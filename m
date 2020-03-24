Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07E121918F1
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 19:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgCXSZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 14:25:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8260 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727772AbgCXSZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 14:25:02 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02OI73lF142333
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 14:25:02 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ywbuvs568-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 14:25:01 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Tue, 24 Mar 2020 18:24:57 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 24 Mar 2020 18:24:56 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02OIOu5Z59441332
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 18:24:56 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE4DAA4054;
        Tue, 24 Mar 2020 18:24:56 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 870E4A405B;
        Tue, 24 Mar 2020 18:24:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 Mar 2020 18:24:56 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 07/11] s390/qeth: collect more TX statistics
Date:   Tue, 24 Mar 2020 19:24:44 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200324182448.95362-1-jwi@linux.ibm.com>
References: <20200324182448.95362-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20032418-4275-0000-0000-000003B24528
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032418-4276-0000-0000-000038C77FF1
Message-Id: <20200324182448.95362-8-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-24_05:2020-03-23,2020-03-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 impostorscore=0 mlxlogscore=999
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240090
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Count the number of TX doorbells we issue to the qdio layer.

Also count the number of actual frames in a TX buffer, and then
use this data along with the byte count during TX completion.
We'll make additional use of the frame count in a subsequent patch.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  2 ++
 drivers/s390/net/qeth_core_main.c | 20 ++++++++++++++------
 drivers/s390/net/qeth_ethtool.c   |  1 +
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 911dcef6adc6..f56670bfcd0a 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -402,6 +402,7 @@ struct qeth_qdio_out_buffer {
 	struct qdio_buffer *buffer;
 	atomic_t state;
 	int next_element_to_fill;
+	unsigned int frames;
 	unsigned int bytes;
 	struct sk_buff_head skb_list;
 	int is_header[QDIO_MAX_ELEMENTS_PER_BUFFER];
@@ -457,6 +458,7 @@ struct qeth_out_q_stats {
 	u64 tso_bytes;
 	u64 packing_mode_switch;
 	u64 stopped;
+	u64 doorbell;
 	u64 completion_yield;
 	u64 completion_timer;
 
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 07b2231f028f..1bf48054723d 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1155,17 +1155,20 @@ static void qeth_tx_complete_buf(struct qeth_qdio_out_buffer *buf, bool error,
 
 	QETH_TXQ_STAT_INC(queue, bufs);
 	QETH_TXQ_STAT_ADD(queue, buf_elements, buf->next_element_to_fill);
+	if (error) {
+		QETH_TXQ_STAT_ADD(queue, tx_errors, buf->frames);
+	} else {
+		QETH_TXQ_STAT_ADD(queue, tx_packets, buf->frames);
+		QETH_TXQ_STAT_ADD(queue, tx_bytes, buf->bytes);
+	}
+
 	while ((skb = __skb_dequeue(&buf->skb_list)) != NULL) {
 		unsigned int bytes = qdisc_pkt_len(skb);
 		bool is_tso = skb_is_gso(skb);
 		unsigned int packets;
 
 		packets = is_tso ? skb_shinfo(skb)->gso_segs : 1;
-		if (error) {
-			QETH_TXQ_STAT_ADD(queue, tx_errors, packets);
-		} else {
-			QETH_TXQ_STAT_ADD(queue, tx_packets, packets);
-			QETH_TXQ_STAT_ADD(queue, tx_bytes, bytes);
+		if (!error) {
 			if (skb->ip_summed == CHECKSUM_PARTIAL)
 				QETH_TXQ_STAT_ADD(queue, skbs_csum, packets);
 			if (skb_is_nonlinear(skb))
@@ -1202,6 +1205,7 @@ static void qeth_clear_output_buffer(struct qeth_qdio_out_q *queue,
 
 	qeth_scrub_qdio_buffer(buf->buffer, queue->max_elements);
 	buf->next_element_to_fill = 0;
+	buf->frames = 0;
 	buf->bytes = 0;
 	atomic_set(&buf->state, QETH_QDIO_BUF_EMPTY);
 }
@@ -3389,6 +3393,7 @@ static void qeth_flush_buffers(struct qeth_qdio_out_q *queue, int index,
 		}
 	}
 
+	QETH_TXQ_STAT_INC(queue, doorbell);
 	qdio_flags = QDIO_FLAG_SYNC_OUTPUT;
 	if (atomic_read(&queue->set_pci_flags_count))
 		qdio_flags |= QDIO_FLAG_PCI_OUT;
@@ -3942,6 +3947,7 @@ static int __qeth_xmit(struct qeth_card *card, struct qeth_qdio_out_q *queue,
 
 	next_element = qeth_fill_buffer(buffer, skb, hdr, offset, hd_len);
 	buffer->bytes += bytes;
+	buffer->frames += skb_is_gso(skb) ? skb_shinfo(skb)->gso_segs : 1;
 	queue->prev_hdr = hdr;
 
 	flush = __netdev_tx_sent_queue(txq, bytes,
@@ -4032,6 +4038,8 @@ int qeth_do_send_packet(struct qeth_card *card, struct qeth_qdio_out_q *queue,
 	}
 
 	next_element = qeth_fill_buffer(buffer, skb, hdr, offset, hd_len);
+	buffer->bytes += qdisc_pkt_len(skb);
+	buffer->frames += skb_is_gso(skb) ? skb_shinfo(skb)->gso_segs : 1;
 
 	if (queue->do_pack)
 		QETH_TXQ_STAT_INC(queue, skbs_pack);
@@ -5668,7 +5676,7 @@ static int qeth_tx_poll(struct napi_struct *napi, int budget)
 			unsigned int bidx = QDIO_BUFNR(i);
 
 			buffer = queue->bufs[bidx];
-			packets += skb_queue_len(&buffer->skb_list);
+			packets += buffer->frames;
 			bytes += buffer->bytes;
 
 			qeth_handle_send_error(card, buffer, error);
diff --git a/drivers/s390/net/qeth_ethtool.c b/drivers/s390/net/qeth_ethtool.c
index 31e019085fc3..6f0cc6fcc759 100644
--- a/drivers/s390/net/qeth_ethtool.c
+++ b/drivers/s390/net/qeth_ethtool.c
@@ -39,6 +39,7 @@ static const struct qeth_stats txq_stats[] = {
 	QETH_TXQ_STAT("TSO bytes", tso_bytes),
 	QETH_TXQ_STAT("Packing mode switches", packing_mode_switch),
 	QETH_TXQ_STAT("Queue stopped", stopped),
+	QETH_TXQ_STAT("Doorbell", doorbell),
 	QETH_TXQ_STAT("Completion yield", completion_yield),
 	QETH_TXQ_STAT("Completion timer", completion_timer),
 };
-- 
2.17.1

