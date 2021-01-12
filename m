Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D14B82F370F
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 18:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390350AbhALR1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 12:27:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35355 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729952AbhALR1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 12:27:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610472353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iWnPwHmwpPq8dtT0EJ/0cNl6TcaYEVCoOV2Vqd6D1Gw=;
        b=BeNxSWIF9gRFZHWZA/WriAYgecLHZPmWXnjcIBBHH1DS17CXvjsjrJus1ihaVyU2eHGBUI
        ySnHj9K+okE/7L6P0TyPbKS2FBTkrzoKOkNjC/7GL2PoKCqUeOpCvUl6zi0pGE/5k048/6
        Z0WisBDK5tq2KtShdqYzYLFQj9HxAtg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-DDwjxtAJPtuQbMuh-d_Big-1; Tue, 12 Jan 2021 12:25:51 -0500
X-MC-Unique: DDwjxtAJPtuQbMuh-d_Big-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 84CF88049C1;
        Tue, 12 Jan 2021 17:25:50 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-120.ams2.redhat.com [10.36.115.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B4FA1975E;
        Tue, 12 Jan 2021 17:25:49 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 2/2] mptcp: better msk-level shutdown.
Date:   Tue, 12 Jan 2021 18:25:24 +0100
Message-Id: <4cd18371d7caa6ee4a4e7ef988b50b45e362e177.1610471474.git.pabeni@redhat.com>
In-Reply-To: <cover.1610471474.git.pabeni@redhat.com>
References: <cover.1610471474.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of re-implementing most of inet_shutdown, re-use
such helper, and implement the MPTCP-specific bits at the
'proto' level.

The msk-level disconnect() can now be invoked, lets provide a
suitable implementation.

As a side effect, this fixes bad state management for listener
sockets. The latter could lead to division by 0 oops since
commit ea4ca586b16f ("mptcp: refine MPTCP-level ack scheduling").

Fixes: 43b54c6ee382 ("mptcp: Use full MPTCP-level disconnect state machine")
Fixes: ea4ca586b16f ("mptcp: refine MPTCP-level ack scheduling")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 62 ++++++++++++--------------------------------
 1 file changed, 17 insertions(+), 45 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 2ff8c7caf74f..81faeff8f3bb 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2642,11 +2642,12 @@ static void mptcp_copy_inaddrs(struct sock *msk, const struct sock *ssk)
 
 static int mptcp_disconnect(struct sock *sk, int flags)
 {
-	/* Should never be called.
-	 * inet_stream_connect() calls ->disconnect, but that
-	 * refers to the subflow socket, not the mptcp one.
-	 */
-	WARN_ON_ONCE(1);
+	struct mptcp_subflow_context *subflow;
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
+	__mptcp_flush_join_list(msk);
+	mptcp_for_each_subflow(msk, subflow)
+		tcp_disconnect(mptcp_subflow_tcp_sock(subflow), flags);
 	return 0;
 }
 
@@ -3089,6 +3090,14 @@ bool mptcp_finish_join(struct sock *ssk)
 	return true;
 }
 
+static void mptcp_shutdown(struct sock *sk, int how)
+{
+	pr_debug("sk=%p, how=%d", sk, how);
+
+	if ((how & SEND_SHUTDOWN) && mptcp_close_state(sk))
+		__mptcp_wr_shutdown(sk);
+}
+
 static struct proto mptcp_prot = {
 	.name		= "MPTCP",
 	.owner		= THIS_MODULE,
@@ -3098,7 +3107,7 @@ static struct proto mptcp_prot = {
 	.accept		= mptcp_accept,
 	.setsockopt	= mptcp_setsockopt,
 	.getsockopt	= mptcp_getsockopt,
-	.shutdown	= tcp_shutdown,
+	.shutdown	= mptcp_shutdown,
 	.destroy	= mptcp_destroy,
 	.sendmsg	= mptcp_sendmsg,
 	.recvmsg	= mptcp_recvmsg,
@@ -3344,43 +3353,6 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 	return mask;
 }
 
-static int mptcp_shutdown(struct socket *sock, int how)
-{
-	struct mptcp_sock *msk = mptcp_sk(sock->sk);
-	struct sock *sk = sock->sk;
-	int ret = 0;
-
-	pr_debug("sk=%p, how=%d", msk, how);
-
-	lock_sock(sk);
-
-	how++;
-	if ((how & ~SHUTDOWN_MASK) || !how) {
-		ret = -EINVAL;
-		goto out_unlock;
-	}
-
-	if (sock->state == SS_CONNECTING) {
-		if ((1 << sk->sk_state) &
-		    (TCPF_SYN_SENT | TCPF_SYN_RECV | TCPF_CLOSE))
-			sock->state = SS_DISCONNECTING;
-		else
-			sock->state = SS_CONNECTED;
-	}
-
-	sk->sk_shutdown |= how;
-	if ((how & SEND_SHUTDOWN) && mptcp_close_state(sk))
-		__mptcp_wr_shutdown(sk);
-
-	/* Wake up anyone sleeping in poll. */
-	sk->sk_state_change(sk);
-
-out_unlock:
-	release_sock(sk);
-
-	return ret;
-}
-
 static const struct proto_ops mptcp_stream_ops = {
 	.family		   = PF_INET,
 	.owner		   = THIS_MODULE,
@@ -3394,7 +3366,7 @@ static const struct proto_ops mptcp_stream_ops = {
 	.ioctl		   = inet_ioctl,
 	.gettstamp	   = sock_gettstamp,
 	.listen		   = mptcp_listen,
-	.shutdown	   = mptcp_shutdown,
+	.shutdown	   = inet_shutdown,
 	.setsockopt	   = sock_common_setsockopt,
 	.getsockopt	   = sock_common_getsockopt,
 	.sendmsg	   = inet_sendmsg,
@@ -3444,7 +3416,7 @@ static const struct proto_ops mptcp_v6_stream_ops = {
 	.ioctl		   = inet6_ioctl,
 	.gettstamp	   = sock_gettstamp,
 	.listen		   = mptcp_listen,
-	.shutdown	   = mptcp_shutdown,
+	.shutdown	   = inet_shutdown,
 	.setsockopt	   = sock_common_setsockopt,
 	.getsockopt	   = sock_common_getsockopt,
 	.sendmsg	   = inet6_sendmsg,
-- 
2.26.2

