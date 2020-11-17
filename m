Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A74642B69B1
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 17:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727633AbgKQQPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 11:15:42 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9402 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727185AbgKQQPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 11:15:37 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AHG1ok6030128;
        Tue, 17 Nov 2020 11:15:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=RnjeJrGCHjyeso3KPfxHC/gsyb7efSKSb6EmVpcK2Qk=;
 b=gKSlt1A6iZ0mrdqZwOFiJNsBjFMNR8N9D5ekXJm69fWfpdBCGZd3R7JEDHdjBLPyoJKT
 bZXdb4HBBcomdt6idaA4SDoXTEgcgohpifAqooc+367MF3uUID3w28LY/lJKP5LKe7i/
 ym/tM9e6CNXrvf/hbDxDuFsN9/ca6F2GPw1tgBiB8jdpSQqna+U79oDnJD/xD1Rs/ZlC
 Z9j0CQh98fnKOLh2LOKJpk9ASX/yLbj/SUrDD108qKUHL8zwstqubmrW2XjS5nCT8zZw
 bIBRwh1mGwLo36Ug/dmB9VkfPFm5b+T3K6W2eOkh/KGxJY74TqgciD68PopZk6R7ECuC Iw== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34vbvqvxr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 11:15:33 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AHG9gL4016372;
        Tue, 17 Nov 2020 16:15:31 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 34v69ur9ub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 16:15:30 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AHGFSRh9896528
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 16:15:28 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE601A405F;
        Tue, 17 Nov 2020 16:15:27 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A35AFA4065;
        Tue, 17 Nov 2020 16:15:27 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 Nov 2020 16:15:27 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 6/9] s390/qeth: set static link info during initialization
Date:   Tue, 17 Nov 2020 17:15:17 +0100
Message-Id: <20201117161520.1089-7-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201117161520.1089-1-jwi@linux.ibm.com>
References: <20201117161520.1089-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_04:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 adultscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170114
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hard-code the minimal link info at initialization time, after we
obtained the link_type. qeth_get_link_ksettings() can still override
this with more accurate data from QUERY CARD INFO later on.

Don't set arbitrary defaults for unknown OSA link types, they
certainly won't match any future type.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  1 +
 drivers/s390/net/qeth_core_main.c | 38 +++++++++++++++++++++++++++++++
 drivers/s390/net/qeth_ethtool.c   | 34 +++------------------------
 3 files changed, 42 insertions(+), 31 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 1c9ed498c2b6..c604e20a5e48 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -738,6 +738,7 @@ struct qeth_card_info {
 	struct qeth_card_blkt blkt;
 	__u32 diagass_support;
 	__u32 hwtrap;
+	struct qeth_link_info link_info;
 };
 
 enum qeth_discipline_id {
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index e7c226c6c989..aac38ade024b 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -4950,6 +4950,42 @@ int qeth_query_card_info(struct qeth_card *card,
 	return qeth_send_ipa_cmd(card, iob, qeth_query_card_info_cb, link_info);
 }
 
+static void qeth_init_link_info(struct qeth_card *card)
+{
+	card->info.link_info.duplex = DUPLEX_FULL;
+
+	if (IS_IQD(card) || IS_VM_NIC(card)) {
+		card->info.link_info.speed = SPEED_10000;
+		card->info.link_info.port = PORT_FIBRE;
+	} else {
+		switch (card->info.link_type) {
+		case QETH_LINK_TYPE_FAST_ETH:
+		case QETH_LINK_TYPE_LANE_ETH100:
+			card->info.link_info.speed = SPEED_100;
+			card->info.link_info.port = PORT_TP;
+			break;
+		case QETH_LINK_TYPE_GBIT_ETH:
+		case QETH_LINK_TYPE_LANE_ETH1000:
+			card->info.link_info.speed = SPEED_1000;
+			card->info.link_info.port = PORT_FIBRE;
+			break;
+		case QETH_LINK_TYPE_10GBIT_ETH:
+			card->info.link_info.speed = SPEED_10000;
+			card->info.link_info.port = PORT_FIBRE;
+			break;
+		case QETH_LINK_TYPE_25GBIT_ETH:
+			card->info.link_info.speed = SPEED_25000;
+			card->info.link_info.port = PORT_FIBRE;
+			break;
+		default:
+			dev_info(&card->gdev->dev, "Unknown link type %x\n",
+				 card->info.link_type);
+			card->info.link_info.speed = SPEED_UNKNOWN;
+			card->info.link_info.port = PORT_OTHER;
+		}
+	}
+}
+
 /**
  * qeth_vm_request_mac() - Request a hypervisor-managed MAC address
  * @card: pointer to a qeth_card
@@ -5334,6 +5370,8 @@ static int qeth_hardsetup_card(struct qeth_card *card, bool *carrier_ok)
 			goto out;
 	}
 
+	qeth_init_link_info(card);
+
 	rc = qeth_init_qdio_queues(card);
 	if (rc) {
 		QETH_CARD_TEXT_(card, 2, "9err%d", rc);
diff --git a/drivers/s390/net/qeth_ethtool.c b/drivers/s390/net/qeth_ethtool.c
index a6455819f403..b8e74018b44f 100644
--- a/drivers/s390/net/qeth_ethtool.c
+++ b/drivers/s390/net/qeth_ethtool.c
@@ -410,44 +410,16 @@ static int qeth_get_link_ksettings(struct net_device *netdev,
 {
 	struct qeth_card *card = netdev->ml_priv;
 	struct qeth_link_info link_info;
-	enum qeth_link_types link_type;
 
-	if (IS_IQD(card) || IS_VM_NIC(card))
-		link_type = QETH_LINK_TYPE_10GBIT_ETH;
-	else
-		link_type = card->info.link_type;
-
-	cmd->base.duplex = DUPLEX_FULL;
+	cmd->base.speed = card->info.link_info.speed;
+	cmd->base.duplex = card->info.link_info.duplex;
+	cmd->base.port = card->info.link_info.port;
 	cmd->base.autoneg = AUTONEG_ENABLE;
 	cmd->base.phy_address = 0;
 	cmd->base.mdio_support = 0;
 	cmd->base.eth_tp_mdix = ETH_TP_MDI_INVALID;
 	cmd->base.eth_tp_mdix_ctrl = ETH_TP_MDI_INVALID;
 
-	switch (link_type) {
-	case QETH_LINK_TYPE_FAST_ETH:
-	case QETH_LINK_TYPE_LANE_ETH100:
-		cmd->base.speed = SPEED_100;
-		cmd->base.port = PORT_TP;
-		break;
-	case QETH_LINK_TYPE_GBIT_ETH:
-	case QETH_LINK_TYPE_LANE_ETH1000:
-		cmd->base.speed = SPEED_1000;
-		cmd->base.port = PORT_FIBRE;
-		break;
-	case QETH_LINK_TYPE_10GBIT_ETH:
-		cmd->base.speed = SPEED_10000;
-		cmd->base.port = PORT_FIBRE;
-		break;
-	case QETH_LINK_TYPE_25GBIT_ETH:
-		cmd->base.speed = SPEED_25000;
-		cmd->base.port = PORT_FIBRE;
-		break;
-	default:
-		cmd->base.speed = SPEED_10;
-		cmd->base.port = PORT_TP;
-	}
-
 	/* Check if we can obtain more accurate information.	 */
 	if (!qeth_query_card_info(card, &link_info)) {
 		if (link_info.speed != SPEED_UNKNOWN)
-- 
2.17.1

