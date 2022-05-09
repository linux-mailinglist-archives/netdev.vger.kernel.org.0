Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2D625201B1
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 17:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238704AbiEIP5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 11:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238779AbiEIP4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 11:56:52 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275CF1FD853
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 08:52:55 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id gj17-20020a17090b109100b001d8b390f77bso17372991pjb.1
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 08:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CAxFYwx9au8ndjamrxPXEwi/2awSLBgQaCrWU0hhgV8=;
        b=sFEfltNQCVk2gKdSF95eO+6o5Oi9iHPAu9XMn5y7AVrB1PpZKrmSauv2vxy2epRHmZ
         NSr62ka7zLG3Gl54pw2fv1HHOqJzmWG+qcYMGudJBID58EtUah//Q/zwiMX8Beifo5Lh
         iXK5FpZRJsooYlIrPkKyk6xy3QQYJz/0u49tSn3qe+yDBvjo3SSASrt46ZFrb6+hHFvW
         H7/yN/ph8EWKTn0C9heTUB8cdpuCpaAeBHKYWIuDAIJkN6Hj0/oODbz/oRPz+ovRDe/T
         g9WoeDulJNTK3wKvSf95Pd6PuXhjpO0IWRLXy6yWL9wRfFaZ8a0IDJZWtt84gKIK5eWZ
         z7iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CAxFYwx9au8ndjamrxPXEwi/2awSLBgQaCrWU0hhgV8=;
        b=BF7lI5GlZTZhPBvHgB+Jl4mK/6s/wZDyIvobv3Gc1aMC2n+OAulIK8niIcHesBYrrG
         fNXVvnsiynvEcUIDShuqGl+LcXsb7NoDQ/84cNZlP8wO2RtQ/Imi2lS1FRcRu+U/0Ok+
         dagQYm0ipErQ0udEgrEyZ+Sjq656sJpprb8/TrDnPMY7vLnccWACsqzyrXSGQZNmLlOq
         ooJeR3E/83wE4IXA8gY1PHryGnoegWIdLAZFn/ed9zon9OpkQCJgc3uYWyO6J0BNJKCi
         XQDEIh6nijrqpFdHHckxDMI6QHrHMPkOVT492nbjBIAlTNiLAw+S+vwnDcsbBDBMDxNv
         AG/g==
X-Gm-Message-State: AOAM531UGtkGbcYv0MY/9BLogKHNEaVk5+imLzXyslLadp12zBkQy1L8
        cgQ9k+joNSt8prviT+elMgHifg==
X-Google-Smtp-Source: ABdhPJysrIMHQqC/1OMD5SyWpentMn8Vwv24RP/WWPrWWVvg2aHHDob94JmsHZxC4PVEzZOqPXHCmA==
X-Received: by 2002:a17:90b:1091:b0:1d8:b371:4b29 with SMTP id gj17-20020a17090b109100b001d8b3714b29mr26584916pjb.234.1652111574246;
        Mon, 09 May 2022 08:52:54 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c2-20020aa79522000000b0050dc7628164sm8941672pfp.62.2022.05.09.08.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 08:52:53 -0700 (PDT)
Date:   Mon, 9 May 2022 15:52:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
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
        kernel-dev@igalia.com, kernel@gpiccoli.net, halves@canonical.com,
        fabiomirmar@gmail.com, alejandro.j.jimenez@oracle.com,
        andriy.shevchenko@linux.intel.com, arnd@arndb.de, bp@alien8.de,
        corbet@lwn.net, d.hatayama@jp.fujitsu.com,
        dave.hansen@linux.intel.com, dyoung@redhat.com,
        feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org, "David P . Reed" <dpreed@deepplum.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 01/30] x86/crash,reboot: Avoid re-disabling VMX in all
 CPUs on crash/restart
Message-ID: <Ynk40U/KA+hLBZRC@google.com>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-2-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="J4vquNhda08TmTtV"
Content-Disposition: inline
In-Reply-To: <20220427224924.592546-2-gpiccoli@igalia.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--J4vquNhda08TmTtV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I find the shortlog to be very confusing, the bug has nothing to do with disabling
VMX and I distinctly remember wrapping VMXOFF with exception fixup to prevent doom
if VMX is already disabled :-).  The issue is really that nmi_shootdown_cpus() doesn't
play nice with being called twice.

On Wed, Apr 27, 2022, Guilherme G. Piccoli wrote:
> In the panic path we have a list of functions to be called, the panic
> notifiers - such callbacks perform various actions in the machine's
> last breath, and sometimes users want them to run before kdump. We
> have the parameter "crash_kexec_post_notifiers" for that. When such
> parameter is used, the function "crash_smp_send_stop()" is executed
> to poweroff all secondary CPUs through the NMI-shootdown mechanism;
> part of this process involves disabling virtualization features in
> all CPUs (except the main one).
> 
> Now, in the emergency restart procedure we have also a way of
> disabling VMX in all CPUs, using the same NMI-shootdown mechanism;
> what happens though is that in case we already NMI-disabled all CPUs,
> the emergency restart fails due to a second addition of the same items
> in the NMI list, as per the following log output:
> 
> sysrq: Trigger a crash
> Kernel panic - not syncing: sysrq triggered crash
> [...]
> Rebooting in 2 seconds..
> list_add double add: new=<addr1>, prev=<addr2>, next=<addr1>.
> ------------[ cut here ]------------
> kernel BUG at lib/list_debug.c:29!
> invalid opcode: 0000 [#1] PREEMPT SMP PTI

Call stacks for the two callers would be very, very helpful.

> In order to reproduce the problem, users just need to set the kernel
> parameter "crash_kexec_post_notifiers" *without* kdump set in any
> system with the VMX feature present.
> 
> Since there is no benefit in re-disabling VMX in all CPUs in case
> it was already done, this patch prevents that by guarding the restart
> routine against doubly issuing NMIs unnecessarily. Notice we still
> need to disable VMX locally in the emergency restart.
> 
> Fixes: ed72736183c4 ("x86/reboot: Force all cpus to exit VMX root if VMX is supported)
> Fixes: 0ee59413c967 ("x86/panic: replace smp_send_stop() with kdump friendly version in panic path")
> Cc: David P. Reed <dpreed@deepplum.com>
> Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> ---
>  arch/x86/include/asm/cpu.h |  1 +
>  arch/x86/kernel/crash.c    |  8 ++++----
>  arch/x86/kernel/reboot.c   | 14 ++++++++++++--
>  3 files changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
> index 86e5e4e26fcb..b6a9062d387f 100644
> --- a/arch/x86/include/asm/cpu.h
> +++ b/arch/x86/include/asm/cpu.h
> @@ -36,6 +36,7 @@ extern int _debug_hotplug_cpu(int cpu, int action);
>  #endif
>  #endif
>  
> +extern bool crash_cpus_stopped;
>  int mwait_usable(const struct cpuinfo_x86 *);
>  
>  unsigned int x86_family(unsigned int sig);
> diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
> index e8326a8d1c5d..71dd1a990e8d 100644
> --- a/arch/x86/kernel/crash.c
> +++ b/arch/x86/kernel/crash.c
> @@ -42,6 +42,8 @@
>  #include <asm/crash.h>
>  #include <asm/cmdline.h>
>  
> +bool crash_cpus_stopped;
> +
>  /* Used while preparing memory map entries for second kernel */
>  struct crash_memmap_data {
>  	struct boot_params *params;
> @@ -108,9 +110,7 @@ void kdump_nmi_shootdown_cpus(void)
>  /* Override the weak function in kernel/panic.c */
>  void crash_smp_send_stop(void)
>  {
> -	static int cpus_stopped;
> -
> -	if (cpus_stopped)
> +	if (crash_cpus_stopped)
>  		return;
>  
>  	if (smp_ops.crash_stop_other_cpus)
> @@ -118,7 +118,7 @@ void crash_smp_send_stop(void)
>  	else
>  		smp_send_stop();
>  
> -	cpus_stopped = 1;
> +	crash_cpus_stopped = true;

This feels like were just adding more duct tape to the mess.  nmi_shootdown() is
still unsafe for more than one caller, and it takes a _lot_ of staring and searching
to understand that crash_smp_send_stop() is invoked iff CONFIG_KEXEC_CORE=y, i.e.
that it will call smp_ops.crash_stop_other_cpus() and not just smp_send_stop().

Rather than shared a flag between two relatively unrelated functions, what if we
instead disabling virtualization in crash_nmi_callback() and then turn the reboot
call into a nop if an NMI shootdown has already occurred?  That will also add a
bit of documentation about multiple shootdowns not working.

And I believe there's also a lurking bug in native_machine_emergency_restart() that
can be fixed with cleanup.  SVM can also block INIT and so should be disabled during
an emergency reboot.

The attached patches are compile tested only.  If they seem sane, I'll post an
official mini series.

>  }
>  
>  #else
> diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
> index fa700b46588e..2fc42b8402ac 100644
> --- a/arch/x86/kernel/reboot.c
> +++ b/arch/x86/kernel/reboot.c
> @@ -589,8 +589,18 @@ static void native_machine_emergency_restart(void)
>  	int orig_reboot_type = reboot_type;
>  	unsigned short mode;
>  
> -	if (reboot_emergency)
> -		emergency_vmx_disable_all();
> +	/*
> +	 * We can reach this point in the end of panic path, having
> +	 * NMI-disabled all secondary CPUs. This process involves
> +	 * disabling the CPU virtualization technologies, so if that
> +	 * is the case, we only miss disabling the local CPU VMX...
> +	 */
> +	if (reboot_emergency) {
> +		if (!crash_cpus_stopped)
> +			emergency_vmx_disable_all();
> +		else
> +			cpu_emergency_vmxoff();
> +	}
>  
>  	tboot_shutdown(TB_SHUTDOWN_REBOOT);
>  
> -- 
> 2.36.0
> 

--J4vquNhda08TmTtV
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-x86-crash-Disable-virt-in-core-NMI-crash-handler-to-.patch"

From 8a4573b7cf3a3e49b409ba3a504934de181c259d Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Mon, 9 May 2022 07:36:34 -0700
Subject: [PATCH 1/2] x86/crash: Disable virt in core NMI crash handler to
 avoid double list_add

Disable virtualization in crash_nmi_callback() and skip the requested NMI
shootdown if a shootdown has already occurred, i.e. a callback has been
registered.  The NMI crash shootdown path doesn't play nice with multiple
invocations, e.g. attempting to register the NMI handler multiple times
will trigger a double list_add() and hang the sytem (in addition to
multiple other issues).  If "crash_kexec_post_notifiers" is specified on
the kernel command line, panic() will invoke crash_smp_send_stop() and
result in a second call to nmi_shootdown_cpus() during
native_machine_emergency_restart().

Invoke the callback _before_ disabling virtualization, as the current
VMCS needs to be cleared before doing VMXOFF.  Note, this results in a
subtle change in ordering between disabling virtualization and stopping
Intel PT on the responding CPUs.  While VMX and Intel PT do interact,
VMXOFF and writes to MSR_IA32_RTIT_CTL do not induce faults between one
another, which is all that matters when panicking.

WARN if nmi_shootdown_cpus() is called a second time with anything other
than the reboot path's "nop" handler, as bailing means the requested
isn't being invoked.  Punt true handling of multiple shootdown callbacks
until there's an actual use case for doing so (beyond disabling
virtualization).

Extract the disabling logic to a common helper to deduplicate code, and
to prepare for doing the shootdown in the emergency reboot path if SVM
is supported.

Note, prior to commit ed72736183c4 ("x86/reboot: Force all cpus to exit
VMX root if VMX is supported), nmi_shootdown_cpus() was subtly protected
against a second invocation by a cpu_vmx_enabled() check as the kdump
handler would disable VMX if it ran first.

Fixes: ed72736183c4 ("x86/reboot: Force all cpus to exit VMX root if VMX is supported)
Cc: stable@vger.kernel.org
Reported-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/reboot.h |  1 +
 arch/x86/kernel/crash.c       | 16 +--------------
 arch/x86/kernel/reboot.c      | 38 ++++++++++++++++++++++++++++++++---
 3 files changed, 37 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/reboot.h b/arch/x86/include/asm/reboot.h
index 04c17be9b5fd..8f2da36435a6 100644
--- a/arch/x86/include/asm/reboot.h
+++ b/arch/x86/include/asm/reboot.h
@@ -25,6 +25,7 @@ void __noreturn machine_real_restart(unsigned int type);
 #define MRR_BIOS	0
 #define MRR_APM		1
 
+void cpu_crash_disable_virtualization(void);
 typedef void (*nmi_shootdown_cb)(int, struct pt_regs*);
 void nmi_panic_self_stop(struct pt_regs *regs);
 void nmi_shootdown_cpus(nmi_shootdown_cb callback);
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index e8326a8d1c5d..fe0cf83843ba 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -81,15 +81,6 @@ static void kdump_nmi_callback(int cpu, struct pt_regs *regs)
 	 */
 	cpu_crash_vmclear_loaded_vmcss();
 
-	/* Disable VMX or SVM if needed.
-	 *
-	 * We need to disable virtualization on all CPUs.
-	 * Having VMX or SVM enabled on any CPU may break rebooting
-	 * after the kdump kernel has finished its task.
-	 */
-	cpu_emergency_vmxoff();
-	cpu_emergency_svm_disable();
-
 	/*
 	 * Disable Intel PT to stop its logging
 	 */
@@ -148,12 +139,7 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
 	 */
 	cpu_crash_vmclear_loaded_vmcss();
 
-	/* Booting kdump kernel with VMX or SVM enabled won't work,
-	 * because (among other limitations) we can't disable paging
-	 * with the virt flags.
-	 */
-	cpu_emergency_vmxoff();
-	cpu_emergency_svm_disable();
+	cpu_crash_disable_virtualization();
 
 	/*
 	 * Disable Intel PT to stop its logging
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index fa700b46588e..f9543a4e9b09 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -528,9 +528,9 @@ static inline void kb_wait(void)
 	}
 }
 
-static void vmxoff_nmi(int cpu, struct pt_regs *regs)
+static void nmi_shootdown_nop(int cpu, struct pt_regs *regs)
 {
-	cpu_emergency_vmxoff();
+	/* Nothing to do, the NMI shootdown handler disables virtualization. */
 }
 
 /* Use NMIs as IPIs to tell all CPUs to disable virtualization */
@@ -554,7 +554,7 @@ static void emergency_vmx_disable_all(void)
 		__cpu_emergency_vmxoff();
 
 		/* Halt and exit VMX root operation on the other CPUs. */
-		nmi_shootdown_cpus(vmxoff_nmi);
+		nmi_shootdown_cpus(nmi_shootdown_nop);
 	}
 }
 
@@ -802,6 +802,18 @@ static nmi_shootdown_cb shootdown_callback;
 static atomic_t waiting_for_crash_ipi;
 static int crash_ipi_issued;
 
+void cpu_crash_disable_virtualization(void)
+{
+	/*
+	 * Disable virtualization, i.e. VMX or SVM, so that INIT is recognized
+	 * during reboot.  VMX blocks INIT if the CPU is post-VMXON, and SVM
+	 * blocks INIT if GIF=0.  Note, CLGI #UDs if SVM isn't enabled, so it's
+	 * easier to just disable SVM unconditionally.
+	 */
+	cpu_emergency_vmxoff();
+	cpu_emergency_svm_disable();
+}
+
 static int crash_nmi_callback(unsigned int val, struct pt_regs *regs)
 {
 	int cpu;
@@ -819,6 +831,12 @@ static int crash_nmi_callback(unsigned int val, struct pt_regs *regs)
 
 	shootdown_callback(cpu, regs);
 
+	/*
+	 * Prepare the CPU for reboot _after_ invoking the callback so that the
+	 * callback can safely use virtualization instructions, e.g. VMCLEAR.
+	 */
+	cpu_crash_disable_virtualization();
+
 	atomic_dec(&waiting_for_crash_ipi);
 	/* Assume hlt works */
 	halt();
@@ -840,6 +858,20 @@ void nmi_shootdown_cpus(nmi_shootdown_cb callback)
 	unsigned long msecs;
 	local_irq_disable();
 
+	/*
+	 * Invoking multiple callbacks is not currently supported, registering
+	 * the NMI handler twice will cause a list_add() double add BUG().
+	 * The exception is the "nop" handler in the emergency reboot path,
+	 * which can run after e.g. kdump's shootdown.  Do nothing if the crash
+	 * handler has already run, i.e. has already prepared other CPUs, the
+	 * reboot path doesn't have any work of its to do, it just needs to
+	 * ensure all CPUs have prepared for reboot.
+	 */
+	if (shootdown_callback) {
+		WARN_ON_ONCE(callback != nmi_shootdown_nop);
+		return;
+	}
+
 	/* Make a note of crashing cpu. Will be used in NMI callback. */
 	crashing_cpu = safe_smp_processor_id();
 

base-commit: 2764011106d0436cb44702cfb0981339d68c3509
-- 
2.36.0.512.ge40c2bad7a-goog


--J4vquNhda08TmTtV
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-x86-reboot-Disable-virtualization-in-an-emergency-if.patch"

From ce4b8fb50962c00a9bb29663e96501e90d68bd8b Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Mon, 9 May 2022 08:28:14 -0700
Subject: [PATCH 2/2] x86/reboot: Disable virtualization in an emergency if SVM
 is supported

Disable SVM on all CPUs via NMI shootdown during an emergency reboot.
Like VMX, SVM can block INIT and thus prevent bringing up other CPUs via
INIT-SIPI-SIPI.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kernel/reboot.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index f9543a4e9b09..33c1f4883b27 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -533,27 +533,29 @@ static void nmi_shootdown_nop(int cpu, struct pt_regs *regs)
 	/* Nothing to do, the NMI shootdown handler disables virtualization. */
 }
 
-/* Use NMIs as IPIs to tell all CPUs to disable virtualization */
-static void emergency_vmx_disable_all(void)
+static void emergency_reboot_disable_virtualization(void)
 {
 	/* Just make sure we won't change CPUs while doing this */
 	local_irq_disable();
 
 	/*
-	 * Disable VMX on all CPUs before rebooting, otherwise we risk hanging
-	 * the machine, because the CPU blocks INIT when it's in VMX root.
+	 * Disable virtualization on all CPUs before rebooting to avoid hanging
+	 * the system, as VMX and SVM block INIT when running in the host
 	 *
 	 * We can't take any locks and we may be on an inconsistent state, so
-	 * use NMIs as IPIs to tell the other CPUs to exit VMX root and halt.
+	 * use NMIs as IPIs to tell the other CPUs to disable VMX/SVM and halt.
 	 *
-	 * Do the NMI shootdown even if VMX if off on _this_ CPU, as that
-	 * doesn't prevent a different CPU from being in VMX root operation.
+	 * Do the NMI shootdown even if virtualization is off on _this_ CPU, as
+	 * other CPUs may have virtualization enabled.
 	 */
-	if (cpu_has_vmx()) {
-		/* Safely force _this_ CPU out of VMX root operation. */
-		__cpu_emergency_vmxoff();
+	if (cpu_has_vmx() || cpu_has_svm(NULL)) {
+		/* Safely force _this_ CPU out of VMX/SVM operation. */
+		if (cpu_has_vmx())
+			__cpu_emergency_vmxoff();
+		else
+			cpu_emergency_svm_disable();
 
-		/* Halt and exit VMX root operation on the other CPUs. */
+		/* Disable VMX/SVM and halt on other CPUs. */
 		nmi_shootdown_cpus(nmi_shootdown_nop);
 	}
 }
@@ -590,7 +592,7 @@ static void native_machine_emergency_restart(void)
 	unsigned short mode;
 
 	if (reboot_emergency)
-		emergency_vmx_disable_all();
+		emergency_reboot_disable_virtualization();
 
 	tboot_shutdown(TB_SHUTDOWN_REBOOT);
 
-- 
2.36.0.512.ge40c2bad7a-goog


--J4vquNhda08TmTtV--
