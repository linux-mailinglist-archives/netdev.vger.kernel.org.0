Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81B33650CD
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 05:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234599AbhDTDVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 23:21:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234117AbhDTDVJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 23:21:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E27061354;
        Tue, 20 Apr 2021 03:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618888838;
        bh=XS9cpFyfk8JsDYKcYr58XouHGb+J11iXAjkWh1KQVmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rz5mkNtUjm+H0xWnSpIWqszmU9hWs9Mc38tkCVW5hB1isrJwzX7kgNOlQWN4bYi72
         426Fd77rq7cN/UO7muSWYSHkutnrreGwrrLBmCM1ZWfK7Td/+DkI3TpLXjZssGQJhu
         TvtQQ1WSLpR40jG6USsjZmmg094sFUgDicUjaGWOffBCQ/Vv4EFB3/7XBFK15m0Xrf
         JFqrYXQCWfj0tdH/D+4fbE8JDCiWxgcLdYQAP599NAr5mPWCjT+oKnQZZVUCcqWXBQ
         MKzI9YksV6MoPwQ8P9YxRm7/xfTBWnyRuiX0N1p4S6NDZpycVCtquApsGJM9+opSr5
         lH9rlYpUY/Y5A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Muhammad Sammar <muhammads@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/15] net/mlx5: DR, Add support for matching on geneve TLV option
Date:   Mon, 19 Apr 2021 20:20:14 -0700
Message-Id: <20210420032018.58639-12-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210420032018.58639-1-saeed@kernel.org>
References: <20210420032018.58639-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Enable matching on tunnel geneve TLV option using the flex parser.

Signed-off-by: Muhammad Sammar <muhammads@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_cmd.c      |  4 +++
 .../mellanox/mlx5/core/steering/dr_matcher.c  | 13 +++++--
 .../mellanox/mlx5/core/steering/dr_ste.c      | 14 ++++++++
 .../mellanox/mlx5/core/steering/dr_ste.h      |  1 +
 .../mellanox/mlx5/core/steering/dr_ste_v0.c   | 34 +++++++++++++++++++
 .../mellanox/mlx5/core/steering/dr_ste_v1.c   | 34 +++++++++++++++++++
 .../mellanox/mlx5/core/steering/dr_types.h    | 11 ++++--
 7 files changed, 107 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
index 461473d31e2e..0561df8616c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -106,6 +106,10 @@ int mlx5dr_cmd_query_device(struct mlx5_core_dev *mdev,
 			MLX5_CAP_GEN(mdev, flex_parser_id_icmpv6_dw1);
 	}
 
+	if (caps->flex_protocols & MLX5_FLEX_PARSER_GENEVE_TLV_OPTION_0_ENABLED)
+		caps->flex_parser_id_geneve_tlv_option_0 =
+			MLX5_CAP_GEN(mdev, flex_parser_id_geneve_tlv_option_0);
+
 	caps->nic_rx_drop_address =
 		MLX5_CAP64_FLOWTABLE(mdev, sw_steering_nic_rx_action_drop_icm_address);
 	caps->nic_tx_drop_address =
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index f83fea98cc46..0aa4a994fe77 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -133,6 +133,11 @@ static bool dr_mask_is_tnl_geneve_set(struct mlx5dr_match_misc *misc)
 	       misc->geneve_opt_len;
 }
 
+static bool dr_mask_is_tnl_geneve_tlv_opt(struct mlx5dr_match_misc3 *misc3)
+{
+	return misc3->geneve_tlv_option_0_data;
+}
+
 static bool
 dr_matcher_supp_tnl_geneve(struct mlx5dr_cmd_caps *caps)
 {
@@ -360,10 +365,14 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 		if (dr_mask_is_tnl_vxlan_gpe(&mask, dmn))
 			mlx5dr_ste_build_tnl_vxlan_gpe(ste_ctx, &sb[idx++],
 						       &mask, inner, rx);
-		else if (dr_mask_is_tnl_geneve(&mask, dmn))
+		else if (dr_mask_is_tnl_geneve(&mask, dmn)) {
 			mlx5dr_ste_build_tnl_geneve(ste_ctx, &sb[idx++],
 						    &mask, inner, rx);
-
+			if (dr_mask_is_tnl_geneve_tlv_opt(&mask.misc3))
+				mlx5dr_ste_build_tnl_geneve_tlv_opt(ste_ctx, &sb[idx++],
+								    &mask, &dmn->info.caps,
+								    inner, rx);
+		}
 		if (DR_MASK_IS_ETH_L4_MISC_SET(mask.misc3, outer))
 			mlx5dr_ste_build_eth_l4_misc(ste_ctx, &sb[idx++],
 						     &mask, inner, rx);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 7ae718bb41eb..8d98341802e3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -852,6 +852,8 @@ static void dr_ste_copy_mask_misc3(char *mask, struct mlx5dr_match_misc3 *spec)
 	spec->icmpv4_code = MLX5_GET(fte_match_set_misc3, mask, icmp_code);
 	spec->icmpv6_type = MLX5_GET(fte_match_set_misc3, mask, icmpv6_type);
 	spec->icmpv6_code = MLX5_GET(fte_match_set_misc3, mask, icmpv6_code);
+	spec->geneve_tlv_option_0_data =
+		MLX5_GET(fte_match_set_misc3, mask, geneve_tlv_option_0_data);
 }
 
 static void dr_ste_copy_mask_misc4(char *mask, struct mlx5dr_match_misc4 *spec)
@@ -1147,6 +1149,18 @@ void mlx5dr_ste_build_tnl_geneve(struct mlx5dr_ste_ctx *ste_ctx,
 	ste_ctx->build_tnl_geneve_init(sb, mask);
 }
 
+void mlx5dr_ste_build_tnl_geneve_tlv_opt(struct mlx5dr_ste_ctx *ste_ctx,
+					 struct mlx5dr_ste_build *sb,
+					 struct mlx5dr_match_param *mask,
+					 struct mlx5dr_cmd_caps *caps,
+					 bool inner, bool rx)
+{
+	sb->rx = rx;
+	sb->caps = caps;
+	sb->inner = inner;
+	ste_ctx->build_tnl_geneve_tlv_opt_init(sb, mask);
+}
+
 void mlx5dr_ste_build_register_0(struct mlx5dr_ste_ctx *ste_ctx,
 				 struct mlx5dr_ste_build *sb,
 				 struct mlx5dr_match_param *mask,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
index a00dab3b6944..5fa268a6c7df 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
@@ -125,6 +125,7 @@ struct mlx5dr_ste_ctx {
 	void DR_STE_CTX_BUILDER(eth_l4_misc);
 	void DR_STE_CTX_BUILDER(tnl_vxlan_gpe);
 	void DR_STE_CTX_BUILDER(tnl_geneve);
+	void DR_STE_CTX_BUILDER(tnl_geneve_tlv_opt);
 	void DR_STE_CTX_BUILDER(register_0);
 	void DR_STE_CTX_BUILDER(register_1);
 	void DR_STE_CTX_BUILDER(src_gvmi_qpn);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
index 62421c33a9ca..cf923a7e9b3b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
@@ -1650,6 +1650,39 @@ static void dr_ste_v0_build_flex_parser_1_init(struct mlx5dr_ste_build *sb,
 	sb->ste_build_tag_func = &dr_ste_v0_build_flex_parser_tag;
 }
 
+static int
+dr_ste_v0_build_flex_parser_tnl_geneve_tlv_opt_tag(struct mlx5dr_match_param *value,
+						   struct mlx5dr_ste_build *sb,
+						   u8 *tag)
+{
+	struct mlx5dr_match_misc3 *misc3 = &value->misc3;
+	u8 parser_id = sb->caps->flex_parser_id_geneve_tlv_option_0;
+	u8 *parser_ptr = dr_ste_calc_flex_parser_offset(tag, parser_id);
+
+	MLX5_SET(ste_flex_parser_0, parser_ptr, flex_parser_3,
+		 misc3->geneve_tlv_option_0_data);
+	misc3->geneve_tlv_option_0_data = 0;
+
+	return 0;
+}
+
+static void
+dr_ste_v0_build_flex_parser_tnl_geneve_tlv_opt_init(struct mlx5dr_ste_build *sb,
+						    struct mlx5dr_match_param *mask)
+{
+	dr_ste_v0_build_flex_parser_tnl_geneve_tlv_opt_tag(mask, sb, sb->bit_mask);
+
+	/* STEs with lookup type FLEX_PARSER_{0/1} includes
+	 * flex parsers_{0-3}/{4-7} respectively.
+	 */
+	sb->lu_type = sb->caps->flex_parser_id_geneve_tlv_option_0 > 3 ?
+		DR_STE_V0_LU_TYPE_FLEX_PARSER_1 :
+		DR_STE_V0_LU_TYPE_FLEX_PARSER_0;
+
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v0_build_flex_parser_tnl_geneve_tlv_opt_tag;
+}
+
 struct mlx5dr_ste_ctx ste_ctx_v0 = {
 	/* Builders */
 	.build_eth_l2_src_dst_init	= &dr_ste_v0_build_eth_l2_src_dst_init,
@@ -1669,6 +1702,7 @@ struct mlx5dr_ste_ctx ste_ctx_v0 = {
 	.build_eth_l4_misc_init		= &dr_ste_v0_build_eth_l4_misc_init,
 	.build_tnl_vxlan_gpe_init	= &dr_ste_v0_build_flex_parser_tnl_vxlan_gpe_init,
 	.build_tnl_geneve_init		= &dr_ste_v0_build_flex_parser_tnl_geneve_init,
+	.build_tnl_geneve_tlv_opt_init	= &dr_ste_v0_build_flex_parser_tnl_geneve_tlv_opt_init,
 	.build_register_0_init		= &dr_ste_v0_build_register_0_init,
 	.build_register_1_init		= &dr_ste_v0_build_register_1_init,
 	.build_src_gvmi_qpn_init	= &dr_ste_v0_build_src_gvmi_qpn_init,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index f77b1e9103ce..f15a15da0acb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -1632,6 +1632,39 @@ static void dr_ste_v1_build_flex_parser_1_init(struct mlx5dr_ste_build *sb,
 	sb->ste_build_tag_func = &dr_ste_v1_build_felx_parser_tag;
 }
 
+static int
+dr_ste_v1_build_flex_parser_tnl_geneve_tlv_opt_tag(struct mlx5dr_match_param *value,
+						   struct mlx5dr_ste_build *sb,
+						   u8 *tag)
+{
+	struct mlx5dr_match_misc3 *misc3 = &value->misc3;
+	u8 parser_id = sb->caps->flex_parser_id_geneve_tlv_option_0;
+	u8 *parser_ptr = dr_ste_calc_flex_parser_offset(tag, parser_id);
+
+	MLX5_SET(ste_flex_parser_0, parser_ptr, flex_parser_3,
+		 misc3->geneve_tlv_option_0_data);
+	misc3->geneve_tlv_option_0_data = 0;
+
+	return 0;
+}
+
+static void
+dr_ste_v1_build_flex_parser_tnl_geneve_tlv_opt_init(struct mlx5dr_ste_build *sb,
+						    struct mlx5dr_match_param *mask)
+{
+	dr_ste_v1_build_flex_parser_tnl_geneve_tlv_opt_tag(mask, sb, sb->bit_mask);
+
+	/* STEs with lookup type FLEX_PARSER_{0/1} includes
+	 * flex parsers_{0-3}/{4-7} respectively.
+	 */
+	sb->lu_type = sb->caps->flex_parser_id_geneve_tlv_option_0 > 3 ?
+		      DR_STE_V1_LU_TYPE_FLEX_PARSER_1 :
+		      DR_STE_V1_LU_TYPE_FLEX_PARSER_0;
+
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v1_build_flex_parser_tnl_geneve_tlv_opt_tag;
+}
+
 struct mlx5dr_ste_ctx ste_ctx_v1 = {
 	/* Builders */
 	.build_eth_l2_src_dst_init	= &dr_ste_v1_build_eth_l2_src_dst_init,
@@ -1651,6 +1684,7 @@ struct mlx5dr_ste_ctx ste_ctx_v1 = {
 	.build_eth_l4_misc_init		= &dr_ste_v1_build_eth_l4_misc_init,
 	.build_tnl_vxlan_gpe_init	= &dr_ste_v1_build_flex_parser_tnl_vxlan_gpe_init,
 	.build_tnl_geneve_init		= &dr_ste_v1_build_flex_parser_tnl_geneve_init,
+	.build_tnl_geneve_tlv_opt_init	= &dr_ste_v1_build_flex_parser_tnl_geneve_tlv_opt_init,
 	.build_register_0_init		= &dr_ste_v1_build_register_0_init,
 	.build_register_1_init		= &dr_ste_v1_build_register_1_init,
 	.build_src_gvmi_qpn_init	= &dr_ste_v1_build_src_gvmi_qpn_init,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index ee2ea215c4b9..3c07ec61c8be 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -12,7 +12,7 @@
 #include "mlx5_ifc_dr.h"
 #include "mlx5dr.h"
 
-#define DR_RULE_MAX_STES 17
+#define DR_RULE_MAX_STES 18
 #define DR_ACTION_MAX_STES 5
 #define WIRE_PORT 0xFFFF
 #define DR_STE_SVLAN 0x1
@@ -406,6 +406,11 @@ void mlx5dr_ste_build_tnl_geneve(struct mlx5dr_ste_ctx *ste_ctx,
 				 struct mlx5dr_ste_build *sb,
 				 struct mlx5dr_match_param *mask,
 				 bool inner, bool rx);
+void mlx5dr_ste_build_tnl_geneve_tlv_opt(struct mlx5dr_ste_ctx *ste_ctx,
+					 struct mlx5dr_ste_build *sb,
+					 struct mlx5dr_match_param *mask,
+					 struct mlx5dr_cmd_caps *caps,
+					 bool inner, bool rx);
 void mlx5dr_ste_build_general_purpose(struct mlx5dr_ste_ctx *ste_ctx,
 				      struct mlx5dr_ste_build *sb,
 				      struct mlx5dr_match_param *mask,
@@ -658,7 +663,8 @@ struct mlx5dr_match_misc3 {
 	u8 icmpv6_type;
 	u8 icmpv4_code;
 	u8 icmpv4_type;
-	u8 reserved_auto3[0x1c];
+	u32 geneve_tlv_option_0_data;
+	u8 reserved_auto3[0x18];
 };
 
 struct mlx5dr_match_misc4 {
@@ -716,6 +722,7 @@ struct mlx5dr_cmd_caps {
 	u8 flex_parser_id_icmp_dw1;
 	u8 flex_parser_id_icmpv6_dw0;
 	u8 flex_parser_id_icmpv6_dw1;
+	u8 flex_parser_id_geneve_tlv_option_0;
 	u8 max_ft_level;
 	u16 roce_min_src_udp;
 	u8 num_esw_ports;
-- 
2.30.2

