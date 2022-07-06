Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2749C5695CC
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 01:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234576AbiGFXZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 19:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234509AbiGFXYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 19:24:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ACD02BB37
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 16:24:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF0D8B81F46
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 23:24:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D6AC3411C;
        Wed,  6 Jul 2022 23:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657149878;
        bh=DkK952YfY/ktzQixzO8elDesufgwYu30dKxP7S7UH2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M9oUsP1T62pJk+WyIjVhoy7t06HJJPindLxo/ZE3vcbDgf0Of8I6Ja5QBCJmKejXD
         xBtTi/H6XL2q2opQq+3TjG4Q9rP5LWw3ba9ZrMQhI6ipU6qzS6oP7PjwU2dyR8Tikz
         3R1Bm9YbjLFmTJxx8Emz5qW0T7cqumXqNuZh+nTxSEYJ12RZTjnvLIl+9a8TkiBDqo
         dK5MCTxsg2dPKWdzUumCQHUsQ9aodxiVtA7xgOsawpN5/341vmS/Q9fqiyL4APauhU
         MD6AgPn2JqONJU6e5Q4DHMPSs5RW/ZKHylZ6y+/BFK7L3tSeWFzcHkvgPsv09z5K0H
         ZOv9d7v8dPKmA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [net-next 14/15] net/mlx5e: kTLS, Recycle objects of device-offloaded TLS TX connections
Date:   Wed,  6 Jul 2022 16:24:20 -0700
Message-Id: <20220706232421.41269-15-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220706232421.41269-1-saeed@kernel.org>
References: <20220706232421.41269-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

The transport interface send (TIS) object is responsible for performing
all transport related operations of the transmit side.  The ConnectX HW
uses a TIS object to save and access the TLS crypto information and state
of an offloaded TX kTLS connection.

Before this patch, we used to create a new TIS per connection and destroy
it once it’s closed. Every create and destroy of a TIS is a FW command.

Same applies for the private TLS context, where we used to dynamically
allocate and free it per connection.

Resources recycling reduce the impact of the allocation/free operations
and helps speeding up the connection rate.

In this feature we maintain a pool of TX objects and use it to recycle
the resources instead of re-creating them per connection.

A cached TIS popped from the pool is updated to serve the new connection
via the fast-path HW interface, updating the tls static and progress
params. This is a very fast operation, significantly faster than FW
commands.

On recycling, a WQE fence is required after the context params change.
This guarantees that the data is sent after the context has been
successfully updated in hardware, and that the context modification
doesn't interfere with existing traffic.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/en_accel.h    |  10 +
 .../mellanox/mlx5/core/en_accel/ktls.h        |  14 ++
 .../mellanox/mlx5/core/en_accel/ktls_stats.c  |   2 +
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 211 ++++++++++++++----
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   9 +
 5 files changed, 199 insertions(+), 47 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index 04c0a5e1c89a..1839f1ab1ddd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -194,4 +194,14 @@ static inline void mlx5e_accel_cleanup_rx(struct mlx5e_priv *priv)
 {
 	mlx5e_ktls_cleanup_rx(priv);
 }
+
+static inline int mlx5e_accel_init_tx(struct mlx5e_priv *priv)
+{
+	return mlx5e_ktls_init_tx(priv);
+}
+
+static inline void mlx5e_accel_cleanup_tx(struct mlx5e_priv *priv)
+{
+	mlx5e_ktls_cleanup_tx(priv);
+}
 #endif /* __MLX5E_EN_ACCEL_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
index d016624fbc9d..948400dee525 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
@@ -42,6 +42,8 @@ static inline bool mlx5e_ktls_type_check(struct mlx5_core_dev *mdev,
 }
 
 void mlx5e_ktls_build_netdev(struct mlx5e_priv *priv);
+int mlx5e_ktls_init_tx(struct mlx5e_priv *priv);
+void mlx5e_ktls_cleanup_tx(struct mlx5e_priv *priv);
 int mlx5e_ktls_init_rx(struct mlx5e_priv *priv);
 void mlx5e_ktls_cleanup_rx(struct mlx5e_priv *priv);
 int mlx5e_ktls_set_feature_rx(struct net_device *netdev, bool enable);
@@ -62,6 +64,8 @@ static inline bool mlx5e_is_ktls_rx(struct mlx5_core_dev *mdev)
 struct mlx5e_tls_sw_stats {
 	atomic64_t tx_tls_ctx;
 	atomic64_t tx_tls_del;
+	atomic64_t tx_tls_pool_alloc;
+	atomic64_t tx_tls_pool_free;
 	atomic64_t rx_tls_ctx;
 	atomic64_t rx_tls_del;
 };
@@ -69,6 +73,7 @@ struct mlx5e_tls_sw_stats {
 struct mlx5e_tls {
 	struct mlx5e_tls_sw_stats sw_stats;
 	struct workqueue_struct *rx_wq;
+	struct mlx5e_tls_tx_pool *tx_pool;
 };
 
 int mlx5e_ktls_init(struct mlx5e_priv *priv);
@@ -83,6 +88,15 @@ static inline void mlx5e_ktls_build_netdev(struct mlx5e_priv *priv)
 {
 }
 
+static inline int mlx5e_ktls_init_tx(struct mlx5e_priv *priv)
+{
+	return 0;
+}
+
+static inline void mlx5e_ktls_cleanup_tx(struct mlx5e_priv *priv)
+{
+}
+
 static inline int mlx5e_ktls_init_rx(struct mlx5e_priv *priv)
 {
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_stats.c
index 2ab46c4247ff..7c1c0eb16787 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_stats.c
@@ -41,6 +41,8 @@
 static const struct counter_desc mlx5e_ktls_sw_stats_desc[] = {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_tls_sw_stats, tx_tls_ctx) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_tls_sw_stats, tx_tls_del) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_tls_sw_stats, tx_tls_pool_alloc) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_tls_sw_stats, tx_tls_pool_free) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_tls_sw_stats, rx_tls_ctx) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_tls_sw_stats, rx_tls_del) },
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 99e1cd015083..24d1288e906a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -35,6 +35,7 @@ u16 mlx5e_ktls_get_stop_room(struct mlx5_core_dev *mdev, struct mlx5e_params *pa
 	stop_room += mlx5e_stop_room_for_wqe(mdev, MLX5E_TLS_SET_STATIC_PARAMS_WQEBBS);
 	stop_room += mlx5e_stop_room_for_wqe(mdev, MLX5E_TLS_SET_PROGRESS_PARAMS_WQEBBS);
 	stop_room += num_dumps * mlx5e_stop_room_for_wqe(mdev, MLX5E_KTLS_DUMP_WQEBBS);
+	stop_room += 1; /* fence nop */
 
 	return stop_room;
 }
@@ -56,13 +57,17 @@ static int mlx5e_ktls_create_tis(struct mlx5_core_dev *mdev, u32 *tisn)
 }
 
 struct mlx5e_ktls_offload_context_tx {
-	struct tls_offload_context_tx *tx_ctx;
-	struct tls12_crypto_info_aes_gcm_128 crypto_info;
-	struct mlx5e_tls_sw_stats *sw_stats;
+	/* fast path */
 	u32 expected_seq;
 	u32 tisn;
-	u32 key_id;
 	bool ctx_post_pending;
+	/* control / resync */
+	struct list_head list_node; /* member of the pool */
+	struct tls12_crypto_info_aes_gcm_128 crypto_info;
+	struct tls_offload_context_tx *tx_ctx;
+	struct mlx5_core_dev *mdev;
+	struct mlx5e_tls_sw_stats *sw_stats;
+	u32 key_id;
 };
 
 static void
@@ -87,28 +92,136 @@ mlx5e_get_ktls_tx_priv_ctx(struct tls_context *tls_ctx)
 	return *ctx;
 }
 
+static struct mlx5e_ktls_offload_context_tx *
+mlx5e_tls_priv_tx_init(struct mlx5_core_dev *mdev, struct mlx5e_tls_sw_stats *sw_stats)
+{
+	struct mlx5e_ktls_offload_context_tx *priv_tx;
+	int err;
+
+	priv_tx = kzalloc(sizeof(*priv_tx), GFP_KERNEL);
+	if (!priv_tx)
+		return ERR_PTR(-ENOMEM);
+
+	priv_tx->mdev = mdev;
+	priv_tx->sw_stats = sw_stats;
+
+	err = mlx5e_ktls_create_tis(mdev, &priv_tx->tisn);
+	if (err) {
+		kfree(priv_tx);
+		return ERR_PTR(err);
+	}
+
+	return priv_tx;
+}
+
+static void mlx5e_tls_priv_tx_cleanup(struct mlx5e_ktls_offload_context_tx *priv_tx)
+{
+	mlx5e_destroy_tis(priv_tx->mdev, priv_tx->tisn);
+	kfree(priv_tx);
+}
+
+static void mlx5e_tls_priv_tx_list_cleanup(struct list_head *list)
+{
+	struct mlx5e_ktls_offload_context_tx *obj;
+
+	list_for_each_entry(obj, list, list_node)
+		mlx5e_tls_priv_tx_cleanup(obj);
+}
+
+/* Recycling pool API */
+
+struct mlx5e_tls_tx_pool {
+	struct mlx5_core_dev *mdev;
+	struct mlx5e_tls_sw_stats *sw_stats;
+	struct mutex lock; /* Protects access to the pool */
+	struct list_head list;
+#define MLX5E_TLS_TX_POOL_MAX_SIZE (256)
+	size_t size;
+};
+
+static struct mlx5e_tls_tx_pool *mlx5e_tls_tx_pool_init(struct mlx5_core_dev *mdev,
+							struct mlx5e_tls_sw_stats *sw_stats)
+{
+	struct mlx5e_tls_tx_pool *pool;
+
+	pool = kvzalloc(sizeof(*pool), GFP_KERNEL);
+	if (!pool)
+		return NULL;
+
+	INIT_LIST_HEAD(&pool->list);
+	mutex_init(&pool->lock);
+
+	pool->mdev = mdev;
+	pool->sw_stats = sw_stats;
+
+	return pool;
+}
+
+static void mlx5e_tls_tx_pool_cleanup(struct mlx5e_tls_tx_pool *pool)
+{
+	mlx5e_tls_priv_tx_list_cleanup(&pool->list);
+	atomic64_add(pool->size, &pool->sw_stats->tx_tls_pool_free);
+	kvfree(pool);
+}
+
+static void pool_push(struct mlx5e_tls_tx_pool *pool, struct mlx5e_ktls_offload_context_tx *obj)
+{
+	mutex_lock(&pool->lock);
+	if (pool->size >= MLX5E_TLS_TX_POOL_MAX_SIZE) {
+		mutex_unlock(&pool->lock);
+		mlx5e_tls_priv_tx_cleanup(obj);
+		atomic64_inc(&pool->sw_stats->tx_tls_pool_free);
+		return;
+	}
+	list_add(&obj->list_node, &pool->list);
+	pool->size++;
+	mutex_unlock(&pool->lock);
+}
+
+static struct mlx5e_ktls_offload_context_tx *pool_pop(struct mlx5e_tls_tx_pool *pool)
+{
+	struct mlx5e_ktls_offload_context_tx *obj;
+
+	mutex_lock(&pool->lock);
+	if (pool->size == 0) {
+		obj = mlx5e_tls_priv_tx_init(pool->mdev, pool->sw_stats);
+		if (!IS_ERR(obj))
+			atomic64_inc(&pool->sw_stats->tx_tls_pool_alloc);
+		goto out;
+	}
+
+	obj = list_first_entry(&pool->list, struct mlx5e_ktls_offload_context_tx,
+			       list_node);
+	list_del(&obj->list_node);
+	pool->size--;
+out:
+	mutex_unlock(&pool->lock);
+	return obj;
+}
+
+/* End of pool API */
+
 int mlx5e_ktls_add_tx(struct net_device *netdev, struct sock *sk,
 		      struct tls_crypto_info *crypto_info, u32 start_offload_tcp_sn)
 {
 	struct mlx5e_ktls_offload_context_tx *priv_tx;
+	struct mlx5e_tls_tx_pool *pool;
 	struct tls_context *tls_ctx;
-	struct mlx5_core_dev *mdev;
 	struct mlx5e_priv *priv;
 	int err;
 
 	tls_ctx = tls_get_ctx(sk);
 	priv = netdev_priv(netdev);
-	mdev = priv->mdev;
+	pool = priv->tls->tx_pool;
 
-	priv_tx = kzalloc(sizeof(*priv_tx), GFP_KERNEL);
-	if (!priv_tx)
-		return -ENOMEM;
+	priv_tx = pool_pop(pool);
+	if (IS_ERR(priv_tx))
+		return PTR_ERR(priv_tx);
 
-	err = mlx5_ktls_create_key(mdev, crypto_info, &priv_tx->key_id);
+	err = mlx5_ktls_create_key(pool->mdev, crypto_info, &priv_tx->key_id);
 	if (err)
 		goto err_create_key;
 
-	priv_tx->sw_stats = &priv->tls->sw_stats;
 	priv_tx->expected_seq = start_offload_tcp_sn;
 	priv_tx->crypto_info  =
 		*(struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
@@ -116,36 +229,29 @@ int mlx5e_ktls_add_tx(struct net_device *netdev, struct sock *sk,
 
 	mlx5e_set_ktls_tx_priv_ctx(tls_ctx, priv_tx);
 
-	err = mlx5e_ktls_create_tis(mdev, &priv_tx->tisn);
-	if (err)
-		goto err_create_tis;
-
 	priv_tx->ctx_post_pending = true;
 	atomic64_inc(&priv_tx->sw_stats->tx_tls_ctx);
 
 	return 0;
 
-err_create_tis:
-	mlx5_ktls_destroy_key(mdev, priv_tx->key_id);
 err_create_key:
-	kfree(priv_tx);
+	pool_push(pool, priv_tx);
 	return err;
 }
 
 void mlx5e_ktls_del_tx(struct net_device *netdev, struct tls_context *tls_ctx)
 {
 	struct mlx5e_ktls_offload_context_tx *priv_tx;
-	struct mlx5_core_dev *mdev;
+	struct mlx5e_tls_tx_pool *pool;
 	struct mlx5e_priv *priv;
 
 	priv_tx = mlx5e_get_ktls_tx_priv_ctx(tls_ctx);
 	priv = netdev_priv(netdev);
-	mdev = priv->mdev;
+	pool = priv->tls->tx_pool;
 
 	atomic64_inc(&priv_tx->sw_stats->tx_tls_del);
-	mlx5e_destroy_tis(mdev, priv_tx->tisn);
-	mlx5_ktls_destroy_key(mdev, priv_tx->key_id);
-	kfree(priv_tx);
+	mlx5_ktls_destroy_key(priv_tx->mdev, priv_tx->key_id);
+	pool_push(pool, priv_tx);
 }
 
 static void tx_fill_wi(struct mlx5e_txqsq *sq,
@@ -206,6 +312,16 @@ post_progress_params(struct mlx5e_txqsq *sq,
 	sq->pc += num_wqebbs;
 }
 
+static void tx_post_fence_nop(struct mlx5e_txqsq *sq)
+{
+	struct mlx5_wq_cyc *wq = &sq->wq;
+	u16 pi = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
+
+	tx_fill_wi(sq, pi, 1, 0, NULL);
+
+	mlx5e_post_nop_fence(wq, sq->sqn, &sq->pc);
+}
+
 static void
 mlx5e_ktls_tx_post_param_wqes(struct mlx5e_txqsq *sq,
 			      struct mlx5e_ktls_offload_context_tx *priv_tx,
@@ -217,6 +333,7 @@ mlx5e_ktls_tx_post_param_wqes(struct mlx5e_txqsq *sq,
 		post_static_params(sq, priv_tx, fence_first_post);
 
 	post_progress_params(sq, priv_tx, progress_fence);
+	tx_post_fence_nop(sq);
 }
 
 struct tx_sync_info {
@@ -309,7 +426,7 @@ tx_post_resync_params(struct mlx5e_txqsq *sq,
 }
 
 static int
-tx_post_resync_dump(struct mlx5e_txqsq *sq, skb_frag_t *frag, u32 tisn, bool first)
+tx_post_resync_dump(struct mlx5e_txqsq *sq, skb_frag_t *frag, u32 tisn)
 {
 	struct mlx5_wqe_ctrl_seg *cseg;
 	struct mlx5_wqe_data_seg *dseg;
@@ -331,7 +448,6 @@ tx_post_resync_dump(struct mlx5e_txqsq *sq, skb_frag_t *frag, u32 tisn, bool fir
 	cseg->opmod_idx_opcode = cpu_to_be32((sq->pc << 8)  | MLX5_OPCODE_DUMP);
 	cseg->qpn_ds           = cpu_to_be32((sq->sqn << 8) | ds_cnt);
 	cseg->tis_tir_num      = cpu_to_be32(tisn << 8);
-	cseg->fm_ce_se         = first ? MLX5_FENCE_MODE_INITIATOR_SMALL : 0;
 
 	fsz = skb_frag_size(frag);
 	dma_addr = skb_frag_dma_map(sq->pdev, frag, 0, fsz,
@@ -366,16 +482,6 @@ void mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
 	stats->tls_dump_bytes += wi->num_bytes;
 }
 
-static void tx_post_fence_nop(struct mlx5e_txqsq *sq)
-{
-	struct mlx5_wq_cyc *wq = &sq->wq;
-	u16 pi = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
-
-	tx_fill_wi(sq, pi, 1, 0, NULL);
-
-	mlx5e_post_nop_fence(wq, sq->sqn, &sq->pc);
-}
-
 static enum mlx5e_ktls_sync_retval
 mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_context_tx *priv_tx,
 			 struct mlx5e_txqsq *sq,
@@ -396,14 +502,6 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_context_tx *priv_tx,
 
 	tx_post_resync_params(sq, priv_tx, info.rcd_sn);
 
-	/* If no dump WQE was sent, we need to have a fence NOP WQE before the
-	 * actual data xmit.
-	 */
-	if (!info.nr_frags) {
-		tx_post_fence_nop(sq);
-		return MLX5E_KTLS_SYNC_DONE;
-	}
-
 	for (i = 0; i < info.nr_frags; i++) {
 		unsigned int orig_fsz, frag_offset = 0, n = 0;
 		skb_frag_t *f = &info.frags[i];
@@ -411,13 +509,12 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_context_tx *priv_tx,
 		orig_fsz = skb_frag_size(f);
 
 		do {
-			bool fence = !(i || frag_offset);
 			unsigned int fsz;
 
 			n++;
 			fsz = min_t(unsigned int, sq->hw_mtu, orig_fsz - frag_offset);
 			skb_frag_size_set(f, fsz);
-			if (tx_post_resync_dump(sq, f, priv_tx->tisn, fence)) {
+			if (tx_post_resync_dump(sq, f, priv_tx->tisn)) {
 				page_ref_add(skb_frag_page(f), n - 1);
 				goto err_out;
 			}
@@ -465,9 +562,8 @@ bool mlx5e_ktls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 
 	priv_tx = mlx5e_get_ktls_tx_priv_ctx(tls_ctx);
 
-	if (unlikely(mlx5e_ktls_tx_offload_test_and_clear_pending(priv_tx))) {
+	if (unlikely(mlx5e_ktls_tx_offload_test_and_clear_pending(priv_tx)))
 		mlx5e_ktls_tx_post_param_wqes(sq, priv_tx, false, false);
-	}
 
 	seq = ntohl(tcp_hdr(skb)->seq);
 	if (unlikely(priv_tx->expected_seq != seq)) {
@@ -505,3 +601,24 @@ bool mlx5e_ktls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 	dev_kfree_skb_any(skb);
 	return false;
 }
+
+int mlx5e_ktls_init_tx(struct mlx5e_priv *priv)
+{
+	if (!mlx5e_is_ktls_tx(priv->mdev))
+		return 0;
+
+	priv->tls->tx_pool = mlx5e_tls_tx_pool_init(priv->mdev, &priv->tls->sw_stats);
+	if (!priv->tls->tx_pool)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void mlx5e_ktls_cleanup_tx(struct mlx5e_priv *priv)
+{
+	if (!mlx5e_is_ktls_tx(priv->mdev))
+		return;
+
+	mlx5e_tls_tx_pool_cleanup(priv->tls->tx_pool);
+	priv->tls->tx_pool = NULL;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 087952b84ccb..eb18cd459c7c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3135,6 +3135,7 @@ int mlx5e_create_tises(struct mlx5e_priv *priv)
 
 static void mlx5e_cleanup_nic_tx(struct mlx5e_priv *priv)
 {
+	mlx5e_accel_cleanup_tx(priv);
 	mlx5e_destroy_tises(priv);
 }
 
@@ -5120,8 +5121,16 @@ static int mlx5e_init_nic_tx(struct mlx5e_priv *priv)
 		return err;
 	}
 
+	err = mlx5e_accel_init_tx(priv);
+	if (err)
+		goto err_destroy_tises;
+
 	mlx5e_dcbnl_initialize(priv);
 	return 0;
+
+err_destroy_tises:
+	mlx5e_destroy_tises(priv);
+	return err;
 }
 
 static void mlx5e_nic_enable(struct mlx5e_priv *priv)
-- 
2.36.1

