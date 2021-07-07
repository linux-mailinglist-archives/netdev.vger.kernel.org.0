Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF9CD3BE748
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 13:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbhGGLnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 07:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbhGGLm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 07:42:59 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0232AC061574;
        Wed,  7 Jul 2021 04:40:18 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id t14-20020a05600c198eb029020c8aac53d4so10815637wmq.1;
        Wed, 07 Jul 2021 04:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nUgNmahITe4pb/nCz15r+HpV62R8U3wmAbaVj3QGhAE=;
        b=pbZHcOimUJ/xd4rW0wF9FfJFSvpiZM799wsg2z4+MjbR/uTb/oPC8s51R8orCMvaN0
         M8Hcsh7gKmNAqHUuBtn24+OpBbqSRxNoru1CNhTA9Y+6OZXSvD6sL7HogvM6b5Gi/sdT
         sSAAvxpDcNaiBlUaUiTI5Eo8KQmEQQ9tcJvfaxkK5GRI4iR2a2yIjUothFx/wR73TWm0
         zy1RkRchgo6D4XWlm3uhLlcjIoMTqeQU3ce7InQ3Jp6o7TvpEB4SGucy2OAs6SY+9uf/
         sQZ1fODB2nU2fEPRI3QgaUGnJBhfpRVdukSkD2gnGnNh3BfGqR9gD2hU7QJSTMhiNo/0
         3nZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nUgNmahITe4pb/nCz15r+HpV62R8U3wmAbaVj3QGhAE=;
        b=pOYJaz5doRpee9fU30VeX8n/h812n4+4Mhk50824lqNKpliYl2yDFVW2bZ9UPD1i0C
         X6Gj68UFUVCXfFpUwAcpcc4u6k74vtnevFV3bEp1qjtXj7HV1hPEESyf1/xssIfYuoCx
         oi+LM6GNvcuGUpTL7ZH7EpDc9rTLns+UWVEMo/xi8+Tm2lyKuTfU1AN1jrAt5B20JUKm
         zGa/cfYJSaEw+SFRCc0ug7/V5vSiN7ISiWRvb2sJSK+TN0Pwp4qbDmSsO7jRS5QtxIXu
         YdOMdEFmmoKMqcF4odVnHAlN/S4nUZdOAvbwP++/7N0QuJKNyRuhYWsUZ1UMpDZUaxgG
         oqWg==
X-Gm-Message-State: AOAM532381oQpHROScg5Y2vFpLM2/1wKVrtH3Vq+iMsqtv12o79yxX2Z
        BQpQHQw5K5Gle4M1g+dgDFvmPGJ92m6ffA==
X-Google-Smtp-Source: ABdhPJwHgT+gyl//qD0uuV+t70wrbmfyjgyHtg6PwjXjyw3h7MPu+G3x8N1hBc4vV//figZ/xecyww==
X-Received: by 2002:a7b:cb1a:: with SMTP id u26mr6326052wmj.125.1625658016617;
        Wed, 07 Jul 2021 04:40:16 -0700 (PDT)
Received: from localhost.localdomain ([85.255.234.206])
        by smtp.gmail.com with ESMTPSA id p9sm18415790wmm.17.2021.07.07.04.40.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 04:40:16 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 1/4] io_uring: allow open directly into fixed fd table
Date:   Wed,  7 Jul 2021 12:39:43 +0100
Message-Id: <159bcb182a7a6df58c4de444e511d9ea464048ac.1625657451.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1625657451.git.asml.silence@gmail.com>
References: <cover.1625657451.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of opening a file into a process's file table as usual and then
registering the fd within io_uring, we can skip the first step and place
it directly into io_uring's fixed file table. Add support for that for
both OPENAT opcodes.

The behaviour is controlled by setting sqe->file_index, where 0 implies
the old behaviour, and non-0 values is translated into index
(file_index-1). The field is u16, hence sets a limit on how many slots
it covers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 75 ++++++++++++++++++++++++++++++-----
 include/uapi/linux/io_uring.h |  2 +
 2 files changed, 68 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 599b11152505..17d2c0eb89dc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1075,6 +1075,8 @@ static bool io_poll_remove_waitqs(struct io_kiocb *req);
 static int io_req_prep_async(struct io_kiocb *req);
 
 static void io_fallback_req_func(struct work_struct *unused);
+static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
+				 unsigned int issue_flags);
 
 static struct kmem_cache *req_cachep;
 
@@ -3745,11 +3747,10 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	const char __user *fname;
 	int ret;
 
-	if (unlikely(sqe->ioprio || sqe->buf_index))
+	if (unlikely(sqe->ioprio))
 		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
-
 	/* open.how should be already initialised */
 	if (!(req->open.how.flags & O_PATH) && force_o_largefile())
 		req->open.how.flags |= O_LARGEFILE;
@@ -3762,6 +3763,10 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 		req->open.filename = NULL;
 		return ret;
 	}
+	req->buf_index = READ_ONCE(sqe->file_index);
+	if (req->buf_index && (req->open.how.flags & O_CLOEXEC))
+		return -EINVAL;
+
 	req->open.nofile = rlimit(RLIMIT_NOFILE);
 	req->flags |= REQ_F_NEED_CLEANUP;
 	return 0;
@@ -3804,8 +3809,8 @@ static int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct open_flags op;
 	struct file *file;
-	bool nonblock_set;
-	bool resolve_nonblock;
+	bool resolve_nonblock, nonblock_set;
+	bool fixed = !!req->buf_index;
 	int ret;
 
 	ret = build_open_flags(&req->open.how, &op);
@@ -3824,9 +3829,11 @@ static int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -3835,7 +3842,8 @@ static int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
 		 * marginal gain for something that is now known to be a slower
 		 * path. So just put it, and we'll get a new one when we retry.
 		 */
-		put_unused_fd(ret);
+		if (!fixed)
+			put_unused_fd(ret);
 
 		ret = PTR_ERR(file);
 		/* only retry if RESOLVE_CACHED wasn't already set by application */
@@ -3848,7 +3856,11 @@ static int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -7776,6 +7788,50 @@ static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
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
+	if (i > ctx->nr_user_files)
+		goto err;
+
+	i = array_index_nospec(i, ctx->nr_user_files);
+	file_slot = io_fixed_file_slot(&ctx->file_table, i);
+	ret = -EEXIST;
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
@@ -10231,6 +10287,7 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(32, __u64,  user_data);
 	BUILD_BUG_SQE_ELEM(40, __u16,  buf_index);
 	BUILD_BUG_SQE_ELEM(40, __u16,  buf_group);
+	BUILD_BUG_SQE_ELEM(40, __u16,  file_index);
 	BUILD_BUG_SQE_ELEM(42, __u16,  personality);
 	BUILD_BUG_SQE_ELEM(44, __s32,  splice_fd_in);
 
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 79126d5cd289..f105deb4da1d 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -52,6 +52,8 @@ struct io_uring_sqe {
 		__u16	buf_index;
 		/* for grouped buffer selection */
 		__u16	buf_group;
+		/* index into fixed files */
+		__u16	file_index;
 	} __attribute__((packed));
 	/* personality to use, if used */
 	__u16	personality;
-- 
2.32.0

