Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC1F268584
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbgINHJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726042AbgINHJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:09:12 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C85C06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:09:11 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id y17so12218974lfa.8
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IX1ua8oFIW5HH6nPvNPi6nCp+DaDCesfDjicjtCoClE=;
        b=Npm2e2hhhRWDn9qBc30rpbVlZPQYj7W+ZrJ5uHCH7/nH+N0n3g/p64erGZo/VsPXHQ
         8Sih+Q3/wVVDuXULPIUXP0DJv9ERkLPrU+8aELMBgvCN6SE4bsW3/4kMk4528CWrKSRo
         BYP71xaID7Z4xPyp6WZKGxbpzP44QlCJQu98M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IX1ua8oFIW5HH6nPvNPi6nCp+DaDCesfDjicjtCoClE=;
        b=uBL/Ff0boNAGW/RkhFsACLtTByXK9mfbYued0TAUJswoOu0HhAZuNNpRMs2yreI0hG
         MMB1/VciMPJzt+Yczlu3671hcy2PD/EK9bHzr3gaKUTxYr5+wrQjTFP+T+cOP8pK/KtT
         SIuK6Zs6Fw/GRPLsANWT9EDnxqdALPbnRpc2MNzucdcAFS8E5fWalO2DhgLp7mWjf/ED
         lL/Utdvkqad0m8JacDuw1BQ/yY4gVrNxtJIjqG1kBB3TDVYMFyrRBj9R/rAyXodF2H9j
         IrlRoh5LTK3ABgErOYKOCEHs78AAJ45PAMqWuBPE6HNBkwZbv/QT3ja7W+oyvVSsMOAn
         H1ag==
X-Gm-Message-State: AOAM533NGer5pbawoQFc1BR2a1CCpm2QYhmkN7g4uKeTYT0HpcRv3y/L
        XS19Xb6zHeeVDQLXdGXeZ22j8Y/aBt1KamEOc/s9MA==
X-Google-Smtp-Source: ABdhPJzoD2XUJsowHckQnUkujQ6wLLV2dI71X+KR8UIJbrje0ci3hSjMtF6YPbb8fN0JIqZVmdE82QtQBIAVyi1Ewdw=
X-Received: by 2002:a19:7015:: with SMTP id h21mr4420959lfc.473.1600067349772;
 Mon, 14 Sep 2020 00:09:09 -0700 (PDT)
MIME-Version: 1.0
References: <1600063682-17313-1-git-send-email-moshe@mellanox.com> <1600063682-17313-2-git-send-email-moshe@mellanox.com>
In-Reply-To: <1600063682-17313-2-git-send-email-moshe@mellanox.com>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Mon, 14 Sep 2020 12:38:58 +0530
Message-ID: <CAACQVJochmfmUgKSvSTe4McFvG6=ffBbkfXsrOJjiCDwQVvaRw@mail.gmail.com>
Subject: Re: [PATCH net-next RFC v4 01/15] devlink: Add reload action option
 to devlink reload command
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 11:39 AM Moshe Shemesh <moshe@mellanox.com> wrote:
>
> Add devlink reload action to allow the user to request a specific reload
> action. The action parameter is optional, if not specified then devlink
> driver re-init action is used (backward compatible).
> Note that when required to do firmware activation some drivers may need
> to reload the driver. On the other hand some drivers may need to reset
> the firmware to reinitialize the driver entities. Therefore, the devlink
> reload command returns the actions which were actually performed.
> Reload actions supported are:
> driver_reinit: driver entities re-initialization, applying devlink-param
>                and devlink-resource values.
> fw_activate: firmware activate.
>
> command examples:
> $devlink dev reload pci/0000:82:00.0 action driver_reinit
> reload_actions_performed:
>   driver_reinit
>
> $devlink dev reload pci/0000:82:00.0 action fw_activate
> reload_actions_performed:
>   driver_reinit fw_activate
>
> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
> ---
> v3 -> v4:
> - Removed fw_activate_no_reset as an action (next patch adds limit
>   levels instead).
> - Renamed actions_done to actions_performed
> v2 -> v3:
> - Replace fw_live_patch action by fw_activate_no_reset
> - Devlink reload returns the actions done over netlink reply
> v1 -> v2:
> - Instead of reload levels driver,fw_reset,fw_live_patch have reload
>   actions driver_reinit,fw_activate,fw_live_patch
> - Remove driver default level, the action driver_reinit is the default
>   action for all drivers
> ---
>  drivers/net/ethernet/mellanox/mlx4/main.c     |  14 ++-
>  .../net/ethernet/mellanox/mlx5/core/devlink.c |  15 ++-
>  drivers/net/ethernet/mellanox/mlxsw/core.c    |  25 ++--
>  drivers/net/netdevsim/dev.c                   |  16 ++-
>  include/net/devlink.h                         |   7 +-
>  include/uapi/linux/devlink.h                  |  19 +++
>  net/core/devlink.c                            | 111 +++++++++++++++++-
>  7 files changed, 180 insertions(+), 27 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
> index 70cf24ba71e4..aadf1676a0ed 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/main.c
> @@ -3946,6 +3946,7 @@ static int mlx4_restart_one_up(struct pci_dev *pdev, bool reload,
>                                struct devlink *devlink);
>
>  static int mlx4_devlink_reload_down(struct devlink *devlink, bool netns_change,
> +                                   enum devlink_reload_action action,
>                                     struct netlink_ext_ack *extack)
>  {
>         struct mlx4_priv *priv = devlink_priv(devlink);
> @@ -3962,8 +3963,8 @@ static int mlx4_devlink_reload_down(struct devlink *devlink, bool netns_change,
>         return 0;
>  }
>
> -static int mlx4_devlink_reload_up(struct devlink *devlink,
> -                                 struct netlink_ext_ack *extack)
> +static int mlx4_devlink_reload_up(struct devlink *devlink, enum devlink_reload_action action,
> +                                 struct netlink_ext_ack *extack, unsigned long *actions_performed)
>  {
>         struct mlx4_priv *priv = devlink_priv(devlink);
>         struct mlx4_dev *dev = &priv->dev;
> @@ -3971,15 +3972,20 @@ static int mlx4_devlink_reload_up(struct devlink *devlink,
>         int err;
>
>         err = mlx4_restart_one_up(persist->pdev, true, devlink);
> -       if (err)
> +       if (err) {
>                 mlx4_err(persist->dev, "mlx4_restart_one_up failed, ret=%d\n",
>                          err);
> +               return err;
> +       }
> +       if (actions_performed)
> +               *actions_performed = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
>
> -       return err;
> +       return 0;
>  }
>
>  static const struct devlink_ops mlx4_devlink_ops = {
>         .port_type_set  = mlx4_devlink_port_type_set,
> +       .supported_reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT),
>         .reload_down    = mlx4_devlink_reload_down,
>         .reload_up      = mlx4_devlink_reload_up,
>  };
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
> index c709e9a385f6..9cd6b6c884e3 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
> @@ -89,6 +89,7 @@ mlx5_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
>  }
>
>  static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
> +                                   enum devlink_reload_action action,
>                                     struct netlink_ext_ack *extack)
>  {
>         struct mlx5_core_dev *dev = devlink_priv(devlink);
> @@ -97,12 +98,19 @@ static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
>         return 0;
>  }
>
> -static int mlx5_devlink_reload_up(struct devlink *devlink,
> -                                 struct netlink_ext_ack *extack)
> +static int mlx5_devlink_reload_up(struct devlink *devlink, enum devlink_reload_action action,
> +                                 struct netlink_ext_ack *extack, unsigned long *actions_performed)
>  {
>         struct mlx5_core_dev *dev = devlink_priv(devlink);
> +       int err;
>
> -       return mlx5_load_one(dev, false);
> +       err = mlx5_load_one(dev, false);
> +       if (err)
> +               return err;
> +       if (actions_performed)
> +               *actions_performed = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
> +
> +       return 0;
>  }
>
>  static const struct devlink_ops mlx5_devlink_ops = {
> @@ -118,6 +126,7 @@ static const struct devlink_ops mlx5_devlink_ops = {
>  #endif
>         .flash_update = mlx5_devlink_flash_update,
>         .info_get = mlx5_devlink_info_get,
> +       .supported_reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT),
>         .reload_down = mlx5_devlink_reload_down,
>         .reload_up = mlx5_devlink_reload_up,
>  };
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
> index ec45a03140d7..c0a32f685b85 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/core.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
> @@ -1113,7 +1113,7 @@ mlxsw_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
>
>  static int
>  mlxsw_devlink_core_bus_device_reload_down(struct devlink *devlink,
> -                                         bool netns_change,
> +                                         bool netns_change, enum devlink_reload_action action,
>                                           struct netlink_ext_ack *extack)
>  {
>         struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
> @@ -1126,15 +1126,24 @@ mlxsw_devlink_core_bus_device_reload_down(struct devlink *devlink,
>  }
>
>  static int
> -mlxsw_devlink_core_bus_device_reload_up(struct devlink *devlink,
> -                                       struct netlink_ext_ack *extack)
> +mlxsw_devlink_core_bus_device_reload_up(struct devlink *devlink, enum devlink_reload_action action,
> +                                       struct netlink_ext_ack *extack,
> +                                       unsigned long *actions_performed)
Sorry for repeating again, for fw_activate action on our device, all
the driver entities undergo reset asynchronously once user initiates
"devlink dev reload action fw_activate" and reload_up does not have
much to do except reporting actions that will be/being performed.

Once reset is complete, the health reporter will be notified using
devlink_health_reporter_recovery_done(). Returning from reload_up does
not guarantee successful activation of firmware. Status of reset will
be notified to the health reporter via
devlink_health_reporter_state_update().

I am just repeating this, so I want to know if I am on the same page.

Thanks.
>  {
>         struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
> +       int err;
>
> -       return mlxsw_core_bus_device_register(mlxsw_core->bus_info,
> -                                             mlxsw_core->bus,
> -                                             mlxsw_core->bus_priv, true,
> -                                             devlink, extack);
> +       err = mlxsw_core_bus_device_register(mlxsw_core->bus_info,
> +                                            mlxsw_core->bus,
> +                                            mlxsw_core->bus_priv, true,
> +                                            devlink, extack);
> +       if (err)
> +               return err;
> +       if (actions_performed)
> +               *actions_performed = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
> +                                    BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE);
> +
> +       return 0;
>  }
>
>  static int mlxsw_devlink_flash_update(struct devlink *devlink,
> @@ -1268,6 +1277,8 @@ mlxsw_devlink_trap_policer_counter_get(struct devlink *devlink,
>  }
>
>  static const struct devlink_ops mlxsw_devlink_ops = {
> +       .supported_reload_actions       = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
> +                                         BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
What if drivers do not support DRIVER_REINIT operation directly but
when users issue FW_ACTIVATE, driver performs both FW_ACTIVATE and
DRIVER_REINIT? That particular driver has to advertise only
DRIVER_REINIT action, right?

>         .reload_down            = mlxsw_devlink_core_bus_device_reload_down,
>         .reload_up              = mlxsw_devlink_core_bus_device_reload_up,
>         .port_type_set                  = mlxsw_devlink_port_type_set,
> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> index 32f339fedb21..f0919fa0cd8b 100644
> --- a/drivers/net/netdevsim/dev.c
> +++ b/drivers/net/netdevsim/dev.c
> @@ -697,7 +697,7 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
>  static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev);
>
>  static int nsim_dev_reload_down(struct devlink *devlink, bool netns_change,
> -                               struct netlink_ext_ack *extack)
> +                               enum devlink_reload_action action, struct netlink_ext_ack *extack)
>  {
>         struct nsim_dev *nsim_dev = devlink_priv(devlink);
>
> @@ -713,10 +713,11 @@ static int nsim_dev_reload_down(struct devlink *devlink, bool netns_change,
>         return 0;
>  }
>
> -static int nsim_dev_reload_up(struct devlink *devlink,
> -                             struct netlink_ext_ack *extack)
> +static int nsim_dev_reload_up(struct devlink *devlink, enum devlink_reload_action action,
> +                             struct netlink_ext_ack *extack, unsigned long *actions_performed)
>  {
>         struct nsim_dev *nsim_dev = devlink_priv(devlink);
> +       int err;
>
>         if (nsim_dev->fail_reload) {
>                 /* For testing purposes, user set debugfs fail_reload
> @@ -726,7 +727,13 @@ static int nsim_dev_reload_up(struct devlink *devlink,
>                 return -EINVAL;
>         }
>
> -       return nsim_dev_reload_create(nsim_dev, extack);
> +       err = nsim_dev_reload_create(nsim_dev, extack);
> +       if (err)
> +               return err;
> +       if (actions_performed)
> +               *actions_performed = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
> +
> +       return 0;
>  }
>
>  static int nsim_dev_info_get(struct devlink *devlink,
> @@ -875,6 +882,7 @@ nsim_dev_devlink_trap_policer_counter_get(struct devlink *devlink,
>  }
>
>  static const struct devlink_ops nsim_dev_devlink_ops = {
> +       .supported_reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT),
>         .reload_down = nsim_dev_reload_down,
>         .reload_up = nsim_dev_reload_up,
>         .info_get = nsim_dev_info_get,
> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index eaec0a8cc5ef..b09db891db04 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -1011,10 +1011,11 @@ enum devlink_trap_group_generic_id {
>         }
>
>  struct devlink_ops {
> +       unsigned long supported_reload_actions;
>         int (*reload_down)(struct devlink *devlink, bool netns_change,
> -                          struct netlink_ext_ack *extack);
> -       int (*reload_up)(struct devlink *devlink,
> -                        struct netlink_ext_ack *extack);
> +                          enum devlink_reload_action action, struct netlink_ext_ack *extack);
> +       int (*reload_up)(struct devlink *devlink, enum devlink_reload_action action,
> +                        struct netlink_ext_ack *extack, unsigned long *actions_performed);
>         int (*port_type_set)(struct devlink_port *devlink_port,
>                              enum devlink_port_type port_type);
>         int (*port_split)(struct devlink *devlink, unsigned int port_index,
> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
> index 40d35145c879..a6f64db0bdf3 100644
> --- a/include/uapi/linux/devlink.h
> +++ b/include/uapi/linux/devlink.h
> @@ -272,6 +272,21 @@ enum {
>         DEVLINK_ATTR_TRAP_METADATA_TYPE_FA_COOKIE,
>  };
>
> +/**
> + * enum devlink_reload_action - Reload action.
> + * @DEVLINK_RELOAD_ACTION_DRIVER_REINIT: Driver entities re-instantiation.
> + * @DEVLINK_RELOAD_ACTION_FW_ACTIVATE: FW activate.
> + */
> +enum devlink_reload_action {
> +       DEVLINK_RELOAD_ACTION_UNSPEC,
> +       DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
> +       DEVLINK_RELOAD_ACTION_FW_ACTIVATE,
> +
> +       /* Add new reload actions above */
> +       __DEVLINK_RELOAD_ACTION_MAX,
> +       DEVLINK_RELOAD_ACTION_MAX = __DEVLINK_RELOAD_ACTION_MAX - 1
> +};
> +
>  enum devlink_attr {
>         /* don't change the order or add anything between, this is ABI! */
>         DEVLINK_ATTR_UNSPEC,
> @@ -460,6 +475,10 @@ enum devlink_attr {
>
>         DEVLINK_ATTR_PORT_EXTERNAL,             /* u8 */
>         DEVLINK_ATTR_PORT_CONTROLLER_NUMBER,    /* u32 */
> +
> +       DEVLINK_ATTR_RELOAD_ACTION,             /* u8 */
> +       DEVLINK_ATTR_RELOAD_ACTIONS_PERFORMED,  /* nested */
> +
>         /* add new attributes above here, update the policy in devlink.c */
>
>         __DEVLINK_ATTR_MAX,
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 19037f114307..f4be1e1bf864 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -462,6 +462,12 @@ static int devlink_nl_put_handle(struct sk_buff *msg, struct devlink *devlink)
>         return 0;
>  }
>
> +static bool
> +devlink_reload_action_is_supported(struct devlink *devlink, enum devlink_reload_action action)
> +{
> +       return test_bit(action, &devlink->ops->supported_reload_actions);
> +}
> +
>  static int devlink_nl_fill(struct sk_buff *msg, struct devlink *devlink,
>                            enum devlink_command cmd, u32 portid,
>                            u32 seq, int flags)
> @@ -2969,29 +2975,72 @@ bool devlink_is_reload_failed(const struct devlink *devlink)
>  EXPORT_SYMBOL_GPL(devlink_is_reload_failed);
>
>  static int devlink_reload(struct devlink *devlink, struct net *dest_net,
> -                         struct netlink_ext_ack *extack)
> +                         enum devlink_reload_action action, struct netlink_ext_ack *extack,
> +                         unsigned long *actions_performed)
>  {
>         int err;
>
>         if (!devlink->reload_enabled)
>                 return -EOPNOTSUPP;
>
> -       err = devlink->ops->reload_down(devlink, !!dest_net, extack);
> +       err = devlink->ops->reload_down(devlink, !!dest_net, action, extack);
>         if (err)
>                 return err;
>
>         if (dest_net && !net_eq(dest_net, devlink_net(devlink)))
>                 devlink_reload_netns_change(devlink, dest_net);
>
> -       err = devlink->ops->reload_up(devlink, extack);
> +       err = devlink->ops->reload_up(devlink, action, extack, actions_performed);
>         devlink_reload_failed_set(devlink, !!err);
>         return err;
>  }
>
> +static int
> +devlink_nl_reload_actions_performed_fill(struct sk_buff *msg,
> +                                        struct devlink *devlink,
> +                                        unsigned long actions_performed,
> +                                        enum devlink_command cmd, u32 portid,
> +                                        u32 seq, int flags)
> +{
> +       struct nlattr *actions_performed_attr;
> +       void *hdr;
> +       int i;
> +
> +       hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
> +       if (!hdr)
> +               return -EMSGSIZE;
> +
> +       if (devlink_nl_put_handle(msg, devlink))
> +               goto genlmsg_cancel;
> +
> +       actions_performed_attr = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_ACTIONS_PERFORMED);
> +       if (!actions_performed_attr)
> +               goto genlmsg_cancel;
> +
> +       for (i = 0; i <= DEVLINK_RELOAD_ACTION_MAX; i++) {
> +               if (!test_bit(i, &actions_performed))
> +                       continue;
> +               if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_ACTION, i))
> +                       goto actions_performed_nest_cancel;
> +       }
> +       nla_nest_end(msg, actions_performed_attr);
> +       genlmsg_end(msg, hdr);
> +       return 0;
> +
> +actions_performed_nest_cancel:
> +       nla_nest_cancel(msg, actions_performed_attr);
> +genlmsg_cancel:
> +       genlmsg_cancel(msg, hdr);
> +       return -EMSGSIZE;
> +}
> +
>  static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
>  {
>         struct devlink *devlink = info->user_ptr[0];
> +       enum devlink_reload_action action;
> +       unsigned long actions_performed;
>         struct net *dest_net = NULL;
> +       struct sk_buff *msg;
>         int err;
>
>         if (!devlink_reload_supported(devlink))
> @@ -3011,12 +3060,41 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
>                         return PTR_ERR(dest_net);
>         }
>
> -       err = devlink_reload(devlink, dest_net, info->extack);
> +       if (info->attrs[DEVLINK_ATTR_RELOAD_ACTION])
> +               action = nla_get_u8(info->attrs[DEVLINK_ATTR_RELOAD_ACTION]);
> +       else
> +               action = DEVLINK_RELOAD_ACTION_DRIVER_REINIT;
> +
> +       if (action == DEVLINK_RELOAD_ACTION_UNSPEC || action > DEVLINK_RELOAD_ACTION_MAX) {
> +               NL_SET_ERR_MSG_MOD(info->extack, "Invalid reload action");
> +               return -EINVAL;
> +       } else if (!devlink_reload_action_is_supported(devlink, action)) {
> +               NL_SET_ERR_MSG_MOD(info->extack, "Requested reload action is not supported");
> +               return -EOPNOTSUPP;
> +       }
> +
> +       err = devlink_reload(devlink, dest_net, action, info->extack, &actions_performed);
>
>         if (dest_net)
>                 put_net(dest_net);
>
> -       return err;
> +       if (err)
> +               return err;
> +
> +       WARN_ON(!actions_performed);
> +       msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> +       if (!msg)
> +               return -ENOMEM;
> +
> +       err = devlink_nl_reload_actions_performed_fill(msg, devlink, actions_performed,
> +                                                      DEVLINK_CMD_RELOAD, info->snd_portid,
> +                                                      info->snd_seq, 0);
> +       if (err) {
> +               nlmsg_free(msg);
> +               return err;
> +       }
> +
> +       return genlmsg_reply(msg, info);
>  }
>
>  static int devlink_nl_flash_update_fill(struct sk_buff *msg,
> @@ -7047,6 +7125,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
>         [DEVLINK_ATTR_TRAP_POLICER_RATE] = { .type = NLA_U64 },
>         [DEVLINK_ATTR_TRAP_POLICER_BURST] = { .type = NLA_U64 },
>         [DEVLINK_ATTR_PORT_FUNCTION] = { .type = NLA_NESTED },
> +       [DEVLINK_ATTR_RELOAD_ACTION] = { .type = NLA_U8 },
>  };
>
>  static const struct genl_ops devlink_nl_ops[] = {
> @@ -7372,6 +7451,20 @@ static struct genl_family devlink_nl_family __ro_after_init = {
>         .n_mcgrps       = ARRAY_SIZE(devlink_nl_mcgrps),
>  };
>
> +static int devlink_reload_actions_verify(struct devlink *devlink)
> +{
> +       const struct devlink_ops *ops;
> +
> +       if (!devlink_reload_supported(devlink))
> +               return 0;
> +
> +       ops = devlink->ops;
> +       if (WARN_ON(ops->supported_reload_actions >= BIT(__DEVLINK_RELOAD_ACTION_MAX) ||
> +                   ops->supported_reload_actions <= BIT(DEVLINK_RELOAD_ACTION_UNSPEC)))
> +               return -EINVAL;
> +       return 0;
> +}
> +
>  /**
>   *     devlink_alloc - Allocate new devlink instance resources
>   *
> @@ -7392,6 +7485,11 @@ struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size)
>         if (!devlink)
>                 return NULL;
>         devlink->ops = ops;
> +       if (devlink_reload_actions_verify(devlink)) {
> +               kfree(devlink);
> +               return NULL;
> +       }
> +
>         xa_init_flags(&devlink->snapshot_ids, XA_FLAGS_ALLOC);
>         __devlink_net_set(devlink, &init_net);
>         INIT_LIST_HEAD(&devlink->port_list);
> @@ -9657,7 +9755,8 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
>                 if (net_eq(devlink_net(devlink), net)) {
>                         if (WARN_ON(!devlink_reload_supported(devlink)))
>                                 continue;
> -                       err = devlink_reload(devlink, &init_net, NULL);
> +                       err = devlink_reload(devlink, &init_net,
> +                                            DEVLINK_RELOAD_ACTION_DRIVER_REINIT, NULL, NULL);
>                         if (err && err != -EOPNOTSUPP)
>                                 pr_warn("Failed to reload devlink instance into init_net\n");
>                 }
> --
> 2.17.1
>
