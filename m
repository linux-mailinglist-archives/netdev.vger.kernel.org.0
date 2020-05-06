Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A271C6B09
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 10:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728751AbgEFIKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 04:10:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24730 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728712AbgEFIKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 04:10:00 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 046833XD144677;
        Wed, 6 May 2020 04:09:59 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30u8sp5kwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 04:09:59 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04685QL2021036;
        Wed, 6 May 2020 08:09:57 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 30s0g5rr5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 08:09:56 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04688iAY29622680
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 May 2020 08:08:44 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 42691A4054;
        Wed,  6 May 2020 08:09:54 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 079BBA4064;
        Wed,  6 May 2020 08:09:54 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  6 May 2020 08:09:53 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH v2 net-next 08/10] s390/qeth: set TX IRQ marker on last buffer in a group
Date:   Wed,  6 May 2020 10:09:47 +0200
Message-Id: <20200506080949.3915-9-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200506080949.3915-1-jwi@linux.ibm.com>
References: <20200506080949.3915-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-06_02:2020-05-04,2020-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 impostorscore=0 priorityscore=1501 phishscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 lowpriorityscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005060062
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

