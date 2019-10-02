Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 573C3C94F2
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729265AbfJBXhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:37:50 -0400
Received: from mga04.intel.com ([192.55.52.120]:16463 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729160AbfJBXhl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:37:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:37:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366862627"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.30.230])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 16:37:23 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Peter Krystad <peter.krystad@linux.intel.com>, cpaasch@apple.com,
        fw@strlen.de, pabeni@redhat.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH v2 32/45] mptcp: Add handling of outgoing MP_JOIN requests
Date:   Wed,  2 Oct 2019 16:36:42 -0700
Message-Id: <20191002233655.24323-33-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
References: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
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
initiate connection. When a valid SYN-ACK is received the
new sock is added to the tail of the mptcp sock conn_list
where it will not interfere with data flow on the original
connection.

Data flow and connection failover not addressed by this commit.

Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/mptcp.h  |  2 +
 net/mptcp/options.c  | 51 +++++++++++++++++++++--
 net/mptcp/protocol.c |  1 +
 net/mptcp/protocol.h |  9 ++++
 net/mptcp/subflow.c  | 98 +++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 156 insertions(+), 5 deletions(-)

diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index bb2dd193c0c5..50cd1b31ebdd 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -40,6 +40,8 @@ struct mptcp_out_options {
 	u8 backup;
 	u32 nonce;
 	u64 thmac;
+	u32 token;
+	u8 hmac[20];
 	struct mptcp_ext ext_copy;
 #endif
 };
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index f5e0b1d0931b..ce298ecc64f5 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -316,6 +316,16 @@ bool mptcp_syn_options(struct sock *sk, unsigned int *size,
 		opts->sndr_key = subflow->local_key;
 		*size = TCPOLEN_MPTCP_MPC_SYN;
 		return true;
+	} else if (subflow->request_join) {
+		pr_debug("remote_token=%u, nonce=%u", subflow->remote_token,
+			 subflow->local_nonce);
+		opts->suboptions = OPTION_MPTCP_MPJ_SYN;
+		opts->join_id = subflow->remote_id;
+		opts->token = subflow->remote_token;
+		opts->nonce = subflow->local_nonce;
+		opts->backup = subflow->request_bkup;
+		*size = TCPOLEN_MPTCP_MPJ_SYN;
+		return true;
 	}
 	return false;
 }
@@ -325,10 +335,17 @@ void mptcp_rcv_synsent(struct sock *sk)
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 
-	pr_debug("subflow=%p", subflow);
 	if (subflow->request_mptcp && tp->rx_opt.mptcp.mp_capable) {
 		subflow->mp_capable = 1;
 		subflow->remote_key = tp->rx_opt.mptcp.sndr_key;
+		pr_debug("subflow=%p, remote_key=%llu", subflow,
+			 subflow->remote_key);
+	} else if (subflow->request_join && tp->rx_opt.mptcp.mp_join) {
+		subflow->mp_join = 1;
+		subflow->thmac = tp->rx_opt.mptcp.thmac;
+		subflow->remote_nonce = tp->rx_opt.mptcp.nonce;
+		pr_debug("subflow=%p, thmac=%llu, remote_nonce=%u", subflow,
+			 subflow->thmac, subflow->remote_nonce);
 	}
 }
 
@@ -338,7 +355,8 @@ static bool mptcp_established_options_mp(struct sock *sk, unsigned int *size,
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 
-	if (!subflow->fourth_ack && remaining >= TCPOLEN_MPTCP_MPC_ACK) {
+	if (subflow->mp_capable && !subflow->fourth_ack &&
+	    remaining >= TCPOLEN_MPTCP_MPC_ACK) {
 		opts->suboptions = OPTION_MPTCP_MPC_ACK;
 		opts->sndr_key = subflow->local_key;
 		opts->rcvr_key = subflow->remote_key;
@@ -347,6 +365,14 @@ static bool mptcp_established_options_mp(struct sock *sk, unsigned int *size,
 		pr_debug("subflow=%p, local_key=%llu, remote_key=%llu",
 			 subflow, subflow->local_key, subflow->remote_key);
 		return true;
+	} else if (subflow->mp_join && !subflow->fourth_ack &&
+		   remaining >= TCPOLEN_MPTCP_MPJ_ACK) {
+		opts->suboptions = OPTION_MPTCP_MPJ_ACK;
+		memcpy(opts->hmac, subflow->hmac, MPTCPOPT_HMAC_LEN);
+		*size = TCPOLEN_MPTCP_MPJ_ACK;
+		subflow->fourth_ack = 1;
+		pr_debug("subflow=%p", subflow);
+		return true;
 	}
 	return false;
 }
@@ -459,10 +485,11 @@ bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
 			       unsigned int *size, unsigned int remaining,
 			       struct mptcp_out_options *opts)
 {
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 	unsigned int opt_size = 0;
 	bool ret = false;
 
-	if (!mptcp_subflow_ctx(sk)->mp_capable)
+	if (!subflow->mp_capable && !subflow->mp_join)
 		return false;
 
 	opts->suboptions = 0;
@@ -562,7 +589,6 @@ void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb,
 
 	if (msk)
 		pm_fully_established(msk);
-
 }
 
 void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
@@ -612,6 +638,16 @@ void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
 				      0, opts->addr_id);
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
@@ -622,6 +658,13 @@ void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
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
index fa99337ca773..445800eae767 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -787,6 +787,7 @@ void mptcp_finish_connect(struct sock *sk, int mp_capable)
 		msk->local_key = subflow->local_key;
 		msk->token = subflow->token;
 		pr_debug("msk=%p, token=%u", msk, msk->token);
+		msk->dport = ntohs(inet_sk(msk->subflow->sk)->inet_dport);
 
 		pm_new_connection(msk, 0);
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 394f2477e6f8..4a1171b75ec6 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -49,8 +49,10 @@
 #define TCPOLEN_MPTCP_ADD_ADDR6		20
 #define TCPOLEN_MPTCP_RM_ADDR		4
 
+/* MPTCP MP_JOIN flags */
 #define MPTCPOPT_BACKUP		BIT(0)
 #define MPTCPOPT_HMAC_LEN	20
+#define MPTCPOPT_THMAC_LEN	8
 
 /* MPTCP MP_CAPABLE flags */
 #define MPTCP_VERSION_MASK	(0x0F)
@@ -115,6 +117,7 @@ struct mptcp_sock {
 	u64		write_seq;
 	u64		ack_seq;
 	u32		token;
+	u16		dport;
 	struct list_head conn_list;
 	struct socket	*subflow; /* outgoing connect/listener/!mp_capable */
 	struct mptcp_pm_data	pm;
@@ -167,7 +170,9 @@ struct mptcp_subflow_context {
 	u32	ssn_offset;
 	u16	map_data_len;
 	u16	request_mptcp : 1,  /* send MP_CAPABLE */
+		request_join : 1,   /* send MP_JOIN */
 		request_cksum : 1,
+		request_bkup : 1,
 		request_version : 4,
 		mp_capable : 1,     /* remote is MPTCP capable */
 		mp_join : 1,        /* remote is JOINing */
@@ -179,6 +184,8 @@ struct mptcp_subflow_context {
 	u32	remote_nonce;
 	u64	thmac;
 	u32	local_nonce;
+	u32	remote_token;
+	u8	hmac[MPTCPOPT_HMAC_LEN];
 	u8	local_id;
 	u8	remote_id;
 
@@ -207,6 +214,8 @@ mptcp_subflow_tcp_socket(const struct mptcp_subflow_context *subflow)
 int mptcp_is_enabled(struct net *net);
 
 void mptcp_subflow_init(void);
+int mptcp_subflow_connect(struct sock *sk, struct sockaddr_in *local,
+			  struct sockaddr_in *remote, u8 remote_id);
 int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock);
 
 extern const struct inet_connection_sock_af_ops ipv4_specific;
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 04f232ff1df0..257e52d9595e 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -26,6 +26,13 @@ static int subflow_rebuild_header(struct sock *sk)
 	if (subflow->request_mptcp && !subflow->token) {
 		pr_debug("subflow=%p", sk);
 		err = mptcp_token_new_connect(sk);
+	} else if (subflow->request_join && !subflow->local_nonce) {
+		pr_debug("subflow=%p", sk);
+		mptcp_token_get_sock(subflow->token);
+
+		do {
+			get_random_bytes(&subflow->local_nonce, sizeof(u32));
+		} while (!subflow->local_nonce);
 	}
 
 	if (err)
@@ -130,13 +137,35 @@ static void subflow_v4_init_req(struct request_sock *req,
 	}
 }
 
+/* validate received truncated hmac and create hmac for third ACK */
+static bool subflow_thmac_valid(struct mptcp_subflow_context *subflow)
+{
+	u8 hmac[MPTCPOPT_HMAC_LEN];
+	u64 thmac;
+
+	mptcp_crypto_hmac_sha1(subflow->remote_key, subflow->local_key,
+			       subflow->remote_nonce, subflow->local_nonce,
+			       (u32 *)hmac);
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
 
 	inet_sk_rx_dst_set(sk, skb);
 
-	if (subflow->conn && !subflow->conn_finished) {
+	if (!subflow->conn)
+		return;
+
+	if (subflow->mp_capable && !subflow->conn_finished) {
 		pr_debug("subflow=%p, remote_key=%llu", mptcp_subflow_ctx(sk),
 			 subflow->remote_key);
 		mptcp_finish_connect(subflow->conn, subflow->mp_capable);
@@ -146,6 +175,23 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 			pr_debug("synack seq=%u", TCP_SKB_CB(skb)->seq);
 			subflow->ssn_offset = TCP_SKB_CB(skb)->seq;
 		}
+	} else if (subflow->mp_join && !subflow->conn_finished) {
+		pr_debug("subflow=%p, thmac=%llu, remote_nonce=%u",
+			 subflow, subflow->thmac,
+			 subflow->remote_nonce);
+		if (!subflow_thmac_valid(subflow)) {
+			subflow->mp_join = 0;
+			// @@ need to trigger RST
+			return;
+		}
+
+		mptcp_crypto_hmac_sha1(subflow->local_key, subflow->remote_key,
+				       subflow->local_nonce,
+				       subflow->remote_nonce,
+				       (u32 *)subflow->hmac);
+
+		mptcp_finish_join(sk);
+		subflow->conn_finished = 1;
 	}
 }
 
@@ -269,6 +315,56 @@ static void subflow_data_ready(struct sock *sk)
 	}
 }
 
+int mptcp_subflow_connect(struct sock *sk, struct sockaddr_in *local,
+			  struct sockaddr_in *remote, u8 remote_id)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct mptcp_subflow_context *subflow;
+	struct socket *sf;
+	u32 remote_token;
+	int err;
+
+	lock_sock(sk);
+	err = mptcp_subflow_create_socket(sk, &sf);
+	if (err) {
+		release_sock(sk);
+		return err;
+	}
+
+	subflow = mptcp_subflow_ctx(sf->sk);
+	subflow->remote_key = msk->remote_key;
+	subflow->local_key = msk->local_key;
+	subflow->token = msk->token;
+
+	sock_hold(sf->sk);
+	release_sock(sk);
+
+	err = kernel_bind(sf, (struct sockaddr *)local,
+			  sizeof(struct sockaddr_in));
+	if (err)
+		goto failed;
+
+	mptcp_crypto_key_sha1(subflow->remote_key, &remote_token, NULL);
+	pr_debug("msk=%p remote_token=%u", msk, remote_token);
+	subflow->remote_token = remote_token;
+	subflow->remote_id = remote_id;
+	subflow->request_join = 1;
+	subflow->request_bkup = 1;
+
+	err = kernel_connect(sf, (struct sockaddr *)remote,
+			     sizeof(struct sockaddr_in), O_NONBLOCK);
+	if (err && err != -EINPROGRESS)
+		goto failed;
+
+	sock_put(sf->sk);
+	return err;
+
+failed:
+	sock_put(sf->sk);
+	sock_release(sf);
+	return err;
+}
+
 int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock)
 {
 	struct mptcp_subflow_context *subflow;
-- 
2.23.0

