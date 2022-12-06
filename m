Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88495644888
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234587AbiLFQBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:01:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235108AbiLFQAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:00:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB5D02D772
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 07:59:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670342381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lkli6dmEQ4Mcb8Om1fjjKp1TiUH43Z+p4yOJ67WTCvY=;
        b=E7IROKjyWnVtBaQTlyinQh7565qnZv28bEuWkGA7KqN0O/fBRSyJCnITf8mWiIuQnNFmf7
        d7RcD7Nod5LHb8dbakDzhwE+XCTrEJYrbGwTVIeyBQ034PN/PIYMxyjfuNLsa1jcBkob0X
        ybqDk5VqJ9BI2h3otKOalI/dDa0F1r4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-116-4FAFcoGZOeK3Vw0KL80jMg-1; Tue, 06 Dec 2022 10:59:37 -0500
X-MC-Unique: 4FAFcoGZOeK3Vw0KL80jMg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8D197811E7A;
        Tue,  6 Dec 2022 15:59:37 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE3651759E;
        Tue,  6 Dec 2022 15:59:36 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 07/32] rxrpc: Only set/transmit aborts in the I/O
 thread
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Tue, 06 Dec 2022 15:59:33 +0000
Message-ID: <167034237388.1105287.8478228096444646375.stgit@warthog.procyon.org.uk>
In-Reply-To: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
References: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |    1 +
 net/rxrpc/ar-internal.h      |    6 +++++-
 net/rxrpc/call_event.c       |    7 ++++++-
 net/rxrpc/call_object.c      |    5 ++---
 net/rxrpc/input.c            |    6 ++----
 net/rxrpc/recvmsg.c          |    2 ++
 net/rxrpc/sendmsg.c          |   28 +++++++++++++++++++++-------
 7 files changed, 39 insertions(+), 16 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 049b52e7aa6a..72f020b829e0 100644
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
index 755395d1f2ca..ca99e94318fc 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -623,7 +623,10 @@ struct rxrpc_call {
 	unsigned long		events;
 	spinlock_t		notify_lock;	/* Kernel notification lock */
 	spinlock_t		state_lock;	/* lock for state transition */
-	u32			abort_code;	/* Local/remote abort code */
+	const char		*send_abort_why; /* String indicating why the abort was sent */
+	s32			send_abort;	/* Abort code to be sent */
+	short			send_abort_err;	/* Error to be associated with the abort */
+	s32			abort_code;	/* Local/remote abort code */
 	int			error;		/* Local error incurred */
 	enum rxrpc_call_state	state;		/* current state of call */
 	enum rxrpc_call_completion completion;	/* Call completion condition */
@@ -1146,6 +1149,7 @@ struct key *rxrpc_look_up_server_security(struct rxrpc_connection *,
 /*
  * sendmsg.c
  */
+bool rxrpc_propose_abort(struct rxrpc_call *, u32, int, const char *);
 int rxrpc_do_sendmsg(struct rxrpc_sock *, struct msghdr *, size_t);
 
 /*
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index b2cf448fb02c..a8b5dff09999 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -336,6 +336,7 @@ void rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb)
 	unsigned long now, next, t;
 	rxrpc_serial_t ackr_serial;
 	bool resend = false, expired = false;
+	s32 abort_code;
 
 	rxrpc_see_call(call, rxrpc_call_see_input);
 
@@ -346,6 +347,11 @@ void rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb)
 	if (call->state == RXRPC_CALL_COMPLETE)
 		goto out;
 
+	abort_code = smp_load_acquire(&call->send_abort);
+	if (abort_code)
+		rxrpc_abort_call(call->send_abort_why, call, 0, call->send_abort,
+				 call->send_abort_err);
+
 	if (skb && skb->mark == RXRPC_SKB_MARK_ERROR)
 		goto out;
 
@@ -433,7 +439,6 @@ void rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb)
 		} else {
 			rxrpc_abort_call("EXP", call, 0, RX_CALL_TIMEOUT, -ETIME);
 		}
-		rxrpc_send_abort_packet(call);
 		goto out;
 	}
 
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 07abf12e99bb..f7606cdf4209 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -588,7 +588,7 @@ void rxrpc_release_calls_on_socket(struct rxrpc_sock *rx)
 		call = list_entry(rx->to_be_accepted.next,
 				  struct rxrpc_call, accept_link);
 		list_del(&call->accept_link);
-		rxrpc_abort_call("SKR", call, 0, RX_CALL_DEAD, -ECONNRESET);
+		rxrpc_propose_abort(call, RX_CALL_DEAD, -ECONNRESET, "SKR");
 		rxrpc_put_call(call, rxrpc_call_put_release_sock_tba);
 	}
 
@@ -596,8 +596,7 @@ void rxrpc_release_calls_on_socket(struct rxrpc_sock *rx)
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
index 3b2e8e7d2e0f..58077b5bfb68 100644
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
@@ -1005,8 +1004,7 @@ void rxrpc_implicit_end_call(struct rxrpc_call *call, struct sk_buff *skb)
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
index a9c9b2a8a27a..492608973935 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -135,6 +135,8 @@ bool rxrpc_abort_call(const char *why, struct rxrpc_call *call,
 	spin_lock(&call->state_lock);
 	ret = __rxrpc_abort_call(why, call, seq, abort_code, error);
 	spin_unlock(&call->state_lock);
+	if (ret)
+		rxrpc_send_abort_packet(call);
 	return ret;
 }
 
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 816c1b083a69..c8cb3b76633c 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -17,6 +17,25 @@
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
@@ -660,9 +679,8 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
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
@@ -755,11 +773,7 @@ bool rxrpc_kernel_abort_call(struct socket *sock, struct rxrpc_call *call,
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


