Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E02BD4D6590
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 17:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350070AbiCKQBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 11:01:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350017AbiCKQBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 11:01:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7166E1CCB02;
        Fri, 11 Mar 2022 08:00:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37279B82C21;
        Fri, 11 Mar 2022 15:59:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274F1C340E9;
        Fri, 11 Mar 2022 15:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647014398;
        bh=u3LXU9B0NsFiJGyUROaEhGHNAJ3nalwJrXEmn9uAx90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ODi7nxsAmmlHrEIzO3DdvPFxSPus9g9SuFxlOdOFc19lmYPlC4NfzNT8/NfAgiaqK
         fbDJUT+FePN1zaS7pYKdPEZuHVSlykEv7B2fXDN9AhVcMLg4Sr9uNztTKl7GcRfq9i
         idD5g0RHkpRZyYa9wirVbuHP87ZVXp/u9i/BuQ/QhqNMjraiGVBW8yD9SIEy2PZY8l
         Fl3frC6QPK48nPKXNvGEY7b9Vdyx5XOOrG2OguTVEaxtbtXlouegKCQ93kDrzLtK8L
         nodsRpjnnNfwC3inIBud0MmifkGhFSA29n68XmXz60ijb9HVK2u1ivEICyNU+7S/Eb
         zfEs2cEZ32pYg==
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
Subject: [PATCH v11 06/12] powerpc: Add rethook support
Date:   Sat, 12 Mar 2022 00:59:51 +0900
Message-Id: <164701439150.268462.11234844552416575497.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <164701432038.268462.3329725152949938527.stgit@devnote2>
References: <164701432038.268462.3329725152949938527.stgit@devnote2>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add rethook powerpc64 implementation. Most of the code has been copied from
kretprobes on powerpc64.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 Changes in v10:
  - Add a dummy @mcount to arch_rethook_prepare().
---
 arch/powerpc/Kconfig          |    1 +
 arch/powerpc/kernel/Makefile  |    1 +
 arch/powerpc/kernel/rethook.c |   72 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 74 insertions(+)
 create mode 100644 arch/powerpc/kernel/rethook.c

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index b779603978e1..5feaa241fb56 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -229,6 +229,7 @@ config PPC
 	select HAVE_PERF_EVENTS_NMI		if PPC64
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
+	select HAVE_RETHOOK			if KPROBES
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_RELIABLE_STACKTRACE
 	select HAVE_RSEQ
diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index 4d7829399570..feb24ea83ca6 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -115,6 +115,7 @@ obj-$(CONFIG_SMP)		+= smp.o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
 obj-$(CONFIG_OPTPROBES)		+= optprobes.o optprobes_head.o
 obj-$(CONFIG_KPROBES_ON_FTRACE)	+= kprobes-ftrace.o
+obj-$(CONFIG_RETHOOK)		+= rethook.o
 obj-$(CONFIG_UPROBES)		+= uprobes.o
 obj-$(CONFIG_PPC_UDBG_16550)	+= legacy_serial.o udbg_16550.o
 obj-$(CONFIG_SWIOTLB)		+= dma-swiotlb.o
diff --git a/arch/powerpc/kernel/rethook.c b/arch/powerpc/kernel/rethook.c
new file mode 100644
index 000000000000..a8a128748efa
--- /dev/null
+++ b/arch/powerpc/kernel/rethook.c
@@ -0,0 +1,72 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * PowerPC implementation of rethook. This depends on kprobes.
+ */
+
+#include <linux/kprobes.h>
+#include <linux/rethook.h>
+
+/*
+ * Function return trampoline:
+ * 	- init_kprobes() establishes a probepoint here
+ * 	- When the probed function returns, this probe
+ * 		causes the handlers to fire
+ */
+asm(".global arch_rethook_trampoline\n"
+	".type arch_rethook_trampoline, @function\n"
+	"arch_rethook_trampoline:\n"
+	"nop\n"
+	"blr\n"
+	".size arch_rethook_trampoline, .-arch_rethook_trampoline\n");
+
+/*
+ * Called when the probe at kretprobe trampoline is hit
+ */
+static int trampoline_rethook_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	unsigned long orig_ret_address;
+
+	orig_ret_address = rethook_trampoline_handler(regs, 0);
+	/*
+	 * We get here through one of two paths:
+	 * 1. by taking a trap -> kprobe_handler() -> here
+	 * 2. by optprobe branch -> optimized_callback() -> opt_pre_handler() -> here
+	 *
+	 * When going back through (1), we need regs->nip to be setup properly
+	 * as it is used to determine the return address from the trap.
+	 * For (2), since nip is not honoured with optprobes, we instead setup
+	 * the link register properly so that the subsequent 'blr' in
+	 * __kretprobe_trampoline jumps back to the right instruction.
+	 *
+	 * For nip, we should set the address to the previous instruction since
+	 * we end up emulating it in kprobe_handler(), which increments the nip
+	 * again.
+	 */
+	regs_set_return_ip(regs, orig_ret_address - 4);
+	regs->link = orig_ret_address;
+
+	return 0;
+}
+NOKPROBE_SYMBOL(trampoline_rethook_handler);
+
+void arch_rethook_prepare(struct rethook_node *rh, struct pt_regs *regs, bool mcount)
+{
+	rh->ret_addr = regs->link;
+	rh->frame = 0;
+
+	/* Replace the return addr with trampoline addr */
+	regs->link = (unsigned long)arch_rethook_trampoline;
+}
+NOKPROBE_SYMBOL(arch_prepare_kretprobe);
+
+static struct kprobe trampoline_p = {
+	.addr = (kprobe_opcode_t *) &arch_rethook_trampoline,
+	.pre_handler = trampoline_rethook_handler
+};
+
+static int init_arch_rethook(void)
+{
+	return register_kprobe(&trampoline_p);
+}
+
+core_initcall(init_arch_rethook);

