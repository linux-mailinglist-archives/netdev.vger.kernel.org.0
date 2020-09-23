Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB75275361
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 10:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgIWIh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 04:37:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:65256 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726178AbgIWIhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 04:37:14 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08N8XYB2042685;
        Wed, 23 Sep 2020 04:37:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=Ttk7v+NYqE3KC8aI/rxkt1jpx/Uj1dV84egH5SgJcNs=;
 b=TpAV6GAEt+6ae9isnFoRF+5Jlf/HL1HY4C5P6mX792mT8k/znIkAJmFy//LMzskP1Ypf
 yl8KflU/qkvQJgUGDZmqBz5aXAge7SpoIa3q8aZH3anf/g7mOPJqdqvAqqT9//A4ufaD
 X/4dYjyW4hH8C56SfFwrSvWTOXVWLRjbgdqxG07sPhq4pyqw5yIAIyHkTU+opBN5P0th
 SXXBBVZkPTMr2R+BuTld7vyd8srzXLi9ZuydvsvAILsNq+J7temY6pwacWYk3I2xUjEg
 8tR2vWRZAFPsnDgxaT7X0Z2Hen+3T4cRw4cjoPJNZL5uZGZdsgKkNiuzujaRvjEqo6t6 CA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33r27m1j90-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 04:37:10 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08N8afth027640;
        Wed, 23 Sep 2020 08:37:08 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 33n9m8bxfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 08:37:08 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08N8b5r121299540
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 08:37:05 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B9EE11C058;
        Wed, 23 Sep 2020 08:37:05 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 417CB11C050;
        Wed, 23 Sep 2020 08:37:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Sep 2020 08:37:05 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 7/9] s390/qeth: consolidate online code
Date:   Wed, 23 Sep 2020 10:36:58 +0200
Message-Id: <20200923083700.44624-8-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200923083700.44624-1-jwi@linux.ibm.com>
References: <20200923083700.44624-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_03:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=2 malwarescore=0
 mlxscore=0 impostorscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 spamscore=0 priorityscore=1501 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009230069
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move duplicated code from the disciplines into the core path.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  6 +----
 drivers/s390/net/qeth_core_main.c | 41 ++++++++++++++++++++++++-------
 drivers/s390/net/qeth_l2_main.c   | 20 +--------------
 drivers/s390/net/qeth_l3_main.c   | 21 ++--------------
 4 files changed, 36 insertions(+), 52 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 711ab5097bd1..242558bdb5ac 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -753,7 +753,7 @@ struct qeth_discipline {
 	const struct device_type *devtype;
 	int (*setup) (struct ccwgroup_device *);
 	void (*remove) (struct ccwgroup_device *);
-	int (*set_online)(struct qeth_card *card);
+	int (*set_online)(struct qeth_card *card, bool carrier_ok);
 	void (*set_offline)(struct qeth_card *card);
 	int (*do_ioctl)(struct net_device *dev, struct ifreq *rq, int cmd);
 	int (*control_event_handler)(struct qeth_card *card,
@@ -1037,11 +1037,8 @@ struct net_device *qeth_clone_netdev(struct net_device *orig);
 struct qeth_card *qeth_get_card_by_busid(char *bus_id);
 void qeth_set_allowed_threads(struct qeth_card *, unsigned long , int);
 int qeth_threads_running(struct qeth_card *, unsigned long);
-int qeth_core_hardsetup_card(struct qeth_card *card, bool *carrier_ok);
-int qeth_stop_channel(struct qeth_channel *channel);
 int qeth_set_offline(struct qeth_card *card, bool resetting);
 
-void qeth_print_status_message(struct qeth_card *);
 int qeth_send_ipa_cmd(struct qeth_card *, struct qeth_cmd_buffer *,
 		  int (*reply_cb)
 		  (struct qeth_card *, struct qeth_reply *, unsigned long),
@@ -1093,7 +1090,6 @@ int qeth_do_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 void qeth_dbf_longtext(debug_info_t *id, int level, char *text, ...);
 int qeth_configure_cq(struct qeth_card *, enum qeth_cq);
 int qeth_hw_trap(struct qeth_card *, enum qeth_diags_trap_action);
-void qeth_trace_features(struct qeth_card *);
 int qeth_setassparms_cb(struct qeth_card *, struct qeth_reply *, unsigned long);
 int qeth_setup_netdev(struct qeth_card *card);
 int qeth_set_features(struct net_device *, netdev_features_t);
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 286787845cae..5a132241b4dd 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1753,7 +1753,7 @@ static int qeth_halt_channel(struct qeth_card *card,
 	return 0;
 }
 
-int qeth_stop_channel(struct qeth_channel *channel)
+static int qeth_stop_channel(struct qeth_channel *channel)
 {
 	struct ccw_device *cdev = channel->ccwdev;
 	int rc;
@@ -1771,7 +1771,6 @@ int qeth_stop_channel(struct qeth_channel *channel)
 
 	return rc;
 }
-EXPORT_SYMBOL_GPL(qeth_stop_channel);
 
 static int qeth_start_channel(struct qeth_channel *channel)
 {
@@ -2866,7 +2865,7 @@ static int qeth_mpc_initialize(struct qeth_card *card)
 	return 0;
 }
 
-void qeth_print_status_message(struct qeth_card *card)
+static void qeth_print_status_message(struct qeth_card *card)
 {
 	switch (card->info.type) {
 	case QETH_CARD_TYPE_OSD:
@@ -2907,7 +2906,6 @@ void qeth_print_status_message(struct qeth_card *card)
 		 (card->info.mcl_level[0]) ? ")" : "",
 		 qeth_get_cardname_short(card));
 }
-EXPORT_SYMBOL_GPL(qeth_print_status_message);
 
 static void qeth_initialize_working_pool_list(struct qeth_card *card)
 {
@@ -5123,7 +5121,7 @@ static void qeth_core_free_card(struct qeth_card *card)
 	kfree(card);
 }
 
-void qeth_trace_features(struct qeth_card *card)
+static void qeth_trace_features(struct qeth_card *card)
 {
 	QETH_CARD_TEXT(card, 2, "features");
 	QETH_CARD_HEX(card, 2, &card->options.ipa4, sizeof(card->options.ipa4));
@@ -5132,7 +5130,6 @@ void qeth_trace_features(struct qeth_card *card)
 	QETH_CARD_HEX(card, 2, &card->info.diagass_support,
 		      sizeof(card->info.diagass_support));
 }
-EXPORT_SYMBOL_GPL(qeth_trace_features);
 
 static struct ccw_device_id qeth_ids[] = {
 	{CCW_DEVICE_DEVTYPE(0x1731, 0x01, 0x1732, 0x01),
@@ -5163,7 +5160,7 @@ static struct ccw_driver qeth_ccw_driver = {
 	.remove = ccwgroup_remove_ccwdev,
 };
 
-int qeth_core_hardsetup_card(struct qeth_card *card, bool *carrier_ok)
+static int qeth_hardsetup_card(struct qeth_card *card, bool *carrier_ok)
 {
 	int retries = 3;
 	int rc;
@@ -5277,6 +5274,8 @@ int qeth_core_hardsetup_card(struct qeth_card *card, bool *carrier_ok)
 			QETH_CARD_TEXT_(card, 2, "8err%d", rc);
 	}
 
+	qeth_trace_features(card);
+
 	if (!qeth_is_diagass_supported(card, QETH_DIAGS_CMD_TRAP) ||
 	    (card->info.hwtrap && qeth_hw_trap(card, QETH_DIAGS_TRAP_ARM)))
 		card->info.hwtrap = 0;
@@ -5302,21 +5301,45 @@ int qeth_core_hardsetup_card(struct qeth_card *card, bool *carrier_ok)
 			 CARD_DEVID(card), rc);
 	return rc;
 }
-EXPORT_SYMBOL_GPL(qeth_core_hardsetup_card);
 
 static int qeth_set_online(struct qeth_card *card)
 {
+	bool carrier_ok;
 	int rc;
 
 	mutex_lock(&card->discipline_mutex);
 	mutex_lock(&card->conf_mutex);
 	QETH_CARD_TEXT(card, 2, "setonlin");
 
-	rc = card->discipline->set_online(card);
+	rc = qeth_hardsetup_card(card, &carrier_ok);
+	if (rc) {
+		QETH_CARD_TEXT_(card, 2, "2err%04x", rc);
+		rc = -ENODEV;
+		goto err_hardsetup;
+	}
+
+	qeth_print_status_message(card);
+
+	rc = card->discipline->set_online(card, carrier_ok);
+	if (rc)
+		goto err_online;
+
+	/* let user_space know that device is online */
+	kobject_uevent(&card->gdev->dev.kobj, KOBJ_CHANGE);
 
 	mutex_unlock(&card->conf_mutex);
 	mutex_unlock(&card->discipline_mutex);
+	return 0;
+
+err_online:
+err_hardsetup:
+	qeth_stop_channel(&card->data);
+	qeth_stop_channel(&card->write);
+	qeth_stop_channel(&card->read);
+	qdio_free(CARD_DDEV(card));
 
+	mutex_unlock(&card->conf_mutex);
+	mutex_unlock(&card->discipline_mutex);
 	return rc;
 }
 
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index cbd1ab71e785..6e8d5113d435 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -1138,19 +1138,10 @@ static void qeth_l2_enable_brport_features(struct qeth_card *card)
 	}
 }
 
-static int qeth_l2_set_online(struct qeth_card *card)
+static int qeth_l2_set_online(struct qeth_card *card, bool carrier_ok)
 {
-	struct ccwgroup_device *gdev = card->gdev;
 	struct net_device *dev = card->dev;
 	int rc = 0;
-	bool carrier_ok;
-
-	rc = qeth_core_hardsetup_card(card, &carrier_ok);
-	if (rc) {
-		QETH_CARD_TEXT_(card, 2, "2err%04x", rc);
-		rc = -ENODEV;
-		goto out_remove;
-	}
 
 	/* query before bridgeport_notification may be enabled */
 	qeth_l2_detect_dev2br_support(card);
@@ -1169,11 +1160,8 @@ static int qeth_l2_set_online(struct qeth_card *card)
 	/* for the rx_bcast characteristic, init VNICC after setmac */
 	qeth_l2_vnicc_init(card);
 
-	qeth_trace_features(card);
 	qeth_l2_trace_features(card);
 
-	qeth_print_status_message(card);
-
 	/* softsetup */
 	QETH_CARD_TEXT(card, 2, "softsetp");
 
@@ -1205,16 +1193,10 @@ static int qeth_l2_set_online(struct qeth_card *card)
 		}
 		rtnl_unlock();
 	}
-	/* let user_space know that device is online */
-	kobject_uevent(&gdev->dev.kobj, KOBJ_CHANGE);
 	return 0;
 
 out_remove:
 	qeth_l2_stop_card(card);
-	qeth_stop_channel(&card->data);
-	qeth_stop_channel(&card->write);
-	qeth_stop_channel(&card->read);
-	qdio_free(CARD_DDEV(card));
 	return rc;
 }
 
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 410c35ca8f4a..08285af6a5ff 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -2012,21 +2012,10 @@ static void qeth_l3_remove_device(struct ccwgroup_device *cgdev)
 	qeth_l3_clear_ipato_list(card);
 }
 
-static int qeth_l3_set_online(struct qeth_card *card)
+static int qeth_l3_set_online(struct qeth_card *card, bool carrier_ok)
 {
-	struct ccwgroup_device *gdev = card->gdev;
 	struct net_device *dev = card->dev;
 	int rc = 0;
-	bool carrier_ok;
-
-	rc = qeth_core_hardsetup_card(card, &carrier_ok);
-	if (rc) {
-		QETH_CARD_TEXT_(card, 2, "2err%04x", rc);
-		rc = -ENODEV;
-		goto out_remove;
-	}
-
-	qeth_print_status_message(card);
 
 	/* softsetup */
 	QETH_CARD_TEXT(card, 2, "softsetp");
@@ -2073,16 +2062,10 @@ static int qeth_l3_set_online(struct qeth_card *card)
 		}
 		rtnl_unlock();
 	}
-	qeth_trace_features(card);
-	/* let user_space know that device is online */
-	kobject_uevent(&gdev->dev.kobj, KOBJ_CHANGE);
 	return 0;
+
 out_remove:
 	qeth_l3_stop_card(card);
-	qeth_stop_channel(&card->data);
-	qeth_stop_channel(&card->write);
-	qeth_stop_channel(&card->read);
-	qdio_free(CARD_DDEV(card));
 	return rc;
 }
 
-- 
2.17.1

