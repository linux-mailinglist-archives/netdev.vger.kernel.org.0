Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16379151F00
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 18:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbgBDRMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 12:12:41 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:36518 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727310AbgBDRMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 12:12:41 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1iz1kd-0004md-H2; Tue, 04 Feb 2020 18:12:39 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Christoph Paasch <cpaasch@apple.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net] mptcp: fix use-after-free on tcp fallback
Date:   Tue,  4 Feb 2020 18:12:30 +0100
Message-Id: <20200204171230.618-1-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When an mptcp socket connects to a tcp peer or when a middlebox interferes
with tcp options, mptcp needs to fall back to plain tcp.
Problem is that mptcp is trying to be too clever in this case:

It attempts to close the mptcp meta sk and transparently replace it with
the (only) subflow tcp sk.

Unfortunately, this is racy -- the socket is already exposed to userspace.
Any parallel calls to send/recv/setsockopt etc. can cause use-after-free:

BUG: KASAN: use-after-free in atomic_try_cmpxchg include/asm-generic/atomic-instrumented.h:693 [inline]
CPU: 1 PID: 2083 Comm: syz-executor.1 Not tainted 5.5.0 #2
 atomic_try_cmpxchg include/asm-generic/atomic-instrumented.h:693 [inline]
 queued_spin_lock include/asm-generic/qspinlock.h:78 [inline]
 do_raw_spin_lock include/linux/spinlock.h:181 [inline]
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:136 [inline]
 _raw_spin_lock_bh+0x71/0xd0 kernel/locking/spinlock.c:175
 spin_lock_bh include/linux/spinlock.h:343 [inline]
 __lock_sock+0x105/0x190 net/core/sock.c:2414
 lock_sock_nested+0x10f/0x140 net/core/sock.c:2938
 lock_sock include/net/sock.h:1516 [inline]
 mptcp_setsockopt+0x2f/0x1f0 net/mptcp/protocol.c:800
 __sys_setsockopt+0x152/0x240 net/socket.c:2130
 __do_sys_setsockopt net/socket.c:2146 [inline]
 __se_sys_setsockopt net/socket.c:2143 [inline]
 __x64_sys_setsockopt+0xba/0x150 net/socket.c:2143
 do_syscall_64+0xb7/0x3d0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

While the use-after-free can be resolved, there is another problem:
sock->ops and sock->sk assignments are not atomic, i.e. we may get calls
into mptcp functions with sock->sk already pointing at the subflow socket,
or calls into tcp functions with a mptcp meta sk.

Remove the fallback code and call the relevant functions for the (only)
subflow in case the mptcp socket is connected to tcp peer.

Reported-by: Christoph Paasch <cpaasch@apple.com>
Diagnosed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 76 ++++----------------------------------------
 1 file changed, 6 insertions(+), 70 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 3bccee455688..353f2d16b986 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -24,58 +24,6 @@
 
 #define MPTCP_SAME_STATE TCP_MAX_STATES
 
-static void __mptcp_close(struct sock *sk, long timeout);
-
-static const struct proto_ops *tcp_proto_ops(struct sock *sk)
-{
-#if IS_ENABLED(CONFIG_MPTCP_IPV6)
-	if (sk->sk_family == AF_INET6)
-		return &inet6_stream_ops;
-#endif
-	return &inet_stream_ops;
-}
-
-/* MP_CAPABLE handshake failed, convert msk to plain tcp, replacing
- * socket->sk and stream ops and destroying msk
- * return the msk socket, as we can't access msk anymore after this function
- * completes
- * Called with msk lock held, releases such lock before returning
- */
-static struct socket *__mptcp_fallback_to_tcp(struct mptcp_sock *msk,
-					      struct sock *ssk)
-{
-	struct mptcp_subflow_context *subflow;
-	struct socket *sock;
-	struct sock *sk;
-
-	sk = (struct sock *)msk;
-	sock = sk->sk_socket;
-	subflow = mptcp_subflow_ctx(ssk);
-
-	/* detach the msk socket */
-	list_del_init(&subflow->node);
-	sock_orphan(sk);
-	sock->sk = NULL;
-
-	/* socket is now TCP */
-	lock_sock(ssk);
-	sock_graft(ssk, sock);
-	if (subflow->conn) {
-		/* We can't release the ULP data on a live socket,
-		 * restore the tcp callback
-		 */
-		mptcp_subflow_tcp_fallback(ssk, subflow);
-		sock_put(subflow->conn);
-		subflow->conn = NULL;
-	}
-	release_sock(ssk);
-	sock->ops = tcp_proto_ops(ssk);
-
-	/* destroy the left-over msk sock */
-	__mptcp_close(sk, 0);
-	return sock;
-}
-
 /* If msk has an initial subflow socket, and the MP_CAPABLE handshake has not
  * completed yet or has failed, return the subflow socket.
  * Otherwise return NULL.
@@ -93,10 +41,6 @@ static bool __mptcp_needs_tcp_fallback(const struct mptcp_sock *msk)
 	return msk->first && !sk_is_mptcp(msk->first);
 }
 
-/* if the mp_capable handshake has failed, it fallbacks msk to plain TCP,
- * releases the socket lock and returns a reference to the now TCP socket.
- * Otherwise returns NULL
- */
 static struct socket *__mptcp_tcp_fallback(struct mptcp_sock *msk)
 {
 	sock_owned_by_me((const struct sock *)msk);
@@ -105,15 +49,11 @@ static struct socket *__mptcp_tcp_fallback(struct mptcp_sock *msk)
 		return NULL;
 
 	if (msk->subflow) {
-		/* the first subflow is an active connection, discart the
-		 * paired socket
-		 */
-		msk->subflow->sk = NULL;
-		sock_release(msk->subflow);
-		msk->subflow = NULL;
+		release_sock((struct sock *)msk);
+		return msk->subflow;
 	}
 
-	return __mptcp_fallback_to_tcp(msk, msk->first);
+	return NULL;
 }
 
 static bool __mptcp_can_create_subflow(const struct mptcp_sock *msk)
@@ -640,12 +580,14 @@ static void mptcp_subflow_shutdown(struct sock *ssk, int how)
 }
 
 /* Called with msk lock held, releases such lock before returning */
-static void __mptcp_close(struct sock *sk, long timeout)
+static void mptcp_close(struct sock *sk, long timeout)
 {
 	struct mptcp_subflow_context *subflow, *tmp;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	LIST_HEAD(conn_list);
 
+	lock_sock(sk);
+
 	mptcp_token_destroy(msk->token);
 	inet_sk_state_store(sk, TCP_CLOSE);
 
@@ -662,12 +604,6 @@ static void __mptcp_close(struct sock *sk, long timeout)
 	sk_common_release(sk);
 }
 
-static void mptcp_close(struct sock *sk, long timeout)
-{
-	lock_sock(sk);
-	__mptcp_close(sk, timeout);
-}
-
 static void mptcp_copy_inaddrs(struct sock *msk, const struct sock *ssk)
 {
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
-- 
2.24.1

