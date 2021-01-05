Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86332EB5CC
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 00:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbhAEXFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 18:05:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:57194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbhAEXFu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 18:05:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA5EF230FB;
        Tue,  5 Jan 2021 23:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609887907;
        bh=yZBsbGdVy9sXYWmvU4Gn29Ag1zGasNlwzozWvd2YVMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ozHx8sy2T4VW/55iKN8i4Bz0GHZLp4toiiXxDhq3XcDf/sdm/WVLQp6Y83kYbZYOA
         xm3Quh5sYwjCl1nv77EnFIIFFwF5dA1GqTYAOYZWcHN2zi2Lth9d4EvZBgvT4OUumr
         t1JHtqY42B81kwNCM+0VwdICIgxA3/GnMGmEnG0tz2jSG8/Sbsrz3EdfFDxAtkSZ18
         EEHAtToEkdXiHHmiHqM/ZED7x72oqbKddxqFCa9mPFdQj/T7zNxKDq9+azgUJtlfLB
         KaiVl1r8jsMC3Gba0lg5LzpYQS4YTX6AL4XRmCjqxbxaWQLYZxOveraFqF0YFDt7o3
         9iHuuhQ0o4u9A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/16] net/mlx5: DR, Use the new HW specific STE infrastructure
Date:   Tue,  5 Jan 2021 15:03:20 -0800
Message-Id: <20210105230333.239456-4-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210105230333.239456-1-saeed@kernel.org>
References: <20210105230333.239456-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Split the STE builders functionality into the common part and
device-specific part. All the device-specific part (with 'v0' in
the function names) is accessed through the STE context structure.

Subsequent patches will have the device-specific logic moved to a
separate file.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_domain.c   |   6 +
 .../mellanox/mlx5/core/steering/dr_matcher.c  | 106 ++-
 .../mellanox/mlx5/core/steering/dr_ste.c      | 766 ++++++++++++------
 .../mellanox/mlx5/core/steering/dr_ste.h      |   2 +
 .../mellanox/mlx5/core/steering/dr_types.h    |  63 +-
 5 files changed, 613 insertions(+), 330 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
index aa2c2d6c44e6..47ec88964bf3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -57,6 +57,12 @@ static int dr_domain_init_resources(struct mlx5dr_domain *dmn)
 {
 	int ret;
 
+	dmn->ste_ctx = mlx5dr_ste_get_ctx(dmn->info.caps.sw_format_ver);
+	if (!dmn->ste_ctx) {
+		mlx5dr_err(dmn, "SW Steering on this device is unsupported\n");
+		return -EOPNOTSUPP;
+	}
+
 	ret = mlx5_core_alloc_pd(dmn->mdev, &dmn->pdn);
 	if (ret) {
 		mlx5dr_err(dmn, "Couldn't allocate PD, ret: %d", ret);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index 6527eb4df153..e3a002983c26 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -221,6 +221,7 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 {
 	struct mlx5dr_domain_rx_tx *nic_dmn = nic_matcher->nic_tbl->nic_dmn;
 	struct mlx5dr_domain *dmn = matcher->tbl->dmn;
+	struct mlx5dr_ste_ctx *ste_ctx = dmn->ste_ctx;
 	struct mlx5dr_match_param mask = {};
 	struct mlx5dr_ste_build *sb;
 	bool inner, rx;
@@ -259,80 +260,89 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 		inner = false;
 
 		if (dr_mask_is_wqe_metadata_set(&mask.misc2))
-			mlx5dr_ste_build_general_purpose(&sb[idx++], &mask, inner, rx);
+			mlx5dr_ste_build_general_purpose(ste_ctx, &sb[idx++],
+							 &mask, inner, rx);
 
 		if (dr_mask_is_reg_c_0_3_set(&mask.misc2))
-			mlx5dr_ste_build_register_0(&sb[idx++], &mask, inner, rx);
+			mlx5dr_ste_build_register_0(ste_ctx, &sb[idx++],
+						    &mask, inner, rx);
 
 		if (dr_mask_is_reg_c_4_7_set(&mask.misc2))
-			mlx5dr_ste_build_register_1(&sb[idx++], &mask, inner, rx);
+			mlx5dr_ste_build_register_1(ste_ctx, &sb[idx++],
+						    &mask, inner, rx);
 
 		if (dr_mask_is_gvmi_or_qpn_set(&mask.misc) &&
 		    (dmn->type == MLX5DR_DOMAIN_TYPE_FDB ||
 		     dmn->type == MLX5DR_DOMAIN_TYPE_NIC_RX)) {
-			mlx5dr_ste_build_src_gvmi_qpn(&sb[idx++], &mask,
-						      dmn, inner, rx);
+			mlx5dr_ste_build_src_gvmi_qpn(ste_ctx, &sb[idx++],
+						      &mask, dmn, inner, rx);
 		}
 
 		if (dr_mask_is_smac_set(&mask.outer) &&
 		    dr_mask_is_dmac_set(&mask.outer)) {
-			mlx5dr_ste_build_eth_l2_src_dst(&sb[idx++], &mask,
-							inner, rx);
+			mlx5dr_ste_build_eth_l2_src_dst(ste_ctx, &sb[idx++],
+							&mask, inner, rx);
 		}
 
 		if (dr_mask_is_smac_set(&mask.outer))
-			mlx5dr_ste_build_eth_l2_src(&sb[idx++], &mask, inner, rx);
+			mlx5dr_ste_build_eth_l2_src(ste_ctx, &sb[idx++],
+						    &mask, inner, rx);
 
 		if (DR_MASK_IS_L2_DST(mask.outer, mask.misc, outer))
-			mlx5dr_ste_build_eth_l2_dst(&sb[idx++], &mask, inner, rx);
+			mlx5dr_ste_build_eth_l2_dst(ste_ctx, &sb[idx++],
+						    &mask, inner, rx);
 
 		if (outer_ipv == DR_RULE_IPV6) {
 			if (dr_mask_is_dst_addr_set(&mask.outer))
-				mlx5dr_ste_build_eth_l3_ipv6_dst(&sb[idx++], &mask,
-								 inner, rx);
+				mlx5dr_ste_build_eth_l3_ipv6_dst(ste_ctx, &sb[idx++],
+								 &mask, inner, rx);
 
 			if (dr_mask_is_src_addr_set(&mask.outer))
-				mlx5dr_ste_build_eth_l3_ipv6_src(&sb[idx++], &mask,
-								 inner, rx);
+				mlx5dr_ste_build_eth_l3_ipv6_src(ste_ctx, &sb[idx++],
+								 &mask, inner, rx);
 
 			if (DR_MASK_IS_ETH_L4_SET(mask.outer, mask.misc, outer))
-				mlx5dr_ste_build_eth_ipv6_l3_l4(&sb[idx++], &mask,
-								inner, rx);
+				mlx5dr_ste_build_eth_ipv6_l3_l4(ste_ctx, &sb[idx++],
+								&mask, inner, rx);
 		} else {
 			if (dr_mask_is_ipv4_5_tuple_set(&mask.outer))
-				mlx5dr_ste_build_eth_l3_ipv4_5_tuple(&sb[idx++], &mask,
-								     inner, rx);
+				mlx5dr_ste_build_eth_l3_ipv4_5_tuple(ste_ctx, &sb[idx++],
+								     &mask, inner, rx);
 
 			if (dr_mask_is_ttl_set(&mask.outer))
-				mlx5dr_ste_build_eth_l3_ipv4_misc(&sb[idx++], &mask,
-								  inner, rx);
+				mlx5dr_ste_build_eth_l3_ipv4_misc(ste_ctx, &sb[idx++],
+								  &mask, inner, rx);
 		}
 
 		if (dr_mask_is_tnl_vxlan_gpe(&mask, dmn))
-			mlx5dr_ste_build_tnl_vxlan_gpe(&sb[idx++], &mask,
-						       inner, rx);
+			mlx5dr_ste_build_tnl_vxlan_gpe(ste_ctx, &sb[idx++],
+						       &mask, inner, rx);
 		else if (dr_mask_is_tnl_geneve(&mask, dmn))
-			mlx5dr_ste_build_tnl_geneve(&sb[idx++], &mask,
-						    inner, rx);
+			mlx5dr_ste_build_tnl_geneve(ste_ctx, &sb[idx++],
+						    &mask, inner, rx);
 
 		if (DR_MASK_IS_ETH_L4_MISC_SET(mask.misc3, outer))
-			mlx5dr_ste_build_eth_l4_misc(&sb[idx++], &mask, inner, rx);
+			mlx5dr_ste_build_eth_l4_misc(ste_ctx, &sb[idx++],
+						     &mask, inner, rx);
 
 		if (DR_MASK_IS_FIRST_MPLS_SET(mask.misc2, outer))
-			mlx5dr_ste_build_mpls(&sb[idx++], &mask, inner, rx);
+			mlx5dr_ste_build_mpls(ste_ctx, &sb[idx++],
+					      &mask, inner, rx);
 
 		if (DR_MASK_IS_TNL_MPLS_SET(mask.misc2))
-			mlx5dr_ste_build_tnl_mpls(&sb[idx++], &mask, inner, rx);
+			mlx5dr_ste_build_tnl_mpls(ste_ctx, &sb[idx++],
+						  &mask, inner, rx);
 
 		if (dr_mask_is_icmp(&mask, dmn)) {
-			ret = mlx5dr_ste_build_icmp(&sb[idx++],
+			ret = mlx5dr_ste_build_icmp(ste_ctx, &sb[idx++],
 						    &mask, &dmn->info.caps,
 						    inner, rx);
 			if (ret)
 				return ret;
 		}
 		if (dr_mask_is_tnl_gre_set(&mask.misc))
-			mlx5dr_ste_build_tnl_gre(&sb[idx++], &mask, inner, rx);
+			mlx5dr_ste_build_tnl_gre(ste_ctx, &sb[idx++],
+						 &mask, inner, rx);
 	}
 
 	/* Inner */
@@ -343,50 +353,56 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 		inner = true;
 
 		if (dr_mask_is_eth_l2_tnl_set(&mask.misc))
-			mlx5dr_ste_build_eth_l2_tnl(&sb[idx++], &mask, inner, rx);
+			mlx5dr_ste_build_eth_l2_tnl(ste_ctx, &sb[idx++],
+						    &mask, inner, rx);
 
 		if (dr_mask_is_smac_set(&mask.inner) &&
 		    dr_mask_is_dmac_set(&mask.inner)) {
-			mlx5dr_ste_build_eth_l2_src_dst(&sb[idx++],
+			mlx5dr_ste_build_eth_l2_src_dst(ste_ctx, &sb[idx++],
 							&mask, inner, rx);
 		}
 
 		if (dr_mask_is_smac_set(&mask.inner))
-			mlx5dr_ste_build_eth_l2_src(&sb[idx++], &mask, inner, rx);
+			mlx5dr_ste_build_eth_l2_src(ste_ctx, &sb[idx++],
+						    &mask, inner, rx);
 
 		if (DR_MASK_IS_L2_DST(mask.inner, mask.misc, inner))
-			mlx5dr_ste_build_eth_l2_dst(&sb[idx++], &mask, inner, rx);
+			mlx5dr_ste_build_eth_l2_dst(ste_ctx, &sb[idx++],
+						    &mask, inner, rx);
 
 		if (inner_ipv == DR_RULE_IPV6) {
 			if (dr_mask_is_dst_addr_set(&mask.inner))
-				mlx5dr_ste_build_eth_l3_ipv6_dst(&sb[idx++], &mask,
-								 inner, rx);
+				mlx5dr_ste_build_eth_l3_ipv6_dst(ste_ctx, &sb[idx++],
+								 &mask, inner, rx);
 
 			if (dr_mask_is_src_addr_set(&mask.inner))
-				mlx5dr_ste_build_eth_l3_ipv6_src(&sb[idx++], &mask,
-								 inner, rx);
+				mlx5dr_ste_build_eth_l3_ipv6_src(ste_ctx, &sb[idx++],
+								 &mask, inner, rx);
 
 			if (DR_MASK_IS_ETH_L4_SET(mask.inner, mask.misc, inner))
-				mlx5dr_ste_build_eth_ipv6_l3_l4(&sb[idx++], &mask,
-								inner, rx);
+				mlx5dr_ste_build_eth_ipv6_l3_l4(ste_ctx, &sb[idx++],
+								&mask, inner, rx);
 		} else {
 			if (dr_mask_is_ipv4_5_tuple_set(&mask.inner))
-				mlx5dr_ste_build_eth_l3_ipv4_5_tuple(&sb[idx++], &mask,
-								     inner, rx);
+				mlx5dr_ste_build_eth_l3_ipv4_5_tuple(ste_ctx, &sb[idx++],
+								     &mask, inner, rx);
 
 			if (dr_mask_is_ttl_set(&mask.inner))
-				mlx5dr_ste_build_eth_l3_ipv4_misc(&sb[idx++], &mask,
-								  inner, rx);
+				mlx5dr_ste_build_eth_l3_ipv4_misc(ste_ctx, &sb[idx++],
+								  &mask, inner, rx);
 		}
 
 		if (DR_MASK_IS_ETH_L4_MISC_SET(mask.misc3, inner))
-			mlx5dr_ste_build_eth_l4_misc(&sb[idx++], &mask, inner, rx);
+			mlx5dr_ste_build_eth_l4_misc(ste_ctx, &sb[idx++],
+						     &mask, inner, rx);
 
 		if (DR_MASK_IS_FIRST_MPLS_SET(mask.misc2, inner))
-			mlx5dr_ste_build_mpls(&sb[idx++], &mask, inner, rx);
+			mlx5dr_ste_build_mpls(ste_ctx, &sb[idx++],
+					      &mask, inner, rx);
 
 		if (DR_MASK_IS_TNL_MPLS_SET(mask.misc2))
-			mlx5dr_ste_build_tnl_mpls(&sb[idx++], &mask, inner, rx);
+			mlx5dr_ste_build_tnl_mpls(ste_ctx, &sb[idx++],
+						  &mask, inner, rx);
 	}
 	/* Empty matcher, takes all */
 	if (matcher->match_criteria == DR_MATCHER_CRITERIA_EMPTY)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 697fdb452e4c..9d88491ce81b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -68,7 +68,7 @@ u32 mlx5dr_ste_calc_hash_index(u8 *hw_ste_p, struct mlx5dr_ste_htbl *htbl)
 	return index;
 }
 
-static u16 dr_ste_conv_bit_to_byte_mask(u8 *bit_mask)
+u16 mlx5dr_ste_conv_bit_to_byte_mask(u8 *bit_mask)
 {
 	u16 byte_mask = 0;
 	int i;
@@ -699,37 +699,6 @@ int mlx5dr_ste_build_ste_arr(struct mlx5dr_matcher *matcher,
 	return 0;
 }
 
-static void dr_ste_build_eth_l2_src_des_bit_mask(struct mlx5dr_match_param *value,
-						 bool inner, u8 *bit_mask)
-{
-	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
-
-	DR_STE_SET_MASK_V(eth_l2_src_dst, bit_mask, dmac_47_16, mask, dmac_47_16);
-	DR_STE_SET_MASK_V(eth_l2_src_dst, bit_mask, dmac_15_0, mask, dmac_15_0);
-
-	if (mask->smac_47_16 || mask->smac_15_0) {
-		MLX5_SET(ste_eth_l2_src_dst, bit_mask, smac_47_32,
-			 mask->smac_47_16 >> 16);
-		MLX5_SET(ste_eth_l2_src_dst, bit_mask, smac_31_0,
-			 mask->smac_47_16 << 16 | mask->smac_15_0);
-		mask->smac_47_16 = 0;
-		mask->smac_15_0 = 0;
-	}
-
-	DR_STE_SET_MASK_V(eth_l2_src_dst, bit_mask, first_vlan_id, mask, first_vid);
-	DR_STE_SET_MASK_V(eth_l2_src_dst, bit_mask, first_cfi, mask, first_cfi);
-	DR_STE_SET_MASK_V(eth_l2_src_dst, bit_mask, first_priority, mask, first_prio);
-	DR_STE_SET_MASK(eth_l2_src_dst, bit_mask, l3_type, mask, ip_version);
-
-	if (mask->cvlan_tag) {
-		MLX5_SET(ste_eth_l2_src_dst, bit_mask, first_vlan_qualifier, -1);
-		mask->cvlan_tag = 0;
-	} else if (mask->svlan_tag) {
-		MLX5_SET(ste_eth_l2_src_dst, bit_mask, first_vlan_qualifier, -1);
-		mask->svlan_tag = 0;
-	}
-}
-
 static void dr_ste_copy_mask_misc(char *mask, struct mlx5dr_match_misc *spec)
 {
 	spec->gre_c_present = MLX5_GET(fte_match_set_misc, mask, gre_c_present);
@@ -971,9 +940,42 @@ void mlx5dr_ste_copy_param(u8 match_criteria,
 	}
 }
 
-static int dr_ste_build_eth_l2_src_des_tag(struct mlx5dr_match_param *value,
-					   struct mlx5dr_ste_build *sb,
-					   u8 *tag)
+static void
+dr_ste_v0_build_eth_l2_src_dst_bit_mask(struct mlx5dr_match_param *value,
+					bool inner, u8 *bit_mask)
+{
+	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
+
+	DR_STE_SET_MASK_V(eth_l2_src_dst, bit_mask, dmac_47_16, mask, dmac_47_16);
+	DR_STE_SET_MASK_V(eth_l2_src_dst, bit_mask, dmac_15_0, mask, dmac_15_0);
+
+	if (mask->smac_47_16 || mask->smac_15_0) {
+		MLX5_SET(ste_eth_l2_src_dst, bit_mask, smac_47_32,
+			 mask->smac_47_16 >> 16);
+		MLX5_SET(ste_eth_l2_src_dst, bit_mask, smac_31_0,
+			 mask->smac_47_16 << 16 | mask->smac_15_0);
+		mask->smac_47_16 = 0;
+		mask->smac_15_0 = 0;
+	}
+
+	DR_STE_SET_MASK_V(eth_l2_src_dst, bit_mask, first_vlan_id, mask, first_vid);
+	DR_STE_SET_MASK_V(eth_l2_src_dst, bit_mask, first_cfi, mask, first_cfi);
+	DR_STE_SET_MASK_V(eth_l2_src_dst, bit_mask, first_priority, mask, first_prio);
+	DR_STE_SET_MASK(eth_l2_src_dst, bit_mask, l3_type, mask, ip_version);
+
+	if (mask->cvlan_tag) {
+		MLX5_SET(ste_eth_l2_src_dst, bit_mask, first_vlan_qualifier, -1);
+		mask->cvlan_tag = 0;
+	} else if (mask->svlan_tag) {
+		MLX5_SET(ste_eth_l2_src_dst, bit_mask, first_vlan_qualifier, -1);
+		mask->svlan_tag = 0;
+	}
+}
+
+static int
+dr_ste_v0_build_eth_l2_src_dst_tag(struct mlx5dr_match_param *value,
+				   struct mlx5dr_ste_build *sb,
+				   u8 *tag)
 {
 	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
 
@@ -1016,21 +1018,30 @@ static int dr_ste_build_eth_l2_src_des_tag(struct mlx5dr_match_param *value,
 	return 0;
 }
 
-void mlx5dr_ste_build_eth_l2_src_dst(struct mlx5dr_ste_build *sb,
+static void
+dr_ste_v0_build_eth_l2_src_dst_init(struct mlx5dr_ste_build *sb,
+				    struct mlx5dr_match_param *mask)
+{
+	dr_ste_v0_build_eth_l2_src_dst_bit_mask(mask, sb->inner, sb->bit_mask);
+
+	sb->lu_type = DR_STE_CALC_LU_TYPE(ETHL2_SRC_DST, sb->rx, sb->inner);
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v0_build_eth_l2_src_dst_tag;
+}
+
+void mlx5dr_ste_build_eth_l2_src_dst(struct mlx5dr_ste_ctx *ste_ctx,
+				     struct mlx5dr_ste_build *sb,
 				     struct mlx5dr_match_param *mask,
 				     bool inner, bool rx)
 {
-	dr_ste_build_eth_l2_src_des_bit_mask(mask, inner, sb->bit_mask);
-
 	sb->rx = rx;
 	sb->inner = inner;
-	sb->lu_type = DR_STE_CALC_LU_TYPE(ETHL2_SRC_DST, rx, inner);
-	sb->byte_mask = dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_build_eth_l2_src_des_tag;
+	ste_ctx->build_eth_l2_src_dst_init(sb, mask);
 }
 
-static void dr_ste_build_eth_l3_ipv6_dst_bit_mask(struct mlx5dr_match_param *value,
-						  bool inner, u8 *bit_mask)
+static void
+dr_ste_v0_build_eth_l3_ipv6_dst_bit_mask(struct mlx5dr_match_param *value,
+					 bool inner, u8 *bit_mask)
 {
 	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
 
@@ -1040,9 +1051,10 @@ static void dr_ste_build_eth_l3_ipv6_dst_bit_mask(struct mlx5dr_match_param *val
 	DR_STE_SET_MASK_V(eth_l3_ipv6_dst, bit_mask, dst_ip_31_0, mask, dst_ip_31_0);
 }
 
-static int dr_ste_build_eth_l3_ipv6_dst_tag(struct mlx5dr_match_param *value,
-					    struct mlx5dr_ste_build *sb,
-					    u8 *tag)
+static int
+dr_ste_v0_build_eth_l3_ipv6_dst_tag(struct mlx5dr_match_param *value,
+				    struct mlx5dr_ste_build *sb,
+				    u8 *tag)
 {
 	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
 
@@ -1054,21 +1066,30 @@ static int dr_ste_build_eth_l3_ipv6_dst_tag(struct mlx5dr_match_param *value,
 	return 0;
 }
 
-void mlx5dr_ste_build_eth_l3_ipv6_dst(struct mlx5dr_ste_build *sb,
+static void
+dr_ste_v0_build_eth_l3_ipv6_dst_init(struct mlx5dr_ste_build *sb,
+				     struct mlx5dr_match_param *mask)
+{
+	dr_ste_v0_build_eth_l3_ipv6_dst_bit_mask(mask, sb->inner, sb->bit_mask);
+
+	sb->lu_type = DR_STE_CALC_LU_TYPE(ETHL3_IPV6_DST, sb->rx, sb->inner);
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v0_build_eth_l3_ipv6_dst_tag;
+}
+
+void mlx5dr_ste_build_eth_l3_ipv6_dst(struct mlx5dr_ste_ctx *ste_ctx,
+				      struct mlx5dr_ste_build *sb,
 				      struct mlx5dr_match_param *mask,
 				      bool inner, bool rx)
 {
-	dr_ste_build_eth_l3_ipv6_dst_bit_mask(mask, inner, sb->bit_mask);
-
 	sb->rx = rx;
 	sb->inner = inner;
-	sb->lu_type = DR_STE_CALC_LU_TYPE(ETHL3_IPV6_DST, rx, inner);
-	sb->byte_mask = dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_build_eth_l3_ipv6_dst_tag;
+	ste_ctx->build_eth_l3_ipv6_dst_init(sb, mask);
 }
 
-static void dr_ste_build_eth_l3_ipv6_src_bit_mask(struct mlx5dr_match_param *value,
-						  bool inner, u8 *bit_mask)
+static void
+dr_ste_v0_build_eth_l3_ipv6_src_bit_mask(struct mlx5dr_match_param *value,
+					 bool inner, u8 *bit_mask)
 {
 	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
 
@@ -1078,9 +1099,10 @@ static void dr_ste_build_eth_l3_ipv6_src_bit_mask(struct mlx5dr_match_param *val
 	DR_STE_SET_MASK_V(eth_l3_ipv6_src, bit_mask, src_ip_31_0, mask, src_ip_31_0);
 }
 
-static int dr_ste_build_eth_l3_ipv6_src_tag(struct mlx5dr_match_param *value,
-					    struct mlx5dr_ste_build *sb,
-					    u8 *tag)
+static int
+dr_ste_v0_build_eth_l3_ipv6_src_tag(struct mlx5dr_match_param *value,
+				    struct mlx5dr_ste_build *sb,
+				    u8 *tag)
 {
 	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
 
@@ -1092,22 +1114,31 @@ static int dr_ste_build_eth_l3_ipv6_src_tag(struct mlx5dr_match_param *value,
 	return 0;
 }
 
-void mlx5dr_ste_build_eth_l3_ipv6_src(struct mlx5dr_ste_build *sb,
+static void
+dr_ste_v0_build_eth_l3_ipv6_src_init(struct mlx5dr_ste_build *sb,
+				     struct mlx5dr_match_param *mask)
+{
+	dr_ste_v0_build_eth_l3_ipv6_src_bit_mask(mask, sb->inner, sb->bit_mask);
+
+	sb->lu_type = DR_STE_CALC_LU_TYPE(ETHL3_IPV6_SRC, sb->rx, sb->inner);
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v0_build_eth_l3_ipv6_src_tag;
+}
+
+void mlx5dr_ste_build_eth_l3_ipv6_src(struct mlx5dr_ste_ctx *ste_ctx,
+				      struct mlx5dr_ste_build *sb,
 				      struct mlx5dr_match_param *mask,
 				      bool inner, bool rx)
 {
-	dr_ste_build_eth_l3_ipv6_src_bit_mask(mask, inner, sb->bit_mask);
-
 	sb->rx = rx;
 	sb->inner = inner;
-	sb->lu_type = DR_STE_CALC_LU_TYPE(ETHL3_IPV6_SRC, rx, inner);
-	sb->byte_mask = dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_build_eth_l3_ipv6_src_tag;
+	ste_ctx->build_eth_l3_ipv6_src_init(sb, mask);
 }
 
-static void dr_ste_build_eth_l3_ipv4_5_tuple_bit_mask(struct mlx5dr_match_param *value,
-						      bool inner,
-						      u8 *bit_mask)
+static void
+dr_ste_v0_build_eth_l3_ipv4_5_tuple_bit_mask(struct mlx5dr_match_param *value,
+					     bool inner,
+					     u8 *bit_mask)
 {
 	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
 
@@ -1138,9 +1169,10 @@ static void dr_ste_build_eth_l3_ipv4_5_tuple_bit_mask(struct mlx5dr_match_param
 	}
 }
 
-static int dr_ste_build_eth_l3_ipv4_5_tuple_tag(struct mlx5dr_match_param *value,
-						struct mlx5dr_ste_build *sb,
-						u8 *tag)
+static int
+dr_ste_v0_build_eth_l3_ipv4_5_tuple_tag(struct mlx5dr_match_param *value,
+					struct mlx5dr_ste_build *sb,
+					u8 *tag)
 {
 	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
 
@@ -1163,22 +1195,30 @@ static int dr_ste_build_eth_l3_ipv4_5_tuple_tag(struct mlx5dr_match_param *value
 	return 0;
 }
 
-void mlx5dr_ste_build_eth_l3_ipv4_5_tuple(struct mlx5dr_ste_build *sb,
+static void
+dr_ste_v0_build_eth_l3_ipv4_5_tuple_init(struct mlx5dr_ste_build *sb,
+					 struct mlx5dr_match_param *mask)
+{
+	dr_ste_v0_build_eth_l3_ipv4_5_tuple_bit_mask(mask, sb->inner, sb->bit_mask);
+
+	sb->lu_type = DR_STE_CALC_LU_TYPE(ETHL3_IPV4_5_TUPLE, sb->rx, sb->inner);
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v0_build_eth_l3_ipv4_5_tuple_tag;
+}
+
+void mlx5dr_ste_build_eth_l3_ipv4_5_tuple(struct mlx5dr_ste_ctx *ste_ctx,
+					  struct mlx5dr_ste_build *sb,
 					  struct mlx5dr_match_param *mask,
 					  bool inner, bool rx)
 {
-	dr_ste_build_eth_l3_ipv4_5_tuple_bit_mask(mask, inner, sb->bit_mask);
-
 	sb->rx = rx;
 	sb->inner = inner;
-	sb->lu_type = DR_STE_CALC_LU_TYPE(ETHL3_IPV4_5_TUPLE, rx, inner);
-	sb->byte_mask = dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_build_eth_l3_ipv4_5_tuple_tag;
+	ste_ctx->build_eth_l3_ipv4_5_tuple_init(sb, mask);
 }
 
 static void
-dr_ste_build_eth_l2_src_or_dst_bit_mask(struct mlx5dr_match_param *value,
-					bool inner, u8 *bit_mask)
+dr_ste_v0_build_eth_l2_src_or_dst_bit_mask(struct mlx5dr_match_param *value,
+					   bool inner, u8 *bit_mask)
 {
 	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
 	struct mlx5dr_match_misc *misc_mask = &value->misc;
@@ -1227,8 +1267,9 @@ dr_ste_build_eth_l2_src_or_dst_bit_mask(struct mlx5dr_match_param *value,
 	}
 }
 
-static int dr_ste_build_eth_l2_src_or_dst_tag(struct mlx5dr_match_param *value,
-					      bool inner, u8 *tag)
+static int
+dr_ste_v0_build_eth_l2_src_or_dst_tag(struct mlx5dr_match_param *value,
+				      bool inner, u8 *tag)
 {
 	struct mlx5dr_match_spec *spec = inner ? &value->inner : &value->outer;
 	struct mlx5dr_match_misc *misc_spec = &value->misc;
@@ -1288,79 +1329,100 @@ static int dr_ste_build_eth_l2_src_or_dst_tag(struct mlx5dr_match_param *value,
 	return 0;
 }
 
-static void dr_ste_build_eth_l2_src_bit_mask(struct mlx5dr_match_param *value,
-					     bool inner, u8 *bit_mask)
+static void
+dr_ste_v0_build_eth_l2_src_bit_mask(struct mlx5dr_match_param *value,
+				    bool inner, u8 *bit_mask)
 {
 	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
 
 	DR_STE_SET_MASK_V(eth_l2_src, bit_mask, smac_47_16, mask, smac_47_16);
 	DR_STE_SET_MASK_V(eth_l2_src, bit_mask, smac_15_0, mask, smac_15_0);
 
-	dr_ste_build_eth_l2_src_or_dst_bit_mask(value, inner, bit_mask);
+	dr_ste_v0_build_eth_l2_src_or_dst_bit_mask(value, inner, bit_mask);
 }
 
-static int dr_ste_build_eth_l2_src_tag(struct mlx5dr_match_param *value,
-				       struct mlx5dr_ste_build *sb,
-				       u8 *tag)
+static int
+dr_ste_v0_build_eth_l2_src_tag(struct mlx5dr_match_param *value,
+			       struct mlx5dr_ste_build *sb,
+			       u8 *tag)
 {
 	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
 
 	DR_STE_SET_TAG(eth_l2_src, tag, smac_47_16, spec, smac_47_16);
 	DR_STE_SET_TAG(eth_l2_src, tag, smac_15_0, spec, smac_15_0);
 
-	return dr_ste_build_eth_l2_src_or_dst_tag(value, sb->inner, tag);
+	return dr_ste_v0_build_eth_l2_src_or_dst_tag(value, sb->inner, tag);
+}
+
+static void
+dr_ste_v0_build_eth_l2_src_init(struct mlx5dr_ste_build *sb,
+				struct mlx5dr_match_param *mask)
+{
+	dr_ste_v0_build_eth_l2_src_bit_mask(mask, sb->inner, sb->bit_mask);
+	sb->lu_type = DR_STE_CALC_LU_TYPE(ETHL2_SRC, sb->rx, sb->inner);
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v0_build_eth_l2_src_tag;
 }
 
-void mlx5dr_ste_build_eth_l2_src(struct mlx5dr_ste_build *sb,
+void mlx5dr_ste_build_eth_l2_src(struct mlx5dr_ste_ctx *ste_ctx,
+				 struct mlx5dr_ste_build *sb,
 				 struct mlx5dr_match_param *mask,
 				 bool inner, bool rx)
 {
-	dr_ste_build_eth_l2_src_bit_mask(mask, inner, sb->bit_mask);
 	sb->rx = rx;
 	sb->inner = inner;
-	sb->lu_type = DR_STE_CALC_LU_TYPE(ETHL2_SRC, rx, inner);
-	sb->byte_mask = dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_build_eth_l2_src_tag;
+	ste_ctx->build_eth_l2_src_init(sb, mask);
 }
 
-static void dr_ste_build_eth_l2_dst_bit_mask(struct mlx5dr_match_param *value,
-					     bool inner, u8 *bit_mask)
+static void
+dr_ste_v0_build_eth_l2_dst_bit_mask(struct mlx5dr_match_param *value,
+				    bool inner, u8 *bit_mask)
 {
 	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
 
 	DR_STE_SET_MASK_V(eth_l2_dst, bit_mask, dmac_47_16, mask, dmac_47_16);
 	DR_STE_SET_MASK_V(eth_l2_dst, bit_mask, dmac_15_0, mask, dmac_15_0);
 
-	dr_ste_build_eth_l2_src_or_dst_bit_mask(value, inner, bit_mask);
+	dr_ste_v0_build_eth_l2_src_or_dst_bit_mask(value, inner, bit_mask);
 }
 
-static int dr_ste_build_eth_l2_dst_tag(struct mlx5dr_match_param *value,
-				       struct mlx5dr_ste_build *sb,
-				       u8 *tag)
+static int
+dr_ste_v0_build_eth_l2_dst_tag(struct mlx5dr_match_param *value,
+			       struct mlx5dr_ste_build *sb,
+			       u8 *tag)
 {
 	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
 
 	DR_STE_SET_TAG(eth_l2_dst, tag, dmac_47_16, spec, dmac_47_16);
 	DR_STE_SET_TAG(eth_l2_dst, tag, dmac_15_0, spec, dmac_15_0);
 
-	return dr_ste_build_eth_l2_src_or_dst_tag(value, sb->inner, tag);
+	return dr_ste_v0_build_eth_l2_src_or_dst_tag(value, sb->inner, tag);
 }
 
-void mlx5dr_ste_build_eth_l2_dst(struct mlx5dr_ste_build *sb,
+static void
+dr_ste_v0_build_eth_l2_dst_init(struct mlx5dr_ste_build *sb,
+				struct mlx5dr_match_param *mask)
+{
+	dr_ste_v0_build_eth_l2_dst_bit_mask(mask, sb->inner, sb->bit_mask);
+
+	sb->lu_type = DR_STE_CALC_LU_TYPE(ETHL2_DST, sb->rx, sb->inner);
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v0_build_eth_l2_dst_tag;
+}
+
+void mlx5dr_ste_build_eth_l2_dst(struct mlx5dr_ste_ctx *ste_ctx,
+				 struct mlx5dr_ste_build *sb,
 				 struct mlx5dr_match_param *mask,
 				 bool inner, bool rx)
 {
-	dr_ste_build_eth_l2_dst_bit_mask(mask, inner, sb->bit_mask);
-
 	sb->rx = rx;
 	sb->inner = inner;
-	sb->lu_type = DR_STE_CALC_LU_TYPE(ETHL2_DST, rx, inner);
-	sb->byte_mask = dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_build_eth_l2_dst_tag;
+	ste_ctx->build_eth_l2_dst_init(sb, mask);
 }
 
-static void dr_ste_build_eth_l2_tnl_bit_mask(struct mlx5dr_match_param *value,
-					     bool inner, u8 *bit_mask)
+static void
+dr_ste_v0_build_eth_l2_tnl_bit_mask(struct mlx5dr_match_param *value,
+				    bool inner, u8 *bit_mask)
 {
 	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
 	struct mlx5dr_match_misc *misc = &value->misc;
@@ -1387,9 +1449,10 @@ static void dr_ste_build_eth_l2_tnl_bit_mask(struct mlx5dr_match_param *value,
 	}
 }
 
-static int dr_ste_build_eth_l2_tnl_tag(struct mlx5dr_match_param *value,
-				       struct mlx5dr_ste_build *sb,
-				       u8 *tag)
+static int
+dr_ste_v0_build_eth_l2_tnl_tag(struct mlx5dr_match_param *value,
+			       struct mlx5dr_ste_build *sb,
+			       u8 *tag)
 {
 	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
 	struct mlx5dr_match_misc *misc = &value->misc;
@@ -1431,29 +1494,39 @@ static int dr_ste_build_eth_l2_tnl_tag(struct mlx5dr_match_param *value,
 	return 0;
 }
 
-void mlx5dr_ste_build_eth_l2_tnl(struct mlx5dr_ste_build *sb,
-				 struct mlx5dr_match_param *mask, bool inner, bool rx)
+static void
+dr_ste_v0_build_eth_l2_tnl_init(struct mlx5dr_ste_build *sb,
+				struct mlx5dr_match_param *mask)
 {
-	dr_ste_build_eth_l2_tnl_bit_mask(mask, inner, sb->bit_mask);
+	dr_ste_v0_build_eth_l2_tnl_bit_mask(mask, sb->inner, sb->bit_mask);
 
+	sb->lu_type = MLX5DR_STE_LU_TYPE_ETHL2_TUNNELING_I;
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v0_build_eth_l2_tnl_tag;
+}
+
+void mlx5dr_ste_build_eth_l2_tnl(struct mlx5dr_ste_ctx *ste_ctx,
+				 struct mlx5dr_ste_build *sb,
+				 struct mlx5dr_match_param *mask, bool inner, bool rx)
+{
 	sb->rx = rx;
 	sb->inner = inner;
-	sb->lu_type = MLX5DR_STE_LU_TYPE_ETHL2_TUNNELING_I;
-	sb->byte_mask = dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_build_eth_l2_tnl_tag;
+	ste_ctx->build_eth_l2_tnl_init(sb, mask);
 }
 
-static void dr_ste_build_eth_l3_ipv4_misc_bit_mask(struct mlx5dr_match_param *value,
-						   bool inner, u8 *bit_mask)
+static void
+dr_ste_v0_build_eth_l3_ipv4_misc_bit_mask(struct mlx5dr_match_param *value,
+					  bool inner, u8 *bit_mask)
 {
 	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
 
 	DR_STE_SET_MASK_V(eth_l3_ipv4_misc, bit_mask, time_to_live, mask, ttl_hoplimit);
 }
 
-static int dr_ste_build_eth_l3_ipv4_misc_tag(struct mlx5dr_match_param *value,
-					     struct mlx5dr_ste_build *sb,
-					     u8 *tag)
+static int
+dr_ste_v0_build_eth_l3_ipv4_misc_tag(struct mlx5dr_match_param *value,
+				     struct mlx5dr_ste_build *sb,
+				     u8 *tag)
 {
 	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
 
@@ -1462,21 +1535,30 @@ static int dr_ste_build_eth_l3_ipv4_misc_tag(struct mlx5dr_match_param *value,
 	return 0;
 }
 
-void mlx5dr_ste_build_eth_l3_ipv4_misc(struct mlx5dr_ste_build *sb,
+static void
+dr_ste_v0_build_eth_l3_ipv4_misc_init(struct mlx5dr_ste_build *sb,
+				      struct mlx5dr_match_param *mask)
+{
+	dr_ste_v0_build_eth_l3_ipv4_misc_bit_mask(mask, sb->inner, sb->bit_mask);
+
+	sb->lu_type = DR_STE_CALC_LU_TYPE(ETHL3_IPV4_MISC, sb->rx, sb->inner);
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v0_build_eth_l3_ipv4_misc_tag;
+}
+
+void mlx5dr_ste_build_eth_l3_ipv4_misc(struct mlx5dr_ste_ctx *ste_ctx,
+				       struct mlx5dr_ste_build *sb,
 				       struct mlx5dr_match_param *mask,
 				       bool inner, bool rx)
 {
-	dr_ste_build_eth_l3_ipv4_misc_bit_mask(mask, inner, sb->bit_mask);
-
 	sb->rx = rx;
 	sb->inner = inner;
-	sb->lu_type = DR_STE_CALC_LU_TYPE(ETHL3_IPV4_MISC, rx, inner);
-	sb->byte_mask = dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_build_eth_l3_ipv4_misc_tag;
+	ste_ctx->build_eth_l3_ipv4_misc_init(sb, mask);
 }
 
-static void dr_ste_build_ipv6_l3_l4_bit_mask(struct mlx5dr_match_param *value,
-					     bool inner, u8 *bit_mask)
+static void
+dr_ste_v0_build_eth_ipv6_l3_l4_bit_mask(struct mlx5dr_match_param *value,
+					bool inner, u8 *bit_mask)
 {
 	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
 
@@ -1496,9 +1578,10 @@ static void dr_ste_build_ipv6_l3_l4_bit_mask(struct mlx5dr_match_param *value,
 	}
 }
 
-static int dr_ste_build_ipv6_l3_l4_tag(struct mlx5dr_match_param *value,
-				       struct mlx5dr_ste_build *sb,
-				       u8 *tag)
+static int
+dr_ste_v0_build_eth_ipv6_l3_l4_tag(struct mlx5dr_match_param *value,
+				   struct mlx5dr_ste_build *sb,
+				   u8 *tag)
 {
 	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
 
@@ -1520,17 +1603,25 @@ static int dr_ste_build_ipv6_l3_l4_tag(struct mlx5dr_match_param *value,
 	return 0;
 }
 
-void mlx5dr_ste_build_eth_ipv6_l3_l4(struct mlx5dr_ste_build *sb,
+static void
+dr_ste_v0_build_eth_ipv6_l3_l4_init(struct mlx5dr_ste_build *sb,
+				    struct mlx5dr_match_param *mask)
+{
+	dr_ste_v0_build_eth_ipv6_l3_l4_bit_mask(mask, sb->inner, sb->bit_mask);
+
+	sb->lu_type = DR_STE_CALC_LU_TYPE(ETHL4, sb->rx, sb->inner);
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v0_build_eth_ipv6_l3_l4_tag;
+}
+
+void mlx5dr_ste_build_eth_ipv6_l3_l4(struct mlx5dr_ste_ctx *ste_ctx,
+				     struct mlx5dr_ste_build *sb,
 				     struct mlx5dr_match_param *mask,
 				     bool inner, bool rx)
 {
-	dr_ste_build_ipv6_l3_l4_bit_mask(mask, inner, sb->bit_mask);
-
 	sb->rx = rx;
 	sb->inner = inner;
-	sb->lu_type = DR_STE_CALC_LU_TYPE(ETHL4, rx, inner);
-	sb->byte_mask = dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_build_ipv6_l3_l4_tag;
+	ste_ctx->build_eth_ipv6_l3_l4_init(sb, mask);
 }
 
 static int dr_ste_build_empty_always_hit_tag(struct mlx5dr_match_param *value,
@@ -1548,8 +1639,9 @@ void mlx5dr_ste_build_empty_always_hit(struct mlx5dr_ste_build *sb, bool rx)
 	sb->ste_build_tag_func = &dr_ste_build_empty_always_hit_tag;
 }
 
-static void dr_ste_build_mpls_bit_mask(struct mlx5dr_match_param *value,
-				       bool inner, u8 *bit_mask)
+static void
+dr_ste_v0_build_mpls_bit_mask(struct mlx5dr_match_param *value,
+			      bool inner, u8 *bit_mask)
 {
 	struct mlx5dr_match_misc2 *misc2_mask = &value->misc2;
 
@@ -1559,9 +1651,10 @@ static void dr_ste_build_mpls_bit_mask(struct mlx5dr_match_param *value,
 		DR_STE_SET_MPLS_MASK(mpls, misc2_mask, outer, bit_mask);
 }
 
-static int dr_ste_build_mpls_tag(struct mlx5dr_match_param *value,
-				 struct mlx5dr_ste_build *sb,
-				 u8 *tag)
+static int
+dr_ste_v0_build_mpls_tag(struct mlx5dr_match_param *value,
+			 struct mlx5dr_ste_build *sb,
+			 u8 *tag)
 {
 	struct mlx5dr_match_misc2 *misc2_mask = &value->misc2;
 
@@ -1573,21 +1666,30 @@ static int dr_ste_build_mpls_tag(struct mlx5dr_match_param *value,
 	return 0;
 }
 
-void mlx5dr_ste_build_mpls(struct mlx5dr_ste_build *sb,
+static void
+dr_ste_v0_build_mpls_init(struct mlx5dr_ste_build *sb,
+			  struct mlx5dr_match_param *mask)
+{
+	dr_ste_v0_build_mpls_bit_mask(mask, sb->inner, sb->bit_mask);
+
+	sb->lu_type = DR_STE_CALC_LU_TYPE(MPLS_FIRST, sb->rx, sb->inner);
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v0_build_mpls_tag;
+}
+
+void mlx5dr_ste_build_mpls(struct mlx5dr_ste_ctx *ste_ctx,
+			   struct mlx5dr_ste_build *sb,
 			   struct mlx5dr_match_param *mask,
 			   bool inner, bool rx)
 {
-	dr_ste_build_mpls_bit_mask(mask, inner, sb->bit_mask);
-
 	sb->rx = rx;
 	sb->inner = inner;
-	sb->lu_type = DR_STE_CALC_LU_TYPE(MPLS_FIRST, rx, inner);
-	sb->byte_mask = dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_build_mpls_tag;
+	ste_ctx->build_mpls_init(sb, mask);
 }
 
-static void dr_ste_build_gre_bit_mask(struct mlx5dr_match_param *value,
-				      bool inner, u8 *bit_mask)
+static void
+dr_ste_v0_build_tnl_gre_bit_mask(struct mlx5dr_match_param *value,
+				 bool inner, u8 *bit_mask)
 {
 	struct mlx5dr_match_misc *misc_mask = &value->misc;
 
@@ -1600,9 +1702,10 @@ static void dr_ste_build_gre_bit_mask(struct mlx5dr_match_param *value,
 	DR_STE_SET_MASK_V(gre, bit_mask, gre_s_present, misc_mask, gre_s_present);
 }
 
-static int dr_ste_build_gre_tag(struct mlx5dr_match_param *value,
-				struct mlx5dr_ste_build *sb,
-				u8 *tag)
+static int
+dr_ste_v0_build_tnl_gre_tag(struct mlx5dr_match_param *value,
+			    struct mlx5dr_ste_build *sb,
+			    u8 *tag)
 {
 	struct  mlx5dr_match_misc *misc = &value->misc;
 
@@ -1619,20 +1722,30 @@ static int dr_ste_build_gre_tag(struct mlx5dr_match_param *value,
 	return 0;
 }
 
-void mlx5dr_ste_build_tnl_gre(struct mlx5dr_ste_build *sb,
-			      struct mlx5dr_match_param *mask, bool inner, bool rx)
+static void
+dr_ste_v0_build_tnl_gre_init(struct mlx5dr_ste_build *sb,
+			     struct mlx5dr_match_param *mask)
 {
-	dr_ste_build_gre_bit_mask(mask, inner, sb->bit_mask);
+	dr_ste_v0_build_tnl_gre_bit_mask(mask, sb->inner, sb->bit_mask);
 
+	sb->lu_type = MLX5DR_STE_LU_TYPE_GRE;
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v0_build_tnl_gre_tag;
+}
+
+void mlx5dr_ste_build_tnl_gre(struct mlx5dr_ste_ctx *ste_ctx,
+			      struct mlx5dr_ste_build *sb,
+			      struct mlx5dr_match_param *mask,
+			      bool inner, bool rx)
+{
 	sb->rx = rx;
 	sb->inner = inner;
-	sb->lu_type = MLX5DR_STE_LU_TYPE_GRE;
-	sb->byte_mask = dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_build_gre_tag;
+	ste_ctx->build_tnl_gre_init(sb, mask);
 }
 
-static void dr_ste_build_flex_parser_0_bit_mask(struct mlx5dr_match_param *value,
-						bool inner, u8 *bit_mask)
+static void
+dr_ste_v0_build_tnl_mpls_bit_mask(struct mlx5dr_match_param *value,
+				  bool inner, u8 *bit_mask)
 {
 	struct mlx5dr_match_misc2 *misc_2_mask = &value->misc2;
 
@@ -1663,9 +1776,10 @@ static void dr_ste_build_flex_parser_0_bit_mask(struct mlx5dr_match_param *value
 	}
 }
 
-static int dr_ste_build_flex_parser_0_tag(struct mlx5dr_match_param *value,
-					  struct mlx5dr_ste_build *sb,
-					  u8 *tag)
+static int
+dr_ste_v0_build_tnl_mpls_tag(struct mlx5dr_match_param *value,
+			     struct mlx5dr_ste_build *sb,
+			     u8 *tag)
 {
 	struct mlx5dr_match_misc2 *misc_2_mask = &value->misc2;
 
@@ -1697,29 +1811,38 @@ static int dr_ste_build_flex_parser_0_tag(struct mlx5dr_match_param *value,
 	return 0;
 }
 
-void mlx5dr_ste_build_tnl_mpls(struct mlx5dr_ste_build *sb,
+static void
+dr_ste_v0_build_tnl_mpls_init(struct mlx5dr_ste_build *sb,
+			      struct mlx5dr_match_param *mask)
+{
+	dr_ste_v0_build_tnl_mpls_bit_mask(mask, sb->inner, sb->bit_mask);
+
+	sb->lu_type = MLX5DR_STE_LU_TYPE_FLEX_PARSER_0;
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v0_build_tnl_mpls_tag;
+}
+
+void mlx5dr_ste_build_tnl_mpls(struct mlx5dr_ste_ctx *ste_ctx,
+			       struct mlx5dr_ste_build *sb,
 			       struct mlx5dr_match_param *mask,
 			       bool inner, bool rx)
 {
-	dr_ste_build_flex_parser_0_bit_mask(mask, inner, sb->bit_mask);
-
 	sb->rx = rx;
 	sb->inner = inner;
-	sb->lu_type = MLX5DR_STE_LU_TYPE_FLEX_PARSER_0;
-	sb->byte_mask = dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_build_flex_parser_0_tag;
+	ste_ctx->build_tnl_mpls_init(sb, mask);
 }
 
 #define ICMP_TYPE_OFFSET_FIRST_DW		24
 #define ICMP_CODE_OFFSET_FIRST_DW		16
 #define ICMP_HEADER_DATA_OFFSET_SECOND_DW	0
 
-static int dr_ste_build_flex_parser_1_bit_mask(struct mlx5dr_match_param *mask,
-					       struct mlx5dr_cmd_caps *caps,
-					       u8 *bit_mask)
+static int
+dr_ste_v0_build_icmp_bit_mask(struct mlx5dr_match_param *mask,
+			      struct mlx5dr_cmd_caps *caps,
+			      u8 *bit_mask)
 {
-	bool is_ipv4_mask = DR_MASK_IS_ICMPV4_SET(&mask->misc3);
 	struct mlx5dr_match_misc3 *misc_3_mask = &mask->misc3;
+	bool is_ipv4_mask = DR_MASK_IS_ICMPV4_SET(misc_3_mask);
 	u32 icmp_header_data_mask;
 	u32 icmp_type_mask;
 	u32 icmp_code_mask;
@@ -1783,9 +1906,10 @@ static int dr_ste_build_flex_parser_1_bit_mask(struct mlx5dr_match_param *mask,
 	return 0;
 }
 
-static int dr_ste_build_flex_parser_1_tag(struct mlx5dr_match_param *value,
-					  struct mlx5dr_ste_build *sb,
-					  u8 *tag)
+static int
+dr_ste_v0_build_icmp_tag(struct mlx5dr_match_param *value,
+			 struct mlx5dr_ste_build *sb,
+			 u8 *tag)
 {
 	struct mlx5dr_match_misc3 *misc_3 = &value->misc3;
 	u32 icmp_header_data;
@@ -1854,29 +1978,38 @@ static int dr_ste_build_flex_parser_1_tag(struct mlx5dr_match_param *value,
 	return 0;
 }
 
-int mlx5dr_ste_build_icmp(struct mlx5dr_ste_build *sb,
-			  struct mlx5dr_match_param *mask,
-			  struct mlx5dr_cmd_caps *caps,
-			  bool inner, bool rx)
+static int
+dr_ste_v0_build_icmp_init(struct mlx5dr_ste_build *sb,
+			  struct mlx5dr_match_param *mask)
 {
 	int ret;
 
-	ret = dr_ste_build_flex_parser_1_bit_mask(mask, caps, sb->bit_mask);
+	ret = dr_ste_v0_build_icmp_bit_mask(mask, sb->caps, sb->bit_mask);
 	if (ret)
 		return ret;
 
-	sb->rx = rx;
-	sb->inner = inner;
-	sb->caps = caps;
 	sb->lu_type = MLX5DR_STE_LU_TYPE_FLEX_PARSER_1;
-	sb->byte_mask = dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_build_flex_parser_1_tag;
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v0_build_icmp_tag;
 
 	return 0;
 }
 
-static void dr_ste_build_general_purpose_bit_mask(struct mlx5dr_match_param *value,
-						  bool inner, u8 *bit_mask)
+int mlx5dr_ste_build_icmp(struct mlx5dr_ste_ctx *ste_ctx,
+			  struct mlx5dr_ste_build *sb,
+			  struct mlx5dr_match_param *mask,
+			  struct mlx5dr_cmd_caps *caps,
+			  bool inner, bool rx)
+{
+	sb->rx = rx;
+	sb->inner = inner;
+	sb->caps = caps;
+	return ste_ctx->build_icmp_init(sb, mask);
+}
+
+static void
+dr_ste_v0_build_general_purpose_bit_mask(struct mlx5dr_match_param *value,
+					 bool inner, u8 *bit_mask)
 {
 	struct mlx5dr_match_misc2 *misc_2_mask = &value->misc2;
 
@@ -1885,9 +2018,10 @@ static void dr_ste_build_general_purpose_bit_mask(struct mlx5dr_match_param *val
 			  metadata_reg_a);
 }
 
-static int dr_ste_build_general_purpose_tag(struct mlx5dr_match_param *value,
-					    struct mlx5dr_ste_build *sb,
-					    u8 *tag)
+static int
+dr_ste_v0_build_general_purpose_tag(struct mlx5dr_match_param *value,
+				    struct mlx5dr_ste_build *sb,
+				    u8 *tag)
 {
 	struct mlx5dr_match_misc2 *misc_2_mask = &value->misc2;
 
@@ -1897,21 +2031,30 @@ static int dr_ste_build_general_purpose_tag(struct mlx5dr_match_param *value,
 	return 0;
 }
 
-void mlx5dr_ste_build_general_purpose(struct mlx5dr_ste_build *sb,
+static void
+dr_ste_v0_build_general_purpose_init(struct mlx5dr_ste_build *sb,
+				     struct mlx5dr_match_param *mask)
+{
+	dr_ste_v0_build_general_purpose_bit_mask(mask, sb->inner, sb->bit_mask);
+
+	sb->lu_type = MLX5DR_STE_LU_TYPE_GENERAL_PURPOSE;
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v0_build_general_purpose_tag;
+}
+
+void mlx5dr_ste_build_general_purpose(struct mlx5dr_ste_ctx *ste_ctx,
+				      struct mlx5dr_ste_build *sb,
 				      struct mlx5dr_match_param *mask,
 				      bool inner, bool rx)
 {
-	dr_ste_build_general_purpose_bit_mask(mask, inner, sb->bit_mask);
-
 	sb->rx = rx;
 	sb->inner = inner;
-	sb->lu_type = MLX5DR_STE_LU_TYPE_GENERAL_PURPOSE;
-	sb->byte_mask = dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_build_general_purpose_tag;
+	ste_ctx->build_general_purpose_init(sb, mask);
 }
 
-static void dr_ste_build_eth_l4_misc_bit_mask(struct mlx5dr_match_param *value,
-					      bool inner, u8 *bit_mask)
+static void
+dr_ste_v0_build_eth_l4_misc_bit_mask(struct mlx5dr_match_param *value,
+				     bool inner, u8 *bit_mask)
 {
 	struct mlx5dr_match_misc3 *misc_3_mask = &value->misc3;
 
@@ -1928,9 +2071,10 @@ static void dr_ste_build_eth_l4_misc_bit_mask(struct mlx5dr_match_param *value,
 	}
 }
 
-static int dr_ste_build_eth_l4_misc_tag(struct mlx5dr_match_param *value,
-					struct mlx5dr_ste_build *sb,
-					u8 *tag)
+static int
+dr_ste_v0_build_eth_l4_misc_tag(struct mlx5dr_match_param *value,
+				struct mlx5dr_ste_build *sb,
+				u8 *tag)
 {
 	struct mlx5dr_match_misc3 *misc3 = &value->misc3;
 
@@ -1945,22 +2089,30 @@ static int dr_ste_build_eth_l4_misc_tag(struct mlx5dr_match_param *value,
 	return 0;
 }
 
-void mlx5dr_ste_build_eth_l4_misc(struct mlx5dr_ste_build *sb,
+static void
+dr_ste_v0_build_eth_l4_misc_init(struct mlx5dr_ste_build *sb,
+				 struct mlx5dr_match_param *mask)
+{
+	dr_ste_v0_build_eth_l4_misc_bit_mask(mask, sb->inner, sb->bit_mask);
+
+	sb->lu_type = DR_STE_CALC_LU_TYPE(ETHL4_MISC, sb->rx, sb->inner);
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v0_build_eth_l4_misc_tag;
+}
+
+void mlx5dr_ste_build_eth_l4_misc(struct mlx5dr_ste_ctx *ste_ctx,
+				  struct mlx5dr_ste_build *sb,
 				  struct mlx5dr_match_param *mask,
 				  bool inner, bool rx)
 {
-	dr_ste_build_eth_l4_misc_bit_mask(mask, inner, sb->bit_mask);
-
 	sb->rx = rx;
 	sb->inner = inner;
-	sb->lu_type = DR_STE_CALC_LU_TYPE(ETHL4_MISC, rx, inner);
-	sb->byte_mask = dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_build_eth_l4_misc_tag;
+	ste_ctx->build_eth_l4_misc_init(sb, mask);
 }
 
 static void
-dr_ste_build_flex_parser_tnl_vxlan_gpe_bit_mask(struct mlx5dr_match_param *value,
-						bool inner, u8 *bit_mask)
+dr_ste_v0_build_flex_parser_tnl_vxlan_gpe_bit_mask(struct mlx5dr_match_param *value,
+						   bool inner, u8 *bit_mask)
 {
 	struct mlx5dr_match_misc3 *misc_3_mask = &value->misc3;
 
@@ -1976,9 +2128,9 @@ dr_ste_build_flex_parser_tnl_vxlan_gpe_bit_mask(struct mlx5dr_match_param *value
 }
 
 static int
-dr_ste_build_flex_parser_tnl_vxlan_gpe_tag(struct mlx5dr_match_param *value,
-					   struct mlx5dr_ste_build *sb,
-					   u8 *tag)
+dr_ste_v0_build_flex_parser_tnl_vxlan_gpe_tag(struct mlx5dr_match_param *value,
+					      struct mlx5dr_ste_build *sb,
+					      u8 *tag)
 {
 	struct mlx5dr_match_misc3 *misc3 = &value->misc3;
 
@@ -1995,23 +2147,30 @@ dr_ste_build_flex_parser_tnl_vxlan_gpe_tag(struct mlx5dr_match_param *value,
 	return 0;
 }
 
-void mlx5dr_ste_build_tnl_vxlan_gpe(struct mlx5dr_ste_build *sb,
+static void
+dr_ste_v0_build_flex_parser_tnl_vxlan_gpe_init(struct mlx5dr_ste_build *sb,
+					       struct mlx5dr_match_param *mask)
+{
+	dr_ste_v0_build_flex_parser_tnl_vxlan_gpe_bit_mask(mask, sb->inner,
+							   sb->bit_mask);
+	sb->lu_type = MLX5DR_STE_LU_TYPE_FLEX_PARSER_TNL_HEADER;
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v0_build_flex_parser_tnl_vxlan_gpe_tag;
+}
+
+void mlx5dr_ste_build_tnl_vxlan_gpe(struct mlx5dr_ste_ctx *ste_ctx,
+				    struct mlx5dr_ste_build *sb,
 				    struct mlx5dr_match_param *mask,
 				    bool inner, bool rx)
 {
-	dr_ste_build_flex_parser_tnl_vxlan_gpe_bit_mask(mask, inner,
-							sb->bit_mask);
-
 	sb->rx = rx;
 	sb->inner = inner;
-	sb->lu_type = MLX5DR_STE_LU_TYPE_FLEX_PARSER_TNL_HEADER;
-	sb->byte_mask = dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_build_flex_parser_tnl_vxlan_gpe_tag;
+	ste_ctx->build_tnl_vxlan_gpe_init(sb, mask);
 }
 
 static void
-dr_ste_build_flex_parser_tnl_geneve_bit_mask(struct mlx5dr_match_param *value,
-					     u8 *bit_mask)
+dr_ste_v0_build_flex_parser_tnl_geneve_bit_mask(struct mlx5dr_match_param *value,
+						u8 *bit_mask)
 {
 	struct mlx5dr_match_misc *misc_mask = &value->misc;
 
@@ -2030,9 +2189,9 @@ dr_ste_build_flex_parser_tnl_geneve_bit_mask(struct mlx5dr_match_param *value,
 }
 
 static int
-dr_ste_build_flex_parser_tnl_geneve_tag(struct mlx5dr_match_param *value,
-					struct mlx5dr_ste_build *sb,
-					u8 *tag)
+dr_ste_v0_build_flex_parser_tnl_geneve_tag(struct mlx5dr_match_param *value,
+					   struct mlx5dr_ste_build *sb,
+					   u8 *tag)
 {
 	struct mlx5dr_match_misc *misc = &value->misc;
 
@@ -2048,20 +2207,29 @@ dr_ste_build_flex_parser_tnl_geneve_tag(struct mlx5dr_match_param *value,
 	return 0;
 }
 
-void mlx5dr_ste_build_tnl_geneve(struct mlx5dr_ste_build *sb,
+static void
+dr_ste_v0_build_flex_parser_tnl_geneve_init(struct mlx5dr_ste_build *sb,
+					    struct mlx5dr_match_param *mask)
+{
+	dr_ste_v0_build_flex_parser_tnl_geneve_bit_mask(mask, sb->bit_mask);
+	sb->lu_type = MLX5DR_STE_LU_TYPE_FLEX_PARSER_TNL_HEADER;
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v0_build_flex_parser_tnl_geneve_tag;
+}
+
+void mlx5dr_ste_build_tnl_geneve(struct mlx5dr_ste_ctx *ste_ctx,
+				 struct mlx5dr_ste_build *sb,
 				 struct mlx5dr_match_param *mask,
 				 bool inner, bool rx)
 {
-	dr_ste_build_flex_parser_tnl_geneve_bit_mask(mask, sb->bit_mask);
 	sb->rx = rx;
 	sb->inner = inner;
-	sb->lu_type = MLX5DR_STE_LU_TYPE_FLEX_PARSER_TNL_HEADER;
-	sb->byte_mask = dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_build_flex_parser_tnl_geneve_tag;
+	ste_ctx->build_tnl_geneve_init(sb, mask);
 }
 
-static void dr_ste_build_register_0_bit_mask(struct mlx5dr_match_param *value,
-					     u8 *bit_mask)
+static void
+dr_ste_v0_build_register_0_bit_mask(struct mlx5dr_match_param *value,
+				    u8 *bit_mask)
 {
 	struct mlx5dr_match_misc2 *misc_2_mask = &value->misc2;
 
@@ -2075,9 +2243,10 @@ static void dr_ste_build_register_0_bit_mask(struct mlx5dr_match_param *value,
 			  misc_2_mask, metadata_reg_c_3);
 }
 
-static int dr_ste_build_register_0_tag(struct mlx5dr_match_param *value,
-				       struct mlx5dr_ste_build *sb,
-				       u8 *tag)
+static int
+dr_ste_v0_build_register_0_tag(struct mlx5dr_match_param *value,
+			       struct mlx5dr_ste_build *sb,
+			       u8 *tag)
 {
 	struct mlx5dr_match_misc2 *misc2 = &value->misc2;
 
@@ -2089,21 +2258,30 @@ static int dr_ste_build_register_0_tag(struct mlx5dr_match_param *value,
 	return 0;
 }
 
-void mlx5dr_ste_build_register_0(struct mlx5dr_ste_build *sb,
+static void
+dr_ste_v0_build_register_0_init(struct mlx5dr_ste_build *sb,
+				struct mlx5dr_match_param *mask)
+{
+	dr_ste_v0_build_register_0_bit_mask(mask, sb->bit_mask);
+
+	sb->lu_type = MLX5DR_STE_LU_TYPE_STEERING_REGISTERS_0;
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v0_build_register_0_tag;
+}
+
+void mlx5dr_ste_build_register_0(struct mlx5dr_ste_ctx *ste_ctx,
+				 struct mlx5dr_ste_build *sb,
 				 struct mlx5dr_match_param *mask,
 				 bool inner, bool rx)
 {
-	dr_ste_build_register_0_bit_mask(mask, sb->bit_mask);
-
 	sb->rx = rx;
 	sb->inner = inner;
-	sb->lu_type = MLX5DR_STE_LU_TYPE_STEERING_REGISTERS_0;
-	sb->byte_mask = dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_build_register_0_tag;
+	ste_ctx->build_register_0_init(sb, mask);
 }
 
-static void dr_ste_build_register_1_bit_mask(struct mlx5dr_match_param *value,
-					     u8 *bit_mask)
+static void
+dr_ste_v0_build_register_1_bit_mask(struct mlx5dr_match_param *value,
+				    u8 *bit_mask)
 {
 	struct mlx5dr_match_misc2 *misc_2_mask = &value->misc2;
 
@@ -2117,9 +2295,10 @@ static void dr_ste_build_register_1_bit_mask(struct mlx5dr_match_param *value,
 			  misc_2_mask, metadata_reg_c_7);
 }
 
-static int dr_ste_build_register_1_tag(struct mlx5dr_match_param *value,
-				       struct mlx5dr_ste_build *sb,
-				       u8 *tag)
+static int
+dr_ste_v0_build_register_1_tag(struct mlx5dr_match_param *value,
+			       struct mlx5dr_ste_build *sb,
+			       u8 *tag)
 {
 	struct mlx5dr_match_misc2 *misc2 = &value->misc2;
 
@@ -2131,21 +2310,30 @@ static int dr_ste_build_register_1_tag(struct mlx5dr_match_param *value,
 	return 0;
 }
 
-void mlx5dr_ste_build_register_1(struct mlx5dr_ste_build *sb,
+static void
+dr_ste_v0_build_register_1_init(struct mlx5dr_ste_build *sb,
+				struct mlx5dr_match_param *mask)
+{
+	dr_ste_v0_build_register_1_bit_mask(mask, sb->bit_mask);
+
+	sb->lu_type = MLX5DR_STE_LU_TYPE_STEERING_REGISTERS_1;
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v0_build_register_1_tag;
+}
+
+void mlx5dr_ste_build_register_1(struct mlx5dr_ste_ctx *ste_ctx,
+				 struct mlx5dr_ste_build *sb,
 				 struct mlx5dr_match_param *mask,
 				 bool inner, bool rx)
 {
-	dr_ste_build_register_1_bit_mask(mask, sb->bit_mask);
-
 	sb->rx = rx;
 	sb->inner = inner;
-	sb->lu_type = MLX5DR_STE_LU_TYPE_STEERING_REGISTERS_1;
-	sb->byte_mask = dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_build_register_1_tag;
+	ste_ctx->build_register_1_init(sb, mask);
 }
 
-static void dr_ste_build_src_gvmi_qpn_bit_mask(struct mlx5dr_match_param *value,
-					       u8 *bit_mask)
+static void
+dr_ste_v0_build_src_gvmi_qpn_bit_mask(struct mlx5dr_match_param *value,
+				      u8 *bit_mask)
 {
 	struct mlx5dr_match_misc *misc_mask = &value->misc;
 
@@ -2154,9 +2342,10 @@ static void dr_ste_build_src_gvmi_qpn_bit_mask(struct mlx5dr_match_param *value,
 	misc_mask->source_eswitch_owner_vhca_id = 0;
 }
 
-static int dr_ste_build_src_gvmi_qpn_tag(struct mlx5dr_match_param *value,
-					 struct mlx5dr_ste_build *sb,
-					 u8 *tag)
+static int
+dr_ste_v0_build_src_gvmi_qpn_tag(struct mlx5dr_match_param *value,
+				 struct mlx5dr_ste_build *sb,
+				 u8 *tag)
 {
 	struct mlx5dr_match_misc *misc = &value->misc;
 	struct mlx5dr_cmd_vport_cap *vport_cap;
@@ -2181,8 +2370,11 @@ static int dr_ste_build_src_gvmi_qpn_tag(struct mlx5dr_match_param *value,
 	}
 
 	vport_cap = mlx5dr_get_vport_cap(caps, misc->source_port);
-	if (!vport_cap)
+	if (!vport_cap) {
+		mlx5dr_err(dmn, "Vport 0x%x is invalid\n",
+			   misc->source_port);
 		return -EINVAL;
+	}
 
 	source_gvmi_set = MLX5_GET(ste_src_gvmi_qp, bit_mask, source_gvmi);
 	if (vport_cap->vport_gvmi && source_gvmi_set)
@@ -2194,7 +2386,19 @@ static int dr_ste_build_src_gvmi_qpn_tag(struct mlx5dr_match_param *value,
 	return 0;
 }
 
-void mlx5dr_ste_build_src_gvmi_qpn(struct mlx5dr_ste_build *sb,
+static void
+dr_ste_v0_build_src_gvmi_qpn_init(struct mlx5dr_ste_build *sb,
+				  struct mlx5dr_match_param *mask)
+{
+	dr_ste_v0_build_src_gvmi_qpn_bit_mask(mask, sb->bit_mask);
+
+	sb->lu_type = MLX5DR_STE_LU_TYPE_SRC_GVMI_AND_QP;
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v0_build_src_gvmi_qpn_tag;
+}
+
+void mlx5dr_ste_build_src_gvmi_qpn(struct mlx5dr_ste_ctx *ste_ctx,
+				   struct mlx5dr_ste_build *sb,
 				   struct mlx5dr_match_param *mask,
 				   struct mlx5dr_domain *dmn,
 				   bool inner, bool rx)
@@ -2202,12 +2406,44 @@ void mlx5dr_ste_build_src_gvmi_qpn(struct mlx5dr_ste_build *sb,
 	/* Set vhca_id_valid before we reset source_eswitch_owner_vhca_id */
 	sb->vhca_id_valid = mask->misc.source_eswitch_owner_vhca_id;
 
-	dr_ste_build_src_gvmi_qpn_bit_mask(mask, sb->bit_mask);
-
 	sb->rx = rx;
 	sb->dmn = dmn;
 	sb->inner = inner;
-	sb->lu_type = MLX5DR_STE_LU_TYPE_SRC_GVMI_AND_QP;
-	sb->byte_mask = dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_build_src_gvmi_qpn_tag;
+	ste_ctx->build_src_gvmi_qpn_init(sb, mask);
+}
+
+static struct mlx5dr_ste_ctx ste_ctx_v0 = {
+	.build_eth_l2_src_dst_init	= &dr_ste_v0_build_eth_l2_src_dst_init,
+	.build_eth_l3_ipv6_src_init	= &dr_ste_v0_build_eth_l3_ipv6_src_init,
+	.build_eth_l3_ipv6_dst_init	= &dr_ste_v0_build_eth_l3_ipv6_dst_init,
+	.build_eth_l3_ipv4_5_tuple_init	= &dr_ste_v0_build_eth_l3_ipv4_5_tuple_init,
+	.build_eth_l2_src_init		= &dr_ste_v0_build_eth_l2_src_init,
+	.build_eth_l2_dst_init		= &dr_ste_v0_build_eth_l2_dst_init,
+	.build_eth_l2_tnl_init		= &dr_ste_v0_build_eth_l2_tnl_init,
+	.build_eth_l3_ipv4_misc_init	= &dr_ste_v0_build_eth_l3_ipv4_misc_init,
+	.build_eth_ipv6_l3_l4_init	= &dr_ste_v0_build_eth_ipv6_l3_l4_init,
+	.build_mpls_init		= &dr_ste_v0_build_mpls_init,
+	.build_tnl_gre_init		= &dr_ste_v0_build_tnl_gre_init,
+	.build_tnl_mpls_init		= &dr_ste_v0_build_tnl_mpls_init,
+	.build_icmp_init		= &dr_ste_v0_build_icmp_init,
+	.build_general_purpose_init	= &dr_ste_v0_build_general_purpose_init,
+	.build_eth_l4_misc_init		= &dr_ste_v0_build_eth_l4_misc_init,
+	.build_tnl_vxlan_gpe_init	= &dr_ste_v0_build_flex_parser_tnl_vxlan_gpe_init,
+	.build_tnl_geneve_init		= &dr_ste_v0_build_flex_parser_tnl_geneve_init,
+	.build_register_0_init		= &dr_ste_v0_build_register_0_init,
+	.build_register_1_init		= &dr_ste_v0_build_register_1_init,
+	.build_src_gvmi_qpn_init	= &dr_ste_v0_build_src_gvmi_qpn_init,
+};
+
+static struct mlx5dr_ste_ctx *mlx5dr_ste_ctx_arr[] = {
+	[MLX5_STEERING_FORMAT_CONNECTX_5] = &ste_ctx_v0,
+	[MLX5_STEERING_FORMAT_CONNECTX_6DX] = NULL,
+};
+
+struct mlx5dr_ste_ctx *mlx5dr_ste_get_ctx(u8 version)
+{
+	if (version > MLX5_STEERING_FORMAT_CONNECTX_6DX)
+		return NULL;
+
+	return mlx5dr_ste_ctx_arr[version];
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
index 1bc8fa31c04e..ed91d98330b9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
@@ -82,6 +82,8 @@
 	(_misc)->outer_first_mpls_over_udp_s_bos || \
 	(_misc)->outer_first_mpls_over_udp_ttl)
 
+u16 mlx5dr_ste_conv_bit_to_byte_mask(u8 *bit_mask);
+
 #define DR_STE_CTX_BUILDER(fname) \
 	((*build_##fname##_init)(struct mlx5dr_ste_build *sb, \
 				 struct mlx5dr_match_param *mask))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 51880df26724..aef88bcc6fc3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -120,6 +120,7 @@ struct mlx5dr_ste_htbl;
 struct mlx5dr_match_param;
 struct mlx5dr_cmd_caps;
 struct mlx5dr_matcher_rx_tx;
+struct mlx5dr_ste_ctx;
 
 struct mlx5dr_ste {
 	u8 *hw_ste;
@@ -248,6 +249,7 @@ u64 mlx5dr_ste_get_icm_addr(struct mlx5dr_ste *ste);
 u64 mlx5dr_ste_get_mr_addr(struct mlx5dr_ste *ste);
 struct list_head *mlx5dr_ste_get_miss_list(struct mlx5dr_ste *ste);
 
+struct mlx5dr_ste_ctx *mlx5dr_ste_get_ctx(u8 version);
 void mlx5dr_ste_free(struct mlx5dr_ste *ste,
 		     struct mlx5dr_matcher *matcher,
 		     struct mlx5dr_matcher_rx_tx *nic_matcher);
@@ -289,65 +291,85 @@ int mlx5dr_ste_build_ste_arr(struct mlx5dr_matcher *matcher,
 			     struct mlx5dr_matcher_rx_tx *nic_matcher,
 			     struct mlx5dr_match_param *value,
 			     u8 *ste_arr);
-void mlx5dr_ste_build_eth_l2_src_dst(struct mlx5dr_ste_build *builder,
+void mlx5dr_ste_build_eth_l2_src_dst(struct mlx5dr_ste_ctx *ste_ctx,
+				     struct mlx5dr_ste_build *builder,
 				     struct mlx5dr_match_param *mask,
 				     bool inner, bool rx);
-void mlx5dr_ste_build_eth_l3_ipv4_5_tuple(struct mlx5dr_ste_build *sb,
+void mlx5dr_ste_build_eth_l3_ipv4_5_tuple(struct mlx5dr_ste_ctx *ste_ctx,
+					  struct mlx5dr_ste_build *sb,
 					  struct mlx5dr_match_param *mask,
 					  bool inner, bool rx);
-void mlx5dr_ste_build_eth_l3_ipv4_misc(struct mlx5dr_ste_build *sb,
+void mlx5dr_ste_build_eth_l3_ipv4_misc(struct mlx5dr_ste_ctx *ste_ctx,
+				       struct mlx5dr_ste_build *sb,
 				       struct mlx5dr_match_param *mask,
 				       bool inner, bool rx);
-void mlx5dr_ste_build_eth_l3_ipv6_dst(struct mlx5dr_ste_build *sb,
+void mlx5dr_ste_build_eth_l3_ipv6_dst(struct mlx5dr_ste_ctx *ste_ctx,
+				      struct mlx5dr_ste_build *sb,
 				      struct mlx5dr_match_param *mask,
 				      bool inner, bool rx);
-void mlx5dr_ste_build_eth_l3_ipv6_src(struct mlx5dr_ste_build *sb,
+void mlx5dr_ste_build_eth_l3_ipv6_src(struct mlx5dr_ste_ctx *ste_ctx,
+				      struct mlx5dr_ste_build *sb,
 				      struct mlx5dr_match_param *mask,
 				      bool inner, bool rx);
-void mlx5dr_ste_build_eth_l2_src(struct mlx5dr_ste_build *sb,
+void mlx5dr_ste_build_eth_l2_src(struct mlx5dr_ste_ctx *ste_ctx,
+				 struct mlx5dr_ste_build *sb,
 				 struct mlx5dr_match_param *mask,
 				 bool inner, bool rx);
-void mlx5dr_ste_build_eth_l2_dst(struct mlx5dr_ste_build *sb,
+void mlx5dr_ste_build_eth_l2_dst(struct mlx5dr_ste_ctx *ste_ctx,
+				 struct mlx5dr_ste_build *sb,
 				 struct mlx5dr_match_param *mask,
 				 bool inner, bool rx);
-void mlx5dr_ste_build_eth_l2_tnl(struct mlx5dr_ste_build *sb,
+void mlx5dr_ste_build_eth_l2_tnl(struct mlx5dr_ste_ctx *ste_ctx,
+				 struct mlx5dr_ste_build *sb,
 				 struct mlx5dr_match_param *mask,
 				 bool inner, bool rx);
-void mlx5dr_ste_build_eth_ipv6_l3_l4(struct mlx5dr_ste_build *sb,
+void mlx5dr_ste_build_eth_ipv6_l3_l4(struct mlx5dr_ste_ctx *ste_ctx,
+				     struct mlx5dr_ste_build *sb,
 				     struct mlx5dr_match_param *mask,
 				     bool inner, bool rx);
-void mlx5dr_ste_build_eth_l4_misc(struct mlx5dr_ste_build *sb,
+void mlx5dr_ste_build_eth_l4_misc(struct mlx5dr_ste_ctx *ste_ctx,
+				  struct mlx5dr_ste_build *sb,
 				  struct mlx5dr_match_param *mask,
 				  bool inner, bool rx);
-void mlx5dr_ste_build_tnl_gre(struct mlx5dr_ste_build *sb,
+void mlx5dr_ste_build_tnl_gre(struct mlx5dr_ste_ctx *ste_ctx,
+			      struct mlx5dr_ste_build *sb,
 			      struct mlx5dr_match_param *mask,
 			      bool inner, bool rx);
-void mlx5dr_ste_build_mpls(struct mlx5dr_ste_build *sb,
+void mlx5dr_ste_build_mpls(struct mlx5dr_ste_ctx *ste_ctx,
+			   struct mlx5dr_ste_build *sb,
 			   struct mlx5dr_match_param *mask,
 			   bool inner, bool rx);
-void mlx5dr_ste_build_tnl_mpls(struct mlx5dr_ste_build *sb,
+void mlx5dr_ste_build_tnl_mpls(struct mlx5dr_ste_ctx *ste_ctx,
+			       struct mlx5dr_ste_build *sb,
 			       struct mlx5dr_match_param *mask,
 			       bool inner, bool rx);
-int mlx5dr_ste_build_icmp(struct mlx5dr_ste_build *sb,
+int mlx5dr_ste_build_icmp(struct mlx5dr_ste_ctx *ste_ctx,
+			  struct mlx5dr_ste_build *sb,
 			  struct mlx5dr_match_param *mask,
 			  struct mlx5dr_cmd_caps *caps,
 			  bool inner, bool rx);
-void mlx5dr_ste_build_tnl_vxlan_gpe(struct mlx5dr_ste_build *sb,
+void mlx5dr_ste_build_tnl_vxlan_gpe(struct mlx5dr_ste_ctx *ste_ctx,
+				    struct mlx5dr_ste_build *sb,
 				    struct mlx5dr_match_param *mask,
 				    bool inner, bool rx);
-void mlx5dr_ste_build_tnl_geneve(struct mlx5dr_ste_build *sb,
+void mlx5dr_ste_build_tnl_geneve(struct mlx5dr_ste_ctx *ste_ctx,
+				 struct mlx5dr_ste_build *sb,
 				 struct mlx5dr_match_param *mask,
 				 bool inner, bool rx);
-void mlx5dr_ste_build_general_purpose(struct mlx5dr_ste_build *sb,
+void mlx5dr_ste_build_general_purpose(struct mlx5dr_ste_ctx *ste_ctx,
+				      struct mlx5dr_ste_build *sb,
 				      struct mlx5dr_match_param *mask,
 				      bool inner, bool rx);
-void mlx5dr_ste_build_register_0(struct mlx5dr_ste_build *sb,
+void mlx5dr_ste_build_register_0(struct mlx5dr_ste_ctx *ste_ctx,
+				 struct mlx5dr_ste_build *sb,
 				 struct mlx5dr_match_param *mask,
 				 bool inner, bool rx);
-void mlx5dr_ste_build_register_1(struct mlx5dr_ste_build *sb,
+void mlx5dr_ste_build_register_1(struct mlx5dr_ste_ctx *ste_ctx,
+				 struct mlx5dr_ste_build *sb,
 				 struct mlx5dr_match_param *mask,
 				 bool inner, bool rx);
-void mlx5dr_ste_build_src_gvmi_qpn(struct mlx5dr_ste_build *sb,
+void mlx5dr_ste_build_src_gvmi_qpn(struct mlx5dr_ste_ctx *ste_ctx,
+				   struct mlx5dr_ste_build *sb,
 				   struct mlx5dr_match_param *mask,
 				   struct mlx5dr_domain *dmn,
 				   bool inner, bool rx);
@@ -671,6 +693,7 @@ struct mlx5dr_domain {
 	struct mlx5dr_send_ring *send_ring;
 	struct mlx5dr_domain_info info;
 	struct mlx5dr_domain_cache cache;
+	struct mlx5dr_ste_ctx *ste_ctx;
 };
 
 struct mlx5dr_table_rx_tx {
-- 
2.26.2

