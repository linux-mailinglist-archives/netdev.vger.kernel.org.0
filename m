Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 975A060FAF2
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 16:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236059AbiJ0O6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 10:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235985AbiJ0O5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 10:57:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8468180274
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 07:57:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77D0CB8267E
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 14:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD510C433C1;
        Thu, 27 Oct 2022 14:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666882659;
        bh=opHNRgLg38F1Rm7QC6SYgx5Y4U6M177+HSLA+eknDYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FGNNB20GqWwRhMV9ZK8chb6h/ohp33cwO+mXic6XCrg4yC6x+bn3SeaUwqGJIC7hx
         5nNDS4i/CjC9EwEqOUScYIHvyqi6mTuRbdFGRHNDMKrDawjhgQtwp3wQ1/N3AsNz2t
         sOBbfK279jSgY1WrvQzaYEefdzfAvugnhLgw0rDFijlopCl5vatnmPhPNuzjGv84gp
         F2edpOM42Axk6rOfzj8t+uSNfdc6sCGKDaJhkFuMGuSN+3wLTB4C7zLv55wn1go+8J
         WDOIqaF54lJT2/ZtM/hkS8RuCXZSSWI+/qpFOI0fblFvyXPSJRIlIaH4UIapQe8gZF
         yUJ3hyIN3u8Yw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next V2 09/14] net/mlx5: DR, Manage STE send info objects in pool
Date:   Thu, 27 Oct 2022 15:56:38 +0100
Message-Id: <20221027145643.6618-10-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221027145643.6618-1-saeed@kernel.org>
References: <20221027145643.6618-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Instead of allocating/freeing send info objects dynamically, manage them
in pool. The number of send info objects doesn't depend on rules, so after
pre-populating the pool with an initial batch of send info objects, the
pool is not expected to grow.
This way we save alloc/free during writing STEs to ICM, which can
sometimes take up to 40msec.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_domain.c   |   9 ++
 .../mellanox/mlx5/core/steering/dr_rule.c     |  43 +++---
 .../mellanox/mlx5/core/steering/dr_send.c     | 131 ++++++++++++++++++
 .../mellanox/mlx5/core/steering/dr_types.h    |   9 ++
 4 files changed, 173 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
index 543d655ae3b6..3dc784b22741 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -73,8 +73,16 @@ static int dr_domain_init_mem_resources(struct mlx5dr_domain *dmn)
 		goto free_ste_icm_pool;
 	}
 
+	ret = mlx5dr_send_info_pool_create(dmn);
+	if (ret) {
+		mlx5dr_err(dmn, "Couldn't create send info pool\n");
+		goto free_action_icm_pool;
+	}
+
 	return 0;
 
+free_action_icm_pool:
+	mlx5dr_icm_pool_destroy(dmn->action_icm_pool);
 free_ste_icm_pool:
 	mlx5dr_icm_pool_destroy(dmn->ste_icm_pool);
 	return ret;
@@ -82,6 +90,7 @@ static int dr_domain_init_mem_resources(struct mlx5dr_domain *dmn)
 
 static void dr_domain_uninit_mem_resources(struct mlx5dr_domain *dmn)
 {
+	mlx5dr_send_info_pool_destroy(dmn);
 	mlx5dr_icm_pool_destroy(dmn->action_icm_pool);
 	mlx5dr_icm_pool_destroy(dmn->ste_icm_pool);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index 22878dcd7c8b..45542e5a5b3a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -6,11 +6,13 @@
 #define DR_RULE_MAX_STES_OPTIMIZED 5
 #define DR_RULE_MAX_STE_CHAIN_OPTIMIZED (DR_RULE_MAX_STES_OPTIMIZED + DR_ACTION_MAX_STES)
 
-static int dr_rule_append_to_miss_list(struct mlx5dr_ste_ctx *ste_ctx,
+static int dr_rule_append_to_miss_list(struct mlx5dr_domain *dmn,
+				       enum mlx5dr_domain_nic_type nic_type,
 				       struct mlx5dr_ste *new_last_ste,
 				       struct list_head *miss_list,
 				       struct list_head *send_list)
 {
+	struct mlx5dr_ste_ctx *ste_ctx = dmn->ste_ctx;
 	struct mlx5dr_ste_send_info *ste_info_last;
 	struct mlx5dr_ste *last_ste;
 
@@ -18,7 +20,7 @@ static int dr_rule_append_to_miss_list(struct mlx5dr_ste_ctx *ste_ctx,
 	last_ste = list_last_entry(miss_list, struct mlx5dr_ste, miss_list_node);
 	WARN_ON(!last_ste);
 
-	ste_info_last = kzalloc(sizeof(*ste_info_last), GFP_KERNEL);
+	ste_info_last = mlx5dr_send_info_alloc(dmn, nic_type);
 	if (!ste_info_last)
 		return -ENOMEM;
 
@@ -121,7 +123,7 @@ dr_rule_handle_one_ste_in_update_list(struct mlx5dr_ste_send_info *ste_info,
 		goto out;
 
 out:
-	kfree(ste_info);
+	mlx5dr_send_info_free(ste_info);
 	return ret;
 }
 
@@ -192,8 +194,8 @@ dr_rule_rehash_handle_collision(struct mlx5dr_matcher *matcher,
 	new_ste->htbl->chunk->miss_list = mlx5dr_ste_get_miss_list(col_ste);
 
 	/* Update the previous from the list */
-	ret = dr_rule_append_to_miss_list(dmn->ste_ctx, new_ste,
-					  mlx5dr_ste_get_miss_list(col_ste),
+	ret = dr_rule_append_to_miss_list(dmn, nic_matcher->nic_tbl->nic_dmn->type,
+					  new_ste, mlx5dr_ste_get_miss_list(col_ste),
 					  update_list);
 	if (ret) {
 		mlx5dr_dbg(dmn, "Failed update dup entry\n");
@@ -279,7 +281,8 @@ dr_rule_rehash_copy_ste(struct mlx5dr_matcher *matcher,
 	new_htbl->ctrl.num_of_valid_entries++;
 
 	if (use_update_list) {
-		ste_info = kzalloc(sizeof(*ste_info), GFP_KERNEL);
+		ste_info = mlx5dr_send_info_alloc(dmn,
+						  nic_matcher->nic_tbl->nic_dmn->type);
 		if (!ste_info)
 			goto err_exit;
 
@@ -397,7 +400,8 @@ dr_rule_rehash_htbl(struct mlx5dr_rule *rule,
 	nic_matcher = nic_rule->nic_matcher;
 	nic_dmn = nic_matcher->nic_tbl->nic_dmn;
 
-	ste_info = kzalloc(sizeof(*ste_info), GFP_KERNEL);
+	ste_info = mlx5dr_send_info_alloc(dmn,
+					  nic_matcher->nic_tbl->nic_dmn->type);
 	if (!ste_info)
 		return NULL;
 
@@ -483,13 +487,13 @@ dr_rule_rehash_htbl(struct mlx5dr_rule *rule,
 	list_for_each_entry_safe(del_ste_info, tmp_ste_info,
 				 &rehash_table_send_list, send_list) {
 		list_del(&del_ste_info->send_list);
-		kfree(del_ste_info);
+		mlx5dr_send_info_free(del_ste_info);
 	}
 
 free_new_htbl:
 	mlx5dr_ste_htbl_free(new_htbl);
 free_ste_info:
-	kfree(ste_info);
+	mlx5dr_send_info_free(ste_info);
 	mlx5dr_info(dmn, "Failed creating rehash table\n");
 	return NULL;
 }
@@ -522,11 +526,11 @@ dr_rule_handle_collision(struct mlx5dr_matcher *matcher,
 			 struct list_head *send_list)
 {
 	struct mlx5dr_domain *dmn = matcher->tbl->dmn;
-	struct mlx5dr_ste_ctx *ste_ctx = dmn->ste_ctx;
 	struct mlx5dr_ste_send_info *ste_info;
 	struct mlx5dr_ste *new_ste;
 
-	ste_info = kzalloc(sizeof(*ste_info), GFP_KERNEL);
+	ste_info = mlx5dr_send_info_alloc(dmn,
+					  nic_matcher->nic_tbl->nic_dmn->type);
 	if (!ste_info)
 		return NULL;
 
@@ -534,8 +538,8 @@ dr_rule_handle_collision(struct mlx5dr_matcher *matcher,
 	if (!new_ste)
 		goto free_send_info;
 
-	if (dr_rule_append_to_miss_list(ste_ctx, new_ste,
-					miss_list, send_list)) {
+	if (dr_rule_append_to_miss_list(dmn, nic_matcher->nic_tbl->nic_dmn->type,
+					new_ste, miss_list, send_list)) {
 		mlx5dr_dbg(dmn, "Failed to update prev miss_list\n");
 		goto err_exit;
 	}
@@ -551,7 +555,7 @@ dr_rule_handle_collision(struct mlx5dr_matcher *matcher,
 err_exit:
 	mlx5dr_ste_free(new_ste, matcher, nic_matcher);
 free_send_info:
-	kfree(ste_info);
+	mlx5dr_send_info_free(ste_info);
 	return NULL;
 }
 
@@ -731,8 +735,8 @@ static int dr_rule_handle_action_stes(struct mlx5dr_rule *rule,
 		list_add_tail(&action_ste->miss_list_node,
 			      mlx5dr_ste_get_miss_list(action_ste));
 
-		ste_info_arr[k] = kzalloc(sizeof(*ste_info_arr[k]),
-					  GFP_KERNEL);
+		ste_info_arr[k] = mlx5dr_send_info_alloc(dmn,
+							 nic_matcher->nic_tbl->nic_dmn->type);
 		if (!ste_info_arr[k])
 			goto err_exit;
 
@@ -782,7 +786,8 @@ static int dr_rule_handle_empty_entry(struct mlx5dr_matcher *matcher,
 
 	ste->ste_chain_location = ste_location;
 
-	ste_info = kzalloc(sizeof(*ste_info), GFP_KERNEL);
+	ste_info = mlx5dr_send_info_alloc(dmn,
+					  nic_matcher->nic_tbl->nic_dmn->type);
 	if (!ste_info)
 		goto clean_ste_setting;
 
@@ -803,7 +808,7 @@ static int dr_rule_handle_empty_entry(struct mlx5dr_matcher *matcher,
 	return 0;
 
 clean_ste_info:
-	kfree(ste_info);
+	mlx5dr_send_info_free(ste_info);
 clean_ste_setting:
 	list_del_init(&ste->miss_list_node);
 	mlx5dr_htbl_put(cur_htbl);
@@ -1216,7 +1221,7 @@ dr_rule_create_rule_nic(struct mlx5dr_rule *rule,
 	/* Clean all ste_info's */
 	list_for_each_entry_safe(ste_info, tmp_ste_info, &send_ste_list, send_list) {
 		list_del(&ste_info->send_list);
-		kfree(ste_info);
+		mlx5dr_send_info_free(ste_info);
 	}
 
 remove_from_nic_tbl:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index 6ad026123b16..a4476cb4c3b3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -7,6 +7,7 @@
 #define QUEUE_SIZE 128
 #define SIGNAL_PER_DIV_QUEUE 16
 #define TH_NUMS_TO_DRAIN 2
+#define DR_SEND_INFO_POOL_SIZE 1000
 
 enum { CQ_OK = 0, CQ_EMPTY = -1, CQ_POLL_ERR = -2 };
 
@@ -49,6 +50,136 @@ struct dr_qp_init_attr {
 	u8 isolate_vl_tc:1;
 };
 
+struct mlx5dr_send_info_pool_obj {
+	struct mlx5dr_ste_send_info ste_send_info;
+	struct mlx5dr_send_info_pool *pool;
+	struct list_head list_node;
+};
+
+struct mlx5dr_send_info_pool {
+	struct list_head free_list;
+};
+
+static int dr_send_info_pool_fill(struct mlx5dr_send_info_pool *pool)
+{
+	struct mlx5dr_send_info_pool_obj *pool_obj, *tmp_pool_obj;
+	int i;
+
+	for (i = 0; i < DR_SEND_INFO_POOL_SIZE; i++) {
+		pool_obj = kzalloc(sizeof(*pool_obj), GFP_KERNEL);
+		if (!pool_obj)
+			goto clean_pool;
+
+		pool_obj->pool = pool;
+		list_add_tail(&pool_obj->list_node, &pool->free_list);
+	}
+
+	return 0;
+
+clean_pool:
+	list_for_each_entry_safe(pool_obj, tmp_pool_obj, &pool->free_list, list_node) {
+		list_del(&pool_obj->list_node);
+		kfree(pool_obj);
+	}
+
+	return -ENOMEM;
+}
+
+static void dr_send_info_pool_destroy(struct mlx5dr_send_info_pool *pool)
+{
+	struct mlx5dr_send_info_pool_obj *pool_obj, *tmp_pool_obj;
+
+	list_for_each_entry_safe(pool_obj, tmp_pool_obj, &pool->free_list, list_node) {
+		list_del(&pool_obj->list_node);
+		kfree(pool_obj);
+	}
+
+	kfree(pool);
+}
+
+void mlx5dr_send_info_pool_destroy(struct mlx5dr_domain *dmn)
+{
+	dr_send_info_pool_destroy(dmn->send_info_pool_tx);
+	dr_send_info_pool_destroy(dmn->send_info_pool_rx);
+}
+
+static struct mlx5dr_send_info_pool *dr_send_info_pool_create(void)
+{
+	struct mlx5dr_send_info_pool *pool;
+	int ret;
+
+	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
+	if (!pool)
+		return NULL;
+
+	INIT_LIST_HEAD(&pool->free_list);
+
+	ret = dr_send_info_pool_fill(pool);
+	if (ret) {
+		kfree(pool);
+		return NULL;
+	}
+
+	return pool;
+}
+
+int mlx5dr_send_info_pool_create(struct mlx5dr_domain *dmn)
+{
+	dmn->send_info_pool_rx = dr_send_info_pool_create();
+	if (!dmn->send_info_pool_rx)
+		return -ENOMEM;
+
+	dmn->send_info_pool_tx = dr_send_info_pool_create();
+	if (!dmn->send_info_pool_tx) {
+		dr_send_info_pool_destroy(dmn->send_info_pool_rx);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+struct mlx5dr_ste_send_info
+*mlx5dr_send_info_alloc(struct mlx5dr_domain *dmn,
+			enum mlx5dr_domain_nic_type nic_type)
+{
+	struct mlx5dr_send_info_pool_obj *pool_obj;
+	struct mlx5dr_send_info_pool *pool;
+	int ret;
+
+	pool = nic_type == DR_DOMAIN_NIC_TYPE_RX ? dmn->send_info_pool_rx :
+						   dmn->send_info_pool_tx;
+
+	if (unlikely(list_empty(&pool->free_list))) {
+		ret = dr_send_info_pool_fill(pool);
+		if (ret)
+			return NULL;
+	}
+
+	pool_obj = list_first_entry_or_null(&pool->free_list,
+					    struct mlx5dr_send_info_pool_obj,
+					    list_node);
+
+	if (likely(pool_obj)) {
+		list_del_init(&pool_obj->list_node);
+	} else {
+		WARN_ONCE(!pool_obj, "Failed getting ste send info obj from pool");
+		return NULL;
+	}
+
+	return &pool_obj->ste_send_info;
+}
+
+void mlx5dr_send_info_free(struct mlx5dr_ste_send_info *ste_send_info)
+{
+	struct mlx5dr_send_info_pool_obj *pool_obj;
+
+	pool_obj = container_of(ste_send_info,
+				struct mlx5dr_send_info_pool_obj,
+				ste_send_info);
+
+	list_add(&pool_obj->list_node, &pool_obj->pool->free_list);
+}
+
 static int dr_parse_cqe(struct mlx5dr_cq *dr_cq, struct mlx5_cqe64 *cqe64)
 {
 	unsigned int idx;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 1777a1e508e7..244685453a27 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -146,6 +146,7 @@ struct mlx5dr_cmd_caps;
 struct mlx5dr_rule_rx_tx;
 struct mlx5dr_matcher_rx_tx;
 struct mlx5dr_ste_ctx;
+struct mlx5dr_send_info_pool;
 
 struct mlx5dr_ste {
 	/* refcount: indicates the num of rules that using this ste */
@@ -912,6 +913,8 @@ struct mlx5dr_domain {
 	refcount_t refcount;
 	struct mlx5dr_icm_pool *ste_icm_pool;
 	struct mlx5dr_icm_pool *action_icm_pool;
+	struct mlx5dr_send_info_pool *send_info_pool_rx;
+	struct mlx5dr_send_info_pool *send_info_pool_tx;
 	struct mlx5dr_send_ring *send_ring;
 	struct mlx5dr_domain_info info;
 	struct xarray csum_fts_xa;
@@ -1404,6 +1407,12 @@ int mlx5dr_send_postsend_formatted_htbl(struct mlx5dr_domain *dmn,
 int mlx5dr_send_postsend_action(struct mlx5dr_domain *dmn,
 				struct mlx5dr_action *action);
 
+int mlx5dr_send_info_pool_create(struct mlx5dr_domain *dmn);
+void mlx5dr_send_info_pool_destroy(struct mlx5dr_domain *dmn);
+struct mlx5dr_ste_send_info *mlx5dr_send_info_alloc(struct mlx5dr_domain *dmn,
+						    enum mlx5dr_domain_nic_type nic_type);
+void mlx5dr_send_info_free(struct mlx5dr_ste_send_info *ste_send_info);
+
 struct mlx5dr_cmd_ft_info {
 	u32 id;
 	u16 vport;
-- 
2.37.3

