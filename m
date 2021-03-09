Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E12332C9C
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 17:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbhCIQw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 11:52:59 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32058 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230086AbhCIQwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 11:52:33 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 129GZ0v8157676;
        Tue, 9 Mar 2021 11:52:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=W3T9H/qNBRF3v1NR0eZtPGb3u7H8UyCYm+F1GBrIrnc=;
 b=cVfVqpEORdEwZ8lMk0LIhI64qxnlifw/hmyQuFwoKcIZ0n+dNlLINIMPnOWA6q95EfPZ
 tShfS+8Qin2w+qYNZGh9i9eTwvkgN3VaScRSuG15PM6VgOrZV7Pr8TkhELqZ2eddw03V
 njlSpcxHY5/7fAxR/096oA8HL7pNofUcehxqnfomK2kE1qIr16zTqbwbz91Q7JXuO7KB
 +DY4wQpzQjuStTUhkLDKYFuIcHp6LJloWuB17T/trjCZMXiDU1p9AYBV8RcNM4VI3rxI
 5UeOSJBIdu2Q0bXFPtq5WjRzyvJU8Fjp9BpLrZCVy6hT9oLH2Hu35nvkSzlOxY5VRppv jg== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 375wgvherq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Mar 2021 11:52:29 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 129Gi4b5013903;
        Tue, 9 Mar 2021 16:52:28 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3768urr70b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Mar 2021 16:52:28 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 129GqPuf39584064
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Mar 2021 16:52:25 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 327A752050;
        Tue,  9 Mar 2021 16:52:25 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id E007652051;
        Tue,  9 Mar 2021 16:52:24 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 2/4] s390/qeth: improve completion of pending TX buffers
Date:   Tue,  9 Mar 2021 17:52:19 +0100
Message-Id: <20210309165221.1735641-3-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210309165221.1735641-1-jwi@linux.ibm.com>
References: <20210309165221.1735641-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-09_13:2021-03-08,2021-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 mlxscore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103090081
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current design attaches a pending TX buffer to a custom
single-linked list, which is anchored at the buffer's slot on the
TX ring. The buffer is then checked for final completion whenever
this slot is processed during a subsequent TX NAPI poll cycle.

But if there's insufficient traffic on the ring, we might never make
enough progress to get back to this ring slot and discover the pending
buffer's final TX completion. In particular if this missing TX
completion blocks the application from sending further traffic.

So convert the custom single-linked list code to a per-queue list_head,
and scan this list on every TX NAPI cycle.

Fixes: 0da9581ddb0f ("qeth: exploit asynchronous delivery of storage blocks")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  3 +-
 drivers/s390/net/qeth_core_main.c | 69 +++++++++++++------------------
 2 files changed, 30 insertions(+), 42 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index a1da83b0b0ef..91acff493612 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -436,7 +436,7 @@ struct qeth_qdio_out_buffer {
 	int is_header[QDIO_MAX_ELEMENTS_PER_BUFFER];
 
 	struct qeth_qdio_out_q *q;
-	struct qeth_qdio_out_buffer *next_pending;
+	struct list_head list_entry;
 };
 
 struct qeth_card;
@@ -500,6 +500,7 @@ struct qeth_qdio_out_q {
 	struct qdio_buffer *qdio_bufs[QDIO_MAX_BUFFERS_PER_Q];
 	struct qeth_qdio_out_buffer *bufs[QDIO_MAX_BUFFERS_PER_Q];
 	struct qdio_outbuf_state *bufstates; /* convenience pointer */
+	struct list_head pending_bufs;
 	struct qeth_out_q_stats stats;
 	spinlock_t lock;
 	unsigned int priority;
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index f7bc0ca6909b..3763cd6d14f8 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -73,8 +73,6 @@ static void qeth_free_qdio_queues(struct qeth_card *card);
 static void qeth_notify_skbs(struct qeth_qdio_out_q *queue,
 		struct qeth_qdio_out_buffer *buf,
 		enum iucv_tx_notify notification);
-static void qeth_tx_complete_buf(struct qeth_qdio_out_buffer *buf, bool error,
-				 int budget);
 
 static void qeth_close_dev_handler(struct work_struct *work)
 {
@@ -465,41 +463,6 @@ static enum iucv_tx_notify qeth_compute_cq_notification(int sbalf15,
 	return n;
 }
 
-static void qeth_cleanup_handled_pending(struct qeth_qdio_out_q *q, int bidx,
-					 int forced_cleanup)
-{
-	if (q->card->options.cq != QETH_CQ_ENABLED)
-		return;
-
-	if (q->bufs[bidx]->next_pending != NULL) {
-		struct qeth_qdio_out_buffer *head = q->bufs[bidx];
-		struct qeth_qdio_out_buffer *c = q->bufs[bidx]->next_pending;
-
-		while (c) {
-			if (forced_cleanup ||
-			    atomic_read(&c->state) == QETH_QDIO_BUF_EMPTY) {
-				struct qeth_qdio_out_buffer *f = c;
-
-				QETH_CARD_TEXT(f->q->card, 5, "fp");
-				QETH_CARD_TEXT_(f->q->card, 5, "%lx", (long) f);
-				/* release here to avoid interleaving between
-				   outbound tasklet and inbound tasklet
-				   regarding notifications and lifecycle */
-				qeth_tx_complete_buf(c, forced_cleanup, 0);
-
-				c = f->next_pending;
-				WARN_ON_ONCE(head->next_pending != f);
-				head->next_pending = c;
-				kmem_cache_free(qeth_qdio_outbuf_cache, f);
-			} else {
-				head = c;
-				c = c->next_pending;
-			}
-
-		}
-	}
-}
-
 static void qeth_qdio_handle_aob(struct qeth_card *card,
 				 unsigned long phys_aob_addr)
 {
@@ -537,7 +500,7 @@ static void qeth_qdio_handle_aob(struct qeth_card *card,
 		qeth_notify_skbs(buffer->q, buffer, notification);
 
 		/* Free dangling allocations. The attached skbs are handled by
-		 * qeth_cleanup_handled_pending().
+		 * qeth_tx_complete_pending_bufs().
 		 */
 		for (i = 0;
 		     i < aob->sb_count && i < QETH_MAX_BUFFER_ELEMENTS(card);
@@ -1488,14 +1451,35 @@ static void qeth_clear_output_buffer(struct qeth_qdio_out_q *queue,
 	atomic_set(&buf->state, QETH_QDIO_BUF_EMPTY);
 }
 
+static void qeth_tx_complete_pending_bufs(struct qeth_card *card,
+					  struct qeth_qdio_out_q *queue,
+					  bool drain)
+{
+	struct qeth_qdio_out_buffer *buf, *tmp;
+
+	list_for_each_entry_safe(buf, tmp, &queue->pending_bufs, list_entry) {
+		if (drain || atomic_read(&buf->state) == QETH_QDIO_BUF_EMPTY) {
+			QETH_CARD_TEXT(card, 5, "fp");
+			QETH_CARD_TEXT_(card, 5, "%lx", (long) buf);
+
+			qeth_tx_complete_buf(buf, drain, 0);
+
+			list_del(&buf->list_entry);
+			kmem_cache_free(qeth_qdio_outbuf_cache, buf);
+		}
+	}
+}
+
 static void qeth_drain_output_queue(struct qeth_qdio_out_q *q, bool free)
 {
 	int j;
 
+	qeth_tx_complete_pending_bufs(q->card, q, true);
+
 	for (j = 0; j < QDIO_MAX_BUFFERS_PER_Q; ++j) {
 		if (!q->bufs[j])
 			continue;
-		qeth_cleanup_handled_pending(q, j, 1);
+
 		qeth_clear_output_buffer(q, q->bufs[j], true, 0);
 		if (free) {
 			kmem_cache_free(qeth_qdio_outbuf_cache, q->bufs[j]);
@@ -2615,7 +2599,6 @@ static int qeth_init_qdio_out_buf(struct qeth_qdio_out_q *q, int bidx)
 	skb_queue_head_init(&newbuf->skb_list);
 	lockdep_set_class(&newbuf->skb_list.lock, &qdio_out_skb_queue_key);
 	newbuf->q = q;
-	newbuf->next_pending = q->bufs[bidx];
 	atomic_set(&newbuf->state, QETH_QDIO_BUF_EMPTY);
 	q->bufs[bidx] = newbuf;
 	return 0;
@@ -2697,6 +2680,7 @@ static int qeth_alloc_qdio_queues(struct qeth_card *card)
 		card->qdio.out_qs[i] = queue;
 		queue->card = card;
 		queue->queue_no = i;
+		INIT_LIST_HEAD(&queue->pending_bufs);
 		spin_lock_init(&queue->lock);
 		timer_setup(&queue->timer, qeth_tx_completion_timer, 0);
 		queue->coalesce_usecs = QETH_TX_COALESCE_USECS;
@@ -6106,6 +6090,8 @@ static void qeth_iqd_tx_complete(struct qeth_qdio_out_q *queue,
 					qeth_schedule_recovery(card);
 				}
 
+				list_add(&buffer->list_entry,
+					 &queue->pending_bufs);
 				/* Skip clearing the buffer: */
 				return;
 			case QETH_QDIO_BUF_QAOB_OK:
@@ -6161,6 +6147,8 @@ static int qeth_tx_poll(struct napi_struct *napi, int budget)
 		unsigned int bytes = 0;
 		int completed;
 
+		qeth_tx_complete_pending_bufs(card, queue, false);
+
 		if (qeth_out_queue_is_empty(queue)) {
 			napi_complete(napi);
 			return 0;
@@ -6193,7 +6181,6 @@ static int qeth_tx_poll(struct napi_struct *napi, int budget)
 
 			qeth_handle_send_error(card, buffer, error);
 			qeth_iqd_tx_complete(queue, bidx, error, budget);
-			qeth_cleanup_handled_pending(queue, bidx, false);
 		}
 
 		netdev_tx_completed_queue(txq, packets, bytes);
-- 
2.25.1

