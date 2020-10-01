Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEB22804C4
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 19:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732913AbgJARL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 13:11:59 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38692 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732609AbgJARLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 13:11:55 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 091H3Jxr107865;
        Thu, 1 Oct 2020 13:11:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=YIvrOLdWDKYnN6NrdsvG5ferNh/l0ApIQMdkdQHbOhQ=;
 b=C7hovV2K1W5rPMbfl5Dqen6b+PlJPLAeOo/i8IYuzyqCklBByhOMYrjVXajzoZBEAM7b
 cFzUm+Ig66mFsZxmAqoHvfMgw0pxtt08ftU5mtvaIXYW9vgYlD+eqOS05M0IbXY8oGPU
 oNeyi/vpaXZ83cKdBj/qv14aqzZ7+DkYIBgCNZkj5ZdC6IYf/SOXpRUPWf1aGrNuVuDR
 l3yT6xMf3YzRftCl0a0ELyAp+rVfiTBhKRqilH1KukLHY5heRIqBiC/cQkRpAo8wNRzO
 EPTuMLC0BAmDQOIWTPAu0qNpf3Ug3q1bFpcGIZLV7nkWWuMUGNCMOhAzUkBxb5L0rqta lw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33wjepspx1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Oct 2020 13:11:48 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 091H3fZe001832;
        Thu, 1 Oct 2020 17:11:46 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 33sw985r8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Oct 2020 17:11:46 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 091HBhiQ31785398
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Oct 2020 17:11:43 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A2A59A4057;
        Thu,  1 Oct 2020 17:11:43 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5DD40A4053;
        Thu,  1 Oct 2020 17:11:43 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  1 Oct 2020 17:11:43 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 5/7] s390/qeth: use netdev_name()
Date:   Thu,  1 Oct 2020 19:11:34 +0200
Message-Id: <20201001171136.46830-6-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201001171136.46830-1-jwi@linux.ibm.com>
References: <20201001171136.46830-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-01_06:2020-10-01,2020-10-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501
 malwarescore=0 bulkscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010010144
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace our custom version of netdev_name().

Once we started to allocate the netdev at probe time with
commit d3d1b205e89f ("s390/qeth: allocate netdevice early"), this
stopped working as intended anyway.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  3 --
 drivers/s390/net/qeth_core_main.c |  6 ++--
 drivers/s390/net/qeth_core_sys.c  |  2 +-
 drivers/s390/net/qeth_l2_main.c   |  2 +-
 drivers/s390/net/qeth_l3_main.c   | 58 ++++++++++++++++---------------
 5 files changed, 35 insertions(+), 36 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index e5f47a823a11..39d17ea2eb78 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -892,9 +892,6 @@ struct qeth_trap_id {
 	__u16 devno;
 } __packed;
 
-/*some helper functions*/
-#define QETH_CARD_IFNAME(card) (((card)->dev)? (card)->dev->name : "")
-
 static inline bool qeth_uses_tx_prio_queueing(struct qeth_card *card)
 {
 	return card->qdio.do_prio_queueing != QETH_NO_PRIO_QUEUEING;
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 9e9c229e2780..5fd614278f30 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -915,12 +915,12 @@ static struct qeth_ipa_cmd *qeth_check_ipa_data(struct qeth_card *card,
 		if (cmd->hdr.return_code == IPA_RC_VEPA_TO_VEB_TRANSITION) {
 			dev_err(&card->gdev->dev,
 				"Interface %s is down because the adjacent port is no longer in reflective relay mode\n",
-				QETH_CARD_IFNAME(card));
+				netdev_name(card->dev));
 			schedule_work(&card->close_dev_work);
 		} else {
 			dev_warn(&card->gdev->dev,
 				 "The link for interface %s on CHPID 0x%X failed\n",
-				 QETH_CARD_IFNAME(card), card->info.chpid);
+				 netdev_name(card->dev), card->info.chpid);
 			qeth_issue_ipa_msg(cmd, cmd->hdr.return_code, card);
 			netif_carrier_off(card->dev);
 		}
@@ -928,7 +928,7 @@ static struct qeth_ipa_cmd *qeth_check_ipa_data(struct qeth_card *card,
 	case IPA_CMD_STARTLAN:
 		dev_info(&card->gdev->dev,
 			 "The link for %s on CHPID 0x%X has been restored\n",
-			 QETH_CARD_IFNAME(card), card->info.chpid);
+			 netdev_name(card->dev), card->info.chpid);
 		if (card->info.hwtrap)
 			card->info.hwtrap = 2;
 		qeth_schedule_recovery(card);
diff --git a/drivers/s390/net/qeth_core_sys.c b/drivers/s390/net/qeth_core_sys.c
index 7cc5649dfffe..4441b3393eaf 100644
--- a/drivers/s390/net/qeth_core_sys.c
+++ b/drivers/s390/net/qeth_core_sys.c
@@ -52,7 +52,7 @@ static ssize_t qeth_dev_if_name_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%s\n", QETH_CARD_IFNAME(card));
+	return sprintf(buf, "%s\n", netdev_name(card->dev));
 }
 
 static DEVICE_ATTR(if_name, 0444, qeth_dev_if_name_show, NULL);
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 2e9d3fea60e6..a88d0a01e9a5 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -1372,7 +1372,7 @@ static void qeth_addr_change_event_worker(struct work_struct *work)
 
 		dev_info(&data->card->gdev->dev,
 			 "Address change notification stopped on %s (%s)\n",
-			 data->card->dev->name,
+			 netdev_name(card->dev),
 			(data->ac_event.lost_event_mask == 0x01)
 			? "Overflow"
 			: (data->ac_event.lost_event_mask == 0x02)
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 4db7ded88fc8..e7244aa4d191 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -706,16 +706,16 @@ static int qeth_l3_start_ipa_arp_processing(struct qeth_card *card)
 
 	if (!qeth_is_supported(card, IPA_ARP_PROCESSING)) {
 		dev_info(&card->gdev->dev,
-			"ARP processing not supported on %s!\n",
-			QETH_CARD_IFNAME(card));
+			 "ARP processing not supported on %s!\n",
+			 netdev_name(card->dev));
 		return 0;
 	}
 	rc = qeth_send_simple_setassparms(card, IPA_ARP_PROCESSING,
 					  IPA_CMD_ASS_START, NULL);
 	if (rc) {
 		dev_warn(&card->gdev->dev,
-			"Starting ARP processing support for %s failed\n",
-			QETH_CARD_IFNAME(card));
+			 "Starting ARP processing support for %s failed\n",
+			 netdev_name(card->dev));
 	}
 	return rc;
 }
@@ -728,8 +728,8 @@ static int qeth_l3_start_ipa_source_mac(struct qeth_card *card)
 
 	if (!qeth_is_supported(card, IPA_SOURCE_MAC)) {
 		dev_info(&card->gdev->dev,
-			"Inbound source MAC-address not supported on %s\n",
-			QETH_CARD_IFNAME(card));
+			 "Inbound source MAC-address not supported on %s\n",
+			 netdev_name(card->dev));
 		return -EOPNOTSUPP;
 	}
 
@@ -737,8 +737,8 @@ static int qeth_l3_start_ipa_source_mac(struct qeth_card *card)
 					  IPA_CMD_ASS_START, NULL);
 	if (rc)
 		dev_warn(&card->gdev->dev,
-			"Starting source MAC-address support for %s failed\n",
-			QETH_CARD_IFNAME(card));
+			 "Starting source MAC-address support for %s failed\n",
+			 netdev_name(card->dev));
 	return rc;
 }
 
@@ -750,7 +750,7 @@ static int qeth_l3_start_ipa_vlan(struct qeth_card *card)
 
 	if (!qeth_is_supported(card, IPA_FULL_VLAN)) {
 		dev_info(&card->gdev->dev,
-			"VLAN not supported on %s\n", QETH_CARD_IFNAME(card));
+			 "VLAN not supported on %s\n", netdev_name(card->dev));
 		return -EOPNOTSUPP;
 	}
 
@@ -758,8 +758,8 @@ static int qeth_l3_start_ipa_vlan(struct qeth_card *card)
 					  IPA_CMD_ASS_START, NULL);
 	if (rc) {
 		dev_warn(&card->gdev->dev,
-			"Starting VLAN support for %s failed\n",
-			QETH_CARD_IFNAME(card));
+			 "Starting VLAN support for %s failed\n",
+			 netdev_name(card->dev));
 	} else {
 		dev_info(&card->gdev->dev, "VLAN enabled\n");
 	}
@@ -774,8 +774,8 @@ static int qeth_l3_start_ipa_multicast(struct qeth_card *card)
 
 	if (!qeth_is_supported(card, IPA_MULTICASTING)) {
 		dev_info(&card->gdev->dev,
-			"Multicast not supported on %s\n",
-			QETH_CARD_IFNAME(card));
+			 "Multicast not supported on %s\n",
+			 netdev_name(card->dev));
 		return -EOPNOTSUPP;
 	}
 
@@ -783,8 +783,8 @@ static int qeth_l3_start_ipa_multicast(struct qeth_card *card)
 					  IPA_CMD_ASS_START, NULL);
 	if (rc) {
 		dev_warn(&card->gdev->dev,
-			"Starting multicast support for %s failed\n",
-			QETH_CARD_IFNAME(card));
+			 "Starting multicast support for %s failed\n",
+			 netdev_name(card->dev));
 	} else {
 		dev_info(&card->gdev->dev, "Multicast enabled\n");
 		card->dev->flags |= IFF_MULTICAST;
@@ -807,7 +807,7 @@ static int qeth_l3_softsetup_ipv6(struct qeth_card *card)
 	if (rc) {
 		dev_err(&card->gdev->dev,
 			"Activating IPv6 support for %s failed\n",
-			QETH_CARD_IFNAME(card));
+			netdev_name(card->dev));
 		return rc;
 	}
 	rc = qeth_send_simple_setassparms_v6(card, IPA_IPV6, IPA_CMD_ASS_START,
@@ -815,15 +815,15 @@ static int qeth_l3_softsetup_ipv6(struct qeth_card *card)
 	if (rc) {
 		dev_err(&card->gdev->dev,
 			"Activating IPv6 support for %s failed\n",
-			 QETH_CARD_IFNAME(card));
+			 netdev_name(card->dev));
 		return rc;
 	}
 	rc = qeth_send_simple_setassparms_v6(card, IPA_PASSTHRU,
 					     IPA_CMD_ASS_START, NULL);
 	if (rc) {
 		dev_warn(&card->gdev->dev,
-			"Enabling the passthrough mode for %s failed\n",
-			QETH_CARD_IFNAME(card));
+			 "Enabling the passthrough mode for %s failed\n",
+			 netdev_name(card->dev));
 		return rc;
 	}
 out:
@@ -837,7 +837,7 @@ static int qeth_l3_start_ipa_ipv6(struct qeth_card *card)
 
 	if (!qeth_is_supported(card, IPA_IPV6)) {
 		dev_info(&card->gdev->dev,
-			"IPv6 not supported on %s\n", QETH_CARD_IFNAME(card));
+			 "IPv6 not supported on %s\n", netdev_name(card->dev));
 		return 0;
 	}
 	return qeth_l3_softsetup_ipv6(card);
@@ -852,16 +852,17 @@ static int qeth_l3_start_ipa_broadcast(struct qeth_card *card)
 	card->info.broadcast_capable = 0;
 	if (!qeth_is_supported(card, IPA_FILTERING)) {
 		dev_info(&card->gdev->dev,
-			"Broadcast not supported on %s\n",
-			QETH_CARD_IFNAME(card));
+			 "Broadcast not supported on %s\n",
+			 netdev_name(card->dev));
 		rc = -EOPNOTSUPP;
 		goto out;
 	}
 	rc = qeth_send_simple_setassparms(card, IPA_FILTERING,
 					  IPA_CMD_ASS_START, NULL);
 	if (rc) {
-		dev_warn(&card->gdev->dev, "Enabling broadcast filtering for "
-			"%s failed\n", QETH_CARD_IFNAME(card));
+		dev_warn(&card->gdev->dev,
+			 "Enabling broadcast filtering for %s failed\n",
+			 netdev_name(card->dev));
 		goto out;
 	}
 
@@ -869,8 +870,8 @@ static int qeth_l3_start_ipa_broadcast(struct qeth_card *card)
 					  IPA_CMD_ASS_CONFIGURE, &filter_data);
 	if (rc) {
 		dev_warn(&card->gdev->dev,
-			"Setting up broadcast filtering for %s failed\n",
-			QETH_CARD_IFNAME(card));
+			 "Setting up broadcast filtering for %s failed\n",
+			 netdev_name(card->dev));
 		goto out;
 	}
 	card->info.broadcast_capable = QETH_BROADCAST_WITH_ECHO;
@@ -878,8 +879,9 @@ static int qeth_l3_start_ipa_broadcast(struct qeth_card *card)
 	rc = qeth_send_simple_setassparms(card, IPA_FILTERING,
 					  IPA_CMD_ASS_ENABLE, &filter_data);
 	if (rc) {
-		dev_warn(&card->gdev->dev, "Setting up broadcast echo "
-			"filtering for %s failed\n", QETH_CARD_IFNAME(card));
+		dev_warn(&card->gdev->dev,
+			 "Setting up broadcast echo filtering for %s failed\n",
+			 netdev_name(card->dev));
 		goto out;
 	}
 	card->info.broadcast_capable = QETH_BROADCAST_WITHOUT_ECHO;
-- 
2.17.1

