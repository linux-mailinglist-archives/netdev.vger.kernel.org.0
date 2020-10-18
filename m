Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B384B2916CF
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 11:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgJRJzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 05:55:33 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:53334 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbgJRJzc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 05:55:32 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603014929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=frO9VGu4c0N3JYQXQJur22BBBdrB0jIkbMuY8Wda430=;
        b=fiA/MLK9BvtfilhaGmoco31jU7YAYrIM3Qoz/5guudauBCZXirJsNudwi+KPxq2LBhS35j
        83/Uc2xpLCOVPMi/vAONImQgp2EknFSrPdBNoRy7EIpR8RcB9scUDFm60g9kmPRBCSzFFG
        XZzpAMmgdP7USkN5IEMyilJyGcmlywFOfnf4jBqV6+hcZtWc5wyoyz7SzCjQcAsHnSLJhK
        ftEE8BE9rniUJEmD0nu3D9GtphTFI9fxQi7iSvM5aSvQH45Z6Vlhx/q75CJGcwTq58igs2
        4jv7TBcrM7RswEiQtK/qJ0+0SxDCSch0OB2rXhNe3upefgi7ktLzjrg+7msHzw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603014929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=frO9VGu4c0N3JYQXQJur22BBBdrB0jIkbMuY8Wda430=;
        b=vevB727nRpj++RvvNh5fE8aVGF9DeRkjaU6aVQ+SPZH7q9IFNLT5vQpdFDHy8wow8U8sup
        8LdSbEZEyQpwaEAw==
To:     Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Remove __napi_schedule_irqoff?
In-Reply-To: <20201017162949.0a6dd37a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <01af7f4f-bd05-b93e-57ad-c2e9b8726e90@gmail.com> <20201017162949.0a6dd37a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Sun, 18 Oct 2020 11:55:28 +0200
Message-ID: <878sc3j1tb.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub,

On Sat, Oct 17 2020 at 16:29, Jakub Kicinski wrote:
> On Sat, 17 Oct 2020 15:45:57 +0200 Heiner Kallweit wrote:
>> It turned out that this most of the time isn't safe in certain
>> configurations:
>> - if CONFIG_PREEMPT_RT is set
>> - if command line parameter threadirqs is set
>> 
>> Having said that drivers are being switched back to __napi_schedule(),
>> see e.g. patch in [0] and related discussion. I thought about a
>> __napi_schedule version checking dynamically whether interrupts are
>> disabled. But checking e.g. variable force_irqthreads also comes at
>> a cost, so that we may not see a benefit compared to calling
>> local_irq_save/local_irq_restore.

This does not have to be a variable check. It's trivial enough to make
it a static key.

>> If more or less all users have to switch back, then the question is
>> whether we should remove __napi_schedule_irqoff.
>> Instead of touching all users we could make  __napi_schedule_irqoff
>> an alias for __napi_schedule for now.
>> 
>> [0] https://lkml.org/lkml/2020/10/8/706
>
> We're effectively calling raise_softirq_irqoff() from IRQ handlers,
> with force_irqthreads == true that's no longer legal.

Hrmpf, indeed. When force threading was introduced that did not exist.

The forced threaded handler is always invoked with bottom halfs disabled
and bottom half processing either happens when the handler returns and
the thread wrapper invokes local_bh_enable() or from ksoftirq. As
everything runs in thread context CPU local serialization through
local_bh_disable() is sufficient.

> Thomas - is the expectation that IRQ handlers never assume they have 
> IRQs disabled going forward? We don't have any performance numbers 
> but if I'm reading Agner's tables right POPF is 18 cycles on Broadwell.
> Is PUSHF/POPF too cheap to bother?

It's not only PUSHF/POPF it's PUSHF,CLI -> POPF, but yeah it's pretty
cheap nowadays. But doing the static key change might still be a good
thing. Completely untested patch below.

Quoting Eric:

> I have to say I do not understand why we want to defer to a thread the
> hard IRQ that we use in NAPI model.
> 
> Whole point of NAPI was to keep hard irq handler very short.

Right. In case the interrupt handler is doing not much more than
scheduling NAPI then you can request it with IRQF_NO_THREAD, which will
prevent it from being threaded even on RT.

> We should focus on transferring the NAPI work (potentially disrupting
> ) to a thread context, instead of the very minor hard irq trigger.

Read about that. I only looked briefly at the patches and wondered why
this has it's own threading mechanism and is not using the irq thread
mechanics. I'll have a closer look in the next days.

Thanks,

        tglx
---
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -109,7 +109,6 @@ int __ide_wait_stat(ide_drive_t *drive,
 	ide_hwif_t *hwif = drive->hwif;
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	unsigned long flags;
-	bool irqs_threaded = force_irqthreads;
 	int i;
 	u8 stat;
 
@@ -117,7 +116,7 @@ int __ide_wait_stat(ide_drive_t *drive,
 	stat = tp_ops->read_status(hwif);
 
 	if (stat & ATA_BUSY) {
-		if (!irqs_threaded) {
+		if (!force_irqthreads_active()) {
 			local_save_flags(flags);
 			local_irq_enable_in_hardirq();
 		}
@@ -133,13 +132,13 @@ int __ide_wait_stat(ide_drive_t *drive,
 				if ((stat & ATA_BUSY) == 0)
 					break;
 
-				if (!irqs_threaded)
+				if (!force_irqthreads_active())
 					local_irq_restore(flags);
 				*rstat = stat;
 				return -EBUSY;
 			}
 		}
-		if (!irqs_threaded)
+		if (!force_irqthreads_active())
 			local_irq_restore(flags);
 	}
 	/*
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -406,7 +406,8 @@ static ide_startstop_t pre_task_out_intr
 		return startstop;
 	}
 
-	if (!force_irqthreads && (drive->dev_flags & IDE_DFLAG_UNMASK) == 0)
+	if (!force_irqthreads_active() &&
+	    (drive->dev_flags & IDE_DFLAG_UNMASK) == 0)
 		local_irq_disable();
 
 	ide_set_handler(drive, &task_pio_intr, WAIT_WORSTCASE);
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -489,12 +489,16 @@ extern int irq_set_irqchip_state(unsigne
 
 #ifdef CONFIG_IRQ_FORCED_THREADING
 # ifdef CONFIG_PREEMPT_RT
-#  define force_irqthreads	(true)
+static inline bool force_irqthreads_active(void) { return true; }
 # else
-extern bool force_irqthreads;
+extern struct static_key_false force_irqthreads_key;
+static inline bool force_irqthreads_active(void)
+{
+	return static_branch_unlikely(&force_irqthreads_key);
+}
 # endif
 #else
-#define force_irqthreads	(0)
+static inline bool force_irqthreads_active(void) { return false; }
 #endif
 
 #ifndef local_softirq_pending
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -25,12 +25,14 @@
 #include "internals.h"
 
 #if defined(CONFIG_IRQ_FORCED_THREADING) && !defined(CONFIG_PREEMPT_RT)
-__read_mostly bool force_irqthreads;
-EXPORT_SYMBOL_GPL(force_irqthreads);
+DEFINE_STATIC_KEY_FALSE(force_irqthreads_key);
+#ifdef CONFIG_IDE
+EXPORT_SYMBOL_GPL(force_irqthreads_key);
+#endif
 
 static int __init setup_forced_irqthreads(char *arg)
 {
-	force_irqthreads = true;
+	static_branch_enable(&force_irqthreads_key);
 	return 0;
 }
 early_param("threadirqs", setup_forced_irqthreads);
@@ -1155,8 +1157,8 @@ static int irq_thread(void *data)
 	irqreturn_t (*handler_fn)(struct irq_desc *desc,
 			struct irqaction *action);
 
-	if (force_irqthreads && test_bit(IRQTF_FORCED_THREAD,
-					&action->thread_flags))
+	if (force_irqthreads_active() && test_bit(IRQTF_FORCED_THREAD,
+						  &action->thread_flags))
 		handler_fn = irq_forced_thread_fn;
 	else
 		handler_fn = irq_thread_fn;
@@ -1217,7 +1219,7 @@ EXPORT_SYMBOL_GPL(irq_wake_thread);
 
 static int irq_setup_forced_threading(struct irqaction *new)
 {
-	if (!force_irqthreads)
+	if (!force_irqthreads_active())
 		return 0;
 	if (new->flags & (IRQF_NO_THREAD | IRQF_PERCPU | IRQF_ONESHOT))
 		return 0;
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -376,7 +376,7 @@ static inline void invoke_softirq(void)
 	if (ksoftirqd_running(local_softirq_pending()))
 		return;
 
-	if (!force_irqthreads) {
+	if (!force_irqthreads_active()) {
 #ifdef CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK
 		/*
 		 * We can safely execute softirq on the current stack if
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6282,9 +6282,11 @@ void __napi_schedule(struct napi_struct
 {
 	unsigned long flags;
 
-	local_irq_save(flags);
+	if (force_irqthreads_active())
+		local_irq_save(flags);
 	____napi_schedule(this_cpu_ptr(&softnet_data), n);
-	local_irq_restore(flags);
+	if (force_irqthreads_active())
+		local_irq_restore(flags);
 }
 EXPORT_SYMBOL(__napi_schedule);
 
