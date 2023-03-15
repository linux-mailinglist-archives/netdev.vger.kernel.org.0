Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C29B6BC050
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 23:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232946AbjCOW7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 18:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232856AbjCOW7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 18:59:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B0A84839
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 15:58:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2A5DB81F90
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 22:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87CD9C433A0;
        Wed, 15 Mar 2023 22:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678921135;
        bh=aPJKw9kH08JK2uhP8yaXVOLVl6vp5o+5ZoKKRYbhxi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EqR0CCaN/ZO1Zr/1ylcf2Qrhi7U0+v5s6h0ApYC7i/ZQvlzLsU60Pn4nv2VIPQxt4
         xCmOj2RFrEFHEMkNT9RflGOfQCZ9n5C9dd885vytRmFzKOtMxkI0cmnTmm0oqc3hoN
         Ha/B3JCd7HnnLILQa5vzyBIYonbMUMidm+JvT6aszhKVe4sbwnNLyWReWVrW3YvRwy
         lilcAdVHZoXnprVVO8fXwogHa55wLMAUi0qTEcrc+1WyfQWL6I+DyjvPHf5/RcT24i
         9PvE8wYcveK/l/Bhrk+JhO3NHIx4JmdjKnk4zZ8ccU8SOpx/g6WypyWSxgEEDlzuAI
         0O6RmCzFVPGjA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [net V2 08/14] net/mlx5e: kTLS, Fix missing error unwind on unsupported cipher type
Date:   Wed, 15 Mar 2023 15:58:41 -0700
Message-Id: <20230315225847.360083-9-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230315225847.360083-1-saeed@kernel.org>
References: <20230315225847.360083-1-saeed@kernel.org>
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

From: Gal Pressman <gal@nvidia.com>

Do proper error unwinding when adding an unsupported TX/RX cipher type.
Move the switch case prior to key creation so there's less to unwind,
and change the goto label name to describe the action performed instead
of what failed.

Fixes: 4960c414db35 ("net/mlx5e: Support 256 bit keys with kTLS device offload")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ktls_rx.c     | 24 ++++++++++---------
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 22 +++++++++--------
 2 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index 4be770443b0c..9b597cb24598 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -621,15 +621,6 @@ int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
 	if (unlikely(!priv_rx))
 		return -ENOMEM;
 
-	dek = mlx5_ktls_create_key(priv->tls->dek_pool, crypto_info);
-	if (IS_ERR(dek)) {
-		err = PTR_ERR(dek);
-		goto err_create_key;
-	}
-	priv_rx->dek = dek;
-
-	INIT_LIST_HEAD(&priv_rx->list);
-	spin_lock_init(&priv_rx->lock);
 	switch (crypto_info->cipher_type) {
 	case TLS_CIPHER_AES_GCM_128:
 		priv_rx->crypto_info.crypto_info_128 =
@@ -642,9 +633,20 @@ int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
 	default:
 		WARN_ONCE(1, "Unsupported cipher type %u\n",
 			  crypto_info->cipher_type);
-		return -EOPNOTSUPP;
+		err = -EOPNOTSUPP;
+		goto err_cipher_type;
 	}
 
+	dek = mlx5_ktls_create_key(priv->tls->dek_pool, crypto_info);
+	if (IS_ERR(dek)) {
+		err = PTR_ERR(dek);
+		goto err_cipher_type;
+	}
+	priv_rx->dek = dek;
+
+	INIT_LIST_HEAD(&priv_rx->list);
+	spin_lock_init(&priv_rx->lock);
+
 	rxq = mlx5e_ktls_sk_get_rxq(sk);
 	priv_rx->rxq = rxq;
 	priv_rx->sk = sk;
@@ -677,7 +679,7 @@ int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
 	mlx5e_tir_destroy(&priv_rx->tir);
 err_create_tir:
 	mlx5_ktls_destroy_key(priv->tls->dek_pool, priv_rx->dek);
-err_create_key:
+err_cipher_type:
 	kfree(priv_rx);
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 60b3e08a1028..0e4c0a093293 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -469,14 +469,6 @@ int mlx5e_ktls_add_tx(struct net_device *netdev, struct sock *sk,
 	if (IS_ERR(priv_tx))
 		return PTR_ERR(priv_tx);
 
-	dek = mlx5_ktls_create_key(priv->tls->dek_pool, crypto_info);
-	if (IS_ERR(dek)) {
-		err = PTR_ERR(dek);
-		goto err_create_key;
-	}
-	priv_tx->dek = dek;
-
-	priv_tx->expected_seq = start_offload_tcp_sn;
 	switch (crypto_info->cipher_type) {
 	case TLS_CIPHER_AES_GCM_128:
 		priv_tx->crypto_info.crypto_info_128 =
@@ -489,8 +481,18 @@ int mlx5e_ktls_add_tx(struct net_device *netdev, struct sock *sk,
 	default:
 		WARN_ONCE(1, "Unsupported cipher type %u\n",
 			  crypto_info->cipher_type);
-		return -EOPNOTSUPP;
+		err = -EOPNOTSUPP;
+		goto err_pool_push;
 	}
+
+	dek = mlx5_ktls_create_key(priv->tls->dek_pool, crypto_info);
+	if (IS_ERR(dek)) {
+		err = PTR_ERR(dek);
+		goto err_pool_push;
+	}
+
+	priv_tx->dek = dek;
+	priv_tx->expected_seq = start_offload_tcp_sn;
 	priv_tx->tx_ctx = tls_offload_ctx_tx(tls_ctx);
 
 	mlx5e_set_ktls_tx_priv_ctx(tls_ctx, priv_tx);
@@ -500,7 +502,7 @@ int mlx5e_ktls_add_tx(struct net_device *netdev, struct sock *sk,
 
 	return 0;
 
-err_create_key:
+err_pool_push:
 	pool_push(pool, priv_tx);
 	return err;
 }
-- 
2.39.2

