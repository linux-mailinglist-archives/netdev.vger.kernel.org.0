Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F637654FFB
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 13:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236221AbiLWMCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 07:02:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235429AbiLWMBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 07:01:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4FA4080C
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 04:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671796817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IdJKWvU8oan6R0NG+jgffjDQcUrJ6USgTLYJyQRM0Qc=;
        b=dnjeKJeCvQSFn6YP0k84hDVK3URqXpveQS69TwfkaY29oQNMPF9K4+rvpn8R/WiLrTfZYY
        hLYLDXdb4xQYrq5BNso05+RUSt7no90ltWLlSN8ebAI487pEWuuErts80Xb+E+bg/1sVZ5
        fNeHDYJ5d2LtyD+RmXQ35xMrGILBMfQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-551-IZvs7AU_Ohe4yJg9s1TPuA-1; Fri, 23 Dec 2022 07:00:14 -0500
X-MC-Unique: IZvs7AU_Ohe4yJg9s1TPuA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 165968F6E83;
        Fri, 23 Dec 2022 12:00:14 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5BD9C492C14;
        Fri, 23 Dec 2022 12:00:13 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 02/19] rxrpc: Stash the network namespace pointer in
 rxrpc_local
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Fri, 23 Dec 2022 12:00:12 +0000
Message-ID: <167179681276.2516210.17147293431614618254.stgit@warthog.procyon.org.uk>
In-Reply-To: <167179679960.2516210.10739247907156079872.stgit@warthog.procyon.org.uk>
References: <167179679960.2516210.10739247907156079872.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
index 18092526d3c8..fe2785c648f2 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -283,7 +283,8 @@ struct rxrpc_local {
 	struct rcu_head		rcu;
 	atomic_t		active_users;	/* Number of users of the local endpoint */
 	refcount_t		ref;		/* Number of references to the structure */
-	struct rxrpc_net	*rxnet;		/* The network ns in which this resides */
+	struct net		*net;		/* The network namespace */
+	struct rxrpc_net	*rxnet;		/* Our bits in the network namespace */
 	struct hlist_node	link;
 	struct socket		*socket;	/* my UDP socket */
 	struct task_struct	*io_thread;
@@ -1063,12 +1064,11 @@ void rxrpc_peer_keepalive_worker(struct work_struct *);
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
index c02401656fa9..c957e4415cdc 100644
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
index 87efa0373aed..e4063c4f4bb2 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -378,7 +378,7 @@ static struct rxrpc_bundle *rxrpc_prep_call(struct rxrpc_sock *rx,
 
 	_enter("{%d,%lx},", call->debug_id, call->user_call_ID);
 
-	cp->peer = rxrpc_lookup_peer(rx, cp->local, srx, gfp);
+	cp->peer = rxrpc_lookup_peer(cp->local, srx, gfp);
 	if (!cp->peer)
 		goto error;
 
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 270b63d8f37a..c0ac2fe07ec4 100644
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
 		init_rwsem(&local->defrag_sem);
 		init_completion(&local->io_thread_ready);
@@ -248,7 +249,7 @@ struct rxrpc_local *rxrpc_lookup_local(struct net *net,
 		goto found;
 	}
 
-	local = rxrpc_alloc_local(rxnet, srx);
+	local = rxrpc_alloc_local(net, srx);
 	if (!local)
 		goto nomem;
 
diff --git a/net/rxrpc/peer_object.c b/net/rxrpc/peer_object.c
index 4eecea2be307..8d7a715a0bb1 100644
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


