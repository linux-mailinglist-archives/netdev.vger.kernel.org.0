Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50FF621F3E2
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbgGNOX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:23:27 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31236 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728722AbgGNOXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 10:23:24 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06EE3dBA180394;
        Tue, 14 Jul 2020 10:23:19 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 329apwfw16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 10:23:19 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06EEFoc9015518;
        Tue, 14 Jul 2020 14:23:17 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3275283e2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 14:23:17 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06EENCUf18874466
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 14:23:13 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC2A14C046;
        Tue, 14 Jul 2020 14:23:12 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88D734C062;
        Tue, 14 Jul 2020 14:23:12 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Jul 2020 14:23:12 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 01/10] s390/qeth: reject unsupported link type earlier
Date:   Tue, 14 Jul 2020 16:22:56 +0200
Message-Id: <20200714142305.29297-2-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200714142305.29297-1-jwi@linux.ibm.com>
References: <20200714142305.29297-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-14_04:2020-07-14,2020-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 mlxscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140104
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rather than delaying the decision until netdev setup, immediately reject
a device when we discover that it has an unsupported link type
(ie. Token Ring).

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 38 ++++++++++++++++++++++---------
 drivers/s390/net/qeth_l3_main.c   |  6 -----
 2 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 88e998de2d03..c0f551602a5a 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -2436,6 +2436,17 @@ static int qeth_cm_setup(struct qeth_card *card)
 	return qeth_send_control_data(card, iob, qeth_cm_setup_cb, NULL);
 }
 
+static bool qeth_is_supported_link_type(struct qeth_card *card, u8 link_type)
+{
+	if (link_type == QETH_LINK_TYPE_LANE_TR ||
+	    link_type == QETH_LINK_TYPE_HSTR) {
+		dev_err(&card->gdev->dev, "Unsupported Token Ring device\n");
+		return false;
+	}
+
+	return true;
+}
+
 static int qeth_update_max_mtu(struct qeth_card *card, unsigned int max_mtu)
 {
 	struct net_device *dev = card->dev;
@@ -2495,8 +2506,8 @@ static int qeth_ulp_enable_cb(struct qeth_card *card, struct qeth_reply *reply,
 {
 	__u16 mtu, framesize;
 	__u16 len;
-	__u8 link_type;
 	struct qeth_cmd_buffer *iob;
+	u8 link_type = 0;
 
 	QETH_CARD_TEXT(card, 2, "ulpenacb");
 
@@ -2516,9 +2527,11 @@ static int qeth_ulp_enable_cb(struct qeth_card *card, struct qeth_reply *reply,
 	if (len >= QETH_MPC_DIFINFO_LEN_INDICATES_LINK_TYPE) {
 		memcpy(&link_type,
 		       QETH_ULP_ENABLE_RESP_LINK_TYPE(iob->data), 1);
-		card->info.link_type = link_type;
-	} else
-		card->info.link_type = 0;
+		if (!qeth_is_supported_link_type(card, link_type))
+			return -EPROTONOSUPPORT;
+	}
+
+	card->info.link_type = link_type;
 	QETH_CARD_TEXT_(card, 2, "link%d", card->info.link_type);
 	return 0;
 }
@@ -3100,7 +3113,6 @@ struct qeth_cmd_buffer *qeth_ipa_alloc_cmd(struct qeth_card *card,
 					   enum qeth_prot_versions prot,
 					   unsigned int data_length)
 {
-	enum qeth_link_types link_type = card->info.link_type;
 	struct qeth_cmd_buffer *iob;
 	struct qeth_ipacmd_hdr *hdr;
 
@@ -3116,7 +3128,7 @@ struct qeth_cmd_buffer *qeth_ipa_alloc_cmd(struct qeth_card *card,
 	hdr->command = cmd_code;
 	hdr->initiator = IPA_CMD_INITIATOR_HOST;
 	/* hdr->seqno is set by qeth_send_control_data() */
-	hdr->adapter_type = (link_type == QETH_LINK_TYPE_HSTR) ? 2 : 1;
+	hdr->adapter_type = QETH_LINK_TYPE_FAST_ETH;
 	hdr->rel_adapter_no = (u8) card->dev->dev_port;
 	hdr->prim_version_no = IS_LAYER2(card) ? 2 : 1;
 	hdr->param_count = 1;
@@ -3199,18 +3211,22 @@ static int qeth_query_setadapterparms_cb(struct qeth_card *card,
 		struct qeth_reply *reply, unsigned long data)
 {
 	struct qeth_ipa_cmd *cmd = (struct qeth_ipa_cmd *) data;
+	struct qeth_query_cmds_supp *query_cmd;
 
 	QETH_CARD_TEXT(card, 3, "quyadpcb");
 	if (qeth_setadpparms_inspect_rc(cmd))
 		return -EIO;
 
-	if (cmd->data.setadapterparms.data.query_cmds_supp.lan_type & 0x7f) {
-		card->info.link_type =
-		      cmd->data.setadapterparms.data.query_cmds_supp.lan_type;
+	query_cmd = &cmd->data.setadapterparms.data.query_cmds_supp;
+	if (query_cmd->lan_type & 0x7f) {
+		if (!qeth_is_supported_link_type(card, query_cmd->lan_type))
+			return -EPROTONOSUPPORT;
+
+		card->info.link_type = query_cmd->lan_type;
 		QETH_CARD_TEXT_(card, 2, "lnk %d", card->info.link_type);
 	}
-	card->options.adp.supported =
-		cmd->data.setadapterparms.data.query_cmds_supp.supported_cmds;
+
+	card->options.adp.supported = query_cmd->supported_cmds;
 	return 0;
 }
 
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 1e50aa0297a3..d4ce653ff111 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1919,12 +1919,6 @@ static int qeth_l3_setup_netdev(struct qeth_card *card)
 		return rc;
 
 	if (IS_OSD(card) || IS_OSX(card)) {
-		if ((card->info.link_type == QETH_LINK_TYPE_LANE_TR) ||
-		    (card->info.link_type == QETH_LINK_TYPE_HSTR)) {
-			pr_info("qeth_l3: ignoring TR device\n");
-			return -ENODEV;
-		}
-
 		card->dev->netdev_ops = &qeth_l3_osa_netdev_ops;
 
 		/*IPv6 address autoconfiguration stuff*/
-- 
2.17.1

