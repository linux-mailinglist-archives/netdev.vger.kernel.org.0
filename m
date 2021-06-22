Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86E9C3B0DA3
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 21:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232754AbhFVT1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 15:27:55 -0400
Received: from mga12.intel.com ([192.55.52.136]:32268 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230330AbhFVT1s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 15:27:48 -0400
IronPort-SDR: uBvW7esIjfgTkiWRzB0mVSCp0sbNhbnzsbSkcx3X6Vm43DMJvx0DpUHkhvJ8FGzPS3CE1emom8
 2H9xc0vcefiA==
X-IronPort-AV: E=McAfee;i="6200,9189,10023"; a="186818206"
X-IronPort-AV: E=Sophos;i="5.83,292,1616482800"; 
   d="scan'208";a="186818206"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2021 12:25:32 -0700
IronPort-SDR: /GhKn+eunOi1y7K6YHr1MqOu1Pt9Y0eAPLCwkd3GpV8eSkCSbMWFz0ZI6KpQHTi9tSO0XQyFQO
 52k7ZpIa/WMA==
X-IronPort-AV: E=Sophos;i="5.83,292,1616482800"; 
   d="scan'208";a="480909729"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.237.182])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2021 12:25:30 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 6/6] mptcp: refine mptcp_cleanup_rbuf
Date:   Tue, 22 Jun 2021 12:25:23 -0700
Message-Id: <20210622192523.90117-7-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210622192523.90117-1-mathew.j.martineau@linux.intel.com>
References: <20210622192523.90117-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

The current cleanup rbuf tries a bit too hard to avoid acquiring
the subflow socket lock. We may end-up delaying the needed ack,
or skip acking a blocked subflow.

Address the above extending the conditions used to trigger the cleanup
to reflect more closely what TCP does and invoking tcp_cleanup_rbuf()
on all the active subflows.

Note that we can't replicate the exact tests implemented in
tcp_cleanup_rbuf(), as MPTCP lacks some of the required info - e.g.
ping-pong mode.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 56 ++++++++++++++++++--------------------------
 net/mptcp/protocol.h |  1 -
 2 files changed, 23 insertions(+), 34 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index cf75be02eb00..ce0c45dfb79e 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -442,49 +442,46 @@ static void mptcp_send_ack(struct mptcp_sock *msk)
 	}
 }
 
-static bool mptcp_subflow_cleanup_rbuf(struct sock *ssk)
+static void mptcp_subflow_cleanup_rbuf(struct sock *ssk)
 {
 	bool slow;
-	int ret;
 
 	slow = lock_sock_fast(ssk);
-	ret = tcp_can_send_ack(ssk);
-	if (ret)
+	if (tcp_can_send_ack(ssk))
 		tcp_cleanup_rbuf(ssk, 1);
 	unlock_sock_fast(ssk, slow);
-	return ret;
+}
+
+static bool mptcp_subflow_could_cleanup(const struct sock *ssk, bool rx_empty)
+{
+	const struct inet_connection_sock *icsk = inet_csk(ssk);
+	bool ack_pending = READ_ONCE(icsk->icsk_ack.pending);
+	const struct tcp_sock *tp = tcp_sk(ssk);
+
+	return (ack_pending & ICSK_ACK_SCHED) &&
+		((READ_ONCE(tp->rcv_nxt) - READ_ONCE(tp->rcv_wup) >
+		  READ_ONCE(icsk->icsk_ack.rcv_mss)) ||
+		 (rx_empty && ack_pending &
+			      (ICSK_ACK_PUSHED2 | ICSK_ACK_PUSHED)));
 }
 
 static void mptcp_cleanup_rbuf(struct mptcp_sock *msk)
 {
-	struct sock *ack_hint = READ_ONCE(msk->ack_hint);
 	int old_space = READ_ONCE(msk->old_wspace);
 	struct mptcp_subflow_context *subflow;
 	struct sock *sk = (struct sock *)msk;
-	bool cleanup;
+	int space =  __mptcp_space(sk);
+	bool cleanup, rx_empty;
 
-	/* this is a simple superset of what tcp_cleanup_rbuf() implements
-	 * so that we don't have to acquire the ssk socket lock most of the time
-	 * to do actually nothing
-	 */
-	cleanup = __mptcp_space(sk) - old_space >= max(0, old_space);
-	if (!cleanup)
-		return;
+	cleanup = (space > 0) && (space >= (old_space << 1));
+	rx_empty = !atomic_read(&sk->sk_rmem_alloc);
 
-	/* if the hinted ssk is still active, try to use it */
-	if (likely(ack_hint)) {
-		mptcp_for_each_subflow(msk, subflow) {
-			struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+	mptcp_for_each_subflow(msk, subflow) {
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 
-			if (ack_hint == ssk && mptcp_subflow_cleanup_rbuf(ssk))
-				return;
-		}
+		if (cleanup || mptcp_subflow_could_cleanup(ssk, rx_empty))
+			mptcp_subflow_cleanup_rbuf(ssk);
 	}
-
-	/* otherwise pick the first active subflow */
-	mptcp_for_each_subflow(msk, subflow)
-		if (mptcp_subflow_cleanup_rbuf(mptcp_subflow_tcp_sock(subflow)))
-			return;
 }
 
 static bool mptcp_check_data_fin(struct sock *sk)
@@ -629,7 +626,6 @@ static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
 			break;
 		}
 	} while (more_data_avail);
-	WRITE_ONCE(msk->ack_hint, ssk);
 
 	*bytes += moved;
 	return done;
@@ -1910,7 +1906,6 @@ static bool __mptcp_move_skbs(struct mptcp_sock *msk)
 		__mptcp_update_rmem(sk);
 		done = __mptcp_move_skbs_from_subflow(msk, ssk, &moved);
 		mptcp_data_unlock(sk);
-		tcp_cleanup_rbuf(ssk, moved);
 
 		if (unlikely(ssk->sk_err))
 			__mptcp_error_report(sk);
@@ -1926,7 +1921,6 @@ static bool __mptcp_move_skbs(struct mptcp_sock *msk)
 		ret |= __mptcp_ofo_queue(msk);
 		__mptcp_splice_receive_queue(sk);
 		mptcp_data_unlock(sk);
-		mptcp_cleanup_rbuf(msk);
 	}
 	if (ret)
 		mptcp_check_data_fin((struct sock *)msk);
@@ -2175,9 +2169,6 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 	if (ssk == msk->last_snd)
 		msk->last_snd = NULL;
 
-	if (ssk == msk->ack_hint)
-		msk->ack_hint = NULL;
-
 	if (ssk == msk->first)
 		msk->first = NULL;
 
@@ -2392,7 +2383,6 @@ static int __mptcp_init_sock(struct sock *sk)
 	msk->rmem_released = 0;
 	msk->tx_pending_data = 0;
 
-	msk->ack_hint = NULL;
 	msk->first = NULL;
 	inet_csk(sk)->icsk_sync_mss = mptcp_sync_mss;
 	WRITE_ONCE(msk->csum_enabled, mptcp_is_checksum_enabled(sock_net(sk)));
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index f4eaa5f57e3f..d8ad3270dfab 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -243,7 +243,6 @@ struct mptcp_sock {
 	bool		use_64bit_ack; /* Set when we received a 64-bit DSN */
 	bool		csum_enabled;
 	spinlock_t	join_list_lock;
-	struct sock	*ack_hint;
 	struct work_struct work;
 	struct sk_buff  *ooo_last_skb;
 	struct rb_root  out_of_order_queue;
-- 
2.32.0

