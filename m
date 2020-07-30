Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 498742334ED
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 17:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729651AbgG3PDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 11:03:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55848 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726275AbgG3PDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 11:03:14 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06UF30KC154250;
        Thu, 30 Jul 2020 11:03:11 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32ks38pwqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jul 2020 11:03:08 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06UEotlZ025151;
        Thu, 30 Jul 2020 15:01:26 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 32gcq0uve9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jul 2020 15:01:26 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06UF1NTL49479716
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jul 2020 15:01:23 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94998A4059;
        Thu, 30 Jul 2020 15:01:23 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54D22A4040;
        Thu, 30 Jul 2020 15:01:23 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 30 Jul 2020 15:01:23 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 4/4] s390/qeth: use all configured RX buffers
Date:   Thu, 30 Jul 2020 17:01:21 +0200
Message-Id: <20200730150121.18005-5-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200730150121.18005-1-jwi@linux.ibm.com>
References: <20200730150121.18005-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-30_11:2020-07-30,2020-07-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 clxscore=1015
 impostorscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007300107
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The (misplaced) comment doesn't make any sense, enforcing an
uninitialized RX buffer won't help with IRQ reduction.

So make the best use of all available RX buffers.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index c2e44853ac1a..bba1b54b8aa3 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -3022,6 +3022,7 @@ static unsigned int qeth_tx_select_bulk_max(struct qeth_card *card,
 
 static int qeth_init_qdio_queues(struct qeth_card *card)
 {
+	unsigned int rx_bufs = card->qdio.in_buf_pool.buf_count;
 	unsigned int i;
 	int rc;
 
@@ -3033,16 +3034,14 @@ static int qeth_init_qdio_queues(struct qeth_card *card)
 
 	qeth_initialize_working_pool_list(card);
 	/*give only as many buffers to hardware as we have buffer pool entries*/
-	for (i = 0; i < card->qdio.in_buf_pool.buf_count - 1; i++) {
+	for (i = 0; i < rx_bufs; i++) {
 		rc = qeth_init_input_buffer(card, &card->qdio.in_q->bufs[i]);
 		if (rc)
 			return rc;
 	}
 
-	card->qdio.in_q->next_buf_to_init =
-		card->qdio.in_buf_pool.buf_count - 1;
-	rc = do_QDIO(CARD_DDEV(card), QDIO_FLAG_SYNC_INPUT, 0, 0,
-		     card->qdio.in_buf_pool.buf_count - 1);
+	card->qdio.in_q->next_buf_to_init = QDIO_BUFNR(rx_bufs);
+	rc = do_QDIO(CARD_DDEV(card), QDIO_FLAG_SYNC_INPUT, 0, 0, rx_bufs);
 	if (rc) {
 		QETH_CARD_TEXT_(card, 2, "1err%d", rc);
 		return rc;
@@ -3535,13 +3534,6 @@ static unsigned int qeth_rx_refill_queue(struct qeth_card *card,
 			return 0;
 		}
 
-		/*
-		 * according to old code it should be avoided to requeue all
-		 * 128 buffers in order to benefit from PCI avoidance.
-		 * this function keeps at least one buffer (the buffer at
-		 * 'index') un-requeued -> this buffer is the first buffer that
-		 * will be requeued the next time
-		 */
 		rc = do_QDIO(CARD_DDEV(card), QDIO_FLAG_SYNC_INPUT, 0,
 			     queue->next_buf_to_init, count);
 		if (rc) {
-- 
2.17.1

