Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4272628660D
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 19:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbgJGRf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 13:35:58 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:19705 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728456AbgJGRf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 13:35:57 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7dfc700000>; Wed, 07 Oct 2020 10:35:44 -0700
Received: from [10.21.180.212] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 7 Oct
 2020 17:35:40 +0000
Subject: Re: [PATCH net-next v2 03/16] devlink: Add devlink reload limit
 option
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Moshe Shemesh <moshe@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1602050457-21700-1-git-send-email-moshe@mellanox.com>
 <1602050457-21700-4-git-send-email-moshe@mellanox.com>
 <CAACQVJo6soxxy-xMF0pWtBFBTqkipp7Yri1XJJUiwnBo-_yJDg@mail.gmail.com>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <ff839778-ef05-9f59-b0e7-600b9ba2ac59@nvidia.com>
Date:   Wed, 7 Oct 2020 20:35:36 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CAACQVJo6soxxy-xMF0pWtBFBTqkipp7Yri1XJJUiwnBo-_yJDg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602092144; bh=/WaMxdIqwW7xcI+ZDVVkYbuSCeMdQ7Q0vR4cq2/OXMA=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=SqqFyBvevVd/HZPq3EqD3JmSj9QZfs+OUgWuIbv2ipFVx9TJ/4wB6N/94BLhuYcTG
         STWSZz0QXOdHTp8qrYX4ZEcfF+e1U4vk1w8ovyiuDGCFfHq/Hj7wPDIaFaYetiwXDq
         Yn6rHufPh7sMkQlKEfhtI3M72DtF47txkL4Un6OcnJTyTVLnlOhl9ysQ/w94gbxeCZ
         fkZDRFrDWApY9pX1ZDu1yP1cJCOjfjhcio/Z/FAz6shDmoQhhEz19PdVdNaHNrqW/6
         T1789tGZFt//UVpKWQRNtaXhWalqay/ZjgHZIfbPgUQ+2riftEI43vfPY00/i+0Pwu
         64k+EW5WKowwg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/7/2020 3:41 PM, Vasundhara Volam wrote:
> On Wed, Oct 7, 2020 at 11:32 AM Moshe Shemesh <moshe@mellanox.com> wrote:
>> Add reload limit to demand restrictions on reload actions.
>> Reload limits supported:
>> no_reset: No reset allowed, no down time allowed, no link flap and no
>>            configuration is lost.
>>
>> By default reload limit is unspecified and so no constraints on reload
>> actions are required.
>>
>> Some combinations of action and limit are invalid. For example, driver
>> can not reinitialize its entities without any downtime.
>>
>> The no_reset reload limit will have usecase in this patchset to
>> implement restricted fw_activate on mlx5.
>>
>> Have the uapi parameter of reload limit ready for future support of
>> multiselection.
>>
>> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
>> ---
>> v1 -> v2:
>> - Changed limit uapi parameter to bitfield32 for future support of
>>    multiselection
>> - Fixed reverse xmas tree
>> RFCv5 -> v1:
>> - Renamed supported_reload_actions_limit_levels to reload_limits
>> - Renamed reload_action_limit_level to reload_limit
>> - Change RELOAD_LIMIT_NONE to unspecified RELOAD_LIMIT_UNSPEC,
>>    drivers don't need to declare support limits if they support only
>>    no limitation
>> - Use nla_poilcy range validation and remove the range check in
>> devlink_nl_cmd_reload
>> RFCv4 -> RFCv5:
>> - Remove check DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX
>> - Added list of invalid action-limit_level combinations and add check to
>>    supported actions and levels and check user request
>> RFCv3 -> RFCv4:
>> - New patch
>> ---
>>   drivers/net/ethernet/mellanox/mlx4/main.c     |  4 +-
>>   .../net/ethernet/mellanox/mlx5/core/devlink.c |  4 +-
>>   drivers/net/ethernet/mellanox/mlxsw/core.c    |  4 +-
>>   drivers/net/netdevsim/dev.c                   |  6 +-
>>   include/net/devlink.h                         |  8 +-
>>   include/uapi/linux/devlink.h                  | 14 +++
>>   net/core/devlink.c                            | 92 +++++++++++++++++--
>>   7 files changed, 119 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
>> index 649c5323cf9f..c326b434734e 100644
>> --- a/drivers/net/ethernet/mellanox/mlx4/main.c
>> +++ b/drivers/net/ethernet/mellanox/mlx4/main.c
>> @@ -3947,6 +3947,7 @@ static int mlx4_restart_one_up(struct pci_dev *pdev, bool reload,
>>
>>   static int mlx4_devlink_reload_down(struct devlink *devlink, bool netns_change,
>>                                      enum devlink_reload_action action,
>> +                                   enum devlink_reload_limit limit,
>>                                      struct netlink_ext_ack *extack)
>>   {
>>          struct mlx4_priv *priv = devlink_priv(devlink);
> I don't see any check for limit. If users provide a limit that is not
> supported by the driver, it seems to be simply ignored. Is it checked
> somewhere else?
>

It is checked by devlink, see devlink_nl_cmd_reload() below.

Note that mlx4 here supports only actions with no limits, so it doesn't 
register any limit (see change log RFCv5 -> v1). If user will request a 
limit for this driver devlink will catch it.

>> @@ -3964,7 +3965,8 @@ static int mlx4_devlink_reload_down(struct devlink *devlink, bool netns_change,
>>   }
>>
>>   static int mlx4_devlink_reload_up(struct devlink *devlink, enum devlink_reload_action action,
>> -                                 u32 *actions_performed, struct netlink_ext_ack *extack)
>> +                                 enum devlink_reload_limit limit, u32 *actions_performed,
>> +                                 struct netlink_ext_ack *extack)
>>   {
>>          struct mlx4_priv *priv = devlink_priv(devlink);
>>          struct mlx4_dev *dev = &priv->dev;
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
>> index 1b248c01a209..0016041e8779 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
>> @@ -86,6 +86,7 @@ mlx5_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
>>
>>   static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
>>                                      enum devlink_reload_action action,
>> +                                   enum devlink_reload_limit limit,
>>                                      struct netlink_ext_ack *extack)
>>   {
>>          struct mlx5_core_dev *dev = devlink_priv(devlink);
>> @@ -95,7 +96,8 @@ static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
>>   }
>>
>>   static int mlx5_devlink_reload_up(struct devlink *devlink, enum devlink_reload_action action,
>> -                                 u32 *actions_performed, struct netlink_ext_ack *extack)
>> +                                 enum devlink_reload_limit limit, u32 *actions_performed,
>> +                                 struct netlink_ext_ack *extack)
>>   {
>>          struct mlx5_core_dev *dev = devlink_priv(devlink);
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
>> index cd9f56c73827..7f77c2a71d1c 100644
>> --- a/drivers/net/ethernet/mellanox/mlxsw/core.c
>> +++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
>> @@ -1415,6 +1415,7 @@ mlxsw_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
>>   static int
>>   mlxsw_devlink_core_bus_device_reload_down(struct devlink *devlink,
>>                                            bool netns_change, enum devlink_reload_action action,
>> +                                         enum devlink_reload_limit limit,
>>                                            struct netlink_ext_ack *extack)
>>   {
>>          struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
>> @@ -1428,7 +1429,8 @@ mlxsw_devlink_core_bus_device_reload_down(struct devlink *devlink,
>>
>>   static int
>>   mlxsw_devlink_core_bus_device_reload_up(struct devlink *devlink, enum devlink_reload_action action,
>> -                                       u32 *actions_performed, struct netlink_ext_ack *extack)
>> +                                       enum devlink_reload_limit limit, u32 *actions_performed,
>> +                                       struct netlink_ext_ack *extack)
>>   {
>>          struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
>>
>> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
>> index b57e35c4ef6f..d07061417675 100644
>> --- a/drivers/net/netdevsim/dev.c
>> +++ b/drivers/net/netdevsim/dev.c
>> @@ -701,7 +701,8 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
>>   static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev);
>>
>>   static int nsim_dev_reload_down(struct devlink *devlink, bool netns_change,
>> -                               enum devlink_reload_action action, struct netlink_ext_ack *extack)
>> +                               enum devlink_reload_action action, enum devlink_reload_limit limit,
>> +                               struct netlink_ext_ack *extack)
>>   {
>>          struct nsim_dev *nsim_dev = devlink_priv(devlink);
>>
>> @@ -718,7 +719,8 @@ static int nsim_dev_reload_down(struct devlink *devlink, bool netns_change,
>>   }
>>
>>   static int nsim_dev_reload_up(struct devlink *devlink, enum devlink_reload_action action,
>> -                             u32 *actions_performed, struct netlink_ext_ack *extack)
>> +                             enum devlink_reload_limit limit, u32 *actions_performed,
>> +                             struct netlink_ext_ack *extack)
>>   {
>>          struct nsim_dev *nsim_dev = devlink_priv(devlink);
>>
>> diff --git a/include/net/devlink.h b/include/net/devlink.h
>> index 93c535ae5a4b..9f5c37c391f8 100644
>> --- a/include/net/devlink.h
>> +++ b/include/net/devlink.h
>> @@ -1151,10 +1151,14 @@ struct devlink_ops {
>>           */
>>          u32 supported_flash_update_params;
>>          unsigned long reload_actions;
>> +       unsigned long reload_limits;
>>          int (*reload_down)(struct devlink *devlink, bool netns_change,
>> -                          enum devlink_reload_action action, struct netlink_ext_ack *extack);
>> +                          enum devlink_reload_action action,
>> +                          enum devlink_reload_limit limit,
>> +                          struct netlink_ext_ack *extack);
>>          int (*reload_up)(struct devlink *devlink, enum devlink_reload_action action,
>> -                        u32 *actions_performed, struct netlink_ext_ack *extack);
>> +                        enum devlink_reload_limit limit, u32 *actions_performed,
>> +                        struct netlink_ext_ack *extack);
>>          int (*port_type_set)(struct devlink_port *devlink_port,
>>                               enum devlink_port_type port_type);
>>          int (*port_split)(struct devlink *devlink, unsigned int port_index,
>> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>> index 74bdad252c36..a0b8e24236c0 100644
>> --- a/include/uapi/linux/devlink.h
>> +++ b/include/uapi/linux/devlink.h
>> @@ -311,6 +311,19 @@ enum devlink_reload_action {
>>          DEVLINK_RELOAD_ACTION_MAX = __DEVLINK_RELOAD_ACTION_MAX - 1
>>   };
>>
>> +enum devlink_reload_limit {
>> +       DEVLINK_RELOAD_LIMIT_UNSPEC,    /* unspecified, no constraints */
>> +       DEVLINK_RELOAD_LIMIT_NO_RESET,  /* No reset allowed, no down time allowed,
>> +                                        * no link flap and no configuration is lost.
>> +                                        */
>> +
>> +       /* Add new reload limit above */
>> +       __DEVLINK_RELOAD_LIMIT_MAX,
>> +       DEVLINK_RELOAD_LIMIT_MAX = __DEVLINK_RELOAD_LIMIT_MAX - 1
>> +};
>> +
>> +#define DEVLINK_RELOAD_LIMITS_VALID_MASK (BIT(__DEVLINK_RELOAD_LIMIT_MAX) - 1)
>> +
>>   enum devlink_attr {
>>          /* don't change the order or add anything between, this is ABI! */
>>          DEVLINK_ATTR_UNSPEC,
>> @@ -505,6 +518,7 @@ enum devlink_attr {
>>
>>          DEVLINK_ATTR_RELOAD_ACTION,             /* u8 */
>>          DEVLINK_ATTR_RELOAD_ACTIONS_PERFORMED,  /* bitfield32 */
>> +       DEVLINK_ATTR_RELOAD_LIMITS,             /* bitfield32 */
>>
>>          /* add new attributes above here, update the policy in devlink.c */
>>
>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index c026ed3519c9..28b63faa3c6b 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -479,12 +479,44 @@ static int devlink_nl_put_handle(struct sk_buff *msg, struct devlink *devlink)
>>          return 0;
>>   }
>>
>> +struct devlink_reload_combination {
>> +       enum devlink_reload_action action;
>> +       enum devlink_reload_limit limit;
>> +};
>> +
>> +static const struct devlink_reload_combination devlink_reload_invalid_combinations[] = {
>> +       {
>> +               /* can't reinitialize driver with no down time */
>> +               .action = DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
>> +               .limit = DEVLINK_RELOAD_LIMIT_NO_RESET,
>> +       },
>> +};
>> +
>> +static bool
>> +devlink_reload_combination_is_invalid(enum devlink_reload_action action,
>> +                                     enum devlink_reload_limit limit)
>> +{
>> +       int i;
>> +
>> +       for (i = 0; i < ARRAY_SIZE(devlink_reload_invalid_combinations); i++)
>> +               if (devlink_reload_invalid_combinations[i].action == action &&
>> +                   devlink_reload_invalid_combinations[i].limit == limit)
>> +                       return true;
>> +       return false;
>> +}
>> +
>>   static bool
>>   devlink_reload_action_is_supported(struct devlink *devlink, enum devlink_reload_action action)
>>   {
>>          return test_bit(action, &devlink->ops->reload_actions);
>>   }
>>
>> +static bool
>> +devlink_reload_limit_is_supported(struct devlink *devlink, enum devlink_reload_limit limit)
>> +{
>> +       return test_bit(limit, &devlink->ops->reload_limits);
>> +}
>> +
>>   static int devlink_nl_fill(struct sk_buff *msg, struct devlink *devlink,
>>                             enum devlink_command cmd, u32 portid,
>>                             u32 seq, int flags)
>> @@ -2990,22 +3022,22 @@ bool devlink_is_reload_failed(const struct devlink *devlink)
>>   EXPORT_SYMBOL_GPL(devlink_is_reload_failed);
>>
>>   static int devlink_reload(struct devlink *devlink, struct net *dest_net,
>> -                         enum devlink_reload_action action, u32 *actions_performed,
>> -                         struct netlink_ext_ack *extack)
>> +                         enum devlink_reload_action action, enum devlink_reload_limit limit,
>> +                         u32 *actions_performed, struct netlink_ext_ack *extack)
>>   {
>>          int err;
>>
>>          if (!devlink->reload_enabled)
>>                  return -EOPNOTSUPP;
>>
>> -       err = devlink->ops->reload_down(devlink, !!dest_net, action, extack);
>> +       err = devlink->ops->reload_down(devlink, !!dest_net, action, limit, extack);
>>          if (err)
>>                  return err;
>>
>>          if (dest_net && !net_eq(dest_net, devlink_net(devlink)))
>>                  devlink_reload_netns_change(devlink, dest_net);
>>
>> -       err = devlink->ops->reload_up(devlink, action, actions_performed, extack);
>> +       err = devlink->ops->reload_up(devlink, action, limit, actions_performed, extack);
>>          devlink_reload_failed_set(devlink, !!err);
>>          if (err)
>>                  return err;
>> @@ -3050,6 +3082,7 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
>>   {
>>          struct devlink *devlink = info->user_ptr[0];
>>          enum devlink_reload_action action;
>> +       enum devlink_reload_limit limit;
>>          struct net *dest_net = NULL;
>>          u32 actions_performed;
>>          int err;
>> @@ -3082,7 +3115,38 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
>>                  return -EOPNOTSUPP;
>>          }
>>
>> -       err = devlink_reload(devlink, dest_net, action, &actions_performed, info->extack);
>> +       limit = DEVLINK_RELOAD_LIMIT_UNSPEC;
>> +       if (info->attrs[DEVLINK_ATTR_RELOAD_LIMITS]) {
>> +               struct nla_bitfield32 limits;
>> +               u32 limits_selected;
>> +
>> +               limits = nla_get_bitfield32(info->attrs[DEVLINK_ATTR_RELOAD_LIMITS]);
>> +               limits_selected = limits.value & limits.selector;
>> +               if (!limits_selected) {
>> +                       NL_SET_ERR_MSG_MOD(info->extack, "Invalid limit selected");
>> +                       return -EINVAL;
>> +               }
>> +               for (limit = 0 ; limit <= DEVLINK_RELOAD_LIMIT_MAX ; limit++)
>> +                       if (limits_selected & BIT(limit))
>> +                               break;
>> +               /* UAPI enables multiselection, but currently it is not used */
>> +               if (limits_selected != BIT(limit)) {
>> +                       NL_SET_ERR_MSG_MOD(info->extack,
>> +                                          "Multiselection of limit is not supported");
>> +                       return -EOPNOTSUPP;
>> +               }
>> +               if (!devlink_reload_limit_is_supported(devlink, limit)) {
>> +                       NL_SET_ERR_MSG_MOD(info->extack,
>> +                                          "Requested limit is not supported by the driver");
>> +                       return -EOPNOTSUPP;
>> +               }
>> +               if (devlink_reload_combination_is_invalid(action, limit)) {
>> +                       NL_SET_ERR_MSG_MOD(info->extack,
>> +                                          "Requested limit is invalid for this action");
>> +                       return -EINVAL;
>> +               }
>> +       }
>> +       err = devlink_reload(devlink, dest_net, action, limit, &actions_performed, info->extack);
>>
>>          if (dest_net)
>>                  put_net(dest_net);
>> @@ -3090,7 +3154,7 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
>>          if (err)
>>                  return err;
>>          /* For backward compatibility generate reply only if attributes used by user */
>> -       if (!info->attrs[DEVLINK_ATTR_RELOAD_ACTION])
>> +       if (!info->attrs[DEVLINK_ATTR_RELOAD_ACTION] && !info->attrs[DEVLINK_ATTR_RELOAD_LIMITS])
>>                  return 0;
>>
>>          return devlink_nl_reload_actions_performed_snd(devlink, actions_performed,
>> @@ -7347,6 +7411,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
>>          [DEVLINK_ATTR_PORT_FUNCTION] = { .type = NLA_NESTED },
>>          [DEVLINK_ATTR_RELOAD_ACTION] = NLA_POLICY_RANGE(NLA_U8, DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
>>                                                          DEVLINK_RELOAD_ACTION_MAX),
>> +       [DEVLINK_ATTR_RELOAD_LIMITS] = NLA_POLICY_BITFIELD32(DEVLINK_RELOAD_LIMITS_VALID_MASK),
>>   };
>>
>>   static const struct genl_small_ops devlink_nl_ops[] = {
>> @@ -7682,6 +7747,9 @@ static struct genl_family devlink_nl_family __ro_after_init = {
>>
>>   static bool devlink_reload_actions_valid(const struct devlink_ops *ops)
>>   {
>> +       const struct devlink_reload_combination *comb;
>> +       int i;
>> +
>>          if (!devlink_reload_supported(ops)) {
>>                  if (WARN_ON(ops->reload_actions))
>>                          return false;
>> @@ -7692,6 +7760,17 @@ static bool devlink_reload_actions_valid(const struct devlink_ops *ops)
>>                      ops->reload_actions & BIT(DEVLINK_RELOAD_ACTION_UNSPEC) ||
>>                      ops->reload_actions >= BIT(__DEVLINK_RELOAD_ACTION_MAX)))
>>                  return false;
>> +
>> +       if (WARN_ON(ops->reload_limits & BIT(DEVLINK_RELOAD_LIMIT_UNSPEC) ||
>> +                   ops->reload_limits >= BIT(__DEVLINK_RELOAD_LIMIT_MAX)))
>> +               return false;
>> +
>> +       for (i = 0; i < ARRAY_SIZE(devlink_reload_invalid_combinations); i++)  {
>> +               comb = &devlink_reload_invalid_combinations[i];
>> +               if (ops->reload_actions == BIT(comb->action) &&
>> +                   ops->reload_limits == BIT(comb->limit))
>> +                       return false;
>> +       }
>>          return true;
>>   }
>>
>> @@ -10056,6 +10135,7 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
>>                                  continue;
>>                          err = devlink_reload(devlink, &init_net,
>>                                               DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
>> +                                            DEVLINK_RELOAD_LIMIT_UNSPEC,
>>                                               &actions_performed, NULL);
>>                          if (err && err != -EOPNOTSUPP)
>>                                  pr_warn("Failed to reload devlink instance into init_net\n");
>> --
>> 2.18.2
>>
