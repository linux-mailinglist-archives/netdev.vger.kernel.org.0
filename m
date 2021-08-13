Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C69E43EBA47
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 18:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237664AbhHMQoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 12:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236895AbhHMQoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 12:44:21 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA734C061756;
        Fri, 13 Aug 2021 09:43:53 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id f9-20020a05600c1549b029025b0f5d8c6cso10071312wmg.4;
        Fri, 13 Aug 2021 09:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CNqoqrJYYQRcV/CRZqwgpOungHLgzziX626nbxoBaQM=;
        b=pSXtyls3J5jBvGn4dQz98QK2mqVDeqdIJLXPtDa1mqwSit+6R3pChg8YE5IWZCh5QA
         /O5pB1sN6ZJQdEKsPCJPcdCdumGpJ1pi0b8onrOTxzdoBc0GXt9kARKd6KUfRBCJPe1G
         +SFC001kdrWWiDwQqXt1KcTC3yOyij+XNBFK3jJqitaSRhHo+xE66OXSCNrwRzeFzB/9
         dI+qUnvBUVJ4UeG9Lg50eH4dDhmQE3V/EZZheTCxGrnytBh79lWAW9jkkqodcwgfOEHH
         FHF9K/KwnyHB284M3XDSMT/CfaAMLR+9DjnDvN4MHr/+p/y21DphII5LMj364kY0JNud
         sGxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CNqoqrJYYQRcV/CRZqwgpOungHLgzziX626nbxoBaQM=;
        b=Hwu7beqJuYUGsgUuINseGuWKWabLdXSIkB8xfnFaRfBdr2oSSCTaAX26gltxllbMGi
         pDqtNImY3rDNBWYC0LioKKe+qi8b/oDie7ANZjak/pXXgAMEJM7elrL5HLGqhyt1pfvs
         iwMjL/T+SLbjrde8ZHvNtoDv7Mzfdwg/yH7pWd/FCSXYtrTPlSeBcTgH3tvWRJJKbku1
         caEFJkI8W4EWrMtirkXisugpkojjTtnFNwDen6rikaidcd6YkdSpzXcg71K/v1VEKs8W
         O+EPNOscY7RvRVk1VqPMwcLGcCCpcPzvdwDOOLJS/Nj35gAnI0WzsG8ZEcKdg5b05YYv
         STVg==
X-Gm-Message-State: AOAM532sB5m2OaZfsP342e+TFbw8B0DorvlPEZtl+9w7Km1Ms/77YWyy
        0NKnJJooQYFjRBUAEvdA1YM=
X-Google-Smtp-Source: ABdhPJxEKCk04KMoa0igrVrqwQmVAdRXy+TYG0qKKgWtGE57PIq8JmJmIbTRV2ze0jeJxsGceAkBzg==
X-Received: by 2002:a05:600c:19c6:: with SMTP id u6mr3569811wmq.154.1628873032417;
        Fri, 13 Aug 2021 09:43:52 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.210])
        by smtp.gmail.com with ESMTPSA id s10sm2495829wrv.54.2021.08.13.09.43.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 09:43:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v2 2/4] io_uring: openat directly into fixed fd table
Date:   Fri, 13 Aug 2021 17:43:11 +0100
Message-Id: <686a860d973d0b751cf1fa3b1408179b2833720f.1628871893.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628871893.git.asml.silence@gmail.com>
References: <cover.1628871893.git.asml.silence@gmail.com>
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

Note 1: we can't use IOSQE_FIXED_FILE to switch between modes, because
accept takes a file, and it already uses the flag with a different
meaning.

Note 2: it's u16, where in theory the limit for fixed file tables might
get increased in the future. If would ever happen so, we'll better
workaround later, e.g. by making ioprio to represent upper bits 16 bits.
The layout for open is tight already enough.

Suggested-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 76 ++++++++++++++++++++++++++++++-----
 include/uapi/linux/io_uring.h |  2 +
 2 files changed, 69 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 51c4166f68b5..b4f7de5147dc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1060,6 +1060,9 @@ static void io_req_task_queue(struct io_kiocb *req);
 static void io_submit_flush_completions(struct io_ring_ctx *ctx);
 static int io_req_prep_async(struct io_kiocb *req);
 
+static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
+				 unsigned int issue_flags);
+
 static struct kmem_cache *req_cachep;
 
 static const struct file_operations io_uring_fops;
@@ -3803,11 +3806,10 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (unlikely(sqe->ioprio || sqe->buf_index))
+	if (unlikely(sqe->ioprio))
 		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
-
 	/* open.how should be already initialised */
 	if (!(req->open.how.flags & O_PATH) && force_o_largefile())
 		req->open.how.flags |= O_LARGEFILE;
@@ -3820,6 +3822,10 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
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
@@ -3857,8 +3863,8 @@ static int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct open_flags op;
 	struct file *file;
-	bool nonblock_set;
-	bool resolve_nonblock;
+	bool resolve_nonblock, nonblock_set;
+	bool fixed = !!req->buf_index;
 	int ret;
 
 	ret = build_open_flags(&req->open.how, &op);
@@ -3877,9 +3883,11 @@ static int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -3888,7 +3896,8 @@ static int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
 		 * marginal gain for something that is now known to be a slower
 		 * path. So just put it, and we'll get a new one when we retry.
 		 */
-		put_unused_fd(ret);
+		if (!fixed)
+			put_unused_fd(ret);
 
 		ret = PTR_ERR(file);
 		/* only retry if RESOLVE_CACHED wasn't already set by application */
@@ -3901,7 +3910,11 @@ static int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -7835,6 +7848,50 @@ static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
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
@@ -10298,6 +10355,7 @@ static int __init io_uring_init(void)
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

