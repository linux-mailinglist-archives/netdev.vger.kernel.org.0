Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B035947C313
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 16:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239655AbhLUPgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 10:36:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239648AbhLUPgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 10:36:25 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 080D8C061574;
        Tue, 21 Dec 2021 07:36:13 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id v7so20401838wrv.12;
        Tue, 21 Dec 2021 07:36:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WsUNFg1GEDl96mL5jIYmxxYGv794Eaz/mdSlxpAjpdQ=;
        b=Dbsqav7VEQIb3SoGMUEEjJVeAu0KNlP1MXClTmDuUKqC7/2TCXapP8UATPIheyiGJO
         GOESUQ/B3PgEZ52VCtUIRYIAjAWEOrzz1EJZFJy40vaTwG4kdMjn/rdGJyfwaH+xX2es
         msa9qBY887L9EA5I7WbtX21n6oWqdWcTMszJpMnNTFpgwobLDTR4qiFxUYQZYjKohKBM
         1d9hvVjt/2/YYAGoC2Jcg1h8LWmxtYYQjZq1fpJw94kzIyE7pLKt7ASOWD5wiAubU+LO
         gLbrtEjp02s0WNA1yodAF7fC7b9AlgFh6EcyBQbyj25tq1opm7UdaJerNkE5uR2kyyyk
         jp+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WsUNFg1GEDl96mL5jIYmxxYGv794Eaz/mdSlxpAjpdQ=;
        b=1JSetzp1TDdivAuASP0UK45LJX6/sYjsie6by51BqCqx7Ka11wWBOdZiOLKewQiYN1
         ESDezoL8tEaw4aSEcjxy3B3vP9YyGbd7TZTl5P4H8UsiaKcf18DNDY5dso6b4I6MVxQK
         KH8J+NVZSPswtQJiqwbnP7vTiS/o/PSQrYgXKQ/xiHJ33l5WE3deYWqHiVpmxzAMc9G0
         y9T3/Eng8iAaHF1FbKcLRCZPvafcl0dKTnUOD63aE0roWXGe0suczOB09H2F9ImxEKFg
         v2sPw9k64jBK+kA+lufB1+mTJWuxGlYGgfmdfWe+uHzE+lGeUwXnIVb6X4Zutl30TKSC
         iFAQ==
X-Gm-Message-State: AOAM533/UEanpKeL79bpLYwfC1Q1PuM9DUU29LmGAfqN834e4iHV13Xt
        T/TW819aIeh5UvUYcvHzx15jtcXNN+s=
X-Google-Smtp-Source: ABdhPJzLvdfkgy6easONlSisP2N9dXgWxzHcfyUiYO7sVeDRPq5n7F/zxeKf1cCH3eaiHj/bsofZ6Q==
X-Received: by 2002:a05:6000:1563:: with SMTP id 3mr3091971wrz.372.1640100971390;
        Tue, 21 Dec 2021 07:36:11 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.24])
        by smtp.gmail.com with ESMTPSA id z11sm2946019wmf.9.2021.12.21.07.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 07:36:10 -0800 (PST)
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
Subject: [RFC v2 16/19] io_uring: cache struct ubuf_info
Date:   Tue, 21 Dec 2021 15:35:38 +0000
Message-Id: <18227f5469478564b3b5f525478acb0980996f2b.1640029579.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1640029579.git.asml.silence@gmail.com>
References: <cover.1640029579.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allocation/deallocation of ubuf_info takes some time, add an
optimisation caching them. The implementation is alike to how we cache
requests in io_req_complete_post().

->ubuf_list is protected by ->uring_lock and requests try grab directly
from it, and there is also ->ubuf_list_locked list protected by
->completion_lock, which is eventually batch spliced to ->ubuf_list.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 74 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 64 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 654023ba0b91..5f79178a3f38 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -334,6 +334,7 @@ struct io_tx_notifier {
 	struct percpu_ref	*fixed_rsrc_refs;
 	u64			tag;
 	u32			seq;
+	struct list_head	cache_node;
 };
 
 struct io_tx_ctx {
@@ -393,6 +394,9 @@ struct io_ring_ctx {
 		unsigned		nr_tx_ctxs;
 
 		struct io_submit_state	submit_state;
+		struct list_head	ubuf_list;
+		struct list_head	ubuf_list_locked;
+		int			ubuf_locked_nr;
 		struct list_head	timeout_list;
 		struct list_head	ltimeout_list;
 		struct list_head	cq_overflow_list;
@@ -1491,6 +1495,8 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_WQ_LIST(&ctx->locked_free_list);
 	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
 	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
+	INIT_LIST_HEAD(&ctx->ubuf_list);
+	INIT_LIST_HEAD(&ctx->ubuf_list_locked);
 	return ctx;
 err:
 	kfree(ctx->dummy_ubuf);
@@ -1963,16 +1969,20 @@ static void io_zc_tx_work_callback(struct work_struct *work)
 	struct io_tx_notifier *notifier = container_of(work, struct io_tx_notifier,
 						       commit_work);
 	struct io_ring_ctx *ctx = notifier->uarg.ctx;
+	struct percpu_ref *rsrc_refs = notifier->fixed_rsrc_refs;
 
 	spin_lock(&ctx->completion_lock);
 	io_fill_cqe_aux(ctx, notifier->tag, notifier->seq, 0);
+
+	list_add(&notifier->cache_node, &ctx->ubuf_list_locked);
+	ctx->ubuf_locked_nr++;
+
 	io_commit_cqring(ctx);
 	spin_unlock(&ctx->completion_lock);
 	io_cqring_ev_posted(ctx);
 
-	percpu_ref_put(notifier->fixed_rsrc_refs);
+	percpu_ref_put(rsrc_refs);
 	percpu_ref_put(&ctx->refs);
-	kfree(notifier);
 }
 
 static void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
@@ -1999,26 +2009,69 @@ static void io_tx_kill_notification(struct io_tx_ctx *tx_ctx)
 	tx_ctx->notifier = NULL;
 }
 
+static void io_notifier_splice(struct io_ring_ctx *ctx)
+{
+	spin_lock(&ctx->completion_lock);
+	list_splice_init(&ctx->ubuf_list_locked, &ctx->ubuf_list);
+	ctx->ubuf_locked_nr = 0;
+	spin_unlock(&ctx->completion_lock);
+}
+
+static void io_notifier_free_cached(struct io_ring_ctx *ctx)
+{
+	struct io_tx_notifier *notifier;
+
+	io_notifier_splice(ctx);
+
+	while (!list_empty(&ctx->ubuf_list)) {
+		notifier = list_first_entry(&ctx->ubuf_list,
+					    struct io_tx_notifier, cache_node);
+		list_del(&notifier->cache_node);
+		kfree(notifier);
+	}
+}
+
+static inline bool io_notifier_has_cached(struct io_ring_ctx *ctx)
+{
+	if (likely(!list_empty(&ctx->ubuf_list)))
+		return true;
+	if (READ_ONCE(ctx->ubuf_locked_nr) <= IO_REQ_ALLOC_BATCH)
+		return false;
+	io_notifier_splice(ctx);
+	return !list_empty(&ctx->ubuf_list);
+}
+
 static struct io_tx_notifier *io_alloc_tx_notifier(struct io_ring_ctx *ctx,
 						   struct io_tx_ctx *tx_ctx)
 {
 	struct io_tx_notifier *notifier;
 	struct ubuf_info *uarg;
 
-	notifier = kmalloc(sizeof(*notifier), GFP_ATOMIC);
-	if (!notifier)
-		return NULL;
+	if (likely(io_notifier_has_cached(ctx))) {
+		if (WARN_ON_ONCE(list_empty(&ctx->ubuf_list)))
+			return NULL;
+
+		notifier = list_first_entry(&ctx->ubuf_list,
+					    struct io_tx_notifier, cache_node);
+		list_del(&notifier->cache_node);
+	} else {
+		gfp_t gfp_flags = GFP_ATOMIC|GFP_KERNEL_ACCOUNT;
+
+		notifier = kmalloc(sizeof(*notifier), gfp_flags);
+		if (!notifier)
+			return NULL;
+		uarg = &notifier->uarg;
+		uarg->ctx = ctx;
+		uarg->flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
+		uarg->callback = io_uring_tx_zerocopy_callback;
+	}
 
 	WARN_ON_ONCE(!current->io_uring);
 	notifier->seq = tx_ctx->seq++;
 	notifier->tag = tx_ctx->tag;
 	io_set_rsrc_node(&notifier->fixed_rsrc_refs, ctx);
 
-	uarg = &notifier->uarg;
-	uarg->ctx = ctx;
-	uarg->flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
-	uarg->callback = io_uring_tx_zerocopy_callback;
-	refcount_set(&uarg->refcnt, 1);
+	refcount_set(&notifier->uarg.refcnt, 1);
 	percpu_ref_get(&ctx->refs);
 	return notifier;
 }
@@ -9732,6 +9785,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 #endif
 	WARN_ON_ONCE(!list_empty(&ctx->ltimeout_list));
 
+	io_notifier_free_cached(ctx);
 	io_sqe_tx_ctx_unregister(ctx);
 	io_mem_free(ctx->rings);
 	io_mem_free(ctx->sq_sqes);
-- 
2.34.1

