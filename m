Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D879511F081
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 07:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbfLNGEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 01:04:38 -0500
Received: from mga06.intel.com ([134.134.136.31]:24723 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726094AbfLNGEg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Dec 2019 01:04:36 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2019 22:04:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,312,1571727600"; 
   d="scan'208";a="216855222"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.17.224])
  by orsmga003.jf.intel.com with ESMTP; 13 Dec 2019 22:04:33 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Peter Krystad <peter.krystad@linux.intel.com>,
        Florian Westphal <fw@strlen.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 07/15] mptcp: Add shutdown() socket operation
Date:   Fri, 13 Dec 2019 22:04:09 -0800
Message-Id: <20191214060417.2870-8-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191214060417.2870-1-mathew.j.martineau@linux.intel.com>
References: <20191214060417.2870-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Krystad <peter.krystad@linux.intel.com>

Call shutdown on all subflows in use on the given socket, or on the
fallback socket.

Co-developed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 66 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 19b1250bb8cc..6298e1d0008b 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -194,6 +194,29 @@ static int mptcp_init_sock(struct sock *sk)
 	return 0;
 }
 
+static void mptcp_subflow_shutdown(struct sock *ssk, int how)
+{
+	lock_sock(ssk);
+
+	switch (ssk->sk_state) {
+	case TCP_LISTEN:
+		if (!(how & RCV_SHUTDOWN))
+			break;
+		/* fall through */
+	case TCP_SYN_SENT:
+		tcp_disconnect(ssk, O_NONBLOCK);
+		break;
+	default:
+		ssk->sk_shutdown |= how;
+		tcp_shutdown(ssk, how);
+		break;
+	}
+
+	/* Wake up anyone sleeping in poll. */
+	ssk->sk_state_change(ssk);
+	release_sock(ssk);
+}
+
 static void mptcp_close(struct sock *sk, long timeout)
 {
 	struct mptcp_subflow_context *subflow, *tmp;
@@ -271,6 +294,7 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 			*err = -ENOBUFS;
 			local_bh_enable();
 			release_sock(sk);
+			mptcp_subflow_shutdown(newsk, SHUT_RDWR + 1);
 			tcp_close(newsk, 0);
 			return NULL;
 		}
@@ -544,6 +568,46 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 	return mask;
 }
 
+static int mptcp_shutdown(struct socket *sock, int how)
+{
+	struct mptcp_sock *msk = mptcp_sk(sock->sk);
+	struct mptcp_subflow_context *subflow;
+	int ret = 0;
+
+	pr_debug("sk=%p, how=%d", msk, how);
+
+	lock_sock(sock->sk);
+
+	if (how == SHUT_WR || how == SHUT_RDWR)
+		inet_sk_state_store(sock->sk, TCP_FIN_WAIT1);
+
+	how++;
+
+	if ((how & ~SHUTDOWN_MASK) || !how) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	if (sock->state == SS_CONNECTING) {
+		if ((1 << sock->sk->sk_state) &
+		    (TCPF_SYN_SENT | TCPF_SYN_RECV | TCPF_CLOSE))
+			sock->state = SS_DISCONNECTING;
+		else
+			sock->state = SS_CONNECTED;
+	}
+
+	mptcp_for_each_subflow(msk, subflow) {
+		struct sock *tcp_sk = mptcp_subflow_tcp_sock(subflow);
+
+		mptcp_subflow_shutdown(tcp_sk, how);
+	}
+
+out_unlock:
+	release_sock(sock->sk);
+
+	return ret;
+}
+
 static struct proto_ops mptcp_stream_ops;
 
 static struct inet_protosw mptcp_protosw = {
@@ -564,6 +628,7 @@ void __init mptcp_init(void)
 	mptcp_stream_ops.accept = mptcp_stream_accept;
 	mptcp_stream_ops.getname = mptcp_v4_getname;
 	mptcp_stream_ops.listen = mptcp_listen;
+	mptcp_stream_ops.shutdown = mptcp_shutdown;
 
 	mptcp_subflow_init();
 
@@ -613,6 +678,7 @@ int mptcpv6_init(void)
 	mptcp_v6_stream_ops.accept = mptcp_stream_accept;
 	mptcp_v6_stream_ops.getname = mptcp_v6_getname;
 	mptcp_v6_stream_ops.listen = mptcp_listen;
+	mptcp_v6_stream_ops.shutdown = mptcp_shutdown;
 
 	err = inet6_register_protosw(&mptcp_v6_protosw);
 	if (err)
-- 
2.24.1

