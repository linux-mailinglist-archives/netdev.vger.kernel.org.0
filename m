Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 311CDE515C
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 18:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633078AbfJYQhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 12:37:20 -0400
Received: from www62.your-server.de ([213.133.104.62]:52450 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2633053AbfJYQhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 12:37:19 -0400
Received: from 33.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.33] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iO2aU-0003aZ-32; Fri, 25 Oct 2019 18:37:18 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next 1/5] uaccess: Add non-pagefault user-space write function
Date:   Fri, 25 Oct 2019 18:37:07 +0200
Message-Id: <8e63f4005c7139d88c5c78e2a19f539b2a1ff988.1572010897.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1572010897.git.daniel@iogearbox.net>
References: <cover.1572010897.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25613/Fri Oct 25 11:00:25 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 3d7081822f7f ("uaccess: Add non-pagefault user-space read functions")
missed to add probe write function, therefore factor out a probe_write_common()
helper with most logic of probe_kernel_write() except setting KERNEL_DS, and
add a new probe_user_write() helper so it can be used from BPF side.

Again, on some archs, the user address space and kernel address space can
co-exist and be overlapping, so in such case, setting KERNEL_DS would mean
that the given address is treated as being in kernel address space.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 include/linux/uaccess.h | 12 +++++++++++
 mm/maccess.c            | 45 +++++++++++++++++++++++++++++++++++++----
 2 files changed, 53 insertions(+), 4 deletions(-)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index e47d0522a1f4..86dcf2894672 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -337,6 +337,18 @@ extern long __probe_user_read(void *dst, const void __user *src, size_t size);
 extern long notrace probe_kernel_write(void *dst, const void *src, size_t size);
 extern long notrace __probe_kernel_write(void *dst, const void *src, size_t size);
 
+/*
+ * probe_user_write(): safely attempt to write to a location in user space
+ * @dst: address to write to
+ * @src: pointer to the data that shall be written
+ * @size: size of the data chunk
+ *
+ * Safely write to address @dst from the buffer at @src.  If a kernel fault
+ * happens, handle that and return -EFAULT.
+ */
+extern long notrace probe_user_write(void __user *dst, const void *src, size_t size);
+extern long notrace __probe_user_write(void __user *dst, const void *src, size_t size);
+
 extern long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
 extern long strncpy_from_unsafe_user(char *dst, const void __user *unsafe_addr,
 				     long count);
diff --git a/mm/maccess.c b/mm/maccess.c
index d065736f6b87..2d3c3d01064c 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -18,6 +18,18 @@ probe_read_common(void *dst, const void __user *src, size_t size)
 	return ret ? -EFAULT : 0;
 }
 
+static __always_inline long
+probe_write_common(void __user *dst, const void *src, size_t size)
+{
+	long ret;
+
+	pagefault_disable();
+	ret = __copy_to_user_inatomic(dst, src, size);
+	pagefault_enable();
+
+	return ret ? -EFAULT : 0;
+}
+
 /**
  * probe_kernel_read(): safely attempt to read from a kernel-space location
  * @dst: pointer to the buffer that shall take the data
@@ -85,6 +97,7 @@ EXPORT_SYMBOL_GPL(probe_user_read);
  * Safely write to address @dst from the buffer at @src.  If a kernel fault
  * happens, handle that and return -EFAULT.
  */
+
 long __weak probe_kernel_write(void *dst, const void *src, size_t size)
     __attribute__((alias("__probe_kernel_write")));
 
@@ -94,15 +107,39 @@ long __probe_kernel_write(void *dst, const void *src, size_t size)
 	mm_segment_t old_fs = get_fs();
 
 	set_fs(KERNEL_DS);
-	pagefault_disable();
-	ret = __copy_to_user_inatomic((__force void __user *)dst, src, size);
-	pagefault_enable();
+	ret = probe_write_common((__force void __user *)dst, src, size);
 	set_fs(old_fs);
 
-	return ret ? -EFAULT : 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(probe_kernel_write);
 
+/**
+ * probe_user_write(): safely attempt to write to a user-space location
+ * @dst: address to write to
+ * @src: pointer to the data that shall be written
+ * @size: size of the data chunk
+ *
+ * Safely write to address @dst from the buffer at @src.  If a kernel fault
+ * happens, handle that and return -EFAULT.
+ */
+
+long __weak probe_user_write(void __user *dst, const void *src, size_t size)
+    __attribute__((alias("__probe_user_write")));
+
+long __probe_user_write(void __user *dst, const void *src, size_t size)
+{
+	long ret = -EFAULT;
+	mm_segment_t old_fs = get_fs();
+
+	set_fs(USER_DS);
+	if (access_ok(dst, size))
+		ret = probe_write_common(dst, src, size);
+	set_fs(old_fs);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(probe_user_write);
 
 /**
  * strncpy_from_unsafe: - Copy a NUL terminated string from unsafe address.
-- 
2.21.0

