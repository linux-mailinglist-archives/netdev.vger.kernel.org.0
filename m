Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDEF2FB469
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 09:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388083AbhASFWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 00:22:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbhASFFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 00:05:19 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C0CAC061757
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 21:04:38 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id w18so228900pfu.9
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 21:04:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hq6cLGhX+YOdloZCBCv76n2UjaYC8NZfkFs6/p+ZtOg=;
        b=W8y876Dbq8gZuEg5QYXKhKTizoMMwtFxcmKeIZtDQdx+XEt3dW/eHtSMhQvknQYW4K
         DnsCpn+GirhCRLFyk/uVDaIJoXZgyWsH6gU53zdrGPud9lsener1pfIQEwdiCZRktfE+
         Ne1ZR7dli2HUDcE+3V2rbyvftav5V4WgBCwhpQ0bHoynV0GboyaGO/cjnRSZdzh0GmFw
         r/A5ZX/PxqxanTpbUqh+VaClMqoh4p4eePPZY6MRWFJ7BiyHJsTxQWwUiwGliuSOKvLc
         PCreg4kS3gTI+lm3d0KE5HrHAWJ4B0/fMhjVOWrn+u+7Kwg0P9wxlbpTSDhJDbdRaU+G
         Y9Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hq6cLGhX+YOdloZCBCv76n2UjaYC8NZfkFs6/p+ZtOg=;
        b=pjLbHlIqF9K+ivhswjPY+SGjfra4sSsqKGhEGJCfANM8eQUCh/gECAqic4xG2klpoX
         JrlWmjnNLOqHI+FsEFE44binm4NparNo5vLhMkdK0WENJfX0q2ZXE9Tw3QDWiiF6E69O
         06xqFSrDMEE78JdUeUIvfEm2v7NO+9vp7qqM1U7qLmUMKUR79q2pPdzUsk1prFvcX6uc
         cL3V7K/4iri6QxEenp0sKuYF+30i1UWEYErZkJSUheU8st4TiuuOV6zrUnIINv1+zJ3a
         o9XQN4jpdipx6rcqIdmcyM2R8zIikG2ye/Ab7Nn5d51dOKJwIAmk1COXAXEj/SKVBUlq
         jkZg==
X-Gm-Message-State: AOAM533SPfOq1QpFfDt48YUko5VGu1c9zIoaN/aPZGQiOZwf5ZgzhEXj
        R80NvvgdzpjbGidelFF5xhYN
X-Google-Smtp-Source: ABdhPJwhMmXGRAF9exzwdYFbs4DDh7HaNjaSgRVmLvyUt1TO1CzzbUW14r26LDKrseM7tbJ/BRrzFA==
X-Received: by 2002:a62:ddcd:0:b029:1a6:99ff:a75e with SMTP id w196-20020a62ddcd0000b02901a699ffa75emr2486197pff.42.1611032678076;
        Mon, 18 Jan 2021 21:04:38 -0800 (PST)
Received: from localhost ([139.177.225.243])
        by smtp.gmail.com with ESMTPSA id gv22sm1047509pjb.56.2021.01.18.21.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 21:04:37 -0800 (PST)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, bob.liu@oracle.com,
        hch@infradead.org, rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: [RFC v3 01/11] eventfd: track eventfd_signal() recursion depth separately in different cases
Date:   Tue, 19 Jan 2021 12:59:10 +0800
Message-Id: <20210119045920.447-2-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210119045920.447-1-xieyongji@bytedance.com>
References: <20210119045920.447-1-xieyongji@bytedance.com>
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

