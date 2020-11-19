Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47BAC2B9BB0
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 20:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbgKSTqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 14:46:18 -0500
Received: from mga04.intel.com ([192.55.52.120]:13142 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727066AbgKSTqO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 14:46:14 -0500
IronPort-SDR: iCRbN35ISroPzGd0m+dP8U2CBX4gpn+hunIJezatCrhwmiXJiErEjF7/ej1SCY/mseQpG0XbyG
 PMf9Dz2i0OUg==
X-IronPort-AV: E=McAfee;i="6000,8403,9810"; a="168780895"
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="168780895"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2020 11:46:09 -0800
IronPort-SDR: 5f+Jm87yNj+gp8grbHBnkYewo/Cri2U8mTSUrI1KIaJAlbXM5F3963D62AFWhsVayu5RGszihG
 Xg//eLgxdUbg==
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="476940481"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.255.229.232])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2020 11:46:09 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, kuba@kernel.org,
        mptcp@lists.01.org, Geliang Tang <geliangtang@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 05/10] mptcp: keep unaccepted MPC subflow into join list
Date:   Thu, 19 Nov 2020 11:45:58 -0800
Message-Id: <20201119194603.103158-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201119194603.103158-1-mathew.j.martineau@linux.intel.com>
References: <20201119194603.103158-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

This will simplify all operation dealing with subflows
before accept time (e.g. data fin processing, add_addr).

The join list is already flushed by mptcp_stream_accept()
before returning the newly created msk to the user space.

This also fixes an potential bug present into the old code:
conn_list was manipulated without helding the msk lock
in mptcp_stream_accept().

Tested-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 24 ++++++++----------------
 net/mptcp/protocol.h |  9 +++++++++
 net/mptcp/subflow.c  | 10 +++++-----
 3 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 806c0658e42f..0e83887efbc8 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2342,7 +2342,6 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 	if (sk_is_mptcp(newsk)) {
 		struct mptcp_subflow_context *subflow;
 		struct sock *new_mptcp_sock;
-		struct sock *ssk = newsk;
 
 		subflow = mptcp_subflow_ctx(newsk);
 		new_mptcp_sock = subflow->conn;
@@ -2357,22 +2356,8 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 
 		/* acquire the 2nd reference for the owning socket */
 		sock_hold(new_mptcp_sock);
-
-		local_bh_disable();
-		bh_lock_sock(new_mptcp_sock);
-		msk = mptcp_sk(new_mptcp_sock);
-		msk->first = newsk;
-
 		newsk = new_mptcp_sock;
-		mptcp_copy_inaddrs(newsk, ssk);
-		list_add(&subflow->node, &msk->conn_list);
-		sock_hold(ssk);
-
-		mptcp_rcv_space_init(msk, ssk);
-		bh_unlock_sock(new_mptcp_sock);
-
-		__MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_MPCAPABLEPASSIVEACK);
-		local_bh_enable();
+		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_MPCAPABLEPASSIVEACK);
 	} else {
 		MPTCP_INC_STATS(sock_net(sk),
 				MPTCP_MIB_MPCAPABLEPASSIVEFALLBACK);
@@ -2823,6 +2808,12 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 	if (err == 0 && !mptcp_is_tcpsk(newsock->sk)) {
 		struct mptcp_sock *msk = mptcp_sk(newsock->sk);
 		struct mptcp_subflow_context *subflow;
+		struct sock *newsk = newsock->sk;
+		bool slowpath;
+
+		slowpath = lock_sock_fast(newsk);
+		mptcp_copy_inaddrs(newsk, msk->first);
+		mptcp_rcv_space_init(msk, msk->first);
 
 		/* set ssk->sk_socket of accept()ed flows to mptcp socket.
 		 * This is needed so NOSPACE flag can be set from tcp stack.
@@ -2834,6 +2825,7 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 			if (!ssk->sk_socket)
 				mptcp_sock_graft(ssk, newsock);
 		}
+		unlock_sock_fast(newsk, slowpath);
 	}
 
 	if (inet_csk_listen_poll(ssock->sk))
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 10fffc5de9e4..7affaf0b1941 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -403,6 +403,15 @@ mptcp_subflow_get_mapped_dsn(const struct mptcp_subflow_context *subflow)
 	return subflow->map_seq + mptcp_subflow_get_map_offset(subflow);
 }
 
+static inline void mptcp_add_pending_subflow(struct mptcp_sock *msk,
+					     struct mptcp_subflow_context *subflow)
+{
+	sock_hold(mptcp_subflow_tcp_sock(subflow));
+	spin_lock_bh(&msk->join_list_lock);
+	list_add_tail(&subflow->node, &msk->join_list);
+	spin_unlock_bh(&msk->join_list_lock);
+}
+
 int mptcp_is_enabled(struct net *net);
 unsigned int mptcp_get_add_addr_timeout(struct net *net);
 void mptcp_subflow_fully_established(struct mptcp_subflow_context *subflow,
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 794259789194..d3c6b3a5ad55 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -578,6 +578,10 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 			 */
 			inet_sk_state_store((void *)new_msk, TCP_ESTABLISHED);
 
+			/* link the newly created socket to the msk */
+			mptcp_add_pending_subflow(mptcp_sk(new_msk), ctx);
+			WRITE_ONCE(mptcp_sk(new_msk)->first, child);
+
 			/* new mpc subflow takes ownership of the newly
 			 * created mptcp socket
 			 */
@@ -1124,11 +1128,7 @@ int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
 	if (err && err != -EINPROGRESS)
 		goto failed;
 
-	sock_hold(ssk);
-	spin_lock_bh(&msk->join_list_lock);
-	list_add_tail(&subflow->node, &msk->join_list);
-	spin_unlock_bh(&msk->join_list_lock);
-
+	mptcp_add_pending_subflow(msk, subflow);
 	return err;
 
 failed:
-- 
2.29.2

