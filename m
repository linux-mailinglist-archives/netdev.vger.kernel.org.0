Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 092071DD16E
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 17:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730212AbgEUPXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 11:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730169AbgEUPXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 11:23:47 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D463BC05BD43;
        Thu, 21 May 2020 08:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=fxWOG5hif9vKKfwkrFVmM3NLzLAalQTXvsWxwZiBbb8=; b=tLPDt4CXYSglY3h76YESUhYKt7
        J7svJNN2VWxKo5fiLN55He0+OYxMwHihpzccA/6pqOIk6QQRZb9GoogD1Bpu4Is9VaqR8zEDC0cBL
        suVR7wMoiJw/+SyTZTOTr6ocZU+uJOmR8sEZQuFFRTSLjGgWvP9Z52ytdUnOMMTLG2Z9pjZOUVsoR
        xSp9ZeKjCbRkpyUr2fGcMiaKZxyNKU3jxUVNoSwxusAdbOoCIXEhN1IBBfDnRDEy2bGW2bIHML3AI
        UH0MnonfWcMF0F7WZcUNh5+bsZPhmwYzF/JZ6Ex+byXTWsNsoM+5KEGXlS8ddrLAQ2PnBd+N9Ysh+
        kEKX+18g==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbn2v-0004WX-EX; Thu, 21 May 2020 15:23:46 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/23] tracing/kprobes: handle mixed kernel/userspace probes better
Date:   Thu, 21 May 2020 17:22:52 +0200
Message-Id: <20200521152301.2587579-15-hch@lst.de>
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

Instead of using the dangerous probe_kernel_read and strncpy_from_unsafe
helpers, rework probes to try a user probe based on the address if the
architecture has a common address space for kernel and userspace.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 kernel/trace/trace_kprobe.c | 72 ++++++++++++++++++++++---------------
 1 file changed, 43 insertions(+), 29 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 4325f9e7fadaa..4aeaef53ba970 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1200,6 +1200,15 @@ static const struct file_operations kprobe_profile_ops = {
 
 /* Kprobe specific fetch functions */
 
+/* Return the length of string -- including null terminal byte */
+static nokprobe_inline int
+fetch_store_strlen_user(unsigned long addr)
+{
+	const void __user *uaddr =  (__force const void __user *)addr;
+
+	return strnlen_user_nofault(uaddr, MAX_STRING_SIZE);
+}
+
 /* Return the length of string -- including null terminal byte */
 static nokprobe_inline int
 fetch_store_strlen(unsigned long addr)
@@ -1207,30 +1216,27 @@ fetch_store_strlen(unsigned long addr)
 	int ret, len = 0;
 	u8 c;
 
+#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+	if (addr < TASK_SIZE)
+		return fetch_store_strlen_user(addr);
+#endif
+
 	do {
-		ret = probe_kernel_read(&c, (u8 *)addr + len, 1);
+		ret = probe_kernel_read_strict(&c, (u8 *)addr + len, 1);
 		len++;
 	} while (c && ret == 0 && len < MAX_STRING_SIZE);
 
 	return (ret < 0) ? ret : len;
 }
 
-/* Return the length of string -- including null terminal byte */
-static nokprobe_inline int
-fetch_store_strlen_user(unsigned long addr)
-{
-	const void __user *uaddr =  (__force const void __user *)addr;
-
-	return strnlen_user_nofault(uaddr, MAX_STRING_SIZE);
-}
-
 /*
- * Fetch a null-terminated string. Caller MUST set *(u32 *)buf with max
- * length and relative data location.
+ * Fetch a null-terminated string from user. Caller MUST set *(u32 *)buf
+ * with max length and relative data location.
  */
 static nokprobe_inline int
-fetch_store_string(unsigned long addr, void *dest, void *base)
+fetch_store_string_user(unsigned long addr, void *dest, void *base)
 {
+	const void __user *uaddr =  (__force const void __user *)addr;
 	int maxlen = get_loc_len(*(u32 *)dest);
 	void *__dest;
 	long ret;
@@ -1240,11 +1246,7 @@ fetch_store_string(unsigned long addr, void *dest, void *base)
 
 	__dest = get_loc_data(dest, base);
 
-	/*
-	 * Try to get string again, since the string can be changed while
-	 * probing.
-	 */
-	ret = strncpy_from_unsafe(__dest, (void *)addr, maxlen);
+	ret = strncpy_from_user_nofault(__dest, uaddr, maxlen);
 	if (ret >= 0)
 		*(u32 *)dest = make_data_loc(ret, __dest - base);
 
@@ -1252,35 +1254,37 @@ fetch_store_string(unsigned long addr, void *dest, void *base)
 }
 
 /*
- * Fetch a null-terminated string from user. Caller MUST set *(u32 *)buf
- * with max length and relative data location.
+ * Fetch a null-terminated string. Caller MUST set *(u32 *)buf with max
+ * length and relative data location.
  */
 static nokprobe_inline int
-fetch_store_string_user(unsigned long addr, void *dest, void *base)
+fetch_store_string(unsigned long addr, void *dest, void *base)
 {
-	const void __user *uaddr =  (__force const void __user *)addr;
 	int maxlen = get_loc_len(*(u32 *)dest);
 	void *__dest;
 	long ret;
 
+#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+	if ((unsigned long)addr < TASK_SIZE)
+		return fetch_store_string_user(addr, dest, base);
+#endif
+
 	if (unlikely(!maxlen))
 		return -ENOMEM;
 
 	__dest = get_loc_data(dest, base);
 
-	ret = strncpy_from_user_nofault(__dest, uaddr, maxlen);
+	/*
+	 * Try to get string again, since the string can be changed while
+	 * probing.
+	 */
+	ret = strncpy_from_user_nofault(__dest, (void *)addr, maxlen);
 	if (ret >= 0)
 		*(u32 *)dest = make_data_loc(ret, __dest - base);
 
 	return ret;
 }
 
-static nokprobe_inline int
-probe_mem_read(void *dest, void *src, size_t size)
-{
-	return probe_kernel_read(dest, src, size);
-}
-
 static nokprobe_inline int
 probe_mem_read_user(void *dest, void *src, size_t size)
 {
@@ -1289,6 +1293,16 @@ probe_mem_read_user(void *dest, void *src, size_t size)
 	return probe_user_read(dest, uaddr, size);
 }
 
+static nokprobe_inline int
+probe_mem_read(void *dest, void *src, size_t size)
+{
+#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+	if ((unsigned long)src < TASK_SIZE)
+		return probe_mem_read_user(dest, src, size);
+#endif
+	return probe_kernel_read_strict(dest, src, size);
+}
+
 /* Note that we don't verify it, since the code does not come from user space */
 static int
 process_fetch_insn(struct fetch_insn *code, struct pt_regs *regs, void *dest,
-- 
2.26.2

