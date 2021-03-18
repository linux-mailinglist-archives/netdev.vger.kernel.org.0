Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09BB340D91
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 19:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232546AbhCRSzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 14:55:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64884 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230220AbhCRSzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 14:55:09 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12IIZBHY165089;
        Thu, 18 Mar 2021 14:55:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=CXmgABkdlU8VH9hl3BZtmEpDSVsW/At8kX8ChSKZ4aA=;
 b=HeN80x2dW9jTrDgWjk2JqWLmadwHBmQAQ8C+nYfMsNegJq5kQjoaWm1FiBqnI7d91AuZ
 yKaVrPNWiRN2TGRqzLbkgJG50/4cMoMNPyR2Xg5P4r6HP0KfwLTTK8jO1k6/0P57/ixO
 GU/kTgyGMxaKJ6mLrC3CFrUiwGHIV92t8nhp6/v8fYIDzYE9PMcyBAJfcknglmodpMQt
 Ag1PgTsx0V2EHxewPok1oYKrnzpx7fD3nmuhp6Bb0nVcCxGxz/3KAi+RvjDwoibJeapl
 NK1V9vB25gQh5cPwwbehYaBGhcSd0+o8/oLKhyTa84lKo6s6R5pQjycp+so1B8FAenAR Og== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37c81xhkqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 14:55:05 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12IIqVQt025838;
        Thu, 18 Mar 2021 18:55:04 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 37b30p1va7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 18:55:04 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12IIsiEr32244046
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Mar 2021 18:54:44 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1ECE2A405D;
        Thu, 18 Mar 2021 18:55:01 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8386A405B;
        Thu, 18 Mar 2021 18:55:00 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Mar 2021 18:55:00 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 2/3] s390/qeth: enable napi_consume_skb() for pending TX buffers
Date:   Thu, 18 Mar 2021 19:54:55 +0100
Message-Id: <20210318185456.2153426-3-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318185456.2153426-1-jwi@linux.ibm.com>
References: <20210318185456.2153426-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_12:2021-03-17,2021-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 clxscore=1015
 lowpriorityscore=0 bulkscore=0 phishscore=0 priorityscore=1501 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103180131
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pending TX buffers are completed from the same NAPI code as normal
TX buffers. Pass the NAPI budget to qeth_tx_complete_buf() so that
the freeing of the completed skbs can be deferred.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index abd1e49cf97a..6954d4e831a3 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1453,7 +1453,7 @@ static void qeth_clear_output_buffer(struct qeth_qdio_out_q *queue,
 
 static void qeth_tx_complete_pending_bufs(struct qeth_card *card,
 					  struct qeth_qdio_out_q *queue,
-					  bool drain)
+					  bool drain, int budget)
 {
 	struct qeth_qdio_out_buffer *buf, *tmp;
 
@@ -1465,7 +1465,7 @@ static void qeth_tx_complete_pending_bufs(struct qeth_card *card,
 			if (drain)
 				qeth_notify_skbs(queue, buf,
 						 TX_NOTIFY_GENERALERROR);
-			qeth_tx_complete_buf(buf, drain, 0);
+			qeth_tx_complete_buf(buf, drain, budget);
 
 			list_del(&buf->list_entry);
 			kmem_cache_free(qeth_qdio_outbuf_cache, buf);
@@ -1477,7 +1477,7 @@ static void qeth_drain_output_queue(struct qeth_qdio_out_q *q, bool free)
 {
 	int j;
 
-	qeth_tx_complete_pending_bufs(q->card, q, true);
+	qeth_tx_complete_pending_bufs(q->card, q, true, 0);
 
 	for (j = 0; j < QDIO_MAX_BUFFERS_PER_Q; ++j) {
 		if (!q->bufs[j])
@@ -6152,7 +6152,7 @@ static int qeth_tx_poll(struct napi_struct *napi, int budget)
 		unsigned int bytes = 0;
 		int completed;
 
-		qeth_tx_complete_pending_bufs(card, queue, false);
+		qeth_tx_complete_pending_bufs(card, queue, false, budget);
 
 		if (qeth_out_queue_is_empty(queue)) {
 			napi_complete(napi);
-- 
2.25.1

