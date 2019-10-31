Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94241EA87C
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 02:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbfJaBBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 21:01:06 -0400
Received: from www62.your-server.de ([213.133.104.62]:42386 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbfJaBAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 21:00:52 -0400
Received: from 38.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.38] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iPypU-0000E9-5i; Thu, 31 Oct 2019 02:00:48 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, andrii.nakryiko@gmail.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, x86@kernel.org
Subject: [PATCH bpf-next v2 2/8] uaccess: Add strict non-pagefault kernel-space read function
Date:   Thu, 31 Oct 2019 02:00:20 +0100
Message-Id: <59ffcedeed70cdae86fbd803b87cc581a82577d7.1572483054.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1572483054.git.daniel@iogearbox.net>
References: <cover.1572483054.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25618/Wed Oct 30 09:54:22 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add two new probe_kernel_read_strict() and strncpy_from_unsafe_strict()
helpers which by default alias to the __probe_kernel_read() and the
__strncpy_from_unsafe(), respectively, but can be overridden by archs
which have non-overlapping address ranges for kernel space and user
space in order to bail out with -EFAULT when attempting to probe user
memory including non-canonical user access addresses [0].

The idea is that these helpers are complementary to the probe_user_read()
and strncpy_from_unsafe_user() which probe user-only memory. Both added
helpers here do the same, but for kernel-only addresses.

Both set of helpers are going to be used for BPF tracing. They also
explicitly avoid throwing the splat for non-canonical user addresses from
00c42373d397 ("x86-64: add warning for non-canonical user access address
dereferences").

For compat, the current probe_kernel_read() and strncpy_from_unsafe() are
left as-is.

  [0] Documentation/x86/x86_64/mm.txt

      4-level page tables: 0x0000800000000000 - 0xffff7fffffffffff
      5-level page tables: 0x0100000000000000 - 0xfeffffffffffffff

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: x86@kernel.org
---
 arch/x86/mm/Makefile    |  2 +-
 arch/x86/mm/maccess.c   | 38 ++++++++++++++++++++++++++++++++++++++
 include/linux/uaccess.h |  4 ++++
 mm/maccess.c            | 25 ++++++++++++++++++++++++-
 4 files changed, 67 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/mm/maccess.c

diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 84373dc9b341..bbc68a54795e 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -13,7 +13,7 @@ CFLAGS_REMOVE_mem_encrypt_identity.o	= -pg
 endif
 
 obj-y	:=  init.o init_$(BITS).o fault.o ioremap.o extable.o pageattr.o mmap.o \
-	    pat.o pgtable.o physaddr.o setup_nx.o tlb.o cpu_entry_area.o
+	    pat.o pgtable.o physaddr.o setup_nx.o tlb.o cpu_entry_area.o maccess.o
 
 # Make sure __phys_addr has no stackprotector
 nostackp := $(call cc-option, -fno-stack-protector)
diff --git a/arch/x86/mm/maccess.c b/arch/x86/mm/maccess.c
new file mode 100644
index 000000000000..fcc55a7cbde2
--- /dev/null
+++ b/arch/x86/mm/maccess.c
@@ -0,0 +1,38 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/uaccess.h>
+#include <linux/kernel.h>
+
+static __always_inline u64 canonical_address(u64 vaddr, u8 vaddr_bits)
+{
+	return ((s64)vaddr << (64 - vaddr_bits)) >> (64 - vaddr_bits);
+}
+
+static __always_inline bool non_canonical_address(u64 vaddr)
+{
+#ifdef CONFIG_X86_64
+	return canonical_address(vaddr, boot_cpu_data.x86_virt_bits) != vaddr;
+#else
+	return false;
+#endif
+}
+
+long probe_kernel_read_strict(void *dst, const void *src, size_t size)
+{
+	u64 addr = (unsigned long)src;
+
+	if (unlikely(addr < TASK_SIZE_MAX || non_canonical_address(addr)))
+		return -EFAULT;
+
+	return __probe_kernel_read(dst, src, size);
+}
+
+long strncpy_from_unsafe_strict(char *dst, const void *unsafe_addr, long count)
+{
+	u64 addr = (unsigned long)unsafe_addr;
+
+	if (unlikely(addr < TASK_SIZE_MAX || non_canonical_address(addr)))
+		return -EFAULT;
+
+	return __strncpy_from_unsafe(dst, unsafe_addr, count);
+}
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 38555435a64a..67f016010aad 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -311,6 +311,7 @@ copy_struct_from_user(void *dst, size_t ksize, const void __user *src,
  * happens, handle that and return -EFAULT.
  */
 extern long probe_kernel_read(void *dst, const void *src, size_t size);
+extern long probe_kernel_read_strict(void *dst, const void *src, size_t size);
 extern long __probe_kernel_read(void *dst, const void *src, size_t size);
 
 /*
@@ -350,6 +351,9 @@ extern long notrace probe_user_write(void __user *dst, const void *src, size_t s
 extern long notrace __probe_user_write(void __user *dst, const void *src, size_t size);
 
 extern long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
+extern long strncpy_from_unsafe_strict(char *dst, const void *unsafe_addr,
+				       long count);
+extern long __strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
 extern long strncpy_from_unsafe_user(char *dst, const void __user *unsafe_addr,
 				     long count);
 extern long strnlen_unsafe_user(const void __user *unsafe_addr, long count);
diff --git a/mm/maccess.c b/mm/maccess.c
index 2d3c3d01064c..3ca8d97e5010 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -43,11 +43,20 @@ probe_write_common(void __user *dst, const void *src, size_t size)
  * do_page_fault() doesn't attempt to take mmap_sem.  This makes
  * probe_kernel_read() suitable for use within regions where the caller
  * already holds mmap_sem, or other locks which nest inside mmap_sem.
+ *
+ * probe_kernel_read_strict() is the same as probe_kernel_read() except for
+ * the case where architectures have non-overlapping user and kernel address
+ * ranges: probe_kernel_read_strict() will additionally return -EFAULT for
+ * probing memory on a user address range where probe_user_read() is supposed
+ * to be used instead.
  */
 
 long __weak probe_kernel_read(void *dst, const void *src, size_t size)
     __attribute__((alias("__probe_kernel_read")));
 
+long __weak probe_kernel_read_strict(void *dst, const void *src, size_t size)
+    __attribute__((alias("__probe_kernel_read")));
+
 long __probe_kernel_read(void *dst, const void *src, size_t size)
 {
 	long ret;
@@ -157,8 +166,22 @@ EXPORT_SYMBOL_GPL(probe_user_write);
  *
  * If @count is smaller than the length of the string, copies @count-1 bytes,
  * sets the last byte of @dst buffer to NUL and returns @count.
+ *
+ * strncpy_from_unsafe_strict() is the same as strncpy_from_unsafe() except
+ * for the case where architectures have non-overlapping user and kernel address
+ * ranges: strncpy_from_unsafe_strict() will additionally return -EFAULT for
+ * probing memory on a user address range where strncpy_from_unsafe_user() is
+ * supposed to be used instead.
  */
-long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
+
+long __weak strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
+    __attribute__((alias("__strncpy_from_unsafe")));
+
+long __weak strncpy_from_unsafe_strict(char *dst, const void *unsafe_addr,
+				       long count)
+    __attribute__((alias("__strncpy_from_unsafe")));
+
+long __strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
 {
 	mm_segment_t old_fs = get_fs();
 	const void *src = unsafe_addr;
-- 
2.21.0

