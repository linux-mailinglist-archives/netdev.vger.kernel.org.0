Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49BD96095E
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 17:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbfGEPbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 11:31:06 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52462 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727917AbfGEPav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 11:30:51 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 5 Jul 2019 18:30:42 +0300
Received: from dev-l-vrt-207-011.mtl.labs.mlnx. (dev-l-vrt-207-011.mtl.labs.mlnx [10.134.207.11])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x65FUfOi029656;
        Fri, 5 Jul 2019 18:30:41 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        moshe@mellanox.com, Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH net-next 09/12] net/mlx5e: Tx, Unconstify SQ stop room
Date:   Fri,  5 Jul 2019 18:30:19 +0300
Message-Id: <1562340622-4423-10-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562340622-4423-1-git-send-email-tariqt@mellanox.com>
References: <1562340622-4423-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use an SQ field for stop_room, and use the larger value only if TLS
is supported.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h | 14 ++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |  5 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c   | 18 ++----------------
 4 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 6e31b7c07f8e..09c43c9f3b4a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -390,6 +390,7 @@ struct mlx5e_txqsq {
 	void __iomem              *uar_map;
 	struct netdev_queue       *txq;
 	u32                        sqn;
+	u16                        stop_room;
 	u8                         min_inline_mode;
 	struct device             *pdev;
 	__be32                     mkey_be;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 1280f4163b53..af6aec717d4e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -6,6 +6,20 @@
 
 #include "en.h"
 
+#define MLX5E_SQ_NOPS_ROOM  MLX5_SEND_WQE_MAX_WQEBBS
+#define MLX5E_SQ_STOP_ROOM (MLX5_SEND_WQE_MAX_WQEBBS +\
+			    MLX5E_SQ_NOPS_ROOM)
+
+#ifndef CONFIG_MLX5_EN_TLS
+#define MLX5E_SQ_TLS_ROOM (0)
+#else
+/* TLS offload requires additional stop_room for:
+ *  - a resync SKB.
+ */
+#define MLX5E_SQ_TLS_ROOM  \
+	(MLX5_SEND_WQE_MAX_WQEBBS)
+#endif
+
 #define INL_HDR_START_SZ (sizeof(((struct mlx5_wqe_eth_seg *)NULL)->inline_hdr.start))
 
 static inline bool
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 0913be65a862..edbedb1c85f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1126,11 +1126,14 @@ static int mlx5e_alloc_txqsq(struct mlx5e_channel *c,
 	sq->uar_map   = mdev->mlx5e_res.bfreg.map;
 	sq->min_inline_mode = params->tx_min_inline_mode;
 	sq->stats     = &c->priv->channel_stats[c->ix].sq[tc];
+	sq->stop_room = MLX5E_SQ_STOP_ROOM;
 	INIT_WORK(&sq->recover_work, mlx5e_tx_err_cqe_work);
 	if (MLX5_IPSEC_DEV(c->priv->mdev))
 		set_bit(MLX5E_SQ_STATE_IPSEC, &sq->state);
-	if (mlx5_accel_is_tls_device(c->priv->mdev))
+	if (mlx5_accel_is_tls_device(c->priv->mdev)) {
 		set_bit(MLX5E_SQ_STATE_TLS, &sq->state);
+		sq->stop_room += MLX5E_SQ_TLS_ROOM;
+	}
 
 	param->wq.db_numa_node = cpu_to_node(c->cpu);
 	err = mlx5_wq_cyc_create(mdev, &param->wq, sqc_wq, wq, &sq->wq_ctrl);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 9740ca51921d..200301d6bac5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -40,19 +40,6 @@
 #include "en_accel/en_accel.h"
 #include "lib/clock.h"
 
-#define MLX5E_SQ_NOPS_ROOM  MLX5_SEND_WQE_MAX_WQEBBS
-
-#ifndef CONFIG_MLX5_EN_TLS
-#define MLX5E_SQ_STOP_ROOM (MLX5_SEND_WQE_MAX_WQEBBS +\
-			    MLX5E_SQ_NOPS_ROOM)
-#else
-/* TLS offload requires MLX5E_SQ_STOP_ROOM to have
- * enough room for a resync SKB, a normal SKB and a NOP
- */
-#define MLX5E_SQ_STOP_ROOM (2 * MLX5_SEND_WQE_MAX_WQEBBS +\
-			    MLX5E_SQ_NOPS_ROOM)
-#endif
-
 static void mlx5e_dma_unmap_wqe_err(struct mlx5e_txqsq *sq, u8 num_dma)
 {
 	int i;
@@ -267,7 +254,7 @@ static inline void mlx5e_insert_vlan(void *start, struct sk_buff *skb, u16 ihs)
 		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 
 	sq->pc += wi->num_wqebbs;
-	if (unlikely(!mlx5e_wqc_has_room_for(wq, sq->cc, sq->pc, MLX5E_SQ_STOP_ROOM))) {
+	if (unlikely(!mlx5e_wqc_has_room_for(wq, sq->cc, sq->pc, sq->stop_room))) {
 		netif_tx_stop_queue(sq->txq);
 		sq->stats->stopped++;
 	}
@@ -528,8 +515,7 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
 	netdev_tx_completed_queue(sq->txq, npkts, nbytes);
 
 	if (netif_tx_queue_stopped(sq->txq) &&
-	    mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc,
-				   MLX5E_SQ_STOP_ROOM) &&
+	    mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, sq->stop_room) &&
 	    !test_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state)) {
 		netif_tx_wake_queue(sq->txq);
 		stats->wake++;
-- 
1.8.3.1

