Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08D0C1C6B07
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 10:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgEFIKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 04:10:06 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22546 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728717AbgEFIKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 04:10:02 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04683hZI094426;
        Wed, 6 May 2020 04:09:59 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30s50he2b0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 04:09:59 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04685eDK017045;
        Wed, 6 May 2020 08:09:57 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 30s0g5kgq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 08:09:57 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04688iJV29622686
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 May 2020 08:08:44 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BAD0A405C;
        Wed,  6 May 2020 08:09:54 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4EF5FA4065;
        Wed,  6 May 2020 08:09:54 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  6 May 2020 08:09:54 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH v2 net-next 09/10] s390/qeth: return error when starting a reset fails
Date:   Wed,  6 May 2020 10:09:48 +0200
Message-Id: <20200506080949.3915-10-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200506080949.3915-1-jwi@linux.ibm.com>
References: <20200506080949.3915-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-06_02:2020-05-04,2020-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 adultscore=0 priorityscore=1501
 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005060062
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When starting the reset worker via sysfs is unsuccessful, return an
error to the user.
Modernize the sysfs input parsing while at it.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  2 +-
 drivers/s390/net/qeth_core_main.c | 26 +++++++++++++++++---------
 drivers/s390/net/qeth_core_sys.c  | 15 +++++++++------
 3 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 6b0d37d2c638..51ea56b73a97 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -1053,7 +1053,7 @@ struct qeth_cmd_buffer *qeth_get_diag_cmd(struct qeth_card *card,
 void qeth_notify_cmd(struct qeth_cmd_buffer *iob, int reason);
 void qeth_put_cmd(struct qeth_cmd_buffer *iob);
 
-void qeth_schedule_recovery(struct qeth_card *);
+int qeth_schedule_recovery(struct qeth_card *card);
 void qeth_flush_local_addrs(struct qeth_card *card);
 int qeth_poll(struct napi_struct *napi, int budget);
 void qeth_clear_ipacmd_list(struct qeth_card *);
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 164cc7f377fc..c0ab6e7bc129 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1131,16 +1131,18 @@ static int qeth_set_thread_start_bit(struct qeth_card *card,
 		unsigned long thread)
 {
 	unsigned long flags;
+	int rc = 0;
 
 	spin_lock_irqsave(&card->thread_mask_lock, flags);
-	if (!(card->thread_allowed_mask & thread) ||
-	      (card->thread_start_mask & thread)) {
-		spin_unlock_irqrestore(&card->thread_mask_lock, flags);
-		return -EPERM;
-	}
-	card->thread_start_mask |= thread;
+	if (!(card->thread_allowed_mask & thread))
+		rc = -EPERM;
+	else if (card->thread_start_mask & thread)
+		rc = -EBUSY;
+	else
+		card->thread_start_mask |= thread;
 	spin_unlock_irqrestore(&card->thread_mask_lock, flags);
-	return 0;
+
+	return rc;
 }
 
 static void qeth_clear_thread_start_bit(struct qeth_card *card,
@@ -1193,11 +1195,17 @@ static int qeth_do_run_thread(struct qeth_card *card, unsigned long thread)
 	return rc;
 }
 
-void qeth_schedule_recovery(struct qeth_card *card)
+int qeth_schedule_recovery(struct qeth_card *card)
 {
+	int rc;
+
 	QETH_CARD_TEXT(card, 2, "startrec");
-	if (qeth_set_thread_start_bit(card, QETH_RECOVER_THREAD) == 0)
+
+	rc = qeth_set_thread_start_bit(card, QETH_RECOVER_THREAD);
+	if (!rc)
 		schedule_work(&card->kernel_thread_starter);
+
+	return rc;
 }
 
 static int qeth_get_problem(struct qeth_card *card, struct ccw_device *cdev,
diff --git a/drivers/s390/net/qeth_core_sys.c b/drivers/s390/net/qeth_core_sys.c
index d7e429f6631e..c901c942fed7 100644
--- a/drivers/s390/net/qeth_core_sys.c
+++ b/drivers/s390/net/qeth_core_sys.c
@@ -275,17 +275,20 @@ static ssize_t qeth_dev_recover_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
-	char *tmp;
-	int i;
+	bool reset;
+	int rc;
+
+	rc = kstrtobool(buf, &reset);
+	if (rc)
+		return rc;
 
 	if (!qeth_card_hw_is_reachable(card))
 		return -EPERM;
 
-	i = simple_strtoul(buf, &tmp, 16);
-	if (i == 1)
-		qeth_schedule_recovery(card);
+	if (reset)
+		rc = qeth_schedule_recovery(card);
 
-	return count;
+	return rc ? rc : count;
 }
 
 static DEVICE_ATTR(recover, 0200, NULL, qeth_dev_recover_store);
-- 
2.17.1

