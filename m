Return-Path: <netdev+bounces-11334-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D52E0732A73
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:53:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B24E28165E
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 08:53:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D343DF46;
	Fri, 16 Jun 2023 08:51:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5F41FCB;
	Fri, 16 Jun 2023 08:51:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B96C433C0;
	Fri, 16 Jun 2023 08:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686905498;
	bh=5P3mMxIXyYNFf6ppZC87llJS/A2oA3e+rU9odOZ3rFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GrSOa5NhtnOEdPO2emKldCxYq27NagFlOnpLOPRg/qCuHIHb8LO7S1KsNa7cBBIGu
	 CFULz/Fso5mnFPxC3GoKTve3+GH4KOJC5ENs9MjgPe830iXGdUkhmDkBuiYS3js9hZ
	 O2Gei2pZomobwEJ1RNRHUB/XhCGqlFQVqR6O2zwyETWqFgnQaf3J1VPH78T0wy/xey
	 gE5JfYQAcoxcH1BlP+lcR2tXCj15xHKYZDhug7RerclAfJxxJRCcw3d33O/ei7NoF5
	 Ctk1dieqBSWGe40Ie9dYqN4xtYT9kr+/6eGN0a2X8Ll7piImnto7TUIvOdE162+eR2
	 lxUPLhTkaHJxQ==
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
Subject: [PATCH v2 04/12] mm/execmem, arch: convert remaining overrides of module_alloc to execmem
Date: Fri, 16 Jun 2023 11:50:30 +0300
Message-Id: <20230616085038.4121892-5-rppt@kernel.org>
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

Extend execmem parameters to accommodate more complex overrides of
module_alloc() by architectures.

This includes specification of a fallback range required by arm, arm64
and powerpc and support for allocation of KASAN shadow required by
arm64, s390 and x86.

The core implementation of execmem_alloc() takes care of suppressing
warnings when the initial allocation fails but there is a fallback range
defined.

Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
---
 arch/arm/kernel/module.c     | 36 ++++++++++---------
 arch/arm64/kernel/module.c   | 68 ++++++++++++++++--------------------
 arch/powerpc/kernel/module.c | 52 +++++++++++++--------------
 arch/s390/kernel/module.c    | 33 ++++++++---------
 arch/x86/kernel/module.c     | 33 +++++++++--------
 include/linux/execmem.h      | 14 ++++++++
 mm/execmem.c                 | 50 ++++++++++++++++++++++----
 7 files changed, 168 insertions(+), 118 deletions(-)

diff --git a/arch/arm/kernel/module.c b/arch/arm/kernel/module.c
index d59c36dc0494..f66d479c1c7d 100644
--- a/arch/arm/kernel/module.c
+++ b/arch/arm/kernel/module.c
@@ -16,6 +16,7 @@
 #include <linux/fs.h>
 #include <linux/string.h>
 #include <linux/gfp.h>
+#include <linux/execmem.h>
 
 #include <asm/sections.h>
 #include <asm/smp_plat.h>
@@ -34,23 +35,26 @@
 #endif
 
 #ifdef CONFIG_MMU
-void *module_alloc(unsigned long size)
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
 {
-	gfp_t gfp_mask = GFP_KERNEL;
-	void *p;
-
-	/* Silence the initial allocation */
-	if (IS_ENABLED(CONFIG_ARM_MODULE_PLTS))
-		gfp_mask |= __GFP_NOWARN;
-
-	p = __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
-				gfp_mask, PAGE_KERNEL_EXEC, 0, NUMA_NO_NODE,
-				__builtin_return_address(0));
-	if (!IS_ENABLED(CONFIG_ARM_MODULE_PLTS) || p)
-		return p;
-	return __vmalloc_node_range(size, 1,  VMALLOC_START, VMALLOC_END,
-				GFP_KERNEL, PAGE_KERNEL_EXEC, 0, NUMA_NO_NODE,
-				__builtin_return_address(0));
+	execmem_params.modules.text.pgprot = PAGE_KERNEL_EXEC;
+
+	if (IS_ENABLED(CONFIG_ARM_MODULE_PLTS)) {
+		execmem_params.modules.text.fallback_start = VMALLOC_START;
+		execmem_params.modules.text.fallback_end = VMALLOC_END;
+	}
+
+	return &execmem_params;
 }
 #endif
 
diff --git a/arch/arm64/kernel/module.c b/arch/arm64/kernel/module.c
index 5af4975caeb5..c3d999f3a3dd 100644
--- a/arch/arm64/kernel/module.c
+++ b/arch/arm64/kernel/module.c
@@ -17,56 +17,50 @@
 #include <linux/moduleloader.h>
 #include <linux/scs.h>
 #include <linux/vmalloc.h>
+#include <linux/execmem.h>
 #include <asm/alternative.h>
 #include <asm/insn.h>
 #include <asm/scs.h>
 #include <asm/sections.h>
 
-void *module_alloc(unsigned long size)
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
 {
 	u64 module_alloc_end = module_alloc_base + MODULES_VSIZE;
-	gfp_t gfp_mask = GFP_KERNEL;
-	void *p;
-
-	/* Silence the initial allocation */
-	if (IS_ENABLED(CONFIG_ARM64_MODULE_PLTS))
-		gfp_mask |= __GFP_NOWARN;
 
-	if (IS_ENABLED(CONFIG_KASAN_GENERIC) ||
-	    IS_ENABLED(CONFIG_KASAN_SW_TAGS))
-		/* don't exceed the static module region - see below */
-		module_alloc_end = MODULES_END;
+	execmem_params.modules.text.pgprot = PAGE_KERNEL;
+	execmem_params.modules.text.start = module_alloc_base;
+	execmem_params.modules.text.end = module_alloc_end;
 
-	p = __vmalloc_node_range(size, MODULE_ALIGN, module_alloc_base,
-				module_alloc_end, gfp_mask, PAGE_KERNEL, VM_DEFER_KMEMLEAK,
-				NUMA_NO_NODE, __builtin_return_address(0));
-
-	if (!p && IS_ENABLED(CONFIG_ARM64_MODULE_PLTS) &&
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
 	    (IS_ENABLED(CONFIG_KASAN_VMALLOC) ||
 	     (!IS_ENABLED(CONFIG_KASAN_GENERIC) &&
-	      !IS_ENABLED(CONFIG_KASAN_SW_TAGS))))
-		/*
-		 * KASAN without KASAN_VMALLOC can only deal with module
-		 * allocations being served from the reserved module region,
-		 * since the remainder of the vmalloc region is already
-		 * backed by zero shadow pages, and punching holes into it
-		 * is non-trivial. Since the module region is not randomized
-		 * when KASAN is enabled without KASAN_VMALLOC, it is even
-		 * less likely that the module region gets exhausted, so we
-		 * can simply omit this fallback in that case.
-		 */
-		p = __vmalloc_node_range(size, MODULE_ALIGN, module_alloc_base,
-				module_alloc_base + SZ_2G, GFP_KERNEL,
-				PAGE_KERNEL, 0, NUMA_NO_NODE,
-				__builtin_return_address(0));
-
-	if (p && (kasan_alloc_module_shadow(p, size, gfp_mask) < 0)) {
-		vfree(p);
-		return NULL;
+	      !IS_ENABLED(CONFIG_KASAN_SW_TAGS)))) {
+		unsigned long end = module_alloc_base + SZ_2G;
+
+		execmem_params.modules.text.fallback_start = module_alloc_base;
+		execmem_params.modules.text.fallback_end = end;
 	}
 
-	/* Memory is intended to be executable, reset the pointer tag. */
-	return kasan_reset_tag(p);
+	return &execmem_params;
 }
 
 enum aarch64_reloc_op {
diff --git a/arch/powerpc/kernel/module.c b/arch/powerpc/kernel/module.c
index f6d6ae0a1692..ba7abff77d98 100644
--- a/arch/powerpc/kernel/module.c
+++ b/arch/powerpc/kernel/module.c
@@ -10,6 +10,7 @@
 #include <linux/vmalloc.h>
 #include <linux/mm.h>
 #include <linux/bug.h>
+#include <linux/execmem.h>
 #include <asm/module.h>
 #include <linux/uaccess.h>
 #include <asm/firmware.h>
@@ -89,39 +90,38 @@ int module_finalize(const Elf_Ehdr *hdr,
 	return 0;
 }
 
-static __always_inline void *
-__module_alloc(unsigned long size, unsigned long start, unsigned long end, bool nowarn)
+static struct execmem_params execmem_params = {
+	.modules = {
+		.text = {
+			.alignment = 1,
+		},
+	},
+};
+
+
+struct execmem_params __init *execmem_arch_params(void)
 {
 	pgprot_t prot = strict_module_rwx_enabled() ? PAGE_KERNEL : PAGE_KERNEL_EXEC;
-	gfp_t gfp = GFP_KERNEL | (nowarn ? __GFP_NOWARN : 0);
-
-	/*
-	 * Don't do huge page allocations for modules yet until more testing
-	 * is done. STRICT_MODULE_RWX may require extra work to support this
-	 * too.
-	 */
-	return __vmalloc_node_range(size, 1, start, end, gfp, prot,
-				    VM_FLUSH_RESET_PERMS,
-				    NUMA_NO_NODE, __builtin_return_address(0));
-}
 
-void *module_alloc(unsigned long size)
-{
 #ifdef MODULES_VADDR
 	unsigned long limit = (unsigned long)_etext - SZ_32M;
-	void *ptr = NULL;
-
-	BUILD_BUG_ON(TASK_SIZE > MODULES_VADDR);
 
 	/* First try within 32M limit from _etext to avoid branch trampolines */
-	if (MODULES_VADDR < PAGE_OFFSET && MODULES_END > limit)
-		ptr = __module_alloc(size, limit, MODULES_END, true);
-
-	if (!ptr)
-		ptr = __module_alloc(size, MODULES_VADDR, MODULES_END, false);
-
-	return ptr;
+	if (MODULES_VADDR < PAGE_OFFSET && MODULES_END > limit) {
+		execmem_params.modules.text.start = limit;
+		execmem_params.modules.text.end = MODULES_END;
+		execmem_params.modules.text.fallback_start = MODULES_VADDR;
+		execmem_params.modules.text.fallback_end = MODULES_END;
+	} else {
+		execmem_params.modules.text.start = MODULES_VADDR;
+		execmem_params.modules.text.end = MODULES_END;
+	}
 #else
-	return __module_alloc(size, VMALLOC_START, VMALLOC_END, false);
+	execmem_params.modules.text.start = VMALLOC_START;
+	execmem_params.modules.text.end = VMALLOC_END;
 #endif
+
+	execmem_params.modules.text.pgprot = prot;
+
+	return &execmem_params;
 }
diff --git a/arch/s390/kernel/module.c b/arch/s390/kernel/module.c
index 4a844683dc76..7fff395d26ea 100644
--- a/arch/s390/kernel/module.c
+++ b/arch/s390/kernel/module.c
@@ -55,23 +55,24 @@ static unsigned long get_module_load_offset(void)
 	return module_load_offset;
 }
 
-void *module_alloc(unsigned long size)
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
 {
-	gfp_t gfp_mask = GFP_KERNEL;
-	void *p;
-
-	if (PAGE_ALIGN(size) > MODULES_LEN)
-		return NULL;
-	p = __vmalloc_node_range(size, MODULE_ALIGN,
-				 MODULES_VADDR + get_module_load_offset(),
-				 MODULES_END, gfp_mask, PAGE_KERNEL,
-				 VM_FLUSH_RESET_PERMS | VM_DEFER_KMEMLEAK,
-				 NUMA_NO_NODE, __builtin_return_address(0));
-	if (p && (kasan_alloc_module_shadow(p, size, gfp_mask) < 0)) {
-		vfree(p);
-		return NULL;
-	}
-	return p;
+	unsigned long start = MODULES_VADDR + get_module_load_offset();
+
+	execmem_params.modules.text.start = start;
+	execmem_params.modules.text.end = MODULES_END;
+
+	return &execmem_params;
 }
 
 #ifdef CONFIG_FUNCTION_TRACER
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index b05f62ee2344..cf9a7d0a8b62 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -19,6 +19,7 @@
 #include <linux/jump_label.h>
 #include <linux/random.h>
 #include <linux/memory.h>
+#include <linux/execmem.h>
 
 #include <asm/text-patching.h>
 #include <asm/page.h>
@@ -65,26 +66,24 @@ static unsigned long int get_module_load_offset(void)
 }
 #endif
 
-void *module_alloc(unsigned long size)
-{
-	gfp_t gfp_mask = GFP_KERNEL;
-	void *p;
-
-	if (PAGE_ALIGN(size) > MODULES_LEN)
-		return NULL;
+static struct execmem_params execmem_params = {
+	.modules = {
+		.flags = EXECMEM_KASAN_SHADOW,
+		.text = {
+			.alignment = MODULE_ALIGN,
+		},
+	},
+};
 
-	p = __vmalloc_node_range(size, MODULE_ALIGN,
-				 MODULES_VADDR + get_module_load_offset(),
-				 MODULES_END, gfp_mask, PAGE_KERNEL,
-				 VM_FLUSH_RESET_PERMS | VM_DEFER_KMEMLEAK,
-				 NUMA_NO_NODE, __builtin_return_address(0));
+struct execmem_params __init *execmem_arch_params(void)
+{
+	unsigned long start = MODULES_VADDR + get_module_load_offset();
 
-	if (p && (kasan_alloc_module_shadow(p, size, gfp_mask) < 0)) {
-		vfree(p);
-		return NULL;
-	}
+	execmem_params.modules.text.start = start;
+	execmem_params.modules.text.end = MODULES_END;
+	execmem_params.modules.text.pgprot = PAGE_KERNEL;
 
-	return p;
+	return &execmem_params;
 }
 
 #ifdef CONFIG_X86_32
diff --git a/include/linux/execmem.h b/include/linux/execmem.h
index 75946f23731e..68b2bfc79993 100644
--- a/include/linux/execmem.h
+++ b/include/linux/execmem.h
@@ -9,22 +9,36 @@
  *			  related data allocations
  * @start:	address space start
  * @end:	address space end (inclusive)
+ * @fallback_start:	start of the range for fallback allocations
+ * @fallback_end:	end of the range for fallback allocations (inclusive)
  * @pgprot:	permisssions for memory in this address space
  * @alignment:	alignment required for text allocations
  */
 struct execmem_range {
 	unsigned long   start;
 	unsigned long   end;
+	unsigned long   fallback_start;
+	unsigned long   fallback_end;
 	pgprot_t        pgprot;
 	unsigned int	alignment;
 };
 
+/**
+ * enum execmem_module_flags - options for executable memory allocations
+ * @EXECMEM_KASAN_SHADOW:	allocate kasan shadow
+ */
+enum execmem_module_flags {
+	EXECMEM_KASAN_SHADOW	= (1 << 0),
+};
+
 /**
  * struct execmem_modules_range - architecure parameters for modules address
  *				  space
+ * @flags:	options for module memory allocations
  * @text:	address range for text allocations
  */
 struct execmem_modules_range {
+	enum execmem_module_flags flags;
 	struct execmem_range text;
 };
 
diff --git a/mm/execmem.c b/mm/execmem.c
index c92878cf4d1a..2fe36dcc7bdf 100644
--- a/mm/execmem.c
+++ b/mm/execmem.c
@@ -7,12 +7,46 @@
 
 struct execmem_params execmem_params;
 
-static void *execmem_alloc(size_t size, unsigned long start, unsigned long end,
-			   unsigned int align, pgprot_t pgprot)
+static void *execmem_alloc(size_t len, unsigned long start, unsigned long end,
+			   unsigned int alignment, pgprot_t pgprot,
+			   unsigned long fallback_start,
+			   unsigned long fallback_end,
+			   bool kasan)
 {
-	return __vmalloc_node_range(size, align, start, end,
-				   GFP_KERNEL, pgprot, VM_FLUSH_RESET_PERMS,
-				   NUMA_NO_NODE, __builtin_return_address(0));
+	unsigned long vm_flags  = VM_FLUSH_RESET_PERMS;
+	bool fallback  = !!fallback_start;
+	gfp_t gfp_flags = GFP_KERNEL;
+	void *p;
+
+	if (PAGE_ALIGN(len) > (end - start))
+		return NULL;
+
+	if (kasan)
+		vm_flags |= VM_DEFER_KMEMLEAK;
+
+	if (fallback)
+		gfp_flags |= __GFP_NOWARN;
+
+	p = __vmalloc_node_range(len, alignment, start, end, gfp_flags,
+				 pgprot, vm_flags, NUMA_NO_NODE,
+				 __builtin_return_address(0));
+
+	if (!p && fallback) {
+		start = fallback_start;
+		end = fallback_end;
+		gfp_flags = GFP_KERNEL;
+
+		p = __vmalloc_node_range(len, alignment, start, end, gfp_flags,
+					 pgprot, vm_flags, NUMA_NO_NODE,
+					 __builtin_return_address(0));
+	}
+
+	if (p && kasan && (kasan_alloc_module_shadow(p, len, GFP_KERNEL) < 0)) {
+		vfree(p);
+		return NULL;
+	}
+
+	return kasan_reset_tag(p);
 }
 
 void *execmem_text_alloc(size_t size)
@@ -21,11 +55,15 @@ void *execmem_text_alloc(size_t size)
 	unsigned long end = execmem_params.modules.text.end;
 	pgprot_t pgprot = execmem_params.modules.text.pgprot;
 	unsigned int align = execmem_params.modules.text.alignment;
+	unsigned long fallback_start = execmem_params.modules.text.fallback_start;
+	unsigned long fallback_end = execmem_params.modules.text.fallback_end;
+	bool kasan = execmem_params.modules.flags & EXECMEM_KASAN_SHADOW;
 
 	if (!execmem_params.modules.text.start)
 		return module_alloc(size);
 
-	return execmem_alloc(size, start, end, align, pgprot);
+	return execmem_alloc(size, start, end, align, pgprot,
+			     fallback_start, fallback_end, kasan);
 }
 
 void execmem_free(void *ptr)
-- 
2.35.1


