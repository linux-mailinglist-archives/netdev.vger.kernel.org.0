Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62AA912525C
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 20:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbfLRTzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 14:55:20 -0500
Received: from mga05.intel.com ([192.55.52.43]:2225 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727543AbfLRTzR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 14:55:17 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 11:55:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="213019956"
Received: from mjmartin-nuc01.amr.corp.intel.com ([10.241.98.42])
  by fmsmga008.fm.intel.com with ESMTP; 18 Dec 2019 11:55:14 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Peter Krystad <peter.krystad@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next v2 08/15] mptcp: Add setsockopt()/getsockopt() socket operations
Date:   Wed, 18 Dec 2019 11:55:03 -0800
Message-Id: <20191218195510.7782-9-mathew.j.martineau@linux.intel.com>
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
index 443425948922..30f4d4f96f15 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -333,6 +333,62 @@ static void mptcp_destroy(struct sock *sk)
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
@@ -383,6 +439,8 @@ static struct proto mptcp_prot = {
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

