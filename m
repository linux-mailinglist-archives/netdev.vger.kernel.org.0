Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B13DF470BD3
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 21:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238623AbhLJUdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 15:33:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234738AbhLJUdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 15:33:38 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 439DFC061746;
        Fri, 10 Dec 2021 12:30:02 -0800 (PST)
Date:   Fri, 10 Dec 2021 21:29:59 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639168200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=wPN+XRGlttXQr842Y5fUhZgvaYSbPwRGAglIQKEtKmY=;
        b=RBT+FkM9ExGg4qN/hACB/eQnuavpOvYQ/FAhMWC76u5gxHGqYQgTD1VjPTFFRU14jwT2Ur
        epqHBFSpcry1DgHLFzNqDteJ/o7LzG51FM1vo9KJK7aIxh6WF4NdoFDzQERdvIB7cWdHtM
        3UrHooSPLdbueCN/Hlzm02lfUzvI8Uq9f7feVGlQIu14hl5BCC1YRlSx4M10FO774aNvlg
        FdSr3CIojMhw3D1vhwkMQ/WSQfiflzy4PhZIYH31aNfBQdMrcQfVqQXv9Z8kfxZmRekkHu
        ixRL75Nxllcj9M/LlrRhdNHT9pod2LOjMCond3vqmZJAJXB1r2M3B3WY9golvw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639168200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=wPN+XRGlttXQr842Y5fUhZgvaYSbPwRGAglIQKEtKmY=;
        b=vjmrJhHXmWpSoVHXzLQ7bfYd0tWOdXeXhWwBObUJEkb8meHYExEhCrVuj9Hk7YIZISbHaX
        YVBVqJv3hgG8WdCw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next] u64_stats: Disable preemption on 32bit UP+SMP
 PREEMPT_RT during updates.
Message-ID: <YbO4x7vRoDGUWxrv@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On PREEMPT_RT the seqcount_t for synchronisation is required on 32bit
architectures even on UP because the softirq (and the threaded IRQ handler) can
be preempted.

With the seqcount_t for synchronisation, a reader with higher priority can
preempt the writer and then spin endlessly in read_seqcount_begin() while the
writer can't make progress.

To avoid such a lock up on PREEMPT_RT the writer must disable preemption during
the update. There is no need to disable interrupts because no writer is using
this API in hard-IRQ context on PREEMPT_RT.

Disable preemption on 32bit-RT within the u64_stats write section.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/u64_stats_sync.h |   42 +++++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 14 deletions(-)

--- a/include/linux/u64_stats_sync.h
+++ b/include/linux/u64_stats_sync.h
@@ -66,7 +66,7 @@
 #include <linux/seqlock.h>
 
 struct u64_stats_sync {
-#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
+#if BITS_PER_LONG == 32 && (defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT))
 	seqcount_t	seq;
 #endif
 };
@@ -125,7 +125,7 @@ static inline void u64_stats_inc(u64_sta
 }
 #endif
 
-#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
+#if BITS_PER_LONG == 32 && (defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT))
 #define u64_stats_init(syncp)	seqcount_init(&(syncp)->seq)
 #else
 static inline void u64_stats_init(struct u64_stats_sync *syncp)
@@ -135,15 +135,19 @@ static inline void u64_stats_init(struct
 
 static inline void u64_stats_update_begin(struct u64_stats_sync *syncp)
 {
-#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
+#if BITS_PER_LONG == 32 && (defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT))
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_disable();
 	write_seqcount_begin(&syncp->seq);
 #endif
 }
 
 static inline void u64_stats_update_end(struct u64_stats_sync *syncp)
 {
-#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
+#if BITS_PER_LONG == 32 && (defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT))
 	write_seqcount_end(&syncp->seq);
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_enable();
 #endif
 }
 
@@ -152,8 +156,11 @@ u64_stats_update_begin_irqsave(struct u6
 {
 	unsigned long flags = 0;
 
-#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
-	local_irq_save(flags);
+#if BITS_PER_LONG == 32 && (defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT))
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_disable();
+	else
+		local_irq_save(flags);
 	write_seqcount_begin(&syncp->seq);
 #endif
 	return flags;
@@ -163,15 +170,18 @@ static inline void
 u64_stats_update_end_irqrestore(struct u64_stats_sync *syncp,
 				unsigned long flags)
 {
-#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
+#if BITS_PER_LONG == 32 && (defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT))
 	write_seqcount_end(&syncp->seq);
-	local_irq_restore(flags);
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_enable();
+	else
+		local_irq_restore(flags);
 #endif
 }
 
 static inline unsigned int __u64_stats_fetch_begin(const struct u64_stats_sync *syncp)
 {
-#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
+#if BITS_PER_LONG == 32 && (defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT))
 	return read_seqcount_begin(&syncp->seq);
 #else
 	return 0;
@@ -180,7 +190,7 @@ static inline unsigned int __u64_stats_f
 
 static inline unsigned int u64_stats_fetch_begin(const struct u64_stats_sync *syncp)
 {
-#if BITS_PER_LONG==32 && !defined(CONFIG_SMP)
+#if BITS_PER_LONG == 32 && (!defined(CONFIG_SMP) && !defined(CONFIG_PREEMPT_RT))
 	preempt_disable();
 #endif
 	return __u64_stats_fetch_begin(syncp);
@@ -189,7 +199,7 @@ static inline unsigned int u64_stats_fet
 static inline bool __u64_stats_fetch_retry(const struct u64_stats_sync *syncp,
 					 unsigned int start)
 {
-#if BITS_PER_LONG==32 && defined(CONFIG_SMP)
+#if BITS_PER_LONG == 32 && (defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT))
 	return read_seqcount_retry(&syncp->seq, start);
 #else
 	return false;
@@ -199,7 +209,7 @@ static inline bool __u64_stats_fetch_ret
 static inline bool u64_stats_fetch_retry(const struct u64_stats_sync *syncp,
 					 unsigned int start)
 {
-#if BITS_PER_LONG==32 && !defined(CONFIG_SMP)
+#if BITS_PER_LONG == 32 && (!defined(CONFIG_SMP) && !defined(CONFIG_PREEMPT_RT))
 	preempt_enable();
 #endif
 	return __u64_stats_fetch_retry(syncp, start);
@@ -213,7 +223,9 @@ static inline bool u64_stats_fetch_retry
  */
 static inline unsigned int u64_stats_fetch_begin_irq(const struct u64_stats_sync *syncp)
 {
-#if BITS_PER_LONG==32 && !defined(CONFIG_SMP)
+#if BITS_PER_LONG == 32 && defined(CONFIG_PREEMPT_RT)
+	preempt_disable();
+#elif BITS_PER_LONG == 32 && !defined(CONFIG_SMP)
 	local_irq_disable();
 #endif
 	return __u64_stats_fetch_begin(syncp);
@@ -222,7 +234,9 @@ static inline unsigned int u64_stats_fet
 static inline bool u64_stats_fetch_retry_irq(const struct u64_stats_sync *syncp,
 					     unsigned int start)
 {
-#if BITS_PER_LONG==32 && !defined(CONFIG_SMP)
+#if BITS_PER_LONG == 32 && defined(CONFIG_PREEMPT_RT)
+	preempt_enable();
+#elif BITS_PER_LONG == 32 && !defined(CONFIG_SMP)
 	local_irq_enable();
 #endif
 	return __u64_stats_fetch_retry(syncp, start);
