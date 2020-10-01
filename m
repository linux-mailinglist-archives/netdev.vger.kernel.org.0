Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866A02800A8
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 16:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732550AbgJAOAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 10:00:38 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:36628 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732441AbgJAOAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 10:00:30 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 1 Oct 2020 17:00:23 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (dev-l-vrt-136.mtl.labs.mlnx [10.234.136.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 091E0Nbq001769;
        Thu, 1 Oct 2020 17:00:23 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7) with ESMTP id 091E0Nkf011163;
        Thu, 1 Oct 2020 17:00:23 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7/Submit) id 091E0N7X011162;
        Thu, 1 Oct 2020 17:00:23 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next 02/16] devlink: Add reload action option to devlink reload command
Date:   Thu,  1 Oct 2020 16:59:05 +0300
Message-Id: <1601560759-11030-3-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
References: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add devlink reload action to allow the user to request a specific reload
action. The action parameter is optional, if not specified then devlink
driver re-init action is used (backward compatible).
Note that when required to do firmware activation some drivers may need
to reload the driver. On the other hand some drivers may need to reset
the firmware to reinitialize the driver entities. Therefore, the devlink
reload command returns the actions which were actually performed.
Reload actions supported are:
driver_reinit: driver entities re-initialization, applying devlink-param
               and devlink-resource values.
fw_activate: firmware activate.

command examples:
$devlink dev reload pci/0000:82:00.0 action driver_reinit
reload_actions_performed:
  driver_reinit

$devlink dev reload pci/0000:82:00.0 action fw_activate
reload_actions_performed:
  driver_reinit fw_activate

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
---
RFCv5 -> v1:
- Rename supported_reload_actions to reload_actions.
- Rename devlink_nl_reload_actions_performed_fill() to
devlink_nl_reload_actions_performed_snd() and add genlmsg_reply() to it
- Actions_performed sent to user space as a mask
- Driver can initialize actions_performed before done as devlink ignores
in case of failure
- Use nla_poilcy range validation and remove the range check in
devlink_nl_cmd_reload
RFCv4 -> RFCv5:
- Always pass actions_performed to unload_up() instead of checking in
  each driver
- Verify returned actions_performed includes the requested action
- Changed  devlink_reload_actions_verify(devlink) to get ops
- Changed  devlink_reload_actions_verify() to return bool and rename to
  devlink_reload_actions_valid()
-  Only generate the reply if request uses new attributes
RFCv3 -> RFCv4:
- Removed fw_activate_no_reset as an action (next patch adds limit
  levels instead).
- Renamed actions_done to actions_performed
RFCv2 -> RFCv3:
- Replace fw_live_patch action by fw_activate_no_reset
- Devlink reload returns the actions done over netlink reply
RFCv1 -> RFCv2:
- Instead of reload levels driver,fw_reset,fw_live_patch have reload
  actions driver_reinit,fw_activate,fw_live_patch
- Remove driver default level, the action driver_reinit is the default
  action for all drivers
---
 drivers/net/ethernet/mellanox/mlx4/main.c     |   7 +-
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   7 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  11 +-
 drivers/net/netdevsim/dev.c                   |   8 +-
 include/net/devlink.h                         |   7 +-
 include/uapi/linux/devlink.h                  |  18 ++++
 net/core/devlink.c                            | 101 ++++++++++++++++--
 7 files changed, 139 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 70cf24ba71e4..a44d8b733db3 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3946,6 +3946,7 @@ static int mlx4_restart_one_up(struct pci_dev *pdev, bool reload,
 			       struct devlink *devlink);
 
 static int mlx4_devlink_reload_down(struct devlink *devlink, bool netns_change,
+				    enum devlink_reload_action action,
 				    struct netlink_ext_ack *extack)
 {
 	struct mlx4_priv *priv = devlink_priv(devlink);
@@ -3962,14 +3963,15 @@ static int mlx4_devlink_reload_down(struct devlink *devlink, bool netns_change,
 	return 0;
 }
 
-static int mlx4_devlink_reload_up(struct devlink *devlink,
-				  struct netlink_ext_ack *extack)
+static int mlx4_devlink_reload_up(struct devlink *devlink, enum devlink_reload_action action,
+				  struct netlink_ext_ack *extack, unsigned long *actions_performed)
 {
 	struct mlx4_priv *priv = devlink_priv(devlink);
 	struct mlx4_dev *dev = &priv->dev;
 	struct mlx4_dev_persistent *persist = dev->persist;
 	int err;
 
+	*actions_performed = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
 	err = mlx4_restart_one_up(persist->pdev, true, devlink);
 	if (err)
 		mlx4_err(persist->dev, "mlx4_restart_one_up failed, ret=%d\n",
@@ -3980,6 +3982,7 @@ static int mlx4_devlink_reload_up(struct devlink *devlink,
 
 static const struct devlink_ops mlx4_devlink_ops = {
 	.port_type_set	= mlx4_devlink_port_type_set,
+	.reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT),
 	.reload_down	= mlx4_devlink_reload_down,
 	.reload_up	= mlx4_devlink_reload_up,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 9b14e3f805a2..35aceab79a50 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -85,6 +85,7 @@ mlx5_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 }
 
 static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
+				    enum devlink_reload_action action,
 				    struct netlink_ext_ack *extack)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
@@ -93,11 +94,12 @@ static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 	return 0;
 }
 
-static int mlx5_devlink_reload_up(struct devlink *devlink,
-				  struct netlink_ext_ack *extack)
+static int mlx5_devlink_reload_up(struct devlink *devlink, enum devlink_reload_action action,
+				  struct netlink_ext_ack *extack, unsigned long *actions_performed)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 
+	*actions_performed = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
 	return mlx5_load_one(dev, false);
 }
 
@@ -114,6 +116,7 @@ static const struct devlink_ops mlx5_devlink_ops = {
 #endif
 	.flash_update = mlx5_devlink_flash_update,
 	.info_get = mlx5_devlink_info_get,
+	.reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT),
 	.reload_down = mlx5_devlink_reload_down,
 	.reload_up = mlx5_devlink_reload_up,
 };
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index a21afa56e3f7..35b800dba6f5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1414,7 +1414,7 @@ mlxsw_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 
 static int
 mlxsw_devlink_core_bus_device_reload_down(struct devlink *devlink,
-					  bool netns_change,
+					  bool netns_change, enum devlink_reload_action action,
 					  struct netlink_ext_ack *extack)
 {
 	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
@@ -1427,11 +1427,14 @@ mlxsw_devlink_core_bus_device_reload_down(struct devlink *devlink,
 }
 
 static int
-mlxsw_devlink_core_bus_device_reload_up(struct devlink *devlink,
-					struct netlink_ext_ack *extack)
+mlxsw_devlink_core_bus_device_reload_up(struct devlink *devlink, enum devlink_reload_action action,
+					struct netlink_ext_ack *extack,
+					unsigned long *actions_performed)
 {
 	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
 
+	*actions_performed = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
+			     BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE);
 	return mlxsw_core_bus_device_register(mlxsw_core->bus_info,
 					      mlxsw_core->bus,
 					      mlxsw_core->bus_priv, true,
@@ -1564,6 +1567,8 @@ mlxsw_devlink_trap_policer_counter_get(struct devlink *devlink,
 }
 
 static const struct devlink_ops mlxsw_devlink_ops = {
+	.reload_actions		= BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
+				  BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
 	.reload_down		= mlxsw_devlink_core_bus_device_reload_down,
 	.reload_up		= mlxsw_devlink_core_bus_device_reload_up,
 	.port_type_set			= mlxsw_devlink_port_type_set,
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 56213ba151f6..e1973d752148 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -701,7 +701,7 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev);
 
 static int nsim_dev_reload_down(struct devlink *devlink, bool netns_change,
-				struct netlink_ext_ack *extack)
+				enum devlink_reload_action action, struct netlink_ext_ack *extack)
 {
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
 
@@ -717,8 +717,8 @@ static int nsim_dev_reload_down(struct devlink *devlink, bool netns_change,
 	return 0;
 }
 
-static int nsim_dev_reload_up(struct devlink *devlink,
-			      struct netlink_ext_ack *extack)
+static int nsim_dev_reload_up(struct devlink *devlink, enum devlink_reload_action action,
+			      struct netlink_ext_ack *extack, unsigned long *actions_performed)
 {
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
 
@@ -730,6 +730,7 @@ static int nsim_dev_reload_up(struct devlink *devlink,
 		return -EINVAL;
 	}
 
+	*actions_performed = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
 	return nsim_dev_reload_create(nsim_dev, extack);
 }
 
@@ -886,6 +887,7 @@ nsim_dev_devlink_trap_policer_counter_get(struct devlink *devlink,
 static const struct devlink_ops nsim_dev_devlink_ops = {
 	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT |
 					 DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK,
+	.reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT),
 	.reload_down = nsim_dev_reload_down,
 	.reload_up = nsim_dev_reload_up,
 	.info_get = nsim_dev_info_get,
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 1c286e9a3590..ddba63bce7ad 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1077,10 +1077,11 @@ struct devlink_ops {
 	 * implemementation.
 	 */
 	u32 supported_flash_update_params;
+	unsigned long reload_actions;
 	int (*reload_down)(struct devlink *devlink, bool netns_change,
-			   struct netlink_ext_ack *extack);
-	int (*reload_up)(struct devlink *devlink,
-			 struct netlink_ext_ack *extack);
+			   enum devlink_reload_action action, struct netlink_ext_ack *extack);
+	int (*reload_up)(struct devlink *devlink, enum devlink_reload_action action,
+			 struct netlink_ext_ack *extack, unsigned long *actions_performed);
 	int (*port_type_set)(struct devlink_port *devlink_port,
 			     enum devlink_port_type port_type);
 	int (*port_split)(struct devlink *devlink, unsigned int port_index,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index ba467dc07852..f1782eaf0be4 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -298,6 +298,21 @@ enum {
 	DEVLINK_ATTR_TRAP_METADATA_TYPE_FA_COOKIE,
 };
 
+/**
+ * enum devlink_reload_action - Reload action.
+ * @DEVLINK_RELOAD_ACTION_DRIVER_REINIT: Driver entities re-instantiation.
+ * @DEVLINK_RELOAD_ACTION_FW_ACTIVATE: FW activate.
+ */
+enum devlink_reload_action {
+	DEVLINK_RELOAD_ACTION_UNSPEC,
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
@@ -490,6 +505,9 @@ enum devlink_attr {
 	DEVLINK_ATTR_FLASH_UPDATE_STATUS_TIMEOUT,	/* u64 */
 	DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK,	/* bitfield32 */
 
+	DEVLINK_ATTR_RELOAD_ACTION,		/* u8 */
+	DEVLINK_ATTR_RELOAD_ACTIONS_PERFORMED,	/* u64 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 722a9431ff60..6f39dc76370e 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -462,6 +462,12 @@ static int devlink_nl_put_handle(struct sk_buff *msg, struct devlink *devlink)
 	return 0;
 }
 
+static bool
+devlink_reload_action_is_supported(struct devlink *devlink, enum devlink_reload_action action)
+{
+	return test_bit(action, &devlink->ops->reload_actions);
+}
+
 static int devlink_nl_fill(struct sk_buff *msg, struct devlink *devlink,
 			   enum devlink_command cmd, u32 portid,
 			   u32 seq, int flags)
@@ -2967,28 +2973,68 @@ bool devlink_is_reload_failed(const struct devlink *devlink)
 EXPORT_SYMBOL_GPL(devlink_is_reload_failed);
 
 static int devlink_reload(struct devlink *devlink, struct net *dest_net,
-			  struct netlink_ext_ack *extack)
+			  enum devlink_reload_action action, struct netlink_ext_ack *extack,
+			  unsigned long *actions_performed)
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
+	err = devlink->ops->reload_up(devlink, action, extack, actions_performed);
 	devlink_reload_failed_set(devlink, !!err);
-	return err;
+	if (err)
+		return err;
+
+	WARN_ON(!test_bit(action, actions_performed));
+	return 0;
+}
+
+static int
+devlink_nl_reload_actions_performed_snd(struct devlink *devlink,
+					unsigned long actions_performed,
+					enum devlink_command cmd, struct genl_info *info)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = genlmsg_put(msg, info->snd_portid, info->snd_seq, &devlink_nl_family, 0, cmd);
+	if (!hdr)
+		goto free_msg;
+
+	if (devlink_nl_put_handle(msg, devlink))
+		goto nla_put_failure;
+
+	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_RELOAD_ACTIONS_PERFORMED, actions_performed,
+			      DEVLINK_ATTR_PAD))
+		goto nla_put_failure;
+	genlmsg_end(msg, hdr);
+
+	return genlmsg_reply(msg, info);
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+free_msg:
+	nlmsg_free(msg);
+	return -EMSGSIZE;
 }
 
 static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 {
 	struct devlink *devlink = info->user_ptr[0];
+	enum devlink_reload_action action;
+	unsigned long actions_performed;
 	struct net *dest_net = NULL;
 	int err;
 
@@ -3009,12 +3055,30 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 			return PTR_ERR(dest_net);
 	}
 
-	err = devlink_reload(devlink, dest_net, info->extack);
+	if (info->attrs[DEVLINK_ATTR_RELOAD_ACTION])
+		action = nla_get_u8(info->attrs[DEVLINK_ATTR_RELOAD_ACTION]);
+	else
+		action = DEVLINK_RELOAD_ACTION_DRIVER_REINIT;
+
+	if (!devlink_reload_action_is_supported(devlink, action)) {
+		NL_SET_ERR_MSG_MOD(info->extack,
+				   "Requested reload action is not supported by the driver");
+		return -EOPNOTSUPP;
+	}
+
+	err = devlink_reload(devlink, dest_net, action, info->extack, &actions_performed);
 
 	if (dest_net)
 		put_net(dest_net);
 
-	return err;
+	if (err)
+		return err;
+	/* For backward compatibility generate reply only if attributes used by user */
+	if (!info->attrs[DEVLINK_ATTR_RELOAD_ACTION])
+		return 0;
+
+	return devlink_nl_reload_actions_performed_snd(devlink, actions_performed,
+						       DEVLINK_CMD_RELOAD, info);
 }
 
 static int devlink_nl_flash_update_fill(struct sk_buff *msg,
@@ -7119,6 +7183,8 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_TRAP_POLICER_RATE] = { .type = NLA_U64 },
 	[DEVLINK_ATTR_TRAP_POLICER_BURST] = { .type = NLA_U64 },
 	[DEVLINK_ATTR_PORT_FUNCTION] = { .type = NLA_NESTED },
+	[DEVLINK_ATTR_RELOAD_ACTION] = NLA_POLICY_RANGE(NLA_U8, DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
+							DEVLINK_RELOAD_ACTION_MAX),
 };
 
 static const struct genl_ops devlink_nl_ops[] = {
@@ -7452,6 +7518,21 @@ static struct genl_family devlink_nl_family __ro_after_init = {
 	.n_mcgrps	= ARRAY_SIZE(devlink_nl_mcgrps),
 };
 
+static bool devlink_reload_actions_valid(const struct devlink_ops *ops)
+{
+	if (!devlink_reload_supported(ops)) {
+		if (WARN_ON(ops->reload_actions))
+			return false;
+		return true;
+	}
+
+	if (WARN_ON(!ops->reload_actions ||
+		    ops->reload_actions & BIT(DEVLINK_RELOAD_ACTION_UNSPEC) ||
+		    ops->reload_actions >= BIT(__DEVLINK_RELOAD_ACTION_MAX)))
+		return false;
+	return true;
+}
+
 /**
  *	devlink_alloc - Allocate new devlink instance resources
  *
@@ -7468,6 +7549,9 @@ struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size)
 	if (WARN_ON(!ops))
 		return NULL;
 
+	if (!devlink_reload_actions_valid(ops))
+		return NULL;
+
 	devlink = kzalloc(sizeof(*devlink) + priv_size, GFP_KERNEL);
 	if (!devlink)
 		return NULL;
@@ -9724,6 +9808,7 @@ int devlink_compat_switch_id_get(struct net_device *dev,
 
 static void __net_exit devlink_pernet_pre_exit(struct net *net)
 {
+	unsigned long actions_performed;
 	struct devlink *devlink;
 	int err;
 
@@ -9735,7 +9820,9 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 		if (net_eq(devlink_net(devlink), net)) {
 			if (WARN_ON(!devlink_reload_supported(devlink->ops)))
 				continue;
-			err = devlink_reload(devlink, &init_net, NULL);
+			err = devlink_reload(devlink, &init_net,
+					     DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
+					     NULL, &actions_performed);
 			if (err && err != -EOPNOTSUPP)
 				pr_warn("Failed to reload devlink instance into init_net\n");
 		}
-- 
2.18.2

