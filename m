Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9942D4361C9
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 14:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbhJUMjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 08:39:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35098 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231687AbhJUMjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 08:39:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634819845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RxvTAezPJGB8dfIBumv6gkdy8ZhbMjjJ/oV0H/w85HE=;
        b=QoQaJg9uondWAH3ioE7M6GjVWdIqdmPVQihg9hCZFCQWH/KHVqkjH0GY2Pg5GyK6iPs9Fj
        S3D1jeELM0JvkvwsroVRriSRS1WyI8ARl2rCS8jTHttcsEZyU01thGSvWk7w3hgZskhgUq
        sIkLdgGHLwd76y+IDsLG5MJZfOqaEOI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-Lc6LZAh4OcqUcZI2r6AneQ-1; Thu, 21 Oct 2021 08:37:23 -0400
X-MC-Unique: Lc6LZAh4OcqUcZI2r6AneQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C0E7E8797E5;
        Thu, 21 Oct 2021 12:37:22 +0000 (UTC)
Received: from localhost (unknown [10.39.208.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA4CF5C3E0;
        Thu, 21 Oct 2021 12:37:21 +0000 (UTC)
From:   =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, sgarzare@redhat.com,
        davem@davemloft.net, kuba@kernel.org,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>
Subject: [PATCH 01/10] sock: move sock_init_peercred() from af_unix
Date:   Thu, 21 Oct 2021 16:37:05 +0400
Message-Id: <20211021123714.1125384-2-marcandre.lureau@redhat.com>
In-Reply-To: <20211021123714.1125384-1-marcandre.lureau@redhat.com>
References: <20211021123714.1125384-1-marcandre.lureau@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SO_PEERCRED can be made to work with other kind of sockets.

Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
---
 include/net/sock.h |  3 +++
 net/core/sock.c    | 17 +++++++++++++++++
 net/unix/af_unix.c | 24 ++++--------------------
 3 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index ea6fbc88c8f9..8b12953752e6 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1816,6 +1816,9 @@ void sk_common_release(struct sock *sk);
 /* Initialise core socket variables */
 void sock_init_data(struct socket *sock, struct sock *sk);
 
+/* Set socket peer PID and credentials with current process. */
+void sock_init_peercred(struct sock *sk);
+
 /*
  * Socket reference counting postulates.
  *
diff --git a/net/core/sock.c b/net/core/sock.c
index c1601f75ec4b..997e8d256e2f 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3197,6 +3197,23 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 }
 EXPORT_SYMBOL(sock_init_data);
 
+void sock_init_peercred(struct sock *sk)
+{
+	const struct cred *old_cred;
+	struct pid *old_pid;
+
+	spin_lock(&sk->sk_peer_lock);
+	old_pid = sk->sk_peer_pid;
+	old_cred = sk->sk_peer_cred;
+	sk->sk_peer_pid  = get_pid(task_tgid(current));
+	sk->sk_peer_cred = get_current_cred();
+	spin_unlock(&sk->sk_peer_lock);
+
+	put_pid(old_pid);
+	put_cred(old_cred);
+}
+EXPORT_SYMBOL(sock_init_peercred);
+
 void lock_sock_nested(struct sock *sk, int subclass)
 {
 	/* The sk_lock has mutex_lock() semantics here. */
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 89f9e85ae970..e56f320dff20 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -606,22 +606,6 @@ static void unix_release_sock(struct sock *sk, int embrion)
 		unix_gc();		/* Garbage collect fds */
 }
 
-static void init_peercred(struct sock *sk)
-{
-	const struct cred *old_cred;
-	struct pid *old_pid;
-
-	spin_lock(&sk->sk_peer_lock);
-	old_pid = sk->sk_peer_pid;
-	old_cred = sk->sk_peer_cred;
-	sk->sk_peer_pid  = get_pid(task_tgid(current));
-	sk->sk_peer_cred = get_current_cred();
-	spin_unlock(&sk->sk_peer_lock);
-
-	put_pid(old_pid);
-	put_cred(old_cred);
-}
-
 static void copy_peercred(struct sock *sk, struct sock *peersk)
 {
 	const struct cred *old_cred;
@@ -666,7 +650,7 @@ static int unix_listen(struct socket *sock, int backlog)
 	sk->sk_max_ack_backlog	= backlog;
 	sk->sk_state		= TCP_LISTEN;
 	/* set credentials so connect can copy them */
-	init_peercred(sk);
+	sock_init_peercred(sk);
 	err = 0;
 
 out_unlock:
@@ -1446,7 +1430,7 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	unix_peer(newsk)	= sk;
 	newsk->sk_state		= TCP_ESTABLISHED;
 	newsk->sk_type		= sk->sk_type;
-	init_peercred(newsk);
+	sock_init_peercred(newsk);
 	newu = unix_sk(newsk);
 	RCU_INIT_POINTER(newsk->sk_wq, &newu->peer_wq);
 	otheru = unix_sk(other);
@@ -1518,8 +1502,8 @@ static int unix_socketpair(struct socket *socka, struct socket *sockb)
 	sock_hold(skb);
 	unix_peer(ska) = skb;
 	unix_peer(skb) = ska;
-	init_peercred(ska);
-	init_peercred(skb);
+	sock_init_peercred(ska);
+	sock_init_peercred(skb);
 
 	ska->sk_state = TCP_ESTABLISHED;
 	skb->sk_state = TCP_ESTABLISHED;
-- 
2.33.0.721.g106298f7f9

