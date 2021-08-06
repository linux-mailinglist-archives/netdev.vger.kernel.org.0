Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24DE03E2DBE
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 17:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244485AbhHFP0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 11:26:34 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9992 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244155AbhHFP0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 11:26:31 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 176F3Opr029121;
        Fri, 6 Aug 2021 11:26:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=60Zfp/KxiqDjsVuX0+0G2U3ArxhlZNf07sfLFHW8rao=;
 b=DCfKeSySoq669GeC21glGD//gUuGqFaM0TuNyFMDqCCFIgMCO2hUhxKZqH8t1xN2V52l
 JYRSxAWuhfHFMTA8iX/W9/cLIjhiBldFQis9/5CC4GMSbUngJJLhNjNT/QqB1a3QDtdM
 5JRhqK0rTkZLDXZgPOIUfYnjh6Xc7yYmkfdGvSrZYqr1vgkQ0+IldhIXlewBCtTpO/T4
 GnHw9onWkXdQiOGYB2bYB4AfPBkk5cMB9tMKq4vt6TPhOSXW3lkcgHaWoO9vx/drUhhz
 exhW8rdja+KPDUTqwm/EyodiSDA3Dr0i6VQsrVPlGOK70M0kkCnl7jsSOt9G7lntwzKw 6Q== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a87f7jmjn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Aug 2021 11:26:12 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 176FOll2029997;
        Fri, 6 Aug 2021 15:26:10 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 3a4wsj405k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Aug 2021 15:26:09 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 176FN6MG40304934
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Aug 2021 15:23:06 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7BE7AA4064;
        Fri,  6 Aug 2021 15:26:06 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1928CA405B;
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
Subject: [PATCH net-next 1/3] s390/qeth: Register switchdev event handler
Date:   Fri,  6 Aug 2021 17:26:01 +0200
Message-Id: <20210806152603.375642-2-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210806152603.375642-1-kgraul@linux.ibm.com>
References: <20210806152603.375642-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -JNb1jg6CmkL-MR_kixfH5X54UexuMJe
X-Proofpoint-GUID: -JNb1jg6CmkL-MR_kixfH5X54UexuMJe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-06_05:2021-08-05,2021-08-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 bulkscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 impostorscore=0 clxscore=1015 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108060104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandra Winter <wintera@linux.ibm.com>

Conditionally register a qeth_l2 switchdev_event handler to handle bridge
to device switchdev events, when at least one qeth interface has the
bridgeport attribute LEARNING_SYNC enabled.

Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 drivers/s390/net/qeth_l2_main.c | 43 ++++++++++++++++++++++++++++++---
 1 file changed, 40 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 69afc0311dd1..3d02d35df5d3 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -717,6 +717,31 @@ static int qeth_l2_dev2br_an_set(struct qeth_card *card, bool enable)
 	return rc;
 }
 
+static refcount_t qeth_l2_switchdev_notify_refcnt;
+
+/* Called under rtnl_lock */
+static void qeth_l2_br2dev_get(void)
+{
+	if (!refcount_inc_not_zero(&qeth_l2_switchdev_notify_refcnt)) {
+		/* tbd: register_switchdev_notifier(&qeth_l2_sw_notifier); */
+		refcount_set(&qeth_l2_switchdev_notify_refcnt, 1);
+		QETH_DBF_MESSAGE(2, "qeth_l2_sw_notifier registered\n");
+	}
+	QETH_DBF_TEXT_(SETUP, 2, "b2d+%04d",
+		       qeth_l2_switchdev_notify_refcnt.refs.counter);
+}
+
+/* Called under rtnl_lock */
+static void qeth_l2_br2dev_put(void)
+{
+	if (refcount_dec_and_test(&qeth_l2_switchdev_notify_refcnt)) {
+		/* tbd: unregister_switchdev_notifier(&qeth_l2_sw_notifier); */
+		QETH_DBF_MESSAGE(2, "qeth_l2_sw_notifier unregistered\n");
+	}
+	QETH_DBF_TEXT_(SETUP, 2, "b2d-%04d",
+		       qeth_l2_switchdev_notify_refcnt.refs.counter);
+}
+
 static int qeth_l2_bridge_getlink(struct sk_buff *skb, u32 pid, u32 seq,
 				  struct net_device *dev, u32 filter_mask,
 				  int nlflags)
@@ -810,16 +835,19 @@ static int qeth_l2_bridge_setlink(struct net_device *dev, struct nlmsghdr *nlh,
 	} else if (enable) {
 		qeth_l2_set_pnso_mode(card, QETH_PNSO_ADDR_INFO);
 		rc = qeth_l2_dev2br_an_set(card, true);
-		if (rc)
+		if (rc) {
 			qeth_l2_set_pnso_mode(card, QETH_PNSO_NONE);
-		else
+		} else {
 			priv->brport_features |= BR_LEARNING_SYNC;
+			qeth_l2_br2dev_get();
+		}
 	} else {
 		rc = qeth_l2_dev2br_an_set(card, false);
 		if (!rc) {
 			qeth_l2_set_pnso_mode(card, QETH_PNSO_NONE);
 			priv->brport_features ^= BR_LEARNING_SYNC;
 			qeth_l2_dev2br_fdb_flush(card);
+			qeth_l2_br2dev_put();
 		}
 	}
 	mutex_unlock(&card->sbp_lock);
@@ -2072,6 +2100,7 @@ static int qeth_l2_probe_device(struct ccwgroup_device *gdev)
 static void qeth_l2_remove_device(struct ccwgroup_device *gdev)
 {
 	struct qeth_card *card = dev_get_drvdata(&gdev->dev);
+	struct qeth_priv *priv;
 
 	if (gdev->dev.type != &qeth_l2_devtype)
 		device_remove_groups(&gdev->dev, qeth_l2_attr_groups);
@@ -2083,8 +2112,15 @@ static void qeth_l2_remove_device(struct ccwgroup_device *gdev)
 		qeth_set_offline(card, card->discipline, false);
 
 	cancel_work_sync(&card->close_dev_work);
-	if (card->dev->reg_state == NETREG_REGISTERED)
+	if (card->dev->reg_state == NETREG_REGISTERED) {
+		priv = netdev_priv(card->dev);
+		if (priv->brport_features & BR_LEARNING_SYNC) {
+			rtnl_lock();
+			qeth_l2_br2dev_put();
+			rtnl_unlock();
+		}
 		unregister_netdev(card->dev);
+	}
 }
 
 static int qeth_l2_set_online(struct qeth_card *card, bool carrier_ok)
@@ -2207,6 +2243,7 @@ EXPORT_SYMBOL_GPL(qeth_l2_discipline);
 static int __init qeth_l2_init(void)
 {
 	pr_info("register layer 2 discipline\n");
+	refcount_set(&qeth_l2_switchdev_notify_refcnt, 0);
 	return 0;
 }
 
-- 
2.25.1

