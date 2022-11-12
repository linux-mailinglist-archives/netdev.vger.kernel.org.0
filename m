Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 692CB6268D5
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 11:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234834AbiKLKWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 05:22:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234825AbiKLKWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 05:22:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8706A2A702
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 02:22:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 093AAB8074C
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 10:22:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93681C433D7;
        Sat, 12 Nov 2022 10:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668248525;
        bh=FnNHFnp2rfnXetNiLcQO5jfTDlIYpYCuN3ATx6fndaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fTrixdAalHLt9CZUvZd+KQ8/WlnkxWoeRc+JonzlddOXN4P2XE/vAYAM2xtaBgD/M
         IntE7P6SE+AD2Gv4Re2gMhWXcmoYRSUTkCfLHQQEPDae3E37jYAbCz4M+LVRWwz9AV
         v7r89kqDP4Hhc3/ar0wQkEyxvMN6/ZrSOvkiXG91OSPqUvyc19iVAJflQ0Un8GvAAD
         pEUBoNEWPNQaBYpNa3VwTIGPYYoyYqqtHVsvuAR6pgz734iijAmMsDuW50yLyYRPE9
         YD02HcTqNXoNJcU2u9wOBSBxAi7IX9p84ECRIVw7USyqgyxHE0TFxPkmpah85Th4M9
         tZCCineiD30Nw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [net-next 13/15] net/mlx5e: kTLS, Use a single async context object per a callback bulk
Date:   Sat, 12 Nov 2022 02:21:45 -0800
Message-Id: <20221112102147.496378-14-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221112102147.496378-1-saeed@kernel.org>
References: <20221112102147.496378-1-saeed@kernel.org>
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

From: Tariq Toukan <tariqt@nvidia.com>

A single async context object is sufficient to wait for the completions
of many callbacks.  Switch to using one instance per a bulk of commands.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 50 +++++++++----------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index fcaa26847c8a..78072bf93f3f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -125,7 +125,7 @@ mlx5e_get_ktls_tx_priv_ctx(struct tls_context *tls_ctx)
 /* struct for callback API management */
 struct mlx5e_async_ctx {
 	struct mlx5_async_work context;
-	struct mlx5_async_ctx async_ctx;
+	struct mlx5_async_ctx *async_ctx;
 	struct mlx5e_ktls_offload_context_tx *priv_tx;
 	int err;
 	union {
@@ -134,33 +134,33 @@ struct mlx5e_async_ctx {
 	};
 };
 
-static struct mlx5e_async_ctx *mlx5e_bulk_async_init(struct mlx5_core_dev *mdev, int n)
+struct mlx5e_bulk_async_ctx {
+	struct mlx5_async_ctx async_ctx;
+	DECLARE_FLEX_ARRAY(struct mlx5e_async_ctx, arr);
+};
+
+static struct mlx5e_bulk_async_ctx *mlx5e_bulk_async_init(struct mlx5_core_dev *mdev, int n)
 {
-	struct mlx5e_async_ctx *bulk_async;
+	struct mlx5e_bulk_async_ctx *bulk_async;
+	int sz;
 	int i;
 
-	bulk_async = kvcalloc(n, sizeof(struct mlx5e_async_ctx), GFP_KERNEL);
+	sz = struct_size(bulk_async, arr, n);
+	bulk_async = kvzalloc(sz, GFP_KERNEL);
 	if (!bulk_async)
 		return NULL;
 
-	for (i = 0; i < n; i++) {
-		struct mlx5e_async_ctx *async = &bulk_async[i];
+	mlx5_cmd_init_async_ctx(mdev, &bulk_async->async_ctx);
 
-		mlx5_cmd_init_async_ctx(mdev, &async->async_ctx);
-	}
+	for (i = 0; i < n; i++)
+		bulk_async->arr[i].async_ctx = &bulk_async->async_ctx;
 
 	return bulk_async;
 }
 
-static void mlx5e_bulk_async_cleanup(struct mlx5e_async_ctx *bulk_async, int n)
+static void mlx5e_bulk_async_cleanup(struct mlx5e_bulk_async_ctx *bulk_async)
 {
-	int i;
-
-	for (i = 0; i < n; i++) {
-		struct mlx5e_async_ctx *async = &bulk_async[i];
-
-		mlx5_cmd_cleanup_async_ctx(&async->async_ctx);
-	}
+	mlx5_cmd_cleanup_async_ctx(&bulk_async->async_ctx);
 	kvfree(bulk_async);
 }
 
@@ -208,7 +208,7 @@ mlx5e_tls_priv_tx_init(struct mlx5_core_dev *mdev, struct mlx5e_tls_sw_stats *sw
 			goto err_out;
 	} else {
 		async->priv_tx = priv_tx;
-		err = mlx5e_ktls_create_tis_cb(mdev, &async->async_ctx,
+		err = mlx5e_ktls_create_tis_cb(mdev, async->async_ctx,
 					       async->out_create, sizeof(async->out_create),
 					       create_tis_callback, &async->context);
 		if (err)
@@ -231,7 +231,7 @@ static void mlx5e_tls_priv_tx_cleanup(struct mlx5e_ktls_offload_context_tx *priv
 	}
 	async->priv_tx = priv_tx;
 	mlx5e_ktls_destroy_tis_cb(priv_tx->mdev, priv_tx->tisn,
-				  &async->async_ctx,
+				  async->async_ctx,
 				  async->out_destroy, sizeof(async->out_destroy),
 				  destroy_tis_callback, &async->context);
 }
@@ -240,7 +240,7 @@ static void mlx5e_tls_priv_tx_list_cleanup(struct mlx5_core_dev *mdev,
 					   struct list_head *list, int size)
 {
 	struct mlx5e_ktls_offload_context_tx *obj, *n;
-	struct mlx5e_async_ctx *bulk_async;
+	struct mlx5e_bulk_async_ctx *bulk_async;
 	int i;
 
 	bulk_async = mlx5e_bulk_async_init(mdev, size);
@@ -249,11 +249,11 @@ static void mlx5e_tls_priv_tx_list_cleanup(struct mlx5_core_dev *mdev,
 
 	i = 0;
 	list_for_each_entry_safe(obj, n, list, list_node) {
-		mlx5e_tls_priv_tx_cleanup(obj, &bulk_async[i]);
+		mlx5e_tls_priv_tx_cleanup(obj, &bulk_async->arr[i]);
 		i++;
 	}
 
-	mlx5e_bulk_async_cleanup(bulk_async, size);
+	mlx5e_bulk_async_cleanup(bulk_async);
 }
 
 /* Recycling pool API */
@@ -279,7 +279,7 @@ static void create_work(struct work_struct *work)
 	struct mlx5e_tls_tx_pool *pool =
 		container_of(work, struct mlx5e_tls_tx_pool, create_work);
 	struct mlx5e_ktls_offload_context_tx *obj;
-	struct mlx5e_async_ctx *bulk_async;
+	struct mlx5e_bulk_async_ctx *bulk_async;
 	LIST_HEAD(local_list);
 	int i, j, err = 0;
 
@@ -288,7 +288,7 @@ static void create_work(struct work_struct *work)
 		return;
 
 	for (i = 0; i < MLX5E_TLS_TX_POOL_BULK; i++) {
-		obj = mlx5e_tls_priv_tx_init(pool->mdev, pool->sw_stats, &bulk_async[i]);
+		obj = mlx5e_tls_priv_tx_init(pool->mdev, pool->sw_stats, &bulk_async->arr[i]);
 		if (IS_ERR(obj)) {
 			err = PTR_ERR(obj);
 			break;
@@ -297,13 +297,13 @@ static void create_work(struct work_struct *work)
 	}
 
 	for (j = 0; j < i; j++) {
-		struct mlx5e_async_ctx *async = &bulk_async[j];
+		struct mlx5e_async_ctx *async = &bulk_async->arr[j];
 
 		if (!err && async->err)
 			err = async->err;
 	}
 	atomic64_add(i, &pool->sw_stats->tx_tls_pool_alloc);
-	mlx5e_bulk_async_cleanup(bulk_async, MLX5E_TLS_TX_POOL_BULK);
+	mlx5e_bulk_async_cleanup(bulk_async);
 	if (err)
 		goto err_out;
 
-- 
2.38.1

