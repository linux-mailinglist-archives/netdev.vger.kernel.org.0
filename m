Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D070E10F53E
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 03:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfLCCzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 21:55:01 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46032 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbfLCCzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 21:55:00 -0500
Received: by mail-pf1-f194.google.com with SMTP id 2so1013159pfg.12
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 18:55:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TE6I6G93atKYVf6ZV9OVwH1JZ1SZk7mrg0So4NCD+aI=;
        b=cLd5MskuKqroUsrBy9eja2MEDEnN7EiT4936/12jxsELKaq4pYreM2Xjoe1flfLQWH
         A2K0Qah7ZYy5w8tI6vNu5fCv9zoyg2DTEN+ATjaUo7iCKmDDMtEQ0fr1As4BAKwTwzM+
         ljpszP+5DyOJMzUnYihx9mZXgVk5TR1PvFif2i3isoM2iNBSwTEpzcDSMoNpB5iuoJWA
         z5eTEP/NRvlomOCLbQ7m4l5+ApGfu41Yv+ihy3K6ycgFRLz5M8aLF935qNP/tZwW/7PG
         G9lyIf7Hzh+3VdV2nzpnurM2LFy9sFJg46l2V5OixFM3kvUhIym6ILAYpeexefpNHau5
         aDKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TE6I6G93atKYVf6ZV9OVwH1JZ1SZk7mrg0So4NCD+aI=;
        b=DDrJAhFOxmfYSMzMkq7P/NQVkfUyisc0xNVi5AjcuHKBSbbFpiLt1nOwihHyj1EM8j
         69uDR7lcMWhCB6yGLMi6r9p+QGIjir866rZNDvIEk9kFa0joUim+MtVGhBjB00oNOOxB
         nRoCuVsL5bMiB7OP0Bppf/7Yv+0zMX7vbXGvkEs3dZ5ajoGF26vAtAiLS57pUXDMSPHa
         CUsVTlIvDI7Hhna5o2v3i2hFlyof1E8ytpvlUn0UVfBuy07+OzHu/NuwVyEyKjWHmg3c
         ycXUGrxIyqPkWgKdEmD+vCf5QS998+za4Qe9+tbkxxSV+nQYS0tA2neRcfl175lTijT9
         Qnzw==
X-Gm-Message-State: APjAAAVFLEBCK7+i/35u+bWmskqHdJcXRMuO8vzHdvnIF/NggwFNpL+0
        KYt9lAah9njejxwuEjUIVKZ3vw==
X-Google-Smtp-Source: APXvYqyfyXbRcijZFBa+KEem2BjfnMisTJq5PpH4Z+piPGajMt+y1osQ4DAiyQWDPLneJgyDK56Q0A==
X-Received: by 2002:a65:6081:: with SMTP id t1mr2865427pgu.391.1575341700017;
        Mon, 02 Dec 2019 18:55:00 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id z7sm959364pfk.41.2019.12.02.18.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 18:54:58 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] io_uring: ensure async punted sendmsg/recvmsg requests copy data
Date:   Mon,  2 Dec 2019 19:54:42 -0700
Message-Id: <20191203025444.29344-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203025444.29344-1-axboe@kernel.dk>
References: <20191203025444.29344-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just like commit bd26dacbd5ce for read/write requests, this one ensures
that the msghdr data is fully copied if we need to punt a recvmsg or
sendmsg system call to async context.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c          | 145 +++++++++++++++++++++++++++++++++++------
 include/linux/socket.h |  15 +++--
 net/socket.c           |  60 +++++------------
 3 files changed, 152 insertions(+), 68 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bd8fab9277d6..11d181ed2076 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -308,6 +308,13 @@ struct io_timeout {
 	struct io_timeout_data		*data;
 };
 
+struct io_async_msghdr {
+	struct iovec			fast_iov[UIO_FASTIOV];
+	struct iovec			*iov;
+	struct sockaddr __user		*uaddr;
+	struct msghdr			msg;
+};
+
 struct io_async_rw {
 	struct iovec			fast_iov[UIO_FASTIOV];
 	struct iovec			*iov;
@@ -319,6 +326,7 @@ struct io_async_ctx {
 	struct io_uring_sqe		sqe;
 	union {
 		struct io_async_rw	rw;
+		struct io_async_msghdr	msg;
 	};
 };
 
@@ -1991,12 +1999,21 @@ static int io_sync_file_range(struct io_kiocb *req,
 	return 0;
 }
 
-#if defined(CONFIG_NET)
-static int io_send_recvmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-			   struct io_kiocb **nxt, bool force_nonblock,
-		   long (*fn)(struct socket *, struct user_msghdr __user *,
-				unsigned int))
+static int io_sendmsg_prep(struct io_kiocb *req, struct io_async_ctx *io)
 {
+	const struct io_uring_sqe *sqe = req->sqe;
+	struct user_msghdr __user *msg;
+	unsigned flags;
+
+	flags = READ_ONCE(sqe->msg_flags);
+	msg = (struct user_msghdr __user *)(unsigned long) READ_ONCE(sqe->addr);
+	return sendmsg_copy_msghdr(&io->msg.msg, msg, flags, &io->msg.iov);
+}
+
+static int io_sendmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+		      struct io_kiocb **nxt, bool force_nonblock)
+{
+#if defined(CONFIG_NET)
 	struct socket *sock;
 	int ret;
 
@@ -2005,7 +2022,9 @@ static int io_send_recvmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 	sock = sock_from_file(req->file, &ret);
 	if (sock) {
-		struct user_msghdr __user *msg;
+		struct io_async_ctx io, *copy;
+		struct sockaddr_storage addr;
+		struct msghdr *kmsg;
 		unsigned flags;
 
 		flags = READ_ONCE(sqe->msg_flags);
@@ -2014,41 +2033,119 @@ static int io_send_recvmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		else if (force_nonblock)
 			flags |= MSG_DONTWAIT;
 
-		msg = (struct user_msghdr __user *) (unsigned long)
-			READ_ONCE(sqe->addr);
+		if (req->io) {
+			kmsg = &req->io->msg.msg;
+			kmsg->msg_name = &addr;
+		} else {
+			kmsg = &io.msg.msg;
+			kmsg->msg_name = &addr;
+			io.msg.iov = io.msg.fast_iov;
+			ret = io_sendmsg_prep(req, &io);
+			if (ret)
+				goto out;
+		}
 
-		ret = fn(sock, msg, flags);
-		if (force_nonblock && ret == -EAGAIN)
+		ret = __sys_sendmsg_sock(sock, kmsg, flags);
+		if (force_nonblock && ret == -EAGAIN) {
+			copy = kmalloc(sizeof(*copy), GFP_KERNEL);
+			if (!copy) {
+				ret = -ENOMEM;
+				goto out;
+			}
+			memcpy(&copy->msg, &io.msg, sizeof(copy->msg));
+			req->io = copy;
+			memcpy(&req->io->sqe, req->sqe, sizeof(*req->sqe));
+			req->sqe = &req->io->sqe;
 			return ret;
+		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
 	}
 
+out:
 	io_cqring_add_event(req, ret);
 	if (ret < 0 && (req->flags & REQ_F_LINK))
 		req->flags |= REQ_F_FAIL_LINK;
 	io_put_req_find_next(req, nxt);
 	return 0;
-}
-#endif
-
-static int io_sendmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-		      struct io_kiocb **nxt, bool force_nonblock)
-{
-#if defined(CONFIG_NET)
-	return io_send_recvmsg(req, sqe, nxt, force_nonblock,
-				__sys_sendmsg_sock);
 #else
 	return -EOPNOTSUPP;
 #endif
 }
 
+static int io_recvmsg_prep(struct io_kiocb *req, struct io_async_ctx *io)
+{
+	const struct io_uring_sqe *sqe = req->sqe;
+	struct user_msghdr __user *msg;
+	unsigned flags;
+
+	flags = READ_ONCE(sqe->msg_flags);
+	msg = (struct user_msghdr __user *)(unsigned long) READ_ONCE(sqe->addr);
+	return recvmsg_copy_msghdr(&io->msg.msg, msg, flags, &io->msg.uaddr,
+					&io->msg.iov);
+}
+
 static int io_recvmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		      struct io_kiocb **nxt, bool force_nonblock)
 {
 #if defined(CONFIG_NET)
-	return io_send_recvmsg(req, sqe, nxt, force_nonblock,
-				__sys_recvmsg_sock);
+	struct socket *sock;
+	int ret;
+
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+
+	sock = sock_from_file(req->file, &ret);
+	if (sock) {
+		struct user_msghdr __user *msg;
+		struct io_async_ctx io, *copy;
+		struct sockaddr_storage addr;
+		struct msghdr *kmsg;
+		unsigned flags;
+
+		flags = READ_ONCE(sqe->msg_flags);
+		if (flags & MSG_DONTWAIT)
+			req->flags |= REQ_F_NOWAIT;
+		else if (force_nonblock)
+			flags |= MSG_DONTWAIT;
+
+		msg = (struct user_msghdr __user *) (unsigned long)
+			READ_ONCE(sqe->addr);
+		if (req->io) {
+			kmsg = &req->io->msg.msg;
+			kmsg->msg_name = &addr;
+		} else {
+			kmsg = &io.msg.msg;
+			kmsg->msg_name = &addr;
+			io.msg.iov = io.msg.fast_iov;
+			ret = io_recvmsg_prep(req, &io);
+			if (ret)
+				goto out;
+		}
+
+		ret = __sys_recvmsg_sock(sock, kmsg, msg, io.msg.uaddr, flags);
+		if (force_nonblock && ret == -EAGAIN) {
+			copy = kmalloc(sizeof(*copy), GFP_KERNEL);
+			if (!copy) {
+				ret = -ENOMEM;
+				goto out;
+			}
+			memcpy(copy, &io, sizeof(*copy));
+			req->io = copy;
+			memcpy(&req->io->sqe, req->sqe, sizeof(*req->sqe));
+			req->sqe = &req->io->sqe;
+			return ret;
+		}
+		if (ret == -ERESTARTSYS)
+			ret = -EINTR;
+	}
+
+out:
+	io_cqring_add_event(req, ret);
+	if (ret < 0 && (req->flags & REQ_F_LINK))
+		req->flags |= REQ_F_FAIL_LINK;
+	io_put_req_find_next(req, nxt);
+	return 0;
 #else
 	return -EOPNOTSUPP;
 #endif
@@ -2719,6 +2816,12 @@ static int io_req_defer_prep(struct io_kiocb *req, struct io_async_ctx *io)
 	case IORING_OP_WRITEV:
 		ret = io_write_prep(req, &iovec, &iter, true);
 		break;
+	case IORING_OP_SENDMSG:
+		ret = io_sendmsg_prep(req, io);
+		break;
+	case IORING_OP_RECVMSG:
+		ret = io_recvmsg_prep(req, io);
+		break;
 	default:
 		req->io = io;
 		return 0;
diff --git a/include/linux/socket.h b/include/linux/socket.h
index 4bde63021c09..903507fb901f 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -378,12 +378,19 @@ extern int __sys_recvmmsg(int fd, struct mmsghdr __user *mmsg,
 extern int __sys_sendmmsg(int fd, struct mmsghdr __user *mmsg,
 			  unsigned int vlen, unsigned int flags,
 			  bool forbid_cmsg_compat);
-extern long __sys_sendmsg_sock(struct socket *sock,
-			       struct user_msghdr __user *msg,
+extern long __sys_sendmsg_sock(struct socket *sock, struct msghdr *msg,
 			       unsigned int flags);
-extern long __sys_recvmsg_sock(struct socket *sock,
-			       struct user_msghdr __user *msg,
+extern long __sys_recvmsg_sock(struct socket *sock, struct msghdr *msg,
+			       struct user_msghdr __user *umsg,
+			       struct sockaddr __user *uaddr,
 			       unsigned int flags);
+extern int sendmsg_copy_msghdr(struct msghdr *msg,
+			       struct user_msghdr __user *umsg, unsigned flags,
+			       struct iovec **iov);
+extern int recvmsg_copy_msghdr(struct msghdr *msg,
+			       struct user_msghdr __user *umsg, unsigned flags,
+			       struct sockaddr __user **uaddr,
+			       struct iovec **iov);
 
 /* helpers which do the actual work for syscalls */
 extern int __sys_recvfrom(int fd, void __user *ubuf, size_t size,
diff --git a/net/socket.c b/net/socket.c
index ea28cbb9e2e7..0fb0820edeec 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2346,9 +2346,9 @@ static int ____sys_sendmsg(struct socket *sock, struct msghdr *msg_sys,
 	return err;
 }
 
-static int sendmsg_copy_msghdr(struct msghdr *msg,
-			       struct user_msghdr __user *umsg, unsigned flags,
-			       struct iovec **iov)
+int sendmsg_copy_msghdr(struct msghdr *msg,
+			struct user_msghdr __user *umsg, unsigned flags,
+			struct iovec **iov)
 {
 	int err;
 
@@ -2390,27 +2390,14 @@ static int ___sys_sendmsg(struct socket *sock, struct user_msghdr __user *msg,
 /*
  *	BSD sendmsg interface
  */
-long __sys_sendmsg_sock(struct socket *sock, struct user_msghdr __user *umsg,
+long __sys_sendmsg_sock(struct socket *sock, struct msghdr *msg,
 			unsigned int flags)
 {
-	struct iovec iovstack[UIO_FASTIOV], *iov = iovstack;
-	struct sockaddr_storage address;
-	struct msghdr msg = { .msg_name = &address };
-	ssize_t err;
-
-	err = sendmsg_copy_msghdr(&msg, umsg, flags, &iov);
-	if (err)
-		return err;
 	/* disallow ancillary data requests from this path */
-	if (msg.msg_control || msg.msg_controllen) {
-		err = -EINVAL;
-		goto out;
-	}
+	if (msg->msg_control || msg->msg_controllen)
+		return -EINVAL;
 
-	err = ____sys_sendmsg(sock, &msg, flags, NULL, 0);
-out:
-	kfree(iov);
-	return err;
+	return ____sys_sendmsg(sock, msg, flags, NULL, 0);
 }
 
 long __sys_sendmsg(int fd, struct user_msghdr __user *msg, unsigned int flags,
@@ -2516,10 +2503,10 @@ SYSCALL_DEFINE4(sendmmsg, int, fd, struct mmsghdr __user *, mmsg,
 	return __sys_sendmmsg(fd, mmsg, vlen, flags, true);
 }
 
-static int recvmsg_copy_msghdr(struct msghdr *msg,
-			       struct user_msghdr __user *umsg, unsigned flags,
-			       struct sockaddr __user **uaddr,
-			       struct iovec **iov)
+int recvmsg_copy_msghdr(struct msghdr *msg,
+			struct user_msghdr __user *umsg, unsigned flags,
+			struct sockaddr __user **uaddr,
+			struct iovec **iov)
 {
 	ssize_t err;
 
@@ -2609,28 +2596,15 @@ static int ___sys_recvmsg(struct socket *sock, struct user_msghdr __user *msg,
  *	BSD recvmsg interface
  */
 
-long __sys_recvmsg_sock(struct socket *sock, struct user_msghdr __user *umsg,
-			unsigned int flags)
+long __sys_recvmsg_sock(struct socket *sock, struct msghdr *msg,
+			struct user_msghdr __user *umsg,
+			struct sockaddr __user *uaddr, unsigned int flags)
 {
-	struct iovec iovstack[UIO_FASTIOV], *iov = iovstack;
-	struct sockaddr_storage address;
-	struct msghdr msg = { .msg_name = &address };
-	struct sockaddr __user *uaddr;
-	ssize_t err;
-
-	err = recvmsg_copy_msghdr(&msg, umsg, flags, &uaddr, &iov);
-	if (err)
-		return err;
 	/* disallow ancillary data requests from this path */
-	if (msg.msg_control || msg.msg_controllen) {
-		err = -EINVAL;
-		goto out;
-	}
+	if (msg->msg_control || msg->msg_controllen)
+		return -EINVAL;
 
-	err = ____sys_recvmsg(sock, &msg, umsg, uaddr, flags, 0);
-out:
-	kfree(iov);
-	return err;
+	return ____sys_recvmsg(sock, msg, umsg, uaddr, flags, 0);
 }
 
 long __sys_recvmsg(int fd, struct user_msghdr __user *msg, unsigned int flags,
-- 
2.24.0

