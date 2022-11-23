Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83F74636AF6
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 21:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239775AbiKWUV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 15:21:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239403AbiKWUUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 15:20:35 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED97BF5AF;
        Wed, 23 Nov 2022 12:18:54 -0800 (PST)
Message-ID: <20221123201624.954785441@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669234724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=9aovE9SsY83ZBBgWbgO0H2UxzRJSCD39AJ6NU6FG1LY=;
        b=ap/DBinmESrU5PswQAz1fTDCTpjoban93gqTgfXUWnTbp8XWAhpO72DbRtjnNva4DBwNOb
        CnLdVcgK4/TtbLESHnQi2GKu8nIxRqul2jXQpqjiGqwZbfVpDdeL1aY8x6YwtIaPCqnffG
        wYXfFTzorCV9JTe74qqlMfAoIZf2ukwIFh0AQdEYxeBkebPl0KMtIXKir/B9bMdARWilTK
        ZSWWnQbRZauVzwd1CoGAX5MLnPfhQIyc68Q+6UCNXvxW0WIZPYvvbm8X/WkasvD2oBZ/cI
        T0Fha2YjLLe421KfwwjXDU8vJT6BbmK1Vsu87Xx3Eia+wru7LVPAxEPT7rwVtg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669234724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=9aovE9SsY83ZBBgWbgO0H2UxzRJSCD39AJ6NU6FG1LY=;
        b=rGvZGpizAO3Cf9dY+7n2noKeNPiOVblL+DuS0Y0BANN1X2CFnzbwW+MuPusJxc0++c9u8T
        VJFOGDipEaiGB9DA==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Linus Torvalds <torvalds@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [patch V3 09/17] timers: Rename del_timer_sync() to timer_delete_sync()
References: <20221123201306.823305113@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 23 Nov 2022 21:18:44 +0100 (CET)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The timer related functions do not have a strict timer_ prefixed namespace
which is really annoying.

Rename del_timer_sync() to timer_delete_sync() and provide del_timer_sync()
as a wrapper. Document that del_timer_sync() is not for new code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
---
 include/linux/timer.h |   15 ++++++++++++++-
 kernel/time/timer.c   |   18 +++++++++---------
 2 files changed, 23 insertions(+), 10 deletions(-)

--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -183,7 +183,20 @@ extern int timer_reduce(struct timer_lis
 extern void add_timer(struct timer_list *timer);
 
 extern int try_to_del_timer_sync(struct timer_list *timer);
-extern int del_timer_sync(struct timer_list *timer);
+extern int timer_delete_sync(struct timer_list *timer);
+
+/**
+ * del_timer_sync - Delete a pending timer and wait for a running callback
+ * @timer:	The timer to be deleted
+ *
+ * See timer_delete_sync() for detailed explanation.
+ *
+ * Do not use in new code. Use timer_delete_sync() instead.
+ */
+static inline int del_timer_sync(struct timer_list *timer)
+{
+	return timer_delete_sync(timer);
+}
 
 extern void init_timers(void);
 struct hrtimer;
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -1083,7 +1083,7 @@ static inline int
 		/*
 		 * We are trying to schedule the timer on the new base.
 		 * However we can't change timer's base while it is running,
-		 * otherwise del_timer_sync() can't detect that the timer's
+		 * otherwise timer_delete_sync() can't detect that the timer's
 		 * handler yet has not finished. This also guarantees that the
 		 * timer is serialized wrt itself.
 		 */
@@ -1261,7 +1261,7 @@ EXPORT_SYMBOL_GPL(add_timer_on);
  * @timer:	The timer to be deactivated
  *
  * The function only deactivates a pending timer, but contrary to
- * del_timer_sync() it does not take into account whether the timer's
+ * timer_delete_sync() it does not take into account whether the timer's
  * callback function is concurrently executed on a different CPU or not.
  * It neither prevents rearming of the timer. If @timer can be rearmed
  * concurrently then the return value of this function is meaningless.
@@ -1397,7 +1397,7 @@ static inline void del_timer_wait_runnin
 #endif
 
 /**
- * del_timer_sync - Deactivate a timer and wait for the handler to finish.
+ * timer_delete_sync - Deactivate a timer and wait for the handler to finish.
  * @timer:	The timer to be deactivated
  *
  * Synchronization rules: Callers must prevent restarting of the timer,
@@ -1419,10 +1419,10 @@ static inline void del_timer_wait_runnin
  *    spin_lock_irq(somelock);
  *                                     <IRQ>
  *                                        spin_lock(somelock);
- *    del_timer_sync(mytimer);
+ *    timer_delete_sync(mytimer);
  *    while (base->running_timer == mytimer);
  *
- * Now del_timer_sync() will never return and never release somelock.
+ * Now timer_delete_sync() will never return and never release somelock.
  * The interrupt on the other CPU is waiting to grab somelock but it has
  * interrupted the softirq that CPU0 is waiting to finish.
  *
@@ -1435,7 +1435,7 @@ static inline void del_timer_wait_runnin
  * * %0	- The timer was not pending
  * * %1	- The timer was pending and deactivated
  */
-int del_timer_sync(struct timer_list *timer)
+int timer_delete_sync(struct timer_list *timer)
 {
 	int ret;
 
@@ -1475,7 +1475,7 @@ int del_timer_sync(struct timer_list *ti
 
 	return ret;
 }
-EXPORT_SYMBOL(del_timer_sync);
+EXPORT_SYMBOL(timer_delete_sync);
 
 static void call_timer_fn(struct timer_list *timer,
 			  void (*fn)(struct timer_list *),
@@ -1497,8 +1497,8 @@ static void call_timer_fn(struct timer_l
 #endif
 	/*
 	 * Couple the lock chain with the lock chain at
-	 * del_timer_sync() by acquiring the lock_map around the fn()
-	 * call here and in del_timer_sync().
+	 * timer_delete_sync() by acquiring the lock_map around the fn()
+	 * call here and in timer_delete_sync().
 	 */
 	lock_map_acquire(&lockdep_map);
 

