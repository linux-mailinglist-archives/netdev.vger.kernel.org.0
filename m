Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7476E3091D7
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 05:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233751AbhA3E2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 23:28:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:36492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233575AbhA3DyN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 22:54:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15CEC64E0B;
        Sat, 30 Jan 2021 02:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611973589;
        bh=8bYVUc01QFPyjvtM8VSlcUzhHsRjctMIabDOhquIMw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NIqyV/3eD5qZAjTuUJIDPG4kR1lAS0vrmI+42Hg4EpuuT18pPV3bRGZaeAQWUCYdz
         RQxFMAHkY2/jn39QkG1uQPwvy6F0ZKlEepiiRnjzSxtzZ3+DQ/5bQqU0Ozp9aQNpSA
         zj52QnttIs5p895QjHitIOosXGESqvBXHLyxOHzLFoDy3DPv89SIpzQ3UZwxLLFnLI
         wYqzFGXk4Et7zS7dqHvuGral+XHfq8KkXOIeQfRasZ9eswEkZSbnQnDGtSiU9ilD5y
         KsRRF8kVBV/Pclqeajudpzu20Z0KEB2ytTDK2pWxJjwptM77xyMaHmg8BgowjOIsmy
         Pkwlz9kAtoEDw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/11] net/mlx5: DR, Add HW STEv1 match logic
Date:   Fri, 29 Jan 2021 18:26:10 -0800
Message-Id: <20210130022618.317351-4-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210130022618.317351-1-saeed@kernel.org>
References: <20210130022618.317351-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Add STEv1 match logic to a new file.
This file will be used for HW specific STEv1.

Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../mellanox/mlx5/core/steering/dr_ste.c      |   2 +-
 .../mellanox/mlx5/core/steering/dr_ste.h      |   1 +
 .../mellanox/mlx5/core/steering/dr_ste_v1.c   | 908 ++++++++++++++++++
 4 files changed, 911 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index f61ee7110243..8809dd4de57e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -85,7 +85,7 @@ mlx5_core-$(CONFIG_MLX5_SW_STEERING) += steering/dr_domain.o steering/dr_table.o
 					steering/dr_matcher.o steering/dr_rule.o \
 					steering/dr_icm_pool.o steering/dr_buddy.o \
 					steering/dr_ste.o steering/dr_send.o \
-					steering/dr_ste_v0.o \
+					steering/dr_ste_v0.o steering/dr_ste_v1.o \
 					steering/dr_cmd.o steering/dr_fw.o \
 					steering/dr_action.o steering/fs_dr.o
 #
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 1614481fdf8d..0f318f409c91 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -1127,7 +1127,7 @@ void mlx5dr_ste_build_src_gvmi_qpn(struct mlx5dr_ste_ctx *ste_ctx,
 
 static struct mlx5dr_ste_ctx *mlx5dr_ste_ctx_arr[] = {
 	[MLX5_STEERING_FORMAT_CONNECTX_5] = &ste_ctx_v0,
-	[MLX5_STEERING_FORMAT_CONNECTX_6DX] = NULL,
+	[MLX5_STEERING_FORMAT_CONNECTX_6DX] = &ste_ctx_v1,
 };
 
 struct mlx5dr_ste_ctx *mlx5dr_ste_get_ctx(u8 version)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
index 4a3d6a849991..0dc08fe1a9db 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
@@ -163,5 +163,6 @@ struct mlx5dr_ste_ctx {
 };
 
 extern struct mlx5dr_ste_ctx ste_ctx_v0;
+extern struct mlx5dr_ste_ctx ste_ctx_v1;
 
 #endif  /* _DR_STE_ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
new file mode 100644
index 000000000000..bf3cb189f3bc
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -0,0 +1,908 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2020 NVIDIA CORPORATION. All rights reserved. */
+
+#include <linux/types.h>
+#include "mlx5_ifc_dr_ste_v1.h"
+#include "dr_ste.h"
+
+#define DR_STE_CALC_DFNR_TYPE(lookup_type, inner) \
+	((inner) ? DR_STE_V1_LU_TYPE_##lookup_type##_I : \
+		   DR_STE_V1_LU_TYPE_##lookup_type##_O)
+
+enum dr_ste_v1_entry_format {
+	DR_STE_V1_TYPE_BWC_BYTE	= 0x0,
+	DR_STE_V1_TYPE_BWC_DW	= 0x1,
+	DR_STE_V1_TYPE_MATCH	= 0x2,
+};
+
+/* Lookup type is built from 2B: [ Definer mode 1B ][ Definer index 1B ] */
+enum {
+	DR_STE_V1_LU_TYPE_NOP				= 0x0000,
+	DR_STE_V1_LU_TYPE_ETHL2_TNL			= 0x0002,
+	DR_STE_V1_LU_TYPE_IBL3_EXT			= 0x0102,
+	DR_STE_V1_LU_TYPE_ETHL2_O			= 0x0003,
+	DR_STE_V1_LU_TYPE_IBL4				= 0x0103,
+	DR_STE_V1_LU_TYPE_ETHL2_I			= 0x0004,
+	DR_STE_V1_LU_TYPE_SRC_QP_GVMI			= 0x0104,
+	DR_STE_V1_LU_TYPE_ETHL2_SRC_O			= 0x0005,
+	DR_STE_V1_LU_TYPE_ETHL2_HEADERS_O		= 0x0105,
+	DR_STE_V1_LU_TYPE_ETHL2_SRC_I			= 0x0006,
+	DR_STE_V1_LU_TYPE_ETHL2_HEADERS_I		= 0x0106,
+	DR_STE_V1_LU_TYPE_ETHL3_IPV4_5_TUPLE_O		= 0x0007,
+	DR_STE_V1_LU_TYPE_IPV6_DES_O			= 0x0107,
+	DR_STE_V1_LU_TYPE_ETHL3_IPV4_5_TUPLE_I		= 0x0008,
+	DR_STE_V1_LU_TYPE_IPV6_DES_I			= 0x0108,
+	DR_STE_V1_LU_TYPE_ETHL4_O			= 0x0009,
+	DR_STE_V1_LU_TYPE_IPV6_SRC_O			= 0x0109,
+	DR_STE_V1_LU_TYPE_ETHL4_I			= 0x000a,
+	DR_STE_V1_LU_TYPE_IPV6_SRC_I			= 0x010a,
+	DR_STE_V1_LU_TYPE_ETHL2_SRC_DST_O		= 0x000b,
+	DR_STE_V1_LU_TYPE_MPLS_O			= 0x010b,
+	DR_STE_V1_LU_TYPE_ETHL2_SRC_DST_I		= 0x000c,
+	DR_STE_V1_LU_TYPE_MPLS_I			= 0x010c,
+	DR_STE_V1_LU_TYPE_ETHL3_IPV4_MISC_O		= 0x000d,
+	DR_STE_V1_LU_TYPE_GRE				= 0x010d,
+	DR_STE_V1_LU_TYPE_FLEX_PARSER_TNL_HEADER	= 0x000e,
+	DR_STE_V1_LU_TYPE_GENERAL_PURPOSE		= 0x010e,
+	DR_STE_V1_LU_TYPE_ETHL3_IPV4_MISC_I		= 0x000f,
+	DR_STE_V1_LU_TYPE_STEERING_REGISTERS_0		= 0x010f,
+	DR_STE_V1_LU_TYPE_STEERING_REGISTERS_1		= 0x0110,
+	DR_STE_V1_LU_TYPE_FLEX_PARSER_0			= 0x0111,
+	DR_STE_V1_LU_TYPE_FLEX_PARSER_1			= 0x0112,
+	DR_STE_V1_LU_TYPE_ETHL4_MISC_O			= 0x0113,
+	DR_STE_V1_LU_TYPE_ETHL4_MISC_I			= 0x0114,
+	DR_STE_V1_LU_TYPE_INVALID			= 0x00ff,
+	DR_STE_V1_LU_TYPE_DONT_CARE			= MLX5DR_STE_LU_TYPE_DONT_CARE,
+};
+
+static void dr_ste_v1_build_eth_l2_src_dst_bit_mask(struct mlx5dr_match_param *value,
+						    bool inner, u8 *bit_mask)
+{
+	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
+
+	DR_STE_SET_TAG(eth_l2_src_dst_v1, bit_mask, dmac_47_16, mask, dmac_47_16);
+	DR_STE_SET_TAG(eth_l2_src_dst_v1, bit_mask, dmac_15_0, mask, dmac_15_0);
+
+	DR_STE_SET_TAG(eth_l2_src_dst_v1, bit_mask, smac_47_16, mask, smac_47_16);
+	DR_STE_SET_TAG(eth_l2_src_dst_v1, bit_mask, smac_15_0, mask, smac_15_0);
+
+	DR_STE_SET_TAG(eth_l2_src_dst_v1, bit_mask, first_vlan_id, mask, first_vid);
+	DR_STE_SET_TAG(eth_l2_src_dst_v1, bit_mask, first_cfi, mask, first_cfi);
+	DR_STE_SET_TAG(eth_l2_src_dst_v1, bit_mask, first_priority, mask, first_prio);
+	DR_STE_SET_ONES(eth_l2_src_dst_v1, bit_mask, l3_type, mask, ip_version);
+
+	if (mask->cvlan_tag) {
+		MLX5_SET(ste_eth_l2_src_dst_v1, bit_mask, first_vlan_qualifier, -1);
+		mask->cvlan_tag = 0;
+	} else if (mask->svlan_tag) {
+		MLX5_SET(ste_eth_l2_src_dst_v1, bit_mask, first_vlan_qualifier, -1);
+		mask->svlan_tag = 0;
+	}
+}
+
+static int dr_ste_v1_build_eth_l2_src_dst_tag(struct mlx5dr_match_param *value,
+					      struct mlx5dr_ste_build *sb,
+					      u8 *tag)
+{
+	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
+
+	DR_STE_SET_TAG(eth_l2_src_dst_v1, tag, dmac_47_16, spec, dmac_47_16);
+	DR_STE_SET_TAG(eth_l2_src_dst_v1, tag, dmac_15_0, spec, dmac_15_0);
+
+	DR_STE_SET_TAG(eth_l2_src_dst_v1, tag, smac_47_16, spec, smac_47_16);
+	DR_STE_SET_TAG(eth_l2_src_dst_v1, tag, smac_15_0, spec, smac_15_0);
+
+	if (spec->ip_version == IP_VERSION_IPV4) {
+		MLX5_SET(ste_eth_l2_src_dst_v1, tag, l3_type, STE_IPV4);
+		spec->ip_version = 0;
+	} else if (spec->ip_version == IP_VERSION_IPV6) {
+		MLX5_SET(ste_eth_l2_src_dst_v1, tag, l3_type, STE_IPV6);
+		spec->ip_version = 0;
+	} else if (spec->ip_version) {
+		return -EINVAL;
+	}
+
+	DR_STE_SET_TAG(eth_l2_src_dst_v1, tag, first_vlan_id, spec, first_vid);
+	DR_STE_SET_TAG(eth_l2_src_dst_v1, tag, first_cfi, spec, first_cfi);
+	DR_STE_SET_TAG(eth_l2_src_dst_v1, tag, first_priority, spec, first_prio);
+
+	if (spec->cvlan_tag) {
+		MLX5_SET(ste_eth_l2_src_dst_v1, tag, first_vlan_qualifier, DR_STE_CVLAN);
+		spec->cvlan_tag = 0;
+	} else if (spec->svlan_tag) {
+		MLX5_SET(ste_eth_l2_src_dst_v1, tag, first_vlan_qualifier, DR_STE_SVLAN);
+		spec->svlan_tag = 0;
+	}
+	return 0;
+}
+
+static void dr_ste_v1_build_eth_l2_src_dst_init(struct mlx5dr_ste_build *sb,
+						struct mlx5dr_match_param *mask)
+{
+	dr_ste_v1_build_eth_l2_src_dst_bit_mask(mask, sb->inner, sb->bit_mask);
+
+	sb->lu_type = DR_STE_CALC_DFNR_TYPE(ETHL2_SRC_DST, sb->inner);
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v1_build_eth_l2_src_dst_tag;
+}
+
+static int dr_ste_v1_build_eth_l3_ipv6_dst_tag(struct mlx5dr_match_param *value,
+					       struct mlx5dr_ste_build *sb,
+					       u8 *tag)
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
+static void dr_ste_v1_build_eth_l3_ipv6_dst_init(struct mlx5dr_ste_build *sb,
+						 struct mlx5dr_match_param *mask)
+{
+	dr_ste_v1_build_eth_l3_ipv6_dst_tag(mask, sb, sb->bit_mask);
+
+	sb->lu_type = DR_STE_CALC_DFNR_TYPE(IPV6_DES, sb->inner);
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v1_build_eth_l3_ipv6_dst_tag;
+}
+
+static int dr_ste_v1_build_eth_l3_ipv6_src_tag(struct mlx5dr_match_param *value,
+					       struct mlx5dr_ste_build *sb,
+					       u8 *tag)
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
+static void dr_ste_v1_build_eth_l3_ipv6_src_init(struct mlx5dr_ste_build *sb,
+						 struct mlx5dr_match_param *mask)
+{
+	dr_ste_v1_build_eth_l3_ipv6_src_tag(mask, sb, sb->bit_mask);
+
+	sb->lu_type = DR_STE_CALC_DFNR_TYPE(IPV6_SRC, sb->inner);
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v1_build_eth_l3_ipv6_src_tag;
+}
+
+static int dr_ste_v1_build_eth_l3_ipv4_5_tuple_tag(struct mlx5dr_match_param *value,
+						   struct mlx5dr_ste_build *sb,
+						   u8 *tag)
+{
+	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
+
+	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple_v1, tag, destination_address, spec, dst_ip_31_0);
+	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple_v1, tag, source_address, spec, src_ip_31_0);
+	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple_v1, tag, destination_port, spec, tcp_dport);
+	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple_v1, tag, destination_port, spec, udp_dport);
+	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple_v1, tag, source_port, spec, tcp_sport);
+	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple_v1, tag, source_port, spec, udp_sport);
+	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple_v1, tag, protocol, spec, ip_protocol);
+	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple_v1, tag, fragmented, spec, frag);
+	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple_v1, tag, dscp, spec, ip_dscp);
+	DR_STE_SET_TAG(eth_l3_ipv4_5_tuple_v1, tag, ecn, spec, ip_ecn);
+
+	if (spec->tcp_flags) {
+		DR_STE_SET_TCP_FLAGS(eth_l3_ipv4_5_tuple_v1, tag, spec);
+		spec->tcp_flags = 0;
+	}
+
+	return 0;
+}
+
+static void dr_ste_v1_build_eth_l3_ipv4_5_tuple_init(struct mlx5dr_ste_build *sb,
+						     struct mlx5dr_match_param *mask)
+{
+	dr_ste_v1_build_eth_l3_ipv4_5_tuple_tag(mask, sb, sb->bit_mask);
+
+	sb->lu_type = DR_STE_CALC_DFNR_TYPE(ETHL3_IPV4_5_TUPLE, sb->inner);
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v1_build_eth_l3_ipv4_5_tuple_tag;
+}
+
+static void dr_ste_v1_build_eth_l2_src_or_dst_bit_mask(struct mlx5dr_match_param *value,
+						       bool inner, u8 *bit_mask)
+{
+	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
+	struct mlx5dr_match_misc *misc_mask = &value->misc;
+
+	DR_STE_SET_TAG(eth_l2_src_v1, bit_mask, first_vlan_id, mask, first_vid);
+	DR_STE_SET_TAG(eth_l2_src_v1, bit_mask, first_cfi, mask, first_cfi);
+	DR_STE_SET_TAG(eth_l2_src_v1, bit_mask, first_priority, mask, first_prio);
+	DR_STE_SET_TAG(eth_l2_src_v1, bit_mask, ip_fragmented, mask, frag); // ?
+	DR_STE_SET_TAG(eth_l2_src_v1, bit_mask, l3_ethertype, mask, ethertype); // ?
+	DR_STE_SET_ONES(eth_l2_src_v1, bit_mask, l3_type, mask, ip_version);
+
+	if (mask->svlan_tag || mask->cvlan_tag) {
+		MLX5_SET(ste_eth_l2_src_v1, bit_mask, first_vlan_qualifier, -1);
+		mask->cvlan_tag = 0;
+		mask->svlan_tag = 0;
+	}
+
+	if (inner) {
+		if (misc_mask->inner_second_cvlan_tag ||
+		    misc_mask->inner_second_svlan_tag) {
+			MLX5_SET(ste_eth_l2_src_v1, bit_mask, second_vlan_qualifier, -1);
+			misc_mask->inner_second_cvlan_tag = 0;
+			misc_mask->inner_second_svlan_tag = 0;
+		}
+
+		DR_STE_SET_TAG(eth_l2_src_v1, bit_mask,
+			       second_vlan_id, misc_mask, inner_second_vid);
+		DR_STE_SET_TAG(eth_l2_src_v1, bit_mask,
+			       second_cfi, misc_mask, inner_second_cfi);
+		DR_STE_SET_TAG(eth_l2_src_v1, bit_mask,
+			       second_priority, misc_mask, inner_second_prio);
+	} else {
+		if (misc_mask->outer_second_cvlan_tag ||
+		    misc_mask->outer_second_svlan_tag) {
+			MLX5_SET(ste_eth_l2_src_v1, bit_mask, second_vlan_qualifier, -1);
+			misc_mask->outer_second_cvlan_tag = 0;
+			misc_mask->outer_second_svlan_tag = 0;
+		}
+
+		DR_STE_SET_TAG(eth_l2_src_v1, bit_mask,
+			       second_vlan_id, misc_mask, outer_second_vid);
+		DR_STE_SET_TAG(eth_l2_src_v1, bit_mask,
+			       second_cfi, misc_mask, outer_second_cfi);
+		DR_STE_SET_TAG(eth_l2_src_v1, bit_mask,
+			       second_priority, misc_mask, outer_second_prio);
+	}
+}
+
+static int dr_ste_v1_build_eth_l2_src_or_dst_tag(struct mlx5dr_match_param *value,
+						 bool inner, u8 *tag)
+{
+	struct mlx5dr_match_spec *spec = inner ? &value->inner : &value->outer;
+	struct mlx5dr_match_misc *misc_spec = &value->misc;
+
+	DR_STE_SET_TAG(eth_l2_src_v1, tag, first_vlan_id, spec, first_vid);
+	DR_STE_SET_TAG(eth_l2_src_v1, tag, first_cfi, spec, first_cfi);
+	DR_STE_SET_TAG(eth_l2_src_v1, tag, first_priority, spec, first_prio);
+	DR_STE_SET_TAG(eth_l2_src_v1, tag, ip_fragmented, spec, frag);
+	DR_STE_SET_TAG(eth_l2_src_v1, tag, l3_ethertype, spec, ethertype);
+
+	if (spec->ip_version == IP_VERSION_IPV4) {
+		MLX5_SET(ste_eth_l2_src_v1, tag, l3_type, STE_IPV4);
+		spec->ip_version = 0;
+	} else if (spec->ip_version == IP_VERSION_IPV6) {
+		MLX5_SET(ste_eth_l2_src_v1, tag, l3_type, STE_IPV6);
+		spec->ip_version = 0;
+	} else if (spec->ip_version) {
+		return -EINVAL;
+	}
+
+	if (spec->cvlan_tag) {
+		MLX5_SET(ste_eth_l2_src_v1, tag, first_vlan_qualifier, DR_STE_CVLAN);
+		spec->cvlan_tag = 0;
+	} else if (spec->svlan_tag) {
+		MLX5_SET(ste_eth_l2_src_v1, tag, first_vlan_qualifier, DR_STE_SVLAN);
+		spec->svlan_tag = 0;
+	}
+
+	if (inner) {
+		if (misc_spec->inner_second_cvlan_tag) {
+			MLX5_SET(ste_eth_l2_src_v1, tag, second_vlan_qualifier, DR_STE_CVLAN);
+			misc_spec->inner_second_cvlan_tag = 0;
+		} else if (misc_spec->inner_second_svlan_tag) {
+			MLX5_SET(ste_eth_l2_src_v1, tag, second_vlan_qualifier, DR_STE_SVLAN);
+			misc_spec->inner_second_svlan_tag = 0;
+		}
+
+		DR_STE_SET_TAG(eth_l2_src_v1, tag, second_vlan_id, misc_spec, inner_second_vid);
+		DR_STE_SET_TAG(eth_l2_src_v1, tag, second_cfi, misc_spec, inner_second_cfi);
+		DR_STE_SET_TAG(eth_l2_src_v1, tag, second_priority, misc_spec, inner_second_prio);
+	} else {
+		if (misc_spec->outer_second_cvlan_tag) {
+			MLX5_SET(ste_eth_l2_src_v1, tag, second_vlan_qualifier, DR_STE_CVLAN);
+			misc_spec->outer_second_cvlan_tag = 0;
+		} else if (misc_spec->outer_second_svlan_tag) {
+			MLX5_SET(ste_eth_l2_src_v1, tag, second_vlan_qualifier, DR_STE_SVLAN);
+			misc_spec->outer_second_svlan_tag = 0;
+		}
+		DR_STE_SET_TAG(eth_l2_src_v1, tag, second_vlan_id, misc_spec, outer_second_vid);
+		DR_STE_SET_TAG(eth_l2_src_v1, tag, second_cfi, misc_spec, outer_second_cfi);
+		DR_STE_SET_TAG(eth_l2_src_v1, tag, second_priority, misc_spec, outer_second_prio);
+	}
+
+	return 0;
+}
+
+static void dr_ste_v1_build_eth_l2_src_bit_mask(struct mlx5dr_match_param *value,
+						bool inner, u8 *bit_mask)
+{
+	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
+
+	DR_STE_SET_TAG(eth_l2_src_v1, bit_mask, smac_47_16, mask, smac_47_16);
+	DR_STE_SET_TAG(eth_l2_src_v1, bit_mask, smac_15_0, mask, smac_15_0);
+
+	dr_ste_v1_build_eth_l2_src_or_dst_bit_mask(value, inner, bit_mask);
+}
+
+static int dr_ste_v1_build_eth_l2_src_tag(struct mlx5dr_match_param *value,
+					  struct mlx5dr_ste_build *sb,
+					  u8 *tag)
+{
+	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
+
+	DR_STE_SET_TAG(eth_l2_src_v1, tag, smac_47_16, spec, smac_47_16);
+	DR_STE_SET_TAG(eth_l2_src_v1, tag, smac_15_0, spec, smac_15_0);
+
+	return dr_ste_v1_build_eth_l2_src_or_dst_tag(value, sb->inner, tag);
+}
+
+static void dr_ste_v1_build_eth_l2_src_init(struct mlx5dr_ste_build *sb,
+					    struct mlx5dr_match_param *mask)
+{
+	dr_ste_v1_build_eth_l2_src_bit_mask(mask, sb->inner, sb->bit_mask);
+
+	sb->lu_type = DR_STE_CALC_DFNR_TYPE(ETHL2_SRC, sb->inner);
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v1_build_eth_l2_src_tag;
+}
+
+static void dr_ste_v1_build_eth_l2_dst_bit_mask(struct mlx5dr_match_param *value,
+						bool inner, u8 *bit_mask)
+{
+	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
+
+	DR_STE_SET_TAG(eth_l2_dst_v1, bit_mask, dmac_47_16, mask, dmac_47_16);
+	DR_STE_SET_TAG(eth_l2_dst_v1, bit_mask, dmac_15_0, mask, dmac_15_0);
+
+	dr_ste_v1_build_eth_l2_src_or_dst_bit_mask(value, inner, bit_mask);
+}
+
+static int dr_ste_v1_build_eth_l2_dst_tag(struct mlx5dr_match_param *value,
+					  struct mlx5dr_ste_build *sb,
+					  u8 *tag)
+{
+	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
+
+	DR_STE_SET_TAG(eth_l2_dst_v1, tag, dmac_47_16, spec, dmac_47_16);
+	DR_STE_SET_TAG(eth_l2_dst_v1, tag, dmac_15_0, spec, dmac_15_0);
+
+	return dr_ste_v1_build_eth_l2_src_or_dst_tag(value, sb->inner, tag);
+}
+
+static void dr_ste_v1_build_eth_l2_dst_init(struct mlx5dr_ste_build *sb,
+					    struct mlx5dr_match_param *mask)
+{
+	dr_ste_v1_build_eth_l2_dst_bit_mask(mask, sb->inner, sb->bit_mask);
+
+	sb->lu_type = DR_STE_CALC_DFNR_TYPE(ETHL2, sb->inner);
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v1_build_eth_l2_dst_tag;
+}
+
+static void dr_ste_v1_build_eth_l2_tnl_bit_mask(struct mlx5dr_match_param *value,
+						bool inner, u8 *bit_mask)
+{
+	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
+	struct mlx5dr_match_misc *misc = &value->misc;
+
+	DR_STE_SET_TAG(eth_l2_tnl_v1, bit_mask, dmac_47_16, mask, dmac_47_16);
+	DR_STE_SET_TAG(eth_l2_tnl_v1, bit_mask, dmac_15_0, mask, dmac_15_0);
+	DR_STE_SET_TAG(eth_l2_tnl_v1, bit_mask, first_vlan_id, mask, first_vid);
+	DR_STE_SET_TAG(eth_l2_tnl_v1, bit_mask, first_cfi, mask, first_cfi);
+	DR_STE_SET_TAG(eth_l2_tnl_v1, bit_mask, first_priority, mask, first_prio);
+	DR_STE_SET_TAG(eth_l2_tnl_v1, bit_mask, ip_fragmented, mask, frag);
+	DR_STE_SET_TAG(eth_l2_tnl_v1, bit_mask, l3_ethertype, mask, ethertype);
+	DR_STE_SET_ONES(eth_l2_tnl_v1, bit_mask, l3_type, mask, ip_version);
+
+	if (misc->vxlan_vni) {
+		MLX5_SET(ste_eth_l2_tnl_v1, bit_mask,
+			 l2_tunneling_network_id, (misc->vxlan_vni << 8));
+		misc->vxlan_vni = 0;
+	}
+
+	if (mask->svlan_tag || mask->cvlan_tag) {
+		MLX5_SET(ste_eth_l2_tnl_v1, bit_mask, first_vlan_qualifier, -1);
+		mask->cvlan_tag = 0;
+		mask->svlan_tag = 0;
+	}
+}
+
+static int dr_ste_v1_build_eth_l2_tnl_tag(struct mlx5dr_match_param *value,
+					  struct mlx5dr_ste_build *sb,
+					  u8 *tag)
+{
+	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
+	struct mlx5dr_match_misc *misc = &value->misc;
+
+	DR_STE_SET_TAG(eth_l2_tnl_v1, tag, dmac_47_16, spec, dmac_47_16);
+	DR_STE_SET_TAG(eth_l2_tnl_v1, tag, dmac_15_0, spec, dmac_15_0);
+	DR_STE_SET_TAG(eth_l2_tnl_v1, tag, first_vlan_id, spec, first_vid);
+	DR_STE_SET_TAG(eth_l2_tnl_v1, tag, first_cfi, spec, first_cfi);
+	DR_STE_SET_TAG(eth_l2_tnl_v1, tag, ip_fragmented, spec, frag);
+	DR_STE_SET_TAG(eth_l2_tnl_v1, tag, first_priority, spec, first_prio);
+	DR_STE_SET_TAG(eth_l2_tnl_v1, tag, l3_ethertype, spec, ethertype);
+
+	if (misc->vxlan_vni) {
+		MLX5_SET(ste_eth_l2_tnl_v1, tag, l2_tunneling_network_id,
+			 (misc->vxlan_vni << 8));
+		misc->vxlan_vni = 0;
+	}
+
+	if (spec->cvlan_tag) {
+		MLX5_SET(ste_eth_l2_tnl_v1, tag, first_vlan_qualifier, DR_STE_CVLAN);
+		spec->cvlan_tag = 0;
+	} else if (spec->svlan_tag) {
+		MLX5_SET(ste_eth_l2_tnl_v1, tag, first_vlan_qualifier, DR_STE_SVLAN);
+		spec->svlan_tag = 0;
+	}
+
+	if (spec->ip_version == IP_VERSION_IPV4) {
+		MLX5_SET(ste_eth_l2_tnl_v1, tag, l3_type, STE_IPV4);
+		spec->ip_version = 0;
+	} else if (spec->ip_version == IP_VERSION_IPV6) {
+		MLX5_SET(ste_eth_l2_tnl_v1, tag, l3_type, STE_IPV6);
+		spec->ip_version = 0;
+	} else if (spec->ip_version) {
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void dr_ste_v1_build_eth_l2_tnl_init(struct mlx5dr_ste_build *sb,
+					    struct mlx5dr_match_param *mask)
+{
+	dr_ste_v1_build_eth_l2_tnl_bit_mask(mask, sb->inner, sb->bit_mask);
+
+	sb->lu_type = DR_STE_V1_LU_TYPE_ETHL2_TNL;
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v1_build_eth_l2_tnl_tag;
+}
+
+static int dr_ste_v1_build_eth_l3_ipv4_misc_tag(struct mlx5dr_match_param *value,
+						struct mlx5dr_ste_build *sb,
+						u8 *tag)
+{
+	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
+
+	DR_STE_SET_TAG(eth_l3_ipv4_misc_v1, tag, time_to_live, spec, ttl_hoplimit);
+
+	return 0;
+}
+
+static void dr_ste_v1_build_eth_l3_ipv4_misc_init(struct mlx5dr_ste_build *sb,
+						  struct mlx5dr_match_param *mask)
+{
+	dr_ste_v1_build_eth_l3_ipv4_misc_tag(mask, sb, sb->bit_mask);
+
+	sb->lu_type = DR_STE_CALC_DFNR_TYPE(ETHL3_IPV4_MISC, sb->inner);
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v1_build_eth_l3_ipv4_misc_tag;
+}
+
+static int dr_ste_v1_build_eth_ipv6_l3_l4_tag(struct mlx5dr_match_param *value,
+					      struct mlx5dr_ste_build *sb,
+					      u8 *tag)
+{
+	struct mlx5dr_match_spec *spec = sb->inner ? &value->inner : &value->outer;
+	struct mlx5dr_match_misc *misc = &value->misc;
+
+	DR_STE_SET_TAG(eth_l4_v1, tag, dst_port, spec, tcp_dport);
+	DR_STE_SET_TAG(eth_l4_v1, tag, src_port, spec, tcp_sport);
+	DR_STE_SET_TAG(eth_l4_v1, tag, dst_port, spec, udp_dport);
+	DR_STE_SET_TAG(eth_l4_v1, tag, src_port, spec, udp_sport);
+	DR_STE_SET_TAG(eth_l4_v1, tag, protocol, spec, ip_protocol);
+	DR_STE_SET_TAG(eth_l4_v1, tag, fragmented, spec, frag);
+	DR_STE_SET_TAG(eth_l4_v1, tag, dscp, spec, ip_dscp);
+	DR_STE_SET_TAG(eth_l4_v1, tag, ecn, spec, ip_ecn);
+	DR_STE_SET_TAG(eth_l4_v1, tag, ipv6_hop_limit, spec, ttl_hoplimit);
+
+	if (sb->inner)
+		DR_STE_SET_TAG(eth_l4_v1, tag, flow_label, misc, inner_ipv6_flow_label);
+	else
+		DR_STE_SET_TAG(eth_l4_v1, tag, flow_label, misc, outer_ipv6_flow_label);
+
+	if (spec->tcp_flags) {
+		DR_STE_SET_TCP_FLAGS(eth_l4_v1, tag, spec);
+		spec->tcp_flags = 0;
+	}
+
+	return 0;
+}
+
+static void dr_ste_v1_build_eth_ipv6_l3_l4_init(struct mlx5dr_ste_build *sb,
+						struct mlx5dr_match_param *mask)
+{
+	dr_ste_v1_build_eth_ipv6_l3_l4_tag(mask, sb, sb->bit_mask);
+
+	sb->lu_type = DR_STE_CALC_DFNR_TYPE(ETHL4, sb->inner);
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v1_build_eth_ipv6_l3_l4_tag;
+}
+
+static int dr_ste_v1_build_mpls_tag(struct mlx5dr_match_param *value,
+				    struct mlx5dr_ste_build *sb,
+				    u8 *tag)
+{
+	struct mlx5dr_match_misc2 *misc2 = &value->misc2;
+
+	if (sb->inner)
+		DR_STE_SET_MPLS(mpls_v1, misc2, inner, tag);
+	else
+		DR_STE_SET_MPLS(mpls_v1, misc2, outer, tag);
+
+	return 0;
+}
+
+static void dr_ste_v1_build_mpls_init(struct mlx5dr_ste_build *sb,
+				      struct mlx5dr_match_param *mask)
+{
+	dr_ste_v1_build_mpls_tag(mask, sb, sb->bit_mask);
+
+	sb->lu_type = DR_STE_CALC_DFNR_TYPE(MPLS, sb->inner);
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v1_build_mpls_tag;
+}
+
+static int dr_ste_v1_build_tnl_gre_tag(struct mlx5dr_match_param *value,
+				       struct mlx5dr_ste_build *sb,
+				       u8 *tag)
+{
+	struct  mlx5dr_match_misc *misc = &value->misc;
+
+	DR_STE_SET_TAG(gre_v1, tag, gre_protocol, misc, gre_protocol);
+	DR_STE_SET_TAG(gre_v1, tag, gre_k_present, misc, gre_k_present);
+	DR_STE_SET_TAG(gre_v1, tag, gre_key_h, misc, gre_key_h);
+	DR_STE_SET_TAG(gre_v1, tag, gre_key_l, misc, gre_key_l);
+
+	DR_STE_SET_TAG(gre_v1, tag, gre_c_present, misc, gre_c_present);
+	DR_STE_SET_TAG(gre_v1, tag, gre_s_present, misc, gre_s_present);
+
+	return 0;
+}
+
+static void dr_ste_v1_build_tnl_gre_init(struct mlx5dr_ste_build *sb,
+					 struct mlx5dr_match_param *mask)
+{
+	dr_ste_v1_build_tnl_gre_tag(mask, sb, sb->bit_mask);
+
+	sb->lu_type = DR_STE_V1_LU_TYPE_GRE;
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v1_build_tnl_gre_tag;
+}
+
+static int dr_ste_v1_build_tnl_mpls_tag(struct mlx5dr_match_param *value,
+					struct mlx5dr_ste_build *sb,
+					u8 *tag)
+{
+	struct mlx5dr_match_misc2 *misc2 = &value->misc2;
+
+	if (DR_STE_IS_OUTER_MPLS_OVER_GRE_SET(misc2)) {
+		DR_STE_SET_TAG(mpls_v1, tag, mpls0_label,
+			       misc2, outer_first_mpls_over_gre_label);
+
+		DR_STE_SET_TAG(mpls_v1, tag, mpls0_exp,
+			       misc2, outer_first_mpls_over_gre_exp);
+
+		DR_STE_SET_TAG(mpls_v1, tag, mpls0_s_bos,
+			       misc2, outer_first_mpls_over_gre_s_bos);
+
+		DR_STE_SET_TAG(mpls_v1, tag, mpls0_ttl,
+			       misc2, outer_first_mpls_over_gre_ttl);
+	} else {
+		DR_STE_SET_TAG(mpls_v1, tag, mpls0_label,
+			       misc2, outer_first_mpls_over_udp_label);
+
+		DR_STE_SET_TAG(mpls_v1, tag, mpls0_exp,
+			       misc2, outer_first_mpls_over_udp_exp);
+
+		DR_STE_SET_TAG(mpls_v1, tag, mpls0_s_bos,
+			       misc2, outer_first_mpls_over_udp_s_bos);
+
+		DR_STE_SET_TAG(mpls_v1, tag, mpls0_ttl,
+			       misc2, outer_first_mpls_over_udp_ttl);
+	}
+
+	return 0;
+}
+
+static void dr_ste_v1_build_tnl_mpls_init(struct mlx5dr_ste_build *sb,
+					  struct mlx5dr_match_param *mask)
+{
+	dr_ste_v1_build_tnl_mpls_tag(mask, sb, sb->bit_mask);
+
+	sb->lu_type = DR_STE_V1_LU_TYPE_MPLS_I;
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v1_build_tnl_mpls_tag;
+}
+
+static int dr_ste_v1_build_icmp_tag(struct mlx5dr_match_param *value,
+				    struct mlx5dr_ste_build *sb,
+				    u8 *tag)
+{
+	struct mlx5dr_match_misc3 *misc3 = &value->misc3;
+	bool is_ipv4 = DR_MASK_IS_ICMPV4_SET(misc3);
+	u32 *icmp_header_data;
+	u8 *icmp_type;
+	u8 *icmp_code;
+
+	if (is_ipv4) {
+		icmp_header_data	= &misc3->icmpv4_header_data;
+		icmp_type		= &misc3->icmpv4_type;
+		icmp_code		= &misc3->icmpv4_code;
+	} else {
+		icmp_header_data	= &misc3->icmpv6_header_data;
+		icmp_type		= &misc3->icmpv6_type;
+		icmp_code		= &misc3->icmpv6_code;
+	}
+
+	MLX5_SET(ste_icmp_v1, tag, icmp_header_data, *icmp_header_data);
+	MLX5_SET(ste_icmp_v1, tag, icmp_type, *icmp_type);
+	MLX5_SET(ste_icmp_v1, tag, icmp_code, *icmp_code);
+
+	*icmp_header_data = 0;
+	*icmp_type = 0;
+	*icmp_code = 0;
+
+	return 0;
+}
+
+static int dr_ste_v1_build_icmp_init(struct mlx5dr_ste_build *sb,
+				     struct mlx5dr_match_param *mask)
+{
+	dr_ste_v1_build_icmp_tag(mask, sb, sb->bit_mask);
+
+	sb->lu_type = DR_STE_V1_LU_TYPE_ETHL4_MISC_O;
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v1_build_icmp_tag;
+
+	return 0;
+}
+
+static int dr_ste_v1_build_general_purpose_tag(struct mlx5dr_match_param *value,
+					       struct mlx5dr_ste_build *sb,
+					       u8 *tag)
+{
+	struct mlx5dr_match_misc2 *misc2 = &value->misc2;
+
+	DR_STE_SET_TAG(general_purpose, tag, general_purpose_lookup_field,
+		       misc2, metadata_reg_a);
+
+	return 0;
+}
+
+static void dr_ste_v1_build_general_purpose_init(struct mlx5dr_ste_build *sb,
+						 struct mlx5dr_match_param *mask)
+{
+	dr_ste_v1_build_general_purpose_tag(mask, sb, sb->bit_mask);
+
+	sb->lu_type = DR_STE_V1_LU_TYPE_GENERAL_PURPOSE;
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v1_build_general_purpose_tag;
+}
+
+static int dr_ste_v1_build_eth_l4_misc_tag(struct mlx5dr_match_param *value,
+					   struct mlx5dr_ste_build *sb,
+					   u8 *tag)
+{
+	struct mlx5dr_match_misc3 *misc3 = &value->misc3;
+
+	if (sb->inner) {
+		DR_STE_SET_TAG(eth_l4_misc_v1, tag, seq_num, misc3, inner_tcp_seq_num);
+		DR_STE_SET_TAG(eth_l4_misc_v1, tag, ack_num, misc3, inner_tcp_ack_num);
+	} else {
+		DR_STE_SET_TAG(eth_l4_misc_v1, tag, seq_num, misc3, outer_tcp_seq_num);
+		DR_STE_SET_TAG(eth_l4_misc_v1, tag, ack_num, misc3, outer_tcp_ack_num);
+	}
+
+	return 0;
+}
+
+static void dr_ste_v1_build_eth_l4_misc_init(struct mlx5dr_ste_build *sb,
+					     struct mlx5dr_match_param *mask)
+{
+	dr_ste_v1_build_eth_l4_misc_tag(mask, sb, sb->bit_mask);
+
+	sb->lu_type = DR_STE_V1_LU_TYPE_ETHL4_MISC_O;
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v1_build_eth_l4_misc_tag;
+}
+
+static int
+dr_ste_v1_build_flex_parser_tnl_vxlan_gpe_tag(struct mlx5dr_match_param *value,
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
+dr_ste_v1_build_flex_parser_tnl_vxlan_gpe_init(struct mlx5dr_ste_build *sb,
+					       struct mlx5dr_match_param *mask)
+{
+	dr_ste_v1_build_flex_parser_tnl_vxlan_gpe_tag(mask, sb, sb->bit_mask);
+
+	sb->lu_type = DR_STE_V1_LU_TYPE_FLEX_PARSER_TNL_HEADER;
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v1_build_flex_parser_tnl_vxlan_gpe_tag;
+}
+
+static int
+dr_ste_v1_build_flex_parser_tnl_geneve_tag(struct mlx5dr_match_param *value,
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
+dr_ste_v1_build_flex_parser_tnl_geneve_init(struct mlx5dr_ste_build *sb,
+					    struct mlx5dr_match_param *mask)
+{
+	dr_ste_v1_build_flex_parser_tnl_geneve_tag(mask, sb, sb->bit_mask);
+
+	sb->lu_type = DR_STE_V1_LU_TYPE_FLEX_PARSER_TNL_HEADER;
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v1_build_flex_parser_tnl_geneve_tag;
+}
+
+static int dr_ste_v1_build_register_0_tag(struct mlx5dr_match_param *value,
+					  struct mlx5dr_ste_build *sb,
+					  u8 *tag)
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
+static void dr_ste_v1_build_register_0_init(struct mlx5dr_ste_build *sb,
+					    struct mlx5dr_match_param *mask)
+{
+	dr_ste_v1_build_register_0_tag(mask, sb, sb->bit_mask);
+
+	sb->lu_type = DR_STE_V1_LU_TYPE_STEERING_REGISTERS_0;
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v1_build_register_0_tag;
+}
+
+static int dr_ste_v1_build_register_1_tag(struct mlx5dr_match_param *value,
+					  struct mlx5dr_ste_build *sb,
+					  u8 *tag)
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
+static void dr_ste_v1_build_register_1_init(struct mlx5dr_ste_build *sb,
+					    struct mlx5dr_match_param *mask)
+{
+	dr_ste_v1_build_register_1_tag(mask, sb, sb->bit_mask);
+
+	sb->lu_type = DR_STE_V1_LU_TYPE_STEERING_REGISTERS_1;
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v1_build_register_1_tag;
+}
+
+static void dr_ste_v1_build_src_gvmi_qpn_bit_mask(struct mlx5dr_match_param *value,
+						  u8 *bit_mask)
+{
+	struct mlx5dr_match_misc *misc_mask = &value->misc;
+
+	DR_STE_SET_ONES(src_gvmi_qp_v1, bit_mask, source_gvmi, misc_mask, source_port);
+	DR_STE_SET_ONES(src_gvmi_qp_v1, bit_mask, source_qp, misc_mask, source_sqn);
+}
+
+static int dr_ste_v1_build_src_gvmi_qpn_tag(struct mlx5dr_match_param *value,
+					    struct mlx5dr_ste_build *sb,
+					    u8 *tag)
+{
+	struct mlx5dr_match_misc *misc = &value->misc;
+	struct mlx5dr_cmd_vport_cap *vport_cap;
+	struct mlx5dr_domain *dmn = sb->dmn;
+	struct mlx5dr_cmd_caps *caps;
+	u8 *bit_mask = sb->bit_mask;
+
+	DR_STE_SET_TAG(src_gvmi_qp_v1, tag, source_qp, misc, source_sqn);
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
+
+		 misc->source_eswitch_owner_vhca_id = 0;
+	} else {
+		caps = &dmn->info.caps;
+	}
+
+	if (!MLX5_GET(ste_src_gvmi_qp_v1, bit_mask, source_gvmi))
+		return 0;
+
+	vport_cap = mlx5dr_get_vport_cap(caps, misc->source_port);
+	if (!vport_cap) {
+		mlx5dr_err(dmn, "Vport 0x%x is disabled or invalid\n",
+			   misc->source_port);
+		return -EINVAL;
+	}
+
+	if (vport_cap->vport_gvmi)
+		MLX5_SET(ste_src_gvmi_qp_v1, tag, source_gvmi, vport_cap->vport_gvmi);
+
+	misc->source_port = 0;
+	return 0;
+}
+
+static void dr_ste_v1_build_src_gvmi_qpn_init(struct mlx5dr_ste_build *sb,
+					      struct mlx5dr_match_param *mask)
+{
+	dr_ste_v1_build_src_gvmi_qpn_bit_mask(mask, sb->bit_mask);
+
+	sb->lu_type = DR_STE_V1_LU_TYPE_SRC_QP_GVMI;
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v1_build_src_gvmi_qpn_tag;
+}
+
+struct mlx5dr_ste_ctx ste_ctx_v1 = {
+	.build_eth_l2_src_dst_init	= &dr_ste_v1_build_eth_l2_src_dst_init,
+	.build_eth_l3_ipv6_src_init	= &dr_ste_v1_build_eth_l3_ipv6_src_init,
+	.build_eth_l3_ipv6_dst_init	= &dr_ste_v1_build_eth_l3_ipv6_dst_init,
+	.build_eth_l3_ipv4_5_tuple_init	= &dr_ste_v1_build_eth_l3_ipv4_5_tuple_init,
+	.build_eth_l2_src_init		= &dr_ste_v1_build_eth_l2_src_init,
+	.build_eth_l2_dst_init		= &dr_ste_v1_build_eth_l2_dst_init,
+	.build_eth_l2_tnl_init		= &dr_ste_v1_build_eth_l2_tnl_init,
+	.build_eth_l3_ipv4_misc_init	= &dr_ste_v1_build_eth_l3_ipv4_misc_init,
+	.build_eth_ipv6_l3_l4_init	= &dr_ste_v1_build_eth_ipv6_l3_l4_init,
+	.build_mpls_init		= &dr_ste_v1_build_mpls_init,
+	.build_tnl_gre_init		= &dr_ste_v1_build_tnl_gre_init,
+	.build_tnl_mpls_init		= &dr_ste_v1_build_tnl_mpls_init,
+	.build_icmp_init		= &dr_ste_v1_build_icmp_init,
+	.build_general_purpose_init	= &dr_ste_v1_build_general_purpose_init,
+	.build_eth_l4_misc_init		= &dr_ste_v1_build_eth_l4_misc_init,
+	.build_tnl_vxlan_gpe_init	= &dr_ste_v1_build_flex_parser_tnl_vxlan_gpe_init,
+	.build_tnl_geneve_init		= &dr_ste_v1_build_flex_parser_tnl_geneve_init,
+	.build_register_0_init		= &dr_ste_v1_build_register_0_init,
+	.build_register_1_init		= &dr_ste_v1_build_register_1_init,
+	.build_src_gvmi_qpn_init	= &dr_ste_v1_build_src_gvmi_qpn_init,
+};
-- 
2.29.2

