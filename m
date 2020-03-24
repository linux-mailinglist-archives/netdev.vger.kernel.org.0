Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C957B191905
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 19:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbgCXSZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 14:25:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4508 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727715AbgCXSZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 14:25:03 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02OI423e114713
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 14:25:01 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ywewudvc3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 14:25:01 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Tue, 24 Mar 2020 18:24:57 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 24 Mar 2020 18:24:54 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02OIOtr128967046
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 18:24:55 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BCD2A4068;
        Tue, 24 Mar 2020 18:24:55 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E7E9A4054;
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
Subject: [PATCH net-next 02/11] s390/qeth: split out RX poll code
Date:   Tue, 24 Mar 2020 19:24:39 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200324182448.95362-1-jwi@linux.ibm.com>
References: <20200324182448.95362-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20032418-0016-0000-0000-000002F7054B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032418-0017-0000-0000-0000335AA4A2
Message-Id: <20200324182448.95362-3-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-24_05:2020-03-23,2020-03-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 spamscore=0 clxscore=1015 malwarescore=0 impostorscore=0
 bulkscore=0 phishscore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240090
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The main NAPI poll routine should eventually handle more types of work,
beyond just the RX ring.
Split off the RX poll logic into a separate function, and simplify the
nested while-loop.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 54 +++++++++++++++++++------------
 1 file changed, 33 insertions(+), 21 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index b25d44c83997..f818d9db32ac 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -5512,12 +5512,10 @@ static int qeth_extract_skb(struct qeth_card *card,
 	return 0;
 }
 
-static int qeth_extract_skbs(struct qeth_card *card, int budget,
-			     struct qeth_qdio_buffer *buf, bool *done)
+static unsigned int qeth_extract_skbs(struct qeth_card *card, int budget,
+				      struct qeth_qdio_buffer *buf, bool *done)
 {
-	int work_done = 0;
-
-	*done = false;
+	unsigned int work_done = 0;
 
 	while (budget) {
 		if (qeth_extract_skb(card, buf, &card->rx.buf_element,
@@ -5533,15 +5531,12 @@ static int qeth_extract_skbs(struct qeth_card *card, int budget,
 	return work_done;
 }
 
-int qeth_poll(struct napi_struct *napi, int budget)
+static unsigned int qeth_rx_poll(struct qeth_card *card, int budget)
 {
-	struct qeth_card *card = container_of(napi, struct qeth_card, napi);
-	int work_done = 0;
-	struct qeth_qdio_buffer *buffer;
-	int new_budget = budget;
-	bool done;
+	unsigned int work_done = 0;
 
-	while (1) {
+	while (budget > 0) {
+		/* Fetch completed RX buffers: */
 		if (!card->rx.b_count) {
 			card->rx.qdio_err = 0;
 			card->rx.b_count = qdio_get_next_buffers(
@@ -5553,16 +5548,24 @@ int qeth_poll(struct napi_struct *napi, int budget)
 			}
 		}
 
-		while (card->rx.b_count) {
+		/* Process one completed RX buffer: */
+		if (card->rx.b_count) {
+			struct qeth_qdio_buffer *buffer;
+			unsigned int skbs_done = 0;
+			bool done = false;
+
 			buffer = &card->qdio.in_q->bufs[card->rx.b_index];
 			if (!(card->rx.qdio_err &&
 			    qeth_check_qdio_errors(card, buffer->buffer,
 			    card->rx.qdio_err, "qinerr")))
-				work_done += qeth_extract_skbs(card, new_budget,
-							       buffer, &done);
+				skbs_done = qeth_extract_skbs(card, budget,
+							      buffer, &done);
 			else
 				done = true;
 
+			work_done += skbs_done;
+			budget -= skbs_done;
+
 			if (done) {
 				QETH_CARD_STAT_INC(card, rx_bufs);
 				qeth_put_buffer_pool_entry(card,
@@ -5576,18 +5579,27 @@ int qeth_poll(struct napi_struct *napi, int budget)
 				card->rx.buf_element = 0;
 				card->rx.e_offset = 0;
 			}
-
-			if (work_done >= budget)
-				goto out;
-			else
-				new_budget = budget - work_done;
 		}
 	}
 
+	return work_done;
+}
+
+int qeth_poll(struct napi_struct *napi, int budget)
+{
+	struct qeth_card *card = container_of(napi, struct qeth_card, napi);
+	unsigned int work_done;
+
+	work_done = qeth_rx_poll(card, budget);
+
+	/* Exhausted the RX budget. Keep IRQ disabled, we get called again. */
+	if (budget && work_done >= budget)
+		return work_done;
+
 	if (napi_complete_done(napi, work_done) &&
 	    qdio_start_irq(CARD_DDEV(card), 0))
 		napi_schedule(napi);
-out:
+
 	return work_done;
 }
 EXPORT_SYMBOL_GPL(qeth_poll);
-- 
2.17.1

