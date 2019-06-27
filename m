Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70D9E58515
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 17:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfF0PC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 11:02:26 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46286 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726480AbfF0PCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 11:02:25 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5RF22Ri045558
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 11:02:25 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tcxnx5e5u-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 11:02:20 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 27 Jun 2019 16:01:40 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 27 Jun 2019 16:01:38 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5RF1bde44171350
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 15:01:37 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D66FA4064;
        Thu, 27 Jun 2019 15:01:37 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05064A406E;
        Thu, 27 Jun 2019 15:01:37 +0000 (GMT)
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
Subject: [PATCH net-next 06/12] s390/qeth: dynamically allocate MPC cmds
Date:   Thu, 27 Jun 2019 17:01:27 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190627150133.58746-1-jwi@linux.ibm.com>
References: <20190627150133.58746-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19062715-0012-0000-0000-0000032D1639
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062715-0013-0000-0000-0000216654DB
Message-Id: <20190627150133.58746-7-jwi@linux.ibm.com>
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

The base MPC cmds are the last remaining user of the static cmd buffers.
Port them over to use dynamic allocation, and stop backing the write
channel's cmd buffers with pages.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 36 ++++++++++++++++---------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 22074890835e..b4c200eec707 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1454,7 +1454,7 @@ static struct qeth_card *qeth_alloc_card(struct ccwgroup_device *gdev)
 		goto out_read_cmd;
 	if (qeth_setup_channel(&card->read, false))
 		goto out_read;
-	if (qeth_setup_channel(&card->write, true))
+	if (qeth_setup_channel(&card->write, false))
 		goto out_write;
 	if (qeth_setup_channel(&card->data, false))
 		goto out_data;
@@ -1737,8 +1737,6 @@ static void qeth_mpc_finalize_cmd(struct qeth_card *card,
 				  struct qeth_cmd_buffer *iob,
 				  unsigned int length)
 {
-	qeth_setup_ccw(__ccw_from_cmd(iob), CCW_CMD_WRITE, 0, length,
-		       iob->data);
 	qeth_idx_finalize_cmd(card, iob, length);
 
 	memcpy(QETH_PDU_HEADER_SEQ_NO(iob->data),
@@ -1751,13 +1749,20 @@ static void qeth_mpc_finalize_cmd(struct qeth_card *card,
 	iob->callback = qeth_release_buffer_cb;
 }
 
-static struct qeth_cmd_buffer *qeth_mpc_get_cmd_buffer(struct qeth_card *card)
+static struct qeth_cmd_buffer *qeth_mpc_alloc_cmd(struct qeth_card *card,
+						  void *data,
+						  unsigned int data_length)
 {
 	struct qeth_cmd_buffer *iob;
 
-	iob = qeth_get_buffer(&card->write);
-	if (iob)
-		iob->finalize = qeth_mpc_finalize_cmd;
+	iob = qeth_alloc_cmd(&card->write, data_length, 1, QETH_TIMEOUT);
+	if (!iob)
+		return NULL;
+
+	memcpy(iob->data, data, data_length);
+	qeth_setup_ccw(__ccw_from_cmd(iob), CCW_CMD_WRITE, 0, data_length,
+		       iob->data);
+	iob->finalize = qeth_mpc_finalize_cmd;
 	return iob;
 }
 
@@ -2080,11 +2085,10 @@ static int qeth_cm_enable(struct qeth_card *card)
 
 	QETH_CARD_TEXT(card, 2, "cmenable");
 
-	iob = qeth_mpc_get_cmd_buffer(card);
+	iob = qeth_mpc_alloc_cmd(card, CM_ENABLE, CM_ENABLE_SIZE);
 	if (!iob)
 		return -ENOMEM;
 
-	memcpy(iob->data, CM_ENABLE, CM_ENABLE_SIZE);
 	memcpy(QETH_CM_ENABLE_ISSUER_RM_TOKEN(iob->data),
 	       &card->token.issuer_rm_r, QETH_MPC_TOKEN_LENGTH);
 	memcpy(QETH_CM_ENABLE_FILTER_TOKEN(iob->data),
@@ -2116,11 +2120,10 @@ static int qeth_cm_setup(struct qeth_card *card)
 
 	QETH_CARD_TEXT(card, 2, "cmsetup");
 
-	iob = qeth_mpc_get_cmd_buffer(card);
+	iob = qeth_mpc_alloc_cmd(card, CM_SETUP, CM_SETUP_SIZE);
 	if (!iob)
 		return -ENOMEM;
 
-	memcpy(iob->data, CM_SETUP, CM_SETUP_SIZE);
 	memcpy(QETH_CM_SETUP_DEST_ADDR(iob->data),
 	       &card->token.issuer_rm_r, QETH_MPC_TOKEN_LENGTH);
 	memcpy(QETH_CM_SETUP_CONNECTION_TOKEN(iob->data),
@@ -2235,11 +2238,10 @@ static int qeth_ulp_enable(struct qeth_card *card)
 
 	QETH_CARD_TEXT(card, 2, "ulpenabl");
 
-	iob = qeth_mpc_get_cmd_buffer(card);
+	iob = qeth_mpc_alloc_cmd(card, ULP_ENABLE, ULP_ENABLE_SIZE);
 	if (!iob)
 		return -ENOMEM;
 
-	memcpy(iob->data, ULP_ENABLE, ULP_ENABLE_SIZE);
 	*(QETH_ULP_ENABLE_LINKNUM(iob->data)) = (u8) card->dev->dev_port;
 	memcpy(QETH_ULP_ENABLE_PROT_TYPE(iob->data), &prot_type, 1);
 	memcpy(QETH_ULP_ENABLE_DEST_ADDR(iob->data),
@@ -2283,11 +2285,10 @@ static int qeth_ulp_setup(struct qeth_card *card)
 
 	QETH_CARD_TEXT(card, 2, "ulpsetup");
 
-	iob = qeth_mpc_get_cmd_buffer(card);
+	iob = qeth_mpc_alloc_cmd(card, ULP_SETUP, ULP_SETUP_SIZE);
 	if (!iob)
 		return -ENOMEM;
 
-	memcpy(iob->data, ULP_SETUP, ULP_SETUP_SIZE);
 	memcpy(QETH_ULP_SETUP_DEST_ADDR(iob->data),
 	       &card->token.cm_connection_r, QETH_MPC_TOKEN_LENGTH);
 	memcpy(QETH_ULP_SETUP_CONNECTION_TOKEN(iob->data),
@@ -2473,11 +2474,10 @@ static int qeth_dm_act(struct qeth_card *card)
 
 	QETH_CARD_TEXT(card, 2, "dmact");
 
-	iob = qeth_mpc_get_cmd_buffer(card);
+	iob = qeth_mpc_alloc_cmd(card, DM_ACT, DM_ACT_SIZE);
 	if (!iob)
 		return -ENOMEM;
 
-	memcpy(iob->data, DM_ACT, DM_ACT_SIZE);
 	memcpy(QETH_DM_ACT_DEST_ADDR(iob->data),
 	       &card->token.cm_connection_r, QETH_MPC_TOKEN_LENGTH);
 	memcpy(QETH_DM_ACT_CONNECTION_TOKEN(iob->data),
@@ -2770,6 +2770,8 @@ void qeth_prepare_ipa_cmd(struct qeth_card *card, struct qeth_cmd_buffer *iob,
 	u16 total_length = IPA_PDU_HEADER_SIZE + cmd_length;
 	u8 prot_type = qeth_mpc_select_prot_type(card);
 
+	qeth_setup_ccw(__ccw_from_cmd(iob), CCW_CMD_WRITE, 0, total_length,
+		       iob->data);
 	iob->finalize = qeth_ipa_finalize_cmd;
 	iob->timeout = QETH_IPA_TIMEOUT;
 
-- 
2.17.1

