Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1E3567706C
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 17:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbjAVQQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 11:16:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbjAVQQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 11:16:20 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2EA1DB8D
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 08:16:19 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30MDNjg1024036;
        Sun, 22 Jan 2023 08:16:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=a4do3w4msQKzzrpGj9DUojhy9U9Okn3nNAdCLLzpfd8=;
 b=F3ejHuEdJM8ittF9brVJ/uzN8GTdZAVZQwDKB9ByRSTXb07XavG0ekMcrCjqn0Tk+1ra
 1Irv6xh56U9sM+G/g5ZGvN2hACqhItpy1xg6HTS8uLicU9ysUnmEDQav8JlKl3r+I5ZZ
 Gu1rDLDbkzRvbnDtsn9DuNOL1hemkv612MIb9g/UfYxigpdTrLQHt5f8rkkQZ3zr2THO
 Voo1Oa3YW3Q9dOV0h8GZFYSI0Wi5r/otXu5LyXLaWlBbCX2vDBtXXHcW+DQV2FwZvFbT
 fNxcc5YEDD3tcVqQItu0kidj3O71WZRnGxrbAcTXMX+rFdGMWnqrsaK2TjO/ZdpgkxHX Xg== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3n8e2438k6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 22 Jan 2023 08:16:14 -0800
Received: from devvm1736.cln0.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server id
 15.1.2375.34; Sun, 22 Jan 2023 08:16:12 -0800
From:   Vadim Fedorenko <vadfed@meta.com>
To:     Aya Levin <ayal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     Vadim Fedorenko <vadfed@meta.com>, <netdev@vger.kernel.org>
Subject: [PATCH net 1/2] mlx5: fix possible ptp queue fifo overflow
Date:   Sun, 22 Jan 2023 08:16:01 -0800
Message-ID: <20230122161602.1958577-2-vadfed@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230122161602.1958577-1-vadfed@meta.com>
References: <20230122161602.1958577-1-vadfed@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c085:108::4]
X-Proofpoint-GUID: wig737f6JiGjSTsXRjPvO7o5a8acPfnK
X-Proofpoint-ORIG-GUID: wig737f6JiGjSTsXRjPvO7o5a8acPfnK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-22_13,2023-01-20_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fifo pointers are not checked for overflow and this could potentially
lead to overflow and double free under heavy PTP traffic.

Also there were accidental OOO cqe which lead to absolutely broken fifo.
Add checks to workaround OOO cqe and add counters to show the amount of
such events.

Fixes: 19b43a432e3e ("net/mlx5e: Extend SKB room check to include PTP-SQ")
Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 28 ++++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  6 +++-
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  2 ++
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  2 ++
 4 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 903de88bab53..11a99e0f00c6 100644
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
index aeed165a2dec..0bd2dd694f04 100644
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
 
+	WARN_ONCE((u16)(*fifo->pc - *fifo->cc) > fifo->mask, "%s overflow", __func__);
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
index 7c5b17c917a5..dffcba42af83 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -2119,6 +2119,8 @@ static const struct counter_desc ptp_cq_stats_desc[] = {
 	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, abort_abs_diff_ns) },
 	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, resync_cqe) },
 	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, resync_event) },
+	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, ooo_cqe) },
+	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, fifo_empty) },
 };
 
 static const struct counter_desc ptp_rq_stats_desc[] = {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index edbf177f3c69..4e58ab49017d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -457,6 +457,8 @@ struct mlx5e_ptp_cq_stats {
 	u64 abort_abs_diff_ns;
 	u64 resync_cqe;
 	u64 resync_event;
+	u64 ooo_cqe;
+	u64 fifo_empty;
 };
 
 struct mlx5e_stats {
-- 
2.30.2

