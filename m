Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F003F744B
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 13:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240382AbhHYL1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 07:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239536AbhHYL1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 07:27:12 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37804C061757;
        Wed, 25 Aug 2021 04:26:27 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id u15so14744936wmj.1;
        Wed, 25 Aug 2021 04:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a1cuoQAJMwM5+2BEvIbHPHMLxmGuXDEYSXOYMtak3NM=;
        b=amabSo8nz0VNvKBf/27D+jsa8dryRGj3pZzzvabxeD59YSM2tjI97/iZXbjVl5oTIt
         0+kf/tVqUcglXmaNg4iQKqdo3C+jWSK2xFteKmWCsAm0+Rhw4w1LD4+a5SdWbAtiy9kp
         N/U5tsPFRoNzQaFPZKMkLTugdOwtRHtcz324WqYQ+3GK8Z6t7FXZecTJtJGhKp5ulnJo
         cPLiGLHkICNdTw3T+qOTFXwAp2+9MxOwlugi3FjOhDbf2/KfVrTPE5dWUImNqIztvu7N
         RdBpe4+Gm0u0bbWYJXbNB+DydvU/kS7v8ExENbyIl+/gzrFw2yd5ZJLTnT3CxAp/msc6
         P7OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a1cuoQAJMwM5+2BEvIbHPHMLxmGuXDEYSXOYMtak3NM=;
        b=YSOLzotUfQNdfZrMjJomgyhDK2IAoai/bDUi3JmmVcORGklle4IFQePIEifj40fKaE
         jh3mdDHBiY+xl/VyWwyA6fCSXOn9OIN7BWRcTAMSqmQyJPqnj1iKU3/l0IGP23XVaE6T
         SoVJ0g7nS+Qbv8fFF//5B5HW2NXw8WzUqinPgF7aKlVqU4gRAlOksMIT1rccAyomxEts
         Y0DcA+0FCj02Kuligc7woMfaA03BLSm9t8NUruHNRq5YAZnA44/yOK4/3VdirZPD0pbY
         zXBpgH4BYx6VpqthC1OIWWTO7h2JyEwllSx311Sbe2pAa2n4FENqVD7oLz+8KZZOjHPT
         5DCg==
X-Gm-Message-State: AOAM532/fohabw1rmkL30Fd+TdZKSoeVOXytGa1TJzQhuAUF28ZRivvK
        QtXiZGhA/JHmp5cu7TwZPY74hHrGi3w=
X-Google-Smtp-Source: ABdhPJwnL64ODXCgxY++i1SIP9VGp1r7N6GtiKb2tQIImcvLSD6syNMZ+9fnUMwmpdtccHgA1Ywvog==
X-Received: by 2002:a1c:f60c:: with SMTP id w12mr8843491wmc.3.1629890785876;
        Wed, 25 Aug 2021 04:26:25 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.117])
        by smtp.gmail.com with ESMTPSA id b12sm25113730wrx.72.2021.08.25.04.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 04:26:25 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v4 1/4] net: add accept helper not installing fd
Date:   Wed, 25 Aug 2021 12:25:44 +0100
Message-Id: <c57b9e8e818d93683a3d24f8ca50ca038d1da8c4.1629888991.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1629888991.git.asml.silence@gmail.com>
References: <cover.1629888991.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce and reuse a helper that acts similarly to __sys_accept4_file()
but returns struct file instead of installing file descriptor. Will be
used by io_uring.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
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

