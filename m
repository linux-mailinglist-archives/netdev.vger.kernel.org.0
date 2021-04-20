Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05503650CF
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 05:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234756AbhDTDV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 23:21:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234261AbhDTDVK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 23:21:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A1ED61360;
        Tue, 20 Apr 2021 03:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618888839;
        bh=J4Jyi69DE6KHrsjume2MMvCMpCEhIrycqwMY42QVu+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cEFzptbsHFKgVSqCYxFifBFe4+kSlI4F6VbVCAtXkbvalVuViOgG1L4MYCvYvfvUo
         V39OeXNJkw23AzziX41L4EC6IOIj2u91HhDm6fSKXzuTNS89fpU5P8jnhdiVJCXqiI
         zucn2zlzaSiu3PSJYkl+nj4T68Z9Mo86BjUSgkmaexT+boJ8Qri9l/b1R3iayrS0WL
         s89kn4J5jGWSALErFtpzPAC7x9KSQbxHYxPPUzPtORvLo5GpDwXz1+/rOHTm1aWQLI
         tDaWGCVQ0l9Th9MGgds7K82RM7ik4cpGwknET1KzMf+waGf7DPPP+WofXVfLPrx5+k
         N/U6zFAubPekQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Muhammad Sammar <muhammads@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/15] net/mlx5: DR, Add support for matching tunnel GTP-U
Date:   Mon, 19 Apr 2021 20:20:16 -0700
Message-Id: <20210420032018.58639-14-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210420032018.58639-1-saeed@kernel.org>
References: <20210420032018.58639-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Enable matching on tunnel GTP-U and GTP-U first extension
header using dynamic flex parser.

Signed-off-by: Muhammad Sammar <muhammads@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_cmd.c      |  16 +++
 .../mellanox/mlx5/core/steering/dr_matcher.c  | 118 ++++++++++++++++++
 .../mellanox/mlx5/core/steering/dr_ste.c      |  41 ++++++
 .../mellanox/mlx5/core/steering/dr_ste.h      |  10 ++
 .../mellanox/mlx5/core/steering/dr_ste_v0.c   |  86 +++++++++++++
 .../mellanox/mlx5/core/steering/dr_ste_v1.c   |  81 ++++++++++++
 .../mellanox/mlx5/core/steering/dr_types.h    |  35 +++++-
 .../mellanox/mlx5/core/steering/mlx5_ifc_dr.h |  11 ++
 8 files changed, 397 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
index dfb1e955409e..6f9d7aa9fb4c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -118,6 +118,22 @@ int mlx5dr_cmd_query_device(struct mlx5_core_dev *mdev,
 		caps->flex_parser_id_mpls_over_udp =
 			MLX5_CAP_GEN(mdev, flex_parser_id_outer_first_mpls_over_udp_label);
 
+	if (caps->flex_protocols & MLX5_FLEX_PARSER_GTPU_DW_0_ENABLED)
+		caps->flex_parser_id_gtpu_dw_0 =
+			MLX5_CAP_GEN(mdev, flex_parser_id_gtpu_dw_0);
+
+	if (caps->flex_protocols & MLX5_FLEX_PARSER_GTPU_TEID_ENABLED)
+		caps->flex_parser_id_gtpu_teid =
+			MLX5_CAP_GEN(mdev, flex_parser_id_gtpu_teid);
+
+	if (caps->flex_protocols & MLX5_FLEX_PARSER_GTPU_DW_2_ENABLED)
+		caps->flex_parser_id_gtpu_dw_2 =
+			MLX5_CAP_GEN(mdev, flex_parser_id_gtpu_dw_2);
+
+	if (caps->flex_protocols & MLX5_FLEX_PARSER_GTPU_FIRST_EXT_DW_0_ENABLED)
+		caps->flex_parser_id_gtpu_first_ext_dw_0 =
+			MLX5_CAP_GEN(mdev, flex_parser_id_gtpu_first_ext_dw_0);
+
 	caps->nic_rx_drop_address =
 		MLX5_CAP64_FLOWTABLE(mdev, sw_steering_nic_rx_action_drop_icm_address);
 	caps->nic_tx_drop_address =
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index 531eb69eeea1..6f6191d1d5a6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -155,6 +155,109 @@ dr_mask_is_tnl_geneve(struct mlx5dr_match_param *mask,
 	       dr_matcher_supp_tnl_geneve(&dmn->info.caps);
 }
 
+static bool dr_mask_is_tnl_gtpu_set(struct mlx5dr_match_misc3 *misc3)
+{
+	return misc3->gtpu_msg_flags || misc3->gtpu_msg_type || misc3->gtpu_teid;
+}
+
+static bool dr_matcher_supp_tnl_gtpu(struct mlx5dr_cmd_caps *caps)
+{
+	return caps->flex_protocols & MLX5_FLEX_PARSER_GTPU_ENABLED;
+}
+
+static bool dr_mask_is_tnl_gtpu(struct mlx5dr_match_param *mask,
+				struct mlx5dr_domain *dmn)
+{
+	return dr_mask_is_tnl_gtpu_set(&mask->misc3) &&
+	       dr_matcher_supp_tnl_gtpu(&dmn->info.caps);
+}
+
+static int dr_matcher_supp_tnl_gtpu_dw_0(struct mlx5dr_cmd_caps *caps)
+{
+	return caps->flex_protocols & MLX5_FLEX_PARSER_GTPU_DW_0_ENABLED;
+}
+
+static bool dr_mask_is_tnl_gtpu_dw_0(struct mlx5dr_match_param *mask,
+				     struct mlx5dr_domain *dmn)
+{
+	return mask->misc3.gtpu_dw_0 &&
+	       dr_matcher_supp_tnl_gtpu_dw_0(&dmn->info.caps);
+}
+
+static int dr_matcher_supp_tnl_gtpu_teid(struct mlx5dr_cmd_caps *caps)
+{
+	return caps->flex_protocols & MLX5_FLEX_PARSER_GTPU_TEID_ENABLED;
+}
+
+static bool dr_mask_is_tnl_gtpu_teid(struct mlx5dr_match_param *mask,
+				     struct mlx5dr_domain *dmn)
+{
+	return mask->misc3.gtpu_teid &&
+	       dr_matcher_supp_tnl_gtpu_teid(&dmn->info.caps);
+}
+
+static int dr_matcher_supp_tnl_gtpu_dw_2(struct mlx5dr_cmd_caps *caps)
+{
+	return caps->flex_protocols & MLX5_FLEX_PARSER_GTPU_DW_2_ENABLED;
+}
+
+static bool dr_mask_is_tnl_gtpu_dw_2(struct mlx5dr_match_param *mask,
+				     struct mlx5dr_domain *dmn)
+{
+	return mask->misc3.gtpu_dw_2 &&
+	       dr_matcher_supp_tnl_gtpu_dw_2(&dmn->info.caps);
+}
+
+static int dr_matcher_supp_tnl_gtpu_first_ext(struct mlx5dr_cmd_caps *caps)
+{
+	return caps->flex_protocols & MLX5_FLEX_PARSER_GTPU_FIRST_EXT_DW_0_ENABLED;
+}
+
+static bool dr_mask_is_tnl_gtpu_first_ext(struct mlx5dr_match_param *mask,
+					  struct mlx5dr_domain *dmn)
+{
+	return mask->misc3.gtpu_first_ext_dw_0 &&
+	       dr_matcher_supp_tnl_gtpu_first_ext(&dmn->info.caps);
+}
+
+static bool dr_mask_is_tnl_gtpu_flex_parser_0(struct mlx5dr_match_param *mask,
+					      struct mlx5dr_domain *dmn)
+{
+	struct mlx5dr_cmd_caps *caps = &dmn->info.caps;
+
+	return (dr_is_flex_parser_0_id(caps->flex_parser_id_gtpu_dw_0) &&
+		dr_mask_is_tnl_gtpu_dw_0(mask, dmn)) ||
+	       (dr_is_flex_parser_0_id(caps->flex_parser_id_gtpu_teid) &&
+		dr_mask_is_tnl_gtpu_teid(mask, dmn)) ||
+	       (dr_is_flex_parser_0_id(caps->flex_parser_id_gtpu_dw_2) &&
+		dr_mask_is_tnl_gtpu_dw_2(mask, dmn)) ||
+	       (dr_is_flex_parser_0_id(caps->flex_parser_id_gtpu_first_ext_dw_0) &&
+		dr_mask_is_tnl_gtpu_first_ext(mask, dmn));
+}
+
+static bool dr_mask_is_tnl_gtpu_flex_parser_1(struct mlx5dr_match_param *mask,
+					      struct mlx5dr_domain *dmn)
+{
+	struct mlx5dr_cmd_caps *caps = &dmn->info.caps;
+
+	return (dr_is_flex_parser_1_id(caps->flex_parser_id_gtpu_dw_0) &&
+		dr_mask_is_tnl_gtpu_dw_0(mask, dmn)) ||
+	       (dr_is_flex_parser_1_id(caps->flex_parser_id_gtpu_teid) &&
+		dr_mask_is_tnl_gtpu_teid(mask, dmn)) ||
+	       (dr_is_flex_parser_1_id(caps->flex_parser_id_gtpu_dw_2) &&
+		dr_mask_is_tnl_gtpu_dw_2(mask, dmn)) ||
+	       (dr_is_flex_parser_1_id(caps->flex_parser_id_gtpu_first_ext_dw_0) &&
+		dr_mask_is_tnl_gtpu_first_ext(mask, dmn));
+}
+
+static bool dr_mask_is_tnl_gtpu_any(struct mlx5dr_match_param *mask,
+				    struct mlx5dr_domain *dmn)
+{
+	return dr_mask_is_tnl_gtpu_flex_parser_0(mask, dmn) ||
+	       dr_mask_is_tnl_gtpu_flex_parser_1(mask, dmn) ||
+	       dr_mask_is_tnl_gtpu(mask, dmn);
+}
+
 static int dr_matcher_supp_icmp_v4(struct mlx5dr_cmd_caps *caps)
 {
 	return (caps->sw_format_ver == MLX5_STEERING_FORMAT_CONNECTX_6DX) ||
@@ -397,7 +500,22 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 				mlx5dr_ste_build_tnl_geneve_tlv_opt(ste_ctx, &sb[idx++],
 								    &mask, &dmn->info.caps,
 								    inner, rx);
+		} else if (dr_mask_is_tnl_gtpu_any(&mask, dmn)) {
+			if (dr_mask_is_tnl_gtpu_flex_parser_0(&mask, dmn))
+				mlx5dr_ste_build_tnl_gtpu_flex_parser_0(ste_ctx, &sb[idx++],
+									&mask, &dmn->info.caps,
+									inner, rx);
+
+			if (dr_mask_is_tnl_gtpu_flex_parser_1(&mask, dmn))
+				mlx5dr_ste_build_tnl_gtpu_flex_parser_1(ste_ctx, &sb[idx++],
+									&mask, &dmn->info.caps,
+									inner, rx);
+
+			if (dr_mask_is_tnl_gtpu(&mask, dmn))
+				mlx5dr_ste_build_tnl_gtpu(ste_ctx, &sb[idx++],
+							  &mask, inner, rx);
 		}
+
 		if (DR_MASK_IS_ETH_L4_MISC_SET(mask.misc3, outer))
 			mlx5dr_ste_build_eth_l4_misc(ste_ctx, &sb[idx++],
 						     &mask, inner, rx);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 6ae839b1ec8a..9b1529137cba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -854,6 +854,13 @@ static void dr_ste_copy_mask_misc3(char *mask, struct mlx5dr_match_misc3 *spec)
 	spec->icmpv6_code = MLX5_GET(fte_match_set_misc3, mask, icmpv6_code);
 	spec->geneve_tlv_option_0_data =
 		MLX5_GET(fte_match_set_misc3, mask, geneve_tlv_option_0_data);
+	spec->gtpu_msg_flags = MLX5_GET(fte_match_set_misc3, mask, gtpu_msg_flags);
+	spec->gtpu_msg_type = MLX5_GET(fte_match_set_misc3, mask, gtpu_msg_type);
+	spec->gtpu_teid = MLX5_GET(fte_match_set_misc3, mask, gtpu_teid);
+	spec->gtpu_dw_0 = MLX5_GET(fte_match_set_misc3, mask, gtpu_dw_0);
+	spec->gtpu_dw_2 = MLX5_GET(fte_match_set_misc3, mask, gtpu_dw_2);
+	spec->gtpu_first_ext_dw_0 =
+		MLX5_GET(fte_match_set_misc3, mask, gtpu_first_ext_dw_0);
 }
 
 static void dr_ste_copy_mask_misc4(char *mask, struct mlx5dr_match_misc4 *spec)
@@ -1175,6 +1182,40 @@ void mlx5dr_ste_build_tnl_geneve_tlv_opt(struct mlx5dr_ste_ctx *ste_ctx,
 	ste_ctx->build_tnl_geneve_tlv_opt_init(sb, mask);
 }
 
+void mlx5dr_ste_build_tnl_gtpu(struct mlx5dr_ste_ctx *ste_ctx,
+			       struct mlx5dr_ste_build *sb,
+			       struct mlx5dr_match_param *mask,
+			       bool inner, bool rx)
+{
+	sb->rx = rx;
+	sb->inner = inner;
+	ste_ctx->build_tnl_gtpu_init(sb, mask);
+}
+
+void mlx5dr_ste_build_tnl_gtpu_flex_parser_0(struct mlx5dr_ste_ctx *ste_ctx,
+					     struct mlx5dr_ste_build *sb,
+					     struct mlx5dr_match_param *mask,
+					     struct mlx5dr_cmd_caps *caps,
+					     bool inner, bool rx)
+{
+	sb->rx = rx;
+	sb->caps = caps;
+	sb->inner = inner;
+	ste_ctx->build_tnl_gtpu_flex_parser_0_init(sb, mask);
+}
+
+void mlx5dr_ste_build_tnl_gtpu_flex_parser_1(struct mlx5dr_ste_ctx *ste_ctx,
+					     struct mlx5dr_ste_build *sb,
+					     struct mlx5dr_match_param *mask,
+					     struct mlx5dr_cmd_caps *caps,
+					     bool inner, bool rx)
+{
+	sb->rx = rx;
+	sb->caps = caps;
+	sb->inner = inner;
+	ste_ctx->build_tnl_gtpu_flex_parser_1_init(sb, mask);
+}
+
 void mlx5dr_ste_build_register_0(struct mlx5dr_ste_ctx *ste_ctx,
 				 struct mlx5dr_ste_build *sb,
 				 struct mlx5dr_match_param *mask,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
index 2d2dc680ad13..992b591bf0c5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
@@ -62,6 +62,13 @@
 		       in_out##_first_mpls_ttl); \
 } while (0)
 
+#define DR_STE_SET_FLEX_PARSER_FIELD(tag, fname, caps, spec) do { \
+	u8 parser_id = (caps)->flex_parser_id_##fname; \
+	u8 *parser_ptr = dr_ste_calc_flex_parser_offset(tag, parser_id); \
+	*(__be32 *)parser_ptr = cpu_to_be32((spec)->fname);\
+	(spec)->fname = 0;\
+} while (0)
+
 #define DR_STE_IS_OUTER_MPLS_OVER_GRE_SET(_misc) (\
 	(_misc)->outer_first_mpls_over_gre_label || \
 	(_misc)->outer_first_mpls_over_gre_exp || \
@@ -133,6 +140,9 @@ struct mlx5dr_ste_ctx {
 	void DR_STE_CTX_BUILDER(src_gvmi_qpn);
 	void DR_STE_CTX_BUILDER(flex_parser_0);
 	void DR_STE_CTX_BUILDER(flex_parser_1);
+	void DR_STE_CTX_BUILDER(tnl_gtpu);
+	void DR_STE_CTX_BUILDER(tnl_gtpu_flex_parser_0);
+	void DR_STE_CTX_BUILDER(tnl_gtpu_flex_parser_1);
 
 	/* Getters and Setters */
 	void (*ste_init)(u8 *hw_ste_p, u16 lu_type,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
index c62f64d48213..0757a4e8540e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
@@ -1768,6 +1768,89 @@ dr_ste_v0_build_flex_parser_tnl_geneve_tlv_opt_init(struct mlx5dr_ste_build *sb,
 	sb->ste_build_tag_func = &dr_ste_v0_build_flex_parser_tnl_geneve_tlv_opt_tag;
 }
 
+static int dr_ste_v0_build_flex_parser_tnl_gtpu_tag(struct mlx5dr_match_param *value,
+						    struct mlx5dr_ste_build *sb,
+						    uint8_t *tag)
+{
+	struct mlx5dr_match_misc3 *misc3 = &value->misc3;
+
+	DR_STE_SET_TAG(flex_parser_tnl_gtpu, tag,
+		       gtpu_msg_flags, misc3,
+		       gtpu_msg_flags);
+	DR_STE_SET_TAG(flex_parser_tnl_gtpu, tag,
+		       gtpu_msg_type, misc3,
+		       gtpu_msg_type);
+	DR_STE_SET_TAG(flex_parser_tnl_gtpu, tag,
+		       gtpu_teid, misc3,
+		       gtpu_teid);
+
+	return 0;
+}
+
+static void dr_ste_v0_build_flex_parser_tnl_gtpu_init(struct mlx5dr_ste_build *sb,
+						      struct mlx5dr_match_param *mask)
+{
+	dr_ste_v0_build_flex_parser_tnl_gtpu_tag(mask, sb, sb->bit_mask);
+
+	sb->lu_type = DR_STE_V0_LU_TYPE_FLEX_PARSER_TNL_HEADER;
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v0_build_flex_parser_tnl_gtpu_tag;
+}
+
+static int
+dr_ste_v0_build_tnl_gtpu_flex_parser_0_tag(struct mlx5dr_match_param *value,
+					   struct mlx5dr_ste_build *sb,
+					   uint8_t *tag)
+{
+	if (dr_is_flex_parser_0_id(sb->caps->flex_parser_id_gtpu_dw_0))
+		DR_STE_SET_FLEX_PARSER_FIELD(tag, gtpu_dw_0, sb->caps, &value->misc3);
+	if (dr_is_flex_parser_0_id(sb->caps->flex_parser_id_gtpu_teid))
+		DR_STE_SET_FLEX_PARSER_FIELD(tag, gtpu_teid, sb->caps, &value->misc3);
+	if (dr_is_flex_parser_0_id(sb->caps->flex_parser_id_gtpu_dw_2))
+		DR_STE_SET_FLEX_PARSER_FIELD(tag, gtpu_dw_2, sb->caps, &value->misc3);
+	if (dr_is_flex_parser_0_id(sb->caps->flex_parser_id_gtpu_first_ext_dw_0))
+		DR_STE_SET_FLEX_PARSER_FIELD(tag, gtpu_first_ext_dw_0, sb->caps, &value->misc3);
+	return 0;
+}
+
+static void
+dr_ste_v0_build_tnl_gtpu_flex_parser_0_init(struct mlx5dr_ste_build *sb,
+					    struct mlx5dr_match_param *mask)
+{
+	dr_ste_v0_build_tnl_gtpu_flex_parser_0_tag(mask, sb, sb->bit_mask);
+
+	sb->lu_type = DR_STE_V0_LU_TYPE_FLEX_PARSER_0;
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v0_build_tnl_gtpu_flex_parser_0_tag;
+}
+
+static int
+dr_ste_v0_build_tnl_gtpu_flex_parser_1_tag(struct mlx5dr_match_param *value,
+					   struct mlx5dr_ste_build *sb,
+					   uint8_t *tag)
+{
+	if (dr_is_flex_parser_1_id(sb->caps->flex_parser_id_gtpu_dw_0))
+		DR_STE_SET_FLEX_PARSER_FIELD(tag, gtpu_dw_0, sb->caps, &value->misc3);
+	if (dr_is_flex_parser_1_id(sb->caps->flex_parser_id_gtpu_teid))
+		DR_STE_SET_FLEX_PARSER_FIELD(tag, gtpu_teid, sb->caps, &value->misc3);
+	if (dr_is_flex_parser_1_id(sb->caps->flex_parser_id_gtpu_dw_2))
+		DR_STE_SET_FLEX_PARSER_FIELD(tag, gtpu_dw_2, sb->caps, &value->misc3);
+	if (dr_is_flex_parser_1_id(sb->caps->flex_parser_id_gtpu_first_ext_dw_0))
+		DR_STE_SET_FLEX_PARSER_FIELD(tag, gtpu_first_ext_dw_0, sb->caps, &value->misc3);
+	return 0;
+}
+
+static void
+dr_ste_v0_build_tnl_gtpu_flex_parser_1_init(struct mlx5dr_ste_build *sb,
+					    struct mlx5dr_match_param *mask)
+{
+	dr_ste_v0_build_tnl_gtpu_flex_parser_1_tag(mask, sb, sb->bit_mask);
+
+	sb->lu_type = DR_STE_V0_LU_TYPE_FLEX_PARSER_1;
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v0_build_tnl_gtpu_flex_parser_1_tag;
+}
+
 struct mlx5dr_ste_ctx ste_ctx_v0 = {
 	/* Builders */
 	.build_eth_l2_src_dst_init	= &dr_ste_v0_build_eth_l2_src_dst_init,
@@ -1795,6 +1878,9 @@ struct mlx5dr_ste_ctx ste_ctx_v0 = {
 	.build_src_gvmi_qpn_init	= &dr_ste_v0_build_src_gvmi_qpn_init,
 	.build_flex_parser_0_init	= &dr_ste_v0_build_flex_parser_0_init,
 	.build_flex_parser_1_init	= &dr_ste_v0_build_flex_parser_1_init,
+	.build_tnl_gtpu_init		= &dr_ste_v0_build_flex_parser_tnl_gtpu_init,
+	.build_tnl_gtpu_flex_parser_0_init   = &dr_ste_v0_build_tnl_gtpu_flex_parser_0_init,
+	.build_tnl_gtpu_flex_parser_1_init   = &dr_ste_v0_build_tnl_gtpu_flex_parser_1_init,
 
 	/* Getters and Setters */
 	.ste_init			= &dr_ste_v0_init,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index ad062bfeef2b..054c2e2b6554 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -1747,6 +1747,83 @@ dr_ste_v1_build_flex_parser_tnl_geneve_tlv_opt_init(struct mlx5dr_ste_build *sb,
 	sb->ste_build_tag_func = &dr_ste_v1_build_flex_parser_tnl_geneve_tlv_opt_tag;
 }
 
+static int dr_ste_v1_build_flex_parser_tnl_gtpu_tag(struct mlx5dr_match_param *value,
+						    struct mlx5dr_ste_build *sb,
+						    uint8_t *tag)
+{
+	struct mlx5dr_match_misc3 *misc3 = &value->misc3;
+
+	DR_STE_SET_TAG(flex_parser_tnl_gtpu, tag, gtpu_msg_flags, misc3, gtpu_msg_flags);
+	DR_STE_SET_TAG(flex_parser_tnl_gtpu, tag, gtpu_msg_type, misc3, gtpu_msg_type);
+	DR_STE_SET_TAG(flex_parser_tnl_gtpu, tag, gtpu_teid, misc3, gtpu_teid);
+
+	return 0;
+}
+
+static void dr_ste_v1_build_flex_parser_tnl_gtpu_init(struct mlx5dr_ste_build *sb,
+						      struct mlx5dr_match_param *mask)
+{
+	dr_ste_v1_build_flex_parser_tnl_gtpu_tag(mask, sb, sb->bit_mask);
+
+	sb->lu_type = DR_STE_V1_LU_TYPE_FLEX_PARSER_TNL_HEADER;
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v1_build_flex_parser_tnl_gtpu_tag;
+}
+
+static int
+dr_ste_v1_build_tnl_gtpu_flex_parser_0_tag(struct mlx5dr_match_param *value,
+					   struct mlx5dr_ste_build *sb,
+					   uint8_t *tag)
+{
+	if (dr_is_flex_parser_0_id(sb->caps->flex_parser_id_gtpu_dw_0))
+		DR_STE_SET_FLEX_PARSER_FIELD(tag, gtpu_dw_0, sb->caps, &value->misc3);
+	if (dr_is_flex_parser_0_id(sb->caps->flex_parser_id_gtpu_teid))
+		DR_STE_SET_FLEX_PARSER_FIELD(tag, gtpu_teid, sb->caps, &value->misc3);
+	if (dr_is_flex_parser_0_id(sb->caps->flex_parser_id_gtpu_dw_2))
+		DR_STE_SET_FLEX_PARSER_FIELD(tag, gtpu_dw_2, sb->caps, &value->misc3);
+	if (dr_is_flex_parser_0_id(sb->caps->flex_parser_id_gtpu_first_ext_dw_0))
+		DR_STE_SET_FLEX_PARSER_FIELD(tag, gtpu_first_ext_dw_0, sb->caps, &value->misc3);
+	return 0;
+}
+
+static void
+dr_ste_v1_build_tnl_gtpu_flex_parser_0_init(struct mlx5dr_ste_build *sb,
+					    struct mlx5dr_match_param *mask)
+{
+	dr_ste_v1_build_tnl_gtpu_flex_parser_0_tag(mask, sb, sb->bit_mask);
+
+	sb->lu_type = DR_STE_V1_LU_TYPE_FLEX_PARSER_0;
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v1_build_tnl_gtpu_flex_parser_0_tag;
+}
+
+static int
+dr_ste_v1_build_tnl_gtpu_flex_parser_1_tag(struct mlx5dr_match_param *value,
+					   struct mlx5dr_ste_build *sb,
+					   uint8_t *tag)
+{
+	if (dr_is_flex_parser_1_id(sb->caps->flex_parser_id_gtpu_dw_0))
+		DR_STE_SET_FLEX_PARSER_FIELD(tag, gtpu_dw_0, sb->caps, &value->misc3);
+	if (dr_is_flex_parser_1_id(sb->caps->flex_parser_id_gtpu_teid))
+		DR_STE_SET_FLEX_PARSER_FIELD(tag, gtpu_teid, sb->caps, &value->misc3);
+	if (dr_is_flex_parser_1_id(sb->caps->flex_parser_id_gtpu_dw_2))
+		DR_STE_SET_FLEX_PARSER_FIELD(tag, gtpu_dw_2, sb->caps, &value->misc3);
+	if (dr_is_flex_parser_1_id(sb->caps->flex_parser_id_gtpu_first_ext_dw_0))
+		DR_STE_SET_FLEX_PARSER_FIELD(tag, gtpu_first_ext_dw_0, sb->caps, &value->misc3);
+	return 0;
+}
+
+static void
+dr_ste_v1_build_tnl_gtpu_flex_parser_1_init(struct mlx5dr_ste_build *sb,
+					    struct mlx5dr_match_param *mask)
+{
+	dr_ste_v1_build_tnl_gtpu_flex_parser_1_tag(mask, sb, sb->bit_mask);
+
+	sb->lu_type = DR_STE_V1_LU_TYPE_FLEX_PARSER_1;
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v1_build_tnl_gtpu_flex_parser_1_tag;
+}
+
 struct mlx5dr_ste_ctx ste_ctx_v1 = {
 	/* Builders */
 	.build_eth_l2_src_dst_init	= &dr_ste_v1_build_eth_l2_src_dst_init,
@@ -1774,6 +1851,10 @@ struct mlx5dr_ste_ctx ste_ctx_v1 = {
 	.build_src_gvmi_qpn_init	= &dr_ste_v1_build_src_gvmi_qpn_init,
 	.build_flex_parser_0_init	= &dr_ste_v1_build_flex_parser_0_init,
 	.build_flex_parser_1_init	= &dr_ste_v1_build_flex_parser_1_init,
+	.build_tnl_gtpu_init		= &dr_ste_v1_build_flex_parser_tnl_gtpu_init,
+	.build_tnl_gtpu_flex_parser_0_init = &dr_ste_v1_build_tnl_gtpu_flex_parser_0_init,
+	.build_tnl_gtpu_flex_parser_1_init = &dr_ste_v1_build_tnl_gtpu_flex_parser_1_init,
+
 	/* Getters and Setters */
 	.ste_init			= &dr_ste_v1_init,
 	.set_next_lu_type		= &dr_ste_v1_set_next_lu_type,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 8eed8ce5a9d9..7c1ab0b6417e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -26,6 +26,16 @@
 #define mlx5dr_info(dmn, arg...) mlx5_core_info((dmn)->mdev, ##arg)
 #define mlx5dr_dbg(dmn, arg...) mlx5_core_dbg((dmn)->mdev, ##arg)
 
+static inline bool dr_is_flex_parser_0_id(u8 parser_id)
+{
+	return parser_id <= DR_STE_MAX_FLEX_0_ID;
+}
+
+static inline bool dr_is_flex_parser_1_id(u8 parser_id)
+{
+	return parser_id > DR_STE_MAX_FLEX_0_ID;
+}
+
 enum mlx5dr_icm_chunk_size {
 	DR_CHUNK_SIZE_1,
 	DR_CHUNK_SIZE_MIN = DR_CHUNK_SIZE_1, /* keep updated when changing */
@@ -421,6 +431,20 @@ void mlx5dr_ste_build_tnl_geneve_tlv_opt(struct mlx5dr_ste_ctx *ste_ctx,
 					 struct mlx5dr_match_param *mask,
 					 struct mlx5dr_cmd_caps *caps,
 					 bool inner, bool rx);
+void mlx5dr_ste_build_tnl_gtpu(struct mlx5dr_ste_ctx *ste_ctx,
+			       struct mlx5dr_ste_build *sb,
+			       struct mlx5dr_match_param *mask,
+			       bool inner, bool rx);
+void mlx5dr_ste_build_tnl_gtpu_flex_parser_0(struct mlx5dr_ste_ctx *ste_ctx,
+					     struct mlx5dr_ste_build *sb,
+					     struct mlx5dr_match_param *mask,
+					     struct mlx5dr_cmd_caps *caps,
+					     bool inner, bool rx);
+void mlx5dr_ste_build_tnl_gtpu_flex_parser_1(struct mlx5dr_ste_ctx *ste_ctx,
+					     struct mlx5dr_ste_build *sb,
+					     struct mlx5dr_match_param *mask,
+					     struct mlx5dr_cmd_caps *caps,
+					     bool inner, bool rx);
 void mlx5dr_ste_build_general_purpose(struct mlx5dr_ste_ctx *ste_ctx,
 				      struct mlx5dr_ste_build *sb,
 				      struct mlx5dr_match_param *mask,
@@ -674,7 +698,12 @@ struct mlx5dr_match_misc3 {
 	u8 icmpv4_code;
 	u8 icmpv4_type;
 	u32 geneve_tlv_option_0_data;
-	u8 reserved_auto3[0x18];
+	u8 gtpu_msg_flags;
+	u8 gtpu_msg_type;
+	u32 gtpu_teid;
+	u32 gtpu_dw_2;
+	u32 gtpu_first_ext_dw_0;
+	u32 gtpu_dw_0;
 };
 
 struct mlx5dr_match_misc4 {
@@ -735,6 +764,10 @@ struct mlx5dr_cmd_caps {
 	u8 flex_parser_id_geneve_tlv_option_0;
 	u8 flex_parser_id_mpls_over_gre;
 	u8 flex_parser_id_mpls_over_udp;
+	u8 flex_parser_id_gtpu_dw_0;
+	u8 flex_parser_id_gtpu_teid;
+	u8 flex_parser_id_gtpu_dw_2;
+	u8 flex_parser_id_gtpu_first_ext_dw_0;
 	u8 max_ft_level;
 	u16 roce_min_src_udp;
 	u8 num_esw_ports;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h
index 601bbb3a107c..9643ee647f57 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h
@@ -485,6 +485,17 @@ struct mlx5_ifc_ste_flex_parser_tnl_geneve_bits {
 	u8         reserved_at_40[0x40];
 };
 
+struct mlx5_ifc_ste_flex_parser_tnl_gtpu_bits {
+	u8	   reserved_at_0[0x5];
+	u8	   gtpu_msg_flags[0x3];
+	u8	   gtpu_msg_type[0x8];
+	u8	   reserved_at_10[0x10];
+
+	u8	   gtpu_teid[0x20];
+
+	u8	   reserved_at_40[0x40];
+};
+
 struct mlx5_ifc_ste_general_purpose_bits {
 	u8         general_purpose_lookup_field[0x20];
 
-- 
2.30.2

