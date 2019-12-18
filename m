Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEA9124DCA
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 17:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbfLRQfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 11:35:00 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17798 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727185AbfLRQe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 11:34:59 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBIGYWGG153585
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 11:34:58 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wyq5r1ck9-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 11:34:57 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Wed, 18 Dec 2019 16:34:56 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 18 Dec 2019 16:34:53 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBIGYqZ057344070
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 16:34:52 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1DD0FA404D;
        Wed, 18 Dec 2019 16:34:52 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6415A4051;
        Wed, 18 Dec 2019 16:34:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Dec 2019 16:34:51 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 1/9] s390/qeth: only handle IRQs while device is online
Date:   Wed, 18 Dec 2019 17:34:42 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191218163450.36731-1-jwi@linux.ibm.com>
References: <20191218163450.36731-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19121816-0028-0000-0000-000003C9F645
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121816-0029-0000-0000-0000248D43BA
Message-Id: <20191218163450.36731-2-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_05:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 impostorscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 suspectscore=2 phishscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912180136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A qeth device that's offline should not be receiving any IRQs - all
pending IOs have been terminated, and we avoid starting any new ones.

So rather than immediately registering the IRQ handler when the device
is probed, only register it while the device is online.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 68 ++++++++++++++-----------------
 1 file changed, 31 insertions(+), 37 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index ce7ff1abbef3..3d2374801308 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -972,8 +972,6 @@ static void qeth_irq(struct ccw_device *cdev, unsigned long intparm,
 	/* while we hold the ccwdev lock, this stays valid: */
 	gdev = dev_get_drvdata(&cdev->dev);
 	card = dev_get_drvdata(&gdev->dev);
-	if (!card)
-		return;
 
 	QETH_CARD_TEXT(card, 5, "irq");
 
@@ -1198,31 +1196,6 @@ static void qeth_free_buffer_pool(struct qeth_card *card)
 	}
 }
 
-static void qeth_clean_channel(struct qeth_channel *channel)
-{
-	struct ccw_device *cdev = channel->ccwdev;
-
-	QETH_DBF_TEXT(SETUP, 2, "freech");
-
-	spin_lock_irq(get_ccwdev_lock(cdev));
-	cdev->handler = NULL;
-	spin_unlock_irq(get_ccwdev_lock(cdev));
-}
-
-static void qeth_setup_channel(struct qeth_channel *channel)
-{
-	struct ccw_device *cdev = channel->ccwdev;
-
-	QETH_DBF_TEXT(SETUP, 2, "setupch");
-
-	channel->state = CH_STATE_DOWN;
-	atomic_set(&channel->irq_pending, 0);
-
-	spin_lock_irq(get_ccwdev_lock(cdev));
-	cdev->handler = qeth_irq;
-	spin_unlock_irq(get_ccwdev_lock(cdev));
-}
-
 static int qeth_osa_set_output_queues(struct qeth_card *card, bool single)
 {
 	unsigned int count = single ? 1 : card->dev->num_tx_queues;
@@ -1395,9 +1368,6 @@ static struct qeth_card *qeth_alloc_card(struct ccwgroup_device *gdev)
 	if (!card->read_cmd)
 		goto out_read_cmd;
 
-	qeth_setup_channel(&card->read);
-	qeth_setup_channel(&card->write);
-	qeth_setup_channel(&card->data);
 	card->qeth_service_level.seq_print = qeth_core_sl_print;
 	register_service_level(&card->qeth_service_level);
 	return card;
@@ -1467,12 +1437,38 @@ int qeth_stop_channel(struct qeth_channel *channel)
 			channel->active_cmd);
 		channel->active_cmd = NULL;
 	}
+	cdev->handler = NULL;
 	spin_unlock_irq(get_ccwdev_lock(cdev));
 
 	return rc;
 }
 EXPORT_SYMBOL_GPL(qeth_stop_channel);
 
+static int qeth_start_channel(struct qeth_channel *channel)
+{
+	struct ccw_device *cdev = channel->ccwdev;
+	int rc;
+
+	channel->state = CH_STATE_DOWN;
+	atomic_set(&channel->irq_pending, 0);
+
+	spin_lock_irq(get_ccwdev_lock(cdev));
+	cdev->handler = qeth_irq;
+	spin_unlock_irq(get_ccwdev_lock(cdev));
+
+	rc = ccw_device_set_online(cdev);
+	if (rc)
+		goto err;
+
+	return 0;
+
+err:
+	spin_lock_irq(get_ccwdev_lock(cdev));
+	cdev->handler = NULL;
+	spin_unlock_irq(get_ccwdev_lock(cdev));
+	return rc;
+}
+
 static int qeth_halt_channels(struct qeth_card *card)
 {
 	int rc1 = 0, rc2 = 0, rc3 = 0;
@@ -4706,7 +4702,7 @@ static void qeth_determine_capabilities(struct qeth_card *card)
 	QETH_CARD_TEXT(card, 2, "detcapab");
 	if (!ddev->online) {
 		ddev_offline = 1;
-		rc = ccw_device_set_online(ddev);
+		rc = qeth_start_channel(channel);
 		if (rc) {
 			QETH_CARD_TEXT_(card, 2, "3err%d", rc);
 			goto out;
@@ -4881,9 +4877,6 @@ static int qeth_qdio_establish(struct qeth_card *card)
 static void qeth_core_free_card(struct qeth_card *card)
 {
 	QETH_CARD_TEXT(card, 2, "freecrd");
-	qeth_clean_channel(&card->read);
-	qeth_clean_channel(&card->write);
-	qeth_clean_channel(&card->data);
 	qeth_put_cmd(card->read_cmd);
 	destroy_workqueue(card->event_wq);
 	unregister_service_level(&card->qeth_service_level);
@@ -4946,13 +4939,14 @@ int qeth_core_hardsetup_card(struct qeth_card *card, bool *carrier_ok)
 	qeth_stop_channel(&card->write);
 	qeth_stop_channel(&card->read);
 	qdio_free(CARD_DDEV(card));
-	rc = ccw_device_set_online(CARD_RDEV(card));
+
+	rc = qeth_start_channel(&card->read);
 	if (rc)
 		goto retriable;
-	rc = ccw_device_set_online(CARD_WDEV(card));
+	rc = qeth_start_channel(&card->write);
 	if (rc)
 		goto retriable;
-	rc = ccw_device_set_online(CARD_DDEV(card));
+	rc = qeth_start_channel(&card->data);
 	if (rc)
 		goto retriable;
 retriable:
-- 
2.17.1

