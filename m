Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12C047C302
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 16:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239636AbhLUPgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 10:36:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239535AbhLUPgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 10:36:11 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E4FC061763;
        Tue, 21 Dec 2021 07:36:06 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id a9so27690265wrr.8;
        Tue, 21 Dec 2021 07:36:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hlDfhawyO4srXvDUu8FIjMC0f1jsig5whZXypCgHm7s=;
        b=kUHFcXu+clpTYg2+7dZlOog1Lyb0RNPmwfWZT3YMp9NMaS5RPj24v5NtKhW8QV3vnc
         rARJvLchpRG3lFbv52dLqE+7Fo7tBJghiQQJB4do/tjfUPJNR+fFfqod44K9quRWH9K+
         rEONiSXPqj8WqaBYhJ6YgMq54z7vAi7yC7mJj/1eSs9ApFvGaWit7exhMyAF1sAI0cKC
         2LQKytoHkMq2C5knXbq+uLVWA5ns94lxzKS9utoQAcxYq5a7Lf4bFDvrorH+2TYhUyGv
         TiW/g7U/HLeKYZKIOOSc7Lqfy3ySIAu46kzk9jfTTk0GKifu4gqwBtgZs3nbo8NTvCxQ
         sQeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hlDfhawyO4srXvDUu8FIjMC0f1jsig5whZXypCgHm7s=;
        b=BLMXANdv3OpG7PbsntpfdDz5QKIJ7a0jXPmj0omHOQ23wZ2YT03Ti5yYjk2cs5pDWD
         ljipk46zAlEbB8VITkmgc72BSzKVJpywuJD0/6LRaVGoynFmKBDLAbheiQ0fTWsGSiL7
         Mse6NnJ7lIbpcfRJEYVqX8scdt23Nl9zFIOM3I3p+t2/Lk0HbONGqXPoq+K8cSeGiefC
         iGtzxxTZd79MlSmkAIRXNvWE4QlzXPFrkPaX37VAc4ntUzApAd2azcUNUWtlS1dKHYXR
         U5XstZquF22ZJpoZilg7XoqKe6fjWMa2zilPqDsG1qP1eHnTGGqBYUX5l1TQv9H/4Z31
         phqw==
X-Gm-Message-State: AOAM533i9PX94MX8w/tzMflP6vdYmDhWWB9pmkOVViEQAoKdY4Ugwb2H
        716IDoiwgxS3BC6DC5mbTJ6XAWcLbqM=
X-Google-Smtp-Source: ABdhPJxZMZB+eUpDRBewQ1fM/jdg8dCcTkuIEK5cqusZENDJVhixmTgnhv7BhoybXpuruTzw1jZiCw==
X-Received: by 2002:a05:6000:1625:: with SMTP id v5mr3114573wrb.196.1640100965140;
        Tue, 21 Dec 2021 07:36:05 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.24])
        by smtp.gmail.com with ESMTPSA id z11sm2946019wmf.9.2021.12.21.07.36.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 07:36:04 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC v2 11/19] io_uring: infrastructure for send zc notifications
Date:   Tue, 21 Dec 2021 15:35:33 +0000
Message-Id: <8fb455d8df2e8635a4424e7fdc34c7e06c7e1138.1640029579.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1640029579.git.asml.silence@gmail.com>
References: <cover.1640029579.git.asml.silence@gmail.com>
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
index a01f91e70fa5..92190679f3f6 100644
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
+	struct io_tx_notifier *notifier = container_of(uarg,
+						struct io_tx_notifier, uarg);
+
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
2.34.1

