Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E71C112525B
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 20:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727564AbfLRTzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 14:55:17 -0500
Received: from mga05.intel.com ([192.55.52.43]:2229 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727541AbfLRTzR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 14:55:17 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 11:55:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="213019953"
Received: from mjmartin-nuc01.amr.corp.intel.com ([10.241.98.42])
  by fmsmga008.fm.intel.com with ESMTP; 18 Dec 2019 11:55:14 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Peter Krystad <peter.krystad@linux.intel.com>,
        Florian Westphal <fw@strlen.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next v2 07/15] mptcp: Add shutdown() socket operation
Date:   Wed, 18 Dec 2019 11:55:02 -0800
Message-Id: <20191218195510.7782-8-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218195510.7782-1-mathew.j.martineau@linux.intel.com>
References: <20191218195510.7782-1-mathew.j.martineau@linux.intel.com>
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
index 593af94e0b57..443425948922 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -197,6 +197,29 @@ static int mptcp_init_sock(struct sock *sk)
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
@@ -274,6 +297,7 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 			*err = -ENOBUFS;
 			local_bh_enable();
 			release_sock(sk);
+			mptcp_subflow_shutdown(newsk, SHUT_RDWR + 1);
 			tcp_close(newsk, 0);
 			return NULL;
 		}
@@ -547,6 +571,46 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
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
@@ -567,6 +631,7 @@ void __init mptcp_init(void)
 	mptcp_stream_ops.accept = mptcp_stream_accept;
 	mptcp_stream_ops.getname = mptcp_v4_getname;
 	mptcp_stream_ops.listen = mptcp_listen;
+	mptcp_stream_ops.shutdown = mptcp_shutdown;
 
 	mptcp_subflow_init();
 
@@ -616,6 +681,7 @@ int mptcpv6_init(void)
 	mptcp_v6_stream_ops.accept = mptcp_stream_accept;
 	mptcp_v6_stream_ops.getname = mptcp_v6_getname;
 	mptcp_v6_stream_ops.listen = mptcp_listen;
+	mptcp_v6_stream_ops.shutdown = mptcp_shutdown;
 
 	err = inet6_register_protosw(&mptcp_v6_protosw);
 	if (err)
-- 
2.24.1

