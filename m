Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93D6B6719D5
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 11:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbjARK5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 05:57:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbjARK4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 05:56:47 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819E464DB6;
        Wed, 18 Jan 2023 02:04:44 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30I8Pnv1004277;
        Wed, 18 Jan 2023 02:04:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=n6mxlIqYFzpZ66GiKm7db4/vc1oU+Pp91EZJpckTbAo=;
 b=gwSysHCSq5y2m3FuBpEmZIOyKwzM02lrCDhkORyDQz14BK8eXYxQsXnBfJbMTsiUUJJU
 9mapaxTqaYldVENb8ekDDQI3BABskv1ns6usRYom+MzPDMjN4tOrJeOkRyqTUC828Uep
 hBINPdTe27Il6LRRP+GPQyYOgu9vsprSyGgYixN1pO7F8iPH0GEFU5+3DkKa4Ia6fsfV
 4mEgkkeNLOZRHGAmvX1k2dqSWBYsaMO5FcQS6ADeLWOndHf6QuhizN8vym/KgWy3PBlc
 Ir0PmdgInDbi/WIr0/WlMGdPlZk711QBdIH4OVlIdHaFRDcKvyEkEgt1OIdO6OxmH0uX wg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3n6avbgxc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 02:04:30 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 18 Jan
 2023 02:04:29 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Wed, 18 Jan 2023 02:04:29 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 8AF5E5B6934;
        Wed, 18 Jan 2023 02:04:23 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <saeedm@nvidia.com>, <richardcochran@gmail.com>,
        <maximmi@nvidia.com>, <tariqt@nvidia.com>, <moshet@nvidia.com>,
        <linux-rdma@vger.kernel.org>, <maxtram95@gmail.com>
Subject: [net-next Patch v2 2/5] octeontx2-pf: qos send queues management
Date:   Wed, 18 Jan 2023 15:34:07 +0530
Message-ID: <20230118100410.8834-3-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230118100410.8834-1-hkelam@marvell.com>
References: <20230118100410.8834-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: _SZExJfXG80BMRUibUDi3_YQlst0I-_r
X-Proofpoint-ORIG-GUID: _SZExJfXG80BMRUibUDi3_YQlst0I-_r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_04,2023-01-17_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

Current implementation is such that the number of Send queues (SQs)
are decided on the device probe which is equal to the number of online
cpus. These SQs are allocated and deallocated in interface open and c
lose calls respectively.

This patch defines new APIs for initializing and deinitializing Send
queues dynamically and allocates more number of transmit queues for
QOS feature.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../marvell/octeontx2/af/rvu_debugfs.c        |   5 +
 .../ethernet/marvell/octeontx2/nic/Makefile   |   2 +-
 .../marvell/octeontx2/nic/otx2_common.c       |  35 ++-
 .../marvell/octeontx2/nic/otx2_common.h       |  22 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  42 ++-
 .../marvell/octeontx2/nic/otx2_txrx.c         |  27 +-
 .../marvell/octeontx2/nic/otx2_txrx.h         |   3 +-
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |   4 +-
 .../net/ethernet/marvell/octeontx2/nic/qos.h  |  19 ++
 .../ethernet/marvell/octeontx2/nic/qos_sq.c   | 290 ++++++++++++++++++
 10 files changed, 416 insertions(+), 33 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/qos.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/qos_sq.c

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index fa280ebd3052..53ad8faf1969 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -1224,6 +1224,11 @@ static int rvu_dbg_npa_ctx_display(struct seq_file *m, void *unused, int ctype)
 
 	for (aura = id; aura < max_id; aura++) {
 		aq_req.aura_id = aura;
+
+		/* Skip if queue is uninitialized */
+		if (ctype == NPA_AQ_CTYPE_POOL && !test_bit(aura, pfvf->pool_bmap))
+			continue;
+
 		seq_printf(m, "======%s : %d=======\n",
 			   (ctype == NPA_AQ_CTYPE_AURA) ? "AURA" : "POOL",
 			aq_req.aura_id);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
index 73fdb8798614..3d31ddf7c652 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
@@ -8,7 +8,7 @@ obj-$(CONFIG_OCTEONTX2_VF) += rvu_nicvf.o otx2_ptp.o
 
 rvu_nicpf-y := otx2_pf.o otx2_common.o otx2_txrx.o otx2_ethtool.o \
                otx2_flows.o otx2_tc.o cn10k.o otx2_dmac_flt.o \
-               otx2_devlink.o
+               otx2_devlink.o qos_sq.o
 rvu_nicvf-y := otx2_vf.o otx2_devlink.o
 
 rvu_nicpf-$(CONFIG_DCB) += otx2_dcbnl.o
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 88f8772a61cd..0868ae825736 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -758,11 +758,16 @@ int otx2_txschq_stop(struct otx2_nic *pfvf)
 void otx2_sqb_flush(struct otx2_nic *pfvf)
 {
 	int qidx, sqe_tail, sqe_head;
+	struct otx2_snd_queue *sq;
 	u64 incr, *ptr, val;
 	int timeout = 1000;
 
 	ptr = (u64 *)otx2_get_regaddr(pfvf, NIX_LF_SQ_OP_STATUS);
-	for (qidx = 0; qidx < pfvf->hw.tot_tx_queues; qidx++) {
+	for (qidx = 0; qidx < pfvf->hw.tot_tx_queues + pfvf->hw.tc_tx_queues;
+	     qidx++) {
+		sq = &pfvf->qset.sq[qidx];
+		if (!sq->sqb_ptrs)
+			continue;
 		incr = (u64)qidx << 32;
 		while (timeout) {
 			val = otx2_atomic64_add(incr, ptr);
@@ -862,7 +867,7 @@ int otx2_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura)
 	return otx2_sync_mbox_msg(&pfvf->mbox);
 }
 
-static int otx2_sq_init(struct otx2_nic *pfvf, u16 qidx, u16 sqb_aura)
+int otx2_sq_init(struct otx2_nic *pfvf, u16 qidx, u16 sqb_aura)
 {
 	struct otx2_qset *qset = &pfvf->qset;
 	struct otx2_snd_queue *sq;
@@ -935,9 +940,17 @@ static int otx2_cq_init(struct otx2_nic *pfvf, u16 qidx)
 		cq->cint_idx = qidx - pfvf->hw.rx_queues;
 		cq->cqe_cnt = qset->sqe_cnt;
 	} else {
-		cq->cq_type = CQ_XDP;
-		cq->cint_idx = qidx - non_xdp_queues;
-		cq->cqe_cnt = qset->sqe_cnt;
+		if (pfvf->hw.xdp_queues &&
+		    qidx < non_xdp_queues + pfvf->hw.xdp_queues) {
+			cq->cq_type = CQ_XDP;
+			cq->cint_idx = qidx - non_xdp_queues;
+			cq->cqe_cnt = qset->sqe_cnt;
+		} else {
+			cq->cq_type = CQ_QOS;
+			cq->cint_idx = qidx - non_xdp_queues -
+				       pfvf->hw.xdp_queues;
+			cq->cqe_cnt = qset->sqe_cnt;
+		}
 	}
 	cq->cqe_size = pfvf->qset.xqe_size;
 
@@ -1097,7 +1110,7 @@ int otx2_config_nix(struct otx2_nic *pfvf)
 
 	/* Set RQ/SQ/CQ counts */
 	nixlf->rq_cnt = pfvf->hw.rx_queues;
-	nixlf->sq_cnt = pfvf->hw.tot_tx_queues;
+	nixlf->sq_cnt = pfvf->hw.tot_tx_queues + pfvf->hw.tc_tx_queues;
 	nixlf->cq_cnt = pfvf->qset.cq_cnt;
 	nixlf->rss_sz = MAX_RSS_INDIR_TBL_SIZE;
 	nixlf->rss_grps = MAX_RSS_GROUPS;
@@ -1135,7 +1148,7 @@ void otx2_sq_free_sqbs(struct otx2_nic *pfvf)
 	int sqb, qidx;
 	u64 iova, pa;
 
-	for (qidx = 0; qidx < hw->tot_tx_queues; qidx++) {
+	for (qidx = 0; qidx < hw->tot_tx_queues + hw->tc_tx_queues; qidx++) {
 		sq = &qset->sq[qidx];
 		if (!sq->sqb_ptrs)
 			continue;
@@ -1203,8 +1216,8 @@ void otx2_aura_pool_free(struct otx2_nic *pfvf)
 	pfvf->qset.pool = NULL;
 }
 
-static int otx2_aura_init(struct otx2_nic *pfvf, int aura_id,
-			  int pool_id, int numptrs)
+int otx2_aura_init(struct otx2_nic *pfvf, int aura_id,
+		   int pool_id, int numptrs)
 {
 	struct npa_aq_enq_req *aq;
 	struct otx2_pool *pool;
@@ -1280,8 +1293,8 @@ static int otx2_aura_init(struct otx2_nic *pfvf, int aura_id,
 	return 0;
 }
 
-static int otx2_pool_init(struct otx2_nic *pfvf, u16 pool_id,
-			  int stack_pages, int numptrs, int buf_size)
+int otx2_pool_init(struct otx2_nic *pfvf, u16 pool_id,
+		   int stack_pages, int numptrs, int buf_size)
 {
 	struct npa_aq_enq_req *aq;
 	struct otx2_pool *pool;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 5bee3c3a7ce4..b142cc685a28 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -27,6 +27,7 @@
 #include "otx2_txrx.h"
 #include "otx2_devlink.h"
 #include <rvu_trace.h>
+#include "qos.h"
 
 /* IPv4 flag more fragment bit */
 #define IPV4_FLAG_MORE				0x20
@@ -189,6 +190,7 @@ struct otx2_hw {
 	u16                     rx_queues;
 	u16                     tx_queues;
 	u16                     xdp_queues;
+	u16			tc_tx_queues;
 	u16                     tot_tx_queues;
 	u16			max_queues;
 	u16			pool_cnt;
@@ -501,6 +503,8 @@ struct otx2_nic {
 	u16			pfc_schq_list[NIX_TXSCH_LVL_CNT][MAX_TXSCHQ_PER_FUNC];
 	bool			pfc_alloc_status[NIX_PF_PFC_PRIO_MAX];
 #endif
+	/* qos */
+	struct otx2_qos		qos;
 
 	/* napi event count. It is needed for adaptive irq coalescing. */
 	u32 napi_events;
@@ -886,12 +890,19 @@ static inline void otx2_dma_unmap_page(struct otx2_nic *pfvf,
 
 static inline u16 otx2_get_smq_idx(struct otx2_nic *pfvf, u16 qidx)
 {
+	u16 smq;
+
 #ifdef CONFIG_DCB
 	if (qidx < NIX_PF_PFC_PRIO_MAX && pfvf->pfc_alloc_status[qidx])
 		return pfvf->pfc_schq_list[NIX_TXSCH_LVL_SMQ][qidx];
 #endif
+	/* check if qidx falls under QOS queues */
+	if (qidx >= pfvf->hw.tot_tx_queues)
+		smq = pfvf->qos.qid_to_sqmap[qidx - pfvf->hw.tot_tx_queues];
+	else
+		smq = pfvf->hw.txschq_list[NIX_TXSCH_LVL_SMQ][0];
 
-	return pfvf->hw.txschq_list[NIX_TXSCH_LVL_SMQ][0];
+	return smq;
 }
 
 /* MSI-X APIs */
@@ -926,11 +937,16 @@ int otx2_rxtx_enable(struct otx2_nic *pfvf, bool enable);
 void otx2_ctx_disable(struct mbox *mbox, int type, bool npa);
 int otx2_nix_config_bp(struct otx2_nic *pfvf, bool enable);
 void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq);
+int otx2_sq_init(struct otx2_nic *pfvf, u16 qidx, u16 sqb_aura);
 void otx2_cleanup_tx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq);
 int otx2_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura);
 int cn10k_sq_aq_init(void *dev, u16 qidx, u16 sqb_aura);
 int otx2_alloc_buffer(struct otx2_nic *pfvf, struct otx2_cq_queue *cq,
 		      dma_addr_t *dma);
+int otx2_pool_init(struct otx2_nic *pfvf, u16 pool_id,
+		   int stack_pages, int numptrs, int buf_size);
+int otx2_aura_init(struct otx2_nic *pfvf, int aura_id,
+		   int pool_id, int numptrs);
 
 /* RSS configuration APIs*/
 int otx2_rss_init(struct otx2_nic *pfvf);
@@ -1038,4 +1054,8 @@ static inline void cn10k_handle_mcs_event(struct otx2_nic *pfvf,
 {}
 #endif /* CONFIG_MACSEC */
 
+/* qos support */
+void otx2_qos_sq_setup(struct otx2_nic *pfvf);
+u16 otx2_select_queue(struct net_device *netdev, struct sk_buff *skb,
+		      struct net_device *sb_dev);
 #endif /* OTX2_COMMON_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index c1ea60bc2630..3acda6d289d3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -23,6 +23,7 @@
 #include "otx2_struct.h"
 #include "otx2_ptp.h"
 #include "cn10k.h"
+#include "qos.h"
 #include <rvu_trace.h>
 
 #define DRV_NAME	"rvu_nicpf"
@@ -1228,6 +1229,7 @@ static char *nix_snd_status_e_str[NIX_SND_STATUS_MAX] =  {
 static irqreturn_t otx2_q_intr_handler(int irq, void *data)
 {
 	struct otx2_nic *pf = data;
+	struct otx2_snd_queue *sq;
 	u64 val, *ptr;
 	u64 qidx = 0;
 
@@ -1257,15 +1259,18 @@ static irqreturn_t otx2_q_intr_handler(int irq, void *data)
 	}
 
 	/* SQ */
-	for (qidx = 0; qidx < pf->hw.tot_tx_queues; qidx++) {
+	for (qidx = 0; qidx < pf->hw.tot_tx_queues + pf->hw.tc_tx_queues; qidx++) {
 		u64 sq_op_err_dbg, mnq_err_dbg, snd_err_dbg;
 		u8 sq_op_err_code, mnq_err_code, snd_err_code;
 
+		sq = &pf->qset.sq[qidx];
+		if (!sq->sqb_ptrs)
+			continue;
+
 		/* Below debug registers captures first errors corresponding to
 		 * those registers. We don't have to check against SQ qid as
 		 * these are fatal errors.
 		 */
-
 		ptr = otx2_get_regaddr(pf, NIX_LF_SQ_OP_INT);
 		val = otx2_atomic64_add((qidx << 44), ptr);
 		otx2_write64(pf, NIX_LF_SQ_OP_INT, (qidx << 44) |
@@ -1383,7 +1388,7 @@ static void otx2_free_sq_res(struct otx2_nic *pf)
 	otx2_ctx_disable(&pf->mbox, NIX_AQ_CTYPE_SQ, false);
 	/* Free SQB pointers */
 	otx2_sq_free_sqbs(pf);
-	for (qidx = 0; qidx < pf->hw.tot_tx_queues; qidx++) {
+	for (qidx = 0; qidx < pf->hw.tot_tx_queues + pf->hw.tc_tx_queues; qidx++) {
 		sq = &qset->sq[qidx];
 		qmem_free(pf->dev, sq->sqe);
 		qmem_free(pf->dev, sq->tso_hdrs);
@@ -1433,7 +1438,7 @@ static int otx2_init_hw_resources(struct otx2_nic *pf)
 	 * so, aura count = pool count.
 	 */
 	hw->rqpool_cnt = hw->rx_queues;
-	hw->sqpool_cnt = hw->tot_tx_queues;
+	hw->sqpool_cnt = hw->tot_tx_queues + hw->tc_tx_queues;
 	hw->pool_cnt = hw->rqpool_cnt + hw->sqpool_cnt;
 
 	/* Maximum hardware supported transmit length */
@@ -1688,11 +1693,13 @@ int otx2_open(struct net_device *netdev)
 
 	netif_carrier_off(netdev);
 
-	pf->qset.cq_cnt = pf->hw.rx_queues + pf->hw.tot_tx_queues;
 	/* RQ and SQs are mapped to different CQs,
 	 * so find out max CQ IRQs (i.e CINTs) needed.
 	 */
 	pf->hw.cint_cnt = max(pf->hw.rx_queues, pf->hw.tx_queues);
+	pf->hw.cint_cnt = max_t(u8, pf->hw.cint_cnt, pf->hw.tc_tx_queues);
+	pf->qset.cq_cnt = pf->hw.rx_queues + pf->hw.tot_tx_queues + pf->hw.tc_tx_queues;
+
 	qset->napi = kcalloc(pf->hw.cint_cnt, sizeof(*cq_poll), GFP_KERNEL);
 	if (!qset->napi)
 		return -ENOMEM;
@@ -1708,7 +1715,7 @@ int otx2_open(struct net_device *netdev)
 	if (!qset->cq)
 		goto err_free_mem;
 
-	qset->sq = kcalloc(pf->hw.tot_tx_queues,
+	qset->sq = kcalloc(pf->hw.tot_tx_queues + pf->hw.tc_tx_queues,
 			   sizeof(struct otx2_snd_queue), GFP_KERNEL);
 	if (!qset->sq)
 		goto err_free_mem;
@@ -1743,6 +1750,11 @@ int otx2_open(struct net_device *netdev)
 		else
 			cq_poll->cq_ids[CQ_XDP] = CINT_INVALID_CQ;
 
+		cq_poll->cq_ids[CQ_QOS] = (qidx < pf->hw.tc_tx_queues) ?
+					  (qidx + pf->hw.rx_queues +
+					   pf->hw.tot_tx_queues) :
+					  CINT_INVALID_CQ;
+
 		cq_poll->dev = (void *)pf;
 		cq_poll->dim.mode = DIM_CQ_PERIOD_MODE_START_FROM_CQE;
 		INIT_WORK(&cq_poll->dim.work, otx2_dim_work);
@@ -1938,6 +1950,13 @@ static netdev_tx_t otx2_xmit(struct sk_buff *skb, struct net_device *netdev)
 	int qidx = skb_get_queue_mapping(skb);
 	struct otx2_snd_queue *sq;
 	struct netdev_queue *txq;
+	int sq_idx = qidx;
+
+	/* XDP SQs are not mapped with TXQs
+	 * advance qid to derive correct sq maped with QOS
+	 */
+	if (qidx == pf->hw.tx_queues)
+		sq_idx = qidx + pf->hw.xdp_queues;
 
 	/* Check for minimum and maximum packet length */
 	if (skb->len <= ETH_HLEN ||
@@ -1946,7 +1965,7 @@ static netdev_tx_t otx2_xmit(struct sk_buff *skb, struct net_device *netdev)
 		return NETDEV_TX_OK;
 	}
 
-	sq = &pf->qset.sq[qidx];
+	sq = &pf->qset.sq[sq_idx];
 	txq = netdev_get_tx_queue(netdev, qidx);
 
 	if (!otx2_sq_append_skb(netdev, sq, skb, qidx)) {
@@ -1964,8 +1983,8 @@ static netdev_tx_t otx2_xmit(struct sk_buff *skb, struct net_device *netdev)
 	return NETDEV_TX_OK;
 }
 
-static u16 otx2_select_queue(struct net_device *netdev, struct sk_buff *skb,
-			     struct net_device *sb_dev)
+u16 otx2_select_queue(struct net_device *netdev, struct sk_buff *skb,
+		      struct net_device *sb_dev)
 {
 #ifdef CONFIG_DCB
 	struct otx2_nic *pf = netdev_priv(netdev);
@@ -1987,6 +2006,7 @@ static u16 otx2_select_queue(struct net_device *netdev, struct sk_buff *skb,
 #endif
 	return netdev_pick_tx(netdev, skb, NULL);
 }
+EXPORT_SYMBOL(otx2_select_queue);
 
 static netdev_features_t otx2_fix_features(struct net_device *dev,
 					   netdev_features_t features)
@@ -2729,7 +2749,7 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* Set number of queues */
 	qcount = min_t(int, num_online_cpus(), OTX2_MAX_CQ_CNT);
 
-	netdev = alloc_etherdev_mqs(sizeof(*pf), qcount, qcount);
+	netdev = alloc_etherdev_mqs(sizeof(*pf), qcount + OTX2_QOS_MAX_LEAF_NODES, qcount);
 	if (!netdev) {
 		err = -ENOMEM;
 		goto err_release_regions;
@@ -2916,6 +2936,8 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_pf_sriov_init;
 #endif
 
+	otx2_qos_sq_setup(pf);
+
 	return 0;
 
 err_pf_sriov_init:
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index ef10aef3cda0..816b37c258e0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -463,12 +463,14 @@ static int otx2_tx_napi_handler(struct otx2_nic *pfvf,
 			break;
 		}
 
-		if (cq->cq_type == CQ_XDP) {
+		qidx = cq->cq_idx - pfvf->hw.rx_queues;
+
+		if (cq->cq_type == CQ_XDP)
 			otx2_xdp_snd_pkt_handler(pfvf, sq, cqe);
-		} else {
-			otx2_snd_pkt_handler(pfvf, cq, sq, cqe, budget,
-					     &tx_pkts, &tx_bytes);
-		}
+		else
+			otx2_snd_pkt_handler(pfvf, cq, &pfvf->qset.sq[qidx],
+					     cqe, budget, &tx_pkts, &tx_bytes);
+
 
 		cqe->hdr.cqe_type = NIX_XQE_TYPE_INVALID;
 		processed_cqe++;
@@ -485,7 +487,11 @@ static int otx2_tx_napi_handler(struct otx2_nic *pfvf,
 	if (likely(tx_pkts)) {
 		struct netdev_queue *txq;
 
-		txq = netdev_get_tx_queue(pfvf->netdev, cq->cint_idx);
+		qidx = cq->cq_idx - pfvf->hw.rx_queues;
+
+		if (qidx >= pfvf->hw.tx_queues)
+			qidx -= pfvf->hw.xdp_queues;
+		txq = netdev_get_tx_queue(pfvf->netdev, qidx);
 		netdev_tx_completed_queue(txq, tx_pkts, tx_bytes);
 		/* Check if queue was stopped earlier due to ring full */
 		smp_mb();
@@ -735,7 +741,10 @@ static void otx2_sqe_add_hdr(struct otx2_nic *pfvf, struct otx2_snd_queue *sq,
 		sqe_hdr->aura = sq->aura_id;
 		/* Post a CQE Tx after pkt transmission */
 		sqe_hdr->pnc = 1;
-		sqe_hdr->sq = qidx;
+		if (pfvf->hw.tx_queues == qidx)
+			sqe_hdr->sq = qidx + pfvf->hw.xdp_queues;
+		else
+			sqe_hdr->sq = qidx;
 	}
 	sqe_hdr->total = skb->len;
 	/* Set SQE identifier which will be used later for freeing SKB */
@@ -1183,8 +1192,10 @@ void otx2_cleanup_tx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq)
 	struct nix_cqe_tx_s *cqe;
 	int processed_cqe = 0;
 	struct sg_list *sg;
+	int qidx;
 
-	sq = &pfvf->qset.sq[cq->cint_idx];
+	qidx = cq->cq_idx - pfvf->hw.rx_queues;
+	sq = &pfvf->qset.sq[qidx];
 
 	if (otx2_nix_cq_op_status(pfvf, cq) || !cq->pend_cqe)
 		return;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
index 93cac2c2664c..7ab6db9a986f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
@@ -102,7 +102,8 @@ enum cq_type {
 	CQ_RX,
 	CQ_TX,
 	CQ_XDP,
-	CQS_PER_CINT = 3, /* RQ + SQ + XDP */
+	CQ_QOS,
+	CQS_PER_CINT = 4, /* RQ + SQ + XDP + QOS_SQ */
 };
 
 struct otx2_cq_poll {
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 7f8ffbf79cf7..459f559a3516 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -479,6 +479,7 @@ static const struct net_device_ops otx2vf_netdev_ops = {
 	.ndo_open = otx2vf_open,
 	.ndo_stop = otx2vf_stop,
 	.ndo_start_xmit = otx2vf_xmit,
+	.ndo_select_queue = otx2_select_queue,
 	.ndo_set_rx_mode = otx2vf_set_rx_mode,
 	.ndo_set_mac_address = otx2_set_mac_address,
 	.ndo_change_mtu = otx2vf_change_mtu,
@@ -550,7 +551,7 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_set_master(pdev);
 
 	qcount = num_online_cpus();
-	netdev = alloc_etherdev_mqs(sizeof(*vf), qcount, qcount);
+	netdev = alloc_etherdev_mqs(sizeof(*vf), qcount + OTX2_QOS_MAX_LEAF_NODES, qcount);
 	if (!netdev) {
 		err = -ENOMEM;
 		goto err_release_regions;
@@ -699,6 +700,7 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto err_shutdown_tc;
 #endif
+	otx2_qos_sq_setup(vf);
 
 	return 0;
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/qos.h b/drivers/net/ethernet/marvell/octeontx2/nic/qos.h
new file mode 100644
index 000000000000..ef8c99a6b2d0
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/qos.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Marvell RVU Ethernet driver
+ *
+ * Copyright (C) 2022 Marvell.
+ *
+ */
+#ifndef OTX2_QOS_H
+#define OTX2_QOS_H
+
+#define OTX2_QOS_MAX_LEAF_NODES		16
+
+int otx2_qos_enable_sq(struct otx2_nic *pfvf, int qidx, u16 smq);
+void otx2_qos_disable_sq(struct otx2_nic *pfvf, int qidx, u16 mdq);
+
+struct otx2_qos {
+	u16 qid_to_sqmap[OTX2_QOS_MAX_LEAF_NODES];
+};
+
+#endif
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/qos_sq.c b/drivers/net/ethernet/marvell/octeontx2/nic/qos_sq.c
new file mode 100644
index 000000000000..96e53d5d1778
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/qos_sq.c
@@ -0,0 +1,290 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell RVU Physical Function ethernet driver
+ *
+ * Copyright (C) 2022 Marvell.
+ *
+ */
+
+#include <linux/netdevice.h>
+#include <net/tso.h>
+
+#include "cn10k.h"
+#include "otx2_reg.h"
+#include "otx2_common.h"
+#include "otx2_txrx.h"
+#include "otx2_struct.h"
+
+#define OTX2_QOS_MAX_LEAF_NODES 16
+
+void otx2_qos_sq_setup(struct otx2_nic *pfvf)
+{
+	struct otx2_hw *hw = &pfvf->hw;
+
+	hw->tc_tx_queues = OTX2_QOS_MAX_LEAF_NODES;
+}
+EXPORT_SYMBOL(otx2_qos_sq_setup);
+
+static void otx2_qos_aura_pool_free(struct otx2_nic *pfvf, int pool_id)
+{
+	struct otx2_pool *pool;
+
+	if (!pfvf->qset.pool)
+		return;
+
+	pool = &pfvf->qset.pool[pool_id];
+	qmem_free(pfvf->dev, pool->stack);
+	qmem_free(pfvf->dev, pool->fc_addr);
+	pool->stack = NULL;
+	pool->fc_addr = NULL;
+}
+
+static int otx2_qos_sq_aura_pool_init(struct otx2_nic *pfvf, int qidx)
+{
+	struct otx2_qset *qset = &pfvf->qset;
+	int pool_id, stack_pages, num_sqbs;
+	struct otx2_hw *hw = &pfvf->hw;
+	struct otx2_snd_queue *sq;
+	struct otx2_pool *pool;
+	dma_addr_t bufptr;
+	int err, ptr;
+	u64 iova, pa;
+
+	/* Calculate number of SQBs needed.
+	 *
+	 * For a 128byte SQE, and 4K size SQB, 31 SQEs will fit in one SQB.
+	 * Last SQE is used for pointing to next SQB.
+	 */
+	num_sqbs = (hw->sqb_size / 128) - 1;
+	num_sqbs = (qset->sqe_cnt + num_sqbs) / num_sqbs;
+
+	/* Get no of stack pages needed */
+	stack_pages =
+		(num_sqbs + hw->stack_pg_ptrs - 1) / hw->stack_pg_ptrs;
+
+	pool_id = otx2_get_pool_idx(pfvf, AURA_NIX_SQ, qidx);
+	pool = &pfvf->qset.pool[pool_id];
+
+	/* Initialize aura context */
+	err = otx2_aura_init(pfvf, pool_id, pool_id, num_sqbs);
+	if (err)
+		return err;
+
+	/* Initialize pool context */
+	err = otx2_pool_init(pfvf, pool_id, stack_pages,
+			     num_sqbs, hw->sqb_size);
+	if (err)
+		goto aura_free;
+
+	/* Flush accumulated messages */
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	if (err)
+		goto pool_free;
+
+	/* Allocate pointers and free them to aura/pool */
+	sq = &qset->sq[qidx];
+	sq->sqb_count = 0;
+	sq->sqb_ptrs = kcalloc(num_sqbs, sizeof(*sq->sqb_ptrs), GFP_KERNEL);
+	if (!sq->sqb_ptrs) {
+		err = -ENOMEM;
+		goto pool_free;
+	}
+
+	for (ptr = 0; ptr < num_sqbs; ptr++) {
+		err = __otx2_alloc_rbuf(pfvf, pool, &bufptr);
+		if (err)
+			goto sqb_free;
+		pfvf->hw_ops->aura_freeptr(pfvf, pool_id, bufptr);
+		sq->sqb_ptrs[sq->sqb_count++] = (u64)bufptr;
+	}
+
+	return 0;
+
+sqb_free:
+	while (ptr--) {
+		if (!sq->sqb_ptrs[ptr])
+			continue;
+		iova = sq->sqb_ptrs[ptr];
+		pa = otx2_iova_to_phys(pfvf->iommu_domain, iova);
+		dma_unmap_page_attrs(pfvf->dev, iova, hw->sqb_size,
+				     DMA_FROM_DEVICE,
+				     DMA_ATTR_SKIP_CPU_SYNC);
+		put_page(virt_to_page(phys_to_virt(pa)));
+		otx2_aura_allocptr(pfvf, pool_id);
+	}
+	sq->sqb_count = 0;
+	kfree(sq->sqb_ptrs);
+pool_free:
+	qmem_free(pfvf->dev, pool->stack);
+aura_free:
+	qmem_free(pfvf->dev, pool->fc_addr);
+	otx2_mbox_reset(&pfvf->mbox.mbox, 0);
+	return err;
+}
+
+static void otx2_qos_sq_free_sqbs(struct otx2_nic *pfvf, int qidx)
+{
+	struct otx2_qset *qset = &pfvf->qset;
+	struct otx2_hw *hw = &pfvf->hw;
+	struct otx2_snd_queue *sq;
+	u64 iova, pa;
+	int sqb;
+
+	sq = &qset->sq[qidx];
+	if (!sq->sqb_ptrs)
+		return;
+	for (sqb = 0; sqb < sq->sqb_count; sqb++) {
+		if (!sq->sqb_ptrs[sqb])
+			continue;
+		iova = sq->sqb_ptrs[sqb];
+		pa = otx2_iova_to_phys(pfvf->iommu_domain, iova);
+		dma_unmap_page_attrs(pfvf->dev, iova, hw->sqb_size,
+				     DMA_FROM_DEVICE,
+				     DMA_ATTR_SKIP_CPU_SYNC);
+		put_page(virt_to_page(phys_to_virt(pa)));
+	}
+
+	sq->sqb_count = 0;
+
+	sq = &qset->sq[qidx];
+	qmem_free(pfvf->dev, sq->sqe);
+	qmem_free(pfvf->dev, sq->tso_hdrs);
+	kfree(sq->sg);
+	kfree(sq->sqb_ptrs);
+	qmem_free(pfvf->dev, sq->timestamps);
+
+	memset((void *)sq, 0, sizeof(*sq));
+}
+
+/* send queue id */
+static void otx2_qos_sqb_flush(struct otx2_nic *pfvf, int qidx)
+{
+	int sqe_tail, sqe_head;
+	u64 incr, *ptr, val;
+
+	ptr = (u64 *)otx2_get_regaddr(pfvf, NIX_LF_SQ_OP_STATUS);
+	incr = (u64)qidx << 32;
+	val = otx2_atomic64_add(incr, ptr);
+	sqe_head = (val >> 20) & 0x3F;
+	sqe_tail = (val >> 28) & 0x3F;
+	if (sqe_head != sqe_tail)
+		usleep_range(50, 60);
+}
+
+static int otx2_qos_ctx_disable(struct otx2_nic *pfvf, u16 qidx, int aura_id)
+{
+	struct nix_cn10k_aq_enq_req *cn10k_sq_aq;
+	struct npa_aq_enq_req *aura_aq;
+	struct npa_aq_enq_req *pool_aq;
+	struct nix_aq_enq_req *sq_aq;
+
+	if (test_bit(CN10K_LMTST, &pfvf->hw.cap_flag)) {
+		cn10k_sq_aq = otx2_mbox_alloc_msg_nix_cn10k_aq_enq(&pfvf->mbox);
+		if (!cn10k_sq_aq)
+			return -ENOMEM;
+		cn10k_sq_aq->qidx = qidx;
+		cn10k_sq_aq->sq.ena = 0;
+		cn10k_sq_aq->sq_mask.ena = 1;
+		cn10k_sq_aq->ctype = NIX_AQ_CTYPE_SQ;
+		cn10k_sq_aq->op = NIX_AQ_INSTOP_WRITE;
+	} else {
+		sq_aq = otx2_mbox_alloc_msg_nix_aq_enq(&pfvf->mbox);
+		if (!sq_aq)
+			return -ENOMEM;
+		sq_aq->qidx = qidx;
+		sq_aq->sq.ena = 0;
+		sq_aq->sq_mask.ena = 1;
+		sq_aq->ctype = NIX_AQ_CTYPE_SQ;
+		sq_aq->op = NIX_AQ_INSTOP_WRITE;
+	}
+
+	aura_aq = otx2_mbox_alloc_msg_npa_aq_enq(&pfvf->mbox);
+	if (!aura_aq) {
+		otx2_mbox_reset(&pfvf->mbox.mbox, 0);
+		return -ENOMEM;
+	}
+
+	aura_aq->aura_id = aura_id;
+	aura_aq->aura.ena = 0;
+	aura_aq->aura_mask.ena = 1;
+	aura_aq->ctype = NPA_AQ_CTYPE_AURA;
+	aura_aq->op = NPA_AQ_INSTOP_WRITE;
+
+	pool_aq = otx2_mbox_alloc_msg_npa_aq_enq(&pfvf->mbox);
+	if (!pool_aq) {
+		otx2_mbox_reset(&pfvf->mbox.mbox, 0);
+		return -ENOMEM;
+	}
+
+	pool_aq->aura_id = aura_id;
+	pool_aq->pool.ena = 0;
+	pool_aq->pool_mask.ena = 1;
+
+	pool_aq->ctype = NPA_AQ_CTYPE_POOL;
+	pool_aq->op = NPA_AQ_INSTOP_WRITE;
+
+	return otx2_sync_mbox_msg(&pfvf->mbox);
+}
+
+int otx2_qos_enable_sq(struct otx2_nic *pfvf, int qidx, u16 smq)
+{
+	struct otx2_hw *hw = &pfvf->hw;
+	int pool_id, sq_idx, err;
+
+	if (pfvf->flags & OTX2_FLAG_INTF_DOWN)
+		return -EPERM;
+
+	sq_idx = hw->tot_tx_queues + qidx;
+
+	mutex_lock(&pfvf->mbox.lock);
+	err = otx2_qos_sq_aura_pool_init(pfvf, sq_idx);
+	if (err)
+		goto out;
+
+	pool_id = otx2_get_pool_idx(pfvf, AURA_NIX_SQ, sq_idx);
+	pfvf->qos.qid_to_sqmap[qidx] = smq;
+	err = otx2_sq_init(pfvf, sq_idx, pool_id);
+	if (err)
+		goto out;
+out:
+	mutex_unlock(&pfvf->mbox.lock);
+	return err;
+}
+
+void otx2_qos_disable_sq(struct otx2_nic *pfvf, int qidx, u16 mdq)
+{
+	struct otx2_qset *qset = &pfvf->qset;
+	struct otx2_hw *hw = &pfvf->hw;
+	struct otx2_snd_queue *sq;
+	struct otx2_cq_queue *cq;
+	int pool_id, sq_idx;
+
+	sq_idx = hw->tot_tx_queues + qidx;
+
+	/* If the DOWN flag is set SQs are already freed */
+	if (pfvf->flags & OTX2_FLAG_INTF_DOWN)
+		return;
+
+	sq = &pfvf->qset.sq[sq_idx];
+	if (!sq->sqb_ptrs)
+		return;
+
+	if (sq_idx < hw->tot_tx_queues ||
+	    sq_idx >= hw->tot_tx_queues + hw->tc_tx_queues) {
+		netdev_err(pfvf->netdev, "Send Queue is not a QoS queue\n");
+		return;
+	}
+
+	cq = &qset->cq[pfvf->hw.rx_queues + sq_idx];
+	pool_id = otx2_get_pool_idx(pfvf, AURA_NIX_SQ, sq_idx);
+
+	otx2_qos_sqb_flush(pfvf, sq_idx);
+	otx2_smq_flush(pfvf, otx2_get_smq_idx(pfvf, sq_idx));
+	otx2_cleanup_tx_cqes(pfvf, cq);
+
+	mutex_lock(&pfvf->mbox.lock);
+	otx2_qos_ctx_disable(pfvf, sq_idx, pool_id);
+	mutex_unlock(&pfvf->mbox.lock);
+
+	otx2_qos_sq_free_sqbs(pfvf, sq_idx);
+	otx2_qos_aura_pool_free(pfvf, pool_id);
+}
-- 
2.17.1

