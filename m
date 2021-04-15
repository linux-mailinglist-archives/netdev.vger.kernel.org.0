Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 597D236166E
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 01:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237961AbhDOXpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 19:45:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:63180 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234874AbhDOXpc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 19:45:32 -0400
IronPort-SDR: 7Is3m+IGzFqlQbzlK0xgqPn8idVYVCLUg5ZqnD9Zo9/3braSHz4frRKexi0sd5wPQlark0z1sM
 goa5ojsXtz/Q==
X-IronPort-AV: E=McAfee;i="6200,9189,9955"; a="215480159"
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="215480159"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2021 16:45:08 -0700
IronPort-SDR: 6ZJ/QtR3RtVOqP/JqGxlQ/gwc+Mjv8wWvWuGhMJ2HEOvDUBfljBugPoqPtezeej7t2d1Mk6njO
 nDBTe83UsWSA==
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="461793360"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.243.150])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2021 16:45:07 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 05/13] mptcp: tag sequence_seq with socket state
Date:   Thu, 15 Apr 2021 16:44:54 -0700
Message-Id: <20210415234502.224225-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415234502.224225-1-mathew.j.martineau@linux.intel.com>
References: <20210415234502.224225-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Paolo Abeni suggested to avoid re-syncing new subflows because
they inherit options from listener. In case options were set on
listener but are not set on mptcp-socket there is no need to
do any synchronisation for new subflows.

This change sets sockopt_seq of new mptcp sockets to the seq of
the mptcp listener sock.

Subflow sequence is set to the embedded tcp listener sk.
Add a comment explaing why sk_state is involved in sockopt_seq
generation.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 12 ++++++++---
 net/mptcp/protocol.h |  4 ++++
 net/mptcp/sockopt.c  | 47 ++++++++++++++++++++++++++++++++++++++++++--
 net/mptcp/subflow.c  |  4 ++++
 4 files changed, 62 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 1399d301d47f..5cba90948a7e 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -733,18 +733,23 @@ void mptcp_data_ready(struct sock *sk, struct sock *ssk)
 static bool mptcp_do_flush_join_list(struct mptcp_sock *msk)
 {
 	struct mptcp_subflow_context *subflow;
+	bool ret = false;
 
 	if (likely(list_empty(&msk->join_list)))
 		return false;
 
 	spin_lock_bh(&msk->join_list_lock);
-	list_for_each_entry(subflow, &msk->join_list, node)
-		mptcp_propagate_sndbuf((struct sock *)msk, mptcp_subflow_tcp_sock(subflow));
+	list_for_each_entry(subflow, &msk->join_list, node) {
+		u32 sseq = READ_ONCE(subflow->setsockopt_seq);
 
+		mptcp_propagate_sndbuf((struct sock *)msk, mptcp_subflow_tcp_sock(subflow));
+		if (READ_ONCE(msk->setsockopt_seq) != sseq)
+			ret = true;
+	}
 	list_splice_tail_init(&msk->join_list, &msk->conn_list);
 	spin_unlock_bh(&msk->join_list_lock);
 
-	return true;
+	return ret;
 }
 
 void __mptcp_flush_join_list(struct mptcp_sock *msk)
@@ -2718,6 +2723,7 @@ struct sock *mptcp_sk_clone(const struct sock *sk,
 	msk->snd_nxt = msk->write_seq;
 	msk->snd_una = msk->write_seq;
 	msk->wnd_end = msk->snd_nxt + req->rsk_rcv_wnd;
+	msk->setsockopt_seq = mptcp_sk(sk)->setsockopt_seq;
 
 	if (mp_opt->mp_capable) {
 		msk->can_ack = true;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 0186aad3108a..df269c26f145 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -256,6 +256,8 @@ struct mptcp_sock {
 		u64	time;	/* start time of measurement window */
 		u64	rtt_us; /* last maximum rtt of subflows */
 	} rcvq_space;
+
+	u32 setsockopt_seq;
 };
 
 #define mptcp_lock_sock(___sk, cb) do {					\
@@ -414,6 +416,8 @@ struct mptcp_subflow_context {
 	long	delegated_status;
 	struct	list_head delegated_node;   /* link into delegated_action, protected by local BH */
 
+	u32 setsockopt_seq;
+
 	struct	sock *tcp_sock;	    /* tcp sk backpointer */
 	struct	sock *conn;	    /* parent mptcp_sock */
 	const	struct inet_connection_sock_af_ops *icsk_af_ops;
diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index 4fdc0ad6acf7..27b49543fc58 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -24,6 +24,27 @@ static struct sock *__mptcp_tcp_fallback(struct mptcp_sock *msk)
 	return msk->first;
 }
 
+static u32 sockopt_seq_reset(const struct sock *sk)
+{
+	sock_owned_by_me(sk);
+
+	/* Highbits contain state.  Allows to distinguish sockopt_seq
+	 * of listener and established:
+	 * s0 = new_listener()
+	 * sockopt(s0) - seq is 1
+	 * s1 = accept(s0) - s1 inherits seq 1 if listener sk (s0)
+	 * sockopt(s0) - seq increments to 2 on s0
+	 * sockopt(s1) // seq increments to 2 on s1 (different option)
+	 * new ssk completes join, inherits options from s0 // seq 2
+	 * Needs sync from mptcp join logic, but ssk->seq == msk->seq
+	 *
+	 * Set High order bits to sk_state so ssk->seq == msk->seq test
+	 * will fail.
+	 */
+
+	return (u32)sk->sk_state << 24u;
+}
+
 static int mptcp_setsockopt_sol_socket(struct mptcp_sock *msk, int optname,
 				       sockptr_t optval, unsigned int optlen)
 {
@@ -350,22 +371,44 @@ int mptcp_getsockopt(struct sock *sk, int level, int optname,
 	return -EOPNOTSUPP;
 }
 
+static void __mptcp_sockopt_sync(struct mptcp_sock *msk, struct sock *ssk)
+{
+}
+
 void mptcp_sockopt_sync(struct mptcp_sock *msk, struct sock *ssk)
 {
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
+
 	msk_owned_by_me(msk);
+
+	if (READ_ONCE(subflow->setsockopt_seq) != msk->setsockopt_seq) {
+		__mptcp_sockopt_sync(msk, ssk);
+
+		subflow->setsockopt_seq = msk->setsockopt_seq;
+	}
 }
 
 void mptcp_sockopt_sync_all(struct mptcp_sock *msk)
 {
 	struct mptcp_subflow_context *subflow;
+	struct sock *sk = (struct sock *)msk;
+	u32 seq;
 
-	msk_owned_by_me(msk);
+	seq = sockopt_seq_reset(sk);
 
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+		u32 sseq = READ_ONCE(subflow->setsockopt_seq);
 
-		mptcp_sockopt_sync(msk, ssk);
+		if (sseq != msk->setsockopt_seq) {
+			__mptcp_sockopt_sync(msk, ssk);
+			WRITE_ONCE(subflow->setsockopt_seq, seq);
+		} else if (sseq != seq) {
+			WRITE_ONCE(subflow->setsockopt_seq, seq);
+		}
 
 		cond_resched();
 	}
+
+	msk->setsockopt_seq = seq;
 }
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 350c51c6bf9d..c3da84576b3c 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -679,6 +679,9 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 			goto out;
 		}
 
+		/* ssk inherits options of listener sk */
+		ctx->setsockopt_seq = listener->setsockopt_seq;
+
 		if (ctx->mp_capable) {
 			/* this can't race with mptcp_close(), as the msk is
 			 * not yet exposted to user-space
@@ -694,6 +697,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 			 * created mptcp socket
 			 */
 			new_msk->sk_destruct = mptcp_sock_destruct;
+			mptcp_sk(new_msk)->setsockopt_seq = ctx->setsockopt_seq;
 			mptcp_pm_new_connection(mptcp_sk(new_msk), child, 1);
 			mptcp_token_accept(subflow_req, mptcp_sk(new_msk));
 			ctx->conn = new_msk;
-- 
2.31.1

