Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0EB26B35D
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 01:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbgIOXCE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 15 Sep 2020 19:02:04 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:32866 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727368AbgIOOzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 10:55:51 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-225-gyJ64E1qMQiV4UPZ8HDYwQ-1; Tue, 15 Sep 2020 15:55:39 +0100
X-MC-Unique: gyJ64E1qMQiV4UPZ8HDYwQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 15 Sep 2020 15:55:38 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 15 Sep 2020 15:55:38 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 9/9 net-next] net/socket: Use iovec_import() instead of
 import_iovec().
Thread-Topic: [PATCH 9/9 net-next] net/socket: Use iovec_import() instead of
 import_iovec().
Thread-Index: AdaLblhsBop7rm5NTB+HLmhgi+sj0w==
Date:   Tue, 15 Sep 2020 14:55:38 +0000
Message-ID: <73b88df9370e4e23b9e6f77557d22a66@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


iovec_import() has a safer calling convention than import_iovec().
Also contains a small change to fs/io_uring.c

Signed-off-by: David Laight <david.laight@aculab.com>
---
 fs/io_uring.c          | 13 +++++++--
 include/linux/socket.h | 15 +++++-----
 include/net/compat.h   |  5 ++--
 net/compat.c           | 17 +++++------
 net/socket.c           | 66 ++++++++++++++++++------------------------
 5 files changed, 57 insertions(+), 59 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0df43882e4b3..79707907e00d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4031,10 +4031,17 @@ static int io_setup_async_msg(struct io_kiocb *req,
 static int io_sendmsg_copy_hdr(struct io_kiocb *req,
 			       struct io_async_msghdr *iomsg)
 {
-	iomsg->iov = iomsg->fast_iov;
+	struct iovec *iov;
+
 	iomsg->msg.msg_name = &iomsg->addr;
-	return sendmsg_copy_msghdr(&iomsg->msg, req->sr_msg.umsg,
-				   req->sr_msg.msg_flags, &iomsg->iov);
+	iov = sendmsg_copy_msghdr(&iomsg->msg, req->sr_msg.umsg,
+				  req->sr_msg.msg_flags,
+				  (void *)&iomsg->fast_iov);
+	if (IS_ERR(iov))
+		return PTR_ERR(iov);
+	/* Save any buffer that must be freed after the request completes. */
+	iomsg->iov = iov;
+	return 0;
 }
 
 static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
diff --git a/include/linux/socket.h b/include/linux/socket.h
index e9cb30d8cbfb..58d82ac014e2 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -398,13 +398,14 @@ extern long __sys_recvmsg_sock(struct socket *sock, struct msghdr *msg,
 			       struct user_msghdr __user *umsg,
 			       struct sockaddr __user *uaddr,
 			       unsigned int flags);
-extern int sendmsg_copy_msghdr(struct msghdr *msg,
-			       struct user_msghdr __user *umsg, unsigned flags,
-			       struct iovec **iov);
-extern int recvmsg_copy_msghdr(struct msghdr *msg,
-			       struct user_msghdr __user *umsg, unsigned flags,
-			       struct sockaddr __user **uaddr,
-			       struct iovec **iov);
+struct iovec *sendmsg_copy_msghdr(struct msghdr *msg,
+				  struct user_msghdr __user *umsg,
+				  unsigned flags, struct iovec_cache *cache);
+struct iovec *recvmsg_copy_msghdr(struct msghdr *msg,
+				  struct user_msghdr __user *umsg,
+				  unsigned flags,
+				  struct sockaddr __user **uaddr,
+				  struct iovec_cache *cache);
 extern int __copy_msghdr_from_user(struct msghdr *kmsg,
 				   struct user_msghdr __user *umsg,
 				   struct sockaddr __user **save_addr,
diff --git a/include/net/compat.h b/include/net/compat.h
index 745db0d605b6..61b8408e16b5 100644
--- a/include/net/compat.h
+++ b/include/net/compat.h
@@ -59,8 +59,9 @@ struct compat_rtentry {
 int __get_compat_msghdr(struct msghdr *kmsg, struct compat_msghdr __user *umsg,
 			struct sockaddr __user **save_addr, compat_uptr_t *ptr,
 			compat_size_t *len);
-int get_compat_msghdr(struct msghdr *, struct compat_msghdr __user *,
-		      struct sockaddr __user **, struct iovec **);
+struct iovec *get_compat_msghdr(struct msghdr *, struct compat_msghdr __user *,
+				struct sockaddr __user **,
+				struct iovec_cache *);
 int put_cmsg_compat(struct msghdr*, int, int, int, void *);
 
 int cmsghdr_from_user_compat_to_kern(struct msghdr *, struct sock *,
diff --git a/net/compat.c b/net/compat.c
index 95ce707a30a3..3b37f6273891 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -85,22 +85,21 @@ int __get_compat_msghdr(struct msghdr *kmsg,
 	return 0;
 }
 
-int get_compat_msghdr(struct msghdr *kmsg,
-		      struct compat_msghdr __user *umsg,
-		      struct sockaddr __user **save_addr,
-		      struct iovec **iov)
+struct iovec *get_compat_msghdr(struct msghdr *kmsg,
+			        struct compat_msghdr __user *umsg,
+			        struct sockaddr __user **save_addr,
+			        struct iovec_cache *cache)
 {
 	compat_uptr_t ptr;
 	compat_size_t len;
-	ssize_t err;
+	int err;
 
 	err = __get_compat_msghdr(kmsg, umsg, save_addr, &ptr, &len);
 	if (err)
-		return err;
+		return ERR_PTR(err);
 
-	err = compat_import_iovec(save_addr ? READ : WRITE, compat_ptr(ptr),
-				   len, UIO_FASTIOV, iov, &kmsg->msg_iter);
-	return err < 0 ? err : 0;
+	return compat_iovec_import(save_addr ? READ : WRITE, compat_ptr(ptr),
+				   len, cache, &kmsg->msg_iter);
 }
 
 /* Bleech... */
diff --git a/net/socket.c b/net/socket.c
index 0c0144604f81..00feed199d53 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2275,10 +2275,10 @@ int __copy_msghdr_from_user(struct msghdr *kmsg,
 	return 0;
 }
 
-static int copy_msghdr_from_user(struct msghdr *kmsg,
-				 struct user_msghdr __user *umsg,
-				 struct sockaddr __user **save_addr,
-				 struct iovec **iov)
+static struct iovec *copy_msghdr_from_user(struct msghdr *kmsg,
+					   struct user_msghdr __user *umsg,
+					   struct sockaddr __user **save_addr,
+					   struct iovec_cache *cache)
 {
 	struct user_msghdr msg;
 	ssize_t err;
@@ -2286,12 +2286,11 @@ static int copy_msghdr_from_user(struct msghdr *kmsg,
 	err = __copy_msghdr_from_user(kmsg, umsg, save_addr, &msg.msg_iov,
 					&msg.msg_iovlen);
 	if (err)
-		return err;
+		return ERR_PTR(err);
 
-	err = import_iovec(save_addr ? READ : WRITE,
+	return iovec_import(save_addr ? READ : WRITE,
 			    msg.msg_iov, msg.msg_iovlen,
-			    UIO_FASTIOV, iov, &kmsg->msg_iter);
-	return err < 0 ? err : 0;
+			    cache, &kmsg->msg_iter);
 }
 
 static int ____sys_sendmsg(struct socket *sock, struct msghdr *msg_sys,
@@ -2369,24 +2368,18 @@ static int ____sys_sendmsg(struct socket *sock, struct msghdr *msg_sys,
 	return err;
 }
 
-int sendmsg_copy_msghdr(struct msghdr *msg,
+struct iovec *sendmsg_copy_msghdr(struct msghdr *msg,
 			struct user_msghdr __user *umsg, unsigned flags,
-			struct iovec **iov)
+			struct iovec_cache *cache)
 {
-	int err;
-
 	if (flags & MSG_CMSG_COMPAT) {
 		struct compat_msghdr __user *msg_compat;
 
 		msg_compat = (struct compat_msghdr __user *) umsg;
-		err = get_compat_msghdr(msg, msg_compat, NULL, iov);
-	} else {
-		err = copy_msghdr_from_user(msg, umsg, NULL, iov);
+		return get_compat_msghdr(msg, msg_compat, NULL, cache);
 	}
-	if (err < 0)
-		return err;
 
-	return 0;
+	return copy_msghdr_from_user(msg, umsg, NULL, cache);
 }
 
 static int ___sys_sendmsg(struct socket *sock, struct user_msghdr __user *msg,
@@ -2395,14 +2388,15 @@ static int ___sys_sendmsg(struct socket *sock, struct user_msghdr __user *msg,
 			 unsigned int allowed_msghdr_flags)
 {
 	struct sockaddr_storage address;
-	struct iovec iovstack[UIO_FASTIOV], *iov = iovstack;
+	struct iovec_cache cache;
+	struct iovec *iov;
 	ssize_t err;
 
 	msg_sys->msg_name = &address;
 
-	err = sendmsg_copy_msghdr(msg_sys, msg, flags, &iov);
-	if (err < 0)
-		return err;
+	iov = sendmsg_copy_msghdr(msg_sys, msg, flags, &cache);
+	if (IS_ERR(iov))
+		return PTR_ERR(iov);
 
 	err = ____sys_sendmsg(sock, msg_sys, flags, used_address,
 				allowed_msghdr_flags);
@@ -2526,25 +2520,20 @@ SYSCALL_DEFINE4(sendmmsg, int, fd, struct mmsghdr __user *, mmsg,
 	return __sys_sendmmsg(fd, mmsg, vlen, flags, true);
 }
 
-int recvmsg_copy_msghdr(struct msghdr *msg,
-			struct user_msghdr __user *umsg, unsigned flags,
-			struct sockaddr __user **uaddr,
-			struct iovec **iov)
+struct iovec *recvmsg_copy_msghdr(struct msghdr *msg,
+				  struct user_msghdr __user *umsg,
+				  unsigned flags,
+				  struct sockaddr __user **uaddr,
+				  struct iovec_cache *cache)
 {
-	ssize_t err;
-
 	if (MSG_CMSG_COMPAT & flags) {
 		struct compat_msghdr __user *msg_compat;
 
 		msg_compat = (struct compat_msghdr __user *) umsg;
-		err = get_compat_msghdr(msg, msg_compat, uaddr, iov);
-	} else {
-		err = copy_msghdr_from_user(msg, umsg, uaddr, iov);
+		return get_compat_msghdr(msg, msg_compat, uaddr, cache);
 	}
-	if (err < 0)
-		return err;
 
-	return 0;
+	return copy_msghdr_from_user(msg, umsg, uaddr, cache);
 }
 
 static int ____sys_recvmsg(struct socket *sock, struct msghdr *msg_sys,
@@ -2606,14 +2595,15 @@ static int ____sys_recvmsg(struct socket *sock, struct msghdr *msg_sys,
 static int ___sys_recvmsg(struct socket *sock, struct user_msghdr __user *msg,
 			 struct msghdr *msg_sys, unsigned int flags, int nosec)
 {
-	struct iovec iovstack[UIO_FASTIOV], *iov = iovstack;
+	struct iovec_cache cache;
+	struct iovec *iov;
 	/* user mode address pointers */
 	struct sockaddr __user *uaddr;
 	ssize_t err;
 
-	err = recvmsg_copy_msghdr(msg_sys, msg, flags, &uaddr, &iov);
-	if (err < 0)
-		return err;
+	iov = recvmsg_copy_msghdr(msg_sys, msg, flags, &uaddr, &cache);
+	if (IS_ERR(iov))
+		return PTR_ERR(iov);
 
 	err = ____sys_recvmsg(sock, msg_sys, msg, uaddr, flags, nosec);
 	kfree(iov);
-- 
2.25.1

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

