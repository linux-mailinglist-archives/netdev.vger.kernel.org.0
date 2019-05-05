Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0F6A13EE1
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 12:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727343AbfEEKgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 06:36:33 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:45853 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726385AbfEEKgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 06:36:33 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 5 May 2019 13:36:26 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x45AaQEV029699;
        Sun, 5 May 2019 13:36:26 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH net-next 2/2] net/mlx5e: RX, Add a prefetch command for small L1_CACHE_BYTES
Date:   Sun,  5 May 2019 13:36:07 +0300
Message-Id: <1557052567-31827-3-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1557052567-31827-1-git-send-email-tariqt@mellanox.com>
References: <1557052567-31827-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A single cacheline might not contain the packet header for
small L1_CACHE_BYTES values.
Issue an additional prefetch in this case.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c      |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c       | 13 ++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c |  3 +--
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 399957104f9d..548a4563e70a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -132,7 +132,7 @@ static void mlx5e_xdp_mpwqe_session_start(struct mlx5e_xdpsq *sq)
 
 	mlx5e_xdpsq_fetch_wqe(sq, &session->wqe);
 
-	prefetchw(session->wqe->data);
+	net_prefetchw(session->wqe->data);
 	session->ds_count  = MLX5E_XDP_TX_EMPTY_DS_COUNT;
 	session->pkt_count = 0;
 	session->complete  = 0;
@@ -235,7 +235,7 @@ static bool mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xdp_info *
 
 	struct mlx5e_xdpsq_stats *stats = sq->stats;
 
-	prefetchw(wqe);
+	net_prefetchw(wqe);
 
 	if (unlikely(dma_len < MLX5E_XDP_MIN_INLINE || sq->hw_mtu < dma_len)) {
 		stats->err++;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 13133e7f088e..9d43ac31e2c5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -30,7 +30,6 @@
  * SOFTWARE.
  */
 
-#include <linux/prefetch.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <linux/tcp.h>
@@ -1007,8 +1006,8 @@ struct sk_buff *
 
 	dma_sync_single_range_for_cpu(rq->pdev, di->addr, wi->offset,
 				      frag_size, DMA_FROM_DEVICE);
-	prefetchw(va); /* xdp_frame data area */
-	prefetch(data);
+	net_prefetchw(va); /* xdp_frame data area */
+	net_prefetch(data);
 
 	if (unlikely(get_cqe_opcode(cqe) != MLX5_CQE_RESP_SEND)) {
 		rq->stats->wqe_err++;
@@ -1057,7 +1056,7 @@ struct sk_buff *
 		return NULL;
 	}
 
-	prefetchw(skb->data);
+	net_prefetchw(skb->data);
 
 	while (byte_cnt) {
 		u16 frag_consumed_bytes =
@@ -1174,7 +1173,7 @@ struct sk_buff *
 		return NULL;
 	}
 
-	prefetchw(skb->data);
+	net_prefetchw(skb->data);
 
 	if (unlikely(frag_offset >= PAGE_SIZE)) {
 		di++;
@@ -1226,8 +1225,8 @@ struct sk_buff *
 
 	dma_sync_single_range_for_cpu(rq->pdev, di->addr, head_offset,
 				      frag_size, DMA_FROM_DEVICE);
-	prefetchw(va); /* xdp_frame data area */
-	prefetch(data);
+	net_prefetchw(va); /* xdp_frame data area */
+	net_prefetch(data);
 
 	rcu_read_lock();
 	consumed = mlx5e_xdp_handle(rq, di, va, &rx_headroom, &cqe_bcnt32);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
index 4382ef85488c..c3a5b4d7bbec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
@@ -30,7 +30,6 @@
  * SOFTWARE.
  */
 
-#include <linux/prefetch.h>
 #include <linux/ip.h>
 #include <linux/udp.h>
 #include <net/udp.h>
@@ -124,7 +123,7 @@ static struct sk_buff *mlx5e_test_get_udp_skb(struct mlx5e_priv *priv)
 		return NULL;
 	}
 
-	prefetchw(skb->data);
+	net_prefetchw(skb->data);
 	skb_reserve(skb, NET_IP_ALIGN);
 
 	/*  Reserve for ethernet and IP header  */
-- 
1.8.3.1

