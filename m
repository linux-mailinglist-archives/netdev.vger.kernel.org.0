Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA6556A176
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235675AbiGGLxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235478AbiGGLwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:52:22 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 336EB564F7;
        Thu,  7 Jul 2022 04:52:13 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id d16so19627632wrv.10;
        Thu, 07 Jul 2022 04:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+Q6oh46ZsOKHpCjkkX4hQw5IEBsf8Tb27Jc0y1xyQTc=;
        b=Ywu8iSvo174JQHme/OmVbgoGmzJf9QWePhwcoHLFs3l7yO1vexrhvmo4PmZ8nDs1al
         lyl0IMJecGInKp9mYAiOQrva9FuKjilMXFU4+trpGJ+gCoySjm/GkUPRTLqOLD+Rg1it
         YEbx8EKiGcrMOE28wRGvpC0vhv61U1EAHimH/znwTDmZIYlzonrWFvcGSOpBD3OxkZ/Q
         cUy4lSazTojvOEi89kknXJF0iAirvzXiku3WIoqx88dsc/SK5PhnhmowvIlVBIg2Pefc
         NyCFsG8HUtCZ0A/aXxyfS94V8zSOQdXotlun4ENRETG1AENXPuKMsrnOKpZJeonbZpdP
         DhxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+Q6oh46ZsOKHpCjkkX4hQw5IEBsf8Tb27Jc0y1xyQTc=;
        b=am39h89jEbnbY3EJJGO0oRaMKM8/PN0/+kiAb/znCbe+CROxH2NoAGL5TiDP6muOn7
         7EWcMZxkwmtd5/KO/4QcZUcVQgb/5wzjOczcvsZCOyN7dy0GKovmOjlOY82lcLAZxNw6
         SwjW4Ar5kTo4uu5qGXfuDd9DWtdNuqo0wrVIdJ4CnN0gESOuAcu/BWUDAQYIsmtF0G/F
         EhFqD+4iUX6MuWdA+qHpM8tpyKXV8DlQx5PjxGWvdxQx++ZZwQFlG3pC7JhD9+jnrZhf
         9lCBMgSSC8xveSQ8Ggexw9crOapXQ75gCAC1fXfu8SNtiGaBgfDXVmtINMfkHTcT7Vu7
         6MQQ==
X-Gm-Message-State: AJIora9Jr1u9Qrni2HfQ9jz9sx9qupQAPsf8zHnLtvuXSP7Yq6YJD0Q/
        YbEI6Z7Jl3IOaI9xcIaHND9CILmdossnG5sZjiY=
X-Google-Smtp-Source: AGRyM1ufO0wl1R6HSZ1OretAHQkqbcdcwBbR6viluQHhQ+UrLM5pmSHsQtVyr2lMuwmDJz1zWkLzcw==
X-Received: by 2002:adf:dd87:0:b0:21d:6ec4:26b0 with SMTP id x7-20020adfdd87000000b0021d6ec426b0mr15485925wrl.182.1657194733100;
        Thu, 07 Jul 2022 04:52:13 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u2-20020a5d5142000000b0021b966abc19sm37982131wrt.19.2022.07.07.04.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 04:52:12 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v4 23/27] io_uring: flush notifiers after sendzc
Date:   Thu,  7 Jul 2022 12:49:54 +0100
Message-Id: <983172d39865aa7c6d313694f3bc2ef4f31e83a9.1657194434.git.asml.silence@gmail.com>
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

Allow to flush notifiers as a part of sendzc request by setting
IORING_SENDZC_FLUSH flag. When the sendzc request succeedes it will
flush the used [active] notifier.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  4 ++++
 io_uring/io_uring.c           | 11 +----------
 io_uring/io_uring.h           | 10 ++++++++++
 io_uring/net.c                |  5 ++++-
 io_uring/notif.c              |  2 +-
 io_uring/notif.h              | 11 +++++++++++
 6 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 8d050c247d6b..37e0730733f9 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -272,10 +272,14 @@ enum io_uring_op {
  *
  * IORING_RECVSEND_FIXED_BUF	Use registered buffers, the index is stored in
  *				the buf_index field.
+ *
+ * IORING_RECVSEND_NOTIF_FLUSH	Flush a notification after a successful
+ *				successful. Only for zerocopy sends.
  */
 #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
 #define IORING_RECV_MULTISHOT		(1U << 1)
 #define IORING_RECVSEND_FIXED_BUF	(1U << 2)
+#define IORING_RECVSEND_NOTIF_FLUSH	(1U << 3)
 
 /*
  * accept flags stored in sqe->ioprio
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 41ef98a43d32..e4f3a1ede2f4 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -615,7 +615,7 @@ void __io_put_task(struct task_struct *task, int nr)
 	put_task_struct_many(task, nr);
 }
 
-static void io_task_refs_refill(struct io_uring_task *tctx)
+void io_task_refs_refill(struct io_uring_task *tctx)
 {
 	unsigned int refill = -tctx->cached_refs + IO_TCTX_REFS_CACHE_NR;
 
@@ -624,15 +624,6 @@ static void io_task_refs_refill(struct io_uring_task *tctx)
 	tctx->cached_refs += refill;
 }
 
-static inline void io_get_task_refs(int nr)
-{
-	struct io_uring_task *tctx = current->io_uring;
-
-	tctx->cached_refs -= nr;
-	if (unlikely(tctx->cached_refs < 0))
-		io_task_refs_refill(tctx);
-}
-
 static __cold void io_uring_drop_tctx_refs(struct task_struct *task)
 {
 	struct io_uring_task *tctx = task->io_uring;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index b8c858727dc8..d9f2f5c71481 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -69,6 +69,7 @@ void io_wq_submit_work(struct io_wq_work *work);
 void io_free_req(struct io_kiocb *req);
 void io_queue_next(struct io_kiocb *req);
 void __io_put_task(struct task_struct *task, int nr);
+void io_task_refs_refill(struct io_uring_task *tctx);
 
 bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
 			bool cancel_all);
@@ -265,4 +266,13 @@ static inline void io_put_task(struct task_struct *task, int nr)
 		__io_put_task(task, nr);
 }
 
+static inline void io_get_task_refs(int nr)
+{
+	struct io_uring_task *tctx = current->io_uring;
+
+	tctx->cached_refs -= nr;
+	if (unlikely(tctx->cached_refs < 0))
+		io_task_refs_refill(tctx);
+}
+
 #endif
diff --git a/io_uring/net.c b/io_uring/net.c
index 0259fbbad591..bf9916d5e50c 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -674,7 +674,8 @@ int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EINVAL;
 
 	zc->flags = READ_ONCE(sqe->ioprio);
-	if (zc->flags & ~(IORING_RECVSEND_POLL_FIRST | IORING_RECVSEND_FIXED_BUF))
+	if (zc->flags & ~(IORING_RECVSEND_POLL_FIRST |
+			  IORING_RECVSEND_FIXED_BUF | IORING_RECVSEND_NOTIF_FLUSH))
 		return -EINVAL;
 	if (zc->flags & IORING_RECVSEND_FIXED_BUF) {
 		unsigned idx = READ_ONCE(sqe->buf_index);
@@ -776,6 +777,8 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 		return ret == -ERESTARTSYS ? -EINTR : ret;
 	}
 
+	if (zc->flags & IORING_RECVSEND_NOTIF_FLUSH)
+		io_notif_slot_flush_submit(notif_slot, 0);
 	io_req_set_res(req, ret, 0);
 	return IOU_OK;
 }
diff --git a/io_uring/notif.c b/io_uring/notif.c
index c5179e5c1cd6..a93887451bbb 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -133,7 +133,7 @@ struct io_notif *io_alloc_notif(struct io_ring_ctx *ctx,
 	return notif;
 }
 
-static void io_notif_slot_flush(struct io_notif_slot *slot)
+void io_notif_slot_flush(struct io_notif_slot *slot)
 	__must_hold(&ctx->uring_lock)
 {
 	struct io_notif *notif = slot->notif;
diff --git a/io_uring/notif.h b/io_uring/notif.h
index 00efe164bdc4..6cd73d7b965b 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -54,6 +54,7 @@ int io_notif_register(struct io_ring_ctx *ctx,
 int io_notif_unregister(struct io_ring_ctx *ctx);
 void io_notif_cache_purge(struct io_ring_ctx *ctx);
 
+void io_notif_slot_flush(struct io_notif_slot *slot);
 struct io_notif *io_alloc_notif(struct io_ring_ctx *ctx,
 				struct io_notif_slot *slot);
 
@@ -74,3 +75,13 @@ static inline struct io_notif_slot *io_get_notif_slot(struct io_ring_ctx *ctx,
 	idx = array_index_nospec(idx, ctx->nr_notif_slots);
 	return &ctx->notif_slots[idx];
 }
+
+static inline void io_notif_slot_flush_submit(struct io_notif_slot *slot,
+					      unsigned int issue_flags)
+{
+	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
+		slot->notif->task = current;
+		io_get_task_refs(1);
+	}
+	io_notif_slot_flush(slot);
+}
-- 
2.36.1

