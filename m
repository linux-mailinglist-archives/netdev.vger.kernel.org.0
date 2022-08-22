Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B28ED59C354
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 17:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236906AbiHVPqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 11:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236754AbiHVPqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 11:46:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D51D11F
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 08:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661183154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jcdTIiPpDWEXrCgBvbIca+zo9nIGWeS72vZ/R3cAAFU=;
        b=WNJmJhe+rUFMip2WqkOyHq/CFV1kcT/O0X4J5nFnaMnHYWrqpyVaPBKhCEavUs30i51v5P
        H+Ffh6vh0cI+1ydX2QKxjtY+pm6cPxAsiUrPiE2GhWmcy1m4PYUEdKIL/lBaQZVJnMCa1E
        ptLwrmNUqr98qlwCrY2650/+VNVq5Vc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-670-0EKL9HduNCeOraUl2duvYw-1; Mon, 22 Aug 2022 11:45:49 -0400
X-MC-Unique: 0EKL9HduNCeOraUl2duvYw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1BDA7382F1A0;
        Mon, 22 Aug 2022 15:45:49 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EAA77492C3B;
        Mon, 22 Aug 2022 15:45:47 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <000000000000ce327f05d537ebf7@google.com>
References: <000000000000ce327f05d537ebf7@google.com>
To:     syzbot <syzbot+7f0483225d0c94cb3441@syzkaller.appspotmail.com>
Cc:     dhowells@redhat.com, davem@davemloft.net, kuba@kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        marc.dionne@auristor.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] WARNING: bad unlock balance in rxrpc_do_sendmsg
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1959172.1661183147.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Mon, 22 Aug 2022 16:45:47 +0100
Message-ID: <1959174.1661183147@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git ma=
ster

rxrpc: Fix locking in rxrpc's sendmsg

Fix three bugs in the rxrpc's sendmsg implementation:

 (1) rxrpc_new_client_call() should release the socket lock when returning
     an error from rxrpc_get_call_slot().

 (2) rxrpc_wait_for_tx_window_intr() will return without the call mutex
     held in the event that we're interrupted by a signal whilst waiting
     for tx space on the socket or relocking the call mutex afterwards.

     Fix this by: (a) moving the unlock/lock of the call mutex up to
     rxrpc_send_data() such that the lock is not held around all of
     rxrpc_wait_for_tx_window*() and (b) indicating to higher callers
     whether we're return with the lock dropped.  Note that this means
     recvmsg() will not block on this call whilst we're waiting.

 (3) After dropping and regaining the call mutex, rxrpc_send_data() needs
     to go and recheck the state of the tx_pending buffer and the
     tx_total_len check in case we raced with another sendmsg() on the sam=
e
     call.

Thinking on this some more, it might make sense to have different locks fo=
r
sendmsg() and recvmsg().  There's probably no need to make recvmsg() wait
for sendmsg().  It does mean that recvmsg() can return MSG_EOR indicating
that a call is dead before a sendmsg() to that call returns - but that can
currently happen anyway.

Without fix (2), something like the following can be induced:

        WARNING: bad unlock balance detected!
        5.16.0-rc6-syzkaller #0 Not tainted
        -------------------------------------
        syz-executor011/3597 is trying to release lock (&call->user_mutex)=
 at:
        [<ffffffff885163a3>] rxrpc_do_sendmsg+0xc13/0x1350 net/rxrpc/sendm=
sg.c:748
        but there are no more locks to release!

        other info that might help us debug this:
        no locks held by syz-executor011/3597.
        ...
        Call Trace:
         <TASK>
         __dump_stack lib/dump_stack.c:88 [inline]
         dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
         print_unlock_imbalance_bug include/trace/events/lock.h:58 [inline=
]
         __lock_release kernel/locking/lockdep.c:5306 [inline]
         lock_release.cold+0x49/0x4e kernel/locking/lockdep.c:5657
         __mutex_unlock_slowpath+0x99/0x5e0 kernel/locking/mutex.c:900
         rxrpc_do_sendmsg+0xc13/0x1350 net/rxrpc/sendmsg.c:748
         rxrpc_sendmsg+0x420/0x630 net/rxrpc/af_rxrpc.c:561
         sock_sendmsg_nosec net/socket.c:704 [inline]
         sock_sendmsg+0xcf/0x120 net/socket.c:724
         ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
         ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
         __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
         do_syscall_x64 arch/x86/entry/common.c:50 [inline]
         do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
         entry_SYSCALL_64_after_hwframe+0x44/0xae

[Thanks to Hawkins Jiawei and Khalid Masum for their attempts to fix this]

Fixes: bc5e3a546d55 ("rxrpc: Use MSG_WAITALL to tell sendmsg() to temporar=
ily ignore signals")
Reported-by: syzbot+7f0483225d0c94cb3441@syzkaller.appspotmail.com
cc: Hawkins Jiawei <yin31149@gmail.com>
cc: Khalid Masum <khalid.masum.92@gmail.com>
cc: Dan Carpenter <dan.carpenter@oracle.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---
 net/rxrpc/call_object.c |    4 +-
 net/rxrpc/sendmsg.c     |   92 ++++++++++++++++++++++++++++--------------=
------
 2 files changed, 57 insertions(+), 39 deletions(-)

diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 84d0a4109645..6401cdf7a624 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -285,8 +285,10 @@ struct rxrpc_call *rxrpc_new_client_call(struct rxrpc=
_sock *rx,
 	_enter("%p,%lx", rx, p->user_call_ID);
 =

 	limiter =3D rxrpc_get_call_slot(p, gfp);
-	if (!limiter)
+	if (!limiter) {
+		release_sock(&rx->sk);
 		return ERR_PTR(-ERESTARTSYS);
+	}
 =

 	call =3D rxrpc_alloc_client_call(rx, srx, gfp, debug_id);
 	if (IS_ERR(call)) {
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 1d38e279e2ef..3c3a626459de 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -51,10 +51,7 @@ static int rxrpc_wait_for_tx_window_intr(struct rxrpc_s=
ock *rx,
 			return sock_intr_errno(*timeo);
 =

 		trace_rxrpc_transmit(call, rxrpc_transmit_wait);
-		mutex_unlock(&call->user_mutex);
 		*timeo =3D schedule_timeout(*timeo);
-		if (mutex_lock_interruptible(&call->user_mutex) < 0)
-			return sock_intr_errno(*timeo);
 	}
 }
 =

@@ -290,37 +287,48 @@ static int rxrpc_queue_packet(struct rxrpc_sock *rx,=
 struct rxrpc_call *call,
 static int rxrpc_send_data(struct rxrpc_sock *rx,
 			   struct rxrpc_call *call,
 			   struct msghdr *msg, size_t len,
-			   rxrpc_notify_end_tx_t notify_end_tx)
+			   rxrpc_notify_end_tx_t notify_end_tx,
+			   bool *_dropped_lock)
 {
 	struct rxrpc_skb_priv *sp;
 	struct sk_buff *skb;
 	struct sock *sk =3D &rx->sk;
+	enum rxrpc_call_state state;
 	long timeo;
-	bool more;
-	int ret, copied;
+	bool more =3D msg->msg_flags & MSG_MORE;
+	int ret, copied =3D 0;
 =

 	timeo =3D sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
 =

 	/* this should be in poll */
 	sk_clear_bit(SOCKWQ_ASYNC_NOSPACE, sk);
 =

+reload:
+	ret =3D -EPIPE;
 	if (sk->sk_shutdown & SEND_SHUTDOWN)
-		return -EPIPE;
-
-	more =3D msg->msg_flags & MSG_MORE;
-
+		goto maybe_error;
+	state =3D READ_ONCE(call->state);
+	ret =3D -ESHUTDOWN;
+	if (state >=3D RXRPC_CALL_COMPLETE)
+		goto maybe_error;
+	ret =3D -EPROTO;
+	if (state !=3D RXRPC_CALL_CLIENT_SEND_REQUEST &&
+	    state !=3D RXRPC_CALL_SERVER_ACK_REQUEST &&
+	    state !=3D RXRPC_CALL_SERVER_SEND_REPLY)
+		goto maybe_error;
+
+	ret =3D -EMSGSIZE;
 	if (call->tx_total_len !=3D -1) {
-		if (len > call->tx_total_len)
-			return -EMSGSIZE;
-		if (!more && len !=3D call->tx_total_len)
-			return -EMSGSIZE;
+		if (len - copied > call->tx_total_len)
+			goto maybe_error;
+		if (!more && len - copied !=3D call->tx_total_len)
+			goto maybe_error;
 	}
 =

 	skb =3D call->tx_pending;
 	call->tx_pending =3D NULL;
 	rxrpc_see_skb(skb, rxrpc_skb_seen);
 =

-	copied =3D 0;
 	do {
 		/* Check to see if there's a ping ACK to reply to. */
 		if (call->ackr_reason =3D=3D RXRPC_ACK_PING_RESPONSE)
@@ -331,16 +339,8 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 =

 			_debug("alloc");
 =

-			if (!rxrpc_check_tx_space(call, NULL)) {
-				ret =3D -EAGAIN;
-				if (msg->msg_flags & MSG_DONTWAIT)
-					goto maybe_error;
-				ret =3D rxrpc_wait_for_tx_window(rx, call,
-							       &timeo,
-							       msg->msg_flags & MSG_WAITALL);
-				if (ret < 0)
-					goto maybe_error;
-			}
+			if (!rxrpc_check_tx_space(call, NULL))
+				goto wait_for_space;
 =

 			/* Work out the maximum size of a packet.  Assume that
 			 * the security header is going to be in the padded
@@ -468,6 +468,27 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 efault:
 	ret =3D -EFAULT;
 	goto out;
+
+wait_for_space:
+	ret =3D -EAGAIN;
+	if (msg->msg_flags & MSG_DONTWAIT)
+		goto maybe_error;
+	mutex_unlock(&call->user_mutex);
+	*_dropped_lock =3D true;
+	ret =3D rxrpc_wait_for_tx_window(rx, call, &timeo,
+				       msg->msg_flags & MSG_WAITALL);
+	if (ret < 0)
+		goto maybe_error;
+	if (call->interruptibility =3D=3D RXRPC_INTERRUPTIBLE) {
+		if (mutex_lock_interruptible(&call->user_mutex) < 0) {
+			ret =3D sock_intr_errno(timeo);
+			goto maybe_error;
+		}
+	} else {
+		mutex_lock(&call->user_mutex);
+	}
+	*_dropped_lock =3D false;
+	goto reload;
 }
 =

 /*
@@ -629,6 +650,7 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct msg=
hdr *msg, size_t len)
 	enum rxrpc_call_state state;
 	struct rxrpc_call *call;
 	unsigned long now, j;
+	bool dropped_lock =3D false;
 	int ret;
 =

 	struct rxrpc_send_params p =3D {
@@ -737,21 +759,13 @@ int rxrpc_do_sendmsg(struct rxrpc_sock *rx, struct m=
sghdr *msg, size_t len)
 			ret =3D rxrpc_send_abort_packet(call);
 	} else if (p.command !=3D RXRPC_CMD_SEND_DATA) {
 		ret =3D -EINVAL;
-	} else if (rxrpc_is_client_call(call) &&
-		   state !=3D RXRPC_CALL_CLIENT_SEND_REQUEST) {
-		/* request phase complete for this client call */
-		ret =3D -EPROTO;
-	} else if (rxrpc_is_service_call(call) &&
-		   state !=3D RXRPC_CALL_SERVER_ACK_REQUEST &&
-		   state !=3D RXRPC_CALL_SERVER_SEND_REPLY) {
-		/* Reply phase not begun or not complete for service call. */
-		ret =3D -EPROTO;
 	} else {
-		ret =3D rxrpc_send_data(rx, call, msg, len, NULL);
+		ret =3D rxrpc_send_data(rx, call, msg, len, NULL, &dropped_lock);
 	}
 =

 out_put_unlock:
-	mutex_unlock(&call->user_mutex);
+	if (!dropped_lock)
+		mutex_unlock(&call->user_mutex);
 error_put:
 	rxrpc_put_call(call, rxrpc_call_put);
 	_leave(" =3D %d", ret);
@@ -779,6 +793,7 @@ int rxrpc_kernel_send_data(struct socket *sock, struct=
 rxrpc_call *call,
 			   struct msghdr *msg, size_t len,
 			   rxrpc_notify_end_tx_t notify_end_tx)
 {
+	bool dropped_lock =3D false;
 	int ret;
 =

 	_enter("{%d,%s},", call->debug_id, rxrpc_call_states[call->state]);
@@ -796,7 +811,7 @@ int rxrpc_kernel_send_data(struct socket *sock, struct=
 rxrpc_call *call,
 	case RXRPC_CALL_SERVER_ACK_REQUEST:
 	case RXRPC_CALL_SERVER_SEND_REPLY:
 		ret =3D rxrpc_send_data(rxrpc_sk(sock->sk), call, msg, len,
-				      notify_end_tx);
+				      notify_end_tx, &dropped_lock);
 		break;
 	case RXRPC_CALL_COMPLETE:
 		read_lock_bh(&call->state_lock);
@@ -810,7 +825,8 @@ int rxrpc_kernel_send_data(struct socket *sock, struct=
 rxrpc_call *call,
 		break;
 	}
 =

-	mutex_unlock(&call->user_mutex);
+	if (!dropped_lock)
+		mutex_unlock(&call->user_mutex);
 	_leave(" =3D %d", ret);
 	return ret;
 }

