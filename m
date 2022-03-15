Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8FF4D9CDB
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 15:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348961AbiCOODJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 10:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349015AbiCOODD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 10:03:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA55546BD;
        Tue, 15 Mar 2022 07:01:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3238B81676;
        Tue, 15 Mar 2022 14:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A6EC340ED;
        Tue, 15 Mar 2022 14:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647352902;
        bh=+XGvUyRySLT2gAjqqif/Q4lJFpEOZToW6bgZ38TpllQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sVjDwgSji7mXDEy8JMgqIost6zNZuqS4o0vYNqO1UAvQ36R7cHoD3UD1TtLmqEBUR
         klBtM5AORCYi9j8AWYM+gv/FH0bNbuOYpEb+S3CSe1MGLznGhRTUA2Gb7/l8XNpV9g
         wu/qE8Cud3kz+9sRYAlixH1BztdTF5S/Hp0Xv9e8tnTzgLbNRK9TQemyxhBh4Yawhh
         9cNC3c1HNPjAQfBAGrvBA2p2azAQVNsvgSQtFPJRwnDzgUkTjmxz82gZe52+BbA1rh
         VmXA3oHgUkxg6c0gmGtNOSBl7A83eABaiiUGEtTHUSi47dle+tpTmqxGSAQL0hbJK6
         Il5XyIA11h63w==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
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
Subject: [PATCH v12 bpf-next 07/12] ARM: rethook: Add rethook arm implementation
Date:   Tue, 15 Mar 2022 23:01:36 +0900
Message-Id: <164735289643.1084943.15184590256680485720.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <164735281449.1084943.12438881786173547153.stgit@devnote2>
References: <164735281449.1084943.12438881786173547153.stgit@devnote2>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add rethook arm implementation. Most of the code has been copied from
kretprobes on arm.
Since the arm's ftrace implementation is a bit special, this needs a
special care using from fprobe.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 Changes in v12:
  - Make arch_rethook_trampoline() as a pure asm function to
    avoid gcc-11 build error.
 Changes in v10:
  - Fix for the mcount entry.
 Changes in v5:
  - Fix build error when !CONFIG_KRETPROBES
---
 arch/arm/Kconfig                  |    1 
 arch/arm/include/asm/stacktrace.h |    4 +
 arch/arm/kernel/stacktrace.c      |    6 ++
 arch/arm/probes/Makefile          |    1 
 arch/arm/probes/rethook.c         |  103 +++++++++++++++++++++++++++++++++++++
 5 files changed, 113 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm/probes/rethook.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 4c97cb40eebb..440f69ee8af5 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -107,6 +107,7 @@ config ARM
 	select HAVE_MOD_ARCH_SPECIFIC
 	select HAVE_NMI
 	select HAVE_OPTPROBES if !THUMB2_KERNEL
+	select HAVE_RETHOOK
 	select HAVE_PERF_EVENTS
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
diff --git a/arch/arm/include/asm/stacktrace.h b/arch/arm/include/asm/stacktrace.h
index 8f54f9ad8a9b..babed1707ca8 100644
--- a/arch/arm/include/asm/stacktrace.h
+++ b/arch/arm/include/asm/stacktrace.h
@@ -14,7 +14,7 @@ struct stackframe {
 	unsigned long sp;
 	unsigned long lr;
 	unsigned long pc;
-#ifdef CONFIG_KRETPROBES
+#if defined(CONFIG_KRETPROBES) || defined(CONFIG_RETHOOK)
 	struct llist_node *kr_cur;
 	struct task_struct *tsk;
 #endif
@@ -27,7 +27,7 @@ void arm_get_current_stackframe(struct pt_regs *regs, struct stackframe *frame)
 		frame->sp = regs->ARM_sp;
 		frame->lr = regs->ARM_lr;
 		frame->pc = regs->ARM_pc;
-#ifdef CONFIG_KRETPROBES
+#if defined(CONFIG_KRETPROBES) || defined(CONFIG_RETHOOK)
 		frame->kr_cur = NULL;
 		frame->tsk = current;
 #endif
diff --git a/arch/arm/kernel/stacktrace.c b/arch/arm/kernel/stacktrace.c
index 75e905508f27..f509c6be4f57 100644
--- a/arch/arm/kernel/stacktrace.c
+++ b/arch/arm/kernel/stacktrace.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include <linux/export.h>
 #include <linux/kprobes.h>
+#include <linux/rethook.h>
 #include <linux/sched.h>
 #include <linux/sched/debug.h>
 #include <linux/stacktrace.h>
@@ -66,6 +67,11 @@ int notrace unwind_frame(struct stackframe *frame)
 	frame->sp = *(unsigned long *)(fp - 8);
 	frame->pc = *(unsigned long *)(fp - 4);
 #endif
+#ifdef CONFIG_RETHOOK
+	if (is_rethook_trampoline(frame->pc))
+		frame->pc = rethook_find_ret_addr(frame->tsk, frame->fp,
+						  &frame->kr_cur);
+#endif
 #ifdef CONFIG_KRETPROBES
 	if (is_kretprobe_trampoline(frame->pc))
 		frame->pc = kretprobe_find_ret_addr(frame->tsk,
diff --git a/arch/arm/probes/Makefile b/arch/arm/probes/Makefile
index 8b0ea5ace100..10c083a22223 100644
--- a/arch/arm/probes/Makefile
+++ b/arch/arm/probes/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_KPROBES)		+= decode-thumb.o
 else
 obj-$(CONFIG_KPROBES)		+= decode-arm.o
 endif
+obj-$(CONFIG_RETHOOK)		+= rethook.o
diff --git a/arch/arm/probes/rethook.c b/arch/arm/probes/rethook.c
new file mode 100644
index 000000000000..1c1357a86365
--- /dev/null
+++ b/arch/arm/probes/rethook.c
@@ -0,0 +1,103 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * arm implementation of rethook. Mostly copied from arch/arm/probes/kprobes/core.c
+ */
+
+#include <linux/kprobes.h>
+#include <linux/rethook.h>
+
+/* Called from arch_rethook_trampoline */
+static __used unsigned long arch_rethook_trampoline_callback(struct pt_regs *regs)
+{
+	return rethook_trampoline_handler(regs, regs->ARM_fp);
+}
+NOKPROBE_SYMBOL(arch_rethook_trampoline_callback);
+
+/*
+ * When a rethook'ed function returns, it returns to arch_rethook_trampoline
+ * which calls rethook callback. We construct a struct pt_regs to
+ * give a view of registers r0-r11, sp, lr, and pc to the user
+ * return-handler. This is not a complete pt_regs structure, but that
+ * should be enough for stacktrace from the return handler with or
+ * without pt_regs.
+ */
+asm(
+	".text\n"
+	".global arch_rethook_trampoline\n"
+	".type arch_rethook_trampoline, %function\n"
+	"arch_rethook_trampoline:\n"
+#ifdef CONFIG_FRAME_POINTER
+	"ldr	lr, =arch_rethook_trampoline	\n\t"
+	/* this makes a framepointer on pt_regs. */
+#ifdef CONFIG_CC_IS_CLANG
+	"stmdb	sp, {sp, lr, pc}	\n\t"
+	"sub	sp, sp, #12		\n\t"
+	/* In clang case, pt_regs->ip = lr. */
+	"stmdb	sp!, {r0 - r11, lr}	\n\t"
+	/* fp points regs->r11 (fp) */
+	"add	fp, sp,	#44		\n\t"
+#else /* !CONFIG_CC_IS_CLANG */
+	/* In gcc case, pt_regs->ip = fp. */
+	"stmdb	sp, {fp, sp, lr, pc}	\n\t"
+	"sub	sp, sp, #16		\n\t"
+	"stmdb	sp!, {r0 - r11}		\n\t"
+	/* fp points regs->r15 (pc) */
+	"add	fp, sp, #60		\n\t"
+#endif /* CONFIG_CC_IS_CLANG */
+#else /* !CONFIG_FRAME_POINTER */
+	"sub	sp, sp, #16		\n\t"
+	"stmdb	sp!, {r0 - r11}		\n\t"
+#endif /* CONFIG_FRAME_POINTER */
+	"mov	r0, sp			\n\t"
+	"bl	arch_rethook_trampoline_callback	\n\t"
+	"mov	lr, r0			\n\t"
+	"ldmia	sp!, {r0 - r11}		\n\t"
+	"add	sp, sp, #16		\n\t"
+#ifdef CONFIG_THUMB2_KERNEL
+	"bx	lr			\n\t"
+#else
+	"mov	pc, lr			\n\t"
+#endif
+	".size arch_rethook_trampoline, .-arch_rethook_trampoline\n"
+);
+NOKPROBE_SYMBOL(arch_rethook_trampoline);
+
+/*
+ * At the entry of function with mcount. The stack and registers are prepared
+ * for the mcount function as below.
+ *
+ * mov     ip, sp
+ * push    {fp, ip, lr, pc}
+ * sub     fp, ip, #4	; FP[0] = PC, FP[-4] = LR, and FP[-12] = call-site FP.
+ * push    {lr}
+ * bl      <__gnu_mcount_nc> ; call ftrace
+ *
+ * And when returning from the function, call-site FP, SP and PC are restored
+ * from stack as below;
+ *
+ * ldm     sp, {fp, sp, pc}
+ *
+ * Thus, if the arch_rethook_prepare() is called from real function entry,
+ * it must change the LR and save FP in pt_regs. But if it is called via
+ * mcount context (ftrace), it must change the LR on stack, which is next
+ * to the PC (= FP[-4]), and save the FP value at FP[-12].
+ */
+void arch_rethook_prepare(struct rethook_node *rh, struct pt_regs *regs, bool mcount)
+{
+	unsigned long *ret_addr, *frame;
+
+	if (mcount) {
+		ret_addr = (unsigned long *)(regs->ARM_fp - 4);
+		frame = (unsigned long *)(regs->ARM_fp - 12);
+	} else {
+		ret_addr = &regs->ARM_lr;
+		frame = &regs->ARM_fp;
+	}
+
+	rh->ret_addr = *ret_addr;
+	rh->frame = *frame;
+
+	/* Replace the return addr with trampoline addr. */
+	*ret_addr = (unsigned long)arch_rethook_trampoline;
+}
+NOKPROBE_SYMBOL(arch_rethook_prepare);

