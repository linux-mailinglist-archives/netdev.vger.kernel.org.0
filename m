Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE63481057
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 07:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238973AbhL2GZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 01:25:19 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58324 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238954AbhL2GZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 01:25:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68268B81826
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 06:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5470C36AE7;
        Wed, 29 Dec 2021 06:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640759113;
        bh=fMF8Re9IzAEgCzloiewomcqEn2cjsVu3uAJC5KTDhaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XY2ML4bCeJb7Oo7PcrvTUWD0GcPHk1p+a4x5hWWJPpwcWmzEXNYJtbAvkwBpA/0Ey
         CTnCL7Xs3+u2D1hfCjliModaWVYYSTqUEnP67ohZSu+/cbN/Ip5gbUXmCxKFoQZpS7
         mlYEJZZFM6D4DAwm2vZ9gjN/wYHqWSYCi+n1EAGZvLK+3DWleAPAcp/JG/GwdJ9AuB
         NfA3FoU+F6LE7vHyuqiNT4VJ7GHumklS7RvSJzcKs1F5xjVRdHBchuRu5JGj3eZ8Tk
         UzMPXOzLQEf0h2eSklfvTV3t5FiHJge73raMUgRnIf/cIjeHV/a8qRQGavo0a1QBlC
         Nn3VuExu7g+BA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next  14/16] net/mlx5: DR, Improve steering for empty or RX/TX-only matchers
Date:   Tue, 28 Dec 2021 22:25:00 -0800
Message-Id: <20211229062502.24111-15-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211229062502.24111-1-saeed@kernel.org>
References: <20211229062502.24111-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Every matcher has RX and TX paths. When a new matcher is created, its RX
and TX start/end anchors are connected to the respective RX and TX anchors
of the previous and next matchers.
This creates a potential performance issue: when a certain rule is added
to a matcher, in many cases it is RX or TX only rule, which may create a
long chain of RX/TX-only paths w/o the actual rules.

This patch aims to handle this issue.

RX and TX matchers are now handled separately: matcher connection in the
matchers chain is split into two separate lists: RX only and TX only.
when a new matcher is created, it is initially created 'detached' - its
RX/TX members are not inserted into the table's matcher list.
When an actual rule is added, only its appropriate RX or TX nic matchers
are then added to the table's nic matchers list and inserted into its
place in the chain of matchers.
I.e., if the rule that is being added is an RX-only rule, only the RX
part of the matcher will be connected to the chain, while TX part of the
matcher remains detached and doesn't prolong the TX chain of the matchers.

Same goes for rule deletion: when the last RX/TX rule of the nic matcher
is destroyed, the nic matcher is removed from its list.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_matcher.c  | 160 +++++++++---------
 .../mellanox/mlx5/core/steering/dr_rule.c     |  28 ++-
 .../mellanox/mlx5/core/steering/dr_table.c    |  89 +++++-----
 .../mellanox/mlx5/core/steering/dr_types.h    |   9 +
 4 files changed, 156 insertions(+), 130 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index d9f66faa619e..e87cf498c77b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -683,10 +683,10 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 	return 0;
 }
 
-static int dr_matcher_connect(struct mlx5dr_domain *dmn,
-			      struct mlx5dr_matcher_rx_tx *curr_nic_matcher,
-			      struct mlx5dr_matcher_rx_tx *next_nic_matcher,
-			      struct mlx5dr_matcher_rx_tx *prev_nic_matcher)
+static int dr_nic_matcher_connect(struct mlx5dr_domain *dmn,
+				  struct mlx5dr_matcher_rx_tx *curr_nic_matcher,
+				  struct mlx5dr_matcher_rx_tx *next_nic_matcher,
+				  struct mlx5dr_matcher_rx_tx *prev_nic_matcher)
 {
 	struct mlx5dr_table_rx_tx *nic_tbl = curr_nic_matcher->nic_tbl;
 	struct mlx5dr_domain_rx_tx *nic_dmn = nic_tbl->nic_dmn;
@@ -742,58 +742,50 @@ static int dr_matcher_connect(struct mlx5dr_domain *dmn,
 	return 0;
 }
 
-static int dr_matcher_add_to_tbl(struct mlx5dr_matcher *matcher)
+int mlx5dr_matcher_add_to_tbl_nic(struct mlx5dr_domain *dmn,
+				  struct mlx5dr_matcher_rx_tx *nic_matcher)
 {
-	struct mlx5dr_matcher *next_matcher, *prev_matcher, *tmp_matcher;
-	struct mlx5dr_table *tbl = matcher->tbl;
-	struct mlx5dr_domain *dmn = tbl->dmn;
+	struct mlx5dr_matcher_rx_tx *next_nic_matcher, *prev_nic_matcher, *tmp_nic_matcher;
+	struct mlx5dr_table_rx_tx *nic_tbl = nic_matcher->nic_tbl;
 	bool first = true;
 	int ret;
 
-	next_matcher = NULL;
-	list_for_each_entry(tmp_matcher, &tbl->matcher_list, list_node) {
-		if (tmp_matcher->prio >= matcher->prio) {
-			next_matcher = tmp_matcher;
+	/* If the nic matcher is already on its parent nic table list,
+	 * then it is already connected to the chain of nic matchers.
+	 */
+	if (!list_empty(&nic_matcher->list_node))
+		return 0;
+
+	next_nic_matcher = NULL;
+	list_for_each_entry(tmp_nic_matcher, &nic_tbl->nic_matcher_list, list_node) {
+		if (tmp_nic_matcher->prio >= nic_matcher->prio) {
+			next_nic_matcher = tmp_nic_matcher;
 			break;
 		}
 		first = false;
 	}
 
-	prev_matcher = NULL;
-	if (next_matcher && !first)
-		prev_matcher = list_prev_entry(next_matcher, list_node);
+	prev_nic_matcher = NULL;
+	if (next_nic_matcher && !first)
+		prev_nic_matcher = list_prev_entry(next_nic_matcher, list_node);
 	else if (!first)
-		prev_matcher = list_last_entry(&tbl->matcher_list,
-					       struct mlx5dr_matcher,
-					       list_node);
-
-	if (dmn->type == MLX5DR_DOMAIN_TYPE_FDB ||
-	    dmn->type == MLX5DR_DOMAIN_TYPE_NIC_RX) {
-		ret = dr_matcher_connect(dmn, &matcher->rx,
-					 next_matcher ? &next_matcher->rx : NULL,
-					 prev_matcher ?	&prev_matcher->rx : NULL);
-		if (ret)
-			return ret;
-	}
+		prev_nic_matcher = list_last_entry(&nic_tbl->nic_matcher_list,
+						   struct mlx5dr_matcher_rx_tx,
+						   list_node);
 
-	if (dmn->type == MLX5DR_DOMAIN_TYPE_FDB ||
-	    dmn->type == MLX5DR_DOMAIN_TYPE_NIC_TX) {
-		ret = dr_matcher_connect(dmn, &matcher->tx,
-					 next_matcher ? &next_matcher->tx : NULL,
-					 prev_matcher ?	&prev_matcher->tx : NULL);
-		if (ret)
-			return ret;
-	}
+	ret = dr_nic_matcher_connect(dmn, nic_matcher,
+				     next_nic_matcher, prev_nic_matcher);
+	if (ret)
+		return ret;
 
-	if (prev_matcher)
-		list_add(&matcher->list_node, &prev_matcher->list_node);
-	else if (next_matcher)
-		list_add_tail(&matcher->list_node,
-			      &next_matcher->list_node);
+	if (prev_nic_matcher)
+		list_add(&nic_matcher->list_node, &prev_nic_matcher->list_node);
+	else if (next_nic_matcher)
+		list_add_tail(&nic_matcher->list_node, &next_nic_matcher->list_node);
 	else
-		list_add(&matcher->list_node, &tbl->matcher_list);
+		list_add(&nic_matcher->list_node, &nic_matcher->nic_tbl->nic_matcher_list);
 
-	return 0;
+	return ret;
 }
 
 static void dr_matcher_uninit_nic(struct mlx5dr_matcher_rx_tx *nic_matcher)
@@ -852,6 +844,9 @@ static int dr_matcher_init_nic(struct mlx5dr_matcher *matcher,
 	struct mlx5dr_domain *dmn = matcher->tbl->dmn;
 	int ret;
 
+	nic_matcher->prio = matcher->prio;
+	INIT_LIST_HEAD(&nic_matcher->list_node);
+
 	ret = dr_matcher_set_all_ste_builders(matcher, nic_matcher);
 	if (ret)
 		return ret;
@@ -979,6 +974,20 @@ static int dr_matcher_init(struct mlx5dr_matcher *matcher,
 	return ret;
 }
 
+static void dr_matcher_add_to_dbg_list(struct mlx5dr_matcher *matcher)
+{
+	mutex_lock(&matcher->tbl->dmn->dump_info.dbg_mutex);
+	list_add(&matcher->list_node, &matcher->tbl->matcher_list);
+	mutex_unlock(&matcher->tbl->dmn->dump_info.dbg_mutex);
+}
+
+static void dr_matcher_remove_from_dbg_list(struct mlx5dr_matcher *matcher)
+{
+	mutex_lock(&matcher->tbl->dmn->dump_info.dbg_mutex);
+	list_del(&matcher->list_node);
+	mutex_unlock(&matcher->tbl->dmn->dump_info.dbg_mutex);
+}
+
 struct mlx5dr_matcher *
 mlx5dr_matcher_create(struct mlx5dr_table *tbl,
 		      u32 priority,
@@ -1007,16 +1016,12 @@ mlx5dr_matcher_create(struct mlx5dr_table *tbl,
 	if (ret)
 		goto free_matcher;
 
-	ret = dr_matcher_add_to_tbl(matcher);
-	if (ret)
-		goto matcher_uninit;
+	dr_matcher_add_to_dbg_list(matcher);
 
 	mlx5dr_domain_unlock(tbl->dmn);
 
 	return matcher;
 
-matcher_uninit:
-	dr_matcher_uninit(matcher);
 free_matcher:
 	mlx5dr_domain_unlock(tbl->dmn);
 	kfree(matcher);
@@ -1025,10 +1030,10 @@ mlx5dr_matcher_create(struct mlx5dr_table *tbl,
 	return NULL;
 }
 
-static int dr_matcher_disconnect(struct mlx5dr_domain *dmn,
-				 struct mlx5dr_table_rx_tx *nic_tbl,
-				 struct mlx5dr_matcher_rx_tx *next_nic_matcher,
-				 struct mlx5dr_matcher_rx_tx *prev_nic_matcher)
+static int dr_matcher_disconnect_nic(struct mlx5dr_domain *dmn,
+				     struct mlx5dr_table_rx_tx *nic_tbl,
+				     struct mlx5dr_matcher_rx_tx *next_nic_matcher,
+				     struct mlx5dr_matcher_rx_tx *prev_nic_matcher)
 {
 	struct mlx5dr_domain_rx_tx *nic_dmn = nic_tbl->nic_dmn;
 	struct mlx5dr_htbl_connect_info info;
@@ -1055,43 +1060,34 @@ static int dr_matcher_disconnect(struct mlx5dr_domain *dmn,
 						 &info, true);
 }
 
-static int dr_matcher_remove_from_tbl(struct mlx5dr_matcher *matcher)
+int mlx5dr_matcher_remove_from_tbl_nic(struct mlx5dr_domain *dmn,
+				       struct mlx5dr_matcher_rx_tx *nic_matcher)
 {
-	struct mlx5dr_matcher *prev_matcher, *next_matcher;
-	struct mlx5dr_table *tbl = matcher->tbl;
-	struct mlx5dr_domain *dmn = tbl->dmn;
-	int ret = 0;
+	struct mlx5dr_matcher_rx_tx *prev_nic_matcher, *next_nic_matcher;
+	struct mlx5dr_table_rx_tx *nic_tbl = nic_matcher->nic_tbl;
+	int ret;
 
-	if (list_is_last(&matcher->list_node, &tbl->matcher_list))
-		next_matcher = NULL;
-	else
-		next_matcher = list_next_entry(matcher, list_node);
+	/* If the nic matcher is not on its parent nic table list,
+	 * then it is detached - no need to disconnect it.
+	 */
+	if (list_empty(&nic_matcher->list_node))
+		return 0;
 
-	if (matcher->list_node.prev == &tbl->matcher_list)
-		prev_matcher = NULL;
+	if (list_is_last(&nic_matcher->list_node, &nic_tbl->nic_matcher_list))
+		next_nic_matcher = NULL;
 	else
-		prev_matcher = list_prev_entry(matcher, list_node);
-
-	if (dmn->type == MLX5DR_DOMAIN_TYPE_FDB ||
-	    dmn->type == MLX5DR_DOMAIN_TYPE_NIC_RX) {
-		ret = dr_matcher_disconnect(dmn, &tbl->rx,
-					    next_matcher ? &next_matcher->rx : NULL,
-					    prev_matcher ? &prev_matcher->rx : NULL);
-		if (ret)
-			return ret;
-	}
+		next_nic_matcher = list_next_entry(nic_matcher, list_node);
 
-	if (dmn->type == MLX5DR_DOMAIN_TYPE_FDB ||
-	    dmn->type == MLX5DR_DOMAIN_TYPE_NIC_TX) {
-		ret = dr_matcher_disconnect(dmn, &tbl->tx,
-					    next_matcher ? &next_matcher->tx : NULL,
-					    prev_matcher ? &prev_matcher->tx : NULL);
-		if (ret)
-			return ret;
-	}
+	if (nic_matcher->list_node.prev == &nic_tbl->nic_matcher_list)
+		prev_nic_matcher = NULL;
+	else
+		prev_nic_matcher = list_prev_entry(nic_matcher, list_node);
 
-	list_del(&matcher->list_node);
+	ret = dr_matcher_disconnect_nic(dmn, nic_tbl, next_nic_matcher, prev_nic_matcher);
+	if (ret)
+		return ret;
 
+	list_del_init(&nic_matcher->list_node);
 	return 0;
 }
 
@@ -1104,7 +1100,7 @@ int mlx5dr_matcher_destroy(struct mlx5dr_matcher *matcher)
 
 	mlx5dr_domain_lock(tbl->dmn);
 
-	dr_matcher_remove_from_tbl(matcher);
+	dr_matcher_remove_from_dbg_list(matcher);
 	dr_matcher_uninit(matcher);
 	refcount_dec(&matcher->tbl->refcount);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index 43e7fe85cbc7..b4374578425b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -990,8 +990,20 @@ static bool dr_rule_verify(struct mlx5dr_matcher *matcher,
 static int dr_rule_destroy_rule_nic(struct mlx5dr_rule *rule,
 				    struct mlx5dr_rule_rx_tx *nic_rule)
 {
+	/* Check if this nic rule was actually created, or was it skipped
+	 * and only the other type of the RX/TX nic rule was created.
+	 */
+	if (!nic_rule->last_rule_ste)
+		return 0;
+
 	mlx5dr_domain_nic_lock(nic_rule->nic_matcher->nic_tbl->nic_dmn);
 	dr_rule_clean_rule_members(rule, nic_rule);
+
+	nic_rule->nic_matcher->rules--;
+	if (!nic_rule->nic_matcher->rules)
+		mlx5dr_matcher_remove_from_tbl_nic(rule->matcher->tbl->dmn,
+						   nic_rule->nic_matcher);
+
 	mlx5dr_domain_nic_unlock(nic_rule->nic_matcher->nic_tbl->nic_dmn);
 
 	return 0;
@@ -1098,24 +1110,28 @@ dr_rule_create_rule_nic(struct mlx5dr_rule *rule,
 
 	mlx5dr_domain_nic_lock(nic_dmn);
 
+	ret = mlx5dr_matcher_add_to_tbl_nic(dmn, nic_matcher);
+	if (ret)
+		goto free_hw_ste;
+
 	ret = mlx5dr_matcher_select_builders(matcher,
 					     nic_matcher,
 					     dr_rule_get_ipv(&param->outer),
 					     dr_rule_get_ipv(&param->inner));
 	if (ret)
-		goto free_hw_ste;
+		goto remove_from_nic_tbl;
 
 	/* Set the tag values inside the ste array */
 	ret = mlx5dr_ste_build_ste_arr(matcher, nic_matcher, param, hw_ste_arr);
 	if (ret)
-		goto free_hw_ste;
+		goto remove_from_nic_tbl;
 
 	/* Set the actions values/addresses inside the ste array */
 	ret = mlx5dr_actions_build_ste_arr(matcher, nic_matcher, actions,
 					   num_actions, hw_ste_arr,
 					   &new_hw_ste_arr_sz);
 	if (ret)
-		goto free_hw_ste;
+		goto remove_from_nic_tbl;
 
 	cur_htbl = nic_matcher->s_htbl;
 
@@ -1162,6 +1178,8 @@ dr_rule_create_rule_nic(struct mlx5dr_rule *rule,
 	if (htbl)
 		mlx5dr_htbl_put(htbl);
 
+	nic_matcher->rules++;
+
 	mlx5dr_domain_nic_unlock(nic_dmn);
 
 	kfree(hw_ste_arr);
@@ -1175,6 +1193,10 @@ dr_rule_create_rule_nic(struct mlx5dr_rule *rule,
 		list_del(&ste_info->send_list);
 		kfree(ste_info);
 	}
+
+remove_from_nic_tbl:
+	mlx5dr_matcher_remove_from_tbl_nic(dmn, nic_matcher);
+
 free_hw_ste:
 	mlx5dr_domain_nic_unlock(nic_dmn);
 	kfree(hw_ste_arr);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
index 1d6b43a52c58..8ca110643cc0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
@@ -3,69 +3,66 @@
 
 #include "dr_types.h"
 
-int mlx5dr_table_set_miss_action(struct mlx5dr_table *tbl,
-				 struct mlx5dr_action *action)
+static int dr_table_set_miss_action_nic(struct mlx5dr_domain *dmn,
+					struct mlx5dr_table_rx_tx *nic_tbl,
+					struct mlx5dr_action *action)
 {
-	struct mlx5dr_matcher *last_matcher = NULL;
+	struct mlx5dr_matcher_rx_tx *last_nic_matcher = NULL;
 	struct mlx5dr_htbl_connect_info info;
 	struct mlx5dr_ste_htbl *last_htbl;
 	int ret;
 
+	if (!list_empty(&nic_tbl->nic_matcher_list))
+		last_nic_matcher = list_last_entry(&nic_tbl->nic_matcher_list,
+						   struct mlx5dr_matcher_rx_tx,
+						   list_node);
+
+	if (last_nic_matcher)
+		last_htbl = last_nic_matcher->e_anchor;
+	else
+		last_htbl = nic_tbl->s_anchor;
+
+	if (action)
+		nic_tbl->default_icm_addr =
+			nic_tbl->nic_dmn->type == DR_DOMAIN_NIC_TYPE_RX ?
+				action->dest_tbl->tbl->rx.s_anchor->chunk->icm_addr :
+				action->dest_tbl->tbl->tx.s_anchor->chunk->icm_addr;
+	else
+		nic_tbl->default_icm_addr = nic_tbl->nic_dmn->default_icm_addr;
+
+	info.type = CONNECT_MISS;
+	info.miss_icm_addr = nic_tbl->default_icm_addr;
+
+	ret = mlx5dr_ste_htbl_init_and_postsend(dmn, nic_tbl->nic_dmn,
+						last_htbl, &info, true);
+	if (ret)
+		mlx5dr_dbg(dmn, "Failed to set NIC RX/TX miss action, ret %d\n", ret);
+
+	return ret;
+}
+
+int mlx5dr_table_set_miss_action(struct mlx5dr_table *tbl,
+				 struct mlx5dr_action *action)
+{
+	int ret;
+
 	if (action && action->action_type != DR_ACTION_TYP_FT)
 		return -EOPNOTSUPP;
 
 	mlx5dr_domain_lock(tbl->dmn);
 
-	if (!list_empty(&tbl->matcher_list))
-		last_matcher = list_last_entry(&tbl->matcher_list,
-					       struct mlx5dr_matcher,
-					       list_node);
-
 	if (tbl->dmn->type == MLX5DR_DOMAIN_TYPE_NIC_RX ||
 	    tbl->dmn->type == MLX5DR_DOMAIN_TYPE_FDB) {
-		if (last_matcher)
-			last_htbl = last_matcher->rx.e_anchor;
-		else
-			last_htbl = tbl->rx.s_anchor;
-
-		tbl->rx.default_icm_addr = action ?
-			action->dest_tbl->tbl->rx.s_anchor->chunk->icm_addr :
-			tbl->rx.nic_dmn->default_icm_addr;
-
-		info.type = CONNECT_MISS;
-		info.miss_icm_addr = tbl->rx.default_icm_addr;
-
-		ret = mlx5dr_ste_htbl_init_and_postsend(tbl->dmn,
-							tbl->rx.nic_dmn,
-							last_htbl,
-							&info, true);
-		if (ret) {
-			mlx5dr_dbg(tbl->dmn, "Failed to set RX miss action, ret %d\n", ret);
+		ret = dr_table_set_miss_action_nic(tbl->dmn, &tbl->rx, action);
+		if (ret)
 			goto out;
-		}
 	}
 
 	if (tbl->dmn->type == MLX5DR_DOMAIN_TYPE_NIC_TX ||
 	    tbl->dmn->type == MLX5DR_DOMAIN_TYPE_FDB) {
-		if (last_matcher)
-			last_htbl = last_matcher->tx.e_anchor;
-		else
-			last_htbl = tbl->tx.s_anchor;
-
-		tbl->tx.default_icm_addr = action ?
-			action->dest_tbl->tbl->tx.s_anchor->chunk->icm_addr :
-			tbl->tx.nic_dmn->default_icm_addr;
-
-		info.type = CONNECT_MISS;
-		info.miss_icm_addr = tbl->tx.default_icm_addr;
-
-		ret = mlx5dr_ste_htbl_init_and_postsend(tbl->dmn,
-							tbl->tx.nic_dmn,
-							last_htbl, &info, true);
-		if (ret) {
-			mlx5dr_dbg(tbl->dmn, "Failed to set TX miss action, ret %d\n", ret);
+		ret = dr_table_set_miss_action_nic(tbl->dmn, &tbl->tx, action);
+		if (ret)
 			goto out;
-		}
 	}
 
 	/* Release old action */
@@ -122,6 +119,8 @@ static int dr_table_init_nic(struct mlx5dr_domain *dmn,
 	struct mlx5dr_htbl_connect_info info;
 	int ret;
 
+	INIT_LIST_HEAD(&nic_tbl->nic_matcher_list);
+
 	nic_tbl->default_icm_addr = nic_dmn->default_icm_addr;
 
 	nic_tbl->s_anchor = mlx5dr_ste_htbl_alloc(dmn->ste_icm_pool,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 21a9b07ba327..1b3d484b99be 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -911,6 +911,7 @@ struct mlx5dr_table_rx_tx {
 	struct mlx5dr_ste_htbl *s_anchor;
 	struct mlx5dr_domain_rx_tx *nic_dmn;
 	u64 default_icm_addr;
+	struct list_head nic_matcher_list;
 };
 
 struct mlx5dr_table {
@@ -938,6 +939,9 @@ struct mlx5dr_matcher_rx_tx {
 	u8 num_of_builders_arr[DR_RULE_IPV_MAX][DR_RULE_IPV_MAX];
 	u64 default_icm_addr;
 	struct mlx5dr_table_rx_tx *nic_tbl;
+	u32 prio;
+	struct list_head list_node;
+	u32 rules;
 };
 
 struct mlx5dr_matcher {
@@ -1119,6 +1123,11 @@ static inline void mlx5dr_domain_unlock(struct mlx5dr_domain *dmn)
 	mlx5dr_domain_nic_unlock(&dmn->info.rx);
 }
 
+int mlx5dr_matcher_add_to_tbl_nic(struct mlx5dr_domain *dmn,
+				  struct mlx5dr_matcher_rx_tx *nic_matcher);
+int mlx5dr_matcher_remove_from_tbl_nic(struct mlx5dr_domain *dmn,
+				       struct mlx5dr_matcher_rx_tx *nic_matcher);
+
 int mlx5dr_matcher_select_builders(struct mlx5dr_matcher *matcher,
 				   struct mlx5dr_matcher_rx_tx *nic_matcher,
 				   enum mlx5dr_ipv outer_ipv,
-- 
2.33.1

