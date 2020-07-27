Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0C022EAC5
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 13:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbgG0LGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 07:06:52 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:40685 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728527AbgG0LGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 07:06:49 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 27 Jul 2020 14:06:11 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (dev-l-vrt-135.mtl.labs.mlnx [10.234.135.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 06RB6BI4022173;
        Mon, 27 Jul 2020 14:06:11 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Debian-10) with ESMTP id 06RB6Ban002384;
        Mon, 27 Jul 2020 14:06:11 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 06RB6BIk002383;
        Mon, 27 Jul 2020 14:06:11 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next RFC 01/13] devlink: Add reload level option to devlink reload command
Date:   Mon, 27 Jul 2020 14:02:21 +0300
Message-Id: <1595847753-2234-2-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
References: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add devlink reload level to allow the user to request a specific reload
level. The level parameter is optional, if not specified then driver's
default reload level is used (backward compatible).
Reload levels supported are:
driver: driver entities re-instantiation only.
fw_reset: firmware reset and driver entities re-instantiation.
fw_live_patch: firmware live patching only.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx4/main.c     |  6 ++-
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  6 ++-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  6 ++-
 drivers/net/netdevsim/dev.c                   |  6 ++-
 include/net/devlink.h                         |  6 ++-
 include/uapi/linux/devlink.h                  | 19 +++++++
 net/core/devlink.c                            | 52 +++++++++++++++++--
 7 files changed, 86 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 954c22c79f6b..57d9d4381cb0 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3935,7 +3935,7 @@ static int mlx4_restart_one_up(struct pci_dev *pdev, bool reload,
 			       struct devlink *devlink);
 
 static int mlx4_devlink_reload_down(struct devlink *devlink, bool netns_change,
-				    struct netlink_ext_ack *extack)
+				    enum devlink_reload_level level, struct netlink_ext_ack *extack)
 {
 	struct mlx4_priv *priv = devlink_priv(devlink);
 	struct mlx4_dev *dev = &priv->dev;
@@ -3951,7 +3951,7 @@ static int mlx4_devlink_reload_down(struct devlink *devlink, bool netns_change,
 	return 0;
 }
 
-static int mlx4_devlink_reload_up(struct devlink *devlink,
+static int mlx4_devlink_reload_up(struct devlink *devlink, enum devlink_reload_level level,
 				  struct netlink_ext_ack *extack)
 {
 	struct mlx4_priv *priv = devlink_priv(devlink);
@@ -3969,6 +3969,8 @@ static int mlx4_devlink_reload_up(struct devlink *devlink,
 
 static const struct devlink_ops mlx4_devlink_ops = {
 	.port_type_set	= mlx4_devlink_port_type_set,
+	.supported_reload_levels = BIT(DEVLINK_RELOAD_LEVEL_DRIVER),
+	.default_reload_level = DEVLINK_RELOAD_LEVEL_DRIVER,
 	.reload_down	= mlx4_devlink_reload_down,
 	.reload_up	= mlx4_devlink_reload_up,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index c709e9a385f6..5424e31a0f45 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -89,7 +89,7 @@ mlx5_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 }
 
 static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
-				    struct netlink_ext_ack *extack)
+				    enum devlink_reload_level level, struct netlink_ext_ack *extack)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 
@@ -97,7 +97,7 @@ static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 	return 0;
 }
 
-static int mlx5_devlink_reload_up(struct devlink *devlink,
+static int mlx5_devlink_reload_up(struct devlink *devlink, enum devlink_reload_level level,
 				  struct netlink_ext_ack *extack)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
@@ -118,6 +118,8 @@ static const struct devlink_ops mlx5_devlink_ops = {
 #endif
 	.flash_update = mlx5_devlink_flash_update,
 	.info_get = mlx5_devlink_info_get,
+	.supported_reload_levels = BIT(DEVLINK_RELOAD_LEVEL_DRIVER),
+	.default_reload_level = DEVLINK_RELOAD_LEVEL_DRIVER,
 	.reload_down = mlx5_devlink_reload_down,
 	.reload_up = mlx5_devlink_reload_up,
 };
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index b01f8f2fab63..360d749eb042 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1113,7 +1113,7 @@ mlxsw_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 
 static int
 mlxsw_devlink_core_bus_device_reload_down(struct devlink *devlink,
-					  bool netns_change,
+					  bool netns_change, enum devlink_reload_level level,
 					  struct netlink_ext_ack *extack)
 {
 	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
@@ -1126,7 +1126,7 @@ mlxsw_devlink_core_bus_device_reload_down(struct devlink *devlink,
 }
 
 static int
-mlxsw_devlink_core_bus_device_reload_up(struct devlink *devlink,
+mlxsw_devlink_core_bus_device_reload_up(struct devlink *devlink, enum devlink_reload_level level,
 					struct netlink_ext_ack *extack)
 {
 	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
@@ -1266,6 +1266,8 @@ mlxsw_devlink_trap_policer_counter_get(struct devlink *devlink,
 }
 
 static const struct devlink_ops mlxsw_devlink_ops = {
+	.supported_reload_levels	= BIT(DEVLINK_RELOAD_LEVEL_FW_RESET),
+	.default_reload_level		= DEVLINK_RELOAD_LEVEL_FW_RESET,
 	.reload_down		= mlxsw_devlink_core_bus_device_reload_down,
 	.reload_up		= mlxsw_devlink_core_bus_device_reload_up,
 	.port_type_set			= mlxsw_devlink_port_type_set,
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index ce719c830a77..680482f687f4 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -697,7 +697,7 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev);
 
 static int nsim_dev_reload_down(struct devlink *devlink, bool netns_change,
-				struct netlink_ext_ack *extack)
+				enum devlink_reload_level level, struct netlink_ext_ack *extack)
 {
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
 
@@ -713,7 +713,7 @@ static int nsim_dev_reload_down(struct devlink *devlink, bool netns_change,
 	return 0;
 }
 
-static int nsim_dev_reload_up(struct devlink *devlink,
+static int nsim_dev_reload_up(struct devlink *devlink, enum devlink_reload_level level,
 			      struct netlink_ext_ack *extack)
 {
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
@@ -873,6 +873,8 @@ nsim_dev_devlink_trap_policer_counter_get(struct devlink *devlink,
 }
 
 static const struct devlink_ops nsim_dev_devlink_ops = {
+	.supported_reload_levels = BIT(DEVLINK_RELOAD_LEVEL_DRIVER),
+	.default_reload_level = DEVLINK_RELOAD_LEVEL_DRIVER,
 	.reload_down = nsim_dev_reload_down,
 	.reload_up = nsim_dev_reload_up,
 	.info_get = nsim_dev_info_get,
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 19d990c8edcc..b291cd8d6be6 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -985,9 +985,11 @@ enum devlink_trap_group_generic_id {
 	}
 
 struct devlink_ops {
+	unsigned long supported_reload_levels;
+	enum devlink_reload_level default_reload_level;
 	int (*reload_down)(struct devlink *devlink, bool netns_change,
-			   struct netlink_ext_ack *extack);
-	int (*reload_up)(struct devlink *devlink,
+			   enum devlink_reload_level level, struct netlink_ext_ack *extack);
+	int (*reload_up)(struct devlink *devlink, enum devlink_reload_level level,
 			 struct netlink_ext_ack *extack);
 	int (*port_type_set)(struct devlink_port *devlink_port,
 			     enum devlink_port_type port_type);
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index cfef4245ea5a..fa5f66db5012 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -272,6 +272,23 @@ enum {
 	DEVLINK_ATTR_TRAP_METADATA_TYPE_FA_COOKIE,
 };
 
+/**
+ * enum devlink_reload_level - Reload level.
+ * @DEVLINK_RELOAD_LEVEL_DRIVER: Driver entities re-instantiation only.
+ * @DEVLINK_RELOAD_LEVEL_FW_RESET: FW reset and driver entities re-instantiation.
+ * @DEVLINK_RELOAD_LEVEL_FW_LIVE_PATCH: FW live patching only.
+ */
+enum devlink_reload_level {
+	DEVLINK_RELOAD_LEVEL_UNSPEC,
+	DEVLINK_RELOAD_LEVEL_DRIVER,
+	DEVLINK_RELOAD_LEVEL_FW_RESET,
+	DEVLINK_RELOAD_LEVEL_FW_LIVE_PATCH,
+
+	/* Add new reload levels above */
+	__DEVLINK_RELOAD_LEVEL_MAX,
+	DEVLINK_RELOAD_LEVEL_MAX = __DEVLINK_RELOAD_LEVEL_MAX - 1
+};
+
 enum devlink_attr {
 	/* don't change the order or add anything between, this is ABI! */
 	DEVLINK_ATTR_UNSPEC,
@@ -458,6 +475,8 @@ enum devlink_attr {
 	DEVLINK_ATTR_PORT_LANES,			/* u32 */
 	DEVLINK_ATTR_PORT_SPLITTABLE,			/* u8 */
 
+	DEVLINK_ATTR_RELOAD_LEVEL,		/* u8 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 0ca89196a367..31b367a1612d 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -462,6 +462,12 @@ static int devlink_nl_put_handle(struct sk_buff *msg, struct devlink *devlink)
 	return 0;
 }
 
+static bool
+devlink_reload_level_is_supported(struct devlink *devlink, enum devlink_reload_level level)
+{
+	return test_bit(level, &devlink->ops->supported_reload_levels);
+}
+
 static int devlink_nl_fill(struct sk_buff *msg, struct devlink *devlink,
 			   enum devlink_command cmd, u32 portid,
 			   u32 seq, int flags)
@@ -2958,21 +2964,21 @@ bool devlink_is_reload_failed(const struct devlink *devlink)
 EXPORT_SYMBOL_GPL(devlink_is_reload_failed);
 
 static int devlink_reload(struct devlink *devlink, struct net *dest_net,
-			  struct netlink_ext_ack *extack)
+			  enum devlink_reload_level level, struct netlink_ext_ack *extack)
 {
 	int err;
 
 	if (!devlink->reload_enabled)
 		return -EOPNOTSUPP;
 
-	err = devlink->ops->reload_down(devlink, !!dest_net, extack);
+	err = devlink->ops->reload_down(devlink, !!dest_net, level, extack);
 	if (err)
 		return err;
 
 	if (dest_net && !net_eq(dest_net, devlink_net(devlink)))
 		devlink_reload_netns_change(devlink, dest_net);
 
-	err = devlink->ops->reload_up(devlink, extack);
+	err = devlink->ops->reload_up(devlink, level, extack);
 	devlink_reload_failed_set(devlink, !!err);
 	return err;
 }
@@ -2980,6 +2986,7 @@ static int devlink_reload(struct devlink *devlink, struct net *dest_net,
 static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 {
 	struct devlink *devlink = info->user_ptr[0];
+	enum devlink_reload_level level;
 	struct net *dest_net = NULL;
 	int err;
 
@@ -3000,7 +3007,20 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 			return PTR_ERR(dest_net);
 	}
 
-	err = devlink_reload(devlink, dest_net, info->extack);
+	if (info->attrs[DEVLINK_ATTR_RELOAD_LEVEL])
+		level = nla_get_u8(info->attrs[DEVLINK_ATTR_RELOAD_LEVEL]);
+	else
+		level = devlink->ops->default_reload_level;
+
+	if (level == DEVLINK_RELOAD_LEVEL_UNSPEC || level > DEVLINK_RELOAD_LEVEL_MAX) {
+		NL_SET_ERR_MSG_MOD(info->extack, "Invalid reload level");
+		return -EINVAL;
+	} else if (!devlink_reload_level_is_supported(devlink, level)) {
+		NL_SET_ERR_MSG_MOD(info->extack, "Requested reload level is not supported");
+		return -EOPNOTSUPP;
+	}
+
+	err = devlink_reload(devlink, dest_net, level, info->extack);
 
 	if (dest_net)
 		put_net(dest_net);
@@ -7026,6 +7046,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_TRAP_POLICER_RATE] = { .type = NLA_U64 },
 	[DEVLINK_ATTR_TRAP_POLICER_BURST] = { .type = NLA_U64 },
 	[DEVLINK_ATTR_PORT_FUNCTION] = { .type = NLA_NESTED },
+	[DEVLINK_ATTR_RELOAD_LEVEL] = { .type = NLA_U8 },
 };
 
 static const struct genl_ops devlink_nl_ops[] = {
@@ -7351,6 +7372,21 @@ static struct genl_family devlink_nl_family __ro_after_init = {
 	.n_mcgrps	= ARRAY_SIZE(devlink_nl_mcgrps),
 };
 
+static int devlink_reload_levels_verify(struct devlink *devlink)
+{
+	const struct devlink_ops *ops;
+
+	if (!devlink_reload_supported(devlink))
+		return 0;
+
+	ops = devlink->ops;
+	if (WARN_ON(ops->supported_reload_levels >= BIT(__DEVLINK_RELOAD_LEVEL_MAX) ||
+		    ops->supported_reload_levels & BIT(DEVLINK_RELOAD_LEVEL_UNSPEC) ||
+		    !(ops->supported_reload_levels & BIT(ops->default_reload_level))))
+		return -EINVAL;
+	return 0;
+}
+
 /**
  *	devlink_alloc - Allocate new devlink instance resources
  *
@@ -7371,6 +7407,11 @@ struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size)
 	if (!devlink)
 		return NULL;
 	devlink->ops = ops;
+	if (devlink_reload_levels_verify(devlink)) {
+		kfree(devlink);
+		return NULL;
+	}
+
 	xa_init_flags(&devlink->snapshot_ids, XA_FLAGS_ALLOC);
 	__devlink_net_set(devlink, &init_net);
 	INIT_LIST_HEAD(&devlink->port_list);
@@ -9599,7 +9640,8 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 		if (net_eq(devlink_net(devlink), net)) {
 			if (WARN_ON(!devlink_reload_supported(devlink)))
 				continue;
-			err = devlink_reload(devlink, &init_net, NULL);
+			err = devlink_reload(devlink, &init_net,
+					     devlink->ops->default_reload_level, NULL);
 			if (err && err != -EOPNOTSUPP)
 				pr_warn("Failed to reload devlink instance into init_net\n");
 		}
-- 
2.17.1

