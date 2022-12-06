Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3DE5644889
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234692AbiLFQBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:01:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234422AbiLFQAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:00:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF40286DE
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 07:59:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670342363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Hd4cCYEIPilIoRtMeZhgzlLe8VXGoDQwL42cMiEFwY=;
        b=LSGRF9KgcrDrK+LtY9sZuErtbj4WwyhS1sgoOLF6oFEwaMkvppiFHTOXtRPUavy86gWWM/
        7eFBpC8cVAjrS8ckbeJfGDIoOs4NgaDcBCZMGPVDsgXWHGQseh0uvVp/6VDbJjeIdjVtP+
        fgfreoUJxxOT2BmZX6Tf2oMEZlfG+QU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-201-hFzxQ_nUOLOOAvHtR2oHKg-1; Tue, 06 Dec 2022 10:59:20 -0500
X-MC-Unique: hFzxQ_nUOLOOAvHtR2oHKg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2B2E8282381A;
        Tue,  6 Dec 2022 15:59:20 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6CB20492B04;
        Tue,  6 Dec 2022 15:59:19 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 05/32] rxrpc: Convert call->recvmsg_lock to a
 spinlock
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Tue, 06 Dec 2022 15:59:16 +0000
Message-ID: <167034235675.1105287.3642482133403716968.stgit@warthog.procyon.org.uk>
In-Reply-To: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
References: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
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

 net/rxrpc/af_rxrpc.c    |    2 +-
 net/rxrpc/ar-internal.h |    2 +-
 net/rxrpc/call_object.c |    4 ++--
 net/rxrpc/recvmsg.c     |   12 ++++++------
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index 7ea576f6ba4b..b9dadc89fede 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -783,7 +783,7 @@ static int rxrpc_create(struct net *net, struct socket *sock, int protocol,
 	INIT_LIST_HEAD(&rx->sock_calls);
 	INIT_LIST_HEAD(&rx->to_be_accepted);
 	INIT_LIST_HEAD(&rx->recvmsg_q);
-	rwlock_init(&rx->recvmsg_lock);
+	spin_lock_init(&rx->recvmsg_lock);
 	rwlock_init(&rx->call_lock);
 	memset(&rx->srx, 0, sizeof(rx->srx));
 
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index cb227b85aae1..423f2e1eddb3 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -154,7 +154,7 @@ struct rxrpc_sock {
 	struct list_head	sock_calls;	/* List of calls owned by this socket */
 	struct list_head	to_be_accepted;	/* calls awaiting acceptance */
 	struct list_head	recvmsg_q;	/* Calls awaiting recvmsg's attention  */
-	rwlock_t		recvmsg_lock;	/* Lock for recvmsg_q */
+	spinlock_t		recvmsg_lock;	/* Lock for recvmsg_q */
 	struct key		*key;		/* security for this socket */
 	struct key		*securities;	/* list of server security descriptors */
 	struct rb_root		calls;		/* User ID -> call mapping */
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 89dcf60b1158..36cc868b8922 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -538,7 +538,7 @@ void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
 	del_timer_sync(&call->timer);
 
 	/* Make sure we don't get any more notifications */
-	write_lock(&rx->recvmsg_lock);
+	spin_lock(&rx->recvmsg_lock);
 
 	if (!list_empty(&call->recvmsg_link)) {
 		_debug("unlinking once-pending call %p { e=%lx f=%lx }",
@@ -551,7 +551,7 @@ void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
 	call->recvmsg_link.next = NULL;
 	call->recvmsg_link.prev = NULL;
 
-	write_unlock(&rx->recvmsg_lock);
+	spin_unlock(&rx->recvmsg_lock);
 	if (put)
 		rxrpc_put_call(call, rxrpc_call_put_unnotify);
 
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index 36b25d003cf0..0cde2b477711 100644
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
@@ -441,14 +441,14 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
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
 
 	trace_rxrpc_recvmsg(call, rxrpc_recvmsg_dequeue, 0);
 
@@ -536,9 +536,9 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 
 error_requeue_call:
 	if (!(flags & MSG_PEEK)) {
-		write_lock(&rx->recvmsg_lock);
+		spin_lock(&rx->recvmsg_lock);
 		list_add(&call->recvmsg_link, &rx->recvmsg_q);
-		write_unlock(&rx->recvmsg_lock);
+		spin_unlock(&rx->recvmsg_lock);
 		trace_rxrpc_recvmsg(call, rxrpc_recvmsg_requeue, 0);
 	} else {
 		rxrpc_put_call(call, rxrpc_call_put_recvmsg);


