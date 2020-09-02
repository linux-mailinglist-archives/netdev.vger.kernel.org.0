Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1B8F25AF09
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 17:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgIBPdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 11:33:06 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52312 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728374AbgIBPch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 11:32:37 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from ayal@mellanox.com)
        with SMTP; 2 Sep 2020 18:32:29 +0300
Received: from dev-l-vrt-210.mtl.labs.mlnx (dev-l-vrt-210.mtl.labs.mlnx [10.234.210.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 082FWTnA014699;
        Wed, 2 Sep 2020 18:32:29 +0300
Received: from dev-l-vrt-210.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Debian-8ubuntu1) with ESMTP id 082FWTLs026691;
        Wed, 2 Sep 2020 18:32:29 +0300
Received: (from ayal@localhost)
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 082FWTxr026690;
        Wed, 2 Sep 2020 18:32:29 +0300
From:   Aya Levin <ayal@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        linux-kernel@vger.kernel.org, Aya Levin <ayal@mellanox.com>
Subject: [PATCH net-next RFC v1 2/4] devlink: Add devlink traps under devlink_ports context
Date:   Wed,  2 Sep 2020 18:32:12 +0300
Message-Id: <1599060734-26617-3-git-send-email-ayal@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1599060734-26617-1-git-send-email-ayal@mellanox.com>
References: <1599060734-26617-1-git-send-email-ayal@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some cases where we would like to trap dropped packets only
for a single port on a device without affecting the others. For that
purpose trap_mngr was added to devlink_port and corresponding Trap API
with devlink_port were added too.

Signed-off-by: Aya Levin <ayal@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c |   1 +
 include/net/devlink.h                      |  25 +++
 net/core/devlink.c                         | 332 ++++++++++++++++++++++++++++-
 3 files changed, 353 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 97460f47e537..cb9567a6a90d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1178,6 +1178,7 @@ static void mlxsw_devlink_trap_fini(struct devlink *devlink,
 static int mlxsw_devlink_trap_action_set(struct devlink *devlink,
 					 const struct devlink_trap *trap,
 					 enum devlink_trap_action action,
+					 void *trap_ctx,
 					 struct netlink_ext_ack *extack)
 {
 	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
diff --git a/include/net/devlink.h b/include/net/devlink.h
index d387ea5518c3..b4897ee38209 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -110,6 +110,7 @@ struct devlink_port {
 	struct delayed_work type_warn_dw;
 	struct list_head reporter_list;
 	struct mutex reporters_lock; /* Protects reporter_list */
+	struct devlink_trap_mngr trap_mngr;
 };
 
 struct devlink_sb_pool_info {
@@ -1108,6 +1109,7 @@ struct devlink_trap_ops {
 	int (*trap_action_set)(struct devlink *devlink,
 			       const struct devlink_trap *trap,
 			       enum devlink_trap_action action,
+			       void *trap_ctx,
 			       struct netlink_ext_ack *extack);
 	/**
 	 * @trap_group_init: Trap group initialization function.
@@ -1414,6 +1416,29 @@ devlink_trap_policers_unregister(struct devlink *devlink,
 				 const struct devlink_trap_policer *policers,
 				 size_t policers_count);
 
+void devlink_port_traps_ops(struct devlink_port *devlink_port,
+			    const struct devlink_trap_ops *ops);
+int devlink_port_traps_register(struct devlink_port *devlink_port,
+				const struct devlink_trap *traps,
+				size_t traps_count, void *priv);
+void devlink_port_traps_unregister(struct devlink_port *devlink_port,
+				   const struct devlink_trap *traps,
+				   size_t traps_count);
+void devlink_port_trap_report(struct devlink_port *devlink_port, struct sk_buff *skb,
+			      void *trap_ctx, const struct flow_action_cookie *fa_cookie);
+int devlink_port_trap_groups_register(struct devlink_port *devlink_port,
+				      const struct devlink_trap_group *groups,
+				      size_t groups_count);
+void devlink_port_trap_groups_unregister(struct devlink_port *devlink_port,
+					 const struct devlink_trap_group *groups,
+					 size_t groups_count);
+int devlink_port_trap_policers_register(struct devlink_port *devlink_port,
+					const struct devlink_trap_policer *policers,
+					size_t policers_count);
+void devlink_port_trap_policers_unregister(struct devlink_port *devlink_port,
+					   const struct devlink_trap_policer *policers,
+					   size_t policers_count);
+
 #if IS_ENABLED(CONFIG_NET_DEVLINK)
 
 void devlink_compat_running_version(struct net_device *dev,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index a30b5444289b..b13e1b40bf1c 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6155,7 +6155,13 @@ struct devlink_trap_item {
 static struct devlink_trap_mngr *
 devlink_trap_get_trap_mngr_from_info(struct devlink *devlink, struct genl_info *info)
 {
-		return &devlink->trap_mngr;
+	struct devlink_port *devlink_port;
+
+	devlink_port = devlink_port_get_from_attrs(devlink, info->attrs);
+	if (IS_ERR(devlink_port))
+		return  &devlink->trap_mngr;
+	else
+		return &devlink_port->trap_mngr;
 }
 
 static struct devlink_trap_policer_item *
@@ -6382,6 +6388,7 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 {
 	struct devlink_trap_mngr *trap_mngr;
 	struct devlink_trap_item *trap_item;
+	struct devlink_port *port;
 	struct devlink *devlink;
 	int start = cb->args[0];
 	int idx = 0;
@@ -6411,6 +6418,30 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 		}
 		mutex_unlock(&devlink->lock);
 	}
+	list_for_each_entry(devlink, &devlink_list, list) {
+		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
+			continue;
+		list_for_each_entry(port, &devlink->port_list, list) {
+			trap_mngr = &port->trap_mngr;
+			mutex_lock(&devlink->lock);
+			list_for_each_entry(trap_item, &trap_mngr->trap_list, list) {
+				if (idx < start) {
+					idx++;
+					continue;
+				}
+				err = devlink_nl_trap_fill(msg, devlink, trap_item,
+							   DEVLINK_CMD_TRAP_NEW,
+							   NETLINK_CB(cb->skb).portid,
+							   cb->nlh->nlmsg_seq,
+							   NLM_F_MULTI);
+				if (err)
+					goto out;
+				idx++;
+			}
+			mutex_unlock(&devlink->lock);
+		}
+	}
+
 out:
 	mutex_unlock(&devlink_mutex);
 
@@ -6433,7 +6464,7 @@ static int __devlink_trap_action_set(struct devlink *devlink,
 	}
 
 	err = trap_mngr->trap_ops->trap_action_set(devlink, trap_item->trap,
-						   trap_action, extack);
+						   trap_action, trap_item, extack);
 	if (err)
 		return err;
 
@@ -6481,6 +6512,7 @@ static int devlink_nl_cmd_trap_set_doit(struct sk_buff *skb,
 		NL_SET_ERR_MSG_MOD(extack, "Device did not register this trap");
 		return -ENOENT;
 	}
+	return devlink_trap_action_set(devlink, trap_mngr, trap_item, info);
 
 	err = devlink_trap_action_set(devlink, trap_mngr, trap_item, info);
 	if (err)
@@ -6614,6 +6646,7 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 	struct devlink_trap_group_item *group_item;
 	u32 portid = NETLINK_CB(cb->skb).portid;
 	struct devlink_trap_mngr *trap_mngr;
+	struct devlink_port *port;
 	struct devlink *devlink;
 	int start = cb->args[0];
 	int idx = 0;
@@ -6644,6 +6677,30 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 		}
 		mutex_unlock(&devlink->lock);
 	}
+	list_for_each_entry(devlink, &devlink_list, list) {
+		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
+			continue;
+		list_for_each_entry(port, &devlink->port_list, list) {
+			trap_mngr = &port->trap_mngr;
+			mutex_lock(&devlink->lock);
+			list_for_each_entry(group_item, &trap_mngr->trap_group_list, list) {
+				if (idx < start) {
+					idx++;
+					continue;
+				}
+				err = devlink_nl_trap_group_fill(msg, devlink,
+								 group_item, cmd,
+								 portid,
+								 cb->nlh->nlmsg_seq,
+								 NLM_F_MULTI);
+				if (err)
+					goto out;
+				idx++;
+			}
+			mutex_unlock(&devlink->lock);
+		}
+	}
+
 out:
 	mutex_unlock(&devlink_mutex);
 
@@ -6912,6 +6969,7 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 	struct devlink_trap_policer_item *policer_item;
 	u32 portid = NETLINK_CB(cb->skb).portid;
 	struct devlink_trap_mngr *trap_mngr;
+	struct devlink_port *port;
 	struct devlink *devlink;
 	int start = cb->args[0];
 	int idx = 0;
@@ -6943,6 +7001,32 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 		}
 		mutex_unlock(&devlink->lock);
 	}
+	list_for_each_entry(devlink, &devlink_list, list) {
+		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
+			continue;
+		list_for_each_entry(port, &devlink->port_list, list) {
+			trap_mngr = &port->trap_mngr;
+			mutex_lock(&devlink->lock);
+			list_for_each_entry(policer_item, &trap_mngr->trap_policer_list,
+					    list) {
+				if (idx < start) {
+					idx++;
+					continue;
+				}
+				err = devlink_nl_trap_policer_fill(msg, devlink,
+								   policer_item, cmd,
+								   portid,
+								   cb->nlh->nlmsg_seq,
+								   trap_mngr,
+								   NLM_F_MULTI);
+				if (err)
+					goto out;
+				idx++;
+			}
+			mutex_unlock(&devlink->lock);
+		}
+	}
+
 out:
 	mutex_unlock(&devlink_mutex);
 
@@ -7348,34 +7432,40 @@ static const struct genl_ops devlink_nl_ops[] = {
 		.cmd = DEVLINK_CMD_TRAP_GET,
 		.doit = devlink_nl_cmd_trap_get_doit,
 		.dumpit = devlink_nl_cmd_trap_get_dumpit,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT,
 		/* can be retrieved by unprivileged users */
 	},
 	{
 		.cmd = DEVLINK_CMD_TRAP_SET,
 		.doit = devlink_nl_cmd_trap_set_doit,
 		.flags = GENL_ADMIN_PERM,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT,
 	},
 	{
 		.cmd = DEVLINK_CMD_TRAP_GROUP_GET,
 		.doit = devlink_nl_cmd_trap_group_get_doit,
 		.dumpit = devlink_nl_cmd_trap_group_get_dumpit,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT,
 		/* can be retrieved by unprivileged users */
 	},
 	{
 		.cmd = DEVLINK_CMD_TRAP_GROUP_SET,
 		.doit = devlink_nl_cmd_trap_group_set_doit,
 		.flags = GENL_ADMIN_PERM,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT,
 	},
 	{
 		.cmd = DEVLINK_CMD_TRAP_POLICER_GET,
 		.doit = devlink_nl_cmd_trap_policer_get_doit,
 		.dumpit = devlink_nl_cmd_trap_policer_get_dumpit,
 		/* can be retrieved by unprivileged users */
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT,
 	},
 	{
 		.cmd = DEVLINK_CMD_TRAP_POLICER_SET,
 		.doit = devlink_nl_cmd_trap_policer_set_doit,
 		.flags = GENL_ADMIN_PERM,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT,
 	},
 };
 
@@ -7593,6 +7683,10 @@ int devlink_port_register(struct devlink *devlink,
 	INIT_DELAYED_WORK(&devlink_port->type_warn_dw, &devlink_port_type_warn);
 	devlink_port_type_warn_schedule(devlink_port);
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
+	INIT_LIST_HEAD(&devlink_port->trap_mngr.trap_list);
+	INIT_LIST_HEAD(&devlink_port->trap_mngr.trap_group_list);
+	INIT_LIST_HEAD(&devlink_port->trap_mngr.trap_policer_list);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(devlink_port_register);

@@ -9084,7 +9178,8 @@ static void devlink_trap_disable(struct devlink *devlink,
 	if (WARN_ON_ONCE(!trap_item))
 		return;
 
-	trap_mngr->trap_ops->trap_action_set(devlink, trap, DEVLINK_TRAP_ACTION_DROP, NULL);
+	trap_mngr->trap_ops->trap_action_set(devlink, trap, DEVLINK_TRAP_ACTION_DROP,
+					     trap_item, NULL);
 	trap_item->action = DEVLINK_TRAP_ACTION_DROP;
 }
 
@@ -9532,6 +9627,233 @@ devlink_trap_policers_unregister(struct devlink *devlink,
 }
 EXPORT_SYMBOL_GPL(devlink_trap_policers_unregister);
 
+/**
+ * devlink_port_traps_ops - Register trap callbacks
+ * @devlink_port: devlink_port.
+ * @ops: trap ops
+ */
+void devlink_port_traps_ops(struct devlink_port *devlink_port,
+			    const struct devlink_trap_ops *ops)
+{
+	devlink_port->trap_mngr.trap_ops = ops;
+}
+EXPORT_SYMBOL_GPL(devlink_port_traps_ops);
+
+/**
+ * devlink_port_traps_register - Register packet traps with devlink
+ * port.
+ * @devlink_port: devlink_port.
+ * @traps: Packet traps.
+ * @traps_count: Count of provided packet traps.
+ * @priv: Driver private information.
+ *
+ * Return: Non-zero value on failure.
+ */
+int devlink_port_traps_register(struct devlink_port *devlink_port,
+				const struct devlink_trap *traps,
+				size_t traps_count, void *priv)
+{
+	struct devlink_trap_mngr *trap_mngr = &devlink_port->trap_mngr;
+	struct devlink *devlink = devlink_port->devlink;
+	int i, err;
+
+	if (!trap_mngr->trap_ops->trap_init || !trap_mngr->trap_ops->trap_action_set)
+		return -EINVAL;
+
+	mutex_lock(&devlink->lock);
+	for (i = 0; i < traps_count; i++) {
+		const struct devlink_trap *trap = &traps[i];
+
+		err = devlink_trap_verify(trap);
+		if (err)
+			goto err_trap_verify;
+
+		err = devlink_trap_register(devlink, trap_mngr, trap, priv);
+		if (err)
+			goto err_trap_register;
+	}
+	mutex_unlock(&devlink->lock);
+
+	return 0;
+
+err_trap_register:
+err_trap_verify:
+	for (i--; i >= 0; i--)
+		devlink_trap_unregister(devlink, trap_mngr, &traps[i]);
+	mutex_unlock(&devlink->lock);
+	return err;
+}
+EXPORT_SYMBOL_GPL(devlink_port_traps_register);
+
+/**
+ * devlink_port_traps_unregister - Unregister packet traps from devlink_port.
+ * @devlink_port: devlink port.
+ * @traps: Packet traps.
+ * @traps_count: Count of provided packet traps.
+ */
+void devlink_port_traps_unregister(struct devlink_port *devlink_port,
+				   const struct devlink_trap *traps,
+				   size_t traps_count)
+{
+	struct devlink_trap_mngr *trap_mngr = &devlink_port->trap_mngr;
+	struct devlink *devlink = devlink_port->devlink;
+	int i;
+
+	mutex_lock(&devlink->lock);
+	/* Make sure we do not have any packets in-flight while unregistering
+	 * traps by disabling all of them and waiting for a grace period.
+	 */
+	for (i = traps_count - 1; i >= 0; i--)
+		devlink_trap_disable(devlink, trap_mngr, &traps[i]);
+	synchronize_rcu();
+	for (i = traps_count - 1; i >= 0; i--)
+		devlink_trap_unregister(devlink, trap_mngr, &traps[i]);
+	mutex_unlock(&devlink->lock);
+}
+EXPORT_SYMBOL_GPL(devlink_port_traps_unregister);
+
+/**
+ * devlink_port_trap_report - Report trapped packet to drop monitor.
+ * @devlink_port: devlink_port.
+ * @skb: Trapped packet.
+ * @trap_ctx: Trap context.
+ * @fa_cookie: Flow action cookie. Could be NULL.
+ */
+void devlink_port_trap_report(struct devlink_port *devlink_port, struct sk_buff *skb,
+			      void *trap_ctx, const struct flow_action_cookie *fa_cookie)
+{
+	return devlink_trap_report(devlink_port->devlink, skb, trap_ctx, devlink_port,
+				   fa_cookie);
+}
+EXPORT_SYMBOL_GPL(devlink_port_trap_report);
+
+/**
+ * devlink_port_trap_groups_register - Register packet trap groups with devlink port.
+ * @devlink_port: devlink_port.
+ * @groups: Packet trap groups.
+ * @groups_count: Count of provided packet trap groups.
+ *
+ * Return: Non-zero value on failure.
+ */
+int devlink_port_trap_groups_register(struct devlink_port *devlink_port,
+				      const struct devlink_trap_group *groups,
+				      size_t groups_count)
+{
+	struct devlink_trap_mngr *trap_mngr = &devlink_port->trap_mngr;
+	struct devlink *devlink = devlink_port->devlink;
+	int i, err;
+
+	mutex_lock(&devlink->lock);
+	for (i = 0; i < groups_count; i++) {
+		const struct devlink_trap_group *group = &groups[i];
+
+		err = devlink_trap_group_verify(group);
+		if (err)
+			goto err_trap_group_verify;
+
+		err = devlink_trap_group_register(devlink, trap_mngr, group);
+		if (err)
+			goto err_trap_group_register;
+	}
+	mutex_unlock(&devlink->lock);
+
+	return 0;
+
+err_trap_group_register:
+err_trap_group_verify:
+	for (i--; i >= 0; i--)
+		devlink_trap_group_unregister(devlink, trap_mngr, &groups[i]);
+	mutex_unlock(&devlink->lock);
+	return err;
+}
+EXPORT_SYMBOL_GPL(devlink_port_trap_groups_register);
+
+/**
+ * devlink_port_trap_groups_unregister - Unregister packet trap groups from devlink port.
+ * @devlink_port: devlink_port.
+ * @groups: Packet trap groups.
+ * @groups_count: Count of provided packet trap groups.
+ */
+void devlink_port_trap_groups_unregister(struct devlink_port *devlink_port,
+					 const struct devlink_trap_group *groups,
+					 size_t groups_count)
+{
+	struct devlink_trap_mngr *trap_mngr = &devlink_port->trap_mngr;
+	struct devlink *devlink = devlink_port->devlink;
+	int i;
+
+	mutex_lock(&devlink->lock);
+	for (i = groups_count - 1; i >= 0; i--)
+		devlink_trap_group_unregister(devlink, trap_mngr, &groups[i]);
+	mutex_unlock(&devlink->lock);
+}
+EXPORT_SYMBOL_GPL(devlink_port_trap_groups_unregister);
+
+/**
+ * devlink_port_trap_policers_register - Register packet trap policers with devlink port.
+ * @devlink_port: devlink_port.
+ * @policers: Packet trap policers.
+ * @policers_count: Count of provided packet trap policers.
+ *
+ * Return: Non-zero value on failure.
+ */
+int devlink_port_trap_policers_register(struct devlink_port *devlink_port,
+					const struct devlink_trap_policer *policers,
+					size_t policers_count)
+{
+	struct devlink_trap_mngr *trap_mngr = &devlink_port->devlink->trap_mngr;
+	struct devlink *devlink = devlink_port->devlink;
+	int i, err;
+
+	mutex_lock(&devlink->lock);
+	for (i = 0; i < policers_count; i++) {
+		const struct devlink_trap_policer *policer = &policers[i];
+
+		if (WARN_ON(policer->id == 0 ||
+			    policer->max_rate < policer->min_rate ||
+			    policer->max_burst < policer->min_burst)) {
+			err = -EINVAL;
+			goto err_trap_policer_verify;
+		}
+
+		err = devlink_trap_policer_register(devlink, trap_mngr, policer);
+		if (err)
+			goto err_trap_policer_register;
+	}
+	mutex_unlock(&devlink->lock);
+
+	return 0;
+
+err_trap_policer_register:
+err_trap_policer_verify:
+	for (i--; i >= 0; i--)
+		devlink_trap_policer_unregister(devlink, trap_mngr, &policers[i]);
+	mutex_unlock(&devlink->lock);
+	return err;
+}
+EXPORT_SYMBOL_GPL(devlink_port_trap_policers_register);
+
+/**
+ * devlink_port_trap_policers_unregister - Unregister packet trap policers from devlink_port
+ * @devlink_port: devlink_port.
+ * @policers: Packet trap policers.
+ * @policers_count: Count of provided packet trap policers.
+ */
+void devlink_port_trap_policers_unregister(struct devlink_port *devlink_port,
+					   const struct devlink_trap_policer *policers,
+					   size_t policers_count)
+{
+	struct devlink_trap_mngr *trap_mngr = &devlink_port->devlink->trap_mngr;
+	struct devlink *devlink = devlink_port->devlink;
+	int i;
+
+	mutex_lock(&devlink->lock);
+	for (i = policers_count - 1; i >= 0; i--)
+		devlink_trap_policer_unregister(devlink, trap_mngr, &policers[i]);
+	mutex_unlock(&devlink->lock);
+}
+EXPORT_SYMBOL_GPL(devlink_port_trap_policers_unregister);
+
 static void __devlink_compat_running_version(struct devlink *devlink,
 					     char *buf, size_t len)
 {
-- 
2.14.1

