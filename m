Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B732B69B5
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 17:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727621AbgKQQPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 11:15:42 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56318 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727012AbgKQQPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 11:15:38 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AHG2FgY082316;
        Tue, 17 Nov 2020 11:15:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=74gRmiDGztpQqlcrBeEfrUlJ5BqCHhRXtbqjU1BNGbc=;
 b=Y4XNkML6K4SZf+3ak6v/tp3nlca2EVIA7jTSm1gMCfwM7+06N4F5+C1hsdOlJjPOwGd9
 zquleOMN4Sa7XP9/RwtX63KIqUekrghX3dwz7FGoHgrQ+eoaRbhXba3IifmFfdQzLGH1
 8jqn2xW1Gq22yLH9mmjgZ74WVfd11U39Y1HeD00b5TsFjCrxKmsZbZbBzdWXF/I/CQzB
 LcJm4t+S3x88YHYqkxrUrFvcQLsLMh+zUabQ5Dhp7rbSdNyVWaRLEEc5o3+RnAxEF7QB
 qNaQH78MtYM+AWUyU7SsSgoBbEunUWKVO8wirjp1nDqfmtndV8146KX8PNfdRlpAxPrR 9w== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34v3yfeqeq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 11:15:33 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AHG8USt001066;
        Tue, 17 Nov 2020 16:15:31 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 34t6v8b3aq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 16:15:31 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AHGFSJ46357640
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 16:15:28 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F01CA4054;
        Tue, 17 Nov 2020 16:15:28 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53D47A4068;
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
Subject: [PATCH net-next 8/9] s390/qeth: use QUERY OAT for initial link info
Date:   Tue, 17 Nov 2020 17:15:19 +0100
Message-Id: <20201117161520.1089-9-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201117161520.1089-1-jwi@linux.ibm.com>
References: <20201117161520.1089-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_04:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 adultscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 priorityscore=1501 malwarescore=0 suspectscore=0 mlxscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170114
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Improve the initial link info with data obtained from QUERY OAT.
Doing so _only_ at initialization time avoids
1. dealing with multi-part replies, and
2. sifting through all the data that may get returned at runtime.

This allows us to determine the correct port type for the 1000BT variant
of recent OSA adapter generations (where the .card_type field in
QUERY CARD INFO is no longer sufficient).

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 107 ++++++++++++++++++++++++++++++
 drivers/s390/net/qeth_core_mpc.h  |  40 ++++++++++-
 2 files changed, 145 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index aac38ade024b..57dad31aab4d 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -4950,6 +4950,86 @@ int qeth_query_card_info(struct qeth_card *card,
 	return qeth_send_ipa_cmd(card, iob, qeth_query_card_info_cb, link_info);
 }
 
+static int qeth_init_link_info_oat_cb(struct qeth_card *card,
+				      struct qeth_reply *reply_priv,
+				      unsigned long data)
+{
+	struct qeth_ipa_cmd *cmd = (struct qeth_ipa_cmd *)data;
+	struct qeth_link_info *link_info = reply_priv->param;
+	struct qeth_query_oat_physical_if *phys_if;
+	struct qeth_query_oat_reply *reply;
+
+	if (qeth_setadpparms_inspect_rc(cmd))
+		return -EIO;
+
+	/* Multi-part reply is unexpected, don't bother: */
+	if (cmd->data.setadapterparms.hdr.used_total > 1)
+		return -EINVAL;
+
+	/* Expect the reply to start with phys_if data: */
+	reply = &cmd->data.setadapterparms.data.query_oat.reply[0];
+	if (reply->type != QETH_QOAT_REPLY_TYPE_PHYS_IF ||
+	    reply->length < sizeof(*reply))
+		return -EINVAL;
+
+	phys_if = &reply->phys_if;
+
+	switch (phys_if->speed_duplex) {
+	case QETH_QOAT_PHYS_SPEED_10M_HALF:
+		link_info->speed = SPEED_10;
+		link_info->duplex = DUPLEX_HALF;
+		break;
+	case QETH_QOAT_PHYS_SPEED_10M_FULL:
+		link_info->speed = SPEED_10;
+		link_info->duplex = DUPLEX_FULL;
+		break;
+	case QETH_QOAT_PHYS_SPEED_100M_HALF:
+		link_info->speed = SPEED_100;
+		link_info->duplex = DUPLEX_HALF;
+		break;
+	case QETH_QOAT_PHYS_SPEED_100M_FULL:
+		link_info->speed = SPEED_100;
+		link_info->duplex = DUPLEX_FULL;
+		break;
+	case QETH_QOAT_PHYS_SPEED_1000M_HALF:
+		link_info->speed = SPEED_1000;
+		link_info->duplex = DUPLEX_HALF;
+		break;
+	case QETH_QOAT_PHYS_SPEED_1000M_FULL:
+		link_info->speed = SPEED_1000;
+		link_info->duplex = DUPLEX_FULL;
+		break;
+	case QETH_QOAT_PHYS_SPEED_10G_FULL:
+		link_info->speed = SPEED_10000;
+		link_info->duplex = DUPLEX_FULL;
+		break;
+	case QETH_QOAT_PHYS_SPEED_25G_FULL:
+		link_info->speed = SPEED_25000;
+		link_info->duplex = DUPLEX_FULL;
+		break;
+	case QETH_QOAT_PHYS_SPEED_UNKNOWN:
+	default:
+		link_info->speed = SPEED_UNKNOWN;
+		link_info->duplex = DUPLEX_UNKNOWN;
+		break;
+	}
+
+	switch (phys_if->media_type) {
+	case QETH_QOAT_PHYS_MEDIA_COPPER:
+		link_info->port = PORT_TP;
+		break;
+	case QETH_QOAT_PHYS_MEDIA_FIBRE_SHORT:
+	case QETH_QOAT_PHYS_MEDIA_FIBRE_LONG:
+		link_info->port = PORT_FIBRE;
+		break;
+	default:
+		link_info->port = PORT_OTHER;
+		break;
+	}
+
+	return 0;
+}
+
 static void qeth_init_link_info(struct qeth_card *card)
 {
 	card->info.link_info.duplex = DUPLEX_FULL;
@@ -4984,6 +5064,33 @@ static void qeth_init_link_info(struct qeth_card *card)
 			card->info.link_info.port = PORT_OTHER;
 		}
 	}
+
+	/* Get more accurate data via QUERY OAT: */
+	if (qeth_adp_supported(card, IPA_SETADP_QUERY_OAT)) {
+		struct qeth_link_info link_info;
+		struct qeth_cmd_buffer *iob;
+
+		iob = qeth_get_adapter_cmd(card, IPA_SETADP_QUERY_OAT,
+					   SETADP_DATA_SIZEOF(query_oat));
+		if (iob) {
+			struct qeth_ipa_cmd *cmd = __ipa_cmd(iob);
+			struct qeth_query_oat *oat_req;
+
+			oat_req = &cmd->data.setadapterparms.data.query_oat;
+			oat_req->subcmd_code = QETH_QOAT_SCOPE_INTERFACE;
+
+			if (!qeth_send_ipa_cmd(card, iob,
+					       qeth_init_link_info_oat_cb,
+					       &link_info)) {
+				if (link_info.speed != SPEED_UNKNOWN)
+					card->info.link_info.speed = link_info.speed;
+				if (link_info.duplex != DUPLEX_UNKNOWN)
+					card->info.link_info.duplex = link_info.duplex;
+				if (link_info.port != PORT_OTHER)
+					card->info.link_info.port = link_info.port;
+			}
+		}
+	}
 }
 
 /**
diff --git a/drivers/s390/net/qeth_core_mpc.h b/drivers/s390/net/qeth_core_mpc.h
index 6541bab96822..e4bde7daf083 100644
--- a/drivers/s390/net/qeth_core_mpc.h
+++ b/drivers/s390/net/qeth_core_mpc.h
@@ -489,9 +489,45 @@ struct qeth_set_access_ctrl {
 	__u8 reserved[8];
 } __attribute__((packed));
 
+#define QETH_QOAT_PHYS_SPEED_UNKNOWN		0x00
+#define QETH_QOAT_PHYS_SPEED_10M_HALF		0x01
+#define QETH_QOAT_PHYS_SPEED_10M_FULL		0x02
+#define QETH_QOAT_PHYS_SPEED_100M_HALF		0x03
+#define QETH_QOAT_PHYS_SPEED_100M_FULL		0x04
+#define QETH_QOAT_PHYS_SPEED_1000M_HALF		0x05
+#define QETH_QOAT_PHYS_SPEED_1000M_FULL		0x06
+// n/a						0x07
+#define QETH_QOAT_PHYS_SPEED_10G_FULL		0x08
+// n/a						0x09
+#define QETH_QOAT_PHYS_SPEED_25G_FULL		0x0A
+
+#define QETH_QOAT_PHYS_MEDIA_COPPER		0x01
+#define QETH_QOAT_PHYS_MEDIA_FIBRE_SHORT	0x02
+#define QETH_QOAT_PHYS_MEDIA_FIBRE_LONG		0x04
+
+struct qeth_query_oat_physical_if {
+	u8 res_head[33];
+	u8 speed_duplex;
+	u8 media_type;
+	u8 res_tail[29];
+};
+
+#define QETH_QOAT_REPLY_TYPE_PHYS_IF		0x0004
+
+struct qeth_query_oat_reply {
+	u16 type;
+	u16 length;
+	u16 version;
+	u8 res[10];
+	struct qeth_query_oat_physical_if phys_if;
+};
+
+#define QETH_QOAT_SCOPE_INTERFACE		0x00000001
+
 struct qeth_query_oat {
-	__u32 subcmd_code;
-	__u8 reserved[12];
+	u32 subcmd_code;
+	u8 reserved[12];
+	struct qeth_query_oat_reply reply[];
 } __packed;
 
 struct qeth_qoat_priv {
-- 
2.17.1

