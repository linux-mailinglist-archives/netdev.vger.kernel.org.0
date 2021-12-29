Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 349AE481056
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 07:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238983AbhL2GZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 01:25:18 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60718 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238958AbhL2GZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 01:25:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99258613F5
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 06:25:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A02A9C36AE7;
        Wed, 29 Dec 2021 06:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640759112;
        bh=feh84do5mMf21FCkSElJwJDs5N2Lyr0LZiQQVEBPNlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cRDnqfq+eOCsplQTSSVJkfN7WRyhAe9b9R11y81Bq/7KGSudEo3Efov6e1mUiCalU
         v2pS/3bkzU80hdS4eG9ltBUqdJouUHHMeso17a+e0Qrs/91nC/PiGXVg1ooR3il9Rb
         0ahSjDyZJAD0TIhKEyzU0dZfdLPG06RIvEnSKKO5Uz4Me5DGPIjQTVoEiMBbDX2eiA
         ucTlh0urdx3oT9lVG0wJzmRUCtXsAFAHY7TsI7ihF6qZjdjNXERqogxBuTNH5VfWyY
         EAAeZLfKRJf3xZNN9lgQiKEISP3sQumOSDVwC9N8lWrlbH0286+cqJBi2pO7uFqkJo
         /alKllI6lvd1Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Muhammad Sammar <muhammads@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next  12/16] net/mlx5: DR, Support matching on tunnel headers 0 and 1
Date:   Tue, 28 Dec 2021 22:24:58 -0800
Message-Id: <20211229062502.24111-13-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211229062502.24111-1-saeed@kernel.org>
References: <20211229062502.24111-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Muhammad Sammar <muhammads@nvidia.com>

Tunnel headers are generic encapsulation headers, applies for all
tunneling protocols identified by the device native parser or by the
programmable parser, this support will enable raw matching headers 0 and 1.

Signed-off-by: Muhammad Sammar <muhammads@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_matcher.c  | 12 +++++++++-
 .../mellanox/mlx5/core/steering/dr_ste.c      | 10 ++++++++
 .../mellanox/mlx5/core/steering/dr_ste.h      |  1 +
 .../mellanox/mlx5/core/steering/dr_ste_v0.c   | 23 +++++++++++++++++++
 .../mellanox/mlx5/core/steering/dr_ste_v1.c   | 22 ++++++++++++++++++
 .../mellanox/mlx5/core/steering/dr_types.h    |  4 ++++
 .../mellanox/mlx5/core/steering/mlx5_ifc_dr.h |  8 +++++++
 7 files changed, 79 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index 856541a60d8c..b3e7a611f99e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -368,6 +368,12 @@ static bool dr_mask_is_tnl_mpls_over_udp(struct mlx5dr_match_param *mask,
 	return DR_MASK_IS_OUTER_MPLS_OVER_UDP_SET(&mask->misc2) &&
 	       dr_matcher_supp_tnl_mpls_over_udp(&dmn->info.caps);
 }
+
+static bool dr_mask_is_tnl_header_0_1_set(struct mlx5dr_match_misc5 *misc5)
+{
+	return misc5->tunnel_header_0 || misc5->tunnel_header_1;
+}
+
 int mlx5dr_matcher_select_builders(struct mlx5dr_matcher *matcher,
 				   struct mlx5dr_matcher_rx_tx *nic_matcher,
 				   enum mlx5dr_ipv outer_ipv,
@@ -446,7 +452,8 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 	if (matcher->match_criteria & (DR_MATCHER_CRITERIA_OUTER |
 				       DR_MATCHER_CRITERIA_MISC |
 				       DR_MATCHER_CRITERIA_MISC2 |
-				       DR_MATCHER_CRITERIA_MISC3)) {
+				       DR_MATCHER_CRITERIA_MISC3 |
+				       DR_MATCHER_CRITERIA_MISC5)) {
 		inner = false;
 
 		if (dr_mask_is_wqe_metadata_set(&mask.misc2))
@@ -528,6 +535,9 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 			if (dr_mask_is_tnl_gtpu(&mask, dmn))
 				mlx5dr_ste_build_tnl_gtpu(ste_ctx, &sb[idx++],
 							  &mask, inner, rx);
+		} else if (dr_mask_is_tnl_header_0_1_set(&mask.misc5)) {
+			mlx5dr_ste_build_tnl_header_0_1(ste_ctx, &sb[idx++],
+							&mask, inner, rx);
 		}
 
 		if (DR_MASK_IS_ETH_L4_MISC_SET(mask.misc3, outer))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 9bf25231c9c9..67094dba233c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -1303,6 +1303,16 @@ void mlx5dr_ste_build_flex_parser_1(struct mlx5dr_ste_ctx *ste_ctx,
 	ste_ctx->build_flex_parser_1_init(sb, mask);
 }
 
+void mlx5dr_ste_build_tnl_header_0_1(struct mlx5dr_ste_ctx *ste_ctx,
+				     struct mlx5dr_ste_build *sb,
+				     struct mlx5dr_match_param *mask,
+				     bool inner, bool rx)
+{
+	sb->rx = rx;
+	sb->inner = inner;
+	ste_ctx->build_tnl_header_0_1_init(sb, mask);
+}
+
 static struct mlx5dr_ste_ctx *mlx5dr_ste_ctx_arr[] = {
 	[MLX5_STEERING_FORMAT_CONNECTX_5] = &ste_ctx_v0,
 	[MLX5_STEERING_FORMAT_CONNECTX_6DX] = &ste_ctx_v1,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
index 2d52d065dc8b..e6c25bdf0da0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
@@ -141,6 +141,7 @@ struct mlx5dr_ste_ctx {
 	void DR_STE_CTX_BUILDER(flex_parser_0);
 	void DR_STE_CTX_BUILDER(flex_parser_1);
 	void DR_STE_CTX_BUILDER(tnl_gtpu);
+	void DR_STE_CTX_BUILDER(tnl_header_0_1);
 	void DR_STE_CTX_BUILDER(tnl_gtpu_flex_parser_0);
 	void DR_STE_CTX_BUILDER(tnl_gtpu_flex_parser_1);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
index 17bfd1ec0589..2d62950f7a29 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
@@ -80,6 +80,7 @@ enum {
 	DR_STE_V0_LU_TYPE_GENERAL_PURPOSE		= 0x18,
 	DR_STE_V0_LU_TYPE_STEERING_REGISTERS_0		= 0x2f,
 	DR_STE_V0_LU_TYPE_STEERING_REGISTERS_1		= 0x30,
+	DR_STE_V0_LU_TYPE_TUNNEL_HEADER			= 0x34,
 	DR_STE_V0_LU_TYPE_DONT_CARE			= MLX5DR_STE_LU_TYPE_DONT_CARE,
 };
 
@@ -1875,6 +1876,27 @@ dr_ste_v0_build_tnl_gtpu_flex_parser_1_init(struct mlx5dr_ste_build *sb,
 	sb->ste_build_tag_func = &dr_ste_v0_build_tnl_gtpu_flex_parser_1_tag;
 }
 
+static int dr_ste_v0_build_tnl_header_0_1_tag(struct mlx5dr_match_param *value,
+					      struct mlx5dr_ste_build *sb,
+					      uint8_t *tag)
+{
+	struct mlx5dr_match_misc5 *misc5 = &value->misc5;
+
+	DR_STE_SET_TAG(tunnel_header, tag, tunnel_header_0, misc5, tunnel_header_0);
+	DR_STE_SET_TAG(tunnel_header, tag, tunnel_header_1, misc5, tunnel_header_1);
+
+	return 0;
+}
+
+static void dr_ste_v0_build_tnl_header_0_1_init(struct mlx5dr_ste_build *sb,
+						struct mlx5dr_match_param *mask)
+{
+	sb->lu_type = DR_STE_V0_LU_TYPE_TUNNEL_HEADER;
+	dr_ste_v0_build_tnl_header_0_1_tag(mask, sb, sb->bit_mask);
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v0_build_tnl_header_0_1_tag;
+}
+
 struct mlx5dr_ste_ctx ste_ctx_v0 = {
 	/* Builders */
 	.build_eth_l2_src_dst_init	= &dr_ste_v0_build_eth_l2_src_dst_init,
@@ -1903,6 +1925,7 @@ struct mlx5dr_ste_ctx ste_ctx_v0 = {
 	.build_flex_parser_0_init	= &dr_ste_v0_build_flex_parser_0_init,
 	.build_flex_parser_1_init	= &dr_ste_v0_build_flex_parser_1_init,
 	.build_tnl_gtpu_init		= &dr_ste_v0_build_flex_parser_tnl_gtpu_init,
+	.build_tnl_header_0_1_init	= &dr_ste_v0_build_tnl_header_0_1_init,
 	.build_tnl_gtpu_flex_parser_0_init   = &dr_ste_v0_build_tnl_gtpu_flex_parser_0_init,
 	.build_tnl_gtpu_flex_parser_1_init   = &dr_ste_v0_build_tnl_gtpu_flex_parser_1_init,
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index a7772804f8e5..9c72be2c2b6b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -1713,6 +1713,27 @@ dr_ste_v1_build_flex_parser_tnl_geneve_init(struct mlx5dr_ste_build *sb,
 	sb->ste_build_tag_func = &dr_ste_v1_build_flex_parser_tnl_geneve_tag;
 }
 
+static int dr_ste_v1_build_tnl_header_0_1_tag(struct mlx5dr_match_param *value,
+					      struct mlx5dr_ste_build *sb,
+					      uint8_t *tag)
+{
+	struct mlx5dr_match_misc5 *misc5 = &value->misc5;
+
+	DR_STE_SET_TAG(tunnel_header, tag, tunnel_header_0, misc5, tunnel_header_0);
+	DR_STE_SET_TAG(tunnel_header, tag, tunnel_header_1, misc5, tunnel_header_1);
+
+	return 0;
+}
+
+static void dr_ste_v1_build_tnl_header_0_1_init(struct mlx5dr_ste_build *sb,
+						struct mlx5dr_match_param *mask)
+{
+	sb->lu_type = DR_STE_V1_LU_TYPE_FLEX_PARSER_TNL_HEADER;
+	dr_ste_v1_build_tnl_header_0_1_tag(mask, sb, sb->bit_mask);
+	sb->byte_mask = mlx5dr_ste_conv_bit_to_byte_mask(sb->bit_mask);
+	sb->ste_build_tag_func = &dr_ste_v1_build_tnl_header_0_1_tag;
+}
+
 static int dr_ste_v1_build_register_0_tag(struct mlx5dr_match_param *value,
 					  struct mlx5dr_ste_build *sb,
 					  u8 *tag)
@@ -2026,6 +2047,7 @@ struct mlx5dr_ste_ctx ste_ctx_v1 = {
 	.build_flex_parser_0_init	= &dr_ste_v1_build_flex_parser_0_init,
 	.build_flex_parser_1_init	= &dr_ste_v1_build_flex_parser_1_init,
 	.build_tnl_gtpu_init		= &dr_ste_v1_build_flex_parser_tnl_gtpu_init,
+	.build_tnl_header_0_1_init	= &dr_ste_v1_build_tnl_header_0_1_init,
 	.build_tnl_gtpu_flex_parser_0_init = &dr_ste_v1_build_tnl_gtpu_flex_parser_0_init,
 	.build_tnl_gtpu_flex_parser_1_init = &dr_ste_v1_build_tnl_gtpu_flex_parser_1_init,
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index b4987822a81a..5805e2554a59 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -456,6 +456,10 @@ void mlx5dr_ste_build_tnl_gtpu_flex_parser_1(struct mlx5dr_ste_ctx *ste_ctx,
 					     struct mlx5dr_match_param *mask,
 					     struct mlx5dr_cmd_caps *caps,
 					     bool inner, bool rx);
+void mlx5dr_ste_build_tnl_header_0_1(struct mlx5dr_ste_ctx *ste_ctx,
+				     struct mlx5dr_ste_build *sb,
+				     struct mlx5dr_match_param *mask,
+				     bool inner, bool rx);
 void mlx5dr_ste_build_general_purpose(struct mlx5dr_ste_ctx *ste_ctx,
 				      struct mlx5dr_ste_build *sb,
 				      struct mlx5dr_match_param *mask,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h
index d2a937f69784..d0e20bda2622 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h
@@ -490,6 +490,14 @@ struct mlx5_ifc_ste_flex_parser_tnl_gtpu_bits {
 	u8	   reserved_at_40[0x40];
 };
 
+struct mlx5_ifc_ste_tunnel_header_bits {
+	u8	   tunnel_header_0[0x20];
+
+	u8	   tunnel_header_1[0x20];
+
+	u8	   reserved_at_40[0x40];
+};
+
 struct mlx5_ifc_ste_general_purpose_bits {
 	u8         general_purpose_lookup_field[0x20];
 
-- 
2.33.1

