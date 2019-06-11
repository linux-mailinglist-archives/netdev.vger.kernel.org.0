Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7918A3D278
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 18:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404185AbfFKQig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 12:38:36 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46044 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404399AbfFKQiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 12:38:13 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5BGR3AC110717
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 12:38:11 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t2fkbs925-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 12:38:11 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Tue, 11 Jun 2019 17:38:09 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 11 Jun 2019 17:38:08 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5BGc6dP51773564
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jun 2019 16:38:06 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AAF7A4C044;
        Tue, 11 Jun 2019 16:38:06 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D7404C040;
        Tue, 11 Jun 2019 16:38:06 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jun 2019 16:38:06 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 06/13] s390/qeth: remove qeth_wait_for_buffer()
Date:   Tue, 11 Jun 2019 18:37:53 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190611163800.64730-1-jwi@linux.ibm.com>
References: <20190611163800.64730-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19061116-0016-0000-0000-000002882ECA
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061116-0017-0000-0000-000032E55E9C
Message-Id: <20190611163800.64730-7-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-11_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906110106
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The basic MPC initialization sequence is strictly sequential, and
waiting for an available cmd buffer should never be necessary.
So this change only affects the OSN path, where dangling waiters on an
unbounded wait_event() are not desirable. Switch to qeth_get_buffers(),
and let OSN callers deal with -ENOMEM.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  2 +-
 drivers/s390/net/qeth_core_main.c | 58 +++++++++++++++++--------------
 drivers/s390/net/qeth_l2_main.c   |  5 ++-
 3 files changed, 37 insertions(+), 28 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 5fab7b3396aa..14e8ab34ab2f 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -998,7 +998,7 @@ void qeth_tx_timeout(struct net_device *);
 void qeth_release_buffer(struct qeth_channel *, struct qeth_cmd_buffer *);
 void qeth_prepare_ipa_cmd(struct qeth_card *card, struct qeth_cmd_buffer *iob,
 			  u16 cmd_length);
-struct qeth_cmd_buffer *qeth_wait_for_buffer(struct qeth_channel *);
+struct qeth_cmd_buffer *qeth_get_buffer(struct qeth_channel *channel);
 int qeth_query_switch_attributes(struct qeth_card *card,
 				  struct qeth_switch_info *sw_info);
 int qeth_query_card_info(struct qeth_card *card,
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 0403a1405872..3d25cff404fe 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -65,7 +65,6 @@ static struct lock_class_key qdio_out_skb_queue_key;
 static void qeth_issue_next_read_cb(struct qeth_card *card,
 				    struct qeth_channel *channel,
 				    struct qeth_cmd_buffer *iob);
-static struct qeth_cmd_buffer *qeth_get_buffer(struct qeth_channel *);
 static void qeth_free_buffer_pool(struct qeth_card *);
 static int qeth_qdio_establish(struct qeth_card *);
 static void qeth_free_qdio_queues(struct qeth_card *card);
@@ -746,7 +745,7 @@ static void qeth_cancel_cmd(struct qeth_cmd_buffer *iob, int rc)
 	qeth_release_buffer(iob->channel, iob);
 }
 
-static struct qeth_cmd_buffer *qeth_get_buffer(struct qeth_channel *channel)
+struct qeth_cmd_buffer *qeth_get_buffer(struct qeth_channel *channel)
 {
 	struct qeth_cmd_buffer *buffer = NULL;
 	unsigned long flags;
@@ -756,15 +755,7 @@ static struct qeth_cmd_buffer *qeth_get_buffer(struct qeth_channel *channel)
 	spin_unlock_irqrestore(&channel->iob_lock, flags);
 	return buffer;
 }
-
-struct qeth_cmd_buffer *qeth_wait_for_buffer(struct qeth_channel *channel)
-{
-	struct qeth_cmd_buffer *buffer;
-	wait_event(channel->wait_q,
-		   ((buffer = qeth_get_buffer(channel)) != NULL));
-	return buffer;
-}
-EXPORT_SYMBOL_GPL(qeth_wait_for_buffer);
+EXPORT_SYMBOL_GPL(qeth_get_buffer);
 
 void qeth_clear_cmd_buffers(struct qeth_channel *channel)
 {
@@ -1794,6 +1785,16 @@ static void qeth_mpc_finalize_cmd(struct qeth_card *card,
 	iob->callback = qeth_release_buffer_cb;
 }
 
+static struct qeth_cmd_buffer *qeth_mpc_get_cmd_buffer(struct qeth_card *card)
+{
+	struct qeth_cmd_buffer *iob;
+
+	iob = qeth_get_buffer(&card->write);
+	if (iob)
+		iob->finalize = qeth_mpc_finalize_cmd;
+	return iob;
+}
+
 /**
  * qeth_send_control_data() -	send control command to the card
  * @card:			qeth_card structure pointer
@@ -2102,10 +2103,11 @@ static int qeth_cm_enable(struct qeth_card *card)
 
 	QETH_DBF_TEXT(SETUP, 2, "cmenable");
 
-	iob = qeth_wait_for_buffer(&card->write);
-	iob->finalize = qeth_mpc_finalize_cmd;
-	memcpy(iob->data, CM_ENABLE, CM_ENABLE_SIZE);
+	iob = qeth_mpc_get_cmd_buffer(card);
+	if (!iob)
+		return -ENOMEM;
 
+	memcpy(iob->data, CM_ENABLE, CM_ENABLE_SIZE);
 	memcpy(QETH_CM_ENABLE_ISSUER_RM_TOKEN(iob->data),
 	       &card->token.issuer_rm_r, QETH_MPC_TOKEN_LENGTH);
 	memcpy(QETH_CM_ENABLE_FILTER_TOKEN(iob->data),
@@ -2137,10 +2139,11 @@ static int qeth_cm_setup(struct qeth_card *card)
 
 	QETH_DBF_TEXT(SETUP, 2, "cmsetup");
 
-	iob = qeth_wait_for_buffer(&card->write);
-	iob->finalize = qeth_mpc_finalize_cmd;
-	memcpy(iob->data, CM_SETUP, CM_SETUP_SIZE);
+	iob = qeth_mpc_get_cmd_buffer(card);
+	if (!iob)
+		return -ENOMEM;
 
+	memcpy(iob->data, CM_SETUP, CM_SETUP_SIZE);
 	memcpy(QETH_CM_SETUP_DEST_ADDR(iob->data),
 	       &card->token.issuer_rm_r, QETH_MPC_TOKEN_LENGTH);
 	memcpy(QETH_CM_SETUP_CONNECTION_TOKEN(iob->data),
@@ -2256,10 +2259,11 @@ static int qeth_ulp_enable(struct qeth_card *card)
 	/*FIXME: trace view callbacks*/
 	QETH_DBF_TEXT(SETUP, 2, "ulpenabl");
 
-	iob = qeth_wait_for_buffer(&card->write);
-	iob->finalize = qeth_mpc_finalize_cmd;
-	memcpy(iob->data, ULP_ENABLE, ULP_ENABLE_SIZE);
+	iob = qeth_mpc_get_cmd_buffer(card);
+	if (!iob)
+		return -ENOMEM;
 
+	memcpy(iob->data, ULP_ENABLE, ULP_ENABLE_SIZE);
 	*(QETH_ULP_ENABLE_LINKNUM(iob->data)) = (u8) card->dev->dev_port;
 	memcpy(QETH_ULP_ENABLE_PROT_TYPE(iob->data), &prot_type, 1);
 	memcpy(QETH_ULP_ENABLE_DEST_ADDR(iob->data),
@@ -2303,10 +2307,11 @@ static int qeth_ulp_setup(struct qeth_card *card)
 
 	QETH_DBF_TEXT(SETUP, 2, "ulpsetup");
 
-	iob = qeth_wait_for_buffer(&card->write);
-	iob->finalize = qeth_mpc_finalize_cmd;
-	memcpy(iob->data, ULP_SETUP, ULP_SETUP_SIZE);
+	iob = qeth_mpc_get_cmd_buffer(card);
+	if (!iob)
+		return -ENOMEM;
 
+	memcpy(iob->data, ULP_SETUP, ULP_SETUP_SIZE);
 	memcpy(QETH_ULP_SETUP_DEST_ADDR(iob->data),
 	       &card->token.cm_connection_r, QETH_MPC_TOKEN_LENGTH);
 	memcpy(QETH_ULP_SETUP_CONNECTION_TOKEN(iob->data),
@@ -2492,10 +2497,11 @@ static int qeth_dm_act(struct qeth_card *card)
 
 	QETH_DBF_TEXT(SETUP, 2, "dmact");
 
-	iob = qeth_wait_for_buffer(&card->write);
-	iob->finalize = qeth_mpc_finalize_cmd;
-	memcpy(iob->data, DM_ACT, DM_ACT_SIZE);
+	iob = qeth_mpc_get_cmd_buffer(card);
+	if (!iob)
+		return -ENOMEM;
 
+	memcpy(iob->data, DM_ACT, DM_ACT_SIZE);
 	memcpy(QETH_DM_ACT_DEST_ADDR(iob->data),
 	       &card->token.cm_connection_r, QETH_MPC_TOKEN_LENGTH);
 	memcpy(QETH_DM_ACT_CONNECTION_TOKEN(iob->data),
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 40e2f6bd0f09..5fa217382480 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -1084,7 +1084,10 @@ int qeth_osn_assist(struct net_device *dev, void *data, int data_len)
 	QETH_CARD_TEXT(card, 2, "osnsdmc");
 	if (!qeth_card_hw_is_reachable(card))
 		return -ENODEV;
-	iob = qeth_wait_for_buffer(&card->write);
+	iob = qeth_get_buffer(&card->write);
+	if (!iob)
+		return -ENOMEM;
+
 	qeth_prepare_ipa_cmd(card, iob, (u16) data_len);
 	memcpy(__ipa_cmd(iob), data, data_len);
 	return qeth_osn_send_ipa_cmd(card, iob);
-- 
2.17.1

