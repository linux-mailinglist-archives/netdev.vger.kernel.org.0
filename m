Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E44231565
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 00:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729849AbgG1WMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 18:12:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:2588 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729762AbgG1WMS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 18:12:18 -0400
IronPort-SDR: QHVpQ7W9Bl7fOhTKT6oTWgkW49yLQOEngDXqYWHJxuTWFKvZnw0qTizx1K+emupVGHC5JIGoGj
 tuLIxXfTbYMQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9696"; a="139342680"
X-IronPort-AV: E=Sophos;i="5.75,408,1589266800"; 
   d="scan'208";a="139342680"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2020 15:12:14 -0700
IronPort-SDR: KFrlaUtTzlJNgxKo9iRejgzpjRsgFfZZp2kE8WXI434s/U3/mBF7xI6qIrx55F/CyRm0Hkog/Q
 fUfJ9uWc5axQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,408,1589266800"; 
   d="scan'208";a="328468885"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.116.118])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Jul 2020 15:12:14 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        mptcp@lists.01.org, matthieu.baerts@tessares.net, pabeni@redhat.com
Subject: [PATCH net-next 05/12] mptcp: Track received DATA_FIN sequence number and add related helpers
Date:   Tue, 28 Jul 2020 15:12:03 -0700
Message-Id: <20200728221210.92841-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200728221210.92841-1-mathew.j.martineau@linux.intel.com>
References: <20200728221210.92841-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Incoming DATA_FIN headers need to propagate the presence of the DATA_FIN
bit and the associated sequence number to the MPTCP layer, even when
arriving on a bare ACK that does not get added to the receive queue. Add
structure members to store the DATA_FIN information and helpers to set
and check those values.

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c  |  16 +++++++
 net/mptcp/protocol.c | 106 +++++++++++++++++++++++++++++++++++++++----
 net/mptcp/protocol.h |   3 ++
 3 files changed, 115 insertions(+), 10 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index f157cb7e14c0..38583d1b9b5f 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -782,6 +782,22 @@ static void update_una(struct mptcp_sock *msk,
 	}
 }
 
+bool mptcp_update_rcv_data_fin(struct mptcp_sock *msk, u64 data_fin_seq)
+{
+	/* Skip if DATA_FIN was already received.
+	 * If updating simultaneously with the recvmsg loop, values
+	 * should match. If they mismatch, the peer is misbehaving and
+	 * we will prefer the most recent information.
+	 */
+	if (READ_ONCE(msk->rcv_data_fin) || !READ_ONCE(msk->first))
+		return false;
+
+	WRITE_ONCE(msk->rcv_data_fin_seq, data_fin_seq);
+	WRITE_ONCE(msk->rcv_data_fin, 1);
+
+	return true;
+}
+
 static bool add_addr_hmac_valid(struct mptcp_sock *msk,
 				struct mptcp_options_received *mp_opt)
 {
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index dd403ba3679a..e1c71bfd61a3 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -16,6 +16,7 @@
 #include <net/inet_hashtables.h>
 #include <net/protocol.h>
 #include <net/tcp.h>
+#include <net/tcp_states.h>
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 #include <net/transp_v6.h>
 #endif
@@ -163,6 +164,101 @@ static bool mptcp_subflow_dsn_valid(const struct mptcp_sock *msk,
 	return mptcp_subflow_data_available(ssk);
 }
 
+static bool mptcp_pending_data_fin(struct sock *sk, u64 *seq)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
+	if (READ_ONCE(msk->rcv_data_fin) &&
+	    ((1 << sk->sk_state) &
+	     (TCPF_ESTABLISHED | TCPF_FIN_WAIT1 | TCPF_FIN_WAIT2))) {
+		u64 rcv_data_fin_seq = READ_ONCE(msk->rcv_data_fin_seq);
+
+		if (msk->ack_seq == rcv_data_fin_seq) {
+			if (seq)
+				*seq = rcv_data_fin_seq;
+
+			return true;
+		}
+	}
+
+	return false;
+}
+
+static void mptcp_set_timeout(const struct sock *sk, const struct sock *ssk)
+{
+	long tout = ssk && inet_csk(ssk)->icsk_pending ?
+				      inet_csk(ssk)->icsk_timeout - jiffies : 0;
+
+	if (tout <= 0)
+		tout = mptcp_sk(sk)->timer_ival;
+	mptcp_sk(sk)->timer_ival = tout > 0 ? tout : TCP_RTO_MIN;
+}
+
+static void mptcp_check_data_fin(struct sock *sk)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	u64 rcv_data_fin_seq;
+
+	if (__mptcp_check_fallback(msk) || !msk->first)
+		return;
+
+	/* Need to ack a DATA_FIN received from a peer while this side
+	 * of the connection is in ESTABLISHED, FIN_WAIT1, or FIN_WAIT2.
+	 * msk->rcv_data_fin was set when parsing the incoming options
+	 * at the subflow level and the msk lock was not held, so this
+	 * is the first opportunity to act on the DATA_FIN and change
+	 * the msk state.
+	 *
+	 * If we are caught up to the sequence number of the incoming
+	 * DATA_FIN, send the DATA_ACK now and do state transition.  If
+	 * not caught up, do nothing and let the recv code send DATA_ACK
+	 * when catching up.
+	 */
+
+	if (mptcp_pending_data_fin(sk, &rcv_data_fin_seq)) {
+		struct mptcp_subflow_context *subflow;
+
+		msk->ack_seq++;
+		WRITE_ONCE(msk->rcv_data_fin, 0);
+
+		sk->sk_shutdown |= RCV_SHUTDOWN;
+
+		switch (sk->sk_state) {
+		case TCP_ESTABLISHED:
+			inet_sk_state_store(sk, TCP_CLOSE_WAIT);
+			break;
+		case TCP_FIN_WAIT1:
+			inet_sk_state_store(sk, TCP_CLOSING);
+			break;
+		case TCP_FIN_WAIT2:
+			inet_sk_state_store(sk, TCP_CLOSE);
+			// @@ Close subflows now?
+			break;
+		default:
+			/* Other states not expected */
+			WARN_ON_ONCE(1);
+			break;
+		}
+
+		mptcp_set_timeout(sk, NULL);
+		mptcp_for_each_subflow(msk, subflow) {
+			struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+
+			lock_sock(ssk);
+			tcp_send_ack(ssk);
+			release_sock(ssk);
+		}
+
+		sk->sk_state_change(sk);
+
+		if (sk->sk_shutdown == SHUTDOWN_MASK ||
+		    sk->sk_state == TCP_CLOSE)
+			sk_wake_async(sk, SOCK_WAKE_WAITD, POLL_HUP);
+		else
+			sk_wake_async(sk, SOCK_WAKE_WAITD, POLL_IN);
+	}
+}
+
 static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
 					   struct sock *ssk,
 					   unsigned int *bytes)
@@ -303,16 +399,6 @@ static void __mptcp_flush_join_list(struct mptcp_sock *msk)
 	spin_unlock_bh(&msk->join_list_lock);
 }
 
-static void mptcp_set_timeout(const struct sock *sk, const struct sock *ssk)
-{
-	long tout = ssk && inet_csk(ssk)->icsk_pending ?
-				      inet_csk(ssk)->icsk_timeout - jiffies : 0;
-
-	if (tout <= 0)
-		tout = mptcp_sk(sk)->timer_ival;
-	mptcp_sk(sk)->timer_ival = tout > 0 ? tout : TCP_RTO_MIN;
-}
-
 static bool mptcp_timer_pending(struct sock *sk)
 {
 	return timer_pending(&inet_csk(sk)->icsk_retransmit_timer);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 3f49cc105772..beb34b8a5363 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -193,12 +193,14 @@ struct mptcp_sock {
 	u64		remote_key;
 	u64		write_seq;
 	u64		ack_seq;
+	u64		rcv_data_fin_seq;
 	atomic64_t	snd_una;
 	unsigned long	timer_ival;
 	u32		token;
 	unsigned long	flags;
 	bool		can_ack;
 	bool		fully_established;
+	bool		rcv_data_fin;
 	bool		snd_data_fin_enable;
 	spinlock_t	join_list_lock;
 	struct work_struct work;
@@ -385,6 +387,7 @@ void mptcp_data_ready(struct sock *sk, struct sock *ssk);
 bool mptcp_finish_join(struct sock *sk);
 void mptcp_data_acked(struct sock *sk);
 void mptcp_subflow_eof(struct sock *sk);
+bool mptcp_update_rcv_data_fin(struct mptcp_sock *msk, u64 data_fin_seq);
 
 void __init mptcp_token_init(void);
 static inline void mptcp_token_init_request(struct request_sock *req)
-- 
2.28.0

