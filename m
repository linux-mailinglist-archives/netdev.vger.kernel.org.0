Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76ECB3A3781
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 00:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbhFJXBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 19:01:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:55161 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230526AbhFJXBr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 19:01:47 -0400
IronPort-SDR: HU60PCyetlZjvmwtDzMBf8E/QcUVgBF+lED/aokNwQqHUcJQ1/OYyhH1s1/qzmJkGZuS6HtmEo
 zIehZyt9IPxg==
X-IronPort-AV: E=McAfee;i="6200,9189,10011"; a="205383807"
X-IronPort-AV: E=Sophos;i="5.83,264,1616482800"; 
   d="scan'208";a="205383807"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2021 15:59:50 -0700
IronPort-SDR: ec5UoZ6OCwQtzhOHKe+PcfiTIfVUDeGRy6dsV6Gc2qpv+KgyyjeUZQUL01id/UKl4fSL5ZcCEO
 HHg6we0CZO7A==
X-IronPort-AV: E=Sophos;i="5.83,264,1616482800"; 
   d="scan'208";a="441387043"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.70.185])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2021 15:59:50 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Maxim Galaganov <max@internet.ru>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 5/5] mptcp: fix soft lookup in subflow_error_report()
Date:   Thu, 10 Jun 2021 15:59:44 -0700
Message-Id: <20210610225944.351224-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210610225944.351224-1-mathew.j.martineau@linux.intel.com>
References: <20210610225944.351224-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Maxim reported a soft lookup in subflow_error_report():

 watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [swapper/0:0]
 RIP: 0010:native_queued_spin_lock_slowpath
 RSP: 0018:ffffa859c0003bc0 EFLAGS: 00000202
 RAX: 0000000000000101 RBX: 0000000000000001 RCX: 0000000000000000
 RDX: ffff9195c2772d88 RSI: 0000000000000000 RDI: ffff9195c2772d88
 RBP: ffff9195c2772d00 R08: 00000000000067b0 R09: c6e31da9eb1e44f4
 R10: ffff9195ef379700 R11: ffff9195edb50710 R12: ffff9195c2772d88
 R13: ffff9195f500e3d0 R14: ffff9195ef379700 R15: ffff9195ef379700
 FS:  0000000000000000(0000) GS:ffff91961f400000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 000000c000407000 CR3: 0000000002988000 CR4: 00000000000006f0
 Call Trace:
  <IRQ>
 _raw_spin_lock_bh
 subflow_error_report
 mptcp_subflow_data_available
 __mptcp_move_skbs_from_subflow
 mptcp_data_ready
 tcp_data_queue
 tcp_rcv_established
 tcp_v4_do_rcv
 tcp_v4_rcv
 ip_protocol_deliver_rcu
 ip_local_deliver_finish
 __netif_receive_skb_one_core
 netif_receive_skb
 rtl8139_poll 8139too
 __napi_poll
 net_rx_action
 __do_softirq
 __irq_exit_rcu
 common_interrupt
  </IRQ>

The calling function - mptcp_subflow_data_available() - can be invoked
from different contexts:
- plain ssk socket lock
- ssk socket lock + mptcp_data_lock
- ssk socket lock + mptcp_data_lock + msk socket lock.

Since subflow_error_report() tries to acquire the mptcp_data_lock, the
latter two call chains will cause soft lookup.

This change addresses the issue moving the error reporting call to
outer functions, where the held locks list is known and the we can
acquire only the needed one.

Reported-by: Maxim Galaganov <max@internet.ru>
Fixes: 15cc10453398 ("mptcp: deliver ssk errors to msk")
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/199
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c |  9 ++++++
 net/mptcp/subflow.c  | 75 +++++++++++++++++++++++---------------------
 2 files changed, 48 insertions(+), 36 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index f6e62a6dc9fb..632350018fb6 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -680,6 +680,12 @@ static bool move_skbs_to_msk(struct mptcp_sock *msk, struct sock *ssk)
 
 	__mptcp_move_skbs_from_subflow(msk, ssk, &moved);
 	__mptcp_ofo_queue(msk);
+	if (unlikely(ssk->sk_err)) {
+		if (!sock_owned_by_user(sk))
+			__mptcp_error_report(sk);
+		else
+			set_bit(MPTCP_ERROR_REPORT,  &msk->flags);
+	}
 
 	/* If the moves have caught up with the DATA_FIN sequence number
 	 * it's time to ack the DATA_FIN and change socket state, but
@@ -1948,6 +1954,9 @@ static bool __mptcp_move_skbs(struct mptcp_sock *msk)
 		done = __mptcp_move_skbs_from_subflow(msk, ssk, &moved);
 		mptcp_data_unlock(sk);
 		tcp_cleanup_rbuf(ssk, moved);
+
+		if (unlikely(ssk->sk_err))
+			__mptcp_error_report(sk);
 		unlock_sock_fast(ssk, slowpath);
 	} while (!done);
 
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index e05e05ec9687..be1de4084196 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1060,7 +1060,6 @@ static bool subflow_check_data_avail(struct sock *ssk)
 		 * subflow_error_report() will introduce the appropriate barriers
 		 */
 		ssk->sk_err = EBADMSG;
-		ssk->sk_error_report(ssk);
 		tcp_set_state(ssk, TCP_CLOSE);
 		subflow->reset_transient = 0;
 		subflow->reset_reason = MPTCP_RST_EMPTCP;
@@ -1115,41 +1114,6 @@ void mptcp_space(const struct sock *ssk, int *space, int *full_space)
 	*full_space = tcp_full_space(sk);
 }
 
-static void subflow_data_ready(struct sock *sk)
-{
-	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
-	u16 state = 1 << inet_sk_state_load(sk);
-	struct sock *parent = subflow->conn;
-	struct mptcp_sock *msk;
-
-	msk = mptcp_sk(parent);
-	if (state & TCPF_LISTEN) {
-		/* MPJ subflow are removed from accept queue before reaching here,
-		 * avoid stray wakeups
-		 */
-		if (reqsk_queue_empty(&inet_csk(sk)->icsk_accept_queue))
-			return;
-
-		set_bit(MPTCP_DATA_READY, &msk->flags);
-		parent->sk_data_ready(parent);
-		return;
-	}
-
-	WARN_ON_ONCE(!__mptcp_check_fallback(msk) && !subflow->mp_capable &&
-		     !subflow->mp_join && !(state & TCPF_CLOSE));
-
-	if (mptcp_subflow_data_available(sk))
-		mptcp_data_ready(parent, sk);
-}
-
-static void subflow_write_space(struct sock *ssk)
-{
-	struct sock *sk = mptcp_subflow_ctx(ssk)->conn;
-
-	mptcp_propagate_sndbuf(sk, ssk);
-	mptcp_write_space(sk);
-}
-
 void __mptcp_error_report(struct sock *sk)
 {
 	struct mptcp_subflow_context *subflow;
@@ -1190,6 +1154,43 @@ static void subflow_error_report(struct sock *ssk)
 	mptcp_data_unlock(sk);
 }
 
+static void subflow_data_ready(struct sock *sk)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+	u16 state = 1 << inet_sk_state_load(sk);
+	struct sock *parent = subflow->conn;
+	struct mptcp_sock *msk;
+
+	msk = mptcp_sk(parent);
+	if (state & TCPF_LISTEN) {
+		/* MPJ subflow are removed from accept queue before reaching here,
+		 * avoid stray wakeups
+		 */
+		if (reqsk_queue_empty(&inet_csk(sk)->icsk_accept_queue))
+			return;
+
+		set_bit(MPTCP_DATA_READY, &msk->flags);
+		parent->sk_data_ready(parent);
+		return;
+	}
+
+	WARN_ON_ONCE(!__mptcp_check_fallback(msk) && !subflow->mp_capable &&
+		     !subflow->mp_join && !(state & TCPF_CLOSE));
+
+	if (mptcp_subflow_data_available(sk))
+		mptcp_data_ready(parent, sk);
+	else if (unlikely(sk->sk_err))
+		subflow_error_report(sk);
+}
+
+static void subflow_write_space(struct sock *ssk)
+{
+	struct sock *sk = mptcp_subflow_ctx(ssk)->conn;
+
+	mptcp_propagate_sndbuf(sk, ssk);
+	mptcp_write_space(sk);
+}
+
 static struct inet_connection_sock_af_ops *
 subflow_default_af_ops(struct sock *sk)
 {
@@ -1500,6 +1501,8 @@ static void subflow_state_change(struct sock *sk)
 	 */
 	if (mptcp_subflow_data_available(sk))
 		mptcp_data_ready(parent, sk);
+	else if (unlikely(sk->sk_err))
+		subflow_error_report(sk);
 
 	subflow_sched_work_if_closed(mptcp_sk(parent), sk);
 
-- 
2.32.0

