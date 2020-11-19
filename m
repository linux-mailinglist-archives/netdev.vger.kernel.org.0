Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A86F2B97DE
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 17:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728824AbgKSQ1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 11:27:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbgKSQ1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 11:27:33 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A5FC0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 08:27:33 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id m6so7053407wrg.7
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 08:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IioeS9Dg9AkawJC0rA82bgYAMNg3xp44Pj00qEh6sh0=;
        b=art9hBd5P5j/+kj2P0wYHIZjL6yunREWPR+kjYldAXaIYpQDQIDE6+hbt9sz5fQl1b
         6n5/y6CAppjkpeomOnpoztMCbW/12R5Vl5klCknADcQrLXomSUEyO4tKjWdqw6g8yxJm
         eTyVOHOaKFslVAWrXAy7iR9M7XZzCHQ+lSLY4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IioeS9Dg9AkawJC0rA82bgYAMNg3xp44Pj00qEh6sh0=;
        b=jwnpUSdZdtCCTofXGSMXFqX9Ed4as2f4/ranUdnGW+1VToqptk2b16An7B8wczfpbw
         YneKBV5ren5Zd2Qavhe9TdHbEQUcA75J2+N3hmf12uThudyHnfxqNpumfjoHPjGKrv71
         gH5tAZaak1JrnKk3wPSud04UnwwJ/kzZUfYgDhh7QMg0ubY0ILLp2RbQYlbkHxRdMXa/
         3bwCa/yDTX4oU31Z34wR1E+eY5LX2N/SbZgHBQwsKDKc4yaxevYsMbj5m9wgt27WXa0h
         O6jCltsGwNK55GBAy7S+NPEfWBmqGsbmroJ5Py/wKmOZYqw5c8RfHF9056Jce67JtTPc
         dmrQ==
X-Gm-Message-State: AOAM533N9mJai/QwjLuUERc8OhAGDO24FGQjMk2GSVW4lMrHsTGnVkZE
        9EtLXgYb0nonGPjRxhXjsrza1A==
X-Google-Smtp-Source: ABdhPJxK7kKv1EW1z/PdDbWzwBgQkw86caAXfKxPThm4XVwabqrtLp3LqHZNmdddOkTyzAgbPYHonA==
X-Received: by 2002:adf:9104:: with SMTP id j4mr11959123wrj.198.1605803251881;
        Thu, 19 Nov 2020 08:27:31 -0800 (PST)
Received: from revest.zrh.corp.google.com ([2a00:79e0:42:204:f693:9fff:fef4:a569])
        by smtp.gmail.com with ESMTPSA id i5sm380061wrw.45.2020.11.19.08.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 08:27:31 -0800 (PST)
From:   Florent Revest <revest@chromium.org>
To:     bpf@vger.kernel.org
Cc:     viro@zeniv.linux.org.uk, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com, yhs@fb.com,
        andrii@kernel.org, kpsingh@chromium.org, revest@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 1/5] net: Remove the err argument from sock_from_file
Date:   Thu, 19 Nov 2020 17:26:50 +0100
Message-Id: <20201119162654.2410685-1-revest@chromium.org>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florent Revest <revest@google.com>

Currently, the sock_from_file prototype takes an "err" pointer that is
either not set or set to -ENOTSOCK IFF the returned socket is NULL. This
makes the error redundant and it is ignored by a few callers.

This patch simplifies the API by letting callers deduce the error based
on whether the returned socket is NULL or not.

Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Florent Revest <revest@google.com>
---
 fs/eventpoll.c               |  3 +--
 fs/io_uring.c                | 16 ++++++++--------
 include/linux/net.h          |  2 +-
 net/core/netclassid_cgroup.c |  3 +--
 net/core/netprio_cgroup.c    |  3 +--
 net/core/sock.c              |  8 +-------
 net/socket.c                 | 27 ++++++++++++++++-----------
 7 files changed, 29 insertions(+), 33 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 4df61129566d..c764d8d5a76a 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -415,12 +415,11 @@ static inline void ep_set_busy_poll_napi_id(struct epitem *epi)
 	unsigned int napi_id;
 	struct socket *sock;
 	struct sock *sk;
-	int err;
 
 	if (!net_busy_loop_on())
 		return;
 
-	sock = sock_from_file(epi->ffd.file, &err);
+	sock = sock_from_file(epi->ffd.file);
 	if (!sock)
 		return;
 
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8018c7076b25..ace99b15cbd3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4341,9 +4341,9 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
 	unsigned flags;
 	int ret;
 
-	sock = sock_from_file(req->file, &ret);
+	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
-		return ret;
+		return -ENOTSOCK;
 
 	if (req->async_data) {
 		kmsg = req->async_data;
@@ -4390,9 +4390,9 @@ static int io_send(struct io_kiocb *req, bool force_nonblock,
 	unsigned flags;
 	int ret;
 
-	sock = sock_from_file(req->file, &ret);
+	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
-		return ret;
+		return -ENOTSOCK;
 
 	ret = import_single_range(WRITE, sr->buf, sr->len, &iov, &msg.msg_iter);
 	if (unlikely(ret))
@@ -4569,9 +4569,9 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 	unsigned flags;
 	int ret, cflags = 0;
 
-	sock = sock_from_file(req->file, &ret);
+	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
-		return ret;
+		return -ENOTSOCK;
 
 	if (req->async_data) {
 		kmsg = req->async_data;
@@ -4632,9 +4632,9 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock,
 	unsigned flags;
 	int ret, cflags = 0;
 
-	sock = sock_from_file(req->file, &ret);
+	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
-		return ret;
+		return -ENOTSOCK;
 
 	if (req->flags & REQ_F_BUFFER_SELECT) {
 		kbuf = io_recv_buffer_select(req, !force_nonblock);
diff --git a/include/linux/net.h b/include/linux/net.h
index 0dcd51feef02..9e2324efc26a 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -240,7 +240,7 @@ int sock_sendmsg(struct socket *sock, struct msghdr *msg);
 int sock_recvmsg(struct socket *sock, struct msghdr *msg, int flags);
 struct file *sock_alloc_file(struct socket *sock, int flags, const char *dname);
 struct socket *sockfd_lookup(int fd, int *err);
-struct socket *sock_from_file(struct file *file, int *err);
+struct socket *sock_from_file(struct file *file);
 #define		     sockfd_put(sock) fput(sock->file)
 int net_ratelimit(void);
 
diff --git a/net/core/netclassid_cgroup.c b/net/core/netclassid_cgroup.c
index 41b24cd31562..b49c57d35a88 100644
--- a/net/core/netclassid_cgroup.c
+++ b/net/core/netclassid_cgroup.c
@@ -68,9 +68,8 @@ struct update_classid_context {
 
 static int update_classid_sock(const void *v, struct file *file, unsigned n)
 {
-	int err;
 	struct update_classid_context *ctx = (void *)v;
-	struct socket *sock = sock_from_file(file, &err);
+	struct socket *sock = sock_from_file(file);
 
 	if (sock) {
 		spin_lock(&cgroup_sk_update_lock);
diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
index 9bd4cab7d510..99a431c56f23 100644
--- a/net/core/netprio_cgroup.c
+++ b/net/core/netprio_cgroup.c
@@ -220,8 +220,7 @@ static ssize_t write_priomap(struct kernfs_open_file *of,
 
 static int update_netprio(const void *v, struct file *file, unsigned n)
 {
-	int err;
-	struct socket *sock = sock_from_file(file, &err);
+	struct socket *sock = sock_from_file(file);
 	if (sock) {
 		spin_lock(&cgroup_sk_update_lock);
 		sock_cgroup_set_prioidx(&sock->sk->sk_cgrp_data,
diff --git a/net/core/sock.c b/net/core/sock.c
index 727ea1cc633c..dd0598d831ef 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2808,14 +2808,8 @@ EXPORT_SYMBOL(sock_no_mmap);
 void __receive_sock(struct file *file)
 {
 	struct socket *sock;
-	int error;
 
-	/*
-	 * The resulting value of "error" is ignored here since we only
-	 * need to take action when the file is a socket and testing
-	 * "sock" for NULL is sufficient.
-	 */
-	sock = sock_from_file(file, &error);
+	sock = sock_from_file(file);
 	if (sock) {
 		sock_update_netprioidx(&sock->sk->sk_cgrp_data);
 		sock_update_classid(&sock->sk->sk_cgrp_data);
diff --git a/net/socket.c b/net/socket.c
index 6e6cccc2104f..c799d9652a2c 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -445,17 +445,15 @@ static int sock_map_fd(struct socket *sock, int flags)
 /**
  *	sock_from_file - Return the &socket bounded to @file.
  *	@file: file
- *	@err: pointer to an error code return
  *
- *	On failure returns %NULL and assigns -ENOTSOCK to @err.
+ *	On failure returns %NULL.
  */
 
-struct socket *sock_from_file(struct file *file, int *err)
+struct socket *sock_from_file(struct file *file)
 {
 	if (file->f_op == &socket_file_ops)
 		return file->private_data;	/* set in sock_map_fd */
 
-	*err = -ENOTSOCK;
 	return NULL;
 }
 EXPORT_SYMBOL(sock_from_file);
@@ -484,9 +482,11 @@ struct socket *sockfd_lookup(int fd, int *err)
 		return NULL;
 	}
 
-	sock = sock_from_file(file, err);
-	if (!sock)
+	sock = sock_from_file(file);
+	if (!sock) {
+		*err = -ENOTSOCK;
 		fput(file);
+	}
 	return sock;
 }
 EXPORT_SYMBOL(sockfd_lookup);
@@ -498,11 +498,12 @@ static struct socket *sockfd_lookup_light(int fd, int *err, int *fput_needed)
 
 	*err = -EBADF;
 	if (f.file) {
-		sock = sock_from_file(f.file, err);
+		sock = sock_from_file(f.file);
 		if (likely(sock)) {
 			*fput_needed = f.flags & FDPUT_FPUT;
 			return sock;
 		}
+		*err = -ENOTSOCK;
 		fdput(f);
 	}
 	return NULL;
@@ -1715,9 +1716,11 @@ int __sys_accept4_file(struct file *file, unsigned file_flags,
 	if (SOCK_NONBLOCK != O_NONBLOCK && (flags & SOCK_NONBLOCK))
 		flags = (flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
 
-	sock = sock_from_file(file, &err);
-	if (!sock)
+	sock = sock_from_file(file);
+	if (!sock) {
+		err = -ENOTSOCK;
 		goto out;
+	}
 
 	err = -ENFILE;
 	newsock = sock_alloc();
@@ -1840,9 +1843,11 @@ int __sys_connect_file(struct file *file, struct sockaddr_storage *address,
 	struct socket *sock;
 	int err;
 
-	sock = sock_from_file(file, &err);
-	if (!sock)
+	sock = sock_from_file(file);
+	if (!sock) {
+		err = -ENOTSOCK;
 		goto out;
+	}
 
 	err =
 	    security_socket_connect(sock, (struct sockaddr *)address, addrlen);
-- 
2.29.2.299.gdc1121823c-goog

