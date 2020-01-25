Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 155B6149670
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 16:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbgAYPxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 10:53:17 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:19092 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726772AbgAYPxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 10:53:16 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00PFbiuP117108
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 10:53:15 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xrjr2eyg8-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 10:53:14 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Sat, 25 Jan 2020 15:53:13 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 25 Jan 2020 15:53:10 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00PFr8Lr47513874
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Jan 2020 15:53:08 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 960BF4C046;
        Sat, 25 Jan 2020 15:53:08 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D7464C044;
        Sat, 25 Jan 2020 15:53:08 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 25 Jan 2020 15:53:08 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 4/5] s390/qeth: make cmd/reply matching more flexible
Date:   Sat, 25 Jan 2020 16:53:02 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200125155303.40971-1-jwi@linux.ibm.com>
References: <20200125155303.40971-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20012515-0012-0000-0000-00000380952E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20012515-0013-0000-0000-000021BCE1AE
Message-Id: <20200125155303.40971-5-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-25_05:2020-01-24,2020-01-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 bulkscore=0 suspectscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2001250132
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When data is received on the READ channel, the matching logic for cmds
that are waiting for a reply is currently hard-coded into the channel's
main IO callback.
Move this into a per-cmd callback, so that we can apply custom matching
logic for each individual cmd.

This also allows us to remove the coarse-grained check for unexpected
non-IPA replies, since they will no longer match against _all_ pending
cmds.

Note that IDX cmds use _no_ matcher, since their reply is synchronously
received as part of the cmd's IO.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      | 14 ++++++++++++-
 drivers/s390/net/qeth_core_main.c | 34 ++++++++++++++++++++++---------
 drivers/s390/net/qeth_l2_main.c   |  3 ++-
 3 files changed, 39 insertions(+), 12 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index d052a265da1c..950d01551373 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -608,6 +608,8 @@ struct qeth_cmd_buffer {
 	long timeout;
 	unsigned char *data;
 	void (*finalize)(struct qeth_card *card, struct qeth_cmd_buffer *iob);
+	bool (*match)(struct qeth_cmd_buffer *iob,
+		      struct qeth_cmd_buffer *reply);
 	void (*callback)(struct qeth_card *card, struct qeth_cmd_buffer *iob,
 			 unsigned int data_length);
 	int rc;
@@ -618,6 +620,14 @@ static inline void qeth_get_cmd(struct qeth_cmd_buffer *iob)
 	refcount_inc(&iob->ref_count);
 }
 
+static inline struct qeth_ipa_cmd *__ipa_reply(struct qeth_cmd_buffer *iob)
+{
+	if (!IS_IPA(iob->data))
+		return NULL;
+
+	return (struct qeth_ipa_cmd *) PDU_ENCAPSULATION(iob->data);
+}
+
 static inline struct qeth_ipa_cmd *__ipa_cmd(struct qeth_cmd_buffer *iob)
 {
 	return (struct qeth_ipa_cmd *)(iob->data + IPA_PDU_HEADER_SIZE);
@@ -1023,7 +1033,9 @@ void qeth_setadp_promisc_mode(struct qeth_card *card, bool enable);
 int qeth_setadpparms_change_macaddr(struct qeth_card *);
 void qeth_tx_timeout(struct net_device *, unsigned int txqueue);
 void qeth_prepare_ipa_cmd(struct qeth_card *card, struct qeth_cmd_buffer *iob,
-			  u16 cmd_length);
+			  u16 cmd_length,
+			  bool (*match)(struct qeth_cmd_buffer *iob,
+					struct qeth_cmd_buffer *reply));
 int qeth_query_switch_attributes(struct qeth_card *card,
 				  struct qeth_switch_info *sw_info);
 int qeth_query_card_info(struct qeth_card *card,
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index d66a7433908c..0f5f36e63823 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -748,8 +748,8 @@ static void qeth_issue_next_read_cb(struct qeth_card *card,
 		goto out;
 	}
 
-	if (IS_IPA(iob->data)) {
-		cmd = (struct qeth_ipa_cmd *) PDU_ENCAPSULATION(iob->data);
+	cmd = __ipa_reply(iob);
+	if (cmd) {
 		cmd = qeth_check_ipa_data(card, cmd);
 		if (!cmd)
 			goto out;
@@ -758,17 +758,12 @@ static void qeth_issue_next_read_cb(struct qeth_card *card,
 			card->osn_info.assist_cb(card->dev, cmd);
 			goto out;
 		}
-	} else {
-		/* non-IPA commands should only flow during initialization */
-		if (card->state != CARD_STATE_DOWN)
-			goto out;
 	}
 
 	/* match against pending cmd requests */
 	spin_lock_irqsave(&card->lock, flags);
 	list_for_each_entry(tmp, &card->cmd_waiter_list, list) {
-		if (!IS_IPA(tmp->data) ||
-		    __ipa_cmd(tmp)->hdr.seqno == cmd->hdr.seqno) {
+		if (tmp->match && tmp->match(tmp, iob)) {
 			request = tmp;
 			/* take the object outside the lock */
 			qeth_get_cmd(request);
@@ -1688,6 +1683,13 @@ static void qeth_mpc_finalize_cmd(struct qeth_card *card,
 	iob->callback = qeth_release_buffer_cb;
 }
 
+static bool qeth_mpc_match_reply(struct qeth_cmd_buffer *iob,
+				 struct qeth_cmd_buffer *reply)
+{
+	/* MPC cmds are issued strictly in sequence. */
+	return !IS_IPA(reply->data);
+}
+
 static struct qeth_cmd_buffer *qeth_mpc_alloc_cmd(struct qeth_card *card,
 						  void *data,
 						  unsigned int data_length)
@@ -1702,6 +1704,7 @@ static struct qeth_cmd_buffer *qeth_mpc_alloc_cmd(struct qeth_card *card,
 	qeth_setup_ccw(__ccw_from_cmd(iob), CCW_CMD_WRITE, 0, data_length,
 		       iob->data);
 	iob->finalize = qeth_mpc_finalize_cmd;
+	iob->match = qeth_mpc_match_reply;
 	return iob;
 }
 
@@ -2722,7 +2725,9 @@ static void qeth_ipa_finalize_cmd(struct qeth_card *card,
 }
 
 void qeth_prepare_ipa_cmd(struct qeth_card *card, struct qeth_cmd_buffer *iob,
-			  u16 cmd_length)
+			  u16 cmd_length,
+			  bool (*match)(struct qeth_cmd_buffer *iob,
+					struct qeth_cmd_buffer *reply))
 {
 	u8 prot_type = qeth_mpc_select_prot_type(card);
 	u16 total_length = iob->length;
@@ -2730,6 +2735,7 @@ void qeth_prepare_ipa_cmd(struct qeth_card *card, struct qeth_cmd_buffer *iob,
 	qeth_setup_ccw(__ccw_from_cmd(iob), CCW_CMD_WRITE, 0, total_length,
 		       iob->data);
 	iob->finalize = qeth_ipa_finalize_cmd;
+	iob->match = match;
 
 	memcpy(iob->data, IPA_PDU_HEADER, IPA_PDU_HEADER_SIZE);
 	memcpy(QETH_IPA_PDU_LEN_TOTAL(iob->data), &total_length, 2);
@@ -2742,6 +2748,14 @@ void qeth_prepare_ipa_cmd(struct qeth_card *card, struct qeth_cmd_buffer *iob,
 }
 EXPORT_SYMBOL_GPL(qeth_prepare_ipa_cmd);
 
+static bool qeth_ipa_match_reply(struct qeth_cmd_buffer *iob,
+				 struct qeth_cmd_buffer *reply)
+{
+	struct qeth_ipa_cmd *ipa_reply = __ipa_reply(reply);
+
+	return ipa_reply && (__ipa_cmd(iob)->hdr.seqno == ipa_reply->hdr.seqno);
+}
+
 struct qeth_cmd_buffer *qeth_ipa_alloc_cmd(struct qeth_card *card,
 					   enum qeth_ipa_cmds cmd_code,
 					   enum qeth_prot_versions prot,
@@ -2757,7 +2771,7 @@ struct qeth_cmd_buffer *qeth_ipa_alloc_cmd(struct qeth_card *card,
 	if (!iob)
 		return NULL;
 
-	qeth_prepare_ipa_cmd(card, iob, data_length);
+	qeth_prepare_ipa_cmd(card, iob, data_length, qeth_ipa_match_reply);
 
 	hdr = &__ipa_cmd(iob)->hdr;
 	hdr->command = cmd_code;
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index c36b6c1fc33f..d5ffd40937d3 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -896,7 +896,8 @@ int qeth_osn_assist(struct net_device *dev, void *data, int data_len)
 	if (!iob)
 		return -ENOMEM;
 
-	qeth_prepare_ipa_cmd(card, iob, (u16) data_len);
+	qeth_prepare_ipa_cmd(card, iob, (u16) data_len, NULL);
+
 	memcpy(__ipa_cmd(iob), data, data_len);
 	iob->callback = qeth_osn_assist_cb;
 	return qeth_send_ipa_cmd(card, iob, NULL, NULL);
-- 
2.17.1

