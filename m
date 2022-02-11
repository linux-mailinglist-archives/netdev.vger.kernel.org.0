Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4CDF4B24E9
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 12:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349706AbiBKLzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 06:55:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231843AbiBKLzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 06:55:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8912FEAE;
        Fri, 11 Feb 2022 03:55:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9440DB829B9;
        Fri, 11 Feb 2022 11:55:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C763C340F0;
        Fri, 11 Feb 2022 11:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644580519;
        bh=1drqKMTndPFOKgV3ThXlvSijwyBTeHOsMLixmBni0wI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EeMu/DWFugMIG5jn+D/2ou6yfLAFznYlJVs8vnp2YWUMovoepwiea6RXySVZJGS4r
         9LR95hwUKNPWO2JMmPdovsEpdGPRuIbQqPVUw/SEeDD1XBFD8TpWWfC9O2cS3ej7gK
         rZvJUqMfznbyoCL1taPORQYT2Wf8XIg8j+ipHWpqUy3EYdfceNvDAE4gSy0Mn+xBq4
         tVfWetefprJDdpBlkgV/c06PhCQzLiOsF92F1QKJqicTKox9i5QN1EGTPmIUVvo3Vu
         fC5903hklD8qVIF1MVO9xTsK/QvN6QkJXrEbEYvve9VoT2DRD9IOYDxJ7dHwhF48lF
         xfByABdOzj9Gg==
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
Subject: [PATCH v8 06/11] arm64: rethook: Add arm64 rethook implementation
Date:   Fri, 11 Feb 2022 20:55:13 +0900
Message-Id: <164458051371.586276.1359064235721309590.stgit@devnote2>
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

Add rethook arm64 implementation. Most of the code has been copied from
kretprobes on arm64.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 Changes in v5:
  - Add description.
  - Fix build error if !CONFIG_KRETPROBES
---
 arch/arm64/Kconfig                            |    1 
 arch/arm64/include/asm/stacktrace.h           |    2 -
 arch/arm64/kernel/probes/Makefile             |    1 
 arch/arm64/kernel/probes/rethook.c            |   25 +++++++
 arch/arm64/kernel/probes/rethook_trampoline.S |   87 +++++++++++++++++++++++++
 arch/arm64/kernel/stacktrace.c                |    7 ++
 6 files changed, 121 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/kernel/probes/rethook.c
 create mode 100644 arch/arm64/kernel/probes/rethook_trampoline.S

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 6978140edfa4..f098ff3b2273 100644
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
diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index e77cdef9ca29..bf04107da97c 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -58,7 +58,7 @@ struct stackframe {
 	DECLARE_BITMAP(stacks_done, __NR_STACK_TYPES);
 	unsigned long prev_fp;
 	enum stack_type prev_type;
-#ifdef CONFIG_KRETPROBES
+#if defined(CONFIG_KRETPROBES) || defined(CONFIG_RETHOOK)
 	struct llist_node *kr_cur;
 #endif
 };
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
index 0fb58fed54cb..821c4b90fe44 100644
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
@@ -38,7 +39,7 @@ static void start_backtrace(struct stackframe *frame, unsigned long fp,
 {
 	frame->fp = fp;
 	frame->pc = pc;
-#ifdef CONFIG_KRETPROBES
+#if defined(CONFIG_KRETPROBES) || defined(CONFIG_RETHOOK)
 	frame->kr_cur = NULL;
 #endif
 
@@ -137,6 +138,10 @@ static int notrace unwind_frame(struct task_struct *tsk,
 	if (is_kretprobe_trampoline(frame->pc))
 		frame->pc = kretprobe_find_ret_addr(tsk, (void *)frame->fp, &frame->kr_cur);
 #endif
+#ifdef CONFIG_RETHOOK
+	if (is_rethook_trampoline(frame->pc))
+		frame->pc = rethook_find_ret_addr(tsk, frame->fp, &frame->kr_cur);
+#endif
 
 	return 0;
 }

