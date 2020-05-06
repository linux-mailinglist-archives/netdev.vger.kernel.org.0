Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202391C68D0
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728201AbgEFGWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728186AbgEFGWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 02:22:39 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB25C061A0F;
        Tue,  5 May 2020 23:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=mSMXwSYIg6w8Djb8jfs2EjgdqI2tqBJvsH4pyf4a+s4=; b=EwXRGNoKH27CubtAt4lkBokJUF
        5JjLZZPOvxWOpLNVT3vSpiAaHrvPR2g78jaTgcWV+0/8g85x3jBiyZonYNkK192ZIsD6rw6/yEHpw
        xbHTeQciZhCksVZFeb/5wjPBfxKlPP5Ied1SCyBI+dwchWXSQ1KiiGpotpe+WYKQcI0Wx8KP6e3rJ
        fDK8cDxVD02hxmcTkxEvztO+7vByfhIp0Euvz52EluPRDoAwYFvRmIhQQ7AFucvGa5PbJE3bgMp+Y
        vBtQGudsD6VH4TDkd7AnnB+u3zFf+RbjeT0qSQ7ILy5x1ho1TwCMB2zxhmLv0/t3KOlY5+ySGvz50
        yHXLfNow==;
Received: from [2001:4bb8:191:66b6:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWDS1-0006Yc-IH; Wed, 06 May 2020 06:22:38 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/15] maccess: clarify kerneldoc comments
Date:   Wed,  6 May 2020 08:22:12 +0200
Message-Id: <20200506062223.30032-5-hch@lst.de>
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

Add proper kerneldoc comments for probe_kernel_read_strict and
probe_kernel_read strncpy_from_unsafe_strict and explain the different
versus the non-strict version.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/maccess.c | 61 ++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 43 insertions(+), 18 deletions(-)

diff --git a/mm/maccess.c b/mm/maccess.c
index 4e7f3b6eb05ae..747581ac50dc9 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -31,29 +31,35 @@ probe_write_common(void __user *dst, const void *src, size_t size)
 }
 
 /**
- * probe_kernel_read(): safely attempt to read from a kernel-space location
+ * probe_kernel_read(): safely attempt to read from any location
  * @dst: pointer to the buffer that shall take the data
  * @src: address to read from
  * @size: size of the data chunk
  *
- * Safely read from address @src to the buffer at @dst.  If a kernel fault
- * happens, handle that and return -EFAULT.
+ * Same as probe_kernel_read_strict() except that for architectures with
+ * not fully separated user and kernel address spaces this function also works
+ * for user address tanges.
+ *
+ * DO NOT USE THIS FUNCTION - it is broken on architectures with entirely
+ * separate kernel and user address spaces, and also a bad idea otherwise.
+ */
+long __weak probe_kernel_read(void *dst, const void *src, size_t size)
+    __attribute__((alias("__probe_kernel_read")));
+
+/**
+ * probe_kernel_read_strict(): safely attempt to read from kernel-space
+ * @dst: pointer to the buffer that shall take the data
+ * @src: address to read from
+ * @size: size of the data chunk
+ *
+ * Safely read from kernel address @src to the buffer at @dst.  If a kernel
+ * fault happens, handle that and return -EFAULT.
  *
  * We ensure that the copy_from_user is executed in atomic context so that
  * do_page_fault() doesn't attempt to take mmap_sem.  This makes
  * probe_kernel_read() suitable for use within regions where the caller
  * already holds mmap_sem, or other locks which nest inside mmap_sem.
- *
- * probe_kernel_read_strict() is the same as probe_kernel_read() except for
- * the case where architectures have non-overlapping user and kernel address
- * ranges: probe_kernel_read_strict() will additionally return -EFAULT for
- * probing memory on a user address range where probe_user_read() is supposed
- * to be used instead.
  */
-
-long __weak probe_kernel_read(void *dst, const void *src, size_t size)
-    __attribute__((alias("__probe_kernel_read")));
-
 long __weak probe_kernel_read_strict(void *dst, const void *src, size_t size)
     __attribute__((alias("__probe_kernel_read")));
 
@@ -153,15 +159,34 @@ long probe_user_write(void __user *dst, const void *src, size_t size)
  * If @count is smaller than the length of the string, copies @count-1 bytes,
  * sets the last byte of @dst buffer to NUL and returns @count.
  *
- * strncpy_from_unsafe_strict() is the same as strncpy_from_unsafe() except
- * for the case where architectures have non-overlapping user and kernel address
- * ranges: strncpy_from_unsafe_strict() will additionally return -EFAULT for
- * probing memory on a user address range where strncpy_from_unsafe_user() is
- * supposed to be used instead.
+ * Same as strncpy_from_unsafe_strict() except that for architectures with
+ * not fully separated user and kernel address spaces this function also works
+ * for user address tanges.
+ *
+ * DO NOT USE THIS FUNCTION - it is broken on architectures with entirely
+ * separate kernel and user address spaces, and also a bad idea otherwise.
  */
 long __weak strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
     __attribute__((alias("__strncpy_from_unsafe")));
 
+/**
+ * strncpy_from_unsafe_strict: - Copy a NUL terminated string from unsafe
+ *				 address.
+ * @dst:   Destination address, in kernel space.  This buffer must be at
+ *         least @count bytes long.
+ * @unsafe_addr: Unsafe address.
+ * @count: Maximum number of bytes to copy, including the trailing NUL.
+ *
+ * Copies a NUL-terminated string from unsafe address to kernel buffer.
+ *
+ * On success, returns the length of the string INCLUDING the trailing NUL.
+ *
+ * If access fails, returns -EFAULT (some data may have been copied
+ * and the trailing NUL added).
+ *
+ * If @count is smaller than the length of the string, copies @count-1 bytes,
+ * sets the last byte of @dst buffer to NUL and returns @count.
+ */
 long __weak strncpy_from_unsafe_strict(char *dst, const void *unsafe_addr,
 				       long count)
     __attribute__((alias("__strncpy_from_unsafe")));
-- 
2.26.2

