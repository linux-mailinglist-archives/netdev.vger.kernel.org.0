Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9D649584
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728624AbfFQW6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:58:53 -0400
Received: from mga18.intel.com ([134.134.136.126]:10995 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727711AbfFQW6v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 18:58:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 15:58:49 -0700
X-ExtLoop1: 1
Received: from mjmartin-nuc01.amr.corp.intel.com (HELO mjmartin-nuc01.sea.intel.com) ([10.241.98.42])
  by orsmga002.jf.intel.com with ESMTP; 17 Jun 2019 15:58:49 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     edumazet@google.com, netdev@vger.kernel.org
Cc:     Peter Krystad <peter.krystad@linux.intel.com>, cpaasch@apple.com,
        fw@strlen.de, pabeni@redhat.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH net-next 05/33] mptcp: Associate MPTCP context with TCP socket
Date:   Mon, 17 Jun 2019 15:57:40 -0700
Message-Id: <20190617225808.665-6-mathew.j.martineau@linux.intel.com>
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

Use ULP to associate a subflow_context structure with each TCP
subflow socket.

Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 include/linux/tcp.h  |  3 ++
 net/mptcp/Makefile   |  2 +-
 net/mptcp/protocol.c | 96 +++++++++++++++++++++++++++++++++++++-------
 net/mptcp/protocol.h | 24 +++++++++++
 net/mptcp/subflow.c  | 76 +++++++++++++++++++++++++++++++++++
 5 files changed, 185 insertions(+), 16 deletions(-)
 create mode 100644 net/mptcp/subflow.c

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 73c633f58233..b8c24bd8c862 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -397,6 +397,9 @@ struct tcp_sock {
 	u32	mtu_info; /* We received an ICMP_FRAG_NEEDED / ICMPV6_PKT_TOOBIG
 			   * while socket was owned by user.
 			   */
+#if IS_ENABLED(CONFIG_MPTCP)
+	bool	is_mptcp;
+#endif
 
 #ifdef CONFIG_TCP_MD5SIG
 /* TCP AF-Specific parts; only used by MD5 Signature support so far */
diff --git a/net/mptcp/Makefile b/net/mptcp/Makefile
index 27a846263f08..e1ee5aade8b0 100644
--- a/net/mptcp/Makefile
+++ b/net/mptcp/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_MPTCP) += mptcp.o
 
-mptcp-y := protocol.o options.o
+mptcp-y := protocol.o subflow.o options.o
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index e57ee600df7f..ce2374ea7871 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -20,7 +20,7 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct socket *subflow = msk->subflow;
 
-	pr_debug("subflow=%p", subflow->sk);
+	pr_debug("subflow=%p", subflow_ctx(subflow->sk));
 
 	return sock_sendmsg(subflow, msg);
 }
@@ -31,7 +31,7 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct socket *subflow = msk->subflow;
 
-	pr_debug("subflow=%p", subflow->sk);
+	pr_debug("subflow=%p", subflow_ctx(subflow->sk));
 
 	return sock_recvmsg(subflow, msg, flags);
 }
@@ -39,19 +39,10 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 static int mptcp_init_sock(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
-	struct net *net = sock_net(sk);
-	struct socket *sf;
-	int err;
 
 	pr_debug("msk=%p", msk);
 
-	err = sock_create_kern(net, PF_INET, SOCK_STREAM, IPPROTO_TCP, &sf);
-	if (!err) {
-		pr_debug("subflow=%p", sf->sk);
-		msk->subflow = sf;
-	}
-
-	return err;
+	return 0;
 }
 
 static void mptcp_close(struct sock *sk, long timeout)
@@ -61,7 +52,7 @@ static void mptcp_close(struct sock *sk, long timeout)
 	inet_sk_state_store(sk, TCP_CLOSE);
 
 	if (msk->subflow) {
-		pr_debug("subflow=%p", msk->subflow->sk);
+		pr_debug("subflow=%p", subflow_ctx(msk->subflow->sk));
 		sock_release(msk->subflow);
 	}
 
@@ -76,7 +67,7 @@ static int mptcp_connect(struct sock *sk, struct sockaddr *saddr, int len)
 
 	saddr->sa_family = AF_INET;
 
-	pr_debug("msk=%p, subflow=%p", msk, msk->subflow->sk);
+	pr_debug("msk=%p, subflow=%p", msk, subflow_ctx(msk->subflow->sk));
 
 	err = kernel_connect(msk->subflow, saddr, len, 0);
 
@@ -102,15 +93,90 @@ static struct proto mptcp_prot = {
 	.no_autobind	= 1,
 };
 
+static int mptcp_subflow_create(struct sock *sk)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct net *net = sock_net(sk);
+	struct socket *sf;
+	int err;
+
+	pr_debug("msk=%p", msk);
+	err = sock_create_kern(net, PF_INET, SOCK_STREAM, IPPROTO_TCP, &sf);
+	if (!err) {
+		lock_sock(sf->sk);
+		err = tcp_set_ulp(sf->sk, "mptcp");
+		release_sock(sf->sk);
+		if (!err) {
+			struct subflow_context *subflow = subflow_ctx(sf->sk);
+
+			pr_debug("subflow=%p", subflow);
+			msk->subflow = sf;
+			subflow->conn = sk;
+			subflow->request_mptcp = 1; // @@ if MPTCP enabled
+			subflow->request_cksum = 1; // @@ if checksum enabled
+			subflow->version = 0;
+		}
+	}
+	return err;
+}
+
+static int mptcp_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
+{
+	struct mptcp_sock *msk = mptcp_sk(sock->sk);
+	int err = -ENOTSUPP;
+
+	pr_debug("msk=%p", msk);
+
+	if (uaddr->sa_family != AF_INET) // @@ allow only IPv4 for now
+		return err;
+
+	if (!msk->subflow) {
+		err = mptcp_subflow_create(sock->sk);
+		if (err)
+			return err;
+	}
+	return inet_bind(msk->subflow, uaddr, addr_len);
+}
+
+static int mptcp_stream_connect(struct socket *sock, struct sockaddr *uaddr,
+				int addr_len, int flags)
+{
+	struct mptcp_sock *msk = mptcp_sk(sock->sk);
+	int err = -ENOTSUPP;
+
+	pr_debug("msk=%p", msk);
+
+	if (uaddr->sa_family != AF_INET) // @@ allow only IPv4 for now
+		return err;
+
+	if (!msk->subflow) {
+		err = mptcp_subflow_create(sock->sk);
+		if (err)
+			return err;
+	}
+
+	return inet_stream_connect(msk->subflow, uaddr, addr_len, flags);
+}
+
+static struct proto_ops mptcp_stream_ops;
+
 static struct inet_protosw mptcp_protosw = {
 	.type		= SOCK_STREAM,
 	.protocol	= IPPROTO_MPTCP,
 	.prot		= &mptcp_prot,
-	.ops		= &inet_stream_ops,
+	.ops		= &mptcp_stream_ops,
+	.flags		= INET_PROTOSW_ICSK,
 };
 
 void __init mptcp_init(void)
 {
+	mptcp_prot.h.hashinfo = tcp_prot.h.hashinfo;
+	mptcp_stream_ops = inet_stream_ops;
+	mptcp_stream_ops.bind = mptcp_bind;
+	mptcp_stream_ops.connect = mptcp_stream_connect;
+
+	subflow_init();
+
 	if (proto_register(&mptcp_prot, 1) != 0)
 		panic("Failed to register MPTCP proto.\n");
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index ac57e10ec4ca..b6adc2aa6222 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -41,4 +41,28 @@ static inline struct mptcp_sock *mptcp_sk(const struct sock *sk)
 	return (struct mptcp_sock *)sk;
 }
 
+/* MPTCP subflow context */
+struct subflow_context {
+	u32	request_mptcp : 1,  /* send MP_CAPABLE */
+		request_cksum : 1,
+		version : 4;
+	struct  socket *tcp_sock;  /* underlying tcp_sock */
+	struct  sock *conn;        /* parent mptcp_sock */
+};
+
+static inline struct subflow_context *subflow_ctx(const struct sock *sk)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+
+	return (struct subflow_context *)icsk->icsk_ulp_data;
+}
+
+static inline struct socket *
+mptcp_subflow_tcp_socket(const struct subflow_context *subflow)
+{
+	return subflow->tcp_sock;
+}
+
+void subflow_init(void);
+
 #endif /* __MPTCP_PROTOCOL_H */
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
new file mode 100644
index 000000000000..8d13713ee159
--- /dev/null
+++ b/net/mptcp/subflow.c
@@ -0,0 +1,76 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Multipath TCP
+ *
+ * Copyright (c) 2017 - 2019, Intel Corporation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <net/sock.h>
+#include <net/inet_common.h>
+#include <net/inet_hashtables.h>
+#include <net/protocol.h>
+#include <net/tcp.h>
+#include <net/mptcp.h>
+#include "protocol.h"
+
+static struct subflow_context *subflow_create_ctx(struct sock *sk,
+						  struct socket *sock)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+	struct subflow_context *ctx;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return NULL;
+
+	pr_debug("subflow=%p", ctx);
+
+	icsk->icsk_ulp_data = ctx;
+	/* might be NULL */
+	ctx->tcp_sock = sock;
+
+	return ctx;
+}
+
+static int subflow_ulp_init(struct sock *sk)
+{
+	struct tcp_sock *tsk = tcp_sk(sk);
+	struct subflow_context *ctx;
+	int err = 0;
+
+	ctx = subflow_create_ctx(sk, sk->sk_socket);
+	if (!ctx) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	pr_debug("subflow=%p", ctx);
+
+	tsk->is_mptcp = 1;
+out:
+	return err;
+}
+
+static void subflow_ulp_release(struct sock *sk)
+{
+	struct subflow_context *ctx = subflow_ctx(sk);
+
+	pr_debug("subflow=%p", ctx);
+
+	kfree(ctx);
+}
+
+static struct tcp_ulp_ops subflow_ulp_ops __read_mostly = {
+	.name		= "mptcp",
+	.owner		= THIS_MODULE,
+	.init		= subflow_ulp_init,
+	.release	= subflow_ulp_release,
+};
+
+void subflow_init(void)
+{
+	if (tcp_register_ulp(&subflow_ulp_ops) != 0)
+		panic("MPTCP: failed to register subflows to ULP\n");
+}
-- 
2.22.0

