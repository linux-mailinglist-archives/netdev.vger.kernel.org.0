Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4BE13650CA
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 05:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234563AbhDTDVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 23:21:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229662AbhDTDVH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 23:21:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E926D61360;
        Tue, 20 Apr 2021 03:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618888837;
        bh=+BeSAg4YTOBT1bO1koDIJPy4yJSyejawUse7VTKgHqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LRG1FHbs/r/w4PFyVUu24TWBkcPdkw4iFecMkUDiTyKeOaU1eZG79jmbS5iuNaOMS
         dsz5m78ohgdzKoOyLxyfINjmTDrbQkCdNFGHvdmg+rGvUrnOjDOC7qORS5LxusG5IH
         +DWXETI83u/yJDIzKJoZEgAW7FFeP66b9feGuivZiqdwrzjj1R3yQiQDaYNY2QSoXs
         1EW7+ZCEEO9z5Bg5Ggfv7TH6MVEagNg4lIrghDAO0iDoKbrZzp+6HMzmcnVxnBnJY7
         4w0FLI/J8SWF38uxXfocdb/n8///lRkjEVdPpkXgHKmW5CIG+pWG4C7mXxA3BhVm8Q
         1cZ5uLglw3bFg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Muhammad Sammar <muhammads@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/15] net/mlx5: DR, Remove protocol-specific flex_parser_3 definitions
Date:   Mon, 19 Apr 2021 20:20:11 -0700
Message-Id: <20210420032018.58639-9-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210420032018.58639-1-saeed@kernel.org>
References: <20210420032018.58639-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Muhammad Sammar <muhammads@nvidia.com>

Remove MPLS specific fields from flex parser 3 layout.
Flex parser can be used for multiple protocols and should
not be hardcoded to a specific type.

Signed-off-by: Muhammad Sammar <muhammads@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_ste.h      |  7 ++++
 .../mellanox/mlx5/core/steering/dr_ste_v0.c   | 41 +++++++++----------
 .../mellanox/mlx5/core/steering/mlx5_ifc_dr.h |  5 +--
 3 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
index 06bcb0ee8f96..eb0384150675 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
@@ -86,6 +86,13 @@ enum dr_ste_action_modify_type_l4 {
 	DR_STE_ACTION_MDFY_TYPE_L4_UDP	= 0x2,
 };
 
+enum {
+	HDR_MPLS_OFFSET_LABEL	= 12,
+	HDR_MPLS_OFFSET_EXP	= 9,
+	HDR_MPLS_OFFSET_S_BOS	= 8,
+	HDR_MPLS_OFFSET_TTL	= 0,
+};
+
 u16 mlx5dr_ste_conv_bit_to_byte_mask(u8 *bit_mask);
 
 #define DR_STE_CTX_BUILDER(fname) \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
index c5f62d2a058f..d9ac57d94609 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
@@ -1248,32 +1248,29 @@ dr_ste_v0_build_tnl_mpls_tag(struct mlx5dr_match_param *value,
 			     u8 *tag)
 {
 	struct mlx5dr_match_misc2 *misc_2 = &value->misc2;
+	u32 mpls_hdr;
 
 	if (DR_STE_IS_OUTER_MPLS_OVER_GRE_SET(misc_2)) {
-		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_label,
-			       misc_2, outer_first_mpls_over_gre_label);
-
-		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_exp,
-			       misc_2, outer_first_mpls_over_gre_exp);
-
-		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_s_bos,
-			       misc_2, outer_first_mpls_over_gre_s_bos);
-
-		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_ttl,
-			       misc_2, outer_first_mpls_over_gre_ttl);
+		mpls_hdr = misc_2->outer_first_mpls_over_gre_label << HDR_MPLS_OFFSET_LABEL;
+		misc_2->outer_first_mpls_over_gre_label = 0;
+		mpls_hdr |= misc_2->outer_first_mpls_over_gre_exp << HDR_MPLS_OFFSET_EXP;
+		misc_2->outer_first_mpls_over_gre_exp = 0;
+		mpls_hdr |= misc_2->outer_first_mpls_over_gre_s_bos << HDR_MPLS_OFFSET_S_BOS;
+		misc_2->outer_first_mpls_over_gre_s_bos = 0;
+		mpls_hdr |= misc_2->outer_first_mpls_over_gre_ttl << HDR_MPLS_OFFSET_TTL;
+		misc_2->outer_first_mpls_over_gre_ttl = 0;
 	} else {
-		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_label,
-			       misc_2, outer_first_mpls_over_udp_label);
-
-		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_exp,
-			       misc_2, outer_first_mpls_over_udp_exp);
-
-		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_s_bos,
-			       misc_2, outer_first_mpls_over_udp_s_bos);
-
-		DR_STE_SET_TAG(flex_parser_0, tag, parser_3_ttl,
-			       misc_2, outer_first_mpls_over_udp_ttl);
+		mpls_hdr = misc_2->outer_first_mpls_over_udp_label << HDR_MPLS_OFFSET_LABEL;
+		misc_2->outer_first_mpls_over_udp_label = 0;
+		mpls_hdr |= misc_2->outer_first_mpls_over_udp_exp << HDR_MPLS_OFFSET_EXP;
+		misc_2->outer_first_mpls_over_udp_exp = 0;
+		mpls_hdr |= misc_2->outer_first_mpls_over_udp_s_bos << HDR_MPLS_OFFSET_S_BOS;
+		misc_2->outer_first_mpls_over_udp_s_bos = 0;
+		mpls_hdr |= misc_2->outer_first_mpls_over_udp_ttl << HDR_MPLS_OFFSET_TTL;
+		misc_2->outer_first_mpls_over_udp_ttl = 0;
 	}
+
+	MLX5_SET(ste_flex_parser_0, tag, flex_parser_3, mpls_hdr);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h
index 83df6df6b459..601bbb3a107c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h
@@ -434,10 +434,7 @@ struct mlx5_ifc_ste_gre_bits {
 };
 
 struct mlx5_ifc_ste_flex_parser_0_bits {
-	u8         parser_3_label[0x14];
-	u8         parser_3_exp[0x3];
-	u8         parser_3_s_bos[0x1];
-	u8         parser_3_ttl[0x8];
+	u8         flex_parser_3[0x20];
 
 	u8         flex_parser_2[0x20];
 
-- 
2.30.2

