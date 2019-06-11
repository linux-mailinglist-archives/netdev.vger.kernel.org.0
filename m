Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5B793D265
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 18:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405627AbfFKQiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 12:38:16 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51224 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404675AbfFKQiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 12:38:14 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5BGR2Pd008860
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 12:38:13 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t2favt52n-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 12:38:13 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Tue, 11 Jun 2019 17:38:10 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 11 Jun 2019 17:38:08 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5BGc76N39452934
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jun 2019 16:38:07 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 154D54C044;
        Tue, 11 Jun 2019 16:38:07 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA54A4C046;
        Tue, 11 Jun 2019 16:38:06 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jun 2019 16:38:06 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 07/13] s390/qeth: remove OSN-specific IO code
Date:   Tue, 11 Jun 2019 18:37:54 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190611163800.64730-1-jwi@linux.ibm.com>
References: <20190611163800.64730-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19061116-0012-0000-0000-000003283B16
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061116-0013-0000-0000-000021613E6F
Message-Id: <20190611163800.64730-8-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-11_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906110106
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OSN currently provides a custom code path to submit IPA cmds, without
waiting for the cmd response. Replace it with qeth_send_ipa_cmd(), which
uses the common qeth_send_control_data() IO infrastructure.

By setting a custom iob->callback, we can now provide feedback to the
caller about whether the cmd has been successfully submitted to HW.
Since the callback then immediately wakes up the reply-waiter object, we
maintain the old behaviour of returning early without waiting for the
response.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  1 +
 drivers/s390/net/qeth_core_main.c |  3 ++-
 drivers/s390/net/qeth_l2_main.c   | 43 +++++--------------------------
 3 files changed, 10 insertions(+), 37 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 14e8ab34ab2f..be50e701b744 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -996,6 +996,7 @@ void qeth_setadp_promisc_mode(struct qeth_card *);
 int qeth_setadpparms_change_macaddr(struct qeth_card *);
 void qeth_tx_timeout(struct net_device *);
 void qeth_release_buffer(struct qeth_channel *, struct qeth_cmd_buffer *);
+void qeth_notify_reply(struct qeth_reply *reply, int reason);
 void qeth_prepare_ipa_cmd(struct qeth_card *card, struct qeth_cmd_buffer *iob,
 			  u16 cmd_length);
 struct qeth_cmd_buffer *qeth_get_buffer(struct qeth_channel *channel);
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 3d25cff404fe..2ad51afa6747 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -577,11 +577,12 @@ static void qeth_dequeue_reply(struct qeth_card *card, struct qeth_reply *reply)
 	spin_unlock_irq(&card->lock);
 }
 
-static void qeth_notify_reply(struct qeth_reply *reply, int reason)
+void qeth_notify_reply(struct qeth_reply *reply, int reason)
 {
 	reply->rc = reason;
 	complete(&reply->received);
 }
+EXPORT_SYMBOL_GPL(qeth_notify_reply);
 
 static void qeth_issue_ipa_msg(struct qeth_ipa_cmd *cmd, int rc,
 		struct qeth_card *card)
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 5fa217382480..7db2c5672e02 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -1033,42 +1033,12 @@ struct qeth_discipline qeth_l2_discipline = {
 };
 EXPORT_SYMBOL_GPL(qeth_l2_discipline);
 
-static int qeth_osn_send_control_data(struct qeth_card *card, int len,
-			   struct qeth_cmd_buffer *iob)
+static void qeth_osn_assist_cb(struct qeth_card *card,
+			       struct qeth_channel *channel,
+			       struct qeth_cmd_buffer *iob)
 {
-	struct qeth_channel *channel = iob->channel;
-	int rc = 0;
-
-	QETH_CARD_TEXT(card, 5, "osndctrd");
-
-	wait_event(card->wait_q, qeth_trylock_channel(channel));
-	iob->finalize(card, iob, len);
-	QETH_DBF_HEX(CTRL, 2, iob->data, min(len, QETH_DBF_CTRL_LEN));
-	QETH_CARD_TEXT(card, 6, "osnoirqp");
-	spin_lock_irq(get_ccwdev_lock(channel->ccwdev));
-	rc = ccw_device_start_timeout(channel->ccwdev, channel->ccw,
-				      (addr_t) iob, 0, 0, iob->timeout);
-	spin_unlock_irq(get_ccwdev_lock(channel->ccwdev));
-	if (rc) {
-		QETH_DBF_MESSAGE(2, "qeth_osn_send_control_data: "
-			   "ccw_device_start rc = %i\n", rc);
-		QETH_CARD_TEXT_(card, 2, " err%d", rc);
-		qeth_release_buffer(channel, iob);
-		atomic_set(&channel->irq_pending, 0);
-		wake_up(&card->wait_q);
-	}
-	return rc;
-}
-
-static int qeth_osn_send_ipa_cmd(struct qeth_card *card,
-				 struct qeth_cmd_buffer *iob)
-{
-	u16 length;
-
-	QETH_CARD_TEXT(card, 4, "osndipa");
-
-	memcpy(&length, QETH_IPA_PDU_LEN_TOTAL(iob->data), 2);
-	return qeth_osn_send_control_data(card, length, iob);
+	qeth_notify_reply(iob->reply, 0);
+	qeth_release_buffer(channel, iob);
 }
 
 int qeth_osn_assist(struct net_device *dev, void *data, int data_len)
@@ -1090,7 +1060,8 @@ int qeth_osn_assist(struct net_device *dev, void *data, int data_len)
 
 	qeth_prepare_ipa_cmd(card, iob, (u16) data_len);
 	memcpy(__ipa_cmd(iob), data, data_len);
-	return qeth_osn_send_ipa_cmd(card, iob);
+	iob->callback = qeth_osn_assist_cb;
+	return qeth_send_ipa_cmd(card, iob, NULL, NULL);
 }
 EXPORT_SYMBOL(qeth_osn_assist);
 
-- 
2.17.1

