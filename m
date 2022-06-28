Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8648A55ED47
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234997AbiF1TBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234400AbiF1TAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:00:30 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F791192B2;
        Tue, 28 Jun 2022 12:00:12 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id cw10so27722463ejb.3;
        Tue, 28 Jun 2022 12:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/DS9gGA8lQr1mQ1qP1UVl4uxwqUZZbMt9fa4yEuYjRY=;
        b=Y16vBXY3BNMdyY694jmORCUiVVsgwT7R/vsEySJHTa5xjL/1WUS6HZxr8RJkTLsohR
         KYG1KrzK0bxhuGHEYEiczLTGHkheDaTTvqWMM/M22vrcFRiqa5tJ3ONIsaoPYHX/CaOc
         LGT6CILsZBUkG3UUoJF+skBT7PgMLG/m4l4TVAbs/l/EovYhYpeWLpq2lfHviKUY7eeK
         cABSLW3eMzxYMARICAKqS4hjVOQxvTwx3pZfYVQzzZXYmwLndy54b9xgT5gqpH183yD8
         s/LJDqTfXOruEvuuNDZcoVbf9Ci3J0RolfudYtBi+NuN1oIMituvB5OWxJlu4RmSsIoi
         CQLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/DS9gGA8lQr1mQ1qP1UVl4uxwqUZZbMt9fa4yEuYjRY=;
        b=241VcFm+NvFziOBJsmwlc5z+mAeAsqsKnFrfPQnoFoybA+H1yfSVCQLPsrFqEGQSNX
         ujFlpLqMdsEQyH7QFzQKhnYn2vgII0PvJxjy6HKNLiUc65tTQ71eweh8YDrHI+dbCvdL
         CI84duUH8Mxm0vDCDN6qiAWmQPoD5D3DN8YwtwtXfjW6VzhPdOGzUadnUJYpUK4m53iz
         jx8/7qej7HqMHXWsmHQwksmm/5wYwSvU//uHij30phAP6yXaGu1qIAeUgPqNPsBjfme7
         hInpkrcvrdQoOcPQUuXoD7LdG5oZ1sZH0CPZZbHBST2m3BbAfABA27WxOC2ukp1MxEto
         5Pog==
X-Gm-Message-State: AJIora9Q+7httaUADN2sP/iZywQ7hRu9PgwUDyy8IajdwJ/b9nUyd8uU
        U/NCKFVX6dG+7RWRrgyHiUkXm0dqUiLr/w==
X-Google-Smtp-Source: AGRyM1vk+bLiNcpuFgwwDts6cGS90BWez3dfWZftHhjo+8cjzcN0Ww3ve3c7v6bb4Lq7xPo3FZmIPw==
X-Received: by 2002:a17:907:3e8c:b0:726:41fa:2866 with SMTP id hs12-20020a1709073e8c00b0072641fa2866mr17765469ejc.562.1656442810332;
        Tue, 28 Jun 2022 12:00:10 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t21-20020a05640203d500b0043573c59ea0sm9758451edw.90.2022.06.28.12.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 12:00:09 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next v3 15/29] io_uring: add zc notification infrastructure
Date:   Tue, 28 Jun 2022 19:56:37 +0100
Message-Id: <4b2a76541e91194a146788bcd401f438f5b4b45d.1653992701.git.asml.silence@gmail.com>
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

Add internal part of send zerocopy notifications. There are two main
structures, the first one is struct io_notif, which carries inside
struct ubuf_info and maps 1:1 to it. io_uring will be binding a number
of zerocopy send requests to it and ask to complete (aka flush) it. When
flushed and all attached requests and skbs complete, it'll generate one
and only one CQE. There are intended to be passed into the network layer
as struct msghdr::msg_ubuf.

The second concept is notification slots. The userspace will be able to
register an array of slots and subsequently addressing them by the index
in the array. Slots are independent of each other. Each slot can have
only one notifier at a time (called active notifier) but many notifiers
during the lifetime. When active, a notifier not going to post any
completion but the userspace can attach requests to it by specifying
the corresponding slot while issueing send zc requests. Eventually, the
userspace will want to "flush" the notifier losing any way to attach
new requests to it, however it can use the next atomatically added
notifier of this slot or of any other slot.

When the network layer is done with all enqueued skbs attached to a
notifier and doesn't need the specified in them user data, the flushed
notifier will post a CQE.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 156 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 156 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e47629adf3f7..7d058deb5f73 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -371,6 +371,43 @@ struct io_ev_fd {
 	struct rcu_head		rcu;
 };
 
+#define IO_NOTIF_MAX_SLOTS	(1U << 10)
+
+struct io_notif {
+	struct ubuf_info	uarg;
+	struct io_ring_ctx	*ctx;
+
+	/* cqe->user_data, io_notif_slot::tag if not overridden */
+	u64			tag;
+	/* see struct io_notif_slot::seq */
+	u32			seq;
+
+	union {
+		struct callback_head	task_work;
+		struct work_struct	commit_work;
+	};
+};
+
+struct io_notif_slot {
+	/*
+	 * Current/active notifier. A slot holds only one active notifier at a
+	 * time and keeps one reference to it. Flush releases the reference and
+	 * lazily replaces it with a new notifier.
+	 */
+	struct io_notif		*notif;
+
+	/*
+	 * Default ->user_data for this slot notifiers CQEs
+	 */
+	u64			tag;
+	/*
+	 * Notifiers of a slot live in generations, we create a new notifier
+	 * only after flushing the previous one. Track the sequential number
+	 * for all notifiers and copy it into notifiers's cqe->cflags
+	 */
+	u32			seq;
+};
+
 #define BGID_ARRAY	64
 
 struct io_ring_ctx {
@@ -423,6 +460,8 @@ struct io_ring_ctx {
 		unsigned		nr_user_files;
 		unsigned		nr_user_bufs;
 		struct io_mapped_ubuf	**user_bufs;
+		struct io_notif_slot	*notif_slots;
+		unsigned		nr_notif_slots;
 
 		struct io_submit_state	submit_state;
 
@@ -2749,6 +2788,121 @@ static __cold void io_free_req(struct io_kiocb *req)
 	spin_unlock(&ctx->completion_lock);
 }
 
+static void __io_notif_complete_tw(struct callback_head *cb)
+{
+	struct io_notif *notif = container_of(cb, struct io_notif, task_work);
+	struct io_ring_ctx *ctx = notif->ctx;
+
+	spin_lock(&ctx->completion_lock);
+	io_fill_cqe_aux(ctx, notif->tag, 0, notif->seq);
+	io_commit_cqring(ctx);
+	spin_unlock(&ctx->completion_lock);
+	io_cqring_ev_posted(ctx);
+
+	percpu_ref_put(&ctx->refs);
+	kfree(notif);
+}
+
+static inline void io_notif_complete(struct io_notif *notif)
+{
+	__io_notif_complete_tw(&notif->task_work);
+}
+
+static void io_notif_complete_wq(struct work_struct *work)
+{
+	struct io_notif *notif = container_of(work, struct io_notif, commit_work);
+
+	io_notif_complete(notif);
+}
+
+static void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
+					  struct ubuf_info *uarg,
+					  bool success)
+{
+	struct io_notif *notif = container_of(uarg, struct io_notif, uarg);
+
+	if (!refcount_dec_and_test(&uarg->refcnt))
+		return;
+	INIT_WORK(&notif->commit_work, io_notif_complete_wq);
+	queue_work(system_unbound_wq, &notif->commit_work);
+}
+
+static struct io_notif *io_alloc_notif(struct io_ring_ctx *ctx,
+				       struct io_notif_slot *slot)
+	__must_hold(&ctx->uring_lock)
+{
+	struct io_notif *notif;
+
+	notif = kzalloc(sizeof(*notif), GFP_ATOMIC | __GFP_ACCOUNT);
+	if (!notif)
+		return NULL;
+
+	notif->seq = slot->seq++;
+	notif->tag = slot->tag;
+	notif->ctx = ctx;
+	notif->uarg.flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
+	notif->uarg.callback = io_uring_tx_zerocopy_callback;
+	/* master ref owned by io_notif_slot, will be dropped on flush */
+	refcount_set(&notif->uarg.refcnt, 1);
+	percpu_ref_get(&ctx->refs);
+	return notif;
+}
+
+__attribute__((unused))
+static inline struct io_notif *io_get_notif(struct io_ring_ctx *ctx,
+					    struct io_notif_slot *slot)
+{
+	if (!slot->notif)
+		slot->notif = io_alloc_notif(ctx, slot);
+	return slot->notif;
+}
+
+__attribute__((unused))
+static inline struct io_notif_slot *io_get_notif_slot(struct io_ring_ctx *ctx,
+						      int idx)
+	__must_hold(&ctx->uring_lock)
+{
+	if (idx >= ctx->nr_notif_slots)
+		return NULL;
+	idx = array_index_nospec(idx, ctx->nr_notif_slots);
+	return &ctx->notif_slots[idx];
+}
+
+static void io_notif_slot_flush(struct io_notif_slot *slot)
+	__must_hold(&ctx->uring_lock)
+{
+	struct io_notif *notif = slot->notif;
+
+	slot->notif = NULL;
+
+	if (WARN_ON_ONCE(in_interrupt()))
+		return;
+	/* drop slot's master ref */
+	if (refcount_dec_and_test(&notif->uarg.refcnt))
+		io_notif_complete(notif);
+}
+
+static __cold int io_notif_unregister(struct io_ring_ctx *ctx)
+	__must_hold(&ctx->uring_lock)
+{
+	int i;
+
+	if (!ctx->notif_slots)
+		return -ENXIO;
+
+	for (i = 0; i < ctx->nr_notif_slots; i++) {
+		struct io_notif_slot *slot = &ctx->notif_slots[i];
+
+		if (slot->notif)
+			io_notif_slot_flush(slot);
+	}
+
+	kvfree(ctx->notif_slots);
+	ctx->notif_slots = NULL;
+	ctx->nr_notif_slots = 0;
+	return 0;
+}
+
 static inline void io_remove_next_linked(struct io_kiocb *req)
 {
 	struct io_kiocb *nxt = req->link;
@@ -11174,6 +11328,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	}
 #endif
 	WARN_ON_ONCE(!list_empty(&ctx->ltimeout_list));
+	WARN_ON_ONCE(ctx->notif_slots || ctx->nr_notif_slots);
 
 	io_mem_free(ctx->rings);
 	io_mem_free(ctx->sq_sqes);
@@ -11368,6 +11523,7 @@ static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 		__io_cqring_overflow_flush(ctx, true);
 	xa_for_each(&ctx->personalities, index, creds)
 		io_unregister_personality(ctx, index);
+	io_notif_unregister(ctx);
 	mutex_unlock(&ctx->uring_lock);
 
 	/* failed during ring init, it couldn't have issued any requests */
-- 
2.36.1

