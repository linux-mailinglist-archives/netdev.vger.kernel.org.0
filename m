Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0CCD11F08A
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 07:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfLNGEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 01:04:55 -0500
Received: from mga06.intel.com ([134.134.136.31]:24724 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbfLNGEg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Dec 2019 01:04:36 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2019 22:04:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,312,1571727600"; 
   d="scan'208";a="216855223"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.17.224])
  by orsmga003.jf.intel.com with ESMTP; 13 Dec 2019 22:04:33 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Peter Krystad <peter.krystad@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 08/15] mptcp: Add setsockopt()/getsockopt() socket operations
Date:   Fri, 13 Dec 2019 22:04:10 -0800
Message-Id: <20191214060417.2870-9-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191214060417.2870-1-mathew.j.martineau@linux.intel.com>
References: <20191214060417.2870-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Krystad <peter.krystad@linux.intel.com>

set/getsockopt behaviour with multiple subflows is undefined.
Therefore, for now, we return -EOPNOTSUPP unless we're in fallback mode.

Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 58 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 6298e1d0008b..891aa6ef0a95 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -330,6 +330,62 @@ static void mptcp_destroy(struct sock *sk)
 {
 }
 
+static int mptcp_setsockopt(struct sock *sk, int level, int optname,
+			    char __user *uoptval, unsigned int optlen)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	char __kernel *optval;
+	int ret = -EOPNOTSUPP;
+	struct socket *ssock;
+
+	/* will be treated as __user in tcp_setsockopt */
+	optval = (char __kernel __force *)uoptval;
+
+	pr_debug("msk=%p", msk);
+
+	/* @@ the meaning of setsockopt() when the socket is connected and
+	 * there are multiple subflows is not defined.
+	 */
+	lock_sock(sk);
+	ssock = __mptcp_socket_create(msk, MPTCP_SAME_STATE);
+	if (!IS_ERR(ssock)) {
+		pr_debug("subflow=%p", ssock->sk);
+		ret = kernel_setsockopt(ssock, level, optname, optval, optlen);
+	}
+	release_sock(sk);
+
+	return ret;
+}
+
+static int mptcp_getsockopt(struct sock *sk, int level, int optname,
+			    char __user *uoptval, int __user *uoption)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	char __kernel *optval;
+	int ret = -EOPNOTSUPP;
+	int __kernel *option;
+	struct socket *ssock;
+
+	/* will be treated as __user in tcp_getsockopt */
+	optval = (char __kernel __force *)uoptval;
+	option = (int __kernel __force *)uoption;
+
+	pr_debug("msk=%p", msk);
+
+	/* @@ the meaning of getsockopt() when the socket is connected and
+	 * there are multiple subflows is not defined.
+	 */
+	lock_sock(sk);
+	ssock = __mptcp_socket_create(msk, MPTCP_SAME_STATE);
+	if (!IS_ERR(ssock)) {
+		pr_debug("subflow=%p", ssock->sk);
+		ret = kernel_getsockopt(ssock, level, optname, optval, option);
+	}
+	release_sock(sk);
+
+	return ret;
+}
+
 static int mptcp_get_port(struct sock *sk, unsigned short snum)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -380,6 +436,8 @@ static struct proto mptcp_prot = {
 	.init		= mptcp_init_sock,
 	.close		= mptcp_close,
 	.accept		= mptcp_accept,
+	.setsockopt	= mptcp_setsockopt,
+	.getsockopt	= mptcp_getsockopt,
 	.shutdown	= tcp_shutdown,
 	.destroy	= mptcp_destroy,
 	.sendmsg	= mptcp_sendmsg,
-- 
2.24.1

