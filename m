Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6348C26B739
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 02:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbgIPATZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 20:19:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726871AbgIOOV6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 10:21:58 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B13D22261;
        Tue, 15 Sep 2020 14:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179435;
        bh=mAvLUOAjRYcfpkRMghrqjRsVA8/IFtwH77ihCDlpknE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yOS1a7++OZZQQUW0Fnjm1zPPlLI5nMWD6R95VrcCLC1WROQDskm08QuULeX30eAG7
         SRPGEvQMfgqv7WvKMoQmyaHGuxVuVLLLk0UjL5O8hYq9shuBeK0416fOYlD+16AHoD
         y3QESZPG2XM/s/Keg3TfX+oCWfbO7iOxygZ5EnAc=
Date:   Tue, 15 Sep 2020 15:17:08 +0100
From:   Will Deacon <will@kernel.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     bpf@vger.kernel.org, ardb@kernel.org, naresh.kamboju@linaro.org,
        Jiri Olsa <jolsa@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Yauheni Kaliuta <yauheni.kaliuta@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] arm64: bpf: Fix branch offset in JIT
Message-ID: <20200915141707.GB26439@willie-the-truck>
References: <20200914160355.19179-1-ilias.apalodimas@linaro.org>
 <20200915131102.GA26439@willie-the-truck>
 <20200915135344.GA113966@apalos.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915135344.GA113966@apalos.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 15, 2020 at 04:53:44PM +0300, Ilias Apalodimas wrote:
> On Tue, Sep 15, 2020 at 02:11:03PM +0100, Will Deacon wrote:
> > Hi Ilias,
> > 
> > On Mon, Sep 14, 2020 at 07:03:55PM +0300, Ilias Apalodimas wrote:
> > > Running the eBPF test_verifier leads to random errors looking like this:
> > > 
> > > [ 6525.735488] Unexpected kernel BRK exception at EL1
> > > [ 6525.735502] Internal error: ptrace BRK handler: f2000100 [#1] SMP
> > 
> > Does this happen because we poison the BPF memory with BRK instructions?
> > Maybe we should look at using a special immediate so we can detect this,
> > rather than end up in the ptrace handler.
> 
> As discussed offline this is what aarch64_insn_gen_branch_imm() will return for
> offsets > 128M and yes replacing the handler with a more suitable message would 
> be good.

Can you give the diff below a shot, please? Hopefully printing a more useful
message will mean these things get triaged/debugged better in future.

Will

--->8

diff --git a/arch/arm64/include/asm/extable.h b/arch/arm64/include/asm/extable.h
index 840a35ed92ec..b15eb4a3e6b2 100644
--- a/arch/arm64/include/asm/extable.h
+++ b/arch/arm64/include/asm/extable.h
@@ -22,6 +22,15 @@ struct exception_table_entry
 
 #define ARCH_HAS_RELATIVE_EXTABLE
 
+static inline bool in_bpf_jit(struct pt_regs *regs)
+{
+	if (!IS_ENABLED(CONFIG_BPF_JIT))
+		return false;
+
+	return regs->pc >= BPF_JIT_REGION_START &&
+	       regs->pc < BPF_JIT_REGION_END;
+}
+
 #ifdef CONFIG_BPF_JIT
 int arm64_bpf_fixup_exception(const struct exception_table_entry *ex,
 			      struct pt_regs *regs);
diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-monitors.c
index 7310a4f7f993..fa76151de6ff 100644
--- a/arch/arm64/kernel/debug-monitors.c
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -384,7 +384,7 @@ void __init debug_traps_init(void)
 	hook_debug_fault_code(DBG_ESR_EVT_HWSS, single_step_handler, SIGTRAP,
 			      TRAP_TRACE, "single-step handler");
 	hook_debug_fault_code(DBG_ESR_EVT_BRK, brk_handler, SIGTRAP,
-			      TRAP_BRKPT, "ptrace BRK handler");
+			      TRAP_BRKPT, "BRK handler");
 }
 
 /* Re-enable single step for syscall restarting. */
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 13ebd5ca2070..9f7fde99eda2 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -34,6 +34,7 @@
 #include <asm/daifflags.h>
 #include <asm/debug-monitors.h>
 #include <asm/esr.h>
+#include <asm/extable.h>
 #include <asm/insn.h>
 #include <asm/kprobes.h>
 #include <asm/traps.h>
@@ -994,6 +995,21 @@ static struct break_hook bug_break_hook = {
 	.imm = BUG_BRK_IMM,
 };
 
+static int reserved_fault_handler(struct pt_regs *regs, unsigned int esr)
+{
+	pr_err("%s generated an invalid instruction at %pS!\n",
+		in_bpf_jit(regs) ? "BPF JIT" : "Kernel runtime patching",
+		instruction_pointer(regs));
+
+	/* We cannot handle this */
+	return DBG_HOOK_ERROR;
+}
+
+static struct break_hook fault_break_hook = {
+	.fn = reserved_fault_handler,
+	.imm = FAULT_BRK_IMM,
+};
+
 #ifdef CONFIG_KASAN_SW_TAGS
 
 #define KASAN_ESR_RECOVER	0x20
@@ -1059,6 +1075,7 @@ int __init early_brk64(unsigned long addr, unsigned int esr,
 void __init trap_init(void)
 {
 	register_kernel_break_hook(&bug_break_hook);
+	register_kernel_break_hook(&fault_break_hook);
 #ifdef CONFIG_KASAN_SW_TAGS
 	register_kernel_break_hook(&kasan_break_hook);
 #endif
diff --git a/arch/arm64/mm/extable.c b/arch/arm64/mm/extable.c
index eee1732ab6cd..aa0060178343 100644
--- a/arch/arm64/mm/extable.c
+++ b/arch/arm64/mm/extable.c
@@ -14,9 +14,7 @@ int fixup_exception(struct pt_regs *regs)
 	if (!fixup)
 		return 0;
 
-	if (IS_ENABLED(CONFIG_BPF_JIT) &&
-	    regs->pc >= BPF_JIT_REGION_START &&
-	    regs->pc < BPF_JIT_REGION_END)
+	if (in_bpf_jit(regs))
 		return arm64_bpf_fixup_exception(fixup, regs);
 
 	regs->pc = (unsigned long)&fixup->fixup + fixup->fixup;
