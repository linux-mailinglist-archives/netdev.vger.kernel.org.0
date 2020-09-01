Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E0C259F5A
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 21:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730113AbgIATnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 15:43:15 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7777 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726936AbgIATnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 15:43:14 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4ea4240000>; Tue, 01 Sep 2020 12:42:28 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 01 Sep 2020 12:43:14 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 01 Sep 2020 12:43:14 -0700
Received: from [10.21.180.182] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 1 Sep
 2020 19:43:03 +0000
Subject: Re: [PATCH net-next RFC v3 01/14] devlink: Add reload action option
 to devlink reload command
To:     Jiri Pirko <jiri@resnulli.us>, Moshe Shemesh <moshe@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1598801254-27764-1-git-send-email-moshe@mellanox.com>
 <1598801254-27764-2-git-send-email-moshe@mellanox.com>
 <20200831121501.GD3794@nanopsycho.orion>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <9fffbe80-9a2a-33de-2e11-24be34648686@nvidia.com>
Date:   Tue, 1 Sep 2020 22:43:00 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200831121501.GD3794@nanopsycho.orion>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598989348; bh=fioV2m6T3Ck+8PbxdHL9WpHp3iXYPU1RIv/t8Kya0Lo=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:
         Content-Transfer-Encoding:Content-Language:X-Originating-IP:
         X-ClientProxiedBy;
        b=giRndYG39aEvZGFIgAmtIvghB4IjpWNMzJsNas97/qLhk8izfi3HYMn8BTKSnf7q8
         s0ZLfW7iwVoljMW+g1IlAUU9f9NwlsCrtMla0xHdHLb+Rf6g/rwYmCKiRGki01bGcr
         dTNCCVNmmHFfjFefOezpXNLcGarH4pnowBD6CvujHLKyyXgSHzbWeAmK1kyvuNAr45
         zBXoVPIwW0QoBpOBgZpRVZOVim392YpvXmpz/ey8YCfxzDvxZNIQCSMrpvhVBgjCFu
         jZWPj2s1FnkiTJ3hjTZDlSu+8S1x3vipqTZkmsEkulF5ufdSNt+qQLkUfwUTAcD/6a
         RlbEegO50BW9w==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/31/2020 3:15 PM, Jiri Pirko wrote:
> Sun, Aug 30, 2020 at 05:27:21PM CEST, moshe@mellanox.com wrote:
>> Add devlink reload action to allow the user to request a specific reload
>> action. The action parameter is optional, if not specified then devlink
>> driver re-init action is used (backward compatible).
>> Note that when required to do firmware activation some drivers may need
>> to reload the driver. On the other hand some drivers may need to reset
>> the firmware to reinitialize the driver entities. Therefore, the devlink
>> reload command returns the actions which were actually done.
>> However, in case fw_activate_no_reset action is selected, then no other
>> reload action is allowed.
>> Reload actions supported are:
>> driver_reinit: driver entities re-initialization, applying devlink-param
>>                and devlink-resource values.
>> fw_activate: firmware activate.
>> fw_activate_no_reset: Activate new firmware image without any reset.
>>                       (also known as: firmware live patching).
>>
>> command examples:
>> $devlink dev reload pci/0000:82:00.0 action driver_reinit
>> reload_actions_done:
>>   driver_reinit
>>
>> $devlink dev reload pci/0000:82:00.0 action fw_activate
>> reload_actions_done:
>>   driver_reinit fw_activate
>>
>> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
>> ---
>> v2 -> v3:
>> - Replace fw_live_patch action by fw_activate_no_reset
>> - Devlink reload returns the actions done over netlink reply
>> v1 -> v2:
>> - Instead of reload levels driver,fw_reset,fw_live_patch have reload
>>   actions driver_reinit,fw_activate,fw_live_patch
>> - Remove driver default level, the action driver_reinit is the default
>>   action for all drivers
>> ---
> [...]
>
>
>> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
>> index 08d101138fbe..c42b66d88884 100644
>> --- a/drivers/net/ethernet/mellanox/mlxsw/core.c
>> +++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
>> @@ -1113,7 +1113,7 @@ mlxsw_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
>>
>> static int
>> mlxsw_devlink_core_bus_device_reload_down(struct devlink *devlink,
>> -					  bool netns_change,
>> +					  bool netns_change, enum devlink_reload_action action,
>> 					  struct netlink_ext_ack *extack)
>> {
>> 	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
>> @@ -1126,15 +1126,23 @@ mlxsw_devlink_core_bus_device_reload_down(struct devlink *devlink,
>> }
>>
>> static int
>> -mlxsw_devlink_core_bus_device_reload_up(struct devlink *devlink,
>> -					struct netlink_ext_ack *extack)
>> +mlxsw_devlink_core_bus_device_reload_up(struct devlink *devlink, enum devlink_reload_action action,
>> +					struct netlink_ext_ack *extack, unsigned long *actions_done)
>> {
>> 	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
>> +	int err;
>>
>> -	return mlxsw_core_bus_device_register(mlxsw_core->bus_info,
>> -					      mlxsw_core->bus,
>> -					      mlxsw_core->bus_priv, true,
>> -					      devlink, extack);
>> +	err = mlxsw_core_bus_device_register(mlxsw_core->bus_info,
>> +					     mlxsw_core->bus,
>> +					     mlxsw_core->bus_priv, true,
>> +					     devlink, extack);
>> +	if (err)
>> +		return err;
>> +	if (actions_done)
>> +		*actions_done = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
>> +				BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE);
>> +
>> +	return 0;
>> }
>>
>> static int mlxsw_devlink_flash_update(struct devlink *devlink,
>> @@ -1268,6 +1276,8 @@ mlxsw_devlink_trap_policer_counter_get(struct devlink *devlink,
>> }
>>
>> static const struct devlink_ops mlxsw_devlink_ops = {
>> +	.supported_reload_actions	= BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
>> +					  BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
> This is confusing and open to interpretation. Does this mean that the
> driver supports:
> 1) REINIT && FW_ACTIVATE
> 2) REINIT || FW_ACTIVATE
> ?
>
> Because mlxsw supports only 1. I guess that mlx5 supports both. This
> needs to be distinguished.

Mlxsw supports 1, so it supports fw_activation and performs also reinit 
and vice versa.

Mlx5 supports fw_activate and performs also reinit. However, it supports 
reinit without performing fw_activate.

> I think you need an array of combinations. Or perhaps rather to extend
> the enum with combinations. You kind of have it already with
> DEVLINK_RELOAD_ACTION_FW_ACTIVATE_NO_RESET
>
> Maybe we can have something like:
> DEVLINK_RELOAD_ACTION_DRIVER_REINIT
> DEVLINK_RELOAD_ACTION_DRIVER_REINIT_FW_ACTIVATE_RESET
> DEVLINK_RELOAD_ACTION_FW_ACTIVATE_RESET
> DEVLINK_RELOAD_ACTION_FW_ACTIVATE (this is the original FW_ACTIVATE_NO_RESET)

The FW_ACTIVATE_NO_RESET meant also to emphasize that driver 
implementation for this one should not do any reset.

So maybe we can have

DEVLINK_RELOAD_ACTION_FW_ACTIVATE_RESET
DEVLINK_RELOAD_ACTION_FW_ACTIVATE_NO_RESET

> Each has very clear meaning.


Yes, it the driver support here is more clear.

> Also, then the "actions_done" would be a simple enum, directly returned
> to the user. No bitfield needed.


I agree it is more clear on the driver support side, but what about the 
uAPI ? Do we need such change there too or keep it as is, each action by 
itself and return what was performed ?

>
>> 	.reload_down		= mlxsw_devlink_core_bus_device_reload_down,
>> 	.reload_up		= mlxsw_devlink_core_bus_device_reload_up,
>> 	.port_type_set			= mlxsw_devlink_port_type_set,
> [...]
