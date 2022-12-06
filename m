Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 185E964489E
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235337AbiLFQCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiLFQB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:01:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63DA36253
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 08:00:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670342456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uAXnKCZcPnjLrV3yzaSB5VERF639/c/pXvUEqSnUYbo=;
        b=DucypqblJdp3XwmR88IElmYHFeZiarwlFt51Z9Dqw6uHiAL5VA6GHzAPKzCK/UQHU0xJhw
        Vxp3gERgz3d1m95ZSMQ3fh/WFv2kiRDpDFGCJOemzYd5LmSwbwe01PDwDjsy8gkn1pYPZ2
        QZ1A3bwKyQUtcsNQwpsIHnYsPnyXFN4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-v1tjU1O1PoW1-L8nli-xbw-1; Tue, 06 Dec 2022 11:00:55 -0500
X-MC-Unique: v1tjU1O1PoW1-L8nli-xbw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE38F3810D36;
        Tue,  6 Dec 2022 16:00:54 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0088240C6E16;
        Tue,  6 Dec 2022 16:00:53 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 16/32] rxrpc: Clean up connection abort
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Tue, 06 Dec 2022 16:00:51 +0000
Message-ID: <167034245119.1105287.9100486645726374644.stgit@warthog.procyon.org.uk>
In-Reply-To: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
References: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean up connection abort, using the connection state_lock to gate access
to change that state, and use an rxrpc_call_completion value to indicate
the difference between local and remote aborts as these can be pasted
directly into the call state.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |    2 
 net/rxrpc/ar-internal.h      |   39 ++++---
 net/rxrpc/call_object.c      |    8 -
 net/rxrpc/conn_event.c       |  233 +++++++++++++++---------------------------
 net/rxrpc/insecure.c         |   18 +--
 net/rxrpc/output.c           |   56 ++++++++++
 net/rxrpc/proc.c             |   10 +-
 net/rxrpc/rxkad.c            |   28 ++---
 8 files changed, 181 insertions(+), 213 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 5a0c44cf1ce6..d9c754f8ef2b 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -118,6 +118,7 @@
 	EM(rxrpc_conn_get_call_input,		"GET inp-call") \
 	EM(rxrpc_conn_get_conn_input,		"GET inp-conn") \
 	EM(rxrpc_conn_get_idle,			"GET idle    ") \
+	EM(rxrpc_conn_get_poke_abort,		"GET pk-abort") \
 	EM(rxrpc_conn_get_poke_timer,		"GET poke    ") \
 	EM(rxrpc_conn_get_service_conn,		"GET svc-conn") \
 	EM(rxrpc_conn_new_client,		"NEW client  ") \
@@ -135,6 +136,7 @@
 	EM(rxrpc_conn_put_unidle,		"PUT unidle  ") \
 	EM(rxrpc_conn_put_work,			"PUT work    ") \
 	EM(rxrpc_conn_queue_challenge,		"QUE chall   ") \
+	EM(rxrpc_conn_queue_retry_work,		"QUE retry-wk") \
 	EM(rxrpc_conn_queue_rx_work,		"QUE rx-work ") \
 	EM(rxrpc_conn_see_new_service_conn,	"SEE new-svc ") \
 	EM(rxrpc_conn_see_reap_service,		"SEE reap-svc") \
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 70a3fdf62cd1..ab031f899c2d 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -263,13 +263,11 @@ struct rxrpc_security {
 
 	/* respond to a challenge */
 	int (*respond_to_challenge)(struct rxrpc_connection *,
-				    struct sk_buff *,
-				    u32 *);
+				    struct sk_buff *);
 
 	/* verify a response */
 	int (*verify_response)(struct rxrpc_connection *,
-			       struct sk_buff *,
-			       u32 *);
+			       struct sk_buff *);
 
 	/* clear connection security */
 	void (*clear)(struct rxrpc_connection *);
@@ -367,6 +365,18 @@ struct rxrpc_conn_parameters {
 	u32			security_level;	/* Security level selected */
 };
 
+/*
+ * Call completion condition (state == RXRPC_CALL_COMPLETE).
+ */
+enum rxrpc_call_completion {
+	RXRPC_CALL_SUCCEEDED,		/* - Normal termination */
+	RXRPC_CALL_REMOTELY_ABORTED,	/* - call aborted by peer */
+	RXRPC_CALL_LOCALLY_ABORTED,	/* - call aborted locally on error or close */
+	RXRPC_CALL_LOCAL_ERROR,		/* - call failed due to local error */
+	RXRPC_CALL_NETWORK_ERROR,	/* - call terminated by network error */
+	NR__RXRPC_CALL_COMPLETIONS
+};
+
 /*
  * Bits in the connection flags.
  */
@@ -391,6 +401,7 @@ enum rxrpc_conn_flag {
  */
 enum rxrpc_conn_event {
 	RXRPC_CONN_EV_CHALLENGE,	/* Send challenge packet */
+	RXRPC_CONN_EV_ABORT_CALLS,	/* Abort attached calls */
 };
 
 /*
@@ -403,8 +414,7 @@ enum rxrpc_conn_proto_state {
 	RXRPC_CONN_SERVICE_UNSECURED,	/* Service unsecured connection */
 	RXRPC_CONN_SERVICE_CHALLENGING,	/* Service challenging for security */
 	RXRPC_CONN_SERVICE,		/* Service secured connection */
-	RXRPC_CONN_REMOTELY_ABORTED,	/* Conn aborted by peer */
-	RXRPC_CONN_LOCALLY_ABORTED,	/* Conn aborted locally */
+	RXRPC_CONN_ABORTED,		/* Conn aborted */
 	RXRPC_CONN__NR_STATES
 };
 
@@ -487,7 +497,8 @@ struct rxrpc_connection {
 	unsigned long		idle_timestamp;	/* Time at which last became idle */
 	spinlock_t		state_lock;	/* state-change lock */
 	enum rxrpc_conn_proto_state state;	/* current state of connection */
-	u32			abort_code;	/* Abort code of connection abort */
+	enum rxrpc_call_completion completion;	/* Completion condition */
+	s32			abort_code;	/* Abort code of connection abort */
 	int			debug_id;	/* debug ID for printks */
 	atomic_t		serial;		/* packet serial number counter */
 	unsigned int		hi_serial;	/* highest serial number received */
@@ -561,18 +572,6 @@ enum rxrpc_call_state {
 	NR__RXRPC_CALL_STATES
 };
 
-/*
- * Call completion condition (state == RXRPC_CALL_COMPLETE).
- */
-enum rxrpc_call_completion {
-	RXRPC_CALL_SUCCEEDED,		/* - Normal termination */
-	RXRPC_CALL_REMOTELY_ABORTED,	/* - call aborted by peer */
-	RXRPC_CALL_LOCALLY_ABORTED,	/* - call aborted locally on error or close */
-	RXRPC_CALL_LOCAL_ERROR,		/* - call failed due to local error */
-	RXRPC_CALL_NETWORK_ERROR,	/* - call terminated by network error */
-	NR__RXRPC_CALL_COMPLETIONS
-};
-
 /*
  * Call Tx congestion management modes.
  */
@@ -907,6 +906,7 @@ void rxrpc_clean_up_local_conns(struct rxrpc_local *);
  */
 void rxrpc_conn_retransmit_call(struct rxrpc_connection *, struct sk_buff *,
 				unsigned int);
+int rxrpc_abort_conn(struct rxrpc_connection *, struct sk_buff *, s32, int, const char *);
 void rxrpc_process_connection(struct work_struct *);
 void rxrpc_process_delayed_final_acks(struct rxrpc_connection *, bool);
 int rxrpc_input_conn_packet(struct rxrpc_connection *conn, struct sk_buff *skb);
@@ -1064,6 +1064,7 @@ static inline struct rxrpc_net *rxrpc_net(struct net *net)
 int rxrpc_send_ack_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb);
 int rxrpc_send_abort_packet(struct rxrpc_call *);
 int rxrpc_send_data_packet(struct rxrpc_call *, struct rxrpc_txbuf *);
+void rxrpc_send_conn_abort(struct rxrpc_connection *);
 void rxrpc_reject_packet(struct rxrpc_local *local, struct sk_buff *skb);
 void rxrpc_send_keepalive(struct rxrpc_peer *);
 void rxrpc_transmit_one(struct rxrpc_call *call, struct rxrpc_txbuf *txb);
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index f31ba1c7d103..924c8dc58ac9 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -442,14 +442,10 @@ void rxrpc_incoming_call(struct rxrpc_sock *rx,
 		call->state = RXRPC_CALL_SERVER_RECV_REQUEST;
 		break;
 
-	case RXRPC_CONN_REMOTELY_ABORTED:
-		__rxrpc_set_call_completion(call, RXRPC_CALL_REMOTELY_ABORTED,
+	case RXRPC_CONN_ABORTED:
+		__rxrpc_set_call_completion(call, conn->completion,
 					    conn->abort_code, conn->error);
 		break;
-	case RXRPC_CONN_LOCALLY_ABORTED:
-		__rxrpc_abort_call("CON", call, 1,
-				   conn->abort_code, conn->error);
-		break;
 	default:
 		BUG();
 	}
diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index 488634f36674..93a892471999 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -16,6 +16,60 @@
 #include <net/ip.h>
 #include "ar-internal.h"
 
+/*
+ * Set the completion state on an aborted connection.
+ */
+static bool rxrpc_set_conn_aborted(struct rxrpc_connection *conn, struct sk_buff *skb,
+				   s32 abort_code, int err,
+				   enum rxrpc_call_completion compl)
+{
+	bool aborted = false;
+
+	if (conn->state != RXRPC_CONN_ABORTED) {
+		spin_lock(&conn->state_lock);
+		if (conn->state != RXRPC_CONN_ABORTED) {
+			conn->abort_code = abort_code;
+			conn->error	 = err;
+			conn->completion = compl;
+			/* Order the abort info before the state change. */
+			smp_store_release(&conn->state, RXRPC_CONN_ABORTED);
+			set_bit(RXRPC_CONN_DONT_REUSE, &conn->flags);
+			set_bit(RXRPC_CONN_EV_ABORT_CALLS, &conn->events);
+			aborted = true;
+		}
+		spin_unlock(&conn->state_lock);
+	}
+
+	return aborted;
+}
+
+/*
+ * Mark a socket buffer to indicate that the connection it's on should be aborted.
+ */
+int rxrpc_abort_conn(struct rxrpc_connection *conn, struct sk_buff *skb,
+		     s32 abort_code, int err, const char *why)
+{
+	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
+
+	if (rxrpc_set_conn_aborted(conn, skb, abort_code, err,
+				   RXRPC_CALL_LOCALLY_ABORTED)) {
+		trace_rxrpc_abort(0, why, sp->hdr.cid, sp->hdr.callNumber,
+				  sp->hdr.seq, abort_code, err);
+		rxrpc_poke_conn(conn, rxrpc_conn_get_poke_abort);
+	}
+	return -EPROTO;
+}
+
+/*
+ * Mark a connection as being remotely aborted.
+ */
+static bool rxrpc_input_conn_abort(struct rxrpc_connection *conn,
+				   struct sk_buff *skb)
+{
+	return rxrpc_set_conn_aborted(conn, skb, skb->priority, -ECONNABORTED,
+				      RXRPC_CALL_REMOTELY_ABORTED);
+}
+
 /*
  * Retransmit terminal ACK or ABORT of the previous call.
  */
@@ -146,9 +200,7 @@ void rxrpc_conn_retransmit_call(struct rxrpc_connection *conn,
 /*
  * pass a connection-level abort onto all calls on that connection
  */
-static void rxrpc_abort_calls(struct rxrpc_connection *conn,
-			      enum rxrpc_call_completion compl,
-			      rxrpc_serial_t serial)
+static void rxrpc_abort_calls(struct rxrpc_connection *conn)
 {
 	struct rxrpc_call *call;
 	int i;
@@ -161,102 +213,17 @@ static void rxrpc_abort_calls(struct rxrpc_connection *conn,
 		call = rcu_dereference_protected(
 			conn->channels[i].call,
 			lockdep_is_held(&conn->bundle->channel_lock));
-		if (call) {
-			if (compl == RXRPC_CALL_LOCALLY_ABORTED)
-				trace_rxrpc_abort(call->debug_id,
-						  "CON", call->cid,
-						  call->call_id, 0,
-						  conn->abort_code,
-						  conn->error);
-			else
-				trace_rxrpc_rx_abort(call, serial,
-						     conn->abort_code);
-			rxrpc_set_call_completion(call, compl,
+		if (call)
+			rxrpc_set_call_completion(call,
+						  conn->completion,
 						  conn->abort_code,
 						  conn->error);
-		}
 	}
 
 	spin_unlock(&conn->bundle->channel_lock);
 	_leave("");
 }
 
-/*
- * generate a connection-level abort
- */
-static int rxrpc_abort_connection(struct rxrpc_connection *conn,
-				  int error, u32 abort_code)
-{
-	struct rxrpc_wire_header whdr;
-	struct msghdr msg;
-	struct kvec iov[2];
-	__be32 word;
-	size_t len;
-	u32 serial;
-	int ret;
-
-	_enter("%d,,%u,%u", conn->debug_id, error, abort_code);
-
-	/* generate a connection-level abort */
-	spin_lock(&conn->state_lock);
-	if (conn->state >= RXRPC_CONN_REMOTELY_ABORTED) {
-		spin_unlock(&conn->state_lock);
-		_leave(" = 0 [already dead]");
-		return 0;
-	}
-
-	conn->error = error;
-	conn->abort_code = abort_code;
-	conn->state = RXRPC_CONN_LOCALLY_ABORTED;
-	set_bit(RXRPC_CONN_DONT_REUSE, &conn->flags);
-	spin_unlock(&conn->state_lock);
-
-	msg.msg_name	= &conn->peer->srx.transport;
-	msg.msg_namelen	= conn->peer->srx.transport_len;
-	msg.msg_control	= NULL;
-	msg.msg_controllen = 0;
-	msg.msg_flags	= 0;
-
-	whdr.epoch	= htonl(conn->proto.epoch);
-	whdr.cid	= htonl(conn->proto.cid);
-	whdr.callNumber	= 0;
-	whdr.seq	= 0;
-	whdr.type	= RXRPC_PACKET_TYPE_ABORT;
-	whdr.flags	= conn->out_clientflag;
-	whdr.userStatus	= 0;
-	whdr.securityIndex = conn->security_ix;
-	whdr._rsvd	= 0;
-	whdr.serviceId	= htons(conn->service_id);
-
-	word		= htonl(conn->abort_code);
-
-	iov[0].iov_base	= &whdr;
-	iov[0].iov_len	= sizeof(whdr);
-	iov[1].iov_base	= &word;
-	iov[1].iov_len	= sizeof(word);
-
-	len = iov[0].iov_len + iov[1].iov_len;
-
-	serial = atomic_inc_return(&conn->serial);
-	rxrpc_abort_calls(conn, RXRPC_CALL_LOCALLY_ABORTED, serial);
-	whdr.serial = htonl(serial);
-
-	ret = kernel_sendmsg(conn->local->socket, &msg, iov, 2, len);
-	if (ret < 0) {
-		trace_rxrpc_tx_fail(conn->debug_id, serial, ret,
-				    rxrpc_tx_point_conn_abort);
-		_debug("sendmsg failed: %d", ret);
-		return -EAGAIN;
-	}
-
-	trace_rxrpc_tx_packet(conn->debug_id, &whdr, rxrpc_tx_point_conn_abort);
-
-	conn->peer->last_tx_at = ktime_get_seconds();
-
-	_leave(" = 0");
-	return 0;
-}
-
 /*
  * mark a call as being on a now-secured channel
  * - must be called with BH's disabled.
@@ -278,26 +245,22 @@ static void rxrpc_call_is_secure(struct rxrpc_call *call)
  * connection-level Rx packet processor
  */
 static int rxrpc_process_event(struct rxrpc_connection *conn,
-			       struct sk_buff *skb,
-			       u32 *_abort_code)
+			       struct sk_buff *skb)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	int loop, ret;
 
-	if (conn->state >= RXRPC_CONN_REMOTELY_ABORTED) {
-		_leave(" = -ECONNABORTED [%u]", conn->state);
+	if (conn->state == RXRPC_CONN_ABORTED)
 		return -ECONNABORTED;
-	}
 
 	_enter("{%d},{%u,%%%u},", conn->debug_id, sp->hdr.type, sp->hdr.serial);
 
 	switch (sp->hdr.type) {
 	case RXRPC_PACKET_TYPE_CHALLENGE:
-		return conn->security->respond_to_challenge(conn, skb,
-							    _abort_code);
+		return conn->security->respond_to_challenge(conn, skb);
 
 	case RXRPC_PACKET_TYPE_RESPONSE:
-		ret = conn->security->verify_response(conn, skb, _abort_code);
+		ret = conn->security->verify_response(conn, skb);
 		if (ret < 0)
 			return ret;
 
@@ -336,26 +299,8 @@ static int rxrpc_process_event(struct rxrpc_connection *conn,
  */
 static void rxrpc_secure_connection(struct rxrpc_connection *conn)
 {
-	u32 abort_code;
-	int ret;
-
-	_enter("{%d}", conn->debug_id);
-
-	ASSERT(conn->security_ix != 0);
-
-	if (conn->security->issue_challenge(conn) < 0) {
-		abort_code = RX_CALL_DEAD;
-		ret = -ENOMEM;
-		goto abort;
-	}
-
-	_leave("");
-	return;
-
-abort:
-	_debug("abort %d, %d", ret, abort_code);
-	rxrpc_abort_connection(conn, ret, abort_code);
-	_leave(" [aborted]");
+	if (conn->security->issue_challenge(conn) < 0)
+		rxrpc_abort_conn(conn, NULL, RX_CALL_DEAD, -ENOMEM, "OOM");
 }
 
 /*
@@ -406,7 +351,6 @@ void rxrpc_process_delayed_final_acks(struct rxrpc_connection *conn, bool force)
 static void rxrpc_do_process_connection(struct rxrpc_connection *conn)
 {
 	struct sk_buff *skb;
-	u32 abort_code = RX_PROTOCOL_ERROR;
 	int ret;
 
 	if (test_and_clear_bit(RXRPC_CONN_EV_CHALLENGE, &conn->events))
@@ -416,33 +360,18 @@ static void rxrpc_do_process_connection(struct rxrpc_connection *conn)
 	 * connection that each one has when we've finished with it */
 	while ((skb = skb_dequeue(&conn->rx_queue))) {
 		rxrpc_see_skb(skb, rxrpc_skb_see_conn_work);
-		ret = rxrpc_process_event(conn, skb, &abort_code);
+		ret = rxrpc_process_event(conn, skb);
 		switch (ret) {
-		case -EPROTO:
-		case -EKEYEXPIRED:
-		case -EKEYREJECTED:
-			goto protocol_error;
 		case -ENOMEM:
 		case -EAGAIN:
-			goto requeue_and_leave;
-		case -ECONNABORTED:
+			skb_queue_head(&conn->rx_queue, skb);
+			rxrpc_queue_conn(conn, rxrpc_conn_queue_retry_work);
+			break;
 		default:
 			rxrpc_free_skb(skb, rxrpc_skb_put_conn_work);
 			break;
 		}
 	}
-
-	return;
-
-requeue_and_leave:
-	skb_queue_head(&conn->rx_queue, skb);
-	return;
-
-protocol_error:
-	if (rxrpc_abort_connection(conn, ret, abort_code) < 0)
-		goto requeue_and_leave;
-	rxrpc_free_skb(skb, rxrpc_skb_put_conn_work);
-	return;
 }
 
 void rxrpc_process_connection(struct work_struct *work)
@@ -480,28 +409,25 @@ int rxrpc_input_conn_packet(struct rxrpc_connection *conn, struct sk_buff *skb)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 
-	if (conn->state >= RXRPC_CONN_REMOTELY_ABORTED) {
-		_leave(" = -ECONNABORTED [%u]", conn->state);
-		return 0;
-	}
-
-	_enter("{%d},{%u,%%%u},", conn->debug_id, sp->hdr.type, sp->hdr.serial);
-
 	switch (sp->hdr.type) {
 	case RXRPC_PACKET_TYPE_BUSY:
 		/* Just ignore BUSY packets for now. */
 		return 0;
 
 	case RXRPC_PACKET_TYPE_ABORT:
-		conn->error = -ECONNABORTED;
-		conn->abort_code = skb->priority;
-		conn->state = RXRPC_CONN_REMOTELY_ABORTED;
-		set_bit(RXRPC_CONN_DONT_REUSE, &conn->flags);
-		rxrpc_abort_calls(conn, RXRPC_CALL_REMOTELY_ABORTED, sp->hdr.serial);
-		return 0;
+		if (smp_load_acquire(&conn->state) == RXRPC_CONN_ABORTED)
+			return true;
+		rxrpc_input_conn_abort(conn, skb);
+		rxrpc_abort_calls(conn);
+		return true;
 
 	case RXRPC_PACKET_TYPE_CHALLENGE:
 	case RXRPC_PACKET_TYPE_RESPONSE:
+		if (smp_load_acquire(&conn->state) == RXRPC_CONN_ABORTED) {
+			if (conn->completion == RXRPC_CALL_LOCALLY_ABORTED)
+				rxrpc_send_conn_abort(conn);
+			return true;
+		}
 		rxrpc_post_packet_to_conn(conn, skb);
 		return 0;
 
@@ -517,6 +443,9 @@ int rxrpc_input_conn_packet(struct rxrpc_connection *conn, struct sk_buff *skb)
  */
 void rxrpc_input_conn_event(struct rxrpc_connection *conn, struct sk_buff *skb)
 {
+	if (test_and_clear_bit(RXRPC_CONN_EV_ABORT_CALLS, &conn->events))
+		rxrpc_abort_calls(conn);
+
 	/* Process delayed ACKs whose time has come. */
 	if (conn->flags & RXRPC_CONN_FINAL_ACK_MASK)
 		rxrpc_process_delayed_final_acks(conn, false);
diff --git a/net/rxrpc/insecure.c b/net/rxrpc/insecure.c
index 0eb8471bfc53..29dcc7d3f51a 100644
--- a/net/rxrpc/insecure.c
+++ b/net/rxrpc/insecure.c
@@ -43,25 +43,15 @@ static void none_free_call_crypto(struct rxrpc_call *call)
 }
 
 static int none_respond_to_challenge(struct rxrpc_connection *conn,
-				     struct sk_buff *skb,
-				     u32 *_abort_code)
+				     struct sk_buff *skb)
 {
-	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
-
-	trace_rxrpc_rx_eproto(NULL, sp->hdr.serial,
-			      tracepoint_string("chall_none"));
-	return -EPROTO;
+	return rxrpc_abort_conn(conn, skb, RX_PROTOCOL_ERROR, -EPROTO, "RXN");
 }
 
 static int none_verify_response(struct rxrpc_connection *conn,
-				struct sk_buff *skb,
-				u32 *_abort_code)
+				struct sk_buff *skb)
 {
-	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
-
-	trace_rxrpc_rx_eproto(NULL, sp->hdr.serial,
-			      tracepoint_string("resp_none"));
-	return -EPROTO;
+	return rxrpc_abort_conn(conn, skb, RX_PROTOCOL_ERROR, -EPROTO, "RXN");
 }
 
 static void none_clear(struct rxrpc_connection *conn)
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 4c2c4b9828b8..4244fbf87fe6 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -517,6 +517,62 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 	goto done;
 }
 
+/*
+ * Transmit a connection-level abort.
+ */
+void rxrpc_send_conn_abort(struct rxrpc_connection *conn)
+{
+	struct rxrpc_wire_header whdr;
+	struct msghdr msg;
+	struct kvec iov[2];
+	__be32 word;
+	size_t len;
+	u32 serial;
+	int ret;
+
+	msg.msg_name	= &conn->peer->srx.transport;
+	msg.msg_namelen	= conn->peer->srx.transport_len;
+	msg.msg_control	= NULL;
+	msg.msg_controllen = 0;
+	msg.msg_flags	= 0;
+
+	whdr.epoch	= htonl(conn->proto.epoch);
+	whdr.cid	= htonl(conn->proto.cid);
+	whdr.callNumber	= 0;
+	whdr.seq	= 0;
+	whdr.type	= RXRPC_PACKET_TYPE_ABORT;
+	whdr.flags	= conn->out_clientflag;
+	whdr.userStatus	= 0;
+	whdr.securityIndex = conn->security_ix;
+	whdr._rsvd	= 0;
+	whdr.serviceId	= htons(conn->service_id);
+
+	word		= htonl(conn->abort_code);
+
+	iov[0].iov_base	= &whdr;
+	iov[0].iov_len	= sizeof(whdr);
+	iov[1].iov_base	= &word;
+	iov[1].iov_len	= sizeof(word);
+
+	len = iov[0].iov_len + iov[1].iov_len;
+
+	serial = atomic_inc_return(&conn->serial);
+	whdr.serial = htonl(serial);
+
+	iov_iter_kvec(&msg.msg_iter, WRITE, iov, 2, len);
+	ret = do_udp_sendmsg(conn->local->socket, &msg, len);
+	if (ret < 0) {
+		trace_rxrpc_tx_fail(conn->debug_id, serial, ret,
+				    rxrpc_tx_point_conn_abort);
+		_debug("sendmsg failed: %d", ret);
+		return;
+	}
+
+	trace_rxrpc_tx_packet(conn->debug_id, &whdr, rxrpc_tx_point_conn_abort);
+
+	conn->peer->last_tx_at = ktime_get_seconds();
+}
+
 /*
  * Reject a packet through the local endpoint.
  */
diff --git a/net/rxrpc/proc.c b/net/rxrpc/proc.c
index 38ea7df3fc42..5c56bcab578c 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -17,8 +17,7 @@ static const char *const rxrpc_conn_states[RXRPC_CONN__NR_STATES] = {
 	[RXRPC_CONN_SERVICE_UNSECURED]		= "SvUnsec ",
 	[RXRPC_CONN_SERVICE_CHALLENGING]	= "SvChall ",
 	[RXRPC_CONN_SERVICE]			= "SvSecure",
-	[RXRPC_CONN_REMOTELY_ABORTED]		= "RmtAbort",
-	[RXRPC_CONN_LOCALLY_ABORTED]		= "LocAbort",
+	[RXRPC_CONN_ABORTED]			= "Aborted ",
 };
 
 /*
@@ -141,6 +140,7 @@ static int rxrpc_connection_seq_show(struct seq_file *seq, void *v)
 {
 	struct rxrpc_connection *conn;
 	struct rxrpc_net *rxnet = rxrpc_net(seq_file_net(seq));
+	const char *state;
 	char lbuff[50], rbuff[50];
 
 	if (v == &rxnet->conn_proc_list) {
@@ -161,9 +161,11 @@ static int rxrpc_connection_seq_show(struct seq_file *seq, void *v)
 	}
 
 	sprintf(lbuff, "%pISpc", &conn->local->srx.transport);
-
 	sprintf(rbuff, "%pISpc", &conn->peer->srx.transport);
 print:
+	state = smp_load_acquire(&conn->state) == RXRPC_CONN_ABORTED ?
+		rxrpc_call_completions[conn->completion] :
+		rxrpc_conn_states[conn->state];
 	seq_printf(seq,
 		   "UDP   %-47.47s %-47.47s %4x %08x %s %3u %3d"
 		   " %s %08x %08x %08x %08x %08x %08x %08x\n",
@@ -174,7 +176,7 @@ static int rxrpc_connection_seq_show(struct seq_file *seq, void *v)
 		   rxrpc_conn_is_service(conn) ? "Svc" : "Clt",
 		   refcount_read(&conn->ref),
 		   atomic_read(&conn->active),
-		   rxrpc_conn_states[conn->state],
+		   state,
 		   key_serial(conn->key),
 		   atomic_read(&conn->serial),
 		   conn->hi_serial,
diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index d1233720e05f..5d2fbc6ec3cf 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -821,8 +821,7 @@ static int rxkad_encrypt_response(struct rxrpc_connection *conn,
  * respond to a challenge packet
  */
 static int rxkad_respond_to_challenge(struct rxrpc_connection *conn,
-				      struct sk_buff *skb,
-				      u32 *_abort_code)
+				      struct sk_buff *skb)
 {
 	const struct rxrpc_key_token *token;
 	struct rxkad_challenge challenge;
@@ -898,7 +897,7 @@ static int rxkad_respond_to_challenge(struct rxrpc_connection *conn,
 	trace_rxrpc_rx_eproto(NULL, sp->hdr.serial, eproto);
 	ret = -EPROTO;
 other_error:
-	*_abort_code = abort_code;
+	rxrpc_abort_conn(conn, skb, abort_code, ret, "RXK");
 	return ret;
 }
 
@@ -910,8 +909,7 @@ static int rxkad_decrypt_ticket(struct rxrpc_connection *conn,
 				struct sk_buff *skb,
 				void *ticket, size_t ticket_len,
 				struct rxrpc_crypt *_session_key,
-				time64_t *_expiry,
-				u32 *_abort_code)
+				time64_t *_expiry)
 {
 	struct skcipher_request *req;
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
@@ -1042,8 +1040,7 @@ static int rxkad_decrypt_ticket(struct rxrpc_connection *conn,
 	abort_code = RXKADBADTICKET;
 	ret = -EPROTO;
 other_error:
-	*_abort_code = abort_code;
-	return ret;
+	return rxrpc_abort_conn(conn, skb, abort_code, ret, "RXK");
 temporary_error:
 	return ret;
 }
@@ -1086,8 +1083,7 @@ static void rxkad_decrypt_response(struct rxrpc_connection *conn,
  * verify a response
  */
 static int rxkad_verify_response(struct rxrpc_connection *conn,
-				 struct sk_buff *skb,
-				 u32 *_abort_code)
+				 struct sk_buff *skb)
 {
 	struct rxkad_response *response;
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
@@ -1115,11 +1111,8 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 			abort_code = RXKADNOAUTH;
 			break;
 		}
-		trace_rxrpc_abort(0, "SVK",
-				  sp->hdr.cid, sp->hdr.callNumber, sp->hdr.seq,
-				  abort_code, PTR_ERR(server_key));
-		*_abort_code = abort_code;
-		return -EPROTO;
+		return rxrpc_abort_conn(conn, skb, abort_code,
+					PTR_ERR(server_key), "RXK");
 	}
 
 	ret = -ENOMEM;
@@ -1168,7 +1161,7 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 		goto temporary_error_free_ticket;
 
 	ret = rxkad_decrypt_ticket(conn, server_key, skb, ticket, ticket_len,
-				   &session_key, &expiry, _abort_code);
+				   &session_key, &expiry);
 	if (ret < 0)
 		goto temporary_error_free_ticket;
 
@@ -1246,10 +1239,9 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 	kfree(ticket);
 protocol_error:
 	kfree(response);
-	trace_rxrpc_rx_eproto(NULL, sp->hdr.serial, eproto);
 	key_put(server_key);
-	*_abort_code = abort_code;
-	return -EPROTO;
+	trace_rxrpc_rx_eproto(NULL, sp->hdr.serial, eproto);
+	return rxrpc_abort_conn(conn, skb, abort_code, -EPROTO, "RXK");
 
 temporary_error_free_ticket:
 	kfree(ticket);


