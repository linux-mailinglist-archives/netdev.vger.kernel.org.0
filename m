Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6A1668336F
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 18:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbjAaRNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 12:13:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjAaRNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 12:13:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9246854210
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 09:12:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675185163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+wBnsraIbJ0LKwtC5Uf24r7KaeTV6Fg0HQ/aibcGoIs=;
        b=FhbEm5GQD1ltaxvxL63aUMifEV78w0yHCWXAdlUAwPCbVH9bs3ofFvBrtaWbURKjZripph
        QFXHZfv16yAnDclRIjNg/lFz/YmOHGC1OcSWCFIFunQgCSji+7rnBRKUGhu0MGzbZEszP7
        jx/k0SISAEv8ej0yFYlWeJbNHslxcpI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-FtmV6J5sOqqHcVp5MbknLA-1; Tue, 31 Jan 2023 12:12:41 -0500
X-MC-Unique: FtmV6J5sOqqHcVp5MbknLA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 530D318013BA;
        Tue, 31 Jan 2023 17:12:38 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.33.36.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 36B1E2166B35;
        Tue, 31 Jan 2023 17:12:37 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 04/13] rxrpc: Convert call->recvmsg_lock to a spinlock
Date:   Tue, 31 Jan 2023 17:12:18 +0000
Message-Id: <20230131171227.3912130-5-dhowells@redhat.com>
In-Reply-To: <20230131171227.3912130-1-dhowells@redhat.com>
References: <20230131171227.3912130-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert call->recvmsg_lock to a spinlock as it's only ever write-locked.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---
 net/rxrpc/af_rxrpc.c    |  2 +-
 net/rxrpc/ar-internal.h |  2 +-
 net/rxrpc/call_object.c |  4 ++--
 net/rxrpc/recvmsg.c     | 12 ++++++------
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index ebbd4a1c3f86..102f5cbff91a 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -786,7 +786,7 @@ static int rxrpc_create(struct net *net, struct socket *sock, int protocol,
 	INIT_LIST_HEAD(&rx->sock_calls);
 	INIT_LIST_HEAD(&rx->to_be_accepted);
 	INIT_LIST_HEAD(&rx->recvmsg_q);
-	rwlock_init(&rx->recvmsg_lock);
+	spin_lock_init(&rx->recvmsg_lock);
 	rwlock_init(&rx->call_lock);
 	memset(&rx->srx, 0, sizeof(rx->srx));
 
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 433060cade03..808c08cb2ae5 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -149,7 +149,7 @@ struct rxrpc_sock {
 	struct list_head	sock_calls;	/* List of calls owned by this socket */
 	struct list_head	to_be_accepted;	/* calls awaiting acceptance */
 	struct list_head	recvmsg_q;	/* Calls awaiting recvmsg's attention  */
-	rwlock_t		recvmsg_lock;	/* Lock for recvmsg_q */
+	spinlock_t		recvmsg_lock;	/* Lock for recvmsg_q */
 	struct key		*key;		/* security for this socket */
 	struct key		*securities;	/* list of server security descriptors */
 	struct rb_root		calls;		/* User ID -> call mapping */
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index f3c9f0201c15..0012589f2aad 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -560,7 +560,7 @@ void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
 	rxrpc_put_call_slot(call);
 
 	/* Make sure we don't get any more notifications */
-	write_lock(&rx->recvmsg_lock);
+	spin_lock(&rx->recvmsg_lock);
 
 	if (!list_empty(&call->recvmsg_link)) {
 		_debug("unlinking once-pending call %p { e=%lx f=%lx }",
@@ -573,7 +573,7 @@ void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
 	call->recvmsg_link.next = NULL;
 	call->recvmsg_link.prev = NULL;
 
-	write_unlock(&rx->recvmsg_lock);
+	spin_unlock(&rx->recvmsg_lock);
 	if (put)
 		rxrpc_put_call(call, rxrpc_call_put_unnotify);
 
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index dd54ceee7bcc..b7545fdc0401 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -40,12 +40,12 @@ void rxrpc_notify_socket(struct rxrpc_call *call)
 			call->notify_rx(sk, call, call->user_call_ID);
 			spin_unlock(&call->notify_lock);
 		} else {
-			write_lock(&rx->recvmsg_lock);
+			spin_lock(&rx->recvmsg_lock);
 			if (list_empty(&call->recvmsg_link)) {
 				rxrpc_get_call(call, rxrpc_call_get_notify_socket);
 				list_add_tail(&call->recvmsg_link, &rx->recvmsg_q);
 			}
-			write_unlock(&rx->recvmsg_lock);
+			spin_unlock(&rx->recvmsg_lock);
 
 			if (!sock_flag(sk, SOCK_DEAD)) {
 				_debug("call %ps", sk->sk_data_ready);
@@ -335,14 +335,14 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	/* Find the next call and dequeue it if we're not just peeking.  If we
 	 * do dequeue it, that comes with a ref that we will need to release.
 	 */
-	write_lock(&rx->recvmsg_lock);
+	spin_lock(&rx->recvmsg_lock);
 	l = rx->recvmsg_q.next;
 	call = list_entry(l, struct rxrpc_call, recvmsg_link);
 	if (!(flags & MSG_PEEK))
 		list_del_init(&call->recvmsg_link);
 	else
 		rxrpc_get_call(call, rxrpc_call_get_recvmsg);
-	write_unlock(&rx->recvmsg_lock);
+	spin_unlock(&rx->recvmsg_lock);
 
 	call_debug_id = call->debug_id;
 	trace_rxrpc_recvmsg(call_debug_id, rxrpc_recvmsg_dequeue, 0);
@@ -431,9 +431,9 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 
 error_requeue_call:
 	if (!(flags & MSG_PEEK)) {
-		write_lock(&rx->recvmsg_lock);
+		spin_lock(&rx->recvmsg_lock);
 		list_add(&call->recvmsg_link, &rx->recvmsg_q);
-		write_unlock(&rx->recvmsg_lock);
+		spin_unlock(&rx->recvmsg_lock);
 		trace_rxrpc_recvmsg(call_debug_id, rxrpc_recvmsg_requeue, 0);
 	} else {
 		rxrpc_put_call(call, rxrpc_call_put_recvmsg);

