Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB37655005
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 13:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236278AbiLWMDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 07:03:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236232AbiLWMB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 07:01:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECEAD389
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 04:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671796842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IBvIYEhqC61vkE5nifbl8b7iyDDJW0GAVBa85A8kwRA=;
        b=Yfbb239uqJVKsv4Bg8Ucuib+pkF4XCM+ZdnlhyioSRKPXxRYOdaIuzsqNS+QAvolb82l8V
        3B4MJWxBkODbr6wBWruZ7aFEv1dluWwYJc8dfNMtodkxcJeN0zudajSkMi3NB/2vg9QC9x
        6Aj3EqqSK6b7yJATKyNIljPUH3Z2bHg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-TWDXdZkKPeK0AUiXpW3twA-1; Fri, 23 Dec 2022 07:00:41 -0500
X-MC-Unique: TWDXdZkKPeK0AUiXpW3twA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CDEEF3C0F688;
        Fri, 23 Dec 2022 12:00:39 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 200E62166B33;
        Fri, 23 Dec 2022 12:00:39 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 06/19] rxrpc: Only disconnect calls in the I/O thread
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Fri, 23 Dec 2022 12:00:38 +0000
Message-ID: <167179683853.2516210.903291442538570624.stgit@warthog.procyon.org.uk>
In-Reply-To: <167179679960.2516210.10739247907156079872.stgit@warthog.procyon.org.uk>
References: <167179679960.2516210.10739247907156079872.stgit@warthog.procyon.org.uk>
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

Only perform call disconnection in the I/O thread to reduce the locking
requirement.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |    1 +
 net/rxrpc/call_event.c       |   14 +++++++++++++-
 net/rxrpc/call_object.c      |    9 +--------
 net/rxrpc/input.c            |    6 ------
 net/rxrpc/recvmsg.c          |    1 +
 5 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index c44cc01de750..eac513668e33 100644
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
index 8d3d2e058827..3db85d09c4b4 100644
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
@@ -531,13 +531,10 @@ void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
 	trace_rxrpc_call(call->debug_id, refcount_read(&call->ref),
 			 call->flags, rxrpc_call_see_release);
 
-	ASSERTCMP(call->state, ==, RXRPC_CALL_COMPLETE);
-
 	if (test_and_set_bit(RXRPC_CALL_RELEASED, &call->flags))
 		BUG();
 
 	rxrpc_put_call_slot(call);
-	del_timer_sync(&call->timer);
 
 	/* Make sure we don't get any more notifications */
 	write_lock(&rx->recvmsg_lock);
@@ -570,10 +567,6 @@ void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
 
 	_debug("RELEASE CALL %p (%d CONN %p)", call, call->debug_id, conn);
 
-	if (conn && !test_bit(RXRPC_CALL_DISCONNECTED, &call->flags))
-		rxrpc_disconnect_call(call);
-	if (call->security)
-		call->security->free_call_crypto(call);
 	_leave("");
 }
 
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 1f03a286620d..bb4beb445325 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -997,8 +997,6 @@ void rxrpc_input_call_packet(struct rxrpc_call *call, struct sk_buff *skb)
  */
 void rxrpc_implicit_end_call(struct rxrpc_call *call, struct sk_buff *skb)
 {
-	struct rxrpc_connection *conn = call->conn;
-
 	switch (READ_ONCE(call->state)) {
 	case RXRPC_CALL_SERVER_AWAIT_ACK:
 		rxrpc_call_completed(call);
@@ -1012,8 +1010,4 @@ void rxrpc_implicit_end_call(struct rxrpc_call *call, struct sk_buff *skb)
 	}
 
 	rxrpc_input_call_event(call, skb);
-
-	spin_lock(&conn->bundle->channel_lock);
-	__rxrpc_disconnect_call(conn, call);
-	spin_unlock(&conn->bundle->channel_lock);
 }
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index 3d6ba7e464b4..2b68ac990ed4 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -201,6 +201,7 @@ static void rxrpc_end_rx_phase(struct rxrpc_call *call, rxrpc_serial_t serial)
 	case RXRPC_CALL_CLIENT_RECV_REPLY:
 		__rxrpc_call_completed(call);
 		write_unlock(&call->state_lock);
+		rxrpc_poke_call(call, rxrpc_call_poke_complete);
 		break;
 
 	case RXRPC_CALL_SERVER_RECV_REQUEST:


