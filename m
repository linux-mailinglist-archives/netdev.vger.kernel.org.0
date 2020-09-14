Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3176268461
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 08:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbgINGIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 02:08:51 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:59439 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726066AbgINGIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 02:08:25 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 14 Sep 2020 09:08:14 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (dev-l-vrt-135.mtl.labs.mlnx [10.234.135.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 08E68ExV020937;
        Mon, 14 Sep 2020 09:08:14 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Debian-10) with ESMTP id 08E68EIV017383;
        Mon, 14 Sep 2020 09:08:14 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 08E68EGG017382;
        Mon, 14 Sep 2020 09:08:14 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next RFC v4 02/15] devlink: Add reload action limit level
Date:   Mon, 14 Sep 2020 09:07:49 +0300
Message-Id: <1600063682-17313-3-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
References: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add reload action limit level to demand restrictions on actions.
Reload action limit levels supported:
none (default): No constrains on actions. Driver implementation may
                include reset or downtime as needed to perform the
                actions.
no_reset: No reset allowed, no down time allowed, no link flap and no
          configuration is lost.

The no_reset limit level will have usecase in this patchset to
implement restricted fw_activate on mlx5.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
---
v3 -> v4:
- New patch
---
 drivers/net/ethernet/mellanox/mlx4/main.c     |  3 ++
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  3 ++
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  3 ++
 drivers/net/netdevsim/dev.c                   |  6 ++-
 include/net/devlink.h                         |  6 ++-
 include/uapi/linux/devlink.h                  | 17 ++++++++
 net/core/devlink.c                            | 40 ++++++++++++++++---
 7 files changed, 70 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index aadf1676a0ed..681b4507b2ba 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3947,6 +3947,7 @@ static int mlx4_restart_one_up(struct pci_dev *pdev, bool reload,
 
 static int mlx4_devlink_reload_down(struct devlink *devlink, bool netns_change,
 				    enum devlink_reload_action action,
+				    enum devlink_reload_action_limit_level limit_level,
 				    struct netlink_ext_ack *extack)
 {
 	struct mlx4_priv *priv = devlink_priv(devlink);
@@ -3964,6 +3965,7 @@ static int mlx4_devlink_reload_down(struct devlink *devlink, bool netns_change,
 }
 
 static int mlx4_devlink_reload_up(struct devlink *devlink, enum devlink_reload_action action,
+				  enum devlink_reload_action_limit_level limit_level,
 				  struct netlink_ext_ack *extack, unsigned long *actions_performed)
 {
 	struct mlx4_priv *priv = devlink_priv(devlink);
@@ -3986,6 +3988,7 @@ static int mlx4_devlink_reload_up(struct devlink *devlink, enum devlink_reload_a
 static const struct devlink_ops mlx4_devlink_ops = {
 	.port_type_set	= mlx4_devlink_port_type_set,
 	.supported_reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT),
+	.supported_reload_action_limit_levels = BIT(DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NONE),
 	.reload_down	= mlx4_devlink_reload_down,
 	.reload_up	= mlx4_devlink_reload_up,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 9cd6b6c884e3..f6b29deaf02e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -90,6 +90,7 @@ mlx5_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 
 static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 				    enum devlink_reload_action action,
+				    enum devlink_reload_action_limit_level limit_level,
 				    struct netlink_ext_ack *extack)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
@@ -99,6 +100,7 @@ static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 }
 
 static int mlx5_devlink_reload_up(struct devlink *devlink, enum devlink_reload_action action,
+				  enum devlink_reload_action_limit_level limit_level,
 				  struct netlink_ext_ack *extack, unsigned long *actions_performed)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
@@ -127,6 +129,7 @@ static const struct devlink_ops mlx5_devlink_ops = {
 	.flash_update = mlx5_devlink_flash_update,
 	.info_get = mlx5_devlink_info_get,
 	.supported_reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT),
+	.supported_reload_action_limit_levels = BIT(DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NONE),
 	.reload_down = mlx5_devlink_reload_down,
 	.reload_up = mlx5_devlink_reload_up,
 };
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index c0a32f685b85..e2b21e5878f3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1114,6 +1114,7 @@ mlxsw_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 static int
 mlxsw_devlink_core_bus_device_reload_down(struct devlink *devlink,
 					  bool netns_change, enum devlink_reload_action action,
+					  enum devlink_reload_action_limit_level limit_level,
 					  struct netlink_ext_ack *extack)
 {
 	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
@@ -1127,6 +1128,7 @@ mlxsw_devlink_core_bus_device_reload_down(struct devlink *devlink,
 
 static int
 mlxsw_devlink_core_bus_device_reload_up(struct devlink *devlink, enum devlink_reload_action action,
+					enum devlink_reload_action_limit_level limit_level,
 					struct netlink_ext_ack *extack,
 					unsigned long *actions_performed)
 {
@@ -1279,6 +1281,7 @@ mlxsw_devlink_trap_policer_counter_get(struct devlink *devlink,
 static const struct devlink_ops mlxsw_devlink_ops = {
 	.supported_reload_actions	= BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
 					  BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
+	.supported_reload_action_limit_levels = BIT(DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NONE),
 	.reload_down		= mlxsw_devlink_core_bus_device_reload_down,
 	.reload_up		= mlxsw_devlink_core_bus_device_reload_up,
 	.port_type_set			= mlxsw_devlink_port_type_set,
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index f0919fa0cd8b..12fbaf56f722 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -697,7 +697,9 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev);
 
 static int nsim_dev_reload_down(struct devlink *devlink, bool netns_change,
-				enum devlink_reload_action action, struct netlink_ext_ack *extack)
+				enum devlink_reload_action action,
+				enum devlink_reload_action_limit_level limit_level,
+				struct netlink_ext_ack *extack)
 {
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
 
@@ -714,6 +716,7 @@ static int nsim_dev_reload_down(struct devlink *devlink, bool netns_change,
 }
 
 static int nsim_dev_reload_up(struct devlink *devlink, enum devlink_reload_action action,
+			      enum devlink_reload_action_limit_level limit_level,
 			      struct netlink_ext_ack *extack, unsigned long *actions_performed)
 {
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
@@ -883,6 +886,7 @@ nsim_dev_devlink_trap_policer_counter_get(struct devlink *devlink,
 
 static const struct devlink_ops nsim_dev_devlink_ops = {
 	.supported_reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT),
+	.supported_reload_action_limit_levels = BIT(DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NONE),
 	.reload_down = nsim_dev_reload_down,
 	.reload_up = nsim_dev_reload_up,
 	.info_get = nsim_dev_info_get,
diff --git a/include/net/devlink.h b/include/net/devlink.h
index b09db891db04..dddd9ee5b8a9 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1012,9 +1012,13 @@ enum devlink_trap_group_generic_id {
 
 struct devlink_ops {
 	unsigned long supported_reload_actions;
+	unsigned long supported_reload_action_limit_levels;
 	int (*reload_down)(struct devlink *devlink, bool netns_change,
-			   enum devlink_reload_action action, struct netlink_ext_ack *extack);
+			   enum devlink_reload_action action,
+			   enum devlink_reload_action_limit_level limit_level,
+			   struct netlink_ext_ack *extack);
 	int (*reload_up)(struct devlink *devlink, enum devlink_reload_action action,
+			 enum devlink_reload_action_limit_level limit_level,
 			 struct netlink_ext_ack *extack, unsigned long *actions_performed);
 	int (*port_type_set)(struct devlink_port *devlink_port,
 			     enum devlink_port_type port_type);
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index a6f64db0bdf3..b19686fd80ff 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -287,6 +287,22 @@ enum devlink_reload_action {
 	DEVLINK_RELOAD_ACTION_MAX = __DEVLINK_RELOAD_ACTION_MAX - 1
 };
 
+/**
+ * enum devlink_reload_action_limit_level - Reload action limit level.
+ * @DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NONE: No constrains on action. Action may include
+ *                                          reset or downtime as needed.
+ * @DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NO_RESET: No reset allowed, no down time allowed,
+ *                                              no link flap and no configuration is lost.
+ */
+enum devlink_reload_action_limit_level {
+	DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NONE,
+	DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NO_RESET,
+
+	/* Add new reload actions limit level above */
+	__DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX,
+	DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX = __DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX - 1
+};
+
 enum devlink_attr {
 	/* don't change the order or add anything between, this is ABI! */
 	DEVLINK_ATTR_UNSPEC,
@@ -478,6 +494,7 @@ enum devlink_attr {
 
 	DEVLINK_ATTR_RELOAD_ACTION,		/* u8 */
 	DEVLINK_ATTR_RELOAD_ACTIONS_PERFORMED,	/* nested */
+	DEVLINK_ATTR_RELOAD_ACTION_LIMIT_LEVEL,	/* u8 */
 
 	/* add new attributes above here, update the policy in devlink.c */
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index f4be1e1bf864..60aa0c4a3726 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -468,6 +468,13 @@ devlink_reload_action_is_supported(struct devlink *devlink, enum devlink_reload_
 	return test_bit(action, &devlink->ops->supported_reload_actions);
 }
 
+static bool
+devlink_reload_action_limit_level_is_supported(struct devlink *devlink,
+					       enum devlink_reload_action_limit_level limit_level)
+{
+	return test_bit(limit_level, &devlink->ops->supported_reload_action_limit_levels);
+}
+
 static int devlink_nl_fill(struct sk_buff *msg, struct devlink *devlink,
 			   enum devlink_command cmd, u32 portid,
 			   u32 seq, int flags)
@@ -2975,22 +2982,23 @@ bool devlink_is_reload_failed(const struct devlink *devlink)
 EXPORT_SYMBOL_GPL(devlink_is_reload_failed);
 
 static int devlink_reload(struct devlink *devlink, struct net *dest_net,
-			  enum devlink_reload_action action, struct netlink_ext_ack *extack,
-			  unsigned long *actions_performed)
+			  enum devlink_reload_action action,
+			  enum devlink_reload_action_limit_level limit_level,
+			  struct netlink_ext_ack *extack, unsigned long *actions_performed)
 {
 	int err;
 
 	if (!devlink->reload_enabled)
 		return -EOPNOTSUPP;
 
-	err = devlink->ops->reload_down(devlink, !!dest_net, action, extack);
+	err = devlink->ops->reload_down(devlink, !!dest_net, action, limit_level, extack);
 	if (err)
 		return err;
 
 	if (dest_net && !net_eq(dest_net, devlink_net(devlink)))
 		devlink_reload_netns_change(devlink, dest_net);
 
-	err = devlink->ops->reload_up(devlink, action, extack, actions_performed);
+	err = devlink->ops->reload_up(devlink, action, limit_level, extack, actions_performed);
 	devlink_reload_failed_set(devlink, !!err);
 	return err;
 }
@@ -3036,6 +3044,7 @@ devlink_nl_reload_actions_performed_fill(struct sk_buff *msg,
 
 static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 {
+	enum devlink_reload_action_limit_level limit_level;
 	struct devlink *devlink = info->user_ptr[0];
 	enum devlink_reload_action action;
 	unsigned long actions_performed;
@@ -3073,7 +3082,20 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 		return -EOPNOTSUPP;
 	}
 
-	err = devlink_reload(devlink, dest_net, action, info->extack, &actions_performed);
+	if (info->attrs[DEVLINK_ATTR_RELOAD_ACTION_LIMIT_LEVEL])
+		limit_level = nla_get_u8(info->attrs[DEVLINK_ATTR_RELOAD_ACTION_LIMIT_LEVEL]);
+	else
+		limit_level = DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NONE;
+
+	if (limit_level > DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX) {
+		NL_SET_ERR_MSG_MOD(info->extack, "Invalid limit level");
+		return -EINVAL;
+	} else if (!devlink_reload_action_limit_level_is_supported(devlink, limit_level)) {
+		NL_SET_ERR_MSG_MOD(info->extack, "Requested limit level is not supported");
+		return -EOPNOTSUPP;
+	}
+	err = devlink_reload(devlink, dest_net, action, limit_level, info->extack,
+			     &actions_performed);
 
 	if (dest_net)
 		put_net(dest_net);
@@ -7126,6 +7148,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_TRAP_POLICER_BURST] = { .type = NLA_U64 },
 	[DEVLINK_ATTR_PORT_FUNCTION] = { .type = NLA_NESTED },
 	[DEVLINK_ATTR_RELOAD_ACTION] = { .type = NLA_U8 },
+	[DEVLINK_ATTR_RELOAD_ACTION_LIMIT_LEVEL] = { .type = NLA_U8 },
 };
 
 static const struct genl_ops devlink_nl_ops[] = {
@@ -7462,6 +7485,10 @@ static int devlink_reload_actions_verify(struct devlink *devlink)
 	if (WARN_ON(ops->supported_reload_actions >= BIT(__DEVLINK_RELOAD_ACTION_MAX) ||
 		    ops->supported_reload_actions <= BIT(DEVLINK_RELOAD_ACTION_UNSPEC)))
 		return -EINVAL;
+	if (WARN_ON(!ops->supported_reload_action_limit_levels ||
+		    ops->supported_reload_action_limit_levels >=
+		    BIT(__DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX)))
+		return -EINVAL;
 	return 0;
 }
 
@@ -9756,7 +9783,8 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 			if (WARN_ON(!devlink_reload_supported(devlink)))
 				continue;
 			err = devlink_reload(devlink, &init_net,
-					     DEVLINK_RELOAD_ACTION_DRIVER_REINIT, NULL, NULL);
+					     DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
+					     DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NONE, NULL, NULL);
 			if (err && err != -EOPNOTSUPP)
 				pr_warn("Failed to reload devlink instance into init_net\n");
 		}
-- 
2.17.1

