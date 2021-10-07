Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D33E425319
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 14:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241395AbhJGMev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 08:34:51 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47298 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241222AbhJGMet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 08:34:49 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 9C6EB200B8;
        Thu,  7 Oct 2021 12:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1633609974; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=w5hRO0ggi6f6CPWquu4xGEKh4nCUYk0yWV6Bvi7G6II=;
        b=osjiG0VJRfFpHGqVrLVot0ga2RL8rn1fbLgkYfbxWUndyu0mY22emQt1HKT0ja4IlDQUXz
        mZyrpqq6jvC7yvHYpB/nmNq2tfV6VV3os1lOJKQrQonqM7XeQR5JWNv5jD60ciS6JNq1x1
        Bsf5cb5tTblz2OnqqLsHSTT6AclGP8k=
Received: from g78.suse.de (unknown [10.163.24.38])
        by relay2.suse.de (Postfix) with ESMTP id 92C60A3B83;
        Thu,  7 Oct 2021 12:32:53 +0000 (UTC)
From:   Richard Palethorpe <rpalethorpe@suse.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Richard Palethorpe <rpalethorpe@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Eric Dumazet <edumazet@google.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Willem de Bruijn <willemb@google.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Palethorpe <rpalethorpe@richiejp.com>
Subject: [PATCH v2 1/2] vsock: Refactor vsock_*_getsockopt to resemble sock_getsockopt
Date:   Thu,  7 Oct 2021 13:31:46 +0100
Message-Id: <20211007123147.5780-1-rpalethorpe@suse.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for sharing the implementation of sock_get_timeout.

Signed-off-by: Richard Palethorpe <rpalethorpe@suse.com>
Cc: Richard Palethorpe <rpalethorpe@richiejp.com>
---

V1: https://lore.kernel.org/netdev/20211006074547.14724-1-rpalethorpe@suse.com/

V2:
* Try to share more code with core/sock.c
* Handle 64-bit timeout values in 32-bit

 net/vmw_vsock/af_vsock.c | 65 +++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 37 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 3e02cc3b24f8..97d56f6a4480 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1648,68 +1648,59 @@ static int vsock_connectible_getsockopt(struct socket *sock,
 					char __user *optval,
 					int __user *optlen)
 {
-	int err;
+	struct sock *sk = sock->sk;
+	struct vsock_sock *vsk = vsock_sk(sk);
+
+	union {
+		u64 val64;
+		struct __kernel_old_timeval tm;
+	} v;
+
+	int lv = sizeof(v.val64);
 	int len;
-	struct sock *sk;
-	struct vsock_sock *vsk;
-	u64 val;
 
 	if (level != AF_VSOCK)
 		return -ENOPROTOOPT;
 
-	err = get_user(len, optlen);
-	if (err != 0)
-		return err;
-
-#define COPY_OUT(_v)                            \
-	do {					\
-		if (len < sizeof(_v))		\
-			return -EINVAL;		\
-						\
-		len = sizeof(_v);		\
-		if (copy_to_user(optval, &_v, len) != 0)	\
-			return -EFAULT;				\
-								\
-	} while (0)
+	if (get_user(len, optlen))
+		return -EFAULT;
 
-	err = 0;
-	sk = sock->sk;
-	vsk = vsock_sk(sk);
+	memset(&v, 0, sizeof(v));
 
 	switch (optname) {
 	case SO_VM_SOCKETS_BUFFER_SIZE:
-		val = vsk->buffer_size;
-		COPY_OUT(val);
+		v.val64 = vsk->buffer_size;
 		break;
 
 	case SO_VM_SOCKETS_BUFFER_MAX_SIZE:
-		val = vsk->buffer_max_size;
-		COPY_OUT(val);
+		v.val64 = vsk->buffer_max_size;
 		break;
 
 	case SO_VM_SOCKETS_BUFFER_MIN_SIZE:
-		val = vsk->buffer_min_size;
-		COPY_OUT(val);
+		v.val64 = vsk->buffer_min_size;
 		break;
 
-	case SO_VM_SOCKETS_CONNECT_TIMEOUT: {
-		struct __kernel_old_timeval tv;
-		tv.tv_sec = vsk->connect_timeout / HZ;
-		tv.tv_usec =
+	case SO_VM_SOCKETS_CONNECT_TIMEOUT:
+		lv = sizeof(v.tm);
+		v.tm.tv_sec = vsk->connect_timeout / HZ;
+		v.tm.tv_usec =
 		    (vsk->connect_timeout -
-		     tv.tv_sec * HZ) * (1000000 / HZ);
-		COPY_OUT(tv);
+		     v.tm.tv_sec * HZ) * (1000000 / HZ);
 		break;
-	}
+
 	default:
 		return -ENOPROTOOPT;
 	}
 
-	err = put_user(len, optlen);
-	if (err != 0)
+	if (len < lv)
+		return -EINVAL;
+	if (len > lv)
+		len = lv;
+	if (copy_to_user(optval, &v, len))
 		return -EFAULT;
 
-#undef COPY_OUT
+	if (put_user(len, optlen))
+		return -EFAULT;
 
 	return 0;
 }
-- 
2.33.0

