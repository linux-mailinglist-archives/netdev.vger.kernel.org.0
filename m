Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8B66342D8
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 18:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbiKVRpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 12:45:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234366AbiKVRp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 12:45:28 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A9E8D9F;
        Tue, 22 Nov 2022 09:44:59 -0800 (PST)
Message-ID: <20221122173648.560770928@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669139097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=EMpM2Y9+AZ3Mkc+gVMKWk6eghahsVVjAJyXVQ6CR7oc=;
        b=jOfQSKgiI43Mey5tMtwdwq5HcuqumunlijHH9jFhIuNmnqNMa09hn7oPyucrb3Fb7Hy247
        sBgZzHiczM2XHBKwQ/4ZYgkb4s+rZsXYUF3Hlb5PGQpHYZMAcnEqweoxl780oo2E/ncE12
        TMxE0d0PhCN97Le4qcdR6JQdxsiQn14ANd53XDmF449szrYZKxUH2Pb664Sf0h4nlVhh0T
        iVDuKH07E3dFD9TiKVSrbxfy62RC2mLgBJFWStGvY+tVP7RsoeKUtLxXtgQdSFS8Eax6aP
        QOpN12SrPjoFzA6VWLkFtiCkDix5G133PH+yLVfd6KG+DRNqCUrt/OQ4vhBXxA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669139097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=EMpM2Y9+AZ3Mkc+gVMKWk6eghahsVVjAJyXVQ6CR7oc=;
        b=BWp8Zh//+2G8dMEG6BXVGDbM34z0AVD4jWkQgirweP06NXhIGCtYfEjeg8i9J72JprjMmF
        MOrJTm31/GbXkIBg==
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
Subject: [patch V2 08/17] timers: Use del_timer_sync() even on UP
References: <20221122171312.191765396@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 22 Nov 2022 18:44:57 +0100 (CET)
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
@@ -1392,7 +1392,6 @@ static inline void timer_sync_wait_runni
 static inline void del_timer_wait_running(struct timer_list *timer) { }
 #endif
 
-#if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT)
 /**
  * del_timer_sync - Deactivate a timer and wait for the handler to finish.
  * @timer:	The timer to be deactivated
@@ -1473,7 +1472,6 @@ int del_timer_sync(struct timer_list *ti
 	return ret;
 }
 EXPORT_SYMBOL(del_timer_sync);
-#endif
 
 static void call_timer_fn(struct timer_list *timer,
 			  void (*fn)(struct timer_list *),

