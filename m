Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E95066448A6
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbiLFQEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:04:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235341AbiLFQCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:02:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2822ED6A
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 08:01:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670342476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WW1ee118uoQ3cBoNOc38dhC0xhsUT8De7VLuxxcefi8=;
        b=TA07fwhoLU6H+pxVqlR/rxGUwsVzm5L8lTzTFfQpsDYC0mhO0BOMqbuirsw5MUP6RDjnos
        pPZrU80lyMvxDBUwoL3JZeBOXGMqibMoST/ZHhV0AmJv3WsAgzSXE2UNbEI93RSfG9XG5q
        /KpJnmrFEdkzoHLubbeDbXYawaISoIU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-4qjHR9I1MR2s_CtpT8wJvQ-1; Tue, 06 Dec 2022 11:01:13 -0500
X-MC-Unique: 4qjHR9I1MR2s_CtpT8wJvQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7FCC186EB21;
        Tue,  6 Dec 2022 16:01:12 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C1777C15BA4;
        Tue,  6 Dec 2022 16:01:11 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 18/32] rxrpc: Stash the network namespace pointer in
 rxrpc_local
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Tue, 06 Dec 2022 16:01:09 +0000
Message-ID: <167034246900.1105287.913631596294374964.stgit@warthog.procyon.org.uk>
In-Reply-To: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
References: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stash the network namespace pointer in the rxrpc_local struct in addition
to a pointer to the rxrpc-specific net namespace info.  Use this to remove
some places where the socket is passed as a parameter.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/ar-internal.h  |    8 ++++----
 net/rxrpc/call_accept.c  |    2 +-
 net/rxrpc/conn_client.c  |    2 +-
 net/rxrpc/local_object.c |    7 ++++---
 net/rxrpc/peer_object.c  |   23 ++++++++++-------------
 5 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index f2ab2d8044bd..1e6e11fb3a90 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -282,7 +282,8 @@ struct rxrpc_local {
 	struct rcu_head		rcu;
 	atomic_t		active_users;	/* Number of users of the local endpoint */
 	refcount_t		ref;		/* Number of references to the structure */
-	struct rxrpc_net	*rxnet;		/* The network ns in which this resides */
+	struct net		*net;		/* The network namespace */
+	struct rxrpc_net	*rxnet;		/* Our bits in the network namespace */
 	struct hlist_node	link;
 	struct socket		*socket;	/* my UDP socket */
 	struct task_struct	*io_thread;
@@ -1088,12 +1089,11 @@ void rxrpc_peer_keepalive_worker(struct work_struct *);
  */
 struct rxrpc_peer *rxrpc_lookup_peer_rcu(struct rxrpc_local *,
 					 const struct sockaddr_rxrpc *);
-struct rxrpc_peer *rxrpc_lookup_peer(struct rxrpc_sock *, struct rxrpc_local *,
+struct rxrpc_peer *rxrpc_lookup_peer(struct rxrpc_local *,
 				     struct sockaddr_rxrpc *, gfp_t);
 struct rxrpc_peer *rxrpc_alloc_peer(struct rxrpc_local *, gfp_t,
 				    enum rxrpc_peer_trace);
-void rxrpc_new_incoming_peer(struct rxrpc_sock *, struct rxrpc_local *,
-			     struct rxrpc_peer *);
+void rxrpc_new_incoming_peer(struct rxrpc_local *, struct rxrpc_peer *);
 void rxrpc_destroy_all_peers(struct rxrpc_net *);
 struct rxrpc_peer *rxrpc_get_peer(struct rxrpc_peer *, enum rxrpc_peer_trace);
 struct rxrpc_peer *rxrpc_get_peer_maybe(struct rxrpc_peer *, enum rxrpc_peer_trace);
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index 5fa81bb4abfa..a132d486dea0 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -280,7 +280,7 @@ static struct rxrpc_call *rxrpc_alloc_incoming_call(struct rxrpc_sock *rx,
 					  (peer_tail + 1) &
 					  (RXRPC_BACKLOG_MAX - 1));
 
-			rxrpc_new_incoming_peer(rx, local, peer);
+			rxrpc_new_incoming_peer(local, peer);
 		}
 
 		/* Now allocate and set up the connection */
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index ec8913de42c9..4cfd8845df90 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -378,7 +378,7 @@ static struct rxrpc_bundle *rxrpc_prep_call(struct rxrpc_sock *rx,
 
 	_enter("{%d,%lx},", call->debug_id, call->user_call_ID);
 
-	cp->peer = rxrpc_lookup_peer(rx, cp->local, srx, gfp);
+	cp->peer = rxrpc_lookup_peer(cp->local, srx, gfp);
 	if (!cp->peer)
 		goto error;
 
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 3ab68ae68954..3843418ea90f 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -85,7 +85,7 @@ static long rxrpc_local_cmp_key(const struct rxrpc_local *local,
 /*
  * Allocate a new local endpoint.
  */
-static struct rxrpc_local *rxrpc_alloc_local(struct rxrpc_net *rxnet,
+static struct rxrpc_local *rxrpc_alloc_local(struct net *net,
 					     const struct sockaddr_rxrpc *srx)
 {
 	struct rxrpc_local *local;
@@ -94,7 +94,8 @@ static struct rxrpc_local *rxrpc_alloc_local(struct rxrpc_net *rxnet,
 	if (local) {
 		refcount_set(&local->ref, 1);
 		atomic_set(&local->active_users, 1);
-		local->rxnet = rxnet;
+		local->net = net;
+		local->rxnet = rxrpc_net(net);
 		INIT_HLIST_NODE(&local->link);
 #ifdef CONFIG_AF_RXRPC_INJECT_RX_DELAY
 		skb_queue_head_init(&local->rx_delay_queue);
@@ -249,7 +250,7 @@ struct rxrpc_local *rxrpc_lookup_local(struct net *net,
 		goto found;
 	}
 
-	local = rxrpc_alloc_local(rxnet, srx);
+	local = rxrpc_alloc_local(net, srx);
 	if (!local)
 		goto nomem;
 
diff --git a/net/rxrpc/peer_object.c b/net/rxrpc/peer_object.c
index 608946dcc505..c3035f44e0ca 100644
--- a/net/rxrpc/peer_object.c
+++ b/net/rxrpc/peer_object.c
@@ -147,10 +147,10 @@ struct rxrpc_peer *rxrpc_lookup_peer_rcu(struct rxrpc_local *local,
  * assess the MTU size for the network interface through which this peer is
  * reached
  */
-static void rxrpc_assess_MTU_size(struct rxrpc_sock *rx,
+static void rxrpc_assess_MTU_size(struct rxrpc_local *local,
 				  struct rxrpc_peer *peer)
 {
-	struct net *net = sock_net(&rx->sk);
+	struct net *net = local->net;
 	struct dst_entry *dst;
 	struct rtable *rt;
 	struct flowi fl;
@@ -236,11 +236,11 @@ struct rxrpc_peer *rxrpc_alloc_peer(struct rxrpc_local *local, gfp_t gfp,
 /*
  * Initialise peer record.
  */
-static void rxrpc_init_peer(struct rxrpc_sock *rx, struct rxrpc_peer *peer,
+static void rxrpc_init_peer(struct rxrpc_local *local, struct rxrpc_peer *peer,
 			    unsigned long hash_key)
 {
 	peer->hash_key = hash_key;
-	rxrpc_assess_MTU_size(rx, peer);
+	rxrpc_assess_MTU_size(local, peer);
 	peer->mtu = peer->if_mtu;
 	peer->rtt_last_req = ktime_get_real();
 
@@ -272,8 +272,7 @@ static void rxrpc_init_peer(struct rxrpc_sock *rx, struct rxrpc_peer *peer,
 /*
  * Set up a new peer.
  */
-static struct rxrpc_peer *rxrpc_create_peer(struct rxrpc_sock *rx,
-					    struct rxrpc_local *local,
+static struct rxrpc_peer *rxrpc_create_peer(struct rxrpc_local *local,
 					    struct sockaddr_rxrpc *srx,
 					    unsigned long hash_key,
 					    gfp_t gfp)
@@ -285,7 +284,7 @@ static struct rxrpc_peer *rxrpc_create_peer(struct rxrpc_sock *rx,
 	peer = rxrpc_alloc_peer(local, gfp, rxrpc_peer_new_client);
 	if (peer) {
 		memcpy(&peer->srx, srx, sizeof(*srx));
-		rxrpc_init_peer(rx, peer, hash_key);
+		rxrpc_init_peer(local, peer, hash_key);
 	}
 
 	_leave(" = %p", peer);
@@ -304,14 +303,13 @@ static void rxrpc_free_peer(struct rxrpc_peer *peer)
  * since we've already done a search in the list from the non-reentrant context
  * (the data_ready handler) that is the only place we can add new peers.
  */
-void rxrpc_new_incoming_peer(struct rxrpc_sock *rx, struct rxrpc_local *local,
-			     struct rxrpc_peer *peer)
+void rxrpc_new_incoming_peer(struct rxrpc_local *local, struct rxrpc_peer *peer)
 {
 	struct rxrpc_net *rxnet = local->rxnet;
 	unsigned long hash_key;
 
 	hash_key = rxrpc_peer_hash_key(local, &peer->srx);
-	rxrpc_init_peer(rx, peer, hash_key);
+	rxrpc_init_peer(local, peer, hash_key);
 
 	spin_lock(&rxnet->peer_hash_lock);
 	hash_add_rcu(rxnet->peer_hash, &peer->hash_link, hash_key);
@@ -322,8 +320,7 @@ void rxrpc_new_incoming_peer(struct rxrpc_sock *rx, struct rxrpc_local *local,
 /*
  * obtain a remote transport endpoint for the specified address
  */
-struct rxrpc_peer *rxrpc_lookup_peer(struct rxrpc_sock *rx,
-				     struct rxrpc_local *local,
+struct rxrpc_peer *rxrpc_lookup_peer(struct rxrpc_local *local,
 				     struct sockaddr_rxrpc *srx, gfp_t gfp)
 {
 	struct rxrpc_peer *peer, *candidate;
@@ -343,7 +340,7 @@ struct rxrpc_peer *rxrpc_lookup_peer(struct rxrpc_sock *rx,
 		/* The peer is not yet present in hash - create a candidate
 		 * for a new record and then redo the search.
 		 */
-		candidate = rxrpc_create_peer(rx, local, srx, hash_key, gfp);
+		candidate = rxrpc_create_peer(local, srx, hash_key, gfp);
 		if (!candidate) {
 			_leave(" = NULL [nomem]");
 			return NULL;


