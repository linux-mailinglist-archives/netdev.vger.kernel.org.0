Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2D548E3F8
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 06:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239227AbiANFtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 00:49:03 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:58375 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236524AbiANFtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 00:49:00 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V1nM4fQ_1642139338;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V1nM4fQ_1642139338)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 14 Jan 2022 13:48:58 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [RFC PATCH net-next 4/6] net/smc: Multiple CQs per IB devices
Date:   Fri, 14 Jan 2022 13:48:50 +0800
Message-Id: <20220114054852.38058-5-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114054852.38058-1-tonylu@linux.alibaba.com>
References: <20220114054852.38058-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows multiple CQs for one IB device, compared to one CQ
now.

During IB device setup, it would initialize ibdev->num_comp_vectors
amount of send/recv CQs, and the corresponding tasklets, like queues for
net devices.

Every smc_link has their own send and recv CQs, which always assigning
from the least used CQs of current IB device.

Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
---
 net/smc/smc_ib.c | 165 +++++++++++++++++++++++++++++++++--------------
 net/smc/smc_ib.h |   6 +-
 net/smc/smc_wr.c |  16 +++--
 3 files changed, 132 insertions(+), 55 deletions(-)

diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index b08b9af4c156..19c49184cd03 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -647,6 +647,38 @@ static void smc_ib_put_vector(struct smc_ib_device *smcibdev, int index)
 	smcibdev->vector_load[index]--;
 }
 
+static struct smc_ib_cq *smc_ib_get_least_used_cq(struct smc_ib_device *smcibdev,
+						  bool is_send)
+{
+	struct smc_ib_cq *smcibcq, *cq;
+	struct list_head *head;
+	int min;
+
+	if (is_send)
+		head = &smcibdev->smcibcq_send;
+	else
+		head = &smcibdev->smcibcq_recv;
+	cq = list_first_entry(head, struct smc_ib_cq, list);
+	min = cq->load;
+
+	list_for_each_entry(smcibcq, head, list) {
+		if (smcibcq->load < min) {
+			cq = smcibcq;
+			min = cq->load;
+		}
+	}
+	if (!cq)
+		cq = smcibcq;
+
+	cq->load++;
+	return cq;
+}
+
+static void smc_ib_put_cq(struct smc_ib_cq *smcibcq)
+{
+	smcibcq->load--;
+}
+
 static void smc_ib_qp_event_handler(struct ib_event *ibevent, void *priv)
 {
 	struct smc_link *lnk = (struct smc_link *)priv;
@@ -670,8 +702,11 @@ static void smc_ib_qp_event_handler(struct ib_event *ibevent, void *priv)
 
 void smc_ib_destroy_queue_pair(struct smc_link *lnk)
 {
-	if (lnk->roce_qp)
+	if (lnk->roce_qp) {
 		ib_destroy_qp(lnk->roce_qp);
+		smc_ib_put_cq(lnk->smcibcq_send);
+		smc_ib_put_cq(lnk->smcibcq_recv);
+	}
 	lnk->smcibcq_send = NULL;
 	lnk->smcibcq_recv = NULL;
 	lnk->roce_qp = NULL;
@@ -680,12 +715,16 @@ void smc_ib_destroy_queue_pair(struct smc_link *lnk)
 /* create a queue pair within the protection domain for a link */
 int smc_ib_create_queue_pair(struct smc_link *lnk)
 {
+	struct smc_ib_cq *smcibcq_send = smc_ib_get_least_used_cq(lnk->smcibdev,
+								  true);
+	struct smc_ib_cq *smcibcq_recv = smc_ib_get_least_used_cq(lnk->smcibdev,
+								  false);
 	int sges_per_buf = (lnk->lgr->smc_version == SMC_V2) ? 2 : 1;
 	struct ib_qp_init_attr qp_attr = {
 		.event_handler = smc_ib_qp_event_handler,
 		.qp_context = lnk,
-		.send_cq = lnk->smcibdev->roce_cq_send->roce_cq,
-		.recv_cq = lnk->smcibdev->roce_cq_recv->roce_cq,
+		.send_cq = smcibcq_send->roce_cq,
+		.recv_cq = smcibcq_recv->roce_cq,
 		.srq = NULL,
 		.cap = {
 				/* include unsolicited rdma_writes as well,
@@ -706,8 +745,8 @@ int smc_ib_create_queue_pair(struct smc_link *lnk)
 	if (IS_ERR(lnk->roce_qp)) {
 		lnk->roce_qp = NULL;
 	} else {
-		lnk->smcibcq_send = lnk->smcibdev->roce_cq_send;
-		lnk->smcibcq_recv = lnk->smcibdev->roce_cq_recv;
+		lnk->smcibcq_send = smcibcq_send;
+		lnk->smcibcq_recv = smcibcq_recv;
 		smc_wr_remember_qp_attr(lnk);
 	}
 	return rc;
@@ -826,6 +865,24 @@ void smc_ib_buf_unmap_sg(struct smc_link *lnk,
 	buf_slot->sgt[lnk->link_idx].sgl->dma_address = 0;
 }
 
+static void smc_ib_cleanup_cq(struct smc_ib_device *smcibdev)
+{
+	struct smc_ib_cq *smcibcq, *cq;
+
+	list_for_each_entry_safe(smcibcq, cq, &smcibdev->smcibcq_send, list) {
+		list_del(&smcibcq->list);
+		ib_destroy_cq(smcibcq->roce_cq);
+		smc_ib_put_vector(smcibdev, smcibcq->comp_vector);
+		kfree(smcibcq);
+	}
+	list_for_each_entry_safe(smcibcq, cq, &smcibdev->smcibcq_recv, list) {
+		list_del(&smcibcq->list);
+		ib_destroy_cq(smcibcq->roce_cq);
+		smc_ib_put_vector(smcibdev, smcibcq->comp_vector);
+		kfree(smcibcq);
+	}
+}
+
 long smc_ib_setup_per_ibdev(struct smc_ib_device *smcibdev)
 {
 	struct ib_cq_init_attr cqattr =	{ .cqe = SMC_MAX_CQE };
@@ -833,6 +890,7 @@ long smc_ib_setup_per_ibdev(struct smc_ib_device *smcibdev)
 	int cq_send_vector, cq_recv_vector;
 	int cqe_size_order, smc_order;
 	long rc;
+	int i;
 
 	mutex_lock(&smcibdev->mutex);
 	rc = 0;
@@ -843,53 +901,61 @@ long smc_ib_setup_per_ibdev(struct smc_ib_device *smcibdev)
 	smc_order = MAX_ORDER - cqe_size_order - 1;
 	if (SMC_MAX_CQE + 2 > (0x00000001 << smc_order) * PAGE_SIZE)
 		cqattr.cqe = (0x00000001 << smc_order) * PAGE_SIZE - 2;
-	smcibcq_send = kmalloc(sizeof(*smcibcq_send), GFP_KERNEL);
-	if (!smcibcq_send) {
-		rc = -ENOMEM;
-		goto out;
-	}
-	cq_send_vector = smc_ib_get_least_used_vector(smcibdev);
-	smcibcq_send->smcibdev = smcibdev;
-	smcibcq_send->is_send = 1;
-	cqattr.comp_vector = cq_send_vector;
-	smcibcq_send->roce_cq = ib_create_cq(smcibdev->ibdev,
-					     smc_wr_tx_cq_handler, NULL,
-					     smcibcq_send, &cqattr);
-	rc = PTR_ERR_OR_ZERO(smcibdev->roce_cq_send);
-	if (IS_ERR(smcibdev->roce_cq_send)) {
-		smcibdev->roce_cq_send = NULL;
-		goto err_send;
-	}
-	smcibdev->roce_cq_send = smcibcq_send;
-	smcibcq_recv = kmalloc(sizeof(*smcibcq_recv), GFP_KERNEL);
-	if (!smcibcq_recv) {
-		rc = -ENOMEM;
-		goto err_send;
-	}
-	cq_recv_vector = smc_ib_get_least_used_vector(smcibdev);
-	smcibcq_recv->smcibdev = smcibdev;
-	smcibcq_recv->is_send = 0;
-	cqattr.comp_vector = cq_recv_vector;
-	smcibcq_recv->roce_cq = ib_create_cq(smcibdev->ibdev,
-					     smc_wr_rx_cq_handler, NULL,
-					     smcibcq_recv, &cqattr);
-	rc = PTR_ERR_OR_ZERO(smcibdev->roce_cq_recv);
-	if (IS_ERR(smcibdev->roce_cq_recv)) {
-		smcibdev->roce_cq_recv = NULL;
-		goto err_recv;
+
+	/* initialize send/recv CQs */
+	for (i = 0; i < smcibdev->ibdev->num_comp_vectors; i++) {
+		/* initialize send CQ */
+		smcibcq_send = kmalloc(sizeof(*smcibcq_send), GFP_KERNEL);
+		if (!smcibcq_send) {
+			rc = -ENOMEM;
+			goto err;
+		}
+		cq_send_vector = smc_ib_get_least_used_vector(smcibdev);
+		smcibcq_send->smcibdev = smcibdev;
+		smcibcq_send->load = 0;
+		smcibcq_send->is_send = 1;
+		smcibcq_send->comp_vector = cq_send_vector;
+		INIT_LIST_HEAD(&smcibcq_send->list);
+		cqattr.comp_vector = cq_send_vector;
+		smcibcq_send->roce_cq = ib_create_cq(smcibdev->ibdev,
+						     smc_wr_tx_cq_handler, NULL,
+						     smcibcq_send, &cqattr);
+		rc = PTR_ERR_OR_ZERO(smcibcq_send->roce_cq);
+		if (IS_ERR(smcibcq_send->roce_cq)) {
+			smcibcq_send->roce_cq = NULL;
+			goto err;
+		}
+		list_add_tail(&smcibcq_send->list, &smcibdev->smcibcq_send);
+
+		/* initialize recv CQ */
+		smcibcq_recv = kmalloc(sizeof(*smcibcq_recv), GFP_KERNEL);
+		if (!smcibcq_recv) {
+			rc = -ENOMEM;
+			goto err;
+		}
+		cq_recv_vector = smc_ib_get_least_used_vector(smcibdev);
+		smcibcq_recv->smcibdev = smcibdev;
+		smcibcq_recv->load = 0;
+		smcibcq_recv->is_send = 0;
+		smcibcq_recv->comp_vector = cq_recv_vector;
+		INIT_LIST_HEAD(&smcibcq_recv->list);
+		cqattr.comp_vector = cq_recv_vector;
+		smcibcq_recv->roce_cq = ib_create_cq(smcibdev->ibdev,
+						     smc_wr_rx_cq_handler, NULL,
+						     smcibcq_recv, &cqattr);
+		rc = PTR_ERR_OR_ZERO(smcibcq_recv->roce_cq);
+		if (IS_ERR(smcibcq_recv->roce_cq)) {
+			smcibcq_recv->roce_cq = NULL;
+			goto err;
+		}
+		list_add_tail(&smcibcq_recv->list, &smcibdev->smcibcq_recv);
 	}
-	smcibdev->roce_cq_recv = smcibcq_recv;
 	smc_wr_add_dev(smcibdev);
 	smcibdev->initialized = 1;
 	goto out;
 
-err_recv:
-	kfree(smcibcq_recv);
-	smc_ib_put_vector(smcibdev, cq_recv_vector);
-	ib_destroy_cq(smcibcq_send->roce_cq);
-err_send:
-	kfree(smcibcq_send);
-	smc_ib_put_vector(smcibdev, cq_send_vector);
+err:
+	smc_ib_cleanup_cq(smcibdev);
 out:
 	mutex_unlock(&smcibdev->mutex);
 	return rc;
@@ -901,8 +967,7 @@ static void smc_ib_cleanup_per_ibdev(struct smc_ib_device *smcibdev)
 	if (!smcibdev->initialized)
 		goto out;
 	smcibdev->initialized = 0;
-	ib_destroy_cq(smcibdev->roce_cq_recv->roce_cq);
-	ib_destroy_cq(smcibdev->roce_cq_send->roce_cq);
+	smc_ib_cleanup_cq(smcibdev);
 	smc_wr_remove_dev(smcibdev);
 out:
 	mutex_unlock(&smcibdev->mutex);
@@ -978,6 +1043,8 @@ static int smc_ib_add_dev(struct ib_device *ibdev)
 	INIT_IB_EVENT_HANDLER(&smcibdev->event_handler, smcibdev->ibdev,
 			      smc_ib_global_event_handler);
 	ib_register_event_handler(&smcibdev->event_handler);
+	INIT_LIST_HEAD(&smcibdev->smcibcq_send);
+	INIT_LIST_HEAD(&smcibdev->smcibcq_recv);
 	/* vector's load per ib device */
 	smcibdev->vector_load = kcalloc(ibdev->num_comp_vectors,
 					sizeof(int), GFP_KERNEL);
diff --git a/net/smc/smc_ib.h b/net/smc/smc_ib.h
index 5b34274ecf47..1776627f113d 100644
--- a/net/smc/smc_ib.h
+++ b/net/smc/smc_ib.h
@@ -38,6 +38,8 @@ struct smc_ib_cq {		/* ib_cq wrapper for smc */
 	struct ib_cq		*roce_cq;	/* real ib_cq for link */
 	struct tasklet_struct	tasklet;	/* tasklet for wr */
 	bool			is_send;	/* send for recv cq */
+	int			comp_vector;	/* index of completion vector */
+	int			load;		/* load of current cq */
 };
 
 struct smc_ib_device {				/* ib-device infos for smc */
@@ -45,8 +47,8 @@ struct smc_ib_device {				/* ib-device infos for smc */
 	struct ib_device	*ibdev;
 	struct ib_port_attr	pattr[SMC_MAX_PORTS];	/* ib dev. port attrs */
 	struct ib_event_handler	event_handler;	/* global ib_event handler */
-	struct smc_ib_cq	*roce_cq_send;	/* send completion queue */
-	struct smc_ib_cq	*roce_cq_recv;	/* recv completion queue */
+	struct list_head	smcibcq_send;	/* all send cqs */
+	struct list_head	smcibcq_recv;	/* all recv cqs */
 	char			mac[SMC_MAX_PORTS][ETH_ALEN];
 						/* mac address per port*/
 	u8			pnetid[SMC_MAX_PORTS][SMC_MAX_PNETID_LEN];
diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
index 011435efb65b..169253e53786 100644
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@ -830,14 +830,22 @@ int smc_wr_alloc_link_mem(struct smc_link *link)
 
 void smc_wr_remove_dev(struct smc_ib_device *smcibdev)
 {
-	tasklet_kill(&smcibdev->roce_cq_recv->tasklet);
-	tasklet_kill(&smcibdev->roce_cq_send->tasklet);
+	struct smc_ib_cq *smcibcq;
+
+	list_for_each_entry(smcibcq, &smcibdev->smcibcq_send, list)
+		tasklet_kill(&smcibcq->tasklet);
+	list_for_each_entry(smcibcq, &smcibdev->smcibcq_recv, list)
+		tasklet_kill(&smcibcq->tasklet);
 }
 
 void smc_wr_add_dev(struct smc_ib_device *smcibdev)
 {
-	tasklet_setup(&smcibdev->roce_cq_recv->tasklet, smc_wr_rx_tasklet_fn);
-	tasklet_setup(&smcibdev->roce_cq_send->tasklet, smc_wr_tx_tasklet_fn);
+	struct smc_ib_cq *smcibcq;
+
+	list_for_each_entry(smcibcq, &smcibdev->smcibcq_send, list)
+		tasklet_setup(&smcibcq->tasklet, smc_wr_tx_tasklet_fn);
+	list_for_each_entry(smcibcq, &smcibdev->smcibcq_recv, list)
+		tasklet_setup(&smcibcq->tasklet, smc_wr_rx_tasklet_fn);
 }
 
 int smc_wr_create_link(struct smc_link *lnk)
-- 
2.32.0.3.g01195cf9f

