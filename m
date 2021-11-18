Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D200456020
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 17:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbhKRQJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 11:09:32 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48784 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231167AbhKRQJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 11:09:32 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AIFISdL021854;
        Thu, 18 Nov 2021 16:06:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=TeRxrNlTLK+053cH+MELusZWHpBBsT1+a6VSJ3g1Sis=;
 b=dtHd8Kav4MugESF2ZY56ymGlwLUzCT3A4v4JH/MnvTf8G1ztcz61LSR73hdV+sxSk9Qj
 jDRMzcRNxmqmplPYiQcVDOyNqWUpDwmaKiWcS4QMXAlgUBdPXrHAoGO324LxGaQo4WA/
 NoViVExTxnfKxuslkMbNhOnlm68cQseXy77k5P3H+a65JPATamkbW3hQ/tE+jQZeKm/5
 2+bRG2YtgAGQGRC/DCwptEQDGawahz3ktcFhMoO34hzmLW4clArc8G+8hTDs/iykM8zo
 aIsPFfGOykOq3LiqUvwp2HS+gvA80Nciv3Tgdmkt00cocf5aR3a0CC2T/D02SwhznBXQ hQ== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cdrwft663-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 16:06:30 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AIG2rBB020672;
        Thu, 18 Nov 2021 16:06:28 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3ca50anu56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 16:06:27 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AIG6OjO47710506
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Nov 2021 16:06:24 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 57FE5AE05F;
        Thu, 18 Nov 2021 16:06:24 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C07CAE076;
        Thu, 18 Nov 2021 16:06:24 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Nov 2021 16:06:24 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 1/6] s390/qeth: allocate RX queue at probe time
Date:   Thu, 18 Nov 2021 17:06:02 +0100
Message-Id: <20211118160607.2245947-2-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211118160607.2245947-1-kgraul@linux.ibm.com>
References: <20211118160607.2245947-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XWDf0E761nj_daFKGKaD7oQPMD_mbPNn
X-Proofpoint-ORIG-GUID: XWDf0E761nj_daFKGKaD7oQPMD_mbPNn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-18_12,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 mlxlogscore=999 impostorscore=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111180089
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

We always need an RX queue, and there's no reconfig situation either
where we would need to free & rebuild the queue.

So allocate the RX queue right from the start, and avoid freeing it
during unrelated qeth_free_qdio_queues() calls.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 35 +++++++++++++++----------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 26c55f67289f..d32aa8b705db 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -194,9 +194,6 @@ static void qeth_clear_working_pool_list(struct qeth_card *card)
 				 &card->qdio.in_buf_pool.entry_list, list)
 		list_del(&pool_entry->list);
 
-	if (!queue)
-		return;
-
 	for (i = 0; i < ARRAY_SIZE(queue->bufs); i++)
 		queue->bufs[i].pool_entry = NULL;
 }
@@ -275,8 +272,8 @@ int qeth_resize_buffer_pool(struct qeth_card *card, unsigned int count)
 
 	QETH_CARD_TEXT(card, 2, "realcbp");
 
-	/* Defer until queue is allocated: */
-	if (!card->qdio.in_q)
+	/* Defer until pool is allocated: */
+	if (list_empty(&pool->entry_list))
 		goto out;
 
 	/* Remove entries from the pool: */
@@ -2557,14 +2554,9 @@ static int qeth_alloc_qdio_queues(struct qeth_card *card)
 		QETH_QDIO_ALLOCATED) != QETH_QDIO_UNINITIALIZED)
 		return 0;
 
-	QETH_CARD_TEXT(card, 2, "inq");
-	card->qdio.in_q = qeth_alloc_qdio_queue();
-	if (!card->qdio.in_q)
-		goto out_nomem;
-
 	/* inbound buffer pool */
 	if (qeth_alloc_buffer_pool(card))
-		goto out_freeinq;
+		goto out_buffer_pool;
 
 	/* outbound */
 	for (i = 0; i < card->qdio.no_out_queues; ++i) {
@@ -2605,10 +2597,7 @@ static int qeth_alloc_qdio_queues(struct qeth_card *card)
 		card->qdio.out_qs[i] = NULL;
 	}
 	qeth_free_buffer_pool(card);
-out_freeinq:
-	qeth_free_qdio_queue(card->qdio.in_q);
-	card->qdio.in_q = NULL;
-out_nomem:
+out_buffer_pool:
 	atomic_set(&card->qdio.state, QETH_QDIO_UNINITIALIZED);
 	return -ENOMEM;
 }
@@ -2623,11 +2612,12 @@ static void qeth_free_qdio_queues(struct qeth_card *card)
 
 	qeth_free_cq(card);
 	for (j = 0; j < QDIO_MAX_BUFFERS_PER_Q; ++j) {
-		if (card->qdio.in_q->bufs[j].rx_skb)
+		if (card->qdio.in_q->bufs[j].rx_skb) {
 			consume_skb(card->qdio.in_q->bufs[j].rx_skb);
+			card->qdio.in_q->bufs[j].rx_skb = NULL;
+		}
 	}
-	qeth_free_qdio_queue(card->qdio.in_q);
-	card->qdio.in_q = NULL;
+
 	/* inbound buffer pool */
 	qeth_free_buffer_pool(card);
 	/* free outbound qdio_qs */
@@ -6447,6 +6437,12 @@ static int qeth_core_probe_device(struct ccwgroup_device *gdev)
 	qeth_determine_capabilities(card);
 	qeth_set_blkt_defaults(card);
 
+	card->qdio.in_q = qeth_alloc_qdio_queue();
+	if (!card->qdio.in_q) {
+		rc = -ENOMEM;
+		goto err_rx_queue;
+	}
+
 	card->qdio.no_out_queues = card->dev->num_tx_queues;
 	rc = qeth_update_from_chp_desc(card);
 	if (rc)
@@ -6473,6 +6469,8 @@ static int qeth_core_probe_device(struct ccwgroup_device *gdev)
 
 err_setup_disc:
 err_chp_desc:
+	qeth_free_qdio_queue(card->qdio.in_q);
+err_rx_queue:
 	free_netdev(card->dev);
 err_card:
 	qeth_core_free_card(card);
@@ -6494,6 +6492,7 @@ static void qeth_core_remove_device(struct ccwgroup_device *gdev)
 
 	qeth_free_qdio_queues(card);
 
+	qeth_free_qdio_queue(card->qdio.in_q);
 	free_netdev(card->dev);
 	qeth_core_free_card(card);
 	put_device(&gdev->dev);
-- 
2.25.1

