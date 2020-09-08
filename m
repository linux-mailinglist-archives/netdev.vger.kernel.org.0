Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4420626216C
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 22:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730067AbgIHUvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 16:51:22 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:46958 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730212AbgIHUvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 16:51:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599598273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NyYHBiloWgUaEeajM+IGpBVsYlpKoapAVl0EaJL0E9o=;
        b=epN9xuvhkMYUiIHjTEK3dKR2AaXFKftC10VYWn79ri50DkoOoz0aZynTaxPP+FIkyZIeAV
        vXu56HadvpNYvuh5GzSRJDd2ozMaq+m7FZR1BKNa8q1sNptJ5Iyj8K++udR4j0RLdf0qvg
        P7kWrnZBZVGl3IMRrsaSjcs/6SsP6Lc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-pX3u76NdOgqoh_jxGvHkJQ-1; Tue, 08 Sep 2020 16:51:08 -0400
X-MC-Unique: pX3u76NdOgqoh_jxGvHkJQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C7601008548;
        Tue,  8 Sep 2020 20:51:07 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-113-6.rdu2.redhat.com [10.10.113.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BEDFB7E8CA;
        Tue,  8 Sep 2020 20:51:05 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 2/3] rxrpc: Rewrite the client connection manager
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 08 Sep 2020 21:51:05 +0100
Message-ID: <159959826498.645007.18091528505219148523.stgit@warthog.procyon.org.uk>
In-Reply-To: <159959825107.645007.502549394334535916.stgit@warthog.procyon.org.uk>
References: <159959825107.645007.502549394334535916.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rewrite the rxrpc client connection manager so that it can support multiple
connections for a given security key to a peer.  The following changes are
made:

 (1) For each open socket, the code currently maintains an rbtree with the
     connections placed into it, keyed by communications parameters.  This
     is tricky to maintain as connections can be culled from the tree or
     replaced within it.  Connections can require replacement for a number
     of reasons, e.g. their IDs span too great a range for the IDR data
     type to represent efficiently, the call ID numbers on that conn would
     overflow or the conn got aborted.

     This is changed so that there's now a connection bundle object placed
     in the tree, keyed on the same parameters.  The bundle, however, does
     not need to be replaced.

 (2) An rxrpc_bundle object can now manage the available channels for a set
     of parallel connections.  The lock that manages this is moved there
     from the rxrpc_connection struct (channel_lock).

 (3) There'a a dummy bundle for all incoming connections to share so that
     they have a channel_lock too.  It might be better to give each
     incoming connection its own bundle.  This bundle is not needed to
     manage which channels incoming calls are made on because that's the
     solely at whim of the client.

 (4) The restrictions on how many client connections are around are
     removed.  Instead, a previous patch limits the number of client calls
     that can be allocated.  Ordinarily, client connections are reaped
     after 2 minutes on the idle queue, but when more than a certain number
     of connections are in existence, the reaper starts reaping them after
     2s of idleness instead to get the numbers back down.

     It could also be made such that new call allocations are forced to
     wait until the number of outstanding connections subsides.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/trace/events/rxrpc.h |   33 -
 net/rxrpc/ar-internal.h      |   68 +--
 net/rxrpc/conn_client.c      | 1081 +++++++++++++++++++-----------------------
 net/rxrpc/conn_event.c       |   14 -
 net/rxrpc/conn_object.c      |   12 
 net/rxrpc/conn_service.c     |    7 
 net/rxrpc/local_object.c     |    4 
 net/rxrpc/net_ns.c           |    5 
 net/rxrpc/output.c           |    6 
 net/rxrpc/proc.c             |    2 
 net/rxrpc/rxkad.c            |    8 
 net/rxrpc/sysctl.c           |   10 
 12 files changed, 559 insertions(+), 691 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index c33079b986e8..3b67d5981224 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -68,21 +68,14 @@ enum rxrpc_client_trace {
 	rxrpc_client_chan_activate,
 	rxrpc_client_chan_disconnect,
 	rxrpc_client_chan_pass,
-	rxrpc_client_chan_unstarted,
 	rxrpc_client_chan_wait_failed,
 	rxrpc_client_cleanup,
-	rxrpc_client_count,
 	rxrpc_client_discard,
 	rxrpc_client_duplicate,
 	rxrpc_client_exposed,
 	rxrpc_client_replace,
 	rxrpc_client_to_active,
-	rxrpc_client_to_culled,
 	rxrpc_client_to_idle,
-	rxrpc_client_to_inactive,
-	rxrpc_client_to_upgrade,
-	rxrpc_client_to_waiting,
-	rxrpc_client_uncount,
 };
 
 enum rxrpc_call_trace {
@@ -271,29 +264,14 @@ enum rxrpc_tx_point {
 	EM(rxrpc_client_chan_activate,		"ChActv") \
 	EM(rxrpc_client_chan_disconnect,	"ChDisc") \
 	EM(rxrpc_client_chan_pass,		"ChPass") \
-	EM(rxrpc_client_chan_unstarted,		"ChUnst") \
 	EM(rxrpc_client_chan_wait_failed,	"ChWtFl") \
 	EM(rxrpc_client_cleanup,		"Clean ") \
-	EM(rxrpc_client_count,			"Count ") \
 	EM(rxrpc_client_discard,		"Discar") \
 	EM(rxrpc_client_duplicate,		"Duplic") \
 	EM(rxrpc_client_exposed,		"Expose") \
 	EM(rxrpc_client_replace,		"Replac") \
 	EM(rxrpc_client_to_active,		"->Actv") \
-	EM(rxrpc_client_to_culled,		"->Cull") \
-	EM(rxrpc_client_to_idle,		"->Idle") \
-	EM(rxrpc_client_to_inactive,		"->Inac") \
-	EM(rxrpc_client_to_upgrade,		"->Upgd") \
-	EM(rxrpc_client_to_waiting,		"->Wait") \
-	E_(rxrpc_client_uncount,		"Uncoun")
-
-#define rxrpc_conn_cache_states \
-	EM(RXRPC_CONN_CLIENT_INACTIVE,		"Inac") \
-	EM(RXRPC_CONN_CLIENT_WAITING,		"Wait") \
-	EM(RXRPC_CONN_CLIENT_ACTIVE,		"Actv") \
-	EM(RXRPC_CONN_CLIENT_UPGRADE,		"Upgd") \
-	EM(RXRPC_CONN_CLIENT_CULLED,		"Cull") \
-	E_(RXRPC_CONN_CLIENT_IDLE,		"Idle") \
+	E_(rxrpc_client_to_idle,		"->Idle")
 
 #define rxrpc_call_traces \
 	EM(rxrpc_call_connected,		"CON") \
@@ -594,23 +572,20 @@ TRACE_EVENT(rxrpc_client,
 		    __field(int,			channel		)
 		    __field(int,			usage		)
 		    __field(enum rxrpc_client_trace,	op		)
-		    __field(enum rxrpc_conn_cache_state, cs		)
 			     ),
 
 	    TP_fast_assign(
-		    __entry->conn = conn->debug_id;
+		    __entry->conn = conn ? conn->debug_id : 0;
 		    __entry->channel = channel;
-		    __entry->usage = atomic_read(&conn->usage);
+		    __entry->usage = conn ? atomic_read(&conn->usage) : -2;
 		    __entry->op = op;
 		    __entry->cid = conn->proto.cid;
-		    __entry->cs = conn->cache_state;
 			   ),
 
-	    TP_printk("C=%08x h=%2d %s %s i=%08x u=%d",
+	    TP_printk("C=%08x h=%2d %s i=%08x u=%d",
 		      __entry->conn,
 		      __entry->channel,
 		      __print_symbolic(__entry->op, rxrpc_client_traces),
-		      __print_symbolic(__entry->cs, rxrpc_conn_cache_states),
 		      __entry->cid,
 		      __entry->usage)
 	    );
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index de84198b3285..cd5a80b34738 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -76,14 +76,12 @@ struct rxrpc_net {
 	struct work_struct	service_conn_reaper;
 	struct timer_list	service_conn_reap_timer;
 
-	unsigned int		nr_client_conns;
-	unsigned int		nr_active_client_conns;
-	bool			kill_all_client_conns;
 	bool			live;
+
+	bool			kill_all_client_conns;
+	atomic_t		nr_client_conns;
 	spinlock_t		client_conn_cache_lock; /* Lock for ->*_client_conns */
 	spinlock_t		client_conn_discard_lock; /* Prevent multiple discarders */
-	struct list_head	waiting_client_conns;
-	struct list_head	active_client_conns;
 	struct list_head	idle_client_conns;
 	struct work_struct	client_conn_reaper;
 	struct timer_list	client_conn_reap_timer;
@@ -275,8 +273,8 @@ struct rxrpc_local {
 	struct rw_semaphore	defrag_sem;	/* control re-enablement of IP DF bit */
 	struct sk_buff_head	reject_queue;	/* packets awaiting rejection */
 	struct sk_buff_head	event_queue;	/* endpoint event packets awaiting processing */
-	struct rb_root		client_conns;	/* Client connections by socket params */
-	spinlock_t		client_conns_lock; /* Lock for client_conns */
+	struct rb_root		client_bundles;	/* Client connection bundles by socket params */
+	spinlock_t		client_bundles_lock; /* Lock for client_bundles */
 	spinlock_t		lock;		/* access lock */
 	rwlock_t		services_lock;	/* lock for services list */
 	int			debug_id;	/* debug ID for printks */
@@ -353,10 +351,7 @@ struct rxrpc_conn_parameters {
 enum rxrpc_conn_flag {
 	RXRPC_CONN_HAS_IDR,		/* Has a client conn ID assigned */
 	RXRPC_CONN_IN_SERVICE_CONNS,	/* Conn is in peer->service_conns */
-	RXRPC_CONN_IN_CLIENT_CONNS,	/* Conn is in local->client_conns */
-	RXRPC_CONN_EXPOSED,		/* Conn has extra ref for exposure */
 	RXRPC_CONN_DONT_REUSE,		/* Don't reuse this connection */
-	RXRPC_CONN_COUNTED,		/* Counted by rxrpc_nr_client_conns */
 	RXRPC_CONN_PROBING_FOR_UPGRADE,	/* Probing for service upgrade */
 	RXRPC_CONN_FINAL_ACK_0,		/* Need final ACK for channel 0 */
 	RXRPC_CONN_FINAL_ACK_1,		/* Need final ACK for channel 1 */
@@ -376,19 +371,6 @@ enum rxrpc_conn_event {
 	RXRPC_CONN_EV_CHALLENGE,	/* Send challenge packet */
 };
 
-/*
- * The connection cache state.
- */
-enum rxrpc_conn_cache_state {
-	RXRPC_CONN_CLIENT_INACTIVE,	/* Conn is not yet listed */
-	RXRPC_CONN_CLIENT_WAITING,	/* Conn is on wait list, waiting for capacity */
-	RXRPC_CONN_CLIENT_ACTIVE,	/* Conn is on active list, doing calls */
-	RXRPC_CONN_CLIENT_UPGRADE,	/* Conn is on active list, probing for upgrade */
-	RXRPC_CONN_CLIENT_CULLED,	/* Conn is culled and delisted, doing calls */
-	RXRPC_CONN_CLIENT_IDLE,		/* Conn is on idle list, doing mostly nothing */
-	RXRPC_CONN__NR_CACHE_STATES
-};
-
 /*
  * The connection protocol state.
  */
@@ -404,6 +386,23 @@ enum rxrpc_conn_proto_state {
 	RXRPC_CONN__NR_STATES
 };
 
+/*
+ * RxRPC client connection bundle.
+ */
+struct rxrpc_bundle {
+	struct rxrpc_conn_parameters params;
+	atomic_t		usage;
+	unsigned int		debug_id;
+	bool			try_upgrade;	/* True if the bundle is attempting upgrade */
+	bool			alloc_conn;	/* True if someone's getting a conn */
+	unsigned short		alloc_error;	/* Error from last conn allocation */
+	spinlock_t		channel_lock;
+	struct rb_node		local_node;	/* Node in local->client_conns */
+	struct list_head	waiting_calls;	/* Calls waiting for channels */
+	unsigned long		avail_chans;	/* Mask of available channels */
+	struct rxrpc_connection	*conns[4];	/* The connections in the bundle (max 4) */
+};
+
 /*
  * RxRPC connection definition
  * - matched by { local, peer, epoch, conn_id, direction }
@@ -417,10 +416,7 @@ struct rxrpc_connection {
 	struct rcu_head		rcu;
 	struct list_head	cache_link;
 
-	spinlock_t		channel_lock;
-	unsigned char		active_chans;	/* Mask of active channels */
-#define RXRPC_ACTIVE_CHANS_MASK	((1 << RXRPC_MAXCALLS) - 1)
-	struct list_head	waiting_calls;	/* Calls waiting for channels */
+	unsigned char		act_chans;	/* Mask of active channels */
 	struct rxrpc_channel {
 		unsigned long		final_ack_at;	/* Time at which to issue final ACK */
 		struct rxrpc_call __rcu	*call;		/* Active call */
@@ -437,10 +433,8 @@ struct rxrpc_connection {
 
 	struct timer_list	timer;		/* Conn event timer */
 	struct work_struct	processor;	/* connection event processor */
-	union {
-		struct rb_node	client_node;	/* Node in local->client_conns */
-		struct rb_node	service_node;	/* Node in peer->service_conns */
-	};
+	struct rxrpc_bundle	*bundle;	/* Client connection bundle */
+	struct rb_node		service_node;	/* Node in peer->service_conns */
 	struct list_head	proc_link;	/* link in procfs list */
 	struct list_head	link;		/* link in master connection list */
 	struct sk_buff_head	rx_queue;	/* received conn-level packets */
@@ -452,7 +446,6 @@ struct rxrpc_connection {
 	unsigned long		events;
 	unsigned long		idle_timestamp;	/* Time at which last became idle */
 	spinlock_t		state_lock;	/* state-change lock */
-	enum rxrpc_conn_cache_state cache_state;
 	enum rxrpc_conn_proto_state state;	/* current state of connection */
 	u32			abort_code;	/* Abort code of connection abort */
 	int			debug_id;	/* debug ID for printks */
@@ -464,6 +457,7 @@ struct rxrpc_connection {
 	u8			security_size;	/* security header size */
 	u8			security_ix;	/* security type */
 	u8			out_clientflag;	/* RXRPC_CLIENT_INITIATED if we are client */
+	u8			bundle_shift;	/* Index into bundle->avail_chans */
 	short			error;		/* Local error code */
 };
 
@@ -494,6 +488,7 @@ enum rxrpc_call_flag {
 	RXRPC_CALL_RX_UNDERRUN,		/* Got data underrun */
 	RXRPC_CALL_DISCONNECTED,	/* The call has been disconnected */
 	RXRPC_CALL_KERNEL,		/* The call was made by the kernel */
+	RXRPC_CALL_UPGRADE,		/* Service upgrade was requested for the call */
 };
 
 /*
@@ -578,7 +573,7 @@ struct rxrpc_call {
 	struct work_struct	processor;	/* Event processor */
 	rxrpc_notify_rx_t	notify_rx;	/* kernel service Rx notification function */
 	struct list_head	link;		/* link in master call list */
-	struct list_head	chan_wait_link;	/* Link in conn->waiting_calls */
+	struct list_head	chan_wait_link;	/* Link in conn->bundle->waiting_calls */
 	struct hlist_node	error_link;	/* link in error distribution list */
 	struct list_head	accept_link;	/* Link in rx->acceptq */
 	struct list_head	recvmsg_link;	/* Link in rx->recvmsg_q */
@@ -817,18 +812,19 @@ static inline bool rxrpc_is_client_call(const struct rxrpc_call *call)
 /*
  * conn_client.c
  */
-extern unsigned int rxrpc_max_client_connections;
 extern unsigned int rxrpc_reap_client_connections;
 extern unsigned long rxrpc_conn_idle_client_expiry;
 extern unsigned long rxrpc_conn_idle_client_fast_expiry;
 extern struct idr rxrpc_client_conn_ids;
 
 void rxrpc_destroy_client_conn_ids(void);
+struct rxrpc_bundle *rxrpc_get_bundle(struct rxrpc_bundle *);
+void rxrpc_put_bundle(struct rxrpc_bundle *);
 int rxrpc_connect_call(struct rxrpc_sock *, struct rxrpc_call *,
 		       struct rxrpc_conn_parameters *, struct sockaddr_rxrpc *,
 		       gfp_t);
 void rxrpc_expose_client_call(struct rxrpc_call *);
-void rxrpc_disconnect_client_call(struct rxrpc_call *);
+void rxrpc_disconnect_client_call(struct rxrpc_bundle *, struct rxrpc_call *);
 void rxrpc_put_client_conn(struct rxrpc_connection *);
 void rxrpc_discard_expired_client_conns(struct work_struct *);
 void rxrpc_destroy_all_client_connections(struct rxrpc_net *);
@@ -854,7 +850,7 @@ void rxrpc_disconnect_call(struct rxrpc_call *);
 void rxrpc_kill_connection(struct rxrpc_connection *);
 bool rxrpc_queue_conn(struct rxrpc_connection *);
 void rxrpc_see_connection(struct rxrpc_connection *);
-void rxrpc_get_connection(struct rxrpc_connection *);
+struct rxrpc_connection *rxrpc_get_connection(struct rxrpc_connection *);
 struct rxrpc_connection *rxrpc_get_connection_maybe(struct rxrpc_connection *);
 void rxrpc_put_service_conn(struct rxrpc_connection *);
 void rxrpc_service_connection_reaper(struct work_struct *);
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index 159e3eda7914..8b41c87b3333 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -1,63 +1,15 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /* Client connection-specific management code.
  *
- * Copyright (C) 2016 Red Hat, Inc. All Rights Reserved.
+ * Copyright (C) 2016, 2020 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
  *
  * Client connections need to be cached for a little while after they've made a
  * call so as to handle retransmitted DATA packets in case the server didn't
  * receive the final ACK or terminating ABORT we sent it.
  *
- * Client connections can be in one of a number of cache states:
- *
- *  (1) INACTIVE - The connection is not held in any list and may not have been
- *      exposed to the world.  If it has been previously exposed, it was
- *      discarded from the idle list after expiring.
- *
- *  (2) WAITING - The connection is waiting for the number of client conns to
- *      drop below the maximum capacity.  Calls may be in progress upon it from
- *      when it was active and got culled.
- *
- *	The connection is on the rxrpc_waiting_client_conns list which is kept
- *	in to-be-granted order.  Culled conns with waiters go to the back of
- *	the queue just like new conns.
- *
- *  (3) ACTIVE - The connection has at least one call in progress upon it, it
- *      may freely grant available channels to new calls and calls may be
- *      waiting on it for channels to become available.
- *
- *	The connection is on the rxnet->active_client_conns list which is kept
- *	in activation order for culling purposes.
- *
- *	rxrpc_nr_active_client_conns is held incremented also.
- *
- *  (4) UPGRADE - As for ACTIVE, but only one call may be in progress and is
- *      being used to probe for service upgrade.
- *
- *  (5) CULLED - The connection got summarily culled to try and free up
- *      capacity.  Calls currently in progress on the connection are allowed to
- *      continue, but new calls will have to wait.  There can be no waiters in
- *      this state - the conn would have to go to the WAITING state instead.
- *
- *  (6) IDLE - The connection has no calls in progress upon it and must have
- *      been exposed to the world (ie. the EXPOSED flag must be set).  When it
- *      expires, the EXPOSED flag is cleared and the connection transitions to
- *      the INACTIVE state.
- *
- *	The connection is on the rxnet->idle_client_conns list which is kept in
- *	order of how soon they'll expire.
- *
  * There are flags of relevance to the cache:
  *
- *  (1) EXPOSED - The connection ID got exposed to the world.  If this flag is
- *      set, an extra ref is added to the connection preventing it from being
- *      reaped when it has no calls outstanding.  This flag is cleared and the
- *      ref dropped when a conn is discarded from the idle list.
- *
- *      This allows us to move terminal call state retransmission to the
- *      connection and to discard the call immediately we think it is done
- *      with.  It also give us a chance to reuse the connection.
- *
  *  (2) DONT_REUSE - The connection should be discarded as soon as possible and
  *      should not be reused.  This is set when an exclusive connection is used
  *      or a call ID counter overflows.
@@ -78,7 +30,6 @@
 
 #include "ar-internal.h"
 
-__read_mostly unsigned int rxrpc_max_client_connections = 1000;
 __read_mostly unsigned int rxrpc_reap_client_connections = 900;
 __read_mostly unsigned long rxrpc_conn_idle_client_expiry = 2 * 60 * HZ;
 __read_mostly unsigned long rxrpc_conn_idle_client_fast_expiry = 2 * HZ;
@@ -89,8 +40,6 @@ __read_mostly unsigned long rxrpc_conn_idle_client_fast_expiry = 2 * HZ;
 DEFINE_IDR(rxrpc_client_conn_ids);
 static DEFINE_SPINLOCK(rxrpc_conn_id_lock);
 
-static void rxrpc_cull_active_client_conns(struct rxrpc_net *);
-
 /*
  * Get a connection ID and epoch for a client connection from the global pool.
  * The connection struct pointer is then recorded in the idr radix tree.  The
@@ -161,14 +110,51 @@ void rxrpc_destroy_client_conn_ids(void)
 	idr_destroy(&rxrpc_client_conn_ids);
 }
 
+/*
+ * Allocate a connection bundle.
+ */
+static struct rxrpc_bundle *rxrpc_alloc_bundle(struct rxrpc_conn_parameters *cp,
+					       gfp_t gfp)
+{
+	struct rxrpc_bundle *bundle;
+
+	bundle = kzalloc(sizeof(*bundle), gfp);
+	if (bundle) {
+		bundle->params = *cp;
+		rxrpc_get_peer(bundle->params.peer);
+		atomic_set(&bundle->usage, 1);
+		spin_lock_init(&bundle->channel_lock);
+		INIT_LIST_HEAD(&bundle->waiting_calls);
+	}
+	return bundle;
+}
+
+struct rxrpc_bundle *rxrpc_get_bundle(struct rxrpc_bundle *bundle)
+{
+	atomic_inc(&bundle->usage);
+	return bundle;
+}
+
+void rxrpc_put_bundle(struct rxrpc_bundle *bundle)
+{
+	unsigned int d = bundle->debug_id;
+	unsigned int u = atomic_dec_return(&bundle->usage);
+
+	_debug("PUT B=%x %u", d, u);
+	if (u == 0) {
+		rxrpc_put_peer(bundle->params.peer);
+		kfree(bundle);
+	}
+}
+
 /*
  * Allocate a client connection.
  */
 static struct rxrpc_connection *
-rxrpc_alloc_client_connection(struct rxrpc_conn_parameters *cp, gfp_t gfp)
+rxrpc_alloc_client_connection(struct rxrpc_bundle *bundle, gfp_t gfp)
 {
 	struct rxrpc_connection *conn;
-	struct rxrpc_net *rxnet = cp->local->rxnet;
+	struct rxrpc_net *rxnet = bundle->params.local->rxnet;
 	int ret;
 
 	_enter("");
@@ -180,15 +166,11 @@ rxrpc_alloc_client_connection(struct rxrpc_conn_parameters *cp, gfp_t gfp)
 	}
 
 	atomic_set(&conn->usage, 1);
-	if (cp->exclusive)
-		__set_bit(RXRPC_CONN_DONT_REUSE, &conn->flags);
-	if (cp->upgrade)
-		__set_bit(RXRPC_CONN_PROBING_FOR_UPGRADE, &conn->flags);
-
-	conn->params		= *cp;
+	conn->bundle		= bundle;
+	conn->params		= bundle->params;
 	conn->out_clientflag	= RXRPC_CLIENT_INITIATED;
 	conn->state		= RXRPC_CONN_CLIENT;
-	conn->service_id	= cp->service_id;
+	conn->service_id	= conn->params.service_id;
 
 	ret = rxrpc_get_client_connection_id(conn, gfp);
 	if (ret < 0)
@@ -207,14 +189,16 @@ rxrpc_alloc_client_connection(struct rxrpc_conn_parameters *cp, gfp_t gfp)
 	list_add_tail(&conn->proc_link, &rxnet->conn_proc_list);
 	write_unlock(&rxnet->conn_lock);
 
-	/* We steal the caller's peer ref. */
-	cp->peer = NULL;
+	rxrpc_get_bundle(bundle);
+	rxrpc_get_peer(conn->params.peer);
 	rxrpc_get_local(conn->params.local);
 	key_get(conn->params.key);
 
 	trace_rxrpc_conn(conn->debug_id, rxrpc_conn_new_client,
 			 atomic_read(&conn->usage),
 			 __builtin_return_address(0));
+
+	atomic_inc(&rxnet->nr_client_conns);
 	trace_rxrpc_client(conn, -1, rxrpc_client_alloc);
 	_leave(" = %p", conn);
 	return conn;
@@ -234,13 +218,18 @@ rxrpc_alloc_client_connection(struct rxrpc_conn_parameters *cp, gfp_t gfp)
  */
 static bool rxrpc_may_reuse_conn(struct rxrpc_connection *conn)
 {
-	struct rxrpc_net *rxnet = conn->params.local->rxnet;
+	struct rxrpc_net *rxnet;
 	int id_cursor, id, distance, limit;
 
+	if (!conn)
+		goto dont_reuse;
+
+	rxnet = conn->params.local->rxnet;
 	if (test_bit(RXRPC_CONN_DONT_REUSE, &conn->flags))
 		goto dont_reuse;
 
-	if (conn->proto.epoch != rxnet->epoch)
+	if (conn->state != RXRPC_CONN_CLIENT ||
+	    conn->proto.epoch != rxnet->epoch)
 		goto mark_dont_reuse;
 
 	/* The IDR tree gets very expensive on memory if the connection IDs are
@@ -254,7 +243,7 @@ static bool rxrpc_may_reuse_conn(struct rxrpc_connection *conn)
 	distance = id - id_cursor;
 	if (distance < 0)
 		distance = -distance;
-	limit = max(rxrpc_max_client_connections * 4, 1024U);
+	limit = max_t(unsigned long, atomic_read(&rxnet->nr_conns) * 4, 1024);
 	if (distance > limit)
 		goto mark_dont_reuse;
 
@@ -267,277 +256,242 @@ static bool rxrpc_may_reuse_conn(struct rxrpc_connection *conn)
 }
 
 /*
- * Create or find a client connection to use for a call.
- *
- * If we return with a connection, the call will be on its waiting list.  It's
- * left to the caller to assign a channel and wake up the call.
+ * Look up the conn bundle that matches the connection parameters, adding it if
+ * it doesn't yet exist.
  */
-static int rxrpc_get_client_conn(struct rxrpc_sock *rx,
-				 struct rxrpc_call *call,
-				 struct rxrpc_conn_parameters *cp,
-				 struct sockaddr_rxrpc *srx,
-				 gfp_t gfp)
+static struct rxrpc_bundle *rxrpc_look_up_bundle(struct rxrpc_conn_parameters *cp,
+						 gfp_t gfp)
 {
-	struct rxrpc_connection *conn, *candidate = NULL;
+	static atomic_t rxrpc_bundle_id;
+	struct rxrpc_bundle *bundle, *candidate;
 	struct rxrpc_local *local = cp->local;
 	struct rb_node *p, **pp, *parent;
 	long diff;
-	int ret = -ENOMEM;
 
-	_enter("{%d,%lx},", call->debug_id, call->user_call_ID);
+	_enter("{%px,%x,%u,%u}",
+	       cp->peer, key_serial(cp->key), cp->security_level, cp->upgrade);
 
-	cp->peer = rxrpc_lookup_peer(rx, cp->local, srx, gfp);
-	if (!cp->peer)
-		goto error;
+	if (cp->exclusive)
+		return rxrpc_alloc_bundle(cp, gfp);
 
-	call->cong_cwnd = cp->peer->cong_cwnd;
-	if (call->cong_cwnd >= call->cong_ssthresh)
-		call->cong_mode = RXRPC_CALL_CONGEST_AVOIDANCE;
-	else
-		call->cong_mode = RXRPC_CALL_SLOW_START;
+	/* First, see if the bundle is already there. */
+	_debug("search 1");
+	spin_lock(&local->client_bundles_lock);
+	p = local->client_bundles.rb_node;
+	while (p) {
+		bundle = rb_entry(p, struct rxrpc_bundle, local_node);
 
-	/* If the connection is not meant to be exclusive, search the available
-	 * connections to see if the connection we want to use already exists.
-	 */
-	if (!cp->exclusive) {
-		_debug("search 1");
-		spin_lock(&local->client_conns_lock);
-		p = local->client_conns.rb_node;
-		while (p) {
-			conn = rb_entry(p, struct rxrpc_connection, client_node);
-
-#define cmp(X) ((long)conn->params.X - (long)cp->X)
-			diff = (cmp(peer) ?:
-				cmp(key) ?:
-				cmp(security_level) ?:
-				cmp(upgrade));
+#define cmp(X) ((long)bundle->params.X - (long)cp->X)
+		diff = (cmp(peer) ?:
+			cmp(key) ?:
+			cmp(security_level) ?:
+			cmp(upgrade));
 #undef cmp
-			if (diff < 0) {
-				p = p->rb_left;
-			} else if (diff > 0) {
-				p = p->rb_right;
-			} else {
-				if (rxrpc_may_reuse_conn(conn) &&
-				    rxrpc_get_connection_maybe(conn))
-					goto found_extant_conn;
-				/* The connection needs replacing.  It's better
-				 * to effect that when we have something to
-				 * replace it with so that we don't have to
-				 * rebalance the tree twice.
-				 */
-				break;
-			}
-		}
-		spin_unlock(&local->client_conns_lock);
-	}
-
-	/* There wasn't a connection yet or we need an exclusive connection.
-	 * We need to create a candidate and then potentially redo the search
-	 * in case we're racing with another thread also trying to connect on a
-	 * shareable connection.
-	 */
-	_debug("new conn");
-	candidate = rxrpc_alloc_client_connection(cp, gfp);
-	if (IS_ERR(candidate)) {
-		ret = PTR_ERR(candidate);
-		goto error_peer;
+		if (diff < 0)
+			p = p->rb_left;
+		else if (diff > 0)
+			p = p->rb_right;
+		else
+			goto found_bundle;
 	}
+	spin_unlock(&local->client_bundles_lock);
+	_debug("not found");
 
-	/* Add the call to the new connection's waiting list in case we're
-	 * going to have to wait for the connection to come live.  It's our
-	 * connection, so we want first dibs on the channel slots.  We would
-	 * normally have to take channel_lock but we do this before anyone else
-	 * can see the connection.
-	 */
-	list_add(&call->chan_wait_link, &candidate->waiting_calls);
-
-	if (cp->exclusive) {
-		call->conn = candidate;
-		call->security = candidate->security;
-		call->security_ix = candidate->security_ix;
-		call->service_id = candidate->service_id;
-		_leave(" = 0 [exclusive %d]", candidate->debug_id);
-		return 0;
-	}
+	/* It wasn't.  We need to add one. */
+	candidate = rxrpc_alloc_bundle(cp, gfp);
+	if (!candidate)
+		return NULL;
 
-	/* Publish the new connection for userspace to find.  We need to redo
-	 * the search before doing this lest we race with someone else adding a
-	 * conflicting instance.
-	 */
 	_debug("search 2");
-	spin_lock(&local->client_conns_lock);
-
-	pp = &local->client_conns.rb_node;
+	spin_lock(&local->client_bundles_lock);
+	pp = &local->client_bundles.rb_node;
 	parent = NULL;
 	while (*pp) {
 		parent = *pp;
-		conn = rb_entry(parent, struct rxrpc_connection, client_node);
+		bundle = rb_entry(parent, struct rxrpc_bundle, local_node);
 
-#define cmp(X) ((long)conn->params.X - (long)candidate->params.X)
+#define cmp(X) ((long)bundle->params.X - (long)cp->X)
 		diff = (cmp(peer) ?:
 			cmp(key) ?:
 			cmp(security_level) ?:
 			cmp(upgrade));
 #undef cmp
-		if (diff < 0) {
+		if (diff < 0)
 			pp = &(*pp)->rb_left;
-		} else if (diff > 0) {
+		else if (diff > 0)
 			pp = &(*pp)->rb_right;
-		} else {
-			if (rxrpc_may_reuse_conn(conn) &&
-			    rxrpc_get_connection_maybe(conn))
-				goto found_extant_conn;
-			/* The old connection is from an outdated epoch. */
-			_debug("replace conn");
-			clear_bit(RXRPC_CONN_IN_CLIENT_CONNS, &conn->flags);
-			rb_replace_node(&conn->client_node,
-					&candidate->client_node,
-					&local->client_conns);
-			trace_rxrpc_client(conn, -1, rxrpc_client_replace);
-			goto candidate_published;
-		}
+		else
+			goto found_bundle_free;
 	}
 
-	_debug("new conn");
-	rb_link_node(&candidate->client_node, parent, pp);
-	rb_insert_color(&candidate->client_node, &local->client_conns);
-
-candidate_published:
-	set_bit(RXRPC_CONN_IN_CLIENT_CONNS, &candidate->flags);
-	call->conn = candidate;
-	call->security = candidate->security;
-	call->security_ix = candidate->security_ix;
-	call->service_id = candidate->service_id;
-	spin_unlock(&local->client_conns_lock);
-	_leave(" = 0 [new %d]", candidate->debug_id);
-	return 0;
+	_debug("new bundle");
+	candidate->debug_id = atomic_inc_return(&rxrpc_bundle_id);
+	rb_link_node(&candidate->local_node, parent, pp);
+	rb_insert_color(&candidate->local_node, &local->client_bundles);
+	rxrpc_get_bundle(candidate);
+	spin_unlock(&local->client_bundles_lock);
+	_leave(" = %u [new]", candidate->debug_id);
+	return candidate;
+
+found_bundle_free:
+	kfree(candidate);
+found_bundle:
+	rxrpc_get_bundle(bundle);
+	spin_unlock(&local->client_bundles_lock);
+	_leave(" = %u [found]", bundle->debug_id);
+	return bundle;
+}
 
-	/* We come here if we found a suitable connection already in existence.
-	 * Discard any candidate we may have allocated, and try to get a
-	 * channel on this one.
-	 */
-found_extant_conn:
-	_debug("found conn");
-	spin_unlock(&local->client_conns_lock);
+/*
+ * Create or find a client bundle to use for a call.
+ *
+ * If we return with a connection, the call will be on its waiting list.  It's
+ * left to the caller to assign a channel and wake up the call.
+ */
+static struct rxrpc_bundle *rxrpc_prep_call(struct rxrpc_sock *rx,
+					    struct rxrpc_call *call,
+					    struct rxrpc_conn_parameters *cp,
+					    struct sockaddr_rxrpc *srx,
+					    gfp_t gfp)
+{
+	struct rxrpc_bundle *bundle;
 
-	if (candidate) {
-		trace_rxrpc_client(candidate, -1, rxrpc_client_duplicate);
-		rxrpc_put_connection(candidate);
-		candidate = NULL;
-	}
+	_enter("{%d,%lx},", call->debug_id, call->user_call_ID);
 
-	spin_lock(&conn->channel_lock);
-	call->conn = conn;
-	call->security = conn->security;
-	call->security_ix = conn->security_ix;
-	call->service_id = conn->service_id;
-	list_add_tail(&call->chan_wait_link, &conn->waiting_calls);
-	spin_unlock(&conn->channel_lock);
-	_leave(" = 0 [extant %d]", conn->debug_id);
-	return 0;
+	cp->peer = rxrpc_lookup_peer(rx, cp->local, srx, gfp);
+	if (!cp->peer)
+		goto error;
+
+	call->cong_cwnd = cp->peer->cong_cwnd;
+	if (call->cong_cwnd >= call->cong_ssthresh)
+		call->cong_mode = RXRPC_CALL_CONGEST_AVOIDANCE;
+	else
+		call->cong_mode = RXRPC_CALL_SLOW_START;
+	if (cp->upgrade)
+		__set_bit(RXRPC_CALL_UPGRADE, &call->flags);
+
+	/* Find the client connection bundle. */
+	bundle = rxrpc_look_up_bundle(cp, gfp);
+	if (!bundle)
+		goto error;
+
+	/* Get this call queued.  Someone else may activate it whilst we're
+	 * lining up a new connection, but that's fine.
+	 */
+	spin_lock(&bundle->channel_lock);
+	list_add_tail(&call->chan_wait_link, &bundle->waiting_calls);
+	spin_unlock(&bundle->channel_lock);
+
+	_leave(" = [B=%x]", bundle->debug_id);
+	return bundle;
 
-error_peer:
-	rxrpc_put_peer(cp->peer);
-	cp->peer = NULL;
 error:
-	_leave(" = %d", ret);
-	return ret;
+	_leave(" = -ENOMEM");
+	return ERR_PTR(-ENOMEM);
 }
 
 /*
- * Activate a connection.
+ * Allocate a new connection and add it into a bundle.
  */
-static void rxrpc_activate_conn(struct rxrpc_net *rxnet,
-				struct rxrpc_connection *conn)
+static void rxrpc_add_conn_to_bundle(struct rxrpc_bundle *bundle, gfp_t gfp)
+	__releases(bundle->channel_lock)
 {
-	if (test_bit(RXRPC_CONN_PROBING_FOR_UPGRADE, &conn->flags)) {
-		trace_rxrpc_client(conn, -1, rxrpc_client_to_upgrade);
-		conn->cache_state = RXRPC_CONN_CLIENT_UPGRADE;
-	} else {
-		trace_rxrpc_client(conn, -1, rxrpc_client_to_active);
-		conn->cache_state = RXRPC_CONN_CLIENT_ACTIVE;
-	}
-	rxnet->nr_active_client_conns++;
-	list_move_tail(&conn->cache_link, &rxnet->active_client_conns);
-}
+	struct rxrpc_connection *candidate = NULL, *old = NULL;
+	bool conflict;
+	int i;
 
-/*
- * Attempt to animate a connection for a new call.
- *
- * If it's not exclusive, the connection is in the endpoint tree, and we're in
- * the conn's list of those waiting to grab a channel.  There is, however, a
- * limit on the number of live connections allowed at any one time, so we may
- * have to wait for capacity to become available.
- *
- * Note that a connection on the waiting queue might *also* have active
- * channels if it has been culled to make space and then re-requested by a new
- * call.
- */
-static void rxrpc_animate_client_conn(struct rxrpc_net *rxnet,
-				      struct rxrpc_connection *conn)
-{
-	unsigned int nr_conns;
+	_enter("");
 
-	_enter("%d,%d", conn->debug_id, conn->cache_state);
+	conflict = bundle->alloc_conn;
+	if (!conflict)
+		bundle->alloc_conn = true;
+	spin_unlock(&bundle->channel_lock);
+	if (conflict) {
+		_leave(" [conf]");
+		return;
+	}
 
-	if (conn->cache_state == RXRPC_CONN_CLIENT_ACTIVE ||
-	    conn->cache_state == RXRPC_CONN_CLIENT_UPGRADE)
-		goto out;
+	candidate = rxrpc_alloc_client_connection(bundle, gfp);
 
-	spin_lock(&rxnet->client_conn_cache_lock);
+	spin_lock(&bundle->channel_lock);
+	bundle->alloc_conn = false;
 
-	nr_conns = rxnet->nr_client_conns;
-	if (!test_and_set_bit(RXRPC_CONN_COUNTED, &conn->flags)) {
-		trace_rxrpc_client(conn, -1, rxrpc_client_count);
-		rxnet->nr_client_conns = nr_conns + 1;
+	if (IS_ERR(candidate)) {
+		bundle->alloc_error = PTR_ERR(candidate);
+		spin_unlock(&bundle->channel_lock);
+		_leave(" [err %ld]", PTR_ERR(candidate));
+		return;
 	}
 
-	switch (conn->cache_state) {
-	case RXRPC_CONN_CLIENT_ACTIVE:
-	case RXRPC_CONN_CLIENT_UPGRADE:
-	case RXRPC_CONN_CLIENT_WAITING:
-		break;
-
-	case RXRPC_CONN_CLIENT_INACTIVE:
-	case RXRPC_CONN_CLIENT_CULLED:
-	case RXRPC_CONN_CLIENT_IDLE:
-		if (nr_conns >= rxrpc_max_client_connections)
-			goto wait_for_capacity;
-		goto activate_conn;
+	bundle->alloc_error = 0;
+
+	for (i = 0; i < ARRAY_SIZE(bundle->conns); i++) {
+		unsigned int shift = i * RXRPC_MAXCALLS;
+		int j;
+
+		old = bundle->conns[i];
+		if (!rxrpc_may_reuse_conn(old)) {
+			if (old)
+				trace_rxrpc_client(old, -1, rxrpc_client_replace);
+			candidate->bundle = rxrpc_get_bundle(bundle);
+			candidate->bundle_shift = shift;
+			bundle->conns[i] = candidate;
+			for (j = 0; j < RXRPC_MAXCALLS; j++)
+				set_bit(shift + j, &bundle->avail_chans);
+			candidate = NULL;
+			break;
+		}
 
-	default:
-		BUG();
+		old = NULL;
 	}
 
-out_unlock:
-	spin_unlock(&rxnet->client_conn_cache_lock);
-out:
-	_leave(" [%d]", conn->cache_state);
-	return;
+	spin_unlock(&bundle->channel_lock);
 
-activate_conn:
-	_debug("activate");
-	rxrpc_activate_conn(rxnet, conn);
-	goto out_unlock;
-
-wait_for_capacity:
-	_debug("wait");
-	trace_rxrpc_client(conn, -1, rxrpc_client_to_waiting);
-	conn->cache_state = RXRPC_CONN_CLIENT_WAITING;
-	list_move_tail(&conn->cache_link, &rxnet->waiting_client_conns);
-	goto out_unlock;
+	if (candidate) {
+		_debug("discard C=%x", candidate->debug_id);
+		trace_rxrpc_client(candidate, -1, rxrpc_client_duplicate);
+		rxrpc_put_connection(candidate);
+	}
+
+	rxrpc_put_connection(old);
+	_leave("");
 }
 
 /*
- * Deactivate a channel.
+ * Add a connection to a bundle if there are no usable connections or we have
+ * connections waiting for extra capacity.
  */
-static void rxrpc_deactivate_one_channel(struct rxrpc_connection *conn,
-					 unsigned int channel)
+static void rxrpc_maybe_add_conn(struct rxrpc_bundle *bundle, gfp_t gfp)
 {
-	struct rxrpc_channel *chan = &conn->channels[channel];
+	struct rxrpc_call *call;
+	int i, usable;
 
-	rcu_assign_pointer(chan->call, NULL);
-	conn->active_chans &= ~(1 << channel);
+	_enter("");
+
+	spin_lock(&bundle->channel_lock);
+
+	/* See if there are any usable connections. */
+	usable = 0;
+	for (i = 0; i < ARRAY_SIZE(bundle->conns); i++)
+		if (rxrpc_may_reuse_conn(bundle->conns[i]))
+			usable++;
+
+	if (!usable && !list_empty(&bundle->waiting_calls)) {
+		call = list_first_entry(&bundle->waiting_calls,
+					struct rxrpc_call, chan_wait_link);
+		if (test_bit(RXRPC_CALL_UPGRADE, &call->flags))
+			bundle->try_upgrade = true;
+	}
+
+	if (!usable)
+		goto alloc_conn;
+
+	spin_unlock(&bundle->channel_lock);
+	_leave("");
+	return;
+
+alloc_conn:
+	return rxrpc_add_conn_to_bundle(bundle, gfp);
 }
 
 /*
@@ -549,35 +503,42 @@ static void rxrpc_activate_one_channel(struct rxrpc_connection *conn,
 				       unsigned int channel)
 {
 	struct rxrpc_channel *chan = &conn->channels[channel];
-	struct rxrpc_call *call = list_entry(conn->waiting_calls.next,
+	struct rxrpc_bundle *bundle = conn->bundle;
+	struct rxrpc_call *call = list_entry(bundle->waiting_calls.next,
 					     struct rxrpc_call, chan_wait_link);
 	u32 call_id = chan->call_counter + 1;
 
+	_enter("C=%x,%u", conn->debug_id, channel);
+
 	trace_rxrpc_client(conn, channel, rxrpc_client_chan_activate);
 
 	/* Cancel the final ACK on the previous call if it hasn't been sent yet
 	 * as the DATA packet will implicitly ACK it.
 	 */
 	clear_bit(RXRPC_CONN_FINAL_ACK_0 + channel, &conn->flags);
-
-	write_lock_bh(&call->state_lock);
-	call->state = RXRPC_CALL_CLIENT_SEND_REQUEST;
-	write_unlock_bh(&call->state_lock);
+	clear_bit(conn->bundle_shift + channel, &bundle->avail_chans);
 
 	rxrpc_see_call(call);
 	list_del_init(&call->chan_wait_link);
-	conn->active_chans |= 1 << channel;
 	call->peer	= rxrpc_get_peer(conn->params.peer);
+	call->conn	= rxrpc_get_connection(conn);
 	call->cid	= conn->proto.cid | channel;
 	call->call_id	= call_id;
+	call->security	= conn->security;
+	call->security_ix = conn->security_ix;
+	call->service_id = conn->service_id;
 
 	trace_rxrpc_connect_call(call);
 	_net("CONNECT call %08x:%08x as call %d on conn %d",
 	     call->cid, call->call_id, call->debug_id, conn->debug_id);
 
-	/* Paired with the read barrier in rxrpc_wait_for_channel().  This
-	 * orders cid and epoch in the connection wrt to call_id without the
-	 * need to take the channel_lock.
+	write_lock_bh(&call->state_lock);
+	call->state = RXRPC_CALL_CLIENT_SEND_REQUEST;
+	write_unlock_bh(&call->state_lock);
+
+	/* Paired with the read barrier in rxrpc_connect_call().  This orders
+	 * cid and epoch in the connection wrt to call_id without the need to
+	 * take the channel_lock.
 	 *
 	 * We provisionally assign a callNumber at this point, but we don't
 	 * confirm it until the call is about to be exposed.
@@ -586,101 +547,137 @@ static void rxrpc_activate_one_channel(struct rxrpc_connection *conn,
 	 * at the call ID through a connection channel.
 	 */
 	smp_wmb();
-	chan->call_id	= call_id;
-	chan->call_debug_id = call->debug_id;
+
+	chan->call_id		= call_id;
+	chan->call_debug_id	= call->debug_id;
 	rcu_assign_pointer(chan->call, call);
 	wake_up(&call->waitq);
 }
 
+/*
+ * Remove a connection from the idle list if it's on it.
+ */
+static void rxrpc_unidle_conn(struct rxrpc_bundle *bundle, struct rxrpc_connection *conn)
+{
+	struct rxrpc_net *rxnet = bundle->params.local->rxnet;
+	bool drop_ref;
+
+	if (!list_empty(&conn->cache_link)) {
+		drop_ref = false;
+		spin_lock(&rxnet->client_conn_cache_lock);
+		if (!list_empty(&conn->cache_link)) {
+			list_del_init(&conn->cache_link);
+			drop_ref = true;
+		}
+		spin_unlock(&rxnet->client_conn_cache_lock);
+		if (drop_ref)
+			rxrpc_put_connection(conn);
+	}
+}
+
 /*
  * Assign channels and callNumbers to waiting calls with channel_lock
  * held by caller.
  */
-static void rxrpc_activate_channels_locked(struct rxrpc_connection *conn)
+static void rxrpc_activate_channels_locked(struct rxrpc_bundle *bundle)
 {
-	u8 avail, mask;
-
-	switch (conn->cache_state) {
-	case RXRPC_CONN_CLIENT_ACTIVE:
-		mask = RXRPC_ACTIVE_CHANS_MASK;
-		break;
-	case RXRPC_CONN_CLIENT_UPGRADE:
-		mask = 0x01;
-		break;
-	default:
-		return;
-	}
+	struct rxrpc_connection *conn;
+	unsigned long avail, mask;
+	unsigned int channel, slot;
 
-	while (!list_empty(&conn->waiting_calls) &&
-	       (avail = ~conn->active_chans,
-		avail &= mask,
-		avail != 0))
-		rxrpc_activate_one_channel(conn, __ffs(avail));
+	if (bundle->try_upgrade)
+		mask = 1;
+	else
+		mask = ULONG_MAX;
+
+	while (!list_empty(&bundle->waiting_calls)) {
+		avail = bundle->avail_chans & mask;
+		if (!avail)
+			break;
+		channel = __ffs(avail);
+		clear_bit(channel, &bundle->avail_chans);
+
+		slot = channel / RXRPC_MAXCALLS;
+		conn = bundle->conns[slot];
+		if (!conn)
+			break;
+
+		if (bundle->try_upgrade)
+			set_bit(RXRPC_CONN_PROBING_FOR_UPGRADE, &conn->flags);
+		rxrpc_unidle_conn(bundle, conn);
+
+		channel &= (RXRPC_MAXCALLS - 1);
+		conn->act_chans	|= 1 << channel;
+		rxrpc_activate_one_channel(conn, channel);
+	}
 }
 
 /*
  * Assign channels and callNumbers to waiting calls.
  */
-static void rxrpc_activate_channels(struct rxrpc_connection *conn)
+static void rxrpc_activate_channels(struct rxrpc_bundle *bundle)
 {
-	_enter("%d", conn->debug_id);
+	_enter("B=%x", bundle->debug_id);
 
-	trace_rxrpc_client(conn, -1, rxrpc_client_activate_chans);
+	trace_rxrpc_client(NULL, -1, rxrpc_client_activate_chans);
 
-	if (conn->active_chans == RXRPC_ACTIVE_CHANS_MASK)
+	if (!bundle->avail_chans)
 		return;
 
-	spin_lock(&conn->channel_lock);
-	rxrpc_activate_channels_locked(conn);
-	spin_unlock(&conn->channel_lock);
+	spin_lock(&bundle->channel_lock);
+	rxrpc_activate_channels_locked(bundle);
+	spin_unlock(&bundle->channel_lock);
 	_leave("");
 }
 
 /*
  * Wait for a callNumber and a channel to be granted to a call.
  */
-static int rxrpc_wait_for_channel(struct rxrpc_call *call, gfp_t gfp)
+static int rxrpc_wait_for_channel(struct rxrpc_bundle *bundle,
+				  struct rxrpc_call *call, gfp_t gfp)
 {
+	DECLARE_WAITQUEUE(myself, current);
 	int ret = 0;
 
 	_enter("%d", call->debug_id);
 
-	if (!call->call_id) {
-		DECLARE_WAITQUEUE(myself, current);
+	if (!gfpflags_allow_blocking(gfp)) {
+		rxrpc_maybe_add_conn(bundle, gfp);
+		rxrpc_activate_channels(bundle);
+		ret = bundle->alloc_error ?: -EAGAIN;
+		goto out;
+	}
 
-		if (!gfpflags_allow_blocking(gfp)) {
-			ret = -EAGAIN;
-			goto out;
+	add_wait_queue_exclusive(&call->waitq, &myself);
+	for (;;) {
+		rxrpc_maybe_add_conn(bundle, gfp);
+		rxrpc_activate_channels(bundle);
+		ret = bundle->alloc_error;
+		if (ret < 0)
+			break;
+
+		switch (call->interruptibility) {
+		case RXRPC_INTERRUPTIBLE:
+		case RXRPC_PREINTERRUPTIBLE:
+			set_current_state(TASK_INTERRUPTIBLE);
+			break;
+		case RXRPC_UNINTERRUPTIBLE:
+		default:
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			break;
 		}
-
-		add_wait_queue_exclusive(&call->waitq, &myself);
-		for (;;) {
-			switch (call->interruptibility) {
-			case RXRPC_INTERRUPTIBLE:
-			case RXRPC_PREINTERRUPTIBLE:
-				set_current_state(TASK_INTERRUPTIBLE);
-				break;
-			case RXRPC_UNINTERRUPTIBLE:
-			default:
-				set_current_state(TASK_UNINTERRUPTIBLE);
-				break;
-			}
-			if (call->call_id)
-				break;
-			if ((call->interruptibility == RXRPC_INTERRUPTIBLE ||
-			     call->interruptibility == RXRPC_PREINTERRUPTIBLE) &&
-			    signal_pending(current)) {
-				ret = -ERESTARTSYS;
-				break;
-			}
-			schedule();
+		if (READ_ONCE(call->state) != RXRPC_CALL_CLIENT_AWAIT_CONN)
+			break;
+		if ((call->interruptibility == RXRPC_INTERRUPTIBLE ||
+		     call->interruptibility == RXRPC_PREINTERRUPTIBLE) &&
+		    signal_pending(current)) {
+			ret = -ERESTARTSYS;
+			break;
 		}
-		remove_wait_queue(&call->waitq, &myself);
-		__set_current_state(TASK_RUNNING);
+		schedule();
 	}
-
-	/* Paired with the write barrier in rxrpc_activate_one_channel(). */
-	smp_rmb();
+	remove_wait_queue(&call->waitq, &myself);
+	__set_current_state(TASK_RUNNING);
 
 out:
 	_leave(" = %d", ret);
@@ -697,52 +694,49 @@ int rxrpc_connect_call(struct rxrpc_sock *rx,
 		       struct sockaddr_rxrpc *srx,
 		       gfp_t gfp)
 {
+	struct rxrpc_bundle *bundle;
 	struct rxrpc_net *rxnet = cp->local->rxnet;
-	int ret;
+	int ret = 0;
 
 	_enter("{%d,%lx},", call->debug_id, call->user_call_ID);
 
 	rxrpc_discard_expired_client_conns(&rxnet->client_conn_reaper);
-	rxrpc_cull_active_client_conns(rxnet);
 
-	ret = rxrpc_get_client_conn(rx, call, cp, srx, gfp);
-	if (ret < 0)
+	bundle = rxrpc_prep_call(rx, call, cp, srx, gfp);
+	if (IS_ERR(bundle)) {
+		ret = PTR_ERR(bundle);
 		goto out;
+	}
 
-	rxrpc_animate_client_conn(rxnet, call->conn);
-	rxrpc_activate_channels(call->conn);
-
-	ret = rxrpc_wait_for_channel(call, gfp);
-	if (ret < 0) {
-		trace_rxrpc_client(call->conn, ret, rxrpc_client_chan_wait_failed);
-		rxrpc_disconnect_client_call(call);
-		goto out;
+	if (call->state == RXRPC_CALL_CLIENT_AWAIT_CONN) {
+		ret = rxrpc_wait_for_channel(bundle, call, gfp);
+		if (ret < 0)
+			goto wait_failed;
 	}
 
-	spin_lock_bh(&call->conn->params.peer->lock);
-	hlist_add_head_rcu(&call->error_link,
-			   &call->conn->params.peer->error_targets);
-	spin_unlock_bh(&call->conn->params.peer->lock);
+granted_channel:
+	/* Paired with the write barrier in rxrpc_activate_one_channel(). */
+	smp_rmb();
 
 out:
+	rxrpc_put_bundle(bundle);
 	_leave(" = %d", ret);
 	return ret;
-}
 
-/*
- * Note that a connection is about to be exposed to the world.  Once it is
- * exposed, we maintain an extra ref on it that stops it from being summarily
- * discarded before it's (a) had a chance to deal with retransmission and (b)
- * had a chance at re-use (the per-connection security negotiation is
- * expensive).
- */
-static void rxrpc_expose_client_conn(struct rxrpc_connection *conn,
-				     unsigned int channel)
-{
-	if (!test_and_set_bit(RXRPC_CONN_EXPOSED, &conn->flags)) {
-		trace_rxrpc_client(conn, channel, rxrpc_client_exposed);
-		rxrpc_get_connection(conn);
+wait_failed:
+	spin_lock(&bundle->channel_lock);
+	list_del_init(&call->chan_wait_link);
+	spin_unlock(&bundle->channel_lock);
+
+	if (call->state != RXRPC_CALL_CLIENT_AWAIT_CONN) {
+		ret = 0;
+		goto granted_channel;
 	}
+
+	trace_rxrpc_client(call->conn, ret, rxrpc_client_chan_wait_failed);
+	rxrpc_set_call_completion(call, RXRPC_CALL_LOCAL_ERROR, 0, ret);
+	rxrpc_disconnect_client_call(bundle, call);
+	goto out;
 }
 
 /*
@@ -764,7 +758,7 @@ void rxrpc_expose_client_call(struct rxrpc_call *call)
 		chan->call_counter++;
 		if (chan->call_counter >= INT_MAX)
 			set_bit(RXRPC_CONN_DONT_REUSE, &conn->flags);
-		rxrpc_expose_client_conn(conn, channel);
+		trace_rxrpc_client(conn, channel, rxrpc_client_exposed);
 	}
 }
 
@@ -773,62 +767,56 @@ void rxrpc_expose_client_call(struct rxrpc_call *call)
  */
 static void rxrpc_set_client_reap_timer(struct rxrpc_net *rxnet)
 {
-	unsigned long now = jiffies;
-	unsigned long reap_at = now + rxrpc_conn_idle_client_expiry;
+	if (!rxnet->kill_all_client_conns) {
+		unsigned long now = jiffies;
+		unsigned long reap_at = now + rxrpc_conn_idle_client_expiry;
 
-	if (rxnet->live)
-		timer_reduce(&rxnet->client_conn_reap_timer, reap_at);
+		if (rxnet->live)
+			timer_reduce(&rxnet->client_conn_reap_timer, reap_at);
+	}
 }
 
 /*
  * Disconnect a client call.
  */
-void rxrpc_disconnect_client_call(struct rxrpc_call *call)
+void rxrpc_disconnect_client_call(struct rxrpc_bundle *bundle, struct rxrpc_call *call)
 {
-	struct rxrpc_connection *conn = call->conn;
+	struct rxrpc_connection *conn;
 	struct rxrpc_channel *chan = NULL;
-	struct rxrpc_net *rxnet = conn->params.local->rxnet;
-	unsigned int channel = -1;
+	struct rxrpc_net *rxnet = bundle->params.local->rxnet;
+	unsigned int channel;
+	bool may_reuse;
 	u32 cid;
 
-	spin_lock(&conn->channel_lock);
-	set_bit(RXRPC_CALL_DISCONNECTED, &call->flags);
+	_enter("c=%x", call->debug_id);
 
-	cid = call->cid;
-	if (cid) {
-		channel = cid & RXRPC_CHANNELMASK;
-		chan = &conn->channels[channel];
-	}
-	trace_rxrpc_client(conn, channel, rxrpc_client_chan_disconnect);
+	spin_lock(&bundle->channel_lock);
+	set_bit(RXRPC_CALL_DISCONNECTED, &call->flags);
 
 	/* Calls that have never actually been assigned a channel can simply be
-	 * discarded.  If the conn didn't get used either, it will follow
-	 * immediately unless someone else grabs it in the meantime.
+	 * discarded.
 	 */
-	if (!list_empty(&call->chan_wait_link)) {
+	conn = call->conn;
+	if (!conn) {
 		_debug("call is waiting");
 		ASSERTCMP(call->call_id, ==, 0);
 		ASSERT(!test_bit(RXRPC_CALL_EXPOSED, &call->flags));
 		list_del_init(&call->chan_wait_link);
-
-		trace_rxrpc_client(conn, channel, rxrpc_client_chan_unstarted);
-
-		/* We must deactivate or idle the connection if it's now
-		 * waiting for nothing.
-		 */
-		spin_lock(&rxnet->client_conn_cache_lock);
-		if (conn->cache_state == RXRPC_CONN_CLIENT_WAITING &&
-		    list_empty(&conn->waiting_calls) &&
-		    !conn->active_chans)
-			goto idle_connection;
 		goto out;
 	}
 
+	cid = call->cid;
+	channel = cid & RXRPC_CHANNELMASK;
+	chan = &conn->channels[channel];
+	trace_rxrpc_client(conn, channel, rxrpc_client_chan_disconnect);
+
 	if (rcu_access_pointer(chan->call) != call) {
-		spin_unlock(&conn->channel_lock);
+		spin_unlock(&bundle->channel_lock);
 		BUG();
 	}
 
+	may_reuse = rxrpc_may_reuse_conn(conn);
+
 	/* If a client call was exposed to the world, we save the result for
 	 * retransmission.
 	 *
@@ -841,14 +829,21 @@ void rxrpc_disconnect_client_call(struct rxrpc_call *call)
 	if (test_bit(RXRPC_CALL_EXPOSED, &call->flags)) {
 		_debug("exposed %u,%u", call->call_id, call->abort_code);
 		__rxrpc_disconnect_call(conn, call);
+
+		if (test_and_clear_bit(RXRPC_CONN_PROBING_FOR_UPGRADE, &conn->flags)) {
+			trace_rxrpc_client(conn, channel, rxrpc_client_to_active);
+			bundle->try_upgrade = false;
+			if (may_reuse)
+				rxrpc_activate_channels_locked(bundle);
+		}
+
 	}
 
 	/* See if we can pass the channel directly to another call. */
-	if (conn->cache_state == RXRPC_CONN_CLIENT_ACTIVE &&
-	    !list_empty(&conn->waiting_calls)) {
+	if (may_reuse && !list_empty(&bundle->waiting_calls)) {
 		trace_rxrpc_client(conn, channel, rxrpc_client_chan_pass);
 		rxrpc_activate_one_channel(conn, channel);
-		goto out_2;
+		goto out;
 	}
 
 	/* Schedule the final ACK to be transmitted in a short while so that it
@@ -865,128 +860,95 @@ void rxrpc_disconnect_client_call(struct rxrpc_call *call)
 		rxrpc_reduce_conn_timer(conn, final_ack_at);
 	}
 
-	/* Things are more complex and we need the cache lock.  We might be
-	 * able to simply idle the conn or it might now be lurking on the wait
-	 * list.  It might even get moved back to the active list whilst we're
-	 * waiting for the lock.
-	 */
-	spin_lock(&rxnet->client_conn_cache_lock);
-
-	switch (conn->cache_state) {
-	case RXRPC_CONN_CLIENT_UPGRADE:
-		/* Deal with termination of a service upgrade probe. */
-		if (test_bit(RXRPC_CONN_EXPOSED, &conn->flags)) {
-			clear_bit(RXRPC_CONN_PROBING_FOR_UPGRADE, &conn->flags);
-			trace_rxrpc_client(conn, channel, rxrpc_client_to_active);
-			conn->cache_state = RXRPC_CONN_CLIENT_ACTIVE;
-			rxrpc_activate_channels_locked(conn);
-		}
-		fallthrough;
-	case RXRPC_CONN_CLIENT_ACTIVE:
-		if (list_empty(&conn->waiting_calls)) {
-			rxrpc_deactivate_one_channel(conn, channel);
-			if (!conn->active_chans) {
-				rxnet->nr_active_client_conns--;
-				goto idle_connection;
-			}
-			goto out;
-		}
-
-		trace_rxrpc_client(conn, channel, rxrpc_client_chan_pass);
-		rxrpc_activate_one_channel(conn, channel);
-		goto out;
+	/* Deactivate the channel. */
+	rcu_assign_pointer(chan->call, NULL);
+	set_bit(conn->bundle_shift + channel, &conn->bundle->avail_chans);
+	conn->act_chans	&= ~(1 << channel);
 
-	case RXRPC_CONN_CLIENT_CULLED:
-		rxrpc_deactivate_one_channel(conn, channel);
-		ASSERT(list_empty(&conn->waiting_calls));
-		if (!conn->active_chans)
-			goto idle_connection;
-		goto out;
+	/* If no channels remain active, then put the connection on the idle
+	 * list for a short while.  Give it a ref to stop it going away if it
+	 * becomes unbundled.
+	 */
+	if (!conn->act_chans) {
+		trace_rxrpc_client(conn, channel, rxrpc_client_to_idle);
+		conn->idle_timestamp = jiffies;
 
-	case RXRPC_CONN_CLIENT_WAITING:
-		rxrpc_deactivate_one_channel(conn, channel);
-		goto out;
+		rxrpc_get_connection(conn);
+		spin_lock(&rxnet->client_conn_cache_lock);
+		list_move_tail(&conn->cache_link, &rxnet->idle_client_conns);
+		spin_unlock(&rxnet->client_conn_cache_lock);
 
-	default:
-		BUG();
+		rxrpc_set_client_reap_timer(rxnet);
 	}
 
 out:
-	spin_unlock(&rxnet->client_conn_cache_lock);
-out_2:
-	spin_unlock(&conn->channel_lock);
+	spin_unlock(&bundle->channel_lock);
 	_leave("");
 	return;
+}
 
-idle_connection:
-	/* As no channels remain active, the connection gets deactivated
-	 * immediately or moved to the idle list for a short while.
-	 */
-	if (test_bit(RXRPC_CONN_EXPOSED, &conn->flags)) {
-		trace_rxrpc_client(conn, channel, rxrpc_client_to_idle);
-		conn->idle_timestamp = jiffies;
-		conn->cache_state = RXRPC_CONN_CLIENT_IDLE;
-		list_move_tail(&conn->cache_link, &rxnet->idle_client_conns);
-		if (rxnet->idle_client_conns.next == &conn->cache_link &&
-		    !rxnet->kill_all_client_conns)
-			rxrpc_set_client_reap_timer(rxnet);
-	} else {
-		trace_rxrpc_client(conn, channel, rxrpc_client_to_inactive);
-		conn->cache_state = RXRPC_CONN_CLIENT_INACTIVE;
-		list_del_init(&conn->cache_link);
+/*
+ * Remove a connection from a bundle.
+ */
+static void rxrpc_unbundle_conn(struct rxrpc_connection *conn)
+{
+	struct rxrpc_bundle *bundle = conn->bundle;
+	struct rxrpc_local *local = bundle->params.local;
+	unsigned int bindex;
+	bool need_drop = false;
+	int i;
+
+	_enter("C=%x", conn->debug_id);
+
+	spin_lock(&bundle->channel_lock);
+	bindex = conn->bundle_shift / RXRPC_MAXCALLS;
+	if (bundle->conns[bindex] == conn) {
+		_debug("clear slot %u", bindex);
+		bundle->conns[bindex] = NULL;
+		for (i = 0; i < RXRPC_MAXCALLS; i++)
+			clear_bit(conn->bundle_shift + i, &bundle->avail_chans);
+		need_drop = true;
 	}
-	goto out;
+	spin_unlock(&bundle->channel_lock);
+
+	/* If there are no more connections, remove the bundle */
+	if (!bundle->avail_chans) {
+		_debug("maybe unbundle");
+		spin_lock(&local->client_bundles_lock);
+
+		for (i = 0; i < ARRAY_SIZE(bundle->conns); i++)
+			if (bundle->conns[i])
+				break;
+		if (i == ARRAY_SIZE(bundle->conns) && !bundle->params.exclusive) {
+			_debug("erase bundle");
+			rb_erase(&bundle->local_node, &local->client_bundles);
+		}
+
+		spin_unlock(&local->client_bundles_lock);
+		if (i == ARRAY_SIZE(bundle->conns))
+			rxrpc_put_bundle(bundle);
+	}
+
+	if (need_drop)
+		rxrpc_put_connection(conn);
+	_leave("");
 }
 
 /*
  * Clean up a dead client connection.
  */
-static struct rxrpc_connection *
-rxrpc_put_one_client_conn(struct rxrpc_connection *conn)
+static void rxrpc_kill_client_conn(struct rxrpc_connection *conn)
 {
-	struct rxrpc_connection *next = NULL;
 	struct rxrpc_local *local = conn->params.local;
 	struct rxrpc_net *rxnet = local->rxnet;
-	unsigned int nr_conns;
 
-	trace_rxrpc_client(conn, -1, rxrpc_client_cleanup);
+	_enter("C=%x", conn->debug_id);
 
-	if (test_bit(RXRPC_CONN_IN_CLIENT_CONNS, &conn->flags)) {
-		spin_lock(&local->client_conns_lock);
-		if (test_and_clear_bit(RXRPC_CONN_IN_CLIENT_CONNS,
-				       &conn->flags))
-			rb_erase(&conn->client_node, &local->client_conns);
-		spin_unlock(&local->client_conns_lock);
-	}
+	trace_rxrpc_client(conn, -1, rxrpc_client_cleanup);
+	atomic_dec(&rxnet->nr_client_conns);
 
 	rxrpc_put_client_connection_id(conn);
-
-	ASSERTCMP(conn->cache_state, ==, RXRPC_CONN_CLIENT_INACTIVE);
-
-	if (test_bit(RXRPC_CONN_COUNTED, &conn->flags)) {
-		trace_rxrpc_client(conn, -1, rxrpc_client_uncount);
-		spin_lock(&rxnet->client_conn_cache_lock);
-		nr_conns = --rxnet->nr_client_conns;
-
-		if (nr_conns < rxrpc_max_client_connections &&
-		    !list_empty(&rxnet->waiting_client_conns)) {
-			next = list_entry(rxnet->waiting_client_conns.next,
-					  struct rxrpc_connection, cache_link);
-			rxrpc_get_connection(next);
-			rxrpc_activate_conn(rxnet, next);
-		}
-
-		spin_unlock(&rxnet->client_conn_cache_lock);
-	}
-
 	rxrpc_kill_connection(conn);
-	if (next)
-		rxrpc_activate_channels(next);
-
-	/* We need to get rid of the temporary ref we took upon next, but we
-	 * can't call rxrpc_put_connection() recursively.
-	 */
-	return next;
 }
 
 /*
@@ -998,63 +960,12 @@ void rxrpc_put_client_conn(struct rxrpc_connection *conn)
 	unsigned int debug_id = conn->debug_id;
 	int n;
 
-	do {
-		n = atomic_dec_return(&conn->usage);
-		trace_rxrpc_conn(debug_id, rxrpc_conn_put_client, n, here);
-		if (n > 0)
-			return;
+	n = atomic_dec_return(&conn->usage);
+	trace_rxrpc_conn(debug_id, rxrpc_conn_put_client, n, here);
+	if (n <= 0) {
 		ASSERTCMP(n, >=, 0);
-
-		conn = rxrpc_put_one_client_conn(conn);
-	} while (conn);
-}
-
-/*
- * Kill the longest-active client connections to make room for new ones.
- */
-static void rxrpc_cull_active_client_conns(struct rxrpc_net *rxnet)
-{
-	struct rxrpc_connection *conn;
-	unsigned int nr_conns = rxnet->nr_client_conns;
-	unsigned int nr_active, limit;
-
-	_enter("");
-
-	ASSERTCMP(nr_conns, >=, 0);
-	if (nr_conns < rxrpc_max_client_connections) {
-		_leave(" [ok]");
-		return;
+		rxrpc_kill_client_conn(conn);
 	}
-	limit = rxrpc_reap_client_connections;
-
-	spin_lock(&rxnet->client_conn_cache_lock);
-	nr_active = rxnet->nr_active_client_conns;
-
-	while (nr_active > limit) {
-		ASSERT(!list_empty(&rxnet->active_client_conns));
-		conn = list_entry(rxnet->active_client_conns.next,
-				  struct rxrpc_connection, cache_link);
-		ASSERTIFCMP(conn->cache_state != RXRPC_CONN_CLIENT_ACTIVE,
-			    conn->cache_state, ==, RXRPC_CONN_CLIENT_UPGRADE);
-
-		if (list_empty(&conn->waiting_calls)) {
-			trace_rxrpc_client(conn, -1, rxrpc_client_to_culled);
-			conn->cache_state = RXRPC_CONN_CLIENT_CULLED;
-			list_del_init(&conn->cache_link);
-		} else {
-			trace_rxrpc_client(conn, -1, rxrpc_client_to_waiting);
-			conn->cache_state = RXRPC_CONN_CLIENT_WAITING;
-			list_move_tail(&conn->cache_link,
-				       &rxnet->waiting_client_conns);
-		}
-
-		nr_active--;
-	}
-
-	rxnet->nr_active_client_conns = nr_active;
-	spin_unlock(&rxnet->client_conn_cache_lock);
-	ASSERTCMP(nr_active, >=, 0);
-	_leave(" [culled]");
 }
 
 /*
@@ -1088,7 +999,7 @@ void rxrpc_discard_expired_client_conns(struct work_struct *work)
 	/* We keep an estimate of what the number of conns ought to be after
 	 * we've discarded some so that we don't overdo the discarding.
 	 */
-	nr_conns = rxnet->nr_client_conns;
+	nr_conns = atomic_read(&rxnet->nr_client_conns);
 
 next:
 	spin_lock(&rxnet->client_conn_cache_lock);
@@ -1098,7 +1009,6 @@ void rxrpc_discard_expired_client_conns(struct work_struct *work)
 
 	conn = list_entry(rxnet->idle_client_conns.next,
 			  struct rxrpc_connection, cache_link);
-	ASSERT(test_bit(RXRPC_CONN_EXPOSED, &conn->flags));
 
 	if (!rxnet->kill_all_client_conns) {
 		/* If the number of connections is over the reap limit, we
@@ -1120,18 +1030,13 @@ void rxrpc_discard_expired_client_conns(struct work_struct *work)
 	}
 
 	trace_rxrpc_client(conn, -1, rxrpc_client_discard);
-	if (!test_and_clear_bit(RXRPC_CONN_EXPOSED, &conn->flags))
-		BUG();
-	conn->cache_state = RXRPC_CONN_CLIENT_INACTIVE;
 	list_del_init(&conn->cache_link);
 
 	spin_unlock(&rxnet->client_conn_cache_lock);
 
-	/* When we cleared the EXPOSED flag, we took on responsibility for the
-	 * reference that that had on the usage count.  We deal with that here.
-	 * If someone re-sets the flag and re-gets the ref, that's fine.
-	 */
-	rxrpc_put_connection(conn);
+	rxrpc_unbundle_conn(conn);
+	rxrpc_put_connection(conn); /* Drop the ->cache_link ref */
+
 	nr_conns--;
 	goto next;
 
@@ -1145,8 +1050,7 @@ void rxrpc_discard_expired_client_conns(struct work_struct *work)
 	 */
 	_debug("not yet");
 	if (!rxnet->kill_all_client_conns)
-		timer_reduce(&rxnet->client_conn_reap_timer,
-			     conn_expires_at);
+		timer_reduce(&rxnet->client_conn_reap_timer, conn_expires_at);
 
 out:
 	spin_unlock(&rxnet->client_conn_cache_lock);
@@ -1181,37 +1085,26 @@ void rxrpc_clean_up_local_conns(struct rxrpc_local *local)
 {
 	struct rxrpc_connection *conn, *tmp;
 	struct rxrpc_net *rxnet = local->rxnet;
-	unsigned int nr_active;
 	LIST_HEAD(graveyard);
 
 	_enter("");
 
 	spin_lock(&rxnet->client_conn_cache_lock);
-	nr_active = rxnet->nr_active_client_conns;
 
 	list_for_each_entry_safe(conn, tmp, &rxnet->idle_client_conns,
 				 cache_link) {
 		if (conn->params.local == local) {
-			ASSERTCMP(conn->cache_state, ==, RXRPC_CONN_CLIENT_IDLE);
-
 			trace_rxrpc_client(conn, -1, rxrpc_client_discard);
-			if (!test_and_clear_bit(RXRPC_CONN_EXPOSED, &conn->flags))
-				BUG();
-			conn->cache_state = RXRPC_CONN_CLIENT_INACTIVE;
 			list_move(&conn->cache_link, &graveyard);
-			nr_active--;
 		}
 	}
 
-	rxnet->nr_active_client_conns = nr_active;
 	spin_unlock(&rxnet->client_conn_cache_lock);
-	ASSERTCMP(nr_active, >=, 0);
 
 	while (!list_empty(&graveyard)) {
 		conn = list_entry(graveyard.next,
 				  struct rxrpc_connection, cache_link);
 		list_del_init(&conn->cache_link);
-
 		rxrpc_put_connection(conn);
 	}
 
diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index 447f55ca6886..0628dad2bdea 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -157,12 +157,12 @@ static void rxrpc_abort_calls(struct rxrpc_connection *conn,
 
 	_enter("{%d},%x", conn->debug_id, conn->abort_code);
 
-	spin_lock(&conn->channel_lock);
+	spin_lock(&conn->bundle->channel_lock);
 
 	for (i = 0; i < RXRPC_MAXCALLS; i++) {
 		call = rcu_dereference_protected(
 			conn->channels[i].call,
-			lockdep_is_held(&conn->channel_lock));
+			lockdep_is_held(&conn->bundle->channel_lock));
 		if (call) {
 			if (compl == RXRPC_CALL_LOCALLY_ABORTED)
 				trace_rxrpc_abort(call->debug_id,
@@ -179,7 +179,7 @@ static void rxrpc_abort_calls(struct rxrpc_connection *conn,
 		}
 	}
 
-	spin_unlock(&conn->channel_lock);
+	spin_unlock(&conn->bundle->channel_lock);
 	_leave("");
 }
 
@@ -210,6 +210,7 @@ static int rxrpc_abort_connection(struct rxrpc_connection *conn,
 	conn->error = error;
 	conn->abort_code = abort_code;
 	conn->state = RXRPC_CONN_LOCALLY_ABORTED;
+	set_bit(RXRPC_CONN_DONT_REUSE, &conn->flags);
 	spin_unlock_bh(&conn->state_lock);
 
 	msg.msg_name	= &conn->params.peer->srx.transport;
@@ -319,6 +320,7 @@ static int rxrpc_process_event(struct rxrpc_connection *conn,
 		conn->error = -ECONNABORTED;
 		conn->abort_code = abort_code;
 		conn->state = RXRPC_CONN_REMOTELY_ABORTED;
+		set_bit(RXRPC_CONN_DONT_REUSE, &conn->flags);
 		rxrpc_abort_calls(conn, RXRPC_CALL_REMOTELY_ABORTED, sp->hdr.serial);
 		return -ECONNABORTED;
 
@@ -339,7 +341,7 @@ static int rxrpc_process_event(struct rxrpc_connection *conn,
 		if (ret < 0)
 			return ret;
 
-		spin_lock(&conn->channel_lock);
+		spin_lock(&conn->bundle->channel_lock);
 		spin_lock(&conn->state_lock);
 
 		if (conn->state == RXRPC_CONN_SERVICE_CHALLENGING) {
@@ -349,12 +351,12 @@ static int rxrpc_process_event(struct rxrpc_connection *conn,
 				rxrpc_call_is_secure(
 					rcu_dereference_protected(
 						conn->channels[loop].call,
-						lockdep_is_held(&conn->channel_lock)));
+						lockdep_is_held(&conn->bundle->channel_lock)));
 		} else {
 			spin_unlock(&conn->state_lock);
 		}
 
-		spin_unlock(&conn->channel_lock);
+		spin_unlock(&conn->bundle->channel_lock);
 		return 0;
 
 	default:
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index 8cbe0bf20ed5..3bcbe0665f91 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -41,8 +41,6 @@ struct rxrpc_connection *rxrpc_alloc_connection(gfp_t gfp)
 	conn = kzalloc(sizeof(struct rxrpc_connection), gfp);
 	if (conn) {
 		INIT_LIST_HEAD(&conn->cache_link);
-		spin_lock_init(&conn->channel_lock);
-		INIT_LIST_HEAD(&conn->waiting_calls);
 		timer_setup(&conn->timer, &rxrpc_connection_timer, 0);
 		INIT_WORK(&conn->processor, &rxrpc_process_connection);
 		INIT_LIST_HEAD(&conn->proc_link);
@@ -219,11 +217,11 @@ void rxrpc_disconnect_call(struct rxrpc_call *call)
 	}
 
 	if (rxrpc_is_client_call(call))
-		return rxrpc_disconnect_client_call(call);
+		return rxrpc_disconnect_client_call(conn->bundle, call);
 
-	spin_lock(&conn->channel_lock);
+	spin_lock(&conn->bundle->channel_lock);
 	__rxrpc_disconnect_call(conn, call);
-	spin_unlock(&conn->channel_lock);
+	spin_unlock(&conn->bundle->channel_lock);
 
 	set_bit(RXRPC_CALL_DISCONNECTED, &call->flags);
 	conn->idle_timestamp = jiffies;
@@ -292,12 +290,13 @@ void rxrpc_see_connection(struct rxrpc_connection *conn)
 /*
  * Get a ref on a connection.
  */
-void rxrpc_get_connection(struct rxrpc_connection *conn)
+struct rxrpc_connection *rxrpc_get_connection(struct rxrpc_connection *conn)
 {
 	const void *here = __builtin_return_address(0);
 	int n = atomic_inc_return(&conn->usage);
 
 	trace_rxrpc_conn(conn->debug_id, rxrpc_conn_got, n, here);
+	return conn;
 }
 
 /*
@@ -365,6 +364,7 @@ static void rxrpc_destroy_connection(struct rcu_head *rcu)
 	conn->security->clear(conn);
 	key_put(conn->params.key);
 	key_put(conn->server_key);
+	rxrpc_put_bundle(conn->bundle);
 	rxrpc_put_peer(conn->params.peer);
 
 	if (atomic_dec_and_test(&conn->params.local->rxnet->nr_conns))
diff --git a/net/rxrpc/conn_service.c b/net/rxrpc/conn_service.c
index 21da48e3d2e5..6c847720494f 100644
--- a/net/rxrpc/conn_service.c
+++ b/net/rxrpc/conn_service.c
@@ -8,6 +8,12 @@
 #include <linux/slab.h>
 #include "ar-internal.h"
 
+static struct rxrpc_bundle rxrpc_service_dummy_bundle = {
+	.usage		= ATOMIC_INIT(1),
+	.debug_id	= UINT_MAX,
+	.channel_lock	= __SPIN_LOCK_UNLOCKED(&rxrpc_service_dummy_bundle.channel_lock),
+};
+
 /*
  * Find a service connection under RCU conditions.
  *
@@ -127,6 +133,7 @@ struct rxrpc_connection *rxrpc_prealloc_service_connection(struct rxrpc_net *rxn
 		 */
 		conn->state = RXRPC_CONN_SERVICE_PREALLOC;
 		atomic_set(&conn->usage, 2);
+		conn->bundle = rxrpc_get_bundle(&rxrpc_service_dummy_bundle);
 
 		atomic_inc(&rxnet->nr_conns);
 		write_lock(&rxnet->conn_lock);
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index ede058f9cc15..8c2881054266 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -86,8 +86,8 @@ static struct rxrpc_local *rxrpc_alloc_local(struct rxrpc_net *rxnet,
 		init_rwsem(&local->defrag_sem);
 		skb_queue_head_init(&local->reject_queue);
 		skb_queue_head_init(&local->event_queue);
-		local->client_conns = RB_ROOT;
-		spin_lock_init(&local->client_conns_lock);
+		local->client_bundles = RB_ROOT;
+		spin_lock_init(&local->client_bundles_lock);
 		spin_lock_init(&local->lock);
 		rwlock_init(&local->services_lock);
 		local->debug_id = atomic_inc_return(&rxrpc_debug_id);
diff --git a/net/rxrpc/net_ns.c b/net/rxrpc/net_ns.c
index b312aab80fed..25bbc4cc8b13 100644
--- a/net/rxrpc/net_ns.c
+++ b/net/rxrpc/net_ns.c
@@ -62,13 +62,10 @@ static __net_init int rxrpc_init_net(struct net *net)
 	timer_setup(&rxnet->service_conn_reap_timer,
 		    rxrpc_service_conn_reap_timeout, 0);
 
-	rxnet->nr_client_conns = 0;
-	rxnet->nr_active_client_conns = 0;
+	atomic_set(&rxnet->nr_client_conns, 0);
 	rxnet->kill_all_client_conns = false;
 	spin_lock_init(&rxnet->client_conn_cache_lock);
 	spin_lock_init(&rxnet->client_conn_discard_lock);
-	INIT_LIST_HEAD(&rxnet->waiting_client_conns);
-	INIT_LIST_HEAD(&rxnet->active_client_conns);
 	INIT_LIST_HEAD(&rxnet->idle_client_conns);
 	INIT_WORK(&rxnet->client_conn_reaper,
 		  rxrpc_discard_expired_client_conns);
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 3cfff7922ba8..10f2bf2e9068 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -357,6 +357,12 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
 
 	_enter(",{%d}", skb->len);
 
+	if (hlist_unhashed(&call->error_link)) {
+		spin_lock_bh(&call->peer->lock);
+		hlist_add_head_rcu(&call->error_link, &call->peer->error_targets);
+		spin_unlock_bh(&call->peer->lock);
+	}
+
 	/* Each transmission of a Tx packet needs a new serial number */
 	serial = atomic_inc_return(&conn->serial);
 
diff --git a/net/rxrpc/proc.c b/net/rxrpc/proc.c
index 543afd9bd664..e2f990754f88 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -165,7 +165,7 @@ static int rxrpc_connection_seq_show(struct seq_file *seq, void *v)
 			 "Proto Local                                          "
 			 " Remote                                         "
 			 " SvID ConnID   End Use State    Key     "
-			 " Serial   ISerial\n"
+			 " Serial   ISerial  CallId0  CallId1  CallId2  CallId3\n"
 			 );
 		return 0;
 	}
diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index e08130e5746b..f114dc2af5cf 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -1169,7 +1169,7 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 	if (response->encrypted.checksum != csum)
 		goto protocol_error_free;
 
-	spin_lock(&conn->channel_lock);
+	spin_lock(&conn->bundle->channel_lock);
 	for (i = 0; i < RXRPC_MAXCALLS; i++) {
 		struct rxrpc_call *call;
 		u32 call_id = ntohl(response->encrypted.call_id[i]);
@@ -1186,13 +1186,13 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 		if (call_id > conn->channels[i].call_counter) {
 			call = rcu_dereference_protected(
 				conn->channels[i].call,
-				lockdep_is_held(&conn->channel_lock));
+				lockdep_is_held(&conn->bundle->channel_lock));
 			if (call && call->state < RXRPC_CALL_COMPLETE)
 				goto protocol_error_unlock;
 			conn->channels[i].call_counter = call_id;
 		}
 	}
-	spin_unlock(&conn->channel_lock);
+	spin_unlock(&conn->bundle->channel_lock);
 
 	eproto = tracepoint_string("rxkad_rsp_seq");
 	abort_code = RXKADOUTOFSEQUENCE;
@@ -1219,7 +1219,7 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 	return 0;
 
 protocol_error_unlock:
-	spin_unlock(&conn->channel_lock);
+	spin_unlock(&conn->bundle->channel_lock);
 protocol_error_free:
 	kfree(ticket);
 protocol_error:
diff --git a/net/rxrpc/sysctl.c b/net/rxrpc/sysctl.c
index e91acc95ff28..540351d6a5f4 100644
--- a/net/rxrpc/sysctl.c
+++ b/net/rxrpc/sysctl.c
@@ -73,14 +73,6 @@ static struct ctl_table rxrpc_sysctl_table[] = {
 	},
 
 	/* Non-time values */
-	{
-		.procname	= "max_client_conns",
-		.data		= &rxrpc_max_client_connections,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= (void *)&rxrpc_reap_client_connections,
-	},
 	{
 		.procname	= "reap_client_conns",
 		.data		= &rxrpc_reap_client_connections,
@@ -88,7 +80,7 @@ static struct ctl_table rxrpc_sysctl_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= (void *)SYSCTL_ONE,
-		.extra2		= (void *)&rxrpc_max_client_connections,
+		.extra2		= (void *)&n_65535,
 	},
 	{
 		.procname	= "max_backlog",


