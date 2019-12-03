Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19AC410F53D
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 03:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbfLCCy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 21:54:58 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34830 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbfLCCy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 21:54:58 -0500
Received: by mail-pl1-f194.google.com with SMTP id s10so1050636plp.2
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 18:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5QhEYS+kl7+QUsvoMH+o5Su+lCHvRF1WMsBAbJGpKk4=;
        b=M77zR5e98QdVo7EVuujSr4Aj1uFcLfZ3vWI+GJoNqu1R/XtRrabpd75/xnnzXkLnWh
         rLNCZka2Sxf3wsNqRqeT+rjljZYrAXoC4HYht+izNz4O2hMzU9v693kuD0sH3Ma/pwHI
         saiRAW4a6LsjqRu+1uF/McMs0MNgTlkij/DGAVp+4Z1hEpth9oAlHdcmXbYySQI+mJ7i
         2jn1WU8oxN6NyK+vZ4xIWrNiixESPf8bEVjUnvfyqv8f90rU9YRwzBeRuM70JCtc3pGw
         VAUru/LxkRGH+LuaucqTameOy1pmjxpkLCWRymKAoYEfg+VXFwIiTphHXoVgWVRoYd7c
         qrQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5QhEYS+kl7+QUsvoMH+o5Su+lCHvRF1WMsBAbJGpKk4=;
        b=I+3j9VCRLvIcawWrKNoPArFX8dQ2HJPhkegieOkVar0zJFY7x2CW7UgGMrSua6ptIb
         OsqjujvWndvyqSYMsncbuXVaaDqlLWejz+dzKdsTZLD7ABtD3FP/cv8xooJLzTDaQDOW
         5IiYC6CAqPLF5bZoA0KXuHcEZ7GOD7/XhovffMGHEkkrIXn2uveRmPmXA2rMOWLNJQql
         +nvEHcm69B7N6DBdL+WhKDekuYxLxCaYsOW9rbMeVyV1blGk6EoV/Sn83aEgZpoKF6Rx
         VyKsOfHAgS5yUTt/w2LU/ToXarla/itZ2tW6yONCggraXDc0kzFue3jkVVxPkwHQ0Lse
         Xf6Q==
X-Gm-Message-State: APjAAAW9TEuAgSTnNh+1FNJ9okQAbknx+CRUeAz1UODjceWdrIaFhBmg
        IdUVz6NbmMG6d70RCQccGupuxA==
X-Google-Smtp-Source: APXvYqyV0x7A9Z4QaY/aFGv4ReNzwrw1d1C+KrJM7IB4O1ec99gJOIH8WaEqfuHAQzzJr9Ks506YcQ==
X-Received: by 2002:a17:902:d697:: with SMTP id v23mr2809955ply.106.1575341697293;
        Mon, 02 Dec 2019 18:54:57 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id z7sm959364pfk.41.2019.12.02.18.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 18:54:56 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        =?UTF-8?q?=E6=9D=8E=E9=80=9A=E6=B4=B2?= <carter.li@eoitek.com>
Subject: [PATCH 2/5] io_uring: ensure async punted read/write requests copy iovec
Date:   Mon,  2 Dec 2019 19:54:41 -0700
Message-Id: <20191203025444.29344-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203025444.29344-1-axboe@kernel.dk>
References: <20191203025444.29344-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently we don't copy the iovecs when we punt to async context. This
can be problematic for applications that store the iovec on the stack,
as they often assume that it's safe to let the iovec go out of scope
as soon as IO submission has been called. This isn't always safe, as we
will re-copy the iovec once we're in async context.

Make this 100% safe by copying the iovec just once. With this change,
applications may safely store the iovec on the stack for all cases.

Reported-by: 李通洲 <carter.li@eoitek.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 241 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 179 insertions(+), 62 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bbbd9f664b1e..bd8fab9277d6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -308,8 +308,18 @@ struct io_timeout {
 	struct io_timeout_data		*data;
 };
 
+struct io_async_rw {
+	struct iovec			fast_iov[UIO_FASTIOV];
+	struct iovec			*iov;
+	ssize_t				nr_segs;
+	ssize_t				size;
+};
+
 struct io_async_ctx {
 	struct io_uring_sqe		sqe;
+	union {
+		struct io_async_rw	rw;
+	};
 };
 
 /*
@@ -1415,15 +1425,6 @@ static int io_prep_rw(struct io_kiocb *req, bool force_nonblock)
 	if (S_ISREG(file_inode(req->file)->i_mode))
 		req->flags |= REQ_F_ISREG;
 
-	/*
-	 * If the file doesn't support async, mark it as REQ_F_MUST_PUNT so
-	 * we know to async punt it even if it was opened O_NONBLOCK
-	 */
-	if (force_nonblock && !io_file_supports_async(req->file)) {
-		req->flags |= REQ_F_MUST_PUNT;
-		return -EAGAIN;
-	}
-
 	kiocb->ki_pos = READ_ONCE(sqe->off);
 	kiocb->ki_flags = iocb_flags(kiocb->ki_filp);
 	kiocb->ki_hint = ki_hint_validate(file_write_hint(kiocb->ki_filp));
@@ -1592,6 +1593,16 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 		return io_import_fixed(req->ctx, rw, sqe, iter);
 	}
 
+	if (req->io) {
+		struct io_async_rw *iorw = &req->io->rw;
+
+		*iovec = iorw->iov;
+		iov_iter_init(iter, rw, *iovec, iorw->nr_segs, iorw->size);
+		if (iorw->iov == iorw->fast_iov)
+			*iovec = NULL;
+		return iorw->size;
+	}
+
 	if (!req->has_user)
 		return -EFAULT;
 
@@ -1662,6 +1673,50 @@ static ssize_t loop_rw_iter(int rw, struct file *file, struct kiocb *kiocb,
 	return ret;
 }
 
+static void io_req_map_io(struct io_kiocb *req, ssize_t io_size,
+			  struct iovec *iovec, struct iovec *fast_iov,
+			  struct iov_iter *iter)
+{
+	req->io->rw.nr_segs = iter->nr_segs;
+	req->io->rw.size = io_size;
+	req->io->rw.iov = iovec;
+	if (!req->io->rw.iov) {
+		req->io->rw.iov = req->io->rw.fast_iov;
+		memcpy(req->io->rw.iov, fast_iov,
+			sizeof(struct iovec) * iter->nr_segs);
+	}
+}
+
+static int io_setup_async_io(struct io_kiocb *req, ssize_t io_size,
+			     struct iovec *iovec, struct iovec *fast_iov,
+			     struct iov_iter *iter)
+{
+	req->io = kmalloc(sizeof(*req->io), GFP_KERNEL);
+	if (req->io) {
+		io_req_map_io(req, io_size, iovec, fast_iov, iter);
+		memcpy(&req->io->sqe, req->sqe, sizeof(req->io->sqe));
+		req->sqe = &req->io->sqe;
+		return 0;
+	}
+
+	return -ENOMEM;
+}
+
+static int io_read_prep(struct io_kiocb *req, struct iovec **iovec,
+			struct iov_iter *iter, bool force_nonblock)
+{
+	ssize_t ret;
+
+	ret = io_prep_rw(req, force_nonblock);
+	if (ret)
+		return ret;
+
+	if (unlikely(!(req->file->f_mode & FMODE_READ)))
+		return -EBADF;
+
+	return io_import_iovec(READ, req, iovec, iter);
+}
+
 static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
 		   bool force_nonblock)
 {
@@ -1670,23 +1725,31 @@ static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
 	struct iov_iter iter;
 	struct file *file;
 	size_t iov_count;
-	ssize_t read_size, ret;
+	ssize_t io_size, ret;
 
-	ret = io_prep_rw(req, force_nonblock);
-	if (ret)
-		return ret;
-	file = kiocb->ki_filp;
-
-	if (unlikely(!(file->f_mode & FMODE_READ)))
-		return -EBADF;
-
-	ret = io_import_iovec(READ, req, &iovec, &iter);
-	if (ret < 0)
-		return ret;
+	if (!req->io) {
+		ret = io_read_prep(req, &iovec, &iter, force_nonblock);
+		if (ret < 0)
+			return ret;
+	} else {
+		ret = io_import_iovec(READ, req, &iovec, &iter);
+		if (ret < 0)
+			return ret;
+	}
 
-	read_size = ret;
+	file = req->file;
+	io_size = ret;
 	if (req->flags & REQ_F_LINK)
-		req->result = read_size;
+		req->result = io_size;
+
+	/*
+	 * If the file doesn't support async, mark it as REQ_F_MUST_PUNT so
+	 * we know to async punt it even if it was opened O_NONBLOCK
+	 */
+	if (force_nonblock && !io_file_supports_async(file)) {
+		req->flags |= REQ_F_MUST_PUNT;
+		goto copy_iov;
+	}
 
 	iov_count = iov_iter_count(&iter);
 	ret = rw_verify_area(READ, file, &kiocb->ki_pos, iov_count);
@@ -1708,18 +1771,40 @@ static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
 		 */
 		if (force_nonblock && !(req->flags & REQ_F_NOWAIT) &&
 		    (req->flags & REQ_F_ISREG) &&
-		    ret2 > 0 && ret2 < read_size)
+		    ret2 > 0 && ret2 < io_size)
 			ret2 = -EAGAIN;
 		/* Catch -EAGAIN return for forced non-blocking submission */
-		if (!force_nonblock || ret2 != -EAGAIN)
+		if (!force_nonblock || ret2 != -EAGAIN) {
 			kiocb_done(kiocb, ret2, nxt, req->in_async);
-		else
-			ret = -EAGAIN;
+		} else {
+copy_iov:
+			ret = io_setup_async_io(req, io_size, iovec,
+						inline_vecs, &iter);
+			if (ret)
+				goto out_free;
+			return -EAGAIN;
+		}
 	}
+out_free:
 	kfree(iovec);
 	return ret;
 }
 
+static int io_write_prep(struct io_kiocb *req, struct iovec **iovec,
+			 struct iov_iter *iter, bool force_nonblock)
+{
+	ssize_t ret;
+
+	ret = io_prep_rw(req, force_nonblock);
+	if (ret)
+		return ret;
+
+	if (unlikely(!(req->file->f_mode & FMODE_WRITE)))
+		return -EBADF;
+
+	return io_import_iovec(WRITE, req, iovec, iter);
+}
+
 static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
 		    bool force_nonblock)
 {
@@ -1728,29 +1813,36 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
 	struct iov_iter iter;
 	struct file *file;
 	size_t iov_count;
-	ssize_t ret;
+	ssize_t ret, io_size;
 
-	ret = io_prep_rw(req, force_nonblock);
-	if (ret)
-		return ret;
+	if (!req->io) {
+		ret = io_write_prep(req, &iovec, &iter, force_nonblock);
+		if (ret < 0)
+			return ret;
+	} else {
+		ret = io_import_iovec(WRITE, req, &iovec, &iter);
+		if (ret < 0)
+			return ret;
+	}
 
 	file = kiocb->ki_filp;
-	if (unlikely(!(file->f_mode & FMODE_WRITE)))
-		return -EBADF;
-
-	ret = io_import_iovec(WRITE, req, &iovec, &iter);
-	if (ret < 0)
-		return ret;
-
+	io_size = ret;
 	if (req->flags & REQ_F_LINK)
-		req->result = ret;
+		req->result = io_size;
 
-	iov_count = iov_iter_count(&iter);
+	/*
+	 * If the file doesn't support async, mark it as REQ_F_MUST_PUNT so
+	 * we know to async punt it even if it was opened O_NONBLOCK
+	 */
+	if (force_nonblock && !io_file_supports_async(req->file)) {
+		req->flags |= REQ_F_MUST_PUNT;
+		goto copy_iov;
+	}
 
-	ret = -EAGAIN;
 	if (force_nonblock && !(kiocb->ki_flags & IOCB_DIRECT))
-		goto out_free;
+		goto copy_iov;
 
+	iov_count = iov_iter_count(&iter);
 	ret = rw_verify_area(WRITE, file, &kiocb->ki_pos, iov_count);
 	if (!ret) {
 		ssize_t ret2;
@@ -1774,10 +1866,16 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
 			ret2 = call_write_iter(file, kiocb, &iter);
 		else
 			ret2 = loop_rw_iter(WRITE, file, kiocb, &iter);
-		if (!force_nonblock || ret2 != -EAGAIN)
+		if (!force_nonblock || ret2 != -EAGAIN) {
 			kiocb_done(kiocb, ret2, nxt, req->in_async);
-		else
-			ret = -EAGAIN;
+		} else {
+copy_iov:
+			ret = io_setup_async_io(req, io_size, iovec,
+						inline_vecs, &iter);
+			if (ret)
+				goto out_free;
+			return -EAGAIN;
+		}
 	}
 out_free:
 	kfree(iovec);
@@ -2605,10 +2703,40 @@ static int io_async_cancel(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	return 0;
 }
 
+static int io_req_defer_prep(struct io_kiocb *req, struct io_async_ctx *io)
+{
+	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
+	struct iov_iter iter;
+	ssize_t ret;
+
+	memcpy(&io->sqe, req->sqe, sizeof(io->sqe));
+	req->sqe = &io->sqe;
+
+	switch (io->sqe.opcode) {
+	case IORING_OP_READV:
+		ret = io_read_prep(req, &iovec, &iter, true);
+		break;
+	case IORING_OP_WRITEV:
+		ret = io_write_prep(req, &iovec, &iter, true);
+		break;
+	default:
+		req->io = io;
+		return 0;
+	}
+
+	if (ret < 0)
+		return ret;
+
+	req->io = io;
+	io_req_map_io(req, ret, iovec, inline_vecs, &iter);
+	return 0;
+}
+
 static int io_req_defer(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_async_ctx *io;
+	int ret;
 
 	/* Still need defer if there is pending req in defer list. */
 	if (!req_need_defer(req) && list_empty(&ctx->defer_list))
@@ -2625,9 +2753,9 @@ static int io_req_defer(struct io_kiocb *req)
 		return 0;
 	}
 
-	memcpy(&io->sqe, req->sqe, sizeof(io->sqe));
-	req->sqe = &io->sqe;
-	req->io = io;
+	ret = io_req_defer_prep(req, io);
+	if (ret < 0)
+		return ret;
 
 	trace_io_uring_defer(ctx, req, req->user_data);
 	list_add_tail(&req->list, &ctx->defer_list);
@@ -2960,17 +3088,6 @@ static void __io_queue_sqe(struct io_kiocb *req)
 	 */
 	if (ret == -EAGAIN && (!(req->flags & REQ_F_NOWAIT) ||
 	    (req->flags & REQ_F_MUST_PUNT))) {
-		struct io_async_ctx *io;
-
-		io = kmalloc(sizeof(*io), GFP_KERNEL);
-		if (!io)
-			goto err;
-
-		memcpy(&io->sqe, req->sqe, sizeof(io->sqe));
-
-		req->sqe = &io->sqe;
-		req->io = io;
-
 		if (req->work.flags & IO_WQ_WORK_NEEDS_FILES) {
 			ret = io_grab_files(req);
 			if (ret)
@@ -3092,9 +3209,9 @@ static void io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
 			goto err_req;
 		}
 
-		memcpy(&io->sqe, req->sqe, sizeof(io->sqe));
-		req->sqe = &io->sqe;
-		req->io = io;
+		ret = io_req_defer_prep(req, io);
+		if (ret)
+			goto err_req;
 		trace_io_uring_link(ctx, req, prev);
 		list_add_tail(&req->list, &prev->link_list);
 	} else if (req->sqe->flags & IOSQE_IO_LINK) {
-- 
2.24.0

