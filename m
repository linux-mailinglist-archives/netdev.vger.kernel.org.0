Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 588A549845C
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 17:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235896AbiAXQKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 11:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243594AbiAXQKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 11:10:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52314C06173D;
        Mon, 24 Jan 2022 08:10:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C7D3B81107;
        Mon, 24 Jan 2022 16:10:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0847BC36AEB;
        Mon, 24 Jan 2022 16:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643040636;
        bh=WZmeFdH8ElYIGUJVoLmuFMDYeopFMvSyUPu3X++ZsIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OdVEy3jO32j3+qxeW2ohGlGynWhZNJw8nbkdBIm4gHboebPtUDEozG3iSJraa6J0x
         V2OWh7puK2axheDEll1hqQcKnclrNzThDv80RLYLV+GbL//OLZc6ow91+2aA6S2UDb
         FkpXN8vl5DfAxT1TMjD0agCklb0kq2ZeO0W13P9J2yCX7zIY10YJwf+oj4jNNtLITI
         QmwivXuNcpjSBXlR0NK4891FQcGwlpZQb3rzK5JATHfRoDgmZp+Y5byPDHy1eKe4LC
         cKQ6twrZ5tKcCp9BZNe/e7XxBbaJSffoMq82mvGBI2L5E5islo0c8fyx2jQNLRpWu2
         rR5UAKFPZk0GQ==
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
Subject: [PATCH v4 6/9] arm64: rethook: Add arm64 rethook implementation
Date:   Tue, 25 Jan 2022 01:10:30 +0900
Message-Id: <164304063053.1680787.17728029474747738793.stgit@devnote2>
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
 arch/arm64/Kconfig                            |    1 
 arch/arm64/kernel/probes/Makefile             |    1 
 arch/arm64/kernel/probes/rethook.c            |   25 +++++++
 arch/arm64/kernel/probes/rethook_trampoline.S |   87 +++++++++++++++++++++++++
 arch/arm64/kernel/stacktrace.c                |    3 +
 5 files changed, 117 insertions(+)
 create mode 100644 arch/arm64/kernel/probes/rethook.c
 create mode 100644 arch/arm64/kernel/probes/rethook_trampoline.S

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index c4207cf9bb17..c706ed25ea50 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -201,6 +201,7 @@ config ARM64
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
+	select HAVE_RETHOOK
 	select HAVE_GENERIC_VDSO
 	select IOMMU_DMA if IOMMU_SUPPORT
 	select IRQ_DOMAIN
diff --git a/arch/arm64/kernel/probes/Makefile b/arch/arm64/kernel/probes/Makefile
index 8e4be92e25b1..24e689f44c32 100644
--- a/arch/arm64/kernel/probes/Makefile
+++ b/arch/arm64/kernel/probes/Makefile
@@ -4,3 +4,4 @@ obj-$(CONFIG_KPROBES)		+= kprobes.o decode-insn.o	\
 				   simulate-insn.o
 obj-$(CONFIG_UPROBES)		+= uprobes.o decode-insn.o	\
 				   simulate-insn.o
+obj-$(CONFIG_RETHOOK)		+= rethook.o rethook_trampoline.o
diff --git a/arch/arm64/kernel/probes/rethook.c b/arch/arm64/kernel/probes/rethook.c
new file mode 100644
index 000000000000..38c33c81438b
--- /dev/null
+++ b/arch/arm64/kernel/probes/rethook.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Generic return hook for arm64.
+ * Most of the code is copied from arch/arm64/kernel/probes/kprobes.c
+ */
+
+#include <linux/kprobes.h>
+#include <linux/rethook.h>
+
+/* This is called from arch_rethook_trampoline() */
+unsigned long __used arch_rethook_trampoline_callback(struct pt_regs *regs)
+{
+	return rethook_trampoline_handler(regs, regs->regs[29]);
+}
+NOKPROBE_SYMBOL(arch_rethook_trampoline_callback);
+
+void arch_rethook_prepare(struct rethook_node *rhn, struct pt_regs *regs)
+{
+	rhn->ret_addr = regs->regs[30];
+	rhn->frame = regs->regs[29];
+
+	/* replace return addr (x30) with trampoline */
+	regs->regs[30] = (u64)arch_rethook_trampoline;
+}
+NOKPROBE_SYMBOL(arch_rethook_prepare);
diff --git a/arch/arm64/kernel/probes/rethook_trampoline.S b/arch/arm64/kernel/probes/rethook_trampoline.S
new file mode 100644
index 000000000000..610f520ee72b
--- /dev/null
+++ b/arch/arm64/kernel/probes/rethook_trampoline.S
@@ -0,0 +1,87 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * trampoline entry and return code for rethook.
+ * Copied from arch/arm64/kernel/probes/kprobes_trampoline.S
+ */
+
+#include <linux/linkage.h>
+#include <asm/asm-offsets.h>
+#include <asm/assembler.h>
+
+	.text
+
+	.macro	save_all_base_regs
+	stp x0, x1, [sp, #S_X0]
+	stp x2, x3, [sp, #S_X2]
+	stp x4, x5, [sp, #S_X4]
+	stp x6, x7, [sp, #S_X6]
+	stp x8, x9, [sp, #S_X8]
+	stp x10, x11, [sp, #S_X10]
+	stp x12, x13, [sp, #S_X12]
+	stp x14, x15, [sp, #S_X14]
+	stp x16, x17, [sp, #S_X16]
+	stp x18, x19, [sp, #S_X18]
+	stp x20, x21, [sp, #S_X20]
+	stp x22, x23, [sp, #S_X22]
+	stp x24, x25, [sp, #S_X24]
+	stp x26, x27, [sp, #S_X26]
+	stp x28, x29, [sp, #S_X28]
+	add x0, sp, #PT_REGS_SIZE
+	stp lr, x0, [sp, #S_LR]
+	/*
+	 * Construct a useful saved PSTATE
+	 */
+	mrs x0, nzcv
+	mrs x1, daif
+	orr x0, x0, x1
+	mrs x1, CurrentEL
+	orr x0, x0, x1
+	mrs x1, SPSel
+	orr x0, x0, x1
+	stp xzr, x0, [sp, #S_PC]
+	.endm
+
+	.macro	restore_all_base_regs
+	ldr x0, [sp, #S_PSTATE]
+	and x0, x0, #(PSR_N_BIT | PSR_Z_BIT | PSR_C_BIT | PSR_V_BIT)
+	msr nzcv, x0
+	ldp x0, x1, [sp, #S_X0]
+	ldp x2, x3, [sp, #S_X2]
+	ldp x4, x5, [sp, #S_X4]
+	ldp x6, x7, [sp, #S_X6]
+	ldp x8, x9, [sp, #S_X8]
+	ldp x10, x11, [sp, #S_X10]
+	ldp x12, x13, [sp, #S_X12]
+	ldp x14, x15, [sp, #S_X14]
+	ldp x16, x17, [sp, #S_X16]
+	ldp x18, x19, [sp, #S_X18]
+	ldp x20, x21, [sp, #S_X20]
+	ldp x22, x23, [sp, #S_X22]
+	ldp x24, x25, [sp, #S_X24]
+	ldp x26, x27, [sp, #S_X26]
+	ldp x28, x29, [sp, #S_X28]
+	.endm
+
+SYM_CODE_START(arch_rethook_trampoline)
+	sub sp, sp, #PT_REGS_SIZE
+
+	save_all_base_regs
+
+	/* Setup a frame pointer. */
+	add x29, sp, #S_FP
+
+	mov x0, sp
+	bl arch_rethook_trampoline_callback
+	/*
+	 * Replace trampoline address in lr with actual orig_ret_addr return
+	 * address.
+	 */
+	mov lr, x0
+
+	/* The frame pointer (x29) is restored with other registers. */
+	restore_all_base_regs
+
+	add sp, sp, #PT_REGS_SIZE
+	ret
+
+SYM_CODE_END(arch_rethook_trampoline)
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index b0f21677764d..d0883d0fa61c 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -8,6 +8,7 @@
 #include <linux/export.h>
 #include <linux/ftrace.h>
 #include <linux/kprobes.h>
+#include <linux/rethook.h>
 #include <linux/sched.h>
 #include <linux/sched/debug.h>
 #include <linux/sched/task_stack.h>
@@ -137,6 +138,8 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
 	if (is_kretprobe_trampoline(frame->pc))
 		frame->pc = kretprobe_find_ret_addr(tsk, (void *)frame->fp, &frame->kr_cur);
 #endif
+	if (IS_ENABLED(CONFIG_RETHOOK) && is_rethook_trampoline(frame->pc))
+		frame->pc = rethook_find_ret_addr(tsk, frame->fp, &frame->kr_cur);
 
 	return 0;
 }

