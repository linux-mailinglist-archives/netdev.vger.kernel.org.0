Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9391526A4DC
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 14:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgIOMQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 08:16:33 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:18821 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbgIOMQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 08:16:19 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f60b0500000>; Tue, 15 Sep 2020 05:15:12 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 15 Sep 2020 05:15:59 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 15 Sep 2020 05:15:59 -0700
Received: from [10.21.180.139] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 15 Sep
 2020 12:15:51 +0000
Subject: Re: [PATCH net-next RFC v4 02/15] devlink: Add reload action limit
 level
To:     Jiri Pirko <jiri@resnulli.us>, Moshe Shemesh <moshe@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
 <1600063682-17313-3-git-send-email-moshe@mellanox.com>
 <20200914131000.GF2236@nanopsycho.orion>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <fd4ee4de-2b42-e3ce-7117-c01f1bb02bbb@nvidia.com>
Date:   Tue, 15 Sep 2020 15:15:48 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200914131000.GF2236@nanopsycho.orion>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600172112; bh=WXPg2iz0Dp9nKjwdOfdEPh3s3owuS083QGKuyHSr25g=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:
         Content-Transfer-Encoding:Content-Language:X-Originating-IP:
         X-ClientProxiedBy;
        b=EzhzQx+UEU+g0BslGiUwmiY1fFUwSh29W6+hEaozt511ZAlXsXaYB9NTyfqsv9v3u
         EGbMgcwGVW24jfLfSYX+kNpi63qxq5xefB03Q8MyZl9vClMeLvVpwQhR3qQ5EqC3mj
         dlUXZH6Vj+Nsd+LgRQKQU0CKVEj1GsddmIjQpsl84xUpQvEbUyN7d5RhLdD6oEkPKi
         8olAu/tTop81ghKIMvW2+T3PCdv2KLHvj2NwB1Wg02WCy/1FwI2jAvQHa2Hxqo9njB
         bfEKuWIxEVG+2EwrYr4j9G+1FANDFAv0YnCS+wde/HNPHqtiuOdAHVNrsc/zpUTPpF
         HFIIAAa8sIoyA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/14/2020 4:10 PM, Jiri Pirko wrote:
> Mon, Sep 14, 2020 at 08:07:49AM CEST, moshe@mellanox.com wrote:
> 		
> [..]
>
> 	
>> diff --git a/include/net/devlink.h b/include/net/devlink.h
>> index b09db891db04..dddd9ee5b8a9 100644
>> --- a/include/net/devlink.h
>> +++ b/include/net/devlink.h
>> @@ -1012,9 +1012,13 @@ enum devlink_trap_group_generic_id {
>>
>> struct devlink_ops {
>> 	unsigned long supported_reload_actions;
>> +	unsigned long supported_reload_action_limit_levels;
>> 	int (*reload_down)(struct devlink *devlink, bool netns_change,
>> -			   enum devlink_reload_action action, struct netlink_ext_ack *extack);
>> +			   enum devlink_reload_action action,
>> +			   enum devlink_reload_action_limit_level limit_level,
>> +			   struct netlink_ext_ack *extack);
>> 	int (*reload_up)(struct devlink *devlink, enum devlink_reload_action action,
>> +			 enum devlink_reload_action_limit_level limit_level,
>> 			 struct netlink_ext_ack *extack, unsigned long *actions_performed);
>> 	int (*port_type_set)(struct devlink_port *devlink_port,
>> 			     enum devlink_port_type port_type);
>> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>> index a6f64db0bdf3..b19686fd80ff 100644
>> --- a/include/uapi/linux/devlink.h
>> +++ b/include/uapi/linux/devlink.h
>> @@ -287,6 +287,22 @@ enum devlink_reload_action {
>> 	DEVLINK_RELOAD_ACTION_MAX = __DEVLINK_RELOAD_ACTION_MAX - 1
>> };
>>
>> +/**
>> + * enum devlink_reload_action_limit_level - Reload action limit level.
>> + * @DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NONE: No constrains on action. Action may include
>> + *                                          reset or downtime as needed.
>> + * @DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NO_RESET: No reset allowed, no down time allowed,
>> + *                                              no link flap and no configuration is lost.
>> + */
>> +enum devlink_reload_action_limit_level {
>> +	DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NONE,
>> +	DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NO_RESET,
>> +
>> +	/* Add new reload actions limit level above */
>> +	__DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX,
>> +	DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX = __DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX - 1
>> +};
>> +
>> enum devlink_attr {
>> 	/* don't change the order or add anything between, this is ABI! */
>> 	DEVLINK_ATTR_UNSPEC,
>> @@ -478,6 +494,7 @@ enum devlink_attr {
>>
>> 	DEVLINK_ATTR_RELOAD_ACTION,		/* u8 */
>> 	DEVLINK_ATTR_RELOAD_ACTIONS_PERFORMED,	/* nested */
>> +	DEVLINK_ATTR_RELOAD_ACTION_LIMIT_LEVEL,	/* u8 */
>>
>> 	/* add new attributes above here, update the policy in devlink.c */
>>
>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index f4be1e1bf864..60aa0c4a3726 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -468,6 +468,13 @@ devlink_reload_action_is_supported(struct devlink *devlink, enum devlink_reload_
>> 	return test_bit(action, &devlink->ops->supported_reload_actions);
>> }
>>
>> +static bool
>> +devlink_reload_action_limit_level_is_supported(struct devlink *devlink,
>> +					       enum devlink_reload_action_limit_level limit_level)
>> +{
>> +	return test_bit(limit_level, &devlink->ops->supported_reload_action_limit_levels);
>> +}
>> +
>> static int devlink_nl_fill(struct sk_buff *msg, struct devlink *devlink,
>> 			   enum devlink_command cmd, u32 portid,
>> 			   u32 seq, int flags)
>> @@ -2975,22 +2982,23 @@ bool devlink_is_reload_failed(const struct devlink *devlink)
>> EXPORT_SYMBOL_GPL(devlink_is_reload_failed);
>>
>> static int devlink_reload(struct devlink *devlink, struct net *dest_net,
>> -			  enum devlink_reload_action action, struct netlink_ext_ack *extack,
>> -			  unsigned long *actions_performed)
>> +			  enum devlink_reload_action action,
>> +			  enum devlink_reload_action_limit_level limit_level,
>> +			  struct netlink_ext_ack *extack, unsigned long *actions_performed)
>> {
>> 	int err;
>>
>> 	if (!devlink->reload_enabled)
>> 		return -EOPNOTSUPP;
>>
>> -	err = devlink->ops->reload_down(devlink, !!dest_net, action, extack);
>> +	err = devlink->ops->reload_down(devlink, !!dest_net, action, limit_level, extack);
>> 	if (err)
>> 		return err;
>>
>> 	if (dest_net && !net_eq(dest_net, devlink_net(devlink)))
>> 		devlink_reload_netns_change(devlink, dest_net);
>>
>> -	err = devlink->ops->reload_up(devlink, action, extack, actions_performed);
>> +	err = devlink->ops->reload_up(devlink, action, limit_level, extack, actions_performed);
>> 	devlink_reload_failed_set(devlink, !!err);
>> 	return err;
>> }
>> @@ -3036,6 +3044,7 @@ devlink_nl_reload_actions_performed_fill(struct sk_buff *msg,
>>
>> static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
>> {
>> +	enum devlink_reload_action_limit_level limit_level;
>> 	struct devlink *devlink = info->user_ptr[0];
>> 	enum devlink_reload_action action;
>> 	unsigned long actions_performed;
>> @@ -3073,7 +3082,20 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
>> 		return -EOPNOTSUPP;
>> 	}
>>
>> -	err = devlink_reload(devlink, dest_net, action, info->extack, &actions_performed);
>> +	if (info->attrs[DEVLINK_ATTR_RELOAD_ACTION_LIMIT_LEVEL])
>> +		limit_level = nla_get_u8(info->attrs[DEVLINK_ATTR_RELOAD_ACTION_LIMIT_LEVEL]);
>> +	else
>> +		limit_level = DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NONE;
>> +
>> +	if (limit_level > DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX) {
> Again, not needed, devlink_reload_action_limit_level_is_supported() will
> take case of it.
Ack.
>> +		NL_SET_ERR_MSG_MOD(info->extack, "Invalid limit level");
>> +		return -EINVAL;
>> +	} else if (!devlink_reload_action_limit_level_is_supported(devlink, limit_level)) {
>> +		NL_SET_ERR_MSG_MOD(info->extack, "Requested limit level is not supported");
> "..by the driver"?
Ack.
>
>> +		return -EOPNOTSUPP;
>> +	}
>> +	err = devlink_reload(devlink, dest_net, action, limit_level, info->extack,
>> +			     &actions_performed);
>>
>> 	if (dest_net)
>> 		put_net(dest_net);
>> @@ -7126,6 +7148,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
>> 	[DEVLINK_ATTR_TRAP_POLICER_BURST] = { .type = NLA_U64 },
>> 	[DEVLINK_ATTR_PORT_FUNCTION] = { .type = NLA_NESTED },
>> 	[DEVLINK_ATTR_RELOAD_ACTION] = { .type = NLA_U8 },
>> +	[DEVLINK_ATTR_RELOAD_ACTION_LIMIT_LEVEL] = { .type = NLA_U8 },
>> };
>>
>> static const struct genl_ops devlink_nl_ops[] = {
>> @@ -7462,6 +7485,10 @@ static int devlink_reload_actions_verify(struct devlink *devlink)
>> 	if (WARN_ON(ops->supported_reload_actions >= BIT(__DEVLINK_RELOAD_ACTION_MAX) ||
>> 		    ops->supported_reload_actions <= BIT(DEVLINK_RELOAD_ACTION_UNSPEC)))
>> 		return -EINVAL;
>> +	if (WARN_ON(!ops->supported_reload_action_limit_levels ||
>> +		    ops->supported_reload_action_limit_levels >=
>> +		    BIT(__DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX)))
>> +		return -EINVAL;
> I think that you can check some insane driver combinations like:
> supports only driver-reinit, supports LEVEL_NO_RESET - that is
> impossible and should be refused here.
>
> Same goes to the actual user command call. If the user calls for
> driver-reinit with LEVEL_NO_RESET, devlink should refuse with proper
> extack


I actually holds a counter for this combination too, we said no_reset 
can apply to any action, but not really.

>
>> 	return 0;
>> }
>>
>> @@ -9756,7 +9783,8 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
>> 			if (WARN_ON(!devlink_reload_supported(devlink)))
>> 				continue;
>> 			err = devlink_reload(devlink, &init_net,
>> -					     DEVLINK_RELOAD_ACTION_DRIVER_REINIT, NULL, NULL);
>> +					     DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
>> +					     DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NONE, NULL, NULL);
>> 			if (err && err != -EOPNOTSUPP)
>> 				pr_warn("Failed to reload devlink instance into init_net\n");
>> 		}
>> -- 
>> 2.17.1
>>
