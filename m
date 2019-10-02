Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61D4EC94E5
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbfJBXhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:37:23 -0400
Received: from mga04.intel.com ([192.55.52.120]:16452 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728766AbfJBXhV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:37:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:37:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366862584"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.30.230])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 16:37:20 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        cpaasch@apple.com, fw@strlen.de, pabeni@redhat.com,
        peter.krystad@linux.intel.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH v2 05/45] mptcp: Add MPTCP socket stubs
Date:   Wed,  2 Oct 2019 16:36:15 -0700
Message-Id: <20191002233655.24323-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
References: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implements the infrastructure for MPTCP sockets.

MPTCP sockets open one in-kernel TCP socket per subflow. These subflow
sockets are only managed by the MPTCP socket that owns them and are not
visible from userspace. This commit allows a userspace program to open
an MPTCP socket with:

  sock = socket(AF_INET, SOCK_STREAM, IPPROTO_MPTCP);

The resulting socket is simply a wrapper around a single regular TCP
socket, without any of the MPTCP protocol implemented over the wire.

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 include/net/mptcp.h  |  22 +++++++++
 net/Kconfig          |   1 +
 net/Makefile         |   1 +
 net/ipv4/tcp.c       |   2 +
 net/mptcp/Kconfig    |  10 ++++
 net/mptcp/Makefile   |   4 ++
 net/mptcp/protocol.c | 114 +++++++++++++++++++++++++++++++++++++++++++
 net/mptcp/protocol.h |  22 +++++++++
 8 files changed, 176 insertions(+)
 create mode 100644 include/net/mptcp.h
 create mode 100644 net/mptcp/Kconfig
 create mode 100644 net/mptcp/Makefile
 create mode 100644 net/mptcp/protocol.c
 create mode 100644 net/mptcp/protocol.h

diff --git a/include/net/mptcp.h b/include/net/mptcp.h
new file mode 100644
index 000000000000..0fe78fddc638
--- /dev/null
+++ b/include/net/mptcp.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Multipath TCP
+ *
+ * Copyright (c) 2017 - 2019, Intel Corporation.
+ */
+
+#ifndef __NET_MPTCP_H
+#define __NET_MPTCP_H
+
+#ifdef CONFIG_MPTCP
+
+void mptcp_init(void);
+
+#else
+
+static inline void mptcp_init(void)
+{
+}
+
+#endif /* CONFIG_MPTCP */
+#endif /* __NET_MPTCP_H */
diff --git a/net/Kconfig b/net/Kconfig
index 3101bfcbdd7a..4f7e7f3618d0 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -91,6 +91,7 @@ if INET
 source "net/ipv4/Kconfig"
 source "net/ipv6/Kconfig"
 source "net/netlabel/Kconfig"
+source "net/mptcp/Kconfig"
 
 endif # if INET
 
diff --git a/net/Makefile b/net/Makefile
index 449fc0b221f8..306d2e8c12c0 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -87,3 +87,4 @@ endif
 obj-$(CONFIG_QRTR)		+= qrtr/
 obj-$(CONFIG_NET_NCSI)		+= ncsi/
 obj-$(CONFIG_XDP_SOCKETS)	+= xdp/
+obj-$(CONFIG_MPTCP)		+= mptcp/
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 79c325a07ba5..5893d08cb204 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -271,6 +271,7 @@
 #include <net/icmp.h>
 #include <net/inet_common.h>
 #include <net/tcp.h>
+#include <net/mptcp.h>
 #include <net/xfrm.h>
 #include <net/ip.h>
 #include <net/sock.h>
@@ -4006,4 +4007,5 @@ void __init tcp_init(void)
 	tcp_metrics_init();
 	BUG_ON(tcp_register_congestion_control(&tcp_reno) != 0);
 	tcp_tasklet_init();
+	mptcp_init();
 }
diff --git a/net/mptcp/Kconfig b/net/mptcp/Kconfig
new file mode 100644
index 000000000000..d87dfdc210cc
--- /dev/null
+++ b/net/mptcp/Kconfig
@@ -0,0 +1,10 @@
+
+config MPTCP
+	bool "Multipath TCP"
+	depends on INET
+	help
+	  Multipath TCP (MPTCP) connections send and receive data over multiple
+	  subflows in order to utilize multiple network paths. Each subflow
+	  uses the TCP protocol, and TCP options carry header information for
+	  MPTCP.
+
diff --git a/net/mptcp/Makefile b/net/mptcp/Makefile
new file mode 100644
index 000000000000..659129d1fcbf
--- /dev/null
+++ b/net/mptcp/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_MPTCP) += mptcp.o
+
+mptcp-y := protocol.o
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
new file mode 100644
index 000000000000..e5c87cb08f97
--- /dev/null
+++ b/net/mptcp/protocol.c
@@ -0,0 +1,114 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Multipath TCP
+ *
+ * Copyright (c) 2017 - 2019, Intel Corporation.
+ */
+
+#define pr_fmt(fmt) "MPTCP: " fmt
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
+static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct socket *subflow = msk->subflow;
+
+	return sock_sendmsg(subflow, msg);
+}
+
+static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
+			 int nonblock, int flags, int *addr_len)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct socket *subflow = msk->subflow;
+
+	return sock_recvmsg(subflow, msg, flags);
+}
+
+static int mptcp_init_sock(struct sock *sk)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct net *net = sock_net(sk);
+	struct socket *sf;
+	int err;
+
+	err = sock_create_kern(net, PF_INET, SOCK_STREAM, IPPROTO_TCP, &sf);
+	if (!err) {
+		pr_debug("subflow=%p", sf->sk);
+		msk->subflow = sf;
+	}
+
+	return err;
+}
+
+static void mptcp_close(struct sock *sk, long timeout)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
+	inet_sk_state_store(sk, TCP_CLOSE);
+
+	if (msk->subflow) {
+		pr_debug("subflow=%p", msk->subflow->sk);
+		sock_release(msk->subflow);
+	}
+
+	sock_orphan(sk);
+	sock_put(sk);
+}
+
+static int mptcp_connect(struct sock *sk, struct sockaddr *saddr, int len)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	int err;
+
+	saddr->sa_family = AF_INET;
+
+	pr_debug("msk=%p, subflow=%p", msk, msk->subflow->sk);
+
+	err = kernel_connect(msk->subflow, saddr, len, 0);
+
+	sk->sk_state = TCP_ESTABLISHED;
+
+	return err;
+}
+
+static struct proto mptcp_prot = {
+	.name		= "MPTCP",
+	.owner		= THIS_MODULE,
+	.init		= mptcp_init_sock,
+	.close		= mptcp_close,
+	.accept		= inet_csk_accept,
+	.connect	= mptcp_connect,
+	.shutdown	= tcp_shutdown,
+	.sendmsg	= mptcp_sendmsg,
+	.recvmsg	= mptcp_recvmsg,
+	.hash		= inet_hash,
+	.unhash		= inet_unhash,
+	.get_port	= inet_csk_get_port,
+	.obj_size	= sizeof(struct mptcp_sock),
+	.no_autobind	= 1,
+};
+
+static struct inet_protosw mptcp_protosw = {
+	.type		= SOCK_STREAM,
+	.protocol	= IPPROTO_MPTCP,
+	.prot		= &mptcp_prot,
+	.ops		= &inet_stream_ops,
+};
+
+void __init mptcp_init(void)
+{
+	if (proto_register(&mptcp_prot, 1) != 0)
+		panic("Failed to register MPTCP proto.\n");
+
+	inet_register_protosw(&mptcp_protosw);
+}
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
new file mode 100644
index 000000000000..ee04a01bffd3
--- /dev/null
+++ b/net/mptcp/protocol.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Multipath TCP
+ *
+ * Copyright (c) 2017 - 2019, Intel Corporation.
+ */
+
+#ifndef __MPTCP_PROTOCOL_H
+#define __MPTCP_PROTOCOL_H
+
+/* MPTCP connection sock */
+struct mptcp_sock {
+	/* inet_connection_sock must be the first member */
+	struct inet_connection_sock sk;
+	struct socket	*subflow; /* outgoing connect/listener/!mp_capable */
+};
+
+static inline struct mptcp_sock *mptcp_sk(const struct sock *sk)
+{
+	return (struct mptcp_sock *)sk;
+}
+
+#endif /* __MPTCP_PROTOCOL_H */
-- 
2.23.0

