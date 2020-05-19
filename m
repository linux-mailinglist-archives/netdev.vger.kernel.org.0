Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860541D985D
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 15:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbgESNpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 09:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729233AbgESNps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 09:45:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C805C08C5C1;
        Tue, 19 May 2020 06:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=du91TDsLWOvanOu/rlqxNAo9slwd55aClf6aY/omdWc=; b=IYo+XsvkkQj8k7U9jnkp6ltSkw
        WsPg3gdiW8KNCp+9Fv06yMLkr8YyWIac6PIw1hGN1RNEwCz440aes7SJZhMF0A9CUaLYGeNFqtznz
        Rv7mKQ0KP4IKlvpEsVF78Y6H+grIXYlJVZa+jeTByUlaDfkd03nWCKfYuRNdOAsspYqxGBYGIPxAh
        plIgkIhb0H7/1V9WUd5XFSbejRpuKWO49GmW/2G5OyR5LeGAnqP5QeKoDorXylgkimZqhQ8vItEbx
        +MHDG+i2iaMgSGYQrbVDUN+17fI5H6FelbmCrIdjUkfzW3z67WpAFLXMPwMWAlBKbWeMMkZM+3QgD
        E2zjBsgw==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jb2Z0-0003s7-5v; Tue, 19 May 2020 13:45:47 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 17/20] maccess: rename probe_kernel_{read,write} to copy_{from,to}_kernel_nofault
Date:   Tue, 19 May 2020 15:44:46 +0200
Message-Id: <20200519134449.1466624-18-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200519134449.1466624-1-hch@lst.de>
References: <20200519134449.1466624-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Better describe what these functions do.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/arm/kernel/ftrace.c           |  3 +-
 arch/arm/kernel/kgdb.c             |  2 +-
 arch/arm64/kernel/insn.c           |  4 +--
 arch/csky/kernel/ftrace.c          |  5 ++--
 arch/ia64/kernel/ftrace.c          |  6 ++--
 arch/mips/kernel/kprobes.c         |  6 ++--
 arch/nds32/kernel/ftrace.c         |  5 ++--
 arch/parisc/kernel/ftrace.c        |  2 +-
 arch/parisc/kernel/kgdb.c          |  4 +--
 arch/parisc/lib/memcpy.c           |  3 +-
 arch/powerpc/kernel/module_64.c    |  5 ++--
 arch/powerpc/kernel/trace/ftrace.c | 24 +++++++--------
 arch/powerpc/perf/core-book3s.c    |  3 +-
 arch/riscv/kernel/ftrace.c         |  3 +-
 arch/riscv/kernel/patch.c          |  4 +--
 arch/s390/kernel/ftrace.c          |  4 +--
 arch/sh/kernel/ftrace.c            |  6 ++--
 arch/um/kernel/maccess.c           |  2 +-
 arch/x86/include/asm/ptrace.h      |  4 +--
 arch/x86/kernel/dumpstack.c        |  2 +-
 arch/x86/kernel/ftrace.c           |  8 ++---
 arch/x86/kernel/kgdb.c             |  6 ++--
 arch/x86/kernel/kprobes/core.c     |  5 ++--
 arch/x86/kernel/kprobes/opt.c      |  2 +-
 arch/x86/kernel/traps.c            |  3 +-
 arch/x86/mm/fault.c                |  2 +-
 arch/x86/mm/init_32.c              |  2 +-
 arch/x86/mm/maccess.c              |  3 +-
 arch/x86/xen/enlighten_pv.c        |  2 +-
 drivers/char/mem.c                 |  2 +-
 drivers/dio/dio.c                  |  6 ++--
 drivers/input/serio/hp_sdc.c       |  2 +-
 drivers/misc/kgdbts.c              |  6 ++--
 drivers/video/fbdev/hpfb.c         |  2 +-
 fs/proc/kcore.c                    |  3 +-
 include/linux/uaccess.h            | 14 +++++----
 kernel/debug/debug_core.c          |  6 ++--
 kernel/debug/gdbstub.c             |  6 ++--
 kernel/debug/kdb/kdb_main.c        |  3 +-
 kernel/debug/kdb/kdb_support.c     |  7 +++--
 kernel/kthread.c                   |  2 +-
 kernel/trace/bpf_trace.c           |  2 +-
 kernel/trace/trace_kprobe.c        |  4 +--
 kernel/workqueue.c                 | 10 +++----
 mm/maccess.c                       | 48 +++++++++++++++---------------
 mm/rodata_test.c                   |  2 +-
 mm/slub.c                          |  2 +-
 47 files changed, 137 insertions(+), 120 deletions(-)

diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
index 10499d44964a2..9a79ef6b1876c 100644
--- a/arch/arm/kernel/ftrace.c
+++ b/arch/arm/kernel/ftrace.c
@@ -84,7 +84,8 @@ static int ftrace_modify_code(unsigned long pc, unsigned long old,
 		old = __opcode_to_mem_arm(old);
 
 	if (validate) {
-		if (probe_kernel_read(&replaced, (void *)pc, MCOUNT_INSN_SIZE))
+		if (copy_from_kernel_nofault(&replaced, (void *)pc,
+				MCOUNT_INSN_SIZE))
 			return -EFAULT;
 
 		if (replaced != old)
diff --git a/arch/arm/kernel/kgdb.c b/arch/arm/kernel/kgdb.c
index 6a95b92966406..7bd30c0a4280d 100644
--- a/arch/arm/kernel/kgdb.c
+++ b/arch/arm/kernel/kgdb.c
@@ -236,7 +236,7 @@ int kgdb_arch_set_breakpoint(struct kgdb_bkpt *bpt)
 	/* patch_text() only supports int-sized breakpoints */
 	BUILD_BUG_ON(sizeof(int) != BREAK_INSTR_SIZE);
 
-	err = probe_kernel_read(bpt->saved_instr, (char *)bpt->bpt_addr,
+	err = copy_from_kernel_nofault(bpt->saved_instr, (char *)bpt->bpt_addr,
 				BREAK_INSTR_SIZE);
 	if (err)
 		return err;
diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
index 4a9e773a177f0..c5f7a7b8d2c3e 100644
--- a/arch/arm64/kernel/insn.c
+++ b/arch/arm64/kernel/insn.c
@@ -123,7 +123,7 @@ int __kprobes aarch64_insn_read(void *addr, u32 *insnp)
 	int ret;
 	__le32 val;
 
-	ret = probe_kernel_read(&val, addr, AARCH64_INSN_SIZE);
+	ret = copy_from_kernel_nofault(&val, addr, AARCH64_INSN_SIZE);
 	if (!ret)
 		*insnp = le32_to_cpu(val);
 
@@ -139,7 +139,7 @@ static int __kprobes __aarch64_insn_write(void *addr, __le32 insn)
 	raw_spin_lock_irqsave(&patch_lock, flags);
 	waddr = patch_map(addr, FIX_TEXT_POKE0);
 
-	ret = probe_kernel_write(waddr, &insn, AARCH64_INSN_SIZE);
+	ret = copy_to_kernel_nofault(waddr, &insn, AARCH64_INSN_SIZE);
 
 	patch_unmap(FIX_TEXT_POKE0);
 	raw_spin_unlock_irqrestore(&patch_lock, flags);
diff --git a/arch/csky/kernel/ftrace.c b/arch/csky/kernel/ftrace.c
index 3c425b84e3be6..b4a7ec1517ff7 100644
--- a/arch/csky/kernel/ftrace.c
+++ b/arch/csky/kernel/ftrace.c
@@ -72,7 +72,8 @@ static int ftrace_check_current_nop(unsigned long hook)
 	uint16_t olds[7];
 	unsigned long hook_pos = hook - 2;
 
-	if (probe_kernel_read((void *)olds, (void *)hook_pos, sizeof(nops)))
+	if (copy_from_kernel_nofault((void *)olds, (void *)hook_pos,
+			sizeof(nops)))
 		return -EFAULT;
 
 	if (memcmp((void *)nops, (void *)olds, sizeof(nops))) {
@@ -97,7 +98,7 @@ static int ftrace_modify_code(unsigned long hook, unsigned long target,
 
 	make_jbsr(target, hook, call, nolr);
 
-	ret = probe_kernel_write((void *)hook_pos, enable ? call : nops,
+	ret = copy_to_kernel_nofault((void *)hook_pos, enable ? call : nops,
 				 sizeof(nops));
 	if (ret)
 		return -EPERM;
diff --git a/arch/ia64/kernel/ftrace.c b/arch/ia64/kernel/ftrace.c
index cee411e647ca0..b2ab2d58fb30c 100644
--- a/arch/ia64/kernel/ftrace.c
+++ b/arch/ia64/kernel/ftrace.c
@@ -108,7 +108,7 @@ ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 		goto skip_check;
 
 	/* read the text we want to modify */
-	if (probe_kernel_read(replaced, (void *)ip, MCOUNT_INSN_SIZE))
+	if (copy_from_kernel_nofault(replaced, (void *)ip, MCOUNT_INSN_SIZE))
 		return -EFAULT;
 
 	/* Make sure it is what we expect it to be */
@@ -117,7 +117,7 @@ ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 
 skip_check:
 	/* replace the text with the new text */
-	if (probe_kernel_write(((void *)ip), new_code, MCOUNT_INSN_SIZE))
+	if (copy_to_kernel_nofault(((void *)ip), new_code, MCOUNT_INSN_SIZE))
 		return -EPERM;
 	flush_icache_range(ip, ip + MCOUNT_INSN_SIZE);
 
@@ -129,7 +129,7 @@ static int ftrace_make_nop_check(struct dyn_ftrace *rec, unsigned long addr)
 	unsigned char __attribute__((aligned(8))) replaced[MCOUNT_INSN_SIZE];
 	unsigned long ip = rec->ip;
 
-	if (probe_kernel_read(replaced, (void *)ip, MCOUNT_INSN_SIZE))
+	if (copy_from_kernel_nofault(replaced, (void *)ip, MCOUNT_INSN_SIZE))
 		return -EFAULT;
 	if (rec->flags & FTRACE_FL_CONVERTED) {
 		struct ftrace_call_insn *call_insn, *tmp_call;
diff --git a/arch/mips/kernel/kprobes.c b/arch/mips/kernel/kprobes.c
index 6cfae2411c044..d043c2f897fc2 100644
--- a/arch/mips/kernel/kprobes.c
+++ b/arch/mips/kernel/kprobes.c
@@ -86,9 +86,9 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 		goto out;
 	}
 
-	if ((probe_kernel_read(&prev_insn, p->addr - 1,
-				sizeof(mips_instruction)) == 0) &&
-				insn_has_delayslot(prev_insn)) {
+	if (copy_from_kernel_nofault(&prev_insn, p->addr - 1,
+			sizeof(mips_instruction)) == 0 &&
+	    insn_has_delayslot(prev_insn)) {
 		pr_notice("Kprobes for branch delayslot are not supported\n");
 		ret = -EINVAL;
 		goto out;
diff --git a/arch/nds32/kernel/ftrace.c b/arch/nds32/kernel/ftrace.c
index 22ab77ea27ad3..3763b3f8c3db5 100644
--- a/arch/nds32/kernel/ftrace.c
+++ b/arch/nds32/kernel/ftrace.c
@@ -131,13 +131,14 @@ static int __ftrace_modify_code(unsigned long pc, unsigned long *old_insn,
 	unsigned long orig_insn[3];
 
 	if (validate) {
-		if (probe_kernel_read(orig_insn, (void *)pc, MCOUNT_INSN_SIZE))
+		if (copy_from_kernel_nofault(orig_insn, (void *)pc,
+				MCOUNT_INSN_SIZE))
 			return -EFAULT;
 		if (memcmp(orig_insn, old_insn, MCOUNT_INSN_SIZE))
 			return -EINVAL;
 	}
 
-	if (probe_kernel_write((void *)pc, new_insn, MCOUNT_INSN_SIZE))
+	if (copy_to_kernel_nofault((void *)pc, new_insn, MCOUNT_INSN_SIZE))
 		return -EPERM;
 
 	return 0;
diff --git a/arch/parisc/kernel/ftrace.c b/arch/parisc/kernel/ftrace.c
index b836fc61a24f4..1df0f67ed6671 100644
--- a/arch/parisc/kernel/ftrace.c
+++ b/arch/parisc/kernel/ftrace.c
@@ -172,7 +172,7 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 
 	ip = (void *)(rec->ip + 4 - size);
 
-	ret = probe_kernel_read(insn, ip, size);
+	ret = copy_from_kernel_nofault(insn, ip, size);
 	if (ret)
 		return ret;
 
diff --git a/arch/parisc/kernel/kgdb.c b/arch/parisc/kernel/kgdb.c
index 664278db9b977..c4554ac13eac7 100644
--- a/arch/parisc/kernel/kgdb.c
+++ b/arch/parisc/kernel/kgdb.c
@@ -154,8 +154,8 @@ void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long ip)
 
 int kgdb_arch_set_breakpoint(struct kgdb_bkpt *bpt)
 {
-	int ret = probe_kernel_read(bpt->saved_instr, (char *)bpt->bpt_addr,
-				BREAK_INSTR_SIZE);
+	int ret = copy_from_kernel_nofault(bpt->saved_instr,
+			(char *)bpt->bpt_addr, BREAK_INSTR_SIZE);
 	if (ret)
 		return ret;
 
diff --git a/arch/parisc/lib/memcpy.c b/arch/parisc/lib/memcpy.c
index 9fe662b3b5604..f51811d613d72 100644
--- a/arch/parisc/lib/memcpy.c
+++ b/arch/parisc/lib/memcpy.c
@@ -57,7 +57,8 @@ void * memcpy(void * dst,const void *src, size_t count)
 EXPORT_SYMBOL(raw_copy_in_user);
 EXPORT_SYMBOL(memcpy);
 
-bool probe_kernel_read_allowed(void *dst, const void *unsafe_src, size_t size)
+bool copy_from_kernel_nofault_allowed(void *dst, const void *unsafe_src,
+		size_t size)
 {
 	if ((unsigned long)unsafe_src < PAGE_SIZE)
 		return false;
diff --git a/arch/powerpc/kernel/module_64.c b/arch/powerpc/kernel/module_64.c
index 007606a48fd98..29067ef485411 100644
--- a/arch/powerpc/kernel/module_64.c
+++ b/arch/powerpc/kernel/module_64.c
@@ -159,7 +159,7 @@ int module_trampoline_target(struct module *mod, unsigned long addr,
 
 	stub = (struct ppc64_stub_entry *)addr;
 
-	if (probe_kernel_read(&magic, &stub->magic, sizeof(magic))) {
+	if (copy_from_kernel_nofault(&magic, &stub->magic, sizeof(magic))) {
 		pr_err("%s: fault reading magic for stub %lx for %s\n", __func__, addr, mod->name);
 		return -EFAULT;
 	}
@@ -169,7 +169,8 @@ int module_trampoline_target(struct module *mod, unsigned long addr,
 		return -EFAULT;
 	}
 
-	if (probe_kernel_read(&funcdata, &stub->funcdata, sizeof(funcdata))) {
+	if (copy_from_kernel_nofault(&funcdata, &stub->funcdata,
+			sizeof(funcdata))) {
 		pr_err("%s: fault reading funcdata for stub %lx for %s\n", __func__, addr, mod->name);
                 return -EFAULT;
 	}
diff --git a/arch/powerpc/kernel/trace/ftrace.c b/arch/powerpc/kernel/trace/ftrace.c
index 7ea0ca044b650..60ee6813830c3 100644
--- a/arch/powerpc/kernel/trace/ftrace.c
+++ b/arch/powerpc/kernel/trace/ftrace.c
@@ -67,7 +67,7 @@ ftrace_modify_code(unsigned long ip, unsigned int old, unsigned int new)
 	 */
 
 	/* read the text we want to modify */
-	if (probe_kernel_read(&replaced, (void *)ip, MCOUNT_INSN_SIZE))
+	if (copy_from_kernel_nofault(&replaced, (void *)ip, MCOUNT_INSN_SIZE))
 		return -EFAULT;
 
 	/* Make sure it is what we expect it to be */
@@ -128,7 +128,7 @@ __ftrace_make_nop(struct module *mod,
 	unsigned int op, pop;
 
 	/* read where this goes */
-	if (probe_kernel_read(&op, (void *)ip, sizeof(int))) {
+	if (copy_from_kernel_nofault(&op, (void *)ip, sizeof(int))) {
 		pr_err("Fetching opcode failed.\n");
 		return -EFAULT;
 	}
@@ -162,7 +162,7 @@ __ftrace_make_nop(struct module *mod,
 	/* When using -mkernel_profile there is no load to jump over */
 	pop = PPC_INST_NOP;
 
-	if (probe_kernel_read(&op, (void *)(ip - 4), 4)) {
+	if (copy_from_kernel_nofault(&op, (void *)(ip - 4), 4)) {
 		pr_err("Fetching instruction at %lx failed.\n", ip - 4);
 		return -EFAULT;
 	}
@@ -193,7 +193,7 @@ __ftrace_make_nop(struct module *mod,
 	 * Check what is in the next instruction. We can see ld r2,40(r1), but
 	 * on first pass after boot we will see mflr r0.
 	 */
-	if (probe_kernel_read(&op, (void *)(ip+4), MCOUNT_INSN_SIZE)) {
+	if (copy_from_kernel_nofault(&op, (void *)(ip+4), MCOUNT_INSN_SIZE)) {
 		pr_err("Fetching op failed.\n");
 		return -EFAULT;
 	}
@@ -222,7 +222,7 @@ __ftrace_make_nop(struct module *mod,
 	unsigned long ip = rec->ip;
 	unsigned long tramp;
 
-	if (probe_kernel_read(&op, (void *)ip, MCOUNT_INSN_SIZE))
+	if (copy_from_kernel_nofault(&op, (void *)ip, MCOUNT_INSN_SIZE))
 		return -EFAULT;
 
 	/* Make sure that that this is still a 24bit jump */
@@ -245,7 +245,7 @@ __ftrace_make_nop(struct module *mod,
 	pr_devel("ip:%lx jumps to %lx", ip, tramp);
 
 	/* Find where the trampoline jumps to */
-	if (probe_kernel_read(jmp, (void *)tramp, sizeof(jmp))) {
+	if (copy_from_kernel_nofault(jmp, (void *)tramp, sizeof(jmp))) {
 		pr_err("Failed to read %lx\n", tramp);
 		return -EFAULT;
 	}
@@ -341,7 +341,7 @@ static int setup_mcount_compiler_tramp(unsigned long tramp)
 			return -1;
 
 	/* New trampoline -- read where this goes */
-	if (probe_kernel_read(&op, (void *)tramp, sizeof(int))) {
+	if (copy_from_kernel_nofault(&op, (void *)tramp, sizeof(int))) {
 		pr_debug("Fetching opcode failed.\n");
 		return -1;
 	}
@@ -391,7 +391,7 @@ static int __ftrace_make_nop_kernel(struct dyn_ftrace *rec, unsigned long addr)
 	unsigned int op;
 
 	/* Read where this goes */
-	if (probe_kernel_read(&op, (void *)ip, sizeof(int))) {
+	if (copy_from_kernel_nofault(&op, (void *)ip, sizeof(int))) {
 		pr_err("Fetching opcode failed.\n");
 		return -EFAULT;
 	}
@@ -516,7 +516,7 @@ __ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 	struct module *mod = rec->arch.mod;
 
 	/* read where this goes */
-	if (probe_kernel_read(op, ip, sizeof(op)))
+	if (copy_from_kernel_nofault(op, ip, sizeof(op)))
 		return -EFAULT;
 
 	if (!expected_nop_sequence(ip, op[0], op[1])) {
@@ -578,7 +578,7 @@ __ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 	unsigned long ip = rec->ip;
 
 	/* read where this goes */
-	if (probe_kernel_read(&op, (void *)ip, MCOUNT_INSN_SIZE))
+	if (copy_from_kernel_nofault(&op, (void *)ip, MCOUNT_INSN_SIZE))
 		return -EFAULT;
 
 	/* It should be pointing to a nop */
@@ -634,7 +634,7 @@ static int __ftrace_make_call_kernel(struct dyn_ftrace *rec, unsigned long addr)
 	}
 
 	/* Make sure we have a nop */
-	if (probe_kernel_read(&op, ip, sizeof(op))) {
+	if (copy_from_kernel_nofault(&op, ip, sizeof(op))) {
 		pr_err("Unable to read ftrace location %p\n", ip);
 		return -EFAULT;
 	}
@@ -712,7 +712,7 @@ __ftrace_modify_call(struct dyn_ftrace *rec, unsigned long old_addr,
 	}
 
 	/* read where this goes */
-	if (probe_kernel_read(&op, (void *)ip, sizeof(int))) {
+	if (copy_from_kernel_nofault(&op, (void *)ip, sizeof(int))) {
 		pr_err("Fetching opcode failed.\n");
 		return -EFAULT;
 	}
diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index 3dcfecf858f36..50bc9f0eb6be3 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -418,7 +418,8 @@ static __u64 power_pmu_bhrb_to(u64 addr)
 	__u64 target;
 
 	if (is_kernel_addr(addr)) {
-		if (probe_kernel_read(&instr, (void *)addr, sizeof(instr)))
+		if (copy_from_kernel_nofault(&instr, (void *)addr,
+				sizeof(instr)))
 			return 0;
 
 		return branch_target(&instr);
diff --git a/arch/riscv/kernel/ftrace.c b/arch/riscv/kernel/ftrace.c
index ce69b34ff55d0..143a22ab8853e 100644
--- a/arch/riscv/kernel/ftrace.c
+++ b/arch/riscv/kernel/ftrace.c
@@ -25,7 +25,8 @@ static int ftrace_check_current_call(unsigned long hook_pos,
 	 * Read the text we want to modify;
 	 * return must be -EFAULT on read error
 	 */
-	if (probe_kernel_read(replaced, (void *)hook_pos, MCOUNT_INSN_SIZE))
+	if (copy_from_kernel_nofault(replaced, (void *)hook_pos,
+			MCOUNT_INSN_SIZE))
 		return -EFAULT;
 
 	/*
diff --git a/arch/riscv/kernel/patch.c b/arch/riscv/kernel/patch.c
index 8a4fc65ee0222..9a0ade9fa10b0 100644
--- a/arch/riscv/kernel/patch.c
+++ b/arch/riscv/kernel/patch.c
@@ -57,7 +57,7 @@ static int __kprobes riscv_insn_write(void *addr, const void *insn, size_t len)
 
 	waddr = patch_map(addr, FIX_TEXT_POKE0);
 
-	ret = probe_kernel_write(waddr, insn, len);
+	ret = copy_to_kernel_nofault(waddr, insn, len);
 
 	patch_unmap(FIX_TEXT_POKE0);
 
@@ -71,7 +71,7 @@ static int __kprobes riscv_insn_write(void *addr, const void *insn, size_t len)
 #else
 static int __kprobes riscv_insn_write(void *addr, const void *insn, size_t len)
 {
-	return probe_kernel_write(addr, insn, len);
+	return copy_to_kernel_nofault(addr, insn, len);
 }
 #endif /* CONFIG_MMU */
 
diff --git a/arch/s390/kernel/ftrace.c b/arch/s390/kernel/ftrace.c
index 4cd9b1ada8340..1576f0eede771 100644
--- a/arch/s390/kernel/ftrace.c
+++ b/arch/s390/kernel/ftrace.c
@@ -99,7 +99,7 @@ int ftrace_make_nop(struct module *mod, struct dyn_ftrace *rec,
 {
 	struct ftrace_insn orig, new, old;
 
-	if (probe_kernel_read(&old, (void *) rec->ip, sizeof(old)))
+	if (copy_from_kernel_nofault(&old, (void *) rec->ip, sizeof(old)))
 		return -EFAULT;
 	if (addr == MCOUNT_ADDR) {
 		/* Initial code replacement */
@@ -121,7 +121,7 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 {
 	struct ftrace_insn orig, new, old;
 
-	if (probe_kernel_read(&old, (void *) rec->ip, sizeof(old)))
+	if (copy_from_kernel_nofault(&old, (void *) rec->ip, sizeof(old)))
 		return -EFAULT;
 	/* Replace nop with an ftrace call. */
 	ftrace_generate_nop_insn(&orig);
diff --git a/arch/sh/kernel/ftrace.c b/arch/sh/kernel/ftrace.c
index 1b04270e5460e..0646c59618466 100644
--- a/arch/sh/kernel/ftrace.c
+++ b/arch/sh/kernel/ftrace.c
@@ -119,7 +119,7 @@ static void ftrace_mod_code(void)
 	 * But if one were to fail, then they all should, and if one were
 	 * to succeed, then they all should.
 	 */
-	mod_code_status = probe_kernel_write(mod_code_ip, mod_code_newcode,
+	mod_code_status = copy_to_kernel_nofault(mod_code_ip, mod_code_newcode,
 					     MCOUNT_INSN_SIZE);
 
 	/* if we fail, then kill any new writers */
@@ -203,7 +203,7 @@ static int ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 	 */
 
 	/* read the text we want to modify */
-	if (probe_kernel_read(replaced, (void *)ip, MCOUNT_INSN_SIZE))
+	if (copy_from_kernel_nofault(replaced, (void *)ip, MCOUNT_INSN_SIZE))
 		return -EFAULT;
 
 	/* Make sure it is what we expect it to be */
@@ -268,7 +268,7 @@ static int ftrace_mod(unsigned long ip, unsigned long old_addr,
 {
 	unsigned char code[MCOUNT_INSN_SIZE];
 
-	if (probe_kernel_read(code, (void *)ip, MCOUNT_INSN_SIZE))
+	if (copy_from_kernel_nofault(code, (void *)ip, MCOUNT_INSN_SIZE))
 		return -EFAULT;
 
 	if (old_addr != __raw_readl((unsigned long *)code))
diff --git a/arch/um/kernel/maccess.c b/arch/um/kernel/maccess.c
index 734f3d7e57c0f..cedf73e9e8ce2 100644
--- a/arch/um/kernel/maccess.c
+++ b/arch/um/kernel/maccess.c
@@ -7,7 +7,7 @@
 #include <linux/kernel.h>
 #include <os.h>
 
-bool probe_kernel_read_allowed(void *dst, const void *src, size_t size)
+bool copy_from_kernel_nofault_allowed(void *dst, const void *src, size_t size)
 {
 	void *psrc = (void *)rounddown((unsigned long)src, PAGE_SIZE);
 
diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 6d6475fdd3278..62ac40751276f 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -278,7 +278,7 @@ static inline unsigned long *regs_get_kernel_stack_nth_addr(struct pt_regs *regs
 }
 
 /* To avoid include hell, we can't include uaccess.h */
-extern long probe_kernel_read(void *dst, const void *src, size_t size);
+extern long copy_from_kernel_nofault(void *dst, const void *src, size_t size);
 
 /**
  * regs_get_kernel_stack_nth() - get Nth entry of the stack
@@ -298,7 +298,7 @@ static inline unsigned long regs_get_kernel_stack_nth(struct pt_regs *regs,
 
 	addr = regs_get_kernel_stack_nth_addr(regs, n);
 	if (addr) {
-		ret = probe_kernel_read(&val, addr, sizeof(val));
+		ret = copy_from_kernel_nofault(&val, addr, sizeof(val));
 		if (!ret)
 			return val;
 	}
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index ae64ec7f752f4..f8dd06ccd8d2e 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -106,7 +106,7 @@ void show_opcodes(struct pt_regs *regs, const char *loglvl)
 	bad_ip = user_mode(regs) &&
 		__chk_range_not_ok(prologue, OPCODE_BUFSIZE, TASK_SIZE_MAX);
 
-	if (bad_ip || probe_kernel_read(opcodes, (u8 *)prologue,
+	if (bad_ip || copy_from_kernel_nofault(opcodes, (u8 *)prologue,
 					OPCODE_BUFSIZE)) {
 		printk("%sCode: Bad RIP value.\n", loglvl);
 	} else {
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index b0e641793be4f..3a27647d00560 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -86,7 +86,7 @@ static int ftrace_verify_code(unsigned long ip, const char *old_code)
 	 * sure what we read is what we expected it to be before modifying it.
 	 */
 	/* read the text we want to modify */
-	if (probe_kernel_read(cur_code, (void *)ip, MCOUNT_INSN_SIZE)) {
+	if (copy_from_kernel_nofault(cur_code, (void *)ip, MCOUNT_INSN_SIZE)) {
 		WARN_ON(1);
 		return -EFAULT;
 	}
@@ -354,7 +354,7 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 	npages = DIV_ROUND_UP(*tramp_size, PAGE_SIZE);
 
 	/* Copy ftrace_caller onto the trampoline memory */
-	ret = probe_kernel_read(trampoline, (void *)start_offset, size);
+	ret = copy_from_kernel_nofault(trampoline, (void *)start_offset, size);
 	if (WARN_ON(ret < 0))
 		goto fail;
 
@@ -362,7 +362,7 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 
 	/* The trampoline ends with ret(q) */
 	retq = (unsigned long)ftrace_stub;
-	ret = probe_kernel_read(ip, (void *)retq, RET_SIZE);
+	ret = copy_from_kernel_nofault(ip, (void *)retq, RET_SIZE);
 	if (WARN_ON(ret < 0))
 		goto fail;
 
@@ -498,7 +498,7 @@ static void *addr_from_call(void *ptr)
 	union text_poke_insn call;
 	int ret;
 
-	ret = probe_kernel_read(&call, ptr, CALL_INSN_SIZE);
+	ret = copy_from_kernel_nofault(&call, ptr, CALL_INSN_SIZE);
 	if (WARN_ON_ONCE(ret < 0))
 		return NULL;
 
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index c44fe7d8d9a4e..68acd30c6b878 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -732,11 +732,11 @@ int kgdb_arch_set_breakpoint(struct kgdb_bkpt *bpt)
 	int err;
 
 	bpt->type = BP_BREAKPOINT;
-	err = probe_kernel_read(bpt->saved_instr, (char *)bpt->bpt_addr,
+	err = copy_from_kernel_nofault(bpt->saved_instr, (char *)bpt->bpt_addr,
 				BREAK_INSTR_SIZE);
 	if (err)
 		return err;
-	err = probe_kernel_write((char *)bpt->bpt_addr,
+	err = copy_to_kernel_nofault((char *)bpt->bpt_addr,
 				 arch_kgdb_ops.gdb_bpt_instr, BREAK_INSTR_SIZE);
 	if (!err)
 		return err;
@@ -768,7 +768,7 @@ int kgdb_arch_remove_breakpoint(struct kgdb_bkpt *bpt)
 	return 0;
 
 knl_write:
-	return probe_kernel_write((char *)bpt->bpt_addr,
+	return copy_to_kernel_nofault((char *)bpt->bpt_addr,
 				  (char *)bpt->saved_instr, BREAK_INSTR_SIZE);
 }
 
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 4d7022a740ab0..ecffda528f86f 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -243,7 +243,7 @@ __recover_probed_insn(kprobe_opcode_t *buf, unsigned long addr)
 	 * Fortunately, we know that the original code is the ideal 5-byte
 	 * long NOP.
 	 */
-	if (probe_kernel_read(buf, (void *)addr,
+	if (copy_from_kernel_nofault(buf, (void *)addr,
 		MAX_INSN_SIZE * sizeof(kprobe_opcode_t)))
 		return 0UL;
 
@@ -346,7 +346,8 @@ int __copy_instruction(u8 *dest, u8 *src, u8 *real, struct insn *insn)
 		return 0;
 
 	/* This can access kernel text if given address is not recovered */
-	if (probe_kernel_read(dest, (void *)recovered_insn, MAX_INSN_SIZE))
+	if (copy_from_kernel_nofault(dest, (void *)recovered_insn,
+			MAX_INSN_SIZE))
 		return 0;
 
 	kernel_insn_init(insn, dest, MAX_INSN_SIZE);
diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
index ea13f68882849..85696911093f4 100644
--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -56,7 +56,7 @@ unsigned long __recover_optprobed_insn(kprobe_opcode_t *buf, unsigned long addr)
 	 * overwritten by jump destination address. In this case, original
 	 * bytes must be recovered from op->optinsn.copied_insn buffer.
 	 */
-	if (probe_kernel_read(buf, (void *)addr,
+	if (copy_from_kernel_nofault(buf, (void *)addr,
 		MAX_INSN_SIZE * sizeof(kprobe_opcode_t)))
 		return 0UL;
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index d54cffdc7cac2..96809f6aad67d 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -483,7 +483,8 @@ static enum kernel_gp_hint get_kernel_gp_address(struct pt_regs *regs,
 	u8 insn_buf[MAX_INSN_SIZE];
 	struct insn insn;
 
-	if (probe_kernel_read(insn_buf, (void *)regs->ip, MAX_INSN_SIZE))
+	if (copy_from_kernel_nofault(insn_buf, (void *)regs->ip,
+			MAX_INSN_SIZE))
 		return GP_NO_HINT;
 
 	kernel_insn_init(&insn, insn_buf, MAX_INSN_SIZE);
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index a51df516b87bf..994e207abdf64 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -590,7 +590,7 @@ static void show_ldttss(const struct desc_ptr *gdt, const char *name, u16 index)
 		return;
 	}
 
-	if (probe_kernel_read(&desc, (void *)(gdt->address + offset),
+	if (copy_from_kernel_nofault(&desc, (void *)(gdt->address + offset),
 			      sizeof(struct ldttss_desc))) {
 		pr_alert("%s: 0x%hx -- GDT entry is not readable\n",
 			 name, index);
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 4222a010057a9..4253c95968932 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -758,7 +758,7 @@ static void __init test_wp_bit(void)
 
 	__set_fixmap(FIX_WP_TEST, __pa_symbol(empty_zero_page), PAGE_KERNEL_RO);
 
-	if (probe_kernel_write((char *)fix_to_virt(FIX_WP_TEST), &z, 1)) {
+	if (copy_to_kernel_nofault((char *)fix_to_virt(FIX_WP_TEST), &z, 1)) {
 		clear_fixmap(FIX_WP_TEST);
 		printk(KERN_CONT "Ok.\n");
 		return;
diff --git a/arch/x86/mm/maccess.c b/arch/x86/mm/maccess.c
index a1bd81677aa72..a29111d25a990 100644
--- a/arch/x86/mm/maccess.c
+++ b/arch/x86/mm/maccess.c
@@ -26,7 +26,8 @@ static __always_inline bool invalid_probe_range(u64 vaddr)
 }
 #endif
 
-bool probe_kernel_read_allowed(void *dst, const void *unsafe_src, size_t size)
+bool copy_from_kernel_nofault_allowed(void *dst, const void *unsafe_src,
+		size_t size)
 {
 	return !invalid_probe_range((unsigned long)unsafe_src);
 }
diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 507f4fb88fa7f..0a76fd298d896 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -387,7 +387,7 @@ static void set_aliased_prot(void *v, pgprot_t prot)
 
 	preempt_disable();
 
-	probe_kernel_read(&dummy, v, 1);
+	copy_from_kernel_nofault(&dummy, v, 1);
 
 	if (HYPERVISOR_update_va_mapping((unsigned long)v, pte, 0))
 		BUG();
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 43dd0891ca1ed..12774655aff45 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -167,7 +167,7 @@ static ssize_t read_mem(struct file *file, char __user *buf,
 			if (!ptr)
 				goto failed;
 
-			probe = probe_kernel_read(bounce, ptr, sz);
+			probe = copy_from_kernel_nofault(bounce, ptr, sz);
 			unxlate_dev_mem_ptr(p, ptr);
 			if (probe)
 				goto failed;
diff --git a/drivers/dio/dio.c b/drivers/dio/dio.c
index c9aa15fb86a9a..193b40e7aec03 100644
--- a/drivers/dio/dio.c
+++ b/drivers/dio/dio.c
@@ -135,7 +135,8 @@ int __init dio_find(int deviceid)
 		else
 			va = ioremap(pa, PAGE_SIZE);
 
-                if (probe_kernel_read(&i, (unsigned char *)va + DIO_IDOFF, 1)) {
+		if (copy_from_kernel_nofault(&i,
+				(unsigned char *)va + DIO_IDOFF, 1)) {
 			if (scode >= DIOII_SCBASE)
 				iounmap(va);
                         continue;             /* no board present at that select code */
@@ -208,7 +209,8 @@ static int __init dio_init(void)
 		else
 			va = ioremap(pa, PAGE_SIZE);
 
-                if (probe_kernel_read(&i, (unsigned char *)va + DIO_IDOFF, 1)) {
+		if (copy_from_kernel_nofault(&i,
+				(unsigned char *)va + DIO_IDOFF, 1)) {
 			if (scode >= DIOII_SCBASE)
 				iounmap(va);
                         continue;              /* no board present at that select code */
diff --git a/drivers/input/serio/hp_sdc.c b/drivers/input/serio/hp_sdc.c
index 654252361653d..13eacf6ab4310 100644
--- a/drivers/input/serio/hp_sdc.c
+++ b/drivers/input/serio/hp_sdc.c
@@ -1021,7 +1021,7 @@ static int __init hp_sdc_register(void)
 	hp_sdc.base_io	 = (unsigned long) 0xf0428000;
 	hp_sdc.data_io	 = (unsigned long) hp_sdc.base_io + 1;
 	hp_sdc.status_io = (unsigned long) hp_sdc.base_io + 3;
-	if (!probe_kernel_read(&i, (unsigned char *)hp_sdc.data_io, 1))
+	if (!copy_from_kernel_nofault(&i, (unsigned char *)hp_sdc.data_io, 1))
 		hp_sdc.dev = (void *)1;
 	hp_sdc.dev_err   = hp_sdc_init();
 #endif
diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
index bccd341e9ae16..d5d2af4d10e66 100644
--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -828,7 +828,7 @@ static void run_plant_and_detach_test(int is_early)
 	char before[BREAK_INSTR_SIZE];
 	char after[BREAK_INSTR_SIZE];
 
-	probe_kernel_read(before, (char *)kgdbts_break_test,
+	copy_from_kernel_nofault(before, (char *)kgdbts_break_test,
 	  BREAK_INSTR_SIZE);
 	init_simple_test();
 	ts.tst = plant_and_detach_test;
@@ -836,8 +836,8 @@ static void run_plant_and_detach_test(int is_early)
 	/* Activate test with initial breakpoint */
 	if (!is_early)
 		kgdb_breakpoint();
-	probe_kernel_read(after, (char *)kgdbts_break_test,
-	  BREAK_INSTR_SIZE);
+	copy_from_kernel_nofault(after, (char *)kgdbts_break_test,
+			BREAK_INSTR_SIZE);
 	if (memcmp(before, after, BREAK_INSTR_SIZE)) {
 		printk(KERN_CRIT "kgdbts: ERROR kgdb corrupted memory\n");
 		panic("kgdb memory corruption");
diff --git a/drivers/video/fbdev/hpfb.c b/drivers/video/fbdev/hpfb.c
index f02be0db335e9..8d418abdd7678 100644
--- a/drivers/video/fbdev/hpfb.c
+++ b/drivers/video/fbdev/hpfb.c
@@ -402,7 +402,7 @@ int __init hpfb_init(void)
 	if (err)
 		return err;
 
-	err = probe_kernel_read(&i, (unsigned char *)INTFBVADDR + DIO_IDOFF, 1);
+	err = copy_from_kernel_nofault(&i, (unsigned char *)INTFBVADDR + DIO_IDOFF, 1);
 
 	if (!err && (i == DIO_ID_FBUFFER) && topcat_sid_ok(sid = DIO_SECID(INTFBVADDR))) {
 		if (!request_mem_region(INTFBPADDR, DIO_DEVSIZE, "Internal Topcat"))
diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index 8ba492d44e689..e502414b35564 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -512,7 +512,8 @@ read_kcore(struct file *file, char __user *buffer, size_t buflen, loff_t *fpos)
 				 * Using bounce buffer to bypass the
 				 * hardened user copy kernel text checks.
 				 */
-				if (probe_kernel_read(buf, (void *) start, tsz)) {
+				if (copy_from_kernel_nofault(buf, (void *)start,
+						tsz)) {
 					if (clear_user(buffer, tsz)) {
 						ret = -EFAULT;
 						goto out;
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 78e0ff8641559..849bc3dca54d6 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -301,13 +301,15 @@ copy_struct_from_user(void *dst, size_t ksize, const void __user *src,
 	return 0;
 }
 
-bool probe_kernel_read_allowed(void *dst, const void *unsafe_src, size_t size);
+bool copy_from_kernel_nofault_allowed(void *dst, const void *unsafe_src,
+		size_t size);
 
-extern long probe_kernel_read(void *dst, const void *src, size_t size);
-extern long probe_user_read(void *dst, const void __user *src, size_t size);
+long copy_from_kernel_nofault(void *dst, const void *src, size_t size);
+long notrace copy_to_kernel_nofault(void *dst, const void *src, size_t size);
 
-extern long notrace probe_kernel_write(void *dst, const void *src, size_t size);
-extern long notrace probe_user_write(void __user *dst, const void *src, size_t size);
+extern long probe_user_read(void *dst, const void __user *src, size_t size);
+extern long notrace probe_user_write(void __user *dst, const void *src,
+		size_t size);
 
 long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr,
 		long count);
@@ -324,7 +326,7 @@ long strnlen_user_nofault(const void __user *unsafe_addr, long count);
  * Returns 0 on success, or -EFAULT.
  */
 #define probe_kernel_address(addr, retval)		\
-	probe_kernel_read(&retval, addr, sizeof(retval))
+	copy_from_kernel_nofault(&retval, addr, sizeof(retval))
 
 #ifndef user_access_begin
 #define user_access_begin(ptr,len) access_ok(ptr, len)
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 2b7c9b67931d6..b5c2492e0b010 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -171,18 +171,18 @@ int __weak kgdb_arch_set_breakpoint(struct kgdb_bkpt *bpt)
 {
 	int err;
 
-	err = probe_kernel_read(bpt->saved_instr, (char *)bpt->bpt_addr,
+	err = copy_from_kernel_nofault(bpt->saved_instr, (char *)bpt->bpt_addr,
 				BREAK_INSTR_SIZE);
 	if (err)
 		return err;
-	err = probe_kernel_write((char *)bpt->bpt_addr,
+	err = copy_to_kernel_nofault((char *)bpt->bpt_addr,
 				 arch_kgdb_ops.gdb_bpt_instr, BREAK_INSTR_SIZE);
 	return err;
 }
 
 int __weak kgdb_arch_remove_breakpoint(struct kgdb_bkpt *bpt)
 {
-	return probe_kernel_write((char *)bpt->bpt_addr,
+	return copy_to_kernel_nofault((char *)bpt->bpt_addr,
 				  (char *)bpt->saved_instr, BREAK_INSTR_SIZE);
 }
 
diff --git a/kernel/debug/gdbstub.c b/kernel/debug/gdbstub.c
index 4b280fc7dd675..61774aec46b4c 100644
--- a/kernel/debug/gdbstub.c
+++ b/kernel/debug/gdbstub.c
@@ -247,7 +247,7 @@ char *kgdb_mem2hex(char *mem, char *buf, int count)
 	 */
 	tmp = buf + count;
 
-	err = probe_kernel_read(tmp, mem, count);
+	err = copy_from_kernel_nofault(tmp, mem, count);
 	if (err)
 		return NULL;
 	while (count > 0) {
@@ -283,7 +283,7 @@ int kgdb_hex2mem(char *buf, char *mem, int count)
 		*tmp_raw |= hex_to_bin(*tmp_hex--) << 4;
 	}
 
-	return probe_kernel_write(mem, tmp_raw, count);
+	return copy_to_kernel_nofault(mem, tmp_raw, count);
 }
 
 /*
@@ -335,7 +335,7 @@ static int kgdb_ebin2mem(char *buf, char *mem, int count)
 		size++;
 	}
 
-	return probe_kernel_write(mem, c, size);
+	return copy_to_kernel_nofault(mem, c, size);
 }
 
 #if DBG_MAX_REG_NUM > 0
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 515379cbf2092..31858c3839ca5 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -2325,7 +2325,8 @@ void kdb_ps1(const struct task_struct *p)
 	int cpu;
 	unsigned long tmp;
 
-	if (!p || probe_kernel_read(&tmp, (char *)p, sizeof(unsigned long)))
+	if (!p ||
+	    copy_from_kernel_nofault(&tmp, (char *)p, sizeof(unsigned long)))
 		return;
 
 	cpu = kdb_process_cpu(p);
diff --git a/kernel/debug/kdb/kdb_support.c b/kernel/debug/kdb/kdb_support.c
index b8e6306e7e133..004c5b6c87f89 100644
--- a/kernel/debug/kdb/kdb_support.c
+++ b/kernel/debug/kdb/kdb_support.c
@@ -325,7 +325,7 @@ char *kdb_strdup(const char *str, gfp_t type)
  */
 int kdb_getarea_size(void *res, unsigned long addr, size_t size)
 {
-	int ret = probe_kernel_read((char *)res, (char *)addr, size);
+	int ret = copy_from_kernel_nofault((char *)res, (char *)addr, size);
 	if (ret) {
 		if (!KDB_STATE(SUPPRESS)) {
 			kdb_printf("kdb_getarea: Bad address 0x%lx\n", addr);
@@ -350,7 +350,7 @@ int kdb_getarea_size(void *res, unsigned long addr, size_t size)
  */
 int kdb_putarea_size(unsigned long addr, void *res, size_t size)
 {
-	int ret = probe_kernel_read((char *)addr, (char *)res, size);
+	int ret = copy_from_kernel_nofault((char *)addr, (char *)res, size);
 	if (ret) {
 		if (!KDB_STATE(SUPPRESS)) {
 			kdb_printf("kdb_putarea: Bad address 0x%lx\n", addr);
@@ -624,7 +624,8 @@ char kdb_task_state_char (const struct task_struct *p)
 	char state;
 	unsigned long tmp;
 
-	if (!p || probe_kernel_read(&tmp, (char *)p, sizeof(unsigned long)))
+	if (!p ||
+	    copy_from_kernel_nofault(&tmp, (char *)p, sizeof(unsigned long)))
 		return 'E';
 
 	cpu = kdb_process_cpu(p);
diff --git a/kernel/kthread.c b/kernel/kthread.c
index bfbfa481be3a5..e19ebe61232ca 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -179,7 +179,7 @@ void *kthread_probe_data(struct task_struct *task)
 	struct kthread *kthread = to_kthread(task);
 	void *data = NULL;
 
-	probe_kernel_read(&data, &kthread->data, sizeof(data));
+	copy_from_kernel_nofault(&data, &kthread->data, sizeof(data));
 	return data;
 }
 
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index c6007d9a987d5..5b591d3b62af0 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -190,7 +190,7 @@ bpf_probe_read_kernel_common(void *dst, u32 size, const void *unsafe_ptr,
 	    compat && (unsigned long)unsafe_ptr < TASK_SIZE)
 		ret = probe_user_read(dst, user_ptr, size);
 	else
-		ret = probe_kernel_read(dst, unsafe_ptr, size);
+		ret = copy_from_kernel_nofault(dst, unsafe_ptr, size);
 	if (unlikely(ret < 0))
 		goto fail;
 
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 82da20e712507..dab7c22d3e131 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1213,7 +1213,7 @@ fetch_store_strlen(unsigned long addr)
 			ret = probe_user_read(&c,
 				(__force u8 __user *)addr + len, 1);
 		} else {
-			ret = probe_kernel_read(&c, (u8 *)addr + len, 1);
+			ret = copy_from_kernel_nofault(&c, (u8 *)addr + len, 1);
 		}
 		len++;
 	} while (c && ret == 0 && len < MAX_STRING_SIZE);
@@ -1296,7 +1296,7 @@ probe_mem_read(void *dest, void *src, size_t size)
 				size);
 	}
 
-	return probe_kernel_read(dest, src, size);
+	return copy_from_kernel_nofault(dest, src, size);
 }
 
 static nokprobe_inline int
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 891ccad5f2716..a1345ffa3a0ba 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4627,11 +4627,11 @@ void print_worker_info(const char *log_lvl, struct task_struct *task)
 	 * Carefully copy the associated workqueue's workfn, name and desc.
 	 * Keep the original last '\0' in case the original is garbage.
 	 */
-	probe_kernel_read(&fn, &worker->current_func, sizeof(fn));
-	probe_kernel_read(&pwq, &worker->current_pwq, sizeof(pwq));
-	probe_kernel_read(&wq, &pwq->wq, sizeof(wq));
-	probe_kernel_read(name, wq->name, sizeof(name) - 1);
-	probe_kernel_read(desc, worker->desc, sizeof(desc) - 1);
+	copy_from_kernel_nofault(&fn, &worker->current_func, sizeof(fn));
+	copy_from_kernel_nofault(&pwq, &worker->current_pwq, sizeof(pwq));
+	copy_from_kernel_nofault(&wq, &pwq->wq, sizeof(wq));
+	copy_from_kernel_nofault(name, wq->name, sizeof(name) - 1);
+	copy_from_kernel_nofault(desc, worker->desc, sizeof(desc) - 1);
 
 	if (fn || name[0] || desc[0]) {
 		printk("%sWorkqueue: %s %ps", log_lvl, name, fn);
diff --git a/mm/maccess.c b/mm/maccess.c
index 01129cbdf4484..955b6c973f742 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -6,7 +6,7 @@
 #include <linux/mm.h>
 #include <linux/uaccess.h>
 
-bool __weak probe_kernel_read_allowed(void *dst, const void *unsafe_src,
+bool __weak copy_from_kernel_nofault_allowed(void *dst, const void *unsafe_src,
 		size_t size)
 {
 	return true;
@@ -14,7 +14,7 @@ bool __weak probe_kernel_read_allowed(void *dst, const void *unsafe_src,
 
 #ifdef HAVE_GET_KERNEL_NOFAULT
 
-#define probe_kernel_read_loop(dst, src, len, type, err_label)		\
+#define copy_from_kernel_nofault_loop(dst, src, len, type, err_label)	\
 	while (len >= sizeof(type)) {					\
 		__get_kernel_nofault(dst, src, type, err_label);		\
 		dst += sizeof(type);					\
@@ -22,25 +22,25 @@ bool __weak probe_kernel_read_allowed(void *dst, const void *unsafe_src,
 		len -= sizeof(type);					\
 	}
 
-long probe_kernel_read(void *dst, const void *src, size_t size)
+long copy_from_kernel_nofault(void *dst, const void *src, size_t size)
 {
-	if (!probe_kernel_read_allowed(dst, src, size))
+	if (!copy_from_kernel_nofault_allowed(dst, src, size))
 		return -EFAULT;
 
 	pagefault_disable();
-	probe_kernel_read_loop(dst, src, size, u64, Efault);
-	probe_kernel_read_loop(dst, src, size, u32, Efault);
-	probe_kernel_read_loop(dst, src, size, u16, Efault);
-	probe_kernel_read_loop(dst, src, size, u8, Efault);
+	copy_from_kernel_nofault_loop(dst, src, size, u64, Efault);
+	copy_from_kernel_nofault_loop(dst, src, size, u32, Efault);
+	copy_from_kernel_nofault_loop(dst, src, size, u16, Efault);
+	copy_from_kernel_nofault_loop(dst, src, size, u8, Efault);
 	pagefault_enable();
 	return 0;
 Efault:
 	pagefault_enable();
 	return -EFAULT;
 }
-EXPORT_SYMBOL_GPL(probe_kernel_read);
+EXPORT_SYMBOL_GPL(copy_from_kernel_nofault);
 
-#define probe_kernel_write_loop(dst, src, len, type, err_label)		\
+#define copy_to_kernel_nofault_loop(dst, src, len, type, err_label)	\
 	while (len >= sizeof(type)) {					\
 		__put_kernel_nofault(dst, src, type, err_label);		\
 		dst += sizeof(type);					\
@@ -48,13 +48,13 @@ EXPORT_SYMBOL_GPL(probe_kernel_read);
 		len -= sizeof(type);					\
 	}
 
-long probe_kernel_write(void *dst, const void *src, size_t size)
+long copy_to_kernel_nofault(void *dst, const void *src, size_t size)
 {
 	pagefault_disable();
-	probe_kernel_write_loop(dst, src, size, u64, Efault);
-	probe_kernel_write_loop(dst, src, size, u32, Efault);
-	probe_kernel_write_loop(dst, src, size, u16, Efault);
-	probe_kernel_write_loop(dst, src, size, u8, Efault);
+	copy_to_kernel_nofault_loop(dst, src, size, u64, Efault);
+	copy_to_kernel_nofault_loop(dst, src, size, u32, Efault);
+	copy_to_kernel_nofault_loop(dst, src, size, u16, Efault);
+	copy_to_kernel_nofault_loop(dst, src, size, u8, Efault);
 	pagefault_enable();
 	return 0;
 Efault:
@@ -68,7 +68,7 @@ long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
 
 	if (unlikely(count <= 0))
 		return 0;
-	if (!probe_kernel_read_allowed(dst, unsafe_addr, count))
+	if (!copy_from_kernel_nofault_allowed(dst, unsafe_addr, count))
 		return -EFAULT;
 
 	pagefault_disable();
@@ -88,7 +88,7 @@ long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
 }
 #else /* HAVE_GET_KERNEL_NOFAULT */
 /**
- * probe_kernel_read(): safely attempt to read from kernel-space
+ * copy_from_kernel_nofault(): safely attempt to read from kernel-space
  * @dst: pointer to the buffer that shall take the data
  * @src: address to read from
  * @size: size of the data chunk
@@ -98,15 +98,15 @@ long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
  *
  * We ensure that the copy_from_user is executed in atomic context so that
  * do_page_fault() doesn't attempt to take mmap_sem.  This makes
- * probe_kernel_read() suitable for use within regions where the caller
+ * copy_from_kernel_nofault() suitable for use within regions where the caller
  * already holds mmap_sem, or other locks which nest inside mmap_sem.
  */
-long probe_kernel_read(void *dst, const void *src, size_t size)
+long copy_from_kernel_nofault(void *dst, const void *src, size_t size)
 {
 	long ret;
 	mm_segment_t old_fs = get_fs();
 
-	if (!probe_kernel_read_allowed(dst, src, size))
+	if (!copy_from_kernel_nofault_allowed(dst, src, size))
 		return -EFAULT;
 
 	set_fs(KERNEL_DS);
@@ -120,10 +120,10 @@ long probe_kernel_read(void *dst, const void *src, size_t size)
 		return -EFAULT;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(probe_kernel_read);
+EXPORT_SYMBOL_GPL(copy_from_kernel_nofault);
 
 /**
- * probe_kernel_write(): safely attempt to write to a location
+ * copy_to_kernel_nofault(): safely attempt to write to a location
  * @dst: address to write to
  * @src: pointer to the data that shall be written
  * @size: size of the data chunk
@@ -131,7 +131,7 @@ EXPORT_SYMBOL_GPL(probe_kernel_read);
  * Safely write to address @dst from the buffer at @src.  If a kernel fault
  * happens, handle that and return -EFAULT.
  */
-long probe_kernel_write(void *dst, const void *src, size_t size)
+long copy_to_kernel_nofault(void *dst, const void *src, size_t size)
 {
 	long ret;
 	mm_segment_t old_fs = get_fs();
@@ -173,7 +173,7 @@ long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
 
 	if (unlikely(count <= 0))
 		return 0;
-	if (!probe_kernel_read_allowed(dst, unsafe_addr, count))
+	if (!copy_from_kernel_nofault_allowed(dst, unsafe_addr, count))
 		return -EFAULT;
 
 	set_fs(KERNEL_DS);
diff --git a/mm/rodata_test.c b/mm/rodata_test.c
index 5e313fa93276d..2a99df7beeb35 100644
--- a/mm/rodata_test.c
+++ b/mm/rodata_test.c
@@ -25,7 +25,7 @@ void rodata_test(void)
 	}
 
 	/* test 2: write to the variable; this should fault */
-	if (!probe_kernel_write((void *)&rodata_test_data,
+	if (!copy_to_kernel_nofault((void *)&rodata_test_data,
 				(void *)&zero, sizeof(zero))) {
 		pr_err("test data was not read only\n");
 		return;
diff --git a/mm/slub.c b/mm/slub.c
index b762450fc9f07..4af02f7af7118 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -292,7 +292,7 @@ static inline void *get_freepointer_safe(struct kmem_cache *s, void *object)
 		return get_freepointer(s, object);
 
 	freepointer_addr = (unsigned long)object + s->offset;
-	probe_kernel_read(&p, (void **)freepointer_addr, sizeof(p));
+	copy_from_kernel_nofault(&p, (void **)freepointer_addr, sizeof(p));
 	return freelist_ptr(s, p, freepointer_addr);
 }
 
-- 
2.26.2

