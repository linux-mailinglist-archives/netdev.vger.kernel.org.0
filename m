Return-Path: <netdev+bounces-6908-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A89DF718A48
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 21:37:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C95E1C20F63
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 19:37:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB15631EF2;
	Wed, 31 May 2023 19:37:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40509200BC;
	Wed, 31 May 2023 19:37:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADBF2C4339E;
	Wed, 31 May 2023 19:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685561837;
	bh=4WKY0Pr/dAihpTUtgtlYI/RMZE9/4UvbyGFh0IkjtPw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ixEsKQZ8xkeS2MoXm5lndgA1dyFJOfDAEHlcCUS6BvFwpWmZfSBdbRgoJzBx//mdA
	 xTWrNm9OtTnTqjcsm3sMiNtHm7LmR3uwMYjCGDy5uzNTtujRPx6caUFcSMpKeSqMKT
	 qEjpS2Fz4fm3oPaF80H0wkjqLbmWncdr1JuGz6yDTxPRSRWHJ5W4DA9bkJDW+ZdhS1
	 RPKBbROm7WZW0CQIIiXrNveniReHgCJtw8/14Tde9ZPx1yd9BUh/anv6kDJ2mi4+/L
	 r2TvjflAX84ERlDxdJ6mqNJKZhhoNar3axlhOSRKLIULLDxut2kmWmsjAvLV5FtRes
	 mpQG1Ev4C7ywQ==
From: Mat Martineau <martineau@kernel.org>
Date: Wed, 31 May 2023 12:37:03 -0700
Subject: [PATCH net 1/6] mptcp: fix connect timeout handling
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230531-send-net-20230531-v1-1-47750c420571@kernel.org>
References: <20230531-send-net-20230531-v1-0-47750c420571@kernel.org>
In-Reply-To: <20230531-send-net-20230531-v1-0-47750c420571@kernel.org>
To: Matthieu Baerts <matthieu.baerts@tessares.net>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Geliang Tang <geliang.tang@suse.com>
Cc: netdev@vger.kernel.org, mptcp@lists.linux.dev, 
 Mat Martineau <martineau@kernel.org>, Ondrej Mosnacek <omosnace@redhat.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.12.2

From: Paolo Abeni <pabeni@redhat.com>

Ondrej reported a functional issue WRT timeout handling on connect
with a nice reproducer.

The problem is that the current mptcp connect waits for both the
MPTCP socket level timeout, and the first subflow socket timeout.
The latter is not influenced/touched by the exposed setsockopt().

Overall the above makes the SO_SNDTIMEO a no-op on connect.

Since mptcp_connect is invoked via inet_stream_connect and the
latter properly handle the MPTCP level timeout, we can address the
issue making the nested subflow level connect always unblocking.

This also allow simplifying a bit the code, dropping an ugly hack
to handle the fastopen and custom proto_ops connect.

The issues predates the blamed commit below, but the current resolution
requires the infrastructure introduced there.

Fixes: 54f1944ed6d2 ("mptcp: factor out mptcp_connect()")
Reported-by: Ondrej Mosnacek <omosnace@redhat.com>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/399
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <martineau@kernel.org>
---
 net/mptcp/protocol.c | 29 +++++++----------------------
 net/mptcp/protocol.h |  1 -
 2 files changed, 7 insertions(+), 23 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 08dc53f56bc2..9cafd3b89908 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1702,7 +1702,6 @@ static int mptcp_sendmsg_fastopen(struct sock *sk, struct msghdr *msg,
 
 	lock_sock(ssk);
 	msg->msg_flags |= MSG_DONTWAIT;
-	msk->connect_flags = O_NONBLOCK;
 	msk->fastopening = 1;
 	ret = tcp_sendmsg_fastopen(ssk, msg, copied_syn, len, NULL);
 	msk->fastopening = 0;
@@ -3617,9 +3616,9 @@ static int mptcp_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	 * acquired the subflow socket lock, too.
 	 */
 	if (msk->fastopening)
-		err = __inet_stream_connect(ssock, uaddr, addr_len, msk->connect_flags, 1);
+		err = __inet_stream_connect(ssock, uaddr, addr_len, O_NONBLOCK, 1);
 	else
-		err = inet_stream_connect(ssock, uaddr, addr_len, msk->connect_flags);
+		err = inet_stream_connect(ssock, uaddr, addr_len, O_NONBLOCK);
 	inet_sk(sk)->defer_connect = inet_sk(ssock->sk)->defer_connect;
 
 	/* on successful connect, the msk state will be moved to established by
@@ -3632,12 +3631,10 @@ static int mptcp_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 
 	mptcp_copy_inaddrs(sk, ssock->sk);
 
-	/* unblocking connect, mptcp-level inet_stream_connect will error out
-	 * without changing the socket state, update it here.
+	/* silence EINPROGRESS and let the caller inet_stream_connect
+	 * handle the connection in progress
 	 */
-	if (err == -EINPROGRESS)
-		sk->sk_socket->state = ssock->state;
-	return err;
+	return 0;
 }
 
 static struct proto mptcp_prot = {
@@ -3696,18 +3693,6 @@ static int mptcp_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	return err;
 }
 
-static int mptcp_stream_connect(struct socket *sock, struct sockaddr *uaddr,
-				int addr_len, int flags)
-{
-	int ret;
-
-	lock_sock(sock->sk);
-	mptcp_sk(sock->sk)->connect_flags = flags;
-	ret = __inet_stream_connect(sock, uaddr, addr_len, flags, 0);
-	release_sock(sock->sk);
-	return ret;
-}
-
 static int mptcp_listen(struct socket *sock, int backlog)
 {
 	struct mptcp_sock *msk = mptcp_sk(sock->sk);
@@ -3859,7 +3844,7 @@ static const struct proto_ops mptcp_stream_ops = {
 	.owner		   = THIS_MODULE,
 	.release	   = inet_release,
 	.bind		   = mptcp_bind,
-	.connect	   = mptcp_stream_connect,
+	.connect	   = inet_stream_connect,
 	.socketpair	   = sock_no_socketpair,
 	.accept		   = mptcp_stream_accept,
 	.getname	   = inet_getname,
@@ -3954,7 +3939,7 @@ static const struct proto_ops mptcp_v6_stream_ops = {
 	.owner		   = THIS_MODULE,
 	.release	   = inet6_release,
 	.bind		   = mptcp_bind,
-	.connect	   = mptcp_stream_connect,
+	.connect	   = inet_stream_connect,
 	.socketpair	   = sock_no_socketpair,
 	.accept		   = mptcp_stream_accept,
 	.getname	   = inet6_getname,
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 2d7b2c80a164..de4667dafe59 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -297,7 +297,6 @@ struct mptcp_sock {
 			nodelay:1,
 			fastopening:1,
 			in_accept_queue:1;
-	int		connect_flags;
 	struct work_struct work;
 	struct sk_buff  *ooo_last_skb;
 	struct rb_root  out_of_order_queue;

-- 
2.40.1


