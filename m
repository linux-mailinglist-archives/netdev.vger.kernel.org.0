Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49A052B69AB
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 17:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbgKQQPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 11:15:41 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11802 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727199AbgKQQPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 11:15:38 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AHG1jrf058146;
        Tue, 17 Nov 2020 11:15:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=MKDdU7u5CAacRKlXh/ttlBz3XmvfI5NCWCJUdv2ip9g=;
 b=htg8Y3XK19Ye4BQcaqYMLYPpA9dGfzSglXwfulx4mEIYQ2b1znJzEVOk8Qe7dvdLCahF
 7kh8wM4HRMXFqGDM0nCwWdZhrs9OxHL6xHzNiFaoltgezhtugGxEdRpclWH6F4sd9xAd
 0S6NGgLb1kYKmYBxkbvilYqC1hGgJ2Z5m4KIc6lNaMxBsE83OJTH1GM/zzfanHOsrvEb
 bCuWL4mmTPTKRsm00sA8lh+zi1VMjVqfegf8esjEUA83O8ZGxNScR5xCnWxyD+u2KHfL
 bPbDHm1D6lYScU0CEDuQSNFXVPZYblSMCYI113+vrDJeynFMmnSwfwGhWsOxp9IwXXTh Bw== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34ve31gq44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 11:15:33 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AHG8Ji6029547;
        Tue, 17 Nov 2020 16:15:32 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 34t6gh9pmq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 16:15:31 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AHGFTSY8192532
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 16:15:29 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5DEDA405F;
        Tue, 17 Nov 2020 16:15:28 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5D45A4060;
        Tue, 17 Nov 2020 16:15:28 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 Nov 2020 16:15:28 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 9/9] s390/qeth: improve selection of ethtool link modes
Date:   Tue, 17 Nov 2020 17:15:20 +0100
Message-Id: <20201117161520.1089-10-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201117161520.1089-1-jwi@linux.ibm.com>
References: <20201117161520.1089-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_04:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011170114
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The link mode is a combination of port speed and port mode. But we
currently only consider the speed, and then typically select the
corresponding TP-based link mode. For 1G and 10G Fibre links this means
we display the wrong link modes.

Move the SPEED_* switch statements inside the PORT_* cases, and only
consider valid combinations where we can select the corresponding
link mode. Add the relevant link modes (1000baseX, 10000baseSR and
1000baseLR) that were introduced back with
commit 5711a9822144 ("net: ethtool: add support for 1000BaseX and missing 10G link modes").

To differentiate between 10000baseSR and 10000baseLR, use the detailed
media_type information that QUERY OAT provides.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |   7 ++
 drivers/s390/net/qeth_core_main.c |  11 +++
 drivers/s390/net/qeth_ethtool.c   | 124 ++++++++++++++++++------------
 3 files changed, 93 insertions(+), 49 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index c604e20a5e48..9e00917286a5 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -701,10 +701,17 @@ enum qeth_pnso_mode {
 	QETH_PNSO_ADDR_INFO,
 };
 
+enum qeth_link_mode {
+	QETH_LINK_MODE_UNKNOWN,
+	QETH_LINK_MODE_FIBRE_SHORT,
+	QETH_LINK_MODE_FIBRE_LONG,
+};
+
 struct qeth_link_info {
 	u32 speed;
 	u8 duplex;
 	u8 port;
+	enum qeth_link_mode link_mode;
 };
 
 #define QETH_BROADCAST_WITH_ECHO    0x01
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 57dad31aab4d..2752a585849d 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -5017,13 +5017,19 @@ static int qeth_init_link_info_oat_cb(struct qeth_card *card,
 	switch (phys_if->media_type) {
 	case QETH_QOAT_PHYS_MEDIA_COPPER:
 		link_info->port = PORT_TP;
+		link_info->link_mode = QETH_LINK_MODE_UNKNOWN;
 		break;
 	case QETH_QOAT_PHYS_MEDIA_FIBRE_SHORT:
+		link_info->port = PORT_FIBRE;
+		link_info->link_mode = QETH_LINK_MODE_FIBRE_SHORT;
+		break;
 	case QETH_QOAT_PHYS_MEDIA_FIBRE_LONG:
 		link_info->port = PORT_FIBRE;
+		link_info->link_mode = QETH_LINK_MODE_FIBRE_LONG;
 		break;
 	default:
 		link_info->port = PORT_OTHER;
+		link_info->link_mode = QETH_LINK_MODE_UNKNOWN;
 		break;
 	}
 
@@ -5037,6 +5043,7 @@ static void qeth_init_link_info(struct qeth_card *card)
 	if (IS_IQD(card) || IS_VM_NIC(card)) {
 		card->info.link_info.speed = SPEED_10000;
 		card->info.link_info.port = PORT_FIBRE;
+		card->info.link_info.link_mode = QETH_LINK_MODE_FIBRE_SHORT;
 	} else {
 		switch (card->info.link_type) {
 		case QETH_LINK_TYPE_FAST_ETH:
@@ -5063,6 +5070,8 @@ static void qeth_init_link_info(struct qeth_card *card)
 			card->info.link_info.speed = SPEED_UNKNOWN;
 			card->info.link_info.port = PORT_OTHER;
 		}
+
+		card->info.link_info.link_mode = QETH_LINK_MODE_UNKNOWN;
 	}
 
 	/* Get more accurate data via QUERY OAT: */
@@ -5088,6 +5097,8 @@ static void qeth_init_link_info(struct qeth_card *card)
 					card->info.link_info.duplex = link_info.duplex;
 				if (link_info.port != PORT_OTHER)
 					card->info.link_info.port = link_info.port;
+				if (link_info.link_mode != QETH_LINK_MODE_UNKNOWN)
+					card->info.link_info.link_mode = link_info.link_mode;
 			}
 		}
 	}
diff --git a/drivers/s390/net/qeth_ethtool.c b/drivers/s390/net/qeth_ethtool.c
index 50b0c1810850..3a51bbff0ffe 100644
--- a/drivers/s390/net/qeth_ethtool.c
+++ b/drivers/s390/net/qeth_ethtool.c
@@ -324,7 +324,8 @@ static int qeth_set_per_queue_coalesce(struct net_device *dev, u32 queue,
 /* Autoneg and full-duplex are supported and advertised unconditionally.     */
 /* Always advertise and support all speeds up to specified, and only one     */
 /* specified port type.							     */
-static void qeth_set_ethtool_link_modes(struct ethtool_link_ksettings *cmd)
+static void qeth_set_ethtool_link_modes(struct ethtool_link_ksettings *cmd,
+					enum qeth_link_mode link_mode)
 {
 	ethtool_link_ksettings_zero_link_mode(cmd, supported);
 	ethtool_link_ksettings_zero_link_mode(cmd, advertising);
@@ -337,58 +338,83 @@ static void qeth_set_ethtool_link_modes(struct ethtool_link_ksettings *cmd)
 	case PORT_TP:
 		ethtool_link_ksettings_add_link_mode(cmd, supported, TP);
 		ethtool_link_ksettings_add_link_mode(cmd, advertising, TP);
+
+		switch (cmd->base.speed) {
+		case SPEED_10000:
+			ethtool_link_ksettings_add_link_mode(cmd, supported,
+							     10000baseT_Full);
+			ethtool_link_ksettings_add_link_mode(cmd, advertising,
+							     10000baseT_Full);
+			fallthrough;
+		case SPEED_1000:
+			ethtool_link_ksettings_add_link_mode(cmd, supported,
+							     1000baseT_Full);
+			ethtool_link_ksettings_add_link_mode(cmd, advertising,
+							     1000baseT_Full);
+			ethtool_link_ksettings_add_link_mode(cmd, supported,
+							     1000baseT_Half);
+			ethtool_link_ksettings_add_link_mode(cmd, advertising,
+							     1000baseT_Half);
+			fallthrough;
+		case SPEED_100:
+			ethtool_link_ksettings_add_link_mode(cmd, supported,
+							     100baseT_Full);
+			ethtool_link_ksettings_add_link_mode(cmd, advertising,
+							     100baseT_Full);
+			ethtool_link_ksettings_add_link_mode(cmd, supported,
+							     100baseT_Half);
+			ethtool_link_ksettings_add_link_mode(cmd, advertising,
+							     100baseT_Half);
+			fallthrough;
+		case SPEED_10:
+			ethtool_link_ksettings_add_link_mode(cmd, supported,
+							     10baseT_Full);
+			ethtool_link_ksettings_add_link_mode(cmd, advertising,
+							     10baseT_Full);
+			ethtool_link_ksettings_add_link_mode(cmd, supported,
+							     10baseT_Half);
+			ethtool_link_ksettings_add_link_mode(cmd, advertising,
+							     10baseT_Half);
+			break;
+		default:
+			break;
+		}
+
 		break;
 	case PORT_FIBRE:
 		ethtool_link_ksettings_add_link_mode(cmd, supported, FIBRE);
 		ethtool_link_ksettings_add_link_mode(cmd, advertising, FIBRE);
-		break;
-	default:
-		break;
-	}
 
-	/* partially does fall through, to also select lower speeds */
-	switch (cmd->base.speed) {
-	case SPEED_25000:
-		ethtool_link_ksettings_add_link_mode(cmd, supported,
-						     25000baseSR_Full);
-		ethtool_link_ksettings_add_link_mode(cmd, advertising,
-						     25000baseSR_Full);
-		break;
-	case SPEED_10000:
-		ethtool_link_ksettings_add_link_mode(cmd, supported,
-						     10000baseT_Full);
-		ethtool_link_ksettings_add_link_mode(cmd, advertising,
-						     10000baseT_Full);
-		fallthrough;
-	case SPEED_1000:
-		ethtool_link_ksettings_add_link_mode(cmd, supported,
-						     1000baseT_Full);
-		ethtool_link_ksettings_add_link_mode(cmd, advertising,
-						     1000baseT_Full);
-		ethtool_link_ksettings_add_link_mode(cmd, supported,
-						     1000baseT_Half);
-		ethtool_link_ksettings_add_link_mode(cmd, advertising,
-						     1000baseT_Half);
-		fallthrough;
-	case SPEED_100:
-		ethtool_link_ksettings_add_link_mode(cmd, supported,
-						     100baseT_Full);
-		ethtool_link_ksettings_add_link_mode(cmd, advertising,
-						     100baseT_Full);
-		ethtool_link_ksettings_add_link_mode(cmd, supported,
-						     100baseT_Half);
-		ethtool_link_ksettings_add_link_mode(cmd, advertising,
-						     100baseT_Half);
-		fallthrough;
-	case SPEED_10:
-		ethtool_link_ksettings_add_link_mode(cmd, supported,
-						     10baseT_Full);
-		ethtool_link_ksettings_add_link_mode(cmd, advertising,
-						     10baseT_Full);
-		ethtool_link_ksettings_add_link_mode(cmd, supported,
-						     10baseT_Half);
-		ethtool_link_ksettings_add_link_mode(cmd, advertising,
-						     10baseT_Half);
+		switch (cmd->base.speed) {
+		case SPEED_25000:
+			ethtool_link_ksettings_add_link_mode(cmd, supported,
+							     25000baseSR_Full);
+			ethtool_link_ksettings_add_link_mode(cmd, advertising,
+							     25000baseSR_Full);
+			break;
+		case SPEED_10000:
+			if (link_mode == QETH_LINK_MODE_FIBRE_LONG) {
+				ethtool_link_ksettings_add_link_mode(cmd, supported,
+								     10000baseLR_Full);
+				ethtool_link_ksettings_add_link_mode(cmd, advertising,
+								     10000baseLR_Full);
+			} else if (link_mode == QETH_LINK_MODE_FIBRE_SHORT) {
+				ethtool_link_ksettings_add_link_mode(cmd, supported,
+								     10000baseSR_Full);
+				ethtool_link_ksettings_add_link_mode(cmd, advertising,
+								     10000baseSR_Full);
+			}
+			break;
+		case SPEED_1000:
+			ethtool_link_ksettings_add_link_mode(cmd, supported,
+							     1000baseX_Full);
+			ethtool_link_ksettings_add_link_mode(cmd, advertising,
+							     1000baseX_Full);
+			break;
+		default:
+			break;
+		}
+
 		break;
 	default:
 		break;
@@ -420,7 +446,7 @@ static int qeth_get_link_ksettings(struct net_device *netdev,
 			cmd->base.port = link_info.port;
 	}
 
-	qeth_set_ethtool_link_modes(cmd);
+	qeth_set_ethtool_link_modes(cmd, card->info.link_info.link_mode);
 
 	return 0;
 }
-- 
2.17.1

