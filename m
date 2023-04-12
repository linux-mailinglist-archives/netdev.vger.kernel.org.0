Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB6DB6DEA31
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 06:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjDLEI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 00:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjDLEI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 00:08:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 990E659E4
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 21:08:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4776462D9E
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 04:08:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988E7C4339B;
        Wed, 12 Apr 2023 04:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681272493;
        bh=OAMbT/mTzE44ifStltscH+182C4xaXvhTgWl7RxTg1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tGciMSbZb8/5t2v1eCLAXqJxoVjz8A5+M6wLdkV/5uYN9R4sCTm1hrDV0JV5M7X3U
         Ej6JTsLZ6snP9aL6qKFqFnTBqgB8jH/xy66lSQZdZ6Vt7ilpRZgVS9Ni/+UgC0jHWM
         nxxXxJO7yxgEL0rOW1yhJKxUViYecZs4EB4VNJFzCaZgMy231eViUk56uF57z7C2xp
         dQFhvv1kHvYrKjO1Sf3sHG5S+7NDm2NLarWbgwhg6tYiQvFu2Mg6iI2kJ973KnoFw4
         bWdUl5xL1qe91meCv0phGpB/kSha7Exa0CnvnwC/+IrJdYBjK8dzOoeLdBInfgRFGg
         F1VzzZi4k3Llg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Muhammad Sammar <muhammads@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next 15/15] net/mlx5: DR, Add modify-header-pattern ICM pool
Date:   Tue, 11 Apr 2023 21:07:52 -0700
Message-Id: <20230412040752.14220-16-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230412040752.14220-1-saeed@kernel.org>
References: <20230412040752.14220-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

There is a new ICM area for that memory, so we need to handle it as we
did for the others ICM types.
The patch added that specific pool with its requirements and management.

Signed-off-by: Muhammad Sammar <muhammads@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  2 +-
 .../mellanox/mlx5/core/steering/dr_cmd.c      |  6 +++
 .../mellanox/mlx5/core/steering/dr_domain.c   | 45 +++++++++++++++++--
 .../mellanox/mlx5/core/steering/dr_icm_pool.c | 41 ++++++++++++-----
 .../mellanox/mlx5/core/steering/dr_ptrn.c     | 43 ++++++++++++++++++
 .../mellanox/mlx5/core/steering/dr_types.h    | 11 +++++
 6 files changed, 132 insertions(+), 16 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ptrn.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 4a009b720bee..39c2c8dc7e07 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -112,7 +112,7 @@ mlx5_core-$(CONFIG_MLX5_SW_STEERING) += steering/dr_domain.o steering/dr_table.o
 					steering/dr_ste_v2.o \
 					steering/dr_cmd.o steering/dr_fw.o \
 					steering/dr_action.o steering/fs_dr.o \
-					steering/dr_definer.o \
+					steering/dr_definer.o steering/dr_ptrn.o \
 					steering/dr_dbg.o lib/smfs.o
 #
 # SF device
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
index 07b6a6dcb92f..229f3684100c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -200,6 +200,12 @@ int mlx5dr_cmd_query_device(struct mlx5_core_dev *mdev,
 	caps->hdr_modify_icm_addr =
 		MLX5_CAP64_DEV_MEM(mdev, header_modify_sw_icm_start_address);
 
+	caps->log_modify_pattern_icm_size =
+		MLX5_CAP_DEV_MEM(mdev, log_header_modify_pattern_sw_icm_size);
+
+	caps->hdr_modify_pattern_icm_addr =
+		MLX5_CAP64_DEV_MEM(mdev, header_modify_pattern_sw_icm_start_address);
+
 	caps->roce_min_src_udp = MLX5_CAP_ROCE(mdev, r_roce_min_src_udp_port);
 
 	caps->is_ecpf = mlx5_core_is_ecpf_esw_manager(mdev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
index 5b8bb2ca31e6..7a0381572c4c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -10,6 +10,33 @@
 	 ((dmn)->info.caps.dmn_type##_sw_owner_v2 &&	\
 	  (dmn)->info.caps.sw_format_ver <= MLX5_STEERING_FORMAT_CONNECTX_7))
 
+bool mlx5dr_domain_is_support_ptrn_arg(struct mlx5dr_domain *dmn)
+{
+	return false;
+}
+
+static int dr_domain_init_modify_header_resources(struct mlx5dr_domain *dmn)
+{
+	if (!mlx5dr_domain_is_support_ptrn_arg(dmn))
+		return 0;
+
+	dmn->ptrn_mgr = mlx5dr_ptrn_mgr_create(dmn);
+	if (!dmn->ptrn_mgr) {
+		mlx5dr_err(dmn, "Couldn't create ptrn_mgr\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void dr_domain_destroy_modify_header_resources(struct mlx5dr_domain *dmn)
+{
+	if (!mlx5dr_domain_is_support_ptrn_arg(dmn))
+		return;
+
+	mlx5dr_ptrn_mgr_destroy(dmn->ptrn_mgr);
+}
+
 static void dr_domain_init_csum_recalc_fts(struct mlx5dr_domain *dmn)
 {
 	/* Per vport cached FW FT for checksum recalculation, this
@@ -149,14 +176,22 @@ static int dr_domain_init_resources(struct mlx5dr_domain *dmn)
 		goto clean_uar;
 	}
 
+	ret = dr_domain_init_modify_header_resources(dmn);
+	if (ret) {
+		mlx5dr_err(dmn, "Couldn't create modify-header-resources\n");
+		goto clean_mem_resources;
+	}
+
 	ret = mlx5dr_send_ring_alloc(dmn);
 	if (ret) {
 		mlx5dr_err(dmn, "Couldn't create send-ring\n");
-		goto clean_mem_resources;
+		goto clean_modify_hdr;
 	}
 
 	return 0;
 
+clean_modify_hdr:
+	dr_domain_destroy_modify_header_resources(dmn);
 clean_mem_resources:
 	dr_domain_uninit_mem_resources(dmn);
 clean_uar:
@@ -170,6 +205,7 @@ static int dr_domain_init_resources(struct mlx5dr_domain *dmn)
 static void dr_domain_uninit_resources(struct mlx5dr_domain *dmn)
 {
 	mlx5dr_send_ring_free(dmn, dmn->send_ring);
+	dr_domain_destroy_modify_header_resources(dmn);
 	dr_domain_uninit_mem_resources(dmn);
 	mlx5_put_uars_page(dmn->mdev, dmn->uar);
 	mlx5_core_dealloc_pd(dmn->mdev, dmn->pdn);
@@ -215,7 +251,7 @@ static int dr_domain_query_vport(struct mlx5dr_domain *dmn,
 	return 0;
 }
 
-static int dr_domain_query_esw_mngr(struct mlx5dr_domain *dmn)
+static int dr_domain_query_esw_mgr(struct mlx5dr_domain *dmn)
 {
 	return dr_domain_query_vport(dmn, 0, false,
 				     &dmn->info.caps.vports.esw_manager_caps);
@@ -321,7 +357,7 @@ static int dr_domain_query_fdb_caps(struct mlx5_core_dev *mdev,
 	 * vports (vport 0, VFs and SFs) will be queried dynamically.
 	 */
 
-	ret = dr_domain_query_esw_mngr(dmn);
+	ret = dr_domain_query_esw_mgr(dmn);
 	if (ret) {
 		mlx5dr_err(dmn, "Failed to query eswitch manager vport caps (err: %d)", ret);
 		goto free_vports_caps_xa;
@@ -435,6 +471,9 @@ mlx5dr_domain_create(struct mlx5_core_dev *mdev, enum mlx5dr_domain_type type)
 	dmn->info.max_log_action_icm_sz = DR_CHUNK_SIZE_4K;
 	dmn->info.max_log_sw_icm_sz = min_t(u32, DR_CHUNK_SIZE_1024K,
 					    dmn->info.caps.log_icm_size);
+	dmn->info.max_log_modify_hdr_pattern_icm_sz =
+		min_t(u32, DR_CHUNK_SIZE_4K,
+		      dmn->info.caps.log_modify_pattern_icm_size);
 
 	if (!dmn->info.supp_sw_steering) {
 		mlx5dr_err(dmn, "SW steering is not supported\n");
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
index 3eb6719bc8eb..04fc170a6c16 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
@@ -107,9 +107,9 @@ static struct mlx5dr_icm_mr *
 dr_icm_pool_mr_create(struct mlx5dr_icm_pool *pool)
 {
 	struct mlx5_core_dev *mdev = pool->dmn->mdev;
-	enum mlx5_sw_icm_type dm_type;
+	enum mlx5_sw_icm_type dm_type = 0;
 	struct mlx5dr_icm_mr *icm_mr;
-	size_t log_align_base;
+	size_t log_align_base = 0;
 	int err;
 
 	icm_mr = kvzalloc(sizeof(*icm_mr), GFP_KERNEL);
@@ -121,14 +121,25 @@ dr_icm_pool_mr_create(struct mlx5dr_icm_pool *pool)
 	icm_mr->dm.length = mlx5dr_icm_pool_chunk_size_to_byte(pool->max_log_chunk_sz,
 							       pool->icm_type);
 
-	if (pool->icm_type == DR_ICM_TYPE_STE) {
+	switch (pool->icm_type) {
+	case DR_ICM_TYPE_STE:
 		dm_type = MLX5_SW_ICM_TYPE_STEERING;
 		log_align_base = ilog2(icm_mr->dm.length);
-	} else {
+		break;
+	case DR_ICM_TYPE_MODIFY_ACTION:
 		dm_type = MLX5_SW_ICM_TYPE_HEADER_MODIFY;
 		/* Align base is 64B */
 		log_align_base = ilog2(DR_ICM_MODIFY_HDR_ALIGN_BASE);
+		break;
+	case DR_ICM_TYPE_MODIFY_HDR_PTRN:
+		dm_type = MLX5_SW_ICM_TYPE_HEADER_MODIFY_PATTERN;
+		/* Align base is 64B */
+		log_align_base = ilog2(DR_ICM_MODIFY_HDR_ALIGN_BASE);
+		break;
+	default:
+		WARN_ON(pool->icm_type);
 	}
+
 	icm_mr->dm.type = dm_type;
 
 	err = mlx5_dm_sw_icm_alloc(mdev, icm_mr->dm.type, icm_mr->dm.length,
@@ -493,27 +504,33 @@ struct mlx5dr_icm_pool *mlx5dr_icm_pool_create(struct mlx5dr_domain *dmn,
 					       enum mlx5dr_icm_type icm_type)
 {
 	u32 num_of_chunks, entry_size, max_hot_size;
-	enum mlx5dr_icm_chunk_size max_log_chunk_sz;
 	struct mlx5dr_icm_pool *pool;
 
-	if (icm_type == DR_ICM_TYPE_STE)
-		max_log_chunk_sz = dmn->info.max_log_sw_icm_sz;
-	else
-		max_log_chunk_sz = dmn->info.max_log_action_icm_sz;
-
 	pool = kvzalloc(sizeof(*pool), GFP_KERNEL);
 	if (!pool)
 		return NULL;
 
 	pool->dmn = dmn;
 	pool->icm_type = icm_type;
-	pool->max_log_chunk_sz = max_log_chunk_sz;
 	pool->chunks_kmem_cache = dmn->chunks_kmem_cache;
 
 	INIT_LIST_HEAD(&pool->buddy_mem_list);
-
 	mutex_init(&pool->mutex);
 
+	switch (icm_type) {
+	case DR_ICM_TYPE_STE:
+		pool->max_log_chunk_sz = dmn->info.max_log_sw_icm_sz;
+		break;
+	case DR_ICM_TYPE_MODIFY_ACTION:
+		pool->max_log_chunk_sz = dmn->info.max_log_action_icm_sz;
+		break;
+	case DR_ICM_TYPE_MODIFY_HDR_PTRN:
+		pool->max_log_chunk_sz = dmn->info.max_log_modify_hdr_pattern_icm_sz;
+		break;
+	default:
+		WARN_ON(icm_type);
+	}
+
 	entry_size = mlx5dr_icm_pool_dm_type_to_entry_size(pool->icm_type);
 
 	max_hot_size = mlx5dr_icm_pool_chunk_size_to_byte(pool->max_log_chunk_sz,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ptrn.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ptrn.c
new file mode 100644
index 000000000000..698e79d278bf
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ptrn.c
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+
+#include "dr_types.h"
+
+struct mlx5dr_ptrn_mgr {
+	struct mlx5dr_domain *dmn;
+	struct mlx5dr_icm_pool *ptrn_icm_pool;
+};
+
+struct mlx5dr_ptrn_mgr *mlx5dr_ptrn_mgr_create(struct mlx5dr_domain *dmn)
+{
+	struct mlx5dr_ptrn_mgr *mgr;
+
+	if (!mlx5dr_domain_is_support_ptrn_arg(dmn))
+		return NULL;
+
+	mgr = kzalloc(sizeof(*mgr), GFP_KERNEL);
+	if (!mgr)
+		return NULL;
+
+	mgr->dmn = dmn;
+	mgr->ptrn_icm_pool = mlx5dr_icm_pool_create(dmn, DR_ICM_TYPE_MODIFY_HDR_PTRN);
+	if (!mgr->ptrn_icm_pool) {
+		mlx5dr_err(dmn, "Couldn't get modify-header-pattern memory\n");
+		goto free_mgr;
+	}
+
+	return mgr;
+
+free_mgr:
+	kfree(mgr);
+	return NULL;
+}
+
+void mlx5dr_ptrn_mgr_destroy(struct mlx5dr_ptrn_mgr *mgr)
+{
+	if (!mgr)
+		return;
+
+	mlx5dr_icm_pool_destroy(mgr->ptrn_icm_pool);
+	kfree(mgr);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 2b769dcbd453..5b9faa714f42 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -26,6 +26,8 @@
 #define mlx5dr_info(dmn, arg...) mlx5_core_info((dmn)->mdev, ##arg)
 #define mlx5dr_dbg(dmn, arg...) mlx5_core_dbg((dmn)->mdev, ##arg)
 
+struct mlx5dr_ptrn_mgr;
+
 static inline bool dr_is_flex_parser_0_id(u8 parser_id)
 {
 	return parser_id <= DR_STE_MAX_FLEX_0_ID;
@@ -66,6 +68,7 @@ enum mlx5dr_icm_chunk_size {
 enum mlx5dr_icm_type {
 	DR_ICM_TYPE_STE,
 	DR_ICM_TYPE_MODIFY_ACTION,
+	DR_ICM_TYPE_MODIFY_HDR_PTRN,
 };
 
 static inline enum mlx5dr_icm_chunk_size
@@ -861,6 +864,8 @@ struct mlx5dr_cmd_caps {
 	u64 esw_tx_drop_address;
 	u32 log_icm_size;
 	u64 hdr_modify_icm_addr;
+	u32 log_modify_pattern_icm_size;
+	u64 hdr_modify_pattern_icm_addr;
 	u32 flex_protocols;
 	u8 flex_parser_id_icmp_dw0;
 	u8 flex_parser_id_icmp_dw1;
@@ -910,6 +915,7 @@ struct mlx5dr_domain_info {
 	u32 max_send_wr;
 	u32 max_log_sw_icm_sz;
 	u32 max_log_action_icm_sz;
+	u32 max_log_modify_hdr_pattern_icm_sz;
 	struct mlx5dr_domain_rx_tx rx;
 	struct mlx5dr_domain_rx_tx tx;
 	struct mlx5dr_cmd_caps caps;
@@ -928,6 +934,7 @@ struct mlx5dr_domain {
 	struct mlx5dr_send_info_pool *send_info_pool_tx;
 	struct kmem_cache *chunks_kmem_cache;
 	struct kmem_cache *htbls_kmem_cache;
+	struct mlx5dr_ptrn_mgr *ptrn_mgr;
 	struct mlx5dr_send_ring *send_ring;
 	struct mlx5dr_domain_info info;
 	struct xarray csum_fts_xa;
@@ -1526,4 +1533,8 @@ static inline bool mlx5dr_supp_match_ranges(struct mlx5_core_dev *dev)
 			(1ULL << MLX5_IFC_DEFINER_FORMAT_ID_SELECT));
 }
 
+bool mlx5dr_domain_is_support_ptrn_arg(struct mlx5dr_domain *dmn);
+struct mlx5dr_ptrn_mgr *mlx5dr_ptrn_mgr_create(struct mlx5dr_domain *dmn);
+void mlx5dr_ptrn_mgr_destroy(struct mlx5dr_ptrn_mgr *mgr);
+
 #endif  /* _DR_TYPES_H_ */
-- 
2.39.2

