Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA9EEB085
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 13:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbfJaMml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 08:42:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31488 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727133AbfJaMmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 08:42:33 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9VCe5kV189377
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 08:42:32 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vxwmrjaad-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 08:42:30 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 31 Oct 2019 12:42:27 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 31 Oct 2019 12:42:26 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9VCfog635782986
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Oct 2019 12:41:50 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4356D11C064;
        Thu, 31 Oct 2019 12:42:24 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03EC611C06C;
        Thu, 31 Oct 2019 12:42:24 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 31 Oct 2019 12:42:23 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 2/8] s390/qeth: use IQD Multi-Write
Date:   Thu, 31 Oct 2019 13:42:15 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191031124221.34028-1-jwi@linux.ibm.com>
References: <20191031124221.34028-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19103112-0008-0000-0000-000003297A90
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19103112-0009-0000-0000-00004A48C5F9
Message-Id: <20191031124221.34028-3-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-31_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910310131
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For IQD devices with Multi-Write support, we can defer the queue-flush
further and transmit multiple IO buffers with a single TX doorbell.
The same-target restriction still applies.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  9 ++++++
 drivers/s390/net/qeth_core_main.c | 54 +++++++++++++++++++++++++------
 2 files changed, 53 insertions(+), 10 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index e4b55f9aa062..d08154502b15 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -532,6 +532,8 @@ struct qeth_qdio_out_q {
 	struct timer_list timer;
 	struct qeth_hdr *prev_hdr;
 	u8 bulk_start;
+	u8 bulk_count;
+	u8 bulk_max;
 };
 
 #define qeth_for_each_output_queue(card, q, i)		\
@@ -878,6 +880,13 @@ static inline u16 qeth_iqd_translate_txq(struct net_device *dev, u16 txq)
 	return txq;
 }
 
+static inline bool qeth_iqd_is_mcast_queue(struct qeth_card *card,
+					   struct qeth_qdio_out_q *queue)
+{
+	return qeth_iqd_translate_txq(card->dev, queue->queue_no) ==
+	       QETH_IQD_MCAST_TXQ;
+}
+
 static inline void qeth_scrub_qdio_buffer(struct qdio_buffer *buf,
 					  unsigned int elements)
 {
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index dda274351c21..62054afd73cc 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -2634,6 +2634,18 @@ static int qeth_init_input_buffer(struct qeth_card *card,
 	return 0;
 }
 
+static unsigned int qeth_tx_select_bulk_max(struct qeth_card *card,
+					    struct qeth_qdio_out_q *queue)
+{
+	if (!IS_IQD(card) ||
+	    qeth_iqd_is_mcast_queue(card, queue) ||
+	    card->options.cq == QETH_CQ_ENABLED ||
+	    qdio_get_ssqd_desc(CARD_DDEV(card), &card->ssqd))
+		return 1;
+
+	return card->ssqd.mmwc ? card->ssqd.mmwc : 1;
+}
+
 int qeth_init_qdio_queues(struct qeth_card *card)
 {
 	unsigned int i;
@@ -2673,6 +2685,8 @@ int qeth_init_qdio_queues(struct qeth_card *card)
 		queue->do_pack = 0;
 		queue->prev_hdr = NULL;
 		queue->bulk_start = 0;
+		queue->bulk_count = 0;
+		queue->bulk_max = qeth_tx_select_bulk_max(card, queue);
 		atomic_set(&queue->used_buffers, 0);
 		atomic_set(&queue->set_pci_flags_count, 0);
 		atomic_set(&queue->state, QETH_OUT_Q_UNLOCKED);
@@ -3318,10 +3332,11 @@ static void qeth_flush_buffers(struct qeth_qdio_out_q *queue, int index,
 
 static void qeth_flush_queue(struct qeth_qdio_out_q *queue)
 {
-	qeth_flush_buffers(queue, queue->bulk_start, 1);
+	qeth_flush_buffers(queue, queue->bulk_start, queue->bulk_count);
 
-	queue->bulk_start = QDIO_BUFNR(queue->bulk_start + 1);
+	queue->bulk_start = QDIO_BUFNR(queue->bulk_start + queue->bulk_count);
 	queue->prev_hdr = NULL;
+	queue->bulk_count = 0;
 }
 
 static void qeth_check_outbound_queue(struct qeth_qdio_out_q *queue)
@@ -3680,10 +3695,10 @@ static int qeth_add_hw_header(struct qeth_qdio_out_q *queue,
 }
 
 static bool qeth_iqd_may_bulk(struct qeth_qdio_out_q *queue,
-			      struct qeth_qdio_out_buffer *buffer,
 			      struct sk_buff *curr_skb,
 			      struct qeth_hdr *curr_hdr)
 {
+	struct qeth_qdio_out_buffer *buffer = queue->bufs[queue->bulk_start];
 	struct qeth_hdr *prev_hdr = queue->prev_hdr;
 
 	if (!prev_hdr)
@@ -3803,13 +3818,14 @@ static int __qeth_xmit(struct qeth_card *card, struct qeth_qdio_out_q *queue,
 		       struct qeth_hdr *hdr, unsigned int offset,
 		       unsigned int hd_len)
 {
-	struct qeth_qdio_out_buffer *buffer = queue->bufs[queue->bulk_start];
 	unsigned int bytes = qdisc_pkt_len(skb);
+	struct qeth_qdio_out_buffer *buffer;
 	unsigned int next_element;
 	struct netdev_queue *txq;
 	bool stopped = false;
 	bool flush;
 
+	buffer = queue->bufs[QDIO_BUFNR(queue->bulk_start + queue->bulk_count)];
 	txq = netdev_get_tx_queue(card->dev, skb_get_queue_mapping(skb));
 
 	/* Just a sanity check, the wake/stop logic should ensure that we always
@@ -3818,11 +3834,23 @@ static int __qeth_xmit(struct qeth_card *card, struct qeth_qdio_out_q *queue,
 	if (atomic_read(&buffer->state) != QETH_QDIO_BUF_EMPTY)
 		return -EBUSY;
 
-	if ((buffer->next_element_to_fill + elements > queue->max_elements) ||
-	    !qeth_iqd_may_bulk(queue, buffer, skb, hdr)) {
-		atomic_set(&buffer->state, QETH_QDIO_BUF_PRIMED);
-		qeth_flush_queue(queue);
-		buffer = queue->bufs[queue->bulk_start];
+	flush = !qeth_iqd_may_bulk(queue, skb, hdr);
+
+	if (flush ||
+	    (buffer->next_element_to_fill + elements > queue->max_elements)) {
+		if (buffer->next_element_to_fill > 0) {
+			atomic_set(&buffer->state, QETH_QDIO_BUF_PRIMED);
+			queue->bulk_count++;
+		}
+
+		if (queue->bulk_count >= queue->bulk_max)
+			flush = true;
+
+		if (flush)
+			qeth_flush_queue(queue);
+
+		buffer = queue->bufs[QDIO_BUFNR(queue->bulk_start +
+						queue->bulk_count)];
 
 		/* Sanity-check again: */
 		if (atomic_read(&buffer->state) != QETH_QDIO_BUF_EMPTY)
@@ -3848,7 +3876,13 @@ static int __qeth_xmit(struct qeth_card *card, struct qeth_qdio_out_q *queue,
 
 	if (flush || next_element >= queue->max_elements) {
 		atomic_set(&buffer->state, QETH_QDIO_BUF_PRIMED);
-		qeth_flush_queue(queue);
+		queue->bulk_count++;
+
+		if (queue->bulk_count >= queue->bulk_max)
+			flush = true;
+
+		if (flush)
+			qeth_flush_queue(queue);
 	}
 
 	if (stopped && !qeth_out_queue_is_full(queue))
-- 
2.17.1

