Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0DF4361CB
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 14:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbhJUMju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 08:39:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57115 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231709AbhJUMjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 08:39:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634819850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pz9Q5MsaEAhd9vpFjFj0Ubly2C9dI+VhasxldWaXTYg=;
        b=bJj+qbUj79MOCxY1cvwfeJEMZniIVq1+hCn8sfattmca/e//CVpkNoCxGhDUer4ZqZHUMW
        68CV704EZryjzBDwvfp0udee9yuVy96G0hhog/viGtTFeqoBGHRpYC8655L7AGYC249Pcm
        +HPrLozABv+peeBe9wYprDBO1YCO7oQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-dYH93tcNNgOgCE39S4m5GA-1; Thu, 21 Oct 2021 08:37:29 -0400
X-MC-Unique: dYH93tcNNgOgCE39S4m5GA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9E411926DA1;
        Thu, 21 Oct 2021 12:37:27 +0000 (UTC)
Received: from localhost (unknown [10.39.208.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B5D1B1346F;
        Thu, 21 Oct 2021 12:37:26 +0000 (UTC)
From:   =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, sgarzare@redhat.com,
        davem@davemloft.net, kuba@kernel.org,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>
Subject: [PATCH 02/10] sock: move sock_copy_peercred() from af_unix
Date:   Thu, 21 Oct 2021 16:37:06 +0400
Message-Id: <20211021123714.1125384-3-marcandre.lureau@redhat.com>
In-Reply-To: <20211021123714.1125384-1-marcandre.lureau@redhat.com>
References: <20211021123714.1125384-1-marcandre.lureau@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SO_PEERCRED can be made to work with other kind of sockets.

Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
---
 include/net/sock.h |  3 +++
 net/core/sock.c    | 25 +++++++++++++++++++++++++
 net/unix/af_unix.c | 26 +-------------------------
 3 files changed, 29 insertions(+), 25 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 8b12953752e6..d6877df26200 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1819,6 +1819,9 @@ void sock_init_data(struct socket *sock, struct sock *sk);
 /* Set socket peer PID and credentials with current process. */
 void sock_init_peercred(struct sock *sk);
 
+/* Copy peer credentials from peersk */
+void sock_copy_peercred(struct sock *sk, struct sock *peersk);
+
 /*
  * Socket reference counting postulates.
  *
diff --git a/net/core/sock.c b/net/core/sock.c
index 997e8d256e2f..f6b2662824df 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3214,6 +3214,31 @@ void sock_init_peercred(struct sock *sk)
 }
 EXPORT_SYMBOL(sock_init_peercred);
 
+void sock_copy_peercred(struct sock *sk, struct sock *peersk)
+{
+	const struct cred *old_cred;
+	struct pid *old_pid;
+
+	if (sk < peersk) {
+		spin_lock(&sk->sk_peer_lock);
+		spin_lock_nested(&peersk->sk_peer_lock, SINGLE_DEPTH_NESTING);
+	} else {
+		spin_lock(&peersk->sk_peer_lock);
+		spin_lock_nested(&sk->sk_peer_lock, SINGLE_DEPTH_NESTING);
+	}
+	old_pid = sk->sk_peer_pid;
+	old_cred = sk->sk_peer_cred;
+	sk->sk_peer_pid  = get_pid(peersk->sk_peer_pid);
+	sk->sk_peer_cred = get_cred(peersk->sk_peer_cred);
+
+	spin_unlock(&sk->sk_peer_lock);
+	spin_unlock(&peersk->sk_peer_lock);
+
+	put_pid(old_pid);
+	put_cred(old_cred);
+}
+EXPORT_SYMBOL(sock_copy_peercred);
+
 void lock_sock_nested(struct sock *sk, int subclass)
 {
 	/* The sk_lock has mutex_lock() semantics here. */
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index e56f320dff20..9109df1efdb6 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -606,30 +606,6 @@ static void unix_release_sock(struct sock *sk, int embrion)
 		unix_gc();		/* Garbage collect fds */
 }
 
-static void copy_peercred(struct sock *sk, struct sock *peersk)
-{
-	const struct cred *old_cred;
-	struct pid *old_pid;
-
-	if (sk < peersk) {
-		spin_lock(&sk->sk_peer_lock);
-		spin_lock_nested(&peersk->sk_peer_lock, SINGLE_DEPTH_NESTING);
-	} else {
-		spin_lock(&peersk->sk_peer_lock);
-		spin_lock_nested(&sk->sk_peer_lock, SINGLE_DEPTH_NESTING);
-	}
-	old_pid = sk->sk_peer_pid;
-	old_cred = sk->sk_peer_cred;
-	sk->sk_peer_pid  = get_pid(peersk->sk_peer_pid);
-	sk->sk_peer_cred = get_cred(peersk->sk_peer_cred);
-
-	spin_unlock(&sk->sk_peer_lock);
-	spin_unlock(&peersk->sk_peer_lock);
-
-	put_pid(old_pid);
-	put_cred(old_cred);
-}
-
 static int unix_listen(struct socket *sock, int backlog)
 {
 	int err;
@@ -1460,7 +1436,7 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	smp_store_release(&newu->addr, otheru->addr);
 
 	/* Set credentials */
-	copy_peercred(sk, other);
+	sock_copy_peercred(sk, other);
 
 	sock->state	= SS_CONNECTED;
 	sk->sk_state	= TCP_ESTABLISHED;
-- 
2.33.0.721.g106298f7f9

