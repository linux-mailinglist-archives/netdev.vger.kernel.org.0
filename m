Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A54A2D1BB1
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 22:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727700AbgLGVIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 16:08:13 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:45917 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727169AbgLGVHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 16:07:50 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from borisp@mellanox.com)
        with SMTP; 7 Dec 2020 23:06:54 +0200
Received: from gen-l-vrt-133.mtl.labs.mlnx. (gen-l-vrt-133.mtl.labs.mlnx [10.237.11.160])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0B7L6qIN029788;
        Mon, 7 Dec 2020 23:06:54 +0200
From:   Boris Pismenny <borisp@mellanox.com>
To:     kuba@kernel.org, davem@davemloft.net, saeedm@nvidia.com,
        hch@lst.de, sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>
Subject: [PATCH v1 net-next 15/15] net/mlx5e: NVMEoTCP workaround CRC after resync
Date:   Mon,  7 Dec 2020 23:06:49 +0200
Message-Id: <20201207210649.19194-16-borisp@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201207210649.19194-1-borisp@mellanox.com>
References: <20201207210649.19194-1-borisp@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yoray Zack <yorayz@nvidia.com>

The nvme-tcp crc computed over the first packet after resync may provide
the wrong signal when the packet contains multiple PDUs. We workaround
that by ignoring the cqe->nvmeotcp_crc signal for the first packet after
resync.

Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
---
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c         |  1 +
 .../mellanox/mlx5/core/en_accel/nvmeotcp.h         |  3 +++
 .../mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c    | 14 ++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    | 12 ++++--------
 include/linux/mlx5/device.h                        |  4 ++--
 5 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
index 756decf53930..e9f7f8b17c92 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
@@ -844,6 +844,7 @@ mlx5e_nvmeotcp_dev_resync(struct net_device *netdev,
 	struct mlx5e_nvmeotcp_queue *queue =
 				(struct mlx5e_nvmeotcp_queue *)tcp_ddp_get_ctx(sk);
 
+	queue->after_resync_cqe = 1;
 	mlx5e_nvmeotcp_rx_post_static_params_wqe(queue, seq);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
index 5be300d8299e..a309971e11b1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
@@ -50,6 +50,7 @@ struct mlx5e_nvmeotcp_sq {
  *	@ccoff_inner: Current offset within the @ccsglidx element
  *	@priv: mlx5e netdev priv
  *	@inv_done: invalidate callback of the nvme tcp driver
+ *	@after_resync_cqe: indicate if resync occurred
  */
 struct mlx5e_nvmeotcp_queue {
 	struct tcp_ddp_ctx		tcp_ddp_ctx;
@@ -82,6 +83,8 @@ struct mlx5e_nvmeotcp_queue {
 
 	/* for flow_steering flow */
 	struct completion		done;
+	/* for MASK HW resync cqe */
+	bool				after_resync_cqe;
 };
 
 struct mlx5e_nvmeotcp {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c
index 298558ae2dcd..4b813de592be 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c
@@ -175,6 +175,20 @@ mlx5e_nvmeotcp_handle_rx_skb(struct net_device *netdev, struct sk_buff *skb,
 		return skb;
 	}
 
+#ifdef CONFIG_TCP_DDP_CRC
+	/* If a resync occurred in the previous cqe,
+	 * the current cqe.crcvalid bit may not be valid,
+	 * so we will treat it as 0
+	 */
+	skb->ddp_crc = queue->after_resync_cqe ? 0 :
+		cqe_is_nvmeotcp_crcvalid(cqe);
+	queue->after_resync_cqe = 0;
+#endif
+	if (!cqe_is_nvmeotcp_zc(cqe)) {
+		mlx5e_nvmeotcp_put_queue(queue);
+		return skb;
+	}
+
 	stats = priv->channels.c[queue->channel_ix]->rq.stats;
 
 	/* cc ddp from cqe */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 2688396d21f8..960aee0d5f0c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1079,10 +1079,6 @@ static inline void mlx5e_build_rx_skb(struct mlx5_cqe64 *cqe,
 	if (unlikely(mlx5_ipsec_is_rx_flow(cqe)))
 		mlx5e_ipsec_offload_handle_rx_skb(netdev, skb, cqe);
 
-#if defined(CONFIG_TCP_DDP_CRC) && defined(CONFIG_MLX5_EN_NVMEOTCP)
-	skb->ddp_crc = cqe_is_nvmeotcp_crcvalid(cqe);
-#endif
-
 	if (lro_num_seg > 1) {
 		mlx5e_lro_update_hdr(skb, cqe, cqe_bcnt);
 		skb_shinfo(skb)->gso_size = DIV_ROUND_UP(cqe_bcnt, lro_num_seg);
@@ -1197,7 +1193,7 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 	page_ref_inc(di->page);
 
 #if defined(CONFIG_TCP_DDP) && defined(CONFIG_MLX5_EN_NVMEOTCP)
-	if (cqe_is_nvmeotcp_zc_or_resync(cqe))
+	if (cqe_is_nvmeotcp(cqe))
 		skb = mlx5e_nvmeotcp_handle_rx_skb(rq->netdev, skb, cqe,
 						   cqe_bcnt, true);
 #endif
@@ -1253,7 +1249,7 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 	skb->len  += headlen;
 
 #if defined(CONFIG_TCP_DDP) && defined(CONFIG_MLX5_EN_NVMEOTCP)
-	if (cqe_is_nvmeotcp_zc_or_resync(cqe))
+	if (cqe_is_nvmeotcp(cqe))
 		skb = mlx5e_nvmeotcp_handle_rx_skb(rq->netdev, skb, cqe,
 						   cqe_bcnt, false);
 #endif
@@ -1486,7 +1482,7 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *w
 	skb->len  += headlen;
 
 #if defined(CONFIG_TCP_DDP) && defined(CONFIG_MLX5_EN_NVMEOTCP)
-	if (cqe_is_nvmeotcp_zc_or_resync(cqe))
+	if (cqe_is_nvmeotcp(cqe))
 		skb = mlx5e_nvmeotcp_handle_rx_skb(rq->netdev, skb, cqe,
 						   cqe_bcnt, false);
 #endif
@@ -1539,7 +1535,7 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 	page_ref_inc(di->page);
 
 #if defined(CONFIG_TCP_DDP) && defined(CONFIG_MLX5_EN_NVMEOTCP)
-	if (cqe_is_nvmeotcp_zc_or_resync(cqe))
+	if (cqe_is_nvmeotcp(cqe))
 		skb = mlx5e_nvmeotcp_handle_rx_skb(rq->netdev, skb, cqe,
 						   cqe_bcnt, true);
 #endif
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index ea4d158e8329..ae879576e371 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -882,9 +882,9 @@ static inline bool cqe_is_nvmeotcp_zc(struct mlx5_cqe64 *cqe)
 	return ((cqe->nvmetcp >> 4) & 0x1);
 }
 
-static inline bool cqe_is_nvmeotcp_zc_or_resync(struct mlx5_cqe64 *cqe)
+static inline bool cqe_is_nvmeotcp(struct mlx5_cqe64 *cqe)
 {
-	return ((cqe->nvmetcp >> 4) & 0x5);
+	return ((cqe->nvmetcp >> 4) & 0x7);
 }
 
 static inline u8 mlx5_get_cqe_format(struct mlx5_cqe64 *cqe)
-- 
2.24.1

