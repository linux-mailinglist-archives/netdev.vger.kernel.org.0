Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2B4C9507
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729403AbfJBXiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:38:19 -0400
Received: from mga04.intel.com ([192.55.52.120]:16479 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729093AbfJBXhm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:37:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:37:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366862633"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.30.230])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 16:37:24 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Paolo Abeni <pabeni@redhat.com>, cpaasch@apple.com, fw@strlen.de,
        peter.krystad@linux.intel.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH v2 37/45] mptcp: introduce MPTCP retransmission timer
Date:   Wed,  2 Oct 2019 16:36:47 -0700
Message-Id: <20191002233655.24323-38-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
References: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

The timer will be used to schedule retransmission. It's
frequency is based on the current subflow RTO estimation and
is reset on every una_seq update

The timer is clearer for good by __mptcp_clear_xmit()

Also clean MPTCP rtx queue before each transmission

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/options.c  |  4 +-
 net/mptcp/protocol.c | 99 ++++++++++++++++++++++++++++++++++++++++++++
 net/mptcp/protocol.h |  2 +
 3 files changed, 104 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 2427fff98091..5e575999e281 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -568,8 +568,10 @@ void update_una(struct mptcp_sock *msk, struct mptcp_options_received *mp_opt)
 		snd_una = old_snd_una;
 		old_snd_una = atomic64_cmpxchg(&msk->snd_una, snd_una,
 					       new_snd_una);
-		if (old_snd_una == snd_una)
+		if (old_snd_una == snd_una) {
+			mptcp_reset_timer((struct sock *)msk);
 			break;
+		}
 	}
 }
 
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index c2e89e8cbc0e..1f7a090ed25c 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -19,6 +19,41 @@
 #include <net/mptcp.h>
 #include "protocol.h"
 
+static void mptcp_set_timeout(const struct sock *sk, const struct sock *ssk)
+{
+	unsigned long tout = ssk && inet_csk(ssk)->icsk_pending ?
+			     inet_csk(ssk)->icsk_timeout - jiffies : 0;
+
+	if (tout <= 0)
+		tout = mptcp_sk(sk)->timer_ival;
+	mptcp_sk(sk)->timer_ival =  tout > 0 ? tout : TCP_RTO_MIN;
+}
+
+bool mptcp_timer_pending(struct sock *sk)
+{
+	return timer_pending(&inet_csk(sk)->icsk_retransmit_timer);
+}
+
+void mptcp_reset_timer(struct sock *sk)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+	unsigned long tout;
+
+	/* should never be called with mptcp level timer cleared */
+	tout = READ_ONCE(mptcp_sk(sk)->timer_ival);
+	if (WARN_ON_ONCE(!tout))
+		tout = TCP_RTO_MIN;
+	sk_reset_timer(sk, &icsk->icsk_retransmit_timer, jiffies + tout);
+}
+
+static void mptcp_stop_timer(struct sock *sk)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+
+	sk_stop_timer(sk, &icsk->icsk_retransmit_timer);
+	mptcp_sk(sk)->timer_ival = 0;
+}
+
 static struct socket *__mptcp_fallback_get_ref(const struct mptcp_sock *msk)
 {
 	sock_owned_by_me((const struct sock *)msk);
@@ -308,10 +343,15 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		copied += ret;
 	}
 
+	mptcp_set_timeout(sk, ssk);
 	if (copied) {
 		ret = copied;
 		tcp_push(ssk, msg->msg_flags, mss_now, tcp_sk(ssk)->nonagle,
 			 size_goal);
+
+		/* start the timer, if it's not pending */
+		if (!mptcp_timer_pending(sk))
+			mptcp_reset_timer(sk);
 	}
 
 	release_sock(ssk);
@@ -680,6 +720,35 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	return copied;
 }
 
+static void mptcp_retransmit_handler(struct sock *sk)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
+	if (atomic64_read(&msk->snd_una) == msk->write_seq)
+		mptcp_stop_timer(sk);
+	else
+		mptcp_reset_timer(sk);
+}
+
+static void mptcp_retransmit_timer(struct timer_list *t)
+{
+	struct inet_connection_sock *icsk = from_timer(icsk, t,
+						       icsk_retransmit_timer);
+	struct sock *sk = &icsk->icsk_inet.sk;
+
+	bh_lock_sock(sk);
+	if (!sock_owned_by_user(sk)) {
+		mptcp_retransmit_handler(sk);
+	} else {
+		/* delegate our work to tcp_release_cb() */
+		if (!test_and_set_bit(TCP_WRITE_TIMER_DEFERRED,
+				      &sk->sk_tsq_flags))
+			sock_hold(sk);
+	}
+	bh_unlock_sock(sk);
+	sock_put(sk);
+}
+
 static int __mptcp_init_sock(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -687,6 +756,9 @@ static int __mptcp_init_sock(struct sock *sk)
 	INIT_LIST_HEAD(&msk->conn_list);
 	INIT_LIST_HEAD(&msk->rtx_queue);
 
+	/* re-use the csk retrans timer for MPTCP-level retrans */
+	timer_setup(&msk->sk.icsk_retransmit_timer, mptcp_retransmit_timer, 0);
+
 	return 0;
 }
 
@@ -708,6 +780,8 @@ static void __mptcp_clear_xmit(struct sock *sk)
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct mptcp_data_frag *dtmp, *dfrag;
 
+	sk_stop_timer(sk, &msk->sk.icsk_retransmit_timer);
+
 	list_for_each_entry_safe(dfrag, dtmp, &msk->rtx_queue, list)
 		dfrag_clear(dfrag);
 }
@@ -884,6 +958,30 @@ static int mptcp_getsockopt(struct sock *sk, int level, int optname,
 	return -EOPNOTSUPP;
 }
 
+#define MPTCP_DEFERRED_ALL TCPF_WRITE_TIMER_DEFERRED
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
+	sock_release_ownership(sk);
+
+	if (flags & TCPF_WRITE_TIMER_DEFERRED) {
+		mptcp_retransmit_handler(sk);
+		__sock_put(sk);
+	}
+}
+
 static int mptcp_get_port(struct sock *sk, unsigned short snum)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -986,6 +1084,7 @@ static struct proto mptcp_prot = {
 	.destroy	= mptcp_destroy,
 	.sendmsg	= mptcp_sendmsg,
 	.recvmsg	= mptcp_recvmsg,
+	.release_cb	= mptcp_release_cb,
 	.hash		= inet_hash,
 	.unhash		= inet_unhash,
 	.get_port	= mptcp_get_port,
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index e09db0f85bfc..ef35d0aa8eb7 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -129,6 +129,7 @@ struct mptcp_sock {
 	u64		write_seq;
 	u64		ack_seq;
 	atomic64_t	snd_una;
+	unsigned long	timer_ival;
 	u32		token;
 	unsigned long	flags;
 	u16		dport;
@@ -252,6 +253,7 @@ void mptcp_get_options(const struct sk_buff *skb,
 
 void mptcp_finish_connect(struct sock *sk, int mp_capable);
 void mptcp_finish_join(struct sock *sk);
+void mptcp_reset_timer(struct sock *sk);
 
 int mptcp_token_new_request(struct request_sock *req);
 void mptcp_token_destroy_request(u32 token);
-- 
2.23.0

