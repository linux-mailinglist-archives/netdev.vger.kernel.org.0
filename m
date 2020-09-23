Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA62275352
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 10:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgIWIhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 04:37:12 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48460 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726178AbgIWIhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 04:37:11 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08N8WaB8007254;
        Wed, 23 Sep 2020 04:37:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=3tsyGflreQpU8RWXWEGHyQkoqstXyIvtf3Q2Mv4nKxU=;
 b=ZtSoYkrS7YaLTrJ/zpkxYKy+KeAIEE8DPW9IEzsQ9i8D20BKjhl32OboEQUF3e1Nm4ch
 E/Kf8EjNrSSxDoSi6VwEvTRu9ElIltPwve4acVwgSatWwM57ebViirYFPg951scVgE0I
 LTL+C93qPbukGxDzzTXXde1ElfK1N8S+iu60O+zm0EvgCg68qsJ9KpeewBKtX2YKB4sT
 RWQho7ynMwlpgDB+iuxKI3mRcLcbAOvYbAM+3VI6sFBwEhYPcUf+hqI0+jXdhuo95uy5
 PWvPyW47lwQMGgW/mGKMF+38HRgfFSgdDUVQPUuSmmWDLqjCaubZeD+GgtRYWyCRQ8iN LQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33r2ncgn7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 04:37:09 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08N8VxRR004309;
        Wed, 23 Sep 2020 08:37:06 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 33n98guyfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 08:37:06 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08N8b3Ma30343466
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 08:37:04 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C999111C050;
        Wed, 23 Sep 2020 08:37:03 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8339B11C04A;
        Wed, 23 Sep 2020 08:37:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Sep 2020 08:37:03 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 2/9] s390/qeth: relax locking for ipato config data
Date:   Wed, 23 Sep 2020 10:36:53 +0200
Message-Id: <20200923083700.44624-3-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200923083700.44624-1-jwi@linux.ibm.com>
References: <20200923083700.44624-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_03:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 adultscore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 phishscore=0 impostorscore=0 bulkscore=0 spamscore=0
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230064
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

card->ipato is currently protected by the conf_mutex. But most users
also hold the ip_lock - in particular qeth_l3_add_ip().

So slightly expand the sections under ip_lock in a few places (to
effectively cover a few error & no-op cases), and then drop the
conf_mutex where it's no longer needed.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h    |  7 +++++--
 drivers/s390/net/qeth_l3_main.c |  4 ----
 drivers/s390/net/qeth_l3_sys.c  | 22 +++++++++++-----------
 3 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 2c14012ca35d..1b3fe384dcc9 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -814,12 +814,16 @@ struct qeth_card {
 	struct workqueue_struct *event_wq;
 	struct workqueue_struct *cmd_wq;
 	wait_queue_head_t wait_q;
+
+	struct mutex ip_lock;
+	/* protected by ip_lock: */
 	DECLARE_HASHTABLE(ip_htable, 4);
+	struct qeth_ipato ipato;
+
 	DECLARE_HASHTABLE(local_addrs4, 4);
 	DECLARE_HASHTABLE(local_addrs6, 4);
 	spinlock_t local_addrs4_lock;
 	spinlock_t local_addrs6_lock;
-	struct mutex ip_lock;
 	DECLARE_HASHTABLE(rx_mode_addrs, 4);
 	struct work_struct rx_mode_work;
 	struct work_struct kernel_thread_starter;
@@ -827,7 +831,6 @@ struct qeth_card {
 	unsigned long thread_start_mask;
 	unsigned long thread_allowed_mask;
 	unsigned long thread_running_mask;
-	struct qeth_ipato ipato;
 	struct list_head cmd_waiter_list;
 	/* QDIO buffer handling */
 	struct qeth_qdio_info qdio;
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 903d7b6f511f..810d65fd48b4 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -536,7 +536,6 @@ int qeth_l3_add_ipato_entry(struct qeth_card *card,
 
 	QETH_CARD_TEXT(card, 2, "addipato");
 
-	mutex_lock(&card->conf_mutex);
 	mutex_lock(&card->ip_lock);
 
 	list_for_each_entry(ipatoe, &card->ipato.entries, entry) {
@@ -556,7 +555,6 @@ int qeth_l3_add_ipato_entry(struct qeth_card *card,
 	}
 
 	mutex_unlock(&card->ip_lock);
-	mutex_unlock(&card->conf_mutex);
 
 	return rc;
 }
@@ -570,7 +568,6 @@ int qeth_l3_del_ipato_entry(struct qeth_card *card,
 
 	QETH_CARD_TEXT(card, 2, "delipato");
 
-	mutex_lock(&card->conf_mutex);
 	mutex_lock(&card->ip_lock);
 
 	list_for_each_entry_safe(ipatoe, tmp, &card->ipato.entries, entry) {
@@ -587,7 +584,6 @@ int qeth_l3_del_ipato_entry(struct qeth_card *card,
 	}
 
 	mutex_unlock(&card->ip_lock);
-	mutex_unlock(&card->conf_mutex);
 
 	return rc;
 }
diff --git a/drivers/s390/net/qeth_l3_sys.c b/drivers/s390/net/qeth_l3_sys.c
index dd0b39082534..ca9c95b6bf35 100644
--- a/drivers/s390/net/qeth_l3_sys.c
+++ b/drivers/s390/net/qeth_l3_sys.c
@@ -301,19 +301,21 @@ static ssize_t qeth_l3_dev_ipato_enable_store(struct device *dev,
 		goto out;
 	}
 
+	mutex_lock(&card->ip_lock);
 	if (sysfs_streq(buf, "toggle")) {
 		enable = !card->ipato.enabled;
 	} else if (kstrtobool(buf, &enable)) {
 		rc = -EINVAL;
-		goto out;
+		goto unlock_ip;
 	}
 
 	if (card->ipato.enabled != enable) {
 		card->ipato.enabled = enable;
-		mutex_lock(&card->ip_lock);
 		qeth_l3_update_ipato(card);
-		mutex_unlock(&card->ip_lock);
 	}
+
+unlock_ip:
+	mutex_unlock(&card->ip_lock);
 out:
 	mutex_unlock(&card->conf_mutex);
 	return rc ? rc : count;
@@ -339,7 +341,7 @@ static ssize_t qeth_l3_dev_ipato_invert4_store(struct device *dev,
 	bool invert;
 	int rc = 0;
 
-	mutex_lock(&card->conf_mutex);
+	mutex_lock(&card->ip_lock);
 	if (sysfs_streq(buf, "toggle")) {
 		invert = !card->ipato.invert4;
 	} else if (kstrtobool(buf, &invert)) {
@@ -349,12 +351,11 @@ static ssize_t qeth_l3_dev_ipato_invert4_store(struct device *dev,
 
 	if (card->ipato.invert4 != invert) {
 		card->ipato.invert4 = invert;
-		mutex_lock(&card->ip_lock);
 		qeth_l3_update_ipato(card);
-		mutex_unlock(&card->ip_lock);
 	}
+
 out:
-	mutex_unlock(&card->conf_mutex);
+	mutex_unlock(&card->ip_lock);
 	return rc ? rc : count;
 }
 
@@ -510,7 +511,7 @@ static ssize_t qeth_l3_dev_ipato_invert6_store(struct device *dev,
 	bool invert;
 	int rc = 0;
 
-	mutex_lock(&card->conf_mutex);
+	mutex_lock(&card->ip_lock);
 	if (sysfs_streq(buf, "toggle")) {
 		invert = !card->ipato.invert6;
 	} else if (kstrtobool(buf, &invert)) {
@@ -520,12 +521,11 @@ static ssize_t qeth_l3_dev_ipato_invert6_store(struct device *dev,
 
 	if (card->ipato.invert6 != invert) {
 		card->ipato.invert6 = invert;
-		mutex_lock(&card->ip_lock);
 		qeth_l3_update_ipato(card);
-		mutex_unlock(&card->ip_lock);
 	}
+
 out:
-	mutex_unlock(&card->conf_mutex);
+	mutex_unlock(&card->ip_lock);
 	return rc ? rc : count;
 }
 
-- 
2.17.1

