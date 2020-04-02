Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A66A819C05B
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 13:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388006AbgDBLpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 07:45:08 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:44664 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728803AbgDBLpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 07:45:07 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jJyHR-0002ih-1E; Thu, 02 Apr 2020 13:45:05 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Christoph Paasch <cpaasch@apple.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH net 1/4] mptcp: fix tcp fallback crash
Date:   Thu,  2 Apr 2020 13:44:51 +0200
Message-Id: <20200402114454.8533-2-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200402114454.8533-1-fw@strlen.de>
References: <20200402114454.8533-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christoph Paasch reports following crash:

general protection fault [..]
CPU: 0 PID: 2874 Comm: syz-executor072 Not tainted 5.6.0-rc5 #62
RIP: 0010:__pv_queued_spin_lock_slowpath kernel/locking/qspinlock.c:471
[..]
 queued_spin_lock_slowpath arch/x86/include/asm/qspinlock.h:50 [inline]
 do_raw_spin_lock include/linux/spinlock.h:181 [inline]
 spin_lock_bh include/linux/spinlock.h:343 [inline]
 __mptcp_flush_join_list+0x44/0xb0 net/mptcp/protocol.c:278
 mptcp_shutdown+0xb3/0x230 net/mptcp/protocol.c:1882
[..]

Problem is that mptcp_shutdown() socket isn't an mptcp socket,
its a plain tcp_sk.  Thus, trying to access mptcp_sk specific
members accesses garbage.

Root cause is that accept() returns a fallback (tcp) socket, not an mptcp
one.  There is code in getpeername to detect this and override the sockets
stream_ops.  But this will only run when accept() caller provided a
sockaddr struct.  "accept(fd, NULL, 0)" will therefore result in
mptcp stream ops, but with sock->sk pointing at a tcp_sk.

Update the existing fallback handling to detect this as well.

Moreover, mptcp_shutdown did not have fallback handling, and
mptcp_poll did it too late so add that there as well.

Reported-by: Christoph Paasch <cpaasch@apple.com>
Tested-by: Christoph Paasch <cpaasch@apple.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 50 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 46 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 1833bc1f4a43..4cf88e3d5121 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -57,10 +57,43 @@ static bool __mptcp_needs_tcp_fallback(const struct mptcp_sock *msk)
 	return msk->first && !sk_is_mptcp(msk->first);
 }
 
+static struct socket *mptcp_is_tcpsk(struct sock *sk)
+{
+	struct socket *sock = sk->sk_socket;
+
+	if (sock->sk != sk)
+		return NULL;
+
+	if (unlikely(sk->sk_prot == &tcp_prot)) {
+		/* we are being invoked after mptcp_accept() has
+		 * accepted a non-mp-capable flow: sk is a tcp_sk,
+		 * not an mptcp one.
+		 *
+		 * Hand the socket over to tcp so all further socket ops
+		 * bypass mptcp.
+		 */
+		sock->ops = &inet_stream_ops;
+		return sock;
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+	} else if (unlikely(sk->sk_prot == &tcpv6_prot)) {
+		sock->ops = &inet6_stream_ops;
+		return sock;
+#endif
+	}
+
+	return NULL;
+}
+
 static struct socket *__mptcp_tcp_fallback(struct mptcp_sock *msk)
 {
+	struct socket *sock;
+
 	sock_owned_by_me((const struct sock *)msk);
 
+	sock = mptcp_is_tcpsk((struct sock *)msk);
+	if (unlikely(sock))
+		return sock;
+
 	if (likely(!__mptcp_needs_tcp_fallback(msk)))
 		return NULL;
 
@@ -84,6 +117,10 @@ static struct socket *__mptcp_socket_create(struct mptcp_sock *msk, int state)
 	struct socket *ssock;
 	int err;
 
+	ssock = __mptcp_tcp_fallback(msk);
+	if (unlikely(ssock))
+		return ssock;
+
 	ssock = __mptcp_nmpc_socket(msk);
 	if (ssock)
 		goto set_state;
@@ -1752,7 +1789,9 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 
 	msk = mptcp_sk(sk);
 	lock_sock(sk);
-	ssock = __mptcp_nmpc_socket(msk);
+	ssock = __mptcp_tcp_fallback(msk);
+	if (!ssock)
+		ssock = __mptcp_nmpc_socket(msk);
 	if (ssock) {
 		mask = ssock->ops->poll(file, ssock, wait);
 		release_sock(sk);
@@ -1762,9 +1801,6 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 	release_sock(sk);
 	sock_poll_wait(file, sock, wait);
 	lock_sock(sk);
-	ssock = __mptcp_tcp_fallback(msk);
-	if (unlikely(ssock))
-		return ssock->ops->poll(file, ssock, NULL);
 
 	if (test_bit(MPTCP_DATA_READY, &msk->flags))
 		mask = EPOLLIN | EPOLLRDNORM;
@@ -1783,11 +1819,17 @@ static int mptcp_shutdown(struct socket *sock, int how)
 {
 	struct mptcp_sock *msk = mptcp_sk(sock->sk);
 	struct mptcp_subflow_context *subflow;
+	struct socket *ssock;
 	int ret = 0;
 
 	pr_debug("sk=%p, how=%d", msk, how);
 
 	lock_sock(sock->sk);
+	ssock = __mptcp_tcp_fallback(msk);
+	if (ssock) {
+		release_sock(sock->sk);
+		return inet_shutdown(ssock, how);
+	}
 
 	if (how == SHUT_WR || how == SHUT_RDWR)
 		inet_sk_state_store(sock->sk, TCP_FIN_WAIT1);
-- 
2.24.1

