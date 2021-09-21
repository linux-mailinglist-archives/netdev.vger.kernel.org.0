Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29D8F4135AA
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 16:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233835AbhIUOyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 10:54:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45236 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233784AbhIUOx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 10:53:59 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18LE6DjV001549;
        Tue, 21 Sep 2021 10:52:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=eAIpzbHKu/gMjgR0k6JGM4Tc90EDXllQhMtwTVJyCwc=;
 b=c2AIvgI1A2Rz5pm46RkinLIv/LKkLdZvBMSb8nDZe/PF4tmhBAQm5U6Ph/0Wu6DRvaA3
 kZwUJBhPHlo5vT3vq1ob9uL2px9mYf4V4umgQ2MYedfmzY2AKg+Y4UdZMy8HVQEwrPjN
 FCrSnbwCudhv8CZzFREaJElSIAoLlvhg2rzF8a7zJQNhe9tI08VAottP+uCripT9ijUP
 WVu5cxrkX4BjOSKS22cLtLJ11SEgTRmLeqMWfkyBqxdh0W/BsS7vShJeAVdLXPY44ANM
 ArOG3r/tDpskpK/WVkz9foBdXXRYfZIxtWpTTuN73Rxkbv34AHc4jXFjvirVs5EUGNd1 SQ== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7f15mxfq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 10:52:29 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18LEqFTh020123;
        Tue, 21 Sep 2021 14:52:27 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3b57r9nc88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 14:52:26 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18LEqKDO43712858
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Sep 2021 14:52:20 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E835C52050;
        Tue, 21 Sep 2021 14:52:19 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 98A5952077;
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
Subject: [PATCH net 3/3] s390/qeth: fix deadlock during failing recovery
Date:   Tue, 21 Sep 2021 16:52:17 +0200
Message-Id: <20210921145217.1584654-4-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210921145217.1584654-1-jwi@linux.ibm.com>
References: <20210921145217.1584654-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MOnMHb89gZ9Lci1VkJPKdqaFt4wjj-V-
X-Proofpoint-GUID: MOnMHb89gZ9Lci1VkJPKdqaFt4wjj-V-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-21_04,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 mlxscore=0 phishscore=0 impostorscore=0 spamscore=0 priorityscore=1501
 suspectscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109210089
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandra Winter <wintera@linux.ibm.com>

Commit 0b9902c1fcc5 ("s390/qeth: fix deadlock during recovery") removed
taking discipline_mutex inside qeth_do_reset(), fixing potential
deadlocks. An error path was missed though, that still takes
discipline_mutex and thus has the original deadlock potential.

Intermittent deadlocks were seen when a qeth channel path is configured
offline, causing a race between qeth_do_reset and ccwgroup_remove.
Call qeth_set_offline() directly in the qeth_do_reset() error case and
then a new variant of ccwgroup_set_offline(), without taking
discipline_mutex.

Fixes: b41b554c1ee7 ("s390/qeth: fix locking for discipline setup / removal")
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 arch/s390/include/asm/ccwgroup.h  |  2 +-
 drivers/s390/cio/ccwgroup.c       | 10 ++++++++--
 drivers/s390/net/qeth_core_main.c |  3 ++-
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/s390/include/asm/ccwgroup.h b/arch/s390/include/asm/ccwgroup.h
index 36dbf5043fc0..aa995d91cd1d 100644
--- a/arch/s390/include/asm/ccwgroup.h
+++ b/arch/s390/include/asm/ccwgroup.h
@@ -55,7 +55,7 @@ int ccwgroup_create_dev(struct device *root, struct ccwgroup_driver *gdrv,
 			int num_devices, const char *buf);
 
 extern int ccwgroup_set_online(struct ccwgroup_device *gdev);
-extern int ccwgroup_set_offline(struct ccwgroup_device *gdev);
+int ccwgroup_set_offline(struct ccwgroup_device *gdev, bool call_gdrv);
 
 extern int ccwgroup_probe_ccwdev(struct ccw_device *cdev);
 extern void ccwgroup_remove_ccwdev(struct ccw_device *cdev);
diff --git a/drivers/s390/cio/ccwgroup.c b/drivers/s390/cio/ccwgroup.c
index 2ec741106cb6..f0538609dfe4 100644
--- a/drivers/s390/cio/ccwgroup.c
+++ b/drivers/s390/cio/ccwgroup.c
@@ -77,12 +77,13 @@ EXPORT_SYMBOL(ccwgroup_set_online);
 /**
  * ccwgroup_set_offline() - disable a ccwgroup device
  * @gdev: target ccwgroup device
+ * @call_gdrv: Call the registered gdrv set_offline function
  *
  * This function attempts to put the ccwgroup device into the offline state.
  * Returns:
  *  %0 on success and a negative error value on failure.
  */
-int ccwgroup_set_offline(struct ccwgroup_device *gdev)
+int ccwgroup_set_offline(struct ccwgroup_device *gdev, bool call_gdrv)
 {
 	struct ccwgroup_driver *gdrv = to_ccwgroupdrv(gdev->dev.driver);
 	int ret = -EINVAL;
@@ -91,11 +92,16 @@ int ccwgroup_set_offline(struct ccwgroup_device *gdev)
 		return -EAGAIN;
 	if (gdev->state == CCWGROUP_OFFLINE)
 		goto out;
+	if (!call_gdrv) {
+		ret = 0;
+		goto offline;
+	}
 	if (gdrv->set_offline)
 		ret = gdrv->set_offline(gdev);
 	if (ret)
 		goto out;
 
+offline:
 	gdev->state = CCWGROUP_OFFLINE;
 out:
 	atomic_set(&gdev->onoff, 0);
@@ -124,7 +130,7 @@ static ssize_t ccwgroup_online_store(struct device *dev,
 	if (value == 1)
 		ret = ccwgroup_set_online(gdev);
 	else if (value == 0)
-		ret = ccwgroup_set_offline(gdev);
+		ret = ccwgroup_set_offline(gdev, true);
 	else
 		ret = -EINVAL;
 out:
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 9f26706051e5..e9807d2996a9 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -5514,7 +5514,8 @@ static int qeth_do_reset(void *data)
 		dev_info(&card->gdev->dev,
 			 "Device successfully recovered!\n");
 	} else {
-		ccwgroup_set_offline(card->gdev);
+		qeth_set_offline(card, disc, true);
+		ccwgroup_set_offline(card->gdev, false);
 		dev_warn(&card->gdev->dev,
 			 "The qeth device driver failed to recover an error on the device\n");
 	}
-- 
2.25.1

