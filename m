Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8D8962D1
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 16:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730432AbfHTOrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 10:47:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57836 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730296AbfHTOrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 10:47:00 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7KEiD4Z019276
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 10:46:58 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ughmvcn2m-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 10:46:58 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Tue, 20 Aug 2019 15:46:56 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 20 Aug 2019 15:46:54 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7KEkqFN53608494
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 14:46:52 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4076211C04C;
        Tue, 20 Aug 2019 14:46:52 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F164E11C054;
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
Subject: [PATCH net-next 5/9] s390/qeth: merge qeth_reply struct into qeth_cmd_buffer
Date:   Tue, 20 Aug 2019 16:46:39 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190820144643.64041-1-jwi@linux.ibm.com>
References: <20190820144643.64041-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19082014-0028-0000-0000-00000391B9E1
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082014-0029-0000-0000-00002453DE3B
Message-Id: <20190820144643.64041-6-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-20_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908200145
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Except for card->read_cmd, every cmd we issue now passes through
qeth_send_control_data() and allocates a qeth_reply struct. The way we
use this struct requires additional refcounting, and pointer tracking.

Clean up things by moving most of qeth_reply's content into the main
cmd struct. This keeps things in one place, saves us the additional
refcounting and simplifies the overall code flow.
A nice little benefit is that we can now match incoming replies against
the pending requests themselves, without caching the requests' seqnos.

The qeth_reply struct stays around for a little bit longer in a shrunk
form, to avoid touching every single callback.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  26 +++---
 drivers/s390/net/qeth_core_main.c | 126 +++++++++++-------------------
 drivers/s390/net/qeth_core_mpc.h  |   1 -
 drivers/s390/net/qeth_l2_main.c   |   2 +-
 4 files changed, 58 insertions(+), 97 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index f6e58a51c366..f07bb7130280 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -572,16 +572,26 @@ struct qeth_channel {
 	atomic_t irq_pending;
 };
 
+struct qeth_reply {
+	int (*callback)(struct qeth_card *card, struct qeth_reply *reply,
+			unsigned long data);
+	void *param;
+};
+
 struct qeth_cmd_buffer {
+	struct list_head list;
+	struct completion done;
+	spinlock_t lock;
 	unsigned int length;
 	refcount_t ref_count;
 	struct qeth_channel *channel;
-	struct qeth_reply *reply;
+	struct qeth_reply reply;
 	long timeout;
 	unsigned char *data;
 	void (*finalize)(struct qeth_card *card, struct qeth_cmd_buffer *iob);
 	void (*callback)(struct qeth_card *card, struct qeth_cmd_buffer *iob,
 			 unsigned int data_length);
+	int rc;
 };
 
 static inline void qeth_get_cmd(struct qeth_cmd_buffer *iob)
@@ -627,18 +637,6 @@ struct qeth_seqno {
 	__u16 ipa;
 };
 
-struct qeth_reply {
-	struct list_head list;
-	struct completion received;
-	spinlock_t lock;
-	int (*callback)(struct qeth_card *, struct qeth_reply *,
-		unsigned long);
-	u32 seqno;
-	int rc;
-	void *param;
-	refcount_t refcnt;
-};
-
 struct qeth_card_blkt {
 	int time_total;
 	int inter_packet;
@@ -994,6 +992,7 @@ struct qeth_cmd_buffer *qeth_get_setassparms_cmd(struct qeth_card *card,
 struct qeth_cmd_buffer *qeth_get_diag_cmd(struct qeth_card *card,
 					  enum qeth_diags_cmds sub_cmd,
 					  unsigned int data_length);
+void qeth_notify_cmd(struct qeth_cmd_buffer *iob, int reason);
 void qeth_put_cmd(struct qeth_cmd_buffer *iob);
 
 struct sk_buff *qeth_core_get_next_skb(struct qeth_card *,
@@ -1008,7 +1007,6 @@ void qeth_drain_output_queues(struct qeth_card *card);
 void qeth_setadp_promisc_mode(struct qeth_card *);
 int qeth_setadpparms_change_macaddr(struct qeth_card *);
 void qeth_tx_timeout(struct net_device *);
-void qeth_notify_reply(struct qeth_reply *reply, int reason);
 void qeth_prepare_ipa_cmd(struct qeth_card *card, struct qeth_cmd_buffer *iob,
 			  u16 cmd_length);
 int qeth_query_switch_attributes(struct qeth_card *card,
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 3fc14f222dc3..95996ce99145 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -537,50 +537,28 @@ static int qeth_issue_next_read(struct qeth_card *card)
 	return ret;
 }
 
-static struct qeth_reply *qeth_alloc_reply(struct qeth_card *card)
-{
-	struct qeth_reply *reply;
-
-	reply = kzalloc(sizeof(*reply), GFP_KERNEL);
-	if (reply) {
-		refcount_set(&reply->refcnt, 1);
-		init_completion(&reply->received);
-		spin_lock_init(&reply->lock);
-	}
-	return reply;
-}
-
-static void qeth_get_reply(struct qeth_reply *reply)
-{
-	refcount_inc(&reply->refcnt);
-}
-
-static void qeth_put_reply(struct qeth_reply *reply)
-{
-	if (refcount_dec_and_test(&reply->refcnt))
-		kfree(reply);
-}
-
-static void qeth_enqueue_reply(struct qeth_card *card, struct qeth_reply *reply)
+static void qeth_enqueue_cmd(struct qeth_card *card,
+			     struct qeth_cmd_buffer *iob)
 {
 	spin_lock_irq(&card->lock);
-	list_add_tail(&reply->list, &card->cmd_waiter_list);
+	list_add_tail(&iob->list, &card->cmd_waiter_list);
 	spin_unlock_irq(&card->lock);
 }
 
-static void qeth_dequeue_reply(struct qeth_card *card, struct qeth_reply *reply)
+static void qeth_dequeue_cmd(struct qeth_card *card,
+			     struct qeth_cmd_buffer *iob)
 {
 	spin_lock_irq(&card->lock);
-	list_del(&reply->list);
+	list_del(&iob->list);
 	spin_unlock_irq(&card->lock);
 }
 
-void qeth_notify_reply(struct qeth_reply *reply, int reason)
+void qeth_notify_cmd(struct qeth_cmd_buffer *iob, int reason)
 {
-	reply->rc = reason;
-	complete(&reply->received);
+	iob->rc = reason;
+	complete(&iob->done);
 }
-EXPORT_SYMBOL_GPL(qeth_notify_reply);
+EXPORT_SYMBOL_GPL(qeth_notify_cmd);
 
 static void qeth_issue_ipa_msg(struct qeth_ipa_cmd *cmd, int rc,
 		struct qeth_card *card)
@@ -658,14 +636,14 @@ static struct qeth_ipa_cmd *qeth_check_ipa_data(struct qeth_card *card,
 
 void qeth_clear_ipacmd_list(struct qeth_card *card)
 {
-	struct qeth_reply *reply;
+	struct qeth_cmd_buffer *iob;
 	unsigned long flags;
 
 	QETH_CARD_TEXT(card, 4, "clipalst");
 
 	spin_lock_irqsave(&card->lock, flags);
-	list_for_each_entry(reply, &card->cmd_waiter_list, list)
-		qeth_notify_reply(reply, -EIO);
+	list_for_each_entry(iob, &card->cmd_waiter_list, list)
+		qeth_notify_cmd(iob, -EIO);
 	spin_unlock_irqrestore(&card->lock, flags);
 }
 EXPORT_SYMBOL_GPL(qeth_clear_ipacmd_list);
@@ -694,8 +672,6 @@ static int qeth_check_idx_response(struct qeth_card *card,
 void qeth_put_cmd(struct qeth_cmd_buffer *iob)
 {
 	if (refcount_dec_and_test(&iob->ref_count)) {
-		if (iob->reply)
-			qeth_put_reply(iob->reply);
 		kfree(iob->data);
 		kfree(iob);
 	}
@@ -711,10 +687,7 @@ static void qeth_release_buffer_cb(struct qeth_card *card,
 
 static void qeth_cancel_cmd(struct qeth_cmd_buffer *iob, int rc)
 {
-	struct qeth_reply *reply = iob->reply;
-
-	if (reply)
-		qeth_notify_reply(reply, rc);
+	qeth_notify_cmd(iob, rc);
 	qeth_put_cmd(iob);
 }
 
@@ -738,6 +711,9 @@ struct qeth_cmd_buffer *qeth_alloc_cmd(struct qeth_channel *channel,
 		return NULL;
 	}
 
+	init_completion(&iob->done);
+	spin_lock_init(&iob->lock);
+	INIT_LIST_HEAD(&iob->list);
 	refcount_set(&iob->ref_count, 1);
 	iob->channel = channel;
 	iob->timeout = timeout;
@@ -750,9 +726,10 @@ static void qeth_issue_next_read_cb(struct qeth_card *card,
 				    struct qeth_cmd_buffer *iob,
 				    unsigned int data_length)
 {
+	struct qeth_cmd_buffer *request = NULL;
 	struct qeth_ipa_cmd *cmd = NULL;
 	struct qeth_reply *reply = NULL;
-	struct qeth_reply *r;
+	struct qeth_cmd_buffer *tmp;
 	unsigned long flags;
 	int rc = 0;
 
@@ -787,39 +764,39 @@ static void qeth_issue_next_read_cb(struct qeth_card *card,
 
 	/* match against pending cmd requests */
 	spin_lock_irqsave(&card->lock, flags);
-	list_for_each_entry(r, &card->cmd_waiter_list, list) {
-		if ((r->seqno == QETH_IDX_COMMAND_SEQNO) ||
-		    (cmd && (r->seqno == cmd->hdr.seqno))) {
-			reply = r;
+	list_for_each_entry(tmp, &card->cmd_waiter_list, list) {
+		if (!IS_IPA(tmp->data) ||
+		    __ipa_cmd(tmp)->hdr.seqno == cmd->hdr.seqno) {
+			request = tmp;
 			/* take the object outside the lock */
-			qeth_get_reply(reply);
+			qeth_get_cmd(request);
 			break;
 		}
 	}
 	spin_unlock_irqrestore(&card->lock, flags);
 
-	if (!reply)
+	if (!request)
 		goto out;
 
+	reply = &request->reply;
 	if (!reply->callback) {
 		rc = 0;
 		goto no_callback;
 	}
 
-	spin_lock_irqsave(&reply->lock, flags);
-	if (reply->rc)
+	spin_lock_irqsave(&request->lock, flags);
+	if (request->rc)
 		/* Bail out when the requestor has already left: */
-		rc = reply->rc;
+		rc = request->rc;
 	else
 		rc = reply->callback(card, reply, cmd ? (unsigned long)cmd :
 							(unsigned long)iob);
-	spin_unlock_irqrestore(&reply->lock, flags);
+	spin_unlock_irqrestore(&request->lock, flags);
 
 no_callback:
 	if (rc <= 0)
-		qeth_notify_reply(reply, rc);
-	qeth_put_reply(reply);
-
+		qeth_notify_cmd(request, rc);
+	qeth_put_cmd(request);
 out:
 	memcpy(&card->seqno.pdu_hdr_ack,
 		QETH_PDU_HEADER_SEQ_NO(iob->data),
@@ -1658,7 +1635,6 @@ static void qeth_mpc_finalize_cmd(struct qeth_card *card,
 	memcpy(QETH_PDU_HEADER_ACK_SEQ_NO(iob->data),
 	       &card->seqno.pdu_hdr_ack, QETH_SEQ_NO_LENGTH);
 
-	iob->reply->seqno = QETH_IDX_COMMAND_SEQNO;
 	iob->callback = qeth_release_buffer_cb;
 }
 
@@ -1709,29 +1685,19 @@ static int qeth_send_control_data(struct qeth_card *card,
 				  void *reply_param)
 {
 	struct qeth_channel *channel = iob->channel;
+	struct qeth_reply *reply = &iob->reply;
 	long timeout = iob->timeout;
 	int rc;
-	struct qeth_reply *reply = NULL;
 
 	QETH_CARD_TEXT(card, 2, "sendctl");
 
-	reply = qeth_alloc_reply(card);
-	if (!reply) {
-		qeth_put_cmd(iob);
-		return -ENOMEM;
-	}
 	reply->callback = reply_cb;
 	reply->param = reply_param;
 
-	/* pairs with qeth_put_cmd(): */
-	qeth_get_reply(reply);
-	iob->reply = reply;
-
 	timeout = wait_event_interruptible_timeout(card->wait_q,
 						   qeth_trylock_channel(channel),
 						   timeout);
 	if (timeout <= 0) {
-		qeth_put_reply(reply);
 		qeth_put_cmd(iob);
 		return (timeout == -ERESTARTSYS) ? -EINTR : -ETIME;
 	}
@@ -1740,7 +1706,7 @@ static int qeth_send_control_data(struct qeth_card *card,
 		iob->finalize(card, iob);
 	QETH_DBF_HEX(CTRL, 2, iob->data, min(iob->length, QETH_DBF_CTRL_LEN));
 
-	qeth_enqueue_reply(card, reply);
+	qeth_enqueue_cmd(card, iob);
 
 	/* This pairs with iob->callback, and keeps the iob alive after IO: */
 	qeth_get_cmd(iob);
@@ -1754,34 +1720,33 @@ static int qeth_send_control_data(struct qeth_card *card,
 		QETH_DBF_MESSAGE(2, "qeth_send_control_data on device %x: ccw_device_start rc = %i\n",
 				 CARD_DEVID(card), rc);
 		QETH_CARD_TEXT_(card, 2, " err%d", rc);
-		qeth_dequeue_reply(card, reply);
+		qeth_dequeue_cmd(card, iob);
 		qeth_put_cmd(iob);
 		atomic_set(&channel->irq_pending, 0);
 		wake_up(&card->wait_q);
 		goto out;
 	}
 
-	timeout = wait_for_completion_interruptible_timeout(&reply->received,
+	timeout = wait_for_completion_interruptible_timeout(&iob->done,
 							    timeout);
 	if (timeout <= 0)
 		rc = (timeout == -ERESTARTSYS) ? -EINTR : -ETIME;
 
-	qeth_dequeue_reply(card, reply);
+	qeth_dequeue_cmd(card, iob);
 
 	if (reply_cb) {
 		/* Wait until the callback for a late reply has completed: */
-		spin_lock_irq(&reply->lock);
+		spin_lock_irq(&iob->lock);
 		if (rc)
 			/* Zap any callback that's still pending: */
-			reply->rc = rc;
-		spin_unlock_irq(&reply->lock);
+			iob->rc = rc;
+		spin_unlock_irq(&iob->lock);
 	}
 
 	if (!rc)
-		rc = reply->rc;
+		rc = iob->rc;
 
 out:
-	qeth_put_reply(reply);
 	qeth_put_cmd(iob);
 	return rc;
 }
@@ -1822,7 +1787,7 @@ static void qeth_read_conf_data_cb(struct qeth_card *card,
 				 nd->nd3.model[2] <= 0xF4;
 
 out:
-	qeth_notify_reply(iob->reply, rc);
+	qeth_notify_cmd(iob, rc);
 	qeth_put_cmd(iob);
 }
 
@@ -1914,7 +1879,7 @@ static void qeth_idx_activate_read_channel_cb(struct qeth_card *card,
 	       QETH_IDX_REPLY_LEVEL(iob->data), QETH_MCL_LENGTH);
 
 out:
-	qeth_notify_reply(iob->reply, rc);
+	qeth_notify_cmd(iob, rc);
 	qeth_put_cmd(iob);
 }
 
@@ -1942,7 +1907,7 @@ static void qeth_idx_activate_write_channel_cb(struct qeth_card *card,
 	}
 
 out:
-	qeth_notify_reply(iob->reply, rc);
+	qeth_notify_cmd(iob, rc);
 	qeth_put_cmd(iob);
 }
 
@@ -2675,8 +2640,7 @@ static void qeth_ipa_finalize_cmd(struct qeth_card *card,
 	qeth_mpc_finalize_cmd(card, iob);
 
 	/* override with IPA-specific values: */
-	__ipa_cmd(iob)->hdr.seqno = card->seqno.ipa;
-	iob->reply->seqno = card->seqno.ipa++;
+	__ipa_cmd(iob)->hdr.seqno = card->seqno.ipa++;
 }
 
 void qeth_prepare_ipa_cmd(struct qeth_card *card, struct qeth_cmd_buffer *iob,
diff --git a/drivers/s390/net/qeth_core_mpc.h b/drivers/s390/net/qeth_core_mpc.h
index 75b5834ed28d..6420b58cf42b 100644
--- a/drivers/s390/net/qeth_core_mpc.h
+++ b/drivers/s390/net/qeth_core_mpc.h
@@ -27,7 +27,6 @@ extern unsigned char IPA_PDU_HEADER[];
 
 #define QETH_TIMEOUT		(10 * HZ)
 #define QETH_IPA_TIMEOUT	(45 * HZ)
-#define QETH_IDX_COMMAND_SEQNO	0xffff0000
 
 #define QETH_CLEAR_CHANNEL_PARM	-10
 #define QETH_HALT_CHANNEL_PARM	-11
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index c524c8bff3c7..ad7ee3bfd63c 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -1003,7 +1003,7 @@ static void qeth_osn_assist_cb(struct qeth_card *card,
 			       struct qeth_cmd_buffer *iob,
 			       unsigned int data_length)
 {
-	qeth_notify_reply(iob->reply, 0);
+	qeth_notify_cmd(iob, 0);
 	qeth_put_cmd(iob);
 }
 
-- 
2.17.1

