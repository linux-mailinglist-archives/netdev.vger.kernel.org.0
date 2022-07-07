Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACA8156A1AA
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235522AbiGGLwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235485AbiGGLwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:52:04 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9321053D0E;
        Thu,  7 Jul 2022 04:52:03 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id o16-20020a05600c379000b003a02eaea815so970365wmr.0;
        Thu, 07 Jul 2022 04:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yQxFmxJR/QKBAZO6SHp/6U0EjdNvdoVCL417Yd+7Jb4=;
        b=RisWah9PCUHLBq4dMjq5QVBsK8Iz+29uS6KjkwGuTrkn0VKJ5XLWK/F6AsIVankBnP
         fufDpm78QfdsFLVpoTZq/p1Z4R5GkW0rm0YKq9ZWI/oNEXSUP66vrZt6ujOJ+6VHBdNs
         69bCHiCWfPK8ec6lRkH4XqLOW27kdN+20KhzcLATS9swuDYU76eQnk5TdfFbSC9JytA5
         t5we97nHaCauqzM0oi0qTiZTMgdzmaWE7WdjlCQGY58Lrz4NGd2WjrVJnw3QD9OtJDXN
         UDNi6U1zZEz3qOJ/ewYhEEXQd/SiJud0vNyj/d/ihm3weXqphQnR9S/Gm8kMplCqMBAB
         pmAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yQxFmxJR/QKBAZO6SHp/6U0EjdNvdoVCL417Yd+7Jb4=;
        b=Vd3TPrMnnuk02oB2zhJua/eW6Hzb3yAMUOQg/pn2/t8psz5WlguELvIlJAvwnUnhBL
         jlAUcV2JMqc44JduCqKsCFljI4ZnEw2utiwD9XEQcDCpRI5DKYsVAujVYAh9Y6+fZyVR
         roMo/3YKkSiVvAov9Cf6COdxqUBh3eKbQzIPDWGnJUG+bDlsEejxdfUSL1oSp2Ox29X4
         wZE5CNL+mlRDPxW5+kMiXKDcXnSFbazgwgO797cZNPlZ3qXzI4ed0csttP0j4kMBHBmX
         IWVg0c4KtokgNMXMG7fN/riSo8UpOtBup9XjkK1l0mhyg2GlziVDOtRp3xzOODqAu44B
         NL5A==
X-Gm-Message-State: AJIora+2d2Gy5tlL+AgnpDdBL23cL/B0D/R8qsh0A+G9gzVQqPsvzDyv
        GY/0g4PVQ7ywHuZkN5vgSR7IOHpOkDu6VhTNgPE=
X-Google-Smtp-Source: AGRyM1uFZBZwYfqwuJaynzQASf+eB7WTisVOSTpfAo+Iyo2A7s0AXRlzOJ0S4Bq6ab9/aXWP71FIqg==
X-Received: by 2002:a7b:c01a:0:b0:3a1:7ab1:e5dc with SMTP id c26-20020a7bc01a000000b003a17ab1e5dcmr4009494wmb.128.1657194721701;
        Thu, 07 Jul 2022 04:52:01 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u2-20020a5d5142000000b0021b966abc19sm37982131wrt.19.2022.07.07.04.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 04:52:01 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v4 13/27] io_uring: export io_put_task()
Date:   Thu,  7 Jul 2022 12:49:44 +0100
Message-Id: <ea0045a5e1b97834c2b943f0f38b1fb9303b66b6.1657194434.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1657194434.git.asml.silence@gmail.com>
References: <cover.1657194434.git.asml.silence@gmail.com>
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
2.36.1

