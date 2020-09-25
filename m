Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF92279201
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 22:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728884AbgIYUVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 16:21:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:43068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726309AbgIYUTd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 16:19:33 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A05D623976;
        Fri, 25 Sep 2020 19:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601062705;
        bh=QdiS6wsGN/ZcWD/8Mz5v/aWeMtZaObDJIi3F5/Kj1EU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WRzU5yTi0eklI5S0hDzEo7RUMhq7YObOuF8rL+620fx3mHNRbw46Ttsvab3KWeszF
         fyqkogQ4Ju9soqn98p9fIrzh6PiNvIiFqrvOOnyzm9LcmWilcR7mHJVjqAx3Nqvn2O
         RfJ5YWlTaO9YUojAXhw3oeTwWYAvZ0FChVG0vu74=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/15] net/mlx5: DR, Rename builders HW specific names
Date:   Fri, 25 Sep 2020 12:38:07 -0700
Message-Id: <20200925193809.463047-14-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200925193809.463047-1-saeed@kernel.org>
References: <20200925193809.463047-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

We will support multiple STE versions.
The existing naming is not suitable for newer versions.
Removed the HW specific details and renamed with a more
general names.

Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_matcher.c  | 63 ++++++++++---------
 .../mellanox/mlx5/core/steering/dr_ste.c      | 42 ++++++-------
 .../mellanox/mlx5/core/steering/dr_types.h    | 42 ++++++-------
 3 files changed, 76 insertions(+), 71 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index 7df883686d46..752afdb20e23 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -85,7 +85,7 @@ static bool dr_mask_is_ttl_set(struct mlx5dr_match_spec *spec)
 	(_misc2)._inner_outer##_first_mpls_s_bos || \
 	(_misc2)._inner_outer##_first_mpls_ttl)
 
-static bool dr_mask_is_gre_set(struct mlx5dr_match_misc *misc)
+static bool dr_mask_is_tnl_gre_set(struct mlx5dr_match_misc *misc)
 {
 	return (misc->gre_key_h || misc->gre_key_l ||
 		misc->gre_protocol || misc->gre_c_present ||
@@ -98,7 +98,7 @@ static bool dr_mask_is_gre_set(struct mlx5dr_match_misc *misc)
 	(_misc2).outer_first_mpls_over_##gre_udp##_s_bos || \
 	(_misc2).outer_first_mpls_over_##gre_udp##_ttl)
 
-#define DR_MASK_IS_FLEX_PARSER_0_SET(_misc2) ( \
+#define DR_MASK_IS_TNL_MPLS_SET(_misc2) ( \
 	DR_MASK_IS_OUTER_MPLS_OVER_GRE_UDP_SET((_misc2), gre) || \
 	DR_MASK_IS_OUTER_MPLS_OVER_GRE_UDP_SET((_misc2), udp))
 
@@ -148,12 +148,23 @@ dr_mask_is_flex_parser_tnl_geneve_set(struct mlx5dr_match_param *mask,
 	       dr_matcher_supp_flex_parser_geneve(&dmn->info.caps);
 }
 
-static bool dr_mask_is_flex_parser_icmpv6_set(struct mlx5dr_match_misc3 *misc3)
+static bool dr_mask_is_icmpv6_set(struct mlx5dr_match_misc3 *misc3)
 {
 	return (misc3->icmpv6_type || misc3->icmpv6_code ||
 		misc3->icmpv6_header_data);
 }
 
+static bool dr_mask_is_flex_parser_icmp_set(struct mlx5dr_match_param *mask,
+					    struct mlx5dr_domain *dmn)
+{
+	if (DR_MASK_IS_ICMPV4_SET(&mask->misc3))
+		return mlx5dr_matcher_supp_flex_parser_icmp_v4(&dmn->info.caps);
+	else if (dr_mask_is_icmpv6_set(&mask->misc3))
+		return mlx5dr_matcher_supp_flex_parser_icmp_v6(&dmn->info.caps);
+
+	return false;
+}
+
 static bool dr_mask_is_wqe_metadata_set(struct mlx5dr_match_misc2 *misc2)
 {
 	return misc2->metadata_reg_a;
@@ -257,7 +268,7 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 
 		if (dr_mask_is_smac_set(&mask.outer) &&
 		    dr_mask_is_dmac_set(&mask.outer)) {
-			mlx5dr_ste_build_eth_l2_src_des(&sb[idx++], &mask,
+			mlx5dr_ste_build_eth_l2_src_dst(&sb[idx++], &mask,
 							inner, rx);
 		}
 
@@ -277,8 +288,8 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 								 inner, rx);
 
 			if (DR_MASK_IS_ETH_L4_SET(mask.outer, mask.misc, outer))
-				mlx5dr_ste_build_ipv6_l3_l4(&sb[idx++], &mask,
-							    inner, rx);
+				mlx5dr_ste_build_eth_ipv6_l3_l4(&sb[idx++], &mask,
+								inner, rx);
 		} else {
 			if (dr_mask_is_ipv4_5_tuple_set(&mask.outer))
 				mlx5dr_ste_build_eth_l3_ipv4_5_tuple(&sb[idx++], &mask,
@@ -290,13 +301,11 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 		}
 
 		if (dr_mask_is_flex_parser_tnl_vxlan_gpe_set(&mask, dmn))
-			mlx5dr_ste_build_flex_parser_tnl_vxlan_gpe(&sb[idx++],
-								   &mask,
-								   inner, rx);
+			mlx5dr_ste_build_tnl_vxlan_gpe(&sb[idx++], &mask,
+						       inner, rx);
 		else if (dr_mask_is_flex_parser_tnl_geneve_set(&mask, dmn))
-			mlx5dr_ste_build_flex_parser_tnl_geneve(&sb[idx++],
-								&mask,
-								inner, rx);
+			mlx5dr_ste_build_tnl_geneve(&sb[idx++], &mask,
+						    inner, rx);
 
 		if (DR_MASK_IS_ETH_L4_MISC_SET(mask.misc3, outer))
 			mlx5dr_ste_build_eth_l4_misc(&sb[idx++], &mask, inner, rx);
@@ -304,22 +313,18 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 		if (DR_MASK_IS_FIRST_MPLS_SET(mask.misc2, outer))
 			mlx5dr_ste_build_mpls(&sb[idx++], &mask, inner, rx);
 
-		if (DR_MASK_IS_FLEX_PARSER_0_SET(mask.misc2))
-			mlx5dr_ste_build_flex_parser_0(&sb[idx++], &mask,
-						       inner, rx);
+		if (DR_MASK_IS_TNL_MPLS_SET(mask.misc2))
+			mlx5dr_ste_build_tnl_mpls(&sb[idx++], &mask, inner, rx);
 
-		if ((DR_MASK_IS_FLEX_PARSER_ICMPV4_SET(&mask.misc3) &&
-		     mlx5dr_matcher_supp_flex_parser_icmp_v4(&dmn->info.caps)) ||
-		    (dr_mask_is_flex_parser_icmpv6_set(&mask.misc3) &&
-		     mlx5dr_matcher_supp_flex_parser_icmp_v6(&dmn->info.caps))) {
-			ret = mlx5dr_ste_build_flex_parser_1(&sb[idx++],
-							     &mask, &dmn->info.caps,
-							     inner, rx);
+		if (dr_mask_is_flex_parser_icmp_set(&mask, dmn)) {
+			ret = mlx5dr_ste_build_icmp(&sb[idx++],
+						    &mask, &dmn->info.caps,
+						    inner, rx);
 			if (ret)
 				return ret;
 		}
-		if (dr_mask_is_gre_set(&mask.misc))
-			mlx5dr_ste_build_gre(&sb[idx++], &mask, inner, rx);
+		if (dr_mask_is_tnl_gre_set(&mask.misc))
+			mlx5dr_ste_build_tnl_gre(&sb[idx++], &mask, inner, rx);
 	}
 
 	/* Inner */
@@ -334,7 +339,7 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 
 		if (dr_mask_is_smac_set(&mask.inner) &&
 		    dr_mask_is_dmac_set(&mask.inner)) {
-			mlx5dr_ste_build_eth_l2_src_des(&sb[idx++],
+			mlx5dr_ste_build_eth_l2_src_dst(&sb[idx++],
 							&mask, inner, rx);
 		}
 
@@ -354,8 +359,8 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 								 inner, rx);
 
 			if (DR_MASK_IS_ETH_L4_SET(mask.inner, mask.misc, inner))
-				mlx5dr_ste_build_ipv6_l3_l4(&sb[idx++], &mask,
-							    inner, rx);
+				mlx5dr_ste_build_eth_ipv6_l3_l4(&sb[idx++], &mask,
+								inner, rx);
 		} else {
 			if (dr_mask_is_ipv4_5_tuple_set(&mask.inner))
 				mlx5dr_ste_build_eth_l3_ipv4_5_tuple(&sb[idx++], &mask,
@@ -372,8 +377,8 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 		if (DR_MASK_IS_FIRST_MPLS_SET(mask.misc2, inner))
 			mlx5dr_ste_build_mpls(&sb[idx++], &mask, inner, rx);
 
-		if (DR_MASK_IS_FLEX_PARSER_0_SET(mask.misc2))
-			mlx5dr_ste_build_flex_parser_0(&sb[idx++], &mask, inner, rx);
+		if (DR_MASK_IS_TNL_MPLS_SET(mask.misc2))
+			mlx5dr_ste_build_tnl_mpls(&sb[idx++], &mask, inner, rx);
 	}
 	/* Empty matcher, takes all */
 	if (matcher->match_criteria == DR_MATCHER_CRITERIA_EMPTY)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index b01aaec75622..d275823bff2f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -1090,7 +1090,7 @@ static int dr_ste_build_eth_l2_src_des_tag(struct mlx5dr_match_param *value,
 	return 0;
 }
 
-void mlx5dr_ste_build_eth_l2_src_des(struct mlx5dr_ste_build *sb,
+void mlx5dr_ste_build_eth_l2_src_dst(struct mlx5dr_ste_build *sb,
 				     struct mlx5dr_match_param *mask,
 				     bool inner, bool rx)
 {
@@ -1594,9 +1594,9 @@ static int dr_ste_build_ipv6_l3_l4_tag(struct mlx5dr_match_param *value,
 	return 0;
 }
 
-void mlx5dr_ste_build_ipv6_l3_l4(struct mlx5dr_ste_build *sb,
-				 struct mlx5dr_match_param *mask,
-				 bool inner, bool rx)
+void mlx5dr_ste_build_eth_ipv6_l3_l4(struct mlx5dr_ste_build *sb,
+				     struct mlx5dr_match_param *mask,
+				     bool inner, bool rx)
 {
 	dr_ste_build_ipv6_l3_l4_bit_mask(mask, inner, sb->bit_mask);
 
@@ -1693,8 +1693,8 @@ static int dr_ste_build_gre_tag(struct mlx5dr_match_param *value,
 	return 0;
 }
 
-void mlx5dr_ste_build_gre(struct mlx5dr_ste_build *sb,
-			  struct mlx5dr_match_param *mask, bool inner, bool rx)
+void mlx5dr_ste_build_tnl_gre(struct mlx5dr_ste_build *sb,
+			      struct mlx5dr_match_param *mask, bool inner, bool rx)
 {
 	dr_ste_build_gre_bit_mask(mask, inner, sb->bit_mask);
 
@@ -1771,9 +1771,9 @@ static int dr_ste_build_flex_parser_0_tag(struct mlx5dr_match_param *value,
 	return 0;
 }
 
-void mlx5dr_ste_build_flex_parser_0(struct mlx5dr_ste_build *sb,
-				    struct mlx5dr_match_param *mask,
-				    bool inner, bool rx)
+void mlx5dr_ste_build_tnl_mpls(struct mlx5dr_ste_build *sb,
+			       struct mlx5dr_match_param *mask,
+			       bool inner, bool rx)
 {
 	dr_ste_build_flex_parser_0_bit_mask(mask, inner, sb->bit_mask);
 
@@ -1792,8 +1792,8 @@ static int dr_ste_build_flex_parser_1_bit_mask(struct mlx5dr_match_param *mask,
 					       struct mlx5dr_cmd_caps *caps,
 					       u8 *bit_mask)
 {
+	bool is_ipv4_mask = DR_MASK_IS_ICMPV4_SET(&mask->misc3);
 	struct mlx5dr_match_misc3 *misc_3_mask = &mask->misc3;
-	bool is_ipv4_mask = DR_MASK_IS_FLEX_PARSER_ICMPV4_SET(misc_3_mask);
 	u32 icmp_header_data_mask;
 	u32 icmp_type_mask;
 	u32 icmp_code_mask;
@@ -1869,7 +1869,7 @@ static int dr_ste_build_flex_parser_1_tag(struct mlx5dr_match_param *value,
 	u32 icmp_code;
 	bool is_ipv4;
 
-	is_ipv4 = DR_MASK_IS_FLEX_PARSER_ICMPV4_SET(misc_3);
+	is_ipv4 = DR_MASK_IS_ICMPV4_SET(misc_3);
 	if (is_ipv4) {
 		icmp_header_data	= misc_3->icmpv4_header_data;
 		icmp_type		= misc_3->icmpv4_type;
@@ -1928,10 +1928,10 @@ static int dr_ste_build_flex_parser_1_tag(struct mlx5dr_match_param *value,
 	return 0;
 }
 
-int mlx5dr_ste_build_flex_parser_1(struct mlx5dr_ste_build *sb,
-				   struct mlx5dr_match_param *mask,
-				   struct mlx5dr_cmd_caps *caps,
-				   bool inner, bool rx)
+int mlx5dr_ste_build_icmp(struct mlx5dr_ste_build *sb,
+			  struct mlx5dr_match_param *mask,
+			  struct mlx5dr_cmd_caps *caps,
+			  bool inner, bool rx)
 {
 	int ret;
 
@@ -2069,9 +2069,9 @@ dr_ste_build_flex_parser_tnl_vxlan_gpe_tag(struct mlx5dr_match_param *value,
 	return 0;
 }
 
-void mlx5dr_ste_build_flex_parser_tnl_vxlan_gpe(struct mlx5dr_ste_build *sb,
-						struct mlx5dr_match_param *mask,
-						bool inner, bool rx)
+void mlx5dr_ste_build_tnl_vxlan_gpe(struct mlx5dr_ste_build *sb,
+				    struct mlx5dr_match_param *mask,
+				    bool inner, bool rx)
 {
 	dr_ste_build_flex_parser_tnl_vxlan_gpe_bit_mask(mask, inner,
 							sb->bit_mask);
@@ -2122,9 +2122,9 @@ dr_ste_build_flex_parser_tnl_geneve_tag(struct mlx5dr_match_param *value,
 	return 0;
 }
 
-void mlx5dr_ste_build_flex_parser_tnl_geneve(struct mlx5dr_ste_build *sb,
-					     struct mlx5dr_match_param *mask,
-					     bool inner, bool rx)
+void mlx5dr_ste_build_tnl_geneve(struct mlx5dr_ste_build *sb,
+				 struct mlx5dr_match_param *mask,
+				 bool inner, bool rx)
 {
 	dr_ste_build_flex_parser_tnl_geneve_bit_mask(mask, sb->bit_mask);
 	sb->rx = rx;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 77615f6d2fdf..5d0ae664aac0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -288,7 +288,7 @@ int mlx5dr_ste_build_ste_arr(struct mlx5dr_matcher *matcher,
 			     struct mlx5dr_matcher_rx_tx *nic_matcher,
 			     struct mlx5dr_match_param *value,
 			     u8 *ste_arr);
-void mlx5dr_ste_build_eth_l2_src_des(struct mlx5dr_ste_build *builder,
+void mlx5dr_ste_build_eth_l2_src_dst(struct mlx5dr_ste_build *builder,
 				     struct mlx5dr_match_param *mask,
 				     bool inner, bool rx);
 void mlx5dr_ste_build_eth_l3_ipv4_5_tuple(struct mlx5dr_ste_build *sb,
@@ -312,31 +312,31 @@ void mlx5dr_ste_build_eth_l2_dst(struct mlx5dr_ste_build *sb,
 void mlx5dr_ste_build_eth_l2_tnl(struct mlx5dr_ste_build *sb,
 				 struct mlx5dr_match_param *mask,
 				 bool inner, bool rx);
-void mlx5dr_ste_build_ipv6_l3_l4(struct mlx5dr_ste_build *sb,
-				 struct mlx5dr_match_param *mask,
-				 bool inner, bool rx);
+void mlx5dr_ste_build_eth_ipv6_l3_l4(struct mlx5dr_ste_build *sb,
+				     struct mlx5dr_match_param *mask,
+				     bool inner, bool rx);
 void mlx5dr_ste_build_eth_l4_misc(struct mlx5dr_ste_build *sb,
 				  struct mlx5dr_match_param *mask,
 				  bool inner, bool rx);
-void mlx5dr_ste_build_gre(struct mlx5dr_ste_build *sb,
-			  struct mlx5dr_match_param *mask,
-			  bool inner, bool rx);
+void mlx5dr_ste_build_tnl_gre(struct mlx5dr_ste_build *sb,
+			      struct mlx5dr_match_param *mask,
+			      bool inner, bool rx);
 void mlx5dr_ste_build_mpls(struct mlx5dr_ste_build *sb,
 			   struct mlx5dr_match_param *mask,
 			   bool inner, bool rx);
-void mlx5dr_ste_build_flex_parser_0(struct mlx5dr_ste_build *sb,
+void mlx5dr_ste_build_tnl_mpls(struct mlx5dr_ste_build *sb,
+			       struct mlx5dr_match_param *mask,
+			       bool inner, bool rx);
+int mlx5dr_ste_build_icmp(struct mlx5dr_ste_build *sb,
+			  struct mlx5dr_match_param *mask,
+			  struct mlx5dr_cmd_caps *caps,
+			  bool inner, bool rx);
+void mlx5dr_ste_build_tnl_vxlan_gpe(struct mlx5dr_ste_build *sb,
 				    struct mlx5dr_match_param *mask,
 				    bool inner, bool rx);
-int mlx5dr_ste_build_flex_parser_1(struct mlx5dr_ste_build *sb,
-				   struct mlx5dr_match_param *mask,
-				   struct mlx5dr_cmd_caps *caps,
-				   bool inner, bool rx);
-void mlx5dr_ste_build_flex_parser_tnl_vxlan_gpe(struct mlx5dr_ste_build *sb,
-						struct mlx5dr_match_param *mask,
-						bool inner, bool rx);
-void mlx5dr_ste_build_flex_parser_tnl_geneve(struct mlx5dr_ste_build *sb,
-					     struct mlx5dr_match_param *mask,
-					     bool inner, bool rx);
+void mlx5dr_ste_build_tnl_geneve(struct mlx5dr_ste_build *sb,
+				 struct mlx5dr_match_param *mask,
+				 bool inner, bool rx);
 void mlx5dr_ste_build_general_purpose(struct mlx5dr_ste_build *sb,
 				      struct mlx5dr_match_param *mask,
 				      bool inner, bool rx);
@@ -588,9 +588,9 @@ struct mlx5dr_match_param {
 	struct mlx5dr_match_misc3 misc3;
 };
 
-#define DR_MASK_IS_FLEX_PARSER_ICMPV4_SET(_misc3) ((_misc3)->icmpv4_type || \
-						   (_misc3)->icmpv4_code || \
-						   (_misc3)->icmpv4_header_data)
+#define DR_MASK_IS_ICMPV4_SET(_misc3) ((_misc3)->icmpv4_type || \
+				       (_misc3)->icmpv4_code || \
+				       (_misc3)->icmpv4_header_data)
 
 struct mlx5dr_esw_caps {
 	u64 drop_icm_address_rx;
-- 
2.26.2

