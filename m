Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715AE1C5D75
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 18:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730687AbgEEQ0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 12:26:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10220 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730664AbgEEQ0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 12:26:11 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 045G76Nf097028;
        Tue, 5 May 2020 12:26:09 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s4v88arg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 12:26:09 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 045GJoN5002641;
        Tue, 5 May 2020 16:26:07 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 30s0g5jy95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 16:26:07 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 045GQ4Nm7602464
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 May 2020 16:26:04 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CD224203F;
        Tue,  5 May 2020 16:26:04 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1EF242042;
        Tue,  5 May 2020 16:26:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 May 2020 16:26:03 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 08/11] s390/qeth: set TX IRQ marker on last buffer in a group
Date:   Tue,  5 May 2020 18:25:56 +0200
Message-Id: <20200505162559.14138-9-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200505162559.14138-1-jwi@linux.ibm.com>
References: <20200505162559.14138-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_09:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050124
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When qeth_flush_buffers() gets called for a group of TX buffers
(currently up to 2 for OSA-style devices), the code iterates over each
buffer for some final processing.

During this processing, it sets the TX IRQ marker on the leading buffer
rather than the last one. This can result in delayed TX completion of
the trailing buffers. So pull the IRQ marker code out of the loop, and
apply it to the final buffer.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 4d1d053eebb7..164cc7f377fc 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -3617,11 +3617,11 @@ static int qeth_switch_to_nonpacking_if_needed(struct qeth_qdio_out_q *queue)
 static void qeth_flush_buffers(struct qeth_qdio_out_q *queue, int index,
 			       int count)
 {
+	struct qeth_qdio_out_buffer *buf = queue->bufs[index];
+	unsigned int qdio_flags = QDIO_FLAG_SYNC_OUTPUT;
 	struct qeth_card *card = queue->card;
-	struct qeth_qdio_out_buffer *buf;
 	int rc;
 	int i;
-	unsigned int qdio_flags;
 
 	for (i = index; i < index + count; ++i) {
 		unsigned int bidx = QDIO_BUFNR(i);
@@ -3638,9 +3638,10 @@ static void qeth_flush_buffers(struct qeth_qdio_out_q *queue, int index,
 		if (IS_IQD(card)) {
 			skb_queue_walk(&buf->skb_list, skb)
 				skb_tx_timestamp(skb);
-			continue;
 		}
+	}
 
+	if (!IS_IQD(card)) {
 		if (!queue->do_pack) {
 			if ((atomic_read(&queue->used_buffers) >=
 				(QETH_HIGH_WATERMARK_PACK -
@@ -3665,12 +3666,12 @@ static void qeth_flush_buffers(struct qeth_qdio_out_q *queue, int index,
 				buf->buffer->element[0].sflags |= SBAL_SFLAGS0_PCI_REQ;
 			}
 		}
+
+		if (atomic_read(&queue->set_pci_flags_count))
+			qdio_flags |= QDIO_FLAG_PCI_OUT;
 	}
 
 	QETH_TXQ_STAT_INC(queue, doorbell);
-	qdio_flags = QDIO_FLAG_SYNC_OUTPUT;
-	if (atomic_read(&queue->set_pci_flags_count))
-		qdio_flags |= QDIO_FLAG_PCI_OUT;
 	rc = do_QDIO(CARD_DDEV(queue->card), qdio_flags,
 		     queue->queue_no, index, count);
 
-- 
2.17.1

