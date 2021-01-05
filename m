Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA822EB5CD
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 00:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726499AbhAEXF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 18:05:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:57214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbhAEXFz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 18:05:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A792230F9;
        Tue,  5 Jan 2021 23:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609887909;
        bh=4NfyC5rR4fCQkOfNJjs1yRryfqSEifELptVYM6yiX8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a0QHm/1Kg21lxLYTfJ/Sf+Hjnp4pXiA8ULizWQqCbdqxCWbgQUk0nwk16VBZoRKc0
         aAOHirlTTs6jN6DrsMF8iWP22zf3g86hWC8hgXq9OLSYqTsagfM9Pu/LwPLXntW7QN
         9aVh0ZtUQGXdoWvY/KDOXiBcvXIeyEF892NBGvxUGbqqeRykADOwIksgGDV06Z3QKd
         FA9Rhh8LgZLEF3lr/ARb45NJ8EvQ3XNTIG3cJYBuks82vrAEYzxOcfevMjC0UIa/xm
         xjcRZcBdObhrVKGJrtJ9tL3NTZzXeJZn35Z+AzBoqzGimy+BmUy1sfva1Mus+TWDlq
         i3fcmdUTspHjA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/16] net/mlx5: DR, Move HW STEv0 match logic to a separate file
Date:   Tue,  5 Jan 2021 15:03:21 -0800
Message-Id: <20210105230333.239456-5-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210105230333.239456-1-saeed@kernel.org>
References: <20210105230333.239456-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Move current STE match logic to a seprate file.
This file will be used for HW specific STEv0.

Future patches will add functionality for v1 steering.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |    1 +
 .../mellanox/mlx5/core/steering/dr_ste.c      | 1279 ----------------
 .../mellanox/mlx5/core/steering/dr_ste.h      |    2 +
 .../mellanox/mlx5/core/steering/dr_ste_v0.c   | 1283 +++++++++++++++++
 4 files changed, 1286 insertions(+), 1279 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 77961643d5a9..134bd038ae8a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -83,5 +83,6 @@ mlx5_core-$(CONFIG_MLX5_SW_STEERING) += steering/dr_domain.o steering/dr_table.o
 					steering/dr_matcher.o steering/dr_rule.o \
 					steering/dr_icm_pool.o steering/dr_buddy.o \
 					steering/dr_ste.o steering/dr_send.o \
+					steering/dr_ste_v0.o \
 					steering/dr_cmd.o steering/dr_fw.o \
 					steering/dr_action.o steering/fs_dr.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 9d88491ce81b..64c387860f79 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -9,11 +9,6 @@
 
 #define DR_STE_ENABLE_FLOW_TAG BIT(31)
 
-#define DR_STE_CALC_LU_TYPE(lookup_type, rx, inner) \
-	((inner) ? MLX5DR_STE_LU_TYPE_##lookup_type##_I : \
-		   (rx) ? MLX5DR_STE_LU_TYPE_##lookup_type##_D : \
-			  MLX5DR_STE_LU_TYPE_##lookup_type##_O)
-
 enum dr_ste_tunl_action {
 	DR_STE_TUNL_ACTION_NONE		= 0,
 	DR_STE_TUNL_ACTION_ENABLE	= 1,
@@ -940,95 +935,6 @@ void mlx5dr_ste_copy_param(u8 match_criteria,
 	}
 }
 
-static void
-dr_ste_v0_build_eth_l2_src_dst_bit_mask(struct mlx5dr_match_param *value,
-					bool inner, u8 *bit_mask)
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
-static int
-dr_ste_v0_build_eth_l2_src_dst_tag(struct mlx5dr_match_param *value,
-				   struct mlx5dr_ste_build *sb,
-				   u8 *tag)
-{
-	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
-
-	DR_STE_SET_TAG(eth_l2_src_dst, tag, dmac_47_16, spec, dmac_47_16);
-	DR_STE_SET_TAG(eth_l2_src_dst, tag, dmac_15_0, spec, dmac_15_0);
-
-	if (spec->smac_47_16 || spec->smac_15_0) {
-		MLX5_SET(ste_eth_l2_src_dst, tag, smac_47_32,
-			 spec->smac_47_16 >> 16);
-		MLX5_SET(ste_eth_l2_src_dst, tag, smac_31_0,
-			 spec->smac_47_16 << 16 | spec->smac_15_0);
-		spec->smac_47_16 = 0;
-		spec->smac_15_0 = 0;
-	}
-
-	if (spec->ip_version) {
-		if (spec->ip_version == IP_VERSION_IPV4) {
-			MLX5_SET(ste_eth_l2_src_dst, tag, l3_type, STE_IPV4);
-			spec->ip_version = 0;
-		} else if (spec->ip_version == IP_VERSION_IPV6) {
-			MLX5_SET(ste_eth_l2_src_dst, tag, l3_type, STE_IPV6);
-			spec->ip_version = 0;
-		} else {
-			pr_info("Unsupported ip_version value\n");
-			return -EINVAL;
-		}
-	}
-
-	DR_STE_SET_TAG(eth_l2_src_dst, tag, first_vlan_id, spec, first_vid);
-	DR_STE_SET_TAG(eth_l2_src_dst, tag, first_cfi, spec, first_cfi);
-	DR_STE_SET_TAG(eth_l2_src_dst, tag, first_priority, spec, first_prio);
-
-	if (spec->cvlan_tag) {
-		MLX5_SET(ste_eth_l2_src_dst, tag, first_vlan_qualifier, DR_STE_CVLAN);
-		spec->cvlan_tag = 0;
-	} else if (spec->svlan_tag) {
-		MLX5_SET(ste_eth_l2_src_dst, tag, first_vlan_qualifier, DR_STE_SVLAN);
-		spec->svlan_tag = 0;
-	}
-	return 0;
-}
-
-static void
-dr_ste_v0_build_eth_l2_src_dst_init(struct mlx5dr_ste_build *sb,
-				    struct mlx5dr_match_param *mask)
-{
-	dr_ste_v0_build_eth_l2_src_dst_bit_mask(mask, sb->inner, sb->bit_mask);
-
-	sb->lu_type = DR_STE_CALC_LU_TYPE(ETHL2_SRC_DST, sb->rx, sb->inner);
-	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_v0_build_eth_l2_src_dst_tag;
-}
-
 void mlx5dr_ste_build_eth_l2_src_dst(struct mlx5dr_ste_ctx *ste_ctx,
 				     struct mlx5dr_ste_build *sb,
 				     struct mlx5dr_match_param *mask,
@@ -1039,44 +945,6 @@ void mlx5dr_ste_build_eth_l2_src_dst(struct mlx5dr_ste_ctx *ste_ctx,
 	ste_ctx->build_eth_l2_src_dst_init(sb, mask);
 }
 
-static void
-dr_ste_v0_build_eth_l3_ipv6_dst_bit_mask(struct mlx5dr_match_param *value,
-					 bool inner, u8 *bit_mask)
-{
-	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
-
-	DR_STE_SET_MASK_V(eth_l3_ipv6_dst, bit_mask, dst_ip_127_96, mask, dst_ip_127_96);
-	DR_STE_SET_MASK_V(eth_l3_ipv6_dst, bit_mask, dst_ip_95_64, mask, dst_ip_95_64);
-	DR_STE_SET_MASK_V(eth_l3_ipv6_dst, bit_mask, dst_ip_63_32, mask, dst_ip_63_32);
-	DR_STE_SET_MASK_V(eth_l3_ipv6_dst, bit_mask, dst_ip_31_0, mask, dst_ip_31_0);
-}
-
-static int
-dr_ste_v0_build_eth_l3_ipv6_dst_tag(struct mlx5dr_match_param *value,
-				    struct mlx5dr_ste_build *sb,
-				    u8 *tag)
-{
-	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
-
-	DR_STE_SET_TAG(eth_l3_ipv6_dst, tag, dst_ip_127_96, spec, dst_ip_127_96);
-	DR_STE_SET_TAG(eth_l3_ipv6_dst, tag, dst_ip_95_64, spec, dst_ip_95_64);
-	DR_STE_SET_TAG(eth_l3_ipv6_dst, tag, dst_ip_63_32, spec, dst_ip_63_32);
-	DR_STE_SET_TAG(eth_l3_ipv6_dst, tag, dst_ip_31_0, spec, dst_ip_31_0);
-
-	return 0;
-}
-
-static void
-dr_ste_v0_build_eth_l3_ipv6_dst_init(struct mlx5dr_ste_build *sb,
-				     struct mlx5dr_match_param *mask)
-{
-	dr_ste_v0_build_eth_l3_ipv6_dst_bit_mask(mask, sb->inner, sb->bit_mask);
-
-	sb->lu_type = DR_STE_CALC_LU_TYPE(ETHL3_IPV6_DST, sb->rx, sb->inner);
-	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_v0_build_eth_l3_ipv6_dst_tag;
-}
-
 void mlx5dr_ste_build_eth_l3_ipv6_dst(struct mlx5dr_ste_ctx *ste_ctx,
 				      struct mlx5dr_ste_build *sb,
 				      struct mlx5dr_match_param *mask,
@@ -1087,44 +955,6 @@ void mlx5dr_ste_build_eth_l3_ipv6_dst(struct mlx5dr_ste_ctx *ste_ctx,
 	ste_ctx->build_eth_l3_ipv6_dst_init(sb, mask);
 }
 
-static void
-dr_ste_v0_build_eth_l3_ipv6_src_bit_mask(struct mlx5dr_match_param *value,
-					 bool inner, u8 *bit_mask)
-{
-	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
-
-	DR_STE_SET_MASK_V(eth_l3_ipv6_src, bit_mask, src_ip_127_96, mask, src_ip_127_96);
-	DR_STE_SET_MASK_V(eth_l3_ipv6_src, bit_mask, src_ip_95_64, mask, src_ip_95_64);
-	DR_STE_SET_MASK_V(eth_l3_ipv6_src, bit_mask, src_ip_63_32, mask, src_ip_63_32);
-	DR_STE_SET_MASK_V(eth_l3_ipv6_src, bit_mask, src_ip_31_0, mask, src_ip_31_0);
-}
-
-static int
-dr_ste_v0_build_eth_l3_ipv6_src_tag(struct mlx5dr_match_param *value,
-				    struct mlx5dr_ste_build *sb,
-				    u8 *tag)
-{
-	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
-
-	DR_STE_SET_TAG(eth_l3_ipv6_src, tag, src_ip_127_96, spec, src_ip_127_96);
-	DR_STE_SET_TAG(eth_l3_ipv6_src, tag, src_ip_95_64, spec, src_ip_95_64);
-	DR_STE_SET_TAG(eth_l3_ipv6_src, tag, src_ip_63_32, spec, src_ip_63_32);
-	DR_STE_SET_TAG(eth_l3_ipv6_src, tag, src_ip_31_0, spec, src_ip_31_0);
-
-	return 0;
-}
-
-static void
-dr_ste_v0_build_eth_l3_ipv6_src_init(struct mlx5dr_ste_build *sb,
-				     struct mlx5dr_match_param *mask)
-{
-	dr_ste_v0_build_eth_l3_ipv6_src_bit_mask(mask, sb->inner, sb->bit_mask);
-
-	sb->lu_type = DR_STE_CALC_LU_TYPE(ETHL3_IPV6_SRC, sb->rx, sb->inner);
-	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_v0_build_eth_l3_ipv6_src_tag;
-}
-
 void mlx5dr_ste_build_eth_l3_ipv6_src(struct mlx5dr_ste_ctx *ste_ctx,
 				      struct mlx5dr_ste_build *sb,
 				      struct mlx5dr_match_param *mask,
@@ -1135,77 +965,6 @@ void mlx5dr_ste_build_eth_l3_ipv6_src(struct mlx5dr_ste_ctx *ste_ctx,
 	ste_ctx->build_eth_l3_ipv6_src_init(sb, mask);
 }
 
-static void
-dr_ste_v0_build_eth_l3_ipv4_5_tuple_bit_mask(struct mlx5dr_match_param *value,
-					     bool inner,
-					     u8 *bit_mask)
-{
-	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
-
-	DR_STE_SET_MASK_V(eth_l3_ipv4_5_tuple, bit_mask,
-			  destination_address, mask, dst_ip_31_0);
-	DR_STE_SET_MASK_V(eth_l3_ipv4_5_tuple, bit_mask,
-			  source_address, mask, src_ip_31_0);
-	DR_STE_SET_MASK_V(eth_l3_ipv4_5_tuple, bit_mask,
-			  destination_port, mask, tcp_dport);
-	DR_STE_SET_MASK_V(eth_l3_ipv4_5_tuple, bit_mask,
-			  destination_port, mask, udp_dport);
-	DR_STE_SET_MASK_V(eth_l3_ipv4_5_tuple, bit_mask,
-			  source_port, mask, tcp_sport);
-	DR_STE_SET_MASK_V(eth_l3_ipv4_5_tuple, bit_mask,
-			  source_port, mask, udp_sport);
-	DR_STE_SET_MASK_V(eth_l3_ipv4_5_tuple, bit_mask,
-			  protocol, mask, ip_protocol);
-	DR_STE_SET_MASK_V(eth_l3_ipv4_5_tuple, bit_mask,
-			  fragmented, mask, frag);
-	DR_STE_SET_MASK_V(eth_l3_ipv4_5_tuple, bit_mask,
-			  dscp, mask, ip_dscp);
-	DR_STE_SET_MASK_V(eth_l3_ipv4_5_tuple, bit_mask,
-			  ecn, mask, ip_ecn);
-
-	if (mask->tcp_flags) {
-		DR_STE_SET_TCP_FLAGS(eth_l3_ipv4_5_tuple, bit_mask, mask);
-		mask->tcp_flags = 0;
-	}
-}
-
-static int
-dr_ste_v0_build_eth_l3_ipv4_5_tuple_tag(struct mlx5dr_match_param *value,
-					struct mlx5dr_ste_build *sb,
-					u8 *tag)
-{
-	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
-
-	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple, tag, destination_address, spec, dst_ip_31_0);
-	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple, tag, source_address, spec, src_ip_31_0);
-	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple, tag, destination_port, spec, tcp_dport);
-	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple, tag, destination_port, spec, udp_dport);
-	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple, tag, source_port, spec, tcp_sport);
-	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple, tag, source_port, spec, udp_sport);
-	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple, tag, protocol, spec, ip_protocol);
-	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple, tag, fragmented, spec, frag);
-	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple, tag, dscp, spec, ip_dscp);
-	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple, tag, ecn, spec, ip_ecn);
-
-	if (spec->tcp_flags) {
-		DR_STE_SET_TCP_FLAGS(eth_l3_ipv4_5_tuple, tag, spec);
-		spec->tcp_flags = 0;
-	}
-
-	return 0;
-}
-
-static void
-dr_ste_v0_build_eth_l3_ipv4_5_tuple_init(struct mlx5dr_ste_build *sb,
-					 struct mlx5dr_match_param *mask)
-{
-	dr_ste_v0_build_eth_l3_ipv4_5_tuple_bit_mask(mask, sb->inner, sb->bit_mask);
-
-	sb->lu_type = DR_STE_CALC_LU_TYPE(ETHL3_IPV4_5_TUPLE, sb->rx, sb->inner);
-	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_v0_build_eth_l3_ipv4_5_tuple_tag;
-}
-
 void mlx5dr_ste_build_eth_l3_ipv4_5_tuple(struct mlx5dr_ste_ctx *ste_ctx,
 					  struct mlx5dr_ste_build *sb,
 					  struct mlx5dr_match_param *mask,
@@ -1216,154 +975,6 @@ void mlx5dr_ste_build_eth_l3_ipv4_5_tuple(struct mlx5dr_ste_ctx *ste_ctx,
 	ste_ctx->build_eth_l3_ipv4_5_tuple_init(sb, mask);
 }
 
-static void
-dr_ste_v0_build_eth_l2_src_or_dst_bit_mask(struct mlx5dr_match_param *value,
-					   bool inner, u8 *bit_mask)
-{
-	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
-	struct mlx5dr_match_misc *misc_mask = &value->misc;
-
-	DR_STE_SET_MASK_V(eth_l2_src, bit_mask, first_vlan_id, mask, first_vid);
-	DR_STE_SET_MASK_V(eth_l2_src, bit_mask, first_cfi, mask, first_cfi);
-	DR_STE_SET_MASK_V(eth_l2_src, bit_mask, first_priority, mask, first_prio);
-	DR_STE_SET_MASK_V(eth_l2_src, bit_mask, ip_fragmented, mask, frag);
-	DR_STE_SET_MASK_V(eth_l2_src, bit_mask, l3_ethertype, mask, ethertype);
-	DR_STE_SET_MASK(eth_l2_src, bit_mask, l3_type, mask, ip_version);
-
-	if (mask->svlan_tag || mask->cvlan_tag) {
-		MLX5_SET(ste_eth_l2_src, bit_mask, first_vlan_qualifier, -1);
-		mask->cvlan_tag = 0;
-		mask->svlan_tag = 0;
-	}
-
-	if (inner) {
-		if (misc_mask->inner_second_cvlan_tag ||
-		    misc_mask->inner_second_svlan_tag) {
-			MLX5_SET(ste_eth_l2_src, bit_mask, second_vlan_qualifier, -1);
-			misc_mask->inner_second_cvlan_tag = 0;
-			misc_mask->inner_second_svlan_tag = 0;
-		}
-
-		DR_STE_SET_MASK_V(eth_l2_src, bit_mask,
-				  second_vlan_id, misc_mask, inner_second_vid);
-		DR_STE_SET_MASK_V(eth_l2_src, bit_mask,
-				  second_cfi, misc_mask, inner_second_cfi);
-		DR_STE_SET_MASK_V(eth_l2_src, bit_mask,
-				  second_priority, misc_mask, inner_second_prio);
-	} else {
-		if (misc_mask->outer_second_cvlan_tag ||
-		    misc_mask->outer_second_svlan_tag) {
-			MLX5_SET(ste_eth_l2_src, bit_mask, second_vlan_qualifier, -1);
-			misc_mask->outer_second_cvlan_tag = 0;
-			misc_mask->outer_second_svlan_tag = 0;
-		}
-
-		DR_STE_SET_MASK_V(eth_l2_src, bit_mask,
-				  second_vlan_id, misc_mask, outer_second_vid);
-		DR_STE_SET_MASK_V(eth_l2_src, bit_mask,
-				  second_cfi, misc_mask, outer_second_cfi);
-		DR_STE_SET_MASK_V(eth_l2_src, bit_mask,
-				  second_priority, misc_mask, outer_second_prio);
-	}
-}
-
-static int
-dr_ste_v0_build_eth_l2_src_or_dst_tag(struct mlx5dr_match_param *value,
-				      bool inner, u8 *tag)
-{
-	struct mlx5dr_match_spec *spec = inner ? &value->inner : &value->outer;
-	struct mlx5dr_match_misc *misc_spec = &value->misc;
-
-	DR_STE_SET_TAG(eth_l2_src, tag, first_vlan_id, spec, first_vid);
-	DR_STE_SET_TAG(eth_l2_src, tag, first_cfi, spec, first_cfi);
-	DR_STE_SET_TAG(eth_l2_src, tag, first_priority, spec, first_prio);
-	DR_STE_SET_TAG(eth_l2_src, tag, ip_fragmented, spec, frag);
-	DR_STE_SET_TAG(eth_l2_src, tag, l3_ethertype, spec, ethertype);
-
-	if (spec->ip_version) {
-		if (spec->ip_version == IP_VERSION_IPV4) {
-			MLX5_SET(ste_eth_l2_src, tag, l3_type, STE_IPV4);
-			spec->ip_version = 0;
-		} else if (spec->ip_version == IP_VERSION_IPV6) {
-			MLX5_SET(ste_eth_l2_src, tag, l3_type, STE_IPV6);
-			spec->ip_version = 0;
-		} else {
-			pr_info("Unsupported ip_version value\n");
-			return -EINVAL;
-		}
-	}
-
-	if (spec->cvlan_tag) {
-		MLX5_SET(ste_eth_l2_src, tag, first_vlan_qualifier, DR_STE_CVLAN);
-		spec->cvlan_tag = 0;
-	} else if (spec->svlan_tag) {
-		MLX5_SET(ste_eth_l2_src, tag, first_vlan_qualifier, DR_STE_SVLAN);
-		spec->svlan_tag = 0;
-	}
-
-	if (inner) {
-		if (misc_spec->inner_second_cvlan_tag) {
-			MLX5_SET(ste_eth_l2_src, tag, second_vlan_qualifier, DR_STE_CVLAN);
-			misc_spec->inner_second_cvlan_tag = 0;
-		} else if (misc_spec->inner_second_svlan_tag) {
-			MLX5_SET(ste_eth_l2_src, tag, second_vlan_qualifier, DR_STE_SVLAN);
-			misc_spec->inner_second_svlan_tag = 0;
-		}
-
-		DR_STE_SET_TAG(eth_l2_src, tag, second_vlan_id, misc_spec, inner_second_vid);
-		DR_STE_SET_TAG(eth_l2_src, tag, second_cfi, misc_spec, inner_second_cfi);
-		DR_STE_SET_TAG(eth_l2_src, tag, second_priority, misc_spec, inner_second_prio);
-	} else {
-		if (misc_spec->outer_second_cvlan_tag) {
-			MLX5_SET(ste_eth_l2_src, tag, second_vlan_qualifier, DR_STE_CVLAN);
-			misc_spec->outer_second_cvlan_tag = 0;
-		} else if (misc_spec->outer_second_svlan_tag) {
-			MLX5_SET(ste_eth_l2_src, tag, second_vlan_qualifier, DR_STE_SVLAN);
-			misc_spec->outer_second_svlan_tag = 0;
-		}
-		DR_STE_SET_TAG(eth_l2_src, tag, second_vlan_id, misc_spec, outer_second_vid);
-		DR_STE_SET_TAG(eth_l2_src, tag, second_cfi, misc_spec, outer_second_cfi);
-		DR_STE_SET_TAG(eth_l2_src, tag, second_priority, misc_spec, outer_second_prio);
-	}
-
-	return 0;
-}
-
-static void
-dr_ste_v0_build_eth_l2_src_bit_mask(struct mlx5dr_match_param *value,
-				    bool inner, u8 *bit_mask)
-{
-	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
-
-	DR_STE_SET_MASK_V(eth_l2_src, bit_mask, smac_47_16, mask, smac_47_16);
-	DR_STE_SET_MASK_V(eth_l2_src, bit_mask, smac_15_0, mask, smac_15_0);
-
-	dr_ste_v0_build_eth_l2_src_or_dst_bit_mask(value, inner, bit_mask);
-}
-
-static int
-dr_ste_v0_build_eth_l2_src_tag(struct mlx5dr_match_param *value,
-			       struct mlx5dr_ste_build *sb,
-			       u8 *tag)
-{
-	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
-
-	DR_STE_SET_TAG(eth_l2_src, tag, smac_47_16, spec, smac_47_16);
-	DR_STE_SET_TAG(eth_l2_src, tag, smac_15_0, spec, smac_15_0);
-
-	return dr_ste_v0_build_eth_l2_src_or_dst_tag(value, sb->inner, tag);
-}
-
-static void
-dr_ste_v0_build_eth_l2_src_init(struct mlx5dr_ste_build *sb,
-				struct mlx5dr_match_param *mask)
-{
-	dr_ste_v0_build_eth_l2_src_bit_mask(mask, sb->inner, sb->bit_mask);
-	sb->lu_type = DR_STE_CALC_LU_TYPE(ETHL2_SRC, sb->rx, sb->inner);
-	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_v0_build_eth_l2_src_tag;
-}
-
 void mlx5dr_ste_build_eth_l2_src(struct mlx5dr_ste_ctx *ste_ctx,
 				 struct mlx5dr_ste_build *sb,
 				 struct mlx5dr_match_param *mask,
@@ -1374,42 +985,6 @@ void mlx5dr_ste_build_eth_l2_src(struct mlx5dr_ste_ctx *ste_ctx,
 	ste_ctx->build_eth_l2_src_init(sb, mask);
 }
 
-static void
-dr_ste_v0_build_eth_l2_dst_bit_mask(struct mlx5dr_match_param *value,
-				    bool inner, u8 *bit_mask)
-{
-	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
-
-	DR_STE_SET_MASK_V(eth_l2_dst, bit_mask, dmac_47_16, mask, dmac_47_16);
-	DR_STE_SET_MASK_V(eth_l2_dst, bit_mask, dmac_15_0, mask, dmac_15_0);
-
-	dr_ste_v0_build_eth_l2_src_or_dst_bit_mask(value, inner, bit_mask);
-}
-
-static int
-dr_ste_v0_build_eth_l2_dst_tag(struct mlx5dr_match_param *value,
-			       struct mlx5dr_ste_build *sb,
-			       u8 *tag)
-{
-	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
-
-	DR_STE_SET_TAG(eth_l2_dst, tag, dmac_47_16, spec, dmac_47_16);
-	DR_STE_SET_TAG(eth_l2_dst, tag, dmac_15_0, spec, dmac_15_0);
-
-	return dr_ste_v0_build_eth_l2_src_or_dst_tag(value, sb->inner, tag);
-}
-
-static void
-dr_ste_v0_build_eth_l2_dst_init(struct mlx5dr_ste_build *sb,
-				struct mlx5dr_match_param *mask)
-{
-	dr_ste_v0_build_eth_l2_dst_bit_mask(mask, sb->inner, sb->bit_mask);
-
-	sb->lu_type = DR_STE_CALC_LU_TYPE(ETHL2_DST, sb->rx, sb->inner);
-	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_v0_build_eth_l2_dst_tag;
-}
-
 void mlx5dr_ste_build_eth_l2_dst(struct mlx5dr_ste_ctx *ste_ctx,
 				 struct mlx5dr_ste_build *sb,
 				 struct mlx5dr_match_param *mask,
@@ -1420,91 +995,6 @@ void mlx5dr_ste_build_eth_l2_dst(struct mlx5dr_ste_ctx *ste_ctx,
 	ste_ctx->build_eth_l2_dst_init(sb, mask);
 }
 
-static void
-dr_ste_v0_build_eth_l2_tnl_bit_mask(struct mlx5dr_match_param *value,
-				    bool inner, u8 *bit_mask)
-{
-	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
-	struct mlx5dr_match_misc *misc = &value->misc;
-
-	DR_STE_SET_MASK_V(eth_l2_tnl, bit_mask, dmac_47_16, mask, dmac_47_16);
-	DR_STE_SET_MASK_V(eth_l2_tnl, bit_mask, dmac_15_0, mask, dmac_15_0);
-	DR_STE_SET_MASK_V(eth_l2_tnl, bit_mask, first_vlan_id, mask, first_vid);
-	DR_STE_SET_MASK_V(eth_l2_tnl, bit_mask, first_cfi, mask, first_cfi);
-	DR_STE_SET_MASK_V(eth_l2_tnl, bit_mask, first_priority, mask, first_prio);
-	DR_STE_SET_MASK_V(eth_l2_tnl, bit_mask, ip_fragmented, mask, frag);
-	DR_STE_SET_MASK_V(eth_l2_tnl, bit_mask, l3_ethertype, mask, ethertype);
-	DR_STE_SET_MASK(eth_l2_tnl, bit_mask, l3_type, mask, ip_version);
-
-	if (misc->vxlan_vni) {
-		MLX5_SET(ste_eth_l2_tnl, bit_mask,
-			 l2_tunneling_network_id, (misc->vxlan_vni << 8));
-		misc->vxlan_vni = 0;
-	}
-
-	if (mask->svlan_tag || mask->cvlan_tag) {
-		MLX5_SET(ste_eth_l2_tnl, bit_mask, first_vlan_qualifier, -1);
-		mask->cvlan_tag = 0;
-		mask->svlan_tag = 0;
-	}
-}
-
-static int
-dr_ste_v0_build_eth_l2_tnl_tag(struct mlx5dr_match_param *value,
-			       struct mlx5dr_ste_build *sb,
-			       u8 *tag)
-{
-	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
-	struct mlx5dr_match_misc *misc = &value->misc;
-
-	DR_STE_SET_TAG(eth_l2_tnl, tag, dmac_47_16, spec, dmac_47_16);
-	DR_STE_SET_TAG(eth_l2_tnl, tag, dmac_15_0, spec, dmac_15_0);
-	DR_STE_SET_TAG(eth_l2_tnl, tag, first_vlan_id, spec, first_vid);
-	DR_STE_SET_TAG(eth_l2_tnl, tag, first_cfi, spec, first_cfi);
-	DR_STE_SET_TAG(eth_l2_tnl, tag, ip_fragmented, spec, frag);
-	DR_STE_SET_TAG(eth_l2_tnl, tag, first_priority, spec, first_prio);
-	DR_STE_SET_TAG(eth_l2_tnl, tag, l3_ethertype, spec, ethertype);
-
-	if (misc->vxlan_vni) {
-		MLX5_SET(ste_eth_l2_tnl, tag, l2_tunneling_network_id,
-			 (misc->vxlan_vni << 8));
-		misc->vxlan_vni = 0;
-	}
-
-	if (spec->cvlan_tag) {
-		MLX5_SET(ste_eth_l2_tnl, tag, first_vlan_qualifier, DR_STE_CVLAN);
-		spec->cvlan_tag = 0;
-	} else if (spec->svlan_tag) {
-		MLX5_SET(ste_eth_l2_tnl, tag, first_vlan_qualifier, DR_STE_SVLAN);
-		spec->svlan_tag = 0;
-	}
-
-	if (spec->ip_version) {
-		if (spec->ip_version == IP_VERSION_IPV4) {
-			MLX5_SET(ste_eth_l2_tnl, tag, l3_type, STE_IPV4);
-			spec->ip_version = 0;
-		} else if (spec->ip_version == IP_VERSION_IPV6) {
-			MLX5_SET(ste_eth_l2_tnl, tag, l3_type, STE_IPV6);
-			spec->ip_version = 0;
-		} else {
-			return -EINVAL;
-		}
-	}
-
-	return 0;
-}
-
-static void
-dr_ste_v0_build_eth_l2_tnl_init(struct mlx5dr_ste_build *sb,
-				struct mlx5dr_match_param *mask)
-{
-	dr_ste_v0_build_eth_l2_tnl_bit_mask(mask, sb->inner, sb->bit_mask);
-
-	sb->lu_type = MLX5DR_STE_LU_TYPE_ETHL2_TUNNELING_I;
-	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_v0_build_eth_l2_tnl_tag;
-}
-
 void mlx5dr_ste_build_eth_l2_tnl(struct mlx5dr_ste_ctx *ste_ctx,
 				 struct mlx5dr_ste_build *sb,
 				 struct mlx5dr_match_param *mask, bool inner, bool rx)
@@ -1514,38 +1004,6 @@ void mlx5dr_ste_build_eth_l2_tnl(struct mlx5dr_ste_ctx *ste_ctx,
 	ste_ctx->build_eth_l2_tnl_init(sb, mask);
 }
 
-static void
-dr_ste_v0_build_eth_l3_ipv4_misc_bit_mask(struct mlx5dr_match_param *value,
-					  bool inner, u8 *bit_mask)
-{
-	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
-
-	DR_STE_SET_MASK_V(eth_l3_ipv4_misc, bit_mask, time_to_live, mask, ttl_hoplimit);
-}
-
-static int
-dr_ste_v0_build_eth_l3_ipv4_misc_tag(struct mlx5dr_match_param *value,
-				     struct mlx5dr_ste_build *sb,
-				     u8 *tag)
-{
-	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
-
-	DR_STE_SET_TAG(eth_l3_ipv4_misc, tag, time_to_live, spec, ttl_hoplimit);
-
-	return 0;
-}
-
-static void
-dr_ste_v0_build_eth_l3_ipv4_misc_init(struct mlx5dr_ste_build *sb,
-				      struct mlx5dr_match_param *mask)
-{
-	dr_ste_v0_build_eth_l3_ipv4_misc_bit_mask(mask, sb->inner, sb->bit_mask);
-
-	sb->lu_type = DR_STE_CALC_LU_TYPE(ETHL3_IPV4_MISC, sb->rx, sb->inner);
-	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_v0_build_eth_l3_ipv4_misc_tag;
-}
-
 void mlx5dr_ste_build_eth_l3_ipv4_misc(struct mlx5dr_ste_ctx *ste_ctx,
 				       struct mlx5dr_ste_build *sb,
 				       struct mlx5dr_match_param *mask,
@@ -1556,64 +1014,6 @@ void mlx5dr_ste_build_eth_l3_ipv4_misc(struct mlx5dr_ste_ctx *ste_ctx,
 	ste_ctx->build_eth_l3_ipv4_misc_init(sb, mask);
 }
 
-static void
-dr_ste_v0_build_eth_ipv6_l3_l4_bit_mask(struct mlx5dr_match_param *value,
-					bool inner, u8 *bit_mask)
-{
-	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
-
-	DR_STE_SET_MASK_V(eth_l4, bit_mask, dst_port, mask, tcp_dport);
-	DR_STE_SET_MASK_V(eth_l4, bit_mask, src_port, mask, tcp_sport);
-	DR_STE_SET_MASK_V(eth_l4, bit_mask, dst_port, mask, udp_dport);
-	DR_STE_SET_MASK_V(eth_l4, bit_mask, src_port, mask, udp_sport);
-	DR_STE_SET_MASK_V(eth_l4, bit_mask, protocol, mask, ip_protocol);
-	DR_STE_SET_MASK_V(eth_l4, bit_mask, fragmented, mask, frag);
-	DR_STE_SET_MASK_V(eth_l4, bit_mask, dscp, mask, ip_dscp);
-	DR_STE_SET_MASK_V(eth_l4, bit_mask, ecn, mask, ip_ecn);
-	DR_STE_SET_MASK_V(eth_l4, bit_mask, ipv6_hop_limit, mask, ttl_hoplimit);
-
-	if (mask->tcp_flags) {
-		DR_STE_SET_TCP_FLAGS(eth_l4, bit_mask, mask);
-		mask->tcp_flags = 0;
-	}
-}
-
-static int
-dr_ste_v0_build_eth_ipv6_l3_l4_tag(struct mlx5dr_match_param *value,
-				   struct mlx5dr_ste_build *sb,
-				   u8 *tag)
-{
-	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
-
-	DR_STE_SET_TAG(eth_l4, tag, dst_port, spec, tcp_dport);
-	DR_STE_SET_TAG(eth_l4, tag, src_port, spec, tcp_sport);
-	DR_STE_SET_TAG(eth_l4, tag, dst_port, spec, udp_dport);
-	DR_STE_SET_TAG(eth_l4, tag, src_port, spec, udp_sport);
-	DR_STE_SET_TAG(eth_l4, tag, protocol, spec, ip_protocol);
-	DR_STE_SET_TAG(eth_l4, tag, fragmented, spec, frag);
-	DR_STE_SET_TAG(eth_l4, tag, dscp, spec, ip_dscp);
-	DR_STE_SET_TAG(eth_l4, tag, ecn, spec, ip_ecn);
-	DR_STE_SET_TAG(eth_l4, tag, ipv6_hop_limit, spec, ttl_hoplimit);
-
-	if (spec->tcp_flags) {
-		DR_STE_SET_TCP_FLAGS(eth_l4, tag, spec);
-		spec->tcp_flags = 0;
-	}
-
-	return 0;
-}
-
-static void
-dr_ste_v0_build_eth_ipv6_l3_l4_init(struct mlx5dr_ste_build *sb,
-				    struct mlx5dr_match_param *mask)
-{
-	dr_ste_v0_build_eth_ipv6_l3_l4_bit_mask(mask, sb->inner, sb->bit_mask);
-
-	sb->lu_type = DR_STE_CALC_LU_TYPE(ETHL4, sb->rx, sb->inner);
-	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_v0_build_eth_ipv6_l3_l4_tag;
-}
-
 void mlx5dr_ste_build_eth_ipv6_l3_l4(struct mlx5dr_ste_ctx *ste_ctx,
 				     struct mlx5dr_ste_build *sb,
 				     struct mlx5dr_match_param *mask,
@@ -1639,44 +1039,6 @@ void mlx5dr_ste_build_empty_always_hit(struct mlx5dr_ste_build *sb, bool rx)
 	sb->ste_build_tag_func = &dr_ste_build_empty_always_hit_tag;
 }
 
-static void
-dr_ste_v0_build_mpls_bit_mask(struct mlx5dr_match_param *value,
-			      bool inner, u8 *bit_mask)
-{
-	struct mlx5dr_match_misc2 *misc2_mask = &value->misc2;
-
-	if (inner)
-		DR_STE_SET_MPLS_MASK(mpls, misc2_mask, inner, bit_mask);
-	else
-		DR_STE_SET_MPLS_MASK(mpls, misc2_mask, outer, bit_mask);
-}
-
-static int
-dr_ste_v0_build_mpls_tag(struct mlx5dr_match_param *value,
-			 struct mlx5dr_ste_build *sb,
-			 u8 *tag)
-{
-	struct mlx5dr_match_misc2 *misc2_mask = &value->misc2;
-
-	if (sb->inner)
-		DR_STE_SET_MPLS_TAG(mpls, misc2_mask, inner, tag);
-	else
-		DR_STE_SET_MPLS_TAG(mpls, misc2_mask, outer, tag);
-
-	return 0;
-}
-
-static void
-dr_ste_v0_build_mpls_init(struct mlx5dr_ste_build *sb,
-			  struct mlx5dr_match_param *mask)
-{
-	dr_ste_v0_build_mpls_bit_mask(mask, sb->inner, sb->bit_mask);
-
-	sb->lu_type = DR_STE_CALC_LU_TYPE(MPLS_FIRST, sb->rx, sb->inner);
-	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_v0_build_mpls_tag;
-}
-
 void mlx5dr_ste_build_mpls(struct mlx5dr_ste_ctx *ste_ctx,
 			   struct mlx5dr_ste_build *sb,
 			   struct mlx5dr_match_param *mask,
@@ -1687,52 +1049,6 @@ void mlx5dr_ste_build_mpls(struct mlx5dr_ste_ctx *ste_ctx,
 	ste_ctx->build_mpls_init(sb, mask);
 }
 
-static void
-dr_ste_v0_build_tnl_gre_bit_mask(struct mlx5dr_match_param *value,
-				 bool inner, u8 *bit_mask)
-{
-	struct mlx5dr_match_misc *misc_mask = &value->misc;
-
-	DR_STE_SET_MASK_V(gre, bit_mask, gre_protocol, misc_mask, gre_protocol);
-	DR_STE_SET_MASK_V(gre, bit_mask, gre_k_present, misc_mask, gre_k_present);
-	DR_STE_SET_MASK_V(gre, bit_mask, gre_key_h, misc_mask, gre_key_h);
-	DR_STE_SET_MASK_V(gre, bit_mask, gre_key_l, misc_mask, gre_key_l);
-
-	DR_STE_SET_MASK_V(gre, bit_mask, gre_c_present, misc_mask, gre_c_present);
-	DR_STE_SET_MASK_V(gre, bit_mask, gre_s_present, misc_mask, gre_s_present);
-}
-
-static int
-dr_ste_v0_build_tnl_gre_tag(struct mlx5dr_match_param *value,
-			    struct mlx5dr_ste_build *sb,
-			    u8 *tag)
-{
-	struct  mlx5dr_match_misc *misc = &value->misc;
-
-	DR_STE_SET_TAG(gre, tag, gre_protocol, misc, gre_protocol);
-
-	DR_STE_SET_TAG(gre, tag, gre_k_present, misc, gre_k_present);
-	DR_STE_SET_TAG(gre, tag, gre_key_h, misc, gre_key_h);
-	DR_STE_SET_TAG(gre, tag, gre_key_l, misc, gre_key_l);
-
-	DR_STE_SET_TAG(gre, tag, gre_c_present, misc, gre_c_present);
-
-	DR_STE_SET_TAG(gre, tag, gre_s_present, misc, gre_s_present);
-
-	return 0;
-}
-
-static void
-dr_ste_v0_build_tnl_gre_init(struct mlx5dr_ste_build *sb,
-			     struct mlx5dr_match_param *mask)
-{
-	dr_ste_v0_build_tnl_gre_bit_mask(mask, sb->inner, sb->bit_mask);
-
-	sb->lu_type = MLX5DR_STE_LU_TYPE_GRE;
-	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_v0_build_tnl_gre_tag;
-}
-
 void mlx5dr_ste_build_tnl_gre(struct mlx5dr_ste_ctx *ste_ctx,
 			      struct mlx5dr_ste_build *sb,
 			      struct mlx5dr_match_param *mask,
@@ -1743,85 +1059,6 @@ void mlx5dr_ste_build_tnl_gre(struct mlx5dr_ste_ctx *ste_ctx,
 	ste_ctx->build_tnl_gre_init(sb, mask);
 }
 
-static void
-dr_ste_v0_build_tnl_mpls_bit_mask(struct mlx5dr_match_param *value,
-				  bool inner, u8 *bit_mask)
-{
-	struct mlx5dr_match_misc2 *misc_2_mask = &value->misc2;
-
-	if (DR_STE_IS_OUTER_MPLS_OVER_GRE_SET(misc_2_mask)) {
-		DR_STE_SET_MASK_V(flex_parser_0, bit_mask, parser_3_label,
-				  misc_2_mask, outer_first_mpls_over_gre_label);
-
-		DR_STE_SET_MASK_V(flex_parser_0, bit_mask, parser_3_exp,
-				  misc_2_mask, outer_first_mpls_over_gre_exp);
-
-		DR_STE_SET_MASK_V(flex_parser_0, bit_mask, parser_3_s_bos,
-				  misc_2_mask, outer_first_mpls_over_gre_s_bos);
-
-		DR_STE_SET_MASK_V(flex_parser_0, bit_mask, parser_3_ttl,
-				  misc_2_mask, outer_first_mpls_over_gre_ttl);
-	} else {
-		DR_STE_SET_MASK_V(flex_parser_0, bit_mask, parser_3_label,
-				  misc_2_mask, outer_first_mpls_over_udp_label);
-
-		DR_STE_SET_MASK_V(flex_parser_0, bit_mask, parser_3_exp,
-				  misc_2_mask, outer_first_mpls_over_udp_exp);
-
-		DR_STE_SET_MASK_V(flex_parser_0, bit_mask, parser_3_s_bos,
-				  misc_2_mask, outer_first_mpls_over_udp_s_bos);
-
-		DR_STE_SET_MASK_V(flex_parser_0, bit_mask, parser_3_ttl,
-				  misc_2_mask, outer_first_mpls_over_udp_ttl);
-	}
-}
-
-static int
-dr_ste_v0_build_tnl_mpls_tag(struct mlx5dr_match_param *value,
-			     struct mlx5dr_ste_build *sb,
-			     u8 *tag)
-{
-	struct mlx5dr_match_misc2 *misc_2_mask = &value->misc2;
-
-	if (DR_STE_IS_OUTER_MPLS_OVER_GRE_SET(misc_2_mask)) {
-		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_label,
-			       misc_2_mask, outer_first_mpls_over_gre_label);
-
-		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_exp,
-			       misc_2_mask, outer_first_mpls_over_gre_exp);
-
-		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_s_bos,
-			       misc_2_mask, outer_first_mpls_over_gre_s_bos);
-
-		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_ttl,
-			       misc_2_mask, outer_first_mpls_over_gre_ttl);
-	} else {
-		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_label,
-			       misc_2_mask, outer_first_mpls_over_udp_label);
-
-		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_exp,
-			       misc_2_mask, outer_first_mpls_over_udp_exp);
-
-		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_s_bos,
-			       misc_2_mask, outer_first_mpls_over_udp_s_bos);
-
-		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_ttl,
-			       misc_2_mask, outer_first_mpls_over_udp_ttl);
-	}
-	return 0;
-}
-
-static void
-dr_ste_v0_build_tnl_mpls_init(struct mlx5dr_ste_build *sb,
-			      struct mlx5dr_match_param *mask)
-{
-	dr_ste_v0_build_tnl_mpls_bit_mask(mask, sb->inner, sb->bit_mask);
-
-	sb->lu_type = MLX5DR_STE_LU_TYPE_FLEX_PARSER_0;
-	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_v0_build_tnl_mpls_tag;
-}
-
 void mlx5dr_ste_build_tnl_mpls(struct mlx5dr_ste_ctx *ste_ctx,
 			       struct mlx5dr_ste_build *sb,
 			       struct mlx5dr_match_param *mask,
@@ -1832,169 +1069,6 @@ void mlx5dr_ste_build_tnl_mpls(struct mlx5dr_ste_ctx *ste_ctx,
 	ste_ctx->build_tnl_mpls_init(sb, mask);
 }
 
-#define ICMP_TYPE_OFFSET_FIRST_DW		24
-#define ICMP_CODE_OFFSET_FIRST_DW		16
-#define ICMP_HEADER_DATA_OFFSET_SECOND_DW	0
-
-static int
-dr_ste_v0_build_icmp_bit_mask(struct mlx5dr_match_param *mask,
-			      struct mlx5dr_cmd_caps *caps,
-			      u8 *bit_mask)
-{
-	struct mlx5dr_match_misc3 *misc_3_mask = &mask->misc3;
-	bool is_ipv4_mask = DR_MASK_IS_ICMPV4_SET(misc_3_mask);
-	u32 icmp_header_data_mask;
-	u32 icmp_type_mask;
-	u32 icmp_code_mask;
-	int dw0_location;
-	int dw1_location;
-
-	if (is_ipv4_mask) {
-		icmp_header_data_mask	= misc_3_mask->icmpv4_header_data;
-		icmp_type_mask		= misc_3_mask->icmpv4_type;
-		icmp_code_mask		= misc_3_mask->icmpv4_code;
-		dw0_location		= caps->flex_parser_id_icmp_dw0;
-		dw1_location		= caps->flex_parser_id_icmp_dw1;
-	} else {
-		icmp_header_data_mask	= misc_3_mask->icmpv6_header_data;
-		icmp_type_mask		= misc_3_mask->icmpv6_type;
-		icmp_code_mask		= misc_3_mask->icmpv6_code;
-		dw0_location		= caps->flex_parser_id_icmpv6_dw0;
-		dw1_location		= caps->flex_parser_id_icmpv6_dw1;
-	}
-
-	switch (dw0_location) {
-	case 4:
-		if (icmp_type_mask) {
-			MLX5_SET(ste_flex_parser_1, bit_mask, flex_parser_4,
-				 (icmp_type_mask << ICMP_TYPE_OFFSET_FIRST_DW));
-			if (is_ipv4_mask)
-				misc_3_mask->icmpv4_type = 0;
-			else
-				misc_3_mask->icmpv6_type = 0;
-		}
-		if (icmp_code_mask) {
-			u32 cur_val = MLX5_GET(ste_flex_parser_1, bit_mask,
-					       flex_parser_4);
-			MLX5_SET(ste_flex_parser_1, bit_mask, flex_parser_4,
-				 cur_val | (icmp_code_mask << ICMP_CODE_OFFSET_FIRST_DW));
-			if (is_ipv4_mask)
-				misc_3_mask->icmpv4_code = 0;
-			else
-				misc_3_mask->icmpv6_code = 0;
-		}
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	switch (dw1_location) {
-	case 5:
-		if (icmp_header_data_mask) {
-			MLX5_SET(ste_flex_parser_1, bit_mask, flex_parser_5,
-				 (icmp_header_data_mask << ICMP_HEADER_DATA_OFFSET_SECOND_DW));
-			if (is_ipv4_mask)
-				misc_3_mask->icmpv4_header_data = 0;
-			else
-				misc_3_mask->icmpv6_header_data = 0;
-		}
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static int
-dr_ste_v0_build_icmp_tag(struct mlx5dr_match_param *value,
-			 struct mlx5dr_ste_build *sb,
-			 u8 *tag)
-{
-	struct mlx5dr_match_misc3 *misc_3 = &value->misc3;
-	u32 icmp_header_data;
-	int dw0_location;
-	int dw1_location;
-	u32 icmp_type;
-	u32 icmp_code;
-	bool is_ipv4;
-
-	is_ipv4 = DR_MASK_IS_ICMPV4_SET(misc_3);
-	if (is_ipv4) {
-		icmp_header_data	= misc_3->icmpv4_header_data;
-		icmp_type		= misc_3->icmpv4_type;
-		icmp_code		= misc_3->icmpv4_code;
-		dw0_location		= sb->caps->flex_parser_id_icmp_dw0;
-		dw1_location		= sb->caps->flex_parser_id_icmp_dw1;
-	} else {
-		icmp_header_data	= misc_3->icmpv6_header_data;
-		icmp_type		= misc_3->icmpv6_type;
-		icmp_code		= misc_3->icmpv6_code;
-		dw0_location		= sb->caps->flex_parser_id_icmpv6_dw0;
-		dw1_location		= sb->caps->flex_parser_id_icmpv6_dw1;
-	}
-
-	switch (dw0_location) {
-	case 4:
-		if (icmp_type) {
-			MLX5_SET(ste_flex_parser_1, tag, flex_parser_4,
-				 (icmp_type << ICMP_TYPE_OFFSET_FIRST_DW));
-			if (is_ipv4)
-				misc_3->icmpv4_type = 0;
-			else
-				misc_3->icmpv6_type = 0;
-		}
-
-		if (icmp_code) {
-			u32 cur_val = MLX5_GET(ste_flex_parser_1, tag,
-					       flex_parser_4);
-			MLX5_SET(ste_flex_parser_1, tag, flex_parser_4,
-				 cur_val | (icmp_code << ICMP_CODE_OFFSET_FIRST_DW));
-			if (is_ipv4)
-				misc_3->icmpv4_code = 0;
-			else
-				misc_3->icmpv6_code = 0;
-		}
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	switch (dw1_location) {
-	case 5:
-		if (icmp_header_data) {
-			MLX5_SET(ste_flex_parser_1, tag, flex_parser_5,
-				 (icmp_header_data << ICMP_HEADER_DATA_OFFSET_SECOND_DW));
-			if (is_ipv4)
-				misc_3->icmpv4_header_data = 0;
-			else
-				misc_3->icmpv6_header_data = 0;
-		}
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static int
-dr_ste_v0_build_icmp_init(struct mlx5dr_ste_build *sb,
-			  struct mlx5dr_match_param *mask)
-{
-	int ret;
-
-	ret = dr_ste_v0_build_icmp_bit_mask(mask, sb->caps, sb->bit_mask);
-	if (ret)
-		return ret;
-
-	sb->lu_type = MLX5DR_STE_LU_TYPE_FLEX_PARSER_1;
-	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_v0_build_icmp_tag;
-
-	return 0;
-}
-
 int mlx5dr_ste_build_icmp(struct mlx5dr_ste_ctx *ste_ctx,
 			  struct mlx5dr_ste_build *sb,
 			  struct mlx5dr_match_param *mask,
@@ -2007,41 +1081,6 @@ int mlx5dr_ste_build_icmp(struct mlx5dr_ste_ctx *ste_ctx,
 	return ste_ctx->build_icmp_init(sb, mask);
 }
 
-static void
-dr_ste_v0_build_general_purpose_bit_mask(struct mlx5dr_match_param *value,
-					 bool inner, u8 *bit_mask)
-{
-	struct mlx5dr_match_misc2 *misc_2_mask = &value->misc2;
-
-	DR_STE_SET_MASK_V(general_purpose, bit_mask,
-			  general_purpose_lookup_field, misc_2_mask,
-			  metadata_reg_a);
-}
-
-static int
-dr_ste_v0_build_general_purpose_tag(struct mlx5dr_match_param *value,
-				    struct mlx5dr_ste_build *sb,
-				    u8 *tag)
-{
-	struct mlx5dr_match_misc2 *misc_2_mask = &value->misc2;
-
-	DR_STE_SET_TAG(general_purpose, tag, general_purpose_lookup_field,
-		       misc_2_mask, metadata_reg_a);
-
-	return 0;
-}
-
-static void
-dr_ste_v0_build_general_purpose_init(struct mlx5dr_ste_build *sb,
-				     struct mlx5dr_match_param *mask)
-{
-	dr_ste_v0_build_general_purpose_bit_mask(mask, sb->inner, sb->bit_mask);
-
-	sb->lu_type = MLX5DR_STE_LU_TYPE_GENERAL_PURPOSE;
-	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_v0_build_general_purpose_tag;
-}
-
 void mlx5dr_ste_build_general_purpose(struct mlx5dr_ste_ctx *ste_ctx,
 				      struct mlx5dr_ste_build *sb,
 				      struct mlx5dr_match_param *mask,
@@ -2052,54 +1091,6 @@ void mlx5dr_ste_build_general_purpose(struct mlx5dr_ste_ctx *ste_ctx,
 	ste_ctx->build_general_purpose_init(sb, mask);
 }
 
-static void
-dr_ste_v0_build_eth_l4_misc_bit_mask(struct mlx5dr_match_param *value,
-				     bool inner, u8 *bit_mask)
-{
-	struct mlx5dr_match_misc3 *misc_3_mask = &value->misc3;
-
-	if (inner) {
-		DR_STE_SET_MASK_V(eth_l4_misc, bit_mask, seq_num, misc_3_mask,
-				  inner_tcp_seq_num);
-		DR_STE_SET_MASK_V(eth_l4_misc, bit_mask, ack_num, misc_3_mask,
-				  inner_tcp_ack_num);
-	} else {
-		DR_STE_SET_MASK_V(eth_l4_misc, bit_mask, seq_num, misc_3_mask,
-				  outer_tcp_seq_num);
-		DR_STE_SET_MASK_V(eth_l4_misc, bit_mask, ack_num, misc_3_mask,
-				  outer_tcp_ack_num);
-	}
-}
-
-static int
-dr_ste_v0_build_eth_l4_misc_tag(struct mlx5dr_match_param *value,
-				struct mlx5dr_ste_build *sb,
-				u8 *tag)
-{
-	struct mlx5dr_match_misc3 *misc3 = &value->misc3;
-
-	if (sb->inner) {
-		DR_STE_SET_TAG(eth_l4_misc, tag, seq_num, misc3, inner_tcp_seq_num);
-		DR_STE_SET_TAG(eth_l4_misc, tag, ack_num, misc3, inner_tcp_ack_num);
-	} else {
-		DR_STE_SET_TAG(eth_l4_misc, tag, seq_num, misc3, outer_tcp_seq_num);
-		DR_STE_SET_TAG(eth_l4_misc, tag, ack_num, misc3, outer_tcp_ack_num);
-	}
-
-	return 0;
-}
-
-static void
-dr_ste_v0_build_eth_l4_misc_init(struct mlx5dr_ste_build *sb,
-				 struct mlx5dr_match_param *mask)
-{
-	dr_ste_v0_build_eth_l4_misc_bit_mask(mask, sb->inner, sb->bit_mask);
-
-	sb->lu_type = DR_STE_CALC_LU_TYPE(ETHL4_MISC, sb->rx, sb->inner);
-	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_v0_build_eth_l4_misc_tag;
-}
-
 void mlx5dr_ste_build_eth_l4_misc(struct mlx5dr_ste_ctx *ste_ctx,
 				  struct mlx5dr_ste_build *sb,
 				  struct mlx5dr_match_param *mask,
@@ -2110,54 +1101,6 @@ void mlx5dr_ste_build_eth_l4_misc(struct mlx5dr_ste_ctx *ste_ctx,
 	ste_ctx->build_eth_l4_misc_init(sb, mask);
 }
 
-static void
-dr_ste_v0_build_flex_parser_tnl_vxlan_gpe_bit_mask(struct mlx5dr_match_param *value,
-						   bool inner, u8 *bit_mask)
-{
-	struct mlx5dr_match_misc3 *misc_3_mask = &value->misc3;
-
-	DR_STE_SET_MASK_V(flex_parser_tnl_vxlan_gpe, bit_mask,
-			  outer_vxlan_gpe_flags,
-			  misc_3_mask, outer_vxlan_gpe_flags);
-	DR_STE_SET_MASK_V(flex_parser_tnl_vxlan_gpe, bit_mask,
-			  outer_vxlan_gpe_next_protocol,
-			  misc_3_mask, outer_vxlan_gpe_next_protocol);
-	DR_STE_SET_MASK_V(flex_parser_tnl_vxlan_gpe, bit_mask,
-			  outer_vxlan_gpe_vni,
-			  misc_3_mask, outer_vxlan_gpe_vni);
-}
-
-static int
-dr_ste_v0_build_flex_parser_tnl_vxlan_gpe_tag(struct mlx5dr_match_param *value,
-					      struct mlx5dr_ste_build *sb,
-					      u8 *tag)
-{
-	struct mlx5dr_match_misc3 *misc3 = &value->misc3;
-
-	DR_STE_SET_TAG(flex_parser_tnl_vxlan_gpe, tag,
-		       outer_vxlan_gpe_flags, misc3,
-		       outer_vxlan_gpe_flags);
-	DR_STE_SET_TAG(flex_parser_tnl_vxlan_gpe, tag,
-		       outer_vxlan_gpe_next_protocol, misc3,
-		       outer_vxlan_gpe_next_protocol);
-	DR_STE_SET_TAG(flex_parser_tnl_vxlan_gpe, tag,
-		       outer_vxlan_gpe_vni, misc3,
-		       outer_vxlan_gpe_vni);
-
-	return 0;
-}
-
-static void
-dr_ste_v0_build_flex_parser_tnl_vxlan_gpe_init(struct mlx5dr_ste_build *sb,
-					       struct mlx5dr_match_param *mask)
-{
-	dr_ste_v0_build_flex_parser_tnl_vxlan_gpe_bit_mask(mask, sb->inner,
-							   sb->bit_mask);
-	sb->lu_type = MLX5DR_STE_LU_TYPE_FLEX_PARSER_TNL_HEADER;
-	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_v0_build_flex_parser_tnl_vxlan_gpe_tag;
-}
-
 void mlx5dr_ste_build_tnl_vxlan_gpe(struct mlx5dr_ste_ctx *ste_ctx,
 				    struct mlx5dr_ste_build *sb,
 				    struct mlx5dr_match_param *mask,
@@ -2168,55 +1111,6 @@ void mlx5dr_ste_build_tnl_vxlan_gpe(struct mlx5dr_ste_ctx *ste_ctx,
 	ste_ctx->build_tnl_vxlan_gpe_init(sb, mask);
 }
 
-static void
-dr_ste_v0_build_flex_parser_tnl_geneve_bit_mask(struct mlx5dr_match_param *value,
-						u8 *bit_mask)
-{
-	struct mlx5dr_match_misc *misc_mask = &value->misc;
-
-	DR_STE_SET_MASK_V(flex_parser_tnl_geneve, bit_mask,
-			  geneve_protocol_type,
-			  misc_mask, geneve_protocol_type);
-	DR_STE_SET_MASK_V(flex_parser_tnl_geneve, bit_mask,
-			  geneve_oam,
-			  misc_mask, geneve_oam);
-	DR_STE_SET_MASK_V(flex_parser_tnl_geneve, bit_mask,
-			  geneve_opt_len,
-			  misc_mask, geneve_opt_len);
-	DR_STE_SET_MASK_V(flex_parser_tnl_geneve, bit_mask,
-			  geneve_vni,
-			  misc_mask, geneve_vni);
-}
-
-static int
-dr_ste_v0_build_flex_parser_tnl_geneve_tag(struct mlx5dr_match_param *value,
-					   struct mlx5dr_ste_build *sb,
-					   u8 *tag)
-{
-	struct mlx5dr_match_misc *misc = &value->misc;
-
-	DR_STE_SET_TAG(flex_parser_tnl_geneve, tag,
-		       geneve_protocol_type, misc, geneve_protocol_type);
-	DR_STE_SET_TAG(flex_parser_tnl_geneve, tag,
-		       geneve_oam, misc, geneve_oam);
-	DR_STE_SET_TAG(flex_parser_tnl_geneve, tag,
-		       geneve_opt_len, misc, geneve_opt_len);
-	DR_STE_SET_TAG(flex_parser_tnl_geneve, tag,
-		       geneve_vni, misc, geneve_vni);
-
-	return 0;
-}
-
-static void
-dr_ste_v0_build_flex_parser_tnl_geneve_init(struct mlx5dr_ste_build *sb,
-					    struct mlx5dr_match_param *mask)
-{
-	dr_ste_v0_build_flex_parser_tnl_geneve_bit_mask(mask, sb->bit_mask);
-	sb->lu_type = MLX5DR_STE_LU_TYPE_FLEX_PARSER_TNL_HEADER;
-	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_v0_build_flex_parser_tnl_geneve_tag;
-}
-
 void mlx5dr_ste_build_tnl_geneve(struct mlx5dr_ste_ctx *ste_ctx,
 				 struct mlx5dr_ste_build *sb,
 				 struct mlx5dr_match_param *mask,
@@ -2227,48 +1121,6 @@ void mlx5dr_ste_build_tnl_geneve(struct mlx5dr_ste_ctx *ste_ctx,
 	ste_ctx->build_tnl_geneve_init(sb, mask);
 }
 
-static void
-dr_ste_v0_build_register_0_bit_mask(struct mlx5dr_match_param *value,
-				    u8 *bit_mask)
-{
-	struct mlx5dr_match_misc2 *misc_2_mask = &value->misc2;
-
-	DR_STE_SET_MASK_V(register_0, bit_mask, register_0_h,
-			  misc_2_mask, metadata_reg_c_0);
-	DR_STE_SET_MASK_V(register_0, bit_mask, register_0_l,
-			  misc_2_mask, metadata_reg_c_1);
-	DR_STE_SET_MASK_V(register_0, bit_mask, register_1_h,
-			  misc_2_mask, metadata_reg_c_2);
-	DR_STE_SET_MASK_V(register_0, bit_mask, register_1_l,
-			  misc_2_mask, metadata_reg_c_3);
-}
-
-static int
-dr_ste_v0_build_register_0_tag(struct mlx5dr_match_param *value,
-			       struct mlx5dr_ste_build *sb,
-			       u8 *tag)
-{
-	struct mlx5dr_match_misc2 *misc2 = &value->misc2;
-
-	DR_STE_SET_TAG(register_0, tag, register_0_h, misc2, metadata_reg_c_0);
-	DR_STE_SET_TAG(register_0, tag, register_0_l, misc2, metadata_reg_c_1);
-	DR_STE_SET_TAG(register_0, tag, register_1_h, misc2, metadata_reg_c_2);
-	DR_STE_SET_TAG(register_0, tag, register_1_l, misc2, metadata_reg_c_3);
-
-	return 0;
-}
-
-static void
-dr_ste_v0_build_register_0_init(struct mlx5dr_ste_build *sb,
-				struct mlx5dr_match_param *mask)
-{
-	dr_ste_v0_build_register_0_bit_mask(mask, sb->bit_mask);
-
-	sb->lu_type = MLX5DR_STE_LU_TYPE_STEERING_REGISTERS_0;
-	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_v0_build_register_0_tag;
-}
-
 void mlx5dr_ste_build_register_0(struct mlx5dr_ste_ctx *ste_ctx,
 				 struct mlx5dr_ste_build *sb,
 				 struct mlx5dr_match_param *mask,
@@ -2279,48 +1131,6 @@ void mlx5dr_ste_build_register_0(struct mlx5dr_ste_ctx *ste_ctx,
 	ste_ctx->build_register_0_init(sb, mask);
 }
 
-static void
-dr_ste_v0_build_register_1_bit_mask(struct mlx5dr_match_param *value,
-				    u8 *bit_mask)
-{
-	struct mlx5dr_match_misc2 *misc_2_mask = &value->misc2;
-
-	DR_STE_SET_MASK_V(register_1, bit_mask, register_2_h,
-			  misc_2_mask, metadata_reg_c_4);
-	DR_STE_SET_MASK_V(register_1, bit_mask, register_2_l,
-			  misc_2_mask, metadata_reg_c_5);
-	DR_STE_SET_MASK_V(register_1, bit_mask, register_3_h,
-			  misc_2_mask, metadata_reg_c_6);
-	DR_STE_SET_MASK_V(register_1, bit_mask, register_3_l,
-			  misc_2_mask, metadata_reg_c_7);
-}
-
-static int
-dr_ste_v0_build_register_1_tag(struct mlx5dr_match_param *value,
-			       struct mlx5dr_ste_build *sb,
-			       u8 *tag)
-{
-	struct mlx5dr_match_misc2 *misc2 = &value->misc2;
-
-	DR_STE_SET_TAG(register_1, tag, register_2_h, misc2, metadata_reg_c_4);
-	DR_STE_SET_TAG(register_1, tag, register_2_l, misc2, metadata_reg_c_5);
-	DR_STE_SET_TAG(register_1, tag, register_3_h, misc2, metadata_reg_c_6);
-	DR_STE_SET_TAG(register_1, tag, register_3_l, misc2, metadata_reg_c_7);
-
-	return 0;
-}
-
-static void
-dr_ste_v0_build_register_1_init(struct mlx5dr_ste_build *sb,
-				struct mlx5dr_match_param *mask)
-{
-	dr_ste_v0_build_register_1_bit_mask(mask, sb->bit_mask);
-
-	sb->lu_type = MLX5DR_STE_LU_TYPE_STEERING_REGISTERS_1;
-	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_v0_build_register_1_tag;
-}
-
 void mlx5dr_ste_build_register_1(struct mlx5dr_ste_ctx *ste_ctx,
 				 struct mlx5dr_ste_build *sb,
 				 struct mlx5dr_match_param *mask,
@@ -2331,72 +1141,6 @@ void mlx5dr_ste_build_register_1(struct mlx5dr_ste_ctx *ste_ctx,
 	ste_ctx->build_register_1_init(sb, mask);
 }
 
-static void
-dr_ste_v0_build_src_gvmi_qpn_bit_mask(struct mlx5dr_match_param *value,
-				      u8 *bit_mask)
-{
-	struct mlx5dr_match_misc *misc_mask = &value->misc;
-
-	DR_STE_SET_MASK(src_gvmi_qp, bit_mask, source_gvmi, misc_mask, source_port);
-	DR_STE_SET_MASK(src_gvmi_qp, bit_mask, source_qp, misc_mask, source_sqn);
-	misc_mask->source_eswitch_owner_vhca_id = 0;
-}
-
-static int
-dr_ste_v0_build_src_gvmi_qpn_tag(struct mlx5dr_match_param *value,
-				 struct mlx5dr_ste_build *sb,
-				 u8 *tag)
-{
-	struct mlx5dr_match_misc *misc = &value->misc;
-	struct mlx5dr_cmd_vport_cap *vport_cap;
-	struct mlx5dr_domain *dmn = sb->dmn;
-	struct mlx5dr_cmd_caps *caps;
-	u8 *bit_mask = sb->bit_mask;
-	bool source_gvmi_set;
-
-	DR_STE_SET_TAG(src_gvmi_qp, tag, source_qp, misc, source_sqn);
-
-	if (sb->vhca_id_valid) {
-		/* Find port GVMI based on the eswitch_owner_vhca_id */
-		if (misc->source_eswitch_owner_vhca_id == dmn->info.caps.gvmi)
-			caps = &dmn->info.caps;
-		else if (dmn->peer_dmn && (misc->source_eswitch_owner_vhca_id ==
-					   dmn->peer_dmn->info.caps.gvmi))
-			caps = &dmn->peer_dmn->info.caps;
-		else
-			return -EINVAL;
-	} else {
-		caps = &dmn->info.caps;
-	}
-
-	vport_cap = mlx5dr_get_vport_cap(caps, misc->source_port);
-	if (!vport_cap) {
-		mlx5dr_err(dmn, "Vport 0x%x is invalid\n",
-			   misc->source_port);
-		return -EINVAL;
-	}
-
-	source_gvmi_set = MLX5_GET(ste_src_gvmi_qp, bit_mask, source_gvmi);
-	if (vport_cap->vport_gvmi && source_gvmi_set)
-		MLX5_SET(ste_src_gvmi_qp, tag, source_gvmi, vport_cap->vport_gvmi);
-
-	misc->source_eswitch_owner_vhca_id = 0;
-	misc->source_port = 0;
-
-	return 0;
-}
-
-static void
-dr_ste_v0_build_src_gvmi_qpn_init(struct mlx5dr_ste_build *sb,
-				  struct mlx5dr_match_param *mask)
-{
-	dr_ste_v0_build_src_gvmi_qpn_bit_mask(mask, sb->bit_mask);
-
-	sb->lu_type = MLX5DR_STE_LU_TYPE_SRC_GVMI_AND_QP;
-	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
-	sb->ste_build_tag_func = &dr_ste_v0_build_src_gvmi_qpn_tag;
-}
-
 void mlx5dr_ste_build_src_gvmi_qpn(struct mlx5dr_ste_ctx *ste_ctx,
 				   struct mlx5dr_ste_build *sb,
 				   struct mlx5dr_match_param *mask,
@@ -2412,29 +1156,6 @@ void mlx5dr_ste_build_src_gvmi_qpn(struct mlx5dr_ste_ctx *ste_ctx,
 	ste_ctx->build_src_gvmi_qpn_init(sb, mask);
 }
 
-static struct mlx5dr_ste_ctx ste_ctx_v0 = {
-	.build_eth_l2_src_dst_init	= &dr_ste_v0_build_eth_l2_src_dst_init,
-	.build_eth_l3_ipv6_src_init	= &dr_ste_v0_build_eth_l3_ipv6_src_init,
-	.build_eth_l3_ipv6_dst_init	= &dr_ste_v0_build_eth_l3_ipv6_dst_init,
-	.build_eth_l3_ipv4_5_tuple_init	= &dr_ste_v0_build_eth_l3_ipv4_5_tuple_init,
-	.build_eth_l2_src_init		= &dr_ste_v0_build_eth_l2_src_init,
-	.build_eth_l2_dst_init		= &dr_ste_v0_build_eth_l2_dst_init,
-	.build_eth_l2_tnl_init		= &dr_ste_v0_build_eth_l2_tnl_init,
-	.build_eth_l3_ipv4_misc_init	= &dr_ste_v0_build_eth_l3_ipv4_misc_init,
-	.build_eth_ipv6_l3_l4_init	= &dr_ste_v0_build_eth_ipv6_l3_l4_init,
-	.build_mpls_init		= &dr_ste_v0_build_mpls_init,
-	.build_tnl_gre_init		= &dr_ste_v0_build_tnl_gre_init,
-	.build_tnl_mpls_init		= &dr_ste_v0_build_tnl_mpls_init,
-	.build_icmp_init		= &dr_ste_v0_build_icmp_init,
-	.build_general_purpose_init	= &dr_ste_v0_build_general_purpose_init,
-	.build_eth_l4_misc_init		= &dr_ste_v0_build_eth_l4_misc_init,
-	.build_tnl_vxlan_gpe_init	= &dr_ste_v0_build_flex_parser_tnl_vxlan_gpe_init,
-	.build_tnl_geneve_init		= &dr_ste_v0_build_flex_parser_tnl_geneve_init,
-	.build_register_0_init		= &dr_ste_v0_build_register_0_init,
-	.build_register_1_init		= &dr_ste_v0_build_register_1_init,
-	.build_src_gvmi_qpn_init	= &dr_ste_v0_build_src_gvmi_qpn_init,
-};
-
 static struct mlx5dr_ste_ctx *mlx5dr_ste_ctx_arr[] = {
 	[MLX5_STEERING_FORMAT_CONNECTX_5] = &ste_ctx_v0,
 	[MLX5_STEERING_FORMAT_CONNECTX_6DX] = NULL,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
index ed91d98330b9..dd5317b72a73 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
@@ -111,4 +111,6 @@ struct mlx5dr_ste_ctx {
 	void DR_STE_CTX_BUILDER(src_gvmi_qpn);
 };
 
+extern struct mlx5dr_ste_ctx ste_ctx_v0;
+
 #endif  /* _DR_STE_ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
new file mode 100644
index 000000000000..97ba875999eb
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
@@ -0,0 +1,1283 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2020 NVIDIA CORPORATION. All rights reserved. */
+
+#include <linux/types.h>
+#include <linux/crc32.h>
+#include "dr_ste.h"
+
+#define DR_STE_CALC_LU_TYPE(lookup_type, rx, inner) \
+	((inner) ? MLX5DR_STE_LU_TYPE_##lookup_type##_I : \
+		   (rx) ? MLX5DR_STE_LU_TYPE_##lookup_type##_D : \
+			  MLX5DR_STE_LU_TYPE_##lookup_type##_O)
+
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
+{
+	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
+
+	DR_STE_SET_TAG(eth_l2_src_dst, tag, dmac_47_16, spec, dmac_47_16);
+	DR_STE_SET_TAG(eth_l2_src_dst, tag, dmac_15_0, spec, dmac_15_0);
+
+	if (spec->smac_47_16 || spec->smac_15_0) {
+		MLX5_SET(ste_eth_l2_src_dst, tag, smac_47_32,
+			 spec->smac_47_16 >> 16);
+		MLX5_SET(ste_eth_l2_src_dst, tag, smac_31_0,
+			 spec->smac_47_16 << 16 | spec->smac_15_0);
+		spec->smac_47_16 = 0;
+		spec->smac_15_0 = 0;
+	}
+
+	if (spec->ip_version) {
+		if (spec->ip_version == IP_VERSION_IPV4) {
+			MLX5_SET(ste_eth_l2_src_dst, tag, l3_type, STE_IPV4);
+			spec->ip_version = 0;
+		} else if (spec->ip_version == IP_VERSION_IPV6) {
+			MLX5_SET(ste_eth_l2_src_dst, tag, l3_type, STE_IPV6);
+			spec->ip_version = 0;
+		} else {
+			return -EINVAL;
+		}
+	}
+
+	DR_STE_SET_TAG(eth_l2_src_dst, tag, first_vlan_id, spec, first_vid);
+	DR_STE_SET_TAG(eth_l2_src_dst, tag, first_cfi, spec, first_cfi);
+	DR_STE_SET_TAG(eth_l2_src_dst, tag, first_priority, spec, first_prio);
+
+	if (spec->cvlan_tag) {
+		MLX5_SET(ste_eth_l2_src_dst, tag, first_vlan_qualifier, DR_STE_CVLAN);
+		spec->cvlan_tag = 0;
+	} else if (spec->svlan_tag) {
+		MLX5_SET(ste_eth_l2_src_dst, tag, first_vlan_qualifier, DR_STE_SVLAN);
+		spec->svlan_tag = 0;
+	}
+	return 0;
+}
+
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
+static void
+dr_ste_v0_build_eth_l3_ipv6_dst_bit_mask(struct mlx5dr_match_param *value,
+					 bool inner, u8 *bit_mask)
+{
+	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
+
+	DR_STE_SET_MASK_V(eth_l3_ipv6_dst, bit_mask, dst_ip_127_96, mask, dst_ip_127_96);
+	DR_STE_SET_MASK_V(eth_l3_ipv6_dst, bit_mask, dst_ip_95_64, mask, dst_ip_95_64);
+	DR_STE_SET_MASK_V(eth_l3_ipv6_dst, bit_mask, dst_ip_63_32, mask, dst_ip_63_32);
+	DR_STE_SET_MASK_V(eth_l3_ipv6_dst, bit_mask, dst_ip_31_0, mask, dst_ip_31_0);
+}
+
+static int
+dr_ste_v0_build_eth_l3_ipv6_dst_tag(struct mlx5dr_match_param *value,
+				    struct mlx5dr_ste_build *sb,
+				    u8 *tag)
+{
+	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
+
+	DR_STE_SET_TAG(eth_l3_ipv6_dst, tag, dst_ip_127_96, spec, dst_ip_127_96);
+	DR_STE_SET_TAG(eth_l3_ipv6_dst, tag, dst_ip_95_64, spec, dst_ip_95_64);
+	DR_STE_SET_TAG(eth_l3_ipv6_dst, tag, dst_ip_63_32, spec, dst_ip_63_32);
+	DR_STE_SET_TAG(eth_l3_ipv6_dst, tag, dst_ip_31_0, spec, dst_ip_31_0);
+
+	return 0;
+}
+
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
+static void
+dr_ste_v0_build_eth_l3_ipv6_src_bit_mask(struct mlx5dr_match_param *value,
+					 bool inner, u8 *bit_mask)
+{
+	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
+
+	DR_STE_SET_MASK_V(eth_l3_ipv6_src, bit_mask, src_ip_127_96, mask, src_ip_127_96);
+	DR_STE_SET_MASK_V(eth_l3_ipv6_src, bit_mask, src_ip_95_64, mask, src_ip_95_64);
+	DR_STE_SET_MASK_V(eth_l3_ipv6_src, bit_mask, src_ip_63_32, mask, src_ip_63_32);
+	DR_STE_SET_MASK_V(eth_l3_ipv6_src, bit_mask, src_ip_31_0, mask, src_ip_31_0);
+}
+
+static int
+dr_ste_v0_build_eth_l3_ipv6_src_tag(struct mlx5dr_match_param *value,
+				    struct mlx5dr_ste_build *sb,
+				    u8 *tag)
+{
+	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
+
+	DR_STE_SET_TAG(eth_l3_ipv6_src, tag, src_ip_127_96, spec, src_ip_127_96);
+	DR_STE_SET_TAG(eth_l3_ipv6_src, tag, src_ip_95_64, spec, src_ip_95_64);
+	DR_STE_SET_TAG(eth_l3_ipv6_src, tag, src_ip_63_32, spec, src_ip_63_32);
+	DR_STE_SET_TAG(eth_l3_ipv6_src, tag, src_ip_31_0, spec, src_ip_31_0);
+
+	return 0;
+}
+
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
+static void
+dr_ste_v0_build_eth_l3_ipv4_5_tuple_bit_mask(struct mlx5dr_match_param *value,
+					     bool inner,
+					     u8 *bit_mask)
+{
+	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
+
+	DR_STE_SET_MASK_V(eth_l3_ipv4_5_tuple, bit_mask,
+			  destination_address, mask, dst_ip_31_0);
+	DR_STE_SET_MASK_V(eth_l3_ipv4_5_tuple, bit_mask,
+			  source_address, mask, src_ip_31_0);
+	DR_STE_SET_MASK_V(eth_l3_ipv4_5_tuple, bit_mask,
+			  destination_port, mask, tcp_dport);
+	DR_STE_SET_MASK_V(eth_l3_ipv4_5_tuple, bit_mask,
+			  destination_port, mask, udp_dport);
+	DR_STE_SET_MASK_V(eth_l3_ipv4_5_tuple, bit_mask,
+			  source_port, mask, tcp_sport);
+	DR_STE_SET_MASK_V(eth_l3_ipv4_5_tuple, bit_mask,
+			  source_port, mask, udp_sport);
+	DR_STE_SET_MASK_V(eth_l3_ipv4_5_tuple, bit_mask,
+			  protocol, mask, ip_protocol);
+	DR_STE_SET_MASK_V(eth_l3_ipv4_5_tuple, bit_mask,
+			  fragmented, mask, frag);
+	DR_STE_SET_MASK_V(eth_l3_ipv4_5_tuple, bit_mask,
+			  dscp, mask, ip_dscp);
+	DR_STE_SET_MASK_V(eth_l3_ipv4_5_tuple, bit_mask,
+			  ecn, mask, ip_ecn);
+
+	if (mask->tcp_flags) {
+		DR_STE_SET_TCP_FLAGS(eth_l3_ipv4_5_tuple, bit_mask, mask);
+		mask->tcp_flags = 0;
+	}
+}
+
+static int
+dr_ste_v0_build_eth_l3_ipv4_5_tuple_tag(struct mlx5dr_match_param *value,
+					struct mlx5dr_ste_build *sb,
+					u8 *tag)
+{
+	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
+
+	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple, tag, destination_address, spec, dst_ip_31_0);
+	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple, tag, source_address, spec, src_ip_31_0);
+	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple, tag, destination_port, spec, tcp_dport);
+	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple, tag, destination_port, spec, udp_dport);
+	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple, tag, source_port, spec, tcp_sport);
+	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple, tag, source_port, spec, udp_sport);
+	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple, tag, protocol, spec, ip_protocol);
+	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple, tag, fragmented, spec, frag);
+	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple, tag, dscp, spec, ip_dscp);
+	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple, tag, ecn, spec, ip_ecn);
+
+	if (spec->tcp_flags) {
+		DR_STE_SET_TCP_FLAGS(eth_l3_ipv4_5_tuple, tag, spec);
+		spec->tcp_flags = 0;
+	}
+
+	return 0;
+}
+
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
+static void
+dr_ste_v0_build_eth_l2_src_or_dst_bit_mask(struct mlx5dr_match_param *value,
+					   bool inner, u8 *bit_mask)
+{
+	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
+	struct mlx5dr_match_misc *misc_mask = &value->misc;
+
+	DR_STE_SET_MASK_V(eth_l2_src, bit_mask, first_vlan_id, mask, first_vid);
+	DR_STE_SET_MASK_V(eth_l2_src, bit_mask, first_cfi, mask, first_cfi);
+	DR_STE_SET_MASK_V(eth_l2_src, bit_mask, first_priority, mask, first_prio);
+	DR_STE_SET_MASK_V(eth_l2_src, bit_mask, ip_fragmented, mask, frag);
+	DR_STE_SET_MASK_V(eth_l2_src, bit_mask, l3_ethertype, mask, ethertype);
+	DR_STE_SET_MASK(eth_l2_src, bit_mask, l3_type, mask, ip_version);
+
+	if (mask->svlan_tag || mask->cvlan_tag) {
+		MLX5_SET(ste_eth_l2_src, bit_mask, first_vlan_qualifier, -1);
+		mask->cvlan_tag = 0;
+		mask->svlan_tag = 0;
+	}
+
+	if (inner) {
+		if (misc_mask->inner_second_cvlan_tag ||
+		    misc_mask->inner_second_svlan_tag) {
+			MLX5_SET(ste_eth_l2_src, bit_mask, second_vlan_qualifier, -1);
+			misc_mask->inner_second_cvlan_tag = 0;
+			misc_mask->inner_second_svlan_tag = 0;
+		}
+
+		DR_STE_SET_MASK_V(eth_l2_src, bit_mask,
+				  second_vlan_id, misc_mask, inner_second_vid);
+		DR_STE_SET_MASK_V(eth_l2_src, bit_mask,
+				  second_cfi, misc_mask, inner_second_cfi);
+		DR_STE_SET_MASK_V(eth_l2_src, bit_mask,
+				  second_priority, misc_mask, inner_second_prio);
+	} else {
+		if (misc_mask->outer_second_cvlan_tag ||
+		    misc_mask->outer_second_svlan_tag) {
+			MLX5_SET(ste_eth_l2_src, bit_mask, second_vlan_qualifier, -1);
+			misc_mask->outer_second_cvlan_tag = 0;
+			misc_mask->outer_second_svlan_tag = 0;
+		}
+
+		DR_STE_SET_MASK_V(eth_l2_src, bit_mask,
+				  second_vlan_id, misc_mask, outer_second_vid);
+		DR_STE_SET_MASK_V(eth_l2_src, bit_mask,
+				  second_cfi, misc_mask, outer_second_cfi);
+		DR_STE_SET_MASK_V(eth_l2_src, bit_mask,
+				  second_priority, misc_mask, outer_second_prio);
+	}
+}
+
+static int
+dr_ste_v0_build_eth_l2_src_or_dst_tag(struct mlx5dr_match_param *value,
+				      bool inner, u8 *tag)
+{
+	struct mlx5dr_match_spec *spec = inner ? &value->inner : &value->outer;
+	struct mlx5dr_match_misc *misc_spec = &value->misc;
+
+	DR_STE_SET_TAG(eth_l2_src, tag, first_vlan_id, spec, first_vid);
+	DR_STE_SET_TAG(eth_l2_src, tag, first_cfi, spec, first_cfi);
+	DR_STE_SET_TAG(eth_l2_src, tag, first_priority, spec, first_prio);
+	DR_STE_SET_TAG(eth_l2_src, tag, ip_fragmented, spec, frag);
+	DR_STE_SET_TAG(eth_l2_src, tag, l3_ethertype, spec, ethertype);
+
+	if (spec->ip_version) {
+		if (spec->ip_version == IP_VERSION_IPV4) {
+			MLX5_SET(ste_eth_l2_src, tag, l3_type, STE_IPV4);
+			spec->ip_version = 0;
+		} else if (spec->ip_version == IP_VERSION_IPV6) {
+			MLX5_SET(ste_eth_l2_src, tag, l3_type, STE_IPV6);
+			spec->ip_version = 0;
+		} else {
+			return -EINVAL;
+		}
+	}
+
+	if (spec->cvlan_tag) {
+		MLX5_SET(ste_eth_l2_src, tag, first_vlan_qualifier, DR_STE_CVLAN);
+		spec->cvlan_tag = 0;
+	} else if (spec->svlan_tag) {
+		MLX5_SET(ste_eth_l2_src, tag, first_vlan_qualifier, DR_STE_SVLAN);
+		spec->svlan_tag = 0;
+	}
+
+	if (inner) {
+		if (misc_spec->inner_second_cvlan_tag) {
+			MLX5_SET(ste_eth_l2_src, tag, second_vlan_qualifier, DR_STE_CVLAN);
+			misc_spec->inner_second_cvlan_tag = 0;
+		} else if (misc_spec->inner_second_svlan_tag) {
+			MLX5_SET(ste_eth_l2_src, tag, second_vlan_qualifier, DR_STE_SVLAN);
+			misc_spec->inner_second_svlan_tag = 0;
+		}
+
+		DR_STE_SET_TAG(eth_l2_src, tag, second_vlan_id, misc_spec, inner_second_vid);
+		DR_STE_SET_TAG(eth_l2_src, tag, second_cfi, misc_spec, inner_second_cfi);
+		DR_STE_SET_TAG(eth_l2_src, tag, second_priority, misc_spec, inner_second_prio);
+	} else {
+		if (misc_spec->outer_second_cvlan_tag) {
+			MLX5_SET(ste_eth_l2_src, tag, second_vlan_qualifier, DR_STE_CVLAN);
+			misc_spec->outer_second_cvlan_tag = 0;
+		} else if (misc_spec->outer_second_svlan_tag) {
+			MLX5_SET(ste_eth_l2_src, tag, second_vlan_qualifier, DR_STE_SVLAN);
+			misc_spec->outer_second_svlan_tag = 0;
+		}
+		DR_STE_SET_TAG(eth_l2_src, tag, second_vlan_id, misc_spec, outer_second_vid);
+		DR_STE_SET_TAG(eth_l2_src, tag, second_cfi, misc_spec, outer_second_cfi);
+		DR_STE_SET_TAG(eth_l2_src, tag, second_priority, misc_spec, outer_second_prio);
+	}
+
+	return 0;
+}
+
+static void
+dr_ste_v0_build_eth_l2_src_bit_mask(struct mlx5dr_match_param *value,
+				    bool inner, u8 *bit_mask)
+{
+	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
+
+	DR_STE_SET_MASK_V(eth_l2_src, bit_mask, smac_47_16, mask, smac_47_16);
+	DR_STE_SET_MASK_V(eth_l2_src, bit_mask, smac_15_0, mask, smac_15_0);
+
+	dr_ste_v0_build_eth_l2_src_or_dst_bit_mask(value, inner, bit_mask);
+}
+
+static int
+dr_ste_v0_build_eth_l2_src_tag(struct mlx5dr_match_param *value,
+			       struct mlx5dr_ste_build *sb,
+			       u8 *tag)
+{
+	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
+
+	DR_STE_SET_TAG(eth_l2_src, tag, smac_47_16, spec, smac_47_16);
+	DR_STE_SET_TAG(eth_l2_src, tag, smac_15_0, spec, smac_15_0);
+
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
+}
+
+static void
+dr_ste_v0_build_eth_l2_dst_bit_mask(struct mlx5dr_match_param *value,
+				    bool inner, u8 *bit_mask)
+{
+	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
+
+	DR_STE_SET_MASK_V(eth_l2_dst, bit_mask, dmac_47_16, mask, dmac_47_16);
+	DR_STE_SET_MASK_V(eth_l2_dst, bit_mask, dmac_15_0, mask, dmac_15_0);
+
+	dr_ste_v0_build_eth_l2_src_or_dst_bit_mask(value, inner, bit_mask);
+}
+
+static int
+dr_ste_v0_build_eth_l2_dst_tag(struct mlx5dr_match_param *value,
+			       struct mlx5dr_ste_build *sb,
+			       u8 *tag)
+{
+	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
+
+	DR_STE_SET_TAG(eth_l2_dst, tag, dmac_47_16, spec, dmac_47_16);
+	DR_STE_SET_TAG(eth_l2_dst, tag, dmac_15_0, spec, dmac_15_0);
+
+	return dr_ste_v0_build_eth_l2_src_or_dst_tag(value, sb->inner, tag);
+}
+
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
+static void
+dr_ste_v0_build_eth_l2_tnl_bit_mask(struct mlx5dr_match_param *value,
+				    bool inner, u8 *bit_mask)
+{
+	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
+	struct mlx5dr_match_misc *misc = &value->misc;
+
+	DR_STE_SET_MASK_V(eth_l2_tnl, bit_mask, dmac_47_16, mask, dmac_47_16);
+	DR_STE_SET_MASK_V(eth_l2_tnl, bit_mask, dmac_15_0, mask, dmac_15_0);
+	DR_STE_SET_MASK_V(eth_l2_tnl, bit_mask, first_vlan_id, mask, first_vid);
+	DR_STE_SET_MASK_V(eth_l2_tnl, bit_mask, first_cfi, mask, first_cfi);
+	DR_STE_SET_MASK_V(eth_l2_tnl, bit_mask, first_priority, mask, first_prio);
+	DR_STE_SET_MASK_V(eth_l2_tnl, bit_mask, ip_fragmented, mask, frag);
+	DR_STE_SET_MASK_V(eth_l2_tnl, bit_mask, l3_ethertype, mask, ethertype);
+	DR_STE_SET_MASK(eth_l2_tnl, bit_mask, l3_type, mask, ip_version);
+
+	if (misc->vxlan_vni) {
+		MLX5_SET(ste_eth_l2_tnl, bit_mask,
+			 l2_tunneling_network_id, (misc->vxlan_vni << 8));
+		misc->vxlan_vni = 0;
+	}
+
+	if (mask->svlan_tag || mask->cvlan_tag) {
+		MLX5_SET(ste_eth_l2_tnl, bit_mask, first_vlan_qualifier, -1);
+		mask->cvlan_tag = 0;
+		mask->svlan_tag = 0;
+	}
+}
+
+static int
+dr_ste_v0_build_eth_l2_tnl_tag(struct mlx5dr_match_param *value,
+			       struct mlx5dr_ste_build *sb,
+			       u8 *tag)
+{
+	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
+	struct mlx5dr_match_misc *misc = &value->misc;
+
+	DR_STE_SET_TAG(eth_l2_tnl, tag, dmac_47_16, spec, dmac_47_16);
+	DR_STE_SET_TAG(eth_l2_tnl, tag, dmac_15_0, spec, dmac_15_0);
+	DR_STE_SET_TAG(eth_l2_tnl, tag, first_vlan_id, spec, first_vid);
+	DR_STE_SET_TAG(eth_l2_tnl, tag, first_cfi, spec, first_cfi);
+	DR_STE_SET_TAG(eth_l2_tnl, tag, ip_fragmented, spec, frag);
+	DR_STE_SET_TAG(eth_l2_tnl, tag, first_priority, spec, first_prio);
+	DR_STE_SET_TAG(eth_l2_tnl, tag, l3_ethertype, spec, ethertype);
+
+	if (misc->vxlan_vni) {
+		MLX5_SET(ste_eth_l2_tnl, tag, l2_tunneling_network_id,
+			 (misc->vxlan_vni << 8));
+		misc->vxlan_vni = 0;
+	}
+
+	if (spec->cvlan_tag) {
+		MLX5_SET(ste_eth_l2_tnl, tag, first_vlan_qualifier, DR_STE_CVLAN);
+		spec->cvlan_tag = 0;
+	} else if (spec->svlan_tag) {
+		MLX5_SET(ste_eth_l2_tnl, tag, first_vlan_qualifier, DR_STE_SVLAN);
+		spec->svlan_tag = 0;
+	}
+
+	if (spec->ip_version) {
+		if (spec->ip_version == IP_VERSION_IPV4) {
+			MLX5_SET(ste_eth_l2_tnl, tag, l3_type, STE_IPV4);
+			spec->ip_version = 0;
+		} else if (spec->ip_version == IP_VERSION_IPV6) {
+			MLX5_SET(ste_eth_l2_tnl, tag, l3_type, STE_IPV6);
+			spec->ip_version = 0;
+		} else {
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static void
+dr_ste_v0_build_eth_l2_tnl_init(struct mlx5dr_ste_build *sb,
+				struct mlx5dr_match_param *mask)
+{
+	dr_ste_v0_build_eth_l2_tnl_bit_mask(mask, sb->inner, sb->bit_mask);
+
+	sb->lu_type = MLX5DR_STE_LU_TYPE_ETHL2_TUNNELING_I;
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v0_build_eth_l2_tnl_tag;
+}
+
+static void
+dr_ste_v0_build_eth_l3_ipv4_misc_bit_mask(struct mlx5dr_match_param *value,
+					  bool inner, u8 *bit_mask)
+{
+	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
+
+	DR_STE_SET_MASK_V(eth_l3_ipv4_misc, bit_mask, time_to_live, mask, ttl_hoplimit);
+}
+
+static int
+dr_ste_v0_build_eth_l3_ipv4_misc_tag(struct mlx5dr_match_param *value,
+				     struct mlx5dr_ste_build *sb,
+				     u8 *tag)
+{
+	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
+
+	DR_STE_SET_TAG(eth_l3_ipv4_misc, tag, time_to_live, spec, ttl_hoplimit);
+
+	return 0;
+}
+
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
+static void
+dr_ste_v0_build_eth_ipv6_l3_l4_bit_mask(struct mlx5dr_match_param *value,
+					bool inner, u8 *bit_mask)
+{
+	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
+
+	DR_STE_SET_MASK_V(eth_l4, bit_mask, dst_port, mask, tcp_dport);
+	DR_STE_SET_MASK_V(eth_l4, bit_mask, src_port, mask, tcp_sport);
+	DR_STE_SET_MASK_V(eth_l4, bit_mask, dst_port, mask, udp_dport);
+	DR_STE_SET_MASK_V(eth_l4, bit_mask, src_port, mask, udp_sport);
+	DR_STE_SET_MASK_V(eth_l4, bit_mask, protocol, mask, ip_protocol);
+	DR_STE_SET_MASK_V(eth_l4, bit_mask, fragmented, mask, frag);
+	DR_STE_SET_MASK_V(eth_l4, bit_mask, dscp, mask, ip_dscp);
+	DR_STE_SET_MASK_V(eth_l4, bit_mask, ecn, mask, ip_ecn);
+	DR_STE_SET_MASK_V(eth_l4, bit_mask, ipv6_hop_limit, mask, ttl_hoplimit);
+
+	if (mask->tcp_flags) {
+		DR_STE_SET_TCP_FLAGS(eth_l4, bit_mask, mask);
+		mask->tcp_flags = 0;
+	}
+}
+
+static int
+dr_ste_v0_build_eth_ipv6_l3_l4_tag(struct mlx5dr_match_param *value,
+				   struct mlx5dr_ste_build *sb,
+				   u8 *tag)
+{
+	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
+
+	DR_STE_SET_TAG(eth_l4, tag, dst_port, spec, tcp_dport);
+	DR_STE_SET_TAG(eth_l4, tag, src_port, spec, tcp_sport);
+	DR_STE_SET_TAG(eth_l4, tag, dst_port, spec, udp_dport);
+	DR_STE_SET_TAG(eth_l4, tag, src_port, spec, udp_sport);
+	DR_STE_SET_TAG(eth_l4, tag, protocol, spec, ip_protocol);
+	DR_STE_SET_TAG(eth_l4, tag, fragmented, spec, frag);
+	DR_STE_SET_TAG(eth_l4, tag, dscp, spec, ip_dscp);
+	DR_STE_SET_TAG(eth_l4, tag, ecn, spec, ip_ecn);
+	DR_STE_SET_TAG(eth_l4, tag, ipv6_hop_limit, spec, ttl_hoplimit);
+
+	if (spec->tcp_flags) {
+		DR_STE_SET_TCP_FLAGS(eth_l4, tag, spec);
+		spec->tcp_flags = 0;
+	}
+
+	return 0;
+}
+
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
+static void
+dr_ste_v0_build_mpls_bit_mask(struct mlx5dr_match_param *value,
+			      bool inner, u8 *bit_mask)
+{
+	struct mlx5dr_match_misc2 *misc2_mask = &value->misc2;
+
+	if (inner)
+		DR_STE_SET_MPLS_MASK(mpls, misc2_mask, inner, bit_mask);
+	else
+		DR_STE_SET_MPLS_MASK(mpls, misc2_mask, outer, bit_mask);
+}
+
+static int
+dr_ste_v0_build_mpls_tag(struct mlx5dr_match_param *value,
+			 struct mlx5dr_ste_build *sb,
+			 u8 *tag)
+{
+	struct mlx5dr_match_misc2 *misc2_mask = &value->misc2;
+
+	if (sb->inner)
+		DR_STE_SET_MPLS_TAG(mpls, misc2_mask, inner, tag);
+	else
+		DR_STE_SET_MPLS_TAG(mpls, misc2_mask, outer, tag);
+
+	return 0;
+}
+
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
+static void
+dr_ste_v0_build_tnl_gre_bit_mask(struct mlx5dr_match_param *value,
+				 bool inner, u8 *bit_mask)
+{
+	struct mlx5dr_match_misc *misc_mask = &value->misc;
+
+	DR_STE_SET_MASK_V(gre, bit_mask, gre_protocol, misc_mask, gre_protocol);
+	DR_STE_SET_MASK_V(gre, bit_mask, gre_k_present, misc_mask, gre_k_present);
+	DR_STE_SET_MASK_V(gre, bit_mask, gre_key_h, misc_mask, gre_key_h);
+	DR_STE_SET_MASK_V(gre, bit_mask, gre_key_l, misc_mask, gre_key_l);
+
+	DR_STE_SET_MASK_V(gre, bit_mask, gre_c_present, misc_mask, gre_c_present);
+	DR_STE_SET_MASK_V(gre, bit_mask, gre_s_present, misc_mask, gre_s_present);
+}
+
+static int
+dr_ste_v0_build_tnl_gre_tag(struct mlx5dr_match_param *value,
+			    struct mlx5dr_ste_build *sb,
+			    u8 *tag)
+{
+	struct  mlx5dr_match_misc *misc = &value->misc;
+
+	DR_STE_SET_TAG(gre, tag, gre_protocol, misc, gre_protocol);
+
+	DR_STE_SET_TAG(gre, tag, gre_k_present, misc, gre_k_present);
+	DR_STE_SET_TAG(gre, tag, gre_key_h, misc, gre_key_h);
+	DR_STE_SET_TAG(gre, tag, gre_key_l, misc, gre_key_l);
+
+	DR_STE_SET_TAG(gre, tag, gre_c_present, misc, gre_c_present);
+
+	DR_STE_SET_TAG(gre, tag, gre_s_present, misc, gre_s_present);
+
+	return 0;
+}
+
+static void
+dr_ste_v0_build_tnl_gre_init(struct mlx5dr_ste_build *sb,
+			     struct mlx5dr_match_param *mask)
+{
+	dr_ste_v0_build_tnl_gre_bit_mask(mask, sb->inner, sb->bit_mask);
+
+	sb->lu_type = MLX5DR_STE_LU_TYPE_GRE;
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v0_build_tnl_gre_tag;
+}
+
+static void
+dr_ste_v0_build_tnl_mpls_bit_mask(struct mlx5dr_match_param *value,
+				  bool inner, u8 *bit_mask)
+{
+	struct mlx5dr_match_misc2 *misc_2_mask = &value->misc2;
+
+	if (DR_STE_IS_OUTER_MPLS_OVER_GRE_SET(misc_2_mask)) {
+		DR_STE_SET_MASK_V(flex_parser_0, bit_mask, parser_3_label,
+				  misc_2_mask, outer_first_mpls_over_gre_label);
+
+		DR_STE_SET_MASK_V(flex_parser_0, bit_mask, parser_3_exp,
+				  misc_2_mask, outer_first_mpls_over_gre_exp);
+
+		DR_STE_SET_MASK_V(flex_parser_0, bit_mask, parser_3_s_bos,
+				  misc_2_mask, outer_first_mpls_over_gre_s_bos);
+
+		DR_STE_SET_MASK_V(flex_parser_0, bit_mask, parser_3_ttl,
+				  misc_2_mask, outer_first_mpls_over_gre_ttl);
+	} else {
+		DR_STE_SET_MASK_V(flex_parser_0, bit_mask, parser_3_label,
+				  misc_2_mask, outer_first_mpls_over_udp_label);
+
+		DR_STE_SET_MASK_V(flex_parser_0, bit_mask, parser_3_exp,
+				  misc_2_mask, outer_first_mpls_over_udp_exp);
+
+		DR_STE_SET_MASK_V(flex_parser_0, bit_mask, parser_3_s_bos,
+				  misc_2_mask, outer_first_mpls_over_udp_s_bos);
+
+		DR_STE_SET_MASK_V(flex_parser_0, bit_mask, parser_3_ttl,
+				  misc_2_mask, outer_first_mpls_over_udp_ttl);
+	}
+}
+
+static int
+dr_ste_v0_build_tnl_mpls_tag(struct mlx5dr_match_param *value,
+			     struct mlx5dr_ste_build *sb,
+			     u8 *tag)
+{
+	struct mlx5dr_match_misc2 *misc_2_mask = &value->misc2;
+
+	if (DR_STE_IS_OUTER_MPLS_OVER_GRE_SET(misc_2_mask)) {
+		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_label,
+			       misc_2_mask, outer_first_mpls_over_gre_label);
+
+		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_exp,
+			       misc_2_mask, outer_first_mpls_over_gre_exp);
+
+		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_s_bos,
+			       misc_2_mask, outer_first_mpls_over_gre_s_bos);
+
+		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_ttl,
+			       misc_2_mask, outer_first_mpls_over_gre_ttl);
+	} else {
+		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_label,
+			       misc_2_mask, outer_first_mpls_over_udp_label);
+
+		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_exp,
+			       misc_2_mask, outer_first_mpls_over_udp_exp);
+
+		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_s_bos,
+			       misc_2_mask, outer_first_mpls_over_udp_s_bos);
+
+		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_ttl,
+			       misc_2_mask, outer_first_mpls_over_udp_ttl);
+	}
+	return 0;
+}
+
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
+#define ICMP_TYPE_OFFSET_FIRST_DW		24
+#define ICMP_CODE_OFFSET_FIRST_DW		16
+#define ICMP_HEADER_DATA_OFFSET_SECOND_DW	0
+
+static int
+dr_ste_v0_build_icmp_bit_mask(struct mlx5dr_match_param *mask,
+			      struct mlx5dr_cmd_caps *caps,
+			      u8 *bit_mask)
+{
+	struct mlx5dr_match_misc3 *misc_3_mask = &mask->misc3;
+	bool is_ipv4_mask = DR_MASK_IS_ICMPV4_SET(misc_3_mask);
+	u32 icmp_header_data_mask;
+	u32 icmp_type_mask;
+	u32 icmp_code_mask;
+	int dw0_location;
+	int dw1_location;
+
+	if (is_ipv4_mask) {
+		icmp_header_data_mask	= misc_3_mask->icmpv4_header_data;
+		icmp_type_mask		= misc_3_mask->icmpv4_type;
+		icmp_code_mask		= misc_3_mask->icmpv4_code;
+		dw0_location		= caps->flex_parser_id_icmp_dw0;
+		dw1_location		= caps->flex_parser_id_icmp_dw1;
+	} else {
+		icmp_header_data_mask	= misc_3_mask->icmpv6_header_data;
+		icmp_type_mask		= misc_3_mask->icmpv6_type;
+		icmp_code_mask		= misc_3_mask->icmpv6_code;
+		dw0_location		= caps->flex_parser_id_icmpv6_dw0;
+		dw1_location		= caps->flex_parser_id_icmpv6_dw1;
+	}
+
+	switch (dw0_location) {
+	case 4:
+		if (icmp_type_mask) {
+			MLX5_SET(ste_flex_parser_1, bit_mask, flex_parser_4,
+				 (icmp_type_mask << ICMP_TYPE_OFFSET_FIRST_DW));
+			if (is_ipv4_mask)
+				misc_3_mask->icmpv4_type = 0;
+			else
+				misc_3_mask->icmpv6_type = 0;
+		}
+		if (icmp_code_mask) {
+			u32 cur_val = MLX5_GET(ste_flex_parser_1, bit_mask,
+					       flex_parser_4);
+			MLX5_SET(ste_flex_parser_1, bit_mask, flex_parser_4,
+				 cur_val | (icmp_code_mask << ICMP_CODE_OFFSET_FIRST_DW));
+			if (is_ipv4_mask)
+				misc_3_mask->icmpv4_code = 0;
+			else
+				misc_3_mask->icmpv6_code = 0;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (dw1_location) {
+	case 5:
+		if (icmp_header_data_mask) {
+			MLX5_SET(ste_flex_parser_1, bit_mask, flex_parser_5,
+				 (icmp_header_data_mask << ICMP_HEADER_DATA_OFFSET_SECOND_DW));
+			if (is_ipv4_mask)
+				misc_3_mask->icmpv4_header_data = 0;
+			else
+				misc_3_mask->icmpv6_header_data = 0;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int
+dr_ste_v0_build_icmp_tag(struct mlx5dr_match_param *value,
+			 struct mlx5dr_ste_build *sb,
+			 u8 *tag)
+{
+	struct mlx5dr_match_misc3 *misc_3 = &value->misc3;
+	u32 icmp_header_data;
+	int dw0_location;
+	int dw1_location;
+	u32 icmp_type;
+	u32 icmp_code;
+	bool is_ipv4;
+
+	is_ipv4 = DR_MASK_IS_ICMPV4_SET(misc_3);
+	if (is_ipv4) {
+		icmp_header_data	= misc_3->icmpv4_header_data;
+		icmp_type		= misc_3->icmpv4_type;
+		icmp_code		= misc_3->icmpv4_code;
+		dw0_location		= sb->caps->flex_parser_id_icmp_dw0;
+		dw1_location		= sb->caps->flex_parser_id_icmp_dw1;
+	} else {
+		icmp_header_data	= misc_3->icmpv6_header_data;
+		icmp_type		= misc_3->icmpv6_type;
+		icmp_code		= misc_3->icmpv6_code;
+		dw0_location		= sb->caps->flex_parser_id_icmpv6_dw0;
+		dw1_location		= sb->caps->flex_parser_id_icmpv6_dw1;
+	}
+
+	switch (dw0_location) {
+	case 4:
+		if (icmp_type) {
+			MLX5_SET(ste_flex_parser_1, tag, flex_parser_4,
+				 (icmp_type << ICMP_TYPE_OFFSET_FIRST_DW));
+			if (is_ipv4)
+				misc_3->icmpv4_type = 0;
+			else
+				misc_3->icmpv6_type = 0;
+		}
+
+		if (icmp_code) {
+			u32 cur_val = MLX5_GET(ste_flex_parser_1, tag,
+					       flex_parser_4);
+			MLX5_SET(ste_flex_parser_1, tag, flex_parser_4,
+				 cur_val | (icmp_code << ICMP_CODE_OFFSET_FIRST_DW));
+			if (is_ipv4)
+				misc_3->icmpv4_code = 0;
+			else
+				misc_3->icmpv6_code = 0;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (dw1_location) {
+	case 5:
+		if (icmp_header_data) {
+			MLX5_SET(ste_flex_parser_1, tag, flex_parser_5,
+				 (icmp_header_data << ICMP_HEADER_DATA_OFFSET_SECOND_DW));
+			if (is_ipv4)
+				misc_3->icmpv4_header_data = 0;
+			else
+				misc_3->icmpv6_header_data = 0;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int
+dr_ste_v0_build_icmp_init(struct mlx5dr_ste_build *sb,
+			  struct mlx5dr_match_param *mask)
+{
+	int ret;
+
+	ret = dr_ste_v0_build_icmp_bit_mask(mask, sb->caps, sb->bit_mask);
+	if (ret)
+		return ret;
+
+	sb->lu_type = MLX5DR_STE_LU_TYPE_FLEX_PARSER_1;
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v0_build_icmp_tag;
+
+	return 0;
+}
+
+static void
+dr_ste_v0_build_general_purpose_bit_mask(struct mlx5dr_match_param *value,
+					 bool inner, u8 *bit_mask)
+{
+	struct mlx5dr_match_misc2 *misc_2_mask = &value->misc2;
+
+	DR_STE_SET_MASK_V(general_purpose, bit_mask,
+			  general_purpose_lookup_field, misc_2_mask,
+			  metadata_reg_a);
+}
+
+static int
+dr_ste_v0_build_general_purpose_tag(struct mlx5dr_match_param *value,
+				    struct mlx5dr_ste_build *sb,
+				    u8 *tag)
+{
+	struct mlx5dr_match_misc2 *misc_2_mask = &value->misc2;
+
+	DR_STE_SET_TAG(general_purpose, tag, general_purpose_lookup_field,
+		       misc_2_mask, metadata_reg_a);
+
+	return 0;
+}
+
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
+static void
+dr_ste_v0_build_eth_l4_misc_bit_mask(struct mlx5dr_match_param *value,
+				     bool inner, u8 *bit_mask)
+{
+	struct mlx5dr_match_misc3 *misc_3_mask = &value->misc3;
+
+	if (inner) {
+		DR_STE_SET_MASK_V(eth_l4_misc, bit_mask, seq_num, misc_3_mask,
+				  inner_tcp_seq_num);
+		DR_STE_SET_MASK_V(eth_l4_misc, bit_mask, ack_num, misc_3_mask,
+				  inner_tcp_ack_num);
+	} else {
+		DR_STE_SET_MASK_V(eth_l4_misc, bit_mask, seq_num, misc_3_mask,
+				  outer_tcp_seq_num);
+		DR_STE_SET_MASK_V(eth_l4_misc, bit_mask, ack_num, misc_3_mask,
+				  outer_tcp_ack_num);
+	}
+}
+
+static int
+dr_ste_v0_build_eth_l4_misc_tag(struct mlx5dr_match_param *value,
+				struct mlx5dr_ste_build *sb,
+				u8 *tag)
+{
+	struct mlx5dr_match_misc3 *misc3 = &value->misc3;
+
+	if (sb->inner) {
+		DR_STE_SET_TAG(eth_l4_misc, tag, seq_num, misc3, inner_tcp_seq_num);
+		DR_STE_SET_TAG(eth_l4_misc, tag, ack_num, misc3, inner_tcp_ack_num);
+	} else {
+		DR_STE_SET_TAG(eth_l4_misc, tag, seq_num, misc3, outer_tcp_seq_num);
+		DR_STE_SET_TAG(eth_l4_misc, tag, ack_num, misc3, outer_tcp_ack_num);
+	}
+
+	return 0;
+}
+
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
+static void
+dr_ste_v0_build_flex_parser_tnl_vxlan_gpe_bit_mask(struct mlx5dr_match_param *value,
+						   bool inner, u8 *bit_mask)
+{
+	struct mlx5dr_match_misc3 *misc_3_mask = &value->misc3;
+
+	DR_STE_SET_MASK_V(flex_parser_tnl_vxlan_gpe, bit_mask,
+			  outer_vxlan_gpe_flags,
+			  misc_3_mask, outer_vxlan_gpe_flags);
+	DR_STE_SET_MASK_V(flex_parser_tnl_vxlan_gpe, bit_mask,
+			  outer_vxlan_gpe_next_protocol,
+			  misc_3_mask, outer_vxlan_gpe_next_protocol);
+	DR_STE_SET_MASK_V(flex_parser_tnl_vxlan_gpe, bit_mask,
+			  outer_vxlan_gpe_vni,
+			  misc_3_mask, outer_vxlan_gpe_vni);
+}
+
+static int
+dr_ste_v0_build_flex_parser_tnl_vxlan_gpe_tag(struct mlx5dr_match_param *value,
+					      struct mlx5dr_ste_build *sb,
+					      u8 *tag)
+{
+	struct mlx5dr_match_misc3 *misc3 = &value->misc3;
+
+	DR_STE_SET_TAG(flex_parser_tnl_vxlan_gpe, tag,
+		       outer_vxlan_gpe_flags, misc3,
+		       outer_vxlan_gpe_flags);
+	DR_STE_SET_TAG(flex_parser_tnl_vxlan_gpe, tag,
+		       outer_vxlan_gpe_next_protocol, misc3,
+		       outer_vxlan_gpe_next_protocol);
+	DR_STE_SET_TAG(flex_parser_tnl_vxlan_gpe, tag,
+		       outer_vxlan_gpe_vni, misc3,
+		       outer_vxlan_gpe_vni);
+
+	return 0;
+}
+
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
+static void
+dr_ste_v0_build_flex_parser_tnl_geneve_bit_mask(struct mlx5dr_match_param *value,
+						u8 *bit_mask)
+{
+	struct mlx5dr_match_misc *misc_mask = &value->misc;
+
+	DR_STE_SET_MASK_V(flex_parser_tnl_geneve, bit_mask,
+			  geneve_protocol_type,
+			  misc_mask, geneve_protocol_type);
+	DR_STE_SET_MASK_V(flex_parser_tnl_geneve, bit_mask,
+			  geneve_oam,
+			  misc_mask, geneve_oam);
+	DR_STE_SET_MASK_V(flex_parser_tnl_geneve, bit_mask,
+			  geneve_opt_len,
+			  misc_mask, geneve_opt_len);
+	DR_STE_SET_MASK_V(flex_parser_tnl_geneve, bit_mask,
+			  geneve_vni,
+			  misc_mask, geneve_vni);
+}
+
+static int
+dr_ste_v0_build_flex_parser_tnl_geneve_tag(struct mlx5dr_match_param *value,
+					   struct mlx5dr_ste_build *sb,
+					   u8 *tag)
+{
+	struct mlx5dr_match_misc *misc = &value->misc;
+
+	DR_STE_SET_TAG(flex_parser_tnl_geneve, tag,
+		       geneve_protocol_type, misc, geneve_protocol_type);
+	DR_STE_SET_TAG(flex_parser_tnl_geneve, tag,
+		       geneve_oam, misc, geneve_oam);
+	DR_STE_SET_TAG(flex_parser_tnl_geneve, tag,
+		       geneve_opt_len, misc, geneve_opt_len);
+	DR_STE_SET_TAG(flex_parser_tnl_geneve, tag,
+		       geneve_vni, misc, geneve_vni);
+
+	return 0;
+}
+
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
+static void
+dr_ste_v0_build_register_0_bit_mask(struct mlx5dr_match_param *value,
+				    u8 *bit_mask)
+{
+	struct mlx5dr_match_misc2 *misc_2_mask = &value->misc2;
+
+	DR_STE_SET_MASK_V(register_0, bit_mask, register_0_h,
+			  misc_2_mask, metadata_reg_c_0);
+	DR_STE_SET_MASK_V(register_0, bit_mask, register_0_l,
+			  misc_2_mask, metadata_reg_c_1);
+	DR_STE_SET_MASK_V(register_0, bit_mask, register_1_h,
+			  misc_2_mask, metadata_reg_c_2);
+	DR_STE_SET_MASK_V(register_0, bit_mask, register_1_l,
+			  misc_2_mask, metadata_reg_c_3);
+}
+
+static int
+dr_ste_v0_build_register_0_tag(struct mlx5dr_match_param *value,
+			       struct mlx5dr_ste_build *sb,
+			       u8 *tag)
+{
+	struct mlx5dr_match_misc2 *misc2 = &value->misc2;
+
+	DR_STE_SET_TAG(register_0, tag, register_0_h, misc2, metadata_reg_c_0);
+	DR_STE_SET_TAG(register_0, tag, register_0_l, misc2, metadata_reg_c_1);
+	DR_STE_SET_TAG(register_0, tag, register_1_h, misc2, metadata_reg_c_2);
+	DR_STE_SET_TAG(register_0, tag, register_1_l, misc2, metadata_reg_c_3);
+
+	return 0;
+}
+
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
+static void
+dr_ste_v0_build_register_1_bit_mask(struct mlx5dr_match_param *value,
+				    u8 *bit_mask)
+{
+	struct mlx5dr_match_misc2 *misc_2_mask = &value->misc2;
+
+	DR_STE_SET_MASK_V(register_1, bit_mask, register_2_h,
+			  misc_2_mask, metadata_reg_c_4);
+	DR_STE_SET_MASK_V(register_1, bit_mask, register_2_l,
+			  misc_2_mask, metadata_reg_c_5);
+	DR_STE_SET_MASK_V(register_1, bit_mask, register_3_h,
+			  misc_2_mask, metadata_reg_c_6);
+	DR_STE_SET_MASK_V(register_1, bit_mask, register_3_l,
+			  misc_2_mask, metadata_reg_c_7);
+}
+
+static int
+dr_ste_v0_build_register_1_tag(struct mlx5dr_match_param *value,
+			       struct mlx5dr_ste_build *sb,
+			       u8 *tag)
+{
+	struct mlx5dr_match_misc2 *misc2 = &value->misc2;
+
+	DR_STE_SET_TAG(register_1, tag, register_2_h, misc2, metadata_reg_c_4);
+	DR_STE_SET_TAG(register_1, tag, register_2_l, misc2, metadata_reg_c_5);
+	DR_STE_SET_TAG(register_1, tag, register_3_h, misc2, metadata_reg_c_6);
+	DR_STE_SET_TAG(register_1, tag, register_3_l, misc2, metadata_reg_c_7);
+
+	return 0;
+}
+
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
+static void
+dr_ste_v0_build_src_gvmi_qpn_bit_mask(struct mlx5dr_match_param *value,
+				      u8 *bit_mask)
+{
+	struct mlx5dr_match_misc *misc_mask = &value->misc;
+
+	DR_STE_SET_MASK(src_gvmi_qp, bit_mask, source_gvmi, misc_mask, source_port);
+	DR_STE_SET_MASK(src_gvmi_qp, bit_mask, source_qp, misc_mask, source_sqn);
+	misc_mask->source_eswitch_owner_vhca_id = 0;
+}
+
+static int
+dr_ste_v0_build_src_gvmi_qpn_tag(struct mlx5dr_match_param *value,
+				 struct mlx5dr_ste_build *sb,
+				 u8 *tag)
+{
+	struct mlx5dr_match_misc *misc = &value->misc;
+	struct mlx5dr_cmd_vport_cap *vport_cap;
+	struct mlx5dr_domain *dmn = sb->dmn;
+	struct mlx5dr_cmd_caps *caps;
+	u8 *bit_mask = sb->bit_mask;
+	bool source_gvmi_set;
+
+	DR_STE_SET_TAG(src_gvmi_qp, tag, source_qp, misc, source_sqn);
+
+	if (sb->vhca_id_valid) {
+		/* Find port GVMI based on the eswitch_owner_vhca_id */
+		if (misc->source_eswitch_owner_vhca_id == dmn->info.caps.gvmi)
+			caps = &dmn->info.caps;
+		else if (dmn->peer_dmn && (misc->source_eswitch_owner_vhca_id ==
+					   dmn->peer_dmn->info.caps.gvmi))
+			caps = &dmn->peer_dmn->info.caps;
+		else
+			return -EINVAL;
+	} else {
+		caps = &dmn->info.caps;
+	}
+
+	vport_cap = mlx5dr_get_vport_cap(caps, misc->source_port);
+	if (!vport_cap) {
+		mlx5dr_err(dmn, "Vport 0x%x is invalid\n",
+			   misc->source_port);
+		return -EINVAL;
+	}
+
+	source_gvmi_set = MLX5_GET(ste_src_gvmi_qp, bit_mask, source_gvmi);
+	if (vport_cap->vport_gvmi && source_gvmi_set)
+		MLX5_SET(ste_src_gvmi_qp, tag, source_gvmi, vport_cap->vport_gvmi);
+
+	misc->source_eswitch_owner_vhca_id = 0;
+	misc->source_port = 0;
+
+	return 0;
+}
+
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
+struct mlx5dr_ste_ctx ste_ctx_v0 = {
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
-- 
2.26.2

