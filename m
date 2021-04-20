Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02D63650CB
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 05:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234613AbhDTDVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 23:21:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:40548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233990AbhDTDVI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 23:21:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67A5C613AE;
        Tue, 20 Apr 2021 03:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618888837;
        bh=79GNmOE5CXa0iXlnKLaA/7ILpnHyJMsW5TDWjUC2zBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TKXwUVtVWJAfKa+hKP/byzLEO0/qRJlthyR9z2Gh4SI3E1bqxzS4gbZRA7xefZ/kP
         LEWVeZ0ORfXBOxCHExnvIsjmBu6ovyTyqiymhso9KnT9lvZKm0iazJb86XCIAJvsfX
         1jo9Rs64hHRJEnx+SeLtaKtaZ/F3jpsl9nLN/urUZyGAO2L4M7SsSLEVOcty93lfIg
         0UygRX8zhwyWpcgRBVHgivk1xwvS2NWaLTB0WoQAf4zp1aacu+Mkj30wFiWMr2Dnxi
         0HSnINxMVvmviYG4YKuiJcP/JiV+IzmZ8pnnuyb/5fDlDGkpicOOVJTn+IgT7J4BYb
         OyfCgNBngnEOQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Muhammad Sammar <muhammads@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/15] net/mlx5: DR, Add support for dynamic flex parser
Date:   Mon, 19 Apr 2021 20:20:12 -0700
Message-Id: <20210420032018.58639-10-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210420032018.58639-1-saeed@kernel.org>
References: <20210420032018.58639-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Flex parser is a HW parser that can support protocols that are not
natively supported by the HCA, such as Geneve (TLV options) and GTP-U.
There are 8 such parsers, and each of them can be assigned to parse a
specific set of protocols.
This patch adds misc4 match params which allows using a correct flex parser
that was programmed to the required protocol.

Signed-off-by: Muhammad Sammar <muhammads@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_matcher.c  | 50 ++++++++++++++
 .../mellanox/mlx5/core/steering/dr_rule.c     | 11 ++++
 .../mellanox/mlx5/core/steering/dr_ste.c      | 54 +++++++++++++++
 .../mellanox/mlx5/core/steering/dr_ste.h      |  9 +++
 .../mellanox/mlx5/core/steering/dr_ste_v0.c   | 65 +++++++++++++++++++
 .../mellanox/mlx5/core/steering/dr_ste_v1.c   | 65 +++++++++++++++++++
 .../mellanox/mlx5/core/steering/dr_types.h    | 26 +++++++-
 7 files changed, 279 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index 15673cd10039..3a7576125404 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -199,6 +199,42 @@ static bool dr_mask_is_gvmi_or_qpn_set(struct mlx5dr_match_misc *misc)
 	return (misc->source_sqn || misc->source_port);
 }
 
+static bool dr_mask_is_flex_parser_id_0_3_set(u32 flex_parser_id,
+					      u32 flex_parser_value)
+{
+	if (flex_parser_id)
+		return flex_parser_id <= DR_STE_MAX_FLEX_0_ID;
+
+	/* Using flex_parser 0 means that id is zero, thus value must be set. */
+	return flex_parser_value;
+}
+
+static bool dr_mask_is_flex_parser_0_3_set(struct mlx5dr_match_misc4 *misc4)
+{
+	return (dr_mask_is_flex_parser_id_0_3_set(misc4->prog_sample_field_id_0,
+						  misc4->prog_sample_field_value_0) ||
+		dr_mask_is_flex_parser_id_0_3_set(misc4->prog_sample_field_id_1,
+						  misc4->prog_sample_field_value_1) ||
+		dr_mask_is_flex_parser_id_0_3_set(misc4->prog_sample_field_id_2,
+						  misc4->prog_sample_field_value_2) ||
+		dr_mask_is_flex_parser_id_0_3_set(misc4->prog_sample_field_id_3,
+						  misc4->prog_sample_field_value_3));
+}
+
+static bool dr_mask_is_flex_parser_id_4_7_set(u32 flex_parser_id)
+{
+	return flex_parser_id > DR_STE_MAX_FLEX_0_ID &&
+	       flex_parser_id <= DR_STE_MAX_FLEX_1_ID;
+}
+
+static bool dr_mask_is_flex_parser_4_7_set(struct mlx5dr_match_misc4 *misc4)
+{
+	return (dr_mask_is_flex_parser_id_4_7_set(misc4->prog_sample_field_id_0) ||
+		dr_mask_is_flex_parser_id_4_7_set(misc4->prog_sample_field_id_1) ||
+		dr_mask_is_flex_parser_id_4_7_set(misc4->prog_sample_field_id_2) ||
+		dr_mask_is_flex_parser_id_4_7_set(misc4->prog_sample_field_id_3));
+}
+
 int mlx5dr_matcher_select_builders(struct mlx5dr_matcher *matcher,
 				   struct mlx5dr_matcher_rx_tx *nic_matcher,
 				   enum mlx5dr_ipv outer_ipv,
@@ -251,6 +287,9 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 	if (matcher->match_criteria & DR_MATCHER_CRITERIA_MISC3)
 		mask.misc3 = matcher->mask.misc3;
 
+	if (matcher->match_criteria & DR_MATCHER_CRITERIA_MISC4)
+		mask.misc4 = matcher->mask.misc4;
+
 	ret = mlx5dr_ste_build_pre_check(dmn, matcher->match_criteria,
 					 &matcher->mask, NULL);
 	if (ret)
@@ -408,6 +447,17 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 			mlx5dr_ste_build_tnl_mpls(ste_ctx, &sb[idx++],
 						  &mask, inner, rx);
 	}
+
+	if (matcher->match_criteria & DR_MATCHER_CRITERIA_MISC4) {
+		if (dr_mask_is_flex_parser_0_3_set(&mask.misc4))
+			mlx5dr_ste_build_flex_parser_0(ste_ctx, &sb[idx++],
+						       &mask, false, rx);
+
+		if (dr_mask_is_flex_parser_4_7_set(&mask.misc4))
+			mlx5dr_ste_build_flex_parser_1(ste_ctx, &sb[idx++],
+						       &mask, false, rx);
+	}
+
 	/* Empty matcher, takes all */
 	if (matcher->match_criteria == DR_MATCHER_CRITERIA_EMPTY)
 		mlx5dr_ste_build_empty_always_hit(&sb[idx++], rx);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index b337d6626bff..43356fad53de 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -952,6 +952,17 @@ static bool dr_rule_verify(struct mlx5dr_matcher *matcher,
 			return false;
 		}
 	}
+
+	if (match_criteria & DR_MATCHER_CRITERIA_MISC4) {
+		s_idx = offsetof(struct mlx5dr_match_param, misc4);
+		e_idx = min(s_idx + sizeof(param->misc4), value_size);
+
+		if (!dr_rule_cmp_value_to_mask(mask_p, param_p, s_idx, e_idx)) {
+			mlx5dr_err(matcher->tbl->dmn,
+				   "Rule misc4 parameters contains a value not specified by mask\n");
+			return false;
+		}
+	}
 	return true;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index f49abc7a4b9b..445481f01a46 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -854,6 +854,26 @@ static void dr_ste_copy_mask_misc3(char *mask, struct mlx5dr_match_misc3 *spec)
 	spec->icmpv6_code = MLX5_GET(fte_match_set_misc3, mask, icmpv6_code);
 }
 
+static void dr_ste_copy_mask_misc4(char *mask, struct mlx5dr_match_misc4 *spec)
+{
+	spec->prog_sample_field_id_0 =
+		MLX5_GET(fte_match_set_misc4, mask, prog_sample_field_id_0);
+	spec->prog_sample_field_value_0 =
+		MLX5_GET(fte_match_set_misc4, mask, prog_sample_field_value_0);
+	spec->prog_sample_field_id_1 =
+		MLX5_GET(fte_match_set_misc4, mask, prog_sample_field_id_1);
+	spec->prog_sample_field_value_1 =
+		MLX5_GET(fte_match_set_misc4, mask, prog_sample_field_value_1);
+	spec->prog_sample_field_id_2 =
+		MLX5_GET(fte_match_set_misc4, mask, prog_sample_field_id_2);
+	spec->prog_sample_field_value_2 =
+		MLX5_GET(fte_match_set_misc4, mask, prog_sample_field_value_2);
+	spec->prog_sample_field_id_3 =
+		MLX5_GET(fte_match_set_misc4, mask, prog_sample_field_id_3);
+	spec->prog_sample_field_value_3 =
+		MLX5_GET(fte_match_set_misc4, mask, prog_sample_field_value_3);
+}
+
 void mlx5dr_ste_copy_param(u8 match_criteria,
 			   struct mlx5dr_match_param *set_param,
 			   struct mlx5dr_match_parameters *mask)
@@ -925,6 +945,20 @@ void mlx5dr_ste_copy_param(u8 match_criteria,
 		}
 		dr_ste_copy_mask_misc3(buff, &set_param->misc3);
 	}
+
+	param_location += sizeof(struct mlx5dr_match_misc3);
+
+	if (match_criteria & DR_MATCHER_CRITERIA_MISC4) {
+		if (mask->match_sz < param_location +
+		    sizeof(struct mlx5dr_match_misc4)) {
+			memcpy(tail_param, data + param_location,
+			       mask->match_sz - param_location);
+			buff = tail_param;
+		} else {
+			buff = data + param_location;
+		}
+		dr_ste_copy_mask_misc4(buff, &set_param->misc4);
+	}
 }
 
 void mlx5dr_ste_build_eth_l2_src_dst(struct mlx5dr_ste_ctx *ste_ctx,
@@ -1148,6 +1182,26 @@ void mlx5dr_ste_build_src_gvmi_qpn(struct mlx5dr_ste_ctx *ste_ctx,
 	ste_ctx->build_src_gvmi_qpn_init(sb, mask);
 }
 
+void mlx5dr_ste_build_flex_parser_0(struct mlx5dr_ste_ctx *ste_ctx,
+				    struct mlx5dr_ste_build *sb,
+				    struct mlx5dr_match_param *mask,
+				    bool inner, bool rx)
+{
+	sb->rx = rx;
+	sb->inner = inner;
+	ste_ctx->build_flex_parser_0_init(sb, mask);
+}
+
+void mlx5dr_ste_build_flex_parser_1(struct mlx5dr_ste_ctx *ste_ctx,
+				    struct mlx5dr_ste_build *sb,
+				    struct mlx5dr_match_param *mask,
+				    bool inner, bool rx)
+{
+	sb->rx = rx;
+	sb->inner = inner;
+	ste_ctx->build_flex_parser_1_init(sb, mask);
+}
+
 static struct mlx5dr_ste_ctx *mlx5dr_ste_ctx_arr[] = {
 	[MLX5_STEERING_FORMAT_CONNECTX_5] = &ste_ctx_v0,
 	[MLX5_STEERING_FORMAT_CONNECTX_6DX] = &ste_ctx_v1,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
index eb0384150675..5900f177d865 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
@@ -95,6 +95,13 @@ enum {
 
 u16 mlx5dr_ste_conv_bit_to_byte_mask(u8 *bit_mask);
 
+static inline u8 *
+dr_ste_calc_flex_parser_offset(u8 *tag, u8 parser_id)
+{
+	/* Calculate tag byte offset based on flex parser id */
+	return tag + 4 * (3 - (parser_id % 4));
+}
+
 #define DR_STE_CTX_BUILDER(fname) \
 	((*build_##fname##_init)(struct mlx5dr_ste_build *sb, \
 				 struct mlx5dr_match_param *mask))
@@ -121,6 +128,8 @@ struct mlx5dr_ste_ctx {
 	void DR_STE_CTX_BUILDER(register_0);
 	void DR_STE_CTX_BUILDER(register_1);
 	void DR_STE_CTX_BUILDER(src_gvmi_qpn);
+	void DR_STE_CTX_BUILDER(flex_parser_0);
+	void DR_STE_CTX_BUILDER(flex_parser_1);
 
 	/* Getters and Setters */
 	void (*ste_init)(u8 *hw_ste_p, u16 lu_type,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
index d9ac57d94609..db19d99366ba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
@@ -1592,6 +1592,69 @@ dr_ste_v0_build_src_gvmi_qpn_init(struct mlx5dr_ste_build *sb,
 	sb->ste_build_tag_func = &dr_ste_v0_build_src_gvmi_qpn_tag;
 }
 
+static void dr_ste_v0_set_flex_parser(u32 *misc4_field_id,
+				      u32 *misc4_field_value,
+				      bool *parser_is_used,
+				      u8 *tag)
+{
+	u32 id = *misc4_field_id;
+	u8 *parser_ptr;
+
+	if (parser_is_used[id])
+		return;
+
+	parser_is_used[id] = true;
+	parser_ptr = dr_ste_calc_flex_parser_offset(tag, id);
+
+	*(__be32 *)parser_ptr = cpu_to_be32(*misc4_field_value);
+	*misc4_field_id = 0;
+	*misc4_field_value = 0;
+}
+
+static int dr_ste_v0_build_flex_parser_tag(struct mlx5dr_match_param *value,
+					   struct mlx5dr_ste_build *sb,
+					   u8 *tag)
+{
+	struct mlx5dr_match_misc4 *misc_4_mask = &value->misc4;
+	bool parser_is_used[DR_NUM_OF_FLEX_PARSERS] = {};
+
+	dr_ste_v0_set_flex_parser(&misc_4_mask->prog_sample_field_id_0,
+				  &misc_4_mask->prog_sample_field_value_0,
+				  parser_is_used, tag);
+
+	dr_ste_v0_set_flex_parser(&misc_4_mask->prog_sample_field_id_1,
+				  &misc_4_mask->prog_sample_field_value_1,
+				  parser_is_used, tag);
+
+	dr_ste_v0_set_flex_parser(&misc_4_mask->prog_sample_field_id_2,
+				  &misc_4_mask->prog_sample_field_value_2,
+				  parser_is_used, tag);
+
+	dr_ste_v0_set_flex_parser(&misc_4_mask->prog_sample_field_id_3,
+				  &misc_4_mask->prog_sample_field_value_3,
+				  parser_is_used, tag);
+
+	return 0;
+}
+
+static void dr_ste_v0_build_flex_parser_0_init(struct mlx5dr_ste_build *sb,
+					       struct mlx5dr_match_param *mask)
+{
+	sb->lu_type = DR_STE_V0_LU_TYPE_FLEX_PARSER_0;
+	dr_ste_v0_build_flex_parser_tag(mask, sb, sb->bit_mask);
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v0_build_flex_parser_tag;
+}
+
+static void dr_ste_v0_build_flex_parser_1_init(struct mlx5dr_ste_build *sb,
+					       struct mlx5dr_match_param *mask)
+{
+	sb->lu_type = DR_STE_V0_LU_TYPE_FLEX_PARSER_1;
+	dr_ste_v0_build_flex_parser_tag(mask, sb, sb->bit_mask);
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v0_build_flex_parser_tag;
+}
+
 struct mlx5dr_ste_ctx ste_ctx_v0 = {
 	/* Builders */
 	.build_eth_l2_src_dst_init	= &dr_ste_v0_build_eth_l2_src_dst_init,
@@ -1614,6 +1677,8 @@ struct mlx5dr_ste_ctx ste_ctx_v0 = {
 	.build_register_0_init		= &dr_ste_v0_build_register_0_init,
 	.build_register_1_init		= &dr_ste_v0_build_register_1_init,
 	.build_src_gvmi_qpn_init	= &dr_ste_v0_build_src_gvmi_qpn_init,
+	.build_flex_parser_0_init	= &dr_ste_v0_build_flex_parser_0_init,
+	.build_flex_parser_1_init	= &dr_ste_v0_build_flex_parser_1_init,
 
 	/* Getters and Setters */
 	.ste_init			= &dr_ste_v0_init,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index 616ebc38381a..1c8c08bc2d38 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -1571,6 +1571,69 @@ static void dr_ste_v1_build_src_gvmi_qpn_init(struct mlx5dr_ste_build *sb,
 	sb->ste_build_tag_func = &dr_ste_v1_build_src_gvmi_qpn_tag;
 }
 
+static void dr_ste_v1_set_flex_parser(u32 *misc4_field_id,
+				      u32 *misc4_field_value,
+				      bool *parser_is_used,
+				      u8 *tag)
+{
+	u32 id = *misc4_field_id;
+	u8 *parser_ptr;
+
+	if (parser_is_used[id])
+		return;
+
+	parser_is_used[id] = true;
+	parser_ptr = dr_ste_calc_flex_parser_offset(tag, id);
+
+	*(__be32 *)parser_ptr = cpu_to_be32(*misc4_field_value);
+	*misc4_field_id = 0;
+	*misc4_field_value = 0;
+}
+
+static int dr_ste_v1_build_felx_parser_tag(struct mlx5dr_match_param *value,
+					   struct mlx5dr_ste_build *sb,
+					   u8 *tag)
+{
+	struct mlx5dr_match_misc4 *misc_4_mask = &value->misc4;
+	bool parser_is_used[DR_NUM_OF_FLEX_PARSERS] = {};
+
+	dr_ste_v1_set_flex_parser(&misc_4_mask->prog_sample_field_id_0,
+				  &misc_4_mask->prog_sample_field_value_0,
+				  parser_is_used, tag);
+
+	dr_ste_v1_set_flex_parser(&misc_4_mask->prog_sample_field_id_1,
+				  &misc_4_mask->prog_sample_field_value_1,
+				  parser_is_used, tag);
+
+	dr_ste_v1_set_flex_parser(&misc_4_mask->prog_sample_field_id_2,
+				  &misc_4_mask->prog_sample_field_value_2,
+				  parser_is_used, tag);
+
+	dr_ste_v1_set_flex_parser(&misc_4_mask->prog_sample_field_id_3,
+				  &misc_4_mask->prog_sample_field_value_3,
+				  parser_is_used, tag);
+
+	return 0;
+}
+
+static void dr_ste_v1_build_flex_parser_0_init(struct mlx5dr_ste_build *sb,
+					       struct mlx5dr_match_param *mask)
+{
+	sb->lu_type = DR_STE_V1_LU_TYPE_FLEX_PARSER_0;
+	dr_ste_v1_build_felx_parser_tag(mask, sb, sb->bit_mask);
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v1_build_felx_parser_tag;
+}
+
+static void dr_ste_v1_build_flex_parser_1_init(struct mlx5dr_ste_build *sb,
+					       struct mlx5dr_match_param *mask)
+{
+	sb->lu_type = DR_STE_V1_LU_TYPE_FLEX_PARSER_1;
+	dr_ste_v1_build_felx_parser_tag(mask, sb, sb->bit_mask);
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v1_build_felx_parser_tag;
+}
+
 struct mlx5dr_ste_ctx ste_ctx_v1 = {
 	/* Builders */
 	.build_eth_l2_src_dst_init	= &dr_ste_v1_build_eth_l2_src_dst_init,
@@ -1593,6 +1656,8 @@ struct mlx5dr_ste_ctx ste_ctx_v1 = {
 	.build_register_0_init		= &dr_ste_v1_build_register_0_init,
 	.build_register_1_init		= &dr_ste_v1_build_register_1_init,
 	.build_src_gvmi_qpn_init	= &dr_ste_v1_build_src_gvmi_qpn_init,
+	.build_flex_parser_0_init	= &dr_ste_v1_build_flex_parser_0_init,
+	.build_flex_parser_1_init	= &dr_ste_v1_build_flex_parser_1_init,
 	/* Getters and Setters */
 	.ste_init			= &dr_ste_v1_init,
 	.set_next_lu_type		= &dr_ste_v1_set_next_lu_type,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 462673947f3c..3ccdb806bf68 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -18,6 +18,9 @@
 #define DR_STE_SVLAN 0x1
 #define DR_STE_CVLAN 0x2
 #define DR_SZ_MATCH_PARAM (MLX5_ST_SZ_DW_MATCH_PARAM * 4)
+#define DR_NUM_OF_FLEX_PARSERS 8
+#define DR_STE_MAX_FLEX_0_ID 3
+#define DR_STE_MAX_FLEX_1_ID 7
 
 #define mlx5dr_err(dmn, arg...) mlx5_core_err((dmn)->mdev, ##arg)
 #define mlx5dr_info(dmn, arg...) mlx5_core_info((dmn)->mdev, ##arg)
@@ -87,7 +90,8 @@ enum mlx5dr_matcher_criteria {
 	DR_MATCHER_CRITERIA_INNER = 1 << 2,
 	DR_MATCHER_CRITERIA_MISC2 = 1 << 3,
 	DR_MATCHER_CRITERIA_MISC3 = 1 << 4,
-	DR_MATCHER_CRITERIA_MAX = 1 << 5,
+	DR_MATCHER_CRITERIA_MISC4 = 1 << 5,
+	DR_MATCHER_CRITERIA_MAX = 1 << 6,
 };
 
 enum mlx5dr_action_type {
@@ -419,6 +423,14 @@ void mlx5dr_ste_build_src_gvmi_qpn(struct mlx5dr_ste_ctx *ste_ctx,
 				   struct mlx5dr_match_param *mask,
 				   struct mlx5dr_domain *dmn,
 				   bool inner, bool rx);
+void mlx5dr_ste_build_flex_parser_0(struct mlx5dr_ste_ctx *ste_ctx,
+				    struct mlx5dr_ste_build *sb,
+				    struct mlx5dr_match_param *mask,
+				    bool inner, bool rx);
+void mlx5dr_ste_build_flex_parser_1(struct mlx5dr_ste_ctx *ste_ctx,
+				    struct mlx5dr_ste_build *sb,
+				    struct mlx5dr_match_param *mask,
+				    bool inner, bool rx);
 void mlx5dr_ste_build_empty_always_hit(struct mlx5dr_ste_build *sb, bool rx);
 
 /* Actions utils */
@@ -649,12 +661,24 @@ struct mlx5dr_match_misc3 {
 	u8 reserved_auto3[0x1c];
 };
 
+struct mlx5dr_match_misc4 {
+	u32 prog_sample_field_value_0;
+	u32 prog_sample_field_id_0;
+	u32 prog_sample_field_value_1;
+	u32 prog_sample_field_id_1;
+	u32 prog_sample_field_value_2;
+	u32 prog_sample_field_id_2;
+	u32 prog_sample_field_value_3;
+	u32 prog_sample_field_id_3;
+};
+
 struct mlx5dr_match_param {
 	struct mlx5dr_match_spec outer;
 	struct mlx5dr_match_misc misc;
 	struct mlx5dr_match_spec inner;
 	struct mlx5dr_match_misc2 misc2;
 	struct mlx5dr_match_misc3 misc3;
+	struct mlx5dr_match_misc4 misc4;
 };
 
 #define DR_MASK_IS_ICMPV4_SET(_misc3) ((_misc3)->icmpv4_type || \
-- 
2.30.2

