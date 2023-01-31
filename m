Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA8B26822A5
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 04:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbjAaDNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 22:13:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbjAaDMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 22:12:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD5D23929E
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 19:12:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AB8A61384
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 03:12:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1EE6C433EF;
        Tue, 31 Jan 2023 03:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675134741;
        bh=65watD32YJ1vXPqhN0UtEBoCqgKec38+6RDGW0Whpgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kfR05dnarBofBBfqa/9e9wDkiyu8WxoXxCP/fCzsmF5qIdxs0XEn/l7tfIfCS9zJY
         f110iqo2/hRk+/slwSuE8eTsnw41YT1BlLIs14Zb6Twy963NPxoqhBJhXzORWWzEcs
         cXJUtRAw4jOcTcwkfrNwIE5zAabaQh4xwcPYO6LKS7u2mGLy2uRm5B8t7az6ErIxE5
         zh0pfnU/ceVV5dN43dePJLFJgqtiihkIMgkDXjjFHDbS2fbZUFR8yX0YNvlOehuDeU
         EH4boZ7tamh6xYXl6vHLZTGHLrZdPs9p/uoRnYIjnTdLJc7aS7GFl8Euie97HcR2ec
         4ADXvwxnNuoGg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>
Subject: [net-next 15/15] net/mlx5e: kTLS, Improve connection rate by using fast update encryption key
Date:   Mon, 30 Jan 2023 19:12:01 -0800
Message-Id: <20230131031201.35336-16-saeed@kernel.org>
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

As the fast DEK update is fully implemented, use it for kTLS to get
better performance.
TIS pool was already supported to recycle the TISes. With this series
and TIS pool, TLS CPS is improved by 9x higher, from 11k/s to 101k/s.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ktls.c        | 26 ++++++++++++-------
 .../mellanox/mlx5/core/en_accel/ktls.h        | 11 +++++---
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     | 21 ++++++++-------
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 17 +++++++-----
 4 files changed, 45 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
index f80d6fce28d2..cf704f106b7c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
@@ -9,9 +9,8 @@
 #include "en_accel/ktls_utils.h"
 #include "en_accel/fs_tcp.h"
 
-int mlx5_ktls_create_key(struct mlx5_core_dev *mdev,
-			 struct tls_crypto_info *crypto_info,
-			 u32 *p_key_id)
+struct mlx5_crypto_dek *mlx5_ktls_create_key(struct mlx5_crypto_dek_pool *dek_pool,
+					     struct tls_crypto_info *crypto_info)
 {
 	const void *key;
 	u32 sz_bytes;
@@ -34,17 +33,16 @@ int mlx5_ktls_create_key(struct mlx5_core_dev *mdev,
 		break;
 	}
 	default:
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 	}
 
-	return mlx5_create_encryption_key(mdev, key, sz_bytes,
-					  MLX5_ACCEL_OBJ_TLS_KEY,
-					  p_key_id);
+	return mlx5_crypto_dek_create(dek_pool, key, sz_bytes);
 }
 
-void mlx5_ktls_destroy_key(struct mlx5_core_dev *mdev, u32 key_id)
+void mlx5_ktls_destroy_key(struct mlx5_crypto_dek_pool *dek_pool,
+			   struct mlx5_crypto_dek *dek)
 {
-	mlx5_destroy_encryption_key(mdev, key_id);
+	mlx5_crypto_dek_destroy(dek_pool, dek);
 }
 
 static int mlx5e_ktls_add(struct net_device *netdev, struct sock *sk,
@@ -190,6 +188,7 @@ static void mlx5e_tls_debugfs_init(struct mlx5e_tls *tls,
 
 int mlx5e_ktls_init(struct mlx5e_priv *priv)
 {
+	struct mlx5_crypto_dek_pool *dek_pool;
 	struct mlx5e_tls *tls;
 
 	if (!mlx5e_is_ktls_device(priv->mdev))
@@ -198,9 +197,15 @@ int mlx5e_ktls_init(struct mlx5e_priv *priv)
 	tls = kzalloc(sizeof(*tls), GFP_KERNEL);
 	if (!tls)
 		return -ENOMEM;
+	tls->mdev = priv->mdev;
 
+	dek_pool = mlx5_crypto_dek_pool_create(priv->mdev, MLX5_ACCEL_OBJ_TLS_KEY);
+	if (IS_ERR(dek_pool)) {
+		kfree(tls);
+		return PTR_ERR(dek_pool);
+	}
+	tls->dek_pool = dek_pool;
 	priv->tls = tls;
-	priv->tls->mdev = priv->mdev;
 
 	mlx5e_tls_debugfs_init(tls, priv->dfs_root);
 
@@ -217,6 +222,7 @@ void mlx5e_ktls_cleanup(struct mlx5e_priv *priv)
 	debugfs_remove_recursive(tls->debugfs.dfs);
 	tls->debugfs.dfs = NULL;
 
+	mlx5_crypto_dek_pool_destroy(tls->dek_pool);
 	kfree(priv->tls);
 	priv->tls = NULL;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
index fccf995ee16d..f11075e67658 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
@@ -10,10 +10,12 @@
 #include "en.h"
 
 #ifdef CONFIG_MLX5_EN_TLS
-int mlx5_ktls_create_key(struct mlx5_core_dev *mdev,
-			 struct tls_crypto_info *crypto_info,
-			 u32 *p_key_id);
-void mlx5_ktls_destroy_key(struct mlx5_core_dev *mdev, u32 key_id);
+#include "lib/crypto.h"
+
+struct mlx5_crypto_dek *mlx5_ktls_create_key(struct mlx5_crypto_dek_pool *dek_pool,
+					     struct tls_crypto_info *crypto_info);
+void mlx5_ktls_destroy_key(struct mlx5_crypto_dek_pool *dek_pool,
+			   struct mlx5_crypto_dek *dek);
 
 static inline bool mlx5e_is_ktls_device(struct mlx5_core_dev *mdev)
 {
@@ -83,6 +85,7 @@ struct mlx5e_tls {
 	struct mlx5e_tls_sw_stats sw_stats;
 	struct workqueue_struct *rx_wq;
 	struct mlx5e_tls_tx_pool *tx_pool;
+	struct mlx5_crypto_dek_pool *dek_pool;
 	struct mlx5e_tls_debugfs debugfs;
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index 3e54834747ce..4be770443b0c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -50,7 +50,7 @@ struct mlx5e_ktls_offload_context_rx {
 	struct mlx5e_tls_sw_stats *sw_stats;
 	struct completion add_ctx;
 	struct mlx5e_tir tir;
-	u32 key_id;
+	struct mlx5_crypto_dek *dek;
 	u32 rxq;
 	DECLARE_BITMAP(flags, MLX5E_NUM_PRIV_RX_FLAGS);
 
@@ -148,7 +148,8 @@ post_static_params(struct mlx5e_icosq *sq,
 	wqe = MLX5E_TLS_FETCH_SET_STATIC_PARAMS_WQE(sq, pi);
 	mlx5e_ktls_build_static_params(wqe, sq->pc, sq->sqn, &priv_rx->crypto_info,
 				       mlx5e_tir_get_tirn(&priv_rx->tir),
-				       priv_rx->key_id, priv_rx->resync.seq, false,
+				       mlx5_crypto_dek_get_id(priv_rx->dek),
+				       priv_rx->resync.seq, false,
 				       TLS_OFFLOAD_CTX_DIR_RX);
 	wi = (struct mlx5e_icosq_wqe_info) {
 		.wqe_type = MLX5E_ICOSQ_WQE_UMR_TLS,
@@ -610,20 +611,22 @@ int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
 	struct mlx5e_ktls_offload_context_rx *priv_rx;
 	struct mlx5e_ktls_rx_resync_ctx *resync;
 	struct tls_context *tls_ctx;
-	struct mlx5_core_dev *mdev;
+	struct mlx5_crypto_dek *dek;
 	struct mlx5e_priv *priv;
 	int rxq, err;
 
 	tls_ctx = tls_get_ctx(sk);
 	priv = netdev_priv(netdev);
-	mdev = priv->mdev;
 	priv_rx = kzalloc(sizeof(*priv_rx), GFP_KERNEL);
 	if (unlikely(!priv_rx))
 		return -ENOMEM;
 
-	err = mlx5_ktls_create_key(mdev, crypto_info, &priv_rx->key_id);
-	if (err)
+	dek = mlx5_ktls_create_key(priv->tls->dek_pool, crypto_info);
+	if (IS_ERR(dek)) {
+		err = PTR_ERR(dek);
 		goto err_create_key;
+	}
+	priv_rx->dek = dek;
 
 	INIT_LIST_HEAD(&priv_rx->list);
 	spin_lock_init(&priv_rx->lock);
@@ -673,7 +676,7 @@ int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
 err_post_wqes:
 	mlx5e_tir_destroy(&priv_rx->tir);
 err_create_tir:
-	mlx5_ktls_destroy_key(mdev, priv_rx->key_id);
+	mlx5_ktls_destroy_key(priv->tls->dek_pool, priv_rx->dek);
 err_create_key:
 	kfree(priv_rx);
 	return err;
@@ -683,11 +686,9 @@ void mlx5e_ktls_del_rx(struct net_device *netdev, struct tls_context *tls_ctx)
 {
 	struct mlx5e_ktls_offload_context_rx *priv_rx;
 	struct mlx5e_ktls_rx_resync_ctx *resync;
-	struct mlx5_core_dev *mdev;
 	struct mlx5e_priv *priv;
 
 	priv = netdev_priv(netdev);
-	mdev = priv->mdev;
 
 	priv_rx = mlx5e_get_ktls_rx_priv_ctx(tls_ctx);
 	set_bit(MLX5E_PRIV_RX_FLAG_DELETING, priv_rx->flags);
@@ -707,7 +708,7 @@ void mlx5e_ktls_del_rx(struct net_device *netdev, struct tls_context *tls_ctx)
 		mlx5e_accel_fs_del_sk(priv_rx->rule.rule);
 
 	mlx5e_tir_destroy(&priv_rx->tir);
-	mlx5_ktls_destroy_key(mdev, priv_rx->key_id);
+	mlx5_ktls_destroy_key(priv->tls->dek_pool, priv_rx->dek);
 	/* priv_rx should normally be freed here, but if there is an outstanding
 	 * GET_PSV, deallocation will be delayed until the CQE for GET_PSV is
 	 * processed.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 6db27062b765..e80b43b7aac9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -98,7 +98,7 @@ struct mlx5e_ktls_offload_context_tx {
 	struct tls_offload_context_tx *tx_ctx;
 	struct mlx5_core_dev *mdev;
 	struct mlx5e_tls_sw_stats *sw_stats;
-	u32 key_id;
+	struct mlx5_crypto_dek *dek;
 	u8 create_err : 1;
 };
 
@@ -457,6 +457,7 @@ int mlx5e_ktls_add_tx(struct net_device *netdev, struct sock *sk,
 	struct mlx5e_ktls_offload_context_tx *priv_tx;
 	struct mlx5e_tls_tx_pool *pool;
 	struct tls_context *tls_ctx;
+	struct mlx5_crypto_dek *dek;
 	struct mlx5e_priv *priv;
 	int err;
 
@@ -468,9 +469,12 @@ int mlx5e_ktls_add_tx(struct net_device *netdev, struct sock *sk,
 	if (IS_ERR(priv_tx))
 		return PTR_ERR(priv_tx);
 
-	err = mlx5_ktls_create_key(pool->mdev, crypto_info, &priv_tx->key_id);
-	if (err)
+	dek = mlx5_ktls_create_key(priv->tls->dek_pool, crypto_info);
+	if (IS_ERR(dek)) {
+		err = PTR_ERR(dek);
 		goto err_create_key;
+	}
+	priv_tx->dek = dek;
 
 	priv_tx->expected_seq = start_offload_tcp_sn;
 	switch (crypto_info->cipher_type) {
@@ -512,7 +516,7 @@ void mlx5e_ktls_del_tx(struct net_device *netdev, struct tls_context *tls_ctx)
 	pool = priv->tls->tx_pool;
 
 	atomic64_inc(&priv_tx->sw_stats->tx_tls_del);
-	mlx5_ktls_destroy_key(priv_tx->mdev, priv_tx->key_id);
+	mlx5_ktls_destroy_key(priv->tls->dek_pool, priv_tx->dek);
 	pool_push(pool, priv_tx);
 }
 
@@ -551,8 +555,9 @@ post_static_params(struct mlx5e_txqsq *sq,
 	pi = mlx5e_txqsq_get_next_pi(sq, num_wqebbs);
 	wqe = MLX5E_TLS_FETCH_SET_STATIC_PARAMS_WQE(sq, pi);
 	mlx5e_ktls_build_static_params(wqe, sq->pc, sq->sqn, &priv_tx->crypto_info,
-				       priv_tx->tisn, priv_tx->key_id, 0, fence,
-				       TLS_OFFLOAD_CTX_DIR_TX);
+				       priv_tx->tisn,
+				       mlx5_crypto_dek_get_id(priv_tx->dek),
+				       0, fence, TLS_OFFLOAD_CTX_DIR_TX);
 	tx_fill_wi(sq, pi, num_wqebbs, 0, NULL);
 	sq->pc += num_wqebbs;
 }
-- 
2.39.1

