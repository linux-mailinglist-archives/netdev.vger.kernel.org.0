Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEBB6822A0
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 04:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbjAaDNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 22:13:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbjAaDMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 22:12:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8393738B6C
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 19:12:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A830B81929
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 03:12:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A885BC433EF;
        Tue, 31 Jan 2023 03:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675134737;
        bh=hMnQDy3BaU9cZOItICvF/VoghopDcckRKw8k9GRDl2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LYeJsNbeDSIoTJbKMA4EZ7GiyDABrLImXFhj33wSxCCbHi/1VutXT1kZadQFa9NI3
         MrsmSt1errMm92WDjFUIZhX374FsjCWHzTYwC8HZhNYFBaUIsL+GiceKf4tH18RwJt
         J1nfDzy9EHRKP6JRG2yMdlMOgnh/4plMFGRft5PQMROvHX4sGFeCGLoW47q6/C9ffF
         6FZADYwZnynf+Dl8KdfdOBAoO2dMxZYYJmnPZSy03vsYJVmnQqKL+aqQHWHWxB/SmW
         XW6GJx9PQGLo/JwcES26r7hTa428SlXFCNUHwlp5TPSSe3+pWDg0oK3FOM3gtLVFlP
         u1uzShyvXSIcA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>
Subject: [net-next 11/15] net/mlx5: Use bulk allocation for fast update encryption key
Date:   Mon, 30 Jan 2023 19:11:57 -0800
Message-Id: <20230131031201.35336-12-saeed@kernel.org>
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

We create a pool for each key type. For the pool, there is a struct
to store the info for all DEK objects of one bulk allocation. As we
use crypto->log_dek_obj_range, which is set to 12 in previous patch,
for the log_obj_range of bulk allocation, 4096 DEKs are allocated in
one time.

To trace the state of all the keys in a bulk, two bitmaps are created.
The need_sync bitmap is used to indicate the available state of the
corresponding key. If the bit is 0, it can be used (available) as it
either is newly created by FW, or SYNC_CRYPTO is executed and bit is
reset after it is freed by upper layer user (this is the case to be
handled in later patch). Otherwise, the key need to be synced. The
in_use bitmap is used to indicate the key is being used, and reset
when user free it.

When ktls, ipsec or macsec need a key from a bulk, it get one with
need_sync bit 0, then set both need_sync and in_used bit to 1. When
user free a key, only in_use bit is reset to 0. So, for the
combinations of (need_sync, in_use) of one DEK object,
   - (0,0) means the key is ready for use,
   - (1,1) means the key is currently being used by a user,
   - (1,0) means the key is freed, and waiting for being synced,
   - (0,1) is invalid state.

There are two lists in each pool, partial_list and full_list,
according to the number for available DEKs in a bulk. When user need a
key, it get a bulk, either from partial list, or create new one from
FW. Then the bulk is put in the different pool's lists according to
the num of avail deks it has. If there is no avail deks, and all of
them are be freed by users, for now, the bulk is destroyed.

To speed up the bitmap search, a variable (avail_start) is added to
indicate where to start to search need_sync bitmap for available key.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/lib/crypto.c  | 215 +++++++++++++++++-
 1 file changed, 208 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
index a7b863859d50..5c92ac5d95ee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
@@ -14,6 +14,28 @@ enum {
 struct mlx5_crypto_dek_pool {
 	struct mlx5_core_dev *mdev;
 	u32 key_purpose;
+	int num_deks; /* the total number of keys in this pool */
+	int avail_deks; /* the number of available keys in this pool */
+	int in_use_deks; /* the number of being used keys in this pool */
+	struct mutex lock; /* protect the following lists, and the bulks */
+	struct list_head partial_list; /* some of keys are available */
+	struct list_head full_list; /* no available keys */
+};
+
+struct mlx5_crypto_dek_bulk {
+	struct mlx5_core_dev *mdev;
+	int base_obj_id;
+	int avail_start; /* the bit to start search */
+	int num_deks; /* the total number of keys in a bulk */
+	int avail_deks; /* the number of keys available, with need_sync bit 0 */
+	int in_use_deks; /* the number of keys being used, with in_use bit 1 */
+	struct list_head entry;
+
+	/* 0: not being used by any user, 1: otherwise */
+	unsigned long *in_use;
+
+	/* The bits are set when they are used, and initialized to 0 */
+	unsigned long *need_sync;
 };
 
 struct mlx5_crypto_dek_priv {
@@ -22,6 +44,7 @@ struct mlx5_crypto_dek_priv {
 };
 
 struct mlx5_crypto_dek {
+	struct mlx5_crypto_dek_bulk *bulk;
 	u32 obj_id;
 };
 
@@ -227,13 +250,166 @@ void mlx5_destroy_encryption_key(struct mlx5_core_dev *mdev, u32 key_id)
 	mlx5_crypto_destroy_dek_key(mdev, key_id);
 }
 
+static struct mlx5_crypto_dek_bulk *
+mlx5_crypto_dek_bulk_create(struct mlx5_crypto_dek_pool *pool)
+{
+	struct mlx5_crypto_dek_priv *dek_priv = pool->mdev->mlx5e_res.dek_priv;
+	struct mlx5_core_dev *mdev = pool->mdev;
+	struct mlx5_crypto_dek_bulk *bulk;
+	int num_deks, base_obj_id;
+	int err;
+
+	bulk = kzalloc(sizeof(*bulk), GFP_KERNEL);
+	if (!bulk)
+		return ERR_PTR(-ENOMEM);
+
+	num_deks = 1 << dek_priv->log_dek_obj_range;
+	bulk->need_sync = bitmap_zalloc(num_deks, GFP_KERNEL);
+	if (!bulk->need_sync) {
+		err = -ENOMEM;
+		goto err_out;
+	}
+
+	bulk->in_use = bitmap_zalloc(num_deks, GFP_KERNEL);
+	if (!bulk->in_use) {
+		err = -ENOMEM;
+		goto err_out;
+	}
+
+	err = mlx5_crypto_create_dek_bulk(mdev, pool->key_purpose,
+					  dek_priv->log_dek_obj_range,
+					  &base_obj_id);
+	if (err)
+		goto err_out;
+
+	bulk->base_obj_id = base_obj_id;
+	bulk->num_deks = num_deks;
+	bulk->avail_deks = num_deks;
+	bulk->mdev = mdev;
+
+	return bulk;
+
+err_out:
+	bitmap_free(bulk->in_use);
+	bitmap_free(bulk->need_sync);
+	kfree(bulk);
+	return ERR_PTR(err);
+}
+
+static struct mlx5_crypto_dek_bulk *
+mlx5_crypto_dek_pool_add_bulk(struct mlx5_crypto_dek_pool *pool)
+{
+	struct mlx5_crypto_dek_bulk *bulk;
+
+	bulk = mlx5_crypto_dek_bulk_create(pool);
+	if (IS_ERR(bulk))
+		return bulk;
+
+	pool->avail_deks += bulk->num_deks;
+	pool->num_deks += bulk->num_deks;
+	list_add(&bulk->entry, &pool->partial_list);
+
+	return bulk;
+}
+
+static void mlx5_crypto_dek_bulk_free(struct mlx5_crypto_dek_bulk *bulk)
+{
+	mlx5_crypto_destroy_dek_key(bulk->mdev, bulk->base_obj_id);
+	bitmap_free(bulk->need_sync);
+	bitmap_free(bulk->in_use);
+	kfree(bulk);
+}
+
+static void mlx5_crypto_dek_pool_remove_bulk(struct mlx5_crypto_dek_pool *pool,
+					     struct mlx5_crypto_dek_bulk *bulk)
+{
+	pool->num_deks -= bulk->num_deks;
+	pool->avail_deks -= bulk->avail_deks;
+	pool->in_use_deks -= bulk->in_use_deks;
+	list_del(&bulk->entry);
+	mlx5_crypto_dek_bulk_free(bulk);
+}
+
+static struct mlx5_crypto_dek_bulk *
+mlx5_crypto_dek_pool_pop(struct mlx5_crypto_dek_pool *pool, u32 *obj_offset)
+{
+	struct mlx5_crypto_dek_bulk *bulk;
+	int pos;
+
+	mutex_lock(&pool->lock);
+	bulk = list_first_entry_or_null(&pool->partial_list,
+					struct mlx5_crypto_dek_bulk, entry);
+
+	if (bulk) {
+		pos = find_next_zero_bit(bulk->need_sync, bulk->num_deks,
+					 bulk->avail_start);
+		if (pos == bulk->num_deks) {
+			mlx5_core_err(pool->mdev, "Wrong DEK bulk avail_start.\n");
+			pos = find_first_zero_bit(bulk->need_sync, bulk->num_deks);
+		}
+		WARN_ON(pos == bulk->num_deks);
+	} else {
+		bulk = mlx5_crypto_dek_pool_add_bulk(pool);
+		if (IS_ERR(bulk))
+			goto out;
+		pos = 0;
+	}
+
+	*obj_offset = pos;
+	bitmap_set(bulk->need_sync, pos, 1);
+	bitmap_set(bulk->in_use, pos, 1);
+	bulk->in_use_deks++;
+	bulk->avail_deks--;
+	if (!bulk->avail_deks) {
+		list_move(&bulk->entry, &pool->full_list);
+		bulk->avail_start = bulk->num_deks;
+	} else {
+		bulk->avail_start = pos + 1;
+	}
+	pool->avail_deks--;
+	pool->in_use_deks++;
+
+out:
+	mutex_unlock(&pool->lock);
+	return bulk;
+}
+
+static int mlx5_crypto_dek_pool_push(struct mlx5_crypto_dek_pool *pool,
+				     struct mlx5_crypto_dek *dek)
+{
+	struct mlx5_crypto_dek_bulk *bulk = dek->bulk;
+	int obj_offset;
+	bool old_val;
+	int err = 0;
+
+	mutex_lock(&pool->lock);
+	obj_offset = dek->obj_id - bulk->base_obj_id;
+	old_val = test_and_clear_bit(obj_offset, bulk->in_use);
+	WARN_ON_ONCE(!old_val);
+	if (!old_val) {
+		err = -ENOENT;
+		goto out_free;
+	}
+	pool->in_use_deks--;
+	bulk->in_use_deks--;
+	if (!bulk->avail_deks && !bulk->in_use_deks)
+		mlx5_crypto_dek_pool_remove_bulk(pool, bulk);
+
+out_free:
+	mutex_unlock(&pool->lock);
+	kfree(dek);
+	return err;
+}
+
 struct mlx5_crypto_dek *mlx5_crypto_dek_create(struct mlx5_crypto_dek_pool *dek_pool,
 					       const void *key, u32 sz_bytes)
 {
 	struct mlx5_crypto_dek_priv *dek_priv = dek_pool->mdev->mlx5e_res.dek_priv;
 	struct mlx5_core_dev *mdev = dek_pool->mdev;
 	u32 key_purpose = dek_pool->key_purpose;
+	struct mlx5_crypto_dek_bulk *bulk;
 	struct mlx5_crypto_dek *dek;
+	int obj_offset;
 	int err;
 
 	dek = kzalloc(sizeof(*dek), GFP_KERNEL);
@@ -246,14 +422,20 @@ struct mlx5_crypto_dek *mlx5_crypto_dek_create(struct mlx5_crypto_dek_pool *dek_
 		goto out;
 	}
 
-	err = mlx5_crypto_create_dek_bulk(mdev, key_purpose, 0, &dek->obj_id);
-	if (err)
+	bulk = mlx5_crypto_dek_pool_pop(dek_pool, &obj_offset);
+	if (IS_ERR(bulk)) {
+		err = PTR_ERR(bulk);
 		goto out;
+	}
 
+	dek->bulk = bulk;
+	dek->obj_id = bulk->base_obj_id + obj_offset;
 	err = mlx5_crypto_modify_dek_key(mdev, key, sz_bytes, key_purpose,
-					 dek->obj_id, 0);
-	if (err)
-		mlx5_crypto_destroy_dek_key(mdev, dek->obj_id);
+					 bulk->base_obj_id, obj_offset);
+	if (err) {
+		mlx5_crypto_dek_pool_push(dek_pool, dek);
+		return ERR_PTR(err);
+	}
 
 out:
 	if (err) {
@@ -267,10 +449,15 @@ struct mlx5_crypto_dek *mlx5_crypto_dek_create(struct mlx5_crypto_dek_pool *dek_
 void mlx5_crypto_dek_destroy(struct mlx5_crypto_dek_pool *dek_pool,
 			     struct mlx5_crypto_dek *dek)
 {
+	struct mlx5_crypto_dek_priv *dek_priv = dek_pool->mdev->mlx5e_res.dek_priv;
 	struct mlx5_core_dev *mdev = dek_pool->mdev;
 
-	mlx5_crypto_destroy_dek_key(mdev, dek->obj_id);
-	kfree(dek);
+	if (!dek_priv) {
+		mlx5_crypto_destroy_dek_key(mdev, dek->obj_id);
+		kfree(dek);
+	} else {
+		mlx5_crypto_dek_pool_push(dek_pool, dek);
+	}
 }
 
 struct mlx5_crypto_dek_pool *
@@ -285,11 +472,25 @@ mlx5_crypto_dek_pool_create(struct mlx5_core_dev *mdev, int key_purpose)
 	pool->mdev = mdev;
 	pool->key_purpose = key_purpose;
 
+	mutex_init(&pool->lock);
+	INIT_LIST_HEAD(&pool->partial_list);
+	INIT_LIST_HEAD(&pool->full_list);
+
 	return pool;
 }
 
 void mlx5_crypto_dek_pool_destroy(struct mlx5_crypto_dek_pool *pool)
 {
+	struct mlx5_crypto_dek_bulk *bulk, *tmp;
+
+	list_for_each_entry_safe(bulk, tmp, &pool->full_list, entry)
+		mlx5_crypto_dek_pool_remove_bulk(pool, bulk);
+
+	list_for_each_entry_safe(bulk, tmp, &pool->partial_list, entry)
+		mlx5_crypto_dek_pool_remove_bulk(pool, bulk);
+
+	mutex_destroy(&pool->lock);
+
 	kfree(pool);
 }
 
-- 
2.39.1

