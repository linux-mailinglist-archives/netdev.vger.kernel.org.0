Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC8C73196AB
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 00:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbhBKXcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 18:32:42 -0500
Received: from mga05.intel.com ([192.55.52.43]:55192 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230101AbhBKXcf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 18:32:35 -0500
IronPort-SDR: 1hpPp08QBcgHZIfVzQ/Z/3FBegdikvH3s0NW9+036sG3IRjIwPr64HBs9BbOrd3AZgG22vgHs7
 EklOmEZW/wHw==
X-IronPort-AV: E=McAfee;i="6000,8403,9892"; a="267177932"
X-IronPort-AV: E=Sophos;i="5.81,172,1610438400"; 
   d="scan'208";a="267177932"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2021 15:30:48 -0800
IronPort-SDR: GzmGej0ss0yaxJc2w4hDTAhQt59jYJYHths2c+lMhdIT2VTEnAkqXyaK+Xf/kJgSQ6P4sXo7Xe
 Zfgdl370/wOg==
X-IronPort-AV: E=Sophos;i="5.81,172,1610438400"; 
   d="scan'208";a="381226381"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.100.224])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2021 15:30:48 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org, matthieu.baerts@tessares.net,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 1/6] mptcp: deliver ssk errors to msk
Date:   Thu, 11 Feb 2021 15:30:37 -0800
Message-Id: <20210211233042.304878-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211233042.304878-1-mathew.j.martineau@linux.intel.com>
References: <20210211233042.304878-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Currently all errors received on msk subflows are ignored.
We need to catch at least the errors on connect() and
on fallback sockets.

Use a custom sk_error_report callback at subflow level,
and do the real action under the msk socket lock - via
the usual sock_owned_by_user()/release_callback() schema.

Fixes: 6e628cd3a8f7 ("mptcp: use mptcp release_cb for delayed tasks")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c |  7 +++++++
 net/mptcp/protocol.h |  4 ++++
 net/mptcp/subflow.c  | 43 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 54 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index f998a077c7dd..9eecd1383d24 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2959,6 +2959,8 @@ static void mptcp_release_cb(struct sock *sk)
 		mptcp_push_pending(sk, 0);
 		spin_lock_bh(&sk->sk_lock.slock);
 	}
+	if (test_and_clear_bit(MPTCP_ERROR_REPORT, &mptcp_sk(sk)->flags))
+		__mptcp_error_report(sk);
 
 	/* clear any wmem reservation and errors */
 	__mptcp_update_wmem(sk);
@@ -3355,6 +3357,11 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 	if (sk->sk_shutdown & RCV_SHUTDOWN)
 		mask |= EPOLLIN | EPOLLRDNORM | EPOLLRDHUP;
 
+	/* This barrier is coupled with smp_wmb() in tcp_reset() */
+	smp_rmb();
+	if (sk->sk_err)
+		mask |= EPOLLERR;
+
 	return mask;
 }
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index d67de793d363..0743f48a0644 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -95,6 +95,7 @@
 #define MPTCP_WORK_CLOSE_SUBFLOW 5
 #define MPTCP_PUSH_PENDING	6
 #define MPTCP_CLEAN_UNA		7
+#define MPTCP_ERROR_REPORT	8
 
 static inline bool before64(__u64 seq1, __u64 seq2)
 {
@@ -414,6 +415,7 @@ struct mptcp_subflow_context {
 	void	(*tcp_data_ready)(struct sock *sk);
 	void	(*tcp_state_change)(struct sock *sk);
 	void	(*tcp_write_space)(struct sock *sk);
+	void	(*tcp_error_report)(struct sock *sk);
 
 	struct	rcu_head rcu;
 };
@@ -478,6 +480,7 @@ static inline void mptcp_subflow_tcp_fallback(struct sock *sk,
 	sk->sk_data_ready = ctx->tcp_data_ready;
 	sk->sk_state_change = ctx->tcp_state_change;
 	sk->sk_write_space = ctx->tcp_write_space;
+	sk->sk_error_report = ctx->tcp_error_report;
 
 	inet_csk(sk)->icsk_af_ops = ctx->icsk_af_ops;
 }
@@ -505,6 +508,7 @@ bool mptcp_finish_join(struct sock *sk);
 bool mptcp_schedule_work(struct sock *sk);
 void __mptcp_check_push(struct sock *sk, struct sock *ssk);
 void __mptcp_data_acked(struct sock *sk);
+void __mptcp_error_report(struct sock *sk);
 void mptcp_subflow_eof(struct sock *sk);
 bool mptcp_update_rcv_data_fin(struct mptcp_sock *msk, u64 data_fin_seq, bool use_64bit);
 void __mptcp_flush_join_list(struct mptcp_sock *msk);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 278cbe3e539e..0ec3ccac6bb4 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1043,6 +1043,46 @@ static void subflow_write_space(struct sock *ssk)
 	/* we take action in __mptcp_clean_una() */
 }
 
+void __mptcp_error_report(struct sock *sk)
+{
+	struct mptcp_subflow_context *subflow;
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
+	mptcp_for_each_subflow(msk, subflow) {
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+		int err = sock_error(ssk);
+
+		if (!err)
+			continue;
+
+		/* only propagate errors on fallen-back sockets or
+		 * on MPC connect
+		 */
+		if (sk->sk_state != TCP_SYN_SENT && !__mptcp_check_fallback(msk))
+			continue;
+
+		inet_sk_state_store(sk, inet_sk_state_load(ssk));
+		sk->sk_err = -err;
+
+		/* This barrier is coupled with smp_rmb() in mptcp_poll() */
+		smp_wmb();
+		sk->sk_error_report(sk);
+		break;
+	}
+}
+
+static void subflow_error_report(struct sock *ssk)
+{
+	struct sock *sk = mptcp_subflow_ctx(ssk)->conn;
+
+	mptcp_data_lock(sk);
+	if (!sock_owned_by_user(sk))
+		__mptcp_error_report(sk);
+	else
+		set_bit(MPTCP_ERROR_REPORT,  &mptcp_sk(sk)->flags);
+	mptcp_data_unlock(sk);
+}
+
 static struct inet_connection_sock_af_ops *
 subflow_default_af_ops(struct sock *sk)
 {
@@ -1352,9 +1392,11 @@ static int subflow_ulp_init(struct sock *sk)
 	ctx->tcp_data_ready = sk->sk_data_ready;
 	ctx->tcp_state_change = sk->sk_state_change;
 	ctx->tcp_write_space = sk->sk_write_space;
+	ctx->tcp_error_report = sk->sk_error_report;
 	sk->sk_data_ready = subflow_data_ready;
 	sk->sk_write_space = subflow_write_space;
 	sk->sk_state_change = subflow_state_change;
+	sk->sk_error_report = subflow_error_report;
 out:
 	return err;
 }
@@ -1407,6 +1449,7 @@ static void subflow_ulp_clone(const struct request_sock *req,
 	new_ctx->tcp_data_ready = old_ctx->tcp_data_ready;
 	new_ctx->tcp_state_change = old_ctx->tcp_state_change;
 	new_ctx->tcp_write_space = old_ctx->tcp_write_space;
+	new_ctx->tcp_error_report = old_ctx->tcp_error_report;
 	new_ctx->rel_write_seq = 1;
 	new_ctx->tcp_sock = newsk;
 
-- 
2.30.1

