Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC166C950F
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729481AbfJBXik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:38:40 -0400
Received: from mga04.intel.com ([192.55.52.120]:16452 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728761AbfJBXhV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:37:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:37:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366862593"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.30.230])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 16:37:20 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Florian Westphal <fw@strlen.de>, cpaasch@apple.com,
        pabeni@redhat.com, peter.krystad@linux.intel.com,
        dcaratti@redhat.com, matthieu.baerts@tessares.net
Subject: [RFC PATCH v2 10/45] mptcp: add mptcp_poll
Date:   Wed,  2 Oct 2019 16:36:20 -0700
Message-Id: <20191002233655.24323-11-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
References: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Can't use tcp_poll directly:

BUG: KASAN: slab-out-of-bounds in tcp_poll+0x17f/0x540
Read of size 4 at addr ffff88806ac5e50c by task mptcp_connect/2085
Call Trace:
 tcp_poll+0x17f/0x540
 sock_poll+0x152/0x180

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 95c302c59d2e..07508d060b3d 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -257,6 +257,36 @@ static int mptcp_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	return inet_stream_connect(msk->subflow, uaddr, addr_len, flags);
 }
 
+static __poll_t mptcp_poll(struct file *file, struct socket *sock,
+			   struct poll_table_struct *wait)
+{
+	struct mptcp_subflow_context *subflow;
+	const struct mptcp_sock *msk;
+	struct sock *sk = sock->sk;
+	struct socket *ssock;
+	__poll_t ret = 0;
+
+	msk = mptcp_sk(sk);
+	lock_sock(sk);
+	ssock = __mptcp_fallback_get_ref(msk);
+	if (ssock) {
+		release_sock(sk);
+		ret = tcp_poll(file, ssock, wait);
+		sock_put(ssock->sk);
+		return ret;
+	}
+
+	mptcp_for_each_subflow(msk, subflow) {
+		struct socket *tcp_sock;
+
+		tcp_sock = mptcp_subflow_tcp_socket(subflow);
+		ret |= tcp_poll(file, tcp_sock, wait);
+	}
+	release_sock(sk);
+
+	return ret;
+}
+
 static struct proto_ops mptcp_stream_ops;
 
 static struct inet_protosw mptcp_protosw = {
@@ -273,6 +303,7 @@ void __init mptcp_init(void)
 	mptcp_stream_ops = inet_stream_ops;
 	mptcp_stream_ops.bind = mptcp_bind;
 	mptcp_stream_ops.connect = mptcp_stream_connect;
+	mptcp_stream_ops.poll = mptcp_poll;
 
 	mptcp_subflow_init();
 
-- 
2.23.0

