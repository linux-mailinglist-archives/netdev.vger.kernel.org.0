Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B02B68229F
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 04:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjAaDND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 22:13:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjAaDMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 22:12:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB2138EB6
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 19:12:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DC79613B3
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 03:12:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B086BC433D2;
        Tue, 31 Jan 2023 03:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675134739;
        bh=U9BfyeynA5LLQVS0bb5vTTmiGHAAWDHDvVTQ/IpcSdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RGBsu5/ZCxR5nteTodO9v7n1jK3MQPS18g/FZzsYOqHQhJ2n43r/eESwHquJsiJex
         Z9hiVCBHWZtQCQN4y+okRwVDp9J4/c6MqqA6l/1sU71ZMOGqoGxXsTH/CZmCbIZEAV
         7ZRxx/mwfspZdA+oUSD3Wqt+LdsFra7pf4qjF5R19DKlCuVOavKhOHT8Z5Br7Lnflp
         /hd4mkg37ZCHuDTLpjK6pQnbloUSRHoW1j2xtNk20Oo5u0GOedNAyNdbCHhYo49tNj
         YG+/O56RV++falF80S9/tBeOBkuFm13XBeMH/u50441Tt+LqbQco11pVJYmM7mcxHl
         YRVbsXew1+OeQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>
Subject: [net-next 13/15] net/mlx5: Add async garbage collector for DEK bulk
Date:   Mon, 30 Jan 2023 19:11:59 -0800
Message-Id: <20230131031201.35336-14-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230131031201.35336-1-saeed@kernel.org>
References: <20230131031201.35336-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianbo Liu <jianbol@nvidia.com>

After invalidation, the idle bulk with all DEKs available for use, is
destroyed, to free keys and mem.

To get better performance, the firmware destruction operation is done
asynchronously. So idle bulks are enqueued in destroy_list first, then
destroyed in system workqueue. This will improve performance, as the
destruction doesn't need to hold pool's mutex.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/lib/crypto.c  | 74 ++++++++++++++++---
 1 file changed, 65 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
index 8f8c18f80601..e078530ef37d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
@@ -46,6 +46,10 @@ struct mlx5_crypto_dek_pool {
 	bool syncing;
 	struct list_head wait_for_free;
 	struct work_struct sync_work;
+
+	spinlock_t destroy_lock; /* protect destroy_list */
+	struct list_head destroy_list;
+	struct work_struct destroy_work;
 };
 
 struct mlx5_crypto_dek_bulk {
@@ -351,13 +355,15 @@ static void mlx5_crypto_dek_bulk_free(struct mlx5_crypto_dek_bulk *bulk)
 }
 
 static void mlx5_crypto_dek_pool_remove_bulk(struct mlx5_crypto_dek_pool *pool,
-					     struct mlx5_crypto_dek_bulk *bulk)
+					     struct mlx5_crypto_dek_bulk *bulk,
+					     bool delay)
 {
 	pool->num_deks -= bulk->num_deks;
 	pool->avail_deks -= bulk->avail_deks;
 	pool->in_use_deks -= bulk->in_use_deks;
 	list_del(&bulk->entry);
-	mlx5_crypto_dek_bulk_free(bulk);
+	if (!delay)
+		mlx5_crypto_dek_bulk_free(bulk);
 }
 
 static struct mlx5_crypto_dek_bulk *
@@ -500,6 +506,23 @@ static void mlx5_crypto_dek_bulk_reset_synced(struct mlx5_crypto_dek_pool *pool,
 	}
 }
 
+static void mlx5_crypto_dek_bulk_handle_avail(struct mlx5_crypto_dek_pool *pool,
+					      struct mlx5_crypto_dek_bulk *bulk,
+					      struct list_head *destroy_list)
+{
+	mlx5_crypto_dek_pool_remove_bulk(pool, bulk, true);
+	list_add(&bulk->entry, destroy_list);
+}
+
+static void mlx5_crypto_dek_pool_splice_destroy_list(struct mlx5_crypto_dek_pool *pool,
+						     struct list_head *list,
+						     struct list_head *head)
+{
+	spin_lock(&pool->destroy_lock);
+	list_splice_init(list, head);
+	spin_unlock(&pool->destroy_lock);
+}
+
 static void mlx5_crypto_dek_pool_free_wait_keys(struct mlx5_crypto_dek_pool *pool)
 {
 	struct mlx5_crypto_dek *dek, *next;
@@ -512,16 +535,18 @@ static void mlx5_crypto_dek_pool_free_wait_keys(struct mlx5_crypto_dek_pool *poo
 
 /* For all the bulks in each list, reset the bits while sync.
  * Move them to different lists according to the number of available DEKs.
+ * Destrory all the idle bulks for now.
  * And free DEKs in the waiting list at the end of this func.
  */
 static void mlx5_crypto_dek_pool_reset_synced(struct mlx5_crypto_dek_pool *pool)
 {
 	struct mlx5_crypto_dek_bulk *bulk, *tmp;
+	LIST_HEAD(destroy_list);
 
 	list_for_each_entry_safe(bulk, tmp, &pool->partial_list, entry) {
 		mlx5_crypto_dek_bulk_reset_synced(pool, bulk);
 		if (MLX5_CRYPTO_DEK_BULK_IDLE(bulk))
-			list_move(&bulk->entry, &pool->avail_list);
+			mlx5_crypto_dek_bulk_handle_avail(pool, bulk, &destroy_list);
 	}
 
 	list_for_each_entry_safe(bulk, tmp, &pool->full_list, entry) {
@@ -531,7 +556,7 @@ static void mlx5_crypto_dek_pool_reset_synced(struct mlx5_crypto_dek_pool *pool)
 			continue;
 
 		if (MLX5_CRYPTO_DEK_BULK_IDLE(bulk))
-			list_move(&bulk->entry, &pool->avail_list);
+			mlx5_crypto_dek_bulk_handle_avail(pool, bulk, &destroy_list);
 		else
 			list_move(&bulk->entry, &pool->partial_list);
 	}
@@ -541,10 +566,16 @@ static void mlx5_crypto_dek_pool_reset_synced(struct mlx5_crypto_dek_pool *pool)
 		bulk->avail_start = 0;
 		bulk->avail_deks = bulk->num_deks;
 		pool->avail_deks += bulk->num_deks;
+		mlx5_crypto_dek_bulk_handle_avail(pool, bulk, &destroy_list);
 	}
-	list_splice_init(&pool->sync_list, &pool->avail_list);
 
 	mlx5_crypto_dek_pool_free_wait_keys(pool);
+
+	if (!list_empty(&destroy_list)) {
+		mlx5_crypto_dek_pool_splice_destroy_list(pool, &destroy_list,
+							 &pool->destroy_list);
+		schedule_work(&pool->destroy_work);
+	}
 }
 
 static void mlx5_crypto_dek_sync_work_fn(struct work_struct *work)
@@ -620,6 +651,25 @@ void mlx5_crypto_dek_destroy(struct mlx5_crypto_dek_pool *dek_pool,
 	}
 }
 
+static void mlx5_crypto_dek_free_destroy_list(struct list_head *destroy_list)
+{
+	struct mlx5_crypto_dek_bulk *bulk, *tmp;
+
+	list_for_each_entry_safe(bulk, tmp, destroy_list, entry)
+		mlx5_crypto_dek_bulk_free(bulk);
+}
+
+static void mlx5_crypto_dek_destroy_work_fn(struct work_struct *work)
+{
+	struct mlx5_crypto_dek_pool *pool =
+		container_of(work, struct mlx5_crypto_dek_pool, destroy_work);
+	LIST_HEAD(destroy_list);
+
+	mlx5_crypto_dek_pool_splice_destroy_list(pool, &pool->destroy_list,
+						 &destroy_list);
+	mlx5_crypto_dek_free_destroy_list(&destroy_list);
+}
+
 struct mlx5_crypto_dek_pool *
 mlx5_crypto_dek_pool_create(struct mlx5_core_dev *mdev, int key_purpose)
 {
@@ -639,6 +689,9 @@ mlx5_crypto_dek_pool_create(struct mlx5_core_dev *mdev, int key_purpose)
 	INIT_LIST_HEAD(&pool->sync_list);
 	INIT_LIST_HEAD(&pool->wait_for_free);
 	INIT_WORK(&pool->sync_work, mlx5_crypto_dek_sync_work_fn);
+	spin_lock_init(&pool->destroy_lock);
+	INIT_LIST_HEAD(&pool->destroy_list);
+	INIT_WORK(&pool->destroy_work, mlx5_crypto_dek_destroy_work_fn);
 
 	return pool;
 }
@@ -648,20 +701,23 @@ void mlx5_crypto_dek_pool_destroy(struct mlx5_crypto_dek_pool *pool)
 	struct mlx5_crypto_dek_bulk *bulk, *tmp;
 
 	cancel_work_sync(&pool->sync_work);
+	cancel_work_sync(&pool->destroy_work);
 
 	mlx5_crypto_dek_pool_free_wait_keys(pool);
 
 	list_for_each_entry_safe(bulk, tmp, &pool->avail_list, entry)
-		mlx5_crypto_dek_pool_remove_bulk(pool, bulk);
+		mlx5_crypto_dek_pool_remove_bulk(pool, bulk, false);
 
 	list_for_each_entry_safe(bulk, tmp, &pool->full_list, entry)
-		mlx5_crypto_dek_pool_remove_bulk(pool, bulk);
+		mlx5_crypto_dek_pool_remove_bulk(pool, bulk, false);
 
 	list_for_each_entry_safe(bulk, tmp, &pool->sync_list, entry)
-		mlx5_crypto_dek_pool_remove_bulk(pool, bulk);
+		mlx5_crypto_dek_pool_remove_bulk(pool, bulk, false);
 
 	list_for_each_entry_safe(bulk, tmp, &pool->partial_list, entry)
-		mlx5_crypto_dek_pool_remove_bulk(pool, bulk);
+		mlx5_crypto_dek_pool_remove_bulk(pool, bulk, false);
+
+	mlx5_crypto_dek_free_destroy_list(&pool->destroy_list);
 
 	mutex_destroy(&pool->lock);
 
-- 
2.39.1

