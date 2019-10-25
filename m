Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9AD3E5256
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 19:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505886AbfJYRbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 13:31:42 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:42868 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2505882AbfJYRav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 13:30:51 -0400
Received: by mail-io1-f65.google.com with SMTP id i26so3293478iog.9
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 10:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wTR5iTu8qxd9g7eLd8K6LBymJYwzVyhOH22aSZJ49ZA=;
        b=w0UwFk56i+jEFwBRCWVBN0+u6HkQbPjq8+/3iG7PpgLFvkZQi/Fa4UJyEJu9VWS24n
         zVzrFkZeyta6ea3T6LEyLJxunNZOf9Aag88JtZ/b7+zFXkr5tPaNOqKDWgPqLx2RClY4
         mOKsw/HcVC8OtUbNpVicpEMK0sTocy0+dy0k+MxIOI0/4Ftinwp32w1961wHy5b0HYhj
         8R82VclIdCCYr5O9X2rZ/dboEKQDobt+3RJp8ZQufT/jttNLOEYHdB2oaXpSw5Lts08O
         Eczb8OpZ8StQsFDBKlohuoOO2JDJfAhF39RnwoCBRTHL9XlfOZ4ZZPx/BCxEucnDFNoj
         S3Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wTR5iTu8qxd9g7eLd8K6LBymJYwzVyhOH22aSZJ49ZA=;
        b=tMqlXTjUd08yQwaVnu5UDAuIWhxOvCG6Ak409sLixh74Enta4VxqeZ0C+2k0Sca9wT
         wRSl0BNlDY5Qlqi404wOPUQeLeOGzXAPEpenDa9xkoQzl2K8xjVfPJ2LcV9mQG18vz5M
         9mNcii7813enhazX8vMAYN2zWrwOSJyitR6u2M383JlJE2DX/oghMY20XdbWn1B4ZJXp
         egmNB5plBO/2PKRu+OFn2FpVk1k5YRf/XWEisa8TxGQAzZ6APQc4hJcQ7TBAGZIVz3U2
         YQgs9xPHsc0oQAckBjjUl9oGzriXfw+xxINyP+qxeJLRS5cXYozBBWoA2eVL7Cigi2Zp
         kKag==
X-Gm-Message-State: APjAAAUWQM/P01JE0eSbjWexGkSffBFuyInqHvR+aG1B/60l5Cym3HN3
        4aXJmxGV+Wfnrv5bkDxQ00PUWQ==
X-Google-Smtp-Source: APXvYqzddTq9xHH/LP/GQgmjueIfFEpwDhlGEjJskjOvwEijfI2Kc5EQbd0qfNFJDzzUpXG59IJOSQ==
X-Received: by 2002:a6b:fa19:: with SMTP id p25mr4747107ioh.125.1572024649744;
        Fri, 25 Oct 2019 10:30:49 -0700 (PDT)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id g23sm323674ioe.73.2019.10.25.10.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 10:30:47 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-block@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jannh@google.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring: add support for IORING_OP_ACCEPT
Date:   Fri, 25 Oct 2019 11:30:37 -0600
Message-Id: <20191025173037.13486-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191025173037.13486-1-axboe@kernel.dk>
References: <20191025173037.13486-1-axboe@kernel.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows an application to call accept4() in an async fashion. Like
other opcodes, we first try a non-blocking accept, then punt to async
context if we have to.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 35 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  7 ++++++-
 2 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5a6f8e1dc718..4402485f0879 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1687,6 +1687,38 @@ static int io_recvmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 #endif
 }
 
+static int io_accept(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+		     struct io_kiocb **nxt, bool force_nonblock)
+{
+#if defined(CONFIG_NET)
+	struct sockaddr __user *addr;
+	int __user *addr_len;
+	unsigned file_flags;
+	int flags, ret;
+
+	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
+		return -EINVAL;
+
+	addr = (struct sockaddr __user *) (unsigned long) READ_ONCE(sqe->addr);
+	addr_len = (int __user *) (unsigned long) READ_ONCE(sqe->addr2);
+	flags = READ_ONCE(sqe->accept_flags);
+	file_flags = force_nonblock ? O_NONBLOCK : 0;
+
+	ret = __sys_accept4_file(req->file, file_flags, addr, addr_len, flags);
+	if (ret == -EAGAIN && force_nonblock) {
+		req->work.flags |= IO_WQ_WORK_NEEDS_FILES;
+		return -EAGAIN;
+	}
+	if (ret < 0 && (req->flags & REQ_F_LINK))
+		req->flags |= REQ_F_FAIL_LINK;
+	io_cqring_add_event(req->ctx, sqe->user_data, ret);
+	io_put_req(req, nxt);
+	return 0;
+#else
+	return -EOPNOTSUPP;
+#endif
+}
+
 static void io_poll_remove_one(struct io_kiocb *req)
 {
 	struct io_poll_iocb *poll = &req->poll;
@@ -2174,6 +2206,9 @@ static int __io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	case IORING_OP_TIMEOUT_REMOVE:
 		ret = io_timeout_remove(req, s->sqe);
 		break;
+	case IORING_OP_ACCEPT:
+		ret = io_accept(req, s->sqe, nxt, force_nonblock);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 6dc5ced1c37a..f82d90e617a6 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -19,7 +19,10 @@ struct io_uring_sqe {
 	__u8	flags;		/* IOSQE_ flags */
 	__u16	ioprio;		/* ioprio for the request */
 	__s32	fd;		/* file descriptor to do IO on */
-	__u64	off;		/* offset into file */
+	union {
+		__u64	off;	/* offset into file */
+		__u64	addr2;
+	};
 	__u64	addr;		/* pointer to buffer or iovecs */
 	__u32	len;		/* buffer size or number of iovecs */
 	union {
@@ -29,6 +32,7 @@ struct io_uring_sqe {
 		__u32		sync_range_flags;
 		__u32		msg_flags;
 		__u32		timeout_flags;
+		__u32		accept_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	union {
@@ -65,6 +69,7 @@ struct io_uring_sqe {
 #define IORING_OP_RECVMSG	10
 #define IORING_OP_TIMEOUT	11
 #define IORING_OP_TIMEOUT_REMOVE	12
+#define IORING_OP_ACCEPT	13
 
 /*
  * sqe->fsync_flags
-- 
2.17.1

