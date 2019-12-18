Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2E62124DD5
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 17:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbfLRQfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 11:35:05 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40680 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727563AbfLRQfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 11:35:02 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBIGYLPZ085352
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 11:35:01 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wypm0af20-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 11:35:00 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Wed, 18 Dec 2019 16:34:56 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 18 Dec 2019 16:34:53 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBIGYqpa35061838
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 16:34:52 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64587A405B;
        Wed, 18 Dec 2019 16:34:52 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 28D37A405F;
        Wed, 18 Dec 2019 16:34:52 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Dec 2019 16:34:52 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 2/9] s390/qeth: wake up all waiters from qeth_irq()
Date:   Wed, 18 Dec 2019 17:34:43 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191218163450.36731-1-jwi@linux.ibm.com>
References: <20191218163450.36731-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19121816-0016-0000-0000-000002D63BE4
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121816-0017-0000-0000-000033387B95
Message-Id: <20191218163450.36731-3-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_05:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=2 mlxscore=0 adultscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912180136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

card->wait_q is shared by different users, for different wake-up
conditions. qeth_irq() can potentially trigger multiple of these
conditions:
1) A change to channel->irq_pending, which qeth_send_control_data() is
   waiting for.
2) A change to card->state, which qeth_clear_channel() and
   qeth_halt_channel() are waiting for.

As qeth_irq() does only a single wake_up(), we might miss to wake up
a second eligible waiter. Luckily all waiters are guarded with a
timeout, so this situation should recover on its own eventually.

To make things work robustly, add an additional wake_up() for changes
to channel->state. And extract a helper that updates
channel->irq_pending along with the needed wake_up().

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  7 +++++++
 drivers/s390/net/qeth_core_main.c | 27 +++++++++++----------------
 2 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index a23875a4fa2b..b54ef12840a2 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -862,6 +862,13 @@ static inline bool qeth_card_hw_is_reachable(struct qeth_card *card)
 	return card->state == CARD_STATE_SOFTSETUP;
 }
 
+static inline void qeth_unlock_channel(struct qeth_card *card,
+				       struct qeth_channel *channel)
+{
+	atomic_set(&channel->irq_pending, 0);
+	wake_up(&card->wait_q);
+}
+
 struct qeth_trap_id {
 	__u16 lparnr;
 	char vmname[8];
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 3d2374801308..38f3ed7567bc 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -520,11 +520,10 @@ static int __qeth_issue_next_read(struct qeth_card *card)
 	} else {
 		QETH_DBF_MESSAGE(2, "error %i on device %x when starting next read ccw!\n",
 				 rc, CARD_DEVID(card));
-		atomic_set(&channel->irq_pending, 0);
+		qeth_unlock_channel(card, channel);
 		qeth_put_cmd(iob);
 		card->read_or_write_problem = 1;
 		qeth_schedule_recovery(card);
-		wake_up(&card->wait_q);
 	}
 	return rc;
 }
@@ -1001,24 +1000,25 @@ static void qeth_irq(struct ccw_device *cdev, unsigned long intparm,
 	}
 
 	channel->active_cmd = NULL;
+	qeth_unlock_channel(card, channel);
 
 	rc = qeth_check_irb_error(card, cdev, irb);
 	if (rc) {
 		/* IO was terminated, free its resources. */
 		if (iob)
 			qeth_cancel_cmd(iob, rc);
-		atomic_set(&channel->irq_pending, 0);
-		wake_up(&card->wait_q);
 		return;
 	}
 
-	atomic_set(&channel->irq_pending, 0);
-
-	if (irb->scsw.cmd.fctl & (SCSW_FCTL_CLEAR_FUNC))
+	if (irb->scsw.cmd.fctl & SCSW_FCTL_CLEAR_FUNC) {
 		channel->state = CH_STATE_STOPPED;
+		wake_up(&card->wait_q);
+	}
 
-	if (irb->scsw.cmd.fctl & (SCSW_FCTL_HALT_FUNC))
+	if (irb->scsw.cmd.fctl & SCSW_FCTL_HALT_FUNC) {
 		channel->state = CH_STATE_HALTED;
+		wake_up(&card->wait_q);
+	}
 
 	if (iob && (irb->scsw.cmd.fctl & (SCSW_FCTL_CLEAR_FUNC |
 					  SCSW_FCTL_HALT_FUNC))) {
@@ -1052,7 +1052,7 @@ static void qeth_irq(struct ccw_device *cdev, unsigned long intparm,
 				qeth_cancel_cmd(iob, rc);
 			qeth_clear_ipacmd_list(card);
 			qeth_schedule_recovery(card);
-			goto out;
+			return;
 		}
 	}
 
@@ -1060,16 +1060,12 @@ static void qeth_irq(struct ccw_device *cdev, unsigned long intparm,
 		/* sanity check: */
 		if (irb->scsw.cmd.count > iob->length) {
 			qeth_cancel_cmd(iob, -EIO);
-			goto out;
+			return;
 		}
 		if (iob->callback)
 			iob->callback(card, iob,
 				      iob->length - irb->scsw.cmd.count);
 	}
-
-out:
-	wake_up(&card->wait_q);
-	return;
 }
 
 static void qeth_notify_skbs(struct qeth_qdio_out_q *q,
@@ -1780,8 +1776,7 @@ static int qeth_send_control_data(struct qeth_card *card,
 		QETH_CARD_TEXT_(card, 2, " err%d", rc);
 		qeth_dequeue_cmd(card, iob);
 		qeth_put_cmd(iob);
-		atomic_set(&channel->irq_pending, 0);
-		wake_up(&card->wait_q);
+		qeth_unlock_channel(card, channel);
 		goto out;
 	}
 
-- 
2.17.1

