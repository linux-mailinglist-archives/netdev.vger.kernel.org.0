Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC09D5727ED
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 22:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbiGLUyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 16:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234109AbiGLUxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 16:53:47 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4A0D085C;
        Tue, 12 Jul 2022 13:53:24 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 9-20020a1c0209000000b003a2dfdebe47so85146wmc.3;
        Tue, 12 Jul 2022 13:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t800C3UW24EYUJ7jIBViV/Es6005J2b7uIwCCrhjWNQ=;
        b=YRIMsVyKoyP/kU4ZdScISJ4L6DZjSnsTWvwKFZwgiVRZJnM+UFyIh2/FJDFaqfT8wF
         zKg/CJycE8Awf2lysm/pLhFOh6ZjdDBFCoZt1HQYjTk82M4LSpMVrYK+V1v9vS+neKxY
         W9p/iryUhFJ5LFsTl/MUzsFgi3iBsR7fDQicnDgrcqVAhqnCzMuLzDmlZjqtX4737Dgq
         UB083BCgopx63K63+0Ngt/UphCaFyAlNvtm+AQFaYDwzpP8G1EEHx5R4m3f+r5ZD2Mp2
         A4ZouS83CH/rrI6+YpNvQCxCa5R1U5a5U0L72MfpaRlbV4NgKYu4fhfEeDOfRVRniCXD
         hGlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t800C3UW24EYUJ7jIBViV/Es6005J2b7uIwCCrhjWNQ=;
        b=2pKatZJqADUpIGOHzI3UkfeibT601k6fCKA1SxPbfwIcEu2nZfKD2Tcrt8Xw7M4ycy
         +r7c0Wc2Yo6H4dBjdqLozeRlmouunbLfp9vrdVNziS1aU0kE3BxXhfSm2ADja1Mm2jJA
         sBloMcTqp2wXCN01OhEd0LgmmOiN74mtNpRh6SGJOe/2s5WrOHCTRAx6g4ARwHLrm+WZ
         LjsRLHBo3SQm1rhnSKcjMo5GHtFqCWRZl1E/N8V74iOCmi5PDxLQkX3TTPilpB7aaqsh
         CepuLXaOSCBOxtt5s4mC2CQ8Ben7N3t/I196YdN6EvXm5YqiaYqCDfIC6DjVce14T6Ip
         kTHQ==
X-Gm-Message-State: AJIora9z0RQX6DeJzdnhGMPdXhGBX/19tVB5noJS4v32k+0zvE8i8SZO
        aUF1bolF6yxFE/MmFnR1kgCXpHGqZ4s=
X-Google-Smtp-Source: AGRyM1uNbx+CtqsvokSH4Szzl4TpleQVijINmFvzFFrVB0wRpW5GCpJaCWuKMG/6MQFXZH/EAlYlPA==
X-Received: by 2002:a05:600c:1e22:b0:3a2:ec81:a415 with SMTP id ay34-20020a05600c1e2200b003a2ec81a415mr6042471wmb.139.1657659203055;
        Tue, 12 Jul 2022 13:53:23 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id c14-20020a7bc00e000000b003a044fe7fe7sm89833wmb.9.2022.07.12.13.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 13:53:22 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v5 13/27] io_uring: export io_put_task()
Date:   Tue, 12 Jul 2022 21:52:37 +0100
Message-Id: <3686807d4c03b72e389947b0e8692d4d44334ef0.1657643355.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1657643355.git.asml.silence@gmail.com>
References: <cover.1657643355.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make io_put_task() available to non-core parts of io_uring, we'll need
it for notification infrastructure.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h | 25 +++++++++++++++++++++++++
 io_uring/io_uring.c            | 11 +----------
 io_uring/io_uring.h            | 10 ++++++++++
 io_uring/tctx.h                | 26 --------------------------
 4 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 26ef11e978d4..d876a0367081 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -4,6 +4,7 @@
 #include <linux/blkdev.h>
 #include <linux/task_work.h>
 #include <linux/bitmap.h>
+#include <linux/llist.h>
 #include <uapi/linux/io_uring.h>
 
 struct io_wq_work_node {
@@ -43,6 +44,30 @@ struct io_hash_table {
 	unsigned		hash_bits;
 };
 
+/*
+ * Arbitrary limit, can be raised if need be
+ */
+#define IO_RINGFD_REG_MAX 16
+
+struct io_uring_task {
+	/* submission side */
+	int				cached_refs;
+	const struct io_ring_ctx 	*last;
+	struct io_wq			*io_wq;
+	struct file			*registered_rings[IO_RINGFD_REG_MAX];
+
+	struct xarray			xa;
+	struct wait_queue_head		wait;
+	atomic_t			in_idle;
+	atomic_t			inflight_tracked;
+	struct percpu_counter		inflight;
+
+	struct { /* task_work */
+		struct llist_head	task_list;
+		struct callback_head	task_work;
+	} ____cacheline_aligned_in_smp;
+};
+
 struct io_uring {
 	u32 head ____cacheline_aligned_in_smp;
 	u32 tail ____cacheline_aligned_in_smp;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index caf979cd4327..bb644b1b575a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -602,7 +602,7 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx)
 	return ret;
 }
 
-static void __io_put_task(struct task_struct *task, int nr)
+void __io_put_task(struct task_struct *task, int nr)
 {
 	struct io_uring_task *tctx = task->io_uring;
 
@@ -612,15 +612,6 @@ static void __io_put_task(struct task_struct *task, int nr)
 	put_task_struct_many(task, nr);
 }
 
-/* must to be called somewhat shortly after putting a request */
-static inline void io_put_task(struct task_struct *task, int nr)
-{
-	if (likely(task == current))
-		task->io_uring->cached_refs += nr;
-	else
-		__io_put_task(task, nr);
-}
-
 static void io_task_refs_refill(struct io_uring_task *tctx)
 {
 	unsigned int refill = -tctx->cached_refs + IO_TCTX_REFS_CACHE_NR;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 868f45d55543..2379d9e70c10 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -66,6 +66,7 @@ void io_wq_submit_work(struct io_wq_work *work);
 
 void io_free_req(struct io_kiocb *req);
 void io_queue_next(struct io_kiocb *req);
+void __io_put_task(struct task_struct *task, int nr);
 
 bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
 			bool cancel_all);
@@ -253,4 +254,13 @@ static inline void io_commit_cqring_flush(struct io_ring_ctx *ctx)
 		__io_commit_cqring_flush(ctx);
 }
 
+/* must to be called somewhat shortly after putting a request */
+static inline void io_put_task(struct task_struct *task, int nr)
+{
+	if (likely(task == current))
+		task->io_uring->cached_refs += nr;
+	else
+		__io_put_task(task, nr);
+}
+
 #endif
diff --git a/io_uring/tctx.h b/io_uring/tctx.h
index 8a33ff6e5d91..25974beed4d6 100644
--- a/io_uring/tctx.h
+++ b/io_uring/tctx.h
@@ -1,31 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
 
-#include <linux/llist.h>
-
-/*
- * Arbitrary limit, can be raised if need be
- */
-#define IO_RINGFD_REG_MAX 16
-
-struct io_uring_task {
-	/* submission side */
-	int				cached_refs;
-	const struct io_ring_ctx 	*last;
-	struct io_wq			*io_wq;
-	struct file			*registered_rings[IO_RINGFD_REG_MAX];
-
-	struct xarray			xa;
-	struct wait_queue_head		wait;
-	atomic_t			in_idle;
-	atomic_t			inflight_tracked;
-	struct percpu_counter		inflight;
-
-	struct { /* task_work */
-		struct llist_head	task_list;
-		struct callback_head	task_work;
-	} ____cacheline_aligned_in_smp;
-};
-
 struct io_tctx_node {
 	struct list_head	ctx_node;
 	struct task_struct	*task;
-- 
2.37.0

