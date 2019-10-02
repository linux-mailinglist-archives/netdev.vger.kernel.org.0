Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D63BFC94EC
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbfJBXhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:37:36 -0400
Received: from mga04.intel.com ([192.55.52.120]:16447 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728969AbfJBXhW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:37:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:37:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366862600"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.30.230])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 16:37:21 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Peter Krystad <peter.krystad@linux.intel.com>, cpaasch@apple.com,
        fw@strlen.de, pabeni@redhat.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH v2 15/45] mptcp: Add setsockopt()/getsockopt() socket operations
Date:   Wed,  2 Oct 2019 16:36:25 -0700
Message-Id: <20191002233655.24323-16-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
References: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Krystad <peter.krystad@linux.intel.com>

set/getsockopt behaviour with multiple subflows is undefined.
Therefore, for now, we return -EOPNOTSUPP unless we're in fallback mode.

Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 67 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index dba4d7a4a61a..41588758f74b 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -28,6 +28,17 @@ static struct socket *__mptcp_fallback_get_ref(const struct mptcp_sock *msk)
 	return msk->subflow;
 }
 
+static struct socket *mptcp_fallback_get_ref(const struct mptcp_sock *msk)
+{
+	struct socket *ssock;
+
+	lock_sock((struct sock *)msk);
+	ssock = __mptcp_fallback_get_ref(msk);
+	release_sock((struct sock *)msk);
+
+	return ssock;
+}
+
 static struct sock *mptcp_subflow_get_ref(const struct mptcp_sock *msk)
 {
 	struct mptcp_subflow_context *subflow;
@@ -224,6 +235,60 @@ static void mptcp_destroy(struct sock *sk)
 {
 }
 
+static int mptcp_setsockopt(struct sock *sk, int level, int optname,
+			    char __user *uoptval, unsigned int optlen)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	char __kernel *optval;
+	struct socket *ssock;
+	int ret;
+
+	/* will be treated as __user in tcp_setsockopt */
+	optval = (char __kernel __force *)uoptval;
+
+	pr_debug("msk=%p", msk);
+	ssock = mptcp_fallback_get_ref(msk);
+	if (ssock) {
+		pr_debug("subflow=%p", ssock->sk);
+		ret = kernel_setsockopt(ssock, level, optname, optval, optlen);
+		sock_put(ssock->sk);
+		return ret;
+	}
+
+	/* @@ the meaning of setsockopt() when the socket is connected and
+	 * there are multiple subflows is not defined.
+	 */
+	return -EOPNOTSUPP;
+}
+
+static int mptcp_getsockopt(struct sock *sk, int level, int optname,
+			    char __user *uoptval, int __user *uoption)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	char __kernel *optval;
+	int __kernel *option;
+	struct socket *ssock;
+	int ret;
+
+	/* will be treated as __user in tcp_getsockopt */
+	optval = (char __kernel __force *)uoptval;
+	option = (int __kernel __force *)uoption;
+
+	pr_debug("msk=%p", msk);
+	ssock = mptcp_fallback_get_ref(msk);
+	if (ssock) {
+		pr_debug("subflow=%p", ssock->sk);
+		ret = kernel_getsockopt(ssock, level, optname, optval, option);
+		sock_put(ssock->sk);
+		return ret;
+	}
+
+	/* @@ the meaning of getsockopt() when the socket is connected and
+	 * there are multiple subflows is not defined.
+	 */
+	return -EOPNOTSUPP;
+}
+
 static int mptcp_get_port(struct sock *sk, unsigned short snum)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -282,6 +347,8 @@ static struct proto mptcp_prot = {
 	.init		= mptcp_init_sock,
 	.close		= mptcp_close,
 	.accept		= mptcp_accept,
+	.setsockopt	= mptcp_setsockopt,
+	.getsockopt	= mptcp_getsockopt,
 	.shutdown	= tcp_shutdown,
 	.destroy	= mptcp_destroy,
 	.sendmsg	= mptcp_sendmsg,
-- 
2.23.0

