Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA85F660D96
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 10:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237182AbjAGJ5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 04:57:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231770AbjAGJz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 04:55:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1852F8060F
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 01:55:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673085303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bjgH27JdKO/sZ8DGa3k4Uhxw/OWXTUQI5Lk0Hm906aw=;
        b=IUlpuGOJmCGeU6rlX9n4oLr/m2fBbyx2x2w/t0ek5sC827yAJCR+mkI3x/HXjfdunFKtKR
        zupfrIDByhMz82y7e0kW3bCz5dL4gcFBjJntiGWaXw1c55DzSDHj3777gOWg8IHk7yPrEn
        f1E6j6aVZpJ0v5OR45Zu/IZw/PgUz54=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-452-B8r6_snUMzCWs2lywUhKGg-1; Sat, 07 Jan 2023 04:55:00 -0500
X-MC-Unique: B8r6_snUMzCWs2lywUhKGg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 21103858F09;
        Sat,  7 Jan 2023 09:55:00 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.87])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A04842203;
        Sat,  7 Jan 2023 09:54:59 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 19/19] rxrpc: Fix incoming call setup race
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Sat, 07 Jan 2023 09:54:58 +0000
Message-ID: <167308529885.1538866.3268052932281950211.stgit@warthog.procyon.org.uk>
In-Reply-To: <167308517118.1538866.3440481802366869065.stgit@warthog.procyon.org.uk>
References: <167308517118.1538866.3440481802366869065.stgit@warthog.procyon.org.uk>
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

An incoming call can race with rxrpc socket destruction, leading to a
leaked call.  This may result in an oops when the call timer eventually
expires:

   BUG: kernel NULL pointer dereference, address: 0000000000000874
   RIP: 0010:_raw_spin_lock_irqsave+0x2a/0x50
   Call Trace:
    <IRQ>
    try_to_wake_up+0x59/0x550
    ? __local_bh_enable_ip+0x37/0x80
    ? rxrpc_poke_call+0x52/0x110 [rxrpc]
    ? rxrpc_poke_call+0x110/0x110 [rxrpc]
    ? rxrpc_poke_call+0x110/0x110 [rxrpc]
    call_timer_fn+0x24/0x120

with a warning in the kernel log looking something like:

   rxrpc: Call 00000000ba5e571a still in use (1,SvAwtACK,1061d,0)!

incurred during rmmod of rxrpc.  The 1061d is the call flags:

   RECVMSG_READ_ALL, RX_HEARD, BEGAN_RX_TIMER, RX_LAST, EXPOSED,
   IS_SERVICE, RELEASED

but no DISCONNECTED flag (0x800), so it's an incoming (service) call and
it's still connected.

The race appears to be that:

 (1) rxrpc_new_incoming_call() consults the service struct, checks sk_state
     and allocates a call - then pauses, possibly for an interrupt.

 (2) rxrpc_release_sock() sets RXRPC_CLOSE, nulls the service pointer,
     discards the prealloc and releases all calls attached to the socket.

 (3) rxrpc_new_incoming_call() resumes, launching the new call, including
     its timer and attaching it to the socket.

Fix this by read-locking local->services_lock to access the AF_RXRPC socket
providing the service rather than RCU in rxrpc_new_incoming_call().
There's no real need to use RCU here as local->services_lock is only
write-locked by the socket side in two places: when binding and when
shutting down.

Fixes: 5e6ef4f1017c ("rxrpc: Make the I/O thread take over the call and local processor work")
Reported-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/af_rxrpc.c    |    8 ++++----
 net/rxrpc/ar-internal.h |    2 +-
 net/rxrpc/call_accept.c |   14 +++++++-------
 net/rxrpc/security.c    |    6 +++---
 4 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index cf200e4e0eae..ebbd4a1c3f86 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -155,10 +155,10 @@ static int rxrpc_bind(struct socket *sock, struct sockaddr *saddr, int len)
 
 		if (service_id) {
 			write_lock(&local->services_lock);
-			if (rcu_access_pointer(local->service))
+			if (local->service)
 				goto service_in_use;
 			rx->local = local;
-			rcu_assign_pointer(local->service, rx);
+			local->service = rx;
 			write_unlock(&local->services_lock);
 
 			rx->sk.sk_state = RXRPC_SERVER_BOUND;
@@ -875,9 +875,9 @@ static int rxrpc_release_sock(struct sock *sk)
 
 	sk->sk_state = RXRPC_CLOSE;
 
-	if (rx->local && rcu_access_pointer(rx->local->service) == rx) {
+	if (rx->local && rx->local->service == rx) {
 		write_lock(&rx->local->services_lock);
-		rcu_assign_pointer(rx->local->service, NULL);
+		rx->local->service = NULL;
 		write_unlock(&rx->local->services_lock);
 	}
 
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 007258538bee..433060cade03 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -283,7 +283,7 @@ struct rxrpc_local {
 	struct socket		*socket;	/* my UDP socket */
 	struct task_struct	*io_thread;
 	struct completion	io_thread_ready; /* Indication that the I/O thread started */
-	struct rxrpc_sock __rcu	*service;	/* Service(s) listening on this endpoint */
+	struct rxrpc_sock	*service;	/* Service(s) listening on this endpoint */
 	struct rw_semaphore	defrag_sem;	/* control re-enablement of IP DF bit */
 	struct sk_buff_head	rx_queue;	/* Received packets */
 	struct list_head	conn_attend_q;	/* Conns requiring immediate attention */
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index 3fbf2fcaaf9e..3e8689fdc437 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -343,13 +343,13 @@ bool rxrpc_new_incoming_call(struct rxrpc_local *local,
 	if (sp->hdr.type != RXRPC_PACKET_TYPE_DATA)
 		return rxrpc_protocol_error(skb, rxrpc_eproto_no_service_call);
 
-	rcu_read_lock();
+	read_lock(&local->services_lock);
 
 	/* Weed out packets to services we're not offering.  Packets that would
 	 * begin a call are explicitly rejected and the rest are just
 	 * discarded.
 	 */
-	rx = rcu_dereference(local->service);
+	rx = local->service;
 	if (!rx || (sp->hdr.serviceId != rx->srx.srx_service &&
 		    sp->hdr.serviceId != rx->second_service)
 	    ) {
@@ -399,7 +399,7 @@ bool rxrpc_new_incoming_call(struct rxrpc_local *local,
 	spin_unlock(&conn->state_lock);
 
 	spin_unlock(&rx->incoming_lock);
-	rcu_read_unlock();
+	read_unlock(&local->services_lock);
 
 	if (hlist_unhashed(&call->error_link)) {
 		spin_lock(&call->peer->lock);
@@ -413,20 +413,20 @@ bool rxrpc_new_incoming_call(struct rxrpc_local *local,
 	return true;
 
 unsupported_service:
-	rcu_read_unlock();
+	read_unlock(&local->services_lock);
 	return rxrpc_direct_abort(skb, rxrpc_abort_service_not_offered,
 				  RX_INVALID_OPERATION, -EOPNOTSUPP);
 unsupported_security:
-	rcu_read_unlock();
+	read_unlock(&local->services_lock);
 	return rxrpc_direct_abort(skb, rxrpc_abort_service_not_offered,
 				  RX_INVALID_OPERATION, -EKEYREJECTED);
 no_call:
 	spin_unlock(&rx->incoming_lock);
-	rcu_read_unlock();
+	read_unlock(&local->services_lock);
 	_leave(" = f [%u]", skb->mark);
 	return false;
 discard:
-	rcu_read_unlock();
+	read_unlock(&local->services_lock);
 	return true;
 }
 
diff --git a/net/rxrpc/security.c b/net/rxrpc/security.c
index cd66634dffe6..cb8dd1d3b1d4 100644
--- a/net/rxrpc/security.c
+++ b/net/rxrpc/security.c
@@ -178,9 +178,9 @@ struct key *rxrpc_look_up_server_security(struct rxrpc_connection *conn,
 		sprintf(kdesc, "%u:%u",
 			sp->hdr.serviceId, sp->hdr.securityIndex);
 
-	rcu_read_lock();
+	read_lock(&conn->local->services_lock);
 
-	rx = rcu_dereference(conn->local->service);
+	rx = conn->local->service;
 	if (!rx)
 		goto out;
 
@@ -202,6 +202,6 @@ struct key *rxrpc_look_up_server_security(struct rxrpc_connection *conn,
 	}
 
 out:
-	rcu_read_unlock();
+	read_unlock(&conn->local->services_lock);
 	return key;
 }


