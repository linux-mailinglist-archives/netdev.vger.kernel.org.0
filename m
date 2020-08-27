Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 356F9254078
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 10:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgH0IRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 04:17:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51888 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726395AbgH0IRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 04:17:15 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07R854wT045838;
        Thu, 27 Aug 2020 04:17:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=lt4sJ4fkC0dAKZhUJTcq5EwSskGkX2jVyTM3AxOZxTI=;
 b=PImmRFVJpkIzRoGmeRgJbxGtP2e7cSzNWN3W5Hm+jWuiS8yyTKZMIQG8J3P9uxqpF85R
 sdSanaeM852Ort1IM2+hqu4IvPlMnHfXe51tfb1dxau5CIPuXN1BdLXXs4ECXnRYjGth
 2HQrJcstHuHMe1sg2Sywz8qTRtaGCadrxX8yFlVtphlzlN2TBOOim0IHJsBpPoGjS9KS
 mwt6jCHgOBMVTUM/GQ26gHpXlz4IIGf39Qq1ofm6Q1JfeM/onxnFpha1565pxyPX+oHb
 Yi2LBxP0u6pqt6xMv7kIrCQP8BUZ/f6nkLEYPkyQqa9OIiMeyRnQ2Mrtc+Hl2fPBsoE4 lg== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3367tsjfqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Aug 2020 04:17:14 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07R8CXnC017685;
        Thu, 27 Aug 2020 08:17:11 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 332ujkwekr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Aug 2020 08:17:11 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07R8H9Ka19792272
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Aug 2020 08:17:09 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFA464C05E;
        Thu, 27 Aug 2020 08:17:08 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F2B44C052;
        Thu, 27 Aug 2020 08:17:08 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Aug 2020 08:17:08 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 3/8] s390/qeth: make queue lock a proper spinlock
Date:   Thu, 27 Aug 2020 10:17:00 +0200
Message-Id: <20200827081705.21922-4-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827081705.21922-1-jwi@linux.ibm.com>
References: <20200827081705.21922-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-27_02:2020-08-27,2020-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1011 priorityscore=1501
 impostorscore=0 adultscore=0 suspectscore=2 spamscore=0 mlxlogscore=999
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270060
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

queue->state is a ternary spinlock in disguise, used by
OSA's TX completion path to lock the Output Queue and flush any pending
packets on it to the device. If the Queue is already locked by our TX
code, setting the lock word to QETH_OUT_Q_LOCKED_FLUSH lets the TX
completion code move on - the TX path will later take care of things
when it unlocks the Queue.

This sort of DIY locking is a non-starter of course, just let the
TX completion path block on the spinlock when necessary. If that ends up
causing additional latency due to lock contention, then converting
the OSA path to use xmit_more is the right way to go forward.

Also slightly expand the locked section and capture all of
qeth_do_send_packet(), so that the update for the 'bufs_pack' statistics
is done race-free.

While reworking the TX completion path's code, remove a barrier() that
doesn't make any sense.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  8 +---
 drivers/s390/net/qeth_core_main.c | 80 +++++++++----------------------
 2 files changed, 23 insertions(+), 65 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index ecfd6d152e86..00ed58428163 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -420,12 +420,6 @@ struct qeth_qdio_out_buffer {
 
 struct qeth_card;
 
-enum qeth_out_q_states {
-       QETH_OUT_Q_UNLOCKED,
-       QETH_OUT_Q_LOCKED,
-       QETH_OUT_Q_LOCKED_FLUSH,
-};
-
 #define QETH_CARD_STAT_ADD(_c, _stat, _val)	((_c)->stats._stat += (_val))
 #define QETH_CARD_STAT_INC(_c, _stat)		QETH_CARD_STAT_ADD(_c, _stat, 1)
 
@@ -486,12 +480,12 @@ struct qeth_qdio_out_q {
 	struct qeth_qdio_out_buffer *bufs[QDIO_MAX_BUFFERS_PER_Q];
 	struct qdio_outbuf_state *bufstates; /* convenience pointer */
 	struct qeth_out_q_stats stats;
+	spinlock_t lock;
 	u8 next_buf_to_fill;
 	u8 max_elements;
 	u8 queue_no;
 	u8 do_pack;
 	struct qeth_card *card;
-	atomic_t state;
 	/*
 	 * number of buffers that are currently filled (PRIMED)
 	 * -> these buffers are hardware-owned
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 5742a682a193..26bc8c15ffb8 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -2702,6 +2702,7 @@ static int qeth_alloc_qdio_queues(struct qeth_card *card)
 		card->qdio.out_qs[i] = queue;
 		queue->card = card;
 		queue->queue_no = i;
+		spin_lock_init(&queue->lock);
 		timer_setup(&queue->timer, qeth_tx_completion_timer, 0);
 		queue->coalesce_usecs = QETH_TX_COALESCE_USECS;
 		queue->max_coalesced_frames = QETH_TX_MAX_COALESCED_FRAMES;
@@ -3068,7 +3069,6 @@ static int qeth_init_qdio_queues(struct qeth_card *card)
 		queue->bulk_max = qeth_tx_select_bulk_max(card, queue);
 		atomic_set(&queue->used_buffers, 0);
 		atomic_set(&queue->set_pci_flags_count, 0);
-		atomic_set(&queue->state, QETH_OUT_Q_UNLOCKED);
 		netdev_tx_reset_queue(netdev_get_tx_queue(card->dev, i));
 	}
 	return 0;
@@ -3741,37 +3741,31 @@ static void qeth_flush_queue(struct qeth_qdio_out_q *queue)
 
 static void qeth_check_outbound_queue(struct qeth_qdio_out_q *queue)
 {
-	int index;
-	int flush_cnt = 0;
-	int q_was_packing = 0;
-
 	/*
 	 * check if weed have to switch to non-packing mode or if
 	 * we have to get a pci flag out on the queue
 	 */
 	if ((atomic_read(&queue->used_buffers) <= QETH_LOW_WATERMARK_PACK) ||
 	    !atomic_read(&queue->set_pci_flags_count)) {
-		if (atomic_xchg(&queue->state, QETH_OUT_Q_LOCKED_FLUSH) ==
-				QETH_OUT_Q_UNLOCKED) {
-			/*
-			 * If we get in here, there was no action in
-			 * do_send_packet. So, we check if there is a
-			 * packing buffer to be flushed here.
-			 */
-			index = queue->next_buf_to_fill;
-			q_was_packing = queue->do_pack;
-			/* queue->do_pack may change */
-			barrier();
-			flush_cnt += qeth_switch_to_nonpacking_if_needed(queue);
-			if (!flush_cnt &&
-			    !atomic_read(&queue->set_pci_flags_count))
-				flush_cnt += qeth_prep_flush_pack_buffer(queue);
+		unsigned int index, flush_cnt;
+		bool q_was_packing;
+
+		spin_lock(&queue->lock);
+
+		index = queue->next_buf_to_fill;
+		q_was_packing = queue->do_pack;
+
+		flush_cnt = qeth_switch_to_nonpacking_if_needed(queue);
+		if (!flush_cnt && !atomic_read(&queue->set_pci_flags_count))
+			flush_cnt = qeth_prep_flush_pack_buffer(queue);
+
+		if (flush_cnt) {
+			qeth_flush_buffers(queue, index, flush_cnt);
 			if (q_was_packing)
 				QETH_TXQ_STAT_ADD(queue, bufs_pack, flush_cnt);
-			if (flush_cnt)
-				qeth_flush_buffers(queue, index, flush_cnt);
-			atomic_set(&queue->state, QETH_OUT_Q_UNLOCKED);
 		}
+
+		spin_unlock(&queue->lock);
 	}
 }
 
@@ -4283,29 +4277,22 @@ int qeth_do_send_packet(struct qeth_card *card, struct qeth_qdio_out_q *queue,
 			unsigned int offset, unsigned int hd_len,
 			int elements_needed)
 {
+	unsigned int start_index = queue->next_buf_to_fill;
 	struct qeth_qdio_out_buffer *buffer;
 	unsigned int next_element;
 	struct netdev_queue *txq;
 	bool stopped = false;
-	int start_index;
 	int flush_count = 0;
 	int do_pack = 0;
-	int tmp;
 	int rc = 0;
 
-	/* spin until we get the queue ... */
-	while (atomic_cmpxchg(&queue->state, QETH_OUT_Q_UNLOCKED,
-			      QETH_OUT_Q_LOCKED) != QETH_OUT_Q_UNLOCKED);
-	start_index = queue->next_buf_to_fill;
 	buffer = queue->bufs[queue->next_buf_to_fill];
 
 	/* Just a sanity check, the wake/stop logic should ensure that we always
 	 * get a free buffer.
 	 */
-	if (atomic_read(&buffer->state) != QETH_QDIO_BUF_EMPTY) {
-		atomic_set(&queue->state, QETH_OUT_Q_UNLOCKED);
+	if (atomic_read(&buffer->state) != QETH_QDIO_BUF_EMPTY)
 		return -EBUSY;
-	}
 
 	txq = netdev_get_tx_queue(card->dev, skb_get_queue_mapping(skb));
 
@@ -4328,8 +4315,6 @@ int qeth_do_send_packet(struct qeth_card *card, struct qeth_qdio_out_q *queue,
 			    QETH_QDIO_BUF_EMPTY) {
 				qeth_flush_buffers(queue, start_index,
 							   flush_count);
-				atomic_set(&queue->state,
-						QETH_OUT_Q_UNLOCKED);
 				rc = -EBUSY;
 				goto out;
 			}
@@ -4361,31 +4346,8 @@ int qeth_do_send_packet(struct qeth_card *card, struct qeth_qdio_out_q *queue,
 
 	if (flush_count)
 		qeth_flush_buffers(queue, start_index, flush_count);
-	else if (!atomic_read(&queue->set_pci_flags_count))
-		atomic_xchg(&queue->state, QETH_OUT_Q_LOCKED_FLUSH);
-	/*
-	 * queue->state will go from LOCKED -> UNLOCKED or from
-	 * LOCKED_FLUSH -> LOCKED if output_handler wanted to 'notify' us
-	 * (switch packing state or flush buffer to get another pci flag out).
-	 * In that case we will enter this loop
-	 */
-	while (atomic_dec_return(&queue->state)) {
-		start_index = queue->next_buf_to_fill;
-		/* check if we can go back to non-packing state */
-		tmp = qeth_switch_to_nonpacking_if_needed(queue);
-		/*
-		 * check if we need to flush a packing buffer to get a pci
-		 * flag out on the queue
-		 */
-		if (!tmp && !atomic_read(&queue->set_pci_flags_count))
-			tmp = qeth_prep_flush_pack_buffer(queue);
-		if (tmp) {
-			qeth_flush_buffers(queue, start_index, tmp);
-			flush_count += tmp;
-		}
-	}
+
 out:
-	/* at this point the queue is UNLOCKED again */
 	if (do_pack)
 		QETH_TXQ_STAT_ADD(queue, bufs_pack, flush_count);
 
@@ -4459,8 +4421,10 @@ int qeth_xmit(struct qeth_card *card, struct sk_buff *skb,
 	} else {
 		/* TODO: drop skb_orphan() once TX completion is fast enough */
 		skb_orphan(skb);
+		spin_lock(&queue->lock);
 		rc = qeth_do_send_packet(card, queue, skb, hdr, data_offset,
 					 hd_len, elements);
+		spin_unlock(&queue->lock);
 	}
 
 	if (rc && !push_len)
-- 
2.17.1

