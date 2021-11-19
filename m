Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0BAE4577D8
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 21:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235605AbhKSUpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 15:45:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:43531 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232401AbhKSUoy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 15:44:54 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10173"; a="231971909"
X-IronPort-AV: E=Sophos;i="5.87,248,1631602800"; 
   d="scan'208";a="231971909"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2021 12:41:49 -0800
X-IronPort-AV: E=Sophos;i="5.87,248,1631602800"; 
   d="scan'208";a="506889225"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.14.166])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2021 12:41:48 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 3/4] mptcp: sockopt: add SOL_IP freebind & transparent options
Date:   Fri, 19 Nov 2021 12:41:36 -0800
Message-Id: <20211119204137.415733-4-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211119204137.415733-1-mathew.j.martineau@linux.intel.com>
References: <20211119204137.415733-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

These options also need to be set before bind, so do the sync of msk to
new ssk socket a bit earlier.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/sockopt.c | 66 ++++++++++++++++++++++++++++++++++++++++++++-
 net/mptcp/subflow.c |  3 ++-
 2 files changed, 67 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index b452571e8d9b..fb43e145cb57 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -390,6 +390,8 @@ static int mptcp_setsockopt_v6(struct mptcp_sock *msk, int optname,
 
 	switch (optname) {
 	case IPV6_V6ONLY:
+	case IPV6_TRANSPARENT:
+	case IPV6_FREEBIND:
 		lock_sock(sk);
 		ssock = __mptcp_nmpc_socket(msk);
 		if (!ssock) {
@@ -398,8 +400,24 @@ static int mptcp_setsockopt_v6(struct mptcp_sock *msk, int optname,
 		}
 
 		ret = tcp_setsockopt(ssock->sk, SOL_IPV6, optname, optval, optlen);
-		if (ret == 0)
+		if (ret != 0) {
+			release_sock(sk);
+			return ret;
+		}
+
+		sockopt_seq_inc(msk);
+
+		switch (optname) {
+		case IPV6_V6ONLY:
 			sk->sk_ipv6only = ssock->sk->sk_ipv6only;
+			break;
+		case IPV6_TRANSPARENT:
+			inet_sk(sk)->transparent = inet_sk(ssock->sk)->transparent;
+			break;
+		case IPV6_FREEBIND:
+			inet_sk(sk)->freebind = inet_sk(ssock->sk)->freebind;
+			break;
+		}
 
 		release_sock(sk);
 		break;
@@ -598,6 +616,46 @@ static int mptcp_setsockopt_sol_tcp_congestion(struct mptcp_sock *msk, sockptr_t
 	return ret;
 }
 
+static int mptcp_setsockopt_sol_ip_set_transparent(struct mptcp_sock *msk, int optname,
+						   sockptr_t optval, unsigned int optlen)
+{
+	struct sock *sk = (struct sock *)msk;
+	struct inet_sock *issk;
+	struct socket *ssock;
+	int err;
+
+	err = ip_setsockopt(sk, SOL_IP, optname, optval, optlen);
+	if (err != 0)
+		return err;
+
+	lock_sock(sk);
+
+	ssock = __mptcp_nmpc_socket(msk);
+	if (!ssock) {
+		release_sock(sk);
+		return -EINVAL;
+	}
+
+	issk = inet_sk(ssock->sk);
+
+	switch (optname) {
+	case IP_FREEBIND:
+		issk->freebind = inet_sk(sk)->freebind;
+		break;
+	case IP_TRANSPARENT:
+		issk->transparent = inet_sk(sk)->transparent;
+		break;
+	default:
+		release_sock(sk);
+		WARN_ON_ONCE(1);
+		return -EOPNOTSUPP;
+	}
+
+	sockopt_seq_inc(msk);
+	release_sock(sk);
+	return 0;
+}
+
 static int mptcp_setsockopt_v4_set_tos(struct mptcp_sock *msk, int optname,
 				       sockptr_t optval, unsigned int optlen)
 {
@@ -627,6 +685,9 @@ static int mptcp_setsockopt_v4(struct mptcp_sock *msk, int optname,
 			       sockptr_t optval, unsigned int optlen)
 {
 	switch (optname) {
+	case IP_FREEBIND:
+	case IP_TRANSPARENT:
+		return mptcp_setsockopt_sol_ip_set_transparent(msk, optname, optval, optlen);
 	case IP_TOS:
 		return mptcp_setsockopt_v4_set_tos(msk, optname, optval, optlen);
 	}
@@ -1068,6 +1129,9 @@ static void sync_socket_options(struct mptcp_sock *msk, struct sock *ssk)
 
 	if (inet_csk(sk)->icsk_ca_ops != inet_csk(ssk)->icsk_ca_ops)
 		tcp_set_congestion_control(ssk, msk->ca_name, false, true);
+
+	inet_sk(ssk)->transparent = inet_sk(sk)->transparent;
+	inet_sk(ssk)->freebind = inet_sk(sk)->freebind;
 }
 
 static void __mptcp_sockopt_sync(struct mptcp_sock *msk, struct sock *ssk)
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 49787a1d7b34..b8dd3441f7d0 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1425,6 +1425,8 @@ int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
 	if (addr.ss_family == AF_INET6)
 		addrlen = sizeof(struct sockaddr_in6);
 #endif
+	mptcp_sockopt_sync(msk, ssk);
+
 	ssk->sk_bound_dev_if = ifindex;
 	err = kernel_bind(sf, (struct sockaddr *)&addr, addrlen);
 	if (err)
@@ -1441,7 +1443,6 @@ int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
 	mptcp_info2sockaddr(remote, &addr, ssk->sk_family);
 
 	mptcp_add_pending_subflow(msk, subflow);
-	mptcp_sockopt_sync(msk, ssk);
 	err = kernel_connect(sf, (struct sockaddr *)&addr, addrlen, O_NONBLOCK);
 	if (err && err != -EINPROGRESS)
 		goto failed_unlink;
-- 
2.34.0

