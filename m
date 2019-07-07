Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8B1614C8
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 13:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbfGGLx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 07:53:56 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58928 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726102AbfGGLxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 07:53:55 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Jul 2019 14:53:20 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x67BrJM4031039;
        Sun, 7 Jul 2019 14:53:19 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        ayal@mellanox.com, jiri@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>, moshe@mellanox.com,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH net-next 15/16] net/mlx5e: RX, Handle CQE with error at the earliest stage
Date:   Sun,  7 Jul 2019 14:53:07 +0300
Message-Id: <1562500388-16847-16-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
References: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>

Just to be aligned with the MPWQE handlers, handle RX WQE with error
for legacy RQs in the top RX handlers, just before calling skb_from_cqe().

CQE error handling will now be called at the same stage regardless of
the RQ type or netdev mode NIC, Representor, IPoIB, etc ..

This will be useful for down stream patches to improve error CQE
handling.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/health.h    |  2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    | 49 ++++++++++++----------
 2 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
index aa46f7ecae53..435e31ad1cfb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
@@ -6,6 +6,8 @@
 
 #include "en.h"
 
+#define MLX5E_RX_ERR_CQE(cqe) (get_cqe_opcode(cqe) != MLX5_CQE_RESP_SEND)
+
 int mlx5e_reporter_tx_create(struct mlx5e_priv *priv);
 void mlx5e_reporter_tx_destroy(struct mlx5e_priv *priv);
 void mlx5e_reporter_tx_err_cqe(struct mlx5e_txqsq *sq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 4173679254bf..3b730d3436e6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -48,6 +48,7 @@
 #include "lib/clock.h"
 #include "en/xdp.h"
 #include "en/xsk/rx.h"
+#include "en/health.h"
 
 static inline bool mlx5e_rx_hw_stamp(struct hwtstamp_config *config)
 {
@@ -1062,11 +1063,6 @@ struct sk_buff *
 	prefetchw(va); /* xdp_frame data area */
 	prefetch(data);
 
-	if (unlikely(get_cqe_opcode(cqe) != MLX5_CQE_RESP_SEND)) {
-		rq->stats->wqe_err++;
-		return NULL;
-	}
-
 	rcu_read_lock();
 	consumed = mlx5e_xdp_handle(rq, di, va, &rx_headroom, &cqe_bcnt, false);
 	rcu_read_unlock();
@@ -1094,11 +1090,6 @@ struct sk_buff *
 	u16 byte_cnt     = cqe_bcnt - headlen;
 	struct sk_buff *skb;
 
-	if (unlikely(get_cqe_opcode(cqe) != MLX5_CQE_RESP_SEND)) {
-		rq->stats->wqe_err++;
-		return NULL;
-	}
-
 	/* XDP is not supported in this configuration, as incoming packets
 	 * might spread among multiple pages.
 	 */
@@ -1144,6 +1135,11 @@ void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	wi       = get_frag(rq, ci);
 	cqe_bcnt = be32_to_cpu(cqe->byte_cnt);
 
+	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
+		rq->stats->wqe_err++;
+		goto free_wqe;
+	}
+
 	skb = INDIRECT_CALL_2(rq->wqe.skb_from_cqe,
 			      mlx5e_skb_from_cqe_linear,
 			      mlx5e_skb_from_cqe_nonlinear,
@@ -1185,6 +1181,11 @@ void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	wi       = get_frag(rq, ci);
 	cqe_bcnt = be32_to_cpu(cqe->byte_cnt);
 
+	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
+		rq->stats->wqe_err++;
+		goto free_wqe;
+	}
+
 	skb = rq->wqe.skb_from_cqe(rq, cqe, wi, cqe_bcnt);
 	if (!skb) {
 		/* probably for XDP */
@@ -1319,7 +1320,7 @@ void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 
 	wi->consumed_strides += cstrides;
 
-	if (unlikely(get_cqe_opcode(cqe) != MLX5_CQE_RESP_SEND)) {
+	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
 		rq->stats->wqe_err++;
 		goto mpwrq_cqe_out;
 	}
@@ -1495,6 +1496,11 @@ void mlx5i_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	wi       = get_frag(rq, ci);
 	cqe_bcnt = be32_to_cpu(cqe->byte_cnt);
 
+	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
+		rq->stats->wqe_err++;
+		goto wq_free_wqe;
+	}
+
 	skb = INDIRECT_CALL_2(rq->wqe.skb_from_cqe,
 			      mlx5e_skb_from_cqe_linear,
 			      mlx5e_skb_from_cqe_nonlinear,
@@ -1530,26 +1536,27 @@ void mlx5e_ipsec_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	wi       = get_frag(rq, ci);
 	cqe_bcnt = be32_to_cpu(cqe->byte_cnt);
 
+	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
+		rq->stats->wqe_err++;
+		goto wq_free_wqe;
+	}
+
 	skb = INDIRECT_CALL_2(rq->wqe.skb_from_cqe,
 			      mlx5e_skb_from_cqe_linear,
 			      mlx5e_skb_from_cqe_nonlinear,
 			      rq, cqe, wi, cqe_bcnt);
-	if (unlikely(!skb)) {
-		/* a DROP, save the page-reuse checks */
-		mlx5e_free_rx_wqe(rq, wi, true);
-		goto wq_cyc_pop;
-	}
+	if (unlikely(!skb)) /* a DROP, save the page-reuse checks */
+		goto wq_free_wqe;
+
 	skb = mlx5e_ipsec_handle_rx_skb(rq->netdev, skb, &cqe_bcnt);
-	if (unlikely(!skb)) {
-		mlx5e_free_rx_wqe(rq, wi, true);
-		goto wq_cyc_pop;
-	}
+	if (unlikely(!skb))
+		goto wq_free_wqe;
 
 	mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
 	napi_gro_receive(rq->cq.napi, skb);
 
+wq_free_wqe:
 	mlx5e_free_rx_wqe(rq, wi, true);
-wq_cyc_pop:
 	mlx5_wq_cyc_pop(wq);
 }
 
-- 
1.8.3.1

