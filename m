Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33E536057A6
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 08:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbiJTGo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 02:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbiJTGoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 02:44:05 -0400
Received: from out199-15.us.a.mail.aliyun.com (out199-15.us.a.mail.aliyun.com [47.90.199.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0651173586;
        Wed, 19 Oct 2022 23:44:02 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VSdzyIM_1666248238;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VSdzyIM_1666248238)
          by smtp.aliyun-inc.com;
          Thu, 20 Oct 2022 14:43:59 +0800
From:   "D.Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net-next v3 03/10] net/smc: allow confirm/delete rkey response deliver multiplex
Date:   Thu, 20 Oct 2022 14:43:45 +0800
Message-Id: <1666248232-63751-4-git-send-email-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1666248232-63751-1-git-send-email-alibuda@linux.alibaba.com>
References: <1666248232-63751-1-git-send-email-alibuda@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "D. Wythe" <alibuda@linux.alibaba.com>

We know that all flows except confirm_rkey and delete_rkey are exclusive,
confirm/delete rkey flows can run concurrently (local and remote).

Although the protocol allows, all flows are actually mutually exclusive
in implementation, dues to waiting for LLC messages is in serial.

This aggravates the time for establishing or destroying a SMC-R
connections, connections have to be queued in smc_llc_wait.

We use rtokens or rkey to correlate a confirm/delete rkey message
with its response.

Before sending a message, we put context with rtokens or rkey into
wait queue. When a response message received, we wakeup the context
which with the same rtokens or rkey against the response message.

Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 net/smc/smc_llc.c | 174 +++++++++++++++++++++++++++++++++++++++++-------------
 net/smc/smc_wr.c  |  10 ----
 net/smc/smc_wr.h  |  10 ++++
 3 files changed, 143 insertions(+), 51 deletions(-)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 524649d..24f9488 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -200,6 +200,7 @@ struct smc_llc_msg_delete_rkey_v2 {	/* type 0x29 */
 struct smc_llc_qentry {
 	struct list_head list;
 	struct smc_link *link;
+	void *private;
 	union smc_llc_msg msg;
 };
 
@@ -479,19 +480,17 @@ int smc_llc_send_confirm_link(struct smc_link *link,
 	return rc;
 }
 
-/* send LLC confirm rkey request */
-static int smc_llc_send_confirm_rkey(struct smc_link *send_link,
-				     struct smc_buf_desc *rmb_desc)
+/* build LLC confirm rkey request */
+static int smc_llc_build_confirm_rkey_request(struct smc_link *send_link,
+					      struct smc_buf_desc *rmb_desc,
+					      struct smc_wr_tx_pend_priv **priv)
 {
 	struct smc_llc_msg_confirm_rkey *rkeyllc;
-	struct smc_wr_tx_pend_priv *pend;
 	struct smc_wr_buf *wr_buf;
 	struct smc_link *link;
 	int i, rc, rtok_ix;
 
-	if (!smc_wr_tx_link_hold(send_link))
-		return -ENOLINK;
-	rc = smc_llc_add_pending_send(send_link, &wr_buf, &pend);
+	rc = smc_llc_add_pending_send(send_link, &wr_buf, priv);
 	if (rc)
 		goto put_out;
 	rkeyllc = (struct smc_llc_msg_confirm_rkey *)wr_buf;
@@ -521,25 +520,20 @@ static int smc_llc_send_confirm_rkey(struct smc_link *send_link,
 		cpu_to_be64((uintptr_t)rmb_desc->cpu_addr) :
 		cpu_to_be64((u64)sg_dma_address
 			    (rmb_desc->sgt[send_link->link_idx].sgl));
-	/* send llc message */
-	rc = smc_wr_tx_send(send_link, pend);
 put_out:
-	smc_wr_tx_link_put(send_link);
 	return rc;
 }
 
-/* send LLC delete rkey request */
-static int smc_llc_send_delete_rkey(struct smc_link *link,
-				    struct smc_buf_desc *rmb_desc)
+/* build LLC delete rkey request */
+static int smc_llc_build_delete_rkey_request(struct smc_link *link,
+					     struct smc_buf_desc *rmb_desc,
+					     struct smc_wr_tx_pend_priv **priv)
 {
 	struct smc_llc_msg_delete_rkey *rkeyllc;
-	struct smc_wr_tx_pend_priv *pend;
 	struct smc_wr_buf *wr_buf;
 	int rc;
 
-	if (!smc_wr_tx_link_hold(link))
-		return -ENOLINK;
-	rc = smc_llc_add_pending_send(link, &wr_buf, &pend);
+	rc = smc_llc_add_pending_send(link, &wr_buf, priv);
 	if (rc)
 		goto put_out;
 	rkeyllc = (struct smc_llc_msg_delete_rkey *)wr_buf;
@@ -548,10 +542,7 @@ static int smc_llc_send_delete_rkey(struct smc_link *link,
 	smc_llc_init_msg_hdr(&rkeyllc->hd, link->lgr, sizeof(*rkeyllc));
 	rkeyllc->num_rkeys = 1;
 	rkeyllc->rkey[0] = htonl(rmb_desc->mr[link->link_idx]->rkey);
-	/* send llc message */
-	rc = smc_wr_tx_send(link, pend);
 put_out:
-	smc_wr_tx_link_put(link);
 	return rc;
 }
 
@@ -2017,7 +2008,8 @@ static void smc_llc_rx_response(struct smc_link *link,
 	case SMC_LLC_DELETE_RKEY:
 		if (flowtype != SMC_LLC_FLOW_RKEY || flow->qentry)
 			break;	/* drop out-of-flow response */
-		goto assign;
+		__wake_up(&link->lgr->llc_msg_waiter, TASK_NORMAL, 1, qentry);
+		goto free;
 	case SMC_LLC_CONFIRM_RKEY_CONT:
 		/* not used because max links is 3 */
 		break;
@@ -2026,6 +2018,7 @@ static void smc_llc_rx_response(struct smc_link *link,
 					   qentry->msg.raw.hdr.common.type);
 		break;
 	}
+free:
 	kfree(qentry);
 	return;
 assign:
@@ -2184,25 +2177,98 @@ void smc_llc_link_clear(struct smc_link *link, bool log)
 	cancel_delayed_work_sync(&link->llc_testlink_wrk);
 }
 
+static int smc_llc_rkey_response_wake_function(struct wait_queue_entry *wq_entry,
+					       unsigned int mode, int sync, void *key)
+{
+	struct smc_llc_qentry *except, *incoming;
+	u8 except_llc_type;
+
+	/* not a rkey response */
+	if (!key)
+		return 0;
+
+	except = wq_entry->private;
+	incoming = key;
+
+	except_llc_type = except->msg.raw.hdr.common.llc_type;
+
+	/* except LLC MSG TYPE mismatch */
+	if (except_llc_type != incoming->msg.raw.hdr.common.llc_type)
+		return 0;
+
+	switch (except_llc_type) {
+	case SMC_LLC_CONFIRM_RKEY:
+		if (memcmp(except->msg.confirm_rkey.rtoken, incoming->msg.confirm_rkey.rtoken,
+			   sizeof(struct smc_rmb_rtoken) *
+			   except->msg.confirm_rkey.rtoken[0].num_rkeys))
+			return 0;
+		break;
+	case SMC_LLC_DELETE_RKEY:
+		if (memcmp(except->msg.delete_rkey.rkey, incoming->msg.delete_rkey.rkey,
+			   sizeof(__be32) * except->msg.delete_rkey.num_rkeys))
+			return 0;
+		break;
+	default:
+		pr_warn("smc: invalid except llc msg %d.\n", except_llc_type);
+		return 0;
+	}
+
+	/* match, save hdr */
+	memcpy(&except->msg.raw.hdr, &incoming->msg.raw.hdr, sizeof(except->msg.raw.hdr));
+
+	wq_entry->private = except->private;
+	return woken_wake_function(wq_entry, mode, sync, NULL);
+}
+
 /* register a new rtoken at the remote peer (for all links) */
 int smc_llc_do_confirm_rkey(struct smc_link *send_link,
 			    struct smc_buf_desc *rmb_desc)
 {
+	DEFINE_WAIT_FUNC(wait, smc_llc_rkey_response_wake_function);
 	struct smc_link_group *lgr = send_link->lgr;
-	struct smc_llc_qentry *qentry = NULL;
-	int rc = 0;
+	long timeout = SMC_LLC_WAIT_TIME;
+	struct smc_wr_tx_pend_priv *priv;
+	struct smc_llc_qentry qentry;
+	struct smc_wr_tx_pend *pend;
+	int rc = 0, flags;
 
-	rc = smc_llc_send_confirm_rkey(send_link, rmb_desc);
+	if (!smc_wr_tx_link_hold(send_link))
+		return -ENOLINK;
+
+	rc = smc_llc_build_confirm_rkey_request(send_link, rmb_desc, &priv);
 	if (rc)
 		goto out;
-	/* receive CONFIRM RKEY response from server over RoCE fabric */
-	qentry = smc_llc_wait(lgr, send_link, SMC_LLC_WAIT_TIME,
-			      SMC_LLC_CONFIRM_RKEY);
-	if (!qentry || (qentry->msg.raw.hdr.flags & SMC_LLC_FLAG_RKEY_NEG))
+
+	pend = container_of(priv, struct smc_wr_tx_pend, priv);
+	/* make a copy of send msg */
+	memcpy(&qentry.msg.confirm_rkey, send_link->wr_tx_bufs[pend->idx].raw,
+	       sizeof(qentry.msg.confirm_rkey));
+
+	qentry.private = wait.private;
+	wait.private = &qentry;
+
+	add_wait_queue(&lgr->llc_msg_waiter, &wait);
+
+	/* send llc message */
+	rc = smc_wr_tx_send(send_link, priv);
+	smc_wr_tx_link_put(send_link);
+	if (rc) {
+		remove_wait_queue(&lgr->llc_msg_waiter, &wait);
+		goto out;
+	}
+
+	while (!signal_pending(current) && timeout) {
+		timeout = wait_woken(&wait, TASK_INTERRUPTIBLE, timeout);
+		if (qentry.msg.raw.hdr.flags & SMC_LLC_FLAG_RESP)
+			break;
+	}
+
+	remove_wait_queue(&lgr->llc_msg_waiter, &wait);
+	flags = qentry.msg.raw.hdr.flags;
+
+	if (!(flags & SMC_LLC_FLAG_RESP) || flags & SMC_LLC_FLAG_RKEY_NEG)
 		rc = -EFAULT;
 out:
-	if (qentry)
-		smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
 	return rc;
 }
 
@@ -2210,26 +2276,52 @@ int smc_llc_do_confirm_rkey(struct smc_link *send_link,
 int smc_llc_do_delete_rkey(struct smc_link_group *lgr,
 			   struct smc_buf_desc *rmb_desc)
 {
-	struct smc_llc_qentry *qentry = NULL;
+	DEFINE_WAIT_FUNC(wait, smc_llc_rkey_response_wake_function);
+	long timeout = SMC_LLC_WAIT_TIME;
+	struct smc_wr_tx_pend_priv *priv;
+	struct smc_llc_qentry qentry;
+	struct smc_wr_tx_pend *pend;
 	struct smc_link *send_link;
-	int rc = 0;
+	int rc = 0, flags;
 
 	send_link = smc_llc_usable_link(lgr);
-	if (!send_link)
+	if (!send_link || !smc_wr_tx_link_hold(send_link))
 		return -ENOLINK;
 
-	/* protected by llc_flow control */
-	rc = smc_llc_send_delete_rkey(send_link, rmb_desc);
+	rc = smc_llc_build_delete_rkey_request(send_link, rmb_desc, &priv);
 	if (rc)
 		goto out;
-	/* receive DELETE RKEY response from server over RoCE fabric */
-	qentry = smc_llc_wait(lgr, send_link, SMC_LLC_WAIT_TIME,
-			      SMC_LLC_DELETE_RKEY);
-	if (!qentry || (qentry->msg.raw.hdr.flags & SMC_LLC_FLAG_RKEY_NEG))
+
+	pend = container_of(priv, struct smc_wr_tx_pend, priv);
+	/* make a copy of send msg */
+	memcpy(&qentry.msg.delete_link, send_link->wr_tx_bufs[pend->idx].raw,
+	       sizeof(qentry.msg.delete_link));
+
+	qentry.private = wait.private;
+	wait.private = &qentry;
+
+	add_wait_queue(&lgr->llc_msg_waiter, &wait);
+
+	/* send llc message */
+	rc = smc_wr_tx_send(send_link, priv);
+	smc_wr_tx_link_put(send_link);
+	if (rc) {
+		remove_wait_queue(&lgr->llc_msg_waiter, &wait);
+		goto out;
+	}
+
+	while (!signal_pending(current) && timeout) {
+		timeout = wait_woken(&wait, TASK_INTERRUPTIBLE, timeout);
+		if (qentry.msg.raw.hdr.flags & SMC_LLC_FLAG_RESP)
+			break;
+	}
+
+	remove_wait_queue(&lgr->llc_msg_waiter, &wait);
+	flags = qentry.msg.raw.hdr.flags;
+
+	if (!(flags & SMC_LLC_FLAG_RESP) || flags & SMC_LLC_FLAG_RKEY_NEG)
 		rc = -EFAULT;
 out:
-	if (qentry)
-		smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
 	return rc;
 }
 
diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
index b0678a4..797dffa 100644
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@ -37,16 +37,6 @@
 static DEFINE_HASHTABLE(smc_wr_rx_hash, SMC_WR_RX_HASH_BITS);
 static DEFINE_SPINLOCK(smc_wr_rx_hash_lock);
 
-struct smc_wr_tx_pend {	/* control data for a pending send request */
-	u64			wr_id;		/* work request id sent */
-	smc_wr_tx_handler	handler;
-	enum ib_wc_status	wc_status;	/* CQE status */
-	struct smc_link		*link;
-	u32			idx;
-	struct smc_wr_tx_pend_priv priv;
-	u8			compl_requested;
-};
-
 /******************************** send queue *********************************/
 
 /*------------------------------- completion --------------------------------*/
diff --git a/net/smc/smc_wr.h b/net/smc/smc_wr.h
index 45e9b89..a4ea215 100644
--- a/net/smc/smc_wr.h
+++ b/net/smc/smc_wr.h
@@ -46,6 +46,16 @@ struct smc_wr_rx_handler {
 	u8			type;
 };
 
+struct smc_wr_tx_pend {	/* control data for a pending send request */
+	u64			wr_id;		/* work request id sent */
+	smc_wr_tx_handler	handler;
+	enum ib_wc_status	wc_status;	/* CQE status */
+	struct smc_link		*link;
+	u32			idx;
+	struct smc_wr_tx_pend_priv priv;
+	u8			compl_requested;
+};
+
 /* Only used by RDMA write WRs.
  * All other WRs (CDC/LLC) use smc_wr_tx_send handling WR_ID implicitly
  */
-- 
1.8.3.1

