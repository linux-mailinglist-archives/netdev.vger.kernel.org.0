Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4242800B7
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 16:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732628AbgJAOBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 10:01:24 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:36624 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732424AbgJAOAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 10:00:31 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 1 Oct 2020 17:00:24 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (dev-l-vrt-136.mtl.labs.mlnx [10.234.136.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 091E0Oqe001794;
        Thu, 1 Oct 2020 17:00:24 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7) with ESMTP id 091E0NTH011165;
        Thu, 1 Oct 2020 17:00:23 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7/Submit) id 091E0NS3011164;
        Thu, 1 Oct 2020 17:00:23 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next 03/16] devlink: Add devlink reload limit option
Date:   Thu,  1 Oct 2020 16:59:06 +0300
Message-Id: <1601560759-11030-4-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
References: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add reload limit to demand restrictions on reload actions.
Reload limits supported:
no_reset: No reset allowed, no down time allowed, no link flap and no
          configuration is lost.

By default reload limit is unspecified and so no constrains on reload
actions are required.

Some combinations of action and limit are invalid. For example, driver
can not reinitialize its entities without any downtime.

The no_reset reload limit will have usecase in this patchset to
implement restricted fw_activate on mlx5.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
---
RFCv5 -> v1:
- Renamed supported_reload_actions_limit_levels to reload_limits
- Renamed reload_action_limit_level to reload_limit
- Change RELOAD_LIMIT_NONE to unspecified RELOAD_LIMIT_UNSPEC,
  drivers don't need to declare support limits if they support only
  no limitation
- Use nla_poilcy range validation and remove the range check in
devlink_nl_cmd_reload
RFCv4 -> RFCv5:
- Remove check DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX
- Added list of invalid action-limit_level combinations and add check to
  supported actions and levels and check user request
RFCv3 -> RFCv4:
- New patch
---
 drivers/net/ethernet/mellanox/mlx4/main.c     |  4 +-
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  2 +
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  2 +
 drivers/net/netdevsim/dev.c                   |  6 +-
 include/net/devlink.h                         |  6 +-
 include/uapi/linux/devlink.h                  | 18 +++++
 net/core/devlink.c                            | 76 +++++++++++++++++--
 7 files changed, 104 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index a44d8b733db3..f07287ebe473 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3947,6 +3947,7 @@ static int mlx4_restart_one_up(struct pci_dev *pdev, bool reload,
 
 static int mlx4_devlink_reload_down(struct devlink *devlink, bool netns_change,
 				    enum devlink_reload_action action,
+				    enum devlink_reload_limit limit,
 				    struct netlink_ext_ack *extack)
 {
 	struct mlx4_priv *priv = devlink_priv(devlink);
@@ -3964,7 +3965,8 @@ static int mlx4_devlink_reload_down(struct devlink *devlink, bool netns_change,
 }
 
 static int mlx4_devlink_reload_up(struct devlink *devlink, enum devlink_reload_action action,
-				  struct netlink_ext_ack *extack, unsigned long *actions_performed)
+				  enum devlink_reload_limit limit, struct netlink_ext_ack *extack,
+				  unsigned long *actions_performed)
 {
 	struct mlx4_priv *priv = devlink_priv(devlink);
 	struct mlx4_dev *dev = &priv->dev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 35aceab79a50..47f3dbc80c7c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -86,6 +86,7 @@ mlx5_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 
 static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 				    enum devlink_reload_action action,
+				    enum devlink_reload_limit limit,
 				    struct netlink_ext_ack *extack)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
@@ -95,6 +96,7 @@ static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 }
 
 static int mlx5_devlink_reload_up(struct devlink *devlink, enum devlink_reload_action action,
+				  enum devlink_reload_limit limit,
 				  struct netlink_ext_ack *extack, unsigned long *actions_performed)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 35b800dba6f5..6d9026ba0f5e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1415,6 +1415,7 @@ mlxsw_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 static int
 mlxsw_devlink_core_bus_device_reload_down(struct devlink *devlink,
 					  bool netns_change, enum devlink_reload_action action,
+					  enum devlink_reload_limit limit,
 					  struct netlink_ext_ack *extack)
 {
 	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
@@ -1428,6 +1429,7 @@ mlxsw_devlink_core_bus_device_reload_down(struct devlink *devlink,
 
 static int
 mlxsw_devlink_core_bus_device_reload_up(struct devlink *devlink, enum devlink_reload_action action,
+					enum devlink_reload_limit limit,
 					struct netlink_ext_ack *extack,
 					unsigned long *actions_performed)
 {
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index e1973d752148..c2113af47b61 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -701,7 +701,8 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev);
 
 static int nsim_dev_reload_down(struct devlink *devlink, bool netns_change,
-				enum devlink_reload_action action, struct netlink_ext_ack *extack)
+				enum devlink_reload_action action, enum devlink_reload_limit limit,
+				struct netlink_ext_ack *extack)
 {
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
 
@@ -718,7 +719,8 @@ static int nsim_dev_reload_down(struct devlink *devlink, bool netns_change,
 }
 
 static int nsim_dev_reload_up(struct devlink *devlink, enum devlink_reload_action action,
-			      struct netlink_ext_ack *extack, unsigned long *actions_performed)
+			      enum devlink_reload_limit limit, struct netlink_ext_ack *extack,
+			      unsigned long *actions_performed)
 {
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
 
diff --git a/include/net/devlink.h b/include/net/devlink.h
index ddba63bce7ad..43dde69086e5 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1078,9 +1078,13 @@ struct devlink_ops {
 	 */
 	u32 supported_flash_update_params;
 	unsigned long reload_actions;
+	unsigned long reload_limits;
 	int (*reload_down)(struct devlink *devlink, bool netns_change,
-			   enum devlink_reload_action action, struct netlink_ext_ack *extack);
+			   enum devlink_reload_action action,
+			   enum devlink_reload_limit limit,
+			   struct netlink_ext_ack *extack);
 	int (*reload_up)(struct devlink *devlink, enum devlink_reload_action action,
+			 enum devlink_reload_limit limit,
 			 struct netlink_ext_ack *extack, unsigned long *actions_performed);
 	int (*port_type_set)(struct devlink_port *devlink_port,
 			     enum devlink_port_type port_type);
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index f1782eaf0be4..cc5dc4c07b4a 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -313,6 +313,23 @@ enum devlink_reload_action {
 	DEVLINK_RELOAD_ACTION_MAX = __DEVLINK_RELOAD_ACTION_MAX - 1
 };
 
+/**
+ * enum devlink_reload_limit - Reload limit.
+ * @DEVLINK_RELOAD_LIMIT_NO_RESET: No reset allowed, no down time allowed,
+ *                                 no link flap and no configuration is lost.
+ *
+ * Note that by default reload limit is unspecified and so no constrains on
+ * reload action.
+ */
+enum devlink_reload_limit {
+	DEVLINK_RELOAD_LIMIT_UNSPEC,
+	DEVLINK_RELOAD_LIMIT_NO_RESET,
+
+	/* Add new reload limit above */
+	__DEVLINK_RELOAD_LIMIT_MAX,
+	DEVLINK_RELOAD_LIMIT_MAX = __DEVLINK_RELOAD_LIMIT_MAX - 1
+};
+
 enum devlink_attr {
 	/* don't change the order or add anything between, this is ABI! */
 	DEVLINK_ATTR_UNSPEC,
@@ -507,6 +524,7 @@ enum devlink_attr {
 
 	DEVLINK_ATTR_RELOAD_ACTION,		/* u8 */
 	DEVLINK_ATTR_RELOAD_ACTIONS_PERFORMED,	/* u64 */
+	DEVLINK_ATTR_RELOAD_LIMIT,	/* u8 */
 
 	/* add new attributes above here, update the policy in devlink.c */
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 6f39dc76370e..6de7d6aa6ed1 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -462,12 +462,44 @@ static int devlink_nl_put_handle(struct sk_buff *msg, struct devlink *devlink)
 	return 0;
 }
 
+struct devlink_reload_combination {
+	enum devlink_reload_action action;
+	enum devlink_reload_limit limit;
+};
+
+static const struct devlink_reload_combination devlink_reload_invalid_combinations[] = {
+	{
+		/* can't reinitialize driver with no down time */
+		.action = DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
+		.limit = DEVLINK_RELOAD_LIMIT_NO_RESET,
+	},
+};
+
+static bool
+devlink_reload_combination_is_invalid(enum devlink_reload_action action,
+				      enum devlink_reload_limit limit)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(devlink_reload_invalid_combinations); i++)
+		if (devlink_reload_invalid_combinations[i].action == action &&
+		    devlink_reload_invalid_combinations[i].limit == limit)
+			return true;
+	return false;
+}
+
 static bool
 devlink_reload_action_is_supported(struct devlink *devlink, enum devlink_reload_action action)
 {
 	return test_bit(action, &devlink->ops->reload_actions);
 }
 
+static bool
+devlink_reload_limit_is_supported(struct devlink *devlink, enum devlink_reload_limit limit)
+{
+	return test_bit(limit, &devlink->ops->reload_limits);
+}
+
 static int devlink_nl_fill(struct sk_buff *msg, struct devlink *devlink,
 			   enum devlink_command cmd, u32 portid,
 			   u32 seq, int flags)
@@ -2973,22 +3005,22 @@ bool devlink_is_reload_failed(const struct devlink *devlink)
 EXPORT_SYMBOL_GPL(devlink_is_reload_failed);
 
 static int devlink_reload(struct devlink *devlink, struct net *dest_net,
-			  enum devlink_reload_action action, struct netlink_ext_ack *extack,
-			  unsigned long *actions_performed)
+			  enum devlink_reload_action action, enum devlink_reload_limit limit,
+			  struct netlink_ext_ack *extack, unsigned long *actions_performed)
 {
 	int err;
 
 	if (!devlink->reload_enabled)
 		return -EOPNOTSUPP;
 
-	err = devlink->ops->reload_down(devlink, !!dest_net, action, extack);
+	err = devlink->ops->reload_down(devlink, !!dest_net, action, limit, extack);
 	if (err)
 		return err;
 
 	if (dest_net && !net_eq(dest_net, devlink_net(devlink)))
 		devlink_reload_netns_change(devlink, dest_net);
 
-	err = devlink->ops->reload_up(devlink, action, extack, actions_performed);
+	err = devlink->ops->reload_up(devlink, action, limit, extack, actions_performed);
 	devlink_reload_failed_set(devlink, !!err);
 	if (err)
 		return err;
@@ -3032,6 +3064,7 @@ devlink_nl_reload_actions_performed_snd(struct devlink *devlink,
 
 static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 {
+	enum devlink_reload_limit limit;
 	struct devlink *devlink = info->user_ptr[0];
 	enum devlink_reload_action action;
 	unsigned long actions_performed;
@@ -3066,7 +3099,21 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 		return -EOPNOTSUPP;
 	}
 
-	err = devlink_reload(devlink, dest_net, action, info->extack, &actions_performed);
+	limit = DEVLINK_RELOAD_LIMIT_UNSPEC;
+	if (info->attrs[DEVLINK_ATTR_RELOAD_LIMIT]) {
+		limit = nla_get_u8(info->attrs[DEVLINK_ATTR_RELOAD_LIMIT]);
+		if (!devlink_reload_limit_is_supported(devlink, limit)) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "Requested limit is not supported by the driver");
+			return -EOPNOTSUPP;
+		}
+		if (devlink_reload_combination_is_invalid(action, limit)) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "Requested limit is invalid for this action");
+			return -EINVAL;
+		}
+	}
+	err = devlink_reload(devlink, dest_net, action, limit, info->extack, &actions_performed);
 
 	if (dest_net)
 		put_net(dest_net);
@@ -3074,7 +3121,7 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		return err;
 	/* For backward compatibility generate reply only if attributes used by user */
-	if (!info->attrs[DEVLINK_ATTR_RELOAD_ACTION])
+	if (!info->attrs[DEVLINK_ATTR_RELOAD_ACTION] && !info->attrs[DEVLINK_ATTR_RELOAD_LIMIT])
 		return 0;
 
 	return devlink_nl_reload_actions_performed_snd(devlink, actions_performed,
@@ -7185,6 +7232,8 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_PORT_FUNCTION] = { .type = NLA_NESTED },
 	[DEVLINK_ATTR_RELOAD_ACTION] = NLA_POLICY_RANGE(NLA_U8, DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
 							DEVLINK_RELOAD_ACTION_MAX),
+	[DEVLINK_ATTR_RELOAD_LIMIT] = NLA_POLICY_RANGE(NLA_U8, DEVLINK_RELOAD_LIMIT_NO_RESET,
+						       DEVLINK_RELOAD_LIMIT_MAX),
 };
 
 static const struct genl_ops devlink_nl_ops[] = {
@@ -7520,6 +7569,9 @@ static struct genl_family devlink_nl_family __ro_after_init = {
 
 static bool devlink_reload_actions_valid(const struct devlink_ops *ops)
 {
+	const struct devlink_reload_combination *comb;
+	int i;
+
 	if (!devlink_reload_supported(ops)) {
 		if (WARN_ON(ops->reload_actions))
 			return false;
@@ -7530,6 +7582,17 @@ static bool devlink_reload_actions_valid(const struct devlink_ops *ops)
 		    ops->reload_actions & BIT(DEVLINK_RELOAD_ACTION_UNSPEC) ||
 		    ops->reload_actions >= BIT(__DEVLINK_RELOAD_ACTION_MAX)))
 		return false;
+
+	if (WARN_ON(ops->reload_limits & BIT(DEVLINK_RELOAD_LIMIT_UNSPEC) ||
+		    ops->reload_limits >= BIT(__DEVLINK_RELOAD_LIMIT_MAX)))
+		return false;
+
+	for (i = 0; i < ARRAY_SIZE(devlink_reload_invalid_combinations); i++)  {
+		comb = &devlink_reload_invalid_combinations[i];
+		if (ops->reload_actions == BIT(comb->action) &&
+		    ops->reload_limits == BIT(comb->limit))
+			return false;
+	}
 	return true;
 }
 
@@ -9822,6 +9885,7 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 				continue;
 			err = devlink_reload(devlink, &init_net,
 					     DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
+					     DEVLINK_RELOAD_LIMIT_UNSPEC,
 					     NULL, &actions_performed);
 			if (err && err != -EOPNOTSUPP)
 				pr_warn("Failed to reload devlink instance into init_net\n");
-- 
2.18.2

