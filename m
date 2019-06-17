Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE63049592
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728769AbfFQW65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:58:57 -0400
Received: from mga18.intel.com ([134.134.136.126]:10998 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727516AbfFQW6w (ORCPT <rfc822;netdev@vger.kernel.org>);
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
Subject: [RFC PATCH net-next 13/33] mptcp: Add setsockopt()/getsockopt() socket operations
Date:   Mon, 17 Jun 2019 15:57:48 -0700
Message-Id: <20190617225808.665-14-mathew.j.martineau@linux.intel.com>
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
 net/mptcp/protocol.c | 48 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 6596e594fa5f..3215601b9c43 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -131,6 +131,52 @@ static void mptcp_destroy(struct sock *sk)
 	token_destroy(msk->token);
 }
 
+static int mptcp_setsockopt(struct sock *sk, int level, int optname,
+			    char __user *uoptval, unsigned int optlen)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct socket *subflow;
+	char __kernel *optval;
+
+	pr_debug("msk=%p", msk);
+	if (msk->connection_list) {
+		subflow = msk->connection_list;
+		pr_debug("conn_list->subflow=%p", subflow_ctx(subflow->sk));
+	} else {
+		subflow = msk->subflow;
+		pr_debug("subflow=%p", subflow_ctx(subflow->sk));
+	}
+
+	/* will be treated as __user in tcp_setsockopt */
+	optval = (char __kernel __force *)uoptval;
+
+	return kernel_setsockopt(subflow, level, optname, optval, optlen);
+}
+
+static int mptcp_getsockopt(struct sock *sk, int level, int optname,
+			    char __user *uoptval, int __user *uoption)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct socket *subflow;
+	char __kernel *optval;
+	int __kernel *option;
+
+	pr_debug("msk=%p", msk);
+	if (msk->connection_list) {
+		subflow = msk->connection_list;
+		pr_debug("conn_list->subflow=%p", subflow_ctx(subflow->sk));
+	} else {
+		subflow = msk->subflow;
+		pr_debug("subflow=%p", subflow_ctx(subflow->sk));
+	}
+
+	/* will be treated as __user in tcp_getsockopt */
+	optval = (char __kernel __force *)uoptval;
+	option = (int __kernel __force *)uoption;
+
+	return kernel_getsockopt(subflow, level, optname, optval, option);
+}
+
 static int mptcp_get_port(struct sock *sk, unsigned short snum)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -162,6 +208,8 @@ static struct proto mptcp_prot = {
 	.init		= mptcp_init_sock,
 	.close		= mptcp_close,
 	.accept		= mptcp_accept,
+	.setsockopt	= mptcp_setsockopt,
+	.getsockopt	= mptcp_getsockopt,
 	.shutdown	= tcp_shutdown,
 	.destroy	= mptcp_destroy,
 	.sendmsg	= mptcp_sendmsg,
-- 
2.22.0

