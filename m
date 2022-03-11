Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52B7D4D6443
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 16:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348321AbiCKPEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 10:04:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbiCKPEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 10:04:48 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9927310E541
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 07:03:45 -0800 (PST)
Date:   Fri, 11 Mar 2022 16:03:42 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1647011024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=ItuTUmrFOhrhoXAIsrI04PClP+mRUytpj7s/Dy3zdyc=;
        b=PW4naodVh8VC2uzJcr67mFEZlNuE3ras8/GKk6hJeBSkOumz/iqTL9hGpIkMGhw6Phaf7S
        QCWqCpNAFdcmf23VZJehDwjcWqXsx61pOQAPiGKtkX07ymqSPgb4qXJ6oprJRbjs15IsKE
        6/zKO50CC4lrQ7KGgv4WY8mZhxm6v4cUEjsuQuwm2goRskWG/Iib5QccI8RKsWPF4Bq7XS
        wLVy51F9SLD9oj7/utegxUpiV/UsOkMFVS0MDL7KNpelq8e5WMiuy5XU7vL2+hOXRcqKlq
        nIT+PXZo6vMUZpk/YCHAys76psopEmEr4rCDPhGqVHPO9j+Onw4ONwom59767g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1647011024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=ItuTUmrFOhrhoXAIsrI04PClP+mRUytpj7s/Dy3zdyc=;
        b=pqLSGa5147qw9WhD0Kd6AiMW0B0P/QeJlGpbYGArYIAZ1yDhSJXnoWxEzxlwfyA/cICzxp
        p9tGysnLYgtKykAA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH net-next] net: Add lockdep asserts to ____napi_schedule().
Message-ID: <YitkzkjU5zng7jAM@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

____napi_schedule() needs to be invoked with disabled interrupts due to
__raise_softirq_irqoff (in order not to corrupt the per-CPU list).
____napi_schedule() needs also to be invoked from an interrupt context
so that the raised-softirq is processed while the interrupt context is
left.

Add lockdep asserts for both conditions.
While this is the second time the irq/softirq check is needed, provide a
generic lockdep_assert_softirq_will_run() which is used by both caller.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
This is my todo from
   https://lkml.kernel.org/r/20220203170901.52ccfd09@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com

- It was suggested to add this to __napi_schedule(),
  __napi_schedule_irqoff but both end up here in ____napi_schedule().

- It was suggested to do lockdep_assert_softirq_will_run(). Done plus
  moved the other caller.

While adding this, I stumbled over lockdep_assert_in_softirq(). This
really special casing things and builds upon assumptions. It took me a
while to figure what is going on. I would suggest to remove it and as a
replacement add lockdep annotations (as in spin_acquire()) around
`napi_alloc_cache' access which is the thing the annotation cares about.
And then the lockdep_assert_in_softirq() can be replaced with a
might_lock() so in the end we know why do what we do. Lockdep will yell
if the lock has been observed in-hardirq and in-softirq without
disabling interrupts.
Sounds good?

---
 include/linux/lockdep.h | 7 +++++++
 net/core/dev.c          | 5 ++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 467b94257105e..0cc65d2167015 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -329,6 +329,12 @@ extern void lock_unpin_lock(struct lockdep_map *lock, struct pin_cookie);
 
 #define lockdep_assert_none_held_once()		\
 	lockdep_assert_once(!current->lockdep_depth)
+/*
+ * Ensure that softirq is handled within the callchain and not delayed and
+ * handled by chance.
+ */
+#define lockdep_assert_softirq_will_run()	\
+	lockdep_assert_once(hardirq_count() | softirq_count())
 
 #define lockdep_recursing(tsk)	((tsk)->lockdep_recursion)
 
@@ -414,6 +420,7 @@ extern int lockdep_is_held(const void *);
 #define lockdep_assert_held_read(l)		do { (void)(l); } while (0)
 #define lockdep_assert_held_once(l)		do { (void)(l); } while (0)
 #define lockdep_assert_none_held_once()	do { } while (0)
+#define lockdep_assert_softirq_will_run()	do { } while (0)
 
 #define lockdep_recursing(tsk)			(0)
 
diff --git a/net/core/dev.c b/net/core/dev.c
index ba69ddf85af6b..dbda85879f6c1 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4267,6 +4267,9 @@ static inline void ____napi_schedule(struct softnet_data *sd,
 {
 	struct task_struct *thread;
 
+	lockdep_assert_softirq_will_run();
+	lockdep_assert_irqs_disabled();
+
 	if (test_bit(NAPI_STATE_THREADED, &napi->state)) {
 		/* Paired with smp_mb__before_atomic() in
 		 * napi_enable()/dev_set_threaded().
@@ -4874,7 +4877,7 @@ int __netif_rx(struct sk_buff *skb)
 {
 	int ret;
 
-	lockdep_assert_once(hardirq_count() | softirq_count());
+	lockdep_assert_softirq_will_run();
 
 	trace_netif_rx_entry(skb);
 	ret = netif_rx_internal(skb);
-- 
2.35.1

