Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 884EB4958C
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbfFQW67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:58:59 -0400
Received: from mga18.intel.com ([134.134.136.126]:10995 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728524AbfFQW6y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 18:58:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 15:58:51 -0700
X-ExtLoop1: 1
Received: from mjmartin-nuc01.amr.corp.intel.com (HELO mjmartin-nuc01.sea.intel.com) ([10.241.98.42])
  by orsmga002.jf.intel.com with ESMTP; 17 Jun 2019 15:58:50 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     edumazet@google.com, netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        cpaasch@apple.com, fw@strlen.de, pabeni@redhat.com,
        peter.krystad@linux.intel.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH net-next 18/33] mptcp: Write MPTCP DSS headers to outgoing data packets
Date:   Mon, 17 Jun 2019 15:57:53 -0700
Message-Id: <20190617225808.665-19-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
References: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Per-packet metadata required to write the MPTCP DSS option is written to
the skb_ext area. One write to the socket may contain more than one
packet of data, in which case the DSS option in the first packet will
have a mapping covering all of the data in that write. Packets after the
first do not have a DSS option. This is complicated to handle under
memory pressure, since the first packet (with the DSS mapping) is pushed
to the TCP core before the remaining skbs are allocated.

The current implementation is limited. It will only send up to one page
of data. The number of bytes sent is returned so the caller knows which
bytes were sent and which were not. More work is required to ensure that
it works correctly with full buffers or under memory pressure.

The MPTCP DSS checksum is not yet implemented.

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
---
 include/net/mptcp.h   |  14 ++++-
 net/ipv4/tcp_output.c |  11 ++--
 net/mptcp/options.c   | 143 +++++++++++++++++++++++++++++++++++++++++-
 net/mptcp/protocol.c  | 117 ++++++++++++++++++++++++++++++----
 net/mptcp/protocol.h  |  18 +++++-
 net/mptcp/subflow.c   |   2 +
 net/mptcp/token.c     |  13 ++--
 7 files changed, 289 insertions(+), 29 deletions(-)

diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 30cfa473e8bf..003150a8e406 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -8,6 +8,14 @@
 #ifndef __NET_MPTCP_H
 #define __NET_MPTCP_H
 
+/* MPTCP DSS flags */
+
+#define MPTCP_DSS_DATA_FIN	BIT(4)
+#define MPTCP_DSS_DSN64		BIT(3)
+#define MPTCP_DSS_HAS_MAP	BIT(2)
+#define MPTCP_DSS_ACK64		BIT(1)
+#define MPTCP_DSS_HAS_ACK	BIT(0)
+
 /* MPTCP sk_buff extension data */
 struct mptcp_ext {
 	u64		data_ack;
@@ -34,6 +42,7 @@ struct mptcp_out_options {
 	u16 suboptions;
 	u64 sndr_key;
 	u64 rcvr_key;
+	struct mptcp_ext ext_copy;
 #endif
 };
 
@@ -58,7 +67,8 @@ bool mptcp_syn_options(struct sock *sk, unsigned int *size,
 void mptcp_rcv_synsent(struct sock *sk);
 bool mptcp_synack_options(const struct request_sock *req, unsigned int *size,
 			  struct mptcp_out_options *opts);
-bool mptcp_established_options(struct sock *sk, unsigned int *size,
+bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
+			       unsigned int *size, unsigned int remaining,
 			       struct mptcp_out_options *opts);
 
 static inline bool mptcp_skb_ext_exist(const struct sk_buff *skb)
@@ -107,7 +117,9 @@ static inline bool mptcp_synack_options(const struct request_sock *req,
 }
 
 static inline bool mptcp_established_options(struct sock *sk,
+					     struct sk_buff *skb,
 					     unsigned int *size,
+					     unsigned int remaining,
 					     struct mptcp_out_options *opts)
 {
 	return false;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 4e49b2c40820..5fe9459bbd6a 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -796,13 +796,12 @@ static unsigned int tcp_established_options(struct sock *sk, struct sk_buff *skb
 	 */
 	if (sk_is_mptcp(sk)) {
 		unsigned int remaining = MAX_TCP_OPTION_SPACE - size;
-		unsigned int opt_size;
+		unsigned int opt_size = 0;
 
-		if (mptcp_established_options(sk, &opt_size, &opts->mptcp)) {
-			if (remaining >= opt_size) {
-				opts->options |= OPTION_MPTCP;
-				size += opt_size;
-			}
+		if (mptcp_established_options(sk, skb, &opt_size, remaining,
+					      &opts->mptcp)) {
+			opts->options |= OPTION_MPTCP;
+			size += opt_size;
 		}
 	}
 
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index d8e77cd5664d..625cd93fb9a8 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -181,12 +181,13 @@ void mptcp_rcv_synsent(struct sock *sk)
 	}
 }
 
-bool mptcp_established_options(struct sock *sk, unsigned int *size,
-			       struct mptcp_out_options *opts)
+static bool mptcp_established_options_mp(struct sock *sk, unsigned int *size,
+					 unsigned int remaining,
+					 struct mptcp_out_options *opts)
 {
 	struct subflow_context *subflow = subflow_ctx(sk);
 
-	if (subflow->mp_capable && !subflow->fourth_ack) {
+	if (!subflow->fourth_ack && remaining >= TCPOLEN_MPTCP_MPC_ACK) {
 		opts->suboptions = OPTION_MPTCP_MPC_ACK;
 		opts->sndr_key = subflow->local_key;
 		opts->rcvr_key = subflow->remote_key;
@@ -199,6 +200,92 @@ bool mptcp_established_options(struct sock *sk, unsigned int *size,
 	return false;
 }
 
+static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
+					  unsigned int *size,
+					  unsigned int remaining,
+					  struct mptcp_out_options *opts)
+{
+	unsigned int dss_size = 0;
+	struct mptcp_ext *mpext;
+	unsigned int ack_size;
+
+	mpext = skb ? mptcp_get_ext(skb) : NULL;
+
+	if (!skb || (mpext && mpext->use_map)) {
+		unsigned int map_size;
+		bool use_csum;
+
+		map_size = TCPOLEN_MPTCP_DSS_BASE + TCPOLEN_MPTCP_DSS_MAP64;
+		use_csum = subflow_ctx(sk)->use_checksum;
+		if (use_csum)
+			map_size += TCPOLEN_MPTCP_DSS_CHECKSUM;
+
+		if (map_size <= remaining) {
+			remaining -= map_size;
+			dss_size = map_size;
+			if (mpext) {
+				opts->ext_copy.data_seq = mpext->data_seq;
+				opts->ext_copy.subflow_seq = mpext->subflow_seq;
+				opts->ext_copy.data_len = mpext->data_len;
+				opts->ext_copy.checksum = mpext->checksum;
+				opts->ext_copy.use_map = 1;
+				opts->ext_copy.dsn64 = mpext->dsn64;
+				opts->ext_copy.use_checksum = use_csum;
+			}
+		} else {
+			opts->ext_copy.use_map = 0;
+			WARN_ONCE(1, "MPTCP: Map dropped");
+		}
+	}
+
+	if (mpext && mpext->use_ack) {
+		ack_size = TCPOLEN_MPTCP_DSS_ACK64;
+
+		/* Add kind/lenght/subtype/flag overhead if mapping is not
+		 * populated
+		 */
+		if (dss_size == 0)
+			ack_size += TCPOLEN_MPTCP_DSS_BASE;
+
+		if (ack_size <= remaining) {
+			dss_size += ack_size;
+
+			opts->ext_copy.data_ack = mpext->data_ack;
+			opts->ext_copy.ack64 = 1;
+			opts->ext_copy.use_ack = 1;
+		} else {
+			opts->ext_copy.use_ack = 0;
+			WARN(1, "MPTCP: Ack dropped");
+		}
+	}
+
+	*size = ALIGN(dss_size, 4);
+	return true;
+}
+
+bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
+			       unsigned int *size, unsigned int remaining,
+			       struct mptcp_out_options *opts)
+{
+	unsigned int opt_size = 0;
+
+	if (!subflow_ctx(sk)->mp_capable)
+		return false;
+
+	if (mptcp_established_options_mp(sk, &opt_size, remaining, opts)) {
+		*size += opt_size;
+		remaining -= opt_size;
+		return true;
+	} else if (mptcp_established_options_dss(sk, skb, &opt_size, remaining,
+					       opts)) {
+		*size += opt_size;
+		remaining -= opt_size;
+		return true;
+	}
+
+	return false;
+}
+
 bool mptcp_synack_options(const struct request_sock *req, unsigned int *size,
 			  struct mptcp_out_options *opts)
 {
@@ -243,4 +330,54 @@ void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
 			ptr += 2;
 		}
 	}
+
+	if (opts->ext_copy.use_ack || opts->ext_copy.use_map) {
+		struct mptcp_ext *mpext = &opts->ext_copy;
+		u8 len = TCPOLEN_MPTCP_DSS_BASE;
+		u8 flags = 0;
+
+		if (mpext->use_ack) {
+			len += TCPOLEN_MPTCP_DSS_ACK64;
+			flags = MPTCP_DSS_HAS_ACK | MPTCP_DSS_ACK64;
+		}
+
+		if (mpext->use_map) {
+			len += TCPOLEN_MPTCP_DSS_MAP64;
+
+			if (mpext->use_checksum)
+				len += TCPOLEN_MPTCP_DSS_CHECKSUM;
+
+			/* Use only 64-bit mapping flags for now, add
+			 * support for optional 32-bit mappings later.
+			 */
+			flags |= MPTCP_DSS_HAS_MAP | MPTCP_DSS_DSN64;
+			if (mpext->data_fin)
+				flags |= MPTCP_DSS_DATA_FIN;
+		}
+
+		*ptr++ = htonl((TCPOPT_MPTCP << 24) |
+			       (len  << 16) |
+			       (MPTCPOPT_DSS << 12) |
+			       (flags));
+
+		if (mpext->use_ack) {
+			put_unaligned_be64(mpext->data_ack, ptr);
+			ptr += 2;
+		}
+
+		if (mpext->use_map) {
+			__sum16 checksum;
+
+			pr_debug("Writing map values");
+			put_unaligned_be64(mpext->data_seq, ptr);
+			ptr += 2;
+			*ptr++ = htonl(mpext->subflow_seq);
+
+			if (mpext->use_checksum)
+				checksum = mpext->checksum;
+			else
+				checksum = TCPOPT_NOP << 8 | TCPOPT_NOP;
+			*ptr = htonl(mpext->data_len << 16 | checksum);
+		}
+	}
 }
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 3215601b9c43..a6e6367c8ed1 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -18,17 +18,104 @@
 static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
-	struct socket *subflow;
+	int mss_now, size_goal, poffset, ret;
+	struct mptcp_ext *mpext = NULL;
+	struct page *page = NULL;
+	struct sk_buff *skb;
+	struct sock *ssk;
+	size_t psize;
 
-	if (msk->connection_list) {
-		subflow = msk->connection_list;
-		pr_debug("conn_list->subflow=%p", subflow_ctx(subflow->sk));
-	} else {
-		subflow = msk->subflow;
-		pr_debug("subflow=%p", subflow_ctx(subflow->sk));
+	pr_debug("msk=%p", msk);
+	if (!msk->connection_list && msk->subflow) {
+		pr_debug("fallback passthrough");
+		return sock_sendmsg(msk->subflow, msg);
 	}
 
-	return sock_sendmsg(subflow, msg);
+	if (!msg_data_left(msg)) {
+		pr_debug("empty send");
+		return sock_sendmsg(msk->connection_list, msg);
+	}
+
+	ssk = msk->connection_list->sk;
+
+	if (msg->msg_flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL))
+		return -ENOTSUPP;
+
+	/* Initial experiment: new page per send.  Real code will
+	 * maintain list of active pages and DSS mappings, append to the
+	 * end and honor zerocopy
+	 */
+	page = alloc_page(GFP_KERNEL);
+	if (!page)
+		return -ENOMEM;
+
+	/* Copy to page */
+	poffset = 0;
+	pr_debug("left=%zu", msg_data_left(msg));
+	psize = copy_page_from_iter(page, poffset,
+				    min_t(size_t, msg_data_left(msg),
+					  PAGE_SIZE),
+				    &msg->msg_iter);
+	pr_debug("left=%zu", msg_data_left(msg));
+
+	if (!psize) {
+		put_page(page);
+		return -EINVAL;
+	}
+
+	lock_sock(sk);
+	lock_sock(ssk);
+
+	/* Mark the end of the previous write so the beginning of the
+	 * next write (with its own mptcp skb extension data) is not
+	 * collapsed.
+	 */
+	skb = tcp_write_queue_tail(ssk);
+	if (skb)
+		TCP_SKB_CB(skb)->eor = 1;
+
+	mss_now = tcp_send_mss(ssk, &size_goal, msg->msg_flags);
+
+	ret = do_tcp_sendpages(ssk, page, poffset, min_t(int, size_goal, psize),
+			       msg->msg_flags | MSG_SENDPAGE_NOTLAST);
+	put_page(page);
+	if (ret <= 0)
+		goto error_out;
+
+	if (skb == tcp_write_queue_tail(ssk))
+		pr_err("no new skb %p/%p", sk, ssk);
+
+	skb = tcp_write_queue_tail(ssk);
+
+	mpext = skb_ext_add(skb, SKB_EXT_MPTCP);
+
+	if (mpext) {
+		memset(mpext, 0, sizeof(*mpext));
+		mpext->data_ack = msk->ack_seq;
+		mpext->data_seq = msk->write_seq;
+		mpext->subflow_seq = subflow_ctx(ssk)->rel_write_seq;
+		mpext->data_len = ret;
+		mpext->checksum = 0xbeef;
+		mpext->use_map = 1;
+		mpext->dsn64 = 1;
+		mpext->use_ack = 1;
+		mpext->ack64 = 1;
+
+		pr_debug("data_seq=%llu subflow_seq=%u data_len=%u checksum=%u, dsn64=%d",
+			 mpext->data_seq, mpext->subflow_seq, mpext->data_len,
+			 mpext->checksum, mpext->dsn64);
+	} /* TODO: else fallback */
+
+	msk->write_seq += ret;
+	subflow_ctx(ssk)->rel_write_seq += ret;
+
+	tcp_push(ssk, msg->msg_flags, mss_now, tcp_sk(ssk)->nonagle, size_goal);
+
+error_out:
+	release_sock(ssk);
+	release_sock(sk);
+
+	return ret;
 }
 
 static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
@@ -109,11 +196,14 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 	subflow->tcp_sock = new_sock;
 
 	if (subflow->mp_capable) {
-		msk->remote_key = subflow->remote_key;
 		msk->local_key = subflow->local_key;
 		msk->token = subflow->token;
-		pr_debug("token=%u", msk->token);
 		token_update_accept(new_sock->sk, new_mptcp_sock->sk);
+		msk->write_seq = subflow->idsn + 1;
+		subflow->rel_write_seq = 1;
+		msk->remote_key = subflow->remote_key;
+		crypto_key_sha1(msk->remote_key, NULL, &msk->ack_seq);
+		msk->ack_seq++;
 		msk->connection_list = new_sock;
 	} else {
 		msk->subflow = new_sock;
@@ -192,10 +282,13 @@ void mptcp_finish_connect(struct sock *sk, int mp_capable)
 	struct subflow_context *subflow = subflow_ctx(msk->subflow->sk);
 
 	if (mp_capable) {
-		msk->remote_key = subflow->remote_key;
 		msk->local_key = subflow->local_key;
 		msk->token = subflow->token;
-		pr_debug("token=%u", msk->token);
+		msk->write_seq = subflow->idsn + 1;
+		subflow->rel_write_seq = 1;
+		msk->remote_key = subflow->remote_key;
+		crypto_key_sha1(msk->remote_key, NULL, &msk->ack_seq);
+		msk->ack_seq++;
 		msk->connection_list = msk->subflow;
 		msk->subflow = NULL;
 	}
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 5a8ed316d70e..79a9ce6c4d31 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -21,6 +21,10 @@
 #define TCPOLEN_MPTCP_MPC_SYN		12
 #define TCPOLEN_MPTCP_MPC_SYNACK	20
 #define TCPOLEN_MPTCP_MPC_ACK		20
+#define TCPOLEN_MPTCP_DSS_BASE		4
+#define TCPOLEN_MPTCP_DSS_ACK64		8
+#define TCPOLEN_MPTCP_DSS_MAP64		14
+#define TCPOLEN_MPTCP_DSS_CHECKSUM	2
 
 /* MPTCP MP_CAPABLE flags */
 #define MPTCP_VERSION_MASK	(0x0F)
@@ -35,6 +39,8 @@ struct mptcp_sock {
 	struct	inet_connection_sock sk;
 	u64	local_key;
 	u64	remote_key;
+	u64	write_seq;
+	u64	ack_seq;
 	u32	token;
 	struct	socket *connection_list; /* @@ needs to be a list */
 	struct	socket *subflow; /* outgoing connect, listener or !mp_capable */
@@ -54,6 +60,7 @@ struct subflow_request_sock {
 		version : 4;
 	u64	local_key;
 	u64	remote_key;
+	u64	idsn;
 	u32	token;
 };
 
@@ -68,12 +75,16 @@ struct subflow_context {
 	u64	local_key;
 	u64	remote_key;
 	u32	token;
+	u32     rel_write_seq;
+	u64     idsn;
 	u32	request_mptcp : 1,  /* send MP_CAPABLE */
 		request_cksum : 1,
 		mp_capable : 1,	    /* remote is MPTCP capable */
 		fourth_ack : 1,     /* send initial DSS */
 		version : 4,
-		conn_finished : 1;
+		conn_finished : 1,
+		use_checksum : 1;
+
 	struct  socket *tcp_sock;  /* underlying tcp_sock */
 	struct  sock *conn;        /* parent mptcp_sock */
 };
@@ -123,4 +134,9 @@ void crypto_key_sha1(u64 key, u32 *token, u64 *idsn);
 void crypto_hmac_sha1(u64 key1, u64 key2, u32 *hash_out,
 		      int arg_num, ...);
 
+static inline struct mptcp_ext *mptcp_get_ext(struct sk_buff *skb)
+{
+	return (struct mptcp_ext *)skb_ext_find(skb, SKB_EXT_MPTCP);
+}
+
 #endif /* __MPTCP_PROTOCOL_H */
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index abae6a42a101..bbfdf03489bb 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -188,6 +188,7 @@ static int subflow_ulp_init(struct sock *sk)
 
 	tp->is_mptcp = 1;
 	icsk->icsk_af_ops = &subflow_specific;
+	ctx->use_checksum = 0;
 out:
 	return err;
 }
@@ -216,6 +217,7 @@ static void subflow_ulp_clone(const struct request_sock *req,
 
 	subflow->conn = NULL;
 	subflow->conn_finished = 1;
+	subflow->use_checksum = 0;
 
 	if (subflow_req->mp_capable) {
 		subflow->mp_capable = 1;
diff --git a/net/mptcp/token.c b/net/mptcp/token.c
index 8c15b8134f70..b055a3e82add 100644
--- a/net/mptcp/token.c
+++ b/net/mptcp/token.c
@@ -74,10 +74,11 @@ static void new_req_token(struct request_sock *req,
 					      ireq->ir_rmt_port);
 #endif
 	}
-	pr_debug("local_key=%llu:%llx", local_key, local_key);
 	subflow_req->local_key = local_key;
-	crypto_key_sha1(subflow_req->local_key, &subflow_req->token, NULL);
-	pr_debug("token=%u", subflow_req->token);
+	crypto_key_sha1(subflow_req->local_key, &subflow_req->token,
+			&subflow_req->idsn);
+	pr_debug("local_key=%llu, token=%u, idsn=%llu", subflow_req->local_key,
+		 subflow_req->token, subflow_req->idsn);
 }
 
 static void new_token(const struct sock *sk)
@@ -98,9 +99,9 @@ static void new_token(const struct sock *sk)
 						       isk->inet_dport);
 #endif
 	}
-	pr_debug("local_key=%llu:%llx", subflow->local_key, subflow->local_key);
-	crypto_key_sha1(subflow->local_key, &subflow->token, NULL);
-	pr_debug("token=%u", subflow->token);
+	crypto_key_sha1(subflow->local_key, &subflow->token, &subflow->idsn);
+	pr_debug("local_key=%llu, token=%u, idsn=%llu", subflow->local_key,
+		 subflow->token, subflow->idsn);
 }
 
 static int insert_req_token(u32 token)
-- 
2.22.0

