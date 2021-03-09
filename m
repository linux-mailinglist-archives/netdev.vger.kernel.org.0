Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE054332C9A
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 17:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbhCIQw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 11:52:57 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43882 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229799AbhCIQwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 11:52:32 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 129GXhRO118720;
        Tue, 9 Mar 2021 11:52:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=5T+Sq8LYiE/LvGRDzrvRmOF3q8OXC6+wA8m0VnDb+ww=;
 b=Ooby4WFjkK4FDDl9smrpEbw0mSdtEk+TdFNyr4gHBXxE5qvW4AA1ShjcDjvzSwBOfwV5
 iIrzoYdFu3AHEBXZsd5pQJYxxoymcaPoGH/iSM48SpA2pPEbIeBV4Kkvk4Ur/BJDLAZz
 Shn+8O020Z7bbxvMlbkqABMdwxxB9/6nZrkHaRSdwU0AahqYM4XkaHWN+1tTw9XW19jC
 4hMg35d/J1mul6YP3AUkq1IM52lYu/B2BHePlq5c2Ug4o8dQRd4TnM9n8rF7tmJWAN0F
 OyDw2m3hU8Re7wzHryXNTwLGVVqN/3x7XsrGvO3w2SXOlU5qToKTNvL6ZFmLWJSKYvjI mw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3762wrb00v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Mar 2021 11:52:30 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 129Gi5Mx013907;
        Tue, 9 Mar 2021 16:52:28 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3768urr70c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Mar 2021 16:52:28 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 129GqP3L42140102
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Mar 2021 16:52:25 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C570C5204E;
        Tue,  9 Mar 2021 16:52:25 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 7F23252050;
        Tue,  9 Mar 2021 16:52:25 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 4/4] s390/qeth: fix notification for pending buffers during teardown
Date:   Tue,  9 Mar 2021 17:52:21 +0100
Message-Id: <20210309165221.1735641-5-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210309165221.1735641-1-jwi@linux.ibm.com>
References: <20210309165221.1735641-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-09_13:2021-03-08,2021-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 bulkscore=0 adultscore=0 spamscore=0 malwarescore=0
 priorityscore=1501 suspectscore=0 phishscore=0 clxscore=1015
 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103090081
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cited commit reworked the state machine for pending TX buffers.
In qeth_iqd_tx_complete() it turned PENDING into a transient state, and
uses NEED_QAOB for buffers that get parked while waiting for their QAOB
completion.

But it missed to adjust the check in qeth_tx_complete_buf(). So if
qeth_tx_complete_pending_bufs() is called during teardown to drain
the parked TX buffers, we no longer raise a notification for af_iucv.

Instead of updating the checked state, just move this code into
qeth_tx_complete_pending_bufs() itself. This also gets rid of the
special-case in the common TX completion path.

Fixes: 8908f36d20d8 ("s390/qeth: fix af_iucv notification race")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index d0a56afec028..a814698387bc 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1390,9 +1390,6 @@ static void qeth_tx_complete_buf(struct qeth_qdio_out_buffer *buf, bool error,
 	struct qeth_qdio_out_q *queue = buf->q;
 	struct sk_buff *skb;
 
-	if (atomic_read(&buf->state) == QETH_QDIO_BUF_PENDING)
-		qeth_notify_skbs(queue, buf, TX_NOTIFY_GENERALERROR);
-
 	/* Empty buffer? */
 	if (buf->next_element_to_fill == 0)
 		return;
@@ -1465,6 +1462,9 @@ static void qeth_tx_complete_pending_bufs(struct qeth_card *card,
 			QETH_CARD_TEXT(card, 5, "fp");
 			QETH_CARD_TEXT_(card, 5, "%lx", (long) buf);
 
+			if (drain)
+				qeth_notify_skbs(queue, buf,
+						 TX_NOTIFY_GENERALERROR);
 			qeth_tx_complete_buf(buf, drain, 0);
 
 			list_del(&buf->list_entry);
-- 
2.25.1

