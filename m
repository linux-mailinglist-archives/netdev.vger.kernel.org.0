Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52164635A2D
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 11:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237122AbiKWKdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 05:33:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237667AbiKWKcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 05:32:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF87E8FB1D
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 02:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669198560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lrpNfaNG4OA9VEUeBYAO49T28PSaXtZ7dQIslseuYHk=;
        b=BOxJoONWEtVD4J1xtgWWB40n4gr+Wxjk8DknM1MWdqP1THLgScnWeawDNG7qg8fLf02t6b
        at+1TBJUi8aEt9NXtUW5KIZP1rqLYZjGcrdMBxiD7+ppmxlC32MwqfAtriv8IySS7M7/OG
        CoZHC59n2i4qjeoa/heRwDVvmlSXFNU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-211-y5hdsfZPNy-Q_2mINzHa3A-1; Wed, 23 Nov 2022 05:15:57 -0500
X-MC-Unique: y5hdsfZPNy-Q_2mINzHa3A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 268FF857F8F;
        Wed, 23 Nov 2022 10:15:57 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 694F7477F5E;
        Wed, 23 Nov 2022 10:15:56 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 11/17] rxrpc: Remove RCU from peer->error_targets
 list
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 23 Nov 2022 10:15:53 +0000
Message-ID: <166919855385.1258552.11439212927842413620.stgit@warthog.procyon.org.uk>
In-Reply-To: <166919846440.1258552.9618708344491052554.stgit@warthog.procyon.org.uk>
References: <166919846440.1258552.9618708344491052554.stgit@warthog.procyon.org.uk>
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

Remove the RCU requirements from the peer's list of error targets so that
the error distributor can call sleeping functions.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/call_accept.c |    6 ++++++
 net/rxrpc/call_object.c |    2 +-
 net/rxrpc/conn_client.c |    4 ++++
 net/rxrpc/conn_object.c |    2 +-
 net/rxrpc/output.c      |    6 ------
 net/rxrpc/peer_event.c  |   15 ++++++++++++++-
 6 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index 46cd52f50ec4..59614ff7ffb7 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -430,6 +430,12 @@ struct rxrpc_call *rxrpc_new_incoming_call(struct rxrpc_local *local,
 	 */
 	rxrpc_put_call(call, rxrpc_call_put_discard_prealloc);
 
+	if (hlist_unhashed(&call->error_link)) {
+		spin_lock(&call->peer->lock);
+		hlist_add_head(&call->error_link, &call->peer->error_targets);
+		spin_unlock(&call->peer->lock);
+	}
+
 	_leave(" = %p{%d}", call, call->debug_id);
 	return call;
 
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index f1071f9ed115..5f72d95bee68 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -439,7 +439,7 @@ void rxrpc_incoming_call(struct rxrpc_sock *rx,
 	rcu_assign_pointer(conn->channels[chan].call, call);
 
 	spin_lock(&conn->peer->lock);
-	hlist_add_head_rcu(&call->error_link, &conn->peer->error_targets);
+	hlist_add_head(&call->error_link, &conn->peer->error_targets);
 	spin_unlock(&conn->peer->lock);
 
 	rxrpc_start_call_timer(call);
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index b369eaed52ef..783941e8feb4 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -786,6 +786,10 @@ void rxrpc_expose_client_call(struct rxrpc_call *call)
 		if (chan->call_counter >= INT_MAX)
 			set_bit(RXRPC_CONN_DONT_REUSE, &conn->flags);
 		trace_rxrpc_client(conn, channel, rxrpc_client_exposed);
+
+		spin_lock(&call->peer->lock);
+		hlist_add_head(&call->error_link, &call->peer->error_targets);
+		spin_unlock(&call->peer->lock);
 	}
 }
 
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index 891cbbb1926d..21b5096af64e 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -211,7 +211,7 @@ void rxrpc_disconnect_call(struct rxrpc_call *call)
 
 	if (!hlist_unhashed(&call->error_link)) {
 		spin_lock(&call->peer->lock);
-		hlist_del_rcu(&call->error_link);
+		hlist_del_init(&call->error_link);
 		spin_unlock(&call->peer->lock);
 	}
 
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index e2880e01624e..ab102adefcb0 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -394,12 +394,6 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 
 	_enter("%x,{%d}", txb->seq, txb->len);
 
-	if (hlist_unhashed(&call->error_link)) {
-		spin_lock(&call->peer->lock);
-		hlist_add_head_rcu(&call->error_link, &call->peer->error_targets);
-		spin_unlock(&call->peer->lock);
-	}
-
 	/* Each transmission of a Tx packet needs a new serial number */
 	serial = atomic_inc_return(&conn->serial);
 	txb->wire.serial = htonl(serial);
diff --git a/net/rxrpc/peer_event.c b/net/rxrpc/peer_event.c
index e902895e67b0..4351ba43f7f5 100644
--- a/net/rxrpc/peer_event.c
+++ b/net/rxrpc/peer_event.c
@@ -207,11 +207,24 @@ static void rxrpc_distribute_error(struct rxrpc_peer *peer, int error,
 				   enum rxrpc_call_completion compl)
 {
 	struct rxrpc_call *call;
+	HLIST_HEAD(error_targets);
+
+	spin_lock(&peer->lock);
+	hlist_move_list(&peer->error_targets, &error_targets);
+
+	while (!hlist_empty(&error_targets)) {
+		call = hlist_entry(error_targets.first,
+				   struct rxrpc_call, error_link);
+		hlist_del_init(&call->error_link);
+		spin_unlock(&peer->lock);
 
-	hlist_for_each_entry_rcu(call, &peer->error_targets, error_link) {
 		rxrpc_see_call(call, rxrpc_call_see_distribute_error);
 		rxrpc_set_call_completion(call, compl, 0, -error);
+
+		spin_lock(&peer->lock);
 	}
+
+	spin_unlock(&peer->lock);
 }
 
 /*


