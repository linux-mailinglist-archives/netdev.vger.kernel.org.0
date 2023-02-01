Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30A736865EA
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 13:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbjBAM0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 07:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbjBAM03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 07:26:29 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC1A45BFD
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 04:26:28 -0800 (PST)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 311BI7pq024511;
        Wed, 1 Feb 2023 04:26:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=tnR2jpO7VOjos0yf0JmzZLC8O+dwPJC7f5kQwMMPHug=;
 b=gwKWcnAZSA2CJmW1z9EBzNNx2qUs1t3ob1XCzXu6aAOmx8mKuYR9ORwouEyIZxQSTA8i
 uYIMKNXjvvIfbcoGmZPOKUpfokM1o/5srjVvpen+K+2ATdd+WKuRZf4ACUXpbCXukaGM
 jHmXyEcwMSUoPjpMwN+uoVUZhEF5AVm1jcKp77dJtLZbIYKewpYD6uIc37IxNLS/7H0k
 09aTFZDVgi6F5qGi1iAQaKHZoP2Dqp12jkdbNby9nsZcEYGQBgU9iFxOysE7smEYDeLy
 TMlgtfOSxxhXxCQ7vw+g/TfcrwE+rSr9dcXftfSwfFR6GwTlhW8S3uu4n0miPH/5FjfL 4Q== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3nfq328bxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 01 Feb 2023 04:26:19 -0800
Received: from devvm1736.cln0.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server id
 15.1.2507.17; Wed, 1 Feb 2023 04:26:17 -0800
From:   Vadim Fedorenko <vadfed@meta.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        "Tariq Toukan" <ttoukan.linux@gmail.com>,
        Gal Pressman <gal@nvidia.com>,
        "Saeed Mahameed" <saeed@kernel.org>
CC:     Vadim Fedorenko <vadfed@meta.com>, <netdev@vger.kernel.org>
Subject: [PATCH net v4 2/2] mlx5: fix possible ptp queue fifo use-after-free
Date:   Wed, 1 Feb 2023 04:26:05 -0800
Message-ID: <20230201122605.1350664-3-vadfed@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230201122605.1350664-1-vadfed@meta.com>
References: <20230201122605.1350664-1-vadfed@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c0a8:1b::d]
X-Proofpoint-GUID: CUyQc1QT9x8QlsxreANu6mU97nUCbbJf
X-Proofpoint-ORIG-GUID: CUyQc1QT9x8QlsxreANu6mU97nUCbbJf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-01_04,2023-01-31_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fifo indexes were not checked during pop operations and it leads to
potential use-after-free when poping from empty queue. Such case was
possible during re-sync action.

There were out-of-order cqe spotted which lead to drain of the queue and
use-after-free because of lack of fifo pointers check. Special check
is added to avoid resync operation if SKB could not exist in the fifo
because of OOO cqe (skb_id must be between consumer and producer index).

Fixes: 58a518948f60 ("net/mlx5e: Add resiliency for PTP TX port timestamp")
Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 23 ++++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  4 +++-
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index b72de2b520ec..5df726185192 100644
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
+	if (skb_cc > skb_id || PTP_WQE_CTR2IDX(ptpsq->skb_fifo_pc) < skb_id) {
+		mlx5_core_err_rl(ptpsq->txqsq.mdev, "out-of-order ptp cqe\n");
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
index d5afad368a69..e599b86d94b5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -295,13 +295,15 @@ static inline
 void mlx5e_skb_fifo_push(struct mlx5e_skb_fifo *fifo, struct sk_buff *skb)
 {
 	struct sk_buff **skb_item = mlx5e_skb_fifo_get(fifo, (*fifo->pc)++);
-
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
2.30.2

