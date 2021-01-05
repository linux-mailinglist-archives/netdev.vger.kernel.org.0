Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7D12EB5D1
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 00:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727552AbhAEXG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 18:06:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:57438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727428AbhAEXG0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 18:06:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AB3522EBE;
        Tue,  5 Jan 2021 23:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609887911;
        bh=+qfacdZJoLpnYtCBk14LIF84jAnlmLfsvw4Z7qaYGKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GjgFDZlNDKcKLu0+2qVva1gVVm1BFwTXIKPhyzLpAVgSdm9cfUhYsRpYJimdre94k
         PiMdv+0Q/7KScusOu44nDjoc/XdliXip4njIr/tJaGcxZvuDrgBtbuimui5XtfsyHm
         Bwdi39PUy8JdMDWPR/CoVJBWv38jJ8mTN93C7949xlApCROBun7EwQaTP3pOphdQpx
         1JNJ/5jZ5XH0eCR542wRrEmrjj8iY/cUG4OYtoJyYNAv23W2hx3Ogf/mE+F5eCj4Yh
         SyxyQp74wNhRlzeuuP8s83KTQAQ1PK78XfVW97FTEXCaRowUDQlSuZx8hLvAmZzpZ1
         Pdt1FX7RmNo9g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/16] net/mlx5: DR, Move STEv0 look up types from mlx5_ifc_dr header
Date:   Tue,  5 Jan 2021 15:03:25 -0800
Message-Id: <20210105230333.239456-9-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210105230333.239456-1-saeed@kernel.org>
References: <20210105230333.239456-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

The lookup types are device specific and should not be
exposed to DR upper layers, matchers/tables.
Each HW STE version should keep them internal.
The lu_type size is updated to support larger lu_types as
required for STEv1.

Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_ste.c      |  6 +-
 .../mellanox/mlx5/core/steering/dr_ste_v0.c   | 70 +++++++++++++++----
 .../mellanox/mlx5/core/steering/dr_types.h    |  8 +--
 .../mellanox/mlx5/core/steering/mlx5_ifc_dr.h | 40 -----------
 4 files changed, 64 insertions(+), 60 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 2cb9406a0364..d3e6e1d9a90b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -171,7 +171,7 @@ void mlx5dr_ste_set_hit_gvmi(u8 *hw_ste_p, u16 gvmi)
 	MLX5_SET(ste_general, hw_ste_p, next_table_base_63_48, gvmi);
 }
 
-void mlx5dr_ste_init(u8 *hw_ste_p, u8 lu_type, u8 entry_type,
+void mlx5dr_ste_init(u8 *hw_ste_p, u16 lu_type, u8 entry_type,
 		     u16 gvmi)
 {
 	MLX5_SET(ste_general, hw_ste_p, entry_type, entry_type);
@@ -523,7 +523,7 @@ int mlx5dr_ste_create_next_htbl(struct mlx5dr_matcher *matcher,
 	struct mlx5dr_ste_htbl *next_htbl;
 
 	if (!mlx5dr_ste_is_last_in_rule(nic_matcher, ste->ste_chain_location)) {
-		u8 next_lu_type;
+		u16 next_lu_type;
 		u16 byte_mask;
 
 		next_lu_type = MLX5_GET(ste_general, hw_ste, next_lu_type);
@@ -576,7 +576,7 @@ static void dr_ste_set_ctrl(struct mlx5dr_ste_htbl *htbl)
 
 struct mlx5dr_ste_htbl *mlx5dr_ste_htbl_alloc(struct mlx5dr_icm_pool *pool,
 					      enum mlx5dr_icm_chunk_size chunk_size,
-					      u8 lu_type, u16 byte_mask)
+					      u16 lu_type, u16 byte_mask)
 {
 	struct mlx5dr_icm_chunk *chunk;
 	struct mlx5dr_ste_htbl *htbl;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
index b4406c633e32..d18f8f9c794a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
@@ -6,9 +6,53 @@
 #include "dr_ste.h"
 
 #define DR_STE_CALC_LU_TYPE(lookup_type, rx, inner) \
-	((inner) ? MLX5DR_STE_LU_TYPE_##lookup_type##_I : \
-		   (rx) ? MLX5DR_STE_LU_TYPE_##lookup_type##_D : \
-			  MLX5DR_STE_LU_TYPE_##lookup_type##_O)
+	((inner) ? DR_STE_V0_LU_TYPE_##lookup_type##_I : \
+		   (rx) ? DR_STE_V0_LU_TYPE_##lookup_type##_D : \
+			  DR_STE_V0_LU_TYPE_##lookup_type##_O)
+
+enum {
+	DR_STE_V0_LU_TYPE_NOP				= 0x00,
+	DR_STE_V0_LU_TYPE_SRC_GVMI_AND_QP		= 0x05,
+	DR_STE_V0_LU_TYPE_ETHL2_TUNNELING_I		= 0x0a,
+	DR_STE_V0_LU_TYPE_ETHL2_DST_O			= 0x06,
+	DR_STE_V0_LU_TYPE_ETHL2_DST_I			= 0x07,
+	DR_STE_V0_LU_TYPE_ETHL2_DST_D			= 0x1b,
+	DR_STE_V0_LU_TYPE_ETHL2_SRC_O			= 0x08,
+	DR_STE_V0_LU_TYPE_ETHL2_SRC_I			= 0x09,
+	DR_STE_V0_LU_TYPE_ETHL2_SRC_D			= 0x1c,
+	DR_STE_V0_LU_TYPE_ETHL2_SRC_DST_O		= 0x36,
+	DR_STE_V0_LU_TYPE_ETHL2_SRC_DST_I		= 0x37,
+	DR_STE_V0_LU_TYPE_ETHL2_SRC_DST_D		= 0x38,
+	DR_STE_V0_LU_TYPE_ETHL3_IPV6_DST_O		= 0x0d,
+	DR_STE_V0_LU_TYPE_ETHL3_IPV6_DST_I		= 0x0e,
+	DR_STE_V0_LU_TYPE_ETHL3_IPV6_DST_D		= 0x1e,
+	DR_STE_V0_LU_TYPE_ETHL3_IPV6_SRC_O		= 0x0f,
+	DR_STE_V0_LU_TYPE_ETHL3_IPV6_SRC_I		= 0x10,
+	DR_STE_V0_LU_TYPE_ETHL3_IPV6_SRC_D		= 0x1f,
+	DR_STE_V0_LU_TYPE_ETHL3_IPV4_5_TUPLE_O		= 0x11,
+	DR_STE_V0_LU_TYPE_ETHL3_IPV4_5_TUPLE_I		= 0x12,
+	DR_STE_V0_LU_TYPE_ETHL3_IPV4_5_TUPLE_D		= 0x20,
+	DR_STE_V0_LU_TYPE_ETHL3_IPV4_MISC_O		= 0x29,
+	DR_STE_V0_LU_TYPE_ETHL3_IPV4_MISC_I		= 0x2a,
+	DR_STE_V0_LU_TYPE_ETHL3_IPV4_MISC_D		= 0x2b,
+	DR_STE_V0_LU_TYPE_ETHL4_O			= 0x13,
+	DR_STE_V0_LU_TYPE_ETHL4_I			= 0x14,
+	DR_STE_V0_LU_TYPE_ETHL4_D			= 0x21,
+	DR_STE_V0_LU_TYPE_ETHL4_MISC_O			= 0x2c,
+	DR_STE_V0_LU_TYPE_ETHL4_MISC_I			= 0x2d,
+	DR_STE_V0_LU_TYPE_ETHL4_MISC_D			= 0x2e,
+	DR_STE_V0_LU_TYPE_MPLS_FIRST_O			= 0x15,
+	DR_STE_V0_LU_TYPE_MPLS_FIRST_I			= 0x24,
+	DR_STE_V0_LU_TYPE_MPLS_FIRST_D			= 0x25,
+	DR_STE_V0_LU_TYPE_GRE				= 0x16,
+	DR_STE_V0_LU_TYPE_FLEX_PARSER_0			= 0x22,
+	DR_STE_V0_LU_TYPE_FLEX_PARSER_1			= 0x23,
+	DR_STE_V0_LU_TYPE_FLEX_PARSER_TNL_HEADER	= 0x19,
+	DR_STE_V0_LU_TYPE_GENERAL_PURPOSE		= 0x18,
+	DR_STE_V0_LU_TYPE_STEERING_REGISTERS_0		= 0x2f,
+	DR_STE_V0_LU_TYPE_STEERING_REGISTERS_1		= 0x30,
+	DR_STE_V0_LU_TYPE_DONT_CARE			= MLX5DR_STE_LU_TYPE_DONT_CARE,
+};
 
 static void
 dr_ste_v0_build_eth_l2_src_dst_bit_mask(struct mlx5dr_match_param *value,
@@ -451,7 +495,7 @@ dr_ste_v0_build_eth_l2_tnl_init(struct mlx5dr_ste_build *sb,
 {
 	dr_ste_v0_build_eth_l2_tnl_bit_mask(mask, sb->inner, sb->bit_mask);
 
-	sb->lu_type = MLX5DR_STE_LU_TYPE_ETHL2_TUNNELING_I;
+	sb->lu_type = DR_STE_V0_LU_TYPE_ETHL2_TUNNELING_I;
 	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
 	sb->ste_build_tag_func = &dr_ste_v0_build_eth_l2_tnl_tag;
 }
@@ -567,7 +611,7 @@ dr_ste_v0_build_tnl_gre_init(struct mlx5dr_ste_build *sb,
 {
 	dr_ste_v0_build_tnl_gre_tag(mask, sb, sb->bit_mask);
 
-	sb->lu_type = MLX5DR_STE_LU_TYPE_GRE;
+	sb->lu_type = DR_STE_V0_LU_TYPE_GRE;
 	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
 	sb->ste_build_tag_func = &dr_ste_v0_build_tnl_gre_tag;
 }
@@ -613,7 +657,7 @@ dr_ste_v0_build_tnl_mpls_init(struct mlx5dr_ste_build *sb,
 {
 	dr_ste_v0_build_tnl_mpls_tag(mask, sb, sb->bit_mask);
 
-	sb->lu_type = MLX5DR_STE_LU_TYPE_FLEX_PARSER_0;
+	sb->lu_type = DR_STE_V0_LU_TYPE_FLEX_PARSER_0;
 	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
 	sb->ste_build_tag_func = &dr_ste_v0_build_tnl_mpls_tag;
 }
@@ -704,7 +748,7 @@ dr_ste_v0_build_icmp_init(struct mlx5dr_ste_build *sb,
 	if (ret)
 		return ret;
 
-	sb->lu_type = MLX5DR_STE_LU_TYPE_FLEX_PARSER_1;
+	sb->lu_type = DR_STE_V0_LU_TYPE_FLEX_PARSER_1;
 	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
 	sb->ste_build_tag_func = &dr_ste_v0_build_icmp_tag;
 
@@ -730,7 +774,7 @@ dr_ste_v0_build_general_purpose_init(struct mlx5dr_ste_build *sb,
 {
 	dr_ste_v0_build_general_purpose_tag(mask, sb, sb->bit_mask);
 
-	sb->lu_type = MLX5DR_STE_LU_TYPE_GENERAL_PURPOSE;
+	sb->lu_type = DR_STE_V0_LU_TYPE_GENERAL_PURPOSE;
 	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
 	sb->ste_build_tag_func = &dr_ste_v0_build_general_purpose_tag;
 }
@@ -789,7 +833,7 @@ dr_ste_v0_build_flex_parser_tnl_vxlan_gpe_init(struct mlx5dr_ste_build *sb,
 					       struct mlx5dr_match_param *mask)
 {
 	dr_ste_v0_build_flex_parser_tnl_vxlan_gpe_tag(mask, sb, sb->bit_mask);
-	sb->lu_type = MLX5DR_STE_LU_TYPE_FLEX_PARSER_TNL_HEADER;
+	sb->lu_type = DR_STE_V0_LU_TYPE_FLEX_PARSER_TNL_HEADER;
 	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
 	sb->ste_build_tag_func = &dr_ste_v0_build_flex_parser_tnl_vxlan_gpe_tag;
 }
@@ -818,7 +862,7 @@ dr_ste_v0_build_flex_parser_tnl_geneve_init(struct mlx5dr_ste_build *sb,
 					    struct mlx5dr_match_param *mask)
 {
 	dr_ste_v0_build_flex_parser_tnl_geneve_tag(mask, sb, sb->bit_mask);
-	sb->lu_type = MLX5DR_STE_LU_TYPE_FLEX_PARSER_TNL_HEADER;
+	sb->lu_type = DR_STE_V0_LU_TYPE_FLEX_PARSER_TNL_HEADER;
 	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
 	sb->ste_build_tag_func = &dr_ste_v0_build_flex_parser_tnl_geneve_tag;
 }
@@ -844,7 +888,7 @@ dr_ste_v0_build_register_0_init(struct mlx5dr_ste_build *sb,
 {
 	dr_ste_v0_build_register_0_tag(mask, sb, sb->bit_mask);
 
-	sb->lu_type = MLX5DR_STE_LU_TYPE_STEERING_REGISTERS_0;
+	sb->lu_type = DR_STE_V0_LU_TYPE_STEERING_REGISTERS_0;
 	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
 	sb->ste_build_tag_func = &dr_ste_v0_build_register_0_tag;
 }
@@ -870,7 +914,7 @@ dr_ste_v0_build_register_1_init(struct mlx5dr_ste_build *sb,
 {
 	dr_ste_v0_build_register_1_tag(mask, sb, sb->bit_mask);
 
-	sb->lu_type = MLX5DR_STE_LU_TYPE_STEERING_REGISTERS_1;
+	sb->lu_type = DR_STE_V0_LU_TYPE_STEERING_REGISTERS_1;
 	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
 	sb->ste_build_tag_func = &dr_ste_v0_build_register_1_tag;
 }
@@ -939,7 +983,7 @@ dr_ste_v0_build_src_gvmi_qpn_init(struct mlx5dr_ste_build *sb,
 {
 	dr_ste_v0_build_src_gvmi_qpn_bit_mask(mask, sb->bit_mask);
 
-	sb->lu_type = MLX5DR_STE_LU_TYPE_SRC_GVMI_AND_QP;
+	sb->lu_type = DR_STE_V0_LU_TYPE_SRC_GVMI_AND_QP;
 	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
 	sb->ste_build_tag_func = &dr_ste_v0_build_src_gvmi_qpn_tag;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index aef88bcc6fc3..c89afc211226 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -155,7 +155,7 @@ struct mlx5dr_ste_htbl_ctrl {
 };
 
 struct mlx5dr_ste_htbl {
-	u8 lu_type;
+	u16 lu_type;
 	u16 byte_mask;
 	u32 refcount;
 	struct mlx5dr_icm_chunk *chunk;
@@ -191,7 +191,7 @@ struct mlx5dr_ste_build {
 	u8 vhca_id_valid:1;
 	struct mlx5dr_domain *dmn;
 	struct mlx5dr_cmd_caps *caps;
-	u8 lu_type;
+	u16 lu_type;
 	u16 byte_mask;
 	u8 bit_mask[DR_STE_SIZE_MASK];
 	int (*ste_build_tag_func)(struct mlx5dr_match_param *spec,
@@ -202,7 +202,7 @@ struct mlx5dr_ste_build {
 struct mlx5dr_ste_htbl *
 mlx5dr_ste_htbl_alloc(struct mlx5dr_icm_pool *pool,
 		      enum mlx5dr_icm_chunk_size chunk_size,
-		      u8 lu_type, u16 byte_mask);
+		      u16 lu_type, u16 byte_mask);
 
 int mlx5dr_ste_htbl_free(struct mlx5dr_ste_htbl *htbl);
 
@@ -220,7 +220,7 @@ static inline void mlx5dr_htbl_get(struct mlx5dr_ste_htbl *htbl)
 
 /* STE utils */
 u32 mlx5dr_ste_calc_hash_index(u8 *hw_ste_p, struct mlx5dr_ste_htbl *htbl);
-void mlx5dr_ste_init(u8 *hw_ste_p, u8 lu_type, u8 entry_type, u16 gvmi);
+void mlx5dr_ste_init(u8 *hw_ste_p, u16 lu_type, u8 entry_type, u16 gvmi);
 void mlx5dr_ste_always_hit_htbl(struct mlx5dr_ste *ste,
 				struct mlx5dr_ste_htbl *next_htbl);
 void mlx5dr_ste_set_miss_addr(u8 *hw_ste, u64 miss_addr);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h
index e01c3766c7de..b4babb6b6616 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h
@@ -50,46 +50,6 @@ enum {
 };
 
 enum {
-	MLX5DR_STE_LU_TYPE_NOP				= 0x00,
-	MLX5DR_STE_LU_TYPE_SRC_GVMI_AND_QP		= 0x05,
-	MLX5DR_STE_LU_TYPE_ETHL2_TUNNELING_I		= 0x0a,
-	MLX5DR_STE_LU_TYPE_ETHL2_DST_O			= 0x06,
-	MLX5DR_STE_LU_TYPE_ETHL2_DST_I			= 0x07,
-	MLX5DR_STE_LU_TYPE_ETHL2_DST_D			= 0x1b,
-	MLX5DR_STE_LU_TYPE_ETHL2_SRC_O			= 0x08,
-	MLX5DR_STE_LU_TYPE_ETHL2_SRC_I			= 0x09,
-	MLX5DR_STE_LU_TYPE_ETHL2_SRC_D			= 0x1c,
-	MLX5DR_STE_LU_TYPE_ETHL2_SRC_DST_O		= 0x36,
-	MLX5DR_STE_LU_TYPE_ETHL2_SRC_DST_I		= 0x37,
-	MLX5DR_STE_LU_TYPE_ETHL2_SRC_DST_D		= 0x38,
-	MLX5DR_STE_LU_TYPE_ETHL3_IPV6_DST_O		= 0x0d,
-	MLX5DR_STE_LU_TYPE_ETHL3_IPV6_DST_I		= 0x0e,
-	MLX5DR_STE_LU_TYPE_ETHL3_IPV6_DST_D		= 0x1e,
-	MLX5DR_STE_LU_TYPE_ETHL3_IPV6_SRC_O		= 0x0f,
-	MLX5DR_STE_LU_TYPE_ETHL3_IPV6_SRC_I		= 0x10,
-	MLX5DR_STE_LU_TYPE_ETHL3_IPV6_SRC_D		= 0x1f,
-	MLX5DR_STE_LU_TYPE_ETHL3_IPV4_5_TUPLE_O		= 0x11,
-	MLX5DR_STE_LU_TYPE_ETHL3_IPV4_5_TUPLE_I		= 0x12,
-	MLX5DR_STE_LU_TYPE_ETHL3_IPV4_5_TUPLE_D		= 0x20,
-	MLX5DR_STE_LU_TYPE_ETHL3_IPV4_MISC_O		= 0x29,
-	MLX5DR_STE_LU_TYPE_ETHL3_IPV4_MISC_I		= 0x2a,
-	MLX5DR_STE_LU_TYPE_ETHL3_IPV4_MISC_D		= 0x2b,
-	MLX5DR_STE_LU_TYPE_ETHL4_O			= 0x13,
-	MLX5DR_STE_LU_TYPE_ETHL4_I			= 0x14,
-	MLX5DR_STE_LU_TYPE_ETHL4_D			= 0x21,
-	MLX5DR_STE_LU_TYPE_ETHL4_MISC_O			= 0x2c,
-	MLX5DR_STE_LU_TYPE_ETHL4_MISC_I			= 0x2d,
-	MLX5DR_STE_LU_TYPE_ETHL4_MISC_D			= 0x2e,
-	MLX5DR_STE_LU_TYPE_MPLS_FIRST_O			= 0x15,
-	MLX5DR_STE_LU_TYPE_MPLS_FIRST_I			= 0x24,
-	MLX5DR_STE_LU_TYPE_MPLS_FIRST_D			= 0x25,
-	MLX5DR_STE_LU_TYPE_GRE				= 0x16,
-	MLX5DR_STE_LU_TYPE_FLEX_PARSER_0		= 0x22,
-	MLX5DR_STE_LU_TYPE_FLEX_PARSER_1		= 0x23,
-	MLX5DR_STE_LU_TYPE_FLEX_PARSER_TNL_HEADER	= 0x19,
-	MLX5DR_STE_LU_TYPE_GENERAL_PURPOSE		= 0x18,
-	MLX5DR_STE_LU_TYPE_STEERING_REGISTERS_0		= 0x2f,
-	MLX5DR_STE_LU_TYPE_STEERING_REGISTERS_1		= 0x30,
 	MLX5DR_STE_LU_TYPE_DONT_CARE			= 0x0f,
 };
 
-- 
2.26.2

