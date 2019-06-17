Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFBC49588
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbfFQW7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:59:04 -0400
Received: from mga18.intel.com ([134.134.136.126]:10998 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728807AbfFQW67 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 18:58:59 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 15:58:53 -0700
X-ExtLoop1: 1
Received: from mjmartin-nuc01.amr.corp.intel.com (HELO mjmartin-nuc01.sea.intel.com) ([10.241.98.42])
  by orsmga002.jf.intel.com with ESMTP; 17 Jun 2019 15:58:52 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     edumazet@google.com, netdev@vger.kernel.org
Cc:     Peter Krystad <peter.krystad@linux.intel.com>, cpaasch@apple.com,
        fw@strlen.de, pabeni@redhat.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH net-next 33/33] mptcp: Add handling of incoming MP_JOIN requests
Date:   Mon, 17 Jun 2019 15:58:08 -0700
Message-Id: <20190617225808.665-34-mathew.j.martineau@linux.intel.com>
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

Process the MP_JOIN option in a SYN packet with the same flow
as MP_CAPABLE but when the third ACK is received add the
subflow to the MPTCP socket subflow list instead of adding it to
the TCP socket accept queue.

The subflow is added at the end of the subflow list so it will not
interfere with the existing subflows operation and no data is
expected to be transmitted on it.

Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
---
 include/linux/tcp.h      |   6 ++
 include/net/mptcp.h      |  14 +++++
 net/ipv4/tcp_minisocks.c |   6 ++
 net/mptcp/options.c      |  58 ++++++++++++++++--
 net/mptcp/protocol.c     |  21 +++++++
 net/mptcp/protocol.h     |  29 ++++++++-
 net/mptcp/subflow.c      |  58 +++++++++++++++---
 net/mptcp/token.c        | 124 +++++++++++++++++++++++++++++++++++++++
 8 files changed, 301 insertions(+), 15 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index b1d2ff2af0c2..68ff73ce8ac2 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -112,8 +112,14 @@ struct tcp_options_received {
 		u8      mp_capable : 1,
 			mp_join : 1,
 			dss : 1,
+			backup : 1,
 			version : 4;
 		u8      flags;
+		u8      join_id;
+		u32     token;
+		u32     nonce;
+		u64     thmac;
+		u8      hmac[20];
 		u8	dss_flags;
 		u8	use_map:1,
 			dsn64:1,
diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 92c630a25666..68e674f453e4 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -28,6 +28,9 @@ struct mptcp_ext {
 #define OPTION_MPTCP_MPC_SYN		BIT(0)
 #define OPTION_MPTCP_MPC_SYNACK		BIT(1)
 #define OPTION_MPTCP_MPC_ACK		BIT(2)
+#define OPTION_MPTCP_MPJ_SYN		BIT(3)
+#define OPTION_MPTCP_MPJ_SYNACK		BIT(4)
+#define OPTION_MPTCP_MPJ_ACK		BIT(5)
 #define OPTION_MPTCP_ADD_ADDR		BIT(6)
 #define OPTION_MPTCP_ADD_ADDR6		BIT(7)
 #define OPTION_MPTCP_RM_ADDR		BIT(8)
@@ -44,6 +47,10 @@ struct mptcp_out_options {
 #endif
 	};
 	u8 addr_id;
+	u8 join_id;
+	u8 backup;
+	u32 nonce;
+	u64 thmac;
 	struct mptcp_ext ext_copy;
 #endif
 };
@@ -83,6 +90,8 @@ static inline bool mptcp_skb_ext_exist(const struct sk_buff *skb)
 
 void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts);
 
+bool mptcp_sk_is_subflow(const struct sock *sk);
+
 #else
 
 static inline void mptcp_init(void)
@@ -140,5 +149,10 @@ static inline bool mptcp_skb_ext_exist(const struct sk_buff *skb)
 	return false;
 }
 
+static inline bool mptcp_sk_is_subflow(const struct sock *sk)
+{
+	return false;
+}
+
 #endif /* CONFIG_MPTCP */
 #endif /* __NET_MPTCP_H */
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 8bcaf2586b68..081b410592b3 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -766,6 +766,12 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 	if (!child)
 		goto listen_overflow;
 
+	if (own_req && sk_is_mptcp(child) && mptcp_sk_is_subflow(child)) {
+		inet_csk_reqsk_queue_drop(sk, req);
+		reqsk_queue_removed(&inet_csk(sk)->icsk_accept_queue, req);
+		return child;
+	}
+
 	sock_rps_save_rxhash(child, skb);
 	tcp_synack_rtt_meas(child, req);
 	*req_stolen = !own_req;
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 68d0b4bec1dd..58215f19829a 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -54,24 +54,53 @@ void mptcp_parse_option(const unsigned char *ptr, int opsize,
 		break;
 
 	/* MPTCPOPT_MP_JOIN
-	 *
 	 * Initial SYN
 	 * 0: 4MSB=subtype, 000, 1LSB=Backup
 	 * 1: Address ID
 	 * 2-5: Receiver token
 	 * 6-9: Sender random number
-	 *
 	 * SYN/ACK response
 	 * 0: 4MSB=subtype, 000, 1LSB=Backup
 	 * 1: Address ID
 	 * 2-9: Sender truncated HMAC
 	 * 10-13: Sender random number
-	 *
 	 * Third ACK
 	 * 0: 4MSB=subtype, 0000
 	 * 1: 0 (Reserved)
 	 * 2-21: Sender HMAC
 	 */
+	case MPTCPOPT_MP_JOIN:
+		mp_opt->mp_join = 1;
+		if (opsize == TCPOLEN_MPTCP_MPJ_SYN) {
+			mp_opt->backup = *ptr++ & MPTCPOPT_BACKUP;
+			mp_opt->join_id = *ptr++;
+			mp_opt->token = get_unaligned_be32(ptr);
+			ptr += 4;
+			mp_opt->nonce = get_unaligned_be32(ptr);
+			ptr += 4;
+			pr_debug("MP_JOIN bkup=%u, id=%u, token=%u, nonce=%u",
+				 mp_opt->backup, mp_opt->join_id,
+				 mp_opt->token, mp_opt->nonce);
+		} else if (opsize == TCPOLEN_MPTCP_MPJ_SYNACK) {
+			mp_opt->backup = *ptr++ & MPTCPOPT_BACKUP;
+			mp_opt->join_id = *ptr++;
+			mp_opt->thmac = get_unaligned_be64(ptr);
+			ptr += 8;
+			mp_opt->nonce = get_unaligned_be32(ptr);
+			ptr += 4;
+			pr_debug("MP_JOIN bkup=%u, id=%u, thmac=%llu, nonce=%u",
+				 mp_opt->backup, mp_opt->join_id,
+				 mp_opt->thmac, mp_opt->nonce);
+		} else if (opsize == TCPOLEN_MPTCP_MPJ_ACK) {
+			ptr++;
+			memcpy(mp_opt->hmac, ptr, MPTCPOPT_HMAC_LEN);
+			pr_debug("MP_JOIN hmac");
+		} else {
+			pr_warn("MP_JOIN bad option size");
+			mp_opt->mp_join = 0;
+		}
+		break;
+
 
 	/* MPTCPOPT_DSS
 	 * 0: 4MSB=subtype, 0000
@@ -428,10 +457,21 @@ bool mptcp_synack_options(const struct request_sock *req, unsigned int *size,
 		opts->sndr_key = subflow_req->local_key;
 		opts->rcvr_key = subflow_req->remote_key;
 		*size = TCPOLEN_MPTCP_MPC_SYNACK;
-		pr_debug("subflow_req=%p, local_key=%llu, remote_key=%llu",
+		pr_debug("req=%p, local_key=%llu, remote_key=%llu",
 			 subflow_req, subflow_req->local_key,
 			 subflow_req->remote_key);
 		return true;
+	} else if (subflow_req->mp_join) {
+		opts->suboptions = OPTION_MPTCP_MPJ_SYNACK;
+		opts->backup = subflow_req->backup;
+		opts->join_id = subflow_req->local_id;
+		opts->thmac = subflow_req->thmac;
+		opts->nonce = subflow_req->local_nonce;
+		pr_debug("req=%p, bkup=%u, id=%u, thmac=%llu, nonce=%u",
+			 subflow_req, opts->backup, opts->join_id,
+			 opts->thmac, opts->nonce);
+		*size = TCPOLEN_MPTCP_MPJ_SYNACK;
+		return true;
 	}
 	return false;
 }
@@ -518,6 +558,16 @@ void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
 				      0, opts->addr_id);
 	}
 
+	if (OPTION_MPTCP_MPJ_SYNACK & opts->suboptions) {
+		*ptr++ = mptcp_option(MPTCPOPT_MP_JOIN,
+				      TCPOLEN_MPTCP_MPJ_SYNACK,
+				      opts->backup, opts->join_id);
+		put_unaligned_be64(opts->thmac, ptr);
+		ptr += 2;
+		put_unaligned_be32(opts->nonce, ptr);
+		ptr += 1;
+	}
+
 	if (opts->ext_copy.use_ack || opts->ext_copy.use_map) {
 		struct mptcp_ext *mpext = &opts->ext_copy;
 		u8 len = TCPOLEN_MPTCP_DSS_BASE;
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index e071fc8191ee..042811a1e01b 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -777,6 +777,27 @@ void mptcp_finish_connect(struct sock *sk, int mp_capable)
 	inet_sk_state_store(sk, TCP_ESTABLISHED);
 }
 
+void mptcp_finish_join(struct sock *conn, struct sock *sk)
+{
+	struct subflow_context *subflow = subflow_ctx(sk);
+	struct mptcp_sock *msk = mptcp_sk(conn);
+
+	pr_debug("msk=%p, subflow=%p", msk, subflow);
+
+	local_bh_disable();
+	bh_lock_sock_nested(sk);
+	list_add_tail(&subflow->node, &msk->conn_list);
+	bh_unlock_sock(sk);
+	local_bh_enable();
+}
+
+bool mptcp_sk_is_subflow(const struct sock *sk)
+{
+	struct subflow_context *subflow = subflow_ctx(sk);
+
+	return subflow->mp_join == 1;
+}
+
 static struct proto mptcp_prot = {
 	.name		= "MPTCP",
 	.owner		= THIS_MODULE,
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 4e4c8fc59972..61e9f15de9d6 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -24,6 +24,9 @@
 #define TCPOLEN_MPTCP_MPC_SYN		12
 #define TCPOLEN_MPTCP_MPC_SYNACK	20
 #define TCPOLEN_MPTCP_MPC_ACK		20
+#define TCPOLEN_MPTCP_MPJ_SYN		12
+#define TCPOLEN_MPTCP_MPJ_SYNACK	16
+#define TCPOLEN_MPTCP_MPJ_ACK		24
 #define TCPOLEN_MPTCP_DSS_BASE		4
 #define TCPOLEN_MPTCP_DSS_ACK32		4
 #define TCPOLEN_MPTCP_DSS_ACK64		8
@@ -34,6 +37,9 @@
 #define TCPOLEN_MPTCP_ADD_ADDR6		20
 #define TCPOLEN_MPTCP_RM_ADDR		4
 
+#define MPTCPOPT_BACKUP		BIT(0)
+#define MPTCPOPT_HMAC_LEN	20
+
 /* MPTCP MP_CAPABLE flags */
 #define MPTCP_VERSION_MASK	(0x0F)
 #define MPTCP_CAP_CHECKSUM_REQD	BIT(7)
@@ -101,11 +107,16 @@ struct subflow_request_sock {
 		checksum : 1,
 		backup : 1,
 		version : 4;
+	u8	local_id;
+	u8	remote_id;
 	u64	local_key;
 	u64	remote_key;
 	u64	idsn;
 	u32	token;
 	u32	ssn_offset;
+	u64	thmac;
+	u32	local_nonce;
+	u32	remote_nonce;
 };
 
 static inline
@@ -128,15 +139,23 @@ struct subflow_context {
 	u16	map_data_len;
 	u16	request_mptcp : 1,  /* send MP_CAPABLE */
 		request_cksum : 1,
-		mp_capable : 1,	    /* remote is MPTCP capable */
+		mp_capable : 1,     /* remote is MPTCP capable */
+		mp_join : 1,        /* remote is JOINing */
 		fourth_ack : 1,     /* send initial DSS */
 		version : 4,
 		conn_finished : 1,
 		use_checksum : 1,
-		map_valid : 1;
+		map_valid : 1,
+		backup : 1;
+	u32	remote_nonce;
+	u64	thmac;
+	u32	local_nonce;
+	u8	local_id;
+	u8	remote_id;
 
 	struct  socket *tcp_sock;  /* underlying tcp_sock */
 	struct  sock *conn;        /* parent mptcp_sock */
+
 	void	(*tcp_sk_data_ready)(struct sock *sk);
 };
 
@@ -161,13 +180,19 @@ void mptcp_get_options(const struct sk_buff *skb,
 		       struct tcp_options_received *opt_rx);
 
 void mptcp_finish_connect(struct sock *sk, int mp_capable);
+void mptcp_finish_join(struct sock *conn, struct sock *sk);
 
 void token_init(void);
 void token_new_request(struct request_sock *req, const struct sk_buff *skb);
+int token_join_request(struct request_sock *req, const struct sk_buff *skb);
+int token_join_valid(struct request_sock *req,
+		     struct tcp_options_received *rx_opt);
 void token_destroy_request(u32 token);
 void token_new_connect(struct sock *sk);
 void token_new_accept(struct sock *sk);
+int token_new_join(struct sock *sk);
 void token_update_accept(struct sock *sk, struct sock *conn);
+void token_release(u32 token);
 void token_destroy(u32 token);
 
 void crypto_init(void);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index a82f5091eed8..a858cc966724 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -54,6 +54,12 @@ static void subflow_v4_init_req(struct request_sock *req,
 	memset(&rx_opt.mptcp, 0, sizeof(rx_opt.mptcp));
 	mptcp_get_options(skb, &rx_opt);
 
+	subflow_req->mp_capable = 0;
+	subflow_req->mp_join = 0;
+
+	if (rx_opt.mptcp.mp_capable && rx_opt.mptcp.mp_join)
+		return;
+
 	if (rx_opt.mptcp.mp_capable && listener->request_mptcp) {
 		subflow_req->mp_capable = 1;
 		if (rx_opt.mptcp.version >= listener->version)
@@ -68,8 +74,18 @@ static void subflow_v4_init_req(struct request_sock *req,
 		token_new_request(req, skb);
 		pr_debug("syn seq=%u", TCP_SKB_CB(skb)->seq);
 		subflow_req->ssn_offset = TCP_SKB_CB(skb)->seq;
-	} else {
-		subflow_req->mp_capable = 0;
+	} else if (rx_opt.mptcp.mp_join && listener->request_mptcp) {
+		subflow_req->mp_join = 1;
+		subflow_req->backup = rx_opt.mptcp.backup;
+		subflow_req->remote_id = rx_opt.mptcp.join_id;
+		subflow_req->token = rx_opt.mptcp.token;
+		subflow_req->remote_nonce = rx_opt.mptcp.nonce;
+		pr_debug("token=%u, remote_nonce=%u", subflow_req->token,
+			 subflow_req->remote_nonce);
+		if (token_join_request(req, skb)) {
+			subflow_req->mp_join = 0;
+			// @@ need to trigger RST
+		}
 	}
 }
 
@@ -134,6 +150,11 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 		    subflow_req->local_key != opt_rx.mptcp.rcvr_key ||
 		    subflow_req->remote_key != opt_rx.mptcp.sndr_key)
 			return NULL;
+	} else if (subflow_req->mp_join) {
+		opt_rx.mptcp.mp_join = 0;
+		mptcp_get_options(skb, &opt_rx);
+		if (!opt_rx.mptcp.mp_join || token_join_valid(req, &opt_rx))
+			return NULL;
 	}
 
 	child = tcp_v4_syn_recv_sock(sk, skb, req, dst, req_unhash, own_req);
@@ -141,18 +162,27 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 	if (child && *own_req) {
 		struct subflow_context *ctx = subflow_ctx(child);
 
-		if (!ctx) {
-			pr_debug("Closing child socket");
-			inet_sk_set_state(child, TCP_CLOSE);
-			sock_set_flag(child, SOCK_DEAD);
-			inet_csk_destroy_sock(child);
-			child = NULL;
-		} else if (ctx->mp_capable) {
+		if (!ctx)
+			goto close_child;
+
+		if (ctx->mp_capable) {
 			token_new_accept(child);
+		} else if (ctx->mp_join) {
+			if (token_new_join(child))
+				goto close_child;
+			else
+				mptcp_finish_join(ctx->conn, child);
 		}
 	}
 
 	return child;
+
+close_child:
+	pr_debug("closing child socket");
+	inet_sk_set_state(child, TCP_CLOSE);
+	sock_set_flag(child, SOCK_DEAD);
+	inet_csk_destroy_sock(child);
+	return NULL;
 }
 
 static struct inet_connection_sock_af_ops subflow_specific;
@@ -222,6 +252,8 @@ static void subflow_ulp_release(struct sock *sk)
 
 	pr_debug("subflow=%p", ctx);
 
+	token_release(ctx->token);
+
 	kfree(ctx);
 }
 
@@ -255,6 +287,14 @@ static void subflow_ulp_clone(const struct request_sock *req,
 		new_ctx->ssn_offset = subflow_req->ssn_offset;
 		new_ctx->idsn = subflow_req->idsn;
 		pr_debug("token=%u", new_ctx->token);
+	} else if (subflow_req->mp_join) {
+		new_ctx->mp_join = 1;
+		new_ctx->fourth_ack = 1;
+		new_ctx->backup = subflow_req->backup;
+		new_ctx->local_id = subflow_req->local_id;
+		new_ctx->token = subflow_req->token;
+		new_ctx->thmac = subflow_req->thmac;
+		pr_debug("token=%u", new_ctx->token);
 	}
 }
 
diff --git a/net/mptcp/token.c b/net/mptcp/token.c
index b055a3e82add..c2f4fcb37566 100644
--- a/net/mptcp/token.c
+++ b/net/mptcp/token.c
@@ -54,6 +54,15 @@ static bool find_token(u32 token)
 	return used;
 }
 
+static struct sock *lookup_token(u32 token)
+{
+	void *conn;
+
+	pr_debug("token=%u", token);
+	conn = radix_tree_lookup(&token_tree, token);
+	return (struct sock *)conn;
+}
+
 static void new_req_token(struct request_sock *req,
 			  const struct sk_buff *skb)
 {
@@ -81,6 +90,56 @@ static void new_req_token(struct request_sock *req,
 		 subflow_req->token, subflow_req->idsn);
 }
 
+static void new_req_join(struct request_sock *req, struct sock *sk,
+			 const struct sk_buff *skb)
+{
+	const struct inet_request_sock *ireq = inet_rsk(req);
+	struct subflow_request_sock *subflow_req = subflow_rsk(req);
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	u8 hmac[MPTCPOPT_HMAC_LEN];
+	u32 nonce;
+
+	if (skb->protocol == htons(ETH_P_IP)) {
+		nonce = crypto_v4_get_nonce(ip_hdr(skb)->saddr,
+					    ip_hdr(skb)->daddr,
+					    htons(ireq->ir_num),
+					    ireq->ir_rmt_port);
+#if IS_ENABLED(CONFIG_IPV6)
+	} else {
+		nonce = crypto_v6_get_nonce(&ipv6_hdr(skb)->saddr,
+					    &ipv6_hdr(skb)->daddr,
+					    htons(ireq->ir_num),
+					    ireq->ir_rmt_port);
+#endif
+	}
+	subflow_req->local_nonce = nonce;
+
+	crypto_hmac_sha1(msk->local_key,
+			 msk->remote_key,
+			 (u32 *)hmac, 2,
+			 4, (u8 *)&subflow_req->local_nonce,
+			 4, (u8 *)&subflow_req->remote_nonce);
+	subflow_req->thmac = *(u64 *)hmac;
+	pr_debug("local_nonce=%u, thmac=%llu", subflow_req->local_nonce,
+		 subflow_req->thmac);
+}
+
+static int new_join_valid(struct request_sock *req, struct sock *sk,
+			  struct tcp_options_received *rx_opt)
+{
+	struct subflow_request_sock *subflow_req = subflow_rsk(req);
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	u8 hmac[MPTCPOPT_HMAC_LEN];
+
+	crypto_hmac_sha1(msk->remote_key,
+			 msk->local_key,
+			 (u32 *)hmac, 2,
+			 4, (u8 *)&subflow_req->remote_nonce,
+			 4, (u8 *)&subflow_req->local_nonce);
+
+	return memcmp(hmac, (char *)rx_opt->mptcp.hmac, MPTCPOPT_HMAC_LEN);
+}
+
 static void new_token(const struct sock *sk)
 {
 	struct subflow_context *subflow = subflow_ctx(sk);
@@ -177,6 +236,42 @@ void token_new_request(struct request_sock *req,
 	spin_unlock_bh(&token_tree_lock);
 }
 
+/* validate received token and create truncated hmac and nonce for SYN-ACK */
+int token_join_request(struct request_sock *req, const struct sk_buff *skb)
+{
+	struct subflow_request_sock *subflow_req = subflow_rsk(req);
+	struct sock *conn;
+
+	pr_debug("subflow_req=%p, token=%u", subflow_req, subflow_req->token);
+	spin_lock_bh(&token_tree_lock);
+	conn = lookup_token(subflow_req->token);
+	spin_unlock_bh(&token_tree_lock);
+	if (conn) {
+		// @@ get real local address id for this skb->saddr
+		subflow_req->local_id = 0;
+		new_req_join(req, conn, skb);
+		return 0;
+	}
+	return -1;
+}
+
+/* validate hmac received in third ACK */
+int token_join_valid(struct request_sock *req,
+		     struct tcp_options_received *rx_opt)
+{
+	struct subflow_request_sock *subflow_req = subflow_rsk(req);
+	struct sock *conn;
+
+	pr_debug("subflow_req=%p, token=%u", subflow_req, subflow_req->token);
+	spin_lock_bh(&token_tree_lock);
+	conn = lookup_token(subflow_req->token);
+	spin_unlock_bh(&token_tree_lock);
+	if (conn)
+		return new_join_valid(req, conn, rx_opt);
+
+	return -1;
+}
+
 /* create new local key, idsn, and token for subflow */
 void token_new_connect(struct sock *sk)
 {
@@ -220,6 +315,23 @@ void token_update_accept(struct sock *sk, struct sock *conn)
 	spin_unlock_bh(&token_tree_lock);
 }
 
+int token_new_join(struct sock *sk)
+{
+	struct subflow_context *subflow = subflow_ctx(sk);
+	struct sock *conn;
+
+	spin_lock_bh(&token_tree_lock);
+	conn = lookup_token(subflow->token);
+	if (conn) {
+		sock_hold(conn);
+		spin_unlock_bh(&token_tree_lock);
+		subflow->conn = conn;
+		return 0;
+	}
+	spin_unlock_bh(&token_tree_lock);
+	return -1;
+}
+
 void token_destroy_request(u32 token)
 {
 	pr_debug("token=%u", token);
@@ -229,6 +341,18 @@ void token_destroy_request(u32 token)
 	spin_unlock_bh(&token_tree_lock);
 }
 
+void token_release(u32 token)
+{
+	struct sock *conn;
+
+	pr_debug("token=%u", token);
+	spin_lock_bh(&token_tree_lock);
+	conn = lookup_token(token);
+	if (conn)
+		sock_put(conn);
+	spin_unlock_bh(&token_tree_lock);
+}
+
 void token_destroy(u32 token)
 {
 	struct sock *conn;
-- 
2.22.0

