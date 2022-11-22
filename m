Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E347E6342DD
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 18:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234539AbiKVRps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 12:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234425AbiKVRp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 12:45:29 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90347AF7A;
        Tue, 22 Nov 2022 09:45:00 -0800 (PST)
Message-ID: <20221122173648.619071341@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669139099;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=loWOeteSDfXqDwCwhR8PkMj0fJ4Wcn9TP/qRmPXVBa4=;
        b=0hGO5Wk0pIFm1S0qXeQ7PdXOz5PGq9RcqJf+EmVCFF9bex2AVxb7gkfQnxHICeUi7/Ofuh
        48V9LXYVsWvLvrvtLAc0iwSq/iSlDCxv91iy9EKhkMlJsVs5rEkw8/mNfElda3OynSfpol
        LI8lc6naiyJ1JLUj0ip9QTVlns8m+Ac4IZW7XvnECZ6oE45BuisMRZyJRaEwaMadBWEPDc
        2lgqKklCAGeS+HNbHTasKvZQ7hypSXUsAmYEOPBviKCesT1hq21R5jefyA8lK78lPHXWaV
        8VS1tyDeFLdoLFs3Rj3jvJ3ij/YuZ3PJ3ksst1VziEqbsO9wSs1odqw2PynWjw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669139099;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=loWOeteSDfXqDwCwhR8PkMj0fJ4Wcn9TP/qRmPXVBa4=;
        b=kzKXKPXw/BGYqj/wvLmudmM7Vc295HgkEEBR1suH31GOdddL+BaN6HBZIeYF6GHCSfOgG7
        6M9XpNmCuBPLjoAQ==
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
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [patch V2 09/17] timers: Rename del_timer_sync() to timer_delete_sync()
References: <20221122171312.191765396@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 22 Nov 2022 18:44:58 +0100 (CET)
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
@@ -1257,7 +1257,7 @@ EXPORT_SYMBOL_GPL(add_timer_on);
  * @timer:	The timer to be deactivated
  *
  * The function only deactivates a pending timer, but contrary to
- * del_timer_sync() it does not take into account whether the timers
+ * timer_delete_sync() it does not take into account whether the timers
  * callback function is concurrently executed on a different CPU or not.
  * It neither prevents rearming of the timer.  If @timer can be rearmed
  * concurrently then the return value of this function is meaningless.
@@ -1393,7 +1393,7 @@ static inline void del_timer_wait_runnin
 #endif
 
 /**
- * del_timer_sync - Deactivate a timer and wait for the handler to finish.
+ * timer_delete_sync - Deactivate a timer and wait for the handler to finish.
  * @timer:	The timer to be deactivated
  *
  * Synchronization rules: Callers must prevent restarting of the timer,
@@ -1415,10 +1415,10 @@ static inline void del_timer_wait_runnin
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
@@ -1431,7 +1431,7 @@ static inline void del_timer_wait_runnin
  * * %0	- The timer was not pending
  * * %1	- The timer was pending and deactivated
  */
-int del_timer_sync(struct timer_list *timer)
+int timer_delete_sync(struct timer_list *timer)
 {
 	int ret;
 
@@ -1471,7 +1471,7 @@ int del_timer_sync(struct timer_list *ti
 
 	return ret;
 }
-EXPORT_SYMBOL(del_timer_sync);
+EXPORT_SYMBOL(timer_delete_sync);
 
 static void call_timer_fn(struct timer_list *timer,
 			  void (*fn)(struct timer_list *),
@@ -1493,8 +1493,8 @@ static void call_timer_fn(struct timer_l
 #endif
 	/*
 	 * Couple the lock chain with the lock chain at
-	 * del_timer_sync() by acquiring the lock_map around the fn()
-	 * call here and in del_timer_sync().
+	 * timer_delete_sync() by acquiring the lock_map around the fn()
+	 * call here and in timer_delete_sync().
 	 */
 	lock_map_acquire(&lockdep_map);
 

