Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6A1B214927
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 01:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbgGDXan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 19:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727929AbgGDXam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 19:30:42 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A061C061794
        for <netdev@vger.kernel.org>; Sat,  4 Jul 2020 16:30:42 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jrrcG-0004qF-Jy; Sun, 05 Jul 2020 01:30:40 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     <mptcp@lists.01.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 3/3] mptcp: support IPV6_V6ONLY setsockopt
Date:   Sun,  5 Jul 2020 01:30:17 +0200
Message-Id: <20200704233017.20831-4-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200704233017.20831-1-fw@strlen.de>
References: <20200704233017.20831-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Without this, Opensshd fails to open an ipv6 socket listening
socket:
  error: setsockopt IPV6_V6ONLY: Operation not supported
  error: Bind to port 22 on :: failed: Address already in use.

Opensshd opens an ipv4 and and ipv6 listening socket, but because
IPV6_V6ONLY setsockopt fails, the port number is already in use.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 612f6d49f1bb..3ab060e30038 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1632,6 +1632,33 @@ static int mptcp_setsockopt_sol_socket(struct mptcp_sock *msk, int optname,
 	return sock_setsockopt(sk->sk_socket, SOL_SOCKET, optname, optval, optlen);
 }
 
+static int mptcp_setsockopt_v6(struct mptcp_sock *msk, int optname,
+			       char __user *optval, unsigned int optlen)
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
 static int mptcp_setsockopt(struct sock *sk, int level, int optname,
 			    char __user *optval, unsigned int optlen)
 {
@@ -1655,6 +1682,9 @@ static int mptcp_setsockopt(struct sock *sk, int level, int optname,
 	if (ssk)
 		return tcp_setsockopt(ssk, level, optname, optval, optlen);
 
+	if (level == SOL_IPV6)
+		return mptcp_setsockopt_v6(msk, optname, optval, optlen);
+
 	return -EOPNOTSUPP;
 }
 
-- 
2.26.2

