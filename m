Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C66349591
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbfFQW64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:58:56 -0400
Received: from mga18.intel.com ([134.134.136.126]:10998 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728273AbfFQW6w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 18:58:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 15:58:50 -0700
X-ExtLoop1: 1
Received: from mjmartin-nuc01.amr.corp.intel.com (HELO mjmartin-nuc01.sea.intel.com) ([10.241.98.42])
  by orsmga002.jf.intel.com with ESMTP; 17 Jun 2019 15:58:50 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     edumazet@google.com, netdev@vger.kernel.org
Cc:     Peter Krystad <peter.krystad@linux.intel.com>, cpaasch@apple.com,
        fw@strlen.de, pabeni@redhat.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH net-next 10/33] mptcp: Create SUBFLOW socket for incoming connections
Date:   Mon, 17 Jun 2019 15:57:45 -0700
Message-Id: <20190617225808.665-11-mathew.j.martineau@linux.intel.com>
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

Add subflow_request_sock type that extends tcp_request_sock
and add an is_mptcp flag to tcp_request_sock distinguish them.

Override the listen() and accept() methods of the MPTCP
socket proto_ops so they may act on the subflow socket.

Override the conn_request() and syn_recv_sock() handlers
in the inet_connection_sock to handle incoming MPTCP
SYNs and the ACK to the response SYN.

Add handling in tcp_output.c to add MP_CAPABLE to an outgoing
SYN-ACK response for a subflow_request_sock.

Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 include/linux/tcp.h   |   3 +
 include/net/mptcp.h   |  19 ++++++
 net/ipv4/tcp_input.c  |   3 +
 net/ipv4/tcp_output.c |  18 +++++
 net/mptcp/options.c   |  57 +++++++++++++++-
 net/mptcp/protocol.c  |  94 +++++++++++++++++++++++++-
 net/mptcp/protocol.h  |  20 ++++++
 net/mptcp/subflow.c   | 150 ++++++++++++++++++++++++++++++++++++++++--
 8 files changed, 357 insertions(+), 7 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index b8c24bd8c862..fcbe8443aaad 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -139,6 +139,9 @@ struct tcp_request_sock {
 	const struct tcp_request_sock_ops *af_specific;
 	u64				snt_synack; /* first SYNACK sent time */
 	bool				tfo_listener;
+#if IS_ENABLED(CONFIG_MPTCP)
+	bool				is_mptcp;
+#endif
 	u32				txhash;
 	u32				rcv_isn;
 	u32				snt_isn;
diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 81255b0f57d7..e7cae0f4404a 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -30,11 +30,18 @@ static inline bool sk_is_mptcp(const struct sock *sk)
 	return tcp_sk(sk)->is_mptcp;
 }
 
+static inline bool rsk_is_mptcp(const struct request_sock *req)
+{
+	return tcp_rsk(req)->is_mptcp;
+}
+
 void mptcp_parse_option(const unsigned char *ptr, int opsize,
 			struct tcp_options_received *opt_rx);
 bool mptcp_syn_options(struct sock *sk, unsigned int *size,
 		       struct mptcp_out_options *opts);
 void mptcp_rcv_synsent(struct sock *sk);
+bool mptcp_synack_options(const struct request_sock *req, unsigned int *size,
+			  struct mptcp_out_options *opts);
 bool mptcp_established_options(struct sock *sk, unsigned int *size,
 			       struct mptcp_out_options *opts);
 
@@ -51,6 +58,11 @@ static inline bool sk_is_mptcp(const struct sock *sk)
 	return false;
 }
 
+static inline bool rsk_is_mptcp(const struct request_sock *req)
+{
+	return false;
+}
+
 static inline void mptcp_parse_option(const unsigned char *ptr, int opsize,
 				      struct tcp_options_received *opt_rx)
 {
@@ -66,6 +78,13 @@ static inline void mptcp_rcv_synsent(struct sock *sk)
 {
 }
 
+static inline bool mptcp_synack_options(const struct request_sock *req,
+					unsigned int *size,
+					struct mptcp_out_options *opts)
+{
+	return false;
+}
+
 static inline bool mptcp_established_options(struct sock *sk,
 					     unsigned int *size,
 					     struct mptcp_out_options *opts)
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 4aa60fe0deca..240eb75c7b84 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6493,6 +6493,9 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 
 	tcp_rsk(req)->af_specific = af_ops;
 	tcp_rsk(req)->ts_off = 0;
+#if IS_ENABLED(CONFIG_MPTCP)
+	tcp_rsk(req)->is_mptcp = 0;
+#endif
 
 	tcp_clear_options(&tmp_opt);
 	tmp_opt.mss_clamp = af_ops->mss_clamp;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index f46e58347d73..a41ba69760f1 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -594,6 +594,22 @@ static void smc_set_option_cond(const struct tcp_sock *tp,
 #endif
 }
 
+static void mptcp_set_option_cond(const struct request_sock *req,
+				  struct tcp_out_options *opts,
+				  unsigned int *remaining)
+{
+	if (rsk_is_mptcp(req)) {
+		unsigned int size;
+
+		if (mptcp_synack_options(req, &size, &opts->mptcp)) {
+			if (*remaining >= size) {
+				opts->options |= OPTION_MPTCP;
+				*remaining -= size;
+			}
+		}
+	}
+}
+
 /* Compute TCP options for SYN packets. This is not the final
  * network wire format yet.
  */
@@ -733,6 +749,8 @@ static unsigned int tcp_synack_options(const struct sock *sk,
 		}
 	}
 
+	mptcp_set_option_cond(req, opts, &remaining);
+
 	smc_set_option_cond(tcp_sk(sk), ireq, opts, &remaining);
 
 	return MAX_TCP_OPTION_SPACE - remaining;
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 071e937d5c1f..d8e77cd5664d 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -121,6 +121,39 @@ void mptcp_parse_option(const unsigned char *ptr, int opsize,
 	}
 }
 
+void mptcp_get_options(const struct sk_buff *skb,
+		       struct tcp_options_received *opt_rx)
+{
+	const unsigned char *ptr;
+	const struct tcphdr *th = tcp_hdr(skb);
+	int length = (th->doff * 4) - sizeof(struct tcphdr);
+
+	ptr = (const unsigned char *)(th + 1);
+
+	while (length > 0) {
+		int opcode = *ptr++;
+		int opsize;
+
+		switch (opcode) {
+		case TCPOPT_EOL:
+			return;
+		case TCPOPT_NOP:	/* Ref: RFC 793 section 3.1 */
+			length--;
+			continue;
+		default:
+			opsize = *ptr++;
+			if (opsize < 2) /* "silly options" */
+				return;
+			if (opsize > length)
+				return;	/* don't parse partial options */
+			if (opcode == TCPOPT_MPTCP)
+				mptcp_parse_option(ptr, opsize, opt_rx);
+			ptr += opsize - 2;
+			length -= opsize;
+		}
+	}
+}
+
 bool mptcp_syn_options(struct sock *sk, unsigned int *size,
 		       struct mptcp_out_options *opts)
 {
@@ -166,14 +199,35 @@ bool mptcp_established_options(struct sock *sk, unsigned int *size,
 	return false;
 }
 
+bool mptcp_synack_options(const struct request_sock *req, unsigned int *size,
+			  struct mptcp_out_options *opts)
+{
+	struct subflow_request_sock *subflow_req = subflow_rsk(req);
+
+	if (subflow_req->mp_capable) {
+		opts->suboptions = OPTION_MPTCP_MPC_SYNACK;
+		opts->sndr_key = subflow_req->local_key;
+		opts->rcvr_key = subflow_req->remote_key;
+		*size = TCPOLEN_MPTCP_MPC_SYNACK;
+		pr_debug("subflow_req=%p, local_key=%llu, remote_key=%llu",
+			 subflow_req, subflow_req->local_key,
+			 subflow_req->remote_key);
+		return true;
+	}
+	return false;
+}
+
 void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
 {
 	if ((OPTION_MPTCP_MPC_SYN |
+	     OPTION_MPTCP_MPC_SYNACK |
 	     OPTION_MPTCP_MPC_ACK) & opts->suboptions) {
 		u8 len;
 
 		if (OPTION_MPTCP_MPC_SYN & opts->suboptions)
 			len = TCPOLEN_MPTCP_MPC_SYN;
+		else if (OPTION_MPTCP_MPC_SYNACK & opts->suboptions)
+			len = TCPOLEN_MPTCP_MPC_SYNACK;
 		else
 			len = TCPOLEN_MPTCP_MPC_ACK;
 
@@ -183,7 +237,8 @@ void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
 			       MPTCP_CAP_HMAC_SHA1);
 		put_unaligned_be64(opts->sndr_key, ptr);
 		ptr += 2;
-		if (OPTION_MPTCP_MPC_ACK & opts->suboptions) {
+		if ((OPTION_MPTCP_MPC_SYNACK |
+		     OPTION_MPTCP_MPC_ACK) & opts->suboptions) {
 			put_unaligned_be64(opts->rcvr_key, ptr);
 			ptr += 2;
 		}
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 3d9cd52e3e1e..ea771f537ac0 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -69,7 +69,8 @@ static void mptcp_close(struct sock *sk, long timeout)
 	}
 
 	if (msk->connection_list) {
-		pr_debug("conn_list->subflow=%p", msk->connection_list->sk);
+		pr_debug("conn_list->subflow=%p",
+			 subflow_ctx(msk->connection_list->sk));
 		sock_release(msk->connection_list);
 	}
 
@@ -77,6 +78,47 @@ static void mptcp_close(struct sock *sk, long timeout)
 	sock_put(sk);
 }
 
+static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
+				 bool kern)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct socket *listener = msk->subflow;
+	struct socket *new_sock;
+	struct socket *new_mptcp_sock;
+	struct subflow_context *subflow;
+
+	pr_debug("msk=%p, listener=%p", msk, subflow_ctx(listener->sk));
+	*err = kernel_accept(listener, &new_sock, flags);
+	if (*err < 0)
+		return NULL;
+
+	subflow = subflow_ctx(new_sock->sk);
+	pr_debug("msk=%p, new subflow=%p, ", msk, subflow);
+
+	*err = sock_create(PF_INET, SOCK_STREAM, IPPROTO_MPTCP,
+			   &new_mptcp_sock);
+	if (*err < 0) {
+		kernel_sock_shutdown(new_sock, SHUT_RDWR);
+		sock_release(new_sock);
+		return NULL;
+	}
+
+	msk = mptcp_sk(new_mptcp_sock->sk);
+	pr_debug("new msk=%p", msk);
+	subflow->conn = new_mptcp_sock->sk;
+	subflow->tcp_sock = new_sock;
+
+	if (subflow->mp_capable) {
+		msk->remote_key = subflow->remote_key;
+		msk->local_key = subflow->local_key;
+		msk->connection_list = new_sock;
+	} else {
+		msk->subflow = new_sock;
+	}
+
+	return new_mptcp_sock->sk;
+}
+
 static int mptcp_get_port(struct sock *sk, unsigned short snum)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -105,7 +147,7 @@ static struct proto mptcp_prot = {
 	.owner		= THIS_MODULE,
 	.init		= mptcp_init_sock,
 	.close		= mptcp_close,
-	.accept		= inet_csk_accept,
+	.accept		= mptcp_accept,
 	.shutdown	= tcp_shutdown,
 	.sendmsg	= mptcp_sendmsg,
 	.recvmsg	= mptcp_recvmsg,
@@ -181,6 +223,51 @@ static int mptcp_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	return inet_stream_connect(msk->subflow, uaddr, addr_len, flags);
 }
 
+static int mptcp_getname(struct socket *sock, struct sockaddr *uaddr,
+			 int peer)
+{
+	struct mptcp_sock *msk = mptcp_sk(sock->sk);
+	struct socket *subflow;
+	int err = -EPERM;
+
+	if (msk->connection_list)
+		subflow = msk->connection_list;
+	else
+		subflow = msk->subflow;
+
+	err = inet_getname(subflow, uaddr, peer);
+
+	return err;
+}
+
+static int mptcp_listen(struct socket *sock, int backlog)
+{
+	struct mptcp_sock *msk = mptcp_sk(sock->sk);
+	int err;
+
+	pr_debug("msk=%p", msk);
+
+	if (!msk->subflow) {
+		err = mptcp_subflow_create(sock->sk);
+		if (err)
+			return err;
+	}
+	return inet_listen(msk->subflow, backlog);
+}
+
+static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
+			       int flags, bool kern)
+{
+	struct mptcp_sock *msk = mptcp_sk(sock->sk);
+
+	pr_debug("msk=%p", msk);
+
+	if (!msk->subflow)
+		return -EINVAL;
+
+	return inet_accept(sock, newsock, flags, kern);
+}
+
 static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 			   struct poll_table_struct *wait)
 {
@@ -211,6 +298,9 @@ void __init mptcp_init(void)
 	mptcp_stream_ops.bind = mptcp_bind;
 	mptcp_stream_ops.connect = mptcp_stream_connect;
 	mptcp_stream_ops.poll = mptcp_poll;
+	mptcp_stream_ops.accept = mptcp_stream_accept;
+	mptcp_stream_ops.getname = mptcp_getname;
+	mptcp_stream_ops.listen = mptcp_listen;
 
 	subflow_init();
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 9206e60ef6d3..34eb10c279f0 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -44,6 +44,23 @@ static inline struct mptcp_sock *mptcp_sk(const struct sock *sk)
 	return (struct mptcp_sock *)sk;
 }
 
+struct subflow_request_sock {
+	struct	tcp_request_sock sk;
+	u8	mp_capable : 1,
+		mp_join : 1,
+		checksum : 1,
+		backup : 1,
+		version : 4;
+	u64	local_key;
+	u64	remote_key;
+};
+
+static inline
+struct subflow_request_sock *subflow_rsk(const struct request_sock *rsk)
+{
+	return (struct subflow_request_sock *)rsk;
+}
+
 /* MPTCP subflow context */
 struct subflow_context {
 	u64	local_key;
@@ -75,6 +92,9 @@ void subflow_init(void);
 
 extern const struct inet_connection_sock_af_ops ipv4_specific;
 
+void mptcp_get_options(const struct sk_buff *skb,
+		       struct tcp_options_received *opt_rx);
+
 void mptcp_finish_connect(struct sock *sk, int mp_capable);
 
 #endif /* __MPTCP_PROTOCOL_H */
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 91df2c4be339..fd2bf7621f0e 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -15,6 +15,37 @@
 #include <net/mptcp.h>
 #include "protocol.h"
 
+static void subflow_v4_init_req(struct request_sock *req,
+				const struct sock *sk_listener,
+				struct sk_buff *skb)
+{
+	struct subflow_request_sock *subflow_req = subflow_rsk(req);
+	struct subflow_context *listener = subflow_ctx(sk_listener);
+	struct tcp_options_received rx_opt;
+
+	tcp_rsk(req)->is_mptcp = 1;
+	pr_debug("subflow_req=%p, listener=%p", subflow_req, listener);
+
+	tcp_request_sock_ipv4_ops.init_req(req, sk_listener, skb);
+
+	memset(&rx_opt.mptcp, 0, sizeof(rx_opt.mptcp));
+	mptcp_get_options(skb, &rx_opt);
+
+	if (rx_opt.mptcp.mp_capable && listener->request_mptcp) {
+		subflow_req->mp_capable = 1;
+		if (rx_opt.mptcp.version >= listener->version)
+			subflow_req->version = listener->version;
+		else
+			subflow_req->version = rx_opt.mptcp.version;
+		if ((rx_opt.mptcp.flags & MPTCP_CAP_CHECKSUM_REQD) ||
+		    listener->request_cksum)
+			subflow_req->checksum = 1;
+		subflow_req->remote_key = rx_opt.mptcp.sndr_key;
+	} else {
+		subflow_req->mp_capable = 0;
+	}
+}
+
 static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 {
 	struct subflow_context *subflow = subflow_ctx(sk);
@@ -29,21 +60,82 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 	}
 }
 
+static struct request_sock_ops subflow_request_sock_ops;
+static struct tcp_request_sock_ops subflow_request_sock_ipv4_ops;
+
+static int subflow_conn_request(struct sock *sk, struct sk_buff *skb)
+{
+	struct subflow_context *subflow = subflow_ctx(sk);
+
+	pr_debug("subflow=%p", subflow);
+
+	/* Never answer to SYNs sent to broadcast or multicast */
+	if (skb_rtable(skb)->rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))
+		goto drop;
+
+	return tcp_conn_request(&subflow_request_sock_ops,
+				&subflow_request_sock_ipv4_ops,
+				sk, skb);
+drop:
+	tcp_listendrop(sk);
+	return 0;
+}
+
+static struct sock *subflow_syn_recv_sock(const struct sock *sk,
+					  struct sk_buff *skb,
+					  struct request_sock *req,
+					  struct dst_entry *dst,
+					  struct request_sock *req_unhash,
+					  bool *own_req)
+{
+	struct subflow_context *listener = subflow_ctx(sk);
+	struct subflow_request_sock *subflow_req = subflow_rsk(req);
+	struct tcp_options_received opt_rx;
+	struct sock *child;
+
+	pr_debug("listener=%p, req=%p, conn=%p", listener, req, listener->conn);
+
+	if (subflow_req->mp_capable) {
+		opt_rx.mptcp.mp_capable = 0;
+		mptcp_get_options(skb, &opt_rx);
+		if (!opt_rx.mptcp.mp_capable ||
+		    subflow_req->local_key != opt_rx.mptcp.rcvr_key ||
+		    subflow_req->remote_key != opt_rx.mptcp.sndr_key)
+			return NULL;
+	}
+
+	child = tcp_v4_syn_recv_sock(sk, skb, req, dst, req_unhash, own_req);
+
+	if (child && *own_req) {
+		if (!subflow_ctx(child)) {
+			pr_debug("Closing child socket");
+			inet_sk_set_state(child, TCP_CLOSE);
+			sock_set_flag(child, SOCK_DEAD);
+			inet_csk_destroy_sock(child);
+			child = NULL;
+		}
+	}
+
+	return child;
+}
+
 static struct inet_connection_sock_af_ops subflow_specific;
 
 static struct subflow_context *subflow_create_ctx(struct sock *sk,
-						  struct socket *sock)
+						  struct socket *sock,
+						  gfp_t priority)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct subflow_context *ctx;
 
-	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	ctx = kzalloc(sizeof(*ctx), priority);
+	icsk->icsk_ulp_data = ctx;
+
 	if (!ctx)
 		return NULL;
 
 	pr_debug("subflow=%p", ctx);
 
-	icsk->icsk_ulp_data = ctx;
 	/* might be NULL */
 	ctx->tcp_sock = sock;
 
@@ -57,7 +149,7 @@ static int subflow_ulp_init(struct sock *sk)
 	struct subflow_context *ctx;
 	int err = 0;
 
-	ctx = subflow_create_ctx(sk, sk->sk_socket);
+	ctx = subflow_create_ctx(sk, sk->sk_socket, GFP_KERNEL);
 	if (!ctx) {
 		err = -ENOMEM;
 		goto out;
@@ -80,16 +172,66 @@ static void subflow_ulp_release(struct sock *sk)
 	kfree(ctx);
 }
 
+static void subflow_ulp_clone(const struct request_sock *req,
+			      struct sock *newsk,
+			      const gfp_t priority)
+{
+	struct subflow_request_sock *subflow_req = subflow_rsk(req);
+
+	/* newsk->sk_socket is NULL at this point */
+	struct subflow_context *subflow = subflow_create_ctx(newsk, NULL,
+							     priority);
+
+	if (!subflow)
+		return;
+
+	subflow->conn = NULL;
+	subflow->conn_finished = 1;
+
+	if (subflow_req->mp_capable) {
+		subflow->mp_capable = 1;
+		subflow->fourth_ack = 1;
+		subflow->remote_key = subflow_req->remote_key;
+		subflow->local_key = subflow_req->local_key;
+	}
+}
+
 static struct tcp_ulp_ops subflow_ulp_ops __read_mostly = {
 	.name		= "mptcp",
 	.owner		= THIS_MODULE,
 	.init		= subflow_ulp_init,
 	.release	= subflow_ulp_release,
+	.clone		= subflow_ulp_clone,
 };
 
+static int subflow_ops_init(struct request_sock_ops *subflow_ops)
+{
+	subflow_ops->obj_size = sizeof(struct subflow_request_sock);
+	subflow_ops->slab_name = "request_sock_subflow";
+
+	subflow_ops->slab = kmem_cache_create(subflow_ops->slab_name,
+					      subflow_ops->obj_size, 0,
+					      SLAB_ACCOUNT |
+					      SLAB_TYPESAFE_BY_RCU,
+					      NULL);
+	if (!subflow_ops->slab)
+		return -ENOMEM;
+
+	return 0;
+}
+
 void subflow_init(void)
 {
+	subflow_request_sock_ops = tcp_request_sock_ops;
+	if (subflow_ops_init(&subflow_request_sock_ops) != 0)
+		panic("MPTCP: failed to init subflow request sock ops\n");
+
+	subflow_request_sock_ipv4_ops = tcp_request_sock_ipv4_ops;
+	subflow_request_sock_ipv4_ops.init_req = subflow_v4_init_req;
+
 	subflow_specific = ipv4_specific;
+	subflow_specific.conn_request = subflow_conn_request;
+	subflow_specific.syn_recv_sock = subflow_syn_recv_sock;
 	subflow_specific.sk_rx_dst_set = subflow_finish_connect;
 
 	if (tcp_register_ulp(&subflow_ulp_ops) != 0)
-- 
2.22.0

