Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64520DB900
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 23:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503663AbfJQV3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 17:29:11 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38177 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503649AbfJQV3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 17:29:10 -0400
Received: by mail-pf1-f196.google.com with SMTP id h195so2444314pfe.5
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 14:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=t/7vAwNRes/OgSWHDpsbdJG9hBx8gt3i+4E5Djauy08=;
        b=fL/x/mF0mKRLsVdh+dTKxKht0va6UZTptQijstDQ+mxE+lCA1zJctEyFbJr4ZUr+gW
         4gapsi0HxqSDjYfpJkRzfarcajQPqxe60/hKp9nfil6uBJRunxv79YdmKYJP6oT+e+qB
         2Otk4ugVGzFYcr6i6yqzC9VQP6W8wjQ+mUmvm5gWPV1dIp4C0fs+ejMrlQqhZ/nVtSLT
         3M/VS7nMXGNwFPa1EYwt7GWtomVU3RoeGX5nTBwlsHy7rfB36fiPFmPTR+eIsGGq7z76
         mT2aNP4IsQWJtUIOpxsxFyI0kj16+JfsRBf/0gzcHBuvPlu0KT+w+RWxTbWHdHfxtG6s
         m3SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=t/7vAwNRes/OgSWHDpsbdJG9hBx8gt3i+4E5Djauy08=;
        b=kCda0QNyqydkekN10zFGw0Mfelcp+H8Cx81dMfJeExxfxsytiW3Zb91jbyAnnSJEyO
         mG4uwIN1MdjwBb25jgKFP322XXSpO20uKH5MlA6NmnM2sR3KIXv+/qJ+eiPeYIGQkdQT
         wRsF+qw81E7GLxKpLICR0kbsRkedDv0vPqhW0NeLz/kkdDkqc8Qn8/WdhY6xl8mbuODB
         Km6uyYsZJvAdSMjNc71P7Ua0/u1vU24CK/xiW0Mt44LE4h8kPOQhh95nMdMOjBVyPToF
         LB6H2Pl5tfalTgtdLx6DwJvoz26J9tWTlJYJhF7ctsidkM7gts3C0b0MncioybJb+1je
         gTtA==
X-Gm-Message-State: APjAAAWpAn48JaZGfQP61P+sIH9sK2y1TJi5FHWz8x5pLbygjnDkoQc4
        FZ1sIMPkQXZqufujFTkWk5O/Rw==
X-Google-Smtp-Source: APXvYqw65pCCcLYeaf21mep1NwRzBJTCNVlFgTO5nxL3xO5V1yrj/5N6zT0zFBgarGPJ//ENeBWVpQ==
X-Received: by 2002:a17:90a:6508:: with SMTP id i8mr6863936pjj.44.1571347749177;
        Thu, 17 Oct 2019 14:29:09 -0700 (PDT)
Received: from x1.thefacebook.com ([2620:10d:c090:180::e2ce])
        by smtp.gmail.com with ESMTPSA id w6sm4296446pfw.84.2019.10.17.14.29.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 14:29:08 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-block@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] net: add __sys_accept4_file() helper
Date:   Thu, 17 Oct 2019 15:28:57 -0600
Message-Id: <20191017212858.13230-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191017212858.13230-1-axboe@kernel.dk>
References: <20191017212858.13230-1-axboe@kernel.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is identical to __sys_accept4(), except it takes a struct file
instead of an fd, and it also allows passing in extra file->f_flags
flags. The latter is done to support masking in O_NONBLOCK without
manipulating the original file flags.

No functional changes in this patch.

Cc: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/socket.h |  3 ++
 net/socket.c           | 65 ++++++++++++++++++++++++++----------------
 2 files changed, 44 insertions(+), 24 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index fc0bed59fc84..dd061f741bc1 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -392,6 +392,9 @@ extern int __sys_recvfrom(int fd, void __user *ubuf, size_t size,
 extern int __sys_sendto(int fd, void __user *buff, size_t len,
 			unsigned int flags, struct sockaddr __user *addr,
 			int addr_len);
+extern int __sys_accept4_file(struct file *file, unsigned file_flags,
+			struct sockaddr __user *upeer_sockaddr,
+			 int __user *upeer_addrlen, int flags);
 extern int __sys_accept4(int fd, struct sockaddr __user *upeer_sockaddr,
 			 int __user *upeer_addrlen, int flags);
 extern int __sys_socket(int family, int type, int protocol);
diff --git a/net/socket.c b/net/socket.c
index 6a9ab7a8b1d2..40ab39f6c5d8 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1690,24 +1690,13 @@ SYSCALL_DEFINE2(listen, int, fd, int, backlog)
 	return __sys_listen(fd, backlog);
 }
 
-/*
- *	For accept, we attempt to create a new socket, set up the link
- *	with the client, wake up the client, then return the new
- *	connected fd. We collect the address of the connector in kernel
- *	space and move it to user at the very end. This is unclean because
- *	we open the socket then return an error.
- *
- *	1003.1g adds the ability to recvmsg() to query connection pending
- *	status to recvmsg. We need to add that support in a way thats
- *	clean when we restructure accept also.
- */
-
-int __sys_accept4(int fd, struct sockaddr __user *upeer_sockaddr,
-		  int __user *upeer_addrlen, int flags)
+int __sys_accept4_file(struct file *file, unsigned file_flags,
+		       struct sockaddr __user *upeer_sockaddr,
+		       int __user *upeer_addrlen, int flags)
 {
 	struct socket *sock, *newsock;
 	struct file *newfile;
-	int err, len, newfd, fput_needed;
+	int err, len, newfd;
 	struct sockaddr_storage address;
 
 	if (flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
@@ -1716,14 +1705,14 @@ int __sys_accept4(int fd, struct sockaddr __user *upeer_sockaddr,
 	if (SOCK_NONBLOCK != O_NONBLOCK && (flags & SOCK_NONBLOCK))
 		flags = (flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	sock = sock_from_file(file, &err);
 	if (!sock)
 		goto out;
 
 	err = -ENFILE;
 	newsock = sock_alloc();
 	if (!newsock)
-		goto out_put;
+		goto out;
 
 	newsock->type = sock->type;
 	newsock->ops = sock->ops;
@@ -1738,20 +1727,21 @@ int __sys_accept4(int fd, struct sockaddr __user *upeer_sockaddr,
 	if (unlikely(newfd < 0)) {
 		err = newfd;
 		sock_release(newsock);
-		goto out_put;
+		goto out;
 	}
 	newfile = sock_alloc_file(newsock, flags, sock->sk->sk_prot_creator->name);
 	if (IS_ERR(newfile)) {
 		err = PTR_ERR(newfile);
 		put_unused_fd(newfd);
-		goto out_put;
+		goto out;
 	}
 
 	err = security_socket_accept(sock, newsock);
 	if (err)
 		goto out_fd;
 
-	err = sock->ops->accept(sock, newsock, sock->file->f_flags, false);
+	err = sock->ops->accept(sock, newsock, sock->file->f_flags | file_flags,
+					false);
 	if (err < 0)
 		goto out_fd;
 
@@ -1772,15 +1762,42 @@ int __sys_accept4(int fd, struct sockaddr __user *upeer_sockaddr,
 
 	fd_install(newfd, newfile);
 	err = newfd;
-
-out_put:
-	fput_light(sock->file, fput_needed);
 out:
 	return err;
 out_fd:
 	fput(newfile);
 	put_unused_fd(newfd);
-	goto out_put;
+	goto out;
+
+}
+
+/*
+ *	For accept, we attempt to create a new socket, set up the link
+ *	with the client, wake up the client, then return the new
+ *	connected fd. We collect the address of the connector in kernel
+ *	space and move it to user at the very end. This is unclean because
+ *	we open the socket then return an error.
+ *
+ *	1003.1g adds the ability to recvmsg() to query connection pending
+ *	status to recvmsg. We need to add that support in a way thats
+ *	clean when we restructure accept also.
+ */
+
+int __sys_accept4(int fd, struct sockaddr __user *upeer_sockaddr,
+		  int __user *upeer_addrlen, int flags)
+{
+	int ret = -EBADF;
+	struct fd f;
+
+	f = fdget(fd);
+	if (f.file) {
+		ret = __sys_accept4_file(f.file, 0, upeer_sockaddr,
+						upeer_addrlen, flags);
+		if (f.flags)
+			fput(f.file);
+	}
+
+	return ret;
 }
 
 SYSCALL_DEFINE4(accept4, int, fd, struct sockaddr __user *, upeer_sockaddr,
-- 
2.17.1

