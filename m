Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46EDB2463A4
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgHQJo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:44:59 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:56905 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726858AbgHQJo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:44:59 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 17 Aug 2020 12:38:11 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (dev-l-vrt-135.mtl.labs.mlnx [10.234.135.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 07H9cBox011400;
        Mon, 17 Aug 2020 12:38:11 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Debian-10) with ESMTP id 07H9cB7j003227;
        Mon, 17 Aug 2020 12:38:11 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 07H9cBtG003226;
        Mon, 17 Aug 2020 12:38:11 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next RFC v2 01/13] devlink: Add reload action option to devlink reload command
Date:   Mon, 17 Aug 2020 12:37:40 +0300
Message-Id: <1597657072-3130-2-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1597657072-3130-1-git-send-email-moshe@mellanox.com>
References: <1597657072-3130-1-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add devlink reload action to allow the user to request a specific reload
action. The action parameter is optional, if not specified then devlink
driver re-init action is used (backward compatible).
Note that when required to do firmware activation some drivers may need
to reload the driver. On the other hand some drivers may need to reset
the firmware to reinitialize the driver entities.
Reload actions supported are:
driver_reinit: driver entities re-initialization, applying devlink-param
               and devlink-resource values.
fw_activate: firmware activate.
fw_live_patch: firmware live patching.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
---
v1 -> v2:
- Instead of reload levels driver,fw_reset,fw_live_patch have reload
  actions driver_reinit,fw_activate,fw_live_patch
- Remove driver default level, the action driver_reinit is the default
  action for all drivers
---
 drivers/net/ethernet/mellanox/mlx4/main.c     |  4 +-
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  4 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  6 ++-
 drivers/net/netdevsim/dev.c                   |  5 +-
 include/net/devlink.h                         |  5 +-
 include/uapi/linux/devlink.h                  | 19 +++++++
 net/core/devlink.c                            | 51 +++++++++++++++++--
 7 files changed, 81 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 258c7a96f269..e7df4975bea3 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3935,6 +3935,7 @@ static int mlx4_restart_one_up(struct pci_dev *pdev, bool reload,
 			       struct devlink *devlink);
 
 static int mlx4_devlink_reload_down(struct devlink *devlink, bool netns_change,
+				    enum devlink_reload_action action,
 				    struct netlink_ext_ack *extack)
 {
 	struct mlx4_priv *priv = devlink_priv(devlink);
@@ -3951,7 +3952,7 @@ static int mlx4_devlink_reload_down(struct devlink *devlink, bool netns_change,
 	return 0;
 }
 
-static int mlx4_devlink_reload_up(struct devlink *devlink,
+static int mlx4_devlink_reload_up(struct devlink *devlink, enum devlink_reload_action action,
 				  struct netlink_ext_ack *extack)
 {
 	struct mlx4_priv *priv = devlink_priv(devlink);
@@ -3969,6 +3970,7 @@ static int mlx4_devlink_reload_up(struct devlink *devlink,
 
 static const struct devlink_ops mlx4_devlink_ops = {
 	.port_type_set	= mlx4_devlink_port_type_set,
+	.supported_reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT),
 	.reload_down	= mlx4_devlink_reload_down,
 	.reload_up	= mlx4_devlink_reload_up,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index c709e9a385f6..dfdf48869f70 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -89,6 +89,7 @@ mlx5_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 }
 
 static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
+				    enum devlink_reload_action action,
 				    struct netlink_ext_ack *extack)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
@@ -97,7 +98,7 @@ static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 	return 0;
 }
 
-static int mlx5_devlink_reload_up(struct devlink *devlink,
+static int mlx5_devlink_reload_up(struct devlink *devlink, enum devlink_reload_action action,
 				  struct netlink_ext_ack *extack)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
@@ -118,6 +119,7 @@ static const struct devlink_ops mlx5_devlink_ops = {
 #endif
 	.flash_update = mlx5_devlink_flash_update,
 	.info_get = mlx5_devlink_info_get,
+	.supported_reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT),
 	.reload_down = mlx5_devlink_reload_down,
 	.reload_up = mlx5_devlink_reload_up,
 };
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 08d101138fbe..f67c5aa2a86f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1113,7 +1113,7 @@ mlxsw_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 
 static int
 mlxsw_devlink_core_bus_device_reload_down(struct devlink *devlink,
-					  bool netns_change,
+					  bool netns_change, enum devlink_reload_action action,
 					  struct netlink_ext_ack *extack)
 {
 	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
@@ -1126,7 +1126,7 @@ mlxsw_devlink_core_bus_device_reload_down(struct devlink *devlink,
 }
 
 static int
-mlxsw_devlink_core_bus_device_reload_up(struct devlink *devlink,
+mlxsw_devlink_core_bus_device_reload_up(struct devlink *devlink, enum devlink_reload_action action,
 					struct netlink_ext_ack *extack)
 {
 	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
@@ -1268,6 +1268,8 @@ mlxsw_devlink_trap_policer_counter_get(struct devlink *devlink,
 }
 
 static const struct devlink_ops mlxsw_devlink_ops = {
+	.supported_reload_actions	= BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
+					  BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
 	.reload_down		= mlxsw_devlink_core_bus_device_reload_down,
 	.reload_up		= mlxsw_devlink_core_bus_device_reload_up,
 	.port_type_set			= mlxsw_devlink_port_type_set,
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 32f339fedb21..c212f502052c 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -697,7 +697,7 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev);
 
 static int nsim_dev_reload_down(struct devlink *devlink, bool netns_change,
-				struct netlink_ext_ack *extack)
+				enum devlink_reload_action action, struct netlink_ext_ack *extack)
 {
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
 
@@ -713,7 +713,7 @@ static int nsim_dev_reload_down(struct devlink *devlink, bool netns_change,
 	return 0;
 }
 
-static int nsim_dev_reload_up(struct devlink *devlink,
+static int nsim_dev_reload_up(struct devlink *devlink, enum devlink_reload_action action,
 			      struct netlink_ext_ack *extack)
 {
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
@@ -875,6 +875,7 @@ nsim_dev_devlink_trap_policer_counter_get(struct devlink *devlink,
 }
 
 static const struct devlink_ops nsim_dev_devlink_ops = {
+	.supported_reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT),
 	.reload_down = nsim_dev_reload_down,
 	.reload_up = nsim_dev_reload_up,
 	.info_get = nsim_dev_info_get,
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 8f3c8a443238..cad3e11d0b9b 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -991,9 +991,10 @@ enum devlink_trap_group_generic_id {
 	}
 
 struct devlink_ops {
+	unsigned long supported_reload_actions;
 	int (*reload_down)(struct devlink *devlink, bool netns_change,
-			   struct netlink_ext_ack *extack);
-	int (*reload_up)(struct devlink *devlink,
+			   enum devlink_reload_action action, struct netlink_ext_ack *extack);
+	int (*reload_up)(struct devlink *devlink, enum devlink_reload_action action,
 			 struct netlink_ext_ack *extack);
 	int (*port_type_set)(struct devlink_port *devlink_port,
 			     enum devlink_port_type port_type);
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index cfef4245ea5a..6728029d2e1e 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -272,6 +272,23 @@ enum {
 	DEVLINK_ATTR_TRAP_METADATA_TYPE_FA_COOKIE,
 };
 
+/**
+ * enum devlink_reload_action - Reload action.
+ * @DEVLINK_RELOAD_ACTION_FW_LIVE_PATCH: FW live patching.
+ * @DEVLINK_RELOAD_ACTION_DRIVER_REINIT: Driver entities re-instantiation.
+ * @DEVLINK_RELOAD_ACTION_FW_ACTIVATE: FW activate.
+ */
+enum devlink_reload_action {
+	DEVLINK_RELOAD_ACTION_UNSPEC,
+	DEVLINK_RELOAD_ACTION_FW_LIVE_PATCH,
+	DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
+	DEVLINK_RELOAD_ACTION_FW_ACTIVATE,
+
+	/* Add new reload actions above */
+	__DEVLINK_RELOAD_ACTION_MAX,
+	DEVLINK_RELOAD_ACTION_MAX = __DEVLINK_RELOAD_ACTION_MAX - 1
+};
+
 enum devlink_attr {
 	/* don't change the order or add anything between, this is ABI! */
 	DEVLINK_ATTR_UNSPEC,
@@ -458,6 +475,8 @@ enum devlink_attr {
 	DEVLINK_ATTR_PORT_LANES,			/* u32 */
 	DEVLINK_ATTR_PORT_SPLITTABLE,			/* u8 */
 
+	DEVLINK_ATTR_RELOAD_ACTION,		/* u8 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index e674f0f46dc2..88438ffd6015 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -462,6 +462,12 @@ static int devlink_nl_put_handle(struct sk_buff *msg, struct devlink *devlink)
 	return 0;
 }
 
+static bool
+devlink_reload_action_is_supported(struct devlink *devlink, enum devlink_reload_action action)
+{
+	return test_bit(action, &devlink->ops->supported_reload_actions);
+}
+
 static int devlink_nl_fill(struct sk_buff *msg, struct devlink *devlink,
 			   enum devlink_command cmd, u32 portid,
 			   u32 seq, int flags)
@@ -2964,21 +2970,21 @@ bool devlink_is_reload_failed(const struct devlink *devlink)
 EXPORT_SYMBOL_GPL(devlink_is_reload_failed);
 
 static int devlink_reload(struct devlink *devlink, struct net *dest_net,
-			  struct netlink_ext_ack *extack)
+			  enum devlink_reload_action action, struct netlink_ext_ack *extack)
 {
 	int err;
 
 	if (!devlink->reload_enabled)
 		return -EOPNOTSUPP;
 
-	err = devlink->ops->reload_down(devlink, !!dest_net, extack);
+	err = devlink->ops->reload_down(devlink, !!dest_net, action, extack);
 	if (err)
 		return err;
 
 	if (dest_net && !net_eq(dest_net, devlink_net(devlink)))
 		devlink_reload_netns_change(devlink, dest_net);
 
-	err = devlink->ops->reload_up(devlink, extack);
+	err = devlink->ops->reload_up(devlink, action, extack);
 	devlink_reload_failed_set(devlink, !!err);
 	return err;
 }
@@ -2986,6 +2992,7 @@ static int devlink_reload(struct devlink *devlink, struct net *dest_net,
 static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 {
 	struct devlink *devlink = info->user_ptr[0];
+	enum devlink_reload_action action;
 	struct net *dest_net = NULL;
 	int err;
 
@@ -3006,7 +3013,20 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 			return PTR_ERR(dest_net);
 	}
 
-	err = devlink_reload(devlink, dest_net, info->extack);
+	if (info->attrs[DEVLINK_ATTR_RELOAD_ACTION])
+		action = nla_get_u8(info->attrs[DEVLINK_ATTR_RELOAD_ACTION]);
+	else
+		action = DEVLINK_RELOAD_ACTION_DRIVER_REINIT;
+
+	if (action == DEVLINK_RELOAD_ACTION_UNSPEC || action > DEVLINK_RELOAD_ACTION_MAX) {
+		NL_SET_ERR_MSG_MOD(info->extack, "Invalid reload action");
+		return -EINVAL;
+	} else if (!devlink_reload_action_is_supported(devlink, action)) {
+		NL_SET_ERR_MSG_MOD(info->extack, "Requested reload action is not supported");
+		return -EOPNOTSUPP;
+	}
+
+	err = devlink_reload(devlink, dest_net, action, info->extack);
 
 	if (dest_net)
 		put_net(dest_net);
@@ -7039,6 +7059,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_TRAP_POLICER_RATE] = { .type = NLA_U64 },
 	[DEVLINK_ATTR_TRAP_POLICER_BURST] = { .type = NLA_U64 },
 	[DEVLINK_ATTR_PORT_FUNCTION] = { .type = NLA_NESTED },
+	[DEVLINK_ATTR_RELOAD_ACTION] = { .type = NLA_U8 },
 };
 
 static const struct genl_ops devlink_nl_ops[] = {
@@ -7364,6 +7385,20 @@ static struct genl_family devlink_nl_family __ro_after_init = {
 	.n_mcgrps	= ARRAY_SIZE(devlink_nl_mcgrps),
 };
 
+static int devlink_reload_actions_verify(struct devlink *devlink)
+{
+	const struct devlink_ops *ops;
+
+	if (!devlink_reload_supported(devlink))
+		return 0;
+
+	ops = devlink->ops;
+	if (WARN_ON(ops->supported_reload_actions >= BIT(__DEVLINK_RELOAD_ACTION_MAX) ||
+		    ops->supported_reload_actions <= BIT(DEVLINK_RELOAD_ACTION_UNSPEC)))
+		return -EINVAL;
+	return 0;
+}
+
 /**
  *	devlink_alloc - Allocate new devlink instance resources
  *
@@ -7384,6 +7419,11 @@ struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size)
 	if (!devlink)
 		return NULL;
 	devlink->ops = ops;
+	if (devlink_reload_actions_verify(devlink)) {
+		kfree(devlink);
+		return NULL;
+	}
+
 	xa_init_flags(&devlink->snapshot_ids, XA_FLAGS_ALLOC);
 	__devlink_net_set(devlink, &init_net);
 	INIT_LIST_HEAD(&devlink->port_list);
@@ -9615,7 +9655,8 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 		if (net_eq(devlink_net(devlink), net)) {
 			if (WARN_ON(!devlink_reload_supported(devlink)))
 				continue;
-			err = devlink_reload(devlink, &init_net, NULL);
+			err = devlink_reload(devlink, &init_net,
+					     DEVLINK_RELOAD_ACTION_DRIVER_REINIT, NULL);
 			if (err && err != -EOPNOTSUPP)
 				pr_warn("Failed to reload devlink instance into init_net\n");
 		}
-- 
2.17.1

