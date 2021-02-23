Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49CE3229CE
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 13:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbhBWLyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 06:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbhBWLxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 06:53:12 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAF1C06178C
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 03:51:49 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id t29so8604354pfg.11
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 03:51:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c3yBROiXapYXwEB1EPrfm+Nn9EEmtLH7D5B0d4oZlD4=;
        b=yGAHM8CXAX/x224wjeWCQAdixy7fpHoGLdsZfgNfS/gc7Vsv1CMk83cLMhmqBbU78u
         F7/x93MGjcQvvo1ZeiDs4pZOazPlpnHThYBXANWVPpUvXakoz3duDUKs66lbYhshiqck
         Vl8s010niUh8rCEDp2+4PAEVavuqnqjQo5fwfVAqkPCKcXCfoYOWMwBs94oLtXS2kAnX
         CteuR3/gRPG/nabtf6uiiOqLZcNe/zTTa5iwfcz5k8mPtzr3BXzLXuKFt+85uzhTyDqq
         cg4ng/58CgyFL3HinNfWnwCG3wSdZevKQb4eaj6iaO9sd24moq/n/tOdZ9kiZmHHhIBb
         O5gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c3yBROiXapYXwEB1EPrfm+Nn9EEmtLH7D5B0d4oZlD4=;
        b=tQ8KyakanR9Sb+e93ORCnxrlsBIGMBvbx17tbmKWk5upCXW9m7QC9j/20ypMf5So+0
         Sw2t/2SQNsevXEA6+AFCvPEHt7BW9+W9Z2ljeFSmJ1tJ0bn8becwNMxMa4D/Q8A6muWU
         gRGOBecfyf0YZ6hf9lzWuG2wcuRKAj1sPKJ64Tomi0lC0a/dfikkIOjpWv0OGRJotC3i
         95Rkmc6hoJZd8AI6YXHK4K/ctY0eWzeXDZaS97hh7D8TOLyIjT5IKhwWvj3F7HsH0ASf
         Tj2IC1zx71yZ5K2kdqcwWVnAKanrh5xnkFCioNX7ahpE2z4lzQvTwNL/v31lvD1hyk9p
         jBRQ==
X-Gm-Message-State: AOAM532GBcdUPr9uw9zXykvr32xwHgyMBJNmDbgkikbJbuh36YVPBX2r
        ZrSGMZXxGZkQ968WbPqTZYWH
X-Google-Smtp-Source: ABdhPJwAHNMqoT+iE+s8fClzO6jv2nzIUjZdtdu3bpXHD3CThaZLgO4WvJzwBPfwmbfWQrMRm/TBkw==
X-Received: by 2002:a65:4947:: with SMTP id q7mr11508562pgs.83.1614081109248;
        Tue, 23 Feb 2021 03:51:49 -0800 (PST)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id l15sm3001657pjq.9.2021.02.23.03.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 03:51:48 -0800 (PST)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, bob.liu@oracle.com,
        hch@infradead.org, rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: [RFC v4 01/11] eventfd: Increase the recursion depth of eventfd_signal()
Date:   Tue, 23 Feb 2021 19:50:38 +0800
Message-Id: <20210223115048.435-2-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210223115048.435-1-xieyongji@bytedance.com>
References: <20210223115048.435-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Increase the recursion depth of eventfd_signal() to 1. This
is the maximum recursion depth we have found so far.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 fs/eventfd.c            | 2 +-
 include/linux/eventfd.h | 5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index e265b6dd4f34..cc7cd1dbedd3 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -71,7 +71,7 @@ __u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
 	 * it returns true, the eventfd_signal() call should be deferred to a
 	 * safe context.
 	 */
-	if (WARN_ON_ONCE(this_cpu_read(eventfd_wake_count)))
+	if (WARN_ON_ONCE(this_cpu_read(eventfd_wake_count) > EFD_WAKE_DEPTH))
 		return 0;
 
 	spin_lock_irqsave(&ctx->wqh.lock, flags);
diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index fa0a524baed0..886d99cd38ef 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -29,6 +29,9 @@
 #define EFD_SHARED_FCNTL_FLAGS (O_CLOEXEC | O_NONBLOCK)
 #define EFD_FLAGS_SET (EFD_SHARED_FCNTL_FLAGS | EFD_SEMAPHORE)
 
+/* Maximum recursion depth */
+#define EFD_WAKE_DEPTH 1
+
 struct eventfd_ctx;
 struct file;
 
@@ -47,7 +50,7 @@ DECLARE_PER_CPU(int, eventfd_wake_count);
 
 static inline bool eventfd_signal_count(void)
 {
-	return this_cpu_read(eventfd_wake_count);
+	return this_cpu_read(eventfd_wake_count) > EFD_WAKE_DEPTH;
 }
 
 #else /* CONFIG_EVENTFD */
-- 
2.11.0

