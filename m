Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8464141E9
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 08:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232898AbhIVGdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 02:33:05 -0400
Received: from out0.migadu.com ([94.23.1.103]:56727 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232718AbhIVGdE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 02:33:04 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1632292289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=DGP8miJEHYKD0hkPycIrBj1DMgw4/Uzx5V0Ha1WSIoM=;
        b=II4znbMIqdIPPebzKdDar2H+m2MYDmIj7+0Pcc+7cEQLU3ag05SO9ksRFnCB9CHN2SyXOH
        ok6CqYfzystU6ohRmqOvltL4NchOGihlddSaQBYg7rgEVXnWWgwbJZ1foO5nB/ZP/Ue6NB
        PFMz6N7sWhSJ0bEUopHB9Y2gZ5R58BI=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH net-next] net: socket: integrate sockfd_lookup() and sockfd_lookup_light()
Date:   Wed, 22 Sep 2021 14:31:06 +0800
Message-Id: <20210922063106.4272-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As commit 6cb153cab92a("[NET]: use fget_light() in net/socket.c") said,
sockfd_lookup_light() is lower load than sockfd_lookup(). So we can
remove sockfd_lookup() but keep the name. As the same time, move flags
to sockfd_put().

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 include/linux/net.h |   8 +++-
 net/socket.c        | 101 +++++++++++++++++---------------------------
 2 files changed, 46 insertions(+), 63 deletions(-)

diff --git a/include/linux/net.h b/include/linux/net.h
index ba736b457a06..63a179d4f760 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -238,8 +238,14 @@ int sock_recvmsg(struct socket *sock, struct msghdr *msg, int flags);
 struct file *sock_alloc_file(struct socket *sock, int flags, const char *dname);
 struct socket *sockfd_lookup(int fd, int *err);
 struct socket *sock_from_file(struct file *file);
-#define		     sockfd_put(sock) fput(sock->file)
 int net_ratelimit(void);
+#define		     sockfd_put(sock)             \
+do {                                              \
+	struct fd *fd = (struct fd *)&sock->file; \
+						  \
+	if (fd->flags & FDPUT_FPUT)               \
+		fput(sock->file);                 \
+} while (0)
 
 #define net_ratelimited_function(function, ...)			\
 do {								\
diff --git a/net/socket.c b/net/socket.c
index 7f64a6eccf63..ca8a05aee982 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -521,28 +521,7 @@ EXPORT_SYMBOL(sock_from_file);
  *
  *	On a success the socket object pointer is returned.
  */
-
 struct socket *sockfd_lookup(int fd, int *err)
-{
-	struct file *file;
-	struct socket *sock;
-
-	file = fget(fd);
-	if (!file) {
-		*err = -EBADF;
-		return NULL;
-	}
-
-	sock = sock_from_file(file);
-	if (!sock) {
-		*err = -ENOTSOCK;
-		fput(file);
-	}
-	return sock;
-}
-EXPORT_SYMBOL(sockfd_lookup);
-
-static struct socket *sockfd_lookup_light(int fd, int *err, int *fput_needed)
 {
 	struct fd f = fdget(fd);
 	struct socket *sock;
@@ -551,7 +530,6 @@ static struct socket *sockfd_lookup_light(int fd, int *err, int *fput_needed)
 	if (f.file) {
 		sock = sock_from_file(f.file);
 		if (likely(sock)) {
-			*fput_needed = f.flags & FDPUT_FPUT;
 			return sock;
 		}
 		*err = -ENOTSOCK;
@@ -559,6 +537,7 @@ static struct socket *sockfd_lookup_light(int fd, int *err, int *fput_needed)
 	}
 	return NULL;
 }
+EXPORT_SYMBOL(sockfd_lookup);
 
 static ssize_t sockfs_listxattr(struct dentry *dentry, char *buffer,
 				size_t size)
@@ -1680,9 +1659,9 @@ int __sys_bind(int fd, struct sockaddr __user *umyaddr, int addrlen)
 {
 	struct socket *sock;
 	struct sockaddr_storage address;
-	int err, fput_needed;
+	int err;
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	sock = sockfd_lookup(fd, &err);
 	if (sock) {
 		err = move_addr_to_kernel(umyaddr, addrlen, &address);
 		if (!err) {
@@ -1694,7 +1673,7 @@ int __sys_bind(int fd, struct sockaddr __user *umyaddr, int addrlen)
 						      (struct sockaddr *)
 						      &address, addrlen);
 		}
-		fput_light(sock->file, fput_needed);
+		sockfd_put(sock);
 	}
 	return err;
 }
@@ -1713,10 +1692,10 @@ SYSCALL_DEFINE3(bind, int, fd, struct sockaddr __user *, umyaddr, int, addrlen)
 int __sys_listen(int fd, int backlog)
 {
 	struct socket *sock;
-	int err, fput_needed;
+	int err;
 	int somaxconn;
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	sock = sockfd_lookup(fd, &err);
 	if (sock) {
 		somaxconn = sock_net(sock->sk)->core.sysctl_somaxconn;
 		if ((unsigned int)backlog > somaxconn)
@@ -1726,7 +1705,7 @@ int __sys_listen(int fd, int backlog)
 		if (!err)
 			err = sock->ops->listen(sock, backlog);
 
-		fput_light(sock->file, fput_needed);
+		sockfd_put(sock);
 	}
 	return err;
 }
@@ -1933,9 +1912,9 @@ int __sys_getsockname(int fd, struct sockaddr __user *usockaddr,
 {
 	struct socket *sock;
 	struct sockaddr_storage address;
-	int err, fput_needed;
+	int err;
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	sock = sockfd_lookup(fd, &err);
 	if (!sock)
 		goto out;
 
@@ -1950,7 +1929,7 @@ int __sys_getsockname(int fd, struct sockaddr __user *usockaddr,
 	err = move_addr_to_user(&address, err, usockaddr, usockaddr_len);
 
 out_put:
-	fput_light(sock->file, fput_needed);
+	sockfd_put(sock);
 out:
 	return err;
 }
@@ -1971,13 +1950,13 @@ int __sys_getpeername(int fd, struct sockaddr __user *usockaddr,
 {
 	struct socket *sock;
 	struct sockaddr_storage address;
-	int err, fput_needed;
+	int err;
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	sock = sockfd_lookup(fd, &err);
 	if (sock != NULL) {
 		err = security_socket_getpeername(sock);
 		if (err) {
-			fput_light(sock->file, fput_needed);
+			sockfd_put(sock);
 			return err;
 		}
 
@@ -1986,7 +1965,7 @@ int __sys_getpeername(int fd, struct sockaddr __user *usockaddr,
 			/* "err" is actually length in this case */
 			err = move_addr_to_user(&address, err, usockaddr,
 						usockaddr_len);
-		fput_light(sock->file, fput_needed);
+		sockfd_put(sock);
 	}
 	return err;
 }
@@ -2010,12 +1989,11 @@ int __sys_sendto(int fd, void __user *buff, size_t len, unsigned int flags,
 	int err;
 	struct msghdr msg;
 	struct iovec iov;
-	int fput_needed;
 
 	err = import_single_range(WRITE, buff, len, &iov, &msg.msg_iter);
 	if (unlikely(err))
 		return err;
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	sock = sockfd_lookup(fd, &err);
 	if (!sock)
 		goto out;
 
@@ -2036,7 +2014,7 @@ int __sys_sendto(int fd, void __user *buff, size_t len, unsigned int flags,
 	err = sock_sendmsg(sock, &msg);
 
 out_put:
-	fput_light(sock->file, fput_needed);
+	sockfd_put(sock);
 out:
 	return err;
 }
@@ -2071,12 +2049,11 @@ int __sys_recvfrom(int fd, void __user *ubuf, size_t size, unsigned int flags,
 	struct msghdr msg;
 	struct sockaddr_storage address;
 	int err, err2;
-	int fput_needed;
 
 	err = import_single_range(READ, ubuf, size, &iov, &msg.msg_iter);
 	if (unlikely(err))
 		return err;
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	sock = sockfd_lookup(fd, &err);
 	if (!sock)
 		goto out;
 
@@ -2099,7 +2076,7 @@ int __sys_recvfrom(int fd, void __user *ubuf, size_t size, unsigned int flags,
 			err = err2;
 	}
 
-	fput_light(sock->file, fput_needed);
+	sockfd_put(sock);
 out:
 	return err;
 }
@@ -2141,13 +2118,13 @@ int __sys_setsockopt(int fd, int level, int optname, char __user *user_optval,
 {
 	sockptr_t optval = USER_SOCKPTR(user_optval);
 	char *kernel_optval = NULL;
-	int err, fput_needed;
+	int err;
 	struct socket *sock;
 
 	if (optlen < 0)
 		return -EINVAL;
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	sock = sockfd_lookup(fd, &err);
 	if (!sock)
 		return err;
 
@@ -2177,7 +2154,7 @@ int __sys_setsockopt(int fd, int level, int optname, char __user *user_optval,
 					    optlen);
 	kfree(kernel_optval);
 out_put:
-	fput_light(sock->file, fput_needed);
+	sockfd_put(sock);
 	return err;
 }
 
@@ -2197,11 +2174,11 @@ INDIRECT_CALLABLE_DECLARE(bool tcp_bpf_bypass_getsockopt(int level,
 int __sys_getsockopt(int fd, int level, int optname, char __user *optval,
 		int __user *optlen)
 {
-	int err, fput_needed;
+	int err;
 	struct socket *sock;
 	int max_optlen;
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	sock = sockfd_lookup(fd, &err);
 	if (!sock)
 		return err;
 
@@ -2225,7 +2202,7 @@ int __sys_getsockopt(int fd, int level, int optname, char __user *optval,
 						     optval, optlen, max_optlen,
 						     err);
 out_put:
-	fput_light(sock->file, fput_needed);
+	sockfd_put(sock);
 	return err;
 }
 
@@ -2252,13 +2229,13 @@ int __sys_shutdown_sock(struct socket *sock, int how)
 
 int __sys_shutdown(int fd, int how)
 {
-	int err, fput_needed;
+	int err;
 	struct socket *sock;
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	sock = sockfd_lookup(fd, &err);
 	if (sock != NULL) {
 		err = __sys_shutdown_sock(sock, how);
-		fput_light(sock->file, fput_needed);
+		sockfd_put(sock);
 	}
 	return err;
 }
@@ -2478,20 +2455,20 @@ long __sys_sendmsg_sock(struct socket *sock, struct msghdr *msg,
 long __sys_sendmsg(int fd, struct user_msghdr __user *msg, unsigned int flags,
 		   bool forbid_cmsg_compat)
 {
-	int fput_needed, err;
+	int err;
 	struct msghdr msg_sys;
 	struct socket *sock;
 
 	if (forbid_cmsg_compat && (flags & MSG_CMSG_COMPAT))
 		return -EINVAL;
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	sock = sockfd_lookup(fd, &err);
 	if (!sock)
 		goto out;
 
 	err = ___sys_sendmsg(sock, msg, &msg_sys, flags, NULL, 0);
 
-	fput_light(sock->file, fput_needed);
+	sockfd_put(sock);
 out:
 	return err;
 }
@@ -2508,7 +2485,7 @@ SYSCALL_DEFINE3(sendmsg, int, fd, struct user_msghdr __user *, msg, unsigned int
 int __sys_sendmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 		   unsigned int flags, bool forbid_cmsg_compat)
 {
-	int fput_needed, err, datagrams;
+	int err, datagrams;
 	struct socket *sock;
 	struct mmsghdr __user *entry;
 	struct compat_mmsghdr __user *compat_entry;
@@ -2524,7 +2501,7 @@ int __sys_sendmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 
 	datagrams = 0;
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	sock = sockfd_lookup(fd, &err);
 	if (!sock)
 		return err;
 
@@ -2563,7 +2540,7 @@ int __sys_sendmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 		cond_resched();
 	}
 
-	fput_light(sock->file, fput_needed);
+	sockfd_put(sock);
 
 	/* We only return an error if no datagrams were able to be sent */
 	if (datagrams != 0)
@@ -2686,20 +2663,20 @@ long __sys_recvmsg_sock(struct socket *sock, struct msghdr *msg,
 long __sys_recvmsg(int fd, struct user_msghdr __user *msg, unsigned int flags,
 		   bool forbid_cmsg_compat)
 {
-	int fput_needed, err;
+	int err;
 	struct msghdr msg_sys;
 	struct socket *sock;
 
 	if (forbid_cmsg_compat && (flags & MSG_CMSG_COMPAT))
 		return -EINVAL;
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	sock = sockfd_lookup(fd, &err);
 	if (!sock)
 		goto out;
 
 	err = ___sys_recvmsg(sock, msg, &msg_sys, flags, 0);
 
-	fput_light(sock->file, fput_needed);
+	sockfd_put(sock);
 out:
 	return err;
 }
@@ -2718,7 +2695,7 @@ static int do_recvmmsg(int fd, struct mmsghdr __user *mmsg,
 			  unsigned int vlen, unsigned int flags,
 			  struct timespec64 *timeout)
 {
-	int fput_needed, err, datagrams;
+	int err, datagrams;
 	struct socket *sock;
 	struct mmsghdr __user *entry;
 	struct compat_mmsghdr __user *compat_entry;
@@ -2733,7 +2710,7 @@ static int do_recvmmsg(int fd, struct mmsghdr __user *mmsg,
 
 	datagrams = 0;
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	sock = sockfd_lookup(fd, &err);
 	if (!sock)
 		return err;
 
@@ -2820,7 +2797,7 @@ static int do_recvmmsg(int fd, struct mmsghdr __user *mmsg,
 		sock->sk->sk_err = -err;
 	}
 out_put:
-	fput_light(sock->file, fput_needed);
+	sockfd_put(sock);
 
 	return datagrams;
 }
-- 
2.32.0

