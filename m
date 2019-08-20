Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8CD9962D3
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 16:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730453AbfHTOrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 10:47:13 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47348 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730020AbfHTOrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 10:47:11 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KEXtKN141984
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 10:47:09 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ugh0jempj-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 10:47:03 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Tue, 20 Aug 2019 15:46:54 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 20 Aug 2019 15:46:52 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7KEkpYM58785900
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 14:46:51 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51AF111C052;
        Tue, 20 Aug 2019 14:46:51 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1347E11C050;
        Tue, 20 Aug 2019 14:46:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 20 Aug 2019 14:46:51 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 2/9] s390/qeth: propagate length of processed cmd IO data to callback
Date:   Tue, 20 Aug 2019 16:46:36 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190820144643.64041-1-jwi@linux.ibm.com>
References: <20190820144643.64041-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19082014-0016-0000-0000-000002A0BC83
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082014-0017-0000-0000-00003300EC64
Message-Id: <20190820144643.64041-3-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-20_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908200145
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When an cmd IO completes in qeth_irq(), calculate how much data was
processed by the device and pass this value to the cmd's callback.

This allows cmds that retrieve data from the device to check whether
sufficient data was received, so we do that in qeth_read_conf_data_cb().

Suggested-by: Jens Remus <jremus@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  3 ++-
 drivers/s390/net/qeth_core_main.c | 40 ++++++++++++++++++++++++-------
 drivers/s390/net/qeth_l2_main.c   |  3 ++-
 3 files changed, 35 insertions(+), 11 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 47e01cdd1775..4e21aa8edb13 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -580,7 +580,8 @@ struct qeth_cmd_buffer {
 	long timeout;
 	unsigned char *data;
 	void (*finalize)(struct qeth_card *card, struct qeth_cmd_buffer *iob);
-	void (*callback)(struct qeth_card *card, struct qeth_cmd_buffer *iob);
+	void (*callback)(struct qeth_card *card, struct qeth_cmd_buffer *iob,
+			 unsigned int data_length);
 };
 
 static inline void qeth_get_cmd(struct qeth_cmd_buffer *iob)
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 50f2773a1f8c..f7a8b8301eb4 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -63,7 +63,8 @@ static struct device *qeth_core_root_dev;
 static struct lock_class_key qdio_out_skb_queue_key;
 
 static void qeth_issue_next_read_cb(struct qeth_card *card,
-				    struct qeth_cmd_buffer *iob);
+				    struct qeth_cmd_buffer *iob,
+				    unsigned int data_length);
 static void qeth_free_buffer_pool(struct qeth_card *);
 static int qeth_qdio_establish(struct qeth_card *);
 static void qeth_free_qdio_queues(struct qeth_card *card);
@@ -702,7 +703,8 @@ void qeth_put_cmd(struct qeth_cmd_buffer *iob)
 EXPORT_SYMBOL_GPL(qeth_put_cmd);
 
 static void qeth_release_buffer_cb(struct qeth_card *card,
-				   struct qeth_cmd_buffer *iob)
+				   struct qeth_cmd_buffer *iob,
+				   unsigned int data_length)
 {
 	qeth_put_cmd(iob);
 }
@@ -745,7 +747,8 @@ struct qeth_cmd_buffer *qeth_alloc_cmd(struct qeth_channel *channel,
 EXPORT_SYMBOL_GPL(qeth_alloc_cmd);
 
 static void qeth_issue_next_read_cb(struct qeth_card *card,
-				    struct qeth_cmd_buffer *iob)
+				    struct qeth_cmd_buffer *iob,
+				    unsigned int data_length)
 {
 	struct qeth_ipa_cmd *cmd = NULL;
 	struct qeth_reply *reply = NULL;
@@ -1072,8 +1075,16 @@ static void qeth_irq(struct ccw_device *cdev, unsigned long intparm,
 		}
 	}
 
-	if (iob && iob->callback)
-		iob->callback(card, iob);
+	if (iob) {
+		/* sanity check: */
+		if (irb->scsw.cmd.count > iob->length) {
+			qeth_cancel_cmd(iob, -EIO);
+			goto out;
+		}
+		if (iob->callback)
+			iob->callback(card, iob,
+				      iob->length - irb->scsw.cmd.count);
+	}
 
 out:
 	wake_up(&card->wait_q);
@@ -1782,12 +1793,20 @@ struct qeth_node_desc {
 };
 
 static void qeth_read_conf_data_cb(struct qeth_card *card,
-				   struct qeth_cmd_buffer *iob)
+				   struct qeth_cmd_buffer *iob,
+				   unsigned int data_length)
 {
 	struct qeth_node_desc *nd = (struct qeth_node_desc *) iob->data;
+	int rc = 0;
 	u8 *tag;
 
 	QETH_CARD_TEXT(card, 2, "cfgunit");
+
+	if (data_length < sizeof(*nd)) {
+		rc = -EINVAL;
+		goto out;
+	}
+
 	card->info.is_vm_nic = nd->nd1.plant[0] == _ascebc['V'] &&
 			       nd->nd1.plant[1] == _ascebc['M'];
 	tag = (u8 *)&nd->nd1.tag;
@@ -1802,7 +1821,8 @@ static void qeth_read_conf_data_cb(struct qeth_card *card,
 				 nd->nd3.model[2] >= 0xF1 &&
 				 nd->nd3.model[2] <= 0xF4;
 
-	qeth_notify_reply(iob->reply, 0);
+out:
+	qeth_notify_reply(iob->reply, rc);
 	qeth_put_cmd(iob);
 }
 
@@ -1865,7 +1885,8 @@ static int qeth_idx_check_activate_response(struct qeth_card *card,
 }
 
 static void qeth_idx_activate_read_channel_cb(struct qeth_card *card,
-					      struct qeth_cmd_buffer *iob)
+					      struct qeth_cmd_buffer *iob,
+					      unsigned int data_length)
 {
 	struct qeth_channel *channel = iob->channel;
 	u16 peer_level;
@@ -1898,7 +1919,8 @@ static void qeth_idx_activate_read_channel_cb(struct qeth_card *card,
 }
 
 static void qeth_idx_activate_write_channel_cb(struct qeth_card *card,
-					       struct qeth_cmd_buffer *iob)
+					       struct qeth_cmd_buffer *iob,
+					       unsigned int data_length)
 {
 	struct qeth_channel *channel = iob->channel;
 	u16 peer_level;
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index cbead3d1b2fd..c524c8bff3c7 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -1000,7 +1000,8 @@ struct qeth_discipline qeth_l2_discipline = {
 EXPORT_SYMBOL_GPL(qeth_l2_discipline);
 
 static void qeth_osn_assist_cb(struct qeth_card *card,
-			       struct qeth_cmd_buffer *iob)
+			       struct qeth_cmd_buffer *iob,
+			       unsigned int data_length)
 {
 	qeth_notify_reply(iob->reply, 0);
 	qeth_put_cmd(iob);
-- 
2.17.1

