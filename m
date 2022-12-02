Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C20E463FCB7
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 01:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbiLBARx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 19:17:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232153AbiLBARR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 19:17:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32A5CEF95
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 16:16:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669940175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qX2NtzDdDBIpK3pq8QzAj8mCbabpuW0klY+GnllIel4=;
        b=dqSNCtazknHg87xOkI8pOjvJPjXXMn+OJNy8HrZT5rtXqCg3QbeUodXYokob7RmGuHUDJZ
        ILCWm8tBbWEOxd4iPIneLDwUzR35166C5KTNn2HynX++gO1LqX4rVuoRnby08L4qsrxKWO
        0/zDqvJ/8H7O1AHw5jMP9q5JNk7RgFk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-674-Qvu3_hcQOb6-QkDiZZbssg-1; Thu, 01 Dec 2022 19:16:13 -0500
X-MC-Unique: Qvu3_hcQOb6-QkDiZZbssg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 025D42999B2C;
        Fri,  2 Dec 2022 00:16:13 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 11BEA2166BB1;
        Fri,  2 Dec 2022 00:16:11 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 08/36] rxrpc: Drop rxrpc_conn_parameters from
 rxrpc_connection and rxrpc_bundle
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Fri, 02 Dec 2022 00:16:09 +0000
Message-ID: <166994016928.1732290.18363723077617934388.stgit@warthog.procyon.org.uk>
In-Reply-To: <166994010342.1732290.13771061038178613124.stgit@warthog.procyon.org.uk>
References: <166994010342.1732290.13771061038178613124.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the rxrpc_conn_parameters struct from the rxrpc_connection and
rxrpc_bundle structs and emplace the members directly.  These are going to
get filled in from the rxrpc_call struct in future.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/ar-internal.h  |   16 ++++++++++++--
 net/rxrpc/call_accept.c  |    6 +++--
 net/rxrpc/call_event.c   |    2 +-
 net/rxrpc/call_object.c  |    6 +++--
 net/rxrpc/conn_client.c  |   53 +++++++++++++++++++++++++++------------------
 net/rxrpc/conn_event.c   |   26 +++++++++++-----------
 net/rxrpc/conn_object.c  |   22 +++++++++----------
 net/rxrpc/conn_service.c |    6 +++--
 net/rxrpc/input.c        |    4 ++-
 net/rxrpc/key.c          |    2 +-
 net/rxrpc/output.c       |   32 ++++++++++++++-------------
 net/rxrpc/proc.c         |    6 +++--
 net/rxrpc/rxkad.c        |   54 +++++++++++++++++++++++-----------------------
 net/rxrpc/security.c     |    4 ++-
 14 files changed, 131 insertions(+), 108 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 36ece1efb1d4..7c48b0163032 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -403,12 +403,18 @@ enum rxrpc_conn_proto_state {
  * RxRPC client connection bundle.
  */
 struct rxrpc_bundle {
-	struct rxrpc_conn_parameters params;
+	struct rxrpc_local	*local;		/* Representation of local endpoint */
+	struct rxrpc_peer	*peer;		/* Remote endpoint */
+	struct key		*key;		/* Security details */
 	refcount_t		ref;
 	atomic_t		active;		/* Number of active users */
 	unsigned int		debug_id;
+	u32			security_level;	/* Security level selected */
+	u16			service_id;	/* Service ID for this connection */
 	bool			try_upgrade;	/* True if the bundle is attempting upgrade */
 	bool			alloc_conn;	/* True if someone's getting a conn */
+	bool			exclusive;	/* T if conn is exclusive */
+	bool			upgrade;	/* T if service ID can be upgraded */
 	short			alloc_error;	/* Error from last conn allocation */
 	spinlock_t		channel_lock;
 	struct rb_node		local_node;	/* Node in local->client_conns */
@@ -424,7 +430,9 @@ struct rxrpc_bundle {
  */
 struct rxrpc_connection {
 	struct rxrpc_conn_proto	proto;
-	struct rxrpc_conn_parameters params;
+	struct rxrpc_local	*local;		/* Representation of local endpoint */
+	struct rxrpc_peer	*peer;		/* Remote endpoint */
+	struct key		*key;		/* Security details */
 
 	refcount_t		ref;
 	struct rcu_head		rcu;
@@ -471,9 +479,13 @@ struct rxrpc_connection {
 	atomic_t		serial;		/* packet serial number counter */
 	unsigned int		hi_serial;	/* highest serial number received */
 	u32			service_id;	/* Service ID, possibly upgraded */
+	u32			security_level;	/* Security level selected */
 	u8			security_ix;	/* security type */
 	u8			out_clientflag;	/* RXRPC_CLIENT_INITIATED if we are client */
 	u8			bundle_shift;	/* Index into bundle->avail_chans */
+	bool			exclusive;	/* T if conn is exclusive */
+	bool			upgrade;	/* T if service ID can be upgraded */
+	u16			orig_service_id; /* Originally requested service ID */
 	short			error;		/* Local error code */
 };
 
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index 48790ee77019..4888959e4727 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -305,8 +305,8 @@ static struct rxrpc_call *rxrpc_alloc_incoming_call(struct rxrpc_sock *rx,
 		b->conn_backlog[conn_tail] = NULL;
 		smp_store_release(&b->conn_backlog_tail,
 				  (conn_tail + 1) & (RXRPC_BACKLOG_MAX - 1));
-		conn->params.local = rxrpc_get_local(local);
-		conn->params.peer = peer;
+		conn->local = rxrpc_get_local(local);
+		conn->peer = peer;
 		rxrpc_see_connection(conn);
 		rxrpc_new_incoming_connection(rx, conn, sec, skb);
 	} else {
@@ -323,7 +323,7 @@ static struct rxrpc_call *rxrpc_alloc_incoming_call(struct rxrpc_sock *rx,
 	call->conn = conn;
 	call->security = conn->security;
 	call->security_ix = conn->security_ix;
-	call->peer = rxrpc_get_peer(conn->params.peer);
+	call->peer = rxrpc_get_peer(conn->peer);
 	call->cong_ssthresh = call->peer->cong_ssthresh;
 	call->tx_last_sent = ktime_get_real();
 	return call;
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index 349f3df569ba..b17ed37434bd 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -69,7 +69,7 @@ void rxrpc_propose_delay_ACK(struct rxrpc_call *call, rxrpc_serial_t serial,
 void rxrpc_send_ACK(struct rxrpc_call *call, u8 ack_reason,
 		    rxrpc_serial_t serial, enum rxrpc_propose_ack_trace why)
 {
-	struct rxrpc_local *local = call->conn->params.local;
+	struct rxrpc_local *local = call->conn->local;
 	struct rxrpc_txbuf *txb;
 
 	if (test_bit(RXRPC_CALL_DISCONNECTED, &call->flags))
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index e36a317b2e9a..59928f0a8fe1 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -417,9 +417,9 @@ void rxrpc_incoming_call(struct rxrpc_sock *rx,
 	conn->channels[chan].call_id = call->call_id;
 	rcu_assign_pointer(conn->channels[chan].call, call);
 
-	spin_lock(&conn->params.peer->lock);
-	hlist_add_head_rcu(&call->error_link, &conn->params.peer->error_targets);
-	spin_unlock(&conn->params.peer->lock);
+	spin_lock(&conn->peer->lock);
+	hlist_add_head_rcu(&call->error_link, &conn->peer->error_targets);
+	spin_unlock(&conn->peer->lock);
 
 	rxrpc_start_call_timer(call);
 	_leave("");
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index 2b76fbffd4dd..71404b33623f 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -51,7 +51,7 @@ static void rxrpc_deactivate_bundle(struct rxrpc_bundle *bundle);
 static int rxrpc_get_client_connection_id(struct rxrpc_connection *conn,
 					  gfp_t gfp)
 {
-	struct rxrpc_net *rxnet = conn->params.local->rxnet;
+	struct rxrpc_net *rxnet = conn->local->rxnet;
 	int id;
 
 	_enter("");
@@ -122,8 +122,13 @@ static struct rxrpc_bundle *rxrpc_alloc_bundle(struct rxrpc_conn_parameters *cp,
 
 	bundle = kzalloc(sizeof(*bundle), gfp);
 	if (bundle) {
-		bundle->params = *cp;
-		rxrpc_get_peer(bundle->params.peer);
+		bundle->local		= cp->local;
+		bundle->peer		= rxrpc_get_peer(cp->peer);
+		bundle->key		= cp->key;
+		bundle->exclusive	= cp->exclusive;
+		bundle->upgrade		= cp->upgrade;
+		bundle->service_id	= cp->service_id;
+		bundle->security_level	= cp->security_level;
 		refcount_set(&bundle->ref, 1);
 		atomic_set(&bundle->active, 1);
 		spin_lock_init(&bundle->channel_lock);
@@ -140,7 +145,7 @@ struct rxrpc_bundle *rxrpc_get_bundle(struct rxrpc_bundle *bundle)
 
 static void rxrpc_free_bundle(struct rxrpc_bundle *bundle)
 {
-	rxrpc_put_peer(bundle->params.peer);
+	rxrpc_put_peer(bundle->peer);
 	kfree(bundle);
 }
 
@@ -164,7 +169,7 @@ static struct rxrpc_connection *
 rxrpc_alloc_client_connection(struct rxrpc_bundle *bundle, gfp_t gfp)
 {
 	struct rxrpc_connection *conn;
-	struct rxrpc_net *rxnet = bundle->params.local->rxnet;
+	struct rxrpc_net *rxnet = bundle->local->rxnet;
 	int ret;
 
 	_enter("");
@@ -177,10 +182,16 @@ rxrpc_alloc_client_connection(struct rxrpc_bundle *bundle, gfp_t gfp)
 
 	refcount_set(&conn->ref, 1);
 	conn->bundle		= bundle;
-	conn->params		= bundle->params;
+	conn->local		= bundle->local;
+	conn->peer		= bundle->peer;
+	conn->key		= bundle->key;
+	conn->exclusive		= bundle->exclusive;
+	conn->upgrade		= bundle->upgrade;
+	conn->orig_service_id	= bundle->service_id;
+	conn->security_level	= bundle->security_level;
 	conn->out_clientflag	= RXRPC_CLIENT_INITIATED;
 	conn->state		= RXRPC_CONN_CLIENT;
-	conn->service_id	= conn->params.service_id;
+	conn->service_id	= conn->orig_service_id;
 
 	ret = rxrpc_get_client_connection_id(conn, gfp);
 	if (ret < 0)
@@ -196,9 +207,9 @@ rxrpc_alloc_client_connection(struct rxrpc_bundle *bundle, gfp_t gfp)
 	write_unlock(&rxnet->conn_lock);
 
 	rxrpc_get_bundle(bundle);
-	rxrpc_get_peer(conn->params.peer);
-	rxrpc_get_local(conn->params.local);
-	key_get(conn->params.key);
+	rxrpc_get_peer(conn->peer);
+	rxrpc_get_local(conn->local);
+	key_get(conn->key);
 
 	trace_rxrpc_conn(conn->debug_id, rxrpc_conn_new_client,
 			 refcount_read(&conn->ref),
@@ -228,7 +239,7 @@ static bool rxrpc_may_reuse_conn(struct rxrpc_connection *conn)
 	if (!conn)
 		goto dont_reuse;
 
-	rxnet = conn->params.local->rxnet;
+	rxnet = conn->local->rxnet;
 	if (test_bit(RXRPC_CONN_DONT_REUSE, &conn->flags))
 		goto dont_reuse;
 
@@ -285,7 +296,7 @@ static struct rxrpc_bundle *rxrpc_look_up_bundle(struct rxrpc_conn_parameters *c
 	while (p) {
 		bundle = rb_entry(p, struct rxrpc_bundle, local_node);
 
-#define cmp(X) ((long)bundle->params.X - (long)cp->X)
+#define cmp(X) ((long)bundle->X - (long)cp->X)
 		diff = (cmp(peer) ?:
 			cmp(key) ?:
 			cmp(security_level) ?:
@@ -314,7 +325,7 @@ static struct rxrpc_bundle *rxrpc_look_up_bundle(struct rxrpc_conn_parameters *c
 		parent = *pp;
 		bundle = rb_entry(parent, struct rxrpc_bundle, local_node);
 
-#define cmp(X) ((long)bundle->params.X - (long)cp->X)
+#define cmp(X) ((long)bundle->X - (long)cp->X)
 		diff = (cmp(peer) ?:
 			cmp(key) ?:
 			cmp(security_level) ?:
@@ -532,7 +543,7 @@ static void rxrpc_activate_one_channel(struct rxrpc_connection *conn,
 
 	rxrpc_see_call(call);
 	list_del_init(&call->chan_wait_link);
-	call->peer	= rxrpc_get_peer(conn->params.peer);
+	call->peer	= rxrpc_get_peer(conn->peer);
 	call->conn	= rxrpc_get_connection(conn);
 	call->cid	= conn->proto.cid | channel;
 	call->call_id	= call_id;
@@ -569,7 +580,7 @@ static void rxrpc_activate_one_channel(struct rxrpc_connection *conn,
  */
 static void rxrpc_unidle_conn(struct rxrpc_bundle *bundle, struct rxrpc_connection *conn)
 {
-	struct rxrpc_net *rxnet = bundle->params.local->rxnet;
+	struct rxrpc_net *rxnet = bundle->local->rxnet;
 	bool drop_ref;
 
 	if (!list_empty(&conn->cache_link)) {
@@ -795,7 +806,7 @@ void rxrpc_disconnect_client_call(struct rxrpc_bundle *bundle, struct rxrpc_call
 {
 	struct rxrpc_connection *conn;
 	struct rxrpc_channel *chan = NULL;
-	struct rxrpc_net *rxnet = bundle->params.local->rxnet;
+	struct rxrpc_net *rxnet = bundle->local->rxnet;
 	unsigned int channel;
 	bool may_reuse;
 	u32 cid;
@@ -936,11 +947,11 @@ static void rxrpc_unbundle_conn(struct rxrpc_connection *conn)
  */
 static void rxrpc_deactivate_bundle(struct rxrpc_bundle *bundle)
 {
-	struct rxrpc_local *local = bundle->params.local;
+	struct rxrpc_local *local = bundle->local;
 	bool need_put = false;
 
 	if (atomic_dec_and_lock(&bundle->active, &local->client_bundles_lock)) {
-		if (!bundle->params.exclusive) {
+		if (!bundle->exclusive) {
 			_debug("erase bundle");
 			rb_erase(&bundle->local_node, &local->client_bundles);
 			need_put = true;
@@ -957,7 +968,7 @@ static void rxrpc_deactivate_bundle(struct rxrpc_bundle *bundle)
  */
 static void rxrpc_kill_client_conn(struct rxrpc_connection *conn)
 {
-	struct rxrpc_local *local = conn->params.local;
+	struct rxrpc_local *local = conn->local;
 	struct rxrpc_net *rxnet = local->rxnet;
 
 	_enter("C=%x", conn->debug_id);
@@ -1036,7 +1047,7 @@ void rxrpc_discard_expired_client_conns(struct work_struct *work)
 		expiry = rxrpc_conn_idle_client_expiry;
 		if (nr_conns > rxrpc_reap_client_connections)
 			expiry = rxrpc_conn_idle_client_fast_expiry;
-		if (conn->params.local->service_closed)
+		if (conn->local->service_closed)
 			expiry = rxrpc_closed_conn_expiry * HZ;
 
 		conn_expires_at = conn->idle_timestamp + expiry;
@@ -1110,7 +1121,7 @@ void rxrpc_clean_up_local_conns(struct rxrpc_local *local)
 
 	list_for_each_entry_safe(conn, tmp, &rxnet->idle_client_conns,
 				 cache_link) {
-		if (conn->params.local == local) {
+		if (conn->local == local) {
 			trace_rxrpc_client(conn, -1, rxrpc_client_discard);
 			list_move(&conn->cache_link, &graveyard);
 		}
diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index d5549cbfc71b..71ed6b9dc63a 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -52,8 +52,8 @@ static void rxrpc_conn_retransmit_call(struct rxrpc_connection *conn,
 	if (skb && call_id != sp->hdr.callNumber)
 		return;
 
-	msg.msg_name	= &conn->params.peer->srx.transport;
-	msg.msg_namelen	= conn->params.peer->srx.transport_len;
+	msg.msg_name	= &conn->peer->srx.transport;
+	msg.msg_namelen	= conn->peer->srx.transport_len;
 	msg.msg_control	= NULL;
 	msg.msg_controllen = 0;
 	msg.msg_flags	= 0;
@@ -86,8 +86,8 @@ static void rxrpc_conn_retransmit_call(struct rxrpc_connection *conn,
 		break;
 
 	case RXRPC_PACKET_TYPE_ACK:
-		mtu = conn->params.peer->if_mtu;
-		mtu -= conn->params.peer->hdrsize;
+		mtu = conn->peer->if_mtu;
+		mtu -= conn->peer->hdrsize;
 		pkt.ack.bufferSpace	= 0;
 		pkt.ack.maxSkew		= htons(skb ? skb->priority : 0);
 		pkt.ack.firstPacket	= htonl(chan->last_seq + 1);
@@ -131,8 +131,8 @@ static void rxrpc_conn_retransmit_call(struct rxrpc_connection *conn,
 		break;
 	}
 
-	ret = kernel_sendmsg(conn->params.local->socket, &msg, iov, ioc, len);
-	conn->params.peer->last_tx_at = ktime_get_seconds();
+	ret = kernel_sendmsg(conn->local->socket, &msg, iov, ioc, len);
+	conn->peer->last_tx_at = ktime_get_seconds();
 	if (ret < 0)
 		trace_rxrpc_tx_fail(chan->call_debug_id, serial, ret,
 				    rxrpc_tx_point_call_final_resend);
@@ -211,8 +211,8 @@ static int rxrpc_abort_connection(struct rxrpc_connection *conn,
 	set_bit(RXRPC_CONN_DONT_REUSE, &conn->flags);
 	spin_unlock_bh(&conn->state_lock);
 
-	msg.msg_name	= &conn->params.peer->srx.transport;
-	msg.msg_namelen	= conn->params.peer->srx.transport_len;
+	msg.msg_name	= &conn->peer->srx.transport;
+	msg.msg_namelen	= conn->peer->srx.transport_len;
 	msg.msg_control	= NULL;
 	msg.msg_controllen = 0;
 	msg.msg_flags	= 0;
@@ -241,7 +241,7 @@ static int rxrpc_abort_connection(struct rxrpc_connection *conn,
 	rxrpc_abort_calls(conn, RXRPC_CALL_LOCALLY_ABORTED, serial);
 	whdr.serial = htonl(serial);
 
-	ret = kernel_sendmsg(conn->params.local->socket, &msg, iov, 2, len);
+	ret = kernel_sendmsg(conn->local->socket, &msg, iov, 2, len);
 	if (ret < 0) {
 		trace_rxrpc_tx_fail(conn->debug_id, serial, ret,
 				    rxrpc_tx_point_conn_abort);
@@ -251,7 +251,7 @@ static int rxrpc_abort_connection(struct rxrpc_connection *conn,
 
 	trace_rxrpc_tx_packet(conn->debug_id, &whdr, rxrpc_tx_point_conn_abort);
 
-	conn->params.peer->last_tx_at = ktime_get_seconds();
+	conn->peer->last_tx_at = ktime_get_seconds();
 
 	_leave(" = 0");
 	return 0;
@@ -330,7 +330,7 @@ static int rxrpc_process_event(struct rxrpc_connection *conn,
 			return ret;
 
 		ret = conn->security->init_connection_security(
-			conn, conn->params.key->payload.data[0]);
+			conn, conn->key->payload.data[0]);
 		if (ret < 0)
 			return ret;
 
@@ -484,9 +484,9 @@ void rxrpc_process_connection(struct work_struct *work)
 
 	rxrpc_see_connection(conn);
 
-	if (__rxrpc_use_local(conn->params.local)) {
+	if (__rxrpc_use_local(conn->local)) {
 		rxrpc_do_process_connection(conn);
-		rxrpc_unuse_local(conn->params.local);
+		rxrpc_unuse_local(conn->local);
 	}
 
 	rxrpc_put_connection(conn);
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index d5d15389406f..ad6e5ee1f069 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -120,10 +120,10 @@ struct rxrpc_connection *rxrpc_find_connection_rcu(struct rxrpc_local *local,
 		}
 
 		if (conn->proto.epoch != k.epoch ||
-		    conn->params.local != local)
+		    conn->local != local)
 			goto not_found;
 
-		peer = conn->params.peer;
+		peer = conn->peer;
 		switch (srx.transport.family) {
 		case AF_INET:
 			if (peer->srx.transport.sin.sin_port !=
@@ -231,7 +231,7 @@ void rxrpc_disconnect_call(struct rxrpc_call *call)
  */
 void rxrpc_kill_connection(struct rxrpc_connection *conn)
 {
-	struct rxrpc_net *rxnet = conn->params.local->rxnet;
+	struct rxrpc_net *rxnet = conn->local->rxnet;
 
 	ASSERT(!rcu_access_pointer(conn->channels[0].call) &&
 	       !rcu_access_pointer(conn->channels[1].call) &&
@@ -340,7 +340,7 @@ void rxrpc_put_service_conn(struct rxrpc_connection *conn)
 	__refcount_dec(&conn->ref, &r);
 	trace_rxrpc_conn(debug_id, rxrpc_conn_put_service, r - 1, here);
 	if (r - 1 == 1)
-		rxrpc_set_service_reap_timer(conn->params.local->rxnet,
+		rxrpc_set_service_reap_timer(conn->local->rxnet,
 					     jiffies + rxrpc_connection_expiry);
 }
 
@@ -360,13 +360,13 @@ static void rxrpc_destroy_connection(struct rcu_head *rcu)
 	rxrpc_purge_queue(&conn->rx_queue);
 
 	conn->security->clear(conn);
-	key_put(conn->params.key);
+	key_put(conn->key);
 	rxrpc_put_bundle(conn->bundle);
-	rxrpc_put_peer(conn->params.peer);
+	rxrpc_put_peer(conn->peer);
 
-	if (atomic_dec_and_test(&conn->params.local->rxnet->nr_conns))
-		wake_up_var(&conn->params.local->rxnet->nr_conns);
-	rxrpc_put_local(conn->params.local);
+	if (atomic_dec_and_test(&conn->local->rxnet->nr_conns))
+		wake_up_var(&conn->local->rxnet->nr_conns);
+	rxrpc_put_local(conn->local);
 
 	kfree(conn);
 	_leave("");
@@ -397,10 +397,10 @@ void rxrpc_service_connection_reaper(struct work_struct *work)
 		if (conn->state == RXRPC_CONN_SERVICE_PREALLOC)
 			continue;
 
-		if (rxnet->live && !conn->params.local->dead) {
+		if (rxnet->live && !conn->local->dead) {
 			idle_timestamp = READ_ONCE(conn->idle_timestamp);
 			expire_at = idle_timestamp + rxrpc_connection_expiry * HZ;
-			if (conn->params.local->service_closed)
+			if (conn->local->service_closed)
 				expire_at = idle_timestamp + rxrpc_closed_conn_expiry * HZ;
 
 			_debug("reap CONN %d { u=%d,t=%ld }",
diff --git a/net/rxrpc/conn_service.c b/net/rxrpc/conn_service.c
index 75f903099eb0..a3b91864ef21 100644
--- a/net/rxrpc/conn_service.c
+++ b/net/rxrpc/conn_service.c
@@ -164,7 +164,7 @@ void rxrpc_new_incoming_connection(struct rxrpc_sock *rx,
 
 	conn->proto.epoch	= sp->hdr.epoch;
 	conn->proto.cid		= sp->hdr.cid & RXRPC_CIDMASK;
-	conn->params.service_id	= sp->hdr.serviceId;
+	conn->orig_service_id	= sp->hdr.serviceId;
 	conn->service_id	= sp->hdr.serviceId;
 	conn->security_ix	= sp->hdr.securityIndex;
 	conn->out_clientflag	= 0;
@@ -183,7 +183,7 @@ void rxrpc_new_incoming_connection(struct rxrpc_sock *rx,
 		conn->service_id = rx->service_upgrade.to;
 
 	/* Make the connection a target for incoming packets. */
-	rxrpc_publish_service_conn(conn->params.peer, conn);
+	rxrpc_publish_service_conn(conn->peer, conn);
 }
 
 /*
@@ -192,7 +192,7 @@ void rxrpc_new_incoming_connection(struct rxrpc_sock *rx,
  */
 void rxrpc_unpublish_service_conn(struct rxrpc_connection *conn)
 {
-	struct rxrpc_peer *peer = conn->params.peer;
+	struct rxrpc_peer *peer = conn->peer;
 
 	write_seqlock_bh(&peer->service_conn_lock);
 	if (test_and_clear_bit(RXRPC_CONN_IN_SERVICE_CONNS, &conn->flags))
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index e2461f29d765..44caf88e04b8 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -1339,10 +1339,10 @@ int rxrpc_input_packet(struct sock *udp_sk, struct sk_buff *skb)
 
 			if (!test_bit(RXRPC_CONN_PROBING_FOR_UPGRADE, &conn->flags))
 				goto reupgrade;
-			old_id = cmpxchg(&conn->service_id, conn->params.service_id,
+			old_id = cmpxchg(&conn->service_id, conn->orig_service_id,
 					 sp->hdr.serviceId);
 
-			if (old_id != conn->params.service_id &&
+			if (old_id != conn->orig_service_id &&
 			    old_id != sp->hdr.serviceId)
 				goto reupgrade;
 		}
diff --git a/net/rxrpc/key.c b/net/rxrpc/key.c
index 830eeffe2d5b..8d53aded09c4 100644
--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -513,7 +513,7 @@ int rxrpc_get_server_data_key(struct rxrpc_connection *conn,
 	if (ret < 0)
 		goto error;
 
-	conn->params.key = key;
+	conn->key = key;
 	_leave(" = 0 [%d]", key_serial(key));
 	return 0;
 
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 635acf3dbd77..b5d8eac8c49c 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -142,8 +142,8 @@ static size_t rxrpc_fill_out_ack(struct rxrpc_connection *conn,
 		txb->ack.reason = RXRPC_ACK_IDLE;
 	}
 
-	mtu = conn->params.peer->if_mtu;
-	mtu -= conn->params.peer->hdrsize;
+	mtu = conn->peer->if_mtu;
+	mtu -= conn->peer->hdrsize;
 	jmax = rxrpc_rx_jumbo_max;
 	qsize = (window - 1) - call->rx_consumed;
 	rsize = max_t(int, call->rx_winsize - qsize, 0);
@@ -259,7 +259,7 @@ static int rxrpc_send_ack_packet(struct rxrpc_local *local, struct rxrpc_txbuf *
 	txb->ack.previousPacket	= htonl(call->rx_highest_seq);
 
 	iov_iter_kvec(&msg.msg_iter, WRITE, iov, 1, len);
-	ret = do_udp_sendmsg(conn->params.local->socket, &msg, len);
+	ret = do_udp_sendmsg(conn->local->socket, &msg, len);
 	call->peer->last_tx_at = ktime_get_seconds();
 	if (ret < 0)
 		trace_rxrpc_tx_fail(call->debug_id, serial, ret,
@@ -368,8 +368,8 @@ int rxrpc_send_abort_packet(struct rxrpc_call *call)
 	pkt.whdr.serial = htonl(serial);
 
 	iov_iter_kvec(&msg.msg_iter, WRITE, iov, 1, sizeof(pkt));
-	ret = do_udp_sendmsg(conn->params.local->socket, &msg, sizeof(pkt));
-	conn->params.peer->last_tx_at = ktime_get_seconds();
+	ret = do_udp_sendmsg(conn->local->socket, &msg, sizeof(pkt));
+	conn->peer->last_tx_at = ktime_get_seconds();
 	if (ret < 0)
 		trace_rxrpc_tx_fail(call->debug_id, serial, ret,
 				    rxrpc_tx_point_call_abort);
@@ -473,7 +473,7 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 	if (txb->len >= call->peer->maxdata)
 		goto send_fragmentable;
 
-	down_read(&conn->params.local->defrag_sem);
+	down_read(&conn->local->defrag_sem);
 
 	txb->last_sent = ktime_get_real();
 	if (txb->wire.flags & RXRPC_REQUEST_ACK)
@@ -486,10 +486,10 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 	 *     message and update the peer record
 	 */
 	rxrpc_inc_stat(call->rxnet, stat_tx_data_send);
-	ret = do_udp_sendmsg(conn->params.local->socket, &msg, len);
-	conn->params.peer->last_tx_at = ktime_get_seconds();
+	ret = do_udp_sendmsg(conn->local->socket, &msg, len);
+	conn->peer->last_tx_at = ktime_get_seconds();
 
-	up_read(&conn->params.local->defrag_sem);
+	up_read(&conn->local->defrag_sem);
 	if (ret < 0) {
 		rxrpc_cancel_rtt_probe(call, serial, rtt_slot);
 		trace_rxrpc_tx_fail(call->debug_id, serial, ret,
@@ -549,22 +549,22 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 	/* attempt to send this message with fragmentation enabled */
 	_debug("send fragment");
 
-	down_write(&conn->params.local->defrag_sem);
+	down_write(&conn->local->defrag_sem);
 
 	txb->last_sent = ktime_get_real();
 	if (txb->wire.flags & RXRPC_REQUEST_ACK)
 		rtt_slot = rxrpc_begin_rtt_probe(call, serial, rxrpc_rtt_tx_data);
 
-	switch (conn->params.local->srx.transport.family) {
+	switch (conn->local->srx.transport.family) {
 	case AF_INET6:
 	case AF_INET:
-		ip_sock_set_mtu_discover(conn->params.local->socket->sk,
+		ip_sock_set_mtu_discover(conn->local->socket->sk,
 					 IP_PMTUDISC_DONT);
 		rxrpc_inc_stat(call->rxnet, stat_tx_data_send_frag);
-		ret = do_udp_sendmsg(conn->params.local->socket, &msg, len);
-		conn->params.peer->last_tx_at = ktime_get_seconds();
+		ret = do_udp_sendmsg(conn->local->socket, &msg, len);
+		conn->peer->last_tx_at = ktime_get_seconds();
 
-		ip_sock_set_mtu_discover(conn->params.local->socket->sk,
+		ip_sock_set_mtu_discover(conn->local->socket->sk,
 					 IP_PMTUDISC_DO);
 		break;
 
@@ -582,7 +582,7 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 	}
 	rxrpc_tx_backoff(call, ret);
 
-	up_write(&conn->params.local->defrag_sem);
+	up_write(&conn->local->defrag_sem);
 	goto done;
 }
 
diff --git a/net/rxrpc/proc.c b/net/rxrpc/proc.c
index fae22a8b38d6..bb2edf6db896 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -172,9 +172,9 @@ static int rxrpc_connection_seq_show(struct seq_file *seq, void *v)
 		goto print;
 	}
 
-	sprintf(lbuff, "%pISpc", &conn->params.local->srx.transport);
+	sprintf(lbuff, "%pISpc", &conn->local->srx.transport);
 
-	sprintf(rbuff, "%pISpc", &conn->params.peer->srx.transport);
+	sprintf(rbuff, "%pISpc", &conn->peer->srx.transport);
 print:
 	seq_printf(seq,
 		   "UDP   %-47.47s %-47.47s %4x %08x %s %3u"
@@ -186,7 +186,7 @@ static int rxrpc_connection_seq_show(struct seq_file *seq, void *v)
 		   rxrpc_conn_is_service(conn) ? "Svc" : "Clt",
 		   refcount_read(&conn->ref),
 		   rxrpc_conn_states[conn->state],
-		   key_serial(conn->params.key),
+		   key_serial(conn->key),
 		   atomic_read(&conn->serial),
 		   conn->hi_serial,
 		   conn->channels[0].call_id,
diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index 36cf40442a7e..d1233720e05f 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -103,7 +103,7 @@ static int rxkad_init_connection_security(struct rxrpc_connection *conn,
 	struct crypto_sync_skcipher *ci;
 	int ret;
 
-	_enter("{%d},{%x}", conn->debug_id, key_serial(conn->params.key));
+	_enter("{%d},{%x}", conn->debug_id, key_serial(conn->key));
 
 	conn->security_ix = token->security_index;
 
@@ -118,7 +118,7 @@ static int rxkad_init_connection_security(struct rxrpc_connection *conn,
 				   sizeof(token->kad->session_key)) < 0)
 		BUG();
 
-	switch (conn->params.security_level) {
+	switch (conn->security_level) {
 	case RXRPC_SECURITY_PLAIN:
 	case RXRPC_SECURITY_AUTH:
 	case RXRPC_SECURITY_ENCRYPT:
@@ -150,7 +150,7 @@ static int rxkad_how_much_data(struct rxrpc_call *call, size_t remain,
 {
 	size_t shdr, buf_size, chunk;
 
-	switch (call->conn->params.security_level) {
+	switch (call->conn->security_level) {
 	default:
 		buf_size = chunk = min_t(size_t, remain, RXRPC_JUMBO_DATALEN);
 		shdr = 0;
@@ -192,7 +192,7 @@ static int rxkad_prime_packet_security(struct rxrpc_connection *conn,
 
 	_enter("");
 
-	if (!conn->params.key)
+	if (!conn->key)
 		return 0;
 
 	tmpbuf = kmalloc(tmpsize, GFP_KERNEL);
@@ -205,7 +205,7 @@ static int rxkad_prime_packet_security(struct rxrpc_connection *conn,
 		return -ENOMEM;
 	}
 
-	token = conn->params.key->payload.data[0];
+	token = conn->key->payload.data[0];
 	memcpy(&iv, token->kad->session_key, sizeof(iv));
 
 	tmpbuf[0] = htonl(conn->proto.epoch);
@@ -317,7 +317,7 @@ static int rxkad_secure_packet_encrypt(const struct rxrpc_call *call,
 	}
 
 	/* encrypt from the session key */
-	token = call->conn->params.key->payload.data[0];
+	token = call->conn->key->payload.data[0];
 	memcpy(&iv, token->kad->session_key, sizeof(iv));
 
 	sg_init_one(&sg, txb->data, txb->len);
@@ -344,13 +344,13 @@ static int rxkad_secure_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 	int ret;
 
 	_enter("{%d{%x}},{#%u},%u,",
-	       call->debug_id, key_serial(call->conn->params.key),
+	       call->debug_id, key_serial(call->conn->key),
 	       txb->seq, txb->len);
 
 	if (!call->conn->rxkad.cipher)
 		return 0;
 
-	ret = key_validate(call->conn->params.key);
+	ret = key_validate(call->conn->key);
 	if (ret < 0)
 		return ret;
 
@@ -380,7 +380,7 @@ static int rxkad_secure_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 		y = 1; /* zero checksums are not permitted */
 	txb->wire.cksum = htons(y);
 
-	switch (call->conn->params.security_level) {
+	switch (call->conn->security_level) {
 	case RXRPC_SECURITY_PLAIN:
 		ret = 0;
 		break;
@@ -525,7 +525,7 @@ static int rxkad_verify_packet_2(struct rxrpc_call *call, struct sk_buff *skb,
 	}
 
 	/* decrypt from the session key */
-	token = call->conn->params.key->payload.data[0];
+	token = call->conn->key->payload.data[0];
 	memcpy(&iv, token->kad->session_key, sizeof(iv));
 
 	skcipher_request_set_sync_tfm(req, call->conn->rxkad.cipher);
@@ -596,7 +596,7 @@ static int rxkad_verify_packet(struct rxrpc_call *call, struct sk_buff *skb)
 	u32 x, y;
 
 	_enter("{%d{%x}},{#%u}",
-	       call->debug_id, key_serial(call->conn->params.key), seq);
+	       call->debug_id, key_serial(call->conn->key), seq);
 
 	if (!call->conn->rxkad.cipher)
 		return 0;
@@ -632,7 +632,7 @@ static int rxkad_verify_packet(struct rxrpc_call *call, struct sk_buff *skb)
 		goto protocol_error;
 	}
 
-	switch (call->conn->params.security_level) {
+	switch (call->conn->security_level) {
 	case RXRPC_SECURITY_PLAIN:
 		ret = 0;
 		break;
@@ -678,8 +678,8 @@ static int rxkad_issue_challenge(struct rxrpc_connection *conn)
 	challenge.min_level	= htonl(0);
 	challenge.__padding	= 0;
 
-	msg.msg_name	= &conn->params.peer->srx.transport;
-	msg.msg_namelen	= conn->params.peer->srx.transport_len;
+	msg.msg_name	= &conn->peer->srx.transport;
+	msg.msg_namelen	= conn->peer->srx.transport_len;
 	msg.msg_control	= NULL;
 	msg.msg_controllen = 0;
 	msg.msg_flags	= 0;
@@ -705,14 +705,14 @@ static int rxkad_issue_challenge(struct rxrpc_connection *conn)
 	serial = atomic_inc_return(&conn->serial);
 	whdr.serial = htonl(serial);
 
-	ret = kernel_sendmsg(conn->params.local->socket, &msg, iov, 2, len);
+	ret = kernel_sendmsg(conn->local->socket, &msg, iov, 2, len);
 	if (ret < 0) {
 		trace_rxrpc_tx_fail(conn->debug_id, serial, ret,
 				    rxrpc_tx_point_rxkad_challenge);
 		return -EAGAIN;
 	}
 
-	conn->params.peer->last_tx_at = ktime_get_seconds();
+	conn->peer->last_tx_at = ktime_get_seconds();
 	trace_rxrpc_tx_packet(conn->debug_id, &whdr,
 			      rxrpc_tx_point_rxkad_challenge);
 	_leave(" = 0");
@@ -736,8 +736,8 @@ static int rxkad_send_response(struct rxrpc_connection *conn,
 
 	_enter("");
 
-	msg.msg_name	= &conn->params.peer->srx.transport;
-	msg.msg_namelen	= conn->params.peer->srx.transport_len;
+	msg.msg_name	= &conn->peer->srx.transport;
+	msg.msg_namelen	= conn->peer->srx.transport_len;
 	msg.msg_control	= NULL;
 	msg.msg_controllen = 0;
 	msg.msg_flags	= 0;
@@ -762,14 +762,14 @@ static int rxkad_send_response(struct rxrpc_connection *conn,
 	serial = atomic_inc_return(&conn->serial);
 	whdr.serial = htonl(serial);
 
-	ret = kernel_sendmsg(conn->params.local->socket, &msg, iov, 3, len);
+	ret = kernel_sendmsg(conn->local->socket, &msg, iov, 3, len);
 	if (ret < 0) {
 		trace_rxrpc_tx_fail(conn->debug_id, serial, ret,
 				    rxrpc_tx_point_rxkad_response);
 		return -EAGAIN;
 	}
 
-	conn->params.peer->last_tx_at = ktime_get_seconds();
+	conn->peer->last_tx_at = ktime_get_seconds();
 	_leave(" = 0");
 	return 0;
 }
@@ -832,15 +832,15 @@ static int rxkad_respond_to_challenge(struct rxrpc_connection *conn,
 	u32 version, nonce, min_level, abort_code;
 	int ret;
 
-	_enter("{%d,%x}", conn->debug_id, key_serial(conn->params.key));
+	_enter("{%d,%x}", conn->debug_id, key_serial(conn->key));
 
 	eproto = tracepoint_string("chall_no_key");
 	abort_code = RX_PROTOCOL_ERROR;
-	if (!conn->params.key)
+	if (!conn->key)
 		goto protocol_error;
 
 	abort_code = RXKADEXPIRED;
-	ret = key_validate(conn->params.key);
+	ret = key_validate(conn->key);
 	if (ret < 0)
 		goto other_error;
 
@@ -863,10 +863,10 @@ static int rxkad_respond_to_challenge(struct rxrpc_connection *conn,
 
 	abort_code = RXKADLEVELFAIL;
 	ret = -EACCES;
-	if (conn->params.security_level < min_level)
+	if (conn->security_level < min_level)
 		goto other_error;
 
-	token = conn->params.key->payload.data[0];
+	token = conn->key->payload.data[0];
 
 	/* build the response packet */
 	resp = kzalloc(sizeof(struct rxkad_response), GFP_NOFS);
@@ -878,7 +878,7 @@ static int rxkad_respond_to_challenge(struct rxrpc_connection *conn,
 	resp->encrypted.cid		= htonl(conn->proto.cid);
 	resp->encrypted.securityIndex	= htonl(conn->security_ix);
 	resp->encrypted.inc_nonce	= htonl(nonce + 1);
-	resp->encrypted.level		= htonl(conn->params.security_level);
+	resp->encrypted.level		= htonl(conn->security_level);
 	resp->kvno			= htonl(token->kad->kvno);
 	resp->ticket_len		= htonl(token->kad->ticket_len);
 	resp->encrypted.call_id[0]	= htonl(conn->channels[0].call_counter);
@@ -1226,7 +1226,7 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 	level = ntohl(response->encrypted.level);
 	if (level > RXRPC_SECURITY_ENCRYPT)
 		goto protocol_error_free;
-	conn->params.security_level = level;
+	conn->security_level = level;
 
 	/* create a key to hold the security data and expiration time - after
 	 * this the connection security can be handled in exactly the same way
diff --git a/net/rxrpc/security.c b/net/rxrpc/security.c
index 50cb5f1ee0c0..e6ddac9b3732 100644
--- a/net/rxrpc/security.c
+++ b/net/rxrpc/security.c
@@ -69,7 +69,7 @@ int rxrpc_init_client_conn_security(struct rxrpc_connection *conn)
 {
 	const struct rxrpc_security *sec;
 	struct rxrpc_key_token *token;
-	struct key *key = conn->params.key;
+	struct key *key = conn->key;
 	int ret;
 
 	_enter("{%d},{%x}", conn->debug_id, key_serial(key));
@@ -163,7 +163,7 @@ struct key *rxrpc_look_up_server_security(struct rxrpc_connection *conn,
 
 	rcu_read_lock();
 
-	rx = rcu_dereference(conn->params.local->service);
+	rx = rcu_dereference(conn->local->service);
 	if (!rx)
 		goto out;
 


