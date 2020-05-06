Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01EEC1C68B0
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgEFGXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728330AbgEFGW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 02:22:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA96CC061A0F;
        Tue,  5 May 2020 23:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=oZwAqX6qv5ccIiIE5YKqKbwN1bXypOB0gq+qr3W5xJ4=; b=R/INjrhAFYyZD0f9X8hDc2m8t+
        ajzKVjqYbb9OkFKPiJSa1VtJ8QKpEPkCH+UdK4umvL0+b+Y0OGjZg6FbDUamHCKiRcxUJcjEZb2M7
        VCgopHPAuUPejFP9NdPAb/uyUHAjQbKk/sLYLV8c2nWBEi6NRij0tW8Z5D4ZZJinhgd0f/iduNSWR
        h6RZ3vhUVgv9V2FrumB5dPzF8YoaXZYK4/aB+65HTq6UZcq/n83iSKjt/QWxcvuMZ+XXvSjhQnYWZ
        Xu5Wutlc/46yQ8OjPcJlgiHyvBwK2mEDRcaN4u9/PN663OL0R/x5OfsuDN9aaLBMgGUaBEimPgnkl
        hOsha3vA==;
Received: from [2001:4bb8:191:66b6:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWDSJ-0006jU-RK; Wed, 06 May 2020 06:22:56 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/15] maccess: unify the probe kernel arch hooks
Date:   Wed,  6 May 2020 08:22:18 +0200
Message-Id: <20200506062223.30032-11-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200506062223.30032-1-hch@lst.de>
References: <20200506062223.30032-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently architectures have to override every routine that probes
kernel memory, which includes a pure read and strcpy, both in strict
and not strict variants.  Just provide a single arch hooks instead to
make sure all architectures cover all the cases.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/parisc/lib/memcpy.c | 13 ++++-------
 arch/um/kernel/maccess.c | 11 ++++-----
 arch/x86/mm/maccess.c    | 18 ++++-----------
 include/linux/uaccess.h  |  5 ++--
 mm/maccess.c             | 49 ++++++++++++++++++++++++++++++----------
 5 files changed, 55 insertions(+), 41 deletions(-)

diff --git a/arch/parisc/lib/memcpy.c b/arch/parisc/lib/memcpy.c
index beceaab34ecb7..5ef648bd33119 100644
--- a/arch/parisc/lib/memcpy.c
+++ b/arch/parisc/lib/memcpy.c
@@ -57,14 +57,11 @@ void * memcpy(void * dst,const void *src, size_t count)
 EXPORT_SYMBOL(raw_copy_in_user);
 EXPORT_SYMBOL(memcpy);
 
-long probe_kernel_read(void *dst, const void *src, size_t size)
+bool probe_kernel_read_allowed(void *dst, const void *unsafe_src, size_t size,
+		bool strict)
 {
-	unsigned long addr = (unsigned long)src;
-
-	if (addr < PAGE_SIZE)
-		return -EFAULT;
-
+	if ((unsigned long)unsafe_src < PAGE_SIZE)
+		return false;
 	/* check for I/O space F_EXTEND(0xfff00000) access as well? */
-
-	return __probe_kernel_read(dst, src, size);
+	return true;
 }
diff --git a/arch/um/kernel/maccess.c b/arch/um/kernel/maccess.c
index 67b2e0fa92bba..90a1bec923158 100644
--- a/arch/um/kernel/maccess.c
+++ b/arch/um/kernel/maccess.c
@@ -7,15 +7,14 @@
 #include <linux/kernel.h>
 #include <os.h>
 
-long probe_kernel_read(void *dst, const void *src, size_t size)
+bool probe_kernel_read_allowed(void *dst, const void *src, size_t size,
+		bool strict)
 {
 	void *psrc = (void *)rounddown((unsigned long)src, PAGE_SIZE);
 
 	if ((unsigned long)src < PAGE_SIZE || size <= 0)
-		return -EFAULT;
-
+		return false;
 	if (os_mincore(psrc, size + src - psrc) <= 0)
-		return -EFAULT;
-
-	return __probe_kernel_read(dst, src, size);
+		return false;
+	return true;
 }
diff --git a/arch/x86/mm/maccess.c b/arch/x86/mm/maccess.c
index 6290e9894fb55..5c323ab187b27 100644
--- a/arch/x86/mm/maccess.c
+++ b/arch/x86/mm/maccess.c
@@ -26,18 +26,10 @@ static __always_inline bool invalid_probe_range(u64 vaddr)
 }
 #endif
 
-long probe_kernel_read_strict(void *dst, const void *src, size_t size)
+bool probe_kernel_read_allowed(void *dst, const void *unsafe_src, size_t size,
+		bool strict)
 {
-	if (unlikely(invalid_probe_range((unsigned long)src)))
-		return -EFAULT;
-
-	return __probe_kernel_read(dst, src, size);
-}
-
-long strncpy_from_kernel_unsafe(char *dst, const void *unsafe_addr, long count)
-{
-	if (unlikely(invalid_probe_range((unsigned long)unsafe_addr)))
-		return -EFAULT;
-
-	return __strncpy_from_unsafe(dst, unsafe_addr, count);
+	if (!strict)
+		return true;
+	return !invalid_probe_range((unsigned long)unsafe_src);
 }
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 77909cafde5a8..f8c47395a92df 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -301,9 +301,11 @@ copy_struct_from_user(void *dst, size_t ksize, const void __user *src,
 	return 0;
 }
 
+bool probe_kernel_read_allowed(void *dst, const void *unsafe_src,
+		size_t size, bool strict);
+
 extern long probe_kernel_read(void *dst, const void *src, size_t size);
 extern long probe_kernel_read_strict(void *dst, const void *src, size_t size);
-extern long __probe_kernel_read(void *dst, const void *src, size_t size);
 extern long probe_user_read(void *dst, const void __user *src, size_t size);
 
 extern long notrace probe_kernel_write(void *dst, const void *src, size_t size);
@@ -312,7 +314,6 @@ extern long notrace probe_user_write(void __user *dst, const void *src, size_t s
 extern long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
 extern long strncpy_from_kernel_unsafe(char *dst, const void *unsafe_addr,
 				       long count);
-extern long __strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
 extern long strncpy_from_user_unsafe(char *dst, const void __user *unsafe_addr,
 				     long count);
 extern long strnlen_user_unsafe(const void __user *unsafe_addr, long count);
diff --git a/mm/maccess.c b/mm/maccess.c
index c18f2dcdb1b88..11563129cd490 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -6,6 +6,17 @@
 #include <linux/mm.h>
 #include <linux/uaccess.h>
 
+static long __probe_kernel_read(void *dst, const void *src, size_t size,
+		bool strict);
+static long __strncpy_from_unsafe(char *dst, const void *unsafe_addr,
+		long count, bool strict);
+
+bool __weak probe_kernel_read_allowed(void *dst, const void *unsafe_src,
+		size_t size, bool strict)
+{
+	return true;
+}
+
 /**
  * probe_kernel_read(): safely attempt to read from any location
  * @dst: pointer to the buffer that shall take the data
@@ -19,8 +30,11 @@
  * DO NOT USE THIS FUNCTION - it is broken on architectures with entirely
  * separate kernel and user address spaces, and also a bad idea otherwise.
  */
-long __weak probe_kernel_read(void *dst, const void *src, size_t size)
-    __attribute__((alias("__probe_kernel_read")));
+long probe_kernel_read(void *dst, const void *src, size_t size)
+{
+	return __probe_kernel_read(dst, src, size, false);
+}
+EXPORT_SYMBOL_GPL(probe_kernel_read);
 
 /**
  * probe_kernel_read_strict(): safely attempt to read from kernel-space
@@ -36,14 +50,20 @@ long __weak probe_kernel_read(void *dst, const void *src, size_t size)
  * probe_kernel_read() suitable for use within regions where the caller
  * already holds mmap_sem, or other locks which nest inside mmap_sem.
  */
-long __weak probe_kernel_read_strict(void *dst, const void *src, size_t size)
-    __attribute__((alias("__probe_kernel_read")));
+long probe_kernel_read_strict(void *dst, const void *src, size_t size)
+{
+	return __probe_kernel_read(dst, src, size, true);
+}
 
-long __probe_kernel_read(void *dst, const void *src, size_t size)
+static long __probe_kernel_read(void *dst, const void *src, size_t size,
+		bool strict)
 {
 	long ret;
 	mm_segment_t old_fs = get_fs();
 
+	if (!probe_kernel_read_allowed(dst, src, size, strict))
+		return -EFAULT;
+
 	set_fs(KERNEL_DS);
 	pagefault_disable();
 	ret = __copy_from_user_inatomic(dst, (__force const void __user *)src,
@@ -55,7 +75,6 @@ long __probe_kernel_read(void *dst, const void *src, size_t size)
 		return -EFAULT;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(probe_kernel_read);
 
 /**
  * probe_user_read(): safely attempt to read from a user-space location
@@ -161,8 +180,10 @@ long probe_user_write(void __user *dst, const void *src, size_t size)
  * DO NOT USE THIS FUNCTION - it is broken on architectures with entirely
  * separate kernel and user address spaces, and also a bad idea otherwise.
  */
-long __weak strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
-    __attribute__((alias("__strncpy_from_unsafe")));
+long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
+{
+	return __strncpy_from_unsafe(dst, unsafe_addr, count, false);
+}
 
 /**
  * strncpy_from_kernel_unsafe: - Copy a NUL terminated string from unsafe
@@ -182,11 +203,13 @@ long __weak strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
  * If @count is smaller than the length of the string, copies @count-1 bytes,
  * sets the last byte of @dst buffer to NUL and returns @count.
  */
-long __weak strncpy_from_kernel_unsafe(char *dst, const void *unsafe_addr,
-				       long count)
-    __attribute__((alias("__strncpy_from_unsafe")));
+long strncpy_from_kernel_unsafe(char *dst, const void *unsafe_addr, long count)
+{
+	return __strncpy_from_unsafe(dst, unsafe_addr, count, true);
+}
 
-long __strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
+static long __strncpy_from_unsafe(char *dst, const void *unsafe_addr,
+		long count, bool strict)
 {
 	mm_segment_t old_fs = get_fs();
 	const void *src = unsafe_addr;
@@ -194,6 +217,8 @@ long __strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
 
 	if (unlikely(count <= 0))
 		return 0;
+	if (!probe_kernel_read_allowed(dst, unsafe_addr, count, strict))
+		return -EFAULT;
 
 	set_fs(KERNEL_DS);
 	pagefault_disable();
-- 
2.26.2

