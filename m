Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6568B1C68BE
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbgEFGWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728278AbgEFGWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 02:22:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A59C061A0F;
        Tue,  5 May 2020 23:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=ACKg+MJWZ9EI8wirgUhJ7AjHbDuAU0r1ZO6hPQ3i2lo=; b=amHpJnA8MrRoxSObKz84Qy+r89
        O6hmDIJPrLqSSfhtDxhtrLRjmyFMts41gqqBCEiKmP2j09604mo0okFDH9Ur5OdMGK7tlnWkddk8Q
        pyaFA1itUIFg8PNBoUqpU198DDPYtvs/EBEQu6umqxwkt43IGAnWsCqSrlZE2xU46j/6sAO1qd0iK
        SwHvEa6r8QYB81H9SVQpbAoyDLejkRuv4OcvTug/PyoA4f2ELw1LGg58rBZSSXADcNogmvYiZktj0
        zfA+jiq4/cPZYmCEPD0chSlvTE0mH0nKFIhkVsugsSTiliAKGVM81VV80XWIopjRwF4wyxmgUhBNN
        VNVJBZOA==;
Received: from [2001:4bb8:191:66b6:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWDSA-0006e7-KB; Wed, 06 May 2020 06:22:47 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/15] maccess: rename strncpy_from_unsafe_strict to strncpy_from_kernel_unsafe
Date:   Wed,  6 May 2020 08:22:15 +0200
Message-Id: <20200506062223.30032-8-hch@lst.de>
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

This matches the convention of always having _unsafe as a suffix, as
well as match the naming of strncpy_from_user_unsafe.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/x86/mm/maccess.c    | 2 +-
 include/linux/uaccess.h  | 2 +-
 kernel/trace/bpf_trace.c | 2 +-
 mm/maccess.c             | 6 +++---
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/maccess.c b/arch/x86/mm/maccess.c
index f5b85bdc0535c..6290e9894fb55 100644
--- a/arch/x86/mm/maccess.c
+++ b/arch/x86/mm/maccess.c
@@ -34,7 +34,7 @@ long probe_kernel_read_strict(void *dst, const void *src, size_t size)
 	return __probe_kernel_read(dst, src, size);
 }
 
-long strncpy_from_unsafe_strict(char *dst, const void *unsafe_addr, long count)
+long strncpy_from_kernel_unsafe(char *dst, const void *unsafe_addr, long count)
 {
 	if (unlikely(invalid_probe_range((unsigned long)unsafe_addr)))
 		return -EFAULT;
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 74db16fac2a04..221d703480b6e 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -310,7 +310,7 @@ extern long notrace probe_kernel_write(void *dst, const void *src, size_t size);
 extern long notrace probe_user_write(void __user *dst, const void *src, size_t size);
 
 extern long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
-extern long strncpy_from_unsafe_strict(char *dst, const void *unsafe_addr,
+extern long strncpy_from_kernel_unsafe(char *dst, const void *unsafe_addr,
 				       long count);
 extern long __strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
 extern long strncpy_from_user_unsafe(char *dst, const void __user *unsafe_addr,
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index d3989384e515d..e4e202f433903 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -240,7 +240,7 @@ bpf_probe_read_kernel_str_common(void *dst, u32 size, const void *unsafe_ptr,
 	 * is returned that can be used for bpf_perf_event_output() et al.
 	 */
 	ret = compat ? strncpy_from_unsafe(dst, unsafe_ptr, size) :
-	      strncpy_from_unsafe_strict(dst, unsafe_ptr, size);
+	      strncpy_from_kernel_unsafe(dst, unsafe_ptr, size);
 	if (unlikely(ret < 0))
 out:
 		memset(dst, 0, size);
diff --git a/mm/maccess.c b/mm/maccess.c
index 76f9d4dd51300..683b70518a896 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -159,7 +159,7 @@ long probe_user_write(void __user *dst, const void *src, size_t size)
  * If @count is smaller than the length of the string, copies @count-1 bytes,
  * sets the last byte of @dst buffer to NUL and returns @count.
  *
- * Same as strncpy_from_unsafe_strict() except that for architectures with
+ * Same as strncpy_from_kernel_unsafe() except that for architectures with
  * not fully separated user and kernel address spaces this function also works
  * for user address tanges.
  *
@@ -170,7 +170,7 @@ long __weak strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
     __attribute__((alias("__strncpy_from_unsafe")));
 
 /**
- * strncpy_from_unsafe_strict: - Copy a NUL terminated string from unsafe
+ * strncpy_from_kernel_unsafe: - Copy a NUL terminated string from unsafe
  *				 address.
  * @dst:   Destination address, in kernel space.  This buffer must be at
  *         least @count bytes long.
@@ -187,7 +187,7 @@ long __weak strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
  * If @count is smaller than the length of the string, copies @count-1 bytes,
  * sets the last byte of @dst buffer to NUL and returns @count.
  */
-long __weak strncpy_from_unsafe_strict(char *dst, const void *unsafe_addr,
+long __weak strncpy_from_kernel_unsafe(char *dst, const void *unsafe_addr,
 				       long count)
     __attribute__((alias("__strncpy_from_unsafe")));
 
-- 
2.26.2

