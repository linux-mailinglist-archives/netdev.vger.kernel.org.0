Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B85CC660D6B
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 10:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbjAGJyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 04:54:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231934AbjAGJx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 04:53:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F8837D9D8
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 01:53:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673085194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TQXEkUgYDu4iJJwCI6AfARV2Uc0uPJuGZcEwoo/OskQ=;
        b=bcShUx6bdn0DyFkYL/nfxren8yMn5tfvAk3Iic/NbhbNLkI3P/PdEwAxR5TKikHt5qxkb2
        4V8GkMNKQc0WFciI53asmItD68z10lFecwhbFwT9O3nEBzl+mmPVGtB230+vakwNqAJUAO
        0lVqeu88RYriVZ4ZIHU6Jk0mEHxXQww=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-413-XePIB2A-Pw-4feXJfStfIw-1; Sat, 07 Jan 2023 04:53:07 -0500
X-MC-Unique: XePIB2A-Pw-4feXJfStfIw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 50E87801779;
        Sat,  7 Jan 2023 09:53:07 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.87])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A822492B00;
        Sat,  7 Jan 2023 09:53:06 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 02/19] rxrpc: Make the local endpoint hold a ref on a
 connected call
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Sat, 07 Jan 2023 09:53:04 +0000
Message-ID: <167308518488.1538866.4463742812210253528.stgit@warthog.procyon.org.uk>
In-Reply-To: <167308517118.1538866.3440481802366869065.stgit@warthog.procyon.org.uk>
References: <167308517118.1538866.3440481802366869065.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make the local endpoint and it's I/O thread hold a reference on a connected
call until that call is disconnected.  Without this, we're reliant on
either the AF_RXRPC socket to hold a ref (which is dropped when the call is
released) or a queued work item to hold a ref (the work item is being
replaced with the I/O thread).

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |    3 +++
 net/rxrpc/call_object.c      |    2 ++
 net/rxrpc/conn_client.c      |    6 +++---
 net/rxrpc/conn_object.c      |   25 +++++++++++++++----------
 4 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 5f9dd7389536..b526d982da7e 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -148,6 +148,7 @@
 	E_(rxrpc_client_to_idle,		"->Idle")
 
 #define rxrpc_call_traces \
+	EM(rxrpc_call_get_io_thread,		"GET iothread") \
 	EM(rxrpc_call_get_input,		"GET input   ") \
 	EM(rxrpc_call_get_kernel_service,	"GET krnl-srv") \
 	EM(rxrpc_call_get_notify_socket,	"GET notify  ") \
@@ -160,6 +161,7 @@
 	EM(rxrpc_call_new_prealloc_service,	"NEW prealloc") \
 	EM(rxrpc_call_put_discard_prealloc,	"PUT disc-pre") \
 	EM(rxrpc_call_put_discard_error,	"PUT disc-err") \
+	EM(rxrpc_call_put_io_thread,		"PUT iothread") \
 	EM(rxrpc_call_put_input,		"PUT input   ") \
 	EM(rxrpc_call_put_kernel,		"PUT kernel  ") \
 	EM(rxrpc_call_put_poke,			"PUT poke    ") \
@@ -173,6 +175,7 @@
 	EM(rxrpc_call_see_activate_client,	"SEE act-clnt") \
 	EM(rxrpc_call_see_connect_failed,	"SEE con-fail") \
 	EM(rxrpc_call_see_connected,		"SEE connect ") \
+	EM(rxrpc_call_see_disconnected,		"SEE disconn ") \
 	EM(rxrpc_call_see_distribute_error,	"SEE dist-err") \
 	EM(rxrpc_call_see_input,		"SEE input   ") \
 	EM(rxrpc_call_see_release,		"SEE release ") \
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 89dcf60b1158..239fc3c75079 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -453,6 +453,8 @@ void rxrpc_incoming_call(struct rxrpc_sock *rx,
 		BUG();
 	}
 
+	rxrpc_get_call(call, rxrpc_call_get_io_thread);
+
 	/* Set the channel for this call.  We don't get channel_lock as we're
 	 * only defending against the data_ready handler (which we're called
 	 * from) and the RESPONSE packet parser (which is only really
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index e4063c4f4bb2..1edd65883c55 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -725,8 +725,11 @@ int rxrpc_connect_call(struct rxrpc_sock *rx,
 
 	rxrpc_discard_expired_client_conns(&rxnet->client_conn_reaper);
 
+	rxrpc_get_call(call, rxrpc_call_get_io_thread);
+
 	bundle = rxrpc_prep_call(rx, call, cp, srx, gfp);
 	if (IS_ERR(bundle)) {
+		rxrpc_put_call(call, rxrpc_call_get_io_thread);
 		ret = PTR_ERR(bundle);
 		goto out;
 	}
@@ -820,7 +823,6 @@ void rxrpc_disconnect_client_call(struct rxrpc_bundle *bundle, struct rxrpc_call
 	_enter("c=%x", call->debug_id);
 
 	spin_lock(&bundle->channel_lock);
-	set_bit(RXRPC_CALL_DISCONNECTED, &call->flags);
 
 	/* Calls that have never actually been assigned a channel can simply be
 	 * discarded.
@@ -912,8 +914,6 @@ void rxrpc_disconnect_client_call(struct rxrpc_bundle *bundle, struct rxrpc_call
 
 out:
 	spin_unlock(&bundle->channel_lock);
-	_leave("");
-	return;
 }
 
 /*
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index 3c8f83dacb2b..2bd3f6288895 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -178,6 +178,9 @@ void rxrpc_disconnect_call(struct rxrpc_call *call)
 {
 	struct rxrpc_connection *conn = call->conn;
 
+	set_bit(RXRPC_CALL_DISCONNECTED, &call->flags);
+	rxrpc_see_call(call, rxrpc_call_see_disconnected);
+
 	call->peer->cong_ssthresh = call->cong_ssthresh;
 
 	if (!hlist_unhashed(&call->error_link)) {
@@ -186,18 +189,20 @@ void rxrpc_disconnect_call(struct rxrpc_call *call)
 		spin_unlock(&call->peer->lock);
 	}
 
-	if (rxrpc_is_client_call(call))
-		return rxrpc_disconnect_client_call(conn->bundle, call);
+	if (rxrpc_is_client_call(call)) {
+		rxrpc_disconnect_client_call(conn->bundle, call);
+	} else {
+		spin_lock(&conn->bundle->channel_lock);
+		__rxrpc_disconnect_call(conn, call);
+		spin_unlock(&conn->bundle->channel_lock);
 
-	spin_lock(&conn->bundle->channel_lock);
-	__rxrpc_disconnect_call(conn, call);
-	spin_unlock(&conn->bundle->channel_lock);
+		conn->idle_timestamp = jiffies;
+		if (atomic_dec_and_test(&conn->active))
+			rxrpc_set_service_reap_timer(conn->rxnet,
+						     jiffies + rxrpc_connection_expiry);
+	}
 
-	set_bit(RXRPC_CALL_DISCONNECTED, &call->flags);
-	conn->idle_timestamp = jiffies;
-	if (atomic_dec_and_test(&conn->active))
-		rxrpc_set_service_reap_timer(conn->rxnet,
-					     jiffies + rxrpc_connection_expiry);
+	rxrpc_put_call(call, rxrpc_call_put_io_thread);
 }
 
 /*


