Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D33DF3F3B44
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 17:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235091AbhHUPy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 11:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232898AbhHUPyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Aug 2021 11:54:05 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AAA3C06175F;
        Sat, 21 Aug 2021 08:53:24 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id n5so6392211wro.12;
        Sat, 21 Aug 2021 08:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RKv2iOkOB2q/Doy6cx3JdFQv2ceaGk66lT97NgE4xbs=;
        b=hGWEuTh2N9U+uOVXt0/h5SU43Y/HWs1t0XL73VOkQi0RN6mDLTYAshQprTveikDOxI
         TIf7tWk1yLJP9TxJCwIfAViLfGg5sd0HhgzD1XB2Ploux4XoY14kFjl0vo26CVulckK1
         GIRxWgmAyd7v2NenIiQV7S7LR8yjHGmDdDVXY+8DYDZ65oON2eVaiN+8DbRFTNE6rVmU
         +BLRhY88EKxdOyZpkZX9IsAvBQ45zWhSkvI3Ex6xNVcWGxeCKL2XZrwZPq9hOflU9tMO
         87v7W63FibuMzlymcmHqti90nsE3BNo04Fta4KqKjMwWjhrClvwYV5C3sfQbwSKfottF
         2h+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RKv2iOkOB2q/Doy6cx3JdFQv2ceaGk66lT97NgE4xbs=;
        b=il7N/5hfM/LxPj+z+slQumU9lhLZXqiAwToTT8Nt/lbOGcCQlhS8WOL17bgcL76PQh
         HNbRGvbl3j7YvkJK9Jhfd2uQT0EIWCp3ja6Vr3gkDEa9uKp22nnF6fs1FcfGgU+z+Lil
         kybCKnA01FustOwkXkyUzZyNBjkEayjaCYhcL2FRLYgzkZ/+oT267QuPU8N0AVvnYSqT
         fM6ktvaqWwuyRHUOxmcq2grfSlHYp8JlUXGuTcXfuTfXzFqm3cMpEAAqm2mvKYumFV3c
         kW8kGKiMHmBkifWzv5UitKKwWNKM6QCBEsRf4TIit5V58ObTJIoPIImoCAHHFwuzqNR2
         60Wg==
X-Gm-Message-State: AOAM531aW5iwdoE2gvczfwABrsvvWVwmit2soePMOxmaP+BBcjFxFTjx
        56NCSnQemi8dNkfGoS8qG4s=
X-Google-Smtp-Source: ABdhPJxd4CQe+K0DFlHZMMRzdTdQhoyeJsujEiYWrjslyK9HhfFryQTZ0qQXaSVnbzGoNla/jjuY/g==
X-Received: by 2002:a5d:658e:: with SMTP id q14mr4524076wru.142.1629561202848;
        Sat, 21 Aug 2021 08:53:22 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.174])
        by smtp.gmail.com with ESMTPSA id e3sm9479554wro.15.2021.08.21.08.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Aug 2021 08:53:22 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v3 4/4] io_uring: accept directly into fixed file table
Date:   Sat, 21 Aug 2021 16:52:40 +0100
Message-Id: <2339d899ba5f56ef1f7480e2a252224f8ad408c8.1629559905.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1629559905.git.asml.silence@gmail.com>
References: <cover.1629559905.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As done with open opcodes, allow accept to skip installing fd into
processes' file tables and put it directly into io_uring's fixed file
table. Same restrictions and design as for open.

Suggested-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a54994a4f4ae..0323e947f403 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4759,10 +4759,11 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_accept *accept = &req->accept;
+	unsigned index;
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->len || sqe->buf_index || sqe->splice_fd_in)
+	if (sqe->ioprio || sqe->len || sqe->buf_index)
 		return -EINVAL;
 
 	accept->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
@@ -4770,6 +4771,17 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	accept->flags = READ_ONCE(sqe->accept_flags);
 	accept->nofile = rlimit(RLIMIT_NOFILE);
 
+	index = READ_ONCE(sqe->file_index);
+	req->buf_index = index;
+	if (index) {
+		if (req->open.how.flags & O_CLOEXEC)
+			return -EINVAL;
+		if (req->buf_index != index)
+			return -EINVAL;
+	}
+
+	if (req->buf_index && (accept->flags & SOCK_CLOEXEC))
+		return -EINVAL;
 	if (accept->flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
 		return -EINVAL;
 	if (SOCK_NONBLOCK != O_NONBLOCK && (accept->flags & SOCK_NONBLOCK))
@@ -4782,28 +4794,34 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_accept *accept = &req->accept;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	unsigned int file_flags = force_nonblock ? O_NONBLOCK : 0;
+	bool fixed = !!req->buf_index;
 	struct file *file;
 	int ret, fd;
 
 	if (req->file->f_flags & O_NONBLOCK)
 		req->flags |= REQ_F_NOWAIT;
 
-	fd = __get_unused_fd_flags(accept->flags, accept->nofile);
-	if (unlikely(fd < 0))
-		return fd;
-
+	if (!fixed) {
+		fd = __get_unused_fd_flags(accept->flags, accept->nofile);
+		if (unlikely(fd < 0))
+			return fd;
+	}
 	file = do_accept(req->file, file_flags, accept->addr, accept->addr_len,
 			 accept->flags);
 	if (IS_ERR(file)) {
+		if (!fixed)
+			put_unused_fd(fd);
 		ret = PTR_ERR(file);
 		if (ret == -EAGAIN && force_nonblock)
 			return -EAGAIN;
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
 		req_set_fail(req);
-	} else {
+	} else if (!fixed) {
 		fd_install(fd, file);
 		ret = fd;
+	} else {
+		ret = io_install_fixed_file(req, file, issue_flags);
 	}
 	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
-- 
2.32.0

