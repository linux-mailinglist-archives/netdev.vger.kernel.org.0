Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C793A6E2C53
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 00:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbjDNWKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 18:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbjDNWJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 18:09:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA0949E8
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 15:09:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 679A664A8A
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 22:09:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65B2C433EF;
        Fri, 14 Apr 2023 22:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681510188;
        bh=JFMLEM8hw2/ZTdL/NMNbIwkQRj1yMsSJmGJytmmRzKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J5D/ErACjIyS+QuiuylfxHQXU5YD7gpROQ7xXZ8wvgryvaL16OMwN60fh63Hczc7K
         zdS3eSM/oAl9/4UNtEJNMEJVgwXux+uPxwNUeG7XxkmGEX0cZCzVkUTkqIE/fOEKCy
         zW0Y8z2bsqcmWhituKR7R8bvzrQ28GepumkB4C9jZMLBZr5zQM2Q+PR4PV5Bnfdyeb
         4Zc4H2D3xvquJJMwmNv2X9m4zqjsYgtopfpgW61xkvQupyIKyGw7seFtTTiCyndmLv
         YbxQ5PGSf4wJkn9iYrateSW0eVawu2UIQLrp5us0vMLRsaznoVCEkpIulIetkKN5H7
         3TF/JmSpIjykw==
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
Subject: [net-next 09/15] net/mlx5: DR, Add modify header arg pool mechanism
Date:   Fri, 14 Apr 2023 15:09:33 -0700
Message-Id: <20230414220939.136865-10-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230414220939.136865-1-saeed@kernel.org>
References: <20230414220939.136865-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Added new mechanism for handling arguments for modify-header action.
The new action "accelerated modify-header" asks for the arguments from
separated area from the pattern, this area accessed via general objects.
Handling of these object is done via the pool-manager struct.

When the new header patterns are supported, while loading the domain,
a few pools for argument creations will be created. The requests for
allocating/deallocating arg objects are done via the pool manager API.

Signed-off-by: Muhammad Sammar <muhammads@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../mellanox/mlx5/core/steering/dr_arg.c      | 273 ++++++++++++++++++
 .../mellanox/mlx5/core/steering/dr_domain.c   |  12 +
 .../mellanox/mlx5/core/steering/dr_types.h    |  18 ++
 4 files changed, 304 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_arg.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 39c2c8dc7e07..ca3c66cd47ec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -113,7 +113,7 @@ mlx5_core-$(CONFIG_MLX5_SW_STEERING) += steering/dr_domain.o steering/dr_table.o
 					steering/dr_cmd.o steering/dr_fw.o \
 					steering/dr_action.o steering/fs_dr.o \
 					steering/dr_definer.o steering/dr_ptrn.o \
-					steering/dr_dbg.o lib/smfs.o
+					steering/dr_arg.o steering/dr_dbg.o lib/smfs.o
 #
 # SF device
 #
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_arg.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_arg.c
new file mode 100644
index 000000000000..01ed6442095d
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_arg.c
@@ -0,0 +1,273 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+
+#include "dr_types.h"
+
+#define DR_ICM_MODIFY_HDR_GRANULARITY_4K 12
+
+/* modify-header arg pool */
+enum dr_arg_chunk_size {
+	DR_ARG_CHUNK_SIZE_1,
+	DR_ARG_CHUNK_SIZE_MIN = DR_ARG_CHUNK_SIZE_1, /* keep updated when changing */
+	DR_ARG_CHUNK_SIZE_2,
+	DR_ARG_CHUNK_SIZE_3,
+	DR_ARG_CHUNK_SIZE_4,
+	DR_ARG_CHUNK_SIZE_MAX,
+};
+
+/* argument pool area */
+struct dr_arg_pool {
+	enum dr_arg_chunk_size log_chunk_size;
+	struct mlx5dr_domain *dmn;
+	struct list_head free_list;
+	struct mutex mutex; /* protect arg pool */
+};
+
+struct mlx5dr_arg_mgr {
+	struct mlx5dr_domain *dmn;
+	struct dr_arg_pool *pools[DR_ARG_CHUNK_SIZE_MAX];
+};
+
+static int dr_arg_pool_alloc_objs(struct dr_arg_pool *pool)
+{
+	struct mlx5dr_arg_obj *arg_obj, *tmp_arg;
+	struct list_head cur_list;
+	u16 object_range;
+	int num_of_objects;
+	u32 obj_id = 0;
+	int i, ret;
+
+	INIT_LIST_HEAD(&cur_list);
+
+	object_range =
+		pool->dmn->info.caps.log_header_modify_argument_granularity;
+
+	object_range =
+		max_t(u32, pool->dmn->info.caps.log_header_modify_argument_granularity,
+		      DR_ICM_MODIFY_HDR_GRANULARITY_4K);
+	object_range =
+		min_t(u32, pool->dmn->info.caps.log_header_modify_argument_max_alloc,
+		      object_range);
+
+	if (pool->log_chunk_size > object_range) {
+		mlx5dr_err(pool->dmn, "Required chunk size (%d) is not supported\n",
+			   pool->log_chunk_size);
+		return -ENOMEM;
+	}
+
+	num_of_objects = (1 << (object_range - pool->log_chunk_size));
+	/* Only one devx object per range */
+	ret = mlx5dr_cmd_create_modify_header_arg(pool->dmn->mdev,
+						  object_range,
+						  pool->dmn->pdn,
+						  &obj_id);
+	if (ret) {
+		mlx5dr_err(pool->dmn, "failed allocating object with range: %d:\n",
+			   object_range);
+		return -EAGAIN;
+	}
+
+	for (i = 0; i < num_of_objects; i++) {
+		arg_obj = kzalloc(sizeof(*arg_obj), GFP_KERNEL);
+		if (!arg_obj) {
+			ret = -ENOMEM;
+			goto clean_arg_obj;
+		}
+
+		arg_obj->log_chunk_size = pool->log_chunk_size;
+
+		list_add_tail(&arg_obj->list_node, &cur_list);
+
+		arg_obj->obj_id = obj_id;
+		arg_obj->obj_offset = i * (1 << pool->log_chunk_size);
+	}
+	list_splice_tail_init(&cur_list, &pool->free_list);
+
+	return 0;
+
+clean_arg_obj:
+	mlx5dr_cmd_destroy_modify_header_arg(pool->dmn->mdev, obj_id);
+	list_for_each_entry_safe(arg_obj, tmp_arg, &cur_list, list_node) {
+		list_del(&arg_obj->list_node);
+		kfree(arg_obj);
+	}
+	return ret;
+}
+
+static struct mlx5dr_arg_obj *dr_arg_pool_get_arg_obj(struct dr_arg_pool *pool)
+{
+	struct mlx5dr_arg_obj *arg_obj = NULL;
+	int ret;
+
+	mutex_lock(&pool->mutex);
+	if (list_empty(&pool->free_list)) {
+		ret = dr_arg_pool_alloc_objs(pool);
+		if (ret)
+			goto out;
+	}
+
+	arg_obj = list_first_entry_or_null(&pool->free_list,
+					   struct mlx5dr_arg_obj,
+					   list_node);
+	WARN(!arg_obj, "couldn't get dr arg obj from pool");
+
+	if (arg_obj)
+		list_del_init(&arg_obj->list_node);
+
+out:
+	mutex_unlock(&pool->mutex);
+	return arg_obj;
+}
+
+static void dr_arg_pool_put_arg_obj(struct dr_arg_pool *pool,
+				    struct mlx5dr_arg_obj *arg_obj)
+{
+	mutex_lock(&pool->mutex);
+	list_add(&arg_obj->list_node, &pool->free_list);
+	mutex_unlock(&pool->mutex);
+}
+
+static struct dr_arg_pool *dr_arg_pool_create(struct mlx5dr_domain *dmn,
+					      enum dr_arg_chunk_size chunk_size)
+{
+	struct dr_arg_pool *pool;
+
+	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
+	if (!pool)
+		return NULL;
+
+	pool->dmn = dmn;
+
+	INIT_LIST_HEAD(&pool->free_list);
+	mutex_init(&pool->mutex);
+
+	pool->log_chunk_size = chunk_size;
+	if (dr_arg_pool_alloc_objs(pool))
+		goto free_pool;
+
+	return pool;
+
+free_pool:
+	kfree(pool);
+
+	return NULL;
+}
+
+static void dr_arg_pool_destroy(struct dr_arg_pool *pool)
+{
+	struct mlx5dr_arg_obj *arg_obj, *tmp_arg;
+
+	list_for_each_entry_safe(arg_obj, tmp_arg, &pool->free_list, list_node) {
+		list_del(&arg_obj->list_node);
+		if (!arg_obj->obj_offset) /* the first in range */
+			mlx5dr_cmd_destroy_modify_header_arg(pool->dmn->mdev, arg_obj->obj_id);
+		kfree(arg_obj);
+	}
+
+	mutex_destroy(&pool->mutex);
+	kfree(pool);
+}
+
+static enum dr_arg_chunk_size dr_arg_get_chunk_size(u16 num_of_actions)
+{
+	if (num_of_actions <= 8)
+		return DR_ARG_CHUNK_SIZE_1;
+	if (num_of_actions <= 16)
+		return DR_ARG_CHUNK_SIZE_2;
+	if (num_of_actions <= 32)
+		return DR_ARG_CHUNK_SIZE_3;
+	if (num_of_actions <= 64)
+		return DR_ARG_CHUNK_SIZE_4;
+
+	return DR_ARG_CHUNK_SIZE_MAX;
+}
+
+u32 mlx5dr_arg_get_obj_id(struct mlx5dr_arg_obj *arg_obj)
+{
+	return (arg_obj->obj_id + arg_obj->obj_offset);
+}
+
+struct mlx5dr_arg_obj *mlx5dr_arg_get_obj(struct mlx5dr_arg_mgr *mgr,
+					  u16 num_of_actions,
+					  u8 *data)
+{
+	u32 size = dr_arg_get_chunk_size(num_of_actions);
+	struct mlx5dr_arg_obj *arg_obj;
+	int ret;
+
+	if (size >= DR_ARG_CHUNK_SIZE_MAX)
+		return NULL;
+
+	arg_obj = dr_arg_pool_get_arg_obj(mgr->pools[size]);
+	if (!arg_obj) {
+		mlx5dr_err(mgr->dmn, "Failed allocating args object for modify header\n");
+		return NULL;
+	}
+
+	/* write it into the hw */
+	ret = mlx5dr_send_postsend_args(mgr->dmn,
+					mlx5dr_arg_get_obj_id(arg_obj),
+					num_of_actions, data);
+	if (ret) {
+		mlx5dr_err(mgr->dmn, "Failed writing args object\n");
+		goto put_obj;
+	}
+
+	return arg_obj;
+
+put_obj:
+	mlx5dr_arg_put_obj(mgr, arg_obj);
+	return NULL;
+}
+
+void mlx5dr_arg_put_obj(struct mlx5dr_arg_mgr *mgr,
+			struct mlx5dr_arg_obj *arg_obj)
+{
+	dr_arg_pool_put_arg_obj(mgr->pools[arg_obj->log_chunk_size], arg_obj);
+}
+
+struct mlx5dr_arg_mgr*
+mlx5dr_arg_mgr_create(struct mlx5dr_domain *dmn)
+{
+	struct mlx5dr_arg_mgr *pool_mgr;
+	int i;
+
+	if (!mlx5dr_domain_is_support_ptrn_arg(dmn))
+		return NULL;
+
+	pool_mgr = kzalloc(sizeof(*pool_mgr), GFP_KERNEL);
+	if (!pool_mgr)
+		return NULL;
+
+	pool_mgr->dmn = dmn;
+
+	for (i = 0; i < DR_ARG_CHUNK_SIZE_MAX; i++) {
+		pool_mgr->pools[i] = dr_arg_pool_create(dmn, i);
+		if (!pool_mgr->pools[i])
+			goto clean_pools;
+	}
+
+	return pool_mgr;
+
+clean_pools:
+	for (i--; i >= 0; i--)
+		dr_arg_pool_destroy(pool_mgr->pools[i]);
+
+	kfree(pool_mgr);
+	return NULL;
+}
+
+void mlx5dr_arg_mgr_destroy(struct mlx5dr_arg_mgr *mgr)
+{
+	struct dr_arg_pool **pools;
+	int i;
+
+	if (!mgr)
+		return;
+
+	pools = mgr->pools;
+	for (i = 0; i < DR_ARG_CHUNK_SIZE_MAX; i++)
+		dr_arg_pool_destroy(pools[i]);
+
+	kfree(mgr);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
index 7a0381572c4c..c4545daf179b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -26,7 +26,18 @@ static int dr_domain_init_modify_header_resources(struct mlx5dr_domain *dmn)
 		return -ENOMEM;
 	}
 
+	/* create argument pool */
+	dmn->arg_mgr = mlx5dr_arg_mgr_create(dmn);
+	if (!dmn->arg_mgr) {
+		mlx5dr_err(dmn, "Couldn't create arg_mgr\n");
+		goto free_modify_header_pattern;
+	}
+
 	return 0;
+
+free_modify_header_pattern:
+	mlx5dr_ptrn_mgr_destroy(dmn->ptrn_mgr);
+	return -ENOMEM;
 }
 
 static void dr_domain_destroy_modify_header_resources(struct mlx5dr_domain *dmn)
@@ -34,6 +45,7 @@ static void dr_domain_destroy_modify_header_resources(struct mlx5dr_domain *dmn)
 	if (!mlx5dr_domain_is_support_ptrn_arg(dmn))
 		return;
 
+	mlx5dr_arg_mgr_destroy(dmn->arg_mgr);
 	mlx5dr_ptrn_mgr_destroy(dmn->ptrn_mgr);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 81d7ac6d6258..e102ceb20e01 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -28,6 +28,8 @@
 #define mlx5dr_dbg(dmn, arg...) mlx5_core_dbg((dmn)->mdev, ##arg)
 
 struct mlx5dr_ptrn_mgr;
+struct mlx5dr_arg_mgr;
+struct mlx5dr_arg_obj;
 
 static inline bool dr_is_flex_parser_0_id(u8 parser_id)
 {
@@ -941,6 +943,7 @@ struct mlx5dr_domain {
 	struct kmem_cache *chunks_kmem_cache;
 	struct kmem_cache *htbls_kmem_cache;
 	struct mlx5dr_ptrn_mgr *ptrn_mgr;
+	struct mlx5dr_arg_mgr *arg_mgr;
 	struct mlx5dr_send_ring *send_ring;
 	struct mlx5dr_domain_info info;
 	struct xarray csum_fts_xa;
@@ -1016,6 +1019,13 @@ struct mlx5dr_ptrn_obj {
 	struct list_head list;
 };
 
+struct mlx5dr_arg_obj {
+	u32 obj_id;
+	u32 obj_offset;
+	struct list_head list_node;
+	u32 log_chunk_size;
+};
+
 struct mlx5dr_action_rewrite {
 	struct mlx5dr_domain *dmn;
 	struct mlx5dr_icm_chunk *chunk;
@@ -1566,5 +1576,13 @@ struct mlx5dr_ptrn_obj *mlx5dr_ptrn_cache_get_pattern(struct mlx5dr_ptrn_mgr *mg
 						      u16 num_of_actions, u8 *data);
 void mlx5dr_ptrn_cache_put_pattern(struct mlx5dr_ptrn_mgr *mgr,
 				   struct mlx5dr_ptrn_obj *pattern);
+struct mlx5dr_arg_mgr *mlx5dr_arg_mgr_create(struct mlx5dr_domain *dmn);
+void mlx5dr_arg_mgr_destroy(struct mlx5dr_arg_mgr *mgr);
+struct mlx5dr_arg_obj *mlx5dr_arg_get_obj(struct mlx5dr_arg_mgr *mgr,
+					  u16 num_of_actions,
+					  u8 *data);
+void mlx5dr_arg_put_obj(struct mlx5dr_arg_mgr *mgr,
+			struct mlx5dr_arg_obj *arg_obj);
+u32 mlx5dr_arg_get_obj_id(struct mlx5dr_arg_obj *arg_obj);
 
 #endif  /* _DR_TYPES_H_ */
-- 
2.39.2

