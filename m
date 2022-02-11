Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFDFC4B24EF
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 12:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349687AbiBKLzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 06:55:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348708AbiBKLy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 06:54:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C24EB0;
        Fri, 11 Feb 2022 03:54:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEAA461A85;
        Fri, 11 Feb 2022 11:54:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E67C340E9;
        Fri, 11 Feb 2022 11:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644580497;
        bh=AqzEZAS4WA0TSnxTUDPC4IrboYfude+0D1mk4wwS4Y4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IFzoOn80eAmWQwhp8kuz5fi3l20MPogir8v4POTmO3ad1yCK7I2LnjpIWFgCQiwjM
         OlbkIPXW4f1Z0vQhjgImPHjyrT3ETbTNuriPWY87vlj1TMK2SrWeLak7O+tyfmCoAV
         24Mz4rZQdDOIyp+6OfWUVIuQkXFO1WIzpVIlQq+coSEbKh1/yfXn+wSY6Ga97zwpcs
         U2Dw2/3kIgTDATZuljLB+qa/RzDygWX6G5dCBQ+WZwHSwkgCgNVViAWfK9BwG44X2U
         gp+XjY/Yg9NxmwLOrsyijsYyGgg8Ct1IwftkoP06N2OVsXZeJPOpjg3jbA6qPi9MgN
         e7+FtW1sTwevA==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH v8 04/11] rethook: x86: Add rethook x86 implementation
Date:   Fri, 11 Feb 2022 20:54:52 +0900
Message-Id: <164458049178.586276.5959702486087117657.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <164458044634.586276.3261555265565111183.stgit@devnote2>
References: <164458044634.586276.3261555265565111183.stgit@devnote2>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add rethook for x86 implementation. Most of the code has been copied from
kretprobes on x86.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 Changes in v5:
  - Fix a build error if !CONFIG_KRETPROBES and !CONFIG_RETHOOK.
 Changes in v4:
  - fix stack backtrace as same as kretprobe does.
---
 arch/x86/Kconfig                 |    1 
 arch/x86/include/asm/unwind.h    |    8 ++-
 arch/x86/kernel/Makefile         |    1 
 arch/x86/kernel/kprobes/common.h |    1 
 arch/x86/kernel/rethook.c        |  115 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 125 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kernel/rethook.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9f5bd41bf660..a91373c56d9f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -220,6 +220,7 @@ config X86
 	select HAVE_KPROBES_ON_FTRACE
 	select HAVE_FUNCTION_ERROR_INJECTION
 	select HAVE_KRETPROBES
+	select HAVE_RETHOOK
 	select HAVE_KVM
 	select HAVE_LIVEPATCH			if X86_64
 	select HAVE_MIXED_BREAKPOINTS_REGS
diff --git a/arch/x86/include/asm/unwind.h b/arch/x86/include/asm/unwind.h
index 2a1f8734416d..192df5b2094d 100644
--- a/arch/x86/include/asm/unwind.h
+++ b/arch/x86/include/asm/unwind.h
@@ -5,6 +5,7 @@
 #include <linux/sched.h>
 #include <linux/ftrace.h>
 #include <linux/kprobes.h>
+#include <linux/rethook.h>
 #include <asm/ptrace.h>
 #include <asm/stacktrace.h>
 
@@ -16,7 +17,7 @@ struct unwind_state {
 	unsigned long stack_mask;
 	struct task_struct *task;
 	int graph_idx;
-#ifdef CONFIG_KRETPROBES
+#if defined(CONFIG_KRETPROBES) || defined(CONFIG_RETHOOK)
 	struct llist_node *kr_cur;
 #endif
 	bool error;
@@ -107,6 +108,11 @@ static inline
 unsigned long unwind_recover_kretprobe(struct unwind_state *state,
 				       unsigned long addr, unsigned long *addr_p)
 {
+#ifdef CONFIG_RETHOOK
+	if (is_rethook_trampoline(addr))
+		return rethook_find_ret_addr(state->task, (unsigned long)addr_p,
+					     &state->kr_cur);
+#endif
 #ifdef CONFIG_KRETPROBES
 	return is_kretprobe_trampoline(addr) ?
 		kretprobe_find_ret_addr(state->task, addr_p, &state->kr_cur) :
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 6aef9ee28a39..792a893a5cc5 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -106,6 +106,7 @@ obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += ftrace.o
 obj-$(CONFIG_FTRACE_SYSCALLS)	+= ftrace.o
 obj-$(CONFIG_X86_TSC)		+= trace_clock.o
 obj-$(CONFIG_TRACING)		+= trace.o
+obj-$(CONFIG_RETHOOK)		+= rethook.o
 obj-$(CONFIG_CRASH_CORE)	+= crash_core_$(BITS).o
 obj-$(CONFIG_KEXEC_CORE)	+= machine_kexec_$(BITS).o
 obj-$(CONFIG_KEXEC_CORE)	+= relocate_kernel_$(BITS).o crash.o
diff --git a/arch/x86/kernel/kprobes/common.h b/arch/x86/kernel/kprobes/common.h
index 7d3a2e2daf01..c993521d4933 100644
--- a/arch/x86/kernel/kprobes/common.h
+++ b/arch/x86/kernel/kprobes/common.h
@@ -6,6 +6,7 @@
 
 #include <asm/asm.h>
 #include <asm/frame.h>
+#include <asm/insn.h>
 
 #ifdef CONFIG_X86_64
 
diff --git a/arch/x86/kernel/rethook.c b/arch/x86/kernel/rethook.c
new file mode 100644
index 000000000000..f2f3b9526e43
--- /dev/null
+++ b/arch/x86/kernel/rethook.c
@@ -0,0 +1,115 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * x86 implementation of rethook. Mostly copied from arch/x86/kernel/kprobes/core.c.
+ */
+#include <linux/bug.h>
+#include <linux/rethook.h>
+#include <linux/kprobes.h>
+
+#include "kprobes/common.h"
+
+/*
+ * Called from arch_rethook_trampoline
+ */
+__used __visible void arch_rethook_trampoline_callback(struct pt_regs *regs)
+{
+	unsigned long *frame_pointer;
+
+	/* fixup registers */
+	regs->cs = __KERNEL_CS;
+#ifdef CONFIG_X86_32
+	regs->gs = 0;
+#endif
+	regs->ip = (unsigned long)&arch_rethook_trampoline;
+	regs->orig_ax = ~0UL;
+	regs->sp += sizeof(long);
+	frame_pointer = &regs->sp + 1;
+
+	/*
+	 * The return address at 'frame_pointer' is recovered by the
+	 * arch_rethook_fixup_return() which called from this
+	 * rethook_trampoline_handler().
+	 */
+	rethook_trampoline_handler(regs, (unsigned long)frame_pointer);
+
+	/*
+	 * Copy FLAGS to 'pt_regs::sp' so that arch_rethook_trapmoline()
+	 * can do RET right after POPF.
+	 */
+	regs->sp = regs->flags;
+}
+NOKPROBE_SYMBOL(arch_rethook_trampoline_callback);
+
+/*
+ * When a target function returns, this code saves registers and calls
+ * arch_rethook_trampoline_callback(), which calls the rethook handler.
+ */
+asm(
+	".text\n"
+	".global arch_rethook_trampoline\n"
+	".type arch_rethook_trampoline, @function\n"
+	"arch_rethook_trampoline:\n"
+#ifdef CONFIG_X86_64
+	/* Push a fake return address to tell the unwinder it's a kretprobe. */
+	"	pushq $arch_rethook_trampoline\n"
+	UNWIND_HINT_FUNC
+	/* Save the 'sp - 8', this will be fixed later. */
+	"	pushq %rsp\n"
+	"	pushfq\n"
+	SAVE_REGS_STRING
+	"	movq %rsp, %rdi\n"
+	"	call arch_rethook_trampoline_callback\n"
+	RESTORE_REGS_STRING
+	/* In the callback function, 'regs->flags' is copied to 'regs->sp'. */
+	"	addq $8, %rsp\n"
+	"	popfq\n"
+#else
+	/* Push a fake return address to tell the unwinder it's a kretprobe. */
+	"	pushl $arch_rethook_trampoline\n"
+	UNWIND_HINT_FUNC
+	/* Save the 'sp - 4', this will be fixed later. */
+	"	pushl %esp\n"
+	"	pushfl\n"
+	SAVE_REGS_STRING
+	"	movl %esp, %eax\n"
+	"	call arch_rethook_trampoline_callback\n"
+	RESTORE_REGS_STRING
+	/* In the callback function, 'regs->flags' is copied to 'regs->sp'. */
+	"	addl $4, %esp\n"
+	"	popfl\n"
+#endif
+	"	ret\n"
+	".size arch_rethook_trampoline, .-arch_rethook_trampoline\n"
+);
+NOKPROBE_SYMBOL(arch_rethook_trampoline);
+/*
+ * arch_rethook_trampoline() skips updating frame pointer. The frame pointer
+ * saved in arch_rethook_trampoline_callback() points to the real caller
+ * function's frame pointer. Thus the arch_rethook_trampoline() doesn't have
+ * a standard stack frame with CONFIG_FRAME_POINTER=y.
+ * Let's mark it non-standard function. Anyway, FP unwinder can correctly
+ * unwind without the hint.
+ */
+STACK_FRAME_NON_STANDARD_FP(arch_rethook_trampoline);
+
+/* This is called from rethook_trampoline_handler(). */
+void arch_rethook_fixup_return(struct pt_regs *regs,
+			       unsigned long correct_ret_addr)
+{
+	unsigned long *frame_pointer = &regs->sp + 1;
+
+	/* Replace fake return address with real one. */
+	*frame_pointer = correct_ret_addr;
+}
+
+void arch_rethook_prepare(struct rethook_node *rh, struct pt_regs *regs)
+{
+	unsigned long *stack = (unsigned long *)regs->sp;
+
+	rh->ret_addr = stack[0];
+	rh->frame = regs->sp;
+
+	/* Replace the return addr with trampoline addr */
+	stack[0] = (unsigned long) arch_rethook_trampoline;
+}
+NOKPROBE_SYMBOL(arch_rethook_prepare);

