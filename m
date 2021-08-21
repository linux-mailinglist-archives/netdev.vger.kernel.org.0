Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 043E03F3B3A
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 17:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234186AbhHUPyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 11:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232711AbhHUPyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Aug 2021 11:54:01 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53259C061756;
        Sat, 21 Aug 2021 08:53:21 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id x12so18695338wrr.11;
        Sat, 21 Aug 2021 08:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EaXGPCv4rG5J1NZC9xHyYL1z2IpeWIiNJsgYxDUUWOE=;
        b=WStex6K3KqJn+YrCKUpF27VJnmqTe5HVUbrKrF5sSVxa8d1CKtlPyDrQZCUHpQ/N37
         khDZTaioYPkmpRYbECVI4hO/9uWkIsgeM7Z6FvwPEoxjkjOnC1COP0FqK2bxx/ODxktz
         nl8HUQ1JK0RtQQZFCQVPurVZL/T2i351r47hjqHuqAAlCRhhSL9CUk2VdoCAwS5aGDYq
         u7MCFTyjFSFPxW8dQj6IiuwRIcoP/l89d3nqVTwyWY8Z+jl2PY9jd6MYFXmpmv8U8Bfk
         Y1L21vJpaq/REPGzWP1O0PxYQzOjbGiuENNINKIUYmvKMhnh3/3T6nFtjsFrgbIDIkVm
         bn3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EaXGPCv4rG5J1NZC9xHyYL1z2IpeWIiNJsgYxDUUWOE=;
        b=jUTvW/ylSh8Gw1NL/0oLmsUAl3WpaFjGeCFfNb1dyQKsvaRPHABcCMy/DIk1hOUPmU
         4c1HgvP8xjTAUD0efUvpnSA/esKEAGOarT/feToA4Ed+Rmd1GTYt87HSwVfX1VL7USbA
         06JD1HNvVPE+24enIb26ngqJYq8XDQ9U4nSisZp123ZpvVKU+t4XCoX/KvvmqxwE0xcB
         64a3crUKRcHoCYb6K/dUqVFYzfik+lQ0zVBg39l/WwzagHiRzFCtna/JqqLqLyeqV9iw
         L4WszOUvR8MfebUo0bdEwyIqHuyb6gm9CFzPQ9/Dm1cnvrf/rV9Frml3wkZWcjdR5aHF
         TzYA==
X-Gm-Message-State: AOAM533tlbvjyfm4FsHCz1r503sLr/mfbBAWH3OPWf3UY1PlNLDKbOdE
        cU1wqLGRWsPHQVHaS32xwqg=
X-Google-Smtp-Source: ABdhPJwh8JwR54YZAijqIKivJ2KfYh4N1PejPXdKciXvhfxqm3kBKwpK7LwKnT+oRQnd4vglVGDqZQ==
X-Received: by 2002:a5d:618c:: with SMTP id j12mr4462461wru.374.1629561199997;
        Sat, 21 Aug 2021 08:53:19 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.174])
        by smtp.gmail.com with ESMTPSA id e3sm9479554wro.15.2021.08.21.08.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Aug 2021 08:53:19 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v3 1/4] net: add accept helper not installing fd
Date:   Sat, 21 Aug 2021 16:52:37 +0100
Message-Id: <0c5d77e34ebff09f1f2f6b9bff15b97ec8fbf8ca.1629559905.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1629559905.git.asml.silence@gmail.com>
References: <cover.1629559905.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce and reuse a helper that acts similarly to __sys_accept4_file()
but returns struct file instead of installing file descriptor. Will be
used by io_uring.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/socket.h |  3 ++
 net/socket.c           | 71 ++++++++++++++++++++++--------------------
 2 files changed, 40 insertions(+), 34 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 0d8e3dcb7f88..d3c1a42a2edd 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -421,6 +421,9 @@ extern int __sys_accept4_file(struct file *file, unsigned file_flags,
 			struct sockaddr __user *upeer_sockaddr,
 			 int __user *upeer_addrlen, int flags,
 			 unsigned long nofile);
+extern struct file *do_accept(struct file *file, unsigned file_flags,
+			      struct sockaddr __user *upeer_sockaddr,
+			      int __user *upeer_addrlen, int flags);
 extern int __sys_accept4(int fd, struct sockaddr __user *upeer_sockaddr,
 			 int __user *upeer_addrlen, int flags);
 extern int __sys_socket(int family, int type, int protocol);
diff --git a/net/socket.c b/net/socket.c
index 0b2dad3bdf7f..532fff5a3684 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1722,32 +1722,22 @@ SYSCALL_DEFINE2(listen, int, fd, int, backlog)
 	return __sys_listen(fd, backlog);
 }
 
-int __sys_accept4_file(struct file *file, unsigned file_flags,
+struct file *do_accept(struct file *file, unsigned file_flags,
 		       struct sockaddr __user *upeer_sockaddr,
-		       int __user *upeer_addrlen, int flags,
-		       unsigned long nofile)
+		       int __user *upeer_addrlen, int flags)
 {
 	struct socket *sock, *newsock;
 	struct file *newfile;
-	int err, len, newfd;
+	int err, len;
 	struct sockaddr_storage address;
 
-	if (flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
-		return -EINVAL;
-
-	if (SOCK_NONBLOCK != O_NONBLOCK && (flags & SOCK_NONBLOCK))
-		flags = (flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
-
 	sock = sock_from_file(file);
-	if (!sock) {
-		err = -ENOTSOCK;
-		goto out;
-	}
+	if (!sock)
+		return ERR_PTR(-ENOTSOCK);
 
-	err = -ENFILE;
 	newsock = sock_alloc();
 	if (!newsock)
-		goto out;
+		return ERR_PTR(-ENFILE);
 
 	newsock->type = sock->type;
 	newsock->ops = sock->ops;
@@ -1758,18 +1748,9 @@ int __sys_accept4_file(struct file *file, unsigned file_flags,
 	 */
 	__module_get(newsock->ops->owner);
 
-	newfd = __get_unused_fd_flags(flags, nofile);
-	if (unlikely(newfd < 0)) {
-		err = newfd;
-		sock_release(newsock);
-		goto out;
-	}
 	newfile = sock_alloc_file(newsock, flags, sock->sk->sk_prot_creator->name);
-	if (IS_ERR(newfile)) {
-		err = PTR_ERR(newfile);
-		put_unused_fd(newfd);
-		goto out;
-	}
+	if (IS_ERR(newfile))
+		return newfile;
 
 	err = security_socket_accept(sock, newsock);
 	if (err)
@@ -1794,16 +1775,38 @@ int __sys_accept4_file(struct file *file, unsigned file_flags,
 	}
 
 	/* File flags are not inherited via accept() unlike another OSes. */
-
-	fd_install(newfd, newfile);
-	err = newfd;
-out:
-	return err;
+	return newfile;
 out_fd:
 	fput(newfile);
-	put_unused_fd(newfd);
-	goto out;
+	return ERR_PTR(err);
+}
+
+int __sys_accept4_file(struct file *file, unsigned file_flags,
+		       struct sockaddr __user *upeer_sockaddr,
+		       int __user *upeer_addrlen, int flags,
+		       unsigned long nofile)
+{
+	struct file *newfile;
+	int newfd;
 
+	if (flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
+		return -EINVAL;
+
+	if (SOCK_NONBLOCK != O_NONBLOCK && (flags & SOCK_NONBLOCK))
+		flags = (flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
+
+	newfd = __get_unused_fd_flags(flags, nofile);
+	if (unlikely(newfd < 0))
+		return newfd;
+
+	newfile = do_accept(file, file_flags, upeer_sockaddr, upeer_addrlen,
+			    flags);
+	if (IS_ERR(newfile)) {
+		put_unused_fd(newfd);
+		return PTR_ERR(newfile);
+	}
+	fd_install(newfd, newfile);
+	return newfd;
 }
 
 /*
-- 
2.32.0

