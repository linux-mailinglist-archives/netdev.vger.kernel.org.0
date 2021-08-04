Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEB13DF9FE
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 05:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234871AbhHDD3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 23:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234207AbhHDD3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 23:29:30 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0047AC061764;
        Tue,  3 Aug 2021 20:29:17 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1628047754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zvfYYuqF2FHspYtQC1WvXSu+rBBu+KjB/5LBDoNtRT4=;
        b=FzQTSyOQ2rGO9qwy0o7IpAgbTz+5sSPMs3uY0QXt4erSXgQRqyoNWlVuyN4C/rXYVw9tVg
        0NE/iaz4WcOIznqjpX8v083yMFlbwDD88OWzGNBvs6FNIlazK3Vu7yA3oCN0Y4eJ6Hiih0
        fjABO4ni6e7dK5W1t8uuLLDApcsdv4M=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com
Cc:     cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, mptcp@lists.linux.dev,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-s390@vger.kernel.org, linux-nfs@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH net-next v2] net: Modify sock_set_keepalive() for more scenarios
Date:   Wed,  4 Aug 2021 11:28:56 +0800
Message-Id: <20210804032856.4005-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add 2nd parameter in sock_set_keepalive(), let the caller decide
whether to set. This can be applied to more scenarios.

v2:
 - add the change in fs/dlm.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 fs/dlm/lowcomms.c     |  2 +-
 include/net/sock.h    |  2 +-
 net/core/filter.c     |  4 +---
 net/core/sock.c       | 10 ++++------
 net/mptcp/sockopt.c   |  4 +---
 net/rds/tcp_listen.c  |  2 +-
 net/smc/af_smc.c      |  2 +-
 net/sunrpc/xprtsock.c |  2 +-
 8 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 0ea9ae35da0b..5d748ce4d876 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1356,7 +1356,7 @@ static int tcp_create_listen_sock(struct listen_connection *con,
 		log_print("Can't bind to port %d", dlm_config.ci_tcp_port);
 		goto create_out;
 	}
-	sock_set_keepalive(sock->sk);
+	sock_set_keepalive(sock->sk, true);
 
 	result = sock->ops->listen(sock, 5);
 	if (result < 0) {
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
index 6f493ef5bb14..c73caa53992e 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4752,9 +4752,7 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
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

