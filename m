Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3A640D9EE
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 14:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239468AbhIPMb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 08:31:27 -0400
Received: from out2.migadu.com ([188.165.223.204]:18001 "EHLO out2.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235767AbhIPMb0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 08:31:26 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1631795403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=WiOqDYtkI9QfC+0Q/1OUY8VFFwUScpv3DTzHFGB/Hnw=;
        b=SYWZS2B3+Aq/W9xjYHTQKR9cuGaLaYUWxZ8DtliaqxngGoulnm7TZv/hyh1vT92AgGD47f
        Zx1lYENQhKSjq0fnJ9pm1STNiyngQT+WkbBvWUGsww8QHrqpf7zZlrWfReHSPWxseVUO4H
        X2g5zQch+ay/u/0+pj14WOlkpZvJfh4=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH net-next] net: socket: add the case sock_no_xxx support
Date:   Thu, 16 Sep 2021 20:29:43 +0800
Message-Id: <20210916122943.19849-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Those sock_no_{mmap, socketpair, listen, accept, connect, shutdown,
sendpage} functions are used many times in struct proto_ops, but they are
meaningless. So we can add them support in socket and delete them in struct
proto_ops.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/socket.c | 71 ++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 58 insertions(+), 13 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index 7f64a6eccf63..4d0e1a2970fb 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1306,6 +1306,9 @@ static int sock_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct socket *sock = file->private_data;
 
+	if (likely(!sock->ops->mmap))
+		return -ENODEV;
+
 	return sock->ops->mmap(file, sock, vma);
 }
 
@@ -1629,11 +1632,19 @@ int __sys_socketpair(int family, int type, int protocol, int __user *usockvec)
 		goto out;
 	}
 
-	err = sock1->ops->socketpair(sock1, sock2);
-	if (unlikely(err < 0)) {
+	if (likely(!sock1->ops->socketpair)) {
+		err = -EOPNOTSUPP;
 		sock_release(sock2);
 		sock_release(sock1);
 		goto out;
+
+	} else {
+		err = sock1->ops->socketpair(sock1, sock2);
+		if (unlikely(err < 0)) {
+			sock_release(sock2);
+			sock_release(sock1);
+			goto out;
+		}
 	}
 
 	newfile1 = sock_alloc_file(sock1, flags, NULL);
@@ -1704,6 +1715,14 @@ SYSCALL_DEFINE3(bind, int, fd, struct sockaddr __user *, umyaddr, int, addrlen)
 	return __sys_bind(fd, umyaddr, addrlen);
 }
 
+static int __sock_listen(struct socket *sock, int backlog)
+{
+	if (likely(!sock->ops->listen))
+		return -EOPNOTSUPP;
+
+	return sock->ops->listen(sock, backlog);
+}
+
 /*
  *	Perform a listen. Basically, we allow the protocol to do anything
  *	necessary for a listen, and if that works, we mark the socket as
@@ -1724,7 +1743,7 @@ int __sys_listen(int fd, int backlog)
 
 		err = security_socket_listen(sock, backlog);
 		if (!err)
-			err = sock->ops->listen(sock, backlog);
+			err = __sock_listen(sock, backlog);
 
 		fput_light(sock->file, fput_needed);
 	}
@@ -1736,6 +1755,15 @@ SYSCALL_DEFINE2(listen, int, fd, int, backlog)
 	return __sys_listen(fd, backlog);
 }
 
+static int __sock_accept(struct socket *sock, struct socket *newsock,
+			 int flags, bool kern)
+{
+	if (likely(!sock->ops->accept))
+		return -EOPNOTSUPP;
+
+	return sock->ops->accept(sock, newsock, flags, kern);
+}
+
 struct file *do_accept(struct file *file, unsigned file_flags,
 		       struct sockaddr __user *upeer_sockaddr,
 		       int __user *upeer_addrlen, int flags)
@@ -1770,8 +1798,8 @@ struct file *do_accept(struct file *file, unsigned file_flags,
 	if (err)
 		goto out_fd;
 
-	err = sock->ops->accept(sock, newsock, sock->file->f_flags | file_flags,
-					false);
+	err = __sock_accept(sock, newsock, sock->file->f_flags | file_flags,
+			    false);
 	if (err < 0)
 		goto out_fd;
 
@@ -1864,6 +1892,15 @@ SYSCALL_DEFINE3(accept, int, fd, struct sockaddr __user *, upeer_sockaddr,
 	return __sys_accept4(fd, upeer_sockaddr, upeer_addrlen, 0);
 }
 
+static int __sock_connect(struct socket *sock, struct sockaddr *saddr,
+			  int len, int flags)
+{
+	if (likely(!sock->ops->connect))
+		return -EOPNOTSUPP;
+
+	return sock->ops->connect(sock, saddr, len, flags);
+}
+
 /*
  *	Attempt to connect to a socket with the server address.  The address
  *	is in user space so we verify it is OK and move it to kernel space.
@@ -1893,8 +1930,8 @@ int __sys_connect_file(struct file *file, struct sockaddr_storage *address,
 	if (err)
 		goto out;
 
-	err = sock->ops->connect(sock, (struct sockaddr *)address, addrlen,
-				 sock->file->f_flags | file_flags);
+	err = __sock_connect(sock, (struct sockaddr *)address, addrlen,
+			     sock->file->f_flags | file_flags);
 out:
 	return err;
 }
@@ -2235,6 +2272,14 @@ SYSCALL_DEFINE5(getsockopt, int, fd, int, level, int, optname,
 	return __sys_getsockopt(fd, level, optname, optval, optlen);
 }
 
+static int __sock_shutdown(struct socket *sock, int how)
+{
+	if (likely(!sock->ops->shutdown))
+		return -EOPNOTSUPP;
+
+	return sock->ops->shutdown(sock, how);
+}
+
 /*
  *	Shutdown a socket.
  */
@@ -2245,7 +2290,7 @@ int __sys_shutdown_sock(struct socket *sock, int how)
 
 	err = security_socket_shutdown(sock, how);
 	if (!err)
-		err = sock->ops->shutdown(sock, how);
+		err = __sock_shutdown(sock, how);
 
 	return err;
 }
@@ -3394,7 +3439,7 @@ EXPORT_SYMBOL(kernel_bind);
 
 int kernel_listen(struct socket *sock, int backlog)
 {
-	return sock->ops->listen(sock, backlog);
+	return __sock_listen(sock, backlog);
 }
 EXPORT_SYMBOL(kernel_listen);
 
@@ -3419,7 +3464,7 @@ int kernel_accept(struct socket *sock, struct socket **newsock, int flags)
 	if (err < 0)
 		goto done;
 
-	err = sock->ops->accept(sock, *newsock, flags, true);
+	err = __sock_accept(sock, *newsock, flags, true);
 	if (err < 0) {
 		sock_release(*newsock);
 		*newsock = NULL;
@@ -3450,7 +3495,7 @@ EXPORT_SYMBOL(kernel_accept);
 int kernel_connect(struct socket *sock, struct sockaddr *addr, int addrlen,
 		   int flags)
 {
-	return sock->ops->connect(sock, addr, addrlen, flags);
+	return __sock_connect(sock, addr, addrlen, flags);
 }
 EXPORT_SYMBOL(kernel_connect);
 
@@ -3498,7 +3543,7 @@ EXPORT_SYMBOL(kernel_getpeername);
 int kernel_sendpage(struct socket *sock, struct page *page, int offset,
 		    size_t size, int flags)
 {
-	if (sock->ops->sendpage) {
+	if (unlikely(sock->ops->sendpage)) {
 		/* Warn in case the improper page to zero-copy send */
 		WARN_ONCE(!sendpage_ok(page), "improper page for zero-copy send");
 		return sock->ops->sendpage(sock, page, offset, size, flags);
@@ -3542,7 +3587,7 @@ EXPORT_SYMBOL(kernel_sendpage_locked);
 
 int kernel_sock_shutdown(struct socket *sock, enum sock_shutdown_cmd how)
 {
-	return sock->ops->shutdown(sock, how);
+	return __sock_shutdown(sock, how);
 }
 EXPORT_SYMBOL(kernel_sock_shutdown);
 
-- 
2.32.0

