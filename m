Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E70D381435
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 01:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234340AbhENXYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 19:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbhENXYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 19:24:18 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA4CC06174A;
        Fri, 14 May 2021 16:23:05 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1621034583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2Wgd0uDiawQHMq/rfYIAZvV7XurhvJxsUGzVJSrAmKM=;
        b=451Zh7QKT6IHMS9tuDNL+AWAvSiS2mweRUD+nUiXb4MQh9tNM/GzmmgXGh70fQ9eaYQHEK
        P1zECbb2Es7KZgaQTVBkv+y/UioU4m1ExDnL8x5DLVxGguIcZxP3XRTSFB1n0oqKubw8Fs
        SVQzHZ4yKu7GZEaUH8vA4TiQqCHo3lfi9To3q1fo+iUmIodhfegVdWV6powFMoZOVn1gJe
        nHdshpL1lq7i+B1KJLHFBtmI4Aqz/x1C2dbmw7FA3CTJtcKouKReBWUdtLnxhNrghAqIqC
        cuxmxSX1loEiZkUocdctFdYqEF7QeRxbHkNLmbI32uwzU1/4d76Ut2BmH0rfUA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1621034583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2Wgd0uDiawQHMq/rfYIAZvV7XurhvJxsUGzVJSrAmKM=;
        b=4g6Nu1ylmmp70kyjRCWMaCP5Rm9fXlyLC232tZkcJCn1iFS8lhExuRbI3Z1oSIH2g1KayB
        gHuK992m+9CBHLBw==
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        Michal Svec <msvec@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hayes Wang <hayeswang@realtek.com>,
        Thierry Reding <treding@nvidia.com>,
        Lee Jones <lee.jones@linaro.org>,
        Borislav Petkov <bp@alien8.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH RFC] r8152: Ensure that napi_schedule() is handled
In-Reply-To: <20210514144130.7287af8e@kicinski-fedora-PC1C0HJN>
References: <877dk162mo.ffs@nanos.tec.linutronix.de> <20210514123838.10d78c35@kicinski-fedora-PC1C0HJN> <87sg2p2hbl.ffs@nanos.tec.linutronix.de> <20210514134655.73d972cb@kicinski-fedora-PC1C0HJN> <87fsyp2f8s.ffs@nanos.tec.linutronix.de> <20210514144130.7287af8e@kicinski-fedora-PC1C0HJN>
Date:   Sat, 15 May 2021 01:23:02 +0200
Message-ID: <871ra83nop.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14 2021 at 14:41, Jakub Kicinski wrote:
> On Fri, 14 May 2021 23:10:43 +0200 Thomas Gleixner wrote:
>> On Fri, May 14 2021 at 13:46, Jakub Kicinski wrote:
>> > On Fri, 14 May 2021 22:25:50 +0200 Thomas Gleixner wrote:  
>> >> Except that some instruction cycle beancounters might complain about
>> >> the extra conditional for the sane cases.
>> >> 
>> >> But yes, I'm fine with that as well. That's why this patch is marked RFC :)  
>> >
>> > When we're in the right context (irq/bh disabled etc.) the cost is just
>> > read of preempt_count() and jump, right? And presumably preempt_count()
>> > is in the cache already, because those sections aren't very long. Let me
>> > make this change locally and see if it is in any way perceivable.  
>> 
>> Right. Just wanted to mention it :)
>> 
>> > Obviously if anyone sees a way to solve the problem without much
>> > ifdefinery and force_irqthreads checks that'd be great - I don't.  
>> 
>> This is not related to force_irqthreads at all. This very driver invokes
>> it from plain thread context.
>
> I see, but a driver calling __napi_schedule_irqoff() from its IRQ
> handler _would_ be an issue, right? Or do irq threads trigger softirq
> processing on exit?

Yes, they do. See irq_forced_thread_fn(). It has a local_bh_disable() /
local_bh_ enable() pair around the invocation to ensure that.

>> > I'd rather avoid pushing this kind of stuff out to the drivers.  
>> 
>> You could have napi_schedule_intask() or something like that which would
>> do the local_bh_disable()/enable() dance around the invocation of
>> napi_schedule(). That would also document it clearly in the drivers. A
>> quick grep shows a bunch of instances which could be replaced:
>> 
>> drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c-5704-		local_bh_disable();
>> drivers/net/ethernet/mellanox/mlx4/en_netdev.c-1830-		local_bh_disable();
>> drivers/net/usb/r8152.c-1552-	local_bh_disable();
>> drivers/net/virtio_net.c-1355-	local_bh_disable();
>> drivers/net/wireless/intel/iwlwifi/pcie/rx.c-1650-	local_bh_disable();
>> drivers/net/wireless/intel/iwlwifi/pcie/rx.c-2015-		local_bh_disable();
>> drivers/net/wireless/intel/iwlwifi/pcie/rx.c-2225-		local_bh_disable();
>> drivers/net/wireless/intel/iwlwifi/pcie/rx.c-2235-		local_bh_disable();
>> drivers/s390/net/qeth_core_main.c-3515-	local_bh_disable();
>
> Very well aware, I've just sent a patch for mlx5 last week :)
>
> My initial reaction was the same as yours - we should add lockdep
> check, and napi_schedule_intask(). But then I started wondering
> if it's all for nothing on rt or with force_irqthreads, and therefore
> we should just eat the extra check.

We can make that work but sure I'm not going to argue when you decide to
just go for raise_softirq_irqsoff().

I just hacked that check up which is actually useful beyond NAPI. It's
straight forward except for that flush_smp_call_function_from_idle()
oddball, which immeditately triggered that assert because block mq uses
__raise_softirq_irqsoff() in a smp function call...

See below. Peter might have opinions though :)

Thanks,

        tglx
---
 include/linux/lockdep.h |   21 +++++++++++++++++++++
 include/linux/sched.h   |    1 +
 kernel/smp.c            |    2 ++
 kernel/softirq.c        |   18 ++++++++++++++----
 4 files changed, 38 insertions(+), 4 deletions(-)

--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -636,6 +636,23 @@ do {									\
 		     (!in_softirq() || in_irq() || in_nmi()));		\
 } while (0)
 
+#define lockdep_set_softirq_raise_safe()				\
+do {									\
+	current->softirq_raise_safe = 1;				\
+} while (0)
+
+#define lockdep_clear_softirq_raise_safe()				\
+do {									\
+	current->softirq_raise_safe = 0;				\
+} while (0)
+
+#define lockdep_assert_softirq_raise_ok()				\
+do {									\
+	WARN_ON_ONCE(__lockdep_enabled &&				\
+		     !current->softirq_raise_safe &&			\
+		     !(softirq_count() | hardirq_count()));		\
+} while (0)
+
 #else
 # define might_lock(lock) do { } while (0)
 # define might_lock_read(lock) do { } while (0)
@@ -648,6 +665,10 @@ do {									\
 # define lockdep_assert_preemption_enabled() do { } while (0)
 # define lockdep_assert_preemption_disabled() do { } while (0)
 # define lockdep_assert_in_softirq() do { } while (0)
+
+# define lockdep_set_softirq_raise_safe()	do { } while (0)
+# define lockdep_clear_softirq_raise_safe()	do { } while (0)
+# define lockdep_assert_softirq_raise_ok()	do { } while (0)
 #endif
 
 #ifdef CONFIG_PROVE_RAW_LOCK_NESTING
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1058,6 +1058,7 @@ struct task_struct {
 	u64				curr_chain_key;
 	int				lockdep_depth;
 	unsigned int			lockdep_recursion;
+	unsigned int			softirq_raise_safe;
 	struct held_lock		held_locks[MAX_LOCK_DEPTH];
 #endif
 
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -691,7 +691,9 @@ void flush_smp_call_function_from_idle(v
 	cfd_seq_store(this_cpu_ptr(&cfd_seq_local)->idle, CFD_SEQ_NOCPU,
 		      smp_processor_id(), CFD_SEQ_IDLE);
 	local_irq_save(flags);
+	lockdep_set_softirq_raise_safe();
 	flush_smp_call_function_queue(true);
+	lockdep_clear_softirq_raise_safe();
 	if (local_softirq_pending())
 		do_softirq();
 
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -664,12 +664,19 @@ void irq_exit(void)
 	lockdep_hardirq_exit();
 }
 
+static inline void ____raise_softirq_irqoff(unsigned int nr)
+{
+	lockdep_assert_irqs_disabled();
+	trace_softirq_raise(nr);
+	or_softirq_pending(1UL << nr);
+}
+
 /*
  * This function must run with irqs disabled!
  */
 inline void raise_softirq_irqoff(unsigned int nr)
 {
-	__raise_softirq_irqoff(nr);
+	____raise_softirq_irqoff(nr);
 
 	/*
 	 * If we're in an interrupt or softirq, we're done
@@ -693,11 +700,14 @@ void raise_softirq(unsigned int nr)
 	local_irq_restore(flags);
 }
 
+/*
+ * Must be invoked with interrupts disabled and either from softirq serving
+ * context or with local bottom halfs disabled.
+ */
 void __raise_softirq_irqoff(unsigned int nr)
 {
-	lockdep_assert_irqs_disabled();
-	trace_softirq_raise(nr);
-	or_softirq_pending(1UL << nr);
+	lockdep_assert_softirq_raise_ok();
+	____raise_softirq_irqoff(nr);
 }
 
 void open_softirq(int nr, void (*action)(struct softirq_action *))

