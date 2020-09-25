Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9812B277F92
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 06:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbgIYExQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 00:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgIYEwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 00:52:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF04C0613CE;
        Thu, 24 Sep 2020 21:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=V2KQALojh4L6beBNImM13vl1+M9h9pbSNeu7cAMkUV4=; b=YRZ6UItjewrMGlnbC32fQHH0nL
        X83aDncwPE4S+tAzXcTs147/MCyPcuKJjP5ADThQLA7wrBrzqeGAjrp6FjE1U9/h3zK4Fta7ItMLu
        lGrL5xFgOYZtnSlKvTqMCC2ac3NXDeIKxxgzLrrtPBfi1Jiy5HlCKIyVDbgpIzLr9WxT80NGgYsvE
        H0z53OI2xjmrSe5J9aFkHCJwR+vlS2kwDaUuJVRSZfZh7tDB4myry1cD4RgrJoOIoaCILBfUBIREx
        eAdy9JLwmXYqD2E7xLRZ6TmqIe9rC3bo9UapR3RmAXGjgME/WMvQ21T+nPbJl0NHTUQJGLyKZ2wRF
        HlTuMS7w==;
Received: from p4fdb0c34.dip0.t-ipconnect.de ([79.219.12.52] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kLfi8-0002rL-Hy; Fri, 25 Sep 2020 04:51:56 +0000
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
Subject: [PATCH 7/9] fs: remove compat_sys_vmsplice
Date:   Fri, 25 Sep 2020 06:51:44 +0200
Message-Id: <20200925045146.1283714-8-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925045146.1283714-1-hch@lst.de>
References: <20200925045146.1283714-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that import_iovec handles compat iovecs, the native vmsplice syscall
can be used for the compat case as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/arm64/include/asm/unistd32.h             |  2 +-
 arch/mips/kernel/syscalls/syscall_n32.tbl     |  2 +-
 arch/mips/kernel/syscalls/syscall_o32.tbl     |  2 +-
 arch/parisc/kernel/syscalls/syscall.tbl       |  2 +-
 arch/powerpc/kernel/syscalls/syscall.tbl      |  2 +-
 arch/s390/kernel/syscalls/syscall.tbl         |  2 +-
 arch/sparc/kernel/syscalls/syscall.tbl        |  2 +-
 arch/x86/entry/syscall_x32.c                  |  1 +
 arch/x86/entry/syscalls/syscall_32.tbl        |  2 +-
 arch/x86/entry/syscalls/syscall_64.tbl        |  2 +-
 fs/splice.c                                   | 57 +++++--------------
 include/linux/compat.h                        |  4 --
 include/uapi/asm-generic/unistd.h             |  2 +-
 tools/include/uapi/asm-generic/unistd.h       |  2 +-
 .../arch/powerpc/entry/syscalls/syscall.tbl   |  2 +-
 .../perf/arch/s390/entry/syscalls/syscall.tbl |  2 +-
 .../arch/x86/entry/syscalls/syscall_64.tbl    |  2 +-
 17 files changed, 28 insertions(+), 62 deletions(-)

diff --git a/arch/arm64/include/asm/unistd32.h b/arch/arm64/include/asm/unistd32.h
index 4a236493dca5b9..11dfae3a8563bd 100644
--- a/arch/arm64/include/asm/unistd32.h
+++ b/arch/arm64/include/asm/unistd32.h
@@ -697,7 +697,7 @@ __SYSCALL(__NR_sync_file_range2, compat_sys_aarch32_sync_file_range2)
 #define __NR_tee 342
 __SYSCALL(__NR_tee, sys_tee)
 #define __NR_vmsplice 343
-__SYSCALL(__NR_vmsplice, compat_sys_vmsplice)
+__SYSCALL(__NR_vmsplice, sys_vmsplice)
 #define __NR_move_pages 344
 __SYSCALL(__NR_move_pages, compat_sys_move_pages)
 #define __NR_getcpu 345
diff --git a/arch/mips/kernel/syscalls/syscall_n32.tbl b/arch/mips/kernel/syscalls/syscall_n32.tbl
index c99a92646f8ee9..5a39d4de0ac85b 100644
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -278,7 +278,7 @@
 267	n32	splice				sys_splice
 268	n32	sync_file_range			sys_sync_file_range
 269	n32	tee				sys_tee
-270	n32	vmsplice			compat_sys_vmsplice
+270	n32	vmsplice			sys_vmsplice
 271	n32	move_pages			compat_sys_move_pages
 272	n32	set_robust_list			compat_sys_set_robust_list
 273	n32	get_robust_list			compat_sys_get_robust_list
diff --git a/arch/mips/kernel/syscalls/syscall_o32.tbl b/arch/mips/kernel/syscalls/syscall_o32.tbl
index 075064d10661bf..136efc6b8c5444 100644
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -318,7 +318,7 @@
 304	o32	splice				sys_splice
 305	o32	sync_file_range			sys_sync_file_range		sys32_sync_file_range
 306	o32	tee				sys_tee
-307	o32	vmsplice			sys_vmsplice			compat_sys_vmsplice
+307	o32	vmsplice			sys_vmsplice
 308	o32	move_pages			sys_move_pages			compat_sys_move_pages
 309	o32	set_robust_list			sys_set_robust_list		compat_sys_set_robust_list
 310	o32	get_robust_list			sys_get_robust_list		compat_sys_get_robust_list
diff --git a/arch/parisc/kernel/syscalls/syscall.tbl b/arch/parisc/kernel/syscalls/syscall.tbl
index 192abde0001d9d..a9e184192caedd 100644
--- a/arch/parisc/kernel/syscalls/syscall.tbl
+++ b/arch/parisc/kernel/syscalls/syscall.tbl
@@ -330,7 +330,7 @@
 292	32	sync_file_range		parisc_sync_file_range
 292	64	sync_file_range		sys_sync_file_range
 293	common	tee			sys_tee
-294	common	vmsplice		sys_vmsplice			compat_sys_vmsplice
+294	common	vmsplice		sys_vmsplice
 295	common	move_pages		sys_move_pages			compat_sys_move_pages
 296	common	getcpu			sys_getcpu
 297	common	epoll_pwait		sys_epoll_pwait			compat_sys_epoll_pwait
diff --git a/arch/powerpc/kernel/syscalls/syscall.tbl b/arch/powerpc/kernel/syscalls/syscall.tbl
index 6f1e2ecf0edad9..0d4985919ca34d 100644
--- a/arch/powerpc/kernel/syscalls/syscall.tbl
+++ b/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -369,7 +369,7 @@
 282	common	unshare				sys_unshare
 283	common	splice				sys_splice
 284	common	tee				sys_tee
-285	common	vmsplice			sys_vmsplice			compat_sys_vmsplice
+285	common	vmsplice			sys_vmsplice
 286	common	openat				sys_openat			compat_sys_openat
 287	common	mkdirat				sys_mkdirat
 288	common	mknodat				sys_mknodat
diff --git a/arch/s390/kernel/syscalls/syscall.tbl b/arch/s390/kernel/syscalls/syscall.tbl
index 6101cf2e004cb4..b5495a42814bd1 100644
--- a/arch/s390/kernel/syscalls/syscall.tbl
+++ b/arch/s390/kernel/syscalls/syscall.tbl
@@ -316,7 +316,7 @@
 306  common	splice			sys_splice			sys_splice
 307  common	sync_file_range		sys_sync_file_range		compat_sys_s390_sync_file_range
 308  common	tee			sys_tee				sys_tee
-309  common	vmsplice		sys_vmsplice			compat_sys_vmsplice
+309  common	vmsplice		sys_vmsplice			sys_vmsplice
 310  common	move_pages		sys_move_pages			compat_sys_move_pages
 311  common	getcpu			sys_getcpu			sys_getcpu
 312  common	epoll_pwait		sys_epoll_pwait			compat_sys_epoll_pwait
diff --git a/arch/sparc/kernel/syscalls/syscall.tbl b/arch/sparc/kernel/syscalls/syscall.tbl
index a87ddb282ab16f..f1810c1a35caa5 100644
--- a/arch/sparc/kernel/syscalls/syscall.tbl
+++ b/arch/sparc/kernel/syscalls/syscall.tbl
@@ -38,7 +38,7 @@
 23	64    	setuid			sys_setuid
 24	32	getuid			sys_getuid16
 24	64   	getuid			sys_getuid
-25	common	vmsplice		sys_vmsplice			compat_sys_vmsplice
+25	common	vmsplice		sys_vmsplice
 26	common	ptrace			sys_ptrace			compat_sys_ptrace
 27	common	alarm			sys_alarm
 28	common	sigaltstack		sys_sigaltstack			compat_sys_sigaltstack
diff --git a/arch/x86/entry/syscall_x32.c b/arch/x86/entry/syscall_x32.c
index aa321444a41f63..a4840b9d50ad14 100644
--- a/arch/x86/entry/syscall_x32.c
+++ b/arch/x86/entry/syscall_x32.c
@@ -16,6 +16,7 @@
 #define __x32_sys_writev	__x64_sys_writev
 #define __x32_sys_getsockopt	__x64_sys_getsockopt
 #define __x32_sys_setsockopt	__x64_sys_setsockopt
+#define __x32_sys_vmsplice	__x64_sys_vmsplice
 
 #define __SYSCALL_64(nr, sym)
 
diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 54ab4beb517f25..0fb2f172581e51 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -327,7 +327,7 @@
 313	i386	splice			sys_splice
 314	i386	sync_file_range		sys_ia32_sync_file_range
 315	i386	tee			sys_tee
-316	i386	vmsplice		sys_vmsplice			compat_sys_vmsplice
+316	i386	vmsplice		sys_vmsplice
 317	i386	move_pages		sys_move_pages			compat_sys_move_pages
 318	i386	getcpu			sys_getcpu
 319	i386	epoll_pwait		sys_epoll_pwait
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index b1e59957c5c51c..642af919183de4 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -388,7 +388,7 @@
 529	x32	waitid			compat_sys_waitid
 530	x32	set_robust_list		compat_sys_set_robust_list
 531	x32	get_robust_list		compat_sys_get_robust_list
-532	x32	vmsplice		compat_sys_vmsplice
+532	x32	vmsplice		sys_vmsplice
 533	x32	move_pages		compat_sys_move_pages
 534	x32	preadv			compat_sys_preadv64
 535	x32	pwritev			compat_sys_pwritev64
diff --git a/fs/splice.c b/fs/splice.c
index 132d42b9871f9b..18d84544030b39 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -33,7 +33,6 @@
 #include <linux/security.h>
 #include <linux/gfp.h>
 #include <linux/socket.h>
-#include <linux/compat.h>
 #include <linux/sched/signal.h>
 
 #include "internal.h"
@@ -1332,20 +1331,6 @@ static int vmsplice_type(struct fd f, int *type)
  * Currently we punt and implement it as a normal copy, see pipe_to_user().
  *
  */
-static long do_vmsplice(struct file *f, struct iov_iter *iter, unsigned int flags)
-{
-	if (unlikely(flags & ~SPLICE_F_ALL))
-		return -EINVAL;
-
-	if (!iov_iter_count(iter))
-		return 0;
-
-	if (iov_iter_rw(iter) == WRITE)
-		return vmsplice_to_pipe(f, iter, flags);
-	else
-		return vmsplice_to_user(f, iter, flags);
-}
-
 SYSCALL_DEFINE4(vmsplice, int, fd, const struct iovec __user *, uiov,
 		unsigned long, nr_segs, unsigned int, flags)
 {
@@ -1356,6 +1341,9 @@ SYSCALL_DEFINE4(vmsplice, int, fd, const struct iovec __user *, uiov,
 	struct fd f;
 	int type;
 
+	if (unlikely(flags & ~SPLICE_F_ALL))
+		return -EINVAL;
+
 	f = fdget(fd);
 	error = vmsplice_type(f, &type);
 	if (error)
@@ -1363,40 +1351,21 @@ SYSCALL_DEFINE4(vmsplice, int, fd, const struct iovec __user *, uiov,
 
 	error = import_iovec(type, uiov, nr_segs,
 			     ARRAY_SIZE(iovstack), &iov, &iter);
-	if (error >= 0) {
-		error = do_vmsplice(f.file, &iter, flags);
-		kfree(iov);
-	}
-	fdput(f);
-	return error;
-}
+	if (error < 0)
+		goto out_fdput;
 
-#ifdef CONFIG_COMPAT
-COMPAT_SYSCALL_DEFINE4(vmsplice, int, fd, const struct compat_iovec __user *, iov32,
-		    unsigned int, nr_segs, unsigned int, flags)
-{
-	struct iovec iovstack[UIO_FASTIOV];
-	struct iovec *iov = iovstack;
-	struct iov_iter iter;
-	ssize_t error;
-	struct fd f;
-	int type;
-
-	f = fdget(fd);
-	error = vmsplice_type(f, &type);
-	if (error)
-		return error;
+	if (!iov_iter_count(&iter))
+		error = 0;
+	else if (iov_iter_rw(&iter) == WRITE)
+		error = vmsplice_to_pipe(f.file, &iter, flags);
+	else
+		error = vmsplice_to_user(f.file, &iter, flags);
 
-	error = import_iovec(type, (struct iovec __user *)iov32, nr_segs,
-			     ARRAY_SIZE(iovstack), &iov, &iter);
-	if (error >= 0) {
-		error = do_vmsplice(f.file, &iter, flags);
-		kfree(iov);
-	}
+	kfree(iov);
+out_fdput:
 	fdput(f);
 	return error;
 }
-#endif
 
 SYSCALL_DEFINE6(splice, int, fd_in, loff_t __user *, off_in,
 		int, fd_out, loff_t __user *, off_out,
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 0f1620988267e6..9e8aa148651455 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -597,10 +597,6 @@ asmlinkage long compat_sys_signalfd4(int ufd,
 				     const compat_sigset_t __user *sigmask,
 				     compat_size_t sigsetsize, int flags);
 
-/* fs/splice.c */
-asmlinkage long compat_sys_vmsplice(int fd, const struct compat_iovec __user *,
-				    unsigned int nr_segs, unsigned int flags);
-
 /* fs/stat.c */
 asmlinkage long compat_sys_newfstatat(unsigned int dfd,
 				      const char __user *filename,
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 211c9eacbda6eb..f2dcb0d5703014 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -237,7 +237,7 @@ __SC_COMP(__NR_signalfd4, sys_signalfd4, compat_sys_signalfd4)
 
 /* fs/splice.c */
 #define __NR_vmsplice 75
-__SC_COMP(__NR_vmsplice, sys_vmsplice, compat_sys_vmsplice)
+__SYSCALL(__NR_vmsplice, sys_vmsplice)
 #define __NR_splice 76
 __SYSCALL(__NR_splice, sys_splice)
 #define __NR_tee 77
diff --git a/tools/include/uapi/asm-generic/unistd.h b/tools/include/uapi/asm-generic/unistd.h
index 211c9eacbda6eb..f2dcb0d5703014 100644
--- a/tools/include/uapi/asm-generic/unistd.h
+++ b/tools/include/uapi/asm-generic/unistd.h
@@ -237,7 +237,7 @@ __SC_COMP(__NR_signalfd4, sys_signalfd4, compat_sys_signalfd4)
 
 /* fs/splice.c */
 #define __NR_vmsplice 75
-__SC_COMP(__NR_vmsplice, sys_vmsplice, compat_sys_vmsplice)
+__SYSCALL(__NR_vmsplice, sys_vmsplice)
 #define __NR_splice 76
 __SYSCALL(__NR_splice, sys_splice)
 #define __NR_tee 77
diff --git a/tools/perf/arch/powerpc/entry/syscalls/syscall.tbl b/tools/perf/arch/powerpc/entry/syscalls/syscall.tbl
index 46be68029587f9..26f0347c15118b 100644
--- a/tools/perf/arch/powerpc/entry/syscalls/syscall.tbl
+++ b/tools/perf/arch/powerpc/entry/syscalls/syscall.tbl
@@ -363,7 +363,7 @@
 282	common	unshare				sys_unshare
 283	common	splice				sys_splice
 284	common	tee				sys_tee
-285	common	vmsplice			sys_vmsplice			compat_sys_vmsplice
+285	common	vmsplice			sys_vmsplice
 286	common	openat				sys_openat			compat_sys_openat
 287	common	mkdirat				sys_mkdirat
 288	common	mknodat				sys_mknodat
diff --git a/tools/perf/arch/s390/entry/syscalls/syscall.tbl b/tools/perf/arch/s390/entry/syscalls/syscall.tbl
index fb5e61ce9d5838..02ad81f69bb7e3 100644
--- a/tools/perf/arch/s390/entry/syscalls/syscall.tbl
+++ b/tools/perf/arch/s390/entry/syscalls/syscall.tbl
@@ -316,7 +316,7 @@
 306  common	splice			sys_splice			compat_sys_splice
 307  common	sync_file_range		sys_sync_file_range		compat_sys_s390_sync_file_range
 308  common	tee			sys_tee				compat_sys_tee
-309  common	vmsplice		sys_vmsplice			compat_sys_vmsplice
+309  common	vmsplice		sys_vmsplice			sys_vmsplice
 310  common	move_pages		sys_move_pages			compat_sys_move_pages
 311  common	getcpu			sys_getcpu			compat_sys_getcpu
 312  common	epoll_pwait		sys_epoll_pwait			compat_sys_epoll_pwait
diff --git a/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl b/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl
index b1e59957c5c51c..642af919183de4 100644
--- a/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl
@@ -388,7 +388,7 @@
 529	x32	waitid			compat_sys_waitid
 530	x32	set_robust_list		compat_sys_set_robust_list
 531	x32	get_robust_list		compat_sys_get_robust_list
-532	x32	vmsplice		compat_sys_vmsplice
+532	x32	vmsplice		sys_vmsplice
 533	x32	move_pages		compat_sys_move_pages
 534	x32	preadv			compat_sys_preadv64
 535	x32	pwritev			compat_sys_pwritev64
-- 
2.28.0

