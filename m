Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2A53650CC
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 05:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234554AbhDTDVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 23:21:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234074AbhDTDVJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 23:21:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBF1461220;
        Tue, 20 Apr 2021 03:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618888838;
        bh=SAeIi2Jr/6uAUffWp50qU+oGZDwOoVKmqKE8sl8gnUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qrbJlVA79On5T8h0PX2i+8zTgS7COwoHrvxAaGwJWMVrt8dOOWpSAGYNAng/a0sFn
         BIInrC3pMt6WceofnmuKaAg+yLZE0F+Zh0xgzdtMyzlexngXRsaBql3m9x1gFzBT4L
         rn8e6ojk3idhzlELmlaNMhb0lEsg2rKXc8b6dd1LHR7ccio0pCwf3pDfo5A2FxJqHN
         dFIn3M5vRCWUx2woJKNT5mKPpaPup7rMisQs+/72Hu1roxcH6ds9RZiS5ZrwtHButf
         Z9f/O1RLjh4yxN+gQgignFnvHAm5f3FRthWDhzc1Am9HtqJ7qJixBSMQQ4QInI68zf
         yWn3Zx/jrsCEg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Muhammad Sammar <muhammads@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/15] net/mlx5: DR, Set STEv0 ICMP flex parser dynamically
Date:   Mon, 19 Apr 2021 20:20:13 -0700
Message-Id: <20210420032018.58639-11-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210420032018.58639-1-saeed@kernel.org>
References: <20210420032018.58639-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Set the flex parser ID dynamicly for ICMP instead of relying
on hardcoded values.

Signed-off-by: Muhammad Sammar <muhammads@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_matcher.c  | 12 ++---
 .../mellanox/mlx5/core/steering/dr_ste.c      | 12 ++---
 .../mellanox/mlx5/core/steering/dr_ste.h      |  2 +-
 .../mellanox/mlx5/core/steering/dr_ste_v0.c   | 53 +++++++++----------
 .../mellanox/mlx5/core/steering/dr_ste_v1.c   |  6 +--
 .../mellanox/mlx5/core/steering/dr_types.h    | 10 ++--
 6 files changed, 43 insertions(+), 52 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index 3a7576125404..f83fea98cc46 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -376,13 +376,11 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 			mlx5dr_ste_build_tnl_mpls(ste_ctx, &sb[idx++],
 						  &mask, inner, rx);
 
-		if (dr_mask_is_icmp(&mask, dmn)) {
-			ret = mlx5dr_ste_build_icmp(ste_ctx, &sb[idx++],
-						    &mask, &dmn->info.caps,
-						    inner, rx);
-			if (ret)
-				return ret;
-		}
+		if (dr_mask_is_icmp(&mask, dmn))
+			mlx5dr_ste_build_icmp(ste_ctx, &sb[idx++],
+					      &mask, &dmn->info.caps,
+					      inner, rx);
+
 		if (dr_mask_is_tnl_gre_set(&mask.misc))
 			mlx5dr_ste_build_tnl_gre(ste_ctx, &sb[idx++],
 						 &mask, inner, rx);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 445481f01a46..7ae718bb41eb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -1095,16 +1095,16 @@ void mlx5dr_ste_build_tnl_mpls(struct mlx5dr_ste_ctx *ste_ctx,
 	ste_ctx->build_tnl_mpls_init(sb, mask);
 }
 
-int mlx5dr_ste_build_icmp(struct mlx5dr_ste_ctx *ste_ctx,
-			  struct mlx5dr_ste_build *sb,
-			  struct mlx5dr_match_param *mask,
-			  struct mlx5dr_cmd_caps *caps,
-			  bool inner, bool rx)
+void mlx5dr_ste_build_icmp(struct mlx5dr_ste_ctx *ste_ctx,
+			   struct mlx5dr_ste_build *sb,
+			   struct mlx5dr_match_param *mask,
+			   struct mlx5dr_cmd_caps *caps,
+			   bool inner, bool rx)
 {
 	sb->rx = rx;
 	sb->inner = inner;
 	sb->caps = caps;
-	return ste_ctx->build_icmp_init(sb, mask);
+	ste_ctx->build_icmp_init(sb, mask);
 }
 
 void mlx5dr_ste_build_general_purpose(struct mlx5dr_ste_ctx *ste_ctx,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
index 5900f177d865..a00dab3b6944 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
@@ -120,7 +120,7 @@ struct mlx5dr_ste_ctx {
 	void DR_STE_CTX_BUILDER(mpls);
 	void DR_STE_CTX_BUILDER(tnl_gre);
 	void DR_STE_CTX_BUILDER(tnl_mpls);
-	int  DR_STE_CTX_BUILDER(icmp);
+	void DR_STE_CTX_BUILDER(icmp);
 	void DR_STE_CTX_BUILDER(general_purpose);
 	void DR_STE_CTX_BUILDER(eth_l4_misc);
 	void DR_STE_CTX_BUILDER(tnl_vxlan_gpe);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
index db19d99366ba..62421c33a9ca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
@@ -1297,9 +1297,11 @@ dr_ste_v0_build_icmp_tag(struct mlx5dr_match_param *value,
 	u32 *icmp_header_data;
 	int dw0_location;
 	int dw1_location;
+	u8 *parser_ptr;
 	u8 *icmp_type;
 	u8 *icmp_code;
 	bool is_ipv4;
+	u32 icmp_hdr;
 
 	is_ipv4 = DR_MASK_IS_ICMPV4_SET(misc_3);
 	if (is_ipv4) {
@@ -1316,47 +1318,40 @@ dr_ste_v0_build_icmp_tag(struct mlx5dr_match_param *value,
 		dw1_location		= sb->caps->flex_parser_id_icmpv6_dw1;
 	}
 
-	switch (dw0_location) {
-	case 4:
-		MLX5_SET(ste_flex_parser_1, tag, flex_parser_4,
-			 (*icmp_type << ICMP_TYPE_OFFSET_FIRST_DW) |
-			 (*icmp_code << ICMP_TYPE_OFFSET_FIRST_DW));
-
-		*icmp_type = 0;
-		*icmp_code = 0;
-		break;
-	default:
-		return -EINVAL;
-	}
+	parser_ptr = dr_ste_calc_flex_parser_offset(tag, dw0_location);
+	icmp_hdr = (*icmp_type << ICMP_TYPE_OFFSET_FIRST_DW) |
+		   (*icmp_code << ICMP_CODE_OFFSET_FIRST_DW);
+	*(__be32 *)parser_ptr = cpu_to_be32(icmp_hdr);
+	*icmp_code = 0;
+	*icmp_type = 0;
 
-	switch (dw1_location) {
-	case 5:
-		MLX5_SET(ste_flex_parser_1, tag, flex_parser_5,
-			 *icmp_header_data);
-		*icmp_header_data = 0;
-		break;
-	default:
-		return -EINVAL;
-	}
+	parser_ptr = dr_ste_calc_flex_parser_offset(tag, dw1_location);
+	*(__be32 *)parser_ptr = cpu_to_be32(*icmp_header_data);
+	*icmp_header_data = 0;
 
 	return 0;
 }
 
-static int
+static void
 dr_ste_v0_build_icmp_init(struct mlx5dr_ste_build *sb,
 			  struct mlx5dr_match_param *mask)
 {
-	int ret;
+	u8 parser_id;
+	bool is_ipv4;
 
-	ret = dr_ste_v0_build_icmp_tag(mask, sb, sb->bit_mask);
-	if (ret)
-		return ret;
+	dr_ste_v0_build_icmp_tag(mask, sb, sb->bit_mask);
 
-	sb->lu_type = DR_STE_V0_LU_TYPE_FLEX_PARSER_1;
+	/* STEs with lookup type FLEX_PARSER_{0/1} includes
+	 * flex parsers_{0-3}/{4-7} respectively.
+	 */
+	is_ipv4 = DR_MASK_IS_ICMPV4_SET(&mask->misc3);
+	parser_id = is_ipv4 ? sb->caps->flex_parser_id_icmp_dw0 :
+		    sb->caps->flex_parser_id_icmpv6_dw0;
+	sb->lu_type = parser_id > DR_STE_MAX_FLEX_0_ID ?
+		      DR_STE_V0_LU_TYPE_FLEX_PARSER_1 :
+		      DR_STE_V0_LU_TYPE_FLEX_PARSER_0;
 	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
 	sb->ste_build_tag_func = &dr_ste_v0_build_icmp_tag;
-
-	return 0;
 }
 
 static int
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index 1c8c08bc2d38..f77b1e9103ce 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -1337,16 +1337,14 @@ static int dr_ste_v1_build_icmp_tag(struct mlx5dr_match_param *value,
 	return 0;
 }
 
-static int dr_ste_v1_build_icmp_init(struct mlx5dr_ste_build *sb,
-				     struct mlx5dr_match_param *mask)
+static void dr_ste_v1_build_icmp_init(struct mlx5dr_ste_build *sb,
+				      struct mlx5dr_match_param *mask)
 {
 	dr_ste_v1_build_icmp_tag(mask, sb, sb->bit_mask);
 
 	sb->lu_type = DR_STE_V1_LU_TYPE_ETHL4_MISC_O;
 	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
 	sb->ste_build_tag_func = &dr_ste_v1_build_icmp_tag;
-
-	return 0;
 }
 
 static int dr_ste_v1_build_general_purpose_tag(struct mlx5dr_match_param *value,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 3ccdb806bf68..ee2ea215c4b9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -393,11 +393,11 @@ void mlx5dr_ste_build_tnl_mpls(struct mlx5dr_ste_ctx *ste_ctx,
 			       struct mlx5dr_ste_build *sb,
 			       struct mlx5dr_match_param *mask,
 			       bool inner, bool rx);
-int mlx5dr_ste_build_icmp(struct mlx5dr_ste_ctx *ste_ctx,
-			  struct mlx5dr_ste_build *sb,
-			  struct mlx5dr_match_param *mask,
-			  struct mlx5dr_cmd_caps *caps,
-			  bool inner, bool rx);
+void mlx5dr_ste_build_icmp(struct mlx5dr_ste_ctx *ste_ctx,
+			   struct mlx5dr_ste_build *sb,
+			   struct mlx5dr_match_param *mask,
+			   struct mlx5dr_cmd_caps *caps,
+			   bool inner, bool rx);
 void mlx5dr_ste_build_tnl_vxlan_gpe(struct mlx5dr_ste_ctx *ste_ctx,
 				    struct mlx5dr_ste_build *sb,
 				    struct mlx5dr_match_param *mask,
-- 
2.30.2

