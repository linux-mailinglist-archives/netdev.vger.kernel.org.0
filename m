Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE7E02B9BAF
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 20:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgKSTqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 14:46:15 -0500
Received: from mga03.intel.com ([134.134.136.65]:56904 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727926AbgKSTqO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 14:46:14 -0500
IronPort-SDR: +TF4sLReS9QyiiedoHaqHkEWGIcIPzbA08FlPu5+KAjTeYDYBum+MU+wqS27vMbfsMaEdtMGV4
 XCdCzFadcvxQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9810"; a="171451137"
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="171451137"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2020 11:46:09 -0800
IronPort-SDR: 38Rx7b29TrbAkOJKZe0GlXJTTWOs3Lkh2+1QqSidQ3WfLkHORJGo97xoEB2k/x6d5k7kW1IgtX
 qqqLnXsM9TQw==
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="476940491"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.255.229.232])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2020 11:46:09 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, kuba@kernel.org,
        mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 10/10] mptcp: refine MPTCP-level ack scheduling
Date:   Thu, 19 Nov 2020 11:46:03 -0800
Message-Id: <20201119194603.103158-11-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201119194603.103158-1-mathew.j.martineau@linux.intel.com>
References: <20201119194603.103158-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Send timely MPTCP-level ack is somewhat difficult when
the insertion into the msk receive level is performed
by the worker.

It needs TCP-level dup-ack to notify the MPTCP-level
ack_seq increase, as both the TCP-level ack seq and the
rcv window are unchanged.

We can actually avoid processing incoming data with the
worker, and let the subflow or recevmsg() send ack as needed.

When recvmsg() moves the skbs inside the msk receive queue,
the msk space is still unchanged, so tcp_cleanup_rbuf() could
end-up skipping TCP-level ack generation. Anyway, when
__mptcp_move_skbs() is invoked, a known amount of bytes is
going to be consumed soon: we update rcv wnd computation taking
them in account.

Additionally we need to explicitly trigger tcp_cleanup_rbuf()
when recvmsg() consumes a significant amount of the receive buffer.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c  |   1 +
 net/mptcp/protocol.c | 105 +++++++++++++++++++++----------------------
 net/mptcp/protocol.h |   8 ++++
 net/mptcp/subflow.c  |   4 +-
 4 files changed, 61 insertions(+), 57 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 248e3930c0cb..8a59b3e44599 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -530,6 +530,7 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
 		opts->ext_copy.ack64 = 0;
 	}
 	opts->ext_copy.use_ack = 1;
+	WRITE_ONCE(msk->old_wspace, __mptcp_space((struct sock *)msk));
 
 	/* Add kind/length/subtype/flag overhead if mapping is not populated */
 	if (dss_size == 0)
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 4ae2c4a30e44..748343f1a968 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -407,16 +407,42 @@ static void mptcp_set_timeout(const struct sock *sk, const struct sock *ssk)
 	mptcp_sk(sk)->timer_ival = tout > 0 ? tout : TCP_RTO_MIN;
 }
 
-static void mptcp_send_ack(struct mptcp_sock *msk)
+static bool mptcp_subflow_active(struct mptcp_subflow_context *subflow)
+{
+	struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+
+	/* can't send if JOIN hasn't completed yet (i.e. is usable for mptcp) */
+	if (subflow->request_join && !subflow->fully_established)
+		return false;
+
+	/* only send if our side has not closed yet */
+	return ((1 << ssk->sk_state) & (TCPF_ESTABLISHED | TCPF_CLOSE_WAIT));
+}
+
+static void mptcp_send_ack(struct mptcp_sock *msk, bool force)
 {
 	struct mptcp_subflow_context *subflow;
+	struct sock *pick = NULL;
 
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 
-		lock_sock(ssk);
-		tcp_send_ack(ssk);
-		release_sock(ssk);
+		if (force) {
+			lock_sock(ssk);
+			tcp_send_ack(ssk);
+			release_sock(ssk);
+			continue;
+		}
+
+		/* if the hintes ssk is still active, use it */
+		pick = ssk;
+		if (ssk == msk->ack_hint)
+			break;
+	}
+	if (!force && pick) {
+		lock_sock(pick);
+		tcp_cleanup_rbuf(pick, 1);
+		release_sock(pick);
 	}
 }
 
@@ -468,7 +494,7 @@ static bool mptcp_check_data_fin(struct sock *sk)
 
 		ret = true;
 		mptcp_set_timeout(sk, NULL);
-		mptcp_send_ack(msk);
+		mptcp_send_ack(msk, true);
 		mptcp_close_wake_up(sk);
 	}
 	return ret;
@@ -483,7 +509,6 @@ static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
 	unsigned int moved = 0;
 	bool more_data_avail;
 	struct tcp_sock *tp;
-	u32 old_copied_seq;
 	bool done = false;
 	int sk_rbuf;
 
@@ -500,7 +525,6 @@ static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
 
 	pr_debug("msk=%p ssk=%p", msk, ssk);
 	tp = tcp_sk(ssk);
-	old_copied_seq = tp->copied_seq;
 	do {
 		u32 map_remaining, offset;
 		u32 seq = tp->copied_seq;
@@ -564,11 +588,9 @@ static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
 			break;
 		}
 	} while (more_data_avail);
+	msk->ack_hint = ssk;
 
 	*bytes += moved;
-	if (tp->copied_seq != old_copied_seq)
-		tcp_cleanup_rbuf(ssk, 1);
-
 	return done;
 }
 
@@ -672,19 +694,8 @@ void mptcp_data_ready(struct sock *sk, struct sock *ssk)
 	if (atomic_read(&sk->sk_rmem_alloc) > sk_rbuf)
 		goto wake;
 
-	if (move_skbs_to_msk(msk, ssk))
-		goto wake;
+	move_skbs_to_msk(msk, ssk);
 
-	/* mptcp socket is owned, release_cb should retry */
-	if (!test_and_set_bit(TCP_DELACK_TIMER_DEFERRED,
-			      &sk->sk_tsq_flags)) {
-		sock_hold(sk);
-
-		/* need to try again, its possible release_cb() has already
-		 * been called after the test_and_set_bit() above.
-		 */
-		move_skbs_to_msk(msk, ssk);
-	}
 wake:
 	if (wake)
 		sk->sk_data_ready(sk);
@@ -1095,18 +1106,6 @@ static void mptcp_nospace(struct mptcp_sock *msk)
 	mptcp_clean_una((struct sock *)msk);
 }
 
-static bool mptcp_subflow_active(struct mptcp_subflow_context *subflow)
-{
-	struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
-
-	/* can't send if JOIN hasn't completed yet (i.e. is usable for mptcp) */
-	if (subflow->request_join && !subflow->fully_established)
-		return false;
-
-	/* only send if our side has not closed yet */
-	return ((1 << ssk->sk_state) & (TCPF_ESTABLISHED | TCPF_CLOSE_WAIT));
-}
-
 #define MPTCP_SEND_BURST_SIZE		((1 << 16) - \
 					 sizeof(struct tcphdr) - \
 					 MAX_TCP_OPTION_SPACE - \
@@ -1533,7 +1532,7 @@ static void mptcp_rcv_space_adjust(struct mptcp_sock *msk, int copied)
 	msk->rcvq_space.time = mstamp;
 }
 
-static bool __mptcp_move_skbs(struct mptcp_sock *msk)
+static bool __mptcp_move_skbs(struct mptcp_sock *msk, unsigned int rcv)
 {
 	unsigned int moved = 0;
 	bool done;
@@ -1552,12 +1551,16 @@ static bool __mptcp_move_skbs(struct mptcp_sock *msk)
 
 		slowpath = lock_sock_fast(ssk);
 		done = __mptcp_move_skbs_from_subflow(msk, ssk, &moved);
+		if (moved && rcv) {
+			WRITE_ONCE(msk->rmem_pending, min(rcv, moved));
+			tcp_cleanup_rbuf(ssk, 1);
+			WRITE_ONCE(msk->rmem_pending, 0);
+		}
 		unlock_sock_fast(ssk, slowpath);
 	} while (!done);
 
 	if (mptcp_ofo_queue(msk) || moved > 0) {
-		if (!mptcp_check_data_fin((struct sock *)msk))
-			mptcp_send_ack(msk);
+		mptcp_check_data_fin((struct sock *)msk);
 		return true;
 	}
 	return false;
@@ -1581,8 +1584,8 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);
 	__mptcp_flush_join_list(msk);
 
-	while (len > (size_t)copied) {
-		int bytes_read;
+	for (;;) {
+		int bytes_read, old_space;
 
 		bytes_read = __mptcp_recvmsg_mskq(msk, msg, len - copied);
 		if (unlikely(bytes_read < 0)) {
@@ -1594,9 +1597,14 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		copied += bytes_read;
 
 		if (skb_queue_empty(&sk->sk_receive_queue) &&
-		    __mptcp_move_skbs(msk))
+		    __mptcp_move_skbs(msk, len - copied))
 			continue;
 
+		/* be sure to advertise window change */
+		old_space = READ_ONCE(msk->old_wspace);
+		if ((tcp_space(sk) - old_space) >= old_space)
+			mptcp_send_ack(msk, false);
+
 		/* only the master socket status is relevant here. The exit
 		 * conditions mirror closely tcp_recvmsg()
 		 */
@@ -1649,7 +1657,7 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		/* .. race-breaker: ssk might have gotten new data
 		 * after last __mptcp_move_skbs() returned false.
 		 */
-		if (unlikely(__mptcp_move_skbs(msk)))
+		if (unlikely(__mptcp_move_skbs(msk, 0)))
 			set_bit(MPTCP_DATA_READY, &msk->flags);
 	} else if (unlikely(!test_bit(MPTCP_DATA_READY, &msk->flags))) {
 		/* data to read but mptcp_wait_data() cleared DATA_READY */
@@ -1880,7 +1888,6 @@ static void mptcp_worker(struct work_struct *work)
 	if (test_and_clear_bit(MPTCP_WORK_CLOSE_SUBFLOW, &msk->flags))
 		__mptcp_close_subflow(msk);
 
-	__mptcp_move_skbs(msk);
 	if (mptcp_send_head(sk))
 		mptcp_push_pending(sk, 0);
 
@@ -1964,6 +1971,7 @@ static int __mptcp_init_sock(struct sock *sk)
 	msk->out_of_order_queue = RB_ROOT;
 	msk->first_pending = NULL;
 
+	msk->ack_hint = NULL;
 	msk->first = NULL;
 	inet_csk(sk)->icsk_sync_mss = mptcp_sync_mss;
 
@@ -2499,8 +2507,7 @@ static int mptcp_getsockopt(struct sock *sk, int level, int optname,
 	return -EOPNOTSUPP;
 }
 
-#define MPTCP_DEFERRED_ALL (TCPF_DELACK_TIMER_DEFERRED | \
-			    TCPF_WRITE_TIMER_DEFERRED)
+#define MPTCP_DEFERRED_ALL (TCPF_WRITE_TIMER_DEFERRED)
 
 /* this is very alike tcp_release_cb() but we must handle differently a
  * different set of events
@@ -2518,16 +2525,6 @@ static void mptcp_release_cb(struct sock *sk)
 
 	sock_release_ownership(sk);
 
-	if (flags & TCPF_DELACK_TIMER_DEFERRED) {
-		struct mptcp_sock *msk = mptcp_sk(sk);
-		struct sock *ssk;
-
-		ssk = mptcp_subflow_recv_lookup(msk);
-		if (!ssk || sk->sk_state == TCP_CLOSE ||
-		    !schedule_work(&msk->work))
-			__sock_put(sk);
-	}
-
 	if (flags & TCPF_WRITE_TIMER_DEFERRED) {
 		mptcp_retransmit_handler(sk);
 		__sock_put(sk);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 67f86818203f..82d5626323b1 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -220,10 +220,12 @@ struct mptcp_sock {
 	u64		rcv_data_fin_seq;
 	struct sock	*last_snd;
 	int		snd_burst;
+	int		old_wspace;
 	atomic64_t	snd_una;
 	atomic64_t	wnd_end;
 	unsigned long	timer_ival;
 	u32		token;
+	int		rmem_pending;
 	unsigned long	flags;
 	bool		can_ack;
 	bool		fully_established;
@@ -231,6 +233,7 @@ struct mptcp_sock {
 	bool		snd_data_fin_enable;
 	bool		use_64bit_ack; /* Set when we received a 64-bit DSN */
 	spinlock_t	join_list_lock;
+	struct sock	*ack_hint;
 	struct work_struct work;
 	struct sk_buff  *ooo_last_skb;
 	struct rb_root  out_of_order_queue;
@@ -258,6 +261,11 @@ static inline struct mptcp_sock *mptcp_sk(const struct sock *sk)
 	return (struct mptcp_sock *)sk;
 }
 
+static inline int __mptcp_space(const struct sock *sk)
+{
+	return tcp_space(sk) + READ_ONCE(mptcp_sk(sk)->rmem_pending);
+}
+
 static inline struct mptcp_data_frag *mptcp_send_head(const struct sock *sk)
 {
 	const struct mptcp_sock *msk = mptcp_sk(sk);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index d3c6b3a5ad55..4d8abff1be18 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -850,8 +850,6 @@ static void mptcp_subflow_discard_data(struct sock *ssk, struct sk_buff *skb,
 		sk_eat_skb(ssk, skb);
 	if (mptcp_subflow_get_map_offset(subflow) >= subflow->map_data_len)
 		subflow->map_valid = 0;
-	if (incr)
-		tcp_cleanup_rbuf(ssk, incr);
 }
 
 static bool subflow_check_data_avail(struct sock *ssk)
@@ -973,7 +971,7 @@ void mptcp_space(const struct sock *ssk, int *space, int *full_space)
 	const struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
 	const struct sock *sk = subflow->conn;
 
-	*space = tcp_space(sk);
+	*space = __mptcp_space(sk);
 	*full_space = tcp_full_space(sk);
 }
 
-- 
2.29.2

