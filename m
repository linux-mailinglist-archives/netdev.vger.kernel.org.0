Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15F87149677
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 16:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgAYPxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 10:53:14 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8260 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725710AbgAYPxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 10:53:14 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00PFa1Ov128191
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 10:53:12 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xrgqc1bky-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 10:53:12 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Sat, 25 Jan 2020 15:53:10 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 25 Jan 2020 15:53:09 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00PFr7o528967110
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Jan 2020 15:53:07 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD7774C046;
        Sat, 25 Jan 2020 15:53:07 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74BD84C04A;
        Sat, 25 Jan 2020 15:53:07 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 25 Jan 2020 15:53:07 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 1/5] s390/qeth: shift some bridgeport code around
Date:   Sat, 25 Jan 2020 16:52:59 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200125155303.40971-1-jwi@linux.ibm.com>
References: <20200125155303.40971-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20012515-0028-0000-0000-000003D450FF
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20012515-0029-0000-0000-00002498919C
Message-Id: <20200125155303.40971-2-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-25_05:2020-01-24,2020-01-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 phishscore=0 mlxlogscore=824
 priorityscore=1501 impostorscore=0 malwarescore=0 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2001250132
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qeth_l2_setup_bridgeport_attrs() is entirely unrelated to sysfs
functionality, move it where it belongs.
While at it merge all the bridgeport-specific code in the set-online
path together.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/s390/net/qeth_l2.h      |  1 -
 drivers/s390/net/qeth_l2_main.c | 26 +++++++++++++++++++++----
 drivers/s390/net/qeth_l2_sys.c  | 34 ---------------------------------
 3 files changed, 22 insertions(+), 39 deletions(-)

diff --git a/drivers/s390/net/qeth_l2.h b/drivers/s390/net/qeth_l2.h
index ddc615b431a8..adf25c9fd2b3 100644
--- a/drivers/s390/net/qeth_l2.h
+++ b/drivers/s390/net/qeth_l2.h
@@ -13,7 +13,6 @@ extern const struct attribute_group *qeth_l2_attr_groups[];
 
 int qeth_l2_create_device_attributes(struct device *);
 void qeth_l2_remove_device_attributes(struct device *);
-void qeth_l2_setup_bridgeport_attrs(struct qeth_card *card);
 int qeth_bridgeport_query_ports(struct qeth_card *card,
 				enum qeth_sbp_roles *role,
 				enum qeth_sbp_states *state);
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 7175b5d8a23c..7da306e267c9 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -728,6 +728,24 @@ static void qeth_l2_trace_features(struct qeth_card *card)
 		      sizeof(card->options.vnicc.sup_chars));
 }
 
+static void qeth_l2_setup_bridgeport_attrs(struct qeth_card *card)
+{
+	if (!card->options.sbp.reflect_promisc &&
+	    card->options.sbp.role != QETH_SBP_ROLE_NONE) {
+		/* Conditional to avoid spurious error messages */
+		qeth_bridgeport_setrole(card, card->options.sbp.role);
+		/* Let the callback function refresh the stored role value. */
+		qeth_bridgeport_query_ports(card, &card->options.sbp.role,
+					    NULL);
+	}
+	if (card->options.sbp.hostnotification) {
+		if (qeth_bridgeport_an_set(card, 1))
+			card->options.sbp.hostnotification = 0;
+	} else {
+		qeth_bridgeport_an_set(card, 0);
+	}
+}
+
 static int qeth_l2_set_online(struct ccwgroup_device *gdev)
 {
 	struct qeth_card *card = dev_get_drvdata(&gdev->dev);
@@ -748,9 +766,11 @@ static int qeth_l2_set_online(struct ccwgroup_device *gdev)
 
 	mutex_lock(&card->sbp_lock);
 	qeth_bridgeport_query_support(card);
-	if (card->options.sbp.supported_funcs)
+	if (card->options.sbp.supported_funcs) {
+		qeth_l2_setup_bridgeport_attrs(card);
 		dev_info(&card->gdev->dev,
-		"The device represents a Bridge Capable Port\n");
+			 "The device represents a Bridge Capable Port\n");
+	}
 	mutex_unlock(&card->sbp_lock);
 
 	qeth_l2_register_dev_addr(card);
@@ -761,8 +781,6 @@ static int qeth_l2_set_online(struct ccwgroup_device *gdev)
 	qeth_trace_features(card);
 	qeth_l2_trace_features(card);
 
-	qeth_l2_setup_bridgeport_attrs(card);
-
 	card->state = CARD_STATE_HARDSETUP;
 	qeth_print_status_message(card);
 
diff --git a/drivers/s390/net/qeth_l2_sys.c b/drivers/s390/net/qeth_l2_sys.c
index 7fa325cf6f8d..86bcae992f72 100644
--- a/drivers/s390/net/qeth_l2_sys.c
+++ b/drivers/s390/net/qeth_l2_sys.c
@@ -246,40 +246,6 @@ static struct attribute_group qeth_l2_bridgeport_attr_group = {
 	.attrs = qeth_l2_bridgeport_attrs,
 };
 
-/**
- * qeth_l2_setup_bridgeport_attrs() - set/restore attrs when turning online.
- * @card:			      qeth_card structure pointer
- *
- * Note: this function is called with conf_mutex held by the caller
- */
-void qeth_l2_setup_bridgeport_attrs(struct qeth_card *card)
-{
-	int rc;
-
-	if (!card)
-		return;
-	if (!card->options.sbp.supported_funcs)
-		return;
-
-	mutex_lock(&card->sbp_lock);
-	if (!card->options.sbp.reflect_promisc &&
-	    card->options.sbp.role != QETH_SBP_ROLE_NONE) {
-		/* Conditional to avoid spurious error messages */
-		qeth_bridgeport_setrole(card, card->options.sbp.role);
-		/* Let the callback function refresh the stored role value. */
-		qeth_bridgeport_query_ports(card,
-			&card->options.sbp.role, NULL);
-	}
-	if (card->options.sbp.hostnotification) {
-		rc = qeth_bridgeport_an_set(card, 1);
-		if (rc)
-			card->options.sbp.hostnotification = 0;
-	} else {
-		qeth_bridgeport_an_set(card, 0);
-	}
-	mutex_unlock(&card->sbp_lock);
-}
-
 /* VNIC CHARS support */
 
 /* convert sysfs attr name to VNIC characteristic */
-- 
2.17.1

