Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8B1486EA2
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343967AbiAGAUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:20:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:47570 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344032AbiAGAUi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 19:20:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641514838; x=1673050838;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SKZwGHNQT0X+qjlikfMMm8d4BiKvecIkUe6rU24m7yM=;
  b=aFa+gAiJH03HErgMdA9uNZNiQoJLih+NS5RkSb6Fv0XBPhTSuHqfYQZ7
   M1+agVFwllcsYw6SRkQIFiBISzxGIm4kIGRVJRzkxInOqqdbcpV6bahwy
   GYnGJLAJ/Wf62HE+nqV3DGRudQXafcqnIev6tfZ03CwI+PAsXvoxxzIUD
   0FyGwel+N14kYdY1Az3MZJeU5jt6f1+HPFzKOpyiDM8192oaAkkFhqqUy
   XalQ7LPcnFZVqQeXfEl7upoTL5XOg4fI+WYtC0cXGNd2EZkH2zdMwdwfy
   GPKx+OAfn/3TpYIppUvIiRlHKaWvvavh1V0rdwK5+hriH1OkvFpgBKedY
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="230109509"
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="230109509"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:20:37 -0800
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="618508519"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.94.200])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:20:37 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 12/13] mptcp: cleanup MPJ subflow list handling
Date:   Thu,  6 Jan 2022 16:20:25 -0800
Message-Id: <20220107002026.375427-13-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220107002026.375427-1-mathew.j.martineau@linux.intel.com>
References: <20220107002026.375427-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

We can simplify the join list handling leveraging the
mptcp_release_cb(): if we can acquire the msk socket
lock at mptcp_finish_join time, move the new subflow
directly into the conn_list, otherwise place it on join_list and
let the release_cb process such list.

Since pending MPJ connection are now always processed
in a timely way, we can avoid flushing the join list
every time we have to process all the current subflows.

Additionally we can now use the mptcp data lock to protect
the join_list, removing the additional spin lock.

Finally, the MPJ handshake is now always finalized under the
msk socket lock, we can drop the additional synchronization
between mptcp_finish_join() and mptcp_close().

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/pm_netlink.c |   3 --
 net/mptcp/protocol.c   | 117 ++++++++++++++++++-----------------------
 net/mptcp/protocol.h   |  15 +-----
 net/mptcp/sockopt.c    |  24 +++------
 net/mptcp/subflow.c    |   5 +-
 5 files changed, 60 insertions(+), 104 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 5efb63ab1fa3..75af1f701e1d 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -165,7 +165,6 @@ select_local_address(const struct pm_nl_pernet *pernet,
 	msk_owned_by_me(msk);
 
 	rcu_read_lock();
-	__mptcp_flush_join_list(msk);
 	list_for_each_entry_rcu(entry, &pernet->local_addr_list, list) {
 		if (!(entry->flags & MPTCP_PM_ADDR_FLAG_SUBFLOW))
 			continue;
@@ -595,7 +594,6 @@ static unsigned int fill_local_addresses_vec(struct mptcp_sock *msk,
 	subflows_max = mptcp_pm_get_subflows_max(msk);
 
 	rcu_read_lock();
-	__mptcp_flush_join_list(msk);
 	list_for_each_entry_rcu(entry, &pernet->local_addr_list, list) {
 		if (!(entry->flags & MPTCP_PM_ADDR_FLAG_FULLMESH))
 			continue;
@@ -684,7 +682,6 @@ void mptcp_pm_nl_addr_send_ack(struct mptcp_sock *msk)
 	    !mptcp_pm_should_rm_signal(msk))
 		return;
 
-	__mptcp_flush_join_list(msk);
 	subflow = list_first_entry_or_null(&msk->conn_list, typeof(*subflow), node);
 	if (subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 3e8cfaed00b5..c5f64fb0474d 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -808,47 +808,38 @@ void mptcp_data_ready(struct sock *sk, struct sock *ssk)
 	mptcp_data_unlock(sk);
 }
 
-static bool mptcp_do_flush_join_list(struct mptcp_sock *msk)
+static bool __mptcp_finish_join(struct mptcp_sock *msk, struct sock *ssk)
 {
-	struct mptcp_subflow_context *subflow;
-	bool ret = false;
+	struct sock *sk = (struct sock *)msk;
 
-	if (likely(list_empty(&msk->join_list)))
+	if (sk->sk_state != TCP_ESTABLISHED)
 		return false;
 
-	spin_lock_bh(&msk->join_list_lock);
-	list_for_each_entry(subflow, &msk->join_list, node) {
-		u32 sseq = READ_ONCE(subflow->setsockopt_seq);
-
-		mptcp_propagate_sndbuf((struct sock *)msk, mptcp_subflow_tcp_sock(subflow));
-		if (READ_ONCE(msk->setsockopt_seq) != sseq)
-			ret = true;
-	}
-	list_splice_tail_init(&msk->join_list, &msk->conn_list);
-	spin_unlock_bh(&msk->join_list_lock);
-
-	return ret;
-}
-
-void __mptcp_flush_join_list(struct mptcp_sock *msk)
-{
-	if (likely(!mptcp_do_flush_join_list(msk)))
-		return;
+	/* attach to msk socket only after we are sure we will deal with it
+	 * at close time
+	 */
+	if (sk->sk_socket && !ssk->sk_socket)
+		mptcp_sock_graft(ssk, sk->sk_socket);
 
-	if (!test_and_set_bit(MPTCP_WORK_SYNC_SETSOCKOPT, &msk->flags))
-		mptcp_schedule_work((struct sock *)msk);
+	mptcp_propagate_sndbuf((struct sock *)msk, ssk);
+	mptcp_sockopt_sync_locked(msk, ssk);
+	return true;
 }
 
-static void mptcp_flush_join_list(struct mptcp_sock *msk)
+static void __mptcp_flush_join_list(struct sock *sk)
 {
-	bool sync_needed = test_and_clear_bit(MPTCP_WORK_SYNC_SETSOCKOPT, &msk->flags);
-
-	might_sleep();
+	struct mptcp_subflow_context *tmp, *subflow;
+	struct mptcp_sock *msk = mptcp_sk(sk);
 
-	if (!mptcp_do_flush_join_list(msk) && !sync_needed)
-		return;
+	list_for_each_entry_safe(subflow, tmp, &msk->join_list, node) {
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+		bool slow = lock_sock_fast(ssk);
 
-	mptcp_sockopt_sync_all(msk);
+		list_move_tail(&subflow->node, &msk->conn_list);
+		if (!__mptcp_finish_join(msk, ssk))
+			mptcp_subflow_reset(ssk);
+		unlock_sock_fast(ssk, slow);
+	}
 }
 
 static bool mptcp_timer_pending(struct sock *sk)
@@ -1549,7 +1540,6 @@ void __mptcp_push_pending(struct sock *sk, unsigned int flags)
 			int ret = 0;
 
 			prev_ssk = ssk;
-			__mptcp_flush_join_list(msk);
 			ssk = mptcp_subflow_get_send(msk);
 
 			/* First check. If the ssk has changed since
@@ -1954,7 +1944,6 @@ static bool __mptcp_move_skbs(struct mptcp_sock *msk)
 	unsigned int moved = 0;
 	bool ret, done;
 
-	mptcp_flush_join_list(msk);
 	do {
 		struct sock *ssk = mptcp_subflow_recv_lookup(msk);
 		bool slowpath;
@@ -2490,7 +2479,6 @@ static void mptcp_worker(struct work_struct *work)
 		goto unlock;
 
 	mptcp_check_data_fin_ack(sk);
-	mptcp_flush_join_list(msk);
 
 	mptcp_check_fastclose(msk);
 
@@ -2528,8 +2516,6 @@ static int __mptcp_init_sock(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
-	spin_lock_init(&msk->join_list_lock);
-
 	INIT_LIST_HEAD(&msk->conn_list);
 	INIT_LIST_HEAD(&msk->join_list);
 	INIT_LIST_HEAD(&msk->rtx_queue);
@@ -2703,7 +2689,6 @@ static void __mptcp_check_send_data_fin(struct sock *sk)
 		}
 	}
 
-	mptcp_flush_join_list(msk);
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *tcp_sk = mptcp_subflow_tcp_sock(subflow);
 
@@ -2736,12 +2721,7 @@ static void __mptcp_destroy_sock(struct sock *sk)
 
 	might_sleep();
 
-	/* be sure to always acquire the join list lock, to sync vs
-	 * mptcp_finish_join().
-	 */
-	spin_lock_bh(&msk->join_list_lock);
-	list_splice_tail_init(&msk->join_list, &msk->conn_list);
-	spin_unlock_bh(&msk->join_list_lock);
+	/* join list will be eventually flushed (with rst) at sock lock release time*/
 	list_splice_init(&msk->conn_list, &conn_list);
 
 	sk_stop_timer(sk, &msk->sk.icsk_retransmit_timer);
@@ -2844,8 +2824,6 @@ static int mptcp_disconnect(struct sock *sk, int flags)
 	struct mptcp_subflow_context *subflow;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
-	mptcp_do_flush_join_list(msk);
-
 	inet_sk_state_store(sk, TCP_CLOSE);
 
 	mptcp_for_each_subflow(msk, subflow) {
@@ -3076,6 +3054,8 @@ static void mptcp_release_cb(struct sock *sk)
 			flags |= BIT(MPTCP_PUSH_PENDING);
 		if (test_and_clear_bit(MPTCP_RETRANSMIT, &mptcp_sk(sk)->flags))
 			flags |= BIT(MPTCP_RETRANSMIT);
+		if (test_and_clear_bit(MPTCP_FLUSH_JOIN_LIST, &mptcp_sk(sk)->flags))
+			flags |= BIT(MPTCP_FLUSH_JOIN_LIST);
 		if (!flags)
 			break;
 
@@ -3088,6 +3068,8 @@ static void mptcp_release_cb(struct sock *sk)
 		 */
 
 		spin_unlock_bh(&sk->sk_lock.slock);
+		if (flags & BIT(MPTCP_FLUSH_JOIN_LIST))
+			__mptcp_flush_join_list(sk);
 		if (flags & BIT(MPTCP_PUSH_PENDING))
 			__mptcp_push_pending(sk, 0);
 		if (flags & BIT(MPTCP_RETRANSMIT))
@@ -3232,8 +3214,7 @@ bool mptcp_finish_join(struct sock *ssk)
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
 	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
 	struct sock *parent = (void *)msk;
-	struct socket *parent_sock;
-	bool ret;
+	bool ret = true;
 
 	pr_debug("msk=%p, subflow=%p", msk, subflow);
 
@@ -3246,35 +3227,38 @@ bool mptcp_finish_join(struct sock *ssk)
 	if (!msk->pm.server_side)
 		goto out;
 
-	if (!mptcp_pm_allow_new_subflow(msk)) {
-		subflow->reset_reason = MPTCP_RST_EPROHIBIT;
-		return false;
-	}
+	if (!mptcp_pm_allow_new_subflow(msk))
+		goto err_prohibited;
 
-	/* active connections are already on conn_list, and we can't acquire
-	 * msk lock here.
-	 * use the join list lock as synchronization point and double-check
-	 * msk status to avoid racing with __mptcp_destroy_sock()
+	if (WARN_ON_ONCE(!list_empty(&subflow->node)))
+		goto err_prohibited;
+
+	/* active connections are already on conn_list.
+	 * If we can't acquire msk socket lock here, let the release callback
+	 * handle it
 	 */
-	spin_lock_bh(&msk->join_list_lock);
-	ret = inet_sk_state_load(parent) == TCP_ESTABLISHED;
-	if (ret && !WARN_ON_ONCE(!list_empty(&subflow->node))) {
-		list_add_tail(&subflow->node, &msk->join_list);
+	mptcp_data_lock(parent);
+	if (!sock_owned_by_user(parent)) {
+		ret = __mptcp_finish_join(msk, ssk);
+		if (ret) {
+			sock_hold(ssk);
+			list_add_tail(&subflow->node, &msk->conn_list);
+		}
+	} else {
 		sock_hold(ssk);
+		list_add_tail(&subflow->node, &msk->join_list);
+		set_bit(MPTCP_FLUSH_JOIN_LIST, &msk->flags);
 	}
-	spin_unlock_bh(&msk->join_list_lock);
+	mptcp_data_unlock(parent);
+
 	if (!ret) {
+err_prohibited:
 		subflow->reset_reason = MPTCP_RST_EPROHIBIT;
 		return false;
 	}
 
-	/* attach to msk socket only after we are sure he will deal with us
-	 * at close time
-	 */
-	parent_sock = READ_ONCE(parent->sk_socket);
-	if (parent_sock && !ssk->sk_socket)
-		mptcp_sock_graft(ssk, parent_sock);
 	subflow->map_seq = READ_ONCE(msk->ack_seq);
+
 out:
 	mptcp_event(MPTCP_EVENT_SUB_ESTABLISHED, msk, ssk, GFP_ATOMIC);
 	return true;
@@ -3539,7 +3523,6 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 		/* set ssk->sk_socket of accept()ed flows to mptcp socket.
 		 * This is needed so NOSPACE flag can be set from tcp stack.
 		 */
-		mptcp_flush_join_list(msk);
 		mptcp_for_each_subflow(msk, subflow) {
 			struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index a8eb32e29215..962f3b6b6a1d 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -120,7 +120,7 @@
 #define MPTCP_CLEAN_UNA		7
 #define MPTCP_ERROR_REPORT	8
 #define MPTCP_RETRANSMIT	9
-#define MPTCP_WORK_SYNC_SETSOCKOPT 10
+#define MPTCP_FLUSH_JOIN_LIST	10
 #define MPTCP_CONNECTED		11
 
 static inline bool before64(__u64 seq1, __u64 seq2)
@@ -261,7 +261,6 @@ struct mptcp_sock {
 	u8		recvmsg_inq:1,
 			cork:1,
 			nodelay:1;
-	spinlock_t	join_list_lock;
 	struct work_struct work;
 	struct sk_buff  *ooo_last_skb;
 	struct rb_root  out_of_order_queue;
@@ -509,15 +508,6 @@ mptcp_subflow_get_mapped_dsn(const struct mptcp_subflow_context *subflow)
 	return subflow->map_seq + mptcp_subflow_get_map_offset(subflow);
 }
 
-static inline void mptcp_add_pending_subflow(struct mptcp_sock *msk,
-					     struct mptcp_subflow_context *subflow)
-{
-	sock_hold(mptcp_subflow_tcp_sock(subflow));
-	spin_lock_bh(&msk->join_list_lock);
-	list_add_tail(&subflow->node, &msk->join_list);
-	spin_unlock_bh(&msk->join_list_lock);
-}
-
 void mptcp_subflow_process_delegated(struct sock *ssk);
 
 static inline void mptcp_subflow_delegate(struct mptcp_subflow_context *subflow, int action)
@@ -682,7 +672,6 @@ void __mptcp_data_acked(struct sock *sk);
 void __mptcp_error_report(struct sock *sk);
 void mptcp_subflow_eof(struct sock *sk);
 bool mptcp_update_rcv_data_fin(struct mptcp_sock *msk, u64 data_fin_seq, bool use_64bit);
-void __mptcp_flush_join_list(struct mptcp_sock *msk);
 static inline bool mptcp_data_fin_enabled(const struct mptcp_sock *msk)
 {
 	return READ_ONCE(msk->snd_data_fin_enable) &&
@@ -842,7 +831,7 @@ unsigned int mptcp_pm_get_subflows_max(struct mptcp_sock *msk);
 unsigned int mptcp_pm_get_local_addr_max(struct mptcp_sock *msk);
 
 void mptcp_sockopt_sync(struct mptcp_sock *msk, struct sock *ssk);
-void mptcp_sockopt_sync_all(struct mptcp_sock *msk);
+void mptcp_sockopt_sync_locked(struct mptcp_sock *msk, struct sock *ssk);
 
 static inline struct mptcp_ext *mptcp_get_ext(const struct sk_buff *skb)
 {
diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index aa3fcd86dbe2..dacf3cee0027 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -1285,27 +1285,15 @@ void mptcp_sockopt_sync(struct mptcp_sock *msk, struct sock *ssk)
 	}
 }
 
-void mptcp_sockopt_sync_all(struct mptcp_sock *msk)
+void mptcp_sockopt_sync_locked(struct mptcp_sock *msk, struct sock *ssk)
 {
-	struct mptcp_subflow_context *subflow;
-	struct sock *sk = (struct sock *)msk;
-	u32 seq;
-
-	seq = sockopt_seq_reset(sk);
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
 
-	mptcp_for_each_subflow(msk, subflow) {
-		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
-		u32 sseq = READ_ONCE(subflow->setsockopt_seq);
+	msk_owned_by_me(msk);
 
-		if (sseq != msk->setsockopt_seq) {
-			__mptcp_sockopt_sync(msk, ssk);
-			WRITE_ONCE(subflow->setsockopt_seq, seq);
-		} else if (sseq != seq) {
-			WRITE_ONCE(subflow->setsockopt_seq, seq);
-		}
+	if (READ_ONCE(subflow->setsockopt_seq) != msk->setsockopt_seq) {
+		sync_socket_options(msk, ssk);
 
-		cond_resched();
+		subflow->setsockopt_seq = msk->setsockopt_seq;
 	}
-
-	msk->setsockopt_seq = seq;
 }
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index d861307f7efe..a1cd39f97659 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1441,7 +1441,8 @@ int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
 	subflow->request_bkup = !!(flags & MPTCP_PM_ADDR_FLAG_BACKUP);
 	mptcp_info2sockaddr(remote, &addr, ssk->sk_family);
 
-	mptcp_add_pending_subflow(msk, subflow);
+	sock_hold(ssk);
+	list_add_tail(&subflow->node, &msk->conn_list);
 	err = kernel_connect(sf, (struct sockaddr *)&addr, addrlen, O_NONBLOCK);
 	if (err && err != -EINPROGRESS)
 		goto failed_unlink;
@@ -1452,9 +1453,7 @@ int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
 	return err;
 
 failed_unlink:
-	spin_lock_bh(&msk->join_list_lock);
 	list_del(&subflow->node);
-	spin_unlock_bh(&msk->join_list_lock);
 	sock_put(mptcp_subflow_tcp_sock(subflow));
 
 failed:
-- 
2.34.1

