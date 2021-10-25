Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECA8B43932F
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 11:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbhJYKAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 06:00:09 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10316 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232726AbhJYJ7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 05:59:36 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19P9hicm003337;
        Mon, 25 Oct 2021 09:57:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ebCOfgaHnf78YOHQooTKubjrsc8El8kWI7xLBVzzfNo=;
 b=ARE6a2hoM93ySahcRExn3Y4pMIhWMzToHcMrfhfC+AO/VHDmrRVnZ1acy1QYyLj4d2U4
 fpYH+8fmbajtVi6yJgn8cZuhSOJb+vVXQ1Y7ic2HaZumhMy5Hi6ZYKlLxjE+oEei+9z4
 EOOFCEqEh3bXX40TapWKde/fAoON06Wq2undNsCAM4x1FacCJRHedXlBJm5vwrEY7wVF
 DRuHLP34oPxsiQZZuWa47Qi7kdRLnUi+yC42CSv6PwlbTMqEpkFCquAEwSLfDksZwqEM
 x6nV9OWpMlJYpakWTRosECt8OmwIeMRpWcNtW+YDdaq8KWPUEo/vcPHYNS9TplJhxnOW lA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bwt6s88qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 09:57:10 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19P9h06G017175;
        Mon, 25 Oct 2021 09:57:09 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3bwqst9pyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 09:57:09 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19P9v5rs48169320
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Oct 2021 09:57:06 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF1B411C05E;
        Mon, 25 Oct 2021 09:57:05 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9CDD511C05C;
        Mon, 25 Oct 2021 09:57:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 25 Oct 2021 09:57:05 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 5/9] s390/qeth: don't keep track of Input Queue count
Date:   Mon, 25 Oct 2021 11:56:54 +0200
Message-Id: <20211025095658.3527635-6-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211025095658.3527635-1-jwi@linux.ibm.com>
References: <20211025095658.3527635-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Tw5otn5hZMdCVbCFDH2E-Xnm-utRIUOt
X-Proofpoint-ORIG-GUID: Tw5otn5hZMdCVbCFDH2E-Xnm-utRIUOt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_03,2021-10-25_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 impostorscore=0 adultscore=0 bulkscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110250058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only actual user of qdio.no_input_queues is qeth_qdio_establish(),
and there we already have full awareness of the current Input Queue
configuration (1 RX queue, plus potentially 1 TX Completion queue).

So avoid this state tracking, and the ambiguity it brings with it.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  1 -
 drivers/s390/net/qeth_core_main.c | 17 +++++++----------
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 0dc62b288480..09e1d2da3e48 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -545,7 +545,6 @@ static inline bool qeth_out_queue_is_empty(struct qeth_qdio_out_q *queue)
 struct qeth_qdio_info {
 	atomic_t state;
 	/* input */
-	int no_in_queues;
 	struct qeth_qdio_q *in_q;
 	struct qeth_qdio_q *c_q;
 	struct qeth_qdio_buffer_pool in_buf_pool;
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index d6230e4e8b1c..df0b96a3943c 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -355,8 +355,8 @@ static int qeth_cq_init(struct qeth_card *card)
 		qdio_reset_buffers(card->qdio.c_q->qdio_bufs,
 				   QDIO_MAX_BUFFERS_PER_Q);
 		card->qdio.c_q->next_buf_to_init = 127;
-		rc = do_QDIO(CARD_DDEV(card), QDIO_FLAG_SYNC_INPUT,
-			     card->qdio.no_in_queues - 1, 0, 127, NULL);
+		rc = do_QDIO(CARD_DDEV(card), QDIO_FLAG_SYNC_INPUT, 1, 0, 127,
+			     NULL);
 		if (rc) {
 			QETH_CARD_TEXT_(card, 2, "1err%d", rc);
 			goto out;
@@ -376,21 +376,16 @@ static int qeth_alloc_cq(struct qeth_card *card)
 			dev_err(&card->gdev->dev, "Failed to create completion queue\n");
 			return -ENOMEM;
 		}
-
-		card->qdio.no_in_queues = 2;
 	} else {
 		QETH_CARD_TEXT(card, 2, "nocq");
 		card->qdio.c_q = NULL;
-		card->qdio.no_in_queues = 1;
 	}
-	QETH_CARD_TEXT_(card, 2, "iqc%d", card->qdio.no_in_queues);
 	return 0;
 }
 
 static void qeth_free_cq(struct qeth_card *card)
 {
 	if (card->qdio.c_q) {
-		--card->qdio.no_in_queues;
 		qeth_free_qdio_queue(card->qdio.c_q);
 		card->qdio.c_q = NULL;
 	}
@@ -1459,7 +1454,6 @@ static void qeth_init_qdio_info(struct qeth_card *card)
 	card->qdio.default_out_queue = QETH_DEFAULT_QUEUE;
 
 	/* inbound */
-	card->qdio.no_in_queues = 1;
 	card->qdio.in_buf_size = QETH_IN_BUF_SIZE_DEFAULT;
 	if (IS_IQD(card))
 		card->qdio.init_pool.buf_count = QETH_IN_BUF_COUNT_HSDEFAULT;
@@ -5141,6 +5135,7 @@ static int qeth_qdio_establish(struct qeth_card *card)
 	struct qdio_buffer **in_sbal_ptrs[QETH_MAX_IN_QUEUES];
 	struct qeth_qib_parms *qib_parms = NULL;
 	struct qdio_initialize init_data;
+	unsigned int no_input_qs = 1;
 	unsigned int i;
 	int rc = 0;
 
@@ -5155,8 +5150,10 @@ static int qeth_qdio_establish(struct qeth_card *card)
 	}
 
 	in_sbal_ptrs[0] = card->qdio.in_q->qdio_bufs;
-	if (card->options.cq == QETH_CQ_ENABLED)
+	if (card->options.cq == QETH_CQ_ENABLED) {
 		in_sbal_ptrs[1] = card->qdio.c_q->qdio_bufs;
+		no_input_qs++;
+	}
 
 	for (i = 0; i < card->qdio.no_out_queues; i++)
 		out_sbal_ptrs[i] = card->qdio.out_qs[i]->qdio_bufs;
@@ -5166,7 +5163,7 @@ static int qeth_qdio_establish(struct qeth_card *card)
 							  QDIO_QETH_QFMT;
 	init_data.qib_param_field_format = 0;
 	init_data.qib_param_field	 = (void *)qib_parms;
-	init_data.no_input_qs            = card->qdio.no_in_queues;
+	init_data.no_input_qs		 = no_input_qs;
 	init_data.no_output_qs           = card->qdio.no_out_queues;
 	init_data.input_handler		 = qeth_qdio_input_handler;
 	init_data.output_handler	 = qeth_qdio_output_handler;
-- 
2.25.1

