Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8BCDB8FD
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 23:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503657AbfJQV3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 17:29:08 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36760 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503649AbfJQV3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 17:29:07 -0400
Received: by mail-pg1-f195.google.com with SMTP id 23so2090293pgk.3
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 14:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=92CYtTRoYQ39d46k61SL6rtGzWXElvZP8rT1pbbx14I=;
        b=drb8GIXsLGMmBXEwez6fklfxs4YzPgKuEtRwcZZj/pxkrrf1TdJuvM94qU90HWW3k6
         tsjMmQ9PekHc61/M30oibRHORCDFGnxCrMU7avMUx9dndND6uNcIovXO605z4qCtD/SE
         rHQbOrvxbPAUUe532OhbMl9X4Jf/QFdBq735dGzJRVuEiq5FgH53SmCGnR2J4Wm1aSGS
         dw5nNouwe0WhfwLmjhnX4FSIxAQbGLbvclKixz85IRxfjD8UBbVFJwxNoCl9WuggMu/0
         QcrwVNIWodhl0qaMjTx2mLnNbGZvoNMicRA6BJdaab9o05iARGWbb53/ZBu+nZy70+gg
         vJRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=92CYtTRoYQ39d46k61SL6rtGzWXElvZP8rT1pbbx14I=;
        b=KwEs80z2wMMd695eQIJg2bhJsvX9amFrvYQakqLgDq39WI7c4lmHxZnmap3avEIvdt
         LsMSWdsi1ASLTKrhmdpUG6OWQmPa7oqxQ7+lhjOBae6B45EOGI37TSV+D5GAPvb6wUDQ
         dxUtEt/jP6dbrlvxW2tinjUYPx0Wj3o9bq26oaCGWaOHOaL0qthArwIJCHLfj4+USEhI
         52jfabTyAagcVGFQ3UjYxdNHsNUzvI89Vf91Mw2lYNd4jIuRMUJgh30ke8+ie94PDtgy
         0slKUPvs5KSr3gF1oMyVUltisaFQt6onVvSNtHsaS6pBaMMrG1O9+78k2l+Ue7syRVdA
         0Pcw==
X-Gm-Message-State: APjAAAUB47cyVLdjWTHwXuq05GmA9bim/PVtes3DBRHZdcDvxb1MRFec
        jDwfSRaYRv9lI3BPm9fn4mF0IY9YyuDL0g==
X-Google-Smtp-Source: APXvYqwm6GLu+zFMnlkzYvu+ZSQTI4qYWKTk3BDgsOmRpNYNQA9qzo5v+4MOGw8e3K+rfAcgXcbalw==
X-Received: by 2002:a17:90a:8c14:: with SMTP id a20mr6821770pjo.77.1571347746552;
        Thu, 17 Oct 2019 14:29:06 -0700 (PDT)
Received: from x1.thefacebook.com ([2620:10d:c090:180::e2ce])
        by smtp.gmail.com with ESMTPSA id w6sm4296446pfw.84.2019.10.17.14.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 14:29:05 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-block@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring: add support for async work inheriting files table
Date:   Thu, 17 Oct 2019 15:28:56 -0600
Message-Id: <20191017212858.13230-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191017212858.13230-1-axboe@kernel.dk>
References: <20191017212858.13230-1-axboe@kernel.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is in preparation for adding opcodes that need to modify files
in a process file table, either adding new ones or closing old ones.

If an opcode needs this, it must set REQ_F_NEED_FILES in the request
structure. If work that needs to get punted to async context have this
set, they will grab a reference to the process file table. When the
work is completed, the reference is dropped again.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 635856023fdf..ad462237275e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -267,10 +267,11 @@ struct io_ring_ctx {
 struct sqe_submit {
 	const struct io_uring_sqe	*sqe;
 	unsigned short			index;
+	bool				has_user : 1;
+	bool				in_async : 1;
+	bool				needs_fixed_file : 1;
 	u32				sequence;
-	bool				has_user;
-	bool				in_async;
-	bool				needs_fixed_file;
+	struct files_struct		*files;
 };
 
 /*
@@ -323,6 +324,7 @@ struct io_kiocb {
 #define REQ_F_FAIL_LINK		256	/* fail rest of links */
 #define REQ_F_SHADOW_DRAIN	512	/* link-drain shadow req */
 #define REQ_F_TIMEOUT		1024	/* timeout request */
+#define REQ_F_NEED_FILES	2048	/* needs to assume file table */
 	u64			user_data;
 	u32			result;
 	u32			sequence;
@@ -2191,6 +2193,7 @@ static inline bool io_sqe_needs_user(const struct io_uring_sqe *sqe)
 static void io_sq_wq_submit_work(struct work_struct *work)
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+	struct files_struct *old_files = NULL;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct mm_struct *cur_mm = NULL;
 	struct async_list *async_list;
@@ -2220,6 +2223,10 @@ static void io_sq_wq_submit_work(struct work_struct *work)
 				set_fs(USER_DS);
 			}
 		}
+		if (s->files && !old_files) {
+			old_files = current->files;
+			current->files = s->files;
+		}
 
 		if (!ret) {
 			s->has_user = cur_mm != NULL;
@@ -2312,6 +2319,11 @@ static void io_sq_wq_submit_work(struct work_struct *work)
 		unuse_mm(cur_mm);
 		mmput(cur_mm);
 	}
+	if (old_files) {
+		struct files_struct *files = current->files;
+		current->files = old_files;
+		put_files_struct(files);
+	}
 }
 
 /*
@@ -2413,6 +2425,8 @@ static int __io_queue_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
 			s->sqe = sqe_copy;
 			memcpy(&req->submit, s, sizeof(*s));
+			if (req->flags & REQ_F_NEED_FILES)
+				req->submit.files = get_files_struct(current);
 			list = io_async_list_from_sqe(ctx, s->sqe);
 			if (!io_add_to_prev_work(list, req)) {
 				if (list)
@@ -2633,6 +2647,7 @@ static bool io_get_sqring(struct io_ring_ctx *ctx, struct sqe_submit *s)
 		s->index = head;
 		s->sqe = &ctx->sq_sqes[head];
 		s->sequence = ctx->cached_sq_head;
+		s->files = NULL;
 		ctx->cached_sq_head++;
 		return true;
 	}
-- 
2.17.1

