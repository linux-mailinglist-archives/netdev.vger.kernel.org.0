Return-Path: <netdev+bounces-7056-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7882F7198CD
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 12:15:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0740A1C2103D
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 10:15:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F12B320987;
	Thu,  1 Jun 2023 10:13:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD7B21063;
	Thu,  1 Jun 2023 10:13:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229F2C433A8;
	Thu,  1 Jun 2023 10:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685614432;
	bh=HaJHvmjJm3n7Yg/0FaBiemHWgA4YPxT3HAblRI/Uz4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LdrjCQ0+/lXdhnRJVytFJCwdKsIera/w9qwEJlLuUMq41Spk6rh/hM7K6Dz5cKjL3
	 zK1d/UUN2LmkQBogNk6fkdfwf95nnlpzrf0z6eEUjm8TozuCF8pg8VQCy/gwBYJVK4
	 cp1Z/V5F40WUgN6ffBhwpWe9cemeLNQh81+dZVYJIOjkiytvV4Ye2qRVPpQxrl6PGj
	 06F+V7vzr+EIMZuyURZfUtY3LI+aMYKcVB+PkRGPaS3AXvK1cccMn7aFfMTiwuqxKv
	 8FBRgzGtGFEBNDnbxcU55bXJcZG9QLdw3xiQgvvAgMETCkv+VvGJoBN5XdepG2AFjC
	 o9JNzmxAPlv2Q==
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
Subject: [PATCH 04/13] mm/jitalloc, arch: convert remaining overrides of module_alloc to jitalloc
Date: Thu,  1 Jun 2023 13:12:48 +0300
Message-Id: <20230601101257.530867-5-rppt@kernel.org>
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

Extend jitalloc parameters to accommodate more complex overrides of
module_alloc() by architectures.

This includes specification of a fallback range required by arm, arm64
and powerpc and support for allocation of KASAN shadow required by
arm64, s390 and x86.

The core implementation of jit_alloc() takes care of suppressing warnings
when the initial allocation fails but there is a fallback range defined.

Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
---
 arch/arm/kernel/module.c     | 32 ++++++++++----------
 arch/arm64/kernel/module.c   | 57 ++++++++++++++++--------------------
 arch/powerpc/kernel/module.c | 46 +++++++++++++----------------
 arch/s390/kernel/module.c    | 31 ++++++++------------
 arch/x86/kernel/module.c     | 29 +++++++-----------
 include/linux/jitalloc.h     | 14 +++++++++
 mm/jitalloc.c                | 44 ++++++++++++++++++++++++----
 7 files changed, 138 insertions(+), 115 deletions(-)

diff --git a/arch/arm/kernel/module.c b/arch/arm/kernel/module.c
index d59c36dc0494..83ccbf98164f 100644
--- a/arch/arm/kernel/module.c
+++ b/arch/arm/kernel/module.c
@@ -16,6 +16,7 @@
 #include <linux/fs.h>
 #include <linux/string.h>
 #include <linux/gfp.h>
+#include <linux/jitalloc.h>
 
 #include <asm/sections.h>
 #include <asm/smp_plat.h>
@@ -34,23 +35,22 @@
 #endif
 
 #ifdef CONFIG_MMU
-void *module_alloc(unsigned long size)
+static struct jit_alloc_params jit_alloc_params = {
+	.alignment	= 1,
+	.text.start	= MODULES_VADDR,
+	.text.end	= MODULES_END,
+};
+
+struct jit_alloc_params *jit_alloc_arch_params(void)
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
+	jit_alloc_params.text.pgprot = PAGE_KERNEL_EXEC;
+
+	if (IS_ENABLED(CONFIG_ARM_MODULE_PLTS)) {
+		jit_alloc_params.text.fallback_start = VMALLOC_START;
+		jit_alloc_params.text.fallback_end = VMALLOC_END;
+	}
+
+	return &jit_alloc_params;
 }
 #endif
 
diff --git a/arch/arm64/kernel/module.c b/arch/arm64/kernel/module.c
index 5af4975caeb5..ecf1f4030317 100644
--- a/arch/arm64/kernel/module.c
+++ b/arch/arm64/kernel/module.c
@@ -17,56 +17,49 @@
 #include <linux/moduleloader.h>
 #include <linux/scs.h>
 #include <linux/vmalloc.h>
+#include <linux/jitalloc.h>
 #include <asm/alternative.h>
 #include <asm/insn.h>
 #include <asm/scs.h>
 #include <asm/sections.h>
 
-void *module_alloc(unsigned long size)
+static struct jit_alloc_params jit_alloc_params = {
+	.alignment	= MODULE_ALIGN,
+	.flags		= JIT_ALLOC_KASAN_SHADOW,
+};
+
+struct jit_alloc_params *jit_alloc_arch_params(void)
 {
 	u64 module_alloc_end = module_alloc_base + MODULES_VSIZE;
-	gfp_t gfp_mask = GFP_KERNEL;
-	void *p;
-
-	/* Silence the initial allocation */
-	if (IS_ENABLED(CONFIG_ARM64_MODULE_PLTS))
-		gfp_mask |= __GFP_NOWARN;
 
 	if (IS_ENABLED(CONFIG_KASAN_GENERIC) ||
 	    IS_ENABLED(CONFIG_KASAN_SW_TAGS))
 		/* don't exceed the static module region - see below */
 		module_alloc_end = MODULES_END;
 
-	p = __vmalloc_node_range(size, MODULE_ALIGN, module_alloc_base,
-				module_alloc_end, gfp_mask, PAGE_KERNEL, VM_DEFER_KMEMLEAK,
-				NUMA_NO_NODE, __builtin_return_address(0));
+	jit_alloc_params.text.pgprot = PAGE_KERNEL;
+	jit_alloc_params.text.start = module_alloc_base;
+	jit_alloc_params.text.end = module_alloc_end;
 
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
+		jit_alloc_params.text.fallback_start = module_alloc_base;
+		jit_alloc_params.text.fallback_end = module_alloc_base + SZ_2G;
 	}
 
-	/* Memory is intended to be executable, reset the pointer tag. */
-	return kasan_reset_tag(p);
+	return &jit_alloc_params;
 }
 
 enum aarch64_reloc_op {
diff --git a/arch/powerpc/kernel/module.c b/arch/powerpc/kernel/module.c
index f6d6ae0a1692..83bdedc7eba0 100644
--- a/arch/powerpc/kernel/module.c
+++ b/arch/powerpc/kernel/module.c
@@ -12,6 +12,7 @@
 #include <linux/bug.h>
 #include <asm/module.h>
 #include <linux/uaccess.h>
+#include <linux/jitalloc.h>
 #include <asm/firmware.h>
 #include <linux/sort.h>
 #include <asm/setup.h>
@@ -89,39 +90,32 @@ int module_finalize(const Elf_Ehdr *hdr,
 	return 0;
 }
 
-static __always_inline void *
-__module_alloc(unsigned long size, unsigned long start, unsigned long end, bool nowarn)
-{
-	pgprot_t prot = strict_module_rwx_enabled() ? PAGE_KERNEL : PAGE_KERNEL_EXEC;
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
+static struct jit_alloc_params jit_alloc_params = {
+	.alignment	= 1,
+};
 
-void *module_alloc(unsigned long size)
+struct jit_alloc_params *jit_alloc_arch_params(void)
 {
 #ifdef MODULES_VADDR
+	pgprot_t prot = strict_module_rwx_enabled() ? PAGE_KERNEL : PAGE_KERNEL_EXEC;
 	unsigned long limit = (unsigned long)_etext - SZ_32M;
-	void *ptr = NULL;
 
-	BUILD_BUG_ON(TASK_SIZE > MODULES_VADDR);
+	jit_alloc_params.text.pgprot = prot;
 
 	/* First try within 32M limit from _etext to avoid branch trampolines */
-	if (MODULES_VADDR < PAGE_OFFSET && MODULES_END > limit)
-		ptr = __module_alloc(size, limit, MODULES_END, true);
-
-	if (!ptr)
-		ptr = __module_alloc(size, MODULES_VADDR, MODULES_END, false);
-
-	return ptr;
+	if (MODULES_VADDR < PAGE_OFFSET && MODULES_END > limit) {
+		jit_alloc_params.text.start = limit;
+		jit_alloc_params.text.end = MODULES_END;
+		jit_alloc_params.text.fallback_start = MODULES_VADDR;
+		jit_alloc_params.text.fallback_end = MODULES_END;
+	} else {
+		jit_alloc_params.text.start = MODULES_VADDR;
+		jit_alloc_params.text.end = MODULES_END;
+	}
 #else
-	return __module_alloc(size, VMALLOC_START, VMALLOC_END, false);
+	jit_alloc_params.text.start = VMALLOC_START;
+	jit_alloc_params.text.end = VMALLOC_END;
 #endif
+
+	return &jit_alloc_params;
 }
diff --git a/arch/s390/kernel/module.c b/arch/s390/kernel/module.c
index d4844cfe3d7e..0986a1a1b261 100644
--- a/arch/s390/kernel/module.c
+++ b/arch/s390/kernel/module.c
@@ -55,23 +55,18 @@ static unsigned long get_module_load_offset(void)
 	return module_load_offset;
 }
 
-void *module_alloc(unsigned long size)
+static struct jit_alloc_params jit_alloc_params = {
+	.alignment	= MODULE_ALIGN,
+	.flags		= JIT_ALLOC_KASAN_SHADOW,
+	.text.pgprot	= PAGE_KERNEL,
+};
+
+struct jit_alloc_params *jit_alloc_arch_params(void)
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
+	jit_alloc_params.text.start = MODULES_VADDR + get_module_load_offset();
+	jit_alloc_params.text.end = MODULES_END;
+
+	return &jit_alloc_params;
 }
 
 #ifdef CONFIG_FUNCTION_TRACER
@@ -130,7 +125,7 @@ static void check_rela(Elf_Rela *rela, struct module *me)
 	case R_390_GLOB_DAT:
 	case R_390_JMP_SLOT:
 	case R_390_RELATIVE:
-		/* Only needed if we want to support loading of 
+		/* Only needed if we want to support loading of
 		   modules linked with -shared. */
 		break;
 	}
@@ -442,7 +437,7 @@ static int apply_rela(Elf_Rela *rela, Elf_Addr base, Elf_Sym *symtab,
 	case R_390_GLOB_DAT:	/* Create GOT entry.  */
 	case R_390_JMP_SLOT:	/* Create PLT entry.  */
 	case R_390_RELATIVE:	/* Adjust by program base.  */
-		/* Only needed if we want to support loading of 
+		/* Only needed if we want to support loading of
 		   modules linked with -shared. */
 		return -ENOEXEC;
 	default:
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index b05f62ee2344..cce84b61a036 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -19,6 +19,7 @@
 #include <linux/jump_label.h>
 #include <linux/random.h>
 #include <linux/memory.h>
+#include <linux/jitalloc.h>
 
 #include <asm/text-patching.h>
 #include <asm/page.h>
@@ -65,26 +66,18 @@ static unsigned long int get_module_load_offset(void)
 }
 #endif
 
-void *module_alloc(unsigned long size)
-{
-	gfp_t gfp_mask = GFP_KERNEL;
-	void *p;
-
-	if (PAGE_ALIGN(size) > MODULES_LEN)
-		return NULL;
-
-	p = __vmalloc_node_range(size, MODULE_ALIGN,
-				 MODULES_VADDR + get_module_load_offset(),
-				 MODULES_END, gfp_mask, PAGE_KERNEL,
-				 VM_FLUSH_RESET_PERMS | VM_DEFER_KMEMLEAK,
-				 NUMA_NO_NODE, __builtin_return_address(0));
+static struct jit_alloc_params jit_alloc_params = {
+	.alignment	= MODULE_ALIGN,
+	.flags		= JIT_ALLOC_KASAN_SHADOW,
+};
 
-	if (p && (kasan_alloc_module_shadow(p, size, gfp_mask) < 0)) {
-		vfree(p);
-		return NULL;
-	}
+struct jit_alloc_params *jit_alloc_arch_params(void)
+{
+	jit_alloc_params.text.pgprot = PAGE_KERNEL;
+	jit_alloc_params.text.start = MODULES_VADDR + get_module_load_offset();
+	jit_alloc_params.text.end = MODULES_END;
 
-	return p;
+	return &jit_alloc_params;
 }
 
 #ifdef CONFIG_X86_32
diff --git a/include/linux/jitalloc.h b/include/linux/jitalloc.h
index 34fddef23dea..34ee57795a18 100644
--- a/include/linux/jitalloc.h
+++ b/include/linux/jitalloc.h
@@ -4,26 +4,40 @@
 
 #include <linux/types.h>
 
+/**
+ * enum jit_alloc_flags - options for executable memory allocations
+ * @JIT_ALLOC_KASAN_SHADOW:	allocate kasan shadow
+ */
+enum jit_alloc_flags {
+	JIT_ALLOC_KASAN_SHADOW	= (1 << 0),
+};
+
 /**
  * struct jit_address_space -	address space definition for code and
  *				related data allocations
  * @pgprot:	permisssions for memory in this address space
  * @start:	address space start
  * @end:	address space end (inclusive)
+ * @fallback_start:	start of the range for fallback allocations
+ * @fallback_end:	end of the range for fallback allocations (inclusive)
  */
 struct jit_address_space {
 	pgprot_t        pgprot;
 	unsigned long   start;
 	unsigned long   end;
+	unsigned long	fallback_start;
+	unsigned long	fallback_end;
 };
 
 /**
  * struct jit_alloc_params -	architecure parameters for code allocations
  * @text:	address space range for text allocations
+ * @flags:	options for executable memory allocations
  * @alignment:	alignment required for text allocations
  */
 struct jit_alloc_params {
 	struct jit_address_space	text;
+	enum jit_alloc_flags		flags;
 	unsigned int			alignment;
 };
 
diff --git a/mm/jitalloc.c b/mm/jitalloc.c
index 3e63eeb8bf4b..4e10af7803f7 100644
--- a/mm/jitalloc.c
+++ b/mm/jitalloc.c
@@ -8,14 +8,44 @@
 static struct jit_alloc_params jit_alloc_params;
 
 static void *jit_alloc(size_t len, unsigned int alignment, pgprot_t pgprot,
-		       unsigned long start, unsigned long end)
+		       unsigned long start, unsigned long end,
+		       unsigned long fallback_start, unsigned long fallback_end,
+		       bool kasan)
 {
+	unsigned long vm_flags  = VM_FLUSH_RESET_PERMS;
+	bool fallback  = !!fallback_start;
+	gfp_t gfp_flags = GFP_KERNEL;
+	void *p;
+
 	if (PAGE_ALIGN(len) > (end - start))
 		return NULL;
 
-	return __vmalloc_node_range(len, alignment, start, end, GFP_KERNEL,
-				    pgprot, VM_FLUSH_RESET_PERMS,
-				    NUMA_NO_NODE, __builtin_return_address(0));
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
 
 void jit_free(void *buf)
@@ -35,8 +65,12 @@ void *jit_text_alloc(size_t len)
 		pgprot_t pgprot = jit_alloc_params.text.pgprot;
 		unsigned long start = jit_alloc_params.text.start;
 		unsigned long end = jit_alloc_params.text.end;
+		unsigned long fallback_start = jit_alloc_params.text.fallback_start;
+		unsigned long fallback_end = jit_alloc_params.text.fallback_end;
+		bool kasan = jit_alloc_params.flags & JIT_ALLOC_KASAN_SHADOW;
 
-		return jit_alloc(len, align, pgprot, start, end);
+		return jit_alloc(len, align, pgprot, start, end,
+				 fallback_start, fallback_end, kasan);
 	}
 
 	return module_alloc(len);
-- 
2.35.1


