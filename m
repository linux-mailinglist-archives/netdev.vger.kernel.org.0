Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05CD3DE857
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 10:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234430AbhHCI0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 04:26:30 -0400
Received: from out2.migadu.com ([188.165.223.204]:60212 "EHLO out2.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234390AbhHCI03 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 04:26:29 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1627979175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/v0LmeMUy3UoCS0LwhBauvix/4HwA46AmbAhAkEbA8E=;
        b=u7uFzTyEyADueCuQGCCxAAroQPqolEGeZFGM0AWRyD9c0QmJqCSSPgOlySpRiqtKmDlzc7
        1P//NNrc9CkNxiqdgW0lDbaKRammriCQ04gpGdeDp/TKQdkdzs9UEcrR4glzWhHyj2952x
        sPbgh3o6gwx+rCJp8G45//eAx5nO7Pw=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, mptcp@lists.linux.dev,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-s390@vger.kernel.org, linux-nfs@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH net-next] net: Modify sock_set_keepalive() for more scenarios
Date:   Tue,  3 Aug 2021 16:25:53 +0800
Message-Id: <20210803082553.25194-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add 2nd parameter in sock_set_keepalive(), let the caller decide
whether to set. This can be applied to more scenarios.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 include/net/sock.h    |  2 +-
 net/core/filter.c     |  4 +---
 net/core/sock.c       | 10 ++++------
 net/mptcp/sockopt.c   |  4 +---
 net/rds/tcp_listen.c  |  2 +-
 net/smc/af_smc.c      |  2 +-
 net/sunrpc/xprtsock.c |  2 +-
 7 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index ff1be7e7e90b..0aae26159549 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2772,7 +2772,7 @@ int sock_set_timestamping(struct sock *sk, int optname,
 
 void sock_enable_timestamps(struct sock *sk);
 void sock_no_linger(struct sock *sk);
-void sock_set_keepalive(struct sock *sk);
+void sock_set_keepalive(struct sock *sk, bool valbool);
 void sock_set_priority(struct sock *sk, u32 priority);
 void sock_set_rcvbuf(struct sock *sk, int val);
 void sock_set_mark(struct sock *sk, u32 val);
diff --git a/net/core/filter.c b/net/core/filter.c
index faf29fd82276..41b2bf140b89 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4769,9 +4769,7 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 			ret = sock_bindtoindex(sk, ifindex, false);
 			break;
 		case SO_KEEPALIVE:
-			if (sk->sk_prot->keepalive)
-				sk->sk_prot->keepalive(sk, valbool);
-			sock_valbool_flag(sk, SOCK_KEEPOPEN, valbool);
+			sock_set_keepalive(sk, !!valbool);
 			break;
 		case SO_REUSEPORT:
 			sk->sk_reuseport = valbool;
diff --git a/net/core/sock.c b/net/core/sock.c
index 9671c32e6ef5..7041e6355ae1 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -892,12 +892,12 @@ int sock_set_timestamping(struct sock *sk, int optname,
 	return 0;
 }
 
-void sock_set_keepalive(struct sock *sk)
+void sock_set_keepalive(struct sock *sk, bool valbool)
 {
 	lock_sock(sk);
 	if (sk->sk_prot->keepalive)
-		sk->sk_prot->keepalive(sk, true);
-	sock_valbool_flag(sk, SOCK_KEEPOPEN, true);
+		sk->sk_prot->keepalive(sk, valbool);
+	sock_valbool_flag(sk, SOCK_KEEPOPEN, valbool);
 	release_sock(sk);
 }
 EXPORT_SYMBOL(sock_set_keepalive);
@@ -1060,9 +1060,7 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case SO_KEEPALIVE:
-		if (sk->sk_prot->keepalive)
-			sk->sk_prot->keepalive(sk, valbool);
-		sock_valbool_flag(sk, SOCK_KEEPOPEN, valbool);
+		sock_set_keepalive(sk, !!valbool);
 		break;
 
 	case SO_OOBINLINE:
diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index 8c03afac5ca0..879b8381055c 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -81,9 +81,7 @@ static void mptcp_sol_socket_sync_intval(struct mptcp_sock *msk, int optname, in
 			sock_valbool_flag(ssk, SOCK_DBG, !!val);
 			break;
 		case SO_KEEPALIVE:
-			if (ssk->sk_prot->keepalive)
-				ssk->sk_prot->keepalive(ssk, !!val);
-			sock_valbool_flag(ssk, SOCK_KEEPOPEN, !!val);
+			sock_set_keepalive(ssk, !!val);
 			break;
 		case SO_PRIORITY:
 			ssk->sk_priority = val;
diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
index 09cadd556d1e..b69ebb3f424a 100644
--- a/net/rds/tcp_listen.c
+++ b/net/rds/tcp_listen.c
@@ -44,7 +44,7 @@ void rds_tcp_keepalive(struct socket *sock)
 	int keepidle = 5; /* send a probe 'keepidle' secs after last data */
 	int keepcnt = 5; /* number of unack'ed probes before declaring dead */
 
-	sock_set_keepalive(sock->sk);
+	sock_set_keepalive(sock->sk, true);
 	tcp_sock_set_keepcnt(sock->sk, keepcnt);
 	tcp_sock_set_keepidle(sock->sk, keepidle);
 	/* KEEPINTVL is the interval between successive probes. We follow
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 898389611ae8..ad8f4302037f 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -68,7 +68,7 @@ static void smc_set_keepalive(struct sock *sk, int val)
 {
 	struct smc_sock *smc = smc_sk(sk);
 
-	smc->clcsock->sk->sk_prot->keepalive(smc->clcsock->sk, val);
+	sock_set_keepalive(smc->clcsock->sk, !!val);
 }
 
 static struct smc_hashinfo smc_v4_hashinfo = {
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index e573dcecdd66..306a332f8d28 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2127,7 +2127,7 @@ static void xs_tcp_set_socket_timeouts(struct rpc_xprt *xprt,
 	spin_unlock(&xprt->transport_lock);
 
 	/* TCP Keepalive options */
-	sock_set_keepalive(sock->sk);
+	sock_set_keepalive(sock->sk, true);
 	tcp_sock_set_keepidle(sock->sk, keepidle);
 	tcp_sock_set_keepintvl(sock->sk, keepidle);
 	tcp_sock_set_keepcnt(sock->sk, keepcnt);
-- 
2.32.0

