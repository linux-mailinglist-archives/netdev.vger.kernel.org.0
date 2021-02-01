Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B3830A4F4
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 11:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbhBAKGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 05:06:51 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:60069 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S233029AbhBAKGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 05:06:11 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from borisp@mellanox.com)
        with SMTP; 1 Feb 2021 12:05:14 +0200
Received: from gen-l-vrt-133.mtl.labs.mlnx. (gen-l-vrt-133.mtl.labs.mlnx [10.237.11.160])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 111A5C0D029353;
        Mon, 1 Feb 2021 12:05:14 +0200
From:   Boris Pismenny <borisp@mellanox.com>
To:     dsahern@gmail.com, kuba@kernel.org, davem@davemloft.net,
        saeedm@nvidia.com, hch@lst.de, sagi@grimberg.me, axboe@fb.com,
        kbusch@kernel.org, viro@zeniv.linux.org.uk, edumazet@google.com,
        smalin@marvell.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: [PATCH v3 net-next  20/21] net/mlx5e: NVMEoTCP statistics
Date:   Mon,  1 Feb 2021 12:05:08 +0200
Message-Id: <20210201100509.27351-21-borisp@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210201100509.27351-1-borisp@mellanox.com>
References: <20210201100509.27351-1-borisp@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Ben-Ishay <benishay@nvidia.com>

NVMEoTCP offload statistics includes both control and data path
statistic: counters for ndo, offloaded packets/bytes, dropped packets
and resync operation.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 23 +++++++++++-
 .../mlx5/core/en_accel/nvmeotcp_rxtx.c        | 16 ++++++++
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 37 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en_stats.h    | 24 ++++++++++++
 4 files changed, 98 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
index 4cbd86b9ed42..c42eb14ee081 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
@@ -659,6 +659,11 @@ mlx5e_nvmeotcp_queue_init(struct net_device *netdev,
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5e_nvmeotcp_queue *queue;
 	int max_wqe_sz_cap, queue_id, err;
+	struct mlx5e_rq_stats *stats;
+	u32 channel_ix;
+
+	channel_ix = mlx5e_get_channel_ix_from_io_cpu(priv, config->io_cpu);
+	stats = &priv->channel_stats[channel_ix].rq;
 
 	if (tconfig->type != TCP_DDP_NVME) {
 		err = -EOPNOTSUPP;
@@ -686,8 +691,7 @@ mlx5e_nvmeotcp_queue_init(struct net_device *netdev,
 	queue->id = queue_id;
 	queue->dgst = config->dgst;
 	queue->pda = config->cpda;
-	queue->channel_ix = mlx5e_get_channel_ix_from_io_cpu(priv,
-							     config->io_cpu);
+	queue->channel_ix = channel_ix;
 	queue->size = config->queue_size;
 	max_wqe_sz_cap  = min_t(int, MAX_DS_VALUE * MLX5_SEND_WQE_DS,
 				MLX5_CAP_GEN(mdev, max_wqe_sz_sq) << OCTWORD_SHIFT);
@@ -707,6 +711,7 @@ mlx5e_nvmeotcp_queue_init(struct net_device *netdev,
 	if (err)
 		goto destroy_rx;
 
+	stats->nvmeotcp_queue_init++;
 	write_lock_bh(&sk->sk_callback_lock);
 	tcp_ddp_set_ctx(sk, queue);
 	write_unlock_bh(&sk->sk_callback_lock);
@@ -721,6 +726,7 @@ mlx5e_nvmeotcp_queue_init(struct net_device *netdev,
 free_queue:
 	kfree(queue);
 out:
+	stats->nvmeotcp_queue_init_fail++;
 	return err;
 }
 
@@ -731,11 +737,15 @@ mlx5e_nvmeotcp_queue_teardown(struct net_device *netdev,
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5e_nvmeotcp_queue *queue;
+	struct mlx5e_rq_stats *stats;
 
 	queue = container_of(tcp_ddp_get_ctx(sk), struct mlx5e_nvmeotcp_queue, tcp_ddp_ctx);
 
 	napi_synchronize(&priv->channels.c[queue->channel_ix]->napi);
 
+	stats = &priv->channel_stats[queue->channel_ix].rq;
+	stats->nvmeotcp_queue_teardown++;
+
 	WARN_ON(refcount_read(&queue->ref_count) != 1);
 	if (queue->zerocopy | queue->crc_rx)
 		mlx5e_nvmeotcp_destroy_rx(queue, mdev, queue->zerocopy);
@@ -757,6 +767,7 @@ mlx5e_nvmeotcp_ddp_setup(struct net_device *netdev,
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct scatterlist *sg = ddp->sg_table.sgl;
 	struct mlx5e_nvmeotcp_queue *queue;
+	struct mlx5e_rq_stats *stats;
 	struct mlx5_core_dev *mdev;
 	int i, size = 0, count = 0;
 
@@ -778,6 +789,11 @@ mlx5e_nvmeotcp_ddp_setup(struct net_device *netdev,
 	queue->ccid_table[ddp->command_id].ccid_gen++;
 	queue->ccid_table[ddp->command_id].sgl_length = count;
 
+	stats = &priv->channel_stats[queue->channel_ix].rq;
+	stats->nvmeotcp_ddp_setup++;
+	if (unlikely(mlx5e_nvmeotcp_post_klm_wqe(queue, KLM_UMR, ddp->command_id, count)))
+		stats->nvmeotcp_ddp_setup_fail++;
+
 	return 0;
 }
 
@@ -818,6 +834,7 @@ mlx5e_nvmeotcp_ddp_teardown(struct net_device *netdev,
 	struct mlx5e_nvmeotcp_queue *queue;
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct nvmeotcp_queue_entry *q_entry;
+	struct mlx5e_rq_stats *stats;
 
 	queue = container_of(tcp_ddp_get_ctx(sk), struct mlx5e_nvmeotcp_queue, tcp_ddp_ctx);
 	q_entry  = &queue->ccid_table[ddp->command_id];
@@ -827,6 +844,8 @@ mlx5e_nvmeotcp_ddp_teardown(struct net_device *netdev,
 	q_entry->queue = queue;
 
 	mlx5e_nvmeotcp_post_klm_wqe(queue, KLM_UMR, ddp->command_id, 0);
+	stats = &priv->channel_stats[queue->channel_ix].rq;
+	stats->nvmeotcp_ddp_teardown++;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c
index b16fcf051665..158f3798bf0c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c
@@ -10,12 +10,16 @@ static void nvmeotcp_update_resync(struct mlx5e_nvmeotcp_queue *queue,
 				   struct mlx5e_cqe128 *cqe128)
 {
 	const struct tcp_ddp_ulp_ops *ulp_ops;
+	struct mlx5e_rq_stats *stats;
 	u32 seq;
 
 	seq = be32_to_cpu(cqe128->resync_tcp_sn);
 	ulp_ops = inet_csk(queue->sk)->icsk_ulp_ddp_ops;
 	if (ulp_ops && ulp_ops->resync_request)
 		ulp_ops->resync_request(queue->sk, seq, TCP_DDP_RESYNC_REQ);
+
+	stats = queue->priv->channels.c[queue->channel_ix]->rq.stats;
+	stats->nvmeotcp_resync++;
 }
 
 static void mlx5e_nvmeotcp_advance_sgl_iter(struct mlx5e_nvmeotcp_queue *queue)
@@ -50,10 +54,13 @@ mlx5_nvmeotcp_add_tail_nonlinear(struct mlx5e_nvmeotcp_queue *queue,
 				 int org_nr_frags, int frag_index)
 {
 	struct mlx5e_priv *priv = queue->priv;
+	struct mlx5e_rq_stats *stats;
 
 	while (org_nr_frags != frag_index) {
 		if (skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS) {
 			dev_kfree_skb_any(skb);
+			stats = priv->channels.c[queue->channel_ix]->rq.stats;
+			stats->nvmeotcp_drop++;
 			return NULL;
 		}
 		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
@@ -72,9 +79,12 @@ mlx5_nvmeotcp_add_tail(struct mlx5e_nvmeotcp_queue *queue, struct sk_buff *skb,
 		       int offset, int len)
 {
 	struct mlx5e_priv *priv = queue->priv;
+	struct mlx5e_rq_stats *stats;
 
 	if (skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS) {
 		dev_kfree_skb_any(skb);
+		stats = priv->channels.c[queue->channel_ix]->rq.stats;
+		stats->nvmeotcp_drop++;
 		return NULL;
 	}
 	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
@@ -135,6 +145,7 @@ mlx5e_nvmeotcp_handle_rx_skb(struct net_device *netdev, struct sk_buff *skb,
 	skb_frag_t org_frags[MAX_SKB_FRAGS];
 	struct mlx5e_nvmeotcp_queue *queue;
 	struct nvmeotcp_queue_entry *nqe;
+	struct mlx5e_rq_stats *stats;
 	int org_nr_frags, frag_index;
 	struct mlx5e_cqe128 *cqe128;
 	u32 queue_id;
@@ -172,6 +183,8 @@ mlx5e_nvmeotcp_handle_rx_skb(struct net_device *netdev, struct sk_buff *skb,
 		return skb;
 	}
 
+	stats = priv->channels.c[queue->channel_ix]->rq.stats;
+
 	/* cc ddp from cqe */
 	ccid = be16_to_cpu(cqe128->ccid);
 	ccoff = be32_to_cpu(cqe128->ccoff);
@@ -214,6 +227,7 @@ mlx5e_nvmeotcp_handle_rx_skb(struct net_device *netdev, struct sk_buff *skb,
 	while (to_copy < cclen) {
 		if (skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS) {
 			dev_kfree_skb_any(skb);
+			stats->nvmeotcp_drop++;
 			mlx5e_nvmeotcp_put_queue(queue);
 			return NULL;
 		}
@@ -243,6 +257,8 @@ mlx5e_nvmeotcp_handle_rx_skb(struct net_device *netdev, struct sk_buff *skb,
 							       frag_index);
 	}
 
+	stats->nvmeotcp_offload_packets++;
+	stats->nvmeotcp_offload_bytes += cclen;
 	mlx5e_nvmeotcp_put_queue(queue);
 	return skb;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 92c5b81427b9..353662f3fc5f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -34,6 +34,7 @@
 #include "en.h"
 #include "en_accel/tls.h"
 #include "en_accel/en_accel.h"
+#include "en_accel/nvmeotcp.h"
 
 static unsigned int stats_grps_num(struct mlx5e_priv *priv)
 {
@@ -189,6 +190,18 @@ static const struct counter_desc sw_stats_desc[] = {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_resync_res_ok) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_resync_res_skip) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_err) },
+#endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_queue_init) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_queue_init_fail) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_queue_teardown) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_ddp_setup) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_ddp_setup_fail) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_ddp_teardown) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_drop) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_resync) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_offload_packets) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_offload_bytes) },
 #endif
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, ch_events) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, ch_poll) },
@@ -352,6 +365,18 @@ static void mlx5e_stats_grp_sw_update_stats_rq_stats(struct mlx5e_sw_stats *s,
 	s->rx_tls_resync_res_skip     += rq_stats->tls_resync_res_skip;
 	s->rx_tls_err                 += rq_stats->tls_err;
 #endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	s->rx_nvmeotcp_queue_init      += rq_stats->nvmeotcp_queue_init;
+	s->rx_nvmeotcp_queue_init_fail += rq_stats->nvmeotcp_queue_init_fail;
+	s->rx_nvmeotcp_queue_teardown  += rq_stats->nvmeotcp_queue_teardown;
+	s->rx_nvmeotcp_ddp_setup       += rq_stats->nvmeotcp_ddp_setup;
+	s->rx_nvmeotcp_ddp_setup_fail  += rq_stats->nvmeotcp_ddp_setup_fail;
+	s->rx_nvmeotcp_ddp_teardown    += rq_stats->nvmeotcp_ddp_teardown;
+	s->rx_nvmeotcp_drop            += rq_stats->nvmeotcp_drop;
+	s->rx_nvmeotcp_resync          += rq_stats->nvmeotcp_resync;
+	s->rx_nvmeotcp_offload_packets += rq_stats->nvmeotcp_offload_packets;
+	s->rx_nvmeotcp_offload_bytes   += rq_stats->nvmeotcp_offload_bytes;
+#endif
 }
 
 static void mlx5e_stats_grp_sw_update_stats_ch_stats(struct mlx5e_sw_stats *s,
@@ -1632,6 +1657,18 @@ static const struct counter_desc rq_stats_desc[] = {
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_resync_res_skip) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_err) },
 #endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_queue_init) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_queue_init_fail) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_queue_teardown) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_ddp_setup) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_ddp_setup_fail) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_ddp_teardown) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_drop) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_resync) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_offload_packets) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_offload_bytes) },
+#endif
 };
 
 static const struct counter_desc sq_stats_desc[] = {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 93c41312fb03..674cee2a884d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -181,6 +181,18 @@ struct mlx5e_sw_stats {
 	u64 rx_congst_umr;
 	u64 rx_arfs_err;
 	u64 rx_recover;
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	u64 rx_nvmeotcp_queue_init;
+	u64 rx_nvmeotcp_queue_init_fail;
+	u64 rx_nvmeotcp_queue_teardown;
+	u64 rx_nvmeotcp_ddp_setup;
+	u64 rx_nvmeotcp_ddp_setup_fail;
+	u64 rx_nvmeotcp_ddp_teardown;
+	u64 rx_nvmeotcp_drop;
+	u64 rx_nvmeotcp_resync;
+	u64 rx_nvmeotcp_offload_packets;
+	u64 rx_nvmeotcp_offload_bytes;
+#endif
 	u64 ch_events;
 	u64 ch_poll;
 	u64 ch_arm;
@@ -344,6 +356,18 @@ struct mlx5e_rq_stats {
 	u64 tls_resync_res_skip;
 	u64 tls_err;
 #endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	u64 nvmeotcp_queue_init;
+	u64 nvmeotcp_queue_init_fail;
+	u64 nvmeotcp_queue_teardown;
+	u64 nvmeotcp_ddp_setup;
+	u64 nvmeotcp_ddp_setup_fail;
+	u64 nvmeotcp_ddp_teardown;
+	u64 nvmeotcp_drop;
+	u64 nvmeotcp_resync;
+	u64 nvmeotcp_offload_packets;
+	u64 nvmeotcp_offload_bytes;
+#endif
 };
 
 struct mlx5e_sq_stats {
-- 
2.24.1

