Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBC399ABD9
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 11:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394257AbfHWJtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 05:49:07 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13346 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404760AbfHWJtF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 05:49:05 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7N9ki1u052469
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 05:49:03 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ujcj5k13y-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 05:49:03 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Fri, 23 Aug 2019 10:49:02 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 23 Aug 2019 10:48:58 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7N9mvTc58196166
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 09:48:57 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4340D42049;
        Fri, 23 Aug 2019 09:48:57 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F242842054;
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
Subject: [PATCH net-next 6/7] s390/qeth: add BQL support for IQD devices
Date:   Fri, 23 Aug 2019 11:48:52 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190823094853.63814-1-jwi@linux.ibm.com>
References: <20190823094853.63814-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19082309-0008-0000-0000-0000030C7418
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082309-0009-0000-0000-00004A2AA5DF
Message-Id: <20190823094853.63814-7-jwi@linux.ibm.com>
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

Each TX buffer may contain multiple skbs. So just accumulate the sent
byte count in the buffer struct, and later use the same count when
completing the buffer.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  1 +
 drivers/s390/net/qeth_core_main.c | 16 +++++++++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index ae2ae17e3e76..d5f796380cd0 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -426,6 +426,7 @@ struct qeth_qdio_out_buffer {
 	struct qdio_buffer *buffer;
 	atomic_t state;
 	int next_element_to_fill;
+	unsigned int bytes;
 	struct sk_buff_head skb_list;
 	int is_header[QDIO_MAX_ELEMENTS_PER_BUFFER];
 
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 70c7e675431e..4c7c7d320c9c 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1142,6 +1142,7 @@ static void qeth_clear_output_buffer(struct qeth_qdio_out_q *queue,
 
 	qeth_scrub_qdio_buffer(buf->buffer, queue->max_elements);
 	buf->next_element_to_fill = 0;
+	buf->bytes = 0;
 	atomic_set(&buf->state, QETH_QDIO_BUF_EMPTY);
 }
 
@@ -2673,6 +2674,7 @@ int qeth_init_qdio_queues(struct qeth_card *card)
 		atomic_set(&queue->used_buffers, 0);
 		atomic_set(&queue->set_pci_flags_count, 0);
 		atomic_set(&queue->state, QETH_OUT_Q_UNLOCKED);
+		netdev_tx_reset_queue(netdev_get_tx_queue(card->dev, i));
 	}
 	return 0;
 }
@@ -3790,6 +3792,7 @@ static int qeth_do_send_packet_fast(struct qeth_qdio_out_q *queue,
 {
 	int index = queue->next_buf_to_fill;
 	struct qeth_qdio_out_buffer *buffer = queue->bufs[index];
+	unsigned int bytes = qdisc_pkt_len(skb);
 	struct netdev_queue *txq;
 	bool stopped = false;
 
@@ -3811,6 +3814,9 @@ static int qeth_do_send_packet_fast(struct qeth_qdio_out_q *queue,
 	}
 
 	qeth_fill_buffer(queue, buffer, skb, hdr, offset, hd_len, stopped);
+	netdev_tx_sent_queue(txq, bytes);
+	buffer->bytes += bytes;
+
 	qeth_flush_buffers(queue, index, 1);
 
 	if (stopped && !qeth_out_queue_is_full(queue))
@@ -5186,6 +5192,8 @@ static int qeth_tx_poll(struct napi_struct *napi, int budget)
 
 	while (1) {
 		unsigned int start, error, i;
+		unsigned int packets = 0;
+		unsigned int bytes = 0;
 		int completed;
 
 		if (qeth_out_queue_is_empty(queue)) {
@@ -5211,13 +5219,19 @@ static int qeth_tx_poll(struct napi_struct *napi, int budget)
 		}
 
 		for (i = start; i < start + completed; i++) {
+			struct qeth_qdio_out_buffer *buffer;
 			unsigned int bidx = QDIO_BUFNR(i);
 
-			qeth_handle_send_error(card, queue->bufs[bidx], error);
+			buffer = queue->bufs[bidx];
+			packets += skb_queue_len(&buffer->skb_list);
+			bytes += buffer->bytes;
+
+			qeth_handle_send_error(card, buffer, error);
 			qeth_iqd_tx_complete(queue, bidx, error, budget);
 			qeth_cleanup_handled_pending(queue, bidx, false);
 		}
 
+		netdev_tx_completed_queue(txq, packets, bytes);
 		atomic_sub(completed, &queue->used_buffers);
 		work_done += completed;
 
-- 
2.17.1

