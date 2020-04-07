Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3631A02FB
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 02:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbgDGACL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 20:02:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727905AbgDGACJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 20:02:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB54F2078C;
        Tue,  7 Apr 2020 00:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586217728;
        bh=LM4Kp5c4W90eubqJLT7gzTOrQV+pRqtley/fcFMFThk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P360R3sHFCA9+4PTKNESFxRAtgXbpSaz5S4zVPTyRQWFBv5HtflEgaehlGn0DwLMW
         oMN8g5FUIxEWhe1PPgEvG56yOJlJ6v/m5ve7793P1PAJ7Y+ODUgB7urYnAiHtDL0hI
         VY3YRSWGRNeOSAmoC+QLV7zuovy/0a4uNyWmV9X8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 13/32] rxrpc: Fix call interruptibility handling
Date:   Mon,  6 Apr 2020 20:01:31 -0400
Message-Id: <20200407000151.16768-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200407000151.16768-1-sashal@kernel.org>
References: <20200407000151.16768-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit e138aa7d3271ac1b0690ae2c9b04d51468dce1d6 ]

Fix the interruptibility of kernel-initiated client calls so that they're
either only interruptible when they're waiting for a call slot to come
available or they're not interruptible at all.  Either way, they're not
interruptible during transmission.

This should help prevent StoreData calls from being interrupted when
writeback is in progress.  It doesn't, however, handle interruption during
the receive phase.

Userspace-initiated calls are still interruptable.  After the signal has
been handled, sendmsg() will return the amount of data copied out of the
buffer and userspace can perform another sendmsg() call to continue
transmission.

Fixes: bc5e3a546d55 ("rxrpc: Use MSG_WAITALL to tell sendmsg() to temporarily ignore signals")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/rxrpc.c          |  3 ++-
 include/net/af_rxrpc.h  |  8 +++++++-
 net/rxrpc/af_rxrpc.c    |  4 ++--
 net/rxrpc/ar-internal.h |  4 ++--
 net/rxrpc/call_object.c |  3 +--
 net/rxrpc/conn_client.c | 13 +++++++++---
 net/rxrpc/sendmsg.c     | 44 +++++++++++++++++++++++++++++++++--------
 7 files changed, 60 insertions(+), 19 deletions(-)

diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index ef1d09f8920bd..52aa90fb4fbd9 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -414,7 +414,8 @@ void afs_make_call(struct afs_addr_cursor *ac, struct afs_call *call, gfp_t gfp)
 					  afs_wake_up_async_call :
 					  afs_wake_up_call_waiter),
 					 call->upgrade,
-					 call->intr,
+					 (call->intr ? RXRPC_PREINTERRUPTIBLE :
+					  RXRPC_UNINTERRUPTIBLE),
 					 call->debug_id);
 	if (IS_ERR(rxcall)) {
 		ret = PTR_ERR(rxcall);
diff --git a/include/net/af_rxrpc.h b/include/net/af_rxrpc.h
index 299240df79e4a..04e97bab6f28b 100644
--- a/include/net/af_rxrpc.h
+++ b/include/net/af_rxrpc.h
@@ -16,6 +16,12 @@ struct sock;
 struct socket;
 struct rxrpc_call;
 
+enum rxrpc_interruptibility {
+	RXRPC_INTERRUPTIBLE,	/* Call is interruptible */
+	RXRPC_PREINTERRUPTIBLE,	/* Call can be cancelled whilst waiting for a slot */
+	RXRPC_UNINTERRUPTIBLE,	/* Call should not be interruptible at all */
+};
+
 /*
  * Debug ID counter for tracing.
  */
@@ -41,7 +47,7 @@ struct rxrpc_call *rxrpc_kernel_begin_call(struct socket *,
 					   gfp_t,
 					   rxrpc_notify_rx_t,
 					   bool,
-					   bool,
+					   enum rxrpc_interruptibility,
 					   unsigned int);
 int rxrpc_kernel_send_data(struct socket *, struct rxrpc_call *,
 			   struct msghdr *, size_t,
diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index a293238fe1e7e..2921fc2767134 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -285,7 +285,7 @@ struct rxrpc_call *rxrpc_kernel_begin_call(struct socket *sock,
 					   gfp_t gfp,
 					   rxrpc_notify_rx_t notify_rx,
 					   bool upgrade,
-					   bool intr,
+					   enum rxrpc_interruptibility interruptibility,
 					   unsigned int debug_id)
 {
 	struct rxrpc_conn_parameters cp;
@@ -310,7 +310,7 @@ struct rxrpc_call *rxrpc_kernel_begin_call(struct socket *sock,
 	memset(&p, 0, sizeof(p));
 	p.user_call_ID = user_call_ID;
 	p.tx_total_len = tx_total_len;
-	p.intr = intr;
+	p.interruptibility = interruptibility;
 
 	memset(&cp, 0, sizeof(cp));
 	cp.local		= rx->local;
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 394d18857979a..3eb1ab40ca5cb 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -489,7 +489,6 @@ enum rxrpc_call_flag {
 	RXRPC_CALL_BEGAN_RX_TIMER,	/* We began the expect_rx_by timer */
 	RXRPC_CALL_RX_HEARD,		/* The peer responded at least once to this call */
 	RXRPC_CALL_RX_UNDERRUN,		/* Got data underrun */
-	RXRPC_CALL_IS_INTR,		/* The call is interruptible */
 	RXRPC_CALL_DISCONNECTED,	/* The call has been disconnected */
 };
 
@@ -598,6 +597,7 @@ struct rxrpc_call {
 	atomic_t		usage;
 	u16			service_id;	/* service ID */
 	u8			security_ix;	/* Security type */
+	enum rxrpc_interruptibility interruptibility; /* At what point call may be interrupted */
 	u32			call_id;	/* call ID on connection  */
 	u32			cid;		/* connection ID plus channel index */
 	int			debug_id;	/* debug ID for printks */
@@ -720,7 +720,7 @@ struct rxrpc_call_params {
 		u32		normal;		/* Max time since last call packet (msec) */
 	} timeouts;
 	u8			nr_timeouts;	/* Number of timeouts specified */
-	bool			intr;		/* The call is interruptible */
+	enum rxrpc_interruptibility interruptibility; /* How is interruptible is the call? */
 };
 
 struct rxrpc_send_params {
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index c9f34b0a11df4..f07970207b544 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -237,8 +237,7 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc_sock *rx,
 		return call;
 	}
 
-	if (p->intr)
-		__set_bit(RXRPC_CALL_IS_INTR, &call->flags);
+	call->interruptibility = p->interruptibility;
 	call->tx_total_len = p->tx_total_len;
 	trace_rxrpc_call(call->debug_id, rxrpc_call_new_client,
 			 atomic_read(&call->usage),
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index ea7d4c21f8893..f2a1a5dbb5a7b 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -655,13 +655,20 @@ static int rxrpc_wait_for_channel(struct rxrpc_call *call, gfp_t gfp)
 
 		add_wait_queue_exclusive(&call->waitq, &myself);
 		for (;;) {
-			if (test_bit(RXRPC_CALL_IS_INTR, &call->flags))
+			switch (call->interruptibility) {
+			case RXRPC_INTERRUPTIBLE:
+			case RXRPC_PREINTERRUPTIBLE:
 				set_current_state(TASK_INTERRUPTIBLE);
-			else
+				break;
+			case RXRPC_UNINTERRUPTIBLE:
+			default:
 				set_current_state(TASK_UNINTERRUPTIBLE);
+				break;
+			}
 			if (call->call_id)
 				break;
-			if (test_bit(RXRPC_CALL_IS_INTR, &call->flags) &&
+			if ((call->interruptibility == RXRPC_INTERRUPTIBLE ||
+			     call->interruptibility == RXRPC_PREINTERRUPTIBLE) &&
 			    signal_pending(current)) {
 				ret = -ERESTARTSYS;
 				break;
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index a13051d380973..1eccfb92c9e15 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -62,7 +62,7 @@ static int rxrpc_wait_for_tx_window_intr(struct rxrpc_sock *rx,
  * Wait for space to appear in the Tx queue uninterruptibly, but with
  * a timeout of 2*RTT if no progress was made and a signal occurred.
  */
-static int rxrpc_wait_for_tx_window_nonintr(struct rxrpc_sock *rx,
+static int rxrpc_wait_for_tx_window_waitall(struct rxrpc_sock *rx,
 					    struct rxrpc_call *call)
 {
 	rxrpc_seq_t tx_start, tx_win;
@@ -87,8 +87,7 @@ static int rxrpc_wait_for_tx_window_nonintr(struct rxrpc_sock *rx,
 		if (call->state >= RXRPC_CALL_COMPLETE)
 			return call->error;
 
-		if (test_bit(RXRPC_CALL_IS_INTR, &call->flags) &&
-		    timeout == 0 &&
+		if (timeout == 0 &&
 		    tx_win == tx_start && signal_pending(current))
 			return -EINTR;
 
@@ -102,6 +101,26 @@ static int rxrpc_wait_for_tx_window_nonintr(struct rxrpc_sock *rx,
 	}
 }
 
+/*
+ * Wait for space to appear in the Tx queue uninterruptibly.
+ */
+static int rxrpc_wait_for_tx_window_nonintr(struct rxrpc_sock *rx,
+					    struct rxrpc_call *call,
+					    long *timeo)
+{
+	for (;;) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		if (rxrpc_check_tx_space(call, NULL))
+			return 0;
+
+		if (call->state >= RXRPC_CALL_COMPLETE)
+			return call->error;
+
+		trace_rxrpc_transmit(call, rxrpc_transmit_wait);
+		*timeo = schedule_timeout(*timeo);
+	}
+}
+
 /*
  * wait for space to appear in the transmit/ACK window
  * - caller holds the socket locked
@@ -119,10 +138,19 @@ static int rxrpc_wait_for_tx_window(struct rxrpc_sock *rx,
 
 	add_wait_queue(&call->waitq, &myself);
 
-	if (waitall)
-		ret = rxrpc_wait_for_tx_window_nonintr(rx, call);
-	else
-		ret = rxrpc_wait_for_tx_window_intr(rx, call, timeo);
+	switch (call->interruptibility) {
+	case RXRPC_INTERRUPTIBLE:
+		if (waitall)
+			ret = rxrpc_wait_for_tx_window_waitall(rx, call);
+		else
+			ret = rxrpc_wait_for_tx_window_intr(rx, call, timeo);
+		break;
+	case RXRPC_PREINTERRUPTIBLE:
+	case RXRPC_UNINTERRUPTIBLE:
+	default:
+		ret = rxrpc_wait_for_tx_window_nonintr(rx, call, timeo);
+		break;
+	}
 
 	remove_wait_queue(&call->waitq, &myself);
 	set_current_state(TASK_RUNNING);
@@ -628,7 +656,7 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msghdr *msg, size_t len)
 		.call.tx_total_len	= -1,
 		.call.user_call_ID	= 0,
 		.call.nr_timeouts	= 0,
-		.call.intr		= true,
+		.call.interruptibility	= RXRPC_INTERRUPTIBLE,
 		.abort_code		= 0,
 		.command		= RXRPC_CMD_SEND_DATA,
 		.exclusive		= false,
-- 
2.20.1

