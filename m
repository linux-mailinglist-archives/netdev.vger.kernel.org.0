Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4C3D63FCD7
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 01:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbiLBAWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 19:22:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbiLBAWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 19:22:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71824D3DEE
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 16:18:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669940314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3XSRH8Wh0iQeCxAKaZkvl0oeEpmt8lK6Mkyjy8nJbLw=;
        b=BTBb3W47yqOnSExvIwvliLPMbi2G0/YHtbFBzxGXmoUCb+SnBNLc/QPzYnPa5v5vow7SOn
        qlJtWLRHMMGNiGcMJvp4njJ6UADc6jhuvXFuJGLKDGCJOtqAQM3XNIizE3DJv+XCMrr76+
        0jkp1LDnmBdYtyqD7DrY97Ysyx1Lp9M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-_YckycuSOeGpnHHgmuBJhQ-1; Thu, 01 Dec 2022 19:18:31 -0500
X-MC-Unique: _YckycuSOeGpnHHgmuBJhQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3999894E81;
        Fri,  2 Dec 2022 00:18:30 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 028CF111E3F8;
        Fri,  2 Dec 2022 00:18:29 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 24/36] rxrpc: Implement a mechanism to send an event
 notification to a call
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Fri, 02 Dec 2022 00:18:27 +0000
Message-ID: <166994030714.1732290.8465757219913929523.stgit@warthog.procyon.org.uk>
In-Reply-To: <166994010342.1732290.13771061038178613124.stgit@warthog.procyon.org.uk>
References: <166994010342.1732290.13771061038178613124.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide a means by which an event notification can be sent to a call such
that the I/O thread can process it rather than it being done in a separate
workqueue.  This will allow a lot of locking to be removed.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |   52 ++++++++++++++++++++++++++++++++++++++++++
 net/rxrpc/ar-internal.h      |    5 +++-
 net/rxrpc/call_object.c      |   24 +++++++++++++++++++
 net/rxrpc/input.c            |    3 +-
 net/rxrpc/io_thread.c        |   20 +++++++++++++++-
 net/rxrpc/local_object.c     |    1 +
 6 files changed, 100 insertions(+), 5 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 44a9be9836f9..0b12d96c7921 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -16,6 +16,13 @@
 /*
  * Declare tracing information enums and their string mappings for display.
  */
+#define rxrpc_call_poke_traces \
+	EM(rxrpc_call_poke_error,		"Error")	\
+	EM(rxrpc_call_poke_idle,		"Idle")		\
+	EM(rxrpc_call_poke_start,		"Start")	\
+	EM(rxrpc_call_poke_timer,		"Timer")	\
+	E_(rxrpc_call_poke_timer_now,		"Timer-now")
+
 #define rxrpc_skb_traces \
 	EM(rxrpc_skb_eaten_by_unshare,		"ETN unshare  ") \
 	EM(rxrpc_skb_eaten_by_unshare_nomem,	"ETN unshar-nm") \
@@ -150,6 +157,7 @@
 	EM(rxrpc_call_get_input,		"GET input   ") \
 	EM(rxrpc_call_get_kernel_service,	"GET krnl-srv") \
 	EM(rxrpc_call_get_notify_socket,	"GET notify  ") \
+	EM(rxrpc_call_get_poke,			"GET poke    ") \
 	EM(rxrpc_call_get_recvmsg,		"GET recvmsg ") \
 	EM(rxrpc_call_get_release_sock,		"GET rel-sock") \
 	EM(rxrpc_call_get_sendmsg,		"GET sendmsg ") \
@@ -160,6 +168,7 @@
 	EM(rxrpc_call_put_discard_prealloc,	"PUT disc-pre") \
 	EM(rxrpc_call_put_input,		"PUT input   ") \
 	EM(rxrpc_call_put_kernel,		"PUT kernel  ") \
+	EM(rxrpc_call_put_poke,			"PUT poke    ") \
 	EM(rxrpc_call_put_recvmsg,		"PUT recvmsg ") \
 	EM(rxrpc_call_put_release_sock,		"PUT rls-sock") \
 	EM(rxrpc_call_put_release_sock_tba,	"PUT rls-sk-a") \
@@ -378,6 +387,7 @@
 #define E_(a, b) a
 
 enum rxrpc_bundle_trace		{ rxrpc_bundle_traces } __mode(byte);
+enum rxrpc_call_poke_trace	{ rxrpc_call_poke_traces } __mode(byte);
 enum rxrpc_call_trace		{ rxrpc_call_traces } __mode(byte);
 enum rxrpc_client_trace		{ rxrpc_client_traces } __mode(byte);
 enum rxrpc_congest_change	{ rxrpc_congest_changes } __mode(byte);
@@ -408,6 +418,7 @@ enum rxrpc_txqueue_trace	{ rxrpc_txqueue_traces } __mode(byte);
 #define E_(a, b) TRACE_DEFINE_ENUM(a);
 
 rxrpc_bundle_traces;
+rxrpc_call_poke_traces;
 rxrpc_call_traces;
 rxrpc_client_traces;
 rxrpc_congest_changes;
@@ -1747,6 +1758,47 @@ TRACE_EVENT(rxrpc_txbuf,
 		      __entry->ref)
 	    );
 
+TRACE_EVENT(rxrpc_poke_call,
+	    TP_PROTO(struct rxrpc_call *call, bool busy,
+		     enum rxrpc_call_poke_trace what),
+
+	    TP_ARGS(call, busy, what),
+
+	    TP_STRUCT__entry(
+		    __field(unsigned int,		call_debug_id	)
+		    __field(bool,			busy		)
+		    __field(enum rxrpc_call_poke_trace,	what		)
+			     ),
+
+	    TP_fast_assign(
+		    __entry->call_debug_id = call->debug_id;
+		    __entry->busy = busy;
+		    __entry->what = what;
+			   ),
+
+	    TP_printk("c=%08x %s%s",
+		      __entry->call_debug_id,
+		      __print_symbolic(__entry->what, rxrpc_call_poke_traces),
+		      __entry->busy ? "!" : "")
+	    );
+
+TRACE_EVENT(rxrpc_call_poked,
+	    TP_PROTO(struct rxrpc_call *call),
+
+	    TP_ARGS(call),
+
+	    TP_STRUCT__entry(
+		    __field(unsigned int,		call_debug_id	)
+			     ),
+
+	    TP_fast_assign(
+		    __entry->call_debug_id = call->debug_id;
+			   ),
+
+	    TP_printk("c=%08x",
+		      __entry->call_debug_id)
+	    );
+
 #undef EM
 #undef E_
 #endif /* _TRACE_RXRPC_H */
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 654e9dab107c..a80655fa9dfb 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -292,6 +292,7 @@ struct rxrpc_local {
 	struct sk_buff_head	reject_queue;	/* packets awaiting rejection */
 	struct sk_buff_head	event_queue;	/* endpoint event packets awaiting processing */
 	struct sk_buff_head	rx_queue;	/* Received packets */
+	struct list_head	call_attend_q;	/* Calls requiring immediate attention */
 	struct rb_root		client_bundles;	/* Client connection bundles by socket params */
 	spinlock_t		client_bundles_lock; /* Lock for client_bundles */
 	spinlock_t		lock;		/* access lock */
@@ -616,6 +617,7 @@ struct rxrpc_call {
 	struct list_head	recvmsg_link;	/* Link in rx->recvmsg_q */
 	struct list_head	sock_link;	/* Link in rx->sock_calls */
 	struct rb_node		sock_node;	/* Node in rx->calls */
+	struct list_head	attend_link;	/* Link in local->call_attend_q */
 	struct rxrpc_txbuf	*tx_pending;	/* Tx buffer being filled */
 	wait_queue_head_t	waitq;		/* Wait queue for channel or Tx */
 	s64			tx_total_len;	/* Total length left to be transmitted (or -1) */
@@ -843,6 +845,7 @@ extern const char *const rxrpc_call_states[];
 extern const char *const rxrpc_call_completions[];
 extern struct kmem_cache *rxrpc_call_jar;
 
+void rxrpc_poke_call(struct rxrpc_call *call, enum rxrpc_call_poke_trace what);
 struct rxrpc_call *rxrpc_find_call_by_user_ID(struct rxrpc_sock *, unsigned long);
 struct rxrpc_call *rxrpc_alloc_call(struct rxrpc_sock *, gfp_t, unsigned int);
 struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *,
@@ -951,7 +954,7 @@ void rxrpc_unpublish_service_conn(struct rxrpc_connection *);
 /*
  * input.c
  */
-void rxrpc_input_call_packet(struct rxrpc_call *, struct sk_buff *);
+void rxrpc_input_call_event(struct rxrpc_call *, struct sk_buff *);
 void rxrpc_input_implicit_end_call(struct rxrpc_sock *, struct rxrpc_connection *,
 				   struct rxrpc_call *);
 
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index f6d1b3a6f8c6..997641e3d1c8 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -45,6 +45,29 @@ static struct semaphore rxrpc_call_limiter =
 static struct semaphore rxrpc_kernel_call_limiter =
 	__SEMAPHORE_INITIALIZER(rxrpc_kernel_call_limiter, 1000);
 
+void rxrpc_poke_call(struct rxrpc_call *call, enum rxrpc_call_poke_trace what)
+{
+	struct rxrpc_local *local;
+	struct rxrpc_peer *peer = call->peer;
+	bool busy;
+
+	if (WARN_ON_ONCE(!peer))
+		return;
+	local = peer->local;
+
+	if (call->state < RXRPC_CALL_COMPLETE) {
+		spin_lock_bh(&local->lock);
+		busy = !list_empty(&call->attend_link);
+		trace_rxrpc_poke_call(call, busy, what);
+		if (!busy) {
+			rxrpc_get_call(call, rxrpc_call_get_poke);
+			list_add_tail(&call->attend_link, &local->call_attend_q);
+		}
+		spin_unlock_bh(&local->lock);
+		rxrpc_wake_up_io_thread(local);
+	}
+}
+
 static void rxrpc_call_timer_expired(struct timer_list *t)
 {
 	struct rxrpc_call *call = from_timer(call, t, timer);
@@ -137,6 +160,7 @@ struct rxrpc_call *rxrpc_alloc_call(struct rxrpc_sock *rx, gfp_t gfp,
 	INIT_LIST_HEAD(&call->accept_link);
 	INIT_LIST_HEAD(&call->recvmsg_link);
 	INIT_LIST_HEAD(&call->sock_link);
+	INIT_LIST_HEAD(&call->attend_link);
 	INIT_LIST_HEAD(&call->tx_buffer);
 	skb_queue_head_init(&call->recvmsg_queue);
 	skb_queue_head_init(&call->rx_oos_queue);
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 13c52145a926..036f02371051 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -1017,8 +1017,7 @@ static void rxrpc_input_abort(struct rxrpc_call *call, struct sk_buff *skb)
 /*
  * Process an incoming call packet.
  */
-void rxrpc_input_call_packet(struct rxrpc_call *call,
-				    struct sk_buff *skb)
+void rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	unsigned long timo;
diff --git a/net/rxrpc/io_thread.c b/net/rxrpc/io_thread.c
index 416c6101cf78..cc249bc6b8cd 100644
--- a/net/rxrpc/io_thread.c
+++ b/net/rxrpc/io_thread.c
@@ -366,7 +366,7 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff *skb)
 	/* Process a call packet; this either discards or passes on the ref
 	 * elsewhere.
 	 */
-	rxrpc_input_call_packet(call, skb);
+	rxrpc_input_call_event(call, skb);
 	goto out;
 
 discard:
@@ -413,6 +413,7 @@ int rxrpc_io_thread(void *data)
 {
 	struct sk_buff_head rx_queue;
 	struct rxrpc_local *local = data;
+	struct rxrpc_call *call;
 	struct sk_buff *skb;
 
 	skb_queue_head_init(&rx_queue);
@@ -422,6 +423,20 @@ int rxrpc_io_thread(void *data)
 	for (;;) {
 		rxrpc_inc_stat(local->rxnet, stat_io_loop);
 
+		/* Deal with calls that want immediate attention. */
+		if ((call = list_first_entry_or_null(&local->call_attend_q,
+						     struct rxrpc_call,
+						     attend_link))) {
+			spin_lock_bh(&local->lock);
+			list_del_init(&call->attend_link);
+			spin_unlock_bh(&local->lock);
+
+			trace_rxrpc_call_poked(call);
+			rxrpc_input_call_event(call, NULL);
+			rxrpc_put_call(call, rxrpc_call_put_poke);
+			continue;
+		}
+
 		/* Process received packets and errors. */
 		if ((skb = __skb_dequeue(&rx_queue))) {
 			switch (skb->mark) {
@@ -450,7 +465,8 @@ int rxrpc_io_thread(void *data)
 		}
 
 		set_current_state(TASK_INTERRUPTIBLE);
-		if (!skb_queue_empty(&local->rx_queue)) {
+		if (!skb_queue_empty(&local->rx_queue) ||
+		    !list_empty(&local->call_attend_q)) {
 			__set_current_state(TASK_RUNNING);
 			continue;
 		}
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 6b4d77219f36..03f491cc23ef 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -104,6 +104,7 @@ static struct rxrpc_local *rxrpc_alloc_local(struct rxrpc_net *rxnet,
 		skb_queue_head_init(&local->reject_queue);
 		skb_queue_head_init(&local->event_queue);
 		skb_queue_head_init(&local->rx_queue);
+		INIT_LIST_HEAD(&local->call_attend_q);
 		local->client_bundles = RB_ROOT;
 		spin_lock_init(&local->client_bundles_lock);
 		spin_lock_init(&local->lock);


