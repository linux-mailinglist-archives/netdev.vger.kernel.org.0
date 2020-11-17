Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3812B69AF
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 17:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727645AbgKQQPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 11:15:43 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16460 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727198AbgKQQPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 11:15:38 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AHG2goh075317;
        Tue, 17 Nov 2020 11:15:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=V30RCSN1pwZyfjofjGc2HE8oqaIDlOBntnBPLnSJ/7g=;
 b=KVXNpJc1xXIcftENwv9u23Ihq7LlDbLs6Q0VQvrQo+U5XTtKs7oDmCDUsJ8w1lV0pKko
 9uhneBKXs4s8N+KhIT5SDE+ipZ/rUf7n5IK3V3oU0wZ+0wfyL6gDSopUrzhtR/DMFG+5
 mnxVwC0ij3s5u6gn3Dh/KJf09BvdKGZO6GuCL7mVYFQV9vCVLH9pkWTL2a5CUWvaH5aG
 ysC61HymqowxGOAssuBwMfPlS+93K2pgHbS63aMaHsuuG/X9tyPQTSQvuaWXyH3GTNwf
 8EA4iTobXt/T0aeCetZUK1cxqJBDNgae9kjFpCtJS8Ffvu4Um2UacefL2YHAG547hkBb gQ== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34vd4q2he5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 11:15:32 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AHG6ijU003969;
        Tue, 17 Nov 2020 16:15:30 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 34t6v8b8yr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 16:15:30 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AHGFREn1966678
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 16:15:27 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C31BA405F;
        Tue, 17 Nov 2020 16:15:27 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D21CA4060;
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
Subject: [PATCH net-next 5/9] s390/qeth: improve QUERY CARD INFO processing
Date:   Tue, 17 Nov 2020 17:15:16 +0100
Message-Id: <20201117161520.1089-6-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201117161520.1089-1-jwi@linux.ibm.com>
References: <20201117161520.1089-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_04:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170114
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move all the HW reply data parsing into qeth_query_card_info_cb(), and
use common ethtool enums for transporting the information back to the
caller.

Also only look at the .port_speed field when we couldn't determine the
speed from the .card_type field, and introduce some 'default' cases for
SPEED_UNKNOWN, PORT_OTHER and DUPLEX_UNKNOWN.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      | 14 +++---
 drivers/s390/net/qeth_core_main.c | 67 +++++++++++++++++++++++++---
 drivers/s390/net/qeth_ethtool.c   | 74 +++++--------------------------
 3 files changed, 79 insertions(+), 76 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index ec4525bd62e1..1c9ed498c2b6 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -701,6 +701,12 @@ enum qeth_pnso_mode {
 	QETH_PNSO_ADDR_INFO,
 };
 
+struct qeth_link_info {
+	u32 speed;
+	u8 duplex;
+	u8 port;
+};
+
 #define QETH_BROADCAST_WITH_ECHO    0x01
 #define QETH_BROADCAST_WITHOUT_ECHO 0x02
 struct qeth_card_info {
@@ -796,12 +802,6 @@ struct qeth_rx {
 	u8 bufs_refill;
 };
 
-struct carrier_info {
-	__u8  card_type;
-	__u16 port_mode;
-	__u32 port_speed;
-};
-
 struct qeth_switch_info {
 	__u32 capabilities;
 	__u32 settings;
@@ -1108,7 +1108,7 @@ void qeth_prepare_ipa_cmd(struct qeth_card *card, struct qeth_cmd_buffer *iob,
 int qeth_query_switch_attributes(struct qeth_card *card,
 				  struct qeth_switch_info *sw_info);
 int qeth_query_card_info(struct qeth_card *card,
-			 struct carrier_info *carrier_info);
+			 struct qeth_link_info *link_info);
 int qeth_setadpparms_set_access_ctrl(struct qeth_card *card,
 				     enum qeth_ipa_isolation_modes mode);
 
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 67e5c46e8373..e7c226c6c989 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -4867,8 +4867,8 @@ static int qeth_query_oat_command(struct qeth_card *card, char __user *udata)
 static int qeth_query_card_info_cb(struct qeth_card *card,
 				   struct qeth_reply *reply, unsigned long data)
 {
-	struct carrier_info *carrier_info = (struct carrier_info *)reply->param;
 	struct qeth_ipa_cmd *cmd = (struct qeth_ipa_cmd *)data;
+	struct qeth_link_info *link_info = reply->param;
 	struct qeth_query_card_info *card_info;
 
 	QETH_CARD_TEXT(card, 2, "qcrdincb");
@@ -4876,14 +4876,67 @@ static int qeth_query_card_info_cb(struct qeth_card *card,
 		return -EIO;
 
 	card_info = &cmd->data.setadapterparms.data.card_info;
-	carrier_info->card_type = card_info->card_type;
-	carrier_info->port_mode = card_info->port_mode;
-	carrier_info->port_speed = card_info->port_speed;
+	netdev_dbg(card->dev,
+		   "card info: card_type=0x%02x, port_mode=0x%04x, port_speed=0x%08x\n",
+		   card_info->card_type, card_info->port_mode,
+		   card_info->port_speed);
+
+	switch (card_info->port_mode) {
+	case CARD_INFO_PORTM_FULLDUPLEX:
+		link_info->duplex = DUPLEX_FULL;
+		break;
+	case CARD_INFO_PORTM_HALFDUPLEX:
+		link_info->duplex = DUPLEX_HALF;
+		break;
+	default:
+		link_info->duplex = DUPLEX_UNKNOWN;
+	}
+
+	switch (card_info->card_type) {
+	case CARD_INFO_TYPE_1G_COPPER_A:
+	case CARD_INFO_TYPE_1G_COPPER_B:
+		link_info->speed = SPEED_1000;
+		link_info->port = PORT_TP;
+		break;
+	case CARD_INFO_TYPE_1G_FIBRE_A:
+	case CARD_INFO_TYPE_1G_FIBRE_B:
+		link_info->speed = SPEED_1000;
+		link_info->port = PORT_FIBRE;
+		break;
+	case CARD_INFO_TYPE_10G_FIBRE_A:
+	case CARD_INFO_TYPE_10G_FIBRE_B:
+		link_info->speed = SPEED_10000;
+		link_info->port = PORT_FIBRE;
+		break;
+	default:
+		switch (card_info->port_speed) {
+		case CARD_INFO_PORTS_10M:
+			link_info->speed = SPEED_10;
+			break;
+		case CARD_INFO_PORTS_100M:
+			link_info->speed = SPEED_100;
+			break;
+		case CARD_INFO_PORTS_1G:
+			link_info->speed = SPEED_1000;
+			break;
+		case CARD_INFO_PORTS_10G:
+			link_info->speed = SPEED_10000;
+			break;
+		case CARD_INFO_PORTS_25G:
+			link_info->speed = SPEED_25000;
+			break;
+		default:
+			link_info->speed = SPEED_UNKNOWN;
+		}
+
+		link_info->port = PORT_OTHER;
+	}
+
 	return 0;
 }
 
 int qeth_query_card_info(struct qeth_card *card,
-			 struct carrier_info *carrier_info)
+			 struct qeth_link_info *link_info)
 {
 	struct qeth_cmd_buffer *iob;
 
@@ -4893,8 +4946,8 @@ int qeth_query_card_info(struct qeth_card *card,
 	iob = qeth_get_adapter_cmd(card, IPA_SETADP_QUERY_CARD_INFO, 0);
 	if (!iob)
 		return -ENOMEM;
-	return qeth_send_ipa_cmd(card, iob, qeth_query_card_info_cb,
-					(void *)carrier_info);
+
+	return qeth_send_ipa_cmd(card, iob, qeth_query_card_info_cb, link_info);
 }
 
 /**
diff --git a/drivers/s390/net/qeth_ethtool.c b/drivers/s390/net/qeth_ethtool.c
index b843df2c14b1..a6455819f403 100644
--- a/drivers/s390/net/qeth_ethtool.c
+++ b/drivers/s390/net/qeth_ethtool.c
@@ -324,8 +324,7 @@ static int qeth_set_per_queue_coalesce(struct net_device *dev, u32 queue,
 /* Autoneg and full-duplex are supported and advertised unconditionally.     */
 /* Always advertise and support all speeds up to specified, and only one     */
 /* specified port type.							     */
-static void qeth_set_cmd_adv_sup(struct ethtool_link_ksettings *cmd,
-				int maxspeed, int porttype)
+static void qeth_set_ethtool_link_modes(struct ethtool_link_ksettings *cmd)
 {
 	ethtool_link_ksettings_zero_link_mode(cmd, supported);
 	ethtool_link_ksettings_zero_link_mode(cmd, advertising);
@@ -334,7 +333,7 @@ static void qeth_set_cmd_adv_sup(struct ethtool_link_ksettings *cmd,
 	ethtool_link_ksettings_add_link_mode(cmd, supported, Autoneg);
 	ethtool_link_ksettings_add_link_mode(cmd, advertising, Autoneg);
 
-	switch (porttype) {
+	switch (cmd->base.port) {
 	case PORT_TP:
 		ethtool_link_ksettings_add_link_mode(cmd, supported, TP);
 		ethtool_link_ksettings_add_link_mode(cmd, advertising, TP);
@@ -350,7 +349,7 @@ static void qeth_set_cmd_adv_sup(struct ethtool_link_ksettings *cmd,
 	}
 
 	/* partially does fall through, to also select lower speeds */
-	switch (maxspeed) {
+	switch (cmd->base.speed) {
 	case SPEED_25000:
 		ethtool_link_ksettings_add_link_mode(cmd, supported,
 						     25000baseSR_Full);
@@ -406,13 +405,12 @@ static void qeth_set_cmd_adv_sup(struct ethtool_link_ksettings *cmd,
 	}
 }
 
-
 static int qeth_get_link_ksettings(struct net_device *netdev,
 				   struct ethtool_link_ksettings *cmd)
 {
 	struct qeth_card *card = netdev->ml_priv;
+	struct qeth_link_info link_info;
 	enum qeth_link_types link_type;
-	struct carrier_info carrier_info;
 
 	if (IS_IQD(card) || IS_VM_NIC(card))
 		link_type = QETH_LINK_TYPE_10GBIT_ETH;
@@ -449,66 +447,18 @@ static int qeth_get_link_ksettings(struct net_device *netdev,
 		cmd->base.speed = SPEED_10;
 		cmd->base.port = PORT_TP;
 	}
-	qeth_set_cmd_adv_sup(cmd, cmd->base.speed, cmd->base.port);
 
 	/* Check if we can obtain more accurate information.	 */
-	/* If QUERY_CARD_INFO command is not supported or fails, */
-	/* just return the heuristics that was filled above.	 */
-	if (qeth_query_card_info(card, &carrier_info))
-		return 0;
-
-	netdev_dbg(netdev,
-	"card info: card_type=0x%02x, port_mode=0x%04x, port_speed=0x%08x\n",
-			carrier_info.card_type,
-			carrier_info.port_mode,
-			carrier_info.port_speed);
-
-	/* Update attributes for which we've obtained more authoritative */
-	/* information, leave the rest the way they where filled above.  */
-	switch (carrier_info.card_type) {
-	case CARD_INFO_TYPE_1G_COPPER_A:
-	case CARD_INFO_TYPE_1G_COPPER_B:
-		cmd->base.port = PORT_TP;
-		qeth_set_cmd_adv_sup(cmd, SPEED_1000, cmd->base.port);
-		break;
-	case CARD_INFO_TYPE_1G_FIBRE_A:
-	case CARD_INFO_TYPE_1G_FIBRE_B:
-		cmd->base.port = PORT_FIBRE;
-		qeth_set_cmd_adv_sup(cmd, SPEED_1000, cmd->base.port);
-		break;
-	case CARD_INFO_TYPE_10G_FIBRE_A:
-	case CARD_INFO_TYPE_10G_FIBRE_B:
-		cmd->base.port = PORT_FIBRE;
-		qeth_set_cmd_adv_sup(cmd, SPEED_10000, cmd->base.port);
-		break;
-	}
-
-	switch (carrier_info.port_mode) {
-	case CARD_INFO_PORTM_FULLDUPLEX:
-		cmd->base.duplex = DUPLEX_FULL;
-		break;
-	case CARD_INFO_PORTM_HALFDUPLEX:
-		cmd->base.duplex = DUPLEX_HALF;
-		break;
+	if (!qeth_query_card_info(card, &link_info)) {
+		if (link_info.speed != SPEED_UNKNOWN)
+			cmd->base.speed = link_info.speed;
+		if (link_info.duplex != DUPLEX_UNKNOWN)
+			cmd->base.duplex = link_info.duplex;
+		if (link_info.port != PORT_OTHER)
+			cmd->base.port = link_info.port;
 	}
 
-	switch (carrier_info.port_speed) {
-	case CARD_INFO_PORTS_10M:
-		cmd->base.speed = SPEED_10;
-		break;
-	case CARD_INFO_PORTS_100M:
-		cmd->base.speed = SPEED_100;
-		break;
-	case CARD_INFO_PORTS_1G:
-		cmd->base.speed = SPEED_1000;
-		break;
-	case CARD_INFO_PORTS_10G:
-		cmd->base.speed = SPEED_10000;
-		break;
-	case CARD_INFO_PORTS_25G:
-		cmd->base.speed = SPEED_25000;
-		break;
-	}
+	qeth_set_ethtool_link_modes(cmd);
 
 	return 0;
 }
-- 
2.17.1

