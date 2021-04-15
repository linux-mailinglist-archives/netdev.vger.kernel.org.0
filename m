Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 006DD361670
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 01:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237975AbhDOXpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 19:45:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:63180 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236990AbhDOXpc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 19:45:32 -0400
IronPort-SDR: bZRqkQnHubSCGFd/o4yxSbgqS5ZdZ/lSjUgARHW5KaQ6VCai3eQLqwDIs0EtOCxXcsiI6DtRcg
 /M3DCwZRrDNg==
X-IronPort-AV: E=McAfee;i="6200,9189,9955"; a="215480163"
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="215480163"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2021 16:45:08 -0700
IronPort-SDR: vFpny2pXmgm+so3DXvrDbvKrPrc9+NXeOEto9S8toQ3leMVeNh3k2uMI6aSv2ZiXirMlbrRfKE
 2TlMutU2/1bA==
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="461793362"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.243.150])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2021 16:45:08 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 07/13] mptcp: setsockopt: handle receive/send buffer and device bind
Date:   Thu, 15 Apr 2021 16:44:56 -0700
Message-Id: <20210415234502.224225-8-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415234502.224225-1-mathew.j.martineau@linux.intel.com>
References: <20210415234502.224225-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Similar to previous patch: needs to be mirrored to all subflows.

Device bind is simpler: it is only done on the initial (listener) sk.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/sockopt.c | 52 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index 9be4c94ff4d4..bfb9db04d26b 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -85,6 +85,16 @@ static void mptcp_sol_socket_sync_intval(struct mptcp_sock *msk, int optname, in
 		case SO_PRIORITY:
 			ssk->sk_priority = val;
 			break;
+		case SO_SNDBUF:
+		case SO_SNDBUFFORCE:
+			ssk->sk_userlocks |= SOCK_SNDBUF_LOCK;
+			WRITE_ONCE(ssk->sk_sndbuf, sk->sk_sndbuf);
+			break;
+		case SO_RCVBUF:
+		case SO_RCVBUFFORCE:
+			ssk->sk_userlocks |= SOCK_RCVBUF_LOCK;
+			WRITE_ONCE(ssk->sk_rcvbuf, sk->sk_rcvbuf);
+			break;
 		}
 
 		subflow->setsockopt_seq = msk->setsockopt_seq;
@@ -123,6 +133,10 @@ static int mptcp_setsockopt_sol_socket_int(struct mptcp_sock *msk, int optname,
 		mptcp_sol_socket_sync_intval(msk, optname, val);
 		return 0;
 	case SO_PRIORITY:
+	case SO_SNDBUF:
+	case SO_SNDBUFFORCE:
+	case SO_RCVBUF:
+	case SO_RCVBUFFORCE:
 		return mptcp_sol_socket_intval(msk, optname, val);
 	}
 
@@ -139,6 +153,8 @@ static int mptcp_setsockopt_sol_socket(struct mptcp_sock *msk, int optname,
 	switch (optname) {
 	case SO_REUSEPORT:
 	case SO_REUSEADDR:
+	case SO_BINDTODEVICE:
+	case SO_BINDTOIFINDEX:
 		lock_sock(sk);
 		ssock = __mptcp_nmpc_socket(msk);
 		if (!ssock) {
@@ -152,11 +168,19 @@ static int mptcp_setsockopt_sol_socket(struct mptcp_sock *msk, int optname,
 				sk->sk_reuseport = ssock->sk->sk_reuseport;
 			else if (optname == SO_REUSEADDR)
 				sk->sk_reuse = ssock->sk->sk_reuse;
+			else if (optname == SO_BINDTODEVICE)
+				sk->sk_bound_dev_if = ssock->sk->sk_bound_dev_if;
+			else if (optname == SO_BINDTOIFINDEX)
+				sk->sk_bound_dev_if = ssock->sk->sk_bound_dev_if;
 		}
 		release_sock(sk);
 		return ret;
 	case SO_KEEPALIVE:
 	case SO_PRIORITY:
+	case SO_SNDBUF:
+	case SO_SNDBUFFORCE:
+	case SO_RCVBUF:
+	case SO_RCVBUFFORCE:
 		return mptcp_setsockopt_sol_socket_int(msk, optname, optval, optlen);
 	}
 
@@ -460,6 +484,7 @@ int mptcp_getsockopt(struct sock *sk, int level, int optname,
 
 static void sync_socket_options(struct mptcp_sock *msk, struct sock *ssk)
 {
+	static const unsigned int tx_rx_locks = SOCK_RCVBUF_LOCK | SOCK_SNDBUF_LOCK;
 	struct sock *sk = (struct sock *)msk;
 
 	if (ssk->sk_prot->keepalive) {
@@ -470,6 +495,33 @@ static void sync_socket_options(struct mptcp_sock *msk, struct sock *ssk)
 	}
 
 	ssk->sk_priority = sk->sk_priority;
+	ssk->sk_bound_dev_if = sk->sk_bound_dev_if;
+	ssk->sk_incoming_cpu = sk->sk_incoming_cpu;
+
+	if (sk->sk_userlocks & tx_rx_locks) {
+		ssk->sk_userlocks |= sk->sk_userlocks & tx_rx_locks;
+		if (sk->sk_userlocks & SOCK_SNDBUF_LOCK)
+			WRITE_ONCE(ssk->sk_sndbuf, sk->sk_sndbuf);
+		if (sk->sk_userlocks & SOCK_RCVBUF_LOCK)
+			WRITE_ONCE(ssk->sk_rcvbuf, sk->sk_rcvbuf);
+	}
+
+	if (sock_flag(sk, SOCK_LINGER)) {
+		ssk->sk_lingertime = sk->sk_lingertime;
+		sock_set_flag(ssk, SOCK_LINGER);
+	} else {
+		sock_reset_flag(ssk, SOCK_LINGER);
+	}
+
+	if (sk->sk_mark != ssk->sk_mark) {
+		ssk->sk_mark = sk->sk_mark;
+		sk_dst_reset(ssk);
+	}
+
+	sock_valbool_flag(ssk, SOCK_DBG, sock_flag(sk, SOCK_DBG));
+
+	if (inet_csk(sk)->icsk_ca_ops != inet_csk(ssk)->icsk_ca_ops)
+		tcp_set_congestion_control(ssk, inet_csk(sk)->icsk_ca_ops->name, false, true);
 }
 
 static void __mptcp_sockopt_sync(struct mptcp_sock *msk, struct sock *ssk)
-- 
2.31.1

