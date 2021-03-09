Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC5EC332C97
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 17:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbhCIQw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 11:52:56 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62412 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230075AbhCIQwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 11:52:32 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 129GYCuU032901;
        Tue, 9 Mar 2021 11:52:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=GUSxTKreouQhx4JKQpBuadvNZQL4cXPVhZlX26nUnnQ=;
 b=V6Xa5imSGal48jlZw4JsnfG83nqNiPutnAjttaiPfrM8GtknTiMq6KOo1wXLbGCvk2PX
 4bXFRwL+5UHIz8yQnei7SI2HU4OF78ra5F3Kgvvh1n1Fj4LG/HMzSnFGZwkLnu19bSli
 d0xFOpB3LXtz09A3J31ZdA1+6ExeMNctQ9933O5pXDPi9FLm/5i661MiDctXyjaChcDA
 9ATnfqcn+NSDLJlQnTG5FnTCXyJBgfIJx8iwahT86wD44vfteC91hR2cCleVM6qHvKMF
 0rqBsC2348CAFqcHZZ09IsW3j8hwrW2V0d3kbuIJik426Fdyz+3wwukv+oNB+dhXJy8o Ag== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 376bkgasxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Mar 2021 11:52:29 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 129Gi1NG017124;
        Tue, 9 Mar 2021 16:52:27 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 376aqsr20n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Mar 2021 16:52:27 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 129Gq9RQ27066680
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Mar 2021 16:52:09 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DCE615204F;
        Tue,  9 Mar 2021 16:52:24 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9662852050;
        Tue,  9 Mar 2021 16:52:24 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 1/4] s390/qeth: fix memory leak after failed TX Buffer allocation
Date:   Tue,  9 Mar 2021 17:52:18 +0100
Message-Id: <20210309165221.1735641-2-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210309165221.1735641-1-jwi@linux.ibm.com>
References: <20210309165221.1735641-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-09_13:2021-03-08,2021-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 impostorscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 phishscore=0 adultscore=0 spamscore=0
 malwarescore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103090081
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When qeth_alloc_qdio_queues() fails to allocate one of the buffers that
back an Output Queue, the 'out_freeoutqbufs' path will free all
previously allocated buffers for this queue. But it misses to free the
half-finished queue struct itself.

Move the buffer allocation into qeth_alloc_output_queue(), and deal with
such errors internally.

Fixes: 0da9581ddb0f ("qeth: exploit asynchronous delivery of storage blocks")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 35 +++++++++++++++----------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index b71b8902d1c4..f7bc0ca6909b 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -2634,15 +2634,28 @@ static void qeth_free_output_queue(struct qeth_qdio_out_q *q)
 static struct qeth_qdio_out_q *qeth_alloc_output_queue(void)
 {
 	struct qeth_qdio_out_q *q = kzalloc(sizeof(*q), GFP_KERNEL);
+	unsigned int i;
 
 	if (!q)
 		return NULL;
 
-	if (qdio_alloc_buffers(q->qdio_bufs, QDIO_MAX_BUFFERS_PER_Q)) {
-		kfree(q);
-		return NULL;
+	if (qdio_alloc_buffers(q->qdio_bufs, QDIO_MAX_BUFFERS_PER_Q))
+		goto err_qdio_bufs;
+
+	for (i = 0; i < QDIO_MAX_BUFFERS_PER_Q; i++) {
+		if (qeth_init_qdio_out_buf(q, i))
+			goto err_out_bufs;
 	}
+
 	return q;
+
+err_out_bufs:
+	while (i > 0)
+		kmem_cache_free(qeth_qdio_outbuf_cache, q->bufs[--i]);
+	qdio_free_buffers(q->qdio_bufs, QDIO_MAX_BUFFERS_PER_Q);
+err_qdio_bufs:
+	kfree(q);
+	return NULL;
 }
 
 static void qeth_tx_completion_timer(struct timer_list *timer)
@@ -2655,7 +2668,7 @@ static void qeth_tx_completion_timer(struct timer_list *timer)
 
 static int qeth_alloc_qdio_queues(struct qeth_card *card)
 {
-	int i, j;
+	unsigned int i;
 
 	QETH_CARD_TEXT(card, 2, "allcqdbf");
 
@@ -2689,13 +2702,6 @@ static int qeth_alloc_qdio_queues(struct qeth_card *card)
 		queue->coalesce_usecs = QETH_TX_COALESCE_USECS;
 		queue->max_coalesced_frames = QETH_TX_MAX_COALESCED_FRAMES;
 		queue->priority = QETH_QIB_PQUE_PRIO_DEFAULT;
-
-		/* give outbound qeth_qdio_buffers their qdio_buffers */
-		for (j = 0; j < QDIO_MAX_BUFFERS_PER_Q; ++j) {
-			WARN_ON(queue->bufs[j]);
-			if (qeth_init_qdio_out_buf(queue, j))
-				goto out_freeoutqbufs;
-		}
 	}
 
 	/* completion */
@@ -2704,13 +2710,6 @@ static int qeth_alloc_qdio_queues(struct qeth_card *card)
 
 	return 0;
 
-out_freeoutqbufs:
-	while (j > 0) {
-		--j;
-		kmem_cache_free(qeth_qdio_outbuf_cache,
-				card->qdio.out_qs[i]->bufs[j]);
-		card->qdio.out_qs[i]->bufs[j] = NULL;
-	}
 out_freeoutq:
 	while (i > 0) {
 		qeth_free_output_queue(card->qdio.out_qs[--i]);
-- 
2.25.1

