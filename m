Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B795E49FBBE
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 15:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349285AbiA1OdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 09:33:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50106 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349242AbiA1OdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 09:33:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6105EB825E8;
        Fri, 28 Jan 2022 14:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90865C340E0;
        Fri, 28 Jan 2022 14:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643380379;
        bh=/l2AYnhwkGK1vuSSo7mgSDc0f2wUI76MI5naeFuvPJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XU0UL1TQ4cf+7VG6oppMhMOnRT7QodhTVa2Qm9zSBYaUMvPlwa2EV45HAsGn44YG2
         g0aGOX/+kH6shchAVwnzgM2oSXKd7CDYwIhCgs1t8TBBl13fE68YYySnduuJYTpXOZ
         cJShV521Oa8iNY4ZLu6UM4ZewJ3uKn9t8wapfRzM60Tg615/iJx0foaXzqFE3K0BLt
         KvuXza1xswJxkdvqLhy9Bd36cwUewZtSt14CxPlKW6inpyn8eebi9YSO59YKesXRSr
         LD/3UkJpAYVpV9kS0LmLip9dtwtCQSYK86edchGQuSPYERCkp6E77AzrMk3dclIUj+
         cJn3ZvbF7r7Jg==
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
Subject: [PATCH v6 05/10] ARM: rethook: Add rethook arm implementation
Date:   Fri, 28 Jan 2022 23:32:53 +0900
Message-Id: <164338037327.2429999.13110792485526743529.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <164338031590.2429999.6203979005944292576.stgit@devnote2>
References: <164338031590.2429999.6203979005944292576.stgit@devnote2>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add rethook arm implementation. Most of the code has been copied from
kretprobes on arm.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 Changes in v5:
  - Fix build error when !CONFIG_KRETPROBES
---
 arch/arm/Kconfig                  |    1 +
 arch/arm/include/asm/stacktrace.h |    4 +-
 arch/arm/kernel/stacktrace.c      |    6 +++
 arch/arm/probes/Makefile          |    1 +
 arch/arm/probes/rethook.c         |   71 +++++++++++++++++++++++++++++++++++++
 5 files changed, 81 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm/probes/rethook.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index c2724d986fa0..2fe24bbca618 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -106,6 +106,7 @@ config ARM
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
index 000000000000..adc16cdf358a
--- /dev/null
+++ b/arch/arm/probes/rethook.c
@@ -0,0 +1,71 @@
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
+void __naked arch_rethook_trampoline(void)
+{
+	__asm__ __volatile__ (
+#ifdef CONFIG_FRAME_POINTER
+		"ldr	lr, =arch_rethook_trampoline	\n\t"
+	/* this makes a framepointer on pt_regs. */
+#ifdef CONFIG_CC_IS_CLANG
+		"stmdb	sp, {sp, lr, pc}	\n\t"
+		"sub	sp, sp, #12		\n\t"
+		/* In clang case, pt_regs->ip = lr. */
+		"stmdb	sp!, {r0 - r11, lr}	\n\t"
+		/* fp points regs->r11 (fp) */
+		"add	fp, sp,	#44		\n\t"
+#else /* !CONFIG_CC_IS_CLANG */
+		/* In gcc case, pt_regs->ip = fp. */
+		"stmdb	sp, {fp, sp, lr, pc}	\n\t"
+		"sub	sp, sp, #16		\n\t"
+		"stmdb	sp!, {r0 - r11}		\n\t"
+		/* fp points regs->r15 (pc) */
+		"add	fp, sp, #60		\n\t"
+#endif /* CONFIG_CC_IS_CLANG */
+#else /* !CONFIG_FRAME_POINTER */
+		"sub	sp, sp, #16		\n\t"
+		"stmdb	sp!, {r0 - r11}		\n\t"
+#endif /* CONFIG_FRAME_POINTER */
+		"mov	r0, sp			\n\t"
+		"bl	arch_rethook_trampoline_callback	\n\t"
+		"mov	lr, r0			\n\t"
+		"ldmia	sp!, {r0 - r11}		\n\t"
+		"add	sp, sp, #16		\n\t"
+#ifdef CONFIG_THUMB2_KERNEL
+		"bx	lr			\n\t"
+#else
+		"mov	pc, lr			\n\t"
+#endif
+		: : : "memory");
+}
+NOKPROBE_SYMBOL(arch_rethook_trampoline);
+
+void arch_rethook_prepare(struct rethook_node *rh, struct pt_regs *regs)
+{
+	rh->ret_addr = regs->ARM_lr;
+	rh->frame = regs->ARM_fp;
+
+	/* Replace the return addr with trampoline addr. */
+	regs->ARM_lr = (unsigned long)arch_rethook_trampoline;
+}
+NOKPROBE_SYMBOL(arch_rethook_prepare);

