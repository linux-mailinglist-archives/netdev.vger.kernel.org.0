Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6551449B7
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 03:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgAVCOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 21:14:18 -0500
Received: from nwk-aaemail-lapp03.apple.com ([17.151.62.68]:35522 "EHLO
        nwk-aaemail-lapp03.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726811AbgAVCOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 21:14:18 -0500
Received: from pps.filterd (nwk-aaemail-lapp03.apple.com [127.0.0.1])
        by nwk-aaemail-lapp03.apple.com (8.16.0.27/8.16.0.27) with SMTP id 00M0urnV013197;
        Tue, 21 Jan 2020 16:57:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=mime-version :
 content-transfer-encoding : content-type : sender : from : to : cc :
 subject : date : message-id : in-reply-to : references; s=20180706;
 bh=3Ptb5LhGEm6ejujC94kElIb8Z//RsMWJgs6ThCk3eO0=;
 b=o+mWsLCWYo/9GC7zzUoVozkJPGY9ocop3vkmzDCzzo76m3Zzr4sXEYWcvyv3EzGv3ZF2
 Wu6w5HCKkbO07teYQ2ue1m4hGpt7tUAVJFHoxbz7gnEPY6VkC23LooudzzzsmEQRUsXZ
 ywOMZeM/pnus39BPVBxNDf1oFABh4DXs0lZHyjgdA9ccwTBVT0mXcUALRG5D+lMKL0EY
 vJpb6jQMott8+RoZYvjP+dwe49l7uoE7RXOJNOvMOTLc2AaiFicS1WkcngdTnjPxjBce
 Pb8v5W8+VpfQU2a85S66XUb4ZSJc1Hd4EUCwpC8sBCul41NnVy+uhzO9tvRRbMyQtkeP 1w== 
Received: from ma1-mtap-s01.corp.apple.com (ma1-mtap-s01.corp.apple.com [17.40.76.5])
        by nwk-aaemail-lapp03.apple.com with ESMTP id 2xmk4p1699-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Tue, 21 Jan 2020 16:57:05 -0800
Received: from nwk-mmpp-sz13.apple.com
 (nwk-mmpp-sz13.apple.com [17.128.115.216]) by ma1-mtap-s01.corp.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPS id <0Q4H00HWQHAUJ720@ma1-mtap-s01.corp.apple.com>; Tue,
 21 Jan 2020 16:57:02 -0800 (PST)
Received: from process_milters-daemon.nwk-mmpp-sz13.apple.com by
 nwk-mmpp-sz13.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) id <0Q4H00100GR2PR00@nwk-mmpp-sz13.apple.com>; Tue,
 21 Jan 2020 16:57:00 -0800 (PST)
X-Va-A: 
X-Va-T-CD: 4b1e0bf36502e052fc75ad21b706ed24
X-Va-E-CD: 25f8c37576da6baeedc9284dc0dc2333
X-Va-R-CD: 16e1daedfa7ee51e002803f96974a4c5
X-Va-CD: 0
X-Va-ID: 4a0df259-c6d7-4a61-ab9d-52bcbd26ed74
X-V-A:  
X-V-T-CD: 4b1e0bf36502e052fc75ad21b706ed24
X-V-E-CD: 25f8c37576da6baeedc9284dc0dc2333
X-V-R-CD: 16e1daedfa7ee51e002803f96974a4c5
X-V-CD: 0
X-V-ID: f92ed012-60a1-4759-86ca-3d0c79bf8a6f
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,,
 definitions=2020-01-17_05:,, signatures=0
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
Received: from localhost ([17.192.155.241]) by nwk-mmpp-sz13.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPSA id <0Q4H0011XHAZ4Y50@nwk-mmpp-sz13.apple.com>; Tue,
 21 Jan 2020 16:56:59 -0800 (PST)
From:   Christoph Paasch <cpaasch@apple.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, Peter Krystad <peter.krystad@linux.intel.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next v3 06/19] mptcp: Add key generation and token tree
Date:   Tue, 21 Jan 2020 16:56:20 -0800
Message-id: <20200122005633.21229-7-cpaasch@apple.com>
X-Mailer: git-send-email 2.23.0
In-reply-to: <20200122005633.21229-1-cpaasch@apple.com>
References: <20200122005633.21229-1-cpaasch@apple.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2020-01-17_05:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Krystad <peter.krystad@linux.intel.com>

Generate the local keys, IDSN, and token when creating a new socket.
Introduce the token tree to track all tokens in use using a radix tree
with the MPTCP token itself as the index.

Override the rebuild_header callback in inet_connection_sock_af_ops for
creating the local key on a new outgoing connection.

Override the init_req callback of tcp_request_sock_ops for creating the
local key on a new incoming connection.

Will be used to obtain the MPTCP parent socket to handle incoming joins.

Co-developed-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Co-developed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Christoph Paasch <cpaasch@apple.com>
---
 net/mptcp/Makefile   |   2 +-
 net/mptcp/crypto.c   | 122 +++++++++++++++++++++++++++
 net/mptcp/protocol.c |  16 ++++
 net/mptcp/protocol.h |  32 +++++++
 net/mptcp/subflow.c  |  69 +++++++++++++--
 net/mptcp/token.c    | 195 +++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 428 insertions(+), 8 deletions(-)
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
index 000000000000..bbd6d01af211
--- /dev/null
+++ b/net/mptcp/crypto.c
@@ -0,0 +1,122 @@
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
+#include <asm/unaligned.h>
+
+#include "protocol.h"
+
+struct sha1_state {
+	u32 workspace[SHA_WORKSPACE_WORDS];
+	u32 digest[SHA_DIGEST_WORDS];
+	unsigned int count;
+};
+
+static void sha1_init(struct sha1_state *state)
+{
+	sha_init(state->digest);
+	state->count = 0;
+}
+
+static void sha1_update(struct sha1_state *state, u8 *input)
+{
+	sha_transform(state->digest, input, state->workspace);
+	state->count += SHA_MESSAGE_BYTES;
+}
+
+static void sha1_pad_final(struct sha1_state *state, u8 *input,
+			   unsigned int length, __be32 *mptcp_hashed_key)
+{
+	int i;
+
+	input[length] = 0x80;
+	memset(&input[length + 1], 0, SHA_MESSAGE_BYTES - length - 9);
+	put_unaligned_be64((length + state->count) << 3,
+			   &input[SHA_MESSAGE_BYTES - 8]);
+
+	sha_transform(state->digest, input, state->workspace);
+	for (i = 0; i < SHA_DIGEST_WORDS; ++i)
+		put_unaligned_be32(state->digest[i], &mptcp_hashed_key[i]);
+
+	memzero_explicit(state->workspace, SHA_WORKSPACE_WORDS << 2);
+}
+
+void mptcp_crypto_key_sha(u64 key, u32 *token, u64 *idsn)
+{
+	__be32 mptcp_hashed_key[SHA_DIGEST_WORDS];
+	u8 input[SHA_MESSAGE_BYTES];
+	struct sha1_state state;
+
+	sha1_init(&state);
+	put_unaligned_be64(key, input);
+	sha1_pad_final(&state, input, 8, mptcp_hashed_key);
+
+	if (token)
+		*token = be32_to_cpu(mptcp_hashed_key[0]);
+	if (idsn)
+		*idsn = be64_to_cpu(*((__be64 *)&mptcp_hashed_key[3]));
+}
+
+void mptcp_crypto_hmac_sha(u64 key1, u64 key2, u32 nonce1, u32 nonce2,
+			   u32 *hash_out)
+{
+	u8 input[SHA_MESSAGE_BYTES * 2];
+	struct sha1_state state;
+	u8 key1be[8];
+	u8 key2be[8];
+	int i;
+
+	put_unaligned_be64(key1, key1be);
+	put_unaligned_be64(key2, key2be);
+
+	/* Generate key xored with ipad */
+	memset(input, 0x36, SHA_MESSAGE_BYTES);
+	for (i = 0; i < 8; i++)
+		input[i] ^= key1be[i];
+	for (i = 0; i < 8; i++)
+		input[i + 8] ^= key2be[i];
+
+	put_unaligned_be32(nonce1, &input[SHA_MESSAGE_BYTES]);
+	put_unaligned_be32(nonce2, &input[SHA_MESSAGE_BYTES + 4]);
+
+	sha1_init(&state);
+	sha1_update(&state, input);
+
+	/* emit sha256(K1 || msg) on the second input block, so we can
+	 * reuse 'input' for the last hashing
+	 */
+	sha1_pad_final(&state, &input[SHA_MESSAGE_BYTES], 8,
+		       (__force __be32 *)&input[SHA_MESSAGE_BYTES]);
+
+	/* Prepare second part of hmac */
+	memset(input, 0x5C, SHA_MESSAGE_BYTES);
+	for (i = 0; i < 8; i++)
+		input[i] ^= key1be[i];
+	for (i = 0; i < 8; i++)
+		input[i + 8] ^= key2be[i];
+
+	sha1_init(&state);
+	sha1_update(&state, input);
+	sha1_pad_final(&state, &input[SHA_MESSAGE_BYTES], SHA_DIGEST_WORDS << 2,
+		       (__be32 *)hash_out);
+}
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index e08a25eabcd5..3f66b6a3bb28 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -201,6 +201,7 @@ static void mptcp_close(struct sock *sk, long timeout)
 	struct mptcp_subflow_context *subflow, *tmp;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
+	mptcp_token_destroy(msk->token);
 	inet_sk_state_store(sk, TCP_CLOSE);
 
 	lock_sock(sk);
@@ -281,8 +282,10 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 		msk = mptcp_sk(new_mptcp_sock);
 		msk->remote_key = subflow->remote_key;
 		msk->local_key = subflow->local_key;
+		msk->token = subflow->token;
 		msk->subflow = NULL;
 
+		mptcp_token_update_accept(newsk, new_mptcp_sock);
 		newsk = new_mptcp_sock;
 		mptcp_copy_inaddrs(newsk, ssk);
 		list_add(&subflow->node, &msk->conn_list);
@@ -299,6 +302,10 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 	return newsk;
 }
 
+static void mptcp_destroy(struct sock *sk)
+{
+}
+
 static int mptcp_get_port(struct sock *sk, unsigned short snum)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -331,6 +338,7 @@ void mptcp_finish_connect(struct sock *ssk)
 	 */
 	WRITE_ONCE(msk->remote_key, subflow->remote_key);
 	WRITE_ONCE(msk->local_key, subflow->local_key);
+	WRITE_ONCE(msk->token, subflow->token);
 }
 
 static void mptcp_sock_graft(struct sock *sk, struct socket *parent)
@@ -349,6 +357,7 @@ static struct proto mptcp_prot = {
 	.close		= mptcp_close,
 	.accept		= mptcp_accept,
 	.shutdown	= tcp_shutdown,
+	.destroy	= mptcp_destroy,
 	.sendmsg	= mptcp_sendmsg,
 	.recvmsg	= mptcp_recvmsg,
 	.hash		= inet_hash,
@@ -568,6 +577,12 @@ void __init mptcp_init(void)
 static struct proto_ops mptcp_v6_stream_ops;
 static struct proto mptcp_v6_prot;
 
+static void mptcp_v6_destroy(struct sock *sk)
+{
+	mptcp_destroy(sk);
+	inet6_destroy_sock(sk);
+}
+
 static struct inet_protosw mptcp_v6_protosw = {
 	.type		= SOCK_STREAM,
 	.protocol	= IPPROTO_MPTCP,
@@ -583,6 +598,7 @@ int mptcpv6_init(void)
 	mptcp_v6_prot = mptcp_prot;
 	strcpy(mptcp_v6_prot.name, "MPTCPv6");
 	mptcp_v6_prot.slab = NULL;
+	mptcp_v6_prot.destroy = mptcp_v6_destroy;
 	mptcp_v6_prot.obj_size = sizeof(struct mptcp_sock) +
 				 sizeof(struct ipv6_pinfo);
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index bd66e7415515..5f43fa0275c0 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -7,6 +7,10 @@
 #ifndef __MPTCP_PROTOCOL_H
 #define __MPTCP_PROTOCOL_H
 
+#include <linux/random.h>
+#include <net/tcp.h>
+#include <net/inet_connection_sock.h>
+
 #define MPTCP_SUPPORTED_VERSION	0
 
 /* MPTCP option bits */
@@ -42,6 +46,7 @@ struct mptcp_sock {
 	struct inet_connection_sock sk;
 	u64		local_key;
 	u64		remote_key;
+	u32		token;
 	struct list_head conn_list;
 	struct socket	*subflow; /* outgoing connect/listener/!mp_capable */
 };
@@ -61,6 +66,8 @@ struct mptcp_subflow_request_sock {
 		backup : 1;
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
 		mp_capable : 1,	    /* remote is MPTCP capable */
 		fourth_ack : 1,	    /* send initial DSS */
@@ -112,4 +121,27 @@ void mptcp_get_options(const struct sk_buff *skb,
 
 void mptcp_finish_connect(struct sock *sk);
 
+int mptcp_token_new_request(struct request_sock *req);
+void mptcp_token_destroy_request(u32 token);
+int mptcp_token_new_connect(struct sock *sk);
+int mptcp_token_new_accept(u32 token);
+void mptcp_token_update_accept(struct sock *sk, struct sock *conn);
+void mptcp_token_destroy(u32 token);
+
+void mptcp_crypto_key_sha(u64 key, u32 *token, u64 *idsn);
+static inline void mptcp_crypto_key_gen_sha(u64 *key, u32 *token, u64 *idsn)
+{
+	/* we might consider a faster version that computes the key as a
+	 * hash of some information available in the MPTCP socket. Use
+	 * random data at the moment, as it's probably the safest option
+	 * in case multiple sockets are opened in different namespaces at
+	 * the same time.
+	 */
+	get_random_bytes(key, sizeof(u64));
+	mptcp_crypto_key_sha(*key, token, idsn);
+}
+
+void mptcp_crypto_hmac_sha(u64 key1, u64 key2, u32 nonce1, u32 nonce2,
+			   u32 *hash_out);
+
 #endif /* __MPTCP_PROTOCOL_H */
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index df3192305967..89b91bc7a831 100644
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
@@ -18,6 +20,33 @@
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
+	return subflow->icsk_af_ops->rebuild_header(sk);
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
 static void subflow_init_req(struct request_sock *req,
 			     const struct sock *sk_listener,
 			     struct sk_buff *skb)
@@ -42,7 +71,12 @@ static void subflow_init_req(struct request_sock *req,
 #endif
 
 	if (rx_opt.mptcp.mp_capable && listener->request_mptcp) {
-		subflow_req->mp_capable = 1;
+		int err;
+
+		err = mptcp_token_new_request(req);
+		if (err == 0)
+			subflow_req->mp_capable = 1;
+
 		subflow_req->remote_key = rx_opt.mptcp.sndr_key;
 	}
 }
@@ -150,16 +184,28 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 						     req_unhash, own_req);
 
 	if (child && *own_req) {
-		if (!mptcp_subflow_ctx(child)) {
-			pr_debug("Closing child socket");
-			inet_sk_set_state(child, TCP_CLOSE);
-			sock_set_flag(child, SOCK_DEAD);
-			inet_csk_destroy_sock(child);
-			child = NULL;
+		struct mptcp_subflow_context *ctx = mptcp_subflow_ctx(child);
+
+		/* we have null ctx on TCP fallback, not fatal on MPC
+		 * handshake
+		 */
+		if (!ctx)
+			return child;
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
+	tcp_send_active_reset(child, GFP_ATOMIC);
+	inet_csk_prepare_forced_close(child);
+	tcp_done(child);
+	return NULL;
 }
 
 static struct inet_connection_sock_af_ops subflow_specific;
@@ -224,6 +270,7 @@ int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock)
 	pr_debug("subflow=%p", subflow);
 
 	*new_sock = sf;
+	sock_hold(sk);
 	subflow->conn = sk;
 
 	return 0;
@@ -286,6 +333,9 @@ static void subflow_ulp_release(struct sock *sk)
 	if (!ctx)
 		return;
 
+	if (ctx->conn)
+		sock_put(ctx->conn);
+
 	kfree_rcu(ctx, rcu);
 }
 
@@ -323,6 +373,7 @@ static void subflow_ulp_clone(const struct request_sock *req,
 	new_ctx->fourth_ack = 1;
 	new_ctx->remote_key = subflow_req->remote_key;
 	new_ctx->local_key = subflow_req->local_key;
+	new_ctx->token = subflow_req->token;
 }
 
 static struct tcp_ulp_ops subflow_ulp_ops __read_mostly = {
@@ -346,6 +397,8 @@ static int subflow_ops_init(struct request_sock_ops *subflow_ops)
 	if (!subflow_ops->slab)
 		return -ENOMEM;
 
+	subflow_ops->destructor = subflow_req_destructor;
+
 	return 0;
 }
 
@@ -362,6 +415,7 @@ void mptcp_subflow_init(void)
 	subflow_specific.conn_request = subflow_v4_conn_request;
 	subflow_specific.syn_recv_sock = subflow_syn_recv_sock;
 	subflow_specific.sk_rx_dst_set = subflow_finish_connect;
+	subflow_specific.rebuild_header = subflow_rebuild_header;
 
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 	subflow_request_sock_ipv6_ops = tcp_request_sock_ipv6_ops;
@@ -371,6 +425,7 @@ void mptcp_subflow_init(void)
 	subflow_v6_specific.conn_request = subflow_v6_conn_request;
 	subflow_v6_specific.syn_recv_sock = subflow_syn_recv_sock;
 	subflow_v6_specific.sk_rx_dst_set = subflow_finish_connect;
+	subflow_v6_specific.rebuild_header = subflow_rebuild_header;
 
 	subflow_v6m_specific = subflow_v6_specific;
 	subflow_v6m_specific.queue_xmit = ipv4_specific.queue_xmit;
diff --git a/net/mptcp/token.c b/net/mptcp/token.c
new file mode 100644
index 000000000000..84d887806090
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
+		mptcp_crypto_key_gen_sha(&subflow_req->local_key,
+					 &subflow_req->token,
+					 &subflow_req->idsn);
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
+		mptcp_crypto_key_gen_sha(&subflow->local_key, &subflow->token,
+					 &subflow->idsn);
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
+		WARN_ON_ONCE(rcu_access_pointer(*slot) != &token_used);
+		radix_tree_replace_slot(&token_tree, slot, conn);
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

