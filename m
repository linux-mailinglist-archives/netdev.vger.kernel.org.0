Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCB1C125267
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 20:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727666AbfLRTzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 14:55:36 -0500
Received: from mga05.intel.com ([192.55.52.43]:2222 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727529AbfLRTzO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 14:55:14 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 11:55:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="213019939"
Received: from mjmartin-nuc01.amr.corp.intel.com ([10.241.98.42])
  by fmsmga008.fm.intel.com with ESMTP; 18 Dec 2019 11:55:13 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Peter Krystad <peter.krystad@linux.intel.com>,
        Florian Westphal <fw@strlen.de>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Davide Caratti <dcaratti@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next v2 03/15] mptcp: Associate MPTCP context with TCP socket
Date:   Wed, 18 Dec 2019 11:54:58 -0800
Message-Id: <20191218195510.7782-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218195510.7782-1-mathew.j.martineau@linux.intel.com>
References: <20191218195510.7782-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Krystad <peter.krystad@linux.intel.com>

Use ULP to associate a subflow_context structure with each TCP subflow
socket. Creating these sockets requires new bind and connect functions
to make sure ULP is set up immediately when the subflow sockets are
created.

Co-developed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Co-developed-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/linux/tcp.h  |   3 +
 net/mptcp/Makefile   |   2 +-
 net/mptcp/protocol.c | 133 +++++++++++++++++++++++++++++++++++++++++--
 net/mptcp/protocol.h |  26 +++++++++
 net/mptcp/subflow.c  | 111 ++++++++++++++++++++++++++++++++++++
 5 files changed, 268 insertions(+), 7 deletions(-)
 create mode 100644 net/mptcp/subflow.c

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 52798ab00394..877947475814 100644
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
index 5e24e7cf7d70..3a24044ee737 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -17,6 +17,54 @@
 #include <net/mptcp.h>
 #include "protocol.h"
 
+#define MPTCP_SAME_STATE TCP_MAX_STATES
+
+/* if msk has a single subflow socket, and the mp_capable handshake is not
+ * completed yet or has failed - that is, the socket is Not MP Capable,
+ * returns it.
+ * Otherwise returns NULL
+ */
+static struct socket *__mptcp_nmpc_socket(const struct mptcp_sock *msk)
+{
+	if (!msk->subflow)
+		return NULL;
+
+	return msk->subflow;
+}
+
+static bool __mptcp_can_create_subflow(const struct mptcp_sock *msk)
+{
+	return ((struct sock *)msk)->sk_state == TCP_CLOSE;
+}
+
+static struct socket *__mptcp_socket_create(struct mptcp_sock *msk, int state)
+{
+	struct mptcp_subflow_context *subflow;
+	struct sock *sk = (struct sock *)msk;
+	struct socket *ssock;
+	int err;
+
+	ssock = __mptcp_nmpc_socket(msk);
+	if (ssock)
+		goto set_state;
+
+	if (!__mptcp_can_create_subflow(msk))
+		return ERR_PTR(-EINVAL);
+
+	err = mptcp_subflow_create_socket(sk, &ssock);
+	if (err)
+		return ERR_PTR(err);
+
+	msk->subflow = ssock;
+	subflow = mptcp_subflow_ctx(ssock->sk);
+	subflow->request_mptcp = 1; /* @@ if MPTCP enabled */
+
+set_state:
+	if (state != MPTCP_SAME_STATE)
+		inet_sk_state_store(sk, state);
+	return ssock;
+}
+
 static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -48,12 +96,14 @@ static int mptcp_init_sock(struct sock *sk)
 static void mptcp_close(struct sock *sk, long timeout)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct socket *ssock;
 
 	inet_sk_state_store(sk, TCP_CLOSE);
 
-	if (msk->subflow) {
-		pr_debug("subflow=%p", msk->subflow->sk);
-		sock_release(msk->subflow);
+	ssock = __mptcp_nmpc_socket(msk);
+	if (ssock) {
+		pr_debug("subflow=%p", mptcp_subflow_ctx(ssock->sk));
+		sock_release(ssock);
 	}
 
 	sock_orphan(sk);
@@ -67,7 +117,8 @@ static int mptcp_connect(struct sock *sk, struct sockaddr *saddr, int len)
 
 	saddr->sa_family = AF_INET;
 
-	pr_debug("msk=%p, subflow=%p", msk, msk->subflow->sk);
+	pr_debug("msk=%p, subflow=%p", msk,
+		 mptcp_subflow_ctx(msk->subflow->sk));
 
 	err = kernel_connect(msk->subflow, saddr, len, 0);
 
@@ -93,15 +144,79 @@ static struct proto mptcp_prot = {
 	.no_autobind	= true,
 };
 
+static int mptcp_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
+{
+	struct mptcp_sock *msk = mptcp_sk(sock->sk);
+	struct socket *ssock;
+	int err = -ENOTSUPP;
+
+	if (uaddr->sa_family != AF_INET) // @@ allow only IPv4 for now
+		return err;
+
+	lock_sock(sock->sk);
+	ssock = __mptcp_socket_create(msk, MPTCP_SAME_STATE);
+	if (IS_ERR(ssock)) {
+		err = PTR_ERR(ssock);
+		goto unlock;
+	}
+
+	err = ssock->ops->bind(ssock, uaddr, addr_len);
+
+unlock:
+	release_sock(sock->sk);
+	return err;
+}
+
+static int mptcp_stream_connect(struct socket *sock, struct sockaddr *uaddr,
+				int addr_len, int flags)
+{
+	struct mptcp_sock *msk = mptcp_sk(sock->sk);
+	struct socket *ssock;
+	int err;
+
+	lock_sock(sock->sk);
+	ssock = __mptcp_socket_create(msk, TCP_SYN_SENT);
+	if (IS_ERR(ssock)) {
+		err = PTR_ERR(ssock);
+		goto unlock;
+	}
+
+	err = ssock->ops->connect(ssock, uaddr, addr_len, flags);
+	inet_sk_state_store(sock->sk, inet_sk_state_load(ssock->sk));
+
+unlock:
+	release_sock(sock->sk);
+	return err;
+}
+
+static __poll_t mptcp_poll(struct file *file, struct socket *sock,
+			   struct poll_table_struct *wait)
+{
+	__poll_t mask = 0;
+
+	return mask;
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
+	mptcp_stream_ops.poll = mptcp_poll;
+
+	mptcp_subflow_init();
+
 	if (proto_register(&mptcp_prot, 1) != 0)
 		panic("Failed to register MPTCP proto.\n");
 
@@ -109,13 +224,14 @@ void __init mptcp_init(void)
 }
 
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
+static struct proto_ops mptcp_v6_stream_ops;
 static struct proto mptcp_v6_prot;
 
 static struct inet_protosw mptcp_v6_protosw = {
 	.type		= SOCK_STREAM,
 	.protocol	= IPPROTO_MPTCP,
 	.prot		= &mptcp_v6_prot,
-	.ops		= &inet6_stream_ops,
+	.ops		= &mptcp_v6_stream_ops,
 	.flags		= INET_PROTOSW_ICSK,
 };
 
@@ -133,6 +249,11 @@ int mptcpv6_init(void)
 	if (err)
 		return err;
 
+	mptcp_v6_stream_ops = inet6_stream_ops;
+	mptcp_v6_stream_ops.bind = mptcp_bind;
+	mptcp_v6_stream_ops.connect = mptcp_stream_connect;
+	mptcp_v6_stream_ops.poll = mptcp_poll;
+
 	err = inet6_register_protosw(&mptcp_v6_protosw);
 	if (err)
 		proto_unregister(&mptcp_v6_prot);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index c59cf8b220b0..543d4d5d8985 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -48,4 +48,30 @@ static inline struct mptcp_sock *mptcp_sk(const struct sock *sk)
 	return (struct mptcp_sock *)sk;
 }
 
+/* MPTCP subflow context */
+struct mptcp_subflow_context {
+	u32	request_mptcp : 1;  /* send MP_CAPABLE */
+	struct	sock *tcp_sock;	    /* tcp sk backpointer */
+	struct	sock *conn;	    /* parent mptcp_sock */
+	struct	rcu_head rcu;
+};
+
+static inline struct mptcp_subflow_context *
+mptcp_subflow_ctx(const struct sock *sk)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+
+	/* Use RCU on icsk_ulp_data only for sock diag code */
+	return (__force struct mptcp_subflow_context *)icsk->icsk_ulp_data;
+}
+
+static inline struct sock *
+mptcp_subflow_tcp_sock(const struct mptcp_subflow_context *subflow)
+{
+	return subflow->tcp_sock;
+}
+
+void mptcp_subflow_init(void);
+int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock);
+
 #endif /* __MPTCP_PROTOCOL_H */
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
new file mode 100644
index 000000000000..9e2ff5b40d13
--- /dev/null
+++ b/net/mptcp/subflow.c
@@ -0,0 +1,111 @@
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
+int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock)
+{
+	struct mptcp_subflow_context *subflow;
+	struct net *net = sock_net(sk);
+	struct socket *sf;
+	int err;
+
+	err = sock_create_kern(net, PF_INET, SOCK_STREAM, IPPROTO_TCP, &sf);
+	if (err)
+		return err;
+
+	lock_sock(sf->sk);
+	err = tcp_set_ulp(sf->sk, "mptcp");
+	release_sock(sf->sk);
+
+	if (err)
+		return err;
+
+	subflow = mptcp_subflow_ctx(sf->sk);
+	pr_debug("subflow=%p", subflow);
+
+	*new_sock = sf;
+	subflow->conn = sk;
+
+	return 0;
+}
+
+static struct mptcp_subflow_context *subflow_create_ctx(struct sock *sk,
+							gfp_t priority)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+	struct mptcp_subflow_context *ctx;
+
+	ctx = kzalloc(sizeof(*ctx), priority);
+	if (!ctx)
+		return NULL;
+	rcu_assign_pointer(icsk->icsk_ulp_data, ctx);
+
+	pr_debug("subflow=%p", ctx);
+
+	ctx->tcp_sock = sk;
+
+	return ctx;
+}
+
+static int subflow_ulp_init(struct sock *sk)
+{
+	struct mptcp_subflow_context *ctx;
+	struct tcp_sock *tp = tcp_sk(sk);
+	int err = 0;
+
+	/* disallow attaching ULP to a socket unless it has been
+	 * created with sock_create_kern()
+	 */
+	if (!sk->sk_kern_sock) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	ctx = subflow_create_ctx(sk, GFP_KERNEL);
+	if (!ctx) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	pr_debug("subflow=%p, family=%d", ctx, sk->sk_family);
+
+	tp->is_mptcp = 1;
+out:
+	return err;
+}
+
+static void subflow_ulp_release(struct sock *sk)
+{
+	struct mptcp_subflow_context *ctx = mptcp_subflow_ctx(sk);
+
+	if (!ctx)
+		return;
+
+	kfree_rcu(ctx, rcu);
+}
+
+static struct tcp_ulp_ops subflow_ulp_ops __read_mostly = {
+	.name		= "mptcp",
+	.owner		= THIS_MODULE,
+	.init		= subflow_ulp_init,
+	.release	= subflow_ulp_release,
+};
+
+void mptcp_subflow_init(void)
+{
+	if (tcp_register_ulp(&subflow_ulp_ops) != 0)
+		panic("MPTCP: failed to register subflows to ULP\n");
+}
-- 
2.24.1

