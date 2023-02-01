Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF156865E8
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 13:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbjBAM02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 07:26:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbjBAM01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 07:26:27 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860B246142
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 04:26:26 -0800 (PST)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 311BIfPe005332;
        Wed, 1 Feb 2023 04:26:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=NkifTK+roL0eklMpOA8QqaD+53oLCZHsqpmpnODYbxg=;
 b=eNqe7baEQ5ThISwAGc86pdQ4alzbkfQjoai1nHKUOTt86EvHrNz1h6q5fWRfwrLbV0/1
 SkMAf/473EYrZHsQ0ElC6VlAr/eDL4B98/hx0XLFOiuda3ySJqzgcBriwp/u7JB0N8CI
 Vpe85qK6ZOYThSIhcOUxWnF7y8NxrCVUUWLiocK3frB1AiAG7jGMQOAGwjdubLot6MgG
 0N4AcRcFQhP7s9Yj2g9C+qwtp+Y9ZYe+4Cj1XO/Zi1vq+bqh2j5ojSU2a0R90E8j1jvn
 YVat6lBFqOPJN/+oafs73mr1qk//qUY0z6duY+aTAs3Ew5vGjPebJWUQfBp5nsAC8ld7 Gg== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3nfq3brbvq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 01 Feb 2023 04:26:17 -0800
Received: from devvm1736.cln0.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server id
 15.1.2507.17; Wed, 1 Feb 2023 04:26:15 -0800
From:   Vadim Fedorenko <vadfed@meta.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        "Tariq Toukan" <ttoukan.linux@gmail.com>,
        Gal Pressman <gal@nvidia.com>,
        "Saeed Mahameed" <saeed@kernel.org>
CC:     Vadim Fedorenko <vadfed@meta.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net v4 1/2] mlx5: fix skb leak while fifo resync and push
Date:   Wed, 1 Feb 2023 04:26:04 -0800
Message-ID: <20230201122605.1350664-2-vadfed@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230201122605.1350664-1-vadfed@meta.com>
References: <20230201122605.1350664-1-vadfed@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c0a8:1b::d]
X-Proofpoint-ORIG-GUID: wFXSl2D9V7NLKWbKmhzzxEzyJSVnL4gR
X-Proofpoint-GUID: wFXSl2D9V7NLKWbKmhzzxEzyJSVnL4gR
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

During ptp resync operation SKBs were poped from the fifo but were never
freed neither by napi_consume nor by dev_kfree_skb_any. Add call to
napi_consume_skb to properly free SKBs.

Another leak was happening because mlx5e_skb_fifo_has_room() had an error
in the check. Comparing free running counters works well unless C promotes
the types to something wider than the counter. In this case counters are
u16 but the result of the substraction is promouted to int and it causes
wrong result (negative value) of the check when producer have already
overlapped but consumer haven't yet. Explicit cast to u16 fixes the issue.

Fixes: 58a518948f60 ("net/mlx5e: Add resiliency for PTP TX port timestamp")
Reviewed-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c  | 6 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h | 2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 8469e9c38670..b72de2b520ec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -86,7 +86,8 @@ static bool mlx5e_ptp_ts_cqe_drop(struct mlx5e_ptpsq *ptpsq, u16 skb_cc, u16 skb
 	return (ptpsq->ts_cqe_ctr_mask && (skb_cc != skb_id));
 }
 
-static void mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_cc, u16 skb_id)
+static void mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_cc,
+					     u16 skb_id, int budget)
 {
 	struct skb_shared_hwtstamps hwts = {};
 	struct sk_buff *skb;
@@ -98,6 +99,7 @@ static void mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_
 		hwts.hwtstamp = mlx5e_skb_cb_get_hwts(skb)->cqe_hwtstamp;
 		skb_tstamp_tx(skb, &hwts);
 		ptpsq->cq_stats->resync_cqe++;
+		napi_consume_skb(skb, budget);
 		skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
 	}
 }
@@ -119,7 +121,7 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
 	}
 
 	if (mlx5e_ptp_ts_cqe_drop(ptpsq, skb_cc, skb_id))
-		mlx5e_ptp_skb_fifo_ts_cqe_resync(ptpsq, skb_cc, skb_id);
+		mlx5e_ptp_skb_fifo_ts_cqe_resync(ptpsq, skb_cc, skb_id, budget);
 
 	skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
 	hwtstamp = mlx5e_cqe_ts_to_ns(sq->ptp_cyc2time, sq->clock, get_cqe_ts(cqe));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index c10c6ab2e7bc..d5afad368a69 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -86,7 +86,7 @@ void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq);
 static inline bool
 mlx5e_skb_fifo_has_room(struct mlx5e_skb_fifo *fifo)
 {
-	return (*fifo->pc - *fifo->cc) < fifo->mask;
+	return (u16)(*fifo->pc - *fifo->cc) < fifo->mask;
 }
 
 static inline bool
-- 
2.30.2

