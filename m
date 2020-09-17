Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4813826D968
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 12:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgIQKpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 06:45:13 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:48298 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726608AbgIQKox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 06:44:53 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from ayal@mellanox.com)
        with SMTP; 17 Sep 2020 13:37:27 +0300
Received: from dev-l-vrt-210.mtl.labs.mlnx (dev-l-vrt-210.mtl.labs.mlnx [10.234.210.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 08HAbRkJ014850;
        Thu, 17 Sep 2020 13:37:27 +0300
Received: from dev-l-vrt-210.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Debian-8ubuntu1) with ESMTP id 08HAbRG3015609;
        Thu, 17 Sep 2020 13:37:27 +0300
Received: (from ayal@localhost)
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 08HAbRuN015608;
        Thu, 17 Sep 2020 13:37:27 +0300
From:   Aya Levin <ayal@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        netdev <netdev@vger.kernel.org>
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        <linux-kernel@vger.kernel.org>, Aya Levin <ayal@nvidia.com>
Subject: [PATCH net-next RFC v2 2/3] devlink: Add devlink traps under devlink_ports context
Date:   Thu, 17 Sep 2020 13:36:43 +0300
Message-Id: <1600339004-15552-3-git-send-email-ayal@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1600339004-15552-1-git-send-email-ayal@nvidia.com>
References: <1600339004-15552-1-git-send-email-ayal@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some cases where we would like to trap dropped packets only
for a single port on a device without affecting the others. For that
purpose:
- Add trap lists and trap ops to devlink_port
- Add corresponding trap API to manage traps
- Add matching netlink commands

Signed-off-by: Aya Levin <ayal@nvidia.com>
---
Changelog:
v1->v2:
Add traps lock in devlink_port
Add devlink_port ops and in it, add the trap ops
Add support onlty for traps and exclude groups and policer
Add seperate netlink commands foor port trap get and set 
Allow trap registration without a corresponding group

 include/net/devlink.h        |  44 ++++++
 include/uapi/linux/devlink.h |   5 +
 net/core/devlink.c           | 346 +++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 382 insertions(+), 13 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index f11e09097e44..93eb7033ce00 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -21,6 +21,8 @@
 #include <linux/xarray.h>
 
 struct devlink_ops;
+struct devlink_port_ops;
+
 
 struct devlink_trap_lists {
 	struct list_head trap_list;
@@ -129,6 +131,9 @@ struct devlink_port {
 	struct delayed_work type_warn_dw;
 	struct list_head reporter_list;
 	struct mutex reporters_lock; /* Protects reporter_list */
+	struct mutex trap_lists_lock;
+	struct devlink_trap_lists trap_lists;
+	const struct devlink_port_ops *ops;
 };
 
 struct devlink_sb_pool_info {
@@ -1177,6 +1182,35 @@ struct devlink_ops {
 					 struct netlink_ext_ack *extack);
 };
 
+struct devlink_port_ops {
+	/**
+	 * @trap_init: Trap initialization function.
+	 *
+	 * Should be used by device drivers to initialize the trap in the
+	 * underlying device. Drivers should also store the provided trap
+	 * context, so that they could efficiently pass it to
+	 * devlink_trap_report() when the trap is triggered.
+	 */
+	int (*trap_init)(struct devlink_port *devlink,
+			 const struct devlink_trap *trap, void *trap_ctx);
+	/**
+	 * @trap_fini: Trap de-initialization function.
+	 *
+	 * Should be used by device drivers to de-initialize the trap in the
+	 * underlying device.
+	 */
+
+	void (*trap_fini)(struct devlink_port *devlink_port,
+			  const struct devlink_trap *trap, void *trap_ctx);
+	/**
+	 * @trap_action_set: Trap action set function.
+	 */
+	int (*trap_action_set)(struct devlink_port *devlink_port,
+			       const struct devlink_trap *trap,
+			       enum devlink_trap_action action,
+			       struct netlink_ext_ack *extack);
+};
+
 static inline void *devlink_priv(struct devlink *devlink)
 {
 	BUG_ON(!devlink);
@@ -1220,6 +1254,8 @@ int devlink_port_register(struct devlink *devlink,
 			  struct devlink_port *devlink_port,
 			  unsigned int port_index);
 void devlink_port_unregister(struct devlink_port *devlink_port);
+void devlink_port_set_ops(struct devlink_port *devlink_port,
+			  const struct devlink_port_ops *ops);
 void devlink_port_type_eth_set(struct devlink_port *devlink_port,
 			       struct net_device *netdev);
 void devlink_port_type_ib_set(struct devlink_port *devlink_port,
@@ -1429,6 +1465,14 @@ void
 devlink_trap_policers_unregister(struct devlink *devlink,
 				 const struct devlink_trap_policer *policers,
 				 size_t policers_count);
+int devlink_port_traps_register(struct devlink_port *devlink_port,
+				const struct devlink_trap *traps,
+				size_t traps_count, void *priv);
+void devlink_port_traps_unregister(struct devlink_port *devlink_port,
+				   const struct devlink_trap *traps,
+				   size_t traps_count);
+void devlink_port_trap_report(struct devlink_port *devlink_port, struct sk_buff *skb,
+			      void *trap_ctx, const struct flow_action_cookie *fa_cookie);
 
 #if IS_ENABLED(CONFIG_NET_DEVLINK)
 
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 40d35145c879..401ad93dab67 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -122,6 +122,11 @@ enum devlink_command {
 	DEVLINK_CMD_TRAP_POLICER_NEW,
 	DEVLINK_CMD_TRAP_POLICER_DEL,
 
+	DEVLINK_CMD_PORT_TRAP_GET,		/* can dump */
+	DEVLINK_CMD_PORT_TRAP_SET,
+	DEVLINK_CMD_PORT_TRAP_NEW,
+	DEVLINK_CMD_PORT_TRAP_DEL,
+
 	/* add new commands above here */
 	__DEVLINK_CMD_MAX,
 	DEVLINK_CMD_MAX = __DEVLINK_CMD_MAX - 1
diff --git a/net/core/devlink.c b/net/core/devlink.c
index fde6f2c5c409..438bd88c2c1b 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6309,8 +6309,8 @@ static int devlink_nl_trap_fill(struct sk_buff *msg, struct devlink *devlink,
 	if (devlink_nl_put_handle(msg, devlink))
 		goto nla_put_failure;
 
-	if (nla_put_string(msg, DEVLINK_ATTR_TRAP_GROUP_NAME,
-			   group_item->group->name))
+	if (group_item &&
+	    nla_put_string(msg, DEVLINK_ATTR_TRAP_GROUP_NAME, group_item->group->name))
 		goto nla_put_failure;
 
 	if (nla_put_string(msg, DEVLINK_ATTR_TRAP_NAME, trap_item->trap->name))
@@ -7002,6 +7002,145 @@ static int devlink_nl_cmd_trap_policer_set_doit(struct sk_buff *skb,
 	return devlink_trap_policer_set(devlink, policer_item, info);
 }
 
+static int devlink_nl_cmd_port_trap_get_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct devlink_port *devlink_port = info->user_ptr[0];
+	struct netlink_ext_ack *extack = info->extack;
+	struct devlink_trap_item *trap_item;
+	struct sk_buff *msg;
+	int err;
+
+	if (list_empty(&devlink_port->trap_lists.trap_list))
+		return -EOPNOTSUPP;
+
+	trap_item = devlink_trap_item_get_from_info(&devlink_port->trap_lists, info);
+	if (!trap_item) {
+		NL_SET_ERR_MSG_MOD(extack, "Port did not register this trap");
+		return -ENOENT;
+	}
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	err = devlink_nl_trap_fill(msg, devlink_port->devlink, trap_item,
+				   DEVLINK_CMD_TRAP_NEW, devlink_port->index,
+				   info->snd_seq, 0);
+	if (err)
+		goto err_trap_fill;
+
+	return genlmsg_reply(msg, info);
+
+err_trap_fill:
+	nlmsg_free(msg);
+	return err;
+}
+
+static int devlink_nl_cmd_port_trap_get_dumpit(struct sk_buff *msg, struct netlink_callback *cb)
+{
+	struct devlink_trap_item *trap_item;
+	struct devlink_port *devlink_port;
+	struct devlink *devlink;
+	int start = cb->args[0];
+	int idx = 0;
+	int err;
+
+	mutex_lock(&devlink_mutex);
+	list_for_each_entry(devlink, &devlink_list, list) {
+		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
+			continue;
+		mutex_lock(&devlink->lock);
+		list_for_each_entry(devlink_port, &devlink->port_list, list) {
+			mutex_lock(&devlink_port->trap_lists_lock);
+			list_for_each_entry(trap_item, &devlink->trap_lists.trap_list, list) {
+				if (idx < start) {
+					idx++;
+					continue;
+				}
+				err = devlink_nl_trap_fill(msg, devlink, trap_item,
+							   DEVLINK_CMD_TRAP_NEW,
+							   devlink_port->index,
+							   cb->nlh->nlmsg_seq,
+							   NLM_F_MULTI);
+				if (err) {
+					mutex_unlock(&devlink_port->trap_lists_lock);
+					mutex_unlock(&devlink->lock);
+					goto out;
+				}
+				idx++;
+			}
+			mutex_unlock(&devlink_port->trap_lists_lock);
+		}
+		mutex_unlock(&devlink->lock);
+	}
+out:
+	mutex_unlock(&devlink_mutex);
+
+	cb->args[0] = idx;
+	return msg->len;
+}
+
+static int __devlink_port_trap_action_set(struct devlink_port *devlink_port,
+					  struct devlink_trap_item *trap_item,
+					  enum devlink_trap_action trap_action,
+					  struct netlink_ext_ack *extack)
+{
+	int err;
+
+	if (trap_item->action != trap_action &&
+	    trap_item->trap->type != DEVLINK_TRAP_TYPE_DROP) {
+		NL_SET_ERR_MSG_MOD(extack, "Cannot change action of non-drop traps. Skipping");
+		return 0;
+	}
+
+	err = devlink_port->ops->trap_action_set(devlink_port, trap_item->trap,
+						 trap_action, extack);
+	if (err)
+		return err;
+
+	trap_item->action = trap_action;
+
+	return 0;
+}
+
+static int devlink_port_trap_action_set(struct devlink_port *devlink_port,
+					struct devlink_trap_item *trap_item,
+					struct genl_info *info)
+{
+	enum devlink_trap_action trap_action;
+	int err;
+
+	if (!info->attrs[DEVLINK_ATTR_TRAP_ACTION])
+		return 0;
+
+	err = devlink_trap_action_get_from_info(info, &trap_action);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(info->extack, "Invalid trap action");
+		return -EINVAL;
+	}
+
+	return __devlink_port_trap_action_set(devlink_port, trap_item, trap_action,
+					      info->extack);
+}
+
+static int devlink_nl_cmd_port_trap_set_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct devlink_port *devlink_port = info->user_ptr[0];
+	struct netlink_ext_ack *extack = info->extack;
+	struct devlink_trap_item *trap_item;
+
+	if (list_empty(&devlink_port->trap_lists.trap_list))
+		return -EOPNOTSUPP;
+
+	trap_item = devlink_trap_item_get_from_info(&devlink_port->trap_lists, info);
+	if (!trap_item) {
+		NL_SET_ERR_MSG_MOD(extack, "Port did not register this trap");
+		return -ENOENT;
+	}
+
+	return devlink_port_trap_action_set(devlink_port, trap_item, info);
+}
+
 static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_UNSPEC] = { .strict_start_type =
 		DEVLINK_ATTR_TRAP_POLICER_ID },
@@ -7355,6 +7494,20 @@ static const struct genl_ops devlink_nl_ops[] = {
 		.doit = devlink_nl_cmd_trap_policer_set_doit,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = DEVLINK_CMD_PORT_TRAP_GET,
+		.doit = devlink_nl_cmd_port_trap_get_doit,
+		.dumpit = devlink_nl_cmd_port_trap_get_dumpit,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_PORT,
+		/* can be retrieved by unprivileged users */
+	},
+	{
+		.cmd = DEVLINK_CMD_PORT_TRAP_SET,
+		.doit = devlink_nl_cmd_port_trap_set_doit,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_PORT,
+	},
+
 };
 
 static struct genl_family devlink_nl_family __ro_after_init = {
@@ -7567,10 +7720,15 @@ int devlink_port_register(struct devlink *devlink,
 	mutex_init(&devlink_port->reporters_lock);
 	list_add_tail(&devlink_port->list, &devlink->port_list);
 	INIT_LIST_HEAD(&devlink_port->param_list);
+	INIT_LIST_HEAD(&devlink_port->trap_lists.trap_list);
+	INIT_LIST_HEAD(&devlink_port->trap_lists.trap_group_list);
+	INIT_LIST_HEAD(&devlink_port->trap_lists.trap_policer_list);
+	mutex_init(&devlink_port->trap_lists_lock);
 	mutex_unlock(&devlink->lock);
 	INIT_DELAYED_WORK(&devlink_port->type_warn_dw, &devlink_port_type_warn);
 	devlink_port_type_warn_schedule(devlink_port);
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(devlink_port_register);
@@ -7590,10 +7748,21 @@ void devlink_port_unregister(struct devlink_port *devlink_port)
 	list_del(&devlink_port->list);
 	mutex_unlock(&devlink->lock);
 	WARN_ON(!list_empty(&devlink_port->reporter_list));
+	WARN_ON(!list_empty(&devlink_port->trap_lists.trap_list));
+	WARN_ON(!list_empty(&devlink_port->trap_lists.trap_group_list));
+	WARN_ON(!list_empty(&devlink_port->trap_lists.trap_group_list));
 	mutex_destroy(&devlink_port->reporters_lock);
+	mutex_destroy(&devlink_port->trap_lists_lock);
 }
 EXPORT_SYMBOL_GPL(devlink_port_unregister);
 
+void devlink_port_set_ops(struct devlink_port *devlink_port,
+			  const struct devlink_port_ops *ops)
+{
+	devlink_port->ops = ops;
+}
+EXPORT_SYMBOL_GPL(devlink_port_set_ops);
+
 static void __devlink_port_type_set(struct devlink_port *devlink_port,
 				    enum devlink_port_type type,
 				    void *type_dev)
@@ -9023,30 +9192,42 @@ static void devlink_trap_notify(struct devlink *devlink,
 				msg, 0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
 }
 
-static int
-devlink_trap_register(struct devlink *devlink,
-		      const struct devlink_trap *trap, void *priv)
+static struct devlink_trap_item *devlink_create_trap_item(struct devlink_trap_lists *trap_lists,
+							  const struct devlink_trap *trap,
+							  void *priv)
 {
-	struct devlink_trap_lists *trap_lists = &devlink->trap_lists;
 	struct devlink_trap_item *trap_item;
-	int err;
 
 	if (devlink_trap_item_lookup(trap_lists, trap->name))
-		return -EEXIST;
+		return ERR_PTR(-EEXIST);
 
 	trap_item = kzalloc(sizeof(*trap_item), GFP_KERNEL);
 	if (!trap_item)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	trap_item->stats = netdev_alloc_pcpu_stats(struct devlink_stats);
 	if (!trap_item->stats) {
-		err = -ENOMEM;
-		goto err_stats_alloc;
+		kfree(trap_item);
+		return ERR_PTR(-ENOMEM);
 	}
 
 	trap_item->trap = trap;
 	trap_item->action = trap->init_action;
 	trap_item->priv = priv;
+	return trap_item;
+}
+
+static int
+devlink_trap_register(struct devlink *devlink,
+		      const struct devlink_trap *trap, void *priv)
+{
+	struct devlink_trap_lists *trap_lists = &devlink->trap_lists;
+	struct devlink_trap_item *trap_item;
+	int err;
+
+	trap_item = devlink_create_trap_item(trap_lists, trap, priv);
+	if (IS_ERR(trap_item))
+		return PTR_ERR(trap_item);
 
 	err = devlink_trap_item_group_link(trap_lists, trap_item);
 	if (err)
@@ -9064,7 +9245,6 @@ devlink_trap_register(struct devlink *devlink,
 err_trap_init:
 err_group_link:
 	free_percpu(trap_item->stats);
-err_stats_alloc:
 	kfree(trap_item);
 	return err;
 }
@@ -9086,6 +9266,23 @@ static void devlink_trap_unregister(struct devlink *devlink,
 	kfree(trap_item);
 }
 
+static void devlink_port_trap_unregister(struct devlink_port *devlink_port,
+					 const struct devlink_trap *trap)
+{
+	struct devlink_trap_item *trap_item;
+
+	trap_item = devlink_trap_item_lookup(&devlink_port->trap_lists, trap->name);
+	if (WARN_ON_ONCE(!trap_item))
+		return;
+
+	devlink_trap_notify(devlink_port->devlink, trap_item, DEVLINK_CMD_TRAP_DEL);
+	list_del(&trap_item->list);
+	if (devlink_port->ops->trap_fini)
+		devlink_port->ops->trap_fini(devlink_port, trap, trap_item);
+	free_percpu(trap_item->stats);
+	kfree(trap_item);
+}
+
 static void devlink_trap_disable(struct devlink *devlink,
 				 const struct devlink_trap *trap)
 {
@@ -9100,6 +9297,19 @@ static void devlink_trap_disable(struct devlink *devlink,
 	trap_item->action = DEVLINK_TRAP_ACTION_DROP;
 }
 
+static void devlink_port_trap_disable(struct devlink_port *devlink_port,
+				      const struct devlink_trap *trap)
+{
+	struct devlink_trap_item *trap_item;
+
+	trap_item = devlink_trap_item_lookup(&devlink_port->trap_lists, trap->name);
+	if (WARN_ON_ONCE(!trap_item))
+		return;
+
+	devlink_port->ops->trap_action_set(devlink_port, trap, DEVLINK_TRAP_ACTION_DROP, NULL);
+	trap_item->action = DEVLINK_TRAP_ACTION_DROP;
+}
+
 /**
  * devlink_traps_register - Register packet traps with devlink.
  * @devlink: devlink.
@@ -9189,7 +9399,8 @@ devlink_trap_report_metadata_fill(struct net_dm_hw_metadata *hw_metadata,
 {
 	struct devlink_trap_group_item *group_item = trap_item->group_item;
 
-	hw_metadata->trap_group_name = group_item->group->name;
+	if (group_item)
+		hw_metadata->trap_group_name = group_item->group->name;
 	hw_metadata->trap_name = trap_item->trap->name;
 	hw_metadata->fa_cookie = fa_cookie;
 
@@ -9529,6 +9740,115 @@ devlink_trap_policers_unregister(struct devlink *devlink,
 }
 EXPORT_SYMBOL_GPL(devlink_trap_policers_unregister);
 
+static int
+devlink_port_trap_register(struct devlink_port *devlink_port,
+			   const struct devlink_trap *trap, void *priv)
+{
+	struct devlink_trap_lists *trap_lists = &devlink_port->trap_lists;
+	struct devlink_trap_item *trap_item;
+	int err;
+
+	trap_item = devlink_create_trap_item(trap_lists, trap, priv);
+	if (IS_ERR(trap_item))
+		return PTR_ERR(trap_item);
+
+	if (!(list_empty(&trap_lists->trap_group_list))) {
+		err = devlink_trap_item_group_link(trap_lists, trap_item);
+		if (err)
+			goto err_group_link;
+	}
+
+	err = devlink_port->ops->trap_init(devlink_port, trap, trap_item);
+	if (err)
+		goto err_trap_init;
+
+	list_add_tail(&trap_item->list, &trap_lists->trap_list);
+	devlink_trap_notify(devlink_port->devlink, trap_item, DEVLINK_CMD_TRAP_NEW);
+
+	return 0;
+
+err_trap_init:
+err_group_link:
+	free_percpu(trap_item->stats);
+	kfree(trap_item);
+	return err;
+}
+
+int devlink_port_traps_register(struct devlink_port *devlink_port,
+				const struct devlink_trap *traps,
+				size_t traps_count, void *priv)
+{
+	int i, err;
+
+	if (!devlink_port->ops->trap_init || !devlink_port->ops->trap_action_set)
+		return -EINVAL;
+
+	mutex_lock(&devlink_port->trap_lists_lock);
+	for (i = 0; i < traps_count; i++) {
+		const struct devlink_trap *trap = &traps[i];
+
+		err = devlink_trap_verify(trap);
+		if (err)
+			goto err_trap_verify;
+
+		err = devlink_port_trap_register(devlink_port, trap, priv);
+		if (err)
+			goto err_trap_register;
+	}
+	mutex_unlock(&devlink_port->trap_lists_lock);
+
+	return 0;
+
+err_trap_register:
+err_trap_verify:
+	for (i--; i >= 0; i--)
+		devlink_port_trap_unregister(devlink_port, &traps[i]);
+	mutex_unlock(&devlink_port->trap_lists_lock);
+	return err;
+}
+EXPORT_SYMBOL_GPL(devlink_port_traps_register);
+
+void devlink_port_traps_unregister(struct devlink_port *devlink_port,
+				   const struct devlink_trap *traps,
+				   size_t traps_count)
+{
+	int i;
+
+	mutex_lock(&devlink_port->trap_lists_lock);
+	/* Make sure we do not have any packets in-flight while unregistering
+	 * traps by disabling all of them and waiting for a grace period.
+	 */
+	for (i = traps_count - 1; i >= 0; i--)
+		devlink_port_trap_disable(devlink_port, &traps[i]);
+	synchronize_rcu();
+	for (i = traps_count - 1; i >= 0; i--)
+		devlink_port_trap_unregister(devlink_port, &traps[i]);
+	mutex_unlock(&devlink_port->trap_lists_lock);
+}
+EXPORT_SYMBOL_GPL(devlink_port_traps_unregister);
+
+void devlink_port_trap_report(struct devlink_port *devlink_port, struct sk_buff *skb,
+			      void *trap_ctx, const struct flow_action_cookie *fa_cookie)
+{
+	struct devlink_trap_item *trap_item = trap_ctx;
+	struct net_dm_hw_metadata hw_metadata = {};
+
+	devlink_trap_stats_update(trap_item->stats, skb->len);
+	devlink_trap_stats_update(trap_item->group_item->stats, skb->len);
+
+	/* Control packets were not dropped by the device or encountered an
+	 * exception during forwarding and therefore should not be reported to
+	 * the kernel's drop monitor.
+	 */
+	if (trap_item->trap->type == DEVLINK_TRAP_TYPE_CONTROL)
+		return;
+
+	devlink_trap_report_metadata_fill(&hw_metadata, trap_item,
+					  devlink_port, fa_cookie);
+	net_dm_hw_report(skb, &hw_metadata);
+}
+EXPORT_SYMBOL_GPL(devlink_port_trap_report);
+
 static void __devlink_compat_running_version(struct devlink *devlink,
 					     char *buf, size_t len)
 {
-- 
2.14.1

