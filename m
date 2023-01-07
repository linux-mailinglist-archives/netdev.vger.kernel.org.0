Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4838660D73
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 10:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjAGJy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 04:54:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235751AbjAGJyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 04:54:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6B37DE20
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 01:53:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673085205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AStRe60camcT860XwkLJ5f5lB9U42lupPdKW5zTep2E=;
        b=ZB0aD8IvuhIoxiLFFpp7y0gMuxBt1f3VkFBAPoJfVfXE7hklDx9SIwyPoaS2qVXzvlrt17
        Fs9y8I+izfrA8F4G0f4T65hCFKf+ORYPOBvaWjGIzBCyoH9x/+5qpP/8pC5QSYOEmZxnrw
        uzY1MPdQvREtILXOllH5FdvG8Xa1aFo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-384-mcdTO3GUM5yf4aw5l7TiSA-1; Sat, 07 Jan 2023 04:53:20 -0500
X-MC-Unique: mcdTO3GUM5yf4aw5l7TiSA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5555F3C025B6;
        Sat,  7 Jan 2023 09:53:20 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.87])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E0BD492B00;
        Sat,  7 Jan 2023 09:53:19 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 04/19] rxrpc: Only set/transmit aborts in the I/O thread
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Sat, 07 Jan 2023 09:53:19 +0000
Message-ID: <167308519906.1538866.9383740065298327242.stgit@warthog.procyon.org.uk>
In-Reply-To: <167308517118.1538866.3440481802366869065.stgit@warthog.procyon.org.uk>
References: <167308517118.1538866.3440481802366869065.stgit@warthog.procyon.org.uk>
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

Only set the abort call completion state in the I/O thread and only
transmit ABORT packets from there.  rxrpc_abort_call() can then be made to
actually send the packet.

Further, ABORT packets should only be sent if the call has been exposed to
the network (ie. at least one attempted DATA transmission has occurred for
it).

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |    1 +
 net/rxrpc/ar-internal.h      |    7 ++++++-
 net/rxrpc/call_event.c       |   16 +++++++++++++---
 net/rxrpc/call_object.c      |    7 ++++---
 net/rxrpc/input.c            |    6 ++----
 net/rxrpc/recvmsg.c          |    2 ++
 net/rxrpc/sendmsg.c          |   29 ++++++++++++++++++++++-------
 7 files changed, 50 insertions(+), 18 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index b526d982da7e..c44cc01de750 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -17,6 +17,7 @@
  * Declare tracing information enums and their string mappings for display.
  */
 #define rxrpc_call_poke_traces \
+	EM(rxrpc_call_poke_abort,		"Abort")	\
 	EM(rxrpc_call_poke_error,		"Error")	\
 	EM(rxrpc_call_poke_idle,		"Idle")		\
 	EM(rxrpc_call_poke_start,		"Start")	\
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index f3b8806e7241..0cf28a56aec5 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -625,7 +625,10 @@ struct rxrpc_call {
 	unsigned long		events;
 	spinlock_t		notify_lock;	/* Kernel notification lock */
 	rwlock_t		state_lock;	/* lock for state transition */
-	u32			abort_code;	/* Local/remote abort code */
+	const char		*send_abort_why; /* String indicating why the abort was sent */
+	s32			send_abort;	/* Abort code to be sent */
+	short			send_abort_err;	/* Error to be associated with the abort */
+	s32			abort_code;	/* Local/remote abort code */
 	int			error;		/* Local error incurred */
 	enum rxrpc_call_state	state;		/* current state of call */
 	enum rxrpc_call_completion completion;	/* Call completion condition */
@@ -1146,6 +1149,8 @@ struct key *rxrpc_look_up_server_security(struct rxrpc_connection *,
 /*
  * sendmsg.c
  */
+bool rxrpc_propose_abort(struct rxrpc_call *call,
+			 u32 abort_code, int error, const char *why);
 int rxrpc_do_sendmsg(struct rxrpc_sock *, struct msghdr *, size_t);
 
 /*
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index b2cf448fb02c..b7efecf5ccfc 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -270,9 +270,11 @@ static void rxrpc_decant_prepared_tx(struct rxrpc_call *call)
 {
 	struct rxrpc_txbuf *txb;
 
-	if (rxrpc_is_client_call(call) &&
-	    !test_bit(RXRPC_CALL_EXPOSED, &call->flags))
+	if (!test_bit(RXRPC_CALL_EXPOSED, &call->flags)) {
+		if (list_empty(&call->tx_sendmsg))
+			return;
 		rxrpc_expose_client_call(call);
+	}
 
 	while ((txb = list_first_entry_or_null(&call->tx_sendmsg,
 					       struct rxrpc_txbuf, call_link))) {
@@ -336,6 +338,7 @@ void rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb)
 	unsigned long now, next, t;
 	rxrpc_serial_t ackr_serial;
 	bool resend = false, expired = false;
+	s32 abort_code;
 
 	rxrpc_see_call(call, rxrpc_call_see_input);
 
@@ -346,6 +349,14 @@ void rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb)
 	if (call->state == RXRPC_CALL_COMPLETE)
 		goto out;
 
+	/* Handle abort request locklessly, vs rxrpc_propose_abort(). */
+	abort_code = smp_load_acquire(&call->send_abort);
+	if (abort_code) {
+		rxrpc_abort_call(call->send_abort_why, call, 0, call->send_abort,
+				 call->send_abort_err);
+		goto out;
+	}
+
 	if (skb && skb->mark == RXRPC_SKB_MARK_ERROR)
 		goto out;
 
@@ -433,7 +444,6 @@ void rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb)
 		} else {
 			rxrpc_abort_call("EXP", call, 0, RX_CALL_TIMEOUT, -ETIME);
 		}
-		rxrpc_send_abort_packet(call);
 		goto out;
 	}
 
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 239fc3c75079..298b7c465d7e 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -430,6 +430,8 @@ void rxrpc_incoming_call(struct rxrpc_sock *rx,
 	call->state		= RXRPC_CALL_SERVER_SECURING;
 	call->cong_tstamp	= skb->tstamp;
 
+	__set_bit(RXRPC_CALL_EXPOSED, &call->flags);
+
 	spin_lock(&conn->state_lock);
 
 	switch (conn->state) {
@@ -590,7 +592,7 @@ void rxrpc_release_calls_on_socket(struct rxrpc_sock *rx)
 		call = list_entry(rx->to_be_accepted.next,
 				  struct rxrpc_call, accept_link);
 		list_del(&call->accept_link);
-		rxrpc_abort_call("SKR", call, 0, RX_CALL_DEAD, -ECONNRESET);
+		rxrpc_propose_abort(call, RX_CALL_DEAD, -ECONNRESET, "SKR");
 		rxrpc_put_call(call, rxrpc_call_put_release_sock_tba);
 	}
 
@@ -598,8 +600,7 @@ void rxrpc_release_calls_on_socket(struct rxrpc_sock *rx)
 		call = list_entry(rx->sock_calls.next,
 				  struct rxrpc_call, sock_link);
 		rxrpc_get_call(call, rxrpc_call_get_release_sock);
-		rxrpc_abort_call("SKT", call, 0, RX_CALL_DEAD, -ECONNRESET);
-		rxrpc_send_abort_packet(call);
+		rxrpc_propose_abort(call, RX_CALL_DEAD, -ECONNRESET, "SKT");
 		rxrpc_release_call(rx, call);
 		rxrpc_put_call(call, rxrpc_call_put_release_sock);
 	}
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index d0e20e946e48..1f03a286620d 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -12,8 +12,7 @@
 static void rxrpc_proto_abort(const char *why,
 			      struct rxrpc_call *call, rxrpc_seq_t seq)
 {
-	if (rxrpc_abort_call(why, call, seq, RX_PROTOCOL_ERROR, -EBADMSG))
-		rxrpc_send_abort_packet(call);
+	rxrpc_abort_call(why, call, seq, RX_PROTOCOL_ERROR, -EBADMSG);
 }
 
 /*
@@ -1007,8 +1006,7 @@ void rxrpc_implicit_end_call(struct rxrpc_call *call, struct sk_buff *skb)
 	case RXRPC_CALL_COMPLETE:
 		break;
 	default:
-		if (rxrpc_abort_call("IMP", call, 0, RX_CALL_DEAD, -ESHUTDOWN))
-			rxrpc_send_abort_packet(call);
+		rxrpc_abort_call("IMP", call, 0, RX_CALL_DEAD, -ESHUTDOWN);
 		trace_rxrpc_improper_term(call);
 		break;
 	}
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index 6ebd6440a2b7..a4ccdc006d0f 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -134,6 +134,8 @@ bool rxrpc_abort_call(const char *why, struct rxrpc_call *call,
 	write_lock(&call->state_lock);
 	ret = __rxrpc_abort_call(why, call, seq, abort_code, error);
 	write_unlock(&call->state_lock);
+	if (ret && test_bit(RXRPC_CALL_EXPOSED, &call->flags))
+		rxrpc_send_abort_packet(call);
 	return ret;
 }
 
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index cde1e65f16b4..dc3c2a834fc8 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -17,6 +17,26 @@
 #include <net/af_rxrpc.h>
 #include "ar-internal.h"
 
+/*
+ * Propose an abort to be made in the I/O thread.
+ */
+bool rxrpc_propose_abort(struct rxrpc_call *call,
+			 u32 abort_code, int error, const char *why)
+{
+	_enter("{%d},%d,%d,%s", call->debug_id, abort_code, error, why);
+
+	if (!call->send_abort && call->state < RXRPC_CALL_COMPLETE) {
+		call->send_abort_why = why;
+		call->send_abort_err = error;
+		/* Request abort locklessly vs rxrpc_input_call_event(). */
+		smp_store_release(&call->send_abort, abort_code);
+		rxrpc_poke_call(call, rxrpc_call_poke_abort);
+		return true;
+	}
+
+	return false;
+}
+
 /*
  * Return true if there's sufficient Tx queue space.
  */
@@ -663,9 +683,8 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
 		/* it's too late for this call */
 		ret = -ESHUTDOWN;
 	} else if (p.command == RXRPC_CMD_SEND_ABORT) {
+		rxrpc_propose_abort(call, p.abort_code, -ECONNABORTED, "CMD");
 		ret = 0;
-		if (rxrpc_abort_call("CMD", call, 0, p.abort_code, -ECONNABORTED))
-			ret = rxrpc_send_abort_packet(call);
 	} else if (p.command != RXRPC_CMD_SEND_DATA) {
 		ret = -EINVAL;
 	} else {
@@ -760,11 +779,7 @@ bool rxrpc_kernel_abort_call(struct socket *sock, struct rxrpc_call *call,
 	_enter("{%d},%d,%d,%s", call->debug_id, abort_code, error, why);
 
 	mutex_lock(&call->user_mutex);
-
-	aborted = rxrpc_abort_call(why, call, 0, abort_code, error);
-	if (aborted)
-		rxrpc_send_abort_packet(call);
-
+	aborted = rxrpc_propose_abort(call, abort_code, error, why);
 	mutex_unlock(&call->user_mutex);
 	return aborted;
 }


