Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46CD23D25BA
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 16:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbhGVNss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 09:48:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232385AbhGVNsp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 09:48:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52B2A61278;
        Thu, 22 Jul 2021 14:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626964160;
        bh=O54DZAW58lGHxHXPsPQBp8/QBUnzIS5LKcItSp7Excs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AqkNdsRXpOqG/nN4/8xyLZsKr4Uw+8fOJqKl6OULqYh8tt8yWoh5vjdda93hCN1ta
         8SdPDfMAieTBdm6MpaoEJh+OmyeKzL2ACw+MjHQz9CwuDEfxmoYhl2fNBt7ytwqMNP
         AHj+KUQrJP8fcalkk25WaesComooQK5wtT5KN8gd7xthrDOWSEYb4syYeRj6EZRSdc
         QKAFn1lhPn/bM2uJBbS9gzyuhbWMlOLNey1eVXwK38UX9uv2fUO4wOQVxZKIdNPNZw
         Aa5WVRWtkD9n4uBmSU/npRqTTPQC0+lms3p/Lx61BGOcu8Ppep+vJyNgc06LG1jat5
         whRCzroswV8/A==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Christoph Hellwig <hch@lst.de>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Marco Elver <elver@google.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: [PATCH net-next v6 1/6] compat: make linux/compat.h available everywhere
Date:   Thu, 22 Jul 2021 16:28:58 +0200
Message-Id: <20210722142903.213084-2-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210722142903.213084-1-arnd@kernel.org>
References: <20210722142903.213084-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Parts of linux/compat.h are under an #ifdef, but we end up
using more of those over time, moving things around bit by
bit.

To get it over with once and for all, make all of this file
uncondititonal now so it can be accessed everywhere. There
are only a few types left that are in asm/compat.h but not
yet in the asm-generic version, so add those in the process.

This requires providing a few more types in asm-generic/compat.h
that were not already there. The only tricky one is
compat_sigset_t, which needs a little help on 32-bit architectures
and for x86.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Changed in v6:
 - split out linux/compat.h changes from multiple patches into
   a separate change
 - Do it all at once
---
 arch/arm64/include/asm/compat.h   | 14 +++-----------
 arch/mips/include/asm/compat.h    | 24 +++++++++++------------
 arch/parisc/include/asm/compat.h  | 14 +++-----------
 arch/powerpc/include/asm/compat.h | 11 -----------
 arch/s390/include/asm/compat.h    | 14 +++-----------
 arch/sparc/include/asm/compat.h   | 14 +++-----------
 arch/x86/include/asm/compat.h     | 14 +++-----------
 arch/x86/include/asm/signal.h     |  1 +
 include/asm-generic/compat.h      | 17 ++++++++++++++++
 include/linux/compat.h            | 32 +++++++++++++++----------------
 10 files changed, 59 insertions(+), 96 deletions(-)

diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
index 23a9fb73c04f..79c1a750e357 100644
--- a/arch/arm64/include/asm/compat.h
+++ b/arch/arm64/include/asm/compat.h
@@ -5,6 +5,9 @@
 #ifndef __ASM_COMPAT_H
 #define __ASM_COMPAT_H
 
+#define compat_mode_t compat_mode_t
+typedef u16		compat_mode_t;
+
 #include <asm-generic/compat.h>
 
 #ifdef CONFIG_COMPAT
@@ -27,13 +30,9 @@ typedef u16		__compat_uid_t;
 typedef u16		__compat_gid_t;
 typedef u16		__compat_uid16_t;
 typedef u16		__compat_gid16_t;
-typedef u32		__compat_uid32_t;
-typedef u32		__compat_gid32_t;
-typedef u16		compat_mode_t;
 typedef u32		compat_dev_t;
 typedef s32		compat_nlink_t;
 typedef u16		compat_ipc_pid_t;
-typedef u32		compat_caddr_t;
 typedef __kernel_fsid_t	compat_fsid_t;
 
 struct compat_stat {
@@ -103,13 +102,6 @@ struct compat_statfs {
 
 #define COMPAT_RLIM_INFINITY		0xffffffff
 
-typedef u32		compat_old_sigset_t;
-
-#define _COMPAT_NSIG		64
-#define _COMPAT_NSIG_BPW	32
-
-typedef u32		compat_sigset_word;
-
 #define COMPAT_OFF_T_MAX	0x7fffffff
 
 #define compat_user_stack_pointer() (user_stack_pointer(task_pt_regs(current)))
diff --git a/arch/mips/include/asm/compat.h b/arch/mips/include/asm/compat.h
index 65975712a22d..53f015a1b0a7 100644
--- a/arch/mips/include/asm/compat.h
+++ b/arch/mips/include/asm/compat.h
@@ -9,20 +9,25 @@
 #include <asm/page.h>
 #include <asm/ptrace.h>
 
+typedef s32		__compat_uid_t;
+typedef s32		__compat_gid_t;
+typedef __compat_uid_t	__compat_uid32_t;
+typedef __compat_gid_t	__compat_gid32_t;
+#define __compat_uid32_t __compat_uid32_t
+#define __compat_gid32_t __compat_gid32_t
+
+#define _COMPAT_NSIG		128		/* Don't ask !$@#% ...	*/
+#define _COMPAT_NSIG_BPW	32
+typedef u32		compat_sigset_word;
+
 #include <asm-generic/compat.h>
 
 #define COMPAT_USER_HZ		100
 #define COMPAT_UTS_MACHINE	"mips\0\0\0"
 
-typedef s32		__compat_uid_t;
-typedef s32		__compat_gid_t;
-typedef __compat_uid_t	__compat_uid32_t;
-typedef __compat_gid_t	__compat_gid32_t;
-typedef u32		compat_mode_t;
 typedef u32		compat_dev_t;
 typedef u32		compat_nlink_t;
 typedef s32		compat_ipc_pid_t;
-typedef s32		compat_caddr_t;
 typedef struct {
 	s32	val[2];
 } compat_fsid_t;
@@ -89,13 +94,6 @@ struct compat_statfs {
 
 #define COMPAT_RLIM_INFINITY	0x7fffffffUL
 
-typedef u32		compat_old_sigset_t;	/* at least 32 bits */
-
-#define _COMPAT_NSIG		128		/* Don't ask !$@#% ...	*/
-#define _COMPAT_NSIG_BPW	32
-
-typedef u32		compat_sigset_word;
-
 #define COMPAT_OFF_T_MAX	0x7fffffff
 
 static inline void __user *arch_compat_alloc_user_space(long len)
diff --git a/arch/parisc/include/asm/compat.h b/arch/parisc/include/asm/compat.h
index 1a609d38f667..b5d90e82b65d 100644
--- a/arch/parisc/include/asm/compat.h
+++ b/arch/parisc/include/asm/compat.h
@@ -8,6 +8,9 @@
 #include <linux/sched.h>
 #include <linux/thread_info.h>
 
+#define compat_mode_t compat_mode_t
+typedef u16	compat_mode_t;
+
 #include <asm-generic/compat.h>
 
 #define COMPAT_USER_HZ 		100
@@ -15,13 +18,9 @@
 
 typedef u32	__compat_uid_t;
 typedef u32	__compat_gid_t;
-typedef u32	__compat_uid32_t;
-typedef u32	__compat_gid32_t;
-typedef u16	compat_mode_t;
 typedef u32	compat_dev_t;
 typedef u16	compat_nlink_t;
 typedef u16	compat_ipc_pid_t;
-typedef u32	compat_caddr_t;
 
 struct compat_stat {
 	compat_dev_t		st_dev;	/* dev_t is 32 bits on parisc */
@@ -96,13 +95,6 @@ struct compat_sigcontext {
 
 #define COMPAT_RLIM_INFINITY 0xffffffff
 
-typedef u32		compat_old_sigset_t;	/* at least 32 bits */
-
-#define _COMPAT_NSIG		64
-#define _COMPAT_NSIG_BPW	32
-
-typedef u32		compat_sigset_word;
-
 #define COMPAT_OFF_T_MAX	0x7fffffff
 
 struct compat_ipc64_perm {
diff --git a/arch/powerpc/include/asm/compat.h b/arch/powerpc/include/asm/compat.h
index 9191fc29e6ed..e33dcf134cdd 100644
--- a/arch/powerpc/include/asm/compat.h
+++ b/arch/powerpc/include/asm/compat.h
@@ -19,13 +19,9 @@
 
 typedef u32		__compat_uid_t;
 typedef u32		__compat_gid_t;
-typedef u32		__compat_uid32_t;
-typedef u32		__compat_gid32_t;
-typedef u32		compat_mode_t;
 typedef u32		compat_dev_t;
 typedef s16		compat_nlink_t;
 typedef u16		compat_ipc_pid_t;
-typedef u32		compat_caddr_t;
 typedef __kernel_fsid_t	compat_fsid_t;
 
 struct compat_stat {
@@ -85,13 +81,6 @@ struct compat_statfs {
 
 #define COMPAT_RLIM_INFINITY		0xffffffff
 
-typedef u32		compat_old_sigset_t;
-
-#define _COMPAT_NSIG		64
-#define _COMPAT_NSIG_BPW	32
-
-typedef u32		compat_sigset_word;
-
 #define COMPAT_OFF_T_MAX	0x7fffffff
 
 static inline void __user *arch_compat_alloc_user_space(long len)
diff --git a/arch/s390/include/asm/compat.h b/arch/s390/include/asm/compat.h
index ea5b9c34b7be..8d49505b4a43 100644
--- a/arch/s390/include/asm/compat.h
+++ b/arch/s390/include/asm/compat.h
@@ -9,6 +9,9 @@
 #include <linux/sched/task_stack.h>
 #include <linux/thread_info.h>
 
+#define compat_mode_t	compat_mode_t
+typedef u16		compat_mode_t;
+
 #include <asm-generic/compat.h>
 
 #define __TYPE_IS_PTR(t) (!__builtin_types_compatible_p( \
@@ -55,13 +58,9 @@
 
 typedef u16		__compat_uid_t;
 typedef u16		__compat_gid_t;
-typedef u32		__compat_uid32_t;
-typedef u32		__compat_gid32_t;
-typedef u16		compat_mode_t;
 typedef u16		compat_dev_t;
 typedef u16		compat_nlink_t;
 typedef u16		compat_ipc_pid_t;
-typedef u32		compat_caddr_t;
 typedef __kernel_fsid_t	compat_fsid_t;
 
 typedef struct {
@@ -155,13 +154,6 @@ struct compat_statfs64 {
 
 #define COMPAT_RLIM_INFINITY		0xffffffff
 
-typedef u32		compat_old_sigset_t;	/* at least 32 bits */
-
-#define _COMPAT_NSIG		64
-#define _COMPAT_NSIG_BPW	32
-
-typedef u32		compat_sigset_word;
-
 #define COMPAT_OFF_T_MAX	0x7fffffff
 
 /*
diff --git a/arch/sparc/include/asm/compat.h b/arch/sparc/include/asm/compat.h
index b85842cda99f..8b63410e830f 100644
--- a/arch/sparc/include/asm/compat.h
+++ b/arch/sparc/include/asm/compat.h
@@ -6,6 +6,9 @@
  */
 #include <linux/types.h>
 
+#define compat_mode_t	compat_mode_t
+typedef u16		compat_mode_t;
+
 #include <asm-generic/compat.h>
 
 #define COMPAT_USER_HZ		100
@@ -13,13 +16,9 @@
 
 typedef u16		__compat_uid_t;
 typedef u16		__compat_gid_t;
-typedef u32		__compat_uid32_t;
-typedef u32		__compat_gid32_t;
-typedef u16		compat_mode_t;
 typedef u16		compat_dev_t;
 typedef s16		compat_nlink_t;
 typedef u16		compat_ipc_pid_t;
-typedef u32		compat_caddr_t;
 typedef __kernel_fsid_t	compat_fsid_t;
 
 struct compat_stat {
@@ -115,13 +114,6 @@ struct compat_statfs {
 
 #define COMPAT_RLIM_INFINITY 0x7fffffff
 
-typedef u32		compat_old_sigset_t;
-
-#define _COMPAT_NSIG		64
-#define _COMPAT_NSIG_BPW	32
-
-typedef u32		compat_sigset_word;
-
 #define COMPAT_OFF_T_MAX	0x7fffffff
 
 #ifdef CONFIG_COMPAT
diff --git a/arch/x86/include/asm/compat.h b/arch/x86/include/asm/compat.h
index be09c7eac89f..4ae01cdb99de 100644
--- a/arch/x86/include/asm/compat.h
+++ b/arch/x86/include/asm/compat.h
@@ -12,6 +12,9 @@
 #include <asm/user32.h>
 #include <asm/unistd.h>
 
+#define compat_mode_t	compat_mode_t
+typedef u16		compat_mode_t;
+
 #include <asm-generic/compat.h>
 
 #define COMPAT_USER_HZ		100
@@ -19,13 +22,9 @@
 
 typedef u16		__compat_uid_t;
 typedef u16		__compat_gid_t;
-typedef u32		__compat_uid32_t;
-typedef u32		__compat_gid32_t;
-typedef u16		compat_mode_t;
 typedef u16		compat_dev_t;
 typedef u16		compat_nlink_t;
 typedef u16		compat_ipc_pid_t;
-typedef u32		compat_caddr_t;
 typedef __kernel_fsid_t	compat_fsid_t;
 
 struct compat_stat {
@@ -92,13 +91,6 @@ struct compat_statfs {
 
 #define COMPAT_RLIM_INFINITY		0xffffffff
 
-typedef u32		compat_old_sigset_t;	/* at least 32 bits */
-
-#define _COMPAT_NSIG		64
-#define _COMPAT_NSIG_BPW	32
-
-typedef u32               compat_sigset_word;
-
 #define COMPAT_OFF_T_MAX	0x7fffffff
 
 struct compat_ipc64_perm {
diff --git a/arch/x86/include/asm/signal.h b/arch/x86/include/asm/signal.h
index 6fd8410a3910..2dfb5fea13af 100644
--- a/arch/x86/include/asm/signal.h
+++ b/arch/x86/include/asm/signal.h
@@ -29,6 +29,7 @@ typedef struct {
 #define SA_X32_ABI	0x01000000u
 
 #ifndef CONFIG_COMPAT
+#define compat_sigset_t compat_sigset_t
 typedef sigset_t compat_sigset_t;
 #endif
 
diff --git a/include/asm-generic/compat.h b/include/asm-generic/compat.h
index 30f7b18a36f9..d46c0201cc34 100644
--- a/include/asm-generic/compat.h
+++ b/include/asm-generic/compat.h
@@ -20,7 +20,18 @@ typedef u16 compat_ushort_t;
 typedef u32 compat_uint_t;
 typedef u32 compat_ulong_t;
 typedef u32 compat_uptr_t;
+typedef u32 compat_caddr_t;
 typedef u32 compat_aio_context_t;
+typedef u32 compat_old_sigset_t;
+
+#ifndef __compat_uid32_t
+typedef u32 __compat_uid32_t;
+typedef u32 __compat_gid32_t;
+#endif
+
+#ifndef compat_mode_t
+typedef u32 compat_mode_t;
+#endif
 
 #ifdef CONFIG_COMPAT_FOR_U64_ALIGNMENT
 typedef s64 __attribute__((aligned(4))) compat_s64;
@@ -30,4 +41,10 @@ typedef s64 compat_s64;
 typedef u64 compat_u64;
 #endif
 
+#ifndef _COMPAT_NSIG
+typedef u32 compat_sigset_word;
+#define _COMPAT_NSIG _NSIG
+#define _COMPAT_NSIG_BPW 32
+#endif
+
 #endif
diff --git a/include/linux/compat.h b/include/linux/compat.h
index c270124e4402..8e0598c7d1d1 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -20,11 +20,8 @@
 #include <linux/unistd.h>
 
 #include <asm/compat.h>
-
-#ifdef CONFIG_COMPAT
 #include <asm/siginfo.h>
 #include <asm/signal.h>
-#endif
 
 #ifdef CONFIG_ARCH_HAS_SYSCALL_WRAPPER
 /*
@@ -95,8 +92,6 @@ struct compat_iovec {
 	compat_size_t	iov_len;
 };
 
-#ifdef CONFIG_COMPAT
-
 #ifndef compat_user_stack_pointer
 #define compat_user_stack_pointer() current_user_stack_pointer()
 #endif
@@ -131,9 +126,11 @@ struct compat_tms {
 
 #define _COMPAT_NSIG_WORDS	(_COMPAT_NSIG / _COMPAT_NSIG_BPW)
 
+#ifndef compat_sigset_t
 typedef struct {
 	compat_sigset_word	sig[_COMPAT_NSIG_WORDS];
 } compat_sigset_t;
+#endif
 
 int set_compat_user_sigmask(const compat_sigset_t __user *umask,
 			    size_t sigsetsize);
@@ -384,6 +381,7 @@ struct compat_keyctl_kdf_params {
 	__u32 __spare[8];
 };
 
+struct compat_stat;
 struct compat_statfs;
 struct compat_statfs64;
 struct compat_old_linux_dirent;
@@ -428,7 +426,7 @@ put_compat_sigset(compat_sigset_t __user *compat, const sigset_t *set,
 		  unsigned int size)
 {
 	/* size <= sizeof(compat_sigset_t) <= sizeof(sigset_t) */
-#ifdef __BIG_ENDIAN
+#if defined(__BIG_ENDIAN) && defined(CONFIG_64BIT)
 	compat_sigset_t v;
 	switch (_NSIG_WORDS) {
 	case 4: v.sig[7] = (set->sig[3] >> 32); v.sig[6] = set->sig[3];
@@ -929,17 +927,6 @@ asmlinkage long compat_sys_socketcall(int call, u32 __user *args);
 
 #endif /* CONFIG_ARCH_HAS_SYSCALL_WRAPPER */
 
-
-/*
- * For most but not all architectures, "am I in a compat syscall?" and
- * "am I a compat task?" are the same question.  For architectures on which
- * they aren't the same question, arch code can override in_compat_syscall.
- */
-
-#ifndef in_compat_syscall
-static inline bool in_compat_syscall(void) { return is_compat_task(); }
-#endif
-
 /**
  * ns_to_old_timeval32 - Compat version of ns_to_timeval
  * @nsec:	the nanoseconds value to be converted
@@ -969,6 +956,17 @@ int kcompat_sys_statfs64(const char __user * pathname, compat_size_t sz,
 int kcompat_sys_fstatfs64(unsigned int fd, compat_size_t sz,
 			  struct compat_statfs64 __user * buf);
 
+#ifdef CONFIG_COMPAT
+
+/*
+ * For most but not all architectures, "am I in a compat syscall?" and
+ * "am I a compat task?" are the same question.  For architectures on which
+ * they aren't the same question, arch code can override in_compat_syscall.
+ */
+#ifndef in_compat_syscall
+static inline bool in_compat_syscall(void) { return is_compat_task(); }
+#endif
+
 #else /* !CONFIG_COMPAT */
 
 #define is_compat_task() (0)
-- 
2.29.2

