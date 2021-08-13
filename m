Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7F563EBA44
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 18:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236852AbhHMQoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 12:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236473AbhHMQoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 12:44:19 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E09C061756;
        Fri, 13 Aug 2021 09:43:52 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id x10so7802894wrt.8;
        Fri, 13 Aug 2021 09:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EaXGPCv4rG5J1NZC9xHyYL1z2IpeWIiNJsgYxDUUWOE=;
        b=gUnpy4Fd0r0qeQY0j9DV0aCJZjgEiE+I07XDM3P1LbQZ0evIDxiLp7lTovIDXUMVtF
         Zooe9e6zZ332888X6hRTKZBMFygxC0osuQd1iQcAsdoSNNS7tvPgl3GdR9FH50Nqo2MB
         g1bwdRxZsJBCklFtwYOYxN0dsSgZzi9i3LtuNwkgrjtL9jx8ol0iSdnGIhSaM1o5yl0i
         +5AKUsDelEySMuzJVcPrvHrpF9WYxoW480D7r/z6uPTeE6YYeC49cnNBOiFzfqusDvx/
         vNDy//lKZDS+gv9omrS7fZK6W7CUCVs1g5NQoOzUTpMTdsjXeiOrQ/4+8Xoofu/Is5Wg
         U8Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EaXGPCv4rG5J1NZC9xHyYL1z2IpeWIiNJsgYxDUUWOE=;
        b=qmVwgmJsyemF+Wn1nu/IzIeh6ZZ5VBAwcE5b2d5YN8yNvU4qUkEOdrZiLH6P8aw9r3
         DagnXOP3NVZTLdKgR4zKHc4B25kUSwSPjxQ3XJav+/YD7IioIEKcGMfgjQCkVbw0hL3a
         hZUZM58UeRqYmkT0D4kCE99oPbvoXZaz23gckvGHqqqMnEnK6q2lZA8DZupCAel+Iy8s
         lXB8IScDmGGgzoGz9B7/uTOL1y51C1HnjdMY8YbfqmkWGL4x1tCRLmBck5H6pA25G1FO
         kiDOvg3XB/9b02QSQ7RE52jf62OzJjoQa0TF0/xmfUIF3J+DSE6+gj9SEaZ8QE407+Ch
         0JSQ==
X-Gm-Message-State: AOAM530jZLOmo5INpDDspx1HGZN+LVvL7f8yvP5EKqPWarludkGTrcq5
        Wr+p2cuD3fzYtD5fl8Dz98g=
X-Google-Smtp-Source: ABdhPJz5tfnJNxOqwfFnaBDDBPs//t7Rss7F1h35igdy1t0QCvEF1HseGfyDmrdA3pBdzeVoJCgtcA==
X-Received: by 2002:a05:6000:1a86:: with SMTP id f6mr4276552wry.345.1628873031039;
        Fri, 13 Aug 2021 09:43:51 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.210])
        by smtp.gmail.com with ESMTPSA id s10sm2495829wrv.54.2021.08.13.09.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 09:43:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v2 1/4] net: add accept helper not installing fd
Date:   Fri, 13 Aug 2021 17:43:10 +0100
Message-Id: <2fa1157f9fa4ed89ebe673a9dfed81385ba63811.1628871893.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628871893.git.asml.silence@gmail.com>
References: <cover.1628871893.git.asml.silence@gmail.com>
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

