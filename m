Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 046D7194970
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 21:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgCZUrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 16:47:04 -0400
Received: from mga05.intel.com ([192.55.52.43]:47906 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727724AbgCZUrD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 16:47:03 -0400
IronPort-SDR: Iq/YvNqAjVHrWcjykePyQizC+Ely/riHx2bUfnRERFmhjZ8Xh0oWE9GbSN14Y7hOXHCTM0A5SP
 Bp1hG+VS4JAQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 13:47:01 -0700
IronPort-SDR: F1287YxRBe/DM/BxA0byNhW4+GFS+1g68sDH3g30b050m7W9GQPEtEfmJPwmrzfkKMyNky0EMK
 i7eOu2rUoTow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,309,1580803200"; 
   d="scan'208";a="238911681"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.252.133.119])
  by fmsmga007.fm.intel.com with ESMTP; 26 Mar 2020 13:47:01 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, eric.dumazet@gmail.com,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next v2 08/17] mptcp: introduce MPTCP retransmission timer
Date:   Thu, 26 Mar 2020 13:46:31 -0700
Message-Id: <20200326204640.67336-9-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200326204640.67336-1-mathew.j.martineau@linux.intel.com>
References: <20200326204640.67336-1-mathew.j.martineau@linux.intel.com>
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

Also clean MPTCP rtx queue before each transmission.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c  |  4 +-
 net/mptcp/protocol.c | 89 +++++++++++++++++++++++++++++++++++++++++++-
 net/mptcp/protocol.h |  2 +
 3 files changed, 93 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index b0ff8ad702a3..bd220ee4aac9 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -779,8 +779,10 @@ static void update_una(struct mptcp_sock *msk,
 		snd_una = old_snd_una;
 		old_snd_una = atomic64_cmpxchg(&msk->snd_una, snd_una,
 					       new_snd_una);
-		if (old_snd_una == snd_una)
+		if (old_snd_una == snd_una) {
+			mptcp_data_acked((struct sock *)msk);
 			break;
+		}
 	}
 }
 
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index dae5d3152da4..35eae3fdcf04 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -251,6 +251,46 @@ static void __mptcp_flush_join_list(struct mptcp_sock *msk)
 	spin_unlock_bh(&msk->join_list_lock);
 }
 
+static void mptcp_set_timeout(const struct sock *sk, const struct sock *ssk)
+{
+	long tout = ssk && inet_csk(ssk)->icsk_pending ?
+				      inet_csk(ssk)->icsk_timeout - jiffies : 0;
+
+	if (tout <= 0)
+		tout = mptcp_sk(sk)->timer_ival;
+	mptcp_sk(sk)->timer_ival = tout > 0 ? tout : TCP_RTO_MIN;
+}
+
+static bool mptcp_timer_pending(struct sock *sk)
+{
+	return timer_pending(&inet_csk(sk)->icsk_retransmit_timer);
+}
+
+static void mptcp_reset_timer(struct sock *sk)
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
+void mptcp_data_acked(struct sock *sk)
+{
+	mptcp_reset_timer(sk);
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
 static bool mptcp_ext_cache_refill(struct mptcp_sock *msk)
 {
 	if (!msk->cached_ext)
@@ -596,10 +636,15 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
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
 
 	ssk_check_wmem(msk, ssk);
@@ -787,6 +832,35 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
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
 /* subflow sockets can be either outgoing (connect) or incoming
  * (accept).
  *
@@ -846,6 +920,9 @@ static int __mptcp_init_sock(struct sock *sk)
 
 	mptcp_pm_data_init(msk);
 
+	/* re-use the csk retrans timer for MPTCP-level retrans */
+	timer_setup(&msk->sk.icsk_retransmit_timer, mptcp_retransmit_timer, 0);
+
 	return 0;
 }
 
@@ -867,6 +944,8 @@ static void __mptcp_clear_xmit(struct sock *sk)
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct mptcp_data_frag *dtmp, *dfrag;
 
+	sk_stop_timer(sk, &msk->sk.icsk_retransmit_timer);
+
 	list_for_each_entry_safe(dfrag, dtmp, &msk->rtx_queue, list)
 		dfrag_clear(dfrag);
 }
@@ -1155,7 +1234,8 @@ static int mptcp_getsockopt(struct sock *sk, int level, int optname,
 	return -EOPNOTSUPP;
 }
 
-#define MPTCP_DEFERRED_ALL TCPF_DELACK_TIMER_DEFERRED
+#define MPTCP_DEFERRED_ALL (TCPF_DELACK_TIMER_DEFERRED | \
+			    TCPF_WRITE_TIMER_DEFERRED)
 
 /* this is very alike tcp_release_cb() but we must handle differently a
  * different set of events
@@ -1171,6 +1251,8 @@ static void mptcp_release_cb(struct sock *sk)
 		nflags = flags & ~MPTCP_DEFERRED_ALL;
 	} while (cmpxchg(&sk->sk_tsq_flags, flags, nflags) != flags);
 
+	sock_release_ownership(sk);
+
 	if (flags & TCPF_DELACK_TIMER_DEFERRED) {
 		struct mptcp_sock *msk = mptcp_sk(sk);
 		struct sock *ssk;
@@ -1179,6 +1261,11 @@ static void mptcp_release_cb(struct sock *sk)
 		if (!ssk || !schedule_work(&msk->work))
 			__sock_put(sk);
 	}
+
+	if (flags & TCPF_WRITE_TIMER_DEFERRED) {
+		mptcp_retransmit_handler(sk);
+		__sock_put(sk);
+	}
 }
 
 static int mptcp_get_port(struct sock *sk, unsigned short snum)
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index a1fdb879259a..d222eea11922 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -157,6 +157,7 @@ struct mptcp_sock {
 	u64		write_seq;
 	u64		ack_seq;
 	atomic64_t	snd_una;
+	unsigned long	timer_ival;
 	u32		token;
 	unsigned long	flags;
 	bool		can_ack;
@@ -326,6 +327,7 @@ void mptcp_get_options(const struct sk_buff *skb,
 void mptcp_finish_connect(struct sock *sk);
 void mptcp_data_ready(struct sock *sk, struct sock *ssk);
 bool mptcp_finish_join(struct sock *sk);
+void mptcp_data_acked(struct sock *sk);
 
 int mptcp_token_new_request(struct request_sock *req);
 void mptcp_token_destroy_request(u32 token);
-- 
2.26.0

