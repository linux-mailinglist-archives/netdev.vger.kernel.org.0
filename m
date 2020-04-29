Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02E2E1BE237
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 17:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbgD2PLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 11:11:50 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27758 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727100AbgD2PLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 11:11:42 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03TF1H7g142961;
        Wed, 29 Apr 2020 11:11:38 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30q80ps2tw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 11:11:38 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03TFB4Rc001536;
        Wed, 29 Apr 2020 15:11:36 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 30mcu59wgu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 15:11:36 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03TFBXvw15794534
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Apr 2020 15:11:33 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8CFF7AE04D;
        Wed, 29 Apr 2020 15:11:32 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 49CB7AE055;
        Wed, 29 Apr 2020 15:11:32 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 Apr 2020 15:11:32 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 10/13] net/smc: use worker to process incoming llc messages
Date:   Wed, 29 Apr 2020 17:10:46 +0200
Message-Id: <20200429151049.49979-11-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200429151049.49979-1-kgraul@linux.ibm.com>
References: <20200429151049.49979-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_07:2020-04-29,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 impostorscore=0 phishscore=0
 bulkscore=0 spamscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=999
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290122
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Incoming llc messages are processed in irq tasklet context, and
a worker is used to send outgoing messages. The worker is needed
because getting a send buffer could result in a wait for a free buffer.

To make sure all incoming llc messages are processed in a serialized way
introduce an event queue and create a new queue entry for each message
which is queued to this event queue. A new worker processes the event
queue entries in order.
And remove the use of a separate worker to send outgoing llc messages
because the messages are processed in worker context already.
With this event queue the serialized llc_wq work queue is obsolete,
remove it.

Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
---
 net/smc/smc_core.c |   4 +-
 net/smc/smc_core.h |   7 ++-
 net/smc/smc_llc.c  | 142 +++++++++++++++++++++++++++------------------
 net/smc/smc_llc.h  |   1 +
 4 files changed, 96 insertions(+), 58 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 78ccfbf6e4af..a1463da14614 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -412,7 +412,8 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
 		lgr->role = smc->listen_smc ? SMC_SERV : SMC_CLNT;
 		memcpy(lgr->peer_systemid, ini->ib_lcl->id_for_peer,
 		       SMC_SYSTEMID_LEN);
-
+		INIT_LIST_HEAD(&lgr->llc_event_q);
+		spin_lock_init(&lgr->llc_event_q_lock);
 		link_idx = SMC_SINGLE_LINK;
 		lnk = &lgr->lnk[link_idx];
 		rc = smcr_link_init(lgr, lnk, link_idx, ini);
@@ -613,6 +614,7 @@ static void smc_lgr_free(struct smc_link_group *lgr)
 			if (lgr->lnk[i].state != SMC_LNK_UNUSED)
 				smcr_link_clear(&lgr->lnk[i]);
 		}
+		smc_llc_event_flush(lgr);
 		if (!atomic_dec_return(&lgr_cnt))
 			wake_up(&lgrs_deleted);
 	}
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 2b1960c8c8ce..6548e9a06f73 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -120,7 +120,6 @@ struct smc_link {
 	struct smc_link_group	*lgr;		/* parent link group */
 
 	enum smc_link_state	state;		/* state of link */
-	struct workqueue_struct *llc_wq;	/* single thread work queue */
 	struct completion	llc_confirm;	/* wait for rx of conf link */
 	struct completion	llc_confirm_resp; /* wait 4 rx of cnf lnk rsp */
 	int			llc_confirm_rc; /* rc from confirm link msg */
@@ -233,6 +232,12 @@ struct smc_link_group {
 			DECLARE_BITMAP(rtokens_used_mask, SMC_RMBS_PER_LGR_MAX);
 						/* used rtoken elements */
 			u8			next_link_id;
+			struct list_head	llc_event_q;
+						/* queue for llc events */
+			spinlock_t		llc_event_q_lock;
+						/* protects llc_event_q */
+			struct work_struct	llc_event_work;
+						/* llc event worker */
 		};
 		struct { /* SMC-D */
 			u64			peer_gid;
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 2f03131c85fd..be74876a36ae 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -134,6 +134,12 @@ union smc_llc_msg {
 
 #define SMC_LLC_FLAG_RESP		0x80
 
+struct smc_llc_qentry {
+	struct list_head list;
+	struct smc_link *link;
+	union smc_llc_msg msg;
+};
+
 /********************************** send *************************************/
 
 struct smc_llc_tx_pend {
@@ -356,46 +362,20 @@ static int smc_llc_send_test_link(struct smc_link *link, u8 user_data[16])
 	return rc;
 }
 
-struct smc_llc_send_work {
-	struct work_struct work;
-	struct smc_link *link;
-	int llclen;
-	union smc_llc_msg llcbuf;
-};
-
-/* worker that sends a prepared message */
-static void smc_llc_send_message_work(struct work_struct *work)
+/* schedule an llc send on link, may wait for buffers */
+static int smc_llc_send_message(struct smc_link *link, void *llcbuf)
 {
-	struct smc_llc_send_work *llcwrk = container_of(work,
-						struct smc_llc_send_work, work);
 	struct smc_wr_tx_pend_priv *pend;
 	struct smc_wr_buf *wr_buf;
 	int rc;
 
-	if (!smc_link_usable(llcwrk->link))
-		goto out;
-	rc = smc_llc_add_pending_send(llcwrk->link, &wr_buf, &pend);
+	if (!smc_link_usable(link))
+		return -ENOLINK;
+	rc = smc_llc_add_pending_send(link, &wr_buf, &pend);
 	if (rc)
-		goto out;
-	memcpy(wr_buf, &llcwrk->llcbuf, llcwrk->llclen);
-	smc_wr_tx_send(llcwrk->link, pend);
-out:
-	kfree(llcwrk);
-}
-
-/* copy llcbuf and schedule an llc send on link */
-static int smc_llc_send_message(struct smc_link *link, void *llcbuf, int llclen)
-{
-	struct smc_llc_send_work *wrk = kmalloc(sizeof(*wrk), GFP_ATOMIC);
-
-	if (!wrk)
-		return -ENOMEM;
-	INIT_WORK(&wrk->work, smc_llc_send_message_work);
-	wrk->link = link;
-	wrk->llclen = llclen;
-	memcpy(&wrk->llcbuf, llcbuf, llclen);
-	queue_work(link->llc_wq, &wrk->work);
-	return 0;
+		return rc;
+	memcpy(wr_buf, llcbuf, sizeof(union smc_llc_msg));
+	return smc_wr_tx_send(link, pend);
 }
 
 /********************************* receive ***********************************/
@@ -452,7 +432,7 @@ static void smc_llc_rx_add_link(struct smc_link *link,
 					link->smcibdev->mac[link->ibport - 1],
 					link->gid, SMC_LLC_RESP);
 		}
-		smc_llc_send_message(link, llc, sizeof(*llc));
+		smc_llc_send_message(link, llc);
 	}
 }
 
@@ -474,7 +454,7 @@ static void smc_llc_rx_delete_link(struct smc_link *link,
 			/* server requests to delete this link, send response */
 			smc_llc_prep_delete_link(llc, link, SMC_LLC_RESP, true);
 		}
-		smc_llc_send_message(link, llc, sizeof(*llc));
+		smc_llc_send_message(link, llc);
 		smc_lgr_terminate_sched(lgr);
 	}
 }
@@ -487,7 +467,7 @@ static void smc_llc_rx_test_link(struct smc_link *link,
 			complete(&link->llc_testlink_resp);
 	} else {
 		llc->hd.flags |= SMC_LLC_FLAG_RESP;
-		smc_llc_send_message(link, llc, sizeof(*llc));
+		smc_llc_send_message(link, llc);
 	}
 }
 
@@ -510,7 +490,7 @@ static void smc_llc_rx_confirm_rkey(struct smc_link *link,
 		llc->hd.flags |= SMC_LLC_FLAG_RESP;
 		if (rc < 0)
 			llc->hd.flags |= SMC_LLC_FLAG_RKEY_NEG;
-		smc_llc_send_message(link, llc, sizeof(*llc));
+		smc_llc_send_message(link, llc);
 	}
 }
 
@@ -522,7 +502,7 @@ static void smc_llc_rx_confirm_rkey_cont(struct smc_link *link,
 	} else {
 		/* ignore rtokens for other links, we have only one link */
 		llc->hd.flags |= SMC_LLC_FLAG_RESP;
-		smc_llc_send_message(link, llc, sizeof(*llc));
+		smc_llc_send_message(link, llc);
 	}
 }
 
@@ -549,21 +529,30 @@ static void smc_llc_rx_delete_rkey(struct smc_link *link,
 		}
 
 		llc->hd.flags |= SMC_LLC_FLAG_RESP;
-		smc_llc_send_message(link, llc, sizeof(*llc));
+		smc_llc_send_message(link, llc);
 	}
 }
 
-static void smc_llc_rx_handler(struct ib_wc *wc, void *buf)
+/* flush the llc event queue */
+void smc_llc_event_flush(struct smc_link_group *lgr)
 {
-	struct smc_link *link = (struct smc_link *)wc->qp->qp_context;
-	union smc_llc_msg *llc = buf;
+	struct smc_llc_qentry *qentry, *q;
+
+	spin_lock_bh(&lgr->llc_event_q_lock);
+	list_for_each_entry_safe(qentry, q, &lgr->llc_event_q, list) {
+		list_del_init(&qentry->list);
+		kfree(qentry);
+	}
+	spin_unlock_bh(&lgr->llc_event_q_lock);
+}
+
+static void smc_llc_event_handler(struct smc_llc_qentry *qentry)
+{
+	union smc_llc_msg *llc = &qentry->msg;
+	struct smc_link *link = qentry->link;
 
-	if (wc->byte_len < sizeof(*llc))
-		return; /* short message */
-	if (llc->raw.hdr.length != sizeof(*llc))
-		return; /* invalid message */
 	if (!smc_link_usable(link))
-		return; /* link not active, drop msg */
+		goto out;
 
 	switch (llc->raw.hdr.common.type) {
 	case SMC_LLC_TEST_LINK:
@@ -588,6 +577,54 @@ static void smc_llc_rx_handler(struct ib_wc *wc, void *buf)
 		smc_llc_rx_delete_rkey(link, &llc->delete_rkey);
 		break;
 	}
+out:
+	kfree(qentry);
+}
+
+/* worker to process llc messages on the event queue */
+static void smc_llc_event_work(struct work_struct *work)
+{
+	struct smc_link_group *lgr = container_of(work, struct smc_link_group,
+						  llc_event_work);
+	struct smc_llc_qentry *qentry;
+
+again:
+	spin_lock_bh(&lgr->llc_event_q_lock);
+	if (!list_empty(&lgr->llc_event_q)) {
+		qentry = list_first_entry(&lgr->llc_event_q,
+					  struct smc_llc_qentry, list);
+		list_del_init(&qentry->list);
+		spin_unlock_bh(&lgr->llc_event_q_lock);
+		smc_llc_event_handler(qentry);
+		goto again;
+	}
+	spin_unlock_bh(&lgr->llc_event_q_lock);
+}
+
+/* copy received msg and add it to the event queue */
+static void smc_llc_rx_handler(struct ib_wc *wc, void *buf)
+{
+	struct smc_link *link = (struct smc_link *)wc->qp->qp_context;
+	struct smc_link_group *lgr = link->lgr;
+	struct smc_llc_qentry *qentry;
+	union smc_llc_msg *llc = buf;
+	unsigned long flags;
+
+	if (wc->byte_len < sizeof(*llc))
+		return; /* short message */
+	if (llc->raw.hdr.length != sizeof(*llc))
+		return; /* invalid message */
+
+	qentry = kmalloc(sizeof(*qentry), GFP_ATOMIC);
+	if (!qentry)
+		return;
+	qentry->link = link;
+	INIT_LIST_HEAD(&qentry->list);
+	memcpy(&qentry->msg, llc, sizeof(union smc_llc_msg));
+	spin_lock_irqsave(&lgr->llc_event_q_lock, flags);
+	list_add_tail(&qentry->list, &lgr->llc_event_q);
+	spin_unlock_irqrestore(&lgr->llc_event_q_lock, flags);
+	schedule_work(&link->lgr->llc_event_work);
 }
 
 /***************************** worker, utils *********************************/
@@ -626,12 +663,6 @@ static void smc_llc_testlink_work(struct work_struct *work)
 
 int smc_llc_link_init(struct smc_link *link)
 {
-	struct smc_link_group *lgr = smc_get_lgr(link);
-	link->llc_wq = alloc_ordered_workqueue("llc_wq-%x:%x)", WQ_MEM_RECLAIM,
-					       *((u32 *)lgr->id),
-					       link->link_id);
-	if (!link->llc_wq)
-		return -ENOMEM;
 	init_completion(&link->llc_confirm);
 	init_completion(&link->llc_confirm_resp);
 	init_completion(&link->llc_add);
@@ -640,6 +671,7 @@ int smc_llc_link_init(struct smc_link *link)
 	init_completion(&link->llc_delete_rkey);
 	mutex_init(&link->llc_delete_rkey_mutex);
 	init_completion(&link->llc_testlink_resp);
+	INIT_WORK(&link->lgr->llc_event_work, smc_llc_event_work);
 	INIT_DELAYED_WORK(&link->llc_testlink_wrk, smc_llc_testlink_work);
 	return 0;
 }
@@ -663,8 +695,6 @@ void smc_llc_link_deleting(struct smc_link *link)
 /* called in worker context */
 void smc_llc_link_clear(struct smc_link *link)
 {
-	flush_workqueue(link->llc_wq);
-	destroy_workqueue(link->llc_wq);
 	complete(&link->llc_testlink_resp);
 	cancel_delayed_work_sync(&link->llc_testlink_wrk);
 	smc_wr_wakeup_reg_wait(link);
diff --git a/net/smc/smc_llc.h b/net/smc/smc_llc.h
index c2c9d48d079f..9de83495ad14 100644
--- a/net/smc/smc_llc.h
+++ b/net/smc/smc_llc.h
@@ -61,6 +61,7 @@ int smc_llc_do_confirm_rkey(struct smc_link *link,
 			    struct smc_buf_desc *rmb_desc);
 int smc_llc_do_delete_rkey(struct smc_link *link,
 			   struct smc_buf_desc *rmb_desc);
+void smc_llc_event_flush(struct smc_link_group *lgr);
 int smc_llc_init(void) __init;
 
 #endif /* SMC_LLC_H */
-- 
2.17.1

