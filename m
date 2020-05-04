Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4B8B1C392A
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 14:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbgEDMTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 08:19:20 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41508 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728742AbgEDMTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 08:19:15 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 044CAPrM065418;
        Mon, 4 May 2020 08:19:13 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30s2g1m315-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 May 2020 08:19:13 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 044C9q3V011607;
        Mon, 4 May 2020 12:19:11 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 30s0g5mr13-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 May 2020 12:19:11 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 044CJ8aI61669592
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 May 2020 12:19:08 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4B37A4051;
        Mon,  4 May 2020 12:19:08 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73651A4055;
        Mon,  4 May 2020 12:19:08 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  4 May 2020 12:19:08 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 05/12] net/smc: wait for departure of an IB message
Date:   Mon,  4 May 2020 14:18:41 +0200
Message-Id: <20200504121848.46585-6-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200504121848.46585-1-kgraul@linux.ibm.com>
References: <20200504121848.46585-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-04_06:2020-05-04,2020-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 suspectscore=3 bulkscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce smc_wr_tx_send_wait() to send an IB message and wait for the
tx completion event of the message. This makes sure that the message is
no longer in-flight when the function returns.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_core.h |  1 +
 net/smc/smc_wr.c   | 39 +++++++++++++++++++++++++++++++++++++++
 net/smc/smc_wr.h   |  2 ++
 3 files changed, 42 insertions(+)

diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 584f11230c4f..86eebbadc8f6 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -85,6 +85,7 @@ struct smc_link {
 	struct smc_rdma_sges	*wr_tx_rdma_sges;/*RDMA WRITE gather meta data*/
 	struct smc_rdma_wr	*wr_tx_rdmas;	/* WR RDMA WRITE */
 	struct smc_wr_tx_pend	*wr_tx_pends;	/* WR send waiting for CQE */
+	struct completion	*wr_tx_compl;	/* WR send CQE completion */
 	/* above four vectors have wr_tx_cnt elements and use the same index */
 	dma_addr_t		wr_tx_dma_addr;	/* DMA address of wr_tx_bufs */
 	atomic_long_t		wr_tx_id;	/* seq # of last sent WR */
diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
index 3fd27bea4f7a..7239ba9b99dc 100644
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@ -44,6 +44,7 @@ struct smc_wr_tx_pend {	/* control data for a pending send request */
 	struct smc_link		*link;
 	u32			idx;
 	struct smc_wr_tx_pend_priv priv;
+	u8			compl_requested;
 };
 
 /******************************** send queue *********************************/
@@ -103,6 +104,8 @@ static inline void smc_wr_tx_process_cqe(struct ib_wc *wc)
 	if (pnd_snd_idx == link->wr_tx_cnt)
 		return;
 	link->wr_tx_pends[pnd_snd_idx].wc_status = wc->status;
+	if (link->wr_tx_pends[pnd_snd_idx].compl_requested)
+		complete(&link->wr_tx_compl[pnd_snd_idx]);
 	memcpy(&pnd_snd, &link->wr_tx_pends[pnd_snd_idx], sizeof(pnd_snd));
 	/* clear the full struct smc_wr_tx_pend including .priv */
 	memset(&link->wr_tx_pends[pnd_snd_idx], 0,
@@ -275,6 +278,33 @@ int smc_wr_tx_send(struct smc_link *link, struct smc_wr_tx_pend_priv *priv)
 	return rc;
 }
 
+/* Send prepared WR slot via ib_post_send and wait for send completion
+ * notification.
+ * @priv: pointer to smc_wr_tx_pend_priv identifying prepared message buffer
+ */
+int smc_wr_tx_send_wait(struct smc_link *link, struct smc_wr_tx_pend_priv *priv,
+			unsigned long timeout)
+{
+	struct smc_wr_tx_pend *pend;
+	int rc;
+
+	pend = container_of(priv, struct smc_wr_tx_pend, priv);
+	pend->compl_requested = 1;
+	init_completion(&link->wr_tx_compl[pend->idx]);
+
+	rc = smc_wr_tx_send(link, priv);
+	if (rc)
+		return rc;
+	/* wait for completion by smc_wr_tx_process_cqe() */
+	rc = wait_for_completion_interruptible_timeout(
+					&link->wr_tx_compl[pend->idx], timeout);
+	if (rc <= 0)
+		rc = -ENODATA;
+	if (rc > 0)
+		rc = 0;
+	return rc;
+}
+
 /* Register a memory region and wait for result. */
 int smc_wr_reg_send(struct smc_link *link, struct ib_mr *mr)
 {
@@ -555,6 +585,8 @@ void smc_wr_free_link(struct smc_link *lnk)
 
 void smc_wr_free_link_mem(struct smc_link *lnk)
 {
+	kfree(lnk->wr_tx_compl);
+	lnk->wr_tx_compl = NULL;
 	kfree(lnk->wr_tx_pends);
 	lnk->wr_tx_pends = NULL;
 	kfree(lnk->wr_tx_mask);
@@ -625,8 +657,15 @@ int smc_wr_alloc_link_mem(struct smc_link *link)
 				    GFP_KERNEL);
 	if (!link->wr_tx_pends)
 		goto no_mem_wr_tx_mask;
+	link->wr_tx_compl = kcalloc(SMC_WR_BUF_CNT,
+				    sizeof(link->wr_tx_compl[0]),
+				    GFP_KERNEL);
+	if (!link->wr_tx_compl)
+		goto no_mem_wr_tx_pends;
 	return 0;
 
+no_mem_wr_tx_pends:
+	kfree(link->wr_tx_pends);
 no_mem_wr_tx_mask:
 	kfree(link->wr_tx_mask);
 no_mem_wr_rx_sges:
diff --git a/net/smc/smc_wr.h b/net/smc/smc_wr.h
index f7eaeb3391f3..423b8709f1c9 100644
--- a/net/smc/smc_wr.h
+++ b/net/smc/smc_wr.h
@@ -101,6 +101,8 @@ int smc_wr_tx_put_slot(struct smc_link *link,
 		       struct smc_wr_tx_pend_priv *wr_pend_priv);
 int smc_wr_tx_send(struct smc_link *link,
 		   struct smc_wr_tx_pend_priv *wr_pend_priv);
+int smc_wr_tx_send_wait(struct smc_link *link, struct smc_wr_tx_pend_priv *priv,
+			unsigned long timeout);
 void smc_wr_tx_cq_handler(struct ib_cq *ib_cq, void *cq_context);
 void smc_wr_tx_dismiss_slots(struct smc_link *lnk, u8 wr_rx_hdr_type,
 			     smc_wr_tx_filter filter,
-- 
2.17.1

