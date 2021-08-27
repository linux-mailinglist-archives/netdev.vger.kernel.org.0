Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D973F91C7
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 03:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244022AbhH0BAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 21:00:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244082AbhH0A7r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 20:59:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B770F610D1;
        Fri, 27 Aug 2021 00:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630025906;
        bh=6YWY6+fbE3Ct9rT6kbWacf4ImmGDml+JURs6uFy3zOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H4bEts+rRDvYMyd+Psh/zSVQAwW8hteLVQ4JQ026PTjcvU6ZuSlznKYQAmIwEdWop
         qU+T65x/GGwx77f3qGIU0d1vu1bPkoheU9IDQ9BL6UIzQzq4VwkQnL3IenWq5tup/X
         J6NEsTMxLiGcAqKuassKvOLm7IPDsg4pN8uNezqPp6uGAC1u36ASklGDk7kgw4FdAG
         UbCR4/NXlCc5fRHfN9YmAp/Q7nmd6ZcIJJ54FS1iDRRlSYMZAesu5wb6MpBDiyld7d
         ICQXNEQA9+9WeCnorcqab8LpX4f9suEvYvU6RN0XOpwVxJysZAx9DDBVBdVYdvsd15
         Vp0ewhu3xtdbw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Erez Shitrit <erezsh@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 16/17] net/mlx5: DR, Improve rule tracking memory consumption
Date:   Thu, 26 Aug 2021 17:58:01 -0700
Message-Id: <20210827005802.236119-17-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210827005802.236119-1-saeed@kernel.org>
References: <20210827005802.236119-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

To track each STE of the rule a rule member was allocated, each
member would point to one STE. This means that we would allocate
40B (rule member) * number of STEs per rule.

To reduce this per rule allocation we use the STE tree pointers
for next_htbl and pointing STE to navigate the tree, this allows
us to keep only the pointer to the last STE of rule (always unique).
From the last rule STE we are able to traverse and rebuild all of
the STEs that construct the rule.

In our testing with 8M rules, each consisting of 7 STES, we were able
to reduce 1.6GB of memory.

Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_rule.c     | 134 +++++++++---------
 .../mellanox/mlx5/core/steering/dr_ste.c      |  10 +-
 .../mellanox/mlx5/core/steering/dr_types.h    |  25 ++--
 3 files changed, 83 insertions(+), 86 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index f853a48e07b2..a1c8ac0ecc23 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -81,6 +81,7 @@ dr_rule_create_collision_entry(struct mlx5dr_matcher *matcher,
 	}
 
 	ste->ste_chain_location = orig_ste->ste_chain_location;
+	ste->htbl->pointing_ste = orig_ste->htbl->pointing_ste;
 
 	/* In collision entry, all members share the same miss_list_head */
 	ste->htbl->miss_list = mlx5dr_ste_get_miss_list(orig_ste);
@@ -185,6 +186,9 @@ dr_rule_rehash_handle_collision(struct mlx5dr_matcher *matcher,
 	if (!new_ste)
 		return NULL;
 
+	/* Update collision pointing STE */
+	new_ste->htbl->pointing_ste = col_ste->htbl->pointing_ste;
+
 	/* In collision entry, all members share the same miss_list_head */
 	new_ste->htbl->miss_list = mlx5dr_ste_get_miss_list(col_ste);
 
@@ -212,7 +216,7 @@ static void dr_rule_rehash_copy_ste_ctrl(struct mlx5dr_matcher *matcher,
 	new_ste->next_htbl = cur_ste->next_htbl;
 	new_ste->ste_chain_location = cur_ste->ste_chain_location;
 
-	if (!mlx5dr_ste_is_last_in_rule(nic_matcher, new_ste->ste_chain_location))
+	if (new_ste->next_htbl)
 		new_ste->next_htbl->pointing_ste = new_ste;
 
 	/* We need to copy the refcount since this ste
@@ -220,10 +224,8 @@ static void dr_rule_rehash_copy_ste_ctrl(struct mlx5dr_matcher *matcher,
 	 */
 	new_ste->refcount = cur_ste->refcount;
 
-	/* Link old STEs rule_mem list to the new ste */
-	mlx5dr_rule_update_rule_member(cur_ste, new_ste);
-	INIT_LIST_HEAD(&new_ste->rule_list);
-	list_splice_tail_init(&cur_ste->rule_list, &new_ste->rule_list);
+	/* Link old STEs rule to the new ste */
+	mlx5dr_rule_set_last_member(cur_ste->rule_rx_tx, new_ste, false);
 }
 
 static struct mlx5dr_ste *
@@ -581,34 +583,66 @@ static int dr_rule_add_action_members(struct mlx5dr_rule *rule,
 	return -ENOMEM;
 }
 
-/* While the pointer of ste is no longer valid, like while moving ste to be
- * the first in the miss_list, and to be in the origin table,
- * all rule-members that are attached to this ste should update their ste member
- * to the new pointer
- */
-void mlx5dr_rule_update_rule_member(struct mlx5dr_ste *ste,
-				    struct mlx5dr_ste *new_ste)
+void mlx5dr_rule_set_last_member(struct mlx5dr_rule_rx_tx *nic_rule,
+				 struct mlx5dr_ste *ste,
+				 bool force)
+{
+	/* Update rule member is usually done for the last STE or during rule
+	 * creation to recover from mid-creation failure (for this peruse the
+	 * force flag is used)
+	 */
+	if (ste->next_htbl && !force)
+		return;
+
+	/* Update is required since each rule keeps track of its last STE */
+	ste->rule_rx_tx = nic_rule;
+	nic_rule->last_rule_ste = ste;
+}
+
+static struct mlx5dr_ste *dr_rule_get_pointed_ste(struct mlx5dr_ste *curr_ste)
+{
+	struct mlx5dr_ste *first_ste;
+
+	first_ste = list_first_entry(mlx5dr_ste_get_miss_list(curr_ste),
+				     struct mlx5dr_ste, miss_list_node);
+
+	return first_ste->htbl->pointing_ste;
+}
+
+int mlx5dr_rule_get_reverse_rule_members(struct mlx5dr_ste **ste_arr,
+					 struct mlx5dr_ste *curr_ste,
+					 int *num_of_stes)
 {
-	struct mlx5dr_rule_member *rule_mem;
+	bool first = false;
+
+	*num_of_stes = 0;
+
+	if (!curr_ste)
+		return -ENOENT;
+
+	/* Iterate from last to first */
+	while (!first) {
+		first = curr_ste->ste_chain_location == 1;
+		ste_arr[*num_of_stes] = curr_ste;
+		*num_of_stes += 1;
+		curr_ste = dr_rule_get_pointed_ste(curr_ste);
+	}
 
-	list_for_each_entry(rule_mem, &ste->rule_list, use_ste_list)
-		rule_mem->ste = new_ste;
+	return 0;
 }
 
 static void dr_rule_clean_rule_members(struct mlx5dr_rule *rule,
 				       struct mlx5dr_rule_rx_tx *nic_rule)
 {
-	struct mlx5dr_rule_member *rule_mem;
-	struct mlx5dr_rule_member *tmp_mem;
+	struct mlx5dr_ste *ste_arr[DR_RULE_MAX_STES + DR_ACTION_MAX_STES];
+	struct mlx5dr_ste *curr_ste = nic_rule->last_rule_ste;
+	int i;
 
-	if (list_empty(&nic_rule->rule_members_list))
+	if (mlx5dr_rule_get_reverse_rule_members(ste_arr, curr_ste, &i))
 		return;
-	list_for_each_entry_safe(rule_mem, tmp_mem, &nic_rule->rule_members_list, list) {
-		list_del(&rule_mem->list);
-		list_del(&rule_mem->use_ste_list);
-		mlx5dr_ste_put(rule_mem->ste, rule->matcher, nic_rule->nic_matcher);
-		kvfree(rule_mem);
-	}
+
+	while (i--)
+		mlx5dr_ste_put(ste_arr[i], rule->matcher, nic_rule->nic_matcher);
 }
 
 static u16 dr_get_bits_per_mask(u16 byte_mask)
@@ -647,26 +681,6 @@ static bool dr_rule_need_enlarge_hash(struct mlx5dr_ste_htbl *htbl,
 	return false;
 }
 
-static int dr_rule_add_member(struct mlx5dr_rule_rx_tx *nic_rule,
-			      struct mlx5dr_ste *ste)
-{
-	struct mlx5dr_rule_member *rule_mem;
-
-	rule_mem = kvzalloc(sizeof(*rule_mem), GFP_KERNEL);
-	if (!rule_mem)
-		return -ENOMEM;
-
-	INIT_LIST_HEAD(&rule_mem->list);
-	INIT_LIST_HEAD(&rule_mem->use_ste_list);
-
-	rule_mem->ste = ste;
-	list_add_tail(&rule_mem->list, &nic_rule->rule_members_list);
-
-	list_add_tail(&rule_mem->use_ste_list, &ste->rule_list);
-
-	return 0;
-}
-
 static int dr_rule_handle_action_stes(struct mlx5dr_rule *rule,
 				      struct mlx5dr_rule_rx_tx *nic_rule,
 				      struct list_head *send_ste_list,
@@ -681,15 +695,13 @@ static int dr_rule_handle_action_stes(struct mlx5dr_rule *rule,
 	struct mlx5dr_domain *dmn = matcher->tbl->dmn;
 	u8 *curr_hw_ste, *prev_hw_ste;
 	struct mlx5dr_ste *action_ste;
-	int i, k, ret;
+	int i, k;
 
 	/* Two cases:
 	 * 1. num_of_builders is equal to new_hw_ste_arr_sz, the action in the ste
 	 * 2. num_of_builders is less then new_hw_ste_arr_sz, new ste was added
 	 *    to support the action.
 	 */
-	if (num_of_builders == new_hw_ste_arr_sz)
-		return 0;
 
 	for (i = num_of_builders, k = 0; i < new_hw_ste_arr_sz; i++, k++) {
 		curr_hw_ste = hw_ste_arr + i * DR_STE_SIZE;
@@ -702,6 +714,10 @@ static int dr_rule_handle_action_stes(struct mlx5dr_rule *rule,
 
 		mlx5dr_ste_get(action_ste);
 
+		action_ste->htbl->pointing_ste = last_ste;
+		last_ste->next_htbl = action_ste->htbl;
+		last_ste = action_ste;
+
 		/* While free ste we go over the miss list, so add this ste to the list */
 		list_add_tail(&action_ste->miss_list_node,
 			      mlx5dr_ste_get_miss_list(action_ste));
@@ -715,21 +731,19 @@ static int dr_rule_handle_action_stes(struct mlx5dr_rule *rule,
 		mlx5dr_ste_set_hit_addr_by_next_htbl(dmn->ste_ctx,
 						     prev_hw_ste,
 						     action_ste->htbl);
-		ret = dr_rule_add_member(nic_rule, action_ste);
-		if (ret) {
-			mlx5dr_dbg(dmn, "Failed adding rule member\n");
-			goto free_ste_info;
-		}
+
+		mlx5dr_rule_set_last_member(nic_rule, action_ste, true);
+
 		mlx5dr_send_fill_and_append_ste_send_info(action_ste, DR_STE_SIZE, 0,
 							  curr_hw_ste,
 							  ste_info_arr[k],
 							  send_ste_list, false);
 	}
 
+	last_ste->next_htbl = NULL;
+
 	return 0;
 
-free_ste_info:
-	kfree(ste_info_arr[k]);
 err_exit:
 	mlx5dr_ste_put(action_ste, matcher, nic_matcher);
 	return -ENOMEM;
@@ -1067,8 +1081,6 @@ dr_rule_create_rule_nic(struct mlx5dr_rule *rule,
 	nic_matcher = nic_rule->nic_matcher;
 	nic_dmn = nic_matcher->nic_tbl->nic_dmn;
 
-	INIT_LIST_HEAD(&nic_rule->rule_members_list);
-
 	if (dr_rule_skip(dmn->type, nic_dmn->type, &matcher->mask, param,
 			 rule->flow_source))
 		return 0;
@@ -1123,14 +1135,8 @@ dr_rule_create_rule_nic(struct mlx5dr_rule *rule,
 
 		cur_htbl = ste->next_htbl;
 
-		/* Keep all STEs in the rule struct */
-		ret = dr_rule_add_member(nic_rule, ste);
-		if (ret) {
-			mlx5dr_dbg(dmn, "Failed adding rule member index %d\n", i);
-			goto free_ste;
-		}
-
 		mlx5dr_ste_get(ste);
+		mlx5dr_rule_set_last_member(nic_rule, ste, true);
 	}
 
 	/* Connect actions */
@@ -1155,8 +1161,6 @@ dr_rule_create_rule_nic(struct mlx5dr_rule *rule,
 
 	return 0;
 
-free_ste:
-	mlx5dr_ste_put(ste, matcher, nic_matcher);
 free_rule:
 	dr_rule_clean_rule_members(rule, nic_rule);
 	/* Clean all ste_info's */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 15fecb491c55..1cdfe4fccc7a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -172,9 +172,6 @@ static void dr_ste_replace(struct mlx5dr_ste *dst, struct mlx5dr_ste *src)
 		dst->next_htbl->pointing_ste = dst;
 
 	dst->refcount = src->refcount;
-
-	INIT_LIST_HEAD(&dst->rule_list);
-	list_splice_tail_init(&src->rule_list, &dst->rule_list);
 }
 
 /* Free ste which is the head and the only one in miss_list */
@@ -233,12 +230,12 @@ dr_ste_replace_head_ste(struct mlx5dr_matcher_rx_tx *nic_matcher,
 	/* Remove from the miss_list the next_ste before copy */
 	list_del_init(&next_ste->miss_list_node);
 
-	/* All rule-members that use next_ste should know about that */
-	mlx5dr_rule_update_rule_member(next_ste, ste);
-
 	/* Move data from next into ste */
 	dr_ste_replace(ste, next_ste);
 
+	/* Update the rule on STE change */
+	mlx5dr_rule_set_last_member(next_ste->rule_rx_tx, ste, false);
+
 	/* Copy all 64 hw_ste bytes */
 	memcpy(hw_ste, ste->hw_ste, DR_STE_SIZE_REDUCED);
 	sb_idx = ste->ste_chain_location - 1;
@@ -499,7 +496,6 @@ struct mlx5dr_ste_htbl *mlx5dr_ste_htbl_alloc(struct mlx5dr_icm_pool *pool,
 		ste->refcount = 0;
 		INIT_LIST_HEAD(&ste->miss_list_node);
 		INIT_LIST_HEAD(&htbl->miss_list[i]);
-		INIT_LIST_HEAD(&ste->rule_list);
 	}
 
 	htbl->chunk_size = chunk_size;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 9ba4f379afa5..b20e8aabb861 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -140,6 +140,7 @@ struct mlx5dr_icm_buddy_mem;
 struct mlx5dr_ste_htbl;
 struct mlx5dr_match_param;
 struct mlx5dr_cmd_caps;
+struct mlx5dr_rule_rx_tx;
 struct mlx5dr_matcher_rx_tx;
 struct mlx5dr_ste_ctx;
 
@@ -151,14 +152,14 @@ struct mlx5dr_ste {
 	/* attached to the miss_list head at each htbl entry */
 	struct list_head miss_list_node;
 
-	/* each rule member that uses this ste attached here */
-	struct list_head rule_list;
-
 	/* this ste is member of htbl */
 	struct mlx5dr_ste_htbl *htbl;
 
 	struct mlx5dr_ste_htbl *next_htbl;
 
+	/* The rule this STE belongs to */
+	struct mlx5dr_rule_rx_tx *rule_rx_tx;
+
 	/* this ste is part of a rule, located in ste's chain */
 	u8 ste_chain_location;
 };
@@ -888,14 +889,6 @@ struct mlx5dr_matcher {
 	struct mlx5dv_flow_matcher *dv_matcher;
 };
 
-struct mlx5dr_rule_member {
-	struct mlx5dr_ste *ste;
-	/* attached to mlx5dr_rule via this */
-	struct list_head list;
-	/* attached to mlx5dr_ste via this */
-	struct list_head use_ste_list;
-};
-
 struct mlx5dr_ste_action_modify_field {
 	u16 hw_field;
 	u8 start;
@@ -996,8 +989,8 @@ struct mlx5dr_htbl_connect_info {
 };
 
 struct mlx5dr_rule_rx_tx {
-	struct list_head rule_members_list;
 	struct mlx5dr_matcher_rx_tx *nic_matcher;
+	struct mlx5dr_ste *last_rule_ste;
 };
 
 struct mlx5dr_rule {
@@ -1008,8 +1001,12 @@ struct mlx5dr_rule {
 	u32 flow_source;
 };
 
-void mlx5dr_rule_update_rule_member(struct mlx5dr_ste *new_ste,
-				    struct mlx5dr_ste *ste);
+void mlx5dr_rule_set_last_member(struct mlx5dr_rule_rx_tx *nic_rule,
+				 struct mlx5dr_ste *ste,
+				 bool force);
+int mlx5dr_rule_get_reverse_rule_members(struct mlx5dr_ste **ste_arr,
+					 struct mlx5dr_ste *curr_ste,
+					 int *num_of_stes);
 
 struct mlx5dr_icm_chunk {
 	struct mlx5dr_icm_buddy_mem *buddy_mem;
-- 
2.31.1

