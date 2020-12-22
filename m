Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D382A2E0C15
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 15:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbgLVOy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 09:54:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727633AbgLVOyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 09:54:25 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC05C061248
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 06:53:17 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 15so8496706pgx.7
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 06:53:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hq6cLGhX+YOdloZCBCv76n2UjaYC8NZfkFs6/p+ZtOg=;
        b=y40ttjV/YgM4wvX349wPEo/KuCxAMjRA2ZGiQMlh4+FFb89YrcRj657ZyIInGzamOW
         0vfsCDqIluk6oIsB2jIj87YdKSM/exKmrbFfY4NkHc0YRPVvxD1OzSOfHVxKTOTiLzAd
         tDe5wUQyRxNUbx5fMBoA8omQ1MJbSMpIFuetQZnAfhieIp+CYT7UAaOXwKoXffCnem1D
         3V0DJz+Bxy3VchfzYjJwwfj5DFYGxerszby07BkOCNCactVeA6L6eyBtoh7l4VcAwVVM
         ghNSomkizu0oUUr2IPwpiyVTKNdcXxHRdQYbXfIxvKEvTvFlRJik1/kfoVSrotdEaDwp
         YYmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hq6cLGhX+YOdloZCBCv76n2UjaYC8NZfkFs6/p+ZtOg=;
        b=LIf/uzzpA3WNGfrtsFt8aLbUsqnZ7CquQhKHewZrOn6abtypsaqqNNXQxqi5ZQxzCi
         zT42XLojkFurjB0NQIaNk4VFv69UevIunRLDk2f8VjZzY+ADcStlzoOeZ+tGUnfdIOYk
         iHEbLKVsCbX16vqUYNtFsuHv0taHJ6oK7qFmZDXbW9sbD8TMWe8/NOS5jipqAmI8wG1w
         h/gBzib6Lmu/lf60dEnLnEQq61nmAHGyL2LV+X+SMjzrDaiRwovM/wtcg4nPN76bNKRg
         hCxIiAHldcJX6Idme7guKiMTtOoXDZxovWRcsIsCU9uaksUCL04wjZIT3eBWKcA7RdiU
         tSmg==
X-Gm-Message-State: AOAM53260DinswUgD4palXaa8G0Hr4LFnA9mxNlbzSM69UMbAaZLZySL
        evt+ccori/dmXONgpLCGIRJ2
X-Google-Smtp-Source: ABdhPJwOIJpirmt9ZpOuYali2BMic+XSa8v1hT8Vzzl1Qawx8gam4Ow7LO4po33/t7B2y9SJvYO7HQ==
X-Received: by 2002:a63:a516:: with SMTP id n22mr19707227pgf.125.1608648797542;
        Tue, 22 Dec 2020 06:53:17 -0800 (PST)
Received: from localhost ([139.177.225.248])
        by smtp.gmail.com with ESMTPSA id h12sm6357200pgk.70.2020.12.22.06.53.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 06:53:17 -0800 (PST)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, akpm@linux-foundation.org,
        rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: [RFC v2 02/13] eventfd: track eventfd_signal() recursion depth separately in different cases
Date:   Tue, 22 Dec 2020 22:52:10 +0800
Message-Id: <20201222145221.711-3-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201222145221.711-1-xieyongji@bytedance.com>
References: <20201222145221.711-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now we have a global percpu counter to limit the recursion depth
of eventfd_signal(). This can avoid deadlock or stack overflow.
But in stack overflow case, it should be OK to increase the
recursion depth if needed. So we add a percpu counter in eventfd_ctx
to limit the recursion depth for deadlock case. Then it could be
fine to increase the global percpu counter later.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 fs/aio.c                |  3 ++-
 fs/eventfd.c            | 20 +++++++++++++++++++-
 include/linux/eventfd.h |  5 +----
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 1f32da13d39e..5d82903161f5 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1698,7 +1698,8 @@ static int aio_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 		list_del(&iocb->ki_list);
 		iocb->ki_res.res = mangle_poll(mask);
 		req->done = true;
-		if (iocb->ki_eventfd && eventfd_signal_count()) {
+		if (iocb->ki_eventfd &&
+			eventfd_signal_count(iocb->ki_eventfd)) {
 			iocb = NULL;
 			INIT_WORK(&req->work, aio_poll_put_work);
 			schedule_work(&req->work);
diff --git a/fs/eventfd.c b/fs/eventfd.c
index e265b6dd4f34..2df24f9bada3 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -25,6 +25,8 @@
 #include <linux/idr.h>
 #include <linux/uio.h>
 
+#define EVENTFD_WAKE_DEPTH 0
+
 DEFINE_PER_CPU(int, eventfd_wake_count);
 
 static DEFINE_IDA(eventfd_ida);
@@ -42,9 +44,17 @@ struct eventfd_ctx {
 	 */
 	__u64 count;
 	unsigned int flags;
+	int __percpu *wake_count;
 	int id;
 };
 
+bool eventfd_signal_count(struct eventfd_ctx *ctx)
+{
+	return (this_cpu_read(*ctx->wake_count) ||
+		this_cpu_read(eventfd_wake_count) > EVENTFD_WAKE_DEPTH);
+}
+EXPORT_SYMBOL_GPL(eventfd_signal_count);
+
 /**
  * eventfd_signal - Adds @n to the eventfd counter.
  * @ctx: [in] Pointer to the eventfd context.
@@ -71,17 +81,19 @@ __u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
 	 * it returns true, the eventfd_signal() call should be deferred to a
 	 * safe context.
 	 */
-	if (WARN_ON_ONCE(this_cpu_read(eventfd_wake_count)))
+	if (WARN_ON_ONCE(eventfd_signal_count(ctx)))
 		return 0;
 
 	spin_lock_irqsave(&ctx->wqh.lock, flags);
 	this_cpu_inc(eventfd_wake_count);
+	this_cpu_inc(*ctx->wake_count);
 	if (ULLONG_MAX - ctx->count < n)
 		n = ULLONG_MAX - ctx->count;
 	ctx->count += n;
 	if (waitqueue_active(&ctx->wqh))
 		wake_up_locked_poll(&ctx->wqh, EPOLLIN);
 	this_cpu_dec(eventfd_wake_count);
+	this_cpu_dec(*ctx->wake_count);
 	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
 
 	return n;
@@ -92,6 +104,7 @@ static void eventfd_free_ctx(struct eventfd_ctx *ctx)
 {
 	if (ctx->id >= 0)
 		ida_simple_remove(&eventfd_ida, ctx->id);
+	free_percpu(ctx->wake_count);
 	kfree(ctx);
 }
 
@@ -423,6 +436,11 @@ static int do_eventfd(unsigned int count, int flags)
 
 	kref_init(&ctx->kref);
 	init_waitqueue_head(&ctx->wqh);
+	ctx->wake_count = alloc_percpu(int);
+	if (!ctx->wake_count) {
+		kfree(ctx);
+		return -ENOMEM;
+	}
 	ctx->count = count;
 	ctx->flags = flags;
 	ctx->id = ida_simple_get(&eventfd_ida, 0, 0, GFP_KERNEL);
diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index fa0a524baed0..1a11ebbd74a9 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -45,10 +45,7 @@ void eventfd_ctx_do_read(struct eventfd_ctx *ctx, __u64 *cnt);
 
 DECLARE_PER_CPU(int, eventfd_wake_count);
 
-static inline bool eventfd_signal_count(void)
-{
-	return this_cpu_read(eventfd_wake_count);
-}
+bool eventfd_signal_count(struct eventfd_ctx *ctx);
 
 #else /* CONFIG_EVENTFD */
 
-- 
2.11.0

