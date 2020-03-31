Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD111997E3
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 15:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731144AbgCaNwe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 31 Mar 2020 09:52:34 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:20595 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731120AbgCaNwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 09:52:33 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-143-aaKZBYIcPiSJ7fCHXFRLoQ-2; Tue, 31 Mar 2020 14:52:28 +0100
X-MC-Unique: aaKZBYIcPiSJ7fCHXFRLoQ-2
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 31 Mar 2020 14:52:25 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 31 Mar 2020 14:52:25 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [RFC PATCH 10/12] net/socket: Use iovec_import() instead of
 import_iovec().
Thread-Topic: [RFC PATCH 10/12] net/socket: Use iovec_import() instead of
 import_iovec().
Thread-Index: AdYHY26Pn/zazxI4TBqBFviolCOniA==
Date:   Tue, 31 Mar 2020 13:52:25 +0000
Message-ID: <b433aca086ad4a7ba36f7559e3ccc458@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Signed-off-by: David Laight <david.laight@aculab.com>
---
 include/linux/socket.h | 14 +++++-----
 include/net/compat.h   |  4 +--
 net/compat.c           | 21 +++++++-------
 net/socket.c           | 74 ++++++++++++++++++++++----------------------------
 4 files changed, 51 insertions(+), 62 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 15f3412..458bcf4 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -384,13 +384,13 @@ extern long __sys_recvmsg_sock(struct socket *sock, struct msghdr *msg,
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
+				  struct user_msghdr __user *umsg, unsigned flags,
+				  struct iovec_cache *cache);
+struct iovec *recvmsg_copy_msghdr(struct msghdr *msg,
+				  struct user_msghdr __user *umsg, unsigned flags,
+				  struct sockaddr __user **uaddr,
+				  struct iovec_cache *cache);
 
 /* helpers which do the actual work for syscalls */
 extern int __sys_recvfrom(int fd, void __user *ubuf, size_t size,
diff --git a/include/net/compat.h b/include/net/compat.h
index f277653..00094fb 100644
--- a/include/net/compat.h
+++ b/include/net/compat.h
@@ -38,8 +38,8 @@ struct compat_cmsghdr {
 #define compat_mmsghdr	mmsghdr
 #endif /* defined(CONFIG_COMPAT) */
 
-int get_compat_msghdr(struct msghdr *, struct compat_msghdr __user *,
-		      struct sockaddr __user **, struct iovec **);
+struct iovec *get_compat_msghdr(struct msghdr *, struct compat_msghdr __user *,
+				struct sockaddr __user **, struct iovec_cache *);
 struct sock_fprog __user *get_compat_bpf_fprog(char __user *optval);
 int put_cmsg_compat(struct msghdr*, int, int, int, void *);
 
diff --git a/net/compat.c b/net/compat.c
index 47d99c7..96bf01f 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -33,16 +33,16 @@
 #include <linux/uaccess.h>
 #include <net/compat.h>
 
-int get_compat_msghdr(struct msghdr *kmsg,
-		      struct compat_msghdr __user *umsg,
-		      struct sockaddr __user **save_addr,
-		      struct iovec **iov)
+struct iovec *get_compat_msghdr(struct msghdr *kmsg,
+				struct compat_msghdr __user *umsg,
+				struct sockaddr __user **save_addr,
+				struct iovec_cache *cache)
 {
 	struct compat_msghdr msg;
 	ssize_t err;
 
 	if (copy_from_user(&msg, umsg, sizeof(*umsg)))
-		return -EFAULT;
+		return ERR_PTR(-EFAULT);
 
 	kmsg->msg_flags = msg.msg_flags;
 	kmsg->msg_namelen = msg.msg_namelen;
@@ -51,7 +51,7 @@ int get_compat_msghdr(struct msghdr *kmsg,
 		kmsg->msg_namelen = 0;
 
 	if (kmsg->msg_namelen < 0)
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
 	if (kmsg->msg_namelen > sizeof(struct sockaddr_storage))
 		kmsg->msg_namelen = sizeof(struct sockaddr_storage);
@@ -68,7 +68,7 @@ int get_compat_msghdr(struct msghdr *kmsg,
 						  kmsg->msg_namelen,
 						  kmsg->msg_name);
 			if (err < 0)
-				return err;
+				return ERR_PTR(err);
 		}
 	} else {
 		kmsg->msg_name = NULL;
@@ -76,14 +76,13 @@ int get_compat_msghdr(struct msghdr *kmsg,
 	}
 
 	if (msg.msg_iovlen > UIO_MAXIOV)
-		return -EMSGSIZE;
+		return ERR_PTR(-EMSGSIZE);
 
 	kmsg->msg_iocb = NULL;
 
-	err = compat_import_iovec(save_addr ? READ : WRITE,
+	return compat_iovec_import(save_addr ? READ : WRITE,
 				   compat_ptr(msg.msg_iov), msg.msg_iovlen,
-				   UIO_FASTIOV, iov, &kmsg->msg_iter);
-	return err < 0 ? err : 0;
+				   cache, &kmsg->msg_iter);
 }
 
 /* Bleech... */
diff --git a/net/socket.c b/net/socket.c
index 2eecf15..7431cf4 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2228,16 +2228,16 @@ struct used_address {
 	unsigned int name_len;
 };
 
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
 
 	if (copy_from_user(&msg, umsg, sizeof(*umsg)))
-		return -EFAULT;
+		return ERR_PTR(-EFAULT);
 
 	kmsg->msg_control = (void __force *)msg.msg_control;
 	kmsg->msg_controllen = msg.msg_controllen;
@@ -2248,7 +2248,7 @@ static int copy_msghdr_from_user(struct msghdr *kmsg,
 		kmsg->msg_namelen = 0;
 
 	if (kmsg->msg_namelen < 0)
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
 	if (kmsg->msg_namelen > sizeof(struct sockaddr_storage))
 		kmsg->msg_namelen = sizeof(struct sockaddr_storage);
@@ -2262,7 +2262,7 @@ static int copy_msghdr_from_user(struct msghdr *kmsg,
 						  kmsg->msg_namelen,
 						  kmsg->msg_name);
 			if (err < 0)
-				return err;
+				return ERR_PTR(err);
 		}
 	} else {
 		kmsg->msg_name = NULL;
@@ -2270,14 +2270,13 @@ static int copy_msghdr_from_user(struct msghdr *kmsg,
 	}
 
 	if (msg.msg_iovlen > UIO_MAXIOV)
-		return -EMSGSIZE;
+		return ERR_PTR(-EMSGSIZE);
 
 	kmsg->msg_iocb = NULL;
 
-	err = import_iovec(save_addr ? READ : WRITE,
+	return iovec_import(save_addr ? READ : WRITE,
 			    msg.msg_iov, msg.msg_iovlen,
-			    UIO_FASTIOV, iov, &kmsg->msg_iter);
-	return err < 0 ? err : 0;
+			    cache, &kmsg->msg_iter);
 }
 
 static int ____sys_sendmsg(struct socket *sock, struct msghdr *msg_sys,
@@ -2361,24 +2360,18 @@ static int ____sys_sendmsg(struct socket *sock, struct msghdr *msg_sys,
 	return err;
 }
 
-int sendmsg_copy_msghdr(struct msghdr *msg,
-			struct user_msghdr __user *umsg, unsigned flags,
-			struct iovec **iov)
+struct iovec *sendmsg_copy_msghdr(struct msghdr *msg,
+				  struct user_msghdr __user *umsg,
+				  unsigned flags, struct iovec_cache *cache)
 {
-	int err;
-
 	if (flags & MSG_CMSG_COMPAT) {
 		struct compat_msghdr __user *msg_compat;
 
 		msg_compat = (struct compat_msghdr __user *) umsg;
-		err = get_compat_msghdr(msg, msg_compat, NULL, iov);
+		return get_compat_msghdr(msg, msg_compat, NULL, cache);
 	} else {
-		err = copy_msghdr_from_user(msg, umsg, NULL, iov);
+		return copy_msghdr_from_user(msg, umsg, NULL, cache);
 	}
-	if (err < 0)
-		return err;
-
-	return 0;
 }
 
 static int ___sys_sendmsg(struct socket *sock, struct user_msghdr __user *msg,
@@ -2386,15 +2379,16 @@ static int ___sys_sendmsg(struct socket *sock, struct user_msghdr __user *msg,
 			 struct used_address *used_address,
 			 unsigned int allowed_msghdr_flags)
 {
+	struct iovec_cache cache;
+	struct iovec *iov;
 	struct sockaddr_storage address;
-	struct iovec iovstack[UIO_FASTIOV], *iov = iovstack;
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
@@ -2518,25 +2512,20 @@ int __sys_sendmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
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
+		return get_compat_msghdr(msg, msg_compat, uaddr, cache);
 	} else {
-		err = copy_msghdr_from_user(msg, umsg, uaddr, iov);
+		return copy_msghdr_from_user(msg, umsg, uaddr, cache);
 	}
-	if (err < 0)
-		return err;
-
-	return 0;
 }
 
 static int ____sys_recvmsg(struct socket *sock, struct msghdr *msg_sys,
@@ -2598,14 +2587,15 @@ static int ____sys_recvmsg(struct socket *sock, struct msghdr *msg_sys,
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
1.8.1.2

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

