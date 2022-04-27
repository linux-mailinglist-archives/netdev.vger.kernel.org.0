Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C88C5125F9
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 00:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239104AbiD0W5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 18:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238132AbiD0W44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 18:56:56 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E406090CC5;
        Wed, 27 Apr 2022 15:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/cdg0sKCsuwzrOmixxbC1Q4JQ/fbIS+o0nd/6r3SqdQ=; b=Ms53zbjgbkvE/VbvvERWDhiSlK
        xnfSZ26duHs4sJGmX9AjyiOpVrZ24qlvncFPTQgx0Ak1/K+qg/q6M3lNqtXBQSywskWJGGXxxZsyH
        0ZCt9ADqjTi/3V+XCpSLOfo1kVbAL88rsa3CWloXQYrPcKcjm0fr5wkBOKZGIirx4MPHlXEq/lSP6
        Wauj7ki9eqiIN/DWOEVCrOIQ5CDDEHA0P4AiVRkbPc3MLQuGkkZQLCDxyedC8rV+CPmlMqMLZGK7O
        pj27Q1YpHqsziDeg78TsiM6RPMIm39rOPoY53108P/vAvRYTx1t1bv7hv+1+u3acH1fsI00wIEzlf
        mvZOITKg==;
Received: from [179.113.53.197] (helo=localhost)
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
        id 1njqVm-00026W-Rl; Thu, 28 Apr 2022 00:51:55 +0200
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
        will@kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hari Bathini <hbathini@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH 08/30] powerpc/setup: Refactor/untangle panic notifiers
Date:   Wed, 27 Apr 2022 19:49:02 -0300
Message-Id: <20220427224924.592546-9-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220427224924.592546-1-gpiccoli@igalia.com>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The panic notifiers infrastructure is a bit limited in the scope of
the callbacks - basically every kind of functionality is dropped
in a list that runs in the same point during the kernel panic path.
This is not really on par with the complexities and particularities
of architecture / hypervisors' needs, and a refactor is ongoing.

As part of this refactor, it was observed that powerpc has 2 notifiers,
with mixed goals: one is just a KASLR offset dumper, whereas the other
aims to hard-disable IRQs (necessary on panic path), warn firmware of
the panic event (fadump) and run low-level platform-specific machinery
that might stop kernel execution and never come back.

Clearly, the 2nd notifier has opposed goals: disable IRQs / fadump
should run earlier while low-level platform actions should
run late since it might not even return. Hence, this patch decouples
the notifiers splitting them in three:

- First one is responsible for hard-disable IRQs and fadump,
should run early;

- The kernel KASLR offset dumper is really an informative notifier,
harmless and may run at any moment in the panic path;

- The last notifier should run last, since it aims to perform
low-level actions for specific platforms, and might never return.
It is also only registered for 2 platforms, pseries and ps3.

The patch better documents the notifiers and clears the code too,
also removing a useless header.

Currently no functionality change should be observed, but after
the planned panic refactor we should expect more panic reliability
with this patch.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---

We'd like to thanks specially the MiniCloud infrastructure [0] maintainers,
that allow us to test PowerPC code in a very complete, functional and FREE
environment (there's no need even for adding a credit card, like many "free"
clouds require ¬¬ ).

[0] https://openpower.ic.unicamp.br/minicloud

 arch/powerpc/kernel/setup-common.c | 74 ++++++++++++++++++++++--------
 1 file changed, 54 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index 518ae5aa9410..52f96b209a96 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -23,7 +23,6 @@
 #include <linux/console.h>
 #include <linux/screen_info.h>
 #include <linux/root_dev.h>
-#include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/unistd.h>
 #include <linux/serial.h>
@@ -680,8 +679,25 @@ int check_legacy_ioport(unsigned long base_port)
 }
 EXPORT_SYMBOL(check_legacy_ioport);
 
-static int ppc_panic_event(struct notifier_block *this,
-                             unsigned long event, void *ptr)
+/*
+ * Panic notifiers setup
+ *
+ * We have 3 notifiers for powerpc, each one from a different "nature":
+ *
+ * - ppc_panic_fadump_handler() is a hypervisor notifier, which hard-disables
+ *   IRQs and deal with the Firmware-Assisted dump, when it is configured;
+ *   should run early in the panic path.
+ *
+ * - dump_kernel_offset() is an informative notifier, just showing the KASLR
+ *   offset if we have RANDOMIZE_BASE set.
+ *
+ * - ppc_panic_platform_handler() is a low-level handler that's registered
+ *   only if the platform wishes to perform final actions in the panic path,
+ *   hence it should run late and might not even return. Currently, only
+ *   pseries and ps3 platforms register callbacks.
+ */
+static int ppc_panic_fadump_handler(struct notifier_block *this,
+				    unsigned long event, void *ptr)
 {
 	/*
 	 * panic does a local_irq_disable, but we really
@@ -691,45 +707,63 @@ static int ppc_panic_event(struct notifier_block *this,
 
 	/*
 	 * If firmware-assisted dump has been registered then trigger
-	 * firmware-assisted dump and let firmware handle everything else.
+	 * its callback and let the firmware handles everything else.
 	 */
 	crash_fadump(NULL, ptr);
-	if (ppc_md.panic)
-		ppc_md.panic(ptr);  /* May not return */
+
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block ppc_panic_block = {
-	.notifier_call = ppc_panic_event,
-	.priority = INT_MIN /* may not return; must be done last */
-};
-
-/*
- * Dump out kernel offset information on panic.
- */
 static int dump_kernel_offset(struct notifier_block *self, unsigned long v,
 			      void *p)
 {
 	pr_emerg("Kernel Offset: 0x%lx from 0x%lx\n",
 		 kaslr_offset(), KERNELBASE);
 
-	return 0;
+	return NOTIFY_DONE;
 }
 
+static int ppc_panic_platform_handler(struct notifier_block *this,
+				      unsigned long event, void *ptr)
+{
+	/*
+	 * This handler is only registered if we have a panic callback
+	 * on ppc_md, hence NULL check is not needed.
+	 * Also, it may not return, so it runs really late on panic path.
+	 */
+	ppc_md.panic(ptr);
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block ppc_fadump_block = {
+	.notifier_call = ppc_panic_fadump_handler,
+	.priority = INT_MAX, /* run early, to notify the firmware ASAP */
+};
+
 static struct notifier_block kernel_offset_notifier = {
-	.notifier_call = dump_kernel_offset
+	.notifier_call = dump_kernel_offset,
+};
+
+static struct notifier_block ppc_panic_block = {
+	.notifier_call = ppc_panic_platform_handler,
+	.priority = INT_MIN, /* may not return; must be done last */
 };
 
 void __init setup_panic(void)
 {
+	/* Hard-disables IRQs + deal with FW-assisted dump (fadump) */
+	atomic_notifier_chain_register(&panic_notifier_list,
+				       &ppc_fadump_block);
+
 	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE) && kaslr_offset() > 0)
 		atomic_notifier_chain_register(&panic_notifier_list,
 					       &kernel_offset_notifier);
 
-	/* PPC64 always does a hard irq disable in its panic handler */
-	if (!IS_ENABLED(CONFIG_PPC64) && !ppc_md.panic)
-		return;
-	atomic_notifier_chain_register(&panic_notifier_list, &ppc_panic_block);
+	/* Low-level platform-specific routines that should run on panic */
+	if (ppc_md.panic)
+		atomic_notifier_chain_register(&panic_notifier_list,
+					       &ppc_panic_block);
 }
 
 #ifdef CONFIG_CHECK_CACHE_COHERENCY
-- 
2.36.0

