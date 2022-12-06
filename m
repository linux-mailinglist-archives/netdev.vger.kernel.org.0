Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC5AC64488C
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234978AbiLFQBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:01:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235191AbiLFQBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:01:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53BF02EF00
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 07:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670342397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V3R1kuEb365V8d9nhtT2KK7hcJTq9KxSkMNZo96Kb8g=;
        b=BLGaiajuePi/82S05oh7dPUQ6kAS3057oNVFV+nXPqbUIS4/u9VPVCSaVatxRogPHxSA78
        w3UDgMnNPA6hzChrMDYCGE6QDqQSsUp9UxJvtTIy3EV380HJY36nWNVcdhLydJu3AGjOfc
        1B8Trgl5KZano23c1IgMNShVbzwc9tA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-7-EChUbyVpNSuY861Fcu7qdg-1; Tue, 06 Dec 2022 10:59:46 -0500
X-MC-Unique: EChUbyVpNSuY861Fcu7qdg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 280A41C008A6;
        Tue,  6 Dec 2022 15:59:46 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A27840C2064;
        Tue,  6 Dec 2022 15:59:45 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 08/32] rxrpc: Only disconnect calls in the I/O thread
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Tue, 06 Dec 2022 15:59:42 +0000
Message-ID: <167034238272.1105287.7060192019565466718.stgit@warthog.procyon.org.uk>
In-Reply-To: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
References: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only perform call disconnection in the I/O thread to reduce the locking
requirement.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |    1 +
 net/rxrpc/call_event.c       |   14 +++++++++++++-
 net/rxrpc/call_object.c      |    9 +--------
 net/rxrpc/input.c            |    1 -
 net/rxrpc/recvmsg.c          |    1 +
 5 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 72f020b829e0..49a0f799cdef 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -18,6 +18,7 @@
  */
 #define rxrpc_call_poke_traces \
 	EM(rxrpc_call_poke_abort,		"Abort")	\
+	EM(rxrpc_call_poke_complete,		"Compl")	\
 	EM(rxrpc_call_poke_error,		"Error")	\
 	EM(rxrpc_call_poke_idle,		"Idle")		\
 	EM(rxrpc_call_poke_start,		"Start")	\
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index a8b5dff09999..bf6858e69187 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -347,6 +347,13 @@ void rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb)
 	if (call->state == RXRPC_CALL_COMPLETE)
 		goto out;
 
+	if (!call->conn) {
+		printk("\n");
+		printk("\n");
+		kdebug("no conn %u", call->state);
+		printk("\n");
+	}
+
 	abort_code = smp_load_acquire(&call->send_abort);
 	if (abort_code)
 		rxrpc_abort_call(call->send_abort_why, call, 0, call->send_abort,
@@ -479,8 +486,13 @@ void rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb)
 	}
 
 out:
-	if (call->state == RXRPC_CALL_COMPLETE)
+	if (call->state == RXRPC_CALL_COMPLETE) {
 		del_timer_sync(&call->timer);
+		if (!test_bit(RXRPC_CALL_DISCONNECTED, &call->flags))
+			rxrpc_disconnect_call(call);
+		if (call->security)
+			call->security->free_call_crypto(call);
+	}
 	if (call->acks_hard_ack != call->tx_bottom)
 		rxrpc_shrink_call_tx_buffer(call);
 	_leave("");
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index f7606cdf4209..a9c77be9107a 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -50,7 +50,7 @@ void rxrpc_poke_call(struct rxrpc_call *call, enum rxrpc_call_poke_trace what)
 	struct rxrpc_local *local = call->local;
 	bool busy;
 
-	if (call->state < RXRPC_CALL_COMPLETE) {
+	if (!test_bit(RXRPC_CALL_DISCONNECTED, &call->flags)) {
 		spin_lock_bh(&local->lock);
 		busy = !list_empty(&call->attend_link);
 		trace_rxrpc_poke_call(call, busy, what);
@@ -529,13 +529,10 @@ void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
 	trace_rxrpc_call(call->debug_id, refcount_read(&call->ref),
 			 call->flags, rxrpc_call_see_release);
 
-	ASSERTCMP(call->state, ==, RXRPC_CALL_COMPLETE);
-
 	if (test_and_set_bit(RXRPC_CALL_RELEASED, &call->flags))
 		BUG();
 
 	rxrpc_put_call_slot(call);
-	del_timer_sync(&call->timer);
 
 	/* Make sure we don't get any more notifications */
 	spin_lock(&rx->recvmsg_lock);
@@ -568,10 +565,6 @@ void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
 
 	_debug("RELEASE CALL %p (%d CONN %p)", call, call->debug_id, conn);
 
-	if (conn && !test_bit(RXRPC_CALL_DISCONNECTED, &call->flags))
-		rxrpc_disconnect_call(call);
-	if (call->security)
-		call->security->free_call_crypto(call);
 	_leave("");
 }
 
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 58077b5bfb68..a72fd2f78fc0 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -1010,5 +1010,4 @@ void rxrpc_implicit_end_call(struct rxrpc_call *call, struct sk_buff *skb)
 	}
 
 	rxrpc_input_call_event(call, skb);
-	rxrpc_disconnect_call(call);
 }
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index 492608973935..88298ab8a9d7 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -202,6 +202,7 @@ static void rxrpc_end_rx_phase(struct rxrpc_call *call, rxrpc_serial_t serial)
 	case RXRPC_CALL_CLIENT_RECV_REPLY:
 		__rxrpc_call_completed(call);
 		spin_unlock(&call->state_lock);
+		rxrpc_poke_call(call, rxrpc_call_poke_complete);
 		break;
 
 	case RXRPC_CALL_SERVER_RECV_REQUEST:


