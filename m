Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66F069ABDA
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 11:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394266AbfHWJtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 05:49:07 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12050 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404398AbfHWJtF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 05:49:05 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7N9keWf087734
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 05:49:03 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ujavbprjt-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 05:49:03 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Fri, 23 Aug 2019 10:49:01 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 23 Aug 2019 10:48:59 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7N9mvaN24576222
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 09:48:57 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 991CC4204D;
        Fri, 23 Aug 2019 09:48:57 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 504DD42042;
        Fri, 23 Aug 2019 09:48:57 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 23 Aug 2019 09:48:57 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 7/7] s390/qeth: add xmit_more support for IQD devices
Date:   Fri, 23 Aug 2019 11:48:53 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190823094853.63814-1-jwi@linux.ibm.com>
References: <20190823094853.63814-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19082309-0020-0000-0000-000003631945
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082309-0021-0000-0000-000021B858BC
Message-Id: <20190823094853.63814-8-jwi@linux.ibm.com>
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

IQD devices offer limited support for bulking: all frames in a TX buffer
need to have the same target. qeth_iqd_may_bulk() implements this
constraint, and allows us to defer the TX doorbell until
(a) the buffer is full (since each buffer needs its own doorbell), or
(b) the entire TX queue is full, or
(b) we reached the BQL limit.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  24 ++++++
 drivers/s390/net/qeth_core_main.c | 128 ++++++++++++++++++++----------
 2 files changed, 109 insertions(+), 43 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index d5f796380cd0..e4b55f9aa062 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -378,6 +378,28 @@ enum qeth_header_ids {
 #define QETH_HDR_EXT_CSUM_TRANSP_REQ  0x20
 #define QETH_HDR_EXT_UDP	      0x40 /*bit off for TCP*/
 
+static inline bool qeth_l2_same_vlan(struct qeth_hdr_layer2 *h1,
+				     struct qeth_hdr_layer2 *h2)
+{
+	return !((h1->flags[2] ^ h2->flags[2]) & QETH_LAYER2_FLAG_VLAN) &&
+	       h1->vlan_id == h2->vlan_id;
+}
+
+static inline bool qeth_l3_iqd_same_vlan(struct qeth_hdr_layer3 *h1,
+					 struct qeth_hdr_layer3 *h2)
+{
+	return !((h1->ext_flags ^ h2->ext_flags) & QETH_HDR_EXT_VLAN_FRAME) &&
+	       h1->vlan_id == h2->vlan_id;
+}
+
+static inline bool qeth_l3_same_next_hop(struct qeth_hdr_layer3 *h1,
+					 struct qeth_hdr_layer3 *h2)
+{
+	return !((h1->flags ^ h2->flags) & QETH_HDR_IPV6) &&
+	       ipv6_addr_equal(&h1->next_hop.ipv6_addr,
+			       &h2->next_hop.ipv6_addr);
+}
+
 enum qeth_qdio_info_states {
 	QETH_QDIO_UNINITIALIZED,
 	QETH_QDIO_ALLOCATED,
@@ -508,6 +530,8 @@ struct qeth_qdio_out_q {
 	atomic_t set_pci_flags_count;
 	struct napi_struct napi;
 	struct timer_list timer;
+	struct qeth_hdr *prev_hdr;
+	u8 bulk_start;
 };
 
 #define qeth_for_each_output_queue(card, q, i)		\
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 4c7c7d320c9c..8b4ea5f2832b 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -2671,6 +2671,8 @@ int qeth_init_qdio_queues(struct qeth_card *card)
 		queue->max_elements = QETH_MAX_BUFFER_ELEMENTS(card);
 		queue->next_buf_to_fill = 0;
 		queue->do_pack = 0;
+		queue->prev_hdr = NULL;
+		queue->bulk_start = 0;
 		atomic_set(&queue->used_buffers, 0);
 		atomic_set(&queue->set_pci_flags_count, 0);
 		atomic_set(&queue->state, QETH_OUT_Q_UNLOCKED);
@@ -3314,6 +3316,14 @@ static void qeth_flush_buffers(struct qeth_qdio_out_q *queue, int index,
 	}
 }
 
+static void qeth_flush_queue(struct qeth_qdio_out_q *queue)
+{
+	qeth_flush_buffers(queue, queue->bulk_start, 1);
+
+	queue->bulk_start = QDIO_BUFNR(queue->bulk_start + 1);
+	queue->prev_hdr = NULL;
+}
+
 static void qeth_check_outbound_queue(struct qeth_qdio_out_q *queue)
 {
 	int index;
@@ -3669,9 +3679,32 @@ static int qeth_add_hw_header(struct qeth_qdio_out_q *queue,
 	return 0;
 }
 
-static void __qeth_fill_buffer(struct sk_buff *skb,
-			       struct qeth_qdio_out_buffer *buf,
-			       bool is_first_elem, unsigned int offset)
+static bool qeth_iqd_may_bulk(struct qeth_qdio_out_q *queue,
+			      struct qeth_qdio_out_buffer *buffer,
+			      struct sk_buff *curr_skb,
+			      struct qeth_hdr *curr_hdr)
+{
+	struct qeth_hdr *prev_hdr = queue->prev_hdr;
+
+	if (!prev_hdr)
+		return true;
+
+	/* All packets must have the same target: */
+	if (curr_hdr->hdr.l2.id == QETH_HEADER_TYPE_LAYER2) {
+		struct sk_buff *prev_skb = skb_peek(&buffer->skb_list);
+
+		return ether_addr_equal(eth_hdr(prev_skb)->h_dest,
+					eth_hdr(curr_skb)->h_dest) &&
+		       qeth_l2_same_vlan(&prev_hdr->hdr.l2, &curr_hdr->hdr.l2);
+	}
+
+	return qeth_l3_same_next_hop(&prev_hdr->hdr.l3, &curr_hdr->hdr.l3) &&
+	       qeth_l3_iqd_same_vlan(&prev_hdr->hdr.l3, &curr_hdr->hdr.l3);
+}
+
+static unsigned int __qeth_fill_buffer(struct sk_buff *skb,
+				       struct qeth_qdio_out_buffer *buf,
+				       bool is_first_elem, unsigned int offset)
 {
 	struct qdio_buffer *buffer = buf->buffer;
 	int element = buf->next_element_to_fill;
@@ -3728,24 +3761,21 @@ static void __qeth_fill_buffer(struct sk_buff *skb,
 	if (buffer->element[element - 1].eflags)
 		buffer->element[element - 1].eflags = SBAL_EFLAGS_LAST_FRAG;
 	buf->next_element_to_fill = element;
+	return element;
 }
 
 /**
  * qeth_fill_buffer() - map skb into an output buffer
- * @queue:	QDIO queue to submit the buffer on
  * @buf:	buffer to transport the skb
  * @skb:	skb to map into the buffer
  * @hdr:	qeth_hdr for this skb. Either at skb->data, or allocated
  *		from qeth_core_header_cache.
  * @offset:	when mapping the skb, start at skb->data + offset
  * @hd_len:	if > 0, build a dedicated header element of this size
- * flush:	Prepare the buffer to be flushed, regardless of its fill level.
  */
-static int qeth_fill_buffer(struct qeth_qdio_out_q *queue,
-			    struct qeth_qdio_out_buffer *buf,
-			    struct sk_buff *skb, struct qeth_hdr *hdr,
-			    unsigned int offset, unsigned int hd_len,
-			    bool flush)
+static unsigned int qeth_fill_buffer(struct qeth_qdio_out_buffer *buf,
+				     struct sk_buff *skb, struct qeth_hdr *hdr,
+				     unsigned int offset, unsigned int hd_len)
 {
 	struct qdio_buffer *buffer = buf->buffer;
 	bool is_first_elem = true;
@@ -3765,36 +3795,22 @@ static int qeth_fill_buffer(struct qeth_qdio_out_q *queue,
 		buf->next_element_to_fill++;
 	}
 
-	__qeth_fill_buffer(skb, buf, is_first_elem, offset);
-
-	if (!queue->do_pack) {
-		QETH_CARD_TEXT(queue->card, 6, "fillbfnp");
-	} else {
-		QETH_CARD_TEXT(queue->card, 6, "fillbfpa");
-
-		QETH_TXQ_STAT_INC(queue, skbs_pack);
-		/* If the buffer still has free elements, keep using it. */
-		if (!flush &&
-		    buf->next_element_to_fill < queue->max_elements)
-			return 0;
-	}
-
-	/* flush out the buffer */
-	atomic_set(&buf->state, QETH_QDIO_BUF_PRIMED);
-	queue->next_buf_to_fill = (queue->next_buf_to_fill + 1) %
-				  QDIO_MAX_BUFFERS_PER_Q;
-	return 1;
+	return __qeth_fill_buffer(skb, buf, is_first_elem, offset);
 }
 
-static int qeth_do_send_packet_fast(struct qeth_qdio_out_q *queue,
-				    struct sk_buff *skb, struct qeth_hdr *hdr,
-				    unsigned int offset, unsigned int hd_len)
+static int __qeth_xmit(struct qeth_card *card, struct qeth_qdio_out_q *queue,
+		       struct sk_buff *skb, unsigned int elements,
+		       struct qeth_hdr *hdr, unsigned int offset,
+		       unsigned int hd_len)
 {
-	int index = queue->next_buf_to_fill;
-	struct qeth_qdio_out_buffer *buffer = queue->bufs[index];
+	struct qeth_qdio_out_buffer *buffer = queue->bufs[queue->bulk_start];
 	unsigned int bytes = qdisc_pkt_len(skb);
+	unsigned int next_element;
 	struct netdev_queue *txq;
 	bool stopped = false;
+	bool flush;
+
+	txq = netdev_get_tx_queue(card->dev, skb_get_queue_mapping(skb));
 
 	/* Just a sanity check, the wake/stop logic should ensure that we always
 	 * get a free buffer.
@@ -3802,9 +3818,19 @@ static int qeth_do_send_packet_fast(struct qeth_qdio_out_q *queue,
 	if (atomic_read(&buffer->state) != QETH_QDIO_BUF_EMPTY)
 		return -EBUSY;
 
-	txq = netdev_get_tx_queue(queue->card->dev, skb_get_queue_mapping(skb));
+	if ((buffer->next_element_to_fill + elements > queue->max_elements) ||
+	    !qeth_iqd_may_bulk(queue, buffer, skb, hdr)) {
+		atomic_set(&buffer->state, QETH_QDIO_BUF_PRIMED);
+		qeth_flush_queue(queue);
+		buffer = queue->bufs[queue->bulk_start];
 
-	if (atomic_inc_return(&queue->used_buffers) >= QDIO_MAX_BUFFERS_PER_Q) {
+		/* Sanity-check again: */
+		if (atomic_read(&buffer->state) != QETH_QDIO_BUF_EMPTY)
+			return -EBUSY;
+	}
+
+	if (buffer->next_element_to_fill == 0 &&
+	    atomic_inc_return(&queue->used_buffers) >= QDIO_MAX_BUFFERS_PER_Q) {
 		/* If a TX completion happens right _here_ and misses to wake
 		 * the txq, then our re-check below will catch the race.
 		 */
@@ -3813,11 +3839,17 @@ static int qeth_do_send_packet_fast(struct qeth_qdio_out_q *queue,
 		stopped = true;
 	}
 
-	qeth_fill_buffer(queue, buffer, skb, hdr, offset, hd_len, stopped);
-	netdev_tx_sent_queue(txq, bytes);
+	next_element = qeth_fill_buffer(buffer, skb, hdr, offset, hd_len);
 	buffer->bytes += bytes;
+	queue->prev_hdr = hdr;
 
-	qeth_flush_buffers(queue, index, 1);
+	flush = __netdev_tx_sent_queue(txq, bytes,
+				       !stopped && netdev_xmit_more());
+
+	if (flush || next_element >= queue->max_elements) {
+		atomic_set(&buffer->state, QETH_QDIO_BUF_PRIMED);
+		qeth_flush_queue(queue);
+	}
 
 	if (stopped && !qeth_out_queue_is_full(queue))
 		netif_tx_start_queue(txq);
@@ -3830,6 +3862,7 @@ int qeth_do_send_packet(struct qeth_card *card, struct qeth_qdio_out_q *queue,
 			int elements_needed)
 {
 	struct qeth_qdio_out_buffer *buffer;
+	unsigned int next_element;
 	struct netdev_queue *txq;
 	bool stopped = false;
 	int start_index;
@@ -3892,8 +3925,17 @@ int qeth_do_send_packet(struct qeth_card *card, struct qeth_qdio_out_q *queue,
 		stopped = true;
 	}
 
-	flush_count += qeth_fill_buffer(queue, buffer, skb, hdr, offset, hd_len,
-					stopped);
+	next_element = qeth_fill_buffer(buffer, skb, hdr, offset, hd_len);
+
+	if (queue->do_pack)
+		QETH_TXQ_STAT_INC(queue, skbs_pack);
+	if (!queue->do_pack || stopped || next_element >= queue->max_elements) {
+		flush_count++;
+		atomic_set(&buffer->state, QETH_QDIO_BUF_PRIMED);
+		queue->next_buf_to_fill = (queue->next_buf_to_fill + 1) %
+					  QDIO_MAX_BUFFERS_PER_Q;
+	}
+
 	if (flush_count)
 		qeth_flush_buffers(queue, start_index, flush_count);
 	else if (!atomic_read(&queue->set_pci_flags_count))
@@ -3989,8 +4031,8 @@ int qeth_xmit(struct qeth_card *card, struct sk_buff *skb,
 				  frame_len - proto_len, skb, proto_len);
 
 	if (IS_IQD(card)) {
-		rc = qeth_do_send_packet_fast(queue, skb, hdr, data_offset,
-					      hd_len);
+		rc = __qeth_xmit(card, queue, skb, elements, hdr, data_offset,
+				 hd_len);
 	} else {
 		/* TODO: drop skb_orphan() once TX completion is fast enough */
 		skb_orphan(skb);
-- 
2.17.1

