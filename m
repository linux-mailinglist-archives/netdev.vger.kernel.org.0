Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9CA741E4AD
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 01:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347316AbhI3XWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 19:22:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230172AbhI3XWh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 19:22:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F403A619F5;
        Thu, 30 Sep 2021 23:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633044054;
        bh=sZUYErglcZjK1ElRGf+JVTwOb/oSMUkxC3r8vXzuj8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a3AnlMYFpcWwjaRVjElvARaGKm9BVnbxdwkylAwWCWMDMbDO45S55nfwv41JIDOql
         bnVVeJjyMqLHw/jYPl8T4YRkP2Dq2xXcqh/uXIjSDHt3nhTQEejns8rQsc1gbFcriz
         9RnU6Km6xSNPKe+aJy/xR7KHmrns8V/O9goDk4BvsdAA30ffPGNKp9sYkyQhO8Vg2o
         LtHaTAYDdwgzaUtscAjXfMF9wKWsKmRUdwOD3zYP3L3+GqjQhRd4O7aW483o6B3rgZ
         sA0LvEcCDsj8HPrC+kBo6nFRpVjLbqYFgxTv0x/VA6KLmDCvKKlgITsSsWhEl1QtB4
         qSgIubECH4NVA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Muhammad Sammar <muhammads@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/15] net/mlx5: DR, Fix vport number data type to u16
Date:   Thu, 30 Sep 2021 16:20:36 -0700
Message-Id: <20210930232050.41779-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930232050.41779-1-saeed@kernel.org>
References: <20210930232050.41779-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

According to the HW spec, vport number is a 16-bit value.
Fix vport usage all over the code to u16 data type.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Muhammad Sammar <muhammads@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/steering/dr_action.c   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c  |  4 ++--
 .../ethernet/mellanox/mlx5/core/steering/dr_domain.c   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/steering/dr_fw.c   |  2 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_types.h    | 10 +++++-----
 .../net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |  2 +-
 6 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index a5b9f65db23c..032b4a2546d3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -1747,7 +1747,7 @@ mlx5dr_action_create_modify_header(struct mlx5dr_domain *dmn,
 
 struct mlx5dr_action *
 mlx5dr_action_create_dest_vport(struct mlx5dr_domain *dmn,
-				u32 vport, u8 vhca_id_valid,
+				u16 vport, u8 vhca_id_valid,
 				u16 vhca_id)
 {
 	struct mlx5dr_cmd_vport_cap *vport_cap;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
index 56307283bf9b..0f69321b3269 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -272,7 +272,7 @@ int mlx5dr_cmd_set_fte_modify_and_vport(struct mlx5_core_dev *mdev,
 					u32 table_id,
 					u32 group_id,
 					u32 modify_header_id,
-					u32 vport_id)
+					u16 vport)
 {
 	u32 out[MLX5_ST_SZ_DW(set_fte_out)] = {};
 	void *in_flow_context;
@@ -303,7 +303,7 @@ int mlx5dr_cmd_set_fte_modify_and_vport(struct mlx5_core_dev *mdev,
 	in_dests = MLX5_ADDR_OF(flow_context, in_flow_context, destination);
 	MLX5_SET(dest_format_struct, in_dests, destination_type,
 		 MLX5_FLOW_DESTINATION_TYPE_VPORT);
-	MLX5_SET(dest_format_struct, in_dests, destination_id, vport_id);
+	MLX5_SET(dest_format_struct, in_dests, destination_id, vport);
 
 	err = mlx5_cmd_exec(mdev, in, inlen, out, sizeof(out));
 	kvfree(in);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
index 0fe159809ba1..ca299d480579 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -38,7 +38,7 @@ static void dr_domain_uninit_cache(struct mlx5dr_domain *dmn)
 }
 
 int mlx5dr_domain_cache_get_recalc_cs_ft_addr(struct mlx5dr_domain *dmn,
-					      u32 vport_num,
+					      u16 vport_num,
 					      u64 *rx_icm_addr)
 {
 	struct mlx5dr_fw_recalc_cs_ft *recalc_cs_ft;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c
index 0d6f86eb248b..68a4c32d5f34 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c
@@ -5,7 +5,7 @@
 #include "dr_types.h"
 
 struct mlx5dr_fw_recalc_cs_ft *
-mlx5dr_fw_create_recalc_cs_ft(struct mlx5dr_domain *dmn, u32 vport_num)
+mlx5dr_fw_create_recalc_cs_ft(struct mlx5dr_domain *dmn, u16 vport_num)
 {
 	struct mlx5dr_cmd_create_flow_table_attr ft_attr = {};
 	struct mlx5dr_fw_recalc_cs_ft *recalc_cs_ft;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index b20e8aabb861..441c03e645db 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -752,9 +752,9 @@ struct mlx5dr_esw_caps {
 struct mlx5dr_cmd_vport_cap {
 	u16 vport_gvmi;
 	u16 vhca_gvmi;
+	u16 num;
 	u64 icm_address_rx;
 	u64 icm_address_tx;
-	u32 num;
 };
 
 struct mlx5dr_roce_cap {
@@ -1103,7 +1103,7 @@ mlx5dr_ste_htbl_may_grow(struct mlx5dr_ste_htbl *htbl)
 }
 
 static inline struct mlx5dr_cmd_vport_cap *
-mlx5dr_get_vport_cap(struct mlx5dr_cmd_caps *caps, u32 vport)
+mlx5dr_get_vport_cap(struct mlx5dr_cmd_caps *caps, u16 vport)
 {
 	if (!caps->vports_caps ||
 	    (vport >= caps->num_vports && vport != WIRE_PORT))
@@ -1154,7 +1154,7 @@ int mlx5dr_cmd_set_fte_modify_and_vport(struct mlx5_core_dev *mdev,
 					u32 table_id,
 					u32 group_id,
 					u32 modify_header_id,
-					u32 vport_id);
+					u16 vport_id);
 int mlx5dr_cmd_del_flow_table_entry(struct mlx5_core_dev *mdev,
 				    u32 table_type,
 				    u32 table_id);
@@ -1372,11 +1372,11 @@ struct mlx5dr_fw_recalc_cs_ft {
 };
 
 struct mlx5dr_fw_recalc_cs_ft *
-mlx5dr_fw_create_recalc_cs_ft(struct mlx5dr_domain *dmn, u32 vport_num);
+mlx5dr_fw_create_recalc_cs_ft(struct mlx5dr_domain *dmn, u16 vport_num);
 void mlx5dr_fw_destroy_recalc_cs_ft(struct mlx5dr_domain *dmn,
 				    struct mlx5dr_fw_recalc_cs_ft *recalc_cs_ft);
 int mlx5dr_domain_cache_get_recalc_cs_ft_addr(struct mlx5dr_domain *dmn,
-					      u32 vport_num,
+					      u16 vport_num,
 					      u64 *rx_icm_addr);
 int mlx5dr_fw_create_md_tbl(struct mlx5dr_domain *dmn,
 			    struct mlx5dr_cmd_flow_destination_hw_info *dest,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index c5a8b1601999..c7c93131b762 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -89,7 +89,7 @@ mlx5dr_action_create_dest_flow_fw_table(struct mlx5dr_domain *domain,
 
 struct mlx5dr_action *
 mlx5dr_action_create_dest_vport(struct mlx5dr_domain *domain,
-				u32 vport, u8 vhca_id_valid,
+				u16 vport, u8 vhca_id_valid,
 				u16 vhca_id);
 
 struct mlx5dr_action *
-- 
2.31.1

