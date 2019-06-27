Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE42B58510
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 17:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfF0PBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 11:01:50 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49534 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726786AbfF0PBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 11:01:50 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5REwQgN078314
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 11:01:49 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tcyf9jju7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 11:01:47 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 27 Jun 2019 16:01:41 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 27 Jun 2019 16:01:39 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5RF1ci547513672
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 15:01:38 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46244A4062;
        Thu, 27 Jun 2019 15:01:38 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D46CA406A;
        Thu, 27 Jun 2019 15:01:38 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Jun 2019 15:01:37 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 09/12] s390/qeth: consolidate pm code
Date:   Thu, 27 Jun 2019 17:01:30 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190627150133.58746-1-jwi@linux.ibm.com>
References: <20190627150133.58746-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19062715-0008-0000-0000-000002F7B602
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062715-0009-0000-0000-00002264EFAF
Message-Id: <20190627150133.58746-10-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-27_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=711 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906270175
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

De-duplicate the pm callback implementations from the two sub-drivers,
replacing them with core helpers that delegate to the .set_online and
.set_offline callbacks.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  3 ---
 drivers/s390/net/qeth_core_main.c | 36 ++++++++++++++++---------------
 drivers/s390/net/qeth_l2_main.c   | 30 --------------------------
 drivers/s390/net/qeth_l3_main.c   | 30 --------------------------
 4 files changed, 19 insertions(+), 80 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 715bff28d48e..c81d5ec26803 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -713,9 +713,6 @@ struct qeth_discipline {
 	void (*remove) (struct ccwgroup_device *);
 	int (*set_online) (struct ccwgroup_device *);
 	int (*set_offline) (struct ccwgroup_device *);
-	int (*freeze)(struct ccwgroup_device *);
-	int (*thaw) (struct ccwgroup_device *);
-	int (*restore)(struct ccwgroup_device *);
 	int (*do_ioctl)(struct net_device *dev, struct ifreq *rq, int cmd);
 	int (*control_event_handler)(struct qeth_card *card,
 					struct qeth_ipa_cmd *cmd);
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index efb9a27b916e..3011cae00391 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -5589,28 +5589,30 @@ static void qeth_core_shutdown(struct ccwgroup_device *gdev)
 	qdio_free(CARD_DDEV(card));
 }
 
-static int qeth_core_freeze(struct ccwgroup_device *gdev)
+static int qeth_suspend(struct ccwgroup_device *gdev)
 {
 	struct qeth_card *card = dev_get_drvdata(&gdev->dev);
-	if (card->discipline && card->discipline->freeze)
-		return card->discipline->freeze(gdev);
-	return 0;
-}
 
-static int qeth_core_thaw(struct ccwgroup_device *gdev)
-{
-	struct qeth_card *card = dev_get_drvdata(&gdev->dev);
-	if (card->discipline && card->discipline->thaw)
-		return card->discipline->thaw(gdev);
+	qeth_set_allowed_threads(card, 0, 1);
+	wait_event(card->wait_q, qeth_threads_running(card, 0xffffffff) == 0);
+	if (gdev->state == CCWGROUP_OFFLINE)
+		return 0;
+
+	card->discipline->set_offline(gdev);
 	return 0;
 }
 
-static int qeth_core_restore(struct ccwgroup_device *gdev)
+static int qeth_resume(struct ccwgroup_device *gdev)
 {
 	struct qeth_card *card = dev_get_drvdata(&gdev->dev);
-	if (card->discipline && card->discipline->restore)
-		return card->discipline->restore(gdev);
-	return 0;
+	int rc;
+
+	rc = card->discipline->set_online(gdev);
+
+	qeth_set_allowed_threads(card, 0xffffffff, 0);
+	if (rc)
+		dev_warn(&card->gdev->dev, "The qeth device driver failed to recover an error on the device\n");
+	return rc;
 }
 
 static ssize_t group_store(struct device_driver *ddrv, const char *buf,
@@ -5651,9 +5653,9 @@ static struct ccwgroup_driver qeth_core_ccwgroup_driver = {
 	.shutdown = qeth_core_shutdown,
 	.prepare = NULL,
 	.complete = NULL,
-	.freeze = qeth_core_freeze,
-	.thaw = qeth_core_thaw,
-	.restore = qeth_core_restore,
+	.freeze = qeth_suspend,
+	.thaw = qeth_resume,
+	.restore = qeth_resume,
 };
 
 struct qeth_card *qeth_get_card_by_busid(char *bus_id)
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 03e1cd4a282a..4a2ff9d8aa5f 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -965,33 +965,6 @@ static void __exit qeth_l2_exit(void)
 	pr_info("unregister layer 2 discipline\n");
 }
 
-static int qeth_l2_pm_suspend(struct ccwgroup_device *gdev)
-{
-	struct qeth_card *card = dev_get_drvdata(&gdev->dev);
-
-	qeth_set_allowed_threads(card, 0, 1);
-	wait_event(card->wait_q, qeth_threads_running(card, 0xffffffff) == 0);
-	if (gdev->state == CCWGROUP_OFFLINE)
-		return 0;
-
-	qeth_l2_set_offline(gdev);
-	return 0;
-}
-
-static int qeth_l2_pm_resume(struct ccwgroup_device *gdev)
-{
-	struct qeth_card *card = dev_get_drvdata(&gdev->dev);
-	int rc;
-
-	rc = qeth_l2_set_online(gdev);
-
-	qeth_set_allowed_threads(card, 0xffffffff, 0);
-	if (rc)
-		dev_warn(&card->gdev->dev, "The qeth device driver "
-			"failed to recover an error on the device\n");
-	return rc;
-}
-
 /* Returns zero if the command is successfully "consumed" */
 static int qeth_l2_control_event(struct qeth_card *card,
 					struct qeth_ipa_cmd *cmd)
@@ -1021,9 +994,6 @@ struct qeth_discipline qeth_l2_discipline = {
 	.remove = qeth_l2_remove_device,
 	.set_online = qeth_l2_set_online,
 	.set_offline = qeth_l2_set_offline,
-	.freeze = qeth_l2_pm_suspend,
-	.thaw = qeth_l2_pm_resume,
-	.restore = qeth_l2_pm_resume,
 	.do_ioctl = NULL,
 	.control_event_handler = qeth_l2_control_event,
 };
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index c36f368336a0..44a602aa12ec 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -2500,33 +2500,6 @@ static int qeth_l3_recover(void *ptr)
 	return 0;
 }
 
-static int qeth_l3_pm_suspend(struct ccwgroup_device *gdev)
-{
-	struct qeth_card *card = dev_get_drvdata(&gdev->dev);
-
-	qeth_set_allowed_threads(card, 0, 1);
-	wait_event(card->wait_q, qeth_threads_running(card, 0xffffffff) == 0);
-	if (gdev->state == CCWGROUP_OFFLINE)
-		return 0;
-
-	qeth_l3_set_offline(gdev);
-	return 0;
-}
-
-static int qeth_l3_pm_resume(struct ccwgroup_device *gdev)
-{
-	struct qeth_card *card = dev_get_drvdata(&gdev->dev);
-	int rc;
-
-	rc = qeth_l3_set_online(gdev);
-
-	qeth_set_allowed_threads(card, 0xffffffff, 0);
-	if (rc)
-		dev_warn(&card->gdev->dev, "The qeth device driver "
-			"failed to recover an error on the device\n");
-	return rc;
-}
-
 /* Returns zero if the command is successfully "consumed" */
 static int qeth_l3_control_event(struct qeth_card *card,
 					struct qeth_ipa_cmd *cmd)
@@ -2542,9 +2515,6 @@ struct qeth_discipline qeth_l3_discipline = {
 	.remove = qeth_l3_remove_device,
 	.set_online = qeth_l3_set_online,
 	.set_offline = qeth_l3_set_offline,
-	.freeze = qeth_l3_pm_suspend,
-	.thaw = qeth_l3_pm_resume,
-	.restore = qeth_l3_pm_resume,
 	.do_ioctl = qeth_l3_do_ioctl,
 	.control_event_handler = qeth_l3_control_event,
 };
-- 
2.17.1

