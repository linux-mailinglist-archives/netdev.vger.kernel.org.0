Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0389163FCC7
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 01:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbiLBAUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 19:20:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbiLBATT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 19:19:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C072D11DF
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 16:17:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669940247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e+gEyqHAYcukbUT7EiIRiNqkNampnQzNPJX4nGRXEqo=;
        b=JR8Ih8GRYppq0fq6mehk+wTHni0Bke6w0jOWxe8IhuEjUuPFhSjJ9nDNJmeQ5mBUrBPTYZ
        kJ+5nKrh0PP6ag8Q9wdlS2sL+3tVU0REBVQMwtFuTfvoIfFlCtx1/ZFUP0yLoRGIK+1ozb
        mzbyNLzldgi4DWUhSlawJuuYP3u+lfI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-403-Mq8ZxlfhMI2AOIBVa-ygAQ-1; Thu, 01 Dec 2022 19:17:23 -0500
X-MC-Unique: Mq8ZxlfhMI2AOIBVa-ygAQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B8C801C05ABD;
        Fri,  2 Dec 2022 00:17:22 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E65B492B11;
        Fri,  2 Dec 2022 00:17:21 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 16/36] rxrpc: Don't hold a ref for call timer or
 workqueue
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Fri, 02 Dec 2022 00:17:18 +0000
Message-ID: <166994023875.1732290.1978144862974692939.stgit@warthog.procyon.org.uk>
In-Reply-To: <166994010342.1732290.13771061038178613124.stgit@warthog.procyon.org.uk>
References: <166994010342.1732290.13771061038178613124.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, rxrpc gives the call timer a ref on the call when it starts it
and this is passed along to the workqueue by the timer expiration function.
The problem comes when queue_work() fails (ie. the work item is already
queued): the timer routine must put the ref - but this may cause the
cleanup code to run.

This has the unfortunate effect that the cleanup code may then be run in
softirq context - which means that any spinlocks it might need to touch
have to be guarded to disable softirqs (ie. they need a "_bh" suffix).

Fix this by:

 (1) Don't give a ref to the timer.

 (2) Making the expiration function not do anything if the refcount is 0.
     Note that this is more of an optimisation.

 (3) Make sure that the cleanup routine waits for timer to complete.

However, this has a consequence that timer cannot give a ref to the work
item.  Therefore the following fixes are also necessary:

 (4) Don't give a ref to the work item.

 (5) Make the work item return asap if it sees the ref count is 0.

 (6) Make sure that the cleanup routine waits for the work item to
     complete.

Unfortunately, neither the timer nor the work item can simply get around
the problem by just using refcount_inc_not_zero() as the waits would still
have to be done, and there would still be the possibility of having to put
the ref in the expiration function.

Note the call work item is going to go away with the work being transferred
to the I/O thread, so the wait in (6) will become obsolete.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |    6 --
 net/rxrpc/ar-internal.h      |    6 +-
 net/rxrpc/call_event.c       |   11 ++--
 net/rxrpc/call_object.c      |  111 ++++++++++++++++--------------------------
 net/rxrpc/txbuf.c            |    2 +
 5 files changed, 52 insertions(+), 84 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 5a2292baffc8..4538de0079a5 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -155,11 +155,9 @@
 	EM(rxrpc_call_get_release_sock,		"GET rel-sock") \
 	EM(rxrpc_call_get_sendmsg,		"GET sendmsg ") \
 	EM(rxrpc_call_get_send_ack,		"GET send-ack") \
-	EM(rxrpc_call_get_timer,		"GET timer   ") \
 	EM(rxrpc_call_get_userid,		"GET user-id ") \
 	EM(rxrpc_call_new_client,		"NEW client  ") \
 	EM(rxrpc_call_new_prealloc_service,	"NEW prealloc") \
-	EM(rxrpc_call_put_already_queued,	"PUT alreadyq") \
 	EM(rxrpc_call_put_discard_prealloc,	"PUT disc-pre") \
 	EM(rxrpc_call_put_input,		"PUT input   ") \
 	EM(rxrpc_call_put_kernel,		"PUT kernel  ") \
@@ -168,11 +166,8 @@
 	EM(rxrpc_call_put_release_sock_tba,	"PUT rls-sk-a") \
 	EM(rxrpc_call_put_send_ack,		"PUT send-ack") \
 	EM(rxrpc_call_put_sendmsg,		"PUT sendmsg ") \
-	EM(rxrpc_call_put_timer,		"PUT timer   ") \
-	EM(rxrpc_call_put_timer_already,	"PUT timer-al") \
 	EM(rxrpc_call_put_unnotify,		"PUT unnotify") \
 	EM(rxrpc_call_put_userid_exists,	"PUT u-exists") \
-	EM(rxrpc_call_put_work,			"PUT work    ") \
 	EM(rxrpc_call_queue_abort,		"QUE abort   ") \
 	EM(rxrpc_call_queue_requeue,		"QUE requeue ") \
 	EM(rxrpc_call_queue_resend,		"QUE resend  ") \
@@ -368,6 +363,7 @@
 	EM(rxrpc_txbuf_put_rotated,		"PUT ROTATED")	\
 	EM(rxrpc_txbuf_put_send_aborted,	"PUT SEND-X ")	\
 	EM(rxrpc_txbuf_put_trans,		"PUT TRANS  ")	\
+	EM(rxrpc_txbuf_see_out_of_step,		"OUT-OF-STEP")	\
 	EM(rxrpc_txbuf_see_send_more,		"SEE SEND+  ")	\
 	E_(rxrpc_txbuf_see_unacked,		"SEE UNACKED")
 
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index c588c0e81f63..03523a864c11 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -598,6 +598,7 @@ struct rxrpc_call {
 	u32			next_req_timo;	/* Timeout for next Rx request packet (jif) */
 	struct timer_list	timer;		/* Combined event timer */
 	struct work_struct	processor;	/* Event processor */
+	struct work_struct	destroyer;	/* In-process-context destroyer */
 	rxrpc_notify_rx_t	notify_rx;	/* kernel service Rx notification function */
 	struct list_head	link;		/* link in master call list */
 	struct list_head	chan_wait_link;	/* Link in conn->bundle->waiting_calls */
@@ -827,8 +828,6 @@ void rxrpc_reduce_call_timer(struct rxrpc_call *call,
 			     unsigned long now,
 			     enum rxrpc_timer_trace why);
 
-void rxrpc_delete_call_timer(struct rxrpc_call *call);
-
 /*
  * call_object.c
  */
@@ -847,8 +846,7 @@ void rxrpc_incoming_call(struct rxrpc_sock *, struct rxrpc_call *,
 			 struct sk_buff *);
 void rxrpc_release_call(struct rxrpc_sock *, struct rxrpc_call *);
 void rxrpc_release_calls_on_socket(struct rxrpc_sock *);
-bool __rxrpc_queue_call(struct rxrpc_call *, enum rxrpc_call_trace);
-bool rxrpc_queue_call(struct rxrpc_call *, enum rxrpc_call_trace);
+void rxrpc_queue_call(struct rxrpc_call *, enum rxrpc_call_trace);
 void rxrpc_see_call(struct rxrpc_call *, enum rxrpc_call_trace);
 bool rxrpc_try_get_call(struct rxrpc_call *, enum rxrpc_call_trace);
 void rxrpc_get_call(struct rxrpc_call *, enum rxrpc_call_trace);
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index 29ca02e53c47..049b92b1c040 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -323,8 +323,8 @@ void rxrpc_process_call(struct work_struct *work)
 		rxrpc_shrink_call_tx_buffer(call);
 
 	if (call->state == RXRPC_CALL_COMPLETE) {
-		rxrpc_delete_call_timer(call);
-		goto out_put;
+		del_timer_sync(&call->timer);
+		goto out;
 	}
 
 	/* Work out if any timeouts tripped */
@@ -432,16 +432,15 @@ void rxrpc_process_call(struct work_struct *work)
 	rxrpc_reduce_call_timer(call, next, now, rxrpc_timer_restart);
 
 	/* other events may have been raised since we started checking */
-	if (call->events && call->state < RXRPC_CALL_COMPLETE)
+	if (call->events)
 		goto requeue;
 
-out_put:
-	rxrpc_put_call(call, rxrpc_call_put_work);
 out:
 	_leave("");
 	return;
 
 requeue:
-	__rxrpc_queue_call(call, rxrpc_call_queue_requeue);
+	if (call->state < RXRPC_CALL_COMPLETE)
+		rxrpc_queue_call(call, rxrpc_call_queue_requeue);
 	goto out;
 }
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 815209673115..9cd7e0190ef4 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -53,9 +53,7 @@ static void rxrpc_call_timer_expired(struct timer_list *t)
 
 	if (call->state < RXRPC_CALL_COMPLETE) {
 		trace_rxrpc_timer_expired(call, jiffies);
-		__rxrpc_queue_call(call, rxrpc_call_queue_timer);
-	} else {
-		rxrpc_put_call(call, rxrpc_call_put_already_queued);
+		rxrpc_queue_call(call, rxrpc_call_queue_timer);
 	}
 }
 
@@ -64,21 +62,14 @@ void rxrpc_reduce_call_timer(struct rxrpc_call *call,
 			     unsigned long now,
 			     enum rxrpc_timer_trace why)
 {
-	if (rxrpc_try_get_call(call, rxrpc_call_get_timer)) {
-		trace_rxrpc_timer(call, why, now);
-		if (timer_reduce(&call->timer, expire_at))
-			rxrpc_put_call(call, rxrpc_call_put_timer_already);
-	}
-}
-
-void rxrpc_delete_call_timer(struct rxrpc_call *call)
-{
-	if (del_timer_sync(&call->timer))
-		rxrpc_put_call(call, rxrpc_call_put_timer);
+	trace_rxrpc_timer(call, why, now);
+	timer_reduce(&call->timer, expire_at);
 }
 
 static struct lock_class_key rxrpc_call_user_mutex_lock_class_key;
 
+static void rxrpc_destroy_call(struct work_struct *);
+
 /*
  * find an extant server call
  * - called in process context with IRQs enabled
@@ -139,7 +130,8 @@ struct rxrpc_call *rxrpc_alloc_call(struct rxrpc_sock *rx, gfp_t gfp,
 				  &rxrpc_call_user_mutex_lock_class_key);
 
 	timer_setup(&call->timer, rxrpc_call_timer_expired, 0);
-	INIT_WORK(&call->processor, &rxrpc_process_call);
+	INIT_WORK(&call->processor, rxrpc_process_call);
+	INIT_WORK(&call->destroyer, rxrpc_destroy_call);
 	INIT_LIST_HEAD(&call->link);
 	INIT_LIST_HEAD(&call->chan_wait_link);
 	INIT_LIST_HEAD(&call->accept_link);
@@ -423,34 +415,12 @@ void rxrpc_incoming_call(struct rxrpc_sock *rx,
 }
 
 /*
- * Queue a call's work processor, getting a ref to pass to the work queue.
+ * Queue a call's work processor.
  */
-bool rxrpc_queue_call(struct rxrpc_call *call, enum rxrpc_call_trace why)
+void rxrpc_queue_call(struct rxrpc_call *call, enum rxrpc_call_trace why)
 {
-	int n;
-
-	if (!__refcount_inc_not_zero(&call->ref, &n))
-		return false;
 	if (rxrpc_queue_work(&call->processor))
-		trace_rxrpc_call(call->debug_id, n + 1, 0, why);
-	else
-		rxrpc_put_call(call, rxrpc_call_put_already_queued);
-	return true;
-}
-
-/*
- * Queue a call's work processor, passing the callers ref to the work queue.
- */
-bool __rxrpc_queue_call(struct rxrpc_call *call, enum rxrpc_call_trace why)
-{
-	int n = refcount_read(&call->ref);
-
-	ASSERTCMP(n, >=, 1);
-	if (rxrpc_queue_work(&call->processor))
-		trace_rxrpc_call(call->debug_id, n, 0, why);
-	else
-		rxrpc_put_call(call, rxrpc_call_put_already_queued);
-	return true;
+		trace_rxrpc_call(call->debug_id, refcount_read(&call->ref), 0, why);
 }
 
 /*
@@ -514,7 +484,7 @@ void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
 		BUG();
 
 	rxrpc_put_call_slot(call);
-	rxrpc_delete_call_timer(call);
+	del_timer_sync(&call->timer);
 
 	/* Make sure we don't get any more notifications */
 	write_lock_bh(&rx->recvmsg_lock);
@@ -612,36 +582,41 @@ void rxrpc_put_call(struct rxrpc_call *call, enum rxrpc_call_trace why)
 }
 
 /*
- * Final call destruction - but must be done in process context.
+ * Free up the call under RCU.
  */
-static void rxrpc_destroy_call(struct work_struct *work)
+static void rxrpc_rcu_free_call(struct rcu_head *rcu)
 {
-	struct rxrpc_call *call = container_of(work, struct rxrpc_call, processor);
-	struct rxrpc_net *rxnet = call->rxnet;
-
-	rxrpc_delete_call_timer(call);
+	struct rxrpc_call *call = container_of(rcu, struct rxrpc_call, rcu);
+	struct rxrpc_net *rxnet = READ_ONCE(call->rxnet);
 
-	rxrpc_put_connection(call->conn, rxrpc_conn_put_call);
-	rxrpc_put_peer(call->peer, rxrpc_peer_put_call);
 	kmem_cache_free(rxrpc_call_jar, call);
 	if (atomic_dec_and_test(&rxnet->nr_calls))
 		wake_up_var(&rxnet->nr_calls);
 }
 
 /*
- * Final call destruction under RCU.
+ * Final call destruction - but must be done in process context.
  */
-static void rxrpc_rcu_destroy_call(struct rcu_head *rcu)
+static void rxrpc_destroy_call(struct work_struct *work)
 {
-	struct rxrpc_call *call = container_of(rcu, struct rxrpc_call, rcu);
+	struct rxrpc_call *call = container_of(work, struct rxrpc_call, destroyer);
+	struct rxrpc_txbuf *txb;
 
-	if (in_softirq()) {
-		INIT_WORK(&call->processor, rxrpc_destroy_call);
-		if (!rxrpc_queue_work(&call->processor))
-			BUG();
-	} else {
-		rxrpc_destroy_call(&call->processor);
+	del_timer_sync(&call->timer);
+	cancel_work_sync(&call->processor); /* The processor may restart the timer */
+	del_timer_sync(&call->timer);
+
+	rxrpc_cleanup_ring(call);
+	while ((txb = list_first_entry_or_null(&call->tx_buffer,
+					       struct rxrpc_txbuf, call_link))) {
+		list_del(&txb->call_link);
+		rxrpc_put_txbuf(txb, rxrpc_txbuf_put_cleaned);
 	}
+	rxrpc_put_txbuf(call->tx_pending, rxrpc_txbuf_put_cleaned);
+	rxrpc_free_skb(call->acks_soft_tbl, rxrpc_skb_put_ack);
+	rxrpc_put_connection(call->conn, rxrpc_conn_put_call);
+	rxrpc_put_peer(call->peer, rxrpc_peer_put_call);
+	call_rcu(&call->rcu, rxrpc_rcu_free_call);
 }
 
 /*
@@ -649,23 +624,21 @@ static void rxrpc_rcu_destroy_call(struct rcu_head *rcu)
  */
 void rxrpc_cleanup_call(struct rxrpc_call *call)
 {
-	struct rxrpc_txbuf *txb;
-
 	memset(&call->sock_node, 0xcd, sizeof(call->sock_node));
 
 	ASSERTCMP(call->state, ==, RXRPC_CALL_COMPLETE);
 	ASSERT(test_bit(RXRPC_CALL_RELEASED, &call->flags));
 
-	rxrpc_cleanup_ring(call);
-	while ((txb = list_first_entry_or_null(&call->tx_buffer,
-					       struct rxrpc_txbuf, call_link))) {
-		list_del(&txb->call_link);
-		rxrpc_put_txbuf(txb, rxrpc_txbuf_put_cleaned);
-	}
-	rxrpc_put_txbuf(call->tx_pending, rxrpc_txbuf_put_cleaned);
-	rxrpc_free_skb(call->acks_soft_tbl, rxrpc_skb_put_ack);
+	del_timer_sync(&call->timer);
+	cancel_work(&call->processor);
 
-	call_rcu(&call->rcu, rxrpc_rcu_destroy_call);
+	if (in_softirq() || work_busy(&call->processor))
+		/* Can't use the rxrpc workqueue as we need to cancel/flush
+		 * something that may be running/waiting there.
+		 */
+		schedule_work(&call->destroyer);
+	else
+		rxrpc_destroy_call(&call->destroyer);
 }
 
 /*
diff --git a/net/rxrpc/txbuf.c b/net/rxrpc/txbuf.c
index 96bfee89927b..f93dc666a3a0 100644
--- a/net/rxrpc/txbuf.c
+++ b/net/rxrpc/txbuf.c
@@ -120,6 +120,8 @@ void rxrpc_shrink_call_tx_buffer(struct rxrpc_call *call)
 		if (before(hard_ack, txb->seq))
 			break;
 
+		if (txb->seq != call->tx_bottom + 1)
+			rxrpc_see_txbuf(txb, rxrpc_txbuf_see_out_of_step);
 		ASSERTCMP(txb->seq, ==, call->tx_bottom + 1);
 		call->tx_bottom++;
 		list_del_rcu(&txb->call_link);


