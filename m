Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D952ED582
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 18:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbhAGRZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 12:25:36 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18098 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726541AbhAGRZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 12:25:35 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 107H8Q9j070234;
        Thu, 7 Jan 2021 12:24:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=nu+iCIxZqpDQixbz46F0mQ0XZEjJ+oYcs3e+C2barFM=;
 b=AP665q7rWyfs5PI18P82xALZvRFee7p6ZVNzPCB9HradaI3zjUKWjGTNAxbGIF2hQVsU
 wlnX9vl6bs1BWCLVY2fvuGNVlj3f6ZOcvSRdwHrvvMCMwBs0UvPE7yVfU4ovOt8XVBK8
 U/wmAsGTmjNLaG7QdRWfAbjyGQXJPZoJKHb/72oMPvZ98VsBUxH53gJW9pgnrhZIS1ve
 ou3fhM1f64wBQCh/ShI+gXf15dOcSrCzKDuTNCnhQJI/OE6tK+jAsYio6MfHfDZzzLZW
 Yv3aRBEehh3ANGaksAXHOprVmNUYNZkwvu1Vg+OxrvMj/6OjI53kXbIhNaWFyg2q6mxh lg== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35x5juhxg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jan 2021 12:24:53 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 107HBncT027409;
        Thu, 7 Jan 2021 17:24:51 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 35tg3hd3f1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jan 2021 17:24:51 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 107HOmxB37814642
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Jan 2021 17:24:48 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B44142041;
        Thu,  7 Jan 2021 17:24:48 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2488C4203F;
        Thu,  7 Jan 2021 17:24:48 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Jan 2021 17:24:48 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 2/3] s390/qeth: fix locking for discipline setup / removal
Date:   Thu,  7 Jan 2021 18:24:41 +0100
Message-Id: <20210107172442.1737-3-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210107172442.1737-1-jwi@linux.ibm.com>
References: <20210107172442.1737-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-07_07:2021-01-07,2021-01-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 impostorscore=0 spamscore=0 adultscore=0 phishscore=0
 suspectscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101070100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Due to insufficient locking, qeth_core_set_online() and
qeth_dev_layer2_store() can run in parallel, both attempting to load &
setup the discipline (and stepping on each other toes along the way).
A similar race can also occur between qeth_core_remove_device() and
qeth_dev_layer2_store().

Access to .discipline is meant to be protected by the discipline_mutex,
so add/expand the locking in qeth_core_remove_device() and
qeth_core_set_online().
Adjust the locking in qeth_l*_remove_device() accordingly, as it's now
handled by the callers in a consistent manner.

Based on an initial patch by Ursula Braun.

Fixes: 9dc48ccc68b9 ("qeth: serialize sysfs-triggered device configurations")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 7 +++++--
 drivers/s390/net/qeth_l2_main.c   | 5 +----
 drivers/s390/net/qeth_l3_main.c   | 5 +----
 3 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index d45e223fc521..cf18d87da41e 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6585,6 +6585,7 @@ static int qeth_core_probe_device(struct ccwgroup_device *gdev)
 		break;
 	default:
 		card->info.layer_enforced = true;
+		/* It's so early that we don't need the discipline_mutex yet. */
 		rc = qeth_core_load_discipline(card, enforced_disc);
 		if (rc)
 			goto err_load;
@@ -6617,10 +6618,12 @@ static void qeth_core_remove_device(struct ccwgroup_device *gdev)
 
 	QETH_CARD_TEXT(card, 2, "removedv");
 
+	mutex_lock(&card->discipline_mutex);
 	if (card->discipline) {
 		card->discipline->remove(gdev);
 		qeth_core_free_discipline(card);
 	}
+	mutex_unlock(&card->discipline_mutex);
 
 	qeth_free_qdio_queues(card);
 
@@ -6635,6 +6638,7 @@ static int qeth_core_set_online(struct ccwgroup_device *gdev)
 	int rc = 0;
 	enum qeth_discipline_id def_discipline;
 
+	mutex_lock(&card->discipline_mutex);
 	if (!card->discipline) {
 		def_discipline = IS_IQD(card) ? QETH_DISCIPLINE_LAYER3 :
 						QETH_DISCIPLINE_LAYER2;
@@ -6648,11 +6652,10 @@ static int qeth_core_set_online(struct ccwgroup_device *gdev)
 		}
 	}
 
-	mutex_lock(&card->discipline_mutex);
 	rc = qeth_set_online(card, card->discipline);
-	mutex_unlock(&card->discipline_mutex);
 
 err:
+	mutex_unlock(&card->discipline_mutex);
 	return rc;
 }
 
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 37279b1e29f6..4254caf1d9b6 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -2207,11 +2207,8 @@ static void qeth_l2_remove_device(struct ccwgroup_device *gdev)
 	qeth_set_allowed_threads(card, 0, 1);
 	wait_event(card->wait_q, qeth_threads_running(card, 0xffffffff) == 0);
 
-	if (gdev->state == CCWGROUP_ONLINE) {
-		mutex_lock(&card->discipline_mutex);
+	if (gdev->state == CCWGROUP_ONLINE)
 		qeth_set_offline(card, card->discipline, false);
-		mutex_unlock(&card->discipline_mutex);
-	}
 
 	cancel_work_sync(&card->close_dev_work);
 	if (card->dev->reg_state == NETREG_REGISTERED)
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 8d474179ce98..6970597bc885 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1970,11 +1970,8 @@ static void qeth_l3_remove_device(struct ccwgroup_device *cgdev)
 	qeth_set_allowed_threads(card, 0, 1);
 	wait_event(card->wait_q, qeth_threads_running(card, 0xffffffff) == 0);
 
-	if (cgdev->state == CCWGROUP_ONLINE) {
-		mutex_lock(&card->discipline_mutex);
+	if (cgdev->state == CCWGROUP_ONLINE)
 		qeth_set_offline(card, card->discipline, false);
-		mutex_unlock(&card->discipline_mutex);
-	}
 
 	cancel_work_sync(&card->close_dev_work);
 	if (card->dev->reg_state == NETREG_REGISTERED)
-- 
2.17.1

