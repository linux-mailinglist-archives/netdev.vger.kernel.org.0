Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 132E0150447
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 11:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbgBCKbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 05:31:23 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:49327 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727977AbgBCKbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 05:31:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580725879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rvNHYAZjYjkV+vkG1tbRc3CJ+s9eRjtdr7RfxMNvBmY=;
        b=U387uJbxca4rFYPNwFxaIZDKN0XyDU9uMYQDMyaVNjr7JgKKqTV4qNkZm3dX4jxN6av7Tw
        VXSFW0jad0S1RL/d1/I/4JClMFIz+1+KM9vNc0Lb5ZhRLMjuferPDbV1No5f/i4ApokucV
        4ty5MQ38ZZOUoHLg8zHirH/P0Rd6r5s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-1DKBdyuQNHeNiM9ef7qq0A-1; Mon, 03 Feb 2020 05:31:15 -0500
X-MC-Unique: 1DKBdyuQNHeNiM9ef7qq0A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 021AB13E5;
        Mon,  3 Feb 2020 10:31:14 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-218.rdu2.redhat.com [10.10.120.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F3A95DA82;
        Mon,  3 Feb 2020 10:31:12 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 4/4] rxrpc: Fix NULL pointer deref due to call->conn being
 cleared on disconnect ver #2
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 03 Feb 2020 10:31:12 +0000
Message-ID: <158072587233.743488.3352010285108950185.stgit@warthog.procyon.org.uk>
In-Reply-To: <158072584492.743488.4616022353630142921.stgit@warthog.procyon.org.uk>
References: <158072584492.743488.4616022353630142921.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a call is disconnected, the connection pointer from the call is
cleared to make sure it isn't used again and to prevent further attempted
transmission for the call.  Unfortunately, there might be a daemon trying
to use it at the same time to transmit a packet.

Fix this by keeping call->conn set, but setting a flag on the call to
indicate disconnection instead.

Remove also the bits in the transmission functions where the conn pointer is
checked and a ref taken under spinlock as this is now redundant.

Fixes: 8d94aa381dab ("rxrpc: Calls shouldn't hold socket refs")
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/ar-internal.h |    1 +
 net/rxrpc/call_object.c |    4 ++--
 net/rxrpc/conn_client.c |    3 +--
 net/rxrpc/conn_object.c |    4 ++--
 net/rxrpc/output.c      |   27 +++++++++------------------
 5 files changed, 15 insertions(+), 24 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 94441fee85bc..7d730c438404 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -490,6 +490,7 @@ enum rxrpc_call_flag {
 	RXRPC_CALL_RX_HEARD,		/* The peer responded at least once to this call */
 	RXRPC_CALL_RX_UNDERRUN,		/* Got data underrun */
 	RXRPC_CALL_IS_INTR,		/* The call is interruptible */
+	RXRPC_CALL_DISCONNECTED,	/* The call has been disconnected */
 };
 
 /*
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index a31c18c09894..dbdbc4f18b5e 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -493,7 +493,7 @@ void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
 
 	_debug("RELEASE CALL %p (%d CONN %p)", call, call->debug_id, conn);
 
-	if (conn)
+	if (conn && !test_bit(RXRPC_CALL_DISCONNECTED, &call->flags))
 		rxrpc_disconnect_call(call);
 	if (call->security)
 		call->security->free_call_crypto(call);
@@ -569,6 +569,7 @@ static void rxrpc_rcu_destroy_call(struct rcu_head *rcu)
 	struct rxrpc_call *call = container_of(rcu, struct rxrpc_call, rcu);
 	struct rxrpc_net *rxnet = call->rxnet;
 
+	rxrpc_put_connection(call->conn);
 	rxrpc_put_peer(call->peer);
 	kfree(call->rxtx_buffer);
 	kfree(call->rxtx_annotations);
@@ -590,7 +591,6 @@ void rxrpc_cleanup_call(struct rxrpc_call *call)
 
 	ASSERTCMP(call->state, ==, RXRPC_CALL_COMPLETE);
 	ASSERT(test_bit(RXRPC_CALL_RELEASED, &call->flags));
-	ASSERTCMP(call->conn, ==, NULL);
 
 	rxrpc_cleanup_ring(call);
 	rxrpc_free_skb(call->tx_pending, rxrpc_skb_cleaned);
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index 376370cd9285..ea7d4c21f889 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -785,6 +785,7 @@ void rxrpc_disconnect_client_call(struct rxrpc_call *call)
 	u32 cid;
 
 	spin_lock(&conn->channel_lock);
+	set_bit(RXRPC_CALL_DISCONNECTED, &call->flags);
 
 	cid = call->cid;
 	if (cid) {
@@ -792,7 +793,6 @@ void rxrpc_disconnect_client_call(struct rxrpc_call *call)
 		chan = &conn->channels[channel];
 	}
 	trace_rxrpc_client(conn, channel, rxrpc_client_chan_disconnect);
-	call->conn = NULL;
 
 	/* Calls that have never actually been assigned a channel can simply be
 	 * discarded.  If the conn didn't get used either, it will follow
@@ -908,7 +908,6 @@ void rxrpc_disconnect_client_call(struct rxrpc_call *call)
 	spin_unlock(&rxnet->client_conn_cache_lock);
 out_2:
 	spin_unlock(&conn->channel_lock);
-	rxrpc_put_connection(conn);
 	_leave("");
 	return;
 
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index 38d718e90dc6..c0b3154f7a7e 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -171,6 +171,8 @@ void __rxrpc_disconnect_call(struct rxrpc_connection *conn,
 
 	_enter("%d,%x", conn->debug_id, call->cid);
 
+	set_bit(RXRPC_CALL_DISCONNECTED, &call->flags);
+
 	if (rcu_access_pointer(chan->call) == call) {
 		/* Save the result of the call so that we can repeat it if necessary
 		 * through the channel, whilst disposing of the actual call record.
@@ -223,9 +225,7 @@ void rxrpc_disconnect_call(struct rxrpc_call *call)
 	__rxrpc_disconnect_call(conn, call);
 	spin_unlock(&conn->channel_lock);
 
-	call->conn = NULL;
 	conn->idle_timestamp = jiffies;
-	rxrpc_put_connection(conn);
 }
 
 /*
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 935bb60fff56..bad3d2420344 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -129,7 +129,7 @@ static size_t rxrpc_fill_out_ack(struct rxrpc_connection *conn,
 int rxrpc_send_ack_packet(struct rxrpc_call *call, bool ping,
 			  rxrpc_serial_t *_serial)
 {
-	struct rxrpc_connection *conn = NULL;
+	struct rxrpc_connection *conn;
 	struct rxrpc_ack_buffer *pkt;
 	struct msghdr msg;
 	struct kvec iov[2];
@@ -139,18 +139,14 @@ int rxrpc_send_ack_packet(struct rxrpc_call *call, bool ping,
 	int ret;
 	u8 reason;
 
-	spin_lock_bh(&call->lock);
-	if (call->conn)
-		conn = rxrpc_get_connection_maybe(call->conn);
-	spin_unlock_bh(&call->lock);
-	if (!conn)
+	if (test_bit(RXRPC_CALL_DISCONNECTED, &call->flags))
 		return -ECONNRESET;
 
 	pkt = kzalloc(sizeof(*pkt), GFP_KERNEL);
-	if (!pkt) {
-		rxrpc_put_connection(conn);
+	if (!pkt)
 		return -ENOMEM;
-	}
+
+	conn = call->conn;
 
 	msg.msg_name	= &call->peer->srx.transport;
 	msg.msg_namelen	= call->peer->srx.transport_len;
@@ -244,7 +240,6 @@ int rxrpc_send_ack_packet(struct rxrpc_call *call, bool ping,
 	}
 
 out:
-	rxrpc_put_connection(conn);
 	kfree(pkt);
 	return ret;
 }
@@ -254,7 +249,7 @@ int rxrpc_send_ack_packet(struct rxrpc_call *call, bool ping,
  */
 int rxrpc_send_abort_packet(struct rxrpc_call *call)
 {
-	struct rxrpc_connection *conn = NULL;
+	struct rxrpc_connection *conn;
 	struct rxrpc_abort_buffer pkt;
 	struct msghdr msg;
 	struct kvec iov[1];
@@ -271,13 +266,11 @@ int rxrpc_send_abort_packet(struct rxrpc_call *call)
 	    test_bit(RXRPC_CALL_TX_LAST, &call->flags))
 		return 0;
 
-	spin_lock_bh(&call->lock);
-	if (call->conn)
-		conn = rxrpc_get_connection_maybe(call->conn);
-	spin_unlock_bh(&call->lock);
-	if (!conn)
+	if (test_bit(RXRPC_CALL_DISCONNECTED, &call->flags))
 		return -ECONNRESET;
 
+	conn = call->conn;
+
 	msg.msg_name	= &call->peer->srx.transport;
 	msg.msg_namelen	= call->peer->srx.transport_len;
 	msg.msg_control	= NULL;
@@ -312,8 +305,6 @@ int rxrpc_send_abort_packet(struct rxrpc_call *call)
 		trace_rxrpc_tx_packet(call->debug_id, &pkt.whdr,
 				      rxrpc_tx_point_call_abort);
 	rxrpc_tx_backoff(call, ret);
-
-	rxrpc_put_connection(conn);
 	return ret;
 }
 


