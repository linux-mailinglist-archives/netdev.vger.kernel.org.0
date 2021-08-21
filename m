Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D89B3F3B42
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 17:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234621AbhHUPyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 11:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232716AbhHUPyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Aug 2021 11:54:02 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53483C061757;
        Sat, 21 Aug 2021 08:53:22 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id c129-20020a1c35870000b02902e6b6135279so7900825wma.0;
        Sat, 21 Aug 2021 08:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nGJoaHfhVSZ+JCi269k+ZI1M+4T/MONcq2oDO9wuY24=;
        b=HzudfrGwr/GYlsmgCwb2Njw+SHqpNnWBmeds9bc48oK98z5emcXeDKZtWfGME+Emrw
         5Q9uNVUBRiZ/UibCxFMpiG6vQRqAdrqDEOgedhpN9XopquhJ7lTtfNy0c5p5njaPekPk
         0zYCbE/b3WnBEa/elQObm2Ob98AGPISkGfaWO12/5bW9HdJyZwwW4TXd6GIEpYXelIX/
         AlOZ08WCrthDxfoda2pvriqsnagjzBrAl60QrOkqQpQpliyXfRa2I4oQP4+2IVbd3XKw
         d5IMfatMBug/CjIiZSmY/Bi5dScWoXt0mHfDZYM/2MF4/Ognl5tPbfyIneLQm0Lzk4Da
         I1Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nGJoaHfhVSZ+JCi269k+ZI1M+4T/MONcq2oDO9wuY24=;
        b=RfTE8MO6ilUXyG+cv/vvHVXST9Dyx7CItgk0/kypQc77GL+CbO02hQru7eo1N2mzgR
         00kr4laBNoEw1WRBewszrbw7pq0jTqUpWEH4XT7tB7nIRIRmXmPV3c69wdNajF1ZFBeO
         cgwjwNQRJSpYpNDwy6+AGN+5zvfh/dX/KVXkoCqqo29vl3mmXJVPz54b0Dp9Eqy6oTXG
         f5y65pU9evgQndMQzMYFQxs+UxY/65gnxrZ/3sK+K/T1OSUUeq4mspDWph/UJOMCDZ/m
         M5n/TksYzdWt41pk7tBBJWJ6nBEobEc4V7lJnaRoVyZjAPJjeHr3V7xx+qFy8zOBZAqq
         yCTQ==
X-Gm-Message-State: AOAM533RNNz0U2SmbMix7Vmk8Wzl78o4rNu9YS7QzSoHYJvmL85k4uqi
        IHTneBwKsOQ9aYB0sLdo4sU=
X-Google-Smtp-Source: ABdhPJxBhWaygH+gnsNxHsK5FxlSsZdMYeLbDn5XGvDBovpw75VwSiT9qyyHqruufARZPlY9WYuKRA==
X-Received: by 2002:a05:600c:210d:: with SMTP id u13mr8736217wml.57.1629561200931;
        Sat, 21 Aug 2021 08:53:20 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.174])
        by smtp.gmail.com with ESMTPSA id e3sm9479554wro.15.2021.08.21.08.53.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Aug 2021 08:53:20 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v3 2/4] io_uring: openat directly into fixed fd table
Date:   Sat, 21 Aug 2021 16:52:38 +0100
Message-Id: <fe6429fbbf964463049496a2d24a649d728561a0.1629559905.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1629559905.git.asml.silence@gmail.com>
References: <cover.1629559905.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of opening a file into a process's file table as usual and then
registering the fd within io_uring, some users may want to skip the
first step and place it directly into io_uring's fixed file table.
This patch adds such a capability for IORING_OP_OPENAT and
IORING_OP_OPENAT2.

The behaviour is controlled by setting sqe->file_index, where 0 implies
the old behaviour. If non-zero value is specified, then it will behave
as described and place the file into a fixed file slot
sqe->file_index - 1. A file table should be already created, the slot
should be valid and empty, otherwise the operation will fail.

Keep the error codes consistent with IORING_OP_FILES_UPDATE, ENXIO and
EINVAL on inappropriate fixed tables, and return EBADF on collision with
already registered file.

Note: we can't use IOSQE_FIXED_FILE to switch between modes, because
accept takes a file, and it already uses the flag with a different
meaning.

Suggested-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 82 +++++++++++++++++++++++++++++++----
 include/uapi/linux/io_uring.h |  5 ++-
 2 files changed, 78 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0fb75aa72b69..b8ef5ac1f90d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1063,6 +1063,9 @@ static void io_req_task_queue(struct io_kiocb *req);
 static void io_submit_flush_completions(struct io_ring_ctx *ctx);
 static int io_req_prep_async(struct io_kiocb *req);
 
+static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
+				 unsigned int issue_flags);
+
 static struct kmem_cache *req_cachep;
 
 static const struct file_operations io_uring_fops;
@@ -3815,11 +3818,12 @@ static int io_fallocate(struct io_kiocb *req, unsigned int issue_flags)
 static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	const char __user *fname;
+	unsigned index;
 	int ret;
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (unlikely(sqe->ioprio || sqe->buf_index || sqe->splice_fd_in))
+	if (unlikely(sqe->ioprio || sqe->buf_index))
 		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
@@ -3836,6 +3840,16 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 		req->open.filename = NULL;
 		return ret;
 	}
+
+	index = READ_ONCE(sqe->file_index);
+	req->buf_index = index;
+	if (index) {
+		if (req->open.how.flags & O_CLOEXEC)
+			return -EINVAL;
+		if (req->buf_index != index)
+			return -EINVAL;
+	}
+
 	req->open.nofile = rlimit(RLIMIT_NOFILE);
 	req->flags |= REQ_F_NEED_CLEANUP;
 	return 0;
@@ -3873,8 +3887,8 @@ static int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct open_flags op;
 	struct file *file;
-	bool nonblock_set;
-	bool resolve_nonblock;
+	bool resolve_nonblock, nonblock_set;
+	bool fixed = !!req->buf_index;
 	int ret;
 
 	ret = build_open_flags(&req->open.how, &op);
@@ -3893,9 +3907,11 @@ static int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
 		op.open_flag |= O_NONBLOCK;
 	}
 
-	ret = __get_unused_fd_flags(req->open.how.flags, req->open.nofile);
-	if (ret < 0)
-		goto err;
+	if (!fixed) {
+		ret = __get_unused_fd_flags(req->open.how.flags, req->open.nofile);
+		if (ret < 0)
+			goto err;
+	}
 
 	file = do_filp_open(req->open.dfd, req->open.filename, &op);
 	if (IS_ERR(file)) {
@@ -3904,7 +3920,8 @@ static int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
 		 * marginal gain for something that is now known to be a slower
 		 * path. So just put it, and we'll get a new one when we retry.
 		 */
-		put_unused_fd(ret);
+		if (!fixed)
+			put_unused_fd(ret);
 
 		ret = PTR_ERR(file);
 		/* only retry if RESOLVE_CACHED wasn't already set by application */
@@ -3917,7 +3934,11 @@ static int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
 	if ((issue_flags & IO_URING_F_NONBLOCK) && !nonblock_set)
 		file->f_flags &= ~O_NONBLOCK;
 	fsnotify_open(file);
-	fd_install(ret, file);
+
+	if (!fixed)
+		fd_install(ret, file);
+	else
+		ret = io_install_fixed_file(req, file, issue_flags);
 err:
 	putname(req->open.filename);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
@@ -7846,6 +7867,50 @@ static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
 #endif
 }
 
+static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
+				 unsigned int issue_flags)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	int i = req->buf_index - 1;
+	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
+	struct io_fixed_file *file_slot;
+	int ret = -EBADF;
+
+	if (WARN_ON_ONCE(req->buf_index == 0))
+		goto err;
+
+	io_ring_submit_lock(ctx, !force_nonblock);
+	if (file->f_op == &io_uring_fops)
+		goto err;
+	ret = -ENXIO;
+	if (!ctx->file_data)
+		goto err;
+	ret = -EINVAL;
+	if (i >= ctx->nr_user_files)
+		goto err;
+
+	i = array_index_nospec(i, ctx->nr_user_files);
+	file_slot = io_fixed_file_slot(&ctx->file_table, i);
+	ret = -EBADF;
+	if (file_slot->file_ptr)
+		goto err;
+
+	*io_get_tag_slot(ctx->file_data, i) = 0;
+	io_fixed_file_set(file_slot, file);
+	ret = io_sqe_file_register(ctx, file, i);
+	if (ret) {
+		file_slot->file_ptr = 0;
+		goto err;
+	}
+
+	ret = 0;
+err:
+	io_ring_submit_unlock(ctx, !force_nonblock);
+	if (ret)
+		fput(file);
+	return ret;
+}
+
 static int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
 				 struct io_rsrc_node *node, void *rsrc)
 {
@@ -10311,6 +10376,7 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(40, __u16,  buf_group);
 	BUILD_BUG_SQE_ELEM(42, __u16,  personality);
 	BUILD_BUG_SQE_ELEM(44, __s32,  splice_fd_in);
+	BUILD_BUG_SQE_ELEM(44, __u32,  file_index);
 
 	BUILD_BUG_ON(sizeof(struct io_uring_files_update) !=
 		     sizeof(struct io_uring_rsrc_update));
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 79126d5cd289..45a4f2373694 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -55,7 +55,10 @@ struct io_uring_sqe {
 	} __attribute__((packed));
 	/* personality to use, if used */
 	__u16	personality;
-	__s32	splice_fd_in;
+	union {
+		__s32	splice_fd_in;
+		__u32	file_index;
+	};
 	__u64	__pad2[2];
 };
 
-- 
2.32.0

