Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9361DD182
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 17:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730291AbgEUPYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 11:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730252AbgEUPYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 11:24:07 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D22CC061A0F;
        Thu, 21 May 2020 08:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=i5TU1vNWnnJC2NIa0U964oDN5YtEgAir0R98ZveIh/8=; b=T4I33JdbwslyweT7EllJeaMoqI
        IeCjIun7kmy5aXLrzeGZb3DTLRT1phKX9nxpMAfvO2cC5c0NPUDD5ffKNACUvoHXQZSwcg/9hyh9S
        SoovtksyMymVBJ1bV0VKZGjHNfb9JfS2UxddH4Q6WcJJb2A3vnzuRFbumtyl/6yS0Z/jJJ1rgU0qL
        EPrhnIRHZYV+GHeOxRyuzVe9zGTZ4rN5+7z1FMiQIr0wDSOwkuC52PO0SSCN9yD9PBc6D8sC6HPgu
        6QxL10yHlanSfYQ4wHcwv8lPYxuXK4Ivd+PgWYQWn0Ms/ST56QZavdzWXeXbeTdN2ChCoacrKdxGl
        ciOOTGZQ==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbn3F-0004tj-EZ; Thu, 21 May 2020 15:24:06 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 21/23] maccess: rename probe_user_{read,write} to copy_{from,to}_user_nofault
Date:   Thu, 21 May 2020 17:22:59 +0200
Message-Id: <20200521152301.2587579-22-hch@lst.de>
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

Better describe what these functions do.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/powerpc/kernel/process.c          |  3 ++-
 arch/powerpc/kvm/book3s_64_mmu_radix.c |  4 ++--
 arch/powerpc/mm/fault.c                |  2 +-
 arch/powerpc/oprofile/backtrace.c      |  6 ++++--
 arch/powerpc/perf/callchain_32.c       |  2 +-
 arch/powerpc/perf/callchain_64.c       |  2 +-
 arch/powerpc/perf/core-book3s.c        |  3 ++-
 arch/powerpc/sysdev/fsl_pci.c          |  4 ++--
 include/linux/uaccess.h                |  4 ++--
 kernel/trace/bpf_trace.c               |  4 ++--
 kernel/trace/trace_kprobe.c            |  2 +-
 mm/maccess.c                           | 10 +++++-----
 12 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 9c21288f86455..d5d6136b13480 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1294,7 +1294,8 @@ void show_user_instructions(struct pt_regs *regs)
 		for (i = 0; i < 8 && n; i++, n--, pc += sizeof(int)) {
 			int instr;
 
-			if (probe_user_read(&instr, (void __user *)pc, sizeof(instr))) {
+			if (copy_from_user_nofault(&instr, (void __user *)pc,
+					sizeof(instr))) {
 				seq_buf_printf(&s, "XXXXXXXX ");
 				continue;
 			}
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index aa12cd4078b32..9d25f2eb5a33a 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -64,9 +64,9 @@ unsigned long __kvmhv_copy_tofrom_guest_radix(int lpid, int pid,
 	isync();
 
 	if (is_load)
-		ret = probe_user_read(to, (const void __user *)from, n);
+		ret = copy_from_user_nofault(to, (const void __user *)from, n);
 	else
-		ret = probe_user_write((void __user *)to, from, n);
+		ret = copy_to_user_nofault((void __user *)to, from, n);
 
 	/* switch the pid first to avoid running host with unallocated pid */
 	if (quadrant == 1 && pid != old_pid)
diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 84af6c8eecf71..231664fe9d126 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -280,7 +280,7 @@ static bool bad_stack_expansion(struct pt_regs *regs, unsigned long address,
 		    access_ok(nip, sizeof(*nip))) {
 			unsigned int inst;
 
-			if (!probe_user_read(&inst, nip, sizeof(inst)))
+			if (!copy_from_user_nofault(&inst, nip, sizeof(inst)))
 				return !store_updates_sp(inst);
 			*must_retry = true;
 		}
diff --git a/arch/powerpc/oprofile/backtrace.c b/arch/powerpc/oprofile/backtrace.c
index 6f347fa29f41e..9db7ada79d10d 100644
--- a/arch/powerpc/oprofile/backtrace.c
+++ b/arch/powerpc/oprofile/backtrace.c
@@ -33,7 +33,8 @@ static unsigned int user_getsp32(unsigned int sp, int is_first)
 	 * which means that we've done all that we can do from
 	 * interrupt context.
 	 */
-	if (probe_user_read(stack_frame, (void __user *)p, sizeof(stack_frame)))
+	if (copy_from_user_nofault(stack_frame, (void __user *)p,
+			sizeof(stack_frame)))
 		return 0;
 
 	if (!is_first)
@@ -51,7 +52,8 @@ static unsigned long user_getsp64(unsigned long sp, int is_first)
 {
 	unsigned long stack_frame[3];
 
-	if (probe_user_read(stack_frame, (void __user *)sp, sizeof(stack_frame)))
+	if (copy_from_user_nofault(stack_frame, (void __user *)sp,
+			sizeof(stack_frame)))
 		return 0;
 
 	if (!is_first)
diff --git a/arch/powerpc/perf/callchain_32.c b/arch/powerpc/perf/callchain_32.c
index 8aa9510031415..2e21849f82b18 100644
--- a/arch/powerpc/perf/callchain_32.c
+++ b/arch/powerpc/perf/callchain_32.c
@@ -45,7 +45,7 @@ static int read_user_stack_32(unsigned int __user *ptr, unsigned int *ret)
 	    ((unsigned long)ptr & 3))
 		return -EFAULT;
 
-	rc = probe_user_read(ret, ptr, sizeof(*ret));
+	rc = copy_from_user_nofault(ret, ptr, sizeof(*ret));
 
 	if (IS_ENABLED(CONFIG_PPC64) && rc)
 		return read_user_stack_slow(ptr, ret, 4);
diff --git a/arch/powerpc/perf/callchain_64.c b/arch/powerpc/perf/callchain_64.c
index df1ffd8b20f21..7b0121694ebb7 100644
--- a/arch/powerpc/perf/callchain_64.c
+++ b/arch/powerpc/perf/callchain_64.c
@@ -71,7 +71,7 @@ static int read_user_stack_64(unsigned long __user *ptr, unsigned long *ret)
 	    ((unsigned long)ptr & 7))
 		return -EFAULT;
 
-	if (!probe_user_read(ret, ptr, sizeof(*ret)))
+	if (!copy_from_user_nofault(ret, ptr, sizeof(*ret)))
 		return 0;
 
 	return read_user_stack_slow(ptr, ret, 8);
diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index 50bc9f0eb6be3..f8072d1e5d172 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -426,7 +426,8 @@ static __u64 power_pmu_bhrb_to(u64 addr)
 	}
 
 	/* Userspace: need copy instruction here then translate it */
-	if (probe_user_read(&instr, (unsigned int __user *)addr, sizeof(instr)))
+	if (copy_from_user_nofault(&instr, (unsigned int __user *)addr,
+			sizeof(instr)))
 		return 0;
 
 	target = branch_target(&instr);
diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
index 4a8874bc10574..73fa37ca40ef9 100644
--- a/arch/powerpc/sysdev/fsl_pci.c
+++ b/arch/powerpc/sysdev/fsl_pci.c
@@ -1066,8 +1066,8 @@ int fsl_pci_mcheck_exception(struct pt_regs *regs)
 
 	if (is_in_pci_mem_space(addr)) {
 		if (user_mode(regs))
-			ret = probe_user_read(&inst, (void __user *)regs->nip,
-					      sizeof(inst));
+			ret = copy_from_user_nofault(&inst,
+					(void __user *)regs->nip, sizeof(inst));
 		else
 			ret = probe_kernel_address((void *)regs->nip, inst);
 
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 329e8479798de..5214d2f1f2cef 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -306,8 +306,8 @@ bool copy_from_kernel_nofault_allowed(const void *unsafe_src, size_t size);
 long copy_from_kernel_nofault(void *dst, const void *src, size_t size);
 long notrace copy_to_kernel_nofault(void *dst, const void *src, size_t size);
 
-extern long probe_user_read(void *dst, const void __user *src, size_t size);
-extern long notrace probe_user_write(void __user *dst, const void *src,
+long copy_from_user_nofault(void *dst, const void __user *src, size_t size);
+long notrace copy_to_user_nofault(void __user *dst, const void *src,
 		size_t size);
 
 long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr,
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 59fec6e226db7..580ceefe23059 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -141,7 +141,7 @@ bpf_probe_read_user_common(void *dst, u32 size, const void __user *unsafe_ptr)
 {
 	int ret;
 
-	ret = probe_user_read(dst, unsafe_ptr, size);
+	ret = copy_from_user_nofault(dst, unsafe_ptr, size);
 	if (unlikely(ret < 0))
 		memset(dst, 0, size);
 	return ret;
@@ -326,7 +326,7 @@ BPF_CALL_3(bpf_probe_write_user, void __user *, unsafe_ptr, const void *, src,
 	if (unlikely(!nmi_uaccess_okay()))
 		return -EPERM;
 
-	return probe_user_write(unsafe_ptr, src, size);
+	return copy_to_user_nofault(unsafe_ptr, src, size);
 }
 
 static const struct bpf_func_proto bpf_probe_write_user_proto = {
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 430e64c4117ee..af4dd69bcc398 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1290,7 +1290,7 @@ probe_mem_read_user(void *dest, void *src, size_t size)
 {
 	const void __user *uaddr =  (__force const void __user *)src;
 
-	return probe_user_read(dest, uaddr, size);
+	return copy_from_user_nofault(dest, uaddr, size);
 }
 
 static nokprobe_inline int
diff --git a/mm/maccess.c b/mm/maccess.c
index 43ed419f38401..349b6cb14426c 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -192,7 +192,7 @@ long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
 #endif /* HAVE_GET_KERNEL_NOFAULT */
 
 /**
- * probe_user_read(): safely attempt to read from a user-space location
+ * copy_from_user_nofault(): safely attempt to read from a user-space location
  * @dst: pointer to the buffer that shall take the data
  * @src: address to read from. This must be a user address.
  * @size: size of the data chunk
@@ -200,7 +200,7 @@ long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
  * Safely read from user address @src to the buffer at @dst. If a kernel fault
  * happens, handle that and return -EFAULT.
  */
-long probe_user_read(void *dst, const void __user *src, size_t size)
+long copy_from_user_nofault(void *dst, const void __user *src, size_t size)
 {
 	long ret = -EFAULT;
 	mm_segment_t old_fs = get_fs();
@@ -217,10 +217,10 @@ long probe_user_read(void *dst, const void __user *src, size_t size)
 		return -EFAULT;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(probe_user_read);
+EXPORT_SYMBOL_GPL(copy_from_user_nofault);
 
 /**
- * probe_user_write(): safely attempt to write to a user-space location
+ * copy_to_user_nofault(): safely attempt to write to a user-space location
  * @dst: address to write to
  * @src: pointer to the data that shall be written
  * @size: size of the data chunk
@@ -228,7 +228,7 @@ EXPORT_SYMBOL_GPL(probe_user_read);
  * Safely write to address @dst from the buffer at @src.  If a kernel fault
  * happens, handle that and return -EFAULT.
  */
-long probe_user_write(void __user *dst, const void *src, size_t size)
+long copy_to_user_nofault(void __user *dst, const void *src, size_t size)
 {
 	long ret = -EFAULT;
 	mm_segment_t old_fs = get_fs();
-- 
2.26.2

