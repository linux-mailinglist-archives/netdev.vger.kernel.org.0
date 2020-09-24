Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69767277968
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 21:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728790AbgIXTee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 15:34:34 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:11482 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbgIXTee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 15:34:34 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f6cf4bd0000>; Thu, 24 Sep 2020 12:34:21 -0700
Received: from [10.21.180.144] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 24 Sep
 2020 19:34:26 +0000
Subject: Re: [PATCH net-next RFC v5 04/15] devlink: Add reload actions stats
 to dev get
To:     Jakub Kicinski <kuba@kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1600445211-31078-1-git-send-email-moshe@mellanox.com>
 <1600445211-31078-5-git-send-email-moshe@mellanox.com>
 <20200923115004.2392fae6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <b9867778-ff66-7f80-8f89-c63ed90a94e5@nvidia.com>
Date:   Thu, 24 Sep 2020 22:34:23 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200923115004.2392fae6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600976061; bh=vSCckPrlVvrfevaHWYf6u0YDQjZttmUMb9n2QgZlJ8M=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=ENuD78nFqexKoJh4tWcjw5wEK/b73ao4Z/f9zQbbK9g6EDyWRQOZYrl8t5yD5Mcpn
         SXp8fVjM+ITHf4fjvtLk3wCcYXf1SO3xMWsbj5PBx0KN7XYU+H7LiKMFMVtBxTU3DR
         BQDXizrST6kdwsfwnf5TAm8em4tkQzFv4YrDcJ9aUXPGePDqhCxCWVuAu2PzzL+Izm
         QLkrRryQWD+hbAXRnfLZVAcxFk+/RIbF8+Punb9cGHVpQQxJ0/9MA7+jYJSY0rKp39
         hP8yA3ciz0yIR8i1QZ3czk7v6S5/WUHd1jymShKU+YmBawQmSgda9qrmTSNFLv2M84
         9TXWlSUdSGzHA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/23/2020 9:50 PM, Jakub Kicinski wrote:
> On Fri, 18 Sep 2020 19:06:40 +0300 Moshe Shemesh wrote:
>> Expose devlink reload actions stats to the user through devlink dev
>> get command.
>>
>> Examples:
>> $ devlink dev show
>> pci/0000:82:00.0:
>>    stats:
>>        reload_action_stats:
>>          driver_reinit 2
>>          fw_activate 1
>>          fw_activate_no_reset 0
>>          remote_driver_reinit 0
>>          remote_fw_activate 0
>>          remote_fw_activate_no_reset 0
>> pci/0000:82:00.1:
>>    stats:
>>        reload_action_stats:
>>          driver_reinit 0
>>          fw_activate 0
>>          fw_activate_no_reset 0
>>          remote_driver_reinit 1
>>          remote_fw_activate 1
>>          remote_fw_activate_no_reset 0
>>
>> $ devlink dev show -jp
>> {
>>      "dev": {
>>          "pci/0000:82:00.0": {
>>              "stats": {
>>                  "reload_action_stats": [ {
>>                          "driver_reinit": 2
>>                      },{
>>                          "fw_activate": 1
>>                      },{
>>                          "fw_activate_no_reset": 0
>>                      },{
>>                          "remote_driver_reinit": 0
>>                      },{
>>                          "remote_fw_activate": 0
>>                      },{
>>                          "remote_fw_activate_no_reset": 0
>>                      } ]
>>              }
>>          },
>>          "pci/0000:82:00.1": {
>>              "stats": {
>>                  "reload_action_stats": [ {
>>                          "driver_reinit": 0
>>                      },{
>>                          "fw_activate": 0
>>                      },{
>>                          "fw_activate_no_reset": 0
>>                      },{
>>                          "remote_driver_reinit": 1
>>                      },{
>>                          "remote_fw_activate": 1
>>                      },{
>>                          "remote_fw_activate_no_reset": 0
>>                      } ]
>>              }
>>          }
>>      }
>> }
>>
>> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
>> ---
>> v4 -> v5:
>> - Add remote actions stats
>> - If devlink reload is not supported, show only remote_stats
>> v3 -> v4:
>> - Renamed DEVLINK_ATTR_RELOAD_ACTION_CNT to
>>    DEVLINK_ATTR_RELOAD_ACTION_STAT
>> - Add stats per action per limit level
>> v2 -> v3:
>> - Add reload actions counters instead of supported reload actions
>>    (reload actions counters are only for supported action so no need for
>>     both)
>> v1 -> v2:
>> - Removed DEVLINK_ATTR_RELOAD_DEFAULT_LEVEL
>> - Removed DEVLINK_ATTR_RELOAD_LEVELS_INFO
>> - Have actions instead of levels
>> ---
>>   include/uapi/linux/devlink.h |  5 +++
>>   net/core/devlink.c           | 70 ++++++++++++++++++++++++++++++++++++
>>   2 files changed, 75 insertions(+)
>>
>> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>> index 0c5d942dcbd5..648d53be691e 100644
>> --- a/include/uapi/linux/devlink.h
>> +++ b/include/uapi/linux/devlink.h
>> @@ -497,7 +497,12 @@ enum devlink_attr {
>>   	DEVLINK_ATTR_RELOAD_ACTION,		/* u8 */
>>   	DEVLINK_ATTR_RELOAD_ACTIONS_PERFORMED,	/* nested */
>>   	DEVLINK_ATTR_RELOAD_ACTION_LIMIT_LEVEL,	/* u8 */
>> +	DEVLINK_ATTR_RELOAD_ACTION_STATS,	/* nested */
>> +	DEVLINK_ATTR_RELOAD_ACTION_STAT,	/* nested */
>> +	DEVLINK_ATTR_RELOAD_ACTION_STAT_REMOTE,	/* flag */
>> +	DEVLINK_ATTR_RELOAD_ACTION_STAT_VALUE,	/* u32 */
>>   
>> +	DEVLINK_ATTR_DEV_STATS,			/* nested */
>>   	/* add new attributes above here, update the policy in devlink.c */
> I'd propose this nesting:
>
> 	[DEV_STATS]
> 		[RELOAD_STATS]
> 			[DEV_STATS_ENTRY]
> 				[ACTION]
> 				[LIMIT]
> 				[VALUE]
> 			[DEV_STATS_ENTRY]
> 				[...]
> 		[REMOTE_RELOAD_STATS]
> 			[DEV_STATS_ENTRY]
> 				[ACTION]
> 				[LIMIT]
> 				[VALUE]
> 			[DEV_STATS_ENTRY]
> 				[...]
>
> Then you can fill in the inside of the [REMOTE_]RELOAD_STATS nests with
> a helper, and similarly user space can separate the two in JSON more
> cleanly than string concat.


Right, will fix, thanks.

>>   	__DEVLINK_ATTR_MAX,
>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index 1509c2ffb98b..71aeda259e6a 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -501,10 +501,39 @@ devlink_reload_action_limit_level_is_supported(struct devlink *devlink,
>>   	return test_bit(limit_level, &devlink->ops->supported_reload_action_limit_levels);
>>   }
>>   
>> +static int devlink_reload_action_stat_put(struct sk_buff *msg, enum devlink_reload_action action,
>> +					  enum devlink_reload_action_limit_level limit_level,
>> +					  bool is_remote, u32 value)
>> +{
>> +	struct nlattr *reload_action_stat;
>> +
>> +	reload_action_stat = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_ACTION_STAT);
>> +	if (!reload_action_stat)
>> +		return -EMSGSIZE;
>> +
>> +	if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_ACTION, action))
>> +		goto nla_put_failure;
>> +	if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_ACTION_LIMIT_LEVEL, limit_level))
>> +		goto nla_put_failure;
>> +	if (is_remote && nla_put_flag(msg, DEVLINK_ATTR_RELOAD_ACTION_STAT_REMOTE))
>> +		goto nla_put_failure;
>> +	if (nla_put_u32(msg, DEVLINK_ATTR_RELOAD_ACTION_STAT_VALUE, value))
>> +		goto nla_put_failure;
>> +	nla_nest_end(msg, reload_action_stat);
>> +	return 0;
>> +
>> +nla_put_failure:
>> +	nla_nest_cancel(msg, reload_action_stat);
>> +	return -EMSGSIZE;
>> +}
>> +
>>   static int devlink_nl_fill(struct sk_buff *msg, struct devlink *devlink,
>>   			   enum devlink_command cmd, u32 portid,
>>   			   u32 seq, int flags)
>>   {
>> +	struct nlattr *dev_stats, *reload_action_stats;
>> +	int i, j, stat_idx;
>> +	u32 value;
>>   	void *hdr;
>>   
>>   	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
>> @@ -516,9 +545,50 @@ static int devlink_nl_fill(struct sk_buff *msg, struct devlink *devlink,
>>   	if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_FAILED, devlink->reload_failed))
>>   		goto nla_put_failure;
>>   
>> +	dev_stats = nla_nest_start(msg, DEVLINK_ATTR_DEV_STATS);
>> +	if (!dev_stats)
>> +		goto nla_put_failure;
>> +	reload_action_stats = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_ACTION_STATS);
>> +	if (!reload_action_stats)
>> +		goto dev_stats_nest_cancel;
>> +
>> +	for (j = 0; j <= DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX; j++) {
>> +		if (!devlink_reload_action_limit_level_is_supported(devlink, j))
>> +			continue;
>> +		for (i = 0; i <= DEVLINK_RELOAD_ACTION_MAX; i++) {
>> +			if (!devlink_reload_action_is_supported(devlink, i) ||
>> +			    devlink_reload_combination_is_invalid(i, j))
>> +				continue;
>> +
>> +			stat_idx = j * __DEVLINK_RELOAD_ACTION_MAX + i;
>> +			value = devlink->reload_action_stats[stat_idx];
>> +			if (devlink_reload_action_stat_put(msg, i, j, false, value))
>> +				goto reload_action_stats_nest_cancel;
>> +		}
>> +	}
>> +
>> +	for (j = 0; j <= DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX; j++) {
>> +		for (i = 0; i <= DEVLINK_RELOAD_ACTION_MAX; i++) {
>> +			if (i == DEVLINK_RELOAD_ACTION_UNSPEC ||
>> +			    devlink_reload_combination_is_invalid(i, j))
>> +				continue;
>> +
>> +			stat_idx = j * __DEVLINK_RELOAD_ACTION_MAX + i;
>> +			value = devlink->remote_reload_action_stats[stat_idx];
>> +			if (devlink_reload_action_stat_put(msg, i, j, true, value))
>> +				goto reload_action_stats_nest_cancel;
>> +		}
>> +	}
> This calls for a helper.
Ack.
