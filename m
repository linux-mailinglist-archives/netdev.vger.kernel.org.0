Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0514F2EB5DB
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 00:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbhAEXGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 18:06:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:57454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727431AbhAEXG1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 18:06:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F3EE230FF;
        Tue,  5 Jan 2021 23:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609887912;
        bh=FypieeRHg/bJW9fFx6M0PF2OVD4WBU8QReS+CHel5AA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R/oddTj9iBFCcGNfCMBfQe5M0fyTezpDrH+K9SfZDVj0i3bAYu6Oe6tdeeXJhMzTe
         QGYErEfbuGAEjlWk9JC2qHcIaeoyBQ+ouIINbBXlonqGmw7w1G1xISLMBFPSd0B+aQ
         3I/1wEr6qckw1Wxo5FONQdqbnKjtBQMxsUTDNakSpy4JEAidDRmInvVssbL6Mo1WgK
         vgaX158qT0Cg7RqVaud0U7sXk3yLq8M/SKcSgdXwf3uEppjMhm8JdpWVl1/7Ril9jZ
         lsxC9na5jSBohyxdMRad1BPup+AIhkHMb52AfwPGF7nfrtrULCD3/DR2MBEwk7FYky
         KZ7v4DwSD+bEg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/16] net/mlx5: DR, Refactor ICMP STE builder
Date:   Tue,  5 Jan 2021 15:03:26 -0800
Message-Id: <20210105230333.239456-10-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210105230333.239456-1-saeed@kernel.org>
References: <20210105230333.239456-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Reworked ICMP tag builder to better handle ICMP v4/6 fields and avoid unneeded
code duplication and 'if' statements, removed unused macro, changed bitfield
of len 8 to u8.

Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_ste_v0.c   | 57 +++++++------------
 .../mellanox/mlx5/core/steering/dr_types.h    |  8 +--
 2 files changed, 23 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
index d18f8f9c794a..2d8a7b1791d0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
@@ -662,9 +662,8 @@ dr_ste_v0_build_tnl_mpls_init(struct mlx5dr_ste_build *sb,
 	sb->ste_build_tag_func = &dr_ste_v0_build_tnl_mpls_tag;
 }
 
-#define ICMP_TYPE_OFFSET_FIRST_DW		24
-#define ICMP_CODE_OFFSET_FIRST_DW		16
-#define ICMP_HEADER_DATA_OFFSET_SECOND_DW	0
+#define ICMP_TYPE_OFFSET_FIRST_DW	24
+#define ICMP_CODE_OFFSET_FIRST_DW	16
 
 static int
 dr_ste_v0_build_icmp_tag(struct mlx5dr_match_param *value,
@@ -672,49 +671,36 @@ dr_ste_v0_build_icmp_tag(struct mlx5dr_match_param *value,
 			 u8 *tag)
 {
 	struct mlx5dr_match_misc3 *misc_3 = &value->misc3;
-	u32 icmp_header_data;
+	u32 *icmp_header_data;
 	int dw0_location;
 	int dw1_location;
-	u32 icmp_type;
-	u32 icmp_code;
+	u8 *icmp_type;
+	u8 *icmp_code;
 	bool is_ipv4;
 
 	is_ipv4 = DR_MASK_IS_ICMPV4_SET(misc_3);
 	if (is_ipv4) {
-		icmp_header_data	= misc_3->icmpv4_header_data;
-		icmp_type		= misc_3->icmpv4_type;
-		icmp_code		= misc_3->icmpv4_code;
+		icmp_header_data	= &misc_3->icmpv4_header_data;
+		icmp_type		= &misc_3->icmpv4_type;
+		icmp_code		= &misc_3->icmpv4_code;
 		dw0_location		= sb->caps->flex_parser_id_icmp_dw0;
 		dw1_location		= sb->caps->flex_parser_id_icmp_dw1;
 	} else {
-		icmp_header_data	= misc_3->icmpv6_header_data;
-		icmp_type		= misc_3->icmpv6_type;
-		icmp_code		= misc_3->icmpv6_code;
+		icmp_header_data	= &misc_3->icmpv6_header_data;
+		icmp_type		= &misc_3->icmpv6_type;
+		icmp_code		= &misc_3->icmpv6_code;
 		dw0_location		= sb->caps->flex_parser_id_icmpv6_dw0;
 		dw1_location		= sb->caps->flex_parser_id_icmpv6_dw1;
 	}
 
 	switch (dw0_location) {
 	case 4:
-		if (icmp_type) {
-			MLX5_SET(ste_flex_parser_1, tag, flex_parser_4,
-				 (icmp_type << ICMP_TYPE_OFFSET_FIRST_DW));
-			if (is_ipv4)
-				misc_3->icmpv4_type = 0;
-			else
-				misc_3->icmpv6_type = 0;
-		}
+		MLX5_SET(ste_flex_parser_1, tag, flex_parser_4,
+			 (*icmp_type << ICMP_TYPE_OFFSET_FIRST_DW) |
+			 (*icmp_code << ICMP_TYPE_OFFSET_FIRST_DW));
 
-		if (icmp_code) {
-			u32 cur_val = MLX5_GET(ste_flex_parser_1, tag,
-					       flex_parser_4);
-			MLX5_SET(ste_flex_parser_1, tag, flex_parser_4,
-				 cur_val | (icmp_code << ICMP_CODE_OFFSET_FIRST_DW));
-			if (is_ipv4)
-				misc_3->icmpv4_code = 0;
-			else
-				misc_3->icmpv6_code = 0;
-		}
+		*icmp_type = 0;
+		*icmp_code = 0;
 		break;
 	default:
 		return -EINVAL;
@@ -722,14 +708,9 @@ dr_ste_v0_build_icmp_tag(struct mlx5dr_match_param *value,
 
 	switch (dw1_location) {
 	case 5:
-		if (icmp_header_data) {
-			MLX5_SET(ste_flex_parser_1, tag, flex_parser_5,
-				 (icmp_header_data << ICMP_HEADER_DATA_OFFSET_SECOND_DW));
-			if (is_ipv4)
-				misc_3->icmpv4_header_data = 0;
-			else
-				misc_3->icmpv6_header_data = 0;
-		}
+		MLX5_SET(ste_flex_parser_1, tag, flex_parser_5,
+			 *icmp_header_data);
+		*icmp_header_data = 0;
 		break;
 	default:
 		return -EINVAL;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index c89afc211226..5bd82c358069 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -596,10 +596,10 @@ struct mlx5dr_match_misc3 {
 	u32 outer_vxlan_gpe_next_protocol:8;
 	u32 icmpv4_header_data;
 	u32 icmpv6_header_data;
-	u32 icmpv6_code:8;
-	u32 icmpv6_type:8;
-	u32 icmpv4_code:8;
-	u32 icmpv4_type:8;
+	u8 icmpv6_code;
+	u8 icmpv6_type;
+	u8 icmpv4_code;
+	u8 icmpv4_type;
 	u8 reserved_auto3[0x1c];
 };
 
-- 
2.26.2

