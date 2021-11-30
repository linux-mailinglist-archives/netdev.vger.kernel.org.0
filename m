Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 964E94639E0
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243937AbhK3PY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245100AbhK3PX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 10:23:28 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7086C06174A;
        Tue, 30 Nov 2021 07:19:33 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id o13so45086133wrs.12;
        Tue, 30 Nov 2021 07:19:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/4qpz7rl83fuO5X6dN8pqm4n0XXAduiad2YQ5ulIq20=;
        b=I/36ciOZgYSozU1brpSbdUbrsAN1z8uFOpSCoMX3VnU4QzmwfZHjQp/6isz7x0JCnE
         9BY2GBHcgOXQYk5d2EAQRV4ZHtBHm7sHRkPcW+MpeUHfTov9+ky4N7tfgpNkss0dEPiQ
         05rWh/XTszCSGQMnxiY9YqWbryjrkxx2MS9p7YmZaIewDrGHu9jwY37E2s3f+Sb+O4nb
         NqDdFxIJQvePO330sGybTuLy85XTJJsaf3qAd+RbW/47SVjSHxwuPT3p6EFuUjyhM4HE
         QaC3S5jlH7t9LOxKw1uum3jjyEePsLsBX12Ba/h3p2wREoGi4buSZde3ix3wk64j7F7d
         kTSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/4qpz7rl83fuO5X6dN8pqm4n0XXAduiad2YQ5ulIq20=;
        b=2l8YB2N7D8jZpzxjwoRcSVU00mAIsv7a3nh9O5Kyn3D5GqCUz9NFVRQj0WN9T+iEiv
         gcgWtWI01qoL6TSvnSl8Bxv4JvkBVFhsq5ynRQIhY8xKRM228mWy3J4/sHXXNgpn++OC
         ZQVZ8+r1wOcyt9O/6giCy4eoZS7ZYSANNJ2oPNaR/m0OAVTTm8zuyccOskp6ioaEXrmv
         A7hnCLRM64pADMpUI/6qiCHeJ4/Fc/hbEHQbnfZVUZxWd8EJ8zRWnm/VfGsBWpyKzdoB
         HddZgLTVskHk9LqmhhBNu2bPtCA/zTLxbkKNOQfuFwy5Ap76yJNglRJMzS3id+CHS2Qh
         YSKQ==
X-Gm-Message-State: AOAM533t9Ndskb4SfkhNPbLJt7HYF8NSFD6xrpB8HB4KsO6yDWaOfSYj
        aEdcSBLLTf2IYrcilc7K5KTWwHa3pSA=
X-Google-Smtp-Source: ABdhPJwuPqYMs2SMchqkN/ucEwDcLeJzxvw8xWysP6BIzYMM/xZsvVqyEymzXBtiKUs4ximNMagJpw==
X-Received: by 2002:a5d:4a85:: with SMTP id o5mr41068346wrq.109.1638285572286;
        Tue, 30 Nov 2021 07:19:32 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.232.109])
        by smtp.gmail.com with ESMTPSA id d1sm16168483wrz.92.2021.11.30.07.19.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 07:19:31 -0800 (PST)
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
Subject: [RFC 12/12] io_uring: cache struct ubuf_info
Date:   Tue, 30 Nov 2021 15:19:00 +0000
Message-Id: <ba596f42f3141c49c5bd915f2b619feaa24aefb0.1638282789.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <cover.1638282789.git.asml.silence@gmail.com>
References: <cover.1638282789.git.asml.silence@gmail.com>
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
index 5a0adfadf759..8c81177395c3 100644
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
2.34.0

