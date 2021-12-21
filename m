Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0F1547C316
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 16:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239770AbhLUPgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 10:36:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239663AbhLUPgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 10:36:25 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96F8C0613A5;
        Tue, 21 Dec 2021 07:36:15 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id v7so20402087wrv.12;
        Tue, 21 Dec 2021 07:36:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v4kTxKKEwyXqjrRhwS7ceqX/Ds1FYWK7l8ES+nNlj2Q=;
        b=gG94ByIHFLtwgV+EjMKRAT6fVgrHLNiHSV9kMz6/qirIeT8g3fpRpeMoBC9U3a4VZP
         gj0tEQP1kWSoC4GJrmi/WxFMZaypaUlIc5HW5wsgx1ToCr12/BUohB4cRw2/HzsIINbP
         3hd8TjkZ0gD3ctUvnTEa1VGTi9ITWZfwtY9Xqgmw9EctyEwpUY2K+Q+o1n2GOnY0CbFX
         Ia9mSXrsysucQ4kFt0K8+PYorYmxaKb7U7NXu8zVunJzNDIXTb604p4sFH1Rvym2ZfGO
         JSU5I+Ize/hZIHfOhPVo52Wla6YB3qWr6GU6V5vbFkXhnP2T7DjnKzen7Qw91rdFICvt
         lNgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v4kTxKKEwyXqjrRhwS7ceqX/Ds1FYWK7l8ES+nNlj2Q=;
        b=XJHM/diKUCBJzTREqo58vp1XBVB0HQLe/EONtyWoDiWoCVHhpOH+LcEmA9EXWbloVK
         kWJ9X1+ycPS5D3dfnXu4Q/+vfwPmTq5xYcFV1iUgkpZROpOcRCe6SDDf19H/QdWebXFX
         E7AVqeE6vzjDOZvZC2R3JhJ62El7O9KYkXeiFqtAC+dgcRQ1MfCjwwNUCIEqjpyAHnoN
         hVAacjQ20jR2LM0seTFMOyeKObORipZusyONDtOuC7AZ8aMETPpwU4waShFjZLySD7Pr
         L4AQjOBX5jHXhdu9cUGVuGJkQPkYs0bG+D0jVQEzt3ngJFhxtT+ayAyDx1jRLk65i3qa
         N03Q==
X-Gm-Message-State: AOAM533aVR25+ek7cnpECKvXSDJLgobl4lo2mObN2p7F490ZxEgkVvd4
        9QuDbohLmVyJLg3sgx0bUmjThGgYpuE=
X-Google-Smtp-Source: ABdhPJxPHkS9UDWxKBHDmpMid1sA3hRhm3+nxdOKKaZh1a5ZgBB7Q2I4r8iXpH3PNiGlnCWzoiv0tw==
X-Received: by 2002:a05:6000:188c:: with SMTP id a12mr3276913wri.45.1640100974106;
        Tue, 21 Dec 2021 07:36:14 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.24])
        by smtp.gmail.com with ESMTPSA id z11sm2946019wmf.9.2021.12.21.07.36.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 07:36:13 -0800 (PST)
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
Subject: [RFC v2 18/19] io_uring: task_work for notification delivery
Date:   Tue, 21 Dec 2021 15:35:40 +0000
Message-Id: <33b943a2409dc1c4ad845ea0bebb76ecad723ef6.1640029579.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1640029579.git.asml.silence@gmail.com>
References: <cover.1640029579.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

workqueues are way too heavy for tx notification delivery. We still
need some non-irq context because ->completion_lock is not irq-safe, so
use task_work instead. Expectedly, performance for test cases with real
hardware and juggling lots of notifications the perfomance is
drastically better, e.g. profiles percetage of relevant parts drops
from 30% to less than 3%

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 57 ++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 43 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8cfa8ea161e4..ee496b463462 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -330,11 +330,16 @@ struct io_submit_state {
 
 struct io_tx_notifier {
 	struct ubuf_info	uarg;
-	struct work_struct	commit_work;
 	struct percpu_ref	*fixed_rsrc_refs;
 	u64			tag;
 	u32			seq;
 	struct list_head	cache_node;
+	struct task_struct	*task;
+
+	union {
+		struct callback_head	task_work;
+		struct work_struct	commit_work;
+	};
 };
 
 struct io_tx_ctx {
@@ -1965,19 +1970,17 @@ static noinline bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data,
 	return __io_fill_cqe(ctx, user_data, res, cflags);
 }
 
-static void io_zc_tx_work_callback(struct work_struct *work)
+static void io_zc_tx_notifier_finish(struct callback_head *cb)
 {
-	struct io_tx_notifier *notifier = container_of(work, struct io_tx_notifier,
-						       commit_work);
+	struct io_tx_notifier *notifier = container_of(cb, struct io_tx_notifier,
+						       task_work);
 	struct io_ring_ctx *ctx = notifier->uarg.ctx;
 	struct percpu_ref *rsrc_refs = notifier->fixed_rsrc_refs;
 
 	spin_lock(&ctx->completion_lock);
 	io_fill_cqe_aux(ctx, notifier->tag, notifier->seq, 0);
-
 	list_add(&notifier->cache_node, &ctx->ubuf_list_locked);
 	ctx->ubuf_locked_nr++;
-
 	io_commit_cqring(ctx);
 	spin_unlock(&ctx->completion_lock);
 	io_cqring_ev_posted(ctx);
@@ -1985,6 +1988,14 @@ static void io_zc_tx_work_callback(struct work_struct *work)
 	percpu_ref_put(rsrc_refs);
 }
 
+static void io_zc_tx_work_callback(struct work_struct *work)
+{
+	struct io_tx_notifier *notifier = container_of(work, struct io_tx_notifier,
+						       commit_work);
+
+	io_zc_tx_notifier_finish(&notifier->task_work);
+}
+
 static void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
 					  struct ubuf_info *uarg,
 					  bool success)
@@ -1994,21 +2005,39 @@ static void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
 
 	if (!refcount_dec_and_test(&uarg->refcnt))
 		return;
+	if (unlikely(!notifier->task))
+		goto fallback;
 
-	if (in_interrupt()) {
-		INIT_WORK(&notifier->commit_work, io_zc_tx_work_callback);
-		queue_work(system_unbound_wq, &notifier->commit_work);
-	} else {
-		io_zc_tx_work_callback(&notifier->commit_work);
+	put_task_struct(notifier->task);
+	notifier->task = NULL;
+
+	if (!in_interrupt()) {
+		io_zc_tx_notifier_finish(&notifier->task_work);
+		return;
 	}
+
+	init_task_work(&notifier->task_work, io_zc_tx_notifier_finish);
+	if (likely(!task_work_add(notifier->task, &notifier->task_work,
+				  TWA_SIGNAL)))
+		return;
+
+fallback:
+	INIT_WORK(&notifier->commit_work, io_zc_tx_work_callback);
+	queue_work(system_unbound_wq, &notifier->commit_work);
 }
 
-static void io_tx_kill_notification(struct io_tx_ctx *tx_ctx)
+static inline void __io_tx_kill_notification(struct io_tx_ctx *tx_ctx)
 {
 	io_uring_tx_zerocopy_callback(NULL, &tx_ctx->notifier->uarg, true);
 	tx_ctx->notifier = NULL;
 }
 
+static inline void io_tx_kill_notification(struct io_tx_ctx *tx_ctx)
+{
+	tx_ctx->notifier->task = get_task_struct(current);
+	__io_tx_kill_notification(tx_ctx);
+}
+
 static void io_notifier_splice(struct io_ring_ctx *ctx)
 {
 	spin_lock(&ctx->completion_lock);
@@ -2058,7 +2087,7 @@ static struct io_tx_notifier *io_alloc_tx_notifier(struct io_ring_ctx *ctx,
 	} else {
 		gfp_t gfp_flags = GFP_ATOMIC|GFP_KERNEL_ACCOUNT;
 
-		notifier = kmalloc(sizeof(*notifier), gfp_flags);
+		notifier = kzalloc(sizeof(*notifier), gfp_flags);
 		if (!notifier)
 			return NULL;
 		ctx->nr_tx_ctx++;
@@ -9502,7 +9531,7 @@ static void io_sqe_tx_ctx_kill_ubufs(struct io_ring_ctx *ctx)
 		tx_ctx = &ctx->tx_ctxs[i];
 
 		if (tx_ctx->notifier)
-			io_tx_kill_notification(tx_ctx);
+			__io_tx_kill_notification(tx_ctx);
 	}
 }
 
-- 
2.34.1

