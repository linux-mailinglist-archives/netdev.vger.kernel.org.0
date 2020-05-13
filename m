Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34A3E1D1A36
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 18:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389483AbgEMQBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 12:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389474AbgEMQBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 12:01:11 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77DC2C061A0C;
        Wed, 13 May 2020 09:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=e1CZctNYK4d9hjU9VWYJ2crWHHVhF7paRXkIsU42MN4=; b=n7hdbbE1EOzvVCtETtvIHh+qrp
        28nml4L7/glz0jmjWbZOyrPevQHLpIokCh3WNHq5yVcJV2nG6407+T5WpQ3LPnISlzNVkTmgC2AIB
        MxmZ6MgLQ4jM5ofoFl4vbpDfYnIb6Iu4DLuMVi/aInRpB8uasWEEVWWpS/RrZrZsRFhjKXFm9dYxb
        l+nQNEj6dLd58St6tMhnfeaLYjuaFHsufN02Kcd/2CqpZJFH788MnnIjqvpm5TTPZ00diAIc4v4QU
        Jdg/rZYaNtCDO3Me9+r7gJ5ZP9o4k8BWDqeKHIexpXHDOlcmhmiGN/bA6qNNfcRmHdibBDY5QAB2o
        8uR1u9bw==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYtoj-0004ug-It; Wed, 13 May 2020 16:01:10 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/18] maccess: remove strncpy_from_unsafe
Date:   Wed, 13 May 2020 18:00:31 +0200
Message-Id: <20200513160038.2482415-12-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513160038.2482415-1-hch@lst.de>
References: <20200513160038.2482415-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All three callers really should try the explicit kernel and user
copies instead.  One has already deprecated the somewhat dangerous
either kernel or user address concept, the other two still need to
follow up eventually.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 include/linux/uaccess.h     |  1 -
 kernel/trace/bpf_trace.c    | 39 +++++++++++++++++++++++++------------
 kernel/trace/trace_kprobe.c |  5 ++++-
 mm/maccess.c                | 39 +------------------------------------
 4 files changed, 32 insertions(+), 52 deletions(-)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 7cfc10eb09c60..28944a14e0534 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -311,7 +311,6 @@ extern long probe_user_read(void *dst, const void __user *src, size_t size);
 extern long notrace probe_kernel_write(void *dst, const void *src, size_t size);
 extern long notrace probe_user_write(void __user *dst, const void *src, size_t size);
 
-extern long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
 long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr,
 		long count);
 
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 3dd4763c195bb..0d849acc9de38 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -226,12 +226,14 @@ static __always_inline int
 bpf_probe_read_kernel_str_common(void *dst, u32 size, const void *unsafe_ptr,
 				 const bool compat)
 {
+	const void __user *user_ptr = (__force const void __user *)unsafe_ptr;
 	int ret = security_locked_down(LOCKDOWN_BPF_READ);
 
 	if (unlikely(ret < 0))
-		goto out;
+		goto fail;
+
 	/*
-	 * The strncpy_from_unsafe_*() call will likely not fill the entire
+	 * The strncpy_from_*_nofault() calls will likely not fill the entire
 	 * buffer, but that's okay in this circumstance as we're probing
 	 * arbitrary memory anyway similar to bpf_probe_read_*() and might
 	 * as well probe the stack. Thus, memory is explicitly cleared
@@ -239,11 +241,16 @@ bpf_probe_read_kernel_str_common(void *dst, u32 size, const void *unsafe_ptr,
 	 * code altogether don't copy garbage; otherwise length of string
 	 * is returned that can be used for bpf_perf_event_output() et al.
 	 */
-	ret = compat ? strncpy_from_unsafe(dst, unsafe_ptr, size) :
-	      strncpy_from_kernel_nofault(dst, unsafe_ptr, size);
-	if (unlikely(ret < 0))
-out:
-		memset(dst, 0, size);
+	ret = strncpy_from_kernel_nofault(dst, unsafe_ptr, size);
+	if (unlikely(ret < 0)) {
+		if (compat)
+			ret = strncpy_from_user_nofault(dst, user_ptr, size);
+		if (unlikely(ret < 0))
+			goto fail;
+	}
+	return 0;
+fail:
+	memset(dst, 0, size);
 	return ret;
 }
 
@@ -321,6 +328,17 @@ static const struct bpf_func_proto *bpf_get_probe_write_proto(void)
 	return &bpf_probe_write_user_proto;
 }
 
+#define BPF_STRNCPY_LEN 64
+
+static void bpf_strncpy(char *buf, long unsafe_addr)
+{
+	buf[0] = 0;
+	if (strncpy_from_kernel_nofault(buf, (void *)unsafe_addr,
+			BPF_STRNCPY_LEN))
+		strncpy_from_user_nofault(buf, (void __user *)unsafe_addr,
+				BPF_STRNCPY_LEN);
+}
+
 /*
  * Only limited trace_printk() conversion specifiers allowed:
  * %d %i %u %x %ld %li %lu %lx %lld %lli %llu %llx %p %s
@@ -332,7 +350,7 @@ BPF_CALL_5(bpf_trace_printk, char *, fmt, u32, fmt_size, u64, arg1,
 	int mod[3] = {};
 	int fmt_cnt = 0;
 	u64 unsafe_addr;
-	char buf[64];
+	char buf[BPF_STRNCPY_LEN];
 	int i;
 
 	/*
@@ -387,10 +405,7 @@ BPF_CALL_5(bpf_trace_printk, char *, fmt, u32, fmt_size, u64, arg1,
 					arg3 = (long) buf;
 					break;
 				}
-				buf[0] = 0;
-				strncpy_from_unsafe(buf,
-						    (void *) (long) unsafe_addr,
-						    sizeof(buf));
+				bpf_strncpy(buf, unsafe_addr);
 			}
 			continue;
 		}
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 4325f9e7fadaa..8c456e30933d3 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1244,7 +1244,10 @@ fetch_store_string(unsigned long addr, void *dest, void *base)
 	 * Try to get string again, since the string can be changed while
 	 * probing.
 	 */
-	ret = strncpy_from_unsafe(__dest, (void *)addr, maxlen);
+	ret = strncpy_from_kernel_nofault(__dest, (void *)addr, maxlen);
+	if (ret < 0)
+		ret = strncpy_from_user_nofault(__dest, (void __user *)addr,
+				maxlen);
 	if (ret >= 0)
 		*(u32 *)dest = make_data_loc(ret, __dest - base);
 
diff --git a/mm/maccess.c b/mm/maccess.c
index 483a933b7d241..3d85e48013e6b 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -8,8 +8,6 @@
 
 static long __probe_kernel_read(void *dst, const void *src, size_t size,
 		bool strict);
-static long __strncpy_from_unsafe(char *dst, const void *unsafe_addr,
-		long count, bool strict);
 
 bool __weak probe_kernel_read_allowed(void *dst, const void *unsafe_src,
 		size_t size, bool strict)
@@ -156,35 +154,6 @@ long probe_user_write(void __user *dst, const void *src, size_t size)
 	return 0;
 }
 
-/**
- * strncpy_from_unsafe: - Copy a NUL terminated string from unsafe address.
- * @dst:   Destination address, in kernel space.  This buffer must be at
- *         least @count bytes long.
- * @unsafe_addr: Unsafe address.
- * @count: Maximum number of bytes to copy, including the trailing NUL.
- *
- * Copies a NUL-terminated string from unsafe address to kernel buffer.
- *
- * On success, returns the length of the string INCLUDING the trailing NUL.
- *
- * If access fails, returns -EFAULT (some data may have been copied
- * and the trailing NUL added).
- *
- * If @count is smaller than the length of the string, copies @count-1 bytes,
- * sets the last byte of @dst buffer to NUL and returns @count.
- *
- * Same as strncpy_from_kernel_nofault() except that for architectures with
- * not fully separated user and kernel address spaces this function also works
- * for user address tanges.
- *
- * DO NOT USE THIS FUNCTION - it is broken on architectures with entirely
- * separate kernel and user address spaces, and also a bad idea otherwise.
- */
-long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
-{
-	return __strncpy_from_unsafe(dst, unsafe_addr, count, false);
-}
-
 /**
  * strncpy_from_kernel_nofault: - Copy a NUL terminated string from unsafe
  *				 address.
@@ -204,12 +173,6 @@ long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
  * sets the last byte of @dst buffer to NUL and returns @count.
  */
 long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
-{
-	return __strncpy_from_unsafe(dst, unsafe_addr, count, true);
-}
-
-static long __strncpy_from_unsafe(char *dst, const void *unsafe_addr,
-		long count, bool strict)
 {
 	mm_segment_t old_fs = get_fs();
 	const void *src = unsafe_addr;
@@ -217,7 +180,7 @@ static long __strncpy_from_unsafe(char *dst, const void *unsafe_addr,
 
 	if (unlikely(count <= 0))
 		return 0;
-	if (!probe_kernel_read_allowed(dst, unsafe_addr, count, strict))
+	if (!probe_kernel_read_allowed(dst, unsafe_addr, count, true))
 		return -EFAULT;
 
 	set_fs(KERNEL_DS);
-- 
2.26.2

