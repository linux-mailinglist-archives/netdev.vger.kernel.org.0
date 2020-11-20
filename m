Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4FB2BA58D
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 10:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727391AbgKTJJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 04:09:57 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38862 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727082AbgKTJJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 04:09:52 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AK94TRt191851;
        Fri, 20 Nov 2020 04:09:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=oqxKmJ43XzowYttbLwjY+vmCKJjalZ49aCQBywYwcoM=;
 b=BuXit3FtIjrtC8bTEGm9Rm0LmaGV7KiLkjybZ5YJ0E2SR9NC44k0Ci72PJNy8/Z/um6H
 8qOM8VF83H5G/5gb1yXVyjrs9FwmnkTGyGsCBVjPIEw44G/8Njoq/DWmh+/0IR88OHeM
 gqYto+uxnIKkIS0ujixxjvX8NLE4TCB/0niNxNqUv6RNr3i7dXAJTUmYF7f94kJZbjhy
 bGYwXFmu6nuJxOCrMWwCFbcrAUKimDCRNuMkmvF50Oj+2CI/sL95tCYCEecTybUy8kJ0
 nkQzl9OLyV7WUM6ztioBvRERVxl/yfEUHe1oyYwDXwWxXPsxRFxe13Laqy+XlzM8Pr4W vQ== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34x1m0wg8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Nov 2020 04:09:47 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AK97wai020916;
        Fri, 20 Nov 2020 09:09:44 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 34weby1ggm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Nov 2020 09:09:44 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AK99fYr64881132
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 09:09:41 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 548C64203F;
        Fri, 20 Nov 2020 09:09:41 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F3AB42041;
        Fri, 20 Nov 2020 09:09:41 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 20 Nov 2020 09:09:40 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 3/4] s390/qeth: fix af_iucv notification race
Date:   Fri, 20 Nov 2020 10:09:38 +0100
Message-Id: <20201120090939.101406-4-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201120090939.101406-1-jwi@linux.ibm.com>
References: <20201120090939.101406-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_03:2020-11-19,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 suspectscore=2 mlxlogscore=999 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200056
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The two expected notification sequences are
1. TX_NOTIFY_PENDING with a subsequent TX_NOTIFY_DELAYED_*, when
   our TX completion code first observed the pending TX and the QAOB
   then completes at a later time; or
2. TX_NOTIFY_OK, when qeth_qdio_handle_aob() picked up the QAOB
   completion before our TX completion code even noticed that the TX
   was pending.

But as qeth_iqd_tx_complete() and qeth_qdio_handle_aob() can run
concurrently, we may end up with a race that results in a sequence of
TX_NOTIFY_DELAYED_* followed by TX_NOTIFY_PENDING. Which would confuse
the af_iucv code in its tracking of pending transmits.

Rework the notification code, so that qeth_qdio_handle_aob() defers its
notification if the TX completion code is still active.

Fixes: b333293058aa ("qeth: add support for af_iucv HiperSockets transport")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  9 ++--
 drivers/s390/net/qeth_core_main.c | 73 ++++++++++++++++++++++---------
 2 files changed, 58 insertions(+), 24 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index f73b4756ed5e..b235393e091c 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -417,10 +417,13 @@ enum qeth_qdio_out_buffer_state {
 	QETH_QDIO_BUF_EMPTY,
 	/* Filled by driver; owned by hardware in order to be sent. */
 	QETH_QDIO_BUF_PRIMED,
-	/* Identified to be pending in TPQ. */
+	/* Discovered by the TX completion code: */
 	QETH_QDIO_BUF_PENDING,
-	/* Found in completion queue. */
-	QETH_QDIO_BUF_IN_CQ,
+	/* Finished by the TX completion code: */
+	QETH_QDIO_BUF_NEED_QAOB,
+	/* Received QAOB notification on CQ: */
+	QETH_QDIO_BUF_QAOB_OK,
+	QETH_QDIO_BUF_QAOB_ERROR,
 	/* Handled via transfer pending / completion queue. */
 	QETH_QDIO_BUF_HANDLED_DELAYED,
 };
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 715f440bdc7c..48f9e4a027bf 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -511,6 +511,7 @@ static void qeth_cleanup_handled_pending(struct qeth_qdio_out_q *q, int bidx,
 static void qeth_qdio_handle_aob(struct qeth_card *card,
 				 unsigned long phys_aob_addr)
 {
+	enum qeth_qdio_out_buffer_state new_state = QETH_QDIO_BUF_QAOB_OK;
 	struct qaob *aob;
 	struct qeth_qdio_out_buffer *buffer;
 	enum iucv_tx_notify notification;
@@ -522,22 +523,6 @@ static void qeth_qdio_handle_aob(struct qeth_card *card,
 	buffer = (struct qeth_qdio_out_buffer *) aob->user1;
 	QETH_CARD_TEXT_(card, 5, "%lx", aob->user1);
 
-	if (atomic_cmpxchg(&buffer->state, QETH_QDIO_BUF_PRIMED,
-			   QETH_QDIO_BUF_IN_CQ) == QETH_QDIO_BUF_PRIMED) {
-		notification = TX_NOTIFY_OK;
-	} else {
-		WARN_ON_ONCE(atomic_read(&buffer->state) !=
-							QETH_QDIO_BUF_PENDING);
-		atomic_set(&buffer->state, QETH_QDIO_BUF_IN_CQ);
-		notification = TX_NOTIFY_DELAYED_OK;
-	}
-
-	if (aob->aorc != 0)  {
-		QETH_CARD_TEXT_(card, 2, "aorc%02X", aob->aorc);
-		notification = qeth_compute_cq_notification(aob->aorc, 1);
-	}
-	qeth_notify_skbs(buffer->q, buffer, notification);
-
 	/* Free dangling allocations. The attached skbs are handled by
 	 * qeth_cleanup_handled_pending().
 	 */
@@ -549,7 +534,33 @@ static void qeth_qdio_handle_aob(struct qeth_card *card,
 		if (data && buffer->is_header[i])
 			kmem_cache_free(qeth_core_header_cache, data);
 	}
-	atomic_set(&buffer->state, QETH_QDIO_BUF_HANDLED_DELAYED);
+
+	if (aob->aorc) {
+		QETH_CARD_TEXT_(card, 2, "aorc%02X", aob->aorc);
+		new_state = QETH_QDIO_BUF_QAOB_ERROR;
+	}
+
+	switch (atomic_xchg(&buffer->state, new_state)) {
+	case QETH_QDIO_BUF_PRIMED:
+		/* Faster than TX completion code. */
+		notification = qeth_compute_cq_notification(aob->aorc, 0);
+		qeth_notify_skbs(buffer->q, buffer, notification);
+		atomic_set(&buffer->state, QETH_QDIO_BUF_HANDLED_DELAYED);
+		break;
+	case QETH_QDIO_BUF_PENDING:
+		/* TX completion code is active and will handle the async
+		 * completion for us.
+		 */
+		break;
+	case QETH_QDIO_BUF_NEED_QAOB:
+		/* TX completion code is already finished. */
+		notification = qeth_compute_cq_notification(aob->aorc, 1);
+		qeth_notify_skbs(buffer->q, buffer, notification);
+		atomic_set(&buffer->state, QETH_QDIO_BUF_HANDLED_DELAYED);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+	}
 
 	qdio_release_aob(aob);
 }
@@ -1417,9 +1428,6 @@ static void qeth_tx_complete_buf(struct qeth_qdio_out_buffer *buf, bool error,
 	struct qeth_qdio_out_q *queue = buf->q;
 	struct sk_buff *skb;
 
-	/* release may never happen from within CQ tasklet scope */
-	WARN_ON_ONCE(atomic_read(&buf->state) == QETH_QDIO_BUF_IN_CQ);
-
 	if (atomic_read(&buf->state) == QETH_QDIO_BUF_PENDING)
 		qeth_notify_skbs(queue, buf, TX_NOTIFY_GENERALERROR);
 
@@ -5870,9 +5878,32 @@ static void qeth_iqd_tx_complete(struct qeth_qdio_out_q *queue,
 
 		if (atomic_cmpxchg(&buffer->state, QETH_QDIO_BUF_PRIMED,
 						   QETH_QDIO_BUF_PENDING) ==
-		    QETH_QDIO_BUF_PRIMED)
+		    QETH_QDIO_BUF_PRIMED) {
 			qeth_notify_skbs(queue, buffer, TX_NOTIFY_PENDING);
 
+			/* Handle race with qeth_qdio_handle_aob(): */
+			switch (atomic_xchg(&buffer->state,
+					    QETH_QDIO_BUF_NEED_QAOB)) {
+			case QETH_QDIO_BUF_PENDING:
+				/* No concurrent QAOB notification. */
+				break;
+			case QETH_QDIO_BUF_QAOB_OK:
+				qeth_notify_skbs(queue, buffer,
+						 TX_NOTIFY_DELAYED_OK);
+				atomic_set(&buffer->state,
+					   QETH_QDIO_BUF_HANDLED_DELAYED);
+				break;
+			case QETH_QDIO_BUF_QAOB_ERROR:
+				qeth_notify_skbs(queue, buffer,
+						 TX_NOTIFY_DELAYED_GENERALERROR);
+				atomic_set(&buffer->state,
+					   QETH_QDIO_BUF_HANDLED_DELAYED);
+				break;
+			default:
+				WARN_ON_ONCE(1);
+			}
+		}
+
 		QETH_CARD_TEXT_(card, 5, "pel%u", bidx);
 
 		/* prepare the queue slot for re-use: */
-- 
2.17.1

