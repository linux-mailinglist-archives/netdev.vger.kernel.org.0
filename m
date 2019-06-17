Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 432E5495A2
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbfFQW7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:59:45 -0400
Received: from mga18.intel.com ([134.134.136.126]:10994 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728018AbfFQW6v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 18:58:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 15:58:49 -0700
X-ExtLoop1: 1
Received: from mjmartin-nuc01.amr.corp.intel.com (HELO mjmartin-nuc01.sea.intel.com) ([10.241.98.42])
  by orsmga002.jf.intel.com with ESMTP; 17 Jun 2019 15:58:49 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     edumazet@google.com, netdev@vger.kernel.org
Cc:     Peter Krystad <peter.krystad@linux.intel.com>, cpaasch@apple.com,
        fw@strlen.de, pabeni@redhat.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH net-next 07/33] mptcp: Handle MP_CAPABLE options for outgoing connections
Date:   Mon, 17 Jun 2019 15:57:42 -0700
Message-Id: <20190617225808.665-8-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
References: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Krystad <peter.krystad@linux.intel.com>

Add hooks to tcp_output.c to add MP_CAPABLE to an outgoing
SYN request for a subflow socket and to the final ACK of the
three-way handshake.

Use the .sk_rx_dst_set() handler in the subflow proto to capture
when the responding SYN-ACK is received and notify the MPTCP
connection layer.

Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
---
 include/net/mptcp.h   | 35 ++++++++++++++++++++++++++++
 net/ipv4/tcp_input.c  |  3 +++
 net/ipv4/tcp_output.c | 29 +++++++++++++++++++++--
 net/mptcp/options.c   | 45 ++++++++++++++++++++++++++++++++++++
 net/mptcp/protocol.c  | 53 +++++++++++++++++++++++++++++++------------
 net/mptcp/protocol.h  | 16 +++++++++++--
 net/mptcp/subflow.c   | 25 ++++++++++++++++++--
 7 files changed, 185 insertions(+), 21 deletions(-)

diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 0d3e02c6c817..81255b0f57d7 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -14,17 +14,30 @@
 #define OPTION_MPTCP_MPC_ACK	BIT(2)
 
 struct mptcp_out_options {
+#if IS_ENABLED(CONFIG_MPTCP)
 	u16 suboptions;
 	u64 sndr_key;
 	u64 rcvr_key;
+#endif
 };
 
 #ifdef CONFIG_MPTCP
 
 void mptcp_init(void);
 
+static inline bool sk_is_mptcp(const struct sock *sk)
+{
+	return tcp_sk(sk)->is_mptcp;
+}
+
 void mptcp_parse_option(const unsigned char *ptr, int opsize,
 			struct tcp_options_received *opt_rx);
+bool mptcp_syn_options(struct sock *sk, unsigned int *size,
+		       struct mptcp_out_options *opts);
+void mptcp_rcv_synsent(struct sock *sk);
+bool mptcp_established_options(struct sock *sk, unsigned int *size,
+			       struct mptcp_out_options *opts);
+
 void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts);
 
 #else
@@ -33,10 +46,32 @@ static inline void mptcp_init(void)
 {
 }
 
+static inline bool sk_is_mptcp(const struct sock *sk)
+{
+	return false;
+}
+
 static inline void mptcp_parse_option(const unsigned char *ptr, int opsize,
 				      struct tcp_options_received *opt_rx)
 {
 }
 
+static inline bool mptcp_syn_options(struct sock *sk, unsigned int *size,
+				     struct mptcp_out_options *opts)
+{
+	return false;
+}
+
+static inline void mptcp_rcv_synsent(struct sock *sk)
+{
+}
+
+static inline bool mptcp_established_options(struct sock *sk,
+					     unsigned int *size,
+					     struct mptcp_out_options *opts)
+{
+	return false;
+}
+
 #endif /* CONFIG_MPTCP */
 #endif /* __NET_MPTCP_H */
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 117f0efbbad5..4aa60fe0deca 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5901,6 +5901,9 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 		tcp_sync_mss(sk, icsk->icsk_pmtu_cookie);
 		tcp_initialize_rcv_mss(sk);
 
+		if (sk_is_mptcp(sk))
+			mptcp_rcv_synsent(sk);
+
 		/* Remember, tcp_poll() does not lock socket!
 		 * Change state from SYN-SENT only after copied_seq
 		 * is initialized. */
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 69c4f39efe8b..f46e58347d73 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -438,9 +438,7 @@ struct tcp_out_options {
 	__u8 *hash_location;	/* temporary pointer, overloaded */
 	__u32 tsval, tsecr;	/* need to include OPTION_TS */
 	struct tcp_fastopen_cookie *fastopen_cookie;	/* Fast open cookie */
-#if IS_ENABLED(CONFIG_MPTCP)
 	struct mptcp_out_options mptcp;
-#endif
 };
 
 static void mptcp_options_write(__be32 *ptr, struct tcp_out_options *opts)
@@ -665,6 +663,15 @@ static unsigned int tcp_syn_options(struct sock *sk, struct sk_buff *skb,
 
 	smc_set_option(tp, opts, &remaining);
 
+	if (sk_is_mptcp(sk)) {
+		unsigned int size;
+
+		if (mptcp_syn_options(sk, &size, &opts->mptcp)) {
+			opts->options |= OPTION_MPTCP;
+			remaining -= size;
+		}
+	}
+
 	return MAX_TCP_OPTION_SPACE - remaining;
 }
 
@@ -763,6 +770,24 @@ static unsigned int tcp_established_options(struct sock *sk, struct sk_buff *skb
 		size += TCPOLEN_TSTAMP_ALIGNED;
 	}
 
+	/* MPTCP options have precedence over SACK for the limited TCP
+	 * option space because a MPTCP connection would be forced to
+	 * fall back to regular TCP if a required multipath option is
+	 * missing. SACK still gets a chance to use whatever space is
+	 * left.
+	 */
+	if (sk_is_mptcp(sk)) {
+		unsigned int remaining = MAX_TCP_OPTION_SPACE - size;
+		unsigned int opt_size;
+
+		if (mptcp_established_options(sk, &opt_size, &opts->mptcp)) {
+			if (remaining >= opt_size) {
+				opts->options |= OPTION_MPTCP;
+				size += opt_size;
+			}
+		}
+	}
+
 	eff_sacks = tp->rx_opt.num_sacks + tp->rx_opt.dsack;
 	if (unlikely(eff_sacks)) {
 		const unsigned int remaining = MAX_TCP_OPTION_SPACE - size;
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 42626cd0a9f7..071e937d5c1f 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -121,6 +121,51 @@ void mptcp_parse_option(const unsigned char *ptr, int opsize,
 	}
 }
 
+bool mptcp_syn_options(struct sock *sk, unsigned int *size,
+		       struct mptcp_out_options *opts)
+{
+	struct subflow_context *subflow = subflow_ctx(sk);
+
+	if (subflow->request_mptcp) {
+		pr_debug("local_key=%llu", subflow->local_key);
+		opts->suboptions = OPTION_MPTCP_MPC_SYN;
+		opts->sndr_key = subflow->local_key;
+		*size = TCPOLEN_MPTCP_MPC_SYN;
+		return true;
+	}
+	return false;
+}
+
+void mptcp_rcv_synsent(struct sock *sk)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+	struct subflow_context *subflow = subflow_ctx(sk);
+
+	pr_debug("subflow=%p", subflow);
+	if (subflow->request_mptcp && tp->rx_opt.mptcp.mp_capable) {
+		subflow->mp_capable = 1;
+		subflow->remote_key = tp->rx_opt.mptcp.sndr_key;
+	}
+}
+
+bool mptcp_established_options(struct sock *sk, unsigned int *size,
+			       struct mptcp_out_options *opts)
+{
+	struct subflow_context *subflow = subflow_ctx(sk);
+
+	if (subflow->mp_capable && !subflow->fourth_ack) {
+		opts->suboptions = OPTION_MPTCP_MPC_ACK;
+		opts->sndr_key = subflow->local_key;
+		opts->rcvr_key = subflow->remote_key;
+		*size = TCPOLEN_MPTCP_MPC_ACK;
+		subflow->fourth_ack = 1;
+		pr_debug("subflow=%p, local_key=%llu, remote_key=%llu",
+			 subflow, subflow->local_key, subflow->remote_key);
+		return true;
+	}
+	return false;
+}
+
 void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
 {
 	if ((OPTION_MPTCP_MPC_SYN |
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index ce2374ea7871..56637e4474da 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -18,9 +18,15 @@
 static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
-	struct socket *subflow = msk->subflow;
-
-	pr_debug("subflow=%p", subflow_ctx(subflow->sk));
+	struct socket *subflow;
+
+	if (msk->connection_list) {
+		subflow = msk->connection_list;
+		pr_debug("conn_list->subflow=%p", subflow_ctx(subflow->sk));
+	} else {
+		subflow = msk->subflow;
+		pr_debug("subflow=%p", subflow_ctx(subflow->sk));
+	}
 
 	return sock_sendmsg(subflow, msg);
 }
@@ -29,9 +35,15 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 			 int nonblock, int flags, int *addr_len)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
-	struct socket *subflow = msk->subflow;
-
-	pr_debug("subflow=%p", subflow_ctx(subflow->sk));
+	struct socket *subflow;
+
+	if (msk->connection_list) {
+		subflow = msk->connection_list;
+		pr_debug("conn_list->subflow=%p", subflow_ctx(subflow->sk));
+	} else {
+		subflow = msk->subflow;
+		pr_debug("subflow=%p", subflow_ctx(subflow->sk));
+	}
 
 	return sock_recvmsg(subflow, msg, flags);
 }
@@ -56,24 +68,36 @@ static void mptcp_close(struct sock *sk, long timeout)
 		sock_release(msk->subflow);
 	}
 
+	if (msk->connection_list) {
+		pr_debug("conn_list->subflow=%p", msk->connection_list->sk);
+		sock_release(msk->connection_list);
+	}
+
 	sock_orphan(sk);
 	sock_put(sk);
 }
 
-static int mptcp_connect(struct sock *sk, struct sockaddr *saddr, int len)
+static int mptcp_get_port(struct sock *sk, unsigned short snum)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
-	int err;
-
-	saddr->sa_family = AF_INET;
 
 	pr_debug("msk=%p, subflow=%p", msk, subflow_ctx(msk->subflow->sk));
 
-	err = kernel_connect(msk->subflow, saddr, len, 0);
+	return inet_csk_get_port(msk->subflow->sk, snum);
+}
 
-	sk->sk_state = TCP_ESTABLISHED;
+void mptcp_finish_connect(struct sock *sk, int mp_capable)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct subflow_context *subflow = subflow_ctx(msk->subflow->sk);
 
-	return err;
+	if (mp_capable) {
+		msk->remote_key = subflow->remote_key;
+		msk->local_key = subflow->local_key;
+		msk->connection_list = msk->subflow;
+		msk->subflow = NULL;
+	}
+	sk->sk_state = TCP_ESTABLISHED;
 }
 
 static struct proto mptcp_prot = {
@@ -82,13 +106,12 @@ static struct proto mptcp_prot = {
 	.init		= mptcp_init_sock,
 	.close		= mptcp_close,
 	.accept		= inet_csk_accept,
-	.connect	= mptcp_connect,
 	.shutdown	= tcp_shutdown,
 	.sendmsg	= mptcp_sendmsg,
 	.recvmsg	= mptcp_recvmsg,
 	.hash		= inet_hash,
 	.unhash		= inet_unhash,
-	.get_port	= inet_csk_get_port,
+	.get_port	= mptcp_get_port,
 	.obj_size	= sizeof(struct mptcp_sock),
 	.no_autobind	= 1,
 };
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index b6adc2aa6222..9206e60ef6d3 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -33,7 +33,10 @@
 struct mptcp_sock {
 	/* inet_connection_sock must be the first member */
 	struct	inet_connection_sock sk;
-	struct	socket *subflow;
+	u64	local_key;
+	u64	remote_key;
+	struct	socket *connection_list; /* @@ needs to be a list */
+	struct	socket *subflow; /* outgoing connect, listener or !mp_capable */
 };
 
 static inline struct mptcp_sock *mptcp_sk(const struct sock *sk)
@@ -43,9 +46,14 @@ static inline struct mptcp_sock *mptcp_sk(const struct sock *sk)
 
 /* MPTCP subflow context */
 struct subflow_context {
+	u64	local_key;
+	u64	remote_key;
 	u32	request_mptcp : 1,  /* send MP_CAPABLE */
 		request_cksum : 1,
-		version : 4;
+		mp_capable : 1,	    /* remote is MPTCP capable */
+		fourth_ack : 1,     /* send initial DSS */
+		version : 4,
+		conn_finished : 1;
 	struct  socket *tcp_sock;  /* underlying tcp_sock */
 	struct  sock *conn;        /* parent mptcp_sock */
 };
@@ -65,4 +73,8 @@ mptcp_subflow_tcp_socket(const struct subflow_context *subflow)
 
 void subflow_init(void);
 
+extern const struct inet_connection_sock_af_ops ipv4_specific;
+
+void mptcp_finish_connect(struct sock *sk, int mp_capable);
+
 #endif /* __MPTCP_PROTOCOL_H */
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 8d13713ee159..91df2c4be339 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -15,6 +15,22 @@
 #include <net/mptcp.h>
 #include "protocol.h"
 
+static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
+{
+	struct subflow_context *subflow = subflow_ctx(sk);
+
+	inet_sk_rx_dst_set(sk, skb);
+
+	if (subflow->conn && !subflow->conn_finished) {
+		pr_debug("subflow=%p, remote_key=%llu", subflow_ctx(sk),
+			 subflow->remote_key);
+		mptcp_finish_connect(subflow->conn, subflow->mp_capable);
+		subflow->conn_finished = 1;
+	}
+}
+
+static struct inet_connection_sock_af_ops subflow_specific;
+
 static struct subflow_context *subflow_create_ctx(struct sock *sk,
 						  struct socket *sock)
 {
@@ -36,7 +52,8 @@ static struct subflow_context *subflow_create_ctx(struct sock *sk,
 
 static int subflow_ulp_init(struct sock *sk)
 {
-	struct tcp_sock *tsk = tcp_sk(sk);
+	struct tcp_sock *tp = tcp_sk(sk);
+	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct subflow_context *ctx;
 	int err = 0;
 
@@ -48,7 +65,8 @@ static int subflow_ulp_init(struct sock *sk)
 
 	pr_debug("subflow=%p", ctx);
 
-	tsk->is_mptcp = 1;
+	tp->is_mptcp = 1;
+	icsk->icsk_af_ops = &subflow_specific;
 out:
 	return err;
 }
@@ -71,6 +89,9 @@ static struct tcp_ulp_ops subflow_ulp_ops __read_mostly = {
 
 void subflow_init(void)
 {
+	subflow_specific = ipv4_specific;
+	subflow_specific.sk_rx_dst_set = subflow_finish_connect;
+
 	if (tcp_register_ulp(&subflow_ulp_ops) != 0)
 		panic("MPTCP: failed to register subflows to ULP\n");
 }
-- 
2.22.0

