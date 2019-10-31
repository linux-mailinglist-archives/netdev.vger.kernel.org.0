Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3ABEB08C
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 13:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbfJaMoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 08:44:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54296 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726540AbfJaMoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 08:44:21 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9VCdOLH105867
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 08:44:20 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vyvwqpny5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 08:43:23 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 31 Oct 2019 12:42:28 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 31 Oct 2019 12:42:26 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9VCgPRZ55902426
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Oct 2019 12:42:25 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 49BC511C04C;
        Thu, 31 Oct 2019 12:42:25 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0930511C052;
        Thu, 31 Oct 2019 12:42:25 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 31 Oct 2019 12:42:24 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 5/8] s390/qeth: consolidate some duplicated HW cmd code
Date:   Thu, 31 Oct 2019 13:42:18 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191031124221.34028-1-jwi@linux.ibm.com>
References: <20191031124221.34028-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19103112-0028-0000-0000-000003B17601
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19103112-0029-0000-0000-00002473BFD4
Message-Id: <20191031124221.34028-6-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-31_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910310131
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When setting a device online, both subdrivers have the same code to
program the HW trap and Isolation mode. Move that code into a single
place.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 10 +++++++++-
 drivers/s390/net/qeth_l2_main.c   | 21 ---------------------
 drivers/s390/net/qeth_l3_main.c   |  9 ---------
 3 files changed, 9 insertions(+), 31 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index d4e66707a03f..d51dcb3c5a01 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -4293,7 +4293,6 @@ int qeth_set_access_ctrl_online(struct qeth_card *card, int fallback)
 	}
 	return rc;
 }
-EXPORT_SYMBOL_GPL(qeth_set_access_ctrl_online);
 
 void qeth_tx_timeout(struct net_device *dev)
 {
@@ -5009,6 +5008,15 @@ int qeth_core_hardsetup_card(struct qeth_card *card, bool *carrier_ok)
 			goto out;
 		}
 	}
+
+	if (!qeth_is_diagass_supported(card, QETH_DIAGS_CMD_TRAP) ||
+	    (card->info.hwtrap && qeth_hw_trap(card, QETH_DIAGS_TRAP_ARM)))
+		card->info.hwtrap = 0;
+
+	rc = qeth_set_access_ctrl_online(card, 0);
+	if (rc)
+		goto out;
+
 	return 0;
 out:
 	dev_warn(&card->gdev->dev, "The qeth device driver failed to recover "
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index bd8143e51747..8f3093d24b12 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -759,14 +759,6 @@ static int qeth_l2_setup_netdev(struct qeth_card *card, bool carrier_ok)
 	return rc;
 }
 
-static int qeth_l2_start_ipassists(struct qeth_card *card)
-{
-	/* configure isolation level */
-	if (qeth_set_access_ctrl_online(card, 0))
-		return -ENODEV;
-	return 0;
-}
-
 static void qeth_l2_trace_features(struct qeth_card *card)
 {
 	/* Set BridgePort features */
@@ -797,13 +789,6 @@ static int qeth_l2_set_online(struct ccwgroup_device *gdev)
 		goto out_remove;
 	}
 
-	if (qeth_is_diagass_supported(card, QETH_DIAGS_CMD_TRAP)) {
-		if (card->info.hwtrap &&
-		    qeth_hw_trap(card, QETH_DIAGS_TRAP_ARM))
-			card->info.hwtrap = 0;
-	} else
-		card->info.hwtrap = 0;
-
 	qeth_bridgeport_query_support(card);
 	if (card->options.sbp.supported_funcs)
 		dev_info(&card->gdev->dev,
@@ -825,12 +810,6 @@ static int qeth_l2_set_online(struct ccwgroup_device *gdev)
 	/* softsetup */
 	QETH_CARD_TEXT(card, 2, "softsetp");
 
-	if (IS_OSD(card) || IS_OSX(card)) {
-		rc = qeth_l2_start_ipassists(card);
-		if (rc)
-			goto out_remove;
-	}
-
 	rc = qeth_init_qdio_queues(card);
 	if (rc) {
 		QETH_CARD_TEXT_(card, 2, "6err%d", rc);
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index d7bfc7a0e4c0..acae44a699ad 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -953,8 +953,6 @@ static int qeth_l3_start_ipassists(struct qeth_card *card)
 {
 	QETH_CARD_TEXT(card, 3, "strtipas");
 
-	if (qeth_set_access_ctrl_online(card, 0))
-		return -EIO;
 	qeth_l3_start_ipa_arp_processing(card);	/* go on*/
 	qeth_l3_start_ipa_source_mac(card);	/* go on*/
 	qeth_l3_start_ipa_vlan(card);		/* go on*/
@@ -2313,13 +2311,6 @@ static int qeth_l3_set_online(struct ccwgroup_device *gdev)
 		goto out_remove;
 	}
 
-	if (qeth_is_diagass_supported(card, QETH_DIAGS_CMD_TRAP)) {
-		if (card->info.hwtrap &&
-		    qeth_hw_trap(card, QETH_DIAGS_TRAP_ARM))
-			card->info.hwtrap = 0;
-	} else
-		card->info.hwtrap = 0;
-
 	card->state = CARD_STATE_HARDSETUP;
 	qeth_print_status_message(card);
 
-- 
2.17.1

