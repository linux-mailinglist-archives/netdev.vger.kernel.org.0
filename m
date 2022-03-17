Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94EB24DCE32
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 19:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237759AbiCQS4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 14:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237533AbiCQSzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 14:55:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A86E3DFDF7
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 11:54:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2406EB81EF7
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 18:54:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DBF6C340F5;
        Thu, 17 Mar 2022 18:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647543274;
        bh=kEJpj6b/58WNxgTxYKDylenIb11BKMi8odmk3+eg4EM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CSJdHgdB53wRx+Mhd7u8DzikwBXSVQScn7aKopkRlNEgIX78gKfIdoobt5NNSteQV
         024fgXzhnMFYNDNhezFkB0eAWGsGRYyCq5Y3QNRW3hr1k1OpwNNQ1Ra7Ho5qZbGOrT
         g3BrBeWBtTgLTDIMp3ERbkWQVqjAJTrHsjUs+NhipjQyOlq9HSZagkn0As6kjvZ6Tv
         5YGHY1DVhLAuYbDXQJiwcmZcK199X3mOxLoayO9f41zsc8aGX8p0Ff9mbZZhlgOi1M
         DMW8Bmrzy9+AgZPLY3BLswGdv0twRveN056Bhzlk0iZt0dNP3BGu9r4xtMwSXkY//T
         oG8/RLobDWsmw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Rongwei Liu <rongweil@nvidia.com>,
        Shun Hao <shunh@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/15] net/mlx5: DR, Remove hw_ste from mlx5dr_ste to reduce memory
Date:   Thu, 17 Mar 2022 11:54:21 -0700
Message-Id: <20220317185424.287982-13-saeed@kernel.org>
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

It can be calculated via function mlx5dr_ste_get_hw_ste().
Very simple and lightweight, no need to use a dedicated member.

Reduce 8 bytes from struct mlx5dr_ste and its size is 48 bytes now.

Signed-off-by: Rongwei Liu <rongweil@nvidia.com>
Reviewed-by: Shun Hao <shunh@nvidia.com>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_dbg.c      |  3 +-
 .../mellanox/mlx5/core/steering/dr_rule.c     | 24 +++----
 .../mellanox/mlx5/core/steering/dr_send.c     |  3 +-
 .../mellanox/mlx5/core/steering/dr_ste.c      | 63 +++++++++++--------
 .../mellanox/mlx5/core/steering/dr_types.h    |  2 +-
 5 files changed, 55 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
index 8fd98b628740..d5998ef59be4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
@@ -217,7 +217,8 @@ dr_dump_rule_mem(struct seq_file *file, struct mlx5dr_ste *ste,
 				       DR_DUMP_REC_TYPE_RULE_TX_ENTRY_V1;
 	}
 
-	dr_dump_hex_print(hw_ste_dump, (char *)ste->hw_ste, DR_STE_SIZE_REDUCED);
+	dr_dump_hex_print(hw_ste_dump, (char *)mlx5dr_ste_get_hw_ste(ste),
+			  DR_STE_SIZE_REDUCED);
 
 	seq_printf(file, "%d,0x%llx,0x%llx,%s\n", mem_rec_type,
 		   dr_dump_icm_to_idx(mlx5dr_ste_get_icm_addr(ste)), rule_id,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index 698e1cfc9571..ddfaf7891188 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -21,12 +21,12 @@ static int dr_rule_append_to_miss_list(struct mlx5dr_ste_ctx *ste_ctx,
 	if (!ste_info_last)
 		return -ENOMEM;
 
-	mlx5dr_ste_set_miss_addr(ste_ctx, last_ste->hw_ste,
+	mlx5dr_ste_set_miss_addr(ste_ctx, mlx5dr_ste_get_hw_ste(last_ste),
 				 mlx5dr_ste_get_icm_addr(new_last_ste));
 	list_add_tail(&new_last_ste->miss_list_node, miss_list);
 
 	mlx5dr_send_fill_and_append_ste_send_info(last_ste, DR_STE_SIZE_CTRL,
-						  0, last_ste->hw_ste,
+						  0, mlx5dr_ste_get_hw_ste(last_ste),
 						  ste_info_last, send_list, true);
 
 	return 0;
@@ -108,9 +108,11 @@ dr_rule_handle_one_ste_in_update_list(struct mlx5dr_ste_send_info *ste_info,
 	 * is already written to the hw.
 	 */
 	if (ste_info->size == DR_STE_SIZE_CTRL)
-		memcpy(ste_info->ste->hw_ste, ste_info->data, DR_STE_SIZE_CTRL);
+		memcpy(mlx5dr_ste_get_hw_ste(ste_info->ste),
+		       ste_info->data, DR_STE_SIZE_CTRL);
 	else
-		memcpy(ste_info->ste->hw_ste, ste_info->data, DR_STE_SIZE_REDUCED);
+		memcpy(mlx5dr_ste_get_hw_ste(ste_info->ste),
+		       ste_info->data, DR_STE_SIZE_REDUCED);
 
 	ret = mlx5dr_send_postsend_ste(dmn, ste_info->ste, ste_info->data,
 				       ste_info->size, ste_info->offset);
@@ -160,7 +162,7 @@ dr_rule_find_ste_in_miss_list(struct list_head *miss_list, u8 *hw_ste)
 
 	/* Check if hw_ste is present in the list */
 	list_for_each_entry(ste, miss_list, miss_list_node) {
-		if (mlx5dr_ste_equal_tag(ste->hw_ste, hw_ste))
+		if (mlx5dr_ste_equal_tag(mlx5dr_ste_get_hw_ste(ste), hw_ste))
 			return ste;
 	}
 
@@ -246,7 +248,7 @@ dr_rule_rehash_copy_ste(struct mlx5dr_matcher *matcher,
 
 	/* Copy STE control and tag */
 	icm_addr = mlx5dr_icm_pool_get_chunk_icm_addr(nic_matcher->e_anchor->chunk);
-	memcpy(hw_ste, cur_ste->hw_ste, DR_STE_SIZE_REDUCED);
+	memcpy(hw_ste, mlx5dr_ste_get_hw_ste(cur_ste), DR_STE_SIZE_REDUCED);
 	mlx5dr_ste_set_miss_addr(dmn->ste_ctx, hw_ste, icm_addr);
 
 	new_idx = mlx5dr_ste_calc_hash_index(hw_ste, new_htbl);
@@ -271,7 +273,7 @@ dr_rule_rehash_copy_ste(struct mlx5dr_matcher *matcher,
 		use_update_list = true;
 	}
 
-	memcpy(new_ste->hw_ste, hw_ste, DR_STE_SIZE_REDUCED);
+	memcpy(mlx5dr_ste_get_hw_ste(new_ste), hw_ste, DR_STE_SIZE_REDUCED);
 
 	new_htbl->ctrl.num_of_valid_entries++;
 
@@ -448,21 +450,21 @@ dr_rule_rehash_htbl(struct mlx5dr_rule *rule,
 		 * (48B len) which works only on first 32B
 		 */
 		mlx5dr_ste_set_hit_addr(dmn->ste_ctx,
-					prev_htbl->chunk->ste_arr[0].hw_ste,
+					prev_htbl->chunk->hw_ste_arr,
 					mlx5dr_icm_pool_get_chunk_icm_addr(new_htbl->chunk),
 					mlx5dr_icm_pool_get_chunk_num_of_entries(new_htbl->chunk));
 
 		ste_to_update = &prev_htbl->chunk->ste_arr[0];
 	} else {
 		mlx5dr_ste_set_hit_addr_by_next_htbl(dmn->ste_ctx,
-						     cur_htbl->pointing_ste->hw_ste,
+						     mlx5dr_ste_get_hw_ste(cur_htbl->pointing_ste),
 						     new_htbl);
 		ste_to_update = cur_htbl->pointing_ste;
 	}
 
 	mlx5dr_send_fill_and_append_ste_send_info(ste_to_update, DR_STE_SIZE_CTRL,
-						  0, ste_to_update->hw_ste, ste_info,
-						  update_list, false);
+						  0, mlx5dr_ste_get_hw_ste(ste_to_update),
+						  ste_info, update_list, false);
 
 	return new_htbl;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index 26a91c4415c5..ef19a66f5233 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -495,7 +495,8 @@ int mlx5dr_send_postsend_htbl(struct mlx5dr_domain *dmn,
 			} else {
 				/* Copy data */
 				memcpy(data + ste_off,
-				       htbl->chunk->ste_arr[ste_index + j].hw_ste,
+				       htbl->chunk->hw_ste_arr +
+				       DR_STE_SIZE_REDUCED * (ste_index + j),
 				       DR_STE_SIZE_REDUCED);
 				/* Copy bit_mask */
 				memcpy(data + ste_off + DR_STE_SIZE_REDUCED,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 3ab155feba5e..09ebd3088857 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -97,13 +97,11 @@ void mlx5dr_ste_set_miss_addr(struct mlx5dr_ste_ctx *ste_ctx,
 }
 
 static void dr_ste_always_miss_addr(struct mlx5dr_ste_ctx *ste_ctx,
-				    struct mlx5dr_ste *ste, u64 miss_addr)
+				    u8 *hw_ste, u64 miss_addr)
 {
-	u8 *hw_ste_p = ste->hw_ste;
-
-	ste_ctx->set_next_lu_type(hw_ste_p, MLX5DR_STE_LU_TYPE_DONT_CARE);
-	ste_ctx->set_miss_addr(hw_ste_p, miss_addr);
-	dr_ste_set_always_miss((struct dr_hw_ste_format *)ste->hw_ste);
+	ste_ctx->set_next_lu_type(hw_ste, MLX5DR_STE_LU_TYPE_DONT_CARE);
+	ste_ctx->set_miss_addr(hw_ste, miss_addr);
+	dr_ste_set_always_miss((struct dr_hw_ste_format *)hw_ste);
 }
 
 void mlx5dr_ste_set_hit_addr(struct mlx5dr_ste_ctx *ste_ctx,
@@ -127,6 +125,13 @@ u64 mlx5dr_ste_get_mr_addr(struct mlx5dr_ste *ste)
 	return mlx5dr_icm_pool_get_chunk_mr_addr(ste->htbl->chunk) + DR_STE_SIZE * index;
 }
 
+u8 *mlx5dr_ste_get_hw_ste(struct mlx5dr_ste *ste)
+{
+	u64 index = ste - ste->htbl->chunk->ste_arr;
+
+	return ste->htbl->chunk->hw_ste_arr + DR_STE_SIZE_REDUCED * index;
+}
+
 struct list_head *mlx5dr_ste_get_miss_list(struct mlx5dr_ste *ste)
 {
 	u32 index = ste - ste->htbl->chunk->ste_arr;
@@ -135,18 +140,17 @@ struct list_head *mlx5dr_ste_get_miss_list(struct mlx5dr_ste *ste)
 }
 
 static void dr_ste_always_hit_htbl(struct mlx5dr_ste_ctx *ste_ctx,
-				   struct mlx5dr_ste *ste,
+				   u8 *hw_ste,
 				   struct mlx5dr_ste_htbl *next_htbl)
 {
 	struct mlx5dr_icm_chunk *chunk = next_htbl->chunk;
-	u8 *hw_ste = ste->hw_ste;
 
 	ste_ctx->set_byte_mask(hw_ste, next_htbl->byte_mask);
 	ste_ctx->set_next_lu_type(hw_ste, next_htbl->lu_type);
 	ste_ctx->set_hit_addr(hw_ste, mlx5dr_icm_pool_get_chunk_icm_addr(chunk),
 			      mlx5dr_icm_pool_get_chunk_num_of_entries(chunk));
 
-	dr_ste_set_always_hit((struct dr_hw_ste_format *)ste->hw_ste);
+	dr_ste_set_always_hit((struct dr_hw_ste_format *)hw_ste);
 }
 
 bool mlx5dr_ste_is_last_in_rule(struct mlx5dr_matcher_rx_tx *nic_matcher,
@@ -169,7 +173,8 @@ bool mlx5dr_ste_is_last_in_rule(struct mlx5dr_matcher_rx_tx *nic_matcher,
  */
 static void dr_ste_replace(struct mlx5dr_ste *dst, struct mlx5dr_ste *src)
 {
-	memcpy(dst->hw_ste, src->hw_ste, DR_STE_SIZE_REDUCED);
+	memcpy(mlx5dr_ste_get_hw_ste(dst), mlx5dr_ste_get_hw_ste(src),
+	       DR_STE_SIZE_REDUCED);
 	dst->next_htbl = src->next_htbl;
 	if (dst->next_htbl)
 		dst->next_htbl->pointing_ste = dst;
@@ -187,18 +192,17 @@ dr_ste_remove_head_ste(struct mlx5dr_ste_ctx *ste_ctx,
 		       struct mlx5dr_ste_htbl *stats_tbl)
 {
 	u8 tmp_data_ste[DR_STE_SIZE] = {};
-	struct mlx5dr_ste tmp_ste = {};
 	u64 miss_addr;
 
-	tmp_ste.hw_ste = tmp_data_ste;
+	miss_addr = mlx5dr_icm_pool_get_chunk_icm_addr(nic_matcher->e_anchor->chunk);
 
 	/* Use temp ste because dr_ste_always_miss_addr
 	 * touches bit_mask area which doesn't exist at ste->hw_ste.
+	 * Need to use a full-sized (DR_STE_SIZE) hw_ste.
 	 */
-	memcpy(tmp_ste.hw_ste, ste->hw_ste, DR_STE_SIZE_REDUCED);
-	miss_addr = mlx5dr_icm_pool_get_chunk_icm_addr(nic_matcher->e_anchor->chunk);
-	dr_ste_always_miss_addr(ste_ctx, &tmp_ste, miss_addr);
-	memcpy(ste->hw_ste, tmp_ste.hw_ste, DR_STE_SIZE_REDUCED);
+	memcpy(tmp_data_ste, mlx5dr_ste_get_hw_ste(ste), DR_STE_SIZE_REDUCED);
+	dr_ste_always_miss_addr(ste_ctx, tmp_data_ste, miss_addr);
+	memcpy(mlx5dr_ste_get_hw_ste(ste), tmp_data_ste, DR_STE_SIZE_REDUCED);
 
 	list_del_init(&ste->miss_list_node);
 
@@ -240,7 +244,7 @@ dr_ste_replace_head_ste(struct mlx5dr_matcher_rx_tx *nic_matcher,
 	mlx5dr_rule_set_last_member(next_ste->rule_rx_tx, ste, false);
 
 	/* Copy all 64 hw_ste bytes */
-	memcpy(hw_ste, ste->hw_ste, DR_STE_SIZE_REDUCED);
+	memcpy(hw_ste, mlx5dr_ste_get_hw_ste(ste), DR_STE_SIZE_REDUCED);
 	sb_idx = ste->ste_chain_location - 1;
 	mlx5dr_ste_set_bit_mask(hw_ste,
 				nic_matcher->ste_builder[sb_idx].bit_mask);
@@ -276,12 +280,13 @@ static void dr_ste_remove_middle_ste(struct mlx5dr_ste_ctx *ste_ctx,
 	if (WARN_ON(!prev_ste))
 		return;
 
-	miss_addr = ste_ctx->get_miss_addr(ste->hw_ste);
-	ste_ctx->set_miss_addr(prev_ste->hw_ste, miss_addr);
+	miss_addr = ste_ctx->get_miss_addr(mlx5dr_ste_get_hw_ste(ste));
+	ste_ctx->set_miss_addr(mlx5dr_ste_get_hw_ste(prev_ste), miss_addr);
 
 	mlx5dr_send_fill_and_append_ste_send_info(prev_ste, DR_STE_SIZE_CTRL, 0,
-						  prev_ste->hw_ste, ste_info,
-						  send_ste_list, true /* Copy data*/);
+						  mlx5dr_ste_get_hw_ste(prev_ste),
+						  ste_info, send_ste_list,
+						  true /* Copy data*/);
 
 	list_del_init(&ste->miss_list_node);
 
@@ -390,15 +395,22 @@ void mlx5dr_ste_set_formatted_ste(struct mlx5dr_ste_ctx *ste_ctx,
 				  struct mlx5dr_htbl_connect_info *connect_info)
 {
 	bool is_rx = nic_type == DR_DOMAIN_NIC_TYPE_RX;
-	struct mlx5dr_ste ste = {};
+	u8 tmp_hw_ste[DR_STE_SIZE] = {0};
 
 	ste_ctx->ste_init(formatted_ste, htbl->lu_type, is_rx, gvmi);
-	ste.hw_ste = formatted_ste;
 
+	/* Use temp ste because dr_ste_always_miss_addr/hit_htbl
+	 * touches bit_mask area which doesn't exist at ste->hw_ste.
+	 * Need to use a full-sized (DR_STE_SIZE) hw_ste.
+	 */
+	memcpy(tmp_hw_ste, formatted_ste, DR_STE_SIZE_REDUCED);
 	if (connect_info->type == CONNECT_HIT)
-		dr_ste_always_hit_htbl(ste_ctx, &ste, connect_info->hit_next_htbl);
+		dr_ste_always_hit_htbl(ste_ctx, tmp_hw_ste,
+				       connect_info->hit_next_htbl);
 	else
-		dr_ste_always_miss_addr(ste_ctx, &ste, connect_info->miss_icm_addr);
+		dr_ste_always_miss_addr(ste_ctx, tmp_hw_ste,
+					connect_info->miss_icm_addr);
+	memcpy(formatted_ste, tmp_hw_ste, DR_STE_SIZE_REDUCED);
 }
 
 int mlx5dr_ste_htbl_init_and_postsend(struct mlx5dr_domain *dmn,
@@ -496,7 +508,6 @@ struct mlx5dr_ste_htbl *mlx5dr_ste_htbl_alloc(struct mlx5dr_icm_pool *pool,
 	for (i = 0; i < num_entries; i++) {
 		struct mlx5dr_ste *ste = &chunk->ste_arr[i];
 
-		ste->hw_ste = chunk->hw_ste_arr + i * DR_STE_SIZE_REDUCED;
 		ste->htbl = htbl;
 		ste->refcount = 0;
 		INIT_LIST_HEAD(&ste->miss_list_node);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 1294c12ceb10..46866a5fc5ca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -147,7 +147,6 @@ struct mlx5dr_matcher_rx_tx;
 struct mlx5dr_ste_ctx;
 
 struct mlx5dr_ste {
-	u8 *hw_ste;
 	/* refcount: indicates the num of rules that using this ste */
 	u32 refcount;
 
@@ -1140,6 +1139,7 @@ u32 mlx5dr_icm_pool_get_chunk_rkey(struct mlx5dr_icm_chunk *chunk);
 u64 mlx5dr_icm_pool_get_chunk_icm_addr(struct mlx5dr_icm_chunk *chunk);
 u32 mlx5dr_icm_pool_get_chunk_num_of_entries(struct mlx5dr_icm_chunk *chunk);
 u32 mlx5dr_icm_pool_get_chunk_byte_size(struct mlx5dr_icm_chunk *chunk);
+u8 *mlx5dr_ste_get_hw_ste(struct mlx5dr_ste *ste);
 
 static inline int
 mlx5dr_icm_pool_dm_type_to_entry_size(enum mlx5dr_icm_type icm_type)
-- 
2.35.1

