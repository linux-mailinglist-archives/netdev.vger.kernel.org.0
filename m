Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04B8D3F91BF
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 03:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244137AbhH0BAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 21:00:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:53838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244058AbhH0A7i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 20:59:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0656C610FA;
        Fri, 27 Aug 2021 00:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630025904;
        bh=D6GXCmVlbzU4hw8myQwYk48CwQ/yBj2D5X8mT2RkVE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TlFfUW8T//gBm5gzng+72Sr627jTCdXDOOZRFxqROgWpy0qeWjMKdDmdu48n7MBap
         9r/wTAC/3WzNd7FFzpJ4B/qLObEQtM1WhfCMee4rLcMAXIEDagbYOUo17bxQaWhWMZ
         iVVYoiZsOnGKutBvGii0wyPvc2dv4kKxznQ0Y1Pgl4jimsTaq9CXUHg2u4JTmhBSeT
         wVul7j85D7ZmAuCOmME6/NurT2V13uOF+u+JZLERE6FOG3gc9qv1sCyuLQaN2Xh3Gi
         ytPJpR1OnXmcUcqGxuVYpDIsMlH5tPlK6qYxwNrCA/axOz4LRf141Z2MVEtizgFadz
         A9w216vm2h1Iw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/17] net/mlx5: DR, Remove HW specific STE type from nic domain
Date:   Thu, 26 Aug 2021 17:57:59 -0700
Message-Id: <20210827005802.236119-15-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210827005802.236119-1-saeed@kernel.org>
References: <20210827005802.236119-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Instead of using the HW specific STEv0 type, it is better to use
an enum to indicate if this is an RX or TX nic domain.
This means that now we will need to convert the nic domain type
to the corresponding STE type.

Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_action.c   | 14 +++---
 .../mellanox/mlx5/core/steering/dr_domain.c   |  8 ++--
 .../mellanox/mlx5/core/steering/dr_matcher.c  |  2 +-
 .../mellanox/mlx5/core/steering/dr_rule.c     |  8 ++--
 .../mellanox/mlx5/core/steering/dr_ste.c      | 10 +++--
 .../mellanox/mlx5/core/steering/dr_ste.h      |  2 +-
 .../mellanox/mlx5/core/steering/dr_ste_v0.c   | 45 ++++++++++++-------
 .../mellanox/mlx5/core/steering/dr_ste_v1.c   |  2 +-
 .../mellanox/mlx5/core/steering/dr_types.h    |  9 +++-
 .../mellanox/mlx5/core/steering/mlx5_ifc_dr.h |  6 ---
 10 files changed, 61 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index f3327eecddfa..a5b9f65db23c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -434,7 +434,7 @@ dr_action_reformat_to_action_type(enum mlx5dr_action_reformat_type reformat_type
  * the new size of the STEs array, rule with actions.
  */
 static void dr_actions_apply(struct mlx5dr_domain *dmn,
-			     enum mlx5dr_ste_entry_type ste_type,
+			     enum mlx5dr_domain_nic_type nic_type,
 			     u8 *action_type_set,
 			     u8 *last_ste,
 			     struct mlx5dr_ste_actions_attr *attr,
@@ -443,7 +443,7 @@ static void dr_actions_apply(struct mlx5dr_domain *dmn,
 	struct mlx5dr_ste_ctx *ste_ctx = dmn->ste_ctx;
 	u32 added_stes = 0;
 
-	if (ste_type == MLX5DR_STE_TYPE_RX)
+	if (nic_type == DR_DOMAIN_NIC_TYPE_RX)
 		mlx5dr_ste_set_actions_rx(ste_ctx, dmn, action_type_set,
 					  last_ste, attr, &added_stes);
 	else
@@ -455,7 +455,7 @@ static void dr_actions_apply(struct mlx5dr_domain *dmn,
 
 static enum dr_action_domain
 dr_action_get_action_domain(enum mlx5dr_domain_type domain,
-			    enum mlx5dr_ste_entry_type ste_type)
+			    enum mlx5dr_domain_nic_type nic_type)
 {
 	switch (domain) {
 	case MLX5DR_DOMAIN_TYPE_NIC_RX:
@@ -463,7 +463,7 @@ dr_action_get_action_domain(enum mlx5dr_domain_type domain,
 	case MLX5DR_DOMAIN_TYPE_NIC_TX:
 		return DR_ACTION_DOMAIN_NIC_EGRESS;
 	case MLX5DR_DOMAIN_TYPE_FDB:
-		if (ste_type == MLX5DR_STE_TYPE_RX)
+		if (nic_type == DR_DOMAIN_NIC_TYPE_RX)
 			return DR_ACTION_DOMAIN_FDB_INGRESS;
 		return DR_ACTION_DOMAIN_FDB_EGRESS;
 	default:
@@ -551,7 +551,7 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 				 u32 *new_hw_ste_arr_sz)
 {
 	struct mlx5dr_domain_rx_tx *nic_dmn = nic_matcher->nic_tbl->nic_dmn;
-	bool rx_rule = nic_dmn->ste_type == MLX5DR_STE_TYPE_RX;
+	bool rx_rule = nic_dmn->type == DR_DOMAIN_NIC_TYPE_RX;
 	struct mlx5dr_domain *dmn = matcher->tbl->dmn;
 	u8 action_type_set[DR_ACTION_TYP_MAX] = {};
 	struct mlx5dr_ste_actions_attr attr = {};
@@ -565,7 +565,7 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 	attr.gvmi = dmn->info.caps.gvmi;
 	attr.hit_gvmi = dmn->info.caps.gvmi;
 	attr.final_icm_addr = nic_dmn->default_icm_addr;
-	action_domain = dr_action_get_action_domain(dmn->type, nic_dmn->ste_type);
+	action_domain = dr_action_get_action_domain(dmn->type, nic_dmn->type);
 
 	for (i = 0; i < num_actions; i++) {
 		struct mlx5dr_action_dest_tbl *dest_tbl;
@@ -752,7 +752,7 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 	}
 
 	dr_actions_apply(dmn,
-			 nic_dmn->ste_type,
+			 nic_dmn->type,
 			 action_type_set,
 			 last_ste,
 			 &attr,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
index 7091b1be84ef..0fe159809ba1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -245,7 +245,7 @@ static int dr_domain_caps_init(struct mlx5_core_dev *mdev,
 			return -ENOTSUPP;
 
 		dmn->info.supp_sw_steering = true;
-		dmn->info.rx.ste_type = MLX5DR_STE_TYPE_RX;
+		dmn->info.rx.type = DR_DOMAIN_NIC_TYPE_RX;
 		dmn->info.rx.default_icm_addr = dmn->info.caps.nic_rx_drop_address;
 		dmn->info.rx.drop_icm_addr = dmn->info.caps.nic_rx_drop_address;
 		break;
@@ -254,7 +254,7 @@ static int dr_domain_caps_init(struct mlx5_core_dev *mdev,
 			return -ENOTSUPP;
 
 		dmn->info.supp_sw_steering = true;
-		dmn->info.tx.ste_type = MLX5DR_STE_TYPE_TX;
+		dmn->info.tx.type = DR_DOMAIN_NIC_TYPE_TX;
 		dmn->info.tx.default_icm_addr = dmn->info.caps.nic_tx_allow_address;
 		dmn->info.tx.drop_icm_addr = dmn->info.caps.nic_tx_drop_address;
 		break;
@@ -265,8 +265,8 @@ static int dr_domain_caps_init(struct mlx5_core_dev *mdev,
 		if (!DR_DOMAIN_SW_STEERING_SUPPORTED(dmn, fdb))
 			return -ENOTSUPP;
 
-		dmn->info.rx.ste_type = MLX5DR_STE_TYPE_RX;
-		dmn->info.tx.ste_type = MLX5DR_STE_TYPE_TX;
+		dmn->info.rx.type = DR_DOMAIN_NIC_TYPE_RX;
+		dmn->info.tx.type = DR_DOMAIN_NIC_TYPE_TX;
 		vport_cap = mlx5dr_get_vport_cap(&dmn->info.caps, 0);
 		if (!vport_cap) {
 			mlx5dr_err(dmn, "Failed to get esw manager vport\n");
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index f0d9f941acfd..b5409cc021d3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -403,7 +403,7 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 	int ret, i;
 
 	sb = nic_matcher->ste_builder_arr[outer_ipv][inner_ipv];
-	rx = nic_dmn->ste_type == MLX5DR_STE_TYPE_RX;
+	rx = nic_dmn->type == DR_DOMAIN_NIC_TYPE_RX;
 
 	/* Create a temporary mask to track and clear used mask fields */
 	if (matcher->match_criteria & DR_MATCHER_CRITERIA_OUTER)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index 43356fad53de..72c75d8e6bbf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -404,7 +404,7 @@ dr_rule_rehash_htbl(struct mlx5dr_rule *rule,
 	info.miss_icm_addr = nic_matcher->e_anchor->chunk->icm_addr;
 	mlx5dr_ste_set_formatted_ste(dmn->ste_ctx,
 				     dmn->info.caps.gvmi,
-				     nic_dmn,
+				     nic_dmn->type,
 				     new_htbl,
 				     formatted_ste,
 				     &info);
@@ -1015,12 +1015,12 @@ static enum mlx5dr_ipv dr_rule_get_ipv(struct mlx5dr_match_spec *spec)
 }
 
 static bool dr_rule_skip(enum mlx5dr_domain_type domain,
-			 enum mlx5dr_ste_entry_type ste_type,
+			 enum mlx5dr_domain_nic_type nic_type,
 			 struct mlx5dr_match_param *mask,
 			 struct mlx5dr_match_param *value,
 			 u32 flow_source)
 {
-	bool rx = ste_type == MLX5DR_STE_TYPE_RX;
+	bool rx = nic_type == DR_DOMAIN_NIC_TYPE_RX;
 
 	if (domain != MLX5DR_DOMAIN_TYPE_FDB)
 		return false;
@@ -1067,7 +1067,7 @@ dr_rule_create_rule_nic(struct mlx5dr_rule *rule,
 
 	INIT_LIST_HEAD(&nic_rule->rule_members_list);
 
-	if (dr_rule_skip(dmn->type, nic_dmn->ste_type, &matcher->mask, param,
+	if (dr_rule_skip(dmn->type, nic_dmn->type, &matcher->mask, param,
 			 rule->flow_source))
 		return 0;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 9b1529137cba..6ea314ff05ec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -382,14 +382,15 @@ void mlx5dr_ste_prepare_for_postsend(struct mlx5dr_ste_ctx *ste_ctx,
 /* Init one ste as a pattern for ste data array */
 void mlx5dr_ste_set_formatted_ste(struct mlx5dr_ste_ctx *ste_ctx,
 				  u16 gvmi,
-				  struct mlx5dr_domain_rx_tx *nic_dmn,
+				  enum mlx5dr_domain_nic_type nic_type,
 				  struct mlx5dr_ste_htbl *htbl,
 				  u8 *formatted_ste,
 				  struct mlx5dr_htbl_connect_info *connect_info)
 {
+	bool is_rx = nic_type == DR_DOMAIN_NIC_TYPE_RX;
 	struct mlx5dr_ste ste = {};
 
-	ste_ctx->ste_init(formatted_ste, htbl->lu_type, nic_dmn->ste_type, gvmi);
+	ste_ctx->ste_init(formatted_ste, htbl->lu_type, is_rx, gvmi);
 	ste.hw_ste = formatted_ste;
 
 	if (connect_info->type == CONNECT_HIT)
@@ -408,7 +409,7 @@ int mlx5dr_ste_htbl_init_and_postsend(struct mlx5dr_domain *dmn,
 
 	mlx5dr_ste_set_formatted_ste(dmn->ste_ctx,
 				     dmn->info.caps.gvmi,
-				     nic_dmn,
+				     nic_dmn->type,
 				     htbl,
 				     formatted_ste,
 				     connect_info);
@@ -649,6 +650,7 @@ int mlx5dr_ste_build_ste_arr(struct mlx5dr_matcher *matcher,
 			     u8 *ste_arr)
 {
 	struct mlx5dr_domain_rx_tx *nic_dmn = nic_matcher->nic_tbl->nic_dmn;
+	bool is_rx = nic_dmn->type == DR_DOMAIN_NIC_TYPE_RX;
 	struct mlx5dr_domain *dmn = matcher->tbl->dmn;
 	struct mlx5dr_ste_ctx *ste_ctx = dmn->ste_ctx;
 	struct mlx5dr_ste_build *sb;
@@ -663,7 +665,7 @@ int mlx5dr_ste_build_ste_arr(struct mlx5dr_matcher *matcher,
 	for (i = 0; i < nic_matcher->num_of_builders; i++) {
 		ste_ctx->ste_init(ste_arr,
 				  sb->lu_type,
-				  nic_dmn->ste_type,
+				  is_rx,
 				  dmn->info.caps.gvmi);
 
 		mlx5dr_ste_set_bit_mask(ste_arr, sb->bit_mask);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
index 12a8bbbf944b..2d52d065dc8b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
@@ -146,7 +146,7 @@ struct mlx5dr_ste_ctx {
 
 	/* Getters and Setters */
 	void (*ste_init)(u8 *hw_ste_p, u16 lu_type,
-			 u8 entry_type, u16 gvmi);
+			 bool is_rx, u16 gvmi);
 	void (*set_next_lu_type)(u8 *hw_ste_p, u16 lu_type);
 	u16  (*get_next_lu_type)(u8 *hw_ste_p);
 	void (*set_miss_addr)(u8 *hw_ste_p, u64 miss_addr);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
index bef90d2c56ae..9c704bce3c12 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
@@ -8,6 +8,12 @@
 #define SVLAN_ETHERTYPE		0x88a8
 #define DR_STE_ENABLE_FLOW_TAG	BIT(31)
 
+enum dr_ste_v0_entry_type {
+	DR_STE_TYPE_TX          = 1,
+	DR_STE_TYPE_RX          = 2,
+	DR_STE_TYPE_MODIFY_PKT  = 6,
+};
+
 enum dr_ste_v0_action_tunl {
 	DR_STE_TUNL_ACTION_NONE		= 0,
 	DR_STE_TUNL_ACTION_ENABLE	= 1,
@@ -292,8 +298,8 @@ static void dr_ste_v0_set_hit_addr(u8 *hw_ste_p, u64 icm_addr, u32 ht_size)
 	MLX5_SET(ste_general, hw_ste_p, next_table_base_31_5_size, index);
 }
 
-static void dr_ste_v0_init(u8 *hw_ste_p, u16 lu_type,
-			   u8 entry_type, u16 gvmi)
+static void dr_ste_v0_init_full(u8 *hw_ste_p, u16 lu_type,
+				enum dr_ste_v0_entry_type entry_type, u16 gvmi)
 {
 	dr_ste_v0_set_entry_type(hw_ste_p, entry_type);
 	dr_ste_v0_set_lu_type(hw_ste_p, lu_type);
@@ -307,6 +313,15 @@ static void dr_ste_v0_init(u8 *hw_ste_p, u16 lu_type,
 	MLX5_SET(ste_rx_steering_mult, hw_ste_p, miss_address_63_48, gvmi);
 }
 
+static void dr_ste_v0_init(u8 *hw_ste_p, u16 lu_type,
+			   bool is_rx, u16 gvmi)
+{
+	enum dr_ste_v0_entry_type entry_type;
+
+	entry_type = is_rx ? DR_STE_TYPE_RX : DR_STE_TYPE_TX;
+	dr_ste_v0_init_full(hw_ste_p, lu_type, entry_type, gvmi);
+}
+
 static void dr_ste_v0_rx_set_flow_tag(u8 *hw_ste_p, u32 flow_tag)
 {
 	MLX5_SET(ste_rx_steering_mult, hw_ste_p, qp_list_pointer,
@@ -380,13 +395,13 @@ static void dr_ste_v0_set_rewrite_actions(u8 *hw_ste_p, u16 num_of_actions,
 
 static void dr_ste_v0_arr_init_next(u8 **last_ste,
 				    u32 *added_stes,
-				    enum mlx5dr_ste_entry_type entry_type,
+				    enum dr_ste_v0_entry_type entry_type,
 				    u16 gvmi)
 {
 	(*added_stes)++;
 	*last_ste += DR_STE_SIZE;
-	dr_ste_v0_init(*last_ste, MLX5DR_STE_LU_TYPE_DONT_CARE,
-		       entry_type, gvmi);
+	dr_ste_v0_init_full(*last_ste, MLX5DR_STE_LU_TYPE_DONT_CARE,
+			    entry_type, gvmi);
 }
 
 static void
@@ -404,7 +419,7 @@ dr_ste_v0_set_actions_tx(struct mlx5dr_domain *dmn,
 	 * modify headers for outer headers only
 	 */
 	if (action_type_set[DR_ACTION_TYP_MODIFY_HDR]) {
-		dr_ste_v0_set_entry_type(last_ste, MLX5DR_STE_TYPE_MODIFY_PKT);
+		dr_ste_v0_set_entry_type(last_ste, DR_STE_TYPE_MODIFY_PKT);
 		dr_ste_v0_set_rewrite_actions(last_ste,
 					      attr->modify_actions,
 					      attr->modify_index);
@@ -417,7 +432,7 @@ dr_ste_v0_set_actions_tx(struct mlx5dr_domain *dmn,
 			if (i || action_type_set[DR_ACTION_TYP_MODIFY_HDR])
 				dr_ste_v0_arr_init_next(&last_ste,
 							added_stes,
-							MLX5DR_STE_TYPE_TX,
+							DR_STE_TYPE_TX,
 							attr->gvmi);
 
 			dr_ste_v0_set_tx_push_vlan(last_ste,
@@ -435,7 +450,7 @@ dr_ste_v0_set_actions_tx(struct mlx5dr_domain *dmn,
 		    action_type_set[DR_ACTION_TYP_PUSH_VLAN])
 			dr_ste_v0_arr_init_next(&last_ste,
 						added_stes,
-						MLX5DR_STE_TYPE_TX,
+						DR_STE_TYPE_TX,
 						attr->gvmi);
 
 		dr_ste_v0_set_tx_encap(last_ste,
@@ -469,7 +484,7 @@ dr_ste_v0_set_actions_rx(struct mlx5dr_domain *dmn,
 		dr_ste_v0_set_counter_id(last_ste, attr->ctr_id);
 
 	if (action_type_set[DR_ACTION_TYP_TNL_L3_TO_L2]) {
-		dr_ste_v0_set_entry_type(last_ste, MLX5DR_STE_TYPE_MODIFY_PKT);
+		dr_ste_v0_set_entry_type(last_ste, DR_STE_TYPE_MODIFY_PKT);
 		dr_ste_v0_set_rx_decap_l3(last_ste, attr->decap_with_vlan);
 		dr_ste_v0_set_rewrite_actions(last_ste,
 					      attr->decap_actions,
@@ -488,7 +503,7 @@ dr_ste_v0_set_actions_rx(struct mlx5dr_domain *dmn,
 			    action_type_set[DR_ACTION_TYP_TNL_L3_TO_L2])
 				dr_ste_v0_arr_init_next(&last_ste,
 							added_stes,
-							MLX5DR_STE_TYPE_RX,
+							DR_STE_TYPE_RX,
 							attr->gvmi);
 
 			dr_ste_v0_set_rx_pop_vlan(last_ste);
@@ -496,13 +511,13 @@ dr_ste_v0_set_actions_rx(struct mlx5dr_domain *dmn,
 	}
 
 	if (action_type_set[DR_ACTION_TYP_MODIFY_HDR]) {
-		if (dr_ste_v0_get_entry_type(last_ste) == MLX5DR_STE_TYPE_MODIFY_PKT)
+		if (dr_ste_v0_get_entry_type(last_ste) == DR_STE_TYPE_MODIFY_PKT)
 			dr_ste_v0_arr_init_next(&last_ste,
 						added_stes,
-						MLX5DR_STE_TYPE_MODIFY_PKT,
+						DR_STE_TYPE_MODIFY_PKT,
 						attr->gvmi);
 		else
-			dr_ste_v0_set_entry_type(last_ste, MLX5DR_STE_TYPE_MODIFY_PKT);
+			dr_ste_v0_set_entry_type(last_ste, DR_STE_TYPE_MODIFY_PKT);
 
 		dr_ste_v0_set_rewrite_actions(last_ste,
 					      attr->modify_actions,
@@ -510,10 +525,10 @@ dr_ste_v0_set_actions_rx(struct mlx5dr_domain *dmn,
 	}
 
 	if (action_type_set[DR_ACTION_TYP_TAG]) {
-		if (dr_ste_v0_get_entry_type(last_ste) == MLX5DR_STE_TYPE_MODIFY_PKT)
+		if (dr_ste_v0_get_entry_type(last_ste) == DR_STE_TYPE_MODIFY_PKT)
 			dr_ste_v0_arr_init_next(&last_ste,
 						added_stes,
-						MLX5DR_STE_TYPE_RX,
+						DR_STE_TYPE_RX,
 						attr->gvmi);
 
 		dr_ste_v0_rx_set_flow_tag(last_ste, attr->flow_tag);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index 0e1a70596fd2..b2481c99da79 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -322,7 +322,7 @@ static void dr_ste_v1_set_hit_addr(u8 *hw_ste_p, u64 icm_addr, u32 ht_size)
 }
 
 static void dr_ste_v1_init(u8 *hw_ste_p, u16 lu_type,
-			   u8 entry_type, u16 gvmi)
+			   bool is_rx, u16 gvmi)
 {
 	dr_ste_v1_set_lu_type(hw_ste_p, lu_type);
 	dr_ste_v1_set_next_lu_type(hw_ste_p, MLX5DR_STE_LU_TYPE_DONT_CARE);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index dd4712d980ea..caff9fc4b8ca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -804,10 +804,15 @@ struct mlx5dr_cmd_caps {
 	u8 isolate_vl_tc:1;
 };
 
+enum mlx5dr_domain_nic_type {
+	DR_DOMAIN_NIC_TYPE_RX,
+	DR_DOMAIN_NIC_TYPE_TX,
+};
+
 struct mlx5dr_domain_rx_tx {
 	u64 drop_icm_addr;
 	u64 default_icm_addr;
-	enum mlx5dr_ste_entry_type ste_type;
+	enum mlx5dr_domain_nic_type type;
 	struct mutex mutex; /* protect rx/tx domain */
 };
 
@@ -1216,7 +1221,7 @@ int mlx5dr_ste_htbl_init_and_postsend(struct mlx5dr_domain *dmn,
 				      bool update_hw_ste);
 void mlx5dr_ste_set_formatted_ste(struct mlx5dr_ste_ctx *ste_ctx,
 				  u16 gvmi,
-				  struct mlx5dr_domain_rx_tx *nic_dmn,
+				  enum mlx5dr_domain_nic_type nic_type,
 				  struct mlx5dr_ste_htbl *htbl,
 				  u8 *formatted_ste,
 				  struct mlx5dr_htbl_connect_info *connect_info);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h
index 9643ee647f57..d2a937f69784 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h
@@ -8,12 +8,6 @@ enum {
 	MLX5DR_STE_LU_TYPE_DONT_CARE			= 0x0f,
 };
 
-enum mlx5dr_ste_entry_type {
-	MLX5DR_STE_TYPE_TX		= 1,
-	MLX5DR_STE_TYPE_RX		= 2,
-	MLX5DR_STE_TYPE_MODIFY_PKT	= 6,
-};
-
 struct mlx5_ifc_ste_general_bits {
 	u8         entry_type[0x4];
 	u8         reserved_at_4[0x4];
-- 
2.31.1

