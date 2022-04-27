Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0B7651270F
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 01:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240077AbiD0XDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 19:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239847AbiD0XBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 19:01:38 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849A61BEBE;
        Wed, 27 Apr 2022 15:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VYrOPrqDKiFUsTfjme0J+bb1QZ+0oMPMNlfIlQcQCIU=; b=esIQjYNUmn8XOAMCY8KOPnZ+c+
        YZlzZFZJpud7l5aihfe1Itrd6ZZ98nnyy8UW1vOI1POK9zaRsPqoo2RhL4mEx84eRCHYefMesX5mG
        VJrQ0svjjO9G7VgOzDpcDLV/ntiz5AJExQTPCtbTdt7JFiAMS9guj375T3WC2+gnc5gFYq3Gv7f9R
        ZGEBpB02C9AAgh+86UxcqyV3yEw/FrOPinej5D7IeCAr0QV77wv10T31rCvUIuA1DrjRAh9qz2P38
        INNgxs5Kiy35sxcHJ/zXmQv2S2dVW6xiWlXVQ/tXuVpNtfQbdJCWgDKWsqK11QKSPuRppT31lgGJ9
        pH1ZqjsQ==;
Received: from [179.113.53.197] (helo=localhost)
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
        id 1njqZZ-0002Nv-Ix; Thu, 28 Apr 2022 00:55:50 +0200
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
        will@kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 22/30] panic: Introduce the panic post-reboot notifier list
Date:   Wed, 27 Apr 2022 19:49:16 -0300
Message-Id: <20220427224924.592546-23-gpiccoli@igalia.com>
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

Currently we have 3 notifier lists in the panic path, which will
be wired in a way to allow the notifier callbacks to run in
different moments at panic time, in a subsequent patch.

But there is also an odd set of architecture calls hardcoded in
the end of panic path, after the restart machinery. They're
responsible for late time tunings / events, like enabling a stop
button (Sparc) or effectively stopping the machine (s390).

This patch introduces yet another notifier list to offer the
architectures a way to add callbacks in such late moment on
panic path without the need of ifdefs / hardcoded approaches.

Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---
 arch/s390/kernel/setup.c       | 19 ++++++++++++++++++-
 arch/sparc/kernel/setup_32.c   | 27 +++++++++++++++++++++++----
 arch/sparc/kernel/setup_64.c   | 29 ++++++++++++++++++++++++-----
 include/linux/panic_notifier.h |  1 +
 kernel/panic.c                 | 19 +++++++------------
 5 files changed, 73 insertions(+), 22 deletions(-)

diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index d860ac300919..d816b2045f1e 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -39,7 +39,6 @@
 #include <linux/kernel_stat.h>
 #include <linux/dma-map-ops.h>
 #include <linux/device.h>
-#include <linux/notifier.h>
 #include <linux/pfn.h>
 #include <linux/ctype.h>
 #include <linux/reboot.h>
@@ -51,6 +50,7 @@
 #include <linux/start_kernel.h>
 #include <linux/hugetlb.h>
 #include <linux/kmemleak.h>
+#include <linux/panic_notifier.h>
 
 #include <asm/boot_data.h>
 #include <asm/ipl.h>
@@ -943,6 +943,20 @@ static void __init log_component_list(void)
 	}
 }
 
+/*
+ * The following notifier executes as one of the latest things in the panic
+ * path, only if the restart routines weren't executed (or didn't succeed).
+ */
+static int panic_event(struct notifier_block *n, unsigned long ev, void *unused)
+{
+	disabled_wait();
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block post_reboot_panic_block = {
+	.notifier_call = panic_event,
+};
+
 /*
  * Setup function called from init/main.c just after the banner
  * was printed.
@@ -1058,4 +1072,7 @@ void __init setup_arch(char **cmdline_p)
 
 	/* Add system specific data to the random pool */
 	setup_randomness();
+
+	atomic_notifier_chain_register(&panic_post_reboot_list,
+				       &post_reboot_panic_block);
 }
diff --git a/arch/sparc/kernel/setup_32.c b/arch/sparc/kernel/setup_32.c
index c8e0dd99f370..4e2428972f76 100644
--- a/arch/sparc/kernel/setup_32.c
+++ b/arch/sparc/kernel/setup_32.c
@@ -34,6 +34,7 @@
 #include <linux/kdebug.h>
 #include <linux/export.h>
 #include <linux/start_kernel.h>
+#include <linux/panic_notifier.h>
 #include <uapi/linux/mount.h>
 
 #include <asm/io.h>
@@ -51,6 +52,7 @@
 
 #include "kernel.h"
 
+int stop_a_enabled = 1;
 struct screen_info screen_info = {
 	0, 0,			/* orig-x, orig-y */
 	0,			/* unused */
@@ -293,6 +295,24 @@ void __init sparc32_start_kernel(struct linux_romvec *rp)
 	start_kernel();
 }
 
+/*
+ * The following notifier executes as one of the latest things in the panic
+ * path, only if the restart routines weren't executed (or didn't succeed).
+ */
+static int panic_event(struct notifier_block *n, unsigned long ev, void *unused)
+{
+	/* Make sure the user can actually press Stop-A (L1-A) */
+	stop_a_enabled = 1;
+	pr_emerg("Press Stop-A (L1-A) from sun keyboard or send break\n"
+		"twice on console to return to the boot prom\n");
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block post_reboot_panic_block = {
+	.notifier_call = panic_event,
+};
+
 void __init setup_arch(char **cmdline_p)
 {
 	int i;
@@ -368,9 +388,10 @@ void __init setup_arch(char **cmdline_p)
 	paging_init();
 
 	smp_setup_cpu_possible_map();
-}
 
-extern int stop_a_enabled;
+	atomic_notifier_chain_register(&panic_post_reboot_list,
+				       &post_reboot_panic_block);
+}
 
 void sun_do_break(void)
 {
@@ -384,8 +405,6 @@ void sun_do_break(void)
 }
 EXPORT_SYMBOL(sun_do_break);
 
-int stop_a_enabled = 1;
-
 static int __init topology_init(void)
 {
 	int i, ncpus, err;
diff --git a/arch/sparc/kernel/setup_64.c b/arch/sparc/kernel/setup_64.c
index 48abee4eee29..9066c25ecc07 100644
--- a/arch/sparc/kernel/setup_64.c
+++ b/arch/sparc/kernel/setup_64.c
@@ -33,6 +33,7 @@
 #include <linux/module.h>
 #include <linux/start_kernel.h>
 #include <linux/memblock.h>
+#include <linux/panic_notifier.h>
 #include <uapi/linux/mount.h>
 
 #include <asm/io.h>
@@ -62,6 +63,8 @@
 #include "entry.h"
 #include "kernel.h"
 
+int stop_a_enabled = 1;
+
 /* Used to synchronize accesses to NatSemi SUPER I/O chip configure
  * operations in asm/ns87303.h
  */
@@ -632,6 +635,24 @@ void __init alloc_irqstack_bootmem(void)
 	}
 }
 
+/*
+ * The following notifier executes as one of the latest things in the panic
+ * path, only if the restart routines weren't executed (or didn't succeed).
+ */
+static int panic_event(struct notifier_block *n, unsigned long ev, void *unused)
+{
+	/* Make sure the user can actually press Stop-A (L1-A) */
+	stop_a_enabled = 1;
+	pr_emerg("Press Stop-A (L1-A) from sun keyboard or send break\n"
+		"twice on console to return to the boot prom\n");
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block post_reboot_panic_block = {
+	.notifier_call = panic_event,
+};
+
 void __init setup_arch(char **cmdline_p)
 {
 	/* Initialize PROM console and command line. */
@@ -691,9 +712,10 @@ void __init setup_arch(char **cmdline_p)
 	 * allocate the IRQ stacks.
 	 */
 	alloc_irqstack_bootmem();
-}
 
-extern int stop_a_enabled;
+	atomic_notifier_chain_register(&panic_post_reboot_list,
+				       &post_reboot_panic_block);
+}
 
 void sun_do_break(void)
 {
@@ -706,6 +728,3 @@ void sun_do_break(void)
 	prom_cmdline();
 }
 EXPORT_SYMBOL(sun_do_break);
-
-int stop_a_enabled = 1;
-EXPORT_SYMBOL(stop_a_enabled);
diff --git a/include/linux/panic_notifier.h b/include/linux/panic_notifier.h
index 7912aacbc0e5..bcf6a5ea9d7f 100644
--- a/include/linux/panic_notifier.h
+++ b/include/linux/panic_notifier.h
@@ -8,6 +8,7 @@
 extern struct atomic_notifier_head panic_hypervisor_list;
 extern struct atomic_notifier_head panic_info_list;
 extern struct atomic_notifier_head panic_pre_reboot_list;
+extern struct atomic_notifier_head panic_post_reboot_list;
 
 extern bool crash_kexec_post_notifiers;
 
diff --git a/kernel/panic.c b/kernel/panic.c
index a9d43b98b05b..bf792102b43e 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -78,6 +78,9 @@ EXPORT_SYMBOL(panic_info_list);
 ATOMIC_NOTIFIER_HEAD(panic_pre_reboot_list);
 EXPORT_SYMBOL(panic_pre_reboot_list);
 
+ATOMIC_NOTIFIER_HEAD(panic_post_reboot_list);
+EXPORT_SYMBOL(panic_post_reboot_list);
+
 static long no_blink(int state)
 {
 	return 0;
@@ -359,18 +362,10 @@ void panic(const char *fmt, ...)
 			reboot_mode = panic_reboot_mode;
 		emergency_restart();
 	}
-#ifdef __sparc__
-	{
-		extern int stop_a_enabled;
-		/* Make sure the user can actually press Stop-A (L1-A) */
-		stop_a_enabled = 1;
-		pr_emerg("Press Stop-A (L1-A) from sun keyboard or send break\n"
-			 "twice on console to return to the boot prom\n");
-	}
-#endif
-#if defined(CONFIG_S390)
-	disabled_wait();
-#endif
+
+	atomic_notifier_call_chain(&panic_post_reboot_list,
+				   PANIC_NOTIFIER, buf);
+
 	pr_emerg("---[ end Kernel panic - not syncing: %s ]---\n", buf);
 
 	/* Do not scroll important messages printed above */
-- 
2.36.0

