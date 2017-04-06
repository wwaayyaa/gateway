local function configure_origin(ngx, conf)
  if conf.origin == nil then
    ngx.header["Access-Control-Allow-Origin"] = "*"
  else
    ngx.header["Access-Control-Allow-Origin"] = conf.origin
    ngx.header["Vary"] = "Origin"
  end
end

local function configure_credentials(ngx, conf)
  if (conf.credentials) then
    ngx.header["Access-Control-Allow-Credentials"] = "true"
  end
end

local function configure_headers(ngx, conf, headers)
  if conf.headers == nil then
    ngx.header["Access-Control-Allow-Headers"] = headers["access-control-request-headers"] or ""
  else
    ngx.header["Access-Control-Allow-Headers"] = table.concat(conf.headers, ",")
  end
end

local function configure_exposed_headers(ngx, conf)
  if conf.exposed_headers ~= nil then
    ngx.header["Access-Control-Expose-Headers"] = table.concat(conf.exposed_headers, ",")
  end
end

local function configure_methods(ngx, conf)
  if conf.methods == nil then
    ngx.header["Access-Control-Allow-Methods"] = "GET,HEAD,PUT,PATCH,POST,DELETE"
  else
    ngx.header["Access-Control-Allow-Methods"] = table.concat(conf.methods, ",")
  end
end

local function configure_max_age(ngx, conf)
  if conf.max_age ~= nil then
    ngx.header["Access-Control-Max-Age"] = tostring(conf.max_age)
  end
end

local function execute(conf)
  configure_origin(ngx, conf)
  configure_credentials(ngx, conf)

  if ngx.req.get_method() == "OPTIONS" then -- Preflight request
    configure_headers(ngx, conf, ngx.req.get_headers())
    configure_methods(ngx, conf)
    configure_max_age(ngx, conf)
  
    return ngx.exit(ngx.HTTP_NO_CONTENT)

  else
    configure_exposed_headers(ngx, conf)
  end
end

--[[

conf = {
  origin,
  credentials,
  headers,
  exposed_headers,
  methods,
  max_age,
  preflight_continue
}

--]]
local conf = {}

execute(conf)
