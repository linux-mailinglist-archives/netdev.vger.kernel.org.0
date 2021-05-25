Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB233390B43
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 23:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbhEYVY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 17:24:58 -0400
Received: from mga14.intel.com ([192.55.52.115]:35473 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232937AbhEYVYv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 17:24:51 -0400
IronPort-SDR: 0yZF5kv3sxfpU8oGRmvlLXcpMGxd9VJ72sDBIBotoVSdr/XBnGXHoZzQXAaC23Wo0GU3AHkpfk
 URLNV/NP+NiA==
X-IronPort-AV: E=McAfee;i="6200,9189,9995"; a="202062419"
X-IronPort-AV: E=Sophos;i="5.82,329,1613462400"; 
   d="scan'208";a="202062419"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2021 14:23:19 -0700
IronPort-SDR: gofOHVjCWJxsVtiklzc9qSVMy4cYeO/DsNvc6q9OBnnLjJYpJE1lMSSZDsskN1zE+kCYKBf5CR
 CaRh5Eg1FHFQ==
X-IronPort-AV: E=Sophos;i="5.82,329,1613462400"; 
   d="scan'208";a="546924972"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.216.142])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2021 14:23:19 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net, mptcp@lists.01.org,
        Florian Westphal <fw@strlen.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 1/4] mptcp: avoid OOB access in setsockopt()
Date:   Tue, 25 May 2021 14:23:10 -0700
Message-Id: <20210525212313.148142-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210525212313.148142-1-mathew.j.martineau@linux.intel.com>
References: <20210525212313.148142-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

We can't use tcp_set_congestion_control() on an mptcp socket, as
such function can end-up accessing a tcp-specific field -
prior_ssthresh - causing an OOB access.

To allow propagating the correct ca algo on subflow, cache the ca
name at initialization time.

Additionally avoid overriding the user-selected CA (if any) at
clone time.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/182
Fixes: aa1fbd94e5c7 ("mptcp: sockopt: add TCP_CONGESTION and TCP_INFO")
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 14 +++++++++++---
 net/mptcp/protocol.h |  1 +
 net/mptcp/sockopt.c  |  4 ++--
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 2d21a4793d9d..2bc199549a88 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2424,13 +2424,12 @@ static int __mptcp_init_sock(struct sock *sk)
 	timer_setup(&msk->sk.icsk_retransmit_timer, mptcp_retransmit_timer, 0);
 	timer_setup(&sk->sk_timer, mptcp_timeout_timer, 0);
 
-	tcp_assign_congestion_control(sk);
-
 	return 0;
 }
 
 static int mptcp_init_sock(struct sock *sk)
 {
+	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct net *net = sock_net(sk);
 	int ret;
 
@@ -2448,6 +2447,16 @@ static int mptcp_init_sock(struct sock *sk)
 	if (ret)
 		return ret;
 
+	/* fetch the ca name; do it outside __mptcp_init_sock(), so that clone will
+	 * propagate the correct value
+	 */
+	tcp_assign_congestion_control(sk);
+	strcpy(mptcp_sk(sk)->ca_name, icsk->icsk_ca_ops->name);
+
+	/* no need to keep a reference to the ops, the name will suffice */
+	tcp_cleanup_congestion_control(sk);
+	icsk->icsk_ca_ops = NULL;
+
 	sk_sockets_allocated_inc(sk);
 	sk->sk_rcvbuf = sock_net(sk)->ipv4.sysctl_tcp_rmem[1];
 	sk->sk_sndbuf = sock_net(sk)->ipv4.sysctl_tcp_wmem[1];
@@ -2622,7 +2631,6 @@ static void __mptcp_destroy_sock(struct sock *sk)
 	sk_stream_kill_queues(sk);
 	xfrm_sk_free_policy(sk);
 
-	tcp_cleanup_congestion_control(sk);
 	sk_refcnt_debug_release(sk);
 	mptcp_dispose_initial_subflow(msk);
 	sock_put(sk);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index edc0128730df..165c8b40b384 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -258,6 +258,7 @@ struct mptcp_sock {
 	} rcvq_space;
 
 	u32 setsockopt_seq;
+	char		ca_name[TCP_CA_NAME_MAX];
 };
 
 #define mptcp_lock_sock(___sk, cb) do {					\
diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index 00d941b66c1e..a79798189599 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -547,7 +547,7 @@ static int mptcp_setsockopt_sol_tcp_congestion(struct mptcp_sock *msk, sockptr_t
 	}
 
 	if (ret == 0)
-		tcp_set_congestion_control(sk, name, false, cap_net_admin);
+		strcpy(msk->ca_name, name);
 
 	release_sock(sk);
 	return ret;
@@ -705,7 +705,7 @@ static void sync_socket_options(struct mptcp_sock *msk, struct sock *ssk)
 	sock_valbool_flag(ssk, SOCK_DBG, sock_flag(sk, SOCK_DBG));
 
 	if (inet_csk(sk)->icsk_ca_ops != inet_csk(ssk)->icsk_ca_ops)
-		tcp_set_congestion_control(ssk, inet_csk(sk)->icsk_ca_ops->name, false, true);
+		tcp_set_congestion_control(ssk, msk->ca_name, false, true);
 }
 
 static void __mptcp_sockopt_sync(struct mptcp_sock *msk, struct sock *ssk)
-- 
2.31.1

