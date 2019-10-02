Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CEE0C9509
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729446AbfJBXiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:38:20 -0400
Received: from mga04.intel.com ([192.55.52.120]:16463 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729088AbfJBXhk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:37:40 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:37:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366862624"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.30.230])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 16:37:23 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Paolo Abeni <pabeni@redhat.com>, cpaasch@apple.com, fw@strlen.de,
        peter.krystad@linux.intel.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH v2 29/45] mptcp: harmonize locking on all socket operations.
Date:   Wed,  2 Oct 2019 16:36:39 -0700
Message-Id: <20191002233655.24323-30-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
References: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

The locking schema implied by sendmsg(), recvmsg(), etc.
requires acquiring the msk's socket lock before manipulating
the msk internal status.

Additionally, we can't acquire the msk->subflow socket lock while holding
the msk lock, due to mptcp_finish_connect().

Many socket operations do not enforce the required locking, e.g. we have
several patterns alike:

	if (msk->subflow)
		// do something with msk->subflow

or:

	if (!msk->subflow)
		// allocate msk->subflow

all without any lock acquired.

They can race with each other and with mptcp_finish_connect() causing
UAF, null ptr dereference and/or memory leaks.

This patch ensures that all mptcp socket operations access and manipulate
msk->subflow under the msk socket lock. To avoid breaking the locking
assumption introduced by mptcp_finish_connect(), while avoiding UAF
issues, we acquire a reference to the msk->subflow, where needed.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
---
 net/mptcp/protocol.c | 82 +++++++++++++++++++++++++++++++++-----------
 net/mptcp/subflow.c  |  3 --
 2 files changed, 62 insertions(+), 23 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 32d9963c492d..8512cf5e0e0f 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -178,6 +178,7 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	struct sock *ssk;
 	long timeo;
 
+	pr_debug("msk=%p", msk);
 	lock_sock(sk);
 	ssock = __mptcp_fallback_get_ref(msk);
 	if (ssock) {
@@ -846,38 +847,72 @@ static struct proto mptcp_prot = {
 	.no_autobind	= 1,
 };
 
+static struct socket *mptcp_socket_create_get(struct mptcp_sock *msk)
+{
+	struct mptcp_subflow_context *subflow;
+	struct sock *sk = (struct sock *)msk;
+	struct socket *ssock;
+	int err;
+
+	lock_sock(sk);
+	ssock = __mptcp_fallback_get_ref(msk);
+	if (ssock)
+		goto release;
+
+	err = mptcp_subflow_create_socket(sk, &ssock);
+	if (err) {
+		ssock = ERR_PTR(err);
+		goto release;
+	}
+
+	msk->subflow = ssock;
+	subflow = mptcp_subflow_ctx(msk->subflow->sk);
+	subflow->request_mptcp = 1; /* @@ if MPTCP enabled */
+	subflow->request_cksum = 0; /* checksum not supported */
+	subflow->request_version = 0; /* only v0 supported */
+
+	sock_hold(ssock->sk);
+
+release:
+	release_sock(sk);
+	return ssock;
+}
+
 static int mptcp_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 {
 	struct mptcp_sock *msk = mptcp_sk(sock->sk);
+	struct socket *ssock;
 	int err = -ENOTSUPP;
 
 	if (uaddr->sa_family != AF_INET) // @@ allow only IPv4 for now
 		return err;
 
-	if (!msk->subflow) {
-		err = mptcp_subflow_create_socket(sock->sk, &msk->subflow);
-		if (err)
-			return err;
-	}
-	return inet_bind(msk->subflow, uaddr, addr_len);
+	ssock = mptcp_socket_create_get(msk);
+	if (IS_ERR(ssock))
+		return PTR_ERR(ssock);
+
+	err = inet_bind(ssock, uaddr, addr_len);
+	sock_put(ssock->sk);
+	return err;
 }
 
 static int mptcp_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 				int addr_len, int flags)
 {
 	struct mptcp_sock *msk = mptcp_sk(sock->sk);
+	struct socket *ssock;
 	int err = -ENOTSUPP;
 
 	if (uaddr->sa_family != AF_INET) // @@ allow only IPv4 for now
 		return err;
 
-	if (!msk->subflow) {
-		err = mptcp_subflow_create_socket(sock->sk, &msk->subflow);
-		if (err)
-			return err;
-	}
+	ssock = mptcp_socket_create_get(msk);
+	if (IS_ERR(ssock))
+		return PTR_ERR(ssock);
 
-	return inet_stream_connect(msk->subflow, uaddr, addr_len, flags);
+	err = inet_stream_connect(ssock, uaddr, addr_len, flags);
+	sock_put(ssock->sk);
+	return err;
 }
 
 static int mptcp_getname(struct socket *sock, struct sockaddr *uaddr,
@@ -929,29 +964,36 @@ static int mptcp_getname(struct socket *sock, struct sockaddr *uaddr,
 static int mptcp_listen(struct socket *sock, int backlog)
 {
 	struct mptcp_sock *msk = mptcp_sk(sock->sk);
+	struct socket *ssock;
 	int err;
 
 	pr_debug("msk=%p", msk);
 
-	if (!msk->subflow) {
-		err = mptcp_subflow_create_socket(sock->sk, &msk->subflow);
-		if (err)
-			return err;
-	}
-	return inet_listen(msk->subflow, backlog);
+	ssock = mptcp_socket_create_get(msk);
+	if (IS_ERR(ssock))
+		return PTR_ERR(ssock);
+
+	err = inet_listen(ssock, backlog);
+	sock_put(ssock->sk);
+	return err;
 }
 
 static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 			       int flags, bool kern)
 {
 	struct mptcp_sock *msk = mptcp_sk(sock->sk);
+	struct socket *ssock;
+	int err;
 
 	pr_debug("msk=%p", msk);
 
-	if (!msk->subflow)
+	ssock = mptcp_fallback_get_ref(msk);
+	if (!ssock)
 		return -EINVAL;
 
-	return inet_accept(sock, newsock, flags, kern);
+	err = inet_accept(sock, newsock, flags, kern);
+	sock_put(ssock->sk);
+	return err;
 }
 
 static __poll_t mptcp_poll(struct file *file, struct socket *sock,
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 1c3330ab2f30..04f232ff1df0 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -293,9 +293,6 @@ int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock)
 	*new_sock = sf;
 	sock_hold(sk);
 	subflow->conn = sk;
-	subflow->request_mptcp = 1; // @@ if MPTCP enabled
-	subflow->request_cksum = 1; // @@ if checksum enabled
-	subflow->request_version = 0;
 
 	return 0;
 }
-- 
2.23.0

