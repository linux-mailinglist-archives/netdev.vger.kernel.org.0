Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75C9063DB5F
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 18:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiK3RCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 12:02:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbiK3RCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 12:02:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39478837D0
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 08:58:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669827506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0ItRdbm0UyoTawpAty3EqeXI5my06iwbuvMc90NvWqA=;
        b=fQng/hYHHwgAoPZlbn3fy69dnP76tVmnh8meb+up/sySr5+uhwmMjbbyulIuJdB0mzZuO8
        nt8NqFSTQI6YRoQ7RaF5+lYU1a4tEtJN5aqMEn83x/DWhWnb3QZA7W9Lb+5rrhOL33ll4C
        mD0cYYiaaIpGX++pciKnF94KKKMBUBU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-256-cnrEHAC4MuGSTptiFkx5vA-1; Wed, 30 Nov 2022 11:58:24 -0500
X-MC-Unique: cnrEHAC4MuGSTptiFkx5vA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C91732932480;
        Wed, 30 Nov 2022 16:58:23 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 159531415119;
        Wed, 30 Nov 2022 16:58:22 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 28/35] rxrpc: Reduce the use of RCU in packet input
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 30 Nov 2022 16:58:20 +0000
Message-ID: <166982750031.621383.17246231076247717914.stgit@warthog.procyon.org.uk>
In-Reply-To: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
References: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Shrink the region of rxrpc_input_packet() that is covered by the RCU read
lock so that it only covers the connection and call lookup.  This means
that the bits now outside of that can call sleepable functions such as
kmalloc and sendmsg.

Also take a ref on the conn or call we're going to use before we drop the
RCU read lock.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/ar-internal.h |    3 +-
 net/rxrpc/call_accept.c |   13 ++-------
 net/rxrpc/input.c       |    7 ++---
 net/rxrpc/io_thread.c   |   68 ++++++++++++++++++++++++++++++++++++-----------
 4 files changed, 59 insertions(+), 32 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 6af7298af39b..cfd16f1e5c83 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -961,8 +961,7 @@ void rxrpc_unpublish_service_conn(struct rxrpc_connection *);
  * input.c
  */
 void rxrpc_input_call_event(struct rxrpc_call *, struct sk_buff *);
-void rxrpc_input_implicit_end_call(struct rxrpc_sock *, struct rxrpc_connection *,
-				   struct rxrpc_call *);
+void rxrpc_input_implicit_end_call(struct rxrpc_connection *, struct rxrpc_call *);
 
 /*
  * io_thread.c
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index 5f978b0b2404..beb8efa2e7a9 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -336,13 +336,13 @@ static struct rxrpc_call *rxrpc_alloc_incoming_call(struct rxrpc_sock *rx,
  * If this is for a kernel service, when we allocate the call, it will have
  * three refs on it: (1) the kernel service, (2) the user_call_ID tree, (3) the
  * retainer ref obtained from the backlog buffer.  Prealloc calls for userspace
- * services only have the ref from the backlog buffer.  We want to pass this
- * ref to non-BH context to dispose of.
+ * services only have the ref from the backlog buffer.  We pass this ref to the
+ * caller.
  *
  * If we want to report an error, we mark the skb with the packet type and
  * abort code and return NULL.
  *
- * The call is returned with the user access mutex held.
+ * The call is returned with the user access mutex held and a ref on it.
  */
 struct rxrpc_call *rxrpc_new_incoming_call(struct rxrpc_local *local,
 					   struct rxrpc_sock *rx,
@@ -426,13 +426,6 @@ struct rxrpc_call *rxrpc_new_incoming_call(struct rxrpc_local *local,
 
 	rxrpc_send_ping(call, skb);
 
-	/* We have to discard the prealloc queue's ref here and rely on a
-	 * combination of the RCU read lock and refs held either by the socket
-	 * (recvmsg queue, to-be-accepted queue or user ID tree) or the kernel
-	 * service to prevent the call from being deallocated too early.
-	 */
-	rxrpc_put_call(call, rxrpc_call_put_discard_prealloc);
-
 	if (hlist_unhashed(&call->error_link)) {
 		spin_lock(&call->peer->lock);
 		hlist_add_head(&call->error_link, &call->peer->error_targets);
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 42addbcf59f9..01d32f817a7a 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -1072,8 +1072,7 @@ void rxrpc_input_call_event(struct rxrpc_call *call, struct sk_buff *skb)
  *
  * TODO: If callNumber > call_id + 1, renegotiate security.
  */
-void rxrpc_input_implicit_end_call(struct rxrpc_sock *rx,
-				   struct rxrpc_connection *conn,
+void rxrpc_input_implicit_end_call(struct rxrpc_connection *conn,
 				   struct rxrpc_call *call)
 {
 	switch (READ_ONCE(call->state)) {
@@ -1091,7 +1090,7 @@ void rxrpc_input_implicit_end_call(struct rxrpc_sock *rx,
 		break;
 	}
 
-	spin_lock(&rx->incoming_lock);
+	spin_lock(&conn->bundle->channel_lock);
 	__rxrpc_disconnect_call(conn, call);
-	spin_unlock(&rx->incoming_lock);
+	spin_unlock(&conn->bundle->channel_lock);
 }
diff --git a/net/rxrpc/io_thread.c b/net/rxrpc/io_thread.c
index 91b8ba5b90db..3b6927610677 100644
--- a/net/rxrpc/io_thread.c
+++ b/net/rxrpc/io_thread.c
@@ -257,6 +257,8 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff **_skb)
 	if (sp->hdr.serviceId == 0)
 		goto bad_message;
 
+	rcu_read_lock();
+
 	if (rxrpc_to_server(sp)) {
 		/* Weed out packets to services we're not offering.  Packets
 		 * that would begin a call are explicitly rejected and the rest
@@ -264,7 +266,9 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff **_skb)
 		 */
 		rx = rcu_dereference(local->service);
 		if (!rx || (sp->hdr.serviceId != rx->srx.srx_service &&
-			    sp->hdr.serviceId != rx->second_service)) {
+			    sp->hdr.serviceId != rx->second_service)
+		    ) {
+			rcu_read_unlock();
 			if (sp->hdr.type == RXRPC_PACKET_TYPE_DATA &&
 			    sp->hdr.seq == 1)
 				goto unsupported_service;
@@ -293,7 +297,12 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff **_skb)
 		if (sp->hdr.callNumber == 0) {
 			/* Connection-level packet */
 			_debug("CONN %p {%d}", conn, conn->debug_id);
-			rxrpc_post_packet_to_conn(conn, skb);
+			conn = rxrpc_get_connection_maybe(conn, rxrpc_conn_get_conn_input);
+			rcu_read_unlock();
+			if (conn) {
+				rxrpc_post_packet_to_conn(conn, skb);
+				rxrpc_put_connection(conn, rxrpc_conn_put_conn_input);
+			}
 			return 0;
 		}
 
@@ -305,20 +314,26 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff **_skb)
 		chan = &conn->channels[channel];
 
 		/* Ignore really old calls */
-		if (sp->hdr.callNumber < chan->last_call)
+		if (sp->hdr.callNumber < chan->last_call) {
+			rcu_read_unlock();
 			return 0;
+		}
 
 		if (sp->hdr.callNumber == chan->last_call) {
 			if (chan->call ||
-			    sp->hdr.type == RXRPC_PACKET_TYPE_ABORT)
+			    sp->hdr.type == RXRPC_PACKET_TYPE_ABORT) {
+				rcu_read_unlock();
 				return 0;
+			}
 
 			/* For the previous service call, if completed
 			 * successfully, we discard all further packets.
 			 */
 			if (rxrpc_conn_is_service(conn) &&
-			    chan->last_type == RXRPC_PACKET_TYPE_ACK)
+			    chan->last_type == RXRPC_PACKET_TYPE_ACK) {
+				rcu_read_unlock();
 				return 0;
+			}
 
 			/* But otherwise we need to retransmit the final packet
 			 * from data cached in the connection record.
@@ -328,20 +343,32 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff **_skb)
 						    sp->hdr.seq,
 						    sp->hdr.serial,
 						    sp->hdr.flags);
-			rxrpc_post_packet_to_conn(conn, skb);
+			conn = rxrpc_get_connection_maybe(conn, rxrpc_conn_get_call_input);
+			rcu_read_unlock();
+			if (conn) {
+				rxrpc_post_packet_to_conn(conn, skb);
+				rxrpc_put_connection(conn, rxrpc_conn_put_call_input);
+			}
 			return 0;
 		}
 
 		call = rcu_dereference(chan->call);
 
 		if (sp->hdr.callNumber > chan->call_id) {
-			if (rxrpc_to_client(sp))
+			if (rxrpc_to_client(sp)) {
+				rcu_read_unlock();
 				goto reject_packet;
-			if (call)
-				rxrpc_input_implicit_end_call(rx, conn, call);
-			call = NULL;
+			}
+			if (call) {
+				rxrpc_input_implicit_end_call(conn, call);
+				chan->call = NULL;
+				call = NULL;
+			}
 		}
 
+		if (call && !rxrpc_try_get_call(call, rxrpc_call_get_input))
+			call = NULL;
+
 		if (call) {
 			if (sp->hdr.serviceId != call->dest_srx.srx_service)
 				call->dest_srx.srx_service = sp->hdr.serviceId;
@@ -352,23 +379,33 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff **_skb)
 		}
 	}
 
-	if (!call || refcount_read(&call->ref) == 0) {
+	if (!call) {
 		if (rxrpc_to_client(sp) ||
-		    sp->hdr.type != RXRPC_PACKET_TYPE_DATA)
+		    sp->hdr.type != RXRPC_PACKET_TYPE_DATA) {
+			rcu_read_unlock();
 			goto bad_message;
-		if (sp->hdr.seq != 1)
+		}
+		if (sp->hdr.seq != 1) {
+			rcu_read_unlock();
 			return 0;
+		}
 		call = rxrpc_new_incoming_call(local, rx, skb);
-		if (!call)
+		if (!call) {
+			rcu_read_unlock();
 			goto reject_packet;
+		}
 	}
 
+	rcu_read_unlock();
+
 	/* Process a call packet. */
 	rxrpc_input_call_event(call, skb);
+	rxrpc_put_call(call, rxrpc_call_put_input);
 	trace_rxrpc_rx_done(0, 0);
 	return 0;
 
 wrong_security:
+	rcu_read_unlock();
 	trace_rxrpc_abort(0, "SEC", sp->hdr.cid, sp->hdr.callNumber, sp->hdr.seq,
 			  RXKADINCONSISTENCY, EBADMSG);
 	skb->priority = RXKADINCONSISTENCY;
@@ -381,6 +418,7 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff **_skb)
 	goto post_abort;
 
 reupgrade:
+	rcu_read_unlock();
 	trace_rxrpc_abort(0, "UPG", sp->hdr.cid, sp->hdr.callNumber, sp->hdr.seq,
 			  RX_PROTOCOL_ERROR, EBADMSG);
 	goto protocol_error;
@@ -433,9 +471,7 @@ int rxrpc_io_thread(void *data)
 			switch (skb->mark) {
 			case RXRPC_SKB_MARK_PACKET:
 				skb->priority = 0;
-				rcu_read_lock();
 				rxrpc_input_packet(local, &skb);
-				rcu_read_unlock();
 				trace_rxrpc_rx_done(skb->mark, skb->priority);
 				rxrpc_free_skb(skb, rxrpc_skb_put_input);
 				break;


