Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9944E233E
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 10:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243528AbiCUJYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 05:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238061AbiCUJYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 05:24:04 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 059801427EF
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 02:22:40 -0700 (PDT)
Date:   Mon, 21 Mar 2022 10:22:37 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1647854558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=/QWaEayZvArwN7LukNZ3sAsEuQ/wTRAvldgHd0dyeCs=;
        b=BZJfHHClEhH87dWEjJ/ZpN4RbylwnMRvr0eMcybIeXMoXgQmaWTXlU/McF5X/S8PJ8v0R5
        smwwp1UIlMCa0c09yQL/QZ+TKDxE79PJcXtIn5uXLpW//ASCokESDTPEi/hCciH5mNu8Qd
        jik7juazTNvuo9EhschGP7mRLZmHGRd3sXeof7KGzJbp74biYdbz4ltOMOYQLsozEMLJXZ
        +kepxIbHRmQRfkTOyE8BDJKoG8uEhNFsg8yAE2son/l+TN6rOL5r62Op1xGs3wy6JmunsB
        eZnclCD+QkRdf+ppQeIWK0MoXvkJjOaEZuW6F94gmKiJ2EFodg16l8X3Q1sfcA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1647854558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=/QWaEayZvArwN7LukNZ3sAsEuQ/wTRAvldgHd0dyeCs=;
        b=EC1lLIN5hLMp1jbGoU3/KKZiqQMF6E5+c4QA2Gc+lWeXtnD2kV7P9r0G2EFIU9KhyjXyFj
        H2Xo+BG+LGzdlPBg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH net-next] net: Revert the softirq will run annotation in
 ____napi_schedule().
Message-ID: <YjhD3ZKWysyw8rc6@linutronix.de>
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

The lockdep annotation lockdep_assert_softirq_will_run() expects that
either hard or soft interrupts are disabled because both guaranty that
the "raised" soft-interrupts will be processed once the context is left.

This triggers in flush_smp_call_function_from_idle() but it this case it
explicitly calls do_softirq() in case of pending softirqs.

Revert the "softirq will run" annotation in ____napi_schedule() and move
the check back to __netif_rx() as it was. Keep the IRQ-off assert in
____napi_schedule() because this is always required.

Fixes: fbd9a2ceba5c7 ("net: Add lockdep asserts to ____napi_schedule().")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/lockdep.h | 7 -------
 net/core/dev.c          | 3 +--
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 0cc65d2167015..467b94257105e 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -329,12 +329,6 @@ extern void lock_unpin_lock(struct lockdep_map *lock, struct pin_cookie);
 
 #define lockdep_assert_none_held_once()		\
 	lockdep_assert_once(!current->lockdep_depth)
-/*
- * Ensure that softirq is handled within the callchain and not delayed and
- * handled by chance.
- */
-#define lockdep_assert_softirq_will_run()	\
-	lockdep_assert_once(hardirq_count() | softirq_count())
 
 #define lockdep_recursing(tsk)	((tsk)->lockdep_recursion)
 
@@ -420,7 +414,6 @@ extern int lockdep_is_held(const void *);
 #define lockdep_assert_held_read(l)		do { (void)(l); } while (0)
 #define lockdep_assert_held_once(l)		do { (void)(l); } while (0)
 #define lockdep_assert_none_held_once()	do { } while (0)
-#define lockdep_assert_softirq_will_run()	do { } while (0)
 
 #define lockdep_recursing(tsk)			(0)
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 8e0cc5f2020d3..8a5109479dbe2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4277,7 +4277,6 @@ static inline void ____napi_schedule(struct softnet_data *sd,
 {
 	struct task_struct *thread;
 
-	lockdep_assert_softirq_will_run();
 	lockdep_assert_irqs_disabled();
 
 	if (test_bit(NAPI_STATE_THREADED, &napi->state)) {
@@ -4887,7 +4886,7 @@ int __netif_rx(struct sk_buff *skb)
 {
 	int ret;
 
-	lockdep_assert_softirq_will_run();
+	lockdep_assert_once(hardirq_count() | softirq_count());
 
 	trace_netif_rx_entry(skb);
 	ret = netif_rx_internal(skb);
-- 
2.35.1

