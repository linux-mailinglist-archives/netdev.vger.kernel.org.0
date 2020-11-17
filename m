Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91252B69AD
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 17:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbgKQQPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 11:15:44 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47744 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726884AbgKQQPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 11:15:37 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AHG2Ioe082627;
        Tue, 17 Nov 2020 11:15:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=O6CSFp7uIGjR5NKKDowyT/x5XYGwSd/EUAPZ+BRRUAM=;
 b=Xx0GvctZxOgi++dH3MZLMc3s+KefnDwVGNcwkOPUHvPC3lpYdbPcQUwnV7qdD+BB2gho
 76hZfOcUCiMDY0ht3GtTVO00GkoA6EpOCnxSTcvmp2V7BmEsWVOsmHzJ3xr/BO4sGiuC
 xsGoY312LXbLvHAeetHRyeGfdU4VWKcH1po/+CvZjLhWPAQ0u2GoxttRemn8EeOkd+x8
 5ocYl++owYNJVym6s1owgM+j8+22edecLHnJrzR0GII+HVz2y7xZE18VxHuobwwLHM45
 9Mau/x0bjzbJUKFc5pzl7hV39iyrfvnNUsNlirN9R/+kfK4mdwnlbNMAmIljzlypW4GB nA== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34v3yfeqdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 11:15:31 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AHG74KR025446;
        Tue, 17 Nov 2020 16:15:29 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 34t6v89q9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 16:15:29 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AHGFQkG61473084
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 16:15:26 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7505FA4067;
        Tue, 17 Nov 2020 16:15:26 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 391E1A4064;
        Tue, 17 Nov 2020 16:15:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 Nov 2020 16:15:26 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 2/9] s390/qeth: reduce rtnl locking for switchdev events
Date:   Tue, 17 Nov 2020 17:15:13 +0100
Message-Id: <20201117161520.1089-3-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201117161520.1089-1-jwi@linux.ibm.com>
References: <20201117161520.1089-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_04:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 adultscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 priorityscore=1501 malwarescore=0 suspectscore=2 mlxscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170114
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

call_switchdev_notifiers() doesn't require holding the RTNL lock since
commit ff5cf100110c ("net: switchdev: Change notifier chain to be atomic").

We still need it for the "lost event" slow path, to avoid racing against
a concurrent .ndo_bridge_setlink().

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/s390/net/qeth_l2_main.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 28f6dda95736..daeb837abec3 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -737,8 +737,6 @@ static void qeth_l2_dev2br_an_set_cb(void *priv,
  *
  *	On enable, emits a series of address notifications for all
  *	currently registered hosts.
- *
- *	Must be called under rtnl_lock
  */
 static int qeth_l2_dev2br_an_set(struct qeth_card *card, bool enable)
 {
@@ -1289,16 +1287,19 @@ static void qeth_l2_dev2br_worker(struct work_struct *work)
 	if (READ_ONCE(card->info.pnso_mode) == QETH_PNSO_NONE)
 		goto free;
 
-	/* Potential re-config in progress, try again later: */
-	if (!rtnl_trylock()) {
-		queue_delayed_work(card->event_wq, dwork,
-				   msecs_to_jiffies(100));
-		return;
-	}
-	if (!netif_device_present(card->dev))
-		goto out_unlock;
-
 	if (data->ac_event.lost_event_mask) {
+		/* Potential re-config in progress, try again later: */
+		if (!rtnl_trylock()) {
+			queue_delayed_work(card->event_wq, dwork,
+					   msecs_to_jiffies(100));
+			return;
+		}
+
+		if (!netif_device_present(card->dev)) {
+			rtnl_unlock();
+			goto free;
+		}
+
 		QETH_DBF_MESSAGE(3,
 				 "Address change notification overflow on device %x\n",
 				 CARD_DEVID(card));
@@ -1328,6 +1329,8 @@ static void qeth_l2_dev2br_worker(struct work_struct *work)
 					 "Address Notification resynced on device %x\n",
 					 CARD_DEVID(card));
 		}
+
+		rtnl_unlock();
 	} else {
 		for (i = 0; i < data->ac_event.num_entries; i++) {
 			struct qeth_ipacmd_addr_change_entry *entry =
@@ -1339,9 +1342,6 @@ static void qeth_l2_dev2br_worker(struct work_struct *work)
 		}
 	}
 
-out_unlock:
-	rtnl_unlock();
-
 free:
 	kfree(data);
 }
@@ -2310,11 +2310,8 @@ static void qeth_l2_set_offline(struct qeth_card *card)
 		card->state = CARD_STATE_DOWN;
 
 	qeth_l2_set_pnso_mode(card, QETH_PNSO_NONE);
-	if (priv->brport_features & BR_LEARNING_SYNC) {
-		rtnl_lock();
+	if (priv->brport_features & BR_LEARNING_SYNC)
 		qeth_l2_dev2br_fdb_flush(card);
-		rtnl_unlock();
-	}
 }
 
 /* Returns zero if the command is successfully "consumed" */
-- 
2.17.1

