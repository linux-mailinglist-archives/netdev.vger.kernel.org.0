Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7B3D3D274
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 18:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405659AbfFKQid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 12:38:33 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40700 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2405610AbfFKQiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 12:38:16 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5BGR2Nu186438
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 12:38:14 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2t2f9qa9km-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 12:38:14 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Tue, 11 Jun 2019 17:38:12 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 11 Jun 2019 17:38:10 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5BGc9XT35258458
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jun 2019 16:38:09 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 155824C050;
        Tue, 11 Jun 2019 16:38:09 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C58064C05C;
        Tue, 11 Jun 2019 16:38:08 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jun 2019 16:38:08 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 12/13] s390/qeth: command-chain the IDX sequence
Date:   Tue, 11 Jun 2019 18:37:59 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190611163800.64730-1-jwi@linux.ibm.com>
References: <20190611163800.64730-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19061116-0012-0000-0000-000003283B18
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061116-0013-0000-0000-000021613E71
Message-Id: <20190611163800.64730-13-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-11_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906110106
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current IDX sequence first sends one WRITE cmd to activate the
device, and then sends a second cmd that READs the response.

Using qeth_alloc_cmd(), we can combine this into a single IO with two
command-chained CCWs.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core_main.c | 58 ++++++++-----------------------
 1 file changed, 14 insertions(+), 44 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 671754a0e591..11e6a3820421 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1709,9 +1709,6 @@ static void qeth_idx_finalize_cmd(struct qeth_card *card,
 				  struct qeth_cmd_buffer *iob,
 				  unsigned int length)
 {
-	qeth_setup_ccw(__ccw_from_cmd(iob), CCW_CMD_WRITE, 0, length,
-		       iob->data);
-
 	memcpy(QETH_TRANSPORT_HEADER_SEQ_NO(iob->data), &card->seqno.trans_hdr,
 	       QETH_SEQ_NO_LENGTH);
 	if (iob->channel == &card->write)
@@ -1731,6 +1728,8 @@ static void qeth_mpc_finalize_cmd(struct qeth_card *card,
 				  struct qeth_cmd_buffer *iob,
 				  unsigned int length)
 {
+	qeth_setup_ccw(__ccw_from_cmd(iob), CCW_CMD_WRITE, 0, length,
+		       iob->data);
 	qeth_idx_finalize_cmd(card, iob, length);
 
 	memcpy(QETH_PDU_HEADER_SEQ_NO(iob->data),
@@ -1920,8 +1919,8 @@ static int qeth_idx_check_activate_response(struct qeth_card *card,
 	}
 }
 
-static void qeth_idx_query_read_cb(struct qeth_card *card,
-				   struct qeth_cmd_buffer *iob)
+static void qeth_idx_activate_read_channel_cb(struct qeth_card *card,
+					      struct qeth_cmd_buffer *iob)
 {
 	struct qeth_channel *channel = iob->channel;
 	u16 peer_level;
@@ -1953,8 +1952,8 @@ static void qeth_idx_query_read_cb(struct qeth_card *card,
 	qeth_release_buffer(iob);
 }
 
-static void qeth_idx_query_write_cb(struct qeth_card *card,
-				    struct qeth_cmd_buffer *iob)
+static void qeth_idx_activate_write_channel_cb(struct qeth_card *card,
+					       struct qeth_cmd_buffer *iob)
 {
 	struct qeth_channel *channel = iob->channel;
 	u16 peer_level;
@@ -1980,30 +1979,19 @@ static void qeth_idx_query_write_cb(struct qeth_card *card,
 	qeth_release_buffer(iob);
 }
 
-static void qeth_idx_finalize_query_cmd(struct qeth_card *card,
-					struct qeth_cmd_buffer *iob,
-					unsigned int length)
-{
-	qeth_setup_ccw(__ccw_from_cmd(iob), CCW_CMD_READ, 0, length, iob->data);
-}
-
-static void qeth_idx_activate_cb(struct qeth_card *card,
-				 struct qeth_cmd_buffer *iob)
-{
-	qeth_notify_reply(iob->reply, 0);
-	qeth_release_buffer(iob);
-}
-
 static void qeth_idx_setup_activate_cmd(struct qeth_card *card,
 					struct qeth_cmd_buffer *iob)
 {
 	u16 addr = (card->info.cula << 8) + card->info.unit_addr2;
 	u8 port = ((u8)card->dev->dev_port) | 0x80;
+	struct ccw1 *ccw = __ccw_from_cmd(iob);
 	struct ccw_dev_id dev_id;
 
+	qeth_setup_ccw(&ccw[0], CCW_CMD_WRITE, CCW_FLAG_CC, IDX_ACTIVATE_SIZE,
+		       iob->data);
+	qeth_setup_ccw(&ccw[1], CCW_CMD_READ, 0, iob->length, iob->data);
 	ccw_device_get_id(CARD_DDEV(card), &dev_id);
 	iob->finalize = qeth_idx_finalize_cmd;
-	iob->callback = qeth_idx_activate_cb;
 
 	memcpy(QETH_IDX_ACT_PNO(iob->data), &port, 1);
 	memcpy(QETH_IDX_ACT_ISSUER_RM_TOKEN(iob->data),
@@ -2022,27 +2010,18 @@ static int qeth_idx_activate_read_channel(struct qeth_card *card)
 
 	QETH_CARD_TEXT(card, 2, "idxread");
 
-	iob = qeth_get_buffer(channel);
+	iob = qeth_alloc_cmd(channel, QETH_BUFSIZE, 2, QETH_TIMEOUT);
 	if (!iob)
 		return -ENOMEM;
 
 	memcpy(iob->data, IDX_ACTIVATE_READ, IDX_ACTIVATE_SIZE);
 	qeth_idx_setup_activate_cmd(card, iob);
+	iob->callback = qeth_idx_activate_read_channel_cb;
 
 	rc = qeth_send_control_data(card, IDX_ACTIVATE_SIZE, iob, NULL, NULL);
 	if (rc)
 		return rc;
 
-	iob = qeth_get_buffer(channel);
-	if (!iob)
-		return -ENOMEM;
-
-	iob->finalize = qeth_idx_finalize_query_cmd;
-	iob->callback = qeth_idx_query_read_cb;
-	rc = qeth_send_control_data(card, QETH_BUFSIZE, iob, NULL, NULL);
-	if (rc)
-		return rc;
-
 	channel->state = CH_STATE_UP;
 	return 0;
 }
@@ -2055,27 +2034,18 @@ static int qeth_idx_activate_write_channel(struct qeth_card *card)
 
 	QETH_CARD_TEXT(card, 2, "idxwrite");
 
-	iob = qeth_get_buffer(channel);
+	iob = qeth_alloc_cmd(channel, QETH_BUFSIZE, 2, QETH_TIMEOUT);
 	if (!iob)
 		return -ENOMEM;
 
 	memcpy(iob->data, IDX_ACTIVATE_WRITE, IDX_ACTIVATE_SIZE);
 	qeth_idx_setup_activate_cmd(card, iob);
+	iob->callback = qeth_idx_activate_write_channel_cb;
 
 	rc = qeth_send_control_data(card, IDX_ACTIVATE_SIZE, iob, NULL, NULL);
 	if (rc)
 		return rc;
 
-	iob = qeth_get_buffer(channel);
-	if (!iob)
-		return -ENOMEM;
-
-	iob->finalize = qeth_idx_finalize_query_cmd;
-	iob->callback = qeth_idx_query_write_cb;
-	rc = qeth_send_control_data(card, QETH_BUFSIZE, iob, NULL, NULL);
-	if (rc)
-		return rc;
-
 	channel->state = CH_STATE_UP;
 	return 0;
 }
-- 
2.17.1

