Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A70AC58516
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 17:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbfF0PC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 11:02:28 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10200 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726480AbfF0PC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 11:02:27 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5RF2BmN142483
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 11:02:26 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tcy4rbq3u-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 11:02:17 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 27 Jun 2019 16:01:40 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 27 Jun 2019 16:01:37 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5RF1QIU36635064
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 15:01:26 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8A95A4054;
        Thu, 27 Jun 2019 15:01:35 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C445A4068;
        Thu, 27 Jun 2019 15:01:35 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Jun 2019 15:01:35 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 02/12] s390/qeth: clarify parameter for simple assist cmds
Date:   Thu, 27 Jun 2019 17:01:23 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190627150133.58746-1-jwi@linux.ibm.com>
References: <20190627150133.58746-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19062715-0012-0000-0000-0000032D1637
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062715-0013-0000-0000-0000216654D9
Message-Id: <20190627150133.58746-3-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-27_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906270175
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For code that uses qeth_send_simple_setassparms_prot(), we currently
can't differentiate whether the cmd should contain (1) no parameter, or
(2) a 4-byte parameter with value 0.
At the moment this doesn't cause any trouble. But when using dynamically
allocated cmds, we need to know whether to allocate & transmit an
additional 4 bytes of zeroes.
So instead of the raw parameter value, pass a parameter pointer
(or NULL) to qeth_send_simple_setassparms_prot().

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  6 +++---
 drivers/s390/net/qeth_core_main.c | 15 +++++++--------
 drivers/s390/net/qeth_core_mpc.h  |  2 ++
 drivers/s390/net/qeth_l3_main.c   | 26 ++++++++++++++------------
 4 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 42aa4a21a4c2..35d7b43f6580 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -940,12 +940,12 @@ static inline int qeth_is_diagass_supported(struct qeth_card *card,
 
 int qeth_send_simple_setassparms_prot(struct qeth_card *card,
 				      enum qeth_ipa_funcs ipa_func,
-				      u16 cmd_code, long data,
+				      u16 cmd_code, u32 *data,
 				      enum qeth_prot_versions prot);
 /* IPv4 variant */
 static inline int qeth_send_simple_setassparms(struct qeth_card *card,
 					       enum qeth_ipa_funcs ipa_func,
-					       u16 cmd_code, long data)
+					       u16 cmd_code, u32 *data)
 {
 	return qeth_send_simple_setassparms_prot(card, ipa_func, cmd_code,
 						 data, QETH_PROT_IPV4);
@@ -953,7 +953,7 @@ static inline int qeth_send_simple_setassparms(struct qeth_card *card,
 
 static inline int qeth_send_simple_setassparms_v6(struct qeth_card *card,
 						  enum qeth_ipa_funcs ipa_func,
-						  u16 cmd_code, long data)
+						  u16 cmd_code, u32 *data)
 {
 	return qeth_send_simple_setassparms_prot(card, ipa_func, cmd_code,
 						 data, QETH_PROT_IPV6);
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 84ed772bbfbd..3ba91b1c1315 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -5355,20 +5355,19 @@ EXPORT_SYMBOL_GPL(qeth_get_setassparms_cmd);
 
 int qeth_send_simple_setassparms_prot(struct qeth_card *card,
 				      enum qeth_ipa_funcs ipa_func,
-				      u16 cmd_code, long data,
+				      u16 cmd_code, u32 *data,
 				      enum qeth_prot_versions prot)
 {
-	int length = 0;
+	unsigned int length = data ? SETASS_DATA_SIZEOF(flags_32bit) : 0;
 	struct qeth_cmd_buffer *iob;
 
 	QETH_CARD_TEXT_(card, 4, "simassp%i", prot);
-	if (data)
-		length = sizeof(__u32);
 	iob = qeth_get_setassparms_cmd(card, ipa_func, cmd_code, length, prot);
 	if (!iob)
 		return -ENOMEM;
 
-	__ipa_cmd(iob)->data.setassparms.data.flags_32bit = (__u32) data;
+	if (data)
+		__ipa_cmd(iob)->data.setassparms.data.flags_32bit = *data;
 	return qeth_send_ipa_cmd(card, iob, qeth_setassparms_cb, NULL);
 }
 EXPORT_SYMBOL_GPL(qeth_send_simple_setassparms_prot);
@@ -5885,8 +5884,8 @@ static int qeth_start_csum_cb(struct qeth_card *card, struct qeth_reply *reply,
 static int qeth_set_csum_off(struct qeth_card *card, enum qeth_ipa_funcs cstype,
 			     enum qeth_prot_versions prot)
 {
-	return qeth_send_simple_setassparms_prot(card, cstype,
-						 IPA_CMD_ASS_STOP, 0, prot);
+	return qeth_send_simple_setassparms_prot(card, cstype, IPA_CMD_ASS_STOP,
+						 NULL, prot);
 }
 
 static int qeth_set_csum_on(struct qeth_card *card, enum qeth_ipa_funcs cstype,
@@ -5974,7 +5973,7 @@ static int qeth_set_tso_off(struct qeth_card *card,
 			    enum qeth_prot_versions prot)
 {
 	return qeth_send_simple_setassparms_prot(card, IPA_OUTBOUND_TSO,
-						 IPA_CMD_ASS_STOP, 0, prot);
+						 IPA_CMD_ASS_STOP, NULL, prot);
 }
 
 static int qeth_set_tso_on(struct qeth_card *card,
diff --git a/drivers/s390/net/qeth_core_mpc.h b/drivers/s390/net/qeth_core_mpc.h
index e84249f8803e..61fc4005dd53 100644
--- a/drivers/s390/net/qeth_core_mpc.h
+++ b/drivers/s390/net/qeth_core_mpc.h
@@ -437,6 +437,8 @@ struct qeth_ipacmd_setassparms {
 	} data;
 } __attribute__ ((packed));
 
+#define SETASS_DATA_SIZEOF(field) FIELD_SIZEOF(struct qeth_ipacmd_setassparms,\
+					       data.field)
 
 /* SETRTG IPA Command:    ****************************************************/
 struct qeth_set_routing {
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 81312be8a36b..3de71ed54e92 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -770,7 +770,7 @@ static int qeth_l3_start_ipa_arp_processing(struct qeth_card *card)
 		return 0;
 	}
 	rc = qeth_send_simple_setassparms(card, IPA_ARP_PROCESSING,
-					  IPA_CMD_ASS_START, 0);
+					  IPA_CMD_ASS_START, NULL);
 	if (rc) {
 		dev_warn(&card->gdev->dev,
 			"Starting ARP processing support for %s failed\n",
@@ -793,7 +793,7 @@ static int qeth_l3_start_ipa_source_mac(struct qeth_card *card)
 	}
 
 	rc = qeth_send_simple_setassparms(card, IPA_SOURCE_MAC,
-					  IPA_CMD_ASS_START, 0);
+					  IPA_CMD_ASS_START, NULL);
 	if (rc)
 		dev_warn(&card->gdev->dev,
 			"Starting source MAC-address support for %s failed\n",
@@ -814,7 +814,7 @@ static int qeth_l3_start_ipa_vlan(struct qeth_card *card)
 	}
 
 	rc = qeth_send_simple_setassparms(card, IPA_VLAN_PRIO,
-					  IPA_CMD_ASS_START, 0);
+					  IPA_CMD_ASS_START, NULL);
 	if (rc) {
 		dev_warn(&card->gdev->dev,
 			"Starting VLAN support for %s failed\n",
@@ -839,7 +839,7 @@ static int qeth_l3_start_ipa_multicast(struct qeth_card *card)
 	}
 
 	rc = qeth_send_simple_setassparms(card, IPA_MULTICASTING,
-					  IPA_CMD_ASS_START, 0);
+					  IPA_CMD_ASS_START, NULL);
 	if (rc) {
 		dev_warn(&card->gdev->dev,
 			"Starting multicast support for %s failed\n",
@@ -853,6 +853,7 @@ static int qeth_l3_start_ipa_multicast(struct qeth_card *card)
 
 static int qeth_l3_softsetup_ipv6(struct qeth_card *card)
 {
+	u32 ipv6_data = 3;
 	int rc;
 
 	QETH_CARD_TEXT(card, 3, "softipv6");
@@ -860,16 +861,16 @@ static int qeth_l3_softsetup_ipv6(struct qeth_card *card)
 	if (IS_IQD(card))
 		goto out;
 
-	rc = qeth_send_simple_setassparms(card, IPA_IPV6,
-					  IPA_CMD_ASS_START, 3);
+	rc = qeth_send_simple_setassparms(card, IPA_IPV6, IPA_CMD_ASS_START,
+					  &ipv6_data);
 	if (rc) {
 		dev_err(&card->gdev->dev,
 			"Activating IPv6 support for %s failed\n",
 			QETH_CARD_IFNAME(card));
 		return rc;
 	}
-	rc = qeth_send_simple_setassparms_v6(card, IPA_IPV6,
-					     IPA_CMD_ASS_START, 0);
+	rc = qeth_send_simple_setassparms_v6(card, IPA_IPV6, IPA_CMD_ASS_START,
+					     NULL);
 	if (rc) {
 		dev_err(&card->gdev->dev,
 			"Activating IPv6 support for %s failed\n",
@@ -877,7 +878,7 @@ static int qeth_l3_softsetup_ipv6(struct qeth_card *card)
 		return rc;
 	}
 	rc = qeth_send_simple_setassparms_v6(card, IPA_PASSTHRU,
-					     IPA_CMD_ASS_START, 0);
+					     IPA_CMD_ASS_START, NULL);
 	if (rc) {
 		dev_warn(&card->gdev->dev,
 			"Enabling the passthrough mode for %s failed\n",
@@ -903,6 +904,7 @@ static int qeth_l3_start_ipa_ipv6(struct qeth_card *card)
 
 static int qeth_l3_start_ipa_broadcast(struct qeth_card *card)
 {
+	u32 filter_data = 1;
 	int rc;
 
 	QETH_CARD_TEXT(card, 3, "stbrdcst");
@@ -915,7 +917,7 @@ static int qeth_l3_start_ipa_broadcast(struct qeth_card *card)
 		goto out;
 	}
 	rc = qeth_send_simple_setassparms(card, IPA_FILTERING,
-					  IPA_CMD_ASS_START, 0);
+					  IPA_CMD_ASS_START, NULL);
 	if (rc) {
 		dev_warn(&card->gdev->dev, "Enabling broadcast filtering for "
 			"%s failed\n", QETH_CARD_IFNAME(card));
@@ -923,7 +925,7 @@ static int qeth_l3_start_ipa_broadcast(struct qeth_card *card)
 	}
 
 	rc = qeth_send_simple_setassparms(card, IPA_FILTERING,
-					  IPA_CMD_ASS_CONFIGURE, 1);
+					  IPA_CMD_ASS_CONFIGURE, &filter_data);
 	if (rc) {
 		dev_warn(&card->gdev->dev,
 			"Setting up broadcast filtering for %s failed\n",
@@ -933,7 +935,7 @@ static int qeth_l3_start_ipa_broadcast(struct qeth_card *card)
 	card->info.broadcast_capable = QETH_BROADCAST_WITH_ECHO;
 	dev_info(&card->gdev->dev, "Broadcast enabled\n");
 	rc = qeth_send_simple_setassparms(card, IPA_FILTERING,
-					  IPA_CMD_ASS_ENABLE, 1);
+					  IPA_CMD_ASS_ENABLE, &filter_data);
 	if (rc) {
 		dev_warn(&card->gdev->dev, "Setting up broadcast echo "
 			"filtering for %s failed\n", QETH_CARD_IFNAME(card));
-- 
2.17.1

