Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA1DF63DB5E
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 18:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbiK3RCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 12:02:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbiK3RCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 12:02:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3AD18DBD4
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 08:58:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669827498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=odmnEFalqiK22jfM/QJXPnjUxCCn5vQWTWNj6w5owoo=;
        b=dXovhgEbRY0CmClxcW+7i6NSGMrWpJxbsoRp+ZgerQrLEAVvcZfap6UeI2K5QBxrpTreA5
        o9KXVcD+m7uYA3qmNWwEjsiwmO3Sr/3v54I84Ue8VxRfiTgcBL7alZJm1aJCSKhPyCuJEU
        wzr/sa4Yaxq5Yy7zMthJZfeK2ATKSMc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-103-brwVPcHqPdW2j2V7c0i-KQ-1; Wed, 30 Nov 2022 11:58:06 -0500
X-MC-Unique: brwVPcHqPdW2j2V7c0i-KQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64A882932480;
        Wed, 30 Nov 2022 16:58:06 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A5F28422A9;
        Wed, 30 Nov 2022 16:58:05 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 26/35] rxrpc: Remove RCU from peer->error_targets
 list
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 30 Nov 2022 16:58:02 +0000
Message-ID: <166982748290.621383.837780227002133853.stgit@warthog.procyon.org.uk>
In-Reply-To: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
References: <166982725699.621383.2358362793992993374.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
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
 net/rxrpc/conn_object.c |    6 +++---
 net/rxrpc/output.c      |    6 ------
 net/rxrpc/peer_event.c  |   15 ++++++++++++++-
 6 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index 8bc327aa2beb..5f978b0b2404 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -433,6 +433,12 @@ struct rxrpc_call *rxrpc_new_incoming_call(struct rxrpc_local *local,
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
index 96a7edd3a842..7570b4e67bc5 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -442,7 +442,7 @@ void rxrpc_incoming_call(struct rxrpc_sock *rx,
 	rcu_assign_pointer(conn->channels[chan].call, call);
 
 	spin_lock(&conn->peer->lock);
-	hlist_add_head_rcu(&call->error_link, &conn->peer->error_targets);
+	hlist_add_head(&call->error_link, &conn->peer->error_targets);
 	spin_unlock(&conn->peer->lock);
 
 	rxrpc_start_call_timer(call);
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index ab3dd22fadc0..3c7b1bdec0db 100644
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
index c2e05ea29f12..5a39255ea014 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -215,9 +215,9 @@ void rxrpc_disconnect_call(struct rxrpc_call *call)
 	call->peer->cong_ssthresh = call->cong_ssthresh;
 
 	if (!hlist_unhashed(&call->error_link)) {
-		spin_lock_bh(&call->peer->lock);
-		hlist_del_rcu(&call->error_link);
-		spin_unlock_bh(&call->peer->lock);
+		spin_lock(&call->peer->lock);
+		hlist_del_init(&call->error_link);
+		spin_unlock(&call->peer->lock);
 	}
 
 	if (rxrpc_is_client_call(call))
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index c8147e50060b..71963b4523be 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -394,12 +394,6 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct rxrpc_txbuf *txb)
 
 	_enter("%x,{%d}", txb->seq, txb->len);
 
-	if (hlist_unhashed(&call->error_link)) {
-		spin_lock_bh(&call->peer->lock);
-		hlist_add_head_rcu(&call->error_link, &call->peer->error_targets);
-		spin_unlock_bh(&call->peer->lock);
-	}
-
 	/* Each transmission of a Tx packet needs a new serial number */
 	serial = atomic_inc_return(&conn->serial);
 	txb->wire.serial = htonl(serial);
diff --git a/net/rxrpc/peer_event.c b/net/rxrpc/peer_event.c
index 94f63fb1bd67..97d017ca3dc4 100644
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


