Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F843650C9
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 05:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234546AbhDTDVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 23:21:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233920AbhDTDVH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 23:21:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 808D261354;
        Tue, 20 Apr 2021 03:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618888836;
        bh=4S7fpnaNKx3yurn/99UxciR5zv5jWl/xuqnZlDw2w8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PPii0JFRDLyOwANLMa8xpwj4F5saz2c9O+w2TAExX3PU3XcrVhiaRZ1S0v6Vs2wIn
         eIqytLS10SIOj5gsNnDaPazrVVWPnJ0aLTP973QlM3zWVMweLmL3iY4GBUR7ENUrOB
         NbMbcm0q1UJgdXG7nROx3aNI197ngrD1mKzXm1R0sIBR2ifR/QWOimnyX6mt3KwVV5
         ezveqBaHgkVMWtI4FOlWyRBAHuYKlnm89ksF7swew9vtEdflnynGsJ3q4TkvBzHPUA
         oK+pUxKFTpWpf4eCYgws+HjPqwpjzrUqHbU0M1gWQx+27GrFtBXd92d4ySQRHP09H0
         H+X39FCdxto4Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/15] net/mlx5: mlx5_ifc updates for flex parser
Date:   Mon, 19 Apr 2021 20:20:10 -0700
Message-Id: <20210420032018.58639-8-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210420032018.58639-1-saeed@kernel.org>
References: <20210420032018.58639-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Added the required definitions for supporting more protocols by flex parsers
(GTP-U, Geneve TLV options), and for using the right flex parser that was
configured for this protocol.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index f2c51d6833c6..aa6effe1dd6d 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -622,7 +622,19 @@ struct mlx5_ifc_fte_match_set_misc3_bits {
 
 	u8         geneve_tlv_option_0_data[0x20];
 
-	u8         reserved_at_140[0xc0];
+	u8	   gtpu_teid[0x20];
+
+	u8	   gtpu_msg_type[0x8];
+	u8	   gtpu_msg_flags[0x8];
+	u8	   reserved_at_170[0x10];
+
+	u8	   gtpu_dw_2[0x20];
+
+	u8	   gtpu_first_ext_dw_0[0x20];
+
+	u8	   gtpu_dw_0[0x20];
+
+	u8	   reserved_at_1e0[0x20];
 };
 
 struct mlx5_ifc_fte_match_set_misc4_bits {
@@ -1237,9 +1249,17 @@ enum {
 
 enum {
 	MLX5_FLEX_PARSER_GENEVE_ENABLED		= 1 << 3,
+	MLX5_FLEX_PARSER_MPLS_OVER_GRE_ENABLED	= 1 << 4,
+	mlx5_FLEX_PARSER_MPLS_OVER_UDP_ENABLED	= 1 << 5,
 	MLX5_FLEX_PARSER_VXLAN_GPE_ENABLED	= 1 << 7,
 	MLX5_FLEX_PARSER_ICMP_V4_ENABLED	= 1 << 8,
 	MLX5_FLEX_PARSER_ICMP_V6_ENABLED	= 1 << 9,
+	MLX5_FLEX_PARSER_GENEVE_TLV_OPTION_0_ENABLED = 1 << 10,
+	MLX5_FLEX_PARSER_GTPU_ENABLED		= 1 << 11,
+	MLX5_FLEX_PARSER_GTPU_DW_2_ENABLED	= 1 << 16,
+	MLX5_FLEX_PARSER_GTPU_FIRST_EXT_DW_0_ENABLED = 1 << 17,
+	MLX5_FLEX_PARSER_GTPU_DW_0_ENABLED	= 1 << 18,
+	MLX5_FLEX_PARSER_GTPU_TEID_ENABLED	= 1 << 19,
 };
 
 enum {
@@ -1637,7 +1657,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         cqe_compression_timeout[0x10];
 	u8         cqe_compression_max_num[0x10];
 
-	u8         reserved_at_5e0[0x10];
+	u8         reserved_at_5e0[0x8];
+	u8         flex_parser_id_gtpu_dw_0[0x4];
+	u8         reserved_at_5ec[0x4];
 	u8         tag_matching[0x1];
 	u8         rndv_offload_rc[0x1];
 	u8         rndv_offload_dc[0x1];
@@ -1648,7 +1670,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8	   affiliate_nic_vport_criteria[0x8];
 	u8	   native_port_num[0x8];
 	u8	   num_vhca_ports[0x8];
-	u8	   reserved_at_618[0x6];
+	u8         flex_parser_id_gtpu_teid[0x4];
+	u8         reserved_at_61c[0x2];
 	u8	   sw_owner_id[0x1];
 	u8         reserved_at_61f[0x1];
 
@@ -1683,7 +1706,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8	   reserved_at_6e0[0x10];
 	u8	   sf_base_id[0x10];
 
-	u8	   reserved_at_700[0x8];
+	u8         flex_parser_id_gtpu_dw_2[0x4];
+	u8         flex_parser_id_gtpu_first_ext_dw_0[0x4];
 	u8	   num_total_dynamic_vf_msix[0x18];
 	u8	   reserved_at_720[0x14];
 	u8	   dynamic_msix_table_size[0xc];
-- 
2.30.2

