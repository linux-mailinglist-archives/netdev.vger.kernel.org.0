Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80FF622342C
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 08:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgGQGYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 02:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbgGQGYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 02:24:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B5EC061755;
        Thu, 16 Jul 2020 23:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=VxyQD+hRQLQr4UhdB5aW45Kx+pCOC8uUSj3q2fzaJeo=; b=kuLOak4LimTxHkua24j0bXUJDB
        aupbdH01Cd+p3yeUiP4wPe4e2tI60umZ1RqNsAXS0Yqs6sE+5Z93ZJ22Wlm9k/GVDzO1XWklnaNTs
        fhzGZpl1jAYWvgzVqo8CZbTXRXIYMQyYuA7OC4MStaVdtPF15ztFgdPijNSi4Fzd+Ic211S7X8S5G
        D7szhFcFC2FgHYRyhkCQYXrSwGn432EckjZYIxk5iN44Bp9GEvktSSzvSrUSibHyhxbTqqh/GE39E
        BxUK6VK6HTha1JRSeEMkANJ5fVU2BUKx1qifozT+dnmpeF6pMhjBjhOL7RDJ5vefZISGMspeIZaSA
        /SAEjDmQ==;
Received: from [2001:4bb8:105:4a81:3772:912d:640:e6c6] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jwJms-00052U-8q; Fri, 17 Jul 2020 06:24:04 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Chas Williams <3chas3@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-sctp@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-wpan@vger.kernel.org, mptcp@lists.01.org
Subject: [PATCH 06/22] net: remove compat_sys_{get,set}sockopt
Date:   Fri, 17 Jul 2020 08:23:15 +0200
Message-Id: <20200717062331.691152-7-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200717062331.691152-1-hch@lst.de>
References: <20200717062331.691152-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the ->compat_{get,set}sockopt proto_ops methods are gone
there is no good reason left to keep the compat syscalls separate.

This fixes the odd use of unsigned int for the compat_setsockopt
optlen and the missing sock_use_custom_sol_socket.

It would also easily allow running the eBPF hooks for the compat
syscalls, but such a large change in behavior does not belong into
a consolidation patch like this one.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/arm64/include/asm/unistd32.h             |  4 +-
 arch/mips/kernel/syscalls/syscall_n32.tbl     |  4 +-
 arch/mips/kernel/syscalls/syscall_o32.tbl     |  4 +-
 arch/parisc/kernel/syscalls/syscall.tbl       |  4 +-
 arch/powerpc/kernel/syscalls/syscall.tbl      |  4 +-
 arch/s390/kernel/syscalls/syscall.tbl         |  4 +-
 arch/sparc/kernel/sys32.S                     | 12 +--
 arch/sparc/kernel/syscalls/syscall.tbl        |  4 +-
 arch/x86/entry/syscall_x32.c                  |  7 ++
 arch/x86/entry/syscalls/syscall_32.tbl        |  4 +-
 arch/x86/entry/syscalls/syscall_64.tbl        |  4 +-
 include/linux/compat.h                        |  4 -
 include/linux/syscalls.h                      |  4 +
 include/uapi/asm-generic/unistd.h             |  4 +-
 net/compat.c                                  | 79 +------------------
 net/socket.c                                  | 25 +++---
 tools/include/uapi/asm-generic/unistd.h       |  4 +-
 .../arch/powerpc/entry/syscalls/syscall.tbl   |  4 +-
 .../perf/arch/s390/entry/syscalls/syscall.tbl |  4 +-
 .../arch/x86/entry/syscalls/syscall_64.tbl    |  4 +-
 20 files changed, 62 insertions(+), 125 deletions(-)

diff --git a/arch/arm64/include/asm/unistd32.h b/arch/arm64/include/asm/unistd32.h
index 6d95d0c8bf2f47..166e369031108a 100644
--- a/arch/arm64/include/asm/unistd32.h
+++ b/arch/arm64/include/asm/unistd32.h
@@ -599,9 +599,9 @@ __SYSCALL(__NR_recvfrom, compat_sys_recvfrom)
 #define __NR_shutdown 293
 __SYSCALL(__NR_shutdown, sys_shutdown)
 #define __NR_setsockopt 294
-__SYSCALL(__NR_setsockopt, compat_sys_setsockopt)
+__SYSCALL(__NR_setsockopt, sys_setsockopt)
 #define __NR_getsockopt 295
-__SYSCALL(__NR_getsockopt, compat_sys_getsockopt)
+__SYSCALL(__NR_getsockopt, sys_getsockopt)
 #define __NR_sendmsg 296
 __SYSCALL(__NR_sendmsg, compat_sys_sendmsg)
 #define __NR_recvmsg 297
diff --git a/arch/mips/kernel/syscalls/syscall_n32.tbl b/arch/mips/kernel/syscalls/syscall_n32.tbl
index f777141f52568f..8488b0d0a99e2a 100644
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -60,8 +60,8 @@
 50	n32	getsockname			sys_getsockname
 51	n32	getpeername			sys_getpeername
 52	n32	socketpair			sys_socketpair
-53	n32	setsockopt			compat_sys_setsockopt
-54	n32	getsockopt			compat_sys_getsockopt
+53	n32	setsockopt			sys_setsockopt
+54	n32	getsockopt			sys_getsockopt
 55	n32	clone				__sys_clone
 56	n32	fork				__sys_fork
 57	n32	execve				compat_sys_execve
diff --git a/arch/mips/kernel/syscalls/syscall_o32.tbl b/arch/mips/kernel/syscalls/syscall_o32.tbl
index 13280625d312e9..b20522f813f9d7 100644
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -184,7 +184,7 @@
 170	o32	connect				sys_connect
 171	o32	getpeername			sys_getpeername
 172	o32	getsockname			sys_getsockname
-173	o32	getsockopt			sys_getsockopt			compat_sys_getsockopt
+173	o32	getsockopt			sys_getsockopt			sys_getsockopt
 174	o32	listen				sys_listen
 175	o32	recv				sys_recv			compat_sys_recv
 176	o32	recvfrom			sys_recvfrom			compat_sys_recvfrom
@@ -192,7 +192,7 @@
 178	o32	send				sys_send
 179	o32	sendmsg				sys_sendmsg			compat_sys_sendmsg
 180	o32	sendto				sys_sendto
-181	o32	setsockopt			sys_setsockopt			compat_sys_setsockopt
+181	o32	setsockopt			sys_setsockopt			sys_setsockopt
 182	o32	shutdown			sys_shutdown
 183	o32	socket				sys_socket
 184	o32	socketpair			sys_socketpair
diff --git a/arch/parisc/kernel/syscalls/syscall.tbl b/arch/parisc/kernel/syscalls/syscall.tbl
index 5a758fa6ec5242..3494e4fa1a1768 100644
--- a/arch/parisc/kernel/syscalls/syscall.tbl
+++ b/arch/parisc/kernel/syscalls/syscall.tbl
@@ -198,8 +198,8 @@
 178	common	rt_sigqueueinfo		sys_rt_sigqueueinfo		compat_sys_rt_sigqueueinfo
 179	common	rt_sigsuspend		sys_rt_sigsuspend		compat_sys_rt_sigsuspend
 180	common	chown			sys_chown
-181	common	setsockopt		sys_setsockopt			compat_sys_setsockopt
-182	common	getsockopt		sys_getsockopt			compat_sys_getsockopt
+181	common	setsockopt		sys_setsockopt			sys_setsockopt
+182	common	getsockopt		sys_getsockopt			sys_getsockopt
 183	common	sendmsg			sys_sendmsg			compat_sys_sendmsg
 184	common	recvmsg			sys_recvmsg			compat_sys_recvmsg
 185	common	semop			sys_semop
diff --git a/arch/powerpc/kernel/syscalls/syscall.tbl b/arch/powerpc/kernel/syscalls/syscall.tbl
index f833a319082247..94eb5b27ef65e3 100644
--- a/arch/powerpc/kernel/syscalls/syscall.tbl
+++ b/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -433,8 +433,8 @@
 336	common	recv				sys_recv			compat_sys_recv
 337	common	recvfrom			sys_recvfrom			compat_sys_recvfrom
 338	common	shutdown			sys_shutdown
-339	common	setsockopt			sys_setsockopt			compat_sys_setsockopt
-340	common	getsockopt			sys_getsockopt			compat_sys_getsockopt
+339	common	setsockopt			sys_setsockopt			sys_setsockopt
+340	common	getsockopt			sys_getsockopt			sys_getsockopt
 341	common	sendmsg				sys_sendmsg			compat_sys_sendmsg
 342	common	recvmsg				sys_recvmsg			compat_sys_recvmsg
 343	32	recvmmsg			sys_recvmmsg_time32		compat_sys_recvmmsg_time32
diff --git a/arch/s390/kernel/syscalls/syscall.tbl b/arch/s390/kernel/syscalls/syscall.tbl
index bfdcb763395735..0d63c71fc54440 100644
--- a/arch/s390/kernel/syscalls/syscall.tbl
+++ b/arch/s390/kernel/syscalls/syscall.tbl
@@ -372,8 +372,8 @@
 362  common	connect			sys_connect			sys_connect
 363  common	listen			sys_listen			sys_listen
 364  common	accept4			sys_accept4			sys_accept4
-365  common	getsockopt		sys_getsockopt			compat_sys_getsockopt
-366  common	setsockopt		sys_setsockopt			compat_sys_setsockopt
+365  common	getsockopt		sys_getsockopt			sys_getsockopt
+366  common	setsockopt		sys_setsockopt			sys_setsockopt
 367  common	getsockname		sys_getsockname			sys_getsockname
 368  common	getpeername		sys_getpeername			sys_getpeername
 369  common	sendto			sys_sendto			sys_sendto
diff --git a/arch/sparc/kernel/sys32.S b/arch/sparc/kernel/sys32.S
index 489ffab918a835..a45f0f31fe51ab 100644
--- a/arch/sparc/kernel/sys32.S
+++ b/arch/sparc/kernel/sys32.S
@@ -157,22 +157,22 @@ do_sys_shutdown: /* sys_shutdown(int, int) */
 	nop
 	nop
 	nop
-do_sys_setsockopt: /* compat_sys_setsockopt(int, int, int, char *, int) */
+do_sys_setsockopt: /* sys_setsockopt(int, int, int, char *, int) */
 47:	ldswa		[%o1 + 0x0] %asi, %o0
-	sethi		%hi(compat_sys_setsockopt), %g1
+	sethi		%hi(sys_setsockopt), %g1
 48:	ldswa		[%o1 + 0x8] %asi, %o2
 49:	lduwa		[%o1 + 0xc] %asi, %o3
 50:	ldswa		[%o1 + 0x10] %asi, %o4
-	jmpl		%g1 + %lo(compat_sys_setsockopt), %g0
+	jmpl		%g1 + %lo(sys_setsockopt), %g0
 51:	 ldswa		[%o1 + 0x4] %asi, %o1
 	nop
-do_sys_getsockopt: /* compat_sys_getsockopt(int, int, int, u32, u32) */
+do_sys_getsockopt: /* sys_getsockopt(int, int, int, u32, u32) */
 52:	ldswa		[%o1 + 0x0] %asi, %o0
-	sethi		%hi(compat_sys_getsockopt), %g1
+	sethi		%hi(sys_getsockopt), %g1
 53:	ldswa		[%o1 + 0x8] %asi, %o2
 54:	lduwa		[%o1 + 0xc] %asi, %o3
 55:	lduwa		[%o1 + 0x10] %asi, %o4
-	jmpl		%g1 + %lo(compat_sys_getsockopt), %g0
+	jmpl		%g1 + %lo(sys_getsockopt), %g0
 56:	 ldswa		[%o1 + 0x4] %asi, %o1
 	nop
 do_sys_sendmsg: /* compat_sys_sendmsg(int, struct compat_msghdr *, unsigned int) */
diff --git a/arch/sparc/kernel/syscalls/syscall.tbl b/arch/sparc/kernel/syscalls/syscall.tbl
index 8004a276cb74be..c59b37965add7e 100644
--- a/arch/sparc/kernel/syscalls/syscall.tbl
+++ b/arch/sparc/kernel/syscalls/syscall.tbl
@@ -147,7 +147,7 @@
 115	32	getgroups32		sys_getgroups
 116	common	gettimeofday		sys_gettimeofday		compat_sys_gettimeofday
 117	common	getrusage		sys_getrusage			compat_sys_getrusage
-118	common	getsockopt		sys_getsockopt			compat_sys_getsockopt
+118	common	getsockopt		sys_getsockopt			sys_getsockopt
 119	common	getcwd			sys_getcwd
 120	common	readv			sys_readv			compat_sys_readv
 121	common	writev			sys_writev			compat_sys_writev
@@ -425,7 +425,7 @@
 352	common	userfaultfd		sys_userfaultfd
 353	common	bind			sys_bind
 354	common	listen			sys_listen
-355	common	setsockopt		sys_setsockopt			compat_sys_setsockopt
+355	common	setsockopt		sys_setsockopt			sys_setsockopt
 356	common	mlock2			sys_mlock2
 357	common	copy_file_range		sys_copy_file_range
 358	common	preadv2			sys_preadv2			compat_sys_preadv2
diff --git a/arch/x86/entry/syscall_x32.c b/arch/x86/entry/syscall_x32.c
index 3d8d70d3896c87..1583831f61a9df 100644
--- a/arch/x86/entry/syscall_x32.c
+++ b/arch/x86/entry/syscall_x32.c
@@ -8,6 +8,13 @@
 #include <asm/unistd.h>
 #include <asm/syscall.h>
 
+/*
+ * Reuse the 64-bit entry points for the x32 versions that occupy different
+ * slots in the syscall table.
+ */
+#define __x32_sys_getsockopt	__x64_sys_getsockopt
+#define __x32_sys_setsockopt	__x64_sys_setsockopt
+
 #define __SYSCALL_64(nr, sym)
 
 #define __SYSCALL_X32(nr, sym) extern long __x32_##sym(const struct pt_regs *);
diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index d8f8a1a69ed11f..43742a69dba13a 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -376,8 +376,8 @@
 362	i386	connect			sys_connect
 363	i386	listen			sys_listen
 364	i386	accept4			sys_accept4
-365	i386	getsockopt		sys_getsockopt			compat_sys_getsockopt
-366	i386	setsockopt		sys_setsockopt			compat_sys_setsockopt
+365	i386	getsockopt		sys_getsockopt			sys_getsockopt
+366	i386	setsockopt		sys_setsockopt			sys_setsockopt
 367	i386	getsockname		sys_getsockname
 368	i386	getpeername		sys_getpeername
 369	i386	sendto			sys_sendto
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 78847b32e1370f..e008d638e6417f 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -396,8 +396,8 @@
 538	x32	sendmmsg		compat_sys_sendmmsg
 539	x32	process_vm_readv	compat_sys_process_vm_readv
 540	x32	process_vm_writev	compat_sys_process_vm_writev
-541	x32	setsockopt		compat_sys_setsockopt
-542	x32	getsockopt		compat_sys_getsockopt
+541	x32	setsockopt		sys_setsockopt
+542	x32	getsockopt		sys_getsockopt
 543	x32	io_setup		compat_sys_io_setup
 544	x32	io_submit		compat_sys_io_submit
 545	x32	execveat		compat_sys_execveat
diff --git a/include/linux/compat.h b/include/linux/compat.h
index e90100c0de72e4..c4255d8a4a8aea 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -737,10 +737,6 @@ asmlinkage long compat_sys_shmat(int shmid, compat_uptr_t shmaddr, int shmflg);
 asmlinkage long compat_sys_recvfrom(int fd, void __user *buf, compat_size_t len,
 			    unsigned flags, struct sockaddr __user *addr,
 			    int __user *addrlen);
-asmlinkage long compat_sys_setsockopt(int fd, int level, int optname,
-				      char __user *optval, unsigned int optlen);
-asmlinkage long compat_sys_getsockopt(int fd, int level, int optname,
-				      char __user *optval, int __user *optlen);
 asmlinkage long compat_sys_sendmsg(int fd, struct compat_msghdr __user *msg,
 				   unsigned flags);
 asmlinkage long compat_sys_recvmsg(int fd, struct compat_msghdr __user *msg,
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index b951a87da9877c..aa46825c6f9d78 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1424,4 +1424,8 @@ long compat_ksys_semtimedop(int semid, struct sembuf __user *tsems,
 			    unsigned int nsops,
 			    const struct old_timespec32 __user *timeout);
 
+int __sys_getsockopt(int fd, int level, int optname, char __user *optval,
+		int __user *optlen);
+int __sys_setsockopt(int fd, int level, int optname, char __user *optval,
+		int optlen);
 #endif
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index f4a01305d9a65c..c8c189a5f0a6bd 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -606,9 +606,9 @@ __SYSCALL(__NR_sendto, sys_sendto)
 #define __NR_recvfrom 207
 __SC_COMP(__NR_recvfrom, sys_recvfrom, compat_sys_recvfrom)
 #define __NR_setsockopt 208
-__SC_COMP(__NR_setsockopt, sys_setsockopt, compat_sys_setsockopt)
+__SC_COMP(__NR_setsockopt, sys_setsockopt, sys_setsockopt)
 #define __NR_getsockopt 209
-__SC_COMP(__NR_getsockopt, sys_getsockopt, compat_sys_getsockopt)
+__SC_COMP(__NR_getsockopt, sys_getsockopt, sys_getsockopt)
 #define __NR_shutdown 210
 __SYSCALL(__NR_shutdown, sys_shutdown)
 #define __NR_sendmsg 211
diff --git a/net/compat.c b/net/compat.c
index 3e6c2c5ff2609c..091875bd621048 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -335,77 +335,6 @@ void scm_detach_fds_compat(struct msghdr *kmsg, struct scm_cookie *scm)
 	__scm_destroy(scm);
 }
 
-static int __compat_sys_setsockopt(int fd, int level, int optname,
-				   char __user *optval, unsigned int optlen)
-{
-	int err;
-	struct socket *sock;
-
-	if (optlen > INT_MAX)
-		return -EINVAL;
-
-	sock = sockfd_lookup(fd, &err);
-	if (sock) {
-		err = security_socket_setsockopt(sock, level, optname);
-		if (err) {
-			sockfd_put(sock);
-			return err;
-		}
-
-		if (level == SOL_SOCKET)
-			err = sock_setsockopt(sock, level,
-					optname, optval, optlen);
-		else if (sock->ops->compat_setsockopt)
-			err = sock->ops->compat_setsockopt(sock, level,
-					optname, optval, optlen);
-		else
-			err = sock->ops->setsockopt(sock, level,
-					optname, optval, optlen);
-		sockfd_put(sock);
-	}
-	return err;
-}
-
-COMPAT_SYSCALL_DEFINE5(setsockopt, int, fd, int, level, int, optname,
-		       char __user *, optval, unsigned int, optlen)
-{
-	return __compat_sys_setsockopt(fd, level, optname, optval, optlen);
-}
-
-static int __compat_sys_getsockopt(int fd, int level, int optname,
-				   char __user *optval,
-				   int __user *optlen)
-{
-	int err;
-	struct socket *sock = sockfd_lookup(fd, &err);
-
-	if (sock) {
-		err = security_socket_getsockopt(sock, level, optname);
-		if (err) {
-			sockfd_put(sock);
-			return err;
-		}
-
-		if (level == SOL_SOCKET)
-			err = sock_getsockopt(sock, level,
-					optname, optval, optlen);
-		else if (sock->ops->compat_getsockopt)
-			err = sock->ops->compat_getsockopt(sock, level,
-					optname, optval, optlen);
-		else
-			err = sock->ops->getsockopt(sock, level,
-					optname, optval, optlen);
-		sockfd_put(sock);
-	}
-	return err;
-}
-
-COMPAT_SYSCALL_DEFINE5(getsockopt, int, fd, int, level, int, optname,
-		       char __user *, optval, int __user *, optlen)
-{
-	return __compat_sys_getsockopt(fd, level, optname, optval, optlen);
-}
-
 /* Argument list sizes for compat_sys_socketcall */
 #define AL(x) ((x) * sizeof(u32))
 static unsigned char nas[21] = {
@@ -565,13 +494,11 @@ COMPAT_SYSCALL_DEFINE2(socketcall, int, call, u32 __user *, args)
 		ret = __sys_shutdown(a0, a1);
 		break;
 	case SYS_SETSOCKOPT:
-		ret = __compat_sys_setsockopt(a0, a1, a[2],
-					      compat_ptr(a[3]), a[4]);
+		ret = __sys_setsockopt(a0, a1, a[2], compat_ptr(a[3]), a[4]);
 		break;
 	case SYS_GETSOCKOPT:
-		ret = __compat_sys_getsockopt(a0, a1, a[2],
-					      compat_ptr(a[3]),
-					      compat_ptr(a[4]));
+		ret = __sys_getsockopt(a0, a1, a[2], compat_ptr(a[3]),
+				       compat_ptr(a[4]));
 		break;
 	case SYS_SENDMSG:
 		ret = __compat_sys_sendmsg(a0, compat_ptr(a1), a[2]);
diff --git a/net/socket.c b/net/socket.c
index b79376b17b45b7..dec345982abbb6 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2094,9 +2094,8 @@ static bool sock_use_custom_sol_socket(const struct socket *sock)
  *	Set a socket option. Because we don't know the option lengths we have
  *	to pass the user mode parameter for the protocols to sort out.
  */
-
-static int __sys_setsockopt(int fd, int level, int optname,
-			    char __user *optval, int optlen)
+int __sys_setsockopt(int fd, int level, int optname, char __user *optval,
+		int optlen)
 {
 	mm_segment_t oldfs = get_fs();
 	char *kernel_optval = NULL;
@@ -2114,8 +2113,10 @@ static int __sys_setsockopt(int fd, int level, int optname,
 	if (err)
 		goto out_put;
 
-	err = BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock->sk, &level, &optname,
-					     optval, &optlen, &kernel_optval);
+	if (!in_compat_syscall())
+		err = BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock->sk, &level, &optname,
+						     optval, &optlen,
+						     &kernel_optval);
 	if (err < 0)
 		goto out_put;
 	if (err > 0) {
@@ -2154,9 +2155,8 @@ SYSCALL_DEFINE5(setsockopt, int, fd, int, level, int, optname,
  *	Get a socket option. Because we don't know the option lengths we have
  *	to pass a user mode parameter for the protocols to sort out.
  */
-
-static int __sys_getsockopt(int fd, int level, int optname,
-			    char __user *optval, int __user *optlen)
+int __sys_getsockopt(int fd, int level, int optname, char __user *optval,
+		int __user *optlen)
 {
 	int err, fput_needed;
 	struct socket *sock;
@@ -2170,7 +2170,8 @@ static int __sys_getsockopt(int fd, int level, int optname,
 	if (err)
 		goto out_put;
 
-	max_optlen = BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN(optlen);
+	if (!in_compat_syscall())
+		max_optlen = BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN(optlen);
 
 	if (level == SOL_SOCKET)
 		err = sock_getsockopt(sock, level, optname, optval, optlen);
@@ -2178,8 +2179,10 @@ static int __sys_getsockopt(int fd, int level, int optname,
 		err = sock->ops->getsockopt(sock, level, optname, optval,
 					    optlen);
 
-	err = BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock->sk, level, optname, optval,
-					     optlen, max_optlen, err);
+	if (!in_compat_syscall())
+		err = BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock->sk, level, optname,
+						     optval, optlen, max_optlen,
+						     err);
 out_put:
 	fput_light(sock->file, fput_needed);
 	return err;
diff --git a/tools/include/uapi/asm-generic/unistd.h b/tools/include/uapi/asm-generic/unistd.h
index f4a01305d9a65c..c8c189a5f0a6bd 100644
--- a/tools/include/uapi/asm-generic/unistd.h
+++ b/tools/include/uapi/asm-generic/unistd.h
@@ -606,9 +606,9 @@ __SYSCALL(__NR_sendto, sys_sendto)
 #define __NR_recvfrom 207
 __SC_COMP(__NR_recvfrom, sys_recvfrom, compat_sys_recvfrom)
 #define __NR_setsockopt 208
-__SC_COMP(__NR_setsockopt, sys_setsockopt, compat_sys_setsockopt)
+__SC_COMP(__NR_setsockopt, sys_setsockopt, sys_setsockopt)
 #define __NR_getsockopt 209
-__SC_COMP(__NR_getsockopt, sys_getsockopt, compat_sys_getsockopt)
+__SC_COMP(__NR_getsockopt, sys_getsockopt, sys_getsockopt)
 #define __NR_shutdown 210
 __SYSCALL(__NR_shutdown, sys_shutdown)
 #define __NR_sendmsg 211
diff --git a/tools/perf/arch/powerpc/entry/syscalls/syscall.tbl b/tools/perf/arch/powerpc/entry/syscalls/syscall.tbl
index 35b61bfc1b1ae9..b190f2eb2611b3 100644
--- a/tools/perf/arch/powerpc/entry/syscalls/syscall.tbl
+++ b/tools/perf/arch/powerpc/entry/syscalls/syscall.tbl
@@ -427,8 +427,8 @@
 336	common	recv				sys_recv			compat_sys_recv
 337	common	recvfrom			sys_recvfrom			compat_sys_recvfrom
 338	common	shutdown			sys_shutdown
-339	common	setsockopt			sys_setsockopt			compat_sys_setsockopt
-340	common	getsockopt			sys_getsockopt			compat_sys_getsockopt
+339	common	setsockopt			sys_setsockopt			sys_setsockopt
+340	common	getsockopt			sys_getsockopt			sys_getsockopt
 341	common	sendmsg				sys_sendmsg			compat_sys_sendmsg
 342	common	recvmsg				sys_recvmsg			compat_sys_recvmsg
 343	32	recvmmsg			sys_recvmmsg_time32		compat_sys_recvmmsg_time32
diff --git a/tools/perf/arch/s390/entry/syscalls/syscall.tbl b/tools/perf/arch/s390/entry/syscalls/syscall.tbl
index b38d48464368dc..56ae24b6e4be6e 100644
--- a/tools/perf/arch/s390/entry/syscalls/syscall.tbl
+++ b/tools/perf/arch/s390/entry/syscalls/syscall.tbl
@@ -372,8 +372,8 @@
 362  common	connect			sys_connect			compat_sys_connect
 363  common	listen			sys_listen			sys_listen
 364  common	accept4			sys_accept4			compat_sys_accept4
-365  common	getsockopt		sys_getsockopt			compat_sys_getsockopt
-366  common	setsockopt		sys_setsockopt			compat_sys_setsockopt
+365  common	getsockopt		sys_getsockopt			sys_getsockopt
+366  common	setsockopt		sys_setsockopt			sys_setsockopt
 367  common	getsockname		sys_getsockname			compat_sys_getsockname
 368  common	getpeername		sys_getpeername			compat_sys_getpeername
 369  common	sendto			sys_sendto			compat_sys_sendto
diff --git a/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl b/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl
index 78847b32e1370f..e008d638e6417f 100644
--- a/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl
@@ -396,8 +396,8 @@
 538	x32	sendmmsg		compat_sys_sendmmsg
 539	x32	process_vm_readv	compat_sys_process_vm_readv
 540	x32	process_vm_writev	compat_sys_process_vm_writev
-541	x32	setsockopt		compat_sys_setsockopt
-542	x32	getsockopt		compat_sys_getsockopt
+541	x32	setsockopt		sys_setsockopt
+542	x32	getsockopt		sys_getsockopt
 543	x32	io_setup		compat_sys_io_setup
 544	x32	io_submit		compat_sys_io_submit
 545	x32	execveat		compat_sys_execveat
-- 
2.27.0

