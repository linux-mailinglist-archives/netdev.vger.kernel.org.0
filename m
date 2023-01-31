Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A27336822A4
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 04:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbjAaDNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 22:13:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbjAaDMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 22:12:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4E63802E
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 19:12:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D52CB81923
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 03:12:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9394C4339C;
        Tue, 31 Jan 2023 03:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675134738;
        bh=XN7XTxptcZxume6qqnRMJGar7yzYM4sjuuZb783rZ88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QhFsQ1WboEkHZ9P4Yg+VN4uNFXjkBFF6zGQxg1bGSAVu7S00DN02HgQma81ALvcz+
         jdFjuxKVLzJttH9KbSGkiVfqUSfcbT6ScS/iE/nwuAqA4jeInV9OKowQsnlDFExllR
         a6h3az7h33yMaNdr93pHowItVoDM6ePaaozIBgvl08vIMfAch2njY/DRsXmit77mA5
         urCyBP6vJ/0ooYSEi4mqpUSMKJg4RLacfss+xgNIBuDpW6colNulmdoCjSJBTces7S
         nNok13crQb1L2b3MbZDsjc9ANhvfSY7Felp23f4Mesd+TH2GQ/V2epUHGST0C4I4ve
         6UHEjkD1YXdag==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>
Subject: [net-next 12/15] net/mlx5: Reuse DEKs after executing SYNC_CRYPTO command
Date:   Mon, 30 Jan 2023 19:11:58 -0800
Message-Id: <20230131031201.35336-13-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230131031201.35336-1-saeed@kernel.org>
References: <20230131031201.35336-1-saeed@kernel.org>
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

From: Jianbo Liu <jianbol@nvidia.com>

To fast update encryption keys, those freed keys with need_sync bit 1
and in_use bit 0 in a bulk, can be recycled. The keys are cached
internally by the NIC, so invalidating internal NIC caches by
SYNC_CRYPTO command is required before reusing them. A threshold in
driver is added to avoid invalidating for every update. Only when the
number of DEKs, which need to be synced, is over this threshold, the
sync process will start. Besides, it is done in system workqueue.

After SYNC_CRYPTO command is executed successfully, the bitmaps of
each bulk must be reset accordingly, so that the freed DEKs can be
reused. From the analysis in previous patch, the number of reused DEKs
can be calculated by hweight_long(need_sync XOR in_use), and the
need_sync bits can be reset by simply copying from in_use bits.

Two more list (avail_list and sync_list) are added for each pool. The
avail_list is for a bulk when all bits in need_sync are reset after
sync. If there is no avail deks, and all are be freed by users, the
bulk is moved to sync_list, instead of being destroyed in previous
patch, and waiting for the invalidation. While syncing, they are
simply reset need_sync bits, and moved to avail_list.

Besides, add a wait_for_free list for the to-be-free DEKs. It is to
avoid this corner case: when thread A is done with SYNC_CRYPTO but just
before starting to reset the bitmaps, thread B is alloc dek, and free
it immediately. It's obvious that this DEK can't be reused this time,
so put it to waiting list, and do free after bulk bitmaps reset is
finished.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/lib/crypto.c  | 192 +++++++++++++++++-
 1 file changed, 183 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
index 5c92ac5d95ee..8f8c18f80601 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
@@ -7,6 +7,22 @@
 #define MLX5_CRYPTO_DEK_POOLS_NUM (MLX5_ACCEL_OBJ_TYPE_KEY_NUM - 1)
 #define type2idx(type) ((type) - 1)
 
+#define MLX5_CRYPTO_DEK_POOL_SYNC_THRESH 128
+
+/* calculate the num of DEKs, which are freed by any user
+ * (for example, TLS) after last revalidation in a pool or a bulk.
+ */
+#define MLX5_CRYPTO_DEK_CALC_FREED(a) \
+	({ typeof(a) _a = (a); \
+	   _a->num_deks - _a->avail_deks - _a->in_use_deks; })
+
+#define MLX5_CRYPTO_DEK_POOL_CALC_FREED(pool) MLX5_CRYPTO_DEK_CALC_FREED(pool)
+#define MLX5_CRYPTO_DEK_BULK_CALC_FREED(bulk) MLX5_CRYPTO_DEK_CALC_FREED(bulk)
+
+#define MLX5_CRYPTO_DEK_BULK_IDLE(bulk) \
+	({ typeof(bulk) _bulk = (bulk); \
+	   _bulk->avail_deks == _bulk->num_deks; })
+
 enum {
 	MLX5_CRYPTO_DEK_ALL_TYPE = BIT(0),
 };
@@ -20,6 +36,16 @@ struct mlx5_crypto_dek_pool {
 	struct mutex lock; /* protect the following lists, and the bulks */
 	struct list_head partial_list; /* some of keys are available */
 	struct list_head full_list; /* no available keys */
+	struct list_head avail_list; /* all keys are available to use */
+
+	/* No in-used keys, and all need to be synced.
+	 * These bulks will be put to avail list after sync.
+	 */
+	struct list_head sync_list;
+
+	bool syncing;
+	struct list_head wait_for_free;
+	struct work_struct sync_work;
 };
 
 struct mlx5_crypto_dek_bulk {
@@ -34,7 +60,10 @@ struct mlx5_crypto_dek_bulk {
 	/* 0: not being used by any user, 1: otherwise */
 	unsigned long *in_use;
 
-	/* The bits are set when they are used, and initialized to 0 */
+	/* The bits are set when they are used, and reset after crypto_sync
+	 * is executed. So, the value 0 means the key is newly created, or not
+	 * used after sync, and 1 means it is in use, or freed but not synced
+	 */
 	unsigned long *need_sync;
 };
 
@@ -45,6 +74,7 @@ struct mlx5_crypto_dek_priv {
 
 struct mlx5_crypto_dek {
 	struct mlx5_crypto_dek_bulk *bulk;
+	struct list_head entry;
 	u32 obj_id;
 };
 
@@ -349,9 +379,16 @@ mlx5_crypto_dek_pool_pop(struct mlx5_crypto_dek_pool *pool, u32 *obj_offset)
 		}
 		WARN_ON(pos == bulk->num_deks);
 	} else {
-		bulk = mlx5_crypto_dek_pool_add_bulk(pool);
-		if (IS_ERR(bulk))
-			goto out;
+		bulk = list_first_entry_or_null(&pool->avail_list,
+						struct mlx5_crypto_dek_bulk,
+						entry);
+		if (bulk) {
+			list_move(&bulk->entry, &pool->partial_list);
+		} else {
+			bulk = mlx5_crypto_dek_pool_add_bulk(pool);
+			if (IS_ERR(bulk))
+				goto out;
+		}
 		pos = 0;
 	}
 
@@ -374,15 +411,20 @@ mlx5_crypto_dek_pool_pop(struct mlx5_crypto_dek_pool *pool, u32 *obj_offset)
 	return bulk;
 }
 
-static int mlx5_crypto_dek_pool_push(struct mlx5_crypto_dek_pool *pool,
-				     struct mlx5_crypto_dek *dek)
+static bool mlx5_crypto_dek_need_sync(struct mlx5_crypto_dek_pool *pool)
+{
+	return !pool->syncing &&
+	       MLX5_CRYPTO_DEK_POOL_CALC_FREED(pool) > MLX5_CRYPTO_DEK_POOL_SYNC_THRESH;
+}
+
+static int mlx5_crypto_dek_free_locked(struct mlx5_crypto_dek_pool *pool,
+				       struct mlx5_crypto_dek *dek)
 {
 	struct mlx5_crypto_dek_bulk *bulk = dek->bulk;
 	int obj_offset;
 	bool old_val;
 	int err = 0;
 
-	mutex_lock(&pool->lock);
 	obj_offset = dek->obj_id - bulk->base_obj_id;
 	old_val = test_and_clear_bit(obj_offset, bulk->in_use);
 	WARN_ON_ONCE(!old_val);
@@ -393,14 +435,132 @@ static int mlx5_crypto_dek_pool_push(struct mlx5_crypto_dek_pool *pool,
 	pool->in_use_deks--;
 	bulk->in_use_deks--;
 	if (!bulk->avail_deks && !bulk->in_use_deks)
-		mlx5_crypto_dek_pool_remove_bulk(pool, bulk);
+		list_move(&bulk->entry, &pool->sync_list);
+
+	if (mlx5_crypto_dek_need_sync(pool) && schedule_work(&pool->sync_work))
+		pool->syncing = true;
 
 out_free:
-	mutex_unlock(&pool->lock);
 	kfree(dek);
 	return err;
 }
 
+static int mlx5_crypto_dek_pool_push(struct mlx5_crypto_dek_pool *pool,
+				     struct mlx5_crypto_dek *dek)
+{
+	int err = 0;
+
+	mutex_lock(&pool->lock);
+	if (pool->syncing)
+		list_add(&dek->entry, &pool->wait_for_free);
+	else
+		err = mlx5_crypto_dek_free_locked(pool, dek);
+	mutex_unlock(&pool->lock);
+
+	return err;
+}
+
+/* Update the bits for a bulk while sync, and avail_next for search.
+ * As the combinations of (need_sync, in_use) of one DEK are
+ *    - (0,0) means the key is ready for use,
+ *    - (1,1) means the key is currently being used by a user,
+ *    - (1,0) means the key is freed, and waiting for being synced,
+ *    - (0,1) is invalid state.
+ * the number of revalidated DEKs can be calculated by
+ * hweight_long(need_sync XOR in_use), and the need_sync bits can be reset
+ * by simply copying from in_use bits.
+ */
+static void mlx5_crypto_dek_bulk_reset_synced(struct mlx5_crypto_dek_pool *pool,
+					      struct mlx5_crypto_dek_bulk *bulk)
+{
+	unsigned long *need_sync = bulk->need_sync;
+	unsigned long *in_use = bulk->in_use;
+	int i, freed, reused, avail_next;
+	bool first = true;
+
+	freed = MLX5_CRYPTO_DEK_BULK_CALC_FREED(bulk);
+
+	for (i = 0; freed && i < BITS_TO_LONGS(bulk->num_deks);
+			i++, need_sync++, in_use++) {
+		reused = hweight_long((*need_sync) ^ (*in_use));
+		if (!reused)
+			continue;
+
+		bulk->avail_deks += reused;
+		pool->avail_deks += reused;
+		*need_sync = *in_use;
+		if (first) {
+			avail_next = i * BITS_PER_TYPE(long);
+			if (bulk->avail_start > avail_next)
+				bulk->avail_start = avail_next;
+			first = false;
+		}
+
+		freed -= reused;
+	}
+}
+
+static void mlx5_crypto_dek_pool_free_wait_keys(struct mlx5_crypto_dek_pool *pool)
+{
+	struct mlx5_crypto_dek *dek, *next;
+
+	list_for_each_entry_safe(dek, next, &pool->wait_for_free, entry) {
+		list_del(&dek->entry);
+		mlx5_crypto_dek_free_locked(pool, dek);
+	}
+}
+
+/* For all the bulks in each list, reset the bits while sync.
+ * Move them to different lists according to the number of available DEKs.
+ * And free DEKs in the waiting list at the end of this func.
+ */
+static void mlx5_crypto_dek_pool_reset_synced(struct mlx5_crypto_dek_pool *pool)
+{
+	struct mlx5_crypto_dek_bulk *bulk, *tmp;
+
+	list_for_each_entry_safe(bulk, tmp, &pool->partial_list, entry) {
+		mlx5_crypto_dek_bulk_reset_synced(pool, bulk);
+		if (MLX5_CRYPTO_DEK_BULK_IDLE(bulk))
+			list_move(&bulk->entry, &pool->avail_list);
+	}
+
+	list_for_each_entry_safe(bulk, tmp, &pool->full_list, entry) {
+		mlx5_crypto_dek_bulk_reset_synced(pool, bulk);
+
+		if (!bulk->avail_deks)
+			continue;
+
+		if (MLX5_CRYPTO_DEK_BULK_IDLE(bulk))
+			list_move(&bulk->entry, &pool->avail_list);
+		else
+			list_move(&bulk->entry, &pool->partial_list);
+	}
+
+	list_for_each_entry_safe(bulk, tmp, &pool->sync_list, entry) {
+		memset(bulk->need_sync, 0, BITS_TO_BYTES(bulk->num_deks));
+		bulk->avail_start = 0;
+		bulk->avail_deks = bulk->num_deks;
+		pool->avail_deks += bulk->num_deks;
+	}
+	list_splice_init(&pool->sync_list, &pool->avail_list);
+
+	mlx5_crypto_dek_pool_free_wait_keys(pool);
+}
+
+static void mlx5_crypto_dek_sync_work_fn(struct work_struct *work)
+{
+	struct mlx5_crypto_dek_pool *pool =
+		container_of(work, struct mlx5_crypto_dek_pool, sync_work);
+	int err;
+
+	err = mlx5_crypto_cmd_sync_crypto(pool->mdev, BIT(pool->key_purpose));
+	mutex_lock(&pool->lock);
+	if (!err)
+		mlx5_crypto_dek_pool_reset_synced(pool);
+	pool->syncing = false;
+	mutex_unlock(&pool->lock);
+}
+
 struct mlx5_crypto_dek *mlx5_crypto_dek_create(struct mlx5_crypto_dek_pool *dek_pool,
 					       const void *key, u32 sz_bytes)
 {
@@ -473,8 +633,12 @@ mlx5_crypto_dek_pool_create(struct mlx5_core_dev *mdev, int key_purpose)
 	pool->key_purpose = key_purpose;
 
 	mutex_init(&pool->lock);
+	INIT_LIST_HEAD(&pool->avail_list);
 	INIT_LIST_HEAD(&pool->partial_list);
 	INIT_LIST_HEAD(&pool->full_list);
+	INIT_LIST_HEAD(&pool->sync_list);
+	INIT_LIST_HEAD(&pool->wait_for_free);
+	INIT_WORK(&pool->sync_work, mlx5_crypto_dek_sync_work_fn);
 
 	return pool;
 }
@@ -483,9 +647,19 @@ void mlx5_crypto_dek_pool_destroy(struct mlx5_crypto_dek_pool *pool)
 {
 	struct mlx5_crypto_dek_bulk *bulk, *tmp;
 
+	cancel_work_sync(&pool->sync_work);
+
+	mlx5_crypto_dek_pool_free_wait_keys(pool);
+
+	list_for_each_entry_safe(bulk, tmp, &pool->avail_list, entry)
+		mlx5_crypto_dek_pool_remove_bulk(pool, bulk);
+
 	list_for_each_entry_safe(bulk, tmp, &pool->full_list, entry)
 		mlx5_crypto_dek_pool_remove_bulk(pool, bulk);
 
+	list_for_each_entry_safe(bulk, tmp, &pool->sync_list, entry)
+		mlx5_crypto_dek_pool_remove_bulk(pool, bulk);
+
 	list_for_each_entry_safe(bulk, tmp, &pool->partial_list, entry)
 		mlx5_crypto_dek_pool_remove_bulk(pool, bulk);
 
-- 
2.39.1

