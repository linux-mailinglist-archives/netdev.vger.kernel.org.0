Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99C8426749
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 12:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239045AbhJHKDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 06:03:03 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:43702 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237434AbhJHKDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 06:03:02 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 7147F1FD74;
        Fri,  8 Oct 2021 10:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1633687265; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=qyzeG39RQY90nbn8hALcZZOVE1eV05QuvB+1SDRXg+A=;
        b=gxlj+y0cSpwIdqrtPZCMb0/ldd+6guidWOonDdIq1raVlTCC18eojoWlPUhTixbuUcrNI/
        pL1ctPyVtHydC7YiDtP6R6nHKLfeLgrIoTyvKgvxX7UdSBTq9EyXs0lfDpPKsCIuuEsvvm
        4UL3pd+htBujnsLyg6/yRX9M5ORybnI=
Received: from g78.suse.de (unknown [10.163.24.38])
        by relay2.suse.de (Postfix) with ESMTP id 41CC0A3B81;
        Fri,  8 Oct 2021 10:01:04 +0000 (UTC)
From:   Richard Palethorpe <rpalethorpe@suse.com>
To:     Arnd Bergmann <arnd@arndb.de>, Jakub Kicinski <kuba@kernel.org>
Cc:     Richard Palethorpe <rpalethorpe@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Eric Dumazet <edumazet@google.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Willem de Bruijn <willemb@google.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Palethorpe <rpalethorpe@richiejp.com>
Subject: [PATCH v3 1/2] vsock: Refactor vsock_*_getsockopt to resemble sock_getsockopt
Date:   Fri,  8 Oct 2021 11:00:52 +0100
Message-Id: <20211008100053.29806-1-rpalethorpe@suse.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for sharing the implementation of sock_get_timeout.

Signed-off-by: Richard Palethorpe <rpalethorpe@suse.com>
Cc: Richard Palethorpe <rpalethorpe@richiejp.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
---
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

