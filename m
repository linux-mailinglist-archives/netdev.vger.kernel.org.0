Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18AA361E9C6
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 04:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbiKGDf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 22:35:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbiKGDf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 22:35:26 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7711C762;
        Sun,  6 Nov 2022 19:35:25 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2A73UUtX028555;
        Sun, 6 Nov 2022 19:35:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=DR7cv5NmhPFvAripd+twDqBFKqdeoleLd3+JjLcWUb0=;
 b=GiPCBlEIHNpc6LucM3CPRN6W8sMXgsIm4czt/CcGaNKLZ+mGonpSCV0D/kvZIOgCxrvm
 Vhw39Cvfk0H1PA1nasLUrgBef52geUUAiCn7WCxPimhGE118324JU8yJzYvU9LjmY+3A
 JVPs+1pMQ++4WVw/zAb4rJVBHXlS+iJjLdMDlfVle1bRrSkfEYKhr7xCBBWejeRhPJzb
 AvfHOjcrVdGVh5UrhapJSVgUBl3IFLQ0ALLhGlbRa3nDBXqHfiSmUtKZZL1aTs2M8X38
 5u7ENIW0XqhqZN2WxU6s2/QTEDuTT4ggWjTHF8bOd/tX5mtBzrlEyOaLkoHCOPWyAHzh Ug== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3kpt63r103-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 06 Nov 2022 19:35:12 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 6 Nov
 2022 19:35:10 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 6 Nov 2022 19:35:10 -0800
Received: from localhost.localdomain (unknown [10.28.36.165])
        by maili.marvell.com (Postfix) with ESMTP id 243B43F7061;
        Sun,  6 Nov 2022 19:35:07 -0800 (PST)
From:   Ratheesh Kannoth <rkannoth@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <sgoutham@marvell.com>, Ratheesh Kannoth <rkannoth@marvell.com>
Subject: [net,v1 PATCH] octeontx2-pf: Fix SQE threshold checking
Date:   Mon, 7 Nov 2022 09:05:05 +0530
Message-ID: <20221107033505.2491464-1-rkannoth@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: es_o02jtiqWfObsKBA9mMpYqogYIKz6x
X-Proofpoint-ORIG-GUID: es_o02jtiqWfObsKBA9mMpYqogYIKz6x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-06_16,2022-11-03_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current way of checking available SQE count which is based on
HW updated SQB count could result in driver submitting an SQE
even before CQE for the previously transmitted SQE at the same
index is processed in NAPI resulting losing SKB pointers,
hence a leak. Fix this by checking a consumer index which
is updated once CQE is processed.

Fixes: 3ca6c4c882a7 ("octeontx2-pf: Add packet transmission support")
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Reviewed-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../marvell/octeontx2/nic/otx2_common.c       |  1 +
 .../marvell/octeontx2/nic/otx2_txrx.c         | 32 +++++++++++--------
 .../marvell/octeontx2/nic/otx2_txrx.h         |  1 +
 3 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 9ac9e6615ae7..9e10e7471b88 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -898,6 +898,7 @@ static int otx2_sq_init(struct otx2_nic *pfvf, u16 qidx, u16 sqb_aura)
 	}
 
 	sq->head = 0;
+	sq->cons_head = 0;
 	sq->sqe_per_sqb = (pfvf->hw.sqb_size / sq->sqe_size) - 1;
 	sq->num_sqbs = (qset->sqe_cnt + sq->sqe_per_sqb) / sq->sqe_per_sqb;
 	/* Set SQE threshold to 10% of total SQEs */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index 5ec11d71bf60..ef10aef3cda0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -441,6 +441,7 @@ static int otx2_tx_napi_handler(struct otx2_nic *pfvf,
 				struct otx2_cq_queue *cq, int budget)
 {
 	int tx_pkts = 0, tx_bytes = 0, qidx;
+	struct otx2_snd_queue *sq;
 	struct nix_cqe_tx_s *cqe;
 	int processed_cqe = 0;
 
@@ -451,6 +452,9 @@ static int otx2_tx_napi_handler(struct otx2_nic *pfvf,
 		return 0;
 
 process_cqe:
+	qidx = cq->cq_idx - pfvf->hw.rx_queues;
+	sq = &pfvf->qset.sq[qidx];
+
 	while (likely(processed_cqe < budget) && cq->pend_cqe) {
 		cqe = (struct nix_cqe_tx_s *)otx2_get_next_cqe(cq);
 		if (unlikely(!cqe)) {
@@ -458,18 +462,20 @@ static int otx2_tx_napi_handler(struct otx2_nic *pfvf,
 				return 0;
 			break;
 		}
+
 		if (cq->cq_type == CQ_XDP) {
-			qidx = cq->cq_idx - pfvf->hw.rx_queues;
-			otx2_xdp_snd_pkt_handler(pfvf, &pfvf->qset.sq[qidx],
-						 cqe);
+			otx2_xdp_snd_pkt_handler(pfvf, sq, cqe);
 		} else {
-			otx2_snd_pkt_handler(pfvf, cq,
-					     &pfvf->qset.sq[cq->cint_idx],
-					     cqe, budget, &tx_pkts, &tx_bytes);
+			otx2_snd_pkt_handler(pfvf, cq, sq, cqe, budget,
+					     &tx_pkts, &tx_bytes);
 		}
+
 		cqe->hdr.cqe_type = NIX_XQE_TYPE_INVALID;
 		processed_cqe++;
 		cq->pend_cqe--;
+
+		sq->cons_head++;
+		sq->cons_head &= (sq->sqe_cnt - 1);
 	}
 
 	/* Free CQEs to HW */
@@ -1072,17 +1078,17 @@ bool otx2_sq_append_skb(struct net_device *netdev, struct otx2_snd_queue *sq,
 {
 	struct netdev_queue *txq = netdev_get_tx_queue(netdev, qidx);
 	struct otx2_nic *pfvf = netdev_priv(netdev);
-	int offset, num_segs, free_sqe;
+	int offset, num_segs, free_desc;
 	struct nix_sqe_hdr_s *sqe_hdr;
 
-	/* Check if there is room for new SQE.
-	 * 'Num of SQBs freed to SQ's pool - SQ's Aura count'
-	 * will give free SQE count.
+	/* Check if there is enough room between producer
+	 * and consumer index.
 	 */
-	free_sqe = (sq->num_sqbs - *sq->aura_fc_addr) * sq->sqe_per_sqb;
+	free_desc = (sq->cons_head - sq->head - 1 + sq->sqe_cnt) & (sq->sqe_cnt - 1);
+	if (free_desc < sq->sqe_thresh)
+		return false;
 
-	if (free_sqe < sq->sqe_thresh ||
-	    free_sqe < otx2_get_sqe_count(pfvf, skb))
+	if (free_desc < otx2_get_sqe_count(pfvf, skb))
 		return false;
 
 	num_segs = skb_shinfo(skb)->nr_frags + 1;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
index fbe62bbfb789..93cac2c2664c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
@@ -79,6 +79,7 @@ struct sg_list {
 struct otx2_snd_queue {
 	u8			aura_id;
 	u16			head;
+	u16			cons_head;
 	u16			sqe_size;
 	u32			sqe_cnt;
 	u16			num_sqbs;
-- 
2.25.1

