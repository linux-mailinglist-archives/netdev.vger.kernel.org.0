Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB4A1A537C
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 21:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgDKTFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 15:05:09 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:59090 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726129AbgDKTFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Apr 2020 15:05:08 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jNLRC-0000Xa-RL; Sat, 11 Apr 2020 21:05:06 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     syzkaller-bugs@googlegroups.com, mptcp@lists.01.org,
        Florian Westphal <fw@strlen.de>,
        syzbot+e56606435b7bfeea8cf5@syzkaller.appspotmail.com
Subject: [PATCH net] mptcp: fix double-unlock in mptcp_poll
Date:   Sat, 11 Apr 2020 21:05:01 +0200
Message-Id: <20200411190501.13249-1-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <000000000000758fcf05a306a8bf@google.com>
References: <000000000000758fcf05a306a8bf@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mptcp_connect/28740 is trying to release lock (sk_lock-AF_INET) at:
[<ffffffff82c15869>] mptcp_poll+0xb9/0x550
but there are no more locks to release!
Call Trace:
 lock_release+0x50f/0x750
 release_sock+0x171/0x1b0
 mptcp_poll+0xb9/0x550
 sock_poll+0x157/0x470
 ? get_net_ns+0xb0/0xb0
 do_sys_poll+0x63c/0xdd0

Problem is that __mptcp_tcp_fallback() releases the mptcp socket lock,
but after recent change it doesn't do this in all of its return paths.

To fix this, remove the unlock from __mptcp_tcp_fallback() and
always do the unlock in the caller.

Also add a small comment as to why we have this
__mptcp_needs_tcp_fallback().

Fixes: 0b4f33def7bbde ("mptcp: fix tcp fallback crash")
Reported-by: syzbot+e56606435b7bfeea8cf5@syzkaller.appspotmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 NB: Reproducer did not trigger for me, so i can't be 100% sure,
 but looking at the 'Fixes' commit the change to
 __mptcp_needs_tcp_fallback was broken.

 net/mptcp/protocol.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 72f3176dc924..559253be6a21 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -97,12 +97,7 @@ static struct socket *__mptcp_tcp_fallback(struct mptcp_sock *msk)
 	if (likely(!__mptcp_needs_tcp_fallback(msk)))
 		return NULL;
 
-	if (msk->subflow) {
-		release_sock((struct sock *)msk);
-		return msk->subflow;
-	}
-
-	return NULL;
+	return msk->subflow;
 }
 
 static bool __mptcp_can_create_subflow(const struct mptcp_sock *msk)
@@ -734,9 +729,10 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 			goto out;
 	}
 
+fallback:
 	ssock = __mptcp_tcp_fallback(msk);
 	if (unlikely(ssock)) {
-fallback:
+		release_sock(sk);
 		pr_debug("fallback passthrough");
 		ret = sock_sendmsg(ssock, msg);
 		return ret >= 0 ? ret + copied : (copied ? copied : ret);
@@ -778,8 +774,14 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		if (ret < 0)
 			break;
 		if (ret == 0 && unlikely(__mptcp_needs_tcp_fallback(msk))) {
+			/* Can happen for passive sockets:
+			 * 3WHS negotiated MPTCP, but first packet after is
+			 * plain TCP (e.g. due to middlebox filtering unknown
+			 * options).
+			 *
+			 * Fall back to TCP.
+			 */
 			release_sock(ssk);
-			ssock = __mptcp_tcp_fallback(msk);
 			goto fallback;
 		}
 
@@ -892,6 +894,7 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	ssock = __mptcp_tcp_fallback(msk);
 	if (unlikely(ssock)) {
 fallback:
+		release_sock(sk);
 		pr_debug("fallback-read subflow=%p",
 			 mptcp_subflow_ctx(ssock->sk));
 		copied = sock_recvmsg(ssock, msg, flags);
@@ -1476,12 +1479,11 @@ static int mptcp_setsockopt(struct sock *sk, int level, int optname,
 	 */
 	lock_sock(sk);
 	ssock = __mptcp_tcp_fallback(msk);
+	release_sock(sk);
 	if (ssock)
 		return tcp_setsockopt(ssock->sk, level, optname, optval,
 				      optlen);
 
-	release_sock(sk);
-
 	return -EOPNOTSUPP;
 }
 
@@ -1501,12 +1503,11 @@ static int mptcp_getsockopt(struct sock *sk, int level, int optname,
 	 */
 	lock_sock(sk);
 	ssock = __mptcp_tcp_fallback(msk);
+	release_sock(sk);
 	if (ssock)
 		return tcp_getsockopt(ssock->sk, level, optname, optval,
 				      option);
 
-	release_sock(sk);
-
 	return -EOPNOTSUPP;
 }
 
-- 
2.24.1

