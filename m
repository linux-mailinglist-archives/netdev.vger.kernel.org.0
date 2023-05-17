Return-Path: <netdev+bounces-3432-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59D447071CD
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 21:17:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4EA491C20AD2
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 19:17:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 599FC34CF6;
	Wed, 17 May 2023 19:16:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D23931F12;
	Wed, 17 May 2023 19:16:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A3BC433A0;
	Wed, 17 May 2023 19:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684350994;
	bh=IOY4w35P1hUP7dCa5bCvMMtraUvTn5g+EzA9MRkHVbI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=NQhG6xyaZQeAYi1QeJKehHPIRy+efatwY9ghUL+Bp+Yhe4Jg4k/2HB5uMckZlfXQA
	 wCzaOtnJKc4k7AUwFBJTqGItqU2XyIjmU25f3u0NEW77Tcd3Pkky5eLQwhDwbGcOO7
	 vXnw8NUW56RcE8d330sMrTr1aJXheIw8TynXOHYGVBmTEP4u07n++T62KN6pmyIlVV
	 Mwy60Z8LS983oa8gIcDX7q2pyz8H6f1pYdB+YL3IsVxBREMlvErtBiL13hMs6ermfB
	 8mGxDSsT0GsTJSZU53JH3tKNQdiO3Y9tTEqOQLmE9223P8MXxugEX+/mqfgwxRvvrY
	 lCZTFzfCncucw==
From: Mat Martineau <martineau@kernel.org>
Date: Wed, 17 May 2023 12:16:15 -0700
Subject: [PATCH net-next 2/5] mptcp: refactor mptcp_stream_accept()
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230516-send-net-next-20220516-v1-2-e91822b7b6e0@kernel.org>
References: <20230516-send-net-next-20220516-v1-0-e91822b7b6e0@kernel.org>
In-Reply-To: <20230516-send-net-next-20220516-v1-0-e91822b7b6e0@kernel.org>
To: "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, 
 Matthieu Baerts <matthieu.baerts@tessares.net>
Cc: netdev@vger.kernel.org, mptcp@lists.linux.dev, 
 Mat Martineau <martineau@kernel.org>
X-Mailer: b4 0.12.2

From: Paolo Abeni <pabeni@redhat.com>

Rewrite the mptcp socket accept op, leveraging the new
__inet_accept() helper.

This way we can avoid acquiring the new socket lock twice
and we can avoid a couple of indirect calls.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <martineau@kernel.org>
---
 net/mptcp/protocol.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 08dc53f56bc2..2d331b2d62b7 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3747,6 +3747,7 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 {
 	struct mptcp_sock *msk = mptcp_sk(sock->sk);
 	struct socket *ssock;
+	struct sock *newsk;
 	int err;
 
 	pr_debug("msk=%p", msk);
@@ -3758,17 +3759,20 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 	if (!ssock)
 		return -EINVAL;
 
-	err = ssock->ops->accept(sock, newsock, flags, kern);
-	if (err == 0 && !mptcp_is_tcpsk(newsock->sk)) {
-		struct mptcp_sock *msk = mptcp_sk(newsock->sk);
+	newsk = mptcp_accept(sock->sk, flags, &err, kern);
+	if (!newsk)
+		return err;
+
+	lock_sock(newsk);
+
+	__inet_accept(sock, newsock, newsk);
+	if (!mptcp_is_tcpsk(newsock->sk)) {
+		struct mptcp_sock *msk = mptcp_sk(newsk);
 		struct mptcp_subflow_context *subflow;
-		struct sock *newsk = newsock->sk;
 
 		set_bit(SOCK_CUSTOM_SOCKOPT, &newsock->flags);
 		msk->in_accept_queue = 0;
 
-		lock_sock(newsk);
-
 		/* set ssk->sk_socket of accept()ed flows to mptcp socket.
 		 * This is needed so NOSPACE flag can be set from tcp stack.
 		 */
@@ -3789,11 +3793,10 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 			if (unlikely(list_empty(&msk->conn_list)))
 				inet_sk_state_store(newsk, TCP_CLOSE);
 		}
-
-		release_sock(newsk);
 	}
+	release_sock(newsk);
 
-	return err;
+	return 0;
 }
 
 static __poll_t mptcp_check_writeable(struct mptcp_sock *msk)

-- 
2.40.1


