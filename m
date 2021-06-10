Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898F93A227D
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 04:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbhFJDAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 23:00:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:33808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229986AbhFJDAV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 23:00:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A80D61426;
        Thu, 10 Jun 2021 02:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623293905;
        bh=Npqb2aRML+OQntV0OKH/MC06hfoefpPN1ZPXevWgc/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QX/PakRDCGNZpl+/uKrqP/uM6sk6cDgjTThvYjXkRoNG+0kppWD8/newmMm3MQCnS
         gIUO5e16+70Eo95fdY9LYFxCk6TDGnk7MIu1oSeC6mg18odpuM7nIN38g7lFXvl60A
         ho91Nn/zylJcrfQk10/Ndr7LiKKRfjA2vdFaBz2PF4vLdr7lmU4wNboKOcnz7BFukb
         6Mqq/bKC1DhK1T58Thj9YnqtsqYkSVjf+tyO/Y8SNNFgqPlPldzGd7hCjIOs97WOZX
         j9X81irO1uZi58dU51pst17d+ALnZvSl9uOWgG/NbryHkEb6qNVvZHvGUJkyxMp7hC
         EgXrMscXXi7Sg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/16] net/mlx5: Bridge, support pvid and untagged vlan configurations
Date:   Wed,  9 Jun 2021 19:58:12 -0700
Message-Id: <20210610025814.274607-15-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610025814.274607-1-saeed@kernel.org>
References: <20210610025814.274607-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Implement support for pushing vlan header into untagged packet on ingress
of port that has pvid configured and support for popping vlan on egress of
port that has the matching vlan configured as untagged. To support such
configurations packet reformat contexts of {INSERT|REMOVE}_HEADER types are
created per such vlan and saved to struct mlx5_esw_bridge_vlan which allows
all FDB entries on particular vlan to share single packet reformat
instance. When initializing FDB entries with pvid or untagged vlan type set
its mlx5_flow_act->pkt_reformat action accordingly.

Flush all flows when removing vlan from port. This is necessary because
even though software bridge removes all FDB entries before removing their
vlan, mlx5 bridge implementation deletes their corresponding flow entries
from hardware in asynchronous workqueue task, which will cause firmware
error if vlan packet reformat context is deleted before all flows that
point to it.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../device_drivers/ethernet/mellanox/mlx5.rst |   8 +
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  | 175 ++++++++++++++++--
 2 files changed, 167 insertions(+), 16 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
index a0c91fe5574d..058882dca17b 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
@@ -241,6 +241,14 @@ Following bridge VLAN functions are supported by mlx5:
     $ ip link set bridge1 type bridge vlan_filtering 1
     $ bridge vlan add dev enp8s0f0 vid 2-3
 
+- VLAN push on bridge ingress::
+
+    $ bridge vlan add dev enp8s0f0 vid 3 pvid
+
+- VLAN pop on bridge egress::
+
+    $ bridge vlan add dev enp8s0f0 vid 3 untagged
+
 mlx5 subfunction
 ================
 mlx5 supports subfunction management using devlink port (see :ref:`Documentation/networking/devlink/devlink-port.rst <devlink_port>`) interface.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index e1467dbe80dc..442a62ff7b43 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -6,6 +6,8 @@
 #include <linux/rhashtable.h>
 #include <linux/xarray.h>
 #include <linux/if_bridge.h>
+#include <linux/if_vlan.h>
+#include <linux/if_ether.h>
 #include <net/switchdev.h>
 #include "bridge.h"
 #include "eswitch.h"
@@ -44,6 +46,7 @@ struct mlx5_esw_bridge_fdb_entry {
 	struct rhash_head ht_node;
 	struct net_device *dev;
 	struct list_head list;
+	struct list_head vlan_list;
 	u16 vport_num;
 	u16 flags;
 
@@ -63,6 +66,9 @@ static const struct rhashtable_params fdb_ht_params = {
 struct mlx5_esw_bridge_vlan {
 	u16 vid;
 	u16 flags;
+	struct list_head fdb_list;
+	struct mlx5_pkt_reformat *pkt_reformat_push;
+	struct mlx5_pkt_reformat *pkt_reformat_pop;
 };
 
 struct mlx5_esw_bridge_port {
@@ -117,6 +123,7 @@ mlx5_esw_bridge_table_create(int max_fte, u32 level, struct mlx5_eswitch *esw)
 		return ERR_PTR(-ENOENT);
 	}
 
+	ft_attr.flags = MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT;
 	ft_attr.max_fte = max_fte;
 	ft_attr.level = level;
 	ft_attr.prio = FDB_BR_OFFLOAD;
@@ -395,7 +402,10 @@ mlx5_esw_bridge_ingress_flow_create(u16 vport_num, const unsigned char *addr,
 	MLX5_SET(fte_match_param, rule_spec->match_value, misc_parameters_2.metadata_reg_c_0,
 		 mlx5_eswitch_get_vport_metadata_for_match(br_offloads->esw, vport_num));
 
-	if (vlan) {
+	if (vlan && vlan->pkt_reformat_push) {
+		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
+		flow_act.pkt_reformat = vlan->pkt_reformat_push;
+	} else if (vlan) {
 		MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria,
 				 outer_headers.cvlan_tag);
 		MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_value,
@@ -449,6 +459,11 @@ mlx5_esw_bridge_egress_flow_create(u16 vport_num, const unsigned char *addr,
 	eth_broadcast_addr(dmac_c);
 
 	if (vlan) {
+		if (vlan->pkt_reformat_pop) {
+			flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
+			flow_act.pkt_reformat = vlan->pkt_reformat_pop;
+		}
+
 		MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria,
 				 outer_headers.cvlan_tag);
 		MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_value,
@@ -597,8 +612,90 @@ mlx5_esw_bridge_vlan_lookup(u16 vid, struct mlx5_esw_bridge_port *port)
 	return xa_load(&port->vlans, vid);
 }
 
+static int
+mlx5_esw_bridge_vlan_push_create(struct mlx5_esw_bridge_vlan *vlan, struct mlx5_eswitch *esw)
+{
+	struct {
+		__be16	h_vlan_proto;
+		__be16	h_vlan_TCI;
+	} vlan_hdr = { htons(ETH_P_8021Q), htons(vlan->vid) };
+	struct mlx5_pkt_reformat_params reformat_params = {};
+	struct mlx5_pkt_reformat *pkt_reformat;
+
+	if (!BIT(MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, reformat_insert)) ||
+	    MLX5_CAP_GEN_2(esw->dev, max_reformat_insert_size) < sizeof(vlan_hdr) ||
+	    MLX5_CAP_GEN_2(esw->dev, max_reformat_insert_offset) <
+	    offsetof(struct vlan_ethhdr, h_vlan_proto)) {
+		esw_warn(esw->dev, "Packet reformat INSERT_HEADER is not supported\n");
+		return -EOPNOTSUPP;
+	}
+
+	reformat_params.type = MLX5_REFORMAT_TYPE_INSERT_HDR;
+	reformat_params.param_0 = MLX5_REFORMAT_CONTEXT_ANCHOR_MAC_START;
+	reformat_params.param_1 = offsetof(struct vlan_ethhdr, h_vlan_proto);
+	reformat_params.size = sizeof(vlan_hdr);
+	reformat_params.data = &vlan_hdr;
+	pkt_reformat = mlx5_packet_reformat_alloc(esw->dev,
+						  &reformat_params,
+						  MLX5_FLOW_NAMESPACE_FDB);
+	if (IS_ERR(pkt_reformat)) {
+		esw_warn(esw->dev, "Failed to alloc packet reformat INSERT_HEADER (err=%ld)\n",
+			 PTR_ERR(pkt_reformat));
+		return PTR_ERR(pkt_reformat);
+	}
+
+	vlan->pkt_reformat_push = pkt_reformat;
+	return 0;
+}
+
+static void
+mlx5_esw_bridge_vlan_push_cleanup(struct mlx5_esw_bridge_vlan *vlan, struct mlx5_eswitch *esw)
+{
+	mlx5_packet_reformat_dealloc(esw->dev, vlan->pkt_reformat_push);
+	vlan->pkt_reformat_push = NULL;
+}
+
+static int
+mlx5_esw_bridge_vlan_pop_create(struct mlx5_esw_bridge_vlan *vlan, struct mlx5_eswitch *esw)
+{
+	struct mlx5_pkt_reformat_params reformat_params = {};
+	struct mlx5_pkt_reformat *pkt_reformat;
+
+	if (!BIT(MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, reformat_remove)) ||
+	    MLX5_CAP_GEN_2(esw->dev, max_reformat_remove_size) < sizeof(struct vlan_hdr) ||
+	    MLX5_CAP_GEN_2(esw->dev, max_reformat_remove_offset) <
+	    offsetof(struct vlan_ethhdr, h_vlan_proto)) {
+		esw_warn(esw->dev, "Packet reformat REMOVE_HEADER is not supported\n");
+		return -EOPNOTSUPP;
+	}
+
+	reformat_params.type = MLX5_REFORMAT_TYPE_REMOVE_HDR;
+	reformat_params.param_0 = MLX5_REFORMAT_CONTEXT_ANCHOR_MAC_START;
+	reformat_params.param_1 = offsetof(struct vlan_ethhdr, h_vlan_proto);
+	reformat_params.size = sizeof(struct vlan_hdr);
+	pkt_reformat = mlx5_packet_reformat_alloc(esw->dev,
+						  &reformat_params,
+						  MLX5_FLOW_NAMESPACE_FDB);
+	if (IS_ERR(pkt_reformat)) {
+		esw_warn(esw->dev, "Failed to alloc packet reformat REMOVE_HEADER (err=%ld)\n",
+			 PTR_ERR(pkt_reformat));
+		return PTR_ERR(pkt_reformat);
+	}
+
+	vlan->pkt_reformat_pop = pkt_reformat;
+	return 0;
+}
+
+static void
+mlx5_esw_bridge_vlan_pop_cleanup(struct mlx5_esw_bridge_vlan *vlan, struct mlx5_eswitch *esw)
+{
+	mlx5_packet_reformat_dealloc(esw->dev, vlan->pkt_reformat_pop);
+	vlan->pkt_reformat_pop = NULL;
+}
+
 static struct mlx5_esw_bridge_vlan *
-mlx5_esw_bridge_vlan_create(u16 vid, u16 flags, struct mlx5_esw_bridge_port *port)
+mlx5_esw_bridge_vlan_create(u16 vid, u16 flags, struct mlx5_esw_bridge_port *port,
+			    struct mlx5_eswitch *esw)
 {
 	struct mlx5_esw_bridge_vlan *vlan;
 	int err;
@@ -609,13 +706,34 @@ mlx5_esw_bridge_vlan_create(u16 vid, u16 flags, struct mlx5_esw_bridge_port *por
 
 	vlan->vid = vid;
 	vlan->flags = flags;
-	err = xa_insert(&port->vlans, vid, vlan, GFP_KERNEL);
-	if (err) {
-		kvfree(vlan);
-		return ERR_PTR(err);
+	INIT_LIST_HEAD(&vlan->fdb_list);
+
+	if (flags & BRIDGE_VLAN_INFO_PVID) {
+		err = mlx5_esw_bridge_vlan_push_create(vlan, esw);
+		if (err)
+			goto err_vlan_push;
+	}
+	if (flags & BRIDGE_VLAN_INFO_UNTAGGED) {
+		err = mlx5_esw_bridge_vlan_pop_create(vlan, esw);
+		if (err)
+			goto err_vlan_pop;
 	}
 
+	err = xa_insert(&port->vlans, vid, vlan, GFP_KERNEL);
+	if (err)
+		goto err_xa_insert;
+
 	return vlan;
+
+err_xa_insert:
+	if (vlan->pkt_reformat_pop)
+		mlx5_esw_bridge_vlan_pop_cleanup(vlan, esw);
+err_vlan_pop:
+	if (vlan->pkt_reformat_push)
+		mlx5_esw_bridge_vlan_push_cleanup(vlan, esw);
+err_vlan_push:
+	kvfree(vlan);
+	return ERR_PTR(err);
 }
 
 static void mlx5_esw_bridge_vlan_erase(struct mlx5_esw_bridge_port *port,
@@ -624,20 +742,42 @@ static void mlx5_esw_bridge_vlan_erase(struct mlx5_esw_bridge_port *port,
 	xa_erase(&port->vlans, vlan->vid);
 }
 
+static void mlx5_esw_bridge_vlan_flush(struct mlx5_esw_bridge_vlan *vlan,
+				       struct mlx5_esw_bridge *bridge)
+{
+	struct mlx5_esw_bridge_fdb_entry *entry, *tmp;
+
+	list_for_each_entry_safe(entry, tmp, &vlan->fdb_list, vlan_list) {
+		if (!(entry->flags & MLX5_ESW_BRIDGE_FLAG_ADDED_BY_USER))
+			mlx5_esw_bridge_fdb_offload_notify(entry->dev, entry->key.addr,
+							   entry->key.vid,
+							   SWITCHDEV_FDB_DEL_TO_BRIDGE);
+		mlx5_esw_bridge_fdb_entry_cleanup(entry, bridge);
+	}
+
+	if (vlan->pkt_reformat_pop)
+		mlx5_esw_bridge_vlan_pop_cleanup(vlan, bridge->br_offloads->esw);
+	if (vlan->pkt_reformat_push)
+		mlx5_esw_bridge_vlan_push_cleanup(vlan, bridge->br_offloads->esw);
+}
+
 static void mlx5_esw_bridge_vlan_cleanup(struct mlx5_esw_bridge_port *port,
-					 struct mlx5_esw_bridge_vlan *vlan)
+					 struct mlx5_esw_bridge_vlan *vlan,
+					 struct mlx5_esw_bridge *bridge)
 {
+	mlx5_esw_bridge_vlan_flush(vlan, bridge);
 	mlx5_esw_bridge_vlan_erase(port, vlan);
 	kvfree(vlan);
 }
 
-static void mlx5_esw_bridge_port_vlans_flush(struct mlx5_esw_bridge_port *port)
+static void mlx5_esw_bridge_port_vlans_flush(struct mlx5_esw_bridge_port *port,
+					     struct mlx5_esw_bridge *bridge)
 {
 	struct mlx5_esw_bridge_vlan *vlan;
 	unsigned long index;
 
 	xa_for_each(&port->vlans, index, vlan)
-		mlx5_esw_bridge_vlan_cleanup(port, vlan);
+		mlx5_esw_bridge_vlan_cleanup(port, vlan, bridge);
 }
 
 static struct mlx5_esw_bridge_vlan *
@@ -685,8 +825,6 @@ mlx5_esw_bridge_fdb_entry_init(struct net_device *dev, u16 vport_num, const unsi
 		vlan = mlx5_esw_bridge_port_vlan_lookup(vid, vport_num, bridge, esw);
 		if (IS_ERR(vlan))
 			return ERR_CAST(vlan);
-		if (vlan->flags & (BRIDGE_VLAN_INFO_PVID | BRIDGE_VLAN_INFO_UNTAGGED))
-			return ERR_PTR(-EOPNOTSUPP); /* can't offload vlan push/pop */
 	}
 
 	priv = netdev_priv(dev);
@@ -734,6 +872,10 @@ mlx5_esw_bridge_fdb_entry_init(struct net_device *dev, u16 vport_num, const unsi
 		goto err_ht_init;
 	}
 
+	if (vlan)
+		list_add(&entry->vlan_list, &vlan->fdb_list);
+	else
+		INIT_LIST_HEAD(&entry->vlan_list);
 	list_add(&entry->list, &bridge->fdb_list);
 	return entry;
 
@@ -831,7 +973,7 @@ static int mlx5_esw_bridge_vport_cleanup(struct mlx5_esw_bridge_offloads *br_off
 		return -EINVAL;
 	}
 
-	mlx5_esw_bridge_port_vlans_flush(port);
+	mlx5_esw_bridge_port_vlans_flush(port, bridge);
 	mlx5_esw_bridge_port_erase(port, bridge);
 	kvfree(port);
 	mlx5_esw_bridge_put(br_offloads, bridge);
@@ -892,11 +1034,12 @@ int mlx5_esw_bridge_port_vlan_add(u16 vid, u16 flags, struct mlx5_eswitch *esw,
 
 	vlan = mlx5_esw_bridge_vlan_lookup(vid, port);
 	if (vlan) {
-		vlan->flags = flags;
-		return 0;
+		if (vlan->flags == flags)
+			return 0;
+		mlx5_esw_bridge_vlan_cleanup(port, vlan, vport->bridge);
 	}
 
-	vlan = mlx5_esw_bridge_vlan_create(vid, flags, port);
+	vlan = mlx5_esw_bridge_vlan_create(vid, flags, port, esw);
 	if (IS_ERR(vlan)) {
 		NL_SET_ERR_MSG_MOD(extack, "Failed to create VLAN entry");
 		return PTR_ERR(vlan);
@@ -916,7 +1059,7 @@ void mlx5_esw_bridge_port_vlan_del(u16 vid, struct mlx5_eswitch *esw, struct mlx
 	vlan = mlx5_esw_bridge_vlan_lookup(vid, port);
 	if (!vlan)
 		return;
-	mlx5_esw_bridge_vlan_cleanup(port, vlan);
+	mlx5_esw_bridge_vlan_cleanup(port, vlan, vport->bridge);
 }
 
 void mlx5_esw_bridge_fdb_create(struct net_device *dev, struct mlx5_eswitch *esw,
-- 
2.31.1

