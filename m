Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD3A26359C9
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 11:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236408AbiKWKX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 05:23:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236668AbiKWKWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 05:22:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 358BA5132D
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 02:07:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669198077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RH3ZSZs0tZMzNtBKgbELarzwcVTfiI+mcv9x3j9ARv4=;
        b=VfML+SfND7X6wGChKba5/URV4Zqa2c0Nnfqj3ZQOIaYMTQ7Rc+xwq/qi1xJxRm/GIDixai
        8kdnnA09Pd1q9zuwit2X7zLc0yW5MbfaBDGFiaMz5BDTplTtd/6TQgAg9taiu1QifpGgOY
        Aoq28nLTloNYqGTwdmakrL0KqgPMSTM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-tG4ELBRZNESUmmt42NGMZQ-1; Wed, 23 Nov 2022 05:07:53 -0500
X-MC-Unique: tG4ELBRZNESUmmt42NGMZQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 857E7811E67;
        Wed, 23 Nov 2022 10:07:53 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AC221477F5D;
        Wed, 23 Nov 2022 10:07:52 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 11/13] rxrpc: trace: Don't use
 __builtin_return_address for rxrpc_call tracing
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 23 Nov 2022 10:07:50 +0000
Message-ID: <166919807007.1256245.13212519521351636369.stgit@warthog.procyon.org.uk>
In-Reply-To: <166919798040.1256245.11495568684139066955.stgit@warthog.procyon.org.uk>
References: <166919798040.1256245.11495568684139066955.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rxrpc tracing, use enums to generate lists of points of interest rather
than __builtin_return_address() for the rxrpc_call tracepoint

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |   84 +++++++++++++++++++++--------------
 net/rxrpc/ar-internal.h      |    8 ++-
 net/rxrpc/call_accept.c      |   16 +++----
 net/rxrpc/call_event.c       |   10 ++--
 net/rxrpc/call_object.c      |  102 ++++++++++++++++++------------------------
 net/rxrpc/conn_client.c      |    2 -
 net/rxrpc/input.c            |    8 ++-
 net/rxrpc/output.c           |    2 -
 net/rxrpc/peer_event.c       |    2 -
 net/rxrpc/recvmsg.c          |    8 ++-
 net/rxrpc/sendmsg.c          |    4 +-
 11 files changed, 123 insertions(+), 123 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index e09568a8c173..34151d17e7b6 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -127,26 +127,45 @@
 	E_(rxrpc_client_to_idle,		"->Idle")
 
 #define rxrpc_call_traces \
-	EM(rxrpc_call_connected,		"CON") \
-	EM(rxrpc_call_error,			"*E*") \
-	EM(rxrpc_call_got,			"GOT") \
-	EM(rxrpc_call_got_kernel,		"Gke") \
-	EM(rxrpc_call_got_timer,		"GTM") \
-	EM(rxrpc_call_got_tx,			"Gtx") \
-	EM(rxrpc_call_got_userid,		"Gus") \
-	EM(rxrpc_call_new_client,		"NWc") \
-	EM(rxrpc_call_new_service,		"NWs") \
-	EM(rxrpc_call_put,			"PUT") \
-	EM(rxrpc_call_put_kernel,		"Pke") \
-	EM(rxrpc_call_put_noqueue,		"PnQ") \
-	EM(rxrpc_call_put_notimer,		"PnT") \
-	EM(rxrpc_call_put_timer,		"PTM") \
-	EM(rxrpc_call_put_tx,			"Ptx") \
-	EM(rxrpc_call_put_userid,		"Pus") \
-	EM(rxrpc_call_queued,			"QUE") \
-	EM(rxrpc_call_queued_ref,		"QUR") \
-	EM(rxrpc_call_release,			"RLS") \
-	E_(rxrpc_call_seen,			"SEE")
+	EM(rxrpc_call_get_input,		"GET input   ") \
+	EM(rxrpc_call_get_kernel_service,	"GET krnl-srv") \
+	EM(rxrpc_call_get_notify_socket,	"GET notify  ") \
+	EM(rxrpc_call_get_recvmsg,		"GET recvmsg ") \
+	EM(rxrpc_call_get_release_sock,		"GET rel-sock") \
+	EM(rxrpc_call_get_retrans,		"GET retrans ") \
+	EM(rxrpc_call_get_sendmsg,		"GET sendmsg ") \
+	EM(rxrpc_call_get_send_ack,		"GET send-ack") \
+	EM(rxrpc_call_get_timer,		"GET timer   ") \
+	EM(rxrpc_call_get_userid,		"GET user-id ") \
+	EM(rxrpc_call_new_client,		"NEW client  ") \
+	EM(rxrpc_call_new_prealloc_service,	"NEW prealloc") \
+	EM(rxrpc_call_put_already_queued,	"PUT alreadyq") \
+	EM(rxrpc_call_put_discard_prealloc,	"PUT disc-pre") \
+	EM(rxrpc_call_put_input,		"PUT input   ") \
+	EM(rxrpc_call_put_kernel,		"PUT kernel  ") \
+	EM(rxrpc_call_put_recvmsg,		"PUT recvmsg ") \
+	EM(rxrpc_call_put_release_sock,		"PUT rls-sock") \
+	EM(rxrpc_call_put_release_sock_tba,	"PUT rls-sk-a") \
+	EM(rxrpc_call_put_send_ack,		"PUT send-ack") \
+	EM(rxrpc_call_put_sendmsg,		"PUT sendmsg ") \
+	EM(rxrpc_call_put_timer,		"PUT timer   ") \
+	EM(rxrpc_call_put_timer_already,	"PUT timer-al") \
+	EM(rxrpc_call_put_unnotify,		"PUT unnotify") \
+	EM(rxrpc_call_put_userid_exists,	"PUT u-exists") \
+	EM(rxrpc_call_put_work,			"PUT work    ") \
+	EM(rxrpc_call_queue_abort,		"QUE abort   ") \
+	EM(rxrpc_call_queue_requeue,		"QUE requeue ") \
+	EM(rxrpc_call_queue_resend,		"QUE resend  ") \
+	EM(rxrpc_call_queue_timer,		"QUE timer   ") \
+	EM(rxrpc_call_see_accept,		"SEE accept  ") \
+	EM(rxrpc_call_see_activate_client,	"SEE act-clnt") \
+	EM(rxrpc_call_see_connect_failed,	"SEE con-fail") \
+	EM(rxrpc_call_see_connected,		"SEE connect ") \
+	EM(rxrpc_call_see_distribute_error,	"SEE dist-err") \
+	EM(rxrpc_call_see_input,		"SEE input   ") \
+	EM(rxrpc_call_see_release,		"SEE release ") \
+	EM(rxrpc_call_see_userid_exists,	"SEE u-exists") \
+	E_(rxrpc_call_see_zap,			"SEE zap     ")
 
 #define rxrpc_txqueue_traces \
 	EM(rxrpc_txqueue_await_reply,		"AWR") \
@@ -503,32 +522,29 @@ TRACE_EVENT(rxrpc_client,
 	    );
 
 TRACE_EVENT(rxrpc_call,
-	    TP_PROTO(unsigned int call_debug_id, enum rxrpc_call_trace op,
-		     int usage, const void *where, const void *aux),
+	    TP_PROTO(unsigned int call_debug_id, int ref, unsigned long aux,
+		     enum rxrpc_call_trace why),
 
-	    TP_ARGS(call_debug_id, op, usage, where, aux),
+	    TP_ARGS(call_debug_id, ref, aux, why),
 
 	    TP_STRUCT__entry(
 		    __field(unsigned int,		call		)
-		    __field(int,			op		)
-		    __field(int,			usage		)
-		    __field(const void *,		where		)
-		    __field(const void *,		aux		)
+		    __field(int,			ref		)
+		    __field(int,			why		)
+		    __field(unsigned long,		aux		)
 			     ),
 
 	    TP_fast_assign(
 		    __entry->call = call_debug_id;
-		    __entry->op = op;
-		    __entry->usage = usage;
-		    __entry->where = where;
+		    __entry->ref = ref;
+		    __entry->why = why;
 		    __entry->aux = aux;
 			   ),
 
-	    TP_printk("c=%08x %s u=%d sp=%pSR a=%p",
+	    TP_printk("c=%08x %s r=%d a=%lx",
 		      __entry->call,
-		      __print_symbolic(__entry->op, rxrpc_call_traces),
-		      __entry->usage,
-		      __entry->where,
+		      __print_symbolic(__entry->why, rxrpc_call_traces),
+		      __entry->ref,
 		      __entry->aux)
 	    );
 
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index bc8281c410c5..82eb09b961a0 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -847,10 +847,10 @@ void rxrpc_incoming_call(struct rxrpc_sock *, struct rxrpc_call *,
 			 struct sk_buff *);
 void rxrpc_release_call(struct rxrpc_sock *, struct rxrpc_call *);
 void rxrpc_release_calls_on_socket(struct rxrpc_sock *);
-bool __rxrpc_queue_call(struct rxrpc_call *);
-bool rxrpc_queue_call(struct rxrpc_call *);
-void rxrpc_see_call(struct rxrpc_call *);
-bool rxrpc_try_get_call(struct rxrpc_call *call, enum rxrpc_call_trace op);
+bool __rxrpc_queue_call(struct rxrpc_call *, enum rxrpc_call_trace);
+bool rxrpc_queue_call(struct rxrpc_call *, enum rxrpc_call_trace);
+void rxrpc_see_call(struct rxrpc_call *, enum rxrpc_call_trace);
+bool rxrpc_try_get_call(struct rxrpc_call *, enum rxrpc_call_trace);
 void rxrpc_get_call(struct rxrpc_call *, enum rxrpc_call_trace);
 void rxrpc_put_call(struct rxrpc_call *, enum rxrpc_call_trace);
 void rxrpc_cleanup_call(struct rxrpc_call *);
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index 04b52e28e0cc..dd4ca4bee77f 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -38,7 +38,6 @@ static int rxrpc_service_prealloc_one(struct rxrpc_sock *rx,
 				      unsigned long user_call_ID, gfp_t gfp,
 				      unsigned int debug_id)
 {
-	const void *here = __builtin_return_address(0);
 	struct rxrpc_call *call, *xcall;
 	struct rxrpc_net *rxnet = rxrpc_net(sock_net(&rx->sk));
 	struct rb_node *parent, **pp;
@@ -102,9 +101,8 @@ static int rxrpc_service_prealloc_one(struct rxrpc_sock *rx,
 	call->flags |= (1 << RXRPC_CALL_IS_SERVICE);
 	call->state = RXRPC_CALL_SERVER_PREALLOC;
 
-	trace_rxrpc_call(call->debug_id, rxrpc_call_new_service,
-			 refcount_read(&call->ref),
-			 here, (const void *)user_call_ID);
+	trace_rxrpc_call(call->debug_id, refcount_read(&call->ref),
+			 user_call_ID, rxrpc_call_new_prealloc_service);
 
 	write_lock(&rx->call_lock);
 
@@ -125,11 +123,11 @@ static int rxrpc_service_prealloc_one(struct rxrpc_sock *rx,
 	call->user_call_ID = user_call_ID;
 	call->notify_rx = notify_rx;
 	if (user_attach_call) {
-		rxrpc_get_call(call, rxrpc_call_got_kernel);
+		rxrpc_get_call(call, rxrpc_call_get_kernel_service);
 		user_attach_call(call, user_call_ID);
 	}
 
-	rxrpc_get_call(call, rxrpc_call_got_userid);
+	rxrpc_get_call(call, rxrpc_call_get_userid);
 	rb_link_node(&call->sock_node, parent, pp);
 	rb_insert_color(&call->sock_node, &rx->calls);
 	set_bit(RXRPC_CALL_HAS_USERID, &call->flags);
@@ -229,7 +227,7 @@ void rxrpc_discard_prealloc(struct rxrpc_sock *rx)
 		}
 		rxrpc_call_completed(call);
 		rxrpc_release_call(rx, call);
-		rxrpc_put_call(call, rxrpc_call_put);
+		rxrpc_put_call(call, rxrpc_call_put_discard_prealloc);
 		tail = (tail + 1) & (size - 1);
 	}
 
@@ -318,7 +316,7 @@ static struct rxrpc_call *rxrpc_alloc_incoming_call(struct rxrpc_sock *rx,
 	smp_store_release(&b->call_backlog_tail,
 			  (call_tail + 1) & (RXRPC_BACKLOG_MAX - 1));
 
-	rxrpc_see_call(call);
+	rxrpc_see_call(call, rxrpc_call_see_accept);
 	call->conn = conn;
 	call->security = conn->security;
 	call->security_ix = conn->security_ix;
@@ -430,7 +428,7 @@ struct rxrpc_call *rxrpc_new_incoming_call(struct rxrpc_local *local,
 	 * (recvmsg queue, to-be-accepted queue or user ID tree) or the kernel
 	 * service to prevent the call from being deallocated too early.
 	 */
-	rxrpc_put_call(call, rxrpc_call_put);
+	rxrpc_put_call(call, rxrpc_call_put_discard_prealloc);
 
 	_leave(" = %p{%d}", call, call->debug_id);
 	return call;
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index 8dfcde127a1d..7ea26fc358a0 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -101,7 +101,7 @@ void rxrpc_send_ACK(struct rxrpc_call *call, u8 ack_reason,
 	txb->ack.reason		= ack_reason;
 	txb->ack.nAcks		= 0;
 
-	if (!rxrpc_try_get_call(call, rxrpc_call_got)) {
+	if (!rxrpc_try_get_call(call, rxrpc_call_get_send_ack)) {
 		rxrpc_put_txbuf(txb, rxrpc_txbuf_put_nomem);
 		return;
 	}
@@ -198,7 +198,7 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 
 			if (list_empty(&txb->tx_link)) {
 				rxrpc_get_txbuf(txb, rxrpc_txbuf_get_retrans);
-				rxrpc_get_call(call, rxrpc_call_got_tx);
+				rxrpc_get_call(call, rxrpc_call_get_retrans);
 				list_add_tail(&txb->tx_link, &retrans_queue);
 				set_bit(RXRPC_TXBUF_RESENT, &txb->flags);
 			}
@@ -303,7 +303,7 @@ void rxrpc_process_call(struct work_struct *work)
 	unsigned int iterations = 0;
 	rxrpc_serial_t ackr_serial;
 
-	rxrpc_see_call(call);
+	rxrpc_see_call(call, rxrpc_call_see_input);
 
 	//printk("\n--------------------\n");
 	_enter("{%d,%s,%lx}",
@@ -437,12 +437,12 @@ void rxrpc_process_call(struct work_struct *work)
 		goto requeue;
 
 out_put:
-	rxrpc_put_call(call, rxrpc_call_put);
+	rxrpc_put_call(call, rxrpc_call_put_work);
 out:
 	_leave("");
 	return;
 
 requeue:
-	__rxrpc_queue_call(call);
+	__rxrpc_queue_call(call, rxrpc_call_queue_requeue);
 	goto out;
 }
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 29ec4013aa0b..afd957f6dc1c 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -53,9 +53,9 @@ static void rxrpc_call_timer_expired(struct timer_list *t)
 
 	if (call->state < RXRPC_CALL_COMPLETE) {
 		trace_rxrpc_timer_expired(call, jiffies);
-		__rxrpc_queue_call(call);
+		__rxrpc_queue_call(call, rxrpc_call_queue_timer);
 	} else {
-		rxrpc_put_call(call, rxrpc_call_put);
+		rxrpc_put_call(call, rxrpc_call_put_already_queued);
 	}
 }
 
@@ -64,10 +64,10 @@ void rxrpc_reduce_call_timer(struct rxrpc_call *call,
 			     unsigned long now,
 			     enum rxrpc_timer_trace why)
 {
-	if (rxrpc_try_get_call(call, rxrpc_call_got_timer)) {
+	if (rxrpc_try_get_call(call, rxrpc_call_get_timer)) {
 		trace_rxrpc_timer(call, why, now);
 		if (timer_reduce(&call->timer, expire_at))
-			rxrpc_put_call(call, rxrpc_call_put_notimer);
+			rxrpc_put_call(call, rxrpc_call_put_timer_already);
 	}
 }
 
@@ -110,7 +110,7 @@ struct rxrpc_call *rxrpc_find_call_by_user_ID(struct rxrpc_sock *rx,
 	return NULL;
 
 found_extant_call:
-	rxrpc_get_call(call, rxrpc_call_got);
+	rxrpc_get_call(call, rxrpc_call_get_sendmsg);
 	read_unlock(&rx->call_lock);
 	_leave(" = %p [%d]", call, refcount_read(&call->ref));
 	return call;
@@ -270,7 +270,6 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 	struct rxrpc_net *rxnet;
 	struct semaphore *limiter;
 	struct rb_node *parent, **pp;
-	const void *here = __builtin_return_address(0);
 	int ret;
 
 	_enter("%p,%lx", rx, p->user_call_ID);
@@ -291,9 +290,8 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 
 	call->interruptibility = p->interruptibility;
 	call->tx_total_len = p->tx_total_len;
-	trace_rxrpc_call(call->debug_id, rxrpc_call_new_client,
-			 refcount_read(&call->ref),
-			 here, (const void *)p->user_call_ID);
+	trace_rxrpc_call(call->debug_id, refcount_read(&call->ref),
+			 p->user_call_ID, rxrpc_call_new_client);
 	if (p->kernel)
 		__set_bit(RXRPC_CALL_KERNEL, &call->flags);
 
@@ -322,7 +320,7 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 	rcu_assign_pointer(call->socket, rx);
 	call->user_call_ID = p->user_call_ID;
 	__set_bit(RXRPC_CALL_HAS_USERID, &call->flags);
-	rxrpc_get_call(call, rxrpc_call_got_userid);
+	rxrpc_get_call(call, rxrpc_call_get_userid);
 	rb_link_node(&call->sock_node, parent, pp);
 	rb_insert_color(&call->sock_node, &rx->calls);
 	list_add(&call->sock_link, &rx->sock_calls);
@@ -344,8 +342,7 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 	if (ret < 0)
 		goto error_attached_to_socket;
 
-	trace_rxrpc_call(call->debug_id, rxrpc_call_connected,
-			 refcount_read(&call->ref), here, NULL);
+	rxrpc_see_call(call, rxrpc_call_see_connected);
 
 	rxrpc_start_call_timer(call);
 
@@ -362,11 +359,11 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 	release_sock(&rx->sk);
 	__rxrpc_set_call_completion(call, RXRPC_CALL_LOCAL_ERROR,
 				    RX_CALL_DEAD, -EEXIST);
-	trace_rxrpc_call(call->debug_id, rxrpc_call_error,
-			 refcount_read(&call->ref), here, ERR_PTR(-EEXIST));
+	trace_rxrpc_call(call->debug_id, refcount_read(&call->ref), 0,
+			 rxrpc_call_see_userid_exists);
 	rxrpc_release_call(rx, call);
 	mutex_unlock(&call->user_mutex);
-	rxrpc_put_call(call, rxrpc_call_put);
+	rxrpc_put_call(call, rxrpc_call_put_userid_exists);
 	_leave(" = -EEXIST");
 	return ERR_PTR(-EEXIST);
 
@@ -376,8 +373,8 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 	 * leave the error to recvmsg() to deal with.
 	 */
 error_attached_to_socket:
-	trace_rxrpc_call(call->debug_id, rxrpc_call_error,
-			 refcount_read(&call->ref), here, ERR_PTR(ret));
+	trace_rxrpc_call(call->debug_id, refcount_read(&call->ref), ret,
+			 rxrpc_call_see_connect_failed);
 	set_bit(RXRPC_CALL_DISCONNECTED, &call->flags);
 	__rxrpc_set_call_completion(call, RXRPC_CALL_LOCAL_ERROR,
 				    RX_CALL_DEAD, ret);
@@ -428,72 +425,65 @@ void rxrpc_incoming_call(struct rxrpc_sock *rx,
 /*
  * Queue a call's work processor, getting a ref to pass to the work queue.
  */
-bool rxrpc_queue_call(struct rxrpc_call *call)
+bool rxrpc_queue_call(struct rxrpc_call *call, enum rxrpc_call_trace why)
 {
-	const void *here = __builtin_return_address(0);
 	int n;
 
 	if (!__refcount_inc_not_zero(&call->ref, &n))
 		return false;
 	if (rxrpc_queue_work(&call->processor))
-		trace_rxrpc_call(call->debug_id, rxrpc_call_queued, n + 1,
-				 here, NULL);
+		trace_rxrpc_call(call->debug_id, n + 1, 0, why);
 	else
-		rxrpc_put_call(call, rxrpc_call_put_noqueue);
+		rxrpc_put_call(call, rxrpc_call_put_already_queued);
 	return true;
 }
 
 /*
  * Queue a call's work processor, passing the callers ref to the work queue.
  */
-bool __rxrpc_queue_call(struct rxrpc_call *call)
+bool __rxrpc_queue_call(struct rxrpc_call *call, enum rxrpc_call_trace why)
 {
-	const void *here = __builtin_return_address(0);
 	int n = refcount_read(&call->ref);
+
 	ASSERTCMP(n, >=, 1);
 	if (rxrpc_queue_work(&call->processor))
-		trace_rxrpc_call(call->debug_id, rxrpc_call_queued_ref, n,
-				 here, NULL);
+		trace_rxrpc_call(call->debug_id, n, 0, why);
 	else
-		rxrpc_put_call(call, rxrpc_call_put_noqueue);
+		rxrpc_put_call(call, rxrpc_call_put_already_queued);
 	return true;
 }
 
 /*
  * Note the re-emergence of a call.
  */
-void rxrpc_see_call(struct rxrpc_call *call)
+void rxrpc_see_call(struct rxrpc_call *call, enum rxrpc_call_trace why)
 {
-	const void *here = __builtin_return_address(0);
 	if (call) {
-		int n = refcount_read(&call->ref);
+		int r = refcount_read(&call->ref);
 
-		trace_rxrpc_call(call->debug_id, rxrpc_call_seen, n,
-				 here, NULL);
+		trace_rxrpc_call(call->debug_id, r, 0, why);
 	}
 }
 
-bool rxrpc_try_get_call(struct rxrpc_call *call, enum rxrpc_call_trace op)
+bool rxrpc_try_get_call(struct rxrpc_call *call, enum rxrpc_call_trace why)
 {
-	const void *here = __builtin_return_address(0);
-	int n;
+	int r;
 
-	if (!__refcount_inc_not_zero(&call->ref, &n))
+	if (!__refcount_inc_not_zero(&call->ref, &r))
 		return false;
-	trace_rxrpc_call(call->debug_id, op, n + 1, here, NULL);
+	trace_rxrpc_call(call->debug_id, r + 1, 0, why);
 	return true;
 }
 
 /*
  * Note the addition of a ref on a call.
  */
-void rxrpc_get_call(struct rxrpc_call *call, enum rxrpc_call_trace op)
+void rxrpc_get_call(struct rxrpc_call *call, enum rxrpc_call_trace why)
 {
-	const void *here = __builtin_return_address(0);
-	int n;
+	int r;
 
-	__refcount_inc(&call->ref, &n);
-	trace_rxrpc_call(call->debug_id, op, n + 1, here, NULL);
+	__refcount_inc(&call->ref, &r);
+	trace_rxrpc_call(call->debug_id, r + 1, 0, why);
 }
 
 /*
@@ -510,15 +500,13 @@ static void rxrpc_cleanup_ring(struct rxrpc_call *call)
  */
 void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
 {
-	const void *here = __builtin_return_address(0);
 	struct rxrpc_connection *conn = call->conn;
 	bool put = false;
 
 	_enter("{%d,%d}", call->debug_id, refcount_read(&call->ref));
 
-	trace_rxrpc_call(call->debug_id, rxrpc_call_release,
-			 refcount_read(&call->ref),
-			 here, (const void *)call->flags);
+	trace_rxrpc_call(call->debug_id, refcount_read(&call->ref),
+			 call->flags, rxrpc_call_see_release);
 
 	ASSERTCMP(call->state, ==, RXRPC_CALL_COMPLETE);
 
@@ -544,14 +532,14 @@ void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
 
 	write_unlock_bh(&rx->recvmsg_lock);
 	if (put)
-		rxrpc_put_call(call, rxrpc_call_put);
+		rxrpc_put_call(call, rxrpc_call_put_unnotify);
 
 	write_lock(&rx->call_lock);
 
 	if (test_and_clear_bit(RXRPC_CALL_HAS_USERID, &call->flags)) {
 		rb_erase(&call->sock_node, &rx->calls);
 		memset(&call->sock_node, 0xdd, sizeof(call->sock_node));
-		rxrpc_put_call(call, rxrpc_call_put_userid);
+		rxrpc_put_call(call, rxrpc_call_put_userid_exists);
 	}
 
 	list_del(&call->sock_link);
@@ -580,17 +568,17 @@ void rxrpc_release_calls_on_socket(struct rxrpc_sock *rx)
 				  struct rxrpc_call, accept_link);
 		list_del(&call->accept_link);
 		rxrpc_abort_call("SKR", call, 0, RX_CALL_DEAD, -ECONNRESET);
-		rxrpc_put_call(call, rxrpc_call_put);
+		rxrpc_put_call(call, rxrpc_call_put_release_sock_tba);
 	}
 
 	while (!list_empty(&rx->sock_calls)) {
 		call = list_entry(rx->sock_calls.next,
 				  struct rxrpc_call, sock_link);
-		rxrpc_get_call(call, rxrpc_call_got);
+		rxrpc_get_call(call, rxrpc_call_get_release_sock);
 		rxrpc_abort_call("SKT", call, 0, RX_CALL_DEAD, -ECONNRESET);
 		rxrpc_send_abort_packet(call);
 		rxrpc_release_call(rx, call);
-		rxrpc_put_call(call, rxrpc_call_put);
+		rxrpc_put_call(call, rxrpc_call_put_release_sock);
 	}
 
 	_leave("");
@@ -599,20 +587,18 @@ void rxrpc_release_calls_on_socket(struct rxrpc_sock *rx)
 /*
  * release a call
  */
-void rxrpc_put_call(struct rxrpc_call *call, enum rxrpc_call_trace op)
+void rxrpc_put_call(struct rxrpc_call *call, enum rxrpc_call_trace why)
 {
 	struct rxrpc_net *rxnet = call->rxnet;
-	const void *here = __builtin_return_address(0);
 	unsigned int debug_id = call->debug_id;
 	bool dead;
-	int n;
+	int r;
 
 	ASSERT(call != NULL);
 
-	dead = __refcount_dec_and_test(&call->ref, &n);
-	trace_rxrpc_call(debug_id, op, n, here, NULL);
+	dead = __refcount_dec_and_test(&call->ref, &r);
+	trace_rxrpc_call(debug_id, r - 1, 0, why);
 	if (dead) {
-		_debug("call %d dead", call->debug_id);
 		ASSERTCMP(call->state, ==, RXRPC_CALL_COMPLETE);
 
 		if (!list_empty(&call->link)) {
@@ -701,7 +687,7 @@ void rxrpc_destroy_all_calls(struct rxrpc_net *rxnet)
 					  struct rxrpc_call, link);
 			_debug("Zapping call %p", call);
 
-			rxrpc_see_call(call);
+			rxrpc_see_call(call, rxrpc_call_see_zap);
 			list_del_init(&call->link);
 
 			pr_err("Call %p still in use (%d,%s,%lx,%lx)!\n",
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index dcfec6a45255..4352e777aa2a 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -540,7 +540,7 @@ static void rxrpc_activate_one_channel(struct rxrpc_connection *conn,
 	clear_bit(RXRPC_CONN_FINAL_ACK_0 + channel, &conn->flags);
 	clear_bit(conn->bundle_shift + channel, &bundle->avail_chans);
 
-	rxrpc_see_call(call);
+	rxrpc_see_call(call, rxrpc_call_see_activate_client);
 	list_del_init(&call->chan_wait_link);
 	call->peer	= rxrpc_get_peer(conn->peer, rxrpc_peer_get_activate_call);
 	call->conn	= rxrpc_get_connection(conn, rxrpc_conn_get_activate_call);
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index c8ff7489b412..09b44cd11c9b 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -14,7 +14,7 @@ static void rxrpc_proto_abort(const char *why,
 {
 	if (rxrpc_abort_call(why, call, seq, RX_PROTOCOL_ERROR, -EBADMSG)) {
 		set_bit(RXRPC_CALL_EV_ABORT, &call->events);
-		rxrpc_queue_call(call);
+		rxrpc_queue_call(call, rxrpc_call_queue_abort);
 	}
 }
 
@@ -175,7 +175,7 @@ static void rxrpc_congestion_management(struct rxrpc_call *call,
 	call->cong_cumul_acks = cumulative_acks;
 	trace_rxrpc_congest(call, summary, acked_serial, change);
 	if (resend && !test_and_set_bit(RXRPC_CALL_EV_RESEND, &call->events))
-		rxrpc_queue_call(call);
+		rxrpc_queue_call(call, rxrpc_call_queue_resend);
 	return;
 
 packet_loss_detected:
@@ -678,7 +678,7 @@ static void rxrpc_input_check_for_lost_ack(struct rxrpc_call *call)
 {
 	if (after(call->acks_lost_top, call->acks_prev_seq) &&
 	    !test_and_set_bit(RXRPC_CALL_EV_RESEND, &call->events))
-		rxrpc_queue_call(call);
+		rxrpc_queue_call(call, rxrpc_call_queue_resend);
 }
 
 /*
@@ -1099,7 +1099,7 @@ static void rxrpc_input_implicit_end_call(struct rxrpc_sock *rx,
 	default:
 		if (rxrpc_abort_call("IMP", call, 0, RX_CALL_DEAD, -ESHUTDOWN)) {
 			set_bit(RXRPC_CALL_EV_ABORT, &call->events);
-			rxrpc_queue_call(call);
+			rxrpc_queue_call(call, rxrpc_call_queue_abort);
 		}
 		trace_rxrpc_improper_term(call);
 		break;
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 2762b7ada9ae..d324e88f7642 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -310,7 +310,7 @@ void rxrpc_transmit_ack_packets(struct rxrpc_local *local)
 		}
 
 		list_del_init(&txb->tx_link);
-		rxrpc_put_call(txb->call, rxrpc_call_put);
+		rxrpc_put_call(txb->call, rxrpc_call_put_send_ack);
 		rxrpc_put_txbuf(txb, rxrpc_txbuf_put_ack_tx);
 	}
 }
diff --git a/net/rxrpc/peer_event.c b/net/rxrpc/peer_event.c
index 5e97d321ac38..b28739d10927 100644
--- a/net/rxrpc/peer_event.c
+++ b/net/rxrpc/peer_event.c
@@ -238,7 +238,7 @@ static void rxrpc_distribute_error(struct rxrpc_peer *peer, int error,
 	struct rxrpc_call *call;
 
 	hlist_for_each_entry_rcu(call, &peer->error_targets, error_link) {
-		rxrpc_see_call(call);
+		rxrpc_see_call(call, rxrpc_call_see_distribute_error);
 		rxrpc_set_call_completion(call, compl, 0, -error);
 	}
 }
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index 134122f5961a..c84d2b620396 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -42,7 +42,7 @@ void rxrpc_notify_socket(struct rxrpc_call *call)
 		} else {
 			write_lock_bh(&rx->recvmsg_lock);
 			if (list_empty(&call->recvmsg_link)) {
-				rxrpc_get_call(call, rxrpc_call_got);
+				rxrpc_get_call(call, rxrpc_call_get_notify_socket);
 				list_add_tail(&call->recvmsg_link, &rx->recvmsg_q);
 			}
 			write_unlock_bh(&rx->recvmsg_lock);
@@ -451,7 +451,7 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	if (!(flags & MSG_PEEK))
 		list_del_init(&call->recvmsg_link);
 	else
-		rxrpc_get_call(call, rxrpc_call_got);
+		rxrpc_get_call(call, rxrpc_call_get_recvmsg);
 	write_unlock_bh(&rx->recvmsg_lock);
 
 	trace_rxrpc_recvmsg(call, rxrpc_recvmsg_dequeue, 0);
@@ -537,7 +537,7 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 
 error_unlock_call:
 	mutex_unlock(&call->user_mutex);
-	rxrpc_put_call(call, rxrpc_call_put);
+	rxrpc_put_call(call, rxrpc_call_put_recvmsg);
 	trace_rxrpc_recvmsg(call, rxrpc_recvmsg_return, ret);
 	return ret;
 
@@ -548,7 +548,7 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		write_unlock_bh(&rx->recvmsg_lock);
 		trace_rxrpc_recvmsg(call, rxrpc_recvmsg_requeue, 0);
 	} else {
-		rxrpc_put_call(call, rxrpc_call_put);
+		rxrpc_put_call(call, rxrpc_call_put_recvmsg);
 	}
 error_no_call:
 	release_sock(&rx->sk);
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index cfe0badba0b3..76b1e2e89c1e 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -667,7 +667,7 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
 		case RXRPC_CALL_CLIENT_AWAIT_CONN:
 		case RXRPC_CALL_SERVER_PREALLOC:
 		case RXRPC_CALL_SERVER_SECURING:
-			rxrpc_put_call(call, rxrpc_call_put);
+			rxrpc_put_call(call, rxrpc_call_put_sendmsg);
 			ret = -EBUSY;
 			goto error_release_sock;
 		default:
@@ -737,7 +737,7 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
 	if (!dropped_lock)
 		mutex_unlock(&call->user_mutex);
 error_put:
-	rxrpc_put_call(call, rxrpc_call_put);
+	rxrpc_put_call(call, rxrpc_call_put_sendmsg);
 	_leave(" = %d", ret);
 	return ret;
 


