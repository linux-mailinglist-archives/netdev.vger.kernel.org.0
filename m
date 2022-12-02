Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0426263FCEC
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 01:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231945AbiLBAYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 19:24:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbiLBAXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 19:23:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46C1D4254
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 16:19:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669940365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L5K0/1KSpPMNNElCfjhINDPpkDoq54xRghHeiwJooY0=;
        b=X376ia1ebp2LKn19njbByDYOBsreZrynojRZ48QM3W2kzSVoCt7NITIx+W3Zu5ejFJPaB3
        IgMPuZDggH/HlskjyF5YGKv+Ms5SoD+xxl8OE83qs/PwGujGOsJjca39BVsEOKBQluvhvV
        1Ti3KtD92T0VCyVqxCqixr7ovwmJd+E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-335-8_lRfQkSOzyWu744-WoUSw-1; Thu, 01 Dec 2022 19:19:22 -0500
X-MC-Unique: 8_lRfQkSOzyWu744-WoUSw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 58841101A528;
        Fri,  2 Dec 2022 00:19:22 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 97F2E40C2065;
        Fri,  2 Dec 2022 00:19:21 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 30/36] rxrpc: Extract the peer address from an
 incoming packet earlier
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Fri, 02 Dec 2022 00:19:19 +0000
Message-ID: <166994035898.1732290.15533782027697967740.stgit@warthog.procyon.org.uk>
In-Reply-To: <166994010342.1732290.13771061038178613124.stgit@warthog.procyon.org.uk>
References: <166994010342.1732290.13771061038178613124.stgit@warthog.procyon.org.uk>
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

Extract the peer address from an incoming packet earlier, at the beginning
of rxrpc_input_packet() and thence pass a pointer to it to various
functions that use it as part of the lookup rather than doing it on several
separate paths.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/ar-internal.h |    2 ++
 net/rxrpc/call_accept.c |   10 ++++++----
 net/rxrpc/conn_object.c |   29 ++++++++---------------------
 net/rxrpc/io_thread.c   |   17 +++++++++++++++--
 4 files changed, 31 insertions(+), 27 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index cfd16f1e5c83..c3c915a05627 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -824,6 +824,7 @@ int rxrpc_service_prealloc(struct rxrpc_sock *, gfp_t);
 void rxrpc_discard_prealloc(struct rxrpc_sock *);
 struct rxrpc_call *rxrpc_new_incoming_call(struct rxrpc_local *,
 					   struct rxrpc_sock *,
+					   struct sockaddr_rxrpc *,
 					   struct sk_buff *);
 void rxrpc_accept_incoming_calls(struct rxrpc_local *);
 int rxrpc_user_charge_accept(struct rxrpc_sock *, unsigned long);
@@ -916,6 +917,7 @@ extern unsigned int rxrpc_closed_conn_expiry;
 
 struct rxrpc_connection *rxrpc_alloc_connection(struct rxrpc_net *, gfp_t);
 struct rxrpc_connection *rxrpc_find_connection_rcu(struct rxrpc_local *,
+						   struct sockaddr_rxrpc *,
 						   struct sk_buff *,
 						   struct rxrpc_peer **);
 void __rxrpc_disconnect_call(struct rxrpc_connection *, struct rxrpc_call *);
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index beb8efa2e7a9..11134b7cec17 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -258,6 +258,7 @@ static struct rxrpc_call *rxrpc_alloc_incoming_call(struct rxrpc_sock *rx,
 						    struct rxrpc_peer *peer,
 						    struct rxrpc_connection *conn,
 						    const struct rxrpc_security *sec,
+						    struct sockaddr_rxrpc *peer_srx,
 						    struct sk_buff *skb)
 {
 	struct rxrpc_backlog *b = rx->backlog;
@@ -287,8 +288,7 @@ static struct rxrpc_call *rxrpc_alloc_incoming_call(struct rxrpc_sock *rx,
 			peer = NULL;
 		if (!peer) {
 			peer = b->peer_backlog[peer_tail];
-			if (rxrpc_extract_addr_from_skb(&peer->srx, skb) < 0)
-				return NULL;
+			peer->srx = *peer_srx;
 			b->peer_backlog[peer_tail] = NULL;
 			smp_store_release(&b->peer_backlog_tail,
 					  (peer_tail + 1) &
@@ -346,6 +346,7 @@ static struct rxrpc_call *rxrpc_alloc_incoming_call(struct rxrpc_sock *rx,
  */
 struct rxrpc_call *rxrpc_new_incoming_call(struct rxrpc_local *local,
 					   struct rxrpc_sock *rx,
+					   struct sockaddr_rxrpc *peer_srx,
 					   struct sk_buff *skb)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
@@ -371,7 +372,7 @@ struct rxrpc_call *rxrpc_new_incoming_call(struct rxrpc_local *local,
 	 * we have to recheck the routing.  However, we're now holding
 	 * rx->incoming_lock, so the values should remain stable.
 	 */
-	conn = rxrpc_find_connection_rcu(local, skb, &peer);
+	conn = rxrpc_find_connection_rcu(local, peer_srx, skb, &peer);
 
 	if (!conn) {
 		sec = rxrpc_get_incoming_security(rx, skb);
@@ -379,7 +380,8 @@ struct rxrpc_call *rxrpc_new_incoming_call(struct rxrpc_local *local,
 			goto no_call;
 	}
 
-	call = rxrpc_alloc_incoming_call(rx, local, peer, conn, sec, skb);
+	call = rxrpc_alloc_incoming_call(rx, local, peer, conn, sec, peer_srx,
+					 skb);
 	if (!call) {
 		skb->mark = RXRPC_SKB_MARK_REJECT_BUSY;
 		goto no_call;
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index 5a39255ea014..98e49646ca1d 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -73,29 +73,17 @@ struct rxrpc_connection *rxrpc_alloc_connection(struct rxrpc_net *rxnet,
  * The caller must be holding the RCU read lock.
  */
 struct rxrpc_connection *rxrpc_find_connection_rcu(struct rxrpc_local *local,
+						   struct sockaddr_rxrpc *srx,
 						   struct sk_buff *skb,
 						   struct rxrpc_peer **_peer)
 {
 	struct rxrpc_connection *conn;
 	struct rxrpc_conn_proto k;
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
-	struct sockaddr_rxrpc srx;
 	struct rxrpc_peer *peer;
 
 	_enter(",%x", sp->hdr.cid & RXRPC_CIDMASK);
 
-	if (rxrpc_extract_addr_from_skb(&srx, skb) < 0)
-		goto not_found;
-
-	if (srx.transport.family != local->srx.transport.family &&
-	    (srx.transport.family == AF_INET &&
-	     local->srx.transport.family != AF_INET6)) {
-		pr_warn_ratelimited("AF_RXRPC: Protocol mismatch %u not %u\n",
-				    srx.transport.family,
-				    local->srx.transport.family);
-		goto not_found;
-	}
-
 	k.epoch	= sp->hdr.epoch;
 	k.cid	= sp->hdr.cid & RXRPC_CIDMASK;
 
@@ -104,7 +92,7 @@ struct rxrpc_connection *rxrpc_find_connection_rcu(struct rxrpc_local *local,
 		 * parameter set.  We look up the peer first as an intermediate
 		 * step and then the connection from the peer's tree.
 		 */
-		peer = rxrpc_lookup_peer_rcu(local, &srx);
+		peer = rxrpc_lookup_peer_rcu(local, srx);
 		if (!peer)
 			goto not_found;
 		*_peer = peer;
@@ -117,8 +105,7 @@ struct rxrpc_connection *rxrpc_find_connection_rcu(struct rxrpc_local *local,
 		/* Look up client connections by connection ID alone as their
 		 * IDs are unique for this machine.
 		 */
-		conn = idr_find(&rxrpc_client_conn_ids,
-				sp->hdr.cid >> RXRPC_CIDSHIFT);
+		conn = idr_find(&rxrpc_client_conn_ids, sp->hdr.cid >> RXRPC_CIDSHIFT);
 		if (!conn || refcount_read(&conn->ref) == 0) {
 			_debug("no conn");
 			goto not_found;
@@ -129,20 +116,20 @@ struct rxrpc_connection *rxrpc_find_connection_rcu(struct rxrpc_local *local,
 			goto not_found;
 
 		peer = conn->peer;
-		switch (srx.transport.family) {
+		switch (srx->transport.family) {
 		case AF_INET:
 			if (peer->srx.transport.sin.sin_port !=
-			    srx.transport.sin.sin_port ||
+			    srx->transport.sin.sin_port ||
 			    peer->srx.transport.sin.sin_addr.s_addr !=
-			    srx.transport.sin.sin_addr.s_addr)
+			    srx->transport.sin.sin_addr.s_addr)
 				goto not_found;
 			break;
 #ifdef CONFIG_AF_RXRPC_IPV6
 		case AF_INET6:
 			if (peer->srx.transport.sin6.sin6_port !=
-			    srx.transport.sin6.sin6_port ||
+			    srx->transport.sin6.sin6_port ||
 			    memcmp(&peer->srx.transport.sin6.sin6_addr,
-				   &srx.transport.sin6.sin6_addr,
+				   &srx->transport.sin6.sin6_addr,
 				   sizeof(struct in6_addr)) != 0)
 				goto not_found;
 			break;
diff --git a/net/rxrpc/io_thread.c b/net/rxrpc/io_thread.c
index 3b6927610677..bc65d83fab88 100644
--- a/net/rxrpc/io_thread.c
+++ b/net/rxrpc/io_thread.c
@@ -155,6 +155,7 @@ static bool rxrpc_extract_abort(struct sk_buff *skb)
 static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff **_skb)
 {
 	struct rxrpc_connection *conn;
+	struct sockaddr_rxrpc peer_srx;
 	struct rxrpc_channel *chan;
 	struct rxrpc_call *call = NULL;
 	struct rxrpc_skb_priv *sp;
@@ -257,6 +258,18 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff **_skb)
 	if (sp->hdr.serviceId == 0)
 		goto bad_message;
 
+	if (WARN_ON_ONCE(rxrpc_extract_addr_from_skb(&peer_srx, skb) < 0))
+		return 0; /* Unsupported address type - discard. */
+
+	if (peer_srx.transport.family != local->srx.transport.family &&
+	    (peer_srx.transport.family == AF_INET &&
+	     local->srx.transport.family != AF_INET6)) {
+		pr_warn_ratelimited("AF_RXRPC: Protocol mismatch %u not %u\n",
+				    peer_srx.transport.family,
+				    local->srx.transport.family);
+		return 0; /* Wrong address type - discard. */
+	}
+
 	rcu_read_lock();
 
 	if (rxrpc_to_server(sp)) {
@@ -276,7 +289,7 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff **_skb)
 		}
 	}
 
-	conn = rxrpc_find_connection_rcu(local, skb, &peer);
+	conn = rxrpc_find_connection_rcu(local, &peer_srx, skb, &peer);
 	if (conn) {
 		if (sp->hdr.securityIndex != conn->security_ix)
 			goto wrong_security;
@@ -389,7 +402,7 @@ static int rxrpc_input_packet(struct rxrpc_local *local, struct sk_buff **_skb)
 			rcu_read_unlock();
 			return 0;
 		}
-		call = rxrpc_new_incoming_call(local, rx, skb);
+		call = rxrpc_new_incoming_call(local, rx, &peer_srx, skb);
 		if (!call) {
 			rcu_read_unlock();
 			goto reject_packet;


