Return-Path: <netdev+bounces-7055-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE4D47198C6
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 12:14:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E6E41C20FC2
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 10:14:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 637362068A;
	Thu,  1 Jun 2023 10:13:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C852320987;
	Thu,  1 Jun 2023 10:13:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 121DDC433AC;
	Thu,  1 Jun 2023 10:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685614423;
	bh=PCR9jMvsF9DNujMmvTpCO2CeEfkl+JIa318zEz8GWMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EIfSwvr3iCTBTyvnNRlSQ0aSeOsNP/teI+gBU+A2SPD9KInN/koHSn+jzWtaMUGOa
	 RYSTeuVaZEqbkGqbYbSJ+PcLdbn4QS1A9fFt/DwZD1xvGy1F8A8VmNTVMfJoT2c7hV
	 5x27DaivAPn98TSDP5otud6RVOY71CXQhBKSwjC5Ubt9kYtoVuxgl45GFZAUBB6EpQ
	 twMBZugkK4pp5EKeIgpG+Cqk1+rNM9APsrRkEsdBtvLTI010KPz56lwMPKdDwKmexe
	 jBAzp/rjLQ6E1zc8npmXEaDOjE6BXPetbU0VinmLZE6qehY7joXyvIM9qFNEJJxP3o
	 UVMwSvUOnZGdA==
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
Subject: [PATCH 03/13] mm/jitalloc, arch: convert simple overrides of module_alloc to jitalloc
Date: Thu,  1 Jun 2023 13:12:47 +0300
Message-Id: <20230601101257.530867-4-rppt@kernel.org>
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

Several architectures override module_alloc() only to define address
range for code allocations different than VMALLOC address space.

Provide a generic implementation in jitalloc that uses the parameters
for address space ranges, required alignment and page protections
provided by architectures.

The architecures must fill jit_alloc_params structure and implement
jit_alloc_arch_params() that returns a pointer to that structure. This
way the jitalloc initialization won't be called from every architecure,
but rather from a central place, namely initialization of the core
memory management.

Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
---
 arch/loongarch/kernel/module.c | 14 ++++++++--
 arch/mips/kernel/module.c      | 16 ++++++++---
 arch/nios2/kernel/module.c     | 15 ++++++----
 arch/parisc/kernel/module.c    | 18 ++++++++----
 arch/riscv/kernel/module.c     | 16 +++++++----
 arch/sparc/kernel/module.c     | 39 +++++++++++---------------
 include/linux/jitalloc.h       | 31 +++++++++++++++++++++
 mm/jitalloc.c                  | 51 ++++++++++++++++++++++++++++++++++
 mm/mm_init.c                   |  2 ++
 9 files changed, 156 insertions(+), 46 deletions(-)

diff --git a/arch/loongarch/kernel/module.c b/arch/loongarch/kernel/module.c
index b8b86088b2dd..1d5e00874ae7 100644
--- a/arch/loongarch/kernel/module.c
+++ b/arch/loongarch/kernel/module.c
@@ -18,6 +18,7 @@
 #include <linux/ftrace.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
+#include <linux/jitalloc.h>
 #include <asm/alternative.h>
 #include <asm/inst.h>
 
@@ -469,10 +470,17 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
 	return 0;
 }
 
-void *module_alloc(unsigned long size)
+static struct jit_alloc_params jit_alloc_params = {
+	.alignment	= 1,
+	.text.pgprot	= PAGE_KERNEL,
+};
+
+struct jit_alloc_params *jit_alloc_arch_params(void)
 {
-	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
-			GFP_KERNEL, PAGE_KERNEL, 0, NUMA_NO_NODE, __builtin_return_address(0));
+	jit_alloc_params.text.start = MODULES_VADDR;
+	jit_alloc_params.text.end = MODULES_END;
+
+	return &jit_alloc_params;
 }
 
 static void module_init_ftrace_plt(const Elf_Ehdr *hdr,
diff --git a/arch/mips/kernel/module.c b/arch/mips/kernel/module.c
index 0c936cbf20c5..f762c697ab9c 100644
--- a/arch/mips/kernel/module.c
+++ b/arch/mips/kernel/module.c
@@ -20,6 +20,7 @@
 #include <linux/kernel.h>
 #include <linux/spinlock.h>
 #include <linux/jump_label.h>
+#include <linux/jitalloc.h>
 
 extern void jump_label_apply_nops(struct module *mod);
 
@@ -33,11 +34,18 @@ static LIST_HEAD(dbe_list);
 static DEFINE_SPINLOCK(dbe_lock);
 
 #ifdef MODULE_START
-void *module_alloc(unsigned long size)
+
+static struct jit_alloc_params jit_alloc_params = {
+	.alignment	= 1,
+	.text.start	= MODULE_START,
+	.text.end	= MODULE_END,
+};
+
+struct jit_alloc_params *jit_alloc_arch_params(void)
 {
-	return __vmalloc_node_range(size, 1, MODULE_START, MODULE_END,
-				GFP_KERNEL, PAGE_KERNEL, 0, NUMA_NO_NODE,
-				__builtin_return_address(0));
+	jit_alloc_params.text.pgprot = PAGE_KERNEL;
+
+	return &jit_alloc_params;
 }
 #endif
 
diff --git a/arch/nios2/kernel/module.c b/arch/nios2/kernel/module.c
index 9c97b7513853..b41d52775ec2 100644
--- a/arch/nios2/kernel/module.c
+++ b/arch/nios2/kernel/module.c
@@ -18,15 +18,20 @@
 #include <linux/fs.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
+#include <linux/jitalloc.h>
 
 #include <asm/cacheflush.h>
 
-void *module_alloc(unsigned long size)
+static struct jit_alloc_params jit_alloc_params = {
+	.alignment	= 1,
+	.text.pgprot	= PAGE_KERNEL_EXEC,
+	.text.start	= MODULES_VADDR,
+	.text.end	= MODULES_END,
+};
+
+struct jit_alloc_params *jit_alloc_arch_params(void)
 {
-	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
-				    GFP_KERNEL, PAGE_KERNEL_EXEC,
-				    VM_FLUSH_RESET_PERMS, NUMA_NO_NODE,
-				    __builtin_return_address(0));
+	return &jit_alloc_params;
 }
 
 int apply_relocate_add(Elf32_Shdr *sechdrs, const char *strtab,
diff --git a/arch/parisc/kernel/module.c b/arch/parisc/kernel/module.c
index f6e38c4d3904..49fdf741fd24 100644
--- a/arch/parisc/kernel/module.c
+++ b/arch/parisc/kernel/module.c
@@ -49,6 +49,7 @@
 #include <linux/bug.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include <linux/jitalloc.h>
 
 #include <asm/unwind.h>
 #include <asm/sections.h>
@@ -173,15 +174,20 @@ static inline int reassemble_22(int as22)
 		((as22 & 0x0003ff) << 3));
 }
 
-void *module_alloc(unsigned long size)
-{
+static struct jit_alloc_params jit_alloc_params = {
+	.alignment	= 1,
 	/* using RWX means less protection for modules, but it's
 	 * easier than trying to map the text, data, init_text and
 	 * init_data correctly */
-	return __vmalloc_node_range(size, 1, VMALLOC_START, VMALLOC_END,
-				    GFP_KERNEL,
-				    PAGE_KERNEL_RWX, 0, NUMA_NO_NODE,
-				    __builtin_return_address(0));
+	.text.pgprot	= PAGE_KERNEL_RWX,
+	.text.end	= VMALLOC_END,
+};
+
+struct jit_alloc_params *jit_alloc_arch_params(void)
+{
+	jit_alloc_params.text.start = VMALLOC_START;
+
+	return &jit_alloc_params;
 }
 
 #ifndef CONFIG_64BIT
diff --git a/arch/riscv/kernel/module.c b/arch/riscv/kernel/module.c
index 7c651d55fcbd..731255654c94 100644
--- a/arch/riscv/kernel/module.c
+++ b/arch/riscv/kernel/module.c
@@ -11,6 +11,7 @@
 #include <linux/vmalloc.h>
 #include <linux/sizes.h>
 #include <linux/pgtable.h>
+#include <linux/jitalloc.h>
 #include <asm/alternative.h>
 #include <asm/sections.h>
 
@@ -436,12 +437,17 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
 }
 
 #if defined(CONFIG_MMU) && defined(CONFIG_64BIT)
-void *module_alloc(unsigned long size)
+static struct jit_alloc_params jit_alloc_params = {
+	.alignment	= 1,
+	.text.pgprot	= PAGE_KERNEL,
+};
+
+struct jit_alloc_params *jit_alloc_arch_params(void)
 {
-	return __vmalloc_node_range(size, 1, MODULES_VADDR,
-				    MODULES_END, GFP_KERNEL,
-				    PAGE_KERNEL, 0, NUMA_NO_NODE,
-				    __builtin_return_address(0));
+	jit_alloc_params.text.start = MODULES_VADDR;
+	jit_alloc_params.text.end = MODULES_END;
+
+	return &jit_alloc_params;
 }
 #endif
 
diff --git a/arch/sparc/kernel/module.c b/arch/sparc/kernel/module.c
index 66c45a2764bc..03f0de693b4d 100644
--- a/arch/sparc/kernel/module.c
+++ b/arch/sparc/kernel/module.c
@@ -14,6 +14,11 @@
 #include <linux/string.h>
 #include <linux/ctype.h>
 #include <linux/mm.h>
+#include <linux/jitalloc.h>
+
+#ifdef CONFIG_SPARC64
+#include <linux/jump_label.h>
+#endif
 
 #include <asm/processor.h>
 #include <asm/spitfire.h>
@@ -21,34 +26,22 @@
 
 #include "entry.h"
 
+static struct jit_alloc_params jit_alloc_params = {
+	.alignment	= 1,
 #ifdef CONFIG_SPARC64
-
-#include <linux/jump_label.h>
-
-static void *module_map(unsigned long size)
-{
-	if (PAGE_ALIGN(size) > MODULES_LEN)
-		return NULL;
-	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
-				GFP_KERNEL, PAGE_KERNEL, 0, NUMA_NO_NODE,
-				__builtin_return_address(0));
-}
+	.text.start	= MODULES_VADDR,
+	.text.end	= MODULES_END,
 #else
-static void *module_map(unsigned long size)
-{
-	return vmalloc(size);
-}
-#endif /* CONFIG_SPARC64 */
+	.text.start	= VMALLOC_START,
+	.text.end	= VMALLOC_END,
+#endif
+};
 
-void *module_alloc(unsigned long size)
+struct jit_alloc_params *jit_alloc_arch_params(void)
 {
-	void *ret;
-
-	ret = module_map(size);
-	if (ret)
-		memset(ret, 0, size);
+	jit_alloc_params.text.pgprot = PAGE_KERNEL;
 
-	return ret;
+	return &jit_alloc_params;
 }
 
 /* Make generic code ignore STT_REGISTER dummy undefined symbols.  */
diff --git a/include/linux/jitalloc.h b/include/linux/jitalloc.h
index 9517e64e474d..34fddef23dea 100644
--- a/include/linux/jitalloc.h
+++ b/include/linux/jitalloc.h
@@ -4,7 +4,38 @@
 
 #include <linux/types.h>
 
+/**
+ * struct jit_address_space -	address space definition for code and
+ *				related data allocations
+ * @pgprot:	permisssions for memory in this address space
+ * @start:	address space start
+ * @end:	address space end (inclusive)
+ */
+struct jit_address_space {
+	pgprot_t        pgprot;
+	unsigned long   start;
+	unsigned long   end;
+};
+
+/**
+ * struct jit_alloc_params -	architecure parameters for code allocations
+ * @text:	address space range for text allocations
+ * @alignment:	alignment required for text allocations
+ */
+struct jit_alloc_params {
+	struct jit_address_space	text;
+	unsigned int			alignment;
+};
+
+struct jit_alloc_params *jit_alloc_arch_params(void);
+
 void jit_free(void *buf);
 void *jit_text_alloc(size_t len);
 
+#ifdef CONFIG_JIT_ALLOC
+void jit_alloc_init(void);
+#else
+static inline void jit_alloc_init(void) {}
+#endif
+
 #endif /* _LINUX_JITALLOC_H */
diff --git a/mm/jitalloc.c b/mm/jitalloc.c
index f15262202a1a..3e63eeb8bf4b 100644
--- a/mm/jitalloc.c
+++ b/mm/jitalloc.c
@@ -2,8 +2,22 @@
 
 #include <linux/moduleloader.h>
 #include <linux/vmalloc.h>
+#include <linux/mm.h>
 #include <linux/jitalloc.h>
 
+static struct jit_alloc_params jit_alloc_params;
+
+static void *jit_alloc(size_t len, unsigned int alignment, pgprot_t pgprot,
+		       unsigned long start, unsigned long end)
+{
+	if (PAGE_ALIGN(len) > (end - start))
+		return NULL;
+
+	return __vmalloc_node_range(len, alignment, start, end, GFP_KERNEL,
+				    pgprot, VM_FLUSH_RESET_PERMS,
+				    NUMA_NO_NODE, __builtin_return_address(0));
+}
+
 void jit_free(void *buf)
 {
 	/*
@@ -16,5 +30,42 @@ void jit_free(void *buf)
 
 void *jit_text_alloc(size_t len)
 {
+	if (jit_alloc_params.text.start) {
+		unsigned int align = jit_alloc_params.alignment;
+		pgprot_t pgprot = jit_alloc_params.text.pgprot;
+		unsigned long start = jit_alloc_params.text.start;
+		unsigned long end = jit_alloc_params.text.end;
+
+		return jit_alloc(len, align, pgprot, start, end);
+	}
+
 	return module_alloc(len);
 }
+
+struct jit_alloc_params * __weak jit_alloc_arch_params(void)
+{
+	return NULL;
+}
+
+static bool jit_alloc_validate_params(struct jit_alloc_params *p)
+{
+	if (!p->alignment || !p->text.start || !p->text.end ||
+	    !pgprot_val(p->text.pgprot)) {
+		pr_crit("Invalid parameters for jit allocator, module loading will fail");
+		return false;
+	}
+
+	return true;
+}
+
+void jit_alloc_init(void)
+{
+	struct jit_alloc_params *p = jit_alloc_arch_params();
+
+	if (p) {
+		if (!jit_alloc_validate_params(p))
+			return;
+
+		jit_alloc_params = *p;
+	}
+}
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 7f7f9c677854..5f50e75bbc5f 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -26,6 +26,7 @@
 #include <linux/pgtable.h>
 #include <linux/swap.h>
 #include <linux/cma.h>
+#include <linux/jitalloc.h>
 #include "internal.h"
 #include "slab.h"
 #include "shuffle.h"
@@ -2747,4 +2748,5 @@ void __init mm_core_init(void)
 	pti_init();
 	kmsan_init_runtime();
 	mm_cache_init();
+	jit_alloc_init();
 }
-- 
2.35.1


