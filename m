Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74783252F08
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 14:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730056AbgHZMyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 08:54:36 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:44436 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729999AbgHZMya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 08:54:30 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@mellanox.com)
        with SMTP; 26 Aug 2020 15:54:21 +0300
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.234.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 07QCsLG4003731;
        Wed, 26 Aug 2020 15:54:21 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH net-next 2/3] net/mlx5e: RX, Add a prefetch command for small L1_CACHE_BYTES
Date:   Wed, 26 Aug 2020 15:54:17 +0300
Message-Id: <20200826125418.11379-3-tariqt@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200826125418.11379-1-tariqt@mellanox.com>
References: <20200826125418.11379-1-tariqt@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A single cacheline might not contain the packet header for
small L1_CACHE_BYTES values.
Use net_prefetch() as it issues an additional prefetch
in this case.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c    |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c     | 13 ++++++-------
 .../net/ethernet/mellanox/mlx5/core/en_selftest.c   |  3 +--
 4 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 0e6946fc121f..4bcb73a5522f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -201,7 +201,7 @@ static void mlx5e_xdp_mpwqe_session_start(struct mlx5e_xdpsq *sq)
 	pi = mlx5e_xdpsq_get_next_pi(sq, MLX5_SEND_WQE_MAX_WQEBBS);
 	session->wqe = MLX5E_TX_FETCH_WQE(sq, pi);
 
-	prefetchw(session->wqe->data);
+	net_prefetchw(session->wqe->data);
 	session->ds_count  = MLX5E_XDP_TX_EMPTY_DS_COUNT;
 	session->pkt_count = 0;
 
@@ -322,7 +322,7 @@ mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xdp_xmit_data *xdptxd,
 
 	struct mlx5e_xdpsq_stats *stats = sq->stats;
 
-	prefetchw(wqe);
+	net_prefetchw(wqe);
 
 	if (unlikely(dma_len < MLX5E_XDP_MIN_INLINE || sq->hw_mtu < dma_len)) {
 		stats->err++;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index a33a1f762c70..786fedf52436 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -49,7 +49,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 	xdp->data_end = xdp->data + cqe_bcnt32;
 	xdp_set_data_meta_invalid(xdp);
 	xsk_buff_dma_sync_for_cpu(xdp);
-	prefetch(xdp->data);
+	net_prefetch(xdp->data);
 
 	rcu_read_lock();
 	consumed = mlx5e_xdp_handle(rq, NULL, &cqe_bcnt32, xdp);
@@ -100,7 +100,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
 	xdp->data_end = xdp->data + cqe_bcnt;
 	xdp_set_data_meta_invalid(xdp);
 	xsk_buff_dma_sync_for_cpu(xdp);
-	prefetch(xdp->data);
+	net_prefetch(xdp->data);
 
 	if (unlikely(get_cqe_opcode(cqe) != MLX5_CQE_RESP_SEND)) {
 		rq->stats->wqe_err++;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 65828af120b7..228fd775bcd5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -30,7 +30,6 @@
  * SOFTWARE.
  */
 
-#include <linux/prefetch.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <linux/tcp.h>
@@ -1141,8 +1140,8 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 
 	dma_sync_single_range_for_cpu(rq->pdev, di->addr, wi->offset,
 				      frag_size, DMA_FROM_DEVICE);
-	prefetchw(va); /* xdp_frame data area */
-	prefetch(data);
+	net_prefetchw(va); /* xdp_frame data area */
+	net_prefetch(data);
 
 	rcu_read_lock();
 	mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt, &xdp);
@@ -1184,7 +1183,7 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 		return NULL;
 	}
 
-	prefetchw(skb->data);
+	net_prefetchw(skb->data);
 
 	while (byte_cnt) {
 		u16 frag_consumed_bytes =
@@ -1399,7 +1398,7 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *w
 		return NULL;
 	}
 
-	prefetchw(skb->data);
+	net_prefetchw(skb->data);
 
 	if (unlikely(frag_offset >= PAGE_SIZE)) {
 		di++;
@@ -1452,8 +1451,8 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 
 	dma_sync_single_range_for_cpu(rq->pdev, di->addr, head_offset,
 				      frag_size, DMA_FROM_DEVICE);
-	prefetchw(va); /* xdp_frame data area */
-	prefetch(data);
+	net_prefetchw(va); /* xdp_frame data area */
+	net_prefetch(data);
 
 	rcu_read_lock();
 	mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt32, &xdp);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
index 46790216ce86..ce8ab1f01876 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
@@ -30,7 +30,6 @@
  * SOFTWARE.
  */
 
-#include <linux/prefetch.h>
 #include <linux/ip.h>
 #include <linux/udp.h>
 #include <net/udp.h>
@@ -115,7 +114,7 @@ static struct sk_buff *mlx5e_test_get_udp_skb(struct mlx5e_priv *priv)
 		return NULL;
 	}
 
-	prefetchw(skb->data);
+	net_prefetchw(skb->data);
 	skb_reserve(skb, NET_IP_ALIGN);
 
 	/*  Reserve for ethernet and IP header  */
-- 
2.21.0

