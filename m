Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF536E5254
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 19:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505895AbfJYRbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 13:31:42 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:38365 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502829AbfJYRar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 13:30:47 -0400
Received: by mail-il1-f194.google.com with SMTP id y5so2526429ilb.5
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 10:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=X1tFIQN8hluXSAcqstDDG+VfYhLOozrIYHLT8zb816k=;
        b=By5ztQT2DfEBZqFtiPHkmtZ4atGNrkbrt1N6371R9MFytbjn9tfjsMjYAViB01DZnT
         Sdbk+2RIvqg/RJwUtyGVh0MDRFM54swCWhU2+CUczRRQVPqaFaTKOzPS7eCVe5SKIPX5
         3FbnsFP+xwQcqEHf11G8RbgluF0nSPq30/UasF+1pIUBMGG/as3iVKsUlZIpolsQ34g0
         GTeo8zbWcJ4ME29jSRBjpLkN1xyp5B8K2hrZ3CXfhE1HSZTMnzXdvqHVVAhBhQrlDjwt
         8T1Q0rhlDkUpWREdHY1SanKlpTelXSlT85SglUjw1LTVuGI1hkLKaJLcSdhv19Niyye4
         gcQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=X1tFIQN8hluXSAcqstDDG+VfYhLOozrIYHLT8zb816k=;
        b=W3syVq4yRWa87dwEP4YTEhy8z3+81gYjy5BB1obhL5mknDxTaIcfiAUHZtkozvpouM
         OMRCkz3UrJlpvBXtRVR2mf6OLCillChLPJtUSWvtXrH+Mabw7SKLH2MSz6fP5x8UVcEe
         bJO+ygoN/WB8V4R4GsxhJdstqcXvqr2S3mRfTV11bg2Ib5VCRbpiP6H7TkjOZSiNel2r
         L63octDJ87PlUS7Hsaz7M7tbq/4W8+rc/gkJJCqsbeuJHZK1nO7wEsuV9OQCqLoPg5LJ
         9iRg5XzkUBBTVg8U3ogJHPWmfNzF1vjPuXgzKRDTALHW1i2M4ZnxwR6AaQlGei5LyQ6V
         7Bew==
X-Gm-Message-State: APjAAAW3+dsNYRcAuP92UZ3nv5MnYlpUHwPGeB5ipaxd4dAJBxCEdLqJ
        JTv5+HHmyHaq4tuI31SmV4eUxw==
X-Google-Smtp-Source: APXvYqx8M6MKAd6TVEy4vcslE5xwt22GQcYvdBqfMwXsl43h2psuSIus9pfA66/b8AxrWv1ocCsBFQ==
X-Received: by 2002:a92:1b49:: with SMTP id b70mr4263418ilb.180.1572024644907;
        Fri, 25 Oct 2019 10:30:44 -0700 (PDT)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id g23sm323674ioe.73.2019.10.25.10.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 10:30:44 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-block@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jannh@google.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io_uring: io_uring: add support for async work inheriting files
Date:   Fri, 25 Oct 2019 11:30:35 -0600
Message-Id: <20191025173037.13486-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191025173037.13486-1-axboe@kernel.dk>
References: <20191025173037.13486-1-axboe@kernel.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is in preparation for adding opcodes that need to add new files
in a process file table, system calls like open(2) or accept4(2).

If an opcode needs this, it must set IO_WQ_WORK_NEEDS_FILES in the work
item. If work that needs to get punted to async context have this
set, the async worker will assume the original task file table before
executing the work.

Note that opcodes that need access to the current files of an
application cannot be done through IORING_SETUP_SQPOLL.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c    |  14 ++++++
 fs/io-wq.h    |   3 ++
 fs/io_uring.c | 116 ++++++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 129 insertions(+), 4 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 99ac5e338d99..134c4632c0be 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -52,6 +52,7 @@ struct io_worker {
 
 	struct rcu_head rcu;
 	struct mm_struct *mm;
+	struct files_struct *restore_files;
 };
 
 struct io_wq_nulls_list {
@@ -128,6 +129,12 @@ static bool __io_worker_unuse(struct io_wqe *wqe, struct io_worker *worker)
 	__must_hold(wqe->lock)
 	__releases(wqe->lock)
 {
+	if (current->files != worker->restore_files) {
+		task_lock(current);
+		current->files = worker->restore_files;
+		task_unlock(current);
+	}
+
 	/*
 	 * If we have an active mm, we need to drop the wq lock before unusing
 	 * it. If we do, return true and let the caller retry the idle loop.
@@ -188,6 +195,7 @@ static void io_worker_start(struct io_wqe *wqe, struct io_worker *worker)
 	current->flags |= PF_IO_WORKER;
 
 	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
+	worker->restore_files = current->files;
 	atomic_inc(&wqe->nr_running);
 }
 
@@ -278,6 +286,12 @@ static void io_worker_handle_work(struct io_worker *worker)
 		if (!work)
 			break;
 next:
+		if ((work->flags & IO_WQ_WORK_NEEDS_FILES) &&
+		    current->files != work->files) {
+			task_lock(current);
+			current->files = work->files;
+			task_unlock(current);
+		}
 		if ((work->flags & IO_WQ_WORK_NEEDS_USER) && !worker->mm &&
 		    wq->mm && mmget_not_zero(wq->mm)) {
 			use_mm(wq->mm);
diff --git a/fs/io-wq.h b/fs/io-wq.h
index be8f22c8937b..e93f764b1fa4 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -8,6 +8,7 @@ enum {
 	IO_WQ_WORK_HAS_MM	= 2,
 	IO_WQ_WORK_HASHED	= 4,
 	IO_WQ_WORK_NEEDS_USER	= 8,
+	IO_WQ_WORK_NEEDS_FILES	= 16,
 
 	IO_WQ_HASH_SHIFT	= 24,	/* upper 8 bits are used for hash key */
 };
@@ -22,12 +23,14 @@ struct io_wq_work {
 	struct list_head list;
 	void (*func)(struct io_wq_work **);
 	unsigned flags;
+	struct files_struct *files;
 };
 
 #define INIT_IO_WORK(work, _func)			\
 	do {						\
 		(work)->func = _func;			\
 		(work)->flags = 0;			\
+		(work)->files = NULL;			\
 	} while (0)					\
 
 struct io_wq *io_wq_create(unsigned concurrency, struct mm_struct *mm);
diff --git a/fs/io_uring.c b/fs/io_uring.c
index effa385ebe72..5a6f8e1dc718 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -196,6 +196,8 @@ struct io_ring_ctx {
 
 		struct list_head	defer_list;
 		struct list_head	timeout_list;
+
+		wait_queue_head_t	inflight_wait;
 	} ____cacheline_aligned_in_smp;
 
 	/* IO offload */
@@ -250,6 +252,9 @@ struct io_ring_ctx {
 		 */
 		struct list_head	poll_list;
 		struct list_head	cancel_list;
+
+		spinlock_t		inflight_lock;
+		struct list_head	inflight_list;
 	} ____cacheline_aligned_in_smp;
 
 #if defined(CONFIG_UNIX)
@@ -259,11 +264,13 @@ struct io_ring_ctx {
 
 struct sqe_submit {
 	const struct io_uring_sqe	*sqe;
+	struct file			*ring_file;
 	unsigned short			index;
 	bool				has_user : 1;
 	bool				in_async : 1;
 	bool				needs_fixed_file : 1;
 	u32				sequence;
+	int				ring_fd;
 };
 
 /*
@@ -318,10 +325,13 @@ struct io_kiocb {
 #define REQ_F_TIMEOUT		1024	/* timeout request */
 #define REQ_F_ISREG		2048	/* regular file */
 #define REQ_F_MUST_PUNT		4096	/* must be punted even for NONBLOCK */
+#define REQ_F_INFLIGHT		8192	/* on inflight list */
 	u64			user_data;
 	u32			result;
 	u32			sequence;
 
+	struct list_head	inflight_entry;
+
 	struct io_wq_work	work;
 };
 
@@ -402,6 +412,9 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->cancel_list);
 	INIT_LIST_HEAD(&ctx->defer_list);
 	INIT_LIST_HEAD(&ctx->timeout_list);
+	init_waitqueue_head(&ctx->inflight_wait);
+	spin_lock_init(&ctx->inflight_lock);
+	INIT_LIST_HEAD(&ctx->inflight_list);
 	return ctx;
 }
 
@@ -671,9 +684,20 @@ static void io_free_req_many(struct io_ring_ctx *ctx, void **reqs, int *nr)
 
 static void __io_free_req(struct io_kiocb *req)
 {
+	struct io_ring_ctx *ctx = req->ctx;
+
 	if (req->file && !(req->flags & REQ_F_FIXED_FILE))
 		fput(req->file);
-	percpu_ref_put(&req->ctx->refs);
+	if (req->flags & REQ_F_INFLIGHT) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&ctx->inflight_lock, flags);
+		list_del(&req->inflight_entry);
+		if (waitqueue_active(&ctx->inflight_wait))
+			wake_up(&ctx->inflight_wait);
+		spin_unlock_irqrestore(&ctx->inflight_lock, flags);
+	}
+	percpu_ref_put(&ctx->refs);
 	kmem_cache_free(req_cachep, req);
 }
 
@@ -2277,6 +2301,30 @@ static int io_req_set_file(struct io_ring_ctx *ctx, const struct sqe_submit *s,
 	return 0;
 }
 
+static int io_grab_files(struct io_ring_ctx *ctx, struct io_kiocb *req)
+{
+	int ret = -EBADF;
+
+	rcu_read_lock();
+	spin_lock_irq(&ctx->inflight_lock);
+	/*
+	 * We use the f_ops->flush() handler to ensure that we can flush
+	 * out work accessing these files if the fd is closed. Check if
+	 * the fd has changed since we started down this path, and disallow
+	 * this operation if it has.
+	 */
+	if (fcheck(req->submit.ring_fd) == req->submit.ring_file) {
+		list_add(&req->inflight_entry, &ctx->inflight_list);
+		req->flags |= REQ_F_INFLIGHT;
+		req->work.files = current->files;
+		ret = 0;
+	}
+	spin_unlock_irq(&ctx->inflight_lock);
+	rcu_read_unlock();
+
+	return ret;
+}
+
 static int __io_queue_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			struct sqe_submit *s)
 {
@@ -2296,17 +2344,25 @@ static int __io_queue_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		if (sqe_copy) {
 			s->sqe = sqe_copy;
 			memcpy(&req->submit, s, sizeof(*s));
-			io_queue_async_work(ctx, req);
+			if (req->work.flags & IO_WQ_WORK_NEEDS_FILES) {
+				ret = io_grab_files(ctx, req);
+				if (ret) {
+					kfree(sqe_copy);
+					goto err;
+				}
+			}
 
 			/*
 			 * Queued up for async execution, worker will release
 			 * submit reference when the iocb is actually submitted.
 			 */
+			io_queue_async_work(ctx, req);
 			return 0;
 		}
 	}
 
 	/* drop submission reference */
+err:
 	io_put_req(req, NULL);
 
 	/* and drop final reference, if we failed */
@@ -2509,6 +2565,7 @@ static bool io_get_sqring(struct io_ring_ctx *ctx, struct sqe_submit *s)
 
 	head = READ_ONCE(sq_array[head & ctx->sq_mask]);
 	if (head < ctx->sq_entries) {
+		s->ring_file = NULL;
 		s->index = head;
 		s->sqe = &ctx->sq_sqes[head];
 		s->sequence = ctx->cached_sq_head;
@@ -2716,7 +2773,8 @@ static int io_sq_thread(void *data)
 	return 0;
 }
 
-static int io_ring_submit(struct io_ring_ctx *ctx, unsigned int to_submit)
+static int io_ring_submit(struct io_ring_ctx *ctx, unsigned int to_submit,
+			  struct file *ring_file, int ring_fd)
 {
 	struct io_submit_state state, *statep = NULL;
 	struct io_kiocb *link = NULL;
@@ -2758,9 +2816,11 @@ static int io_ring_submit(struct io_ring_ctx *ctx, unsigned int to_submit)
 		}
 
 out:
+		s.ring_file = ring_file;
 		s.has_user = true;
 		s.in_async = false;
 		s.needs_fixed_file = false;
+		s.ring_fd = ring_fd;
 		submit++;
 		trace_io_uring_submit_sqe(ctx, true, false);
 		io_submit_sqe(ctx, &s, statep, &link);
@@ -3722,6 +3782,53 @@ static int io_uring_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static void io_uring_cancel_files(struct io_ring_ctx *ctx,
+				  struct files_struct *files)
+{
+	struct io_kiocb *req;
+	DEFINE_WAIT(wait);
+
+	while (!list_empty_careful(&ctx->inflight_list)) {
+		enum io_wq_cancel ret = IO_WQ_CANCEL_NOTFOUND;
+
+		spin_lock_irq(&ctx->inflight_lock);
+		list_for_each_entry(req, &ctx->inflight_list, inflight_entry) {
+			if (req->work.files == files) {
+				ret = io_wq_cancel_work(ctx->io_wq, &req->work);
+				break;
+			}
+		}
+		if (ret == IO_WQ_CANCEL_RUNNING)
+			prepare_to_wait(&ctx->inflight_wait, &wait,
+					TASK_UNINTERRUPTIBLE);
+
+		spin_unlock_irq(&ctx->inflight_lock);
+
+		/*
+		 * We need to keep going until we get NOTFOUND. We only cancel
+		 * one work at the time.
+		 *
+		 * If we get CANCEL_RUNNING, then wait for a work to complete
+		 * before continuing.
+		 */
+		if (ret == IO_WQ_CANCEL_OK)
+			continue;
+		else if (ret != IO_WQ_CANCEL_RUNNING)
+			break;
+		schedule();
+	}
+}
+
+static int io_uring_flush(struct file *file, void *data)
+{
+	struct io_ring_ctx *ctx = file->private_data;
+
+	io_uring_cancel_files(ctx, data);
+	if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
+		io_wq_cancel_all(ctx->io_wq);
+	return 0;
+}
+
 static int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	loff_t offset = (loff_t) vma->vm_pgoff << PAGE_SHIFT;
@@ -3790,7 +3897,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		to_submit = min(to_submit, ctx->sq_entries);
 
 		mutex_lock(&ctx->uring_lock);
-		submitted = io_ring_submit(ctx, to_submit);
+		submitted = io_ring_submit(ctx, to_submit, f.file, fd);
 		mutex_unlock(&ctx->uring_lock);
 	}
 	if (flags & IORING_ENTER_GETEVENTS) {
@@ -3813,6 +3920,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 
 static const struct file_operations io_uring_fops = {
 	.release	= io_uring_release,
+	.flush		= io_uring_flush,
 	.mmap		= io_uring_mmap,
 	.poll		= io_uring_poll,
 	.fasync		= io_uring_fasync,
-- 
2.17.1

