Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8FB836166F
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 01:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237972AbhDOXpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 19:45:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:63174 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236787AbhDOXpc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 19:45:32 -0400
IronPort-SDR: Z5xYgPouBuMfx7Jst7ccg3nSop3KUccE0k1Q0AvZc8ylVZITDrbfTZMyv4Wj6UGdt1TUBuiuMH
 Ia/w4/rrfzAQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9955"; a="215480161"
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="215480161"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2021 16:45:08 -0700
IronPort-SDR: oXcO+T70XrIKJyvX6gmp1SlRTF8xeOQIOPcgBEhYahqiNBFaQ7VZezvLFmdYVrUEEPLiF+CSHA
 qG/P7guI/buw==
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="461793361"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.243.150])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2021 16:45:08 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 06/13] mptcp: setsockopt: handle SO_KEEPALIVE and SO_PRIORITY
Date:   Thu, 15 Apr 2021 16:44:55 -0700
Message-Id: <20210415234502.224225-7-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415234502.224225-1-mathew.j.martineau@linux.intel.com>
References: <20210415234502.224225-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

start with something simple: both take an integer value, both
need to be mirrored to all subflows.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/sockopt.c | 106 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 106 insertions(+)

diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index 27b49543fc58..9be4c94ff4d4 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -45,6 +45,90 @@ static u32 sockopt_seq_reset(const struct sock *sk)
 	return (u32)sk->sk_state << 24u;
 }
 
+static void sockopt_seq_inc(struct mptcp_sock *msk)
+{
+	u32 seq = (msk->setsockopt_seq + 1) & 0x00ffffff;
+
+	msk->setsockopt_seq = sockopt_seq_reset((struct sock *)msk) + seq;
+}
+
+static int mptcp_get_int_option(struct mptcp_sock *msk, sockptr_t optval,
+				unsigned int optlen, int *val)
+{
+	if (optlen < sizeof(int))
+		return -EINVAL;
+
+	if (copy_from_sockptr(val, optval, sizeof(*val)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static void mptcp_sol_socket_sync_intval(struct mptcp_sock *msk, int optname, int val)
+{
+	struct mptcp_subflow_context *subflow;
+	struct sock *sk = (struct sock *)msk;
+
+	lock_sock(sk);
+	sockopt_seq_inc(msk);
+
+	mptcp_for_each_subflow(msk, subflow) {
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+		bool slow = lock_sock_fast(ssk);
+
+		switch (optname) {
+		case SO_KEEPALIVE:
+			if (ssk->sk_prot->keepalive)
+				ssk->sk_prot->keepalive(ssk, !!val);
+			sock_valbool_flag(ssk, SOCK_KEEPOPEN, !!val);
+			break;
+		case SO_PRIORITY:
+			ssk->sk_priority = val;
+			break;
+		}
+
+		subflow->setsockopt_seq = msk->setsockopt_seq;
+		unlock_sock_fast(ssk, slow);
+	}
+
+	release_sock(sk);
+}
+
+static int mptcp_sol_socket_intval(struct mptcp_sock *msk, int optname, int val)
+{
+	sockptr_t optval = KERNEL_SOCKPTR(&val);
+	struct sock *sk = (struct sock *)msk;
+	int ret;
+
+	ret = sock_setsockopt(sk->sk_socket, SOL_SOCKET, optname,
+			      optval, sizeof(val));
+	if (ret)
+		return ret;
+
+	mptcp_sol_socket_sync_intval(msk, optname, val);
+	return 0;
+}
+
+static int mptcp_setsockopt_sol_socket_int(struct mptcp_sock *msk, int optname,
+					   sockptr_t optval, unsigned int optlen)
+{
+	int val, ret;
+
+	ret = mptcp_get_int_option(msk, optval, optlen, &val);
+	if (ret)
+		return ret;
+
+	switch (optname) {
+	case SO_KEEPALIVE:
+		mptcp_sol_socket_sync_intval(msk, optname, val);
+		return 0;
+	case SO_PRIORITY:
+		return mptcp_sol_socket_intval(msk, optname, val);
+	}
+
+	return -ENOPROTOOPT;
+}
+
 static int mptcp_setsockopt_sol_socket(struct mptcp_sock *msk, int optname,
 				       sockptr_t optval, unsigned int optlen)
 {
@@ -71,6 +155,9 @@ static int mptcp_setsockopt_sol_socket(struct mptcp_sock *msk, int optname,
 		}
 		release_sock(sk);
 		return ret;
+	case SO_KEEPALIVE:
+	case SO_PRIORITY:
+		return mptcp_setsockopt_sol_socket_int(msk, optname, optval, optlen);
 	}
 
 	return sock_setsockopt(sk->sk_socket, SOL_SOCKET, optname, optval, optlen);
@@ -371,8 +458,27 @@ int mptcp_getsockopt(struct sock *sk, int level, int optname,
 	return -EOPNOTSUPP;
 }
 
+static void sync_socket_options(struct mptcp_sock *msk, struct sock *ssk)
+{
+	struct sock *sk = (struct sock *)msk;
+
+	if (ssk->sk_prot->keepalive) {
+		if (sock_flag(sk, SOCK_KEEPOPEN))
+			ssk->sk_prot->keepalive(ssk, 1);
+		else
+			ssk->sk_prot->keepalive(ssk, 0);
+	}
+
+	ssk->sk_priority = sk->sk_priority;
+}
+
 static void __mptcp_sockopt_sync(struct mptcp_sock *msk, struct sock *ssk)
 {
+	bool slow = lock_sock_fast(ssk);
+
+	sync_socket_options(msk, ssk);
+
+	unlock_sock_fast(ssk, slow);
 }
 
 void mptcp_sockopt_sync(struct mptcp_sock *msk, struct sock *ssk)
-- 
2.31.1

