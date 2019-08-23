Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 928599ABD6
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 11:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404866AbfHWJtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 05:49:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35296 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2394135AbfHWJtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 05:49:03 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7N9kfcs067755
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 05:49:02 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ujbmg564e-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 05:49:02 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Fri, 23 Aug 2019 10:49:00 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 23 Aug 2019 10:48:58 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7N9mvrk53281000
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 09:48:57 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBB4842041;
        Fri, 23 Aug 2019 09:48:56 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A01154204B;
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
Subject: [PATCH net-next 5/7] s390/qeth: when in TX NAPI mode, use napi_consume_skb()
Date:   Fri, 23 Aug 2019 11:48:51 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190823094853.63814-1-jwi@linux.ibm.com>
References: <20190823094853.63814-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19082309-0016-0000-0000-000002A218AA
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082309-0017-0000-0000-000033025605
Message-Id: <20190823094853.63814-6-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-23_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908230102
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows the stack to bulk-free our TX-completed skbs.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 3223ad80998c..70c7e675431e 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -71,7 +71,8 @@ static void qeth_free_qdio_queues(struct qeth_card *card);
 static void qeth_notify_skbs(struct qeth_qdio_out_q *queue,
 		struct qeth_qdio_out_buffer *buf,
 		enum iucv_tx_notify notification);
-static void qeth_tx_complete_buf(struct qeth_qdio_out_buffer *buf, bool error);
+static void qeth_tx_complete_buf(struct qeth_qdio_out_buffer *buf, bool error,
+				 int budget);
 static int qeth_init_qdio_out_buf(struct qeth_qdio_out_q *, int);
 
 static void qeth_close_dev_handler(struct work_struct *work)
@@ -411,7 +412,7 @@ static void qeth_cleanup_handled_pending(struct qeth_qdio_out_q *q, int bidx,
 				/* release here to avoid interleaving between
 				   outbound tasklet and inbound tasklet
 				   regarding notifications and lifecycle */
-				qeth_tx_complete_buf(c, forced_cleanup);
+				qeth_tx_complete_buf(c, forced_cleanup, 0);
 
 				c = f->next_pending;
 				WARN_ON_ONCE(head->next_pending != f);
@@ -1077,7 +1078,8 @@ static void qeth_notify_skbs(struct qeth_qdio_out_q *q,
 	}
 }
 
-static void qeth_tx_complete_buf(struct qeth_qdio_out_buffer *buf, bool error)
+static void qeth_tx_complete_buf(struct qeth_qdio_out_buffer *buf, bool error,
+				 int budget)
 {
 	struct qeth_qdio_out_q *queue = buf->q;
 	struct sk_buff *skb;
@@ -1115,13 +1117,13 @@ static void qeth_tx_complete_buf(struct qeth_qdio_out_buffer *buf, bool error)
 			}
 		}
 
-		consume_skb(skb);
+		napi_consume_skb(skb, budget);
 	}
 }
 
 static void qeth_clear_output_buffer(struct qeth_qdio_out_q *queue,
 				     struct qeth_qdio_out_buffer *buf,
-				     bool error)
+				     bool error, int budget)
 {
 	int i;
 
@@ -1129,7 +1131,7 @@ static void qeth_clear_output_buffer(struct qeth_qdio_out_q *queue,
 	if (buf->buffer->element[0].sflags & SBAL_SFLAGS0_PCI_REQ)
 		atomic_dec(&queue->set_pci_flags_count);
 
-	qeth_tx_complete_buf(buf, error);
+	qeth_tx_complete_buf(buf, error, budget);
 
 	for (i = 0; i < queue->max_elements; ++i) {
 		if (buf->buffer->element[i].addr && buf->is_header[i])
@@ -1151,7 +1153,7 @@ static void qeth_drain_output_queue(struct qeth_qdio_out_q *q, bool free)
 		if (!q->bufs[j])
 			continue;
 		qeth_cleanup_handled_pending(q, j, 1);
-		qeth_clear_output_buffer(q, q->bufs[j], true);
+		qeth_clear_output_buffer(q, q->bufs[j], true, 0);
 		if (free) {
 			kmem_cache_free(qeth_qdio_outbuf_cache, q->bufs[j]);
 			q->bufs[j] = NULL;
@@ -3471,7 +3473,7 @@ static void qeth_qdio_output_handler(struct ccw_device *ccwdev,
 		int bidx = i % QDIO_MAX_BUFFERS_PER_Q;
 		buffer = queue->bufs[bidx];
 		qeth_handle_send_error(card, buffer, qdio_error);
-		qeth_clear_output_buffer(queue, buffer, qdio_error);
+		qeth_clear_output_buffer(queue, buffer, qdio_error, 0);
 	}
 
 	atomic_sub(count, &queue->used_buffers);
@@ -5138,7 +5140,7 @@ int qeth_poll(struct napi_struct *napi, int budget)
 EXPORT_SYMBOL_GPL(qeth_poll);
 
 static void qeth_iqd_tx_complete(struct qeth_qdio_out_q *queue,
-				 unsigned int bidx, bool error)
+				 unsigned int bidx, bool error, int budget)
 {
 	struct qeth_qdio_out_buffer *buffer = queue->bufs[bidx];
 	u8 sflags = buffer->buffer->element[15].sflags;
@@ -5168,7 +5170,7 @@ static void qeth_iqd_tx_complete(struct qeth_qdio_out_q *queue,
 	if (card->options.cq == QETH_CQ_ENABLED)
 		qeth_notify_skbs(queue, buffer,
 				 qeth_compute_cq_notification(sflags, 0));
-	qeth_clear_output_buffer(queue, buffer, error);
+	qeth_clear_output_buffer(queue, buffer, error, budget);
 }
 
 static int qeth_tx_poll(struct napi_struct *napi, int budget)
@@ -5212,7 +5214,7 @@ static int qeth_tx_poll(struct napi_struct *napi, int budget)
 			unsigned int bidx = QDIO_BUFNR(i);
 
 			qeth_handle_send_error(card, queue->bufs[bidx], error);
-			qeth_iqd_tx_complete(queue, bidx, error);
+			qeth_iqd_tx_complete(queue, bidx, error, budget);
 			qeth_cleanup_handled_pending(queue, bidx, false);
 		}
 
-- 
2.17.1

