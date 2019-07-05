Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0587A60958
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 17:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbfGEPa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 11:30:57 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52435 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727909AbfGEPav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 11:30:51 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 5 Jul 2019 18:30:42 +0300
Received: from dev-l-vrt-207-011.mtl.labs.mlnx. (dev-l-vrt-207-011.mtl.labs.mlnx [10.134.207.11])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x65FUfOg029656;
        Fri, 5 Jul 2019 18:30:41 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        moshe@mellanox.com, Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH net-next 07/12] net/mlx5e: Tx, Make SQ WQE fetch function type generic
Date:   Fri,  5 Jul 2019 18:30:17 +0300
Message-Id: <1562340622-4423-8-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562340622-4423-1-git-send-email-tariqt@mellanox.com>
References: <1562340622-4423-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change mlx5e_sq_fetch_wqe to be agnostic to the Work Queue
Element (WQE) type.
Before this patch, it was specific for struct mlx5e_tx_wqe.

In order to allow the change, the function now returns the
generic void pointer, and gets the WQE size to do the zero
memset.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h           | 12 +++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c             |  4 ++--
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index bd41f89afef1..1280f4163b53 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -14,15 +14,17 @@
 	return (mlx5_wq_cyc_ctr2ix(wq, cc - pc) >= n) || (cc == pc);
 }
 
-static inline void mlx5e_sq_fetch_wqe(struct mlx5e_txqsq *sq,
-				      struct mlx5e_tx_wqe **wqe,
-				      u16 *pi)
+static inline void *
+mlx5e_sq_fetch_wqe(struct mlx5e_txqsq *sq, size_t size, u16 *pi)
 {
 	struct mlx5_wq_cyc *wq = &sq->wq;
+	void *wqe;
 
 	*pi  = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
-	*wqe = mlx5_wq_cyc_get_wqe(wq, *pi);
-	memset(*wqe, 0, sizeof(**wqe));
+	wqe = mlx5_wq_cyc_get_wqe(wq, *pi);
+	memset(wqe, 0, size);
+
+	return wqe;
 }
 
 static inline struct mlx5e_tx_wqe *
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
index 439bf5953885..7d191d98ac94 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
@@ -248,7 +248,7 @@ static void mlx5e_tls_complete_sync_skb(struct sk_buff *skb,
 	mlx5e_tls_complete_sync_skb(skb, nskb, tcp_seq, headln,
 				    cpu_to_be64(info.rcd_sn));
 	mlx5e_sq_xmit(sq, nskb, *wqe, *pi, true);
-	mlx5e_sq_fetch_wqe(sq, wqe, pi);
+	*wqe = mlx5e_sq_fetch_wqe(sq, sizeof(**wqe), pi);
 	return skb;
 
 err_out:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index b1a163e66053..983ea6206a94 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -335,7 +335,7 @@ netdev_tx_t mlx5e_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 		struct mlx5_wqe_eth_seg cur_eth = wqe->eth;
 #endif
 		mlx5e_fill_sq_frag_edge(sq, wq, pi, contig_wqebbs_room);
-		mlx5e_sq_fetch_wqe(sq, &wqe, &pi);
+		wqe = mlx5e_sq_fetch_wqe(sq, sizeof(*wqe), &pi);
 #ifdef CONFIG_MLX5_EN_IPSEC
 		wqe->eth = cur_eth;
 #endif
@@ -397,7 +397,7 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev)
 	u16 pi;
 
 	sq = priv->txq2sq[skb_get_queue_mapping(skb)];
-	mlx5e_sq_fetch_wqe(sq, &wqe, &pi);
+	wqe = mlx5e_sq_fetch_wqe(sq, sizeof(*wqe), &pi);
 
 	/* might send skbs and update wqe and pi */
 	skb = mlx5e_accel_handle_tx(skb, sq, dev, &wqe, &pi);
-- 
1.8.3.1

