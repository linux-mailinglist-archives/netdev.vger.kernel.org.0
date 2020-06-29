Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB2620DE95
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389110AbgF2U1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:27:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28656 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389094AbgF2U06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 16:26:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593462416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VuK3Aljl4iEpHgRHK34htWZjaEx6EyezHNfrK07PqPc=;
        b=TkzntvAyMyj8mSieQsl6bSKoWyrWX539wARgYZlWKpWACzYIA6BIKZt5X8373Qe2hMz8cc
        IE8xVCcfTMRzMeeAGStGJp+VHYncF8p3NiyoansxnDYshQW47bYUWjVhUB6Xy+j1ytQ8h5
        6fqV526dCuK3jfDqyYOHBYQuSH0A4XU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-kHNcFeF2MRuMg2vIAAX9QQ-1; Mon, 29 Jun 2020 16:26:53 -0400
X-MC-Unique: kHNcFeF2MRuMg2vIAAX9QQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E0CA800C60;
        Mon, 29 Jun 2020 20:26:52 +0000 (UTC)
Received: from new-host-5.redhat.com (unknown [10.40.194.100])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E511B7BEBF;
        Mon, 29 Jun 2020 20:26:50 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.01.org
Subject: [PATCH net-next 4/6] mptcp: create first subflow at msk creation time
Date:   Mon, 29 Jun 2020 22:26:23 +0200
Message-Id: <ce0a43c723147d86dec5ea47f86fa877bf5371b7.1593461586.git.dcaratti@redhat.com>
In-Reply-To: <cover.1593461586.git.dcaratti@redhat.com>
References: <cover.1593461586.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

This cleans the code a bit and makes the behavior more consistent.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/mptcp/protocol.c | 53 +++++++++++++++++---------------------------
 1 file changed, 20 insertions(+), 33 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index dbeb6fe374f5..ad619bda71cc 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -86,32 +86,16 @@ static struct socket *__mptcp_tcp_fallback(struct mptcp_sock *msk)
 	return msk->subflow;
 }
 
-static bool __mptcp_can_create_subflow(const struct mptcp_sock *msk)
-{
-	return !msk->first;
-}
-
-static struct socket *__mptcp_socket_create(struct mptcp_sock *msk, int state)
+static int __mptcp_socket_create(struct mptcp_sock *msk)
 {
 	struct mptcp_subflow_context *subflow;
 	struct sock *sk = (struct sock *)msk;
 	struct socket *ssock;
 	int err;
 
-	ssock = __mptcp_tcp_fallback(msk);
-	if (unlikely(ssock))
-		return ssock;
-
-	ssock = __mptcp_nmpc_socket(msk);
-	if (ssock)
-		goto set_state;
-
-	if (!__mptcp_can_create_subflow(msk))
-		return ERR_PTR(-EINVAL);
-
 	err = mptcp_subflow_create_socket(sk, &ssock);
 	if (err)
-		return ERR_PTR(err);
+		return err;
 
 	msk->first = ssock->sk;
 	msk->subflow = ssock;
@@ -124,10 +108,7 @@ static struct socket *__mptcp_socket_create(struct mptcp_sock *msk, int state)
 	 */
 	RCU_INIT_POINTER(msk->first->sk_wq, &sk->sk_socket->wq);
 
-set_state:
-	if (state != MPTCP_SAME_STATE)
-		inet_sk_state_store(sk, state);
-	return ssock;
+	return 0;
 }
 
 static void __mptcp_move_skb(struct mptcp_sock *msk, struct sock *ssk,
@@ -1255,6 +1236,10 @@ static int mptcp_init_sock(struct sock *sk)
 	if (ret)
 		return ret;
 
+	ret = __mptcp_socket_create(mptcp_sk(sk));
+	if (ret)
+		return ret;
+
 	sk_sockets_allocated_inc(sk);
 	sk->sk_sndbuf = sock_net(sk)->ipv4.sysctl_tcp_wmem[2];
 
@@ -1744,9 +1729,9 @@ static int mptcp_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	int err;
 
 	lock_sock(sock->sk);
-	ssock = __mptcp_socket_create(msk, MPTCP_SAME_STATE);
-	if (IS_ERR(ssock)) {
-		err = PTR_ERR(ssock);
+	ssock = __mptcp_nmpc_socket(msk);
+	if (!ssock) {
+		err = -EINVAL;
 		goto unlock;
 	}
 
@@ -1776,13 +1761,14 @@ static int mptcp_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 		goto do_connect;
 	}
 
-	mptcp_token_destroy(msk);
-	ssock = __mptcp_socket_create(msk, TCP_SYN_SENT);
-	if (IS_ERR(ssock)) {
-		err = PTR_ERR(ssock);
+	ssock = __mptcp_nmpc_socket(msk);
+	if (!ssock) {
+		err = -EINVAL;
 		goto unlock;
 	}
 
+	mptcp_token_destroy(msk);
+	inet_sk_state_store(sock->sk, TCP_SYN_SENT);
 	subflow = mptcp_subflow_ctx(ssock->sk);
 #ifdef CONFIG_TCP_MD5SIG
 	/* no MPTCP if MD5SIG is enabled on this socket or we may run out of
@@ -1820,13 +1806,14 @@ static int mptcp_listen(struct socket *sock, int backlog)
 	pr_debug("msk=%p", msk);
 
 	lock_sock(sock->sk);
-	mptcp_token_destroy(msk);
-	ssock = __mptcp_socket_create(msk, TCP_LISTEN);
-	if (IS_ERR(ssock)) {
-		err = PTR_ERR(ssock);
+	ssock = __mptcp_nmpc_socket(msk);
+	if (!ssock) {
+		err = -EINVAL;
 		goto unlock;
 	}
 
+	mptcp_token_destroy(msk);
+	inet_sk_state_store(sock->sk, TCP_LISTEN);
 	sock_set_flag(sock->sk, SOCK_RCU_FREE);
 
 	err = ssock->ops->listen(ssock, backlog);
-- 
2.26.2

