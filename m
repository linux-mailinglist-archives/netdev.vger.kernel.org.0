Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3223D26C
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 18:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405653AbfFKQiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 12:38:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43400 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404499AbfFKQiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 12:38:17 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5BGR5jf080632
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 12:38:17 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t2fc4j3w2-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 12:38:16 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Tue, 11 Jun 2019 17:38:14 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 11 Jun 2019 17:38:11 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5BGc9dU21364978
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jun 2019 16:38:09 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 729B74C050;
        Tue, 11 Jun 2019 16:38:09 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E3C34C058;
        Tue, 11 Jun 2019 16:38:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jun 2019 16:38:09 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 13/13] s390/qeth: allocate a single cmd on read channel
Date:   Tue, 11 Jun 2019 18:38:00 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190611163800.64730-1-jwi@linux.ibm.com>
References: <20190611163800.64730-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19061116-0008-0000-0000-000002F2611D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061116-0009-0000-0000-0000225F5DB9
Message-Id: <20190611163800.64730-14-jwi@linux.ibm.com>
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

We statically allocate 8 cmd buffers on the read channel, when the only
IO left that's still using them is the long-running READ.
Replace this with a single allocated cmd, that gets restarted whenever
the READ completed.

This introduces refcounting for allocated cmds, so that the READ cmd can
survive the IO completion.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  7 ++++
 drivers/s390/net/qeth_core_main.c | 54 ++++++++++++++++++-------------
 drivers/s390/net/qeth_l2_main.c   |  1 -
 drivers/s390/net/qeth_l3_main.c   |  1 -
 4 files changed, 39 insertions(+), 24 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 962945a63235..5bcdede5e955 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -579,6 +579,7 @@ struct qeth_channel;
 struct qeth_cmd_buffer {
 	enum qeth_cmd_buffer_state state;
 	unsigned int length;
+	refcount_t ref_count;
 	struct qeth_channel *channel;
 	struct qeth_reply *reply;
 	long timeout;
@@ -588,6 +589,11 @@ struct qeth_cmd_buffer {
 	void (*callback)(struct qeth_card *card, struct qeth_cmd_buffer *iob);
 };
 
+static inline void qeth_get_cmd(struct qeth_cmd_buffer *iob)
+{
+	refcount_inc(&iob->ref_count);
+}
+
 static inline struct qeth_ipa_cmd *__ipa_cmd(struct qeth_cmd_buffer *iob)
 {
 	return (struct qeth_ipa_cmd *)(iob->data + IPA_PDU_HEADER_SIZE);
@@ -771,6 +777,7 @@ struct qeth_card {
 	enum qeth_card_states state;
 	spinlock_t lock;
 	struct ccwgroup_device *gdev;
+	struct qeth_cmd_buffer *read_cmd;
 	struct qeth_channel read;
 	struct qeth_channel write;
 	struct qeth_channel data;
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 11e6a3820421..fe3dfeaf5ceb 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -496,26 +496,21 @@ static void qeth_setup_ccw(struct ccw1 *ccw, u8 cmd_code, u8 flags, u32 len,
 
 static int __qeth_issue_next_read(struct qeth_card *card)
 {
-	struct qeth_channel *channel = &card->read;
-	struct qeth_cmd_buffer *iob;
-	struct ccw1 *ccw;
+	struct qeth_cmd_buffer *iob = card->read_cmd;
+	struct qeth_channel *channel = iob->channel;
+	struct ccw1 *ccw = __ccw_from_cmd(iob);
 	int rc;
 
 	QETH_CARD_TEXT(card, 5, "issnxrd");
 	if (channel->state != CH_STATE_UP)
 		return -EIO;
-	iob = qeth_get_buffer(channel);
-	if (!iob) {
-		dev_warn(&card->gdev->dev, "The qeth device driver "
-			"failed to recover an error on the device\n");
-		QETH_DBF_MESSAGE(2, "issue_next_read on device %x failed: no iob available\n",
-				 CARD_DEVID(card));
-		return -ENOMEM;
-	}
 
-	ccw = __ccw_from_cmd(iob);
-	qeth_setup_ccw(ccw, CCW_CMD_READ, 0, QETH_BUFSIZE, iob->data);
+	memset(iob->data, 0, iob->length);
+	qeth_setup_ccw(ccw, CCW_CMD_READ, 0, iob->length, iob->data);
 	iob->callback = qeth_issue_next_read_cb;
+	/* keep the cmd alive after completion: */
+	qeth_get_cmd(iob);
+
 	QETH_CARD_TEXT(card, 6, "noirqpnd");
 	rc = ccw_device_start(channel->ccwdev, ccw, (addr_t) iob, 0, 0);
 	if (rc) {
@@ -694,6 +689,16 @@ static int qeth_check_idx_response(struct qeth_card *card,
 	return 0;
 }
 
+static void qeth_put_cmd(struct qeth_cmd_buffer *iob)
+{
+	if (refcount_dec_and_test(&iob->ref_count)) {
+		if (iob->reply)
+			qeth_put_reply(iob->reply);
+		kfree(iob->data);
+		kfree(iob);
+	}
+}
+
 static struct qeth_cmd_buffer *__qeth_get_buffer(struct qeth_channel *channel)
 {
 	__u8 index;
@@ -720,10 +725,7 @@ void qeth_release_buffer(struct qeth_cmd_buffer *iob)
 	unsigned long flags;
 
 	if (iob->state == BUF_STATE_MALLOC) {
-		if (iob->reply)
-			qeth_put_reply(iob->reply);
-		kfree(iob->data);
-		kfree(iob);
+		qeth_put_cmd(iob);
 		return;
 	}
 
@@ -787,6 +789,7 @@ static struct qeth_cmd_buffer *qeth_alloc_cmd(struct qeth_channel *channel,
 	}
 
 	iob->state = BUF_STATE_MALLOC;
+	refcount_set(&iob->ref_count, 1);
 	iob->channel = channel;
 	iob->timeout = timeout;
 	iob->length = length;
@@ -1445,10 +1448,14 @@ static struct qeth_card *qeth_alloc_card(struct ccwgroup_device *gdev)
 						 dev_name(&gdev->dev));
 	if (!card->event_wq)
 		goto out_wq;
-	if (qeth_setup_channel(&card->read, true))
-		goto out_ip;
+
+	card->read_cmd = qeth_alloc_cmd(&card->read, QETH_BUFSIZE, 1, 0);
+	if (!card->read_cmd)
+		goto out_read_cmd;
+	if (qeth_setup_channel(&card->read, false))
+		goto out_read;
 	if (qeth_setup_channel(&card->write, true))
-		goto out_channel;
+		goto out_write;
 	if (qeth_setup_channel(&card->data, false))
 		goto out_data;
 	card->qeth_service_level.seq_print = qeth_core_sl_print;
@@ -1457,9 +1464,11 @@ static struct qeth_card *qeth_alloc_card(struct ccwgroup_device *gdev)
 
 out_data:
 	qeth_clean_channel(&card->write);
-out_channel:
+out_write:
 	qeth_clean_channel(&card->read);
-out_ip:
+out_read:
+	qeth_release_buffer(card->read_cmd);
+out_read_cmd:
 	destroy_workqueue(card->event_wq);
 out_wq:
 	dev_set_drvdata(&gdev->dev, NULL);
@@ -4892,6 +4901,7 @@ static void qeth_core_free_card(struct qeth_card *card)
 	qeth_clean_channel(&card->read);
 	qeth_clean_channel(&card->write);
 	qeth_clean_channel(&card->data);
+	qeth_release_buffer(card->read_cmd);
 	destroy_workqueue(card->event_wq);
 	qeth_free_qdio_queues(card);
 	unregister_service_level(&card->qeth_service_level);
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index e1b25084dcd4..9565ef9747c1 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -292,7 +292,6 @@ static void qeth_l2_stop_card(struct qeth_card *card)
 		card->state = CARD_STATE_DOWN;
 	}
 
-	qeth_clear_cmd_buffers(&card->read);
 	qeth_clear_cmd_buffers(&card->write);
 	flush_workqueue(card->event_wq);
 	card->info.mac_bits &= ~QETH_LAYER2_MAC_REGISTERED;
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 15758f45837d..4d66f9556451 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1436,7 +1436,6 @@ static void qeth_l3_stop_card(struct qeth_card *card)
 		card->state = CARD_STATE_DOWN;
 	}
 
-	qeth_clear_cmd_buffers(&card->read);
 	qeth_clear_cmd_buffers(&card->write);
 	flush_workqueue(card->event_wq);
 }
-- 
2.17.1

