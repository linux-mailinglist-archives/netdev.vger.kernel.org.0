Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDCE57A7D3
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 21:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239772AbiGST7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 15:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240045AbiGST6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 15:58:53 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DEA954AEE;
        Tue, 19 Jul 2022 12:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=RpPIVWJSegZTJ1Zk+nlkNWLRtyKXlazgG8e/Axp3REs=; b=BSACue9cX6K/+P66zIiXJJjEw1
        5/iLWgR55WAotKu8EaOiH4LNs2o72lpFEx7fJGuxr5yYwPlC58BJ0GCa4vhOL/lJbIAuXHBKsoVeN
        3Yoza4x6t5HXe7ZuO8PdqXl1T8z+xyveJXIhnaHAyPw6aJB4D35Y0erYCzFov2dUweMLaAMdH0NcQ
        zGn8eLOuWL3cmskLQhDNSk7lk4UGyMaS9CG2RTlMiHzW66iiDGgov+IvNAgMSK7+lunck0NcgRTVw
        iEiar8HXTgrzWJ2N/aShm42Yan2nN4hNuAD+wYrIOrJGylP/Der0djf/yCd7ij+zKdwyVz1Htt47k
        OUP1ymyA==;
Received: from 200-100-212-117.dial-up.telesp.net.br ([200.100.212.117] helo=localhost)
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
        id 1oDtLx-006ffw-O7; Tue, 19 Jul 2022 21:57:58 +0200
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To:     akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
        kexec@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, x86@kernel.org, kernel-dev@igalia.com,
        kernel@gpiccoli.net, halves@canonical.com, fabiomirmar@gmail.com,
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
        will@kernel.org, "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        Andrea Parri <parri.andrea@gmail.com>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>
Subject: [PATCH v2 12/13] drivers/hv/vmbus, video/hyperv_fb: Untangle and refactor Hyper-V panic notifiers
Date:   Tue, 19 Jul 2022 16:53:25 -0300
Message-Id: <20220719195325.402745-13-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719195325.402745-1-gpiccoli@igalia.com>
References: <20220719195325.402745-1-gpiccoli@igalia.com>
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

Currently Hyper-V guests are among the most relevant users of the panic
infrastructure, like panic notifiers, kmsg dumpers, etc. The reasons rely
both in cleaning-up procedures (closing hypervisor <-> guest connection,
disabling some paravirtualized timer) as well as to data collection
(sending panic information to the hypervisor) and framebuffer management.

The thing is: some notifiers are related to others, ordering matters, some
functionalities are duplicated and there are lots of conditionals behind
sending panic information to the hypervisor. As part of an effort to
clean-up the panic notifiers mechanism and better document things, we
hereby address some of the issues/complexities of Hyper-V panic handling
through the following changes:

(a) We have die and panic notifiers on vmbus_drv.c and both have goals of
sending panic information to the hypervisor, though the panic notifier is
also responsible for a cleaning-up procedure.

This commit clears the code by splitting the panic notifier in two, one
for closing the vmbus connection whereas the other is only for sending
panic info to hypervisor. With that, it was possible to merge the die and
panic notifiers in a single/well-documented function, and clear some
conditional complexities on sending such information to the hypervisor.

(b) There is a Hyper-V framebuffer panic notifier, which relies in doing
a vmbus operation that demands a valid connection. So, we must order this
notifier with the panic notifier from vmbus_drv.c, to guarantee that the
framebuffer code executes before the vmbus connection is unloaded.

Also, this commit removes a useless header.

Although there is code rework and re-ordering, we expect that this change
has no functional regressions but instead optimize the path and increase
panic reliability on Hyper-V. This was tested on Hyper-V with success.

Cc: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Michael Kelley <mikelley@microsoft.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Tianyu Lan <Tianyu.Lan@microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>
Tested-by: Fabio A M Martins <fabiomirmar@gmail.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>

---


V2:
- Unfortunately we cannot rely in the crash shutdown (custom) handler
to perform the vmbus unload - arm64 architecture doesn't have this
"feature" [0]. So, in V2 we kept the notifier behavior and always
unload the vmbus connection, no matter what - thanks Michael for
pointing that;

- Removed the Fixes tags as per Michael suggestion;

- As per Petr suggestion, we abandoned the idea of distinguish among
notifiers using an id - so, in V2 we rely in the old and good address
comparison for that. Thanks Petr for the enriching discussion!

[0] https://lore.kernel.org/lkml/427a8277-49f0-4317-d6c3-4a15d7070e55@igalia.com/


 drivers/hv/vmbus_drv.c          | 109 +++++++++++++++++++-------------
 drivers/video/fbdev/hyperv_fb.c |   8 +++
 2 files changed, 74 insertions(+), 43 deletions(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 547ae334e5cd..75c5623e7289 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -25,7 +25,6 @@
 #include <linux/sched/task_stack.h>
 
 #include <linux/delay.h>
-#include <linux/notifier.h>
 #include <linux/panic_notifier.h>
 #include <linux/ptrace.h>
 #include <linux/screen_info.h>
@@ -69,53 +68,74 @@ static int hyperv_report_reg(void)
 	return !sysctl_record_panic_msg || !hv_panic_page;
 }
 
-static int hyperv_panic_event(struct notifier_block *nb, unsigned long val,
+/*
+ * The panic notifier below is responsible solely for unloading the
+ * vmbus connection, which is necessary in a panic event.
+ *
+ * Notice an intrincate relation of this notifier with Hyper-V
+ * framebuffer panic notifier exists - we need vmbus connection alive
+ * there in order to succeed, so we need to order both with each other
+ * [see hvfb_on_panic()] - this is done using notifiers' priorities.
+ */
+static int hv_panic_vmbus_unload(struct notifier_block *nb, unsigned long val,
 			      void *args)
+{
+	vmbus_initiate_unload(true);
+	return NOTIFY_DONE;
+}
+static struct notifier_block hyperv_panic_vmbus_unload_block = {
+	.notifier_call	= hv_panic_vmbus_unload,
+	.priority	= INT_MIN + 1, /* almost the latest one to execute */
+};
+
+static int hv_die_panic_notify_crash(struct notifier_block *self,
+				     unsigned long val, void *args);
+
+static struct notifier_block hyperv_die_report_block = {
+	.notifier_call = hv_die_panic_notify_crash,
+};
+static struct notifier_block hyperv_panic_report_block = {
+	.notifier_call = hv_die_panic_notify_crash,
+};
+
+/*
+ * The following callback works both as die and panic notifier; its
+ * goal is to provide panic information to the hypervisor unless the
+ * kmsg dumper is used [see hv_kmsg_dump()], which provides more
+ * information but isn't always available.
+ *
+ * Notice that both the panic/die report notifiers are registered only
+ * if we have the capability HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE set.
+ */
+static int hv_die_panic_notify_crash(struct notifier_block *self,
+				     unsigned long val, void *args)
 {
 	struct pt_regs *regs;
+	bool is_die;
 
-	vmbus_initiate_unload(true);
-
-	/*
-	 * Hyper-V should be notified only once about a panic.  If we will be
-	 * doing hv_kmsg_dump() with kmsg data later, don't do the notification
-	 * here.
-	 */
-	if (ms_hyperv.misc_features & HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE
-	    && hyperv_report_reg()) {
+	/* Don't notify Hyper-V unless we have a die oops event or panic. */
+	if (self == &hyperv_panic_report_block) {
+		is_die = false;
 		regs = current_pt_regs();
-		hyperv_report_panic(regs, val, false);
+	} else { /* die event */
+		if (val != DIE_OOPS)
+			return NOTIFY_DONE;
+
+		is_die = true;
+		regs = ((struct die_args *)args)->regs;
 	}
-	return NOTIFY_DONE;
-}
-
-static int hyperv_die_event(struct notifier_block *nb, unsigned long val,
-			    void *args)
-{
-	struct die_args *die = args;
-	struct pt_regs *regs = die->regs;
-
-	/* Don't notify Hyper-V if the die event is other than oops */
-	if (val != DIE_OOPS)
-		return NOTIFY_DONE;
 
 	/*
-	 * Hyper-V should be notified only once about a panic.  If we will be
-	 * doing hv_kmsg_dump() with kmsg data later, don't do the notification
-	 * here.
+	 * Hyper-V should be notified only once about a panic/die. If we will
+	 * be calling hv_kmsg_dump() later with kmsg data, don't do the
+	 * notification here.
 	 */
 	if (hyperv_report_reg())
-		hyperv_report_panic(regs, val, true);
+		hyperv_report_panic(regs, val, is_die);
+
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block hyperv_die_block = {
-	.notifier_call = hyperv_die_event,
-};
-static struct notifier_block hyperv_panic_block = {
-	.notifier_call = hyperv_panic_event,
-};
-
 static const char *fb_mmio_name = "fb_range";
 static struct resource *fb_mmio;
 static struct resource *hyperv_mmio;
@@ -1534,16 +1554,17 @@ static int vmbus_bus_init(void)
 		if (hyperv_crash_ctl & HV_CRASH_CTL_CRASH_NOTIFY_MSG)
 			hv_kmsg_dump_register();
 
-		register_die_notifier(&hyperv_die_block);
+		register_die_notifier(&hyperv_die_report_block);
+		atomic_notifier_chain_register(&panic_notifier_list,
+						&hyperv_panic_report_block);
 	}
 
 	/*
-	 * Always register the panic notifier because we need to unload
-	 * the VMbus channel connection to prevent any VMbus
-	 * activity after the VM panics.
+	 * Always register the vmbus unload panic notifier because we
+	 * need to shut the VMbus channel connection on panic.
 	 */
 	atomic_notifier_chain_register(&panic_notifier_list,
-			       &hyperv_panic_block);
+			       &hyperv_panic_vmbus_unload_block);
 
 	vmbus_request_offers();
 
@@ -2765,15 +2786,17 @@ static void __exit vmbus_exit(void)
 
 	if (ms_hyperv.misc_features & HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE) {
 		kmsg_dump_unregister(&hv_kmsg_dumper);
-		unregister_die_notifier(&hyperv_die_block);
+		unregister_die_notifier(&hyperv_die_report_block);
+		atomic_notifier_chain_unregister(&panic_notifier_list,
+						&hyperv_panic_report_block);
 	}
 
 	/*
-	 * The panic notifier is always registered, hence we should
+	 * The vmbus panic notifier is always registered, hence we should
 	 * also unconditionally unregister it here as well.
 	 */
 	atomic_notifier_chain_unregister(&panic_notifier_list,
-					 &hyperv_panic_block);
+					&hyperv_panic_vmbus_unload_block);
 
 	free_page((unsigned long)hv_panic_page);
 	unregister_sysctl_table(hv_ctl_table_hdr);
diff --git a/drivers/video/fbdev/hyperv_fb.c b/drivers/video/fbdev/hyperv_fb.c
index e1b65a01fb96..9234d31d4305 100644
--- a/drivers/video/fbdev/hyperv_fb.c
+++ b/drivers/video/fbdev/hyperv_fb.c
@@ -1216,7 +1216,15 @@ static int hvfb_probe(struct hv_device *hdev,
 	par->fb_ready = true;
 
 	par->synchronous_fb = false;
+
+	/*
+	 * We need to be sure this panic notifier runs _before_ the
+	 * vmbus disconnect, so order it by priority. It must execute
+	 * before the function hv_panic_vmbus_unload() [drivers/hv/vmbus_drv.c],
+	 * which is almost at the end of list, with priority = INT_MIN + 1.
+	 */
 	par->hvfb_panic_nb.notifier_call = hvfb_on_panic;
+	par->hvfb_panic_nb.priority = INT_MIN + 10,
 	atomic_notifier_chain_register(&panic_notifier_list,
 				       &par->hvfb_panic_nb);
 
-- 
2.37.1

