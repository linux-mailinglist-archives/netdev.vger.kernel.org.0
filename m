Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8C8277F49
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 06:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbgIYEwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 00:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727149AbgIYEwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 00:52:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2AAC0613D3;
        Thu, 24 Sep 2020 21:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=voI7JY0g3ipbPucoh1FvUn9JvI0fm/QDsUmyIvkSXDA=; b=v/WUvf0nbm+GBegYfhxJh7jHmL
        tbdFZ5CsGZRLoNMz8mzGQ7JgPaou5mlM4MvbjaFvLtB6+guRqDw3RJtnwRS1wA98HFLpZ14oYnix9
        ndsDDMMnk8Dzj2NMSqebaomHYn3hIkaENbXZY/0RGs5MmodqBfZ8OWYH6ohYID53pkyEoTFY8nvTb
        uNijjpO3M7Pvq3Oc1JSB6g/e/leoWHrGy3KZ0buZDiHz8r5xY1xrVeA/mw9TzwreULDQ1Vue/LrRi
        XGa/Ui/QvLAKClCl9g53fwp8uFIKONi+SIO2yPARxETIUH04x/Ifk9t2ekeGHXimb9fJp+tJkB2n9
        DaDTkCBA==;
Received: from p4fdb0c34.dip0.t-ipconnect.de ([79.219.12.52] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kLfi7-0002r9-Dd; Fri, 25 Sep 2020 04:51:55 +0000
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
Subject: [PATCH 6/9] fs: remove the compat readv/writev syscalls
Date:   Fri, 25 Sep 2020 06:51:43 +0200
Message-Id: <20200925045146.1283714-7-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925045146.1283714-1-hch@lst.de>
References: <20200925045146.1283714-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that import_iovec handles compat iovecs, the native readv and writev
syscalls can be used for the compat case as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/arm64/include/asm/unistd32.h                  |  4 ++--
 arch/mips/kernel/syscalls/syscall_n32.tbl          |  4 ++--
 arch/mips/kernel/syscalls/syscall_o32.tbl          |  4 ++--
 arch/parisc/kernel/syscalls/syscall.tbl            |  4 ++--
 arch/powerpc/kernel/syscalls/syscall.tbl           |  4 ++--
 arch/s390/kernel/syscalls/syscall.tbl              |  4 ++--
 arch/sparc/kernel/syscalls/syscall.tbl             |  4 ++--
 arch/x86/entry/syscall_x32.c                       |  2 ++
 arch/x86/entry/syscalls/syscall_32.tbl             |  4 ++--
 arch/x86/entry/syscalls/syscall_64.tbl             |  4 ++--
 fs/read_write.c                                    | 14 --------------
 include/linux/compat.h                             |  4 ----
 include/uapi/asm-generic/unistd.h                  |  4 ++--
 tools/include/uapi/asm-generic/unistd.h            |  4 ++--
 tools/perf/arch/powerpc/entry/syscalls/syscall.tbl |  4 ++--
 tools/perf/arch/s390/entry/syscalls/syscall.tbl    |  4 ++--
 tools/perf/arch/x86/entry/syscalls/syscall_64.tbl  |  4 ++--
 17 files changed, 30 insertions(+), 46 deletions(-)

diff --git a/arch/arm64/include/asm/unistd32.h b/arch/arm64/include/asm/unistd32.h
index 734860ac7cf9d5..4a236493dca5b9 100644
--- a/arch/arm64/include/asm/unistd32.h
+++ b/arch/arm64/include/asm/unistd32.h
@@ -301,9 +301,9 @@ __SYSCALL(__NR_flock, sys_flock)
 #define __NR_msync 144
 __SYSCALL(__NR_msync, sys_msync)
 #define __NR_readv 145
-__SYSCALL(__NR_readv, compat_sys_readv)
+__SYSCALL(__NR_readv, sys_readv)
 #define __NR_writev 146
-__SYSCALL(__NR_writev, compat_sys_writev)
+__SYSCALL(__NR_writev, sys_writev)
 #define __NR_getsid 147
 __SYSCALL(__NR_getsid, sys_getsid)
 #define __NR_fdatasync 148
diff --git a/arch/mips/kernel/syscalls/syscall_n32.tbl b/arch/mips/kernel/syscalls/syscall_n32.tbl
index f9df9edb67a407..c99a92646f8ee9 100644
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -25,8 +25,8 @@
 15	n32	ioctl				compat_sys_ioctl
 16	n32	pread64				sys_pread64
 17	n32	pwrite64			sys_pwrite64
-18	n32	readv				compat_sys_readv
-19	n32	writev				compat_sys_writev
+18	n32	readv				sys_readv
+19	n32	writev				sys_writev
 20	n32	access				sys_access
 21	n32	pipe				sysm_pipe
 22	n32	_newselect			compat_sys_select
diff --git a/arch/mips/kernel/syscalls/syscall_o32.tbl b/arch/mips/kernel/syscalls/syscall_o32.tbl
index 195b43cf27c848..075064d10661bf 100644
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -156,8 +156,8 @@
 142	o32	_newselect			sys_select			compat_sys_select
 143	o32	flock				sys_flock
 144	o32	msync				sys_msync
-145	o32	readv				sys_readv			compat_sys_readv
-146	o32	writev				sys_writev			compat_sys_writev
+145	o32	readv				sys_readv
+146	o32	writev				sys_writev
 147	o32	cacheflush			sys_cacheflush
 148	o32	cachectl			sys_cachectl
 149	o32	sysmips				__sys_sysmips
diff --git a/arch/parisc/kernel/syscalls/syscall.tbl b/arch/parisc/kernel/syscalls/syscall.tbl
index def64d221cd4fb..192abde0001d9d 100644
--- a/arch/parisc/kernel/syscalls/syscall.tbl
+++ b/arch/parisc/kernel/syscalls/syscall.tbl
@@ -159,8 +159,8 @@
 142	common	_newselect		sys_select			compat_sys_select
 143	common	flock			sys_flock
 144	common	msync			sys_msync
-145	common	readv			sys_readv			compat_sys_readv
-146	common	writev			sys_writev			compat_sys_writev
+145	common	readv			sys_readv
+146	common	writev			sys_writev
 147	common	getsid			sys_getsid
 148	common	fdatasync		sys_fdatasync
 149	common	_sysctl			sys_ni_syscall
diff --git a/arch/powerpc/kernel/syscalls/syscall.tbl b/arch/powerpc/kernel/syscalls/syscall.tbl
index c2d737ff2e7bec..6f1e2ecf0edad9 100644
--- a/arch/powerpc/kernel/syscalls/syscall.tbl
+++ b/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -193,8 +193,8 @@
 142	common	_newselect			sys_select			compat_sys_select
 143	common	flock				sys_flock
 144	common	msync				sys_msync
-145	common	readv				sys_readv			compat_sys_readv
-146	common	writev				sys_writev			compat_sys_writev
+145	common	readv				sys_readv
+146	common	writev				sys_writev
 147	common	getsid				sys_getsid
 148	common	fdatasync			sys_fdatasync
 149	nospu	_sysctl				sys_ni_syscall
diff --git a/arch/s390/kernel/syscalls/syscall.tbl b/arch/s390/kernel/syscalls/syscall.tbl
index 10456bc936fb09..6101cf2e004cb4 100644
--- a/arch/s390/kernel/syscalls/syscall.tbl
+++ b/arch/s390/kernel/syscalls/syscall.tbl
@@ -134,8 +134,8 @@
 142  64		select			sys_select			-
 143  common	flock			sys_flock			sys_flock
 144  common	msync			sys_msync			sys_msync
-145  common	readv			sys_readv			compat_sys_readv
-146  common	writev			sys_writev			compat_sys_writev
+145  common	readv			sys_readv			sys_readv
+146  common	writev			sys_writev			sys_writev
 147  common	getsid			sys_getsid			sys_getsid
 148  common	fdatasync		sys_fdatasync			sys_fdatasync
 149  common	_sysctl			-				-
diff --git a/arch/sparc/kernel/syscalls/syscall.tbl b/arch/sparc/kernel/syscalls/syscall.tbl
index 4af114e84f2022..a87ddb282ab16f 100644
--- a/arch/sparc/kernel/syscalls/syscall.tbl
+++ b/arch/sparc/kernel/syscalls/syscall.tbl
@@ -149,8 +149,8 @@
 117	common	getrusage		sys_getrusage			compat_sys_getrusage
 118	common	getsockopt		sys_getsockopt			sys_getsockopt
 119	common	getcwd			sys_getcwd
-120	common	readv			sys_readv			compat_sys_readv
-121	common	writev			sys_writev			compat_sys_writev
+120	common	readv			sys_readv
+121	common	writev			sys_writev
 122	common	settimeofday		sys_settimeofday		compat_sys_settimeofday
 123	32	fchown			sys_fchown16
 123	64	fchown			sys_fchown
diff --git a/arch/x86/entry/syscall_x32.c b/arch/x86/entry/syscall_x32.c
index 1583831f61a9df..aa321444a41f63 100644
--- a/arch/x86/entry/syscall_x32.c
+++ b/arch/x86/entry/syscall_x32.c
@@ -12,6 +12,8 @@
  * Reuse the 64-bit entry points for the x32 versions that occupy different
  * slots in the syscall table.
  */
+#define __x32_sys_readv		__x64_sys_readv
+#define __x32_sys_writev	__x64_sys_writev
 #define __x32_sys_getsockopt	__x64_sys_getsockopt
 #define __x32_sys_setsockopt	__x64_sys_setsockopt
 
diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 9d11028736661b..54ab4beb517f25 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -156,8 +156,8 @@
 142	i386	_newselect		sys_select			compat_sys_select
 143	i386	flock			sys_flock
 144	i386	msync			sys_msync
-145	i386	readv			sys_readv			compat_sys_readv
-146	i386	writev			sys_writev			compat_sys_writev
+145	i386	readv			sys_readv
+146	i386	writev			sys_writev
 147	i386	getsid			sys_getsid
 148	i386	fdatasync		sys_fdatasync
 149	i386	_sysctl			sys_ni_syscall
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index f30d6ae9a6883c..b1e59957c5c51c 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -371,8 +371,8 @@
 512	x32	rt_sigaction		compat_sys_rt_sigaction
 513	x32	rt_sigreturn		compat_sys_x32_rt_sigreturn
 514	x32	ioctl			compat_sys_ioctl
-515	x32	readv			compat_sys_readv
-516	x32	writev			compat_sys_writev
+515	x32	readv			sys_readv
+516	x32	writev			sys_writev
 517	x32	recvfrom		compat_sys_recvfrom
 518	x32	sendmsg			compat_sys_sendmsg
 519	x32	recvmsg			compat_sys_recvmsg
diff --git a/fs/read_write.c b/fs/read_write.c
index eab427b7cc0a3f..6c13f744c34a38 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1074,13 +1074,6 @@ SYSCALL_DEFINE6(pwritev2, unsigned long, fd, const struct iovec __user *, vec,
  * in_compat_syscall().
  */
 #ifdef CONFIG_COMPAT
-COMPAT_SYSCALL_DEFINE3(readv, compat_ulong_t, fd,
-		const struct iovec __user *, vec,
-		compat_ulong_t, vlen)
-{
-	return do_readv(fd, vec, vlen, 0);
-}
-
 #ifdef __ARCH_WANT_COMPAT_SYS_PREADV64
 COMPAT_SYSCALL_DEFINE4(preadv64, unsigned long, fd,
 		const struct iovec __user *, vec,
@@ -1122,13 +1115,6 @@ COMPAT_SYSCALL_DEFINE6(preadv2, compat_ulong_t, fd,
 	return do_preadv(fd, vec, vlen, pos, flags);
 }
 
-COMPAT_SYSCALL_DEFINE3(writev, compat_ulong_t, fd,
-		const struct iovec __user *, vec,
-		compat_ulong_t, vlen)
-{
-	return do_writev(fd, vec, vlen, 0);
-}
-
 #ifdef __ARCH_WANT_COMPAT_SYS_PWRITEV64
 COMPAT_SYSCALL_DEFINE4(pwritev64, unsigned long, fd,
 		const struct iovec __user *, vec,
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 306ea7e1172d8d..0f1620988267e6 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -545,10 +545,6 @@ asmlinkage long compat_sys_getdents(unsigned int fd,
 
 /* fs/read_write.c */
 asmlinkage long compat_sys_lseek(unsigned int, compat_off_t, unsigned int);
-asmlinkage ssize_t compat_sys_readv(compat_ulong_t fd,
-		const struct iovec __user *vec, compat_ulong_t vlen);
-asmlinkage ssize_t compat_sys_writev(compat_ulong_t fd,
-		const struct iovec __user *vec, compat_ulong_t vlen);
 /* No generic prototype for pread64 and pwrite64 */
 asmlinkage ssize_t compat_sys_preadv(compat_ulong_t fd,
 		const struct iovec __user *vec,
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 995b36c2ea7d8a..211c9eacbda6eb 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -207,9 +207,9 @@ __SYSCALL(__NR_read, sys_read)
 #define __NR_write 64
 __SYSCALL(__NR_write, sys_write)
 #define __NR_readv 65
-__SC_COMP(__NR_readv, sys_readv, compat_sys_readv)
+__SC_COMP(__NR_readv, sys_readv, sys_readv)
 #define __NR_writev 66
-__SC_COMP(__NR_writev, sys_writev, compat_sys_writev)
+__SC_COMP(__NR_writev, sys_writev, sys_writev)
 #define __NR_pread64 67
 __SC_COMP(__NR_pread64, sys_pread64, compat_sys_pread64)
 #define __NR_pwrite64 68
diff --git a/tools/include/uapi/asm-generic/unistd.h b/tools/include/uapi/asm-generic/unistd.h
index 995b36c2ea7d8a..211c9eacbda6eb 100644
--- a/tools/include/uapi/asm-generic/unistd.h
+++ b/tools/include/uapi/asm-generic/unistd.h
@@ -207,9 +207,9 @@ __SYSCALL(__NR_read, sys_read)
 #define __NR_write 64
 __SYSCALL(__NR_write, sys_write)
 #define __NR_readv 65
-__SC_COMP(__NR_readv, sys_readv, compat_sys_readv)
+__SC_COMP(__NR_readv, sys_readv, sys_readv)
 #define __NR_writev 66
-__SC_COMP(__NR_writev, sys_writev, compat_sys_writev)
+__SC_COMP(__NR_writev, sys_writev, sys_writev)
 #define __NR_pread64 67
 __SC_COMP(__NR_pread64, sys_pread64, compat_sys_pread64)
 #define __NR_pwrite64 68
diff --git a/tools/perf/arch/powerpc/entry/syscalls/syscall.tbl b/tools/perf/arch/powerpc/entry/syscalls/syscall.tbl
index 3ca6fe057a0b1f..46be68029587f9 100644
--- a/tools/perf/arch/powerpc/entry/syscalls/syscall.tbl
+++ b/tools/perf/arch/powerpc/entry/syscalls/syscall.tbl
@@ -189,8 +189,8 @@
 142	common	_newselect			sys_select			compat_sys_select
 143	common	flock				sys_flock
 144	common	msync				sys_msync
-145	common	readv				sys_readv			compat_sys_readv
-146	common	writev				sys_writev			compat_sys_writev
+145	common	readv				sys_readv
+146	common	writev				sys_writev
 147	common	getsid				sys_getsid
 148	common	fdatasync			sys_fdatasync
 149	nospu	_sysctl				sys_ni_syscall
diff --git a/tools/perf/arch/s390/entry/syscalls/syscall.tbl b/tools/perf/arch/s390/entry/syscalls/syscall.tbl
index 6a0bbea225db0d..fb5e61ce9d5838 100644
--- a/tools/perf/arch/s390/entry/syscalls/syscall.tbl
+++ b/tools/perf/arch/s390/entry/syscalls/syscall.tbl
@@ -134,8 +134,8 @@
 142  64		select			sys_select			-
 143  common	flock			sys_flock			sys_flock
 144  common	msync			sys_msync			compat_sys_msync
-145  common	readv			sys_readv			compat_sys_readv
-146  common	writev			sys_writev			compat_sys_writev
+145  common	readv			sys_readv
+146  common	writev			sys_writev
 147  common	getsid			sys_getsid			sys_getsid
 148  common	fdatasync		sys_fdatasync			sys_fdatasync
 149  common	_sysctl			-				-
diff --git a/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl b/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl
index f30d6ae9a6883c..b1e59957c5c51c 100644
--- a/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl
@@ -371,8 +371,8 @@
 512	x32	rt_sigaction		compat_sys_rt_sigaction
 513	x32	rt_sigreturn		compat_sys_x32_rt_sigreturn
 514	x32	ioctl			compat_sys_ioctl
-515	x32	readv			compat_sys_readv
-516	x32	writev			compat_sys_writev
+515	x32	readv			sys_readv
+516	x32	writev			sys_writev
 517	x32	recvfrom		compat_sys_recvfrom
 518	x32	sendmsg			compat_sys_sendmsg
 519	x32	recvmsg			compat_sys_recvmsg
-- 
2.28.0

