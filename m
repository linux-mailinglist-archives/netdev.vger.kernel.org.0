Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCF34958E
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728789AbfFQW66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:58:58 -0400
Received: from mga18.intel.com ([134.134.136.126]:10994 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728281AbfFQW6w (ORCPT <rfc822;netdev@vger.kernel.org>);
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
Subject: [RFC PATCH net-next 11/33] mptcp: Add key generation and token tree
Date:   Mon, 17 Jun 2019 15:57:46 -0700
Message-Id: <20190617225808.665-12-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
References: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Krystad <peter.krystad@linux.intel.com>

Generate the local keys, IDSN, and token when creating a new
socket. Introduce the token tree to track all tokens in use using
a radix tree with the MPTCP token itself as the index.

Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
---
 net/mptcp/Makefile   |   2 +-
 net/mptcp/crypto.c   | 206 +++++++++++++++++++++++++++++++++++
 net/mptcp/protocol.c |  17 +++
 net/mptcp/protocol.h |  26 +++++
 net/mptcp/subflow.c  |  36 ++++++-
 net/mptcp/token.c    | 248 +++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 533 insertions(+), 2 deletions(-)
 create mode 100644 net/mptcp/crypto.c
 create mode 100644 net/mptcp/token.c

diff --git a/net/mptcp/Makefile b/net/mptcp/Makefile
index e1ee5aade8b0..178ae81d8b66 100644
--- a/net/mptcp/Makefile
+++ b/net/mptcp/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_MPTCP) += mptcp.o
 
-mptcp-y := protocol.o subflow.o options.o
+mptcp-y := protocol.o subflow.o options.o token.o crypto.o
diff --git a/net/mptcp/crypto.c b/net/mptcp/crypto.c
new file mode 100644
index 000000000000..26a68aa1933a
--- /dev/null
+++ b/net/mptcp/crypto.c
@@ -0,0 +1,206 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Multipath TCP cryptographic functions
+ * Copyright (c) 2017 - 2019, Intel Corporation.
+ *
+ * Note: This code is based on mptcp_ctrl.c, mptcp_ipv4.c, and
+ *       mptcp_ipv6 from multipath-tcp.org, authored by:
+ *
+ *       Sébastien Barré <sebastien.barre@uclouvain.be>
+ *       Christoph Paasch <christoph.paasch@uclouvain.be>
+ *       Jaakko Korkeaniemi <jaakko.korkeaniemi@aalto.fi>
+ *       Gregory Detal <gregory.detal@uclouvain.be>
+ *       Fabien Duchêne <fabien.duchene@uclouvain.be>
+ *       Andreas Seelinger <Andreas.Seelinger@rwth-aachen.de>
+ *       Lavkesh Lahngir <lavkesh51@gmail.com>
+ *       Andreas Ripke <ripke@neclab.eu>
+ *       Vlad Dogaru <vlad.dogaru@intel.com>
+ *       Octavian Purdila <octavian.purdila@intel.com>
+ *       John Ronan <jronan@tssg.org>
+ *       Catalin Nicutar <catalin.nicutar@gmail.com>
+ *       Brandon Heller <brandonh@stanford.edu>
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/cryptohash.h>
+#include <linux/random.h>
+#include <linux/siphash.h>
+#include <asm/unaligned.h>
+
+static siphash_key_t crypto_key_secret __read_mostly;
+static hsiphash_key_t crypto_nonce_secret __read_mostly;
+static u32 crypto_seed;
+
+u32 crypto_v4_get_nonce(__be32 saddr, __be32 daddr, __be16 sport, __be16 dport)
+{
+	return hsiphash_4u32((__force u32)saddr, (__force u32)daddr,
+			    (__force u32)sport << 16 | (__force u32)dport,
+			    crypto_seed++, &crypto_nonce_secret);
+}
+
+u64 crypto_v4_get_key(__be32 saddr, __be32 daddr, __be16 sport, __be16 dport)
+{
+	pr_debug("src=%x:%d, dst=%x:%d", saddr, sport, daddr, dport);
+	return siphash_4u32((__force u32)saddr, (__force u32)daddr,
+			    (__force u32)sport << 16 | (__force u32)dport,
+			    crypto_seed++, &crypto_key_secret);
+}
+
+u32 crypto_v6_get_nonce(const struct in6_addr *saddr,
+			const struct in6_addr *daddr,
+			__be16 sport, __be16 dport)
+{
+	const struct {
+		struct in6_addr saddr;
+		struct in6_addr daddr;
+		u32 seed;
+		__be16 sport;
+		__be16 dport;
+	} __aligned(SIPHASH_ALIGNMENT) combined = {
+		.saddr = *saddr,
+		.daddr = *daddr,
+		.seed = crypto_seed++,
+		.sport = sport,
+		.dport = dport,
+	};
+
+	return hsiphash(&combined, offsetofend(typeof(combined), dport),
+			&crypto_nonce_secret);
+}
+
+u64 crypto_v6_get_key(const struct in6_addr *saddr,
+		      const struct in6_addr *daddr,
+		      __be16 sport, __be16 dport)
+{
+	const struct {
+		struct in6_addr saddr;
+		struct in6_addr daddr;
+		u32 seed;
+		__be16 sport;
+		__be16 dport;
+	} __aligned(SIPHASH_ALIGNMENT) combined = {
+		.saddr = *saddr,
+		.daddr = *daddr,
+		.seed = crypto_seed++,
+		.sport = sport,
+		.dport = dport,
+	};
+
+	return siphash(&combined, offsetofend(typeof(combined), dport),
+		       &crypto_key_secret);
+}
+
+void crypto_key_sha1(u64 key, u32 *token, u64 *idsn)
+{
+	u32 workspace[SHA_WORKSPACE_WORDS];
+	u32 mptcp_hashed_key[SHA_DIGEST_WORDS];
+	u8 input[64];
+
+	memset(workspace, 0, sizeof(workspace));
+
+	/* Initialize input with appropriate padding */
+	memset(&input[9], 0, sizeof(input) - 10); /* -10, because the last byte
+						   * is explicitly set too
+						   */
+	put_unaligned_be64(key, input);
+	input[8] = 0x80; /* Padding: First bit after message = 1 */
+	input[63] = 0x40; /* Padding: Length of the message = 64 bits */
+
+	sha_init(mptcp_hashed_key);
+	sha_transform(mptcp_hashed_key, input, workspace);
+
+	if (token)
+		*token = mptcp_hashed_key[0];
+	if (idsn)
+		*idsn = ((u64)mptcp_hashed_key[3] << 32) + mptcp_hashed_key[4];
+}
+
+void crypto_hmac_sha1(u64 key1, u64 key2, u32 *hash_out,
+		      int arg_num, ...)
+{
+	u32 workspace[SHA_WORKSPACE_WORDS];
+	u8 input[128]; /* 2 512-bit blocks */
+	int i;
+	int index;
+	int length;
+	u8 *msg;
+	va_list list;
+	u8 key_1[8];
+	u8 key_2[8];
+
+	memset(workspace, 0, sizeof(workspace));
+
+	put_unaligned_be64(key1, key_1);
+	put_unaligned_be64(key2, key_2);
+
+	/* Generate key xored with ipad */
+	memset(input, 0x36, 64);
+	for (i = 0; i < 8; i++)
+		input[i] ^= key_1[i];
+	for (i = 0; i < 8; i++)
+		input[i + 8] ^= key_2[i];
+
+	va_start(list, arg_num);
+	index = 64;
+	for (i = 0; i < arg_num; i++) {
+		length = va_arg(list, int);
+		msg = va_arg(list, u8 *);
+		WARN_ON(index + length > 125); /* Message is too long */
+		memcpy(&input[index], msg, length);
+		index += length;
+	}
+	va_end(list);
+
+	input[index] = 0x80; /* Padding: First bit after message = 1 */
+	memset(&input[index + 1], 0, (126 - index));
+
+	/* Padding: Length of the message = 512 + message length (bits) */
+	input[126] = 0x02;
+	input[127] = ((index - 64) * 8); /* Message length (bits) */
+
+	sha_init(hash_out);
+	sha_transform(hash_out, input, workspace);
+	memset(workspace, 0, sizeof(workspace));
+
+	sha_transform(hash_out, &input[64], workspace);
+	memset(workspace, 0, sizeof(workspace));
+
+	for (i = 0; i < 5; i++)
+		hash_out[i] = (__force u32)cpu_to_be32(hash_out[i]);
+
+	/* Prepare second part of hmac */
+	memset(input, 0x5C, 64);
+	for (i = 0; i < 8; i++)
+		input[i] ^= key_1[i];
+	for (i = 0; i < 8; i++)
+		input[i + 8] ^= key_2[i];
+
+	memcpy(&input[64], hash_out, 20);
+	input[84] = 0x80;
+	memset(&input[85], 0, 41);
+
+	/* Padding: Length of the message = 512 + 160 bits */
+	input[126] = 0x02;
+	input[127] = 0xA0;
+
+	sha_init(hash_out);
+	sha_transform(hash_out, input, workspace);
+	memset(workspace, 0, sizeof(workspace));
+
+	sha_transform(hash_out, &input[64], workspace);
+
+	for (i = 0; i < 5; i++)
+		hash_out[i] = (__force u32)cpu_to_be32(hash_out[i]);
+}
+
+void crypto_init(void)
+{
+	get_random_bytes((void *)&crypto_key_secret,
+			 sizeof(crypto_key_secret));
+	get_random_bytes((void *)&crypto_nonce_secret,
+			 sizeof(crypto_nonce_secret));
+	crypto_seed = 0;
+}
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index ea771f537ac0..2f340ef8e281 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -111,6 +111,9 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 	if (subflow->mp_capable) {
 		msk->remote_key = subflow->remote_key;
 		msk->local_key = subflow->local_key;
+		msk->token = subflow->token;
+		pr_debug("token=%u", msk->token);
+		token_update_accept(new_sock->sk, new_mptcp_sock->sk);
 		msk->connection_list = new_sock;
 	} else {
 		msk->subflow = new_sock;
@@ -119,6 +122,15 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 	return new_mptcp_sock->sk;
 }
 
+static void mptcp_destroy(struct sock *sk)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
+	pr_debug("msk=%p, subflow=%p", sk, msk->subflow->sk);
+
+	token_destroy(msk->token);
+}
+
 static int mptcp_get_port(struct sock *sk, unsigned short snum)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -136,6 +148,8 @@ void mptcp_finish_connect(struct sock *sk, int mp_capable)
 	if (mp_capable) {
 		msk->remote_key = subflow->remote_key;
 		msk->local_key = subflow->local_key;
+		msk->token = subflow->token;
+		pr_debug("token=%u", msk->token);
 		msk->connection_list = msk->subflow;
 		msk->subflow = NULL;
 	}
@@ -149,6 +163,7 @@ static struct proto mptcp_prot = {
 	.close		= mptcp_close,
 	.accept		= mptcp_accept,
 	.shutdown	= tcp_shutdown,
+	.destroy	= mptcp_destroy,
 	.sendmsg	= mptcp_sendmsg,
 	.recvmsg	= mptcp_recvmsg,
 	.hash		= inet_hash,
@@ -302,6 +317,8 @@ void __init mptcp_init(void)
 	mptcp_stream_ops.getname = mptcp_getname;
 	mptcp_stream_ops.listen = mptcp_listen;
 
+	token_init();
+	crypto_init();
 	subflow_init();
 
 	if (proto_register(&mptcp_prot, 1) != 0)
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 34eb10c279f0..5a8ed316d70e 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -35,6 +35,7 @@ struct mptcp_sock {
 	struct	inet_connection_sock sk;
 	u64	local_key;
 	u64	remote_key;
+	u32	token;
 	struct	socket *connection_list; /* @@ needs to be a list */
 	struct	socket *subflow; /* outgoing connect, listener or !mp_capable */
 };
@@ -53,6 +54,7 @@ struct subflow_request_sock {
 		version : 4;
 	u64	local_key;
 	u64	remote_key;
+	u32	token;
 };
 
 static inline
@@ -65,6 +67,7 @@ struct subflow_request_sock *subflow_rsk(const struct request_sock *rsk)
 struct subflow_context {
 	u64	local_key;
 	u64	remote_key;
+	u32	token;
 	u32	request_mptcp : 1,  /* send MP_CAPABLE */
 		request_cksum : 1,
 		mp_capable : 1,	    /* remote is MPTCP capable */
@@ -97,4 +100,27 @@ void mptcp_get_options(const struct sk_buff *skb,
 
 void mptcp_finish_connect(struct sock *sk, int mp_capable);
 
+void token_init(void);
+void token_new_request(struct request_sock *req, const struct sk_buff *skb);
+void token_destroy_request(u32 token);
+void token_new_connect(struct sock *sk);
+void token_new_accept(struct sock *sk);
+void token_update_accept(struct sock *sk, struct sock *conn);
+void token_destroy(u32 token);
+
+void crypto_init(void);
+u32 crypto_v4_get_nonce(__be32 saddr, __be32 daddr,
+			__be16 sport, __be16 dport);
+u64 crypto_v4_get_key(__be32 saddr, __be32 daddr,
+		      __be16 sport, __be16 dport);
+u64 crypto_v6_get_key(const struct in6_addr *saddr,
+		      const struct in6_addr *daddr,
+		      __be16 sport, __be16 dport);
+u32 crypto_v6_get_nonce(const struct in6_addr *saddr,
+			const struct in6_addr *daddr,
+			__be16 sport, __be16 dport);
+void crypto_key_sha1(u64 key, u32 *token, u64 *idsn);
+void crypto_hmac_sha1(u64 key1, u64 key2, u32 *hash_out,
+		      int arg_num, ...);
+
 #endif /* __MPTCP_PROTOCOL_H */
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index fd2bf7621f0e..abae6a42a101 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -15,6 +15,29 @@
 #include <net/mptcp.h>
 #include "protocol.h"
 
+static int subflow_rebuild_header(struct sock *sk)
+{
+	struct subflow_context *subflow = subflow_ctx(sk);
+
+	if (subflow->request_mptcp && !subflow->token) {
+		pr_debug("subflow=%p", sk);
+		token_new_connect(sk);
+	}
+
+	return inet_sk_rebuild_header(sk);
+}
+
+static void subflow_req_destructor(struct request_sock *req)
+{
+	struct subflow_request_sock *subflow_req = subflow_rsk(req);
+
+	pr_debug("subflow_req=%p", subflow_req);
+
+	if (subflow_req->mp_capable)
+		token_destroy_request(subflow_req->token);
+	tcp_request_sock_ops.destructor(req);
+}
+
 static void subflow_v4_init_req(struct request_sock *req,
 				const struct sock *sk_listener,
 				struct sk_buff *skb)
@@ -41,6 +64,8 @@ static void subflow_v4_init_req(struct request_sock *req,
 		    listener->request_cksum)
 			subflow_req->checksum = 1;
 		subflow_req->remote_key = rx_opt.mptcp.sndr_key;
+		pr_debug("remote_key=%llu", subflow_req->remote_key);
+		token_new_request(req, skb);
 	} else {
 		subflow_req->mp_capable = 0;
 	}
@@ -107,12 +132,16 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 	child = tcp_v4_syn_recv_sock(sk, skb, req, dst, req_unhash, own_req);
 
 	if (child && *own_req) {
-		if (!subflow_ctx(child)) {
+		struct subflow_context *ctx = subflow_ctx(child);
+
+		if (!ctx) {
 			pr_debug("Closing child socket");
 			inet_sk_set_state(child, TCP_CLOSE);
 			sock_set_flag(child, SOCK_DEAD);
 			inet_csk_destroy_sock(child);
 			child = NULL;
+		} else if (ctx->mp_capable) {
+			token_new_accept(child);
 		}
 	}
 
@@ -193,6 +222,8 @@ static void subflow_ulp_clone(const struct request_sock *req,
 		subflow->fourth_ack = 1;
 		subflow->remote_key = subflow_req->remote_key;
 		subflow->local_key = subflow_req->local_key;
+		subflow->token = subflow_req->token;
+		pr_debug("token=%u", subflow->token);
 	}
 }
 
@@ -217,6 +248,8 @@ static int subflow_ops_init(struct request_sock_ops *subflow_ops)
 	if (!subflow_ops->slab)
 		return -ENOMEM;
 
+	subflow_ops->destructor = subflow_req_destructor;
+
 	return 0;
 }
 
@@ -233,6 +266,7 @@ void subflow_init(void)
 	subflow_specific.conn_request = subflow_conn_request;
 	subflow_specific.syn_recv_sock = subflow_syn_recv_sock;
 	subflow_specific.sk_rx_dst_set = subflow_finish_connect;
+	subflow_specific.rebuild_header = subflow_rebuild_header;
 
 	if (tcp_register_ulp(&subflow_ulp_ops) != 0)
 		panic("MPTCP: failed to register subflows to ULP\n");
diff --git a/net/mptcp/token.c b/net/mptcp/token.c
new file mode 100644
index 000000000000..8c15b8134f70
--- /dev/null
+++ b/net/mptcp/token.c
@@ -0,0 +1,248 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Multipath TCP token management
+ * Copyright (c) 2017 - 2019, Intel Corporation.
+ *
+ * Note: This code is based on mptcp_ctrl.c from multipath-tcp.org,
+ *       authored by:
+ *
+ *       Sébastien Barré <sebastien.barre@uclouvain.be>
+ *       Christoph Paasch <christoph.paasch@uclouvain.be>
+ *       Jaakko Korkeaniemi <jaakko.korkeaniemi@aalto.fi>
+ *       Gregory Detal <gregory.detal@uclouvain.be>
+ *       Fabien Duchêne <fabien.duchene@uclouvain.be>
+ *       Andreas Seelinger <Andreas.Seelinger@rwth-aachen.de>
+ *       Lavkesh Lahngir <lavkesh51@gmail.com>
+ *       Andreas Ripke <ripke@neclab.eu>
+ *       Vlad Dogaru <vlad.dogaru@intel.com>
+ *       Octavian Purdila <octavian.purdila@intel.com>
+ *       John Ronan <jronan@tssg.org>
+ *       Catalin Nicutar <catalin.nicutar@gmail.com>
+ *       Brandon Heller <brandonh@stanford.edu>
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/radix-tree.h>
+#include <linux/ip.h>
+#include <linux/tcp.h>
+#include <net/sock.h>
+#include <net/inet_common.h>
+#include <net/protocol.h>
+#include <net/mptcp.h>
+#include "protocol.h"
+
+static struct radix_tree_root token_tree;
+static struct radix_tree_root token_req_tree;
+static spinlock_t token_tree_lock;
+static int token_used;
+
+static bool find_req_token(u32 token)
+{
+	void *used;
+
+	pr_debug("token=%u", token);
+	used = radix_tree_lookup(&token_req_tree, token);
+	return used;
+}
+
+static bool find_token(u32 token)
+{
+	void *used;
+
+	pr_debug("token=%u", token);
+	used = radix_tree_lookup(&token_tree, token);
+	return used;
+}
+
+static void new_req_token(struct request_sock *req,
+			  const struct sk_buff *skb)
+{
+	const struct inet_request_sock *ireq = inet_rsk(req);
+	struct subflow_request_sock *subflow_req = subflow_rsk(req);
+	u64 local_key;
+
+	if (!IS_ENABLED(CONFIG_IPV6) || skb->protocol == htons(ETH_P_IP)) {
+		local_key = crypto_v4_get_key(ip_hdr(skb)->saddr,
+					      ip_hdr(skb)->daddr,
+					      htons(ireq->ir_num),
+					      ireq->ir_rmt_port);
+#if IS_ENABLED(CONFIG_IPV6)
+	} else {
+		local_key = crypto_v6_get_key(&ipv6_hdr(skb)->saddr,
+					      &ipv6_hdr(skb)->daddr,
+					      htons(ireq->ir_num),
+					      ireq->ir_rmt_port);
+#endif
+	}
+	pr_debug("local_key=%llu:%llx", local_key, local_key);
+	subflow_req->local_key = local_key;
+	crypto_key_sha1(subflow_req->local_key, &subflow_req->token, NULL);
+	pr_debug("token=%u", subflow_req->token);
+}
+
+static void new_token(const struct sock *sk)
+{
+	struct subflow_context *subflow = subflow_ctx(sk);
+	const struct inet_sock *isk = inet_sk(sk);
+
+	if (sk->sk_family == AF_INET) {
+		subflow->local_key = crypto_v4_get_key(isk->inet_saddr,
+						       isk->inet_daddr,
+						       isk->inet_sport,
+						       isk->inet_dport);
+#if IS_ENABLED(CONFIG_IPV6)
+	} else {
+		subflow->local_key = crypto_v6_get_key(&inet6_sk(sk)->saddr,
+						       &sk->sk_v6_daddr,
+						       isk->inet_sport,
+						       isk->inet_dport);
+#endif
+	}
+	pr_debug("local_key=%llu:%llx", subflow->local_key, subflow->local_key);
+	crypto_key_sha1(subflow->local_key, &subflow->token, NULL);
+	pr_debug("token=%u", subflow->token);
+}
+
+static int insert_req_token(u32 token)
+{
+	void *used = &token_used;
+
+	pr_debug("token=%u", token);
+	return radix_tree_insert(&token_req_tree, token, used);
+}
+
+static int insert_token(u32 token, void *conn)
+{
+	void *used = &token_used;
+
+	if (conn)
+		used = conn;
+
+	pr_debug("token=%u, conn=%p", token, used);
+	return radix_tree_insert(&token_tree, token, used);
+}
+
+static void update_token(u32 token, void *conn)
+{
+	void **slot;
+
+	pr_debug("token=%u, conn=%p", token, conn);
+	slot = radix_tree_lookup_slot(&token_tree, token);
+	if (slot) {
+		if (*slot != &token_used)
+			pr_err("slot ALREADY updated!");
+		*slot = conn;
+	} else {
+		pr_warn("token NOT FOUND!");
+	}
+}
+
+static void destroy_req_token(u32 token)
+{
+	void *cur;
+
+	cur = radix_tree_delete(&token_req_tree, token);
+	if (!cur)
+		pr_warn("token NOT FOUND!");
+}
+
+static struct sock *destroy_token(u32 token)
+{
+	void *conn;
+
+	pr_debug("token=%u", token);
+	conn = radix_tree_delete(&token_tree, token);
+	if (conn && conn != &token_used)
+		return (struct sock *)conn;
+	return NULL;
+}
+
+/* create new local key, idsn, and token for subflow_request */
+void token_new_request(struct request_sock *req,
+		       const struct sk_buff *skb)
+{
+	struct subflow_request_sock *subflow_req = subflow_rsk(req);
+
+	pr_debug("subflow_req=%p", req);
+	while (1) {
+		new_req_token(req, skb);
+		spin_lock_bh(&token_tree_lock);
+		if (!find_req_token(subflow_req->token) &&
+		    !find_token(subflow_req->token))
+			break;
+		spin_unlock_bh(&token_tree_lock);
+	}
+	insert_req_token(subflow_req->token);
+	spin_unlock_bh(&token_tree_lock);
+}
+
+/* create new local key, idsn, and token for subflow */
+void token_new_connect(struct sock *sk)
+{
+	struct subflow_context *subflow = subflow_ctx(sk);
+
+	pr_debug("subflow=%p", sk);
+
+	while (1) {
+		new_token(sk);
+		spin_lock_bh(&token_tree_lock);
+		if (!find_req_token(subflow->token) &&
+		    !find_token(subflow->token))
+			break;
+		spin_unlock_bh(&token_tree_lock);
+	}
+	insert_token(subflow->token, subflow->conn);
+	sock_hold(subflow->conn);
+	spin_unlock_bh(&token_tree_lock);
+}
+
+void token_new_accept(struct sock *sk)
+{
+	struct subflow_context *subflow = subflow_ctx(sk);
+
+	pr_debug("subflow=%p", sk);
+
+	spin_lock_bh(&token_tree_lock);
+	insert_token(subflow->token, NULL);
+	spin_unlock_bh(&token_tree_lock);
+}
+
+void token_update_accept(struct sock *sk, struct sock *conn)
+{
+	struct subflow_context *subflow = subflow_ctx(sk);
+
+	pr_debug("subflow=%p, conn=%p", sk, conn);
+
+	spin_lock_bh(&token_tree_lock);
+	update_token(subflow->token, conn);
+	sock_hold(conn);
+	spin_unlock_bh(&token_tree_lock);
+}
+
+void token_destroy_request(u32 token)
+{
+	pr_debug("token=%u", token);
+
+	spin_lock_bh(&token_tree_lock);
+	destroy_req_token(token);
+	spin_unlock_bh(&token_tree_lock);
+}
+
+void token_destroy(u32 token)
+{
+	struct sock *conn;
+
+	pr_debug("token=%u", token);
+	spin_lock_bh(&token_tree_lock);
+	conn = destroy_token(token);
+	if (conn)
+		sock_put(conn);
+	spin_unlock_bh(&token_tree_lock);
+}
+
+void token_init(void)
+{
+	INIT_RADIX_TREE(&token_tree, GFP_ATOMIC);
+	INIT_RADIX_TREE(&token_req_tree, GFP_ATOMIC);
+	spin_lock_init(&token_tree_lock);
+}
-- 
2.22.0

