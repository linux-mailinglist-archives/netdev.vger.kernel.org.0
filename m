Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF33E149678
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 16:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725710AbgAYPxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 10:53:21 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32278 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726436AbgAYPxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 10:53:15 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00PFbiq4117174
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 10:53:13 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xrjr2eyft-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 10:53:13 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Sat, 25 Jan 2020 15:53:11 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 25 Jan 2020 15:53:09 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00PFr8qR47513872
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Jan 2020 15:53:08 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 518DC4C040;
        Sat, 25 Jan 2020 15:53:08 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A45D4C046;
        Sat, 25 Jan 2020 15:53:08 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 25 Jan 2020 15:53:07 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 3/5] s390/qeth: consolidate online/offline code
Date:   Sat, 25 Jan 2020 16:53:01 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200125155303.40971-1-jwi@linux.ibm.com>
References: <20200125155303.40971-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20012515-0008-0000-0000-0000034C9C9D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20012515-0009-0000-0000-00004A6D0E6C
Message-Id: <20200125155303.40971-4-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-25_05:2020-01-24,2020-01-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 bulkscore=0 suspectscore=2 spamscore=0 adultscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2001250132
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Large parts of the online/offline code are identical now, and cleaning
up the remaining stuff is easier with a shared core.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |   9 +--
 drivers/s390/net/qeth_core_main.c | 110 ++++++++++++++++++++++++++----
 drivers/s390/net/qeth_l2_main.c   |  85 ++---------------------
 drivers/s390/net/qeth_l3_main.c   |  87 ++---------------------
 4 files changed, 107 insertions(+), 184 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 09d8211fd542..d052a265da1c 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -727,11 +727,10 @@ struct qeth_osn_info {
 
 struct qeth_discipline {
 	const struct device_type *devtype;
-	int (*recover)(void *ptr);
 	int (*setup) (struct ccwgroup_device *);
 	void (*remove) (struct ccwgroup_device *);
-	int (*set_online) (struct ccwgroup_device *);
-	int (*set_offline) (struct ccwgroup_device *);
+	int (*set_online)(struct qeth_card *card);
+	void (*set_offline)(struct qeth_card *card);
 	int (*do_ioctl)(struct net_device *dev, struct ifreq *rq, int cmd);
 	int (*control_event_handler)(struct qeth_card *card,
 					struct qeth_ipa_cmd *cmd);
@@ -987,11 +986,9 @@ struct net_device *qeth_clone_netdev(struct net_device *orig);
 struct qeth_card *qeth_get_card_by_busid(char *bus_id);
 void qeth_set_allowed_threads(struct qeth_card *, unsigned long , int);
 int qeth_threads_running(struct qeth_card *, unsigned long);
-int qeth_do_run_thread(struct qeth_card *, unsigned long);
-void qeth_clear_thread_start_bit(struct qeth_card *, unsigned long);
-void qeth_clear_thread_running_bit(struct qeth_card *, unsigned long);
 int qeth_core_hardsetup_card(struct qeth_card *card, bool *carrier_ok);
 int qeth_stop_channel(struct qeth_channel *channel);
+int qeth_set_offline(struct qeth_card *card, bool resetting);
 
 void qeth_print_status_message(struct qeth_card *);
 int qeth_send_ipa_cmd(struct qeth_card *, struct qeth_cmd_buffer *,
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 52e5f086444b..d66a7433908c 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -823,7 +823,8 @@ static int qeth_set_thread_start_bit(struct qeth_card *card,
 	return 0;
 }
 
-void qeth_clear_thread_start_bit(struct qeth_card *card, unsigned long thread)
+static void qeth_clear_thread_start_bit(struct qeth_card *card,
+					unsigned long thread)
 {
 	unsigned long flags;
 
@@ -832,9 +833,9 @@ void qeth_clear_thread_start_bit(struct qeth_card *card, unsigned long thread)
 	spin_unlock_irqrestore(&card->thread_mask_lock, flags);
 	wake_up(&card->wait_q);
 }
-EXPORT_SYMBOL_GPL(qeth_clear_thread_start_bit);
 
-void qeth_clear_thread_running_bit(struct qeth_card *card, unsigned long thread)
+static void qeth_clear_thread_running_bit(struct qeth_card *card,
+					  unsigned long thread)
 {
 	unsigned long flags;
 
@@ -843,7 +844,6 @@ void qeth_clear_thread_running_bit(struct qeth_card *card, unsigned long thread)
 	spin_unlock_irqrestore(&card->thread_mask_lock, flags);
 	wake_up_all(&card->wait_q);
 }
-EXPORT_SYMBOL_GPL(qeth_clear_thread_running_bit);
 
 static int __qeth_do_run_thread(struct qeth_card *card, unsigned long thread)
 {
@@ -864,7 +864,7 @@ static int __qeth_do_run_thread(struct qeth_card *card, unsigned long thread)
 	return rc;
 }
 
-int qeth_do_run_thread(struct qeth_card *card, unsigned long thread)
+static int qeth_do_run_thread(struct qeth_card *card, unsigned long thread)
 {
 	int rc = 0;
 
@@ -872,7 +872,6 @@ int qeth_do_run_thread(struct qeth_card *card, unsigned long thread)
 		   (rc = __qeth_do_run_thread(card, thread)) >= 0);
 	return rc;
 }
-EXPORT_SYMBOL_GPL(qeth_do_run_thread);
 
 void qeth_schedule_recovery(struct qeth_card *card)
 {
@@ -880,7 +879,6 @@ void qeth_schedule_recovery(struct qeth_card *card)
 	if (qeth_set_thread_start_bit(card, QETH_RECOVER_THREAD) == 0)
 		schedule_work(&card->kernel_thread_starter);
 }
-EXPORT_SYMBOL_GPL(qeth_schedule_recovery);
 
 static int qeth_get_problem(struct qeth_card *card, struct ccw_device *cdev,
 			    struct irb *irb)
@@ -1287,6 +1285,7 @@ static int qeth_do_start_thread(struct qeth_card *card, unsigned long thread)
 	return rc;
 }
 
+static int qeth_do_reset(void *data);
 static void qeth_start_kernel_thread(struct work_struct *work)
 {
 	struct task_struct *ts;
@@ -1298,8 +1297,7 @@ static void qeth_start_kernel_thread(struct work_struct *work)
 	    card->write.state != CH_STATE_UP)
 		return;
 	if (qeth_do_start_thread(card, QETH_RECOVER_THREAD)) {
-		ts = kthread_run(card->discipline->recover, (void *)card,
-				"qeth_recover");
+		ts = kthread_run(qeth_do_reset, card, "qeth_recover");
 		if (IS_ERR(ts)) {
 			qeth_clear_thread_start_bit(card, QETH_RECOVER_THREAD);
 			qeth_clear_thread_running_bit(card,
@@ -3095,7 +3093,6 @@ int qeth_hw_trap(struct qeth_card *card, enum qeth_diags_trap_action action)
 	}
 	return qeth_send_ipa_cmd(card, iob, qeth_hw_trap_cb, NULL);
 }
-EXPORT_SYMBOL_GPL(qeth_hw_trap);
 
 static int qeth_check_qdio_errors(struct qeth_card *card,
 				  struct qdio_buffer *buf,
@@ -5041,6 +5038,89 @@ int qeth_core_hardsetup_card(struct qeth_card *card, bool *carrier_ok)
 }
 EXPORT_SYMBOL_GPL(qeth_core_hardsetup_card);
 
+static int qeth_set_online(struct qeth_card *card)
+{
+	int rc;
+
+	mutex_lock(&card->discipline_mutex);
+	mutex_lock(&card->conf_mutex);
+	QETH_CARD_TEXT(card, 2, "setonlin");
+
+	rc = card->discipline->set_online(card);
+
+	mutex_unlock(&card->conf_mutex);
+	mutex_unlock(&card->discipline_mutex);
+
+	return rc;
+}
+
+int qeth_set_offline(struct qeth_card *card, bool resetting)
+{
+	int rc, rc2, rc3;
+
+	mutex_lock(&card->discipline_mutex);
+	mutex_lock(&card->conf_mutex);
+	QETH_CARD_TEXT(card, 3, "setoffl");
+
+	if ((!resetting && card->info.hwtrap) || card->info.hwtrap == 2) {
+		qeth_hw_trap(card, QETH_DIAGS_TRAP_DISARM);
+		card->info.hwtrap = 1;
+	}
+
+	rtnl_lock();
+	card->info.open_when_online = card->dev->flags & IFF_UP;
+	dev_close(card->dev);
+	netif_device_detach(card->dev);
+	netif_carrier_off(card->dev);
+	rtnl_unlock();
+
+	card->discipline->set_offline(card);
+
+	rc  = qeth_stop_channel(&card->data);
+	rc2 = qeth_stop_channel(&card->write);
+	rc3 = qeth_stop_channel(&card->read);
+	if (!rc)
+		rc = (rc2) ? rc2 : rc3;
+	if (rc)
+		QETH_CARD_TEXT_(card, 2, "1err%d", rc);
+	qdio_free(CARD_DDEV(card));
+
+	/* let user_space know that device is offline */
+	kobject_uevent(&card->gdev->dev.kobj, KOBJ_CHANGE);
+
+	mutex_unlock(&card->conf_mutex);
+	mutex_unlock(&card->discipline_mutex);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(qeth_set_offline);
+
+static int qeth_do_reset(void *data)
+{
+	struct qeth_card *card = data;
+	int rc;
+
+	QETH_CARD_TEXT(card, 2, "recover1");
+	if (!qeth_do_run_thread(card, QETH_RECOVER_THREAD))
+		return 0;
+	QETH_CARD_TEXT(card, 2, "recover2");
+	dev_warn(&card->gdev->dev,
+		 "A recovery process has been started for the device\n");
+
+	qeth_set_offline(card, true);
+	rc = qeth_set_online(card);
+	if (!rc) {
+		dev_info(&card->gdev->dev,
+			 "Device successfully recovered!\n");
+	} else {
+		ccwgroup_set_offline(card->gdev);
+		dev_warn(&card->gdev->dev,
+			 "The qeth device driver failed to recover an error on the device\n");
+	}
+	qeth_clear_thread_start_bit(card, QETH_RECOVER_THREAD);
+	qeth_clear_thread_running_bit(card, QETH_RECOVER_THREAD);
+	return 0;
+}
+
 #if IS_ENABLED(CONFIG_QETH_L3)
 static void qeth_l3_rebuild_skb(struct qeth_card *card, struct sk_buff *skb,
 				struct qeth_hdr *hdr)
@@ -5977,7 +6057,8 @@ static int qeth_core_set_online(struct ccwgroup_device *gdev)
 			goto err;
 		}
 	}
-	rc = card->discipline->set_online(gdev);
+
+	rc = qeth_set_online(card);
 err:
 	return rc;
 }
@@ -5985,7 +6066,8 @@ static int qeth_core_set_online(struct ccwgroup_device *gdev)
 static int qeth_core_set_offline(struct ccwgroup_device *gdev)
 {
 	struct qeth_card *card = dev_get_drvdata(&gdev->dev);
-	return card->discipline->set_offline(gdev);
+
+	return qeth_set_offline(card, false);
 }
 
 static void qeth_core_shutdown(struct ccwgroup_device *gdev)
@@ -6008,7 +6090,7 @@ static int qeth_suspend(struct ccwgroup_device *gdev)
 	if (gdev->state == CCWGROUP_OFFLINE)
 		return 0;
 
-	card->discipline->set_offline(gdev);
+	qeth_set_offline(card, false);
 	return 0;
 }
 
@@ -6017,7 +6099,7 @@ static int qeth_resume(struct ccwgroup_device *gdev)
 	struct qeth_card *card = dev_get_drvdata(&gdev->dev);
 	int rc;
 
-	rc = card->discipline->set_online(gdev);
+	rc = qeth_set_online(card);
 
 	qeth_set_allowed_threads(card, 0xffffffff, 0);
 	if (rc)
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 5d9bb0597465..c36b6c1fc33f 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -24,7 +24,6 @@
 #include "qeth_core.h"
 #include "qeth_l2.h"
 
-static int qeth_l2_set_offline(struct ccwgroup_device *);
 static void qeth_bridgeport_query_support(struct qeth_card *card);
 static void qeth_bridge_state_change(struct qeth_card *card,
 					struct qeth_ipa_cmd *cmd);
@@ -610,7 +609,7 @@ static void qeth_l2_remove_device(struct ccwgroup_device *cgdev)
 	wait_event(card->wait_q, qeth_threads_running(card, 0xffffffff) == 0);
 
 	if (cgdev->state == CCWGROUP_ONLINE)
-		qeth_l2_set_offline(cgdev);
+		qeth_set_offline(card, false);
 
 	cancel_work_sync(&card->close_dev_work);
 	if (qeth_netdev_is_registered(card->dev))
@@ -746,17 +745,13 @@ static void qeth_l2_setup_bridgeport_attrs(struct qeth_card *card)
 	}
 }
 
-static int qeth_l2_set_online(struct ccwgroup_device *gdev)
+static int qeth_l2_set_online(struct qeth_card *card)
 {
-	struct qeth_card *card = dev_get_drvdata(&gdev->dev);
+	struct ccwgroup_device *gdev = card->gdev;
 	struct net_device *dev = card->dev;
 	int rc = 0;
 	bool carrier_ok;
 
-	mutex_lock(&card->discipline_mutex);
-	mutex_lock(&card->conf_mutex);
-	QETH_CARD_TEXT(card, 2, "setonlin");
-
 	rc = qeth_core_hardsetup_card(card, &carrier_ok);
 	if (rc) {
 		QETH_CARD_TEXT_(card, 2, "2err%04x", rc);
@@ -813,8 +808,6 @@ static int qeth_l2_set_online(struct ccwgroup_device *gdev)
 	}
 	/* let user_space know that device is online */
 	kobject_uevent(&gdev->dev.kobj, KOBJ_CHANGE);
-	mutex_unlock(&card->conf_mutex);
-	mutex_unlock(&card->discipline_mutex);
 	return 0;
 
 out_remove:
@@ -823,81 +816,12 @@ static int qeth_l2_set_online(struct ccwgroup_device *gdev)
 	qeth_stop_channel(&card->write);
 	qeth_stop_channel(&card->read);
 	qdio_free(CARD_DDEV(card));
-
-	mutex_unlock(&card->conf_mutex);
-	mutex_unlock(&card->discipline_mutex);
 	return rc;
 }
 
-static int __qeth_l2_set_offline(struct ccwgroup_device *cgdev,
-					int recovery_mode)
+static void qeth_l2_set_offline(struct qeth_card *card)
 {
-	struct qeth_card *card = dev_get_drvdata(&cgdev->dev);
-	int rc = 0, rc2 = 0, rc3 = 0;
-
-	mutex_lock(&card->discipline_mutex);
-	mutex_lock(&card->conf_mutex);
-	QETH_CARD_TEXT(card, 3, "setoffl");
-
-	if ((!recovery_mode && card->info.hwtrap) || card->info.hwtrap == 2) {
-		qeth_hw_trap(card, QETH_DIAGS_TRAP_DISARM);
-		card->info.hwtrap = 1;
-	}
-
-	rtnl_lock();
-	card->info.open_when_online = card->dev->flags & IFF_UP;
-	dev_close(card->dev);
-	netif_device_detach(card->dev);
-	netif_carrier_off(card->dev);
-	rtnl_unlock();
-
 	qeth_l2_stop_card(card);
-	rc  = qeth_stop_channel(&card->data);
-	rc2 = qeth_stop_channel(&card->write);
-	rc3 = qeth_stop_channel(&card->read);
-	if (!rc)
-		rc = (rc2) ? rc2 : rc3;
-	if (rc)
-		QETH_CARD_TEXT_(card, 2, "1err%d", rc);
-	qdio_free(CARD_DDEV(card));
-
-	/* let user_space know that device is offline */
-	kobject_uevent(&cgdev->dev.kobj, KOBJ_CHANGE);
-	mutex_unlock(&card->conf_mutex);
-	mutex_unlock(&card->discipline_mutex);
-	return 0;
-}
-
-static int qeth_l2_set_offline(struct ccwgroup_device *cgdev)
-{
-	return __qeth_l2_set_offline(cgdev, 0);
-}
-
-static int qeth_l2_recover(void *ptr)
-{
-	struct qeth_card *card;
-	int rc = 0;
-
-	card = (struct qeth_card *) ptr;
-	QETH_CARD_TEXT(card, 2, "recover1");
-	if (!qeth_do_run_thread(card, QETH_RECOVER_THREAD))
-		return 0;
-	QETH_CARD_TEXT(card, 2, "recover2");
-	dev_warn(&card->gdev->dev,
-		"A recovery process has been started for the device\n");
-	__qeth_l2_set_offline(card->gdev, 1);
-	rc = qeth_l2_set_online(card->gdev);
-	if (!rc)
-		dev_info(&card->gdev->dev,
-			"Device successfully recovered!\n");
-	else {
-		ccwgroup_set_offline(card->gdev);
-		dev_warn(&card->gdev->dev, "The qeth device driver "
-				"failed to recover an error on the device\n");
-	}
-	qeth_clear_thread_start_bit(card, QETH_RECOVER_THREAD);
-	qeth_clear_thread_running_bit(card, QETH_RECOVER_THREAD);
-	return 0;
 }
 
 static int __init qeth_l2_init(void)
@@ -934,7 +858,6 @@ static int qeth_l2_control_event(struct qeth_card *card,
 
 struct qeth_discipline qeth_l2_discipline = {
 	.devtype = &qeth_l2_devtype,
-	.recover = qeth_l2_recover,
 	.setup = qeth_l2_probe_device,
 	.remove = qeth_l2_remove_device,
 	.set_online = qeth_l2_set_online,
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index ee1bdaaa26f6..eb2d9c427b10 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -37,8 +37,6 @@
 
 #include "qeth_l3.h"
 
-
-static int qeth_l3_set_offline(struct ccwgroup_device *);
 static int qeth_l3_register_addr_entry(struct qeth_card *,
 		struct qeth_ipaddr *);
 static int qeth_l3_deregister_addr_entry(struct qeth_card *,
@@ -2044,7 +2042,7 @@ static void qeth_l3_remove_device(struct ccwgroup_device *cgdev)
 	wait_event(card->wait_q, qeth_threads_running(card, 0xffffffff) == 0);
 
 	if (cgdev->state == CCWGROUP_ONLINE)
-		qeth_l3_set_offline(cgdev);
+		qeth_set_offline(card, false);
 
 	cancel_work_sync(&card->close_dev_work);
 	if (qeth_netdev_is_registered(card->dev))
@@ -2056,17 +2054,13 @@ static void qeth_l3_remove_device(struct ccwgroup_device *cgdev)
 	qeth_l3_clear_ipato_list(card);
 }
 
-static int qeth_l3_set_online(struct ccwgroup_device *gdev)
+static int qeth_l3_set_online(struct qeth_card *card)
 {
-	struct qeth_card *card = dev_get_drvdata(&gdev->dev);
+	struct ccwgroup_device *gdev = card->gdev;
 	struct net_device *dev = card->dev;
 	int rc = 0;
 	bool carrier_ok;
 
-	mutex_lock(&card->discipline_mutex);
-	mutex_lock(&card->conf_mutex);
-	QETH_CARD_TEXT(card, 2, "setonlin");
-
 	rc = qeth_core_hardsetup_card(card, &carrier_ok);
 	if (rc) {
 		QETH_CARD_TEXT_(card, 2, "2err%04x", rc);
@@ -2125,8 +2119,6 @@ static int qeth_l3_set_online(struct ccwgroup_device *gdev)
 	qeth_trace_features(card);
 	/* let user_space know that device is online */
 	kobject_uevent(&gdev->dev.kobj, KOBJ_CHANGE);
-	mutex_unlock(&card->conf_mutex);
-	mutex_unlock(&card->discipline_mutex);
 	return 0;
 out_remove:
 	qeth_l3_stop_card(card);
@@ -2134,82 +2126,12 @@ static int qeth_l3_set_online(struct ccwgroup_device *gdev)
 	qeth_stop_channel(&card->write);
 	qeth_stop_channel(&card->read);
 	qdio_free(CARD_DDEV(card));
-
-	mutex_unlock(&card->conf_mutex);
-	mutex_unlock(&card->discipline_mutex);
 	return rc;
 }
 
-static int __qeth_l3_set_offline(struct ccwgroup_device *cgdev,
-			int recovery_mode)
+static void qeth_l3_set_offline(struct qeth_card *card)
 {
-	struct qeth_card *card = dev_get_drvdata(&cgdev->dev);
-	int rc = 0, rc2 = 0, rc3 = 0;
-
-	mutex_lock(&card->discipline_mutex);
-	mutex_lock(&card->conf_mutex);
-	QETH_CARD_TEXT(card, 3, "setoffl");
-
-	if ((!recovery_mode && card->info.hwtrap) || card->info.hwtrap == 2) {
-		qeth_hw_trap(card, QETH_DIAGS_TRAP_DISARM);
-		card->info.hwtrap = 1;
-	}
-
-	rtnl_lock();
-	card->info.open_when_online = card->dev->flags & IFF_UP;
-	dev_close(card->dev);
-	netif_device_detach(card->dev);
-	netif_carrier_off(card->dev);
-	rtnl_unlock();
-
 	qeth_l3_stop_card(card);
-	rc  = qeth_stop_channel(&card->data);
-	rc2 = qeth_stop_channel(&card->write);
-	rc3 = qeth_stop_channel(&card->read);
-	if (!rc)
-		rc = (rc2) ? rc2 : rc3;
-	if (rc)
-		QETH_CARD_TEXT_(card, 2, "1err%d", rc);
-	qdio_free(CARD_DDEV(card));
-
-	/* let user_space know that device is offline */
-	kobject_uevent(&cgdev->dev.kobj, KOBJ_CHANGE);
-	mutex_unlock(&card->conf_mutex);
-	mutex_unlock(&card->discipline_mutex);
-	return 0;
-}
-
-static int qeth_l3_set_offline(struct ccwgroup_device *cgdev)
-{
-	return __qeth_l3_set_offline(cgdev, 0);
-}
-
-static int qeth_l3_recover(void *ptr)
-{
-	struct qeth_card *card;
-	int rc = 0;
-
-	card = (struct qeth_card *) ptr;
-	QETH_CARD_TEXT(card, 2, "recover1");
-	QETH_CARD_HEX(card, 2, &card, sizeof(void *));
-	if (!qeth_do_run_thread(card, QETH_RECOVER_THREAD))
-		return 0;
-	QETH_CARD_TEXT(card, 2, "recover2");
-	dev_warn(&card->gdev->dev,
-		"A recovery process has been started for the device\n");
-	__qeth_l3_set_offline(card->gdev, 1);
-	rc = qeth_l3_set_online(card->gdev);
-	if (!rc)
-		dev_info(&card->gdev->dev,
-			"Device successfully recovered!\n");
-	else {
-		ccwgroup_set_offline(card->gdev);
-		dev_warn(&card->gdev->dev, "The qeth device driver "
-				"failed to recover an error on the device\n");
-	}
-	qeth_clear_thread_start_bit(card, QETH_RECOVER_THREAD);
-	qeth_clear_thread_running_bit(card, QETH_RECOVER_THREAD);
-	return 0;
 }
 
 /* Returns zero if the command is successfully "consumed" */
@@ -2221,7 +2143,6 @@ static int qeth_l3_control_event(struct qeth_card *card,
 
 struct qeth_discipline qeth_l3_discipline = {
 	.devtype = &qeth_l3_devtype,
-	.recover = qeth_l3_recover,
 	.setup = qeth_l3_probe_device,
 	.remove = qeth_l3_remove_device,
 	.set_online = qeth_l3_set_online,
-- 
2.17.1

