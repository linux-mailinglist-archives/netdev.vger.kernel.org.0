Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B24414CCD0
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 15:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgA2OzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 09:55:09 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:42566 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726645AbgA2OzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 09:55:08 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1iwokE-00078F-2M; Wed, 29 Jan 2020 15:55:06 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     matthieu.baerts@tessares.net, mathew.j.martineau@linux.intel.com,
        Florian Westphal <fw@strlen.de>,
        Christoph Paasch <cpaasch@apple.com>
Subject: [PATCH net 2/4] mptcp: fix panic on user pointer access
Date:   Wed, 29 Jan 2020 15:54:44 +0100
Message-Id: <20200129145446.26425-3-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129145446.26425-1-fw@strlen.de>
References: <20200129145446.26425-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Its not possible to call the kernel_(s|g)etsockopt functions here,
the address points to user memory:

General protection fault in user access. Non-canonical address?
WARNING: CPU: 1 PID: 5352 at arch/x86/mm/extable.c:77 ex_handler_uaccess+0xba/0xe0 arch/x86/mm/extable.c:77
Kernel panic - not syncing: panic_on_warn set ...
[..]
Call Trace:
 fixup_exception+0x9d/0xcd arch/x86/mm/extable.c:178
 general_protection+0x2d/0x40 arch/x86/entry/entry_64.S:1202
 do_ip_getsockopt+0x1f6/0x1860 net/ipv4/ip_sockglue.c:1323
 ip_getsockopt+0x87/0x1c0 net/ipv4/ip_sockglue.c:1561
 tcp_getsockopt net/ipv4/tcp.c:3691 [inline]
 tcp_getsockopt+0x8c/0xd0 net/ipv4/tcp.c:3685
 kernel_getsockopt+0x121/0x1f0 net/socket.c:3736
 mptcp_getsockopt+0x69/0x90 net/mptcp/protocol.c:830
 __sys_getsockopt+0x13a/0x220 net/socket.c:2175

We can call tcp_get/setsockopt functions instead.  Doing so fixes
crashing, but still leaves rtnl related lockdep splat:

     WARNING: possible circular locking dependency detected
     5.5.0-rc6 #2 Not tainted
     ------------------------------------------------------
     syz-executor.0/16334 is trying to acquire lock:
     ffffffff84f7a080 (rtnl_mutex){+.+.}, at: do_ip_setsockopt.isra.0+0x277/0x3820 net/ipv4/ip_sockglue.c:644
     but task is already holding lock:
     ffff888116503b90 (sk_lock-AF_INET){+.+.}, at: lock_sock include/net/sock.h:1516 [inline]
     ffff888116503b90 (sk_lock-AF_INET){+.+.}, at: mptcp_setsockopt+0x28/0x90 net/mptcp/protocol.c:1284

     which lock already depends on the new lock.
     the existing dependency chain (in reverse order) is:

     -> #1 (sk_lock-AF_INET){+.+.}:
            lock_sock_nested+0xca/0x120 net/core/sock.c:2944
            lock_sock include/net/sock.h:1516 [inline]
            do_ip_setsockopt.isra.0+0x281/0x3820 net/ipv4/ip_sockglue.c:645
            ip_setsockopt+0x44/0xf0 net/ipv4/ip_sockglue.c:1248
            udp_setsockopt+0x5d/0xa0 net/ipv4/udp.c:2639
            __sys_setsockopt+0x152/0x240 net/socket.c:2130
            __do_sys_setsockopt net/socket.c:2146 [inline]
            __se_sys_setsockopt net/socket.c:2143 [inline]
            __x64_sys_setsockopt+0xba/0x150 net/socket.c:2143
            do_syscall_64+0xbd/0x5b0 arch/x86/entry/common.c:294
            entry_SYSCALL_64_after_hwframe+0x49/0xbe

     -> #0 (rtnl_mutex){+.+.}:
            check_prev_add kernel/locking/lockdep.c:2475 [inline]
            check_prevs_add kernel/locking/lockdep.c:2580 [inline]
            validate_chain kernel/locking/lockdep.c:2970 [inline]
            __lock_acquire+0x1fb2/0x4680 kernel/locking/lockdep.c:3954
            lock_acquire+0x127/0x330 kernel/locking/lockdep.c:4484
            __mutex_lock_common kernel/locking/mutex.c:956 [inline]
            __mutex_lock+0x158/0x1340 kernel/locking/mutex.c:1103
            do_ip_setsockopt.isra.0+0x277/0x3820 net/ipv4/ip_sockglue.c:644
            ip_setsockopt+0x44/0xf0 net/ipv4/ip_sockglue.c:1248
            tcp_setsockopt net/ipv4/tcp.c:3159 [inline]
            tcp_setsockopt+0x8c/0xd0 net/ipv4/tcp.c:3153
            kernel_setsockopt+0x121/0x1f0 net/socket.c:3767
            mptcp_setsockopt+0x69/0x90 net/mptcp/protocol.c:1288
            __sys_setsockopt+0x152/0x240 net/socket.c:2130
            __do_sys_setsockopt net/socket.c:2146 [inline]
            __se_sys_setsockopt net/socket.c:2143 [inline]
            __x64_sys_setsockopt+0xba/0x150 net/socket.c:2143
            do_syscall_64+0xbd/0x5b0 arch/x86/entry/common.c:294
            entry_SYSCALL_64_after_hwframe+0x49/0xbe

     other info that might help us debug this:

      Possible unsafe locking scenario:

            CPU0                    CPU1
            ----                    ----
       lock(sk_lock-AF_INET);
                                    lock(rtnl_mutex);
                                    lock(sk_lock-AF_INET);
       lock(rtnl_mutex);

The lockdep complaint is because we hold mptcp socket lock when calling
the sk_prot get/setsockopt handler, and those might need to acquire the
rtnl mutex.  Normally, order is:

rtnl_lock(sk) -> lock_sock

Whereas for mptcp the order is

lock_sock(mptcp_sk) rtnl_lock -> lock_sock(subflow_sk)

We can avoid this by releasing the mptcp socket lock early, but, as Paolo
points out, we need to get/put the subflow socket refcount before doing so
to avoid race with concurrent close().

Fixes: 717e79c867ca5 ("mptcp: Add setsockopt()/getsockopt() socket operations")
Reported-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 40 ++++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index f1b1160dbbb4..07ebff6396cd 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -781,15 +781,12 @@ static void mptcp_destroy(struct sock *sk)
 }
 
 static int mptcp_setsockopt(struct sock *sk, int level, int optname,
-			    char __user *uoptval, unsigned int optlen)
+			    char __user *optval, unsigned int optlen)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
-	char __kernel *optval;
 	int ret = -EOPNOTSUPP;
 	struct socket *ssock;
-
-	/* will be treated as __user in tcp_setsockopt */
-	optval = (char __kernel __force *)uoptval;
+	struct sock *ssk;
 
 	pr_debug("msk=%p", msk);
 
@@ -798,27 +795,28 @@ static int mptcp_setsockopt(struct sock *sk, int level, int optname,
 	 */
 	lock_sock(sk);
 	ssock = __mptcp_socket_create(msk, MPTCP_SAME_STATE);
-	if (!IS_ERR(ssock)) {
-		pr_debug("subflow=%p", ssock->sk);
-		ret = kernel_setsockopt(ssock, level, optname, optval, optlen);
+	if (IS_ERR(ssock)) {
+		release_sock(sk);
+		return ret;
 	}
+
+	ssk = ssock->sk;
+	sock_hold(ssk);
 	release_sock(sk);
 
+	ret = tcp_setsockopt(ssk, level, optname, optval, optlen);
+	sock_put(ssk);
+
 	return ret;
 }
 
 static int mptcp_getsockopt(struct sock *sk, int level, int optname,
-			    char __user *uoptval, int __user *uoption)
+			    char __user *optval, int __user *option)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
-	char __kernel *optval;
 	int ret = -EOPNOTSUPP;
-	int __kernel *option;
 	struct socket *ssock;
-
-	/* will be treated as __user in tcp_getsockopt */
-	optval = (char __kernel __force *)uoptval;
-	option = (int __kernel __force *)uoption;
+	struct sock *ssk;
 
 	pr_debug("msk=%p", msk);
 
@@ -827,12 +825,18 @@ static int mptcp_getsockopt(struct sock *sk, int level, int optname,
 	 */
 	lock_sock(sk);
 	ssock = __mptcp_socket_create(msk, MPTCP_SAME_STATE);
-	if (!IS_ERR(ssock)) {
-		pr_debug("subflow=%p", ssock->sk);
-		ret = kernel_getsockopt(ssock, level, optname, optval, option);
+	if (IS_ERR(ssock)) {
+		release_sock(sk);
+		return ret;
 	}
+
+	ssk = ssock->sk;
+	sock_hold(ssk);
 	release_sock(sk);
 
+	ret = tcp_getsockopt(ssk, level, optname, optval, option);
+	sock_put(ssk);
+
 	return ret;
 }
 
-- 
2.24.1

