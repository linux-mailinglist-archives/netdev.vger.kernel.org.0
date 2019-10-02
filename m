Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 610CFC94E9
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbfJBXha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:37:30 -0400
Received: from mga04.intel.com ([192.55.52.120]:16452 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728960AbfJBXhX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:37:23 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:37:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366862596"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.30.230])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 16:37:21 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Peter Krystad <peter.krystad@linux.intel.com>, cpaasch@apple.com,
        fw@strlen.de, pabeni@redhat.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH v2 13/45] mptcp: Add key generation and token tree
Date:   Wed,  2 Oct 2019 16:36:23 -0700
Message-Id: <20191002233655.24323-14-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
References: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Krystad <peter.krystad@linux.intel.com>

Generate the local keys, IDSN, and token when creating a new socket.
Introduce the token tree to track all tokens in use using a radix tree
with the MPTCP token itself as the index.

Will be used to obtain the MPTCP parent socket to handle incoming joins.

Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/Makefile   |   2 +-
 net/mptcp/crypto.c   | 128 ++++++++++++++++++++++++++++
 net/mptcp/protocol.c |  11 +++
 net/mptcp/protocol.h |  32 +++++++
 net/mptcp/subflow.c  |  65 +++++++++++++--
 net/mptcp/token.c    | 195 +++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 424 insertions(+), 9 deletions(-)
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
index 000000000000..0d7b10939ba6
--- /dev/null
+++ b/net/mptcp/crypto.c
@@ -0,0 +1,128 @@
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
+#include <linux/cryptohash.h>
+#include <linux/random.h>
+#include <linux/siphash.h>
+#include <asm/unaligned.h>
+
+#include "protocol.h"
+
+void mptcp_crypto_key_sha1(u64 key, u32 *token, u64 *idsn)
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
+void mptcp_crypto_hmac_sha1(u64 key1, u64 key2, u32 nonce1, u32 nonce2,
+			    u32 *hash_out)
+{
+	u32 workspace[SHA_WORKSPACE_WORDS];
+	u8 input[128]; /* 2 512-bit blocks */
+	int i;
+	int index;
+	u8 key_1[8];
+	u8 key_2[8];
+	u8 nonce_1[4];
+	u8 nonce_2[4];
+
+	memset(workspace, 0, sizeof(workspace));
+
+	put_unaligned_be64(key1, key_1);
+	put_unaligned_be64(key2, key_2);
+	put_unaligned_be32(nonce1, nonce_1);
+	put_unaligned_be32(nonce2, nonce_2);
+
+	/* Generate key xored with ipad */
+	memset(input, 0x36, 64);
+	for (i = 0; i < 8; i++)
+		input[i] ^= key_1[i];
+	for (i = 0; i < 8; i++)
+		input[i + 8] ^= key_2[i];
+
+	index = 64;
+	memcpy(&input[index], nonce_1, 4);
+	index = 68;
+	memcpy(&input[index], nonce_2, 4);
+	index = 72;
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
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 5605391fc32a..0a9c447db159 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -133,6 +133,7 @@ static void mptcp_close(struct sock *sk, long timeout)
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct socket *ssk = NULL;
 
+	mptcp_token_destroy(msk->token);
 	inet_sk_state_store(sk, TCP_CLOSE);
 
 	lock_sock(sk);
@@ -198,6 +199,10 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 		msk->local_key = subflow->local_key;
 		msk->subflow = NULL;
 
+		msk->token = subflow->token;
+
+		mptcp_token_update_accept(new_sock->sk, new_mptcp_sock);
+		msk->subflow = NULL;
 		newsk = new_mptcp_sock;
 		subflow->conn = new_mptcp_sock;
 		list_add(&subflow->node, &msk->conn_list);
@@ -215,6 +220,10 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 	return newsk;
 }
 
+static void mptcp_destroy(struct sock *sk)
+{
+}
+
 static int mptcp_get_port(struct sock *sk, unsigned short snum)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -258,6 +267,7 @@ void mptcp_finish_connect(struct sock *sk, int mp_capable)
 
 		msk->remote_key = subflow->remote_key;
 		msk->local_key = subflow->local_key;
+		msk->token = subflow->token;
 		list_add(&subflow->node, &msk->conn_list);
 		msk->subflow = NULL;
 		bh_unlock_sock(sk);
@@ -273,6 +283,7 @@ static struct proto mptcp_prot = {
 	.close		= mptcp_close,
 	.accept		= mptcp_accept,
 	.shutdown	= tcp_shutdown,
+	.destroy	= mptcp_destroy,
 	.sendmsg	= mptcp_sendmsg,
 	.recvmsg	= mptcp_recvmsg,
 	.hash		= inet_hash,
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index d228d1d3c8c3..dea6d4f32f38 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -7,6 +7,10 @@
 #ifndef __MPTCP_PROTOCOL_H
 #define __MPTCP_PROTOCOL_H
 
+#include <linux/random.h>
+#include <linux/tcp.h>
+#include <net/inet_connection_sock.h>
+
 /* MPTCP option bits */
 #define OPTION_MPTCP_MPC_SYN	BIT(0)
 #define OPTION_MPTCP_MPC_SYNACK	BIT(1)
@@ -40,6 +44,7 @@ struct mptcp_sock {
 	struct inet_connection_sock sk;
 	u64		local_key;
 	u64		remote_key;
+	u32		token;
 	struct list_head conn_list;
 	struct socket	*subflow; /* outgoing connect/listener/!mp_capable */
 };
@@ -61,6 +66,8 @@ struct mptcp_subflow_request_sock {
 		version : 4;
 	u64	local_key;
 	u64	remote_key;
+	u64	idsn;
+	u32	token;
 };
 
 static inline struct mptcp_subflow_request_sock *
@@ -74,6 +81,8 @@ struct mptcp_subflow_context {
 	struct	list_head node;/* conn_list of subflows */
 	u64	local_key;
 	u64	remote_key;
+	u64	idsn;
+	u32	token;
 	u32	request_mptcp : 1,  /* send MP_CAPABLE */
 		request_cksum : 1,
 		request_version : 4,
@@ -108,4 +117,27 @@ void mptcp_get_options(const struct sk_buff *skb,
 
 void mptcp_finish_connect(struct sock *sk, int mp_capable);
 
+int mptcp_token_new_request(struct request_sock *req);
+void mptcp_token_destroy_request(u32 token);
+int mptcp_token_new_connect(struct sock *sk);
+int mptcp_token_new_accept(u32 token);
+void mptcp_token_update_accept(struct sock *sk, struct sock *conn);
+void mptcp_token_destroy(u32 token);
+
+void mptcp_crypto_key_sha1(u64 key, u32 *token, u64 *idsn);
+static inline void mptcp_crypto_key_gen_sha1(u64 *key, u32 *token, u64 *idsn)
+{
+	/* we might consider a faster version that computes the key as a
+	 * hash of some information available in the MPTCP socket. Use
+	 * random data at the moment, as it's probably the safest option
+	 * in case multiple sockets are opened in different namespaces at
+	 * the same time.
+	 */
+	get_random_bytes(key, sizeof(u64));
+	mptcp_crypto_key_sha1(*key, token, idsn);
+}
+
+void mptcp_crypto_hmac_sha1(u64 key1, u64 key2, u32 nonce1, u32 nonce2,
+			    u32 *hash_out);
+
 #endif /* __MPTCP_PROTOCOL_H */
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index b4e86456d4d6..43fb1ae51b03 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -4,6 +4,8 @@
  * Copyright (c) 2017 - 2019, Intel Corporation.
  */
 
+#define pr_fmt(fmt) "MPTCP: " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
@@ -15,6 +17,33 @@
 #include <net/mptcp.h>
 #include "protocol.h"
 
+static int subflow_rebuild_header(struct sock *sk)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+	int err = 0;
+
+	if (subflow->request_mptcp && !subflow->token) {
+		pr_debug("subflow=%p", sk);
+		err = mptcp_token_new_connect(sk);
+	}
+
+	if (err)
+		return err;
+
+	return inet_sk_rebuild_header(sk);
+}
+
+static void subflow_req_destructor(struct request_sock *req)
+{
+	struct mptcp_subflow_request_sock *subflow_req = mptcp_subflow_rsk(req);
+
+	pr_debug("subflow_req=%p", subflow_req);
+
+	if (subflow_req->mp_capable)
+		mptcp_token_destroy_request(subflow_req->token);
+	tcp_request_sock_ops.destructor(req);
+}
+
 static void subflow_v4_init_req(struct request_sock *req,
 				const struct sock *sk_listener,
 				struct sk_buff *skb)
@@ -32,7 +61,12 @@ static void subflow_v4_init_req(struct request_sock *req,
 	mptcp_get_options(skb, &rx_opt);
 
 	if (rx_opt.mptcp.mp_capable && listener->request_mptcp) {
-		subflow_req->mp_capable = 1;
+		int err;
+
+		err = mptcp_token_new_request(req);
+		if (err == 0)
+			subflow_req->mp_capable = 1;
+
 		if (rx_opt.mptcp.version >= listener->request_version)
 			subflow_req->version = listener->request_version;
 		else
@@ -98,16 +132,25 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 	child = tcp_v4_syn_recv_sock(sk, skb, req, dst, req_unhash, own_req);
 
 	if (child && *own_req) {
-		if (!mptcp_subflow_ctx(child)) {
-			pr_debug("Closing child socket");
-			inet_sk_set_state(child, TCP_CLOSE);
-			sock_set_flag(child, SOCK_DEAD);
-			inet_csk_destroy_sock(child);
-			child = NULL;
+		struct mptcp_subflow_context *ctx = mptcp_subflow_ctx(child);
+
+		if (!ctx)
+			goto close_child;
+
+		if (ctx->mp_capable) {
+			if (mptcp_token_new_accept(ctx->token))
+				goto close_child;
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
@@ -134,6 +177,7 @@ int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock)
 	pr_debug("subflow=%p", subflow);
 
 	*new_sock = sf;
+	sock_hold(sk);
 	subflow->conn = sk;
 	subflow->request_mptcp = 1; // @@ if MPTCP enabled
 	subflow->request_cksum = 1; // @@ if checksum enabled
@@ -188,7 +232,8 @@ static void subflow_ulp_release(struct sock *sk)
 {
 	struct mptcp_subflow_context *ctx = mptcp_subflow_ctx(sk);
 
-	pr_debug("subflow=%p", ctx);
+	if (ctx->conn)
+		sock_put(ctx->conn);
 
 	kfree(ctx);
 }
@@ -213,6 +258,7 @@ static void subflow_ulp_clone(const struct request_sock *req,
 		new_ctx->fourth_ack = 1;
 		new_ctx->remote_key = subflow_req->remote_key;
 		new_ctx->local_key = subflow_req->local_key;
+		new_ctx->token = subflow_req->token;
 	}
 }
 
@@ -237,6 +283,8 @@ static int subflow_ops_init(struct request_sock_ops *subflow_ops)
 	if (!subflow_ops->slab)
 		return -ENOMEM;
 
+	subflow_ops->destructor = subflow_req_destructor;
+
 	return 0;
 }
 
@@ -253,6 +301,7 @@ void mptcp_subflow_init(void)
 	subflow_specific.conn_request = subflow_conn_request;
 	subflow_specific.syn_recv_sock = subflow_syn_recv_sock;
 	subflow_specific.sk_rx_dst_set = subflow_finish_connect;
+	subflow_specific.rebuild_header = subflow_rebuild_header;
 
 	if (tcp_register_ulp(&subflow_ulp_ops) != 0)
 		panic("MPTCP: failed to register subflows to ULP\n");
diff --git a/net/mptcp/token.c b/net/mptcp/token.c
new file mode 100644
index 000000000000..7e579deef6a2
--- /dev/null
+++ b/net/mptcp/token.c
@@ -0,0 +1,195 @@
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
+#define pr_fmt(fmt) "MPTCP: " fmt
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
+static RADIX_TREE(token_tree, GFP_ATOMIC);
+static RADIX_TREE(token_req_tree, GFP_ATOMIC);
+static DEFINE_SPINLOCK(token_tree_lock);
+static int token_used __read_mostly;
+
+/**
+ * mptcp_token_new_request - create new key/idsn/token for subflow_request
+ * @req - the request socket
+ *
+ * This function is called when a new mptcp connection is coming in.
+ *
+ * It creates a unique token to identify the new mptcp connection,
+ * a secret local key and the initial data sequence number (idsn).
+ *
+ * Returns 0 on success.
+ */
+int mptcp_token_new_request(struct request_sock *req)
+{
+	struct mptcp_subflow_request_sock *subflow_req = mptcp_subflow_rsk(req);
+	int err;
+
+	while (1) {
+		u32 token;
+
+		mptcp_crypto_key_gen_sha1(&subflow_req->local_key,
+					  &subflow_req->token,
+					  &subflow_req->idsn);
+		pr_debug("req=%p local_key=%llu, token=%u, idsn=%llu\n",
+			 req, subflow_req->local_key, subflow_req->token,
+			 subflow_req->idsn);
+
+		token = subflow_req->token;
+		spin_lock_bh(&token_tree_lock);
+		if (!radix_tree_lookup(&token_req_tree, token) &&
+		    !radix_tree_lookup(&token_tree, token))
+			break;
+		spin_unlock_bh(&token_tree_lock);
+	}
+
+	err = radix_tree_insert(&token_req_tree,
+				subflow_req->token, &token_used);
+	spin_unlock_bh(&token_tree_lock);
+	return err;
+}
+
+/**
+ * mptcp_token_new_connect - create new key/idsn/token for subflow
+ * @sk - the socket that will initiate a connection
+ *
+ * This function is called when a new outgoing mptcp connection is
+ * initiated.
+ *
+ * It creates a unique token to identify the new mptcp connection,
+ * a secret local key and the initial data sequence number (idsn).
+ *
+ * On success, the mptcp connection can be found again using
+ * the computed token at a later time, this is needed to process
+ * join requests.
+ *
+ * returns 0 on success.
+ */
+int mptcp_token_new_connect(struct sock *sk)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+	struct sock *mptcp_sock = subflow->conn;
+	int err;
+
+	while (1) {
+		u32 token;
+
+		mptcp_crypto_key_gen_sha1(&subflow->local_key, &subflow->token,
+					  &subflow->idsn);
+
+		pr_debug("ssk=%p, local_key=%llu, token=%u, idsn=%llu\n",
+			 sk, subflow->local_key, subflow->token, subflow->idsn);
+
+		token = subflow->token;
+		spin_lock_bh(&token_tree_lock);
+		if (!radix_tree_lookup(&token_req_tree, token) &&
+		    !radix_tree_lookup(&token_tree, token))
+			break;
+		spin_unlock_bh(&token_tree_lock);
+	}
+	err = radix_tree_insert(&token_tree, subflow->token, mptcp_sock);
+	spin_unlock_bh(&token_tree_lock);
+
+	return err;
+}
+
+/**
+ * mptcp_token_new_accept - insert token for later processing
+ * @token: the token to insert to the tree
+ *
+ * Called when a SYN packet creates a new logical connection, i.e.
+ * is not a join request.
+ *
+ * We don't have an mptcp socket yet at that point.
+ * This is paired with mptcp_token_update_accept, called on accept().
+ */
+int mptcp_token_new_accept(u32 token)
+{
+	int err;
+
+	spin_lock_bh(&token_tree_lock);
+	err = radix_tree_insert(&token_tree, token, &token_used);
+	spin_unlock_bh(&token_tree_lock);
+
+	return err;
+}
+
+/**
+ * mptcp_token_update_accept - update token to map to mptcp socket
+ * @conn: the new struct mptcp_sock
+ * @sk: the initial subflow for this mptcp socket
+ *
+ * Called when the first mptcp socket is created on accept to
+ * refresh the dummy mapping (done to reserve the token) with
+ * the mptcp_socket structure that wasn't allocated before.
+ */
+void mptcp_token_update_accept(struct sock *sk, struct sock *conn)
+{
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
+	void __rcu **slot;
+
+	spin_lock_bh(&token_tree_lock);
+	slot = radix_tree_lookup_slot(&token_tree, subflow->token);
+	WARN_ON_ONCE(!slot);
+	if (slot) {
+		WARN_ON_ONCE(*slot != &token_used);
+		*slot = conn;
+	}
+	spin_unlock_bh(&token_tree_lock);
+}
+
+/**
+ * mptcp_token_destroy_request - remove mptcp connection/token
+ * @token - token of mptcp connection to remove
+ *
+ * Remove not-yet-fully-established incoming connection identified
+ * by @token.
+ */
+void mptcp_token_destroy_request(u32 token)
+{
+	spin_lock_bh(&token_tree_lock);
+	radix_tree_delete(&token_req_tree, token);
+	spin_unlock_bh(&token_tree_lock);
+}
+
+/**
+ * mptcp_token_destroy - remove mptcp connection/token
+ * @token - token of mptcp connection to remove
+ *
+ * Remove the connection identified by @token.
+ */
+void mptcp_token_destroy(u32 token)
+{
+	spin_lock_bh(&token_tree_lock);
+	radix_tree_delete(&token_tree, token);
+	spin_unlock_bh(&token_tree_lock);
+}
-- 
2.23.0

