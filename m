Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1E357A852
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 22:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239803AbiGSUgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 16:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239766AbiGSUft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 16:35:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D2A4F64D
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 13:35:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99B69B81D3F
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 20:35:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E9C0C341CF;
        Tue, 19 Jul 2022 20:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658262945;
        bh=Iu0j+mqWZdjgaJGGzTt2fpBjQadjdkEdb46LVb9wAg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T3V0jozQWS94/pZh6gLg4eVoQjVMX5MuBKwrOCvjzz9ENgSM5uw25VBSmrUTkMUM5
         +i66/ZYk+j5e56NBsYyYx/Kn0xr//Q+awtV/vqnnZq8tN1AXD4uzNJ/pdMpiI/kZ5J
         AmgLUtJ/tqYweWadDebBaaSOq4heQKgHy8PD7Bs3f0VlCWCK1FHp+m6CzoWocCua/7
         98SghxVclyRVLhZvFhsAsFQ0+UUF06Jk9hiwc/+oQTTRt9m0w7irCMbGOaZ/tkwivv
         ppYBtVPkWXVvFGTxkXJ5Y9IerVx9gDZaknJSgruJ2H/RUKTFD4ui0Cut1Dag5wCGoG
         GLOZYyMEXTn4A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Aya Levin <ayal@nvidia.com>
Subject: [net-next V2 12/13] net/mlx5e: Add resiliency for PTP TX port timestamp
Date:   Tue, 19 Jul 2022 13:35:28 -0700
Message-Id: <20220719203529.51151-13-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220719203529.51151-1-saeed@kernel.org>
References: <20220719203529.51151-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

PTP TX port timestamp relies on receiving 2 CQEs for each outgoing
packet (WQE). The regular CQE has a less accurate timestamp than the
wire CQE. On link change, the wire CQE may get lost. Let the driver
detect and restore the relation between the CQEs, and re-sync after
timeout.

Add resiliency for this as follows: add id (producer counter)
into the WQE's metadata. This id will be received in the wire
CQE (in wqe_counter field). On handling the wire CQE, if there is no
match, replay the PTP application with the time-stamp from the regular
CQE and restore the sync between the CQEs and their SKBs. This patch
adds 2 ptp counters:
1) ptp_cq0_resync_event: number of times a mismatch was detected between
   the regular CQE and the wire CQE.
2) ptp_cq0_resync_cqe: total amount of missing wire CQEs.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 37 ++++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/en/ptp.h  |  1 +
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  2 +
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  2 +
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 10 +++++
 5 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 047f88f09203..78ad96cf4222 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -79,19 +79,49 @@ void mlx5e_skb_cb_hwtstamp_handler(struct sk_buff *skb, int hwtstamp_type,
 	memset(skb->cb, 0, sizeof(struct mlx5e_skb_cb_hwtstamp));
 }
 
+#define PTP_WQE_CTR2IDX(val) ((val) & ptpsq->ts_cqe_ctr_mask)
+
+static bool mlx5e_ptp_ts_cqe_drop(struct mlx5e_ptpsq *ptpsq, u16 skb_cc, u16 skb_id)
+{
+	return (ptpsq->ts_cqe_ctr_mask && (skb_cc != skb_id));
+}
+
+static void mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_cc, u16 skb_id)
+{
+	struct skb_shared_hwtstamps hwts = {};
+	struct sk_buff *skb;
+
+	ptpsq->cq_stats->resync_event++;
+
+	while (skb_cc != skb_id) {
+		skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
+		hwts.hwtstamp = mlx5e_skb_cb_get_hwts(skb)->cqe_hwtstamp;
+		skb_tstamp_tx(skb, &hwts);
+		ptpsq->cq_stats->resync_cqe++;
+		skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
+	}
+}
+
 static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
 				    struct mlx5_cqe64 *cqe,
 				    int budget)
 {
-	struct sk_buff *skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
+	u16 skb_id = PTP_WQE_CTR2IDX(be16_to_cpu(cqe->wqe_counter));
+	u16 skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
 	struct mlx5e_txqsq *sq = &ptpsq->txqsq;
+	struct sk_buff *skb;
 	ktime_t hwtstamp;
 
 	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
+		skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
 		ptpsq->cq_stats->err_cqe++;
 		goto out;
 	}
 
+	if (mlx5e_ptp_ts_cqe_drop(ptpsq, skb_cc, skb_id))
+		mlx5e_ptp_skb_fifo_ts_cqe_resync(ptpsq, skb_cc, skb_id);
+
+	skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
 	hwtstamp = mlx5e_cqe_ts_to_ns(sq->ptp_cyc2time, sq->clock, get_cqe_ts(cqe));
 	mlx5e_skb_cb_hwtstamp_handler(skb, MLX5E_SKB_CB_PORT_HWTSTAMP,
 				      hwtstamp, ptpsq->cq_stats);
@@ -241,6 +271,7 @@ static void mlx5e_ptp_destroy_sq(struct mlx5_core_dev *mdev, u32 sqn)
 static int mlx5e_ptp_alloc_traffic_db(struct mlx5e_ptpsq *ptpsq, int numa)
 {
 	int wq_sz = mlx5_wq_cyc_get_size(&ptpsq->txqsq.wq);
+	struct mlx5_core_dev *mdev = ptpsq->txqsq.mdev;
 
 	ptpsq->skb_fifo.fifo = kvzalloc_node(array_size(wq_sz, sizeof(*ptpsq->skb_fifo.fifo)),
 					     GFP_KERNEL, numa);
@@ -250,7 +281,9 @@ static int mlx5e_ptp_alloc_traffic_db(struct mlx5e_ptpsq *ptpsq, int numa)
 	ptpsq->skb_fifo.pc   = &ptpsq->skb_fifo_pc;
 	ptpsq->skb_fifo.cc   = &ptpsq->skb_fifo_cc;
 	ptpsq->skb_fifo.mask = wq_sz - 1;
-
+	if (MLX5_CAP_GEN_2(mdev, ts_cqe_metadata_size2wqe_counter))
+		ptpsq->ts_cqe_ctr_mask =
+			(1 << MLX5_CAP_GEN_2(mdev, ts_cqe_metadata_size2wqe_counter)) - 1;
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
index a71a32e00ebb..92dbbec472ec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
@@ -17,6 +17,7 @@ struct mlx5e_ptpsq {
 	u16                      skb_fifo_pc;
 	struct mlx5e_skb_fifo    skb_fifo;
 	struct mlx5e_ptp_cq_stats *cq_stats;
+	u16                      ts_cqe_ctr_mask;
 };
 
 enum {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 1a88406ee6d2..7409829d1201 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -2100,6 +2100,8 @@ static const struct counter_desc ptp_cq_stats_desc[] = {
 	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, err_cqe) },
 	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, abort) },
 	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, abort_abs_diff_ns) },
+	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, resync_cqe) },
+	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, resync_event) },
 };
 
 static const struct counter_desc ptp_rq_stats_desc[] = {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index e48b15b55b6f..ed4fc940e4ef 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -453,6 +453,8 @@ struct mlx5e_ptp_cq_stats {
 	u64 err_cqe;
 	u64 abort;
 	u64 abort_abs_diff_ns;
+	u64 resync_cqe;
+	u64 resync_event;
 };
 
 struct mlx5e_stats {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 699d3a9886bd..dc1e01e93d5a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -631,12 +631,22 @@ void mlx5e_tx_mpwqe_ensure_complete(struct mlx5e_txqsq *sq)
 		mlx5e_tx_mpwqe_session_complete(sq);
 }
 
+static void mlx5e_cqe_ts_id_eseg(struct mlx5e_ptpsq *ptpsq, struct sk_buff *skb,
+				 struct mlx5_wqe_eth_seg *eseg)
+{
+	if (ptpsq->ts_cqe_ctr_mask && unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
+		eseg->flow_table_metadata = cpu_to_be32(ptpsq->skb_fifo_pc &
+							ptpsq->ts_cqe_ctr_mask);
+}
+
 static void mlx5e_txwqe_build_eseg(struct mlx5e_priv *priv, struct mlx5e_txqsq *sq,
 				   struct sk_buff *skb, struct mlx5e_accel_tx_state *accel,
 				   struct mlx5_wqe_eth_seg *eseg, u16 ihs)
 {
 	mlx5e_accel_tx_eseg(priv, skb, eseg, ihs);
 	mlx5e_txwqe_build_eseg_csum(sq, skb, accel, eseg);
+	if (unlikely(sq->ptpsq))
+		mlx5e_cqe_ts_id_eseg(sq->ptpsq, skb, eseg);
 }
 
 netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev)
-- 
2.36.1

