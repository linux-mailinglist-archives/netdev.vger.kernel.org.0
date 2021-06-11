Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 856873A3D4A
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 09:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbhFKHhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 03:37:39 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40494 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230469AbhFKHhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 03:37:38 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15B7Zc56145084;
        Fri, 11 Jun 2021 03:35:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=aybAxtICUf9xNF2wjYESdvuO0RgqnX4pLiVDqn2WmIs=;
 b=WXv75UK0MhJzIfkNAVs6slkt+/rrSOl5bkm2xSLQr0giVxQj6O9P9TU9LGdpvitjifPF
 wc4OoO5pya32PJhGc0BzC4x9nZ1fvDLBQZRQsQNH74uCYxZ01jalp4H1n8H3ZCXyJoj/
 MPDnWbZkHsOHuXeB/Pn3sN1vShQKqr4CMnIREnxl1AIBUYZpgIW/ofux1Eq6eQJGP83a
 +/nCN4Z0dSfFMK/caHtZDbLWYkKye6+2sLx2D+WaCyJvTsbqex2Zd1GVNzQ9X8E8mX0A
 Z7wFBIDN+SB6S4tPF4evHne71RBCZalSaTW11jQ9Z15/auHkY3lfDgMgyUMkqqbb5wAi 1g== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3943gf01qh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 03:35:39 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15B7WjON029212;
        Fri, 11 Jun 2021 07:33:54 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 3900w89ts2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 07:33:54 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15B7WrTO25952610
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 07:32:54 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6771A4069;
        Fri, 11 Jun 2021 07:33:48 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70D57A406B;
        Fri, 11 Jun 2021 07:33:48 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 11 Jun 2021 07:33:48 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 2/9] s390/qeth: also use TX NAPI for non-IQD devices
Date:   Fri, 11 Jun 2021 09:33:34 +0200
Message-Id: <20210611073341.1634501-3-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611073341.1634501-1-jwi@linux.ibm.com>
References: <20210611073341.1634501-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1UhC2ujsWC-cV1prgVzTzPdWC-jT5wHB
X-Proofpoint-GUID: 1UhC2ujsWC-cV1prgVzTzPdWC-jT5wHB
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-11_01:2021-06-11,2021-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 suspectscore=0 clxscore=1015 mlxscore=0
 impostorscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106110048
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set scan_threshold = 0 to opt out from the qdio layer's internal tasklet
& timer mechanism for TX completions, and replace it with the TX NAPI
infrastructure that qeth already uses for IQD devices. This avoids the
fragile logic in qdio_check_output_queue(), enables tighter integration
and gives us more tuning options via ethtool in the future.

For now we continue to apply the same policy as the qdio layer:
scan for completions if 32 TX buffers are in use, or after 1 sec.
A re-scan is done after 10 sec, but only if no TX interrupt is pending.

With scan_threshold = 0 we no longer get TX completion scans from
within qdio_get_next_buffers(). So trigger these manually in qeth_poll()
and in the RX path switch to the equivalent qdio_inspect_queue().

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |   6 ++
 drivers/s390/net/qeth_core_main.c | 148 +++++++++++++++---------------
 2 files changed, 79 insertions(+), 75 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 3a49ef8dd906..4d29801bcf41 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -527,6 +527,7 @@ struct qeth_qdio_out_q {
 
 	unsigned int coalesce_usecs;
 	unsigned int max_coalesced_frames;
+	unsigned int rescan_usecs;
 };
 
 #define qeth_for_each_output_queue(card, q, i)		\
@@ -887,6 +888,11 @@ static inline bool qeth_card_hw_is_reachable(struct qeth_card *card)
 	return card->state == CARD_STATE_SOFTSETUP;
 }
 
+static inline bool qeth_use_tx_irqs(struct qeth_card *card)
+{
+	return !IS_IQD(card);
+}
+
 static inline void qeth_unlock_channel(struct qeth_card *card,
 				       struct qeth_channel *channel)
 {
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 9085f22ca34c..f22f223a4a6c 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -2665,8 +2665,15 @@ static int qeth_alloc_qdio_queues(struct qeth_card *card)
 		INIT_LIST_HEAD(&queue->pending_bufs);
 		spin_lock_init(&queue->lock);
 		timer_setup(&queue->timer, qeth_tx_completion_timer, 0);
-		queue->coalesce_usecs = QETH_TX_COALESCE_USECS;
-		queue->max_coalesced_frames = QETH_TX_MAX_COALESCED_FRAMES;
+		if (IS_IQD(card)) {
+			queue->coalesce_usecs = QETH_TX_COALESCE_USECS;
+			queue->max_coalesced_frames = QETH_TX_MAX_COALESCED_FRAMES;
+			queue->rescan_usecs = QETH_TX_TIMER_USECS;
+		} else {
+			queue->coalesce_usecs = USEC_PER_SEC;
+			queue->max_coalesced_frames = 0;
+			queue->rescan_usecs = 10 * USEC_PER_SEC;
+		}
 		queue->priority = QETH_QIB_PQUE_PRIO_DEFAULT;
 	}
 
@@ -3603,8 +3610,8 @@ static void qeth_flush_buffers(struct qeth_qdio_out_q *queue, int index,
 			       int count)
 {
 	struct qeth_qdio_out_buffer *buf = queue->bufs[index];
-	unsigned int qdio_flags = QDIO_FLAG_SYNC_OUTPUT;
 	struct qeth_card *card = queue->card;
+	unsigned int frames, usecs;
 	struct qaob *aob = NULL;
 	int rc;
 	int i;
@@ -3660,14 +3667,11 @@ static void qeth_flush_buffers(struct qeth_qdio_out_q *queue, int index,
 				buf->buffer->element[0].sflags |= SBAL_SFLAGS0_PCI_REQ;
 			}
 		}
-
-		if (atomic_read(&queue->set_pci_flags_count))
-			qdio_flags |= QDIO_FLAG_PCI_OUT;
 	}
 
 	QETH_TXQ_STAT_INC(queue, doorbell);
-	rc = do_QDIO(CARD_DDEV(card), qdio_flags, queue->queue_no, index, count,
-		     aob);
+	rc = do_QDIO(CARD_DDEV(card), QDIO_FLAG_SYNC_OUTPUT, queue->queue_no,
+		     index, count, aob);
 
 	switch (rc) {
 	case 0:
@@ -3675,17 +3679,20 @@ static void qeth_flush_buffers(struct qeth_qdio_out_q *queue, int index,
 		/* ignore temporary SIGA errors without busy condition */
 
 		/* Fake the TX completion interrupt: */
-		if (IS_IQD(card)) {
-			unsigned int frames = READ_ONCE(queue->max_coalesced_frames);
-			unsigned int usecs = READ_ONCE(queue->coalesce_usecs);
+		frames = READ_ONCE(queue->max_coalesced_frames);
+		usecs = READ_ONCE(queue->coalesce_usecs);
 
-			if (frames && queue->coalesced_frames >= frames) {
-				napi_schedule(&queue->napi);
-				queue->coalesced_frames = 0;
-				QETH_TXQ_STAT_INC(queue, coal_frames);
-			} else if (usecs) {
-				qeth_tx_arm_timer(queue, usecs);
-			}
+		if (frames && queue->coalesced_frames >= frames) {
+			napi_schedule(&queue->napi);
+			queue->coalesced_frames = 0;
+			QETH_TXQ_STAT_INC(queue, coal_frames);
+		} else if (qeth_use_tx_irqs(card) &&
+			   atomic_read(&queue->used_buffers) >= 32) {
+			/* Old behaviour carried over from the qdio layer: */
+			napi_schedule(&queue->napi);
+			QETH_TXQ_STAT_INC(queue, coal_frames);
+		} else if (usecs) {
+			qeth_tx_arm_timer(queue, usecs);
 		}
 
 		break;
@@ -3833,36 +3840,14 @@ static void qeth_qdio_output_handler(struct ccw_device *ccwdev,
 				     unsigned long card_ptr)
 {
 	struct qeth_card *card        = (struct qeth_card *) card_ptr;
-	struct qeth_qdio_out_q *queue = card->qdio.out_qs[__queue];
 	struct net_device *dev = card->dev;
-	struct netdev_queue *txq;
-	int i;
 
 	QETH_CARD_TEXT(card, 6, "qdouhdl");
 	if (qdio_error & QDIO_ERROR_FATAL) {
 		QETH_CARD_TEXT(card, 2, "achkcond");
 		netif_tx_stop_all_queues(dev);
 		qeth_schedule_recovery(card);
-		return;
-	}
-
-	for (i = first_element; i < (first_element + count); ++i) {
-		struct qeth_qdio_out_buffer *buf = queue->bufs[QDIO_BUFNR(i)];
-
-		qeth_handle_send_error(card, buf, qdio_error);
-		qeth_clear_output_buffer(queue, buf, qdio_error, 0);
 	}
-
-	atomic_sub(count, &queue->used_buffers);
-	qeth_check_outbound_queue(queue);
-
-	txq = netdev_get_tx_queue(dev, __queue);
-	/* xmit may have observed the full-condition, but not yet stopped the
-	 * txq. In which case the code below won't trigger. So before returning,
-	 * xmit will re-check the txq's fill level and wake it up if needed.
-	 */
-	if (netif_tx_queue_stopped(txq) && !qeth_out_queue_is_full(queue))
-		netif_tx_wake_queue(txq);
 }
 
 /**
@@ -5258,7 +5243,6 @@ static int qeth_qdio_establish(struct qeth_card *card)
 	init_data.int_parm               = (unsigned long) card;
 	init_data.input_sbal_addr_array  = in_sbal_ptrs;
 	init_data.output_sbal_addr_array = out_sbal_ptrs;
-	init_data.scan_threshold	 = IS_IQD(card) ? 0 : 32;
 
 	if (atomic_cmpxchg(&card->qdio.state, QETH_QDIO_ALLOCATED,
 		QETH_QDIO_ESTABLISHED) == QETH_QDIO_ALLOCATED) {
@@ -5958,9 +5942,10 @@ static unsigned int qeth_rx_poll(struct qeth_card *card, int budget)
 		/* Fetch completed RX buffers: */
 		if (!card->rx.b_count) {
 			card->rx.qdio_err = 0;
-			card->rx.b_count = qdio_get_next_buffers(
-				card->data.ccwdev, 0, &card->rx.b_index,
-				&card->rx.qdio_err);
+			card->rx.b_count = qdio_inspect_queue(CARD_DDEV(card),
+							      0, true,
+							      &card->rx.b_index,
+							      &card->rx.qdio_err);
 			if (card->rx.b_count <= 0) {
 				card->rx.b_count = 0;
 				break;
@@ -6024,6 +6009,16 @@ int qeth_poll(struct napi_struct *napi, int budget)
 
 	work_done = qeth_rx_poll(card, budget);
 
+	if (qeth_use_tx_irqs(card)) {
+		struct qeth_qdio_out_q *queue;
+		unsigned int i;
+
+		qeth_for_each_output_queue(card, queue, i) {
+			if (!qeth_out_queue_is_empty(queue))
+				napi_schedule(&queue->napi);
+		}
+	}
+
 	if (card->options.cq == QETH_CQ_ENABLED)
 		qeth_cq_poll(card);
 
@@ -6140,7 +6135,10 @@ static int qeth_tx_poll(struct napi_struct *napi, int budget)
 	unsigned int work_done = 0;
 	struct netdev_queue *txq;
 
-	txq = netdev_get_tx_queue(dev, qeth_iqd_translate_txq(dev, queue_no));
+	if (IS_IQD(card))
+		txq = netdev_get_tx_queue(dev, qeth_iqd_translate_txq(dev, queue_no));
+	else
+		txq = netdev_get_tx_queue(dev, queue_no);
 
 	while (1) {
 		unsigned int start, error, i;
@@ -6167,8 +6165,9 @@ static int qeth_tx_poll(struct napi_struct *napi, int budget)
 					       &start, &error);
 		if (completed <= 0) {
 			/* Ensure we see TX completion for pending work: */
-			if (napi_complete_done(napi, 0))
-				qeth_tx_arm_timer(queue, QETH_TX_TIMER_USECS);
+			if (napi_complete_done(napi, 0) &&
+			    !atomic_read(&queue->set_pci_flags_count))
+				qeth_tx_arm_timer(queue, queue->rescan_usecs);
 			return 0;
 		}
 
@@ -6181,12 +6180,19 @@ static int qeth_tx_poll(struct napi_struct *napi, int budget)
 			bytes += buffer->bytes;
 
 			qeth_handle_send_error(card, buffer, error);
-			qeth_iqd_tx_complete(queue, bidx, error, budget);
+			if (IS_IQD(card))
+				qeth_iqd_tx_complete(queue, bidx, error, budget);
+			else
+				qeth_clear_output_buffer(queue, buffer, error,
+							 budget);
 		}
 
-		netdev_tx_completed_queue(txq, packets, bytes);
 		atomic_sub(completed, &queue->used_buffers);
 		work_done += completed;
+		if (IS_IQD(card))
+			netdev_tx_completed_queue(txq, packets, bytes);
+		else
+			qeth_check_outbound_queue(queue);
 
 		/* xmit may have observed the full-condition, but not yet
 		 * stopped the txq. In which case the code below won't trigger.
@@ -7230,6 +7236,8 @@ EXPORT_SYMBOL_GPL(qeth_iqd_select_queue);
 int qeth_open(struct net_device *dev)
 {
 	struct qeth_card *card = dev->ml_priv;
+	struct qeth_qdio_out_q *queue;
+	unsigned int i;
 
 	QETH_CARD_TEXT(card, 4, "qethopen");
 
@@ -7237,16 +7245,11 @@ int qeth_open(struct net_device *dev)
 	netif_tx_start_all_queues(dev);
 
 	local_bh_disable();
-	if (IS_IQD(card)) {
-		struct qeth_qdio_out_q *queue;
-		unsigned int i;
-
-		qeth_for_each_output_queue(card, queue, i) {
-			netif_tx_napi_add(dev, &queue->napi, qeth_tx_poll,
-					  QETH_NAPI_WEIGHT);
-			napi_enable(&queue->napi);
-			napi_schedule(&queue->napi);
-		}
+	qeth_for_each_output_queue(card, queue, i) {
+		netif_tx_napi_add(dev, &queue->napi, qeth_tx_poll,
+				  QETH_NAPI_WEIGHT);
+		napi_enable(&queue->napi);
+		napi_schedule(&queue->napi);
 	}
 
 	napi_enable(&card->napi);
@@ -7261,6 +7264,8 @@ EXPORT_SYMBOL_GPL(qeth_open);
 int qeth_stop(struct net_device *dev)
 {
 	struct qeth_card *card = dev->ml_priv;
+	struct qeth_qdio_out_q *queue;
+	unsigned int i;
 
 	QETH_CARD_TEXT(card, 4, "qethstop");
 
@@ -7268,24 +7273,17 @@ int qeth_stop(struct net_device *dev)
 	cancel_delayed_work_sync(&card->buffer_reclaim_work);
 	qdio_stop_irq(CARD_DDEV(card));
 
-	if (IS_IQD(card)) {
-		struct qeth_qdio_out_q *queue;
-		unsigned int i;
-
-		/* Quiesce the NAPI instances: */
-		qeth_for_each_output_queue(card, queue, i)
-			napi_disable(&queue->napi);
+	/* Quiesce the NAPI instances: */
+	qeth_for_each_output_queue(card, queue, i)
+		napi_disable(&queue->napi);
 
-		/* Stop .ndo_start_xmit, might still access queue->napi. */
-		netif_tx_disable(dev);
+	/* Stop .ndo_start_xmit, might still access queue->napi. */
+	netif_tx_disable(dev);
 
-		qeth_for_each_output_queue(card, queue, i) {
-			del_timer_sync(&queue->timer);
-			/* Queues may get re-allocated, so remove the NAPIs. */
-			netif_napi_del(&queue->napi);
-		}
-	} else {
-		netif_tx_disable(dev);
+	qeth_for_each_output_queue(card, queue, i) {
+		del_timer_sync(&queue->timer);
+		/* Queues may get re-allocated, so remove the NAPIs. */
+		netif_napi_del(&queue->napi);
 	}
 
 	return 0;
-- 
2.25.1

