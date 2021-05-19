Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8CF0389087
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347203AbhESOR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354221AbhESOQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 10:16:31 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC0ACC06135C;
        Wed, 19 May 2021 07:14:19 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id y184-20020a1ce1c10000b02901769b409001so3432981wmg.3;
        Wed, 19 May 2021 07:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iBBRv8iSs8vsCboxbXfrG1xclNCmAan+98X/JNnVwAg=;
        b=XSBlrvEvMACuV/Mdl4wp5JepMkofpVjHeuZWupaz3AcrddBD9wrL9TmBdnkW2CJB7+
         K0mlbLXjdCRUzD4ntkCCJpzNL6SMuLMkVs/fqUq7LSAvLn4OfqFzpaf9wqQmQUyI4rd6
         G2kJqroWvHAhpBPrAfFTZHP2tNbSohWOK+pwu+dACKTH7naQqzpnfkP39nxfAjbKQrSf
         aZQdBfFganrJ5aVynzXPA622Ya4kwRZTO/ec7N38veAZ79xHTC+PwdHLQdea/HvVfd/w
         J16yGF0rVYI6s4j5eA/Bd5PriuILuvXBMGQNS4nGW2P89rkiDjMdlgp1FSlmwrlfpD7N
         9pkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iBBRv8iSs8vsCboxbXfrG1xclNCmAan+98X/JNnVwAg=;
        b=ClsF0h8t+KShvkVJ9tSIRj72ByBKg3GWb4Cn8QYNO6vyixfxvjBxjrLtwo3yk4nzy+
         zFTwNz4wQcZ9Sdx6/ssv1ikxDbhYpLxo3/v2gvXYu8j9vxdENax6ePH3edDF1FhiDzS0
         rcDloWTnWAMC/4wD2trixCHLHFMOhOgmSWOYwWR246pSvFfyIVHZg2SxVraPRuJ2WNRM
         Iy8sgblC6+thQ9EZHSxGRVHprR+bHNV44jK3Thzqhjlxp5ymv8hQyNsTck46rXHORpSI
         8o6SrZ1SRBXtdw0EwN5u3yvmiWqhONaStfWPlwZy4NLsvIcTcRM+wHGpLzq2IAFtlsTK
         EuiQ==
X-Gm-Message-State: AOAM532ZS1zeMQcadlBzmatBqQAysjPH8CXaalQAxJsEk6x7syO2xdUD
        iWdEkrGrNQnjjhsHNlXTC28qZXa5bCeJzZdj
X-Google-Smtp-Source: ABdhPJxTeznG7ssgz77rK45QH0UWDzr+22MRJzQlDRsOMhy7gqN2YgkFcLMkwwTtc7dXq4xaJzXiXw==
X-Received: by 2002:a1c:4c10:: with SMTP id z16mr11517821wmf.134.1621433658304;
        Wed, 19 May 2021 07:14:18 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.154])
        by smtp.gmail.com with ESMTPSA id z3sm6233569wrq.42.2021.05.19.07.14.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 07:14:17 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        "Franz-B . Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>,
        Christian Dietrich <stettberger@dokucode.de>
Subject: [PATCH 23/23] io_uring: enable bpf reqs to wait for CQs
Date:   Wed, 19 May 2021 15:13:34 +0100
Message-Id: <a3d5ac5539a8d9f0423fea051a038e8bbfe10c99.1621424513.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621424513.git.asml.silence@gmail.com>
References: <cover.1621424513.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add experimental support for bpf requests waiting for a number of CQEs
to in a specified CQ.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 80 +++++++++++++++++++++++++++++++++--
 include/uapi/linux/io_uring.h |  2 +
 2 files changed, 79 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 805c10be7ea4..cf02389747b5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -687,6 +687,12 @@ struct io_bpf {
 	struct bpf_prog			*prog;
 };
 
+struct io_async_bpf {
+	struct wait_queue_entry		wqe;
+	unsigned int 			wait_nr;
+	unsigned int 			wait_idx;
+};
+
 struct io_completion {
 	struct file			*file;
 	struct list_head		list;
@@ -1050,7 +1056,9 @@ static const struct io_op_def io_op_defs[] = {
 	},
 	[IORING_OP_RENAMEAT] = {},
 	[IORING_OP_UNLINKAT] = {},
-	[IORING_OP_BPF] = {},
+	[IORING_OP_BPF] = {
+		.async_size		= sizeof(struct io_async_bpf),
+	},
 };
 
 static bool io_disarm_next(struct io_kiocb *req);
@@ -9148,6 +9156,7 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 			}
 		}
 
+		wake_up_all(&ctx->wait);
 		ret |= io_cancel_defer_files(ctx, task, files);
 		ret |= io_poll_remove_all(ctx, task, files);
 		ret |= io_kill_timeouts(ctx, task, files);
@@ -10492,6 +10501,10 @@ static bool io_bpf_is_valid_access(int off, int size,
 	switch (off) {
 	case offsetof(struct io_uring_bpf_ctx, user_data):
 		return size == sizeof_field(struct io_uring_bpf_ctx, user_data);
+	case offsetof(struct io_uring_bpf_ctx, wait_nr):
+		return size == sizeof_field(struct io_uring_bpf_ctx, wait_nr);
+	case offsetof(struct io_uring_bpf_ctx, wait_idx):
+		return size == sizeof_field(struct io_uring_bpf_ctx, wait_idx);
 	}
 	return false;
 }
@@ -10503,6 +10516,60 @@ const struct bpf_verifier_ops bpf_io_uring_verifier_ops = {
 	.is_valid_access	= io_bpf_is_valid_access,
 };
 
+static inline bool io_bpf_need_wake(struct io_async_bpf *abpf)
+{
+	struct io_kiocb *req = abpf->wqe.private;
+	struct io_ring_ctx *ctx = req->ctx;
+
+	if (unlikely(percpu_ref_is_dying(&ctx->refs)) ||
+		     atomic_read(&req->task->io_uring->in_idle))
+		return true;
+	return __io_cqring_events(&ctx->cqs[abpf->wait_idx]) >= abpf->wait_nr;
+}
+
+static int io_bpf_wait_func(struct wait_queue_entry *wqe, unsigned mode,
+			       int sync, void *key)
+{
+	struct io_async_bpf *abpf = container_of(wqe, struct io_async_bpf, wqe);
+	bool wake = io_bpf_need_wake(abpf);
+
+	if (wake) {
+		list_del_init_careful(&wqe->entry);
+		req_ref_get(wqe->private);
+		io_queue_async_work(wqe->private);
+	}
+	return wake;
+}
+
+static int io_bpf_wait_cq_async(struct io_kiocb *req, unsigned int nr,
+				unsigned int idx)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct wait_queue_head *wq;
+	struct wait_queue_entry *wqe;
+	struct io_async_bpf *abpf;
+
+	if (unlikely(idx >= ctx->cq_nr))
+		return -EINVAL;
+	if (!req->async_data && io_alloc_async_data(req))
+		return -ENOMEM;
+
+	abpf = req->async_data;
+	abpf->wait_nr = nr;
+	abpf->wait_idx = idx;
+	wqe = &abpf->wqe;
+	init_waitqueue_func_entry(wqe, io_bpf_wait_func);
+	wqe->private = req;
+	wq = &ctx->wait;
+
+	spin_lock_irq(&wq->lock);
+	__add_wait_queue(wq, wqe);
+	smp_mb();
+	io_bpf_wait_func(wqe, 0, 0, NULL);
+	spin_unlock_irq(&wq->lock);
+	return 0;
+}
+
 static void io_bpf_run(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -10512,8 +10579,8 @@ static void io_bpf_run(struct io_kiocb *req, unsigned int issue_flags)
 
 	lockdep_assert_held(&req->ctx->uring_lock);
 
-	if (unlikely(percpu_ref_is_dying(&ctx->refs) ||
-		     atomic_read(&req->task->io_uring->in_idle)))
+	if (unlikely(percpu_ref_is_dying(&ctx->refs)) ||
+		     atomic_read(&req->task->io_uring->in_idle))
 		goto done;
 
 	memset(&bpf_ctx.u, 0, sizeof(bpf_ctx.u));
@@ -10531,6 +10598,13 @@ static void io_bpf_run(struct io_kiocb *req, unsigned int issue_flags)
 	}
 	io_submit_state_end(&ctx->submit_state, ctx);
 	ret = 0;
+
+	if (bpf_ctx.u.wait_nr) {
+		ret = io_bpf_wait_cq_async(req, bpf_ctx.u.wait_nr,
+					   bpf_ctx.u.wait_idx);
+		if (!ret)
+			return;
+	}
 done:
 	__io_req_complete(req, issue_flags, ret, 0);
 }
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index d7b1713bcfb0..95c04af3afd4 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -405,6 +405,8 @@ struct io_uring_getevents_arg {
 
 struct io_uring_bpf_ctx {
 	__u64	user_data;
+	__u32	wait_nr;
+	__u32	wait_idx;
 };
 
 #endif
-- 
2.31.1

