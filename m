Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF28481058
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 07:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238976AbhL2GZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 01:25:19 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58318 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238968AbhL2GZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 01:25:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E889DB81828
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 06:25:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C104C36AF5;
        Wed, 29 Dec 2021 06:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640759112;
        bh=MXf+H9xI2AxoSAoQgiz7Z5N8KW5yA6n3zsJ3m16Wa6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g5+u3jrzI1IrHczaAkhvVjONY5/6pLCMfODwKs796bIwNVG5wN1kRZqshy1CAtAaR
         vdEW7u47FRKw5MvcgnM9GTKzLbhnq37OVwnfWeMNgfH2w9ezYGEqLa7XbvHmZ+EDQP
         3mtbaQdigd/4gewYdI/nnRuHYThkq5SydQClT9IrkLUjA15VDXcy9QAUIbMZc1bbPZ
         D29zzCkPnst8OITcqsD7Ifcfsx2QwnhNX3zm+qb/qoDKFkM/NykO8I0vZxB2WQy3FL
         BJSItb79aqqy5lCgRshGHDZICa/Va3ueXQOn9WIvnCoSiqJPLMbo3Z03ALoGNngFNP
         g2Mk0LCan9Rjg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Muhammad Sammar <muhammads@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next  13/16] net/mlx5: DR, Add support for matching on geneve_tlv_option_0_exist field
Date:   Tue, 28 Dec 2021 22:24:59 -0800
Message-Id: <20211229062502.24111-14-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211229062502.24111-1-saeed@kernel.org>
References: <20211229062502.24111-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Match on geneve_tlv_option_0_exist field on devices that support STEv1.

Signed-off-by: Muhammad Sammar <muhammads@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_cmd.c      |  7 +++++
 .../mellanox/mlx5/core/steering/dr_matcher.c  | 17 +++++++++++
 .../mellanox/mlx5/core/steering/dr_ste.c      | 17 +++++++++++
 .../mellanox/mlx5/core/steering/dr_ste.h      |  1 +
 .../mellanox/mlx5/core/steering/dr_ste_v1.c   | 28 +++++++++++++++++++
 .../mellanox/mlx5/core/steering/dr_types.h    |  9 +++++-
 .../mellanox/mlx5/core/steering/mlx5_ifc_dr.h |  8 ++++++
 include/linux/mlx5/mlx5_ifc.h                 |  6 ++--
 8 files changed, 90 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
index e1a79eb66f3c..4dd619d238cc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -132,6 +132,13 @@ int mlx5dr_cmd_query_device(struct mlx5_core_dev *mdev,
 
 	caps->isolate_vl_tc = MLX5_CAP_GEN(mdev, isolate_vl_tc_new);
 
+	/* geneve_tlv_option_0_exist is the indication of
+	 * STE support for lookup type flex_parser_ok
+	 */
+	caps->flex_parser_ok_bits_supp =
+		MLX5_CAP_FLOWTABLE(mdev,
+				   flow_table_properties_nic_receive.ft_field_support.geneve_tlv_option_0_exist);
+
 	if (caps->flex_protocols & MLX5_FLEX_PARSER_ICMP_V4_ENABLED) {
 		caps->flex_parser_id_icmp_dw0 = MLX5_CAP_GEN(mdev, flex_parser_id_icmp_dw0);
 		caps->flex_parser_id_icmp_dw1 = MLX5_CAP_GEN(mdev, flex_parser_id_icmp_dw1);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index b3e7a611f99e..d9f66faa619e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -140,6 +140,19 @@ static bool dr_mask_is_tnl_geneve_tlv_opt(struct mlx5dr_match_misc3 *misc3)
 	return misc3->geneve_tlv_option_0_data;
 }
 
+static bool
+dr_matcher_supp_flex_parser_ok(struct mlx5dr_cmd_caps *caps)
+{
+	return caps->flex_parser_ok_bits_supp;
+}
+
+static bool dr_mask_is_tnl_geneve_tlv_opt_exist_set(struct mlx5dr_match_misc *misc,
+						    struct mlx5dr_domain *dmn)
+{
+	return dr_matcher_supp_flex_parser_ok(&dmn->info.caps) &&
+	       misc->geneve_tlv_option_0_exist;
+}
+
 static bool
 dr_matcher_supp_tnl_geneve(struct mlx5dr_cmd_caps *caps)
 {
@@ -521,6 +534,10 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 				mlx5dr_ste_build_tnl_geneve_tlv_opt(ste_ctx, &sb[idx++],
 								    &mask, &dmn->info.caps,
 								    inner, rx);
+			if (dr_mask_is_tnl_geneve_tlv_opt_exist_set(&mask.misc, dmn))
+				mlx5dr_ste_build_tnl_geneve_tlv_opt_exist(ste_ctx, &sb[idx++],
+									  &mask, &dmn->info.caps,
+									  inner, rx);
 		} else if (dr_mask_is_tnl_gtpu_any(&mask, dmn)) {
 			if (dr_mask_is_tnl_gtpu_flex_parser_0(&mask, dmn))
 				mlx5dr_ste_build_tnl_gtpu_flex_parser_0(ste_ctx, &sb[idx++],
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 67094dba233c..7e61742e58a0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -719,6 +719,8 @@ static void dr_ste_copy_mask_misc(char *mask, struct mlx5dr_match_misc *spec, bo
 	spec->vxlan_vni = IFC_GET_CLR(fte_match_set_misc, mask, vxlan_vni, clr);
 
 	spec->geneve_vni = IFC_GET_CLR(fte_match_set_misc, mask, geneve_vni, clr);
+	spec->geneve_tlv_option_0_exist =
+		IFC_GET_CLR(fte_match_set_misc, mask, geneve_tlv_option_0_exist, clr);
 	spec->geneve_oam = IFC_GET_CLR(fte_match_set_misc, mask, geneve_oam, clr);
 
 	spec->outer_ipv6_flow_label =
@@ -1214,6 +1216,21 @@ void mlx5dr_ste_build_tnl_geneve_tlv_opt(struct mlx5dr_ste_ctx *ste_ctx,
 	ste_ctx->build_tnl_geneve_tlv_opt_init(sb, mask);
 }
 
+void mlx5dr_ste_build_tnl_geneve_tlv_opt_exist(struct mlx5dr_ste_ctx *ste_ctx,
+					       struct mlx5dr_ste_build *sb,
+					       struct mlx5dr_match_param *mask,
+					       struct mlx5dr_cmd_caps *caps,
+					       bool inner, bool rx)
+{
+	if (!ste_ctx->build_tnl_geneve_tlv_opt_exist_init)
+		return;
+
+	sb->rx = rx;
+	sb->caps = caps;
+	sb->inner = inner;
+	ste_ctx->build_tnl_geneve_tlv_opt_exist_init(sb, mask);
+}
+
 void mlx5dr_ste_build_tnl_gtpu(struct mlx5dr_ste_ctx *ste_ctx,
 			       struct mlx5dr_ste_build *sb,
 			       struct mlx5dr_match_param *mask,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
index e6c25bdf0da0..ca8fa32b8680 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
@@ -135,6 +135,7 @@ struct mlx5dr_ste_ctx {
 	void DR_STE_CTX_BUILDER(tnl_vxlan_gpe);
 	void DR_STE_CTX_BUILDER(tnl_geneve);
 	void DR_STE_CTX_BUILDER(tnl_geneve_tlv_opt);
+	void DR_STE_CTX_BUILDER(tnl_geneve_tlv_opt_exist);
 	void DR_STE_CTX_BUILDER(register_0);
 	void DR_STE_CTX_BUILDER(register_1);
 	void DR_STE_CTX_BUILDER(src_gvmi_qpn);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index 9c72be2c2b6b..6ca06800f1d9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -47,6 +47,7 @@ enum {
 	DR_STE_V1_LU_TYPE_ETHL3_IPV4_MISC_I		= 0x000f,
 	DR_STE_V1_LU_TYPE_STEERING_REGISTERS_0		= 0x010f,
 	DR_STE_V1_LU_TYPE_STEERING_REGISTERS_1		= 0x0110,
+	DR_STE_V1_LU_TYPE_FLEX_PARSER_OK		= 0x0011,
 	DR_STE_V1_LU_TYPE_FLEX_PARSER_0			= 0x0111,
 	DR_STE_V1_LU_TYPE_FLEX_PARSER_1			= 0x0112,
 	DR_STE_V1_LU_TYPE_ETHL4_MISC_O			= 0x0113,
@@ -1942,6 +1943,32 @@ dr_ste_v1_build_flex_parser_tnl_geneve_tlv_opt_init(struct mlx5dr_ste_build *sb,
 	sb->ste_build_tag_func = &dr_ste_v1_build_flex_parser_tnl_geneve_tlv_opt_tag;
 }
 
+static int
+dr_ste_v1_build_flex_parser_tnl_geneve_tlv_opt_exist_tag(struct mlx5dr_match_param *value,
+							 struct mlx5dr_ste_build *sb,
+							 uint8_t *tag)
+{
+	u8 parser_id = sb->caps->flex_parser_id_geneve_tlv_option_0;
+	struct mlx5dr_match_misc *misc = &value->misc;
+
+	if (misc->geneve_tlv_option_0_exist) {
+		MLX5_SET(ste_flex_parser_ok, tag, flex_parsers_ok, 1 << parser_id);
+		misc->geneve_tlv_option_0_exist = 0;
+	}
+
+	return 0;
+}
+
+static void
+dr_ste_v1_build_flex_parser_tnl_geneve_tlv_opt_exist_init(struct mlx5dr_ste_build *sb,
+							  struct mlx5dr_match_param *mask)
+{
+	sb->lu_type = DR_STE_V1_LU_TYPE_FLEX_PARSER_OK;
+	dr_ste_v1_build_flex_parser_tnl_geneve_tlv_opt_exist_tag(mask, sb, sb->bit_mask);
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v1_build_flex_parser_tnl_geneve_tlv_opt_exist_tag;
+}
+
 static int dr_ste_v1_build_flex_parser_tnl_gtpu_tag(struct mlx5dr_match_param *value,
 						    struct mlx5dr_ste_build *sb,
 						    u8 *tag)
@@ -2041,6 +2068,7 @@ struct mlx5dr_ste_ctx ste_ctx_v1 = {
 	.build_tnl_vxlan_gpe_init	= &dr_ste_v1_build_flex_parser_tnl_vxlan_gpe_init,
 	.build_tnl_geneve_init		= &dr_ste_v1_build_flex_parser_tnl_geneve_init,
 	.build_tnl_geneve_tlv_opt_init	= &dr_ste_v1_build_flex_parser_tnl_geneve_tlv_opt_init,
+	.build_tnl_geneve_tlv_opt_exist_init = &dr_ste_v1_build_flex_parser_tnl_geneve_tlv_opt_exist_init,
 	.build_register_0_init		= &dr_ste_v1_build_register_0_init,
 	.build_register_1_init		= &dr_ste_v1_build_register_1_init,
 	.build_src_gvmi_qpn_init	= &dr_ste_v1_build_src_gvmi_qpn_init,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 5805e2554a59..21a9b07ba327 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -442,6 +442,11 @@ void mlx5dr_ste_build_tnl_geneve_tlv_opt(struct mlx5dr_ste_ctx *ste_ctx,
 					 struct mlx5dr_match_param *mask,
 					 struct mlx5dr_cmd_caps *caps,
 					 bool inner, bool rx);
+void mlx5dr_ste_build_tnl_geneve_tlv_opt_exist(struct mlx5dr_ste_ctx *ste_ctx,
+					       struct mlx5dr_ste_build *sb,
+					       struct mlx5dr_match_param *mask,
+					       struct mlx5dr_cmd_caps *caps,
+					       bool inner, bool rx);
 void mlx5dr_ste_build_tnl_gtpu(struct mlx5dr_ste_ctx *ste_ctx,
 			       struct mlx5dr_ste_build *sb,
 			       struct mlx5dr_match_param *mask,
@@ -666,7 +671,8 @@ struct mlx5dr_match_misc {
 	u32 reserved_auto3:8;
 
 	u32 geneve_vni:24;		/* GENEVE VNI field (outer) */
-	u32 reserved_auto4:7;
+	u32 reserved_auto4:6;
+	u32 geneve_tlv_option_0_exist:1;
 	u32 geneve_oam:1;		/* GENEVE OAM field (outer) */
 
 	u32 reserved_auto5:12;
@@ -842,6 +848,7 @@ struct mlx5dr_cmd_caps {
 	u8 flex_parser_id_gtpu_teid;
 	u8 flex_parser_id_gtpu_dw_2;
 	u8 flex_parser_id_gtpu_first_ext_dw_0;
+	u8 flex_parser_ok_bits_supp;
 	u8 max_ft_level;
 	u16 roce_min_src_udp;
 	u8 sw_format_ver;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h
index d0e20bda2622..9604b2091358 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h
@@ -447,6 +447,14 @@ struct mlx5_ifc_ste_flex_parser_1_bits {
 	u8         flex_parser_4[0x20];
 };
 
+struct mlx5_ifc_ste_flex_parser_ok_bits {
+	u8         flex_parser_3[0x20];
+	u8         flex_parser_2[0x20];
+	u8         flex_parsers_ok[0x8];
+	u8         reserved_at_48[0x18];
+	u8         flex_parser_0[0x20];
+};
+
 struct mlx5_ifc_ste_flex_parser_tnl_bits {
 	u8         flex_parser_tunneling_header_63_32[0x20];
 
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index c74c5e147cb9..deaa0f71213f 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -372,7 +372,8 @@ struct mlx5_ifc_flow_table_fields_supported_bits {
 	u8         reserved_at_37[0x9];
 
 	u8         geneve_tlv_option_0_data[0x1];
-	u8         reserved_at_41[0x4];
+	u8         geneve_tlv_option_0_exist[0x1];
+	u8         reserved_at_42[0x3];
 	u8         outer_first_mpls_over_udp[0x4];
 	u8         outer_first_mpls_over_gre[0x4];
 	u8         inner_first_mpls[0x4];
@@ -551,7 +552,8 @@ struct mlx5_ifc_fte_match_set_misc_bits {
 	u8         bth_opcode[0x8];
 
 	u8         geneve_vni[0x18];
-	u8         reserved_at_d8[0x7];
+	u8         reserved_at_d8[0x6];
+	u8         geneve_tlv_option_0_exist[0x1];
 	u8         geneve_oam[0x1];
 
 	u8         reserved_at_e0[0xc];
-- 
2.33.1

