Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE280FE9DC
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 01:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbfKPAmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 19:42:04 -0500
Received: from mout-p-101.mailbox.org ([80.241.56.151]:32004 "EHLO
        mout-p-101.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727202AbfKPAmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 19:42:03 -0500
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 47FGQG61QbzKmcq;
        Sat, 16 Nov 2019 01:32:38 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by hefe.heinlein-support.de (hefe.heinlein-support.de [91.198.250.172]) (amavisd-new, port 10030)
        with ESMTP id Fd7A89GNv-8X; Sat, 16 Nov 2019 01:32:33 +0100 (CET)
From:   Aleksa Sarai <cyphar@cyphar.com>
To:     Al Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Aleksa Sarai <cyphar@cyphar.com>,
        Christian Brauner <christian@brauner.io>,
        Eric Biederman <ebiederm@xmission.com>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>,
        David Drysdale <drysdale@google.com>,
        Chanho Min <chanho.min@lge.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Aleksa Sarai <asarai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        dev@opencontainers.org, containers@lists.linux-foundation.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-api@vger.kernel.org,
        libc-alpha@sourceware.org, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, sparclinux@vger.kernel.org
Subject: [PATCH v16 10/12] open: introduce openat2(2) syscall
Date:   Sat, 16 Nov 2019 11:28:00 +1100
Message-Id: <20191116002802.6663-11-cyphar@cyphar.com>
In-Reply-To: <20191116002802.6663-1-cyphar@cyphar.com>
References: <20191116002802.6663-1-cyphar@cyphar.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

/* Background. */
For a very long time, extending openat(2) with new features has been
incredibly frustrating. This stems from the fact that openat(2) is
possibly the most famous counter-example to the mantra "don't silently
accept garbage from userspace" -- it doesn't check whether unknown flags
are present[1].

This means that (generally) the addition of new flags to openat(2) has
been fraught with backwards-compatibility issues (O_TMPFILE has to be
defined as __O_TMPFILE|O_DIRECTORY|[O_RDWR or O_WRONLY] to ensure old
kernels gave errors, since it's insecure to silently ignore the
flag[2]). All new security-related flags therefore have a tough road to
being added to openat(2).

Userspace also has a hard time figuring out whether a particular flag is
supported on a particular kernel. While it is now possible with
contemporary kernels (thanks to [3]), older kernels will expose unknown
flag bits through fcntl(F_GETFL). Giving a clear -EINVAL during
openat(2) time matches modern syscall designs and is far more
fool-proof.

In addition, the newly-added path resolution restriction LOOKUP flags
(which we would like to expose to user-space) don't feel related to the
pre-existing O_* flag set -- they affect all components of path lookup.
We'd therefore like to add a new flag argument.

Adding a new syscall allows us to finally fix the flag-ignoring problem,
and we can make it extensible enough so that we will hopefully never
need an openat3(2).

/* Syscall Prototype. */
  /*
   * open_how is an extensible structure (similar in interface to
   * clone3(2) or sched_setattr(2)). The size parameter must be set to
   * sizeof(struct open_how), to allow for future extensions. All future
   * extensions will be appended to open_how, with their zero value
   * acting as a no-op default.
   */
  struct open_how { /* ... */ };

  int openat2(int dfd, const char *pathname,
              struct open_how *how, size_t size);

/* Description. */
The initial version of 'struct open_how' contains the following fields:

  flags
    Used to specify openat(2)-style flags. However, any unknown flag
    bits or otherwise incorrect flag combinations (like O_PATH|O_RDWR)
    will result in -EINVAL. In addition, this field is 64-bits wide to
    allow for more O_ flags than currently permitted with openat(2).

  mode
    The file mode for O_CREAT or O_TMPFILE.

    Must be set to zero if flags does not contain O_CREAT or O_TMPFILE.

  __padding
    Must be set to all zeroes.

  resolve
    Restrict path resolution (in contrast to O_* flags they affect all
    path components). The current set of flags are as follows (at the
    moment, all of the RESOLVE_ flags are implemented as just passing
    the corresponding LOOKUP_ flag).

    RESOLVE_NO_XDEV       => LOOKUP_NO_XDEV
    RESOLVE_NO_SYMLINKS   => LOOKUP_NO_SYMLINKS
    RESOLVE_NO_MAGICLINKS => LOOKUP_NO_MAGICLINKS
    RESOLVE_BENEATH       => LOOKUP_BENEATH
    RESOLVE_IN_ROOT       => LOOKUP_IN_ROOT

open_how does not contain an embedded size field, because it is of
little benefit (userspace can figure out the kernel open_how size at
runtime fairly easily without it).

Note that as a result of the new how->flags handling, O_PATH|O_TMPFILE
is no longer permitted for openat(2). As far as I can tell, this has
always been a bug and appears to not be used by userspace (and I've not
seen any problems on my machines by disallowing it). If it turns out
this breaks something, we can special-case it and only permit it for
openat(2) but not openat2(2).

/* Testing. */
In a follow-up patch there are over 200 selftests which ensure that this
syscall has the correct semantics and will correctly handle several
attack scenarios.

In addition, I've written a userspace library[4] which provides
convenient wrappers around openat2(RESOLVE_IN_ROOT) (this is necessary
because no other syscalls support RESOLVE_IN_ROOT, and thus lots of care
must be taken when using RESOLVE_IN_ROOT'd file descriptors with other
syscalls). During the development of this patch, I've run numerous
verification tests using libpathrs (showing that the API is reasonably
usable by userspace).

/* Future Work. */
Additional RESOLVE_ flags have been suggested during the review period.
These can be easily implemented separately (such as blocking auto-mount
during resolution).

Furthermore, there are some other proposed changes to the openat(2)
interface (the most obvious example is magic-link hardening[5]) which
would be a good opportunity to add a way for userspace to restrict how
O_PATH file descriptors can be re-opened.

[1]: https://lwn.net/Articles/588444/
[2]: https://lore.kernel.org/lkml/CA+55aFyyxJL1LyXZeBsf2ypriraj5ut1XkNDsunRBqgVjZU_6Q@mail.gmail.com
[3]: commit 629e014bb834 ("fs: completely ignore unknown open flags")
[4]: https://sourceware.org/bugzilla/show_bug.cgi?id=17523
[5]: https://lore.kernel.org/lkml/20190930183316.10190-2-cyphar@cyphar.com/

Suggested-by: Christian Brauner <christian@brauner.io>
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 CREDITS                                     |   4 +-
 arch/alpha/kernel/syscalls/syscall.tbl      |   1 +
 arch/arm/tools/syscall.tbl                  |   1 +
 arch/arm64/include/asm/unistd.h             |   2 +-
 arch/arm64/include/asm/unistd32.h           |   2 +
 arch/ia64/kernel/syscalls/syscall.tbl       |   1 +
 arch/m68k/kernel/syscalls/syscall.tbl       |   1 +
 arch/microblaze/kernel/syscalls/syscall.tbl |   1 +
 arch/mips/kernel/syscalls/syscall_n32.tbl   |   1 +
 arch/mips/kernel/syscalls/syscall_n64.tbl   |   1 +
 arch/mips/kernel/syscalls/syscall_o32.tbl   |   1 +
 arch/parisc/kernel/syscalls/syscall.tbl     |   1 +
 arch/powerpc/kernel/syscalls/syscall.tbl    |   1 +
 arch/s390/kernel/syscalls/syscall.tbl       |   1 +
 arch/sh/kernel/syscalls/syscall.tbl         |   1 +
 arch/sparc/kernel/syscalls/syscall.tbl      |   1 +
 arch/x86/entry/syscalls/syscall_32.tbl      |   1 +
 arch/x86/entry/syscalls/syscall_64.tbl      |   1 +
 arch/xtensa/kernel/syscalls/syscall.tbl     |   1 +
 fs/open.c                                   | 149 +++++++++++++++-----
 include/linux/fcntl.h                       |  12 +-
 include/linux/syscalls.h                    |   3 +
 include/uapi/asm-generic/unistd.h           |   5 +-
 include/uapi/linux/fcntl.h                  |  40 ++++++
 24 files changed, 195 insertions(+), 38 deletions(-)

diff --git a/CREDITS b/CREDITS
index 031605d46b4d..a048e001d726 100644
--- a/CREDITS
+++ b/CREDITS
@@ -3301,7 +3301,9 @@ S: France
 N: Aleksa Sarai
 E: cyphar@cyphar.com
 W: https://www.cyphar.com/
-D: `pids` cgroup subsystem
+D: /sys/fs/cgroup/pids
+D: openat2(2)
+S: Sydney, Australia
 
 N: Dipankar Sarma
 E: dipankar@in.ibm.com
diff --git a/arch/alpha/kernel/syscalls/syscall.tbl b/arch/alpha/kernel/syscalls/syscall.tbl
index 728fe028c02c..9f374f7d9514 100644
--- a/arch/alpha/kernel/syscalls/syscall.tbl
+++ b/arch/alpha/kernel/syscalls/syscall.tbl
@@ -475,3 +475,4 @@
 543	common	fspick				sys_fspick
 544	common	pidfd_open			sys_pidfd_open
 # 545 reserved for clone3
+547	common	openat2				sys_openat2
diff --git a/arch/arm/tools/syscall.tbl b/arch/arm/tools/syscall.tbl
index 6da7dc4d79cc..4ba54bc7e19a 100644
--- a/arch/arm/tools/syscall.tbl
+++ b/arch/arm/tools/syscall.tbl
@@ -449,3 +449,4 @@
 433	common	fspick				sys_fspick
 434	common	pidfd_open			sys_pidfd_open
 435	common	clone3				sys_clone3
+437	common	openat2				sys_openat2
diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
index 2629a68b8724..8aa00ccb0b96 100644
--- a/arch/arm64/include/asm/unistd.h
+++ b/arch/arm64/include/asm/unistd.h
@@ -38,7 +38,7 @@
 #define __ARM_NR_compat_set_tls		(__ARM_NR_COMPAT_BASE + 5)
 #define __ARM_NR_COMPAT_END		(__ARM_NR_COMPAT_BASE + 0x800)
 
-#define __NR_compat_syscalls		436
+#define __NR_compat_syscalls		438
 #endif
 
 #define __ARCH_WANT_SYS_CLONE
diff --git a/arch/arm64/include/asm/unistd32.h b/arch/arm64/include/asm/unistd32.h
index 94ab29cf4f00..57f6f592d460 100644
--- a/arch/arm64/include/asm/unistd32.h
+++ b/arch/arm64/include/asm/unistd32.h
@@ -879,6 +879,8 @@ __SYSCALL(__NR_fspick, sys_fspick)
 __SYSCALL(__NR_pidfd_open, sys_pidfd_open)
 #define __NR_clone3 435
 __SYSCALL(__NR_clone3, sys_clone3)
+#define __NR_openat2 437
+__SYSCALL(__NR_openat2, sys_openat2)
 
 /*
  * Please add new compat syscalls above this comment and update
diff --git a/arch/ia64/kernel/syscalls/syscall.tbl b/arch/ia64/kernel/syscalls/syscall.tbl
index 36d5faf4c86c..8d36f2e2dc89 100644
--- a/arch/ia64/kernel/syscalls/syscall.tbl
+++ b/arch/ia64/kernel/syscalls/syscall.tbl
@@ -356,3 +356,4 @@
 433	common	fspick				sys_fspick
 434	common	pidfd_open			sys_pidfd_open
 # 435 reserved for clone3
+437	common	openat2				sys_openat2
diff --git a/arch/m68k/kernel/syscalls/syscall.tbl b/arch/m68k/kernel/syscalls/syscall.tbl
index a88a285a0e5f..2559925f1924 100644
--- a/arch/m68k/kernel/syscalls/syscall.tbl
+++ b/arch/m68k/kernel/syscalls/syscall.tbl
@@ -435,3 +435,4 @@
 433	common	fspick				sys_fspick
 434	common	pidfd_open			sys_pidfd_open
 # 435 reserved for clone3
+437	common	openat2				sys_openat2
diff --git a/arch/microblaze/kernel/syscalls/syscall.tbl b/arch/microblaze/kernel/syscalls/syscall.tbl
index 09b0cd7dab0a..c04385e60833 100644
--- a/arch/microblaze/kernel/syscalls/syscall.tbl
+++ b/arch/microblaze/kernel/syscalls/syscall.tbl
@@ -441,3 +441,4 @@
 433	common	fspick				sys_fspick
 434	common	pidfd_open			sys_pidfd_open
 435	common	clone3				sys_clone3
+437	common	openat2				sys_openat2
diff --git a/arch/mips/kernel/syscalls/syscall_n32.tbl b/arch/mips/kernel/syscalls/syscall_n32.tbl
index e7c5ab38e403..68c9ec06851f 100644
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -374,3 +374,4 @@
 433	n32	fspick				sys_fspick
 434	n32	pidfd_open			sys_pidfd_open
 435	n32	clone3				__sys_clone3
+437	n32	openat2				sys_openat2
diff --git a/arch/mips/kernel/syscalls/syscall_n64.tbl b/arch/mips/kernel/syscalls/syscall_n64.tbl
index 13cd66581f3b..42a72d010050 100644
--- a/arch/mips/kernel/syscalls/syscall_n64.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n64.tbl
@@ -350,3 +350,4 @@
 433	n64	fspick				sys_fspick
 434	n64	pidfd_open			sys_pidfd_open
 435	n64	clone3				__sys_clone3
+437	n64	openat2				sys_openat2
diff --git a/arch/mips/kernel/syscalls/syscall_o32.tbl b/arch/mips/kernel/syscalls/syscall_o32.tbl
index 353539ea4140..f114c4aed0ed 100644
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -423,3 +423,4 @@
 433	o32	fspick				sys_fspick
 434	o32	pidfd_open			sys_pidfd_open
 435	o32	clone3				__sys_clone3
+437	o32	openat2				sys_openat2
diff --git a/arch/parisc/kernel/syscalls/syscall.tbl b/arch/parisc/kernel/syscalls/syscall.tbl
index 285ff516150c..b550ae9a7fea 100644
--- a/arch/parisc/kernel/syscalls/syscall.tbl
+++ b/arch/parisc/kernel/syscalls/syscall.tbl
@@ -433,3 +433,4 @@
 433	common	fspick				sys_fspick
 434	common	pidfd_open			sys_pidfd_open
 435	common	clone3				sys_clone3_wrapper
+437	common	openat2				sys_openat2
diff --git a/arch/powerpc/kernel/syscalls/syscall.tbl b/arch/powerpc/kernel/syscalls/syscall.tbl
index 43f736ed47f2..a8b5ecb5b602 100644
--- a/arch/powerpc/kernel/syscalls/syscall.tbl
+++ b/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -517,3 +517,4 @@
 433	common	fspick				sys_fspick
 434	common	pidfd_open			sys_pidfd_open
 435	nospu	clone3				ppc_clone3
+437	common	openat2				sys_openat2
diff --git a/arch/s390/kernel/syscalls/syscall.tbl b/arch/s390/kernel/syscalls/syscall.tbl
index 3054e9c035a3..16b571c06161 100644
--- a/arch/s390/kernel/syscalls/syscall.tbl
+++ b/arch/s390/kernel/syscalls/syscall.tbl
@@ -438,3 +438,4 @@
 433  common	fspick			sys_fspick			sys_fspick
 434  common	pidfd_open		sys_pidfd_open			sys_pidfd_open
 435  common	clone3			sys_clone3			sys_clone3
+437  common	openat2			sys_openat2			sys_openat2
diff --git a/arch/sh/kernel/syscalls/syscall.tbl b/arch/sh/kernel/syscalls/syscall.tbl
index b5ed26c4c005..a7185cc18626 100644
--- a/arch/sh/kernel/syscalls/syscall.tbl
+++ b/arch/sh/kernel/syscalls/syscall.tbl
@@ -438,3 +438,4 @@
 433	common	fspick				sys_fspick
 434	common	pidfd_open			sys_pidfd_open
 # 435 reserved for clone3
+437	common	openat2				sys_openat2
diff --git a/arch/sparc/kernel/syscalls/syscall.tbl b/arch/sparc/kernel/syscalls/syscall.tbl
index 8c8cc7537fb2..b11c19552022 100644
--- a/arch/sparc/kernel/syscalls/syscall.tbl
+++ b/arch/sparc/kernel/syscalls/syscall.tbl
@@ -481,3 +481,4 @@
 433	common	fspick				sys_fspick
 434	common	pidfd_open			sys_pidfd_open
 # 435 reserved for clone3
+437	common	openat2			sys_openat2
diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 3fe02546aed3..e5c022e9a5c4 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -440,3 +440,4 @@
 433	i386	fspick			sys_fspick			__ia32_sys_fspick
 434	i386	pidfd_open		sys_pidfd_open			__ia32_sys_pidfd_open
 435	i386	clone3			sys_clone3			__ia32_sys_clone3
+437	i386	openat2			sys_openat2			__ia32_sys_openat2
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index c29976eca4a8..9035647ef236 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -357,6 +357,7 @@
 433	common	fspick			__x64_sys_fspick
 434	common	pidfd_open		__x64_sys_pidfd_open
 435	common	clone3			__x64_sys_clone3/ptregs
+437	common	openat2			__x64_sys_openat2
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/arch/xtensa/kernel/syscalls/syscall.tbl b/arch/xtensa/kernel/syscalls/syscall.tbl
index 25f4de729a6d..f0a68013c038 100644
--- a/arch/xtensa/kernel/syscalls/syscall.tbl
+++ b/arch/xtensa/kernel/syscalls/syscall.tbl
@@ -406,3 +406,4 @@
 433	common	fspick				sys_fspick
 434	common	pidfd_open			sys_pidfd_open
 435	common	clone3				sys_clone3
+437	common	openat2				sys_openat2
diff --git a/fs/open.c b/fs/open.c
index b62f5c0923a8..50a46501bcc9 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -955,48 +955,86 @@ struct file *open_with_fake_path(const struct path *path, int flags,
 }
 EXPORT_SYMBOL(open_with_fake_path);
 
-static inline int build_open_flags(int flags, umode_t mode, struct open_flags *op)
+#define WILL_CREATE(flags)	(flags & (O_CREAT | __O_TMPFILE))
+#define O_PATH_FLAGS		(O_DIRECTORY | O_NOFOLLOW | O_PATH | O_CLOEXEC)
+
+static inline struct open_how build_open_how(int flags, umode_t mode)
+{
+	struct open_how how = {
+		.flags = flags & VALID_OPEN_FLAGS,
+		.mode = mode & S_IALLUGO,
+	};
+
+	/* O_PATH beats everything else. */
+	if (how.flags & O_PATH)
+		how.flags &= O_PATH_FLAGS;
+	/* Modes should only be set for create-like flags. */
+	if (!WILL_CREATE(how.flags))
+		how.mode = 0;
+	return how;
+}
+
+static inline int build_open_flags(const struct open_how *how,
+				   struct open_flags *op)
 {
+	int flags = how->flags;
 	int lookup_flags = 0;
 	int acc_mode = ACC_MODE(flags);
 
+	/* Must never be set by userspace */
+	flags &= ~(FMODE_NONOTIFY | O_CLOEXEC);
+
 	/*
-	 * Clear out all open flags we don't know about so that we don't report
-	 * them in fcntl(F_GETFD) or similar interfaces.
+	 * Older syscalls implicitly clear all of the invalid flags or argument
+	 * values before calling build_open_flags(), but openat2(2) checks all
+	 * of its arguments.
 	 */
-	flags &= VALID_OPEN_FLAGS;
+	if (flags & ~VALID_OPEN_FLAGS)
+		return -EINVAL;
+	if (how->resolve & ~VALID_RESOLVE_FLAGS)
+		return -EINVAL;
+	if (memchr_inv(how->__padding, 0, sizeof(how->__padding)))
+		return -EINVAL;
 
-	if (flags & (O_CREAT | __O_TMPFILE))
-		op->mode = (mode & S_IALLUGO) | S_IFREG;
-	else
+	/* Deal with the mode. */
+	if (WILL_CREATE(flags)) {
+		if (how->mode & ~S_IALLUGO)
+			return -EINVAL;
+		op->mode = how->mode | S_IFREG;
+	} else {
+		if (how->mode != 0)
+			return -EINVAL;
 		op->mode = 0;
-
-	/* Must never be set by userspace */
-	flags &= ~FMODE_NONOTIFY & ~O_CLOEXEC;
+	}
 
 	/*
-	 * O_SYNC is implemented as __O_SYNC|O_DSYNC.  As many places only
-	 * check for O_DSYNC if the need any syncing at all we enforce it's
-	 * always set instead of having to deal with possibly weird behaviour
-	 * for malicious applications setting only __O_SYNC.
+	 * In order to ensure programs get explicit errors when trying to use
+	 * O_TMPFILE on old kernels, O_TMPFILE is implemented such that it
+	 * looks like (O_DIRECTORY|O_RDWR & ~O_CREAT) to old kernels. But we
+	 * have to require userspace to explicitly set it.
 	 */
-	if (flags & __O_SYNC)
-		flags |= O_DSYNC;
-
 	if (flags & __O_TMPFILE) {
 		if ((flags & O_TMPFILE_MASK) != O_TMPFILE)
 			return -EINVAL;
 		if (!(acc_mode & MAY_WRITE))
 			return -EINVAL;
-	} else if (flags & O_PATH) {
-		/*
-		 * If we have O_PATH in the open flag. Then we
-		 * cannot have anything other than the below set of flags
-		 */
-		flags &= O_DIRECTORY | O_NOFOLLOW | O_PATH;
+	}
+	if (flags & O_PATH) {
+		/* O_PATH only permits certain other flags to be set. */
+		if (flags & ~O_PATH_FLAGS)
+			return -EINVAL;
 		acc_mode = 0;
 	}
 
+	/*
+	 * O_SYNC is implemented as __O_SYNC|O_DSYNC.  As many places only
+	 * check for O_DSYNC if the need any syncing at all we enforce it's
+	 * always set instead of having to deal with possibly weird behaviour
+	 * for malicious applications setting only __O_SYNC.
+	 */
+	if (flags & __O_SYNC)
+		flags |= O_DSYNC;
+
 	op->open_flag = flags;
 
 	/* O_TRUNC implies we need access checks for write permissions */
@@ -1022,6 +1060,18 @@ static inline int build_open_flags(int flags, umode_t mode, struct open_flags *o
 		lookup_flags |= LOOKUP_DIRECTORY;
 	if (!(flags & O_NOFOLLOW))
 		lookup_flags |= LOOKUP_FOLLOW;
+
+	if (how->resolve & RESOLVE_NO_XDEV)
+		lookup_flags |= LOOKUP_NO_XDEV;
+	if (how->resolve & RESOLVE_NO_MAGICLINKS)
+		lookup_flags |= LOOKUP_NO_MAGICLINKS;
+	if (how->resolve & RESOLVE_NO_SYMLINKS)
+		lookup_flags |= LOOKUP_NO_SYMLINKS;
+	if (how->resolve & RESOLVE_BENEATH)
+		lookup_flags |= LOOKUP_BENEATH;
+	if (how->resolve & RESOLVE_IN_ROOT)
+		lookup_flags |= LOOKUP_IN_ROOT;
+
 	op->lookup_flags = lookup_flags;
 	return 0;
 }
@@ -1040,8 +1090,11 @@ static inline int build_open_flags(int flags, umode_t mode, struct open_flags *o
 struct file *file_open_name(struct filename *name, int flags, umode_t mode)
 {
 	struct open_flags op;
-	int err = build_open_flags(flags, mode, &op);
-	return err ? ERR_PTR(err) : do_filp_open(AT_FDCWD, name, &op);
+	struct open_how how = build_open_how(flags, mode);
+	int err = build_open_flags(&how, &op);
+	if (err)
+		return ERR_PTR(err);
+	return do_filp_open(AT_FDCWD, name, &op);
 }
 
 /**
@@ -1072,17 +1125,19 @@ struct file *file_open_root(struct dentry *dentry, struct vfsmount *mnt,
 			    const char *filename, int flags, umode_t mode)
 {
 	struct open_flags op;
-	int err = build_open_flags(flags, mode, &op);
+	struct open_how how = build_open_how(flags, mode);
+	int err = build_open_flags(&how, &op);
 	if (err)
 		return ERR_PTR(err);
 	return do_file_open_root(dentry, mnt, filename, &op);
 }
 EXPORT_SYMBOL(file_open_root);
 
-long do_sys_open(int dfd, const char __user *filename, int flags, umode_t mode)
+static long do_sys_openat2(int dfd, const char __user *filename,
+			   struct open_how *how)
 {
 	struct open_flags op;
-	int fd = build_open_flags(flags, mode, &op);
+	int fd = build_open_flags(how, &op);
 	struct filename *tmp;
 
 	if (fd)
@@ -1092,7 +1147,7 @@ long do_sys_open(int dfd, const char __user *filename, int flags, umode_t mode)
 	if (IS_ERR(tmp))
 		return PTR_ERR(tmp);
 
-	fd = get_unused_fd_flags(flags);
+	fd = get_unused_fd_flags(how->flags);
 	if (fd >= 0) {
 		struct file *f = do_filp_open(dfd, tmp, &op);
 		if (IS_ERR(f)) {
@@ -1107,12 +1162,16 @@ long do_sys_open(int dfd, const char __user *filename, int flags, umode_t mode)
 	return fd;
 }
 
-SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
+long do_sys_open(int dfd, const char __user *filename, int flags, umode_t mode)
 {
-	if (force_o_largefile())
-		flags |= O_LARGEFILE;
+	struct open_how how = build_open_how(flags, mode);
+	return do_sys_openat2(dfd, filename, &how);
+}
 
-	return do_sys_open(AT_FDCWD, filename, flags, mode);
+
+SYSCALL_DEFINE3(open, const char __user *, filename, int, flags, umode_t, mode)
+{
+	return ksys_open(filename, flags, mode);
 }
 
 SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
@@ -1120,10 +1179,32 @@ SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, flags,
 {
 	if (force_o_largefile())
 		flags |= O_LARGEFILE;
-
 	return do_sys_open(dfd, filename, flags, mode);
 }
 
+SYSCALL_DEFINE4(openat2, int, dfd, const char __user *, filename,
+		struct open_how __user *, how, size_t, usize)
+{
+	int err;
+	struct open_how tmp;
+
+	BUILD_BUG_ON(sizeof(struct open_how) < OPEN_HOW_SIZE_VER0);
+	BUILD_BUG_ON(sizeof(struct open_how) != OPEN_HOW_SIZE_LATEST);
+
+	if (unlikely(usize < OPEN_HOW_SIZE_VER0))
+		return -EINVAL;
+
+	err = copy_struct_from_user(&tmp, sizeof(tmp), how, usize);
+	if (err)
+		return err;
+
+	/* O_LARGEFILE is only allowed for non-O_PATH. */
+	if (!(tmp.flags & O_PATH) && force_o_largefile())
+		tmp.flags |= O_LARGEFILE;
+
+	return do_sys_openat2(dfd, filename, &tmp);
+}
+
 #ifdef CONFIG_COMPAT
 /*
  * Exactly like sys_open(), except that it doesn't set the
diff --git a/include/linux/fcntl.h b/include/linux/fcntl.h
index d019df946cb2..f2eb05bd3af3 100644
--- a/include/linux/fcntl.h
+++ b/include/linux/fcntl.h
@@ -2,15 +2,25 @@
 #ifndef _LINUX_FCNTL_H
 #define _LINUX_FCNTL_H
 
+#include <linux/stat.h>
 #include <uapi/linux/fcntl.h>
 
-/* list of all valid flags for the open/openat flags argument: */
+/* List of all valid flags for the open/openat flags argument: */
 #define VALID_OPEN_FLAGS \
 	(O_RDONLY | O_WRONLY | O_RDWR | O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC | \
 	 O_APPEND | O_NDELAY | O_NONBLOCK | O_NDELAY | __O_SYNC | O_DSYNC | \
 	 FASYNC	| O_DIRECT | O_LARGEFILE | O_DIRECTORY | O_NOFOLLOW | \
 	 O_NOATIME | O_CLOEXEC | O_PATH | __O_TMPFILE)
 
+/* List of all valid flags for the how->upgrade_mask argument: */
+#define VALID_UPGRADE_FLAGS \
+	(UPGRADE_NOWRITE | UPGRADE_NOREAD)
+
+/* List of all valid flags for the how->resolve argument: */
+#define VALID_RESOLVE_FLAGS \
+	(RESOLVE_NO_XDEV | RESOLVE_NO_MAGICLINKS | RESOLVE_NO_SYMLINKS | \
+	 RESOLVE_BENEATH | RESOLVE_IN_ROOT)
+
 #ifndef force_o_largefile
 #define force_o_largefile() (!IS_ENABLED(CONFIG_ARCH_32BIT_OFF_T))
 #endif
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index f7c561c4dcdd..808f103b7a62 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -69,6 +69,7 @@ struct rseq;
 union bpf_attr;
 struct io_uring_params;
 struct clone_args;
+struct open_how;
 
 #include <linux/types.h>
 #include <linux/aio_abi.h>
@@ -439,6 +440,8 @@ asmlinkage long sys_fchownat(int dfd, const char __user *filename, uid_t user,
 asmlinkage long sys_fchown(unsigned int fd, uid_t user, gid_t group);
 asmlinkage long sys_openat(int dfd, const char __user *filename, int flags,
 			   umode_t mode);
+asmlinkage long sys_openat2(int dfd, const char __user *filename,
+			    struct open_how *how, size_t size);
 asmlinkage long sys_close(unsigned int fd);
 asmlinkage long sys_vhangup(void);
 
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 1fc8faa6e973..d4122c091472 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -851,8 +851,11 @@ __SYSCALL(__NR_pidfd_open, sys_pidfd_open)
 __SYSCALL(__NR_clone3, sys_clone3)
 #endif
 
+#define __NR_openat2 437
+__SYSCALL(__NR_openat2, sys_openat2)
+
 #undef __NR_syscalls
-#define __NR_syscalls 436
+#define __NR_syscalls 438
 
 /*
  * 32 bit systems traditionally used different
diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
index 1d338357df8a..6b00ad378fb7 100644
--- a/include/uapi/linux/fcntl.h
+++ b/include/uapi/linux/fcntl.h
@@ -93,5 +93,45 @@
 
 #define AT_RECURSIVE		0x8000	/* Apply to the entire subtree */
 
+/*
+ * Arguments for how openat2(2) should open the target path. If @resolve is
+ * zero, then openat2(2) operates very similarly to openat(2).
+ *
+ * However, unlike openat(2), unknown bits in @flags result in -EINVAL rather
+ * than being silently ignored. @mode must be zero unless one of {O_CREAT,
+ * O_TMPFILE} are set.
+ *
+ * @flags: O_* flags.
+ * @mode: O_CREAT/O_TMPFILE file mode.
+ * @resolve: RESOLVE_* flags.
+ */
+struct open_how {
+	__aligned_u64 flags;
+	__u16 mode;
+	__u16 __padding[3]; /* must be zeroed */
+	__aligned_u64 resolve;
+};
+
+#define OPEN_HOW_SIZE_VER0	24 /* sizeof first published struct */
+#define OPEN_HOW_SIZE_LATEST	OPEN_HOW_SIZE_VER0
+
+/* how->resolve flags for openat2(2). */
+#define RESOLVE_NO_XDEV		0x01 /* Block mount-point crossings
+					(includes bind-mounts). */
+#define RESOLVE_NO_MAGICLINKS	0x02 /* Block traversal through procfs-style
+					"magic-links". */
+#define RESOLVE_NO_SYMLINKS	0x04 /* Block traversal through all symlinks
+					(implies OEXT_NO_MAGICLINKS) */
+#define RESOLVE_BENEATH		0x08 /* Block "lexical" trickery like
+					"..", symlinks, and absolute
+					paths which escape the dirfd. */
+#define RESOLVE_IN_ROOT		0x10 /* Make all jumps to "/" and ".."
+					be scoped inside the dirfd
+					(similar to chroot(2)). */
+
+/* how->upgrade flags for openat2(2). */
+/* First bit is reserved for a future UPGRADE_NOEXEC flag. */
+#define UPGRADE_NOREAD		0x02 /* Block re-opening with MAY_READ. */
+#define UPGRADE_NOWRITE		0x04 /* Block re-opening with MAY_WRITE. */
 
 #endif /* _UAPI_LINUX_FCNTL_H */
-- 
2.24.0

