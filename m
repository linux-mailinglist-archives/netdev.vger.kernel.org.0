Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB596F1F57
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 22:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346628AbjD1U30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 16:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346630AbjD1U3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 16:29:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18691BC3
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 13:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682713690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=41KUBQaFistzCqjFah0QVDYkKS+WNIdy9b94n5s+HCs=;
        b=Dxc41cHXZOObMkJktaTgut8jHHyRTieSo4o8Rw9OXWoCILmMJ54/tLDQWU4tSvEWc10gos
        NPW3V4rOUbKWQhxL3TcPYmDRYWBYNnkrkqlDdAtteG1w71jubjggw9rOb6sIwBYM4+UXfC
        WwDB5shBAgT9gX9LCXg59ioGOx6tjtk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-158-hO9dkLOQO523hDB9GezRGw-1; Fri, 28 Apr 2023 16:28:07 -0400
X-MC-Unique: hO9dkLOQO523hDB9GezRGw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AFD4FA0F385;
        Fri, 28 Apr 2023 20:28:06 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.42.28.174])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D9002166B4F;
        Fri, 28 Apr 2023 20:28:05 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 3/3] rxrpc: Fix timeout of a call that hasn't yet been granted a channel
Date:   Fri, 28 Apr 2023 21:27:56 +0100
Message-Id: <20230428202756.1186269-4-dhowells@redhat.com>
In-Reply-To: <20230428202756.1186269-1-dhowells@redhat.com>
References: <20230428202756.1186269-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

afs_make_call() calls rxrpc_kernel_begin_call() to begin a call (which may
get stalled in the background waiting for a connection to become
available); it then calls rxrpc_kernel_set_max_life() to set the timeouts -
but that starts the call timer so the call timer might then expire before
we get a connection assigned - leading to the following oops if the call
stalled:

	BUG: kernel NULL pointer dereference, address: 0000000000000000
	...
	CPU: 1 PID: 5111 Comm: krxrpcio/0 Not tainted 6.3.0-rc7-build3+ #701
	RIP: 0010:rxrpc_alloc_txbuf+0xc0/0x157
	...
	Call Trace:
	 <TASK>
	 rxrpc_send_ACK+0x50/0x13b
	 rxrpc_input_call_event+0x16a/0x67d
	 rxrpc_io_thread+0x1b6/0x45f
	 ? _raw_spin_unlock_irqrestore+0x1f/0x35
	 ? rxrpc_input_packet+0x519/0x519
	 kthread+0xe7/0xef
	 ? kthread_complete_and_exit+0x1b/0x1b
	 ret_from_fork+0x22/0x30

Fix this by noting the timeouts in struct rxrpc_call when the call is
created.  The timer will be started when the first packet is transmitted.

It shouldn't be possible to trigger this directly from userspace through
AF_RXRPC as sendmsg() will return EBUSY if the call is in the
waiting-for-conn state if it dropped out of the wait due to a signal.

Fixes: 9d35d880e0e4 ("rxrpc: Move client call connection to the I/O thread")
Reported-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: linux-afs@lists.infradead.org
cc: netdev@vger.kernel.org
cc: linux-kernel@vger.kernel.org
---
 fs/afs/afs.h            |  4 ++--
 fs/afs/internal.h       |  2 +-
 fs/afs/rxrpc.c          |  8 +++-----
 include/net/af_rxrpc.h  | 21 +++++++++++----------
 net/rxrpc/af_rxrpc.c    |  3 +++
 net/rxrpc/ar-internal.h |  1 +
 net/rxrpc/call_object.c |  9 ++++++++-
 net/rxrpc/sendmsg.c     |  1 +
 8 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/fs/afs/afs.h b/fs/afs/afs.h
index 432cb4b23961..81815724db6c 100644
--- a/fs/afs/afs.h
+++ b/fs/afs/afs.h
@@ -19,8 +19,8 @@
 #define AFSPATHMAX		1024	/* Maximum length of a pathname plus NUL */
 #define AFSOPAQUEMAX		1024	/* Maximum length of an opaque field */
 
-#define AFS_VL_MAX_LIFESPAN	(120 * HZ)
-#define AFS_PROBE_MAX_LIFESPAN	(30 * HZ)
+#define AFS_VL_MAX_LIFESPAN	120
+#define AFS_PROBE_MAX_LIFESPAN	30
 
 typedef u64			afs_volid_t;
 typedef u64			afs_vnodeid_t;
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index ad8523d0d038..68ae91d21b57 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -128,7 +128,7 @@ struct afs_call {
 	spinlock_t		state_lock;
 	int			error;		/* error code */
 	u32			abort_code;	/* Remote abort ID or 0 */
-	unsigned int		max_lifespan;	/* Maximum lifespan to set if not 0 */
+	unsigned int		max_lifespan;	/* Maximum lifespan in secs to set if not 0 */
 	unsigned		request_size;	/* size of request data */
 	unsigned		reply_max;	/* maximum size of reply */
 	unsigned		count2;		/* count used in unmarshalling */
diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index e08b850c3e6d..ed1644e7683f 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -335,7 +335,9 @@ void afs_make_call(struct afs_addr_cursor *ac, struct afs_call *call, gfp_t gfp)
 	/* create a call */
 	rxcall = rxrpc_kernel_begin_call(call->net->socket, srx, call->key,
 					 (unsigned long)call,
-					 tx_total_len, gfp,
+					 tx_total_len,
+					 call->max_lifespan,
+					 gfp,
 					 (call->async ?
 					  afs_wake_up_async_call :
 					  afs_wake_up_call_waiter),
@@ -350,10 +352,6 @@ void afs_make_call(struct afs_addr_cursor *ac, struct afs_call *call, gfp_t gfp)
 	}
 
 	call->rxcall = rxcall;
-
-	if (call->max_lifespan)
-		rxrpc_kernel_set_max_life(call->net->socket, rxcall,
-					  call->max_lifespan);
 	call->issue_time = ktime_get_real();
 
 	/* send the request */
diff --git a/include/net/af_rxrpc.h b/include/net/af_rxrpc.h
index 01a35e113ab9..5531dd08061e 100644
--- a/include/net/af_rxrpc.h
+++ b/include/net/af_rxrpc.h
@@ -40,16 +40,17 @@ typedef void (*rxrpc_user_attach_call_t)(struct rxrpc_call *, unsigned long);
 void rxrpc_kernel_new_call_notification(struct socket *,
 					rxrpc_notify_new_call_t,
 					rxrpc_discard_new_call_t);
-struct rxrpc_call *rxrpc_kernel_begin_call(struct socket *,
-					   struct sockaddr_rxrpc *,
-					   struct key *,
-					   unsigned long,
-					   s64,
-					   gfp_t,
-					   rxrpc_notify_rx_t,
-					   bool,
-					   enum rxrpc_interruptibility,
-					   unsigned int);
+struct rxrpc_call *rxrpc_kernel_begin_call(struct socket *sock,
+					   struct sockaddr_rxrpc *srx,
+					   struct key *key,
+					   unsigned long user_call_ID,
+					   s64 tx_total_len,
+					   u32 hard_timeout,
+					   gfp_t gfp,
+					   rxrpc_notify_rx_t notify_rx,
+					   bool upgrade,
+					   enum rxrpc_interruptibility interruptibility,
+					   unsigned int debug_id);
 int rxrpc_kernel_send_data(struct socket *, struct rxrpc_call *,
 			   struct msghdr *, size_t,
 			   rxrpc_notify_end_tx_t);
diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index c32b164206f9..31f738d65f1c 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -265,6 +265,7 @@ static int rxrpc_listen(struct socket *sock, int backlog)
  * @key: The security context to use (defaults to socket setting)
  * @user_call_ID: The ID to use
  * @tx_total_len: Total length of data to transmit during the call (or -1)
+ * @hard_timeout: The maximum lifespan of the call in sec
  * @gfp: The allocation constraints
  * @notify_rx: Where to send notifications instead of socket queue
  * @upgrade: Request service upgrade for call
@@ -283,6 +284,7 @@ struct rxrpc_call *rxrpc_kernel_begin_call(struct socket *sock,
 					   struct key *key,
 					   unsigned long user_call_ID,
 					   s64 tx_total_len,
+					   u32 hard_timeout,
 					   gfp_t gfp,
 					   rxrpc_notify_rx_t notify_rx,
 					   bool upgrade,
@@ -313,6 +315,7 @@ struct rxrpc_call *rxrpc_kernel_begin_call(struct socket *sock,
 	p.tx_total_len		= tx_total_len;
 	p.interruptibility	= interruptibility;
 	p.kernel		= true;
+	p.timeouts.hard		= hard_timeout;
 
 	memset(&cp, 0, sizeof(cp));
 	cp.local		= rx->local;
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 67b0a894162d..5d44dc08f66d 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -616,6 +616,7 @@ struct rxrpc_call {
 	unsigned long		expect_term_by;	/* When we expect call termination by */
 	u32			next_rx_timo;	/* Timeout for next Rx packet (jif) */
 	u32			next_req_timo;	/* Timeout for next Rx request packet (jif) */
+	u32			hard_timo;	/* Maximum lifetime or 0 (jif) */
 	struct timer_list	timer;		/* Combined event timer */
 	struct work_struct	destroyer;	/* In-process-context destroyer */
 	rxrpc_notify_rx_t	notify_rx;	/* kernel service Rx notification function */
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index e9f1f49d18c2..fecbc73054bc 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -226,6 +226,13 @@ static struct rxrpc_call *rxrpc_alloc_client_call(struct rxrpc_sock *rx,
 	if (cp->exclusive)
 		__set_bit(RXRPC_CALL_EXCLUSIVE, &call->flags);
 
+	if (p->timeouts.normal)
+		call->next_rx_timo = min(msecs_to_jiffies(p->timeouts.normal), 1UL);
+	if (p->timeouts.idle)
+		call->next_req_timo = min(msecs_to_jiffies(p->timeouts.idle), 1UL);
+	if (p->timeouts.hard)
+		call->hard_timo = p->timeouts.hard * HZ;
+
 	ret = rxrpc_init_client_call_security(call);
 	if (ret < 0) {
 		rxrpc_prefail_call(call, RXRPC_CALL_LOCAL_ERROR, ret);
@@ -257,7 +264,7 @@ void rxrpc_start_call_timer(struct rxrpc_call *call)
 	call->keepalive_at = j;
 	call->expect_rx_by = j;
 	call->expect_req_by = j;
-	call->expect_term_by = j;
+	call->expect_term_by = j + call->hard_timo;
 	call->timer.expires = now;
 }
 
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index c1b074c17b33..8e0b94714e84 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -651,6 +651,7 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
 		if (IS_ERR(call))
 			return PTR_ERR(call);
 		/* ... and we have the call lock. */
+		p.call.nr_timeouts = 0;
 		ret = 0;
 		if (rxrpc_call_is_complete(call))
 			goto out_put_unlock;

