Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B186726216A
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 22:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730257AbgIHUvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 16:51:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52127 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730212AbgIHUvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 16:51:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599598264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vVizqOXb8au2Xl7t+2qm3WCsYZlRCbMKJLGeqCAM8HM=;
        b=AMd405IOgoS6Lbr/sCA7O9KWSzjsttyfPJSO8h7aPIB89VEYxHTGy2o7jRTtVbzfKuEtzQ
        1zxkQtn2YdZvStY4SOc05IZMehZ24oilUBt1igWzNMU6V+USr4GUL/z4ZJ2t5yDv8ruws8
        HFLB1rcBXO+FoS7FP3PyJN2Ai8h01sU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-f7TcAJLMNo-0CIn7fpDoAw-1; Tue, 08 Sep 2020 16:51:00 -0400
X-MC-Unique: f7TcAJLMNo-0CIn7fpDoAw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BAB246408A;
        Tue,  8 Sep 2020 20:50:59 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-113-6.rdu2.redhat.com [10.10.113.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C812C60C0F;
        Tue,  8 Sep 2020 20:50:58 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 1/3] rxrpc: Impose a maximum number of client calls
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 08 Sep 2020 21:50:58 +0100
Message-ID: <159959825801.645007.1776603172846633618.stgit@warthog.procyon.org.uk>
In-Reply-To: <159959825107.645007.502549394334535916.stgit@warthog.procyon.org.uk>
References: <159959825107.645007.502549394334535916.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Impose a maximum on the number of client rxrpc calls that are allowed
simultaneously.  This will be in lieu of a maximum number of client
connections as this is easier to administed as, unlike connections, calls
aren't reusable (to be changed in a subsequent patch)..

This doesn't affect the limits on service calls and connections.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/af_rxrpc.c    |    7 ++++---
 net/rxrpc/ar-internal.h |    2 ++
 net/rxrpc/call_object.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 49 insertions(+), 3 deletions(-)

diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index 186c8a889b16..0a2f4817ec6c 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -308,9 +308,10 @@ struct rxrpc_call *rxrpc_kernel_begin_call(struct socket *sock,
 		key = NULL; /* a no-security key */
 
 	memset(&p, 0, sizeof(p));
-	p.user_call_ID = user_call_ID;
-	p.tx_total_len = tx_total_len;
-	p.interruptibility = interruptibility;
+	p.user_call_ID		= user_call_ID;
+	p.tx_total_len		= tx_total_len;
+	p.interruptibility	= interruptibility;
+	p.kernel		= true;
 
 	memset(&cp, 0, sizeof(cp));
 	cp.local		= rx->local;
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 884cff7bb169..de84198b3285 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -493,6 +493,7 @@ enum rxrpc_call_flag {
 	RXRPC_CALL_RX_HEARD,		/* The peer responded at least once to this call */
 	RXRPC_CALL_RX_UNDERRUN,		/* Got data underrun */
 	RXRPC_CALL_DISCONNECTED,	/* The call has been disconnected */
+	RXRPC_CALL_KERNEL,		/* The call was made by the kernel */
 };
 
 /*
@@ -727,6 +728,7 @@ struct rxrpc_call_params {
 		u32		normal;		/* Max time since last call packet (msec) */
 	} timeouts;
 	u8			nr_timeouts;	/* Number of timeouts specified */
+	bool			kernel;		/* T if kernel is making the call */
 	enum rxrpc_interruptibility interruptibility; /* How is interruptible is the call? */
 };
 
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index a40fae013942..c8015c76a81c 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -41,6 +41,11 @@ const char *const rxrpc_call_completions[NR__RXRPC_CALL_COMPLETIONS] = {
 
 struct kmem_cache *rxrpc_call_jar;
 
+static struct semaphore rxrpc_call_limiter =
+	__SEMAPHORE_INITIALIZER(rxrpc_call_limiter, 1000);
+static struct semaphore rxrpc_kernel_call_limiter =
+	__SEMAPHORE_INITIALIZER(rxrpc_kernel_call_limiter, 1000);
+
 static void rxrpc_call_timer_expired(struct timer_list *t)
 {
 	struct rxrpc_call *call = from_timer(call, t, timer);
@@ -209,6 +214,34 @@ static void rxrpc_start_call_timer(struct rxrpc_call *call)
 	call->timer.expires = now;
 }
 
+/*
+ * Wait for a call slot to become available.
+ */
+static struct semaphore *rxrpc_get_call_slot(struct rxrpc_call_params *p, gfp_t gfp)
+{
+	struct semaphore *limiter = &rxrpc_call_limiter;
+
+	if (p->kernel)
+		limiter = &rxrpc_kernel_call_limiter;
+	if (p->interruptibility == RXRPC_UNINTERRUPTIBLE) {
+		down(limiter);
+		return limiter;
+	}
+	return down_interruptible(limiter) < 0 ? NULL : limiter;
+}
+
+/*
+ * Release a call slot.
+ */
+static void rxrpc_put_call_slot(struct rxrpc_call *call)
+{
+	struct semaphore *limiter = &rxrpc_call_limiter;
+
+	if (test_bit(RXRPC_CALL_KERNEL, &call->flags))
+		limiter = &rxrpc_kernel_call_limiter;
+	up(limiter);
+}
+
 /*
  * Set up a call for the given parameters.
  * - Called with the socket lock held, which it must release.
@@ -225,15 +258,21 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 {
 	struct rxrpc_call *call, *xcall;
 	struct rxrpc_net *rxnet;
+	struct semaphore *limiter;
 	struct rb_node *parent, **pp;
 	const void *here = __builtin_return_address(0);
 	int ret;
 
 	_enter("%p,%lx", rx, p->user_call_ID);
 
+	limiter = rxrpc_get_call_slot(p, gfp);
+	if (!limiter)
+		return ERR_PTR(-ERESTARTSYS);
+
 	call = rxrpc_alloc_client_call(rx, srx, gfp, debug_id);
 	if (IS_ERR(call)) {
 		release_sock(&rx->sk);
+		up(limiter);
 		_leave(" = %ld", PTR_ERR(call));
 		return call;
 	}
@@ -243,6 +282,8 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 	trace_rxrpc_call(call->debug_id, rxrpc_call_new_client,
 			 atomic_read(&call->usage),
 			 here, (const void *)p->user_call_ID);
+	if (p->kernel)
+		__set_bit(RXRPC_CALL_KERNEL, &call->flags);
 
 	/* We need to protect a partially set up call against the user as we
 	 * will be acting outside the socket lock.
@@ -471,6 +512,8 @@ void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
 		BUG();
 	spin_unlock_bh(&call->lock);
 
+	rxrpc_put_call_slot(call);
+
 	del_timer_sync(&call->timer);
 
 	/* Make sure we don't get any more notifications */


