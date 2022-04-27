Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85DBB512744
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 01:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbiD0XFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 19:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239884AbiD0XBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 19:01:39 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B207560A91;
        Wed, 27 Apr 2022 15:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HBUuAr51OMuxJxYe3RD+OwNeXP+xs2hLWBMDzaZAVcU=; b=TdeuJAIDaqG7cwkqI4nHtdLny3
        iyCGAksOLbOqYUJhSHm7/jnC9FYcG7MIAOI+24axWzVXXtY5atDwJhF+jKUhXmqfua6SRtlM+APMM
        /pYrjZPc6jxGuTXcpWZNvCBeGuUVSbIdA+s5Wy3xFKjzxGB2gHwr9ssNf9AZuLz8yIIYL86UZuejU
        XVMh5xio++Mw71vSoYtvIu7OGOfqGzJUfFYq3P814XI3qfdU5eIZpgCj0gTmmOGhFHuiK0SwPAxTu
        lSlbzkU4S5i7NKFBbNSmypNtm9Lj4sjOaRZ0Un4K1h/t8X5QpXDk7e0wi3PVQ1JnV2KXISI4VvN0g
        bri/UK8A==;
Received: from [179.113.53.197] (helo=localhost)
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
        id 1njqa3-0002Pf-2B; Thu, 28 Apr 2022 00:56:20 +0200
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To:     akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
        kexec@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, coresight@lists.linaro.org,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-um@lists.infradead.org, linux-xtensa@linux-xtensa.org,
        netdev@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
        rcu@vger.kernel.org, sparclinux@vger.kernel.org,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        kernel-dev@igalia.com, gpiccoli@igalia.com, kernel@gpiccoli.net,
        halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, bp@alien8.de, corbet@lwn.net,
        d.hatayama@jp.fujitsu.com, dave.hansen@linux.intel.com,
        dyoung@redhat.com, feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org
Subject: [PATCH 24/30] panic: Refactor the panic path
Date:   Wed, 27 Apr 2022 19:49:18 -0300
Message-Id: <20220427224924.592546-25-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220427224924.592546-1-gpiccoli@igalia.com>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The panic() function is somewhat convoluted - a lot of changes were
made over the years, adding comments that might be misleading/outdated
now, it has a code structure that is a bit complex to follow, with
lots of conditionals, for example. The panic notifier list is something
else - a single list, with multiple callbacks of different purposes,
that run in a non-deterministic order and may affect hardly kdump
reliability - see the "crash_kexec_post_notifiers" workaround-ish flag.

This patch proposes a major refactor on the panic path based on Petr's
idea [0] - basically we split the notifiers list in three, having a set
of different call points in the panic path. Below a list of changes
proposed in this patch, culminating in the panic notifiers level
concept:

(a) First of all, we improved comments all over the function
and removed useless variables / includes. Also, as part of this
clean-up we concentrate the console flushing functions in a helper.

(b) As mentioned before, there is a split of the panic notifier list
in three, based on the purpose of the callback. The code contains
good documentation in form of comments, but a summary of the three
lists follows:

- the hypervisor list aims low-risk procedures to inform hypervisors
or firmware about the panic event, also includes LED-related functions;

- the informational list contains callbacks that provide more details,
like kernel offset or trace dump (if enabled) and also includes the
callbacks aimed at reducing log pollution or warns, like the RCU and
hung task disable callbacks;

- finally, the pre_reboot list is the old notifier list renamed,
containing the more risky callbacks that didn't fit the previous
lists. There is also a 4th list (the post_reboot one), but it's not
related with the original list - it contains late time architecture
callbacks aimed at stopping the machine, for example.

The 3 notifiers lists execute in different moments, hypervisor being
the first, followed by informational and finally the pre_reboot list.

(c) But then, there is the ordering problem of the notifiers against
the crash_kernel() call - kdump must be as reliable as possible.
For that, a simple binary "switch" as "crash_kexec_post_notifiers"
is not enough, hence we introduce here concept of panic notifier
levels: there are 5 levels, from 0 (no notifier executes before
kdump) until 4 (all notifiers run before kdump); the default level
is 2, in which the hypervisor and (iff we have any kmsg dumper)
the informational notifiers execute before kdump.

The detailed documentation of the levels is present in code comments
and in the kernel-parameters.txt file; as an analogy with the previous
panic() implementation, the level 0 is exactly the same as the old
behavior of notifiers, running all after kdump, and the level 4 is
the same as "crash_kexec_post_notifiers=Y" (we kept this parameter as
a deprecated one).

(d) Finally, an important change made here: we now use only the
function "crash_smp_send_stop()" to shut all the secondary CPUs
in the panic path. Before, there was a case of using the regular
"smp_send_stop()", but the better approach is to simplify the
code and try to use the function which was created exclusively
for the panic path. Experiments showed that it works fine, and
code was very simplified with that.

Functional change is expected from this refactor, since now we
call some notifiers by default before kdump, but the goal here
besides code clean-up is to have a better panic path, more
reliable and deterministic, but also very customizable.

[0] https://lore.kernel.org/lkml/YfPxvzSzDLjO5ldp@alley/

Suggested-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---

Special thanks to Petr and Baoquan for the suggestion and feedback in a previous
email thread. There's some important design decisions that worth mentioning and
discussing:

* The default panic notifiers level is 2, based on Petr Mladek's suggestion,
which makes a lot of sense. Of course, this is customizable through the
parameter, but would be something worthwhile to have a KConfig option to set
the default level? It would help distros that want the old behavior
(no notifiers before kdump) as default.

* The implementation choice was to _avoid_ intricate if conditionals in the
panic path, which would _definitely_ be present with the panic notifiers levels
idea; so, instead of lots of if conditionals, the set/clear bits approach with
functions called in 2 points (but executing only in one of them) is much easier
to follow an was used here; the ordering helper function and the comments also
help a lot to avoid confusion (hopefully).

* Choice was to *always* use crash_smp_send_stop() instead of sometimes making
use of the regular smp_send_stop(); for most architectures they are the same,
including Xen (on x86). For the ones that override it, all should work fine,
in the powerpc case it's even more correct (see the subsequent patch
"powerpc: Do not force all panic notifiers to execute before kdump")

There seems to be 2 cases that requires some plumbing to work 100% right:
- ARM doesn't disable local interrupts / FIQs in the crash version of
send_stop(); we patched that early in this series;
- x86 could face an issue if we have VMX and do use crash_smp_send_stop()
_without_ kdump, but this is fixed in the first patch of the series (and
it's a bug present even before this refactor).

* Notice we didn't add a sysrq for panic notifiers level - should have it?
Alejandro proposed recently to add a sysrq for "crash_kexec_post_notifiers",
let me know if you feel the need here Alejandro, since the core parameters are
present in /sys, I didn't consider much gain in having a sysrq, but of course
I'm open to suggestions!

Thanks advance for the review!

 .../admin-guide/kernel-parameters.txt         |  42 ++-
 include/linux/panic_notifier.h                |   1 +
 kernel/kexec_core.c                           |   8 +-
 kernel/panic.c                                | 292 +++++++++++++-----
 .../selftests/pstore/pstore_crash_test        |   5 +-
 5 files changed, 252 insertions(+), 96 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 3f1cc5e317ed..8d3524060ce3 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -829,6 +829,13 @@
 			It will be ignored when crashkernel=X,high is not used
 			or memory reserved is below 4G.
 
+	crash_kexec_post_notifiers
+			This was DEPRECATED - users should always prefer the
+			parameter "panic_notifiers_level" - check its entry
+			in this documentation for details on how it works.
+			Setting this parameter is exactly the same as setting
+			"panic_notifiers_level=4".
+
 	cryptomgr.notests
 			[KNL] Disable crypto self-tests
 
@@ -3784,6 +3791,33 @@
 			timeout < 0: reboot immediately
 			Format: <timeout>
 
+	panic_notifiers_level=
+			[KNL] Set the panic notifiers execution order.
+			Format: <unsigned int>
+			We currently have 4 lists of panic notifiers; based
+			on the functionality and risk (for panic success) the
+			callbacks are added in a given list. The lists are:
+			- hypervisor/FW notification list (low risk);
+			- informational list (low/medium risk);
+			- pre_reboot list (higher risk);
+			- post_reboot list (only run late in panic and after
+			kdump, not configurable for now).
+			This parameter defines the ordering of the first 3
+			lists with regards to kdump; the levels determine
+			which set of notifiers execute before kdump. The
+			accepted levels are:
+			0: kdump is the first thing to run, NO list is
+			executed before kdump.
+			1: only the hypervisor list is executed before kdump.
+			2 (default level): the hypervisor list and (*if*
+			there's any kmsg_dumper defined) the informational
+			list are executed before kdump.
+			3: both the hypervisor and the informational lists
+			(always) execute before kdump.
+			4: the 3 lists (hypervisor, info and pre_reboot)
+			execute before kdump - this behavior is analog to the
+			deprecated parameter "crash_kexec_post_notifiers".
+
 	panic_print=	Bitmask for printing system info when panic happens.
 			User can chose combination of the following bits:
 			bit 0: print all tasks info
@@ -3814,14 +3848,6 @@
 	panic_on_warn	panic() instead of WARN().  Useful to cause kdump
 			on a WARN().
 
-	crash_kexec_post_notifiers
-			Run kdump after running panic-notifiers and dumping
-			kmsg. This only for the users who doubt kdump always
-			succeeds in any situation.
-			Note that this also increases risks of kdump failure,
-			because some panic notifiers can make the crashed
-			kernel more unstable.
-
 	parkbd.port=	[HW] Parallel port number the keyboard adapter is
 			connected to, default is 0.
 			Format: <parport#>
diff --git a/include/linux/panic_notifier.h b/include/linux/panic_notifier.h
index bcf6a5ea9d7f..b5041132321d 100644
--- a/include/linux/panic_notifier.h
+++ b/include/linux/panic_notifier.h
@@ -10,6 +10,7 @@ extern struct atomic_notifier_head panic_info_list;
 extern struct atomic_notifier_head panic_pre_reboot_list;
 extern struct atomic_notifier_head panic_post_reboot_list;
 
+bool panic_notifiers_before_kdump(void);
 extern bool crash_kexec_post_notifiers;
 
 enum panic_notifier_val {
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index 68480f731192..f8906db8ca72 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -74,11 +74,11 @@ struct resource crashk_low_res = {
 int kexec_should_crash(struct task_struct *p)
 {
 	/*
-	 * If crash_kexec_post_notifiers is enabled, don't run
-	 * crash_kexec() here yet, which must be run after panic
-	 * notifiers in panic().
+	 * In case any panic notifiers are set to execute before kexec,
+	 * don't run crash_kexec() here yet, which must run after these
+	 * panic notifiers are executed, in the panic() path.
 	 */
-	if (crash_kexec_post_notifiers)
+	if (panic_notifiers_before_kdump())
 		return 0;
 	/*
 	 * There are 4 panic() calls in make_task_dead() path, each of which
diff --git a/kernel/panic.c b/kernel/panic.c
index bf792102b43e..b7c055d4f87f 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -15,7 +15,6 @@
 #include <linux/kgdb.h>
 #include <linux/kmsg_dump.h>
 #include <linux/kallsyms.h>
-#include <linux/notifier.h>
 #include <linux/vt_kern.h>
 #include <linux/module.h>
 #include <linux/random.h>
@@ -52,14 +51,23 @@ static unsigned long tainted_mask =
 static int pause_on_oops;
 static int pause_on_oops_flag;
 static DEFINE_SPINLOCK(pause_on_oops_lock);
-bool crash_kexec_post_notifiers;
+
 int panic_on_warn __read_mostly;
+bool panic_on_taint_nousertaint;
 unsigned long panic_on_taint;
-bool panic_on_taint_nousertaint = false;
 
 int panic_timeout = CONFIG_PANIC_TIMEOUT;
 EXPORT_SYMBOL_GPL(panic_timeout);
 
+/* Initialized with all notifiers set to run before kdump */
+static unsigned long panic_notifiers_bits = 15;
+
+/* Default level is 2, see kernel-parameters.txt */
+unsigned int panic_notifiers_level = 2;
+
+/* DEPRECATED in favor of panic_notifiers_level */
+bool crash_kexec_post_notifiers;
+
 #define PANIC_PRINT_TASK_INFO		0x00000001
 #define PANIC_PRINT_MEM_INFO		0x00000002
 #define PANIC_PRINT_TIMER_INFO		0x00000004
@@ -109,10 +117,14 @@ void __weak nmi_panic_self_stop(struct pt_regs *regs)
 }
 
 /*
- * Stop other CPUs in panic.  Architecture dependent code may override this
- * with more suitable version.  For example, if the architecture supports
- * crash dump, it should save registers of each stopped CPU and disable
- * per-CPU features such as virtualization extensions.
+ * Stop other CPUs in panic context.
+ *
+ * Architecture dependent code may override this with more suitable version.
+ * For example, if the architecture supports crash dump, it should save the
+ * registers of each stopped CPU and disable per-CPU features such as
+ * virtualization extensions. When not overridden in arch code (and for
+ * x86/xen), this is exactly the same as execute smp_send_stop(), but
+ * guarded against duplicate execution.
  */
 void __weak crash_smp_send_stop(void)
 {
@@ -183,6 +195,112 @@ static void panic_print_sys_info(bool console_flush)
 		ftrace_dump(DUMP_ALL);
 }
 
+/*
+ * Helper that accumulates all console flushing routines executed on panic.
+ */
+static void console_flushing(void)
+{
+#ifdef CONFIG_VT
+	unblank_screen();
+#endif
+	console_unblank();
+
+	/*
+	 * In this point, we may have disabled other CPUs, hence stopping the
+	 * CPU holding the lock while still having some valuable data in the
+	 * console buffer.
+	 *
+	 * Try to acquire the lock then release it regardless of the result.
+	 * The release will also print the buffers out. Locks debug should
+	 * be disabled to avoid reporting bad unlock balance when panic()
+	 * is not being called from OOPS.
+	 */
+	debug_locks_off();
+	console_flush_on_panic(CONSOLE_FLUSH_PENDING);
+
+	panic_print_sys_info(true);
+}
+
+#define PN_HYPERVISOR_BIT	0
+#define PN_INFO_BIT		1
+#define PN_PRE_REBOOT_BIT	2
+#define PN_POST_REBOOT_BIT	3
+
+/*
+ * Determine the order of panic notifiers with regards to kdump.
+ *
+ * This function relies in the "panic_notifiers_level" kernel parameter
+ * to determine how to order the notifiers with regards to kdump. We
+ * have currently 5 levels. For details, please check the kernel docs for
+ * "panic_notifiers_level" at Documentation/admin-guide/kernel-parameters.txt.
+ *
+ * Default level is 2, which means the panic hypervisor and informational
+ * (unless we don't have any kmsg_dumper) lists will execute before kdump.
+ */
+static void order_panic_notifiers_and_kdump(void)
+{
+	/*
+	 * The parameter "crash_kexec_post_notifiers" is deprecated, but
+	 * valid. Users that set it want really all panic notifiers to
+	 * execute before kdump, so it's effectively the same as setting
+	 * the panic notifiers level to 4.
+	 */
+	if (panic_notifiers_level >= 4 || crash_kexec_post_notifiers)
+		return;
+
+	/*
+	 * Based on the level configured (smaller than 4), we clear the
+	 * proper bits in "panic_notifiers_bits". Notice that this bitfield
+	 * is initialized with all notifiers set.
+	 */
+	switch (panic_notifiers_level) {
+	case 3:
+		clear_bit(PN_PRE_REBOOT_BIT, &panic_notifiers_bits);
+		break;
+	case 2:
+		clear_bit(PN_PRE_REBOOT_BIT, &panic_notifiers_bits);
+
+		if (!kmsg_has_dumpers())
+			clear_bit(PN_INFO_BIT, &panic_notifiers_bits);
+		break;
+	case 1:
+		clear_bit(PN_PRE_REBOOT_BIT, &panic_notifiers_bits);
+		clear_bit(PN_INFO_BIT, &panic_notifiers_bits);
+		break;
+	case 0:
+		clear_bit(PN_PRE_REBOOT_BIT, &panic_notifiers_bits);
+		clear_bit(PN_INFO_BIT, &panic_notifiers_bits);
+		clear_bit(PN_HYPERVISOR_BIT, &panic_notifiers_bits);
+		break;
+	}
+}
+
+/*
+ * Set of helpers to execute the panic notifiers only once.
+ * Just the informational notifier cares about the return.
+ */
+static inline bool notifier_run_once(struct atomic_notifier_head head,
+				     char *buf, long bit)
+{
+	if (test_and_change_bit(bit, &panic_notifiers_bits)) {
+		atomic_notifier_call_chain(&head, PANIC_NOTIFIER, buf);
+		return true;
+	}
+	return false;
+}
+
+#define panic_notifier_hypervisor_once(buf)\
+	notifier_run_once(panic_hypervisor_list, buf, PN_HYPERVISOR_BIT)
+
+#define panic_notifier_info_once(buf)\
+	notifier_run_once(panic_info_list, buf, PN_INFO_BIT)
+
+#define panic_notifier_pre_reboot_once(buf)\
+	notifier_run_once(panic_pre_reboot_list, buf, PN_PRE_REBOOT_BIT)
+
+#define panic_notifier_post_reboot_once(buf)\
+	notifier_run_once(panic_post_reboot_list, buf, PN_POST_REBOOT_BIT)
+
 /**
  *	panic - halt the system
  *	@fmt: The text string to print
@@ -198,32 +316,29 @@ void panic(const char *fmt, ...)
 	long i, i_next = 0, len;
 	int state = 0;
 	int old_cpu, this_cpu;
-	bool _crash_kexec_post_notifiers = crash_kexec_post_notifiers;
 
-	if (panic_on_warn) {
-		/*
-		 * This thread may hit another WARN() in the panic path.
-		 * Resetting this prevents additional WARN() from panicking the
-		 * system on this thread.  Other threads are blocked by the
-		 * panic_mutex in panic().
-		 */
-		panic_on_warn = 0;
-	}
+	/*
+	 * This thread may hit another WARN() in the panic path, so
+	 * resetting this option prevents additional WARN() from
+	 * re-panicking the system here.
+	 */
+	panic_on_warn = 0;
 
 	/*
 	 * Disable local interrupts. This will prevent panic_smp_self_stop
-	 * from deadlocking the first cpu that invokes the panic, since
-	 * there is nothing to prevent an interrupt handler (that runs
-	 * after setting panic_cpu) from invoking panic() again.
+	 * from deadlocking the first cpu that invokes the panic, since there
+	 * is nothing to prevent an interrupt handler (that runs after setting
+	 * panic_cpu) from invoking panic() again. Also disables preemption
+	 * here - notice it's not safe to rely on interrupt disabling to avoid
+	 * preemption, since any cond_resched() or cond_resched_lock() might
+	 * trigger a reschedule if the preempt count is 0 (for reference, see
+	 * Documentation/locking/preempt-locking.rst). Some functions called
+	 * from here want preempt disabled, so no point enabling it later.
 	 */
 	local_irq_disable();
 	preempt_disable_notrace();
 
 	/*
-	 * It's possible to come here directly from a panic-assertion and
-	 * not have preempt disabled. Some functions called from here want
-	 * preempt to be disabled. No point enabling it later though...
-	 *
 	 * Only one CPU is allowed to execute the panic code from here. For
 	 * multiple parallel invocations of panic, all other CPUs either
 	 * stop themself or will wait until they are stopped by the 1st CPU
@@ -266,73 +381,75 @@ void panic(const char *fmt, ...)
 	kgdb_panic(buf);
 
 	/*
-	 * If we have crashed and we have a crash kernel loaded let it handle
-	 * everything else.
-	 * If we want to run this after calling panic_notifiers, pass
-	 * the "crash_kexec_post_notifiers" option to the kernel.
+	 * Here lies one of the most subtle parts of the panic path,
+	 * the panic notifiers and their order with regards to kdump.
+	 * We currently have 4 sets of notifiers:
 	 *
-	 * Bypass the panic_cpu check and call __crash_kexec directly.
+	 *  - the hypervisor list is composed by callbacks that are related
+	 *  to warn the FW / hypervisor about panic, or non-invasive LED
+	 *  controlling functions - (hopefully) low-risk for kdump, should
+	 *  run early if possible.
+	 *
+	 *  - the informational list is composed by functions dumping data
+	 *  like kernel offsets, device error registers or tracing buffer;
+	 *  also log flooding prevention callbacks fit in this list. It is
+	 *  relatively safe to run before kdump.
+	 *
+	 *  - the pre_reboot list basically is everything else, all the
+	 *  callbacks that don't fit in the 2 previous lists. It should
+	 *  run *after* kdump if possible, as it contains high-risk
+	 *  functions that may break kdump.
+	 *
+	 *  - we also have a 4th list of notifiers, the post_reboot
+	 *  callbacks. This is not strongly related to kdump since it's
+	 *  always executed late in the panic path, after the restart
+	 *  mechanism (if set); its goal is to provide a way for
+	 *  architecture code effectively power-off/disable the system.
+	 *
+	 *  The kernel provides the "panic_notifiers_level" parameter
+	 *  to adjust the ordering in which these notifiers should run
+	 *  with regards to kdump - the default level is 2, so both the
+	 *  hypervisor and informational notifiers should execute before
+	 *  the __crash_kexec(); the info notifier won't run by default
+	 *  unless there's some kmsg_dumper() registered. For details
+	 *  about it, check Documentation/admin-guide/kernel-parameters.txt.
+	 *
+	 *  Notice that the code relies in bits set/clear operations to
+	 *  determine the ordering, functions *_once() execute only one
+	 *  time, as their name implies. The goal is to prevent too much
+	 *  if conditionals and more confusion. Finally, regarding CPUs
+	 *  disabling: unless NO panic notifier executes before kdump,
+	 *  we always disable secondary CPUs before __crash_kexec() and
+	 *  the notifiers execute.
 	 */
-	if (!_crash_kexec_post_notifiers) {
+	order_panic_notifiers_and_kdump();
+
+	/* If no level, we should kdump ASAP. */
+	if (!panic_notifiers_level)
 		__crash_kexec(NULL);
 
-		/*
-		 * Note smp_send_stop is the usual smp shutdown function, which
-		 * unfortunately means it may not be hardened to work in a
-		 * panic situation.
-		 */
-		smp_send_stop();
-	} else {
-		/*
-		 * If we want to do crash dump after notifier calls and
-		 * kmsg_dump, we will need architecture dependent extra
-		 * works in addition to stopping other CPUs.
-		 */
-		crash_smp_send_stop();
-	}
+	crash_smp_send_stop();
+	panic_notifier_hypervisor_once(buf);
 
-	/*
-	 * Run any panic handlers, including those that might need to
-	 * add information to the kmsg dump output.
-	 */
-	atomic_notifier_call_chain(&panic_hypervisor_list, PANIC_NOTIFIER, buf);
-	atomic_notifier_call_chain(&panic_info_list, PANIC_NOTIFIER, buf);
-	atomic_notifier_call_chain(&panic_pre_reboot_list, PANIC_NOTIFIER, buf);
+	if (panic_notifier_info_once(buf)) {
+		panic_print_sys_info(false);
+		kmsg_dump(KMSG_DUMP_PANIC);
+	}
 
-	panic_print_sys_info(false);
+	panic_notifier_pre_reboot_once(buf);
 
-	kmsg_dump(KMSG_DUMP_PANIC);
+	__crash_kexec(NULL);
 
-	/*
-	 * If you doubt kdump always works fine in any situation,
-	 * "crash_kexec_post_notifiers" offers you a chance to run
-	 * panic_notifiers and dumping kmsg before kdump.
-	 * Note: since some panic_notifiers can make crashed kernel
-	 * more unstable, it can increase risks of the kdump failure too.
-	 *
-	 * Bypass the panic_cpu check and call __crash_kexec directly.
-	 */
-	if (_crash_kexec_post_notifiers)
-		__crash_kexec(NULL);
+	panic_notifier_hypervisor_once(buf);
 
-#ifdef CONFIG_VT
-	unblank_screen();
-#endif
-	console_unblank();
-
-	/*
-	 * We may have ended up stopping the CPU holding the lock (in
-	 * smp_send_stop()) while still having some valuable data in the console
-	 * buffer.  Try to acquire the lock then release it regardless of the
-	 * result.  The release will also print the buffers out.  Locks debug
-	 * should be disabled to avoid reporting bad unlock balance when
-	 * panic() is not being callled from OOPS.
-	 */
-	debug_locks_off();
-	console_flush_on_panic(CONSOLE_FLUSH_PENDING);
+	if (panic_notifier_info_once(buf)) {
+		panic_print_sys_info(false);
+		kmsg_dump(KMSG_DUMP_PANIC);
+	}
 
-	panic_print_sys_info(true);
+	panic_notifier_pre_reboot_once(buf);
 
+	console_flushing();
 	if (!panic_blink)
 		panic_blink = no_blink;
 
@@ -363,8 +480,7 @@ void panic(const char *fmt, ...)
 		emergency_restart();
 	}
 
-	atomic_notifier_call_chain(&panic_post_reboot_list,
-				   PANIC_NOTIFIER, buf);
+	panic_notifier_post_reboot_once(buf);
 
 	pr_emerg("---[ end Kernel panic - not syncing: %s ]---\n", buf);
 
@@ -383,6 +499,15 @@ void panic(const char *fmt, ...)
 
 EXPORT_SYMBOL(panic);
 
+/*
+ * Helper used in the kexec code, to validate if any
+ * panic notifier is set to execute early, before kdump.
+ */
+inline bool panic_notifiers_before_kdump(void)
+{
+	return panic_notifiers_level || crash_kexec_post_notifiers;
+}
+
 /*
  * TAINT_FORCED_RMMOD could be a per-module flag but the module
  * is being removed anyway.
@@ -692,6 +817,9 @@ core_param(panic, panic_timeout, int, 0644);
 core_param(panic_print, panic_print, ulong, 0644);
 core_param(pause_on_oops, pause_on_oops, int, 0644);
 core_param(panic_on_warn, panic_on_warn, int, 0644);
+core_param(panic_notifiers_level, panic_notifiers_level, uint, 0644);
+
+/* DEPRECATED in favor of panic_notifiers_level */
 core_param(crash_kexec_post_notifiers, crash_kexec_post_notifiers, bool, 0644);
 
 static int __init oops_setup(char *s)
diff --git a/tools/testing/selftests/pstore/pstore_crash_test b/tools/testing/selftests/pstore/pstore_crash_test
index 2a329bbb4aca..1e60ce4501aa 100755
--- a/tools/testing/selftests/pstore/pstore_crash_test
+++ b/tools/testing/selftests/pstore/pstore_crash_test
@@ -25,6 +25,7 @@ touch $REBOOT_FLAG
 sync
 
 # cause crash
-# Note: If you use kdump and want to see kmesg-* files after reboot, you should
-#       specify 'crash_kexec_post_notifiers' in 1st kernel's cmdline.
+# Note: If you use kdump and want to see kmsg-* files after reboot, you should
+#       be sure that the parameter "panic_notifiers_level" is more than '2' (the
+#       default value for this parameter is '2') in the first kernel's cmdline.
 echo c > /proc/sysrq-trigger
-- 
2.36.0

