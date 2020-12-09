Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05FFF2D42AA
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 14:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732016AbgLINFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 08:05:25 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58182 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732005AbgLINFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 08:05:14 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@nvidia.com)
        with SMTP; 9 Dec 2020 15:04:21 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.234.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0B9D4KeK022609;
        Wed, 9 Dec 2020 15:04:21 +0200
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net 2/2] net/mlx4_en: Handle TX error CQE
Date:   Wed,  9 Dec 2020 15:03:39 +0200
Message-Id: <20201209130339.21795-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20201209130339.21795-1-tariqt@nvidia.com>
References: <20201209130339.21795-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>

In case error CQE was found while polling TX CQ, the QP is in error
state and all posted WQEs will generate error CQEs without any data
transmitted. Fix it by reopening the channels, via same method used for
TX timeout handling.

In addition add some more info on error CQE and WQE for debug.

Fixes: bd2f631d7c60 ("net/mlx4_en: Notify user when TX ring in error state")
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |  1 +
 drivers/net/ethernet/mellanox/mlx4/en_tx.c    | 40 +++++++++++++++----
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h  |  5 +++
 3 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 1a2b0bd64aa9..6f290319b617 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -1735,6 +1735,7 @@ int mlx4_en_start_port(struct net_device *dev)
 				mlx4_en_deactivate_cq(priv, cq);
 				goto tx_err;
 			}
+			clear_bit(MLX4_EN_TX_RING_STATE_RECOVERING, &tx_ring->state);
 			if (t != TX_XDP) {
 				tx_ring->tx_queue = netdev_get_tx_queue(dev, i);
 				tx_ring->recycle_ring = NULL;
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index 3ddb7268e415..59b097cda327 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -392,6 +392,35 @@ int mlx4_en_free_tx_buf(struct net_device *dev, struct mlx4_en_tx_ring *ring)
 	return cnt;
 }
 
+static void mlx4_en_handle_err_cqe(struct mlx4_en_priv *priv, struct mlx4_err_cqe *err_cqe,
+				   u16 cqe_index, struct mlx4_en_tx_ring *ring)
+{
+	struct mlx4_en_dev *mdev = priv->mdev;
+	struct mlx4_en_tx_info *tx_info;
+	struct mlx4_en_tx_desc *tx_desc;
+	u16 wqe_index;
+	int desc_size;
+
+	en_err(priv, "CQE error - cqn 0x%x, ci 0x%x, vendor syndrome: 0x%x syndrome: 0x%x\n",
+	       ring->sp_cqn, cqe_index, err_cqe->vendor_err_syndrome, err_cqe->syndrome);
+	print_hex_dump(KERN_WARNING, "", DUMP_PREFIX_OFFSET, 16, 1, err_cqe, sizeof(*err_cqe),
+		       false);
+
+	wqe_index = be16_to_cpu(err_cqe->wqe_index) & ring->size_mask;
+	tx_info = &ring->tx_info[wqe_index];
+	desc_size = tx_info->nr_txbb << LOG_TXBB_SIZE;
+	en_err(priv, "Related WQE - qpn 0x%x, wqe index 0x%x, wqe size 0x%x\n", ring->qpn,
+	       wqe_index, desc_size);
+	tx_desc = ring->buf + (wqe_index << LOG_TXBB_SIZE);
+	print_hex_dump(KERN_WARNING, "", DUMP_PREFIX_OFFSET, 16, 1, tx_desc, desc_size, false);
+
+	if (test_and_set_bit(MLX4_EN_STATE_FLAG_RESTARTING, &priv->state))
+		return;
+
+	en_err(priv, "Scheduling port restart\n");
+	queue_work(mdev->workqueue, &priv->restart_task);
+}
+
 int mlx4_en_process_tx_cq(struct net_device *dev,
 			  struct mlx4_en_cq *cq, int napi_budget)
 {
@@ -438,13 +467,10 @@ int mlx4_en_process_tx_cq(struct net_device *dev,
 		dma_rmb();
 
 		if (unlikely((cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) ==
-			     MLX4_CQE_OPCODE_ERROR)) {
-			struct mlx4_err_cqe *cqe_err = (struct mlx4_err_cqe *)cqe;
-
-			en_err(priv, "CQE error - vendor syndrome: 0x%x syndrome: 0x%x\n",
-			       cqe_err->vendor_err_syndrome,
-			       cqe_err->syndrome);
-		}
+			     MLX4_CQE_OPCODE_ERROR))
+			if (!test_and_set_bit(MLX4_EN_TX_RING_STATE_RECOVERING, &ring->state))
+				mlx4_en_handle_err_cqe(priv, (struct mlx4_err_cqe *)cqe, index,
+						       ring);
 
 		/* Skip over last polled CQE */
 		new_index = be16_to_cpu(cqe->wqe_index) & size_mask;
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
index fd9535bde1b8..30378e4c90b5 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -271,6 +271,10 @@ struct mlx4_en_page_cache {
 	} buf[MLX4_EN_CACHE_SIZE];
 };
 
+enum {
+	MLX4_EN_TX_RING_STATE_RECOVERING,
+};
+
 struct mlx4_en_priv;
 
 struct mlx4_en_tx_ring {
@@ -317,6 +321,7 @@ struct mlx4_en_tx_ring {
 	 * Only queue_stopped might be used if BQL is not properly working.
 	 */
 	unsigned long		queue_stopped;
+	unsigned long		state;
 	struct mlx4_hwq_resources sp_wqres;
 	struct mlx4_qp		sp_qp;
 	struct mlx4_qp_context	sp_context;
-- 
2.21.0

