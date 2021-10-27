Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3386943D5E7
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 23:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbhJ0Vk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 17:40:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:41790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229561AbhJ0Vk4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 17:40:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 248A861073;
        Wed, 27 Oct 2021 21:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635370710;
        bh=03rFmnukQRaPXLpg9uWxjVUo8omX3iV+BTbJrx/1enk=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=DPQsUalnxmHvZ8SbWv8GHumt8u3Rx+mwrLjSqFrp+yvGkxqyS1FQ49Tz90zOUdG8N
         Qy8bO5AHifubN0h3cXEEChAzrkdd3z4mb9qpx0nvMk5CfQGYG8OAQtEuU3UT3t/crT
         8qMIHxBLnFqsKzWCom1rZdgL6Z7AdqvctiKiTVrC+zUQeTP0IdtF0PI4Q+jIEosZ7w
         xd3nLtsm/az397JEpupa6VW0C+kBpylqtn1yuwUZEXf1SHs6Kxey18MhXZ8EnTV0DU
         9zB6jqxTcpzW8VOyWBv6hwQDqjdqJ43gbrtydfjyqSN73ZMGlKb+aPrAFvxxtQmEvI
         l9tTx0Anwd0UQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 745A75C0326; Wed, 27 Oct 2021 14:38:29 -0700 (PDT)
Date:   Wed, 27 Oct 2021 14:38:29 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Jiri Wiesner <jwiesner@suse.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>, Mel Gorman <mgorman@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH] clocksource: increase watchdog retries
Message-ID: <20211027213829.GB880162@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20211027164352.GA23273@incl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211027164352.GA23273@incl>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 06:43:52PM +0200, Jiri Wiesner wrote:
> A recent change to the clocksource watchdog in commit db3a34e17433
> ("clocksource: Retry clock read if long delays detected") has caused a
> severe performance regression in TCP throughput tests. Netperf executed on
> localhost was used for testing. The regression was more than 80%. On the
> testing machine, the HPET clocksource was used to detect delays in reading
> the TSC clocksource, which was the selected clocksource. In 10% of the
> boots of the machine, TSC was marked unstable and the HPET clocksource was
> selected as the best clocksource:
> 
> [   13.669682] clocksource: timekeeping watchdog on CPU6: hpet read-back delay of 60666ns, attempt 4, marking unstable
> [   13.669827] tsc: Marking TSC unstable due to clocksource watchdog
> [   13.669917] TSC found unstable after boot, most likely due to broken BIOS. Use 'tsc=unstable'.
> [   13.670048] sched_clock: Marking unstable (11633513890, 2036384489)<-(13965149377, -295250974)
> [   13.672268] clocksource: Checking clocksource tsc synchronization from CPU 0 to CPUs 1-3,6-7.
> [   13.673148] clocksource: Switched to clocksource hpet
> 
> The earliest occurrence was this:
> 
> [    3.423636] clocksource: timekeeping watchdog on CPU2: hpet read-back delay of 61833ns, attempt 4, marking unstable
> [    3.435182] tsc: Marking TSC unstable due to clocksource watchdog
> [    3.455228] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
> [    3.459182] hpet0: 8 comparators, 64-bit 24.000000 MHz counter
> [    3.471195] clocksource: Switched to clocksource hpet
> 
> The HPET clocksource suffers from lock contention when its read() function
> is executed on multiple CPUs concurrently. A perf profile from the netperf
> test (netperf ran on CPU 1, netserver ran on CPU 0):
> 
> Samples: 14K of event 'bus-cycles'
> Overhead  Command    Shared Object     Symbol                         CPU
>   43.83%  netperf    [kernel.vmlinux]  [k] read_hpet                  001
>   40.86%  netserver  [kernel.vmlinux]  [k] read_hpet                  000
>    2.27%  netperf    [kernel.vmlinux]  [k] syscall_exit_to_user_mode  001
>    2.19%  netserver  [kernel.vmlinux]  [k] syscall_exit_to_user_mode  000
>    0.96%  netserver  [kernel.vmlinux]  [k] entry_SYSCALL_64           000
>    0.92%  swapper    [kernel.vmlinux]  [k] read_hpet                  000
> 
> For timestamping, TCP needs to execute ktime_get() in both the transmit
> and receive path. Lock contention caused by HPET on 2 CPUs was enough to
> lose 88% of the throughput measured with TSC (1.6 Gbit/s with HPET, 13
> Gbit/s with TSC). The lock contention can also be reproduced by switching
> to HPET via sysfs.
> 
> Tests were carried out to tweak the value of the
> clocksource.max_cswd_read_retries parameter. The results indicate that
> setting the number of retries to 50 mitigates the issue on the testing
> machine, but it does not make it go away entirely:
> 
> clocksource.max_cswd_read_retries=3
> Reboots: 100  TSC unstable: 10
> Reboots: 300  TSC unstable: 32
> clocksource.max_cswd_read_retries=5
> Reboots: 100  TSC unstable: 5
> clocksource.max_cswd_read_retries=10
> Reboots: 100  TSC unstable: 6
> clocksource.max_cswd_read_retries=50
> Reboots: 100  TSC unstable: 0
> Reboots: 300  TSC unstable: 1
> 
> The testing machine has a Skylake CPU (Intel(R) Xeon(R) CPU E3-1240 v5 @
> 3.50GHz) with 4 cores (8 CPUs when SMT is on). Perhaps, the number of
> retries to mitigate the issue could depend on the number of online CPUs on
> the system. Tweaking clocksource.verify_n_cpus had no effect:
> 
> clocksource.max_cswd_read_retries=3 clocksource.verify_n_cpus=1
> Reboots: 100  TSC unstable: 11
> 
> The issue has been observed on both Intel and AMD machines, and it is not
> specific to Skylake CPUs. The observed regression varies but, so far, tens
> of per cent have been observed.
> 
> Signed-off-by: Jiri Wiesner <jwiesner@suse.de>

First, apologies for the inconvenience!

I had something like this pending, but people came up with other workloads
that resulted in repeated delays.  In those cases, it does not make sense
to ever mark the affected clocksource unstable.  This led me to the patch
shown below, which splats after about 100 consecutive long-delay retries,
but which avoids marking the clocksource unstable.  This is queued on -rcu.

Does this work for you?

							Thanx, Paul

------------------------------------------------------------------------

commit 9ec2a03bbf4bee3d9fbc02a402dee36efafc5a2d
Author: Paul E. McKenney <paulmck@kernel.org>
Date:   Thu May 27 11:03:28 2021 -0700

    clocksource: Forgive repeated long-latency watchdog clocksource reads
    
    Currently, the clocksource watchdog reacts to repeated long-latency
    clocksource reads by marking that clocksource unstable on the theory that
    these long-latency reads are a sign of a serious problem.  And this theory
    does in fact have real-world support in the form of firmware issues [1].
    
    However, it is also possible to trigger this using stress-ng on what
    the stress-ng man page terms "poorly designed hardware" [2].  And it
    is not necessarily a bad thing for the kernel to diagnose cases where
    heavy memory-contention workloads are being run on hardware that is not
    designed for this sort of use.
    
    Nevertheless, it is quite possible that real-world use will result in
    some situation requiring that high-stress workloads run on hardware
    not designed to accommodate them, and also requiring that the kernel
    refrain from marking clocksources unstable.
    
    Therefore, react to persistent long-latency reads by leaving the
    clocksource alone, but using the old 62.5-millisecond skew-detection
    threshold.  In addition, the offending clocksource is marked for
    re-initialization, which both restarts that clocksource with a clean bill
    of health and avoids false-positive skew reports on later watchdog checks.
    Once marked for re-initialization, the clocksource is not subjected to
    further watchdog checking until a subsequent successful read from that
    clocksource that is free of excessive delays.
    
    However, if clocksource.max_cswd_coarse_reads consecutive clocksource read
    attempts result in long latencies, a warning (splat) will be emitted.
    This kernel boot parameter defaults to 100, and this warning can be
    disabled by setting it to zero or to a negative value.
    
    [ paulmck: Apply feedback from Chao Gao ]
    
    Link: https://lore.kernel.org/lkml/20210513155515.GB23902@xsang-OptiPlex-9020/ # [1]
    Link: https://lore.kernel.org/lkml/20210521083322.GG25531@xsang-OptiPlex-9020/ # [2]
    Link: https://lore.kernel.org/lkml/20210521084405.GH25531@xsang-OptiPlex-9020/
    Link: https://lore.kernel.org/lkml/20210511233403.GA2896757@paulmck-ThinkPad-P17-Gen-1/
    Tested-by: Chao Gao <chao.gao@intel.com>
    Signed-off-by: Paul E. McKenney <paulmck@kernel.org>

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 316027c3aadc..61d2436ae9df 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -600,6 +600,14 @@
 			loops can be debugged more effectively on production
 			systems.
 
+	clocksource.max_cswd_coarse_reads= [KNL]
+			Number of consecutive clocksource_watchdog()
+			coarse reads (that is, clocksource reads that
+			were unduly delayed) that are permitted before
+			the kernel complains (gently).	Set to a value
+			less than or equal to zero to suppress these
+			complaints.
+
 	clocksource.max_cswd_read_retries= [KNL]
 			Number of clocksource_watchdog() retries due to
 			external delays before the clock will be marked
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 1d42d4b17327..3e925d9ffc31 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -110,6 +110,7 @@ struct clocksource {
 	int			rating;
 	enum clocksource_ids	id;
 	enum vdso_clock_mode	vdso_clock_mode;
+	unsigned int		n_coarse_reads;
 	unsigned long		flags;
 
 	int			(*enable)(struct clocksource *cs);
@@ -291,6 +292,7 @@ static inline void timer_probe(void) {}
 #define TIMER_ACPI_DECLARE(name, table_id, fn)		\
 	ACPI_DECLARE_PROBE_ENTRY(timer, name, table_id, 0, NULL, 0, fn)
 
+extern int max_cswd_coarse_reads;
 extern ulong max_cswd_read_retries;
 void clocksource_verify_percpu(struct clocksource *cs);
 
diff --git a/kernel/time/clocksource-wdtest.c b/kernel/time/clocksource-wdtest.c
index df922f49d171..7e82500c400b 100644
--- a/kernel/time/clocksource-wdtest.c
+++ b/kernel/time/clocksource-wdtest.c
@@ -145,13 +145,12 @@ static int wdtest_func(void *arg)
 		else if (i <= max_cswd_read_retries)
 			s = ", expect message";
 		else
-			s = ", expect clock skew";
+			s = ", expect coarse-grained clock skew check and re-initialization";
 		pr_info("--- Watchdog with %dx error injection, %lu retries%s.\n", i, max_cswd_read_retries, s);
 		WRITE_ONCE(wdtest_ktime_read_ndelays, i);
 		schedule_timeout_uninterruptible(2 * HZ);
 		WARN_ON_ONCE(READ_ONCE(wdtest_ktime_read_ndelays));
-		WARN_ON_ONCE((i <= max_cswd_read_retries) !=
-			     !(clocksource_wdtest_ktime.flags & CLOCK_SOURCE_UNSTABLE));
+		WARN_ON_ONCE(clocksource_wdtest_ktime.flags & CLOCK_SOURCE_UNSTABLE);
 		wdtest_ktime_clocksource_reset();
 	}
 
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index b8a14d2fb5ba..796a127aabb9 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -199,6 +199,9 @@ void clocksource_mark_unstable(struct clocksource *cs)
 	spin_unlock_irqrestore(&watchdog_lock, flags);
 }
 
+int max_cswd_coarse_reads = 100;
+module_param(max_cswd_coarse_reads, int, 0644);
+EXPORT_SYMBOL_GPL(max_cswd_coarse_reads);
 ulong max_cswd_read_retries = 3;
 module_param(max_cswd_read_retries, ulong, 0644);
 EXPORT_SYMBOL_GPL(max_cswd_read_retries);
@@ -226,13 +229,22 @@ static bool cs_watchdog_read(struct clocksource *cs, u64 *csnow, u64 *wdnow)
 				pr_warn("timekeeping watchdog on CPU%d: %s retried %d times before success\n",
 					smp_processor_id(), watchdog->name, nretries);
 			}
-			return true;
+			cs->n_coarse_reads = 0;
+			return false;
 		}
+		WARN_ONCE(max_cswd_coarse_reads > 0 &&
+			  !(++cs->n_coarse_reads % max_cswd_coarse_reads),
+			  "timekeeping watchdog on CPU%d: %s %u consecutive coarse-grained reads\n", smp_processor_id(), watchdog->name, cs->n_coarse_reads);
 	}
 
-	pr_warn("timekeeping watchdog on CPU%d: %s read-back delay of %lldns, attempt %d, marking unstable\n",
-		smp_processor_id(), watchdog->name, wd_delay, nretries);
-	return false;
+	if ((cs->flags & CLOCK_SOURCE_WATCHDOG) && !atomic_read(&watchdog_reset_pending)) {
+		pr_warn("timekeeping watchdog on CPU%d: %s read-back delay of %lldns, attempt %d, coarse-grained skew check followed by re-initialization\n",
+			smp_processor_id(), watchdog->name, wd_delay, nretries);
+	} else {
+		pr_warn("timekeeping watchdog on CPU%d: %s read-back delay of %lldns, attempt %d, awaiting re-initialization\n",
+			smp_processor_id(), watchdog->name, wd_delay, nretries);
+	}
+	return true;
 }
 
 static u64 csnow_mid;
@@ -356,6 +368,7 @@ static void clocksource_watchdog(struct timer_list *unused)
 	int next_cpu, reset_pending;
 	int64_t wd_nsec, cs_nsec;
 	struct clocksource *cs;
+	bool coarse;
 	u32 md;
 
 	spin_lock(&watchdog_lock);
@@ -373,16 +386,13 @@ static void clocksource_watchdog(struct timer_list *unused)
 			continue;
 		}
 
-		if (!cs_watchdog_read(cs, &csnow, &wdnow)) {
-			/* Clock readout unreliable, so give it up. */
-			__clocksource_unstable(cs);
-			continue;
-		}
+		coarse = cs_watchdog_read(cs, &csnow, &wdnow);
 
 		/* Clocksource initialized ? */
 		if (!(cs->flags & CLOCK_SOURCE_WATCHDOG) ||
 		    atomic_read(&watchdog_reset_pending)) {
-			cs->flags |= CLOCK_SOURCE_WATCHDOG;
+			if (!coarse)
+				cs->flags |= CLOCK_SOURCE_WATCHDOG;
 			cs->wd_last = wdnow;
 			cs->cs_last = csnow;
 			continue;
@@ -403,7 +413,13 @@ static void clocksource_watchdog(struct timer_list *unused)
 			continue;
 
 		/* Check the deviation from the watchdog clocksource. */
-		md = cs->uncertainty_margin + watchdog->uncertainty_margin;
+		if (coarse) {
+			md = 62500 * NSEC_PER_USEC;
+			cs->flags &= ~CLOCK_SOURCE_WATCHDOG;
+			pr_warn("timekeeping watchdog on CPU%d: %s coarse-grained %lu.%03lu ms clock-skew check followed by re-initialization\n", smp_processor_id(), watchdog->name, md / NSEC_PER_MSEC, md % NSEC_PER_MSEC / NSEC_PER_USEC);
+		} else {
+			md = cs->uncertainty_margin + watchdog->uncertainty_margin;
+		}
 		if (abs(cs_nsec - wd_nsec) > md) {
 			pr_warn("timekeeping watchdog on CPU%d: Marking clocksource '%s' as unstable because the skew is too large:\n",
 				smp_processor_id(), cs->name);
