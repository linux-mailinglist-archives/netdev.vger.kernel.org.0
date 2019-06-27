Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA7458523
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 17:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfF0PEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 11:04:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47214 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726443AbfF0PEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 11:04:06 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5RF3qWf083847
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 11:04:05 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tcwr3quux-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 11:03:56 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 27 Jun 2019 16:01:40 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 27 Jun 2019 16:01:38 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5RF1axe54722610
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 15:01:36 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89C3EA4064;
        Thu, 27 Jun 2019 15:01:36 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 50B75A406A;
        Thu, 27 Jun 2019 15:01:36 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Jun 2019 15:01:36 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 04/12] s390/qeth: dynamically allocate diag cmds
Date:   Thu, 27 Jun 2019 17:01:25 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190627150133.58746-1-jwi@linux.ibm.com>
References: <20190627150133.58746-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19062715-0016-0000-0000-0000028D0D0C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062715-0017-0000-0000-000032EA8BA7
Message-Id: <20190627150133.58746-5-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-27_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906270176
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new wrapper that allocates DIAG cmds of the right size, and fills
in the common fields.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  3 +++
 drivers/s390/net/qeth_core_main.c | 29 +++++++++++++++++++++--------
 drivers/s390/net/qeth_core_mpc.h  |  5 +++++
 drivers/s390/net/qeth_l3_main.c   |  4 +---
 4 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 258756dc06c3..b99fe6b043aa 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -1008,6 +1008,9 @@ struct qeth_cmd_buffer *qeth_get_setassparms_cmd(struct qeth_card *card,
 						 u16 cmd_code,
 						 unsigned int data_length,
 						 enum qeth_prot_versions prot);
+struct qeth_cmd_buffer *qeth_get_diag_cmd(struct qeth_card *card,
+					  enum qeth_diags_cmds sub_cmd,
+					  unsigned int data_length);
 
 struct sk_buff *qeth_core_get_next_skb(struct qeth_card *,
 		struct qeth_qdio_buffer *, struct qdio_buffer_element **, int *,
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 696aba566d0b..22074890835e 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -3037,6 +3037,25 @@ int qeth_query_switch_attributes(struct qeth_card *card,
 				qeth_query_switch_attributes_cb, sw_info);
 }
 
+struct qeth_cmd_buffer *qeth_get_diag_cmd(struct qeth_card *card,
+					  enum qeth_diags_cmds sub_cmd,
+					  unsigned int data_length)
+{
+	struct qeth_ipacmd_diagass *cmd;
+	struct qeth_cmd_buffer *iob;
+
+	iob = qeth_ipa_alloc_cmd(card, IPA_CMD_SET_DIAG_ASS, QETH_PROT_NONE,
+				 DIAG_HDR_LEN + data_length);
+	if (!iob)
+		return NULL;
+
+	cmd = &__ipa_cmd(iob)->data.diagass;
+	cmd->subcmd_len = DIAG_SUB_HDR_LEN + data_length;
+	cmd->subcmd = sub_cmd;
+	return iob;
+}
+EXPORT_SYMBOL_GPL(qeth_get_diag_cmd);
+
 static int qeth_query_setdiagass_cb(struct qeth_card *card,
 		struct qeth_reply *reply, unsigned long data)
 {
@@ -3055,15 +3074,11 @@ static int qeth_query_setdiagass_cb(struct qeth_card *card,
 static int qeth_query_setdiagass(struct qeth_card *card)
 {
 	struct qeth_cmd_buffer *iob;
-	struct qeth_ipa_cmd    *cmd;
 
 	QETH_CARD_TEXT(card, 2, "qdiagass");
-	iob = qeth_get_ipacmd_buffer(card, IPA_CMD_SET_DIAG_ASS, 0);
+	iob = qeth_get_diag_cmd(card, QETH_DIAGS_CMD_QUERY, 0);
 	if (!iob)
 		return -ENOMEM;
-	cmd = __ipa_cmd(iob);
-	cmd->data.diagass.subcmd_len = 16;
-	cmd->data.diagass.subcmd = QETH_DIAGS_CMD_QUERY;
 	return qeth_send_ipa_cmd(card, iob, qeth_query_setdiagass_cb, NULL);
 }
 
@@ -3111,12 +3126,10 @@ int qeth_hw_trap(struct qeth_card *card, enum qeth_diags_trap_action action)
 	struct qeth_ipa_cmd *cmd;
 
 	QETH_CARD_TEXT(card, 2, "diagtrap");
-	iob = qeth_get_ipacmd_buffer(card, IPA_CMD_SET_DIAG_ASS, 0);
+	iob = qeth_get_diag_cmd(card, QETH_DIAGS_CMD_TRAP, 64);
 	if (!iob)
 		return -ENOMEM;
 	cmd = __ipa_cmd(iob);
-	cmd->data.diagass.subcmd_len = 80;
-	cmd->data.diagass.subcmd = QETH_DIAGS_CMD_TRAP;
 	cmd->data.diagass.type = 1;
 	cmd->data.diagass.action = action;
 	switch (action) {
diff --git a/drivers/s390/net/qeth_core_mpc.h b/drivers/s390/net/qeth_core_mpc.h
index 46f038580a72..5cec877d972f 100644
--- a/drivers/s390/net/qeth_core_mpc.h
+++ b/drivers/s390/net/qeth_core_mpc.h
@@ -599,6 +599,11 @@ struct qeth_ipacmd_diagass {
 	__u8   cdata[64];
 } __attribute__ ((packed));
 
+#define DIAG_HDR_LEN		offsetofend(struct qeth_ipacmd_diagass, ext)
+#define DIAG_SUB_HDR_LEN	(offsetofend(struct qeth_ipacmd_diagass, ext) -\
+				 offsetof(struct qeth_ipacmd_diagass, \
+					  subcmd_len))
+
 /* VNIC Characteristics IPA Command: *****************************************/
 /* IPA commands/sub commands for VNICC */
 #define IPA_VNICC_QUERY_CHARS		0x00000000L
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index ff4d514656f2..2e10f5be8f67 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1107,12 +1107,10 @@ qeth_diags_trace(struct qeth_card *card, enum qeth_diags_trace_cmds diags_cmd)
 
 	QETH_CARD_TEXT(card, 2, "diagtrac");
 
-	iob = qeth_get_ipacmd_buffer(card, IPA_CMD_SET_DIAG_ASS, 0);
+	iob = qeth_get_diag_cmd(card, QETH_DIAGS_CMD_TRACE, 0);
 	if (!iob)
 		return -ENOMEM;
 	cmd = __ipa_cmd(iob);
-	cmd->data.diagass.subcmd_len = 16;
-	cmd->data.diagass.subcmd = QETH_DIAGS_CMD_TRACE;
 	cmd->data.diagass.type = QETH_DIAGS_TYPE_HIPERSOCKET;
 	cmd->data.diagass.action = diags_cmd;
 	return qeth_send_ipa_cmd(card, iob, qeth_diags_trace_cb, NULL);
-- 
2.17.1

