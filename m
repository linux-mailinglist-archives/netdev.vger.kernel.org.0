Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30F1514572E
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 14:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbgAVNxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 08:53:12 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:41176 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726584AbgAVNxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 08:53:11 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 22 Jan 2020 15:53:05 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 00MDr4fD013119;
        Wed, 22 Jan 2020 15:53:05 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next-mlx5 v2 06/13] net/mlx5e: Rx, Split rep rx mpwqe handler from nic
Date:   Wed, 22 Jan 2020 15:52:51 +0200
Message-Id: <1579701178-24624-7-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1579701178-24624-1-git-send-email-paulb@mellanox.com>
References: <1579701178-24624-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Copy the current rep mpwqe rx handler which is also used by nic
profile. In the next patch, we will add rep specific logic, just
for the rep profile rx handler.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h |  2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c  | 54 ++++++++++++++++++++++++
 3 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 446eb4d..f33b865 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1823,7 +1823,7 @@ static void mlx5e_uplink_rep_disable(struct mlx5e_priv *priv)
 	.update_rx		= mlx5e_update_rep_rx,
 	.update_stats           = mlx5e_rep_update_hw_counters,
 	.rx_handlers.handle_rx_cqe       = mlx5e_handle_rx_cqe_rep,
-	.rx_handlers.handle_rx_cqe_mpwqe = mlx5e_handle_rx_cqe_mpwrq,
+	.rx_handlers.handle_rx_cqe_mpwqe = mlx5e_handle_rx_cqe_mpwrq_rep,
 	.max_tc			= 1,
 	.rq_groups		= MLX5E_NUM_RQ_GROUPS(REGULAR),
 };
@@ -1841,7 +1841,7 @@ static void mlx5e_uplink_rep_disable(struct mlx5e_priv *priv)
 	.update_stats           = mlx5e_uplink_rep_update_hw_counters,
 	.update_carrier	        = mlx5e_update_carrier,
 	.rx_handlers.handle_rx_cqe       = mlx5e_handle_rx_cqe_rep,
-	.rx_handlers.handle_rx_cqe_mpwqe = mlx5e_handle_rx_cqe_mpwrq,
+	.rx_handlers.handle_rx_cqe_mpwqe = mlx5e_handle_rx_cqe_mpwrq_rep,
 	.max_tc			= MLX5E_MAX_NUM_TC,
 	.rq_groups		= MLX5E_NUM_RQ_GROUPS(REGULAR),
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index 31f83c8..5e29141 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -190,6 +190,8 @@ struct mlx5e_rep_sq {
 void mlx5e_remove_sqs_fwd_rules(struct mlx5e_priv *priv);
 
 void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
+void mlx5e_handle_rx_cqe_mpwrq_rep(struct mlx5e_rq *rq,
+				   struct mlx5_cqe64 *cqe);
 
 int mlx5e_rep_encap_entry_attach(struct mlx5e_priv *priv,
 				 struct mlx5e_encap_entry *e);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 9e99601..ad84a55 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1230,6 +1230,60 @@ void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 wq_cyc_pop:
 	mlx5_wq_cyc_pop(wq);
 }
+
+void mlx5e_handle_rx_cqe_mpwrq_rep(struct mlx5e_rq *rq,
+				   struct mlx5_cqe64 *cqe)
+{
+	u16 cstrides       = mpwrq_get_cqe_consumed_strides(cqe);
+	u16 wqe_id         = be16_to_cpu(cqe->wqe_id);
+	struct mlx5e_mpw_info *wi = &rq->mpwqe.info[wqe_id];
+	u16 stride_ix      = mpwrq_get_cqe_stride_index(cqe);
+	u32 wqe_offset     = stride_ix << rq->mpwqe.log_stride_sz;
+	u32 head_offset    = wqe_offset & (PAGE_SIZE - 1);
+	u32 page_idx       = wqe_offset >> PAGE_SHIFT;
+	struct mlx5e_rx_wqe_ll *wqe;
+	struct mlx5_wq_ll *wq;
+	struct sk_buff *skb;
+	u16 cqe_bcnt;
+
+	wi->consumed_strides += cstrides;
+
+	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
+		trigger_report(rq, cqe);
+		rq->stats->wqe_err++;
+		goto mpwrq_cqe_out;
+	}
+
+	if (unlikely(mpwrq_is_filler_cqe(cqe))) {
+		struct mlx5e_rq_stats *stats = rq->stats;
+
+		stats->mpwqe_filler_cqes++;
+		stats->mpwqe_filler_strides += cstrides;
+		goto mpwrq_cqe_out;
+	}
+
+	cqe_bcnt = mpwrq_get_cqe_byte_cnt(cqe);
+
+	skb = INDIRECT_CALL_2(rq->mpwqe.skb_from_cqe_mpwrq,
+			      mlx5e_skb_from_cqe_mpwrq_linear,
+			      mlx5e_skb_from_cqe_mpwrq_nonlinear,
+			      rq, wi, cqe_bcnt, head_offset, page_idx);
+	if (!skb)
+		goto mpwrq_cqe_out;
+
+	mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
+
+	napi_gro_receive(rq->cq.napi, skb);
+
+mpwrq_cqe_out:
+	if (likely(wi->consumed_strides < rq->mpwqe.num_strides))
+		return;
+
+	wq  = &rq->mpwqe.wq;
+	wqe = mlx5_wq_ll_get_wqe(wq, wqe_id);
+	mlx5e_free_rx_mpwqe(rq, wi, true);
+	mlx5_wq_ll_pop(wq, cqe->wqe_id, &wqe->next.next_wqe_index);
+}
 #endif
 
 struct sk_buff *
-- 
1.8.3.1

