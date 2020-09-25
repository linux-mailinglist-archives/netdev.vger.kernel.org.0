Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01837277F4A
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 06:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbgIYEwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 00:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727179AbgIYEwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 00:52:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA004C0613CE;
        Thu, 24 Sep 2020 21:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Mt1va4jQKx2xt+rrFfiGSpGua9WL5LBsYe4eyMxKs3U=; b=YSV0++UGk7hNYBkdNiYJj3Sjyz
        27tEYJEfxSe5SoMMLVCy1I+NPwccLLNC9U7qLOuRt1sAYj3vpUKlSA/9A4UczZBYL7zxP7DOZ+thV
        m5uVZEoWFxqUKk8ZACbhkmJ6U8CcbBqMGFMFnjGGqrpIXe29P+/3UsghuLZz5sMM59wTlk6DZ3apv
        oPkLFBE09q4jmGDIbrpcNpxr67E6iMx6SX6EwMc2KVDxikR0rXNfh9yNdNfL69aZDcawdipwgQp0a
        w3R8CUPqIeQoEp4h//N6N5rBfDYA4Ou+w80TTtm1U0gOjtD7qPVyXea51eEHs6FBR5/TwUtXJQR0I
        bafFfnVw==;
Received: from p4fdb0c34.dip0.t-ipconnect.de ([79.219.12.52] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kLfi9-0002rg-TK; Fri, 25 Sep 2020 04:51:58 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        David Laight <David.Laight@aculab.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, keyrings@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH 8/9] mm: remove compat_process_vm_{readv,writev}
Date:   Fri, 25 Sep 2020 06:51:45 +0200
Message-Id: <20200925045146.1283714-9-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925045146.1283714-1-hch@lst.de>
References: <20200925045146.1283714-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that import_iovec handles compat iovecs, the native syscalls
can be used for the compat case as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/arm64/include/asm/unistd32.h             |  4 +-
 arch/mips/kernel/syscalls/syscall_n32.tbl     |  4 +-
 arch/mips/kernel/syscalls/syscall_o32.tbl     |  4 +-
 arch/parisc/kernel/syscalls/syscall.tbl       |  4 +-
 arch/powerpc/kernel/syscalls/syscall.tbl      |  4 +-
 arch/s390/kernel/syscalls/syscall.tbl         |  4 +-
 arch/sparc/kernel/syscalls/syscall.tbl        |  4 +-
 arch/x86/entry/syscall_x32.c                  |  2 +
 arch/x86/entry/syscalls/syscall_32.tbl        |  4 +-
 arch/x86/entry/syscalls/syscall_64.tbl        |  4 +-
 include/linux/compat.h                        |  8 ---
 include/uapi/asm-generic/unistd.h             |  6 +-
 mm/process_vm_access.c                        | 69 -------------------
 tools/include/uapi/asm-generic/unistd.h       |  6 +-
 .../arch/powerpc/entry/syscalls/syscall.tbl   |  4 +-
 .../perf/arch/s390/entry/syscalls/syscall.tbl |  4 +-
 .../arch/x86/entry/syscalls/syscall_64.tbl    |  4 +-
 17 files changed, 30 insertions(+), 109 deletions(-)

diff --git a/arch/arm64/include/asm/unistd32.h b/arch/arm64/include/asm/unistd32.h
index 11dfae3a8563bd..0c280a05f699bf 100644
--- a/arch/arm64/include/asm/unistd32.h
+++ b/arch/arm64/include/asm/unistd32.h
@@ -763,9 +763,9 @@ __SYSCALL(__NR_sendmmsg, compat_sys_sendmmsg)
 #define __NR_setns 375
 __SYSCALL(__NR_setns, sys_setns)
 #define __NR_process_vm_readv 376
-__SYSCALL(__NR_process_vm_readv, compat_sys_process_vm_readv)
+__SYSCALL(__NR_process_vm_readv, sys_process_vm_readv)
 #define __NR_process_vm_writev 377
-__SYSCALL(__NR_process_vm_writev, compat_sys_process_vm_writev)
+__SYSCALL(__NR_process_vm_writev, sys_process_vm_writev)
 #define __NR_kcmp 378
 __SYSCALL(__NR_kcmp, sys_kcmp)
 #define __NR_finit_module 379
diff --git a/arch/mips/kernel/syscalls/syscall_n32.tbl b/arch/mips/kernel/syscalls/syscall_n32.tbl
index 5a39d4de0ac85b..0bc2e0fcf1ee56 100644
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -317,8 +317,8 @@
 306	n32	syncfs				sys_syncfs
 307	n32	sendmmsg			compat_sys_sendmmsg
 308	n32	setns				sys_setns
-309	n32	process_vm_readv		compat_sys_process_vm_readv
-310	n32	process_vm_writev		compat_sys_process_vm_writev
+309	n32	process_vm_readv		sys_process_vm_readv
+310	n32	process_vm_writev		sys_process_vm_writev
 311	n32	kcmp				sys_kcmp
 312	n32	finit_module			sys_finit_module
 313	n32	sched_setattr			sys_sched_setattr
diff --git a/arch/mips/kernel/syscalls/syscall_o32.tbl b/arch/mips/kernel/syscalls/syscall_o32.tbl
index 136efc6b8c5444..b408c13b934296 100644
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -356,8 +356,8 @@
 342	o32	syncfs				sys_syncfs
 343	o32	sendmmsg			sys_sendmmsg			compat_sys_sendmmsg
 344	o32	setns				sys_setns
-345	o32	process_vm_readv		sys_process_vm_readv		compat_sys_process_vm_readv
-346	o32	process_vm_writev		sys_process_vm_writev		compat_sys_process_vm_writev
+345	o32	process_vm_readv		sys_process_vm_readv
+346	o32	process_vm_writev		sys_process_vm_writev
 347	o32	kcmp				sys_kcmp
 348	o32	finit_module			sys_finit_module
 349	o32	sched_setattr			sys_sched_setattr
diff --git a/arch/parisc/kernel/syscalls/syscall.tbl b/arch/parisc/kernel/syscalls/syscall.tbl
index a9e184192caedd..2015a5124b78ad 100644
--- a/arch/parisc/kernel/syscalls/syscall.tbl
+++ b/arch/parisc/kernel/syscalls/syscall.tbl
@@ -372,8 +372,8 @@
 327	common	syncfs			sys_syncfs
 328	common	setns			sys_setns
 329	common	sendmmsg		sys_sendmmsg			compat_sys_sendmmsg
-330	common	process_vm_readv	sys_process_vm_readv		compat_sys_process_vm_readv
-331	common	process_vm_writev	sys_process_vm_writev		compat_sys_process_vm_writev
+330	common	process_vm_readv	sys_process_vm_readv
+331	common	process_vm_writev	sys_process_vm_writev
 332	common	kcmp			sys_kcmp
 333	common	finit_module		sys_finit_module
 334	common	sched_setattr		sys_sched_setattr
diff --git a/arch/powerpc/kernel/syscalls/syscall.tbl b/arch/powerpc/kernel/syscalls/syscall.tbl
index 0d4985919ca34d..66a472aa635d3f 100644
--- a/arch/powerpc/kernel/syscalls/syscall.tbl
+++ b/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -449,8 +449,8 @@
 348	common	syncfs				sys_syncfs
 349	common	sendmmsg			sys_sendmmsg			compat_sys_sendmmsg
 350	common	setns				sys_setns
-351	nospu	process_vm_readv		sys_process_vm_readv		compat_sys_process_vm_readv
-352	nospu	process_vm_writev		sys_process_vm_writev		compat_sys_process_vm_writev
+351	nospu	process_vm_readv		sys_process_vm_readv
+352	nospu	process_vm_writev		sys_process_vm_writev
 353	nospu	finit_module			sys_finit_module
 354	nospu	kcmp				sys_kcmp
 355	common	sched_setattr			sys_sched_setattr
diff --git a/arch/s390/kernel/syscalls/syscall.tbl b/arch/s390/kernel/syscalls/syscall.tbl
index b5495a42814bd1..7485867a490bb2 100644
--- a/arch/s390/kernel/syscalls/syscall.tbl
+++ b/arch/s390/kernel/syscalls/syscall.tbl
@@ -347,8 +347,8 @@
 337  common	clock_adjtime		sys_clock_adjtime		sys_clock_adjtime32
 338  common	syncfs			sys_syncfs			sys_syncfs
 339  common	setns			sys_setns			sys_setns
-340  common	process_vm_readv	sys_process_vm_readv		compat_sys_process_vm_readv
-341  common	process_vm_writev	sys_process_vm_writev		compat_sys_process_vm_writev
+340  common	process_vm_readv	sys_process_vm_readv		sys_process_vm_readv
+341  common	process_vm_writev	sys_process_vm_writev		sys_process_vm_writev
 342  common	s390_runtime_instr	sys_s390_runtime_instr		sys_s390_runtime_instr
 343  common	kcmp			sys_kcmp			sys_kcmp
 344  common	finit_module		sys_finit_module		sys_finit_module
diff --git a/arch/sparc/kernel/syscalls/syscall.tbl b/arch/sparc/kernel/syscalls/syscall.tbl
index f1810c1a35caa5..4a9365b2e340b2 100644
--- a/arch/sparc/kernel/syscalls/syscall.tbl
+++ b/arch/sparc/kernel/syscalls/syscall.tbl
@@ -406,8 +406,8 @@
 335	common	syncfs			sys_syncfs
 336	common	sendmmsg		sys_sendmmsg			compat_sys_sendmmsg
 337	common	setns			sys_setns
-338	common	process_vm_readv	sys_process_vm_readv		compat_sys_process_vm_readv
-339	common	process_vm_writev	sys_process_vm_writev		compat_sys_process_vm_writev
+338	common	process_vm_readv	sys_process_vm_readv
+339	common	process_vm_writev	sys_process_vm_writev
 340	32	kern_features		sys_ni_syscall			sys_kern_features
 340	64	kern_features		sys_kern_features
 341	common	kcmp			sys_kcmp
diff --git a/arch/x86/entry/syscall_x32.c b/arch/x86/entry/syscall_x32.c
index a4840b9d50ad14..f2fe0a33bcfdd5 100644
--- a/arch/x86/entry/syscall_x32.c
+++ b/arch/x86/entry/syscall_x32.c
@@ -17,6 +17,8 @@
 #define __x32_sys_getsockopt	__x64_sys_getsockopt
 #define __x32_sys_setsockopt	__x64_sys_setsockopt
 #define __x32_sys_vmsplice	__x64_sys_vmsplice
+#define __x32_sys_process_vm_readv	__x64_sys_process_vm_readv
+#define __x32_sys_process_vm_writev	__x64_sys_process_vm_writev
 
 #define __SYSCALL_64(nr, sym)
 
diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 0fb2f172581e51..5fbe10ad8a23fc 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -358,8 +358,8 @@
 344	i386	syncfs			sys_syncfs
 345	i386	sendmmsg		sys_sendmmsg			compat_sys_sendmmsg
 346	i386	setns			sys_setns
-347	i386	process_vm_readv	sys_process_vm_readv		compat_sys_process_vm_readv
-348	i386	process_vm_writev	sys_process_vm_writev		compat_sys_process_vm_writev
+347	i386	process_vm_readv	sys_process_vm_readv
+348	i386	process_vm_writev	sys_process_vm_writev
 349	i386	kcmp			sys_kcmp
 350	i386	finit_module		sys_finit_module
 351	i386	sched_setattr		sys_sched_setattr
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 642af919183de4..347809649ba28f 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -395,8 +395,8 @@
 536	x32	rt_tgsigqueueinfo	compat_sys_rt_tgsigqueueinfo
 537	x32	recvmmsg		compat_sys_recvmmsg_time64
 538	x32	sendmmsg		compat_sys_sendmmsg
-539	x32	process_vm_readv	compat_sys_process_vm_readv
-540	x32	process_vm_writev	compat_sys_process_vm_writev
+539	x32	process_vm_readv	sys_process_vm_readv
+540	x32	process_vm_writev	sys_process_vm_writev
 541	x32	setsockopt		sys_setsockopt
 542	x32	getsockopt		sys_getsockopt
 543	x32	io_setup		compat_sys_io_setup
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 9e8aa148651455..2ae4e4bc22c0a4 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -780,14 +780,6 @@ asmlinkage long compat_sys_open_by_handle_at(int mountdirfd,
 					     int flags);
 asmlinkage long compat_sys_sendmmsg(int fd, struct compat_mmsghdr __user *mmsg,
 				    unsigned vlen, unsigned int flags);
-asmlinkage ssize_t compat_sys_process_vm_readv(compat_pid_t pid,
-		const struct compat_iovec __user *lvec,
-		compat_ulong_t liovcnt, const struct compat_iovec __user *rvec,
-		compat_ulong_t riovcnt, compat_ulong_t flags);
-asmlinkage ssize_t compat_sys_process_vm_writev(compat_pid_t pid,
-		const struct compat_iovec __user *lvec,
-		compat_ulong_t liovcnt, const struct compat_iovec __user *rvec,
-		compat_ulong_t riovcnt, compat_ulong_t flags);
 asmlinkage long compat_sys_execveat(int dfd, const char __user *filename,
 		     const compat_uptr_t __user *argv,
 		     const compat_uptr_t __user *envp, int flags);
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index f2dcb0d5703014..c1dfe99c9c3f70 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -727,11 +727,9 @@ __SYSCALL(__NR_setns, sys_setns)
 #define __NR_sendmmsg 269
 __SC_COMP(__NR_sendmmsg, sys_sendmmsg, compat_sys_sendmmsg)
 #define __NR_process_vm_readv 270
-__SC_COMP(__NR_process_vm_readv, sys_process_vm_readv, \
-          compat_sys_process_vm_readv)
+__SYSCALL(__NR_process_vm_readv, sys_process_vm_readv)
 #define __NR_process_vm_writev 271
-__SC_COMP(__NR_process_vm_writev, sys_process_vm_writev, \
-          compat_sys_process_vm_writev)
+__SYSCALL(__NR_process_vm_writev, sys_process_vm_writev)
 #define __NR_kcmp 272
 __SYSCALL(__NR_kcmp, sys_kcmp)
 #define __NR_finit_module 273
diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
index 3f2156aab44263..fd12da80b6f27b 100644
--- a/mm/process_vm_access.c
+++ b/mm/process_vm_access.c
@@ -14,10 +14,6 @@
 #include <linux/slab.h>
 #include <linux/syscalls.h>
 
-#ifdef CONFIG_COMPAT
-#include <linux/compat.h>
-#endif
-
 /**
  * process_vm_rw_pages - read/write pages from task specified
  * @pages: array of pointers to pages we want to copy
@@ -304,68 +300,3 @@ SYSCALL_DEFINE6(process_vm_writev, pid_t, pid,
 {
 	return process_vm_rw(pid, lvec, liovcnt, rvec, riovcnt, flags, 1);
 }
-
-#ifdef CONFIG_COMPAT
-
-static ssize_t
-compat_process_vm_rw(compat_pid_t pid,
-		     const struct compat_iovec __user *lvec,
-		     unsigned long liovcnt,
-		     const struct compat_iovec __user *rvec,
-		     unsigned long riovcnt,
-		     unsigned long flags, int vm_write)
-{
-	struct iovec iovstack_l[UIO_FASTIOV];
-	struct iovec iovstack_r[UIO_FASTIOV];
-	struct iovec *iov_l = iovstack_l;
-	struct iovec *iov_r = iovstack_r;
-	struct iov_iter iter;
-	ssize_t rc = -EFAULT;
-	int dir = vm_write ? WRITE : READ;
-
-	if (flags != 0)
-		return -EINVAL;
-
-	rc = import_iovec(dir, (const struct iovec __user *)lvec, liovcnt,
-			  UIO_FASTIOV, &iov_l, &iter);
-	if (rc < 0)
-		return rc;
-	if (!iov_iter_count(&iter))
-		goto free_iov_l;
-	iov_r = iovec_from_user((const struct iovec __user *)rvec, riovcnt,
-				UIO_FASTIOV, iovstack_r, true);
-	if (IS_ERR(iov_r)) {
-		rc = PTR_ERR(iov_r);
-		goto free_iov_l;
-	}
-	rc = process_vm_rw_core(pid, &iter, iov_r, riovcnt, flags, vm_write);
-	if (iov_r != iovstack_r)
-		kfree(iov_r);
-free_iov_l:
-	kfree(iov_l);
-	return rc;
-}
-
-COMPAT_SYSCALL_DEFINE6(process_vm_readv, compat_pid_t, pid,
-		       const struct compat_iovec __user *, lvec,
-		       compat_ulong_t, liovcnt,
-		       const struct compat_iovec __user *, rvec,
-		       compat_ulong_t, riovcnt,
-		       compat_ulong_t, flags)
-{
-	return compat_process_vm_rw(pid, lvec, liovcnt, rvec,
-				    riovcnt, flags, 0);
-}
-
-COMPAT_SYSCALL_DEFINE6(process_vm_writev, compat_pid_t, pid,
-		       const struct compat_iovec __user *, lvec,
-		       compat_ulong_t, liovcnt,
-		       const struct compat_iovec __user *, rvec,
-		       compat_ulong_t, riovcnt,
-		       compat_ulong_t, flags)
-{
-	return compat_process_vm_rw(pid, lvec, liovcnt, rvec,
-				    riovcnt, flags, 1);
-}
-
-#endif
diff --git a/tools/include/uapi/asm-generic/unistd.h b/tools/include/uapi/asm-generic/unistd.h
index f2dcb0d5703014..c1dfe99c9c3f70 100644
--- a/tools/include/uapi/asm-generic/unistd.h
+++ b/tools/include/uapi/asm-generic/unistd.h
@@ -727,11 +727,9 @@ __SYSCALL(__NR_setns, sys_setns)
 #define __NR_sendmmsg 269
 __SC_COMP(__NR_sendmmsg, sys_sendmmsg, compat_sys_sendmmsg)
 #define __NR_process_vm_readv 270
-__SC_COMP(__NR_process_vm_readv, sys_process_vm_readv, \
-          compat_sys_process_vm_readv)
+__SYSCALL(__NR_process_vm_readv, sys_process_vm_readv)
 #define __NR_process_vm_writev 271
-__SC_COMP(__NR_process_vm_writev, sys_process_vm_writev, \
-          compat_sys_process_vm_writev)
+__SYSCALL(__NR_process_vm_writev, sys_process_vm_writev)
 #define __NR_kcmp 272
 __SYSCALL(__NR_kcmp, sys_kcmp)
 #define __NR_finit_module 273
diff --git a/tools/perf/arch/powerpc/entry/syscalls/syscall.tbl b/tools/perf/arch/powerpc/entry/syscalls/syscall.tbl
index 26f0347c15118b..a188f053cbf90a 100644
--- a/tools/perf/arch/powerpc/entry/syscalls/syscall.tbl
+++ b/tools/perf/arch/powerpc/entry/syscalls/syscall.tbl
@@ -443,8 +443,8 @@
 348	common	syncfs				sys_syncfs
 349	common	sendmmsg			sys_sendmmsg			compat_sys_sendmmsg
 350	common	setns				sys_setns
-351	nospu	process_vm_readv		sys_process_vm_readv		compat_sys_process_vm_readv
-352	nospu	process_vm_writev		sys_process_vm_writev		compat_sys_process_vm_writev
+351	nospu	process_vm_readv		sys_process_vm_readv
+352	nospu	process_vm_writev		sys_process_vm_writev
 353	nospu	finit_module			sys_finit_module
 354	nospu	kcmp				sys_kcmp
 355	common	sched_setattr			sys_sched_setattr
diff --git a/tools/perf/arch/s390/entry/syscalls/syscall.tbl b/tools/perf/arch/s390/entry/syscalls/syscall.tbl
index 02ad81f69bb7e3..c44c83032c3a04 100644
--- a/tools/perf/arch/s390/entry/syscalls/syscall.tbl
+++ b/tools/perf/arch/s390/entry/syscalls/syscall.tbl
@@ -347,8 +347,8 @@
 337  common	clock_adjtime		sys_clock_adjtime		compat_sys_clock_adjtime
 338  common	syncfs			sys_syncfs			sys_syncfs
 339  common	setns			sys_setns			sys_setns
-340  common	process_vm_readv	sys_process_vm_readv		compat_sys_process_vm_readv
-341  common	process_vm_writev	sys_process_vm_writev		compat_sys_process_vm_writev
+340  common	process_vm_readv	sys_process_vm_readv		sys_process_vm_readv
+341  common	process_vm_writev	sys_process_vm_writev		sys_process_vm_writev
 342  common	s390_runtime_instr	sys_s390_runtime_instr		sys_s390_runtime_instr
 343  common	kcmp			sys_kcmp			compat_sys_kcmp
 344  common	finit_module		sys_finit_module		compat_sys_finit_module
diff --git a/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl b/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl
index 642af919183de4..347809649ba28f 100644
--- a/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl
@@ -395,8 +395,8 @@
 536	x32	rt_tgsigqueueinfo	compat_sys_rt_tgsigqueueinfo
 537	x32	recvmmsg		compat_sys_recvmmsg_time64
 538	x32	sendmmsg		compat_sys_sendmmsg
-539	x32	process_vm_readv	compat_sys_process_vm_readv
-540	x32	process_vm_writev	compat_sys_process_vm_writev
+539	x32	process_vm_readv	sys_process_vm_readv
+540	x32	process_vm_writev	sys_process_vm_writev
 541	x32	setsockopt		sys_setsockopt
 542	x32	getsockopt		sys_getsockopt
 543	x32	io_setup		compat_sys_io_setup
-- 
2.28.0

