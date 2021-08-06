Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67C43E2DC2
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 17:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244725AbhHFP0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 11:26:38 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14816 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S244452AbhHFP0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 11:26:33 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 176F4lag167582;
        Fri, 6 Aug 2021 11:26:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=MI8mT2kh4usQl/dWdL+e1W4hz+3NyDfISOaGrdMu1n4=;
 b=Upi/AyslclXzm0cb4RcUqXrMdiZhQ8FibeK81wRBYcwrcCTtdvkyvrTPj/nUHVWrExLC
 FrIUCh2xnFoL4VHaEDAfCCuzZArSAZbn8iMtAKJGbvM6B7DCnFointmrqiMc7D1qTUGz
 ET3MnXAxkKm+xGO4bl5ysHH4rPur9zXff9PPKcOGA2FcPikNIWb90jzfXhYy6Siw2yIL
 QKYWOps+M8Z7CapEiJG/8neBVpclcumr3g7UxsgA2tbpfeEg8ExK2wTG5SUsDpO1B86R
 SwlHYlI6xoG4WuPDG3lVnBjSpJY+RHbDnEn/i45SHXwqDOedC3mqNNT1YcxNu/M8gsiZ SA== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a891b5na7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Aug 2021 11:26:12 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 176FMXG1028019;
        Fri, 6 Aug 2021 15:26:10 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3a4x58uxjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Aug 2021 15:26:10 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 176FQ78b48300388
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Aug 2021 15:26:07 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EDBE3A405B;
        Fri,  6 Aug 2021 15:26:06 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B725A405C;
        Fri,  6 Aug 2021 15:26:06 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 Aug 2021 15:26:06 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Guvenc Gulce <guvenc@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: [PATCH net-next 2/3] s390/qeth: Switchdev event handler
Date:   Fri,  6 Aug 2021 17:26:02 +0200
Message-Id: <20210806152603.375642-3-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210806152603.375642-1-kgraul@linux.ibm.com>
References: <20210806152603.375642-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0D8oy4u6YeeVV27Q4Bwad2Cu74GIxto7
X-Proofpoint-GUID: 0D8oy4u6YeeVV27Q4Bwad2Cu74GIxto7
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-06_05:2021-08-05,2021-08-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 clxscore=1015 phishscore=0 spamscore=0
 suspectscore=0 priorityscore=1501 adultscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108060104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandra Winter <wintera@linux.ibm.com>

QETH HiperSockets devices with LEARNING_SYNC capability can be used
to construct a linux bridge with:
2 isolated southbound interfaces:
     a) a default network interface
     b) a LEARNING-SYNC HiperSockets interface
and 1 non-isolated northbound interface. This is called a 'HiperSockets
Converged Interface' (HSCI).
The existing LEARNING_SYNC functionality is used to update the bridge fdb
with MAC addresses that should be sent-out via the HiperSockets interface,
instead of the default network interface.

Add handling of switchdev events SWITCHDEV_FDB_ADD_TO_DEVICE and
SWITCHDEV_FDB_DEL_TO_DEVICE to the qeth LEARNING_SYNC functionality. Thus
if the northbound bridgeport of an HSCI doesn't only have a single static
MAC address, but instead is a learning bridgeport, work is enqueued, so
the HiperSockets virtual switch (that is external to this Linux instance)
can update its fdb.

When BRIDGE is a loadable module, QETH_L2 mustn't be built-in:

drivers/s390/net/qeth_l2_main.o: in function 'qeth_l2_switchdev_event':
drivers/s390/net/qeth_l2_main.c:927: undefined reference to
'br_port_flag_is_set'

Add Kconfig dependency to enforce usable configurations.

Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 drivers/s390/net/Kconfig        |  1 +
 drivers/s390/net/qeth_l2_main.c | 83 +++++++++++++++++++++++++++++++--
 2 files changed, 79 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/net/Kconfig b/drivers/s390/net/Kconfig
index cff91b4f1a76..9c67b97faba2 100644
--- a/drivers/s390/net/Kconfig
+++ b/drivers/s390/net/Kconfig
@@ -74,6 +74,7 @@ config QETH_L2
 	def_tristate y
 	prompt "qeth layer 2 device support"
 	depends on QETH
+	depends on BRIDGE || BRIDGE=n
 	help
 	  Select this option to be able to run qeth devices in layer 2 mode.
 	  To compile as a module, choose M. The module name is qeth_l2.
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 3d02d35df5d3..e38a1befce3f 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -717,15 +717,79 @@ static int qeth_l2_dev2br_an_set(struct qeth_card *card, bool enable)
 	return rc;
 }
 
+static const struct net_device_ops qeth_l2_netdev_ops;
+
+static bool qeth_l2_must_learn(struct net_device *netdev,
+			       struct net_device *dstdev)
+{
+	struct qeth_priv *priv;
+
+	priv = netdev_priv(netdev);
+	return (netdev != dstdev &&
+		(priv->brport_features & BR_LEARNING_SYNC) &&
+		!(br_port_flag_is_set(netdev, BR_ISOLATED) &&
+		  br_port_flag_is_set(dstdev, BR_ISOLATED)) &&
+		netdev->netdev_ops == &qeth_l2_netdev_ops);
+}
+
+/* Called under rtnl_lock */
+static int qeth_l2_switchdev_event(struct notifier_block *unused,
+				   unsigned long event, void *ptr)
+{
+	struct net_device *dstdev, *brdev, *lowerdev;
+	struct switchdev_notifier_fdb_info *fdb_info;
+	struct switchdev_notifier_info *info = ptr;
+	struct list_head *iter;
+	struct qeth_card *card;
+
+	if (!(event == SWITCHDEV_FDB_ADD_TO_DEVICE ||
+	      event == SWITCHDEV_FDB_DEL_TO_DEVICE))
+		return NOTIFY_DONE;
+
+	dstdev = switchdev_notifier_info_to_dev(info);
+	brdev = netdev_master_upper_dev_get_rcu(dstdev);
+	if (!brdev || !netif_is_bridge_master(brdev))
+		return NOTIFY_DONE;
+	fdb_info = container_of(info,
+				struct switchdev_notifier_fdb_info,
+				info);
+	iter = &brdev->adj_list.lower;
+	lowerdev = netdev_next_lower_dev_rcu(brdev, &iter);
+	while (lowerdev) {
+		if (qeth_l2_must_learn(lowerdev, dstdev)) {
+			card = lowerdev->ml_priv;
+			QETH_CARD_TEXT_(card, 4, "b2dqw%03x", event);
+			/* tbd: rc = qeth_l2_br2dev_queue_work(brdev, lowerdev,
+			 *				       dstdev, event,
+			 *				       fdb_info->addr);
+			 */
+		}
+		lowerdev = netdev_next_lower_dev_rcu(brdev, &iter);
+	}
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block qeth_l2_sw_notifier = {
+		.notifier_call = qeth_l2_switchdev_event,
+};
+
 static refcount_t qeth_l2_switchdev_notify_refcnt;
 
 /* Called under rtnl_lock */
 static void qeth_l2_br2dev_get(void)
 {
+	int rc;
+
 	if (!refcount_inc_not_zero(&qeth_l2_switchdev_notify_refcnt)) {
-		/* tbd: register_switchdev_notifier(&qeth_l2_sw_notifier); */
-		refcount_set(&qeth_l2_switchdev_notify_refcnt, 1);
-		QETH_DBF_MESSAGE(2, "qeth_l2_sw_notifier registered\n");
+		rc = register_switchdev_notifier(&qeth_l2_sw_notifier);
+		if (rc) {
+			QETH_DBF_MESSAGE(2,
+					 "failed to register qeth_l2_sw_notifier: %d\n",
+					 rc);
+		} else {
+			refcount_set(&qeth_l2_switchdev_notify_refcnt, 1);
+			QETH_DBF_MESSAGE(2, "qeth_l2_sw_notifier registered\n");
+		}
 	}
 	QETH_DBF_TEXT_(SETUP, 2, "b2d+%04d",
 		       qeth_l2_switchdev_notify_refcnt.refs.counter);
@@ -734,9 +798,18 @@ static void qeth_l2_br2dev_get(void)
 /* Called under rtnl_lock */
 static void qeth_l2_br2dev_put(void)
 {
+	int rc;
+
 	if (refcount_dec_and_test(&qeth_l2_switchdev_notify_refcnt)) {
-		/* tbd: unregister_switchdev_notifier(&qeth_l2_sw_notifier); */
-		QETH_DBF_MESSAGE(2, "qeth_l2_sw_notifier unregistered\n");
+		rc = unregister_switchdev_notifier(&qeth_l2_sw_notifier);
+		if (rc) {
+			QETH_DBF_MESSAGE(2,
+					 "failed to unregister qeth_l2_sw_notifier: %d\n",
+					 rc);
+		} else {
+			QETH_DBF_MESSAGE(2,
+					 "qeth_l2_sw_notifier unregistered\n");
+		}
 	}
 	QETH_DBF_TEXT_(SETUP, 2, "b2d-%04d",
 		       qeth_l2_switchdev_notify_refcnt.refs.counter);
-- 
2.25.1

