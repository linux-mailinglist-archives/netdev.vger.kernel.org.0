Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF6E36166B
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 01:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237436AbhDOXpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 19:45:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:63174 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235613AbhDOXpb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 19:45:31 -0400
IronPort-SDR: cAExN00Mmv4p5kwLZR4qR2KqJHyLUuyCu6M+IShAtGUcnbd2/vYIPPLMLPy5uy1NXrSYbXylJC
 EUa7JQQiuFfw==
X-IronPort-AV: E=McAfee;i="6200,9189,9955"; a="215480152"
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="215480152"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2021 16:45:07 -0700
IronPort-SDR: bZo8MplJ3i7e9RV2nhWwRNd3Mlw7bDcAiBAnDM0p3/zoF9gEWUlWnla/8R9WxzHAXmhluIFGDy
 DVjkkNE0zbVA==
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="461793355"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.243.150])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2021 16:45:07 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 02/13] mptcp: move sockopt function into a new file
Date:   Thu, 15 Apr 2021 16:44:51 -0700
Message-Id: <20210415234502.224225-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415234502.224225-1-mathew.j.martineau@linux.intel.com>
References: <20210415234502.224225-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

The MPTCP sockopt implementation is going to be much
more big and complex soon. Let's move it to a different
source file.

No functional change intended.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/Makefile   |   2 +-
 net/mptcp/protocol.c | 120 --------------------------------------
 net/mptcp/protocol.h |   5 ++
 net/mptcp/sockopt.c  | 136 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 142 insertions(+), 121 deletions(-)
 create mode 100644 net/mptcp/sockopt.c

diff --git a/net/mptcp/Makefile b/net/mptcp/Makefile
index a611968be4d7..d2642c012a6a 100644
--- a/net/mptcp/Makefile
+++ b/net/mptcp/Makefile
@@ -2,7 +2,7 @@
 obj-$(CONFIG_MPTCP) += mptcp.o
 
 mptcp-y := protocol.o subflow.o options.o token.o crypto.o ctrl.o pm.o diag.o \
-	   mib.o pm_netlink.o
+	   mib.o pm_netlink.o sockopt.o
 
 obj-$(CONFIG_SYN_COOKIES) += syncookies.o
 obj-$(CONFIG_INET_MPTCP_DIAG) += mptcp_diag.o
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 2fcdc611c122..e0b381ae99af 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -90,16 +90,6 @@ static bool mptcp_is_tcpsk(struct sock *sk)
 	return false;
 }
 
-static struct sock *__mptcp_tcp_fallback(struct mptcp_sock *msk)
-{
-	sock_owned_by_me((const struct sock *)msk);
-
-	if (likely(!__mptcp_check_fallback(msk)))
-		return NULL;
-
-	return msk->first;
-}
-
 static int __mptcp_socket_create(struct mptcp_sock *msk)
 {
 	struct mptcp_subflow_context *subflow;
@@ -2811,116 +2801,6 @@ static void mptcp_destroy(struct sock *sk)
 	sk_sockets_allocated_dec(sk);
 }
 
-static int mptcp_setsockopt_sol_socket(struct mptcp_sock *msk, int optname,
-				       sockptr_t optval, unsigned int optlen)
-{
-	struct sock *sk = (struct sock *)msk;
-	struct socket *ssock;
-	int ret;
-
-	switch (optname) {
-	case SO_REUSEPORT:
-	case SO_REUSEADDR:
-		lock_sock(sk);
-		ssock = __mptcp_nmpc_socket(msk);
-		if (!ssock) {
-			release_sock(sk);
-			return -EINVAL;
-		}
-
-		ret = sock_setsockopt(ssock, SOL_SOCKET, optname, optval, optlen);
-		if (ret == 0) {
-			if (optname == SO_REUSEPORT)
-				sk->sk_reuseport = ssock->sk->sk_reuseport;
-			else if (optname == SO_REUSEADDR)
-				sk->sk_reuse = ssock->sk->sk_reuse;
-		}
-		release_sock(sk);
-		return ret;
-	}
-
-	return sock_setsockopt(sk->sk_socket, SOL_SOCKET, optname, optval, optlen);
-}
-
-static int mptcp_setsockopt_v6(struct mptcp_sock *msk, int optname,
-			       sockptr_t optval, unsigned int optlen)
-{
-	struct sock *sk = (struct sock *)msk;
-	int ret = -EOPNOTSUPP;
-	struct socket *ssock;
-
-	switch (optname) {
-	case IPV6_V6ONLY:
-		lock_sock(sk);
-		ssock = __mptcp_nmpc_socket(msk);
-		if (!ssock) {
-			release_sock(sk);
-			return -EINVAL;
-		}
-
-		ret = tcp_setsockopt(ssock->sk, SOL_IPV6, optname, optval, optlen);
-		if (ret == 0)
-			sk->sk_ipv6only = ssock->sk->sk_ipv6only;
-
-		release_sock(sk);
-		break;
-	}
-
-	return ret;
-}
-
-static int mptcp_setsockopt(struct sock *sk, int level, int optname,
-			    sockptr_t optval, unsigned int optlen)
-{
-	struct mptcp_sock *msk = mptcp_sk(sk);
-	struct sock *ssk;
-
-	pr_debug("msk=%p", msk);
-
-	if (level == SOL_SOCKET)
-		return mptcp_setsockopt_sol_socket(msk, optname, optval, optlen);
-
-	/* @@ the meaning of setsockopt() when the socket is connected and
-	 * there are multiple subflows is not yet defined. It is up to the
-	 * MPTCP-level socket to configure the subflows until the subflow
-	 * is in TCP fallback, when TCP socket options are passed through
-	 * to the one remaining subflow.
-	 */
-	lock_sock(sk);
-	ssk = __mptcp_tcp_fallback(msk);
-	release_sock(sk);
-	if (ssk)
-		return tcp_setsockopt(ssk, level, optname, optval, optlen);
-
-	if (level == SOL_IPV6)
-		return mptcp_setsockopt_v6(msk, optname, optval, optlen);
-
-	return -EOPNOTSUPP;
-}
-
-static int mptcp_getsockopt(struct sock *sk, int level, int optname,
-			    char __user *optval, int __user *option)
-{
-	struct mptcp_sock *msk = mptcp_sk(sk);
-	struct sock *ssk;
-
-	pr_debug("msk=%p", msk);
-
-	/* @@ the meaning of setsockopt() when the socket is connected and
-	 * there are multiple subflows is not yet defined. It is up to the
-	 * MPTCP-level socket to configure the subflows until the subflow
-	 * is in TCP fallback, when socket options are passed through
-	 * to the one remaining subflow.
-	 */
-	lock_sock(sk);
-	ssk = __mptcp_tcp_fallback(msk);
-	release_sock(sk);
-	if (ssk)
-		return tcp_getsockopt(ssk, level, optname, optval, option);
-
-	return -EOPNOTSUPP;
-}
-
 void __mptcp_data_acked(struct sock *sk)
 {
 	if (!sock_owned_by_user(sk))
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index d8de1e961ab0..14f0114be17a 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -571,6 +571,11 @@ void mptcp_rcv_space_init(struct mptcp_sock *msk, const struct sock *ssk);
 void mptcp_data_ready(struct sock *sk, struct sock *ssk);
 bool mptcp_finish_join(struct sock *sk);
 bool mptcp_schedule_work(struct sock *sk);
+int mptcp_setsockopt(struct sock *sk, int level, int optname,
+		     sockptr_t optval, unsigned int optlen);
+int mptcp_getsockopt(struct sock *sk, int level, int optname,
+		     char __user *optval, int __user *option);
+
 void __mptcp_check_push(struct sock *sk, struct sock *ssk);
 void __mptcp_data_acked(struct sock *sk);
 void __mptcp_error_report(struct sock *sk);
diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
new file mode 100644
index 000000000000..479f75653969
--- /dev/null
+++ b/net/mptcp/sockopt.c
@@ -0,0 +1,136 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Multipath TCP
+ *
+ * Copyright (c) 2021, Red Hat.
+ */
+
+#define pr_fmt(fmt) "MPTCP: " fmt
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <net/sock.h>
+#include <net/protocol.h>
+#include <net/tcp.h>
+#include <net/mptcp.h>
+#include "protocol.h"
+
+static struct sock *__mptcp_tcp_fallback(struct mptcp_sock *msk)
+{
+	sock_owned_by_me((const struct sock *)msk);
+
+	if (likely(!__mptcp_check_fallback(msk)))
+		return NULL;
+
+	return msk->first;
+}
+
+static int mptcp_setsockopt_sol_socket(struct mptcp_sock *msk, int optname,
+				       sockptr_t optval, unsigned int optlen)
+{
+	struct sock *sk = (struct sock *)msk;
+	struct socket *ssock;
+	int ret;
+
+	switch (optname) {
+	case SO_REUSEPORT:
+	case SO_REUSEADDR:
+		lock_sock(sk);
+		ssock = __mptcp_nmpc_socket(msk);
+		if (!ssock) {
+			release_sock(sk);
+			return -EINVAL;
+		}
+
+		ret = sock_setsockopt(ssock, SOL_SOCKET, optname, optval, optlen);
+		if (ret == 0) {
+			if (optname == SO_REUSEPORT)
+				sk->sk_reuseport = ssock->sk->sk_reuseport;
+			else if (optname == SO_REUSEADDR)
+				sk->sk_reuse = ssock->sk->sk_reuse;
+		}
+		release_sock(sk);
+		return ret;
+	}
+
+	return sock_setsockopt(sk->sk_socket, SOL_SOCKET, optname, optval, optlen);
+}
+
+static int mptcp_setsockopt_v6(struct mptcp_sock *msk, int optname,
+			       sockptr_t optval, unsigned int optlen)
+{
+	struct sock *sk = (struct sock *)msk;
+	int ret = -EOPNOTSUPP;
+	struct socket *ssock;
+
+	switch (optname) {
+	case IPV6_V6ONLY:
+		lock_sock(sk);
+		ssock = __mptcp_nmpc_socket(msk);
+		if (!ssock) {
+			release_sock(sk);
+			return -EINVAL;
+		}
+
+		ret = tcp_setsockopt(ssock->sk, SOL_IPV6, optname, optval, optlen);
+		if (ret == 0)
+			sk->sk_ipv6only = ssock->sk->sk_ipv6only;
+
+		release_sock(sk);
+		break;
+	}
+
+	return ret;
+}
+
+int mptcp_setsockopt(struct sock *sk, int level, int optname,
+		     sockptr_t optval, unsigned int optlen)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct sock *ssk;
+
+	pr_debug("msk=%p", msk);
+
+	if (level == SOL_SOCKET)
+		return mptcp_setsockopt_sol_socket(msk, optname, optval, optlen);
+
+	/* @@ the meaning of setsockopt() when the socket is connected and
+	 * there are multiple subflows is not yet defined. It is up to the
+	 * MPTCP-level socket to configure the subflows until the subflow
+	 * is in TCP fallback, when TCP socket options are passed through
+	 * to the one remaining subflow.
+	 */
+	lock_sock(sk);
+	ssk = __mptcp_tcp_fallback(msk);
+	release_sock(sk);
+	if (ssk)
+		return tcp_setsockopt(ssk, level, optname, optval, optlen);
+
+	if (level == SOL_IPV6)
+		return mptcp_setsockopt_v6(msk, optname, optval, optlen);
+
+	return -EOPNOTSUPP;
+}
+
+int mptcp_getsockopt(struct sock *sk, int level, int optname,
+		     char __user *optval, int __user *option)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct sock *ssk;
+
+	pr_debug("msk=%p", msk);
+
+	/* @@ the meaning of setsockopt() when the socket is connected and
+	 * there are multiple subflows is not yet defined. It is up to the
+	 * MPTCP-level socket to configure the subflows until the subflow
+	 * is in TCP fallback, when socket options are passed through
+	 * to the one remaining subflow.
+	 */
+	lock_sock(sk);
+	ssk = __mptcp_tcp_fallback(msk);
+	release_sock(sk);
+	if (ssk)
+		return tcp_getsockopt(ssk, level, optname, optval, option);
+
+	return -EOPNOTSUPP;
+}
+
-- 
2.31.1

