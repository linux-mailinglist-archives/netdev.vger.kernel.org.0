Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E09665851B
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 17:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbfF0PDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 11:03:38 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31160 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726370AbfF0PDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 11:03:37 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5RF30PY033955
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 11:03:35 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tcx4xq9kk-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 11:03:17 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 27 Jun 2019 16:01:39 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 27 Jun 2019 16:01:38 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5RF1agQ40698110
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 15:01:36 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A45CA4054;
        Thu, 27 Jun 2019 15:01:36 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5D48A406B;
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
Subject: [PATCH net-next 03/12] s390/qeth: dynamically allocate various cmds with sub-types
Date:   Thu, 27 Jun 2019 17:01:24 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190627150133.58746-1-jwi@linux.ibm.com>
References: <20190627150133.58746-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19062715-0008-0000-0000-000002F7B601
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062715-0009-0000-0000-00002264EFAE
Message-Id: <20190627150133.58746-4-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-27_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906270175
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch converts the adapter, assist and bridgeport cmd paths to
dynamic allocation. Most of the work is about re-organizing the cmd
headers, calculating the correct cmd length, and filling in the right
value in the sub-cmd's length field.

Since we now also set the correct length for cmds that are not reflected
by a fixed struct (ie SNMP), we can remove the work-around from
qeth_snmp_command().

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  9 ++--
 drivers/s390/net/qeth_core_main.c | 86 ++++++++++++++++---------------
 drivers/s390/net/qeth_core_mpc.h  | 27 ++++------
 drivers/s390/net/qeth_l2_main.c   | 29 ++++++-----
 drivers/s390/net/qeth_l3_main.c   | 10 ++--
 5 files changed, 78 insertions(+), 83 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 35d7b43f6580..258756dc06c3 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -1003,6 +1003,11 @@ struct qeth_cmd_buffer *qeth_ipa_alloc_cmd(struct qeth_card *card,
 struct qeth_cmd_buffer *qeth_alloc_cmd(struct qeth_channel *channel,
 				       unsigned int length, unsigned int ccws,
 				       long timeout);
+struct qeth_cmd_buffer *qeth_get_setassparms_cmd(struct qeth_card *card,
+						 enum qeth_ipa_funcs ipa_func,
+						 u16 cmd_code,
+						 unsigned int data_length,
+						 enum qeth_prot_versions prot);
 
 struct sk_buff *qeth_core_get_next_skb(struct qeth_card *,
 		struct qeth_qdio_buffer *, struct qdio_buffer_element **, int *,
@@ -1037,10 +1042,6 @@ int qeth_configure_cq(struct qeth_card *, enum qeth_cq);
 int qeth_hw_trap(struct qeth_card *, enum qeth_diags_trap_action);
 void qeth_trace_features(struct qeth_card *);
 int qeth_setassparms_cb(struct qeth_card *, struct qeth_reply *, unsigned long);
-struct qeth_cmd_buffer *qeth_get_setassparms_cmd(struct qeth_card *,
-						 enum qeth_ipa_funcs,
-						 __u16, __u16,
-						 enum qeth_prot_versions);
 int qeth_set_features(struct net_device *, netdev_features_t);
 void qeth_enable_hw_features(struct net_device *dev);
 netdev_features_t qeth_fix_features(struct net_device *, netdev_features_t);
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 3ba91b1c1315..696aba566d0b 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -2915,21 +2915,24 @@ static int qeth_query_setadapterparms_cb(struct qeth_card *card,
 }
 
 static struct qeth_cmd_buffer *qeth_get_adapter_cmd(struct qeth_card *card,
-		__u32 command, __u32 cmdlen)
+						    enum qeth_ipa_setadp_cmd adp_cmd,
+						    unsigned int data_length)
 {
+	struct qeth_ipacmd_setadpparms_hdr *hdr;
 	struct qeth_cmd_buffer *iob;
-	struct qeth_ipa_cmd *cmd;
 
-	iob = qeth_get_ipacmd_buffer(card, IPA_CMD_SETADAPTERPARMS,
-				     QETH_PROT_IPV4);
-	if (iob) {
-		cmd = __ipa_cmd(iob);
-		cmd->data.setadapterparms.hdr.cmdlength = cmdlen;
-		cmd->data.setadapterparms.hdr.command_code = command;
-		cmd->data.setadapterparms.hdr.used_total = 1;
-		cmd->data.setadapterparms.hdr.seq_no = 1;
-	}
+	iob = qeth_ipa_alloc_cmd(card, IPA_CMD_SETADAPTERPARMS, QETH_PROT_IPV4,
+				 data_length +
+				 offsetof(struct qeth_ipacmd_setadpparms,
+					  data));
+	if (!iob)
+		return NULL;
 
+	hdr = &__ipa_cmd(iob)->data.setadapterparms.hdr;
+	hdr->cmdlength = sizeof(*hdr) + data_length;
+	hdr->command_code = adp_cmd;
+	hdr->used_total = 1;
+	hdr->seq_no = 1;
 	return iob;
 }
 
@@ -2940,7 +2943,7 @@ static int qeth_query_setadapterparms(struct qeth_card *card)
 
 	QETH_CARD_TEXT(card, 3, "queryadp");
 	iob = qeth_get_adapter_cmd(card, IPA_SETADP_QUERY_COMMANDS_SUPPORTED,
-				   sizeof(struct qeth_ipacmd_setadpparms));
+				   SETADP_DATA_SIZEOF(query_cmds_supp));
 	if (!iob)
 		return -ENOMEM;
 	rc = qeth_send_ipa_cmd(card, iob, qeth_query_setadapterparms_cb, NULL);
@@ -3027,8 +3030,7 @@ int qeth_query_switch_attributes(struct qeth_card *card,
 		return -EOPNOTSUPP;
 	if (!netif_carrier_ok(card->dev))
 		return -ENOMEDIUM;
-	iob = qeth_get_adapter_cmd(card, IPA_SETADP_QUERY_SWITCH_ATTRIBUTES,
-				sizeof(struct qeth_ipacmd_setadpparms_hdr));
+	iob = qeth_get_adapter_cmd(card, IPA_SETADP_QUERY_SWITCH_ATTRIBUTES, 0);
 	if (!iob)
 		return -ENOMEM;
 	return qeth_send_ipa_cmd(card, iob,
@@ -4152,7 +4154,7 @@ void qeth_setadp_promisc_mode(struct qeth_card *card)
 	QETH_CARD_TEXT_(card, 4, "mode:%x", mode);
 
 	iob = qeth_get_adapter_cmd(card, IPA_SETADP_SET_PROMISC_MODE,
-			sizeof(struct qeth_ipacmd_setadpparms_hdr) + 8);
+				   SETADP_DATA_SIZEOF(mode));
 	if (!iob)
 		return;
 	cmd = __ipa_cmd(iob);
@@ -4192,8 +4194,7 @@ int qeth_setadpparms_change_macaddr(struct qeth_card *card)
 	QETH_CARD_TEXT(card, 4, "chgmac");
 
 	iob = qeth_get_adapter_cmd(card, IPA_SETADP_ALTER_MAC_ADDRESS,
-				   sizeof(struct qeth_ipacmd_setadpparms_hdr) +
-				   sizeof(struct qeth_change_addr));
+				   SETADP_DATA_SIZEOF(change_addr));
 	if (!iob)
 		return -ENOMEM;
 	cmd = __ipa_cmd(iob);
@@ -4302,8 +4303,7 @@ static int qeth_setadpparms_set_access_ctrl(struct qeth_card *card,
 	QETH_CARD_TEXT(card, 4, "setacctl");
 
 	iob = qeth_get_adapter_cmd(card, IPA_SETADP_SET_ACCESS_CONTROL,
-				   sizeof(struct qeth_ipacmd_setadpparms_hdr) +
-				   sizeof(struct qeth_set_access_ctrl));
+				   SETADP_DATA_SIZEOF(set_access_ctrl));
 	if (!iob)
 		return -ENOMEM;
 	cmd = __ipa_cmd(iob);
@@ -4498,9 +4498,9 @@ static int qeth_snmp_command(struct qeth_card *card, char __user *udata)
 	/* skip 4 bytes (data_len struct member) to get req_len */
 	if (copy_from_user(&req_len, udata + sizeof(int), sizeof(int)))
 		return -EFAULT;
-	if (req_len > (QETH_BUFSIZE - IPA_PDU_HEADER_SIZE -
-		       sizeof(struct qeth_ipacmd_hdr) -
-		       sizeof(struct qeth_ipacmd_setadpparms_hdr)))
+	if (req_len + offsetof(struct qeth_ipacmd_setadpparms, data) +
+	    offsetof(struct qeth_ipa_cmd, data) + IPA_PDU_HEADER_SIZE >
+	    QETH_BUFSIZE)
 		return -EINVAL;
 	ureq = memdup_user(udata, req_len + sizeof(struct qeth_snmp_ureq_hdr));
 	if (IS_ERR(ureq)) {
@@ -4515,16 +4515,12 @@ static int qeth_snmp_command(struct qeth_card *card, char __user *udata)
 	}
 	qinfo.udata_offset = sizeof(struct qeth_snmp_ureq_hdr);
 
-	iob = qeth_get_adapter_cmd(card, IPA_SETADP_SET_SNMP_CONTROL,
-				   QETH_SNMP_SETADP_CMDLENGTH + req_len);
+	iob = qeth_get_adapter_cmd(card, IPA_SETADP_SET_SNMP_CONTROL, req_len);
 	if (!iob) {
 		rc = -ENOMEM;
 		goto out;
 	}
 
-	/* for large requests, fix-up the length fields: */
-	qeth_prepare_ipa_cmd(card, iob, QETH_SETADP_BASE_LEN + req_len);
-
 	cmd = __ipa_cmd(iob);
 	memcpy(&cmd->data.setadapterparms.data.snmp, &ureq->cmd, req_len);
 	rc = qeth_send_ipa_cmd(card, iob, qeth_snmp_command_cb, &qinfo);
@@ -4602,8 +4598,7 @@ static int qeth_query_oat_command(struct qeth_card *card, char __user *udata)
 	}
 
 	iob = qeth_get_adapter_cmd(card, IPA_SETADP_QUERY_OAT,
-				   sizeof(struct qeth_ipacmd_setadpparms_hdr) +
-				   sizeof(struct qeth_query_oat));
+				   SETADP_DATA_SIZEOF(query_oat));
 	if (!iob) {
 		rc = -ENOMEM;
 		goto out_free;
@@ -4665,8 +4660,7 @@ int qeth_query_card_info(struct qeth_card *card,
 	QETH_CARD_TEXT(card, 2, "qcrdinfo");
 	if (!qeth_adp_supported(card, IPA_SETADP_QUERY_CARD_INFO))
 		return -EOPNOTSUPP;
-	iob = qeth_get_adapter_cmd(card, IPA_SETADP_QUERY_CARD_INFO,
-		sizeof(struct qeth_ipacmd_setadpparms_hdr));
+	iob = qeth_get_adapter_cmd(card, IPA_SETADP_QUERY_CARD_INFO, 0);
 	if (!iob)
 		return -ENOMEM;
 	return qeth_send_ipa_cmd(card, iob, qeth_query_card_info_cb,
@@ -5333,22 +5327,28 @@ EXPORT_SYMBOL_GPL(qeth_setassparms_cb);
 
 struct qeth_cmd_buffer *qeth_get_setassparms_cmd(struct qeth_card *card,
 						 enum qeth_ipa_funcs ipa_func,
-						 __u16 cmd_code, __u16 len,
+						 u16 cmd_code,
+						 unsigned int data_length,
 						 enum qeth_prot_versions prot)
 {
+	struct qeth_ipacmd_setassparms *setassparms;
+	struct qeth_ipacmd_setassparms_hdr *hdr;
 	struct qeth_cmd_buffer *iob;
-	struct qeth_ipa_cmd *cmd;
 
 	QETH_CARD_TEXT(card, 4, "getasscm");
-	iob = qeth_get_ipacmd_buffer(card, IPA_CMD_SETASSPARMS, prot);
+	iob = qeth_ipa_alloc_cmd(card, IPA_CMD_SETASSPARMS, prot,
+				 data_length +
+				 offsetof(struct qeth_ipacmd_setassparms,
+					  data));
+	if (!iob)
+		return NULL;
 
-	if (iob) {
-		cmd = __ipa_cmd(iob);
-		cmd->data.setassparms.hdr.assist_no = ipa_func;
-		cmd->data.setassparms.hdr.length = 8 + len;
-		cmd->data.setassparms.hdr.command_code = cmd_code;
-	}
+	setassparms = &__ipa_cmd(iob)->data.setassparms;
+	setassparms->assist_no = ipa_func;
 
+	hdr = &setassparms->hdr;
+	hdr->length = sizeof(*hdr) + data_length;
+	hdr->command_code = cmd_code;
 	return iob;
 }
 EXPORT_SYMBOL_GPL(qeth_get_setassparms_cmd);
@@ -5916,7 +5916,8 @@ static int qeth_set_csum_on(struct qeth_card *card, enum qeth_ipa_funcs cstype,
 		return -EOPNOTSUPP;
 	}
 
-	iob = qeth_get_setassparms_cmd(card, cstype, IPA_CMD_ASS_ENABLE, 4,
+	iob = qeth_get_setassparms_cmd(card, cstype, IPA_CMD_ASS_ENABLE,
+				       SETASS_DATA_SIZEOF(flags_32bit),
 				       prot);
 	if (!iob) {
 		qeth_set_csum_off(card, cstype, prot);
@@ -5999,7 +6000,8 @@ static int qeth_set_tso_on(struct qeth_card *card,
 	}
 
 	iob = qeth_get_setassparms_cmd(card, IPA_OUTBOUND_TSO,
-				       IPA_CMD_ASS_ENABLE, sizeof(caps), prot);
+				       IPA_CMD_ASS_ENABLE,
+				       SETASS_DATA_SIZEOF(caps), prot);
 	if (!iob) {
 		qeth_set_tso_off(card, prot);
 		return -ENOMEM;
diff --git a/drivers/s390/net/qeth_core_mpc.h b/drivers/s390/net/qeth_core_mpc.h
index 61fc4005dd53..46f038580a72 100644
--- a/drivers/s390/net/qeth_core_mpc.h
+++ b/drivers/s390/net/qeth_core_mpc.h
@@ -379,9 +379,7 @@ struct qeth_ipacmd_layer2setdelvlan {
 	__u16 vlan_id;
 } __attribute__ ((packed));
 
-
 struct qeth_ipacmd_setassparms_hdr {
-	__u32 assist_no;
 	__u16 length;
 	__u16 command_code;
 	__u16 return_code;
@@ -426,6 +424,7 @@ struct qeth_tso_start_data {
 
 /* SETASSPARMS IPA Command: */
 struct qeth_ipacmd_setassparms {
+	u32 assist_no;
 	struct qeth_ipacmd_setassparms_hdr hdr;
 	union {
 		__u32 flags_32bit;
@@ -526,8 +525,6 @@ struct qeth_query_switch_attributes {
 #define QETH_SETADP_FLAGS_VIRTUAL_MAC	0x80	/* for CHANGE_ADDR_READ_MAC */
 
 struct qeth_ipacmd_setadpparms_hdr {
-	u32 supp_hw_cmds;
-	u32 reserved1;
 	u16 cmdlength;
 	u16 reserved2;
 	u32 command_code;
@@ -539,6 +536,7 @@ struct qeth_ipacmd_setadpparms_hdr {
 };
 
 struct qeth_ipacmd_setadpparms {
+	struct qeth_ipa_caps hw_cmds;
 	struct qeth_ipacmd_setadpparms_hdr hdr;
 	union {
 		struct qeth_query_cmds_supp query_cmds_supp;
@@ -552,6 +550,9 @@ struct qeth_ipacmd_setadpparms {
 	} data;
 } __attribute__ ((packed));
 
+#define SETADP_DATA_SIZEOF(field) FIELD_SIZEOF(struct qeth_ipacmd_setadpparms,\
+					       data.field)
+
 /* CREATE_ADDR IPA Command:    ***********************************************/
 struct qeth_create_destroy_address {
 	__u8 unique_id[8];
@@ -688,8 +689,6 @@ struct mac_addr_lnid {
 } __packed;
 
 struct qeth_ipacmd_sbp_hdr {
-	__u32 supported_sbp_cmds;
-	__u32 enabled_sbp_cmds;
 	__u16 cmdlength;
 	__u16 reserved1;
 	__u32 command_code;
@@ -704,16 +703,10 @@ struct qeth_sbp_query_cmds_supp {
 	__u32 reserved;
 } __packed;
 
-struct qeth_sbp_reset_role {
-} __packed;
-
 struct qeth_sbp_set_primary {
 	struct net_if_token token;
 } __packed;
 
-struct qeth_sbp_set_secondary {
-} __packed;
-
 struct qeth_sbp_port_entry {
 		__u8 role;
 		__u8 state;
@@ -739,17 +732,19 @@ struct qeth_sbp_state_change {
 } __packed;
 
 struct qeth_ipacmd_setbridgeport {
+	struct qeth_ipa_caps sbp_cmds;
 	struct qeth_ipacmd_sbp_hdr hdr;
 	union {
 		struct qeth_sbp_query_cmds_supp query_cmds_supp;
-		struct qeth_sbp_reset_role reset_role;
 		struct qeth_sbp_set_primary set_primary;
-		struct qeth_sbp_set_secondary set_secondary;
 		struct qeth_sbp_query_ports query_ports;
 		struct qeth_sbp_state_change state_change;
 	} data;
 } __packed;
 
+#define SBP_DATA_SIZEOF(field)	FIELD_SIZEOF(struct qeth_ipacmd_setbridgeport,\
+					     data.field)
+
 /* ADDRESS_CHANGE_NOTIFICATION adapter-initiated "command" *******************/
 /* Bitmask for entry->change_code. Both bits may be raised.		     */
 enum qeth_ipa_addr_change_code {
@@ -827,10 +822,6 @@ enum qeth_ipa_arp_return_codes {
 extern const char *qeth_get_ipa_msg(enum qeth_ipa_return_codes rc);
 extern const char *qeth_get_ipa_cmd_name(enum qeth_ipa_cmds cmd);
 
-#define QETH_SETADP_BASE_LEN (sizeof(struct qeth_ipacmd_hdr) + \
-			      sizeof(struct qeth_ipacmd_setadpparms_hdr))
-#define QETH_SNMP_SETADP_CMDLENGTH 16
-
 /* Helper functions */
 #define IS_IPA_REPLY(cmd) ((cmd->hdr.initiator == IPA_CMD_INITIATOR_HOST) || \
 			   (cmd->hdr.initiator == IPA_CMD_INITIATOR_OSA_REPLY))
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 1dd8d22299c2..f762d22a3272 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -1427,22 +1427,25 @@ static int qeth_bridgeport_makerc(struct qeth_card *card,
 
 static struct qeth_cmd_buffer *qeth_sbp_build_cmd(struct qeth_card *card,
 						  enum qeth_ipa_sbp_cmd sbp_cmd,
-						  unsigned int cmd_length)
+						  unsigned int data_length)
 {
 	enum qeth_ipa_cmds ipa_cmd = IS_IQD(card) ? IPA_CMD_SETBRIDGEPORT_IQD :
 						    IPA_CMD_SETBRIDGEPORT_OSA;
+	struct qeth_ipacmd_sbp_hdr *hdr;
 	struct qeth_cmd_buffer *iob;
-	struct qeth_ipa_cmd *cmd;
 
-	iob = qeth_get_ipacmd_buffer(card, ipa_cmd, 0);
+	iob = qeth_ipa_alloc_cmd(card, ipa_cmd, QETH_PROT_NONE,
+				 data_length +
+				 offsetof(struct qeth_ipacmd_setbridgeport,
+					  data));
 	if (!iob)
 		return iob;
-	cmd = __ipa_cmd(iob);
-	cmd->data.sbp.hdr.cmdlength = sizeof(struct qeth_ipacmd_sbp_hdr) +
-				      cmd_length;
-	cmd->data.sbp.hdr.command_code = sbp_cmd;
-	cmd->data.sbp.hdr.used_total = 1;
-	cmd->data.sbp.hdr.seq_no = 1;
+
+	hdr = &__ipa_cmd(iob)->data.sbp.hdr;
+	hdr->cmdlength = sizeof(*hdr) + data_length;
+	hdr->command_code = sbp_cmd;
+	hdr->used_total = 1;
+	hdr->seq_no = 1;
 	return iob;
 }
 
@@ -1477,7 +1480,7 @@ static void qeth_bridgeport_query_support(struct qeth_card *card)
 
 	QETH_CARD_TEXT(card, 2, "brqsuppo");
 	iob = qeth_sbp_build_cmd(card, IPA_SBP_QUERY_COMMANDS_SUPPORTED,
-				 sizeof(struct qeth_sbp_query_cmds_supp));
+				 SBP_DATA_SIZEOF(query_cmds_supp));
 	if (!iob)
 		return;
 
@@ -1569,23 +1572,21 @@ static int qeth_bridgeport_set_cb(struct qeth_card *card,
  */
 int qeth_bridgeport_setrole(struct qeth_card *card, enum qeth_sbp_roles role)
 {
-	int cmdlength;
 	struct qeth_cmd_buffer *iob;
 	enum qeth_ipa_sbp_cmd setcmd;
+	unsigned int cmdlength = 0;
 
 	QETH_CARD_TEXT(card, 2, "brsetrol");
 	switch (role) {
 	case QETH_SBP_ROLE_NONE:
 		setcmd = IPA_SBP_RESET_BRIDGE_PORT_ROLE;
-		cmdlength = sizeof(struct qeth_sbp_reset_role);
 		break;
 	case QETH_SBP_ROLE_PRIMARY:
 		setcmd = IPA_SBP_SET_PRIMARY_BRIDGE_PORT;
-		cmdlength = sizeof(struct qeth_sbp_set_primary);
+		cmdlength = SBP_DATA_SIZEOF(set_primary);
 		break;
 	case QETH_SBP_ROLE_SECONDARY:
 		setcmd = IPA_SBP_SET_SECONDARY_BRIDGE_PORT;
-		cmdlength = sizeof(struct qeth_sbp_set_secondary);
 		break;
 	default:
 		return -EINVAL;
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 3de71ed54e92..ff4d514656f2 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1564,7 +1564,8 @@ static int qeth_l3_arp_set_no_entries(struct qeth_card *card, int no_entries)
 	}
 
 	iob = qeth_get_setassparms_cmd(card, IPA_ARP_PROCESSING,
-				       IPA_CMD_ASS_ARP_SET_NO_ENTRIES, 4,
+				       IPA_CMD_ASS_ARP_SET_NO_ENTRIES,
+				       SETASS_DATA_SIZEOF(flags_32bit),
 				       QETH_PROT_IPV4);
 	if (!iob)
 		return -ENOMEM;
@@ -1710,9 +1711,7 @@ static int qeth_l3_query_arp_cache_info(struct qeth_card *card,
 
 	iob = qeth_get_setassparms_cmd(card, IPA_ARP_PROCESSING,
 				       IPA_CMD_ASS_ARP_QUERY_INFO,
-				       sizeof(struct qeth_arp_query_data)
-						- sizeof(char),
-				       prot);
+				       SETASS_DATA_SIZEOF(query_arp), prot);
 	if (!iob)
 		return -ENOMEM;
 	cmd = __ipa_cmd(iob);
@@ -1796,7 +1795,8 @@ static int qeth_l3_arp_modify_entry(struct qeth_card *card,
 	}
 
 	iob = qeth_get_setassparms_cmd(card, IPA_ARP_PROCESSING, arp_cmd,
-				       sizeof(*cmd_entry), QETH_PROT_IPV4);
+				       SETASS_DATA_SIZEOF(arp_entry),
+				       QETH_PROT_IPV4);
 	if (!iob)
 		return -ENOMEM;
 
-- 
2.17.1

