Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE7D11F082
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 07:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbfLNGEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 01:04:39 -0500
Received: from mga06.intel.com ([134.134.136.31]:24723 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726050AbfLNGEg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Dec 2019 01:04:36 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2019 22:04:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,312,1571727600"; 
   d="scan'208";a="216855227"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.17.224])
  by orsmga003.jf.intel.com with ESMTP; 13 Dec 2019 22:04:34 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Florian Westphal <fw@strlen.de>,
        Peter Krystad <peter.krystad@linux.intel.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 11/15] mptcp: add subflow write space signalling and mptcp_poll
Date:   Fri, 13 Dec 2019 22:04:13 -0800
Message-Id: <20191214060417.2870-12-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191214060417.2870-1-mathew.j.martineau@linux.intel.com>
References: <20191214060417.2870-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Add new SEND_SPACE flag to indicate that a subflow has enough space to
accept more data for transmission.

It gets cleared at the end of mptcp_sendmsg() in case ssk has run
below the free watermark.

It is (re-set) from the wspace callback.

This allows us to use msk->flags to determine the poll mask.

Co-developed-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 52 ++++++++++++++++++++++++++++++++++++++++++++
 net/mptcp/protocol.h |  1 +
 net/mptcp/subflow.c  |  2 ++
 3 files changed, 55 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 1ede654057ba..44e6f0d1070c 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -177,6 +177,22 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	return ret;
 }
 
+static void ssk_check_wmem(struct mptcp_sock *msk, struct sock *ssk)
+{
+	struct socket *sock;
+
+	if (likely(sk_stream_is_writeable(ssk)))
+		return;
+
+	sock = READ_ONCE(ssk->sk_socket);
+
+	if (sock) {
+		clear_bit(MPTCP_SEND_SPACE, &msk->flags);
+		smp_mb__after_atomic();
+		set_bit(SOCK_NOSPACE, &sock->flags);
+	}
+}
+
 static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -220,6 +236,7 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	if (copied > 0)
 		ret = copied;
 
+	ssk_check_wmem(msk, ssk);
 	release_sock(ssk);
 	release_sock(sk);
 	return ret;
@@ -315,6 +332,7 @@ static int mptcp_init_sock(struct sock *sk)
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
 	INIT_LIST_HEAD(&msk->conn_list);
+	__set_bit(MPTCP_SEND_SPACE, &msk->flags);
 
 	return 0;
 }
@@ -580,6 +598,13 @@ static void mptcp_sock_graft(struct sock *sk, struct socket *parent)
 	write_unlock_bh(&sk->sk_callback_lock);
 }
 
+static bool mptcp_memory_free(const struct sock *sk, int wake)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
+	return wake ? test_bit(MPTCP_SEND_SPACE, &msk->flags) : true;
+}
+
 static struct proto mptcp_prot = {
 	.name		= "MPTCP",
 	.owner		= THIS_MODULE,
@@ -595,6 +620,7 @@ static struct proto mptcp_prot = {
 	.hash		= inet_hash,
 	.unhash		= inet_unhash,
 	.get_port	= mptcp_get_port,
+	.stream_memory_free	= mptcp_memory_free,
 	.obj_size	= sizeof(struct mptcp_sock),
 	.no_autobind	= true,
 };
@@ -771,8 +797,34 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 			   struct poll_table_struct *wait)
 {
+	const struct mptcp_sock *msk;
+	struct sock *sk = sock->sk;
+	struct socket *ssock;
 	__poll_t mask = 0;
 
+	msk = mptcp_sk(sk);
+	lock_sock(sk);
+	ssock = __mptcp_nmpc_socket(msk);
+	if (ssock) {
+		mask = ssock->ops->poll(file, ssock, wait);
+		release_sock(sk);
+		return mask;
+	}
+
+	release_sock(sk);
+	sock_poll_wait(file, sock, wait);
+	lock_sock(sk);
+
+	if (test_bit(MPTCP_DATA_READY, &msk->flags))
+		mask = EPOLLIN | EPOLLRDNORM;
+	if (sk_stream_is_writeable(sk) &&
+	    test_bit(MPTCP_SEND_SPACE, &msk->flags))
+		mask |= EPOLLOUT | EPOLLWRNORM;
+	if (sk->sk_shutdown & RCV_SHUTDOWN)
+		mask |= EPOLLIN | EPOLLRDNORM | EPOLLRDHUP;
+
+	release_sock(sk);
+
 	return mask;
 }
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index defa51c0dd44..f02dd5c35ec9 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -56,6 +56,7 @@
 
 /* MPTCP socket flags */
 #define MPTCP_DATA_READY	BIT(0)
+#define MPTCP_SEND_SPACE	BIT(1)
 
 /* MPTCP connection sock */
 struct mptcp_sock {
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index da10b5092d8d..269c7fcb8293 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -527,6 +527,8 @@ static void subflow_write_space(struct sock *sk)
 
 	sk_stream_write_space(sk);
 	if (parent && sk_stream_is_writeable(sk)) {
+		set_bit(MPTCP_SEND_SPACE, &mptcp_sk(parent)->flags);
+		smp_mb__after_atomic();
 		sk_stream_write_space(parent);
 	}
 }
-- 
2.24.1

