Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD6A7660D7B
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 10:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236905AbjAGJzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 04:55:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236867AbjAGJyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 04:54:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93E67DE32
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 01:53:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673085209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AhXHlWwEZWij1vsd0vJCKNS0dxIVf0WXf3zLTMT/EEc=;
        b=QPcLQX8KentoEsz8wd4lMcVVqQjD5+t+sOJGSsXrHbZS/Rce/KHqdkaa14oQrShNHb2eRc
        QUdBtkBePGg1Aj2TxfGBVA6k/axk+a67cw6r5v90oOu1hBsT+Il9+ErvDgJ/Zi739huOr+
        139p6z4Rscjtx00g/kmyGo26shqM0CM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-y9JLLmc6OhCvD10WhEb28Q-1; Sat, 07 Jan 2023 04:53:27 -0500
X-MC-Unique: y9JLLmc6OhCvD10WhEb28Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0936F101A521;
        Sat,  7 Jan 2023 09:53:27 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.87])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3AE6D40C1141;
        Sat,  7 Jan 2023 09:53:26 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 05/19] rxrpc: Only disconnect calls in the I/O thread
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     syzbot+c22650d2844392afdcfd@syzkaller.appspotmail.com,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Sat, 07 Jan 2023 09:53:25 +0000
Message-ID: <167308520548.1538866.8728900248500565529.stgit@warthog.procyon.org.uk>
In-Reply-To: <167308517118.1538866.3440481802366869065.stgit@warthog.procyon.org.uk>
References: <167308517118.1538866.3440481802366869065.stgit@warthog.procyon.org.uk>
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

Only perform call disconnection in the I/O thread to reduce the locking
requirement.

This is the first part of a fix for a race that exists between call
connection and call disconnection whereby the data transmission code adds
the call to the peer error distribution list after the call has been
disconnected (say by the rxrpc socket getting closed).

The fix is to complete the process of moving call connection, data
transmission and call disconnection into the I/O thread and thus forcibly
serialising them.

Note that the issue may predate the overhaul to an I/O thread model that
were included in the merge window for v6.2, but the timing is very much
changed by the change given below.

Fixes: cf37b5987508 ("rxrpc: Move DATA transmission into call processor work item")
Reported-by: syzbot+c22650d2844392afdcfd@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |    1 +
 net/rxrpc/call_event.c       |    7 ++++++-
 net/rxrpc/call_object.c      |    9 +--------
 net/rxrpc/input.c            |    6 ------
 net/rxrpc/recvmsg.c          |    1 +
 5 files changed, 9 insertions(+), 15 deletions(-)

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
index b7efecf5ccfc..b2fc3fa686ec 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -484,8 +484,13 @@ void rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb)
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
index 298b7c465d7e..13aac3ca03a0 100644
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
@@ -533,13 +533,10 @@ void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
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
@@ -572,10 +569,6 @@ void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
 
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
index a4ccdc006d0f..8d5fe65f5951 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -201,6 +201,7 @@ static void rxrpc_end_rx_phase(struct rxrpc_call *call, rxrpc_serial_t serial)
 	case RXRPC_CALL_CLIENT_RECV_REPLY:
 		__rxrpc_call_completed(call);
 		write_unlock(&call->state_lock);
+		rxrpc_poke_call(call, rxrpc_call_poke_complete);
 		break;
 
 	case RXRPC_CALL_SERVER_RECV_REQUEST:


