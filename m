Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31492655A62
	for <lists+netdev@lfdr.de>; Sat, 24 Dec 2022 15:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbiLXOts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Dec 2022 09:49:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiLXOtq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Dec 2022 09:49:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370CDE0E8
        for <netdev@vger.kernel.org>; Sat, 24 Dec 2022 06:49:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671893343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=4tzYr3Pu5jtMD/IxJuZhK1FdWppt8xGya9MKeSgwwE8=;
        b=d56l+ulcEzNSoswRvU5HlmXK/rxPzP0c0soiThLuVtZXvcNAGhxkcemo3rXIIC3asUUqqj
        BufvjsqTB7POCP/9Cp+P9pNY8uQNbiwkismeb0yV5uaotiY7NEur51u3oclAvom6o8VpCl
        7/W//E3RJunHyrqVHDKO7UrONrFnH94=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-379-qS58rLuHNkaqSkIDqD9ZdA-1; Sat, 24 Dec 2022 09:49:01 -0500
X-MC-Unique: qS58rLuHNkaqSkIDqD9ZdA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6CB243C0D845;
        Sat, 24 Dec 2022 14:49:01 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C763214152F4;
        Sat, 24 Dec 2022 14:49:00 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net] rxrpc: Fix a couple of potential use-after-frees
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com
Date:   Sat, 24 Dec 2022 14:49:00 +0000
Message-ID: <167189334008.2649494.14058695597250049586.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At the end of rxrpc_recvmsg(), if a call is found, the call is put and then
a trace line is emitted referencing that call in a couple of places - but
the call may have been deallocated by the time those traces happen.

Fix this by stashing the call debug_id in a variable and passing that to
the tracepoint rather than the call pointer.

Fixes: 849979051cbc ("rxrpc: Add a tracepoint to follow what recvmsg does")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |    6 +++---
 net/rxrpc/recvmsg.c          |   14 ++++++++------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index c6cfed00d0c6..5f9dd7389536 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -1062,10 +1062,10 @@ TRACE_EVENT(rxrpc_receive,
 	    );
 
 TRACE_EVENT(rxrpc_recvmsg,
-	    TP_PROTO(struct rxrpc_call *call, enum rxrpc_recvmsg_trace why,
+	    TP_PROTO(unsigned int call_debug_id, enum rxrpc_recvmsg_trace why,
 		     int ret),
 
-	    TP_ARGS(call, why, ret),
+	    TP_ARGS(call_debug_id, why, ret),
 
 	    TP_STRUCT__entry(
 		    __field(unsigned int,		call		)
@@ -1074,7 +1074,7 @@ TRACE_EVENT(rxrpc_recvmsg,
 			     ),
 
 	    TP_fast_assign(
-		    __entry->call = call ? call->debug_id : 0;
+		    __entry->call = call_debug_id;
 		    __entry->why = why;
 		    __entry->ret = ret;
 			   ),
diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index 36b25d003cf0..6ebd6440a2b7 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -388,13 +388,14 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	struct rxrpc_call *call;
 	struct rxrpc_sock *rx = rxrpc_sk(sock->sk);
 	struct list_head *l;
+	unsigned int call_debug_id = 0;
 	size_t copied = 0;
 	long timeo;
 	int ret;
 
 	DEFINE_WAIT(wait);
 
-	trace_rxrpc_recvmsg(NULL, rxrpc_recvmsg_enter, 0);
+	trace_rxrpc_recvmsg(0, rxrpc_recvmsg_enter, 0);
 
 	if (flags & (MSG_OOB | MSG_TRUNC))
 		return -EOPNOTSUPP;
@@ -431,7 +432,7 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		if (list_empty(&rx->recvmsg_q)) {
 			if (signal_pending(current))
 				goto wait_interrupted;
-			trace_rxrpc_recvmsg(NULL, rxrpc_recvmsg_wait, 0);
+			trace_rxrpc_recvmsg(0, rxrpc_recvmsg_wait, 0);
 			timeo = schedule_timeout(timeo);
 		}
 		finish_wait(sk_sleep(&rx->sk), &wait);
@@ -450,7 +451,8 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		rxrpc_get_call(call, rxrpc_call_get_recvmsg);
 	write_unlock(&rx->recvmsg_lock);
 
-	trace_rxrpc_recvmsg(call, rxrpc_recvmsg_dequeue, 0);
+	call_debug_id = call->debug_id;
+	trace_rxrpc_recvmsg(call_debug_id, rxrpc_recvmsg_dequeue, 0);
 
 	/* We're going to drop the socket lock, so we need to lock the call
 	 * against interference by sendmsg.
@@ -531,7 +533,7 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 error_unlock_call:
 	mutex_unlock(&call->user_mutex);
 	rxrpc_put_call(call, rxrpc_call_put_recvmsg);
-	trace_rxrpc_recvmsg(call, rxrpc_recvmsg_return, ret);
+	trace_rxrpc_recvmsg(call_debug_id, rxrpc_recvmsg_return, ret);
 	return ret;
 
 error_requeue_call:
@@ -539,14 +541,14 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		write_lock(&rx->recvmsg_lock);
 		list_add(&call->recvmsg_link, &rx->recvmsg_q);
 		write_unlock(&rx->recvmsg_lock);
-		trace_rxrpc_recvmsg(call, rxrpc_recvmsg_requeue, 0);
+		trace_rxrpc_recvmsg(call_debug_id, rxrpc_recvmsg_requeue, 0);
 	} else {
 		rxrpc_put_call(call, rxrpc_call_put_recvmsg);
 	}
 error_no_call:
 	release_sock(&rx->sk);
 error_trace:
-	trace_rxrpc_recvmsg(call, rxrpc_recvmsg_return, ret);
+	trace_rxrpc_recvmsg(call_debug_id, rxrpc_recvmsg_return, ret);
 	return ret;
 
 wait_interrupted:


