Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6E19ABD7
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 11:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404983AbfHWJtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 05:49:05 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37980 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390173AbfHWJtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 05:49:04 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7N9kjsQ052550
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 05:49:02 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ujcj5k12t-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 05:49:01 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Fri, 23 Aug 2019 10:49:00 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 23 Aug 2019 10:48:58 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7N9mZiC22872520
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 09:48:35 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92D6A42049;
        Fri, 23 Aug 2019 09:48:56 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 49C7F42045;
        Fri, 23 Aug 2019 09:48:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 23 Aug 2019 09:48:56 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 4/7] s390/qeth: add TX NAPI support for IQD devices
Date:   Fri, 23 Aug 2019 11:48:50 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190823094853.63814-1-jwi@linux.ibm.com>
References: <20190823094853.63814-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19082309-0008-0000-0000-0000030C7416
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082309-0009-0000-0000-00004A2AA5DE
Message-Id: <20190823094853.63814-5-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-23_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908230102
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Due to their large MTU and potentially low utilization of TX buffers,
IQD devices in particular require fast TX recycling. This makes them
a prime candidate for a TX NAPI path in qeth.

qeth_tx_poll() uses the recently introduced qdio_inspect_queue() helper
to poll the TX queue for completed buffers. To avoid hogging the CPU for
too long, we yield to the stack after completing an entire queue's worth
of buffers.
While IQD is expected to transfer its buffers synchronously (and thus
doesn't support TX interrupts), a timer covers for the odd case where a
TX buffer doesn't complete synchronously. Currently this timer should
only ever fire for
(1) the mcast queue,
(2) the occasional race, where the NAPI poll code observes an update to
    queue->used_buffers while the TX doorbell hasn't been issued yet.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 arch/s390/include/asm/qdio.h      |   1 +
 drivers/s390/net/qeth_core.h      |  26 ++++
 drivers/s390/net/qeth_core_main.c | 202 +++++++++++++++++++++++-------
 drivers/s390/net/qeth_ethtool.c   |   2 +
 4 files changed, 183 insertions(+), 48 deletions(-)

diff --git a/arch/s390/include/asm/qdio.h b/arch/s390/include/asm/qdio.h
index 556d3e703fae..78e8a888306d 100644
--- a/arch/s390/include/asm/qdio.h
+++ b/arch/s390/include/asm/qdio.h
@@ -16,6 +16,7 @@
 #define QDIO_MAX_QUEUES_PER_IRQ		4
 #define QDIO_MAX_BUFFERS_PER_Q		128
 #define QDIO_MAX_BUFFERS_MASK		(QDIO_MAX_BUFFERS_PER_Q - 1)
+#define QDIO_BUFNR(num)			((num) & QDIO_MAX_BUFFERS_MASK)
 #define QDIO_MAX_ELEMENTS_PER_BUFFER	16
 #define QDIO_SBAL_SIZE			256
 
diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index a0911ce55db3..ae2ae17e3e76 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -22,6 +22,7 @@
 #include <linux/hashtable.h>
 #include <linux/ip.h>
 #include <linux/refcount.h>
+#include <linux/timer.h>
 #include <linux/wait.h>
 #include <linux/workqueue.h>
 
@@ -474,6 +475,8 @@ struct qeth_out_q_stats {
 	u64 tso_bytes;
 	u64 packing_mode_switch;
 	u64 stopped;
+	u64 completion_yield;
+	u64 completion_timer;
 
 	/* rtnl_link_stats64 */
 	u64 tx_packets;
@@ -482,6 +485,8 @@ struct qeth_out_q_stats {
 	u64 tx_dropped;
 };
 
+#define QETH_TX_TIMER_USECS		500
+
 struct qeth_qdio_out_q {
 	struct qdio_buffer *qdio_bufs[QDIO_MAX_BUFFERS_PER_Q];
 	struct qeth_qdio_out_buffer *bufs[QDIO_MAX_BUFFERS_PER_Q];
@@ -500,13 +505,34 @@ struct qeth_qdio_out_q {
 	atomic_t used_buffers;
 	/* indicates whether PCI flag must be set (or if one is outstanding) */
 	atomic_t set_pci_flags_count;
+	struct napi_struct napi;
+	struct timer_list timer;
 };
 
+#define qeth_for_each_output_queue(card, q, i)		\
+	for (i = 0; i < card->qdio.no_out_queues &&	\
+		    (q = card->qdio.out_qs[i]); i++)
+
+#define	qeth_napi_to_out_queue(n) container_of(n, struct qeth_qdio_out_q, napi)
+
+static inline void qeth_tx_arm_timer(struct qeth_qdio_out_q *queue)
+{
+	if (timer_pending(&queue->timer))
+		return;
+	mod_timer(&queue->timer, usecs_to_jiffies(QETH_TX_TIMER_USECS) +
+				 jiffies);
+}
+
 static inline bool qeth_out_queue_is_full(struct qeth_qdio_out_q *queue)
 {
 	return atomic_read(&queue->used_buffers) >= QDIO_MAX_BUFFERS_PER_Q;
 }
 
+static inline bool qeth_out_queue_is_empty(struct qeth_qdio_out_q *queue)
+{
+	return atomic_read(&queue->used_buffers) == 0;
+}
+
 struct qeth_qdio_info {
 	atomic_t state;
 	/* input */
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index d7a15a88bdba..3223ad80998c 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -2284,6 +2284,14 @@ static struct qeth_qdio_out_q *qeth_alloc_output_queue(void)
 	return q;
 }
 
+static void qeth_tx_completion_timer(struct timer_list *timer)
+{
+	struct qeth_qdio_out_q *queue = from_timer(queue, timer, timer);
+
+	napi_schedule(&queue->napi);
+	QETH_TXQ_STAT_INC(queue, completion_timer);
+}
+
 static int qeth_alloc_qdio_queues(struct qeth_card *card)
 {
 	int i, j;
@@ -2305,17 +2313,22 @@ static int qeth_alloc_qdio_queues(struct qeth_card *card)
 
 	/* outbound */
 	for (i = 0; i < card->qdio.no_out_queues; ++i) {
-		card->qdio.out_qs[i] = qeth_alloc_output_queue();
-		if (!card->qdio.out_qs[i])
+		struct qeth_qdio_out_q *queue;
+
+		queue = qeth_alloc_output_queue();
+		if (!queue)
 			goto out_freeoutq;
 		QETH_CARD_TEXT_(card, 2, "outq %i", i);
-		QETH_CARD_HEX(card, 2, &card->qdio.out_qs[i], sizeof(void *));
-		card->qdio.out_qs[i]->card = card;
-		card->qdio.out_qs[i]->queue_no = i;
+		QETH_CARD_HEX(card, 2, &queue, sizeof(void *));
+		card->qdio.out_qs[i] = queue;
+		queue->card = card;
+		queue->queue_no = i;
+		timer_setup(&queue->timer, qeth_tx_completion_timer, 0);
+
 		/* give outbound qeth_qdio_buffers their qdio_buffers */
 		for (j = 0; j < QDIO_MAX_BUFFERS_PER_Q; ++j) {
-			WARN_ON(card->qdio.out_qs[i]->bufs[j] != NULL);
-			if (qeth_init_qdio_out_buf(card->qdio.out_qs[i], j))
+			WARN_ON(queue->bufs[j]);
+			if (qeth_init_qdio_out_buf(queue, j))
 				goto out_freeoutqbufs;
 		}
 	}
@@ -3226,6 +3239,7 @@ static int qeth_switch_to_nonpacking_if_needed(struct qeth_qdio_out_q *queue)
 static void qeth_flush_buffers(struct qeth_qdio_out_q *queue, int index,
 			       int count)
 {
+	struct qeth_card *card = queue->card;
 	struct qeth_qdio_out_buffer *buf;
 	int rc;
 	int i;
@@ -3274,6 +3288,11 @@ static void qeth_flush_buffers(struct qeth_qdio_out_q *queue, int index,
 		qdio_flags |= QDIO_FLAG_PCI_OUT;
 	rc = do_QDIO(CARD_DDEV(queue->card), qdio_flags,
 		     queue->queue_no, index, count);
+
+	/* Fake the TX completion interrupt: */
+	if (IS_IQD(card))
+		napi_schedule(&queue->napi);
+
 	if (rc) {
 		/* ignore temporary SIGA errors without busy condition */
 		if (rc == -ENOBUFS)
@@ -3452,48 +3471,12 @@ static void qeth_qdio_output_handler(struct ccw_device *ccwdev,
 		int bidx = i % QDIO_MAX_BUFFERS_PER_Q;
 		buffer = queue->bufs[bidx];
 		qeth_handle_send_error(card, buffer, qdio_error);
-
-		if (queue->bufstates &&
-		    (queue->bufstates[bidx].flags &
-		     QDIO_OUTBUF_STATE_FLAG_PENDING) != 0) {
-			WARN_ON_ONCE(card->options.cq != QETH_CQ_ENABLED);
-
-			if (atomic_cmpxchg(&buffer->state,
-					   QETH_QDIO_BUF_PRIMED,
-					   QETH_QDIO_BUF_PENDING) ==
-				QETH_QDIO_BUF_PRIMED) {
-				qeth_notify_skbs(queue, buffer,
-						 TX_NOTIFY_PENDING);
-			}
-			QETH_CARD_TEXT_(queue->card, 5, "pel%d", bidx);
-
-			/* prepare the queue slot for re-use: */
-			qeth_scrub_qdio_buffer(buffer->buffer,
-					       queue->max_elements);
-			if (qeth_init_qdio_out_buf(queue, bidx)) {
-				QETH_CARD_TEXT(card, 2, "outofbuf");
-				qeth_schedule_recovery(card);
-			}
-		} else {
-			if (card->options.cq == QETH_CQ_ENABLED) {
-				enum iucv_tx_notify n;
-
-				n = qeth_compute_cq_notification(
-					buffer->buffer->element[15].sflags, 0);
-				qeth_notify_skbs(queue, buffer, n);
-			}
-
-			qeth_clear_output_buffer(queue, buffer, qdio_error);
-		}
-		qeth_cleanup_handled_pending(queue, bidx, 0);
+		qeth_clear_output_buffer(queue, buffer, qdio_error);
 	}
+
 	atomic_sub(count, &queue->used_buffers);
-	/* check if we need to do something on this outbound queue */
-	if (!IS_IQD(card))
-		qeth_check_outbound_queue(queue);
+	qeth_check_outbound_queue(queue);
 
-	if (IS_IQD(card))
-		__queue = qeth_iqd_translate_txq(dev, __queue);
 	txq = netdev_get_tx_queue(dev, __queue);
 	/* xmit may have observed the full-condition, but not yet stopped the
 	 * txq. In which case the code below won't trigger. So before returning,
@@ -4740,7 +4723,7 @@ static int qeth_qdio_establish(struct qeth_card *card)
 	init_data.input_sbal_addr_array  = in_sbal_ptrs;
 	init_data.output_sbal_addr_array = out_sbal_ptrs;
 	init_data.output_sbal_state_array = card->qdio.out_bufstates;
-	init_data.scan_threshold	 = IS_IQD(card) ? 1 : 32;
+	init_data.scan_threshold	 = IS_IQD(card) ? 0 : 32;
 
 	if (atomic_cmpxchg(&card->qdio.state, QETH_QDIO_ALLOCATED,
 		QETH_QDIO_ESTABLISHED) == QETH_QDIO_ALLOCATED) {
@@ -5154,6 +5137,99 @@ int qeth_poll(struct napi_struct *napi, int budget)
 }
 EXPORT_SYMBOL_GPL(qeth_poll);
 
+static void qeth_iqd_tx_complete(struct qeth_qdio_out_q *queue,
+				 unsigned int bidx, bool error)
+{
+	struct qeth_qdio_out_buffer *buffer = queue->bufs[bidx];
+	u8 sflags = buffer->buffer->element[15].sflags;
+	struct qeth_card *card = queue->card;
+
+	if (queue->bufstates && (queue->bufstates[bidx].flags &
+				 QDIO_OUTBUF_STATE_FLAG_PENDING)) {
+		WARN_ON_ONCE(card->options.cq != QETH_CQ_ENABLED);
+
+		if (atomic_cmpxchg(&buffer->state, QETH_QDIO_BUF_PRIMED,
+						   QETH_QDIO_BUF_PENDING) ==
+		    QETH_QDIO_BUF_PRIMED)
+			qeth_notify_skbs(queue, buffer, TX_NOTIFY_PENDING);
+
+		QETH_CARD_TEXT_(card, 5, "pel%u", bidx);
+
+		/* prepare the queue slot for re-use: */
+		qeth_scrub_qdio_buffer(buffer->buffer, queue->max_elements);
+		if (qeth_init_qdio_out_buf(queue, bidx)) {
+			QETH_CARD_TEXT(card, 2, "outofbuf");
+			qeth_schedule_recovery(card);
+		}
+
+		return;
+	}
+
+	if (card->options.cq == QETH_CQ_ENABLED)
+		qeth_notify_skbs(queue, buffer,
+				 qeth_compute_cq_notification(sflags, 0));
+	qeth_clear_output_buffer(queue, buffer, error);
+}
+
+static int qeth_tx_poll(struct napi_struct *napi, int budget)
+{
+	struct qeth_qdio_out_q *queue = qeth_napi_to_out_queue(napi);
+	unsigned int queue_no = queue->queue_no;
+	struct qeth_card *card = queue->card;
+	struct net_device *dev = card->dev;
+	unsigned int work_done = 0;
+	struct netdev_queue *txq;
+
+	txq = netdev_get_tx_queue(dev, qeth_iqd_translate_txq(dev, queue_no));
+
+	while (1) {
+		unsigned int start, error, i;
+		int completed;
+
+		if (qeth_out_queue_is_empty(queue)) {
+			napi_complete(napi);
+			return 0;
+		}
+
+		/* Give the CPU a breather: */
+		if (work_done >= QDIO_MAX_BUFFERS_PER_Q) {
+			QETH_TXQ_STAT_INC(queue, completion_yield);
+			if (napi_complete_done(napi, 0))
+				napi_schedule(napi);
+			return 0;
+		}
+
+		completed = qdio_inspect_queue(CARD_DDEV(card), queue_no, false,
+					       &start, &error);
+		if (completed <= 0) {
+			/* Ensure we see TX completion for pending work: */
+			if (napi_complete_done(napi, 0))
+				qeth_tx_arm_timer(queue);
+			return 0;
+		}
+
+		for (i = start; i < start + completed; i++) {
+			unsigned int bidx = QDIO_BUFNR(i);
+
+			qeth_handle_send_error(card, queue->bufs[bidx], error);
+			qeth_iqd_tx_complete(queue, bidx, error);
+			qeth_cleanup_handled_pending(queue, bidx, false);
+		}
+
+		atomic_sub(completed, &queue->used_buffers);
+		work_done += completed;
+
+		/* xmit may have observed the full-condition, but not yet
+		 * stopped the txq. In which case the code below won't trigger.
+		 * So before returning, xmit will re-check the txq's fill level
+		 * and wake it up if needed.
+		 */
+		if (netif_tx_queue_stopped(txq) &&
+		    !qeth_out_queue_is_full(queue))
+			netif_tx_wake_queue(txq);
+	}
+}
+
 static int qeth_setassparms_inspect_rc(struct qeth_ipa_cmd *cmd)
 {
 	if (!cmd->hdr.return_code)
@@ -6100,6 +6176,17 @@ int qeth_open(struct net_device *dev)
 	napi_enable(&card->napi);
 	local_bh_disable();
 	napi_schedule(&card->napi);
+	if (IS_IQD(card)) {
+		struct qeth_qdio_out_q *queue;
+		unsigned int i;
+
+		qeth_for_each_output_queue(card, queue, i) {
+			netif_tx_napi_add(dev, &queue->napi, qeth_tx_poll,
+					  QETH_NAPI_WEIGHT);
+			napi_enable(&queue->napi);
+			napi_schedule(&queue->napi);
+		}
+	}
 	/* kick-start the NAPI softirq: */
 	local_bh_enable();
 	return 0;
@@ -6111,7 +6198,26 @@ int qeth_stop(struct net_device *dev)
 	struct qeth_card *card = dev->ml_priv;
 
 	QETH_CARD_TEXT(card, 4, "qethstop");
-	netif_tx_disable(dev);
+	if (IS_IQD(card)) {
+		struct qeth_qdio_out_q *queue;
+		unsigned int i;
+
+		/* Quiesce the NAPI instances: */
+		qeth_for_each_output_queue(card, queue, i) {
+			napi_disable(&queue->napi);
+			del_timer_sync(&queue->timer);
+		}
+
+		/* Stop .ndo_start_xmit, might still access queue->napi. */
+		netif_tx_disable(dev);
+
+		/* Queues may get re-allocated, so remove the NAPIs here. */
+		qeth_for_each_output_queue(card, queue, i)
+			netif_napi_del(&queue->napi);
+	} else {
+		netif_tx_disable(dev);
+	}
+
 	napi_disable(&card->napi);
 	return 0;
 }
diff --git a/drivers/s390/net/qeth_ethtool.c b/drivers/s390/net/qeth_ethtool.c
index 4166eb29f0bd..096698df3886 100644
--- a/drivers/s390/net/qeth_ethtool.c
+++ b/drivers/s390/net/qeth_ethtool.c
@@ -39,6 +39,8 @@ static const struct qeth_stats txq_stats[] = {
 	QETH_TXQ_STAT("TSO bytes", tso_bytes),
 	QETH_TXQ_STAT("Packing mode switches", packing_mode_switch),
 	QETH_TXQ_STAT("Queue stopped", stopped),
+	QETH_TXQ_STAT("Completion yield", completion_yield),
+	QETH_TXQ_STAT("Completion timer", completion_timer),
 };
 
 static const struct qeth_stats card_stats[] = {
-- 
2.17.1

