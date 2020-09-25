Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7B12791DE
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 22:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbgIYURe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 16:17:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727402AbgIYUPb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 16:15:31 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 237B1238D6;
        Fri, 25 Sep 2020 19:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601062701;
        bh=7ogmpV378h+F06NIkCYNrd4xk1dRAqKNHMbRxZ46aOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WmQaHYuaeL1QB3QlYpBPUYzncKb0eLORdP+4b5PHXvy4+lguj959Gp8Rc/KOQ+X1M
         tUXmzmiqyoMrGcj1yCNxQi0l/uQxQgC84NiLiX0dYD+YTfjPLU9JQy9t41Am9nvYu8
         pGgCvS5e49+LZ3UdAgmk4xv9jTJCoO8bQNqXQwv8=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/15] net/mlx5: DR, Replace the check for valid STE entry
Date:   Fri, 25 Sep 2020 12:38:01 -0700
Message-Id: <20200925193809.463047-8-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200925193809.463047-1-saeed@kernel.org>
References: <20200925193809.463047-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Validity check is done by reading the next lu_type from the STE,
this check can be replaced by checking the refcount.
This will make the check independent on internal STE structure.

Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_rule.c     |  6 +++---
 .../mellanox/mlx5/core/steering/dr_send.c     |  4 ++--
 .../mellanox/mlx5/core/steering/dr_ste.c      | 19 -------------------
 .../mellanox/mlx5/core/steering/dr_types.h    |  7 +++++--
 4 files changed, 10 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index 6ec5106bc472..17577181ce8f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -242,7 +242,7 @@ dr_rule_rehash_copy_ste(struct mlx5dr_matcher *matcher,
 	new_idx = mlx5dr_ste_calc_hash_index(hw_ste, new_htbl);
 	new_ste = &new_htbl->ste_arr[new_idx];
 
-	if (mlx5dr_ste_not_used_ste(new_ste)) {
+	if (mlx5dr_ste_is_not_used(new_ste)) {
 		mlx5dr_htbl_get(new_htbl);
 		list_add_tail(&new_ste->miss_list_node,
 			      mlx5dr_ste_get_miss_list(new_ste));
@@ -335,7 +335,7 @@ static int dr_rule_rehash_copy_htbl(struct mlx5dr_matcher *matcher,
 
 	for (i = 0; i < cur_entries; i++) {
 		cur_ste = &cur_htbl->ste_arr[i];
-		if (mlx5dr_ste_not_used_ste(cur_ste)) /* Empty, nothing to copy */
+		if (mlx5dr_ste_is_not_used(cur_ste)) /* Empty, nothing to copy */
 			continue;
 
 		err = dr_rule_rehash_copy_miss_list(matcher,
@@ -791,7 +791,7 @@ dr_rule_handle_ste_branch(struct mlx5dr_rule *rule,
 	miss_list = &cur_htbl->chunk->miss_list[index];
 	ste = &cur_htbl->ste_arr[index];
 
-	if (mlx5dr_ste_not_used_ste(ste)) {
+	if (mlx5dr_ste_is_not_used(ste)) {
 		if (dr_rule_handle_empty_entry(matcher, nic_matcher, cur_htbl,
 					       ste, ste_location,
 					       hw_ste, miss_list,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index 2ca79b9bde1f..3d77f7d9fbdf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -466,10 +466,10 @@ int mlx5dr_send_postsend_htbl(struct mlx5dr_domain *dmn,
 		 * need to add the bit_mask
 		 */
 		for (j = 0; j < num_stes_per_iter; j++) {
-			u8 *hw_ste = htbl->ste_arr[ste_index + j].hw_ste;
+			struct mlx5dr_ste *ste = &htbl->ste_arr[ste_index + j];
 			u32 ste_off = j * DR_STE_SIZE;
 
-			if (mlx5dr_ste_is_not_valid_entry(hw_ste)) {
+			if (mlx5dr_ste_is_not_used(ste)) {
 				memcpy(data + ste_off,
 				       formatted_ste, DR_STE_SIZE);
 			} else {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 00c2f598f034..053e63844bd2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -549,25 +549,6 @@ void mlx5dr_ste_always_miss_addr(struct mlx5dr_ste *ste, u64 miss_addr)
 	dr_ste_set_always_miss((struct dr_hw_ste_format *)ste->hw_ste);
 }
 
-/* The assumption here is that we don't update the ste->hw_ste if it is not
- * used ste, so it will be all zero, checking the next_lu_type.
- */
-bool mlx5dr_ste_is_not_valid_entry(u8 *p_hw_ste)
-{
-	struct dr_hw_ste_format *hw_ste = (struct dr_hw_ste_format *)p_hw_ste;
-
-	if (MLX5_GET(ste_general, hw_ste, next_lu_type) ==
-	    MLX5DR_STE_LU_TYPE_NOP)
-		return true;
-
-	return false;
-}
-
-bool mlx5dr_ste_not_used_ste(struct mlx5dr_ste *ste)
-{
-	return !ste->refcount;
-}
-
 /* Init one ste as a pattern for ste data array */
 void mlx5dr_ste_set_formatted_ste(u16 gvmi,
 				  struct mlx5dr_domain_rx_tx *nic_dmn,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index f71ca74f96fd..07cf24a38d47 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -227,7 +227,6 @@ void mlx5dr_ste_set_hit_gvmi(u8 *hw_ste_p, u16 gvmi);
 void mlx5dr_ste_set_hit_addr(u8 *hw_ste, u64 icm_addr, u32 ht_size);
 void mlx5dr_ste_always_miss_addr(struct mlx5dr_ste *ste, u64 miss_addr);
 void mlx5dr_ste_set_bit_mask(u8 *hw_ste_p, u8 *bit_mask);
-bool mlx5dr_ste_not_used_ste(struct mlx5dr_ste *ste);
 bool mlx5dr_ste_is_last_in_rule(struct mlx5dr_matcher_rx_tx *nic_matcher,
 				u8 ste_location);
 void mlx5dr_ste_rx_set_flow_tag(u8 *hw_ste_p, u32 flow_tag);
@@ -266,6 +265,11 @@ static inline void mlx5dr_ste_get(struct mlx5dr_ste *ste)
 	ste->refcount++;
 }
 
+static inline bool mlx5dr_ste_is_not_used(struct mlx5dr_ste *ste)
+{
+	return !ste->refcount;
+}
+
 void mlx5dr_ste_set_hit_addr_by_next_htbl(u8 *hw_ste,
 					  struct mlx5dr_ste_htbl *next_htbl);
 bool mlx5dr_ste_equal_tag(void *src, void *dst);
@@ -1001,7 +1005,6 @@ struct mlx5dr_icm_chunk *
 mlx5dr_icm_alloc_chunk(struct mlx5dr_icm_pool *pool,
 		       enum mlx5dr_icm_chunk_size chunk_size);
 void mlx5dr_icm_free_chunk(struct mlx5dr_icm_chunk *chunk);
-bool mlx5dr_ste_is_not_valid_entry(u8 *p_hw_ste);
 int mlx5dr_ste_htbl_init_and_postsend(struct mlx5dr_domain *dmn,
 				      struct mlx5dr_domain_rx_tx *nic_dmn,
 				      struct mlx5dr_ste_htbl *htbl,
-- 
2.26.2

