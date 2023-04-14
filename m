Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A448D6E2C47
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 00:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbjDNWJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 18:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbjDNWJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 18:09:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34FC40FD
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 15:09:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F84764A97
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 22:09:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE49EC433EF;
        Fri, 14 Apr 2023 22:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681510183;
        bh=cvIAbB0drJYOcOCZ4cXPXyjoUnGjRXHJx9KY/qO/9qU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ABNN8hu8tY/24SKUC1Gke9+b0p0/Mjzh7sODtyAvdNlVSiFxW7+YM7RBs7C9VDZ2J
         zqaZkV53+QcK+TfRVBJM5FxsRidJ1HO20TXo8bpj5uSmzOZoqW3S0KWodqfD2HCrkz
         f84BX27xEwoFSOuLwGDy9A6+7Ifvk3Kp4u4g3ucB3XOte6Ysnmatr8vt2zC4HDNpX0
         GpO2BwKxk+I9ASlgkn0zhuq7riuMBcLJhCk99QI1s/P9zReNJvt1bxBBiICSb7L3V+
         zP5cQitw4TaRHXy+RHQakkPKpTjGWlRF7QNiSW4T9SvR5I558Oqq/19HjjG+oEB4UP
         lvnrwivauVEgA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next 02/15] net/mlx5: DR, Add cache for modify header pattern
Date:   Fri, 14 Apr 2023 15:09:26 -0700
Message-Id: <20230414220939.136865-3-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230414220939.136865-1-saeed@kernel.org>
References: <20230414220939.136865-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Starting with ConnectX-6 Dx, we use new design of modify_header FW object.
The current modify_header object allows for having only limited number
of FW objects, so the new design of pattern and argument allows pattern
reuse, saving memory, and having a large number of modify_header objects.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_ptrn.c     | 198 ++++++++++++++++++
 .../mellanox/mlx5/core/steering/dr_send.c     |  20 ++
 .../mellanox/mlx5/core/steering/dr_types.h    |  18 ++
 3 files changed, 236 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ptrn.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ptrn.c
index 698e79d278bf..13e06a6a6b22 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ptrn.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ptrn.c
@@ -2,12 +2,198 @@
 // Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
 
 #include "dr_types.h"
+#include "mlx5_ifc_dr_ste_v1.h"
+
+enum dr_ptrn_modify_hdr_action_id {
+	DR_PTRN_MODIFY_HDR_ACTION_ID_NOP = 0x00,
+	DR_PTRN_MODIFY_HDR_ACTION_ID_COPY = 0x05,
+	DR_PTRN_MODIFY_HDR_ACTION_ID_SET = 0x06,
+	DR_PTRN_MODIFY_HDR_ACTION_ID_ADD = 0x07,
+	DR_PTRN_MODIFY_HDR_ACTION_ID_INSERT_INLINE = 0x0a,
+};
 
 struct mlx5dr_ptrn_mgr {
 	struct mlx5dr_domain *dmn;
 	struct mlx5dr_icm_pool *ptrn_icm_pool;
+	/* cache for modify_header ptrn */
+	struct list_head ptrn_list;
+	struct mutex modify_hdr_mutex; /* protect the pattern cache */
 };
 
+/* Cache structure and functions */
+static bool dr_ptrn_compare_modify_hdr(size_t cur_num_of_actions,
+				       __be64 cur_hw_actions[],
+				       size_t num_of_actions,
+				       __be64 hw_actions[])
+{
+	int i;
+
+	if (cur_num_of_actions != num_of_actions)
+		return false;
+
+	for (i = 0; i < num_of_actions; i++) {
+		u8 action_id =
+			MLX5_GET(ste_double_action_set_v1, &hw_actions[i], action_id);
+
+		if (action_id == DR_PTRN_MODIFY_HDR_ACTION_ID_COPY) {
+			if (hw_actions[i] != cur_hw_actions[i])
+				return false;
+		} else {
+			if ((__force __be32)hw_actions[i] !=
+			    (__force __be32)cur_hw_actions[i])
+				return false;
+		}
+	}
+
+	return true;
+}
+
+static struct mlx5dr_ptrn_obj *
+dr_ptrn_find_cached_pattern(struct mlx5dr_ptrn_mgr *mgr,
+			    size_t num_of_actions,
+			    __be64 hw_actions[])
+{
+	struct mlx5dr_ptrn_obj *cached_pattern;
+	struct mlx5dr_ptrn_obj *tmp;
+
+	list_for_each_entry_safe(cached_pattern, tmp, &mgr->ptrn_list, list) {
+		if (dr_ptrn_compare_modify_hdr(cached_pattern->num_of_actions,
+					       (__be64 *)cached_pattern->data,
+					       num_of_actions,
+					       hw_actions)) {
+			/* Put this pattern in the head of the list,
+			 * as we will probably use it more.
+			 */
+			list_del_init(&cached_pattern->list);
+			list_add(&cached_pattern->list, &mgr->ptrn_list);
+			return cached_pattern;
+		}
+	}
+
+	return NULL;
+}
+
+static struct mlx5dr_ptrn_obj *
+dr_ptrn_alloc_pattern(struct mlx5dr_ptrn_mgr *mgr,
+		      u16 num_of_actions, u8 *data)
+{
+	struct mlx5dr_ptrn_obj *pattern;
+	struct mlx5dr_icm_chunk *chunk;
+	u32 chunk_size;
+	u32 index;
+
+	chunk_size = ilog2(num_of_actions);
+	/* HW modify action index granularity is at least 64B */
+	chunk_size = max_t(u32, chunk_size, DR_CHUNK_SIZE_8);
+
+	chunk = mlx5dr_icm_alloc_chunk(mgr->ptrn_icm_pool, chunk_size);
+	if (!chunk)
+		return NULL;
+
+	index = (mlx5dr_icm_pool_get_chunk_icm_addr(chunk) -
+		 mgr->dmn->info.caps.hdr_modify_pattern_icm_addr) /
+		DR_ACTION_CACHE_LINE_SIZE;
+
+	pattern = kzalloc(sizeof(*pattern), GFP_KERNEL);
+	if (!pattern)
+		goto free_chunk;
+
+	pattern->data = kzalloc(num_of_actions * DR_MODIFY_ACTION_SIZE *
+				sizeof(*pattern->data), GFP_KERNEL);
+	if (!pattern->data)
+		goto free_pattern;
+
+	memcpy(pattern->data, data, num_of_actions * DR_MODIFY_ACTION_SIZE);
+	pattern->chunk = chunk;
+	pattern->index = index;
+	pattern->num_of_actions = num_of_actions;
+
+	list_add(&pattern->list, &mgr->ptrn_list);
+	refcount_set(&pattern->refcount, 1);
+
+	return pattern;
+
+free_pattern:
+	kfree(pattern);
+free_chunk:
+	mlx5dr_icm_free_chunk(chunk);
+	return NULL;
+}
+
+static void
+dr_ptrn_free_pattern(struct mlx5dr_ptrn_obj *pattern)
+{
+	list_del(&pattern->list);
+	mlx5dr_icm_free_chunk(pattern->chunk);
+	kfree(pattern->data);
+	kfree(pattern);
+}
+
+struct mlx5dr_ptrn_obj *
+mlx5dr_ptrn_cache_get_pattern(struct mlx5dr_ptrn_mgr *mgr,
+			      u16 num_of_actions,
+			      u8 *data)
+{
+	struct mlx5dr_ptrn_obj *pattern;
+	u64 *hw_actions;
+	u8 action_id;
+	int i;
+
+	mutex_lock(&mgr->modify_hdr_mutex);
+	pattern = dr_ptrn_find_cached_pattern(mgr,
+					      num_of_actions,
+					      (__be64 *)data);
+	if (!pattern) {
+		/* Alloc and add new pattern to cache */
+		pattern = dr_ptrn_alloc_pattern(mgr, num_of_actions, data);
+		if (!pattern)
+			goto out_unlock;
+
+		hw_actions = (u64 *)pattern->data;
+		/* Here we mask the pattern data to create a valid pattern
+		 * since we do an OR operation between the arg and pattern
+		 */
+		for (i = 0; i < num_of_actions; i++) {
+			action_id = MLX5_GET(ste_double_action_set_v1, &hw_actions[i], action_id);
+
+			if (action_id == DR_PTRN_MODIFY_HDR_ACTION_ID_SET ||
+			    action_id == DR_PTRN_MODIFY_HDR_ACTION_ID_ADD ||
+			    action_id == DR_PTRN_MODIFY_HDR_ACTION_ID_INSERT_INLINE)
+				MLX5_SET(ste_double_action_set_v1, &hw_actions[i], inline_data, 0);
+		}
+
+		if (mlx5dr_send_postsend_pattern(mgr->dmn, pattern->chunk,
+						 num_of_actions, pattern->data)) {
+			refcount_dec(&pattern->refcount);
+			goto free_pattern;
+		}
+	} else {
+		refcount_inc(&pattern->refcount);
+	}
+
+	mutex_unlock(&mgr->modify_hdr_mutex);
+
+	return pattern;
+
+free_pattern:
+	dr_ptrn_free_pattern(pattern);
+out_unlock:
+	mutex_unlock(&mgr->modify_hdr_mutex);
+	return NULL;
+}
+
+void
+mlx5dr_ptrn_cache_put_pattern(struct mlx5dr_ptrn_mgr *mgr,
+			      struct mlx5dr_ptrn_obj *pattern)
+{
+	mutex_lock(&mgr->modify_hdr_mutex);
+
+	if (refcount_dec_and_test(&pattern->refcount))
+		dr_ptrn_free_pattern(pattern);
+
+	mutex_unlock(&mgr->modify_hdr_mutex);
+}
+
 struct mlx5dr_ptrn_mgr *mlx5dr_ptrn_mgr_create(struct mlx5dr_domain *dmn)
 {
 	struct mlx5dr_ptrn_mgr *mgr;
@@ -26,6 +212,7 @@ struct mlx5dr_ptrn_mgr *mlx5dr_ptrn_mgr_create(struct mlx5dr_domain *dmn)
 		goto free_mgr;
 	}
 
+	INIT_LIST_HEAD(&mgr->ptrn_list);
 	return mgr;
 
 free_mgr:
@@ -35,9 +222,20 @@ struct mlx5dr_ptrn_mgr *mlx5dr_ptrn_mgr_create(struct mlx5dr_domain *dmn)
 
 void mlx5dr_ptrn_mgr_destroy(struct mlx5dr_ptrn_mgr *mgr)
 {
+	struct mlx5dr_ptrn_obj *pattern;
+	struct mlx5dr_ptrn_obj *tmp;
+
 	if (!mgr)
 		return;
 
+	WARN_ON(!list_empty(&mgr->ptrn_list));
+
+	list_for_each_entry_safe(pattern, tmp, &mgr->ptrn_list, list) {
+		list_del(&pattern->list);
+		kfree(pattern->data);
+		kfree(pattern);
+	}
+
 	mlx5dr_icm_pool_destroy(mgr->ptrn_icm_pool);
 	kfree(mgr);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index 00bb65613300..78756840d263 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -754,6 +754,26 @@ int mlx5dr_send_postsend_action(struct mlx5dr_domain *dmn,
 	return dr_postsend_icm_data(dmn, &send_info);
 }
 
+int mlx5dr_send_postsend_pattern(struct mlx5dr_domain *dmn,
+				 struct mlx5dr_icm_chunk *chunk,
+				 u16 num_of_actions,
+				 u8 *data)
+{
+	struct postsend_info send_info = {};
+	int ret;
+
+	send_info.write.addr = (uintptr_t)data;
+	send_info.write.length = num_of_actions * DR_MODIFY_ACTION_SIZE;
+	send_info.remote_addr = mlx5dr_icm_pool_get_chunk_mr_addr(chunk);
+	send_info.rkey = mlx5dr_icm_pool_get_chunk_rkey(chunk);
+
+	ret = dr_postsend_icm_data(dmn, &send_info);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 static int dr_modify_qp_rst2init(struct mlx5_core_dev *mdev,
 				 struct mlx5dr_qp *dr_qp,
 				 int port)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 7453fc6df494..097f1f389b76 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -1002,6 +1002,15 @@ struct mlx5dr_ste_action_modify_field {
 	u8 l4_type;
 };
 
+struct mlx5dr_ptrn_obj {
+	struct mlx5dr_icm_chunk *chunk;
+	u8 *data;
+	u16 num_of_actions;
+	u32 index;
+	refcount_t refcount;
+	struct list_head list;
+};
+
 struct mlx5dr_action_rewrite {
 	struct mlx5dr_domain *dmn;
 	struct mlx5dr_icm_chunk *chunk;
@@ -1011,6 +1020,7 @@ struct mlx5dr_action_rewrite {
 	u8 allow_rx:1;
 	u8 allow_tx:1;
 	u8 modify_ttl:1;
+	struct mlx5dr_ptrn_obj *ptrn;
 };
 
 struct mlx5dr_action_reformat {
@@ -1448,6 +1458,10 @@ int mlx5dr_send_postsend_formatted_htbl(struct mlx5dr_domain *dmn,
 					bool update_hw_ste);
 int mlx5dr_send_postsend_action(struct mlx5dr_domain *dmn,
 				struct mlx5dr_action *action);
+int mlx5dr_send_postsend_pattern(struct mlx5dr_domain *dmn,
+				 struct mlx5dr_icm_chunk *chunk,
+				 u16 num_of_actions,
+				 u8 *data);
 
 int mlx5dr_send_info_pool_create(struct mlx5dr_domain *dmn);
 void mlx5dr_send_info_pool_destroy(struct mlx5dr_domain *dmn);
@@ -1537,5 +1551,9 @@ static inline bool mlx5dr_supp_match_ranges(struct mlx5_core_dev *dev)
 bool mlx5dr_domain_is_support_ptrn_arg(struct mlx5dr_domain *dmn);
 struct mlx5dr_ptrn_mgr *mlx5dr_ptrn_mgr_create(struct mlx5dr_domain *dmn);
 void mlx5dr_ptrn_mgr_destroy(struct mlx5dr_ptrn_mgr *mgr);
+struct mlx5dr_ptrn_obj *mlx5dr_ptrn_cache_get_pattern(struct mlx5dr_ptrn_mgr *mgr,
+						      u16 num_of_actions, u8 *data);
+void mlx5dr_ptrn_cache_put_pattern(struct mlx5dr_ptrn_mgr *mgr,
+				   struct mlx5dr_ptrn_obj *pattern);
 
 #endif  /* _DR_TYPES_H_ */
-- 
2.39.2

