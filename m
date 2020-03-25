Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 615EF19243C
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 10:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbgCYJfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 05:35:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32770 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726239AbgCYJfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 05:35:15 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02P9Y3oV087465
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 05:35:15 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ywbthr6k5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 05:35:14 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Wed, 25 Mar 2020 09:35:10 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 25 Mar 2020 09:35:08 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02P9Z8Ug44957894
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Mar 2020 09:35:08 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE586A4055;
        Wed, 25 Mar 2020 09:35:08 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82879A405D;
        Wed, 25 Mar 2020 09:35:08 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 25 Mar 2020 09:35:08 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH v2 net-next 01/11] s390/qeth: simplify RX buffer tracking
Date:   Wed, 25 Mar 2020 10:34:57 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200325093507.20831-1-jwi@linux.ibm.com>
References: <20200325093507.20831-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20032509-0012-0000-0000-0000039760F3
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032509-0013-0000-0000-000021D457F2
Message-Id: <20200325093507.20831-2-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_01:2020-03-23,2020-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 phishscore=0 impostorscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 mlxlogscore=999 lowpriorityscore=0 clxscore=1015 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003250077
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since RX buffers may contain multiple packets, qeth's NAPI poll code can
exhaust its budget in the middle of an RX buffer. Thus we keep track of
our current position within the active RX buffer, so we can resume
processing here in the next NAPI poll period.

Clean up that code by tracking the index of the active buffer element,
instead of a pointer to it.
Also simplify the code that advances to the next RX buffer when the
current buffer has been fully processed.

v2: - remove QDIO_ELEMENT_NO() macro (davem)

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  2 +-
 drivers/s390/net/qeth_core_main.c | 30 ++++++++++++------------------
 2 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 6eb431c194bd..9840d4fab010 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -752,7 +752,7 @@ enum qeth_addr_disposition {
 struct qeth_rx {
 	int b_count;
 	int b_index;
-	struct qdio_buffer_element *b_element;
+	u8 buf_element;
 	int e_offset;
 	int qdio_err;
 };
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index bd3adbb6ad50..4f33e4ee49d7 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -5332,14 +5332,13 @@ static inline int qeth_is_last_sbale(struct qdio_buffer_element *sbale)
 }
 
 static int qeth_extract_skb(struct qeth_card *card,
-			    struct qeth_qdio_buffer *qethbuffer,
-			    struct qdio_buffer_element **__element,
+			    struct qeth_qdio_buffer *qethbuffer, u8 *element_no,
 			    int *__offset)
 {
-	struct qdio_buffer_element *element = *__element;
 	struct qeth_priv *priv = netdev_priv(card->dev);
 	struct qdio_buffer *buffer = qethbuffer->buffer;
 	struct napi_struct *napi = &card->napi;
+	struct qdio_buffer_element *element;
 	unsigned int linear_len = 0;
 	bool uses_frags = false;
 	int offset = *__offset;
@@ -5349,6 +5348,8 @@ static int qeth_extract_skb(struct qeth_card *card,
 	struct sk_buff *skb;
 	int skb_len = 0;
 
+	element = &buffer->element[*element_no];
+
 next_packet:
 	/* qeth_hdr must not cross element boundaries */
 	while (element->length < offset + sizeof(struct qeth_hdr)) {
@@ -5504,7 +5505,7 @@ static int qeth_extract_skb(struct qeth_card *card,
 	if (!skb)
 		goto next_packet;
 
-	*__element = element;
+	*element_no = element - &buffer->element[0];
 	*__offset = offset;
 
 	qeth_receive_skb(card, skb, hdr, uses_frags);
@@ -5519,7 +5520,7 @@ static int qeth_extract_skbs(struct qeth_card *card, int budget,
 	*done = false;
 
 	while (budget) {
-		if (qeth_extract_skb(card, buf, &card->rx.b_element,
+		if (qeth_extract_skb(card, buf, &card->rx.buf_element,
 				     &card->rx.e_offset)) {
 			*done = true;
 			break;
@@ -5550,10 +5551,6 @@ int qeth_poll(struct napi_struct *napi, int budget)
 				card->rx.b_count = 0;
 				break;
 			}
-			card->rx.b_element =
-				&card->qdio.in_q->bufs[card->rx.b_index]
-				.buffer->element[0];
-			card->rx.e_offset = 0;
 		}
 
 		while (card->rx.b_count) {
@@ -5572,15 +5569,12 @@ int qeth_poll(struct napi_struct *napi, int budget)
 					buffer->pool_entry);
 				qeth_queue_input_buffer(card, card->rx.b_index);
 				card->rx.b_count--;
-				if (card->rx.b_count) {
-					card->rx.b_index =
-						QDIO_BUFNR(card->rx.b_index + 1);
-					card->rx.b_element =
-						&card->qdio.in_q
-						->bufs[card->rx.b_index]
-						.buffer->element[0];
-					card->rx.e_offset = 0;
-				}
+
+				/* Step forward to next buffer: */
+				card->rx.b_index =
+					QDIO_BUFNR(card->rx.b_index + 1);
+				card->rx.buf_element = 0;
+				card->rx.e_offset = 0;
 			}
 
 			if (work_done >= budget)
-- 
2.17.1

