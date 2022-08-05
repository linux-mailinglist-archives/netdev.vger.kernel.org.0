Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50AD658ADE2
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 18:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241029AbiHEQG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 12:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238346AbiHEQG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 12:06:58 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D569F1D32B;
        Fri,  5 Aug 2022 09:06:56 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 275FoZTj019381;
        Fri, 5 Aug 2022 16:06:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=nn38/JSd10xQBvzrd9ZE55APH+Bcgz05es0jtJj5meQ=;
 b=Eks5bpKsl/QTJOW5TpohdD5VNaulmczIY59z+v7RN+nOpJE/kbEKfoF7NXNq7tBWFBb8
 CJqY2Z/jfJzmpUulYPoONtnCFRbJIP8UNrY6ZywzXeSbGwjujCjW16rCtELqBPGHWmN4
 cTu7a6P56i6IrRuk7Fof9waUJkpNYrs0zxQfcicUJzlU9Rwc0lvFxzbu5c3KE17RhGBp
 WMv2n1aEuvNgf/6lRfZMTqO4IM1aVqMgH4kPEm+9FmfLtCgJ7/hOnpUSMyMJF/6otdGt
 aXEg7wIN0z8UHhFhQmLhYWhnyB9nIJqsFC2TwkhHoOW6hy7ge/8PkdKHhckq7C/DcqJD eQ== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hs671ge8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Aug 2022 16:06:42 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 275FrVPW015756;
        Fri, 5 Aug 2022 16:05:50 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com ([9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3hmv98wmxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Aug 2022 16:01:16 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 275FvZSn27328944
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Aug 2022 15:57:35 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2059A405B;
        Fri,  5 Aug 2022 15:57:18 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6FB30A4054;
        Fri,  5 Aug 2022 15:57:18 +0000 (GMT)
Received: from Alexandras-MBP.fritz.box.com (unknown [9.145.46.72])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  5 Aug 2022 15:57:18 +0000 (GMT)
From:   Alexandra Winter <wintera@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>
Subject: [PATCH net v2] s390/qeth: cache link_info for ethtool
Date:   Fri,  5 Aug 2022 17:57:14 +0200
Message-Id: <20220805155714.59609-1-wintera@linux.ibm.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dPXtux6yP78rOFHO1N_9oJ1-oMXZnil5
X-Proofpoint-GUID: dPXtux6yP78rOFHO1N_9oJ1-oMXZnil5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-05_07,2022-08-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 suspectscore=0 clxscore=1015 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 lowpriorityscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208050078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since
commit e6e771b3d897 ("s390/qeth: detach netdevice while card is offline")
there was a timing window during recovery, that qeth_query_card_info could
be sent to the card, even before it was ready for it, leading to a failing
card recovery. There is evidence that this window was hit, as not all
callers of get_link_ksettings() check for netif_device_present.

Use cached values in qeth_get_link_ksettings(), instead of calling
qeth_query_card_info() and falling back to default values in case it
fails. Link info is already updated when the card goes online, e.g. after
STARTLAN (physical link up). Set the link info to default values, when the
card goes offline or at STOPLAN (physical link down). A follow-on patch
will improve values reported for link down.

Fixes: e6e771b3d897 ("s390/qeth: detach netdevice while card is offline")

Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Thorsten Winkler <twinkler@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 168 +++++++++---------------------
 drivers/s390/net/qeth_ethtool.c   |  12 +--
 2 files changed, 48 insertions(+), 132 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 9e54fe76a9b2..026289f644da 100644
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
@@ -4744,92 +4788,6 @@ static int qeth_query_oat_command(struct qeth_card *card, char __user *udata)
 	return rc;
 }
 
-static int qeth_query_card_info_cb(struct qeth_card *card,
-				   struct qeth_reply *reply, unsigned long data)
-{
-	struct qeth_ipa_cmd *cmd = (struct qeth_ipa_cmd *)data;
-	struct qeth_link_info *link_info = reply->param;
-	struct qeth_query_card_info *card_info;
-
-	QETH_CARD_TEXT(card, 2, "qcrdincb");
-	if (qeth_setadpparms_inspect_rc(cmd))
-		return -EIO;
-
-	card_info = &cmd->data.setadapterparms.data.card_info;
-	netdev_dbg(card->dev,
-		   "card info: card_type=0x%02x, port_mode=0x%04x, port_speed=0x%08x\n",
-		   card_info->card_type, card_info->port_mode,
-		   card_info->port_speed);
-
-	switch (card_info->port_mode) {
-	case CARD_INFO_PORTM_FULLDUPLEX:
-		link_info->duplex = DUPLEX_FULL;
-		break;
-	case CARD_INFO_PORTM_HALFDUPLEX:
-		link_info->duplex = DUPLEX_HALF;
-		break;
-	default:
-		link_info->duplex = DUPLEX_UNKNOWN;
-	}
-
-	switch (card_info->card_type) {
-	case CARD_INFO_TYPE_1G_COPPER_A:
-	case CARD_INFO_TYPE_1G_COPPER_B:
-		link_info->speed = SPEED_1000;
-		link_info->port = PORT_TP;
-		break;
-	case CARD_INFO_TYPE_1G_FIBRE_A:
-	case CARD_INFO_TYPE_1G_FIBRE_B:
-		link_info->speed = SPEED_1000;
-		link_info->port = PORT_FIBRE;
-		break;
-	case CARD_INFO_TYPE_10G_FIBRE_A:
-	case CARD_INFO_TYPE_10G_FIBRE_B:
-		link_info->speed = SPEED_10000;
-		link_info->port = PORT_FIBRE;
-		break;
-	default:
-		switch (card_info->port_speed) {
-		case CARD_INFO_PORTS_10M:
-			link_info->speed = SPEED_10;
-			break;
-		case CARD_INFO_PORTS_100M:
-			link_info->speed = SPEED_100;
-			break;
-		case CARD_INFO_PORTS_1G:
-			link_info->speed = SPEED_1000;
-			break;
-		case CARD_INFO_PORTS_10G:
-			link_info->speed = SPEED_10000;
-			break;
-		case CARD_INFO_PORTS_25G:
-			link_info->speed = SPEED_25000;
-			break;
-		default:
-			link_info->speed = SPEED_UNKNOWN;
-		}
-
-		link_info->port = PORT_OTHER;
-	}
-
-	return 0;
-}
-
-int qeth_query_card_info(struct qeth_card *card,
-			 struct qeth_link_info *link_info)
-{
-	struct qeth_cmd_buffer *iob;
-
-	QETH_CARD_TEXT(card, 2, "qcrdinfo");
-	if (!qeth_adp_supported(card, IPA_SETADP_QUERY_CARD_INFO))
-		return -EOPNOTSUPP;
-	iob = qeth_get_adapter_cmd(card, IPA_SETADP_QUERY_CARD_INFO, 0);
-	if (!iob)
-		return -ENOMEM;
-
-	return qeth_send_ipa_cmd(card, iob, qeth_query_card_info_cb, link_info);
-}
-
 static int qeth_init_link_info_oat_cb(struct qeth_card *card,
 				      struct qeth_reply *reply_priv,
 				      unsigned long data)
@@ -4839,6 +4797,7 @@ static int qeth_init_link_info_oat_cb(struct qeth_card *card,
 	struct qeth_query_oat_physical_if *phys_if;
 	struct qeth_query_oat_reply *reply;
 
+	QETH_CARD_TEXT(card, 2, "qoatincb");
 	if (qeth_setadpparms_inspect_rc(cmd))
 		return -EIO;
 
@@ -4918,41 +4877,7 @@ static int qeth_init_link_info_oat_cb(struct qeth_card *card,
 
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
@@ -5461,6 +5386,7 @@ int qeth_set_offline(struct qeth_card *card, const struct qeth_discipline *disc,
 	qeth_clear_working_pool_list(card);
 	qeth_flush_local_addrs(card);
 	card->info.promisc_mode = 0;
+	qeth_default_link_info(card);
 
 	rc  = qeth_stop_channel(&card->data);
 	rc2 = qeth_stop_channel(&card->write);
diff --git a/drivers/s390/net/qeth_ethtool.c b/drivers/s390/net/qeth_ethtool.c
index b0b36b2132fe..9eba0a32e9f9 100644
--- a/drivers/s390/net/qeth_ethtool.c
+++ b/drivers/s390/net/qeth_ethtool.c
@@ -428,8 +428,8 @@ static int qeth_get_link_ksettings(struct net_device *netdev,
 				   struct ethtool_link_ksettings *cmd)
 {
 	struct qeth_card *card = netdev->ml_priv;
-	struct qeth_link_info link_info;
 
+	QETH_CARD_TEXT(card, 4, "ethtglks");
 	cmd->base.speed = card->info.link_info.speed;
 	cmd->base.duplex = card->info.link_info.duplex;
 	cmd->base.port = card->info.link_info.port;
@@ -439,16 +439,6 @@ static int qeth_get_link_ksettings(struct net_device *netdev,
 	cmd->base.eth_tp_mdix = ETH_TP_MDI_INVALID;
 	cmd->base.eth_tp_mdix_ctrl = ETH_TP_MDI_INVALID;
 
-	/* Check if we can obtain more accurate information.	 */
-	if (!qeth_query_card_info(card, &link_info)) {
-		if (link_info.speed != SPEED_UNKNOWN)
-			cmd->base.speed = link_info.speed;
-		if (link_info.duplex != DUPLEX_UNKNOWN)
-			cmd->base.duplex = link_info.duplex;
-		if (link_info.port != PORT_OTHER)
-			cmd->base.port = link_info.port;
-	}
-
 	qeth_set_ethtool_link_modes(cmd, card->info.link_info.link_mode);
 
 	return 0;
-- 
2.24.3 (Apple Git-128)

