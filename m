Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 734DE59743A
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 18:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241076AbiHQQ1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 12:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241015AbiHQQ1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 12:27:42 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C349A0605;
        Wed, 17 Aug 2022 09:27:40 -0700 (PDT)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1660753658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b0RhUT9EfZg6coERnTROD4jwiSNyrMmoG56LL3GmvfY=;
        b=WwwANwzJPfzo8t2RuMJOkr6DXKZBTFcwoIrgsgHJvORVcs0U3Z6NgzlOtQiyUywSYtrqaW
        +xb7dEDgshLDybFMmhyFshYh1C2a4ivRVFdfHs1r5L/Cvl6E0apBryUS5843pt680Q/AOH
        zDBFBnbprVpYvq0ojehD4DBV2bkKdTxus7C3qubvC9hmZtOrB9ri6izRc7wNx30yWgn4Jq
        dyCCJ8PuCob5k1V6U7ceYsLZfVBPQWXJ5IbkPNJ2gQdkhHGgYSiIsjnMiajAOC5O04H1sH
        hklzynwrkv6T6tjjdpMFMeMsgQ5dNP3oh/nM+/sNbyTVV5sfzvw3PWIZq+xvJQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1660753658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b0RhUT9EfZg6coERnTROD4jwiSNyrMmoG56LL3GmvfY=;
        b=aw6axL68jEutvCcc9oovciv5v3PRHbqXjVRlT2qx+p3l5EY+c8M9CjcpTJeBEcXUURt5BD
        +LOxj/giIdJYx5DA==
To:     linux-kernel@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>, netdev@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 8/9] u64_stats: Streamline the implementation
Date:   Wed, 17 Aug 2022 18:27:02 +0200
Message-Id: <20220817162703.728679-9-bigeasy@linutronix.de>
In-Reply-To: <20220817162703.728679-1-bigeasy@linutronix.de>
References: <20220817162703.728679-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

The u64 stats code handles 3 different cases:

  - 32bit UP
  - 32bit SMP
  - 64bit

with an unreadable #ifdef maze, which was recently expanded with PREEMPT_RT
conditionals.

Reduce it to two cases (32bit and 64bit) and drop the optimization for
32bit UP as suggested by Linus.

Use the new preempt_disable/enable_nested() helpers to get rid of the
CONFIG_PREEMPT_RT conditionals.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: netdev@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/u64_stats_sync.h | 147 +++++++++++++++------------------
 1 file changed, 65 insertions(+), 82 deletions(-)

diff --git a/include/linux/u64_stats_sync.h b/include/linux/u64_stats_sync.h
index 6ad4e9032d538..46040d66334a8 100644
--- a/include/linux/u64_stats_sync.h
+++ b/include/linux/u64_stats_sync.h
@@ -8,7 +8,7 @@
  *
  * Key points :
  *
- * -  Use a seqcount on 32-bit SMP, only disable preemption for 32-bit UP.
+ * -  Use a seqcount on 32-bit
  * -  The whole thing is a no-op on 64-bit architectures.
  *
  * Usage constraints:
@@ -20,7 +20,8 @@
  *    writer and also spin forever.
  *
  * 3) Write side must use the _irqsave() variant if other writers, or a re=
ader,
- *    can be invoked from an IRQ context.
+ *    can be invoked from an IRQ context. On 64bit systems this variant do=
es not
+ *    disable interrupts.
  *
  * 4) If reader fetches several counters, there is no guarantee the whole =
values
  *    are consistent w.r.t. each other (remember point #2: seqcounts are n=
ot
@@ -29,11 +30,6 @@
  * 5) Readers are allowed to sleep or be preempted/interrupted: they perfo=
rm
  *    pure reads.
  *
- * 6) Readers must use both u64_stats_fetch_{begin,retry}_irq() if the sta=
ts
- *    might be updated from a hardirq or softirq context (remember point #=
1:
- *    seqcounts are not used for UP kernels). 32-bit UP stat readers could=
 read
- *    corrupted 64-bit values otherwise.
- *
  * Usage :
  *
  * Stats producer (writer) should use following template granted it alread=
y got
@@ -66,7 +62,7 @@
 #include <linux/seqlock.h>
=20
 struct u64_stats_sync {
-#if BITS_PER_LONG =3D=3D 32 && (defined(CONFIG_SMP) || defined(CONFIG_PREE=
MPT_RT))
+#if BITS_PER_LONG =3D=3D 32
 	seqcount_t	seq;
 #endif
 };
@@ -98,7 +94,22 @@ static inline void u64_stats_inc(u64_stats_t *p)
 	local64_inc(&p->v);
 }
=20
-#else
+static inline void u64_stats_init(struct u64_stats_sync *syncp) { }
+static inline void __u64_stats_update_begin(struct u64_stats_sync *syncp) =
{ }
+static inline void __u64_stats_update_end(struct u64_stats_sync *syncp) { }
+static inline unsigned long __u64_stats_irqsave(void) { return 0; }
+static inline void __u64_stats_irqrestore(unsigned long flags) { }
+static inline unsigned int __u64_stats_fetch_begin(const struct u64_stats_=
sync *syncp)
+{
+	return 0;
+}
+static inline bool __u64_stats_fetch_retry(const struct u64_stats_sync *sy=
ncp,
+					   unsigned int start)
+{
+	return false;
+}
+
+#else /* 64 bit */
=20
 typedef struct {
 	u64		v;
@@ -123,123 +134,95 @@ static inline void u64_stats_inc(u64_stats_t *p)
 {
 	p->v++;
 }
-#endif
=20
-#if BITS_PER_LONG =3D=3D 32 && (defined(CONFIG_SMP) || defined(CONFIG_PREE=
MPT_RT))
-#define u64_stats_init(syncp)	seqcount_init(&(syncp)->seq)
-#else
 static inline void u64_stats_init(struct u64_stats_sync *syncp)
 {
+	seqcount_init(&syncp->seq);
 }
-#endif
=20
-static inline void u64_stats_update_begin(struct u64_stats_sync *syncp)
+static inline void __u64_stats_update_begin(struct u64_stats_sync *syncp)
 {
-#if BITS_PER_LONG =3D=3D 32 && (defined(CONFIG_SMP) || defined(CONFIG_PREE=
MPT_RT))
-	if (IS_ENABLED(CONFIG_PREEMPT_RT))
-		preempt_disable();
+	preempt_disable_nested();
 	write_seqcount_begin(&syncp->seq);
-#endif
 }
=20
-static inline void u64_stats_update_end(struct u64_stats_sync *syncp)
+static inline void __u64_stats_update_end(struct u64_stats_sync *syncp)
 {
-#if BITS_PER_LONG =3D=3D 32 && (defined(CONFIG_SMP) || defined(CONFIG_PREE=
MPT_RT))
 	write_seqcount_end(&syncp->seq);
-	if (IS_ENABLED(CONFIG_PREEMPT_RT))
-		preempt_enable();
-#endif
+	preempt_enable_nested();
 }
=20
-static inline unsigned long
-u64_stats_update_begin_irqsave(struct u64_stats_sync *syncp)
+static inline unsigned long __u64_stats_irqsave(void)
 {
-	unsigned long flags =3D 0;
+	unsigned long flags;
=20
-#if BITS_PER_LONG =3D=3D 32 && (defined(CONFIG_SMP) || defined(CONFIG_PREE=
MPT_RT))
-	if (IS_ENABLED(CONFIG_PREEMPT_RT))
-		preempt_disable();
-	else
-		local_irq_save(flags);
-	write_seqcount_begin(&syncp->seq);
-#endif
+	local_irq_save(flags);
 	return flags;
 }
=20
-static inline void
-u64_stats_update_end_irqrestore(struct u64_stats_sync *syncp,
-				unsigned long flags)
+static inline void __u64_stats_irqrestore(unsigned long flags)
 {
-#if BITS_PER_LONG =3D=3D 32 && (defined(CONFIG_SMP) || defined(CONFIG_PREE=
MPT_RT))
-	write_seqcount_end(&syncp->seq);
-	if (IS_ENABLED(CONFIG_PREEMPT_RT))
-		preempt_enable();
-	else
-		local_irq_restore(flags);
-#endif
+	local_irq_restore(flags);
 }
=20
 static inline unsigned int __u64_stats_fetch_begin(const struct u64_stats_=
sync *syncp)
 {
-#if BITS_PER_LONG =3D=3D 32 && (defined(CONFIG_SMP) || defined(CONFIG_PREE=
MPT_RT))
 	return read_seqcount_begin(&syncp->seq);
-#else
-	return 0;
-#endif
+}
+
+static inline bool __u64_stats_fetch_retry(const struct u64_stats_sync *sy=
ncp,
+					   unsigned int start)
+{
+	return read_seqcount_retry(&syncp->seq, start);
+}
+#endif /* !64 bit */
+
+static inline void u64_stats_update_begin(struct u64_stats_sync *syncp)
+{
+	__u64_stats_update_begin(syncp);
+}
+
+static inline void u64_stats_update_end(struct u64_stats_sync *syncp)
+{
+	__u64_stats_update_end(syncp);
+}
+
+static inline unsigned long u64_stats_update_begin_irqsave(struct u64_stat=
s_sync *syncp)
+{
+	unsigned long flags =3D __u64_stats_irqsave();
+
+	__u64_stats_update_begin(syncp);
+	return flags;
+}
+
+static inline void u64_stats_update_end_irqrestore(struct u64_stats_sync *=
syncp,
+						   unsigned long flags)
+{
+	__u64_stats_update_end(syncp);
+	__u64_stats_irqrestore(flags);
 }
=20
 static inline unsigned int u64_stats_fetch_begin(const struct u64_stats_sy=
nc *syncp)
 {
-#if BITS_PER_LONG =3D=3D 32 && (!defined(CONFIG_SMP) && !defined(CONFIG_PR=
EEMPT_RT))
-	preempt_disable();
-#endif
 	return __u64_stats_fetch_begin(syncp);
 }
=20
-static inline bool __u64_stats_fetch_retry(const struct u64_stats_sync *sy=
ncp,
-					 unsigned int start)
-{
-#if BITS_PER_LONG =3D=3D 32 && (defined(CONFIG_SMP) || defined(CONFIG_PREE=
MPT_RT))
-	return read_seqcount_retry(&syncp->seq, start);
-#else
-	return false;
-#endif
-}
-
 static inline bool u64_stats_fetch_retry(const struct u64_stats_sync *sync=
p,
 					 unsigned int start)
 {
-#if BITS_PER_LONG =3D=3D 32 && (!defined(CONFIG_SMP) && !defined(CONFIG_PR=
EEMPT_RT))
-	preempt_enable();
-#endif
 	return __u64_stats_fetch_retry(syncp, start);
 }
=20
-/*
- * In case irq handlers can update u64 counters, readers can use following=
 helpers
- * - SMP 32bit arches use seqcount protection, irq safe.
- * - UP 32bit must disable irqs.
- * - 64bit have no problem atomically reading u64 values, irq safe.
- */
+/* Obsolete interfaces */
 static inline unsigned int u64_stats_fetch_begin_irq(const struct u64_stat=
s_sync *syncp)
 {
-#if BITS_PER_LONG =3D=3D 32 && defined(CONFIG_PREEMPT_RT)
-	preempt_disable();
-#elif BITS_PER_LONG =3D=3D 32 && !defined(CONFIG_SMP)
-	local_irq_disable();
-#endif
-	return __u64_stats_fetch_begin(syncp);
+	return u64_stats_fetch_begin(syncp);
 }
=20
 static inline bool u64_stats_fetch_retry_irq(const struct u64_stats_sync *=
syncp,
 					     unsigned int start)
 {
-#if BITS_PER_LONG =3D=3D 32 && defined(CONFIG_PREEMPT_RT)
-	preempt_enable();
-#elif BITS_PER_LONG =3D=3D 32 && !defined(CONFIG_SMP)
-	local_irq_enable();
-#endif
-	return __u64_stats_fetch_retry(syncp, start);
+	return u64_stats_fetch_retry(syncp, start);
 }
=20
 #endif /* _LINUX_U64_STATS_SYNC_H */
--=20
2.37.2

