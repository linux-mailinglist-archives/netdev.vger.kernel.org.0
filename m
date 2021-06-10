Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 412813A227C
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 04:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbhFJDAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 23:00:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:33780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230060AbhFJDAU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 23:00:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF8826141E;
        Thu, 10 Jun 2021 02:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623293905;
        bh=dMVQ7hdDKiRKeI5qQEjarqmFQY2MXbDaNcNdKvexMlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QsDJJoXrf/XkUlLCTVgfCGLn+8cnF3QxFUHDCeCQl6MBzo4I5RHK0dE2cdmmy24Ck
         smX9UOhxd9q9VQ0CGLpvh5GbbJUIxgyNnswZ/YeDs0GAgKR+LID6YcpprhlwftU9n8
         CfxU6/FUIr7vgy4BKNKjJkyqzPn62YdANINNs/RbgRrHnwGmqEtFEVvEJkqSWt21ph
         944ag26uWJgq157o77VN/tC8TLKEm5OlKwyDrk1yl4jGGhK19gItKR5uTcYwKcTbRA
         6YDj2340P3J7igYwasPL+1LELEntTtPZeH4n/t2W5GsFDjEHaLrcE268vLMG4VN82M
         vbH/vmPzQDTpg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/16] net/mlx5: Bridge, match FDB entry vlan tag
Date:   Wed,  9 Jun 2021 19:58:11 -0700
Message-Id: <20210610025814.274607-14-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610025814.274607-1-saeed@kernel.org>
References: <20210610025814.274607-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Add support for FDB vlan-tagged entries. Extend ingress and egress flow
tables with flow groups to match packet vlan tag. Modify the flow creation
code to include vlan tag, if vlan is configured on port and vlan
configuration is supported for offload.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../device_drivers/ethernet/mellanox/mlx5.rst |   9 +
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  | 181 +++++++++++++++++-
 .../ethernet/mellanox/mlx5/core/esw/bridge.h  |   1 +
 3 files changed, 181 insertions(+), 10 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
index ea32136b30e7..a0c91fe5574d 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
@@ -232,6 +232,15 @@ representor is attached to bridge.
 
     $ ip link set enp8s0f0 master bridge1
 
+VLANs
+-----
+Following bridge VLAN functions are supported by mlx5:
+
+- VLAN filtering (including multiple VLANs per port)::
+
+    $ ip link set bridge1 type bridge vlan_filtering 1
+    $ bridge vlan add dev enp8s0f0 vid 2-3
+
 mlx5 subfunction
 ================
 mlx5 supports subfunction management using devlink port (see :ref:`Documentation/networking/devlink/devlink-port.rst <devlink_port>`) interface.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index eec5897c6b79..e1467dbe80dc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -12,11 +12,17 @@
 #include "fs_core.h"
 
 #define MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE 64000
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_FROM 0
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_FROM 0
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_TO (MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE / 2 - 1)
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_FROM \
+	(MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_TO + 1)
 #define MLX5_ESW_BRIDGE_INGRESS_TABLE_MAC_GRP_IDX_TO (MLX5_ESW_BRIDGE_INGRESS_TABLE_SIZE - 1)
 
 #define MLX5_ESW_BRIDGE_EGRESS_TABLE_SIZE 64000
-#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_FROM 0
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_IDX_FROM 0
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_IDX_TO (MLX5_ESW_BRIDGE_EGRESS_TABLE_SIZE / 2 - 1)
+#define MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_FROM \
+	(MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_IDX_TO + 1)
 #define MLX5_ESW_BRIDGE_EGRESS_TABLE_MAC_GRP_IDX_TO (MLX5_ESW_BRIDGE_EGRESS_TABLE_SIZE - 1)
 
 enum {
@@ -79,6 +85,7 @@ struct mlx5_esw_bridge {
 	struct xarray vports;
 
 	struct mlx5_flow_table *egress_ft;
+	struct mlx5_flow_group *egress_vlan_fg;
 	struct mlx5_flow_group *egress_mac_fg;
 	unsigned long ageing_time;
 	u32 flags;
@@ -120,6 +127,44 @@ mlx5_esw_bridge_table_create(int max_fte, u32 level, struct mlx5_eswitch *esw)
 	return fdb;
 }
 
+static struct mlx5_flow_group *
+mlx5_esw_bridge_ingress_vlan_fg_create(struct mlx5_eswitch *esw, struct mlx5_flow_table *ingress_ft)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
+	struct mlx5_flow_group *fg;
+	u32 *in, *match;
+
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return ERR_PTR(-ENOMEM);
+
+	MLX5_SET(create_flow_group_in, in, match_criteria_enable,
+		 MLX5_MATCH_OUTER_HEADERS | MLX5_MATCH_MISC_PARAMETERS_2);
+	match = MLX5_ADDR_OF(create_flow_group_in, in, match_criteria);
+
+	MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.smac_47_16);
+	MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.smac_15_0);
+	MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.cvlan_tag);
+	MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.first_vid);
+
+	MLX5_SET(fte_match_param, match, misc_parameters_2.metadata_reg_c_0,
+		 mlx5_eswitch_get_vport_metadata_mask());
+
+	MLX5_SET(create_flow_group_in, in, start_flow_index,
+		 MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_FROM);
+	MLX5_SET(create_flow_group_in, in, end_flow_index,
+		 MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_TO);
+
+	fg = mlx5_create_flow_group(ingress_ft, in);
+	kvfree(in);
+	if (IS_ERR(fg))
+		esw_warn(esw->dev,
+			 "Failed to create VLAN flow group for bridge ingress table (err=%ld)\n",
+			 PTR_ERR(fg));
+
+	return fg;
+}
+
 static struct mlx5_flow_group *
 mlx5_esw_bridge_ingress_mac_fg_create(struct mlx5_eswitch *esw, struct mlx5_flow_table *ingress_ft)
 {
@@ -149,13 +194,46 @@ mlx5_esw_bridge_ingress_mac_fg_create(struct mlx5_eswitch *esw, struct mlx5_flow
 	fg = mlx5_create_flow_group(ingress_ft, in);
 	if (IS_ERR(fg))
 		esw_warn(esw->dev,
-			 "Failed to create bridge ingress table MAC flow group (err=%ld)\n",
+			 "Failed to create MAC flow group for bridge ingress table (err=%ld)\n",
 			 PTR_ERR(fg));
 
 	kvfree(in);
 	return fg;
 }
 
+static struct mlx5_flow_group *
+mlx5_esw_bridge_egress_vlan_fg_create(struct mlx5_eswitch *esw, struct mlx5_flow_table *egress_ft)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
+	struct mlx5_flow_group *fg;
+	u32 *in, *match;
+
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return ERR_PTR(-ENOMEM);
+
+	MLX5_SET(create_flow_group_in, in, match_criteria_enable, MLX5_MATCH_OUTER_HEADERS);
+	match = MLX5_ADDR_OF(create_flow_group_in, in, match_criteria);
+
+	MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.dmac_47_16);
+	MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.dmac_15_0);
+	MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.cvlan_tag);
+	MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.first_vid);
+
+	MLX5_SET(create_flow_group_in, in, start_flow_index,
+		 MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_IDX_FROM);
+	MLX5_SET(create_flow_group_in, in, end_flow_index,
+		 MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_IDX_TO);
+
+	fg = mlx5_create_flow_group(egress_ft, in);
+	if (IS_ERR(fg))
+		esw_warn(esw->dev,
+			 "Failed to create VLAN flow group for bridge egress table (err=%ld)\n",
+			 PTR_ERR(fg));
+	kvfree(in);
+	return fg;
+}
+
 static struct mlx5_flow_group *
 mlx5_esw_bridge_egress_mac_fg_create(struct mlx5_eswitch *esw, struct mlx5_flow_table *egress_ft)
 {
@@ -190,8 +268,8 @@ mlx5_esw_bridge_egress_mac_fg_create(struct mlx5_eswitch *esw, struct mlx5_flow_
 static int
 mlx5_esw_bridge_ingress_table_init(struct mlx5_esw_bridge_offloads *br_offloads)
 {
+	struct mlx5_flow_group *mac_fg, *vlan_fg;
 	struct mlx5_flow_table *ingress_ft;
-	struct mlx5_flow_group *mac_fg;
 	int err;
 
 	if (!mlx5_eswitch_vport_match_metadata_enabled(br_offloads->esw))
@@ -203,6 +281,12 @@ mlx5_esw_bridge_ingress_table_init(struct mlx5_esw_bridge_offloads *br_offloads)
 	if (IS_ERR(ingress_ft))
 		return PTR_ERR(ingress_ft);
 
+	vlan_fg = mlx5_esw_bridge_ingress_vlan_fg_create(br_offloads->esw, ingress_ft);
+	if (IS_ERR(vlan_fg)) {
+		err = PTR_ERR(vlan_fg);
+		goto err_vlan_fg;
+	}
+
 	mac_fg = mlx5_esw_bridge_ingress_mac_fg_create(br_offloads->esw, ingress_ft);
 	if (IS_ERR(mac_fg)) {
 		err = PTR_ERR(mac_fg);
@@ -210,10 +294,13 @@ mlx5_esw_bridge_ingress_table_init(struct mlx5_esw_bridge_offloads *br_offloads)
 	}
 
 	br_offloads->ingress_ft = ingress_ft;
+	br_offloads->ingress_vlan_fg = vlan_fg;
 	br_offloads->ingress_mac_fg = mac_fg;
 	return 0;
 
 err_mac_fg:
+	mlx5_destroy_flow_group(vlan_fg);
+err_vlan_fg:
 	mlx5_destroy_flow_table(ingress_ft);
 	return err;
 }
@@ -223,6 +310,8 @@ mlx5_esw_bridge_ingress_table_cleanup(struct mlx5_esw_bridge_offloads *br_offloa
 {
 	mlx5_destroy_flow_group(br_offloads->ingress_mac_fg);
 	br_offloads->ingress_mac_fg = NULL;
+	mlx5_destroy_flow_group(br_offloads->ingress_vlan_fg);
+	br_offloads->ingress_vlan_fg = NULL;
 	mlx5_destroy_flow_table(br_offloads->ingress_ft);
 	br_offloads->ingress_ft = NULL;
 }
@@ -231,8 +320,8 @@ static int
 mlx5_esw_bridge_egress_table_init(struct mlx5_esw_bridge_offloads *br_offloads,
 				  struct mlx5_esw_bridge *bridge)
 {
+	struct mlx5_flow_group *mac_fg, *vlan_fg;
 	struct mlx5_flow_table *egress_ft;
-	struct mlx5_flow_group *mac_fg;
 	int err;
 
 	egress_ft = mlx5_esw_bridge_table_create(MLX5_ESW_BRIDGE_EGRESS_TABLE_SIZE,
@@ -241,6 +330,12 @@ mlx5_esw_bridge_egress_table_init(struct mlx5_esw_bridge_offloads *br_offloads,
 	if (IS_ERR(egress_ft))
 		return PTR_ERR(egress_ft);
 
+	vlan_fg = mlx5_esw_bridge_egress_vlan_fg_create(br_offloads->esw, egress_ft);
+	if (IS_ERR(vlan_fg)) {
+		err = PTR_ERR(vlan_fg);
+		goto err_vlan_fg;
+	}
+
 	mac_fg = mlx5_esw_bridge_egress_mac_fg_create(br_offloads->esw, egress_ft);
 	if (IS_ERR(mac_fg)) {
 		err = PTR_ERR(mac_fg);
@@ -248,10 +343,13 @@ mlx5_esw_bridge_egress_table_init(struct mlx5_esw_bridge_offloads *br_offloads,
 	}
 
 	bridge->egress_ft = egress_ft;
+	bridge->egress_vlan_fg = vlan_fg;
 	bridge->egress_mac_fg = mac_fg;
 	return 0;
 
 err_mac_fg:
+	mlx5_destroy_flow_group(vlan_fg);
+err_vlan_fg:
 	mlx5_destroy_flow_table(egress_ft);
 	return err;
 }
@@ -260,12 +358,14 @@ static void
 mlx5_esw_bridge_egress_table_cleanup(struct mlx5_esw_bridge *bridge)
 {
 	mlx5_destroy_flow_group(bridge->egress_mac_fg);
+	mlx5_destroy_flow_group(bridge->egress_vlan_fg);
 	mlx5_destroy_flow_table(bridge->egress_ft);
 }
 
 static struct mlx5_flow_handle *
-mlx5_esw_bridge_ingress_flow_create(u16 vport_num, const unsigned char *addr, u16 vid,
-				    u32 counter_id, struct mlx5_esw_bridge *bridge)
+mlx5_esw_bridge_ingress_flow_create(u16 vport_num, const unsigned char *addr,
+				    struct mlx5_esw_bridge_vlan *vlan, u32 counter_id,
+				    struct mlx5_esw_bridge *bridge)
 {
 	struct mlx5_esw_bridge_offloads *br_offloads = bridge->br_offloads;
 	struct mlx5_flow_act flow_act = {
@@ -295,6 +395,17 @@ mlx5_esw_bridge_ingress_flow_create(u16 vport_num, const unsigned char *addr, u1
 	MLX5_SET(fte_match_param, rule_spec->match_value, misc_parameters_2.metadata_reg_c_0,
 		 mlx5_eswitch_get_vport_metadata_for_match(br_offloads->esw, vport_num));
 
+	if (vlan) {
+		MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria,
+				 outer_headers.cvlan_tag);
+		MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_value,
+				 outer_headers.cvlan_tag);
+		MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria,
+				 outer_headers.first_vid);
+		MLX5_SET(fte_match_param, rule_spec->match_value, outer_headers.first_vid,
+			 vlan->vid);
+	}
+
 	dests[0].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dests[0].ft = bridge->egress_ft;
 	dests[1].type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
@@ -308,7 +419,8 @@ mlx5_esw_bridge_ingress_flow_create(u16 vport_num, const unsigned char *addr, u1
 }
 
 static struct mlx5_flow_handle *
-mlx5_esw_bridge_egress_flow_create(u16 vport_num, const unsigned char *addr, u16 vid,
+mlx5_esw_bridge_egress_flow_create(u16 vport_num, const unsigned char *addr,
+				   struct mlx5_esw_bridge_vlan *vlan,
 				   struct mlx5_esw_bridge *bridge)
 {
 	struct mlx5_flow_destination dest = {
@@ -336,6 +448,17 @@ mlx5_esw_bridge_egress_flow_create(u16 vport_num, const unsigned char *addr, u16
 			      outer_headers.dmac_47_16);
 	eth_broadcast_addr(dmac_c);
 
+	if (vlan) {
+		MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria,
+				 outer_headers.cvlan_tag);
+		MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_value,
+				 outer_headers.cvlan_tag);
+		MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria,
+				 outer_headers.first_vid);
+		MLX5_SET(fte_match_param, rule_spec->match_value, outer_headers.first_vid,
+			 vlan->vid);
+	}
+
 	handle = mlx5_add_flow_rules(bridge->egress_ft, rule_spec, &flow_act, &dest, 1);
 
 	kvfree(rule_spec);
@@ -517,17 +640,55 @@ static void mlx5_esw_bridge_port_vlans_flush(struct mlx5_esw_bridge_port *port)
 		mlx5_esw_bridge_vlan_cleanup(port, vlan);
 }
 
+static struct mlx5_esw_bridge_vlan *
+mlx5_esw_bridge_port_vlan_lookup(u16 vid, u16 vport_num, struct mlx5_esw_bridge *bridge,
+				 struct mlx5_eswitch *esw)
+{
+	struct mlx5_esw_bridge_port *port;
+	struct mlx5_esw_bridge_vlan *vlan;
+
+	port = mlx5_esw_bridge_port_lookup(vport_num, bridge);
+	if (!port) {
+		/* FDB is added asynchronously on wq while port might have been deleted
+		 * concurrently. Report on 'info' logging level and skip the FDB offload.
+		 */
+		esw_info(esw->dev, "Failed to lookup bridge port (vport=%u)\n", vport_num);
+		return ERR_PTR(-EINVAL);
+	}
+
+	vlan = mlx5_esw_bridge_vlan_lookup(vid, port);
+	if (!vlan) {
+		/* FDB is added asynchronously on wq while vlan might have been deleted
+		 * concurrently. Report on 'info' logging level and skip the FDB offload.
+		 */
+		esw_info(esw->dev, "Failed to lookup bridge port vlan metadata (vport=%u)\n",
+			 vport_num);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return vlan;
+}
+
 static struct mlx5_esw_bridge_fdb_entry *
 mlx5_esw_bridge_fdb_entry_init(struct net_device *dev, u16 vport_num, const unsigned char *addr,
 			       u16 vid, bool added_by_user, struct mlx5_eswitch *esw,
 			       struct mlx5_esw_bridge *bridge)
 {
+	struct mlx5_esw_bridge_vlan *vlan = NULL;
 	struct mlx5_esw_bridge_fdb_entry *entry;
 	struct mlx5_flow_handle *handle;
 	struct mlx5_fc *counter;
 	struct mlx5e_priv *priv;
 	int err;
 
+	if (bridge->flags & MLX5_ESW_BRIDGE_VLAN_FILTERING_FLAG && vid) {
+		vlan = mlx5_esw_bridge_port_vlan_lookup(vid, vport_num, bridge, esw);
+		if (IS_ERR(vlan))
+			return ERR_CAST(vlan);
+		if (vlan->flags & (BRIDGE_VLAN_INFO_PVID | BRIDGE_VLAN_INFO_UNTAGGED))
+			return ERR_PTR(-EOPNOTSUPP); /* can't offload vlan push/pop */
+	}
+
 	priv = netdev_priv(dev);
 	entry = kvzalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry)
@@ -548,7 +709,7 @@ mlx5_esw_bridge_fdb_entry_init(struct net_device *dev, u16 vport_num, const unsi
 	}
 	entry->ingress_counter = counter;
 
-	handle = mlx5_esw_bridge_ingress_flow_create(vport_num, addr, vid, mlx5_fc_id(counter),
+	handle = mlx5_esw_bridge_ingress_flow_create(vport_num, addr, vlan, mlx5_fc_id(counter),
 						     bridge);
 	if (IS_ERR(handle)) {
 		err = PTR_ERR(handle);
@@ -558,7 +719,7 @@ mlx5_esw_bridge_fdb_entry_init(struct net_device *dev, u16 vport_num, const unsi
 	}
 	entry->ingress_handle = handle;
 
-	handle = mlx5_esw_bridge_egress_flow_create(vport_num, addr, vid, bridge);
+	handle = mlx5_esw_bridge_egress_flow_create(vport_num, addr, vlan, bridge);
 	if (IS_ERR(handle)) {
 		err = PTR_ERR(handle);
 		esw_warn(esw->dev, "Failed to create egress flow(vport=%u,err=%d)\n",
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
index 276ed0392607..bedbda57cdb3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
@@ -22,6 +22,7 @@ struct mlx5_esw_bridge_offloads {
 	struct delayed_work update_work;
 
 	struct mlx5_flow_table *ingress_ft;
+	struct mlx5_flow_group *ingress_vlan_fg;
 	struct mlx5_flow_group *ingress_mac_fg;
 };
 
-- 
2.31.1

