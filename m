Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E46DE63DB69
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 18:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbiK3RDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 12:03:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbiK3RCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 12:02:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBDC1837C8
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 08:58:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669827523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jha3RsWmlSpHzmxewi31DkMbpLfg+Nc4JE79oTAKtPk=;
        b=MPBQifd2WpEr8nLeAgxRg/9gFmrfYNMh4Syo2zhVytU//2LVtQWNeDyidDf2mrPRE45pJ0
        rgZHZI33D/eOU/nXpXruBMnQaqikhZmxRYnET6L6dty09NXtJ0Lc10pMOb0mPC5YIEyraK
        Jy6gaHHswE3cd64FjBLl53FlQSyKCFc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-ofV-rgLGPDe99dp06amS9w-1; Wed, 30 Nov 2022 11:58:41 -0500
X-MC-Unique: ofV-rgLGPDe99dp06amS9w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 237B0101A52A;
        Wed, 30 Nov 2022 16:58:41 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 14643492B04;
        Wed, 30 Nov 2022 16:58:39 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 30/35] rxrpc: Make the I/O thread take over the call
 and local processor work
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 30 Nov 2022 16:58:37 +0000
Message-ID: <166982751762.621383.5848583443739953259.stgit@warthog.procyon.org.uk>
In-Reply-To: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
References: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the functions from the call->processor and local->processor work items
into the domain of the I/O thread.

The call event processor, now called from the I/O thread, then takes over
the job of cranking the call state machine, processing incoming packets and
transmitting DATA, ACK and ABORT packets.  In a future patch,
rxrpc_send_ACK() will transmit the ACK on the spot rather than queuing it
for later transmission.

The call event processor becomes purely received-skb driven.  It only
transmits things in response to events.  We use "pokes" to queue a dummy
skb to make it do things like start/resume transmitting data.  Timer expiry
also results in pokes.

The connection event processor, becomes similar, though crypto events, such
as dealing with CHALLENGE and RESPONSE packets is offloaded to a work item
to avoid doing crypto in the I/O thread.

The local event processor is removed and VERSION response packets are
generated directly from the packet parser.  Similarly, ABORTs generated in
response to protocol errors will be transmitted immediately rather than
being pushed onto a queue for later transmission.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |   42 +++---
 net/rxrpc/ar-internal.h      |   50 +++----
 net/rxrpc/call_accept.c      |  126 ++++++++---------
 net/rxrpc/call_event.c       |  171 +++++++++--------------
 net/rxrpc/call_object.c      |   56 ++++---
 net/rxrpc/conn_event.c       |   60 ++++++++
 net/rxrpc/conn_object.c      |   93 +++++-------
 net/rxrpc/input.c            |  167 ++++++----------------
 net/rxrpc/io_thread.c        |  319 +++++++++++++++++++-----------------------
 net/rxrpc/local_event.c      |   43 ------
 net/rxrpc/local_object.c     |   69 ---------
 net/rxrpc/output.c           |   92 +++++-------
 net/rxrpc/peer_event.c       |   29 ++--
 net/rxrpc/recvmsg.c          |    9 -
 net/rxrpc/sendmsg.c          |   10 +
 15 files changed, 545 insertions(+), 791 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 82b1327c2ba6..c49b0c233594 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -26,7 +26,6 @@
 #define rxrpc_skb_traces \
 	EM(rxrpc_skb_eaten_by_unshare,		"ETN unshare  ") \
 	EM(rxrpc_skb_eaten_by_unshare_nomem,	"ETN unshar-nm") \
-	EM(rxrpc_skb_get_ack,			"GET ack      ") \
 	EM(rxrpc_skb_get_conn_work,		"GET conn-work") \
 	EM(rxrpc_skb_get_local_work,		"GET locl-work") \
 	EM(rxrpc_skb_get_reject_work,		"GET rej-work ") \
@@ -36,7 +35,6 @@
 	EM(rxrpc_skb_new_error_report,		"NEW error-rpt") \
 	EM(rxrpc_skb_new_jumbo_subpacket,	"NEW jumbo-sub") \
 	EM(rxrpc_skb_new_unshared,		"NEW unshared ") \
-	EM(rxrpc_skb_put_ack,			"PUT ack      ") \
 	EM(rxrpc_skb_put_conn_work,		"PUT conn-work") \
 	EM(rxrpc_skb_put_error_report,		"PUT error-rep") \
 	EM(rxrpc_skb_put_input,			"PUT input    ") \
@@ -45,7 +43,6 @@
 	EM(rxrpc_skb_put_rotate,		"PUT rotate   ") \
 	EM(rxrpc_skb_put_unknown,		"PUT unknown  ") \
 	EM(rxrpc_skb_see_conn_work,		"SEE conn-work") \
-	EM(rxrpc_skb_see_local_work,		"SEE locl-work") \
 	EM(rxrpc_skb_see_recvmsg,		"SEE recvmsg  ") \
 	EM(rxrpc_skb_see_reject,		"SEE reject   ") \
 	EM(rxrpc_skb_see_rotate,		"SEE rotate   ") \
@@ -58,10 +55,7 @@
 	EM(rxrpc_local_get_for_use,		"GET for-use ") \
 	EM(rxrpc_local_get_peer,		"GET peer    ") \
 	EM(rxrpc_local_get_prealloc_conn,	"GET conn-pre") \
-	EM(rxrpc_local_get_queue,		"GET queue   ") \
 	EM(rxrpc_local_new,			"NEW         ") \
-	EM(rxrpc_local_processing,		"PROCESSING  ") \
-	EM(rxrpc_local_put_already_queued,	"PUT alreadyq") \
 	EM(rxrpc_local_put_bind,		"PUT bind    ") \
 	EM(rxrpc_local_put_call,		"PUT call    ") \
 	EM(rxrpc_local_put_for_use,		"PUT for-use ") \
@@ -69,8 +63,6 @@
 	EM(rxrpc_local_put_peer,		"PUT peer    ") \
 	EM(rxrpc_local_put_prealloc_conn,	"PUT conn-pre") \
 	EM(rxrpc_local_put_release_sock,	"PUT rel-sock") \
-	EM(rxrpc_local_put_queue,		"PUT queue   ") \
-	EM(rxrpc_local_queued,			"QUEUED      ") \
 	EM(rxrpc_local_see_tx_ack,		"SEE tx-ack  ") \
 	EM(rxrpc_local_stop,			"STOP        ") \
 	EM(rxrpc_local_stopped,			"STOPPED     ") \
@@ -78,11 +70,9 @@
 	EM(rxrpc_local_unuse_conn_work,		"UNU conn-wrk") \
 	EM(rxrpc_local_unuse_peer_keepalive,	"UNU peer-kpa") \
 	EM(rxrpc_local_unuse_release_sock,	"UNU rel-sock") \
-	EM(rxrpc_local_unuse_work,		"UNU work    ") \
 	EM(rxrpc_local_use_conn_work,		"USE conn-wrk") \
 	EM(rxrpc_local_use_lookup,		"USE lookup  ") \
-	EM(rxrpc_local_use_peer_keepalive,	"USE peer-kpa") \
-	E_(rxrpc_local_use_work,		"USE work    ")
+	E_(rxrpc_local_use_peer_keepalive,	"USE peer-kpa")
 
 #define rxrpc_peer_traces \
 	EM(rxrpc_peer_free,			"FREE        ") \
@@ -90,6 +80,7 @@
 	EM(rxrpc_peer_get_activate_call,	"GET act-call") \
 	EM(rxrpc_peer_get_bundle,		"GET bundle  ") \
 	EM(rxrpc_peer_get_client_conn,		"GET cln-conn") \
+	EM(rxrpc_peer_get_input,		"GET input   ") \
 	EM(rxrpc_peer_get_input_error,		"GET inpt-err") \
 	EM(rxrpc_peer_get_keepalive,		"GET keepaliv") \
 	EM(rxrpc_peer_get_lookup_client,	"GET look-cln") \
@@ -100,6 +91,7 @@
 	EM(rxrpc_peer_put_call,			"PUT call    ") \
 	EM(rxrpc_peer_put_conn,			"PUT conn    ") \
 	EM(rxrpc_peer_put_discard_tmp,		"PUT disc-tmp") \
+	EM(rxrpc_peer_put_input,		"PUT input   ") \
 	EM(rxrpc_peer_put_input_error,		"PUT inpt-err") \
 	E_(rxrpc_peer_put_keepalive,		"PUT keepaliv")
 
@@ -180,11 +172,6 @@
 	EM(rxrpc_call_put_sendmsg,		"PUT sendmsg ") \
 	EM(rxrpc_call_put_unnotify,		"PUT unnotify") \
 	EM(rxrpc_call_put_userid_exists,	"PUT u-exists") \
-	EM(rxrpc_call_queue_abort,		"QUE abort   ") \
-	EM(rxrpc_call_queue_requeue,		"QUE requeue ") \
-	EM(rxrpc_call_queue_resend,		"QUE resend  ") \
-	EM(rxrpc_call_queue_timer,		"QUE timer   ") \
-	EM(rxrpc_call_queue_tx_data,		"QUE tx-data ") \
 	EM(rxrpc_call_see_accept,		"SEE accept  ") \
 	EM(rxrpc_call_see_activate_client,	"SEE act-clnt") \
 	EM(rxrpc_call_see_connect_failed,	"SEE con-fail") \
@@ -282,6 +269,7 @@
 	EM(rxrpc_propose_ack_respond_to_ping,	"Rsp2Png") \
 	EM(rxrpc_propose_ack_retry_tx,		"RetryTx") \
 	EM(rxrpc_propose_ack_rotate_rx,		"RxAck  ") \
+	EM(rxrpc_propose_ack_rx_idle,		"RxIdle ") \
 	E_(rxrpc_propose_ack_terminal_ack,	"ClTerm ")
 
 #define rxrpc_congest_modes \
@@ -1532,6 +1520,7 @@ TRACE_EVENT(rxrpc_connect_call,
 		    __field(unsigned long,		user_call_ID	)
 		    __field(u32,			cid		)
 		    __field(u32,			call_id		)
+		    __field_struct(struct sockaddr_rxrpc, srx		)
 			     ),
 
 	    TP_fast_assign(
@@ -1539,33 +1528,42 @@ TRACE_EVENT(rxrpc_connect_call,
 		    __entry->user_call_ID = call->user_call_ID;
 		    __entry->cid = call->cid;
 		    __entry->call_id = call->call_id;
+		    __entry->srx = call->dest_srx;
 			   ),
 
-	    TP_printk("c=%08x u=%p %08x:%08x",
+	    TP_printk("c=%08x u=%p %08x:%08x dst=%pISp",
 		      __entry->call,
 		      (void *)__entry->user_call_ID,
 		      __entry->cid,
-		      __entry->call_id)
+		      __entry->call_id,
+		      &__entry->srx.transport)
 	    );
 
 TRACE_EVENT(rxrpc_resend,
-	    TP_PROTO(struct rxrpc_call *call),
+	    TP_PROTO(struct rxrpc_call *call, struct sk_buff *ack),
 
-	    TP_ARGS(call),
+	    TP_ARGS(call, ack),
 
 	    TP_STRUCT__entry(
 		    __field(unsigned int,		call		)
 		    __field(rxrpc_seq_t,		seq		)
+		    __field(rxrpc_seq_t,		transmitted	)
+		    __field(rxrpc_serial_t,		ack_serial	)
 			     ),
 
 	    TP_fast_assign(
+		    struct rxrpc_skb_priv *sp = ack ? rxrpc_skb(ack) : NULL;
 		    __entry->call = call->debug_id;
 		    __entry->seq = call->acks_hard_ack;
+		    __entry->transmitted = call->tx_transmitted;
+		    __entry->ack_serial = sp ? sp->hdr.serial : 0;
 			   ),
 
-	    TP_printk("c=%08x q=%x",
+	    TP_printk("c=%08x r=%x q=%x tq=%x",
 		      __entry->call,
-		      __entry->seq)
+		      __entry->ack_serial,
+		      __entry->seq,
+		      __entry->transmitted)
 	    );
 
 TRACE_EVENT(rxrpc_rx_icmp,
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index c3c915a05627..6b993a3d4186 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -283,14 +283,11 @@ struct rxrpc_local {
 	struct rxrpc_net	*rxnet;		/* The network ns in which this resides */
 	struct hlist_node	link;
 	struct socket		*socket;	/* my UDP socket */
-	struct work_struct	processor;
 	struct task_struct	*io_thread;
 	struct list_head	ack_tx_queue;	/* List of ACKs that need sending */
 	spinlock_t		ack_tx_lock;	/* ACK list lock */
 	struct rxrpc_sock __rcu	*service;	/* Service(s) listening on this endpoint */
 	struct rw_semaphore	defrag_sem;	/* control re-enablement of IP DF bit */
-	struct sk_buff_head	reject_queue;	/* packets awaiting rejection */
-	struct sk_buff_head	event_queue;	/* endpoint event packets awaiting processing */
 	struct sk_buff_head	rx_queue;	/* Received packets */
 	struct list_head	call_attend_q;	/* Calls requiring immediate attention */
 	struct rb_root		client_bundles;	/* Client connection bundles by socket params */
@@ -524,23 +521,19 @@ enum rxrpc_call_flag {
 	RXRPC_CALL_RETRANS_TIMEOUT,	/* Retransmission due to timeout occurred */
 	RXRPC_CALL_BEGAN_RX_TIMER,	/* We began the expect_rx_by timer */
 	RXRPC_CALL_RX_HEARD,		/* The peer responded at least once to this call */
-	RXRPC_CALL_RX_UNDERRUN,		/* Got data underrun */
 	RXRPC_CALL_DISCONNECTED,	/* The call has been disconnected */
 	RXRPC_CALL_KERNEL,		/* The call was made by the kernel */
 	RXRPC_CALL_UPGRADE,		/* Service upgrade was requested for the call */
-	RXRPC_CALL_DELAY_ACK_PENDING,	/* DELAY ACK generation is pending */
-	RXRPC_CALL_IDLE_ACK_PENDING,	/* IDLE ACK generation is pending */
 	RXRPC_CALL_EXCLUSIVE,		/* The call uses a once-only connection */
+	RXRPC_CALL_RX_IS_IDLE,		/* Reception is idle - send an ACK */
 };
 
 /*
  * Events that can be raised on a call.
  */
 enum rxrpc_call_event {
-	RXRPC_CALL_EV_ABORT,		/* need to generate abort */
-	RXRPC_CALL_EV_RESEND,		/* Tx resend required */
-	RXRPC_CALL_EV_EXPIRED,		/* Expiry occurred */
 	RXRPC_CALL_EV_ACK_LOST,		/* ACK may be lost, send ping */
+	RXRPC_CALL_EV_INITIAL_PING,	/* Send initial ping for a new service call */
 };
 
 /*
@@ -611,7 +604,6 @@ struct rxrpc_call {
 	u32			next_rx_timo;	/* Timeout for next Rx packet (jif) */
 	u32			next_req_timo;	/* Timeout for next Rx request packet (jif) */
 	struct timer_list	timer;		/* Combined event timer */
-	struct work_struct	processor;	/* Event processor */
 	struct work_struct	destroyer;	/* In-process-context destroyer */
 	rxrpc_notify_rx_t	notify_rx;	/* kernel service Rx notification function */
 	struct list_head	link;		/* link in master call list */
@@ -705,11 +697,7 @@ struct rxrpc_call {
 	rxrpc_seq_t		acks_prev_seq;	/* Highest previousPacket received */
 	rxrpc_seq_t		acks_hard_ack;	/* Latest hard-ack point */
 	rxrpc_seq_t		acks_lowest_nak; /* Lowest NACK in the buffer (or ==tx_hard_ack) */
-	rxrpc_seq_t		acks_lost_top;	/* tx_top at the time lost-ack ping sent */
-	rxrpc_serial_t		acks_lost_ping;	/* Serial number of probe ACK */
 	rxrpc_serial_t		acks_highest_serial; /* Highest serial number ACK'd */
-	struct sk_buff		*acks_soft_tbl;	/* The last ACK packet with NAKs in it */
-	spinlock_t		acks_ack_lock;	/* Access to ->acks_last_ack */
 };
 
 /*
@@ -822,10 +810,9 @@ extern struct workqueue_struct *rxrpc_workqueue;
  */
 int rxrpc_service_prealloc(struct rxrpc_sock *, gfp_t);
 void rxrpc_discard_prealloc(struct rxrpc_sock *);
-struct rxrpc_call *rxrpc_new_incoming_call(struct rxrpc_local *,
-					   struct rxrpc_sock *,
-					   struct sockaddr_rxrpc *,
-					   struct sk_buff *);
+bool rxrpc_new_incoming_call(struct rxrpc_local *, struct rxrpc_peer *,
+			     struct rxrpc_connection *, struct sockaddr_rxrpc *,
+			     struct sk_buff *);
 void rxrpc_accept_incoming_calls(struct rxrpc_local *);
 int rxrpc_user_charge_accept(struct rxrpc_sock *, unsigned long);
 
@@ -838,13 +825,15 @@ void rxrpc_send_ACK(struct rxrpc_call *, u8, rxrpc_serial_t, enum rxrpc_propose_
 void rxrpc_propose_delay_ACK(struct rxrpc_call *, rxrpc_serial_t,
 			     enum rxrpc_propose_ack_trace);
 void rxrpc_shrink_call_tx_buffer(struct rxrpc_call *);
-void rxrpc_process_call(struct work_struct *);
+void rxrpc_resend(struct rxrpc_call *call, struct sk_buff *ack_skb);
 
 void rxrpc_reduce_call_timer(struct rxrpc_call *call,
 			     unsigned long expire_at,
 			     unsigned long now,
 			     enum rxrpc_timer_trace why);
 
+void rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb);
+
 /*
  * call_object.c
  */
@@ -864,9 +853,8 @@ void rxrpc_incoming_call(struct rxrpc_sock *, struct rxrpc_call *,
 			 struct sk_buff *);
 void rxrpc_release_call(struct rxrpc_sock *, struct rxrpc_call *);
 void rxrpc_release_calls_on_socket(struct rxrpc_sock *);
-void rxrpc_queue_call(struct rxrpc_call *, enum rxrpc_call_trace);
 void rxrpc_see_call(struct rxrpc_call *, enum rxrpc_call_trace);
-bool rxrpc_try_get_call(struct rxrpc_call *, enum rxrpc_call_trace);
+struct rxrpc_call *rxrpc_try_get_call(struct rxrpc_call *, enum rxrpc_call_trace);
 void rxrpc_get_call(struct rxrpc_call *, enum rxrpc_call_trace);
 void rxrpc_put_call(struct rxrpc_call *, enum rxrpc_call_trace);
 void rxrpc_cleanup_call(struct rxrpc_call *);
@@ -908,6 +896,7 @@ void rxrpc_clean_up_local_conns(struct rxrpc_local *);
  */
 void rxrpc_process_connection(struct work_struct *);
 void rxrpc_process_delayed_final_acks(struct rxrpc_connection *, bool);
+int rxrpc_input_conn_packet(struct rxrpc_connection *conn, struct sk_buff *skb);
 
 /*
  * conn_object.c
@@ -916,10 +905,9 @@ extern unsigned int rxrpc_connection_expiry;
 extern unsigned int rxrpc_closed_conn_expiry;
 
 struct rxrpc_connection *rxrpc_alloc_connection(struct rxrpc_net *, gfp_t);
-struct rxrpc_connection *rxrpc_find_connection_rcu(struct rxrpc_local *,
-						   struct sockaddr_rxrpc *,
-						   struct sk_buff *,
-						   struct rxrpc_peer **);
+struct rxrpc_connection *rxrpc_find_client_connection_rcu(struct rxrpc_local *,
+							  struct sockaddr_rxrpc *,
+							  struct sk_buff *);
 void __rxrpc_disconnect_call(struct rxrpc_connection *, struct rxrpc_call *);
 void rxrpc_disconnect_call(struct rxrpc_call *);
 void rxrpc_kill_client_conn(struct rxrpc_connection *);
@@ -962,8 +950,8 @@ void rxrpc_unpublish_service_conn(struct rxrpc_connection *);
 /*
  * input.c
  */
-void rxrpc_input_call_event(struct rxrpc_call *, struct sk_buff *);
-void rxrpc_input_implicit_end_call(struct rxrpc_connection *, struct rxrpc_call *);
+void rxrpc_input_call_packet(struct rxrpc_call *, struct sk_buff *);
+void rxrpc_implicit_end_call(struct rxrpc_call *, struct sk_buff *);
 
 /*
  * io_thread.c
@@ -993,7 +981,9 @@ int rxrpc_get_server_data_key(struct rxrpc_connection *, const void *, time64_t,
 /*
  * local_event.c
  */
-extern void rxrpc_process_local_events(struct rxrpc_local *);
+void rxrpc_send_version_request(struct rxrpc_local *local,
+				struct rxrpc_host_header *hdr,
+				struct sk_buff *skb);
 
 /*
  * local_object.c
@@ -1004,7 +994,6 @@ struct rxrpc_local *rxrpc_get_local_maybe(struct rxrpc_local *, enum rxrpc_local
 void rxrpc_put_local(struct rxrpc_local *, enum rxrpc_local_trace);
 struct rxrpc_local *rxrpc_use_local(struct rxrpc_local *, enum rxrpc_local_trace);
 void rxrpc_unuse_local(struct rxrpc_local *, enum rxrpc_local_trace);
-void rxrpc_queue_local(struct rxrpc_local *);
 void rxrpc_destroy_local(struct rxrpc_local *local);
 void rxrpc_destroy_all_locals(struct rxrpc_net *);
 
@@ -1068,7 +1057,7 @@ static inline struct rxrpc_net *rxrpc_net(struct net *net)
 void rxrpc_transmit_ack_packets(struct rxrpc_local *);
 int rxrpc_send_abort_packet(struct rxrpc_call *);
 int rxrpc_send_data_packet(struct rxrpc_call *, struct rxrpc_txbuf *);
-void rxrpc_reject_packets(struct rxrpc_local *);
+void rxrpc_reject_packet(struct rxrpc_local *local, struct sk_buff *skb);
 void rxrpc_send_keepalive(struct rxrpc_peer *);
 void rxrpc_transmit_one(struct rxrpc_call *call, struct rxrpc_txbuf *txb);
 
@@ -1178,7 +1167,6 @@ int rxrpc_server_keyring(struct rxrpc_sock *, sockptr_t, int);
  * skbuff.c
  */
 void rxrpc_kernel_data_consumed(struct rxrpc_call *, struct sk_buff *);
-void rxrpc_packet_destructor(struct sk_buff *);
 void rxrpc_new_skb(struct sk_buff *, enum rxrpc_skb_trace);
 void rxrpc_see_skb(struct sk_buff *, enum rxrpc_skb_trace);
 void rxrpc_eaten_skb(struct sk_buff *, enum rxrpc_skb_trace);
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index 11134b7cec17..86a4187fb2fb 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -100,6 +100,7 @@ static int rxrpc_service_prealloc_one(struct rxrpc_sock *rx,
 		return -ENOMEM;
 	call->flags |= (1 << RXRPC_CALL_IS_SERVICE);
 	call->state = RXRPC_CALL_SERVER_PREALLOC;
+	__set_bit(RXRPC_CALL_EV_INITIAL_PING, &call->events);
 
 	trace_rxrpc_call(call->debug_id, refcount_read(&call->ref),
 			 user_call_ID, rxrpc_call_new_prealloc_service);
@@ -234,21 +235,6 @@ void rxrpc_discard_prealloc(struct rxrpc_sock *rx)
 	kfree(b);
 }
 
-/*
- * Ping the other end to fill our RTT cache and to retrieve the rwind
- * and MTU parameters.
- */
-static void rxrpc_send_ping(struct rxrpc_call *call, struct sk_buff *skb)
-{
-	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
-	ktime_t now = skb->tstamp;
-
-	if (call->peer->rtt_count < 3 ||
-	    ktime_before(ktime_add_ms(call->peer->rtt_last_req, 1000), now))
-		rxrpc_send_ACK(call, RXRPC_ACK_PING, sp->hdr.serial,
-			       rxrpc_propose_ack_ping_for_params);
-}
-
 /*
  * Allocate a new incoming call from the prealloc pool, along with a connection
  * and a peer as necessary.
@@ -330,33 +316,56 @@ static struct rxrpc_call *rxrpc_alloc_incoming_call(struct rxrpc_sock *rx,
 }
 
 /*
- * Set up a new incoming call.  Called in BH context with the RCU read lock
- * held.
+ * Set up a new incoming call.  Called from the I/O thread.
  *
  * If this is for a kernel service, when we allocate the call, it will have
  * three refs on it: (1) the kernel service, (2) the user_call_ID tree, (3) the
  * retainer ref obtained from the backlog buffer.  Prealloc calls for userspace
- * services only have the ref from the backlog buffer.  We pass this ref to the
- * caller.
+ * services only have the ref from the backlog buffer.
  *
  * If we want to report an error, we mark the skb with the packet type and
- * abort code and return NULL.
- *
- * The call is returned with the user access mutex held and a ref on it.
+ * abort code and return false.
  */
-struct rxrpc_call *rxrpc_new_incoming_call(struct rxrpc_local *local,
-					   struct rxrpc_sock *rx,
-					   struct sockaddr_rxrpc *peer_srx,
-					   struct sk_buff *skb)
+bool rxrpc_new_incoming_call(struct rxrpc_local *local,
+			     struct rxrpc_peer *peer,
+			     struct rxrpc_connection *conn,
+			     struct sockaddr_rxrpc *peer_srx,
+			     struct sk_buff *skb)
 {
-	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	const struct rxrpc_security *sec = NULL;
-	struct rxrpc_connection *conn;
-	struct rxrpc_peer *peer = NULL;
+	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	struct rxrpc_call *call = NULL;
+	struct rxrpc_sock *rx;
 
 	_enter("");
 
+	/* Don't set up a call for anything other than the first DATA packet. */
+	if (sp->hdr.seq != 1 ||
+	    sp->hdr.type != RXRPC_PACKET_TYPE_DATA)
+		return 0;
+
+	rcu_read_lock();
+
+	/* Weed out packets to services we're not offering.  Packets that would
+	 * begin a call are explicitly rejected and the rest are just
+	 * discarded.
+	 */
+	rx = rcu_dereference(local->service);
+	if (!rx || (sp->hdr.serviceId != rx->srx.srx_service &&
+		    sp->hdr.serviceId != rx->second_service)
+	    ) {
+		if (sp->hdr.type == RXRPC_PACKET_TYPE_DATA &&
+		    sp->hdr.seq == 1)
+			goto unsupported_service;
+		goto discard;
+	}
+
+	if (!conn) {
+		sec = rxrpc_get_incoming_security(rx, skb);
+		if (!sec)
+			goto no_call;
+	}
+
 	spin_lock(&rx->incoming_lock);
 	if (rx->sk.sk_state == RXRPC_SERVER_LISTEN_DISABLED ||
 	    rx->sk.sk_state == RXRPC_CLOSE) {
@@ -367,19 +376,6 @@ struct rxrpc_call *rxrpc_new_incoming_call(struct rxrpc_local *local,
 		goto no_call;
 	}
 
-	/* The peer, connection and call may all have sprung into existence due
-	 * to a duplicate packet being handled on another CPU in parallel, so
-	 * we have to recheck the routing.  However, we're now holding
-	 * rx->incoming_lock, so the values should remain stable.
-	 */
-	conn = rxrpc_find_connection_rcu(local, peer_srx, skb, &peer);
-
-	if (!conn) {
-		sec = rxrpc_get_incoming_security(rx, skb);
-		if (!sec)
-			goto no_call;
-	}
-
 	call = rxrpc_alloc_incoming_call(rx, local, peer, conn, sec, peer_srx,
 					 skb);
 	if (!call) {
@@ -398,35 +394,15 @@ struct rxrpc_call *rxrpc_new_incoming_call(struct rxrpc_local *local,
 		rx->notify_new_call(&rx->sk, call, call->user_call_ID);
 
 	spin_lock(&conn->state_lock);
-	switch (conn->state) {
-	case RXRPC_CONN_SERVICE_UNSECURED:
+	if (conn->state == RXRPC_CONN_SERVICE_UNSECURED) {
 		conn->state = RXRPC_CONN_SERVICE_CHALLENGING;
 		set_bit(RXRPC_CONN_EV_CHALLENGE, &call->conn->events);
 		rxrpc_queue_conn(call->conn, rxrpc_conn_queue_challenge);
-		break;
-
-	case RXRPC_CONN_SERVICE:
-		write_lock(&call->state_lock);
-		if (call->state < RXRPC_CALL_COMPLETE)
-			call->state = RXRPC_CALL_SERVER_RECV_REQUEST;
-		write_unlock(&call->state_lock);
-		break;
-
-	case RXRPC_CONN_REMOTELY_ABORTED:
-		rxrpc_set_call_completion(call, RXRPC_CALL_REMOTELY_ABORTED,
-					  conn->abort_code, conn->error);
-		break;
-	case RXRPC_CONN_LOCALLY_ABORTED:
-		rxrpc_abort_call("CON", call, sp->hdr.seq,
-				 conn->abort_code, conn->error);
-		break;
-	default:
-		BUG();
 	}
 	spin_unlock(&conn->state_lock);
-	spin_unlock(&rx->incoming_lock);
 
-	rxrpc_send_ping(call, skb);
+	spin_unlock(&rx->incoming_lock);
+	rcu_read_unlock();
 
 	if (hlist_unhashed(&call->error_link)) {
 		spin_lock(&call->peer->lock);
@@ -435,12 +411,24 @@ struct rxrpc_call *rxrpc_new_incoming_call(struct rxrpc_local *local,
 	}
 
 	_leave(" = %p{%d}", call, call->debug_id);
-	return call;
-
+	rxrpc_input_call_event(call, skb);
+	rxrpc_put_call(call, rxrpc_call_put_input);
+	return true;
+
+unsupported_service:
+	trace_rxrpc_abort(0, "INV", sp->hdr.cid, sp->hdr.callNumber, sp->hdr.seq,
+			  RX_INVALID_OPERATION, EOPNOTSUPP);
+	skb->priority = RX_INVALID_OPERATION;
+	goto reject;
 no_call:
 	spin_unlock(&rx->incoming_lock);
-	_leave(" = NULL [%u]", skb->mark);
-	return NULL;
+reject:
+	rcu_read_unlock();
+	_leave(" = f [%u]", skb->mark);
+	return false;
+discard:
+	rcu_read_lock();
+	return true;
 }
 
 /*
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index c9f835292f7b..9db62fa55c62 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -74,11 +74,6 @@ void rxrpc_send_ACK(struct rxrpc_call *call, u8 ack_reason,
 
 	if (test_bit(RXRPC_CALL_DISCONNECTED, &call->flags))
 		return;
-	if (ack_reason == RXRPC_ACK_DELAY &&
-	    test_and_set_bit(RXRPC_CALL_DELAY_ACK_PENDING, &call->flags)) {
-		trace_rxrpc_drop_ack(call, why, ack_reason, serial, false);
-		return;
-	}
 
 	rxrpc_inc_stat(call->rxnet, stat_tx_acks[ack_reason]);
 
@@ -111,12 +106,7 @@ void rxrpc_send_ACK(struct rxrpc_call *call, u8 ack_reason,
 	spin_unlock_bh(&local->ack_tx_lock);
 	trace_rxrpc_send_ack(call, why, ack_reason, serial);
 
-	if (!rcu_read_lock_held()) {
-		rxrpc_transmit_ack_packets(call->peer->local);
-	} else {
-		rxrpc_get_local(local, rxrpc_local_get_queue);
-		rxrpc_queue_local(local);
-	}
+	rxrpc_wake_up_io_thread(local);
 }
 
 /*
@@ -130,11 +120,10 @@ static void rxrpc_congestion_timeout(struct rxrpc_call *call)
 /*
  * Perform retransmission of NAK'd and unack'd packets.
  */
-static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
+void rxrpc_resend(struct rxrpc_call *call, struct sk_buff *ack_skb)
 {
 	struct rxrpc_ackpacket *ack = NULL;
 	struct rxrpc_txbuf *txb;
-	struct sk_buff *ack_skb = NULL;
 	unsigned long resend_at;
 	rxrpc_seq_t transmitted = READ_ONCE(call->tx_transmitted);
 	ktime_t now, max_age, oldest, ack_ts;
@@ -148,32 +137,21 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 	max_age = ktime_sub_us(now, jiffies_to_usecs(call->peer->rto_j));
 	oldest = now;
 
-	/* See if there's an ACK saved with a soft-ACK table in it. */
-	if (call->acks_soft_tbl) {
-		spin_lock_bh(&call->acks_ack_lock);
-		ack_skb = call->acks_soft_tbl;
-		if (ack_skb) {
-			rxrpc_get_skb(ack_skb, rxrpc_skb_get_ack);
-			ack = (void *)ack_skb->data + sizeof(struct rxrpc_wire_header);
-		}
-		spin_unlock_bh(&call->acks_ack_lock);
-	}
-
 	if (list_empty(&call->tx_buffer))
 		goto no_resend;
 
-	spin_lock(&call->tx_lock);
-
 	if (list_empty(&call->tx_buffer))
 		goto no_further_resend;
 
-	trace_rxrpc_resend(call);
+	trace_rxrpc_resend(call, ack_skb);
 	txb = list_first_entry(&call->tx_buffer, struct rxrpc_txbuf, call_link);
 
 	/* Scan the soft ACK table without dropping the lock and resend any
 	 * explicitly NAK'd packets.
 	 */
-	if (ack) {
+	if (ack_skb) {
+		ack = (void *)ack_skb->data + sizeof(struct rxrpc_wire_header);
+
 		for (i = 0; i < ack->nAcks; i++) {
 			rxrpc_seq_t seq;
 
@@ -197,7 +175,6 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 			rxrpc_see_txbuf(txb, rxrpc_txbuf_see_unacked);
 
 			if (list_empty(&txb->tx_link)) {
-				rxrpc_get_txbuf(txb, rxrpc_txbuf_get_retrans);
 				list_add_tail(&txb->tx_link, &retrans_queue);
 				set_bit(RXRPC_TXBUF_RESENT, &txb->flags);
 			}
@@ -241,7 +218,6 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 	do_resend:
 		unacked = true;
 		if (list_empty(&txb->tx_link)) {
-			rxrpc_get_txbuf(txb, rxrpc_txbuf_get_retrans);
 			list_add_tail(&txb->tx_link, &retrans_queue);
 			set_bit(RXRPC_TXBUF_RESENT, &txb->flags);
 			rxrpc_inc_stat(call->rxnet, stat_tx_data_retrans);
@@ -249,10 +225,7 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 	}
 
 no_further_resend:
-	spin_unlock(&call->tx_lock);
 no_resend:
-	rxrpc_free_skb(ack_skb, rxrpc_skb_put_ack);
-
 	resend_at = nsecs_to_jiffies(ktime_to_ns(ktime_sub(now, oldest)));
 	resend_at += jiffies + rxrpc_get_rto_backoff(call->peer,
 						     !list_empty(&retrans_queue));
@@ -266,7 +239,7 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 	 * retransmitting data.
 	 */
 	if (list_empty(&retrans_queue)) {
-		rxrpc_reduce_call_timer(call, resend_at, now_j,
+		rxrpc_reduce_call_timer(call, resend_at, jiffies,
 					rxrpc_timer_set_for_resend);
 		ack_ts = ktime_sub(now, call->acks_latest_ts);
 		if (ktime_to_us(ack_ts) < (call->peer->srtt_us >> 3))
@@ -276,15 +249,11 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 		goto out;
 	}
 
+	/* Retransmit the queue */
 	while ((txb = list_first_entry_or_null(&retrans_queue,
 					       struct rxrpc_txbuf, tx_link))) {
 		list_del_init(&txb->tx_link);
-		rxrpc_send_data_packet(call, txb);
-		rxrpc_put_txbuf(txb, rxrpc_txbuf_put_trans);
-
-		trace_rxrpc_retransmit(call, txb->seq,
-				       ktime_to_ns(ktime_sub(txb->last_sent,
-							     max_age)));
+		rxrpc_transmit_one(call, txb);
 	}
 
 out:
@@ -357,16 +326,27 @@ static void rxrpc_transmit_some_data(struct rxrpc_call *call)
 	}
 }
 
+/*
+ * Ping the other end to fill our RTT cache and to retrieve the rwind
+ * and MTU parameters.
+ */
+static void rxrpc_send_initial_ping(struct rxrpc_call *call)
+{
+	if (call->peer->rtt_count < 3 ||
+	    ktime_before(ktime_add_ms(call->peer->rtt_last_req, 1000),
+			 ktime_get_real()))
+		rxrpc_send_ACK(call, RXRPC_ACK_PING, 0,
+			       rxrpc_propose_ack_ping_for_params);
+}
+
 /*
  * Handle retransmission and deferred ACK/abort generation.
  */
-void rxrpc_process_call(struct work_struct *work)
+void rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb)
 {
-	struct rxrpc_call *call =
-		container_of(work, struct rxrpc_call, processor);
 	unsigned long now, next, t;
-	unsigned int iterations = 0;
 	rxrpc_serial_t ackr_serial;
+	bool resend = false, expired = false;
 
 	rxrpc_see_call(call, rxrpc_call_see_input);
 
@@ -374,47 +354,31 @@ void rxrpc_process_call(struct work_struct *work)
 	_enter("{%d,%s,%lx}",
 	       call->debug_id, rxrpc_call_states[call->state], call->events);
 
-recheck_state:
-	if (call->acks_hard_ack != call->tx_bottom)
-		rxrpc_shrink_call_tx_buffer(call);
-
-	/* Limit the number of times we do this before returning to the manager */
-	if (!rxrpc_tx_window_has_space(call) ||
-	    list_empty(&call->tx_sendmsg)) {
-		iterations++;
-		if (iterations > 5)
-			goto requeue;
-	}
-
-	if (test_and_clear_bit(RXRPC_CALL_EV_ABORT, &call->events)) {
-		rxrpc_send_abort_packet(call);
-		goto recheck_state;
-	}
+	if (call->state == RXRPC_CALL_COMPLETE)
+		goto out;
 
-	if (call->state == RXRPC_CALL_COMPLETE) {
-		del_timer_sync(&call->timer);
+	if (skb && skb->mark == RXRPC_SKB_MARK_ERROR)
 		goto out;
-	}
 
-	/* Work out if any timeouts tripped */
+	/* If we see our async-event poke, check for timeout trippage. */
 	now = jiffies;
 	t = READ_ONCE(call->expect_rx_by);
 	if (time_after_eq(now, t)) {
 		trace_rxrpc_timer(call, rxrpc_timer_exp_normal, now);
-		set_bit(RXRPC_CALL_EV_EXPIRED, &call->events);
+		expired = true;
 	}
 
 	t = READ_ONCE(call->expect_req_by);
 	if (call->state == RXRPC_CALL_SERVER_RECV_REQUEST &&
 	    time_after_eq(now, t)) {
 		trace_rxrpc_timer(call, rxrpc_timer_exp_idle, now);
-		set_bit(RXRPC_CALL_EV_EXPIRED, &call->events);
+		expired = true;
 	}
 
 	t = READ_ONCE(call->expect_term_by);
 	if (time_after_eq(now, t)) {
 		trace_rxrpc_timer(call, rxrpc_timer_exp_hard, now);
-		set_bit(RXRPC_CALL_EV_EXPIRED, &call->events);
+		expired = true;
 	}
 
 	t = READ_ONCE(call->delay_ack_at);
@@ -453,13 +417,19 @@ void rxrpc_process_call(struct work_struct *work)
 	if (time_after_eq(now, t)) {
 		trace_rxrpc_timer(call, rxrpc_timer_exp_resend, now);
 		cmpxchg(&call->resend_at, t, now + MAX_JIFFY_OFFSET);
-		set_bit(RXRPC_CALL_EV_RESEND, &call->events);
+		resend = true;
 	}
 
+	if (skb)
+		rxrpc_input_call_packet(call, skb);
+
 	rxrpc_transmit_some_data(call);
 
+	if (test_and_clear_bit(RXRPC_CALL_EV_INITIAL_PING, &call->events))
+		rxrpc_send_initial_ping(call);
+
 	/* Process events */
-	if (test_and_clear_bit(RXRPC_CALL_EV_EXPIRED, &call->events)) {
+	if (expired) {
 		if (test_bit(RXRPC_CALL_RX_HEARD, &call->flags) &&
 		    (int)call->conn->hi_serial - (int)call->rx_serial > 0) {
 			trace_rxrpc_call_reset(call);
@@ -467,51 +437,50 @@ void rxrpc_process_call(struct work_struct *work)
 		} else {
 			rxrpc_abort_call("EXP", call, 0, RX_CALL_TIMEOUT, -ETIME);
 		}
-		set_bit(RXRPC_CALL_EV_ABORT, &call->events);
-		goto recheck_state;
+		rxrpc_send_abort_packet(call);
+		goto out;
 	}
 
-	if (test_and_clear_bit(RXRPC_CALL_EV_ACK_LOST, &call->events)) {
-		call->acks_lost_top = call->tx_top;
+	if (test_and_clear_bit(RXRPC_CALL_EV_ACK_LOST, &call->events))
 		rxrpc_send_ACK(call, RXRPC_ACK_PING, 0,
 			       rxrpc_propose_ack_ping_for_lost_ack);
-	}
 
-	if (test_and_clear_bit(RXRPC_CALL_EV_RESEND, &call->events) &&
-	    call->state != RXRPC_CALL_CLIENT_RECV_REPLY) {
-		rxrpc_resend(call, now);
-		goto recheck_state;
-	}
+	if (resend && call->state != RXRPC_CALL_CLIENT_RECV_REPLY)
+		rxrpc_resend(call, NULL);
+
+	if (test_and_clear_bit(RXRPC_CALL_RX_IS_IDLE, &call->flags))
+		rxrpc_send_ACK(call, RXRPC_ACK_IDLE, 0,
+			       rxrpc_propose_ack_rx_idle);
+
+	if (atomic_read(&call->ackr_nr_unacked) > 2)
+		rxrpc_send_ACK(call, RXRPC_ACK_IDLE, 0,
+			       rxrpc_propose_ack_input_data);
 
 	/* Make sure the timer is restarted */
-	next = call->expect_rx_by;
+	if (call->state != RXRPC_CALL_COMPLETE) {
+		next = call->expect_rx_by;
 
 #define set(T) { t = READ_ONCE(T); if (time_before(t, next)) next = t; }
 
-	set(call->expect_req_by);
-	set(call->expect_term_by);
-	set(call->delay_ack_at);
-	set(call->ack_lost_at);
-	set(call->resend_at);
-	set(call->keepalive_at);
-	set(call->ping_at);
-
-	now = jiffies;
-	if (time_after_eq(now, next))
-		goto recheck_state;
+		set(call->expect_req_by);
+		set(call->expect_term_by);
+		set(call->delay_ack_at);
+		set(call->ack_lost_at);
+		set(call->resend_at);
+		set(call->keepalive_at);
+		set(call->ping_at);
 
-	rxrpc_reduce_call_timer(call, next, now, rxrpc_timer_restart);
+		now = jiffies;
+		if (time_after_eq(now, next))
+			rxrpc_poke_call(call, rxrpc_call_poke_timer_now);
 
-	/* other events may have been raised since we started checking */
-	if (call->events)
-		goto requeue;
+		rxrpc_reduce_call_timer(call, next, now, rxrpc_timer_restart);
+	}
 
 out:
+	if (call->state == RXRPC_CALL_COMPLETE)
+		del_timer_sync(&call->timer);
+	if (call->acks_hard_ack != call->tx_bottom)
+		rxrpc_shrink_call_tx_buffer(call);
 	_leave("");
-	return;
-
-requeue:
-	if (call->state < RXRPC_CALL_COMPLETE)
-		rxrpc_queue_call(call, rxrpc_call_queue_requeue);
-	goto out;
 }
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 7570b4e67bc5..d441a715d988 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -71,7 +71,7 @@ static void rxrpc_call_timer_expired(struct timer_list *t)
 
 	if (call->state < RXRPC_CALL_COMPLETE) {
 		trace_rxrpc_timer_expired(call, jiffies);
-		rxrpc_queue_call(call, rxrpc_call_queue_timer);
+		rxrpc_poke_call(call, rxrpc_call_poke_timer);
 	}
 }
 
@@ -148,7 +148,6 @@ struct rxrpc_call *rxrpc_alloc_call(struct rxrpc_sock *rx, gfp_t gfp,
 				  &rxrpc_call_user_mutex_lock_class_key);
 
 	timer_setup(&call->timer, rxrpc_call_timer_expired, 0);
-	INIT_WORK(&call->processor, rxrpc_process_call);
 	INIT_WORK(&call->destroyer, rxrpc_destroy_call);
 	INIT_LIST_HEAD(&call->link);
 	INIT_LIST_HEAD(&call->chan_wait_link);
@@ -163,7 +162,6 @@ struct rxrpc_call *rxrpc_alloc_call(struct rxrpc_sock *rx, gfp_t gfp,
 	init_waitqueue_head(&call->waitq);
 	spin_lock_init(&call->notify_lock);
 	spin_lock_init(&call->tx_lock);
-	spin_lock_init(&call->acks_ack_lock);
 	rwlock_init(&call->state_lock);
 	refcount_set(&call->ref, 1);
 	call->debug_id = debug_id;
@@ -252,6 +250,7 @@ static void rxrpc_start_call_timer(struct rxrpc_call *call)
 	call->ack_lost_at = j;
 	call->resend_at = j;
 	call->ping_at = j;
+	call->keepalive_at = j;
 	call->expect_rx_by = j;
 	call->expect_req_by = j;
 	call->expect_term_by = j;
@@ -430,6 +429,29 @@ void rxrpc_incoming_call(struct rxrpc_sock *rx,
 	call->state		= RXRPC_CALL_SERVER_SECURING;
 	call->cong_tstamp	= skb->tstamp;
 
+	spin_lock(&conn->state_lock);
+
+	switch (conn->state) {
+	case RXRPC_CONN_SERVICE_UNSECURED:
+	case RXRPC_CONN_SERVICE_CHALLENGING:
+		call->state = RXRPC_CALL_SERVER_SECURING;
+		break;
+	case RXRPC_CONN_SERVICE:
+		call->state = RXRPC_CALL_SERVER_RECV_REQUEST;
+		break;
+
+	case RXRPC_CONN_REMOTELY_ABORTED:
+		__rxrpc_set_call_completion(call, RXRPC_CALL_REMOTELY_ABORTED,
+					    conn->abort_code, conn->error);
+		break;
+	case RXRPC_CONN_LOCALLY_ABORTED:
+		__rxrpc_abort_call("CON", call, 1,
+				   conn->abort_code, conn->error);
+		break;
+	default:
+		BUG();
+	}
+
 	/* Set the channel for this call.  We don't get channel_lock as we're
 	 * only defending against the data_ready handler (which we're called
 	 * from) and the RESPONSE packet parser (which is only really
@@ -440,6 +462,7 @@ void rxrpc_incoming_call(struct rxrpc_sock *rx,
 	conn->channels[chan].call_counter = call->call_id;
 	conn->channels[chan].call_id = call->call_id;
 	rcu_assign_pointer(conn->channels[chan].call, call);
+	spin_unlock(&conn->state_lock);
 
 	spin_lock(&conn->peer->lock);
 	hlist_add_head(&call->error_link, &conn->peer->error_targets);
@@ -449,15 +472,6 @@ void rxrpc_incoming_call(struct rxrpc_sock *rx,
 	_leave("");
 }
 
-/*
- * Queue a call's work processor.
- */
-void rxrpc_queue_call(struct rxrpc_call *call, enum rxrpc_call_trace why)
-{
-	if (rxrpc_queue_work(&call->processor))
-		trace_rxrpc_call(call->debug_id, refcount_read(&call->ref), 0, why);
-}
-
 /*
  * Note the re-emergence of a call.
  */
@@ -470,14 +484,15 @@ void rxrpc_see_call(struct rxrpc_call *call, enum rxrpc_call_trace why)
 	}
 }
 
-bool rxrpc_try_get_call(struct rxrpc_call *call, enum rxrpc_call_trace why)
+struct rxrpc_call *rxrpc_try_get_call(struct rxrpc_call *call,
+				      enum rxrpc_call_trace why)
 {
 	int r;
 
-	if (!__refcount_inc_not_zero(&call->ref, &r))
-		return false;
+	if (!call || !__refcount_inc_not_zero(&call->ref, &r))
+		return NULL;
 	trace_rxrpc_call(call->debug_id, r + 1, 0, why);
-	return true;
+	return call;
 }
 
 /*
@@ -637,8 +652,6 @@ static void rxrpc_destroy_call(struct work_struct *work)
 	struct rxrpc_call *call = container_of(work, struct rxrpc_call, destroyer);
 	struct rxrpc_txbuf *txb;
 
-	del_timer_sync(&call->timer);
-	cancel_work_sync(&call->processor); /* The processor may restart the timer */
 	del_timer_sync(&call->timer);
 
 	rxrpc_cleanup_ring(call);
@@ -652,8 +665,8 @@ static void rxrpc_destroy_call(struct work_struct *work)
 		list_del(&txb->call_link);
 		rxrpc_put_txbuf(txb, rxrpc_txbuf_put_cleaned);
 	}
+
 	rxrpc_put_txbuf(call->tx_pending, rxrpc_txbuf_put_cleaned);
-	rxrpc_free_skb(call->acks_soft_tbl, rxrpc_skb_put_ack);
 	rxrpc_put_connection(call->conn, rxrpc_conn_put_call);
 	rxrpc_put_peer(call->peer, rxrpc_peer_put_call);
 	rxrpc_put_local(call->local, rxrpc_local_put_call);
@@ -670,10 +683,9 @@ void rxrpc_cleanup_call(struct rxrpc_call *call)
 	ASSERTCMP(call->state, ==, RXRPC_CALL_COMPLETE);
 	ASSERT(test_bit(RXRPC_CALL_RELEASED, &call->flags));
 
-	del_timer_sync(&call->timer);
-	cancel_work(&call->processor);
+	del_timer(&call->timer);
 
-	if (rcu_read_lock_held() || work_busy(&call->processor))
+	if (rcu_read_lock_held())
 		/* Can't use the rxrpc workqueue as we need to cancel/flush
 		 * something that may be running/waiting there.
 		 */
diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index 23a74e35052d..643a56322224 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -479,3 +479,63 @@ void rxrpc_process_connection(struct work_struct *work)
 		rxrpc_unuse_local(conn->local, rxrpc_local_unuse_conn_work);
 	}
 }
+
+/*
+ * post connection-level events to the connection
+ * - this includes challenges, responses, some aborts and call terminal packet
+ *   retransmission.
+ */
+static void rxrpc_post_packet_to_conn(struct rxrpc_connection *conn,
+				      struct sk_buff *skb)
+{
+	_enter("%p,%p", conn, skb);
+
+	rxrpc_get_skb(skb, rxrpc_skb_get_conn_work);
+	skb_queue_tail(&conn->rx_queue, skb);
+	rxrpc_queue_conn(conn, rxrpc_conn_queue_rx_work);
+}
+
+/*
+ * Input a connection-level packet.
+ */
+int rxrpc_input_conn_packet(struct rxrpc_connection *conn, struct sk_buff *skb)
+{
+	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
+
+	if (conn->state >= RXRPC_CONN_REMOTELY_ABORTED) {
+		_leave(" = -ECONNABORTED [%u]", conn->state);
+		return -ECONNABORTED;
+	}
+
+	_enter("{%d},{%u,%%%u},", conn->debug_id, sp->hdr.type, sp->hdr.serial);
+
+	switch (sp->hdr.type) {
+	case RXRPC_PACKET_TYPE_DATA:
+	case RXRPC_PACKET_TYPE_ACK:
+		rxrpc_conn_retransmit_call(conn, skb,
+					   sp->hdr.cid & RXRPC_CHANNELMASK);
+		return 0;
+
+	case RXRPC_PACKET_TYPE_BUSY:
+		/* Just ignore BUSY packets for now. */
+		return 0;
+
+	case RXRPC_PACKET_TYPE_ABORT:
+		conn->error = -ECONNABORTED;
+		conn->abort_code = skb->priority;
+		conn->state = RXRPC_CONN_REMOTELY_ABORTED;
+		set_bit(RXRPC_CONN_DONT_REUSE, &conn->flags);
+		rxrpc_abort_calls(conn, RXRPC_CALL_REMOTELY_ABORTED, sp->hdr.serial);
+		return -ECONNABORTED;
+
+	case RXRPC_PACKET_TYPE_CHALLENGE:
+	case RXRPC_PACKET_TYPE_RESPONSE:
+		rxrpc_post_packet_to_conn(conn, skb);
+		return 0;
+
+	default:
+		trace_rxrpc_rx_eproto(NULL, sp->hdr.serial,
+				      tracepoint_string("bad_conn_pkt"));
+		return -EPROTO;
+	}
+}
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index 98e49646ca1d..3c8f83dacb2b 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -72,76 +72,55 @@ struct rxrpc_connection *rxrpc_alloc_connection(struct rxrpc_net *rxnet,
  *
  * The caller must be holding the RCU read lock.
  */
-struct rxrpc_connection *rxrpc_find_connection_rcu(struct rxrpc_local *local,
-						   struct sockaddr_rxrpc *srx,
-						   struct sk_buff *skb,
-						   struct rxrpc_peer **_peer)
+struct rxrpc_connection *rxrpc_find_client_connection_rcu(struct rxrpc_local *local,
+							  struct sockaddr_rxrpc *srx,
+							  struct sk_buff *skb)
 {
 	struct rxrpc_connection *conn;
-	struct rxrpc_conn_proto k;
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	struct rxrpc_peer *peer;
 
 	_enter(",%x", sp->hdr.cid & RXRPC_CIDMASK);
 
-	k.epoch	= sp->hdr.epoch;
-	k.cid	= sp->hdr.cid & RXRPC_CIDMASK;
-
-	if (rxrpc_to_server(sp)) {
-		/* We need to look up service connections by the full protocol
-		 * parameter set.  We look up the peer first as an intermediate
-		 * step and then the connection from the peer's tree.
-		 */
-		peer = rxrpc_lookup_peer_rcu(local, srx);
-		if (!peer)
-			goto not_found;
-		*_peer = peer;
-		conn = rxrpc_find_service_conn_rcu(peer, skb);
-		if (!conn || refcount_read(&conn->ref) == 0)
-			goto not_found;
-		_leave(" = %p", conn);
-		return conn;
-	} else {
-		/* Look up client connections by connection ID alone as their
-		 * IDs are unique for this machine.
-		 */
-		conn = idr_find(&rxrpc_client_conn_ids, sp->hdr.cid >> RXRPC_CIDSHIFT);
-		if (!conn || refcount_read(&conn->ref) == 0) {
-			_debug("no conn");
-			goto not_found;
-		}
+	/* Look up client connections by connection ID alone as their IDs are
+	 * unique for this machine.
+	 */
+	conn = idr_find(&rxrpc_client_conn_ids, sp->hdr.cid >> RXRPC_CIDSHIFT);
+	if (!conn || refcount_read(&conn->ref) == 0) {
+		_debug("no conn");
+		goto not_found;
+	}
 
-		if (conn->proto.epoch != k.epoch ||
-		    conn->local != local)
+	if (conn->proto.epoch != sp->hdr.epoch ||
+	    conn->local != local)
+		goto not_found;
+
+	peer = conn->peer;
+	switch (srx->transport.family) {
+	case AF_INET:
+		if (peer->srx.transport.sin.sin_port !=
+		    srx->transport.sin.sin_port ||
+		    peer->srx.transport.sin.sin_addr.s_addr !=
+		    srx->transport.sin.sin_addr.s_addr)
 			goto not_found;
-
-		peer = conn->peer;
-		switch (srx->transport.family) {
-		case AF_INET:
-			if (peer->srx.transport.sin.sin_port !=
-			    srx->transport.sin.sin_port ||
-			    peer->srx.transport.sin.sin_addr.s_addr !=
-			    srx->transport.sin.sin_addr.s_addr)
-				goto not_found;
-			break;
+		break;
 #ifdef CONFIG_AF_RXRPC_IPV6
-		case AF_INET6:
-			if (peer->srx.transport.sin6.sin6_port !=
-			    srx->transport.sin6.sin6_port ||
-			    memcmp(&peer->srx.transport.sin6.sin6_addr,
-				   &srx->transport.sin6.sin6_addr,
-				   sizeof(struct in6_addr)) != 0)
-				goto not_found;
-			break;
+	case AF_INET6:
+		if (peer->srx.transport.sin6.sin6_port !=
+		    srx->transport.sin6.sin6_port ||
+		    memcmp(&peer->srx.transport.sin6.sin6_addr,
+			   &srx->transport.sin6.sin6_addr,
+			   sizeof(struct in6_addr)) != 0)
+			goto not_found;
+		break;
 #endif
-		default:
-			BUG();
-		}
-
-		_leave(" = %p", conn);
-		return conn;
+	default:
+		BUG();
 	}
 
+	_leave(" = %p", conn);
+	return conn;
+
 not_found:
 	_leave(" = NULL");
 	return NULL;
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 01d32f817a7a..7ae7046f0b03 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -12,10 +12,8 @@
 static void rxrpc_proto_abort(const char *why,
 			      struct rxrpc_call *call, rxrpc_seq_t seq)
 {
-	if (rxrpc_abort_call(why, call, seq, RX_PROTOCOL_ERROR, -EBADMSG)) {
-		set_bit(RXRPC_CALL_EV_ABORT, &call->events);
-		rxrpc_queue_call(call, rxrpc_call_queue_abort);
-	}
+	if (rxrpc_abort_call(why, call, seq, RX_PROTOCOL_ERROR, -EBADMSG))
+		rxrpc_send_abort_packet(call);
 }
 
 /*
@@ -174,8 +172,8 @@ static void rxrpc_congestion_management(struct rxrpc_call *call,
 	call->cong_cwnd = cwnd;
 	call->cong_cumul_acks = cumulative_acks;
 	trace_rxrpc_congest(call, summary, acked_serial, change);
-	if (resend && !test_and_set_bit(RXRPC_CALL_EV_RESEND, &call->events))
-		rxrpc_queue_call(call, rxrpc_call_queue_resend);
+	if (resend)
+		rxrpc_resend(call, skb);
 	return;
 
 packet_loss_detected:
@@ -398,6 +396,8 @@ static void rxrpc_input_data_one(struct rxrpc_call *call, struct sk_buff *skb,
 		/* Send an immediate ACK if we fill in a hole */
 		else if (!skb_queue_empty(&call->rx_oos_queue))
 			ack_reason = RXRPC_ACK_DELAY;
+		else
+			atomic_inc_return(&call->ackr_nr_unacked);
 
 		window++;
 		if (after(window, wtop))
@@ -473,14 +473,6 @@ static void rxrpc_input_data_one(struct rxrpc_call *call, struct sk_buff *skb,
 	}
 
 send_ack:
-	if (ack_reason < 0 &&
-	    atomic_inc_return(&call->ackr_nr_unacked) > 2 &&
-	    test_and_set_bit(RXRPC_CALL_IDLE_ACK_PENDING, &call->flags)) {
-		ack_reason = RXRPC_ACK_IDLE;
-	} else if (ack_reason >= 0) {
-		set_bit(RXRPC_CALL_IDLE_ACK_PENDING, &call->flags);
-	}
-
 	if (ack_reason >= 0)
 		rxrpc_send_ACK(call, ack_reason, serial,
 			       rxrpc_propose_ack_input_data);
@@ -510,7 +502,7 @@ static bool rxrpc_input_split_jumbo(struct rxrpc_call *call, struct sk_buff *skb
 				  &jhdr, sizeof(jhdr)) < 0)
 			goto protocol_error;
 
-		jskb = skb_clone(skb, GFP_ATOMIC);
+		jskb = skb_clone(skb, GFP_NOFS);
 		if (!jskb) {
 			kdebug("couldn't clone");
 			return false;
@@ -562,24 +554,6 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 	if (state >= RXRPC_CALL_COMPLETE)
 		return;
 
-	/* Unshare the packet so that it can be modified for in-place
-	 * decryption.
-	 */
-	if (sp->hdr.securityIndex != 0) {
-		struct sk_buff *nskb = skb_unshare(skb, GFP_ATOMIC);
-		if (!nskb) {
-			rxrpc_eaten_skb(skb, rxrpc_skb_eaten_by_unshare_nomem);
-			return;
-		}
-
-		if (nskb != skb) {
-			rxrpc_eaten_skb(skb, rxrpc_skb_eaten_by_unshare);
-			skb = nskb;
-			rxrpc_new_skb(skb, rxrpc_skb_new_unshared);
-			sp = rxrpc_skb(skb);
-		}
-	}
-
 	if (state == RXRPC_CALL_SERVER_RECV_REQUEST) {
 		unsigned long timo = READ_ONCE(call->next_req_timo);
 		unsigned long now, expect_req_by;
@@ -599,15 +573,15 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 	if ((state == RXRPC_CALL_CLIENT_SEND_REQUEST ||
 	     state == RXRPC_CALL_CLIENT_AWAIT_REPLY) &&
 	    !rxrpc_receiving_reply(call))
-		goto out;
+		goto out_notify;
 
 	if (!rxrpc_input_split_jumbo(call, skb)) {
 		rxrpc_proto_abort("VLD", call, sp->hdr.seq);
-		goto out;
+		goto out_notify;
 	}
 	skb = NULL;
 
-out:
+out_notify:
 	trace_rxrpc_notify_socket(call->debug_id, serial);
 	rxrpc_notify_socket(call);
 	_leave(" [queued]");
@@ -667,32 +641,6 @@ static void rxrpc_complete_rtt_probe(struct rxrpc_call *call,
 		trace_rxrpc_rtt_rx(call, rxrpc_rtt_rx_lost, 9, 0, acked_serial, 0, 0);
 }
 
-/*
- * Process the response to a ping that we sent to find out if we lost an ACK.
- *
- * If we got back a ping response that indicates a lower tx_top than what we
- * had at the time of the ping transmission, we adjudge all the DATA packets
- * sent between the response tx_top and the ping-time tx_top to have been lost.
- */
-static void rxrpc_input_check_for_lost_ack(struct rxrpc_call *call)
-{
-	if (after(call->acks_lost_top, call->acks_prev_seq) &&
-	    !test_and_set_bit(RXRPC_CALL_EV_RESEND, &call->events))
-		rxrpc_queue_call(call, rxrpc_call_queue_resend);
-}
-
-/*
- * Process a ping response.
- */
-static void rxrpc_input_ping_response(struct rxrpc_call *call,
-				      ktime_t resp_time,
-				      rxrpc_serial_t acked_serial,
-				      rxrpc_serial_t ack_serial)
-{
-	if (acked_serial == call->acks_lost_ping)
-		rxrpc_input_check_for_lost_ack(call);
-}
-
 /*
  * Process the extra information that may be appended to an ACK packet
  */
@@ -801,7 +749,6 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	struct rxrpc_ackpacket ack;
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	struct rxrpc_ackinfo info;
-	struct sk_buff *skb_old = NULL;
 	rxrpc_serial_t ack_serial, acked_serial;
 	rxrpc_seq_t first_soft_ack, hard_ack, prev_pkt;
 	int nr_acks, offset, ioffset;
@@ -809,10 +756,8 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	_enter("");
 
 	offset = sizeof(struct rxrpc_wire_header);
-	if (skb_copy_bits(skb, offset, &ack, sizeof(ack)) < 0) {
-		rxrpc_proto_abort("XAK", call, 0);
-		goto out;
-	}
+	if (skb_copy_bits(skb, offset, &ack, sizeof(ack)) < 0)
+		return rxrpc_proto_abort("XAK", call, 0);
 	offset += sizeof(ack);
 
 	ack_serial = sp->hdr.serial;
@@ -863,7 +808,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	    rxrpc_is_client_call(call)) {
 		rxrpc_set_call_completion(call, RXRPC_CALL_REMOTELY_ABORTED,
 					  0, -ENETRESET);
-		goto out;
+		return;
 	}
 
 	/* If we get an OUT_OF_SEQUENCE ACK from the server, that can also
@@ -877,7 +822,7 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	    rxrpc_is_client_call(call)) {
 		rxrpc_set_call_completion(call, RXRPC_CALL_REMOTELY_ABORTED,
 					  0, -ENETRESET);
-		goto out;
+		return;
 	}
 
 	/* Discard any out-of-order or duplicate ACKs (outside lock). */
@@ -885,39 +830,25 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 		trace_rxrpc_rx_discard_ack(call->debug_id, ack_serial,
 					   first_soft_ack, call->acks_first_seq,
 					   prev_pkt, call->acks_prev_seq);
-		goto out;
+		return;
 	}
 
 	info.rxMTU = 0;
 	ioffset = offset + nr_acks + 3;
 	if (skb->len >= ioffset + sizeof(info) &&
-	    skb_copy_bits(skb, ioffset, &info, sizeof(info)) < 0) {
-		rxrpc_proto_abort("XAI", call, 0);
-		goto out;
-	}
+	    skb_copy_bits(skb, ioffset, &info, sizeof(info)) < 0)
+		return rxrpc_proto_abort("XAI", call, 0);
 
 	if (nr_acks > 0)
 		skb_condense(skb);
 
-	/* Discard any out-of-order or duplicate ACKs (inside lock). */
-	if (!rxrpc_is_ack_valid(call, first_soft_ack, prev_pkt)) {
-		trace_rxrpc_rx_discard_ack(call->debug_id, ack_serial,
-					   first_soft_ack, call->acks_first_seq,
-					   prev_pkt, call->acks_prev_seq);
-		goto out;
-	}
 	call->acks_latest_ts = skb->tstamp;
-
 	call->acks_first_seq = first_soft_ack;
 	call->acks_prev_seq = prev_pkt;
 
 	switch (ack.reason) {
 	case RXRPC_ACK_PING:
 		break;
-	case RXRPC_ACK_PING_RESPONSE:
-		rxrpc_input_ping_response(call, skb->tstamp, acked_serial,
-					  ack_serial);
-		fallthrough;
 	default:
 		if (after(acked_serial, call->acks_highest_serial))
 			call->acks_highest_serial = acked_serial;
@@ -928,10 +859,8 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	if (info.rxMTU)
 		rxrpc_input_ackinfo(call, skb, &info);
 
-	if (first_soft_ack == 0) {
-		rxrpc_proto_abort("AK0", call, 0);
-		goto out;
-	}
+	if (first_soft_ack == 0)
+		return rxrpc_proto_abort("AK0", call, 0);
 
 	/* Ignore ACKs unless we are or have just been transmitting. */
 	switch (READ_ONCE(call->state)) {
@@ -941,45 +870,27 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	case RXRPC_CALL_SERVER_AWAIT_ACK:
 		break;
 	default:
-		goto out;
+		return;
 	}
 
 	if (before(hard_ack, call->acks_hard_ack) ||
-	    after(hard_ack, call->tx_top)) {
-		rxrpc_proto_abort("AKW", call, 0);
-		goto out;
-	}
-	if (nr_acks > call->tx_top - hard_ack) {
-		rxrpc_proto_abort("AKN", call, 0);
-		goto out;
-	}
+	    after(hard_ack, call->tx_top))
+		return rxrpc_proto_abort("AKW", call, 0);
+	if (nr_acks > call->tx_top - hard_ack)
+		return rxrpc_proto_abort("AKN", call, 0);
 
 	if (after(hard_ack, call->acks_hard_ack)) {
 		if (rxrpc_rotate_tx_window(call, hard_ack, &summary)) {
 			rxrpc_end_tx_phase(call, false, "ETA");
-			goto out;
+			return;
 		}
 	}
 
 	if (nr_acks > 0) {
-		if (offset > (int)skb->len - nr_acks) {
-			rxrpc_proto_abort("XSA", call, 0);
-			goto out;
-		}
-
-		rxrpc_get_skb(skb, rxrpc_skb_get_ack);
-		spin_lock(&call->acks_ack_lock);
-		skb_old = call->acks_soft_tbl;
-		call->acks_soft_tbl = skb;
-		spin_unlock(&call->acks_ack_lock);
-
+		if (offset > (int)skb->len - nr_acks)
+			return rxrpc_proto_abort("XSA", call, 0);
 		rxrpc_input_soft_acks(call, skb->data + offset, first_soft_ack,
 				      nr_acks, &summary);
-	} else if (call->acks_soft_tbl) {
-		spin_lock(&call->acks_ack_lock);
-		skb_old = call->acks_soft_tbl;
-		call->acks_soft_tbl = NULL;
-		spin_unlock(&call->acks_ack_lock);
 	}
 
 	if (test_bit(RXRPC_CALL_TX_LAST, &call->flags) &&
@@ -989,8 +900,6 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 				   rxrpc_propose_ack_ping_for_lost_reply);
 
 	rxrpc_congestion_management(call, skb, &summary, acked_serial);
-out:
-	rxrpc_free_skb(skb_old, rxrpc_skb_put_ack);
 }
 
 /*
@@ -1020,13 +929,20 @@ static void rxrpc_input_abort(struct rxrpc_call *call, struct sk_buff *skb)
 /*
  * Process an incoming call packet.
  */
-void rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb)
+void rxrpc_input_call_packet(struct rxrpc_call *call, struct sk_buff *skb)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	unsigned long timo;
 
 	_enter("%p,%p", call, skb);
 
+	if (sp->hdr.serviceId != call->dest_srx.srx_service)
+		call->dest_srx.srx_service = sp->hdr.serviceId;
+	if ((int)sp->hdr.serial - (int)call->rx_serial > 0)
+		call->rx_serial = sp->hdr.serial;
+	if (!test_bit(RXRPC_CALL_RX_HEARD, &call->flags))
+		set_bit(RXRPC_CALL_RX_HEARD, &call->flags);
+
 	timo = READ_ONCE(call->next_rx_timo);
 	if (timo) {
 		unsigned long now = jiffies, expect_rx_by;
@@ -1072,9 +988,10 @@ void rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb)
  *
  * TODO: If callNumber > call_id + 1, renegotiate security.
  */
-void rxrpc_input_implicit_end_call(struct rxrpc_connection *conn,
-				   struct rxrpc_call *call)
+void rxrpc_implicit_end_call(struct rxrpc_call *call, struct sk_buff *skb)
 {
+	struct rxrpc_connection *conn = call->conn;
+
 	switch (READ_ONCE(call->state)) {
 	case RXRPC_CALL_SERVER_AWAIT_ACK:
 		rxrpc_call_completed(call);
@@ -1082,14 +999,14 @@ void rxrpc_input_implicit_end_call(struct rxrpc_connection *conn,
 	case RXRPC_CALL_COMPLETE:
 		break;
 	default:
-		if (rxrpc_abort_call("IMP", call, 0, RX_CALL_DEAD, -ESHUTDOWN)) {
-			set_bit(RXRPC_CALL_EV_ABORT, &call->events);
-			rxrpc_queue_call(call, rxrpc_call_queue_abort);
-		}
+		if (rxrpc_abort_call("IMP", call, 0, RX_CALL_DEAD, -ESHUTDOWN))
+			rxrpc_send_abort_packet(call);
 		trace_rxrpc_improper_term(call);
 		break;
 	}
 
+	rxrpc_input_call_event(call, skb);
+
 	spin_lock(&conn->bundle->channel_lock);
 	__rxrpc_disconnect_call(conn, call);
 	spin_unlock(&conn->bundle->channel_lock);
diff --git a/net/rxrpc/io_thread.c b/net/rxrpc/io_thread.c
index bc65d83fab88..19aa315eddf5 100644
--- a/net/rxrpc/io_thread.c
+++ b/net/rxrpc/io_thread.c
@@ -9,6 +9,10 @@
 
 #include "ar-internal.h"
 
+static int rxrpc_input_packet_on_conn(struct rxrpc_connection *conn,
+				      struct sockaddr_rxrpc *peer_srx,
+				      struct sk_buff *skb);
+
 /*
  * handle data received on the local endpoint
  * - may be called in interrupt context
@@ -63,45 +67,19 @@ void rxrpc_error_report(struct sock *sk)
 }
 
 /*
- * post connection-level events to the connection
- * - this includes challenges, responses, some aborts and call terminal packet
- *   retransmission.
+ * Process event packets targeted at a local endpoint.
  */
-static void rxrpc_post_packet_to_conn(struct rxrpc_connection *conn,
-				      struct sk_buff *skb)
+static void rxrpc_input_version(struct rxrpc_local *local, struct sk_buff *skb)
 {
-	_enter("%p,%p", conn, skb);
-
-	rxrpc_get_skb(skb, rxrpc_skb_get_conn_work);
-	skb_queue_tail(&conn->rx_queue, skb);
-	rxrpc_queue_conn(conn, rxrpc_conn_queue_rx_work);
-}
+	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
+	char v;
 
-/*
- * post endpoint-level events to the local endpoint
- * - this includes debug and version messages
- */
-static void rxrpc_post_packet_to_local(struct rxrpc_local *local,
-				       struct sk_buff *skb)
-{
-	_enter("%p,%p", local, skb);
+	_enter("");
 
-	if (rxrpc_get_local_maybe(local, rxrpc_local_get_queue)) {
-		rxrpc_get_skb(skb, rxrpc_skb_get_local_work);
-		skb_queue_tail(&local->event_queue, skb);
-		rxrpc_queue_local(local);
-	}
-}
-
-/*
- * put a packet up for transport-level abort
- */
-static void rxrpc_reject_packet(struct rxrpc_local *local, struct sk_buff *skb)
-{
-	if (rxrpc_get_local_maybe(local, rxrpc_local_get_queue)) {
-		rxrpc_get_skb(skb, rxrpc_skb_get_reject_work);
-		skb_queue_tail(&local->reject_queue, skb);
-		rxrpc_queue_local(local);
+	rxrpc_see_skb(skb, rxrpc_skb_see_version);
+	if (skb_copy_bits(skb, sizeof(struct rxrpc_wire_header), &v, 1) >= 0) {
+		if (v == 0)
+			rxrpc_send_version_request(local, &sp->hdr, skb);
 	}
 }
 
@@ -156,22 +134,13 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff **_skb)
 {
 	struct rxrpc_connection *conn;
 	struct sockaddr_rxrpc peer_srx;
-	struct rxrpc_channel *chan;
-	struct rxrpc_call *call = NULL;
 	struct rxrpc_skb_priv *sp;
 	struct rxrpc_peer *peer = NULL;
-	struct rxrpc_sock *rx = NULL;
 	struct sk_buff *skb = *_skb;
-	unsigned int channel;
-
-	if (skb->tstamp == 0)
-		skb->tstamp = ktime_get_real();
+	int ret = 0;
 
 	skb_pull(skb, sizeof(struct udphdr));
 
-	/* The UDP protocol already released all skb resources;
-	 * we are free to add our own data there.
-	 */
 	sp = rxrpc_skb(skb);
 
 	/* dig out the RxRPC connection details */
@@ -186,15 +155,13 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff **_skb)
 		}
 	}
 
-	if (skb->tstamp == 0)
-		skb->tstamp = ktime_get_real();
 	trace_rxrpc_rx_packet(sp);
 
 	switch (sp->hdr.type) {
 	case RXRPC_PACKET_TYPE_VERSION:
 		if (rxrpc_to_client(sp))
 			return 0;
-		rxrpc_post_packet_to_local(local, skb);
+		rxrpc_input_version(local, skb);
 		return 0;
 
 	case RXRPC_PACKET_TYPE_BUSY:
@@ -259,7 +226,7 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff **_skb)
 		goto bad_message;
 
 	if (WARN_ON_ONCE(rxrpc_extract_addr_from_skb(&peer_srx, skb) < 0))
-		return 0; /* Unsupported address type - discard. */
+		return true; /* Unsupported address type - discard. */
 
 	if (peer_srx.transport.family != local->srx.transport.family &&
 	    (peer_srx.transport.family == AF_INET &&
@@ -267,171 +234,172 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff **_skb)
 		pr_warn_ratelimited("AF_RXRPC: Protocol mismatch %u not %u\n",
 				    peer_srx.transport.family,
 				    local->srx.transport.family);
-		return 0; /* Wrong address type - discard. */
+		return true; /* Wrong address type - discard. */
+	}
+
+	if (rxrpc_to_client(sp)) {
+		rcu_read_lock();
+		conn = rxrpc_find_client_connection_rcu(local, &peer_srx, skb);
+		conn = rxrpc_get_connection_maybe(conn, rxrpc_conn_get_call_input);
+		rcu_read_unlock();
+		if (!conn) {
+			trace_rxrpc_abort(0, "NCC", sp->hdr.cid,
+					  sp->hdr.callNumber, sp->hdr.seq,
+					  RXKADINCONSISTENCY, EBADMSG);
+			goto protocol_error;
+		}
+
+		ret = rxrpc_input_packet_on_conn(conn, &peer_srx, skb);
+		rxrpc_put_connection(conn, rxrpc_conn_put_call_input);
+		return ret;
 	}
 
+	/* We need to look up service connections by the full protocol
+	 * parameter set.  We look up the peer first as an intermediate step
+	 * and then the connection from the peer's tree.
+	 */
 	rcu_read_lock();
 
-	if (rxrpc_to_server(sp)) {
-		/* Weed out packets to services we're not offering.  Packets
-		 * that would begin a call are explicitly rejected and the rest
-		 * are just discarded.
-		 */
-		rx = rcu_dereference(local->service);
-		if (!rx || (sp->hdr.serviceId != rx->srx.srx_service &&
-			    sp->hdr.serviceId != rx->second_service)
-		    ) {
-			rcu_read_unlock();
-			if (sp->hdr.type == RXRPC_PACKET_TYPE_DATA &&
-			    sp->hdr.seq == 1)
-				goto unsupported_service;
-			return 0;
-		}
+	peer = rxrpc_lookup_peer_rcu(local, &peer_srx);
+	if (!peer) {
+		rcu_read_unlock();
+		return rxrpc_new_incoming_call(local, NULL, NULL, &peer_srx, skb);
 	}
 
-	conn = rxrpc_find_connection_rcu(local, &peer_srx, skb, &peer);
+	conn = rxrpc_find_service_conn_rcu(peer, skb);
+	conn = rxrpc_get_connection_maybe(conn, rxrpc_conn_get_call_input);
 	if (conn) {
-		if (sp->hdr.securityIndex != conn->security_ix)
-			goto wrong_security;
+		rcu_read_unlock();
+		ret = rxrpc_input_packet_on_conn(conn, &peer_srx, skb);
+		rxrpc_put_connection(conn, rxrpc_conn_put_call_input);
+		return ret;
+	}
 
-		if (sp->hdr.serviceId != conn->service_id) {
-			int old_id;
+	peer = rxrpc_get_peer_maybe(peer, rxrpc_peer_get_input);
+	rcu_read_unlock();
 
-			if (!test_bit(RXRPC_CONN_PROBING_FOR_UPGRADE, &conn->flags))
-				goto reupgrade;
-			old_id = cmpxchg(&conn->service_id, conn->orig_service_id,
-					 sp->hdr.serviceId);
+	ret = rxrpc_new_incoming_call(local, peer, NULL, &peer_srx, skb);
+	rxrpc_put_peer(peer, rxrpc_peer_put_input);
+	if (ret < 0)
+		goto reject_packet;
+	return 0;
 
-			if (old_id != conn->orig_service_id &&
-			    old_id != sp->hdr.serviceId)
-				goto reupgrade;
-		}
+bad_message:
+	trace_rxrpc_abort(0, "BAD", sp->hdr.cid, sp->hdr.callNumber, sp->hdr.seq,
+			  RX_PROTOCOL_ERROR, EBADMSG);
+protocol_error:
+	skb->priority = RX_PROTOCOL_ERROR;
+	skb->mark = RXRPC_SKB_MARK_REJECT_ABORT;
+reject_packet:
+	rxrpc_reject_packet(local, skb);
+	return ret;
+}
 
-		if (sp->hdr.callNumber == 0) {
-			/* Connection-level packet */
-			_debug("CONN %p {%d}", conn, conn->debug_id);
-			conn = rxrpc_get_connection_maybe(conn, rxrpc_conn_get_conn_input);
-			rcu_read_unlock();
-			if (conn) {
-				rxrpc_post_packet_to_conn(conn, skb);
-				rxrpc_put_connection(conn, rxrpc_conn_put_conn_input);
-			}
-			return 0;
-		}
+/*
+ * Deal with a packet that's associated with an extant connection.
+ */
+static int rxrpc_input_packet_on_conn(struct rxrpc_connection *conn,
+				      struct sockaddr_rxrpc *peer_srx,
+				      struct sk_buff *skb)
+{
+	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
+	struct rxrpc_channel *chan;
+	struct rxrpc_call *call = NULL;
+	unsigned int channel;
 
-		if ((int)sp->hdr.serial - (int)conn->hi_serial > 0)
-			conn->hi_serial = sp->hdr.serial;
+	if (sp->hdr.securityIndex != conn->security_ix)
+		goto wrong_security;
 
-		/* Call-bound packets are routed by connection channel. */
-		channel = sp->hdr.cid & RXRPC_CHANNELMASK;
-		chan = &conn->channels[channel];
+	if (sp->hdr.serviceId != conn->service_id) {
+		int old_id;
 
-		/* Ignore really old calls */
-		if (sp->hdr.callNumber < chan->last_call) {
-			rcu_read_unlock();
-			return 0;
-		}
+		if (!test_bit(RXRPC_CONN_PROBING_FOR_UPGRADE, &conn->flags))
+			goto reupgrade;
+		old_id = cmpxchg(&conn->service_id, conn->orig_service_id,
+				 sp->hdr.serviceId);
 
-		if (sp->hdr.callNumber == chan->last_call) {
-			if (chan->call ||
-			    sp->hdr.type == RXRPC_PACKET_TYPE_ABORT) {
-				rcu_read_unlock();
-				return 0;
-			}
+		if (old_id != conn->orig_service_id &&
+		    old_id != sp->hdr.serviceId)
+			goto reupgrade;
+	}
 
-			/* For the previous service call, if completed
-			 * successfully, we discard all further packets.
-			 */
-			if (rxrpc_conn_is_service(conn) &&
-			    chan->last_type == RXRPC_PACKET_TYPE_ACK) {
-				rcu_read_unlock();
-				return 0;
-			}
+	if (after(sp->hdr.serial, conn->hi_serial))
+		conn->hi_serial = sp->hdr.serial;
 
-			/* But otherwise we need to retransmit the final packet
-			 * from data cached in the connection record.
-			 */
-			if (sp->hdr.type == RXRPC_PACKET_TYPE_DATA)
-				trace_rxrpc_rx_data(chan->call_debug_id,
-						    sp->hdr.seq,
-						    sp->hdr.serial,
-						    sp->hdr.flags);
-			conn = rxrpc_get_connection_maybe(conn, rxrpc_conn_get_call_input);
-			rcu_read_unlock();
-			if (conn) {
-				rxrpc_post_packet_to_conn(conn, skb);
-				rxrpc_put_connection(conn, rxrpc_conn_put_call_input);
-			}
+	/* It's a connection-level packet if the call number is 0. */
+	if (sp->hdr.callNumber == 0)
+		return rxrpc_input_conn_packet(conn, skb);
+
+	/* Call-bound packets are routed by connection channel. */
+	channel = sp->hdr.cid & RXRPC_CHANNELMASK;
+	chan = &conn->channels[channel];
+
+	/* Ignore really old calls */
+	if (sp->hdr.callNumber < chan->last_call)
+		return 0;
+
+	if (sp->hdr.callNumber == chan->last_call) {
+		if (chan->call ||
+		    sp->hdr.type == RXRPC_PACKET_TYPE_ABORT)
 			return 0;
-		}
 
-		call = rcu_dereference(chan->call);
+		/* For the previous service call, if completed successfully, we
+		 * discard all further packets.
+		 */
+		if (rxrpc_conn_is_service(conn) &&
+		    chan->last_type == RXRPC_PACKET_TYPE_ACK)
+			return 0;
 
-		if (sp->hdr.callNumber > chan->call_id) {
-			if (rxrpc_to_client(sp)) {
-				rcu_read_unlock();
-				goto reject_packet;
-			}
-			if (call) {
-				rxrpc_input_implicit_end_call(conn, call);
-				chan->call = NULL;
-				call = NULL;
-			}
-		}
+		/* But otherwise we need to retransmit the final packet from
+		 * data cached in the connection record.
+		 */
+		if (sp->hdr.type == RXRPC_PACKET_TYPE_DATA)
+			trace_rxrpc_rx_data(chan->call_debug_id,
+					    sp->hdr.seq,
+					    sp->hdr.serial,
+					    sp->hdr.flags);
+		rxrpc_input_conn_packet(conn, skb);
+		return 0;
+	}
 
-		if (call && !rxrpc_try_get_call(call, rxrpc_call_get_input))
-			call = NULL;
+	rcu_read_lock();
+	call = rxrpc_try_get_call(rcu_dereference(chan->call),
+				  rxrpc_call_get_input);
+	rcu_read_unlock();
+
+	if (sp->hdr.callNumber > chan->call_id) {
+		if (rxrpc_to_client(sp)) {
+			rxrpc_put_call(call, rxrpc_call_put_input);
+			goto reject_packet;
+		}
 
 		if (call) {
-			if (sp->hdr.serviceId != call->dest_srx.srx_service)
-				call->dest_srx.srx_service = sp->hdr.serviceId;
-			if ((int)sp->hdr.serial - (int)call->rx_serial > 0)
-				call->rx_serial = sp->hdr.serial;
-			if (!test_bit(RXRPC_CALL_RX_HEARD, &call->flags))
-				set_bit(RXRPC_CALL_RX_HEARD, &call->flags);
+			rxrpc_implicit_end_call(call, skb);
+			rxrpc_put_call(call, rxrpc_call_put_input);
+			call = NULL;
 		}
 	}
 
 	if (!call) {
-		if (rxrpc_to_client(sp) ||
-		    sp->hdr.type != RXRPC_PACKET_TYPE_DATA) {
-			rcu_read_unlock();
+		if (rxrpc_to_client(sp))
 			goto bad_message;
-		}
-		if (sp->hdr.seq != 1) {
-			rcu_read_unlock();
+		if (rxrpc_new_incoming_call(conn->local, conn->peer, conn,
+					    peer_srx, skb))
 			return 0;
-		}
-		call = rxrpc_new_incoming_call(local, rx, &peer_srx, skb);
-		if (!call) {
-			rcu_read_unlock();
-			goto reject_packet;
-		}
+		goto reject_packet;
 	}
 
-	rcu_read_unlock();
-
-	/* Process a call packet. */
 	rxrpc_input_call_event(call, skb);
 	rxrpc_put_call(call, rxrpc_call_put_input);
-	trace_rxrpc_rx_done(0, 0);
 	return 0;
 
 wrong_security:
-	rcu_read_unlock();
 	trace_rxrpc_abort(0, "SEC", sp->hdr.cid, sp->hdr.callNumber, sp->hdr.seq,
 			  RXKADINCONSISTENCY, EBADMSG);
 	skb->priority = RXKADINCONSISTENCY;
 	goto post_abort;
 
-unsupported_service:
-	trace_rxrpc_abort(0, "INV", sp->hdr.cid, sp->hdr.callNumber, sp->hdr.seq,
-			  RX_INVALID_OPERATION, EOPNOTSUPP);
-	skb->priority = RX_INVALID_OPERATION;
-	goto post_abort;
-
 reupgrade:
-	rcu_read_unlock();
 	trace_rxrpc_abort(0, "UPG", sp->hdr.cid, sp->hdr.callNumber, sp->hdr.seq,
 			  RX_PROTOCOL_ERROR, EBADMSG);
 	goto protocol_error;
@@ -444,7 +412,7 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff **_skb)
 post_abort:
 	skb->mark = RXRPC_SKB_MARK_REJECT_ABORT;
 reject_packet:
-	rxrpc_reject_packet(local, skb);
+	rxrpc_reject_packet(conn->local, skb);
 	return 0;
 }
 
@@ -479,6 +447,11 @@ int rxrpc_io_thread(void *data)
 			continue;
 		}
 
+		if (!list_empty(&local->ack_tx_queue)) {
+			rxrpc_transmit_ack_packets(local);
+			continue;
+		}
+
 		/* Process received packets and errors. */
 		if ((skb = __skb_dequeue(&rx_queue))) {
 			switch (skb->mark) {
diff --git a/net/rxrpc/local_event.c b/net/rxrpc/local_event.c
index c344383a20b2..5e69ea6b233d 100644
--- a/net/rxrpc/local_event.c
+++ b/net/rxrpc/local_event.c
@@ -21,9 +21,9 @@ static const char rxrpc_version_string[65] = "linux-" UTS_RELEASE " AF_RXRPC";
 /*
  * Reply to a version request
  */
-static void rxrpc_send_version_request(struct rxrpc_local *local,
-				       struct rxrpc_host_header *hdr,
-				       struct sk_buff *skb)
+void rxrpc_send_version_request(struct rxrpc_local *local,
+				struct rxrpc_host_header *hdr,
+				struct sk_buff *skb)
 {
 	struct rxrpc_wire_header whdr;
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
@@ -73,40 +73,3 @@ static void rxrpc_send_version_request(struct rxrpc_local *local,
 
 	_leave("");
 }
-
-/*
- * Process event packets targeted at a local endpoint.
- */
-void rxrpc_process_local_events(struct rxrpc_local *local)
-{
-	struct sk_buff *skb;
-	char v;
-
-	_enter("");
-
-	skb = skb_dequeue(&local->event_queue);
-	if (skb) {
-		struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
-
-		rxrpc_see_skb(skb, rxrpc_skb_see_local_work);
-		_debug("{%d},{%u}", local->debug_id, sp->hdr.type);
-
-		switch (sp->hdr.type) {
-		case RXRPC_PACKET_TYPE_VERSION:
-			if (skb_copy_bits(skb, sizeof(struct rxrpc_wire_header),
-					  &v, 1) < 0)
-				return;
-			if (v == 0)
-				rxrpc_send_version_request(local, &sp->hdr, skb);
-			break;
-
-		default:
-			/* Just ignore anything we don't understand */
-			break;
-		}
-
-		rxrpc_free_skb(skb, rxrpc_skb_put_input);
-	}
-
-	_leave("");
-}
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 03f491cc23ef..c73a5a1bc088 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -20,7 +20,6 @@
 #include <net/af_rxrpc.h>
 #include "ar-internal.h"
 
-static void rxrpc_local_processor(struct work_struct *);
 static void rxrpc_local_rcu(struct rcu_head *);
 
 /*
@@ -97,12 +96,9 @@ static struct rxrpc_local *rxrpc_alloc_local(struct rxrpc_net *rxnet,
 		atomic_set(&local->active_users, 1);
 		local->rxnet = rxnet;
 		INIT_HLIST_NODE(&local->link);
-		INIT_WORK(&local->processor, rxrpc_local_processor);
 		INIT_LIST_HEAD(&local->ack_tx_queue);
 		spin_lock_init(&local->ack_tx_lock);
 		init_rwsem(&local->defrag_sem);
-		skb_queue_head_init(&local->reject_queue);
-		skb_queue_head_init(&local->event_queue);
 		skb_queue_head_init(&local->rx_queue);
 		INIT_LIST_HEAD(&local->call_attend_q);
 		local->client_bundles = RB_ROOT;
@@ -318,21 +314,6 @@ struct rxrpc_local *rxrpc_get_local_maybe(struct rxrpc_local *local,
 	return NULL;
 }
 
-/*
- * Queue a local endpoint and pass the caller's reference to the work item.
- */
-void rxrpc_queue_local(struct rxrpc_local *local)
-{
-	unsigned int debug_id = local->debug_id;
-	int r = refcount_read(&local->ref);
-	int u = atomic_read(&local->active_users);
-
-	if (rxrpc_queue_work(&local->processor))
-		trace_rxrpc_local(debug_id, rxrpc_local_queued, r, u);
-	else
-		rxrpc_put_local(local, rxrpc_local_put_already_queued);
-}
-
 /*
  * Drop a ref on a local endpoint.
  */
@@ -374,7 +355,7 @@ struct rxrpc_local *rxrpc_use_local(struct rxrpc_local *local,
 
 /*
  * Cease using a local endpoint.  Once the number of active users reaches 0, we
- * start the closure of the transport in the work processor.
+ * start the closure of the transport in the I/O thread..
  */
 void rxrpc_unuse_local(struct rxrpc_local *local, enum rxrpc_local_trace why)
 {
@@ -416,52 +397,9 @@ void rxrpc_destroy_local(struct rxrpc_local *local)
 	/* At this point, there should be no more packets coming in to the
 	 * local endpoint.
 	 */
-	rxrpc_purge_queue(&local->reject_queue);
-	rxrpc_purge_queue(&local->event_queue);
 	rxrpc_purge_queue(&local->rx_queue);
 }
 
-/*
- * Process events on an endpoint.  The work item carries a ref which
- * we must release.
- */
-static void rxrpc_local_processor(struct work_struct *work)
-{
-	struct rxrpc_local *local =
-		container_of(work, struct rxrpc_local, processor);
-	bool again;
-
-	if (local->dead)
-		return;
-
-	rxrpc_see_local(local, rxrpc_local_processing);
-
-	do {
-		again = false;
-		if (!__rxrpc_use_local(local, rxrpc_local_use_work))
-			break;
-
-		if (!list_empty(&local->ack_tx_queue)) {
-			rxrpc_transmit_ack_packets(local);
-			again = true;
-		}
-
-		if (!skb_queue_empty(&local->reject_queue)) {
-			rxrpc_reject_packets(local);
-			again = true;
-		}
-
-		if (!skb_queue_empty(&local->event_queue)) {
-			rxrpc_process_local_events(local);
-			again = true;
-		}
-
-		__rxrpc_unuse_local(local, rxrpc_local_unuse_work);
-	} while (again);
-
-	rxrpc_put_local(local, rxrpc_local_put_queue);
-}
-
 /*
  * Destroy a local endpoint after the RCU grace period expires.
  */
@@ -469,13 +407,8 @@ static void rxrpc_local_rcu(struct rcu_head *rcu)
 {
 	struct rxrpc_local *local = container_of(rcu, struct rxrpc_local, rcu);
 
-	_enter("%d", local->debug_id);
-
-	ASSERT(!work_pending(&local->processor));
-
 	rxrpc_see_local(local, rxrpc_local_free);
 	kfree(local);
-	_leave("");
 }
 
 /*
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 71963b4523be..2ea1fa1b8a6f 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -229,11 +229,6 @@ static int rxrpc_send_ack_packet(struct rxrpc_local *local, struct rxrpc_txbuf *
 	if (txb->ack.reason == RXRPC_ACK_PING)
 		txb->wire.flags |= RXRPC_REQUEST_ACK;
 
-	if (txb->ack.reason == RXRPC_ACK_DELAY)
-		clear_bit(RXRPC_CALL_DELAY_ACK_PENDING, &call->flags);
-	if (txb->ack.reason == RXRPC_ACK_IDLE)
-		clear_bit(RXRPC_CALL_IDLE_ACK_PENDING, &call->flags);
-
 	n = rxrpc_fill_out_ack(conn, call, txb);
 	if (n == 0)
 		return 0;
@@ -247,8 +242,6 @@ static int rxrpc_send_ack_packet(struct rxrpc_local *local, struct rxrpc_txbuf *
 	trace_rxrpc_tx_ack(call->debug_id, serial,
 			   ntohl(txb->ack.firstPacket),
 			   ntohl(txb->ack.serial), txb->ack.reason, txb->ack.nAcks);
-	if (txb->ack_why == rxrpc_propose_ack_ping_for_lost_ack)
-		call->acks_lost_ping = serial;
 
 	if (txb->ack.reason == RXRPC_ACK_PING)
 		rtt_slot = rxrpc_begin_rtt_probe(call, serial, rxrpc_rtt_tx_ping);
@@ -588,21 +581,20 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 }
 
 /*
- * reject packets through the local endpoint
+ * Reject a packet through the local endpoint.
  */
-void rxrpc_reject_packets(struct rxrpc_local *local)
+void rxrpc_reject_packet(struct rxrpc_local *local, struct sk_buff *skb)
 {
-	struct sockaddr_rxrpc srx;
-	struct rxrpc_skb_priv *sp;
 	struct rxrpc_wire_header whdr;
-	struct sk_buff *skb;
+	struct sockaddr_rxrpc srx;
+	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	struct msghdr msg;
 	struct kvec iov[2];
 	size_t size;
 	__be32 code;
 	int ret, ioc;
 
-	_enter("%d", local->debug_id);
+	rxrpc_see_skb(skb, rxrpc_skb_see_reject);
 
 	iov[0].iov_base = &whdr;
 	iov[0].iov_len = sizeof(whdr);
@@ -616,52 +608,42 @@ void rxrpc_reject_packets(struct rxrpc_local *local)
 
 	memset(&whdr, 0, sizeof(whdr));
 
-	while ((skb = skb_dequeue(&local->reject_queue))) {
-		rxrpc_see_skb(skb, rxrpc_skb_see_reject);
-		sp = rxrpc_skb(skb);
+	switch (skb->mark) {
+	case RXRPC_SKB_MARK_REJECT_BUSY:
+		whdr.type = RXRPC_PACKET_TYPE_BUSY;
+		size = sizeof(whdr);
+		ioc = 1;
+		break;
+	case RXRPC_SKB_MARK_REJECT_ABORT:
+		whdr.type = RXRPC_PACKET_TYPE_ABORT;
+		code = htonl(skb->priority);
+		size = sizeof(whdr) + sizeof(code);
+		ioc = 2;
+		break;
+	default:
+		return;
+	}
 
-		switch (skb->mark) {
-		case RXRPC_SKB_MARK_REJECT_BUSY:
-			whdr.type = RXRPC_PACKET_TYPE_BUSY;
-			size = sizeof(whdr);
-			ioc = 1;
-			break;
-		case RXRPC_SKB_MARK_REJECT_ABORT:
-			whdr.type = RXRPC_PACKET_TYPE_ABORT;
-			code = htonl(skb->priority);
-			size = sizeof(whdr) + sizeof(code);
-			ioc = 2;
-			break;
-		default:
-			rxrpc_free_skb(skb, rxrpc_skb_put_input);
-			continue;
-		}
+	if (rxrpc_extract_addr_from_skb(&srx, skb) == 0) {
+		msg.msg_namelen = srx.transport_len;
 
-		if (rxrpc_extract_addr_from_skb(&srx, skb) == 0) {
-			msg.msg_namelen = srx.transport_len;
-
-			whdr.epoch	= htonl(sp->hdr.epoch);
-			whdr.cid	= htonl(sp->hdr.cid);
-			whdr.callNumber	= htonl(sp->hdr.callNumber);
-			whdr.serviceId	= htons(sp->hdr.serviceId);
-			whdr.flags	= sp->hdr.flags;
-			whdr.flags	^= RXRPC_CLIENT_INITIATED;
-			whdr.flags	&= RXRPC_CLIENT_INITIATED;
-
-			iov_iter_kvec(&msg.msg_iter, WRITE, iov, ioc, size);
-			ret = do_udp_sendmsg(local->socket, &msg, size);
-			if (ret < 0)
-				trace_rxrpc_tx_fail(local->debug_id, 0, ret,
-						    rxrpc_tx_point_reject);
-			else
-				trace_rxrpc_tx_packet(local->debug_id, &whdr,
-						      rxrpc_tx_point_reject);
-		}
+		whdr.epoch	= htonl(sp->hdr.epoch);
+		whdr.cid	= htonl(sp->hdr.cid);
+		whdr.callNumber	= htonl(sp->hdr.callNumber);
+		whdr.serviceId	= htons(sp->hdr.serviceId);
+		whdr.flags	= sp->hdr.flags;
+		whdr.flags	^= RXRPC_CLIENT_INITIATED;
+		whdr.flags	&= RXRPC_CLIENT_INITIATED;
 
-		rxrpc_free_skb(skb, rxrpc_skb_put_input);
+		iov_iter_kvec(&msg.msg_iter, WRITE, iov, ioc, size);
+		ret = do_udp_sendmsg(local->socket, &msg, size);
+		if (ret < 0)
+			trace_rxrpc_tx_fail(local->debug_id, 0, ret,
+					    rxrpc_tx_point_reject);
+		else
+			trace_rxrpc_tx_packet(local->debug_id, &whdr,
+					      rxrpc_tx_point_reject);
 	}
-
-	_leave("");
 }
 
 /*
diff --git a/net/rxrpc/peer_event.c b/net/rxrpc/peer_event.c
index 97d017ca3dc4..fb8096e93d2c 100644
--- a/net/rxrpc/peer_event.c
+++ b/net/rxrpc/peer_event.c
@@ -18,9 +18,9 @@
 #include <net/ip.h>
 #include "ar-internal.h"
 
-static void rxrpc_store_error(struct rxrpc_peer *, struct sock_exterr_skb *);
-static void rxrpc_distribute_error(struct rxrpc_peer *, int,
-				   enum rxrpc_call_completion);
+static void rxrpc_store_error(struct rxrpc_peer *, struct sk_buff *);
+static void rxrpc_distribute_error(struct rxrpc_peer *, struct sk_buff *,
+				   enum rxrpc_call_completion, int);
 
 /*
  * Find the peer associated with a local error.
@@ -161,7 +161,7 @@ void rxrpc_input_error(struct rxrpc_local *local, struct sk_buff *skb)
 		goto out;
 	}
 
-	rxrpc_store_error(peer, serr);
+	rxrpc_store_error(peer, skb);
 out:
 	rxrpc_put_peer(peer, rxrpc_peer_put_input_error);
 }
@@ -169,19 +169,15 @@ void rxrpc_input_error(struct rxrpc_local *local, struct sk_buff *skb)
 /*
  * Map an error report to error codes on the peer record.
  */
-static void rxrpc_store_error(struct rxrpc_peer *peer,
-			      struct sock_exterr_skb *serr)
+static void rxrpc_store_error(struct rxrpc_peer *peer, struct sk_buff *skb)
 {
 	enum rxrpc_call_completion compl = RXRPC_CALL_NETWORK_ERROR;
-	struct sock_extended_err *ee;
-	int err;
+	struct sock_exterr_skb *serr = SKB_EXT_ERR(skb);
+	struct sock_extended_err *ee = &serr->ee;
+	int err = ee->ee_errno;
 
 	_enter("");
 
-	ee = &serr->ee;
-
-	err = ee->ee_errno;
-
 	switch (ee->ee_origin) {
 	case SO_EE_ORIGIN_NONE:
 	case SO_EE_ORIGIN_LOCAL:
@@ -197,14 +193,14 @@ static void rxrpc_store_error(struct rxrpc_peer *peer,
 		break;
 	}
 
-	rxrpc_distribute_error(peer, err, compl);
+	rxrpc_distribute_error(peer, skb, compl, err);
 }
 
 /*
  * Distribute an error that occurred on a peer.
  */
-static void rxrpc_distribute_error(struct rxrpc_peer *peer, int error,
-				   enum rxrpc_call_completion compl)
+static void rxrpc_distribute_error(struct rxrpc_peer *peer, struct sk_buff *skb,
+				   enum rxrpc_call_completion compl, int err)
 {
 	struct rxrpc_call *call;
 	HLIST_HEAD(error_targets);
@@ -219,7 +215,8 @@ static void rxrpc_distribute_error(struct rxrpc_peer *peer, int error,
 		spin_unlock(&peer->lock);
 
 		rxrpc_see_call(call, rxrpc_call_see_distribute_error);
-		rxrpc_set_call_completion(call, compl, 0, -error);
+		rxrpc_set_call_completion(call, compl, 0, -err);
+		rxrpc_input_call_event(call, skb);
 
 		spin_lock(&peer->lock);
 	}
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index 5df7f468abed..77d03b9e4c4c 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -253,11 +253,8 @@ static void rxrpc_rotate_rx_window(struct rxrpc_call *call)
 	acked = atomic_add_return(call->rx_consumed - old_consumed,
 				  &call->ackr_nr_consumed);
 	if (acked > 2 &&
-	    !test_and_set_bit(RXRPC_CALL_IDLE_ACK_PENDING, &call->flags)) {
-		rxrpc_send_ACK(call, RXRPC_ACK_IDLE, serial,
-			       rxrpc_propose_ack_rotate_rx);
-		rxrpc_transmit_ack_packets(call->peer->local);
-	}
+	    !test_and_set_bit(RXRPC_CALL_RX_IS_IDLE, &call->flags))
+		rxrpc_poke_call(call, rxrpc_call_poke_idle);
 }
 
 /*
@@ -377,7 +374,7 @@ static int rxrpc_recvmsg_data(struct socket *sock, struct rxrpc_call *call,
 	trace_rxrpc_recvdata(call, rxrpc_recvmsg_data_return, seq,
 			     rx_pkt_offset, rx_pkt_len, ret);
 	if (ret == -EAGAIN)
-		set_bit(RXRPC_CALL_RX_UNDERRUN, &call->flags);
+		set_bit(RXRPC_CALL_RX_IS_IDLE, &call->flags);
 	return ret;
 }
 
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 11af37275d5b..58e0a36f6aa9 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -170,7 +170,7 @@ static void rxrpc_queue_packet(struct rxrpc_sock *rx, struct rxrpc_call *call,
 {
 	unsigned long now;
 	rxrpc_seq_t seq = txb->seq;
-	bool last = test_bit(RXRPC_TXBUF_LAST, &txb->flags);
+	bool last = test_bit(RXRPC_TXBUF_LAST, &txb->flags), poke;
 
 	rxrpc_inc_stat(call->rxnet, stat_tx_data);
 
@@ -188,6 +188,7 @@ static void rxrpc_queue_packet(struct rxrpc_sock *rx, struct rxrpc_call *call,
 
 	/* Add the packet to the call's output buffer */
 	spin_lock(&call->tx_lock);
+	poke = list_empty(&call->tx_sendmsg);
 	list_add_tail(&txb->call_link, &call->tx_sendmsg);
 	call->tx_prepared = seq;
 	spin_unlock(&call->tx_lock);
@@ -220,11 +221,8 @@ static void rxrpc_queue_packet(struct rxrpc_sock *rx, struct rxrpc_call *call,
 		write_unlock_bh(&call->state_lock);
 	}
 
-
-	/* Stick the packet on the crypto queue or the transmission queue as
-	 * appropriate.
-	 */
-	rxrpc_queue_call(call, rxrpc_call_queue_tx_data);
+	if (poke)
+		rxrpc_poke_call(call, rxrpc_call_poke_start);
 }
 
 /*


