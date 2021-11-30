Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF6D24639D1
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244562AbhK3PYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:24:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245086AbhK3PX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 10:23:28 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E310BC061D65;
        Tue, 30 Nov 2021 07:19:27 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id j3so45243400wrp.1;
        Tue, 30 Nov 2021 07:19:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aQQXoYWBH4jfdlEHv5tZol+01BrTrQ8qiQ0k4xRr9KQ=;
        b=kZFiGfLzItRdZa2oClNtEIvfviPy1VJs24Iyd2nWiFaJHZ+SgMQhuf7eDNWDYCr1VQ
         cERXF8xuyeQuizQYQOB+XJvm65nkPIgQNtEjS+CWZlIK96eHqFtZPT7GLYA1mbVpLJ1h
         Vwqmjiayr+d1KZPTjA3Ms6UoSgN0qEhV5rnfXF7jERi7yoWIT9m1t/biLwff2wE/kEJW
         cBU2gd/J+sW5LplFrewTbsFM4fv26c/NURjQUCRM3xd3in4bEKHAN9YjETZRY+3yZa02
         iGg+04z36Gy1/JYjtk8Z0Hp5yJgSununM0rRh4rt1j/2U9G5f16brfRhjDpw0WvzB+xW
         VVkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aQQXoYWBH4jfdlEHv5tZol+01BrTrQ8qiQ0k4xRr9KQ=;
        b=msO1odKb3z5k4wdxM77cEmPX7umpYAk/u7BOMxMuyJC8QOIKylkVyRiJh9UIz+jnk0
         yTiljGnako146klI6EnnwMAWPubzaOmgEtmjzH2OR2tCyqalX3qkSW9Yqer2RnHML/9p
         JROVO0pGILAbOXS0AgquNHT3Jht/4nmXoNHB59wU+xpJ+oCJcZFD6Q+Fz6K+Tnuv3J88
         aXUZQf69haIuMgiIH5LbVytMR2ee18aBaKJWGq2n/tJWST2nA8kFeLJkn71UQYcHiMub
         2DwohWwHk/urbpba62xW8YECC/foAuhQQ3v8/n3dSp7TfWBz4+D1EYvk8dEi9hss/3QV
         8Axg==
X-Gm-Message-State: AOAM533wVi41P7ubfa5zO8j//ljJkLC5DTWmagl9r82WXWRhHEQASxra
        rnk/s9ACCek6uDmSq5IoNo9KWQ/9JlQ=
X-Google-Smtp-Source: ABdhPJxD8BTtW6WL2an20PrK6Cfj0KFy5qepEeEebPK/e5whCwDaUOWQz28cjzL/U26WPjRbl8cXQA==
X-Received: by 2002:a5d:5986:: with SMTP id n6mr43685533wri.297.1638285566354;
        Tue, 30 Nov 2021 07:19:26 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.232.109])
        by smtp.gmail.com with ESMTPSA id d1sm16168483wrz.92.2021.11.30.07.19.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 07:19:26 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC 07/12] io_uring: infrastructure for send zc notifications
Date:   Tue, 30 Nov 2021 15:18:55 +0000
Message-Id: <5c2b751d6c29c02f1d0a3b0e0b220de321bc3e2d.1638282789.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <cover.1638282789.git.asml.silence@gmail.com>
References: <cover.1638282789.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new ubuf_info callback io_uring_tx_zerocopy_callback(), which
should post an CQE when it completes. Also, implement some
infrastructuire for allocating and managing struct ubuf_info.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 114 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 108 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a01f91e70fa5..6ca02e60fa48 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -329,6 +329,11 @@ struct io_submit_state {
 };
 
 struct io_tx_notifier {
+	struct ubuf_info	uarg;
+	struct work_struct	commit_work;
+	struct percpu_ref	*fixed_rsrc_refs;
+	u64			tag;
+	u32			seq;
 };
 
 struct io_tx_ctx {
@@ -1275,15 +1280,20 @@ static void io_rsrc_refs_refill(struct io_ring_ctx *ctx)
 	percpu_ref_get_many(&ctx->rsrc_node->refs, IO_RSRC_REF_BATCH);
 }
 
+static inline void io_set_rsrc_node(struct percpu_ref **rsrc_refs,
+				    struct io_ring_ctx *ctx)
+{
+	*rsrc_refs = &ctx->rsrc_node->refs;
+	ctx->rsrc_cached_refs--;
+	if (unlikely(ctx->rsrc_cached_refs < 0))
+		io_rsrc_refs_refill(ctx);
+}
+
 static inline void io_req_set_rsrc_node(struct io_kiocb *req,
 					struct io_ring_ctx *ctx)
 {
-	if (!req->fixed_rsrc_refs) {
-		req->fixed_rsrc_refs = &ctx->rsrc_node->refs;
-		ctx->rsrc_cached_refs--;
-		if (unlikely(ctx->rsrc_cached_refs < 0))
-			io_rsrc_refs_refill(ctx);
-	}
+	if (!req->fixed_rsrc_refs)
+		io_set_rsrc_node(&req->fixed_rsrc_refs, ctx);
 }
 
 static void io_refs_resurrect(struct percpu_ref *ref, struct completion *compl)
@@ -1930,6 +1940,76 @@ static noinline bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data,
 	return __io_fill_cqe(ctx, user_data, res, cflags);
 }
 
+static void io_zc_tx_work_callback(struct work_struct *work)
+{
+	struct io_tx_notifier *notifier = container_of(work, struct io_tx_notifier,
+						       commit_work);
+	struct io_ring_ctx *ctx = notifier->uarg.ctx;
+
+	spin_lock(&ctx->completion_lock);
+	io_fill_cqe_aux(ctx, notifier->tag, notifier->seq, 0);
+	io_commit_cqring(ctx);
+	spin_unlock(&ctx->completion_lock);
+	io_cqring_ev_posted(ctx);
+
+	percpu_ref_put(notifier->fixed_rsrc_refs);
+	percpu_ref_put(&ctx->refs);
+	kfree(notifier);
+}
+
+static void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
+					  struct ubuf_info *uarg,
+					  bool success)
+{
+	struct io_tx_notifier *notifier;
+
+	notifier = container_of(uarg, struct io_tx_notifier, uarg);
+	if (!refcount_dec_and_test(&uarg->refcnt))
+		return;
+
+	if (in_interrupt()) {
+		INIT_WORK(&notifier->commit_work, io_zc_tx_work_callback);
+		queue_work(system_unbound_wq, &notifier->commit_work);
+	} else {
+		io_zc_tx_work_callback(&notifier->commit_work);
+	}
+}
+
+static struct io_tx_notifier *io_alloc_tx_notifier(struct io_ring_ctx *ctx,
+						   struct io_tx_ctx *tx_ctx)
+{
+	struct io_tx_notifier *notifier;
+	struct ubuf_info *uarg;
+
+	notifier = kmalloc(sizeof(*notifier), GFP_ATOMIC);
+	if (!notifier)
+		return NULL;
+
+	WARN_ON_ONCE(!current->io_uring);
+	notifier->seq = tx_ctx->seq++;
+	notifier->tag = tx_ctx->tag;
+	io_set_rsrc_node(&notifier->fixed_rsrc_refs, ctx);
+
+	uarg = &notifier->uarg;
+	uarg->ctx = ctx;
+	uarg->flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
+	uarg->callback = io_uring_tx_zerocopy_callback;
+	refcount_set(&uarg->refcnt, 1);
+	percpu_ref_get(&ctx->refs);
+	return notifier;
+}
+
+__attribute__((unused))
+static inline struct io_tx_notifier *io_get_tx_notifier(struct io_ring_ctx *ctx,
+							struct io_tx_ctx *tx_ctx)
+{
+	if (tx_ctx->notifier)
+		return tx_ctx->notifier;
+
+	tx_ctx->notifier = io_alloc_tx_notifier(ctx, tx_ctx);
+	return tx_ctx->notifier;
+}
+
 static void io_req_complete_post(struct io_kiocb *req, s32 res,
 				 u32 cflags)
 {
@@ -9212,11 +9292,27 @@ static int io_buffer_validate(struct iovec *iov)
 	return 0;
 }
 
+static void io_sqe_tx_ctx_kill_ubufs(struct io_ring_ctx *ctx)
+{
+	struct io_tx_ctx *tx_ctx;
+	int i;
+
+	for (i = 0; i < ctx->nr_tx_ctxs; i++) {
+		tx_ctx = &ctx->tx_ctxs[i];
+		if (!tx_ctx->notifier)
+			continue;
+		io_uring_tx_zerocopy_callback(NULL, &tx_ctx->notifier->uarg,
+					      true);
+		tx_ctx->notifier = NULL;
+	}
+}
+
 static int io_sqe_tx_ctx_unregister(struct io_ring_ctx *ctx)
 {
 	if (!ctx->nr_tx_ctxs)
 		return -ENXIO;
 
+	io_sqe_tx_ctx_kill_ubufs(ctx);
 	kvfree(ctx->tx_ctxs);
 	ctx->tx_ctxs = NULL;
 	ctx->nr_tx_ctxs = 0;
@@ -9608,6 +9704,12 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 			io_sq_thread_unpark(sqd);
 		}
 
+		if (READ_ONCE(ctx->nr_tx_ctxs)) {
+			mutex_lock(&ctx->uring_lock);
+			io_sqe_tx_ctx_kill_ubufs(ctx);
+			mutex_unlock(&ctx->uring_lock);
+		}
+
 		io_req_caches_free(ctx);
 
 		if (WARN_ON_ONCE(time_after(jiffies, timeout))) {
-- 
2.34.0

