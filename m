Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 565593EBE32
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 00:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235249AbhHMWQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 18:16:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:29030 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235007AbhHMWQX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 18:16:23 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10075"; a="212520897"
X-IronPort-AV: E=Sophos;i="5.84,320,1620716400"; 
   d="scan'208";a="212520897"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 15:15:55 -0700
X-IronPort-AV: E=Sophos;i="5.84,320,1620716400"; 
   d="scan'208";a="504320454"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.69.245])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 15:15:54 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 3/8] mptcp: handle pending data on closed subflow
Date:   Fri, 13 Aug 2021 15:15:43 -0700
Message-Id: <20210813221548.111990-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813221548.111990-1-mathew.j.martineau@linux.intel.com>
References: <20210813221548.111990-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

The PM can close active subflow, e.g. due to ingress RM_ADDR
option. Such subflow could carry data still unacked at the
MPTCP-level, both in the write and the rtx_queue, which has
never reached the other peer.

Currently the mptcp-level retransmission will deliver such data,
but at a very low rate (at most 1 DSM for each MPTCP rtx interval).

We can speed-up the recovery a lot, moving all the unacked in the
tcp write_queue, so that it will be pushed again via other
subflows, at the speed allowed by them.

Also make available the new helper for later patches.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/207
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c  |  8 +++--
 net/mptcp/protocol.c | 76 +++++++++++++++++++++++++++++++++++++++++---
 net/mptcp/protocol.h |  6 ++++
 3 files changed, 82 insertions(+), 8 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 4452455aef7f..e37b6f2fb514 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -975,9 +975,11 @@ static void ack_update_msk(struct mptcp_sock *msk,
 	old_snd_una = msk->snd_una;
 	new_snd_una = mptcp_expand_seq(old_snd_una, mp_opt->data_ack, mp_opt->ack64);
 
-	/* ACK for data not even sent yet? Ignore. */
-	if (after64(new_snd_una, snd_nxt))
-		new_snd_una = old_snd_una;
+	/* ACK for data not even sent yet and even above recovery bound? Ignore.*/
+	if (unlikely(after64(new_snd_una, snd_nxt))) {
+		if (!msk->recovery || after64(new_snd_una, msk->recovery_snd_nxt))
+			new_snd_una = old_snd_una;
+	}
 
 	new_wnd_end = new_snd_una + tcp_sk(ssk)->snd_wnd;
 
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index decbb4295ae1..5fafa7a4cd69 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1055,8 +1055,14 @@ static void __mptcp_clean_una(struct sock *sk)
 		if (after64(dfrag->data_seq + dfrag->data_len, snd_una))
 			break;
 
-		if (WARN_ON_ONCE(dfrag == msk->first_pending))
-			break;
+		if (unlikely(dfrag == msk->first_pending)) {
+			/* in recovery mode can see ack after the current snd head */
+			if (WARN_ON_ONCE(!msk->recovery))
+				break;
+
+			WRITE_ONCE(msk->first_pending, mptcp_send_next(sk));
+		}
+
 		dfrag_clear(sk, dfrag);
 		cleaned = true;
 	}
@@ -1065,8 +1071,14 @@ static void __mptcp_clean_una(struct sock *sk)
 	if (dfrag && after64(snd_una, dfrag->data_seq)) {
 		u64 delta = snd_una - dfrag->data_seq;
 
-		if (WARN_ON_ONCE(delta > dfrag->already_sent))
-			goto out;
+		/* prevent wrap around in recovery mode */
+		if (unlikely(delta > dfrag->already_sent)) {
+			if (WARN_ON_ONCE(!msk->recovery))
+				goto out;
+			if (WARN_ON_ONCE(delta > dfrag->data_len))
+				goto out;
+			dfrag->already_sent += delta - dfrag->already_sent;
+		}
 
 		dfrag->data_seq += delta;
 		dfrag->offset += delta;
@@ -1077,6 +1089,10 @@ static void __mptcp_clean_una(struct sock *sk)
 		cleaned = true;
 	}
 
+	/* all retransmitted data acked, recovery completed */
+	if (unlikely(msk->recovery) && after64(msk->snd_una, msk->recovery_snd_nxt))
+		msk->recovery = false;
+
 out:
 	if (cleaned) {
 		if (tcp_under_memory_pressure(sk)) {
@@ -1085,7 +1101,7 @@ static void __mptcp_clean_una(struct sock *sk)
 		}
 	}
 
-	if (snd_una == READ_ONCE(msk->snd_nxt)) {
+	if (snd_una == READ_ONCE(msk->snd_nxt) && !msk->recovery) {
 		if (mptcp_timer_pending(sk) && !mptcp_data_fin_enabled(msk))
 			mptcp_stop_timer(sk);
 	} else {
@@ -2148,6 +2164,50 @@ static void mptcp_dispose_initial_subflow(struct mptcp_sock *msk)
 	}
 }
 
+bool __mptcp_retransmit_pending_data(struct sock *sk)
+{
+	struct mptcp_data_frag *cur, *rtx_head;
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
+	if (__mptcp_check_fallback(mptcp_sk(sk)))
+		return false;
+
+	if (tcp_rtx_and_write_queues_empty(sk))
+		return false;
+
+	/* the closing socket has some data untransmitted and/or unacked:
+	 * some data in the mptcp rtx queue has not really xmitted yet.
+	 * keep it simple and re-inject the whole mptcp level rtx queue
+	 */
+	mptcp_data_lock(sk);
+	__mptcp_clean_una_wakeup(sk);
+	rtx_head = mptcp_rtx_head(sk);
+	if (!rtx_head) {
+		mptcp_data_unlock(sk);
+		return false;
+	}
+
+	/* will accept ack for reijected data before re-sending them */
+	if (!msk->recovery || after64(msk->snd_nxt, msk->recovery_snd_nxt))
+		msk->recovery_snd_nxt = msk->snd_nxt;
+	msk->recovery = true;
+	mptcp_data_unlock(sk);
+
+	msk->first_pending = rtx_head;
+	msk->tx_pending_data += msk->snd_nxt - rtx_head->data_seq;
+	msk->snd_nxt = rtx_head->data_seq;
+	msk->snd_burst = 0;
+
+	/* be sure to clear the "sent status" on all re-injected fragments */
+	list_for_each_entry(cur, &msk->rtx_queue, list) {
+		if (!cur->already_sent)
+			break;
+		cur->already_sent = 0;
+	}
+
+	return true;
+}
+
 /* subflow sockets can be either outgoing (connect) or incoming
  * (accept).
  *
@@ -2160,6 +2220,7 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 			      struct mptcp_subflow_context *subflow)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
+	bool need_push;
 
 	list_del(&subflow->node);
 
@@ -2171,6 +2232,7 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 	if (ssk->sk_socket)
 		sock_orphan(ssk);
 
+	need_push = __mptcp_retransmit_pending_data(sk);
 	subflow->disposable = 1;
 
 	/* if ssk hit tcp_done(), tcp_cleanup_ulp() cleared the related ops
@@ -2198,6 +2260,9 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 
 	if (msk->subflow && ssk == msk->subflow->sk)
 		mptcp_dispose_initial_subflow(msk);
+
+	if (need_push)
+		__mptcp_push_pending(sk, 0);
 }
 
 void mptcp_close_ssk(struct sock *sk, struct sock *ssk,
@@ -2410,6 +2475,7 @@ static int __mptcp_init_sock(struct sock *sk)
 	msk->first = NULL;
 	inet_csk(sk)->icsk_sync_mss = mptcp_sync_mss;
 	WRITE_ONCE(msk->csum_enabled, mptcp_is_checksum_enabled(sock_net(sk)));
+	msk->recovery = false;
 
 	mptcp_pm_data_init(msk);
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 6a3cbdb597e2..6f55784a2efd 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -230,12 +230,17 @@ struct mptcp_sock {
 	struct sock	*last_snd;
 	int		snd_burst;
 	int		old_wspace;
+	u64		recovery_snd_nxt;	/* in recovery mode accept up to this seq;
+						 * recovery related fields are under data_lock
+						 * protection
+						 */
 	u64		snd_una;
 	u64		wnd_end;
 	unsigned long	timer_ival;
 	u32		token;
 	int		rmem_released;
 	unsigned long	flags;
+	bool		recovery;		/* closing subflow write queue reinjected */
 	bool		can_ack;
 	bool		fully_established;
 	bool		rcv_data_fin;
@@ -557,6 +562,7 @@ int mptcp_is_checksum_enabled(struct net *net);
 int mptcp_allow_join_id0(struct net *net);
 void mptcp_subflow_fully_established(struct mptcp_subflow_context *subflow,
 				     struct mptcp_options_received *mp_opt);
+bool __mptcp_retransmit_pending_data(struct sock *sk);
 bool mptcp_subflow_data_available(struct sock *sk);
 void __init mptcp_subflow_init(void);
 void mptcp_subflow_shutdown(struct sock *sk, struct sock *ssk, int how);
-- 
2.32.0

