Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA1E3074C8
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 12:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbhA1L1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 06:27:48 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60954 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231419AbhA1L0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 06:26:46 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10SB2IZk035272;
        Thu, 28 Jan 2021 06:26:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=TrBHHs5AlR5uHA5QephXWYseMANNDYp52oOJ3pSr5uA=;
 b=S4zvGwHDIO0irZqKoxSqERYkBORuGhU70OsOrh8xNXPOq/4zf0yyKyskwI1/5AJVwpvM
 yd3PXvMIi3pfjGI9VI7ujvYAnoeC3DfKafX/8x3atm7uu8aRRfbQlzdBLBDai3r9vSLc
 xtScUX8FvWbW60Z8tMuU7NKFHa8vaHDb7KuvB1D/rmFBLdoQkYN90lkdTwU9QWU743q9
 QVcR7D49OqT0CcjhLGt9egjqJIqbd5n2/SeMNO+YJJzVcSA+4eZEBrCH32GInjD0U8EW
 +5aYOs62TTtHcMXhiGVbLyTF2ujnU2WvcsYUMM3WrQ8VU1fLyihwFF6nXlgjJUu7ICBJ 4g== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36b5t51gxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jan 2021 06:26:01 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10SBMY8E027497;
        Thu, 28 Jan 2021 11:25:59 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 368be8afkw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jan 2021 11:25:58 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10SBPuMA45285864
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jan 2021 11:25:56 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2FA9442041;
        Thu, 28 Jan 2021 11:25:56 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3D3442045;
        Thu, 28 Jan 2021 11:25:55 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 28 Jan 2021 11:25:55 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 1/5] s390/qeth: clean up load/remove code for disciplines
Date:   Thu, 28 Jan 2021 12:25:47 +0100
Message-Id: <20210128112551.18780-2-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210128112551.18780-1-jwi@linux.ibm.com>
References: <20210128112551.18780-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-28_05:2021-01-27,2021-01-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 phishscore=0 adultscore=0 clxscore=1015 suspectscore=0 lowpriorityscore=0
 mlxscore=0 mlxlogscore=999 priorityscore=1501 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101280051
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have two usage patterns:
1. get & ->setup() a new discipline, or
2. ->remove() & put the currently loaded one.

Add corresponding helpers that hide the internals & error handling.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  4 +--
 drivers/s390/net/qeth_core_main.c | 45 ++++++++++++++++---------------
 drivers/s390/net/qeth_core_sys.c  | 10 ++-----
 3 files changed, 28 insertions(+), 31 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 28f637042d44..331dcbbf3e25 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -1067,8 +1067,8 @@ extern const struct device_type qeth_generic_devtype;
 
 const char *qeth_get_cardname_short(struct qeth_card *);
 int qeth_resize_buffer_pool(struct qeth_card *card, unsigned int count);
-int qeth_core_load_discipline(struct qeth_card *, enum qeth_discipline_id);
-void qeth_core_free_discipline(struct qeth_card *);
+int qeth_setup_discipline(struct qeth_card *card, enum qeth_discipline_id disc);
+void qeth_remove_discipline(struct qeth_card *card);
 
 /* exports for qeth discipline device drivers */
 extern struct kmem_cache *qeth_core_header_cache;
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index cf18d87da41e..0a65213ab606 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6349,9 +6349,11 @@ static int qeth_register_dbf_views(void)
 
 static DEFINE_MUTEX(qeth_mod_mutex);	/* for synchronized module loading */
 
-int qeth_core_load_discipline(struct qeth_card *card,
-		enum qeth_discipline_id discipline)
+int qeth_setup_discipline(struct qeth_card *card,
+			  enum qeth_discipline_id discipline)
 {
+	int rc;
+
 	mutex_lock(&qeth_mod_mutex);
 	switch (discipline) {
 	case QETH_DISCIPLINE_LAYER3:
@@ -6373,12 +6375,25 @@ int qeth_core_load_discipline(struct qeth_card *card,
 		return -EINVAL;
 	}
 
+	rc = card->discipline->setup(card->gdev);
+	if (rc) {
+		if (discipline == QETH_DISCIPLINE_LAYER2)
+			symbol_put(qeth_l2_discipline);
+		else
+			symbol_put(qeth_l3_discipline);
+		card->discipline = NULL;
+
+		return rc;
+	}
+
 	card->options.layer = discipline;
 	return 0;
 }
 
-void qeth_core_free_discipline(struct qeth_card *card)
+void qeth_remove_discipline(struct qeth_card *card)
 {
+	card->discipline->remove(card->gdev);
+
 	if (IS_LAYER2(card))
 		symbol_put(qeth_l2_discipline);
 	else
@@ -6586,23 +6601,18 @@ static int qeth_core_probe_device(struct ccwgroup_device *gdev)
 	default:
 		card->info.layer_enforced = true;
 		/* It's so early that we don't need the discipline_mutex yet. */
-		rc = qeth_core_load_discipline(card, enforced_disc);
+		rc = qeth_setup_discipline(card, enforced_disc);
 		if (rc)
-			goto err_load;
+			goto err_setup_disc;
 
 		gdev->dev.type = IS_OSN(card) ? &qeth_osn_devtype :
 						card->discipline->devtype;
-		rc = card->discipline->setup(card->gdev);
-		if (rc)
-			goto err_disc;
 		break;
 	}
 
 	return 0;
 
-err_disc:
-	qeth_core_free_discipline(card);
-err_load:
+err_setup_disc:
 err_chp_desc:
 	free_netdev(card->dev);
 err_card:
@@ -6619,10 +6629,8 @@ static void qeth_core_remove_device(struct ccwgroup_device *gdev)
 	QETH_CARD_TEXT(card, 2, "removedv");
 
 	mutex_lock(&card->discipline_mutex);
-	if (card->discipline) {
-		card->discipline->remove(gdev);
-		qeth_core_free_discipline(card);
-	}
+	if (card->discipline)
+		qeth_remove_discipline(card);
 	mutex_unlock(&card->discipline_mutex);
 
 	qeth_free_qdio_queues(card);
@@ -6642,14 +6650,9 @@ static int qeth_core_set_online(struct ccwgroup_device *gdev)
 	if (!card->discipline) {
 		def_discipline = IS_IQD(card) ? QETH_DISCIPLINE_LAYER3 :
 						QETH_DISCIPLINE_LAYER2;
-		rc = qeth_core_load_discipline(card, def_discipline);
+		rc = qeth_setup_discipline(card, def_discipline);
 		if (rc)
 			goto err;
-		rc = card->discipline->setup(card->gdev);
-		if (rc) {
-			qeth_core_free_discipline(card);
-			goto err;
-		}
 	}
 
 	rc = qeth_set_online(card, card->discipline);
diff --git a/drivers/s390/net/qeth_core_sys.c b/drivers/s390/net/qeth_core_sys.c
index a0f777f76f66..5815114da468 100644
--- a/drivers/s390/net/qeth_core_sys.c
+++ b/drivers/s390/net/qeth_core_sys.c
@@ -384,19 +384,13 @@ static ssize_t qeth_dev_layer2_store(struct device *dev,
 			goto out;
 		}
 
-		card->discipline->remove(card->gdev);
-		qeth_core_free_discipline(card);
+		qeth_remove_discipline(card);
 		free_netdev(card->dev);
 		card->dev = ndev;
 	}
 
-	rc = qeth_core_load_discipline(card, newdis);
-	if (rc)
-		goto out;
+	rc = qeth_setup_discipline(card, newdis);
 
-	rc = card->discipline->setup(card->gdev);
-	if (rc)
-		qeth_core_free_discipline(card);
 out:
 	mutex_unlock(&card->discipline_mutex);
 	return rc ? rc : count;
-- 
2.17.1

