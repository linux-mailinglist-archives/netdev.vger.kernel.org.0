Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 940122EB5D4
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 00:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbhAEXG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 18:06:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:57504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727608AbhAEXGi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 18:06:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B62E623105;
        Tue,  5 Jan 2021 23:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609887916;
        bh=cbao1HcbtH7ZVjZ1c1VDMu0w2EeARhY/YRhNP4IEq/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SzJtdTIbgIhPCNcbBvE9rrolzUMwNRgAPdgYgOKEm/4rFNsS49omBERIID3jLsHzB
         lwtkVs9LRndKWT/DExVT/LGSNDyuPgzbuSnwgK8gNAcuFuMDYM2iMPcshIWlFPWXmU
         5GfAZAOsnCq+z3N5XyTi1fRxDIZPc8xtnUYev9RC40N8fg1zmAxKkI1CSE8vTiL4yZ
         NpmD/JVNKkspIIRK1mYtr9u3KT4CLhSu0+xB+Y4P7czGHb2lZfhnNGs1rKDJ1H27/U
         J0SG7gpgkAyGXq+f6WRfCNRrKgAaEE4CoNWgCW3pIrVX8ocZsjJtVGtabaNuHtIcYD
         mG1QlnThGvE4Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/16] net/mlx5: DR, Move STEv0 action apply logic
Date:   Tue,  5 Jan 2021 15:03:31 -0800
Message-Id: <20210105230333.239456-15-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210105230333.239456-1-saeed@kernel.org>
References: <20210105230333.239456-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Use STE tx/rx actions per-device API: move HW specific
action apply logic from dr_ste to STEv0 file - STEv0 and
STEv1 actions format is different, each version should
have its own implementation.

Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_ste.c      | 240 +----------------
 .../mellanox/mlx5/core/steering/dr_ste_v0.c   | 251 +++++++++++++++++-
 2 files changed, 256 insertions(+), 235 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 19eb49d3c571..2af9487344a2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -5,22 +5,6 @@
 #include <linux/crc32.h>
 #include "dr_ste.h"
 
-#define DR_STE_ENABLE_FLOW_TAG BIT(31)
-
-enum dr_ste_tunl_action {
-	DR_STE_TUNL_ACTION_NONE		= 0,
-	DR_STE_TUNL_ACTION_ENABLE	= 1,
-	DR_STE_TUNL_ACTION_DECAP	= 2,
-	DR_STE_TUNL_ACTION_L3_DECAP	= 3,
-	DR_STE_TUNL_ACTION_POP_VLAN	= 4,
-};
-
-enum dr_ste_action_type {
-	DR_STE_ACTION_TYPE_PUSH_VLAN	= 1,
-	DR_STE_ACTION_TYPE_ENCAP_L3	= 3,
-	DR_STE_ACTION_TYPE_ENCAP	= 4,
-};
-
 struct dr_hw_ste_format {
 	u8 ctrl[DR_STE_SIZE_CTRL];
 	u8 tag[DR_STE_SIZE_TAG];
@@ -88,90 +72,6 @@ void mlx5dr_ste_set_bit_mask(u8 *hw_ste_p, u8 *bit_mask)
 	memcpy(hw_ste->mask, bit_mask, DR_STE_SIZE_MASK);
 }
 
-static void dr_ste_rx_set_flow_tag(u8 *hw_ste_p, u32 flow_tag)
-{
-	MLX5_SET(ste_rx_steering_mult, hw_ste_p, qp_list_pointer,
-		 DR_STE_ENABLE_FLOW_TAG | flow_tag);
-}
-
-static void dr_ste_set_counter_id(u8 *hw_ste_p, u32 ctr_id)
-{
-	/* This can be used for both rx_steering_mult and for sx_transmit */
-	MLX5_SET(ste_rx_steering_mult, hw_ste_p, counter_trigger_15_0, ctr_id);
-	MLX5_SET(ste_rx_steering_mult, hw_ste_p, counter_trigger_23_16, ctr_id >> 16);
-}
-
-static void dr_ste_set_go_back_bit(u8 *hw_ste_p)
-{
-	MLX5_SET(ste_sx_transmit, hw_ste_p, go_back, 1);
-}
-
-static void dr_ste_set_tx_push_vlan(u8 *hw_ste_p, u32 vlan_hdr,
-				    bool go_back)
-{
-	MLX5_SET(ste_sx_transmit, hw_ste_p, action_type,
-		 DR_STE_ACTION_TYPE_PUSH_VLAN);
-	MLX5_SET(ste_sx_transmit, hw_ste_p, encap_pointer_vlan_data, vlan_hdr);
-	/* Due to HW limitation we need to set this bit, otherwise reforamt +
-	 * push vlan will not work.
-	 */
-	if (go_back)
-		dr_ste_set_go_back_bit(hw_ste_p);
-}
-
-static void dr_ste_set_tx_encap(void *hw_ste_p, u32 reformat_id,
-				int size, bool encap_l3)
-{
-	MLX5_SET(ste_sx_transmit, hw_ste_p, action_type,
-		 encap_l3 ? DR_STE_ACTION_TYPE_ENCAP_L3 : DR_STE_ACTION_TYPE_ENCAP);
-	/* The hardware expects here size in words (2 byte) */
-	MLX5_SET(ste_sx_transmit, hw_ste_p, action_description, size / 2);
-	MLX5_SET(ste_sx_transmit, hw_ste_p, encap_pointer_vlan_data, reformat_id);
-}
-
-static void dr_ste_set_rx_decap(u8 *hw_ste_p)
-{
-	MLX5_SET(ste_rx_steering_mult, hw_ste_p, tunneling_action,
-		 DR_STE_TUNL_ACTION_DECAP);
-}
-
-static void dr_ste_set_rx_pop_vlan(u8 *hw_ste_p)
-{
-	MLX5_SET(ste_rx_steering_mult, hw_ste_p, tunneling_action,
-		 DR_STE_TUNL_ACTION_POP_VLAN);
-}
-
-static void dr_ste_set_rx_decap_l3(u8 *hw_ste_p, bool vlan)
-{
-	MLX5_SET(ste_rx_steering_mult, hw_ste_p, tunneling_action,
-		 DR_STE_TUNL_ACTION_L3_DECAP);
-	MLX5_SET(ste_modify_packet, hw_ste_p, action_description, vlan ? 1 : 0);
-}
-
-static void dr_ste_set_entry_type(u8 *hw_ste_p, u8 entry_type)
-{
-	MLX5_SET(ste_general, hw_ste_p, entry_type, entry_type);
-}
-
-static u8 dr_ste_get_entry_type(u8 *hw_ste_p)
-{
-	return MLX5_GET(ste_general, hw_ste_p, entry_type);
-}
-
-static void dr_ste_set_rewrite_actions(u8 *hw_ste_p, u16 num_of_actions,
-				       u32 re_write_index)
-{
-	MLX5_SET(ste_modify_packet, hw_ste_p, number_of_re_write_actions,
-		 num_of_actions);
-	MLX5_SET(ste_modify_packet, hw_ste_p, header_re_write_actions_pointer,
-		 re_write_index);
-}
-
-static void dr_ste_set_hit_gvmi(u8 *hw_ste_p, u16 gvmi)
-{
-	MLX5_SET(ste_general, hw_ste_p, next_table_base_63_48, gvmi);
-}
-
 static void dr_ste_set_always_hit(struct dr_hw_ste_format *hw_ste)
 {
 	memset(&hw_ste->tag, 0, sizeof(hw_ste->tag));
@@ -612,154 +512,26 @@ int mlx5dr_ste_htbl_free(struct mlx5dr_ste_htbl *htbl)
 	return 0;
 }
 
-static void dr_ste_arr_init_next_ste(struct mlx5dr_ste_ctx *ste_ctx,
-				     u8 **last_ste,
-				     u32 *added_stes,
-				     enum mlx5dr_ste_entry_type entry_type,
-				     u16 gvmi)
-{
-	(*added_stes)++;
-	*last_ste += DR_STE_SIZE;
-	ste_ctx->ste_init(*last_ste, MLX5DR_STE_LU_TYPE_DONT_CARE, entry_type, gvmi);
-}
-
 void mlx5dr_ste_set_actions_tx(struct mlx5dr_ste_ctx *ste_ctx,
 			       struct mlx5dr_domain *dmn,
 			       u8 *action_type_set,
-			       u8 *last_ste,
+			       u8 *hw_ste_arr,
 			       struct mlx5dr_ste_actions_attr *attr,
 			       u32 *added_stes)
 {
-	bool encap = action_type_set[DR_ACTION_TYP_L2_TO_TNL_L2] ||
-		action_type_set[DR_ACTION_TYP_L2_TO_TNL_L3];
-
-	/* We want to make sure the modify header comes before L2
-	 * encapsulation. The reason for that is that we support
-	 * modify headers for outer headers only
-	 */
-	if (action_type_set[DR_ACTION_TYP_MODIFY_HDR]) {
-		dr_ste_set_entry_type(last_ste, MLX5DR_STE_TYPE_MODIFY_PKT);
-		dr_ste_set_rewrite_actions(last_ste,
-					   attr->modify_actions,
-					   attr->modify_index);
-	}
-
-	if (action_type_set[DR_ACTION_TYP_PUSH_VLAN]) {
-		int i;
-
-		for (i = 0; i < attr->vlans.count; i++) {
-			if (i || action_type_set[DR_ACTION_TYP_MODIFY_HDR])
-				dr_ste_arr_init_next_ste(ste_ctx,
-							 &last_ste,
-							 added_stes,
-							 MLX5DR_STE_TYPE_TX,
-							 attr->gvmi);
-
-			dr_ste_set_tx_push_vlan(last_ste,
-						attr->vlans.headers[i],
-						encap);
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
-			dr_ste_arr_init_next_ste(ste_ctx,
-						 &last_ste,
-						 added_stes,
-						 MLX5DR_STE_TYPE_TX,
-						 attr->gvmi);
-
-		dr_ste_set_tx_encap(last_ste,
-				    attr->reformat_id,
-				    attr->reformat_size,
-				    action_type_set[DR_ACTION_TYP_L2_TO_TNL_L3]);
-		/* Whenever prio_tag_required enabled, we can be sure that the
-		 * previous table (ACL) already push vlan to our packet,
-		 * And due to HW limitation we need to set this bit, otherwise
-		 * push vlan + reformat will not work.
-		 */
-		if (MLX5_CAP_GEN(dmn->mdev, prio_tag_required))
-			dr_ste_set_go_back_bit(last_ste);
-	}
-
-	if (action_type_set[DR_ACTION_TYP_CTR])
-		dr_ste_set_counter_id(last_ste, attr->ctr_id);
-
-	dr_ste_set_hit_gvmi(last_ste, attr->hit_gvmi);
-	mlx5dr_ste_set_hit_addr(ste_ctx, last_ste, attr->final_icm_addr, 1);
+	ste_ctx->set_actions_tx(dmn, action_type_set, hw_ste_arr,
+				attr, added_stes);
 }
 
 void mlx5dr_ste_set_actions_rx(struct mlx5dr_ste_ctx *ste_ctx,
 			       struct mlx5dr_domain *dmn,
 			       u8 *action_type_set,
-			       u8 *last_ste,
+			       u8 *hw_ste_arr,
 			       struct mlx5dr_ste_actions_attr *attr,
 			       u32 *added_stes)
 {
-	if (action_type_set[DR_ACTION_TYP_CTR])
-		dr_ste_set_counter_id(last_ste, attr->ctr_id);
-
-	if (action_type_set[DR_ACTION_TYP_TNL_L3_TO_L2]) {
-		dr_ste_set_entry_type(last_ste, MLX5DR_STE_TYPE_MODIFY_PKT);
-		dr_ste_set_rx_decap_l3(last_ste, attr->decap_with_vlan);
-		dr_ste_set_rewrite_actions(last_ste,
-					   attr->decap_actions,
-					   attr->decap_index);
-	}
-
-	if (action_type_set[DR_ACTION_TYP_TNL_L2_TO_L2])
-		dr_ste_set_rx_decap(last_ste);
-
-	if (action_type_set[DR_ACTION_TYP_POP_VLAN]) {
-		int i;
-
-		for (i = 0; i < attr->vlans.count; i++) {
-			if (i ||
-			    action_type_set[DR_ACTION_TYP_TNL_L2_TO_L2] ||
-			    action_type_set[DR_ACTION_TYP_TNL_L3_TO_L2])
-				dr_ste_arr_init_next_ste(ste_ctx,
-							 &last_ste,
-							 added_stes,
-							 MLX5DR_STE_TYPE_RX,
-							 attr->gvmi);
-
-			dr_ste_set_rx_pop_vlan(last_ste);
-		}
-	}
-
-	if (action_type_set[DR_ACTION_TYP_MODIFY_HDR]) {
-		if (dr_ste_get_entry_type(last_ste) == MLX5DR_STE_TYPE_MODIFY_PKT)
-			dr_ste_arr_init_next_ste(ste_ctx,
-						 &last_ste,
-						 added_stes,
-						 MLX5DR_STE_TYPE_MODIFY_PKT,
-						 attr->gvmi);
-		else
-			dr_ste_set_entry_type(last_ste, MLX5DR_STE_TYPE_MODIFY_PKT);
-
-		dr_ste_set_rewrite_actions(last_ste,
-					   attr->modify_actions,
-					   attr->modify_index);
-	}
-
-	if (action_type_set[DR_ACTION_TYP_TAG]) {
-		if (dr_ste_get_entry_type(last_ste) == MLX5DR_STE_TYPE_MODIFY_PKT)
-			dr_ste_arr_init_next_ste(ste_ctx,
-						 &last_ste,
-						 added_stes,
-						 MLX5DR_STE_TYPE_RX,
-						 attr->gvmi);
-
-		dr_ste_rx_set_flow_tag(last_ste, attr->flow_tag);
-	}
-
-	dr_ste_set_hit_gvmi(last_ste, attr->hit_gvmi);
-	mlx5dr_ste_set_hit_addr(ste_ctx, last_ste, attr->final_icm_addr, 1);
+	ste_ctx->set_actions_rx(dmn, action_type_set, hw_ste_arr,
+				attr, added_stes);
 }
 
 int mlx5dr_ste_build_pre_check(struct mlx5dr_domain *dmn,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
index f23085a67b70..9bb6395f5d60 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
@@ -5,6 +5,22 @@
 #include <linux/crc32.h>
 #include "dr_ste.h"
 
+#define DR_STE_ENABLE_FLOW_TAG BIT(31)
+
+enum dr_ste_tunl_action {
+	DR_STE_TUNL_ACTION_NONE		= 0,
+	DR_STE_TUNL_ACTION_ENABLE	= 1,
+	DR_STE_TUNL_ACTION_DECAP	= 2,
+	DR_STE_TUNL_ACTION_L3_DECAP	= 3,
+	DR_STE_TUNL_ACTION_POP_VLAN	= 4,
+};
+
+enum dr_ste_action_type {
+	DR_STE_ACTION_TYPE_PUSH_VLAN	= 1,
+	DR_STE_ACTION_TYPE_ENCAP_L3	= 3,
+	DR_STE_ACTION_TYPE_ENCAP	= 4,
+};
+
 #define DR_STE_CALC_LU_TYPE(lookup_type, rx, inner) \
 	((inner) ? DR_STE_V0_LU_TYPE_##lookup_type##_I : \
 		   (rx) ? DR_STE_V0_LU_TYPE_##lookup_type##_D : \
@@ -54,6 +70,16 @@ enum {
 	DR_STE_V0_LU_TYPE_DONT_CARE			= MLX5DR_STE_LU_TYPE_DONT_CARE,
 };
 
+static void dr_ste_v0_set_entry_type(u8 *hw_ste_p, u8 entry_type)
+{
+	MLX5_SET(ste_general, hw_ste_p, entry_type, entry_type);
+}
+
+static u8 dr_ste_v0_get_entry_type(u8 *hw_ste_p)
+{
+	return MLX5_GET(ste_general, hw_ste_p, entry_type);
+}
+
 static void dr_ste_v0_set_miss_addr(u8 *hw_ste_p, u64 miss_addr)
 {
 	u64 index = miss_addr >> 6;
@@ -97,6 +123,11 @@ static u16 dr_ste_v0_get_next_lu_type(u8 *hw_ste_p)
 	return MLX5_GET(ste_general, hw_ste_p, next_lu_type);
 }
 
+static void dr_ste_v0_set_hit_gvmi(u8 *hw_ste_p, u16 gvmi)
+{
+	MLX5_SET(ste_general, hw_ste_p, next_table_base_63_48, gvmi);
+}
+
 static void dr_ste_v0_set_hit_addr(u8 *hw_ste_p, u64 icm_addr, u32 ht_size)
 {
 	u64 index = (icm_addr >> 5) | ht_size;
@@ -108,7 +139,7 @@ static void dr_ste_v0_set_hit_addr(u8 *hw_ste_p, u64 icm_addr, u32 ht_size)
 static void dr_ste_v0_init(u8 *hw_ste_p, u16 lu_type,
 			   u8 entry_type, u16 gvmi)
 {
-	MLX5_SET(ste_general, hw_ste_p, entry_type, entry_type);
+	dr_ste_v0_set_entry_type(hw_ste_p, entry_type);
 	dr_ste_v0_set_lu_type(hw_ste_p, lu_type);
 	dr_ste_v0_set_next_lu_type(hw_ste_p, MLX5DR_STE_LU_TYPE_DONT_CARE);
 
@@ -120,6 +151,220 @@ static void dr_ste_v0_init(u8 *hw_ste_p, u16 lu_type,
 	MLX5_SET(ste_rx_steering_mult, hw_ste_p, miss_address_63_48, gvmi);
 }
 
+static void dr_ste_v0_rx_set_flow_tag(u8 *hw_ste_p, u32 flow_tag)
+{
+	MLX5_SET(ste_rx_steering_mult, hw_ste_p, qp_list_pointer,
+		 DR_STE_ENABLE_FLOW_TAG | flow_tag);
+}
+
+static void dr_ste_v0_set_counter_id(u8 *hw_ste_p, u32 ctr_id)
+{
+	/* This can be used for both rx_steering_mult and for sx_transmit */
+	MLX5_SET(ste_rx_steering_mult, hw_ste_p, counter_trigger_15_0, ctr_id);
+	MLX5_SET(ste_rx_steering_mult, hw_ste_p, counter_trigger_23_16, ctr_id >> 16);
+}
+
+static void dr_ste_v0_set_go_back_bit(u8 *hw_ste_p)
+{
+	MLX5_SET(ste_sx_transmit, hw_ste_p, go_back, 1);
+}
+
+static void dr_ste_v0_set_tx_push_vlan(u8 *hw_ste_p, u32 vlan_hdr,
+				       bool go_back)
+{
+	MLX5_SET(ste_sx_transmit, hw_ste_p, action_type,
+		 DR_STE_ACTION_TYPE_PUSH_VLAN);
+	MLX5_SET(ste_sx_transmit, hw_ste_p, encap_pointer_vlan_data, vlan_hdr);
+	/* Due to HW limitation we need to set this bit, otherwise reforamt +
+	 * push vlan will not work.
+	 */
+	if (go_back)
+		dr_ste_v0_set_go_back_bit(hw_ste_p);
+}
+
+static void dr_ste_v0_set_tx_encap(void *hw_ste_p, u32 reformat_id,
+				   int size, bool encap_l3)
+{
+	MLX5_SET(ste_sx_transmit, hw_ste_p, action_type,
+		 encap_l3 ? DR_STE_ACTION_TYPE_ENCAP_L3 : DR_STE_ACTION_TYPE_ENCAP);
+	/* The hardware expects here size in words (2 byte) */
+	MLX5_SET(ste_sx_transmit, hw_ste_p, action_description, size / 2);
+	MLX5_SET(ste_sx_transmit, hw_ste_p, encap_pointer_vlan_data, reformat_id);
+}
+
+static void dr_ste_v0_set_rx_decap(u8 *hw_ste_p)
+{
+	MLX5_SET(ste_rx_steering_mult, hw_ste_p, tunneling_action,
+		 DR_STE_TUNL_ACTION_DECAP);
+}
+
+static void dr_ste_v0_set_rx_pop_vlan(u8 *hw_ste_p)
+{
+	MLX5_SET(ste_rx_steering_mult, hw_ste_p, tunneling_action,
+		 DR_STE_TUNL_ACTION_POP_VLAN);
+}
+
+static void dr_ste_v0_set_rx_decap_l3(u8 *hw_ste_p, bool vlan)
+{
+	MLX5_SET(ste_rx_steering_mult, hw_ste_p, tunneling_action,
+		 DR_STE_TUNL_ACTION_L3_DECAP);
+	MLX5_SET(ste_modify_packet, hw_ste_p, action_description, vlan ? 1 : 0);
+}
+
+static void dr_ste_v0_set_rewrite_actions(u8 *hw_ste_p, u16 num_of_actions,
+					  u32 re_write_index)
+{
+	MLX5_SET(ste_modify_packet, hw_ste_p, number_of_re_write_actions,
+		 num_of_actions);
+	MLX5_SET(ste_modify_packet, hw_ste_p, header_re_write_actions_pointer,
+		 re_write_index);
+}
+
+static void dr_ste_v0_arr_init_next(u8 **last_ste,
+				    u32 *added_stes,
+				    enum mlx5dr_ste_entry_type entry_type,
+				    u16 gvmi)
+{
+	(*added_stes)++;
+	*last_ste += DR_STE_SIZE;
+	dr_ste_v0_init(*last_ste, MLX5DR_STE_LU_TYPE_DONT_CARE,
+		       entry_type, gvmi);
+}
+
+static void
+dr_ste_v0_set_actions_tx(struct mlx5dr_domain *dmn,
+			 u8 *action_type_set,
+			 u8 *last_ste,
+			 struct mlx5dr_ste_actions_attr *attr,
+			 u32 *added_stes)
+{
+	bool encap = action_type_set[DR_ACTION_TYP_L2_TO_TNL_L2] ||
+		action_type_set[DR_ACTION_TYP_L2_TO_TNL_L3];
+
+	/* We want to make sure the modify header comes before L2
+	 * encapsulation. The reason for that is that we support
+	 * modify headers for outer headers only
+	 */
+	if (action_type_set[DR_ACTION_TYP_MODIFY_HDR]) {
+		dr_ste_v0_set_entry_type(last_ste, MLX5DR_STE_TYPE_MODIFY_PKT);
+		dr_ste_v0_set_rewrite_actions(last_ste,
+					      attr->modify_actions,
+					      attr->modify_index);
+	}
+
+	if (action_type_set[DR_ACTION_TYP_PUSH_VLAN]) {
+		int i;
+
+		for (i = 0; i < attr->vlans.count; i++) {
+			if (i || action_type_set[DR_ACTION_TYP_MODIFY_HDR])
+				dr_ste_v0_arr_init_next(&last_ste,
+							added_stes,
+							MLX5DR_STE_TYPE_TX,
+							attr->gvmi);
+
+			dr_ste_v0_set_tx_push_vlan(last_ste,
+						   attr->vlans.headers[i],
+						   encap);
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
+			dr_ste_v0_arr_init_next(&last_ste,
+						added_stes,
+						MLX5DR_STE_TYPE_TX,
+						attr->gvmi);
+
+		dr_ste_v0_set_tx_encap(last_ste,
+				       attr->reformat_id,
+				       attr->reformat_size,
+				       action_type_set[DR_ACTION_TYP_L2_TO_TNL_L3]);
+		/* Whenever prio_tag_required enabled, we can be sure that the
+		 * previous table (ACL) already push vlan to our packet,
+		 * And due to HW limitation we need to set this bit, otherwise
+		 * push vlan + reformat will not work.
+		 */
+		if (MLX5_CAP_GEN(dmn->mdev, prio_tag_required))
+			dr_ste_v0_set_go_back_bit(last_ste);
+	}
+
+	if (action_type_set[DR_ACTION_TYP_CTR])
+		dr_ste_v0_set_counter_id(last_ste, attr->ctr_id);
+
+	dr_ste_v0_set_hit_gvmi(last_ste, attr->hit_gvmi);
+	dr_ste_v0_set_hit_addr(last_ste, attr->final_icm_addr, 1);
+}
+
+static void
+dr_ste_v0_set_actions_rx(struct mlx5dr_domain *dmn,
+			 u8 *action_type_set,
+			 u8 *last_ste,
+			 struct mlx5dr_ste_actions_attr *attr,
+			 u32 *added_stes)
+{
+	if (action_type_set[DR_ACTION_TYP_CTR])
+		dr_ste_v0_set_counter_id(last_ste, attr->ctr_id);
+
+	if (action_type_set[DR_ACTION_TYP_TNL_L3_TO_L2]) {
+		dr_ste_v0_set_entry_type(last_ste, MLX5DR_STE_TYPE_MODIFY_PKT);
+		dr_ste_v0_set_rx_decap_l3(last_ste, attr->decap_with_vlan);
+		dr_ste_v0_set_rewrite_actions(last_ste,
+					      attr->decap_actions,
+					      attr->decap_index);
+	}
+
+	if (action_type_set[DR_ACTION_TYP_TNL_L2_TO_L2])
+		dr_ste_v0_set_rx_decap(last_ste);
+
+	if (action_type_set[DR_ACTION_TYP_POP_VLAN]) {
+		int i;
+
+		for (i = 0; i < attr->vlans.count; i++) {
+			if (i ||
+			    action_type_set[DR_ACTION_TYP_TNL_L2_TO_L2] ||
+			    action_type_set[DR_ACTION_TYP_TNL_L3_TO_L2])
+				dr_ste_v0_arr_init_next(&last_ste,
+							added_stes,
+							MLX5DR_STE_TYPE_RX,
+							attr->gvmi);
+
+			dr_ste_v0_set_rx_pop_vlan(last_ste);
+		}
+	}
+
+	if (action_type_set[DR_ACTION_TYP_MODIFY_HDR]) {
+		if (dr_ste_v0_get_entry_type(last_ste) == MLX5DR_STE_TYPE_MODIFY_PKT)
+			dr_ste_v0_arr_init_next(&last_ste,
+						added_stes,
+						MLX5DR_STE_TYPE_MODIFY_PKT,
+						attr->gvmi);
+		else
+			dr_ste_v0_set_entry_type(last_ste, MLX5DR_STE_TYPE_MODIFY_PKT);
+
+		dr_ste_v0_set_rewrite_actions(last_ste,
+					      attr->modify_actions,
+					      attr->modify_index);
+	}
+
+	if (action_type_set[DR_ACTION_TYP_TAG]) {
+		if (dr_ste_v0_get_entry_type(last_ste) == MLX5DR_STE_TYPE_MODIFY_PKT)
+			dr_ste_v0_arr_init_next(&last_ste,
+						added_stes,
+						MLX5DR_STE_TYPE_RX,
+						attr->gvmi);
+
+		dr_ste_v0_rx_set_flow_tag(last_ste, attr->flow_tag);
+	}
+
+	dr_ste_v0_set_hit_gvmi(last_ste, attr->hit_gvmi);
+	dr_ste_v0_set_hit_addr(last_ste, attr->final_icm_addr, 1);
+}
+
 static void
 dr_ste_v0_build_eth_l2_src_dst_bit_mask(struct mlx5dr_match_param *value,
 					bool inner, u8 *bit_mask)
@@ -1067,4 +1312,8 @@ struct mlx5dr_ste_ctx ste_ctx_v0 = {
 	.set_hit_addr			= &dr_ste_v0_set_hit_addr,
 	.set_byte_mask			= &dr_ste_v0_set_byte_mask,
 	.get_byte_mask			= &dr_ste_v0_get_byte_mask,
+
+	/* Actions */
+	.set_actions_rx			= &dr_ste_v0_set_actions_rx,
+	.set_actions_tx			= &dr_ste_v0_set_actions_tx,
 };
-- 
2.26.2

