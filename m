Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87CDE3B4D7E
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 09:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhFZHrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 03:47:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229741AbhFZHrY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Jun 2021 03:47:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 773F86186A;
        Sat, 26 Jun 2021 07:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624693502;
        bh=pZw3ksNBgk3TpykGjInD766lpiusxUZKuFYmYxCJmZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tswB4xu5n/UHLP/BwPGRm/q713kR34eTfqLBi6maxhqGfgowqv0GNFMu+1hVES6hi
         BaLjM50Q+4mUuXTjzRee1NAYfdGlWxyJUoh7lcATa4JfRkX9WCW41xDg05edGEjV4G
         ZWKoHqUA8BNpmM9ZeEIVRRRLW8JkEPoznlWyb2PvKR1RJnuVYH5P+cbMVPYj1xiMjd
         9X30GC08F5/dtUuli2vSKHH1+H/NCK1fLzskfbAcqWsG94/mLVrkNbxsb08gtF6tAg
         nyJxvsR/zOnhesqKi9tWRiN2MDqlyGkOQhZbrvYSMVOS7eicbF9sbP3If7I+NUW1hi
         k6nC7vu/T4i+A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 5/6] net/mlx5e: kTLS, Add stats for number of deleted kTLS TX offloaded connections
Date:   Sat, 26 Jun 2021 00:44:16 -0700
Message-Id: <20210626074417.714833-6-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210626074417.714833-1-saeed@kernel.org>
References: <20210626074417.714833-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Expose ethtool SW counter for the number of kTLS device-offloaded
TX connections that are finished and deleted.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c   | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h       | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_stats.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 2c0a9344338a..9ad3459fb63a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -138,6 +138,7 @@ void mlx5e_ktls_del_tx(struct net_device *netdev, struct tls_context *tls_ctx)
 	priv = netdev_priv(netdev);
 	mdev = priv->mdev;
 
+	atomic64_inc(&priv_tx->sw_stats->tx_tls_del);
 	mlx5e_destroy_tis(mdev, priv_tx->tisn);
 	mlx5_ktls_destroy_key(mdev, priv_tx->key_id);
 	kfree(priv_tx);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
index 3fd6fd69bbd0..62ecf14bf86a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
@@ -42,6 +42,7 @@
 
 struct mlx5e_tls_sw_stats {
 	atomic64_t tx_tls_ctx;
+	atomic64_t tx_tls_del;
 	atomic64_t tx_tls_drop_metadata;
 	atomic64_t tx_tls_drop_resync_alloc;
 	atomic64_t tx_tls_drop_no_sync_data;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_stats.c
index ffc84f9b41b0..56e7b2aee85f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_stats.c
@@ -47,6 +47,7 @@ static const struct counter_desc mlx5e_tls_sw_stats_desc[] = {
 
 static const struct counter_desc mlx5e_ktls_sw_stats_desc[] = {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_tls_sw_stats, tx_tls_ctx) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_tls_sw_stats, tx_tls_del) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_tls_sw_stats, rx_tls_ctx) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_tls_sw_stats, rx_tls_del) },
 };
-- 
2.31.1

