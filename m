Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D593B4135A9
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 16:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233759AbhIUOyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 10:54:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20502 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233798AbhIUOx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 10:53:59 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18LEKFSX037730;
        Tue, 21 Sep 2021 10:52:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=9dL6tQd4tAav7VDRjDMxUg/fUV3+1e2wrD6EQNW8ok8=;
 b=rgfkNtclXHzPTDnOmjkQYswBCOfRUyOQ2azCnWWbdOJ8HKLPynYPIXjTmQlfWQtjWHOO
 f5PKrP3HJu3fXhd7fIKiNBU6mN0OdOnJ6qyoeB4vzVQCWAXlzsj/lGq46+5w6WPpm8ST
 zLzXvqmRNkW34txcnpXXEUcgrfpEnB6clZnhLAss4rCIMwjDXFJ6aeZgSbtscDKQfo2t
 9gRgH91I4Jpci9R6s6sGXWzeVFWKWtHH5GSTeTqiuZJTJQZk5OEmC+JmWv0COC0lUDkT
 ug7hwouhBEa6XCc0Ae6BJ0XjdqkGkHGoDKIJNzCI7t/VvKIm2ZQPofUTER+doom5/2SN gw== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7ek3nd36-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 10:52:27 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18LEqFTd020123;
        Tue, 21 Sep 2021 14:52:25 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3b57r9nc7x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 14:52:25 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18LElYON61473246
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Sep 2021 14:47:34 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88F645205A;
        Tue, 21 Sep 2021 14:52:19 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 388E552071;
        Tue, 21 Sep 2021 14:52:19 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: [PATCH net 2/3] s390/qeth: Fix deadlock in remove_discipline
Date:   Tue, 21 Sep 2021 16:52:16 +0200
Message-Id: <20210921145217.1584654-3-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210921145217.1584654-1-jwi@linux.ibm.com>
References: <20210921145217.1584654-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3C_e2yalCjallge8bfe9v5EjJmOh3vjW
X-Proofpoint-ORIG-GUID: 3C_e2yalCjallge8bfe9v5EjJmOh3vjW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-21_04,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 clxscore=1015 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109210089
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandra Winter <wintera@linux.ibm.com>

Problem: qeth_close_dev_handler is a worker that tries to acquire
card->discipline_mutex via drv->set_offline() in ccwgroup_set_offline().
Since commit b41b554c1ee7
("s390/qeth: fix locking for discipline setup / removal")
qeth_remove_discipline() is called under card->discipline_mutex and
cancels the work and waits for it to finish.

STOPLAN reception with reason code IPA_RC_VEPA_TO_VEB_TRANSITION is the
only situation that schedules close_dev_work. In that situation scheduling
qeth recovery will also result in an offline interface, when resetting the
isolation mode fails, if the external switch is still set to VEB.
And since commit 0b9902c1fcc5 ("s390/qeth: fix deadlock during recovery")
qeth recovery does not aquire card->discipline_mutex anymore.

So we accept the longer pathlength of qeth_schedule_recovery in this
error situation and re-use the existing function.

As a side-benefit this changes the hwtrap to behave like during recovery
instead of like during a user-triggered set_offline.

Fixes: b41b554c1ee7 ("s390/qeth: fix locking for discipline setup / removal")
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Acked-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  1 -
 drivers/s390/net/qeth_core_main.c | 16 ++++------------
 drivers/s390/net/qeth_l2_main.c   |  1 -
 drivers/s390/net/qeth_l3_main.c   |  1 -
 4 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 535a60b3946d..a5aa0bdc61d6 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -858,7 +858,6 @@ struct qeth_card {
 	struct napi_struct napi;
 	struct qeth_rx rx;
 	struct delayed_work buffer_reclaim_work;
-	struct work_struct close_dev_work;
 };
 
 static inline bool qeth_card_hw_is_reachable(struct qeth_card *card)
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 3fba440a0731..9f26706051e5 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -70,15 +70,6 @@ static void qeth_issue_next_read_cb(struct qeth_card *card,
 static int qeth_qdio_establish(struct qeth_card *);
 static void qeth_free_qdio_queues(struct qeth_card *card);
 
-static void qeth_close_dev_handler(struct work_struct *work)
-{
-	struct qeth_card *card;
-
-	card = container_of(work, struct qeth_card, close_dev_work);
-	QETH_CARD_TEXT(card, 2, "cldevhdl");
-	ccwgroup_set_offline(card->gdev);
-}
-
 static const char *qeth_get_cardname(struct qeth_card *card)
 {
 	if (IS_VM_NIC(card)) {
@@ -795,10 +786,12 @@ static struct qeth_ipa_cmd *qeth_check_ipa_data(struct qeth_card *card,
 	case IPA_CMD_STOPLAN:
 		if (cmd->hdr.return_code == IPA_RC_VEPA_TO_VEB_TRANSITION) {
 			dev_err(&card->gdev->dev,
-				"Interface %s is down because the adjacent port is no longer in reflective relay mode\n",
+				"Adjacent port of interface %s is no longer in reflective relay mode, trigger recovery\n",
 				netdev_name(card->dev));
-			schedule_work(&card->close_dev_work);
+			/* Set offline, then probably fail to set online: */
+			qeth_schedule_recovery(card);
 		} else {
+			/* stay online for subsequent STARTLAN */
 			dev_warn(&card->gdev->dev,
 				 "The link for interface %s on CHPID 0x%X failed\n",
 				 netdev_name(card->dev), card->info.chpid);
@@ -1540,7 +1533,6 @@ static void qeth_setup_card(struct qeth_card *card)
 	INIT_LIST_HEAD(&card->ipato.entries);
 	qeth_init_qdio_info(card);
 	INIT_DELAYED_WORK(&card->buffer_reclaim_work, qeth_buffer_reclaim_work);
-	INIT_WORK(&card->close_dev_work, qeth_close_dev_handler);
 	hash_init(card->rx_mode_addrs);
 	hash_init(card->local_addrs4);
 	hash_init(card->local_addrs6);
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 72e84ff9fea5..dc6c00768d91 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -2307,7 +2307,6 @@ static void qeth_l2_remove_device(struct ccwgroup_device *gdev)
 	if (gdev->state == CCWGROUP_ONLINE)
 		qeth_set_offline(card, card->discipline, false);
 
-	cancel_work_sync(&card->close_dev_work);
 	if (card->dev->reg_state == NETREG_REGISTERED) {
 		priv = netdev_priv(card->dev);
 		if (priv->brport_features & BR_LEARNING_SYNC) {
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 3a523e700a5a..6fd3e288f059 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1969,7 +1969,6 @@ static void qeth_l3_remove_device(struct ccwgroup_device *cgdev)
 	if (cgdev->state == CCWGROUP_ONLINE)
 		qeth_set_offline(card, card->discipline, false);
 
-	cancel_work_sync(&card->close_dev_work);
 	if (card->dev->reg_state == NETREG_REGISTERED)
 		unregister_netdev(card->dev);
 
-- 
2.25.1

