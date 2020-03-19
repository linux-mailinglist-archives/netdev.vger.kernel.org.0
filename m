Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2419D18B2A9
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 12:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbgCSLxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 07:53:50 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:36663 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727286AbgCSLxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 07:53:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584618828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tnl0I/QZRF5J593N64Rz7N2upSTHKohl6l1x9AWaMJA=;
        b=UAMwBz1xLTwiulzVx1RFcsIFrLuYIkqLlEoTBqUYpd+6USnEdixppMfy/HNj7Pj1HN1UaB
        Qx4KLFSIZOiUmq+rthjET20PjsvQj+CoAFGezS+Emzstk4ND+djYRzqoJe52vkRAHwd1Kf
        +TAFMTiKasfDsopD42U0xIF8T2w8CUk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-xldVPSGuPZql0mvwTr4BSg-1; Thu, 19 Mar 2020 07:53:46 -0400
X-MC-Unique: xldVPSGuPZql0mvwTr4BSg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B06D9801E7A;
        Thu, 19 Mar 2020 11:53:45 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-113-126.rdu2.redhat.com [10.10.113.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BDEA55C28E;
        Thu, 19 Mar 2020 11:53:44 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 2/6] rxrpc: Fix call interruptibility handling
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 19 Mar 2020 11:53:44 +0000
Message-ID: <158461882403.3094720.7644918318018856729.stgit@warthog.procyon.org.uk>
In-Reply-To: <158461880968.3094720.5019510060910604912.stgit@warthog.procyon.org.uk>
References: <158461880968.3094720.5019510060910604912.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---

 fs/afs/rxrpc.c          |    3 ++-
 include/net/af_rxrpc.h  |    8 +++++++-
 net/rxrpc/af_rxrpc.c    |    4 ++--
 net/rxrpc/ar-internal.h |    4 ++--
 net/rxrpc/call_object.c |    3 +--
 net/rxrpc/conn_client.c |   13 ++++++++++---
 net/rxrpc/sendmsg.c     |   44 ++++++++++++++++++++++++++++++++++++--------
 7 files changed, 60 insertions(+), 19 deletions(-)

diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index 58d396592250..4c28712bb7f6 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -413,7 +413,8 @@ void afs_make_call(struct afs_addr_cursor *ac, struct afs_call *call, gfp_t gfp)
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
index 1abae3c340a5..8e547b4d88c8 100644
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
index fe42f986cd94..7603cf811f75 100644
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
index 7d730c438404..1f72f43b082d 100644
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
@@ -721,7 +721,7 @@ struct rxrpc_call_params {
 		u32		normal;		/* Max time since last call packet (msec) */
 	} timeouts;
 	u8			nr_timeouts;	/* Number of timeouts specified */
-	bool			intr;		/* The call is interruptible */
+	enum rxrpc_interruptibility interruptibility; /* How is interruptible is the call? */
 };
 
 struct rxrpc_send_params {
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index c9f34b0a11df..f07970207b54 100644
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
index ea7d4c21f889..f2a1a5dbb5a7 100644
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
index a13051d38097..1eccfb92c9e1 100644
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


