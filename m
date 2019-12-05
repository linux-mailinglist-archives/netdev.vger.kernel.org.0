Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78F30114185
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 14:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729526AbfLENd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 08:33:26 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30890 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729489AbfLENdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 08:33:25 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB5DTeAR042743
        for <netdev@vger.kernel.org>; Thu, 5 Dec 2019 08:33:23 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wq2tug7wg-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 08:33:23 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 5 Dec 2019 13:33:22 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 5 Dec 2019 13:33:20 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xB5DXJ4822020280
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Dec 2019 13:33:19 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E990411C04A;
        Thu,  5 Dec 2019 13:33:18 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A39BF11C04C;
        Thu,  5 Dec 2019 13:33:18 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  5 Dec 2019 13:33:18 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 3/3] s390/qeth: fix dangling IO buffers after halt/clear
Date:   Thu,  5 Dec 2019 14:33:04 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191205133304.58895-1-jwi@linux.ibm.com>
References: <20191205133304.58895-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19120513-0008-0000-0000-0000033D9DD6
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19120513-0009-0000-0000-00004A5CC118
Message-Id: <20191205133304.58895-4-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-05_03:2019-12-04,2019-12-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 impostorscore=0
 phishscore=0 spamscore=0 suspectscore=2 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1912050113
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cio layer's intparm logic does not align itself well with how qeth
manages cmd IOs. When an active IO gets terminated via halt/clear, the
corresponding IRQ's intparm does not reflect the cmd buffer but rather
the intparm that was passed to ccw_device_halt() / ccw_device_clear().
This behaviour was recently clarified in
commit b91d9e67e50b ("s390/cio: fix intparm documentation").

As a result, qeth_irq() currently doesn't cancel a cmd that was
terminated via halt/clear. This primarily causes us to leak
card->read_cmd after the qeth device is removed, since our IO path still
holds a refcount for this cmd.

For qeth this means that we need to keep track of which IO is pending on
a device ('active_cmd'), and use this as the intparm when calling
halt/clear. Otherwise qeth_irq() can't match the subsequent IRQ to its
cmd buffer.
Since we now keep track of the _expected_ intparm, we can also detect
any mismatch; this would constitute a bug somewhere in the lower layers.
In this case cancel the active cmd - we effectively "lost" the IRQ and
should not expect any further notification for this IO.

Fixes: 405548959cc7 ("s390/qeth: add support for dynamically allocated cmds")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  3 ++
 drivers/s390/net/qeth_core_main.c | 71 ++++++++++++++++++++++---------
 drivers/s390/net/qeth_core_mpc.h  | 14 ------
 drivers/s390/net/qeth_l2_main.c   | 12 +++---
 drivers/s390/net/qeth_l3_main.c   | 13 +++---
 5 files changed, 67 insertions(+), 46 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 7cdebd2e329f..871d44746f5c 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -628,6 +628,7 @@ struct qeth_ipato {
 
 struct qeth_channel {
 	struct ccw_device *ccwdev;
+	struct qeth_cmd_buffer *active_cmd;
 	enum qeth_channel_states state;
 	atomic_t irq_pending;
 };
@@ -1038,6 +1039,8 @@ int qeth_do_run_thread(struct qeth_card *, unsigned long);
 void qeth_clear_thread_start_bit(struct qeth_card *, unsigned long);
 void qeth_clear_thread_running_bit(struct qeth_card *, unsigned long);
 int qeth_core_hardsetup_card(struct qeth_card *card, bool *carrier_ok);
+int qeth_stop_channel(struct qeth_channel *channel);
+
 void qeth_print_status_message(struct qeth_card *);
 int qeth_init_qdio_queues(struct qeth_card *);
 int qeth_send_ipa_cmd(struct qeth_card *, struct qeth_cmd_buffer *,
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 634913112441..b9a2349e4b90 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -515,7 +515,9 @@ static int __qeth_issue_next_read(struct qeth_card *card)
 
 	QETH_CARD_TEXT(card, 6, "noirqpnd");
 	rc = ccw_device_start(channel->ccwdev, ccw, (addr_t) iob, 0, 0);
-	if (rc) {
+	if (!rc) {
+		channel->active_cmd = iob;
+	} else {
 		QETH_DBF_MESSAGE(2, "error %i on device %x when starting next read ccw!\n",
 				 rc, CARD_DEVID(card));
 		atomic_set(&channel->irq_pending, 0);
@@ -986,8 +988,21 @@ static void qeth_irq(struct ccw_device *cdev, unsigned long intparm,
 		QETH_CARD_TEXT(card, 5, "data");
 	}
 
-	if (qeth_intparm_is_iob(intparm))
-		iob = (struct qeth_cmd_buffer *) __va((addr_t)intparm);
+	if (intparm == 0) {
+		QETH_CARD_TEXT(card, 5, "irqunsol");
+	} else if ((addr_t)intparm != (addr_t)channel->active_cmd) {
+		QETH_CARD_TEXT(card, 5, "irqunexp");
+
+		dev_err(&cdev->dev,
+			"Received IRQ with intparm %lx, expected %px\n",
+			intparm, channel->active_cmd);
+		if (channel->active_cmd)
+			qeth_cancel_cmd(channel->active_cmd, -EIO);
+	} else {
+		iob = (struct qeth_cmd_buffer *) (addr_t)intparm;
+	}
+
+	channel->active_cmd = NULL;
 
 	rc = qeth_check_irb_error(card, cdev, irb);
 	if (rc) {
@@ -1007,15 +1022,10 @@ static void qeth_irq(struct ccw_device *cdev, unsigned long intparm,
 	if (irb->scsw.cmd.fctl & (SCSW_FCTL_HALT_FUNC))
 		channel->state = CH_STATE_HALTED;
 
-	if (intparm == QETH_CLEAR_CHANNEL_PARM) {
-		QETH_CARD_TEXT(card, 6, "clrchpar");
-		/* we don't have to handle this further */
-		intparm = 0;
-	}
-	if (intparm == QETH_HALT_CHANNEL_PARM) {
-		QETH_CARD_TEXT(card, 6, "hltchpar");
-		/* we don't have to handle this further */
-		intparm = 0;
+	if (iob && (irb->scsw.cmd.fctl & (SCSW_FCTL_CLEAR_FUNC |
+					  SCSW_FCTL_HALT_FUNC))) {
+		qeth_cancel_cmd(iob, -ECANCELED);
+		iob = NULL;
 	}
 
 	cstat = irb->scsw.cmd.cstat;
@@ -1408,7 +1418,7 @@ static int qeth_clear_channel(struct qeth_card *card,
 
 	QETH_CARD_TEXT(card, 3, "clearch");
 	spin_lock_irq(get_ccwdev_lock(channel->ccwdev));
-	rc = ccw_device_clear(channel->ccwdev, QETH_CLEAR_CHANNEL_PARM);
+	rc = ccw_device_clear(channel->ccwdev, (addr_t)channel->active_cmd);
 	spin_unlock_irq(get_ccwdev_lock(channel->ccwdev));
 
 	if (rc)
@@ -1430,7 +1440,7 @@ static int qeth_halt_channel(struct qeth_card *card,
 
 	QETH_CARD_TEXT(card, 3, "haltch");
 	spin_lock_irq(get_ccwdev_lock(channel->ccwdev));
-	rc = ccw_device_halt(channel->ccwdev, QETH_HALT_CHANNEL_PARM);
+	rc = ccw_device_halt(channel->ccwdev, (addr_t)channel->active_cmd);
 	spin_unlock_irq(get_ccwdev_lock(channel->ccwdev));
 
 	if (rc)
@@ -1444,6 +1454,25 @@ static int qeth_halt_channel(struct qeth_card *card,
 	return 0;
 }
 
+int qeth_stop_channel(struct qeth_channel *channel)
+{
+	struct ccw_device *cdev = channel->ccwdev;
+	int rc;
+
+	rc = ccw_device_set_offline(cdev);
+
+	spin_lock_irq(get_ccwdev_lock(cdev));
+	if (channel->active_cmd) {
+		dev_err(&cdev->dev, "Stopped channel while cmd %px was still active\n",
+			channel->active_cmd);
+		channel->active_cmd = NULL;
+	}
+	spin_unlock_irq(get_ccwdev_lock(cdev));
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(qeth_stop_channel);
+
 static int qeth_halt_channels(struct qeth_card *card)
 {
 	int rc1 = 0, rc2 = 0, rc3 = 0;
@@ -1746,6 +1775,8 @@ static int qeth_send_control_data(struct qeth_card *card,
 	spin_lock_irq(get_ccwdev_lock(channel->ccwdev));
 	rc = ccw_device_start_timeout(channel->ccwdev, __ccw_from_cmd(iob),
 				      (addr_t) iob, 0, 0, timeout);
+	if (!rc)
+		channel->active_cmd = iob;
 	spin_unlock_irq(get_ccwdev_lock(channel->ccwdev));
 	if (rc) {
 		QETH_DBF_MESSAGE(2, "qeth_send_control_data on device %x: ccw_device_start rc = %i\n",
@@ -4667,12 +4698,12 @@ EXPORT_SYMBOL_GPL(qeth_vm_request_mac);
 
 static void qeth_determine_capabilities(struct qeth_card *card)
 {
+	struct qeth_channel *channel = &card->data;
+	struct ccw_device *ddev = channel->ccwdev;
 	int rc;
-	struct ccw_device *ddev;
 	int ddev_offline = 0;
 
 	QETH_CARD_TEXT(card, 2, "detcapab");
-	ddev = CARD_DDEV(card);
 	if (!ddev->online) {
 		ddev_offline = 1;
 		rc = ccw_device_set_online(ddev);
@@ -4711,7 +4742,7 @@ static void qeth_determine_capabilities(struct qeth_card *card)
 
 out_offline:
 	if (ddev_offline == 1)
-		ccw_device_set_offline(ddev);
+		qeth_stop_channel(channel);
 out:
 	return;
 }
@@ -4911,9 +4942,9 @@ int qeth_core_hardsetup_card(struct qeth_card *card, bool *carrier_ok)
 		QETH_DBF_MESSAGE(2, "Retrying to do IDX activates on device %x.\n",
 				 CARD_DEVID(card));
 	rc = qeth_qdio_clear_card(card, !IS_IQD(card));
-	ccw_device_set_offline(CARD_DDEV(card));
-	ccw_device_set_offline(CARD_WDEV(card));
-	ccw_device_set_offline(CARD_RDEV(card));
+	qeth_stop_channel(&card->data);
+	qeth_stop_channel(&card->write);
+	qeth_stop_channel(&card->read);
 	qdio_free(CARD_DDEV(card));
 	rc = ccw_device_set_online(CARD_RDEV(card));
 	if (rc)
diff --git a/drivers/s390/net/qeth_core_mpc.h b/drivers/s390/net/qeth_core_mpc.h
index 53fcf6641154..88f4dc140751 100644
--- a/drivers/s390/net/qeth_core_mpc.h
+++ b/drivers/s390/net/qeth_core_mpc.h
@@ -29,20 +29,6 @@ extern unsigned char IPA_PDU_HEADER[];
 #define QETH_TIMEOUT		(10 * HZ)
 #define QETH_IPA_TIMEOUT	(45 * HZ)
 
-#define QETH_CLEAR_CHANNEL_PARM	-10
-#define QETH_HALT_CHANNEL_PARM	-11
-
-static inline bool qeth_intparm_is_iob(unsigned long intparm)
-{
-	switch (intparm) {
-	case QETH_CLEAR_CHANNEL_PARM:
-	case QETH_HALT_CHANNEL_PARM:
-	case 0:
-		return false;
-	}
-	return true;
-}
-
 /*****************************************************************************/
 /* IP Assist related definitions                                             */
 /*****************************************************************************/
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 989935d67b31..9086bc04fa6b 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -845,9 +845,9 @@ static int qeth_l2_set_online(struct ccwgroup_device *gdev)
 
 out_remove:
 	qeth_l2_stop_card(card);
-	ccw_device_set_offline(CARD_DDEV(card));
-	ccw_device_set_offline(CARD_WDEV(card));
-	ccw_device_set_offline(CARD_RDEV(card));
+	qeth_stop_channel(&card->data);
+	qeth_stop_channel(&card->write);
+	qeth_stop_channel(&card->read);
 	qdio_free(CARD_DDEV(card));
 
 	mutex_unlock(&card->conf_mutex);
@@ -878,9 +878,9 @@ static int __qeth_l2_set_offline(struct ccwgroup_device *cgdev,
 	rtnl_unlock();
 
 	qeth_l2_stop_card(card);
-	rc  = ccw_device_set_offline(CARD_DDEV(card));
-	rc2 = ccw_device_set_offline(CARD_WDEV(card));
-	rc3 = ccw_device_set_offline(CARD_RDEV(card));
+	rc  = qeth_stop_channel(&card->data);
+	rc2 = qeth_stop_channel(&card->write);
+	rc3 = qeth_stop_channel(&card->read);
 	if (!rc)
 		rc = (rc2) ? rc2 : rc3;
 	if (rc)
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index e7ce73b9f016..27126330a4b0 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -2259,9 +2259,9 @@ static int qeth_l3_set_online(struct ccwgroup_device *gdev)
 	return 0;
 out_remove:
 	qeth_l3_stop_card(card);
-	ccw_device_set_offline(CARD_DDEV(card));
-	ccw_device_set_offline(CARD_WDEV(card));
-	ccw_device_set_offline(CARD_RDEV(card));
+	qeth_stop_channel(&card->data);
+	qeth_stop_channel(&card->write);
+	qeth_stop_channel(&card->read);
 	qdio_free(CARD_DDEV(card));
 
 	mutex_unlock(&card->conf_mutex);
@@ -2297,9 +2297,10 @@ static int __qeth_l3_set_offline(struct ccwgroup_device *cgdev,
 		call_netdevice_notifiers(NETDEV_REBOOT, card->dev);
 		rtnl_unlock();
 	}
-	rc  = ccw_device_set_offline(CARD_DDEV(card));
-	rc2 = ccw_device_set_offline(CARD_WDEV(card));
-	rc3 = ccw_device_set_offline(CARD_RDEV(card));
+
+	rc  = qeth_stop_channel(&card->data);
+	rc2 = qeth_stop_channel(&card->write);
+	rc3 = qeth_stop_channel(&card->read);
 	if (!rc)
 		rc = (rc2) ? rc2 : rc3;
 	if (rc)
-- 
2.17.1

