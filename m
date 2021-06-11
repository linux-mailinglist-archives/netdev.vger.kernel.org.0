Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C019D3A3D3F
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 09:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbhFKHgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 03:36:01 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59564 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231324AbhFKHfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 03:35:55 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15B7Wg3J150845;
        Fri, 11 Jun 2021 03:33:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=OsX4kgYDsJsPAHfeWMBqfogdsmcQ0E8W9NDi4p7viRI=;
 b=dCxLIzsizn9iGAj3OQfLT/oZxqkpWb1G+6BultWX0UUBdw54CAA2QHayFAAoY+HaCF22
 SlWev0NWCtY1NxM/ZiLK4RI2Ji9rqV1VeVCWSSuotMNEGGyhDFIHxTTMtZyVIbCDANGQ
 kMF59+nfPSkcS7Om8S0lw5ZDJFnnEWrAjYyE9lMUjq3jlWiFn59Vb2jj6q9Iw/1rxI2S
 BLzy6sTpL80fhGrcyTCgCO5d1KTM2EegHxgT42U3Gds5Hb0owTLiQWvKYkU3zNRK1cwo
 EbCOE7GkXfBaTvGD47PLVfHUKTt3gkbZY0cL2r/HKV/aCawsKhekVB+WUbWClmWs1bVU yg== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39439g0dgq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 03:33:55 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15B7Vr9p024352;
        Fri, 11 Jun 2021 07:33:53 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3900hhu9bq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 07:33:52 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15B7WvAO36372894
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 07:32:57 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E630A406F;
        Fri, 11 Jun 2021 07:33:49 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D883A4067;
        Fri, 11 Jun 2021 07:33:49 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 11 Jun 2021 07:33:49 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 5/9] s390/qeth: consolidate completion of pending TX buffers
Date:   Fri, 11 Jun 2021 09:33:37 +0200
Message-Id: <20210611073341.1634501-6-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611073341.1634501-1-jwi@linux.ibm.com>
References: <20210611073341.1634501-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: s2G7ZrIVgtRzTkrVnti511d_aYVrxF51
X-Proofpoint-GUID: s2G7ZrIVgtRzTkrVnti511d_aYVrxF51
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-11_01:2021-06-11,2021-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106110048
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With commit 396c100472dd ("s390/qdio: let driver manage the QAOB")
a pending TX buffer now has access to its associated QAOB during
TX completion processing. We can thus reduce the amount of work & state
propagation that needs to be done by qeth_qdio_handle_aob().

Move all this logic into the respective TX completion paths. Doing so
even allows us to determine more precise TX_NOTIFY_* values via
qeth_compute_cq_notification(aob->aorc, ...).

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  3 +-
 drivers/s390/net/qeth_core_main.c | 73 ++++++++++++-------------------
 2 files changed, 29 insertions(+), 47 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index ad0e86aa99b2..5de5b419a761 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -422,8 +422,7 @@ enum qeth_qdio_out_buffer_state {
 	/* Finished by the TX completion code: */
 	QETH_QDIO_BUF_NEED_QAOB,
 	/* Received QAOB notification on CQ: */
-	QETH_QDIO_BUF_QAOB_OK,
-	QETH_QDIO_BUF_QAOB_ERROR,
+	QETH_QDIO_BUF_QAOB_DONE,
 };
 
 struct qeth_qdio_out_buffer {
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 83d540f8b527..99e3b0b75cc3 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -70,9 +70,6 @@ static void qeth_issue_next_read_cb(struct qeth_card *card,
 				    unsigned int data_length);
 static int qeth_qdio_establish(struct qeth_card *);
 static void qeth_free_qdio_queues(struct qeth_card *card);
-static void qeth_notify_skbs(struct qeth_qdio_out_q *queue,
-		struct qeth_qdio_out_buffer *buf,
-		enum iucv_tx_notify notification);
 
 static void qeth_close_dev_handler(struct work_struct *work)
 {
@@ -437,12 +434,9 @@ static enum iucv_tx_notify qeth_compute_cq_notification(int sbalf15,
 static void qeth_qdio_handle_aob(struct qeth_card *card,
 				 unsigned long phys_aob_addr)
 {
-	enum qeth_qdio_out_buffer_state new_state = QETH_QDIO_BUF_QAOB_OK;
 	struct qaob *aob;
 	struct qeth_qdio_out_buffer *buffer;
-	enum iucv_tx_notify notification;
 	struct qeth_qdio_out_q *queue;
-	unsigned int i;
 
 	aob = (struct qaob *) phys_to_virt(phys_aob_addr);
 	QETH_CARD_TEXT(card, 5, "haob");
@@ -450,12 +444,10 @@ static void qeth_qdio_handle_aob(struct qeth_card *card,
 	buffer = (struct qeth_qdio_out_buffer *) aob->user1;
 	QETH_CARD_TEXT_(card, 5, "%lx", aob->user1);
 
-	if (aob->aorc) {
+	if (aob->aorc)
 		QETH_CARD_TEXT_(card, 2, "aorc%02X", aob->aorc);
-		new_state = QETH_QDIO_BUF_QAOB_ERROR;
-	}
 
-	switch (atomic_xchg(&buffer->state, new_state)) {
+	switch (atomic_xchg(&buffer->state, QETH_QDIO_BUF_QAOB_DONE)) {
 	case QETH_QDIO_BUF_PRIMED:
 		/* Faster than TX completion code, let it handle the async
 		 * completion for us. It will also recycle the QAOB.
@@ -468,21 +460,6 @@ static void qeth_qdio_handle_aob(struct qeth_card *card,
 		break;
 	case QETH_QDIO_BUF_NEED_QAOB:
 		/* TX completion code is already finished. */
-		notification = qeth_compute_cq_notification(aob->aorc, 1);
-		qeth_notify_skbs(buffer->q, buffer, notification);
-
-		/* Free dangling allocations. The attached skbs are handled by
-		 * qeth_tx_complete_pending_bufs(), and so is the QAOB.
-		 */
-		for (i = 0;
-		     i < aob->sb_count && i < QETH_MAX_BUFFER_ELEMENTS(card);
-		     i++) {
-			void *data = phys_to_virt(aob->sba[i]);
-
-			if (data && buffer->is_header[i])
-				kmem_cache_free(qeth_core_header_cache, data);
-			buffer->is_header[i] = 0;
-		}
 
 		queue = buffer->q;
 		atomic_set(&buffer->state, QETH_QDIO_BUF_EMPTY);
@@ -1435,15 +1412,29 @@ static void qeth_tx_complete_pending_bufs(struct qeth_card *card,
 	struct qeth_qdio_out_buffer *buf, *tmp;
 
 	list_for_each_entry_safe(buf, tmp, &queue->pending_bufs, list_entry) {
+		struct qaob *aob = buf->aob;
+		enum iucv_tx_notify notify;
+		unsigned int i;
+
 		if (drain || atomic_read(&buf->state) == QETH_QDIO_BUF_EMPTY) {
 			QETH_CARD_TEXT(card, 5, "fp");
 			QETH_CARD_TEXT_(card, 5, "%lx", (long) buf);
 
-			if (drain)
-				qeth_notify_skbs(queue, buf,
-						 TX_NOTIFY_GENERALERROR);
+			notify = drain ? TX_NOTIFY_GENERALERROR :
+					 qeth_compute_cq_notification(aob->aorc, 1);
+			qeth_notify_skbs(queue, buf, notify);
 			qeth_tx_complete_buf(buf, drain, budget);
 
+			for (i = 0;
+			     i < aob->sb_count && i < queue->max_elements;
+			     i++) {
+				void *data = phys_to_virt(aob->sba[i]);
+
+				if (data && buf->is_header[i])
+					kmem_cache_free(qeth_core_header_cache,
+							data);
+			}
+
 			list_del(&buf->list_entry);
 			qeth_free_out_buf(buf);
 		}
@@ -6048,6 +6039,7 @@ static void qeth_iqd_tx_complete(struct qeth_qdio_out_q *queue,
 
 	if (qdio_error == QDIO_ERROR_SLSB_PENDING) {
 		struct qaob *aob = buffer->aob;
+		enum iucv_tx_notify notify;
 
 		if (!aob) {
 			netdev_WARN_ONCE(card->dev,
@@ -6084,30 +6076,21 @@ static void qeth_iqd_tx_complete(struct qeth_qdio_out_q *queue,
 					 &queue->pending_bufs);
 				/* Skip clearing the buffer: */
 				return;
-			case QETH_QDIO_BUF_QAOB_OK:
-				qeth_notify_skbs(queue, buffer,
-						 TX_NOTIFY_DELAYED_OK);
-				error = false;
-				break;
-			case QETH_QDIO_BUF_QAOB_ERROR:
-				qeth_notify_skbs(queue, buffer,
-						 TX_NOTIFY_DELAYED_GENERALERROR);
-				error = true;
+			case QETH_QDIO_BUF_QAOB_DONE:
+				notify = qeth_compute_cq_notification(aob->aorc, 1);
+				qeth_notify_skbs(queue, buffer, notify);
+				error = !!aob->aorc;
 				break;
 			default:
 				WARN_ON_ONCE(1);
 			}
 
 			break;
-		case QETH_QDIO_BUF_QAOB_OK:
-			/* qeth_qdio_handle_aob() already received a QAOB: */
-			qeth_notify_skbs(queue, buffer, TX_NOTIFY_OK);
-			error = false;
-			break;
-		case QETH_QDIO_BUF_QAOB_ERROR:
+		case QETH_QDIO_BUF_QAOB_DONE:
 			/* qeth_qdio_handle_aob() already received a QAOB: */
-			qeth_notify_skbs(queue, buffer, TX_NOTIFY_GENERALERROR);
-			error = true;
+			notify = qeth_compute_cq_notification(aob->aorc, 0);
+			qeth_notify_skbs(queue, buffer, notify);
+			error = !!aob->aorc;
 			break;
 		default:
 			WARN_ON_ONCE(1);
-- 
2.25.1

