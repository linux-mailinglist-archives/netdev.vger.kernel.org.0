Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA3CAC9506
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729428AbfJBXiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:38:19 -0400
Received: from mga04.intel.com ([192.55.52.120]:16463 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729147AbfJBXhk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:37:40 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:37:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366862625"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.30.230])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 16:37:23 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>, cpaasch@apple.com,
        fw@strlen.de, pabeni@redhat.com, peter.krystad@linux.intel.com,
        dcaratti@redhat.com
Subject: [RFC PATCH v2 30/45] mptcp: new sysctl to control the activation per NS
Date:   Wed,  2 Oct 2019 16:36:40 -0700
Message-Id: <20191002233655.24323-31-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
References: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

New MPTCP sockets will return -ENOPROTOOPT if MPTCP support is disabled
for the current net namespace.

For security reasons, it is interesting to have a global switch for
MPTCP. To start, MPTCP will be disabled by default and only privileged
users will be able to modify this. The reason is that because MPTCP is
new, it will not be tested and reviewed by many and security issues can
then take time to be discovered and fixed.

The value of this new sysctl can be different per namespace. We can then
restrict the usage of MPTCP to the selected NS. In case of serious
issues with MPTCP, administrators can now easily turn MPTCP off.

Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/Makefile   |   2 +-
 net/mptcp/ctrl.c     | 112 +++++++++++++++++++++++++++++++++++++++++++
 net/mptcp/protocol.c |  25 +++++-----
 net/mptcp/protocol.h |   4 ++
 4 files changed, 129 insertions(+), 14 deletions(-)
 create mode 100644 net/mptcp/ctrl.c

diff --git a/net/mptcp/Makefile b/net/mptcp/Makefile
index 7fe7aa64eda0..289fdf4339c1 100644
--- a/net/mptcp/Makefile
+++ b/net/mptcp/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_MPTCP) += mptcp.o
 
-mptcp-y := protocol.o subflow.o options.o token.o crypto.o pm.o
+mptcp-y := protocol.o subflow.o options.o token.o crypto.o pm.o ctrl.o
diff --git a/net/mptcp/ctrl.c b/net/mptcp/ctrl.c
new file mode 100644
index 000000000000..8d9f15f02369
--- /dev/null
+++ b/net/mptcp/ctrl.c
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Multipath TCP
+ *
+ * Copyright (c) 2019, Tessares SA.
+ */
+
+#include <linux/sysctl.h>
+
+#include <net/net_namespace.h>
+#include <net/netns/generic.h>
+
+#include "protocol.h"
+
+#define MPTCP_SYSCTL_PATH "net/mptcp"
+
+static int mptcp_pernet_id;
+struct mptcp_pernet {
+	struct ctl_table_header *ctl_table_hdr;
+
+	int mptcp_enabled;
+};
+
+static struct mptcp_pernet *mptcp_get_pernet(struct net *net)
+{
+	return net_generic(net, mptcp_pernet_id);
+}
+
+int mptcp_is_enabled(struct net *net)
+{
+	return mptcp_get_pernet(net)->mptcp_enabled;
+}
+
+static struct ctl_table mptcp_sysctl_table[] = {
+	{
+		.procname = "enabled",
+		.maxlen = sizeof(int),
+		.mode = 0644,
+		/* users with CAP_NET_ADMIN or root (not and) can change thi
+		 * value, same as other sysctl or the 'net' tree.
+		 */
+		.proc_handler = proc_dointvec,
+	},
+	{}
+};
+
+static int mptcp_pernet_new_table(struct net *net, struct mptcp_pernet *pernet)
+{
+	struct ctl_table_header *hdr;
+	struct ctl_table *table;
+
+	table = mptcp_sysctl_table;
+	if (!net_eq(net, &init_net)) {
+		table = kmemdup(table, sizeof(mptcp_sysctl_table), GFP_KERNEL);
+		if (!table)
+			goto err_alloc;
+	}
+
+	table[0].data = &pernet->mptcp_enabled;
+
+	hdr = register_net_sysctl(net, MPTCP_SYSCTL_PATH, table);
+	if (!hdr)
+		goto err_reg;
+
+	pernet->ctl_table_hdr = hdr;
+
+	return 0;
+
+err_reg:
+	if (!net_eq(net, &init_net))
+		kfree(table);
+err_alloc:
+	return -ENOMEM;
+}
+
+static void mptcp_pernet_del_table(struct mptcp_pernet *pernet)
+{
+	struct ctl_table *table = pernet->ctl_table_hdr->ctl_table_arg;
+
+	unregister_net_sysctl_table(pernet->ctl_table_hdr);
+
+	kfree(table);
+}
+
+static int __net_init mptcp_net_init(struct net *net)
+{
+	struct mptcp_pernet *pernet = mptcp_get_pernet(net);
+
+	return mptcp_pernet_new_table(net, pernet);
+}
+
+/* Note: the callback will only be called per extra netns */
+static void __net_exit mptcp_net_exit(struct net *net)
+{
+	struct mptcp_pernet *pernet = mptcp_get_pernet(net);
+
+	mptcp_pernet_del_table(pernet);
+}
+
+static struct pernet_operations mptcp_pernet_ops = {
+	.init = mptcp_net_init,
+	.exit = mptcp_net_exit,
+	.id = &mptcp_pernet_id,
+	.size = sizeof(struct mptcp_pernet),
+};
+
+void __init mptcp_init(void)
+{
+	mptcp_proto_init();
+
+	if (register_pernet_subsys(&mptcp_pernet_ops) < 0)
+		panic("Failed to register MPTCP pernet subsystem.\n");
+}
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 8512cf5e0e0f..fa99337ca773 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -562,22 +562,21 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	return copied;
 }
 
-static int mptcp_init_sock(struct sock *sk)
+static int __mptcp_init_sock(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
-	struct net *net = sock_net(sk);
-	struct socket *sf;
-	int err;
-
-	err = sock_create_kern(net, PF_INET, SOCK_STREAM, IPPROTO_TCP, &sf);
-	if (!err) {
-		pr_debug("subflow=%p", sf->sk);
-		msk->subflow = sf;
-	}
 
 	INIT_LIST_HEAD(&msk->conn_list);
 
-	return err;
+	return 0;
+}
+
+static int mptcp_init_sock(struct sock *sk)
+{
+	if (!mptcp_is_enabled(sock_net(sk)))
+		return -ENOPROTOOPT;
+
+	return __mptcp_init_sock(sk);
 }
 
 static void mptcp_close(struct sock *sk, long timeout)
@@ -646,7 +645,7 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 			return NULL;
 		}
 
-		mptcp_init_sock(new_mptcp_sock);
+		__mptcp_init_sock(new_mptcp_sock);
 
 		msk = mptcp_sk(new_mptcp_sock);
 		msk->remote_key = subflow->remote_key;
@@ -1067,7 +1066,7 @@ static struct inet_protosw mptcp_protosw = {
 	.flags		= INET_PROTOSW_ICSK,
 };
 
-void __init mptcp_init(void)
+void mptcp_proto_init(void)
 {
 	mptcp_prot.h.hashinfo = tcp_prot.h.hashinfo;
 	mptcp_stream_ops = inet_stream_ops;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 16fe1c766d98..394f2477e6f8 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -204,11 +204,15 @@ mptcp_subflow_tcp_socket(const struct mptcp_subflow_context *subflow)
 	return subflow->tcp_sock;
 }
 
+int mptcp_is_enabled(struct net *net);
+
 void mptcp_subflow_init(void);
 int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock);
 
 extern const struct inet_connection_sock_af_ops ipv4_specific;
 
+void mptcp_proto_init(void);
+
 void mptcp_get_options(const struct sk_buff *skb,
 		       struct tcp_options_received *opt_rx);
 
-- 
2.23.0

