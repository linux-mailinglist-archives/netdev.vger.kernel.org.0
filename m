Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5287C94E6
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbfJBXhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:37:24 -0400
Received: from mga04.intel.com ([192.55.52.120]:16453 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728958AbfJBXhW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:37:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:37:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366862595"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.30.230])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 16:37:20 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Peter Krystad <peter.krystad@linux.intel.com>, cpaasch@apple.com,
        fw@strlen.de, pabeni@redhat.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH v2 12/45] mptcp: Create SUBFLOW socket for incoming connections
Date:   Wed,  2 Oct 2019 16:36:22 -0700
Message-Id: <20191002233655.24323-13-mathew.j.martineau@linux.intel.com>
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
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/linux/tcp.h   |   3 +
 include/net/mptcp.h   |  19 ++++++
 net/ipv4/tcp_input.c  |   3 +
 net/ipv4/tcp_output.c |  18 ++++++
 net/mptcp/options.c   |  57 ++++++++++++++++-
 net/mptcp/protocol.c  | 138 ++++++++++++++++++++++++++++++++++++++++-
 net/mptcp/protocol.h  |  20 ++++++
 net/mptcp/subflow.c   | 140 ++++++++++++++++++++++++++++++++++++++++--
 8 files changed, 392 insertions(+), 6 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index b3311659c39a..220883a7a4db 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -134,6 +134,9 @@ struct tcp_request_sock {
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
index e3e248b16016..1a3ed7734bb4 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -25,11 +25,18 @@ static inline bool sk_is_mptcp(const struct sock *sk)
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
 
@@ -46,6 +53,11 @@ static inline bool sk_is_mptcp(const struct sock *sk)
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
@@ -61,6 +73,13 @@ static inline void mptcp_rcv_synsent(struct sock *sk)
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
index e28f308006da..218df735c822 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6583,6 +6583,9 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 
 	tcp_rsk(req)->af_specific = af_ops;
 	tcp_rsk(req)->ts_off = 0;
+#if IS_ENABLED(CONFIG_MPTCP)
+	tcp_rsk(req)->is_mptcp = 0;
+#endif
 
 	tcp_clear_options(&tmp_opt);
 	tmp_opt.mss_clamp = af_ops->mss_clamp;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 2354500c8ebb..e21e8134559a 100644
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
index 94508c0d887a..4fdd5178fe78 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -134,6 +134,39 @@ void mptcp_parse_option(const unsigned char *ptr, int opsize,
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
@@ -179,14 +212,35 @@ bool mptcp_established_options(struct sock *sk, unsigned int *size,
 	return false;
 }
 
+bool mptcp_synack_options(const struct request_sock *req, unsigned int *size,
+			  struct mptcp_out_options *opts)
+{
+	struct mptcp_subflow_request_sock *subflow_req = mptcp_subflow_rsk(req);
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
 
@@ -196,7 +250,8 @@ void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
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
index 07508d060b3d..5605391fc32a 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -156,6 +156,65 @@ static void mptcp_close(struct sock *sk, long timeout)
 	sk_common_release(sk);
 }
 
+static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
+				 bool kern)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct mptcp_subflow_context *subflow;
+	struct socket *new_sock;
+	struct socket *listener;
+	struct sock *newsk;
+
+	listener = msk->subflow;
+
+	pr_debug("msk=%p, listener=%p", msk, mptcp_subflow_ctx(listener->sk));
+	*err = kernel_accept(listener, &new_sock, flags);
+	if (*err < 0)
+		return NULL;
+
+	subflow = mptcp_subflow_ctx(new_sock->sk);
+	pr_debug("msk=%p, new subflow=%p, ", msk, subflow);
+
+	if (subflow->mp_capable) {
+		struct sock *new_mptcp_sock;
+
+		lock_sock(sk);
+
+		local_bh_disable();
+		new_mptcp_sock = sk_clone_lock(sk, GFP_ATOMIC);
+		if (!new_mptcp_sock) {
+			*err = -ENOBUFS;
+			local_bh_enable();
+			release_sock(sk);
+			kernel_sock_shutdown(new_sock, SHUT_RDWR);
+			sock_release(new_sock);
+			return NULL;
+		}
+
+		mptcp_init_sock(new_mptcp_sock);
+
+		msk = mptcp_sk(new_mptcp_sock);
+		msk->remote_key = subflow->remote_key;
+		msk->local_key = subflow->local_key;
+		msk->subflow = NULL;
+
+		newsk = new_mptcp_sock;
+		subflow->conn = new_mptcp_sock;
+		list_add(&subflow->node, &msk->conn_list);
+		bh_unlock_sock(new_mptcp_sock);
+		local_bh_enable();
+		inet_sk_state_store(newsk, TCP_ESTABLISHED);
+		release_sock(sk);
+	} else {
+		newsk = new_sock->sk;
+		tcp_sk(newsk)->is_mptcp = 0;
+		new_sock->sk = NULL;
+		sock_release(new_sock);
+	}
+
+	return newsk;
+}
+
 static int mptcp_get_port(struct sock *sk, unsigned short snum)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -212,7 +271,7 @@ static struct proto mptcp_prot = {
 	.owner		= THIS_MODULE,
 	.init		= mptcp_init_sock,
 	.close		= mptcp_close,
-	.accept		= inet_csk_accept,
+	.accept		= mptcp_accept,
 	.shutdown	= tcp_shutdown,
 	.sendmsg	= mptcp_sendmsg,
 	.recvmsg	= mptcp_recvmsg,
@@ -257,6 +316,80 @@ static int mptcp_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	return inet_stream_connect(msk->subflow, uaddr, addr_len, flags);
 }
 
+static int mptcp_getname(struct socket *sock, struct sockaddr *uaddr,
+			 int peer)
+{
+	struct mptcp_sock *msk = mptcp_sk(sock->sk);
+	struct socket *ssock;
+	struct sock *ssk;
+	int ret;
+
+	if (sock->sk->sk_prot == &tcp_prot) {
+		/* we are being invoked from __sys_accept4, after
+		 * mptcp_accept() has just accepted a non-mp-capable
+		 * flow: sk is a tcp_sk, not an mptcp one.
+		 *
+		 * Hand the socket over to tcp so all further socket ops
+		 * bypass mptcp.
+		 */
+		sock->ops = &inet_stream_ops;
+		return inet_getname(sock, uaddr, peer);
+	}
+
+	lock_sock(sock->sk);
+	ssock = __mptcp_fallback_get_ref(msk);
+	if (ssock) {
+		release_sock(sock->sk);
+		pr_debug("subflow=%p", ssock->sk);
+		ret = inet_getname(ssock, uaddr, peer);
+		sock_put(ssock->sk);
+		return ret;
+	}
+
+	/* @@ the meaning of getname() for the remote peer when the socket
+	 * is connected and there are multiple subflows is not defined.
+	 * For now just use the first subflow on the list.
+	 */
+	ssk = mptcp_subflow_get_ref(msk);
+	if (!ssk) {
+		release_sock(sock->sk);
+		return -ENOTCONN;
+	}
+
+	ret = inet_getname(ssk->sk_socket, uaddr, peer);
+	release_sock(sock->sk);
+	sock_put(ssk);
+	return ret;
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
+		err = mptcp_subflow_create_socket(sock->sk, &msk->subflow);
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
@@ -304,6 +437,9 @@ void __init mptcp_init(void)
 	mptcp_stream_ops.bind = mptcp_bind;
 	mptcp_stream_ops.connect = mptcp_stream_connect;
 	mptcp_stream_ops.poll = mptcp_poll;
+	mptcp_stream_ops.accept = mptcp_stream_accept;
+	mptcp_stream_ops.getname = mptcp_getname;
+	mptcp_stream_ops.listen = mptcp_listen;
 
 	mptcp_subflow_init();
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 2e000ba7caa4..d228d1d3c8c3 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -52,6 +52,23 @@ static inline struct mptcp_sock *mptcp_sk(const struct sock *sk)
 	return (struct mptcp_sock *)sk;
 }
 
+struct mptcp_subflow_request_sock {
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
+static inline struct mptcp_subflow_request_sock *
+mptcp_subflow_rsk(const struct request_sock *rsk)
+{
+	return (struct mptcp_subflow_request_sock *)rsk;
+}
+
 /* MPTCP subflow context */
 struct mptcp_subflow_context {
 	struct	list_head node;/* conn_list of subflows */
@@ -86,6 +103,9 @@ int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock);
 
 extern const struct inet_connection_sock_af_ops ipv4_specific;
 
+void mptcp_get_options(const struct sk_buff *skb,
+		       struct tcp_options_received *opt_rx);
+
 void mptcp_finish_connect(struct sock *sk, int mp_capable);
 
 #endif /* __MPTCP_PROTOCOL_H */
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 4690410d9922..b4e86456d4d6 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -15,6 +15,37 @@
 #include <net/mptcp.h>
 #include "protocol.h"
 
+static void subflow_v4_init_req(struct request_sock *req,
+				const struct sock *sk_listener,
+				struct sk_buff *skb)
+{
+	struct mptcp_subflow_context *listener = mptcp_subflow_ctx(sk_listener);
+	struct mptcp_subflow_request_sock *subflow_req = mptcp_subflow_rsk(req);
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
+		if (rx_opt.mptcp.version >= listener->request_version)
+			subflow_req->version = listener->request_version;
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
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
@@ -29,6 +60,56 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 	}
 }
 
+static struct request_sock_ops subflow_request_sock_ops;
+static struct tcp_request_sock_ops subflow_request_sock_ipv4_ops;
+
+static int subflow_conn_request(struct sock *sk, struct sk_buff *skb)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
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
+	struct mptcp_subflow_context *listener = mptcp_subflow_ctx(sk);
+	struct sock *child;
+
+	pr_debug("listener=%p, req=%p, conn=%p", listener, req, listener->conn);
+
+	/* if the sk is MP_CAPABLE, we already received the client key */
+
+	child = tcp_v4_syn_recv_sock(sk, skb, req, dst, req_unhash, own_req);
+
+	if (child && *own_req) {
+		if (!mptcp_subflow_ctx(child)) {
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
 
 int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock)
@@ -62,18 +143,20 @@ int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock)
 }
 
 static struct mptcp_subflow_context *subflow_create_ctx(struct sock *sk,
-							struct socket *sock)
+							struct socket *sock,
+							gfp_t priority)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct mptcp_subflow_context *ctx;
 
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
 
@@ -87,7 +170,7 @@ static int subflow_ulp_init(struct sock *sk)
 	struct tcp_sock *tp = tcp_sk(sk);
 	int err = 0;
 
-	ctx = subflow_create_ctx(sk, sk->sk_socket);
+	ctx = subflow_create_ctx(sk, sk->sk_socket, GFP_KERNEL);
 	if (!ctx) {
 		err = -ENOMEM;
 		goto out;
@@ -110,16 +193,65 @@ static void subflow_ulp_release(struct sock *sk)
 	kfree(ctx);
 }
 
+static void subflow_ulp_clone(const struct request_sock *req,
+			      struct sock *newsk,
+			      const gfp_t priority)
+{
+	struct mptcp_subflow_request_sock *subflow_req = mptcp_subflow_rsk(req);
+	struct mptcp_subflow_context *new_ctx;
+
+	/* newsk->sk_socket is NULL at this point */
+	new_ctx = subflow_create_ctx(newsk, NULL, priority);
+	if (!new_ctx)
+		return;
+
+	new_ctx->conn = NULL;
+	new_ctx->conn_finished = 1;
+
+	if (subflow_req->mp_capable) {
+		new_ctx->mp_capable = 1;
+		new_ctx->fourth_ack = 1;
+		new_ctx->remote_key = subflow_req->remote_key;
+		new_ctx->local_key = subflow_req->local_key;
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
+	subflow_ops->obj_size = sizeof(struct mptcp_subflow_request_sock);
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
 void mptcp_subflow_init(void)
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
2.23.0

