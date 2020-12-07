Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620FE2D1192
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 14:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgLGNOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 08:14:39 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37452 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726141AbgLGNOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 08:14:39 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B7D3M0x011512;
        Mon, 7 Dec 2020 08:13:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=UVoX72jbokTVpxmnax07LxSj94O73pEmnMgLG5yTP8c=;
 b=tGNg4rLIdLfZOiWPXivMe9HN5OX3oG2BFmfW8oMRfrFTCEJB6vd2wx7/72AxR5HTj4hJ
 KpXI49GgdMGvH8Q+HINE+wiisRnOPnoWskcU4xZw9L01DiAmKbsadQJuAR5uM+EUhbDZ
 zFK4E+tmh/TQMIdesrAGkPCIgdNuBGjtVbRh+ivL5Rn/oLFAuBYAUsHix2e8piHd4MrS
 RcMZYByrc0y0lYLNxUwmDyzJ49ADtlNl+l11T0BzrL0zIcrID3k2ygnALZxNsEvJ/uGw
 MonChXlzg+sNWY13sCLO5oye0Zj0+Ro5JB34PWXbcuYZkujxKFAH/Y2iSH9BKqvTxx9O UA== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 359m359r4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 08:13:57 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B7DBZmc020491;
        Mon, 7 Dec 2020 13:13:54 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3581u8kq0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 13:13:54 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B7DCbSF51118404
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Dec 2020 13:12:37 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34F3911C04C;
        Mon,  7 Dec 2020 13:12:37 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F36EE11C05C;
        Mon,  7 Dec 2020 13:12:36 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Dec 2020 13:12:36 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 4/6] s390/qeth: don't replace a fully completed async TX buffer
Date:   Mon,  7 Dec 2020 14:12:31 +0100
Message-Id: <20201207131233.90383-5-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201207131233.90383-1-jwi@linux.ibm.com>
References: <20201207131233.90383-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-07_11:2020-12-04,2020-12-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 mlxscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 suspectscore=2 mlxlogscore=999 bulkscore=0 clxscore=1015 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070083
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For TX buffers that require an additional async notification via QAOB, the
TX completion code can now manage all the necessary processing if the
notification has already occurred (or is occurring concurrently).

In such cases we can avoid replacing the metadata that is associated
with the buffer's slot on the ring, and just keep using the current one.

As qeth_clear_output_buffer() will also handle any kmem cache-allocated
memory that was mapped into the TX buffer, qeth_qdio_handle_aob()
doesn't need to worry about it.

While at it, also remove the unneeded forward declaration for
qeth_init_qdio_out_buf().

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 89 ++++++++++++++++++-------------
 1 file changed, 51 insertions(+), 38 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 05d0b16bd7d6..869694217450 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -75,7 +75,6 @@ static void qeth_notify_skbs(struct qeth_qdio_out_q *queue,
 		enum iucv_tx_notify notification);
 static void qeth_tx_complete_buf(struct qeth_qdio_out_buffer *buf, bool error,
 				 int budget);
-static int qeth_init_qdio_out_buf(struct qeth_qdio_out_q *, int);
 
 static void qeth_close_dev_handler(struct work_struct *work)
 {
@@ -517,18 +516,6 @@ static void qeth_qdio_handle_aob(struct qeth_card *card,
 	buffer = (struct qeth_qdio_out_buffer *) aob->user1;
 	QETH_CARD_TEXT_(card, 5, "%lx", aob->user1);
 
-	/* Free dangling allocations. The attached skbs are handled by
-	 * qeth_cleanup_handled_pending().
-	 */
-	for (i = 0;
-	     i < aob->sb_count && i < QETH_MAX_BUFFER_ELEMENTS(card);
-	     i++) {
-		void *data = phys_to_virt(aob->sba[i]);
-
-		if (data && buffer->is_header[i])
-			kmem_cache_free(qeth_core_header_cache, data);
-	}
-
 	if (aob->aorc) {
 		QETH_CARD_TEXT_(card, 2, "aorc%02X", aob->aorc);
 		new_state = QETH_QDIO_BUF_QAOB_ERROR;
@@ -536,10 +523,9 @@ static void qeth_qdio_handle_aob(struct qeth_card *card,
 
 	switch (atomic_xchg(&buffer->state, new_state)) {
 	case QETH_QDIO_BUF_PRIMED:
-		/* Faster than TX completion code. */
-		notification = qeth_compute_cq_notification(aob->aorc, 0);
-		qeth_notify_skbs(buffer->q, buffer, notification);
-		atomic_set(&buffer->state, QETH_QDIO_BUF_HANDLED_DELAYED);
+		/* Faster than TX completion code, let it handle the async
+		 * completion for us.
+		 */
 		break;
 	case QETH_QDIO_BUF_PENDING:
 		/* TX completion code is active and will handle the async
@@ -550,6 +536,19 @@ static void qeth_qdio_handle_aob(struct qeth_card *card,
 		/* TX completion code is already finished. */
 		notification = qeth_compute_cq_notification(aob->aorc, 1);
 		qeth_notify_skbs(buffer->q, buffer, notification);
+
+		/* Free dangling allocations. The attached skbs are handled by
+		 * qeth_cleanup_handled_pending().
+		 */
+		for (i = 0;
+		     i < aob->sb_count && i < QETH_MAX_BUFFER_ELEMENTS(card);
+		     i++) {
+			void *data = phys_to_virt(aob->sba[i]);
+
+			if (data && buffer->is_header[i])
+				kmem_cache_free(qeth_core_header_cache, data);
+		}
+
 		atomic_set(&buffer->state, QETH_QDIO_BUF_HANDLED_DELAYED);
 		break;
 	default:
@@ -6078,9 +6077,13 @@ static void qeth_iqd_tx_complete(struct qeth_qdio_out_q *queue,
 				 QDIO_OUTBUF_STATE_FLAG_PENDING)) {
 		WARN_ON_ONCE(card->options.cq != QETH_CQ_ENABLED);
 
-		if (atomic_cmpxchg(&buffer->state, QETH_QDIO_BUF_PRIMED,
-						   QETH_QDIO_BUF_PENDING) ==
-		    QETH_QDIO_BUF_PRIMED) {
+		QETH_CARD_TEXT_(card, 5, "pel%u", bidx);
+
+		switch (atomic_cmpxchg(&buffer->state,
+				       QETH_QDIO_BUF_PRIMED,
+				       QETH_QDIO_BUF_PENDING)) {
+		case QETH_QDIO_BUF_PRIMED:
+			/* We have initial ownership, no QAOB (yet): */
 			qeth_notify_skbs(queue, buffer, TX_NOTIFY_PENDING);
 
 			/* Handle race with qeth_qdio_handle_aob(): */
@@ -6088,39 +6091,49 @@ static void qeth_iqd_tx_complete(struct qeth_qdio_out_q *queue,
 					    QETH_QDIO_BUF_NEED_QAOB)) {
 			case QETH_QDIO_BUF_PENDING:
 				/* No concurrent QAOB notification. */
-				break;
+
+				/* Prepare the queue slot for immediate re-use: */
+				qeth_scrub_qdio_buffer(buffer->buffer, queue->max_elements);
+				if (qeth_init_qdio_out_buf(queue, bidx)) {
+					QETH_CARD_TEXT(card, 2, "outofbuf");
+					qeth_schedule_recovery(card);
+				}
+
+				/* Skip clearing the buffer: */
+				return;
 			case QETH_QDIO_BUF_QAOB_OK:
 				qeth_notify_skbs(queue, buffer,
 						 TX_NOTIFY_DELAYED_OK);
-				atomic_set(&buffer->state,
-					   QETH_QDIO_BUF_HANDLED_DELAYED);
+				error = false;
 				break;
 			case QETH_QDIO_BUF_QAOB_ERROR:
 				qeth_notify_skbs(queue, buffer,
 						 TX_NOTIFY_DELAYED_GENERALERROR);
-				atomic_set(&buffer->state,
-					   QETH_QDIO_BUF_HANDLED_DELAYED);
+				error = true;
 				break;
 			default:
 				WARN_ON_ONCE(1);
 			}
-		}
-
-		QETH_CARD_TEXT_(card, 5, "pel%u", bidx);
 
-		/* prepare the queue slot for re-use: */
-		qeth_scrub_qdio_buffer(buffer->buffer, queue->max_elements);
-		if (qeth_init_qdio_out_buf(queue, bidx)) {
-			QETH_CARD_TEXT(card, 2, "outofbuf");
-			qeth_schedule_recovery(card);
+			break;
+		case QETH_QDIO_BUF_QAOB_OK:
+			/* qeth_qdio_handle_aob() already received a QAOB: */
+			qeth_notify_skbs(queue, buffer, TX_NOTIFY_OK);
+			error = false;
+			break;
+		case QETH_QDIO_BUF_QAOB_ERROR:
+			/* qeth_qdio_handle_aob() already received a QAOB: */
+			qeth_notify_skbs(queue, buffer, TX_NOTIFY_GENERALERROR);
+			error = true;
+			break;
+		default:
+			WARN_ON_ONCE(1);
 		}
-
-		return;
-	}
-
-	if (card->options.cq == QETH_CQ_ENABLED)
+	} else if (card->options.cq == QETH_CQ_ENABLED) {
 		qeth_notify_skbs(queue, buffer,
 				 qeth_compute_cq_notification(sflags, 0));
+	}
+
 	qeth_clear_output_buffer(queue, buffer, error, budget);
 }
 
-- 
2.17.1

