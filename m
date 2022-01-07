Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B341486EAA
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344068AbiAGAUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:20:45 -0500
Received: from mga03.intel.com ([134.134.136.65]:47989 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344003AbiAGAUn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 19:20:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641514843; x=1673050843;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pqOieQkFJK/df3FIuxP2JeoTUef4jBU5My1op3wP8ds=;
  b=Am9taSfait+ijO0cHLgnFNlDrZBCrCq6Zj22kWfmOXgY9XItdFKtTIDC
   MyY3Ec1IG42aGAfPxH/sVg0KyMHT3OLF/DnA5m8TFIpWQJJiquqMbkSjT
   R3L1ru6oEV/fGrHR22tuK8ErVd6/q2PNRCeVYlA5gRdHFs5XWbF/tRVpB
   esKcbHAXxfBlHhCrsxbwwDQxB2vHgU3lCU+0GVTlz+No86XGZ1I7sVLRe
   84BB1s0vVfATMck616xwgcV+2Ha/oby+kVbMTZmkOrU2vYz94HVwDB9kV
   NgCElKXuUwjB8pCUd7pdLDyk+wYQ3CbA12DqhG6zBpyQEDrtPkrbwjVr4
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="242721303"
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="242721303"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:20:34 -0800
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="618508497"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.94.200])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:20:34 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 03/13] mptcp: full disconnect implementation
Date:   Thu,  6 Jan 2022 16:20:16 -0800
Message-Id: <20220107002026.375427-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220107002026.375427-1-mathew.j.martineau@linux.intel.com>
References: <20220107002026.375427-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

The current mptcp_disconnect() implementation lacks several
steps, we additionally need to reset the msk socket state
and flush the subflow list.

Factor out the needed helper to avoid code duplication.

Additionally ensure that the initial subflow is disposed
only after mptcp_close(), just reset it at disconnect time.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm.c       |  10 +++--
 net/mptcp/protocol.c | 101 ++++++++++++++++++++++++++++++++-----------
 net/mptcp/protocol.h |  14 ++++++
 net/mptcp/token.c    |   1 +
 4 files changed, 98 insertions(+), 28 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 6ab386ff3294..6b2bfe89d445 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -356,7 +356,7 @@ void mptcp_pm_subflow_chk_stale(const struct mptcp_sock *msk, struct sock *ssk)
 	}
 }
 
-void mptcp_pm_data_init(struct mptcp_sock *msk)
+void mptcp_pm_data_reset(struct mptcp_sock *msk)
 {
 	msk->pm.add_addr_signaled = 0;
 	msk->pm.add_addr_accepted = 0;
@@ -371,10 +371,14 @@ void mptcp_pm_data_init(struct mptcp_sock *msk)
 	WRITE_ONCE(msk->pm.remote_deny_join_id0, false);
 	msk->pm.status = 0;
 
+	mptcp_pm_nl_data_init(msk);
+}
+
+void mptcp_pm_data_init(struct mptcp_sock *msk)
+{
 	spin_lock_init(&msk->pm.lock);
 	INIT_LIST_HEAD(&msk->pm.anno_list);
-
-	mptcp_pm_nl_data_init(msk);
+	mptcp_pm_data_reset(msk);
 }
 
 void __init mptcp_pm_init(void)
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index f6fc0f0f66f0..83f6d6c3e3eb 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2253,6 +2253,10 @@ bool __mptcp_retransmit_pending_data(struct sock *sk)
 	return true;
 }
 
+/* flags for __mptcp_close_ssk() */
+#define MPTCP_CF_PUSH		BIT(1)
+#define MPTCP_CF_FASTCLOSE	BIT(2)
+
 /* subflow sockets can be either outgoing (connect) or incoming
  * (accept).
  *
@@ -2262,22 +2266,37 @@ bool __mptcp_retransmit_pending_data(struct sock *sk)
  * parent socket.
  */
 static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
-			      struct mptcp_subflow_context *subflow)
+			      struct mptcp_subflow_context *subflow,
+			      unsigned int flags)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
-	bool need_push;
+	bool need_push, dispose_it;
 
-	list_del(&subflow->node);
+	dispose_it = !msk->subflow || ssk != msk->subflow->sk;
+	if (dispose_it)
+		list_del(&subflow->node);
 
 	lock_sock_nested(ssk, SINGLE_DEPTH_NESTING);
 
+	if (flags & MPTCP_CF_FASTCLOSE)
+		subflow->send_fastclose = 1;
+
+	need_push = (flags & MPTCP_CF_PUSH) && __mptcp_retransmit_pending_data(sk);
+	if (!dispose_it) {
+		tcp_disconnect(ssk, 0);
+		msk->subflow->state = SS_UNCONNECTED;
+		mptcp_subflow_ctx_reset(subflow);
+		release_sock(ssk);
+
+		goto out;
+	}
+
 	/* if we are invoked by the msk cleanup code, the subflow is
 	 * already orphaned
 	 */
 	if (ssk->sk_socket)
 		sock_orphan(ssk);
 
-	need_push = __mptcp_retransmit_pending_data(sk);
 	subflow->disposable = 1;
 
 	/* if ssk hit tcp_done(), tcp_cleanup_ulp() cleared the related ops
@@ -2297,14 +2316,12 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 
 	sock_put(ssk);
 
-	if (ssk == msk->last_snd)
-		msk->last_snd = NULL;
-
 	if (ssk == msk->first)
 		msk->first = NULL;
 
-	if (msk->subflow && ssk == msk->subflow->sk)
-		mptcp_dispose_initial_subflow(msk);
+out:
+	if (ssk == msk->last_snd)
+		msk->last_snd = NULL;
 
 	if (need_push)
 		__mptcp_push_pending(sk, 0);
@@ -2315,7 +2332,7 @@ void mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 {
 	if (sk->sk_state == TCP_ESTABLISHED)
 		mptcp_event(MPTCP_EVENT_SUB_CLOSED, mptcp_sk(sk), ssk, GFP_KERNEL);
-	__mptcp_close_ssk(sk, ssk, subflow);
+	__mptcp_close_ssk(sk, ssk, subflow, MPTCP_CF_PUSH);
 }
 
 static unsigned int mptcp_sync_mss(struct sock *sk, u32 pmtu)
@@ -2533,9 +2550,20 @@ static int __mptcp_init_sock(struct sock *sk)
 	return 0;
 }
 
-static int mptcp_init_sock(struct sock *sk)
+static void mptcp_ca_reset(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
+
+	tcp_assign_congestion_control(sk);
+	strcpy(mptcp_sk(sk)->ca_name, icsk->icsk_ca_ops->name);
+
+	/* no need to keep a reference to the ops, the name will suffice */
+	tcp_cleanup_congestion_control(sk);
+	icsk->icsk_ca_ops = NULL;
+}
+
+static int mptcp_init_sock(struct sock *sk)
+{
 	struct net *net = sock_net(sk);
 	int ret;
 
@@ -2556,12 +2584,7 @@ static int mptcp_init_sock(struct sock *sk)
 	/* fetch the ca name; do it outside __mptcp_init_sock(), so that clone will
 	 * propagate the correct value
 	 */
-	tcp_assign_congestion_control(sk);
-	strcpy(mptcp_sk(sk)->ca_name, icsk->icsk_ca_ops->name);
-
-	/* no need to keep a reference to the ops, the name will suffice */
-	tcp_cleanup_congestion_control(sk);
-	icsk->icsk_ca_ops = NULL;
+	mptcp_ca_reset(sk);
 
 	sk_sockets_allocated_inc(sk);
 	sk->sk_rcvbuf = sock_net(sk)->ipv4.sysctl_tcp_rmem[1];
@@ -2720,9 +2743,13 @@ static void __mptcp_destroy_sock(struct sock *sk)
 	sk_stop_timer(sk, &sk->sk_timer);
 	msk->pm.status = 0;
 
+	/* clears msk->subflow, allowing the following loop to close
+	 * even the initial subflow
+	 */
+	mptcp_dispose_initial_subflow(msk);
 	list_for_each_entry_safe(subflow, tmp, &conn_list, node) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
-		__mptcp_close_ssk(sk, ssk, subflow);
+		__mptcp_close_ssk(sk, ssk, subflow, 0);
 	}
 
 	sk->sk_prot->destroy(sk);
@@ -2733,7 +2760,6 @@ static void __mptcp_destroy_sock(struct sock *sk)
 	xfrm_sk_free_policy(sk);
 
 	sk_refcnt_debug_release(sk);
-	mptcp_dispose_initial_subflow(msk);
 	sock_put(sk);
 }
 
@@ -2769,6 +2795,9 @@ static void mptcp_close(struct sock *sk, long timeout)
 
 	sock_hold(sk);
 	pr_debug("msk=%p state=%d", sk, sk->sk_state);
+	if (mptcp_sk(sk)->token)
+		mptcp_event(MPTCP_EVENT_CLOSED, mptcp_sk(sk), NULL, GFP_KERNEL);
+
 	if (sk->sk_state == TCP_CLOSE) {
 		__mptcp_destroy_sock(sk);
 		do_cancel_work = true;
@@ -2779,9 +2808,6 @@ static void mptcp_close(struct sock *sk, long timeout)
 	if (do_cancel_work)
 		mptcp_cancel_work(sk);
 
-	if (mptcp_sk(sk)->token)
-		mptcp_event(MPTCP_EVENT_CLOSED, mptcp_sk(sk), NULL, GFP_KERNEL);
-
 	sock_put(sk);
 }
 
@@ -2815,13 +2841,36 @@ static int mptcp_disconnect(struct sock *sk, int flags)
 
 	mptcp_do_flush_join_list(msk);
 
+	inet_sk_state_store(sk, TCP_CLOSE);
+
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 
-		lock_sock(ssk);
-		tcp_disconnect(ssk, flags);
-		release_sock(ssk);
+		__mptcp_close_ssk(sk, ssk, subflow, MPTCP_CF_FASTCLOSE);
 	}
+
+	sk_stop_timer(sk, &msk->sk.icsk_retransmit_timer);
+	sk_stop_timer(sk, &sk->sk_timer);
+
+	if (mptcp_sk(sk)->token)
+		mptcp_event(MPTCP_EVENT_CLOSED, mptcp_sk(sk), NULL, GFP_KERNEL);
+
+	mptcp_destroy_common(msk);
+	msk->last_snd = NULL;
+	msk->flags = 0;
+	msk->recovery = false;
+	msk->can_ack = false;
+	msk->fully_established = false;
+	msk->rcv_data_fin = false;
+	msk->snd_data_fin_enable = false;
+	msk->rcv_fastclose = false;
+	msk->use_64bit_ack = false;
+	WRITE_ONCE(msk->csum_enabled, mptcp_is_checksum_enabled(sock_net(sk)));
+	mptcp_pm_data_reset(msk);
+	mptcp_ca_reset(sk);
+
+	sk->sk_shutdown = 0;
+	sk_error_report(sk);
 	return 0;
 }
 
@@ -2961,9 +3010,11 @@ void mptcp_destroy_common(struct mptcp_sock *msk)
 	__mptcp_clear_xmit(sk);
 
 	/* move to sk_receive_queue, sk_stream_kill_queues will purge it */
+	mptcp_data_lock(sk);
 	skb_queue_splice_tail_init(&msk->receive_queue, &sk->sk_receive_queue);
 	__skb_queue_purge(&sk->sk_receive_queue);
 	skb_rbtree_purge(&msk->out_of_order_queue);
+	mptcp_data_unlock(sk);
 
 	/* move all the rx fwd alloc into the sk_mem_reclaim_final in
 	 * inet_sock_destruct() will dispose it
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index f177936ff67d..1a4ca5a202c8 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -395,6 +395,9 @@ DECLARE_PER_CPU(struct mptcp_delegated_action, mptcp_delegated_actions);
 /* MPTCP subflow context */
 struct mptcp_subflow_context {
 	struct	list_head node;/* conn_list of subflows */
+
+	char	reset_start[0];
+
 	unsigned long avg_pacing_rate; /* protected by msk socket lock */
 	u64	local_key;
 	u64	remote_key;
@@ -442,6 +445,9 @@ struct mptcp_subflow_context {
 	u8	stale_count;
 
 	long	delegated_status;
+
+	char	reset_end[0];
+
 	struct	list_head delegated_node;   /* link into delegated_action, protected by local BH */
 
 	u32	setsockopt_seq;
@@ -473,6 +479,13 @@ mptcp_subflow_tcp_sock(const struct mptcp_subflow_context *subflow)
 	return subflow->tcp_sock;
 }
 
+static inline void
+mptcp_subflow_ctx_reset(struct mptcp_subflow_context *subflow)
+{
+	memset(subflow->reset_start, 0, subflow->reset_end - subflow->reset_start);
+	subflow->request_mptcp = 1;
+}
+
 static inline u64
 mptcp_subflow_get_map_offset(const struct mptcp_subflow_context *subflow)
 {
@@ -713,6 +726,7 @@ void mptcp_crypto_hmac_sha(u64 key1, u64 key2, u8 *msg, int len, void *hmac);
 
 void __init mptcp_pm_init(void);
 void mptcp_pm_data_init(struct mptcp_sock *msk);
+void mptcp_pm_data_reset(struct mptcp_sock *msk);
 void mptcp_pm_subflow_chk_stale(const struct mptcp_sock *msk, struct sock *ssk);
 void mptcp_pm_nl_subflow_chk_stale(const struct mptcp_sock *msk, struct sock *ssk);
 void mptcp_pm_new_connection(struct mptcp_sock *msk, const struct sock *ssk, int server_side);
diff --git a/net/mptcp/token.c b/net/mptcp/token.c
index e581b341c5be..f52ee7b26aed 100644
--- a/net/mptcp/token.c
+++ b/net/mptcp/token.c
@@ -384,6 +384,7 @@ void mptcp_token_destroy(struct mptcp_sock *msk)
 		bucket->chain_len--;
 	}
 	spin_unlock_bh(&bucket->lock);
+	WRITE_ONCE(msk->token, 0);
 }
 
 void __init mptcp_token_init(void)
-- 
2.34.1

