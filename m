Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B829742A1D8
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 12:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235915AbhJLKUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 06:20:34 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46900 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235878AbhJLKU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 06:20:28 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19C9abxY018802;
        Tue, 12 Oct 2021 06:18:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=F7v0qLInDs/8PKY0gu4L3oJWJahNTED5Fd07RWpUprk=;
 b=e4lRqz1bSFKWj1LWwZr9k6gDxWO4FeT9ZQQ4ogHQIL6oRHBDISpUZFUEsUN+IdWEPmyK
 /9msZO/koL+eqR1IKuSmXAdbfYkG+KtL9WwjdSDKNrJf4MqDljRX7Y0NeBWiZIPG3ozO
 Ebq1idd993sH75SVXzJ9a7hSHqSSLGoJ3xXPioQLfD50W5R7MKofoTMnHnvqHO6Tp3v4
 eyfR9nzdGUZEYNIK2p0LWC/+3Rhp8EasECX0pg05ghGVbiKypRDFNUjwHNQRNDVSPR0J
 SyQgIy2BL8xcxNZMemAw83ItghVdpDA1S39qLqGmzhed64SHMLVJk91kZAb21Ry2MHIb Qg== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bn6mwacfe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 06:18:25 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19CABOGG018626;
        Tue, 12 Oct 2021 10:18:23 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3bk2q9dck6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 10:18:23 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19CAIHBY66060680
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 10:18:17 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D054AE058;
        Tue, 12 Oct 2021 10:18:17 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 43D00AE05D;
        Tue, 12 Oct 2021 10:18:15 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Oct 2021 10:18:14 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH net-next 08/11] net/smc: add v2 support to the work request layer
Date:   Tue, 12 Oct 2021 12:17:40 +0200
Message-Id: <20211012101743.2282031-9-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211012101743.2282031-1-kgraul@linux.ibm.com>
References: <20211012101743.2282031-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wrk_YK--qu0ySGuMq6nbr1oTlGoyJETd
X-Proofpoint-ORIG-GUID: wrk_YK--qu0ySGuMq6nbr1oTlGoyJETd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-12_02,2021-10-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 mlxlogscore=897
 mlxscore=0 adultscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110120058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the work request layer define one large v2 buffer for each link group
that is used to transmit and receive large LLC control messages.
Add the completion queue handling for this buffer.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_core.c |   7 +-
 net/smc/smc_core.h |  14 ++++
 net/smc/smc_ib.c   |   3 +-
 net/smc/smc_wr.c   | 194 ++++++++++++++++++++++++++++++++++++++++-----
 net/smc/smc_wr.h   |   2 +
 5 files changed, 199 insertions(+), 21 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 6bbd71de6bc0..1ccab993683d 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -837,13 +837,17 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 		}
 		memcpy(lgr->pnet_id, ibdev->pnetid[ibport - 1],
 		       SMC_MAX_PNETID_LEN);
+		if (smc_wr_alloc_lgr_mem(lgr))
+			goto free_wq;
 		smc_llc_lgr_init(lgr, smc);
 
 		link_idx = SMC_SINGLE_LINK;
 		lnk = &lgr->lnk[link_idx];
 		rc = smcr_link_init(lgr, lnk, link_idx, ini);
-		if (rc)
+		if (rc) {
+			smc_wr_free_lgr_mem(lgr);
 			goto free_wq;
+		}
 		lgr_list = &smc_lgr_list.list;
 		lgr_lock = &smc_lgr_list.lock;
 		atomic_inc(&lgr_cnt);
@@ -1250,6 +1254,7 @@ static void smc_lgr_free(struct smc_link_group *lgr)
 		if (!atomic_dec_return(&lgr->smcd->lgr_cnt))
 			wake_up(&lgr->smcd->lgrs_deleted);
 	} else {
+		smc_wr_free_lgr_mem(lgr);
 		if (!atomic_dec_return(&lgr_cnt))
 			wake_up(&lgrs_deleted);
 	}
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index dd3198bb6cb9..5997657ee9cc 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -42,11 +42,16 @@ enum smc_link_state {			/* possible states of a link */
 };
 
 #define SMC_WR_BUF_SIZE		48	/* size of work request buffer */
+#define SMC_WR_BUF_V2_SIZE	8192	/* size of v2 work request buffer */
 
 struct smc_wr_buf {
 	u8	raw[SMC_WR_BUF_SIZE];
 };
 
+struct smc_wr_v2_buf {
+	u8	raw[SMC_WR_BUF_V2_SIZE];
+};
+
 #define SMC_WR_REG_MR_WAIT_TIME	(5 * HZ)/* wait time for ib_wr_reg_mr result */
 
 enum smc_wr_reg_state {
@@ -92,7 +97,11 @@ struct smc_link {
 	struct smc_wr_tx_pend	*wr_tx_pends;	/* WR send waiting for CQE */
 	struct completion	*wr_tx_compl;	/* WR send CQE completion */
 	/* above four vectors have wr_tx_cnt elements and use the same index */
+	struct ib_send_wr	*wr_tx_v2_ib;	/* WR send v2 meta data */
+	struct ib_sge		*wr_tx_v2_sge;	/* WR send v2 gather meta data*/
+	struct smc_wr_tx_pend	*wr_tx_v2_pend;	/* WR send v2 waiting for CQE */
 	dma_addr_t		wr_tx_dma_addr;	/* DMA address of wr_tx_bufs */
+	dma_addr_t		wr_tx_v2_dma_addr; /* DMA address of v2 tx buf*/
 	atomic_long_t		wr_tx_id;	/* seq # of last sent WR */
 	unsigned long		*wr_tx_mask;	/* bit mask of used indexes */
 	u32			wr_tx_cnt;	/* number of WR send buffers */
@@ -104,6 +113,7 @@ struct smc_link {
 	struct ib_sge		*wr_rx_sges;	/* WR recv scatter meta data */
 	/* above three vectors have wr_rx_cnt elements and use the same index */
 	dma_addr_t		wr_rx_dma_addr;	/* DMA address of wr_rx_bufs */
+	dma_addr_t		wr_rx_v2_dma_addr; /* DMA address of v2 rx buf*/
 	u64			wr_rx_id;	/* seq # of last recv WR */
 	u32			wr_rx_cnt;	/* number of WR recv buffers */
 	unsigned long		wr_rx_tstamp;	/* jiffies when last buf rx */
@@ -250,6 +260,10 @@ struct smc_link_group {
 						/* client or server */
 			struct smc_link		lnk[SMC_LINKS_PER_LGR_MAX];
 						/* smc link */
+			struct smc_wr_v2_buf	*wr_rx_buf_v2;
+						/* WR v2 recv payload buffer */
+			struct smc_wr_v2_buf	*wr_tx_buf_v2;
+						/* WR v2 send payload buffer */
 			char			peer_systemid[SMC_SYSTEMID_LEN];
 						/* unique system_id of peer */
 			struct smc_rtoken	rtokens[SMC_RMBS_PER_LGR_MAX]
diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index d15bacbd73e0..32f9d2fdc474 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -601,6 +601,7 @@ void smc_ib_destroy_queue_pair(struct smc_link *lnk)
 /* create a queue pair within the protection domain for a link */
 int smc_ib_create_queue_pair(struct smc_link *lnk)
 {
+	int sges_per_buf = (lnk->lgr->smc_version == SMC_V2) ? 2 : 1;
 	struct ib_qp_init_attr qp_attr = {
 		.event_handler = smc_ib_qp_event_handler,
 		.qp_context = lnk,
@@ -614,7 +615,7 @@ int smc_ib_create_queue_pair(struct smc_link *lnk)
 			.max_send_wr = SMC_WR_BUF_CNT * 3,
 			.max_recv_wr = SMC_WR_BUF_CNT * 3,
 			.max_send_sge = SMC_IB_MAX_SEND_SGE,
-			.max_recv_sge = 1,
+			.max_recv_sge = sges_per_buf,
 		},
 		.sq_sig_type = IB_SIGNAL_REQ_WR,
 		.qp_type = IB_QPT_RC,
diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
index a419e9af36b9..22d7324969cd 100644
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@ -101,19 +101,32 @@ static inline void smc_wr_tx_process_cqe(struct ib_wc *wc)
 	}
 
 	pnd_snd_idx = smc_wr_tx_find_pending_index(link, wc->wr_id);
-	if (pnd_snd_idx == link->wr_tx_cnt)
-		return;
-	link->wr_tx_pends[pnd_snd_idx].wc_status = wc->status;
-	if (link->wr_tx_pends[pnd_snd_idx].compl_requested)
-		complete(&link->wr_tx_compl[pnd_snd_idx]);
-	memcpy(&pnd_snd, &link->wr_tx_pends[pnd_snd_idx], sizeof(pnd_snd));
-	/* clear the full struct smc_wr_tx_pend including .priv */
-	memset(&link->wr_tx_pends[pnd_snd_idx], 0,
-	       sizeof(link->wr_tx_pends[pnd_snd_idx]));
-	memset(&link->wr_tx_bufs[pnd_snd_idx], 0,
-	       sizeof(link->wr_tx_bufs[pnd_snd_idx]));
-	if (!test_and_clear_bit(pnd_snd_idx, link->wr_tx_mask))
-		return;
+	if (pnd_snd_idx == link->wr_tx_cnt) {
+		if (link->lgr->smc_version != SMC_V2 ||
+		    link->wr_tx_v2_pend->wr_id != wc->wr_id)
+			return;
+		link->wr_tx_v2_pend->wc_status = wc->status;
+		memcpy(&pnd_snd, link->wr_tx_v2_pend, sizeof(pnd_snd));
+		/* clear the full struct smc_wr_tx_pend including .priv */
+		memset(link->wr_tx_v2_pend, 0,
+		       sizeof(*link->wr_tx_v2_pend));
+		memset(link->lgr->wr_tx_buf_v2, 0,
+		       sizeof(*link->lgr->wr_tx_buf_v2));
+	} else {
+		link->wr_tx_pends[pnd_snd_idx].wc_status = wc->status;
+		if (link->wr_tx_pends[pnd_snd_idx].compl_requested)
+			complete(&link->wr_tx_compl[pnd_snd_idx]);
+		memcpy(&pnd_snd, &link->wr_tx_pends[pnd_snd_idx],
+		       sizeof(pnd_snd));
+		/* clear the full struct smc_wr_tx_pend including .priv */
+		memset(&link->wr_tx_pends[pnd_snd_idx], 0,
+		       sizeof(link->wr_tx_pends[pnd_snd_idx]));
+		memset(&link->wr_tx_bufs[pnd_snd_idx], 0,
+		       sizeof(link->wr_tx_bufs[pnd_snd_idx]));
+		if (!test_and_clear_bit(pnd_snd_idx, link->wr_tx_mask))
+			return;
+	}
+
 	if (wc->status) {
 		for_each_set_bit(i, link->wr_tx_mask, link->wr_tx_cnt) {
 			/* clear full struct smc_wr_tx_pend including .priv */
@@ -123,6 +136,12 @@ static inline void smc_wr_tx_process_cqe(struct ib_wc *wc)
 			       sizeof(link->wr_tx_bufs[i]));
 			clear_bit(i, link->wr_tx_mask);
 		}
+		if (link->lgr->smc_version == SMC_V2) {
+			memset(link->wr_tx_v2_pend, 0,
+			       sizeof(*link->wr_tx_v2_pend));
+			memset(link->lgr->wr_tx_buf_v2, 0,
+			       sizeof(*link->lgr->wr_tx_buf_v2));
+		}
 		/* terminate link */
 		smcr_link_down_cond_sched(link);
 	}
@@ -256,6 +275,14 @@ int smc_wr_tx_put_slot(struct smc_link *link,
 		test_and_clear_bit(idx, link->wr_tx_mask);
 		wake_up(&link->wr_tx_wait);
 		return 1;
+	} else if (link->lgr->smc_version == SMC_V2 &&
+		   pend->idx == link->wr_tx_cnt) {
+		/* Large v2 buffer */
+		memset(&link->wr_tx_v2_pend, 0,
+		       sizeof(link->wr_tx_v2_pend));
+		memset(&link->lgr->wr_tx_buf_v2, 0,
+		       sizeof(link->lgr->wr_tx_buf_v2));
+		return 1;
 	}
 
 	return 0;
@@ -517,6 +544,7 @@ void smc_wr_remember_qp_attr(struct smc_link *lnk)
 
 static void smc_wr_init_sge(struct smc_link *lnk)
 {
+	int sges_per_buf = (lnk->lgr->smc_version == SMC_V2) ? 2 : 1;
 	u32 i;
 
 	for (i = 0; i < lnk->wr_tx_cnt; i++) {
@@ -545,14 +573,44 @@ static void smc_wr_init_sge(struct smc_link *lnk)
 		lnk->wr_tx_rdmas[i].wr_tx_rdma[1].wr.sg_list =
 			lnk->wr_tx_rdma_sges[i].tx_rdma_sge[1].wr_tx_rdma_sge;
 	}
+
+	if (lnk->lgr->smc_version == SMC_V2) {
+		lnk->wr_tx_v2_sge->addr = lnk->wr_tx_v2_dma_addr;
+		lnk->wr_tx_v2_sge->length = SMC_WR_BUF_V2_SIZE;
+		lnk->wr_tx_v2_sge->lkey = lnk->roce_pd->local_dma_lkey;
+
+		lnk->wr_tx_v2_ib->next = NULL;
+		lnk->wr_tx_v2_ib->sg_list = lnk->wr_tx_v2_sge;
+		lnk->wr_tx_v2_ib->num_sge = 1;
+		lnk->wr_tx_v2_ib->opcode = IB_WR_SEND;
+		lnk->wr_tx_v2_ib->send_flags =
+			IB_SEND_SIGNALED | IB_SEND_SOLICITED;
+	}
+
+	/* With SMC-Rv2 there can be messages larger than SMC_WR_TX_SIZE.
+	 * Each ib_recv_wr gets 2 sges, the second one is a spillover buffer
+	 * and the same buffer for all sges. When a larger message arrived then
+	 * the content of the first small sge is copied to the beginning of
+	 * the larger spillover buffer, allowing easy data mapping.
+	 */
 	for (i = 0; i < lnk->wr_rx_cnt; i++) {
-		lnk->wr_rx_sges[i].addr =
+		int x = i * sges_per_buf;
+
+		lnk->wr_rx_sges[x].addr =
 			lnk->wr_rx_dma_addr + i * SMC_WR_BUF_SIZE;
-		lnk->wr_rx_sges[i].length = SMC_WR_BUF_SIZE;
-		lnk->wr_rx_sges[i].lkey = lnk->roce_pd->local_dma_lkey;
+		lnk->wr_rx_sges[x].length = SMC_WR_TX_SIZE;
+		lnk->wr_rx_sges[x].lkey = lnk->roce_pd->local_dma_lkey;
+		if (lnk->lgr->smc_version == SMC_V2) {
+			lnk->wr_rx_sges[x + 1].addr =
+					lnk->wr_rx_v2_dma_addr + SMC_WR_TX_SIZE;
+			lnk->wr_rx_sges[x + 1].length =
+					SMC_WR_BUF_V2_SIZE - SMC_WR_TX_SIZE;
+			lnk->wr_rx_sges[x + 1].lkey =
+					lnk->roce_pd->local_dma_lkey;
+		}
 		lnk->wr_rx_ibs[i].next = NULL;
-		lnk->wr_rx_ibs[i].sg_list = &lnk->wr_rx_sges[i];
-		lnk->wr_rx_ibs[i].num_sge = 1;
+		lnk->wr_rx_ibs[i].sg_list = &lnk->wr_rx_sges[x];
+		lnk->wr_rx_ibs[i].num_sge = sges_per_buf;
 	}
 	lnk->wr_reg.wr.next = NULL;
 	lnk->wr_reg.wr.num_sge = 0;
@@ -585,16 +643,45 @@ void smc_wr_free_link(struct smc_link *lnk)
 				    DMA_FROM_DEVICE);
 		lnk->wr_rx_dma_addr = 0;
 	}
+	if (lnk->wr_rx_v2_dma_addr) {
+		ib_dma_unmap_single(ibdev, lnk->wr_rx_v2_dma_addr,
+				    SMC_WR_BUF_V2_SIZE,
+				    DMA_FROM_DEVICE);
+		lnk->wr_rx_v2_dma_addr = 0;
+	}
 	if (lnk->wr_tx_dma_addr) {
 		ib_dma_unmap_single(ibdev, lnk->wr_tx_dma_addr,
 				    SMC_WR_BUF_SIZE * lnk->wr_tx_cnt,
 				    DMA_TO_DEVICE);
 		lnk->wr_tx_dma_addr = 0;
 	}
+	if (lnk->wr_tx_v2_dma_addr) {
+		ib_dma_unmap_single(ibdev, lnk->wr_tx_v2_dma_addr,
+				    SMC_WR_BUF_V2_SIZE,
+				    DMA_TO_DEVICE);
+		lnk->wr_tx_v2_dma_addr = 0;
+	}
+}
+
+void smc_wr_free_lgr_mem(struct smc_link_group *lgr)
+{
+	if (lgr->smc_version < SMC_V2)
+		return;
+
+	kfree(lgr->wr_rx_buf_v2);
+	lgr->wr_rx_buf_v2 = NULL;
+	kfree(lgr->wr_tx_buf_v2);
+	lgr->wr_tx_buf_v2 = NULL;
 }
 
 void smc_wr_free_link_mem(struct smc_link *lnk)
 {
+	kfree(lnk->wr_tx_v2_ib);
+	lnk->wr_tx_v2_ib = NULL;
+	kfree(lnk->wr_tx_v2_sge);
+	lnk->wr_tx_v2_sge = NULL;
+	kfree(lnk->wr_tx_v2_pend);
+	lnk->wr_tx_v2_pend = NULL;
 	kfree(lnk->wr_tx_compl);
 	lnk->wr_tx_compl = NULL;
 	kfree(lnk->wr_tx_pends);
@@ -619,8 +706,26 @@ void smc_wr_free_link_mem(struct smc_link *lnk)
 	lnk->wr_rx_bufs = NULL;
 }
 
+int smc_wr_alloc_lgr_mem(struct smc_link_group *lgr)
+{
+	if (lgr->smc_version < SMC_V2)
+		return 0;
+
+	lgr->wr_rx_buf_v2 = kzalloc(SMC_WR_BUF_V2_SIZE, GFP_KERNEL);
+	if (!lgr->wr_rx_buf_v2)
+		return -ENOMEM;
+	lgr->wr_tx_buf_v2 = kzalloc(SMC_WR_BUF_V2_SIZE, GFP_KERNEL);
+	if (!lgr->wr_tx_buf_v2) {
+		kfree(lgr->wr_rx_buf_v2);
+		return -ENOMEM;
+	}
+	return 0;
+}
+
 int smc_wr_alloc_link_mem(struct smc_link *link)
 {
+	int sges_per_buf = link->lgr->smc_version == SMC_V2 ? 2 : 1;
+
 	/* allocate link related memory */
 	link->wr_tx_bufs = kcalloc(SMC_WR_BUF_CNT, SMC_WR_BUF_SIZE, GFP_KERNEL);
 	if (!link->wr_tx_bufs)
@@ -653,7 +758,7 @@ int smc_wr_alloc_link_mem(struct smc_link *link)
 	if (!link->wr_tx_sges)
 		goto no_mem_wr_tx_rdma_sges;
 	link->wr_rx_sges = kcalloc(SMC_WR_BUF_CNT * 3,
-				   sizeof(link->wr_rx_sges[0]),
+				   sizeof(link->wr_rx_sges[0]) * sges_per_buf,
 				   GFP_KERNEL);
 	if (!link->wr_rx_sges)
 		goto no_mem_wr_tx_sges;
@@ -672,8 +777,29 @@ int smc_wr_alloc_link_mem(struct smc_link *link)
 				    GFP_KERNEL);
 	if (!link->wr_tx_compl)
 		goto no_mem_wr_tx_pends;
+
+	if (link->lgr->smc_version == SMC_V2) {
+		link->wr_tx_v2_ib = kzalloc(sizeof(*link->wr_tx_v2_ib),
+					    GFP_KERNEL);
+		if (!link->wr_tx_v2_ib)
+			goto no_mem_tx_compl;
+		link->wr_tx_v2_sge = kzalloc(sizeof(*link->wr_tx_v2_sge),
+					     GFP_KERNEL);
+		if (!link->wr_tx_v2_sge)
+			goto no_mem_v2_ib;
+		link->wr_tx_v2_pend = kzalloc(sizeof(*link->wr_tx_v2_pend),
+					      GFP_KERNEL);
+		if (!link->wr_tx_v2_pend)
+			goto no_mem_v2_sge;
+	}
 	return 0;
 
+no_mem_v2_sge:
+	kfree(link->wr_tx_v2_sge);
+no_mem_v2_ib:
+	kfree(link->wr_tx_v2_ib);
+no_mem_tx_compl:
+	kfree(link->wr_tx_compl);
 no_mem_wr_tx_pends:
 	kfree(link->wr_tx_pends);
 no_mem_wr_tx_mask:
@@ -725,6 +851,24 @@ int smc_wr_create_link(struct smc_link *lnk)
 		rc = -EIO;
 		goto out;
 	}
+	if (lnk->lgr->smc_version == SMC_V2) {
+		lnk->wr_rx_v2_dma_addr = ib_dma_map_single(ibdev,
+			lnk->lgr->wr_rx_buf_v2, SMC_WR_BUF_V2_SIZE,
+			DMA_FROM_DEVICE);
+		if (ib_dma_mapping_error(ibdev, lnk->wr_rx_v2_dma_addr)) {
+			lnk->wr_rx_v2_dma_addr = 0;
+			rc = -EIO;
+			goto dma_unmap;
+		}
+		lnk->wr_tx_v2_dma_addr = ib_dma_map_single(ibdev,
+			lnk->lgr->wr_tx_buf_v2, SMC_WR_BUF_V2_SIZE,
+			DMA_TO_DEVICE);
+		if (ib_dma_mapping_error(ibdev, lnk->wr_tx_v2_dma_addr)) {
+			lnk->wr_tx_v2_dma_addr = 0;
+			rc = -EIO;
+			goto dma_unmap;
+		}
+	}
 	lnk->wr_tx_dma_addr = ib_dma_map_single(
 		ibdev, lnk->wr_tx_bufs,	SMC_WR_BUF_SIZE * lnk->wr_tx_cnt,
 		DMA_TO_DEVICE);
@@ -742,6 +886,18 @@ int smc_wr_create_link(struct smc_link *lnk)
 	return rc;
 
 dma_unmap:
+	if (lnk->wr_rx_v2_dma_addr) {
+		ib_dma_unmap_single(ibdev, lnk->wr_rx_v2_dma_addr,
+				    SMC_WR_BUF_V2_SIZE,
+				    DMA_FROM_DEVICE);
+		lnk->wr_rx_v2_dma_addr = 0;
+	}
+	if (lnk->wr_tx_v2_dma_addr) {
+		ib_dma_unmap_single(ibdev, lnk->wr_tx_v2_dma_addr,
+				    SMC_WR_BUF_V2_SIZE,
+				    DMA_TO_DEVICE);
+		lnk->wr_tx_v2_dma_addr = 0;
+	}
 	ib_dma_unmap_single(ibdev, lnk->wr_rx_dma_addr,
 			    SMC_WR_BUF_SIZE * lnk->wr_rx_cnt,
 			    DMA_FROM_DEVICE);
diff --git a/net/smc/smc_wr.h b/net/smc/smc_wr.h
index 2bc626f230a5..6d2cdb231859 100644
--- a/net/smc/smc_wr.h
+++ b/net/smc/smc_wr.h
@@ -101,8 +101,10 @@ static inline int smc_wr_rx_post(struct smc_link *link)
 
 int smc_wr_create_link(struct smc_link *lnk);
 int smc_wr_alloc_link_mem(struct smc_link *lnk);
+int smc_wr_alloc_lgr_mem(struct smc_link_group *lgr);
 void smc_wr_free_link(struct smc_link *lnk);
 void smc_wr_free_link_mem(struct smc_link *lnk);
+void smc_wr_free_lgr_mem(struct smc_link_group *lgr);
 void smc_wr_remember_qp_attr(struct smc_link *lnk);
 void smc_wr_remove_dev(struct smc_ib_device *smcibdev);
 void smc_wr_add_dev(struct smc_ib_device *smcibdev);
-- 
2.25.1

