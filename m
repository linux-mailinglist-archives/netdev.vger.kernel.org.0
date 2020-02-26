Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9062C16FA6B
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 10:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgBZJP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 04:15:28 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:60788 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727719AbgBZJP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 04:15:28 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1j6sms-0001Nj-Ok; Wed, 26 Feb 2020 10:15:26 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 7/7] mptcp: defer work schedule until mptcp lock is released
Date:   Wed, 26 Feb 2020 10:14:52 +0100
Message-Id: <20200226091452.1116-8-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200226091452.1116-1-fw@strlen.de>
References: <20200226091452.1116-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Don't schedule the work queue right away, instead defer this
to the lock release callback.

This has the advantage that it will give recv path a chance to
complete -- this might have moved all pending packets from the
subflow to the mptcp receive queue, which allows to avoid the
schedule_work().

Co-developed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 70f20c8eddbd..044295707bbf 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -238,9 +238,16 @@ void mptcp_data_ready(struct sock *sk, struct sock *ssk)
 	if (atomic_read(&sk->sk_rmem_alloc) > READ_ONCE(sk->sk_rcvbuf))
 		goto wake;
 
-	if (schedule_work(&msk->work))
-		sock_hold((struct sock *)msk);
+	/* mptcp socket is owned, release_cb should retry */
+	if (!test_and_set_bit(TCP_DELACK_TIMER_DEFERRED,
+			      &sk->sk_tsq_flags)) {
+		sock_hold(sk);
 
+		/* need to try again, its possible release_cb() has already
+		 * been called after the test_and_set_bit() above.
+		 */
+		move_skbs_to_msk(msk, ssk);
+	}
 wake:
 	sk->sk_data_ready(sk);
 }
@@ -941,6 +948,32 @@ static int mptcp_getsockopt(struct sock *sk, int level, int optname,
 	return -EOPNOTSUPP;
 }
 
+#define MPTCP_DEFERRED_ALL TCPF_DELACK_TIMER_DEFERRED
+
+/* this is very alike tcp_release_cb() but we must handle differently a
+ * different set of events
+ */
+static void mptcp_release_cb(struct sock *sk)
+{
+	unsigned long flags, nflags;
+
+	do {
+		flags = sk->sk_tsq_flags;
+		if (!(flags & MPTCP_DEFERRED_ALL))
+			return;
+		nflags = flags & ~MPTCP_DEFERRED_ALL;
+	} while (cmpxchg(&sk->sk_tsq_flags, flags, nflags) != flags);
+
+	if (flags & TCPF_DELACK_TIMER_DEFERRED) {
+		struct mptcp_sock *msk = mptcp_sk(sk);
+		struct sock *ssk;
+
+		ssk = mptcp_subflow_recv_lookup(msk);
+		if (!ssk || !schedule_work(&msk->work))
+			__sock_put(sk);
+	}
+}
+
 static int mptcp_get_port(struct sock *sk, unsigned short snum)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -1016,6 +1049,7 @@ static struct proto mptcp_prot = {
 	.destroy	= mptcp_destroy,
 	.sendmsg	= mptcp_sendmsg,
 	.recvmsg	= mptcp_recvmsg,
+	.release_cb	= mptcp_release_cb,
 	.hash		= inet_hash,
 	.unhash		= inet_unhash,
 	.get_port	= mptcp_get_port,
-- 
2.24.1

