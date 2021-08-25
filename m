Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D69A3F744E
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 13:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240493AbhHYL1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 07:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240361AbhHYL1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 07:27:16 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26DF7C061757;
        Wed, 25 Aug 2021 04:26:28 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id d22-20020a1c1d16000000b002e7777970f0so4022447wmd.3;
        Wed, 25 Aug 2021 04:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2vpCWvHyDYTvLG1B0GApP4brIQRde2l3CEnEkrOSsDo=;
        b=dSFz6IwRJAwNIbimQvTEj9Iaiu64VTJSr0/wnntJuse0OpH12yWFgz6o7KADyDEhsO
         kWu+YIzbvFbnLGaZ2qKcqavxHjz3PVfZJn9FlOnDYPTgU+27jN4POSxFPUVSWldhVdvF
         43OEdjnnEtNlnkHNQCiyafIM6yCx63pPek6gHkHWiwyreCcn5joY8FphQjXQFdvb+7Ar
         mW8WYP2vNJBGfKDqvv6b+5hUzvkQN5MqK3cwkLqaztTyzBlGv5H1qGAyeg0nSSUyTttF
         /NoAnJ63yNGZq/Gxf2qY5CCWCLE3An7WkSERMfDrmtBbiLsKKNHpyrCZy41/pJ6+JnRq
         IIfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2vpCWvHyDYTvLG1B0GApP4brIQRde2l3CEnEkrOSsDo=;
        b=lc++U2mjXtk0PuJUyubgtACKzZf6pyHrnqvd3SjDRXpuDMUTtysTVARNfNIK7M7DUp
         QQLTDmr+wWPndxXgbHXVZ+Fwa51OsPaBbt6S3qM7g9jxCXz0K05tffAVj+9FENH4drH7
         xuQXDgkCCSkZAOqGmC2sjFzGcN69Chlsq0U72MJ7E/vNhUu5dkuQzDZc/yptrn2ELEH0
         VyDD9ciqkpO2e+oljyUz6+8b9dGZqE4p8ulXwSJeB62HKKh1Hx+BUQB/4TdFs7S/BfK5
         CzoGQ1RkP4k692S/A9dKvgrclfyYv7sNanekhD7RlYHIS38PLDWynJ5osKdXQ/2PtAdq
         RySw==
X-Gm-Message-State: AOAM533tNwdYueWk3tMn0cPZ9vR+aoeDv4ZJ0yUGX++2gqXPVAQOtmEn
        RQ0BvYcjSJWAAYFvT0shHsorwNbdzHA=
X-Google-Smtp-Source: ABdhPJxJw8laZj1s8hymX8855Xqbep4iYI30HVaaaXTUDCtXvaAi33Is+p8aFcyZG4eo2fQtA7sFcQ==
X-Received: by 2002:a1c:f414:: with SMTP id z20mr8941467wma.94.1629890786701;
        Wed, 25 Aug 2021 04:26:26 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.117])
        by smtp.gmail.com with ESMTPSA id b12sm25113730wrx.72.2021.08.25.04.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 04:26:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v4 2/4] io_uring: openat directly into fixed fd table
Date:   Wed, 25 Aug 2021 12:25:45 +0100
Message-Id: <e9b33d1163286f51ea707f87d95bd596dada1e65.1629888991.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1629888991.git.asml.silence@gmail.com>
References: <cover.1629888991.git.asml.silence@gmail.com>
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
the old behaviour using normal file tables. If non-zero value is
specified, then it will behave as described and place the file into a
fixed file slot sqe->file_index - 1. A file table should be already
created, the slot should be valid and empty, otherwise the operation
will fail.

Keep the error codes consistent with IORING_OP_FILES_UPDATE, ENXIO and
EINVAL on inappropriate fixed tables, and return EBADF on collision with
already registered file.

Note: IOSQE_FIXED_FILE can't be used to switch between modes, because
accept takes a file, and it already uses the flag with a different
meaning.

Suggested-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 74 +++++++++++++++++++++++++++++++----
 include/uapi/linux/io_uring.h |  5 ++-
 2 files changed, 70 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 11462f217aee..2ef81cd6a0ec 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -579,6 +579,7 @@ struct io_sr_msg {
 struct io_open {
 	struct file			*file;
 	int				dfd;
+	u32				file_slot;
 	struct filename			*filename;
 	struct open_how			how;
 	unsigned long			nofile;
@@ -1062,6 +1063,9 @@ static void io_req_task_queue(struct io_kiocb *req);
 static void io_submit_flush_completions(struct io_ring_ctx *ctx);
 static int io_req_prep_async(struct io_kiocb *req);
 
+static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
+				 unsigned int issue_flags, u32 slot_index);
+
 static struct kmem_cache *req_cachep;
 
 static const struct file_operations io_uring_fops;
@@ -3863,7 +3867,7 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (unlikely(sqe->ioprio || sqe->buf_index || sqe->splice_fd_in))
+	if (unlikely(sqe->ioprio || sqe->buf_index))
 		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
@@ -3880,6 +3884,11 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 		req->open.filename = NULL;
 		return ret;
 	}
+
+	req->open.file_slot = READ_ONCE(sqe->file_index);
+	if (req->open.file_slot && (req->open.how.flags & O_CLOEXEC))
+		return -EINVAL;
+
 	req->open.nofile = rlimit(RLIMIT_NOFILE);
 	req->flags |= REQ_F_NEED_CLEANUP;
 	return 0;
@@ -3917,8 +3926,8 @@ static int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct open_flags op;
 	struct file *file;
-	bool nonblock_set;
-	bool resolve_nonblock;
+	bool resolve_nonblock, nonblock_set;
+	bool fixed = !!req->open.file_slot;
 	int ret;
 
 	ret = build_open_flags(&req->open.how, &op);
@@ -3937,9 +3946,11 @@ static int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -3948,7 +3959,8 @@ static int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
 		 * marginal gain for something that is now known to be a slower
 		 * path. So just put it, and we'll get a new one when we retry.
 		 */
-		put_unused_fd(ret);
+		if (!fixed)
+			put_unused_fd(ret);
 
 		ret = PTR_ERR(file);
 		/* only retry if RESOLVE_CACHED wasn't already set by application */
@@ -3961,7 +3973,12 @@ static int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
 	if ((issue_flags & IO_URING_F_NONBLOCK) && !nonblock_set)
 		file->f_flags &= ~O_NONBLOCK;
 	fsnotify_open(file);
-	fd_install(ret, file);
+
+	if (!fixed)
+		fd_install(ret, file);
+	else
+		ret = io_install_fixed_file(req, file, issue_flags,
+					    req->open.file_slot - 1);
 err:
 	putname(req->open.filename);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
@@ -7896,6 +7913,46 @@ static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
 #endif
 }
 
+static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
+				 unsigned int issue_flags, u32 slot_index)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
+	struct io_fixed_file *file_slot;
+	int ret = -EBADF;
+
+	io_ring_submit_lock(ctx, !force_nonblock);
+	if (file->f_op == &io_uring_fops)
+		goto err;
+	ret = -ENXIO;
+	if (!ctx->file_data)
+		goto err;
+	ret = -EINVAL;
+	if (slot_index >= ctx->nr_user_files)
+		goto err;
+
+	slot_index = array_index_nospec(slot_index, ctx->nr_user_files);
+	file_slot = io_fixed_file_slot(&ctx->file_table, slot_index);
+	ret = -EBADF;
+	if (file_slot->file_ptr)
+		goto err;
+
+	*io_get_tag_slot(ctx->file_data, slot_index) = 0;
+	io_fixed_file_set(file_slot, file);
+	ret = io_sqe_file_register(ctx, file, slot_index);
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
@@ -10363,6 +10420,7 @@ static int __init io_uring_init(void)
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

