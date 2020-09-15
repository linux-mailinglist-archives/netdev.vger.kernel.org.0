Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E96C26A538
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 14:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgIOMas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 08:30:48 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:1512 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgIOMag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 08:30:36 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f60b35d0002>; Tue, 15 Sep 2020 05:28:13 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 15 Sep 2020 05:30:34 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 15 Sep 2020 05:30:34 -0700
Received: from [10.21.180.139] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 15 Sep
 2020 12:30:23 +0000
Subject: Re: [PATCH net-next RFC v4 03/15] devlink: Add reload action stats
To:     Jiri Pirko <jiri@resnulli.us>, Moshe Shemesh <moshe@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
 <1600063682-17313-4-git-send-email-moshe@mellanox.com>
 <20200914133939.GG2236@nanopsycho.orion>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <a5b7cbd5-ef55-1d74-a21e-5fb962307773@nvidia.com>
Date:   Tue, 15 Sep 2020 15:30:19 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200914133939.GG2236@nanopsycho.orion>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600172893; bh=wIvW7UIrQndM0XlXBjjsCH83SPYyOAeA0mMRVWlGWX0=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:
         Content-Transfer-Encoding:Content-Language:X-Originating-IP:
         X-ClientProxiedBy;
        b=qjkcrXr/2VudSoYDoMJIHIOZ02vb9k3/Zg4sYkeQ46c7oFm2P45FTJId2GlpsNrgp
         rrET2G06Ml4edtq457swxzffSvKyzMOQVhfKfif4NY+rEgElFV5HTllR6kGv+0Lim+
         ZUgaQtSiZAzhVp4666AiV0gKl9jO407iUo//3IshWjq+t4pHhsW4HAypZaUkaM7oqs
         ZMyZZOxOYAp1JpfLDV2azI6FfZMohBYpP2Zzj2O8Yvhp5wmce9Z56JgOQeIOLz5r6q
         r59M/9UR2RNqBrzEMmqclrcjSoEL9pdZeDwgzcFG4w/MySaYkwubLLzxXhEbQFV9P9
         tAlr9HQPdbJbg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/14/2020 4:39 PM, Jiri Pirko wrote:
> Mon, Sep 14, 2020 at 08:07:50AM CEST, moshe@mellanox.com wrote:
>> Add reload action stats to hold the history per reload action type and
>> limit level.
> Empty line missing.
>

Ack.

>> For example, the number of times fw_activate has been performed on this
>> device since the driver module was added or if the firmware activation
>> was performed with or without reset.
>> Add devlink notification on stats update.
>>
>> The function devlink_reload_actions_implicit_actions_performed() is
>> exported to enable also drivers update on reload actions performed,
>> for example in case firmware activation with reset finished
>> successfully but was initiated by remote host.
>>
>> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
>> ---
>> v3 -> v4:
>> - Renamed reload_actions_cnts to reload_action_stats
>> - Add devlink notifications on stats update
>> - Renamed devlink_reload_actions_implicit_actions_performed() and add
>>   function comment in code
>> v2 -> v3:
>> - New patch
>> ---
>> include/net/devlink.h |  7 ++++++
>> net/core/devlink.c    | 58 ++++++++++++++++++++++++++++++++++++++++---
>> 2 files changed, 62 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/net/devlink.h b/include/net/devlink.h
>> index dddd9ee5b8a9..b4feb92e0269 100644
>> --- a/include/net/devlink.h
>> +++ b/include/net/devlink.h
>> @@ -20,6 +20,9 @@
>> #include <uapi/linux/devlink.h>
>> #include <linux/xarray.h>
>>
>> +#define DEVLINK_RELOAD_ACTION_STATS_ARRAY_SIZE \
>> +	(__DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX * __DEVLINK_RELOAD_ACTION_MAX)
>> +
>> struct devlink_ops;
>>
>> struct devlink {
>> @@ -38,6 +41,7 @@ struct devlink {
>> 	struct list_head trap_policer_list;
>> 	const struct devlink_ops *ops;
>> 	struct xarray snapshot_ids;
>> +	u32 reload_action_stats[DEVLINK_RELOAD_ACTION_STATS_ARRAY_SIZE];
>> 	struct device *dev;
>> 	possible_net_t _net;
>> 	struct mutex lock; /* Serializes access to devlink instance specific objects such as
>> @@ -1397,6 +1401,9 @@ void
>> devlink_health_reporter_recovery_done(struct devlink_health_reporter *reporter);
>>
>> bool devlink_is_reload_failed(const struct devlink *devlink);
>> +void devlink_reload_implicit_actions_performed(struct devlink *devlink,
>> +					       enum devlink_reload_action_limit_level limit_level,
>> +					       unsigned long actions_performed);
>>
>> void devlink_flash_update_begin_notify(struct devlink *devlink);
>> void devlink_flash_update_end_notify(struct devlink *devlink);
>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index 60aa0c4a3726..cbf746966913 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -2981,11 +2981,58 @@ bool devlink_is_reload_failed(const struct devlink *devlink)
>> }
>> EXPORT_SYMBOL_GPL(devlink_is_reload_failed);
>>
>> +static void
>> +devlink_reload_action_stats_update(struct devlink *devlink,
>> +				   enum devlink_reload_action_limit_level limit_level,
>> +				   unsigned long actions_performed)
>> +{
>> +	int stat_idx;
>> +	int action;
>> +
>> +	if (!actions_performed)
>> +		return;
>> +
>> +	if (WARN_ON(limit_level > DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX))
>> +		return;
>> +	for (action = 0; action <= DEVLINK_RELOAD_ACTION_MAX; action++) {
>> +		if (!test_bit(action, &actions_performed))
>> +			continue;
>> +		stat_idx = limit_level * __DEVLINK_RELOAD_ACTION_MAX + action;
>> +		devlink->reload_action_stats[stat_idx]++;
>> +	}
>> +	devlink_notify(devlink, DEVLINK_CMD_NEW);
>> +}
>> +
>> +/**
>> + *	devlink_reload_implicit_actions_performed - Update devlink on reload actions
>> + *	  performed which are not a direct result of devlink reload call.
>> + *
>> + *	This should be called by a driver after performing reload actions in case it was not
>> + *	a result of devlink reload call. For example fw_activate was performed as a result
>> + *	of devlink reload triggered fw_activate on another host.
>> + *	The motivation for this function is to keep data on reload actions performed on this
>> + *	function whether it was done due to direct devlink reload call or not.
>> + *
>> + *	@devlink: devlink
>> + *	@limit_level: reload action limit level
>> + *	@actions_performed: bitmask of actions performed
>> + */
>> +void devlink_reload_implicit_actions_performed(struct devlink *devlink,
>> +					       enum devlink_reload_action_limit_level limit_level,
>> +					       unsigned long actions_performed)
> What I'm a bit scarred of that the driver would call this from withing
> reload_down()/up() ops. Perheps this could be WARN_ON'ed here (or in
> devlink_reload())?
>

Not sure how I know if it was called from devlink_reload_down()/up() ? 
Maybe mutex ? So the warn will be actually mutex deadlock ?

>> +{
>> +	if (!devlink_reload_supported(devlink))
> Hmm. I think that the driver does not have to support the reload and can
> still be reloaded by another instance and update the stats here. Why
> not?
>

But I show counters only for supported reload actions and levels, 
otherwise we will have these counters on devlink dev show output for 
other drivers that don't have support for devlink reload and didn't 
implement any of these including this function and these drivers may do 
some actions like fw_activate in another way and don't update the stats 
and so that will make these stats misleading. They will show history 
"stats" but they don't update them as they didn't apply anything related 
to devlink reload.

>> +		return;
>> +	devlink_reload_action_stats_update(devlink, limit_level, actions_performed);
>> +}
>> +EXPORT_SYMBOL_GPL(devlink_reload_implicit_actions_performed);
>> +
>> static int devlink_reload(struct devlink *devlink, struct net *dest_net,
>> 			  enum devlink_reload_action action,
>> 			  enum devlink_reload_action_limit_level limit_level,
>> -			  struct netlink_ext_ack *extack, unsigned long *actions_performed)
>> +			  struct netlink_ext_ack *extack, unsigned long *actions_performed_out)
>> {
>> +	unsigned long actions_performed;
>> 	int err;
>>
>> 	if (!devlink->reload_enabled)
>> @@ -2998,9 +3045,14 @@ static int devlink_reload(struct devlink *devlink, struct net *dest_net,
>> 	if (dest_net && !net_eq(dest_net, devlink_net(devlink)))
>> 		devlink_reload_netns_change(devlink, dest_net);
>>
>> -	err = devlink->ops->reload_up(devlink, action, limit_level, extack, actions_performed);
>> +	err = devlink->ops->reload_up(devlink, action, limit_level, extack, &actions_performed);
>> 	devlink_reload_failed_set(devlink, !!err);
>> -	return err;
>> +	if (err)
>> +		return err;
>> +	devlink_reload_action_stats_update(devlink, limit_level, actions_performed);
>> +	if (actions_performed_out)
> Just make the caller to provide valid pointer, as I suggested in the
> other patch review.


Ack.

>
>> +		*actions_performed_out = actions_performed;
>> +	return 0;
>> }
>>
>> static int
>> -- 
>> 2.17.1
>>
