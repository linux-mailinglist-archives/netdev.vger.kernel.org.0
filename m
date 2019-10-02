Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 620C1C950C
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbfJBXid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:38:33 -0400
Received: from mga04.intel.com ([192.55.52.120]:16463 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729109AbfJBXhi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:37:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:37:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366862610"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.30.230])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 16:37:22 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        cpaasch@apple.com, fw@strlen.de, pabeni@redhat.com,
        peter.krystad@linux.intel.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH v2 21/45] mptcp: Implement MPTCP receive path
Date:   Wed,  2 Oct 2019 16:36:31 -0700
Message-Id: <20191002233655.24323-22-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
References: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Parses incoming DSS options and populates outgoing MPTCP ACK
fields. MPTCP fields are parsed from the TCP option header and placed in
an skb extension, allowing the upper MPTCP layer to access MPTCP
options after the skb has gone through the TCP stack.

Outgoing MPTCP ACK values are now populated from an atomic value stored
in the connection socket rather than carried in an skb extension. This
allows sent packet headers to make use of the most up-to-date sequence
number and allows the MPTCP ACK to be populated in TCP ACK packets that
have no payload.

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 include/linux/tcp.h  |  17 ++-
 include/net/mptcp.h  |  16 +--
 net/ipv4/tcp_input.c |   8 +-
 net/mptcp/options.c  | 138 +++++++++++++++++--
 net/mptcp/protocol.c | 318 +++++++++++++++++++++++++++++++++++++++++--
 net/mptcp/protocol.h |  32 ++++-
 net/mptcp/subflow.c  |  36 ++++-
 7 files changed, 523 insertions(+), 42 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 220883a7a4db..0f0d6c188f52 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -97,13 +97,26 @@ struct tcp_options_received {
 	u16	mss_clamp;	/* Maximal mss, negotiated at connection setup */
 #if IS_ENABLED(CONFIG_MPTCP)
 	struct mptcp_options_received {
+		u64     sndr_key;
+		u64     rcvr_key;
+		u64	data_ack;
+		u64	data_seq;
+		u32	subflow_seq;
+		u16	data_len;
+		__sum16	checksum;
 		u8      mp_capable : 1,
 			mp_join : 1,
 			dss : 1,
 			version : 4;
 		u8      flags;
-		u64     sndr_key;
-		u64     rcvr_key;
+		u8	dss_flags;
+		u8	use_map:1,
+			dsn64:1,
+			use_checksum:1,
+			data_fin:1,
+			use_ack:1,
+			ack64:1,
+			__unused:2;
 	} mptcp;
 #endif
 };
diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 43fcd4989f37..21438bcacb14 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -8,14 +8,6 @@
 #ifndef __NET_MPTCP_H
 #define __NET_MPTCP_H
 
-/* MPTCP DSS flags */
-
-#define MPTCP_DSS_DATA_FIN	BIT(4)
-#define MPTCP_DSS_DSN64		BIT(3)
-#define MPTCP_DSS_HAS_MAP	BIT(2)
-#define MPTCP_DSS_ACK64		BIT(1)
-#define MPTCP_DSS_HAS_ACK	BIT(0)
-
 /* MPTCP sk_buff extension data */
 struct mptcp_ext {
 	u64		data_ack;
@@ -65,6 +57,8 @@ bool mptcp_synack_options(const struct request_sock *req, unsigned int *size,
 bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
 			       unsigned int *size, unsigned int remaining,
 			       struct mptcp_out_options *opts);
+void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb,
+			    struct tcp_options_received *opt_rx);
 
 static inline bool mptcp_skb_ext_exist(const struct sk_buff *skb)
 {
@@ -120,6 +114,12 @@ static inline bool mptcp_established_options(struct sock *sk,
 	return false;
 }
 
+static inline void mptcp_incoming_options(struct sock *sk,
+					  struct sk_buff *skb,
+					  struct tcp_options_received *opt_rx)
+{
+}
+
 static inline bool mptcp_skb_ext_exist(const struct sk_buff *skb)
 {
 	return false;
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 04267684babf..dac6027a6c2e 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4764,6 +4764,9 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 	bool fragstolen;
 	int eaten;
 
+	if (sk_is_mptcp(sk))
+		mptcp_incoming_options(sk, skb, &tp->rx_opt);
+
 	if (TCP_SKB_CB(skb)->seq == TCP_SKB_CB(skb)->end_seq) {
 		__kfree_skb(skb);
 		return;
@@ -6332,8 +6335,11 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 	case TCP_CLOSE_WAIT:
 	case TCP_CLOSING:
 	case TCP_LAST_ACK:
-		if (!before(TCP_SKB_CB(skb)->seq, tp->rcv_nxt))
+		if (!before(TCP_SKB_CB(skb)->seq, tp->rcv_nxt)) {
+			if (sk_is_mptcp(sk))
+				mptcp_incoming_options(sk, skb, &tp->rx_opt);
 			break;
+		}
 		/* fall through */
 	case TCP_FIN_WAIT1:
 	case TCP_FIN_WAIT2:
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 36691e439796..caea320cd2a6 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -14,6 +14,7 @@ void mptcp_parse_option(const unsigned char *ptr, int opsize,
 {
 	struct mptcp_options_received *mp_opt = &opt_rx->mptcp;
 	u8 subtype = *ptr >> 4;
+	int expected_opsize;
 
 	switch (subtype) {
 	/* MPTCPOPT_MP_CAPABLE
@@ -98,6 +99,72 @@ void mptcp_parse_option(const unsigned char *ptr, int opsize,
 	case MPTCPOPT_DSS:
 		pr_debug("DSS");
 		mp_opt->dss = 1;
+		ptr++;
+
+		mp_opt->dss_flags = (*ptr++) & MPTCP_DSS_FLAG_MASK;
+		mp_opt->data_fin = (mp_opt->dss_flags & MPTCP_DSS_DATA_FIN) != 0;
+		mp_opt->dsn64 = (mp_opt->dss_flags & MPTCP_DSS_DSN64) != 0;
+		mp_opt->use_map = (mp_opt->dss_flags & MPTCP_DSS_HAS_MAP) != 0;
+		mp_opt->ack64 = (mp_opt->dss_flags & MPTCP_DSS_ACK64) != 0;
+		mp_opt->use_ack = (mp_opt->dss_flags & MPTCP_DSS_HAS_ACK);
+
+		pr_debug("data_fin=%d dsn64=%d use_map=%d ack64=%d use_ack=%d",
+			 mp_opt->data_fin, mp_opt->dsn64,
+			 mp_opt->use_map, mp_opt->ack64,
+			 mp_opt->use_ack);
+
+		expected_opsize = TCPOLEN_MPTCP_DSS_BASE;
+
+		if (mp_opt->use_ack) {
+			if (mp_opt->ack64)
+				expected_opsize += TCPOLEN_MPTCP_DSS_ACK64;
+			else
+				expected_opsize += TCPOLEN_MPTCP_DSS_ACK32;
+
+			if (opsize < expected_opsize)
+				break;
+
+			if (mp_opt->ack64) {
+				mp_opt->data_ack = get_unaligned_be64(ptr);
+				ptr += 8;
+			} else {
+				mp_opt->data_ack = get_unaligned_be32(ptr);
+				ptr += 4;
+			}
+
+			pr_debug("data_ack=%llu", mp_opt->data_ack);
+		}
+
+		if (mp_opt->use_map) {
+			if (mp_opt->dsn64)
+				expected_opsize += TCPOLEN_MPTCP_DSS_MAP64;
+			else
+				expected_opsize += TCPOLEN_MPTCP_DSS_MAP32;
+
+			if (opsize < expected_opsize)
+				break;
+
+			if (mp_opt->dsn64) {
+				mp_opt->data_seq = get_unaligned_be64(ptr);
+				ptr += 8;
+			} else {
+				mp_opt->data_seq = get_unaligned_be32(ptr);
+				ptr += 4;
+			}
+
+			mp_opt->subflow_seq = get_unaligned_be32(ptr);
+			ptr += 4;
+
+			mp_opt->data_len = get_unaligned_be16(ptr);
+			ptr += 2;
+
+			/* Checksum not currently supported */
+			mp_opt->checksum = 0;
+
+			pr_debug("data_seq=%llu subflow_seq=%u data_len=%u ck=%u",
+				 mp_opt->data_seq, mp_opt->subflow_seq,
+				 mp_opt->data_len, mp_opt->checksum);
+		}
 		break;
 
 	/* MPTCPOPT_ADD_ADDR
@@ -251,25 +318,31 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
 		}
 	}
 
-	if (mpext && mpext->use_ack) {
-		ack_size = TCPOLEN_MPTCP_DSS_ACK64;
+	ack_size = TCPOLEN_MPTCP_DSS_ACK64;
 
-		/* Add kind/length/subtype/flag overhead if mapping is not
-		 * populated
-		 */
-		if (dss_size == 0)
-			ack_size += TCPOLEN_MPTCP_DSS_BASE;
+	/* Add kind/length/subtype/flag overhead if mapping is not populated */
+	if (dss_size == 0)
+		ack_size += TCPOLEN_MPTCP_DSS_BASE;
 
-		if (ack_size <= remaining) {
-			dss_size += ack_size;
+	if (ack_size <= remaining) {
+		struct mptcp_sock *msk;
 
-			opts->ext_copy.data_ack = mpext->data_ack;
-			opts->ext_copy.ack64 = 1;
-			opts->ext_copy.use_ack = 1;
+		dss_size += ack_size;
+
+		msk = mptcp_sk(mptcp_subflow_ctx(sk)->conn);
+		if (msk) {
+			opts->ext_copy.data_ack = msk->ack_seq;
 		} else {
-			opts->ext_copy.use_ack = 0;
-			WARN(1, "MPTCP: Ack dropped");
+			mptcp_crypto_key_sha1(mptcp_subflow_ctx(sk)->remote_key,
+					      NULL, &opts->ext_copy.data_ack);
+			opts->ext_copy.data_ack++;
 		}
+
+		opts->ext_copy.ack64 = 1;
+		opts->ext_copy.use_ack = 1;
+	} else {
+		opts->ext_copy.use_ack = 0;
+		WARN(1, "MPTCP: Ack dropped");
 	}
 
 	if (!dss_size)
@@ -320,6 +393,42 @@ bool mptcp_synack_options(const struct request_sock *req, unsigned int *size,
 	return false;
 }
 
+void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb,
+			    struct tcp_options_received *opt_rx)
+{
+	struct mptcp_options_received *mp_opt;
+	struct mptcp_ext *mpext;
+
+	mp_opt = &opt_rx->mptcp;
+
+	if (!mp_opt->dss)
+		return;
+
+	mpext = skb_ext_add(skb, SKB_EXT_MPTCP);
+	if (!mpext)
+		return;
+
+	memset(mpext, 0, sizeof(*mpext));
+
+	if (mp_opt->use_map) {
+		mpext->data_seq = mp_opt->data_seq;
+		mpext->subflow_seq = mp_opt->subflow_seq;
+		mpext->data_len = mp_opt->data_len;
+		mpext->checksum = mp_opt->checksum;
+		mpext->use_map = 1;
+		mpext->dsn64 = mp_opt->dsn64;
+		mpext->use_checksum = mp_opt->use_checksum;
+	}
+
+	if (mp_opt->use_ack) {
+		mpext->data_ack = mp_opt->data_ack;
+		mpext->use_ack = 1;
+		mpext->ack64 = mp_opt->ack64;
+	}
+
+	mpext->data_fin = mp_opt->data_fin;
+}
+
 void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
 {
 	if ((OPTION_MPTCP_MPC_SYN |
@@ -358,6 +467,7 @@ void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
 		}
 
 		if (mpext->use_map) {
+			pr_debug("Updating DSS length and flags for map");
 			len += TCPOLEN_MPTCP_DSS_MAP64;
 
 			if (mpext->use_checksum)
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index feabf3dfc988..fdcfffce0ec9 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -9,6 +9,8 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/sched/signal.h>
+#include <linux/atomic.h>
 #include <net/sock.h>
 #include <net/inet_common.h>
 #include <net/inet_hashtables.h>
@@ -145,15 +147,12 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	if (mpext) {
 		memset(mpext, 0, sizeof(*mpext));
-		mpext->data_ack = msk->ack_seq;
 		mpext->data_seq = msk->write_seq;
 		mpext->subflow_seq = mptcp_subflow_ctx(ssk)->rel_write_seq;
 		mpext->data_len = ret;
 		mpext->checksum = 0xbeef;
 		mpext->use_map = 1;
 		mpext->dsn64 = 1;
-		mpext->use_ack = 1;
-		mpext->ack64 = 1;
 
 		pr_debug("data_seq=%llu subflow_seq=%u data_len=%u checksum=%u, dsn64=%d",
 			 mpext->data_seq, mpext->subflow_seq, mpext->data_len,
@@ -173,13 +172,158 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	return ret;
 }
 
+struct mptcp_read_arg {
+	struct msghdr *msg;
+};
+
+static u64 expand_seq(u64 old_seq, u16 old_data_len, u64 seq)
+{
+	if ((u32)seq == (u32)old_seq)
+		return old_seq;
+
+	/* Assume map covers data not mapped yet. */
+	return seq | ((old_seq + old_data_len + 1) & GENMASK_ULL(63, 32));
+}
+
+static u64 get_map_offset(struct mptcp_subflow_context *subflow)
+{
+	return tcp_sk(mptcp_subflow_tcp_socket(subflow)->sk)->copied_seq -
+		      subflow->ssn_offset -
+		      subflow->map_subflow_seq;
+}
+
+static u64 get_mapped_dsn(struct mptcp_subflow_context *subflow)
+{
+	return subflow->map_seq + get_map_offset(subflow);
+}
+
+static int mptcp_read_actor(read_descriptor_t *desc, struct sk_buff *skb,
+			    unsigned int offset, size_t len)
+{
+	struct mptcp_read_arg *arg = desc->arg.data;
+	size_t copy_len;
+
+	copy_len = min(desc->count, len);
+
+	if (likely(arg->msg)) {
+		int err;
+
+		err = skb_copy_datagram_msg(skb, offset, arg->msg, copy_len);
+		if (err) {
+			pr_debug("error path");
+			desc->error = err;
+			return err;
+		}
+	} else {
+		pr_debug("Flushing skb payload");
+	}
+
+	// MSG_PEEK support? Other flags? MSG_TRUNC?
+
+	desc->count -= copy_len;
+
+	pr_debug("consumed %zu bytes, %zu left", copy_len, desc->count);
+	return copy_len;
+}
+
+enum mapping_status {
+	MAPPING_ADDED,
+	MAPPING_MISSING,
+	MAPPING_EMPTY,
+	MAPPING_DATA_FIN
+};
+
+static enum mapping_status mptcp_get_mapping(struct sock *ssk)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
+	struct mptcp_ext *mpext;
+	enum mapping_status ret;
+	struct sk_buff *skb;
+	u64 map_seq;
+
+	skb = skb_peek(&ssk->sk_receive_queue);
+	if (!skb) {
+		pr_debug("Empty queue");
+		return MAPPING_EMPTY;
+	}
+
+	mpext = mptcp_get_ext(skb);
+
+	if (!mpext) {
+		/* This is expected for non-DSS data packets */
+		return MAPPING_MISSING;
+	}
+
+	if (!mpext->use_map) {
+		ret = MAPPING_MISSING;
+		goto del_out;
+	}
+
+	pr_debug("seq=%llu is64=%d ssn=%u data_len=%u ck=%u",
+		 mpext->data_seq, mpext->dsn64, mpext->subflow_seq,
+		 mpext->data_len, mpext->checksum);
+
+	if (mpext->data_len == 0) {
+		pr_err("Infinite mapping not handled");
+		ret = MAPPING_MISSING;
+		goto del_out;
+	} else if (mpext->subflow_seq == 0 &&
+		   mpext->data_fin == 1) {
+		pr_debug("DATA_FIN with no payload");
+		ret = MAPPING_DATA_FIN;
+		goto del_out;
+	}
+
+	if (!mpext->dsn64) {
+		map_seq = expand_seq(subflow->map_seq, subflow->map_data_len,
+				     mpext->data_seq);
+		pr_debug("expanded seq=%llu", subflow->map_seq);
+	} else {
+		map_seq = mpext->data_seq;
+	}
+
+	if (subflow->map_valid) {
+		/* due to GSO/TSO we can receive the same mapping multiple
+		 * times, before it's expiration.
+		 */
+		if (subflow->map_seq != map_seq ||
+		    subflow->map_subflow_seq != mpext->subflow_seq ||
+		    subflow->map_data_len != mpext->data_len)
+			pr_warn("Replaced mapping before it was done");
+	}
+
+	subflow->map_seq = map_seq;
+	subflow->map_subflow_seq = mpext->subflow_seq;
+	subflow->map_data_len = mpext->data_len;
+	subflow->map_valid = 1;
+	ret = MAPPING_ADDED;
+	pr_debug("new map seq=%llu subflow_seq=%u data_len=%u",
+		 subflow->map_seq, subflow->map_subflow_seq,
+		 subflow->map_data_len);
+
+del_out:
+	__skb_ext_del(skb, SKB_EXT_MPTCP);
+	return ret;
+}
+
+static void warn_bad_map(struct mptcp_subflow_context *subflow, u32 ssn)
+{
+	WARN_ONCE(1, "Bad mapping: ssn=%d map_seq=%d map_data_len=%d",
+		  ssn, subflow->map_subflow_seq, subflow->map_data_len);
+}
+
 static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 			 int nonblock, int flags, int *addr_len)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct mptcp_subflow_context *subflow;
+	struct mptcp_read_arg arg;
+	read_descriptor_t desc;
 	struct socket *ssock;
+	struct tcp_sock *tp;
 	struct sock *ssk;
 	int copied = 0;
+	long timeo;
 
 	lock_sock(sk);
 	ssock = __mptcp_fallback_get_ref(msk);
@@ -198,8 +342,158 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		return -ENOTCONN;
 	}
 
-	copied = sock_recvmsg(ssk->sk_socket, msg, flags);
+	subflow = mptcp_subflow_ctx(ssk);
+	tp = tcp_sk(ssk);
+
+	lock_sock(ssk);
+
+	desc.arg.data = &arg;
+	desc.error = 0;
+
+	timeo = sock_rcvtimeo(sk, nonblock);
+
+	len = min_t(size_t, len, INT_MAX);
+
+	while (copied < len) {
+		enum mapping_status status;
+		u32 map_remaining;
+		int bytes_read;
+		u64 ack_seq;
+		u64 old_ack;
+		u32 ssn;
+
+		status = mptcp_get_mapping(ssk);
+
+		if (status == MAPPING_ADDED) {
+			/* Common case, but nothing to do here */
+		} else if (status == MAPPING_MISSING) {
+			struct sk_buff *skb = skb_peek(&ssk->sk_receive_queue);
+
+			if (!skb->len) {
+				/* the TCP stack deliver 0 len FIN pkt
+				 * to the receive queue, that is the only
+				 * 0len pkts ever expected here, and we can
+				 * admit no mapping only for 0 len pkts
+				 */
+				if (!(TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN))
+					WARN_ONCE(1, "0len seq %d:%d flags %x",
+						  TCP_SKB_CB(skb)->seq,
+						  TCP_SKB_CB(skb)->end_seq,
+						  TCP_SKB_CB(skb)->tcp_flags);
+				sk_eat_skb(sk, skb);
+				continue;
+			}
+			if (!subflow->map_valid) {
+				WARN_ONCE(1, "corrupted stream: missing mapping");
+				copied = -EBADFD;
+				break;
+			}
+		} else if (status == MAPPING_EMPTY) {
+			goto wait_for_data;
+		} else if (status == MAPPING_DATA_FIN) {
+			/* TODO: Handle according to RFC 6824 */
+			if (!copied) {
+				pr_err("Can't read after DATA_FIN");
+				copied = -ENOTCONN;
+			}
+
+			break;
+		}
+
+		ssn = tcp_sk(ssk)->copied_seq - subflow->ssn_offset;
+		old_ack = msk->ack_seq;
+
+		if (unlikely(before(ssn, subflow->map_subflow_seq))) {
+			/* Mapping covers data later in the subflow stream,
+			 * currently unsupported.
+			 */
+			warn_bad_map(subflow, ssn);
+			copied = -EBADFD;
+			break;
+		} else if (unlikely(!before(ssn, (subflow->map_subflow_seq +
+						  subflow->map_data_len)))) {
+			/* Mapping ends earlier in the subflow stream.
+			 * Invalid
+			 */
+			warn_bad_map(subflow, ssn);
+			copied = -EBADFD;
+			break;
+		}
+
+		ack_seq = get_mapped_dsn(subflow);
+		map_remaining = subflow->map_data_len - get_map_offset(subflow);
+
+		if (before64(ack_seq, old_ack)) {
+			/* Mapping covers data already received, discard data
+			 * in the current mapping
+			 */
+			arg.msg = NULL;
+			desc.count = min_t(size_t, old_ack - ack_seq,
+					   map_remaining);
+			pr_debug("Dup data, map len=%d acked=%lld dropped=%ld",
+				 map_remaining, old_ack - ack_seq, desc.count);
+		} else {
+			arg.msg = msg;
+			desc.count = min_t(size_t, len - copied, map_remaining);
+		}
+
+		/* Read mapped data */
+		bytes_read = tcp_read_sock(ssk, &desc, mptcp_read_actor);
+		if (bytes_read < 0)
+			break;
+
+		/* Refresh current MPTCP sequence number based on subflow seq */
+		ack_seq = get_mapped_dsn(subflow);
+
+		if (before64(old_ack, ack_seq))
+			msk->ack_seq = ack_seq;
+
+		if (!before(tcp_sk(ssk)->copied_seq - subflow->ssn_offset,
+			    subflow->map_subflow_seq + subflow->map_data_len)) {
+			subflow->map_valid = 0;
+			pr_debug("Done with mapping: seq=%u data_len=%u",
+				 subflow->map_subflow_seq,
+				 subflow->map_data_len);
+		}
 
+		if (arg.msg)
+			copied += bytes_read;
+
+		/* The 'wait_for_data' code path can terminate the receive loop
+		 * in a number of scenarios: check if more data is pending
+		 * before giving up.
+		 */
+		if (!skb_queue_empty(&ssk->sk_receive_queue))
+			continue;
+
+wait_for_data:
+		if (copied)
+			break;
+
+		if (tp->urg_data && tp->urg_seq == tp->copied_seq) {
+			pr_err("Urgent data present, cannot proceed");
+			break;
+		}
+
+		if (ssk->sk_err || ssk->sk_state == TCP_CLOSE ||
+		    (ssk->sk_shutdown & RCV_SHUTDOWN) || !timeo ||
+		    signal_pending(current)) {
+			pr_debug("nonblock or error");
+			break;
+		}
+
+		/* Handle blocking and retry read if needed.
+		 *
+		 * Wait on MPTCP sock, the subflow will notify via data ready.
+		 */
+
+		pr_debug("block");
+		release_sock(ssk);
+		sk_wait_data(sk, &timeo, NULL);
+		lock_sock(ssk);
+	}
+
+	release_sock(ssk);
 	release_sock(sk);
 
 	sock_put(ssk);
@@ -296,8 +590,6 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 		msk = mptcp_sk(new_mptcp_sock);
 		msk->remote_key = subflow->remote_key;
 		msk->local_key = subflow->local_key;
-		msk->subflow = NULL;
-
 		msk->token = subflow->token;
 
 		mptcp_token_update_accept(new_sock->sk, new_mptcp_sock);
@@ -307,9 +599,10 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 		msk->write_seq = subflow->idsn + 1;
 		ack_seq++;
 		msk->ack_seq = ack_seq;
-		msk->remote_key = subflow->remote_key;
-		msk->ack_seq++;
+		subflow->map_seq = ack_seq;
+		subflow->map_subflow_seq = 1;
 		subflow->rel_write_seq = 1;
+		subflow->tcp_sock = new_sock;
 		newsk = new_mptcp_sock;
 		subflow->conn = new_mptcp_sock;
 		list_add(&subflow->node, &msk->conn_list);
@@ -431,11 +724,16 @@ void mptcp_finish_connect(struct sock *sk, int mp_capable)
 		msk->remote_key = subflow->remote_key;
 		msk->local_key = subflow->local_key;
 		msk->token = subflow->token;
-		msk->write_seq = subflow->idsn + 1;
-		subflow->rel_write_seq = 1;
+
+		pr_debug("msk=%p, token=%u", msk, msk->token);
+
 		mptcp_crypto_key_sha1(msk->remote_key, NULL, &ack_seq);
+		msk->write_seq = subflow->idsn + 1;
 		ack_seq++;
 		msk->ack_seq = ack_seq;
+		subflow->map_seq = ack_seq;
+		subflow->map_subflow_seq = 1;
+		subflow->rel_write_seq = 1;
 		list_add(&subflow->node, &msk->conn_list);
 		msk->subflow = NULL;
 		bh_unlock_sock(sk);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 2b0347612550..7dae12cfcf14 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -31,7 +31,9 @@
 #define TCPOLEN_MPTCP_MPC_SYNACK	20
 #define TCPOLEN_MPTCP_MPC_ACK		20
 #define TCPOLEN_MPTCP_DSS_BASE		4
+#define TCPOLEN_MPTCP_DSS_ACK32		4
 #define TCPOLEN_MPTCP_DSS_ACK64		8
+#define TCPOLEN_MPTCP_DSS_MAP32		10
 #define TCPOLEN_MPTCP_DSS_MAP64		14
 #define TCPOLEN_MPTCP_DSS_CHECKSUM	2
 
@@ -42,6 +44,14 @@
 #define MPTCP_CAP_HMAC_SHA1	BIT(0)
 #define MPTCP_CAP_FLAG_MASK	(0x3F)
 
+/* MPTCP DSS flags */
+#define MPTCP_DSS_DATA_FIN	BIT(4)
+#define MPTCP_DSS_DSN64		BIT(3)
+#define MPTCP_DSS_HAS_MAP	BIT(2)
+#define MPTCP_DSS_ACK64		BIT(1)
+#define MPTCP_DSS_HAS_ACK	BIT(0)
+#define MPTCP_DSS_FLAG_MASK	(0x1F)
+
 /* MPTCP connection sock */
 struct mptcp_sock {
 	/* inet_connection_sock must be the first member */
@@ -74,6 +84,7 @@ struct mptcp_subflow_request_sock {
 	u64	remote_key;
 	u64	idsn;
 	u32	token;
+	u32	ssn_offset;
 };
 
 static inline struct mptcp_subflow_request_sock *
@@ -88,18 +99,25 @@ struct mptcp_subflow_context {
 	u64	local_key;
 	u64	remote_key;
 	u64	idsn;
+	u64	map_seq;
 	u32	token;
 	u32     rel_write_seq;
-	u32	request_mptcp : 1,  /* send MP_CAPABLE */
+	u32	map_subflow_seq;
+	u32	ssn_offset;
+	u16	map_data_len;
+	u16	request_mptcp : 1,  /* send MP_CAPABLE */
 		request_cksum : 1,
 		request_version : 4,
 		mp_capable : 1,	    /* remote is MPTCP capable */
 		fourth_ack : 1,     /* send initial DSS */
 		conn_finished : 1,
-		use_checksum : 1;
+		use_checksum : 1,
+		map_valid : 1;
 
 	struct  socket *tcp_sock;  /* underlying tcp_sock */
 	struct  sock *conn;        /* parent mptcp_sock */
+	void	(*tcp_sk_data_ready)(struct sock *sk);
+	struct	rcu_head rcu;
 };
 
 static inline struct mptcp_subflow_context *
@@ -107,7 +125,8 @@ mptcp_subflow_ctx(const struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 
-	return (struct mptcp_subflow_context *)icsk->icsk_ulp_data;
+	/* Use RCU on icsk_ulp_data only for sock diag code */
+	return (__force struct mptcp_subflow_context *)icsk->icsk_ulp_data;
 }
 
 static inline struct socket *
@@ -154,4 +173,11 @@ static inline struct mptcp_ext *mptcp_get_ext(struct sk_buff *skb)
 	return (struct mptcp_ext *)skb_ext_find(skb, SKB_EXT_MPTCP);
 }
 
+static inline bool before64(__u64 seq1, __u64 seq2)
+{
+	return (__s64)(seq1 - seq2) < 0;
+}
+
+#define after64(seq2, seq1)	before64(seq1, seq2)
+
 #endif /* __MPTCP_PROTOCOL_H */
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 260352af20c9..1cde27227fd9 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -75,6 +75,7 @@ static void subflow_v4_init_req(struct request_sock *req,
 		    listener->request_cksum)
 			subflow_req->checksum = 1;
 		subflow_req->remote_key = rx_opt.mptcp.sndr_key;
+		subflow_req->ssn_offset = TCP_SKB_CB(skb)->seq;
 	} else {
 		subflow_req->mp_capable = 0;
 	}
@@ -91,6 +92,11 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 			 subflow->remote_key);
 		mptcp_finish_connect(subflow->conn, subflow->mp_capable);
 		subflow->conn_finished = 1;
+
+		if (skb) {
+			pr_debug("synack seq=%u", TCP_SKB_CB(skb)->seq);
+			subflow->ssn_offset = TCP_SKB_CB(skb)->seq;
+		}
 	}
 }
 
@@ -155,6 +161,20 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 
 static struct inet_connection_sock_af_ops subflow_specific;
 
+static void subflow_data_ready(struct sock *sk)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+	struct sock *parent = subflow->conn;
+
+	pr_debug("sk=%p", sk);
+	subflow->tcp_sk_data_ready(sk);
+
+	if (parent) {
+		pr_debug("parent=%p", parent);
+		parent->sk_data_ready(parent);
+	}
+}
+
 int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock)
 {
 	struct mptcp_subflow_context *subflow;
@@ -194,10 +214,9 @@ static struct mptcp_subflow_context *subflow_create_ctx(struct sock *sk,
 	struct mptcp_subflow_context *ctx;
 
 	ctx = kzalloc(sizeof(*ctx), priority);
-	icsk->icsk_ulp_data = ctx;
-
 	if (!ctx)
 		return NULL;
+	rcu_assign_pointer(icsk->icsk_ulp_data, ctx);
 
 	pr_debug("subflow=%p", ctx);
 
@@ -224,7 +243,9 @@ static int subflow_ulp_init(struct sock *sk)
 
 	tp->is_mptcp = 1;
 	icsk->icsk_af_ops = &subflow_specific;
+	ctx->tcp_sk_data_ready = sk->sk_data_ready;
 	ctx->use_checksum = 0;
+	sk->sk_data_ready = subflow_data_ready;
 out:
 	return err;
 }
@@ -233,10 +254,13 @@ static void subflow_ulp_release(struct sock *sk)
 {
 	struct mptcp_subflow_context *ctx = mptcp_subflow_ctx(sk);
 
+	if (!ctx)
+		return;
+
 	if (ctx->conn)
 		sock_put(ctx->conn);
 
-	kfree(ctx);
+	kfree_rcu(ctx, rcu);
 }
 
 static void subflow_ulp_clone(const struct request_sock *req,
@@ -244,6 +268,7 @@ static void subflow_ulp_clone(const struct request_sock *req,
 			      const gfp_t priority)
 {
 	struct mptcp_subflow_request_sock *subflow_req = mptcp_subflow_rsk(req);
+	struct mptcp_subflow_context *old_ctx = mptcp_subflow_ctx(newsk);
 	struct mptcp_subflow_context *new_ctx;
 
 	/* newsk->sk_socket is NULL at this point */
@@ -253,7 +278,8 @@ static void subflow_ulp_clone(const struct request_sock *req,
 
 	new_ctx->conn = NULL;
 	new_ctx->conn_finished = 1;
-	new_ctx->use_checksum = 0;
+	new_ctx->tcp_sk_data_ready = old_ctx->tcp_sk_data_ready;
+	new_ctx->use_checksum = old_ctx->use_checksum;
 
 	if (subflow_req->mp_capable) {
 		new_ctx->mp_capable = 1;
@@ -261,6 +287,8 @@ static void subflow_ulp_clone(const struct request_sock *req,
 		new_ctx->remote_key = subflow_req->remote_key;
 		new_ctx->local_key = subflow_req->local_key;
 		new_ctx->token = subflow_req->token;
+		new_ctx->ssn_offset = subflow_req->ssn_offset;
+		new_ctx->idsn = subflow_req->idsn;
 	}
 }
 
-- 
2.23.0

