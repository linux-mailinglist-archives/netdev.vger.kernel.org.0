Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4AAF588EC8
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 16:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235709AbiHCOmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 10:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbiHCOmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 10:42:11 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD021117C;
        Wed,  3 Aug 2022 07:42:09 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 273EY1NU020684;
        Wed, 3 Aug 2022 14:42:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=pRKdCBBb4DAI5CXE1Mk7XtLM/sM1SVVfXjAPOjwZiow=;
 b=H+N0SKyAR7g8NDgW3+6SHaneqPRSuszCgYwxMQcKXaVF670FAvjz+RPLjQRNgpUufXAQ
 SWVSyxVU9MruiNQlRNvSml4xW6PD29/BIbM0KBUC7Lh6JNGONVsCASCGTBW027YjlqaF
 Zg/j0BMhc0kAqM8AexZa9DR9sBe4XbjYrdNw4o51LZaNVQqmQK8Nml5LIAkYbjr/vPhE
 L6/ffoxiD5PW+mzCBaLT8ZXRi16r5lwA3weRbIcF8Sn1/WzVNOIw1XmLA9tYxGNdFtyD
 eVnD1LKQRjHGW+hDMO9/M3DKFCF0KtSO8oEa+qChtHbChik/vTSG8gKU6Y7MWJ68lhFv 9g== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hqr6ay5g4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 14:42:00 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 273EZLjM030479;
        Wed, 3 Aug 2022 14:41:58 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3hmv993r5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 14:41:57 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 273Efs4E29229544
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Aug 2022 14:41:54 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4F6EA404D;
        Wed,  3 Aug 2022 14:41:54 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73F64A4040;
        Wed,  3 Aug 2022 14:41:54 +0000 (GMT)
Received: from Alexandras-MBP.fritz.box.com (unknown [9.145.20.221])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  3 Aug 2022 14:41:54 +0000 (GMT)
From:   Alexandra Winter <wintera@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>
Subject: [PATCH net 1/2] s390/qeth: update cached link_info for ethtool
Date:   Wed,  3 Aug 2022 16:40:14 +0200
Message-Id: <20220803144015.52946-2-wintera@linux.ibm.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20220803144015.52946-1-wintera@linux.ibm.com>
References: <20220803144015.52946-1-wintera@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FeO25Zi9iAAX5kEhjzPETYJh7dElW8bd
X-Proofpoint-GUID: FeO25Zi9iAAX5kEhjzPETYJh7dElW8bd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_03,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxscore=0 priorityscore=1501
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208030066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Speed, duplex, port type and link mode can change, after the physical link
goes down (STOPLAN) or the card goes offline, so set them to the default
values for the card type. STARTLAN and set_online initiate a hard setup
that will restore the current values.

Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Thorsten Winkler <twinkler@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 83 ++++++++++++++++++-------------
 1 file changed, 48 insertions(+), 35 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 9e54fe76a9b2..05582a7a55e2 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -763,6 +763,49 @@ static void qeth_issue_ipa_msg(struct qeth_ipa_cmd *cmd, int rc,
 				 ipa_name, com, CARD_DEVID(card));
 }
 
+static void qeth_default_link_info(struct qeth_card *card)
+{
+	struct qeth_link_info *link_info = &card->info.link_info;
+
+	QETH_CARD_TEXT(card, 2, "dftlinfo");
+	link_info->duplex = DUPLEX_FULL;
+
+	if (IS_IQD(card) || IS_VM_NIC(card)) {
+		link_info->speed = SPEED_10000;
+		link_info->port = PORT_FIBRE;
+		link_info->link_mode = QETH_LINK_MODE_FIBRE_SHORT;
+	} else {
+		switch (card->info.link_type) {
+		case QETH_LINK_TYPE_FAST_ETH:
+		case QETH_LINK_TYPE_LANE_ETH100:
+			link_info->speed = SPEED_100;
+			link_info->port = PORT_TP;
+			break;
+		case QETH_LINK_TYPE_GBIT_ETH:
+		case QETH_LINK_TYPE_LANE_ETH1000:
+			link_info->speed = SPEED_1000;
+			link_info->port = PORT_FIBRE;
+			break;
+		case QETH_LINK_TYPE_10GBIT_ETH:
+			link_info->speed = SPEED_10000;
+			link_info->port = PORT_FIBRE;
+			break;
+		case QETH_LINK_TYPE_25GBIT_ETH:
+			link_info->speed = SPEED_25000;
+			link_info->port = PORT_FIBRE;
+			break;
+		default:
+			dev_info(&card->gdev->dev,
+				 "Unknown link type %x\n",
+				 card->info.link_type);
+			link_info->speed = SPEED_UNKNOWN;
+			link_info->port = PORT_OTHER;
+		}
+
+		link_info->link_mode = QETH_LINK_MODE_UNKNOWN;
+	}
+}
+
 static struct qeth_ipa_cmd *qeth_check_ipa_data(struct qeth_card *card,
 						struct qeth_ipa_cmd *cmd)
 {
@@ -790,6 +833,7 @@ static struct qeth_ipa_cmd *qeth_check_ipa_data(struct qeth_card *card,
 				 netdev_name(card->dev), card->info.chpid);
 			qeth_issue_ipa_msg(cmd, cmd->hdr.return_code, card);
 			netif_carrier_off(card->dev);
+			qeth_default_link_info(card);
 		}
 		return NULL;
 	case IPA_CMD_STARTLAN:
@@ -4839,6 +4883,7 @@ static int qeth_init_link_info_oat_cb(struct qeth_card *card,
 	struct qeth_query_oat_physical_if *phys_if;
 	struct qeth_query_oat_reply *reply;
 
+	QETH_CARD_TEXT(card, 2, "qoatincb");
 	if (qeth_setadpparms_inspect_rc(cmd))
 		return -EIO;
 
@@ -4918,41 +4963,7 @@ static int qeth_init_link_info_oat_cb(struct qeth_card *card,
 
 static void qeth_init_link_info(struct qeth_card *card)
 {
-	card->info.link_info.duplex = DUPLEX_FULL;
-
-	if (IS_IQD(card) || IS_VM_NIC(card)) {
-		card->info.link_info.speed = SPEED_10000;
-		card->info.link_info.port = PORT_FIBRE;
-		card->info.link_info.link_mode = QETH_LINK_MODE_FIBRE_SHORT;
-	} else {
-		switch (card->info.link_type) {
-		case QETH_LINK_TYPE_FAST_ETH:
-		case QETH_LINK_TYPE_LANE_ETH100:
-			card->info.link_info.speed = SPEED_100;
-			card->info.link_info.port = PORT_TP;
-			break;
-		case QETH_LINK_TYPE_GBIT_ETH:
-		case QETH_LINK_TYPE_LANE_ETH1000:
-			card->info.link_info.speed = SPEED_1000;
-			card->info.link_info.port = PORT_FIBRE;
-			break;
-		case QETH_LINK_TYPE_10GBIT_ETH:
-			card->info.link_info.speed = SPEED_10000;
-			card->info.link_info.port = PORT_FIBRE;
-			break;
-		case QETH_LINK_TYPE_25GBIT_ETH:
-			card->info.link_info.speed = SPEED_25000;
-			card->info.link_info.port = PORT_FIBRE;
-			break;
-		default:
-			dev_info(&card->gdev->dev, "Unknown link type %x\n",
-				 card->info.link_type);
-			card->info.link_info.speed = SPEED_UNKNOWN;
-			card->info.link_info.port = PORT_OTHER;
-		}
-
-		card->info.link_info.link_mode = QETH_LINK_MODE_UNKNOWN;
-	}
+	qeth_default_link_info(card);
 
 	/* Get more accurate data via QUERY OAT: */
 	if (qeth_adp_supported(card, IPA_SETADP_QUERY_OAT)) {
@@ -5445,6 +5456,8 @@ int qeth_set_offline(struct qeth_card *card, const struct qeth_discipline *disc,
 	/* cancel any stalled cmd that might block the rtnl: */
 	qeth_clear_ipacmd_list(card);
 
+	qeth_default_link_info(card);
+
 	rtnl_lock();
 	card->info.open_when_online = card->dev->flags & IFF_UP;
 	dev_close(card->dev);
-- 
2.24.3 (Apple Git-128)

