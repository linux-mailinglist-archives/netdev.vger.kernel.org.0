Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 576B067C22C
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 02:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236480AbjAZBC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 20:02:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236474AbjAZBCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 20:02:37 -0500
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702B65CFFC
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 17:02:35 -0800 (PST)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 249FA50550B;
        Thu, 26 Jan 2023 03:57:07 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 249FA50550B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1674694633; bh=ZZ/ZmGvLqVhoaGKEaJ/0xM1UQavAEQko8za6zMQvHrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vg4FfR1bYtXYxr+XMRktm/xfkeFzrdHnCdZnSOvivHmdSP+Jp7znl5YvYZm9VbPf/
         wW6BzWPd96lZZb8Ie74muzMyVrtouebs7fQ8WdW/GpzHGh+80HbAAzOAQ5viXFLhNX
         G0sx/+uq0qc7LjV/AyP8f9em9cIKIE7EY9WrBSGs=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, Gal Pressman <gal@nvidia.com>
Cc:     Vadim Fedorenko <vadfed@meta.com>, netdev@vger.kernel.org
Subject: [PATCH net v3 2/2] mlx5: fix possible ptp queue fifo use-after-free
Date:   Thu, 26 Jan 2023 04:02:06 +0300
Message-Id: <20230126010206.13483-3-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230126010206.13483-1-vfedorenko@novek.ru>
References: <20230126010206.13483-1-vfedorenko@novek.ru>
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

Fifo pointers were not checked during push and pop operations and this
could potentially lead to use-after-free or skb leak under heavy PTP
traffic.

Also there were OOO cqe spotted which lead to drain of the queue and
use-after-free because of lack of fifo pointers check. Special check
is added to avoid resync operation if SKB could not exist in the fifo
because of OOO cqe (skb_id must be between consumer and producer index).

Fixes: 58a518948f60 ("net/mlx5e: Add resiliency for PTP TX port timestamp")
Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 23 ++++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  7 +++++-
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index b72de2b520ec..4ac7483dcbcc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -86,7 +86,7 @@ static bool mlx5e_ptp_ts_cqe_drop(struct mlx5e_ptpsq *ptpsq, u16 skb_cc, u16 skb
 	return (ptpsq->ts_cqe_ctr_mask && (skb_cc != skb_id));
 }
 
-static void mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_cc,
+static bool mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_cc,
 					     u16 skb_id, int budget)
 {
 	struct skb_shared_hwtstamps hwts = {};
@@ -94,14 +94,23 @@ static void mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_
 
 	ptpsq->cq_stats->resync_event++;
 
-	while (skb_cc != skb_id) {
-		skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
+	if (skb_cc > skb_id || PTP_WQE_CTR2IDX(ptpsq->skb_fifo_pc) < skb_id)
+		pr_err_ratelimited("mlx5e: out-of-order ptp cqe\n");
+		return false;
+	}
+
+	while (skb_cc != skb_id && (skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo))) {
 		hwts.hwtstamp = mlx5e_skb_cb_get_hwts(skb)->cqe_hwtstamp;
 		skb_tstamp_tx(skb, &hwts);
 		ptpsq->cq_stats->resync_cqe++;
 		napi_consume_skb(skb, budget);
 		skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
 	}
+
+	if (!skb)
+		return false;
+
+	return true;
 }
 
 static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
@@ -111,7 +120,7 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
 	u16 skb_id = PTP_WQE_CTR2IDX(be16_to_cpu(cqe->wqe_counter));
 	u16 skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
 	struct mlx5e_txqsq *sq = &ptpsq->txqsq;
-	struct sk_buff *skb;
+	struct sk_buff *skb = NULL;
 	ktime_t hwtstamp;
 
 	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
@@ -120,8 +129,10 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
 		goto out;
 	}
 
-	if (mlx5e_ptp_ts_cqe_drop(ptpsq, skb_cc, skb_id))
-		mlx5e_ptp_skb_fifo_ts_cqe_resync(ptpsq, skb_cc, skb_id, budget);
+	if (mlx5e_ptp_ts_cqe_drop(ptpsq, skb_cc, skb_id) &&
+	    !mlx5e_ptp_skb_fifo_ts_cqe_resync(ptpsq, skb_cc, skb_id, budget)) {
+		goto out;
+	}
 
 	skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
 	hwtstamp = mlx5e_cqe_ts_to_ns(sq->ptp_cyc2time, sq->clock, get_cqe_ts(cqe));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 15a5a57b47b8..6e559b856afb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -289,14 +289,19 @@ struct sk_buff **mlx5e_skb_fifo_get(struct mlx5e_skb_fifo *fifo, u16 i)
 static inline
 void mlx5e_skb_fifo_push(struct mlx5e_skb_fifo *fifo, struct sk_buff *skb)
 {
-	struct sk_buff **skb_item = mlx5e_skb_fifo_get(fifo, (*fifo->pc)++);
+	struct sk_buff **skb_item;
 
+	WARN_ONCE(mlx5e_skb_fifo_has_room(fifo), "ptp fifo overflow");
+	skb_item = mlx5e_skb_fifo_get(fifo, (*fifo->pc)++);
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
 
-- 
2.27.0

