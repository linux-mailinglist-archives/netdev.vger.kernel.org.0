Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51566498456
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 17:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243303AbiAXQKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 11:10:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243569AbiAXQK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 11:10:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D83FC061748;
        Mon, 24 Jan 2022 08:10:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 659B7B8110D;
        Mon, 24 Jan 2022 16:10:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843EAC340E5;
        Mon, 24 Jan 2022 16:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643040625;
        bh=KLF7MeQzMSwksMcwOWZWT5QYkmgawKjGT2SemmO7Zqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ovmfzWbCz4gXUZJgOgIvNgjrwm0tqKE7uhp6Shh8y1B5U9/H5zIG8zXxbMyXq9ypB
         4CaEaMhN/JfitVd3yVZiGuKzhwaXkqC68VFdaMjagR9LLldA4LpR8UGSv0ovFzoXyr
         /MHek9sxbO4cVCu2Tk0CCa+eYBQOqlgDVLam+D55dKKIrKXJPxBgMefAwAMUMDFpXu
         In1rPeSZz5Mw+k0x4f3Jy6p+qBxCY08qfk0Sz8bNYQZLkQIEVfCL456EM8wGqOBtUF
         gDPm6yJb+mf5/wfbFL647Gf8mKWVvMWykPmK65rwj78r/hs/o0KEO92rFz4D+Ao8Q5
         Xxem5fOd/nPKw==
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
Subject: [PATCH v4 5/9] ARM: rethook: Add rethook arm implementation
Date:   Tue, 25 Jan 2022 01:10:19 +0900
Message-Id: <164304061932.1680787.11603911228891618150.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <164304056155.1680787.14081905648619647218.stgit@devnote2>
References: <164304056155.1680787.14081905648619647218.stgit@devnote2>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 arch/arm/Kconfig             |    1 +
 arch/arm/kernel/stacktrace.c |    4 ++
 arch/arm/probes/Makefile     |    1 +
 arch/arm/probes/rethook.c    |   71 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 77 insertions(+)
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
diff --git a/arch/arm/kernel/stacktrace.c b/arch/arm/kernel/stacktrace.c
index 75e905508f27..3c2a9d7024bc 100644
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
@@ -66,6 +67,9 @@ int notrace unwind_frame(struct stackframe *frame)
 	frame->sp = *(unsigned long *)(fp - 8);
 	frame->pc = *(unsigned long *)(fp - 4);
 #endif
+	if (IS_ENABLED(CONFIG_RETHOOK) && is_rethook_trampoline(frame->pc))
+		frame->pc = rethook_find_ret_addr(frame->tsk, frame->fp,
+						  &frame->kr_cur);
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

