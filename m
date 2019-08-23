Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEA419ABD2
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 11:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394191AbfHWJtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 05:49:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20366 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2394105AbfHWJtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 05:49:02 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7N9kaKb005606
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 05:49:01 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ujap9fbmd-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 05:49:01 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Fri, 23 Aug 2019 10:48:59 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 23 Aug 2019 10:48:58 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7N9mZJ421037480
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 09:48:35 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D0F342042;
        Fri, 23 Aug 2019 09:48:56 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E835942049;
        Fri, 23 Aug 2019 09:48:55 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 23 Aug 2019 09:48:55 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 3/7] s390/qeth: collect accurate TX statistics
Date:   Fri, 23 Aug 2019 11:48:49 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190823094853.63814-1-jwi@linux.ibm.com>
References: <20190823094853.63814-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19082309-4275-0000-0000-0000035C8040
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082309-4276-0000-0000-0000386EA8F4
Message-Id: <20190823094853.63814-4-jwi@linux.ibm.com>
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

This consolidates the SW statistics code, and improves it to
(1) account for the header overhead of each segment on a TSO skb,
(2) count dangling packets as in-error (during eg. shutdown), and
(3) only count offloads when the skb was successfully transmitted.

We also count each segment of an TSO skb as one packet - except for
tx_dropped, to be consistent with dev->tx_dropped.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  1 +
 drivers/s390/net/qeth_core_main.c | 66 +++++++++++++++++++------------
 drivers/s390/net/qeth_l2_main.c   | 12 ++----
 drivers/s390/net/qeth_l3_main.c   |  9 ++---
 4 files changed, 49 insertions(+), 39 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 72755a025b4d..a0911ce55db3 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -30,6 +30,7 @@
 #include <net/ipv6.h>
 #include <net/if_inet6.h>
 #include <net/addrconf.h>
+#include <net/sch_generic.h>
 #include <net/tcp.h>
 
 #include <asm/debug.h>
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 44fbaa4f7264..d7a15a88bdba 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -71,7 +71,7 @@ static void qeth_free_qdio_queues(struct qeth_card *card);
 static void qeth_notify_skbs(struct qeth_qdio_out_q *queue,
 		struct qeth_qdio_out_buffer *buf,
 		enum iucv_tx_notify notification);
-static void qeth_release_skbs(struct qeth_qdio_out_buffer *buf);
+static void qeth_tx_complete_buf(struct qeth_qdio_out_buffer *buf, bool error);
 static int qeth_init_qdio_out_buf(struct qeth_qdio_out_q *, int);
 
 static void qeth_close_dev_handler(struct work_struct *work)
@@ -411,7 +411,7 @@ static void qeth_cleanup_handled_pending(struct qeth_qdio_out_q *q, int bidx,
 				/* release here to avoid interleaving between
 				   outbound tasklet and inbound tasklet
 				   regarding notifications and lifecycle */
-				qeth_release_skbs(c);
+				qeth_tx_complete_buf(c, forced_cleanup);
 
 				c = f->next_pending;
 				WARN_ON_ONCE(head->next_pending != f);
@@ -1077,22 +1077,51 @@ static void qeth_notify_skbs(struct qeth_qdio_out_q *q,
 	}
 }
 
-static void qeth_release_skbs(struct qeth_qdio_out_buffer *buf)
+static void qeth_tx_complete_buf(struct qeth_qdio_out_buffer *buf, bool error)
 {
+	struct qeth_qdio_out_q *queue = buf->q;
 	struct sk_buff *skb;
 
 	/* release may never happen from within CQ tasklet scope */
 	WARN_ON_ONCE(atomic_read(&buf->state) == QETH_QDIO_BUF_IN_CQ);
 
 	if (atomic_read(&buf->state) == QETH_QDIO_BUF_PENDING)
-		qeth_notify_skbs(buf->q, buf, TX_NOTIFY_GENERALERROR);
+		qeth_notify_skbs(queue, buf, TX_NOTIFY_GENERALERROR);
+
+	/* Empty buffer? */
+	if (buf->next_element_to_fill == 0)
+		return;
+
+	QETH_TXQ_STAT_INC(queue, bufs);
+	QETH_TXQ_STAT_ADD(queue, buf_elements, buf->next_element_to_fill);
+	while ((skb = __skb_dequeue(&buf->skb_list)) != NULL) {
+		unsigned int bytes = qdisc_pkt_len(skb);
+		bool is_tso = skb_is_gso(skb);
+		unsigned int packets;
+
+		packets = is_tso ? skb_shinfo(skb)->gso_segs : 1;
+		if (error) {
+			QETH_TXQ_STAT_ADD(queue, tx_errors, packets);
+		} else {
+			QETH_TXQ_STAT_ADD(queue, tx_packets, packets);
+			QETH_TXQ_STAT_ADD(queue, tx_bytes, bytes);
+			if (skb->ip_summed == CHECKSUM_PARTIAL)
+				QETH_TXQ_STAT_ADD(queue, skbs_csum, packets);
+			if (skb_is_nonlinear(skb))
+				QETH_TXQ_STAT_INC(queue, skbs_sg);
+			if (is_tso) {
+				QETH_TXQ_STAT_INC(queue, skbs_tso);
+				QETH_TXQ_STAT_ADD(queue, tso_bytes, bytes);
+			}
+		}
 
-	while ((skb = __skb_dequeue(&buf->skb_list)) != NULL)
 		consume_skb(skb);
+	}
 }
 
 static void qeth_clear_output_buffer(struct qeth_qdio_out_q *queue,
-				     struct qeth_qdio_out_buffer *buf)
+				     struct qeth_qdio_out_buffer *buf,
+				     bool error)
 {
 	int i;
 
@@ -1100,7 +1129,7 @@ static void qeth_clear_output_buffer(struct qeth_qdio_out_q *queue,
 	if (buf->buffer->element[0].sflags & SBAL_SFLAGS0_PCI_REQ)
 		atomic_dec(&queue->set_pci_flags_count);
 
-	qeth_release_skbs(buf);
+	qeth_tx_complete_buf(buf, error);
 
 	for (i = 0; i < queue->max_elements; ++i) {
 		if (buf->buffer->element[i].addr && buf->is_header[i])
@@ -1122,7 +1151,7 @@ static void qeth_drain_output_queue(struct qeth_qdio_out_q *q, bool free)
 		if (!q->bufs[j])
 			continue;
 		qeth_cleanup_handled_pending(q, j, 1);
-		qeth_clear_output_buffer(q, q->bufs[j]);
+		qeth_clear_output_buffer(q, q->bufs[j], true);
 		if (free) {
 			kmem_cache_free(qeth_qdio_outbuf_cache, q->bufs[j]);
 			q->bufs[j] = NULL;
@@ -3240,14 +3269,12 @@ static void qeth_flush_buffers(struct qeth_qdio_out_q *queue, int index,
 		}
 	}
 
-	QETH_TXQ_STAT_ADD(queue, bufs, count);
 	qdio_flags = QDIO_FLAG_SYNC_OUTPUT;
 	if (atomic_read(&queue->set_pci_flags_count))
 		qdio_flags |= QDIO_FLAG_PCI_OUT;
 	rc = do_QDIO(CARD_DDEV(queue->card), qdio_flags,
 		     queue->queue_no, index, count);
 	if (rc) {
-		QETH_TXQ_STAT_ADD(queue, tx_errors, count);
 		/* ignore temporary SIGA errors without busy condition */
 		if (rc == -ENOBUFS)
 			return;
@@ -3456,7 +3483,7 @@ static void qeth_qdio_output_handler(struct ccw_device *ccwdev,
 				qeth_notify_skbs(queue, buffer, n);
 			}
 
-			qeth_clear_output_buffer(queue, buffer);
+			qeth_clear_output_buffer(queue, buffer, qdio_error);
 		}
 		qeth_cleanup_handled_pending(queue, bidx, 0);
 	}
@@ -3942,7 +3969,6 @@ int qeth_xmit(struct qeth_card *card, struct sk_buff *skb,
 	unsigned int hd_len = 0;
 	unsigned int elements;
 	int push_len, rc;
-	bool is_sg;
 
 	if (is_tso) {
 		hw_hdr_len = sizeof(struct qeth_hdr_tso);
@@ -3971,7 +3997,6 @@ int qeth_xmit(struct qeth_card *card, struct sk_buff *skb,
 		qeth_fill_tso_ext((struct qeth_hdr_tso *) hdr,
 				  frame_len - proto_len, skb, proto_len);
 
-	is_sg = skb_is_nonlinear(skb);
 	if (IS_IQD(card)) {
 		rc = qeth_do_send_packet_fast(queue, skb, hdr, data_offset,
 					      hd_len);
@@ -3982,18 +4007,9 @@ int qeth_xmit(struct qeth_card *card, struct sk_buff *skb,
 					 hd_len, elements);
 	}
 
-	if (!rc) {
-		QETH_TXQ_STAT_ADD(queue, buf_elements, elements);
-		if (is_sg)
-			QETH_TXQ_STAT_INC(queue, skbs_sg);
-		if (is_tso) {
-			QETH_TXQ_STAT_INC(queue, skbs_tso);
-			QETH_TXQ_STAT_ADD(queue, tso_bytes, frame_len);
-		}
-	} else {
-		if (!push_len)
-			kmem_cache_free(qeth_core_header_cache, hdr);
-	}
+	if (rc && !push_len)
+		kmem_cache_free(qeth_core_header_cache, hdr);
+
 	return rc;
 }
 EXPORT_SYMBOL_GPL(qeth_xmit);
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 662bd51f922f..b8799cd3e7aa 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -175,10 +175,8 @@ static void qeth_l2_fill_header(struct qeth_qdio_out_q *queue,
 		hdr->hdr.l2.id = QETH_HEADER_TYPE_L2_TSO;
 	} else {
 		hdr->hdr.l2.id = QETH_HEADER_TYPE_LAYER2;
-		if (skb->ip_summed == CHECKSUM_PARTIAL) {
+		if (skb->ip_summed == CHECKSUM_PARTIAL)
 			qeth_tx_csum(skb, &hdr->hdr.l2.flags[1], ipv);
-			QETH_TXQ_STAT_INC(queue, skbs_csum);
-		}
 	}
 
 	/* set byte byte 3 to casting flags */
@@ -588,9 +586,10 @@ static netdev_tx_t qeth_l2_hard_start_xmit(struct sk_buff *skb,
 	struct qeth_card *card = dev->ml_priv;
 	u16 txq = skb_get_queue_mapping(skb);
 	struct qeth_qdio_out_q *queue;
-	int tx_bytes = skb->len;
 	int rc;
 
+	if (!skb_is_gso(skb))
+		qdisc_skb_cb(skb)->pkt_len = skb->len;
 	if (IS_IQD(card))
 		txq = qeth_iqd_translate_txq(dev, txq);
 	queue = card->qdio.out_qs[txq];
@@ -601,11 +600,8 @@ static netdev_tx_t qeth_l2_hard_start_xmit(struct sk_buff *skb,
 		rc = qeth_xmit(card, skb, queue, qeth_get_ip_version(skb),
 			       qeth_l2_fill_header);
 
-	if (!rc) {
-		QETH_TXQ_STAT_INC(queue, tx_packets);
-		QETH_TXQ_STAT_ADD(queue, tx_bytes, tx_bytes);
+	if (!rc)
 		return NETDEV_TX_OK;
-	}
 
 	QETH_TXQ_STAT_INC(queue, tx_dropped);
 	kfree_skb(skb);
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 54799fe6a700..d7bfc7a0e4c0 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1957,7 +1957,6 @@ static void qeth_l3_fill_header(struct qeth_qdio_out_q *queue,
 			/* some HW requires combined L3+L4 csum offload: */
 			if (ipv == 4)
 				hdr->hdr.l3.ext_flags |= QETH_HDR_EXT_CSUM_HDR_REQ;
-			QETH_TXQ_STAT_INC(queue, skbs_csum);
 		}
 	}
 
@@ -2044,9 +2043,10 @@ static netdev_tx_t qeth_l3_hard_start_xmit(struct sk_buff *skb,
 	u16 txq = skb_get_queue_mapping(skb);
 	int ipv = qeth_get_ip_version(skb);
 	struct qeth_qdio_out_q *queue;
-	int tx_bytes = skb->len;
 	int rc;
 
+	if (!skb_is_gso(skb))
+		qdisc_skb_cb(skb)->pkt_len = skb->len;
 	if (IS_IQD(card)) {
 		queue = card->qdio.out_qs[qeth_iqd_translate_txq(dev, txq)];
 
@@ -2069,11 +2069,8 @@ static netdev_tx_t qeth_l3_hard_start_xmit(struct sk_buff *skb,
 	else
 		rc = qeth_xmit(card, skb, queue, ipv, qeth_l3_fill_header);
 
-	if (!rc) {
-		QETH_TXQ_STAT_INC(queue, tx_packets);
-		QETH_TXQ_STAT_ADD(queue, tx_bytes, tx_bytes);
+	if (!rc)
 		return NETDEV_TX_OK;
-	}
 
 tx_drop:
 	QETH_TXQ_STAT_INC(queue, tx_dropped);
-- 
2.17.1

