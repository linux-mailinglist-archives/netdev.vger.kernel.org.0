Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75A50231566
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 00:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729840AbgG1WMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 18:12:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:2596 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729437AbgG1WMS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 18:12:18 -0400
IronPort-SDR: 1F9h3JmoJ+sdsCUbUcnKfDAUokRaB0/f8JQd/oNZSF6+eBtvVtpVkkGH1vYmK187/4C3LoDCm8
 gWj7f8f3qAyA==
X-IronPort-AV: E=McAfee;i="6000,8403,9696"; a="139342688"
X-IronPort-AV: E=Sophos;i="5.75,408,1589266800"; 
   d="scan'208";a="139342688"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2020 15:12:15 -0700
IronPort-SDR: /Z9itb8eYx/BW8xf7XEYa9/j0AyXo6diC84uis3QushQyoOr6Mg1DecH+wx9KvGcsF2e5r2g16
 HxIzEqFHeRQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,408,1589266800"; 
   d="scan'208";a="328468890"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.254.116.118])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Jul 2020 15:12:14 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        mptcp@lists.01.org, matthieu.baerts@tessares.net, pabeni@redhat.com
Subject: [PATCH net-next 08/12] mptcp: Use full MPTCP-level disconnect state machine
Date:   Tue, 28 Jul 2020 15:12:06 -0700
Message-Id: <20200728221210.92841-9-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200728221210.92841-1-mathew.j.martineau@linux.intel.com>
References: <20200728221210.92841-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RFC 8684 appendix D describes the connection state machine for
MPTCP. This patch implements the DATA_FIN / DATA_ACK exchanges and
MPTCP-level socket state changes described in that appendix, rather than
simply sending DATA_FIN along with TCP FIN when disconnecting subflows.

DATA_FIN is now sent and acknowledged before shutting down the
subflows. Received DATA_FIN information (if not part of a data packet)
is written to the MPTCP socket when the incoming DSS option is parsed by
the subflow, and the MPTCP worker is scheduled to process the
flag. DATA_FIN received as part of a full DSS mapping will be handled
when the mapping is processed.

The DATA_FIN is acknowledged by the worker if the reader is caught
up. If there is still data to be moved to the MPTCP-level queue, ack_seq
will be incremented to account for the DATA_FIN when it reaches the end
of the stream and a DATA_ACK will be sent to the peer.

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c  | 11 ++++++
 net/mptcp/protocol.c | 87 +++++++++++++++++++++++++++++++++++++-------
 net/mptcp/subflow.c  | 11 ++++--
 3 files changed, 92 insertions(+), 17 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 38583d1b9b5f..b4458ecd01f8 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -868,6 +868,17 @@ void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb,
 	if (mp_opt.use_ack)
 		update_una(msk, &mp_opt);
 
+	/* Zero-length packets, like bare ACKs carrying a DATA_FIN, are
+	 * dropped by the caller and not propagated to the MPTCP layer.
+	 * Copy the DATA_FIN information now.
+	 */
+	if (TCP_SKB_CB(skb)->seq == TCP_SKB_CB(skb)->end_seq) {
+		if (mp_opt.data_fin && mp_opt.data_len == 1 &&
+		    mptcp_update_rcv_data_fin(msk, mp_opt.data_seq) &&
+		    schedule_work(&msk->work))
+			sock_hold(subflow->conn);
+	}
+
 	mpext = skb_ext_add(skb, SKB_EXT_MPTCP);
 	if (!mpext)
 		return;
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index b3350830e14d..f264ea15e081 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -381,6 +381,15 @@ static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
 
 	*bytes = moved;
 
+	/* If the moves have caught up with the DATA_FIN sequence number
+	 * it's time to ack the DATA_FIN and change socket state, but
+	 * this is not a good place to change state. Let the workqueue
+	 * do it.
+	 */
+	if (mptcp_pending_data_fin(sk, NULL) &&
+	    schedule_work(&msk->work))
+		sock_hold(sk);
+
 	return done;
 }
 
@@ -466,7 +475,8 @@ void mptcp_data_acked(struct sock *sk)
 {
 	mptcp_reset_timer(sk);
 
-	if (!sk_stream_is_writeable(sk) &&
+	if ((!sk_stream_is_writeable(sk) ||
+	     (inet_sk_state_load(sk) != TCP_ESTABLISHED)) &&
 	    schedule_work(&mptcp_sk(sk)->work))
 		sock_hold(sk);
 }
@@ -1384,6 +1394,7 @@ static void mptcp_worker(struct work_struct *work)
 
 	lock_sock(sk);
 	mptcp_clean_una(sk);
+	mptcp_check_data_fin_ack(sk);
 	__mptcp_flush_join_list(msk);
 	__mptcp_move_skbs(msk);
 
@@ -1393,6 +1404,8 @@ static void mptcp_worker(struct work_struct *work)
 	if (test_and_clear_bit(MPTCP_WORK_EOF, &msk->flags))
 		mptcp_check_for_eof(msk);
 
+	mptcp_check_data_fin(sk);
+
 	if (!test_and_clear_bit(MPTCP_WORK_RTX, &msk->flags))
 		goto unlock;
 
@@ -1515,7 +1528,7 @@ static void mptcp_cancel_work(struct sock *sk)
 		sock_put(sk);
 }
 
-static void mptcp_subflow_shutdown(struct sock *ssk, int how)
+static void mptcp_subflow_shutdown(struct sock *sk, struct sock *ssk, int how)
 {
 	lock_sock(ssk);
 
@@ -1528,8 +1541,15 @@ static void mptcp_subflow_shutdown(struct sock *ssk, int how)
 		tcp_disconnect(ssk, O_NONBLOCK);
 		break;
 	default:
-		ssk->sk_shutdown |= how;
-		tcp_shutdown(ssk, how);
+		if (__mptcp_check_fallback(mptcp_sk(sk))) {
+			pr_debug("Fallback");
+			ssk->sk_shutdown |= how;
+			tcp_shutdown(ssk, how);
+		} else {
+			pr_debug("Sending DATA_FIN on subflow %p", ssk);
+			mptcp_set_timeout(sk, ssk);
+			tcp_send_ack(ssk);
+		}
 		break;
 	}
 
@@ -1570,9 +1590,35 @@ static void mptcp_close(struct sock *sk, long timeout)
 	LIST_HEAD(conn_list);
 
 	lock_sock(sk);
+	sk->sk_shutdown = SHUTDOWN_MASK;
+
+	if (sk->sk_state == TCP_LISTEN) {
+		inet_sk_state_store(sk, TCP_CLOSE);
+		goto cleanup;
+	} else if (sk->sk_state == TCP_CLOSE) {
+		goto cleanup;
+	}
+
+	if (__mptcp_check_fallback(msk)) {
+		goto update_state;
+	} else if (mptcp_close_state(sk)) {
+		pr_debug("Sending DATA_FIN sk=%p", sk);
+		WRITE_ONCE(msk->write_seq, msk->write_seq + 1);
+		WRITE_ONCE(msk->snd_data_fin_enable, 1);
+
+		mptcp_for_each_subflow(msk, subflow) {
+			struct sock *tcp_sk = mptcp_subflow_tcp_sock(subflow);
+
+			mptcp_subflow_shutdown(sk, tcp_sk, SHUTDOWN_MASK);
+		}
+	}
 
+	sk_stream_wait_close(sk, timeout);
+
+update_state:
 	inet_sk_state_store(sk, TCP_CLOSE);
 
+cleanup:
 	/* be sure to always acquire the join list lock, to sync vs
 	 * mptcp_finish_join().
 	 */
@@ -1581,8 +1627,6 @@ static void mptcp_close(struct sock *sk, long timeout)
 	spin_unlock_bh(&msk->join_list_lock);
 	list_splice_init(&msk->conn_list, &conn_list);
 
-	msk->snd_data_fin_enable = 1;
-
 	__mptcp_clear_xmit(sk);
 
 	release_sock(sk);
@@ -2265,11 +2309,8 @@ static int mptcp_shutdown(struct socket *sock, int how)
 	pr_debug("sk=%p, how=%d", msk, how);
 
 	lock_sock(sock->sk);
-	if (how == SHUT_WR || how == SHUT_RDWR)
-		inet_sk_state_store(sock->sk, TCP_FIN_WAIT1);
 
 	how++;
-
 	if ((how & ~SHUTDOWN_MASK) || !how) {
 		ret = -EINVAL;
 		goto out_unlock;
@@ -2283,13 +2324,31 @@ static int mptcp_shutdown(struct socket *sock, int how)
 			sock->state = SS_CONNECTED;
 	}
 
-	__mptcp_flush_join_list(msk);
-	msk->snd_data_fin_enable = 1;
+	/* If we've already sent a FIN, or it's a closed state, skip this. */
+	if (__mptcp_check_fallback(msk)) {
+		if (how == SHUT_WR || how == SHUT_RDWR)
+			inet_sk_state_store(sock->sk, TCP_FIN_WAIT1);
 
-	mptcp_for_each_subflow(msk, subflow) {
-		struct sock *tcp_sk = mptcp_subflow_tcp_sock(subflow);
+		mptcp_for_each_subflow(msk, subflow) {
+			struct sock *tcp_sk = mptcp_subflow_tcp_sock(subflow);
 
-		mptcp_subflow_shutdown(tcp_sk, how);
+			mptcp_subflow_shutdown(sock->sk, tcp_sk, how);
+		}
+	} else if ((how & SEND_SHUTDOWN) &&
+		   ((1 << sock->sk->sk_state) &
+		    (TCPF_ESTABLISHED | TCPF_SYN_SENT |
+		     TCPF_SYN_RECV | TCPF_CLOSE_WAIT)) &&
+		   mptcp_close_state(sock->sk)) {
+		__mptcp_flush_join_list(msk);
+
+		WRITE_ONCE(msk->write_seq, msk->write_seq + 1);
+		WRITE_ONCE(msk->snd_data_fin_enable, 1);
+
+		mptcp_for_each_subflow(msk, subflow) {
+			struct sock *tcp_sk = mptcp_subflow_tcp_sock(subflow);
+
+			mptcp_subflow_shutdown(sock->sk, tcp_sk, how);
+		}
 	}
 
 	/* Wake up anyone sleeping in poll. */
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index e645483d1200..7ab2a52ad150 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -598,7 +598,8 @@ static bool validate_mapping(struct sock *ssk, struct sk_buff *skb)
 	return true;
 }
 
-static enum mapping_status get_mapping_status(struct sock *ssk)
+static enum mapping_status get_mapping_status(struct sock *ssk,
+					      struct mptcp_sock *msk)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
 	struct mptcp_ext *mpext;
@@ -648,7 +649,8 @@ static enum mapping_status get_mapping_status(struct sock *ssk)
 
 	if (mpext->data_fin == 1) {
 		if (data_len == 1) {
-			pr_debug("DATA_FIN with no payload");
+			mptcp_update_rcv_data_fin(msk, mpext->data_seq);
+			pr_debug("DATA_FIN with no payload seq=%llu", mpext->data_seq);
 			if (subflow->map_valid) {
 				/* A DATA_FIN might arrive in a DSS
 				 * option before the previous mapping
@@ -660,6 +662,9 @@ static enum mapping_status get_mapping_status(struct sock *ssk)
 			} else {
 				return MAPPING_DATA_FIN;
 			}
+		} else {
+			mptcp_update_rcv_data_fin(msk, mpext->data_seq + data_len);
+			pr_debug("DATA_FIN with mapping seq=%llu", mpext->data_seq + data_len);
 		}
 
 		/* Adjust for DATA_FIN using 1 byte of sequence space */
@@ -748,7 +753,7 @@ static bool subflow_check_data_avail(struct sock *ssk)
 		u64 ack_seq;
 		u64 old_ack;
 
-		status = get_mapping_status(ssk);
+		status = get_mapping_status(ssk, msk);
 		pr_debug("msk=%p ssk=%p status=%d", msk, ssk, status);
 		if (status == MAPPING_INVALID) {
 			ssk->sk_err = EBADMSG;
-- 
2.28.0

