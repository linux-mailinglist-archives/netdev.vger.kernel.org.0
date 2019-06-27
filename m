Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED77758514
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 17:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfF0PCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 11:02:10 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58186 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726480AbfF0PCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 11:02:09 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5RF0sGP132698
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 11:02:06 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tcwrf080h-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 11:01:49 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 27 Jun 2019 16:01:40 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 27 Jun 2019 16:01:39 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5RF1bDL47841350
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 15:01:37 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B846A405F;
        Thu, 27 Jun 2019 15:01:37 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54171A4070;
        Thu, 27 Jun 2019 15:01:37 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Jun 2019 15:01:37 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 07/12] s390/qeth: remove static cmd buffer infrastructure
Date:   Thu, 27 Jun 2019 17:01:28 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190627150133.58746-1-jwi@linux.ibm.com>
References: <20190627150133.58746-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19062715-4275-0000-0000-00000346F242
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062715-4276-0000-0000-00003856FB4B
Message-Id: <20190627150133.58746-8-jwi@linux.ibm.com>
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

Now that all cmds are dynamically allocated, the code for static cmd
buffers can go away entirely. Resulting in a nice reduction of
code/data size & complexity, while removing the risk that
qeth_clear_cmd_buffers() releases cmds that are still in-flight.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_core.h      |  45 +-----
 drivers/s390/net/qeth_core_main.c | 254 ++++++------------------------
 drivers/s390/net/qeth_l2_main.c   |   3 +-
 drivers/s390/net/qeth_l3_main.c   |   1 -
 4 files changed, 59 insertions(+), 244 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index b99fe6b043aa..715bff28d48e 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -60,7 +60,7 @@ struct qeth_dbf_info {
 	debug_info_t *id;
 };
 
-#define QETH_DBF_CTRL_LEN 256
+#define QETH_DBF_CTRL_LEN 256U
 
 #define QETH_DBF_TEXT(name, level, text) \
 	debug_text_event(qeth_dbf[QETH_DBF_##name].id, level, text)
@@ -524,11 +524,6 @@ struct qeth_qdio_info {
 	int default_out_queue;
 };
 
-/**
- * buffer stuff for read channel
- */
-#define QETH_CMD_BUFFER_NO	8
-
 /**
  *  channel state machine
  */
@@ -556,12 +551,6 @@ enum qeth_prot_versions {
 	QETH_PROT_IPV6 = 0x0006,
 };
 
-enum qeth_cmd_buffer_state {
-	BUF_STATE_FREE,
-	BUF_STATE_LOCKED,
-	BUF_STATE_MALLOC,
-};
-
 enum qeth_cq {
 	QETH_CQ_DISABLED = 0,
 	QETH_CQ_ENABLED = 1,
@@ -575,18 +564,20 @@ struct qeth_ipato {
 	struct list_head entries;
 };
 
-struct qeth_channel;
+struct qeth_channel {
+	struct ccw_device *ccwdev;
+	enum qeth_channel_states state;
+	atomic_t irq_pending;
+};
 
 struct qeth_cmd_buffer {
-	enum qeth_cmd_buffer_state state;
 	unsigned int length;
 	refcount_t ref_count;
 	struct qeth_channel *channel;
 	struct qeth_reply *reply;
 	long timeout;
 	unsigned char *data;
-	void (*finalize)(struct qeth_card *card, struct qeth_cmd_buffer *iob,
-			 unsigned int length);
+	void (*finalize)(struct qeth_card *card, struct qeth_cmd_buffer *iob);
 	void (*callback)(struct qeth_card *card, struct qeth_cmd_buffer *iob);
 };
 
@@ -600,25 +591,8 @@ static inline struct qeth_ipa_cmd *__ipa_cmd(struct qeth_cmd_buffer *iob)
 	return (struct qeth_ipa_cmd *)(iob->data + IPA_PDU_HEADER_SIZE);
 }
 
-/**
- * definition of a qeth channel, used for read and write
- */
-struct qeth_channel {
-	enum qeth_channel_states state;
-	struct ccw1 *ccw;
-	spinlock_t iob_lock;
-	wait_queue_head_t wait_q;
-	struct ccw_device *ccwdev;
-/*command buffer for control data*/
-	struct qeth_cmd_buffer iob[QETH_CMD_BUFFER_NO];
-	atomic_t irq_pending;
-	int io_buf_no;
-};
-
 static inline struct ccw1 *__ccw_from_cmd(struct qeth_cmd_buffer *iob)
 {
-	if (iob->state != BUF_STATE_MALLOC)
-		return iob->channel->ccw;
 	return (struct ccw1 *)(iob->data + ALIGN(iob->length, 8));
 }
 
@@ -994,8 +968,6 @@ int qeth_send_ipa_cmd(struct qeth_card *, struct qeth_cmd_buffer *,
 		  int (*reply_cb)
 		  (struct qeth_card *, struct qeth_reply *, unsigned long),
 		  void *);
-struct qeth_cmd_buffer *qeth_get_ipacmd_buffer(struct qeth_card *,
-			enum qeth_ipa_cmds, enum qeth_prot_versions);
 struct qeth_cmd_buffer *qeth_ipa_alloc_cmd(struct qeth_card *card,
 					   enum qeth_ipa_cmds cmd_code,
 					   enum qeth_prot_versions prot,
@@ -1011,6 +983,7 @@ struct qeth_cmd_buffer *qeth_get_setassparms_cmd(struct qeth_card *card,
 struct qeth_cmd_buffer *qeth_get_diag_cmd(struct qeth_card *card,
 					  enum qeth_diags_cmds sub_cmd,
 					  unsigned int data_length);
+void qeth_put_cmd(struct qeth_cmd_buffer *iob);
 
 struct sk_buff *qeth_core_get_next_skb(struct qeth_card *,
 		struct qeth_qdio_buffer *, struct qdio_buffer_element **, int *,
@@ -1020,12 +993,10 @@ int qeth_poll(struct napi_struct *napi, int budget);
 void qeth_clear_ipacmd_list(struct qeth_card *);
 int qeth_qdio_clear_card(struct qeth_card *, int);
 void qeth_clear_working_pool_list(struct qeth_card *);
-void qeth_clear_cmd_buffers(struct qeth_channel *);
 void qeth_drain_output_queues(struct qeth_card *card);
 void qeth_setadp_promisc_mode(struct qeth_card *);
 int qeth_setadpparms_change_macaddr(struct qeth_card *);
 void qeth_tx_timeout(struct net_device *);
-void qeth_release_buffer(struct qeth_cmd_buffer *iob);
 void qeth_notify_reply(struct qeth_reply *reply, int reason);
 void qeth_prepare_ipa_cmd(struct qeth_card *card, struct qeth_cmd_buffer *iob,
 			  u16 cmd_length);
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index b4c200eec707..3875f70118e4 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -517,7 +517,7 @@ static int __qeth_issue_next_read(struct qeth_card *card)
 		QETH_DBF_MESSAGE(2, "error %i on device %x when starting next read ccw!\n",
 				 rc, CARD_DEVID(card));
 		atomic_set(&channel->irq_pending, 0);
-		qeth_release_buffer(iob);
+		qeth_put_cmd(iob);
 		card->read_or_write_problem = 1;
 		qeth_schedule_recovery(card);
 		wake_up(&card->wait_q);
@@ -689,7 +689,7 @@ static int qeth_check_idx_response(struct qeth_card *card,
 	return 0;
 }
 
-static void qeth_put_cmd(struct qeth_cmd_buffer *iob)
+void qeth_put_cmd(struct qeth_cmd_buffer *iob)
 {
 	if (refcount_dec_and_test(&iob->ref_count)) {
 		if (iob->reply)
@@ -698,53 +698,12 @@ static void qeth_put_cmd(struct qeth_cmd_buffer *iob)
 		kfree(iob);
 	}
 }
-
-static struct qeth_cmd_buffer *__qeth_get_buffer(struct qeth_channel *channel)
-{
-	__u8 index;
-
-	index = channel->io_buf_no;
-	do {
-		if (channel->iob[index].state == BUF_STATE_FREE) {
-			channel->iob[index].state = BUF_STATE_LOCKED;
-			channel->iob[index].timeout = QETH_TIMEOUT;
-			channel->io_buf_no = (channel->io_buf_no + 1) %
-				QETH_CMD_BUFFER_NO;
-			memset(channel->iob[index].data, 0, QETH_BUFSIZE);
-			return channel->iob + index;
-		}
-		index = (index + 1) % QETH_CMD_BUFFER_NO;
-	} while (index != channel->io_buf_no);
-
-	return NULL;
-}
-
-void qeth_release_buffer(struct qeth_cmd_buffer *iob)
-{
-	struct qeth_channel *channel = iob->channel;
-	unsigned long flags;
-
-	if (iob->state == BUF_STATE_MALLOC) {
-		qeth_put_cmd(iob);
-		return;
-	}
-
-	spin_lock_irqsave(&channel->iob_lock, flags);
-	iob->state = BUF_STATE_FREE;
-	iob->callback = NULL;
-	if (iob->reply) {
-		qeth_put_reply(iob->reply);
-		iob->reply = NULL;
-	}
-	spin_unlock_irqrestore(&channel->iob_lock, flags);
-	wake_up(&channel->wait_q);
-}
-EXPORT_SYMBOL_GPL(qeth_release_buffer);
+EXPORT_SYMBOL_GPL(qeth_put_cmd);
 
 static void qeth_release_buffer_cb(struct qeth_card *card,
 				   struct qeth_cmd_buffer *iob)
 {
-	qeth_release_buffer(iob);
+	qeth_put_cmd(iob);
 }
 
 static void qeth_cancel_cmd(struct qeth_cmd_buffer *iob, int rc)
@@ -753,18 +712,7 @@ static void qeth_cancel_cmd(struct qeth_cmd_buffer *iob, int rc)
 
 	if (reply)
 		qeth_notify_reply(reply, rc);
-	qeth_release_buffer(iob);
-}
-
-static struct qeth_cmd_buffer *qeth_get_buffer(struct qeth_channel *channel)
-{
-	struct qeth_cmd_buffer *buffer = NULL;
-	unsigned long flags;
-
-	spin_lock_irqsave(&channel->iob_lock, flags);
-	buffer = __qeth_get_buffer(channel);
-	spin_unlock_irqrestore(&channel->iob_lock, flags);
-	return buffer;
+	qeth_put_cmd(iob);
 }
 
 struct qeth_cmd_buffer *qeth_alloc_cmd(struct qeth_channel *channel,
@@ -787,7 +735,6 @@ struct qeth_cmd_buffer *qeth_alloc_cmd(struct qeth_channel *channel,
 		return NULL;
 	}
 
-	iob->state = BUF_STATE_MALLOC;
 	refcount_set(&iob->ref_count, 1);
 	iob->channel = channel;
 	iob->timeout = timeout;
@@ -796,16 +743,6 @@ struct qeth_cmd_buffer *qeth_alloc_cmd(struct qeth_channel *channel,
 }
 EXPORT_SYMBOL_GPL(qeth_alloc_cmd);
 
-void qeth_clear_cmd_buffers(struct qeth_channel *channel)
-{
-	int cnt;
-
-	for (cnt = 0; cnt < QETH_CMD_BUFFER_NO; cnt++)
-		qeth_release_buffer(&channel->iob[cnt]);
-	channel->io_buf_no = 0;
-}
-EXPORT_SYMBOL_GPL(qeth_clear_cmd_buffers);
-
 static void qeth_issue_next_read_cb(struct qeth_card *card,
 				    struct qeth_cmd_buffer *iob)
 {
@@ -879,7 +816,7 @@ static void qeth_issue_next_read_cb(struct qeth_card *card,
 	memcpy(&card->seqno.pdu_hdr_ack,
 		QETH_PDU_HEADER_SEQ_NO(iob->data),
 		QETH_SEQ_NO_LENGTH);
-	qeth_release_buffer(iob);
+	qeth_put_cmd(iob);
 	__qeth_issue_next_read(card);
 }
 
@@ -1229,56 +1166,26 @@ static void qeth_free_buffer_pool(struct qeth_card *card)
 static void qeth_clean_channel(struct qeth_channel *channel)
 {
 	struct ccw_device *cdev = channel->ccwdev;
-	int cnt;
 
 	QETH_DBF_TEXT(SETUP, 2, "freech");
 
 	spin_lock_irq(get_ccwdev_lock(cdev));
 	cdev->handler = NULL;
 	spin_unlock_irq(get_ccwdev_lock(cdev));
-
-	for (cnt = 0; cnt < QETH_CMD_BUFFER_NO; cnt++)
-		kfree(channel->iob[cnt].data);
-	kfree(channel->ccw);
 }
 
-static int qeth_setup_channel(struct qeth_channel *channel, bool alloc_buffers)
+static void qeth_setup_channel(struct qeth_channel *channel)
 {
 	struct ccw_device *cdev = channel->ccwdev;
-	int cnt;
 
 	QETH_DBF_TEXT(SETUP, 2, "setupch");
 
-	channel->ccw = kmalloc(sizeof(struct ccw1), GFP_KERNEL | GFP_DMA);
-	if (!channel->ccw)
-		return -ENOMEM;
 	channel->state = CH_STATE_DOWN;
 	atomic_set(&channel->irq_pending, 0);
-	init_waitqueue_head(&channel->wait_q);
 
 	spin_lock_irq(get_ccwdev_lock(cdev));
 	cdev->handler = qeth_irq;
 	spin_unlock_irq(get_ccwdev_lock(cdev));
-
-	if (!alloc_buffers)
-		return 0;
-
-	for (cnt = 0; cnt < QETH_CMD_BUFFER_NO; cnt++) {
-		channel->iob[cnt].data = kmalloc(QETH_BUFSIZE,
-						 GFP_KERNEL | GFP_DMA);
-		if (channel->iob[cnt].data == NULL)
-			break;
-		channel->iob[cnt].state = BUF_STATE_FREE;
-		channel->iob[cnt].channel = channel;
-	}
-	if (cnt < QETH_CMD_BUFFER_NO) {
-		qeth_clean_channel(channel);
-		return -ENOMEM;
-	}
-	channel->io_buf_no = 0;
-	spin_lock_init(&channel->iob_lock);
-
-	return 0;
 }
 
 static int qeth_osa_set_output_queues(struct qeth_card *card, bool single)
@@ -1452,22 +1359,14 @@ static struct qeth_card *qeth_alloc_card(struct ccwgroup_device *gdev)
 	card->read_cmd = qeth_alloc_cmd(&card->read, QETH_BUFSIZE, 1, 0);
 	if (!card->read_cmd)
 		goto out_read_cmd;
-	if (qeth_setup_channel(&card->read, false))
-		goto out_read;
-	if (qeth_setup_channel(&card->write, false))
-		goto out_write;
-	if (qeth_setup_channel(&card->data, false))
-		goto out_data;
+
+	qeth_setup_channel(&card->read);
+	qeth_setup_channel(&card->write);
+	qeth_setup_channel(&card->data);
 	card->qeth_service_level.seq_print = qeth_core_sl_print;
 	register_service_level(&card->qeth_service_level);
 	return card;
 
-out_data:
-	qeth_clean_channel(&card->write);
-out_write:
-	qeth_clean_channel(&card->read);
-out_read:
-	qeth_release_buffer(card->read_cmd);
 out_read_cmd:
 	destroy_workqueue(card->event_wq);
 out_wq:
@@ -1715,8 +1614,7 @@ static void qeth_init_func_level(struct qeth_card *card)
 }
 
 static void qeth_idx_finalize_cmd(struct qeth_card *card,
-				  struct qeth_cmd_buffer *iob,
-				  unsigned int length)
+				  struct qeth_cmd_buffer *iob)
 {
 	memcpy(QETH_TRANSPORT_HEADER_SEQ_NO(iob->data), &card->seqno.trans_hdr,
 	       QETH_SEQ_NO_LENGTH);
@@ -1734,10 +1632,9 @@ static int qeth_peer_func_level(int level)
 }
 
 static void qeth_mpc_finalize_cmd(struct qeth_card *card,
-				  struct qeth_cmd_buffer *iob,
-				  unsigned int length)
+				  struct qeth_cmd_buffer *iob)
 {
-	qeth_idx_finalize_cmd(card, iob, length);
+	qeth_idx_finalize_cmd(card, iob);
 
 	memcpy(QETH_PDU_HEADER_SEQ_NO(iob->data),
 	       &card->seqno.pdu_hdr, QETH_SEQ_NO_LENGTH);
@@ -1769,7 +1666,6 @@ static struct qeth_cmd_buffer *qeth_mpc_alloc_cmd(struct qeth_card *card,
 /**
  * qeth_send_control_data() -	send control command to the card
  * @card:			qeth_card structure pointer
- * @len:			size of the command buffer
  * @iob:			qeth_cmd_buffer pointer
  * @reply_cb:			callback function pointer
  * @cb_card:			pointer to the qeth_card structure
@@ -1789,7 +1685,7 @@ static struct qeth_cmd_buffer *qeth_mpc_alloc_cmd(struct qeth_card *card,
  * field 'param' of the structure qeth_reply.
  */
 
-static int qeth_send_control_data(struct qeth_card *card, int len,
+static int qeth_send_control_data(struct qeth_card *card,
 				  struct qeth_cmd_buffer *iob,
 				  int (*reply_cb)(struct qeth_card *cb_card,
 						  struct qeth_reply *cb_reply,
@@ -1805,13 +1701,13 @@ static int qeth_send_control_data(struct qeth_card *card, int len,
 
 	reply = qeth_alloc_reply(card);
 	if (!reply) {
-		qeth_release_buffer(iob);
+		qeth_put_cmd(iob);
 		return -ENOMEM;
 	}
 	reply->callback = reply_cb;
 	reply->param = reply_param;
 
-	/* pairs with qeth_release_buffer(): */
+	/* pairs with qeth_put_cmd(): */
 	qeth_get_reply(reply);
 	iob->reply = reply;
 
@@ -1820,13 +1716,13 @@ static int qeth_send_control_data(struct qeth_card *card, int len,
 						   timeout);
 	if (timeout <= 0) {
 		qeth_put_reply(reply);
-		qeth_release_buffer(iob);
+		qeth_put_cmd(iob);
 		return (timeout == -ERESTARTSYS) ? -EINTR : -ETIME;
 	}
 
 	if (iob->finalize)
-		iob->finalize(card, iob, len);
-	QETH_DBF_HEX(CTRL, 2, iob->data, min(len, QETH_DBF_CTRL_LEN));
+		iob->finalize(card, iob);
+	QETH_DBF_HEX(CTRL, 2, iob->data, min(iob->length, QETH_DBF_CTRL_LEN));
 
 	qeth_enqueue_reply(card, reply);
 
@@ -1841,7 +1737,7 @@ static int qeth_send_control_data(struct qeth_card *card, int len,
 		QETH_CARD_TEXT_(card, 2, " err%d", rc);
 		qeth_dequeue_reply(card, reply);
 		qeth_put_reply(reply);
-		qeth_release_buffer(iob);
+		qeth_put_cmd(iob);
 		atomic_set(&channel->irq_pending, 0);
 		wake_up(&card->wait_q);
 		return rc;
@@ -1874,7 +1770,7 @@ static void qeth_read_conf_data_cb(struct qeth_card *card,
 				 prcd[76] >= 0xF1 && prcd[76] <= 0xF4;
 
 	qeth_notify_reply(iob->reply, 0);
-	qeth_release_buffer(iob);
+	qeth_put_cmd(iob);
 }
 
 static int qeth_read_conf_data(struct qeth_card *card)
@@ -1896,7 +1792,7 @@ static int qeth_read_conf_data(struct qeth_card *card)
 	qeth_setup_ccw(__ccw_from_cmd(iob), ciw->cmd, 0, iob->length,
 		       iob->data);
 
-	return qeth_send_control_data(card, iob->length, iob, NULL, NULL);
+	return qeth_send_control_data(card, iob, NULL, NULL);
 }
 
 static int qeth_idx_check_activate_response(struct qeth_card *card,
@@ -1963,7 +1859,7 @@ static void qeth_idx_activate_read_channel_cb(struct qeth_card *card,
 
 out:
 	qeth_notify_reply(iob->reply, rc);
-	qeth_release_buffer(iob);
+	qeth_put_cmd(iob);
 }
 
 static void qeth_idx_activate_write_channel_cb(struct qeth_card *card,
@@ -1990,7 +1886,7 @@ static void qeth_idx_activate_write_channel_cb(struct qeth_card *card,
 
 out:
 	qeth_notify_reply(iob->reply, rc);
-	qeth_release_buffer(iob);
+	qeth_put_cmd(iob);
 }
 
 static void qeth_idx_setup_activate_cmd(struct qeth_card *card,
@@ -2032,7 +1928,7 @@ static int qeth_idx_activate_read_channel(struct qeth_card *card)
 	qeth_idx_setup_activate_cmd(card, iob);
 	iob->callback = qeth_idx_activate_read_channel_cb;
 
-	rc = qeth_send_control_data(card, IDX_ACTIVATE_SIZE, iob, NULL, NULL);
+	rc = qeth_send_control_data(card, iob, NULL, NULL);
 	if (rc)
 		return rc;
 
@@ -2056,7 +1952,7 @@ static int qeth_idx_activate_write_channel(struct qeth_card *card)
 	qeth_idx_setup_activate_cmd(card, iob);
 	iob->callback = qeth_idx_activate_write_channel_cb;
 
-	rc = qeth_send_control_data(card, IDX_ACTIVATE_SIZE, iob, NULL, NULL);
+	rc = qeth_send_control_data(card, iob, NULL, NULL);
 	if (rc)
 		return rc;
 
@@ -2080,7 +1976,6 @@ static int qeth_cm_enable_cb(struct qeth_card *card, struct qeth_reply *reply,
 
 static int qeth_cm_enable(struct qeth_card *card)
 {
-	int rc;
 	struct qeth_cmd_buffer *iob;
 
 	QETH_CARD_TEXT(card, 2, "cmenable");
@@ -2094,9 +1989,7 @@ static int qeth_cm_enable(struct qeth_card *card)
 	memcpy(QETH_CM_ENABLE_FILTER_TOKEN(iob->data),
 	       &card->token.cm_filter_w, QETH_MPC_TOKEN_LENGTH);
 
-	rc = qeth_send_control_data(card, CM_ENABLE_SIZE, iob,
-				    qeth_cm_enable_cb, NULL);
-	return rc;
+	return qeth_send_control_data(card, iob, qeth_cm_enable_cb, NULL);
 }
 
 static int qeth_cm_setup_cb(struct qeth_card *card, struct qeth_reply *reply,
@@ -2115,7 +2008,6 @@ static int qeth_cm_setup_cb(struct qeth_card *card, struct qeth_reply *reply,
 
 static int qeth_cm_setup(struct qeth_card *card)
 {
-	int rc;
 	struct qeth_cmd_buffer *iob;
 
 	QETH_CARD_TEXT(card, 2, "cmsetup");
@@ -2130,9 +2022,7 @@ static int qeth_cm_setup(struct qeth_card *card)
 	       &card->token.cm_connection_w, QETH_MPC_TOKEN_LENGTH);
 	memcpy(QETH_CM_SETUP_FILTER_TOKEN(iob->data),
 	       &card->token.cm_filter_r, QETH_MPC_TOKEN_LENGTH);
-	rc = qeth_send_control_data(card, CM_SETUP_SIZE, iob,
-				    qeth_cm_setup_cb, NULL);
-	return rc;
+	return qeth_send_control_data(card, iob, qeth_cm_setup_cb, NULL);
 }
 
 static int qeth_update_max_mtu(struct qeth_card *card, unsigned int max_mtu)
@@ -2248,8 +2138,7 @@ static int qeth_ulp_enable(struct qeth_card *card)
 	       &card->token.cm_connection_r, QETH_MPC_TOKEN_LENGTH);
 	memcpy(QETH_ULP_ENABLE_FILTER_TOKEN(iob->data),
 	       &card->token.ulp_filter_w, QETH_MPC_TOKEN_LENGTH);
-	rc = qeth_send_control_data(card, ULP_ENABLE_SIZE, iob,
-				    qeth_ulp_enable_cb, &max_mtu);
+	rc = qeth_send_control_data(card, iob, qeth_ulp_enable_cb, &max_mtu);
 	if (rc)
 		return rc;
 	return qeth_update_max_mtu(card, max_mtu);
@@ -2278,7 +2167,6 @@ static int qeth_ulp_setup_cb(struct qeth_card *card, struct qeth_reply *reply,
 
 static int qeth_ulp_setup(struct qeth_card *card)
 {
-	int rc;
 	__u16 temp;
 	struct qeth_cmd_buffer *iob;
 	struct ccw_dev_id dev_id;
@@ -2300,9 +2188,7 @@ static int qeth_ulp_setup(struct qeth_card *card)
 	memcpy(QETH_ULP_SETUP_CUA(iob->data), &dev_id.devno, 2);
 	temp = (card->info.cula << 8) + card->info.unit_addr2;
 	memcpy(QETH_ULP_SETUP_REAL_DEVADDR(iob->data), &temp, 2);
-	rc = qeth_send_control_data(card, ULP_SETUP_SIZE, iob,
-				    qeth_ulp_setup_cb, NULL);
-	return rc;
+	return qeth_send_control_data(card, iob, qeth_ulp_setup_cb, NULL);
 }
 
 static int qeth_init_qdio_out_buf(struct qeth_qdio_out_q *q, int bidx)
@@ -2469,7 +2355,6 @@ static int qeth_qdio_activate(struct qeth_card *card)
 
 static int qeth_dm_act(struct qeth_card *card)
 {
-	int rc;
 	struct qeth_cmd_buffer *iob;
 
 	QETH_CARD_TEXT(card, 2, "dmact");
@@ -2482,8 +2367,7 @@ static int qeth_dm_act(struct qeth_card *card)
 	       &card->token.cm_connection_r, QETH_MPC_TOKEN_LENGTH);
 	memcpy(QETH_DM_ACT_CONNECTION_TOKEN(iob->data),
 	       &card->token.ulp_connection_r, QETH_MPC_TOKEN_LENGTH);
-	rc = qeth_send_control_data(card, DM_ACT_SIZE, iob, NULL, NULL);
-	return rc;
+	return qeth_send_control_data(card, iob, NULL, NULL);
 }
 
 static int qeth_mpc_initialize(struct qeth_card *card)
@@ -2728,36 +2612,10 @@ int qeth_init_qdio_queues(struct qeth_card *card)
 }
 EXPORT_SYMBOL_GPL(qeth_init_qdio_queues);
 
-static __u8 qeth_get_ipa_adp_type(enum qeth_link_types link_type)
-{
-	switch (link_type) {
-	case QETH_LINK_TYPE_HSTR:
-		return 2;
-	default:
-		return 1;
-	}
-}
-
-static void qeth_fill_ipacmd_header(struct qeth_card *card,
-				    struct qeth_ipa_cmd *cmd,
-				    enum qeth_ipa_cmds command,
-				    enum qeth_prot_versions prot)
-{
-	cmd->hdr.command = command;
-	cmd->hdr.initiator = IPA_CMD_INITIATOR_HOST;
-	/* cmd->hdr.seqno is set by qeth_send_control_data() */
-	cmd->hdr.adapter_type = qeth_get_ipa_adp_type(card->info.link_type);
-	cmd->hdr.rel_adapter_no = (u8) card->dev->dev_port;
-	cmd->hdr.prim_version_no = IS_LAYER2(card) ? 2 : 1;
-	cmd->hdr.param_count = 1;
-	cmd->hdr.prot_version = prot;
-}
-
 static void qeth_ipa_finalize_cmd(struct qeth_card *card,
-				  struct qeth_cmd_buffer *iob,
-				  unsigned int length)
+				  struct qeth_cmd_buffer *iob)
 {
-	qeth_mpc_finalize_cmd(card, iob, length);
+	qeth_mpc_finalize_cmd(card, iob);
 
 	/* override with IPA-specific values: */
 	__ipa_cmd(iob)->hdr.seqno = card->seqno.ipa;
@@ -2767,13 +2625,12 @@ static void qeth_ipa_finalize_cmd(struct qeth_card *card,
 void qeth_prepare_ipa_cmd(struct qeth_card *card, struct qeth_cmd_buffer *iob,
 			  u16 cmd_length)
 {
-	u16 total_length = IPA_PDU_HEADER_SIZE + cmd_length;
 	u8 prot_type = qeth_mpc_select_prot_type(card);
+	u16 total_length = iob->length;
 
 	qeth_setup_ccw(__ccw_from_cmd(iob), CCW_CMD_WRITE, 0, total_length,
 		       iob->data);
 	iob->finalize = qeth_ipa_finalize_cmd;
-	iob->timeout = QETH_IPA_TIMEOUT;
 
 	memcpy(iob->data, IPA_PDU_HEADER, IPA_PDU_HEADER_SIZE);
 	memcpy(QETH_IPA_PDU_LEN_TOTAL(iob->data), &total_length, 2);
@@ -2786,32 +2643,14 @@ void qeth_prepare_ipa_cmd(struct qeth_card *card, struct qeth_cmd_buffer *iob,
 }
 EXPORT_SYMBOL_GPL(qeth_prepare_ipa_cmd);
 
-struct qeth_cmd_buffer *qeth_get_ipacmd_buffer(struct qeth_card *card,
-		enum qeth_ipa_cmds ipacmd, enum qeth_prot_versions prot)
-{
-	struct qeth_cmd_buffer *iob;
-
-	iob = qeth_get_buffer(&card->write);
-	if (iob) {
-		qeth_prepare_ipa_cmd(card, iob, sizeof(struct qeth_ipa_cmd));
-		qeth_fill_ipacmd_header(card, __ipa_cmd(iob), ipacmd, prot);
-	} else {
-		dev_warn(&card->gdev->dev,
-			 "The qeth driver ran out of channel command buffers\n");
-		QETH_DBF_MESSAGE(1, "device %x ran out of channel command buffers",
-				 CARD_DEVID(card));
-	}
-
-	return iob;
-}
-EXPORT_SYMBOL_GPL(qeth_get_ipacmd_buffer);
-
 struct qeth_cmd_buffer *qeth_ipa_alloc_cmd(struct qeth_card *card,
 					   enum qeth_ipa_cmds cmd_code,
 					   enum qeth_prot_versions prot,
 					   unsigned int data_length)
 {
+	enum qeth_link_types link_type = card->info.link_type;
 	struct qeth_cmd_buffer *iob;
+	struct qeth_ipacmd_hdr *hdr;
 
 	data_length += offsetof(struct qeth_ipa_cmd, data);
 	iob = qeth_alloc_cmd(&card->write, IPA_PDU_HEADER_SIZE + data_length, 1,
@@ -2820,7 +2659,16 @@ struct qeth_cmd_buffer *qeth_ipa_alloc_cmd(struct qeth_card *card,
 		return NULL;
 
 	qeth_prepare_ipa_cmd(card, iob, data_length);
-	qeth_fill_ipacmd_header(card, __ipa_cmd(iob), cmd_code, prot);
+
+	hdr = &__ipa_cmd(iob)->hdr;
+	hdr->command = cmd_code;
+	hdr->initiator = IPA_CMD_INITIATOR_HOST;
+	/* hdr->seqno is set by qeth_send_control_data() */
+	hdr->adapter_type = (link_type == QETH_LINK_TYPE_HSTR) ? 2 : 1;
+	hdr->rel_adapter_no = (u8) card->dev->dev_port;
+	hdr->prim_version_no = IS_LAYER2(card) ? 2 : 1;
+	hdr->param_count = 1;
+	hdr->prot_version = prot;
 	return iob;
 }
 EXPORT_SYMBOL_GPL(qeth_ipa_alloc_cmd);
@@ -2844,20 +2692,18 @@ int qeth_send_ipa_cmd(struct qeth_card *card, struct qeth_cmd_buffer *iob,
 			unsigned long),
 		void *reply_param)
 {
-	u16 length;
 	int rc;
 
 	QETH_CARD_TEXT(card, 4, "sendipa");
 
 	if (card->read_or_write_problem) {
-		qeth_release_buffer(iob);
+		qeth_put_cmd(iob);
 		return -EIO;
 	}
 
 	if (reply_cb == NULL)
 		reply_cb = qeth_send_ipa_cmd_cb;
-	memcpy(&length, QETH_IPA_PDU_LEN_TOTAL(iob->data), 2);
-	rc = qeth_send_control_data(card, length, iob, reply_cb, reply_param);
+	rc = qeth_send_control_data(card, iob, reply_cb, reply_param);
 	if (rc == -ETIME) {
 		qeth_clear_ipacmd_list(card);
 		qeth_schedule_recovery(card);
@@ -4929,7 +4775,7 @@ static void qeth_core_free_card(struct qeth_card *card)
 	qeth_clean_channel(&card->read);
 	qeth_clean_channel(&card->write);
 	qeth_clean_channel(&card->data);
-	qeth_release_buffer(card->read_cmd);
+	qeth_put_cmd(card->read_cmd);
 	destroy_workqueue(card->event_wq);
 	qeth_free_qdio_queues(card);
 	unregister_service_level(&card->qeth_service_level);
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 68c6f4080745..03e1cd4a282a 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -294,7 +294,6 @@ static void qeth_l2_stop_card(struct qeth_card *card)
 		card->state = CARD_STATE_DOWN;
 	}
 
-	qeth_clear_cmd_buffers(&card->write);
 	flush_workqueue(card->event_wq);
 	card->info.mac_bits &= ~QETH_LAYER2_MAC_REGISTERED;
 }
@@ -1034,7 +1033,7 @@ static void qeth_osn_assist_cb(struct qeth_card *card,
 			       struct qeth_cmd_buffer *iob)
 {
 	qeth_notify_reply(iob->reply, 0);
-	qeth_release_buffer(iob);
+	qeth_put_cmd(iob);
 }
 
 int qeth_osn_assist(struct net_device *dev, void *data, int data_len)
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 2e10f5be8f67..c36f368336a0 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1439,7 +1439,6 @@ static void qeth_l3_stop_card(struct qeth_card *card)
 		card->state = CARD_STATE_DOWN;
 	}
 
-	qeth_clear_cmd_buffers(&card->write);
 	flush_workqueue(card->event_wq);
 }
 
-- 
2.17.1

