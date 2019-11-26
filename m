Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5747C109793
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 02:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbfKZBbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 20:31:53 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:38024 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfKZBbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 20:31:52 -0500
Received: by mail-io1-f66.google.com with SMTP id u24so16901614iob.5
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 17:31:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1o0OX2YLgPzhy5X/SvFBK25ZSj4cbH27XyZbloESzeY=;
        b=PK2MKih4TDBZLv/ZNGD72zxSxjD1W5FKHHOLGZVuGgqFFq/Im/L9aDcb3zztxcjSps
         VuGBj4TmmElqvhQOZRhH0frChs+n4RSXQeEj7eAYKm2dtSLPXzmEJihmR90EKdJbORYi
         f9/SEGtmz3NIX/gGkE++ohLvUIO68NciCwLWhDB912tYVLNkTXJDM2YUTYIoZUWLa+QU
         YpZL8mvaApakr0a6uhzlo34HLrpqOPMscotW8CpFosRfeJtSlLiNfQG9LnsvUq6F8l2H
         EWmjB1IUAVnrYmCppa0zVy4earyTRwrqCrOwP5ID7WMt/Cj9KurIKhre/sZAzkjblPsv
         0xXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1o0OX2YLgPzhy5X/SvFBK25ZSj4cbH27XyZbloESzeY=;
        b=VAGViuKqmf8Wph6vDOg4F6QUXuZi4Rc5Kg4qKkDRvPSU62zABIFL4fDQP/3TnzpGYY
         rEvZgzALV928gaiPWDBE1loyfjGAn9wnz2c0zoucEV8vUP8+/BaBKp9yeEHfnfxkVwrW
         JNYximix54kfSX44uv8lBHBMI05iB5f9ULikgVyEWRxtHz4rzlkSlX5e3V8EWHmOUxpJ
         zp/vtyU9aPV9W1u+laFZJte7pXoXDN7p2oCDlUNndTk0DRmvgzOaAtCSOlMi/OfHdt4w
         OMBHFQwakodWwWHRNJWG4yDPkUHuSU9L2r5EHY3W0E0n29hfyJEAV6scwPvEq3635ARN
         zgUA==
X-Gm-Message-State: APjAAAWKyJdninoTO+PiMUIS/IiR9ufxS82nbVLePffzjCtYcKsjFqEd
        aLOFtZiJ1L6S325M/uuvMoqXV/zeXACzMg==
X-Google-Smtp-Source: APXvYqx78QpTwtk3XacXB4VESn+egX6qAtyUOupxr7UBZa3iCHU7Op7mwwQlbeAX/+wOlwOn/w0CaQ==
X-Received: by 2002:a5d:8184:: with SMTP id u4mr27883529ion.155.1574731910731;
        Mon, 25 Nov 2019 17:31:50 -0800 (PST)
Received: from localhost.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v15sm2723353ilk.8.2019.11.25.17.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 17:31:49 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] net: separate out the msghdr copy from ___sys_{send,recv}msg()
Date:   Mon, 25 Nov 2019 18:31:44 -0700
Message-Id: <20191126013145.23426-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191126013145.23426-1-axboe@kernel.dk>
References: <20191126013145.23426-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is in preparation for enabling the io_uring helpers for sendmsg
and recvmsg to first copy the header for validation before continuing
with the operation.

There should be no functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 net/socket.c | 141 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 95 insertions(+), 46 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index 96e44b55d3d3..da729df8f03d 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2263,15 +2263,10 @@ static int copy_msghdr_from_user(struct msghdr *kmsg,
 	return err < 0 ? err : 0;
 }
 
-static int ___sys_sendmsg(struct socket *sock, struct user_msghdr __user *msg,
-			 struct msghdr *msg_sys, unsigned int flags,
-			 struct used_address *used_address,
-			 unsigned int allowed_msghdr_flags)
+static int ____sys_sendmsg(struct socket *sock, struct msghdr *msg_sys,
+			   unsigned int flags, struct used_address *used_address,
+			   unsigned int allowed_msghdr_flags)
 {
-	struct compat_msghdr __user *msg_compat =
-	    (struct compat_msghdr __user *)msg;
-	struct sockaddr_storage address;
-	struct iovec iovstack[UIO_FASTIOV], *iov = iovstack;
 	unsigned char ctl[sizeof(struct cmsghdr) + 20]
 				__aligned(sizeof(__kernel_size_t));
 	/* 20 is size of ipv6_pktinfo */
@@ -2279,19 +2274,10 @@ static int ___sys_sendmsg(struct socket *sock, struct user_msghdr __user *msg,
 	int ctl_len;
 	ssize_t err;
 
-	msg_sys->msg_name = &address;
-
-	if (MSG_CMSG_COMPAT & flags)
-		err = get_compat_msghdr(msg_sys, msg_compat, NULL, &iov);
-	else
-		err = copy_msghdr_from_user(msg_sys, msg, NULL, &iov);
-	if (err < 0)
-		return err;
-
 	err = -ENOBUFS;
 
 	if (msg_sys->msg_controllen > INT_MAX)
-		goto out_freeiov;
+		goto out;
 	flags |= (msg_sys->msg_flags & allowed_msghdr_flags);
 	ctl_len = msg_sys->msg_controllen;
 	if ((MSG_CMSG_COMPAT & flags) && ctl_len) {
@@ -2299,7 +2285,7 @@ static int ___sys_sendmsg(struct socket *sock, struct user_msghdr __user *msg,
 		    cmsghdr_from_user_compat_to_kern(msg_sys, sock->sk, ctl,
 						     sizeof(ctl));
 		if (err)
-			goto out_freeiov;
+			goto out;
 		ctl_buf = msg_sys->msg_control;
 		ctl_len = msg_sys->msg_controllen;
 	} else if (ctl_len) {
@@ -2308,7 +2294,7 @@ static int ___sys_sendmsg(struct socket *sock, struct user_msghdr __user *msg,
 		if (ctl_len > sizeof(ctl)) {
 			ctl_buf = sock_kmalloc(sock->sk, ctl_len, GFP_KERNEL);
 			if (ctl_buf == NULL)
-				goto out_freeiov;
+				goto out;
 		}
 		err = -EFAULT;
 		/*
@@ -2354,7 +2340,47 @@ static int ___sys_sendmsg(struct socket *sock, struct user_msghdr __user *msg,
 out_freectl:
 	if (ctl_buf != ctl)
 		sock_kfree_s(sock->sk, ctl_buf, ctl_len);
-out_freeiov:
+out:
+	return err;
+}
+
+static int sendmsg_copy_msghdr(struct msghdr *msg,
+			       struct user_msghdr __user *umsg, unsigned flags,
+			       struct iovec **iov)
+{
+	int err;
+
+	if (flags & MSG_CMSG_COMPAT) {
+		struct compat_msghdr __user *msg_compat;
+
+		msg_compat = (struct compat_msghdr __user *) umsg;
+		err = get_compat_msghdr(msg, msg_compat, NULL, iov);
+	} else {
+		err = copy_msghdr_from_user(msg, umsg, NULL, iov);
+	}
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
+static int ___sys_sendmsg(struct socket *sock, struct user_msghdr __user *msg,
+			 struct msghdr *msg_sys, unsigned int flags,
+			 struct used_address *used_address,
+			 unsigned int allowed_msghdr_flags)
+{
+	struct sockaddr_storage address;
+	struct iovec iovstack[UIO_FASTIOV], *iov = iovstack;
+	ssize_t err;
+
+	msg_sys->msg_name = &address;
+
+	err = sendmsg_copy_msghdr(msg_sys, msg, flags, &iov);
+	if (err < 0)
+		return err;
+
+	err = ____sys_sendmsg(sock, msg_sys, flags, used_address,
+				allowed_msghdr_flags);
 	kfree(iov);
 	return err;
 }
@@ -2473,33 +2499,41 @@ SYSCALL_DEFINE4(sendmmsg, int, fd, struct mmsghdr __user *, mmsg,
 	return __sys_sendmmsg(fd, mmsg, vlen, flags, true);
 }
 
-static int ___sys_recvmsg(struct socket *sock, struct user_msghdr __user *msg,
-			 struct msghdr *msg_sys, unsigned int flags, int nosec)
+static int recvmsg_copy_msghdr(struct msghdr *msg,
+			       struct user_msghdr __user *umsg, unsigned flags,
+			       struct sockaddr __user **uaddr,
+			       struct iovec **iov)
 {
-	struct compat_msghdr __user *msg_compat =
-	    (struct compat_msghdr __user *)msg;
-	struct iovec iovstack[UIO_FASTIOV];
-	struct iovec *iov = iovstack;
-	unsigned long cmsg_ptr;
-	int len;
 	ssize_t err;
 
-	/* kernel mode address */
-	struct sockaddr_storage addr;
-
-	/* user mode address pointers */
-	struct sockaddr __user *uaddr;
-	int __user *uaddr_len = COMPAT_NAMELEN(msg);
-
-	msg_sys->msg_name = &addr;
+	if (MSG_CMSG_COMPAT & flags) {
+		struct compat_msghdr __user *msg_compat;
 
-	if (MSG_CMSG_COMPAT & flags)
-		err = get_compat_msghdr(msg_sys, msg_compat, &uaddr, &iov);
-	else
-		err = copy_msghdr_from_user(msg_sys, msg, &uaddr, &iov);
+		msg_compat = (struct compat_msghdr __user *) umsg;
+		err = get_compat_msghdr(msg, msg_compat, uaddr, iov);
+	} else {
+		err = copy_msghdr_from_user(msg, umsg, uaddr, iov);
+	}
 	if (err < 0)
 		return err;
 
+	return 0;
+}
+
+static int ____sys_recvmsg(struct socket *sock, struct msghdr *msg_sys,
+			   struct user_msghdr __user *msg,
+			   struct sockaddr __user *uaddr,
+			   unsigned int flags, int nosec)
+{
+	struct compat_msghdr __user *msg_compat =
+					(struct compat_msghdr __user *) msg;
+	int __user *uaddr_len = COMPAT_NAMELEN(msg);
+	struct sockaddr_storage addr;
+	unsigned long cmsg_ptr;
+	int len;
+	ssize_t err;
+
+	msg_sys->msg_name = &addr;
 	cmsg_ptr = (unsigned long)msg_sys->msg_control;
 	msg_sys->msg_flags = flags & (MSG_CMSG_CLOEXEC|MSG_CMSG_COMPAT);
 
@@ -2510,7 +2544,7 @@ static int ___sys_recvmsg(struct socket *sock, struct user_msghdr __user *msg,
 		flags |= MSG_DONTWAIT;
 	err = (nosec ? sock_recvmsg_nosec : sock_recvmsg)(sock, msg_sys, flags);
 	if (err < 0)
-		goto out_freeiov;
+		goto out;
 	len = err;
 
 	if (uaddr != NULL) {
@@ -2518,12 +2552,12 @@ static int ___sys_recvmsg(struct socket *sock, struct user_msghdr __user *msg,
 					msg_sys->msg_namelen, uaddr,
 					uaddr_len);
 		if (err < 0)
-			goto out_freeiov;
+			goto out;
 	}
 	err = __put_user((msg_sys->msg_flags & ~MSG_CMSG_COMPAT),
 			 COMPAT_FLAGS(msg));
 	if (err)
-		goto out_freeiov;
+		goto out;
 	if (MSG_CMSG_COMPAT & flags)
 		err = __put_user((unsigned long)msg_sys->msg_control - cmsg_ptr,
 				 &msg_compat->msg_controllen);
@@ -2531,10 +2565,25 @@ static int ___sys_recvmsg(struct socket *sock, struct user_msghdr __user *msg,
 		err = __put_user((unsigned long)msg_sys->msg_control - cmsg_ptr,
 				 &msg->msg_controllen);
 	if (err)
-		goto out_freeiov;
+		goto out;
 	err = len;
+out:
+	return err;
+}
+
+static int ___sys_recvmsg(struct socket *sock, struct user_msghdr __user *msg,
+			 struct msghdr *msg_sys, unsigned int flags, int nosec)
+{
+	struct iovec iovstack[UIO_FASTIOV], *iov = iovstack;
+	/* user mode address pointers */
+	struct sockaddr __user *uaddr;
+	ssize_t err;
+
+	err = recvmsg_copy_msghdr(msg_sys, msg, flags, &uaddr, &iov);
+	if (err < 0)
+		return err;
 
-out_freeiov:
+	err = ____sys_recvmsg(sock, msg_sys, msg, uaddr, flags, nosec);
 	kfree(iov);
 	return err;
 }
-- 
2.24.0

