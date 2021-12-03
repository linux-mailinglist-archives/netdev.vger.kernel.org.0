Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8912467FF9
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 23:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383446AbhLCWjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 17:39:22 -0500
Received: from mga18.intel.com ([134.134.136.126]:46471 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383441AbhLCWjV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 17:39:21 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10187"; a="223940939"
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="223940939"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2021 14:35:48 -0800
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="460185315"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.18.88])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2021 14:35:48 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Maxim Galaganov <max@internet.ru>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 10/10] mptcp: support TCP_CORK and TCP_NODELAY
Date:   Fri,  3 Dec 2021 14:35:41 -0800
Message-Id: <20211203223541.69364-11-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211203223541.69364-1-mathew.j.martineau@linux.intel.com>
References: <20211203223541.69364-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Galaganov <max@internet.ru>

First, add cork and nodelay fields to the mptcp_sock structure
so they can be used in sync_socket_options(), and fill them on setsockopt
while holding the msk socket lock.

Then, on setsockopt set proper tcp_sk(ssk)->nonagle values for subflows
by calling __tcp_sock_set_cork() or __tcp_sock_set_nodelay() on the ssk
while holding the ssk socket lock.

tcp_push_pending_frames() will be invoked on the ssk if a cork was cleared
or nodelay was set. Also set MPTCP_PUSH_PENDING bit by calling
mptcp_check_and_set_pending(). This will lead to __mptcp_push_pending()
being called inside mptcp_release_cb() with new tcp_sk(ssk)->nonagle.

Also add getsockopt support for TCP_CORK and TCP_NODELAY.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Maxim Galaganov <max@internet.ru>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.h |  4 ++-
 net/mptcp/sockopt.c  | 70 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 147b22da41ca..e1469155fb15 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -249,7 +249,9 @@ struct mptcp_sock {
 	bool		rcv_fastclose;
 	bool		use_64bit_ack; /* Set when we received a 64-bit DSN */
 	bool		csum_enabled;
-	u8		recvmsg_inq:1;
+	u8		recvmsg_inq:1,
+			cork:1,
+			nodelay:1;
 	spinlock_t	join_list_lock;
 	struct work_struct work;
 	struct sk_buff  *ooo_last_skb;
diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index 44e0a37c567c..3c3db22fd36a 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -616,6 +616,66 @@ static int mptcp_setsockopt_sol_tcp_congestion(struct mptcp_sock *msk, sockptr_t
 	return ret;
 }
 
+static int mptcp_setsockopt_sol_tcp_cork(struct mptcp_sock *msk, sockptr_t optval,
+					 unsigned int optlen)
+{
+	struct mptcp_subflow_context *subflow;
+	struct sock *sk = (struct sock *)msk;
+	int val;
+
+	if (optlen < sizeof(int))
+		return -EINVAL;
+
+	if (copy_from_sockptr(&val, optval, sizeof(val)))
+		return -EFAULT;
+
+	lock_sock(sk);
+	sockopt_seq_inc(msk);
+	msk->cork = !!val;
+	mptcp_for_each_subflow(msk, subflow) {
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+
+		lock_sock(ssk);
+		__tcp_sock_set_cork(ssk, !!val);
+		release_sock(ssk);
+	}
+	if (!val)
+		mptcp_check_and_set_pending(sk);
+	release_sock(sk);
+
+	return 0;
+}
+
+static int mptcp_setsockopt_sol_tcp_nodelay(struct mptcp_sock *msk, sockptr_t optval,
+					    unsigned int optlen)
+{
+	struct mptcp_subflow_context *subflow;
+	struct sock *sk = (struct sock *)msk;
+	int val;
+
+	if (optlen < sizeof(int))
+		return -EINVAL;
+
+	if (copy_from_sockptr(&val, optval, sizeof(val)))
+		return -EFAULT;
+
+	lock_sock(sk);
+	sockopt_seq_inc(msk);
+	msk->nodelay = !!val;
+	mptcp_for_each_subflow(msk, subflow) {
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+
+		lock_sock(ssk);
+		__tcp_sock_set_nodelay(ssk, !!val);
+		release_sock(ssk);
+	}
+	if (val)
+		mptcp_check_and_set_pending(sk);
+	release_sock(sk);
+
+	return 0;
+}
+
 static int mptcp_setsockopt_sol_ip_set_transparent(struct mptcp_sock *msk, int optname,
 						   sockptr_t optval, unsigned int optlen)
 {
@@ -717,6 +777,10 @@ static int mptcp_setsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
 		return -EOPNOTSUPP;
 	case TCP_CONGESTION:
 		return mptcp_setsockopt_sol_tcp_congestion(msk, optval, optlen);
+	case TCP_CORK:
+		return mptcp_setsockopt_sol_tcp_cork(msk, optval, optlen);
+	case TCP_NODELAY:
+		return mptcp_setsockopt_sol_tcp_nodelay(msk, optval, optlen);
 	}
 
 	return -EOPNOTSUPP;
@@ -1087,6 +1151,10 @@ static int mptcp_getsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
 						      optval, optlen);
 	case TCP_INQ:
 		return mptcp_put_int_option(msk, optval, optlen, msk->recvmsg_inq);
+	case TCP_CORK:
+		return mptcp_put_int_option(msk, optval, optlen, msk->cork);
+	case TCP_NODELAY:
+		return mptcp_put_int_option(msk, optval, optlen, msk->nodelay);
 	}
 	return -EOPNOTSUPP;
 }
@@ -1189,6 +1257,8 @@ static void sync_socket_options(struct mptcp_sock *msk, struct sock *ssk)
 
 	if (inet_csk(sk)->icsk_ca_ops != inet_csk(ssk)->icsk_ca_ops)
 		tcp_set_congestion_control(ssk, msk->ca_name, false, true);
+	__tcp_sock_set_cork(ssk, !!msk->cork);
+	__tcp_sock_set_nodelay(ssk, !!msk->nodelay);
 
 	inet_sk(ssk)->transparent = inet_sk(sk)->transparent;
 	inet_sk(ssk)->freebind = inet_sk(sk)->freebind;
-- 
2.34.1

