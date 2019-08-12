Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE888A16E
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 16:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfHLOor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 10:44:47 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15782 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726585AbfHLOor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 10:44:47 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7CEgteb006468
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 10:44:45 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ub7tseh8r-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 10:44:45 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Mon, 12 Aug 2019 15:44:43 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 12 Aug 2019 15:44:40 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7CEidpp14745842
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Aug 2019 14:44:39 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E9A44203F;
        Mon, 12 Aug 2019 14:44:39 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C48CD42049;
        Mon, 12 Aug 2019 14:44:38 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 12 Aug 2019 14:44:38 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net] s390/qeth: serialize cmd reply with concurrent timeout
Date:   Mon, 12 Aug 2019 16:44:35 +0200
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 19081214-0020-0000-0000-0000035EDBF1
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19081214-0021-0000-0000-000021B3EBB1
Message-Id: <20190812144435.67451-1-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-12_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=789 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908120165
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Callbacks for a cmd reply run outside the protection of card->lock, to
allow for additional cmds to be issued & enqueued in parallel.

When qeth_send_control_data() bails out for a cmd without having
received a reply (eg. due to timeout), its callback may concurrently be
processing a reply that just arrived. In this case, the callback
potentially accesses a stale reply->reply_param area that eg. was
on-stack and has already been released.

To avoid this race, add some locking so that qeth_send_control_data()
can (1) wait for a concurrently running callback, and (2) zap any
pending callback that still wants to run.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  1 +
 drivers/s390/net/qeth_core_main.c | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index c7ee07ce3615..28db887d38ed 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -629,6 +629,7 @@ struct qeth_seqno {
 struct qeth_reply {
 	struct list_head list;
 	struct completion received;
+	spinlock_t lock;
 	int (*callback)(struct qeth_card *, struct qeth_reply *,
 		unsigned long);
 	u32 seqno;
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 4d0caeebc802..9c3310c4d61d 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -544,6 +544,7 @@ static struct qeth_reply *qeth_alloc_reply(struct qeth_card *card)
 	if (reply) {
 		refcount_set(&reply->refcnt, 1);
 		init_completion(&reply->received);
+		spin_lock_init(&reply->lock);
 	}
 	return reply;
 }
@@ -799,6 +800,13 @@ static void qeth_issue_next_read_cb(struct qeth_card *card,
 
 	if (!reply->callback) {
 		rc = 0;
+		goto no_callback;
+	}
+
+	spin_lock_irqsave(&reply->lock, flags);
+	if (reply->rc) {
+		/* Bail out when the requestor has already left: */
+		rc = reply->rc;
 	} else {
 		if (cmd) {
 			reply->offset = (u16)((char *)cmd - (char *)iob->data);
@@ -807,7 +815,9 @@ static void qeth_issue_next_read_cb(struct qeth_card *card,
 			rc = reply->callback(card, reply, (unsigned long)iob);
 		}
 	}
+	spin_unlock_irqrestore(&reply->lock, flags);
 
+no_callback:
 	if (rc <= 0)
 		qeth_notify_reply(reply, rc);
 	qeth_put_reply(reply);
@@ -1749,6 +1759,16 @@ static int qeth_send_control_data(struct qeth_card *card,
 		rc = (timeout == -ERESTARTSYS) ? -EINTR : -ETIME;
 
 	qeth_dequeue_reply(card, reply);
+
+	if (reply_cb) {
+		/* Wait until the callback for a late reply has completed: */
+		spin_lock_irq(&reply->lock);
+		if (rc)
+			/* Zap any callback that's still pending: */
+			reply->rc = rc;
+		spin_unlock_irq(&reply->lock);
+	}
+
 	if (!rc)
 		rc = reply->rc;
 	qeth_put_reply(reply);
-- 
2.17.1

