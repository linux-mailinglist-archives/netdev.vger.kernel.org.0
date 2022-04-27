Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C96651272A
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 01:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242013AbiD0XFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 19:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiD0XDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 19:03:00 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7248D6B1;
        Wed, 27 Apr 2022 15:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jkYRHw7XLP9WroKS48pjCKf8DZNXzuNJkBrmx0UcVRc=; b=fbM2Fu2zuIxXnRnSKiwEiLyyJe
        XagaY4Y4i5sW6+W+epTqREIZ/ICl1Xi2oNzNqYSLfAiAeujQhcD2J6BRDpwqIfpK1aYn9B4Gepnqm
        UXEPwRAoI9LiYlvqP9hTq72CQIYynMwPnO/khrMA9H8ZW9ZKFbbeWjtIm9rBmVgqZX/xUmom+B8xi
        QY1BWJZFFIiYDwppo949ykglLrpZKKBYxdtwbkyN1uybFrzpdjMmPjKvulL2l2aogMZ8iE6aJcjTZ
        GbdvguHg7iZbdZllsoe1PY/R6t06HkFNrymWUR1pYeoyB7ORK7qb8BLpbexkNshwnkf274e7nAB6M
        ydSnW7kQ==;
Received: from [179.113.53.197] (helo=localhost)
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
        id 1njqaG-0002Qg-Er; Thu, 28 Apr 2022 00:56:33 +0200
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
Subject: [PATCH 25/30] panic, printk: Add console flush parameter and convert panic_print to a notifier
Date:   Wed, 27 Apr 2022 19:49:19 -0300
Message-Id: <20220427224924.592546-26-gpiccoli@igalia.com>
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

Currently the parameter "panic_print" relies in a function called
directly on panic path; one of the flags the users can set for
panic_print triggers a console replay mechanism, to show the
entire kernel log buffer (from the beginning) in a panic event.

Two problems with that: the dual nature of the panic_print
isn't really appropriate, the function was originally meant
to allow users dumping system information on panic events,
and was "overridden" to also force a console flush of the full
kernel log buffer. It also turns the code a bit more complex
and duplicate than it needs to be.

This patch proposes 2 changes: first, we decouple panic_print
from the console flushing mechanism, in the form of a new kernel
core parameter (panic_console_replay); we kept the functionality
on panic_print to avoid userspace breakage, although we comment
in both code and documentation that this panic_print usage is
deprecated.

We converted panic_print function to a panic notifier too, adding
it on the panic informational notifier list, executed as the final
callback. This allows a more clear code and makes sense, as
panic_print_sys_info() is really a panic-time only function.
We also moved its code to kernel/printk.c, it seems to make more
sense given it's related to printing stuff.

Suggested-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---
 .../admin-guide/kernel-parameters.txt         | 12 +++-
 Documentation/admin-guide/sysctl/kernel.rst   |  5 +-
 include/linux/console.h                       |  2 +
 include/linux/panic.h                         |  1 -
 include/linux/printk.h                        |  1 +
 kernel/panic.c                                | 51 +++------------
 kernel/printk/printk.c                        | 62 +++++++++++++++++++
 7 files changed, 87 insertions(+), 47 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 8d3524060ce3..c99da8b2b216 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3791,6 +3791,14 @@
 			timeout < 0: reboot immediately
 			Format: <timeout>
 
+	panic_console_replay
+			[KNL] Force a kernel log replay in the console on
+			panic event. Notice that there is already a flush
+			mechanism for pending messages; this option is meant
+			for users that wish to replay the *full* buffer.
+			It deprecates the bit 5 setting on "panic_print",
+			both having the same functionality.
+
 	panic_notifiers_level=
 			[KNL] Set the panic notifiers execution order.
 			Format: <unsigned int>
@@ -3825,12 +3833,14 @@
 			bit 2: print timer info
 			bit 3: print locks info if CONFIG_LOCKDEP is on
 			bit 4: print ftrace buffer
-			bit 5: print all printk messages in buffer
+			bit 5: print all printk messages in buffer (DEPRECATED)
 			bit 6: print all CPUs backtrace (if available in the arch)
 			*Be aware* that this option may print a _lot_ of lines,
 			so there are risks of losing older messages in the log.
 			Use this option carefully, maybe worth to setup a
 			bigger log buffer with "log_buf_len" along with this.
+			Also, notice that bit 5 was deprecated in favor of the
+			parameter "panic_console_replay".
 
 	panic_on_taint=	Bitmask for conditionally calling panic() in add_taint()
 			Format: <hex>[,nousertaint]
diff --git a/Documentation/admin-guide/sysctl/kernel.rst b/Documentation/admin-guide/sysctl/kernel.rst
index 1144ea3229a3..17b293a0e566 100644
--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@ -763,10 +763,13 @@ bit 1  print system memory info
 bit 2  print timer info
 bit 3  print locks info if ``CONFIG_LOCKDEP`` is on
 bit 4  print ftrace buffer
-bit 5  print all printk messages in buffer
+bit 5  print all printk messages in buffer (DEPRECATED)
 bit 6  print all CPUs backtrace (if available in the arch)
 =====  ============================================
 
+Notice that bit 5 was deprecated in favor of kernel core parameter
+"panic_console_replay" (see kernel-parameters.txt documentation).
+
 So for example to print tasks and memory info on panic, user can::
 
   echo 3 > /proc/sys/kernel/panic_print
diff --git a/include/linux/console.h b/include/linux/console.h
index 7cd758a4f44e..351c14f623ad 100644
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -169,6 +169,8 @@ enum con_flush_mode {
 	CONSOLE_REPLAY_ALL,
 };
 
+extern bool panic_console_replay;
+
 extern int add_preferred_console(char *name, int idx, char *options);
 extern void register_console(struct console *);
 extern int unregister_console(struct console *);
diff --git a/include/linux/panic.h b/include/linux/panic.h
index f5844908a089..34175d0188d0 100644
--- a/include/linux/panic.h
+++ b/include/linux/panic.h
@@ -22,7 +22,6 @@ extern unsigned int sysctl_oops_all_cpu_backtrace;
 #endif /* CONFIG_SMP */
 
 extern int panic_timeout;
-extern unsigned long panic_print;
 extern int panic_on_oops;
 extern int panic_on_unrecovered_nmi;
 extern int panic_on_io_nmi;
diff --git a/include/linux/printk.h b/include/linux/printk.h
index 1522df223c0f..aee2e8ebd541 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -13,6 +13,7 @@
 extern const char linux_banner[];
 extern const char linux_proc_banner[];
 
+extern unsigned long panic_print;
 extern int oops_in_progress;	/* If set, an oops, panic(), BUG() or die() is in progress */
 
 #define PRINTK_MAX_SINGLE_HEADER_LEN 2
diff --git a/kernel/panic.c b/kernel/panic.c
index b7c055d4f87f..ff257bd8f81b 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -68,15 +68,6 @@ unsigned int panic_notifiers_level = 2;
 /* DEPRECATED in favor of panic_notifiers_level */
 bool crash_kexec_post_notifiers;
 
-#define PANIC_PRINT_TASK_INFO		0x00000001
-#define PANIC_PRINT_MEM_INFO		0x00000002
-#define PANIC_PRINT_TIMER_INFO		0x00000004
-#define PANIC_PRINT_LOCK_INFO		0x00000008
-#define PANIC_PRINT_FTRACE_INFO		0x00000010
-#define PANIC_PRINT_ALL_PRINTK_MSG	0x00000020
-#define PANIC_PRINT_ALL_CPU_BT		0x00000040
-unsigned long panic_print;
-
 ATOMIC_NOTIFIER_HEAD(panic_hypervisor_list);
 EXPORT_SYMBOL(panic_hypervisor_list);
 
@@ -168,33 +159,6 @@ void nmi_panic(struct pt_regs *regs, const char *msg)
 }
 EXPORT_SYMBOL(nmi_panic);
 
-static void panic_print_sys_info(bool console_flush)
-{
-	if (console_flush) {
-		if (panic_print & PANIC_PRINT_ALL_PRINTK_MSG)
-			console_flush_on_panic(CONSOLE_REPLAY_ALL);
-		return;
-	}
-
-	if (panic_print & PANIC_PRINT_ALL_CPU_BT)
-		trigger_all_cpu_backtrace();
-
-	if (panic_print & PANIC_PRINT_TASK_INFO)
-		show_state();
-
-	if (panic_print & PANIC_PRINT_MEM_INFO)
-		show_mem(0, NULL);
-
-	if (panic_print & PANIC_PRINT_TIMER_INFO)
-		sysrq_timer_list_show();
-
-	if (panic_print & PANIC_PRINT_LOCK_INFO)
-		debug_show_all_locks();
-
-	if (panic_print & PANIC_PRINT_FTRACE_INFO)
-		ftrace_dump(DUMP_ALL);
-}
-
 /*
  * Helper that accumulates all console flushing routines executed on panic.
  */
@@ -218,7 +182,11 @@ static void console_flushing(void)
 	debug_locks_off();
 	console_flush_on_panic(CONSOLE_FLUSH_PENDING);
 
-	panic_print_sys_info(true);
+	/* In case users wish to replay the full log buffer... */
+	if (panic_console_replay) {
+		pr_warn("Replaying the log buffer from the beginning\n");
+		console_flush_on_panic(CONSOLE_REPLAY_ALL);
+	}
 }
 
 #define PN_HYPERVISOR_BIT	0
@@ -431,10 +399,8 @@ void panic(const char *fmt, ...)
 	crash_smp_send_stop();
 	panic_notifier_hypervisor_once(buf);
 
-	if (panic_notifier_info_once(buf)) {
-		panic_print_sys_info(false);
+	if (panic_notifier_info_once(buf))
 		kmsg_dump(KMSG_DUMP_PANIC);
-	}
 
 	panic_notifier_pre_reboot_once(buf);
 
@@ -442,10 +408,8 @@ void panic(const char *fmt, ...)
 
 	panic_notifier_hypervisor_once(buf);
 
-	if (panic_notifier_info_once(buf)) {
-		panic_print_sys_info(false);
+	if (panic_notifier_info_once(buf))
 		kmsg_dump(KMSG_DUMP_PANIC);
-	}
 
 	panic_notifier_pre_reboot_once(buf);
 
@@ -814,7 +778,6 @@ EXPORT_SYMBOL(__stack_chk_fail);
 #endif
 
 core_param(panic, panic_timeout, int, 0644);
-core_param(panic_print, panic_print, ulong, 0644);
 core_param(pause_on_oops, pause_on_oops, int, 0644);
 core_param(panic_on_warn, panic_on_warn, int, 0644);
 core_param(panic_notifiers_level, panic_notifiers_level, uint, 0644);
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index e3a1c429fbbc..ad91d4c04246 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -35,6 +35,7 @@
 #include <linux/memblock.h>
 #include <linux/syscalls.h>
 #include <linux/crash_core.h>
+#include <linux/panic_notifier.h>
 #include <linux/ratelimit.h>
 #include <linux/kmsg_dump.h>
 #include <linux/syslog.h>
@@ -3234,6 +3235,61 @@ void __init console_init(void)
 	}
 }
 
+#define PANIC_PRINT_TASK_INFO		0x00000001
+#define PANIC_PRINT_MEM_INFO		0x00000002
+#define PANIC_PRINT_TIMER_INFO		0x00000004
+#define PANIC_PRINT_LOCK_INFO		0x00000008
+#define PANIC_PRINT_FTRACE_INFO		0x00000010
+
+/* DEPRECATED - please use "panic_console_replay" */
+#define PANIC_PRINT_ALL_PRINTK_MSG	0x00000020
+
+#define PANIC_PRINT_ALL_CPU_BT		0x00000040
+
+unsigned long panic_print;
+bool panic_console_replay;
+
+static int panic_print_sys_info(struct notifier_block *self,
+				unsigned long ev, void *unused)
+{
+	if (panic_print & PANIC_PRINT_ALL_CPU_BT)
+		trigger_all_cpu_backtrace();
+
+	if (panic_print & PANIC_PRINT_TASK_INFO)
+		show_state();
+
+	if (panic_print & PANIC_PRINT_MEM_INFO)
+		show_mem(0, NULL);
+
+	if (panic_print & PANIC_PRINT_TIMER_INFO)
+		sysrq_timer_list_show();
+
+	if (panic_print & PANIC_PRINT_LOCK_INFO)
+		debug_show_all_locks();
+
+	if (panic_print & PANIC_PRINT_FTRACE_INFO)
+		ftrace_dump(DUMP_ALL);
+
+	/*
+	 * This is legacy/deprecated feature from panic_print,
+	 * the console force flushing. We have now the parameter
+	 * "panic_console_replay", but we need to keep the
+	 * retro-compatibility with the old stuff...
+	 */
+	if (panic_print & PANIC_PRINT_ALL_PRINTK_MSG)
+		panic_console_replay = true;
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block panic_print_nb = {
+	.notifier_call = panic_print_sys_info,
+	.priority = INT_MIN, /* defer to run as late as possible */
+};
+
+core_param(panic_print, panic_print, ulong, 0644);
+core_param(panic_console_replay, panic_console_replay, bool, 0644);
+
 /*
  * Some boot consoles access data that is in the init section and which will
  * be discarded after the initcalls have been run. To make sure that no code
@@ -3253,6 +3309,12 @@ static int __init printk_late_init(void)
 	struct console *con;
 	int ret;
 
+	/*
+	 * Register the panic notifier to print user information
+	 * in case the user have that set.
+	 */
+	atomic_notifier_chain_register(&panic_info_list, &panic_print_nb);
+
 	for_each_console(con) {
 		if (!(con->flags & CON_BOOT))
 			continue;
-- 
2.36.0

