Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9E52EB5D2
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 00:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbhAEXGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 18:06:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:57434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727426AbhAEXG1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 18:06:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 699AC23100;
        Tue,  5 Jan 2021 23:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609887911;
        bh=DDbqKCcDNXBTPBNF0T7RDewRn82L1pgNmIY3XPlV/uo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rm9OaZt9L2S5gJq60ZG9P/H2bwAY2m7hP4jPUuOKSTEzI/TdkZ3sTLdBV6T09jGga
         vn723TCQxTRcn7fsQChZVeazC58+/63VWPeWdsRj4cVDrF2K29JBcMeX+5JwnMcCPj
         y9ClD3GJuR5SrA0Ak77TyOtMiTiDljYr6iWsifn6b1Jwbp+e7xhSSsEudidmWI69Hl
         K8U8svfAKds7xc34p/37njWDUu+qKH7sDM8JW0ZNSdOP2aQUMFtHbv8IJHcxSQXVyd
         RRQdZGyFwVQrPI4zT5mkFdECF79aTdp4kUoEh8rVTIECS067JV9K7S0/4HoyqZIrwe
         ACWMgvWQ9ys7Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/16] net/mlx5: DR, Merge similar DR STE SET macros
Date:   Tue,  5 Jan 2021 15:03:24 -0800
Message-Id: <20210105230333.239456-8-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210105230333.239456-1-saeed@kernel.org>
References: <20210105230333.239456-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Merge DR_STE_STE macros for better code reuse, the macro
DR_STE_SET_MASK_V and DR_STE_SET_TAG are merged to avoid
tag and bit_mask function creation which are usually the
same.

Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_ste.h      |  35 +-
 .../mellanox/mlx5/core/steering/dr_ste_v0.c   | 464 +++---------------
 2 files changed, 84 insertions(+), 415 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
index dd5317b72a73..0773dad59f93 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
@@ -24,17 +24,13 @@
 	} \
 } while (0)
 
-/* Set to STE spec->s_fname to tag->t_fname */
+/* Set to STE spec->s_fname to tag->t_fname set spec->s_fname as used */
 #define DR_STE_SET_TAG(lookup_type, tag, t_fname, spec, s_fname) \
 	DR_STE_SET_VAL(lookup_type, tag, t_fname, spec, s_fname, spec->s_fname)
 
-/* Set to STE -1 to bit_mask->bm_fname and set spec->s_fname as used */
-#define DR_STE_SET_MASK(lookup_type, bit_mask, bm_fname, spec, s_fname) \
-	DR_STE_SET_VAL(lookup_type, bit_mask, bm_fname, spec, s_fname, -1)
-
-/* Set to STE spec->s_fname to bit_mask->bm_fname and set spec->s_fname as used */
-#define DR_STE_SET_MASK_V(lookup_type, bit_mask, bm_fname, spec, s_fname) \
-	DR_STE_SET_VAL(lookup_type, bit_mask, bm_fname, spec, s_fname, (spec)->s_fname)
+/* Set to STE -1 to tag->t_fname and set spec->s_fname as used */
+#define DR_STE_SET_ONES(lookup_type, tag, t_fname, spec, s_fname) \
+	DR_STE_SET_VAL(lookup_type, tag, t_fname, spec, s_fname, -1)
 
 #define DR_STE_SET_TCP_FLAGS(lookup_type, tag, spec) do { \
 	MLX5_SET(ste_##lookup_type, tag, tcp_ns, !!((spec)->tcp_flags & (1 << 8))); \
@@ -48,25 +44,16 @@
 	MLX5_SET(ste_##lookup_type, tag, tcp_fin, !!((spec)->tcp_flags & (1 << 0))); \
 } while (0)
 
-#define DR_STE_SET_MPLS_MASK(lookup_type, mask, in_out, bit_mask) do { \
-	DR_STE_SET_MASK_V(lookup_type, bit_mask, mpls0_label, mask, \
-			  in_out##_first_mpls_label);\
-	DR_STE_SET_MASK_V(lookup_type, bit_mask, mpls0_s_bos, mask, \
-			  in_out##_first_mpls_s_bos); \
-	DR_STE_SET_MASK_V(lookup_type, bit_mask, mpls0_exp, mask, \
-			  in_out##_first_mpls_exp); \
-	DR_STE_SET_MASK_V(lookup_type, bit_mask, mpls0_ttl, mask, \
-			  in_out##_first_mpls_ttl); \
-} while (0)
-
-#define DR_STE_SET_MPLS_TAG(lookup_type, mask, in_out, tag) do { \
-	DR_STE_SET_TAG(lookup_type, tag, mpls0_label, mask, \
+#define DR_STE_SET_MPLS(lookup_type, mask, in_out, tag) do { \
+	struct mlx5dr_match_misc2 *_mask = mask; \
+	u8 *_tag = tag; \
+	DR_STE_SET_TAG(lookup_type, _tag, mpls0_label, _mask, \
 		       in_out##_first_mpls_label);\
-	DR_STE_SET_TAG(lookup_type, tag, mpls0_s_bos, mask, \
+	DR_STE_SET_TAG(lookup_type, _tag, mpls0_s_bos, _mask, \
 		       in_out##_first_mpls_s_bos); \
-	DR_STE_SET_TAG(lookup_type, tag, mpls0_exp, mask, \
+	DR_STE_SET_TAG(lookup_type, _tag, mpls0_exp, _mask, \
 		       in_out##_first_mpls_exp); \
-	DR_STE_SET_TAG(lookup_type, tag, mpls0_ttl, mask, \
+	DR_STE_SET_TAG(lookup_type, _tag, mpls0_ttl, _mask, \
 		       in_out##_first_mpls_ttl); \
 } while (0)
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
index 3ce3197aaf90..b4406c633e32 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
@@ -16,8 +16,8 @@ dr_ste_v0_build_eth_l2_src_dst_bit_mask(struct mlx5dr_match_param *value,
 {
 	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
 
-	DR_STE_SET_MASK_V(eth_l2_src_dst, bit_mask, dmac_47_16, mask, dmac_47_16);
-	DR_STE_SET_MASK_V(eth_l2_src_dst, bit_mask, dmac_15_0, mask, dmac_15_0);
+	DR_STE_SET_TAG(eth_l2_src_dst, bit_mask, dmac_47_16, mask, dmac_47_16);
+	DR_STE_SET_TAG(eth_l2_src_dst, bit_mask, dmac_15_0, mask, dmac_15_0);
 
 	if (mask->smac_47_16 || mask->smac_15_0) {
 		MLX5_SET(ste_eth_l2_src_dst, bit_mask, smac_47_32,
@@ -28,10 +28,10 @@ dr_ste_v0_build_eth_l2_src_dst_bit_mask(struct mlx5dr_match_param *value,
 		mask->smac_15_0 = 0;
 	}
 
-	DR_STE_SET_MASK_V(eth_l2_src_dst, bit_mask, first_vlan_id, mask, first_vid);
-	DR_STE_SET_MASK_V(eth_l2_src_dst, bit_mask, first_cfi, mask, first_cfi);
-	DR_STE_SET_MASK_V(eth_l2_src_dst, bit_mask, first_priority, mask, first_prio);
-	DR_STE_SET_MASK(eth_l2_src_dst, bit_mask, l3_type, mask, ip_version);
+	DR_STE_SET_TAG(eth_l2_src_dst, bit_mask, first_vlan_id, mask, first_vid);
+	DR_STE_SET_TAG(eth_l2_src_dst, bit_mask, first_cfi, mask, first_cfi);
+	DR_STE_SET_TAG(eth_l2_src_dst, bit_mask, first_priority, mask, first_prio);
+	DR_STE_SET_ONES(eth_l2_src_dst, bit_mask, l3_type, mask, ip_version);
 
 	if (mask->cvlan_tag) {
 		MLX5_SET(ste_eth_l2_src_dst, bit_mask, first_vlan_qualifier, -1);
@@ -98,18 +98,6 @@ dr_ste_v0_build_eth_l2_src_dst_init(struct mlx5dr_ste_build *sb,
 	sb->ste_build_tag_func = &dr_ste_v0_build_eth_l2_src_dst_tag;
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
 static int
 dr_ste_v0_build_eth_l3_ipv6_dst_tag(struct mlx5dr_match_param *value,
 				    struct mlx5dr_ste_build *sb,
@@ -129,25 +117,13 @@ static void
 dr_ste_v0_build_eth_l3_ipv6_dst_init(struct mlx5dr_ste_build *sb,
 				     struct mlx5dr_match_param *mask)
 {
-	dr_ste_v0_build_eth_l3_ipv6_dst_bit_mask(mask, sb->inner, sb->bit_mask);
+	dr_ste_v0_build_eth_l3_ipv6_dst_tag(mask, sb, sb->bit_mask);
 
 	sb->lu_type = DR_STE_CALC_LU_TYPE(ETHL3_IPV6_DST, sb->rx, sb->inner);
 	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
 	sb->ste_build_tag_func = &dr_ste_v0_build_eth_l3_ipv6_dst_tag;
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
 static int
 dr_ste_v0_build_eth_l3_ipv6_src_tag(struct mlx5dr_match_param *value,
 				    struct mlx5dr_ste_build *sb,
@@ -167,47 +143,13 @@ static void
 dr_ste_v0_build_eth_l3_ipv6_src_init(struct mlx5dr_ste_build *sb,
 				     struct mlx5dr_match_param *mask)
 {
-	dr_ste_v0_build_eth_l3_ipv6_src_bit_mask(mask, sb->inner, sb->bit_mask);
+	dr_ste_v0_build_eth_l3_ipv6_src_tag(mask, sb, sb->bit_mask);
 
 	sb->lu_type = DR_STE_CALC_LU_TYPE(ETHL3_IPV6_SRC, sb->rx, sb->inner);
 	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
 	sb->ste_build_tag_func = &dr_ste_v0_build_eth_l3_ipv6_src_tag;
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
 static int
 dr_ste_v0_build_eth_l3_ipv4_5_tuple_tag(struct mlx5dr_match_param *value,
 					struct mlx5dr_ste_build *sb,
@@ -238,7 +180,7 @@ static void
 dr_ste_v0_build_eth_l3_ipv4_5_tuple_init(struct mlx5dr_ste_build *sb,
 					 struct mlx5dr_match_param *mask)
 {
-	dr_ste_v0_build_eth_l3_ipv4_5_tuple_bit_mask(mask, sb->inner, sb->bit_mask);
+	dr_ste_v0_build_eth_l3_ipv4_5_tuple_tag(mask, sb, sb->bit_mask);
 
 	sb->lu_type = DR_STE_CALC_LU_TYPE(ETHL3_IPV4_5_TUPLE, sb->rx, sb->inner);
 	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
@@ -252,12 +194,12 @@ dr_ste_v0_build_eth_l2_src_or_dst_bit_mask(struct mlx5dr_match_param *value,
 	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
 	struct mlx5dr_match_misc *misc_mask = &value->misc;
 
-	DR_STE_SET_MASK_V(eth_l2_src, bit_mask, first_vlan_id, mask, first_vid);
-	DR_STE_SET_MASK_V(eth_l2_src, bit_mask, first_cfi, mask, first_cfi);
-	DR_STE_SET_MASK_V(eth_l2_src, bit_mask, first_priority, mask, first_prio);
-	DR_STE_SET_MASK_V(eth_l2_src, bit_mask, ip_fragmented, mask, frag);
-	DR_STE_SET_MASK_V(eth_l2_src, bit_mask, l3_ethertype, mask, ethertype);
-	DR_STE_SET_MASK(eth_l2_src, bit_mask, l3_type, mask, ip_version);
+	DR_STE_SET_TAG(eth_l2_src, bit_mask, first_vlan_id, mask, first_vid);
+	DR_STE_SET_TAG(eth_l2_src, bit_mask, first_cfi, mask, first_cfi);
+	DR_STE_SET_TAG(eth_l2_src, bit_mask, first_priority, mask, first_prio);
+	DR_STE_SET_TAG(eth_l2_src, bit_mask, ip_fragmented, mask, frag);
+	DR_STE_SET_TAG(eth_l2_src, bit_mask, l3_ethertype, mask, ethertype);
+	DR_STE_SET_ONES(eth_l2_src, bit_mask, l3_type, mask, ip_version);
 
 	if (mask->svlan_tag || mask->cvlan_tag) {
 		MLX5_SET(ste_eth_l2_src, bit_mask, first_vlan_qualifier, -1);
@@ -273,12 +215,12 @@ dr_ste_v0_build_eth_l2_src_or_dst_bit_mask(struct mlx5dr_match_param *value,
 			misc_mask->inner_second_svlan_tag = 0;
 		}
 
-		DR_STE_SET_MASK_V(eth_l2_src, bit_mask,
-				  second_vlan_id, misc_mask, inner_second_vid);
-		DR_STE_SET_MASK_V(eth_l2_src, bit_mask,
-				  second_cfi, misc_mask, inner_second_cfi);
-		DR_STE_SET_MASK_V(eth_l2_src, bit_mask,
-				  second_priority, misc_mask, inner_second_prio);
+		DR_STE_SET_TAG(eth_l2_src, bit_mask,
+			       second_vlan_id, misc_mask, inner_second_vid);
+		DR_STE_SET_TAG(eth_l2_src, bit_mask,
+			       second_cfi, misc_mask, inner_second_cfi);
+		DR_STE_SET_TAG(eth_l2_src, bit_mask,
+			       second_priority, misc_mask, inner_second_prio);
 	} else {
 		if (misc_mask->outer_second_cvlan_tag ||
 		    misc_mask->outer_second_svlan_tag) {
@@ -287,12 +229,12 @@ dr_ste_v0_build_eth_l2_src_or_dst_bit_mask(struct mlx5dr_match_param *value,
 			misc_mask->outer_second_svlan_tag = 0;
 		}
 
-		DR_STE_SET_MASK_V(eth_l2_src, bit_mask,
-				  second_vlan_id, misc_mask, outer_second_vid);
-		DR_STE_SET_MASK_V(eth_l2_src, bit_mask,
-				  second_cfi, misc_mask, outer_second_cfi);
-		DR_STE_SET_MASK_V(eth_l2_src, bit_mask,
-				  second_priority, misc_mask, outer_second_prio);
+		DR_STE_SET_TAG(eth_l2_src, bit_mask,
+			       second_vlan_id, misc_mask, outer_second_vid);
+		DR_STE_SET_TAG(eth_l2_src, bit_mask,
+			       second_cfi, misc_mask, outer_second_cfi);
+		DR_STE_SET_TAG(eth_l2_src, bit_mask,
+			       second_priority, misc_mask, outer_second_prio);
 	}
 }
 
@@ -363,8 +305,8 @@ dr_ste_v0_build_eth_l2_src_bit_mask(struct mlx5dr_match_param *value,
 {
 	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
 
-	DR_STE_SET_MASK_V(eth_l2_src, bit_mask, smac_47_16, mask, smac_47_16);
-	DR_STE_SET_MASK_V(eth_l2_src, bit_mask, smac_15_0, mask, smac_15_0);
+	DR_STE_SET_TAG(eth_l2_src, bit_mask, smac_47_16, mask, smac_47_16);
+	DR_STE_SET_TAG(eth_l2_src, bit_mask, smac_15_0, mask, smac_15_0);
 
 	dr_ste_v0_build_eth_l2_src_or_dst_bit_mask(value, inner, bit_mask);
 }
@@ -394,14 +336,15 @@ dr_ste_v0_build_eth_l2_src_init(struct mlx5dr_ste_build *sb,
 
 static void
 dr_ste_v0_build_eth_l2_dst_bit_mask(struct mlx5dr_match_param *value,
-				    bool inner, u8 *bit_mask)
+				    struct mlx5dr_ste_build *sb,
+				    u8 *bit_mask)
 {
-	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
+	struct mlx5dr_match_spec *mask = sb->inner ? &value->inner : &value->outer;
 
-	DR_STE_SET_MASK_V(eth_l2_dst, bit_mask, dmac_47_16, mask, dmac_47_16);
-	DR_STE_SET_MASK_V(eth_l2_dst, bit_mask, dmac_15_0, mask, dmac_15_0);
+	DR_STE_SET_TAG(eth_l2_dst, bit_mask, dmac_47_16, mask, dmac_47_16);
+	DR_STE_SET_TAG(eth_l2_dst, bit_mask, dmac_15_0, mask, dmac_15_0);
 
-	dr_ste_v0_build_eth_l2_src_or_dst_bit_mask(value, inner, bit_mask);
+	dr_ste_v0_build_eth_l2_src_or_dst_bit_mask(value, sb->inner, bit_mask);
 }
 
 static int
@@ -421,7 +364,7 @@ static void
 dr_ste_v0_build_eth_l2_dst_init(struct mlx5dr_ste_build *sb,
 				struct mlx5dr_match_param *mask)
 {
-	dr_ste_v0_build_eth_l2_dst_bit_mask(mask, sb->inner, sb->bit_mask);
+	dr_ste_v0_build_eth_l2_dst_bit_mask(mask, sb, sb->bit_mask);
 
 	sb->lu_type = DR_STE_CALC_LU_TYPE(ETHL2_DST, sb->rx, sb->inner);
 	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
@@ -435,14 +378,14 @@ dr_ste_v0_build_eth_l2_tnl_bit_mask(struct mlx5dr_match_param *value,
 	struct mlx5dr_match_spec *mask = inner ? &value->inner : &value->outer;
 	struct mlx5dr_match_misc *misc = &value->misc;
 
-	DR_STE_SET_MASK_V(eth_l2_tnl, bit_mask, dmac_47_16, mask, dmac_47_16);
-	DR_STE_SET_MASK_V(eth_l2_tnl, bit_mask, dmac_15_0, mask, dmac_15_0);
-	DR_STE_SET_MASK_V(eth_l2_tnl, bit_mask, first_vlan_id, mask, first_vid);
-	DR_STE_SET_MASK_V(eth_l2_tnl, bit_mask, first_cfi, mask, first_cfi);
-	DR_STE_SET_MASK_V(eth_l2_tnl, bit_mask, first_priority, mask, first_prio);
-	DR_STE_SET_MASK_V(eth_l2_tnl, bit_mask, ip_fragmented, mask, frag);
-	DR_STE_SET_MASK_V(eth_l2_tnl, bit_mask, l3_ethertype, mask, ethertype);
-	DR_STE_SET_MASK(eth_l2_tnl, bit_mask, l3_type, mask, ip_version);
+	DR_STE_SET_TAG(eth_l2_tnl, bit_mask, dmac_47_16, mask, dmac_47_16);
+	DR_STE_SET_TAG(eth_l2_tnl, bit_mask, dmac_15_0, mask, dmac_15_0);
+	DR_STE_SET_TAG(eth_l2_tnl, bit_mask, first_vlan_id, mask, first_vid);
+	DR_STE_SET_TAG(eth_l2_tnl, bit_mask, first_cfi, mask, first_cfi);
+	DR_STE_SET_TAG(eth_l2_tnl, bit_mask, first_priority, mask, first_prio);
+	DR_STE_SET_TAG(eth_l2_tnl, bit_mask, ip_fragmented, mask, frag);
+	DR_STE_SET_TAG(eth_l2_tnl, bit_mask, l3_ethertype, mask, ethertype);
+	DR_STE_SET_ONES(eth_l2_tnl, bit_mask, l3_type, mask, ip_version);
 
 	if (misc->vxlan_vni) {
 		MLX5_SET(ste_eth_l2_tnl, bit_mask,
@@ -513,15 +456,6 @@ dr_ste_v0_build_eth_l2_tnl_init(struct mlx5dr_ste_build *sb,
 	sb->ste_build_tag_func = &dr_ste_v0_build_eth_l2_tnl_tag;
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
 static int
 dr_ste_v0_build_eth_l3_ipv4_misc_tag(struct mlx5dr_match_param *value,
 				     struct mlx5dr_ste_build *sb,
@@ -538,35 +472,13 @@ static void
 dr_ste_v0_build_eth_l3_ipv4_misc_init(struct mlx5dr_ste_build *sb,
 				      struct mlx5dr_match_param *mask)
 {
-	dr_ste_v0_build_eth_l3_ipv4_misc_bit_mask(mask, sb->inner, sb->bit_mask);
+	dr_ste_v0_build_eth_l3_ipv4_misc_tag(mask, sb, sb->bit_mask);
 
 	sb->lu_type = DR_STE_CALC_LU_TYPE(ETHL3_IPV4_MISC, sb->rx, sb->inner);
 	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
 	sb->ste_build_tag_func = &dr_ste_v0_build_eth_l3_ipv4_misc_tag;
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
 static int
 dr_ste_v0_build_eth_ipv6_l3_l4_tag(struct mlx5dr_match_param *value,
 				   struct mlx5dr_ste_build *sb,
@@ -596,36 +508,24 @@ static void
 dr_ste_v0_build_eth_ipv6_l3_l4_init(struct mlx5dr_ste_build *sb,
 				    struct mlx5dr_match_param *mask)
 {
-	dr_ste_v0_build_eth_ipv6_l3_l4_bit_mask(mask, sb->inner, sb->bit_mask);
+	dr_ste_v0_build_eth_ipv6_l3_l4_tag(mask, sb, sb->bit_mask);
 
 	sb->lu_type = DR_STE_CALC_LU_TYPE(ETHL4, sb->rx, sb->inner);
 	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
 	sb->ste_build_tag_func = &dr_ste_v0_build_eth_ipv6_l3_l4_tag;
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
 static int
 dr_ste_v0_build_mpls_tag(struct mlx5dr_match_param *value,
 			 struct mlx5dr_ste_build *sb,
 			 u8 *tag)
 {
-	struct mlx5dr_match_misc2 *misc2_mask = &value->misc2;
+	struct mlx5dr_match_misc2 *misc2 = &value->misc2;
 
 	if (sb->inner)
-		DR_STE_SET_MPLS_TAG(mpls, misc2_mask, inner, tag);
+		DR_STE_SET_MPLS(mpls, misc2, inner, tag);
 	else
-		DR_STE_SET_MPLS_TAG(mpls, misc2_mask, outer, tag);
+		DR_STE_SET_MPLS(mpls, misc2, outer, tag);
 
 	return 0;
 }
@@ -634,28 +534,13 @@ static void
 dr_ste_v0_build_mpls_init(struct mlx5dr_ste_build *sb,
 			  struct mlx5dr_match_param *mask)
 {
-	dr_ste_v0_build_mpls_bit_mask(mask, sb->inner, sb->bit_mask);
+	dr_ste_v0_build_mpls_tag(mask, sb, sb->bit_mask);
 
 	sb->lu_type = DR_STE_CALC_LU_TYPE(MPLS_FIRST, sb->rx, sb->inner);
 	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
 	sb->ste_build_tag_func = &dr_ste_v0_build_mpls_tag;
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
 static int
 dr_ste_v0_build_tnl_gre_tag(struct mlx5dr_match_param *value,
 			    struct mlx5dr_ste_build *sb,
@@ -680,77 +565,44 @@ static void
 dr_ste_v0_build_tnl_gre_init(struct mlx5dr_ste_build *sb,
 			     struct mlx5dr_match_param *mask)
 {
-	dr_ste_v0_build_tnl_gre_bit_mask(mask, sb->inner, sb->bit_mask);
+	dr_ste_v0_build_tnl_gre_tag(mask, sb, sb->bit_mask);
 
 	sb->lu_type = MLX5DR_STE_LU_TYPE_GRE;
 	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
 	sb->ste_build_tag_func = &dr_ste_v0_build_tnl_gre_tag;
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
 static int
 dr_ste_v0_build_tnl_mpls_tag(struct mlx5dr_match_param *value,
 			     struct mlx5dr_ste_build *sb,
 			     u8 *tag)
 {
-	struct mlx5dr_match_misc2 *misc_2_mask = &value->misc2;
+	struct mlx5dr_match_misc2 *misc_2 = &value->misc2;
 
-	if (DR_STE_IS_OUTER_MPLS_OVER_GRE_SET(misc_2_mask)) {
+	if (DR_STE_IS_OUTER_MPLS_OVER_GRE_SET(misc_2)) {
 		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_label,
-			       misc_2_mask, outer_first_mpls_over_gre_label);
+			       misc_2, outer_first_mpls_over_gre_label);
 
 		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_exp,
-			       misc_2_mask, outer_first_mpls_over_gre_exp);
+			       misc_2, outer_first_mpls_over_gre_exp);
 
 		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_s_bos,
-			       misc_2_mask, outer_first_mpls_over_gre_s_bos);
+			       misc_2, outer_first_mpls_over_gre_s_bos);
 
 		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_ttl,
-			       misc_2_mask, outer_first_mpls_over_gre_ttl);
+			       misc_2, outer_first_mpls_over_gre_ttl);
 	} else {
 		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_label,
-			       misc_2_mask, outer_first_mpls_over_udp_label);
+			       misc_2, outer_first_mpls_over_udp_label);
 
 		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_exp,
-			       misc_2_mask, outer_first_mpls_over_udp_exp);
+			       misc_2, outer_first_mpls_over_udp_exp);
 
 		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_s_bos,
-			       misc_2_mask, outer_first_mpls_over_udp_s_bos);
+			       misc_2, outer_first_mpls_over_udp_s_bos);
 
 		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_ttl,
-			       misc_2_mask, outer_first_mpls_over_udp_ttl);
+			       misc_2, outer_first_mpls_over_udp_ttl);
 	}
 	return 0;
 }
@@ -759,7 +611,7 @@ static void
 dr_ste_v0_build_tnl_mpls_init(struct mlx5dr_ste_build *sb,
 			      struct mlx5dr_match_param *mask)
 {
-	dr_ste_v0_build_tnl_mpls_bit_mask(mask, sb->inner, sb->bit_mask);
+	dr_ste_v0_build_tnl_mpls_tag(mask, sb, sb->bit_mask);
 
 	sb->lu_type = MLX5DR_STE_LU_TYPE_FLEX_PARSER_0;
 	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
@@ -770,76 +622,6 @@ dr_ste_v0_build_tnl_mpls_init(struct mlx5dr_ste_build *sb,
 #define ICMP_CODE_OFFSET_FIRST_DW		16
 #define ICMP_HEADER_DATA_OFFSET_SECOND_DW	0
 
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
 static int
 dr_ste_v0_build_icmp_tag(struct mlx5dr_match_param *value,
 			 struct mlx5dr_ste_build *sb,
@@ -918,7 +700,7 @@ dr_ste_v0_build_icmp_init(struct mlx5dr_ste_build *sb,
 {
 	int ret;
 
-	ret = dr_ste_v0_build_icmp_bit_mask(mask, sb->caps, sb->bit_mask);
+	ret = dr_ste_v0_build_icmp_tag(mask, sb, sb->bit_mask);
 	if (ret)
 		return ret;
 
@@ -929,26 +711,15 @@ dr_ste_v0_build_icmp_init(struct mlx5dr_ste_build *sb,
 	return 0;
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
 static int
 dr_ste_v0_build_general_purpose_tag(struct mlx5dr_match_param *value,
 				    struct mlx5dr_ste_build *sb,
 				    u8 *tag)
 {
-	struct mlx5dr_match_misc2 *misc_2_mask = &value->misc2;
+	struct mlx5dr_match_misc2 *misc_2 = &value->misc2;
 
 	DR_STE_SET_TAG(general_purpose, tag, general_purpose_lookup_field,
-		       misc_2_mask, metadata_reg_a);
+		       misc_2, metadata_reg_a);
 
 	return 0;
 }
@@ -957,32 +728,13 @@ static void
 dr_ste_v0_build_general_purpose_init(struct mlx5dr_ste_build *sb,
 				     struct mlx5dr_match_param *mask)
 {
-	dr_ste_v0_build_general_purpose_bit_mask(mask, sb->inner, sb->bit_mask);
+	dr_ste_v0_build_general_purpose_tag(mask, sb, sb->bit_mask);
 
 	sb->lu_type = MLX5DR_STE_LU_TYPE_GENERAL_PURPOSE;
 	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
 	sb->ste_build_tag_func = &dr_ste_v0_build_general_purpose_tag;
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
 static int
 dr_ste_v0_build_eth_l4_misc_tag(struct mlx5dr_match_param *value,
 				struct mlx5dr_ste_build *sb,
@@ -1005,30 +757,13 @@ static void
 dr_ste_v0_build_eth_l4_misc_init(struct mlx5dr_ste_build *sb,
 				 struct mlx5dr_match_param *mask)
 {
-	dr_ste_v0_build_eth_l4_misc_bit_mask(mask, sb->inner, sb->bit_mask);
+	dr_ste_v0_build_eth_l4_misc_tag(mask, sb, sb->bit_mask);
 
 	sb->lu_type = DR_STE_CALC_LU_TYPE(ETHL4_MISC, sb->rx, sb->inner);
 	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
 	sb->ste_build_tag_func = &dr_ste_v0_build_eth_l4_misc_tag;
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
 static int
 dr_ste_v0_build_flex_parser_tnl_vxlan_gpe_tag(struct mlx5dr_match_param *value,
 					      struct mlx5dr_ste_build *sb,
@@ -1053,33 +788,12 @@ static void
 dr_ste_v0_build_flex_parser_tnl_vxlan_gpe_init(struct mlx5dr_ste_build *sb,
 					       struct mlx5dr_match_param *mask)
 {
-	dr_ste_v0_build_flex_parser_tnl_vxlan_gpe_bit_mask(mask, sb->inner,
-							   sb->bit_mask);
+	dr_ste_v0_build_flex_parser_tnl_vxlan_gpe_tag(mask, sb, sb->bit_mask);
 	sb->lu_type = MLX5DR_STE_LU_TYPE_FLEX_PARSER_TNL_HEADER;
 	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
 	sb->ste_build_tag_func = &dr_ste_v0_build_flex_parser_tnl_vxlan_gpe_tag;
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
 static int
 dr_ste_v0_build_flex_parser_tnl_geneve_tag(struct mlx5dr_match_param *value,
 					   struct mlx5dr_ste_build *sb,
@@ -1103,28 +817,12 @@ static void
 dr_ste_v0_build_flex_parser_tnl_geneve_init(struct mlx5dr_ste_build *sb,
 					    struct mlx5dr_match_param *mask)
 {
-	dr_ste_v0_build_flex_parser_tnl_geneve_bit_mask(mask, sb->bit_mask);
+	dr_ste_v0_build_flex_parser_tnl_geneve_tag(mask, sb, sb->bit_mask);
 	sb->lu_type = MLX5DR_STE_LU_TYPE_FLEX_PARSER_TNL_HEADER;
 	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
 	sb->ste_build_tag_func = &dr_ste_v0_build_flex_parser_tnl_geneve_tag;
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
 static int
 dr_ste_v0_build_register_0_tag(struct mlx5dr_match_param *value,
 			       struct mlx5dr_ste_build *sb,
@@ -1144,29 +842,13 @@ static void
 dr_ste_v0_build_register_0_init(struct mlx5dr_ste_build *sb,
 				struct mlx5dr_match_param *mask)
 {
-	dr_ste_v0_build_register_0_bit_mask(mask, sb->bit_mask);
+	dr_ste_v0_build_register_0_tag(mask, sb, sb->bit_mask);
 
 	sb->lu_type = MLX5DR_STE_LU_TYPE_STEERING_REGISTERS_0;
 	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
 	sb->ste_build_tag_func = &dr_ste_v0_build_register_0_tag;
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
 static int
 dr_ste_v0_build_register_1_tag(struct mlx5dr_match_param *value,
 			       struct mlx5dr_ste_build *sb,
@@ -1186,7 +868,7 @@ static void
 dr_ste_v0_build_register_1_init(struct mlx5dr_ste_build *sb,
 				struct mlx5dr_match_param *mask)
 {
-	dr_ste_v0_build_register_1_bit_mask(mask, sb->bit_mask);
+	dr_ste_v0_build_register_1_tag(mask, sb, sb->bit_mask);
 
 	sb->lu_type = MLX5DR_STE_LU_TYPE_STEERING_REGISTERS_1;
 	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
@@ -1199,8 +881,8 @@ dr_ste_v0_build_src_gvmi_qpn_bit_mask(struct mlx5dr_match_param *value,
 {
 	struct mlx5dr_match_misc *misc_mask = &value->misc;
 
-	DR_STE_SET_MASK(src_gvmi_qp, bit_mask, source_gvmi, misc_mask, source_port);
-	DR_STE_SET_MASK(src_gvmi_qp, bit_mask, source_qp, misc_mask, source_sqn);
+	DR_STE_SET_ONES(src_gvmi_qp, bit_mask, source_gvmi, misc_mask, source_port);
+	DR_STE_SET_ONES(src_gvmi_qp, bit_mask, source_qp, misc_mask, source_sqn);
 	misc_mask->source_eswitch_owner_vhca_id = 0;
 }
 
-- 
2.26.2

