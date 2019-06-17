Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 910994959F
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbfFQW7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:59:40 -0400
Received: from mga18.intel.com ([134.134.136.126]:10995 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728293AbfFQW6w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 18:58:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 15:58:50 -0700
X-ExtLoop1: 1
Received: from mjmartin-nuc01.amr.corp.intel.com (HELO mjmartin-nuc01.sea.intel.com) ([10.241.98.42])
  by orsmga002.jf.intel.com with ESMTP; 17 Jun 2019 15:58:50 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     edumazet@google.com, netdev@vger.kernel.org
Cc:     Peter Krystad <peter.krystad@linux.intel.com>, cpaasch@apple.com,
        fw@strlen.de, pabeni@redhat.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH net-next 12/33] mptcp: Add shutdown() socket operation
Date:   Mon, 17 Jun 2019 15:57:47 -0700
Message-Id: <20190617225808.665-13-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
References: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Krystad <peter.krystad@linux.intel.com>

Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
---
 net/mptcp/protocol.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 2f340ef8e281..6596e594fa5f 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -296,6 +296,26 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 	return tcp_poll(file, msk->connection_list, wait);
 }
 
+static int mptcp_shutdown(struct socket *sock, int how)
+{
+	struct mptcp_sock *msk = mptcp_sk(sock->sk);
+	int ret = 0;
+
+	pr_debug("sk=%p, how=%d", msk, how);
+
+	if (msk->subflow) {
+		pr_debug("subflow=%p", msk->subflow->sk);
+		ret = kernel_sock_shutdown(msk->subflow, how);
+	}
+
+	if (msk->connection_list) {
+		pr_debug("conn_list->subflow=%p", msk->connection_list->sk);
+		ret = kernel_sock_shutdown(msk->connection_list, how);
+	}
+
+	return ret;
+}
+
 static struct proto_ops mptcp_stream_ops;
 
 static struct inet_protosw mptcp_protosw = {
@@ -316,6 +336,7 @@ void __init mptcp_init(void)
 	mptcp_stream_ops.accept = mptcp_stream_accept;
 	mptcp_stream_ops.getname = mptcp_getname;
 	mptcp_stream_ops.listen = mptcp_listen;
+	mptcp_stream_ops.shutdown = mptcp_shutdown;
 
 	token_init();
 	crypto_init();
-- 
2.22.0

