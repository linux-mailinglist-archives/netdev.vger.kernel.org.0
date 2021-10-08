Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912EA42674B
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 12:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237434AbhJHKDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 06:03:05 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:45118 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238321AbhJHKDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 06:03:02 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 2C39621E9E;
        Fri,  8 Oct 2021 10:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1633687266; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bIrAX4vUdJpRNtlWwOHMFp4HK+A2h1hcMCe4IzU4wa8=;
        b=qprwc9HgnFPdzwgJC2RSNS6leJQkUuf85UYCPnnEevuozIjnXSd+oKi3yg3TjOsFnSLfDd
        nVH965syWCqhYdjmzpPLDtGK+Kd3bgz4xGoT/TKvJxqa3Fo+H/5af8cj0fnxIhEufDuAQz
        fQUboUAaG2BE63R03sFdv7E3GarfKSw=
Received: from g78.suse.de (unknown [10.163.24.38])
        by relay2.suse.de (Postfix) with ESMTP id 815B7A3B81;
        Fri,  8 Oct 2021 10:01:05 +0000 (UTC)
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
Subject: [PATCH v3 2/2] vsock: Enable y2038 safe timeval for timeout
Date:   Fri,  8 Oct 2021 11:00:53 +0100
Message-Id: <20211008100053.29806-2-rpalethorpe@suse.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008100053.29806-1-rpalethorpe@suse.com>
References: <20211008100053.29806-1-rpalethorpe@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reuse the timeval compat code from core/sock to handle 32-bit and
64-bit timeval structures. Also introduce a new socket option define
to allow using y2038 safe timeval under 32-bit.

The existing behavior of sock_set_timeout and vsock's timeout setter
differ when the time value is out of bounds. vsocks current behavior
is retained at the expense of not being able to share the full
implementation.

This allows the LTP test vsock01 to pass under 32-bit compat mode.

Fixes: fe0c72f3db11 ("socket: move compat timeout handling into sock.c")
Signed-off-by: Richard Palethorpe <rpalethorpe@suse.com>
Cc: Richard Palethorpe <rpalethorpe@richiejp.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
---

V1: https://lore.kernel.org/netdev/20211006074547.14724-1-rpalethorpe@suse.com/

V2: https://lore.kernel.org/netdev/20211007123147.5780-1-rpalethorpe@suse.com/
* Try to share more code with core/sock.c
* Handle 64-bit timeout values in 32-bit

V3:
* Remove 64-bit division for 32-bit x86 (same as sock.c)

 include/net/sock.h              |  4 ++++
 include/uapi/linux/vm_sockets.h | 13 +++++++++++-
 net/core/sock.c                 | 35 ++++++++++++++++++++++-----------
 net/vmw_vsock/af_vsock.c        | 25 +++++++++++++----------
 4 files changed, 55 insertions(+), 22 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index f23cb259b0e2..b93d0ac552c1 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2773,4 +2773,8 @@ void sock_set_sndtimeo(struct sock *sk, s64 secs);
 
 int sock_bind_add(struct sock *sk, struct sockaddr *addr, int addr_len);
 
+int sock_get_timeout(long timeo, void *optval, bool old_timeval);
+int sock_copy_user_timeval(struct __kernel_sock_timeval *tv,
+			   sockptr_t optval, int optlen, bool old_timeval);
+
 #endif	/* _SOCK_H */
diff --git a/include/uapi/linux/vm_sockets.h b/include/uapi/linux/vm_sockets.h
index 46918a1852d7..c60ca33eac59 100644
--- a/include/uapi/linux/vm_sockets.h
+++ b/include/uapi/linux/vm_sockets.h
@@ -64,7 +64,7 @@
  * timeout for a STREAM socket.
  */
 
-#define SO_VM_SOCKETS_CONNECT_TIMEOUT 6
+#define SO_VM_SOCKETS_CONNECT_TIMEOUT_OLD 6
 
 /* Option name for using non-blocking send/receive.  Use as the option name
  * for setsockopt(3) or getsockopt(3) to set or get the non-blocking
@@ -81,6 +81,17 @@
 
 #define SO_VM_SOCKETS_NONBLOCK_TXRX 7
 
+#define SO_VM_SOCKETS_CONNECT_TIMEOUT_NEW 8
+
+#if !defined(__KERNEL__)
+#if __BITS_PER_LONG == 64 || (defined(__x86_64__) && defined(__ILP32__))
+#define SO_VM_SOCKETS_CONNECT_TIMEOUT SO_VM_SOCKETS_CONNECT_TIMEOUT_OLD
+#else
+#define SO_VM_SOCKETS_CONNECT_TIMEOUT \
+	(sizeof(time_t) == sizeof(__kernel_long_t) ? SO_VM_SOCKETS_CONNECT_TIMEOUT_OLD : SO_VM_SOCKETS_CONNECT_TIMEOUT_NEW)
+#endif
+#endif
+
 /* The vSocket equivalent of INADDR_ANY.  This works for the svm_cid field of
  * sockaddr_vm and indicates the context ID of the current endpoint.
  */
diff --git a/net/core/sock.c b/net/core/sock.c
index a3eea6e0b30a..a648fd3cc2ec 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -349,7 +349,7 @@ void sk_error_report(struct sock *sk)
 }
 EXPORT_SYMBOL(sk_error_report);
 
-static int sock_get_timeout(long timeo, void *optval, bool old_timeval)
+int sock_get_timeout(long timeo, void *optval, bool old_timeval)
 {
 	struct __kernel_sock_timeval tv;
 
@@ -378,12 +378,11 @@ static int sock_get_timeout(long timeo, void *optval, bool old_timeval)
 	*(struct __kernel_sock_timeval *)optval = tv;
 	return sizeof(tv);
 }
+EXPORT_SYMBOL(sock_get_timeout);
 
-static int sock_set_timeout(long *timeo_p, sockptr_t optval, int optlen,
-			    bool old_timeval)
+int sock_copy_user_timeval(struct __kernel_sock_timeval *tv,
+			   sockptr_t optval, int optlen, bool old_timeval)
 {
-	struct __kernel_sock_timeval tv;
-
 	if (old_timeval && in_compat_syscall() && !COMPAT_USE_64BIT_TIME) {
 		struct old_timeval32 tv32;
 
@@ -392,8 +391,8 @@ static int sock_set_timeout(long *timeo_p, sockptr_t optval, int optlen,
 
 		if (copy_from_sockptr(&tv32, optval, sizeof(tv32)))
 			return -EFAULT;
-		tv.tv_sec = tv32.tv_sec;
-		tv.tv_usec = tv32.tv_usec;
+		tv->tv_sec = tv32.tv_sec;
+		tv->tv_usec = tv32.tv_usec;
 	} else if (old_timeval) {
 		struct __kernel_old_timeval old_tv;
 
@@ -401,14 +400,28 @@ static int sock_set_timeout(long *timeo_p, sockptr_t optval, int optlen,
 			return -EINVAL;
 		if (copy_from_sockptr(&old_tv, optval, sizeof(old_tv)))
 			return -EFAULT;
-		tv.tv_sec = old_tv.tv_sec;
-		tv.tv_usec = old_tv.tv_usec;
+		tv->tv_sec = old_tv.tv_sec;
+		tv->tv_usec = old_tv.tv_usec;
 	} else {
-		if (optlen < sizeof(tv))
+		if (optlen < sizeof(*tv))
 			return -EINVAL;
-		if (copy_from_sockptr(&tv, optval, sizeof(tv)))
+		if (copy_from_sockptr(tv, optval, sizeof(*tv)))
 			return -EFAULT;
 	}
+
+	return 0;
+}
+EXPORT_SYMBOL(sock_copy_user_timeval);
+
+static int sock_set_timeout(long *timeo_p, sockptr_t optval, int optlen,
+			    bool old_timeval)
+{
+	struct __kernel_sock_timeval tv;
+	int err = sock_copy_user_timeval(&tv, optval, optlen, old_timeval);
+
+	if (err)
+		return err;
+
 	if (tv.tv_usec < 0 || tv.tv_usec >= USEC_PER_SEC)
 		return -EDOM;
 
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 97d56f6a4480..53b5568e54eb 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1614,13 +1614,18 @@ static int vsock_connectible_setsockopt(struct socket *sock,
 		vsock_update_buffer_size(vsk, transport, vsk->buffer_size);
 		break;
 
-	case SO_VM_SOCKETS_CONNECT_TIMEOUT: {
-		struct __kernel_old_timeval tv;
-		COPY_IN(tv);
+	case SO_VM_SOCKETS_CONNECT_TIMEOUT_NEW:
+	case SO_VM_SOCKETS_CONNECT_TIMEOUT_OLD: {
+		struct __kernel_sock_timeval tv;
+
+		err = sock_copy_user_timeval(&tv, optval, optlen,
+					     optname == SO_VM_SOCKETS_CONNECT_TIMEOUT_OLD);
+		if (err)
+			break;
 		if (tv.tv_sec >= 0 && tv.tv_usec < USEC_PER_SEC &&
 		    tv.tv_sec < (MAX_SCHEDULE_TIMEOUT / HZ - 1)) {
 			vsk->connect_timeout = tv.tv_sec * HZ +
-			    DIV_ROUND_UP(tv.tv_usec, (1000000 / HZ));
+				DIV_ROUND_UP((unsigned long)tv.tv_usec, (USEC_PER_SEC / HZ));
 			if (vsk->connect_timeout == 0)
 				vsk->connect_timeout =
 				    VSOCK_DEFAULT_CONNECT_TIMEOUT;
@@ -1653,7 +1658,9 @@ static int vsock_connectible_getsockopt(struct socket *sock,
 
 	union {
 		u64 val64;
+		struct old_timeval32 tm32;
 		struct __kernel_old_timeval tm;
+		struct  __kernel_sock_timeval stm;
 	} v;
 
 	int lv = sizeof(v.val64);
@@ -1680,12 +1687,10 @@ static int vsock_connectible_getsockopt(struct socket *sock,
 		v.val64 = vsk->buffer_min_size;
 		break;
 
-	case SO_VM_SOCKETS_CONNECT_TIMEOUT:
-		lv = sizeof(v.tm);
-		v.tm.tv_sec = vsk->connect_timeout / HZ;
-		v.tm.tv_usec =
-		    (vsk->connect_timeout -
-		     v.tm.tv_sec * HZ) * (1000000 / HZ);
+	case SO_VM_SOCKETS_CONNECT_TIMEOUT_NEW:
+	case SO_VM_SOCKETS_CONNECT_TIMEOUT_OLD:
+		lv = sock_get_timeout(vsk->connect_timeout, &v,
+				      optname == SO_VM_SOCKETS_CONNECT_TIMEOUT_OLD);
 		break;
 
 	default:
-- 
2.33.0

