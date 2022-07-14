Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64467573FDA
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 00:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiGMW7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 18:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiGMW72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 18:59:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94202AC41
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 15:59:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F38BA61651
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 22:59:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48168C34114;
        Wed, 13 Jul 2022 22:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657753159;
        bh=SFTsARE2dBBPTbwdjU19YAgKizDsjBBf+sUUELLgO7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PNC7ENL9zjvtDXVGDKuckaoQWwNZJc7vGGjMA7cklEb29QWnJUOhhDpI562FRF6S7
         OZ7O3CO6g1lB9CgqtB+fKrIitEuLQJxLpb30RCX5+nmo+IENbOIWCzAKYDO64bQtFl
         QutbRPgmZ5hMyciKYkitf391dOY3grGAfgGp7zDgD3RyXUFlc0ROB8XcL6jzCwStzT
         oJouObt/J252/QpMUSEO2bqoZC25PVIHMdMnvoSZi+f+hXPACOtrDMUuYL41AM8xvZ
         I4sOU5ggRJobal7xj98fS4L6WOCYg5ejf7+2u/KrKsfkwGds4nlgqzjH8kE5Myh92i
         5tJuHkEL1uXjg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 09/15] net/mlx5: Bridge, implement infrastructure for VLAN protocol change
Date:   Wed, 13 Jul 2022 15:58:53 -0700
Message-Id: <20220713225859.401241-10-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220713225859.401241-1-saeed@kernel.org>
References: <20220713225859.401241-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Current implementation only supports 802.1Q VLAN Ethernet protocol. That
protocol type is assumed by default and
SWITCHDEV_ATTR_ID_BRIDGE_VLAN_PROTOCOL notification is ignored. To prepare
for supporting 802.1ad protocol in following patches implement the
necessary infrastructure to allow the user to dynamically change the VLAN
protocol:

- Handle SWITCHDEV_ATTR_ID_BRIDGE_VLAN_PROTOCOL notification by flushing
FDB and re-creating VLAN modify header actions with new protocol. In this
patch the only allowed dynamic VLAN protocol value is ETH_P_8021Q.

- Save current VLAN protocol in per-bridge instance variable. Use the
dynamic variable instead of hardcoded values in mlx5 bridge code. Create
VLAN flow groups and flows based on current mlx5_esw_bridge->vlan_proto
value instead of assuming 802.1Q ethertype.

- Extract common flow group creation code into dedicated functions in order
to be reused for creating QinQ groups in following patches.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/rep/bridge.c        |   6 +
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  | 194 ++++++++++++++----
 .../ethernet/mellanox/mlx5/core/esw/bridge.h  |   2 +
 3 files changed, 160 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
index 48dc121b2cb4..39ef2a2561a3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
@@ -269,6 +269,12 @@ mlx5_esw_bridge_port_obj_attr_set(struct net_device *dev,
 		err = mlx5_esw_bridge_vlan_filtering_set(vport_num, esw_owner_vhca_id,
 							 attr->u.vlan_filtering, br_offloads);
 		break;
+	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_PROTOCOL:
+		err = mlx5_esw_bridge_vlan_proto_set(vport_num,
+						     esw_owner_vhca_id,
+						     attr->u.vlan_protocol,
+						     br_offloads);
+		break;
 	default:
 		err = -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index 2b6e258279f0..e505c4623e65 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -86,6 +86,7 @@ struct mlx5_esw_bridge {
 	struct mlx5_flow_handle *egress_miss_handle;
 	unsigned long ageing_time;
 	u32 flags;
+	u16 vlan_proto;
 };
 
 static void
@@ -155,7 +156,9 @@ mlx5_esw_bridge_table_create(int max_fte, u32 level, struct mlx5_eswitch *esw)
 }
 
 static struct mlx5_flow_group *
-mlx5_esw_bridge_ingress_vlan_fg_create(struct mlx5_eswitch *esw, struct mlx5_flow_table *ingress_ft)
+mlx5_esw_bridge_ingress_vlan_proto_fg_create(unsigned int from, unsigned int to, u16 vlan_proto,
+					     struct mlx5_eswitch *esw,
+					     struct mlx5_flow_table *ingress_ft)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
 	struct mlx5_flow_group *fg;
@@ -171,30 +174,40 @@ mlx5_esw_bridge_ingress_vlan_fg_create(struct mlx5_eswitch *esw, struct mlx5_flo
 
 	MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.smac_47_16);
 	MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.smac_15_0);
-	MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.cvlan_tag);
+	if (vlan_proto == ETH_P_8021Q)
+		MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.cvlan_tag);
 	MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.first_vid);
 
 	MLX5_SET(fte_match_param, match, misc_parameters_2.metadata_reg_c_0,
 		 mlx5_eswitch_get_vport_metadata_mask());
 
-	MLX5_SET(create_flow_group_in, in, start_flow_index,
-		 MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_FROM);
-	MLX5_SET(create_flow_group_in, in, end_flow_index,
-		 MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_TO);
+	MLX5_SET(create_flow_group_in, in, start_flow_index, from);
+	MLX5_SET(create_flow_group_in, in, end_flow_index, to);
 
 	fg = mlx5_create_flow_group(ingress_ft, in);
 	kvfree(in);
 	if (IS_ERR(fg))
 		esw_warn(esw->dev,
-			 "Failed to create VLAN flow group for bridge ingress table (err=%ld)\n",
-			 PTR_ERR(fg));
+			 "Failed to create VLAN(proto=%x) flow group for bridge ingress table (err=%ld)\n",
+			 vlan_proto, PTR_ERR(fg));
 
 	return fg;
 }
 
 static struct mlx5_flow_group *
-mlx5_esw_bridge_ingress_vlan_filter_fg_create(struct mlx5_eswitch *esw,
-					      struct mlx5_flow_table *ingress_ft)
+mlx5_esw_bridge_ingress_vlan_fg_create(struct mlx5_eswitch *esw,
+				       struct mlx5_flow_table *ingress_ft)
+{
+	unsigned int from = MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_FROM;
+	unsigned int to = MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_TO;
+
+	return mlx5_esw_bridge_ingress_vlan_proto_fg_create(from, to, ETH_P_8021Q, esw, ingress_ft);
+}
+
+static struct mlx5_flow_group *
+mlx5_esw_bridge_ingress_vlan_proto_filter_fg_create(unsigned int from, unsigned int to,
+						    u16 vlan_proto, struct mlx5_eswitch *esw,
+						    struct mlx5_flow_table *ingress_ft)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
 	struct mlx5_flow_group *fg;
@@ -210,26 +223,34 @@ mlx5_esw_bridge_ingress_vlan_filter_fg_create(struct mlx5_eswitch *esw,
 
 	MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.smac_47_16);
 	MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.smac_15_0);
-	MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.cvlan_tag);
-
+	if (vlan_proto == ETH_P_8021Q)
+		MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.cvlan_tag);
 	MLX5_SET(fte_match_param, match, misc_parameters_2.metadata_reg_c_0,
 		 mlx5_eswitch_get_vport_metadata_mask());
 
-	MLX5_SET(create_flow_group_in, in, start_flow_index,
-		 MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_FILTER_GRP_IDX_FROM);
-	MLX5_SET(create_flow_group_in, in, end_flow_index,
-		 MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_FILTER_GRP_IDX_TO);
+	MLX5_SET(create_flow_group_in, in, start_flow_index, from);
+	MLX5_SET(create_flow_group_in, in, end_flow_index, to);
 
 	fg = mlx5_create_flow_group(ingress_ft, in);
 	if (IS_ERR(fg))
 		esw_warn(esw->dev,
 			 "Failed to create bridge ingress table VLAN filter flow group (err=%ld)\n",
 			 PTR_ERR(fg));
-
 	kvfree(in);
 	return fg;
 }
 
+static struct mlx5_flow_group *
+mlx5_esw_bridge_ingress_vlan_filter_fg_create(struct mlx5_eswitch *esw,
+					      struct mlx5_flow_table *ingress_ft)
+{
+	unsigned int from = MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_FILTER_GRP_IDX_FROM;
+	unsigned int to = MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_FILTER_GRP_IDX_TO;
+
+	return mlx5_esw_bridge_ingress_vlan_proto_filter_fg_create(from, to, ETH_P_8021Q, esw,
+								   ingress_ft);
+}
+
 static struct mlx5_flow_group *
 mlx5_esw_bridge_ingress_mac_fg_create(struct mlx5_eswitch *esw, struct mlx5_flow_table *ingress_ft)
 {
@@ -267,7 +288,9 @@ mlx5_esw_bridge_ingress_mac_fg_create(struct mlx5_eswitch *esw, struct mlx5_flow
 }
 
 static struct mlx5_flow_group *
-mlx5_esw_bridge_egress_vlan_fg_create(struct mlx5_eswitch *esw, struct mlx5_flow_table *egress_ft)
+mlx5_esw_bridge_egress_vlan_proto_fg_create(unsigned int from, unsigned int to, u16 vlan_proto,
+					    struct mlx5_eswitch *esw,
+					    struct mlx5_flow_table *egress_ft)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
 	struct mlx5_flow_group *fg;
@@ -282,13 +305,12 @@ mlx5_esw_bridge_egress_vlan_fg_create(struct mlx5_eswitch *esw, struct mlx5_flow
 
 	MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.dmac_47_16);
 	MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.dmac_15_0);
-	MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.cvlan_tag);
+	if (vlan_proto == ETH_P_8021Q)
+		MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.cvlan_tag);
 	MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.first_vid);
 
-	MLX5_SET(create_flow_group_in, in, start_flow_index,
-		 MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_IDX_FROM);
-	MLX5_SET(create_flow_group_in, in, end_flow_index,
-		 MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_IDX_TO);
+	MLX5_SET(create_flow_group_in, in, start_flow_index, from);
+	MLX5_SET(create_flow_group_in, in, end_flow_index, to);
 
 	fg = mlx5_create_flow_group(egress_ft, in);
 	if (IS_ERR(fg))
@@ -299,6 +321,15 @@ mlx5_esw_bridge_egress_vlan_fg_create(struct mlx5_eswitch *esw, struct mlx5_flow
 	return fg;
 }
 
+static struct mlx5_flow_group *
+mlx5_esw_bridge_egress_vlan_fg_create(struct mlx5_eswitch *esw, struct mlx5_flow_table *egress_ft)
+{
+	unsigned int from = MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_IDX_FROM;
+	unsigned int to = MLX5_ESW_BRIDGE_EGRESS_TABLE_VLAN_GRP_IDX_TO;
+
+	return mlx5_esw_bridge_egress_vlan_proto_fg_create(from, to, ETH_P_8021Q, esw, egress_ft);
+}
+
 static struct mlx5_flow_group *
 mlx5_esw_bridge_egress_mac_fg_create(struct mlx5_eswitch *esw, struct mlx5_flow_table *egress_ft)
 {
@@ -576,10 +607,12 @@ mlx5_esw_bridge_ingress_flow_with_esw_create(u16 vport_num, const unsigned char
 		flow_act.pkt_reformat = vlan->pkt_reformat_push;
 		flow_act.modify_hdr = vlan->pkt_mod_hdr_push_mark;
 	} else if (vlan) {
-		MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria,
-				 outer_headers.cvlan_tag);
-		MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_value,
-				 outer_headers.cvlan_tag);
+		if (bridge->vlan_proto == ETH_P_8021Q) {
+			MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria,
+					 outer_headers.cvlan_tag);
+			MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_value,
+					 outer_headers.cvlan_tag);
+		}
 		MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria,
 				 outer_headers.first_vid);
 		MLX5_SET(fte_match_param, rule_spec->match_value, outer_headers.first_vid,
@@ -662,10 +695,12 @@ mlx5_esw_bridge_ingress_filter_flow_create(u16 vport_num, const unsigned char *a
 	MLX5_SET(fte_match_param, rule_spec->match_value, misc_parameters_2.metadata_reg_c_0,
 		 mlx5_eswitch_get_vport_metadata_for_match(br_offloads->esw, vport_num));
 
-	MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria,
-			 outer_headers.cvlan_tag);
-	MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_value,
-			 outer_headers.cvlan_tag);
+	if (bridge->vlan_proto == ETH_P_8021Q) {
+		MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria,
+				 outer_headers.cvlan_tag);
+		MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_value,
+				 outer_headers.cvlan_tag);
+	}
 
 	handle = mlx5_add_flow_rules(br_offloads->ingress_ft, rule_spec, &flow_act, &dest, 1);
 
@@ -713,10 +748,12 @@ mlx5_esw_bridge_egress_flow_create(u16 vport_num, u16 esw_owner_vhca_id, const u
 			flow_act.pkt_reformat = vlan->pkt_reformat_pop;
 		}
 
-		MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria,
-				 outer_headers.cvlan_tag);
-		MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_value,
-				 outer_headers.cvlan_tag);
+		if (bridge->vlan_proto == ETH_P_8021Q) {
+			MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria,
+					 outer_headers.cvlan_tag);
+			MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_value,
+					 outer_headers.cvlan_tag);
+		}
 		MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria,
 				 outer_headers.first_vid);
 		MLX5_SET(fte_match_param, rule_spec->match_value, outer_headers.first_vid,
@@ -791,6 +828,7 @@ static struct mlx5_esw_bridge *mlx5_esw_bridge_create(int ifindex,
 	bridge->ifindex = ifindex;
 	bridge->refcnt = 1;
 	bridge->ageing_time = clock_t_to_jiffies(BR_DEFAULT_AGEING_TIME);
+	bridge->vlan_proto = ETH_P_8021Q;
 	list_add(&bridge->list, &br_offloads->bridges);
 
 	return bridge;
@@ -928,12 +966,13 @@ mlx5_esw_bridge_vlan_lookup(u16 vid, struct mlx5_esw_bridge_port *port)
 }
 
 static int
-mlx5_esw_bridge_vlan_push_create(struct mlx5_esw_bridge_vlan *vlan, struct mlx5_eswitch *esw)
+mlx5_esw_bridge_vlan_push_create(u16 vlan_proto, struct mlx5_esw_bridge_vlan *vlan,
+				 struct mlx5_eswitch *esw)
 {
 	struct {
 		__be16	h_vlan_proto;
 		__be16	h_vlan_TCI;
-	} vlan_hdr = { htons(ETH_P_8021Q), htons(vlan->vid) };
+	} vlan_hdr = { htons(vlan_proto), htons(vlan->vid) };
 	struct mlx5_pkt_reformat_params reformat_params = {};
 	struct mlx5_pkt_reformat *pkt_reformat;
 
@@ -1026,13 +1065,13 @@ mlx5_esw_bridge_vlan_push_mark_cleanup(struct mlx5_esw_bridge_vlan *vlan, struct
 }
 
 static int
-mlx5_esw_bridge_vlan_push_pop_create(u16 flags, struct mlx5_esw_bridge_vlan *vlan,
+mlx5_esw_bridge_vlan_push_pop_create(u16 vlan_proto, u16 flags, struct mlx5_esw_bridge_vlan *vlan,
 				     struct mlx5_eswitch *esw)
 {
 	int err;
 
 	if (flags & BRIDGE_VLAN_INFO_PVID) {
-		err = mlx5_esw_bridge_vlan_push_create(vlan, esw);
+		err = mlx5_esw_bridge_vlan_push_create(vlan_proto, vlan, esw);
 		if (err)
 			return err;
 
@@ -1059,7 +1098,7 @@ mlx5_esw_bridge_vlan_push_pop_create(u16 flags, struct mlx5_esw_bridge_vlan *vla
 }
 
 static struct mlx5_esw_bridge_vlan *
-mlx5_esw_bridge_vlan_create(u16 vid, u16 flags, struct mlx5_esw_bridge_port *port,
+mlx5_esw_bridge_vlan_create(u16 vlan_proto, u16 vid, u16 flags, struct mlx5_esw_bridge_port *port,
 			    struct mlx5_eswitch *esw)
 {
 	struct mlx5_esw_bridge_vlan *vlan;
@@ -1073,7 +1112,7 @@ mlx5_esw_bridge_vlan_create(u16 vid, u16 flags, struct mlx5_esw_bridge_port *por
 	vlan->flags = flags;
 	INIT_LIST_HEAD(&vlan->fdb_list);
 
-	err = mlx5_esw_bridge_vlan_push_pop_create(flags, vlan, esw);
+	err = mlx5_esw_bridge_vlan_push_pop_create(vlan_proto, flags, vlan, esw);
 	if (err)
 		goto err_vlan_push_pop;
 
@@ -1139,6 +1178,50 @@ static void mlx5_esw_bridge_port_vlans_flush(struct mlx5_esw_bridge_port *port,
 		mlx5_esw_bridge_vlan_cleanup(port, vlan, bridge);
 }
 
+static int mlx5_esw_bridge_port_vlans_recreate(struct mlx5_esw_bridge_port *port,
+					       struct mlx5_esw_bridge *bridge)
+{
+	struct mlx5_esw_bridge_offloads *br_offloads = bridge->br_offloads;
+	struct mlx5_esw_bridge_vlan *vlan;
+	unsigned long i;
+	int err;
+
+	xa_for_each(&port->vlans, i, vlan) {
+		mlx5_esw_bridge_vlan_flush(vlan, bridge);
+		err = mlx5_esw_bridge_vlan_push_pop_create(bridge->vlan_proto, vlan->flags, vlan,
+							   br_offloads->esw);
+		if (err) {
+			esw_warn(br_offloads->esw->dev,
+				 "Failed to create VLAN=%u(proto=%x) push/pop actions (vport=%u,err=%d)\n",
+				 vlan->vid, bridge->vlan_proto, port->vport_num,
+				 err);
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+static int
+mlx5_esw_bridge_vlans_recreate(struct mlx5_esw_bridge *bridge)
+{
+	struct mlx5_esw_bridge_offloads *br_offloads = bridge->br_offloads;
+	struct mlx5_esw_bridge_port *port;
+	unsigned long i;
+	int err;
+
+	xa_for_each(&br_offloads->ports, i, port) {
+		if (port->bridge != bridge)
+			continue;
+
+		err = mlx5_esw_bridge_port_vlans_recreate(port, bridge);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 static struct mlx5_esw_bridge_vlan *
 mlx5_esw_bridge_port_vlan_lookup(u16 vid, u16 vport_num, u16 esw_owner_vhca_id,
 				 struct mlx5_esw_bridge *bridge, struct mlx5_eswitch *esw)
@@ -1324,6 +1407,32 @@ int mlx5_esw_bridge_vlan_filtering_set(u16 vport_num, u16 esw_owner_vhca_id, boo
 	return 0;
 }
 
+int mlx5_esw_bridge_vlan_proto_set(u16 vport_num, u16 esw_owner_vhca_id, u16 proto,
+				   struct mlx5_esw_bridge_offloads *br_offloads)
+{
+	struct mlx5_esw_bridge_port *port;
+	struct mlx5_esw_bridge *bridge;
+
+	port = mlx5_esw_bridge_port_lookup(vport_num, esw_owner_vhca_id,
+					   br_offloads);
+	if (!port)
+		return -EINVAL;
+
+	bridge = port->bridge;
+	if (bridge->vlan_proto == proto)
+		return 0;
+	if (proto != ETH_P_8021Q) {
+		esw_warn(br_offloads->esw->dev, "Can't set unsupported VLAN protocol %x", proto);
+		return -EOPNOTSUPP;
+	}
+
+	mlx5_esw_bridge_fdb_flush(bridge);
+	bridge->vlan_proto = proto;
+	mlx5_esw_bridge_vlans_recreate(bridge);
+
+	return 0;
+}
+
 static int mlx5_esw_bridge_vport_init(u16 vport_num, u16 esw_owner_vhca_id, u16 flags,
 				      struct mlx5_esw_bridge_offloads *br_offloads,
 				      struct mlx5_esw_bridge *bridge)
@@ -1471,7 +1580,8 @@ int mlx5_esw_bridge_port_vlan_add(u16 vport_num, u16 esw_owner_vhca_id, u16 vid,
 		mlx5_esw_bridge_vlan_cleanup(port, vlan, port->bridge);
 	}
 
-	vlan = mlx5_esw_bridge_vlan_create(vid, flags, port, br_offloads->esw);
+	vlan = mlx5_esw_bridge_vlan_create(port->bridge->vlan_proto, vid, flags, port,
+					   br_offloads->esw);
 	if (IS_ERR(vlan)) {
 		NL_SET_ERR_MSG_MOD(extack, "Failed to create VLAN entry");
 		return PTR_ERR(vlan);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
index 3d0bd6e6c33c..8c322ef05892 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
@@ -60,6 +60,8 @@ int mlx5_esw_bridge_ageing_time_set(u16 vport_num, u16 esw_owner_vhca_id, unsign
 				    struct mlx5_esw_bridge_offloads *br_offloads);
 int mlx5_esw_bridge_vlan_filtering_set(u16 vport_num, u16 esw_owner_vhca_id, bool enable,
 				       struct mlx5_esw_bridge_offloads *br_offloads);
+int mlx5_esw_bridge_vlan_proto_set(u16 vport_num, u16 esw_owner_vhca_id, u16 proto,
+				   struct mlx5_esw_bridge_offloads *br_offloads);
 int mlx5_esw_bridge_port_vlan_add(u16 vport_num, u16 esw_owner_vhca_id, u16 vid, u16 flags,
 				  struct mlx5_esw_bridge_offloads *br_offloads,
 				  struct netlink_ext_ack *extack);
-- 
2.36.1

