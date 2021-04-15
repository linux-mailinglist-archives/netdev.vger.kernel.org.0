Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0683136166D
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 01:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237967AbhDOXpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 19:45:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:63174 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236592AbhDOXpc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 19:45:32 -0400
IronPort-SDR: Qy0Q1Z/dN+gLJybF89k3oyU0nHvU3/vu9m7vvgQAyJK00uZX3v2aG+lb6jiAlgTBJ0JqeECdtK
 R2lA6t2HV3DQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9955"; a="215480157"
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="215480157"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2021 16:45:08 -0700
IronPort-SDR: NNn7eCUoLZ+ny3a3VQ/a2+3DyveXdh9WBrIWtx8wayhdYqsZbqGNq2GhxvIoTTHWnbQwIebRoZ
 kgaEasyHrHVw==
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="461793357"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.243.150])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2021 16:45:07 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 04/13] mptcp: add skeleton to sync msk socket options to subflows
Date:   Thu, 15 Apr 2021 16:44:53 -0700
Message-Id: <20210415234502.224225-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415234502.224225-1-mathew.j.martineau@linux.intel.com>
References: <20210415234502.224225-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Handle following cases:
1. setsockopt is called with multiple subflows.
   Change might have to be mirrored to all of them.
   This is done directly in process context/setsockopt call.
2. Outgoing subflow is created after one or several setsockopt()
   calls have been made.  Old setsockopt changes should be
   synced to the new socket.
3. Incoming subflow, after setsockopt call(s).

Cases 2 and 3 are handled right after the join list is spliced to the conn
list.

Not all sockopt values can be just be copied by value, some require
helper calls.  Those can acquire socket lock (which can sleep).

If the join->conn list splicing is done from preemptible context,
synchronization can be done right away, otherwise its deferred to work
queue.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 41 +++++++++++++++++++++++++++++++++--------
 net/mptcp/protocol.h |  7 +++++++
 net/mptcp/sockopt.c  | 19 +++++++++++++++++++
 net/mptcp/subflow.c  |  1 +
 4 files changed, 60 insertions(+), 8 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index e0b381ae99af..1399d301d47f 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -730,18 +730,42 @@ void mptcp_data_ready(struct sock *sk, struct sock *ssk)
 		sk->sk_data_ready(sk);
 }
 
-void __mptcp_flush_join_list(struct mptcp_sock *msk)
+static bool mptcp_do_flush_join_list(struct mptcp_sock *msk)
 {
 	struct mptcp_subflow_context *subflow;
 
 	if (likely(list_empty(&msk->join_list)))
-		return;
+		return false;
 
 	spin_lock_bh(&msk->join_list_lock);
 	list_for_each_entry(subflow, &msk->join_list, node)
 		mptcp_propagate_sndbuf((struct sock *)msk, mptcp_subflow_tcp_sock(subflow));
+
 	list_splice_tail_init(&msk->join_list, &msk->conn_list);
 	spin_unlock_bh(&msk->join_list_lock);
+
+	return true;
+}
+
+void __mptcp_flush_join_list(struct mptcp_sock *msk)
+{
+	if (likely(!mptcp_do_flush_join_list(msk)))
+		return;
+
+	if (!test_and_set_bit(MPTCP_WORK_SYNC_SETSOCKOPT, &msk->flags))
+		mptcp_schedule_work((struct sock *)msk);
+}
+
+static void mptcp_flush_join_list(struct mptcp_sock *msk)
+{
+	bool sync_needed = test_and_clear_bit(MPTCP_WORK_SYNC_SETSOCKOPT, &msk->flags);
+
+	might_sleep();
+
+	if (!mptcp_do_flush_join_list(msk) && !sync_needed)
+		return;
+
+	mptcp_sockopt_sync_all(msk);
 }
 
 static bool mptcp_timer_pending(struct sock *sk)
@@ -1457,7 +1481,7 @@ static void __mptcp_push_pending(struct sock *sk, unsigned int flags)
 			int ret = 0;
 
 			prev_ssk = ssk;
-			__mptcp_flush_join_list(msk);
+			mptcp_flush_join_list(msk);
 			ssk = mptcp_subflow_get_send(msk);
 
 			/* try to keep the subflow socket lock across
@@ -1883,7 +1907,7 @@ static bool __mptcp_move_skbs(struct mptcp_sock *msk)
 	unsigned int moved = 0;
 	bool ret, done;
 
-	__mptcp_flush_join_list(msk);
+	mptcp_flush_join_list(msk);
 	do {
 		struct sock *ssk = mptcp_subflow_recv_lookup(msk);
 		bool slowpath;
@@ -2307,7 +2331,7 @@ static void mptcp_worker(struct work_struct *work)
 		goto unlock;
 
 	mptcp_check_data_fin_ack(sk);
-	__mptcp_flush_join_list(msk);
+	mptcp_flush_join_list(msk);
 
 	mptcp_check_fastclose(msk);
 
@@ -2507,7 +2531,7 @@ static void __mptcp_check_send_data_fin(struct sock *sk)
 		}
 	}
 
-	__mptcp_flush_join_list(msk);
+	mptcp_flush_join_list(msk);
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *tcp_sk = mptcp_subflow_tcp_sock(subflow);
 
@@ -2644,7 +2668,8 @@ static int mptcp_disconnect(struct sock *sk, int flags)
 	struct mptcp_subflow_context *subflow;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
-	__mptcp_flush_join_list(msk);
+	mptcp_do_flush_join_list(msk);
+
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 
@@ -3210,7 +3235,7 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 		/* set ssk->sk_socket of accept()ed flows to mptcp socket.
 		 * This is needed so NOSPACE flag can be set from tcp stack.
 		 */
-		__mptcp_flush_join_list(msk);
+		mptcp_flush_join_list(msk);
 		mptcp_for_each_subflow(msk, subflow) {
 			struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 14f0114be17a..0186aad3108a 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -108,6 +108,7 @@
 #define MPTCP_CLEAN_UNA		7
 #define MPTCP_ERROR_REPORT	8
 #define MPTCP_RETRANSMIT	9
+#define MPTCP_WORK_SYNC_SETSOCKOPT 10
 
 static inline bool before64(__u64 seq1, __u64 seq2)
 {
@@ -735,6 +736,12 @@ unsigned int mptcp_pm_get_add_addr_accept_max(struct mptcp_sock *msk);
 unsigned int mptcp_pm_get_subflows_max(struct mptcp_sock *msk);
 unsigned int mptcp_pm_get_local_addr_max(struct mptcp_sock *msk);
 
+int mptcp_setsockopt(struct sock *sk, int level, int optname,
+		     sockptr_t optval, unsigned int optlen);
+
+void mptcp_sockopt_sync(struct mptcp_sock *msk, struct sock *ssk);
+void mptcp_sockopt_sync_all(struct mptcp_sock *msk);
+
 static inline struct mptcp_ext *mptcp_get_ext(const struct sk_buff *skb)
 {
 	return (struct mptcp_ext *)skb_ext_find(skb, SKB_EXT_MPTCP);
diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index fb98fab252df..4fdc0ad6acf7 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -350,3 +350,22 @@ int mptcp_getsockopt(struct sock *sk, int level, int optname,
 	return -EOPNOTSUPP;
 }
 
+void mptcp_sockopt_sync(struct mptcp_sock *msk, struct sock *ssk)
+{
+	msk_owned_by_me(msk);
+}
+
+void mptcp_sockopt_sync_all(struct mptcp_sock *msk)
+{
+	struct mptcp_subflow_context *subflow;
+
+	msk_owned_by_me(msk);
+
+	mptcp_for_each_subflow(msk, subflow) {
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+
+		mptcp_sockopt_sync(msk, ssk);
+
+		cond_resched();
+	}
+}
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 3c19a5265a0f..350c51c6bf9d 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1317,6 +1317,7 @@ int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
 	mptcp_info2sockaddr(remote, &addr, ssk->sk_family);
 
 	mptcp_add_pending_subflow(msk, subflow);
+	mptcp_sockopt_sync(msk, ssk);
 	err = kernel_connect(sf, (struct sockaddr *)&addr, addrlen, O_NONBLOCK);
 	if (err && err != -EINPROGRESS)
 		goto failed_unlink;
-- 
2.31.1

