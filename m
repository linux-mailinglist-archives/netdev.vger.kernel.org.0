Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C20A54DCE30
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 19:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237745AbiCQS4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 14:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237722AbiCQSzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 14:55:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B51165B8F
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 11:54:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AFEFB81FA0
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 18:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88A7C340EC;
        Thu, 17 Mar 2022 18:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647543274;
        bh=4vWrPCABOt4rXUReogfq5EcAYeJNMn9cEniAE5ilLh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pCYNDDPbMoNoyFLdq9xibsqt0Iut/+qQ65NhHR62df9w/k6+UPMrs7G5wirD0qicx
         9V2D0t3yOJekov4geGnkg7urP0ezKBkSOhgfAKggAfxEzM3Yfug4YFfYCE6QvqBN6N
         92dVAs5Pg6hGhn7LZ1UbLRKTsWbjIUwahCoAAr1cyiXiw0nxRpuLUARlWFnqKJnzH6
         gtQbMIL13KmWw6dBgITCaW0rHVe0bEo9bbPgcix36LQ+bGrPGF2NSLml+mAVNOQeml
         UxVV6DtETm0X7Bxn4gnfgEquhGjaGq6Z2eD2/RCxgcluutMH6NBEggDHnjiS3dGt/q
         zxXQIt8vV1kkg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Rongwei Liu <rongweil@nvidia.com>,
        Shun Hao <shunh@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/15] net/mlx5: DR, Remove 4 members from mlx5dr_ste_htbl to reduce memory
Date:   Thu, 17 Mar 2022 11:54:20 -0700
Message-Id: <20220317185424.287982-12-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220317185424.287982-1-saeed@kernel.org>
References: <20220317185424.287982-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rongwei Liu <rongweil@nvidia.com>

Remove chunk_size in struct mlx5dr_icm_chunk and use
chunk->size instead.

Remove ste_arr/hw_ste_arr/miss_list since they can be accessed
from htbl->chunk pointer, no need to keep a copy.

This commit reduces 28 bytes from struct mlx5dr_ste_htbl and its
size is 32 bytes now.

Signed-off-by: Rongwei Liu <rongweil@nvidia.com>
Reviewed-by: Shun Hao <shunh@nvidia.com>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_matcher.c  | 16 ++++++-----
 .../mellanox/mlx5/core/steering/dr_rule.c     | 28 +++++++++----------
 .../mellanox/mlx5/core/steering/dr_send.c     | 10 +++----
 .../mellanox/mlx5/core/steering/dr_ste.c      | 18 +++++-------
 .../mellanox/mlx5/core/steering/dr_types.h    | 11 ++------
 5 files changed, 37 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index 35154ec9673a..0726848eb3ff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -726,12 +726,14 @@ static int dr_nic_matcher_connect(struct mlx5dr_domain *dmn,
 		return ret;
 
 	/* Update the pointing ste and next hash table */
-	curr_nic_matcher->s_htbl->pointing_ste = prev_htbl->ste_arr;
-	prev_htbl->ste_arr[0].next_htbl = curr_nic_matcher->s_htbl;
+	curr_nic_matcher->s_htbl->pointing_ste = prev_htbl->chunk->ste_arr;
+	prev_htbl->chunk->ste_arr[0].next_htbl = curr_nic_matcher->s_htbl;
 
 	if (next_nic_matcher) {
-		next_nic_matcher->s_htbl->pointing_ste = curr_nic_matcher->e_anchor->ste_arr;
-		curr_nic_matcher->e_anchor->ste_arr[0].next_htbl = next_nic_matcher->s_htbl;
+		next_nic_matcher->s_htbl->pointing_ste =
+			curr_nic_matcher->e_anchor->chunk->ste_arr;
+		curr_nic_matcher->e_anchor->chunk->ste_arr[0].next_htbl =
+			next_nic_matcher->s_htbl;
 	}
 
 	return 0;
@@ -1043,12 +1045,12 @@ static int dr_matcher_disconnect_nic(struct mlx5dr_domain *dmn,
 	if (next_nic_matcher) {
 		info.type = CONNECT_HIT;
 		info.hit_next_htbl = next_nic_matcher->s_htbl;
-		next_nic_matcher->s_htbl->pointing_ste = prev_anchor->ste_arr;
-		prev_anchor->ste_arr[0].next_htbl = next_nic_matcher->s_htbl;
+		next_nic_matcher->s_htbl->pointing_ste = prev_anchor->chunk->ste_arr;
+		prev_anchor->chunk->ste_arr[0].next_htbl = next_nic_matcher->s_htbl;
 	} else {
 		info.type = CONNECT_MISS;
 		info.miss_icm_addr = nic_tbl->default_icm_addr;
-		prev_anchor->ste_arr[0].next_htbl = NULL;
+		prev_anchor->chunk->ste_arr[0].next_htbl = NULL;
 	}
 
 	return mlx5dr_ste_htbl_init_and_postsend(dmn, nic_dmn, prev_anchor,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index 91be9d9d95a8..698e1cfc9571 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -54,7 +54,7 @@ dr_rule_create_collision_htbl(struct mlx5dr_matcher *matcher,
 	}
 
 	/* One and only entry, never grows */
-	ste = new_htbl->ste_arr;
+	ste = new_htbl->chunk->ste_arr;
 	icm_addr = mlx5dr_icm_pool_get_chunk_icm_addr(nic_matcher->e_anchor->chunk);
 	mlx5dr_ste_set_miss_addr(ste_ctx, hw_ste, icm_addr);
 	mlx5dr_htbl_get(new_htbl);
@@ -80,7 +80,7 @@ dr_rule_create_collision_entry(struct mlx5dr_matcher *matcher,
 	ste->htbl->pointing_ste = orig_ste->htbl->pointing_ste;
 
 	/* In collision entry, all members share the same miss_list_head */
-	ste->htbl->miss_list = mlx5dr_ste_get_miss_list(orig_ste);
+	ste->htbl->chunk->miss_list = mlx5dr_ste_get_miss_list(orig_ste);
 
 	/* Next table */
 	if (mlx5dr_ste_create_next_htbl(matcher, nic_matcher, ste, hw_ste,
@@ -186,7 +186,7 @@ dr_rule_rehash_handle_collision(struct mlx5dr_matcher *matcher,
 	new_ste->htbl->pointing_ste = col_ste->htbl->pointing_ste;
 
 	/* In collision entry, all members share the same miss_list_head */
-	new_ste->htbl->miss_list = mlx5dr_ste_get_miss_list(col_ste);
+	new_ste->htbl->chunk->miss_list = mlx5dr_ste_get_miss_list(col_ste);
 
 	/* Update the previous from the list */
 	ret = dr_rule_append_to_miss_list(dmn->ste_ctx, new_ste,
@@ -250,7 +250,7 @@ dr_rule_rehash_copy_ste(struct mlx5dr_matcher *matcher,
 	mlx5dr_ste_set_miss_addr(dmn->ste_ctx, hw_ste, icm_addr);
 
 	new_idx = mlx5dr_ste_calc_hash_index(hw_ste, new_htbl);
-	new_ste = &new_htbl->ste_arr[new_idx];
+	new_ste = &new_htbl->chunk->ste_arr[new_idx];
 
 	if (mlx5dr_ste_is_not_used(new_ste)) {
 		mlx5dr_htbl_get(new_htbl);
@@ -336,7 +336,7 @@ static int dr_rule_rehash_copy_htbl(struct mlx5dr_matcher *matcher,
 	int err = 0;
 	int i;
 
-	cur_entries = mlx5dr_icm_pool_chunk_size_to_entries(cur_htbl->chunk_size);
+	cur_entries = mlx5dr_icm_pool_chunk_size_to_entries(cur_htbl->chunk->size);
 
 	if (cur_entries < 1) {
 		mlx5dr_dbg(matcher->tbl->dmn, "Invalid number of entries\n");
@@ -344,7 +344,7 @@ static int dr_rule_rehash_copy_htbl(struct mlx5dr_matcher *matcher,
 	}
 
 	for (i = 0; i < cur_entries; i++) {
-		cur_ste = &cur_htbl->ste_arr[i];
+		cur_ste = &cur_htbl->chunk->ste_arr[i];
 		if (mlx5dr_ste_is_not_used(cur_ste)) /* Empty, nothing to copy */
 			continue;
 
@@ -448,11 +448,11 @@ dr_rule_rehash_htbl(struct mlx5dr_rule *rule,
 		 * (48B len) which works only on first 32B
 		 */
 		mlx5dr_ste_set_hit_addr(dmn->ste_ctx,
-					prev_htbl->ste_arr[0].hw_ste,
+					prev_htbl->chunk->ste_arr[0].hw_ste,
 					mlx5dr_icm_pool_get_chunk_icm_addr(new_htbl->chunk),
 					mlx5dr_icm_pool_get_chunk_num_of_entries(new_htbl->chunk));
 
-		ste_to_update = &prev_htbl->ste_arr[0];
+		ste_to_update = &prev_htbl->chunk->ste_arr[0];
 	} else {
 		mlx5dr_ste_set_hit_addr_by_next_htbl(dmn->ste_ctx,
 						     cur_htbl->pointing_ste->hw_ste,
@@ -491,10 +491,10 @@ static struct mlx5dr_ste_htbl *dr_rule_rehash(struct mlx5dr_rule *rule,
 	struct mlx5dr_domain *dmn = rule->matcher->tbl->dmn;
 	enum mlx5dr_icm_chunk_size new_size;
 
-	new_size = mlx5dr_icm_next_higher_chunk(cur_htbl->chunk_size);
+	new_size = mlx5dr_icm_next_higher_chunk(cur_htbl->chunk->size);
 	new_size = min_t(u32, new_size, dmn->info.max_log_sw_icm_sz);
 
-	if (new_size == cur_htbl->chunk_size)
+	if (new_size == cur_htbl->chunk->size)
 		return NULL; /* Skip rehash, we already at the max size */
 
 	return dr_rule_rehash_htbl(rule, nic_rule, cur_htbl, ste_location,
@@ -661,13 +661,13 @@ static bool dr_rule_need_enlarge_hash(struct mlx5dr_ste_htbl *htbl,
 	struct mlx5dr_ste_htbl_ctrl *ctrl = &htbl->ctrl;
 	int threshold;
 
-	if (dmn->info.max_log_sw_icm_sz <= htbl->chunk_size)
+	if (dmn->info.max_log_sw_icm_sz <= htbl->chunk->size)
 		return false;
 
 	if (!mlx5dr_ste_htbl_may_grow(htbl))
 		return false;
 
-	if (dr_get_bits_per_mask(htbl->byte_mask) * BITS_PER_BYTE <= htbl->chunk_size)
+	if (dr_get_bits_per_mask(htbl->byte_mask) * BITS_PER_BYTE <= htbl->chunk->size)
 		return false;
 
 	threshold = mlx5dr_ste_htbl_increase_threshold(htbl);
@@ -825,7 +825,7 @@ dr_rule_handle_ste_branch(struct mlx5dr_rule *rule,
 again:
 	index = mlx5dr_ste_calc_hash_index(hw_ste, cur_htbl);
 	miss_list = &cur_htbl->chunk->miss_list[index];
-	ste = &cur_htbl->ste_arr[index];
+	ste = &cur_htbl->chunk->ste_arr[index];
 
 	if (mlx5dr_ste_is_not_used(ste)) {
 		if (dr_rule_handle_empty_entry(matcher, nic_matcher, cur_htbl,
@@ -861,7 +861,7 @@ dr_rule_handle_ste_branch(struct mlx5dr_rule *rule,
 						  ste_location, send_ste_list);
 			if (!new_htbl) {
 				mlx5dr_err(dmn, "Failed creating rehash table, htbl-log_size: %d\n",
-					   cur_htbl->chunk_size);
+					   cur_htbl->chunk->size);
 				mlx5dr_htbl_put(cur_htbl);
 			} else {
 				cur_htbl = new_htbl;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index e0470dbd3116..26a91c4415c5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -486,7 +486,7 @@ int mlx5dr_send_postsend_htbl(struct mlx5dr_domain *dmn,
 		 * need to add the bit_mask
 		 */
 		for (j = 0; j < num_stes_per_iter; j++) {
-			struct mlx5dr_ste *ste = &htbl->ste_arr[ste_index + j];
+			struct mlx5dr_ste *ste = &htbl->chunk->ste_arr[ste_index + j];
 			u32 ste_off = j * DR_STE_SIZE;
 
 			if (mlx5dr_ste_is_not_used(ste)) {
@@ -495,7 +495,7 @@ int mlx5dr_send_postsend_htbl(struct mlx5dr_domain *dmn,
 			} else {
 				/* Copy data */
 				memcpy(data + ste_off,
-				       htbl->ste_arr[ste_index + j].hw_ste,
+				       htbl->chunk->ste_arr[ste_index + j].hw_ste,
 				       DR_STE_SIZE_REDUCED);
 				/* Copy bit_mask */
 				memcpy(data + ste_off + DR_STE_SIZE_REDUCED,
@@ -511,7 +511,7 @@ int mlx5dr_send_postsend_htbl(struct mlx5dr_domain *dmn,
 		send_info.write.length = byte_size;
 		send_info.write.lkey = 0;
 		send_info.remote_addr =
-			mlx5dr_ste_get_mr_addr(htbl->ste_arr + ste_index);
+			mlx5dr_ste_get_mr_addr(htbl->chunk->ste_arr + ste_index);
 		send_info.rkey = mlx5dr_icm_pool_get_chunk_rkey(htbl->chunk);
 
 		ret = dr_postsend_icm_data(dmn, &send_info);
@@ -546,7 +546,7 @@ int mlx5dr_send_postsend_formatted_htbl(struct mlx5dr_domain *dmn,
 	if (update_hw_ste) {
 		/* Copy the reduced STE to hash table ste_arr */
 		for (i = 0; i < num_stes; i++) {
-			copy_dst = htbl->hw_ste_arr + i * DR_STE_SIZE_REDUCED;
+			copy_dst = htbl->chunk->hw_ste_arr + i * DR_STE_SIZE_REDUCED;
 			memcpy(copy_dst, ste_init_data, DR_STE_SIZE_REDUCED);
 		}
 	}
@@ -568,7 +568,7 @@ int mlx5dr_send_postsend_formatted_htbl(struct mlx5dr_domain *dmn,
 		send_info.write.length = byte_size;
 		send_info.write.lkey = 0;
 		send_info.remote_addr =
-			mlx5dr_ste_get_mr_addr(htbl->ste_arr + ste_index);
+			mlx5dr_ste_get_mr_addr(htbl->chunk->ste_arr + ste_index);
 		send_info.rkey = mlx5dr_icm_pool_get_chunk_rkey(htbl->chunk);
 
 		ret = dr_postsend_icm_data(dmn, &send_info);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 3ff568e80e0e..3ab155feba5e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -115,23 +115,23 @@ void mlx5dr_ste_set_hit_addr(struct mlx5dr_ste_ctx *ste_ctx,
 u64 mlx5dr_ste_get_icm_addr(struct mlx5dr_ste *ste)
 {
 	u64 base_icm_addr = mlx5dr_icm_pool_get_chunk_icm_addr(ste->htbl->chunk);
-	u32 index = ste - ste->htbl->ste_arr;
+	u32 index = ste - ste->htbl->chunk->ste_arr;
 
 	return base_icm_addr + DR_STE_SIZE * index;
 }
 
 u64 mlx5dr_ste_get_mr_addr(struct mlx5dr_ste *ste)
 {
-	u32 index = ste - ste->htbl->ste_arr;
+	u32 index = ste - ste->htbl->chunk->ste_arr;
 
 	return mlx5dr_icm_pool_get_chunk_mr_addr(ste->htbl->chunk) + DR_STE_SIZE * index;
 }
 
 struct list_head *mlx5dr_ste_get_miss_list(struct mlx5dr_ste *ste)
 {
-	u32 index = ste - ste->htbl->ste_arr;
+	u32 index = ste - ste->htbl->chunk->ste_arr;
 
-	return &ste->htbl->miss_list[index];
+	return &ste->htbl->chunk->miss_list[index];
 }
 
 static void dr_ste_always_hit_htbl(struct mlx5dr_ste_ctx *ste_ctx,
@@ -490,23 +490,19 @@ struct mlx5dr_ste_htbl *mlx5dr_ste_htbl_alloc(struct mlx5dr_icm_pool *pool,
 	htbl->chunk = chunk;
 	htbl->lu_type = lu_type;
 	htbl->byte_mask = byte_mask;
-	htbl->ste_arr = chunk->ste_arr;
-	htbl->hw_ste_arr = chunk->hw_ste_arr;
-	htbl->miss_list = chunk->miss_list;
 	htbl->refcount = 0;
 	num_entries = mlx5dr_icm_pool_get_chunk_num_of_entries(chunk);
 
 	for (i = 0; i < num_entries; i++) {
-		struct mlx5dr_ste *ste = &htbl->ste_arr[i];
+		struct mlx5dr_ste *ste = &chunk->ste_arr[i];
 
-		ste->hw_ste = htbl->hw_ste_arr + i * DR_STE_SIZE_REDUCED;
+		ste->hw_ste = chunk->hw_ste_arr + i * DR_STE_SIZE_REDUCED;
 		ste->htbl = htbl;
 		ste->refcount = 0;
 		INIT_LIST_HEAD(&ste->miss_list_node);
-		INIT_LIST_HEAD(&htbl->miss_list[i]);
+		INIT_LIST_HEAD(&chunk->miss_list[i]);
 	}
 
-	htbl->chunk_size = chunk_size;
 	return htbl;
 
 out_free_htbl:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 9660296d36aa..1294c12ceb10 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -181,14 +181,7 @@ struct mlx5dr_ste_htbl {
 	u16 byte_mask;
 	u32 refcount;
 	struct mlx5dr_icm_chunk *chunk;
-	struct mlx5dr_ste *ste_arr;
-	u8 *hw_ste_arr;
-
-	struct list_head *miss_list;
-
-	enum mlx5dr_icm_chunk_size chunk_size;
 	struct mlx5dr_ste *pointing_ste;
-
 	struct mlx5dr_ste_htbl_ctrl ctrl;
 };
 
@@ -1180,7 +1173,7 @@ static inline int
 mlx5dr_ste_htbl_increase_threshold(struct mlx5dr_ste_htbl *htbl)
 {
 	int num_of_entries =
-		mlx5dr_icm_pool_chunk_size_to_entries(htbl->chunk_size);
+		mlx5dr_icm_pool_chunk_size_to_entries(htbl->chunk->size);
 
 	/* Threshold is 50%, one is added to table of size 1 */
 	return (num_of_entries + 1) / 2;
@@ -1189,7 +1182,7 @@ mlx5dr_ste_htbl_increase_threshold(struct mlx5dr_ste_htbl *htbl)
 static inline bool
 mlx5dr_ste_htbl_may_grow(struct mlx5dr_ste_htbl *htbl)
 {
-	if (htbl->chunk_size == DR_CHUNK_SIZE_MAX - 1 || !htbl->byte_mask)
+	if (htbl->chunk->size == DR_CHUNK_SIZE_MAX - 1 || !htbl->byte_mask)
 		return false;
 
 	return true;
-- 
2.35.1

