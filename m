Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 386F6282952
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 09:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725869AbgJDHJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 03:09:30 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15471 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgJDHJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 03:09:29 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f79751c0001>; Sun, 04 Oct 2020 00:09:16 -0700
Received: from [10.21.180.76] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 4 Oct
 2020 07:09:16 +0000
Subject: Re: [PATCH net-next 05/16] devlink: Add remote reload stats
To:     Jiri Pirko <jiri@resnulli.us>, Moshe Shemesh <moshe@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
 <1601560759-11030-6-git-send-email-moshe@mellanox.com>
 <20201003090542.GF3159@nanopsycho.orion>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <9ea0e668-3613-18dc-e1e0-c6dfbd803906@nvidia.com>
Date:   Sun, 4 Oct 2020 10:09:13 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201003090542.GF3159@nanopsycho.orion>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601795356; bh=pSkbc8yxgxfS1GYuuXbddIGvMz9dQZ/zYK37e902fN0=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=g3ECC0mbYkQn5f+Ic2nAJ5GR6GyyVWj1lDJrB9yXmbFVA5tfCyjXxwzmuYAY3KpkX
         UJHg4fjfua3j9MeQiNS7h3FaRtDtwoOArRFZeGr65ySZ7qv09uPDMq9mDnmAa0XhTp
         gmRAInkcynpFe3ytIOWChokHI96NWZN+G/rR+KJtlAMvq+ToRnbBlwHmhbOzXtA8Ay
         p0CSW6OE7kFZ9F2GzEo7KD5poQ0e1kSnLiVRHjhCQ1yPwFHPSYgOgsqSB02Lt1P6CL
         esgS474L8HiPvsg6vnxBqDIIYsgBTROZOKaP+EJlghWmJdNGCVLvpMRhIxX8THRYUz
         WQCvs2+K6p6bQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/3/2020 12:05 PM, Jiri Pirko wrote:
> Thu, Oct 01, 2020 at 03:59:08PM CEST, moshe@mellanox.com wrote:
>> Add remote reload stats to hold the history of actions performed due
>> devlink reload commands initiated by remote host. For example, in case
>> firmware activation with reset finished successfully but was initiated
>> by remote host.
>>
>> The function devlink_remote_reload_actions_performed() is exported to
>> enable drivers update on remote reload actions performed as it was not
>> initiated by their own devlink instance.
>>
>> Expose devlink remote reload stats to the user through devlink dev get
>> command.
>>
>> Examples:
>> $ devlink dev show
>> pci/0000:82:00.0:
>>   stats:
>>       reload_stats:
>>         driver_reinit 2
>>         fw_activate 1
>>         fw_activate_no_reset 0
>>       remote_reload_stats:
>>         driver_reinit 0
>>         fw_activate 0
>>         fw_activate_no_reset 0
>> pci/0000:82:00.1:
>>   stats:
>>       reload_stats:
>>         driver_reinit 1
>>         fw_activate 0
>>         fw_activate_no_reset 0
>>       remote_reload_stats:
>>         driver_reinit 1
>>         fw_activate 1
>>         fw_activate_no_reset 0
>>
>> $ devlink dev show -jp
>> {
>>     "dev": {
>>         "pci/0000:82:00.0": {
>>             "stats": {
>>                 "reload_stats": [ {
>>                         "driver_reinit": 2
>>                     },{
>>                         "fw_activate": 1
>>                     },{
>>                         "fw_activate_no_reset": 0
>>                     } ],
>>                 "remote_reload_stats": [ {
>>                         "driver_reinit": 0
>>                     },{
>>                         "fw_activate": 0
>>                     },{
>>                         "fw_activate_no_reset": 0
>>                     } ]
>>             }
>>         },
>>         "pci/0000:82:00.1": {
>>             "stats": {
>>                 "reload_stats": [ {
>>                         "driver_reinit": 1
>>                     },{
>>                         "fw_activate": 0
>>                     },{
>>                         "fw_activate_no_reset": 0
>>                     } ],
>>                 "remote_reload_stats": [ {
>>                         "driver_reinit": 1
>>                     },{
>>                         "fw_activate": 1
>>                     },{
>>                         "fw_activate_no_reset": 0
>>                     } ]
>>             }
>>         }
>>     }
>> }
>>
>> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
>> ---
>> RFCv5 -> v1:
>> - Resplit this patch and the previous one by remote/local reload stats
>> instead of set/get reload stats
>> - Rename reload_action_stats to reload_stats
>> RFCv4 -> RFCv5:
>> - Add remote actions stats
>> - If devlink reload is not supported, show only remote_stats
>> RFCv3 -> RFCv4:
>> - Renamed DEVLINK_ATTR_RELOAD_ACTION_CNT to
>>   DEVLINK_ATTR_RELOAD_ACTION_STAT
>> - Add stats per action per limit level
>> RFCv2 -> RFCv3:
>> - Add reload actions counters instead of supported reload actions
>>   (reload actions counters are only for supported action so no need for
>>    both)
>> RFCv1 -> RFCv2:
>> - Removed DEVLINK_ATTR_RELOAD_DEFAULT_LEVEL
>> - Removed DEVLINK_ATTR_RELOAD_LEVELS_INFO
>> - Have actions instead of levels
>> ---
>> include/net/devlink.h        |  1 +
>> include/uapi/linux/devlink.h |  1 +
>> net/core/devlink.c           | 49 +++++++++++++++++++++++++++++++-----
>> 3 files changed, 45 insertions(+), 6 deletions(-)
>>
>> diff --git a/include/net/devlink.h b/include/net/devlink.h
>> index 0f3bd23b6c04..a4ccb83bbd2c 100644
>> --- a/include/net/devlink.h
>> +++ b/include/net/devlink.h
>> @@ -42,6 +42,7 @@ struct devlink {
>> 	const struct devlink_ops *ops;
>> 	struct xarray snapshot_ids;
>> 	u32 reload_stats[DEVLINK_RELOAD_STATS_ARRAY_SIZE];
>> +	u32 remote_reload_stats[DEVLINK_RELOAD_STATS_ARRAY_SIZE];
> Perhaps a nested struct  {} stats?
I guess you mean struct that holds these two arrays.
>
>> 	struct device *dev;
>> 	possible_net_t _net;
>> 	struct mutex lock; /* Serializes access to devlink instance specific objects such as
>> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>> index 97e0137f6201..f9887d8afdc7 100644
>> --- a/include/uapi/linux/devlink.h
>> +++ b/include/uapi/linux/devlink.h
>> @@ -530,6 +530,7 @@ enum devlink_attr {
>> 	DEVLINK_ATTR_RELOAD_STATS,		/* nested */
>> 	DEVLINK_ATTR_RELOAD_STATS_ENTRY,	/* nested */
>> 	DEVLINK_ATTR_RELOAD_STATS_VALUE,	/* u32 */
>> +	DEVLINK_ATTR_REMOTE_RELOAD_STATS,	/* nested */
>>
>> 	/* add new attributes above here, update the policy in devlink.c */
>>
>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index 05516f1e4c3e..3b6bd3b4d346 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -523,28 +523,35 @@ static int devlink_reload_stat_put(struct sk_buff *msg, enum devlink_reload_acti
>> 	return -EMSGSIZE;
>> }
>>
>> -static int devlink_reload_stats_put(struct sk_buff *msg, struct devlink *devlink)
>> +static int devlink_reload_stats_put(struct sk_buff *msg, struct devlink *devlink, bool is_remote)
>> {
>> 	struct nlattr *reload_stats_attr;
>> 	int i, j, stat_idx;
>> 	u32 value;
>>
>> -	reload_stats_attr = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_STATS);
>> +	if (!is_remote)
>> +		reload_stats_attr = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_STATS);
>> +	else
>> +		reload_stats_attr = nla_nest_start(msg, DEVLINK_ATTR_REMOTE_RELOAD_STATS);
>>
>> 	if (!reload_stats_attr)
>> 		return -EMSGSIZE;
>>
>> 	for (j = 0; j <= DEVLINK_RELOAD_LIMIT_MAX; j++) {
>> -		if (j != DEVLINK_RELOAD_LIMIT_UNSPEC &&
>> +		if (!is_remote && j != DEVLINK_RELOAD_LIMIT_UNSPEC &&
> I don't follow the check "!is_remote" here,


We agreed that remote stats should be shown also for non supported 
actions and limits, because its remote. So it makes this condition 
different for remote stats. Rethinking about it, maybe that's wrong. I 
mean if we had here reload actions as a result of remote driver, they 
have common device, so it has to be the same type of driver and support 
same actions/limits, right ?

>> 		    !devlink_reload_limit_is_supported(devlink, j))
>> 			continue;
>> 		for (i = 0; i <= DEVLINK_RELOAD_ACTION_MAX; i++) {
>> -			if (!devlink_reload_action_is_supported(devlink, i) ||
>> +			if ((!is_remote && !devlink_reload_action_is_supported(devlink, i)) ||
> and here. Could you perhaps put in a comment to describe what are you
> doing?
>
Yes, similar.
>
>> +			    i == DEVLINK_RELOAD_ACTION_UNSPEC ||
>> 			    devlink_reload_combination_is_invalid(i, j))
>> 				continue;
>>
>> 			stat_idx = j * __DEVLINK_RELOAD_ACTION_MAX + i;
>> -			value = devlink->reload_stats[stat_idx];
>> +			if (!is_remote)
>> +				value = devlink->reload_stats[stat_idx];
>> +			else
>> +				value = devlink->remote_reload_stats[stat_idx];
>> 			if (devlink_reload_stat_put(msg, i, j, value))
>> 				goto nla_put_failure;
>> 		}
>> @@ -577,7 +584,9 @@ static int devlink_nl_fill(struct sk_buff *msg, struct devlink *devlink,
>> 	if (!dev_stats)
>> 		goto nla_put_failure;
>>
>> -	if (devlink_reload_stats_put(msg, devlink))
>> +	if (devlink_reload_stats_put(msg, devlink, false))
>> +		goto dev_stats_nest_cancel;
>> +	if (devlink_reload_stats_put(msg, devlink, true))
>> 		goto dev_stats_nest_cancel;
>>
>> 	nla_nest_end(msg, dev_stats);
>> @@ -3100,15 +3109,40 @@ devlink_reload_stats_update(struct devlink *devlink, enum devlink_reload_limit l
>> 	__devlink_reload_stats_update(devlink, devlink->reload_stats, limit, actions_performed);
>> }
>>
>> +/**
>> + *	devlink_remote_reload_actions_performed - Update devlink on reload actions
>> + *	  performed which are not a direct result of devlink reload call.
>> + *
>> + *	This should be called by a driver after performing reload actions in case it was not
>> + *	a result of devlink reload call. For example fw_activate was performed as a result
>> + *	of devlink reload triggered fw_activate on another host.
>> + *	The motivation for this function is to keep data on reload actions performed on this
>> + *	function whether it was done due to direct devlink reload call or not.
>> + *
>> + *	@devlink: devlink
>> + *	@limit: reload limit
>> + *	@actions_performed: bitmask of actions performed
>> + */
>> +void devlink_remote_reload_actions_performed(struct devlink *devlink,
>> +					     enum devlink_reload_limit limit,
>> +					     unsigned long actions_performed)
>> +{
>> +	__devlink_reload_stats_update(devlink, devlink->remote_reload_stats, limit,
>> +				      actions_performed);
>> +}
>> +EXPORT_SYMBOL_GPL(devlink_remote_reload_actions_performed);
>> +
>> static int devlink_reload(struct devlink *devlink, struct net *dest_net,
>> 			  enum devlink_reload_action action, enum devlink_reload_limit limit,
>> 			  struct netlink_ext_ack *extack, unsigned long *actions_performed)
>> {
>> +	u32 remote_reload_stats[DEVLINK_RELOAD_STATS_ARRAY_SIZE];
>> 	int err;
>>
>> 	if (!devlink->reload_enabled)
>> 		return -EOPNOTSUPP;
>>
>> +	memcpy(remote_reload_stats, devlink->remote_reload_stats, sizeof(remote_reload_stats));
>> 	err = devlink->ops->reload_down(devlink, !!dest_net, action, limit, extack);
>> 	if (err)
>> 		return err;
>> @@ -3122,6 +3156,9 @@ static int devlink_reload(struct devlink *devlink, struct net *dest_net,
>> 		return err;
>>
>> 	WARN_ON(!test_bit(action, actions_performed));
>> +	/* Catch driver on updating the remote action within devlink reload */
>> +	WARN_ON(memcmp(remote_reload_stats, devlink->remote_reload_stats,
>> +		       sizeof(remote_reload_stats)));
>> 	devlink_reload_stats_update(devlink, limit, *actions_performed);
>> 	return 0;
>> }
>> -- 
>> 2.18.2
>>
