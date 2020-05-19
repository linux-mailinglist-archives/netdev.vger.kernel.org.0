Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21F0E1D9876
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 15:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbgESNqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 09:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729131AbgESNpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 09:45:16 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA1AC08C5C0;
        Tue, 19 May 2020 06:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=vJr8Nd36WTtjRbTcnMJfPCvQoz7VGVQf3j70KzB4hjE=; b=jrCWhGlVo4Ct3iRycyUUPVuttW
        MP7KoMrZ/vwwhokUxNobucpMbvwMCOWuFEHctpnYImXmtK5px0AHhWgm5uEDt1GyMfS94/te4MBgQ
        GeYD/7qO9ZtJW9i8sJ8tRIjUrUj6sYUQ4AMPGcuGVlRopB68tWYzzBZEkq8L2VwWX4fDCbFqbh/tM
        an1U0+NRH0K58mSXpjiNj3arb/rkkvsKz0cfdLxqw3afYYg2Idl+kK0CkL/gBg8UvM4A9EQZZP/O7
        udBbQ3u4NtzjuqSmCxxXr52T+cCoWcBh9Voni0qXVMQszAqXvKS9aEEyKhtdAALSfA6fhNAHYpkQb
        mZG7raKQ==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jb2YU-0003E0-Bw; Tue, 19 May 2020 13:45:15 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/20] maccess: rename strncpy_from_unsafe_strict to strncpy_from_kernel_nofault
Date:   Tue, 19 May 2020 15:44:36 +0200
Message-Id: <20200519134449.1466624-8-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200519134449.1466624-1-hch@lst.de>
References: <20200519134449.1466624-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This matches the naming of strncpy_from_user_nofault, and also makes it
more clear what the function is supposed to do.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/x86/mm/maccess.c    | 2 +-
 include/linux/uaccess.h  | 4 ++--
 kernel/trace/bpf_trace.c | 4 ++--
 mm/maccess.c             | 6 +++---
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/maccess.c b/arch/x86/mm/maccess.c
index f5b85bdc0535c..62c4017a2473d 100644
--- a/arch/x86/mm/maccess.c
+++ b/arch/x86/mm/maccess.c
@@ -34,7 +34,7 @@ long probe_kernel_read_strict(void *dst, const void *src, size_t size)
 	return __probe_kernel_read(dst, src, size);
 }
 
-long strncpy_from_unsafe_strict(char *dst, const void *unsafe_addr, long count)
+long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
 {
 	if (unlikely(invalid_probe_range((unsigned long)unsafe_addr)))
 		return -EFAULT;
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index b983cb1c1216a..134ff9c1c151b 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -310,8 +310,8 @@ extern long notrace probe_kernel_write(void *dst, const void *src, size_t size);
 extern long notrace probe_user_write(void __user *dst, const void *src, size_t size);
 
 extern long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
-extern long strncpy_from_unsafe_strict(char *dst, const void *unsafe_addr,
-				       long count);
+long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr,
+		long count);
 extern long __strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
 long strncpy_from_user_nofault(char *dst, const void __user *unsafe_addr,
 		long count);
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 4e20bf1d95832..f5231ffea85b9 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -240,7 +240,7 @@ bpf_probe_read_kernel_str_common(void *dst, u32 size, const void *unsafe_ptr,
 	 * is returned that can be used for bpf_perf_event_output() et al.
 	 */
 	ret = compat ? strncpy_from_unsafe(dst, unsafe_ptr, size) :
-	      strncpy_from_unsafe_strict(dst, unsafe_ptr, size);
+	      strncpy_from_kernel_nofault(dst, unsafe_ptr, size);
 	if (unlikely(ret < 0))
 out:
 		memset(dst, 0, size);
@@ -412,7 +412,7 @@ BPF_CALL_5(bpf_trace_printk, char *, fmt, u32, fmt_size, u64, arg1,
 				break;
 #endif
 			case 'k':
-				strncpy_from_unsafe_strict(buf, unsafe_ptr,
+				strncpy_from_kernel_nofault(buf, unsafe_ptr,
 							   sizeof(buf));
 				break;
 			case 'u':
diff --git a/mm/maccess.c b/mm/maccess.c
index 457d8f9bf714f..c8748c2809096 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -159,7 +159,7 @@ long probe_user_write(void __user *dst, const void *src, size_t size)
  * If @count is smaller than the length of the string, copies @count-1 bytes,
  * sets the last byte of @dst buffer to NUL and returns @count.
  *
- * Same as strncpy_from_unsafe_strict() except that for architectures with
+ * Same as strncpy_from_kernel_nofault() except that for architectures with
  * not fully separated user and kernel address spaces this function also works
  * for user address tanges.
  *
@@ -170,7 +170,7 @@ long __weak strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
     __attribute__((alias("__strncpy_from_unsafe")));
 
 /**
- * strncpy_from_unsafe_strict: - Copy a NUL terminated string from unsafe
+ * strncpy_from_kernel_nofault: - Copy a NUL terminated string from unsafe
  *				 address.
  * @dst:   Destination address, in kernel space.  This buffer must be at
  *         least @count bytes long.
@@ -187,7 +187,7 @@ long __weak strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
  * If @count is smaller than the length of the string, copies @count-1 bytes,
  * sets the last byte of @dst buffer to NUL and returns @count.
  */
-long __weak strncpy_from_unsafe_strict(char *dst, const void *unsafe_addr,
+long __weak strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr,
 				       long count)
     __attribute__((alias("__strncpy_from_unsafe")));
 
-- 
2.26.2

