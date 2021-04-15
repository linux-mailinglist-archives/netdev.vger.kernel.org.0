Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3615361676
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 01:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238074AbhDOXpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 19:45:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:63180 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237286AbhDOXpe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 19:45:34 -0400
IronPort-SDR: fYz+VnwPvZHNww0fc79QT85I0lcM6egSQRTXs6OXH/B8qQ77zIe8Rl7X6sVgRScj4syvKBq6Hv
 8NL9zs4qCIiQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9955"; a="215480176"
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="215480176"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2021 16:45:09 -0700
IronPort-SDR: Imp2wDoSpwpA1P1UsDH17CETDm5zvbXJwn+0i03GGRyRycOtH3VUMS+u9TVwC69PhuhfY/xpFA
 hfQe6ehrnH9w==
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="461793373"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.243.150])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2021 16:45:09 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 12/13] mptcp: sockopt: add TCP_CONGESTION and TCP_INFO
Date:   Thu, 15 Apr 2021 16:45:01 -0700
Message-Id: <20210415234502.224225-13-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415234502.224225-1-mathew.j.martineau@linux.intel.com>
References: <20210415234502.224225-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

TCP_CONGESTION is set for all subflows.
The mptcp socket gains icsk_ca_ops too so it can be used to keep the
authoritative state that should be set on new/future subflows.

TCP_INFO will return first subflow only.
The out-of-tree kernel has a MPTCP_INFO getsockopt, this could be added
later on.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c |   5 +++
 net/mptcp/sockopt.c  | 101 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 106 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 5cba90948a7e..073e20078ed0 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2399,6 +2399,9 @@ static int __mptcp_init_sock(struct sock *sk)
 	/* re-use the csk retrans timer for MPTCP-level retrans */
 	timer_setup(&msk->sk.icsk_retransmit_timer, mptcp_retransmit_timer, 0);
 	timer_setup(&sk->sk_timer, mptcp_timeout_timer, 0);
+
+	tcp_assign_congestion_control(sk);
+
 	return 0;
 }
 
@@ -2592,6 +2595,8 @@ static void __mptcp_destroy_sock(struct sock *sk)
 	WARN_ON_ONCE(msk->rmem_released);
 	sk_stream_kill_queues(sk);
 	xfrm_sk_free_policy(sk);
+
+	tcp_cleanup_congestion_control(sk);
 	sk_refcnt_debug_release(sk);
 	mptcp_dispose_initial_subflow(msk);
 	sock_put(sk);
diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index 390433b7f324..00d941b66c1e 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -510,6 +510,62 @@ static bool mptcp_supported_sockopt(int level, int optname)
 	return false;
 }
 
+static int mptcp_setsockopt_sol_tcp_congestion(struct mptcp_sock *msk, sockptr_t optval,
+					       unsigned int optlen)
+{
+	struct mptcp_subflow_context *subflow;
+	struct sock *sk = (struct sock *)msk;
+	char name[TCP_CA_NAME_MAX];
+	bool cap_net_admin;
+	int ret;
+
+	if (optlen < 1)
+		return -EINVAL;
+
+	ret = strncpy_from_sockptr(name, optval,
+				   min_t(long, TCP_CA_NAME_MAX - 1, optlen));
+	if (ret < 0)
+		return -EFAULT;
+
+	name[ret] = 0;
+
+	cap_net_admin = ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN);
+
+	ret = 0;
+	lock_sock(sk);
+	sockopt_seq_inc(msk);
+	mptcp_for_each_subflow(msk, subflow) {
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+		int err;
+
+		lock_sock(ssk);
+		err = tcp_set_congestion_control(ssk, name, true, cap_net_admin);
+		if (err < 0 && ret == 0)
+			ret = err;
+		subflow->setsockopt_seq = msk->setsockopt_seq;
+		release_sock(ssk);
+	}
+
+	if (ret == 0)
+		tcp_set_congestion_control(sk, name, false, cap_net_admin);
+
+	release_sock(sk);
+	return ret;
+}
+
+static int mptcp_setsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
+				    sockptr_t optval, unsigned int optlen)
+{
+	switch (optname) {
+	case TCP_ULP:
+		return -EOPNOTSUPP;
+	case TCP_CONGESTION:
+		return mptcp_setsockopt_sol_tcp_congestion(msk, optval, optlen);
+	}
+
+	return -EOPNOTSUPP;
+}
+
 int mptcp_setsockopt(struct sock *sk, int level, int optname,
 		     sockptr_t optval, unsigned int optlen)
 {
@@ -539,6 +595,49 @@ int mptcp_setsockopt(struct sock *sk, int level, int optname,
 	if (level == SOL_IPV6)
 		return mptcp_setsockopt_v6(msk, optname, optval, optlen);
 
+	if (level == SOL_TCP)
+		return mptcp_setsockopt_sol_tcp(msk, optname, optval, optlen);
+
+	return -EOPNOTSUPP;
+}
+
+static int mptcp_getsockopt_first_sf_only(struct mptcp_sock *msk, int level, int optname,
+					  char __user *optval, int __user *optlen)
+{
+	struct sock *sk = (struct sock *)msk;
+	struct socket *ssock;
+	int ret = -EINVAL;
+	struct sock *ssk;
+
+	lock_sock(sk);
+	ssk = msk->first;
+	if (ssk) {
+		ret = tcp_getsockopt(ssk, level, optname, optval, optlen);
+		goto out;
+	}
+
+	ssock = __mptcp_nmpc_socket(msk);
+	if (!ssock)
+		goto out;
+
+	ret = tcp_getsockopt(ssock->sk, level, optname, optval, optlen);
+
+out:
+	release_sock(sk);
+	return ret;
+}
+
+static int mptcp_getsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
+				    char __user *optval, int __user *optlen)
+{
+	switch (optname) {
+	case TCP_ULP:
+	case TCP_CONGESTION:
+	case TCP_INFO:
+	case TCP_CC_INFO:
+		return mptcp_getsockopt_first_sf_only(msk, SOL_TCP, optname,
+						      optval, optlen);
+	}
 	return -EOPNOTSUPP;
 }
 
@@ -562,6 +661,8 @@ int mptcp_getsockopt(struct sock *sk, int level, int optname,
 	if (ssk)
 		return tcp_getsockopt(ssk, level, optname, optval, option);
 
+	if (level == SOL_TCP)
+		return mptcp_getsockopt_sol_tcp(msk, optname, optval, option);
 	return -EOPNOTSUPP;
 }
 
-- 
2.31.1

