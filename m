Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 624FA14492F
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 02:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbgAVBFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 20:05:07 -0500
Received: from ma1-aaemail-dr-lapp01.apple.com ([17.171.2.60]:46196 "EHLO
        ma1-aaemail-dr-lapp01.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728609AbgAVBFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 20:05:07 -0500
X-Greylist: delayed 473 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jan 2020 20:05:04 EST
Received: from pps.filterd (ma1-aaemail-dr-lapp01.apple.com [127.0.0.1])
        by ma1-aaemail-dr-lapp01.apple.com (8.16.0.27/8.16.0.27) with SMTP id 00M0v12h016568;
        Tue, 21 Jan 2020 16:57:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=sender : from : to :
 cc : subject : date : message-id : in-reply-to : references : mime-version
 : content-transfer-encoding; s=20180706;
 bh=P4HYqWnPW3LM4NsyheBoYc5p3humRdmUtwWamNPKG6E=;
 b=c+BTKVwZaOeG+RuQg1mh9xi/UWi42TSJQnA2Oeq4xHRTE0sVOu5SQKZAxaBUd7Be1vAQ
 KPMu7lEyFNkRTPASxFUOBa5zjuF3rTV9DPXp87gK4/wiRS2ZaummhykskEnKnDSLb5qA
 YLUS4Xdf4saSFHjLgZil86JDDwFvUNnLmLj10nBlcvzFyWzJM+PM1Xje+aSOseU/V4AH
 J6oacuHtbaBNL1jwYjcRkXpBy8jKqtyAMzey/HP3Z/Hf44EXEpuy9kJEnm19RSjmvZT9
 qjXv86DZoRJgYgd8yKGkFiHcydEbbE50JHcnKC0xyNI5thlhSnnzHPcEi1Ea/ORbQWDc Rw== 
Received: from mr2-mtap-s02.rno.apple.com (mr2-mtap-s02.rno.apple.com [17.179.226.134])
        by ma1-aaemail-dr-lapp01.apple.com with ESMTP id 2xm1j8ksrg-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Tue, 21 Jan 2020 16:57:03 -0800
Received: from nwk-mmpp-sz13.apple.com
 (nwk-mmpp-sz13.apple.com [17.128.115.216]) by mr2-mtap-s02.rno.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPS id <0Q4H00ERMHB31200@mr2-mtap-s02.rno.apple.com>; Tue,
 21 Jan 2020 16:57:03 -0800 (PST)
Received: from process_milters-daemon.nwk-mmpp-sz13.apple.com by
 nwk-mmpp-sz13.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) id <0Q4H00100GR2PR00@nwk-mmpp-sz13.apple.com>; Tue,
 21 Jan 2020 16:57:03 -0800 (PST)
X-Va-A: 
X-Va-T-CD: 4b1e0bf36502e052fc75ad21b706ed24
X-Va-E-CD: ac8e93af83cdded18ecd24b166711788
X-Va-R-CD: 68f9cb94711d0221451738a98b442b3b
X-Va-CD: 0
X-Va-ID: 78f5d884-080b-4c8f-833f-440a6072fe61
X-V-A:  
X-V-T-CD: 4b1e0bf36502e052fc75ad21b706ed24
X-V-E-CD: ac8e93af83cdded18ecd24b166711788
X-V-R-CD: 68f9cb94711d0221451738a98b442b3b
X-V-CD: 0
X-V-ID: 5f155179-2ad4-4375-8e8d-28fa2b39fc42
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,,
 definitions=2020-01-17_05:,, signatures=0
Received: from localhost ([17.192.155.241]) by nwk-mmpp-sz13.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPSA id <0Q4H00125HB04Y50@nwk-mmpp-sz13.apple.com>; Tue,
 21 Jan 2020 16:57:00 -0800 (PST)
From:   Christoph Paasch <cpaasch@apple.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Peter Krystad <peter.krystad@linux.intel.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next v3 10/19] mptcp: Implement MPTCP receive path
Date:   Tue, 21 Jan 2020 16:56:24 -0800
Message-id: <20200122005633.21229-11-cpaasch@apple.com>
X-Mailer: git-send-email 2.23.0
In-reply-to: <20200122005633.21229-1-cpaasch@apple.com>
References: <20200122005633.21229-1-cpaasch@apple.com>
MIME-version: 1.0
Content-transfer-encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2020-01-17_05:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mat Martineau <mathew.j.martineau@linux.intel.com>

Parses incoming DSS options and populates outgoing MPTCP ACK
fields. MPTCP fields are parsed from the TCP option header and placed in
an skb extension, allowing the upper MPTCP layer to access MPTCP
options after the skb has gone through the TCP stack.

The subflow implements its own data_ready() ops, which ensures that the
pending data is in sequence - according to MPTCP seq number - dropping
out-of-seq skbs. The DATA_READY bit flag is set if this is the case.
This allows the MPTCP socket layer to determine if more data is
available without having to consult the individual subflows.

It additionally validates the current mapping and propagates EoF events
to the connection socket.

Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Co-developed-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
Co-developed-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Co-developed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Christoph Paasch <cpaasch@apple.com>
---
 include/linux/tcp.h  |  10 ++
 include/net/mptcp.h  |   8 +
 net/ipv4/tcp_input.c |   8 +-
 net/mptcp/options.c  | 107 ++++++++++++
 net/mptcp/protocol.c |  34 ++++
 net/mptcp/protocol.h |  64 +++++++-
 net/mptcp/subflow.c  | 383 ++++++++++++++++++++++++++++++++++++++++++-
 7 files changed, 609 insertions(+), 5 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index e9ee06d887fa..0d00dad4b85d 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -82,9 +82,19 @@ struct tcp_sack_block {
 struct mptcp_options_received {
 	u64	sndr_key;
 	u64	rcvr_key;
+	u64	data_ack;
+	u64	data_seq;
+	u32	subflow_seq;
+	u16	data_len;
 	u8	mp_capable : 1,
 		mp_join : 1,
 		dss : 1;
+	u8	use_map:1,
+		dsn64:1,
+		data_fin:1,
+		use_ack:1,
+		ack64:1,
+		__unused:3;
 };
 #endif
 
diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 06dcc665135e..8619c1fca741 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -60,6 +60,8 @@ bool mptcp_synack_options(const struct request_sock *req, unsigned int *size,
 bool mptcp_established_options(struct sock *sk, struct sk_buff *skb,
 			       unsigned int *size, unsigned int remaining,
 			       struct mptcp_out_options *opts);
+void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb,
+			    struct tcp_options_received *opt_rx);
 
 void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts);
 
@@ -150,6 +152,12 @@ static inline bool mptcp_established_options(struct sock *sk,
 	return false;
 }
 
+static inline void mptcp_incoming_options(struct sock *sk,
+					  struct sk_buff *skb,
+					  struct tcp_options_received *opt_rx)
+{
+}
+
 static inline void mptcp_skb_ext_move(struct sk_buff *to,
 				      const struct sk_buff *from)
 {
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 5165c8de47ee..28d31f2c1422 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4770,6 +4770,9 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 	bool fragstolen;
 	int eaten;
 
+	if (sk_is_mptcp(sk))
+		mptcp_incoming_options(sk, skb, &tp->rx_opt);
+
 	if (TCP_SKB_CB(skb)->seq == TCP_SKB_CB(skb)->end_seq) {
 		__kfree_skb(skb);
 		return;
@@ -6346,8 +6349,11 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
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
index 5ea127bc7f01..1fa8496f3551 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -14,6 +14,7 @@ void mptcp_parse_option(const unsigned char *ptr, int opsize,
 {
 	struct mptcp_options_received *mp_opt = &opt_rx->mptcp;
 	u8 subtype = *ptr >> 4;
+	int expected_opsize;
 	u8 version;
 	u8 flags;
 
@@ -64,7 +65,79 @@ void mptcp_parse_option(const unsigned char *ptr, int opsize,
 
 	case MPTCPOPT_DSS:
 		pr_debug("DSS");
+		ptr++;
+
+		flags = (*ptr++) & MPTCP_DSS_FLAG_MASK;
+		mp_opt->data_fin = (flags & MPTCP_DSS_DATA_FIN) != 0;
+		mp_opt->dsn64 = (flags & MPTCP_DSS_DSN64) != 0;
+		mp_opt->use_map = (flags & MPTCP_DSS_HAS_MAP) != 0;
+		mp_opt->ack64 = (flags & MPTCP_DSS_ACK64) != 0;
+		mp_opt->use_ack = (flags & MPTCP_DSS_HAS_ACK);
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
+		}
+
+		if (mp_opt->use_map) {
+			if (mp_opt->dsn64)
+				expected_opsize += TCPOLEN_MPTCP_DSS_MAP64;
+			else
+				expected_opsize += TCPOLEN_MPTCP_DSS_MAP32;
+		}
+
+		/* RFC 6824, Section 3.3:
+		 * If a checksum is present, but its use had
+		 * not been negotiated in the MP_CAPABLE handshake,
+		 * the checksum field MUST be ignored.
+		 */
+		if (opsize != expected_opsize &&
+		    opsize != expected_opsize + TCPOLEN_MPTCP_DSS_CHECKSUM)
+			break;
+
 		mp_opt->dss = 1;
+
+		if (mp_opt->use_ack) {
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
+			pr_debug("data_seq=%llu subflow_seq=%u data_len=%u",
+				 mp_opt->data_seq, mp_opt->subflow_seq,
+				 mp_opt->data_len);
+		}
+
 		break;
 
 	default:
@@ -275,6 +348,40 @@ bool mptcp_synack_options(const struct request_sock *req, unsigned int *size,
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
+		mpext->use_map = 1;
+		mpext->dsn64 = mp_opt->dsn64;
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
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 8cf49193b1c0..71250149180b 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -224,6 +224,33 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	return ret;
 }
 
+int mptcp_read_actor(read_descriptor_t *desc, struct sk_buff *skb,
+		     unsigned int offset, size_t len)
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
+	desc->count -= copy_len;
+
+	pr_debug("consumed %zu bytes, %zu left", copy_len, desc->count);
+	return copy_len;
+}
+
 static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 			 int nonblock, int flags, int *addr_len)
 {
@@ -414,7 +441,10 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 		msk->write_seq = subflow->idsn + 1;
 		ack_seq++;
 		msk->ack_seq = ack_seq;
+		subflow->map_seq = ack_seq;
+		subflow->map_subflow_seq = 1;
 		subflow->rel_write_seq = 1;
+		subflow->tcp_sock = ssk;
 		newsk = new_mptcp_sock;
 		mptcp_copy_inaddrs(newsk, ssk);
 		list_add(&subflow->node, &msk->conn_list);
@@ -519,8 +549,12 @@ void mptcp_finish_connect(struct sock *ssk)
 	sk = subflow->conn;
 	msk = mptcp_sk(sk);
 
+	pr_debug("msk=%p, token=%u", sk, subflow->token);
+
 	mptcp_crypto_key_sha(subflow->remote_key, NULL, &ack_seq);
 	ack_seq++;
+	subflow->map_seq = ack_seq;
+	subflow->map_subflow_seq = 1;
 	subflow->rel_write_seq = 1;
 
 	/* the socket is not connected yet, no msk/subflow ops can access/race
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 384ec4804198..c6d8217e24d4 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -33,7 +33,9 @@
 #define TCPOLEN_MPTCP_MPC_SYNACK	12
 #define TCPOLEN_MPTCP_MPC_ACK		20
 #define TCPOLEN_MPTCP_DSS_BASE		4
+#define TCPOLEN_MPTCP_DSS_ACK32		4
 #define TCPOLEN_MPTCP_DSS_ACK64		8
+#define TCPOLEN_MPTCP_DSS_MAP32		10
 #define TCPOLEN_MPTCP_DSS_MAP64		14
 #define TCPOLEN_MPTCP_DSS_CHECKSUM	2
 
@@ -50,6 +52,10 @@
 #define MPTCP_DSS_HAS_MAP	BIT(2)
 #define MPTCP_DSS_ACK64		BIT(1)
 #define MPTCP_DSS_HAS_ACK	BIT(0)
+#define MPTCP_DSS_FLAG_MASK	(0x1F)
+
+/* MPTCP socket flags */
+#define MPTCP_DATA_READY	BIT(0)
 
 /* MPTCP connection sock */
 struct mptcp_sock {
@@ -60,6 +66,7 @@ struct mptcp_sock {
 	u64		write_seq;
 	u64		ack_seq;
 	u32		token;
+	unsigned long	flags;
 	struct list_head conn_list;
 	struct skb_ext	*cached_ext;	/* for the next sendmsg */
 	struct socket	*subflow; /* outgoing connect/listener/!mp_capable */
@@ -82,6 +89,7 @@ struct mptcp_subflow_request_sock {
 	u64	remote_key;
 	u64	idsn;
 	u32	token;
+	u32	ssn_offset;
 };
 
 static inline struct mptcp_subflow_request_sock *
@@ -96,15 +104,27 @@ struct mptcp_subflow_context {
 	u64	local_key;
 	u64	remote_key;
 	u64	idsn;
+	u64	map_seq;
 	u32	token;
 	u32	rel_write_seq;
+	u32	map_subflow_seq;
+	u32	ssn_offset;
+	u32	map_data_len;
 	u32	request_mptcp : 1,  /* send MP_CAPABLE */
 		mp_capable : 1,	    /* remote is MPTCP capable */
 		fourth_ack : 1,	    /* send initial DSS */
-		conn_finished : 1;
+		conn_finished : 1,
+		map_valid : 1,
+		data_avail : 1,
+		rx_eof : 1;
+
 	struct	sock *tcp_sock;	    /* tcp sk backpointer */
 	struct	sock *conn;	    /* parent mptcp_sock */
 	const	struct inet_connection_sock_af_ops *icsk_af_ops;
+	void	(*tcp_data_ready)(struct sock *sk);
+	void	(*tcp_state_change)(struct sock *sk);
+	void	(*tcp_write_space)(struct sock *sk);
+
 	struct	rcu_head rcu;
 };
 
@@ -123,14 +143,49 @@ mptcp_subflow_tcp_sock(const struct mptcp_subflow_context *subflow)
 	return subflow->tcp_sock;
 }
 
+static inline u64
+mptcp_subflow_get_map_offset(const struct mptcp_subflow_context *subflow)
+{
+	return tcp_sk(mptcp_subflow_tcp_sock(subflow))->copied_seq -
+		      subflow->ssn_offset -
+		      subflow->map_subflow_seq;
+}
+
+static inline u64
+mptcp_subflow_get_mapped_dsn(const struct mptcp_subflow_context *subflow)
+{
+	return subflow->map_seq + mptcp_subflow_get_map_offset(subflow);
+}
+
+int mptcp_is_enabled(struct net *net);
+bool mptcp_subflow_data_available(struct sock *sk);
 void mptcp_subflow_init(void);
 int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock);
 
+static inline void mptcp_subflow_tcp_fallback(struct sock *sk,
+					      struct mptcp_subflow_context *ctx)
+{
+	sk->sk_data_ready = ctx->tcp_data_ready;
+	sk->sk_state_change = ctx->tcp_state_change;
+	sk->sk_write_space = ctx->tcp_write_space;
+
+	inet_csk(sk)->icsk_af_ops = ctx->icsk_af_ops;
+}
+
 extern const struct inet_connection_sock_af_ops ipv4_specific;
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 extern const struct inet_connection_sock_af_ops ipv6_specific;
 #endif
 
+void mptcp_proto_init(void);
+
+struct mptcp_read_arg {
+	struct msghdr *msg;
+};
+
+int mptcp_read_actor(read_descriptor_t *desc, struct sk_buff *skb,
+		     unsigned int offset, size_t len);
+
 void mptcp_get_options(const struct sk_buff *skb,
 		       struct tcp_options_received *opt_rx);
 
@@ -164,4 +219,11 @@ static inline struct mptcp_ext *mptcp_get_ext(struct sk_buff *skb)
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
index 89b91bc7a831..528351e26371 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -78,6 +78,7 @@ static void subflow_init_req(struct request_sock *req,
 			subflow_req->mp_capable = 1;
 
 		subflow_req->remote_key = rx_opt.mptcp.sndr_key;
+		subflow_req->ssn_offset = TCP_SKB_CB(skb)->seq;
 	}
 }
 
@@ -116,6 +117,11 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 			 subflow->remote_key);
 		mptcp_finish_connect(sk);
 		subflow->conn_finished = 1;
+
+		if (skb) {
+			pr_debug("synack seq=%u", TCP_SKB_CB(skb)->seq);
+			subflow->ssn_offset = TCP_SKB_CB(skb)->seq;
+		}
 	}
 }
 
@@ -210,6 +216,323 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 
 static struct inet_connection_sock_af_ops subflow_specific;
 
+enum mapping_status {
+	MAPPING_OK,
+	MAPPING_INVALID,
+	MAPPING_EMPTY,
+	MAPPING_DATA_FIN
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
+static void warn_bad_map(struct mptcp_subflow_context *subflow, u32 ssn)
+{
+	WARN_ONCE(1, "Bad mapping: ssn=%d map_seq=%d map_data_len=%d",
+		  ssn, subflow->map_subflow_seq, subflow->map_data_len);
+}
+
+static bool skb_is_fully_mapped(struct sock *ssk, struct sk_buff *skb)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
+	unsigned int skb_consumed;
+
+	skb_consumed = tcp_sk(ssk)->copied_seq - TCP_SKB_CB(skb)->seq;
+	if (WARN_ON_ONCE(skb_consumed >= skb->len))
+		return true;
+
+	return skb->len - skb_consumed <= subflow->map_data_len -
+					  mptcp_subflow_get_map_offset(subflow);
+}
+
+static bool validate_mapping(struct sock *ssk, struct sk_buff *skb)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
+	u32 ssn = tcp_sk(ssk)->copied_seq - subflow->ssn_offset;
+
+	if (unlikely(before(ssn, subflow->map_subflow_seq))) {
+		/* Mapping covers data later in the subflow stream,
+		 * currently unsupported.
+		 */
+		warn_bad_map(subflow, ssn);
+		return false;
+	}
+	if (unlikely(!before(ssn, subflow->map_subflow_seq +
+				  subflow->map_data_len))) {
+		/* Mapping does covers past subflow data, invalid */
+		warn_bad_map(subflow, ssn + skb->len);
+		return false;
+	}
+	return true;
+}
+
+static enum mapping_status get_mapping_status(struct sock *ssk)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
+	struct mptcp_ext *mpext;
+	struct sk_buff *skb;
+	u16 data_len;
+	u64 map_seq;
+
+	skb = skb_peek(&ssk->sk_receive_queue);
+	if (!skb)
+		return MAPPING_EMPTY;
+
+	mpext = mptcp_get_ext(skb);
+	if (!mpext || !mpext->use_map) {
+		if (!subflow->map_valid && !skb->len) {
+			/* the TCP stack deliver 0 len FIN pkt to the receive
+			 * queue, that is the only 0len pkts ever expected here,
+			 * and we can admit no mapping only for 0 len pkts
+			 */
+			if (!(TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN))
+				WARN_ONCE(1, "0len seq %d:%d flags %x",
+					  TCP_SKB_CB(skb)->seq,
+					  TCP_SKB_CB(skb)->end_seq,
+					  TCP_SKB_CB(skb)->tcp_flags);
+			sk_eat_skb(ssk, skb);
+			return MAPPING_EMPTY;
+		}
+
+		if (!subflow->map_valid)
+			return MAPPING_INVALID;
+
+		goto validate_seq;
+	}
+
+	pr_debug("seq=%llu is64=%d ssn=%u data_len=%u data_fin=%d",
+		 mpext->data_seq, mpext->dsn64, mpext->subflow_seq,
+		 mpext->data_len, mpext->data_fin);
+
+	data_len = mpext->data_len;
+	if (data_len == 0) {
+		pr_err("Infinite mapping not handled");
+		return MAPPING_INVALID;
+	}
+
+	if (mpext->data_fin == 1) {
+		if (data_len == 1) {
+			pr_debug("DATA_FIN with no payload");
+			if (subflow->map_valid) {
+				/* A DATA_FIN might arrive in a DSS
+				 * option before the previous mapping
+				 * has been fully consumed. Continue
+				 * handling the existing mapping.
+				 */
+				skb_ext_del(skb, SKB_EXT_MPTCP);
+				return MAPPING_OK;
+			} else {
+				return MAPPING_DATA_FIN;
+			}
+		}
+
+		/* Adjust for DATA_FIN using 1 byte of sequence space */
+		data_len--;
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
+		/* Allow replacing only with an identical map */
+		if (subflow->map_seq == map_seq &&
+		    subflow->map_subflow_seq == mpext->subflow_seq &&
+		    subflow->map_data_len == data_len) {
+			skb_ext_del(skb, SKB_EXT_MPTCP);
+			return MAPPING_OK;
+		}
+
+		/* If this skb data are fully covered by the current mapping,
+		 * the new map would need caching, which is not supported
+		 */
+		if (skb_is_fully_mapped(ssk, skb))
+			return MAPPING_INVALID;
+
+		/* will validate the next map after consuming the current one */
+		return MAPPING_OK;
+	}
+
+	subflow->map_seq = map_seq;
+	subflow->map_subflow_seq = mpext->subflow_seq;
+	subflow->map_data_len = data_len;
+	subflow->map_valid = 1;
+	pr_debug("new map seq=%llu subflow_seq=%u data_len=%u",
+		 subflow->map_seq, subflow->map_subflow_seq,
+		 subflow->map_data_len);
+
+validate_seq:
+	/* we revalidate valid mapping on new skb, because we must ensure
+	 * the current skb is completely covered by the available mapping
+	 */
+	if (!validate_mapping(ssk, skb))
+		return MAPPING_INVALID;
+
+	skb_ext_del(skb, SKB_EXT_MPTCP);
+	return MAPPING_OK;
+}
+
+static bool subflow_check_data_avail(struct sock *ssk)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
+	enum mapping_status status;
+	struct mptcp_sock *msk;
+	struct sk_buff *skb;
+
+	pr_debug("msk=%p ssk=%p data_avail=%d skb=%p", subflow->conn, ssk,
+		 subflow->data_avail, skb_peek(&ssk->sk_receive_queue));
+	if (subflow->data_avail)
+		return true;
+
+	if (!subflow->conn)
+		return false;
+
+	msk = mptcp_sk(subflow->conn);
+	for (;;) {
+		u32 map_remaining;
+		size_t delta;
+		u64 ack_seq;
+		u64 old_ack;
+
+		status = get_mapping_status(ssk);
+		pr_debug("msk=%p ssk=%p status=%d", msk, ssk, status);
+		if (status == MAPPING_INVALID) {
+			ssk->sk_err = EBADMSG;
+			goto fatal;
+		}
+
+		if (status != MAPPING_OK)
+			return false;
+
+		skb = skb_peek(&ssk->sk_receive_queue);
+		if (WARN_ON_ONCE(!skb))
+			return false;
+
+		old_ack = READ_ONCE(msk->ack_seq);
+		ack_seq = mptcp_subflow_get_mapped_dsn(subflow);
+		pr_debug("msk ack_seq=%llx subflow ack_seq=%llx", old_ack,
+			 ack_seq);
+		if (ack_seq == old_ack)
+			break;
+
+		/* only accept in-sequence mapping. Old values are spurious
+		 * retransmission; we can hit "future" values on active backup
+		 * subflow switch, we relay on retransmissions to get
+		 * in-sequence data.
+		 * Cuncurrent subflows support will require subflow data
+		 * reordering
+		 */
+		map_remaining = subflow->map_data_len -
+				mptcp_subflow_get_map_offset(subflow);
+		if (before64(ack_seq, old_ack))
+			delta = min_t(size_t, old_ack - ack_seq, map_remaining);
+		else
+			delta = min_t(size_t, ack_seq - old_ack, map_remaining);
+
+		/* discard mapped data */
+		pr_debug("discarding %zu bytes, current map len=%d", delta,
+			 map_remaining);
+		if (delta) {
+			struct mptcp_read_arg arg = {
+				.msg = NULL,
+			};
+			read_descriptor_t desc = {
+				.count = delta,
+				.arg.data = &arg,
+			};
+			int ret;
+
+			ret = tcp_read_sock(ssk, &desc, mptcp_read_actor);
+			if (ret < 0) {
+				ssk->sk_err = -ret;
+				goto fatal;
+			}
+			if (ret < delta)
+				return false;
+			if (delta == map_remaining)
+				subflow->map_valid = 0;
+		}
+	}
+	return true;
+
+fatal:
+	/* fatal protocol error, close the socket */
+	/* This barrier is coupled with smp_rmb() in tcp_poll() */
+	smp_wmb();
+	ssk->sk_error_report(ssk);
+	tcp_set_state(ssk, TCP_CLOSE);
+	tcp_send_active_reset(ssk, GFP_ATOMIC);
+	return false;
+}
+
+bool mptcp_subflow_data_available(struct sock *sk)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+	struct sk_buff *skb;
+
+	/* check if current mapping is still valid */
+	if (subflow->map_valid &&
+	    mptcp_subflow_get_map_offset(subflow) >= subflow->map_data_len) {
+		subflow->map_valid = 0;
+		subflow->data_avail = 0;
+
+		pr_debug("Done with mapping: seq=%u data_len=%u",
+			 subflow->map_subflow_seq,
+			 subflow->map_data_len);
+	}
+
+	if (!subflow_check_data_avail(sk)) {
+		subflow->data_avail = 0;
+		return false;
+	}
+
+	skb = skb_peek(&sk->sk_receive_queue);
+	subflow->data_avail = skb &&
+		       before(tcp_sk(sk)->copied_seq, TCP_SKB_CB(skb)->end_seq);
+	return subflow->data_avail;
+}
+
+static void subflow_data_ready(struct sock *sk)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+	struct sock *parent = subflow->conn;
+
+	if (!parent || !subflow->mp_capable) {
+		subflow->tcp_data_ready(sk);
+
+		if (parent)
+			parent->sk_data_ready(parent);
+		return;
+	}
+
+	if (mptcp_subflow_data_available(sk)) {
+		set_bit(MPTCP_DATA_READY, &mptcp_sk(parent)->flags);
+
+		parent->sk_data_ready(parent);
+	}
+}
+
+static void subflow_write_space(struct sock *sk)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+	struct sock *parent = subflow->conn;
+
+	sk_stream_write_space(sk);
+	if (parent && sk_stream_is_writeable(sk)) {
+		sk_stream_write_space(parent);
+	}
+}
+
 static struct inet_connection_sock_af_ops *
 subflow_default_af_ops(struct sock *sk)
 {
@@ -296,6 +619,47 @@ static struct mptcp_subflow_context *subflow_create_ctx(struct sock *sk,
 	return ctx;
 }
 
+static void __subflow_state_change(struct sock *sk)
+{
+	struct socket_wq *wq;
+
+	rcu_read_lock();
+	wq = rcu_dereference(sk->sk_wq);
+	if (skwq_has_sleeper(wq))
+		wake_up_interruptible_all(&wq->wait);
+	rcu_read_unlock();
+}
+
+static bool subflow_is_done(const struct sock *sk)
+{
+	return sk->sk_shutdown & RCV_SHUTDOWN || sk->sk_state == TCP_CLOSE;
+}
+
+static void subflow_state_change(struct sock *sk)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+	struct sock *parent = READ_ONCE(subflow->conn);
+
+	__subflow_state_change(sk);
+
+	/* as recvmsg() does not acquire the subflow socket for ssk selection
+	 * a fin packet carrying a DSS can be unnoticed if we don't trigger
+	 * the data available machinery here.
+	 */
+	if (parent && subflow->mp_capable && mptcp_subflow_data_available(sk)) {
+		set_bit(MPTCP_DATA_READY, &mptcp_sk(parent)->flags);
+
+		parent->sk_data_ready(parent);
+	}
+
+	if (parent && !(parent->sk_shutdown & RCV_SHUTDOWN) &&
+	    !subflow->rx_eof && subflow_is_done(sk)) {
+		subflow->rx_eof = 1;
+		parent->sk_shutdown |= RCV_SHUTDOWN;
+		__subflow_state_change(parent);
+	}
+}
+
 static int subflow_ulp_init(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
@@ -322,6 +686,12 @@ static int subflow_ulp_init(struct sock *sk)
 	tp->is_mptcp = 1;
 	ctx->icsk_af_ops = icsk->icsk_af_ops;
 	icsk->icsk_af_ops = subflow_default_af_ops(sk);
+	ctx->tcp_data_ready = sk->sk_data_ready;
+	ctx->tcp_state_change = sk->sk_state_change;
+	ctx->tcp_write_space = sk->sk_write_space;
+	sk->sk_data_ready = subflow_data_ready;
+	sk->sk_write_space = subflow_write_space;
+	sk->sk_state_change = subflow_state_change;
 out:
 	return err;
 }
@@ -339,10 +709,12 @@ static void subflow_ulp_release(struct sock *sk)
 	kfree_rcu(ctx, rcu);
 }
 
-static void subflow_ulp_fallback(struct sock *sk)
+static void subflow_ulp_fallback(struct sock *sk,
+				 struct mptcp_subflow_context *old_ctx)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 
+	mptcp_subflow_tcp_fallback(sk, old_ctx);
 	icsk->icsk_ulp_ops = NULL;
 	rcu_assign_pointer(icsk->icsk_ulp_data, NULL);
 	tcp_sk(sk)->is_mptcp = 0;
@@ -357,23 +729,28 @@ static void subflow_ulp_clone(const struct request_sock *req,
 	struct mptcp_subflow_context *new_ctx;
 
 	if (!subflow_req->mp_capable) {
-		subflow_ulp_fallback(newsk);
+		subflow_ulp_fallback(newsk, old_ctx);
 		return;
 	}
 
 	new_ctx = subflow_create_ctx(newsk, priority);
 	if (new_ctx == NULL) {
-		subflow_ulp_fallback(newsk);
+		subflow_ulp_fallback(newsk, old_ctx);
 		return;
 	}
 
 	new_ctx->conn_finished = 1;
 	new_ctx->icsk_af_ops = old_ctx->icsk_af_ops;
+	new_ctx->tcp_data_ready = old_ctx->tcp_data_ready;
+	new_ctx->tcp_state_change = old_ctx->tcp_state_change;
+	new_ctx->tcp_write_space = old_ctx->tcp_write_space;
 	new_ctx->mp_capable = 1;
 	new_ctx->fourth_ack = 1;
 	new_ctx->remote_key = subflow_req->remote_key;
 	new_ctx->local_key = subflow_req->local_key;
 	new_ctx->token = subflow_req->token;
+	new_ctx->ssn_offset = subflow_req->ssn_offset;
+	new_ctx->idsn = subflow_req->idsn;
 }
 
 static struct tcp_ulp_ops subflow_ulp_ops __read_mostly = {
-- 
2.23.0

