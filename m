Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3195920DE99
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387853AbgF2U1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:27:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49380 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389106AbgF2U1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 16:27:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593462420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xZ0lrRYkxAl0RydCohzMlCIYdwH9VivECB57kRHXAX0=;
        b=CSxsXTL0QoGDQwwAKDSyazw77X4BZCExSxrbKzpQIlJl1F8kyaMDvFgkKo7byZ++7G+AfT
        kmJCvVSOc2lRXkTSkihSpSbFRnF/OtYawAXnuurv1hdMIcDjgtcG5yBQWD3ufIn7YbKi3E
        iJ9e3hxrV/KhRm1D6VVoKcsUmC/83+4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-FTEP9M3WMN2p2MVq31UheQ-1; Mon, 29 Jun 2020 16:26:51 -0400
X-MC-Unique: FTEP9M3WMN2p2MVq31UheQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 88E0D107ACCA;
        Mon, 29 Jun 2020 20:26:50 +0000 (UTC)
Received: from new-host-5.redhat.com (unknown [10.40.194.100])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EAEE11C4;
        Mon, 29 Jun 2020 20:26:48 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.01.org
Subject: [PATCH net-next 3/6] mptcp: check for plain TCP sock at accept time
Date:   Mon, 29 Jun 2020 22:26:22 +0200
Message-Id: <821ad8ad1581b906b6706426c1ba0c3b837cf60d.1593461586.git.dcaratti@redhat.com>
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

This cleanup the code a bit and avoid corrupted states
on weird syscall sequence (accept(), connect()).

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/mptcp/protocol.c | 69 +++++---------------------------------------
 1 file changed, 7 insertions(+), 62 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 84ae96be9837..dbeb6fe374f5 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -52,13 +52,10 @@ static struct socket *__mptcp_nmpc_socket(const struct mptcp_sock *msk)
 	return msk->subflow;
 }
 
-static struct socket *mptcp_is_tcpsk(struct sock *sk)
+static bool mptcp_is_tcpsk(struct sock *sk)
 {
 	struct socket *sock = sk->sk_socket;
 
-	if (sock->sk != sk)
-		return NULL;
-
 	if (unlikely(sk->sk_prot == &tcp_prot)) {
 		/* we are being invoked after mptcp_accept() has
 		 * accepted a non-mp-capable flow: sk is a tcp_sk,
@@ -68,27 +65,21 @@ static struct socket *mptcp_is_tcpsk(struct sock *sk)
 		 * bypass mptcp.
 		 */
 		sock->ops = &inet_stream_ops;
-		return sock;
+		return true;
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 	} else if (unlikely(sk->sk_prot == &tcpv6_prot)) {
 		sock->ops = &inet6_stream_ops;
-		return sock;
+		return true;
 #endif
 	}
 
-	return NULL;
+	return false;
 }
 
 static struct socket *__mptcp_tcp_fallback(struct mptcp_sock *msk)
 {
-	struct socket *sock;
-
 	sock_owned_by_me((const struct sock *)msk);
 
-	sock = mptcp_is_tcpsk((struct sock *)msk);
-	if (unlikely(sock))
-		return sock;
-
 	if (likely(!__mptcp_check_fallback(msk)))
 		return NULL;
 
@@ -1466,7 +1457,6 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 		return NULL;
 
 	pr_debug("msk=%p, subflow is mptcp=%d", msk, sk_is_mptcp(newsk));
-
 	if (sk_is_mptcp(newsk)) {
 		struct mptcp_subflow_context *subflow;
 		struct sock *new_mptcp_sock;
@@ -1821,42 +1811,6 @@ static int mptcp_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	return err;
 }
 
-static int mptcp_v4_getname(struct socket *sock, struct sockaddr *uaddr,
-			    int peer)
-{
-	if (sock->sk->sk_prot == &tcp_prot) {
-		/* we are being invoked from __sys_accept4, after
-		 * mptcp_accept() has just accepted a non-mp-capable
-		 * flow: sk is a tcp_sk, not an mptcp one.
-		 *
-		 * Hand the socket over to tcp so all further socket ops
-		 * bypass mptcp.
-		 */
-		sock->ops = &inet_stream_ops;
-	}
-
-	return inet_getname(sock, uaddr, peer);
-}
-
-#if IS_ENABLED(CONFIG_MPTCP_IPV6)
-static int mptcp_v6_getname(struct socket *sock, struct sockaddr *uaddr,
-			    int peer)
-{
-	if (sock->sk->sk_prot == &tcpv6_prot) {
-		/* we are being invoked from __sys_accept4 after
-		 * mptcp_accept() has accepted a non-mp-capable
-		 * subflow: sk is a tcp_sk, not mptcp.
-		 *
-		 * Hand the socket over to tcp so all further
-		 * socket ops bypass mptcp.
-		 */
-		sock->ops = &inet6_stream_ops;
-	}
-
-	return inet6_getname(sock, uaddr, peer);
-}
-#endif
-
 static int mptcp_listen(struct socket *sock, int backlog)
 {
 	struct mptcp_sock *msk = mptcp_sk(sock->sk);
@@ -1885,15 +1839,6 @@ static int mptcp_listen(struct socket *sock, int backlog)
 	return err;
 }
 
-static bool is_tcp_proto(const struct proto *p)
-{
-#if IS_ENABLED(CONFIG_MPTCP_IPV6)
-	return p == &tcp_prot || p == &tcpv6_prot;
-#else
-	return p == &tcp_prot;
-#endif
-}
-
 static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 			       int flags, bool kern)
 {
@@ -1915,7 +1860,7 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 	release_sock(sock->sk);
 
 	err = ssock->ops->accept(sock, newsock, flags, kern);
-	if (err == 0 && !is_tcp_proto(newsock->sk->sk_prot)) {
+	if (err == 0 && !mptcp_is_tcpsk(newsock->sk)) {
 		struct mptcp_sock *msk = mptcp_sk(newsock->sk);
 		struct mptcp_subflow_context *subflow;
 
@@ -2011,7 +1956,7 @@ static const struct proto_ops mptcp_stream_ops = {
 	.connect	   = mptcp_stream_connect,
 	.socketpair	   = sock_no_socketpair,
 	.accept		   = mptcp_stream_accept,
-	.getname	   = mptcp_v4_getname,
+	.getname	   = inet_getname,
 	.poll		   = mptcp_poll,
 	.ioctl		   = inet_ioctl,
 	.gettstamp	   = sock_gettstamp,
@@ -2065,7 +2010,7 @@ static const struct proto_ops mptcp_v6_stream_ops = {
 	.connect	   = mptcp_stream_connect,
 	.socketpair	   = sock_no_socketpair,
 	.accept		   = mptcp_stream_accept,
-	.getname	   = mptcp_v6_getname,
+	.getname	   = inet6_getname,
 	.poll		   = mptcp_poll,
 	.ioctl		   = inet6_ioctl,
 	.gettstamp	   = sock_gettstamp,
-- 
2.26.2

