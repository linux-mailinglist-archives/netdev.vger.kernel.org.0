Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20147E5D56
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbfJZNgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:36:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726777AbfJZNQc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:16:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DFC6222C1;
        Sat, 26 Oct 2019 13:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095791;
        bh=nt28z379L3xzDsUOBtOFpHIW+q40Fn0WeTFOyvoqjeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CgOVNQVClacV5MwZ8gnscADhEXZpknX5BVMV08AWc7K0ze9wpTp4CvfHVuCqGrgZo
         7ADCGSbzo4rDZtGZX0AsJTjxKoUxshQ7GtTZVf37P85eMLtwCcD/0KAZIY7ffO89Cl
         NItXQ1DCTbV5HURBc7ZN3QUPhfscVYyG2+Ec+E1I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 19/99] rxrpc: Fix trace-after-put looking at the put call record
Date:   Sat, 26 Oct 2019 09:14:40 -0400
Message-Id: <20191026131600.2507-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 48c9e0ec7cbbb7370448f859ccc8e3b7eb69e755 ]

rxrpc_put_call() calls trace_rxrpc_call() after it has done the decrement
of the refcount - which looks at the debug_id in the call record.  But
unless the refcount was reduced to zero, we no longer have the right to
look in the record and, indeed, it may be deleted by some other thread.

Fix this by getting the debug_id out before decrementing the refcount and
then passing that into the tracepoint.

Fixes: e34d4234b0b7 ("rxrpc: Trace rxrpc_call usage")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/rxrpc.h |  6 +++---
 net/rxrpc/call_accept.c      |  2 +-
 net/rxrpc/call_object.c      | 28 +++++++++++++++++-----------
 3 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 38a97e890cb67..191fe447f9908 100644
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
index c1b1b7dd29245..1f778102ed8d7 100644
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
index 014548c259ceb..7f862a039eddc 100644
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
@@ -532,12 +537,13 @@ void rxrpc_put_call(struct rxrpc_call *call, enum rxrpc_call_trace op)
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
-- 
2.20.1

