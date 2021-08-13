Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9EB3EBE31
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 00:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235160AbhHMWQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 18:16:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:29033 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235029AbhHMWQX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 18:16:23 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10075"; a="212520893"
X-IronPort-AV: E=Sophos;i="5.84,320,1620716400"; 
   d="scan'208";a="212520893"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 15:15:54 -0700
X-IronPort-AV: E=Sophos;i="5.84,320,1620716400"; 
   d="scan'208";a="504320450"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.69.245])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 15:15:54 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/8] mptcp: more accurate timeout
Date:   Fri, 13 Aug 2021 15:15:41 -0700
Message-Id: <20210813221548.111990-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813221548.111990-1-mathew.j.martineau@linux.intel.com>
References: <20210813221548.111990-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

As reported by Maxim, we have a lot of MPTCP-level
retransmissions when multilple links with different latencies
are in use.

This patch refactor the mptcp-level timeout accounting so that
the maximum of all the active subflow timeout is used. To avoid
traversing the subflow list multiple times, the update is
performed inside the packet scheduler.

Additionally clean-up a bit timeout handling.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 60 +++++++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 23 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index a88924947815..08fa2c73a7e5 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -411,16 +411,28 @@ static void mptcp_set_datafin_timeout(const struct sock *sk)
 				       TCP_RTO_MIN << icsk->icsk_retransmits);
 }
 
-static void mptcp_set_timeout(const struct sock *sk, const struct sock *ssk)
+static void __mptcp_set_timeout(struct sock *sk, long tout)
 {
-	long tout = ssk && inet_csk(ssk)->icsk_pending ?
-				      inet_csk(ssk)->icsk_timeout - jiffies : 0;
-
-	if (tout <= 0)
-		tout = mptcp_sk(sk)->timer_ival;
 	mptcp_sk(sk)->timer_ival = tout > 0 ? tout : TCP_RTO_MIN;
 }
 
+static long mptcp_timeout_from_subflow(const struct mptcp_subflow_context *subflow)
+{
+	const struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+
+	return inet_csk(ssk)->icsk_pending ? inet_csk(ssk)->icsk_timeout - jiffies : 0;
+}
+
+static void mptcp_set_timeout(struct sock *sk)
+{
+	struct mptcp_subflow_context *subflow;
+	long tout = 0;
+
+	mptcp_for_each_subflow(mptcp_sk(sk), subflow)
+		tout = max(tout, mptcp_timeout_from_subflow(subflow));
+	__mptcp_set_timeout(sk, tout);
+}
+
 static bool tcp_can_send_ack(const struct sock *ssk)
 {
 	return !((1 << inet_sk_state_load(ssk)) &
@@ -531,7 +543,6 @@ static bool mptcp_check_data_fin(struct sock *sk)
 		}
 
 		ret = true;
-		mptcp_set_timeout(sk, NULL);
 		mptcp_send_ack(msk);
 		mptcp_close_wake_up(sk);
 	}
@@ -791,10 +802,7 @@ static void mptcp_reset_timer(struct sock *sk)
 	if (unlikely(inet_sk_state_load(sk) == TCP_CLOSE))
 		return;
 
-	/* should never be called with mptcp level timer cleared */
-	tout = READ_ONCE(mptcp_sk(sk)->timer_ival);
-	if (WARN_ON_ONCE(!tout))
-		tout = TCP_RTO_MIN;
+	tout = mptcp_sk(sk)->timer_ival;
 	sk_reset_timer(sk, &icsk->icsk_retransmit_timer, jiffies + tout);
 }
 
@@ -1077,7 +1085,7 @@ static void __mptcp_clean_una(struct sock *sk)
 	}
 
 	if (snd_una == READ_ONCE(msk->snd_nxt)) {
-		if (msk->timer_ival && !mptcp_data_fin_enabled(msk))
+		if (mptcp_timer_pending(sk) && !mptcp_data_fin_enabled(msk))
 			mptcp_stop_timer(sk);
 	} else {
 		mptcp_reset_timer(sk);
@@ -1366,16 +1374,22 @@ struct subflow_send_info {
 	u64 ratio;
 };
 
+/* implement the mptcp packet scheduler;
+ * returns the subflow that will transmit the next DSS
+ * additionally updates the rtx timeout
+ */
 static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk)
 {
 	struct subflow_send_info send_info[2];
 	struct mptcp_subflow_context *subflow;
+	struct sock *sk = (struct sock *)msk;
 	int i, nr_active = 0;
 	struct sock *ssk;
+	long tout = 0;
 	u64 ratio;
 	u32 pace;
 
-	sock_owned_by_me((struct sock *)msk);
+	sock_owned_by_me(sk);
 
 	if (__mptcp_check_fallback(msk)) {
 		if (!msk->first)
@@ -1386,8 +1400,10 @@ static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk)
 	/* re-use last subflow, if the burst allow that */
 	if (msk->last_snd && msk->snd_burst > 0 &&
 	    sk_stream_memory_free(msk->last_snd) &&
-	    mptcp_subflow_active(mptcp_subflow_ctx(msk->last_snd)))
+	    mptcp_subflow_active(mptcp_subflow_ctx(msk->last_snd))) {
+		mptcp_set_timeout(sk);
 		return msk->last_snd;
+	}
 
 	/* pick the subflow with the lower wmem/wspace ratio */
 	for (i = 0; i < 2; ++i) {
@@ -1400,6 +1416,7 @@ static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk)
 		if (!mptcp_subflow_active(subflow))
 			continue;
 
+		tout = max(tout, mptcp_timeout_from_subflow(subflow));
 		nr_active += !subflow->backup;
 		if (!sk_stream_memory_free(subflow->tcp_sock) || !tcp_sk(ssk)->snd_wnd)
 			continue;
@@ -1415,6 +1432,7 @@ static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk)
 			send_info[subflow->backup].ratio = ratio;
 		}
 	}
+	__mptcp_set_timeout(sk, tout);
 
 	/* pick the best backup if no other subflow is active */
 	if (!nr_active)
@@ -1433,7 +1451,6 @@ static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk)
 static void mptcp_push_release(struct sock *sk, struct sock *ssk,
 			       struct mptcp_sendmsg_info *info)
 {
-	mptcp_set_timeout(sk, ssk);
 	tcp_push(ssk, 0, info->mss_now, tcp_sk(ssk)->nonagle, info->size_goal);
 	release_sock(ssk);
 }
@@ -1501,12 +1518,11 @@ static void __mptcp_push_pending(struct sock *sk, unsigned int flags)
 		mptcp_push_release(sk, ssk, &info);
 
 out:
-	if (copied) {
-		/* start the timer, if it's not pending */
-		if (!mptcp_timer_pending(sk))
-			mptcp_reset_timer(sk);
+	/* ensure the rtx timer is running */
+	if (!mptcp_timer_pending(sk))
+		mptcp_reset_timer(sk);
+	if (copied)
 		__mptcp_check_send_data_fin(sk);
-	}
 }
 
 static void __mptcp_subflow_push_pending(struct sock *sk, struct sock *ssk)
@@ -1567,7 +1583,6 @@ static void __mptcp_subflow_push_pending(struct sock *sk, struct sock *ssk)
 	 */
 	__mptcp_update_wmem(sk);
 	if (copied) {
-		mptcp_set_timeout(sk, ssk);
 		tcp_push(ssk, 0, info.mss_now, tcp_sk(ssk)->nonagle,
 			 info.size_goal);
 		if (!mptcp_timer_pending(sk))
@@ -2313,7 +2328,6 @@ static void __mptcp_retrans(struct sock *sk)
 			 info.size_goal);
 	}
 
-	mptcp_set_timeout(sk, ssk);
 	release_sock(ssk);
 
 reset_timer:
@@ -2384,6 +2398,7 @@ static int __mptcp_init_sock(struct sock *sk)
 	msk->wmem_reserved = 0;
 	WRITE_ONCE(msk->rmem_released, 0);
 	msk->tx_pending_data = 0;
+	msk->timer_ival = TCP_RTO_MIN;
 
 	msk->first = NULL;
 	inet_csk(sk)->icsk_sync_mss = mptcp_sync_mss;
@@ -2472,7 +2487,6 @@ void mptcp_subflow_shutdown(struct sock *sk, struct sock *ssk, int how)
 			tcp_shutdown(ssk, how);
 		} else {
 			pr_debug("Sending DATA_FIN on subflow %p", ssk);
-			mptcp_set_timeout(sk, ssk);
 			tcp_send_ack(ssk);
 			if (!mptcp_timer_pending(sk))
 				mptcp_reset_timer(sk);
-- 
2.32.0

