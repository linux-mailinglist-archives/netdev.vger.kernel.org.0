Return-Path: <netdev+bounces-11333-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 741E2732A5D
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:52:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A39D2816C9
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 08:52:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88BABC2F9;
	Fri, 16 Jun 2023 08:51:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7F6DF46;
	Fri, 16 Jun 2023 08:51:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC877C433CB;
	Fri, 16 Jun 2023 08:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686905488;
	bh=pb8Z4rxsM0yBpjwRPF1Qed87z579BhooyvNuy+PUQCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SB9uDtnNDYLKu1T9LikI8QGyk91Nzx06vgv8rwiPKboDZQZmMqOcn4UlzXtreruPk
	 IFyNG1tHP4kqpcaojMY+WwqBpBgvZGKC2GFF4PAuO8fCCtOpIBo8PmzqHTi6KbgK73
	 E8Zs5OUs9eJKG/mrr0WWwxV2H7qcoVS31HbeyRMeQ7JIBRFRq4sIfCxe6b+CJGqeeA
	 +DtpOa5d/+cFTbC2ej+fiqSk/7GwiTNLf9BfBPjq+UV2jHQFYxRB/vqvw3HdLEoU+m
	 G/NhfI9yw9teIhVrb5dhTW3mSsQkx23Z8EHPvRYbvDQWf45wIQgURVj/iTJfL126kd
	 6MoFwW06K+J9Q==
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
Subject: [PATCH v2 03/12] mm/execmem, arch: convert simple overrides of module_alloc to execmem
Date: Fri, 16 Jun 2023 11:50:29 +0300
Message-Id: <20230616085038.4121892-4-rppt@kernel.org>
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

Several architectures override module_alloc() only to define address
range for code allocations different than VMALLOC address space.

Provide a generic implementation in execmem that uses the parameters
for address space ranges, required alignment and page protections
provided by architectures.

The architecures must fill execmem_params structure and implement
execmem_arch_params() that returns a pointer to that structure. This
way the execmem initialization won't be called from every architecure,
but rather from a central place, namely initialization of the core
memory management.

The execmem provides execmem_text_alloc() API that wraps
__vmalloc_node_range() with the parameters defined by the architecures.
If an architeture does not implement execmem_arch_params(),
execmem_text_alloc() will fall back to module_alloc().

The name execmem_text_alloc() emphasizes that the allocated memory is
for executable code, the allocations of the associated data, like data
sections of a module will use execmem_data_alloc() interface that will
be added later.

Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
---
 arch/loongarch/kernel/module.c | 18 ++++++++++--
 arch/mips/kernel/module.c      | 18 +++++++++---
 arch/nios2/kernel/module.c     | 19 +++++++++----
 arch/parisc/kernel/module.c    | 23 +++++++++------
 arch/riscv/kernel/module.c     | 20 +++++++++----
 arch/sparc/kernel/module.c     | 44 +++++++++++++---------------
 include/linux/execmem.h        | 52 ++++++++++++++++++++++++++++++++++
 mm/execmem.c                   | 52 +++++++++++++++++++++++++++++++---
 mm/mm_init.c                   |  2 ++
 9 files changed, 195 insertions(+), 53 deletions(-)

diff --git a/arch/loongarch/kernel/module.c b/arch/loongarch/kernel/module.c
index b8b86088b2dd..32b167722c2b 100644
--- a/arch/loongarch/kernel/module.c
+++ b/arch/loongarch/kernel/module.c
@@ -18,6 +18,7 @@
 #include <linux/ftrace.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
+#include <linux/execmem.h>
 #include <asm/alternative.h>
 #include <asm/inst.h>
 
@@ -469,10 +470,21 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
 	return 0;
 }
 
-void *module_alloc(unsigned long size)
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
 {
-	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
-			GFP_KERNEL, PAGE_KERNEL, 0, NUMA_NO_NODE, __builtin_return_address(0));
+	execmem_params.modules.text.start = MODULES_VADDR;
+	execmem_params.modules.text.end = MODULES_END;
+
+	return &execmem_params;
 }
 
 static void module_init_ftrace_plt(const Elf_Ehdr *hdr,
diff --git a/arch/mips/kernel/module.c b/arch/mips/kernel/module.c
index 0c936cbf20c5..2d370de67383 100644
--- a/arch/mips/kernel/module.c
+++ b/arch/mips/kernel/module.c
@@ -20,6 +20,7 @@
 #include <linux/kernel.h>
 #include <linux/spinlock.h>
 #include <linux/jump_label.h>
+#include <linux/execmem.h>
 
 extern void jump_label_apply_nops(struct module *mod);
 
@@ -33,11 +34,20 @@ static LIST_HEAD(dbe_list);
 static DEFINE_SPINLOCK(dbe_lock);
 
 #ifdef MODULE_START
-void *module_alloc(unsigned long size)
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
 {
-	return __vmalloc_node_range(size, 1, MODULE_START, MODULE_END,
-				GFP_KERNEL, PAGE_KERNEL, 0, NUMA_NO_NODE,
-				__builtin_return_address(0));
+	return &execmem_params;
 }
 #endif
 
diff --git a/arch/nios2/kernel/module.c b/arch/nios2/kernel/module.c
index 9c97b7513853..3cf5723e3c70 100644
--- a/arch/nios2/kernel/module.c
+++ b/arch/nios2/kernel/module.c
@@ -18,15 +18,24 @@
 #include <linux/fs.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
+#include <linux/execmem.h>
 
 #include <asm/cacheflush.h>
 
-void *module_alloc(unsigned long size)
+static struct execmem_params execmem_params = {
+	.modules = {
+		.text = {
+			.start = MODULES_VADDR,
+			.end = MODULES_END,
+			.pgprot = PAGE_KERNEL_EXEC,
+			.alignment = 1,
+		},
+	},
+};
+
+struct execmem_params __init *execmem_arch_params(void)
 {
-	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
-				    GFP_KERNEL, PAGE_KERNEL_EXEC,
-				    VM_FLUSH_RESET_PERMS, NUMA_NO_NODE,
-				    __builtin_return_address(0));
+	return &execmem_params;
 }
 
 int apply_relocate_add(Elf32_Shdr *sechdrs, const char *strtab,
diff --git a/arch/parisc/kernel/module.c b/arch/parisc/kernel/module.c
index f6e38c4d3904..569b8f52a24b 100644
--- a/arch/parisc/kernel/module.c
+++ b/arch/parisc/kernel/module.c
@@ -49,6 +49,7 @@
 #include <linux/bug.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include <linux/execmem.h>
 
 #include <asm/unwind.h>
 #include <asm/sections.h>
@@ -173,15 +174,21 @@ static inline int reassemble_22(int as22)
 		((as22 & 0x0003ff) << 3));
 }
 
-void *module_alloc(unsigned long size)
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
 {
-	/* using RWX means less protection for modules, but it's
-	 * easier than trying to map the text, data, init_text and
-	 * init_data correctly */
-	return __vmalloc_node_range(size, 1, VMALLOC_START, VMALLOC_END,
-				    GFP_KERNEL,
-				    PAGE_KERNEL_RWX, 0, NUMA_NO_NODE,
-				    __builtin_return_address(0));
+	execmem_params.modules.text.start = VMALLOC_START;
+	execmem_params.modules.text.end = VMALLOC_END;
+
+	return &execmem_params;
 }
 
 #ifndef CONFIG_64BIT
diff --git a/arch/riscv/kernel/module.c b/arch/riscv/kernel/module.c
index 7c651d55fcbd..ee5e04cd3f21 100644
--- a/arch/riscv/kernel/module.c
+++ b/arch/riscv/kernel/module.c
@@ -11,6 +11,7 @@
 #include <linux/vmalloc.h>
 #include <linux/sizes.h>
 #include <linux/pgtable.h>
+#include <linux/execmem.h>
 #include <asm/alternative.h>
 #include <asm/sections.h>
 
@@ -436,12 +437,21 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
 }
 
 #if defined(CONFIG_MMU) && defined(CONFIG_64BIT)
-void *module_alloc(unsigned long size)
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
 {
-	return __vmalloc_node_range(size, 1, MODULES_VADDR,
-				    MODULES_END, GFP_KERNEL,
-				    PAGE_KERNEL, 0, NUMA_NO_NODE,
-				    __builtin_return_address(0));
+	execmem_params.modules.text.start = MODULES_VADDR;
+	execmem_params.modules.text.end = MODULES_END;
+
+	return &execmem_params;
 }
 #endif
 
diff --git a/arch/sparc/kernel/module.c b/arch/sparc/kernel/module.c
index 66c45a2764bc..ab75e3e69834 100644
--- a/arch/sparc/kernel/module.c
+++ b/arch/sparc/kernel/module.c
@@ -14,6 +14,10 @@
 #include <linux/string.h>
 #include <linux/ctype.h>
 #include <linux/mm.h>
+#include <linux/execmem.h>
+#ifdef CONFIG_SPARC64
+#include <linux/jump_label.h>
+#endif
 
 #include <asm/processor.h>
 #include <asm/spitfire.h>
@@ -21,34 +25,26 @@
 
 #include "entry.h"
 
+static struct execmem_params execmem_params = {
+	.modules = {
+		.text = {
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
+			.start = MODULES_VADDR,
+			.end = MODULES_END,
 #else
-static void *module_map(unsigned long size)
-{
-	return vmalloc(size);
-}
-#endif /* CONFIG_SPARC64 */
-
-void *module_alloc(unsigned long size)
+			.start = VMALLOC_START,
+			.end = VMALLOC_END,
+#endif
+			.alignment = 1,
+		},
+	},
+};
+
+struct execmem_params __init *execmem_arch_params(void)
 {
-	void *ret;
-
-	ret = module_map(size);
-	if (ret)
-		memset(ret, 0, size);
+	execmem_params.modules.text.pgprot = PAGE_KERNEL;
 
-	return ret;
+	return &execmem_params;
 }
 
 /* Make generic code ignore STT_REGISTER dummy undefined symbols.  */
diff --git a/include/linux/execmem.h b/include/linux/execmem.h
index 0d4e5a6985f8..75946f23731e 100644
--- a/include/linux/execmem.h
+++ b/include/linux/execmem.h
@@ -4,6 +4,52 @@
 
 #include <linux/types.h>
 
+/**
+ * struct execmem_range - definition of a memory range suitable for code and
+ *			  related data allocations
+ * @start:	address space start
+ * @end:	address space end (inclusive)
+ * @pgprot:	permisssions for memory in this address space
+ * @alignment:	alignment required for text allocations
+ */
+struct execmem_range {
+	unsigned long   start;
+	unsigned long   end;
+	pgprot_t        pgprot;
+	unsigned int	alignment;
+};
+
+/**
+ * struct execmem_modules_range - architecure parameters for modules address
+ *				  space
+ * @text:	address range for text allocations
+ */
+struct execmem_modules_range {
+	struct execmem_range text;
+};
+
+/**
+ * struct execmem_params -	architecure parameters for code allocations
+ * @modules:	parameters for modules address space
+ */
+struct execmem_params {
+	struct execmem_modules_range	modules;
+};
+
+/**
+ * execmem_arch_params - supply parameters for allocations of executable memory
+ *
+ * A hook for architecures to define parameters for allocations of
+ * executable memory described by struct execmem_params
+ *
+ * For architectures that do not implement this method a default set of
+ * parameters will be used
+ *
+ * Return: a structure defining architecture parameters and restrictions
+ * for allocations of executable memory
+ */
+struct execmem_params *execmem_arch_params(void);
+
 /**
  * execmem_text_alloc - allocate executable memory
  * @size: how many bytes of memory are required
@@ -49,4 +95,10 @@ void *jit_text_alloc(size_t size);
  */
 void jit_free(void *ptr);
 
+#ifdef CONFIG_EXECMEM
+void execmem_init(void);
+#else
+static inline void execmem_init(void) {}
+#endif
+
 #endif /* _LINUX_EXECMEM_ALLOC_H */
diff --git a/mm/execmem.c b/mm/execmem.c
index eac26234eb38..c92878cf4d1a 100644
--- a/mm/execmem.c
+++ b/mm/execmem.c
@@ -5,14 +5,27 @@
 #include <linux/execmem.h>
 #include <linux/moduleloader.h>
 
-static void *execmem_alloc(size_t size)
+struct execmem_params execmem_params;
+
+static void *execmem_alloc(size_t size, unsigned long start, unsigned long end,
+			   unsigned int align, pgprot_t pgprot)
 {
-	return module_alloc(size);
+	return __vmalloc_node_range(size, align, start, end,
+				   GFP_KERNEL, pgprot, VM_FLUSH_RESET_PERMS,
+				   NUMA_NO_NODE, __builtin_return_address(0));
 }
 
 void *execmem_text_alloc(size_t size)
 {
-	return execmem_alloc(size);
+	unsigned long start = execmem_params.modules.text.start;
+	unsigned long end = execmem_params.modules.text.end;
+	pgprot_t pgprot = execmem_params.modules.text.pgprot;
+	unsigned int align = execmem_params.modules.text.alignment;
+
+	if (!execmem_params.modules.text.start)
+		return module_alloc(size);
+
+	return execmem_alloc(size, start, end, align, pgprot);
 }
 
 void execmem_free(void *ptr)
@@ -27,10 +40,41 @@ void execmem_free(void *ptr)
 
 void *jit_text_alloc(size_t size)
 {
-	return execmem_alloc(size);
+	return execmem_text_alloc(size);
 }
 
 void jit_free(void *ptr)
 {
 	execmem_free(ptr);
 }
+
+struct execmem_params * __weak execmem_arch_params(void)
+{
+	return NULL;
+}
+
+static bool execmem_validate_params(struct execmem_params *p)
+{
+	struct execmem_modules_range *m = &p->modules;
+	struct execmem_range *t = &m->text;
+
+	if (!t->alignment || !t->start || !t->end || !pgprot_val(t->pgprot)) {
+		pr_crit("Invalid parameters for execmem allocator, module loading will fail");
+		return false;
+	}
+
+	return true;
+}
+
+void __init execmem_init(void)
+{
+	struct execmem_params *p = execmem_arch_params();
+
+	if (!p)
+		return;
+
+	if (!execmem_validate_params(p))
+		return;
+
+	execmem_params = *p;
+}
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 7f7f9c677854..3b11450efe8a 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -26,6 +26,7 @@
 #include <linux/pgtable.h>
 #include <linux/swap.h>
 #include <linux/cma.h>
+#include <linux/execmem.h>
 #include "internal.h"
 #include "slab.h"
 #include "shuffle.h"
@@ -2747,4 +2748,5 @@ void __init mm_core_init(void)
 	pti_init();
 	kmsan_init_runtime();
 	mm_cache_init();
+	execmem_init();
 }
-- 
2.35.1


