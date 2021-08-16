Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 291DA3EE064
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 01:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235461AbhHPXXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 19:23:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:51510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234639AbhHPXXL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 19:23:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3299E60F55;
        Mon, 16 Aug 2021 23:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629156159;
        bh=tDdKwFyduHl5Hv54qfyty2oofps8OIXio7z52tFxHCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sLSXOXYLz755950qs/5Wy03Ij5dw+fFrrIbJbZ2xts2TQevqquJMATznIIF4tpp75
         hCzPA7v8eiqKfSJ+uFeRyOiZDZ0dMXkfM1NJEiE+OZGOKiXfAyBO1I4382GrtAOKE7
         ahSNbD54JOaTRAD8LHpyMkCMZ+5mKhi1BAJGBXhwKTOpvGT4ScLSsrU7tkyyB3AUPj
         r5hu/J3rAupRpt483Qc0Q29LXor6NrD3emYE/gyv/Kcu6GTt6UU5GCBBgLBzAxwMGc
         7+SYFvBz2wyM8aHFmXfCiQN+WvA4j2fuMi+0zqK6cYHPVlSKdAIxWVoBNZY6MB37di
         H17Z0m7DrO2HQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 17/17] net/mlx5: Bridge, support LAG
Date:   Mon, 16 Aug 2021 16:22:19 -0700
Message-Id: <20210816232219.557083-18-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816232219.557083-1-saeed@kernel.org>
References: <20210816232219.557083-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Allow adding bond net devices to mlx5 bridge with following changes:

- Modify bridge representor code to obtain uplink represetor that belongs
to eswitch that is registered for notification. Require representor to be
in shared FDB mode. If representor is the lag master, then consider its
port as local, otherwise treat it as peer.

- Use devcom to match on paired eswitch metadata in peer FDB entries. This
is necessary for shared FDB LAG to function since packets are always
received on active eswitch instance as opposed to parent eswitch of port.

- Support for deleting peer flows when receiving
SWITCHDEV_FDB_DEL_TO_BRIDGE notification was implemented in one of previous
patches in series. Now also implement support for handling
SWITCHDEV_FDB_ADD_TO_BRIDGE which can be generated on peer by bridge update
workqueue task in LAG configuration. Refresh the flow 'lastuse' timestamp
to current jiffies when receiving such notification on eswitch that manages
the local FDB entry. This allows peer entries to prevent ageing of the FDB.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/rep/bridge.c        | 125 ++++++++++++------
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  |  79 +++++++++--
 .../ethernet/mellanox/mlx5/core/esw/bridge.h  |   3 +
 3 files changed, 159 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
index fdb9853bfe3f..0c38c2e319be 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
@@ -41,46 +41,88 @@ static bool mlx5_esw_bridge_dev_same_hw(struct net_device *dev, struct mlx5_eswi
 	return system_guid == esw_system_guid;
 }
 
-static int mlx5_esw_bridge_vport_num_vhca_id_get(struct net_device *dev, struct mlx5_eswitch *esw,
-						 u16 *vport_num, u16 *esw_owner_vhca_id)
+static struct net_device *
+mlx5_esw_bridge_lag_rep_get(struct net_device *dev, struct mlx5_eswitch *esw)
+{
+	struct net_device *lower;
+	struct list_head *iter;
+
+	netdev_for_each_lower_dev(dev, lower, iter) {
+		struct mlx5_core_dev *mdev;
+		struct mlx5e_priv *priv;
+
+		if (!mlx5e_eswitch_rep(lower))
+			continue;
+
+		priv = netdev_priv(lower);
+		mdev = priv->mdev;
+		if (mlx5_lag_is_shared_fdb(mdev) && mlx5_esw_bridge_dev_same_esw(lower, esw))
+			return lower;
+	}
+
+	return NULL;
+}
+
+static struct net_device *
+mlx5_esw_bridge_rep_vport_num_vhca_id_get(struct net_device *dev, struct mlx5_eswitch *esw,
+					  u16 *vport_num, u16 *esw_owner_vhca_id)
 {
 	struct mlx5e_rep_priv *rpriv;
 	struct mlx5e_priv *priv;
 
-	if (!mlx5e_eswitch_rep(dev) || !mlx5_esw_bridge_dev_same_hw(dev, esw))
-		return -ENODEV;
+	if (netif_is_lag_master(dev))
+		dev = mlx5_esw_bridge_lag_rep_get(dev, esw);
+
+	if (!dev || !mlx5e_eswitch_rep(dev) || !mlx5_esw_bridge_dev_same_hw(dev, esw))
+		return NULL;
 
 	priv = netdev_priv(dev);
 	rpriv = priv->ppriv;
 	*vport_num = rpriv->rep->vport;
 	*esw_owner_vhca_id = MLX5_CAP_GEN(priv->mdev, vhca_id);
-	return 0;
+	return dev;
 }
 
-static int
+static struct net_device *
 mlx5_esw_bridge_lower_rep_vport_num_vhca_id_get(struct net_device *dev, struct mlx5_eswitch *esw,
 						u16 *vport_num, u16 *esw_owner_vhca_id)
 {
 	struct net_device *lower_dev;
 	struct list_head *iter;
 
-	if (mlx5e_eswitch_rep(dev))
-		return mlx5_esw_bridge_vport_num_vhca_id_get(dev, esw, vport_num,
-							     esw_owner_vhca_id);
+	if (netif_is_lag_master(dev) || mlx5e_eswitch_rep(dev))
+		return mlx5_esw_bridge_rep_vport_num_vhca_id_get(dev, esw, vport_num,
+								 esw_owner_vhca_id);
 
 	netdev_for_each_lower_dev(dev, lower_dev, iter) {
-		int err;
+		struct net_device *rep;
 
 		if (netif_is_bridge_master(lower_dev))
 			continue;
 
-		err = mlx5_esw_bridge_lower_rep_vport_num_vhca_id_get(lower_dev, esw, vport_num,
+		rep = mlx5_esw_bridge_lower_rep_vport_num_vhca_id_get(lower_dev, esw, vport_num,
 								      esw_owner_vhca_id);
-		if (!err)
-			return 0;
+		if (rep)
+			return rep;
 	}
 
-	return -ENODEV;
+	return NULL;
+}
+
+static bool mlx5_esw_bridge_is_local(struct net_device *dev, struct net_device *rep,
+				     struct mlx5_eswitch *esw)
+{
+	struct mlx5_core_dev *mdev;
+	struct mlx5e_priv *priv;
+
+	if (!mlx5_esw_bridge_dev_same_esw(rep, esw))
+		return false;
+
+	priv = netdev_priv(rep);
+	mdev = priv->mdev;
+	if (netif_is_lag_master(dev))
+		return mlx5_lag_is_shared_fdb(mdev) && mlx5_lag_is_master(mdev);
+	return true;
 }
 
 static int mlx5_esw_bridge_port_changeupper(struct notifier_block *nb, void *ptr)
@@ -90,8 +132,8 @@ static int mlx5_esw_bridge_port_changeupper(struct notifier_block *nb, void *ptr
 								    netdev_nb);
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	struct netdev_notifier_changeupper_info *info = ptr;
+	struct net_device *upper = info->upper_dev, *rep;
 	struct mlx5_eswitch *esw = br_offloads->esw;
-	struct net_device *upper = info->upper_dev;
 	u16 vport_num, esw_owner_vhca_id;
 	struct netlink_ext_ack *extack;
 	int ifindex = upper->ifindex;
@@ -100,20 +142,19 @@ static int mlx5_esw_bridge_port_changeupper(struct notifier_block *nb, void *ptr
 	if (!netif_is_bridge_master(upper))
 		return 0;
 
-	err = mlx5_esw_bridge_vport_num_vhca_id_get(dev, br_offloads->esw, &vport_num,
-						    &esw_owner_vhca_id);
-	if (err)
+	rep = mlx5_esw_bridge_rep_vport_num_vhca_id_get(dev, esw, &vport_num, &esw_owner_vhca_id);
+	if (!rep)
 		return 0;
 
 	extack = netdev_notifier_info_to_extack(&info->info);
 
-	if (mlx5_esw_bridge_dev_same_esw(dev, esw))
+	if (mlx5_esw_bridge_is_local(dev, rep, esw))
 		err = info->linking ?
 			mlx5_esw_bridge_vport_link(ifindex, vport_num, esw_owner_vhca_id,
 						   br_offloads, extack) :
 			mlx5_esw_bridge_vport_unlink(ifindex, vport_num, esw_owner_vhca_id,
 						     br_offloads, extack);
-	else if (mlx5_esw_bridge_dev_same_hw(dev, esw))
+	else if (mlx5_esw_bridge_dev_same_hw(rep, esw))
 		err = info->linking ?
 			mlx5_esw_bridge_vport_peer_link(ifindex, vport_num, esw_owner_vhca_id,
 							br_offloads, extack) :
@@ -151,9 +192,8 @@ mlx5_esw_bridge_port_obj_add(struct net_device *dev,
 	u16 vport_num, esw_owner_vhca_id;
 	int err;
 
-	err = mlx5_esw_bridge_vport_num_vhca_id_get(dev, br_offloads->esw, &vport_num,
-						    &esw_owner_vhca_id);
-	if (err)
+	if (!mlx5_esw_bridge_rep_vport_num_vhca_id_get(dev, br_offloads->esw, &vport_num,
+						       &esw_owner_vhca_id))
 		return 0;
 
 	port_obj_info->handled = true;
@@ -178,11 +218,9 @@ mlx5_esw_bridge_port_obj_del(struct net_device *dev,
 	const struct switchdev_obj *obj = port_obj_info->obj;
 	const struct switchdev_obj_port_vlan *vlan;
 	u16 vport_num, esw_owner_vhca_id;
-	int err;
 
-	err = mlx5_esw_bridge_vport_num_vhca_id_get(dev, br_offloads->esw, &vport_num,
-						    &esw_owner_vhca_id);
-	if (err)
+	if (!mlx5_esw_bridge_rep_vport_num_vhca_id_get(dev, br_offloads->esw, &vport_num,
+						       &esw_owner_vhca_id))
 		return 0;
 
 	port_obj_info->handled = true;
@@ -208,9 +246,8 @@ mlx5_esw_bridge_port_obj_attr_set(struct net_device *dev,
 	u16 vport_num, esw_owner_vhca_id;
 	int err;
 
-	err = mlx5_esw_bridge_lower_rep_vport_num_vhca_id_get(dev, br_offloads->esw, &vport_num,
-							      &esw_owner_vhca_id);
-	if (err)
+	if (!mlx5_esw_bridge_lower_rep_vport_num_vhca_id_get(dev, br_offloads->esw, &vport_num,
+							     &esw_owner_vhca_id))
 		return 0;
 
 	port_attr_info->handled = true;
@@ -283,13 +320,11 @@ static void mlx5_esw_bridge_switchdev_fdb_event_work(struct work_struct *work)
 		fdb_work->br_offloads;
 	struct net_device *dev = fdb_work->dev;
 	u16 vport_num, esw_owner_vhca_id;
-	int err;
 
 	rtnl_lock();
 
-	err = mlx5_esw_bridge_vport_num_vhca_id_get(dev, br_offloads->esw, &vport_num,
-						    &esw_owner_vhca_id);
-	if (err)
+	if (!mlx5_esw_bridge_rep_vport_num_vhca_id_get(dev, br_offloads->esw, &vport_num,
+						       &esw_owner_vhca_id))
 		goto out;
 
 	if (fdb_work->add)
@@ -343,8 +378,10 @@ static int mlx5_esw_bridge_switchdev_event(struct notifier_block *nb,
 	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
 	struct switchdev_notifier_fdb_info *fdb_info;
 	struct mlx5_bridge_switchdev_fdb_work *work;
+	struct mlx5_eswitch *esw = br_offloads->esw;
 	struct switchdev_notifier_info *info = ptr;
-	struct net_device *upper;
+	u16 vport_num, esw_owner_vhca_id;
+	struct net_device *upper, *rep;
 
 	if (event == SWITCHDEV_PORT_ATTR_SET) {
 		int err = mlx5_esw_bridge_port_obj_attr_set(dev, ptr, br_offloads);
@@ -358,13 +395,25 @@ static int mlx5_esw_bridge_switchdev_event(struct notifier_block *nb,
 	if (!netif_is_bridge_master(upper))
 		return NOTIFY_DONE;
 
-	if (!mlx5e_eswitch_rep(dev))
+	rep = mlx5_esw_bridge_rep_vport_num_vhca_id_get(dev, esw, &vport_num, &esw_owner_vhca_id);
+	if (!rep)
 		return NOTIFY_DONE;
 
 	switch (event) {
+	case SWITCHDEV_FDB_ADD_TO_BRIDGE:
+		/* only handle the event on native eswtich of representor */
+		if (!mlx5_esw_bridge_is_local(dev, rep, esw))
+			break;
+
+		fdb_info = container_of(info,
+					struct switchdev_notifier_fdb_info,
+					info);
+		mlx5_esw_bridge_fdb_update_used(dev, vport_num, esw_owner_vhca_id, br_offloads,
+						fdb_info);
+		break;
 	case SWITCHDEV_FDB_DEL_TO_BRIDGE:
-		/* only handle the event when source is on another eswitch */
-		if (mlx5_esw_bridge_dev_same_esw(dev, br_offloads->esw))
+		/* only handle the event on peers */
+		if (mlx5_esw_bridge_is_local(dev, rep, esw))
 			break;
 		fallthrough;
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index 20d44b0ae337..7e221038df8d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -5,6 +5,7 @@
 #include <linux/notifier.h>
 #include <net/netevent.h>
 #include <net/switchdev.h>
+#include "lib/devcom.h"
 #include "bridge.h"
 #include "eswitch.h"
 #include "bridge_priv.h"
@@ -408,9 +409,10 @@ mlx5_esw_bridge_egress_table_cleanup(struct mlx5_esw_bridge *bridge)
 }
 
 static struct mlx5_flow_handle *
-mlx5_esw_bridge_ingress_flow_create(u16 vport_num, const unsigned char *addr,
-				    struct mlx5_esw_bridge_vlan *vlan, u32 counter_id,
-				    struct mlx5_esw_bridge *bridge)
+mlx5_esw_bridge_ingress_flow_with_esw_create(u16 vport_num, const unsigned char *addr,
+					     struct mlx5_esw_bridge_vlan *vlan, u32 counter_id,
+					     struct mlx5_esw_bridge *bridge,
+					     struct mlx5_eswitch *esw)
 {
 	struct mlx5_esw_bridge_offloads *br_offloads = bridge->br_offloads;
 	struct mlx5_flow_act flow_act = {
@@ -438,7 +440,7 @@ mlx5_esw_bridge_ingress_flow_create(u16 vport_num, const unsigned char *addr,
 	MLX5_SET(fte_match_param, rule_spec->match_criteria,
 		 misc_parameters_2.metadata_reg_c_0, mlx5_eswitch_get_vport_metadata_mask());
 	MLX5_SET(fte_match_param, rule_spec->match_value, misc_parameters_2.metadata_reg_c_0,
-		 mlx5_eswitch_get_vport_metadata_for_match(br_offloads->esw, vport_num));
+		 mlx5_eswitch_get_vport_metadata_for_match(esw, vport_num));
 
 	if (vlan && vlan->pkt_reformat_push) {
 		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
@@ -466,6 +468,35 @@ mlx5_esw_bridge_ingress_flow_create(u16 vport_num, const unsigned char *addr,
 	return handle;
 }
 
+static struct mlx5_flow_handle *
+mlx5_esw_bridge_ingress_flow_create(u16 vport_num, const unsigned char *addr,
+				    struct mlx5_esw_bridge_vlan *vlan, u32 counter_id,
+				    struct mlx5_esw_bridge *bridge)
+{
+	return mlx5_esw_bridge_ingress_flow_with_esw_create(vport_num, addr, vlan, counter_id,
+							    bridge, bridge->br_offloads->esw);
+}
+
+static struct mlx5_flow_handle *
+mlx5_esw_bridge_ingress_flow_peer_create(u16 vport_num, const unsigned char *addr,
+					 struct mlx5_esw_bridge_vlan *vlan, u32 counter_id,
+					 struct mlx5_esw_bridge *bridge)
+{
+	struct mlx5_devcom *devcom = bridge->br_offloads->esw->dev->priv.devcom;
+	static struct mlx5_flow_handle *handle;
+	struct mlx5_eswitch *peer_esw;
+
+	peer_esw = mlx5_devcom_get_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
+	if (!peer_esw)
+		return ERR_PTR(-ENODEV);
+
+	handle = mlx5_esw_bridge_ingress_flow_with_esw_create(vport_num, addr, vlan, counter_id,
+							      bridge, peer_esw);
+
+	mlx5_devcom_release_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
+	return handle;
+}
+
 static struct mlx5_flow_handle *
 mlx5_esw_bridge_ingress_filter_flow_create(u16 vport_num, const unsigned char *addr,
 					   struct mlx5_esw_bridge *bridge)
@@ -679,12 +710,10 @@ static void mlx5_esw_bridge_port_erase(struct mlx5_esw_bridge_port *port,
 	xa_erase(&br_offloads->ports, mlx5_esw_bridge_port_key(port));
 }
 
-static void mlx5_esw_bridge_fdb_entry_refresh(unsigned long lastuse,
-					      struct mlx5_esw_bridge_fdb_entry *entry)
+static void mlx5_esw_bridge_fdb_entry_refresh(struct mlx5_esw_bridge_fdb_entry *entry)
 {
 	trace_mlx5_esw_bridge_fdb_entry_refresh(entry);
 
-	entry->lastuse = lastuse;
 	mlx5_esw_bridge_fdb_offload_notify(entry->dev, entry->key.addr,
 					   entry->key.vid,
 					   SWITCHDEV_FDB_ADD_TO_BRIDGE);
@@ -959,8 +988,11 @@ mlx5_esw_bridge_fdb_entry_init(struct net_device *dev, u16 vport_num, u16 esw_ow
 	}
 	entry->ingress_counter = counter;
 
-	handle = mlx5_esw_bridge_ingress_flow_create(vport_num, addr, vlan, mlx5_fc_id(counter),
-						     bridge);
+	handle = peer ?
+		mlx5_esw_bridge_ingress_flow_peer_create(vport_num, addr, vlan,
+							 mlx5_fc_id(counter), bridge) :
+		mlx5_esw_bridge_ingress_flow_create(vport_num, addr, vlan,
+						    mlx5_fc_id(counter), bridge);
 	if (IS_ERR(handle)) {
 		err = PTR_ERR(handle);
 		esw_warn(esw->dev, "Failed to create ingress flow(vport=%u,err=%d)\n",
@@ -1228,6 +1260,33 @@ void mlx5_esw_bridge_port_vlan_del(u16 vport_num, u16 esw_owner_vhca_id, u16 vid
 	mlx5_esw_bridge_vlan_cleanup(port, vlan, port->bridge);
 }
 
+void mlx5_esw_bridge_fdb_update_used(struct net_device *dev, u16 vport_num, u16 esw_owner_vhca_id,
+				     struct mlx5_esw_bridge_offloads *br_offloads,
+				     struct switchdev_notifier_fdb_info *fdb_info)
+{
+	struct mlx5_esw_bridge_fdb_entry *entry;
+	struct mlx5_esw_bridge_fdb_key key;
+	struct mlx5_esw_bridge_port *port;
+	struct mlx5_esw_bridge *bridge;
+
+	port = mlx5_esw_bridge_port_lookup(vport_num, esw_owner_vhca_id, br_offloads);
+	if (!port || port->flags & MLX5_ESW_BRIDGE_PORT_FLAG_PEER)
+		return;
+
+	bridge = port->bridge;
+	ether_addr_copy(key.addr, fdb_info->addr);
+	key.vid = fdb_info->vid;
+	entry = rhashtable_lookup_fast(&bridge->fdb_ht, &key, fdb_ht_params);
+	if (!entry) {
+		esw_debug(br_offloads->esw->dev,
+			  "FDB entry with specified key not found (MAC=%pM,vid=%u,vport=%u)\n",
+			  key.addr, key.vid, vport_num);
+		return;
+	}
+
+	entry->lastuse = jiffies;
+}
+
 void mlx5_esw_bridge_fdb_create(struct net_device *dev, u16 vport_num, u16 esw_owner_vhca_id,
 				struct mlx5_esw_bridge_offloads *br_offloads,
 				struct switchdev_notifier_fdb_info *fdb_info)
@@ -1300,7 +1359,7 @@ void mlx5_esw_bridge_update(struct mlx5_esw_bridge_offloads *br_offloads)
 				continue;
 
 			if (time_after(lastuse, entry->lastuse)) {
-				mlx5_esw_bridge_fdb_entry_refresh(lastuse, entry);
+				mlx5_esw_bridge_fdb_entry_refresh(entry);
 			} else if (!(entry->flags & MLX5_ESW_BRIDGE_FLAG_PEER) &&
 				   time_is_before_jiffies(entry->lastuse + bridge->ageing_time)) {
 				mlx5_esw_bridge_fdb_del_notify(entry);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
index a4f04f3f5b11..efc39975226e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
@@ -46,6 +46,9 @@ int mlx5_esw_bridge_vport_peer_link(int ifindex, u16 vport_num, u16 esw_owner_vh
 int mlx5_esw_bridge_vport_peer_unlink(int ifindex, u16 vport_num, u16 esw_owner_vhca_id,
 				      struct mlx5_esw_bridge_offloads *br_offloads,
 				      struct netlink_ext_ack *extack);
+void mlx5_esw_bridge_fdb_update_used(struct net_device *dev, u16 vport_num, u16 esw_owner_vhca_id,
+				     struct mlx5_esw_bridge_offloads *br_offloads,
+				     struct switchdev_notifier_fdb_info *fdb_info);
 void mlx5_esw_bridge_fdb_create(struct net_device *dev, u16 vport_num, u16 esw_owner_vhca_id,
 				struct mlx5_esw_bridge_offloads *br_offloads,
 				struct switchdev_notifier_fdb_info *fdb_info);
-- 
2.31.1

