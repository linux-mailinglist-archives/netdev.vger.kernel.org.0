Return-Path: <netdev+bounces-11340-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 08512732AA1
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:56:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C30B1C20FD9
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 08:56:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 456FBC2FC;
	Fri, 16 Jun 2023 08:52:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0912517AD6;
	Fri, 16 Jun 2023 08:52:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719F5C433AB;
	Fri, 16 Jun 2023 08:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686905556;
	bh=E4MCbX8yPnTDkKJwtQr/rf4a5TEvdYJ6s+Zf6ypiamM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YnZOm1AxQLSndnLP4kA6ukJQ0Y7mq//jlolnZDXY1s0PD60ukzIO5G2md/3qE22w0
	 bL1xlNH+l0OJWW1bnSY06+H1l3L80j7T+e7ZFlslHmVSifqqOf5WpeX7My38TcamuZ
	 i/j9eGvr7hBgy4jeX5zWpJiZm0uggs1zpojNta4c57WV/UlR8KhIHzMtfn8e0vPzrJ
	 u4iH/BVMeLHIP7NGE+FrEOu+eAIL1FOe4dSN3BpZ0dUreNZe+tng1wG8NcFh9gNjCy
	 d9hIUd3yJ9vl3EFfTSkuJETr2Y6SJF5syCGumdL2KZIWo8+OmJ2vghWfpLg8rtJGDh
	 g2LoYdgrk8v8g==
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
	Mark Rutland <mark.rutland@arm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Mike Rapoport <rppt@kernel.org>,
	Nadav Amit <nadav.amit@gmail.com>,
	"Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Puranjay Mohan <puranjay12@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
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
Subject: [PATCH v2 10/12] arch: make execmem setup available regardless of CONFIG_MODULES
Date: Fri, 16 Jun 2023 11:50:36 +0300
Message-Id: <20230616085038.4121892-11-rppt@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230616085038.4121892-1-rppt@kernel.org>
References: <20230616085038.4121892-1-rppt@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Mike Rapoport (IBM)" <rppt@kernel.org>

execmem does not depend on modules, on the contrary modules use
execmem.

To make execmem available when CONFIG_MODULES=n, for instance for
kprobes, split execmem_params initialization out from
arch/kernel/module.c and compile it when CONFIG_EXECMEM=y

Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
---
 arch/arm/kernel/module.c        | 36 --------------------
 arch/arm/mm/init.c              | 36 ++++++++++++++++++++
 arch/arm64/include/asm/memory.h |  8 +++++
 arch/arm64/include/asm/module.h |  6 ----
 arch/arm64/kernel/kaslr.c       |  3 +-
 arch/arm64/kernel/module.c      | 50 ----------------------------
 arch/arm64/mm/init.c            | 56 +++++++++++++++++++++++++++++++
 arch/loongarch/kernel/module.c  | 18 ----------
 arch/loongarch/mm/init.c        | 20 +++++++++++
 arch/mips/kernel/module.c       | 18 ----------
 arch/mips/mm/init.c             | 19 +++++++++++
 arch/parisc/kernel/module.c     | 17 ----------
 arch/parisc/mm/init.c           | 22 +++++++++++-
 arch/powerpc/kernel/module.c    | 58 --------------------------------
 arch/powerpc/mm/mem.c           | 59 +++++++++++++++++++++++++++++++++
 arch/riscv/kernel/module.c      | 34 -------------------
 arch/riscv/mm/init.c            | 34 +++++++++++++++++++
 arch/s390/kernel/module.c       | 38 ---------------------
 arch/s390/mm/init.c             | 41 +++++++++++++++++++++++
 arch/sparc/kernel/module.c      | 23 -------------
 arch/sparc/mm/Makefile          |  2 ++
 arch/sparc/mm/execmem.c         | 25 ++++++++++++++
 arch/x86/kernel/module.c        | 50 ----------------------------
 arch/x86/mm/init.c              | 54 ++++++++++++++++++++++++++++++
 24 files changed, 376 insertions(+), 351 deletions(-)
 create mode 100644 arch/sparc/mm/execmem.c

diff --git a/arch/arm/kernel/module.c b/arch/arm/kernel/module.c
index f66d479c1c7d..054e799e7091 100644
--- a/arch/arm/kernel/module.c
+++ b/arch/arm/kernel/module.c
@@ -16,48 +16,12 @@
 #include <linux/fs.h>
 #include <linux/string.h>
 #include <linux/gfp.h>
-#include <linux/execmem.h>
 
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
-static struct execmem_params execmem_params = {
-	.modules = {
-		.text = {
-			.start = MODULES_VADDR,
-			.end = MODULES_END,
-			.alignment = 1,
-		},
-	},
-};
-
-struct execmem_params __init *execmem_arch_params(void)
-{
-	execmem_params.modules.text.pgprot = PAGE_KERNEL_EXEC;
-
-	if (IS_ENABLED(CONFIG_ARM_MODULE_PLTS)) {
-		execmem_params.modules.text.fallback_start = VMALLOC_START;
-		execmem_params.modules.text.fallback_end = VMALLOC_END;
-	}
-
-	return &execmem_params;
-}
-#endif
-
 bool module_init_section(const char *name)
 {
 	return strstarts(name, ".init") ||
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index ce64bdb55a16..cffd29f15782 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -22,6 +22,7 @@
 #include <linux/sizes.h>
 #include <linux/stop_machine.h>
 #include <linux/swiotlb.h>
+#include <linux/execmem.h>
 
 #include <asm/cp15.h>
 #include <asm/mach-types.h>
@@ -486,3 +487,38 @@ void free_initrd_mem(unsigned long start, unsigned long end)
 	free_reserved_area((void *)start, (void *)end, -1, "initrd");
 }
 #endif
+
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
+#if defined(CONFIG_MMU) && defined(CONFIG_EXECMEM)
+static struct execmem_params execmem_params = {
+	.modules = {
+		.text = {
+			.start = MODULES_VADDR,
+			.end = MODULES_END,
+			.alignment = 1,
+		},
+	},
+};
+
+struct execmem_params __init *execmem_arch_params(void)
+{
+	execmem_params.modules.text.pgprot = PAGE_KERNEL_EXEC;
+
+	if (IS_ENABLED(CONFIG_ARM_MODULE_PLTS)) {
+		execmem_params.modules.text.fallback_start = VMALLOC_START;
+		execmem_params.modules.text.fallback_end = VMALLOC_END;
+	}
+
+	return &execmem_params;
+}
+#endif
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index c735afdf639b..962ad2d8b5e5 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -214,6 +214,14 @@ static inline bool kaslr_enabled(void)
 	return kaslr_offset() >= MIN_KIMG_ALIGN;
 }
 
+#ifdef CONFIG_RANDOMIZE_BASE
+extern u64 module_alloc_base;
+int kaslr_init(void);
+#else
+static int kaslr_init(void) {}
+#define module_alloc_base	((u64)_etext - MODULES_VSIZE)
+#endif
+
 /*
  * Allow all memory at the discovery stage. We will clip it later.
  */
diff --git a/arch/arm64/include/asm/module.h b/arch/arm64/include/asm/module.h
index 18734fed3bdd..3e7dcc5fa2f2 100644
--- a/arch/arm64/include/asm/module.h
+++ b/arch/arm64/include/asm/module.h
@@ -30,12 +30,6 @@ u64 module_emit_plt_entry(struct module *mod, Elf64_Shdr *sechdrs,
 u64 module_emit_veneer_for_adrp(struct module *mod, Elf64_Shdr *sechdrs,
 				void *loc, u64 val);
 
-#ifdef CONFIG_RANDOMIZE_BASE
-extern u64 module_alloc_base;
-#else
-#define module_alloc_base	((u64)_etext - MODULES_VSIZE)
-#endif
-
 struct plt_entry {
 	/*
 	 * A program that conforms to the AArch64 Procedure Call Standard
diff --git a/arch/arm64/kernel/kaslr.c b/arch/arm64/kernel/kaslr.c
index e7477f21a4c9..1f5ce4e41e59 100644
--- a/arch/arm64/kernel/kaslr.c
+++ b/arch/arm64/kernel/kaslr.c
@@ -25,7 +25,7 @@ u16 __initdata memstart_offset_seed;
 
 struct arm64_ftr_override kaslr_feature_override __initdata;
 
-static int __init kaslr_init(void)
+int __init kaslr_init(void)
 {
 	u64 module_range;
 	u32 seed;
@@ -90,4 +90,3 @@ static int __init kaslr_init(void)
 
 	return 0;
 }
-subsys_initcall(kaslr_init)
diff --git a/arch/arm64/kernel/module.c b/arch/arm64/kernel/module.c
index 52b09626bc0f..6d09b29fe9db 100644
--- a/arch/arm64/kernel/module.c
+++ b/arch/arm64/kernel/module.c
@@ -17,61 +17,11 @@
 #include <linux/moduleloader.h>
 #include <linux/scs.h>
 #include <linux/vmalloc.h>
-#include <linux/execmem.h>
 #include <asm/alternative.h>
 #include <asm/insn.h>
 #include <asm/scs.h>
 #include <asm/sections.h>
 
-static struct execmem_params execmem_params = {
-	.modules = {
-		.flags = EXECMEM_KASAN_SHADOW,
-		.text = {
-			.alignment = MODULE_ALIGN,
-		},
-	},
-	.jit = {
-		.text = {
-			.start = VMALLOC_START,
-			.end = VMALLOC_END,
-			.alignment = 1,
-		},
-	},
-};
-
-struct execmem_params __init *execmem_arch_params(void)
-{
-	u64 module_alloc_end = module_alloc_base + MODULES_VSIZE;
-
-	execmem_params.modules.text.pgprot = PAGE_KERNEL;
-	execmem_params.modules.text.start = module_alloc_base;
-	execmem_params.modules.text.end = module_alloc_end;
-
-	execmem_params.jit.text.pgprot = PAGE_KERNEL_ROX;
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
-		unsigned long end = module_alloc_base + SZ_2G;
-
-		execmem_params.modules.text.fallback_start = module_alloc_base;
-		execmem_params.modules.text.fallback_end = end;
-	}
-
-	return &execmem_params;
-}
-
 enum aarch64_reloc_op {
 	RELOC_OP_NONE,
 	RELOC_OP_ABS,
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 66e70ca47680..7e3c202ff6ea 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -31,6 +31,7 @@
 #include <linux/hugetlb.h>
 #include <linux/acpi_iort.h>
 #include <linux/kmemleak.h>
+#include <linux/execmem.h>
 
 #include <asm/boot.h>
 #include <asm/fixmap.h>
@@ -493,3 +494,58 @@ void dump_mem_limit(void)
 		pr_emerg("Memory Limit: none\n");
 	}
 }
+
+#ifdef CONFIG_EXECMEM
+static struct execmem_params execmem_params = {
+	.modules = {
+		.flags = EXECMEM_KASAN_SHADOW,
+		.text = {
+			.alignment = MODULE_ALIGN,
+		},
+	},
+	.jit = {
+		.text = {
+			.start = VMALLOC_START,
+			.end = VMALLOC_END,
+			.alignment = 1,
+		},
+	},
+};
+
+struct execmem_params __init *execmem_arch_params(void)
+{
+	u64 module_alloc_end;
+
+	kaslr_init();
+
+	module_alloc_end = module_alloc_base + MODULES_VSIZE;
+
+	execmem_params.modules.text.pgprot = PAGE_KERNEL;
+	execmem_params.modules.text.start = module_alloc_base;
+	execmem_params.modules.text.end = module_alloc_end;
+
+	execmem_params.jit.text.pgprot = PAGE_KERNEL_ROX;
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
+		unsigned long end = module_alloc_base + SZ_2G;
+
+		execmem_params.modules.text.fallback_start = module_alloc_base;
+		execmem_params.modules.text.fallback_end = end;
+	}
+
+	return &execmem_params;
+}
+#endif
diff --git a/arch/loongarch/kernel/module.c b/arch/loongarch/kernel/module.c
index 32b167722c2b..181b5f8b09f1 100644
--- a/arch/loongarch/kernel/module.c
+++ b/arch/loongarch/kernel/module.c
@@ -18,7 +18,6 @@
 #include <linux/ftrace.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
-#include <linux/execmem.h>
 #include <asm/alternative.h>
 #include <asm/inst.h>
 
@@ -470,23 +469,6 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
 	return 0;
 }
 
-static struct execmem_params execmem_params = {
-	.modules = {
-		.text = {
-			.pgprot = PAGE_KERNEL,
-			.alignment = 1,
-		},
-	},
-};
-
-struct execmem_params __init *execmem_arch_params(void)
-{
-	execmem_params.modules.text.start = MODULES_VADDR;
-	execmem_params.modules.text.end = MODULES_END;
-
-	return &execmem_params;
-}
-
 static void module_init_ftrace_plt(const Elf_Ehdr *hdr,
 				   const Elf_Shdr *sechdrs, struct module *mod)
 {
diff --git a/arch/loongarch/mm/init.c b/arch/loongarch/mm/init.c
index 3b7d8129570b..e752f94f87ed 100644
--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -24,6 +24,7 @@
 #include <linux/gfp.h>
 #include <linux/hugetlb.h>
 #include <linux/mmzone.h>
+#include <linux/execmem.h>
 
 #include <asm/asm-offsets.h>
 #include <asm/bootinfo.h>
@@ -274,3 +275,22 @@ EXPORT_SYMBOL(invalid_pmd_table);
 #endif
 pte_t invalid_pte_table[PTRS_PER_PTE] __page_aligned_bss;
 EXPORT_SYMBOL(invalid_pte_table);
+
+#ifdef CONFIG_EXECMEM
+static struct execmem_params execmem_params = {
+	.modules = {
+		.text = {
+			.pgprot = PAGE_KERNEL,
+			.alignment = 1,
+		},
+	},
+};
+
+struct execmem_params __init *execmem_arch_params(void)
+{
+	execmem_params.modules.text.start = MODULES_VADDR;
+	execmem_params.modules.text.end = MODULES_END;
+
+	return &execmem_params;
+}
+#endif
diff --git a/arch/mips/kernel/module.c b/arch/mips/kernel/module.c
index 2d370de67383..ebf9496f5db0 100644
--- a/arch/mips/kernel/module.c
+++ b/arch/mips/kernel/module.c
@@ -33,24 +33,6 @@ struct mips_hi16 {
 static LIST_HEAD(dbe_list);
 static DEFINE_SPINLOCK(dbe_lock);
 
-#ifdef MODULE_START
-static struct execmem_params execmem_params = {
-	.modules = {
-		.text = {
-			.start = MODULES_VADDR,
-			.end = MODULES_END,
-			.pgprot = PAGE_KERNEL,
-			.alignment = 1,
-		},
-	},
-};
-
-struct execmem_params __init *execmem_arch_params(void)
-{
-	return &execmem_params;
-}
-#endif
-
 static void apply_r_mips_32(u32 *location, u32 base, Elf_Addr v)
 {
 	*location = base + v;
diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
index 5a8002839550..630656921a87 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -31,6 +31,7 @@
 #include <linux/gfp.h>
 #include <linux/kcore.h>
 #include <linux/initrd.h>
+#include <linux/execmem.h>
 
 #include <asm/bootinfo.h>
 #include <asm/cachectl.h>
@@ -568,3 +569,21 @@ EXPORT_SYMBOL_GPL(invalid_pmd_table);
 #endif
 pte_t invalid_pte_table[PTRS_PER_PTE] __page_aligned_bss;
 EXPORT_SYMBOL(invalid_pte_table);
+
+#if defined(CONFIG_EXECMEM) && defined(MODULE_START)
+static struct execmem_params execmem_params = {
+	.modules = {
+		.text = {
+			.start = MODULES_VADDR,
+			.end = MODULES_END,
+			.pgprot = PAGE_KERNEL,
+			.alignment = 1,
+		},
+	},
+};
+
+struct execmem_params __init *execmem_arch_params(void)
+{
+	return &execmem_params;
+}
+#endif
diff --git a/arch/parisc/kernel/module.c b/arch/parisc/kernel/module.c
index 569b8f52a24b..b975c9d583f1 100644
--- a/arch/parisc/kernel/module.c
+++ b/arch/parisc/kernel/module.c
@@ -174,23 +174,6 @@ static inline int reassemble_22(int as22)
 		((as22 & 0x0003ff) << 3));
 }
 
-static struct execmem_params execmem_params = {
-	.modules = {
-		.text = {
-			.pgprot = PAGE_KERNEL_RWX,
-			.alignment = 1,
-		},
-	},
-};
-
-struct execmem_params __init *execmem_arch_params(void)
-{
-	execmem_params.modules.text.start = VMALLOC_START;
-	execmem_params.modules.text.end = VMALLOC_END;
-
-	return &execmem_params;
-}
-
 #ifndef CONFIG_64BIT
 static inline unsigned long count_gots(const Elf_Rela *rela, unsigned long n)
 {
diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
index b0c43f3b0a5f..659eddaa492d 100644
--- a/arch/parisc/mm/init.c
+++ b/arch/parisc/mm/init.c
@@ -24,6 +24,7 @@
 #include <linux/nodemask.h>	/* for node_online_map */
 #include <linux/pagemap.h>	/* for release_pages */
 #include <linux/compat.h>
+#include <linux/execmem.h>
 
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
@@ -891,3 +892,22 @@ static const pgprot_t protection_map[16] = {
 	[VM_SHARED | VM_EXEC | VM_WRITE | VM_READ]	= PAGE_RWX
 };
 DECLARE_VM_GET_PAGE_PROT
+
+#ifdef CONFIG_EXECMEM
+static struct execmem_params execmem_params = {
+	.modules = {
+		.text = {
+			.pgprot = PAGE_KERNEL_RWX,
+			.alignment = 1,
+		},
+	},
+};
+
+struct execmem_params __init *execmem_arch_params(void)
+{
+	execmem_params.modules.text.start = VMALLOC_START;
+	execmem_params.modules.text.end = VMALLOC_END;
+
+	return &execmem_params;
+}
+#endif
diff --git a/arch/powerpc/kernel/module.c b/arch/powerpc/kernel/module.c
index 8e5b379d6da1..b30e00964a60 100644
--- a/arch/powerpc/kernel/module.c
+++ b/arch/powerpc/kernel/module.c
@@ -10,7 +10,6 @@
 #include <linux/vmalloc.h>
 #include <linux/mm.h>
 #include <linux/bug.h>
-#include <linux/execmem.h>
 #include <asm/module.h>
 #include <linux/uaccess.h>
 #include <asm/firmware.h>
@@ -89,60 +88,3 @@ int module_finalize(const Elf_Ehdr *hdr,
 
 	return 0;
 }
-
-static struct execmem_params execmem_params = {
-	.modules = {
-		.text = {
-			.alignment = 1,
-		},
-	},
-	.jit = {
-		.text = {
-			.alignment = 1,
-		},
-	},
-};
-
-
-struct execmem_params __init *execmem_arch_params(void)
-{
-	pgprot_t prot = strict_module_rwx_enabled() ? PAGE_KERNEL : PAGE_KERNEL_EXEC;
-
-	/*
-	 * BOOK3S_32 and 8xx define MODULES_VADDR for text allocations and
-	 * allow allocating data in the entire vmalloc space
-	 */
-#ifdef MODULES_VADDR
-	unsigned long limit = (unsigned long)_etext - SZ_32M;
-
-	/* First try within 32M limit from _etext to avoid branch trampolines */
-	if (MODULES_VADDR < PAGE_OFFSET && MODULES_END > limit) {
-		execmem_params.modules.text.start = limit;
-		execmem_params.modules.text.end = MODULES_END;
-		execmem_params.modules.text.fallback_start = MODULES_VADDR;
-		execmem_params.modules.text.fallback_end = MODULES_END;
-	} else {
-		execmem_params.modules.text.start = MODULES_VADDR;
-		execmem_params.modules.text.end = MODULES_END;
-	}
-	execmem_params.modules.data.start = VMALLOC_START;
-	execmem_params.modules.data.end = VMALLOC_END;
-	execmem_params.modules.data.pgprot = PAGE_KERNEL;
-	execmem_params.modules.data.alignment = 1;
-#else
-	execmem_params.modules.text.start = VMALLOC_START;
-	execmem_params.modules.text.end = VMALLOC_END;
-#endif
-
-	execmem_params.modules.text.pgprot = prot;
-
-	execmem_params.jit.text.start = VMALLOC_START;
-	execmem_params.jit.text.end = VMALLOC_END;
-
-	if (strict_module_rwx_enabled())
-		execmem_params.jit.text.pgprot = PAGE_KERNEL_ROX;
-	else
-		execmem_params.jit.text.pgprot = PAGE_KERNEL_EXEC;
-
-	return &execmem_params;
-}
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 8b121df7b08f..84cc805d780d 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -16,6 +16,7 @@
 #include <linux/highmem.h>
 #include <linux/suspend.h>
 #include <linux/dma-direct.h>
+#include <linux/execmem.h>
 
 #include <asm/swiotlb.h>
 #include <asm/machdep.h>
@@ -406,3 +407,61 @@ int devmem_is_allowed(unsigned long pfn)
  * the EHEA driver. Drop this when drivers/net/ethernet/ibm/ehea is removed.
  */
 EXPORT_SYMBOL_GPL(walk_system_ram_range);
+
+#ifdef CONFIG_EXECMEM
+static struct execmem_params execmem_params = {
+	.modules = {
+		.text = {
+			.alignment = 1,
+		},
+	},
+	.jit = {
+		.text = {
+			.alignment = 1,
+		},
+	},
+};
+
+struct execmem_params __init *execmem_arch_params(void)
+{
+	pgprot_t prot = strict_module_rwx_enabled() ? PAGE_KERNEL : PAGE_KERNEL_EXEC;
+
+	/*
+	 * BOOK3S_32 and 8xx define MODULES_VADDR for text allocations and
+	 * allow allocating data in the entire vmalloc space
+	 */
+#ifdef MODULES_VADDR
+	unsigned long limit = (unsigned long)_etext - SZ_32M;
+
+	/* First try within 32M limit from _etext to avoid branch trampolines */
+	if (MODULES_VADDR < PAGE_OFFSET && MODULES_END > limit) {
+		execmem_params.modules.text.start = limit;
+		execmem_params.modules.text.end = MODULES_END;
+		execmem_params.modules.text.fallback_start = MODULES_VADDR;
+		execmem_params.modules.text.fallback_end = MODULES_END;
+	} else {
+		execmem_params.modules.text.start = MODULES_VADDR;
+		execmem_params.modules.text.end = MODULES_END;
+	}
+	execmem_params.modules.data.start = VMALLOC_START;
+	execmem_params.modules.data.end = VMALLOC_END;
+	execmem_params.modules.data.pgprot = PAGE_KERNEL;
+	execmem_params.modules.data.alignment = 1;
+#else
+	execmem_params.modules.text.start = VMALLOC_START;
+	execmem_params.modules.text.end = VMALLOC_END;
+#endif
+
+	execmem_params.modules.text.pgprot = prot;
+
+	execmem_params.jit.text.start = VMALLOC_START;
+	execmem_params.jit.text.end = VMALLOC_END;
+
+	if (strict_module_rwx_enabled())
+		execmem_params.jit.text.pgprot = PAGE_KERNEL_ROX;
+	else
+		execmem_params.jit.text.pgprot = PAGE_KERNEL_EXEC;
+
+	return &execmem_params;
+}
+#endif
diff --git a/arch/riscv/kernel/module.c b/arch/riscv/kernel/module.c
index cca6ed4e9340..8af08d5449bf 100644
--- a/arch/riscv/kernel/module.c
+++ b/arch/riscv/kernel/module.c
@@ -11,7 +11,6 @@
 #include <linux/vmalloc.h>
 #include <linux/sizes.h>
 #include <linux/pgtable.h>
-#include <linux/execmem.h>
 #include <asm/alternative.h>
 #include <asm/sections.h>
 
@@ -436,39 +435,6 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
 	return 0;
 }
 
-#ifdef CONFIG_MMU
-static struct execmem_params execmem_params = {
-	.modules = {
-		.text = {
-			.pgprot = PAGE_KERNEL,
-			.alignment = 1,
-		},
-	},
-	.jit = {
-		.text = {
-			.pgprot = PAGE_KERNEL_READ_EXEC,
-			.alignment = 1,
-		},
-	},
-};
-
-struct execmem_params __init *execmem_arch_params(void)
-{
-#ifdef CONFIG_64BIT
-	execmem_params.modules.text.start = MODULES_VADDR;
-	execmem_params.modules.text.end = MODULES_END;
-#else
-	execmem_params.modules.text.start = VMALLOC_START;
-	execmem_params.modules.text.end = VMALLOC_END;
-#endif
-
-	execmem_params.jit.text.start = VMALLOC_START;
-	execmem_params.jit.text.end = VMALLOC_END;
-
-	return &execmem_params;
-}
-#endif
-
 int module_finalize(const Elf_Ehdr *hdr,
 		    const Elf_Shdr *sechdrs,
 		    struct module *me)
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 747e5b1ef02d..d7b88d89f021 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -23,6 +23,7 @@
 #ifdef CONFIG_RELOCATABLE
 #include <linux/elf.h>
 #endif
+#include <linux/execmem.h>
 
 #include <asm/fixmap.h>
 #include <asm/tlbflush.h>
@@ -1363,3 +1364,36 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 	return vmemmap_populate_basepages(start, end, node, NULL);
 }
 #endif
+
+#if defined(CONFIG_MMU) && defined(CONFIG_EXECMEM)
+static struct execmem_params execmem_params = {
+	.modules = {
+		.text = {
+			.pgprot = PAGE_KERNEL,
+			.alignment = 1,
+		},
+	},
+	.jit = {
+		.text = {
+			.pgprot = PAGE_KERNEL_READ_EXEC,
+			.alignment = 1,
+		},
+	},
+};
+
+struct execmem_params __init *execmem_arch_params(void)
+{
+#ifdef CONFIG_64BIT
+	execmem_params.modules.text.start = MODULES_VADDR;
+	execmem_params.modules.text.end = MODULES_END;
+#else
+	execmem_params.modules.text.start = VMALLOC_START;
+	execmem_params.modules.text.end = VMALLOC_END;
+#endif
+
+	execmem_params.jit.text.start = VMALLOC_START;
+	execmem_params.jit.text.end = VMALLOC_END;
+
+	return &execmem_params;
+}
+#endif
diff --git a/arch/s390/kernel/module.c b/arch/s390/kernel/module.c
index 7fff395d26ea..3773c842fc01 100644
--- a/arch/s390/kernel/module.c
+++ b/arch/s390/kernel/module.c
@@ -37,44 +37,6 @@
 
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
-static struct execmem_params execmem_params = {
-	.modules = {
-		.flags = EXECMEM_KASAN_SHADOW,
-		.text = {
-			.alignment = MODULE_ALIGN,
-			.pgprot = PAGE_KERNEL,
-		},
-	},
-};
-
-struct execmem_params __init *execmem_arch_params(void)
-{
-	unsigned long start = MODULES_VADDR + get_module_load_offset();
-
-	execmem_params.modules.text.start = start;
-	execmem_params.modules.text.end = MODULES_END;
-
-	return &execmem_params;
-}
-
 #ifdef CONFIG_FUNCTION_TRACER
 void module_arch_cleanup(struct module *mod)
 {
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index 8d94e29adcdb..cab5c2d041d1 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -34,6 +34,7 @@
 #include <linux/percpu.h>
 #include <asm/processor.h>
 #include <linux/uaccess.h>
+#include <linux/execmem.h>
 #include <asm/pgalloc.h>
 #include <asm/kfence.h>
 #include <asm/ptdump.h>
@@ -311,3 +312,43 @@ void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
 	vmem_remove_mapping(start, size);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
+
+#ifdef CONFIG_EXECMEM
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
+static struct execmem_params execmem_params = {
+	.modules = {
+		.flags = EXECMEM_KASAN_SHADOW,
+		.text = {
+			.alignment = MODULE_ALIGN,
+			.pgprot = PAGE_KERNEL,
+		},
+	},
+};
+
+struct execmem_params __init *execmem_arch_params(void)
+{
+	unsigned long start = MODULES_VADDR + get_module_load_offset();
+
+	execmem_params.modules.text.start = start;
+	execmem_params.modules.text.end = MODULES_END;
+
+	return &execmem_params;
+}
+#endif
diff --git a/arch/sparc/kernel/module.c b/arch/sparc/kernel/module.c
index ab75e3e69834..dff1d85ba202 100644
--- a/arch/sparc/kernel/module.c
+++ b/arch/sparc/kernel/module.c
@@ -14,7 +14,6 @@
 #include <linux/string.h>
 #include <linux/ctype.h>
 #include <linux/mm.h>
-#include <linux/execmem.h>
 #ifdef CONFIG_SPARC64
 #include <linux/jump_label.h>
 #endif
@@ -25,28 +24,6 @@
 
 #include "entry.h"
 
-static struct execmem_params execmem_params = {
-	.modules = {
-		.text = {
-#ifdef CONFIG_SPARC64
-			.start = MODULES_VADDR,
-			.end = MODULES_END,
-#else
-			.start = VMALLOC_START,
-			.end = VMALLOC_END,
-#endif
-			.alignment = 1,
-		},
-	},
-};
-
-struct execmem_params __init *execmem_arch_params(void)
-{
-	execmem_params.modules.text.pgprot = PAGE_KERNEL;
-
-	return &execmem_params;
-}
-
 /* Make generic code ignore STT_REGISTER dummy undefined symbols.  */
 int module_frob_arch_sections(Elf_Ehdr *hdr,
 			      Elf_Shdr *sechdrs,
diff --git a/arch/sparc/mm/Makefile b/arch/sparc/mm/Makefile
index 871354aa3c00..87e2cf7efb5b 100644
--- a/arch/sparc/mm/Makefile
+++ b/arch/sparc/mm/Makefile
@@ -15,3 +15,5 @@ obj-$(CONFIG_SPARC32)   += leon_mm.o
 
 # Only used by sparc64
 obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpage.o
+
+obj-$(CONFIG_EXECMEM) += execmem.o
diff --git a/arch/sparc/mm/execmem.c b/arch/sparc/mm/execmem.c
new file mode 100644
index 000000000000..74708b7b1f84
--- /dev/null
+++ b/arch/sparc/mm/execmem.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/mm.h>
+#include <linux/execmem.h>
+
+static struct execmem_params execmem_params = {
+	.modules = {
+		.text = {
+#ifdef CONFIG_SPARC64
+			.start = MODULES_VADDR,
+			.end = MODULES_END,
+#else
+			.start = VMALLOC_START,
+			.end = VMALLOC_END,
+#endif
+			.alignment = 1,
+		},
+	},
+};
+
+struct execmem_params __init *execmem_arch_params(void)
+{
+	execmem_params.modules.text.pgprot = PAGE_KERNEL;
+
+	return &execmem_params;
+}
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index cf9a7d0a8b62..94a00dc103cd 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -19,7 +19,6 @@
 #include <linux/jump_label.h>
 #include <linux/random.h>
 #include <linux/memory.h>
-#include <linux/execmem.h>
 
 #include <asm/text-patching.h>
 #include <asm/page.h>
@@ -37,55 +36,6 @@ do {							\
 } while (0)
 #endif
 
-#ifdef CONFIG_RANDOMIZE_BASE
-static unsigned long module_load_offset;
-
-/* Mutex protects the module_load_offset. */
-static DEFINE_MUTEX(module_kaslr_mutex);
-
-static unsigned long int get_module_load_offset(void)
-{
-	if (kaslr_enabled()) {
-		mutex_lock(&module_kaslr_mutex);
-		/*
-		 * Calculate the module_load_offset the first time this
-		 * code is called. Once calculated it stays the same until
-		 * reboot.
-		 */
-		if (module_load_offset == 0)
-			module_load_offset =
-				get_random_u32_inclusive(1, 1024) * PAGE_SIZE;
-		mutex_unlock(&module_kaslr_mutex);
-	}
-	return module_load_offset;
-}
-#else
-static unsigned long int get_module_load_offset(void)
-{
-	return 0;
-}
-#endif
-
-static struct execmem_params execmem_params = {
-	.modules = {
-		.flags = EXECMEM_KASAN_SHADOW,
-		.text = {
-			.alignment = MODULE_ALIGN,
-		},
-	},
-};
-
-struct execmem_params __init *execmem_arch_params(void)
-{
-	unsigned long start = MODULES_VADDR + get_module_load_offset();
-
-	execmem_params.modules.text.start = start;
-	execmem_params.modules.text.end = MODULES_END;
-	execmem_params.modules.text.pgprot = PAGE_KERNEL;
-
-	return &execmem_params;
-}
-
 #ifdef CONFIG_X86_32
 int apply_relocate(Elf32_Shdr *sechdrs,
 		   const char *strtab,
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 3cdac0f0055d..b3833cca68bc 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -7,6 +7,7 @@
 #include <linux/swapops.h>
 #include <linux/kmemleak.h>
 #include <linux/sched/task.h>
+#include <linux/execmem.h>
 
 #include <asm/set_memory.h>
 #include <asm/e820/api.h>
@@ -1084,3 +1085,56 @@ unsigned long arch_max_swapfile_size(void)
 	return pages;
 }
 #endif
+
+#ifdef CONFIG_EXECMEM
+
+#ifdef CONFIG_RANDOMIZE_BASE
+static unsigned long module_load_offset;
+
+/* Mutex protects the module_load_offset. */
+static DEFINE_MUTEX(module_kaslr_mutex);
+
+static unsigned long int get_module_load_offset(void)
+{
+	if (kaslr_enabled()) {
+		mutex_lock(&module_kaslr_mutex);
+		/*
+		 * Calculate the module_load_offset the first time this
+		 * code is called. Once calculated it stays the same until
+		 * reboot.
+		 */
+		if (module_load_offset == 0)
+			module_load_offset =
+				get_random_u32_inclusive(1, 1024) * PAGE_SIZE;
+		mutex_unlock(&module_kaslr_mutex);
+	}
+	return module_load_offset;
+}
+#else
+static unsigned long int get_module_load_offset(void)
+{
+	return 0;
+}
+#endif
+
+static struct execmem_params execmem_params = {
+	.modules = {
+		.flags = EXECMEM_KASAN_SHADOW,
+		.text = {
+			.alignment = MODULE_ALIGN,
+		},
+	},
+};
+
+struct execmem_params __init *execmem_arch_params(void)
+{
+	unsigned long start = MODULES_VADDR + get_module_load_offset();
+
+	execmem_params.modules.text.start = start;
+	execmem_params.modules.text.end = MODULES_END;
+	execmem_params.modules.text.pgprot = PAGE_KERNEL;
+
+	return &execmem_params;
+}
+
+#endif /* CONFIG_EXECMEM */
-- 
2.35.1


