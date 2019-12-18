Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4E5125262
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 20:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbfLRTza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 14:55:30 -0500
Received: from mga05.intel.com ([192.55.52.43]:2225 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727541AbfLRTzS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 14:55:18 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 11:55:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="213019974"
Received: from mjmartin-nuc01.amr.corp.intel.com ([10.241.98.42])
  by fmsmga008.fm.intel.com with ESMTP; 18 Dec 2019 11:55:17 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        Peter Krystad <peter.krystad@linux.intel.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next v2 14/15] mptcp: new sysctl to control the activation per NS
Date:   Wed, 18 Dec 2019 11:55:09 -0800
Message-Id: <20191218195510.7782-15-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218195510.7782-1-mathew.j.martineau@linux.intel.com>
References: <20191218195510.7782-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

New MPTCP sockets will return -ENOPROTOOPT if MPTCP support is disabled
for the current net namespace.

We are providing here a way to control access to the feature for those
that need to turn it on or off.

The value of this new sysctl can be different per namespace. We can then
restrict the usage of MPTCP to the selected NS. In case of serious
issues with MPTCP, administrators can now easily turn MPTCP off.

Co-developed-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/Makefile   |   2 +-
 net/mptcp/ctrl.c     | 130 +++++++++++++++++++++++++++++++++++++++++++
 net/mptcp/protocol.c |  16 ++++--
 net/mptcp/protocol.h |   3 +
 4 files changed, 146 insertions(+), 5 deletions(-)
 create mode 100644 net/mptcp/ctrl.c

diff --git a/net/mptcp/Makefile b/net/mptcp/Makefile
index 178ae81d8b66..4e98d9edfd0a 100644
--- a/net/mptcp/Makefile
+++ b/net/mptcp/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_MPTCP) += mptcp.o
 
-mptcp-y := protocol.o subflow.o options.o token.o crypto.o
+mptcp-y := protocol.o subflow.o options.o token.o crypto.o ctrl.o
diff --git a/net/mptcp/ctrl.c b/net/mptcp/ctrl.c
new file mode 100644
index 000000000000..8e39585d37f3
--- /dev/null
+++ b/net/mptcp/ctrl.c
@@ -0,0 +1,130 @@
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
+		/* users with CAP_NET_ADMIN or root (not and) can change this
+		 * value, same as other sysctl or the 'net' tree.
+		 */
+		.proc_handler = proc_dointvec,
+	},
+	{}
+};
+
+static void mptcp_pernet_set_defaults(struct mptcp_pernet *pernet)
+{
+	pernet->mptcp_enabled = 1;
+}
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
+	mptcp_pernet_set_defaults(pernet);
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
+
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+int __init mptcpv6_init(void)
+{
+	int err;
+
+	err = mptcp_proto_v6_init();
+
+	return err;
+}
+#endif
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 79d45081e66e..bcc29e9b695c 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -522,7 +522,7 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 	}
 }
 
-static int mptcp_init_sock(struct sock *sk)
+static int __mptcp_init_sock(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
@@ -532,6 +532,14 @@ static int mptcp_init_sock(struct sock *sk)
 	return 0;
 }
 
+static int mptcp_init_sock(struct sock *sk)
+{
+	if (!mptcp_is_enabled(sock_net(sk)))
+		return -ENOPROTOOPT;
+
+	return __mptcp_init_sock(sk);
+}
+
 static void mptcp_subflow_shutdown(struct sock *ssk, int how)
 {
 	lock_sock(ssk);
@@ -640,7 +648,7 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 			return NULL;
 		}
 
-		mptcp_init_sock(new_mptcp_sock);
+		__mptcp_init_sock(new_mptcp_sock);
 
 		msk = mptcp_sk(new_mptcp_sock);
 		msk->remote_key = subflow->remote_key;
@@ -1080,7 +1088,7 @@ static struct inet_protosw mptcp_protosw = {
 	.flags		= INET_PROTOSW_ICSK,
 };
 
-void __init mptcp_init(void)
+void mptcp_proto_init(void)
 {
 	mptcp_prot.h.hashinfo = tcp_prot.h.hashinfo;
 	mptcp_stream_ops = inet_stream_ops;
@@ -1118,7 +1126,7 @@ static struct inet_protosw mptcp_v6_protosw = {
 	.flags		= INET_PROTOSW_ICSK,
 };
 
-int mptcpv6_init(void)
+int mptcp_proto_v6_init(void)
 {
 	int err;
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index b3d884fd7d23..fb90cf3e97c9 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -166,6 +166,9 @@ extern const struct inet_connection_sock_af_ops ipv6_specific;
 #endif
 
 void mptcp_proto_init(void);
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+int mptcp_proto_v6_init(void);
+#endif
 
 struct mptcp_read_arg {
 	struct msghdr *msg;
-- 
2.24.1

