Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202851DD19F
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 17:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730392AbgEUPZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 11:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730209AbgEUPXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 11:23:53 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A2DC061A0E;
        Thu, 21 May 2020 08:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=vNQeQfhnQUYlUEGOV8ptc/9DQ91DLtvvx9y3Q+wCvtc=; b=C3fZLFC+Lklqp5kYgtF3uH2SrS
        2oOkjccLo3dYgUzQzOouWvurqyxKekwlSANNx8t1MA40Jyom8/zWiQinCk3MfUWHT8mG4gvdSyCqn
        P6gIxi8U+2Sj2Eg/syj5+jvtn7EpwE++qRKKNdP6OD3vZ7mFNl8yp01n6AtuvUacbHRMcvkw640dD
        FPirtNdhTEhAkcYoYQDkvnI2LEWIn4wwwqLTnKprLt/1ljtD70UtWGutvFIPP0uwuFLwKocFlrEX2
        SsgpoIqYWONLv6JGC0pEDFuhK4Uvrl8/hq4orYoVZs8Qg6PwEPyOOYH8V9vk4uE+SsxsTFiZGC59u
        PaazKvPQ==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbn31-0004a8-Lr; Thu, 21 May 2020 15:23:52 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 16/23] maccess: always use strict semantics for probe_kernel_read
Date:   Thu, 21 May 2020 17:22:54 +0200
Message-Id: <20200521152301.2587579-17-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521152301.2587579-1-hch@lst.de>
References: <20200521152301.2587579-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Except for historical confusion in the kprobes/uprobes and bpf tracers,
which has been fixed now, there is no good reason to ever allow user
memory accesses from probe_kernel_read.  Switch probe_kernel_read to only
read from kernel memory.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/parisc/lib/memcpy.c    |  2 +-
 arch/um/kernel/maccess.c    |  2 +-
 arch/x86/mm/maccess.c       |  9 ++-------
 include/linux/uaccess.h     |  4 +---
 kernel/trace/bpf_trace.c    |  2 +-
 kernel/trace/trace_kprobe.c |  4 ++--
 mm/maccess.c                | 40 ++++++-------------------------------
 7 files changed, 14 insertions(+), 49 deletions(-)

diff --git a/arch/parisc/lib/memcpy.c b/arch/parisc/lib/memcpy.c
index 5b75c35d1da0d..94a9fe2702c2f 100644
--- a/arch/parisc/lib/memcpy.c
+++ b/arch/parisc/lib/memcpy.c
@@ -57,7 +57,7 @@ void * memcpy(void * dst,const void *src, size_t count)
 EXPORT_SYMBOL(raw_copy_in_user);
 EXPORT_SYMBOL(memcpy);
 
-bool probe_kernel_read_allowed(const void *unsafe_src, size_t size, bool strict)
+bool probe_kernel_read_allowed(const void *unsafe_src, size_t size)
 {
 	if ((unsigned long)unsafe_src < PAGE_SIZE)
 		return false;
diff --git a/arch/um/kernel/maccess.c b/arch/um/kernel/maccess.c
index ad2c538ce497c..e929c0966696c 100644
--- a/arch/um/kernel/maccess.c
+++ b/arch/um/kernel/maccess.c
@@ -7,7 +7,7 @@
 #include <linux/kernel.h>
 #include <os.h>
 
-bool probe_kernel_read_allowed(const void *src, size_t size, bool strict)
+bool probe_kernel_read_allowed(const void *src, size_t size)
 {
 	void *psrc = (void *)rounddown((unsigned long)src, PAGE_SIZE);
 
diff --git a/arch/x86/mm/maccess.c b/arch/x86/mm/maccess.c
index a96a56ff16109..a5ed03ac9b10f 100644
--- a/arch/x86/mm/maccess.c
+++ b/arch/x86/mm/maccess.c
@@ -9,13 +9,10 @@ static __always_inline u64 canonical_address(u64 vaddr, u8 vaddr_bits)
 	return ((s64)vaddr << (64 - vaddr_bits)) >> (64 - vaddr_bits);
 }
 
-bool probe_kernel_read_allowed(const void *unsafe_src, size_t size, bool strict)
+bool probe_kernel_read_allowed(const void *unsafe_src, size_t size)
 {
 	unsigned long vaddr = (unsigned long)unsafe_src;
 
-	if (!strict)
-		return true;
-
 	/*
 	 * Range covering the highest possible canonical userspace address
 	 * as well as non-canonical address range. For the canonical range
@@ -25,10 +22,8 @@ bool probe_kernel_read_allowed(const void *unsafe_src, size_t size, bool strict)
 	       canonical_address(vaddr, boot_cpu_data.x86_virt_bits) == vaddr;
 }
 #else
-bool probe_kernel_read_allowed(const void *unsafe_src, size_t size, bool strict)
+bool probe_kernel_read_allowed(const void *unsafe_src, size_t size)
 {
-	if (!strict)
-		return true;
 	return (unsigned long)vaddr >= TASK_SIZE_MAX;
 }
 #endif
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index d7d98ff345b3d..58e9f3dc1cf13 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -301,11 +301,9 @@ copy_struct_from_user(void *dst, size_t ksize, const void __user *src,
 	return 0;
 }
 
-bool probe_kernel_read_allowed(const void *unsafe_src, size_t size,
-		bool strict);
+bool probe_kernel_read_allowed(const void *unsafe_src, size_t size);
 
 extern long probe_kernel_read(void *dst, const void *src, size_t size);
-extern long probe_kernel_read_strict(void *dst, const void *src, size_t size);
 extern long probe_user_read(void *dst, const void __user *src, size_t size);
 
 extern long notrace probe_kernel_write(void *dst, const void *src, size_t size);
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 43566cd2a8180..d9781c894c38b 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -196,7 +196,7 @@ bpf_probe_read_kernel_common(void *dst, u32 size, const void *unsafe_ptr)
 
 	if (unlikely(ret < 0))
 		goto fail;
-	ret = probe_kernel_read_strict(dst, unsafe_ptr, size);
+	ret = probe_kernel_read(dst, unsafe_ptr, size);
 	if (unlikely(ret < 0))
 		goto fail;
 	return ret;
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 4aeaef53ba970..b1f21d558e454 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1222,7 +1222,7 @@ fetch_store_strlen(unsigned long addr)
 #endif
 
 	do {
-		ret = probe_kernel_read_strict(&c, (u8 *)addr + len, 1);
+		ret = probe_kernel_read(&c, (u8 *)addr + len, 1);
 		len++;
 	} while (c && ret == 0 && len < MAX_STRING_SIZE);
 
@@ -1300,7 +1300,7 @@ probe_mem_read(void *dest, void *src, size_t size)
 	if ((unsigned long)src < TASK_SIZE)
 		return probe_mem_read_user(dest, src, size);
 #endif
-	return probe_kernel_read_strict(dest, src, size);
+	return probe_kernel_read(dest, src, size);
 }
 
 /* Note that we don't verify it, since the code does not come from user space */
diff --git a/mm/maccess.c b/mm/maccess.c
index df82fde34307f..81a85c1e71165 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -6,36 +6,13 @@
 #include <linux/mm.h>
 #include <linux/uaccess.h>
 
-static long __probe_kernel_read(void *dst, const void *src, size_t size,
-		bool strict);
-
-bool __weak probe_kernel_read_allowed(const void *unsafe_src, size_t size,
-		bool strict)
+bool __weak probe_kernel_read_allowed(const void *unsafe_src, size_t size)
 {
 	return true;
 }
 
 /**
- * probe_kernel_read(): safely attempt to read from any location
- * @dst: pointer to the buffer that shall take the data
- * @src: address to read from
- * @size: size of the data chunk
- *
- * Same as probe_kernel_read_strict() except that for architectures with
- * not fully separated user and kernel address spaces this function also works
- * for user address tanges.
- *
- * DO NOT USE THIS FUNCTION - it is broken on architectures with entirely
- * separate kernel and user address spaces, and also a bad idea otherwise.
- */
-long probe_kernel_read(void *dst, const void *src, size_t size)
-{
-	return __probe_kernel_read(dst, src, size, false);
-}
-EXPORT_SYMBOL_GPL(probe_kernel_read);
-
-/**
- * probe_kernel_read_strict(): safely attempt to read from kernel-space
+ * probe_kernel_read(): safely attempt to read from kernel-space
  * @dst: pointer to the buffer that shall take the data
  * @src: address to read from
  * @size: size of the data chunk
@@ -48,18 +25,12 @@ EXPORT_SYMBOL_GPL(probe_kernel_read);
  * probe_kernel_read() suitable for use within regions where the caller
  * already holds mmap_sem, or other locks which nest inside mmap_sem.
  */
-long probe_kernel_read_strict(void *dst, const void *src, size_t size)
-{
-	return __probe_kernel_read(dst, src, size, true);
-}
-
-static long __probe_kernel_read(void *dst, const void *src, size_t size,
-		bool strict)
+long probe_kernel_read(void *dst, const void *src, size_t size)
 {
 	long ret;
 	mm_segment_t old_fs = get_fs();
 
-	if (!probe_kernel_read_allowed(src, size, strict))
+	if (!probe_kernel_read_allowed(src, size))
 		return -EFAULT;
 
 	set_fs(KERNEL_DS);
@@ -73,6 +44,7 @@ static long __probe_kernel_read(void *dst, const void *src, size_t size,
 		return -EFAULT;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(probe_kernel_read);
 
 /**
  * probe_user_read(): safely attempt to read from a user-space location
@@ -180,7 +152,7 @@ long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
 
 	if (unlikely(count <= 0))
 		return 0;
-	if (!probe_kernel_read_allowed(unsafe_addr, count, true))
+	if (!probe_kernel_read_allowed(unsafe_addr, count))
 		return -EFAULT;
 
 	set_fs(KERNEL_DS);
-- 
2.26.2

