Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67ADD27795D
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 21:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728825AbgIXTaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 15:30:12 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:1291 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728217AbgIXTaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 15:30:11 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f6cf3610003>; Thu, 24 Sep 2020 12:28:33 -0700
Received: from [10.21.180.144] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 24 Sep
 2020 19:29:59 +0000
Subject: Re: [PATCH net-next RFC v5 02/15] devlink: Add reload action limit
 level
To:     Jakub Kicinski <kuba@kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1600445211-31078-1-git-send-email-moshe@mellanox.com>
 <1600445211-31078-3-git-send-email-moshe@mellanox.com>
 <20200923113648.7398276d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <13ff51f8-10d8-df3a-048e-cfd8563dc2de@nvidia.com>
Date:   Thu, 24 Sep 2020 22:29:55 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200923113648.7398276d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600975713; bh=e7+MG4wxP5GdZj1BvXqSrzmalXWZIX84OtqN6pMpQ14=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=L45ZXXFiGCzQCgXsdRmDpL8mbuGt+ATmsBcje7CzP7aNBa+Jf8iaaLBJDC2cQ6PFX
         1dgcT1Y8/YJSM5Pg5otNrObV35mNYpsWR5ea7zThQa77+Y96OVZfTGYik9IEcPjahn
         oKnTHOaUsOpE8ryHDuqCAlfkaj2v/eFf069A3wZl2YTuW6uZjegPtQ8v0MRN77mx0h
         h+on8n3F6NCHcwsaKi3d+SngoLCJY1+YK3RGIVOQwVMYjMts+CckU2DLL7YzPe5Qe0
         W8JB+wesnwKmVgHJ/3NakNUx9RSYnDwY0QBAmgsS70HRa4oGreuSedp5saxsckxUww
         oDawjj4Fj8vAQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/23/2020 9:36 PM, Jakub Kicinski wrote:
> On Fri, 18 Sep 2020 19:06:38 +0300 Moshe Shemesh wrote:
>> Add reload action limit level to demand restrictions on actions.
>> Reload action limit levels supported:
>> none (default): No constrains on actions. Driver implementation may
>>                  include reset or downtime as needed to perform the
>>                  actions.
>> no_reset: No reset allowed, no down time allowed, no link flap and no
>>            configuration is lost.
>>
>> Some combinations of action and limit level are invalid. For example,
>> driver can not reinitialize its entities without any downtime.
>>
>> The no_reset limit level will have usecase in this patchset to
>> implement restricted fw_activate on mlx5.
>>
>> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
>> ---
>> v4 -> v5:
>> - Remove check DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX
>> - Added list of invalid action-limit_level combinations and add check to
>>    supported actions and levels and check user request
>> v3 -> v4:
>> - New patch
>> ---
>>   drivers/net/ethernet/mellanox/mlx4/main.c     |  3 +
>>   .../net/ethernet/mellanox/mlx5/core/devlink.c |  3 +
>>   drivers/net/ethernet/mellanox/mlxsw/core.c    |  3 +
>>   drivers/net/netdevsim/dev.c                   |  6 +-
>>   include/net/devlink.h                         |  6 +-
>>   include/uapi/linux/devlink.h                  | 17 +++++
>>   net/core/devlink.c                            | 76 +++++++++++++++++--
>>   7 files changed, 107 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
>> index 1a482120cc0a..f0ef295af477 100644
>> --- a/drivers/net/ethernet/mellanox/mlx4/main.c
>> +++ b/drivers/net/ethernet/mellanox/mlx4/main.c
>> @@ -3947,6 +3947,7 @@ static int mlx4_restart_one_up(struct pci_dev *pdev, bool reload,
>>
>>   static int mlx4_devlink_reload_down(struct devlink *devlink, bool netns_change,
>>                                    enum devlink_reload_action action,
>> +                                 enum devlink_reload_action_limit_level limit_level,
>>                                    struct netlink_ext_ack *extack)
>>   {
>>        struct mlx4_priv *priv = devlink_priv(devlink);
>> @@ -3964,6 +3965,7 @@ static int mlx4_devlink_reload_down(struct devlink *devlink, bool netns_change,
>>   }
>>
>>   static int mlx4_devlink_reload_up(struct devlink *devlink, enum devlink_reload_action action,
>> +                               enum devlink_reload_action_limit_level limit_level,
>>                                  struct netlink_ext_ack *extack, unsigned long *actions_performed)
>>   {
>>        struct mlx4_priv *priv = devlink_priv(devlink);
>> @@ -3985,6 +3987,7 @@ static int mlx4_devlink_reload_up(struct devlink *devlink, enum devlink_reload_a
>>   static const struct devlink_ops mlx4_devlink_ops = {
>>        .port_type_set  = mlx4_devlink_port_type_set,
>>        .supported_reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT),
>> +     .supported_reload_action_limit_levels = BIT(DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NONE),
> Please cut down the name lenghts, this is just lazy.
>
> 'supported_reload_limits' or 'cap_reload_limits' is perfectly
> sufficient.
>
> 'reload_limits' would be even better. Cause what else would it be if
> not a capability.


Sounds good.

So instead of supported_reload_actions_limit_levels will have reload_limits.

Instead of supported_reload_actions will have reload_actions, OK ?

May also use reload_limit_level instead of reload_action_limit_level 
everywhere if its clear enough.

> Besides I don't think drivers should have to fill negative attributes
> (that they don't support something). Everyone is always going to
> support NONE, since it's "unspecified" / "pick your favorite", right?


Good point, will remove it.

>>        .reload_down    = mlx4_devlink_reload_down,
>>        .reload_up      = mlx4_devlink_reload_up,
>>   };
>> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>> index fdba7ab58a79..0c5d942dcbd5 100644
>> --- a/include/uapi/linux/devlink.h
>> +++ b/include/uapi/linux/devlink.h
>> @@ -289,6 +289,22 @@ enum devlink_reload_action {
>>        DEVLINK_RELOAD_ACTION_MAX = __DEVLINK_RELOAD_ACTION_MAX - 1
>>   };
>>
>> +/**
>> + * enum devlink_reload_action_limit_level - Reload action limit level.
>> + * @DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NONE: No constrains on action. Action may include
>> + *                                          reset or downtime as needed.
>> + * @DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NO_RESET: No reset allowed, no down time allowed,
>> + *                                              no link flap and no configuration is lost.
>> + */
>> +enum devlink_reload_action_limit_level {
> You reserved UNSPEC for actions but not for limit level?


Yes, I used LIMIT_LEVEL_NONE = 0 as no limit needed, so I skipped UNSPEC.

Maybe should add UNSPEC and use UNSPEC as no limit needed. But UNSPEC is 
kind of invalid.


>> +     DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NONE,
>> +     DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NO_RESET,
>> +
>> +     /* Add new reload actions limit level above */
>> +     __DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX,
>> +     DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX = __DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX - 1
>> +};
>> +
>>   enum devlink_attr {
>>        /* don't change the order or add anything between, this is ABI! */
>>        DEVLINK_ATTR_UNSPEC,
>> @@ -480,6 +496,7 @@ enum devlink_attr {
>>
>>        DEVLINK_ATTR_RELOAD_ACTION,             /* u8 */
>>        DEVLINK_ATTR_RELOAD_ACTIONS_PERFORMED,  /* nested */
>> +     DEVLINK_ATTR_RELOAD_ACTION_LIMIT_LEVEL, /* u8 */
>>
>>        /* add new attributes above here, update the policy in devlink.c */
>>
>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index 318ef29f81f2..fee6fcc7dead 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -462,12 +462,45 @@ static int devlink_nl_put_handle(struct sk_buff *msg, struct devlink *devlink)
>>        return 0;
>>   }
>>
>> +struct devlink_reload_combination {
>> +     enum devlink_reload_action action;
>> +     enum devlink_reload_action_limit_level limit_level;
>> +};
>> +
>> +static const struct devlink_reload_combination devlink_reload_invalid_combinations[] = {
>> +     {
>> +             /* can't reinitialize driver with no down time */
>> +             .action = DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
>> +             .limit_level = DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NO_RESET,
>> +     },
>> +};
>> +
>> +static bool
>> +devlink_reload_combination_is_invalid(enum devlink_reload_action action,
>> +                                   enum devlink_reload_action_limit_level limit_level)
>> +{
>> +     int i;
>> +
>> +     for (i = 0 ; i <  ARRAY_SIZE(devlink_reload_invalid_combinations) ; i++)
> Whitespace. Did you checkpatch?


Yes, checked it again now, it still pass. I think checkpatch doesn't see 
double space.

But anyway, I missed it, I will fix.

>> +             if (devlink_reload_invalid_combinations[i].action == action &&
>> +                 devlink_reload_invalid_combinations[i].limit_level == limit_level)
>> +                     return true;
>> +     return false;
>> +}
>> +
>>   static bool
>>   devlink_reload_action_is_supported(struct devlink *devlink, enum devlink_reload_action action)
>>   {
>>        return test_bit(action, &devlink->ops->supported_reload_actions);
>>   }
>>
>> +static bool
>> +devlink_reload_action_limit_level_is_supported(struct devlink *devlink,
>> +                                            enum devlink_reload_action_limit_level limit_level)
>> +{
>> +     return test_bit(limit_level, &devlink->ops->supported_reload_action_limit_levels);
>> +}
> This single-use helper just grows LoC and muddies the code IMHO.


It is used again in patch 4.

>
>>   static int devlink_nl_fill(struct sk_buff *msg, struct devlink *devlink,
>>                           enum devlink_command cmd, u32 portid,
>>                           u32 seq, int flags)
>> @@ -2975,22 +3008,23 @@ bool devlink_is_reload_failed(const struct devlink *devlink)
>>   EXPORT_SYMBOL_GPL(devlink_is_reload_failed);
>>
>>   static int devlink_reload(struct devlink *devlink, struct net *dest_net,
>> -                       enum devlink_reload_action action, struct netlink_ext_ack *extack,
>> -                       unsigned long *actions_performed)
>> +                       enum devlink_reload_action action,
>> +                       enum devlink_reload_action_limit_level limit_level,
>> +                       struct netlink_ext_ack *extack, unsigned long *actions_performed)
>>   {
>>        int err;
>>
>>        if (!devlink->reload_enabled)
>>                return -EOPNOTSUPP;
>>
>> -     err = devlink->ops->reload_down(devlink, !!dest_net, action, extack);
>> +     err = devlink->ops->reload_down(devlink, !!dest_net, action, limit_level, extack);
>>        if (err)
>>                return err;
>>
>>        if (dest_net && !net_eq(dest_net, devlink_net(devlink)))
>>                devlink_reload_netns_change(devlink, dest_net);
>>
>> -     err = devlink->ops->reload_up(devlink, action, extack, actions_performed);
>> +     err = devlink->ops->reload_up(devlink, action, limit_level, extack, actions_performed);
>>        devlink_reload_failed_set(devlink, !!err);
>>        if (err)
>>                return err;
>> @@ -3040,6 +3074,7 @@ devlink_nl_reload_actions_performed_fill(struct sk_buff *msg,
>>
>>   static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
>>   {
>> +     enum devlink_reload_action_limit_level limit_level;
>>        struct devlink *devlink = info->user_ptr[0];
>>        enum devlink_reload_action action;
>>        unsigned long actions_performed;
>> @@ -3077,7 +3112,21 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
>>                return -EOPNOTSUPP;
>>        }
>>
>> -     err = devlink_reload(devlink, dest_net, action, info->extack, &actions_performed);
>> +     if (info->attrs[DEVLINK_ATTR_RELOAD_ACTION_LIMIT_LEVEL])
>> +             limit_level = nla_get_u8(info->attrs[DEVLINK_ATTR_RELOAD_ACTION_LIMIT_LEVEL]);
>> +     else
>> +             limit_level = DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NONE;
>> +
>> +     if (!devlink_reload_action_limit_level_is_supported(devlink, limit_level)) {
>> +             NL_SET_ERR_MSG_MOD(info->extack, "Requested limit level is not supported by the driver");
>> +             return -EOPNOTSUPP;
>> +     }
>> +     if (devlink_reload_combination_is_invalid(action, limit_level)) {
>> +             NL_SET_ERR_MSG_MOD(info->extack, "Requested limit level is invalid for this action");
>> +             return -EINVAL;
>> +     }
>> +     err = devlink_reload(devlink, dest_net, action, limit_level, info->extack,
>> +                          &actions_performed);
>>
>>        if (dest_net)
>>                put_net(dest_net);
>> @@ -7154,6 +7203,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
>>        [DEVLINK_ATTR_TRAP_POLICER_BURST] = { .type = NLA_U64 },
>>        [DEVLINK_ATTR_PORT_FUNCTION] = { .type = NLA_NESTED },
>>        [DEVLINK_ATTR_RELOAD_ACTION] = { .type = NLA_U8 },
>> +     [DEVLINK_ATTR_RELOAD_ACTION_LIMIT_LEVEL] = { .type = NLA_U8 },
> range
>
>>   };
>>
>>   static const struct genl_ops devlink_nl_ops[] = {
>> @@ -7489,6 +7539,9 @@ static struct genl_family devlink_nl_family __ro_after_init = {
>>
>>   static bool devlink_reload_actions_valid(const struct devlink_ops *ops)
>>   {
>> +     const struct devlink_reload_combination *comb;
>> +     int i;
>> +
>>        if (!devlink_reload_supported(ops)) {
>>                if (WARN_ON(ops->supported_reload_actions))
>>                        return false;
>> @@ -7498,6 +7551,18 @@ static bool devlink_reload_actions_valid(const struct devlink_ops *ops)
>>        if (WARN_ON(ops->supported_reload_actions >= BIT(__DEVLINK_RELOAD_ACTION_MAX) ||
>>                    ops->supported_reload_actions <= BIT(DEVLINK_RELOAD_ACTION_UNSPEC)))
>>                return false;
>> +
>> +     if (WARN_ON(!ops->supported_reload_action_limit_levels ||
>> +                 ops->supported_reload_action_limit_levels >=
>> +                 BIT(__DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX)))
>> +             return false;
>> +
>> +     for (i = 0; i <  ARRAY_SIZE(devlink_reload_invalid_combinations); i++)  {
> White space, again.
Same double space, I will fix.
>
>> +             comb = &devlink_reload_invalid_combinations[i];
>> +             if (ops->supported_reload_actions == BIT(comb->action) &&
>> +                 ops->supported_reload_action_limit_levels == BIT(comb->limit_level))
>> +                     return false;
>> +     }
>>        return true;
>>   }
>>
>> @@ -9793,6 +9858,7 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
>>                                continue;
>>                        err = devlink_reload(devlink, &init_net,
>>                                             DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
>> +                                          DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NONE,
>>                                             NULL, &actions_performed);
>>                        if (err && err != -EOPNOTSUPP)
>>                                pr_warn("Failed to reload devlink instance into init_net\n");
