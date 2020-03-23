Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3133C190053
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 22:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgCWV3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 17:29:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:60326 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727093AbgCWV3g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 17:29:36 -0400
IronPort-SDR: gIZagAfC5m39mL2RZy1aKjroL8mTjIB451OJVf9lyraw9Icmnkcf7qjtQqjfu/ajPmY31a7lOQ
 zWnliqSWztCw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2020 14:29:35 -0700
IronPort-SDR: JHgj9we9+MTP5m2n2KbK1o0t89w2yL1IxDpkby3qkEecT30cfztb0FCvflQZXRh9yU6YJ90M7K
 FmbKY3heWnkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,297,1580803200"; 
   d="scan'208";a="445960401"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.254.100.76])
  by fmsmga005.fm.intel.com with ESMTP; 23 Mar 2020 14:29:33 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Peter Krystad <peter.krystad@linux.intel.com>,
        eric.dumazet@gmail.com, Florian Westphal <fw@strlen.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 04/17] mptcp: Add handling of outgoing MP_JOIN requests
Date:   Mon, 23 Mar 2020 14:26:29 -0700
Message-Id: <20200323212642.34104-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200323212642.34104-1-mathew.j.martineau@linux.intel.com>
References: <20200323212642.34104-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Krystad <peter.krystad@linux.intel.com>

Subflow creation may be initiated by the path manager when
the primary connection is fully established and a remote
address has been received via ADD_ADDR.

Create an in-kernel sock and use kernel_connect() to
initiate connection.

Passive sockets can't acquire the mptcp socket lock at
subflow creation time, so an additional list protected by
a new spinlock is used to track the MPJ subflows.

Such list is spliced into conn_list tail every time the msk
socket lock is acquired, so that it will not interfere
with data flow on the original connection.

Data flow and connection failover not addressed by this commit.

Co-developed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/net/mptcp.h  |   2 +
 net/mptcp/options.c  | 108 +++++++++++++++++++++++++++----
 net/mptcp/protocol.c |  31 ++++++++-
 net/mptcp/protocol.h |  13 ++++
 net/mptcp/subflow.c  | 150 ++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 287 insertions(+), 17 deletions(-)

diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index a4aea0e4addc..b648fa20eec8 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -46,6 +46,8 @@ struct mptcp_out_options {
 	u8 backup;
 	u32 nonce;
 	u64 thmac;
+	u32 token;
+	u8 hmac[20];
 	struct mptcp_ext ext_copy;
 #endif
 };
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 8e2b2dbadf6d..20ba00865c55 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -328,6 +328,16 @@ bool mptcp_syn_options(struct sock *sk, const struct sk_buff *skb,
 		opts->sndr_key = subflow->local_key;
 		*size = TCPOLEN_MPTCP_MPC_SYN;
 		return true;
+	} else if (subflow->request_join) {
+		pr_debug("remote_token=%u, nonce=%u", subflow->remote_token,
+			 subflow->local_nonce);
+		opts->suboptions = OPTION_MPTCP_MPJ_SYN;
+		opts->join_id = subflow->local_id;
+		opts->token = subflow->remote_token;
+		opts->nonce = subflow->local_nonce;
+		opts->backup = subflow->request_bkup;
+		*size = TCPOLEN_MPTCP_MPJ_SYN;
+		return true;
 	}
 	return false;
 }
@@ -337,16 +347,55 @@ void mptcp_rcv_synsent(struct sock *sk)
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 
-	pr_debug("subflow=%p", subflow);
 	if (subflow->request_mptcp && tp->rx_opt.mptcp.mp_capable) {
 		subflow->mp_capable = 1;
 		subflow->can_ack = 1;
 		subflow->remote_key = tp->rx_opt.mptcp.sndr_key;
-	} else {
+		pr_debug("subflow=%p, remote_key=%llu", subflow,
+			 subflow->remote_key);
+	} else if (subflow->request_join && tp->rx_opt.mptcp.mp_join) {
+		subflow->mp_join = 1;
+		subflow->thmac = tp->rx_opt.mptcp.thmac;
+		subflow->remote_nonce = tp->rx_opt.mptcp.nonce;
+		pr_debug("subflow=%p, thmac=%llu, remote_nonce=%u", subflow,
+			 subflow->thmac, subflow->remote_nonce);
+	} else if (subflow->request_mptcp) {
 		tcp_sk(sk)->is_mptcp = 0;
 	}
 }
 
+/* MP_JOIN client subflow must wait for 4th ack before sending any data:
+ * TCP can't schedule delack timer before the subflow is fully established.
+ * MPTCP uses the delack timer to do 3rd ack retransmissions
+ */
+static void schedule_3rdack_retransmission(struct sock *sk)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+	struct tcp_sock *tp = tcp_sk(sk);
+	unsigned long timeout;
+
+	/* reschedule with a timeout above RTT, as we must look only for drop */
+	if (tp->srtt_us)
+		timeout = tp->srtt_us << 1;
+	else
+		timeout = TCP_TIMEOUT_INIT;
+
+	WARN_ON_ONCE(icsk->icsk_ack.pending & ICSK_ACK_TIMER);
+	icsk->icsk_ack.pending |= ICSK_ACK_SCHED | ICSK_ACK_TIMER;
+	icsk->icsk_ack.timeout = timeout;
+	sk_reset_timer(sk, &icsk->icsk_delack_timer, timeout);
+}
+
+static void clear_3rdack_retransmission(struct sock *sk)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+
+	sk_stop_timer(sk, &icsk->icsk_delack_timer);
+	icsk->icsk_ack.timeout = 0;
+	icsk->icsk_ack.ato = 0;
+	icsk->icsk_ack.pending &= ~(ICSK_ACK_SCHED | ICSK_ACK_TIMER);
+}
+
 static bool mptcp_established_options_mp(struct sock *sk, struct sk_buff *skb,
 					 unsigned int *size,
 					 unsigned int remaining,
@@ -356,17 +405,21 @@ static bool mptcp_established_options_mp(struct sock *sk, struct sk_buff *skb,
 	struct mptcp_ext *mpext;
 	unsigned int data_len;
 
-	pr_debug("subflow=%p fully established=%d seq=%x:%x remaining=%d",
-		 subflow, subflow->fully_established, subflow->snd_isn,
-		 skb ? TCP_SKB_CB(skb)->seq : 0, remaining);
+	/* When skb is not available, we better over-estimate the emitted
+	 * options len. A full DSS option (28 bytes) is longer than
+	 * TCPOLEN_MPTCP_MPC_ACK_DATA(22) or TCPOLEN_MPTCP_MPJ_ACK(24), so
+	 * tell the caller to defer the estimate to
+	 * mptcp_established_options_dss(), which will reserve enough space.
+	 */
+	if (!skb)
+		return false;
 
-	if (subflow->mp_capable && !subflow->fully_established && skb &&
-	    subflow->snd_isn == TCP_SKB_CB(skb)->seq) {
-		/* When skb is not available, we better over-estimate the
-		 * emitted options len. A full DSS option is longer than
-		 * TCPOLEN_MPTCP_MPC_ACK_DATA, so let's the caller try to fit
-		 * that.
-		 */
+	/* MPC/MPJ needed only on 3rd ack packet */
+	if (subflow->fully_established ||
+	    subflow->snd_isn != TCP_SKB_CB(skb)->seq)
+		return false;
+
+	if (subflow->mp_capable) {
 		mpext = mptcp_get_ext(skb);
 		data_len = mpext ? mpext->data_len : 0;
 
@@ -394,6 +447,14 @@ static bool mptcp_established_options_mp(struct sock *sk, struct sk_buff *skb,
 			 data_len);
 
 		return true;
+	} else if (subflow->mp_join) {
+		opts->suboptions = OPTION_MPTCP_MPJ_ACK;
+		memcpy(opts->hmac, subflow->hmac, MPTCPOPT_HMAC_LEN);
+		*size = TCPOLEN_MPTCP_MPJ_ACK;
+		pr_debug("subflow=%p", subflow);
+
+		schedule_3rdack_retransmission(sk);
+		return true;
 	}
 	return false;
 }
@@ -674,10 +735,12 @@ static bool check_fully_established(struct mptcp_sock *msk, struct sock *sk,
 		return true;
 
 	subflow->pm_notified = 1;
-	if (subflow->mp_join)
+	if (subflow->mp_join) {
+		clear_3rdack_retransmission(sk);
 		mptcp_pm_subflow_established(msk, subflow);
-	else
+	} else {
 		mptcp_pm_fully_established(msk);
+	}
 	return true;
 }
 
@@ -860,6 +923,16 @@ void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
 				      0, opts->rm_id);
 	}
 
+	if (OPTION_MPTCP_MPJ_SYN & opts->suboptions) {
+		*ptr++ = mptcp_option(MPTCPOPT_MP_JOIN,
+				      TCPOLEN_MPTCP_MPJ_SYN,
+				      opts->backup, opts->join_id);
+		put_unaligned_be32(opts->token, ptr);
+		ptr += 1;
+		put_unaligned_be32(opts->nonce, ptr);
+		ptr += 1;
+	}
+
 	if (OPTION_MPTCP_MPJ_SYNACK & opts->suboptions) {
 		*ptr++ = mptcp_option(MPTCPOPT_MP_JOIN,
 				      TCPOLEN_MPTCP_MPJ_SYNACK,
@@ -870,6 +943,13 @@ void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
 		ptr += 1;
 	}
 
+	if (OPTION_MPTCP_MPJ_ACK & opts->suboptions) {
+		*ptr++ = mptcp_option(MPTCPOPT_MP_JOIN,
+				      TCPOLEN_MPTCP_MPJ_ACK, 0, 0);
+		memcpy(ptr, opts->hmac, MPTCPOPT_HMAC_LEN);
+		ptr += 5;
+	}
+
 	if (opts->ext_copy.use_ack || opts->ext_copy.use_map) {
 		struct mptcp_ext *mpext = &opts->ext_copy;
 		u8 len = TCPOLEN_MPTCP_DSS_BASE;
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index a9a7fac6fb5a..84c28b4326ff 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -241,6 +241,16 @@ void mptcp_data_ready(struct sock *sk, struct sock *ssk)
 	sk->sk_data_ready(sk);
 }
 
+static void __mptcp_flush_join_list(struct mptcp_sock *msk)
+{
+	if (likely(list_empty(&msk->join_list)))
+		return;
+
+	spin_lock_bh(&msk->join_list_lock);
+	list_splice_tail_init(&msk->join_list, &msk->conn_list);
+	spin_unlock_bh(&msk->join_list_lock);
+}
+
 static bool mptcp_ext_cache_refill(struct mptcp_sock *msk)
 {
 	if (!msk->cached_ext)
@@ -462,6 +472,7 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		return ret >= 0 ? ret + copied : (copied ? copied : ret);
 	}
 
+	__mptcp_flush_join_list(msk);
 	ssk = mptcp_subflow_get_send(msk);
 	while (!sk_stream_memory_free(sk) || !ssk) {
 		ret = sk_stream_wait_memory(sk, &timeo);
@@ -603,6 +614,7 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 
 	len = min_t(size_t, len, INT_MAX);
 	target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);
+	__mptcp_flush_join_list(msk);
 
 	while (len > (size_t)copied) {
 		int bytes_read;
@@ -718,6 +730,7 @@ static void mptcp_worker(struct work_struct *work)
 	struct sock *sk = &msk->sk.icsk_inet.sk;
 
 	lock_sock(sk);
+	__mptcp_flush_join_list(msk);
 	__mptcp_move_skbs(msk);
 	release_sock(sk);
 	sock_put(sk);
@@ -727,7 +740,10 @@ static int __mptcp_init_sock(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
+	spin_lock_init(&msk->join_list_lock);
+
 	INIT_LIST_HEAD(&msk->conn_list);
+	INIT_LIST_HEAD(&msk->join_list);
 	__set_bit(MPTCP_SEND_SPACE, &msk->flags);
 	INIT_WORK(&msk->work, mptcp_worker);
 
@@ -800,6 +816,8 @@ static void mptcp_close(struct sock *sk, long timeout)
 	mptcp_token_destroy(msk->token);
 	inet_sk_state_store(sk, TCP_CLOSE);
 
+	__mptcp_flush_join_list(msk);
+
 	list_splice_init(&msk->conn_list, &conn_list);
 
 	data_fin_tx_seq = msk->write_seq;
@@ -1111,6 +1129,7 @@ bool mptcp_finish_join(struct sock *sk)
 	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
 	struct sock *parent = (void *)msk;
 	struct socket *parent_sock;
+	bool ret;
 
 	pr_debug("msk=%p, subflow=%p", msk, subflow);
 
@@ -1126,7 +1145,15 @@ bool mptcp_finish_join(struct sock *sk)
 	if (parent_sock && !sk->sk_socket)
 		mptcp_sock_graft(sk, parent_sock);
 
-	return mptcp_pm_allow_new_subflow(msk);
+	ret = mptcp_pm_allow_new_subflow(msk);
+	if (ret) {
+		/* active connections are already on conn_list */
+		spin_lock_bh(&msk->join_list_lock);
+		if (!WARN_ON_ONCE(!list_empty(&subflow->node)))
+			list_add_tail(&subflow->node, &msk->join_list);
+		spin_unlock_bh(&msk->join_list_lock);
+	}
+	return ret;
 }
 
 bool mptcp_sk_is_subflow(const struct sock *sk)
@@ -1315,6 +1342,7 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 		/* set ssk->sk_socket of accept()ed flows to mptcp socket.
 		 * This is needed so NOSPACE flag can be set from tcp stack.
 		 */
+		__mptcp_flush_join_list(msk);
 		list_for_each_entry(subflow, &msk->conn_list, node) {
 			struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 
@@ -1396,6 +1424,7 @@ static int mptcp_shutdown(struct socket *sock, int how)
 			sock->state = SS_CONNECTED;
 	}
 
+	__mptcp_flush_join_list(msk);
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *tcp_sk = mptcp_subflow_tcp_sock(subflow);
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index ef94e36b8560..df134ac91274 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -59,8 +59,10 @@
 #define TCPOLEN_MPTCP_PORT_LEN		2
 #define TCPOLEN_MPTCP_RM_ADDR_BASE	4
 
+/* MPTCP MP_JOIN flags */
 #define MPTCPOPT_BACKUP		BIT(0)
 #define MPTCPOPT_HMAC_LEN	20
+#define MPTCPOPT_THMAC_LEN	8
 
 /* MPTCP MP_CAPABLE flags */
 #define MPTCP_VERSION_MASK	(0x0F)
@@ -148,8 +150,10 @@ struct mptcp_sock {
 	u32		token;
 	unsigned long	flags;
 	bool		can_ack;
+	spinlock_t	join_list_lock;
 	struct work_struct work;
 	struct list_head conn_list;
+	struct list_head join_list;
 	struct skb_ext	*cached_ext;	/* for the next sendmsg */
 	struct socket	*subflow; /* outgoing connect/listener/!mp_capable */
 	struct sock	*first;
@@ -202,6 +206,8 @@ struct mptcp_subflow_context {
 	u32	ssn_offset;
 	u32	map_data_len;
 	u32	request_mptcp : 1,  /* send MP_CAPABLE */
+		request_join : 1,   /* send MP_JOIN */
+		request_bkup : 1,
 		mp_capable : 1,	    /* remote is MPTCP capable */
 		mp_join : 1,	    /* remote is JOINing */
 		fully_established : 1,	    /* path validated */
@@ -218,6 +224,8 @@ struct mptcp_subflow_context {
 	u32	remote_nonce;
 	u64	thmac;
 	u32	local_nonce;
+	u32	remote_token;
+	u8	hmac[MPTCPOPT_HMAC_LEN];
 	u8	local_id;
 	u8	remote_id;
 
@@ -263,6 +271,11 @@ mptcp_subflow_get_mapped_dsn(const struct mptcp_subflow_context *subflow)
 int mptcp_is_enabled(struct net *net);
 bool mptcp_subflow_data_available(struct sock *sk);
 void mptcp_subflow_init(void);
+
+/* called with sk socket lock held */
+int __mptcp_subflow_connect(struct sock *sk, int ifindex,
+			    const struct mptcp_addr_info *loc,
+			    const struct mptcp_addr_info *remote);
 int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock);
 
 static inline void mptcp_subflow_tcp_fallback(struct sock *sk,
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index eb5f016ce7a5..bf58b599a820 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -24,13 +24,31 @@
 static int subflow_rebuild_header(struct sock *sk)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
-	int err = 0;
+	int local_id, err = 0;
 
 	if (subflow->request_mptcp && !subflow->token) {
 		pr_debug("subflow=%p", sk);
 		err = mptcp_token_new_connect(sk);
+	} else if (subflow->request_join && !subflow->local_nonce) {
+		struct mptcp_sock *msk = (struct mptcp_sock *)subflow->conn;
+
+		pr_debug("subflow=%p", sk);
+
+		do {
+			get_random_bytes(&subflow->local_nonce, sizeof(u32));
+		} while (!subflow->local_nonce);
+
+		if (subflow->local_id)
+			goto out;
+
+		local_id = mptcp_pm_get_local_id(msk, (struct sock_common *)sk);
+		if (local_id < 0)
+			return -EINVAL;
+
+		subflow->local_id = local_id;
 	}
 
+out:
 	if (err)
 		return err;
 
@@ -131,6 +149,7 @@ static void subflow_init_req(struct request_sock *req,
 
 		subflow_req->ssn_offset = TCP_SKB_CB(skb)->seq;
 	} else if (rx_opt.mptcp.mp_join && listener->request_mptcp) {
+		subflow_req->ssn_offset = TCP_SKB_CB(skb)->seq;
 		subflow_req->mp_join = 1;
 		subflow_req->backup = rx_opt.mptcp.backup;
 		subflow_req->remote_id = rx_opt.mptcp.join_id;
@@ -169,13 +188,35 @@ static void subflow_v6_init_req(struct request_sock *req,
 }
 #endif
 
+/* validate received truncated hmac and create hmac for third ACK */
+static bool subflow_thmac_valid(struct mptcp_subflow_context *subflow)
+{
+	u8 hmac[MPTCPOPT_HMAC_LEN];
+	u64 thmac;
+
+	subflow_generate_hmac(subflow->remote_key, subflow->local_key,
+			      subflow->remote_nonce, subflow->local_nonce,
+			      hmac);
+
+	thmac = get_unaligned_be64(hmac);
+	pr_debug("subflow=%p, token=%u, thmac=%llu, subflow->thmac=%llu\n",
+		 subflow, subflow->token,
+		 (unsigned long long)thmac,
+		 (unsigned long long)subflow->thmac);
+
+	return thmac == subflow->thmac;
+}
+
 static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 
 	subflow->icsk_af_ops->sk_rx_dst_set(sk, skb);
 
-	if (!subflow->conn_finished) {
+	if (subflow->conn_finished || !tcp_sk(sk)->is_mptcp)
+		return;
+
+	if (subflow->mp_capable) {
 		pr_debug("subflow=%p, remote_key=%llu", mptcp_subflow_ctx(sk),
 			 subflow->remote_key);
 		mptcp_finish_connect(sk);
@@ -185,6 +226,31 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 			pr_debug("synack seq=%u", TCP_SKB_CB(skb)->seq);
 			subflow->ssn_offset = TCP_SKB_CB(skb)->seq;
 		}
+	} else if (subflow->mp_join) {
+		pr_debug("subflow=%p, thmac=%llu, remote_nonce=%u",
+			 subflow, subflow->thmac,
+			 subflow->remote_nonce);
+		if (!subflow_thmac_valid(subflow)) {
+			subflow->mp_join = 0;
+			goto do_reset;
+		}
+
+		subflow_generate_hmac(subflow->local_key, subflow->remote_key,
+				      subflow->local_nonce,
+				      subflow->remote_nonce,
+				      subflow->hmac);
+
+		if (skb)
+			subflow->ssn_offset = TCP_SKB_CB(skb)->seq;
+
+		if (!mptcp_finish_join(sk))
+			goto do_reset;
+
+		subflow->conn_finished = 1;
+	} else {
+do_reset:
+		tcp_send_active_reset(sk, GFP_ATOMIC);
+		tcp_done(sk);
 	}
 }
 
@@ -731,6 +797,85 @@ void mptcpv6_handle_mapped(struct sock *sk, bool mapped)
 }
 #endif
 
+static void mptcp_info2sockaddr(const struct mptcp_addr_info *info,
+				struct sockaddr_storage *addr)
+{
+	memset(addr, 0, sizeof(*addr));
+	addr->ss_family = info->family;
+	if (addr->ss_family == AF_INET) {
+		struct sockaddr_in *in_addr = (struct sockaddr_in *)addr;
+
+		in_addr->sin_addr = info->addr;
+		in_addr->sin_port = info->port;
+	}
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+	else if (addr->ss_family == AF_INET6) {
+		struct sockaddr_in6 *in6_addr = (struct sockaddr_in6 *)addr;
+
+		in6_addr->sin6_addr = info->addr6;
+		in6_addr->sin6_port = info->port;
+	}
+#endif
+}
+
+int __mptcp_subflow_connect(struct sock *sk, int ifindex,
+			    const struct mptcp_addr_info *loc,
+			    const struct mptcp_addr_info *remote)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct mptcp_subflow_context *subflow;
+	struct sockaddr_storage addr;
+	struct socket *sf;
+	u32 remote_token;
+	int addrlen;
+	int err;
+
+	if (sk->sk_state != TCP_ESTABLISHED)
+		return -ENOTCONN;
+
+	err = mptcp_subflow_create_socket(sk, &sf);
+	if (err)
+		return err;
+
+	subflow = mptcp_subflow_ctx(sf->sk);
+	subflow->remote_key = msk->remote_key;
+	subflow->local_key = msk->local_key;
+	subflow->token = msk->token;
+	mptcp_info2sockaddr(loc, &addr);
+
+	addrlen = sizeof(struct sockaddr_in);
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+	if (loc->family == AF_INET6)
+		addrlen = sizeof(struct sockaddr_in6);
+#endif
+	sf->sk->sk_bound_dev_if = ifindex;
+	err = kernel_bind(sf, (struct sockaddr *)&addr, addrlen);
+	if (err)
+		goto failed;
+
+	mptcp_crypto_key_sha(subflow->remote_key, &remote_token, NULL);
+	pr_debug("msk=%p remote_token=%u", msk, remote_token);
+	subflow->remote_token = remote_token;
+	subflow->local_id = loc->id;
+	subflow->request_join = 1;
+	subflow->request_bkup = 1;
+	mptcp_info2sockaddr(remote, &addr);
+
+	err = kernel_connect(sf, (struct sockaddr *)&addr, addrlen, O_NONBLOCK);
+	if (err && err != -EINPROGRESS)
+		goto failed;
+
+	spin_lock_bh(&msk->join_list_lock);
+	list_add_tail(&subflow->node, &msk->join_list);
+	spin_unlock_bh(&msk->join_list_lock);
+
+	return err;
+
+failed:
+	sock_release(sf);
+	return err;
+}
+
 int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock)
 {
 	struct mptcp_subflow_context *subflow;
@@ -928,6 +1073,7 @@ static void subflow_ulp_clone(const struct request_sock *req,
 		new_ctx->ssn_offset = subflow_req->ssn_offset;
 		new_ctx->idsn = subflow_req->idsn;
 	} else if (subflow_req->mp_join) {
+		new_ctx->ssn_offset = subflow_req->ssn_offset;
 		new_ctx->mp_join = 1;
 		new_ctx->fully_established = 1;
 		new_ctx->backup = subflow_req->backup;
-- 
2.26.0

