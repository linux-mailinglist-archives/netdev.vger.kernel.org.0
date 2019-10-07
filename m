Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92279CDEFB
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 12:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbfJGKQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 06:16:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59134 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726010AbfJGKQI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 06:16:08 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6C19A18C4278;
        Mon,  7 Oct 2019 10:16:07 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-125-72.rdu2.redhat.com [10.10.125.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6001960C05;
        Mon,  7 Oct 2019 10:16:06 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 4/6] rxrpc: Fix trace-after-put looking at the put call
 record
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 07 Oct 2019 11:16:05 +0100
Message-ID: <157044336559.32635.15827348355107141845.stgit@warthog.procyon.org.uk>
In-Reply-To: <157044333551.32635.10133219357337058780.stgit@warthog.procyon.org.uk>
References: <157044333551.32635.10133219357337058780.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.62]); Mon, 07 Oct 2019 10:16:07 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rxrpc_put_call() calls trace_rxrpc_call() after it has done the decrement
of the refcount - which looks at the debug_id in the call record.  But
unless the refcount was reduced to zero, we no longer have the right to
look in the record and, indeed, it may be deleted by some other thread.

Fix this by getting the debug_id out before decrementing the refcount and
then passing that into the tracepoint.

Fixes: e34d4234b0b7 ("rxrpc: Trace rxrpc_call usage")
Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/trace/events/rxrpc.h |    6 +++---
 net/rxrpc/call_accept.c      |    2 +-
 net/rxrpc/call_object.c      |   28 +++++++++++++++++-----------
 3 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 38a97e890cb6..191fe447f990 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -606,10 +606,10 @@ TRACE_EVENT(rxrpc_client,
 	    );
 
 TRACE_EVENT(rxrpc_call,
-	    TP_PROTO(struct rxrpc_call *call, enum rxrpc_call_trace op,
+	    TP_PROTO(unsigned int call_debug_id, enum rxrpc_call_trace op,
 		     int usage, const void *where, const void *aux),
 
-	    TP_ARGS(call, op, usage, where, aux),
+	    TP_ARGS(call_debug_id, op, usage, where, aux),
 
 	    TP_STRUCT__entry(
 		    __field(unsigned int,		call		)
@@ -620,7 +620,7 @@ TRACE_EVENT(rxrpc_call,
 			     ),
 
 	    TP_fast_assign(
-		    __entry->call = call->debug_id;
+		    __entry->call = call_debug_id;
 		    __entry->op = op;
 		    __entry->usage = usage;
 		    __entry->where = where;
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index c1b1b7dd2924..1f778102ed8d 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -97,7 +97,7 @@ static int rxrpc_service_prealloc_one(struct rxrpc_sock *rx,
 	call->flags |= (1 << RXRPC_CALL_IS_SERVICE);
 	call->state = RXRPC_CALL_SERVER_PREALLOC;
 
-	trace_rxrpc_call(call, rxrpc_call_new_service,
+	trace_rxrpc_call(call->debug_id, rxrpc_call_new_service,
 			 atomic_read(&call->usage),
 			 here, (const void *)user_call_ID);
 
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 32d8dc677142..6dace078971a 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -240,7 +240,8 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 	if (p->intr)
 		__set_bit(RXRPC_CALL_IS_INTR, &call->flags);
 	call->tx_total_len = p->tx_total_len;
-	trace_rxrpc_call(call, rxrpc_call_new_client, atomic_read(&call->usage),
+	trace_rxrpc_call(call->debug_id, rxrpc_call_new_client,
+			 atomic_read(&call->usage),
 			 here, (const void *)p->user_call_ID);
 
 	/* We need to protect a partially set up call against the user as we
@@ -290,8 +291,8 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 	if (ret < 0)
 		goto error;
 
-	trace_rxrpc_call(call, rxrpc_call_connected, atomic_read(&call->usage),
-			 here, NULL);
+	trace_rxrpc_call(call->debug_id, rxrpc_call_connected,
+			 atomic_read(&call->usage), here, NULL);
 
 	rxrpc_start_call_timer(call);
 
@@ -313,8 +314,8 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 error:
 	__rxrpc_set_call_completion(call, RXRPC_CALL_LOCAL_ERROR,
 				    RX_CALL_DEAD, ret);
-	trace_rxrpc_call(call, rxrpc_call_error, atomic_read(&call->usage),
-			 here, ERR_PTR(ret));
+	trace_rxrpc_call(call->debug_id, rxrpc_call_error,
+			 atomic_read(&call->usage), here, ERR_PTR(ret));
 	rxrpc_release_call(rx, call);
 	mutex_unlock(&call->user_mutex);
 	rxrpc_put_call(call, rxrpc_call_put);
@@ -376,7 +377,8 @@ bool rxrpc_queue_call(struct rxrpc_call *call)
 	if (n == 0)
 		return false;
 	if (rxrpc_queue_work(&call->processor))
-		trace_rxrpc_call(call, rxrpc_call_queued, n + 1, here, NULL);
+		trace_rxrpc_call(call->debug_id, rxrpc_call_queued, n + 1,
+				 here, NULL);
 	else
 		rxrpc_put_call(call, rxrpc_call_put_noqueue);
 	return true;
@@ -391,7 +393,8 @@ bool __rxrpc_queue_call(struct rxrpc_call *call)
 	int n = atomic_read(&call->usage);
 	ASSERTCMP(n, >=, 1);
 	if (rxrpc_queue_work(&call->processor))
-		trace_rxrpc_call(call, rxrpc_call_queued_ref, n, here, NULL);
+		trace_rxrpc_call(call->debug_id, rxrpc_call_queued_ref, n,
+				 here, NULL);
 	else
 		rxrpc_put_call(call, rxrpc_call_put_noqueue);
 	return true;
@@ -406,7 +409,8 @@ void rxrpc_see_call(struct rxrpc_call *call)
 	if (call) {
 		int n = atomic_read(&call->usage);
 
-		trace_rxrpc_call(call, rxrpc_call_seen, n, here, NULL);
+		trace_rxrpc_call(call->debug_id, rxrpc_call_seen, n,
+				 here, NULL);
 	}
 }
 
@@ -418,7 +422,7 @@ void rxrpc_get_call(struct rxrpc_call *call, enum rxrpc_call_trace op)
 	const void *here = __builtin_return_address(0);
 	int n = atomic_inc_return(&call->usage);
 
-	trace_rxrpc_call(call, op, n, here, NULL);
+	trace_rxrpc_call(call->debug_id, op, n, here, NULL);
 }
 
 /*
@@ -445,7 +449,8 @@ void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
 
 	_enter("{%d,%d}", call->debug_id, atomic_read(&call->usage));
 
-	trace_rxrpc_call(call, rxrpc_call_release, atomic_read(&call->usage),
+	trace_rxrpc_call(call->debug_id, rxrpc_call_release,
+			 atomic_read(&call->usage),
 			 here, (const void *)call->flags);
 
 	ASSERTCMP(call->state, ==, RXRPC_CALL_COMPLETE);
@@ -534,12 +539,13 @@ void rxrpc_put_call(struct rxrpc_call *call, enum rxrpc_call_trace op)
 {
 	struct rxrpc_net *rxnet = call->rxnet;
 	const void *here = __builtin_return_address(0);
+	unsigned int debug_id = call->debug_id;
 	int n;
 
 	ASSERT(call != NULL);
 
 	n = atomic_dec_return(&call->usage);
-	trace_rxrpc_call(call, op, n, here, NULL);
+	trace_rxrpc_call(debug_id, op, n, here, NULL);
 	ASSERTCMP(n, >=, 0);
 	if (n == 0) {
 		_debug("call %d dead", call->debug_id);

