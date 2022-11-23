Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E046635A2A
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 11:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237181AbiKWKcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 05:32:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237490AbiKWKcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 05:32:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94AE8E0D9
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 02:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669198528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/JIc7C6bHMr2yR7PRaYpswtXHVf06FOZdXU09PtPw7c=;
        b=SjTYxtep8dqnie77a7J4uZKPwR8mHcFElpk1RH4+SyMsmvOPyjUDxCefv2s8y0X8NjUc6v
        EYRRE4KBdRQ/r+mTieB3VGh6hBH1I1FjYMnGoK75xHcFWCWQeS+pLFaNqenAIHmuruJhKY
        7FpUpEhmd2rftCRGXFzbLlWWVogEJ64=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-htdbRUTXNpOGrxp20LEFHA-1; Wed, 23 Nov 2022 05:15:25 -0500
X-MC-Unique: htdbRUTXNpOGrxp20LEFHA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F1ED885A588;
        Wed, 23 Nov 2022 10:15:24 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 40E184A9254;
        Wed, 23 Nov 2022 10:15:24 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 07/17] rxrpc: Don't take spinlocks in the RCU
 callback functions
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 23 Nov 2022 10:15:21 +0000
Message-ID: <166919852169.1258552.10370784990641295051.stgit@warthog.procyon.org.uk>
In-Reply-To: <166919846440.1258552.9618708344491052554.stgit@warthog.procyon.org.uk>
References: <166919846440.1258552.9618708344491052554.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't take spinlocks in the RCU callback functions as these are run in
softirq context - which then requires all other takers to use _bh-marked
locks.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/call_object.c |   30 +++++++-----------------------
 net/rxrpc/conn_object.c |   18 +++++++++---------
 2 files changed, 16 insertions(+), 32 deletions(-)

diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 01ffe99516b8..d77b65bf3273 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -613,36 +613,16 @@ void rxrpc_put_call(struct rxrpc_call *call, enum rxrpc_call_trace why)
 /*
  * Final call destruction - but must be done in process context.
  */
-static void rxrpc_destroy_call(struct work_struct *work)
+static void rxrpc_destroy_call(struct rcu_head *rcu)
 {
-	struct rxrpc_call *call = container_of(work, struct rxrpc_call, processor);
+	struct rxrpc_call *call = container_of(rcu, struct rxrpc_call, rcu);
 	struct rxrpc_net *rxnet = call->rxnet;
 
-	rxrpc_delete_call_timer(call);
-
-	rxrpc_put_connection(call->conn, rxrpc_conn_put_call);
-	rxrpc_put_peer(call->peer, rxrpc_peer_put_call);
 	kmem_cache_free(rxrpc_call_jar, call);
 	if (atomic_dec_and_test(&rxnet->nr_calls))
 		wake_up_var(&rxnet->nr_calls);
 }
 
-/*
- * Final call destruction under RCU.
- */
-static void rxrpc_rcu_destroy_call(struct rcu_head *rcu)
-{
-	struct rxrpc_call *call = container_of(rcu, struct rxrpc_call, rcu);
-
-	if (rcu_read_lock_held()) {
-		INIT_WORK(&call->processor, rxrpc_destroy_call);
-		if (!rxrpc_queue_work(&call->processor))
-			BUG();
-	} else {
-		rxrpc_destroy_call(&call->processor);
-	}
-}
-
 /*
  * clean up a call
  */
@@ -663,8 +643,12 @@ void rxrpc_cleanup_call(struct rxrpc_call *call)
 	}
 	rxrpc_put_txbuf(call->tx_pending, rxrpc_txbuf_put_cleaned);
 	rxrpc_free_skb(call->acks_soft_tbl, rxrpc_skb_put_ack);
+	rxrpc_delete_call_timer(call);
+
+	rxrpc_put_connection(call->conn, rxrpc_conn_put_call);
+	rxrpc_put_peer(call->peer, rxrpc_peer_put_call);
 
-	call_rcu(&call->rcu, rxrpc_rcu_destroy_call);
+	call_rcu(&call->rcu, rxrpc_destroy_call);
 }
 
 /*
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index f7c271a740ed..54821c2f6d89 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -249,6 +249,15 @@ void rxrpc_kill_connection(struct rxrpc_connection *conn)
 	 */
 	rxrpc_purge_queue(&conn->rx_queue);
 
+	del_timer_sync(&conn->timer);
+	rxrpc_purge_queue(&conn->rx_queue);
+
+	conn->security->clear(conn);
+	key_put(conn->key);
+	rxrpc_put_bundle(conn->bundle, rxrpc_bundle_put_conn);
+	rxrpc_put_peer(conn->peer, rxrpc_peer_put_conn);
+	rxrpc_put_local(conn->local, rxrpc_local_put_kill_conn);
+
 	/* Leave final destruction to RCU.  The connection processor work item
 	 * must carry a ref on the connection to prevent us getting here whilst
 	 * it is queued or running.
@@ -358,17 +367,8 @@ static void rxrpc_destroy_connection(struct rcu_head *rcu)
 
 	ASSERTCMP(refcount_read(&conn->ref), ==, 0);
 
-	del_timer_sync(&conn->timer);
-	rxrpc_purge_queue(&conn->rx_queue);
-
-	conn->security->clear(conn);
-	key_put(conn->key);
-	rxrpc_put_bundle(conn->bundle, rxrpc_bundle_put_conn);
-	rxrpc_put_peer(conn->peer, rxrpc_peer_put_conn);
-
 	if (atomic_dec_and_test(&conn->local->rxnet->nr_conns))
 		wake_up_var(&conn->local->rxnet->nr_conns);
-	rxrpc_put_local(conn->local, rxrpc_local_put_kill_conn);
 
 	kfree(conn);
 	_leave("");


