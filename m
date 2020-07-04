Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8BF214926
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 01:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbgGDXai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 19:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727929AbgGDXah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 19:30:37 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC39DC061794
        for <netdev@vger.kernel.org>; Sat,  4 Jul 2020 16:30:37 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jrrcC-0004pu-3h; Sun, 05 Jul 2020 01:30:36 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     <mptcp@lists.01.org>, Florian Westphal <fw@strlen.de>,
        Christoph Paasch <cpaasch@apple.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 2/3] mptcp: add REUSEADDR/REUSEPORT support
Date:   Sun,  5 Jul 2020 01:30:16 +0200
Message-Id: <20200704233017.20831-3-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200704233017.20831-1-fw@strlen.de>
References: <20200704233017.20831-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will e.g. make 'sshd restart' work when MPTCP is used, as we will
now set this option on the listener socket instead of only the mptcp
socket (where it has no effect).

We still need to copy the setting to the master socket so that a
subsequent getsockopt() returns the expected value.

Reported-by: Christoph Paasch <cpaasch@apple.com>
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 320f306ea85c..612f6d49f1bb 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1601,6 +1601,37 @@ static void mptcp_destroy(struct sock *sk)
 	sk_sockets_allocated_dec(sk);
 }
 
+static int mptcp_setsockopt_sol_socket(struct mptcp_sock *msk, int optname,
+				       char __user *optval, unsigned int optlen)
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
 static int mptcp_setsockopt(struct sock *sk, int level, int optname,
 			    char __user *optval, unsigned int optlen)
 {
@@ -1610,7 +1641,7 @@ static int mptcp_setsockopt(struct sock *sk, int level, int optname,
 	pr_debug("msk=%p", msk);
 
 	if (level == SOL_SOCKET)
-		return sock_setsockopt(sk->sk_socket, level, optname, optval, optlen);
+		return mptcp_setsockopt_sol_socket(msk, optname, optval, optlen);
 
 	/* @@ the meaning of setsockopt() when the socket is connected and
 	 * there are multiple subflows is not yet defined. It is up to the
-- 
2.26.2

