Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD60214925
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 01:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbgGDXad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 19:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727929AbgGDXad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 19:30:33 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD33C061794
        for <netdev@vger.kernel.org>; Sat,  4 Jul 2020 16:30:32 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jrrc7-0004pc-Ix; Sun, 05 Jul 2020 01:30:31 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     <mptcp@lists.01.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 1/3] net: use mptcp setsockopt function for SOL_SOCKET on mptcp sockets
Date:   Sun,  5 Jul 2020 01:30:15 +0200
Message-Id: <20200704233017.20831-2-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200704233017.20831-1-fw@strlen.de>
References: <20200704233017.20831-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

setsockopt(mptcp_fd, SOL_SOCKET, ...)...  appears to work (returns 0),
but it has no effect -- this is because the MPTCP layer never has a
chance to copy the settings to the subflow socket.

Skip the generic handling for the mptcp case and instead call the
mptcp specific handler instead for SOL_SOCKET too.

Next patch adds more specific handling for SOL_SOCKET to mptcp.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c |  3 +++
 net/socket.c         | 13 ++++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index fa137a9c42d1..320f306ea85c 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1609,6 +1609,9 @@ static int mptcp_setsockopt(struct sock *sk, int level, int optname,
 
 	pr_debug("msk=%p", msk);
 
+	if (level == SOL_SOCKET)
+		return sock_setsockopt(sk->sk_socket, level, optname, optval, optlen);
+
 	/* @@ the meaning of setsockopt() when the socket is connected and
 	 * there are multiple subflows is not yet defined. It is up to the
 	 * MPTCP-level socket to configure the subflows until the subflow
diff --git a/net/socket.c b/net/socket.c
index 976426d03f09..d87812a9ed4b 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2080,6 +2080,17 @@ SYSCALL_DEFINE4(recv, int, fd, void __user *, ubuf, size_t, size,
 	return __sys_recvfrom(fd, ubuf, size, flags, NULL, NULL);
 }
 
+static bool sock_use_custom_sol_socket(const struct socket *sock)
+{
+	const struct sock *sk = sock->sk;
+
+	/* Use sock->ops->setsockopt() for MPTCP */
+	return IS_ENABLED(CONFIG_MPTCP) &&
+	       sk->sk_protocol == IPPROTO_MPTCP &&
+	       sk->sk_type == SOCK_STREAM &&
+	       (sk->sk_family == AF_INET || sk->sk_family == AF_INET6);
+}
+
 /*
  *	Set a socket option. Because we don't know the option lengths we have
  *	to pass the user mode parameter for the protocols to sort out.
@@ -2118,7 +2129,7 @@ static int __sys_setsockopt(int fd, int level, int optname,
 			optval = (char __user __force *)kernel_optval;
 		}
 
-		if (level == SOL_SOCKET)
+		if (level == SOL_SOCKET && !sock_use_custom_sol_socket(sock))
 			err =
 			    sock_setsockopt(sock, level, optname, optval,
 					    optlen);
-- 
2.26.2

