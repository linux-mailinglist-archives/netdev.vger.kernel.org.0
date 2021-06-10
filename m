Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 096D73A227A
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 04:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbhFJDAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 23:00:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:33754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230039AbhFJDAT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 23:00:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF3B661424;
        Thu, 10 Jun 2021 02:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623293904;
        bh=jGThM3AYIudqP/68X/qWJJjI4Fpy7yIpVSmhvnjg7TM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=haxezoFEVOhN2hMqJyV7m+eTkDBPMqOBgOvEsWM/0A9SYnbZV9l9eltV3ot0kkM4o
         VjWwmVROTmpuEbxWflwQ/GtbKIRMBp2w3sn58p5rueimQVc2utqnwDqJE8ULz7mrui
         JkmwbP0fM9+bSK9suu6V/jyVQuVM7FNxgzMXYekA5ez8GufjhBJvgN3gp1IL0kUYSN
         sfmKvHMjRmMlJ8SITY+myj7yPXMd5HcuCaVegwX1Q0skbrWPkDoMWYxbpW9xuFedNu
         Yzns1CYv5IoCP+oMx8ECcJFE6Rkq0XwU7UZRgiO5d6DN4YMR2JZwyuayBv7pXaQkSY
         xnTqFpdOH9tTA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/16] net/mlx5: Bridge, dynamic entry ageing
Date:   Wed,  9 Jun 2021 19:58:09 -0700
Message-Id: <20210610025814.274607-12-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610025814.274607-1-saeed@kernel.org>
References: <20210610025814.274607-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Dynamic FDB entries require capability to age out unused entries. Such
entries are either aged out by kernel software bridge implementation or by
hardware switch that offloaded them (and notified the kernel to mark them
as SWITCHDEV_FDB_ADD_TO_BRIDGE). Leaving ageing to kernel bridge would
result it deleting offloaded dynamic FDB entries every ageing_time period
due to packets being processed by hardware and, consecutively, 'used'
timestamp for FDB entry not being updated. However, since hardware doesn't
support ageing, software solution inside the driver is required.

In order to emulate hardware ageing in driver, extend bridge FDB ingress
flows with counter and create delayed br_offloads->update_work task on
bridge offloads workqueue. Run the task every second, update 'used'
timestamp in software bridge dynamic entry by sending
SWITCHDEV_FDB_ADD_TO_BRIDGE for the entry, if it flow hardware counter
lastuse field was changed since last update. If lastuse wasn't changed for
ageing_time period, then delete the FDB entry and notify kernel bridge by
sending SWITCHDEV_FDB_DEL_TO_BRIDGE notification.

Register blocking switchdev notifier callback and handle attribute set
SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME event to allow user to dynamically
configure bridge FDB entry ageing timeout. Save the value per-bridge in
struct mlx5_esw_bridge. Silently ignore
SWITCHDEV_ATTR_ID_PORT_{PRE_}BRIDGE_FLAGS switchdev event since mlx5 bridge
implementation relies on software bridge for implementing necessary
behavior for all of these flags.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/rep/bridge.c        |  95 ++++++++++++++++
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  | 104 ++++++++++++++++--
 .../ethernet/mellanox/mlx5/core/esw/bridge.h  |   7 +-
 3 files changed, 193 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
index b34e9cb686e3..14645f24671f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
@@ -2,12 +2,15 @@
 /* Copyright (c) 2021 Mellanox Technologies. */
 
 #include <linux/netdevice.h>
+#include <linux/if_bridge.h>
 #include <net/netevent.h>
 #include <net/switchdev.h>
 #include "bridge.h"
 #include "esw/bridge.h"
 #include "en_rep.h"
 
+#define MLX5_ESW_BRIDGE_UPDATE_INTERVAL 1000
+
 struct mlx5_bridge_switchdev_fdb_work {
 	struct work_struct work;
 	struct switchdev_notifier_fdb_info fdb_info;
@@ -72,6 +75,63 @@ static int mlx5_esw_bridge_switchdev_port_event(struct notifier_block *nb,
 	return notifier_from_errno(err);
 }
 
+static int mlx5_esw_bridge_port_obj_attr_set(struct net_device *dev,
+					     const struct switchdev_attr *attr,
+					     struct netlink_ext_ack *extack)
+{
+	struct mlx5e_rep_priv *rpriv;
+	struct mlx5_eswitch *esw;
+	struct mlx5_vport *vport;
+	struct mlx5e_priv *priv;
+	u16 vport_num;
+	int err = 0;
+
+	priv = netdev_priv(dev);
+	rpriv = priv->ppriv;
+	vport_num = rpriv->rep->vport;
+	esw = priv->mdev->priv.eswitch;
+	vport = mlx5_eswitch_get_vport(esw, vport_num);
+	if (IS_ERR(vport))
+		return PTR_ERR(vport);
+
+	switch (attr->id) {
+	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
+		if (attr->u.brport_flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD)) {
+			NL_SET_ERR_MSG_MOD(extack, "Flag is not supported");
+			err = -EINVAL;
+		}
+		break;
+	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
+		break;
+	case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
+		err = mlx5_esw_bridge_ageing_time_set(attr->u.ageing_time, esw, vport);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+	}
+
+	return err;
+}
+
+static int mlx5_esw_bridge_event_blocking(struct notifier_block *unused,
+					  unsigned long event, void *ptr)
+{
+	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
+	int err;
+
+	switch (event) {
+	case SWITCHDEV_PORT_ATTR_SET:
+		err = switchdev_handle_port_attr_set(dev, ptr,
+						     mlx5e_eswitch_rep,
+						     mlx5_esw_bridge_port_obj_attr_set);
+		break;
+	default:
+		err = 0;
+	}
+
+	return notifier_from_errno(err);
+}
+
 static void
 mlx5_esw_bridge_cleanup_switchdev_fdb_work(struct mlx5_bridge_switchdev_fdb_work *fdb_work)
 {
@@ -160,6 +220,13 @@ static int mlx5_esw_bridge_switchdev_event(struct notifier_block *nb,
 	if (priv->mdev->priv.eswitch != br_offloads->esw)
 		return NOTIFY_DONE;
 
+	if (event == SWITCHDEV_PORT_ATTR_SET) {
+		int err = switchdev_handle_port_attr_set(dev, ptr,
+							 mlx5e_eswitch_rep,
+							 mlx5_esw_bridge_port_obj_attr_set);
+		return notifier_from_errno(err);
+	}
+
 	upper = netdev_master_upper_dev_get_rcu(dev);
 	if (!upper)
 		return NOTIFY_DONE;
@@ -190,6 +257,20 @@ static int mlx5_esw_bridge_switchdev_event(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
+static void mlx5_esw_bridge_update_work(struct work_struct *work)
+{
+	struct mlx5_esw_bridge_offloads *br_offloads = container_of(work,
+								    struct mlx5_esw_bridge_offloads,
+								    update_work.work);
+
+	rtnl_lock();
+	mlx5_esw_bridge_update(br_offloads);
+	rtnl_unlock();
+
+	queue_delayed_work(br_offloads->wq, &br_offloads->update_work,
+			   msecs_to_jiffies(MLX5_ESW_BRIDGE_UPDATE_INTERVAL));
+}
+
 void mlx5e_rep_bridge_init(struct mlx5e_priv *priv)
 {
 	struct mlx5_esw_bridge_offloads *br_offloads;
@@ -211,6 +292,9 @@ void mlx5e_rep_bridge_init(struct mlx5e_priv *priv)
 		esw_warn(mdev, "Failed to allocate bridge offloads workqueue\n");
 		goto err_alloc_wq;
 	}
+	INIT_DELAYED_WORK(&br_offloads->update_work, mlx5_esw_bridge_update_work);
+	queue_delayed_work(br_offloads->wq, &br_offloads->update_work,
+			   msecs_to_jiffies(MLX5_ESW_BRIDGE_UPDATE_INTERVAL));
 
 	br_offloads->nb.notifier_call = mlx5_esw_bridge_switchdev_event;
 	err = register_switchdev_notifier(&br_offloads->nb);
@@ -219,6 +303,13 @@ void mlx5e_rep_bridge_init(struct mlx5e_priv *priv)
 		goto err_register_swdev;
 	}
 
+	br_offloads->nb_blk.notifier_call = mlx5_esw_bridge_event_blocking;
+	err = register_switchdev_blocking_notifier(&br_offloads->nb_blk);
+	if (err) {
+		esw_warn(mdev, "Failed to register blocking switchdev notifier (err=%d)\n", err);
+		goto err_register_swdev_blk;
+	}
+
 	br_offloads->netdev_nb.notifier_call = mlx5_esw_bridge_switchdev_port_event;
 	err = register_netdevice_notifier(&br_offloads->netdev_nb);
 	if (err) {
@@ -229,6 +320,8 @@ void mlx5e_rep_bridge_init(struct mlx5e_priv *priv)
 	return;
 
 err_register_netdev:
+	unregister_switchdev_blocking_notifier(&br_offloads->nb_blk);
+err_register_swdev_blk:
 	unregister_switchdev_notifier(&br_offloads->nb);
 err_register_swdev:
 	destroy_workqueue(br_offloads->wq);
@@ -248,7 +341,9 @@ void mlx5e_rep_bridge_cleanup(struct mlx5e_priv *priv)
 		return;
 
 	unregister_netdevice_notifier(&br_offloads->netdev_nb);
+	unregister_switchdev_blocking_notifier(&br_offloads->nb_blk);
 	unregister_switchdev_notifier(&br_offloads->nb);
+	cancel_delayed_work(&br_offloads->update_work);
 	destroy_workqueue(br_offloads->wq);
 	rtnl_lock();
 	mlx5_esw_bridge_cleanup(esw);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index 6dd47891189c..557dac5e9745 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -4,6 +4,7 @@
 #include <linux/netdevice.h>
 #include <linux/list.h>
 #include <linux/rhashtable.h>
+#include <linux/if_bridge.h>
 #include <net/switchdev.h>
 #include "bridge.h"
 #include "eswitch.h"
@@ -27,13 +28,21 @@ struct mlx5_esw_bridge_fdb_key {
 	u16 vid;
 };
 
+enum {
+	MLX5_ESW_BRIDGE_FLAG_ADDED_BY_USER = BIT(0),
+};
+
 struct mlx5_esw_bridge_fdb_entry {
 	struct mlx5_esw_bridge_fdb_key key;
 	struct rhash_head ht_node;
+	struct net_device *dev;
 	struct list_head list;
 	u16 vport_num;
+	u16 flags;
 
 	struct mlx5_flow_handle *ingress_handle;
+	struct mlx5_fc *ingress_counter;
+	unsigned long lastuse;
 	struct mlx5_flow_handle *egress_handle;
 };
 
@@ -55,6 +64,7 @@ struct mlx5_esw_bridge {
 
 	struct mlx5_flow_table *egress_ft;
 	struct mlx5_flow_group *egress_mac_fg;
+	unsigned long ageing_time;
 };
 
 static void
@@ -238,17 +248,14 @@ mlx5_esw_bridge_egress_table_cleanup(struct mlx5_esw_bridge *bridge)
 
 static struct mlx5_flow_handle *
 mlx5_esw_bridge_ingress_flow_create(u16 vport_num, const unsigned char *addr, u16 vid,
-				    struct mlx5_esw_bridge *bridge)
+				    u32 counter_id, struct mlx5_esw_bridge *bridge)
 {
 	struct mlx5_esw_bridge_offloads *br_offloads = bridge->br_offloads;
-	struct mlx5_flow_destination dest = {
-		.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE,
-		.ft = bridge->egress_ft,
-	};
 	struct mlx5_flow_act flow_act = {
-		.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST,
+		.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST | MLX5_FLOW_CONTEXT_ACTION_COUNT,
 		.flags = FLOW_ACT_NO_APPEND,
 	};
+	struct mlx5_flow_destination dests[2] = {};
 	struct mlx5_flow_spec *rule_spec;
 	struct mlx5_flow_handle *handle;
 	u8 *smac_v, *smac_c;
@@ -271,7 +278,13 @@ mlx5_esw_bridge_ingress_flow_create(u16 vport_num, const unsigned char *addr, u1
 	MLX5_SET(fte_match_param, rule_spec->match_value, misc_parameters_2.metadata_reg_c_0,
 		 mlx5_eswitch_get_vport_metadata_for_match(br_offloads->esw, vport_num));
 
-	handle = mlx5_add_flow_rules(br_offloads->ingress_ft, rule_spec, &flow_act, &dest, 1);
+	dests[0].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	dests[0].ft = bridge->egress_ft;
+	dests[1].type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
+	dests[1].counter_id = counter_id;
+
+	handle = mlx5_add_flow_rules(br_offloads->ingress_ft, rule_spec, &flow_act, dests,
+				     ARRAY_SIZE(dests));
 
 	kvfree(rule_spec);
 	return handle;
@@ -334,6 +347,7 @@ static struct mlx5_esw_bridge *mlx5_esw_bridge_create(int ifindex,
 	INIT_LIST_HEAD(&bridge->fdb_list);
 	bridge->ifindex = ifindex;
 	bridge->refcnt = 1;
+	bridge->ageing_time = BR_DEFAULT_AGEING_TIME;
 	list_add(&bridge->list, &br_offloads->bridges);
 
 	return bridge;
@@ -399,27 +413,44 @@ mlx5_esw_bridge_fdb_entry_cleanup(struct mlx5_esw_bridge_fdb_entry *entry,
 	rhashtable_remove_fast(&bridge->fdb_ht, &entry->ht_node, fdb_ht_params);
 	mlx5_del_flow_rules(entry->egress_handle);
 	mlx5_del_flow_rules(entry->ingress_handle);
+	mlx5_fc_destroy(bridge->br_offloads->esw->dev, entry->ingress_counter);
 	list_del(&entry->list);
 	kvfree(entry);
 }
 
 static struct mlx5_esw_bridge_fdb_entry *
 mlx5_esw_bridge_fdb_entry_init(struct net_device *dev, u16 vport_num, const unsigned char *addr,
-			       u16 vid, struct mlx5_eswitch *esw, struct mlx5_esw_bridge *bridge)
+			       u16 vid, bool added_by_user, struct mlx5_eswitch *esw,
+			       struct mlx5_esw_bridge *bridge)
 {
 	struct mlx5_esw_bridge_fdb_entry *entry;
 	struct mlx5_flow_handle *handle;
+	struct mlx5_fc *counter;
+	struct mlx5e_priv *priv;
 	int err;
 
+	priv = netdev_priv(dev);
 	entry = kvzalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry)
 		return ERR_PTR(-ENOMEM);
 
 	ether_addr_copy(entry->key.addr, addr);
 	entry->key.vid = vid;
+	entry->dev = dev;
 	entry->vport_num = vport_num;
+	entry->lastuse = jiffies;
+	if (added_by_user)
+		entry->flags |= MLX5_ESW_BRIDGE_FLAG_ADDED_BY_USER;
+
+	counter = mlx5_fc_create(priv->mdev, true);
+	if (IS_ERR(counter)) {
+		err = PTR_ERR(counter);
+		goto err_ingress_fc_create;
+	}
+	entry->ingress_counter = counter;
 
-	handle = mlx5_esw_bridge_ingress_flow_create(vport_num, addr, vid, bridge);
+	handle = mlx5_esw_bridge_ingress_flow_create(vport_num, addr, vid, mlx5_fc_id(counter),
+						     bridge);
 	if (IS_ERR(handle)) {
 		err = PTR_ERR(handle);
 		esw_warn(esw->dev, "Failed to create ingress flow(vport=%u,err=%d)\n",
@@ -451,10 +482,22 @@ mlx5_esw_bridge_fdb_entry_init(struct net_device *dev, u16 vport_num, const unsi
 err_egress_flow_create:
 	mlx5_del_flow_rules(entry->ingress_handle);
 err_ingress_flow_create:
+	mlx5_fc_destroy(priv->mdev, entry->ingress_counter);
+err_ingress_fc_create:
 	kvfree(entry);
 	return ERR_PTR(err);
 }
 
+int mlx5_esw_bridge_ageing_time_set(unsigned long ageing_time, struct mlx5_eswitch *esw,
+				    struct mlx5_vport *vport)
+{
+	if (!vport->bridge)
+		return -EINVAL;
+
+	vport->bridge->ageing_time = ageing_time;
+	return 0;
+}
+
 static int mlx5_esw_bridge_vport_init(struct mlx5_esw_bridge *bridge,
 				      struct mlx5_vport *vport)
 {
@@ -524,12 +567,17 @@ void mlx5_esw_bridge_fdb_create(struct net_device *dev, struct mlx5_eswitch *esw
 	}
 
 	entry = mlx5_esw_bridge_fdb_entry_init(dev, vport_num, fdb_info->addr, fdb_info->vid,
-					       esw, bridge);
+					       fdb_info->added_by_user, esw, bridge);
 	if (IS_ERR(entry))
 		return;
 
-	mlx5_esw_bridge_fdb_offload_notify(dev, entry->key.addr, entry->key.vid,
-					   SWITCHDEV_FDB_OFFLOADED);
+	if (entry->flags & MLX5_ESW_BRIDGE_FLAG_ADDED_BY_USER)
+		mlx5_esw_bridge_fdb_offload_notify(dev, entry->key.addr, entry->key.vid,
+						   SWITCHDEV_FDB_OFFLOADED);
+	else
+		/* Take over dynamic entries to prevent kernel bridge from aging them out. */
+		mlx5_esw_bridge_fdb_offload_notify(dev, entry->key.addr, entry->key.vid,
+						   SWITCHDEV_FDB_ADD_TO_BRIDGE);
 }
 
 void mlx5_esw_bridge_fdb_remove(struct net_device *dev, struct mlx5_eswitch *esw,
@@ -556,9 +604,41 @@ void mlx5_esw_bridge_fdb_remove(struct net_device *dev, struct mlx5_eswitch *esw
 		return;
 	}
 
+	if (!(entry->flags & MLX5_ESW_BRIDGE_FLAG_ADDED_BY_USER))
+		mlx5_esw_bridge_fdb_offload_notify(dev, entry->key.addr, entry->key.vid,
+						   SWITCHDEV_FDB_DEL_TO_BRIDGE);
 	mlx5_esw_bridge_fdb_entry_cleanup(entry, bridge);
 }
 
+void mlx5_esw_bridge_update(struct mlx5_esw_bridge_offloads *br_offloads)
+{
+	struct mlx5_esw_bridge_fdb_entry *entry, *tmp;
+	struct mlx5_esw_bridge *bridge;
+
+	list_for_each_entry(bridge, &br_offloads->bridges, list) {
+		list_for_each_entry_safe(entry, tmp, &bridge->fdb_list, list) {
+			unsigned long lastuse =
+				(unsigned long)mlx5_fc_query_lastuse(entry->ingress_counter);
+
+			if (entry->flags & MLX5_ESW_BRIDGE_FLAG_ADDED_BY_USER)
+				continue;
+
+			if (time_after(lastuse, entry->lastuse)) {
+				entry->lastuse = lastuse;
+				/* refresh existing bridge entry */
+				mlx5_esw_bridge_fdb_offload_notify(entry->dev, entry->key.addr,
+								   entry->key.vid,
+								   SWITCHDEV_FDB_ADD_TO_BRIDGE);
+			} else if (time_is_before_jiffies(entry->lastuse + bridge->ageing_time)) {
+				mlx5_esw_bridge_fdb_offload_notify(entry->dev, entry->key.addr,
+								   entry->key.vid,
+								   SWITCHDEV_FDB_DEL_TO_BRIDGE);
+				mlx5_esw_bridge_fdb_entry_cleanup(entry, bridge);
+			}
+		}
+	}
+}
+
 static void mlx5_esw_bridge_flush(struct mlx5_esw_bridge_offloads *br_offloads)
 {
 	struct mlx5_eswitch *esw = br_offloads->esw;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
index cec118c0b733..07726ae55b2b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
@@ -6,18 +6,20 @@
 
 #include <linux/notifier.h>
 #include <linux/list.h>
+#include <linux/workqueue.h>
 #include "eswitch.h"
 
 struct mlx5_flow_table;
 struct mlx5_flow_group;
-struct workqueue_struct;
 
 struct mlx5_esw_bridge_offloads {
 	struct mlx5_eswitch *esw;
 	struct list_head bridges;
 	struct notifier_block netdev_nb;
+	struct notifier_block nb_blk;
 	struct notifier_block nb;
 	struct workqueue_struct *wq;
+	struct delayed_work update_work;
 
 	struct mlx5_flow_table *ingress_ft;
 	struct mlx5_flow_group *ingress_mac_fg;
@@ -35,5 +37,8 @@ void mlx5_esw_bridge_fdb_create(struct net_device *dev, struct mlx5_eswitch *esw
 void mlx5_esw_bridge_fdb_remove(struct net_device *dev, struct mlx5_eswitch *esw,
 				struct mlx5_vport *vport,
 				struct switchdev_notifier_fdb_info *fdb_info);
+void mlx5_esw_bridge_update(struct mlx5_esw_bridge_offloads *br_offloads);
+int mlx5_esw_bridge_ageing_time_set(unsigned long ageing_time, struct mlx5_eswitch *esw,
+				    struct mlx5_vport *vport);
 
 #endif /* __MLX5_ESW_BRIDGE_H__ */
-- 
2.31.1

