Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C05E42B3515
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 14:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbgKONnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 08:43:19 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:41358 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726789AbgKONnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 08:43:18 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@nvidia.com)
        with SMTP; 15 Nov 2020 15:43:14 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.234.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0AFDhDYQ028844;
        Sun, 15 Nov 2020 15:43:13 +0200
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Boris Pismenny <borisp@nvidia.com>
Subject: [PATCH net-next 1/2] net/tls: Add real_dev field to TLS context
Date:   Sun, 15 Nov 2020 15:42:50 +0200
Message-Id: <20201115134251.4272-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20201115134251.4272-1-tariqt@nvidia.com>
References: <20201115134251.4272-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Save the real device for the TLS context.
Upper devices that support TLS offload should init real_dev
to point to the slave dev in tls_dev_add().
Lower device drivers should work only against real_dev.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@nvidia.com>
---
 drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c    | 2 +-
 include/net/tls.h                                              | 1 +
 net/tls/tls_device.c                                           | 2 ++
 net/tls/tls_device_fallback.c                                  | 2 +-
 5 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index c24485c0d512..d70839f2f267 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -1987,7 +1987,7 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 	mss = skb_is_gso(skb) ? skb_shinfo(skb)->gso_size : data_len;
 
 	tls_ctx = tls_get_ctx(skb->sk);
-	if (unlikely(tls_ctx->netdev != dev))
+	if (unlikely(tls_ctx->real_dev != dev))
 		goto out;
 
 	tx_ctx = chcr_get_ktls_tx_context(tls_ctx);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
index f51c04284e4d..7f912ba18948 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
@@ -273,7 +273,7 @@ bool mlx5e_tls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 	mlx5e_tx_mpwqe_ensure_complete(sq);
 
 	tls_ctx = tls_get_ctx(skb->sk);
-	if (WARN_ON_ONCE(tls_ctx->netdev != netdev))
+	if (WARN_ON_ONCE(tls_ctx->real_dev != netdev))
 		goto err_out;
 
 	if (mlx5_accel_is_ktls_tx(sq->channel->mdev))
diff --git a/include/net/tls.h b/include/net/tls.h
index baf1e99d8193..3f37443ac7e6 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -241,6 +241,7 @@ struct tls_context {
 	void *priv_ctx_rx;
 
 	struct net_device *netdev;
+	struct net_device *real_dev;
 
 	/* rw cache line */
 	struct cipher_context tx;
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index cec86229a6a0..f97a8aaacf14 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -970,6 +970,8 @@ static void tls_device_attach(struct tls_context *ctx, struct sock *sk,
 		refcount_set(&ctx->refcount, 1);
 		dev_hold(netdev);
 		ctx->netdev = netdev;
+		if (!ctx->real_dev)
+			ctx->real_dev = netdev;
 		spin_lock_irq(&tls_device_lock);
 		list_add_tail(&ctx->list, &tls_device_list);
 		spin_unlock_irq(&tls_device_lock);
diff --git a/net/tls/tls_device_fallback.c b/net/tls/tls_device_fallback.c
index 28895333701e..516db5ff41ee 100644
--- a/net/tls/tls_device_fallback.c
+++ b/net/tls/tls_device_fallback.c
@@ -423,7 +423,7 @@ struct sk_buff *tls_validate_xmit_skb(struct sock *sk,
 				      struct net_device *dev,
 				      struct sk_buff *skb)
 {
-	if (dev == tls_get_ctx(sk)->netdev)
+	if (dev == tls_get_ctx(sk)->netdev || dev == tls_get_ctx(sk)->real_dev)
 		return skb;
 
 	return tls_sw_fallback(sk, skb);
-- 
2.21.0

