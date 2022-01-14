Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF4F48E3FB
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 06:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239235AbiANFtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 00:49:05 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:37464 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236473AbiANFtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 00:49:00 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V1nMT1l_1642139337;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V1nMT1l_1642139337)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 14 Jan 2022 13:48:57 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [RFC PATCH net-next 3/6] net/smc: Introduce smc_ib_cq to bind link and cq
Date:   Fri, 14 Jan 2022 13:48:49 +0800
Message-Id: <20220114054852.38058-4-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114054852.38058-1-tonylu@linux.alibaba.com>
References: <20220114054852.38058-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces struct smc_ib_cq as a medium between smc_link and
ib_cq. Every smc_link can access ib_cq from their own, and unbinds
smc_link from smc_ib_device. This allows flexible mapping, prepares for
multiple CQs support.

Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
---
 net/smc/smc_core.h |  2 ++
 net/smc/smc_ib.c   | 52 +++++++++++++++++++++++++++++++++-------------
 net/smc/smc_ib.h   | 14 +++++++++----
 net/smc/smc_wr.c   | 34 +++++++++++++++---------------
 4 files changed, 67 insertions(+), 35 deletions(-)

diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 521c64a3d8d3..fd10cad8fb77 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -86,6 +86,8 @@ struct smc_link {
 	struct ib_pd		*roce_pd;	/* IB protection domain,
 						 * unique for every RoCE QP
 						 */
+	struct smc_ib_cq	*smcibcq_recv;	/* cq for recv */
+	struct smc_ib_cq	*smcibcq_send;	/* cq for send */
 	struct ib_qp		*roce_qp;	/* IB queue pair */
 	struct ib_qp_attr	qp_attr;	/* IB queue pair attributes */
 
diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 9a162810ed8c..b08b9af4c156 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -133,7 +133,7 @@ int smc_ib_ready_link(struct smc_link *lnk)
 	if (rc)
 		goto out;
 	smc_wr_remember_qp_attr(lnk);
-	rc = ib_req_notify_cq(lnk->smcibdev->roce_cq_recv,
+	rc = ib_req_notify_cq(lnk->smcibcq_recv->roce_cq,
 			      IB_CQ_SOLICITED_MASK);
 	if (rc)
 		goto out;
@@ -672,6 +672,8 @@ void smc_ib_destroy_queue_pair(struct smc_link *lnk)
 {
 	if (lnk->roce_qp)
 		ib_destroy_qp(lnk->roce_qp);
+	lnk->smcibcq_send = NULL;
+	lnk->smcibcq_recv = NULL;
 	lnk->roce_qp = NULL;
 }
 
@@ -682,8 +684,8 @@ int smc_ib_create_queue_pair(struct smc_link *lnk)
 	struct ib_qp_init_attr qp_attr = {
 		.event_handler = smc_ib_qp_event_handler,
 		.qp_context = lnk,
-		.send_cq = lnk->smcibdev->roce_cq_send,
-		.recv_cq = lnk->smcibdev->roce_cq_recv,
+		.send_cq = lnk->smcibdev->roce_cq_send->roce_cq,
+		.recv_cq = lnk->smcibdev->roce_cq_recv->roce_cq,
 		.srq = NULL,
 		.cap = {
 				/* include unsolicited rdma_writes as well,
@@ -701,10 +703,13 @@ int smc_ib_create_queue_pair(struct smc_link *lnk)
 
 	lnk->roce_qp = ib_create_qp(lnk->roce_pd, &qp_attr);
 	rc = PTR_ERR_OR_ZERO(lnk->roce_qp);
-	if (IS_ERR(lnk->roce_qp))
+	if (IS_ERR(lnk->roce_qp)) {
 		lnk->roce_qp = NULL;
-	else
+	} else {
+		lnk->smcibcq_send = lnk->smcibdev->roce_cq_send;
+		lnk->smcibcq_recv = lnk->smcibdev->roce_cq_recv;
 		smc_wr_remember_qp_attr(lnk);
+	}
 	return rc;
 }
 
@@ -824,6 +829,7 @@ void smc_ib_buf_unmap_sg(struct smc_link *lnk,
 long smc_ib_setup_per_ibdev(struct smc_ib_device *smcibdev)
 {
 	struct ib_cq_init_attr cqattr =	{ .cqe = SMC_MAX_CQE };
+	struct smc_ib_cq *smcibcq_send, *smcibcq_recv;
 	int cq_send_vector, cq_recv_vector;
 	int cqe_size_order, smc_order;
 	long rc;
@@ -837,34 +843,52 @@ long smc_ib_setup_per_ibdev(struct smc_ib_device *smcibdev)
 	smc_order = MAX_ORDER - cqe_size_order - 1;
 	if (SMC_MAX_CQE + 2 > (0x00000001 << smc_order) * PAGE_SIZE)
 		cqattr.cqe = (0x00000001 << smc_order) * PAGE_SIZE - 2;
+	smcibcq_send = kmalloc(sizeof(*smcibcq_send), GFP_KERNEL);
+	if (!smcibcq_send) {
+		rc = -ENOMEM;
+		goto out;
+	}
 	cq_send_vector = smc_ib_get_least_used_vector(smcibdev);
+	smcibcq_send->smcibdev = smcibdev;
+	smcibcq_send->is_send = 1;
 	cqattr.comp_vector = cq_send_vector;
-	smcibdev->roce_cq_send = ib_create_cq(smcibdev->ibdev,
-					      smc_wr_tx_cq_handler, NULL,
-					      smcibdev, &cqattr);
+	smcibcq_send->roce_cq = ib_create_cq(smcibdev->ibdev,
+					     smc_wr_tx_cq_handler, NULL,
+					     smcibcq_send, &cqattr);
 	rc = PTR_ERR_OR_ZERO(smcibdev->roce_cq_send);
 	if (IS_ERR(smcibdev->roce_cq_send)) {
 		smcibdev->roce_cq_send = NULL;
 		goto err_send;
 	}
+	smcibdev->roce_cq_send = smcibcq_send;
+	smcibcq_recv = kmalloc(sizeof(*smcibcq_recv), GFP_KERNEL);
+	if (!smcibcq_recv) {
+		rc = -ENOMEM;
+		goto err_send;
+	}
 	cq_recv_vector = smc_ib_get_least_used_vector(smcibdev);
+	smcibcq_recv->smcibdev = smcibdev;
+	smcibcq_recv->is_send = 0;
 	cqattr.comp_vector = cq_recv_vector;
-	smcibdev->roce_cq_recv = ib_create_cq(smcibdev->ibdev,
-					      smc_wr_rx_cq_handler, NULL,
-					      smcibdev, &cqattr);
+	smcibcq_recv->roce_cq = ib_create_cq(smcibdev->ibdev,
+					     smc_wr_rx_cq_handler, NULL,
+					     smcibcq_recv, &cqattr);
 	rc = PTR_ERR_OR_ZERO(smcibdev->roce_cq_recv);
 	if (IS_ERR(smcibdev->roce_cq_recv)) {
 		smcibdev->roce_cq_recv = NULL;
 		goto err_recv;
 	}
+	smcibdev->roce_cq_recv = smcibcq_recv;
 	smc_wr_add_dev(smcibdev);
 	smcibdev->initialized = 1;
 	goto out;
 
 err_recv:
+	kfree(smcibcq_recv);
 	smc_ib_put_vector(smcibdev, cq_recv_vector);
-	ib_destroy_cq(smcibdev->roce_cq_send);
+	ib_destroy_cq(smcibcq_send->roce_cq);
 err_send:
+	kfree(smcibcq_send);
 	smc_ib_put_vector(smcibdev, cq_send_vector);
 out:
 	mutex_unlock(&smcibdev->mutex);
@@ -877,8 +901,8 @@ static void smc_ib_cleanup_per_ibdev(struct smc_ib_device *smcibdev)
 	if (!smcibdev->initialized)
 		goto out;
 	smcibdev->initialized = 0;
-	ib_destroy_cq(smcibdev->roce_cq_recv);
-	ib_destroy_cq(smcibdev->roce_cq_send);
+	ib_destroy_cq(smcibdev->roce_cq_recv->roce_cq);
+	ib_destroy_cq(smcibdev->roce_cq_send->roce_cq);
 	smc_wr_remove_dev(smcibdev);
 out:
 	mutex_unlock(&smcibdev->mutex);
diff --git a/net/smc/smc_ib.h b/net/smc/smc_ib.h
index a748b74e56e6..5b34274ecf47 100644
--- a/net/smc/smc_ib.h
+++ b/net/smc/smc_ib.h
@@ -32,15 +32,21 @@ struct smc_ib_devices {			/* list of smc ib devices definition */
 extern struct smc_ib_devices	smc_ib_devices; /* list of smc ib devices */
 extern struct smc_lgr_list smc_lgr_list; /* list of linkgroups */
 
+struct smc_ib_cq {		/* ib_cq wrapper for smc */
+	struct list_head	list;
+	struct smc_ib_device	*smcibdev;	/* parent ib device */
+	struct ib_cq		*roce_cq;	/* real ib_cq for link */
+	struct tasklet_struct	tasklet;	/* tasklet for wr */
+	bool			is_send;	/* send for recv cq */
+};
+
 struct smc_ib_device {				/* ib-device infos for smc */
 	struct list_head	list;
 	struct ib_device	*ibdev;
 	struct ib_port_attr	pattr[SMC_MAX_PORTS];	/* ib dev. port attrs */
 	struct ib_event_handler	event_handler;	/* global ib_event handler */
-	struct ib_cq		*roce_cq_send;	/* send completion queue */
-	struct ib_cq		*roce_cq_recv;	/* recv completion queue */
-	struct tasklet_struct	send_tasklet;	/* called by send cq handler */
-	struct tasklet_struct	recv_tasklet;	/* called by recv cq handler */
+	struct smc_ib_cq	*roce_cq_send;	/* send completion queue */
+	struct smc_ib_cq	*roce_cq_recv;	/* recv completion queue */
 	char			mac[SMC_MAX_PORTS][ETH_ALEN];
 						/* mac address per port*/
 	u8			pnetid[SMC_MAX_PORTS][SMC_MAX_PNETID_LEN];
diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
index 24be1d03fef9..011435efb65b 100644
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@ -135,7 +135,7 @@ static inline void smc_wr_tx_process_cqe(struct ib_wc *wc)
 
 static void smc_wr_tx_tasklet_fn(struct tasklet_struct *t)
 {
-	struct smc_ib_device *dev = from_tasklet(dev, t, send_tasklet);
+	struct smc_ib_cq *smcibcq = from_tasklet(smcibcq, t, tasklet);
 	struct ib_wc wc[SMC_WR_MAX_POLL_CQE];
 	int i = 0, rc;
 	int polled = 0;
@@ -144,9 +144,9 @@ static void smc_wr_tx_tasklet_fn(struct tasklet_struct *t)
 	polled++;
 	do {
 		memset(&wc, 0, sizeof(wc));
-		rc = ib_poll_cq(dev->roce_cq_send, SMC_WR_MAX_POLL_CQE, wc);
+		rc = ib_poll_cq(smcibcq->roce_cq, SMC_WR_MAX_POLL_CQE, wc);
 		if (polled == 1) {
-			ib_req_notify_cq(dev->roce_cq_send,
+			ib_req_notify_cq(smcibcq->roce_cq,
 					 IB_CQ_NEXT_COMP |
 					 IB_CQ_REPORT_MISSED_EVENTS);
 		}
@@ -161,9 +161,9 @@ static void smc_wr_tx_tasklet_fn(struct tasklet_struct *t)
 
 void smc_wr_tx_cq_handler(struct ib_cq *ib_cq, void *cq_context)
 {
-	struct smc_ib_device *dev = (struct smc_ib_device *)cq_context;
+	struct smc_ib_cq *smcibcq = (struct smc_ib_cq *)cq_context;
 
-	tasklet_schedule(&dev->send_tasklet);
+	tasklet_schedule(&smcibcq->tasklet);
 }
 
 /*---------------------------- request submission ---------------------------*/
@@ -306,7 +306,7 @@ int smc_wr_tx_send(struct smc_link *link, struct smc_wr_tx_pend_priv *priv)
 	struct smc_wr_tx_pend *pend;
 	int rc;
 
-	ib_req_notify_cq(link->smcibdev->roce_cq_send,
+	ib_req_notify_cq(link->smcibcq_send->roce_cq,
 			 IB_CQ_NEXT_COMP | IB_CQ_REPORT_MISSED_EVENTS);
 	pend = container_of(priv, struct smc_wr_tx_pend, priv);
 	rc = ib_post_send(link->roce_qp, &link->wr_tx_ibs[pend->idx], NULL);
@@ -323,7 +323,7 @@ int smc_wr_tx_v2_send(struct smc_link *link, struct smc_wr_tx_pend_priv *priv,
 	int rc;
 
 	link->wr_tx_v2_ib->sg_list[0].length = len;
-	ib_req_notify_cq(link->smcibdev->roce_cq_send,
+	ib_req_notify_cq(link->smcibcq_send->roce_cq,
 			 IB_CQ_NEXT_COMP | IB_CQ_REPORT_MISSED_EVENTS);
 	rc = ib_post_send(link->roce_qp, link->wr_tx_v2_ib, NULL);
 	if (rc) {
@@ -367,7 +367,7 @@ int smc_wr_reg_send(struct smc_link *link, struct ib_mr *mr)
 {
 	int rc;
 
-	ib_req_notify_cq(link->smcibdev->roce_cq_send,
+	ib_req_notify_cq(link->smcibcq_send->roce_cq,
 			 IB_CQ_NEXT_COMP | IB_CQ_REPORT_MISSED_EVENTS);
 	link->wr_reg_state = POSTED;
 	link->wr_reg.wr.wr_id = (u64)(uintptr_t)mr;
@@ -476,7 +476,7 @@ static inline void smc_wr_rx_process_cqes(struct ib_wc wc[], int num)
 
 static void smc_wr_rx_tasklet_fn(struct tasklet_struct *t)
 {
-	struct smc_ib_device *dev = from_tasklet(dev, t, recv_tasklet);
+	struct smc_ib_cq *smcibcq = from_tasklet(smcibcq, t, tasklet);
 	struct ib_wc wc[SMC_WR_MAX_POLL_CQE];
 	int polled = 0;
 	int rc;
@@ -485,9 +485,9 @@ static void smc_wr_rx_tasklet_fn(struct tasklet_struct *t)
 	polled++;
 	do {
 		memset(&wc, 0, sizeof(wc));
-		rc = ib_poll_cq(dev->roce_cq_recv, SMC_WR_MAX_POLL_CQE, wc);
+		rc = ib_poll_cq(smcibcq->roce_cq, SMC_WR_MAX_POLL_CQE, wc);
 		if (polled == 1) {
-			ib_req_notify_cq(dev->roce_cq_recv,
+			ib_req_notify_cq(smcibcq->roce_cq,
 					 IB_CQ_SOLICITED_MASK
 					 | IB_CQ_REPORT_MISSED_EVENTS);
 		}
@@ -501,9 +501,9 @@ static void smc_wr_rx_tasklet_fn(struct tasklet_struct *t)
 
 void smc_wr_rx_cq_handler(struct ib_cq *ib_cq, void *cq_context)
 {
-	struct smc_ib_device *dev = (struct smc_ib_device *)cq_context;
+	struct smc_ib_cq *smcibcq = (struct smc_ib_cq *)cq_context;
 
-	tasklet_schedule(&dev->recv_tasklet);
+	tasklet_schedule(&smcibcq->tasklet);
 }
 
 int smc_wr_rx_post_init(struct smc_link *link)
@@ -830,14 +830,14 @@ int smc_wr_alloc_link_mem(struct smc_link *link)
 
 void smc_wr_remove_dev(struct smc_ib_device *smcibdev)
 {
-	tasklet_kill(&smcibdev->recv_tasklet);
-	tasklet_kill(&smcibdev->send_tasklet);
+	tasklet_kill(&smcibdev->roce_cq_recv->tasklet);
+	tasklet_kill(&smcibdev->roce_cq_send->tasklet);
 }
 
 void smc_wr_add_dev(struct smc_ib_device *smcibdev)
 {
-	tasklet_setup(&smcibdev->recv_tasklet, smc_wr_rx_tasklet_fn);
-	tasklet_setup(&smcibdev->send_tasklet, smc_wr_tx_tasklet_fn);
+	tasklet_setup(&smcibdev->roce_cq_recv->tasklet, smc_wr_rx_tasklet_fn);
+	tasklet_setup(&smcibdev->roce_cq_send->tasklet, smc_wr_tx_tasklet_fn);
 }
 
 int smc_wr_create_link(struct smc_link *lnk)
-- 
2.32.0.3.g01195cf9f

