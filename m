Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 200132B7B6B
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 11:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgKRKek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 05:34:40 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:37664 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725497AbgKRKek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 05:34:40 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@nvidia.com)
        with SMTP; 18 Nov 2020 12:34:36 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.234.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0AIAYa8Q027799;
        Wed, 18 Nov 2020 12:34:36 +0200
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next] net/mlx4_en: Remove unused performance counters
Date:   Wed, 18 Nov 2020 12:34:27 +0200
Message-Id: <20201118103427.4314-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Performance analysis counters are maintained under the MLX4_EN_PERF_STAT
definition, which is never set.
Clean them up, with all related structures and logic.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |  1 -
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  3 ---
 drivers/net/ethernet/mellanox/mlx4/en_tx.c    | 13 -----------
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h  | 22 -------------------
 .../net/ethernet/mellanox/mlx4/mlx4_stats.h   | 18 +--------------
 5 files changed, 1 insertion(+), 56 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 106513f772c3..157f7eef92f1 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2027,7 +2027,6 @@ static void mlx4_en_clear_stats(struct net_device *dev)
 		if (mlx4_en_DUMP_ETH_STATS(mdev, priv->port, 1))
 			en_dbg(HW, priv, "Failed dumping statistics\n");
 
-	memset(&priv->pstats, 0, sizeof(priv->pstats));
 	memset(&priv->pkstats, 0, sizeof(priv->pkstats));
 	memset(&priv->port_stats, 0, sizeof(priv->port_stats));
 	memset(&priv->rx_flowstats, 0, sizeof(priv->rx_flowstats));
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index b0f79a5151cf..55fc33de4ce7 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -914,7 +914,6 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 		wmb(); /* ensure HW sees CQ consumer before we post new buffers */
 		ring->cons = cq->mcq.cons_index;
 	}
-	AVG_PERF_COUNTER(priv->pstats.rx_coal_avg, polled);
 
 	mlx4_en_refill_rx_buffers(priv, ring);
 
@@ -966,8 +965,6 @@ int mlx4_en_poll_rx_cq(struct napi_struct *napi, int budget)
 		/* in case we got here because of !clean_complete */
 		done = budget;
 
-		INC_PERF_COUNTER(priv->pstats.napi_quota);
-
 		cpu_curr = smp_processor_id();
 		idata = irq_desc_get_irq_data(cq->irq_desc);
 		aff = irq_data_get_affinity_mask(idata);
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index 3ddb7268e415..b15ec32758a3 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -864,9 +864,6 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (unlikely(!priv->port_up))
 		goto tx_drop;
 
-	/* fetch ring->cons far ahead before needing it to avoid stall */
-	ring_cons = READ_ONCE(ring->cons);
-
 	real_size = get_real_size(skb, shinfo, dev, &lso_header_size,
 				  &inline_ok, &fragptr);
 	if (unlikely(!real_size))
@@ -898,10 +895,6 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	netdev_txq_bql_enqueue_prefetchw(ring->tx_queue);
 
-	/* Track current inflight packets for performance analysis */
-	AVG_PERF_COUNTER(priv->pstats.inflight_avg,
-			 (u32)(ring->prod - ring_cons - 1));
-
 	/* Packet is good - grab an index and transmit it */
 	index = ring->prod & ring->size_mask;
 	bf_index = ring->prod;
@@ -1012,7 +1005,6 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
 		ring->packets++;
 	}
 	ring->bytes += tx_info->nr_bytes;
-	AVG_PERF_COUNTER(priv->pstats.tx_pktsz_avg, skb->len);
 
 	if (tx_info->inl)
 		build_inline_wqe(tx_desc, skb, shinfo, fragptr);
@@ -1141,10 +1133,6 @@ netdev_tx_t mlx4_en_xmit_frame(struct mlx4_en_rx_ring *rx_ring,
 	index = ring->prod & ring->size_mask;
 	tx_info = &ring->tx_info[index];
 
-	/* Track current inflight packets for performance analysis */
-	AVG_PERF_COUNTER(priv->pstats.inflight_avg,
-			 (u32)(ring->prod - READ_ONCE(ring->cons) - 1));
-
 	tx_desc = ring->buf + (index << LOG_TXBB_SIZE);
 	data = &tx_desc->data;
 
@@ -1169,7 +1157,6 @@ netdev_tx_t mlx4_en_xmit_frame(struct mlx4_en_rx_ring *rx_ring,
 		 cpu_to_be32(MLX4_EN_BIT_DESC_OWN) : 0);
 
 	rx_ring->xdp_tx++;
-	AVG_PERF_COUNTER(priv->pstats.tx_pktsz_avg, length);
 
 	ring->prod += MLX4_EN_XDP_TX_NRTXBB;
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
index a46efe37cfa9..014ce8d3d97b 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -170,27 +170,6 @@
 #define MLX4_EN_LOOPBACK_RETRIES	5
 #define MLX4_EN_LOOPBACK_TIMEOUT	100
 
-#ifdef MLX4_EN_PERF_STAT
-/* Number of samples to 'average' */
-#define AVG_SIZE			128
-#define AVG_FACTOR			1024
-
-#define INC_PERF_COUNTER(cnt)		(++(cnt))
-#define ADD_PERF_COUNTER(cnt, add)	((cnt) += (add))
-#define AVG_PERF_COUNTER(cnt, sample) \
-	((cnt) = ((cnt) * (AVG_SIZE - 1) + (sample) * AVG_FACTOR) / AVG_SIZE)
-#define GET_PERF_COUNTER(cnt)		(cnt)
-#define GET_AVG_PERF_COUNTER(cnt)	((cnt) / AVG_FACTOR)
-
-#else
-
-#define INC_PERF_COUNTER(cnt)		do {} while (0)
-#define ADD_PERF_COUNTER(cnt, add)	do {} while (0)
-#define AVG_PERF_COUNTER(cnt, sample)	do {} while (0)
-#define GET_PERF_COUNTER(cnt)		(0)
-#define GET_AVG_PERF_COUNTER(cnt)	(0)
-#endif /* MLX4_EN_PERF_STAT */
-
 /* Constants for TX flow */
 enum {
 	MAX_INLINE = 104, /* 128 - 16 - 4 - 4 */
@@ -599,7 +578,6 @@ struct mlx4_en_priv {
 	struct work_struct linkstate_task;
 	struct delayed_work stats_task;
 	struct delayed_work service_task;
-	struct mlx4_en_perf_stats pstats;
 	struct mlx4_en_pkt_stats pkstats;
 	struct mlx4_en_counter_stats pf_stats;
 	struct mlx4_en_flow_stats_rx rx_priority_flowstats[MLX4_NUM_PRIORITIES];
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_stats.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_stats.h
index 51d4eaab6a2f..7b51ae8cf759 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_stats.h
@@ -2,12 +2,6 @@
 #ifndef _MLX4_STATS_
 #define _MLX4_STATS_
 
-#ifdef MLX4_EN_PERF_STAT
-#define NUM_PERF_STATS			NUM_PERF_COUNTERS
-#else
-#define NUM_PERF_STATS			0
-#endif
-
 #define NUM_PRIORITIES	9
 #define NUM_PRIORITY_STATS 2
 
@@ -46,16 +40,6 @@ struct mlx4_en_port_stats {
 #define NUM_PORT_STATS		10
 };
 
-struct mlx4_en_perf_stats {
-	u32 tx_poll;
-	u64 tx_pktsz_avg;
-	u32 inflight_avg;
-	u16 tx_coal_avg;
-	u16 rx_coal_avg;
-	u32 napi_quota;
-#define NUM_PERF_COUNTERS		6
-};
-
 struct mlx4_en_xdp_stats {
 	unsigned long rx_xdp_drop;
 	unsigned long rx_xdp_tx;
@@ -135,7 +119,7 @@ enum {
 };
 
 #define NUM_ALL_STATS	(NUM_MAIN_STATS + NUM_PORT_STATS + NUM_PKT_STATS + \
-			 NUM_FLOW_STATS + NUM_PERF_STATS + NUM_PF_STATS + \
+			 NUM_FLOW_STATS + NUM_PF_STATS + \
 			 NUM_XDP_STATS + NUM_PHY_STATS)
 
 #define MLX4_FIND_NETDEV_STAT(n) (offsetof(struct net_device_stats, n) / \
-- 
2.21.0

