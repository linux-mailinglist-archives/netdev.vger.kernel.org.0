Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254DC3074C4
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 12:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbhA1L1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 06:27:20 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32790 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231409AbhA1L0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 06:26:44 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10SB1u80132765;
        Thu, 28 Jan 2021 06:26:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=4b8TszhmECpsNamqc8+72bxdAU0ZbDa0bSKiJAdp2qk=;
 b=ZlVSU5FwW/PJzz4VFEhpT2HoQmda43DymTLVeboXFnVZTfsQBhmwpwnsEK1UpEihQIdM
 cXEdc5npPh0/mKfrmH/RP9Wwfpnv3ASPBWPZR6TiwLffgqMS0W/tnsRv3XBKYLsTV2Jh
 IqhskbcGLgdN8ODLHCjCo3DjUNueY52gQaf8pGKm+GHCrDLLA4wolXofM7oiWLVNwb+x
 FAVDRn44PsECMmkRYmXHa+v6LJ06ip/O2t+TgetpbgYx5gSfuMOnGixzcUnyV0zbPIAA
 X5HxgCdHMM4QYirybDAsLzPx3M2xMSA8Wj6gKXLSekgAiAdlCiaNXiVhjJ9hgQZTTXiN CA== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36bqx3r3dm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jan 2021 06:26:02 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10SBMJjI018386;
        Thu, 28 Jan 2021 11:26:00 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 368b2hafgk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jan 2021 11:26:00 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10SBPvAr29229400
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jan 2021 11:25:57 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70DF542045;
        Thu, 28 Jan 2021 11:25:57 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3078B42042;
        Thu, 28 Jan 2021 11:25:57 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 28 Jan 2021 11:25:57 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 5/5] s390/qeth: don't fake a TX completion interrupt after TX error
Date:   Thu, 28 Jan 2021 12:25:51 +0100
Message-Id: <20210128112551.18780-6-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210128112551.18780-1-jwi@linux.ibm.com>
References: <20210128112551.18780-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-28_05:2021-01-27,2021-01-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 suspectscore=0 adultscore=0 bulkscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 impostorscore=0 phishscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101280051
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When do_qdio() returns with an unexpected error, qeth_flush_buffers()
kicks off a recovery action.

In such a case there's no point in starting TX completion processing,
the device gets torn down anyway. So take a closer look at do_qdio()'s
return value, and skip the TX completion processing accordingly.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 34 ++++++++++++++++---------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index de9d27e1c529..ea2e139cd592 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -3692,24 +3692,27 @@ static void qeth_flush_buffers(struct qeth_qdio_out_q *queue, int index,
 	rc = do_QDIO(CARD_DDEV(queue->card), qdio_flags,
 		     queue->queue_no, index, count);
 
-	/* Fake the TX completion interrupt: */
-	if (IS_IQD(card)) {
-		unsigned int frames = READ_ONCE(queue->max_coalesced_frames);
-		unsigned int usecs = READ_ONCE(queue->coalesce_usecs);
+	switch (rc) {
+	case 0:
+	case -ENOBUFS:
+		/* ignore temporary SIGA errors without busy condition */
 
-		if (frames && queue->coalesced_frames >= frames) {
-			napi_schedule(&queue->napi);
-			queue->coalesced_frames = 0;
-			QETH_TXQ_STAT_INC(queue, coal_frames);
-		} else if (usecs) {
-			qeth_tx_arm_timer(queue, usecs);
+		/* Fake the TX completion interrupt: */
+		if (IS_IQD(card)) {
+			unsigned int frames = READ_ONCE(queue->max_coalesced_frames);
+			unsigned int usecs = READ_ONCE(queue->coalesce_usecs);
+
+			if (frames && queue->coalesced_frames >= frames) {
+				napi_schedule(&queue->napi);
+				queue->coalesced_frames = 0;
+				QETH_TXQ_STAT_INC(queue, coal_frames);
+			} else if (usecs) {
+				qeth_tx_arm_timer(queue, usecs);
+			}
 		}
-	}
 
-	if (rc) {
-		/* ignore temporary SIGA errors without busy condition */
-		if (rc == -ENOBUFS)
-			return;
+		break;
+	default:
 		QETH_CARD_TEXT(queue->card, 2, "flushbuf");
 		QETH_CARD_TEXT_(queue->card, 2, " q%d", queue->queue_no);
 		QETH_CARD_TEXT_(queue->card, 2, " idx%d", index);
@@ -3719,7 +3722,6 @@ static void qeth_flush_buffers(struct qeth_qdio_out_q *queue, int index,
 		/* this must not happen under normal circumstances. if it
 		 * happens something is really wrong -> recover */
 		qeth_schedule_recovery(queue->card);
-		return;
 	}
 }
 
-- 
2.17.1

