Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30A032D53A
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 07:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbfE2Fve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 01:51:34 -0400
Received: from mga18.intel.com ([134.134.136.126]:12653 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725856AbfE2Fve (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 01:51:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 May 2019 22:51:33 -0700
X-ExtLoop1: 1
Received: from rpedgeco-mobl.amr.corp.intel.com (HELO localhost.intel.com) ([10.252.134.167])
  by orsmga006.jf.intel.com with ESMTP; 28 May 2019 22:51:32 -0700
From:   Rick Edgecombe <rick.p.edgecombe@intel.com>
To:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        davem@davemloft.net, sparclinux@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     dave.hansen@intel.com, jeyu@kernel.org, namit@vmware.com,
        luto@kernel.org, will.deacon@arm.com, ast@kernel.org,
        daniel@iogearbox.net, Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Meelis Roos <mroos@linux.ee>,
        Ard Biesheuvel <ard.biesheuvel@arm.com>
Subject: [PATCH] vmalloc: Don't use flush flag when no exec perm
Date:   Tue, 28 May 2019 22:51:04 -0700
Message-Id: <20190529055104.6822-1-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The addition of VM_FLUSH_RESET_PERMS for BPF JIT allocations was
bisected to prevent boot on an UltraSparc III machine. It was found that
sometime shortly after the TLB flush this flag does on vfree of the BPF
program, the machine hung. Further investigation showed that before any of
the changes for this flag were introduced, with CONFIG_DEBUG_PAGEALLOC
configured (which does a similar TLB flush of the vmalloc range on
every vfree), this machine also hung shortly after the first vmalloc
unmap/free.

So the evidence points to there being some existing issue with the
vmalloc TLB flushes, but it's still unknown exactly why these hangs are
happening on sparc. It is also unknown when someone with this hardware
could resolve this, and in the meantime using this flag on it turns a
lurking behavior into something that prevents boot.

However Linux on sparc64 doesn't restrict executable permissions and so
there is actually not really a need to use this flag. If normal memory is
executable, any memory copied from the user could be executed without any
extra steps. There also isn't a need to reset direct map permissions. So
to work around this issue we can just not use the flag in these cases.

So change the helper that sets this flag to simply not set it if the
architecture has these properties. Do this by comparing if PAGE_KERNEL is
the same as PAGE_KERNEL_EXEC. Also make the logic always do the flush if
an architecture has a way to reset direct map permissions by checking
CONFIG_ARCH_HAS_SET_DIRECT_MAP. Place the helper in vmalloc.c to work
around header dependency issues. Also, remove VM_FLUSH_RESET_PERMS from
vmalloc_exec() so it doesn't get set unconditionally anywhere.

Note, today arm has direct map permissions and no
CONFIG_ARCH_HAS_SET_DIRECT_MAP, but it also restricts executable
permissions so this logic will work today. When arm adds
set_direct_map_() implementations and removes the set_memory_() block from
from vm_remove_mappings() as currently proposed, then this will be correct
as well.

This logic could be put in vm_remove_mappings() instead, but doing it this
way leaves the raw flag generic and open for future usages. So change the
name of the helper to match its new conditional properties.

Fixes: d53d2f7 ("bpf: Use vmalloc special flag")
Reported-by: Meelis Roos <mroos@linux.ee>
Cc: David S. Miller <davem@davemloft.net>
Cc: peterz@infradead.org <peterz@infradead.org>
Cc: Nadav Amit <namit@vmware.com>
Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---

Hi,

This is what I came up with for working around the sparc issue. The
other solution I had looked at was making a CONFIG_ARCH_NEEDS_VM_FLUSH
and just opt out only sparc. Very open to suggestions.

 arch/x86/kernel/ftrace.c       |  2 +-
 arch/x86/kernel/kprobes/core.c |  2 +-
 include/linux/filter.h         |  4 ++--
 include/linux/vmalloc.h        | 10 ++--------
 kernel/module.c                |  4 ++--
 mm/vmalloc.c                   | 25 ++++++++++++++++++++++---
 6 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 0927bb158ffc..9793f6491882 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -823,7 +823,7 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 	/* ALLOC_TRAMP flags lets us know we created it */
 	ops->flags |= FTRACE_OPS_FL_ALLOC_TRAMP;
 
-	set_vm_flush_reset_perms(trampoline);
+	set_vm_flush_if_needed(trampoline);
 
 	/*
 	 * Module allocation needs to be completed by making the page
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 9e4fa2484d10..2e3c31c63a6f 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -434,7 +434,7 @@ void *alloc_insn_page(void)
 	if (!page)
 		return NULL;
 
-	set_vm_flush_reset_perms(page);
+	set_vm_flush_if_needed(page);
 	/*
 	 * First make the page read-only, and only then make it executable to
 	 * prevent it from being W+X in between.
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 7148bab96943..7b20d43a9cf1 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -735,13 +735,13 @@ bpf_ctx_narrow_access_ok(u32 off, u32 size, u32 size_default)
 
 static inline void bpf_prog_lock_ro(struct bpf_prog *fp)
 {
-	set_vm_flush_reset_perms(fp);
+	set_vm_flush_if_needed(fp);
 	set_memory_ro((unsigned long)fp, fp->pages);
 }
 
 static inline void bpf_jit_binary_lock_ro(struct bpf_binary_header *hdr)
 {
-	set_vm_flush_reset_perms(hdr);
+	set_vm_flush_if_needed(hdr);
 	set_memory_ro((unsigned long)hdr, hdr->pages);
 	set_memory_x((unsigned long)hdr, hdr->pages);
 }
diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 51e131245379..2fdd1d62a603 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -151,13 +151,7 @@ extern int map_kernel_range_noflush(unsigned long start, unsigned long size,
 				    pgprot_t prot, struct page **pages);
 extern void unmap_kernel_range_noflush(unsigned long addr, unsigned long size);
 extern void unmap_kernel_range(unsigned long addr, unsigned long size);
-static inline void set_vm_flush_reset_perms(void *addr)
-{
-	struct vm_struct *vm = find_vm_area(addr);
-
-	if (vm)
-		vm->flags |= VM_FLUSH_RESET_PERMS;
-}
+extern void set_vm_flush_if_needed(void *addr);
 #else
 static inline int
 map_kernel_range_noflush(unsigned long start, unsigned long size,
@@ -173,7 +167,7 @@ static inline void
 unmap_kernel_range(unsigned long addr, unsigned long size)
 {
 }
-static inline void set_vm_flush_reset_perms(void *addr)
+static inline void set_vm_flush_if_needed(void *addr)
 {
 }
 #endif
diff --git a/kernel/module.c b/kernel/module.c
index 6e6712b3aaf5..d91f03781c41 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1958,8 +1958,8 @@ void module_enable_ro(const struct module *mod, bool after_init)
 	if (!rodata_enabled)
 		return;
 
-	set_vm_flush_reset_perms(mod->core_layout.base);
-	set_vm_flush_reset_perms(mod->init_layout.base);
+	set_vm_flush_if_needed(mod->core_layout.base);
+	set_vm_flush_if_needed(mod->init_layout.base);
 	frob_text(&mod->core_layout, set_memory_ro);
 	frob_text(&mod->core_layout, set_memory_x);
 
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 233af6936c93..c3cac44d96d4 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1944,6 +1944,26 @@ void unmap_kernel_range(unsigned long addr, unsigned long size)
 }
 EXPORT_SYMBOL_GPL(unmap_kernel_range);
 
+void set_vm_flush_if_needed(void *addr)
+{
+	struct vm_struct *vm;
+
+	/*
+	 * If all PAGE_KERNEL memory is executable, the mandatory flush
+	 * doesn't really add any security value, so skip it. However if there
+	 * is a way to reset direct map permissions, we still need to flush in
+	 * order to do that.
+	 */
+	if (!IS_ENABLED(CONFIG_ARCH_HAS_SET_DIRECT_MAP)
+		&& pgprot_val(PAGE_KERNEL_EXEC) == pgprot_val(PAGE_KERNEL))
+		return;
+
+	vm = find_vm_area(addr);
+
+	if (vm)
+		vm->flags |= VM_FLUSH_RESET_PERMS;
+}
+
 int map_vm_area(struct vm_struct *area, pgprot_t prot, struct page **pages)
 {
 	unsigned long addr = (unsigned long)area->addr;
@@ -2633,9 +2653,8 @@ EXPORT_SYMBOL(vzalloc_node);
  */
 void *vmalloc_exec(unsigned long size)
 {
-	return __vmalloc_node_range(size, 1, VMALLOC_START, VMALLOC_END,
-			GFP_KERNEL, PAGE_KERNEL_EXEC, VM_FLUSH_RESET_PERMS,
-			NUMA_NO_NODE, __builtin_return_address(0));
+	return __vmalloc_node(size, 1, GFP_KERNEL, PAGE_KERNEL_EXEC,
+			      NUMA_NO_NODE, __builtin_return_address(0));
 }
 
 #if defined(CONFIG_64BIT) && defined(CONFIG_ZONE_DMA32)
-- 
2.20.1

