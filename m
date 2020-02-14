Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D76D15F94A
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 23:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbgBNWOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 17:14:44 -0500
Received: from mga18.intel.com ([134.134.136.126]:44881 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgBNWOo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 17:14:44 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Feb 2020 14:14:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,442,1574150400"; 
   d="scan'208";a="348044917"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.10.201])
  by fmsmga001.fm.intel.com with ESMTP; 14 Feb 2020 14:14:43 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net] mptcp: Protect subflow socket options before connection completes
Date:   Fri, 14 Feb 2020 14:14:29 -0800
Message-Id: <20200214221429.26156-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Userspace should not be able to directly manipulate subflow socket
options before a connection is established since it is not yet known if
it will be an MPTCP subflow or a TCP fallback subflow. TCP fallback
subflows can be more directly controlled by userspace because they are
regular TCP connections, while MPTCP subflow sockets need to be
configured for the specific needs of MPTCP. Use the same logic as
sendmsg/recvmsg to ensure that socket option calls are only passed
through to known TCP fallback subflows.

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 48 ++++++++++++++++++--------------------------
 1 file changed, 19 insertions(+), 29 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 030dee668e0a..e9aa6807b5be 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -755,60 +755,50 @@ static int mptcp_setsockopt(struct sock *sk, int level, int optname,
 			    char __user *optval, unsigned int optlen)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
-	int ret = -EOPNOTSUPP;
 	struct socket *ssock;
-	struct sock *ssk;
 
 	pr_debug("msk=%p", msk);
 
 	/* @@ the meaning of setsockopt() when the socket is connected and
-	 * there are multiple subflows is not defined.
+	 * there are multiple subflows is not yet defined. It is up to the
+	 * MPTCP-level socket to configure the subflows until the subflow
+	 * is in TCP fallback, when TCP socket options are passed through
+	 * to the one remaining subflow.
 	 */
 	lock_sock(sk);
-	ssock = __mptcp_socket_create(msk, MPTCP_SAME_STATE);
-	if (IS_ERR(ssock)) {
-		release_sock(sk);
-		return ret;
-	}
+	ssock = __mptcp_tcp_fallback(msk);
+	if (ssock)
+		return tcp_setsockopt(ssock->sk, level, optname, optval,
+				      optlen);
 
-	ssk = ssock->sk;
-	sock_hold(ssk);
 	release_sock(sk);
 
-	ret = tcp_setsockopt(ssk, level, optname, optval, optlen);
-	sock_put(ssk);
-
-	return ret;
+	return -EOPNOTSUPP;
 }
 
 static int mptcp_getsockopt(struct sock *sk, int level, int optname,
 			    char __user *optval, int __user *option)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
-	int ret = -EOPNOTSUPP;
 	struct socket *ssock;
-	struct sock *ssk;
 
 	pr_debug("msk=%p", msk);
 
-	/* @@ the meaning of getsockopt() when the socket is connected and
-	 * there are multiple subflows is not defined.
+	/* @@ the meaning of setsockopt() when the socket is connected and
+	 * there are multiple subflows is not yet defined. It is up to the
+	 * MPTCP-level socket to configure the subflows until the subflow
+	 * is in TCP fallback, when socket options are passed through
+	 * to the one remaining subflow.
 	 */
 	lock_sock(sk);
-	ssock = __mptcp_socket_create(msk, MPTCP_SAME_STATE);
-	if (IS_ERR(ssock)) {
-		release_sock(sk);
-		return ret;
-	}
+	ssock = __mptcp_tcp_fallback(msk);
+	if (ssock)
+		return tcp_getsockopt(ssock->sk, level, optname, optval,
+				      option);
 
-	ssk = ssock->sk;
-	sock_hold(ssk);
 	release_sock(sk);
 
-	ret = tcp_getsockopt(ssk, level, optname, optval, option);
-	sock_put(ssk);
-
-	return ret;
+	return -EOPNOTSUPP;
 }
 
 static int mptcp_get_port(struct sock *sk, unsigned short snum)

base-commit: a1fa83bdab784fa0ff2e92870011c0dcdbd2f680
-- 
2.25.0

