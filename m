Return-Path: <netdev+bounces-7054-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D8AB07198BE
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 12:14:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8DBC3281610
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 10:14:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AD7A206A9;
	Thu,  1 Jun 2023 10:13:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F06220680;
	Thu,  1 Jun 2023 10:13:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA4AC433A8;
	Thu,  1 Jun 2023 10:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685614414;
	bh=650MGgIz3ifEdmt5EAPBLq8Xf3erPRE6hU5FPv92RsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sawxEUNDuUO7c2uBkql+3a4HVy34CMkiJ1ElbEu8ta+r8fBePYZBIL5hWCr+ZExkr
	 3ZFdY53+9gM9peUGyrw5BqGRrckgY7OkPcXuQs32K1QeQofBG2ruTYaS/SeYkD1y7n
	 jB154v/ppngiw0OO3ZzFFtZ/luuVjn/nsby1iuNmx6m0Hfsk4PR3Q2gMwISy5dOSzt
	 8Yt1y8c+bHebiBDqMr6jbxjqy0kg1Arh90KCB7A2nLKNv77h1ynG3dJN5XvVTIC5vw
	 NRt8q+ZuUABmYHUDCk46EVHXzBrkUUzSWbt7sXxxLlcbcH2NWKTP8ImW41fewBA8gL
	 KSmsJW6hHbmXg==
From: Mike Rapoport <rppt@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"David S. Miller" <davem@davemloft.net>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Mike Rapoport <rppt@kernel.org>,
	"Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Russell King <linux@armlinux.org.uk>,
	Song Liu <song@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Will Deacon <will@kernel.org>,
	bpf@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mips@vger.kernel.org,
	linux-mm@kvack.org,
	linux-modules@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	loongarch@lists.linux.dev,
	netdev@vger.kernel.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH 02/13] mm: introduce jit_text_alloc() and use it instead of module_alloc()
Date: Thu,  1 Jun 2023 13:12:46 +0300
Message-Id: <20230601101257.530867-3-rppt@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230601101257.530867-1-rppt@kernel.org>
References: <20230601101257.530867-1-rppt@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Mike Rapoport (IBM)" <rppt@kernel.org>

module_alloc() is used everywhere as a mean to allocate memory for code.

Beside being semantically wrong, this unnecessarily ties all subsystmes
that need to allocate code, such as ftrace, kprobes and BPF to modules
and puts the burden of code allocation to the modules code.

Several architectures override module_alloc() because of various
constraints where the executable memory can be located and this causes
additional obstacles for improvements of code allocation.

Start splitting code allocation from modules by introducing
jit_text_alloc() and jit_free() APIs.

Start with making jit_text_alloc() a wrapper for module_alloc() and
jit_free() a replacement of module_memfree() to allow updating all call
sites to use the new APIs.

The name jit_text_alloc() emphasizes that the allocated memory is for
executable code, the allocations of the associated data, like data sections
of a module will use jit_data_alloc() interface that will be added later.

Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
---
 arch/powerpc/kernel/kprobes.c    |  4 ++--
 arch/s390/kernel/ftrace.c        |  4 ++--
 arch/s390/kernel/kprobes.c       |  4 ++--
 arch/s390/kernel/module.c        |  5 +++--
 arch/sparc/net/bpf_jit_comp_32.c |  8 ++++----
 arch/x86/kernel/ftrace.c         |  6 +++---
 arch/x86/kernel/kprobes/core.c   |  4 ++--
 include/linux/jitalloc.h         | 10 ++++++++++
 include/linux/moduleloader.h     |  3 ---
 kernel/bpf/core.c                | 14 +++++++-------
 kernel/kprobes.c                 |  8 ++++----
 kernel/module/Kconfig            |  1 +
 kernel/module/main.c             | 23 +++++++----------------
 mm/Kconfig                       |  3 +++
 mm/Makefile                      |  1 +
 mm/jitalloc.c                    | 20 ++++++++++++++++++++
 16 files changed, 71 insertions(+), 47 deletions(-)
 create mode 100644 include/linux/jitalloc.h
 create mode 100644 mm/jitalloc.c

diff --git a/arch/powerpc/kernel/kprobes.c b/arch/powerpc/kernel/kprobes.c
index b20ee72e873a..e5835b148ec4 100644
--- a/arch/powerpc/kernel/kprobes.c
+++ b/arch/powerpc/kernel/kprobes.c
@@ -19,8 +19,8 @@
 #include <linux/extable.h>
 #include <linux/kdebug.h>
 #include <linux/slab.h>
-#include <linux/moduleloader.h>
 #include <linux/set_memory.h>
+#include <linux/jitalloc.h>
 #include <asm/code-patching.h>
 #include <asm/cacheflush.h>
 #include <asm/sstep.h>
@@ -130,7 +130,7 @@ void *alloc_insn_page(void)
 {
 	void *page;
 
-	page = module_alloc(PAGE_SIZE);
+	page = jit_text_alloc(PAGE_SIZE);
 	if (!page)
 		return NULL;
 
diff --git a/arch/s390/kernel/ftrace.c b/arch/s390/kernel/ftrace.c
index c46381ea04ec..6e50a88b9b5d 100644
--- a/arch/s390/kernel/ftrace.c
+++ b/arch/s390/kernel/ftrace.c
@@ -7,13 +7,13 @@
  *   Author(s): Martin Schwidefsky <schwidefsky@de.ibm.com>
  */
 
-#include <linux/moduleloader.h>
 #include <linux/hardirq.h>
 #include <linux/uaccess.h>
 #include <linux/ftrace.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/kprobes.h>
+#include <linux/jitalloc.h>
 #include <trace/syscall.h>
 #include <asm/asm-offsets.h>
 #include <asm/text-patching.h>
@@ -220,7 +220,7 @@ static int __init ftrace_plt_init(void)
 {
 	const char *start, *end;
 
-	ftrace_plt = module_alloc(PAGE_SIZE);
+	ftrace_plt = jit_text_alloc(PAGE_SIZE);
 	if (!ftrace_plt)
 		panic("cannot allocate ftrace plt\n");
 
diff --git a/arch/s390/kernel/kprobes.c b/arch/s390/kernel/kprobes.c
index d4b863ed0aa7..3804945f212f 100644
--- a/arch/s390/kernel/kprobes.c
+++ b/arch/s390/kernel/kprobes.c
@@ -9,7 +9,6 @@
 
 #define pr_fmt(fmt) "kprobes: " fmt
 
-#include <linux/moduleloader.h>
 #include <linux/kprobes.h>
 #include <linux/ptrace.h>
 #include <linux/preempt.h>
@@ -21,6 +20,7 @@
 #include <linux/slab.h>
 #include <linux/hardirq.h>
 #include <linux/ftrace.h>
+#include <linux/jitalloc.h>
 #include <asm/set_memory.h>
 #include <asm/sections.h>
 #include <asm/dis.h>
@@ -38,7 +38,7 @@ void *alloc_insn_page(void)
 {
 	void *page;
 
-	page = module_alloc(PAGE_SIZE);
+	page = jit_text_alloc(PAGE_SIZE);
 	if (!page)
 		return NULL;
 	set_memory_rox((unsigned long)page, 1);
diff --git a/arch/s390/kernel/module.c b/arch/s390/kernel/module.c
index f1b35dcdf3eb..d4844cfe3d7e 100644
--- a/arch/s390/kernel/module.c
+++ b/arch/s390/kernel/module.c
@@ -21,6 +21,7 @@
 #include <linux/moduleloader.h>
 #include <linux/bug.h>
 #include <linux/memory.h>
+#include <linux/jitalloc.h>
 #include <asm/alternative.h>
 #include <asm/nospec-branch.h>
 #include <asm/facility.h>
@@ -76,7 +77,7 @@ void *module_alloc(unsigned long size)
 #ifdef CONFIG_FUNCTION_TRACER
 void module_arch_cleanup(struct module *mod)
 {
-	module_memfree(mod->arch.trampolines_start);
+	jit_free(mod->arch.trampolines_start);
 }
 #endif
 
@@ -509,7 +510,7 @@ static int module_alloc_ftrace_hotpatch_trampolines(struct module *me,
 
 	size = FTRACE_HOTPATCH_TRAMPOLINES_SIZE(s->sh_size);
 	numpages = DIV_ROUND_UP(size, PAGE_SIZE);
-	start = module_alloc(numpages * PAGE_SIZE);
+	start = jit_text_alloc(numpages * PAGE_SIZE);
 	if (!start)
 		return -ENOMEM;
 	set_memory_rox((unsigned long)start, numpages);
diff --git a/arch/sparc/net/bpf_jit_comp_32.c b/arch/sparc/net/bpf_jit_comp_32.c
index a74e5004c6c8..068be1097d1a 100644
--- a/arch/sparc/net/bpf_jit_comp_32.c
+++ b/arch/sparc/net/bpf_jit_comp_32.c
@@ -1,10 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0
-#include <linux/moduleloader.h>
 #include <linux/workqueue.h>
 #include <linux/netdevice.h>
 #include <linux/filter.h>
 #include <linux/cache.h>
 #include <linux/if_vlan.h>
+#include <linux/jitalloc.h>
 
 #include <asm/cacheflush.h>
 #include <asm/ptrace.h>
@@ -713,7 +713,7 @@ cond_branch:			f_offset = addrs[i + filter[i].jf];
 				if (unlikely(proglen + ilen > oldproglen)) {
 					pr_err("bpb_jit_compile fatal error\n");
 					kfree(addrs);
-					module_memfree(image);
+					jit_free(image);
 					return;
 				}
 				memcpy(image + proglen, temp, ilen);
@@ -736,7 +736,7 @@ cond_branch:			f_offset = addrs[i + filter[i].jf];
 			break;
 		}
 		if (proglen == oldproglen) {
-			image = module_alloc(proglen);
+			image = jit_text_alloc(proglen);
 			if (!image)
 				goto out;
 		}
@@ -758,7 +758,7 @@ cond_branch:			f_offset = addrs[i + filter[i].jf];
 void bpf_jit_free(struct bpf_prog *fp)
 {
 	if (fp->jited)
-		module_memfree(fp->bpf_func);
+		jit_free(fp->bpf_func);
 
 	bpf_prog_unlock_free(fp);
 }
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 5e7ead52cfdb..157c8a799704 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -25,6 +25,7 @@
 #include <linux/memory.h>
 #include <linux/vmalloc.h>
 #include <linux/set_memory.h>
+#include <linux/jitalloc.h>
 
 #include <trace/syscall.h>
 
@@ -261,15 +262,14 @@ void arch_ftrace_update_code(int command)
 #ifdef CONFIG_X86_64
 
 #ifdef CONFIG_MODULES
-#include <linux/moduleloader.h>
 /* Module allocation simplifies allocating memory for code */
 static inline void *alloc_tramp(unsigned long size)
 {
-	return module_alloc(size);
+	return jit_text_alloc(size);
 }
 static inline void tramp_free(void *tramp)
 {
-	module_memfree(tramp);
+	jit_free(tramp);
 }
 #else
 /* Trampolines can only be created if modules are supported */
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index f7f6042eb7e6..48bbf97de5a0 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -40,11 +40,11 @@
 #include <linux/kgdb.h>
 #include <linux/ftrace.h>
 #include <linux/kasan.h>
-#include <linux/moduleloader.h>
 #include <linux/objtool.h>
 #include <linux/vmalloc.h>
 #include <linux/pgtable.h>
 #include <linux/set_memory.h>
+#include <linux/jitalloc.h>
 
 #include <asm/text-patching.h>
 #include <asm/cacheflush.h>
@@ -414,7 +414,7 @@ void *alloc_insn_page(void)
 {
 	void *page;
 
-	page = module_alloc(PAGE_SIZE);
+	page = jit_text_alloc(PAGE_SIZE);
 	if (!page)
 		return NULL;
 
diff --git a/include/linux/jitalloc.h b/include/linux/jitalloc.h
new file mode 100644
index 000000000000..9517e64e474d
--- /dev/null
+++ b/include/linux/jitalloc.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_JITALLOC_H
+#define _LINUX_JITALLOC_H
+
+#include <linux/types.h>
+
+void jit_free(void *buf);
+void *jit_text_alloc(size_t len);
+
+#endif /* _LINUX_JITALLOC_H */
diff --git a/include/linux/moduleloader.h b/include/linux/moduleloader.h
index 03be088fb439..b3374342f7af 100644
--- a/include/linux/moduleloader.h
+++ b/include/linux/moduleloader.h
@@ -29,9 +29,6 @@ unsigned int arch_mod_section_prepend(struct module *mod, unsigned int section);
    sections.  Returns NULL on failure. */
 void *module_alloc(unsigned long size);
 
-/* Free memory returned from module_alloc. */
-void module_memfree(void *module_region);
-
 /* Determines if the section name is an init section (that is only used during
  * module loading).
  */
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 7421487422d4..bf954d2721c1 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -22,7 +22,6 @@
 #include <linux/skbuff.h>
 #include <linux/vmalloc.h>
 #include <linux/random.h>
-#include <linux/moduleloader.h>
 #include <linux/bpf.h>
 #include <linux/btf.h>
 #include <linux/objtool.h>
@@ -37,6 +36,7 @@
 #include <linux/nospec.h>
 #include <linux/bpf_mem_alloc.h>
 #include <linux/memcontrol.h>
+#include <linux/jitalloc.h>
 
 #include <asm/barrier.h>
 #include <asm/unaligned.h>
@@ -860,7 +860,7 @@ static struct bpf_prog_pack *alloc_new_pack(bpf_jit_fill_hole_t bpf_fill_ill_ins
 		       GFP_KERNEL);
 	if (!pack)
 		return NULL;
-	pack->ptr = module_alloc(BPF_PROG_PACK_SIZE);
+	pack->ptr = jit_text_alloc(BPF_PROG_PACK_SIZE);
 	if (!pack->ptr) {
 		kfree(pack);
 		return NULL;
@@ -884,7 +884,7 @@ void *bpf_prog_pack_alloc(u32 size, bpf_jit_fill_hole_t bpf_fill_ill_insns)
 	mutex_lock(&pack_mutex);
 	if (size > BPF_PROG_PACK_SIZE) {
 		size = round_up(size, PAGE_SIZE);
-		ptr = module_alloc(size);
+		ptr = jit_text_alloc(size);
 		if (ptr) {
 			bpf_fill_ill_insns(ptr, size);
 			set_vm_flush_reset_perms(ptr);
@@ -922,7 +922,7 @@ void bpf_prog_pack_free(struct bpf_binary_header *hdr)
 
 	mutex_lock(&pack_mutex);
 	if (hdr->size > BPF_PROG_PACK_SIZE) {
-		module_memfree(hdr);
+		jit_free(hdr);
 		goto out;
 	}
 
@@ -946,7 +946,7 @@ void bpf_prog_pack_free(struct bpf_binary_header *hdr)
 	if (bitmap_find_next_zero_area(pack->bitmap, BPF_PROG_CHUNK_COUNT, 0,
 				       BPF_PROG_CHUNK_COUNT, 0) == 0) {
 		list_del(&pack->list);
-		module_memfree(pack->ptr);
+		jit_free(pack->ptr);
 		kfree(pack);
 	}
 out:
@@ -997,12 +997,12 @@ void bpf_jit_uncharge_modmem(u32 size)
 
 void *__weak bpf_jit_alloc_exec(unsigned long size)
 {
-	return module_alloc(size);
+	return jit_text_alloc(size);
 }
 
 void __weak bpf_jit_free_exec(void *addr)
 {
-	module_memfree(addr);
+	jit_free(addr);
 }
 
 struct bpf_binary_header *
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 00e177de91cc..3caf3561c048 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -26,7 +26,6 @@
 #include <linux/slab.h>
 #include <linux/stddef.h>
 #include <linux/export.h>
-#include <linux/moduleloader.h>
 #include <linux/kallsyms.h>
 #include <linux/freezer.h>
 #include <linux/seq_file.h>
@@ -39,6 +38,7 @@
 #include <linux/jump_label.h>
 #include <linux/static_call.h>
 #include <linux/perf_event.h>
+#include <linux/jitalloc.h>
 
 #include <asm/sections.h>
 #include <asm/cacheflush.h>
@@ -113,17 +113,17 @@ enum kprobe_slot_state {
 void __weak *alloc_insn_page(void)
 {
 	/*
-	 * Use module_alloc() so this page is within +/- 2GB of where the
+	 * Use jit_text_alloc() so this page is within +/- 2GB of where the
 	 * kernel image and loaded module images reside. This is required
 	 * for most of the architectures.
 	 * (e.g. x86-64 needs this to handle the %rip-relative fixups.)
 	 */
-	return module_alloc(PAGE_SIZE);
+	return jit_text_alloc(PAGE_SIZE);
 }
 
 static void free_insn_page(void *page)
 {
-	module_memfree(page);
+	jit_free(page);
 }
 
 struct kprobe_insn_cache kprobe_insn_slots = {
diff --git a/kernel/module/Kconfig b/kernel/module/Kconfig
index 33a2e991f608..a228b6aafc8f 100644
--- a/kernel/module/Kconfig
+++ b/kernel/module/Kconfig
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 menuconfig MODULES
 	bool "Enable loadable module support"
+	select JIT_ALLOC
 	modules
 	help
 	  Kernel modules are small pieces of compiled code which can
diff --git a/kernel/module/main.c b/kernel/module/main.c
index 044aa2c9e3cb..51278c571bcb 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -57,6 +57,7 @@
 #include <linux/audit.h>
 #include <linux/cfi.h>
 #include <linux/debugfs.h>
+#include <linux/jitalloc.h>
 #include <uapi/linux/module.h>
 #include "internal.h"
 
@@ -1186,16 +1187,6 @@ resolve_symbol_wait(struct module *mod,
 	return ksym;
 }
 
-void __weak module_memfree(void *module_region)
-{
-	/*
-	 * This memory may be RO, and freeing RO memory in an interrupt is not
-	 * supported by vmalloc.
-	 */
-	WARN_ON(in_interrupt());
-	vfree(module_region);
-}
-
 void __weak module_arch_cleanup(struct module *mod)
 {
 }
@@ -1214,7 +1205,7 @@ static void *module_memory_alloc(unsigned int size, enum mod_mem_type type)
 {
 	if (mod_mem_use_vmalloc(type))
 		return vzalloc(size);
-	return module_alloc(size);
+	return jit_text_alloc(size);
 }
 
 static void module_memory_free(void *ptr, enum mod_mem_type type)
@@ -1222,7 +1213,7 @@ static void module_memory_free(void *ptr, enum mod_mem_type type)
 	if (mod_mem_use_vmalloc(type))
 		vfree(ptr);
 	else
-		module_memfree(ptr);
+		jit_free(ptr);
 }
 
 static void free_mod_mem(struct module *mod)
@@ -2478,9 +2469,9 @@ static void do_free_init(struct work_struct *w)
 
 	llist_for_each_safe(pos, n, list) {
 		initfree = container_of(pos, struct mod_initfree, node);
-		module_memfree(initfree->init_text);
-		module_memfree(initfree->init_data);
-		module_memfree(initfree->init_rodata);
+		jit_free(initfree->init_text);
+		jit_free(initfree->init_data);
+		jit_free(initfree->init_rodata);
 		kfree(initfree);
 	}
 }
@@ -2583,7 +2574,7 @@ static noinline int do_init_module(struct module *mod)
 	 * We want to free module_init, but be aware that kallsyms may be
 	 * walking this with preempt disabled.  In all the failure paths, we
 	 * call synchronize_rcu(), but we don't want to slow down the success
-	 * path. module_memfree() cannot be called in an interrupt, so do the
+	 * path. jit_free() cannot be called in an interrupt, so do the
 	 * work and call synchronize_rcu() in a work queue.
 	 *
 	 * Note that module_alloc() on most architectures creates W+X page
diff --git a/mm/Kconfig b/mm/Kconfig
index 7672a22647b4..2dea61dade13 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1206,6 +1206,9 @@ config PER_VMA_LOCK
 	  This feature allows locking each virtual memory area separately when
 	  handling page faults instead of taking mmap_lock.
 
+config JIT_ALLOC
+       bool
+
 source "mm/damon/Kconfig"
 
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index e29afc890cde..18d45cd60a11 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -137,3 +137,4 @@ obj-$(CONFIG_IO_MAPPING) += io-mapping.o
 obj-$(CONFIG_HAVE_BOOTMEM_INFO_NODE) += bootmem_info.o
 obj-$(CONFIG_GENERIC_IOREMAP) += ioremap.o
 obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
+obj-$(CONFIG_JIT_ALLOC) +=  jitalloc.o
diff --git a/mm/jitalloc.c b/mm/jitalloc.c
new file mode 100644
index 000000000000..f15262202a1a
--- /dev/null
+++ b/mm/jitalloc.c
@@ -0,0 +1,20 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/moduleloader.h>
+#include <linux/vmalloc.h>
+#include <linux/jitalloc.h>
+
+void jit_free(void *buf)
+{
+	/*
+	 * This memory may be RO, and freeing RO memory in an interrupt is not
+	 * supported by vmalloc.
+	 */
+	WARN_ON(in_interrupt());
+	vfree(buf);
+}
+
+void *jit_text_alloc(size_t len)
+{
+	return module_alloc(len);
+}
-- 
2.35.1


