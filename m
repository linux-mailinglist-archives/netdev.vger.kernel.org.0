Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBCC678C92
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 01:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbjAXAJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 19:09:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbjAXAJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 19:09:16 -0500
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA86C1204B
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 16:09:13 -0800 (PST)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 32AC9505269;
        Tue, 24 Jan 2023 03:03:45 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 32AC9505269
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1674518633; bh=WD5i5Etf53ZubeSCT0j9yhr6cXy8ydqz062X8No6mNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fyDg647mXi0XHKUAM5SHQxbiav+Pd8z2bWghZcdp61kEzdrGfVAXHyinZFUCExDSh
         c8eC0uUKL/mq9VWCuFQrLuPIGb1XQu2iKvsVJlra6ncg3hUWYSTJsb2mJFwDp8XFqN
         ZAvd50LyGfHJkl8qpgrIasQLSPeBcr0ZHJZfFoII=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, Gal Pressman <gal@nvidia.com>
Cc:     Vadim Fedorenko <vadfed@meta.com>, netdev@vger.kernel.org
Subject: [PATCH net v2 1/2] mlx5: fix possible ptp queue fifo overflow
Date:   Tue, 24 Jan 2023 03:08:35 +0300
Message-Id: <20230124000836.20523-2-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230124000836.20523-1-vfedorenko@novek.ru>
References: <20230124000836.20523-1-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Fedorenko <vadfed@meta.com>

Fifo pointers are not checked for overflow and this could potentially
lead to overflow and double free under heavy PTP traffic.

Also there were accidental OOO cqe which lead to absolutely broken fifo.
Add checks to workaround OOO cqe and add counters to show the amount of
such events.

Fixes: 58a518948f60 ("net/mlx5e: Add resiliency for PTP TX port timestamp")
Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 28 ++++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  6 +++-
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  2 ++
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  2 ++
 4 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 8469e9c38670..32d6b387af61 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -86,20 +86,31 @@ static bool mlx5e_ptp_ts_cqe_drop(struct mlx5e_ptpsq *ptpsq, u16 skb_cc, u16 skb
 	return (ptpsq->ts_cqe_ctr_mask && (skb_cc != skb_id));
 }
 
-static void mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_cc, u16 skb_id)
+static bool mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_cc, u16 skb_id)
 {
 	struct skb_shared_hwtstamps hwts = {};
 	struct sk_buff *skb;
 
 	ptpsq->cq_stats->resync_event++;
 
-	while (skb_cc != skb_id) {
-		skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
+	if (skb_cc > skb_id || PTP_WQE_CTR2IDX(ptpsq->skb_fifo_pc) < skb_id) {
+		ptpsq->cq_stats->ooo_cqe++;
+		return false;
+	}
+
+	while (skb_cc != skb_id && (skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo))) {
 		hwts.hwtstamp = mlx5e_skb_cb_get_hwts(skb)->cqe_hwtstamp;
 		skb_tstamp_tx(skb, &hwts);
 		ptpsq->cq_stats->resync_cqe++;
 		skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
 	}
+
+	if (!skb) {
+		ptpsq->cq_stats->fifo_empty++;
+		return false;
+	}
+
+	return true;
 }
 
 static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
@@ -109,7 +120,7 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
 	u16 skb_id = PTP_WQE_CTR2IDX(be16_to_cpu(cqe->wqe_counter));
 	u16 skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
 	struct mlx5e_txqsq *sq = &ptpsq->txqsq;
-	struct sk_buff *skb;
+	struct sk_buff *skb = NULL;
 	ktime_t hwtstamp;
 
 	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
@@ -118,8 +129,10 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
 		goto out;
 	}
 
-	if (mlx5e_ptp_ts_cqe_drop(ptpsq, skb_cc, skb_id))
-		mlx5e_ptp_skb_fifo_ts_cqe_resync(ptpsq, skb_cc, skb_id);
+	if (mlx5e_ptp_ts_cqe_drop(ptpsq, skb_cc, skb_id) &&
+	    !mlx5e_ptp_skb_fifo_ts_cqe_resync(ptpsq, skb_cc, skb_id)) {
+		goto out;
+	}
 
 	skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
 	hwtstamp = mlx5e_cqe_ts_to_ns(sq->ptp_cyc2time, sq->clock, get_cqe_ts(cqe));
@@ -128,7 +141,8 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
 	ptpsq->cq_stats->cqe++;
 
 out:
-	napi_consume_skb(skb, budget);
+	if (skb)
+		napi_consume_skb(skb, budget);
 }
 
 static bool mlx5e_ptp_poll_ts_cq(struct mlx5e_cq *cq, int budget)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 853f312cd757..5fb58764c923 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -81,7 +81,7 @@ void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq);
 static inline bool
 mlx5e_skb_fifo_has_room(struct mlx5e_skb_fifo *fifo)
 {
-	return (*fifo->pc - *fifo->cc) < fifo->mask;
+	return (u16)(*fifo->pc - *fifo->cc) < fifo->mask;
 }
 
 static inline bool
@@ -291,12 +291,16 @@ void mlx5e_skb_fifo_push(struct mlx5e_skb_fifo *fifo, struct sk_buff *skb)
 {
 	struct sk_buff **skb_item = mlx5e_skb_fifo_get(fifo, (*fifo->pc)++);
 
+	WARN_ONCE((u16)(*fifo->pc - *fifo->cc) > fifo->mask, "ptp fifo overflow");
 	*skb_item = skb;
 }
 
 static inline
 struct sk_buff *mlx5e_skb_fifo_pop(struct mlx5e_skb_fifo *fifo)
 {
+	if (*fifo->pc == *fifo->cc)
+		return NULL;
+
 	return *mlx5e_skb_fifo_get(fifo, (*fifo->cc)++);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 6687b8136e44..6fbd58d1722a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -2138,6 +2138,8 @@ static const struct counter_desc ptp_cq_stats_desc[] = {
 	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, abort_abs_diff_ns) },
 	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, resync_cqe) },
 	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, resync_event) },
+	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, ooo_cqe) },
+	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, fifo_empty) },
 };
 
 static const struct counter_desc ptp_rq_stats_desc[] = {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 375752d6546d..51da492169c2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -461,6 +461,8 @@ struct mlx5e_ptp_cq_stats {
 	u64 abort_abs_diff_ns;
 	u64 resync_cqe;
 	u64 resync_event;
+	u64 ooo_cqe;
+	u64 fifo_empty;
 };
 
 struct mlx5e_rep_stats {
-- 
2.27.0

