Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1FC21918F5
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 19:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgCXSZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 14:25:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40306 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727830AbgCXSZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 14:25:03 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02OI5OT2012051
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 14:25:02 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ywf0pavkf-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 14:25:02 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Tue, 24 Mar 2020 18:24:58 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 24 Mar 2020 18:24:55 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02OIOtCA50593798
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 18:24:55 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 984AFA406D;
        Tue, 24 Mar 2020 18:24:55 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6131DA4065;
        Tue, 24 Mar 2020 18:24:55 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 Mar 2020 18:24:55 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 03/11] s390/qeth: remove redundant if-clause in RX poll code
Date:   Tue, 24 Mar 2020 19:24:40 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200324182448.95362-1-jwi@linux.ibm.com>
References: <20200324182448.95362-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20032418-0008-0000-0000-000003632A3E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032418-0009-0000-0000-00004A849777
Message-Id: <20200324182448.95362-4-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-24_05:2020-03-23,2020-03-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 impostorscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 clxscore=1015 lowpriorityscore=0 adultscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240090
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whenever all completed RX buffers have been processed
(ie. rx->b_count == 0), we call down to the HW layer to scan for
additional buffers. If no further buffers are available, the code
breaks out of the while-loop.

So we never reach the 'process an RX buffer' step with rx->b_count == 0,
eliminate that check and one level of indentation.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 56 ++++++++++++++-----------------
 1 file changed, 26 insertions(+), 30 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index f818d9db32ac..dd9bee620f46 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -5536,6 +5536,10 @@ static unsigned int qeth_rx_poll(struct qeth_card *card, int budget)
 	unsigned int work_done = 0;
 
 	while (budget > 0) {
+		struct qeth_qdio_buffer *buffer;
+		unsigned int skbs_done = 0;
+		bool done = false;
+
 		/* Fetch completed RX buffers: */
 		if (!card->rx.b_count) {
 			card->rx.qdio_err = 0;
@@ -5549,36 +5553,28 @@ static unsigned int qeth_rx_poll(struct qeth_card *card, int budget)
 		}
 
 		/* Process one completed RX buffer: */
-		if (card->rx.b_count) {
-			struct qeth_qdio_buffer *buffer;
-			unsigned int skbs_done = 0;
-			bool done = false;
-
-			buffer = &card->qdio.in_q->bufs[card->rx.b_index];
-			if (!(card->rx.qdio_err &&
-			    qeth_check_qdio_errors(card, buffer->buffer,
-			    card->rx.qdio_err, "qinerr")))
-				skbs_done = qeth_extract_skbs(card, budget,
-							      buffer, &done);
-			else
-				done = true;
-
-			work_done += skbs_done;
-			budget -= skbs_done;
-
-			if (done) {
-				QETH_CARD_STAT_INC(card, rx_bufs);
-				qeth_put_buffer_pool_entry(card,
-					buffer->pool_entry);
-				qeth_queue_input_buffer(card, card->rx.b_index);
-				card->rx.b_count--;
-
-				/* Step forward to next buffer: */
-				card->rx.b_index =
-					QDIO_BUFNR(card->rx.b_index + 1);
-				card->rx.buf_element = 0;
-				card->rx.e_offset = 0;
-			}
+		buffer = &card->qdio.in_q->bufs[card->rx.b_index];
+		if (!(card->rx.qdio_err &&
+		      qeth_check_qdio_errors(card, buffer->buffer,
+					     card->rx.qdio_err, "qinerr")))
+			skbs_done = qeth_extract_skbs(card, budget, buffer,
+						      &done);
+		else
+			done = true;
+
+		work_done += skbs_done;
+		budget -= skbs_done;
+
+		if (done) {
+			QETH_CARD_STAT_INC(card, rx_bufs);
+			qeth_put_buffer_pool_entry(card, buffer->pool_entry);
+			qeth_queue_input_buffer(card, card->rx.b_index);
+			card->rx.b_count--;
+
+			/* Step forward to next buffer: */
+			card->rx.b_index = QDIO_BUFNR(card->rx.b_index + 1);
+			card->rx.buf_element = 0;
+			card->rx.e_offset = 0;
 		}
 	}
 
-- 
2.17.1

