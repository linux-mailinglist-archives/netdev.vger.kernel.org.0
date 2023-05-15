Return-Path: <netdev+bounces-2722-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C99B7034CE
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 18:52:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 43F272810C6
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 16:52:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 555D4FBF2;
	Mon, 15 May 2023 16:52:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3CAFBF0;
	Mon, 15 May 2023 16:52:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7230BC433EF;
	Mon, 15 May 2023 16:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169547;
	bh=dyvVhBldc2lQ5+fBJ7yXqpacp8JRUXVrN4hOOR0qruQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tbX0ru5nECvLVC0Vs3DEbjJGfDdX8qfL5/kSojuLI0RfgcQQdl1RFwnp/Ez8AK0U8
	 jbzOFaaUJQEd1yfMQYyiShsOC+NYtmJgHu2KoROl27+ogwixTKMV7wBcL4NC/Yw10F
	 YxEfV1idToHVNeI0PaIJj3Ow/z7dJ6PsElLa3wbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Dionne <marc.dionne@auristor.com>,
	David Howells <dhowells@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-afs@lists.infradead.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 053/246] rxrpc: Fix timeout of a call that hasnt yet been granted a channel
Date: Mon, 15 May 2023 18:24:25 +0200
Message-Id: <20230515161724.172164116@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit db099c625b13a74d462521a46d98a8ce5b53af5d ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
index 432cb4b239614..81815724db6c9 100644
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
index ad8523d0d0386..68ae91d21b578 100644
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
index 7817e2b860e5e..6862e3dde364b 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -334,7 +334,9 @@ void afs_make_call(struct afs_addr_cursor *ac, struct afs_call *call, gfp_t gfp)
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
@@ -349,10 +351,6 @@ void afs_make_call(struct afs_addr_cursor *ac, struct afs_call *call, gfp_t gfp)
 	}
 
 	call->rxcall = rxcall;
-
-	if (call->max_lifespan)
-		rxrpc_kernel_set_max_life(call->net->socket, rxcall,
-					  call->max_lifespan);
 	call->issue_time = ktime_get_real();
 
 	/* send the request */
diff --git a/include/net/af_rxrpc.h b/include/net/af_rxrpc.h
index ba717eac0229a..73644bd42a3f9 100644
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
index 102f5cbff91a3..a6f0d29f35ef9 100644
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
index 67b0a894162d7..5d44dc08f66d0 100644
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
index e9f1f49d18c2a..fecbc73054bc2 100644
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
index c1b074c17b33e..8e0b94714e849 100644
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
-- 
2.39.2




