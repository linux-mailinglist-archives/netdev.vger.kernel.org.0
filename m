Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36C19C94F7
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729252AbfJBXhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:37:48 -0400
Received: from mga04.intel.com ([192.55.52.120]:16472 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729145AbfJBXhk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:37:40 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:37:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366862622"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.30.230])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 16:37:23 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Peter Krystad <peter.krystad@linux.intel.com>, cpaasch@apple.com,
        fw@strlen.de, pabeni@redhat.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH v2 28/45] mptcp: Add handling of incoming MP_JOIN requests
Date:   Wed,  2 Oct 2019 16:36:38 -0700
Message-Id: <20191002233655.24323-29-mathew.j.martineau@linux.intel.com>
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

Process the MP_JOIN option in a SYN packet with the same flow
as MP_CAPABLE but when the third ACK is received add the
subflow to the MPTCP socket subflow list instead of adding it to
the TCP socket accept queue.

The subflow is added at the end of the subflow list so it will not
interfere with the existing subflows operation and no data is
expected to be transmitted on it.

Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
---
 include/linux/tcp.h      |   6 +++
 include/net/mptcp.h      |  11 ++++
 net/ipv4/tcp_minisocks.c |   6 +++
 net/mptcp/options.c      |  55 +++++++++++++++++++-
 net/mptcp/protocol.c     |  22 ++++++++
 net/mptcp/protocol.h     |  27 +++++++++-
 net/mptcp/subflow.c      | 105 ++++++++++++++++++++++++++++++++++++++-
 net/mptcp/token.c        |  22 ++++++++
 8 files changed, 249 insertions(+), 5 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index b3289e69cac1..3b69ab99e666 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -107,8 +107,14 @@ struct tcp_options_received {
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
index f4a9962ea85f..bb2dd193c0c5 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -36,6 +36,10 @@ struct mptcp_out_options {
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
@@ -74,6 +78,8 @@ static inline bool mptcp_skb_ext_exist(const struct sk_buff *skb)
 
 void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts);
 
+bool mptcp_sk_is_subflow(const struct sock *sk);
+
 #else
 
 static inline void mptcp_init(void)
@@ -132,5 +138,10 @@ static inline bool mptcp_skb_ext_exist(const struct sk_buff *skb)
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
index bb140a5db8c0..c519684d081b 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -767,6 +767,12 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
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
index 6fd2c8b5001c..f5e0b1d0931b 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -85,6 +85,38 @@ void mptcp_parse_option(const unsigned char *ptr, int opsize,
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
+			ptr += 2;
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
@@ -462,10 +494,21 @@ bool mptcp_synack_options(const struct request_sock *req, unsigned int *size,
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
@@ -569,6 +612,16 @@ void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
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
index 932362e6047e..32d9963c492d 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -805,6 +805,28 @@ void mptcp_finish_connect(struct sock *sk, int mp_capable)
 	inet_sk_state_store(sk, TCP_ESTABLISHED);
 }
 
+void mptcp_finish_join(struct sock *sk)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
+
+	pr_debug("msk=%p, subflow=%p", msk, subflow);
+
+	local_bh_disable();
+	bh_lock_sock_nested(subflow->conn);
+	list_add_tail(&subflow->node, &msk->conn_list);
+	bh_unlock_sock(subflow->conn);
+	local_bh_enable();
+	inet_sk_state_store(sk, TCP_ESTABLISHED);
+}
+
+bool mptcp_sk_is_subflow(const struct sock *sk)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+
+	return subflow->mp_join == 1;
+}
+
 static struct proto mptcp_prot = {
 	.name		= "MPTCP",
 	.owner		= THIS_MODULE,
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index fd21ed6c03b7..16fe1c766d98 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -15,6 +15,9 @@
 #define OPTION_MPTCP_MPC_SYN	BIT(0)
 #define OPTION_MPTCP_MPC_SYNACK	BIT(1)
 #define OPTION_MPTCP_MPC_ACK	BIT(2)
+#define OPTION_MPTCP_MPJ_SYN	BIT(3)
+#define OPTION_MPTCP_MPJ_SYNACK	BIT(4)
+#define OPTION_MPTCP_MPJ_ACK	BIT(5)
 #define OPTION_MPTCP_ADD_ADDR	BIT(6)
 #define OPTION_MPTCP_ADD_ADDR6	BIT(7)
 #define OPTION_MPTCP_RM_ADDR	BIT(8)
@@ -33,6 +36,9 @@
 #define TCPOLEN_MPTCP_MPC_SYN		12
 #define TCPOLEN_MPTCP_MPC_SYNACK	20
 #define TCPOLEN_MPTCP_MPC_ACK		20
+#define TCPOLEN_MPTCP_MPJ_SYN		12
+#define TCPOLEN_MPTCP_MPJ_SYNACK	16
+#define TCPOLEN_MPTCP_MPJ_ACK		24
 #define TCPOLEN_MPTCP_DSS_BASE		4
 #define TCPOLEN_MPTCP_DSS_ACK32		4
 #define TCPOLEN_MPTCP_DSS_ACK64		8
@@ -43,6 +49,9 @@
 #define TCPOLEN_MPTCP_ADD_ADDR6		20
 #define TCPOLEN_MPTCP_RM_ADDR		4
 
+#define MPTCPOPT_BACKUP		BIT(0)
+#define MPTCPOPT_HMAC_LEN	20
+
 /* MPTCP MP_CAPABLE flags */
 #define MPTCP_VERSION_MASK	(0x0F)
 #define MPTCP_CAP_CHECKSUM_REQD	BIT(7)
@@ -128,11 +137,15 @@ struct mptcp_subflow_request_sock {
 		backup : 1,
 		version : 4;
 	u8	local_id;
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
 
 static inline struct mptcp_subflow_request_sock *
@@ -156,14 +169,22 @@ struct mptcp_subflow_context {
 	u16	request_mptcp : 1,  /* send MP_CAPABLE */
 		request_cksum : 1,
 		request_version : 4,
-		mp_capable : 1,	    /* remote is MPTCP capable */
+		mp_capable : 1,     /* remote is MPTCP capable */
+		mp_join : 1,        /* remote is JOINing */
 		fourth_ack : 1,     /* send initial DSS */
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
 	struct	rcu_head rcu;
 };
@@ -192,12 +213,14 @@ void mptcp_get_options(const struct sk_buff *skb,
 		       struct tcp_options_received *opt_rx);
 
 void mptcp_finish_connect(struct sock *sk, int mp_capable);
+void mptcp_finish_join(struct sock *sk);
 
 int mptcp_token_new_request(struct request_sock *req);
 void mptcp_token_destroy_request(u32 token);
 int mptcp_token_new_connect(struct sock *sk);
 int mptcp_token_new_accept(u32 token);
 void mptcp_token_update_accept(struct sock *sk, struct sock *conn);
+struct mptcp_sock *mptcp_token_get_sock(u32 token);
 void mptcp_token_destroy(u32 token);
 
 void mptcp_crypto_key_sha1(u64 key, u32 *token, u64 *idsn);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 1cde27227fd9..1c3330ab2f30 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -9,6 +9,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <crypto/algapi.h>
 #include <net/sock.h>
 #include <net/inet_common.h>
 #include <net/inet_hashtables.h>
@@ -44,6 +45,38 @@ static void subflow_req_destructor(struct request_sock *req)
 	tcp_request_sock_ops.destructor(req);
 }
 
+/* validate received token and create truncated hmac and nonce for SYN-ACK */
+static bool subflow_token_join_request(struct request_sock *req,
+				       const struct sk_buff *skb)
+{
+	struct mptcp_subflow_request_sock *subflow_req = mptcp_subflow_rsk(req);
+	u8 hmac[MPTCPOPT_HMAC_LEN];
+	struct mptcp_sock *msk;
+
+	msk = mptcp_token_get_sock(subflow_req->token);
+	if (!msk) {
+		pr_debug("subflow_req=%p, token=%u - not found\n",
+			 subflow_req, subflow_req->token);
+		return false;
+	}
+
+	if (pm_get_local_id(req, (struct sock *)msk, skb)) {
+		sock_put((struct sock *)msk);
+		return false;
+	}
+
+	get_random_bytes(&subflow_req->local_nonce, sizeof(u32));
+
+	mptcp_crypto_hmac_sha1(msk->local_key, msk->remote_key,
+			       subflow_req->local_nonce,
+			       subflow_req->remote_nonce, (u32 *)hmac);
+
+	subflow_req->thmac = get_unaligned_be64(hmac);
+
+	sock_put((struct sock *)msk);
+	return true;
+}
+
 static void subflow_v4_init_req(struct request_sock *req,
 				const struct sock *sk_listener,
 				struct sk_buff *skb)
@@ -60,6 +93,12 @@ static void subflow_v4_init_req(struct request_sock *req,
 	memset(&rx_opt.mptcp, 0, sizeof(rx_opt.mptcp));
 	mptcp_get_options(skb, &rx_opt);
 
+	subflow_req->mp_capable = 0;
+	subflow_req->mp_join = 0;
+
+	if (rx_opt.mptcp.mp_capable && rx_opt.mptcp.mp_join)
+		return;
+
 	if (rx_opt.mptcp.mp_capable && listener->request_mptcp) {
 		int err;
 
@@ -76,8 +115,18 @@ static void subflow_v4_init_req(struct request_sock *req,
 			subflow_req->checksum = 1;
 		subflow_req->remote_key = rx_opt.mptcp.sndr_key;
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
+		if (!subflow_token_join_request(req, skb)) {
+			subflow_req->mp_join = 0;
+			// @@ need to trigger RST
+		}
 	}
 }
 
@@ -121,6 +170,32 @@ static int subflow_conn_request(struct sock *sk, struct sk_buff *skb)
 	return 0;
 }
 
+/* validate hmac received in third ACK */
+static bool subflow_hmac_valid(const struct request_sock *req,
+			       const struct tcp_options_received *rx_opt)
+{
+	const struct mptcp_subflow_request_sock *subflow_req;
+	u8 hmac[MPTCPOPT_HMAC_LEN];
+	struct mptcp_sock *msk;
+	bool ret;
+
+	subflow_req = mptcp_subflow_rsk(req);
+	msk = mptcp_token_get_sock(subflow_req->token);
+	if (!msk)
+		return false;
+
+	mptcp_crypto_hmac_sha1(msk->remote_key, msk->local_key,
+			       subflow_req->remote_nonce,
+			       subflow_req->local_nonce, (u32 *)hmac);
+
+	ret = true;
+	if (crypto_memneq(hmac, rx_opt->mptcp.hmac, sizeof(hmac)))
+		ret = false;
+
+	sock_put((struct sock *)msk);
+	return ret;
+}
+
 static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 					  struct sk_buff *skb,
 					  struct request_sock *req,
@@ -129,11 +204,21 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 					  bool *own_req)
 {
 	struct mptcp_subflow_context *listener = mptcp_subflow_ctx(sk);
+	struct mptcp_subflow_request_sock *subflow_req;
+	struct tcp_options_received opt_rx;
 	struct sock *child;
 
 	pr_debug("listener=%p, req=%p, conn=%p", listener, req, listener->conn);
 
 	/* if the sk is MP_CAPABLE, we already received the client key */
+	subflow_req = mptcp_subflow_rsk(req);
+	if (!subflow_req->mp_capable && subflow_req->mp_join) {
+		opt_rx.mptcp.mp_join = 0;
+		mptcp_get_options(skb, &opt_rx);
+		if (!opt_rx.mptcp.mp_join ||
+		    !subflow_hmac_valid(req, &opt_rx))
+			return NULL;
+	}
 
 	child = tcp_v4_syn_recv_sock(sk, skb, req, dst, req_unhash, own_req);
 
@@ -146,6 +231,15 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 		if (ctx->mp_capable) {
 			if (mptcp_token_new_accept(ctx->token))
 				goto close_child;
+		} else if (ctx->mp_join) {
+			struct mptcp_sock *owner;
+
+			owner = mptcp_token_get_sock(ctx->token);
+			if (!owner)
+				goto close_child;
+
+			ctx->conn = (struct sock *)owner;
+			mptcp_finish_join(child);
 		}
 	}
 
@@ -289,6 +383,13 @@ static void subflow_ulp_clone(const struct request_sock *req,
 		new_ctx->token = subflow_req->token;
 		new_ctx->ssn_offset = subflow_req->ssn_offset;
 		new_ctx->idsn = subflow_req->idsn;
+	} else if (subflow_req->mp_join) {
+		new_ctx->mp_join = 1;
+		new_ctx->fourth_ack = 1;
+		new_ctx->backup = subflow_req->backup;
+		new_ctx->local_id = subflow_req->local_id;
+		new_ctx->token = subflow_req->token;
+		new_ctx->thmac = subflow_req->thmac;
 	}
 }
 
diff --git a/net/mptcp/token.c b/net/mptcp/token.c
index 7e579deef6a2..a0d8f6e323b2 100644
--- a/net/mptcp/token.c
+++ b/net/mptcp/token.c
@@ -167,6 +167,28 @@ void mptcp_token_update_accept(struct sock *sk, struct sock *conn)
 	spin_unlock_bh(&token_tree_lock);
 }
 
+/**
+ * mptcp_token_get_sock - retrieve mptcp connection sock using its token
+ * @token - token of the mptcp connection to retrieve
+ *
+ * This function returns the mptcp connection structure with the given token.
+ * A reference count on the mptcp socket returned is taken.
+ *
+ * returns NULL if no connection with the given token value exists.
+ */
+struct mptcp_sock *mptcp_token_get_sock(u32 token)
+{
+	struct sock *conn;
+
+	spin_lock_bh(&token_tree_lock);
+	conn = radix_tree_lookup(&token_tree, token);
+	if (conn)
+		sock_hold(conn);
+	spin_unlock_bh(&token_tree_lock);
+
+	return mptcp_sk(conn);
+}
+
 /**
  * mptcp_token_destroy_request - remove mptcp connection/token
  * @token - token of mptcp connection to remove
-- 
2.23.0

