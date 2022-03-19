Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 954284DE4EB
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 01:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241210AbiCSAtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 20:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238614AbiCSAtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 20:49:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2072E8415
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 17:47:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0CC7B825E7
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 00:47:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B6FC340E8;
        Sat, 19 Mar 2022 00:47:49 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Pl/X7qFb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1647650867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=V4QfcpmMfKhbZqAZheZzQjZAaNrrDgRvupNqVg+Dm9M=;
        b=Pl/X7qFbbxwPisO6SyUf+jefdvDcX1DrwWHRYXnWjmMB0qnsoAteqOeD8FIL2wpXMTI6QM
        U/CgtR3aeRTEzMoY/rvBml6A87nQzwNdYKlamhaeKhjIETyXYqR3ahwH+ZcHu3gFEMkGcw
        JIjJIuIcevHKelAb26CGAvpT2y1xR+w=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 252b7d66 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Sat, 19 Mar 2022 00:47:46 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, wireguard@lists.zx2c4.com, kuba@kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Saeed Mahameed <saeed@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] net: remove lockdep asserts from ____napi_schedule()
Date:   Fri, 18 Mar 2022 18:47:38 -0600
Message-Id: <20220319004738.1068685-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit fbd9a2ceba5c ("net: Add lockdep asserts to
____napi_schedule()."). While good in theory, in practice it causes
issues with various drivers, and so it can be revisited earlier in the
cycle where those drivers can be adjusted if needed.

Link: https://lore.kernel.org/netdev/20220317192145.g23wprums5iunx6c@sx1/
Link: https://lore.kernel.org/netdev/CAHmME9oHFzL6CYVh8nLGkNKOkMeWi2gmxs_f7S8PATWwc6uQsw@mail.gmail.com/
Link: https://lore.kernel.org/wireguard/0000000000000eaff805da869d5b@google.com/
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Saeed Mahameed <saeed@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 include/linux/lockdep.h | 7 -------
 net/core/dev.c          | 5 +----
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 0cc65d216701..467b94257105 100644
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
index 8e0cc5f2020d..6cad39b73a8e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4277,9 +4277,6 @@ static inline void ____napi_schedule(struct softnet_data *sd,
 {
 	struct task_struct *thread;
 
-	lockdep_assert_softirq_will_run();
-	lockdep_assert_irqs_disabled();
-
 	if (test_bit(NAPI_STATE_THREADED, &napi->state)) {
 		/* Paired with smp_mb__before_atomic() in
 		 * napi_enable()/dev_set_threaded().
@@ -4887,7 +4884,7 @@ int __netif_rx(struct sk_buff *skb)
 {
 	int ret;
 
-	lockdep_assert_softirq_will_run();
+	lockdep_assert_once(hardirq_count() | softirq_count());
 
 	trace_netif_rx_entry(skb);
 	ret = netif_rx_internal(skb);
-- 
2.35.1

