Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE05F419D9F
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 19:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235835AbhI0R4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 13:56:08 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47196 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235703AbhI0R4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 13:56:02 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18RDdiOG024289;
        Mon, 27 Sep 2021 10:54:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=DHBBEooGvH5mJa06izyOUZm5BYym8ojTC3jGrXbdn7U=;
 b=TrfXKj4IRgOZojd/OYnoE6iWiJAy9twKSNkx9wBuBqrW1HIkfsiLlg7o89w8CNAoMV66
 pPth5+NkjELaJzHXV32u/SNBnX9Ezs/scgKeGlKjDD2e1mz7nFtjELooKDkerbAyyKEs
 lY4nzc+S9aIFH/sWIFmNOHOo7ze1C2Mq73mqFilBDWCAntIX3kuf3mFnm77f4kDlbf9z
 ahiP679RJSImFVUg4mSzqtUGkYt7ARcii68ffJg4gewv8Huq1AgJknQ+hz/mSa69qGeX
 MVf3MtAFaiQs/iChJ5/fL+cZLCP/yhxDQwUcKPVtYqA2DO4+8bxIr1qQ+0tOldhAz+Ns wg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bbdj4sb81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 27 Sep 2021 10:54:18 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 27 Sep
 2021 10:54:17 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 27 Sep 2021 10:54:17 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id E57193F70B5;
        Mon, 27 Sep 2021 10:54:14 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <gakula@marvell.com>, <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net-next v2 PATCH] octeontx2-pf: Use hardware register for CQE count
Date:   Mon, 27 Sep 2021 23:24:14 +0530
Message-ID: <20210927175414.14976-1-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 0zWgt3py7TN-rH2p_WugN91RPf7jvjBR
X-Proofpoint-ORIG-GUID: 0zWgt3py7TN-rH2p_WugN91RPf7jvjBR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-27_07,2021-09-24_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current driver uses a software CQ head pointer to poll on CQE
header in memory to determine if CQE is valid. Software needs
to make sure, that the reads of the CQE do not get re-ordered
so much that it ends up with an inconsistent view of the CQE.
To ensure that DMB barrier after reads to first CQE cacheline
and before reading of the rest of the CQE is needed.
But having barrier for every CQE read will impact the performance,
instead use hardware CQ head and tail pointers to find the
valid number of CQEs.

v1-v2:
Fixed compilation warnings.

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
---
 .../marvell/octeontx2/nic/otx2_common.c       |  2 +
 .../marvell/octeontx2/nic/otx2_common.h       |  1 +
 .../marvell/octeontx2/nic/otx2_txrx.c         | 69 +++++++++++++++++--
 .../marvell/octeontx2/nic/otx2_txrx.h         |  5 ++
 include/linux/soc/marvell/octeontx2/asm.h     | 14 ++++
 5 files changed, 84 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 78df173e6df2..b9a9e0a3e7ed 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -1006,6 +1006,8 @@ int otx2_config_nix_queues(struct otx2_nic *pfvf)
 			return err;
 	}
 
+	pfvf->cq_op_addr = (__force u64 *)otx2_get_regaddr(pfvf, NIX_LF_CQ_OP_STATUS);
+
 	/* Initialize work queue for receive buffer refill */
 	pfvf->refill_wrk = devm_kcalloc(pfvf->dev, pfvf->qset.cq_cnt,
 					sizeof(struct refill_work), GFP_KERNEL);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 8e51a1db7e29..ef855dc4123a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -337,6 +337,7 @@ struct otx2_nic {
 #define OTX2_FLAG_TC_MATCHALL_INGRESS_ENABLED	BIT_ULL(13)
 #define OTX2_FLAG_DMACFLTR_SUPPORT		BIT_ULL(14)
 	u64			flags;
+	u64			*cq_op_addr;
 
 	struct otx2_qset	qset;
 	struct otx2_hw		hw;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index f42b1d4e0c67..3f3ec8ffc4dd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -18,6 +18,31 @@
 
 #define CQE_ADDR(CQ, idx) ((CQ)->cqe_base + ((CQ)->cqe_size * (idx)))
 
+static int otx2_nix_cq_op_status(struct otx2_nic *pfvf,
+				 struct otx2_cq_queue *cq)
+{
+	u64 incr = (u64)(cq->cq_idx) << 32;
+	u64 status;
+
+	status = otx2_atomic64_fetch_add(incr, pfvf->cq_op_addr);
+
+	if (unlikely(status & BIT_ULL(CQ_OP_STAT_OP_ERR) ||
+		     status & BIT_ULL(CQ_OP_STAT_CQ_ERR))) {
+		dev_err(pfvf->dev, "CQ stopped due to error");
+		return -EINVAL;
+	}
+
+	cq->cq_tail = status & 0xFFFFF;
+	cq->cq_head = (status >> 20) & 0xFFFFF;
+	if (cq->cq_tail < cq->cq_head)
+		cq->pend_cqe = (cq->cqe_cnt - cq->cq_head) +
+				cq->cq_tail;
+	else
+		cq->pend_cqe = cq->cq_tail - cq->cq_head;
+
+	return 0;
+}
+
 static struct nix_cqe_hdr_s *otx2_get_next_cqe(struct otx2_cq_queue *cq)
 {
 	struct nix_cqe_hdr_s *cqe_hdr;
@@ -318,7 +343,14 @@ static int otx2_rx_napi_handler(struct otx2_nic *pfvf,
 	struct nix_cqe_rx_s *cqe;
 	int processed_cqe = 0;
 
-	while (likely(processed_cqe < budget)) {
+	if (cq->pend_cqe >= budget)
+		goto process_cqe;
+
+	if (otx2_nix_cq_op_status(pfvf, cq) || !cq->pend_cqe)
+		return 0;
+
+process_cqe:
+	while (likely(processed_cqe < budget) && cq->pend_cqe) {
 		cqe = (struct nix_cqe_rx_s *)CQE_ADDR(cq, cq->cq_head);
 		if (cqe->hdr.cqe_type == NIX_XQE_TYPE_INVALID ||
 		    !cqe->sg.seg_addr) {
@@ -334,6 +366,7 @@ static int otx2_rx_napi_handler(struct otx2_nic *pfvf,
 		cqe->hdr.cqe_type = NIX_XQE_TYPE_INVALID;
 		cqe->sg.seg_addr = 0x00;
 		processed_cqe++;
+		cq->pend_cqe--;
 	}
 
 	/* Free CQEs to HW */
@@ -368,7 +401,14 @@ static int otx2_tx_napi_handler(struct otx2_nic *pfvf,
 	struct nix_cqe_tx_s *cqe;
 	int processed_cqe = 0;
 
-	while (likely(processed_cqe < budget)) {
+	if (cq->pend_cqe >= budget)
+		goto process_cqe;
+
+	if (otx2_nix_cq_op_status(pfvf, cq) || !cq->pend_cqe)
+		return 0;
+
+process_cqe:
+	while (likely(processed_cqe < budget) && cq->pend_cqe) {
 		cqe = (struct nix_cqe_tx_s *)otx2_get_next_cqe(cq);
 		if (unlikely(!cqe)) {
 			if (!processed_cqe)
@@ -380,6 +420,7 @@ static int otx2_tx_napi_handler(struct otx2_nic *pfvf,
 
 		cqe->hdr.cqe_type = NIX_XQE_TYPE_INVALID;
 		processed_cqe++;
+		cq->pend_cqe--;
 	}
 
 	/* Free CQEs to HW */
@@ -936,10 +977,16 @@ void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq)
 	int processed_cqe = 0;
 	u64 iova, pa;
 
-	while ((cqe = (struct nix_cqe_rx_s *)otx2_get_next_cqe(cq))) {
-		if (!cqe->sg.subdc)
-			continue;
+	if (otx2_nix_cq_op_status(pfvf, cq) || !cq->pend_cqe)
+		return;
+
+	while (cq->pend_cqe) {
+		cqe = (struct nix_cqe_rx_s *)otx2_get_next_cqe(cq);
 		processed_cqe++;
+		cq->pend_cqe--;
+
+		if (!cqe)
+			continue;
 		if (cqe->sg.segs > 1) {
 			otx2_free_rcv_seg(pfvf, cqe, cq->cq_idx);
 			continue;
@@ -965,7 +1012,16 @@ void otx2_cleanup_tx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq)
 
 	sq = &pfvf->qset.sq[cq->cint_idx];
 
-	while ((cqe = (struct nix_cqe_tx_s *)otx2_get_next_cqe(cq))) {
+	if (otx2_nix_cq_op_status(pfvf, cq) || !cq->pend_cqe)
+		return;
+
+	while (cq->pend_cqe) {
+		cqe = (struct nix_cqe_tx_s *)otx2_get_next_cqe(cq);
+		processed_cqe++;
+		cq->pend_cqe--;
+
+		if (!cqe)
+			continue;
 		sg = &sq->sg[cqe->comp.sqe_id];
 		skb = (struct sk_buff *)sg->skb;
 		if (skb) {
@@ -973,7 +1029,6 @@ void otx2_cleanup_tx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq)
 			dev_kfree_skb_any(skb);
 			sg->skb = (u64)NULL;
 		}
-		processed_cqe++;
 	}
 
 	/* Free CQEs to HW */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
index 3ff1ad79c001..6a97631ff226 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
@@ -56,6 +56,9 @@
  */
 #define CQ_QCOUNT_DEFAULT	1
 
+#define CQ_OP_STAT_OP_ERR       63
+#define CQ_OP_STAT_CQ_ERR       46
+
 struct queue_stats {
 	u64	bytes;
 	u64	pkts;
@@ -122,6 +125,8 @@ struct otx2_cq_queue {
 	u16			pool_ptrs;
 	u32			cqe_cnt;
 	u32			cq_head;
+	u32			cq_tail;
+	u32			pend_cqe;
 	void			*cqe_base;
 	struct qmem		*cqe;
 	struct otx2_pool	*rbpool;
diff --git a/include/linux/soc/marvell/octeontx2/asm.h b/include/linux/soc/marvell/octeontx2/asm.h
index fa1d6af0164e..0f79fd7f81a1 100644
--- a/include/linux/soc/marvell/octeontx2/asm.h
+++ b/include/linux/soc/marvell/octeontx2/asm.h
@@ -34,9 +34,23 @@
 			 : [rf] "+r"(val)		\
 			 : [rs] "r"(addr));		\
 })
+
+static inline u64 otx2_atomic64_fetch_add(u64 incr, u64 *ptr)
+{
+	u64 result;
+
+	asm volatile (".cpu  generic+lse\n"
+		      "ldadda %x[i], %x[r], [%[b]]"
+		      : [r] "=r" (result), "+m" (*ptr)
+		      : [i] "r" (incr), [b] "r" (ptr)
+		      : "memory");
+	return result;
+}
+
 #else
 #define otx2_lmt_flush(ioaddr)          ({ 0; })
 #define cn10k_lmt_flush(val, addr)	({ addr = val; })
+#define otx2_atomic64_fetch_add(incr, ptr)	({ incr; })
 #endif
 
 #endif /* __SOC_OTX2_ASM_H */
-- 
2.17.1

