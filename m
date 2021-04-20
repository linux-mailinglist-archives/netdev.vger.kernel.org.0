Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6497E3650CE
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 05:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbhDTDVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 23:21:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:40616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234182AbhDTDVK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 23:21:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13F986135F;
        Tue, 20 Apr 2021 03:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618888839;
        bh=yLU0vdDTKdmiTgOfhAZQNXamLwXBw7JePVRRc+geQpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eKDk+DZbqxp/bv3BXrbVMNePoHqnEWPbM4wenFg5YyrbT+NGWXMnmA675Q75KWtAt
         +fC8cqlSSRDGvoF8chuAcwewA4Zm1wuN/kQKaETNNeWmZ59SPXBOhDClKdYc+RCudM
         Uo98WBUGKovtcb8YBhQ6lUnfZf9rNbZBGMrAMWPSf2Ot289H1/+/daEM5vzTR90br3
         EHhB+h9RMwgh4RJyWVzAqoyZoQysPCIPdtFdhmascsWteMJDtlbfpJsdnRn8tveW4t
         DNlYEwAsem+nwRLxJ1PxQBwDJW97+An1oig7ho8VMgt3ZDD6xzFmBc6qx5ny7bdbiT
         3GGQw9SpX6GAw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Muhammad Sammar <muhammads@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/15] net/mlx5: DR, Set flex parser for TNL_MPLS dynamically
Date:   Mon, 19 Apr 2021 20:20:15 -0700
Message-Id: <20210420032018.58639-13-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210420032018.58639-1-saeed@kernel.org>
References: <20210420032018.58639-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Query the flex_parser id that's intended for TNL_MPLS
and use an appropriate flex parser for MPLS over UDP/GRE.

Signed-off-by: Muhammad Sammar <muhammads@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_cmd.c      |  8 ++
 .../mellanox/mlx5/core/steering/dr_matcher.c  | 65 ++++++++++----
 .../mellanox/mlx5/core/steering/dr_ste.c      | 24 +++--
 .../mellanox/mlx5/core/steering/dr_ste.h      |  2 +
 .../mellanox/mlx5/core/steering/dr_ste_v0.c   | 87 +++++++++++++++++++
 .../mellanox/mlx5/core/steering/dr_ste_v1.c   | 84 ++++++++++++++++++
 .../mellanox/mlx5/core/steering/dr_types.h    | 12 +++
 7 files changed, 262 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
index 0561df8616c7..dfb1e955409e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -110,6 +110,14 @@ int mlx5dr_cmd_query_device(struct mlx5_core_dev *mdev,
 		caps->flex_parser_id_geneve_tlv_option_0 =
 			MLX5_CAP_GEN(mdev, flex_parser_id_geneve_tlv_option_0);
 
+	if (caps->flex_protocols & MLX5_FLEX_PARSER_MPLS_OVER_GRE_ENABLED)
+		caps->flex_parser_id_mpls_over_gre =
+			MLX5_CAP_GEN(mdev, flex_parser_id_outer_first_mpls_over_gre);
+
+	if (caps->flex_protocols & mlx5_FLEX_PARSER_MPLS_OVER_UDP_ENABLED)
+		caps->flex_parser_id_mpls_over_udp =
+			MLX5_CAP_GEN(mdev, flex_parser_id_outer_first_mpls_over_udp_label);
+
 	caps->nic_rx_drop_address =
 		MLX5_CAP64_FLOWTABLE(mdev, sw_steering_nic_rx_action_drop_icm_address);
 	caps->nic_tx_drop_address =
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index 0aa4a994fe77..531eb69eeea1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -92,15 +92,17 @@ static bool dr_mask_is_tnl_gre_set(struct mlx5dr_match_misc *misc)
 		misc->gre_k_present || misc->gre_s_present);
 }
 
-#define DR_MASK_IS_OUTER_MPLS_OVER_GRE_UDP_SET(_misc2, gre_udp) ( \
-	(_misc2).outer_first_mpls_over_##gre_udp##_label || \
-	(_misc2).outer_first_mpls_over_##gre_udp##_exp || \
-	(_misc2).outer_first_mpls_over_##gre_udp##_s_bos || \
-	(_misc2).outer_first_mpls_over_##gre_udp##_ttl)
-
-#define DR_MASK_IS_TNL_MPLS_SET(_misc2) ( \
-	DR_MASK_IS_OUTER_MPLS_OVER_GRE_UDP_SET((_misc2), gre) || \
-	DR_MASK_IS_OUTER_MPLS_OVER_GRE_UDP_SET((_misc2), udp))
+#define DR_MASK_IS_OUTER_MPLS_OVER_GRE_SET(_misc) (\
+	(_misc)->outer_first_mpls_over_gre_label || \
+	(_misc)->outer_first_mpls_over_gre_exp || \
+	(_misc)->outer_first_mpls_over_gre_s_bos || \
+	(_misc)->outer_first_mpls_over_gre_ttl)
+
+#define DR_MASK_IS_OUTER_MPLS_OVER_UDP_SET(_misc) (\
+	(_misc)->outer_first_mpls_over_udp_label || \
+	(_misc)->outer_first_mpls_over_udp_exp || \
+	(_misc)->outer_first_mpls_over_udp_s_bos || \
+	(_misc)->outer_first_mpls_over_udp_ttl)
 
 static bool
 dr_mask_is_vxlan_gpe_set(struct mlx5dr_match_misc3 *misc3)
@@ -240,6 +242,29 @@ static bool dr_mask_is_flex_parser_4_7_set(struct mlx5dr_match_misc4 *misc4)
 		dr_mask_is_flex_parser_id_4_7_set(misc4->prog_sample_field_id_3));
 }
 
+static int dr_matcher_supp_tnl_mpls_over_gre(struct mlx5dr_cmd_caps *caps)
+{
+	return caps->flex_protocols & MLX5_FLEX_PARSER_MPLS_OVER_GRE_ENABLED;
+}
+
+static bool dr_mask_is_tnl_mpls_over_gre(struct mlx5dr_match_param *mask,
+					 struct mlx5dr_domain *dmn)
+{
+	return DR_MASK_IS_OUTER_MPLS_OVER_GRE_SET(&mask->misc2) &&
+	       dr_matcher_supp_tnl_mpls_over_gre(&dmn->info.caps);
+}
+
+static int dr_matcher_supp_tnl_mpls_over_udp(struct mlx5dr_cmd_caps *caps)
+{
+	return caps->flex_protocols & mlx5_FLEX_PARSER_MPLS_OVER_UDP_ENABLED;
+}
+
+static bool dr_mask_is_tnl_mpls_over_udp(struct mlx5dr_match_param *mask,
+					 struct mlx5dr_domain *dmn)
+{
+	return DR_MASK_IS_OUTER_MPLS_OVER_UDP_SET(&mask->misc2) &&
+	       dr_matcher_supp_tnl_mpls_over_udp(&dmn->info.caps);
+}
 int mlx5dr_matcher_select_builders(struct mlx5dr_matcher *matcher,
 				   struct mlx5dr_matcher_rx_tx *nic_matcher,
 				   enum mlx5dr_ipv outer_ipv,
@@ -381,9 +406,14 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 			mlx5dr_ste_build_mpls(ste_ctx, &sb[idx++],
 					      &mask, inner, rx);
 
-		if (DR_MASK_IS_TNL_MPLS_SET(mask.misc2))
-			mlx5dr_ste_build_tnl_mpls(ste_ctx, &sb[idx++],
-						  &mask, inner, rx);
+		if (dr_mask_is_tnl_mpls_over_gre(&mask, dmn))
+			mlx5dr_ste_build_tnl_mpls_over_gre(ste_ctx, &sb[idx++],
+							   &mask, &dmn->info.caps,
+							   inner, rx);
+		else if (dr_mask_is_tnl_mpls_over_udp(&mask, dmn))
+			mlx5dr_ste_build_tnl_mpls_over_udp(ste_ctx, &sb[idx++],
+							   &mask, &dmn->info.caps,
+							   inner, rx);
 
 		if (dr_mask_is_icmp(&mask, dmn))
 			mlx5dr_ste_build_icmp(ste_ctx, &sb[idx++],
@@ -450,9 +480,14 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 			mlx5dr_ste_build_mpls(ste_ctx, &sb[idx++],
 					      &mask, inner, rx);
 
-		if (DR_MASK_IS_TNL_MPLS_SET(mask.misc2))
-			mlx5dr_ste_build_tnl_mpls(ste_ctx, &sb[idx++],
-						  &mask, inner, rx);
+		if (dr_mask_is_tnl_mpls_over_gre(&mask, dmn))
+			mlx5dr_ste_build_tnl_mpls_over_gre(ste_ctx, &sb[idx++],
+							   &mask, &dmn->info.caps,
+							   inner, rx);
+		else if (dr_mask_is_tnl_mpls_over_udp(&mask, dmn))
+			mlx5dr_ste_build_tnl_mpls_over_udp(ste_ctx, &sb[idx++],
+							   &mask, &dmn->info.caps,
+							   inner, rx);
 	}
 
 	if (matcher->match_criteria & DR_MATCHER_CRITERIA_MISC4) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 8d98341802e3..6ae839b1ec8a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -1087,14 +1087,28 @@ void mlx5dr_ste_build_tnl_gre(struct mlx5dr_ste_ctx *ste_ctx,
 	ste_ctx->build_tnl_gre_init(sb, mask);
 }
 
-void mlx5dr_ste_build_tnl_mpls(struct mlx5dr_ste_ctx *ste_ctx,
-			       struct mlx5dr_ste_build *sb,
-			       struct mlx5dr_match_param *mask,
-			       bool inner, bool rx)
+void mlx5dr_ste_build_tnl_mpls_over_gre(struct mlx5dr_ste_ctx *ste_ctx,
+					struct mlx5dr_ste_build *sb,
+					struct mlx5dr_match_param *mask,
+					struct mlx5dr_cmd_caps *caps,
+					bool inner, bool rx)
+{
+	sb->rx = rx;
+	sb->inner = inner;
+	sb->caps = caps;
+	return ste_ctx->build_tnl_mpls_over_gre_init(sb, mask);
+}
+
+void mlx5dr_ste_build_tnl_mpls_over_udp(struct mlx5dr_ste_ctx *ste_ctx,
+					struct mlx5dr_ste_build *sb,
+					struct mlx5dr_match_param *mask,
+					struct mlx5dr_cmd_caps *caps,
+					bool inner, bool rx)
 {
 	sb->rx = rx;
 	sb->inner = inner;
-	ste_ctx->build_tnl_mpls_init(sb, mask);
+	sb->caps = caps;
+	return ste_ctx->build_tnl_mpls_over_udp_init(sb, mask);
 }
 
 void mlx5dr_ste_build_icmp(struct mlx5dr_ste_ctx *ste_ctx,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
index 5fa268a6c7df..2d2dc680ad13 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
@@ -120,6 +120,8 @@ struct mlx5dr_ste_ctx {
 	void DR_STE_CTX_BUILDER(mpls);
 	void DR_STE_CTX_BUILDER(tnl_gre);
 	void DR_STE_CTX_BUILDER(tnl_mpls);
+	void DR_STE_CTX_BUILDER(tnl_mpls_over_gre);
+	void DR_STE_CTX_BUILDER(tnl_mpls_over_udp);
 	void DR_STE_CTX_BUILDER(icmp);
 	void DR_STE_CTX_BUILDER(general_purpose);
 	void DR_STE_CTX_BUILDER(eth_l4_misc);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
index cf923a7e9b3b..c62f64d48213 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
@@ -1285,6 +1285,91 @@ dr_ste_v0_build_tnl_mpls_init(struct mlx5dr_ste_build *sb,
 	sb->ste_build_tag_func = &dr_ste_v0_build_tnl_mpls_tag;
 }
 
+static int
+dr_ste_v0_build_tnl_mpls_over_udp_tag(struct mlx5dr_match_param *value,
+				      struct mlx5dr_ste_build *sb,
+				      u8 *tag)
+{
+	struct mlx5dr_match_misc2 *misc2 = &value->misc2;
+	u8 *parser_ptr;
+	u8 parser_id;
+	u32 mpls_hdr;
+
+	mpls_hdr = misc2->outer_first_mpls_over_udp_label << HDR_MPLS_OFFSET_LABEL;
+	misc2->outer_first_mpls_over_udp_label = 0;
+	mpls_hdr |= misc2->outer_first_mpls_over_udp_exp << HDR_MPLS_OFFSET_EXP;
+	misc2->outer_first_mpls_over_udp_exp = 0;
+	mpls_hdr |= misc2->outer_first_mpls_over_udp_s_bos << HDR_MPLS_OFFSET_S_BOS;
+	misc2->outer_first_mpls_over_udp_s_bos = 0;
+	mpls_hdr |= misc2->outer_first_mpls_over_udp_ttl << HDR_MPLS_OFFSET_TTL;
+	misc2->outer_first_mpls_over_udp_ttl = 0;
+
+	parser_id = sb->caps->flex_parser_id_mpls_over_udp;
+	parser_ptr = dr_ste_calc_flex_parser_offset(tag, parser_id);
+	*(__be32 *)parser_ptr = cpu_to_be32(mpls_hdr);
+
+	return 0;
+}
+
+static void
+dr_ste_v0_build_tnl_mpls_over_udp_init(struct mlx5dr_ste_build *sb,
+				       struct mlx5dr_match_param *mask)
+{
+	dr_ste_v0_build_tnl_mpls_over_udp_tag(mask, sb, sb->bit_mask);
+	/* STEs with lookup type FLEX_PARSER_{0/1} includes
+	 * flex parsers_{0-3}/{4-7} respectively.
+	 */
+	sb->lu_type = sb->caps->flex_parser_id_mpls_over_udp > DR_STE_MAX_FLEX_0_ID ?
+		      DR_STE_V0_LU_TYPE_FLEX_PARSER_1 :
+		      DR_STE_V0_LU_TYPE_FLEX_PARSER_0;
+
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v0_build_tnl_mpls_over_udp_tag;
+}
+
+static int
+dr_ste_v0_build_tnl_mpls_over_gre_tag(struct mlx5dr_match_param *value,
+				      struct mlx5dr_ste_build *sb,
+				      u8 *tag)
+{
+	struct mlx5dr_match_misc2 *misc2 = &value->misc2;
+	u8 *parser_ptr;
+	u8 parser_id;
+	u32 mpls_hdr;
+
+	mpls_hdr = misc2->outer_first_mpls_over_gre_label << HDR_MPLS_OFFSET_LABEL;
+	misc2->outer_first_mpls_over_gre_label = 0;
+	mpls_hdr |= misc2->outer_first_mpls_over_gre_exp << HDR_MPLS_OFFSET_EXP;
+	misc2->outer_first_mpls_over_gre_exp = 0;
+	mpls_hdr |= misc2->outer_first_mpls_over_gre_s_bos << HDR_MPLS_OFFSET_S_BOS;
+	misc2->outer_first_mpls_over_gre_s_bos = 0;
+	mpls_hdr |= misc2->outer_first_mpls_over_gre_ttl << HDR_MPLS_OFFSET_TTL;
+	misc2->outer_first_mpls_over_gre_ttl = 0;
+
+	parser_id = sb->caps->flex_parser_id_mpls_over_gre;
+	parser_ptr = dr_ste_calc_flex_parser_offset(tag, parser_id);
+	*(__be32 *)parser_ptr = cpu_to_be32(mpls_hdr);
+
+	return 0;
+}
+
+static void
+dr_ste_v0_build_tnl_mpls_over_gre_init(struct mlx5dr_ste_build *sb,
+				       struct mlx5dr_match_param *mask)
+{
+	dr_ste_v0_build_tnl_mpls_over_gre_tag(mask, sb, sb->bit_mask);
+
+	/* STEs with lookup type FLEX_PARSER_{0/1} includes
+	 * flex parsers_{0-3}/{4-7} respectively.
+	 */
+	sb->lu_type = sb->caps->flex_parser_id_mpls_over_gre > DR_STE_MAX_FLEX_0_ID ?
+		      DR_STE_V0_LU_TYPE_FLEX_PARSER_1 :
+		      DR_STE_V0_LU_TYPE_FLEX_PARSER_0;
+
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v0_build_tnl_mpls_over_gre_tag;
+}
+
 #define ICMP_TYPE_OFFSET_FIRST_DW	24
 #define ICMP_CODE_OFFSET_FIRST_DW	16
 
@@ -1697,6 +1782,8 @@ struct mlx5dr_ste_ctx ste_ctx_v0 = {
 	.build_mpls_init		= &dr_ste_v0_build_mpls_init,
 	.build_tnl_gre_init		= &dr_ste_v0_build_tnl_gre_init,
 	.build_tnl_mpls_init		= &dr_ste_v0_build_tnl_mpls_init,
+	.build_tnl_mpls_over_udp_init	= &dr_ste_v0_build_tnl_mpls_over_udp_init,
+	.build_tnl_mpls_over_gre_init	= &dr_ste_v0_build_tnl_mpls_over_gre_init,
 	.build_icmp_init		= &dr_ste_v0_build_icmp_init,
 	.build_general_purpose_init	= &dr_ste_v0_build_general_purpose_init,
 	.build_eth_l4_misc_init		= &dr_ste_v0_build_eth_l4_misc_init,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index f15a15da0acb..ad062bfeef2b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -1306,6 +1306,88 @@ static void dr_ste_v1_build_tnl_mpls_init(struct mlx5dr_ste_build *sb,
 	sb->ste_build_tag_func = &dr_ste_v1_build_tnl_mpls_tag;
 }
 
+static int dr_ste_v1_build_tnl_mpls_over_udp_tag(struct mlx5dr_match_param *value,
+						 struct mlx5dr_ste_build *sb,
+						 u8 *tag)
+{
+	struct mlx5dr_match_misc2 *misc2 = &value->misc2;
+	u8 *parser_ptr;
+	u8 parser_id;
+	u32 mpls_hdr;
+
+	mpls_hdr = misc2->outer_first_mpls_over_udp_label << HDR_MPLS_OFFSET_LABEL;
+	misc2->outer_first_mpls_over_udp_label = 0;
+	mpls_hdr |= misc2->outer_first_mpls_over_udp_exp << HDR_MPLS_OFFSET_EXP;
+	misc2->outer_first_mpls_over_udp_exp = 0;
+	mpls_hdr |= misc2->outer_first_mpls_over_udp_s_bos << HDR_MPLS_OFFSET_S_BOS;
+	misc2->outer_first_mpls_over_udp_s_bos = 0;
+	mpls_hdr |= misc2->outer_first_mpls_over_udp_ttl << HDR_MPLS_OFFSET_TTL;
+	misc2->outer_first_mpls_over_udp_ttl = 0;
+
+	parser_id = sb->caps->flex_parser_id_mpls_over_udp;
+	parser_ptr = dr_ste_calc_flex_parser_offset(tag, parser_id);
+	*(__be32 *)parser_ptr = cpu_to_be32(mpls_hdr);
+
+	return 0;
+}
+
+static void dr_ste_v1_build_tnl_mpls_over_udp_init(struct mlx5dr_ste_build *sb,
+						   struct mlx5dr_match_param *mask)
+{
+	dr_ste_v1_build_tnl_mpls_over_udp_tag(mask, sb, sb->bit_mask);
+
+	/* STEs with lookup type FLEX_PARSER_{0/1} includes
+	 * flex parsers_{0-3}/{4-7} respectively.
+	 */
+	sb->lu_type = sb->caps->flex_parser_id_mpls_over_udp > DR_STE_MAX_FLEX_0_ID ?
+		      DR_STE_V1_LU_TYPE_FLEX_PARSER_1 :
+		      DR_STE_V1_LU_TYPE_FLEX_PARSER_0;
+
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v1_build_tnl_mpls_over_udp_tag;
+}
+
+static int dr_ste_v1_build_tnl_mpls_over_gre_tag(struct mlx5dr_match_param *value,
+						 struct mlx5dr_ste_build *sb,
+						 u8 *tag)
+{
+	struct mlx5dr_match_misc2 *misc2 = &value->misc2;
+	u8 *parser_ptr;
+	u8 parser_id;
+	u32 mpls_hdr;
+
+	mpls_hdr = misc2->outer_first_mpls_over_gre_label << HDR_MPLS_OFFSET_LABEL;
+	misc2->outer_first_mpls_over_gre_label = 0;
+	mpls_hdr |= misc2->outer_first_mpls_over_gre_exp << HDR_MPLS_OFFSET_EXP;
+	misc2->outer_first_mpls_over_gre_exp = 0;
+	mpls_hdr |= misc2->outer_first_mpls_over_gre_s_bos << HDR_MPLS_OFFSET_S_BOS;
+	misc2->outer_first_mpls_over_gre_s_bos = 0;
+	mpls_hdr |= misc2->outer_first_mpls_over_gre_ttl << HDR_MPLS_OFFSET_TTL;
+	misc2->outer_first_mpls_over_gre_ttl = 0;
+
+	parser_id = sb->caps->flex_parser_id_mpls_over_gre;
+	parser_ptr = dr_ste_calc_flex_parser_offset(tag, parser_id);
+	*(__be32 *)parser_ptr = cpu_to_be32(mpls_hdr);
+
+	return 0;
+}
+
+static void dr_ste_v1_build_tnl_mpls_over_gre_init(struct mlx5dr_ste_build *sb,
+						   struct mlx5dr_match_param *mask)
+{
+	dr_ste_v1_build_tnl_mpls_over_gre_tag(mask, sb, sb->bit_mask);
+
+	/* STEs with lookup type FLEX_PARSER_{0/1} includes
+	 * flex parsers_{0-3}/{4-7} respectively.
+	 */
+	sb->lu_type = sb->caps->flex_parser_id_mpls_over_gre > DR_STE_MAX_FLEX_0_ID ?
+		      DR_STE_V1_LU_TYPE_FLEX_PARSER_1 :
+		      DR_STE_V1_LU_TYPE_FLEX_PARSER_0;
+
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v1_build_tnl_mpls_over_gre_tag;
+}
+
 static int dr_ste_v1_build_icmp_tag(struct mlx5dr_match_param *value,
 				    struct mlx5dr_ste_build *sb,
 				    u8 *tag)
@@ -1679,6 +1761,8 @@ struct mlx5dr_ste_ctx ste_ctx_v1 = {
 	.build_mpls_init		= &dr_ste_v1_build_mpls_init,
 	.build_tnl_gre_init		= &dr_ste_v1_build_tnl_gre_init,
 	.build_tnl_mpls_init		= &dr_ste_v1_build_tnl_mpls_init,
+	.build_tnl_mpls_over_udp_init	= &dr_ste_v1_build_tnl_mpls_over_udp_init,
+	.build_tnl_mpls_over_gre_init	= &dr_ste_v1_build_tnl_mpls_over_gre_init,
 	.build_icmp_init		= &dr_ste_v1_build_icmp_init,
 	.build_general_purpose_init	= &dr_ste_v1_build_general_purpose_init,
 	.build_eth_l4_misc_init		= &dr_ste_v1_build_eth_l4_misc_init,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 3c07ec61c8be..8eed8ce5a9d9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -393,6 +393,16 @@ void mlx5dr_ste_build_tnl_mpls(struct mlx5dr_ste_ctx *ste_ctx,
 			       struct mlx5dr_ste_build *sb,
 			       struct mlx5dr_match_param *mask,
 			       bool inner, bool rx);
+void mlx5dr_ste_build_tnl_mpls_over_gre(struct mlx5dr_ste_ctx *ste_ctx,
+					struct mlx5dr_ste_build *sb,
+					struct mlx5dr_match_param *mask,
+					struct mlx5dr_cmd_caps *caps,
+					bool inner, bool rx);
+void mlx5dr_ste_build_tnl_mpls_over_udp(struct mlx5dr_ste_ctx *ste_ctx,
+					struct mlx5dr_ste_build *sb,
+					struct mlx5dr_match_param *mask,
+					struct mlx5dr_cmd_caps *caps,
+					bool inner, bool rx);
 void mlx5dr_ste_build_icmp(struct mlx5dr_ste_ctx *ste_ctx,
 			   struct mlx5dr_ste_build *sb,
 			   struct mlx5dr_match_param *mask,
@@ -723,6 +733,8 @@ struct mlx5dr_cmd_caps {
 	u8 flex_parser_id_icmpv6_dw0;
 	u8 flex_parser_id_icmpv6_dw1;
 	u8 flex_parser_id_geneve_tlv_option_0;
+	u8 flex_parser_id_mpls_over_gre;
+	u8 flex_parser_id_mpls_over_udp;
 	u8 max_ft_level;
 	u16 roce_min_src_udp;
 	u8 num_esw_ports;
-- 
2.30.2

