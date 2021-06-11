Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE8833A3D47
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 09:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbhFKHgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 03:36:16 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55082 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231502AbhFKHgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 03:36:07 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15B7Y6dV031524;
        Fri, 11 Jun 2021 03:34:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=bV/CtTGlRsK+2qA6jQ5VvX0wVdAkztwB8atUOtj87jk=;
 b=BkOKqwv5nXTsgd4T4uVKhNfrb3unJPFew3S6CisNJ+lvomQTDhZBFGduUlhhY4DGFCAL
 2hY1uQkNoqXV/6CkIlHk2gxGMSpZBP5IlIl+yggwdznqGEqEfUqIdpjDly0guGqqjsRt
 FrW3grMLPY4z1CFf8vmGbjKvoNo+RX7outR+uQX8GwRwgS/Q6AZAF0aCbuKfwxKRZ0d+
 IOBK0e6oH+TdXbucmAJQs4O/4Qeyge7/Im3FWKhs5Gl17HuDSO8DNQUp+x0aW50jqUz+
 2A4ubiWOApjkM2iRnoqHs1l3hCkSho4SPq5E5okVaZU4pkT/1TB8zj5YChgsG8M2vFTO Nw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3942n69f1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 03:34:07 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15B7Vnkc007757;
        Fri, 11 Jun 2021 07:33:53 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3900w8k92x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 07:33:53 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15B7XoR829426130
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 07:33:50 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 460B0A405B;
        Fri, 11 Jun 2021 07:33:50 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09F42A4067;
        Fri, 11 Jun 2021 07:33:50 +0000 (GMT)
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
Subject: [PATCH net-next 7/9] s390/qeth: remove TX buffer's pointer to its queue
Date:   Fri, 11 Jun 2021 09:33:39 +0200
Message-Id: <20210611073341.1634501-8-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611073341.1634501-1-jwi@linux.ibm.com>
References: <20210611073341.1634501-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jl5jM9vF_yUo6_sVFem12v2jLF64tF0Z
X-Proofpoint-ORIG-GUID: jl5jM9vF_yUo6_sVFem12v2jLF64tF0Z
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-11_01:2021-06-11,2021-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 suspectscore=0 phishscore=0 priorityscore=1501 adultscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106110048
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qeth_tx_complete_buf() is the only remaining user of buf->q, and the
callers can easily provide this as a parameter instead.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      | 1 -
 drivers/s390/net/qeth_core_main.c | 9 ++++-----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 457224b7b97f..ff1064f871e5 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -439,7 +439,6 @@ struct qeth_qdio_out_buffer {
 	struct sk_buff_head skb_list;
 	int is_header[QDIO_MAX_ELEMENTS_PER_BUFFER];
 
-	struct qeth_qdio_out_q *q;
 	struct list_head list_entry;
 	struct qaob *aob;
 };
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 5ddb2939d4fc..0ad175d54c13 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1290,10 +1290,10 @@ static void qeth_notify_skbs(struct qeth_qdio_out_q *q,
 	}
 }
 
-static void qeth_tx_complete_buf(struct qeth_qdio_out_buffer *buf, bool error,
+static void qeth_tx_complete_buf(struct qeth_qdio_out_q *queue,
+				 struct qeth_qdio_out_buffer *buf, bool error,
 				 int budget)
 {
-	struct qeth_qdio_out_q *queue = buf->q;
 	struct sk_buff *skb;
 
 	/* Empty buffer? */
@@ -1342,7 +1342,7 @@ static void qeth_clear_output_buffer(struct qeth_qdio_out_q *queue,
 		QETH_TXQ_STAT_INC(queue, completion_irq);
 	}
 
-	qeth_tx_complete_buf(buf, error, budget);
+	qeth_tx_complete_buf(queue, buf, error, budget);
 
 	for (i = 0; i < queue->max_elements; ++i) {
 		void *data = phys_to_virt(buf->buffer->element[i].addr);
@@ -1386,7 +1386,7 @@ static void qeth_tx_complete_pending_bufs(struct qeth_card *card,
 			notify = drain ? TX_NOTIFY_GENERALERROR :
 					 qeth_compute_cq_notification(aob->aorc, 1);
 			qeth_notify_skbs(queue, buf, notify);
-			qeth_tx_complete_buf(buf, drain, budget);
+			qeth_tx_complete_buf(queue, buf, drain, budget);
 
 			for (i = 0;
 			     i < aob->sb_count && i < queue->max_elements;
@@ -2530,7 +2530,6 @@ static int qeth_alloc_out_buf(struct qeth_qdio_out_q *q, unsigned int bidx,
 	newbuf->buffer = q->qdio_bufs[bidx];
 	skb_queue_head_init(&newbuf->skb_list);
 	lockdep_set_class(&newbuf->skb_list.lock, &qdio_out_skb_queue_key);
-	newbuf->q = q;
 	atomic_set(&newbuf->state, QETH_QDIO_BUF_EMPTY);
 	q->bufs[bidx] = newbuf;
 	return 0;
-- 
2.25.1

