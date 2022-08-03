Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32055588ECA
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 16:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiHCOmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 10:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235093AbiHCOmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 10:42:12 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E2710FC1;
        Wed,  3 Aug 2022 07:42:11 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 273DkKPc004151;
        Wed, 3 Aug 2022 14:42:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=kzKTuTnydJNUn7b1tS0ZaQzgBLuC3ZCLQARGQqE2RFg=;
 b=H5p7G6P2A3bTshixxWiRMBTaKhDeVDBE9gXUepS9aB18n22Oku+Xu/OgRfhqHjq5pZBU
 qQ6uw6fW31yn90m8MARyBLpmUq3FP9w073Wt0GGd4hBdhHJ6deFei7zbWkEHFADZTR0N
 evGU1CYqqtQ8mj4MwZf0xjj1pMmV6F8BQ6kpWYdEjaik2tnVf/DrPAfyh/reELv17RDl
 UFpUUiQLVTkCQLlvhyNSCAvyOlvGSNSy4tUIS/1Dj4wOxCauhMJQfE9Iw7/vLCYCMlri
 WTP400GMZSLHbqnsA8R4xQuEhwxMh91rG9wnmgwEyQk3lr6T3wPtpT/+MePGyqfHxage 0w== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hqt6stauy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 14:42:01 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 273EZnQu004618;
        Wed, 3 Aug 2022 14:42:00 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3hmv98n2dy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 14:41:59 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 273EfuRJ9502994
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Aug 2022 14:41:56 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9370A404D;
        Wed,  3 Aug 2022 14:41:56 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A460A4040;
        Wed,  3 Aug 2022 14:41:56 +0000 (GMT)
Received: from Alexandras-MBP.fritz.box.com (unknown [9.145.20.221])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  3 Aug 2022 14:41:56 +0000 (GMT)
From:   Alexandra Winter <wintera@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>
Subject: [PATCH net 2/2] s390/qeth: use cached link_info for ethtool
Date:   Wed,  3 Aug 2022 16:40:15 +0200
Message-Id: <20220803144015.52946-3-wintera@linux.ibm.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20220803144015.52946-1-wintera@linux.ibm.com>
References: <20220803144015.52946-1-wintera@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zdDrE5tf5BKceT0KEQtKRHQFl5ColBtI
X-Proofpoint-ORIG-GUID: zdDrE5tf5BKceT0KEQtKRHQFl5ColBtI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_03,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 malwarescore=0 impostorscore=0 adultscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 priorityscore=1501 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208030066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the cached information is kept up to date, it is no longer necessary to
query the card on each call of get_link_ksettings.
Tools like snmpd, prometheus, sadc or nmbd call get_link_ksettings, so
this has the potential to reduce system load.

This eliminates the need for qeth_query_card_info(). Since
commit e6e771b3d897 ("s390/qeth: detach netdevice while card is offline")
there was a timing window during recovery, that qeth_query_card_info could
be sent to the card, even before it was ready for it, leading to a failing
recovery. There is evidence that this window was hit, as not all callers
of get_link_ksettings() check for netif_device_present.

Fixes: e6e771b3d897 ("s390/qeth: detach netdevice while card is offline")
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Thorsten Winkler <twinkler@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 86 -------------------------------
 drivers/s390/net/qeth_ethtool.c   | 12 +----
 2 files changed, 1 insertion(+), 97 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 05582a7a55e2..10e38fe54bc9 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -4788,92 +4788,6 @@ static int qeth_query_oat_command(struct qeth_card *card, char __user *udata)
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

