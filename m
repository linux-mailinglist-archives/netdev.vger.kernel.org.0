Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3325925AF19
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 17:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728330AbgIBPdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 11:33:46 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52315 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728369AbgIBPdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 11:33:14 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from ayal@mellanox.com)
        with SMTP; 2 Sep 2020 18:32:29 +0300
Received: from dev-l-vrt-210.mtl.labs.mlnx (dev-l-vrt-210.mtl.labs.mlnx [10.234.210.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 082FWS3O014695;
        Wed, 2 Sep 2020 18:32:28 +0300
Received: from dev-l-vrt-210.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Debian-8ubuntu1) with ESMTP id 082FWS69026689;
        Wed, 2 Sep 2020 18:32:28 +0300
Received: (from ayal@localhost)
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 082FWSu0026688;
        Wed, 2 Sep 2020 18:32:28 +0300
From:   Aya Levin <ayal@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        linux-kernel@vger.kernel.org, Aya Levin <ayal@mellanox.com>
Subject: [PATCH net-next RFC v1 1/4] devlink: Wrap trap related lists and ops in trap_mngr
Date:   Wed,  2 Sep 2020 18:32:11 +0300
Message-Id: <1599060734-26617-2-git-send-email-ayal@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1599060734-26617-1-git-send-email-ayal@mellanox.com>
References: <1599060734-26617-1-git-send-email-ayal@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bundle the trap related lists: trap_list, trap_group_list and
trap_policer_list and trap ops like: trap_init, trap_fini,
trap_action_set... together in trap_mngr. This will be handy in the
coming patches in the set introducing traps in devlink port context.
With trap_mngr, code reuse is much simpler.

Signed-off-by: Aya Levin <ayal@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c |   4 +
 include/net/devlink.h                      |  59 ++++---
 net/core/devlink.c                         | 255 +++++++++++++++++------------
 3 files changed, 188 insertions(+), 130 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 08d101138fbe..97460f47e537 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1285,6 +1285,9 @@ static const struct devlink_ops mlxsw_devlink_ops = {
 	.sb_occ_tc_port_bind_get	= mlxsw_devlink_sb_occ_tc_port_bind_get,
 	.info_get			= mlxsw_devlink_info_get,
 	.flash_update			= mlxsw_devlink_flash_update,
+};
+
+static const struct devlink_trap_ops mlxsw_devlink_traps_ops = {
 	.trap_init			= mlxsw_devlink_trap_init,
 	.trap_fini			= mlxsw_devlink_trap_fini,
 	.trap_action_set		= mlxsw_devlink_trap_action_set,
@@ -1321,6 +1324,7 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 			err = -ENOMEM;
 			goto err_devlink_alloc;
 		}
+		devlink_traps_ops(devlink, &mlxsw_devlink_traps_ops);
 	}
 
 	mlxsw_core = devlink_priv(devlink);
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 8f3c8a443238..d387ea5518c3 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -21,6 +21,13 @@
 #include <linux/xarray.h>
 
 struct devlink_ops;
+struct devlink_trap_ops;
+struct devlink_trap_mngr {
+	struct list_head trap_list;
+	struct list_head trap_group_list;
+	struct list_head trap_policer_list;
+	const struct devlink_trap_ops *trap_ops;
+};
 
 struct devlink {
 	struct list_head list;
@@ -33,9 +40,7 @@ struct devlink {
 	struct list_head reporter_list;
 	struct mutex reporters_lock; /* protects reporter_list */
 	struct devlink_dpipe_headers *dpipe_headers;
-	struct list_head trap_list;
-	struct list_head trap_group_list;
-	struct list_head trap_policer_list;
+	struct devlink_trap_mngr trap_mngr;
 	const struct devlink_ops *ops;
 	struct xarray snapshot_ids;
 	struct device *dev;
@@ -1054,6 +1059,31 @@ struct devlink_ops {
 	int (*flash_update)(struct devlink *devlink, const char *file_name,
 			    const char *component,
 			    struct netlink_ext_ack *extack);
+	/**
+	 * @port_function_hw_addr_get: Port function's hardware address get function.
+	 *
+	 * Should be used by device drivers to report the hardware address of a function
+	 * managed by the devlink port. Driver should return -EOPNOTSUPP if it doesn't
+	 * support port function handling for a particular port.
+	 *
+	 * Note: @extack can be NULL when port notifier queries the port function.
+	 */
+	int (*port_function_hw_addr_get)(struct devlink *devlink, struct devlink_port *port,
+					 u8 *hw_addr, int *hw_addr_len,
+					 struct netlink_ext_ack *extack);
+	/**
+	 * @port_function_hw_addr_set: Port function's hardware address set function.
+	 *
+	 * Should be used by device drivers to set the hardware address of a function
+	 * managed by the devlink port. Driver should return -EOPNOTSUPP if it doesn't
+	 * support port function handling for a particular port.
+	 */
+	int (*port_function_hw_addr_set)(struct devlink *devlink, struct devlink_port *port,
+					 const u8 *hw_addr, int hw_addr_len,
+					 struct netlink_ext_ack *extack);
+};
+
+struct devlink_trap_ops {
 	/**
 	 * @trap_init: Trap initialization function.
 	 *
@@ -1129,28 +1159,6 @@ struct devlink_ops {
 	int (*trap_policer_counter_get)(struct devlink *devlink,
 					const struct devlink_trap_policer *policer,
 					u64 *p_drops);
-	/**
-	 * @port_function_hw_addr_get: Port function's hardware address get function.
-	 *
-	 * Should be used by device drivers to report the hardware address of a function managed
-	 * by the devlink port. Driver should return -EOPNOTSUPP if it doesn't support port
-	 * function handling for a particular port.
-	 *
-	 * Note: @extack can be NULL when port notifier queries the port function.
-	 */
-	int (*port_function_hw_addr_get)(struct devlink *devlink, struct devlink_port *port,
-					 u8 *hw_addr, int *hw_addr_len,
-					 struct netlink_ext_ack *extack);
-	/**
-	 * @port_function_hw_addr_set: Port function's hardware address set function.
-	 *
-	 * Should be used by device drivers to set the hardware address of a function managed
-	 * by the devlink port. Driver should return -EOPNOTSUPP if it doesn't support port
-	 * function handling for a particular port.
-	 */
-	int (*port_function_hw_addr_set)(struct devlink *devlink, struct devlink_port *port,
-					 const u8 *hw_addr, int hw_addr_len,
-					 struct netlink_ext_ack *extack);
 };
 
 static inline void *devlink_priv(struct devlink *devlink)
@@ -1380,6 +1388,7 @@ void devlink_flash_update_status_notify(struct devlink *devlink,
 					unsigned long done,
 					unsigned long total);
 
+void devlink_traps_ops(struct devlink *devlink, const struct devlink_trap_ops *op);
 int devlink_traps_register(struct devlink *devlink,
 			   const struct devlink_trap *traps,
 			   size_t traps_count, void *priv);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 58c8bb07fa19..a30b5444289b 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6152,12 +6152,18 @@ struct devlink_trap_item {
 	void *priv;
 };
 
+static struct devlink_trap_mngr *
+devlink_trap_get_trap_mngr_from_info(struct devlink *devlink, struct genl_info *info)
+{
+		return &devlink->trap_mngr;
+}
+
 static struct devlink_trap_policer_item *
-devlink_trap_policer_item_lookup(struct devlink *devlink, u32 id)
+devlink_trap_policer_item_lookup(struct devlink_trap_mngr *trap_mngr, u32 id)
 {
 	struct devlink_trap_policer_item *policer_item;
 
-	list_for_each_entry(policer_item, &devlink->trap_policer_list, list) {
+	list_for_each_entry(policer_item, &trap_mngr->trap_policer_list, list) {
 		if (policer_item->policer->id == id)
 			return policer_item;
 	}
@@ -6166,11 +6172,11 @@ devlink_trap_policer_item_lookup(struct devlink *devlink, u32 id)
 }
 
 static struct devlink_trap_item *
-devlink_trap_item_lookup(struct devlink *devlink, const char *name)
+devlink_trap_item_lookup(struct devlink_trap_mngr *trap_mngr, const char *name)
 {
 	struct devlink_trap_item *trap_item;
 
-	list_for_each_entry(trap_item, &devlink->trap_list, list) {
+	list_for_each_entry(trap_item, &trap_mngr->trap_list, list) {
 		if (!strcmp(trap_item->trap->name, name))
 			return trap_item;
 	}
@@ -6179,8 +6185,7 @@ devlink_trap_item_lookup(struct devlink *devlink, const char *name)
 }
 
 static struct devlink_trap_item *
-devlink_trap_item_get_from_info(struct devlink *devlink,
-				struct genl_info *info)
+devlink_trap_item_get_from_info(struct devlink_trap_mngr *trap_mngr, struct genl_info *info)
 {
 	struct nlattr *attr;
 
@@ -6188,7 +6193,7 @@ devlink_trap_item_get_from_info(struct devlink *devlink,
 		return NULL;
 	attr = info->attrs[DEVLINK_ATTR_TRAP_NAME];
 
-	return devlink_trap_item_lookup(devlink, nla_data(attr));
+	return devlink_trap_item_lookup(trap_mngr, nla_data(attr));
 }
 
 static int
@@ -6343,14 +6348,13 @@ static int devlink_nl_cmd_trap_get_doit(struct sk_buff *skb,
 {
 	struct netlink_ext_ack *extack = info->extack;
 	struct devlink *devlink = info->user_ptr[0];
+	struct devlink_trap_mngr *trap_mngr;
 	struct devlink_trap_item *trap_item;
 	struct sk_buff *msg;
 	int err;
 
-	if (list_empty(&devlink->trap_list))
-		return -EOPNOTSUPP;
-
-	trap_item = devlink_trap_item_get_from_info(devlink, info);
+	trap_mngr = devlink_trap_get_trap_mngr_from_info(devlink, info);
+	trap_item = devlink_trap_item_get_from_info(trap_mngr, info);
 	if (!trap_item) {
 		NL_SET_ERR_MSG_MOD(extack, "Device did not register this trap");
 		return -ENOENT;
@@ -6376,6 +6380,7 @@ static int devlink_nl_cmd_trap_get_doit(struct sk_buff *skb,
 static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 					  struct netlink_callback *cb)
 {
+	struct devlink_trap_mngr *trap_mngr;
 	struct devlink_trap_item *trap_item;
 	struct devlink *devlink;
 	int start = cb->args[0];
@@ -6386,8 +6391,9 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 	list_for_each_entry(devlink, &devlink_list, list) {
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			continue;
+		trap_mngr = &devlink->trap_mngr;
 		mutex_lock(&devlink->lock);
-		list_for_each_entry(trap_item, &devlink->trap_list, list) {
+		list_for_each_entry(trap_item, &trap_mngr->trap_list, list) {
 			if (idx < start) {
 				idx++;
 				continue;
@@ -6413,6 +6419,7 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 }
 
 static int __devlink_trap_action_set(struct devlink *devlink,
+				     struct devlink_trap_mngr *trap_mngr,
 				     struct devlink_trap_item *trap_item,
 				     enum devlink_trap_action trap_action,
 				     struct netlink_ext_ack *extack)
@@ -6425,8 +6432,8 @@ static int __devlink_trap_action_set(struct devlink *devlink,
 		return 0;
 	}
 
-	err = devlink->ops->trap_action_set(devlink, trap_item->trap,
-					    trap_action, extack);
+	err = trap_mngr->trap_ops->trap_action_set(devlink, trap_item->trap,
+						   trap_action, extack);
 	if (err)
 		return err;
 
@@ -6436,6 +6443,7 @@ static int __devlink_trap_action_set(struct devlink *devlink,
 }
 
 static int devlink_trap_action_set(struct devlink *devlink,
+				   struct devlink_trap_mngr *trap_mngr,
 				   struct devlink_trap_item *trap_item,
 				   struct genl_info *info)
 {
@@ -6451,7 +6459,7 @@ static int devlink_trap_action_set(struct devlink *devlink,
 		return -EINVAL;
 	}
 
-	return __devlink_trap_action_set(devlink, trap_item, trap_action,
+	return __devlink_trap_action_set(devlink, trap_mngr, trap_item, trap_action,
 					 info->extack);
 }
 
@@ -6460,19 +6468,21 @@ static int devlink_nl_cmd_trap_set_doit(struct sk_buff *skb,
 {
 	struct netlink_ext_ack *extack = info->extack;
 	struct devlink *devlink = info->user_ptr[0];
+	struct devlink_trap_mngr *trap_mngr;
 	struct devlink_trap_item *trap_item;
 	int err;
 
-	if (list_empty(&devlink->trap_list))
+	trap_mngr = devlink_trap_get_trap_mngr_from_info(devlink, info);
+	if (list_empty(&trap_mngr->trap_list))
 		return -EOPNOTSUPP;
 
-	trap_item = devlink_trap_item_get_from_info(devlink, info);
+	trap_item = devlink_trap_item_get_from_info(trap_mngr, info);
 	if (!trap_item) {
 		NL_SET_ERR_MSG_MOD(extack, "Device did not register this trap");
 		return -ENOENT;
 	}
 
-	err = devlink_trap_action_set(devlink, trap_item, info);
+	err = devlink_trap_action_set(devlink, trap_mngr, trap_item, info);
 	if (err)
 		return err;
 
@@ -6480,11 +6490,11 @@ static int devlink_nl_cmd_trap_set_doit(struct sk_buff *skb,
 }
 
 static struct devlink_trap_group_item *
-devlink_trap_group_item_lookup(struct devlink *devlink, const char *name)
+devlink_trap_group_item_lookup(struct devlink_trap_mngr *trap_mngr, const char *name)
 {
 	struct devlink_trap_group_item *group_item;
 
-	list_for_each_entry(group_item, &devlink->trap_group_list, list) {
+	list_for_each_entry(group_item, &trap_mngr->trap_group_list, list) {
 		if (!strcmp(group_item->group->name, name))
 			return group_item;
 	}
@@ -6493,11 +6503,11 @@ devlink_trap_group_item_lookup(struct devlink *devlink, const char *name)
 }
 
 static struct devlink_trap_group_item *
-devlink_trap_group_item_lookup_by_id(struct devlink *devlink, u16 id)
+devlink_trap_group_item_lookup_by_id(struct devlink_trap_mngr *trap_mngr, u16 id)
 {
 	struct devlink_trap_group_item *group_item;
 
-	list_for_each_entry(group_item, &devlink->trap_group_list, list) {
+	list_for_each_entry(group_item, &trap_mngr->trap_group_list, list) {
 		if (group_item->group->id == id)
 			return group_item;
 	}
@@ -6506,7 +6516,7 @@ devlink_trap_group_item_lookup_by_id(struct devlink *devlink, u16 id)
 }
 
 static struct devlink_trap_group_item *
-devlink_trap_group_item_get_from_info(struct devlink *devlink,
+devlink_trap_group_item_get_from_info(struct devlink_trap_mngr *trap_mngr,
 				      struct genl_info *info)
 {
 	char *name;
@@ -6515,7 +6525,7 @@ devlink_trap_group_item_get_from_info(struct devlink *devlink,
 		return NULL;
 	name = nla_data(info->attrs[DEVLINK_ATTR_TRAP_GROUP_NAME]);
 
-	return devlink_trap_group_item_lookup(devlink, name);
+	return devlink_trap_group_item_lookup(trap_mngr, name);
 }
 
 static int
@@ -6566,13 +6576,15 @@ static int devlink_nl_cmd_trap_group_get_doit(struct sk_buff *skb,
 	struct netlink_ext_ack *extack = info->extack;
 	struct devlink *devlink = info->user_ptr[0];
 	struct devlink_trap_group_item *group_item;
+	struct devlink_trap_mngr *trap_mngr;
 	struct sk_buff *msg;
 	int err;
 
-	if (list_empty(&devlink->trap_group_list))
+	trap_mngr = devlink_trap_get_trap_mngr_from_info(devlink, info);
+	if (list_empty(&trap_mngr->trap_group_list))
 		return -EOPNOTSUPP;
 
-	group_item = devlink_trap_group_item_get_from_info(devlink, info);
+	group_item = devlink_trap_group_item_get_from_info(trap_mngr, info);
 	if (!group_item) {
 		NL_SET_ERR_MSG_MOD(extack, "Device did not register this trap group");
 		return -ENOENT;
@@ -6601,6 +6613,7 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 	enum devlink_command cmd = DEVLINK_CMD_TRAP_GROUP_NEW;
 	struct devlink_trap_group_item *group_item;
 	u32 portid = NETLINK_CB(cb->skb).portid;
+	struct devlink_trap_mngr *trap_mngr;
 	struct devlink *devlink;
 	int start = cb->args[0];
 	int idx = 0;
@@ -6608,10 +6621,11 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 
 	mutex_lock(&devlink_mutex);
 	list_for_each_entry(devlink, &devlink_list, list) {
+		trap_mngr = &devlink->trap_mngr;
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			continue;
 		mutex_lock(&devlink->lock);
-		list_for_each_entry(group_item, &devlink->trap_group_list,
+		list_for_each_entry(group_item, &trap_mngr->trap_group_list,
 				    list) {
 			if (idx < start) {
 				idx++;
@@ -6639,6 +6653,7 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 
 static int
 __devlink_trap_group_action_set(struct devlink *devlink,
+				struct devlink_trap_mngr *trap_mngr,
 				struct devlink_trap_group_item *group_item,
 				enum devlink_trap_action trap_action,
 				struct netlink_ext_ack *extack)
@@ -6647,10 +6662,10 @@ __devlink_trap_group_action_set(struct devlink *devlink,
 	struct devlink_trap_item *trap_item;
 	int err;
 
-	list_for_each_entry(trap_item, &devlink->trap_list, list) {
+	list_for_each_entry(trap_item, &trap_mngr->trap_list, list) {
 		if (strcmp(trap_item->group_item->group->name, group_name))
 			continue;
-		err = __devlink_trap_action_set(devlink, trap_item,
+		err = __devlink_trap_action_set(devlink, trap_mngr, trap_item,
 						trap_action, extack);
 		if (err)
 			return err;
@@ -6661,6 +6676,7 @@ __devlink_trap_group_action_set(struct devlink *devlink,
 
 static int
 devlink_trap_group_action_set(struct devlink *devlink,
+			      struct devlink_trap_mngr *trap_mngr,
 			      struct devlink_trap_group_item *group_item,
 			      struct genl_info *info, bool *p_modified)
 {
@@ -6676,7 +6692,7 @@ devlink_trap_group_action_set(struct devlink *devlink,
 		return -EINVAL;
 	}
 
-	err = __devlink_trap_group_action_set(devlink, group_item, trap_action,
+	err = __devlink_trap_group_action_set(devlink, trap_mngr, group_item, trap_action,
 					      info->extack);
 	if (err)
 		return err;
@@ -6687,6 +6703,7 @@ devlink_trap_group_action_set(struct devlink *devlink,
 }
 
 static int devlink_trap_group_set(struct devlink *devlink,
+				  struct devlink_trap_mngr *trap_mngr,
 				  struct devlink_trap_group_item *group_item,
 				  struct genl_info *info)
 {
@@ -6699,7 +6716,7 @@ static int devlink_trap_group_set(struct devlink *devlink,
 	if (!attrs[DEVLINK_ATTR_TRAP_POLICER_ID])
 		return 0;
 
-	if (!devlink->ops->trap_group_set)
+	if (!trap_mngr->trap_ops->trap_group_set)
 		return -EOPNOTSUPP;
 
 	policer_item = group_item->policer_item;
@@ -6707,8 +6724,7 @@ static int devlink_trap_group_set(struct devlink *devlink,
 		u32 policer_id;
 
 		policer_id = nla_get_u32(attrs[DEVLINK_ATTR_TRAP_POLICER_ID]);
-		policer_item = devlink_trap_policer_item_lookup(devlink,
-								policer_id);
+		policer_item = devlink_trap_policer_item_lookup(trap_mngr, policer_id);
 		if (policer_id && !policer_item) {
 			NL_SET_ERR_MSG_MOD(extack, "Device did not register this trap policer");
 			return -ENOENT;
@@ -6716,8 +6732,8 @@ static int devlink_trap_group_set(struct devlink *devlink,
 	}
 	policer = policer_item ? policer_item->policer : NULL;
 
-	err = devlink->ops->trap_group_set(devlink, group_item->group, policer,
-					   extack);
+	err = trap_mngr->trap_ops->trap_group_set(devlink, group_item->group, policer,
+						  extack);
 	if (err)
 		return err;
 
@@ -6732,24 +6748,26 @@ static int devlink_nl_cmd_trap_group_set_doit(struct sk_buff *skb,
 	struct netlink_ext_ack *extack = info->extack;
 	struct devlink *devlink = info->user_ptr[0];
 	struct devlink_trap_group_item *group_item;
+	struct devlink_trap_mngr *trap_mngr;
 	bool modified = false;
 	int err;
 
-	if (list_empty(&devlink->trap_group_list))
+	trap_mngr = devlink_trap_get_trap_mngr_from_info(devlink, info);
+	if (list_empty(&trap_mngr->trap_group_list))
 		return -EOPNOTSUPP;
 
-	group_item = devlink_trap_group_item_get_from_info(devlink, info);
+	group_item = devlink_trap_group_item_get_from_info(trap_mngr, info);
 	if (!group_item) {
 		NL_SET_ERR_MSG_MOD(extack, "Device did not register this trap group");
 		return -ENOENT;
 	}
 
-	err = devlink_trap_group_action_set(devlink, group_item, info,
+	err = devlink_trap_group_action_set(devlink, trap_mngr, group_item, info,
 					    &modified);
 	if (err)
 		return err;
 
-	err = devlink_trap_group_set(devlink, group_item, info);
+	err = devlink_trap_group_set(devlink, trap_mngr, group_item, info);
 	if (err)
 		goto err_trap_group_set;
 
@@ -6762,7 +6780,7 @@ static int devlink_nl_cmd_trap_group_set_doit(struct sk_buff *skb,
 }
 
 static struct devlink_trap_policer_item *
-devlink_trap_policer_item_get_from_info(struct devlink *devlink,
+devlink_trap_policer_item_get_from_info(struct devlink_trap_mngr *trap_mngr,
 					struct genl_info *info)
 {
 	u32 id;
@@ -6771,21 +6789,22 @@ devlink_trap_policer_item_get_from_info(struct devlink *devlink,
 		return NULL;
 	id = nla_get_u32(info->attrs[DEVLINK_ATTR_TRAP_POLICER_ID]);
 
-	return devlink_trap_policer_item_lookup(devlink, id);
+	return devlink_trap_policer_item_lookup(trap_mngr, id);
 }
 
 static int
 devlink_trap_policer_stats_put(struct sk_buff *msg, struct devlink *devlink,
-			       const struct devlink_trap_policer *policer)
+			       const struct devlink_trap_policer *policer,
+			       struct devlink_trap_mngr *trap_mngr)
 {
 	struct nlattr *attr;
 	u64 drops;
 	int err;
 
-	if (!devlink->ops->trap_policer_counter_get)
+	if (!trap_mngr->trap_ops->trap_policer_counter_get)
 		return 0;
 
-	err = devlink->ops->trap_policer_counter_get(devlink, policer, &drops);
+	err = trap_mngr->trap_ops->trap_policer_counter_get(devlink, policer, &drops);
 	if (err)
 		return err;
 
@@ -6810,6 +6829,7 @@ static int
 devlink_nl_trap_policer_fill(struct sk_buff *msg, struct devlink *devlink,
 			     const struct devlink_trap_policer_item *policer_item,
 			     enum devlink_command cmd, u32 portid, u32 seq,
+			     struct devlink_trap_mngr *trap_mngr,
 			     int flags)
 {
 	void *hdr;
@@ -6835,7 +6855,7 @@ devlink_nl_trap_policer_fill(struct sk_buff *msg, struct devlink *devlink,
 		goto nla_put_failure;
 
 	err = devlink_trap_policer_stats_put(msg, devlink,
-					     policer_item->policer);
+					     policer_item->policer, trap_mngr);
 	if (err)
 		goto nla_put_failure;
 
@@ -6854,13 +6874,15 @@ static int devlink_nl_cmd_trap_policer_get_doit(struct sk_buff *skb,
 	struct devlink_trap_policer_item *policer_item;
 	struct netlink_ext_ack *extack = info->extack;
 	struct devlink *devlink = info->user_ptr[0];
+	struct devlink_trap_mngr *trap_mngr;
 	struct sk_buff *msg;
 	int err;
 
-	if (list_empty(&devlink->trap_policer_list))
+	trap_mngr = devlink_trap_get_trap_mngr_from_info(devlink, info);
+	if (list_empty(&trap_mngr->trap_policer_list))
 		return -EOPNOTSUPP;
 
-	policer_item = devlink_trap_policer_item_get_from_info(devlink, info);
+	policer_item = devlink_trap_policer_item_get_from_info(trap_mngr, info);
 	if (!policer_item) {
 		NL_SET_ERR_MSG_MOD(extack, "Device did not register this trap policer");
 		return -ENOENT;
@@ -6872,7 +6894,7 @@ static int devlink_nl_cmd_trap_policer_get_doit(struct sk_buff *skb,
 
 	err = devlink_nl_trap_policer_fill(msg, devlink, policer_item,
 					   DEVLINK_CMD_TRAP_POLICER_NEW,
-					   info->snd_portid, info->snd_seq, 0);
+					   info->snd_portid, info->snd_seq, trap_mngr, 0);
 	if (err)
 		goto err_trap_policer_fill;
 
@@ -6889,6 +6911,7 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 	enum devlink_command cmd = DEVLINK_CMD_TRAP_POLICER_NEW;
 	struct devlink_trap_policer_item *policer_item;
 	u32 portid = NETLINK_CB(cb->skb).portid;
+	struct devlink_trap_mngr *trap_mngr;
 	struct devlink *devlink;
 	int start = cb->args[0];
 	int idx = 0;
@@ -6896,10 +6919,11 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 
 	mutex_lock(&devlink_mutex);
 	list_for_each_entry(devlink, &devlink_list, list) {
+		trap_mngr = &devlink->trap_mngr;
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			continue;
 		mutex_lock(&devlink->lock);
-		list_for_each_entry(policer_item, &devlink->trap_policer_list,
+		list_for_each_entry(policer_item, &trap_mngr->trap_policer_list,
 				    list) {
 			if (idx < start) {
 				idx++;
@@ -6909,6 +6933,7 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 							   policer_item, cmd,
 							   portid,
 							   cb->nlh->nlmsg_seq,
+							   trap_mngr,
 							   NLM_F_MULTI);
 			if (err) {
 				mutex_unlock(&devlink->lock);
@@ -6926,7 +6951,7 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 }
 
 static int
-devlink_trap_policer_set(struct devlink *devlink,
+devlink_trap_policer_set(struct devlink *devlink, struct devlink_trap_mngr *trap_mngr,
 			 struct devlink_trap_policer_item *policer_item,
 			 struct genl_info *info)
 {
@@ -6964,8 +6989,8 @@ devlink_trap_policer_set(struct devlink *devlink,
 		return -EINVAL;
 	}
 
-	err = devlink->ops->trap_policer_set(devlink, policer_item->policer,
-					     rate, burst, info->extack);
+	err = trap_mngr->trap_ops->trap_policer_set(devlink, policer_item->policer,
+						    rate, burst, info->extack);
 	if (err)
 		return err;
 
@@ -6981,20 +7006,22 @@ static int devlink_nl_cmd_trap_policer_set_doit(struct sk_buff *skb,
 	struct devlink_trap_policer_item *policer_item;
 	struct netlink_ext_ack *extack = info->extack;
 	struct devlink *devlink = info->user_ptr[0];
+	struct devlink_trap_mngr *trap_mngr;
 
-	if (list_empty(&devlink->trap_policer_list))
+	trap_mngr = devlink_trap_get_trap_mngr_from_info(devlink, info);
+	if (list_empty(&trap_mngr->trap_policer_list))
 		return -EOPNOTSUPP;
 
-	if (!devlink->ops->trap_policer_set)
+	if (!trap_mngr->trap_ops->trap_policer_set)
 		return -EOPNOTSUPP;
 
-	policer_item = devlink_trap_policer_item_get_from_info(devlink, info);
+	policer_item = devlink_trap_policer_item_get_from_info(trap_mngr, info);
 	if (!policer_item) {
 		NL_SET_ERR_MSG_MOD(extack, "Device did not register this trap policer");
 		return -ENOENT;
 	}
 
-	return devlink_trap_policer_set(devlink, policer_item, info);
+	return devlink_trap_policer_set(devlink, trap_mngr, policer_item, info);
 }
 
 static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
@@ -7396,9 +7423,9 @@ struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size)
 	INIT_LIST_HEAD(&devlink->param_list);
 	INIT_LIST_HEAD(&devlink->region_list);
 	INIT_LIST_HEAD(&devlink->reporter_list);
-	INIT_LIST_HEAD(&devlink->trap_list);
-	INIT_LIST_HEAD(&devlink->trap_group_list);
-	INIT_LIST_HEAD(&devlink->trap_policer_list);
+	INIT_LIST_HEAD(&devlink->trap_mngr.trap_list);
+	INIT_LIST_HEAD(&devlink->trap_mngr.trap_group_list);
+	INIT_LIST_HEAD(&devlink->trap_mngr.trap_policer_list);
 	mutex_init(&devlink->lock);
 	mutex_init(&devlink->reporters_lock);
 	return devlink;
@@ -7483,9 +7510,9 @@ void devlink_free(struct devlink *devlink)
 {
 	mutex_destroy(&devlink->reporters_lock);
 	mutex_destroy(&devlink->lock);
-	WARN_ON(!list_empty(&devlink->trap_policer_list));
-	WARN_ON(!list_empty(&devlink->trap_group_list));
-	WARN_ON(!list_empty(&devlink->trap_list));
+	WARN_ON(!list_empty(&devlink->trap_mngr.trap_policer_list));
+	WARN_ON(!list_empty(&devlink->trap_mngr.trap_group_list));
+	WARN_ON(!list_empty(&devlink->trap_mngr.trap_list));
 	WARN_ON(!list_empty(&devlink->reporter_list));
 	WARN_ON(!list_empty(&devlink->region_list));
 	WARN_ON(!list_empty(&devlink->param_list));
@@ -8945,13 +8972,13 @@ devlink_trap_group_notify(struct devlink *devlink,
 }
 
 static int
-devlink_trap_item_group_link(struct devlink *devlink,
+devlink_trap_item_group_link(struct devlink_trap_mngr *trap_mngr,
 			     struct devlink_trap_item *trap_item)
 {
 	u16 group_id = trap_item->trap->init_group_id;
 	struct devlink_trap_group_item *group_item;
 
-	group_item = devlink_trap_group_item_lookup_by_id(devlink, group_id);
+	group_item = devlink_trap_group_item_lookup_by_id(trap_mngr, group_id);
 	if (WARN_ON_ONCE(!group_item))
 		return -EINVAL;
 
@@ -8985,13 +9012,13 @@ static void devlink_trap_notify(struct devlink *devlink,
 }
 
 static int
-devlink_trap_register(struct devlink *devlink,
+devlink_trap_register(struct devlink *devlink, struct devlink_trap_mngr *trap_mngr,
 		      const struct devlink_trap *trap, void *priv)
 {
 	struct devlink_trap_item *trap_item;
 	int err;
 
-	if (devlink_trap_item_lookup(devlink, trap->name))
+	if (devlink_trap_item_lookup(trap_mngr, trap->name))
 		return -EEXIST;
 
 	trap_item = kzalloc(sizeof(*trap_item), GFP_KERNEL);
@@ -9008,15 +9035,15 @@ devlink_trap_register(struct devlink *devlink,
 	trap_item->action = trap->init_action;
 	trap_item->priv = priv;
 
-	err = devlink_trap_item_group_link(devlink, trap_item);
+	err = devlink_trap_item_group_link(trap_mngr, trap_item);
 	if (err)
 		goto err_group_link;
 
-	err = devlink->ops->trap_init(devlink, trap, trap_item);
+	err = trap_mngr->trap_ops->trap_init(devlink, trap, trap_item);
 	if (err)
 		goto err_trap_init;
 
-	list_add_tail(&trap_item->list, &devlink->trap_list);
+	list_add_tail(&trap_item->list, &trap_mngr->trap_list);
 	devlink_trap_notify(devlink, trap_item, DEVLINK_CMD_TRAP_NEW);
 
 	return 0;
@@ -9030,36 +9057,48 @@ devlink_trap_register(struct devlink *devlink,
 }
 
 static void devlink_trap_unregister(struct devlink *devlink,
+				    struct devlink_trap_mngr *trap_mngr,
 				    const struct devlink_trap *trap)
 {
 	struct devlink_trap_item *trap_item;
 
-	trap_item = devlink_trap_item_lookup(devlink, trap->name);
+	trap_item = devlink_trap_item_lookup(trap_mngr, trap->name);
 	if (WARN_ON_ONCE(!trap_item))
 		return;
 
 	devlink_trap_notify(devlink, trap_item, DEVLINK_CMD_TRAP_DEL);
 	list_del(&trap_item->list);
-	if (devlink->ops->trap_fini)
-		devlink->ops->trap_fini(devlink, trap, trap_item);
+	if (trap_mngr->trap_ops->trap_fini)
+		trap_mngr->trap_ops->trap_fini(devlink, trap, trap_item);
 	free_percpu(trap_item->stats);
 	kfree(trap_item);
 }
 
 static void devlink_trap_disable(struct devlink *devlink,
+				 struct devlink_trap_mngr *trap_mngr,
 				 const struct devlink_trap *trap)
 {
 	struct devlink_trap_item *trap_item;
 
-	trap_item = devlink_trap_item_lookup(devlink, trap->name);
+	trap_item = devlink_trap_item_lookup(trap_mngr, trap->name);
 	if (WARN_ON_ONCE(!trap_item))
 		return;
 
-	devlink->ops->trap_action_set(devlink, trap, DEVLINK_TRAP_ACTION_DROP,
-				      NULL);
+	trap_mngr->trap_ops->trap_action_set(devlink, trap, DEVLINK_TRAP_ACTION_DROP, NULL);
 	trap_item->action = DEVLINK_TRAP_ACTION_DROP;
 }
 
+/**
+ * devlink_traps_ops - Register trap callbacks
+ * @devlink: devlink.
+ * @ops: trap ops
+ */
+void devlink_traps_ops(struct devlink *devlink, const struct devlink_trap_ops *ops)
+{
+	devlink->trap_mngr.trap_ops = ops;
+}
+EXPORT_SYMBOL_GPL(devlink_traps_ops);
+
 /**
  * devlink_traps_register - Register packet traps with devlink.
  * @devlink: devlink.
@@ -9073,9 +9112,10 @@ int devlink_traps_register(struct devlink *devlink,
 			   const struct devlink_trap *traps,
 			   size_t traps_count, void *priv)
 {
+	struct devlink_trap_mngr *trap_mngr = &devlink->trap_mngr;
 	int i, err;
 
-	if (!devlink->ops->trap_init || !devlink->ops->trap_action_set)
+	if (!trap_mngr->trap_ops->trap_init || !trap_mngr->trap_ops->trap_action_set)
 		return -EINVAL;
 
 	mutex_lock(&devlink->lock);
@@ -9086,7 +9126,7 @@ int devlink_traps_register(struct devlink *devlink,
 		if (err)
 			goto err_trap_verify;
 
-		err = devlink_trap_register(devlink, trap, priv);
+		err = devlink_trap_register(devlink, &devlink->trap_mngr, trap, priv);
 		if (err)
 			goto err_trap_register;
 	}
@@ -9097,7 +9137,7 @@ int devlink_traps_register(struct devlink *devlink,
 err_trap_register:
 err_trap_verify:
 	for (i--; i >= 0; i--)
-		devlink_trap_unregister(devlink, &traps[i]);
+		devlink_trap_unregister(devlink, trap_mngr, &traps[i]);
 	mutex_unlock(&devlink->lock);
 	return err;
 }
@@ -9113,6 +9153,7 @@ void devlink_traps_unregister(struct devlink *devlink,
 			      const struct devlink_trap *traps,
 			      size_t traps_count)
 {
+	struct devlink_trap_mngr *trap_mngr = &devlink->trap_mngr;
 	int i;
 
 	mutex_lock(&devlink->lock);
@@ -9120,10 +9161,10 @@ void devlink_traps_unregister(struct devlink *devlink,
 	 * traps by disabling all of them and waiting for a grace period.
 	 */
 	for (i = traps_count - 1; i >= 0; i--)
-		devlink_trap_disable(devlink, &traps[i]);
+		devlink_trap_disable(devlink, trap_mngr, &traps[i]);
 	synchronize_rcu();
 	for (i = traps_count - 1; i >= 0; i--)
-		devlink_trap_unregister(devlink, &traps[i]);
+		devlink_trap_unregister(devlink, trap_mngr, &traps[i]);
 	mutex_unlock(&devlink->lock);
 }
 EXPORT_SYMBOL_GPL(devlink_traps_unregister);
@@ -9206,7 +9247,7 @@ void *devlink_trap_ctx_priv(void *trap_ctx)
 EXPORT_SYMBOL_GPL(devlink_trap_ctx_priv);
 
 static int
-devlink_trap_group_item_policer_link(struct devlink *devlink,
+devlink_trap_group_item_policer_link(struct devlink_trap_mngr *trap_mngr,
 				     struct devlink_trap_group_item *group_item)
 {
 	u32 policer_id = group_item->group->init_policer_id;
@@ -9215,7 +9256,7 @@ devlink_trap_group_item_policer_link(struct devlink *devlink,
 	if (policer_id == 0)
 		return 0;
 
-	policer_item = devlink_trap_policer_item_lookup(devlink, policer_id);
+	policer_item = devlink_trap_policer_item_lookup(trap_mngr, policer_id);
 	if (WARN_ON_ONCE(!policer_item))
 		return -EINVAL;
 
@@ -9225,13 +9266,13 @@ devlink_trap_group_item_policer_link(struct devlink *devlink,
 }
 
 static int
-devlink_trap_group_register(struct devlink *devlink,
+devlink_trap_group_register(struct devlink *devlink, struct devlink_trap_mngr *trap_mngr,
 			    const struct devlink_trap_group *group)
 {
 	struct devlink_trap_group_item *group_item;
 	int err;
 
-	if (devlink_trap_group_item_lookup(devlink, group->name))
+	if (devlink_trap_group_item_lookup(trap_mngr, group->name))
 		return -EEXIST;
 
 	group_item = kzalloc(sizeof(*group_item), GFP_KERNEL);
@@ -9246,17 +9287,17 @@ devlink_trap_group_register(struct devlink *devlink,
 
 	group_item->group = group;
 
-	err = devlink_trap_group_item_policer_link(devlink, group_item);
+	err = devlink_trap_group_item_policer_link(trap_mngr, group_item);
 	if (err)
 		goto err_policer_link;
 
-	if (devlink->ops->trap_group_init) {
-		err = devlink->ops->trap_group_init(devlink, group);
+	if (trap_mngr->trap_ops->trap_group_init) {
+		err = trap_mngr->trap_ops->trap_group_init(devlink, group);
 		if (err)
 			goto err_group_init;
 	}
 
-	list_add_tail(&group_item->list, &devlink->trap_group_list);
+	list_add_tail(&group_item->list, &trap_mngr->trap_group_list);
 	devlink_trap_group_notify(devlink, group_item,
 				  DEVLINK_CMD_TRAP_GROUP_NEW);
 
@@ -9271,12 +9312,12 @@ devlink_trap_group_register(struct devlink *devlink,
 }
 
 static void
-devlink_trap_group_unregister(struct devlink *devlink,
+devlink_trap_group_unregister(struct devlink *devlink, struct devlink_trap_mngr *trap_mngr,
 			      const struct devlink_trap_group *group)
 {
 	struct devlink_trap_group_item *group_item;
 
-	group_item = devlink_trap_group_item_lookup(devlink, group->name);
+	group_item = devlink_trap_group_item_lookup(trap_mngr, group->name);
 	if (WARN_ON_ONCE(!group_item))
 		return;
 
@@ -9299,6 +9340,7 @@ int devlink_trap_groups_register(struct devlink *devlink,
 				 const struct devlink_trap_group *groups,
 				 size_t groups_count)
 {
+	struct devlink_trap_mngr *trap_mngr = &devlink->trap_mngr;
 	int i, err;
 
 	mutex_lock(&devlink->lock);
@@ -9309,7 +9351,7 @@ int devlink_trap_groups_register(struct devlink *devlink,
 		if (err)
 			goto err_trap_group_verify;
 
-		err = devlink_trap_group_register(devlink, group);
+		err = devlink_trap_group_register(devlink, trap_mngr, group);
 		if (err)
 			goto err_trap_group_register;
 	}
@@ -9320,7 +9362,7 @@ int devlink_trap_groups_register(struct devlink *devlink,
 err_trap_group_register:
 err_trap_group_verify:
 	for (i--; i >= 0; i--)
-		devlink_trap_group_unregister(devlink, &groups[i]);
+		devlink_trap_group_unregister(devlink, trap_mngr, &groups[i]);
 	mutex_unlock(&devlink->lock);
 	return err;
 }
@@ -9340,7 +9382,7 @@ void devlink_trap_groups_unregister(struct devlink *devlink,
 
 	mutex_lock(&devlink->lock);
 	for (i = groups_count - 1; i >= 0; i--)
-		devlink_trap_group_unregister(devlink, &groups[i]);
+		devlink_trap_group_unregister(devlink, &devlink->trap_mngr, &groups[i]);
 	mutex_unlock(&devlink->lock);
 }
 EXPORT_SYMBOL_GPL(devlink_trap_groups_unregister);
@@ -9361,7 +9403,7 @@ devlink_trap_policer_notify(struct devlink *devlink,
 		return;
 
 	err = devlink_nl_trap_policer_fill(msg, devlink, policer_item, cmd, 0,
-					   0, 0);
+					   0, &devlink->trap_mngr, 0);
 	if (err) {
 		nlmsg_free(msg);
 		return;
@@ -9372,13 +9414,13 @@ devlink_trap_policer_notify(struct devlink *devlink,
 }
 
 static int
-devlink_trap_policer_register(struct devlink *devlink,
+devlink_trap_policer_register(struct devlink *devlink, struct devlink_trap_mngr *trap_mngr,
 			      const struct devlink_trap_policer *policer)
 {
 	struct devlink_trap_policer_item *policer_item;
 	int err;
 
-	if (devlink_trap_policer_item_lookup(devlink, policer->id))
+	if (devlink_trap_policer_item_lookup(trap_mngr, policer->id))
 		return -EEXIST;
 
 	policer_item = kzalloc(sizeof(*policer_item), GFP_KERNEL);
@@ -9389,13 +9431,13 @@ devlink_trap_policer_register(struct devlink *devlink,
 	policer_item->rate = policer->init_rate;
 	policer_item->burst = policer->init_burst;
 
-	if (devlink->ops->trap_policer_init) {
-		err = devlink->ops->trap_policer_init(devlink, policer);
+	if (trap_mngr->trap_ops->trap_policer_init) {
+		err = trap_mngr->trap_ops->trap_policer_init(devlink, policer);
 		if (err)
 			goto err_policer_init;
 	}
 
-	list_add_tail(&policer_item->list, &devlink->trap_policer_list);
+	list_add_tail(&policer_item->list, &trap_mngr->trap_policer_list);
 	devlink_trap_policer_notify(devlink, policer_item,
 				    DEVLINK_CMD_TRAP_POLICER_NEW);
 
@@ -9408,19 +9450,20 @@ devlink_trap_policer_register(struct devlink *devlink,
 
 static void
 devlink_trap_policer_unregister(struct devlink *devlink,
+				struct devlink_trap_mngr *trap_mngr,
 				const struct devlink_trap_policer *policer)
 {
 	struct devlink_trap_policer_item *policer_item;
 
-	policer_item = devlink_trap_policer_item_lookup(devlink, policer->id);
+	policer_item = devlink_trap_policer_item_lookup(trap_mngr, policer->id);
 	if (WARN_ON_ONCE(!policer_item))
 		return;
 
 	devlink_trap_policer_notify(devlink, policer_item,
 				    DEVLINK_CMD_TRAP_POLICER_DEL);
 	list_del(&policer_item->list);
-	if (devlink->ops->trap_policer_fini)
-		devlink->ops->trap_policer_fini(devlink, policer);
+	if (trap_mngr->trap_ops->trap_policer_fini)
+		trap_mngr->trap_ops->trap_policer_fini(devlink, policer);
 	kfree(policer_item);
 }
 
@@ -9437,6 +9480,7 @@ devlink_trap_policers_register(struct devlink *devlink,
 			       const struct devlink_trap_policer *policers,
 			       size_t policers_count)
 {
+	struct devlink_trap_mngr *trap_mngr = &devlink->trap_mngr;
 	int i, err;
 
 	mutex_lock(&devlink->lock);
@@ -9450,7 +9494,7 @@ devlink_trap_policers_register(struct devlink *devlink,
 			goto err_trap_policer_verify;
 		}
 
-		err = devlink_trap_policer_register(devlink, policer);
+		err = devlink_trap_policer_register(devlink, trap_mngr, policer);
 		if (err)
 			goto err_trap_policer_register;
 	}
@@ -9461,7 +9505,7 @@ devlink_trap_policers_register(struct devlink *devlink,
 err_trap_policer_register:
 err_trap_policer_verify:
 	for (i--; i >= 0; i--)
-		devlink_trap_policer_unregister(devlink, &policers[i]);
+		devlink_trap_policer_unregister(devlink, trap_mngr, &policers[i]);
 	mutex_unlock(&devlink->lock);
 	return err;
 }
@@ -9478,11 +9522,12 @@ devlink_trap_policers_unregister(struct devlink *devlink,
 				 const struct devlink_trap_policer *policers,
 				 size_t policers_count)
 {
+	struct devlink_trap_mngr *trap_mngr = &devlink->trap_mngr;
 	int i;
 
 	mutex_lock(&devlink->lock);
 	for (i = policers_count - 1; i >= 0; i--)
-		devlink_trap_policer_unregister(devlink, &policers[i]);
+		devlink_trap_policer_unregister(devlink, trap_mngr, &policers[i]);
 	mutex_unlock(&devlink->lock);
 }
 EXPORT_SYMBOL_GPL(devlink_trap_policers_unregister);
-- 
2.14.1

