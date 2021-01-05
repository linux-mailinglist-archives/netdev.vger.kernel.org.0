Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6A02EB5DA
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 00:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727934AbhAEXGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 18:06:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:57456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727432AbhAEXG2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 18:06:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BB7D23103;
        Tue,  5 Jan 2021 23:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609887913;
        bh=VV8/u/eEGm78cfMR+6OFz5D4XImaLekm6C+bet5wnhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RUCJ3S4aQImuu8IJHywmyFtVsm2FjBkPdtqwVu4wDpKn56f5yMcOImIaFn6EGSKYv
         mMssEVe7/fSPsySxYz2oXYO52W9SjBR2DSgWPMZViqvsya7c+7vk4PWlqBYPTD0IZi
         i6E33z1UiTLAiLE+rMX2DkqXckg0meBAp2rqTcVkP7kVpBSJ3fLPsVYSqCoy2taAMo
         kC2n/wrh6SOEMdYJ/cxQoDL/Mg5i+2powHUjwVCQVr0W/EsAIGYAmB9yOJa0csdCP8
         +TS2jaxF2CbRkX+BzAWVRjD2kD4N3F0J3KidzDGJNGx4oYvriiOSAJbsN7iKJW59r1
         +jO9sNsE0peeA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/16] net/mlx5: DR, Move action apply logic to dr_ste
Date:   Tue,  5 Jan 2021 15:03:27 -0800
Message-Id: <20210105230333.239456-11-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210105230333.239456-1-saeed@kernel.org>
References: <20210105230333.239456-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

The action apply logic is device specific per STE version,
moving to the STE layer will allow implementing it for
both devices while keeping DR upper layers the same.

Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_action.c   | 177 +------------
 .../mellanox/mlx5/core/steering/dr_ste.c      | 236 ++++++++++++++----
 .../mellanox/mlx5/core/steering/dr_types.h    |  52 ++--
 3 files changed, 231 insertions(+), 234 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index df1363a34a42..60f504d693ff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -348,28 +348,6 @@ static const struct dr_action_modify_field_conv dr_action_conv_arr[] = {
 	},
 };
 
-#define MAX_VLANS 2
-struct dr_action_vlan_info {
-	int	count;
-	u32	headers[MAX_VLANS];
-};
-
-struct dr_action_apply_attr {
-	u32	modify_index;
-	u16	modify_actions;
-	u32	decap_index;
-	u16	decap_actions;
-	u8	decap_with_vlan:1;
-	u64	final_icm_addr;
-	u32	flow_tag;
-	u32	ctr_id;
-	u16	gvmi;
-	u16	hit_gvmi;
-	u32	reformat_id;
-	u32	reformat_size;
-	struct	dr_action_vlan_info vlans;
-};
-
 static int
 dr_action_reformat_to_action_type(enum mlx5dr_action_reformat_type reformat_type,
 				  enum mlx5dr_action_type *action_type)
@@ -394,141 +372,6 @@ dr_action_reformat_to_action_type(enum mlx5dr_action_reformat_type reformat_type
 	return 0;
 }
 
-static void dr_actions_init_next_ste(u8 **last_ste,
-				     u32 *added_stes,
-				     enum mlx5dr_ste_entry_type entry_type,
-				     u16 gvmi)
-{
-	(*added_stes)++;
-	*last_ste += DR_STE_SIZE;
-	mlx5dr_ste_init(*last_ste, MLX5DR_STE_LU_TYPE_DONT_CARE, entry_type, gvmi);
-}
-
-static void dr_actions_apply_tx(struct mlx5dr_domain *dmn,
-				u8 *action_type_set,
-				u8 *last_ste,
-				struct dr_action_apply_attr *attr,
-				u32 *added_stes)
-{
-	bool encap = action_type_set[DR_ACTION_TYP_L2_TO_TNL_L2] ||
-		action_type_set[DR_ACTION_TYP_L2_TO_TNL_L3];
-
-	/* We want to make sure the modify header comes before L2
-	 * encapsulation. The reason for that is that we support
-	 * modify headers for outer headers only
-	 */
-	if (action_type_set[DR_ACTION_TYP_MODIFY_HDR]) {
-		mlx5dr_ste_set_entry_type(last_ste, MLX5DR_STE_TYPE_MODIFY_PKT);
-		mlx5dr_ste_set_rewrite_actions(last_ste,
-					       attr->modify_actions,
-					       attr->modify_index);
-	}
-
-	if (action_type_set[DR_ACTION_TYP_PUSH_VLAN]) {
-		int i;
-
-		for (i = 0; i < attr->vlans.count; i++) {
-			if (i || action_type_set[DR_ACTION_TYP_MODIFY_HDR])
-				dr_actions_init_next_ste(&last_ste,
-							 added_stes,
-							 MLX5DR_STE_TYPE_TX,
-							 attr->gvmi);
-
-			mlx5dr_ste_set_tx_push_vlan(last_ste,
-						    attr->vlans.headers[i],
-						    encap);
-		}
-	}
-
-	if (encap) {
-		/* Modify header and encapsulation require a different STEs.
-		 * Since modify header STE format doesn't support encapsulation
-		 * tunneling_action.
-		 */
-		if (action_type_set[DR_ACTION_TYP_MODIFY_HDR] ||
-		    action_type_set[DR_ACTION_TYP_PUSH_VLAN])
-			dr_actions_init_next_ste(&last_ste,
-						 added_stes,
-						 MLX5DR_STE_TYPE_TX,
-						 attr->gvmi);
-
-		mlx5dr_ste_set_tx_encap(last_ste,
-					attr->reformat_id,
-					attr->reformat_size,
-					action_type_set[DR_ACTION_TYP_L2_TO_TNL_L3]);
-		/* Whenever prio_tag_required enabled, we can be sure that the
-		 * previous table (ACL) already push vlan to our packet,
-		 * And due to HW limitation we need to set this bit, otherwise
-		 * push vlan + reformat will not work.
-		 */
-		if (MLX5_CAP_GEN(dmn->mdev, prio_tag_required))
-			mlx5dr_ste_set_go_back_bit(last_ste);
-	}
-
-	if (action_type_set[DR_ACTION_TYP_CTR])
-		mlx5dr_ste_set_counter_id(last_ste, attr->ctr_id);
-}
-
-static void dr_actions_apply_rx(u8 *action_type_set,
-				u8 *last_ste,
-				struct dr_action_apply_attr *attr,
-				u32 *added_stes)
-{
-	if (action_type_set[DR_ACTION_TYP_CTR])
-		mlx5dr_ste_set_counter_id(last_ste, attr->ctr_id);
-
-	if (action_type_set[DR_ACTION_TYP_TNL_L3_TO_L2]) {
-		mlx5dr_ste_set_entry_type(last_ste, MLX5DR_STE_TYPE_MODIFY_PKT);
-		mlx5dr_ste_set_rx_decap_l3(last_ste, attr->decap_with_vlan);
-		mlx5dr_ste_set_rewrite_actions(last_ste,
-					       attr->decap_actions,
-					       attr->decap_index);
-	}
-
-	if (action_type_set[DR_ACTION_TYP_TNL_L2_TO_L2])
-		mlx5dr_ste_set_rx_decap(last_ste);
-
-	if (action_type_set[DR_ACTION_TYP_POP_VLAN]) {
-		int i;
-
-		for (i = 0; i < attr->vlans.count; i++) {
-			if (i ||
-			    action_type_set[DR_ACTION_TYP_TNL_L2_TO_L2] ||
-			    action_type_set[DR_ACTION_TYP_TNL_L3_TO_L2])
-				dr_actions_init_next_ste(&last_ste,
-							 added_stes,
-							 MLX5DR_STE_TYPE_RX,
-							 attr->gvmi);
-
-			mlx5dr_ste_set_rx_pop_vlan(last_ste);
-		}
-	}
-
-	if (action_type_set[DR_ACTION_TYP_MODIFY_HDR]) {
-		if (mlx5dr_ste_get_entry_type(last_ste) == MLX5DR_STE_TYPE_MODIFY_PKT)
-			dr_actions_init_next_ste(&last_ste,
-						 added_stes,
-						 MLX5DR_STE_TYPE_MODIFY_PKT,
-						 attr->gvmi);
-		else
-			mlx5dr_ste_set_entry_type(last_ste, MLX5DR_STE_TYPE_MODIFY_PKT);
-
-		mlx5dr_ste_set_rewrite_actions(last_ste,
-					       attr->modify_actions,
-					       attr->modify_index);
-	}
-
-	if (action_type_set[DR_ACTION_TYP_TAG]) {
-		if (mlx5dr_ste_get_entry_type(last_ste) == MLX5DR_STE_TYPE_MODIFY_PKT)
-			dr_actions_init_next_ste(&last_ste,
-						 added_stes,
-						 MLX5DR_STE_TYPE_RX,
-						 attr->gvmi);
-
-		mlx5dr_ste_rx_set_flow_tag(last_ste, attr->flow_tag);
-	}
-}
-
 /* Apply the actions on the rule STE array starting from the last_ste.
  * Actions might require more than one STE, new_num_stes will return
  * the new size of the STEs array, rule with actions.
@@ -537,21 +380,19 @@ static void dr_actions_apply(struct mlx5dr_domain *dmn,
 			     enum mlx5dr_ste_entry_type ste_type,
 			     u8 *action_type_set,
 			     u8 *last_ste,
-			     struct dr_action_apply_attr *attr,
+			     struct mlx5dr_ste_actions_attr *attr,
 			     u32 *new_num_stes)
 {
 	u32 added_stes = 0;
 
 	if (ste_type == MLX5DR_STE_TYPE_RX)
-		dr_actions_apply_rx(action_type_set, last_ste, attr, &added_stes);
+		mlx5dr_ste_set_actions_rx(dmn, action_type_set,
+					  last_ste, attr, &added_stes);
 	else
-		dr_actions_apply_tx(dmn, action_type_set, last_ste, attr, &added_stes);
+		mlx5dr_ste_set_actions_tx(dmn, action_type_set,
+					  last_ste, attr, &added_stes);
 
-	last_ste += added_stes * DR_STE_SIZE;
 	*new_num_stes += added_stes;
-
-	mlx5dr_ste_set_hit_gvmi(last_ste, attr->hit_gvmi);
-	mlx5dr_ste_set_hit_addr(last_ste, attr->final_icm_addr, 1);
 }
 
 static enum dr_action_domain
@@ -643,9 +484,9 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 	bool rx_rule = nic_dmn->ste_type == MLX5DR_STE_TYPE_RX;
 	struct mlx5dr_domain *dmn = matcher->tbl->dmn;
 	u8 action_type_set[DR_ACTION_TYP_MAX] = {};
+	struct mlx5dr_ste_actions_attr attr = {};
 	struct mlx5dr_action *dest_action = NULL;
 	u32 state = DR_ACTION_STATE_NO_ACTION;
-	struct dr_action_apply_attr attr = {};
 	enum dr_action_domain action_domain;
 	bool recalc_cs_required = false;
 	u8 *last_ste;
@@ -756,12 +597,12 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 			}
 			break;
 		case DR_ACTION_TYP_POP_VLAN:
-			max_actions_type = MAX_VLANS;
+			max_actions_type = MLX5DR_MAX_VLANS;
 			attr.vlans.count++;
 			break;
 		case DR_ACTION_TYP_PUSH_VLAN:
-			max_actions_type = MAX_VLANS;
-			if (attr.vlans.count == MAX_VLANS)
+			max_actions_type = MLX5DR_MAX_VLANS;
+			if (attr.vlans.count == MLX5DR_MAX_VLANS)
 				return -EINVAL;
 
 			attr.vlans.headers[attr.vlans.count++] = action->push_vlan.vlan_hdr;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index d3e6e1d9a90b..18d044e092ce 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -74,7 +74,7 @@ u16 mlx5dr_ste_conv_bit_to_byte_mask(u8 *bit_mask)
 	return byte_mask;
 }
 
-static u8 *mlx5dr_ste_get_tag(u8 *hw_ste_p)
+static u8 *dr_ste_get_tag(u8 *hw_ste_p)
 {
 	struct dr_hw_ste_format *hw_ste = (struct dr_hw_ste_format *)hw_ste_p;
 
@@ -88,26 +88,26 @@ void mlx5dr_ste_set_bit_mask(u8 *hw_ste_p, u8 *bit_mask)
 	memcpy(hw_ste->mask, bit_mask, DR_STE_SIZE_MASK);
 }
 
-void mlx5dr_ste_rx_set_flow_tag(u8 *hw_ste_p, u32 flow_tag)
+static void dr_ste_rx_set_flow_tag(u8 *hw_ste_p, u32 flow_tag)
 {
 	MLX5_SET(ste_rx_steering_mult, hw_ste_p, qp_list_pointer,
 		 DR_STE_ENABLE_FLOW_TAG | flow_tag);
 }
 
-void mlx5dr_ste_set_counter_id(u8 *hw_ste_p, u32 ctr_id)
+static void dr_ste_set_counter_id(u8 *hw_ste_p, u32 ctr_id)
 {
 	/* This can be used for both rx_steering_mult and for sx_transmit */
 	MLX5_SET(ste_rx_steering_mult, hw_ste_p, counter_trigger_15_0, ctr_id);
 	MLX5_SET(ste_rx_steering_mult, hw_ste_p, counter_trigger_23_16, ctr_id >> 16);
 }
 
-void mlx5dr_ste_set_go_back_bit(u8 *hw_ste_p)
+static void dr_ste_set_go_back_bit(u8 *hw_ste_p)
 {
 	MLX5_SET(ste_sx_transmit, hw_ste_p, go_back, 1);
 }
 
-void mlx5dr_ste_set_tx_push_vlan(u8 *hw_ste_p, u32 vlan_hdr,
-				 bool go_back)
+static void dr_ste_set_tx_push_vlan(u8 *hw_ste_p, u32 vlan_hdr,
+				    bool go_back)
 {
 	MLX5_SET(ste_sx_transmit, hw_ste_p, action_type,
 		 DR_STE_ACTION_TYPE_PUSH_VLAN);
@@ -116,10 +116,11 @@ void mlx5dr_ste_set_tx_push_vlan(u8 *hw_ste_p, u32 vlan_hdr,
 	 * push vlan will not work.
 	 */
 	if (go_back)
-		mlx5dr_ste_set_go_back_bit(hw_ste_p);
+		dr_ste_set_go_back_bit(hw_ste_p);
 }
 
-void mlx5dr_ste_set_tx_encap(void *hw_ste_p, u32 reformat_id, int size, bool encap_l3)
+static void dr_ste_set_tx_encap(void *hw_ste_p, u32 reformat_id,
+				int size, bool encap_l3)
 {
 	MLX5_SET(ste_sx_transmit, hw_ste_p, action_type,
 		 encap_l3 ? DR_STE_ACTION_TYPE_ENCAP_L3 : DR_STE_ACTION_TYPE_ENCAP);
@@ -128,37 +129,37 @@ void mlx5dr_ste_set_tx_encap(void *hw_ste_p, u32 reformat_id, int size, bool enc
 	MLX5_SET(ste_sx_transmit, hw_ste_p, encap_pointer_vlan_data, reformat_id);
 }
 
-void mlx5dr_ste_set_rx_decap(u8 *hw_ste_p)
+static void dr_ste_set_rx_decap(u8 *hw_ste_p)
 {
 	MLX5_SET(ste_rx_steering_mult, hw_ste_p, tunneling_action,
 		 DR_STE_TUNL_ACTION_DECAP);
 }
 
-void mlx5dr_ste_set_rx_pop_vlan(u8 *hw_ste_p)
+static void dr_ste_set_rx_pop_vlan(u8 *hw_ste_p)
 {
 	MLX5_SET(ste_rx_steering_mult, hw_ste_p, tunneling_action,
 		 DR_STE_TUNL_ACTION_POP_VLAN);
 }
 
-void mlx5dr_ste_set_rx_decap_l3(u8 *hw_ste_p, bool vlan)
+static void dr_ste_set_rx_decap_l3(u8 *hw_ste_p, bool vlan)
 {
 	MLX5_SET(ste_rx_steering_mult, hw_ste_p, tunneling_action,
 		 DR_STE_TUNL_ACTION_L3_DECAP);
 	MLX5_SET(ste_modify_packet, hw_ste_p, action_description, vlan ? 1 : 0);
 }
 
-void mlx5dr_ste_set_entry_type(u8 *hw_ste_p, u8 entry_type)
+static void dr_ste_set_entry_type(u8 *hw_ste_p, u8 entry_type)
 {
 	MLX5_SET(ste_general, hw_ste_p, entry_type, entry_type);
 }
 
-u8 mlx5dr_ste_get_entry_type(u8 *hw_ste_p)
+static u8 dr_ste_get_entry_type(u8 *hw_ste_p)
 {
 	return MLX5_GET(ste_general, hw_ste_p, entry_type);
 }
 
-void mlx5dr_ste_set_rewrite_actions(u8 *hw_ste_p, u16 num_of_actions,
-				    u32 re_write_index)
+static void dr_ste_set_rewrite_actions(u8 *hw_ste_p, u16 num_of_actions,
+				       u32 re_write_index)
 {
 	MLX5_SET(ste_modify_packet, hw_ste_p, number_of_re_write_actions,
 		 num_of_actions);
@@ -166,13 +167,13 @@ void mlx5dr_ste_set_rewrite_actions(u8 *hw_ste_p, u16 num_of_actions,
 		 re_write_index);
 }
 
-void mlx5dr_ste_set_hit_gvmi(u8 *hw_ste_p, u16 gvmi)
+static void dr_ste_set_hit_gvmi(u8 *hw_ste_p, u16 gvmi)
 {
 	MLX5_SET(ste_general, hw_ste_p, next_table_base_63_48, gvmi);
 }
 
-void mlx5dr_ste_init(u8 *hw_ste_p, u16 lu_type, u8 entry_type,
-		     u16 gvmi)
+static void dr_ste_init(u8 *hw_ste_p, u16 lu_type, u8 entry_type,
+			u16 gvmi)
 {
 	MLX5_SET(ste_general, hw_ste_p, entry_type, entry_type);
 	MLX5_SET(ste_general, hw_ste_p, entry_sub_type, lu_type);
@@ -198,7 +199,16 @@ static void dr_ste_set_always_miss(struct dr_hw_ste_format *hw_ste)
 	hw_ste->mask[0] = 0;
 }
 
-u64 mlx5dr_ste_get_miss_addr(u8 *hw_ste)
+void mlx5dr_ste_set_miss_addr(u8 *hw_ste_p, u64 miss_addr)
+{
+	u64 index = miss_addr >> 6;
+
+	/* Miss address for TX and RX STEs located in the same offsets */
+	MLX5_SET(ste_rx_steering_mult, hw_ste_p, miss_address_39_32, index >> 26);
+	MLX5_SET(ste_rx_steering_mult, hw_ste_p, miss_address_31_6, index);
+}
+
+static u64 dr_ste_get_miss_addr(u8 *hw_ste)
 {
 	u64 index =
 		(MLX5_GET(ste_rx_steering_mult, hw_ste, miss_address_31_6) |
@@ -207,6 +217,16 @@ u64 mlx5dr_ste_get_miss_addr(u8 *hw_ste)
 	return index << 6;
 }
 
+static void dr_ste_always_miss_addr(struct mlx5dr_ste *ste, u64 miss_addr)
+{
+	u8 *hw_ste_p = ste->hw_ste;
+
+	MLX5_SET(ste_rx_steering_mult, hw_ste_p, next_lu_type,
+		 MLX5DR_STE_LU_TYPE_DONT_CARE);
+	mlx5dr_ste_set_miss_addr(hw_ste_p, miss_addr);
+	dr_ste_set_always_miss((struct dr_hw_ste_format *)ste->hw_ste);
+}
+
 void mlx5dr_ste_set_hit_addr(u8 *hw_ste, u64 icm_addr, u32 ht_size)
 {
 	u64 index = (icm_addr >> 5) | ht_size;
@@ -299,7 +319,7 @@ dr_ste_remove_head_ste(struct mlx5dr_ste *ste,
 	 */
 	memcpy(tmp_ste.hw_ste, ste->hw_ste, DR_STE_SIZE_REDUCED);
 	miss_addr = nic_matcher->e_anchor->chunk->icm_addr;
-	mlx5dr_ste_always_miss_addr(&tmp_ste, miss_addr);
+	dr_ste_always_miss_addr(&tmp_ste, miss_addr);
 	memcpy(ste->hw_ste, tmp_ste.hw_ste, DR_STE_SIZE_REDUCED);
 
 	list_del_init(&ste->miss_list_node);
@@ -367,7 +387,7 @@ static void dr_ste_remove_middle_ste(struct mlx5dr_ste *ste,
 	if (WARN_ON(!prev_ste))
 		return;
 
-	miss_addr = mlx5dr_ste_get_miss_addr(ste->hw_ste);
+	miss_addr = dr_ste_get_miss_addr(ste->hw_ste);
 	mlx5dr_ste_set_miss_addr(prev_ste->hw_ste, miss_addr);
 
 	mlx5dr_send_fill_and_append_ste_send_info(prev_ste, DR_STE_SIZE_REDUCED, 0,
@@ -457,24 +477,6 @@ void mlx5dr_ste_set_hit_addr_by_next_htbl(u8 *hw_ste,
 	mlx5dr_ste_set_hit_addr(hw_ste, chunk->icm_addr, chunk->num_of_entries);
 }
 
-void mlx5dr_ste_set_miss_addr(u8 *hw_ste_p, u64 miss_addr)
-{
-	u64 index = miss_addr >> 6;
-
-	/* Miss address for TX and RX STEs located in the same offsets */
-	MLX5_SET(ste_rx_steering_mult, hw_ste_p, miss_address_39_32, index >> 26);
-	MLX5_SET(ste_rx_steering_mult, hw_ste_p, miss_address_31_6, index);
-}
-
-void mlx5dr_ste_always_miss_addr(struct mlx5dr_ste *ste, u64 miss_addr)
-{
-	u8 *hw_ste = ste->hw_ste;
-
-	MLX5_SET(ste_rx_steering_mult, hw_ste, next_lu_type, MLX5DR_STE_LU_TYPE_DONT_CARE);
-	mlx5dr_ste_set_miss_addr(hw_ste, miss_addr);
-	dr_ste_set_always_miss((struct dr_hw_ste_format *)ste->hw_ste);
-}
-
 /* Init one ste as a pattern for ste data array */
 void mlx5dr_ste_set_formatted_ste(u16 gvmi,
 				  struct mlx5dr_domain_rx_tx *nic_dmn,
@@ -484,13 +486,13 @@ void mlx5dr_ste_set_formatted_ste(u16 gvmi,
 {
 	struct mlx5dr_ste ste = {};
 
-	mlx5dr_ste_init(formatted_ste, htbl->lu_type, nic_dmn->ste_type, gvmi);
+	dr_ste_init(formatted_ste, htbl->lu_type, nic_dmn->ste_type, gvmi);
 	ste.hw_ste = formatted_ste;
 
 	if (connect_info->type == CONNECT_HIT)
 		dr_ste_always_hit_htbl(&ste, connect_info->hit_next_htbl);
 	else
-		mlx5dr_ste_always_miss_addr(&ste, connect_info->miss_icm_addr);
+		dr_ste_always_miss_addr(&ste, connect_info->miss_icm_addr);
 }
 
 int mlx5dr_ste_htbl_init_and_postsend(struct mlx5dr_domain *dmn,
@@ -628,6 +630,148 @@ int mlx5dr_ste_htbl_free(struct mlx5dr_ste_htbl *htbl)
 	return 0;
 }
 
+static void dr_ste_arr_init_next_ste(u8 **last_ste,
+				     u32 *added_stes,
+				     enum mlx5dr_ste_entry_type entry_type,
+				     u16 gvmi)
+{
+	(*added_stes)++;
+	*last_ste += DR_STE_SIZE;
+	dr_ste_init(*last_ste, MLX5DR_STE_LU_TYPE_DONT_CARE, entry_type, gvmi);
+}
+
+void mlx5dr_ste_set_actions_tx(struct mlx5dr_domain *dmn,
+			       u8 *action_type_set,
+			       u8 *last_ste,
+			       struct mlx5dr_ste_actions_attr *attr,
+			       u32 *added_stes)
+{
+	bool encap = action_type_set[DR_ACTION_TYP_L2_TO_TNL_L2] ||
+		action_type_set[DR_ACTION_TYP_L2_TO_TNL_L3];
+
+	/* We want to make sure the modify header comes before L2
+	 * encapsulation. The reason for that is that we support
+	 * modify headers for outer headers only
+	 */
+	if (action_type_set[DR_ACTION_TYP_MODIFY_HDR]) {
+		dr_ste_set_entry_type(last_ste, MLX5DR_STE_TYPE_MODIFY_PKT);
+		dr_ste_set_rewrite_actions(last_ste,
+					   attr->modify_actions,
+					   attr->modify_index);
+	}
+
+	if (action_type_set[DR_ACTION_TYP_PUSH_VLAN]) {
+		int i;
+
+		for (i = 0; i < attr->vlans.count; i++) {
+			if (i || action_type_set[DR_ACTION_TYP_MODIFY_HDR])
+				dr_ste_arr_init_next_ste(&last_ste,
+							 added_stes,
+							 MLX5DR_STE_TYPE_TX,
+							 attr->gvmi);
+
+			dr_ste_set_tx_push_vlan(last_ste,
+						attr->vlans.headers[i],
+						encap);
+		}
+	}
+
+	if (encap) {
+		/* Modify header and encapsulation require a different STEs.
+		 * Since modify header STE format doesn't support encapsulation
+		 * tunneling_action.
+		 */
+		if (action_type_set[DR_ACTION_TYP_MODIFY_HDR] ||
+		    action_type_set[DR_ACTION_TYP_PUSH_VLAN])
+			dr_ste_arr_init_next_ste(&last_ste,
+						 added_stes,
+						 MLX5DR_STE_TYPE_TX,
+						 attr->gvmi);
+
+		dr_ste_set_tx_encap(last_ste,
+				    attr->reformat_id,
+				    attr->reformat_size,
+				    action_type_set[DR_ACTION_TYP_L2_TO_TNL_L3]);
+		/* Whenever prio_tag_required enabled, we can be sure that the
+		 * previous table (ACL) already push vlan to our packet,
+		 * And due to HW limitation we need to set this bit, otherwise
+		 * push vlan + reformat will not work.
+		 */
+		if (MLX5_CAP_GEN(dmn->mdev, prio_tag_required))
+			dr_ste_set_go_back_bit(last_ste);
+	}
+
+	if (action_type_set[DR_ACTION_TYP_CTR])
+		dr_ste_set_counter_id(last_ste, attr->ctr_id);
+
+	dr_ste_set_hit_gvmi(last_ste, attr->hit_gvmi);
+	mlx5dr_ste_set_hit_addr(last_ste, attr->final_icm_addr, 1);
+}
+
+void mlx5dr_ste_set_actions_rx(struct mlx5dr_domain *dmn,
+			       u8 *action_type_set,
+			       u8 *last_ste,
+			       struct mlx5dr_ste_actions_attr *attr,
+			       u32 *added_stes)
+{
+	if (action_type_set[DR_ACTION_TYP_CTR])
+		dr_ste_set_counter_id(last_ste, attr->ctr_id);
+
+	if (action_type_set[DR_ACTION_TYP_TNL_L3_TO_L2]) {
+		dr_ste_set_entry_type(last_ste, MLX5DR_STE_TYPE_MODIFY_PKT);
+		dr_ste_set_rx_decap_l3(last_ste, attr->decap_with_vlan);
+		dr_ste_set_rewrite_actions(last_ste,
+					   attr->decap_actions,
+					   attr->decap_index);
+	}
+
+	if (action_type_set[DR_ACTION_TYP_TNL_L2_TO_L2])
+		dr_ste_set_rx_decap(last_ste);
+
+	if (action_type_set[DR_ACTION_TYP_POP_VLAN]) {
+		int i;
+
+		for (i = 0; i < attr->vlans.count; i++) {
+			if (i ||
+			    action_type_set[DR_ACTION_TYP_TNL_L2_TO_L2] ||
+			    action_type_set[DR_ACTION_TYP_TNL_L3_TO_L2])
+				dr_ste_arr_init_next_ste(&last_ste,
+							 added_stes,
+							 MLX5DR_STE_TYPE_RX,
+							 attr->gvmi);
+
+			dr_ste_set_rx_pop_vlan(last_ste);
+		}
+	}
+
+	if (action_type_set[DR_ACTION_TYP_MODIFY_HDR]) {
+		if (dr_ste_get_entry_type(last_ste) == MLX5DR_STE_TYPE_MODIFY_PKT)
+			dr_ste_arr_init_next_ste(&last_ste,
+						 added_stes,
+						 MLX5DR_STE_TYPE_MODIFY_PKT,
+						 attr->gvmi);
+		else
+			dr_ste_set_entry_type(last_ste, MLX5DR_STE_TYPE_MODIFY_PKT);
+
+		dr_ste_set_rewrite_actions(last_ste,
+					   attr->modify_actions,
+					   attr->modify_index);
+	}
+
+	if (action_type_set[DR_ACTION_TYP_TAG]) {
+		if (dr_ste_get_entry_type(last_ste) == MLX5DR_STE_TYPE_MODIFY_PKT)
+			dr_ste_arr_init_next_ste(&last_ste,
+						 added_stes,
+						 MLX5DR_STE_TYPE_RX,
+						 attr->gvmi);
+
+		dr_ste_rx_set_flow_tag(last_ste, attr->flow_tag);
+	}
+
+	dr_ste_set_hit_gvmi(last_ste, attr->hit_gvmi);
+	mlx5dr_ste_set_hit_addr(last_ste, attr->final_icm_addr, 1);
+}
+
 int mlx5dr_ste_build_pre_check(struct mlx5dr_domain *dmn,
 			       u8 match_criteria,
 			       struct mlx5dr_match_param *mask,
@@ -667,14 +811,14 @@ int mlx5dr_ste_build_ste_arr(struct mlx5dr_matcher *matcher,
 
 	sb = nic_matcher->ste_builder;
 	for (i = 0; i < nic_matcher->num_of_builders; i++) {
-		mlx5dr_ste_init(ste_arr,
-				sb->lu_type,
-				nic_dmn->ste_type,
-				dmn->info.caps.gvmi);
+		dr_ste_init(ste_arr,
+			    sb->lu_type,
+			    nic_dmn->ste_type,
+			    dmn->info.caps.gvmi);
 
 		mlx5dr_ste_set_bit_mask(ste_arr, sb->bit_mask);
 
-		ret = sb->ste_build_tag_func(value, sb, mlx5dr_ste_get_tag(ste_arr));
+		ret = sb->ste_build_tag_func(value, sb, dr_ste_get_tag(ste_arr));
 		if (ret)
 			return ret;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 5bd82c358069..46812c209044 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -220,35 +220,47 @@ static inline void mlx5dr_htbl_get(struct mlx5dr_ste_htbl *htbl)
 
 /* STE utils */
 u32 mlx5dr_ste_calc_hash_index(u8 *hw_ste_p, struct mlx5dr_ste_htbl *htbl);
-void mlx5dr_ste_init(u8 *hw_ste_p, u16 lu_type, u8 entry_type, u16 gvmi);
-void mlx5dr_ste_always_hit_htbl(struct mlx5dr_ste *ste,
-				struct mlx5dr_ste_htbl *next_htbl);
 void mlx5dr_ste_set_miss_addr(u8 *hw_ste, u64 miss_addr);
-u64 mlx5dr_ste_get_miss_addr(u8 *hw_ste);
-void mlx5dr_ste_set_hit_gvmi(u8 *hw_ste_p, u16 gvmi);
 void mlx5dr_ste_set_hit_addr(u8 *hw_ste, u64 icm_addr, u32 ht_size);
-void mlx5dr_ste_always_miss_addr(struct mlx5dr_ste *ste, u64 miss_addr);
 void mlx5dr_ste_set_bit_mask(u8 *hw_ste_p, u8 *bit_mask);
 bool mlx5dr_ste_is_last_in_rule(struct mlx5dr_matcher_rx_tx *nic_matcher,
 				u8 ste_location);
-void mlx5dr_ste_rx_set_flow_tag(u8 *hw_ste_p, u32 flow_tag);
-void mlx5dr_ste_set_counter_id(u8 *hw_ste_p, u32 ctr_id);
-void mlx5dr_ste_set_tx_encap(void *hw_ste_p, u32 reformat_id,
-			     int size, bool encap_l3);
-void mlx5dr_ste_set_rx_decap(u8 *hw_ste_p);
-void mlx5dr_ste_set_rx_decap_l3(u8 *hw_ste_p, bool vlan);
-void mlx5dr_ste_set_rx_pop_vlan(u8 *hw_ste_p);
-void mlx5dr_ste_set_tx_push_vlan(u8 *hw_ste_p, u32 vlan_tpid_pcp_dei_vid,
-				 bool go_back);
-void mlx5dr_ste_set_entry_type(u8 *hw_ste_p, u8 entry_type);
-u8 mlx5dr_ste_get_entry_type(u8 *hw_ste_p);
-void mlx5dr_ste_set_rewrite_actions(u8 *hw_ste_p, u16 num_of_actions,
-				    u32 re_write_index);
-void mlx5dr_ste_set_go_back_bit(u8 *hw_ste_p);
 u64 mlx5dr_ste_get_icm_addr(struct mlx5dr_ste *ste);
 u64 mlx5dr_ste_get_mr_addr(struct mlx5dr_ste *ste);
 struct list_head *mlx5dr_ste_get_miss_list(struct mlx5dr_ste *ste);
 
+#define MLX5DR_MAX_VLANS 2
+
+struct mlx5dr_ste_actions_attr {
+	u32	modify_index;
+	u16	modify_actions;
+	u32	decap_index;
+	u16	decap_actions;
+	u8	decap_with_vlan:1;
+	u64	final_icm_addr;
+	u32	flow_tag;
+	u32	ctr_id;
+	u16	gvmi;
+	u16	hit_gvmi;
+	u32	reformat_id;
+	u32	reformat_size;
+	struct {
+		int	count;
+		u32	headers[MLX5DR_MAX_VLANS];
+	} vlans;
+};
+
+void mlx5dr_ste_set_actions_rx(struct mlx5dr_domain *dmn,
+			       u8 *action_type_set,
+			       u8 *last_ste,
+			       struct mlx5dr_ste_actions_attr *attr,
+			       u32 *added_stes);
+void mlx5dr_ste_set_actions_tx(struct mlx5dr_domain *dmn,
+			       u8 *action_type_set,
+			       u8 *last_ste,
+			       struct mlx5dr_ste_actions_attr *attr,
+			       u32 *added_stes);
+
 struct mlx5dr_ste_ctx *mlx5dr_ste_get_ctx(u8 version);
 void mlx5dr_ste_free(struct mlx5dr_ste *ste,
 		     struct mlx5dr_matcher *matcher,
-- 
2.26.2

