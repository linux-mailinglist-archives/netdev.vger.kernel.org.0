Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1503C94E8
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbfJBXhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:37:25 -0400
Received: from mga04.intel.com ([192.55.52.120]:16453 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728971AbfJBXhW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:37:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:37:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366862598"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.30.230])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 16:37:21 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Peter Krystad <peter.krystad@linux.intel.com>, cpaasch@apple.com,
        fw@strlen.de, pabeni@redhat.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH v2 14/45] mptcp: Add shutdown() socket operation
Date:   Wed,  2 Oct 2019 16:36:24 -0700
Message-Id: <20191002233655.24323-15-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
References: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Krystad <peter.krystad@linux.intel.com>

Call shutdown on all subflows in use on the given socket, or on the
fallback socket.

Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
---
 net/mptcp/protocol.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 0a9c447db159..dba4d7a4a61a 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -431,6 +431,37 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 	return ret;
 }
 
+static int mptcp_shutdown(struct socket *sock, int how)
+{
+	struct mptcp_sock *msk = mptcp_sk(sock->sk);
+	struct mptcp_subflow_context *subflow;
+	struct socket *ssock;
+	int ret = 0;
+
+	pr_debug("sk=%p, how=%d", msk, how);
+
+	lock_sock(sock->sk);
+	ssock = __mptcp_fallback_get_ref(msk);
+	if (ssock) {
+		release_sock(sock->sk);
+		pr_debug("subflow=%p", ssock->sk);
+		ret = kernel_sock_shutdown(ssock, how);
+		sock_put(ssock->sk);
+		return ret;
+	}
+
+	mptcp_for_each_subflow(msk, subflow) {
+		struct socket *tcp_socket;
+
+		tcp_socket = mptcp_subflow_tcp_socket(subflow);
+		pr_debug("conn_list->subflow=%p", subflow);
+		ret = kernel_sock_shutdown(tcp_socket, how);
+	}
+	release_sock(sock->sk);
+
+	return ret;
+}
+
 static struct proto_ops mptcp_stream_ops;
 
 static struct inet_protosw mptcp_protosw = {
@@ -451,6 +482,7 @@ void __init mptcp_init(void)
 	mptcp_stream_ops.accept = mptcp_stream_accept;
 	mptcp_stream_ops.getname = mptcp_getname;
 	mptcp_stream_ops.listen = mptcp_listen;
+	mptcp_stream_ops.shutdown = mptcp_shutdown;
 
 	mptcp_subflow_init();
 
-- 
2.23.0

