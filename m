Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0484755ED49
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235015AbiF1TBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234436AbiF1TAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:00:30 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA15192BC;
        Tue, 28 Jun 2022 12:00:12 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id q6so27605025eji.13;
        Tue, 28 Jun 2022 12:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zfHMbLuCKQqFJLG8Xa+1J2oi4mfqrTwl6h13Ej2Ml0E=;
        b=XQKoHY8GrKGDe5JicrVvTuTlNvN73tTcy6RZF+Mg/PCkmMolIAIQl0kC14UwLCS1U1
         ZXPQq9eayrkufn+wD9lDatnxits6uWY3upVEyN/X0EfpbnWcbJshAo9R51UJhgES4a3r
         hiitciLNIAU7Lcn3l6XfvneGJ7yRvlwZNq7w2krWVH0bio4PKGJa245ZahbBNe4ccKyf
         jsFJQC5xEmUZcXRvHzuXF8//hhRCyExnHfdGzaBj/f8+EKiyOw2QcsCMaBBO8rnjKH6l
         2Lcmt6UOmBVsVqNLZutdo1b8SJvRsfQZsL2hXYXHS2XnMnb0MQvzv+6KKtVZJpoWSJJx
         LuOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zfHMbLuCKQqFJLG8Xa+1J2oi4mfqrTwl6h13Ej2Ml0E=;
        b=bjxmoDQnj8N/vLxzvnD7yZIz2tlDl6xBkLSuW2PW5PtGU3aR7hok7Rvevqllxd60R/
         w0yCcimHA9CGCd4SOKi6iQyRUqNdiMMaOJPy0YxVSCPQWHZ6VlmuEHZMGuWLtb+C0jX/
         h2WUzb1G4uziVEWmI8koBfMD5x9IeQ4NgkUkgYssflgyA5fHjubc4zv3M9kFFzvVm42B
         aRrWXzO3qlYNzMJw3tC3exoIg/X6z+R8hzsFQVmaH4H1FSFoJSZoF8MK53UUcZyIS5PI
         ufL3adjn/dQVx2vDzkS7BdF6OC3Rx3FWqEpQhnv29VjqdiFJmuXW0SyARjGqZxpeFPRa
         GwBA==
X-Gm-Message-State: AJIora+dqeD7HLYOUz9ODNfPsyAKYfZKQdfqsz3IhQTnbrUBa0o1spum
        r5BRZm58ZlmRWsEV8INLbw691c1FlOa9ng==
X-Google-Smtp-Source: AGRyM1tUHxbZIc83PqDWmR89oynE48Yyu5+PWEBEifb3wXk/kqiod3sTW8M3H3cT66R2rTRiZTErRA==
X-Received: by 2002:a17:907:7f8e:b0:712:f503:1a56 with SMTP id qk14-20020a1709077f8e00b00712f5031a56mr18130211ejc.364.1656442811574;
        Tue, 28 Jun 2022 12:00:11 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t21-20020a05640203d500b0043573c59ea0sm9758451edw.90.2022.06.28.12.00.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 12:00:11 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next v3 16/29] io_uring: cache struct io_notif
Date:   Tue, 28 Jun 2022 19:56:38 +0100
Message-Id: <91a78581e59863bd45125195055a1712e1e202e3.1653992701.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1653992701.git.asml.silence@gmail.com>
References: <cover.1653992701.git.asml.silence@gmail.com>
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

kmalloc'ing struct io_notif is too expensive when done frequently, cache
them as many other resources in io_uring. Keep two list, the first one
is from where we're getting notifiers, it's protected by ->uring_lock.
The second is protected by ->completion_lock, to which we queue released
notifiers. Then we splice one list into another when needed.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 68 +++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 61 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7d058deb5f73..422ff835bf36 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -381,6 +381,8 @@ struct io_notif {
 	u64			tag;
 	/* see struct io_notif_slot::seq */
 	u32			seq;
+	/* hook into ctx->notif_list and ctx->notif_list_locked */
+	struct list_head	cache_node;
 
 	union {
 		struct callback_head	task_work;
@@ -469,6 +471,8 @@ struct io_ring_ctx {
 		struct xarray		io_bl_xa;
 		struct list_head	io_buffers_cache;
 
+		/* struct io_notif cache protected by uring_lock */
+		struct list_head	notif_list;
 		struct list_head	timeout_list;
 		struct list_head	ltimeout_list;
 		struct list_head	cq_overflow_list;
@@ -481,6 +485,9 @@ struct io_ring_ctx {
 	/* IRQ completion list, under ->completion_lock */
 	struct io_wq_work_list	locked_free_list;
 	unsigned int		locked_free_nr;
+	/* struct io_notif cache protected by completion_lock */
+	struct list_head	notif_list_locked;
+	unsigned int		notif_locked_nr;
 
 	const struct cred	*sq_creds;	/* cred used for __io_sq_thread() */
 	struct io_sq_data	*sq_data;	/* if using sq thread polling */
@@ -1932,6 +1939,8 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_WQ_LIST(&ctx->locked_free_list);
 	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
 	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
+	INIT_LIST_HEAD(&ctx->notif_list);
+	INIT_LIST_HEAD(&ctx->notif_list_locked);
 	return ctx;
 err:
 	kfree(ctx->dummy_ubuf);
@@ -2795,12 +2804,15 @@ static void __io_notif_complete_tw(struct callback_head *cb)
 
 	spin_lock(&ctx->completion_lock);
 	io_fill_cqe_aux(ctx, notif->tag, 0, notif->seq);
+
+	list_add(&notif->cache_node, &ctx->notif_list_locked);
+	ctx->notif_locked_nr++;
+
 	io_commit_cqring(ctx);
 	spin_unlock(&ctx->completion_lock);
 	io_cqring_ev_posted(ctx);
 
 	percpu_ref_put(&ctx->refs);
-	kfree(notif);
 }
 
 static inline void io_notif_complete(struct io_notif *notif)
@@ -2827,21 +2839,62 @@ static void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
 	queue_work(system_unbound_wq, &notif->commit_work);
 }
 
+static void io_notif_splice_cached(struct io_ring_ctx *ctx)
+	__must_hold(&ctx->uring_lock)
+{
+	spin_lock(&ctx->completion_lock);
+	list_splice_init(&ctx->notif_list_locked, &ctx->notif_list);
+	ctx->notif_locked_nr = 0;
+	spin_unlock(&ctx->completion_lock);
+}
+
+static void io_notif_cache_purge(struct io_ring_ctx *ctx)
+	__must_hold(&ctx->uring_lock)
+{
+	io_notif_splice_cached(ctx);
+
+	while (!list_empty(&ctx->notif_list)) {
+		struct io_notif *notif = list_first_entry(&ctx->notif_list,
+						struct io_notif, cache_node);
+
+		list_del(&notif->cache_node);
+		kfree(notif);
+	}
+}
+
+static inline bool io_notif_has_cached(struct io_ring_ctx *ctx)
+	__must_hold(&ctx->uring_lock)
+{
+	if (likely(!list_empty(&ctx->notif_list)))
+		return true;
+	if (data_race(READ_ONCE(ctx->notif_locked_nr) <= IO_COMPL_BATCH))
+		return false;
+	io_notif_splice_cached(ctx);
+	return !list_empty(&ctx->notif_list);
+}
+
 static struct io_notif *io_alloc_notif(struct io_ring_ctx *ctx,
 				       struct io_notif_slot *slot)
 	__must_hold(&ctx->uring_lock)
 {
 	struct io_notif *notif;
 
-	notif = kzalloc(sizeof(*notif), GFP_ATOMIC | __GFP_ACCOUNT);
-	if (!notif)
-		return NULL;
+	if (likely(io_notif_has_cached(ctx))) {
+		notif = list_first_entry(&ctx->notif_list,
+					 struct io_notif, cache_node);
+		list_del(&notif->cache_node);
+	} else {
+		notif = kzalloc(sizeof(*notif), GFP_ATOMIC | __GFP_ACCOUNT);
+		if (!notif)
+			return NULL;
+		/* pre-initialise some fields */
+		notif->ctx = ctx;
+		notif->uarg.flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
+		notif->uarg.callback = io_uring_tx_zerocopy_callback;
+	}
 
 	notif->seq = slot->seq++;
 	notif->tag = slot->tag;
-	notif->ctx = ctx;
-	notif->uarg.flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
-	notif->uarg.callback = io_uring_tx_zerocopy_callback;
 	/* master ref owned by io_notif_slot, will be dropped on flush */
 	refcount_set(&notif->uarg.refcnt, 1);
 	percpu_ref_get(&ctx->refs);
@@ -11330,6 +11383,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	WARN_ON_ONCE(!list_empty(&ctx->ltimeout_list));
 	WARN_ON_ONCE(ctx->notif_slots || ctx->nr_notif_slots);
 
+	io_notif_cache_purge(ctx);
 	io_mem_free(ctx->rings);
 	io_mem_free(ctx->sq_sqes);
 
-- 
2.36.1

