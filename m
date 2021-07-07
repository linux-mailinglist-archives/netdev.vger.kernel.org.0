Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357483BE745
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 13:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbhGGLnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 07:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbhGGLm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 07:42:59 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4871C06175F;
        Wed,  7 Jul 2021 04:40:18 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id v5so2705064wrt.3;
        Wed, 07 Jul 2021 04:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0XH1EdSjH8+xrcSsJr5mTBTHNu8DD3elj9IiyWm0z0g=;
        b=hgpISY9ikcDDBgLeh1cf2deIh3loolobR2tXVVo58JotEnu6BJZ6V3LoX23Y3K8ZHI
         UsU8SPdGpkq1Te8lVJ8O66BtmGmyD8xLJ1nuUqovLb2F3KkhS7Ba27WZNEcM290S6Czg
         SAbuzLeG9VKjLkw5AX0thP3gpGXhbkhK6g5Ii8ihvGgVsTR9CqVXCSoWvOc0Z58RMKrc
         7Fr5PyI6t3I0VnpXmhY73nQ70ae9IYJ4h6d56PxPAv4t1dOqBEkN6SYQAJrAZyGX6eYW
         Ouu/MjvGbqMBHUHG767XZEmBMZP+JTnddlYHG2g26ma6LgbU1ZTot6RNB+l20JFP8nWy
         4/aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0XH1EdSjH8+xrcSsJr5mTBTHNu8DD3elj9IiyWm0z0g=;
        b=P2+CcYWOC8myx+IcspmhB1tEDKq5PGM7S+53rZmfB2L3BXa68JJ1/CqpOwDAQaAmbj
         6ZXJbMKKTQ/4s8R/GwdxKrUjgGDNr4Y26wAxvzr9sz6iPWqWpC3+xHFUmbDryi3+orE4
         fCZcWnDjR7mmq0ZzfvdEmsBLfvuA/kldoHel+KfZEB8LdnAQA84RRyPjeoMd5Gmf+70Y
         nT+fKqyO0kyyubQ1Ser2zF4JfJQOev16kUY5omwxwoH5zKc1ClfX+XZcxyxtGDCruK20
         gsHg1N3ry15gjx9alUjs9RChdqE8e+y7BXLYBO1kMWVd1A50f1YDTTtXvg3SJ/4T2LiE
         c2lg==
X-Gm-Message-State: AOAM530OP2avBhiSmQ1oWyI3iwH+2/uMIi/uAs8K0H5711KQ5YSmzuwD
        ZYVTQ808v2C4dh2k8HU/TnOiPp1DXeSnvw==
X-Google-Smtp-Source: ABdhPJxX+jlq1ncfaF71aGcpH5aAEw3C7jLZvWd7r/5yUmfGWHon/jCBcCnJRrf8aCs6xtcQzL/7jw==
X-Received: by 2002:adf:f946:: with SMTP id q6mr26942940wrr.283.1625658017570;
        Wed, 07 Jul 2021 04:40:17 -0700 (PDT)
Received: from localhost.localdomain ([85.255.234.206])
        by smtp.gmail.com with ESMTPSA id p9sm18415790wmm.17.2021.07.07.04.40.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 04:40:17 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 2/4] net: add an accept helper not installing fd
Date:   Wed,  7 Jul 2021 12:39:44 +0100
Message-Id: <8c0bb671180a8f8375422146eb534bc5ccb2b269.1625657451.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1625657451.git.asml.silence@gmail.com>
References: <cover.1625657451.git.asml.silence@gmail.com>
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
index bd9233da2497..2857206453f9 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1715,32 +1715,22 @@ SYSCALL_DEFINE2(listen, int, fd, int, backlog)
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
@@ -1751,18 +1741,9 @@ int __sys_accept4_file(struct file *file, unsigned file_flags,
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
@@ -1787,16 +1768,38 @@ int __sys_accept4_file(struct file *file, unsigned file_flags,
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

