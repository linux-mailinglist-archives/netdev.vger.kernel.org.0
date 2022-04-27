Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3167A5125FE
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 00:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238914AbiD0Wzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 18:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238242AbiD0Wxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 18:53:44 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379BE8A30C;
        Wed, 27 Apr 2022 15:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=r/T7YOY0VHwWAfHSEqxJa3Wt3qfvSExYRCUKLKE/qpM=; b=XhhicIlaxPAENQgGkNSZu/8JWa
        MoKMtLET2WEey/cUMjdoOeeZp/qIHF9AnIAQ1U9UG9ceTx5YsNvbqlEug3W8sTqjMADP3kqZkWGXE
        81ePHhsZB9/Fl6O5VwXVIzqdUd2GxbFqpTJI3oISOjep5UHhEIJ1gEAyfbzeKWGz11qqm1H8SqNmy
        PIXViapEJaVN3g1qVA0ll8xOHoXY2Fth5HpQAgahG3Orvdyx32C20SUgZY0+6ymNqW2eIcskQ9hv0
        PnRYqaVu+GNdXU/wxDKHHXg22u4+P2b/VN7O5/RK6RnCNvbziWOBIpkgY1JIKXd1EMfFHtVMCWu3y
        LPmztM1w==;
Received: from [179.113.53.197] (helo=localhost)
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
        id 1njqTt-0001xj-VW; Thu, 28 Apr 2022 00:49:58 +0200
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
        will@kernel.org, "David P . Reed" <dpreed@deepplum.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 01/30] x86/crash,reboot: Avoid re-disabling VMX in all CPUs on crash/restart
Date:   Wed, 27 Apr 2022 19:48:55 -0300
Message-Id: <20220427224924.592546-2-gpiccoli@igalia.com>
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

In the panic path we have a list of functions to be called, the panic
notifiers - such callbacks perform various actions in the machine's
last breath, and sometimes users want them to run before kdump. We
have the parameter "crash_kexec_post_notifiers" for that. When such
parameter is used, the function "crash_smp_send_stop()" is executed
to poweroff all secondary CPUs through the NMI-shootdown mechanism;
part of this process involves disabling virtualization features in
all CPUs (except the main one).

Now, in the emergency restart procedure we have also a way of
disabling VMX in all CPUs, using the same NMI-shootdown mechanism;
what happens though is that in case we already NMI-disabled all CPUs,
the emergency restart fails due to a second addition of the same items
in the NMI list, as per the following log output:

sysrq: Trigger a crash
Kernel panic - not syncing: sysrq triggered crash
[...]
Rebooting in 2 seconds..
list_add double add: new=<addr1>, prev=<addr2>, next=<addr1>.
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:29!
invalid opcode: 0000 [#1] PREEMPT SMP PTI

In order to reproduce the problem, users just need to set the kernel
parameter "crash_kexec_post_notifiers" *without* kdump set in any
system with the VMX feature present.

Since there is no benefit in re-disabling VMX in all CPUs in case
it was already done, this patch prevents that by guarding the restart
routine against doubly issuing NMIs unnecessarily. Notice we still
need to disable VMX locally in the emergency restart.

Fixes: ed72736183c4 ("x86/reboot: Force all cpus to exit VMX root if VMX is supported)
Fixes: 0ee59413c967 ("x86/panic: replace smp_send_stop() with kdump friendly version in panic path")
Cc: David P. Reed <dpreed@deepplum.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---
 arch/x86/include/asm/cpu.h |  1 +
 arch/x86/kernel/crash.c    |  8 ++++----
 arch/x86/kernel/reboot.c   | 14 ++++++++++++--
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index 86e5e4e26fcb..b6a9062d387f 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -36,6 +36,7 @@ extern int _debug_hotplug_cpu(int cpu, int action);
 #endif
 #endif
 
+extern bool crash_cpus_stopped;
 int mwait_usable(const struct cpuinfo_x86 *);
 
 unsigned int x86_family(unsigned int sig);
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index e8326a8d1c5d..71dd1a990e8d 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -42,6 +42,8 @@
 #include <asm/crash.h>
 #include <asm/cmdline.h>
 
+bool crash_cpus_stopped;
+
 /* Used while preparing memory map entries for second kernel */
 struct crash_memmap_data {
 	struct boot_params *params;
@@ -108,9 +110,7 @@ void kdump_nmi_shootdown_cpus(void)
 /* Override the weak function in kernel/panic.c */
 void crash_smp_send_stop(void)
 {
-	static int cpus_stopped;
-
-	if (cpus_stopped)
+	if (crash_cpus_stopped)
 		return;
 
 	if (smp_ops.crash_stop_other_cpus)
@@ -118,7 +118,7 @@ void crash_smp_send_stop(void)
 	else
 		smp_send_stop();
 
-	cpus_stopped = 1;
+	crash_cpus_stopped = true;
 }
 
 #else
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index fa700b46588e..2fc42b8402ac 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -589,8 +589,18 @@ static void native_machine_emergency_restart(void)
 	int orig_reboot_type = reboot_type;
 	unsigned short mode;
 
-	if (reboot_emergency)
-		emergency_vmx_disable_all();
+	/*
+	 * We can reach this point in the end of panic path, having
+	 * NMI-disabled all secondary CPUs. This process involves
+	 * disabling the CPU virtualization technologies, so if that
+	 * is the case, we only miss disabling the local CPU VMX...
+	 */
+	if (reboot_emergency) {
+		if (!crash_cpus_stopped)
+			emergency_vmx_disable_all();
+		else
+			cpu_emergency_vmxoff();
+	}
 
 	tboot_shutdown(TB_SHUTDOWN_REBOOT);
 
-- 
2.36.0

