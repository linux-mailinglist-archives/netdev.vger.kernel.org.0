Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38AF81CA069
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 03:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgEHB6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 21:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726518AbgEHB6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 21:58:15 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E683DC05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 18:58:14 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id o134so104265yba.18
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 18:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=/BklOOKF51ZkWBYaNoHeAcL1OcPZb8WIGG/ZWjim6uQ=;
        b=KI+uOzD369zGgzzDt5AkE2uRmyN2jTGwHtvdaN+f+5QyX5viwQhnCn1RgUanBLw88W
         vqJJW6/UvZL+D8mrcS4qIOH8JcGONI3Ze/gcRJeNGaqJdAH9eI1FIIYo8n9lm1AK4n4f
         F3QmguC7lWqlHzE+DolWt59lZMDgU/bNsaOimH/62R3kFX/VRTaTcIrD5vlAYJoC5SUN
         sUL1ezs9pRSCz9ZhPAlcMRcyhcKaXDtB9I69+jR0rYPpb6h4zy/F0rhuqo4V7cNKjZM1
         VKysGGPP5ofsV7TyBXuonKu+7XyCzw7GuTLhrWb1xaqesPdN3urcmbpLsSuVQ46g2d0g
         UFWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=/BklOOKF51ZkWBYaNoHeAcL1OcPZb8WIGG/ZWjim6uQ=;
        b=Q/J+Srahqn1t6ulaQjrDI2D4R6Bjg0pNZFyoM+HXjwAiRm7okUHENY9m5cz5m1pOKF
         FLSpKDSjLGrFp+K8uvjvoL0WtREBwPOswDllaNpv/4wtcC9rCIEVKLUXa7EJqT3N9m7T
         CFRLg9+ZqV0TmhQou2YwTa4U1xpJn9XoYxP5Jf2dL3fFcICmXp0/Wn8xgUNnzG+UHddj
         9ENl7WN6TVM970AOrvRQGOF8CtgZyK6eBRwJN3MadgqTjlS/NQWm/uWGisP+131t2VQW
         8LqchiPTFh8SKo7fY4c8m6I4aJojW8VksnCZlZRyqPt5wQs44fPWaJlzHV7biQsXkpP/
         6vjg==
X-Gm-Message-State: AGi0PuY1V2KlHHxUgP7jSA9F62eAE7wDm/WcAVOSCbrC0cJBGpT6We9k
        t0oJzMN3dBWqr+zjNl5Z/7HGVemxY/5JIg==
X-Google-Smtp-Source: APiQypI0t+Id8CPQjDfkxUbws7BkGbCWUXDfFJFSSqXp1jKB6lnGWEKNngpzjct05dEWDv+9+NYvyqs9xWMcZA==
X-Received: by 2002:a25:3252:: with SMTP id y79mr929116yby.274.1588903094101;
 Thu, 07 May 2020 18:58:14 -0700 (PDT)
Date:   Thu,  7 May 2020 18:58:10 -0700
Message-Id: <20200508015810.46023-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.645.ge9eca65c58-goog
Subject: [PATCH net-next] net/dst: use a smaller percpu_counter batch for dst
 entries accounting
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

percpu_counter_add() uses a default batch size which is quite big
on platforms with 256 cpus. (2*256 -> 512)

This means dst_entries_get_fast() can be off by +/- 2*(nr_cpus^2)
(131072 on servers with 256 cpus)

Reduce the batch size to something more reasonable, and
add logic to ip6_dst_gc() to call dst_entries_get_slow()
before calling the _very_ expensive fib6_run_gc() function.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/dst_ops.h | 4 +++-
 net/core/dst.c        | 8 ++++----
 net/ipv6/route.c      | 3 +++
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/net/dst_ops.h b/include/net/dst_ops.h
index 443863c7b8da362476c15fd290ac2a32a8aa86e3..88ff7bb2bb9bd950cc54fd5e0ae4573d4c66873d 100644
--- a/include/net/dst_ops.h
+++ b/include/net/dst_ops.h
@@ -53,9 +53,11 @@ static inline int dst_entries_get_slow(struct dst_ops *dst)
 	return percpu_counter_sum_positive(&dst->pcpuc_entries);
 }
 
+#define DST_PERCPU_COUNTER_BATCH 32
 static inline void dst_entries_add(struct dst_ops *dst, int val)
 {
-	percpu_counter_add(&dst->pcpuc_entries, val);
+	percpu_counter_add_batch(&dst->pcpuc_entries, val,
+				 DST_PERCPU_COUNTER_BATCH);
 }
 
 static inline int dst_entries_init(struct dst_ops *dst)
diff --git a/net/core/dst.c b/net/core/dst.c
index 193af526e908afa4b868cf128470f0fbc3850698..d6b6ced0d451a39c0ccb88ae39dba225ea9f5705 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -81,11 +81,11 @@ void *dst_alloc(struct dst_ops *ops, struct net_device *dev,
 {
 	struct dst_entry *dst;
 
-	if (ops->gc && dst_entries_get_fast(ops) > ops->gc_thresh) {
+	if (ops->gc &&
+	    !(flags & DST_NOCOUNT) &&
+	    dst_entries_get_fast(ops) > ops->gc_thresh) {
 		if (ops->gc(ops)) {
-			printk_ratelimited(KERN_NOTICE "Route cache is full: "
-					   "consider increasing sysctl "
-					   "net.ipv[4|6].route.max_size.\n");
+			pr_notice_ratelimited("Route cache is full: consider increasing sysctl net.ipv6.route.max_size.\n");
 			return NULL;
 		}
 	}
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 1ff142393c768f85c495474a1d05e1ae1642301c..a9072dba00f4fb0b61bce1fc0f44a3a81ba702fa 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3195,6 +3195,9 @@ static int ip6_dst_gc(struct dst_ops *ops)
 	int entries;
 
 	entries = dst_entries_get_fast(ops);
+	if (entries > rt_max_size)
+		entries = dst_entries_get_slow(ops);
+
 	if (time_after(rt_last_gc + rt_min_interval, jiffies) &&
 	    entries <= rt_max_size)
 		goto out;
-- 
2.26.2.645.ge9eca65c58-goog

