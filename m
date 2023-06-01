Return-Path: <netdev+bounces-7060-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9528A719912
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 12:17:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE60B1C20F34
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 10:17:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62B51206AD;
	Thu,  1 Jun 2023 10:14:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228F231EFD;
	Thu,  1 Jun 2023 10:14:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75981C433AA;
	Thu,  1 Jun 2023 10:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685614468;
	bh=K7wvO7ElwhoAy7Oh2IpfLgKs2YHT7c7jqjInBLBuDTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fRH3Dr0wJXXqyiX4DpPIKcmgXGzVC4gxNGWC6LITX/cuu1fgtqI+DGd/9maCsR1YG
	 n02Pkrgsj/Vf+omfNPMLkDIo5AN0DpSJtbXnHd8HZYRidz4tixxp+zVAey7pSOXiL2
	 cko5pQEh79FuGCFjyg1UUYvNTHWmqFfd0GoIcCkM0Zc2qiZnUklG6CFkw/wVmFZbjc
	 SNrDkttPHy4gt7c/8IG464jkTRJMmL6XvHlOQ637slnEy6SnCyf+T1hQ+VMOoEny+t
	 HOm3wN3FqH/AR42jxZ+6LMUF0Xt0ozqmMyjhXT2Z8ufKOXgnAqLmo+fVYAvP698VE6
	 fxfx5BUrh+Gtw==
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
Subject: [PATCH 08/13] arch: make jitalloc setup available regardless of CONFIG_MODULES
Date: Thu,  1 Jun 2023 13:12:52 +0300
Message-Id: <20230601101257.530867-9-rppt@kernel.org>
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

jitalloc does not depend on modules, on the contrary modules use
jitalloc.

To make jitalloc available when CONFIG_MODULES=n, for instance for
kprobes, split jit_alloc_params initialization out from
arch/kernel/module.c and compile it when CONFIG_JIT_ALLOC=y

Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
---
 arch/arm/kernel/module.c       | 32 --------------------------
 arch/arm/mm/init.c             | 35 ++++++++++++++++++++++++++++
 arch/arm64/kernel/module.c     | 40 --------------------------------
 arch/arm64/mm/init.c           | 42 ++++++++++++++++++++++++++++++++++
 arch/loongarch/kernel/module.c | 14 ------------
 arch/loongarch/mm/init.c       | 16 +++++++++++++
 arch/mips/kernel/module.c      | 17 --------------
 arch/mips/mm/init.c            | 19 +++++++++++++++
 arch/parisc/kernel/module.c    | 17 --------------
 arch/parisc/mm/init.c          | 21 ++++++++++++++++-
 arch/powerpc/kernel/module.c   | 39 -------------------------------
 arch/powerpc/mm/mem.c          | 41 +++++++++++++++++++++++++++++++++
 arch/riscv/kernel/module.c     | 16 -------------
 arch/riscv/mm/init.c           | 18 +++++++++++++++
 arch/s390/kernel/module.c      | 32 --------------------------
 arch/s390/mm/init.c            | 35 ++++++++++++++++++++++++++++
 arch/sparc/kernel/module.c     | 19 ---------------
 arch/sparc/mm/Makefile         |  2 ++
 arch/sparc/mm/jitalloc.c       | 21 +++++++++++++++++
 19 files changed, 249 insertions(+), 227 deletions(-)
 create mode 100644 arch/sparc/mm/jitalloc.c

diff --git a/arch/arm/kernel/module.c b/arch/arm/kernel/module.c
index 83ccbf98164f..054e799e7091 100644
--- a/arch/arm/kernel/module.c
+++ b/arch/arm/kernel/module.c
@@ -16,44 +16,12 @@
 #include <linux/fs.h>
 #include <linux/string.h>
 #include <linux/gfp.h>
-#include <linux/jitalloc.h>
 
 #include <asm/sections.h>
 #include <asm/smp_plat.h>
 #include <asm/unwind.h>
 #include <asm/opcodes.h>
 
-#ifdef CONFIG_XIP_KERNEL
-/*
- * The XIP kernel text is mapped in the module area for modules and
- * some other stuff to work without any indirect relocations.
- * MODULES_VADDR is redefined here and not in asm/memory.h to avoid
- * recompiling the whole kernel when CONFIG_XIP_KERNEL is turned on/off.
- */
-#undef MODULES_VADDR
-#define MODULES_VADDR	(((unsigned long)_exiprom + ~PMD_MASK) & PMD_MASK)
-#endif
-
-#ifdef CONFIG_MMU
-static struct jit_alloc_params jit_alloc_params = {
-	.alignment	= 1,
-	.text.start	= MODULES_VADDR,
-	.text.end	= MODULES_END,
-};
-
-struct jit_alloc_params *jit_alloc_arch_params(void)
-{
-	jit_alloc_params.text.pgprot = PAGE_KERNEL_EXEC;
-
-	if (IS_ENABLED(CONFIG_ARM_MODULE_PLTS)) {
-		jit_alloc_params.text.fallback_start = VMALLOC_START;
-		jit_alloc_params.text.fallback_end = VMALLOC_END;
-	}
-
-	return &jit_alloc_params;
-}
-#endif
-
 bool module_init_section(const char *name)
 {
 	return strstarts(name, ".init") ||
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index ce64bdb55a16..e492625b7f3d 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -22,6 +22,7 @@
 #include <linux/sizes.h>
 #include <linux/stop_machine.h>
 #include <linux/swiotlb.h>
+#include <linux/jitalloc.h>
 
 #include <asm/cp15.h>
 #include <asm/mach-types.h>
@@ -486,3 +487,37 @@ void free_initrd_mem(unsigned long start, unsigned long end)
 	free_reserved_area((void *)start, (void *)end, -1, "initrd");
 }
 #endif
+
+#ifdef CONFIG_JIT_ALLOC
+#ifdef CONFIG_XIP_KERNEL
+/*
+ * The XIP kernel text is mapped in the module area for modules and
+ * some other stuff to work without any indirect relocations.
+ * MODULES_VADDR is redefined here and not in asm/memory.h to avoid
+ * recompiling the whole kernel when CONFIG_XIP_KERNEL is turned on/off.
+ */
+#undef MODULES_VADDR
+#define MODULES_VADDR	(((unsigned long)_exiprom + ~PMD_MASK) & PMD_MASK)
+#endif
+
+#ifdef CONFIG_MMU
+static struct jit_alloc_params jit_alloc_params = {
+	.alignment	= 1,
+	.text.start	= MODULES_VADDR,
+	.text.end	= MODULES_END,
+};
+
+struct jit_alloc_params *jit_alloc_arch_params(void)
+{
+	jit_alloc_params.text.pgprot = PAGE_KERNEL_EXEC;
+
+	if (IS_ENABLED(CONFIG_ARM_MODULE_PLTS)) {
+		jit_alloc_params.text.fallback_start = VMALLOC_START;
+		jit_alloc_params.text.fallback_end = VMALLOC_END;
+	}
+
+	return &jit_alloc_params;
+}
+#endif
+
+#endif /* CONFIG_JIT_ALLOC */
diff --git a/arch/arm64/kernel/module.c b/arch/arm64/kernel/module.c
index 91ffcff5a44c..6d09b29fe9db 100644
--- a/arch/arm64/kernel/module.c
+++ b/arch/arm64/kernel/module.c
@@ -17,51 +17,11 @@
 #include <linux/moduleloader.h>
 #include <linux/scs.h>
 #include <linux/vmalloc.h>
-#include <linux/jitalloc.h>
 #include <asm/alternative.h>
 #include <asm/insn.h>
 #include <asm/scs.h>
 #include <asm/sections.h>
 
-static struct jit_alloc_params jit_alloc_params = {
-	.alignment	= JIT_ALLOC_ALIGN,
-	.flags		= JIT_ALLOC_KASAN_SHADOW,
-};
-
-struct jit_alloc_params *jit_alloc_arch_params(void)
-{
-	u64 module_alloc_end = module_alloc_base + MODULES_VSIZE;
-
-	if (IS_ENABLED(CONFIG_KASAN_GENERIC) ||
-	    IS_ENABLED(CONFIG_KASAN_SW_TAGS))
-		/* don't exceed the static module region - see below */
-		module_alloc_end = MODULES_END;
-
-	jit_alloc_params.text.pgprot = PAGE_KERNEL;
-	jit_alloc_params.text.start = module_alloc_base;
-	jit_alloc_params.text.end = module_alloc_end;
-
-	/*
-	 * KASAN without KASAN_VMALLOC can only deal with module
-	 * allocations being served from the reserved module region,
-	 * since the remainder of the vmalloc region is already
-	 * backed by zero shadow pages, and punching holes into it
-	 * is non-trivial. Since the module region is not randomized
-	 * when KASAN is enabled without KASAN_VMALLOC, it is even
-	 * less likely that the module region gets exhausted, so we
-	 * can simply omit this fallback in that case.
-	 */
-	if (IS_ENABLED(CONFIG_ARM64_MODULE_PLTS) &&
-	    (IS_ENABLED(CONFIG_KASAN_VMALLOC) ||
-	     (!IS_ENABLED(CONFIG_KASAN_GENERIC) &&
-	      !IS_ENABLED(CONFIG_KASAN_SW_TAGS)))) {
-		jit_alloc_params.text.fallback_start = module_alloc_base;
-		jit_alloc_params.text.fallback_end = module_alloc_base + SZ_2G;
-	}
-
-	return &jit_alloc_params;
-}
-
 enum aarch64_reloc_op {
 	RELOC_OP_NONE,
 	RELOC_OP_ABS,
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 66e70ca47680..a4463a35b3c5 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -31,6 +31,7 @@
 #include <linux/hugetlb.h>
 #include <linux/acpi_iort.h>
 #include <linux/kmemleak.h>
+#include <linux/jitalloc.h>
 
 #include <asm/boot.h>
 #include <asm/fixmap.h>
@@ -493,3 +494,44 @@ void dump_mem_limit(void)
 		pr_emerg("Memory Limit: none\n");
 	}
 }
+
+#ifdef CONFIG_JIT_ALLOC
+static struct jit_alloc_params jit_alloc_params = {
+	.alignment	= JIT_ALLOC_ALIGN,
+	.flags		= JIT_ALLOC_KASAN_SHADOW,
+};
+
+struct jit_alloc_params *jit_alloc_arch_params(void)
+{
+	u64 module_alloc_end = module_alloc_base + MODULES_VSIZE;
+
+	if (IS_ENABLED(CONFIG_KASAN_GENERIC) ||
+	    IS_ENABLED(CONFIG_KASAN_SW_TAGS))
+		/* don't exceed the static module region - see below */
+		module_alloc_end = MODULES_END;
+
+	jit_alloc_params.text.pgprot = PAGE_KERNEL;
+	jit_alloc_params.text.start = module_alloc_base;
+	jit_alloc_params.text.end = module_alloc_end;
+
+	/*
+	 * KASAN without KASAN_VMALLOC can only deal with module
+	 * allocations being served from the reserved module region,
+	 * since the remainder of the vmalloc region is already
+	 * backed by zero shadow pages, and punching holes into it
+	 * is non-trivial. Since the module region is not randomized
+	 * when KASAN is enabled without KASAN_VMALLOC, it is even
+	 * less likely that the module region gets exhausted, so we
+	 * can simply omit this fallback in that case.
+	 */
+	if (IS_ENABLED(CONFIG_ARM64_MODULE_PLTS) &&
+	    (IS_ENABLED(CONFIG_KASAN_VMALLOC) ||
+	     (!IS_ENABLED(CONFIG_KASAN_GENERIC) &&
+	      !IS_ENABLED(CONFIG_KASAN_SW_TAGS)))) {
+		jit_alloc_params.text.fallback_start = module_alloc_base;
+		jit_alloc_params.text.fallback_end = module_alloc_base + SZ_2G;
+	}
+
+	return &jit_alloc_params;
+}
+#endif
diff --git a/arch/loongarch/kernel/module.c b/arch/loongarch/kernel/module.c
index 1d5e00874ae7..181b5f8b09f1 100644
--- a/arch/loongarch/kernel/module.c
+++ b/arch/loongarch/kernel/module.c
@@ -18,7 +18,6 @@
 #include <linux/ftrace.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
-#include <linux/jitalloc.h>
 #include <asm/alternative.h>
 #include <asm/inst.h>
 
@@ -470,19 +469,6 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
 	return 0;
 }
 
-static struct jit_alloc_params jit_alloc_params = {
-	.alignment	= 1,
-	.text.pgprot	= PAGE_KERNEL,
-};
-
-struct jit_alloc_params *jit_alloc_arch_params(void)
-{
-	jit_alloc_params.text.start = MODULES_VADDR;
-	jit_alloc_params.text.end = MODULES_END;
-
-	return &jit_alloc_params;
-}
-
 static void module_init_ftrace_plt(const Elf_Ehdr *hdr,
 				   const Elf_Shdr *sechdrs, struct module *mod)
 {
diff --git a/arch/loongarch/mm/init.c b/arch/loongarch/mm/init.c
index 3b7d8129570b..30ca8e497377 100644
--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -24,6 +24,7 @@
 #include <linux/gfp.h>
 #include <linux/hugetlb.h>
 #include <linux/mmzone.h>
+#include <linux/jitalloc.h>
 
 #include <asm/asm-offsets.h>
 #include <asm/bootinfo.h>
@@ -274,3 +275,18 @@ EXPORT_SYMBOL(invalid_pmd_table);
 #endif
 pte_t invalid_pte_table[PTRS_PER_PTE] __page_aligned_bss;
 EXPORT_SYMBOL(invalid_pte_table);
+
+#ifdef CONFIG_JIT_ALLOC
+static struct jit_alloc_params jit_alloc_params = {
+	.alignment	= 1,
+	.text.pgprot	= PAGE_KERNEL,
+};
+
+struct jit_alloc_params *jit_alloc_arch_params(void)
+{
+	jit_alloc_params.text.start = MODULES_VADDR;
+	jit_alloc_params.text.end = MODULES_END;
+
+	return &jit_alloc_params;
+}
+#endif
diff --git a/arch/mips/kernel/module.c b/arch/mips/kernel/module.c
index f762c697ab9c..dba78c7a4a88 100644
--- a/arch/mips/kernel/module.c
+++ b/arch/mips/kernel/module.c
@@ -20,7 +20,6 @@
 #include <linux/kernel.h>
 #include <linux/spinlock.h>
 #include <linux/jump_label.h>
-#include <linux/jitalloc.h>
 
 extern void jump_label_apply_nops(struct module *mod);
 
@@ -33,22 +32,6 @@ struct mips_hi16 {
 static LIST_HEAD(dbe_list);
 static DEFINE_SPINLOCK(dbe_lock);
 
-#ifdef MODULE_START
-
-static struct jit_alloc_params jit_alloc_params = {
-	.alignment	= 1,
-	.text.start	= MODULE_START,
-	.text.end	= MODULE_END,
-};
-
-struct jit_alloc_params *jit_alloc_arch_params(void)
-{
-	jit_alloc_params.text.pgprot = PAGE_KERNEL;
-
-	return &jit_alloc_params;
-}
-#endif
-
 static void apply_r_mips_32(u32 *location, u32 base, Elf_Addr v)
 {
 	*location = base + v;
diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
index 5a8002839550..1fd1bea78fdc 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -31,6 +31,7 @@
 #include <linux/gfp.h>
 #include <linux/kcore.h>
 #include <linux/initrd.h>
+#include <linux/jitalloc.h>
 
 #include <asm/bootinfo.h>
 #include <asm/cachectl.h>
@@ -568,3 +569,21 @@ EXPORT_SYMBOL_GPL(invalid_pmd_table);
 #endif
 pte_t invalid_pte_table[PTRS_PER_PTE] __page_aligned_bss;
 EXPORT_SYMBOL(invalid_pte_table);
+
+#ifdef CONFIG_JIT_ALLOC
+#ifdef MODULE_START
+
+static struct jit_alloc_params jit_alloc_params = {
+	.alignment	= 1,
+	.text.start	= MODULE_START,
+	.text.end	= MODULE_END,
+};
+
+struct jit_alloc_params *jit_alloc_arch_params(void)
+{
+	jit_alloc_params.text.pgprot = PAGE_KERNEL;
+
+	return &jit_alloc_params;
+}
+#endif
+#endif
diff --git a/arch/parisc/kernel/module.c b/arch/parisc/kernel/module.c
index 49fdf741fd24..3cb0b2c72d85 100644
--- a/arch/parisc/kernel/module.c
+++ b/arch/parisc/kernel/module.c
@@ -49,7 +49,6 @@
 #include <linux/bug.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
-#include <linux/jitalloc.h>
 
 #include <asm/unwind.h>
 #include <asm/sections.h>
@@ -174,22 +173,6 @@ static inline int reassemble_22(int as22)
 		((as22 & 0x0003ff) << 3));
 }
 
-static struct jit_alloc_params jit_alloc_params = {
-	.alignment	= 1,
-	/* using RWX means less protection for modules, but it's
-	 * easier than trying to map the text, data, init_text and
-	 * init_data correctly */
-	.text.pgprot	= PAGE_KERNEL_RWX,
-	.text.end	= VMALLOC_END,
-};
-
-struct jit_alloc_params *jit_alloc_arch_params(void)
-{
-	jit_alloc_params.text.start = VMALLOC_START;
-
-	return &jit_alloc_params;
-}
-
 #ifndef CONFIG_64BIT
 static inline unsigned long count_gots(const Elf_Rela *rela, unsigned long n)
 {
diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
index b0c43f3b0a5f..1601519486fa 100644
--- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -24,6 +24,7 @@
 #include <linux/nodemask.h>	/* for node_online_map */
 #include <linux/pagemap.h>	/* for release_pages */
 #include <linux/compat.h>
+#include <linux/jitalloc.h>
 
 #include <asm/pgalloc.h>
 #include <asm/tlb.h>
@@ -479,7 +480,7 @@ void free_initmem(void)
 	/* finally dump all the instructions which were cached, since the
 	 * pages are no-longer executable */
 	flush_icache_range(init_begin, init_end);
-	
+
 	free_initmem_default(POISON_FREE_INITMEM);
 
 	/* set up a new led state on systems shipped LED State panel */
@@ -891,3 +892,21 @@ static const pgprot_t protection_map[16] = {
 	[VM_SHARED | VM_EXEC | VM_WRITE | VM_READ]	= PAGE_RWX
 };
 DECLARE_VM_GET_PAGE_PROT
+
+#ifdef CONFIG_JIT_ALLOC
+static struct jit_alloc_params jit_alloc_params = {
+	.alignment	= 1,
+	/* using RWX means less protection for modules, but it's
+	 * easier than trying to map the text, data, init_text and
+	 * init_data correctly */
+	.text.pgprot	= PAGE_KERNEL_RWX,
+	.text.end	= VMALLOC_END,
+};
+
+struct jit_alloc_params *jit_alloc_arch_params(void)
+{
+	jit_alloc_params.text.start = VMALLOC_START;
+
+	return &jit_alloc_params;
+}
+#endif
diff --git a/arch/powerpc/kernel/module.c b/arch/powerpc/kernel/module.c
index b58af61e90c0..b30e00964a60 100644
--- a/arch/powerpc/kernel/module.c
+++ b/arch/powerpc/kernel/module.c
@@ -12,7 +12,6 @@
 #include <linux/bug.h>
 #include <asm/module.h>
 #include <linux/uaccess.h>
-#include <linux/jitalloc.h>
 #include <asm/firmware.h>
 #include <linux/sort.h>
 #include <asm/setup.h>
@@ -89,41 +88,3 @@ int module_finalize(const Elf_Ehdr *hdr,
 
 	return 0;
 }
-
-static struct jit_alloc_params jit_alloc_params = {
-	.alignment	= 1,
-};
-
-struct jit_alloc_params *jit_alloc_arch_params(void)
-{
-	/*
-	 * BOOK3S_32 and 8xx define MODULES_VADDR for text allocations and
-	 * allow allocating data in the entire vmalloc space
-	 */
-#ifdef MODULES_VADDR
-	pgprot_t prot = strict_module_rwx_enabled() ? PAGE_KERNEL : PAGE_KERNEL_EXEC;
-	unsigned long limit = (unsigned long)_etext - SZ_32M;
-
-	jit_alloc_params.text.pgprot = prot;
-
-	/* First try within 32M limit from _etext to avoid branch trampolines */
-	if (MODULES_VADDR < PAGE_OFFSET && MODULES_END > limit) {
-		jit_alloc_params.text.start = limit;
-		jit_alloc_params.text.end = MODULES_END;
-		jit_alloc_params.text.fallback_start = MODULES_VADDR;
-		jit_alloc_params.text.fallback_end = MODULES_END;
-	} else {
-		jit_alloc_params.text.start = MODULES_VADDR;
-		jit_alloc_params.text.end = MODULES_END;
-	}
-
-	jit_alloc_params.data.pgprot	= PAGE_KERNEL;
-	jit_alloc_params.data.start	= VMALLOC_START;
-	jit_alloc_params.data.end	= VMALLOC_END;
-#else
-	jit_alloc_params.text.start = VMALLOC_START;
-	jit_alloc_params.text.end = VMALLOC_END;
-#endif
-
-	return &jit_alloc_params;
-}
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 8b121df7b08f..de970988119f 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -16,6 +16,7 @@
 #include <linux/highmem.h>
 #include <linux/suspend.h>
 #include <linux/dma-direct.h>
+#include <linux/jitalloc.h>
 
 #include <asm/swiotlb.h>
 #include <asm/machdep.h>
@@ -406,3 +407,43 @@ int devmem_is_allowed(unsigned long pfn)
  * the EHEA driver. Drop this when drivers/net/ethernet/ibm/ehea is removed.
  */
 EXPORT_SYMBOL_GPL(walk_system_ram_range);
+
+#ifdef CONFIG_JIT_ALLOC
+static struct jit_alloc_params jit_alloc_params = {
+	.alignment	= 1,
+};
+
+struct jit_alloc_params *jit_alloc_arch_params(void)
+{
+	/*
+	 * BOOK3S_32 and 8xx define MODULES_VADDR for text allocations and
+	 * allow allocating data in the entire vmalloc space
+	 */
+#ifdef MODULES_VADDR
+	pgprot_t prot = strict_module_rwx_enabled() ? PAGE_KERNEL : PAGE_KERNEL_EXEC;
+	unsigned long limit = (unsigned long)_etext - SZ_32M;
+
+	jit_alloc_params.text.pgprot = prot;
+
+	/* First try within 32M limit from _etext to avoid branch trampolines */
+	if (MODULES_VADDR < PAGE_OFFSET && MODULES_END > limit) {
+		jit_alloc_params.text.start = limit;
+		jit_alloc_params.text.end = MODULES_END;
+		jit_alloc_params.text.fallback_start = MODULES_VADDR;
+		jit_alloc_params.text.fallback_end = MODULES_END;
+	} else {
+		jit_alloc_params.text.start = MODULES_VADDR;
+		jit_alloc_params.text.end = MODULES_END;
+	}
+
+	jit_alloc_params.data.pgprot	= PAGE_KERNEL;
+	jit_alloc_params.data.start	= VMALLOC_START;
+	jit_alloc_params.data.end	= VMALLOC_END;
+#else
+	jit_alloc_params.text.start = VMALLOC_START;
+	jit_alloc_params.text.end = VMALLOC_END;
+#endif
+
+	return &jit_alloc_params;
+}
+#endif
diff --git a/arch/riscv/kernel/module.c b/arch/riscv/kernel/module.c
index 731255654c94..8af08d5449bf 100644
--- a/arch/riscv/kernel/module.c
+++ b/arch/riscv/kernel/module.c
@@ -11,7 +11,6 @@
 #include <linux/vmalloc.h>
 #include <linux/sizes.h>
 #include <linux/pgtable.h>
-#include <linux/jitalloc.h>
 #include <asm/alternative.h>
 #include <asm/sections.h>
 
@@ -436,21 +435,6 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
 	return 0;
 }
 
-#if defined(CONFIG_MMU) && defined(CONFIG_64BIT)
-static struct jit_alloc_params jit_alloc_params = {
-	.alignment	= 1,
-	.text.pgprot	= PAGE_KERNEL,
-};
-
-struct jit_alloc_params *jit_alloc_arch_params(void)
-{
-	jit_alloc_params.text.start = MODULES_VADDR;
-	jit_alloc_params.text.end = MODULES_END;
-
-	return &jit_alloc_params;
-}
-#endif
-
 int module_finalize(const Elf_Ehdr *hdr,
 		    const Elf_Shdr *sechdrs,
 		    struct module *me)
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 747e5b1ef02d..5b87f83ef810 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -23,6 +23,7 @@
 #ifdef CONFIG_RELOCATABLE
 #include <linux/elf.h>
 #endif
+#include <linux/jitalloc.h>
 
 #include <asm/fixmap.h>
 #include <asm/tlbflush.h>
@@ -1363,3 +1364,20 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 	return vmemmap_populate_basepages(start, end, node, NULL);
 }
 #endif
+
+#ifdef CONFIG_JIT_ALLOC
+#if defined(CONFIG_MMU) && defined(CONFIG_64BIT)
+static struct jit_alloc_params jit_alloc_params = {
+	.alignment	= 1,
+	.text.pgprot	= PAGE_KERNEL,
+};
+
+struct jit_alloc_params *jit_alloc_arch_params(void)
+{
+	jit_alloc_params.text.start = MODULES_VADDR;
+	jit_alloc_params.text.end = MODULES_END;
+
+	return &jit_alloc_params;
+}
+#endif
+#endif
diff --git a/arch/s390/kernel/module.c b/arch/s390/kernel/module.c
index 3f85cf1e7c4e..0a4f4f32ef49 100644
--- a/arch/s390/kernel/module.c
+++ b/arch/s390/kernel/module.c
@@ -37,38 +37,6 @@
 
 #define PLT_ENTRY_SIZE 22
 
-static unsigned long get_module_load_offset(void)
-{
-	static DEFINE_MUTEX(module_kaslr_mutex);
-	static unsigned long module_load_offset;
-
-	if (!kaslr_enabled())
-		return 0;
-	/*
-	 * Calculate the module_load_offset the first time this code
-	 * is called. Once calculated it stays the same until reboot.
-	 */
-	mutex_lock(&module_kaslr_mutex);
-	if (!module_load_offset)
-		module_load_offset = get_random_u32_inclusive(1, 1024) * PAGE_SIZE;
-	mutex_unlock(&module_kaslr_mutex);
-	return module_load_offset;
-}
-
-static struct jit_alloc_params jit_alloc_params = {
-	.alignment	= JIT_ALLOC_ALIGN,
-	.flags		= JIT_ALLOC_KASAN_SHADOW,
-	.text.pgprot	= PAGE_KERNEL,
-};
-
-struct jit_alloc_params *jit_alloc_arch_params(void)
-{
-	jit_alloc_params.text.start = MODULES_VADDR + get_module_load_offset();
-	jit_alloc_params.text.end = MODULES_END;
-
-	return &jit_alloc_params;
-}
-
 #ifdef CONFIG_FUNCTION_TRACER
 void module_arch_cleanup(struct module *mod)
 {
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index 8d94e29adcdb..6e428e0f3215 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -50,6 +50,7 @@
 #include <asm/uv.h>
 #include <linux/virtio_anchor.h>
 #include <linux/virtio_config.h>
+#include <linux/jitalloc.h>
 
 pgd_t swapper_pg_dir[PTRS_PER_PGD] __section(".bss..swapper_pg_dir");
 pgd_t invalid_pg_dir[PTRS_PER_PGD] __section(".bss..invalid_pg_dir");
@@ -311,3 +312,37 @@ void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
 	vmem_remove_mapping(start, size);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
+
+#ifdef CONFIG_JIT_ALLOC
+static unsigned long get_module_load_offset(void)
+{
+	static DEFINE_MUTEX(module_kaslr_mutex);
+	static unsigned long module_load_offset;
+
+	if (!kaslr_enabled())
+		return 0;
+	/*
+	 * Calculate the module_load_offset the first time this code
+	 * is called. Once calculated it stays the same until reboot.
+	 */
+	mutex_lock(&module_kaslr_mutex);
+	if (!module_load_offset)
+		module_load_offset = get_random_u32_inclusive(1, 1024) * PAGE_SIZE;
+	mutex_unlock(&module_kaslr_mutex);
+	return module_load_offset;
+}
+
+static struct jit_alloc_params jit_alloc_params = {
+	.alignment	= JIT_ALLOC_ALIGN,
+	.flags		= JIT_ALLOC_KASAN_SHADOW,
+	.text.pgprot	= PAGE_KERNEL,
+};
+
+struct jit_alloc_params *jit_alloc_arch_params(void)
+{
+	jit_alloc_params.text.start = MODULES_VADDR + get_module_load_offset();
+	jit_alloc_params.text.end = MODULES_END;
+
+	return &jit_alloc_params;
+}
+#endif
diff --git a/arch/sparc/kernel/module.c b/arch/sparc/kernel/module.c
index 03f0de693b4d..9edbd0372add 100644
--- a/arch/sparc/kernel/module.c
+++ b/arch/sparc/kernel/module.c
@@ -14,7 +14,6 @@
 #include <linux/string.h>
 #include <linux/ctype.h>
 #include <linux/mm.h>
-#include <linux/jitalloc.h>
 
 #ifdef CONFIG_SPARC64
 #include <linux/jump_label.h>
@@ -26,24 +25,6 @@
 
 #include "entry.h"
 
-static struct jit_alloc_params jit_alloc_params = {
-	.alignment	= 1,
-#ifdef CONFIG_SPARC64
-	.text.start	= MODULES_VADDR,
-	.text.end	= MODULES_END,
-#else
-	.text.start	= VMALLOC_START,
-	.text.end	= VMALLOC_END,
-#endif
-};
-
-struct jit_alloc_params *jit_alloc_arch_params(void)
-{
-	jit_alloc_params.text.pgprot = PAGE_KERNEL;
-
-	return &jit_alloc_params;
-}
-
 /* Make generic code ignore STT_REGISTER dummy undefined symbols.  */
 int module_frob_arch_sections(Elf_Ehdr *hdr,
 			      Elf_Shdr *sechdrs,
diff --git a/arch/sparc/mm/Makefile b/arch/sparc/mm/Makefile
index 871354aa3c00..95ede0fd851a 100644
--- a/arch/sparc/mm/Makefile
+++ b/arch/sparc/mm/Makefile
@@ -15,3 +15,5 @@ obj-$(CONFIG_SPARC32)   += leon_mm.o
 
 # Only used by sparc64
 obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpage.o
+
+obj-$(CONFIG_JIT_ALLOC) += jitalloc.o
diff --git a/arch/sparc/mm/jitalloc.c b/arch/sparc/mm/jitalloc.c
new file mode 100644
index 000000000000..6b407a8e85ef
--- /dev/null
+++ b/arch/sparc/mm/jitalloc.c
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/mm.h>
+#include <linux/jitalloc.h>
+
+static struct jit_alloc_params jit_alloc_params = {
+	.alignment	= 1,
+#ifdef CONFIG_SPARC64
+	.text.start	= MODULES_VADDR,
+	.text.end	= MODULES_END,
+#else
+	.text.start	= VMALLOC_START,
+	.text.end	= VMALLOC_END,
+#endif
+};
+
+struct jit_alloc_params *jit_alloc_arch_params(void)
+{
+	jit_alloc_params.text.pgprot = PAGE_KERNEL;
+
+	return &jit_alloc_params;
+}
-- 
2.35.1


