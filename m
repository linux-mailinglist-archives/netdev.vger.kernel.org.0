Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 386C7190052
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 22:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgCWV3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 17:29:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:60323 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727067AbgCWV3f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 17:29:35 -0400
IronPort-SDR: Hk7D2pqujQxwTUzxGxiu7eoW2+Cb1feacVu0cUTcu819so5f9NcszjeV5OaXs0ACSarQFJqAro
 7TmnWB5hORcw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2020 14:29:33 -0700
IronPort-SDR: OXV3uLtK7TvDrjgfcfwzTV6SE1lMh9YjbUFsXxl6Qmaeqs0lkMnt2D5nYlOlQn7JJ73XPzCCZ8
 InOizoNp6F2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,297,1580803200"; 
   d="scan'208";a="445960398"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.254.100.76])
  by fmsmga005.fm.intel.com with ESMTP; 23 Mar 2020 14:29:33 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Peter Krystad <peter.krystad@linux.intel.com>,
        eric.dumazet@gmail.com, Florian Westphal <fw@strlen.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 03/17] mptcp: Add handling of incoming MP_JOIN requests
Date:   Mon, 23 Mar 2020 14:26:28 -0700
Message-Id: <20200323212642.34104-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200323212642.34104-1-mathew.j.martineau@linux.intel.com>
References: <20200323212642.34104-1-mathew.j.martineau@linux.intel.com>
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

Co-developed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/linux/tcp.h      |   8 +-
 include/net/mptcp.h      |  11 +++
 net/ipv4/tcp_minisocks.c |   6 ++
 net/mptcp/options.c      | 107 +++++++++++++++++++++++---
 net/mptcp/protocol.c     |  96 +++++++++++++++++++-----
 net/mptcp/protocol.h     |  23 ++++++
 net/mptcp/subflow.c      | 158 +++++++++++++++++++++++++++++++++++----
 net/mptcp/token.c        |  27 +++++++
 8 files changed, 390 insertions(+), 46 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 1225db308957..421c99c12291 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -92,7 +92,13 @@ struct mptcp_options_received {
 		add_addr : 1,
 		rm_addr : 1,
 		family : 4,
-		echo : 1;
+		echo : 1,
+		backup : 1;
+	u32	token;
+	u32	nonce;
+	u64	thmac;
+	u8	hmac[20];
+	u8	join_id;
 	u8	use_map:1,
 		dsn64:1,
 		data_fin:1,
diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 0d5ea71dd3d0..a4aea0e4addc 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -42,6 +42,10 @@ struct mptcp_out_options {
 	u8 addr_id;
 	u64 ahmac;
 	u8 rm_id;
+	u8 join_id;
+	u8 backup;
+	u32 nonce;
+	u64 thmac;
 	struct mptcp_ext ext_copy;
 #endif
 };
@@ -115,6 +119,8 @@ static inline bool mptcp_skb_can_collapse(const struct sk_buff *to,
 				 skb_ext_find(from, SKB_EXT_MPTCP));
 }
 
+bool mptcp_sk_is_subflow(const struct sock *sk);
+
 #else
 
 static inline void mptcp_init(void)
@@ -181,6 +187,11 @@ static inline bool mptcp_skb_can_collapse(const struct sk_buff *to,
 	return true;
 }
 
+static inline bool mptcp_sk_is_subflow(const struct sock *sk)
+{
+	return false;
+}
+
 #endif /* CONFIG_MPTCP */
 
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 03af7c3e75ef..7e40322cc5ec 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -774,6 +774,12 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 	if (!child)
 		goto listen_overflow;
 
+	if (own_req && sk_is_mptcp(child) && mptcp_sk_is_subflow(child)) {
+		reqsk_queue_removed(&inet_csk(sk)->icsk_accept_queue, req);
+		inet_csk_reqsk_queue_drop_and_put(sk, req);
+		return child;
+	}
+
 	sock_rps_save_rxhash(child, skb);
 	tcp_synack_rtt_meas(child, req);
 	*req_stolen = !own_req;
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index a3661318a7af..8e2b2dbadf6d 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -96,6 +96,38 @@ void mptcp_parse_option(const struct sk_buff *skb, const unsigned char *ptr,
 			 mp_opt->rcvr_key, mp_opt->data_len);
 		break;
 
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
 	case MPTCPOPT_DSS:
 		pr_debug("DSS");
 		ptr++;
@@ -572,37 +604,80 @@ bool mptcp_synack_options(const struct request_sock *req, unsigned int *size,
 		pr_debug("subflow_req=%p, local_key=%llu",
 			 subflow_req, subflow_req->local_key);
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
 
-static bool check_fully_established(struct mptcp_subflow_context *subflow,
+static bool check_fully_established(struct mptcp_sock *msk, struct sock *sk,
+				    struct mptcp_subflow_context *subflow,
 				    struct sk_buff *skb,
 				    struct mptcp_options_received *mp_opt)
 {
 	/* here we can process OoO, in-window pkts, only in-sequence 4th ack
-	 * are relevant
+	 * will make the subflow fully established
 	 */
-	if (likely(subflow->fully_established ||
-		   TCP_SKB_CB(skb)->seq != subflow->ssn_offset + 1))
-		return true;
+	if (likely(subflow->fully_established)) {
+		/* on passive sockets, check for 3rd ack retransmission
+		 * note that msk is always set by subflow_syn_recv_sock()
+		 * for mp_join subflows
+		 */
+		if (TCP_SKB_CB(skb)->seq == subflow->ssn_offset + 1 &&
+		    TCP_SKB_CB(skb)->end_seq == TCP_SKB_CB(skb)->seq &&
+		    subflow->mp_join && mp_opt->mp_join &&
+		    READ_ONCE(msk->pm.server_side))
+			tcp_send_ack(sk);
+		goto fully_established;
+	}
+
+	/* we should process OoO packets before the first subflow is fully
+	 * established, but not expected for MP_JOIN subflows
+	 */
+	if (TCP_SKB_CB(skb)->seq != subflow->ssn_offset + 1)
+		return subflow->mp_capable;
 
-	if (mp_opt->use_ack)
+	if (mp_opt->use_ack) {
+		/* subflows are fully established as soon as we get any
+		 * additional ack.
+		 */
 		subflow->fully_established = 1;
+		goto fully_established;
+	}
 
-	if (subflow->can_ack)
-		return true;
+	WARN_ON_ONCE(subflow->can_ack);
 
 	/* If the first established packet does not contain MP_CAPABLE + data
 	 * then fallback to TCP
 	 */
 	if (!mp_opt->mp_capable) {
 		subflow->mp_capable = 0;
-		tcp_sk(mptcp_subflow_tcp_sock(subflow))->is_mptcp = 0;
+		tcp_sk(sk)->is_mptcp = 0;
 		return false;
 	}
+
+	subflow->fully_established = 1;
 	subflow->remote_key = mp_opt->sndr_key;
 	subflow->can_ack = 1;
+
+fully_established:
+	if (likely(subflow->pm_notified))
+		return true;
+
+	subflow->pm_notified = 1;
+	if (subflow->mp_join)
+		mptcp_pm_subflow_established(msk, subflow);
+	else
+		mptcp_pm_fully_established(msk);
 	return true;
 }
 
@@ -641,7 +716,7 @@ void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb,
 	struct mptcp_ext *mpext;
 
 	mp_opt = &opt_rx->mptcp;
-	if (!check_fully_established(subflow, skb, mp_opt))
+	if (!check_fully_established(msk, sk, subflow, skb, mp_opt))
 		return;
 
 	if (mp_opt->add_addr && add_addr_hmac_valid(msk, mp_opt)) {
@@ -700,8 +775,6 @@ void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb,
 	}
 
 	mpext->data_fin = mp_opt->data_fin;
-
-	mptcp_pm_fully_established(msk);
 }
 
 void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
@@ -787,6 +860,16 @@ void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
 				      0, opts->rm_id);
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
index 4479ef04cfa7..a9a7fac6fb5a 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -104,19 +104,6 @@ static struct socket *__mptcp_socket_create(struct mptcp_sock *msk, int state)
 	return ssock;
 }
 
-static struct sock *mptcp_subflow_get(const struct mptcp_sock *msk)
-{
-	struct mptcp_subflow_context *subflow;
-
-	sock_owned_by_me((const struct sock *)msk);
-
-	mptcp_for_each_subflow(msk, subflow) {
-		return mptcp_subflow_tcp_sock(subflow);
-	}
-
-	return NULL;
-}
-
 static void __mptcp_move_skb(struct mptcp_sock *msk, struct sock *ssk,
 			     struct sk_buff *skb,
 			     unsigned int offset, size_t copy_len)
@@ -391,6 +378,43 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	return ret;
 }
 
+static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk)
+{
+	struct mptcp_subflow_context *subflow;
+	struct sock *backup = NULL;
+
+	sock_owned_by_me((const struct sock *)msk);
+
+	mptcp_for_each_subflow(msk, subflow) {
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+
+		if (!sk_stream_memory_free(ssk)) {
+			struct socket *sock = ssk->sk_socket;
+
+			if (sock) {
+				clear_bit(MPTCP_SEND_SPACE, &msk->flags);
+				smp_mb__after_atomic();
+
+				/* enables sk->write_space() callbacks */
+				set_bit(SOCK_NOSPACE, &sock->flags);
+			}
+
+			return NULL;
+		}
+
+		if (subflow->backup) {
+			if (!backup)
+				backup = ssk;
+
+			continue;
+		}
+
+		return ssk;
+	}
+
+	return backup;
+}
+
 static void ssk_check_wmem(struct mptcp_sock *msk, struct sock *ssk)
 {
 	struct socket *sock;
@@ -438,10 +462,17 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		return ret >= 0 ? ret + copied : (copied ? copied : ret);
 	}
 
-	ssk = mptcp_subflow_get(msk);
-	if (!ssk) {
-		release_sock(sk);
-		return -ENOTCONN;
+	ssk = mptcp_subflow_get_send(msk);
+	while (!sk_stream_memory_free(sk) || !ssk) {
+		ret = sk_stream_wait_memory(sk, &timeo);
+		if (ret)
+			goto out;
+
+		ssk = mptcp_subflow_get_send(msk);
+		if (list_empty(&msk->conn_list)) {
+			ret = -ENOTCONN;
+			goto out;
+		}
 	}
 
 	pr_debug("conn_list->subflow=%p", ssk);
@@ -1074,6 +1105,37 @@ static void mptcp_sock_graft(struct sock *sk, struct socket *parent)
 	write_unlock_bh(&sk->sk_callback_lock);
 }
 
+bool mptcp_finish_join(struct sock *sk)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
+	struct sock *parent = (void *)msk;
+	struct socket *parent_sock;
+
+	pr_debug("msk=%p, subflow=%p", msk, subflow);
+
+	/* mptcp socket already closing? */
+	if (inet_sk_state_load(parent) != TCP_ESTABLISHED)
+		return false;
+
+	if (!msk->pm.server_side)
+		return true;
+
+	/* passive connection, attach to msk socket */
+	parent_sock = READ_ONCE(parent->sk_socket);
+	if (parent_sock && !sk->sk_socket)
+		mptcp_sock_graft(sk, parent_sock);
+
+	return mptcp_pm_allow_new_subflow(msk);
+}
+
+bool mptcp_sk_is_subflow(const struct sock *sk)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+
+	return subflow->mp_join == 1;
+}
+
 static bool mptcp_memory_free(const struct sock *sk, int wake)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 8d4761ae3951..ef94e36b8560 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -17,6 +17,9 @@
 #define OPTION_MPTCP_MPC_SYN	BIT(0)
 #define OPTION_MPTCP_MPC_SYNACK	BIT(1)
 #define OPTION_MPTCP_MPC_ACK	BIT(2)
+#define OPTION_MPTCP_MPJ_SYN	BIT(3)
+#define OPTION_MPTCP_MPJ_SYNACK	BIT(4)
+#define OPTION_MPTCP_MPJ_ACK	BIT(5)
 #define OPTION_MPTCP_ADD_ADDR	BIT(6)
 #define OPTION_MPTCP_ADD_ADDR6	BIT(7)
 #define OPTION_MPTCP_RM_ADDR	BIT(8)
@@ -36,6 +39,9 @@
 #define TCPOLEN_MPTCP_MPC_SYNACK	12
 #define TCPOLEN_MPTCP_MPC_ACK		20
 #define TCPOLEN_MPTCP_MPC_ACK_DATA	22
+#define TCPOLEN_MPTCP_MPJ_SYN		12
+#define TCPOLEN_MPTCP_MPJ_SYNACK	16
+#define TCPOLEN_MPTCP_MPJ_ACK		24
 #define TCPOLEN_MPTCP_DSS_BASE		4
 #define TCPOLEN_MPTCP_DSS_ACK32		4
 #define TCPOLEN_MPTCP_DSS_ACK64		8
@@ -53,6 +59,9 @@
 #define TCPOLEN_MPTCP_PORT_LEN		2
 #define TCPOLEN_MPTCP_RM_ADDR_BASE	4
 
+#define MPTCPOPT_BACKUP		BIT(0)
+#define MPTCPOPT_HMAC_LEN	20
+
 /* MPTCP MP_CAPABLE flags */
 #define MPTCP_VERSION_MASK	(0x0F)
 #define MPTCP_CAP_CHECKSUM_REQD	BIT(7)
@@ -162,11 +171,15 @@ struct mptcp_subflow_request_sock {
 		backup : 1,
 		remote_key_valid : 1;
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
@@ -190,15 +203,23 @@ struct mptcp_subflow_context {
 	u32	map_data_len;
 	u32	request_mptcp : 1,  /* send MP_CAPABLE */
 		mp_capable : 1,	    /* remote is MPTCP capable */
+		mp_join : 1,	    /* remote is JOINing */
 		fully_established : 1,	    /* path validated */
+		pm_notified : 1,    /* PM hook called for established status */
 		conn_finished : 1,
 		map_valid : 1,
 		mpc_map : 1,
+		backup : 1,
 		data_avail : 1,
 		rx_eof : 1,
 		data_fin_tx_enable : 1,
 		can_ack : 1;	    /* only after processing the remote a key */
 	u64	data_fin_tx_seq;
+	u32	remote_nonce;
+	u64	thmac;
+	u32	local_nonce;
+	u8	local_id;
+	u8	remote_id;
 
 	struct	sock *tcp_sock;	    /* tcp sk backpointer */
 	struct	sock *conn;	    /* parent mptcp_sock */
@@ -270,11 +291,13 @@ void mptcp_get_options(const struct sk_buff *skb,
 
 void mptcp_finish_connect(struct sock *sk);
 void mptcp_data_ready(struct sock *sk, struct sock *ssk);
+bool mptcp_finish_join(struct sock *sk);
 
 int mptcp_token_new_request(struct request_sock *req);
 void mptcp_token_destroy_request(u32 token);
 int mptcp_token_new_connect(struct sock *sk);
 int mptcp_token_new_accept(u32 token, struct sock *conn);
+struct mptcp_sock *mptcp_token_get_sock(u32 token);
 void mptcp_token_destroy(u32 token);
 
 void mptcp_crypto_key_sha(u64 key, u32 *token, u64 *idsn);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 35345b2b0c44..eb5f016ce7a5 100644
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
@@ -47,6 +48,52 @@ static void subflow_req_destructor(struct request_sock *req)
 	tcp_request_sock_ops.destructor(req);
 }
 
+static void subflow_generate_hmac(u64 key1, u64 key2, u32 nonce1, u32 nonce2,
+				  void *hmac)
+{
+	u8 msg[8];
+
+	put_unaligned_be32(nonce1, &msg[0]);
+	put_unaligned_be32(nonce2, &msg[4]);
+
+	mptcp_crypto_hmac_sha(key1, key2, msg, 8, hmac);
+}
+
+/* validate received token and create truncated hmac and nonce for SYN-ACK */
+static bool subflow_token_join_request(struct request_sock *req,
+				       const struct sk_buff *skb)
+{
+	struct mptcp_subflow_request_sock *subflow_req = mptcp_subflow_rsk(req);
+	u8 hmac[MPTCPOPT_HMAC_LEN];
+	struct mptcp_sock *msk;
+	int local_id;
+
+	msk = mptcp_token_get_sock(subflow_req->token);
+	if (!msk) {
+		pr_debug("subflow_req=%p, token=%u - not found\n",
+			 subflow_req, subflow_req->token);
+		return false;
+	}
+
+	local_id = mptcp_pm_get_local_id(msk, (struct sock_common *)req);
+	if (local_id < 0) {
+		sock_put((struct sock *)msk);
+		return false;
+	}
+	subflow_req->local_id = local_id;
+
+	get_random_bytes(&subflow_req->local_nonce, sizeof(u32));
+
+	subflow_generate_hmac(msk->local_key, msk->remote_key,
+			      subflow_req->local_nonce,
+			      subflow_req->remote_nonce, hmac);
+
+	subflow_req->thmac = get_unaligned_be64(hmac);
+
+	sock_put((struct sock *)msk);
+	return true;
+}
+
 static void subflow_init_req(struct request_sock *req,
 			     const struct sock *sk_listener,
 			     struct sk_buff *skb)
@@ -61,6 +108,7 @@ static void subflow_init_req(struct request_sock *req,
 	mptcp_get_options(skb, &rx_opt);
 
 	subflow_req->mp_capable = 0;
+	subflow_req->mp_join = 0;
 	subflow_req->remote_key_valid = 0;
 
 #ifdef CONFIG_TCP_MD5SIG
@@ -71,6 +119,9 @@ static void subflow_init_req(struct request_sock *req,
 		return;
 #endif
 
+	if (rx_opt.mptcp.mp_capable && rx_opt.mptcp.mp_join)
+		return;
+
 	if (rx_opt.mptcp.mp_capable && listener->request_mptcp) {
 		int err;
 
@@ -79,6 +130,18 @@ static void subflow_init_req(struct request_sock *req,
 			subflow_req->mp_capable = 1;
 
 		subflow_req->ssn_offset = TCP_SKB_CB(skb)->seq;
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
 
@@ -172,6 +235,32 @@ static int subflow_v6_conn_request(struct sock *sk, struct sk_buff *skb)
 }
 #endif
 
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
+	subflow_generate_hmac(msk->remote_key, msk->local_key,
+			      subflow_req->remote_nonce,
+			      subflow_req->local_nonce, hmac);
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
@@ -182,6 +271,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 	struct mptcp_subflow_context *listener = mptcp_subflow_ctx(sk);
 	struct mptcp_subflow_request_sock *subflow_req;
 	struct tcp_options_received opt_rx;
+	bool fallback_is_fatal = false;
 	struct sock *new_msk = NULL;
 	struct sock *child;
 
@@ -215,6 +305,13 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 		new_msk = mptcp_sk_clone(listener->conn, req);
 		if (!new_msk)
 			subflow_req->mp_capable = 0;
+	} else if (subflow_req->mp_join) {
+		fallback_is_fatal = true;
+		opt_rx.mptcp.mp_join = 0;
+		mptcp_get_options(skb, &opt_rx);
+		if (!opt_rx.mptcp.mp_join ||
+		    !subflow_hmac_valid(req, &opt_rx))
+			return NULL;
 	}
 
 create_child:
@@ -224,11 +321,14 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 	if (child && *own_req) {
 		struct mptcp_subflow_context *ctx = mptcp_subflow_ctx(child);
 
-		/* we have null ctx on TCP fallback, not fatal on MPC
-		 * handshake
+		/* we have null ctx on TCP fallback, which is fatal on
+		 * MPJ handshake
 		 */
-		if (!ctx)
+		if (!ctx) {
+			if (fallback_is_fatal)
+				goto close_child;
 			goto out;
+		}
 
 		if (ctx->mp_capable) {
 			/* new mpc subflow takes ownership of the newly
@@ -238,6 +338,16 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 			mptcp_pm_new_connection(mptcp_sk(new_msk), 1);
 			ctx->conn = new_msk;
 			new_msk = NULL;
+		} else if (ctx->mp_join) {
+			struct mptcp_sock *owner;
+
+			owner = mptcp_token_get_sock(ctx->token);
+			if (!owner)
+				goto close_child;
+
+			ctx->conn = (struct sock *)owner;
+			if (!mptcp_finish_join(child))
+				goto close_child;
 		}
 	}
 
@@ -246,6 +356,12 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 	if (unlikely(new_msk))
 		sock_put(new_msk);
 	return child;
+
+close_child:
+	tcp_send_active_reset(child, GFP_ATOMIC);
+	inet_csk_prepare_forced_close(child);
+	tcp_done(child);
+	return NULL;
 }
 
 static struct inet_connection_sock_af_ops subflow_specific;
@@ -560,7 +676,7 @@ static void subflow_data_ready(struct sock *sk)
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 	struct sock *parent = subflow->conn;
 
-	if (!subflow->mp_capable) {
+	if (!subflow->mp_capable && !subflow->mp_join) {
 		subflow->tcp_data_ready(sk);
 
 		parent->sk_data_ready(parent);
@@ -779,7 +895,8 @@ static void subflow_ulp_clone(const struct request_sock *req,
 	struct mptcp_subflow_context *old_ctx = mptcp_subflow_ctx(newsk);
 	struct mptcp_subflow_context *new_ctx;
 
-	if (!tcp_rsk(req)->is_mptcp || !subflow_req->mp_capable) {
+	if (!tcp_rsk(req)->is_mptcp ||
+	    (!subflow_req->mp_capable && !subflow_req->mp_join)) {
 		subflow_ulp_fallback(newsk, old_ctx);
 		return;
 	}
@@ -790,9 +907,6 @@ static void subflow_ulp_clone(const struct request_sock *req,
 		return;
 	}
 
-	/* see comments in subflow_syn_recv_sock(), MPTCP connection is fully
-	 * established only after we receive the remote key
-	 */
 	new_ctx->conn_finished = 1;
 	new_ctx->icsk_af_ops = old_ctx->icsk_af_ops;
 	new_ctx->tcp_data_ready = old_ctx->tcp_data_ready;
@@ -801,14 +915,26 @@ static void subflow_ulp_clone(const struct request_sock *req,
 	new_ctx->rel_write_seq = 1;
 	new_ctx->tcp_sock = newsk;
 
-	new_ctx->mp_capable = 1;
-	new_ctx->fully_established = subflow_req->remote_key_valid;
-	new_ctx->can_ack = subflow_req->remote_key_valid;
-	new_ctx->remote_key = subflow_req->remote_key;
-	new_ctx->local_key = subflow_req->local_key;
-	new_ctx->token = subflow_req->token;
-	new_ctx->ssn_offset = subflow_req->ssn_offset;
-	new_ctx->idsn = subflow_req->idsn;
+	if (subflow_req->mp_capable) {
+		/* see comments in subflow_syn_recv_sock(), MPTCP connection
+		 * is fully established only after we receive the remote key
+		 */
+		new_ctx->mp_capable = 1;
+		new_ctx->fully_established = subflow_req->remote_key_valid;
+		new_ctx->can_ack = subflow_req->remote_key_valid;
+		new_ctx->remote_key = subflow_req->remote_key;
+		new_ctx->local_key = subflow_req->local_key;
+		new_ctx->token = subflow_req->token;
+		new_ctx->ssn_offset = subflow_req->ssn_offset;
+		new_ctx->idsn = subflow_req->idsn;
+	} else if (subflow_req->mp_join) {
+		new_ctx->mp_join = 1;
+		new_ctx->fully_established = 1;
+		new_ctx->backup = subflow_req->backup;
+		new_ctx->local_id = subflow_req->local_id;
+		new_ctx->token = subflow_req->token;
+		new_ctx->thmac = subflow_req->thmac;
+	}
 }
 
 static struct tcp_ulp_ops subflow_ulp_ops __read_mostly = {
diff --git a/net/mptcp/token.c b/net/mptcp/token.c
index b71b53c0ac8d..d0e0585fb2ff 100644
--- a/net/mptcp/token.c
+++ b/net/mptcp/token.c
@@ -140,6 +140,33 @@ int mptcp_token_new_accept(u32 token, struct sock *conn)
 	return err;
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
+	if (conn) {
+		/* token still reserved? */
+		if (conn == (struct sock *)&token_used)
+			conn = NULL;
+		else
+			sock_hold(conn);
+	}
+	spin_unlock_bh(&token_tree_lock);
+
+	return mptcp_sk(conn);
+}
+
 /**
  * mptcp_token_destroy_request - remove mptcp connection/token
  * @token - token of mptcp connection to remove
-- 
2.26.0

