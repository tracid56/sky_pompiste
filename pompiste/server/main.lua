ESX                = nil
local Playersrecolt = {}
local Playersdisti = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'pompiste', -1)
end

TriggerEvent('esx_society:registerSociety', 'pompiste', 'Pompiste', 'society_pompiste', 'society_pompiste', 'society_pompiste', {type = 'private'})

local function Distil(source) 

  SetTimeout(Config.TimeToDistil, function()
		if Playersdisti[source] == true then

		local _source = source
		local xPlayer = ESX.GetPlayerFromId(_source)
		local job = xPlayer["job"]["name"]

		local Quantity = xPlayer.getInventoryItem('petrole').count

		if Quantity <= Config.ItemDistiled then
		  TriggerClientEvent('esx:showNotification', _source, '~r~Vous n\'avez plus de pétrol brut à distiller.')
		  Playersdisti[_source] = false
		else
				 xPlayer.removeInventoryItem('petrole', Config.ItemDistiled)
				 xPlayer.addInventoryItem('essence', math.floor(Config.ItemDistiled/2))
				 TriggerClientEvent('esx:showNotification', _source, 'Vous avez distillé '.. Config.ItemDistiled ..' de pétrol brut.')
				 Distil(_source)
		end

	  end
	end)
end

local function Recolting(source) 

  SetTimeout(Config.TimeToRecolte, function()
		if Playersrecolt[source] == true then
		local _source = source
		local xPlayer = ESX.GetPlayerFromId(_source)
				 Recolting(_source)
			else
				TriggerClientEvent('esx:showNotification', _source, 'Vous n\'avez pas assez de place sur vous.')
			end
		TriggerClientEvent('esx:showNotification', _source, 'Vous avez récolté '.. Config.ItemRecolte ..' de pétrol brut.')
		Recolting(_source)
	  end
	end)
end

RegisterServerEvent('pompiste:disti')
AddEventHandler('pompiste:disti', function()
	local _source = source
	if Playersdisti[_source] == false then
	  TriggerClientEvent('esx:showNotification', _source, '~r~Sortez et revenez dans la zone !')
	  Playersdisti[_source] = false
	else
	  Playersdisti[_source] = true
	  TriggerClientEvent('esx:showNotification', _source, '~g~Action ~w~en cours...')
	  Distil(_source)
	end
end)

RegisterServerEvent('pompiste:recolte')
AddEventHandler('pompiste:recolte', function()
	local _source = source
	if Playersrecolt[_source] == false then
	  TriggerClientEvent('esx:showNotification', _source, '~r~Sortez et revenez dans la zone !')
	  Playersrecolt[_source] = false
	else
	  Playersrecolt[_source] = true
	  TriggerClientEvent('esx:showNotification', _source, '~g~Action ~w~en cours...')
	  Recolting(_source)
	end
end)

RegisterServerEvent('pompiste:stopDisti')
AddEventHandler('pompiste:stopDisti', function()

local _source = source

if Playersdisti[_source] == true then
  Playersdisti[_source] = false
else
  Playersdisti[_source] = true
end
end)

RegisterServerEvent('pompiste:stopReco')
AddEventHandler('pompiste:stopReco', function()

local _source = source

if Playersrecolt[_source] == true then
  Playersrecolt[_source] = false
else
  Playersrecolt[_source] = true
end
end)
