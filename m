Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60331C9510
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729490AbfJBXil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:38:41 -0400
Received: from mga04.intel.com ([192.55.52.120]:16447 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728944AbfJBXhV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:37:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:37:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366862591"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.30.230])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 16:37:20 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Peter Krystad <peter.krystad@linux.intel.com>, cpaasch@apple.com,
        fw@strlen.de, pabeni@redhat.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH v2 09/45] mptcp: Handle MP_CAPABLE options for outgoing connections
Date:   Wed,  2 Oct 2019 16:36:19 -0700
Message-Id: <20191002233655.24323-10-mathew.j.martineau@linux.intel.com>
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

Add hooks to tcp_output.c to add MP_CAPABLE to an outgoing SYN request
for a subflow socket and to the final ACK of the three-way handshake.

Use the .sk_rx_dst_set() handler in the subflow proto to capture when the
responding SYN-ACK is received and notify the MPTCP connection layer.

Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
---
 include/net/mptcp.h   |  33 +++++++++
 net/ipv4/tcp_input.c  |   3 +
 net/ipv4/tcp_output.c |  27 ++++++++
 net/mptcp/options.c   |  45 ++++++++++++
 net/mptcp/protocol.c  | 158 +++++++++++++++++++++++++++++++++++++-----
 net/mptcp/protocol.h  |  18 ++++-
 net/mptcp/subflow.c   |  25 ++++++-
 7 files changed, 289 insertions(+), 20 deletions(-)

diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index fc3f9286c667..e3e248b16016 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -20,8 +20,19 @@ struct mptcp_out_options {
 
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
@@ -30,10 +41,32 @@ static inline void mptcp_init(void)
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
index 8e04adff1912..e28f308006da 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5963,6 +5963,9 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 		tcp_sync_mss(sk, icsk->icsk_pmtu_cookie);
 		tcp_initialize_rcv_mss(sk);
 
+		if (sk_is_mptcp(sk))
+			mptcp_rcv_synsent(sk);
+
 		/* Remember, tcp_poll() does not lock socket!
 		 * Change state from SYN-SENT only after copied_seq
 		 * is initialized. */
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 531929c68822..2354500c8ebb 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -663,6 +663,15 @@ static unsigned int tcp_syn_options(struct sock *sk, struct sk_buff *skb,
 
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
 
@@ -761,6 +770,24 @@ static unsigned int tcp_established_options(struct sock *sk, struct sk_buff *skb
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
index cee4280647fe..94508c0d887a 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -134,6 +134,51 @@ void mptcp_parse_option(const unsigned char *ptr, int opsize,
 	}
 }
 
+bool mptcp_syn_options(struct sock *sk, unsigned int *size,
+		       struct mptcp_out_options *opts)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
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
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+	struct tcp_sock *tp = tcp_sk(sk);
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
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
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
index c8e12017eddb..95c302c59d2e 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -17,21 +17,96 @@
 #include <net/mptcp.h>
 #include "protocol.h"
 
+static struct socket *__mptcp_fallback_get_ref(const struct mptcp_sock *msk)
+{
+	sock_owned_by_me((const struct sock *)msk);
+
+	if (!msk->subflow)
+		return NULL;
+
+	sock_hold(msk->subflow->sk);
+	return msk->subflow;
+}
+
+static struct sock *mptcp_subflow_get_ref(const struct mptcp_sock *msk)
+{
+	struct mptcp_subflow_context *subflow;
+
+	sock_owned_by_me((const struct sock *)msk);
+
+	mptcp_for_each_subflow(msk, subflow) {
+		struct sock *sk;
+
+		sk = mptcp_subflow_tcp_socket(subflow)->sk;
+		sock_hold(sk);
+		return sk;
+	}
+
+	return NULL;
+}
+
 static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
-	struct socket *subflow = msk->subflow;
+	struct socket *ssock;
+	struct sock *ssk;
+	int ret;
+
+	lock_sock(sk);
+	ssock = __mptcp_fallback_get_ref(msk);
+	if (ssock) {
+		release_sock(sk);
+		pr_debug("fallback passthrough");
+		ret = sock_sendmsg(ssock, msg);
+		sock_put(ssock->sk);
+		return ret;
+	}
 
-	return sock_sendmsg(subflow, msg);
+	ssk = mptcp_subflow_get_ref(msk);
+	if (!ssk) {
+		release_sock(sk);
+		return -ENOTCONN;
+	}
+
+	ret = sock_sendmsg(ssk->sk_socket, msg);
+
+	release_sock(sk);
+	sock_put(ssk);
+	return ret;
 }
 
 static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 			 int nonblock, int flags, int *addr_len)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
-	struct socket *subflow = msk->subflow;
+	struct socket *ssock;
+	struct sock *ssk;
+	int copied = 0;
+
+	lock_sock(sk);
+	ssock = __mptcp_fallback_get_ref(msk);
+	if (ssock) {
+		release_sock(sk);
+		pr_debug("fallback-read subflow=%p",
+			 mptcp_subflow_ctx(ssock->sk));
+		copied = sock_recvmsg(ssock, msg, flags);
+		sock_put(ssock->sk);
+		return copied;
+	}
 
-	return sock_recvmsg(subflow, msg, flags);
+	ssk = mptcp_subflow_get_ref(msk);
+	if (!ssk) {
+		release_sock(sk);
+		return -ENOTCONN;
+	}
+
+	copied = sock_recvmsg(ssk->sk_socket, msg, flags);
+
+	release_sock(sk);
+
+	sock_put(ssk);
+
+	return copied;
 }
 
 static int mptcp_init_sock(struct sock *sk)
@@ -47,39 +122,89 @@ static int mptcp_init_sock(struct sock *sk)
 		msk->subflow = sf;
 	}
 
+	INIT_LIST_HEAD(&msk->conn_list);
+
 	return err;
 }
 
 static void mptcp_close(struct sock *sk, long timeout)
 {
+	struct mptcp_subflow_context *subflow, *tmp;
 	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct socket *ssk = NULL;
 
 	inet_sk_state_store(sk, TCP_CLOSE);
 
+	lock_sock(sk);
+
 	if (msk->subflow) {
-		pr_debug("subflow=%p", mptcp_subflow_ctx(msk->subflow->sk));
-		sock_release(msk->subflow);
+		ssk = msk->subflow;
+		msk->subflow = NULL;
+	}
+
+	if (ssk) {
+		pr_debug("subflow=%p", ssk->sk);
+		sock_release(ssk);
 	}
 
-	sock_orphan(sk);
-	sock_put(sk);
+	list_for_each_entry_safe(subflow, tmp, &msk->conn_list, node) {
+		pr_debug("conn_list->subflow=%p", subflow);
+		sock_release(mptcp_subflow_tcp_socket(subflow));
+	}
+
+	release_sock(sk);
+	sk_common_release(sk);
 }
 
-static int mptcp_connect(struct sock *sk, struct sockaddr *saddr, int len)
+static int mptcp_get_port(struct sock *sk, unsigned short snum)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
-	int err;
-
-	saddr->sa_family = AF_INET;
 
 	pr_debug("msk=%p, subflow=%p", msk,
 		 mptcp_subflow_ctx(msk->subflow->sk));
 
-	err = kernel_connect(msk->subflow, saddr, len, 0);
+	return inet_csk_get_port(msk->subflow->sk, snum);
+}
 
-	sk->sk_state = TCP_ESTABLISHED;
+void mptcp_finish_connect(struct sock *sk, int mp_capable)
+{
+	struct mptcp_subflow_context *subflow;
+	struct mptcp_sock *msk = mptcp_sk(sk);
 
-	return err;
+	subflow = mptcp_subflow_ctx(msk->subflow->sk);
+
+	if (mp_capable) {
+		/* sk (new subflow socket) is already locked, but we need
+		 * to lock the parent (mptcp) socket now to add the tcp socket
+		 * to the subflow list.
+		 *
+		 * From lockdep point of view, this creates an ABBA type
+		 * deadlock: Normally (sendmsg, recvmsg, ..), we lock the mptcp
+		 * socket, then acquire a subflow lock.
+		 * Here we do the reverse: "subflow lock, then mptcp lock".
+		 *
+		 * Its alright to do this here, because this subflow is not yet
+		 * on the mptcp sockets subflow list.
+		 *
+		 * IOW, if another CPU has this mptcp socket locked, it cannot
+		 * acquire this particular subflow, because subflow->sk isn't
+		 * on msk->conn_list.
+		 *
+		 * This function can be called either from backlog processing
+		 * (BH will be enabled) or from softirq, so we need to use BH
+		 * locking scheme.
+		 */
+		local_bh_disable();
+		bh_lock_sock_nested(sk);
+
+		msk->remote_key = subflow->remote_key;
+		msk->local_key = subflow->local_key;
+		list_add(&subflow->node, &msk->conn_list);
+		msk->subflow = NULL;
+		bh_unlock_sock(sk);
+		local_bh_enable();
+	}
+	inet_sk_state_store(sk, TCP_ESTABLISHED);
 }
 
 static struct proto mptcp_prot = {
@@ -88,13 +213,12 @@ static struct proto mptcp_prot = {
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
index fe6b31bbad1b..2e000ba7caa4 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -38,9 +38,15 @@
 struct mptcp_sock {
 	/* inet_connection_sock must be the first member */
 	struct inet_connection_sock sk;
+	u64		local_key;
+	u64		remote_key;
+	struct list_head conn_list;
 	struct socket	*subflow; /* outgoing connect/listener/!mp_capable */
 };
 
+#define mptcp_for_each_subflow(__msk, __subflow)			\
+	list_for_each_entry(__subflow, &((__msk)->conn_list), node)
+
 static inline struct mptcp_sock *mptcp_sk(const struct sock *sk)
 {
 	return (struct mptcp_sock *)sk;
@@ -48,9 +54,15 @@ static inline struct mptcp_sock *mptcp_sk(const struct sock *sk)
 
 /* MPTCP subflow context */
 struct mptcp_subflow_context {
+	struct	list_head node;/* conn_list of subflows */
+	u64	local_key;
+	u64	remote_key;
 	u32	request_mptcp : 1,  /* send MP_CAPABLE */
 		request_cksum : 1,
-		request_version : 4;
+		request_version : 4,
+		mp_capable : 1,	    /* remote is MPTCP capable */
+		fourth_ack : 1,     /* send initial DSS */
+		conn_finished : 1;
 	struct  socket *tcp_sock;  /* underlying tcp_sock */
 	struct  sock *conn;        /* parent mptcp_sock */
 };
@@ -72,4 +84,8 @@ mptcp_subflow_tcp_socket(const struct mptcp_subflow_context *subflow)
 void mptcp_subflow_init(void);
 int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock);
 
+extern const struct inet_connection_sock_af_ops ipv4_specific;
+
+void mptcp_finish_connect(struct sock *sk, int mp_capable);
+
 #endif /* __MPTCP_PROTOCOL_H */
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 5971fb5bfdf2..4690410d9922 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -15,6 +15,22 @@
 #include <net/mptcp.h>
 #include "protocol.h"
 
+static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+
+	inet_sk_rx_dst_set(sk, skb);
+
+	if (subflow->conn && !subflow->conn_finished) {
+		pr_debug("subflow=%p, remote_key=%llu", mptcp_subflow_ctx(sk),
+			 subflow->remote_key);
+		mptcp_finish_connect(subflow->conn, subflow->mp_capable);
+		subflow->conn_finished = 1;
+	}
+}
+
+static struct inet_connection_sock_af_ops subflow_specific;
+
 int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock)
 {
 	struct mptcp_subflow_context *subflow;
@@ -66,8 +82,9 @@ static struct mptcp_subflow_context *subflow_create_ctx(struct sock *sk,
 
 static int subflow_ulp_init(struct sock *sk)
 {
-	struct tcp_sock *tsk = tcp_sk(sk);
+	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct mptcp_subflow_context *ctx;
+	struct tcp_sock *tp = tcp_sk(sk);
 	int err = 0;
 
 	ctx = subflow_create_ctx(sk, sk->sk_socket);
@@ -78,7 +95,8 @@ static int subflow_ulp_init(struct sock *sk)
 
 	pr_debug("subflow=%p", ctx);
 
-	tsk->is_mptcp = 1;
+	tp->is_mptcp = 1;
+	icsk->icsk_af_ops = &subflow_specific;
 out:
 	return err;
 }
@@ -101,6 +119,9 @@ static struct tcp_ulp_ops subflow_ulp_ops __read_mostly = {
 
 void mptcp_subflow_init(void)
 {
+	subflow_specific = ipv4_specific;
+	subflow_specific.sk_rx_dst_set = subflow_finish_connect;
+
 	if (tcp_register_ulp(&subflow_ulp_ops) != 0)
 		panic("MPTCP: failed to register subflows to ULP\n");
 }
-- 
2.23.0

