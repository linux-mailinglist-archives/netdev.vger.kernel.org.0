Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC75720FCB9
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 21:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbgF3TZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 15:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbgF3TZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 15:25:04 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1114C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 12:25:03 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jqLsM-0001jT-E5; Tue, 30 Jun 2020 21:25:02 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     <mptcp@lists.01.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 2/2] mptcp: add receive buffer auto-tuning
Date:   Tue, 30 Jun 2020 21:24:45 +0200
Message-Id: <20200630192445.18333-3-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200630192445.18333-1-fw@strlen.de>
References: <20200630192445.18333-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When mptcp is used, userspace doesn't read from the tcp (subflow)
socket but from the parent (mptcp) socket receive queue.

skbs are moved from the subflow socket to the mptcp rx queue either from
'data_ready' callback (if mptcp socket can be locked), a work queue, or
the socket receive function.

This means tcp_rcv_space_adjust() is never called and thus no receive
buffer size auto-tuning is done.

An earlier (not merged) patch added tcp_rcv_space_adjust() calls to the
function that moves skbs from subflow to mptcp socket.
While this enabled autotuning, it also meant tuning was done even if
userspace was reading the mptcp socket very slowly.

This adds mptcp_rcv_space_adjust() and calls it after userspace has
read data from the mptcp socket rx queue.

Its very similar to tcp_rcv_space_adjust, with two differences:

1. The rtt estimate is the largest one observed on a subflow
2. The rcvbuf size and window clamp of all subflows is adjusted
   to the mptcp-level rcvbuf.

Otherwise, we get spurious drops at tcp (subflow) socket level if
the skbs are not moved to the mptcp socket fast enough.

Before:
time mptcp_connect.sh -t -f $((4*1024*1024)) -d 300 -l 0.01% -r 0 -e "" -m mmap
[..]
ns4 MPTCP -> ns3 (10.0.3.2:10108      ) MPTCP   (duration 40823ms) [ OK ]
ns4 MPTCP -> ns3 (10.0.3.2:10109      ) TCP     (duration 23119ms) [ OK ]
ns4 TCP   -> ns3 (10.0.3.2:10110      ) MPTCP   (duration  5421ms) [ OK ]
ns4 MPTCP -> ns3 (dead:beef:3::2:10111) MPTCP   (duration 41446ms) [ OK ]
ns4 MPTCP -> ns3 (dead:beef:3::2:10112) TCP     (duration 23427ms) [ OK ]
ns4 TCP   -> ns3 (dead:beef:3::2:10113) MPTCP   (duration  5426ms) [ OK ]
Time: 1396 seconds

After:
ns4 MPTCP -> ns3 (10.0.3.2:10108      ) MPTCP   (duration  5417ms) [ OK ]
ns4 MPTCP -> ns3 (10.0.3.2:10109      ) TCP     (duration  5427ms) [ OK ]
ns4 TCP   -> ns3 (10.0.3.2:10110      ) MPTCP   (duration  5422ms) [ OK ]
ns4 MPTCP -> ns3 (dead:beef:3::2:10111) MPTCP   (duration  5415ms) [ OK ]
ns4 MPTCP -> ns3 (dead:beef:3::2:10112) TCP     (duration  5422ms) [ OK ]
ns4 TCP   -> ns3 (dead:beef:3::2:10113) MPTCP   (duration  5423ms) [ OK ]
Time: 296 seconds

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 123 ++++++++++++++++++++++++++++++++++++++++---
 net/mptcp/protocol.h |   7 +++
 net/mptcp/subflow.c  |   5 +-
 3 files changed, 127 insertions(+), 8 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 28ec26d97f96..fa137a9c42d1 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -179,13 +179,6 @@ static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
 		return false;
 	}
 
-	if (!(sk->sk_userlocks & SOCK_RCVBUF_LOCK)) {
-		int rcvbuf = max(ssk->sk_rcvbuf, sk->sk_rcvbuf);
-
-		if (rcvbuf > sk->sk_rcvbuf)
-			sk->sk_rcvbuf = rcvbuf;
-	}
-
 	tp = tcp_sk(ssk);
 	do {
 		u32 map_remaining, offset;
@@ -916,6 +909,100 @@ static int __mptcp_recvmsg_mskq(struct mptcp_sock *msk,
 	return copied;
 }
 
+/* receive buffer autotuning.  See tcp_rcv_space_adjust for more information.
+ *
+ * Only difference: Use highest rtt estimate of the subflows in use.
+ */
+static void mptcp_rcv_space_adjust(struct mptcp_sock *msk, int copied)
+{
+	struct mptcp_subflow_context *subflow;
+	struct sock *sk = (struct sock *)msk;
+	u32 time, advmss = 1;
+	u64 rtt_us, mstamp;
+
+	sock_owned_by_me(sk);
+
+	if (copied <= 0)
+		return;
+
+	msk->rcvq_space.copied += copied;
+
+	mstamp = div_u64(tcp_clock_ns(), NSEC_PER_USEC);
+	time = tcp_stamp_us_delta(mstamp, msk->rcvq_space.time);
+
+	rtt_us = msk->rcvq_space.rtt_us;
+	if (rtt_us && time < (rtt_us >> 3))
+		return;
+
+	rtt_us = 0;
+	mptcp_for_each_subflow(msk, subflow) {
+		const struct tcp_sock *tp;
+		u64 sf_rtt_us;
+		u32 sf_advmss;
+
+		tp = tcp_sk(mptcp_subflow_tcp_sock(subflow));
+
+		sf_rtt_us = READ_ONCE(tp->rcv_rtt_est.rtt_us);
+		sf_advmss = READ_ONCE(tp->advmss);
+
+		rtt_us = max(sf_rtt_us, rtt_us);
+		advmss = max(sf_advmss, advmss);
+	}
+
+	msk->rcvq_space.rtt_us = rtt_us;
+	if (time < (rtt_us >> 3) || rtt_us == 0)
+		return;
+
+	if (msk->rcvq_space.copied <= msk->rcvq_space.space)
+		goto new_measure;
+
+	if (sock_net(sk)->ipv4.sysctl_tcp_moderate_rcvbuf &&
+	    !(sk->sk_userlocks & SOCK_RCVBUF_LOCK)) {
+		int rcvmem, rcvbuf;
+		u64 rcvwin, grow;
+
+		rcvwin = ((u64)msk->rcvq_space.copied << 1) + 16 * advmss;
+
+		grow = rcvwin * (msk->rcvq_space.copied - msk->rcvq_space.space);
+
+		do_div(grow, msk->rcvq_space.space);
+		rcvwin += (grow << 1);
+
+		rcvmem = SKB_TRUESIZE(advmss + MAX_TCP_HEADER);
+		while (tcp_win_from_space(sk, rcvmem) < advmss)
+			rcvmem += 128;
+
+		do_div(rcvwin, advmss);
+		rcvbuf = min_t(u64, rcvwin * rcvmem,
+			       sock_net(sk)->ipv4.sysctl_tcp_rmem[2]);
+
+		if (rcvbuf > sk->sk_rcvbuf) {
+			u32 window_clamp;
+
+			window_clamp = tcp_win_from_space(sk, rcvbuf);
+			WRITE_ONCE(sk->sk_rcvbuf, rcvbuf);
+
+			/* Make subflows follow along.  If we do not do this, we
+			 * get drops at subflow level if skbs can't be moved to
+			 * the mptcp rx queue fast enough (announced rcv_win can
+			 * exceed ssk->sk_rcvbuf).
+			 */
+			mptcp_for_each_subflow(msk, subflow) {
+				struct sock *ssk;
+
+				ssk = mptcp_subflow_tcp_sock(subflow);
+				WRITE_ONCE(ssk->sk_rcvbuf, rcvbuf);
+				tcp_sk(ssk)->window_clamp = window_clamp;
+			}
+		}
+	}
+
+	msk->rcvq_space.space = msk->rcvq_space.copied;
+new_measure:
+	msk->rcvq_space.copied = 0;
+	msk->rcvq_space.time = mstamp;
+}
+
 static bool __mptcp_move_skbs(struct mptcp_sock *msk)
 {
 	unsigned int moved = 0;
@@ -1028,6 +1115,8 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		set_bit(MPTCP_DATA_READY, &msk->flags);
 	}
 out_err:
+	mptcp_rcv_space_adjust(msk, copied);
+
 	release_sock(sk);
 	return copied;
 }
@@ -1241,6 +1330,7 @@ static int mptcp_init_sock(struct sock *sk)
 		return ret;
 
 	sk_sockets_allocated_inc(sk);
+	sk->sk_rcvbuf = sock_net(sk)->ipv4.sysctl_tcp_rmem[1];
 	sk->sk_sndbuf = sock_net(sk)->ipv4.sysctl_tcp_wmem[2];
 
 	return 0;
@@ -1423,6 +1513,22 @@ struct sock *mptcp_sk_clone(const struct sock *sk,
 	return nsk;
 }
 
+void mptcp_rcv_space_init(struct mptcp_sock *msk, const struct sock *ssk)
+{
+	const struct tcp_sock *tp = tcp_sk(ssk);
+
+	msk->rcvq_space.copied = 0;
+	msk->rcvq_space.rtt_us = 0;
+
+	msk->rcvq_space.time = tp->tcp_mstamp;
+
+	/* initial rcv_space offering made to peer */
+	msk->rcvq_space.space = min_t(u32, tp->rcv_wnd,
+				      TCP_INIT_CWND * tp->advmss);
+	if (msk->rcvq_space.space == 0)
+		msk->rcvq_space.space = TCP_INIT_CWND * TCP_MSS_DEFAULT;
+}
+
 static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 				 bool kern)
 {
@@ -1471,6 +1577,7 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 		list_add(&subflow->node, &msk->conn_list);
 		inet_sk_state_store(newsk, TCP_ESTABLISHED);
 
+		mptcp_rcv_space_init(msk, ssk);
 		bh_unlock_sock(new_mptcp_sock);
 
 		__MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_MPCAPABLEPASSIVEACK);
@@ -1631,6 +1738,8 @@ void mptcp_finish_connect(struct sock *ssk)
 	atomic64_set(&msk->snd_una, msk->write_seq);
 
 	mptcp_pm_new_connection(msk, 0);
+
+	mptcp_rcv_space_init(msk, ssk);
 }
 
 static void mptcp_sock_graft(struct sock *sk, struct socket *parent)
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 1d05d9841b5c..a6412ff0fddb 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -209,6 +209,12 @@ struct mptcp_sock {
 	struct socket	*subflow; /* outgoing connect/listener/!mp_capable */
 	struct sock	*first;
 	struct mptcp_pm_data	pm;
+	struct {
+		u32	space;	/* bytes copied in last measurement window */
+		u32	copied; /* bytes copied in this measurement window */
+		u64	time;	/* start time of measurement window */
+		u64	rtt_us; /* last maximum rtt of subflows */
+	} rcvq_space;
 };
 
 #define mptcp_for_each_subflow(__msk, __subflow)			\
@@ -369,6 +375,7 @@ void mptcp_get_options(const struct sk_buff *skb,
 		       struct mptcp_options_received *mp_opt);
 
 void mptcp_finish_connect(struct sock *sk);
+void mptcp_rcv_space_init(struct mptcp_sock *msk, const struct sock *ssk);
 void mptcp_data_ready(struct sock *sk, struct sock *ssk);
 bool mptcp_finish_join(struct sock *sk);
 void mptcp_data_acked(struct sock *sk);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 548f9e347ff5..0e65bc07363c 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -253,8 +253,10 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 		pr_fallback(mptcp_sk(subflow->conn));
 	}
 
-	if (mptcp_check_fallback(sk))
+	if (mptcp_check_fallback(sk)) {
+		mptcp_rcv_space_init(mptcp_sk(parent), sk);
 		return;
+	}
 
 	if (subflow->mp_capable) {
 		pr_debug("subflow=%p, remote_key=%llu", mptcp_subflow_ctx(sk),
@@ -1130,6 +1132,7 @@ static void subflow_state_change(struct sock *sk)
 
 	if (subflow_simultaneous_connect(sk)) {
 		mptcp_do_fallback(sk);
+		mptcp_rcv_space_init(mptcp_sk(parent), sk);
 		pr_fallback(mptcp_sk(parent));
 		subflow->conn_finished = 1;
 		if (inet_sk_state_load(parent) == TCP_SYN_SENT) {
-- 
2.26.2

