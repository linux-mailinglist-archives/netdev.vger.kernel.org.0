Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1F97160342
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 11:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbgBPKBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 05:01:50 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52981 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727668AbgBPKBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 05:01:47 -0500
Received: from Internal Mail-Server by MTLPINE2 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 16 Feb 2020 12:01:39 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 01GA1ce5007834;
        Sun, 16 Feb 2020 12:01:39 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next-mlx5 v3 09/16] net/mlx5e: Rx, Split rep rx mpwqe handler from nic
Date:   Sun, 16 Feb 2020 12:01:29 +0200
Message-Id: <1581847296-19194-10-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1581847296-19194-1-git-send-email-paulb@mellanox.com>
References: <1581847296-19194-1-git-send-email-paulb@mellanox.com>
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
index 7b48cca..ad426e0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1921,7 +1921,7 @@ static unsigned int mlx5e_ul_rep_stats_grps_num(struct mlx5e_priv *priv)
 	.update_rx		= mlx5e_update_rep_rx,
 	.update_stats           = mlx5e_update_ndo_stats,
 	.rx_handlers.handle_rx_cqe       = mlx5e_handle_rx_cqe_rep,
-	.rx_handlers.handle_rx_cqe_mpwqe = mlx5e_handle_rx_cqe_mpwrq,
+	.rx_handlers.handle_rx_cqe_mpwqe = mlx5e_handle_rx_cqe_mpwrq_rep,
 	.max_tc			= 1,
 	.rq_groups		= MLX5E_NUM_RQ_GROUPS(REGULAR),
 	.stats_grps		= mlx5e_rep_stats_grps,
@@ -1941,7 +1941,7 @@ static unsigned int mlx5e_ul_rep_stats_grps_num(struct mlx5e_priv *priv)
 	.update_stats           = mlx5e_update_ndo_stats,
 	.update_carrier	        = mlx5e_update_carrier,
 	.rx_handlers.handle_rx_cqe       = mlx5e_handle_rx_cqe_rep,
-	.rx_handlers.handle_rx_cqe_mpwqe = mlx5e_handle_rx_cqe_mpwrq,
+	.rx_handlers.handle_rx_cqe_mpwqe = mlx5e_handle_rx_cqe_mpwrq_rep,
 	.max_tc			= MLX5E_MAX_NUM_TC,
 	.rq_groups		= MLX5E_NUM_RQ_GROUPS(REGULAR),
 	.stats_grps		= mlx5e_ul_rep_stats_grps,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index 3f756d5..6ff7d90 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -191,6 +191,8 @@ struct mlx5e_rep_sq {
 void mlx5e_remove_sqs_fwd_rules(struct mlx5e_priv *priv);
 
 void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
+void mlx5e_handle_rx_cqe_mpwrq_rep(struct mlx5e_rq *rq,
+				   struct mlx5_cqe64 *cqe);
 
 int mlx5e_rep_encap_entry_attach(struct mlx5e_priv *priv,
 				 struct mlx5e_encap_entry *e);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 1c3ab69..454ce4c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1232,6 +1232,60 @@ void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
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

