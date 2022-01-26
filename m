Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6796949CA4A
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 14:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbiAZNDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 08:03:02 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:53101 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232334AbiAZNDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 08:03:00 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V2vbaVl_1643202175;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V2vbaVl_1643202175)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 26 Jan 2022 21:02:56 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH net-next 2/2] net/smc: Multiple CQs per IB devices
Date:   Wed, 26 Jan 2022 21:01:43 +0800
Message-Id: <20220126130140.66316-3-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126130140.66316-1-tonylu@linux.alibaba.com>
References: <20220126130140.66316-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows multiple CQs for one IB device, compared to one CQ now.

During IB device setup, it would initialize ibdev->num_comp_vectors
amount of send/recv CQs, and the corresponding tasklets, like queues for
net devices.

Every smc_link has their own send and recv CQs, which always assigning
from the least used CQs of current IB device.

Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
---
 net/smc/smc_ib.c | 139 +++++++++++++++++++++++++++++++----------------
 net/smc/smc_ib.h |   6 +-
 net/smc/smc_wr.c |  18 ++++--
 3 files changed, 111 insertions(+), 52 deletions(-)

diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 0d98cf440adc..5d2fce0a7796 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -625,6 +625,36 @@ int smcr_nl_get_device(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
+static struct smc_ib_cq *smc_ib_get_least_used_cq(struct smc_ib_device *smcibdev,
+						  bool is_send)
+{
+	struct smc_ib_cq *smcibcq, *cq;
+	int min, i;
+
+	if (is_send)
+		smcibcq = smcibdev->smcibcq_send;
+	else
+		smcibcq = smcibdev->smcibcq_recv;
+
+	cq = smcibcq;
+	min = cq->load;
+
+	for (i = 0; i < smcibdev->num_cq_peer; i++) {
+		if (smcibcq[i].load < min) {
+			cq = &smcibcq[i];
+			min = cq->load;
+		}
+	}
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
@@ -648,8 +678,11 @@ static void smc_ib_qp_event_handler(struct ib_event *ibevent, void *priv)
 
 void smc_ib_destroy_queue_pair(struct smc_link *lnk)
 {
-	if (lnk->roce_qp)
+	if (lnk->roce_qp) {
 		ib_destroy_qp(lnk->roce_qp);
+		smc_ib_put_cq(lnk->smcibcq_send);
+		smc_ib_put_cq(lnk->smcibcq_recv);
+	}
 	lnk->roce_qp = NULL;
 	lnk->smcibcq_send = NULL;
 	lnk->smcibcq_recv = NULL;
@@ -658,12 +691,16 @@ void smc_ib_destroy_queue_pair(struct smc_link *lnk)
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
-		.send_cq = lnk->smcibdev->ib_cq_send->ib_cq,
-		.recv_cq = lnk->smcibdev->ib_cq_recv->ib_cq,
+		.send_cq = smcibcq_send->ib_cq,
+		.recv_cq = smcibcq_recv->ib_cq,
 		.srq = NULL,
 		.cap = {
 				/* include unsolicited rdma_writes as well,
@@ -684,8 +721,8 @@ int smc_ib_create_queue_pair(struct smc_link *lnk)
 	if (IS_ERR(lnk->roce_qp)) {
 		lnk->roce_qp = NULL;
 	} else {
-		lnk->smcibcq_send = lnk->smcibdev->ib_cq_send;
-		lnk->smcibcq_recv = lnk->smcibdev->ib_cq_recv;
+		lnk->smcibcq_send = smcibcq_send;
+		lnk->smcibcq_recv = smcibcq_recv;
 		smc_wr_remember_qp_attr(lnk);
 	}
 	return rc;
@@ -806,20 +843,26 @@ void smc_ib_buf_unmap_sg(struct smc_link *lnk,
 
 static void smc_ib_cleanup_cq(struct smc_ib_device *smcibdev)
 {
-	ib_destroy_cq(smcibdev->ib_cq_send->ib_cq);
-	kfree(smcibdev->ib_cq_send);
-	smcibdev->ib_cq_send = NULL;
+	int i;
+
+	for (i = 0; i < smcibdev->num_cq_peer; i++) {
+		if (smcibdev->smcibcq_send[i].ib_cq)
+			ib_destroy_cq(smcibdev->smcibcq_send[i].ib_cq);
+
+		if (smcibdev->smcibcq_recv[i].ib_cq)
+			ib_destroy_cq(smcibdev->smcibcq_recv[i].ib_cq);
+	}
 
-	ib_destroy_cq(smcibdev->ib_cq_recv->ib_cq);
-	kfree(smcibdev->ib_cq_recv);
-	smcibdev->ib_cq_recv = NULL;
+	kfree(smcibdev->smcibcq_send);
+	kfree(smcibdev->smcibcq_recv);
 }
 
 long smc_ib_setup_per_ibdev(struct smc_ib_device *smcibdev)
 {
 	struct ib_cq_init_attr cqattr =	{ .cqe = SMC_MAX_CQE };
-	struct smc_ib_cq *smcibcq_send, *smcibcq_recv;
 	int cqe_size_order, smc_order;
+	struct smc_ib_cq *smcibcq;
+	int i, num_cq_peer;
 	long rc;
 
 	mutex_lock(&smcibdev->mutex);
@@ -832,49 +875,53 @@ long smc_ib_setup_per_ibdev(struct smc_ib_device *smcibdev)
 	if (SMC_MAX_CQE + 2 > (0x00000001 << smc_order) * PAGE_SIZE)
 		cqattr.cqe = (0x00000001 << smc_order) * PAGE_SIZE - 2;
 
-	smcibcq_send = kzalloc(sizeof(*smcibcq_send), GFP_KERNEL);
-	if (!smcibcq_send) {
+	num_cq_peer = min_t(int, smcibdev->ibdev->num_comp_vectors,
+			    num_online_cpus());
+	smcibdev->num_cq_peer = num_cq_peer;
+	smcibdev->smcibcq_send = kcalloc(num_cq_peer, sizeof(*smcibcq),
+					 GFP_KERNEL);
+	if (!smcibdev->smcibcq_send) {
 		rc = -ENOMEM;
-		goto out;
-	}
-	smcibcq_send->smcibdev = smcibdev;
-	smcibcq_send->is_send = 1;
-	cqattr.comp_vector = 0;
-	smcibcq_send->ib_cq = ib_create_cq(smcibdev->ibdev,
-					   smc_wr_tx_cq_handler, NULL,
-					   smcibcq_send, &cqattr);
-	rc = PTR_ERR_OR_ZERO(smcibdev->ib_cq_send);
-	if (IS_ERR(smcibdev->ib_cq_send)) {
-		smcibdev->ib_cq_send = NULL;
-		goto out;
+		goto err;
 	}
-	smcibdev->ib_cq_send = smcibcq_send;
-
-	smcibcq_recv = kzalloc(sizeof(*smcibcq_recv), GFP_KERNEL);
-	if (!smcibcq_recv) {
+	smcibdev->smcibcq_recv = kcalloc(num_cq_peer, sizeof(*smcibcq),
+					 GFP_KERNEL);
+	if (!smcibdev->smcibcq_recv) {
 		rc = -ENOMEM;
-		goto err_send;
+		goto err;
 	}
-	smcibcq_recv->smcibdev = smcibdev;
-	cqattr.comp_vector = 1;
-	smcibcq_recv->ib_cq = ib_create_cq(smcibdev->ibdev,
-					   smc_wr_rx_cq_handler, NULL,
-					   smcibcq_recv, &cqattr);
-	rc = PTR_ERR_OR_ZERO(smcibdev->ib_cq_recv);
-	if (IS_ERR(smcibdev->ib_cq_recv)) {
-		smcibdev->ib_cq_recv = NULL;
-		goto err_recv;
+
+	/* initialize CQs */
+	for (i = 0; i < num_cq_peer; i++) {
+		/* initialize send CQ */
+		smcibcq = &smcibdev->smcibcq_send[i];
+		smcibcq->smcibdev = smcibdev;
+		smcibcq->is_send = 1;
+		cqattr.comp_vector = i;
+		smcibcq->ib_cq = ib_create_cq(smcibdev->ibdev,
+					      smc_wr_tx_cq_handler, NULL,
+					      smcibcq, &cqattr);
+		rc = PTR_ERR_OR_ZERO(smcibcq->ib_cq);
+		if (IS_ERR(smcibcq->ib_cq))
+			goto err;
+
+		/* initialize recv CQ */
+		smcibcq = &smcibdev->smcibcq_recv[i];
+		smcibcq->smcibdev = smcibdev;
+		cqattr.comp_vector = num_cq_peer - 1 - i; /* reverse to spread snd/rcv */
+		smcibcq->ib_cq = ib_create_cq(smcibdev->ibdev,
+					      smc_wr_rx_cq_handler, NULL,
+					      smcibcq, &cqattr);
+		rc = PTR_ERR_OR_ZERO(smcibcq->ib_cq);
+		if (IS_ERR(smcibcq->ib_cq))
+			goto err;
 	}
-	smcibdev->ib_cq_recv = smcibcq_recv;
 	smc_wr_add_dev(smcibdev);
 	smcibdev->initialized = 1;
 	goto out;
 
-err_recv:
-	kfree(smcibcq_recv);
-	ib_destroy_cq(smcibcq_send->ib_cq);
-err_send:
-	kfree(smcibcq_send);
+err:
+	smc_ib_cleanup_cq(smcibdev);
 out:
 	mutex_unlock(&smcibdev->mutex);
 	return rc;
diff --git a/net/smc/smc_ib.h b/net/smc/smc_ib.h
index 1dc567599977..d303b0717c3f 100644
--- a/net/smc/smc_ib.h
+++ b/net/smc/smc_ib.h
@@ -37,6 +37,7 @@ struct smc_ib_cq {		/* ib_cq wrapper for smc */
 	struct ib_cq		*ib_cq;		/* real ib_cq for link */
 	struct tasklet_struct	tasklet;	/* tasklet for wr */
 	bool			is_send;	/* send for recv cq */
+	int			load;		/* load of current cq */
 };
 
 struct smc_ib_device {				/* ib-device infos for smc */
@@ -44,8 +45,9 @@ struct smc_ib_device {				/* ib-device infos for smc */
 	struct ib_device	*ibdev;
 	struct ib_port_attr	pattr[SMC_MAX_PORTS];	/* ib dev. port attrs */
 	struct ib_event_handler	event_handler;	/* global ib_event handler */
-	struct smc_ib_cq	*ib_cq_send;	/* send completion queue */
-	struct smc_ib_cq	*ib_cq_recv;	/* recv completion queue */
+	int			num_cq_peer;	/* num of snd/rcv cq peer */
+	struct smc_ib_cq	*smcibcq_send;	/* send cqs */
+	struct smc_ib_cq	*smcibcq_recv;	/* recv cqs */
 	char			mac[SMC_MAX_PORTS][ETH_ALEN];
 						/* mac address per port*/
 	u8			pnetid[SMC_MAX_PORTS][SMC_MAX_PNETID_LEN];
diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
index ddb0ba67a851..24014c9924b1 100644
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@ -830,14 +830,24 @@ int smc_wr_alloc_link_mem(struct smc_link *link)
 
 void smc_wr_remove_dev(struct smc_ib_device *smcibdev)
 {
-	tasklet_kill(&smcibdev->ib_cq_recv->tasklet);
-	tasklet_kill(&smcibdev->ib_cq_send->tasklet);
+	int i;
+
+	for (i = 0; i < smcibdev->num_cq_peer; i++) {
+		tasklet_kill(&smcibdev->smcibcq_send[i].tasklet);
+		tasklet_kill(&smcibdev->smcibcq_recv[i].tasklet);
+	}
 }
 
 void smc_wr_add_dev(struct smc_ib_device *smcibdev)
 {
-	tasklet_setup(&smcibdev->ib_cq_recv->tasklet, smc_wr_rx_tasklet_fn);
-	tasklet_setup(&smcibdev->ib_cq_send->tasklet, smc_wr_tx_tasklet_fn);
+	int i;
+
+	for (i = 0; i < smcibdev->num_cq_peer; i++) {
+		tasklet_setup(&smcibdev->smcibcq_send[i].tasklet,
+			      smc_wr_tx_tasklet_fn);
+		tasklet_setup(&smcibdev->smcibcq_recv[i].tasklet,
+			      smc_wr_rx_tasklet_fn);
+	}
 }
 
 int smc_wr_create_link(struct smc_link *lnk)
-- 
2.32.0.3.g01195cf9f

