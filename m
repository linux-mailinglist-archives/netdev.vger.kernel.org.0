Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBBEE636AD7
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 21:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239723AbiKWUU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 15:20:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237373AbiKWUUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 15:20:15 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D10B043A;
        Wed, 23 Nov 2022 12:18:44 -0800 (PST)
Message-ID: <20221123201624.888306160@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669234723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=0eY7YnzlwSNTQTRTn0uxqikX7ma7laOZXEtpEJOrwxM=;
        b=4opf8+/GOXjJNOy6hPzmeTt80WMzIFSy8Am96kclq97AQbJnWOAprC4vzZ1RZ9AbWkSeZk
        8zxZ4sxeVeoBFgxABFY7ezWo75DXTTNGhM4D5jOMM2E+O2bn+NeGpqfZXBMXe7fEmBdJvK
        wTJmhUcJZEEsksW+Dkwxwh463sn4aIwrjxMUuHxBlkF9QQB2GcTpqhScr8KqDSwvF2OQfy
        8ahBVUYnd/xMAqaBzHyud1lYvkZsmsdMMFwp5r3zMlwNBcALp9chFIOkhiH4aIdZi99Xj4
        l/Rge2vagqPxQK11ZT3jUQu2tE7GP+DsyoC3XzfC0xe7A+phaeCOUeMdBjcw9w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669234723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=0eY7YnzlwSNTQTRTn0uxqikX7ma7laOZXEtpEJOrwxM=;
        b=qUhbnPp1lnq6hw/ZiuMuZPtuw5rIwxw31eQbsu7Um9qICRI4gv+9DhpXmFjAUdmwFAtvnr
        9j34rhZTb7lka7Cg==
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
Subject: [patch V3 08/17] timers: Use del_timer_sync() even on UP
References: <20221123201306.823305113@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 23 Nov 2022 21:18:42 +0100 (CET)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

del_timer_sync() is assumed to be pointless on uniprocessor systems and can
be mapped to del_timer() because in theory del_timer() can never be invoked
while the timer callback function is executed.

This is not entirely true because del_timer() can be invoked from interrupt
context and therefore hit in the middle of a running timer callback.

Contrary to that del_timer_sync() is not allowed to be invoked from
interrupt context unless the affected timer is marked with TIMER_IRQSAFE.
del_timer_sync() has proper checks in place to detect such a situation.

Give up on the UP optimization and make del_timer_sync() unconditionally
available.

Co-developed-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://lore.kernel.org/all/20220407161745.7d6754b3@gandalf.local.home
Link: https://lore.kernel.org/all/20221110064101.429013735@goodmis.org
---
 include/linux/timer.h |    7 +------
 kernel/time/timer.c   |    2 --
 2 files changed, 1 insertion(+), 8 deletions(-)

--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -183,12 +183,7 @@ extern int timer_reduce(struct timer_lis
 extern void add_timer(struct timer_list *timer);
 
 extern int try_to_del_timer_sync(struct timer_list *timer);
-
-#if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT)
-  extern int del_timer_sync(struct timer_list *timer);
-#else
-# define del_timer_sync(t)		del_timer(t)
-#endif
+extern int del_timer_sync(struct timer_list *timer);
 
 extern void init_timers(void);
 struct hrtimer;
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -1396,7 +1396,6 @@ static inline void timer_sync_wait_runni
 static inline void del_timer_wait_running(struct timer_list *timer) { }
 #endif
 
-#if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT)
 /**
  * del_timer_sync - Deactivate a timer and wait for the handler to finish.
  * @timer:	The timer to be deactivated
@@ -1477,7 +1476,6 @@ int del_timer_sync(struct timer_list *ti
 	return ret;
 }
 EXPORT_SYMBOL(del_timer_sync);
-#endif
 
 static void call_timer_fn(struct timer_list *timer,
 			  void (*fn)(struct timer_list *),

