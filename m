Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEB6440C43
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 01:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbhJ3XPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 19:15:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:36698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231459AbhJ3XP3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 19:15:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CF9160F55;
        Sat, 30 Oct 2021 23:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635635578;
        bh=l7hPLVkK8F2hz2ObOed4CC4Ob9KlbSmYeKrUgfgBmE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f1eEujsKrCrPfLkiBWO+OqaWD0WUn80oqS9L846tCwIZ0ETxXY1lDwWQ78WXaxOrw
         T+3++aNscbDUYkEx7HFCxWMzZARODprfJUgugH6jbwooG1PBIIeppO7CWCywxaVEG/
         KV+Zbv03/aK3HJUmAwVirZuR07Ep/viiNjfnuv2Fhz7OJnXMCEggYOcW1YtMkhl5UU
         CAcGc8RMnTNEUy1I2hYuh6uvHG2vPmqd7XpfsDJWdxWic6sBP9LL58owkd8u4HQnyO
         1RR3NMA3pa34RDIhkez/kdbth2zxAuV+Ed+gjb4nPU8Eus/4/FhTVyqHTzbDGB5hW1
         brjDHc16Wbtyg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     leon@kernel.org, idosch@idosch.org
Cc:     edwin.peer@broadcom.com, jiri@resnulli.us, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC 1/5] devlink: add unlocked APIs
Date:   Sat, 30 Oct 2021 16:12:50 -0700
Message-Id: <20211030231254.2477599-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211030231254.2477599-1-kuba@kernel.org>
References: <20211030231254.2477599-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Much noise...

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/devlink.h |  60 ++++
 net/core/devlink.c    | 696 +++++++++++++++++++++++++++---------------
 2 files changed, 514 insertions(+), 242 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index aab3d007c577..d8e4274e2af4 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1514,7 +1514,11 @@ void devlink_free(struct devlink *devlink);
 int devlink_port_register(struct devlink *devlink,
 			  struct devlink_port *devlink_port,
 			  unsigned int port_index);
+int __devlink_port_register(struct devlink *devlink,
+			    struct devlink_port *devlink_port,
+			    unsigned int port_index);
 void devlink_port_unregister(struct devlink_port *devlink_port);
+void __devlink_port_unregister(struct devlink_port *devlink_port);
 void devlink_port_type_eth_set(struct devlink_port *devlink_port,
 			       struct net_device *netdev);
 void devlink_port_type_ib_set(struct devlink_port *devlink_port,
@@ -1530,8 +1534,11 @@ void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port,
 				   u32 controller, u16 pf, u32 sf,
 				   bool external);
 int devlink_rate_leaf_create(struct devlink_port *port, void *priv);
+int __devlink_rate_leaf_create(struct devlink_port *port, void *priv);
 void devlink_rate_leaf_destroy(struct devlink_port *devlink_port);
+void __devlink_rate_leaf_destroy(struct devlink_port *devlink_port);
 void devlink_rate_nodes_destroy(struct devlink *devlink);
+void __devlink_rate_nodes_destroy(struct devlink *devlink);
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u32 size, u16 ingress_pools_count,
 			u16 egress_pools_count, u16 ingress_tc_count,
@@ -1567,11 +1574,23 @@ int devlink_resource_register(struct devlink *devlink,
 			      u64 resource_id,
 			      u64 parent_resource_id,
 			      const struct devlink_resource_size_params *size_params);
+int __devlink_resource_register(struct devlink *devlink,
+				const char *resource_name,
+				u64 resource_size,
+				u64 resource_id,
+				u64 parent_resource_id,
+				const struct devlink_resource_size_params *size_params);
+
 void devlink_resources_unregister(struct devlink *devlink,
 				  struct devlink_resource *resource);
+void __devlink_resources_unregister(struct devlink *devlink,
+				    struct devlink_resource *resource);
 int devlink_resource_size_get(struct devlink *devlink,
 			      u64 resource_id,
 			      u64 *p_resource_size);
+int __devlink_resource_size_get(struct devlink *devlink,
+				u64 resource_id,
+				u64 *p_resource_size);
 int devlink_dpipe_table_resource_set(struct devlink *devlink,
 				     const char *table_name, u64 resource_id,
 				     u64 resource_units);
@@ -1579,14 +1598,26 @@ void devlink_resource_occ_get_register(struct devlink *devlink,
 				       u64 resource_id,
 				       devlink_resource_occ_get_t *occ_get,
 				       void *occ_get_priv);
+void __devlink_resource_occ_get_register(struct devlink *devlink,
+					 u64 resource_id,
+					 devlink_resource_occ_get_t *occ_get,
+					 void *occ_get_priv);
 void devlink_resource_occ_get_unregister(struct devlink *devlink,
 					 u64 resource_id);
+void __devlink_resource_occ_get_unregister(struct devlink *devlink,
+					   u64 resource_id);
 int devlink_params_register(struct devlink *devlink,
 			    const struct devlink_param *params,
 			    size_t params_count);
+int __devlink_params_register(struct devlink *devlink,
+			      const struct devlink_param *params,
+			      size_t params_count);
 void devlink_params_unregister(struct devlink *devlink,
 			       const struct devlink_param *params,
 			       size_t params_count);
+void __devlink_params_unregister(struct devlink *devlink,
+				 const struct devlink_param *params,
+				 size_t params_count);
 int devlink_param_register(struct devlink *devlink,
 			   const struct devlink_param *param);
 void devlink_param_unregister(struct devlink *devlink,
@@ -1601,16 +1632,25 @@ devlink_region_create(struct devlink *devlink,
 		      const struct devlink_region_ops *ops,
 		      u32 region_max_snapshots, u64 region_size);
 struct devlink_region *
+__devlink_region_create(struct devlink *devlink,
+			const struct devlink_region_ops *ops,
+			u32 region_max_snapshots, u64 region_size);
+struct devlink_region *
 devlink_port_region_create(struct devlink_port *port,
 			   const struct devlink_port_region_ops *ops,
 			   u32 region_max_snapshots, u64 region_size);
 void devlink_region_destroy(struct devlink_region *region);
+void __devlink_region_destroy(struct devlink_region *region);
 void devlink_port_region_destroy(struct devlink_region *region);
 
 int devlink_region_snapshot_id_get(struct devlink *devlink, u32 *id);
+int __devlink_region_snapshot_id_get(struct devlink *devlink, u32 *id);
 void devlink_region_snapshot_id_put(struct devlink *devlink, u32 id);
+void __devlink_region_snapshot_id_put(struct devlink *devlink, u32 id);
 int devlink_region_snapshot_create(struct devlink_region *region,
 				   u8 *data, u32 snapshot_id);
+int __devlink_region_snapshot_create(struct devlink_region *region,
+				     u8 *data, u32 snapshot_id);
 int devlink_info_serial_number_put(struct devlink_info_req *req,
 				   const char *sn);
 int devlink_info_driver_name_put(struct devlink_info_req *req,
@@ -1702,9 +1742,15 @@ void devlink_flash_update_timeout_notify(struct devlink *devlink,
 int devlink_traps_register(struct devlink *devlink,
 			   const struct devlink_trap *traps,
 			   size_t traps_count, void *priv);
+int __devlink_traps_register(struct devlink *devlink,
+			     const struct devlink_trap *traps,
+			     size_t traps_count, void *priv);
 void devlink_traps_unregister(struct devlink *devlink,
 			      const struct devlink_trap *traps,
 			      size_t traps_count);
+void __devlink_traps_unregister(struct devlink *devlink,
+				const struct devlink_trap *traps,
+				size_t traps_count);
 void devlink_trap_report(struct devlink *devlink, struct sk_buff *skb,
 			 void *trap_ctx, struct devlink_port *in_devlink_port,
 			 const struct flow_action_cookie *fa_cookie);
@@ -1712,17 +1758,31 @@ void *devlink_trap_ctx_priv(void *trap_ctx);
 int devlink_trap_groups_register(struct devlink *devlink,
 				 const struct devlink_trap_group *groups,
 				 size_t groups_count);
+int __devlink_trap_groups_register(struct devlink *devlink,
+				   const struct devlink_trap_group *groups,
+				   size_t groups_count);
 void devlink_trap_groups_unregister(struct devlink *devlink,
 				    const struct devlink_trap_group *groups,
 				    size_t groups_count);
+void __devlink_trap_groups_unregister(struct devlink *devlink,
+				      const struct devlink_trap_group *groups,
+				      size_t groups_count);
 int
 devlink_trap_policers_register(struct devlink *devlink,
 			       const struct devlink_trap_policer *policers,
 			       size_t policers_count);
+int
+__devlink_trap_policers_register(struct devlink *devlink,
+				 const struct devlink_trap_policer *policers,
+				 size_t policers_count);
 void
 devlink_trap_policers_unregister(struct devlink *devlink,
 				 const struct devlink_trap_policer *policers,
 				 size_t policers_count);
+void
+__devlink_trap_policers_unregister(struct devlink *devlink,
+				   const struct devlink_trap_policer *policers,
+				   size_t policers_count);
 
 #if IS_ENABLED(CONFIG_NET_DEVLINK)
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 6b5ee862429e..9ea0c0bbc796 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5323,13 +5323,14 @@ static int __devlink_snapshot_id_insert(struct devlink *devlink, u32 id)
  *	avoid race conditions. The caller must release its hold on the
  *	snapshot by using devlink_region_snapshot_id_put.
  */
-static int __devlink_region_snapshot_id_get(struct devlink *devlink, u32 *id)
+int __devlink_region_snapshot_id_get(struct devlink *devlink, u32 *id)
 {
 	lockdep_assert_held(&devlink->lock);
 
 	return xa_alloc(&devlink->snapshot_ids, id, xa_mk_value(1),
 			xa_limit_32b, GFP_KERNEL);
 }
+EXPORT_SYMBOL_GPL(__devlink_region_snapshot_id_get);
 
 /**
  *	__devlink_region_snapshot_create - create a new snapshot
@@ -5345,9 +5346,8 @@ static int __devlink_region_snapshot_id_get(struct devlink *devlink, u32 *id)
  *	@data: snapshot data
  *	@snapshot_id: snapshot id to be created
  */
-static int
-__devlink_region_snapshot_create(struct devlink_region *region,
-				 u8 *data, u32 snapshot_id)
+int __devlink_region_snapshot_create(struct devlink_region *region,
+				     u8 *data, u32 snapshot_id)
 {
 	struct devlink *devlink = region->devlink;
 	struct devlink_snapshot *snapshot;
@@ -5385,6 +5385,7 @@ __devlink_region_snapshot_create(struct devlink_region *region,
 	kfree(snapshot);
 	return err;
 }
+EXPORT_SYMBOL_GPL(__devlink_region_snapshot_create);
 
 static void devlink_region_snapshot_del(struct devlink_region *region,
 					struct devlink_snapshot *snapshot)
@@ -9204,6 +9205,32 @@ static void devlink_port_type_warn_cancel(struct devlink_port *devlink_port)
 	cancel_delayed_work_sync(&devlink_port->type_warn_dw);
 }
 
+int __devlink_port_register(struct devlink *devlink,
+			    struct devlink_port *devlink_port,
+			    unsigned int port_index)
+{
+	lockdep_assert_held(&devlink->lock);
+
+	if (devlink_port_index_exists(devlink, port_index))
+		return -EEXIST;
+
+	WARN_ON(devlink_port->devlink);
+	devlink_port->devlink = devlink;
+	devlink_port->index = port_index;
+	spin_lock_init(&devlink_port->type_lock);
+	INIT_LIST_HEAD(&devlink_port->reporter_list);
+	mutex_init(&devlink_port->reporters_lock);
+	list_add_tail(&devlink_port->list, &devlink->port_list);
+	INIT_LIST_HEAD(&devlink_port->param_list);
+	INIT_LIST_HEAD(&devlink_port->region_list);
+
+	INIT_DELAYED_WORK(&devlink_port->type_warn_dw, &devlink_port_type_warn);
+	devlink_port_type_warn_schedule(devlink_port);
+	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__devlink_port_register);
+
 /**
  *	devlink_port_register - Register devlink port
  *
@@ -9221,29 +9248,28 @@ int devlink_port_register(struct devlink *devlink,
 			  struct devlink_port *devlink_port,
 			  unsigned int port_index)
 {
-	mutex_lock(&devlink->lock);
-	if (devlink_port_index_exists(devlink, port_index)) {
-		mutex_unlock(&devlink->lock);
-		return -EEXIST;
-	}
+	int err;
 
-	WARN_ON(devlink_port->devlink);
-	devlink_port->devlink = devlink;
-	devlink_port->index = port_index;
-	spin_lock_init(&devlink_port->type_lock);
-	INIT_LIST_HEAD(&devlink_port->reporter_list);
-	mutex_init(&devlink_port->reporters_lock);
-	list_add_tail(&devlink_port->list, &devlink->port_list);
-	INIT_LIST_HEAD(&devlink_port->param_list);
-	INIT_LIST_HEAD(&devlink_port->region_list);
+	mutex_lock(&devlink->lock);
+	err = __devlink_port_register(devlink, devlink_port, port_index);
 	mutex_unlock(&devlink->lock);
-	INIT_DELAYED_WORK(&devlink_port->type_warn_dw, &devlink_port_type_warn);
-	devlink_port_type_warn_schedule(devlink_port);
-	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_port_register);
 
+void __devlink_port_unregister(struct devlink_port *devlink_port)
+{
+	lockdep_assert_held(&devlink_port->devlink->lock);
+
+	devlink_port_type_warn_cancel(devlink_port);
+	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
+	list_del(&devlink_port->list);
+	WARN_ON(!list_empty(&devlink_port->reporter_list));
+	WARN_ON(!list_empty(&devlink_port->region_list));
+	mutex_destroy(&devlink_port->reporters_lock);
+}
+EXPORT_SYMBOL_GPL(__devlink_port_unregister);
+
 /**
  *	devlink_port_unregister - Unregister devlink port
  *
@@ -9253,14 +9279,9 @@ void devlink_port_unregister(struct devlink_port *devlink_port)
 {
 	struct devlink *devlink = devlink_port->devlink;
 
-	devlink_port_type_warn_cancel(devlink_port);
-	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
 	mutex_lock(&devlink->lock);
-	list_del(&devlink_port->list);
+	__devlink_port_unregister(devlink_port);
 	mutex_unlock(&devlink->lock);
-	WARN_ON(!list_empty(&devlink_port->reporter_list));
-	WARN_ON(!list_empty(&devlink_port->region_list));
-	mutex_destroy(&devlink_port->reporters_lock);
 }
 EXPORT_SYMBOL_GPL(devlink_port_unregister);
 
@@ -9480,30 +9501,17 @@ void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port, u32 contro
 }
 EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_sf_set);
 
-/**
- * devlink_rate_leaf_create - create devlink rate leaf
- *
- * @devlink_port: devlink port object to create rate object on
- * @priv: driver private data
- *
- * Create devlink rate object of type leaf on provided @devlink_port.
- * Throws call trace if @devlink_port already has a devlink rate object.
- *
- * Context: Takes and release devlink->lock <mutex>.
- *
- * Return: -ENOMEM if failed to allocate rate object, 0 otherwise.
- */
-int
-devlink_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
+int __devlink_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
 {
 	struct devlink *devlink = devlink_port->devlink;
 	struct devlink_rate *devlink_rate;
 
+	lockdep_assert_held(&devlink->lock);
+
 	devlink_rate = kzalloc(sizeof(*devlink_rate), GFP_KERNEL);
 	if (!devlink_rate)
 		return -ENOMEM;
 
-	mutex_lock(&devlink->lock);
 	WARN_ON(devlink_port->devlink_rate);
 	devlink_rate->type = DEVLINK_RATE_TYPE_LEAF;
 	devlink_rate->devlink = devlink;
@@ -9512,54 +9520,79 @@ devlink_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
 	list_add_tail(&devlink_rate->list, &devlink->rate_list);
 	devlink_port->devlink_rate = devlink_rate;
 	devlink_rate_notify(devlink_rate, DEVLINK_CMD_RATE_NEW);
-	mutex_unlock(&devlink->lock);
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(devlink_rate_leaf_create);
+EXPORT_SYMBOL_GPL(__devlink_rate_leaf_create);
 
 /**
- * devlink_rate_leaf_destroy - destroy devlink rate leaf
+ * devlink_rate_leaf_create - create devlink rate leaf
  *
- * @devlink_port: devlink port linked to the rate object
+ * @devlink_port: devlink port object to create rate object on
+ * @priv: driver private data
+ *
+ * Create devlink rate object of type leaf on provided @devlink_port.
+ * Throws call trace if @devlink_port already has a devlink rate object.
  *
  * Context: Takes and release devlink->lock <mutex>.
+ *
+ * Return: -ENOMEM if failed to allocate rate object, 0 otherwise.
  */
-void devlink_rate_leaf_destroy(struct devlink_port *devlink_port)
+int
+devlink_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
 {
-	struct devlink_rate *devlink_rate = devlink_port->devlink_rate;
 	struct devlink *devlink = devlink_port->devlink;
+	int err;
+
+	mutex_lock(&devlink->lock);
+	err = __devlink_rate_leaf_create(devlink_port, priv);
+	mutex_unlock(&devlink->lock);
+	return err;
+}
+EXPORT_SYMBOL_GPL(devlink_rate_leaf_create);
+
+void __devlink_rate_leaf_destroy(struct devlink_port *devlink_port)
+{
+	struct devlink_rate *devlink_rate = devlink_port->devlink_rate;
+
+	lockdep_assert_held(&devlink_port->devlink->lock);
 
 	if (!devlink_rate)
 		return;
 
-	mutex_lock(&devlink->lock);
 	devlink_rate_notify(devlink_rate, DEVLINK_CMD_RATE_DEL);
 	if (devlink_rate->parent)
 		refcount_dec(&devlink_rate->parent->refcnt);
 	list_del(&devlink_rate->list);
 	devlink_port->devlink_rate = NULL;
-	mutex_unlock(&devlink->lock);
 	kfree(devlink_rate);
 }
-EXPORT_SYMBOL_GPL(devlink_rate_leaf_destroy);
+EXPORT_SYMBOL_GPL(__devlink_rate_leaf_destroy);
 
 /**
- * devlink_rate_nodes_destroy - destroy all devlink rate nodes on device
- *
- * @devlink: devlink instance
+ * devlink_rate_leaf_destroy - destroy devlink rate leaf
  *
- * Unset parent for all rate objects and destroy all rate nodes
- * on specified device.
+ * @devlink_port: devlink port linked to the rate object
  *
  * Context: Takes and release devlink->lock <mutex>.
  */
-void devlink_rate_nodes_destroy(struct devlink *devlink)
+void devlink_rate_leaf_destroy(struct devlink_port *devlink_port)
+{
+	struct devlink *devlink = devlink_port->devlink;
+
+	mutex_lock(&devlink->lock);
+	__devlink_rate_leaf_destroy(devlink_port);
+	mutex_unlock(&devlink->lock);
+}
+EXPORT_SYMBOL_GPL(devlink_rate_leaf_destroy);
+
+void __devlink_rate_nodes_destroy(struct devlink *devlink)
 {
 	static struct devlink_rate *devlink_rate, *tmp;
 	const struct devlink_ops *ops = devlink->ops;
 
-	mutex_lock(&devlink->lock);
+	lockdep_assert_held(&devlink->lock);
+
 	list_for_each_entry(devlink_rate, &devlink->rate_list, list) {
 		if (!devlink_rate->parent)
 			continue;
@@ -9580,6 +9613,23 @@ void devlink_rate_nodes_destroy(struct devlink *devlink)
 			kfree(devlink_rate);
 		}
 	}
+}
+EXPORT_SYMBOL_GPL(__devlink_rate_nodes_destroy);
+
+/**
+ * devlink_rate_nodes_destroy - destroy all devlink rate nodes on device
+ *
+ * @devlink: devlink instance
+ *
+ * Unset parent for all rate objects and destroy all rate nodes
+ * on specified device.
+ *
+ * Context: Takes and release devlink->lock <mutex>.
+ */
+void devlink_rate_nodes_destroy(struct devlink *devlink)
+{
+	mutex_lock(&devlink->lock);
+	__devlink_rate_nodes_destroy(devlink);
 	mutex_unlock(&devlink->lock);
 }
 EXPORT_SYMBOL_GPL(devlink_rate_nodes_destroy);
@@ -9830,46 +9880,28 @@ void devlink_dpipe_table_unregister(struct devlink *devlink,
 }
 EXPORT_SYMBOL_GPL(devlink_dpipe_table_unregister);
 
-/**
- *	devlink_resource_register - devlink resource register
- *
- *	@devlink: devlink
- *	@resource_name: resource's name
- *	@resource_size: resource's size
- *	@resource_id: resource's id
- *	@parent_resource_id: resource's parent id
- *	@size_params: size parameters
- *
- *	Generic resources should reuse the same names across drivers.
- *	Please see the generic resources list at:
- *	Documentation/networking/devlink/devlink-resource.rst
- */
-int devlink_resource_register(struct devlink *devlink,
-			      const char *resource_name,
-			      u64 resource_size,
-			      u64 resource_id,
-			      u64 parent_resource_id,
-			      const struct devlink_resource_size_params *size_params)
+int __devlink_resource_register(struct devlink *devlink,
+				const char *resource_name,
+				u64 resource_size,
+				u64 resource_id,
+				u64 parent_resource_id,
+				const struct devlink_resource_size_params *size_params)
 {
 	struct devlink_resource *resource;
 	struct list_head *resource_list;
 	bool top_hierarchy;
-	int err = 0;
+
+	lockdep_assert_held(&devlink->lock);
 
 	top_hierarchy = parent_resource_id == DEVLINK_RESOURCE_ID_PARENT_TOP;
 
-	mutex_lock(&devlink->lock);
 	resource = devlink_resource_find(devlink, NULL, resource_id);
-	if (resource) {
-		err = -EINVAL;
-		goto out;
-	}
+	if (resource)
+		return -EINVAL;
 
 	resource = kzalloc(sizeof(*resource), GFP_KERNEL);
-	if (!resource) {
-		err = -ENOMEM;
-		goto out;
-	}
+	if (!resource)
+		return -ENOMEM;
 
 	if (top_hierarchy) {
 		resource_list = &devlink->resource_list;
@@ -9883,8 +9915,7 @@ int devlink_resource_register(struct devlink *devlink,
 			resource->parent = parent_resource;
 		} else {
 			kfree(resource);
-			err = -EINVAL;
-			goto out;
+			return -EINVAL;
 		}
 	}
 
@@ -9897,20 +9928,45 @@ int devlink_resource_register(struct devlink *devlink,
 	       sizeof(resource->size_params));
 	INIT_LIST_HEAD(&resource->resource_list);
 	list_add_tail(&resource->list, resource_list);
-out:
-	mutex_unlock(&devlink->lock);
-	return err;
+
+	return 0;
 }
-EXPORT_SYMBOL_GPL(devlink_resource_register);
+EXPORT_SYMBOL_GPL(__devlink_resource_register);
 
 /**
- *	devlink_resources_unregister - free all resources
+ *	devlink_resource_register - devlink resource register
  *
  *	@devlink: devlink
- *	@resource: resource
+ *	@resource_name: resource's name
+ *	@resource_size: resource's size
+ *	@resource_id: resource's id
+ *	@parent_resource_id: resource's parent id
+ *	@size_params: size parameters
+ *
+ *	Generic resources should reuse the same names across drivers.
+ *	Please see the generic resources list at:
+ *	Documentation/networking/devlink/devlink-resource.rst
  */
-void devlink_resources_unregister(struct devlink *devlink,
-				  struct devlink_resource *resource)
+int devlink_resource_register(struct devlink *devlink,
+			      const char *resource_name,
+			      u64 resource_size,
+			      u64 resource_id,
+			      u64 parent_resource_id,
+			      const struct devlink_resource_size_params *size_params)
+{
+	int err;
+
+	mutex_lock(&devlink->lock);
+	err = __devlink_resource_register(devlink, resource_name, resource_size,
+					  resource_id, parent_resource_id,
+					  size_params);
+	mutex_unlock(&devlink->lock);
+	return err;
+}
+
+static void ____devlink_resources_unregister(struct devlink *devlink,
+					     struct devlink_resource *resource,
+					     bool locked)
 {
 	struct devlink_resource *tmp, *child_resource;
 	struct list_head *resource_list;
@@ -9920,7 +9976,7 @@ void devlink_resources_unregister(struct devlink *devlink,
 	else
 		resource_list = &devlink->resource_list;
 
-	if (!resource)
+	if (!resource && !locked)
 		mutex_lock(&devlink->lock);
 
 	list_for_each_entry_safe(child_resource, tmp, resource_list, list) {
@@ -9929,11 +9985,49 @@ void devlink_resources_unregister(struct devlink *devlink,
 		kfree(child_resource);
 	}
 
-	if (!resource)
+	if (!resource && !locked)
 		mutex_unlock(&devlink->lock);
 }
+
+void __devlink_resources_unregister(struct devlink *devlink,
+				    struct devlink_resource *resource)
+{
+	lockdep_assert_held(&devlink->lock);
+	____devlink_resources_unregister(devlink, resource, true);
+}
+EXPORT_SYMBOL_GPL(__devlink_resources_unregister);
+
+/**
+ *	devlink_resources_unregister - free all resources
+ *
+ *	@devlink: devlink
+ *	@resource: resource
+ */
+void devlink_resources_unregister(struct devlink *devlink,
+				  struct devlink_resource *resource)
+{
+	____devlink_resources_unregister(devlink, resource, false);
+}
 EXPORT_SYMBOL_GPL(devlink_resources_unregister);
 
+int __devlink_resource_size_get(struct devlink *devlink,
+				u64 resource_id,
+				u64 *p_resource_size)
+{
+	struct devlink_resource *resource;
+
+	lockdep_assert_held(&devlink->lock);
+
+	resource = devlink_resource_find(devlink, NULL, resource_id);
+	if (!resource)
+		return -EINVAL;
+
+	*p_resource_size = resource->size_new;
+	resource->size = resource->size_new;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__devlink_resource_size_get);
+
 /**
  *	devlink_resource_size_get - get and update size
  *
@@ -9945,18 +10039,11 @@ int devlink_resource_size_get(struct devlink *devlink,
 			      u64 resource_id,
 			      u64 *p_resource_size)
 {
-	struct devlink_resource *resource;
-	int err = 0;
+	int err;
 
 	mutex_lock(&devlink->lock);
-	resource = devlink_resource_find(devlink, NULL, resource_id);
-	if (!resource) {
-		err = -EINVAL;
-		goto out;
-	}
-	*p_resource_size = resource->size_new;
-	resource->size = resource->size_new;
-out:
+	err = __devlink_resource_size_get(devlink, resource_id,
+					  p_resource_size);
 	mutex_unlock(&devlink->lock);
 	return err;
 }
@@ -9993,10 +10080,29 @@ int devlink_dpipe_table_resource_set(struct devlink *devlink,
 }
 EXPORT_SYMBOL_GPL(devlink_dpipe_table_resource_set);
 
-/**
- *	devlink_resource_occ_get_register - register occupancy getter
- *
- *	@devlink: devlink
+void __devlink_resource_occ_get_register(struct devlink *devlink,
+					 u64 resource_id,
+					 devlink_resource_occ_get_t *occ_get,
+					 void *occ_get_priv)
+{
+	struct devlink_resource *resource;
+
+	lockdep_assert_held(&devlink->lock);
+
+	resource = devlink_resource_find(devlink, NULL, resource_id);
+	if (WARN_ON(!resource))
+		return;
+	WARN_ON(resource->occ_get);
+
+	resource->occ_get = occ_get;
+	resource->occ_get_priv = occ_get_priv;
+}
+EXPORT_SYMBOL_GPL(__devlink_resource_occ_get_register);
+
+/**
+ *	devlink_resource_occ_get_register - register occupancy getter
+ *
+ *	@devlink: devlink
  *	@resource_id: resource id
  *	@occ_get: occupancy getter callback
  *	@occ_get_priv: occupancy getter callback priv
@@ -10005,21 +10111,30 @@ void devlink_resource_occ_get_register(struct devlink *devlink,
 				       u64 resource_id,
 				       devlink_resource_occ_get_t *occ_get,
 				       void *occ_get_priv)
+{
+	mutex_lock(&devlink->lock);
+	__devlink_resource_occ_get_register(devlink, resource_id,
+					    occ_get, occ_get_priv);
+	mutex_unlock(&devlink->lock);
+}
+EXPORT_SYMBOL_GPL(devlink_resource_occ_get_register);
+
+void __devlink_resource_occ_get_unregister(struct devlink *devlink,
+					   u64 resource_id)
 {
 	struct devlink_resource *resource;
 
-	mutex_lock(&devlink->lock);
+	lockdep_assert_held(&devlink->lock);
+
 	resource = devlink_resource_find(devlink, NULL, resource_id);
 	if (WARN_ON(!resource))
-		goto out;
-	WARN_ON(resource->occ_get);
+		return;
+	WARN_ON(!resource->occ_get);
 
-	resource->occ_get = occ_get;
-	resource->occ_get_priv = occ_get_priv;
-out:
-	mutex_unlock(&devlink->lock);
+	resource->occ_get = NULL;
+	resource->occ_get_priv = NULL;
 }
-EXPORT_SYMBOL_GPL(devlink_resource_occ_get_register);
+EXPORT_SYMBOL_GPL(__devlink_resource_occ_get_unregister);
 
 /**
  *	devlink_resource_occ_get_unregister - unregister occupancy getter
@@ -10030,17 +10145,8 @@ EXPORT_SYMBOL_GPL(devlink_resource_occ_get_register);
 void devlink_resource_occ_get_unregister(struct devlink *devlink,
 					 u64 resource_id)
 {
-	struct devlink_resource *resource;
-
 	mutex_lock(&devlink->lock);
-	resource = devlink_resource_find(devlink, NULL, resource_id);
-	if (WARN_ON(!resource))
-		goto out;
-	WARN_ON(!resource->occ_get);
-
-	resource->occ_get = NULL;
-	resource->occ_get_priv = NULL;
-out:
+	__devlink_resource_occ_get_unregister(devlink, resource_id);
 	mutex_unlock(&devlink->lock);
 }
 EXPORT_SYMBOL_GPL(devlink_resource_occ_get_unregister);
@@ -10055,24 +10161,13 @@ static int devlink_param_verify(const struct devlink_param *param)
 		return devlink_param_driver_verify(param);
 }
 
-/**
- *	devlink_params_register - register configuration parameters
- *
- *	@devlink: devlink
- *	@params: configuration parameters array
- *	@params_count: number of parameters provided
- *
- *	Register the configuration parameters supported by the driver.
- */
-int devlink_params_register(struct devlink *devlink,
-			    const struct devlink_param *params,
-			    size_t params_count)
+int __devlink_params_register(struct devlink *devlink,
+			      const struct devlink_param *params,
+			      size_t params_count)
 {
 	const struct devlink_param *param = params;
 	int i, err;
 
-	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
-
 	for (i = 0; i < params_count; i++, param++) {
 		err = devlink_param_register(devlink, param);
 		if (err)
@@ -10088,8 +10183,39 @@ int devlink_params_register(struct devlink *devlink,
 		devlink_param_unregister(devlink, param);
 	return err;
 }
+EXPORT_SYMBOL_GPL(__devlink_params_register);
+
+/**
+ *	devlink_params_register - register configuration parameters
+ *
+ *	@devlink: devlink
+ *	@params: configuration parameters array
+ *	@params_count: number of parameters provided
+ *
+ *	Register the configuration parameters supported by the driver.
+ */
+int devlink_params_register(struct devlink *devlink,
+			    const struct devlink_param *params,
+			    size_t params_count)
+{
+	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
+
+	return __devlink_params_register(devlink, params, params_count);
+}
 EXPORT_SYMBOL_GPL(devlink_params_register);
 
+void __devlink_params_unregister(struct devlink *devlink,
+				 const struct devlink_param *params,
+				 size_t params_count)
+{
+	const struct devlink_param *param = params;
+	int i;
+
+	for (i = 0; i < params_count; i++, param++)
+		devlink_param_unregister(devlink, param);
+}
+EXPORT_SYMBOL_GPL(__devlink_params_unregister);
+
 /**
  *	devlink_params_unregister - unregister configuration parameters
  *	@devlink: devlink
@@ -10100,13 +10226,9 @@ void devlink_params_unregister(struct devlink *devlink,
 			       const struct devlink_param *params,
 			       size_t params_count)
 {
-	const struct devlink_param *param = params;
-	int i;
-
 	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
 
-	for (i = 0; i < params_count; i++, param++)
-		devlink_param_unregister(devlink, param);
+	__devlink_params_unregister(devlink, params, params_count);
 }
 EXPORT_SYMBOL_GPL(devlink_params_unregister);
 
@@ -10261,37 +10383,24 @@ void devlink_param_value_changed(struct devlink *devlink, u32 param_id)
 }
 EXPORT_SYMBOL_GPL(devlink_param_value_changed);
 
-/**
- *	devlink_region_create - create a new address region
- *
- *	@devlink: devlink
- *	@ops: region operations and name
- *	@region_max_snapshots: Maximum supported number of snapshots for region
- *	@region_size: size of region
- */
 struct devlink_region *
-devlink_region_create(struct devlink *devlink,
-		      const struct devlink_region_ops *ops,
-		      u32 region_max_snapshots, u64 region_size)
+__devlink_region_create(struct devlink *devlink,
+			const struct devlink_region_ops *ops,
+			u32 region_max_snapshots, u64 region_size)
 {
 	struct devlink_region *region;
-	int err = 0;
+
+	lockdep_assert_held(&devlink->lock);
 
 	if (WARN_ON(!ops) || WARN_ON(!ops->destructor))
 		return ERR_PTR(-EINVAL);
 
-	mutex_lock(&devlink->lock);
-
-	if (devlink_region_get_by_name(devlink, ops->name)) {
-		err = -EEXIST;
-		goto unlock;
-	}
+	if (devlink_region_get_by_name(devlink, ops->name))
+		return ERR_PTR(-EEXIST);
 
 	region = kzalloc(sizeof(*region), GFP_KERNEL);
-	if (!region) {
-		err = -ENOMEM;
-		goto unlock;
-	}
+	if (!region)
+		return ERR_PTR(-ENOMEM);
 
 	region->devlink = devlink;
 	region->max_snapshots = region_max_snapshots;
@@ -10301,12 +10410,30 @@ devlink_region_create(struct devlink *devlink,
 	list_add_tail(&region->list, &devlink->region_list);
 	devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_NEW);
 
-	mutex_unlock(&devlink->lock);
 	return region;
+}
+EXPORT_SYMBOL_GPL(__devlink_region_create);
 
-unlock:
+/**
+ *	devlink_region_create - create a new address region
+ *
+ *	@devlink: devlink
+ *	@ops: region operations and name
+ *	@region_max_snapshots: Maximum supported number of snapshots for region
+ *	@region_size: size of region
+ */
+struct devlink_region *
+devlink_region_create(struct devlink *devlink,
+		      const struct devlink_region_ops *ops,
+		      u32 region_max_snapshots, u64 region_size)
+{
+	struct devlink_region *region;
+
+	mutex_lock(&devlink->lock);
+	region = __devlink_region_create(devlink, ops, region_max_snapshots,
+					 region_size);
 	mutex_unlock(&devlink->lock);
-	return ERR_PTR(err);
+	return region;
 }
 EXPORT_SYMBOL_GPL(devlink_region_create);
 
@@ -10361,17 +10488,11 @@ devlink_port_region_create(struct devlink_port *port,
 }
 EXPORT_SYMBOL_GPL(devlink_port_region_create);
 
-/**
- *	devlink_region_destroy - destroy address region
- *
- *	@region: devlink region to destroy
- */
-void devlink_region_destroy(struct devlink_region *region)
+void __devlink_region_destroy(struct devlink_region *region)
 {
-	struct devlink *devlink = region->devlink;
 	struct devlink_snapshot *snapshot, *ts;
 
-	mutex_lock(&devlink->lock);
+	lockdep_assert_held(&region->devlink->lock);
 
 	/* Free all snapshots of region */
 	list_for_each_entry_safe(snapshot, ts, &region->snapshot_list, list)
@@ -10380,9 +10501,23 @@ void devlink_region_destroy(struct devlink_region *region)
 	list_del(&region->list);
 
 	devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_DEL);
-	mutex_unlock(&devlink->lock);
 	kfree(region);
 }
+EXPORT_SYMBOL_GPL(__devlink_region_destroy);
+
+/**
+ *	devlink_region_destroy - destroy address region
+ *
+ *	@region: devlink region to destroy
+ */
+void devlink_region_destroy(struct devlink_region *region)
+{
+	struct devlink *devlink = region->devlink;
+
+	mutex_lock(&devlink->lock);
+	__devlink_region_destroy(region);
+	mutex_unlock(&devlink->lock);
+}
 EXPORT_SYMBOL_GPL(devlink_region_destroy);
 
 /**
@@ -10412,6 +10547,14 @@ int devlink_region_snapshot_id_get(struct devlink *devlink, u32 *id)
 }
 EXPORT_SYMBOL_GPL(devlink_region_snapshot_id_get);
 
+void __devlink_region_snapshot_id_put(struct devlink *devlink, u32 id)
+{
+	lockdep_assert_held(&devlink->lock);
+
+	__devlink_snapshot_id_decrement(devlink, id);
+}
+EXPORT_SYMBOL_GPL(__devlink_region_snapshot_id_put);
+
 /**
  *	devlink_region_snapshot_id_put - put snapshot ID reference
  *
@@ -10815,25 +10958,17 @@ static void devlink_trap_disable(struct devlink *devlink,
 	trap_item->action = DEVLINK_TRAP_ACTION_DROP;
 }
 
-/**
- * devlink_traps_register - Register packet traps with devlink.
- * @devlink: devlink.
- * @traps: Packet traps.
- * @traps_count: Count of provided packet traps.
- * @priv: Driver private information.
- *
- * Return: Non-zero value on failure.
- */
-int devlink_traps_register(struct devlink *devlink,
-			   const struct devlink_trap *traps,
-			   size_t traps_count, void *priv)
+int __devlink_traps_register(struct devlink *devlink,
+			     const struct devlink_trap *traps,
+			     size_t traps_count, void *priv)
 {
 	int i, err;
 
+	lockdep_assert_held(&devlink->lock);
+
 	if (!devlink->ops->trap_init || !devlink->ops->trap_action_set)
 		return -EINVAL;
 
-	mutex_lock(&devlink->lock);
 	for (i = 0; i < traps_count; i++) {
 		const struct devlink_trap *trap = &traps[i];
 
@@ -10845,7 +10980,6 @@ int devlink_traps_register(struct devlink *devlink,
 		if (err)
 			goto err_trap_register;
 	}
-	mutex_unlock(&devlink->lock);
 
 	return 0;
 
@@ -10853,24 +10987,40 @@ int devlink_traps_register(struct devlink *devlink,
 err_trap_verify:
 	for (i--; i >= 0; i--)
 		devlink_trap_unregister(devlink, &traps[i]);
-	mutex_unlock(&devlink->lock);
 	return err;
 }
-EXPORT_SYMBOL_GPL(devlink_traps_register);
+EXPORT_SYMBOL_GPL(__devlink_traps_register);
 
 /**
- * devlink_traps_unregister - Unregister packet traps from devlink.
+ * devlink_traps_register - Register packet traps with devlink.
  * @devlink: devlink.
  * @traps: Packet traps.
  * @traps_count: Count of provided packet traps.
+ * @priv: Driver private information.
+ *
+ * Return: Non-zero value on failure.
  */
-void devlink_traps_unregister(struct devlink *devlink,
-			      const struct devlink_trap *traps,
-			      size_t traps_count)
+int devlink_traps_register(struct devlink *devlink,
+			   const struct devlink_trap *traps,
+			   size_t traps_count, void *priv)
 {
-	int i;
+	int err;
 
 	mutex_lock(&devlink->lock);
+	err = __devlink_traps_register(devlink, traps, traps_count, priv);
+	mutex_unlock(&devlink->lock);
+	return err;
+}
+EXPORT_SYMBOL_GPL(devlink_traps_register);
+
+void __devlink_traps_unregister(struct devlink *devlink,
+				const struct devlink_trap *traps,
+				size_t traps_count)
+{
+	int i;
+
+	lockdep_assert_held(&devlink->lock);
+
 	/* Make sure we do not have any packets in-flight while unregistering
 	 * traps by disabling all of them and waiting for a grace period.
 	 */
@@ -10879,6 +11029,21 @@ void devlink_traps_unregister(struct devlink *devlink,
 	synchronize_rcu();
 	for (i = traps_count - 1; i >= 0; i--)
 		devlink_trap_unregister(devlink, &traps[i]);
+}
+EXPORT_SYMBOL_GPL(__devlink_traps_unregister);
+
+/**
+ * devlink_traps_unregister - Unregister packet traps from devlink.
+ * @devlink: devlink.
+ * @traps: Packet traps.
+ * @traps_count: Count of provided packet traps.
+ */
+void devlink_traps_unregister(struct devlink *devlink,
+			      const struct devlink_trap *traps,
+			      size_t traps_count)
+{
+	mutex_lock(&devlink->lock);
+	__devlink_traps_unregister(devlink, traps, traps_count);
 	mutex_unlock(&devlink->lock);
 }
 EXPORT_SYMBOL_GPL(devlink_traps_unregister);
@@ -11037,21 +11202,14 @@ devlink_trap_group_unregister(struct devlink *devlink,
 	kfree(group_item);
 }
 
-/**
- * devlink_trap_groups_register - Register packet trap groups with devlink.
- * @devlink: devlink.
- * @groups: Packet trap groups.
- * @groups_count: Count of provided packet trap groups.
- *
- * Return: Non-zero value on failure.
- */
-int devlink_trap_groups_register(struct devlink *devlink,
-				 const struct devlink_trap_group *groups,
-				 size_t groups_count)
+int __devlink_trap_groups_register(struct devlink *devlink,
+				   const struct devlink_trap_group *groups,
+				   size_t groups_count)
 {
 	int i, err;
 
-	mutex_lock(&devlink->lock);
+	lockdep_assert_held(&devlink->lock);
+
 	for (i = 0; i < groups_count; i++) {
 		const struct devlink_trap_group *group = &groups[i];
 
@@ -11063,7 +11221,6 @@ int devlink_trap_groups_register(struct devlink *devlink,
 		if (err)
 			goto err_trap_group_register;
 	}
-	mutex_unlock(&devlink->lock);
 
 	return 0;
 
@@ -11071,11 +11228,44 @@ int devlink_trap_groups_register(struct devlink *devlink,
 err_trap_group_verify:
 	for (i--; i >= 0; i--)
 		devlink_trap_group_unregister(devlink, &groups[i]);
+	return err;
+}
+EXPORT_SYMBOL_GPL(__devlink_trap_groups_register);
+
+/**
+ * devlink_trap_groups_register - Register packet trap groups with devlink.
+ * @devlink: devlink.
+ * @groups: Packet trap groups.
+ * @groups_count: Count of provided packet trap groups.
+ *
+ * Return: Non-zero value on failure.
+ */
+int devlink_trap_groups_register(struct devlink *devlink,
+				 const struct devlink_trap_group *groups,
+				 size_t groups_count)
+{
+	int err;
+
+	mutex_lock(&devlink->lock);
+	err = __devlink_trap_groups_register(devlink, groups, groups_count);
 	mutex_unlock(&devlink->lock);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_trap_groups_register);
 
+void __devlink_trap_groups_unregister(struct devlink *devlink,
+				      const struct devlink_trap_group *groups,
+				      size_t groups_count)
+{
+	int i;
+
+	lockdep_assert_held(&devlink->lock);
+
+	for (i = groups_count - 1; i >= 0; i--)
+		devlink_trap_group_unregister(devlink, &groups[i]);
+}
+EXPORT_SYMBOL_GPL(__devlink_trap_groups_unregister);
+
 /**
  * devlink_trap_groups_unregister - Unregister packet trap groups from devlink.
  * @devlink: devlink.
@@ -11086,11 +11276,8 @@ void devlink_trap_groups_unregister(struct devlink *devlink,
 				    const struct devlink_trap_group *groups,
 				    size_t groups_count)
 {
-	int i;
-
 	mutex_lock(&devlink->lock);
-	for (i = groups_count - 1; i >= 0; i--)
-		devlink_trap_group_unregister(devlink, &groups[i]);
+	__devlink_trap_groups_unregister(devlink, groups, groups_count);
 	mutex_unlock(&devlink->lock);
 }
 EXPORT_SYMBOL_GPL(devlink_trap_groups_unregister);
@@ -11176,22 +11363,15 @@ devlink_trap_policer_unregister(struct devlink *devlink,
 	kfree(policer_item);
 }
 
-/**
- * devlink_trap_policers_register - Register packet trap policers with devlink.
- * @devlink: devlink.
- * @policers: Packet trap policers.
- * @policers_count: Count of provided packet trap policers.
- *
- * Return: Non-zero value on failure.
- */
 int
-devlink_trap_policers_register(struct devlink *devlink,
-			       const struct devlink_trap_policer *policers,
-			       size_t policers_count)
+__devlink_trap_policers_register(struct devlink *devlink,
+				 const struct devlink_trap_policer *policers,
+				 size_t policers_count)
 {
 	int i, err;
 
-	mutex_lock(&devlink->lock);
+	lockdep_assert_held(&devlink->lock);
+
 	for (i = 0; i < policers_count; i++) {
 		const struct devlink_trap_policer *policer = &policers[i];
 
@@ -11206,7 +11386,6 @@ devlink_trap_policers_register(struct devlink *devlink,
 		if (err)
 			goto err_trap_policer_register;
 	}
-	mutex_unlock(&devlink->lock);
 
 	return 0;
 
@@ -11214,11 +11393,47 @@ devlink_trap_policers_register(struct devlink *devlink,
 err_trap_policer_verify:
 	for (i--; i >= 0; i--)
 		devlink_trap_policer_unregister(devlink, &policers[i]);
+	return err;
+}
+EXPORT_SYMBOL_GPL(__devlink_trap_policers_register);
+
+/**
+ * devlink_trap_policers_register - Register packet trap policers with devlink.
+ * @devlink: devlink.
+ * @policers: Packet trap policers.
+ * @policers_count: Count of provided packet trap policers.
+ *
+ * Return: Non-zero value on failure.
+ */
+int
+devlink_trap_policers_register(struct devlink *devlink,
+			       const struct devlink_trap_policer *policers,
+			       size_t policers_count)
+{
+	int err;
+
+	mutex_lock(&devlink->lock);
+	err = __devlink_trap_policers_register(devlink, policers,
+					       policers_count);
 	mutex_unlock(&devlink->lock);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_trap_policers_register);
 
+void
+__devlink_trap_policers_unregister(struct devlink *devlink,
+				   const struct devlink_trap_policer *policers,
+				   size_t policers_count)
+{
+	int i;
+
+	lockdep_assert_held(&devlink->lock);
+
+	for (i = policers_count - 1; i >= 0; i--)
+		devlink_trap_policer_unregister(devlink, &policers[i]);
+}
+EXPORT_SYMBOL_GPL(__devlink_trap_policers_unregister);
+
 /**
  * devlink_trap_policers_unregister - Unregister packet trap policers from devlink.
  * @devlink: devlink.
@@ -11230,11 +11445,8 @@ devlink_trap_policers_unregister(struct devlink *devlink,
 				 const struct devlink_trap_policer *policers,
 				 size_t policers_count)
 {
-	int i;
-
 	mutex_lock(&devlink->lock);
-	for (i = policers_count - 1; i >= 0; i--)
-		devlink_trap_policer_unregister(devlink, &policers[i]);
+	__devlink_trap_policers_unregister(devlink, policers, policers_count);
 	mutex_unlock(&devlink->lock);
 }
 EXPORT_SYMBOL_GPL(devlink_trap_policers_unregister);
-- 
2.31.1

