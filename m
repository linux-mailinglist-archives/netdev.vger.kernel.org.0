Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94C4E4959A
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbfFQW7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:59:32 -0400
Received: from mga18.intel.com ([134.134.136.126]:10994 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728525AbfFQW6x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 18:58:53 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 15:58:51 -0700
X-ExtLoop1: 1
Received: from mjmartin-nuc01.amr.corp.intel.com (HELO mjmartin-nuc01.sea.intel.com) ([10.241.98.42])
  by orsmga002.jf.intel.com with ESMTP; 17 Jun 2019 15:58:51 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     edumazet@google.com, netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        cpaasch@apple.com, fw@strlen.de, pabeni@redhat.com,
        peter.krystad@linux.intel.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH net-next 19/33] mptcp: Implement MPTCP receive path
Date:   Mon, 17 Jun 2019 15:57:54 -0700
Message-Id: <20190617225808.665-20-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
References: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
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

Outgoing MPTCP ACK values are now populated from a value stored
in the connection socket rather than carried in an skb extension. This
allows sent packet headers to make use of the most up-to-date sequence
number and allows the MPTCP ACK to be populated in TCP ACK packets that
have no payload.

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
---
 include/linux/tcp.h  |  17 +-
 include/net/mptcp.h  |  16 +-
 net/ipv4/tcp_input.c |   4 +
 net/mptcp/options.c  | 138 ++++++++++++++--
 net/mptcp/protocol.c | 378 ++++++++++++++++++++++++++++++++++++++++---
 net/mptcp/protocol.h |  37 +++--
 net/mptcp/subflow.c  |  53 ++++--
 7 files changed, 574 insertions(+), 69 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index fcbe8443aaad..81cfa7834111 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -102,13 +102,26 @@ struct tcp_options_received {
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
index 003150a8e406..ecc45733d8cf 100644
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
@@ -71,6 +63,9 @@ bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
 			       unsigned int *size, unsigned int remaining,
 			       struct mptcp_out_options *opts);
 
+void mptcp_attach_dss(struct sock *sk, struct sk_buff *skb,
+		      struct tcp_options_received *opt_rx);
+
 static inline bool mptcp_skb_ext_exist(const struct sk_buff *skb)
 {
 	return skb_ext_exist(skb, SKB_EXT_MPTCP);
@@ -125,6 +120,11 @@ static inline bool mptcp_established_options(struct sock *sk,
 	return false;
 }
 
+static inline void mptcp_attach_dss(struct sock *sk, struct sk_buff *skb,
+				    struct tcp_options_received *opt_rx)
+{
+}
+
 static inline bool mptcp_skb_ext_exist(const struct sk_buff *skb)
 {
 	return false;
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 5e634fdd8e1c..eaa9abd8841d 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5650,6 +5650,10 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 	/* Process urgent data. */
 	tcp_urg(sk, skb, th);
 
+	/* Prepare MPTCP sequence data */
+	if (sk_is_mptcp(sk))
+		mptcp_attach_dss(sk, skb, &tp->rx_opt);
+
 	/* step 7: process the segment text */
 	tcp_data_queue(sk, skb);
 
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 625cd93fb9a8..6c5aed6351b3 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -14,6 +14,7 @@ void mptcp_parse_option(const unsigned char *ptr, int opsize,
 {
 	struct mptcp_options_received *mp_opt = &opt_rx->mptcp;
 	u8 subtype = *ptr >> 4;
+	int expected_opsize;
 
 	switch (subtype) {
 	/* MPTCPOPT_MP_CAPABLE
@@ -85,6 +86,72 @@ void mptcp_parse_option(const unsigned char *ptr, int opsize,
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
@@ -238,25 +305,31 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
 		}
 	}
 
-	if (mpext && mpext->use_ack) {
-		ack_size = TCPOLEN_MPTCP_DSS_ACK64;
+	ack_size = TCPOLEN_MPTCP_DSS_ACK64;
 
-		/* Add kind/lenght/subtype/flag overhead if mapping is not
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
+		msk = mptcp_sk(subflow_ctx(sk)->conn);
+		if (msk) {
+			opts->ext_copy.data_ack = msk->ack_seq;
 		} else {
-			opts->ext_copy.use_ack = 0;
-			WARN(1, "MPTCP: Ack dropped");
+			crypto_key_sha1(subflow_ctx(sk)->remote_key, NULL,
+					&opts->ext_copy.data_ack);
+			opts->ext_copy.data_ack++;
 		}
+
+		opts->ext_copy.ack64 = 1;
+		opts->ext_copy.use_ack = 1;
+	} else {
+		opts->ext_copy.use_ack = 0;
+		WARN(1, "MPTCP: Ack dropped");
 	}
 
 	*size = ALIGN(dss_size, 4);
@@ -304,6 +377,42 @@ bool mptcp_synack_options(const struct request_sock *req, unsigned int *size,
 	return false;
 }
 
+void mptcp_attach_dss(struct sock *sk, struct sk_buff *skb,
+		      struct tcp_options_received *opt_rx)
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
@@ -342,6 +451,7 @@ void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
 		}
 
 		if (mpext->use_map) {
+			pr_debug("Updating DSS length and flags for map");
 			len += TCPOLEN_MPTCP_DSS_MAP64;
 
 			if (mpext->use_checksum)
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index a6e6367c8ed1..2e76b7450ce2 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -7,6 +7,8 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/sched/signal.h>
+#include <linux/atomic.h>
 #include <net/sock.h>
 #include <net/inet_common.h>
 #include <net/inet_hashtables.h>
@@ -15,6 +17,13 @@
 #include <net/mptcp.h>
 #include "protocol.h"
 
+static inline bool before64(__u64 seq1, __u64 seq2)
+{
+	return (__s64)(seq1 - seq2) < 0;
+}
+
+#define after64(seq2, seq1)	before64(seq1, seq2)
+
 static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -91,15 +100,12 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	if (mpext) {
 		memset(mpext, 0, sizeof(*mpext));
-		mpext->data_ack = msk->ack_seq;
 		mpext->data_seq = msk->write_seq;
 		mpext->subflow_seq = subflow_ctx(ssk)->rel_write_seq;
 		mpext->data_len = ret;
 		mpext->checksum = 0xbeef;
 		mpext->use_map = 1;
 		mpext->dsn64 = 1;
-		mpext->use_ack = 1;
-		mpext->ack64 = 1;
 
 		pr_debug("data_seq=%llu subflow_seq=%u data_len=%u checksum=%u, dsn64=%d",
 			 mpext->data_seq, mpext->subflow_seq, mpext->data_len,
@@ -118,21 +124,333 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
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
+static u64 get_map_offset(struct subflow_context *subflow)
+{
+	return tcp_sk(mptcp_subflow_tcp_socket(subflow)->sk)->copied_seq -
+		      subflow->ssn_offset -
+		      subflow->map_subflow_seq;
+}
+
+static u64 get_mapped_dsn(struct subflow_context *subflow)
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
+static int mptcp_flush_actor(read_descriptor_t *desc, struct sk_buff *skb,
+			     unsigned int offset, size_t len)
+{
+	pr_debug("Flushing one skb with %zu of %zu bytes remaining",
+		 len, len + offset);
+
+	desc->count = 0;
+
+	return len;
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
+	struct subflow_context *subflow = subflow_ctx(ssk);
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
 static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 			 int nonblock, int flags, int *addr_len)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
-	struct socket *subflow;
+	struct subflow_context *subflow;
+	struct mptcp_read_arg arg;
+	read_descriptor_t desc;
+	struct tcp_sock *tp;
+	struct sock *ssk;
+	int copied = 0;
+	long timeo;
 
-	if (msk->connection_list) {
-		subflow = msk->connection_list;
-		pr_debug("conn_list->subflow=%p", subflow_ctx(subflow->sk));
-	} else {
-		subflow = msk->subflow;
-		pr_debug("subflow=%p", subflow_ctx(subflow->sk));
+	if (!msk->connection_list) {
+		pr_debug("fallback-read subflow=%p",
+			 subflow_ctx(msk->subflow->sk));
+		return sock_recvmsg(msk->subflow, msg, flags);
+	}
+
+	ssk = msk->connection_list->sk;
+	subflow = subflow_ctx(ssk);
+	tp = tcp_sk(ssk);
+
+	lock_sock(sk);
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
+		size_t discard_len = 0;
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
+			if (!subflow->map_valid) {
+				pr_debug("Mapping missing, trying next skb");
+
+				arg.msg = NULL;
+				desc.count = SIZE_MAX;
+
+				bytes_read = tcp_read_sock(ssk, &desc,
+							   mptcp_flush_actor);
+
+				if (bytes_read < 0)
+					break;
+
+				continue;
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
+			 * discard unmapped data.
+			 */
+			pr_debug("Mapping covers data later in stream");
+			discard_len = subflow->map_subflow_seq - ssn;
+		} else if (unlikely(!before(ssn, (subflow->map_subflow_seq +
+						  subflow->map_data_len)))) {
+			/* Mapping ends earlier in the subflow stream.
+			 * Invalidate the mapping and try again.
+			 */
+			subflow->map_valid = 0;
+			pr_debug("Invalid mapping ssn=%d map_seq=%d map_data_len=%d",
+				 ssn, subflow->map_subflow_seq,
+				 subflow->map_data_len);
+			continue;
+		} else {
+			ack_seq = get_mapped_dsn(subflow);
+
+			if (before64(ack_seq, old_ack)) {
+				/* Mapping covers data already received,
+				 * discard data in the current mapping
+				 * and invalidate the map
+				 */
+				u64 map_end_dsn = subflow->map_seq +
+					subflow->map_data_len;
+				discard_len = min(map_end_dsn - ack_seq,
+						  old_ack - ack_seq);
+				subflow->map_valid = 0;
+				pr_debug("Duplicate MPTCP data found");
+			}
+		}
+
+		if (discard_len) {
+			/* Discard data for the current mapping.
+			 */
+			pr_debug("Discard %zu bytes", discard_len);
+
+			arg.msg = NULL;
+			desc.count = discard_len;
+
+			bytes_read = tcp_read_sock(ssk, &desc,
+						   mptcp_read_actor);
+
+			if (bytes_read < 0)
+				break;
+			else if (bytes_read == discard_len)
+				continue;
+			else
+				goto wait_for_data;
+		}
+
+		/* Read mapped data */
+		map_remaining = subflow->map_data_len - get_map_offset(subflow);
+		desc.count = min_t(size_t, len - copied, map_remaining);
+		arg.msg = msg;
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
+
+		copied += bytes_read;
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
 	}
 
-	return sock_recvmsg(subflow, msg, flags);
+	release_sock(ssk);
+	release_sock(sk);
+
+	return copied;
 }
 
 static int mptcp_init_sock(struct sock *sk)
@@ -192,22 +510,29 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 
 	msk = mptcp_sk(new_mptcp_sock->sk);
 	pr_debug("new msk=%p", msk);
-	subflow->conn = new_mptcp_sock->sk;
-	subflow->tcp_sock = new_sock;
 
 	if (subflow->mp_capable) {
+		u64 ack_seq;
+
+		msk->remote_key = subflow->remote_key;
 		msk->local_key = subflow->local_key;
 		msk->token = subflow->token;
 		token_update_accept(new_sock->sk, new_mptcp_sock->sk);
+		msk->connection_list = new_sock;
+
+		crypto_key_sha1(msk->remote_key, NULL, &ack_seq);
 		msk->write_seq = subflow->idsn + 1;
+		ack_seq++;
+		msk->ack_seq = ack_seq;
+		subflow->map_seq = ack_seq;
+		subflow->map_subflow_seq = 1;
 		subflow->rel_write_seq = 1;
-		msk->remote_key = subflow->remote_key;
-		crypto_key_sha1(msk->remote_key, NULL, &msk->ack_seq);
-		msk->ack_seq++;
-		msk->connection_list = new_sock;
+		subflow->conn = new_mptcp_sock->sk;
+		subflow->tcp_sock = new_sock;
 	} else {
 		msk->subflow = new_sock;
 	}
+	inet_sk_state_store(new_mptcp_sock->sk, TCP_ESTABLISHED);
 
 	return new_mptcp_sock->sk;
 }
@@ -282,17 +607,24 @@ void mptcp_finish_connect(struct sock *sk, int mp_capable)
 	struct subflow_context *subflow = subflow_ctx(msk->subflow->sk);
 
 	if (mp_capable) {
+		u64 ack_seq;
+
+		msk->remote_key = subflow->remote_key;
 		msk->local_key = subflow->local_key;
 		msk->token = subflow->token;
-		msk->write_seq = subflow->idsn + 1;
-		subflow->rel_write_seq = 1;
-		msk->remote_key = subflow->remote_key;
-		crypto_key_sha1(msk->remote_key, NULL, &msk->ack_seq);
-		msk->ack_seq++;
+		pr_debug("msk=%p, token=%u", msk, msk->token);
 		msk->connection_list = msk->subflow;
 		msk->subflow = NULL;
+
+		crypto_key_sha1(msk->remote_key, NULL, &ack_seq);
+		msk->write_seq = subflow->idsn + 1;
+		ack_seq++;
+		msk->ack_seq = ack_seq;
+		subflow->map_seq = ack_seq;
+		subflow->map_subflow_seq = 1;
+		subflow->rel_write_seq = 1;
 	}
-	sk->sk_state = TCP_ESTABLISHED;
+	inet_sk_state_store(sk, TCP_ESTABLISHED);
 }
 
 static struct proto mptcp_prot = {
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 79a9ce6c4d31..5c840f76a9b9 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -22,7 +22,9 @@
 #define TCPOLEN_MPTCP_MPC_SYNACK	20
 #define TCPOLEN_MPTCP_MPC_ACK		20
 #define TCPOLEN_MPTCP_DSS_BASE		4
+#define TCPOLEN_MPTCP_DSS_ACK32		4
 #define TCPOLEN_MPTCP_DSS_ACK64		8
+#define TCPOLEN_MPTCP_DSS_MAP32		10
 #define TCPOLEN_MPTCP_DSS_MAP64		14
 #define TCPOLEN_MPTCP_DSS_CHECKSUM	2
 
@@ -33,17 +35,25 @@
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
-	struct	inet_connection_sock sk;
-	u64	local_key;
-	u64	remote_key;
-	u64	write_seq;
-	u64	ack_seq;
-	u32	token;
-	struct	socket *connection_list; /* @@ needs to be a list */
-	struct	socket *subflow; /* outgoing connect, listener or !mp_capable */
+	struct inet_connection_sock sk;
+	u64		local_key;
+	u64		remote_key;
+	u64		write_seq;
+	u64		ack_seq;
+	u32		token;
+	struct socket	*connection_list; /* @@ needs to be a list */
+	struct socket	*subflow; /* outgoing connect/listener/!mp_capable */
 };
 
 static inline struct mptcp_sock *mptcp_sk(const struct sock *sk)
@@ -62,6 +72,7 @@ struct subflow_request_sock {
 	u64	remote_key;
 	u64	idsn;
 	u32	token;
+	u32	ssn_offset;
 };
 
 static inline
@@ -77,16 +88,22 @@ struct subflow_context {
 	u32	token;
 	u32     rel_write_seq;
 	u64     idsn;
-	u32	request_mptcp : 1,  /* send MP_CAPABLE */
+	u64	map_seq;
+	u32	map_subflow_seq;
+	u32	ssn_offset;
+	u16	map_data_len;
+	u16	request_mptcp : 1,  /* send MP_CAPABLE */
 		request_cksum : 1,
 		mp_capable : 1,	    /* remote is MPTCP capable */
 		fourth_ack : 1,     /* send initial DSS */
 		version : 4,
 		conn_finished : 1,
-		use_checksum : 1;
+		use_checksum : 1,
+		map_valid : 1;
 
 	struct  socket *tcp_sock;  /* underlying tcp_sock */
 	struct  sock *conn;        /* parent mptcp_sock */
+	void	(*tcp_sk_data_ready)(struct sock *sk);
 };
 
 static inline struct subflow_context *subflow_ctx(const struct sock *sk)
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index bbfdf03489bb..a82f5091eed8 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -66,6 +66,8 @@ static void subflow_v4_init_req(struct request_sock *req,
 		subflow_req->remote_key = rx_opt.mptcp.sndr_key;
 		pr_debug("remote_key=%llu", subflow_req->remote_key);
 		token_new_request(req, skb);
+		pr_debug("syn seq=%u", TCP_SKB_CB(skb)->seq);
+		subflow_req->ssn_offset = TCP_SKB_CB(skb)->seq;
 	} else {
 		subflow_req->mp_capable = 0;
 	}
@@ -82,6 +84,11 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
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
 
@@ -150,6 +157,20 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 
 static struct inet_connection_sock_af_ops subflow_specific;
 
+static void subflow_data_ready(struct sock *sk)
+{
+	struct subflow_context *subflow = subflow_ctx(sk);
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
 static struct subflow_context *subflow_create_ctx(struct sock *sk,
 						  struct socket *sock,
 						  gfp_t priority)
@@ -188,7 +209,9 @@ static int subflow_ulp_init(struct sock *sk)
 
 	tp->is_mptcp = 1;
 	icsk->icsk_af_ops = &subflow_specific;
+	ctx->tcp_sk_data_ready = sk->sk_data_ready;
 	ctx->use_checksum = 0;
+	sk->sk_data_ready = subflow_data_ready;
 out:
 	return err;
 }
@@ -207,25 +230,31 @@ static void subflow_ulp_clone(const struct request_sock *req,
 			      const gfp_t priority)
 {
 	struct subflow_request_sock *subflow_req = subflow_rsk(req);
+	struct subflow_context *old_ctx;
+	struct subflow_context *new_ctx;
+
+	old_ctx = inet_csk(newsk)->icsk_ulp_data;
 
 	/* newsk->sk_socket is NULL at this point */
-	struct subflow_context *subflow = subflow_create_ctx(newsk, NULL,
-							     priority);
+	new_ctx = subflow_create_ctx(newsk, NULL, priority);
 
-	if (!subflow)
+	if (!new_ctx)
 		return;
 
-	subflow->conn = NULL;
-	subflow->conn_finished = 1;
-	subflow->use_checksum = 0;
+	new_ctx->conn = NULL;
+	new_ctx->conn_finished = 1;
+	new_ctx->tcp_sk_data_ready = old_ctx->tcp_sk_data_ready;
+	new_ctx->use_checksum = old_ctx->use_checksum;
 
 	if (subflow_req->mp_capable) {
-		subflow->mp_capable = 1;
-		subflow->fourth_ack = 1;
-		subflow->remote_key = subflow_req->remote_key;
-		subflow->local_key = subflow_req->local_key;
-		subflow->token = subflow_req->token;
-		pr_debug("token=%u", subflow->token);
+		new_ctx->mp_capable = 1;
+		new_ctx->fourth_ack = 1;
+		new_ctx->remote_key = subflow_req->remote_key;
+		new_ctx->local_key = subflow_req->local_key;
+		new_ctx->token = subflow_req->token;
+		new_ctx->ssn_offset = subflow_req->ssn_offset;
+		new_ctx->idsn = subflow_req->idsn;
+		pr_debug("token=%u", new_ctx->token);
 	}
 }
 
-- 
2.22.0

