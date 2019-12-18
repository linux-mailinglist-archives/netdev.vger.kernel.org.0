Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C331012525F
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 20:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbfLRTzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 14:55:22 -0500
Received: from mga05.intel.com ([192.55.52.43]:2229 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727548AbfLRTzS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 14:55:18 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 11:55:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="213019958"
Received: from mjmartin-nuc01.amr.corp.intel.com ([10.241.98.42])
  by fmsmga008.fm.intel.com with ESMTP; 18 Dec 2019 11:55:15 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Peter Krystad <peter.krystad@linux.intel.com>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next v2 09/15] mptcp: Write MPTCP DSS headers to outgoing data packets
Date:   Wed, 18 Dec 2019 11:55:04 -0800
Message-Id: <20191218195510.7782-10-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218195510.7782-1-mathew.j.martineau@linux.intel.com>
References: <20191218195510.7782-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Per-packet metadata required to write the MPTCP DSS option is written to
the skb_ext area. One write to the socket may contain more than one
packet of data, which is copied to page fragments and mapped in to MPTCP
DSS segments with size determined by the available page fragments and
the maximum mapping length allowed by the MPTCP specification. If
do_tcp_sendpages() splits a DSS segment in to multiple skbs, that's ok -
the later skbs can either have duplicated DSS mapping information or
none at all, and the receiver can handle that.

The current implementation uses the subflow frag cache and tcp
sendpages to avoid excessive code duplication. More work is required to
ensure that it works correctly under memory pressure and to support
MPTCP-level retransmissions.

The MPTCP DSS checksum is not yet implemented.

Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Co-developed-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
Co-developed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/net/mptcp.h  |   1 +
 net/mptcp/options.c  | 158 +++++++++++++++++++++++++++++++++++++++++--
 net/mptcp/protocol.c | 116 ++++++++++++++++++++++++++++++-
 net/mptcp/protocol.h |  20 ++++++
 4 files changed, 289 insertions(+), 6 deletions(-)

diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 588abcb76da3..6615920d3703 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -31,6 +31,7 @@ struct mptcp_out_options {
 	u16 suboptions;
 	u64 sndr_key;
 	u64 rcvr_key;
+	struct mptcp_ext ext_copy;
 #endif
 };
 
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 89aef0d0beb1..c9b5f37db63b 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -196,13 +196,13 @@ void mptcp_rcv_synsent(struct sock *sk)
 	}
 }
 
-bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
-			       unsigned int *size, unsigned int remaining,
-			       struct mptcp_out_options *opts)
+static bool mptcp_established_options_mp(struct sock *sk, unsigned int *size,
+					 unsigned int remaining,
+					 struct mptcp_out_options *opts)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 
-	if (subflow->mp_capable && !subflow->fourth_ack) {
+	if (!subflow->fourth_ack) {
 		opts->suboptions = OPTION_MPTCP_MPC_ACK;
 		opts->sndr_key = subflow->local_key;
 		opts->rcvr_key = subflow->remote_key;
@@ -215,6 +215,115 @@ bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
 	return false;
 }
 
+static void mptcp_write_data_fin(struct mptcp_subflow_context *subflow,
+				 struct mptcp_ext *ext)
+{
+	ext->data_fin = 1;
+
+	if (!ext->use_map) {
+		/* RFC6824 requires a DSS mapping with specific values
+		 * if DATA_FIN is set but no data payload is mapped
+		 */
+		ext->use_map = 1;
+		ext->dsn64 = 1;
+		ext->data_seq = mptcp_sk(subflow->conn)->write_seq;
+		ext->subflow_seq = 0;
+		ext->data_len = 1;
+	} else {
+		/* If there's an existing DSS mapping, DATA_FIN consumes
+		 * 1 additional byte of mapping space.
+		 */
+		ext->data_len++;
+	}
+}
+
+static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
+					  unsigned int *size,
+					  unsigned int remaining,
+					  struct mptcp_out_options *opts)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+	unsigned int dss_size = 0;
+	struct mptcp_ext *mpext;
+	struct mptcp_sock *msk;
+	unsigned int ack_size;
+	u8 tcp_fin;
+
+	if (skb) {
+		mpext = mptcp_get_ext(skb);
+		tcp_fin = TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN;
+	} else {
+		mpext = NULL;
+		tcp_fin = 0;
+	}
+
+	if (!skb || (mpext && mpext->use_map) || tcp_fin) {
+		unsigned int map_size;
+
+		map_size = TCPOLEN_MPTCP_DSS_BASE + TCPOLEN_MPTCP_DSS_MAP64;
+
+		remaining -= map_size;
+		dss_size = map_size;
+		if (mpext)
+			opts->ext_copy = *mpext;
+
+		if (skb && tcp_fin &&
+		    subflow->conn->sk_state != TCP_ESTABLISHED)
+			mptcp_write_data_fin(subflow, &opts->ext_copy);
+	}
+
+	ack_size = TCPOLEN_MPTCP_DSS_ACK64;
+
+	/* Add kind/length/subtype/flag overhead if mapping is not populated */
+	if (dss_size == 0)
+		ack_size += TCPOLEN_MPTCP_DSS_BASE;
+
+	dss_size += ack_size;
+
+	msk = mptcp_sk(mptcp_subflow_ctx(sk)->conn);
+	if (msk) {
+		opts->ext_copy.data_ack = msk->ack_seq;
+	} else {
+		mptcp_crypto_key_sha(mptcp_subflow_ctx(sk)->remote_key,
+				     NULL, &opts->ext_copy.data_ack);
+		opts->ext_copy.data_ack++;
+	}
+
+	opts->ext_copy.ack64 = 1;
+	opts->ext_copy.use_ack = 1;
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
+	bool ret = false;
+
+	if (!mptcp_subflow_ctx(sk)->mp_capable)
+		return false;
+
+	if (mptcp_established_options_mp(sk, &opt_size, remaining, opts))
+		ret = true;
+	else if (mptcp_established_options_dss(sk, skb, &opt_size, remaining,
+					       opts))
+		ret = true;
+
+	/* we reserved enough space for the above options, and exceeding the
+	 * TCP option space would be fatal
+	 */
+	if (WARN_ON_ONCE(opt_size > remaining))
+		return false;
+
+	*size += opt_size;
+	remaining -= opt_size;
+
+	return ret;
+}
+
 bool mptcp_synack_options(const struct request_sock *req, unsigned int *size,
 			  struct mptcp_out_options *opts)
 {
@@ -256,4 +365,45 @@ void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
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
+			put_unaligned_be64(mpext->data_seq, ptr);
+			ptr += 2;
+			put_unaligned_be32(mpext->subflow_seq, ptr);
+			ptr += 1;
+			put_unaligned_be32(mpext->data_len << 16 |
+					   TCPOPT_NOP << 8 | TCPOPT_NOP, ptr);
+		}
+	}
 }
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 30f4d4f96f15..0d82e551f3de 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -98,12 +98,93 @@ static struct sock *mptcp_subflow_get(const struct mptcp_sock *msk)
 	return NULL;
 }
 
+static bool mptcp_ext_cache_refill(struct mptcp_sock *msk)
+{
+	if (!msk->cached_ext)
+		msk->cached_ext = __skb_ext_alloc();
+
+	return !!msk->cached_ext;
+}
+
+static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
+			      struct msghdr *msg, long *timeo)
+{
+	int mss_now = 0, size_goal = 0, ret = 0;
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct mptcp_ext *mpext = NULL;
+	struct page_frag *pfrag;
+	struct sk_buff *skb;
+	size_t psize;
+
+	/* use the mptcp page cache so that we can easily move the data
+	 * from one substream to another, but do per subflow memory accounting
+	 */
+	pfrag = sk_page_frag(sk);
+	while (!sk_page_frag_refill(ssk, pfrag) ||
+	       !mptcp_ext_cache_refill(msk)) {
+		ret = sk_stream_wait_memory(ssk, timeo);
+		if (ret)
+			return ret;
+	}
+
+	/* compute copy limit */
+	mss_now = tcp_send_mss(ssk, &size_goal, msg->msg_flags);
+	psize = min_t(int, pfrag->size - pfrag->offset, size_goal);
+
+	pr_debug("left=%zu", msg_data_left(msg));
+	psize = copy_page_from_iter(pfrag->page, pfrag->offset,
+				    min_t(size_t, msg_data_left(msg), psize),
+				    &msg->msg_iter);
+	pr_debug("left=%zu", msg_data_left(msg));
+	if (!psize)
+		return -EINVAL;
+
+	/* Mark the end of the previous write so the beginning of the
+	 * next write (with its own mptcp skb extension data) is not
+	 * collapsed.
+	 */
+	skb = tcp_write_queue_tail(ssk);
+	if (skb)
+		TCP_SKB_CB(skb)->eor = 1;
+
+	ret = do_tcp_sendpages(ssk, pfrag->page, pfrag->offset, psize,
+			       msg->msg_flags | MSG_SENDPAGE_NOTLAST);
+	if (ret <= 0)
+		return ret;
+	if (unlikely(ret < psize))
+		iov_iter_revert(&msg->msg_iter, psize - ret);
+
+	skb = tcp_write_queue_tail(ssk);
+	mpext = __skb_ext_set(skb, SKB_EXT_MPTCP, msk->cached_ext);
+	msk->cached_ext = NULL;
+
+	memset(mpext, 0, sizeof(*mpext));
+	mpext->data_seq = msk->write_seq;
+	mpext->subflow_seq = mptcp_subflow_ctx(ssk)->rel_write_seq;
+	mpext->data_len = ret;
+	mpext->use_map = 1;
+	mpext->dsn64 = 1;
+
+	pr_debug("data_seq=%llu subflow_seq=%u data_len=%u dsn64=%d",
+		 mpext->data_seq, mpext->subflow_seq, mpext->data_len,
+		 mpext->dsn64);
+
+	pfrag->offset += ret;
+	msk->write_seq += ret;
+	mptcp_subflow_ctx(ssk)->rel_write_seq += ret;
+
+	tcp_push(ssk, msg->msg_flags, mss_now, tcp_sk(ssk)->nonagle, size_goal);
+	return ret;
+}
+
 static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct socket *ssock;
+	size_t copied = 0;
 	struct sock *ssk;
-	int ret;
+	int ret = 0;
+	long timeo;
 
 	if (msg->msg_flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL))
 		return -EOPNOTSUPP;
@@ -117,14 +198,29 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		return ret;
 	}
 
+	timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
+
 	ssk = mptcp_subflow_get(msk);
 	if (!ssk) {
 		release_sock(sk);
 		return -ENOTCONN;
 	}
 
-	ret = sock_sendmsg(ssk->sk_socket, msg);
+	pr_debug("conn_list->subflow=%p", ssk);
 
+	lock_sock(ssk);
+	while (msg_data_left(msg)) {
+		ret = mptcp_sendmsg_frag(sk, ssk, msg, &timeo);
+		if (ret < 0)
+			break;
+
+		copied += ret;
+	}
+
+	if (copied > 0)
+		ret = copied;
+
+	release_sock(ssk);
 	release_sock(sk);
 	return ret;
 }
@@ -236,6 +332,8 @@ static void mptcp_close(struct sock *sk, long timeout)
 		__mptcp_close_ssk(sk, ssk, subflow, timeout);
 	}
 
+	if (msk->cached_ext)
+		__skb_ext_put(msk->cached_ext);
 	release_sock(sk);
 	sk_common_release(sk);
 }
@@ -288,6 +386,7 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 	if (subflow->mp_capable) {
 		struct sock *new_mptcp_sock;
 		struct sock *ssk = newsk;
+		u64 ack_seq;
 
 		lock_sock(sk);
 
@@ -311,6 +410,12 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 		msk->subflow = NULL;
 
 		mptcp_token_update_accept(newsk, new_mptcp_sock);
+
+		mptcp_crypto_key_sha(msk->remote_key, NULL, &ack_seq);
+		msk->write_seq = subflow->idsn + 1;
+		ack_seq++;
+		msk->ack_seq = ack_seq;
+		subflow->rel_write_seq = 1;
 		newsk = new_mptcp_sock;
 		mptcp_copy_inaddrs(newsk, ssk);
 		list_add(&subflow->node, &msk->conn_list);
@@ -407,6 +512,7 @@ void mptcp_finish_connect(struct sock *ssk)
 	struct mptcp_subflow_context *subflow;
 	struct mptcp_sock *msk;
 	struct sock *sk;
+	u64 ack_seq;
 
 	subflow = mptcp_subflow_ctx(ssk);
 
@@ -416,12 +522,18 @@ void mptcp_finish_connect(struct sock *ssk)
 	sk = subflow->conn;
 	msk = mptcp_sk(sk);
 
+	mptcp_crypto_key_sha(subflow->remote_key, NULL, &ack_seq);
+	ack_seq++;
+	subflow->rel_write_seq = 1;
+
 	/* the socket is not connected yet, no msk/subflow ops can access/race
 	 * accessing the field below
 	 */
 	WRITE_ONCE(msk->remote_key, subflow->remote_key);
 	WRITE_ONCE(msk->local_key, subflow->local_key);
 	WRITE_ONCE(msk->token, subflow->token);
+	WRITE_ONCE(msk->write_seq, subflow->idsn + 1);
+	WRITE_ONCE(msk->ack_seq, ack_seq);
 }
 
 static void mptcp_sock_graft(struct sock *sk, struct socket *parent)
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 5f43fa0275c0..384ec4804198 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -32,6 +32,10 @@
 #define TCPOLEN_MPTCP_MPC_SYN		12
 #define TCPOLEN_MPTCP_MPC_SYNACK	12
 #define TCPOLEN_MPTCP_MPC_ACK		20
+#define TCPOLEN_MPTCP_DSS_BASE		4
+#define TCPOLEN_MPTCP_DSS_ACK64		8
+#define TCPOLEN_MPTCP_DSS_MAP64		14
+#define TCPOLEN_MPTCP_DSS_CHECKSUM	2
 
 /* MPTCP MP_CAPABLE flags */
 #define MPTCP_VERSION_MASK	(0x0F)
@@ -40,14 +44,24 @@
 #define MPTCP_CAP_HMAC_SHA1	BIT(0)
 #define MPTCP_CAP_FLAG_MASK	(0x3F)
 
+/* MPTCP DSS flags */
+#define MPTCP_DSS_DATA_FIN	BIT(4)
+#define MPTCP_DSS_DSN64		BIT(3)
+#define MPTCP_DSS_HAS_MAP	BIT(2)
+#define MPTCP_DSS_ACK64		BIT(1)
+#define MPTCP_DSS_HAS_ACK	BIT(0)
+
 /* MPTCP connection sock */
 struct mptcp_sock {
 	/* inet_connection_sock must be the first member */
 	struct inet_connection_sock sk;
 	u64		local_key;
 	u64		remote_key;
+	u64		write_seq;
+	u64		ack_seq;
 	u32		token;
 	struct list_head conn_list;
+	struct skb_ext	*cached_ext;	/* for the next sendmsg */
 	struct socket	*subflow; /* outgoing connect/listener/!mp_capable */
 };
 
@@ -83,6 +97,7 @@ struct mptcp_subflow_context {
 	u64	remote_key;
 	u64	idsn;
 	u32	token;
+	u32	rel_write_seq;
 	u32	request_mptcp : 1,  /* send MP_CAPABLE */
 		mp_capable : 1,	    /* remote is MPTCP capable */
 		fourth_ack : 1,	    /* send initial DSS */
@@ -144,4 +159,9 @@ static inline void mptcp_crypto_key_gen_sha(u64 *key, u32 *token, u64 *idsn)
 void mptcp_crypto_hmac_sha(u64 key1, u64 key2, u32 nonce1, u32 nonce2,
 			   u32 *hash_out);
 
+static inline struct mptcp_ext *mptcp_get_ext(struct sk_buff *skb)
+{
+	return (struct mptcp_ext *)skb_ext_find(skb, SKB_EXT_MPTCP);
+}
+
 #endif /* __MPTCP_PROTOCOL_H */
-- 
2.24.1

