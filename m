Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED8A309385
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbhA3JiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 04:38:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:33956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233410AbhA3DKA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 22:10:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 652E964E02;
        Sat, 30 Jan 2021 02:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611973590;
        bh=EgB8yvui0N7E/Loj1UbhOvwarWawFL5CqU/pk+M5yKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JW5Z4fhb3CQJ5u2P90+4Gx10cGjTD1f4NDtaadVdgmgkeS+nwFmBamlzplz38Yx1s
         CqTa6wsvD5gBtQhT1Ub7jMvvrCSu9hjEsAbMubH/7DstBHfH0h3X6EarY3STBvnua+
         culNCejUTpvq3as72/KLIcrr3DRPz+O6IxNDHUdZ07zRePfqaRa+DXBoNbcs2Dy6m7
         4Ev2Z5ZdLaHI6b1wkMcId5Qvph2NwYV2pnvK4sFigQ1J69oL8vWONWP9shNvxPAcVv
         sBHS42VQCA1tysoC/VHTpuK1JbxSP/0jO7G7WToNZ2a+axWv3FufbtQU23mJRYsEGK
         3LKKJX6qwvuyg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/11] net/mlx5: DR, Add STEv1 setters and getters
Date:   Fri, 29 Jan 2021 18:26:12 -0800
Message-Id: <20210130022618.317351-6-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210130022618.317351-1-saeed@kernel.org>
References: <20210130022618.317351-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Add HW specific setter and getters to STEv1 file.
Since STEv0 and STEv1 format are different, each version
should implemented different setters and getters.

Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_ste_v1.c   | 76 +++++++++++++++++++
 .../mlx5/core/steering/mlx5_ifc_dr_ste_v1.h   | 57 ++++++++++++++
 2 files changed, 133 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index bf3cb189f3bc..522909f1cab6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -55,6 +55,72 @@ enum {
 	DR_STE_V1_LU_TYPE_DONT_CARE			= MLX5DR_STE_LU_TYPE_DONT_CARE,
 };
 
+static void dr_ste_v1_set_miss_addr(u8 *hw_ste_p, u64 miss_addr)
+{
+	u64 index = miss_addr >> 6;
+
+	MLX5_SET(ste_match_bwc_v1, hw_ste_p, miss_address_39_32, index >> 26);
+	MLX5_SET(ste_match_bwc_v1, hw_ste_p, miss_address_31_6, index);
+}
+
+static u64 dr_ste_v1_get_miss_addr(u8 *hw_ste_p)
+{
+	u64 index =
+		(MLX5_GET(ste_match_bwc_v1, hw_ste_p, miss_address_31_6) |
+		 MLX5_GET(ste_match_bwc_v1, hw_ste_p, miss_address_39_32) << 26);
+
+	return index << 6;
+}
+
+static void dr_ste_v1_set_byte_mask(u8 *hw_ste_p, u16 byte_mask)
+{
+	MLX5_SET(ste_match_bwc_v1, hw_ste_p, byte_mask, byte_mask);
+}
+
+static u16 dr_ste_v1_get_byte_mask(u8 *hw_ste_p)
+{
+	return MLX5_GET(ste_match_bwc_v1, hw_ste_p, byte_mask);
+}
+
+static void dr_ste_v1_set_lu_type(u8 *hw_ste_p, u16 lu_type)
+{
+	MLX5_SET(ste_match_bwc_v1, hw_ste_p, entry_format, lu_type >> 8);
+	MLX5_SET(ste_match_bwc_v1, hw_ste_p, match_definer_ctx_idx, lu_type & 0xFF);
+}
+
+static void dr_ste_v1_set_next_lu_type(u8 *hw_ste_p, u16 lu_type)
+{
+	MLX5_SET(ste_match_bwc_v1, hw_ste_p, next_entry_format, lu_type >> 8);
+	MLX5_SET(ste_match_bwc_v1, hw_ste_p, hash_definer_ctx_idx, lu_type & 0xFF);
+}
+
+static u16 dr_ste_v1_get_next_lu_type(u8 *hw_ste_p)
+{
+	u8 mode = MLX5_GET(ste_match_bwc_v1, hw_ste_p, next_entry_format);
+	u8 index = MLX5_GET(ste_match_bwc_v1, hw_ste_p, hash_definer_ctx_idx);
+
+	return (mode << 8 | index);
+}
+
+static void dr_ste_v1_set_hit_addr(u8 *hw_ste_p, u64 icm_addr, u32 ht_size)
+{
+	u64 index = (icm_addr >> 5) | ht_size;
+
+	MLX5_SET(ste_match_bwc_v1, hw_ste_p, next_table_base_39_32_size, index >> 27);
+	MLX5_SET(ste_match_bwc_v1, hw_ste_p, next_table_base_31_5_size, index);
+}
+
+static void dr_ste_v1_init(u8 *hw_ste_p, u16 lu_type,
+			   u8 entry_type, u16 gvmi)
+{
+	dr_ste_v1_set_lu_type(hw_ste_p, lu_type);
+	dr_ste_v1_set_next_lu_type(hw_ste_p, MLX5DR_STE_LU_TYPE_DONT_CARE);
+
+	MLX5_SET(ste_match_bwc_v1, hw_ste_p, gvmi, gvmi);
+	MLX5_SET(ste_match_bwc_v1, hw_ste_p, next_table_base_63_48, gvmi);
+	MLX5_SET(ste_match_bwc_v1, hw_ste_p, miss_address_63_48, gvmi);
+}
+
 static void dr_ste_v1_build_eth_l2_src_dst_bit_mask(struct mlx5dr_match_param *value,
 						    bool inner, u8 *bit_mask)
 {
@@ -885,6 +951,7 @@ static void dr_ste_v1_build_src_gvmi_qpn_init(struct mlx5dr_ste_build *sb,
 }
 
 struct mlx5dr_ste_ctx ste_ctx_v1 = {
+	/* Builders */
 	.build_eth_l2_src_dst_init	= &dr_ste_v1_build_eth_l2_src_dst_init,
 	.build_eth_l3_ipv6_src_init	= &dr_ste_v1_build_eth_l3_ipv6_src_init,
 	.build_eth_l3_ipv6_dst_init	= &dr_ste_v1_build_eth_l3_ipv6_dst_init,
@@ -905,4 +972,13 @@ struct mlx5dr_ste_ctx ste_ctx_v1 = {
 	.build_register_0_init		= &dr_ste_v1_build_register_0_init,
 	.build_register_1_init		= &dr_ste_v1_build_register_1_init,
 	.build_src_gvmi_qpn_init	= &dr_ste_v1_build_src_gvmi_qpn_init,
+	/* Getters and Setters */
+	.ste_init			= &dr_ste_v1_init,
+	.set_next_lu_type		= &dr_ste_v1_set_next_lu_type,
+	.get_next_lu_type		= &dr_ste_v1_get_next_lu_type,
+	.set_miss_addr			= &dr_ste_v1_set_miss_addr,
+	.get_miss_addr			= &dr_ste_v1_get_miss_addr,
+	.set_hit_addr			= &dr_ste_v1_set_hit_addr,
+	.set_byte_mask			= &dr_ste_v1_set_byte_mask,
+	.get_byte_mask			= &dr_ste_v1_get_byte_mask,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr_ste_v1.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr_ste_v1.h
index 6db7b8493fd9..678b048e7022 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr_ste_v1.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr_ste_v1.h
@@ -4,6 +4,63 @@
 #ifndef MLX5_IFC_DR_STE_V1_H
 #define MLX5_IFC_DR_STE_V1_H
 
+struct mlx5_ifc_ste_match_bwc_v1_bits {
+	u8         entry_format[0x8];
+	u8         counter_id[0x18];
+
+	u8         miss_address_63_48[0x10];
+	u8         match_definer_ctx_idx[0x8];
+	u8         miss_address_39_32[0x8];
+
+	u8         miss_address_31_6[0x1a];
+	u8         reserved_at_5a[0x1];
+	u8         match_polarity[0x1];
+	u8         reparse[0x1];
+	u8         reserved_at_5d[0x3];
+
+	u8         next_table_base_63_48[0x10];
+	u8         hash_definer_ctx_idx[0x8];
+	u8         next_table_base_39_32_size[0x8];
+
+	u8         next_table_base_31_5_size[0x1b];
+	u8         hash_type[0x2];
+	u8         hash_after_actions[0x1];
+	u8         reserved_at_9e[0x2];
+
+	u8         byte_mask[0x10];
+	u8         next_entry_format[0x1];
+	u8         mask_mode[0x1];
+	u8         gvmi[0xe];
+
+	u8         action[0x40];
+};
+
+struct mlx5_ifc_ste_mask_and_match_v1_bits {
+	u8         entry_format[0x8];
+	u8         counter_id[0x18];
+
+	u8         miss_address_63_48[0x10];
+	u8         match_definer_ctx_idx[0x8];
+	u8         miss_address_39_32[0x8];
+
+	u8         miss_address_31_6[0x1a];
+	u8         reserved_at_5a[0x1];
+	u8         match_polarity[0x1];
+	u8         reparse[0x1];
+	u8         reserved_at_5d[0x3];
+
+	u8         next_table_base_63_48[0x10];
+	u8         hash_definer_ctx_idx[0x8];
+	u8         next_table_base_39_32_size[0x8];
+
+	u8         next_table_base_31_5_size[0x1b];
+	u8         hash_type[0x2];
+	u8         hash_after_actions[0x1];
+	u8         reserved_at_9e[0x2];
+
+	u8         action[0x60];
+};
+
 struct mlx5_ifc_ste_eth_l2_src_v1_bits {
 	u8         reserved_at_0[0x1];
 	u8         sx_sniffer[0x1];
-- 
2.29.2

