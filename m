Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B61FFF6EF
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 02:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbfKQBX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 20:23:27 -0500
Received: from mout-p-102.mailbox.org ([80.241.56.152]:32700 "EHLO
        mout-p-102.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbfKQBX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 20:23:27 -0500
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 47FvVJ1ZxVzKmcq;
        Sun, 17 Nov 2019 02:23:20 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id tmF_0I1V3SAT; Sun, 17 Nov 2019 02:23:15 +0100 (CET)
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
        Andrii Nakryiko <andriin@fb.com>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Aleksa Sarai <cyphar@cyphar.com>,
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
        Christian Brauner <christian@brauner.io>,
        Aleksa Sarai <asarai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        dev@opencontainers.org, containers@lists.linux-foundation.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-api@vger.kernel.org,
        libc-alpha@sourceware.org, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, sparclinux@vger.kernel.org
Subject: [PATCH v17 12/13] selftests: add openat2(2) selftests
Date:   Sun, 17 Nov 2019 12:17:12 +1100
Message-Id: <20191117011713.13032-13-cyphar@cyphar.com>
In-Reply-To: <20191117011713.13032-1-cyphar@cyphar.com>
References: <20191117011713.13032-1-cyphar@cyphar.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test all of the various openat2(2) flags. A small stress-test of a
symlink-rename attack is included to show that the protections against
".."-based attacks are sufficient.

The main things these self-tests are enforcing are:

  * The struct+usize ABI for openat2(2) and copy_struct_from_user() to
    ensure that upgrades will be handled gracefully (in addition,
    ensuring that misaligned structures are also handled correctly).

  * The -EINVAL checks for openat2(2) are all correctly handled to avoid
    userspace passing unknown or conflicting flag sets (most
    importantly, ensuring that invalid flag combinations are checked).

  * All of the RESOLVE_* semantics (including errno values) are
    correctly handled with various combinations of paths and flags.

  * RESOLVE_IN_ROOT correctly protects against the symlink rename(2)
    attack that has been responsible for several CVEs (and likely will
    be responsible for several more).

Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/openat2/.gitignore    |   1 +
 tools/testing/selftests/openat2/Makefile      |   8 +
 tools/testing/selftests/openat2/helpers.c     | 109 ++++
 tools/testing/selftests/openat2/helpers.h     | 107 ++++
 .../testing/selftests/openat2/openat2_test.c  | 316 +++++++++++
 .../selftests/openat2/rename_attack_test.c    | 160 ++++++
 .../testing/selftests/openat2/resolve_test.c  | 523 ++++++++++++++++++
 8 files changed, 1225 insertions(+)
 create mode 100644 tools/testing/selftests/openat2/.gitignore
 create mode 100644 tools/testing/selftests/openat2/Makefile
 create mode 100644 tools/testing/selftests/openat2/helpers.c
 create mode 100644 tools/testing/selftests/openat2/helpers.h
 create mode 100644 tools/testing/selftests/openat2/openat2_test.c
 create mode 100644 tools/testing/selftests/openat2/rename_attack_test.c
 create mode 100644 tools/testing/selftests/openat2/resolve_test.c

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 4cdbae6f4e61..28996856ed5e 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -37,6 +37,7 @@ TARGETS += powerpc
 TARGETS += proc
 TARGETS += pstore
 TARGETS += ptrace
+TARGETS += openat2
 TARGETS += rseq
 TARGETS += rtc
 TARGETS += seccomp
diff --git a/tools/testing/selftests/openat2/.gitignore b/tools/testing/selftests/openat2/.gitignore
new file mode 100644
index 000000000000..bd68f6c3fd07
--- /dev/null
+++ b/tools/testing/selftests/openat2/.gitignore
@@ -0,0 +1 @@
+/*_test
diff --git a/tools/testing/selftests/openat2/Makefile b/tools/testing/selftests/openat2/Makefile
new file mode 100644
index 000000000000..4b93b1417b86
--- /dev/null
+++ b/tools/testing/selftests/openat2/Makefile
@@ -0,0 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+
+CFLAGS += -Wall -O2 -g -fsanitize=address -fsanitize=undefined
+TEST_GEN_PROGS := openat2_test resolve_test rename_attack_test
+
+include ../lib.mk
+
+$(TEST_GEN_PROGS): helpers.c
diff --git a/tools/testing/selftests/openat2/helpers.c b/tools/testing/selftests/openat2/helpers.c
new file mode 100644
index 000000000000..e9a6557ab16f
--- /dev/null
+++ b/tools/testing/selftests/openat2/helpers.c
@@ -0,0 +1,109 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Author: Aleksa Sarai <cyphar@cyphar.com>
+ * Copyright (C) 2018-2019 SUSE LLC.
+ */
+
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <stdbool.h>
+#include <string.h>
+#include <syscall.h>
+#include <limits.h>
+
+#include "helpers.h"
+
+bool needs_openat2(const struct open_how *how)
+{
+	return how->resolve != 0;
+}
+
+int raw_openat2(int dfd, const char *path, void *how, size_t size)
+{
+	int ret = syscall(__NR_openat2, dfd, path, how, size);
+	return ret >= 0 ? ret : -errno;
+}
+
+int sys_openat2(int dfd, const char *path, struct open_how *how)
+{
+	return raw_openat2(dfd, path, how, sizeof(*how));
+}
+
+int sys_openat(int dfd, const char *path, struct open_how *how)
+{
+	int ret = openat(dfd, path, how->flags, how->mode);
+	return ret >= 0 ? ret : -errno;
+}
+
+int sys_renameat2(int olddirfd, const char *oldpath,
+		  int newdirfd, const char *newpath, unsigned int flags)
+{
+	int ret = syscall(__NR_renameat2, olddirfd, oldpath,
+					  newdirfd, newpath, flags);
+	return ret >= 0 ? ret : -errno;
+}
+
+int touchat(int dfd, const char *path)
+{
+	int fd = openat(dfd, path, O_CREAT);
+	if (fd >= 0)
+		close(fd);
+	return fd;
+}
+
+char *fdreadlink(int fd)
+{
+	char *target, *tmp;
+
+	E_asprintf(&tmp, "/proc/self/fd/%d", fd);
+
+	target = malloc(PATH_MAX);
+	if (!target)
+		ksft_exit_fail_msg("fdreadlink: malloc failed\n");
+	memset(target, 0, PATH_MAX);
+
+	E_readlink(tmp, target, PATH_MAX);
+	free(tmp);
+	return target;
+}
+
+bool fdequal(int fd, int dfd, const char *path)
+{
+	char *fdpath, *dfdpath, *other;
+	bool cmp;
+
+	fdpath = fdreadlink(fd);
+	dfdpath = fdreadlink(dfd);
+
+	if (!path)
+		E_asprintf(&other, "%s", dfdpath);
+	else if (*path == '/')
+		E_asprintf(&other, "%s", path);
+	else
+		E_asprintf(&other, "%s/%s", dfdpath, path);
+
+	cmp = !strcmp(fdpath, other);
+
+	free(fdpath);
+	free(dfdpath);
+	free(other);
+	return cmp;
+}
+
+bool openat2_supported = false;
+
+void __attribute__((constructor)) init(void)
+{
+	struct open_how how = {};
+	int fd;
+
+	BUILD_BUG_ON(sizeof(struct open_how) != OPEN_HOW_SIZE_VER0);
+
+	/* Check openat2(2) support. */
+	fd = sys_openat2(AT_FDCWD, ".", &how);
+	openat2_supported = (fd >= 0);
+
+	if (fd >= 0)
+		close(fd);
+}
diff --git a/tools/testing/selftests/openat2/helpers.h b/tools/testing/selftests/openat2/helpers.h
new file mode 100644
index 000000000000..43ca5ceab6e3
--- /dev/null
+++ b/tools/testing/selftests/openat2/helpers.h
@@ -0,0 +1,107 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Author: Aleksa Sarai <cyphar@cyphar.com>
+ * Copyright (C) 2018-2019 SUSE LLC.
+ */
+
+#ifndef __RESOLVEAT_H__
+#define __RESOLVEAT_H__
+
+#define _GNU_SOURCE
+#include <stdint.h>
+#include <errno.h>
+#include <linux/types.h>
+#include "../kselftest.h"
+
+#define ARRAY_LEN(X) (sizeof (X) / sizeof (*(X)))
+#define BUILD_BUG_ON(e) ((void)(sizeof(struct { int:(-!!(e)); })))
+
+#ifndef SYS_openat2
+#ifndef __NR_openat2
+#define __NR_openat2 437
+#endif /* __NR_openat2 */
+#define SYS_openat2 __NR_openat2
+#endif /* SYS_openat2 */
+
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
+bool needs_openat2(const struct open_how *how);
+
+#ifndef RESOLVE_IN_ROOT
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
+#endif /* RESOLVE_IN_ROOT */
+
+#define E_func(func, ...)						\
+	do {								\
+		if (func(__VA_ARGS__) < 0)				\
+			ksft_exit_fail_msg("%s:%d %s failed\n", \
+					   __FILE__, __LINE__, #func);\
+	} while (0)
+
+#define E_asprintf(...)		E_func(asprintf,	__VA_ARGS__)
+#define E_chmod(...)		E_func(chmod,		__VA_ARGS__)
+#define E_dup2(...)		E_func(dup2,		__VA_ARGS__)
+#define E_fchdir(...)		E_func(fchdir,		__VA_ARGS__)
+#define E_fstatat(...)		E_func(fstatat,		__VA_ARGS__)
+#define E_kill(...)		E_func(kill,		__VA_ARGS__)
+#define E_mkdirat(...)		E_func(mkdirat,		__VA_ARGS__)
+#define E_mount(...)		E_func(mount,		__VA_ARGS__)
+#define E_prctl(...)		E_func(prctl,		__VA_ARGS__)
+#define E_readlink(...)		E_func(readlink,	__VA_ARGS__)
+#define E_setresuid(...)	E_func(setresuid,	__VA_ARGS__)
+#define E_symlinkat(...)	E_func(symlinkat,	__VA_ARGS__)
+#define E_touchat(...)		E_func(touchat,		__VA_ARGS__)
+#define E_unshare(...)		E_func(unshare,		__VA_ARGS__)
+
+#define E_assert(expr, msg, ...)					\
+	do {								\
+		if (!(expr))						\
+			ksft_exit_fail_msg("ASSERT(%s:%d) failed (%s): " msg "\n", \
+					   __FILE__, __LINE__, #expr, ##__VA_ARGS__); \
+	} while (0)
+
+int raw_openat2(int dfd, const char *path, void *how, size_t size);
+int sys_openat2(int dfd, const char *path, struct open_how *how);
+int sys_openat(int dfd, const char *path, struct open_how *how);
+int sys_renameat2(int olddirfd, const char *oldpath,
+		  int newdirfd, const char *newpath, unsigned int flags);
+
+int touchat(int dfd, const char *path);
+char *fdreadlink(int fd);
+bool fdequal(int fd, int dfd, const char *path);
+
+extern bool openat2_supported;
+
+#endif /* __RESOLVEAT_H__ */
diff --git a/tools/testing/selftests/openat2/openat2_test.c b/tools/testing/selftests/openat2/openat2_test.c
new file mode 100644
index 000000000000..8a641acb0d6c
--- /dev/null
+++ b/tools/testing/selftests/openat2/openat2_test.c
@@ -0,0 +1,316 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Author: Aleksa Sarai <cyphar@cyphar.com>
+ * Copyright (C) 2018-2019 SUSE LLC.
+ */
+
+#define _GNU_SOURCE
+#include <fcntl.h>
+#include <sched.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <sys/mount.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <string.h>
+
+#include "../kselftest.h"
+#include "helpers.h"
+
+/*
+ * O_LARGEFILE is set to 0 by glibc.
+ * XXX: This is wrong on {mips, parisc, powerpc, sparc}.
+ */
+#undef	O_LARGEFILE
+#define	O_LARGEFILE 0x8000
+
+struct open_how_ext {
+	struct open_how inner;
+	uint32_t extra1;
+	char pad1[128];
+	uint32_t extra2;
+	char pad2[128];
+	uint32_t extra3;
+};
+
+struct struct_test {
+	const char *name;
+	struct open_how_ext arg;
+	size_t size;
+	int err;
+};
+
+#define NUM_OPENAT2_STRUCT_TESTS 9
+#define NUM_OPENAT2_STRUCT_VARIATIONS 13
+
+void test_openat2_struct(void)
+{
+	int misalignments[] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 17, 87 };
+
+	struct struct_test tests[] = {
+		/* Normal struct. */
+		{ .name = "normal struct",
+		  .arg.inner.flags = O_RDONLY,
+		  .size = sizeof(struct open_how) },
+		/* Bigger struct, with zeroed out end. */
+		{ .name = "bigger struct (zeroed out)",
+		  .arg.inner.flags = O_RDONLY,
+		  .size = sizeof(struct open_how_ext) },
+
+		/* Normal struct with broken padding. */
+		{ .name = "normal struct (non-zero padding[0])",
+		  .arg.inner.flags = O_RDONLY,
+		  .arg.inner.__padding = {0xa0, 0x00},
+		  .size = sizeof(struct open_how_ext), .err = -EINVAL },
+		{ .name = "normal struct (non-zero padding[1])",
+		  .arg.inner.flags = O_RDONLY,
+		  .arg.inner.__padding = {0x00, 0x1a},
+		  .size = sizeof(struct open_how_ext), .err = -EINVAL },
+
+		/* TODO: Once expanded, check zero-padding. */
+
+		/* Smaller than version-0 struct. */
+		{ .name = "zero-sized 'struct'",
+		  .arg.inner.flags = O_RDONLY, .size = 0, .err = -EINVAL },
+		{ .name = "smaller-than-v0 struct",
+		  .arg.inner.flags = O_RDONLY,
+		  .size = OPEN_HOW_SIZE_VER0 - 1, .err = -EINVAL },
+
+		/* Bigger struct, with non-zero trailing bytes. */
+		{ .name = "bigger struct (non-zero data in first 'future field')",
+		  .arg.inner.flags = O_RDONLY, .arg.extra1 = 0xdeadbeef,
+		  .size = sizeof(struct open_how_ext), .err = -E2BIG },
+		{ .name = "bigger struct (non-zero data in middle of 'future fields')",
+		  .arg.inner.flags = O_RDONLY, .arg.extra2 = 0xfeedcafe,
+		  .size = sizeof(struct open_how_ext), .err = -E2BIG },
+		{ .name = "bigger struct (non-zero data at end of 'future fields')",
+		  .arg.inner.flags = O_RDONLY, .arg.extra3 = 0xabad1dea,
+		  .size = sizeof(struct open_how_ext), .err = -E2BIG },
+	};
+
+	BUILD_BUG_ON(ARRAY_LEN(misalignments) != NUM_OPENAT2_STRUCT_VARIATIONS);
+	BUILD_BUG_ON(ARRAY_LEN(tests) != NUM_OPENAT2_STRUCT_TESTS);
+
+	for (int i = 0; i < ARRAY_LEN(tests); i++) {
+		struct struct_test *test = &tests[i];
+		struct open_how_ext how_ext = test->arg;
+
+		for (int j = 0; j < ARRAY_LEN(misalignments); j++) {
+			int fd, misalign = misalignments[j];
+			char *fdpath = NULL;
+			bool failed;
+			void (*resultfn)(const char *msg, ...) = ksft_test_result_pass;
+
+			void *copy = NULL, *how_copy = &how_ext;
+
+			if (!openat2_supported) {
+				ksft_print_msg("openat2(2) unsupported\n");
+				resultfn = ksft_test_result_skip;
+				goto skip;
+			}
+
+			if (misalign) {
+				/*
+				 * Explicitly misalign the structure copying it with the given
+				 * (mis)alignment offset. The other data is set to be non-zero to
+				 * make sure that non-zero bytes outside the struct aren't checked
+				 *
+				 * This is effectively to check that is_zeroed_user() works.
+				 */
+				copy = malloc(misalign + sizeof(how_ext));
+				how_copy = copy + misalign;
+				memset(copy, 0xff, misalign);
+				memcpy(how_copy, &how_ext, sizeof(how_ext));
+			}
+
+			fd = raw_openat2(AT_FDCWD, ".", how_copy, test->size);
+			if (test->err >= 0)
+				failed = (fd < 0);
+			else
+				failed = (fd != test->err);
+			if (fd >= 0) {
+				fdpath = fdreadlink(fd);
+				close(fd);
+			}
+
+			if (failed) {
+				resultfn = ksft_test_result_fail;
+
+				ksft_print_msg("openat2 unexpectedly returned ");
+				if (fdpath)
+					ksft_print_msg("%d['%s']\n", fd, fdpath);
+				else
+					ksft_print_msg("%d (%s)\n", fd, strerror(-fd));
+			}
+
+skip:
+			if (test->err >= 0)
+				resultfn("openat2 with %s argument [misalign=%d] succeeds\n",
+					 test->name, misalign);
+			else
+				resultfn("openat2 with %s argument [misalign=%d] fails with %d (%s)\n",
+					 test->name, misalign, test->err,
+					 strerror(-test->err));
+
+			free(copy);
+			free(fdpath);
+			fflush(stdout);
+		}
+	}
+}
+
+struct flag_test {
+	const char *name;
+	struct open_how how;
+	int err;
+};
+
+#define NUM_OPENAT2_FLAG_TESTS 21
+
+void test_openat2_flags(void)
+{
+	struct flag_test tests[] = {
+		/* O_TMPFILE is incompatible with O_PATH and O_CREAT. */
+		{ .name = "incompatible flags (O_TMPFILE | O_PATH)",
+		  .how.flags = O_TMPFILE | O_PATH | O_RDWR, .err = -EINVAL },
+		{ .name = "incompatible flags (O_TMPFILE | O_CREAT)",
+		  .how.flags = O_TMPFILE | O_CREAT | O_RDWR, .err = -EINVAL },
+
+		/* O_PATH only permits certain other flags to be set ... */
+		{ .name = "compatible flags (O_PATH | O_CLOEXEC)",
+		  .how.flags = O_PATH | O_CLOEXEC },
+		{ .name = "compatible flags (O_PATH | O_DIRECTORY)",
+		  .how.flags = O_PATH | O_DIRECTORY },
+		{ .name = "compatible flags (O_PATH | O_NOFOLLOW)",
+		  .how.flags = O_PATH | O_NOFOLLOW },
+		/* ... and others are absolutely not permitted. */
+		{ .name = "incompatible flags (O_PATH | O_RDWR)",
+		  .how.flags = O_PATH | O_RDWR, .err = -EINVAL },
+		{ .name = "incompatible flags (O_PATH | O_CREAT)",
+		  .how.flags = O_PATH | O_CREAT, .err = -EINVAL },
+		{ .name = "incompatible flags (O_PATH | O_EXCL)",
+		  .how.flags = O_PATH | O_EXCL, .err = -EINVAL },
+		{ .name = "incompatible flags (O_PATH | O_NOCTTY)",
+		  .how.flags = O_PATH | O_NOCTTY, .err = -EINVAL },
+		{ .name = "incompatible flags (O_PATH | O_DIRECT)",
+		  .how.flags = O_PATH | O_DIRECT, .err = -EINVAL },
+		{ .name = "incompatible flags (O_PATH | O_LARGEFILE)",
+		  .how.flags = O_PATH | O_LARGEFILE, .err = -EINVAL },
+
+		/* ->mode must only be set with O_{CREAT,TMPFILE}. */
+		{ .name = "non-zero how.mode and O_RDONLY",
+		  .how.flags = O_RDONLY, .how.mode = 0600, .err = -EINVAL },
+		{ .name = "non-zero how.mode and O_PATH",
+		  .how.flags = O_PATH,   .how.mode = 0600, .err = -EINVAL },
+		{ .name = "valid how.mode and O_CREAT",
+		  .how.flags = O_CREAT,  .how.mode = 0600 },
+		{ .name = "valid how.mode and O_TMPFILE",
+		  .how.flags = O_TMPFILE | O_RDWR, .how.mode = 0600 },
+		/* ->mode must only contain 0777 bits. */
+		{ .name = "invalid how.mode and O_CREAT",
+		  .how.flags = O_CREAT,
+		  .how.mode = 0xFFFF, .err = -EINVAL },
+		{ .name = "invalid how.mode and O_TMPFILE",
+		  .how.flags = O_TMPFILE | O_RDWR,
+		  .how.mode = 0x1337, .err = -EINVAL },
+
+		/* ->resolve must only contain RESOLVE_* flags. */
+		{ .name = "invalid how.resolve and O_RDONLY",
+		  .how.flags = O_RDONLY,
+		  .how.resolve = 0x1337, .err = -EINVAL },
+		{ .name = "invalid how.resolve and O_CREAT",
+		  .how.flags = O_CREAT,
+		  .how.resolve = 0x1337, .err = -EINVAL },
+		{ .name = "invalid how.resolve and O_TMPFILE",
+		  .how.flags = O_TMPFILE | O_RDWR,
+		  .how.resolve = 0x1337, .err = -EINVAL },
+		{ .name = "invalid how.resolve and O_PATH",
+		  .how.flags = O_PATH,
+		  .how.resolve = 0x1337, .err = -EINVAL },
+	};
+
+	BUILD_BUG_ON(ARRAY_LEN(tests) != NUM_OPENAT2_FLAG_TESTS);
+
+	for (int i = 0; i < ARRAY_LEN(tests); i++) {
+		int fd, fdflags = -1;
+		char *path, *fdpath = NULL;
+		bool failed = false;
+		struct flag_test *test = &tests[i];
+		void (*resultfn)(const char *msg, ...) = ksft_test_result_pass;
+
+		if (!openat2_supported) {
+			ksft_print_msg("openat2(2) unsupported\n");
+			resultfn = ksft_test_result_skip;
+			goto skip;
+		}
+
+		path = (test->how.flags & O_CREAT) ? "/tmp/ksft.openat2_tmpfile" : ".";
+		unlink(path);
+
+		fd = sys_openat2(AT_FDCWD, path, &test->how);
+		if (test->err >= 0)
+			failed = (fd < 0);
+		else
+			failed = (fd != test->err);
+		if (fd >= 0) {
+			int otherflags;
+
+			fdpath = fdreadlink(fd);
+			fdflags = fcntl(fd, F_GETFL);
+			otherflags = fcntl(fd, F_GETFD);
+			close(fd);
+
+			E_assert(fdflags >= 0, "fcntl F_GETFL of new fd");
+			E_assert(otherflags >= 0, "fcntl F_GETFD of new fd");
+
+			/* O_CLOEXEC isn't shown in F_GETFL. */
+			if (otherflags & FD_CLOEXEC)
+				fdflags |= O_CLOEXEC;
+			/* O_CREAT is hidden from F_GETFL. */
+			if (test->how.flags & O_CREAT)
+				fdflags |= O_CREAT;
+			if (!(test->how.flags & O_LARGEFILE))
+				fdflags &= ~O_LARGEFILE;
+			failed |= (fdflags != test->how.flags);
+		}
+
+		if (failed) {
+			resultfn = ksft_test_result_fail;
+
+			ksft_print_msg("openat2 unexpectedly returned ");
+			if (fdpath)
+				ksft_print_msg("%d['%s'] with %X (!= %X)\n",
+					       fd, fdpath, fdflags,
+					       test->how.flags);
+			else
+				ksft_print_msg("%d (%s)\n", fd, strerror(-fd));
+		}
+
+skip:
+		if (test->err >= 0)
+			resultfn("openat2 with %s succeeds\n", test->name);
+		else
+			resultfn("openat2 with %s fails with %d (%s)\n",
+				 test->name, test->err, strerror(-test->err));
+
+		free(fdpath);
+		fflush(stdout);
+	}
+}
+
+#define NUM_TESTS (NUM_OPENAT2_STRUCT_VARIATIONS * NUM_OPENAT2_STRUCT_TESTS + \
+		   NUM_OPENAT2_FLAG_TESTS)
+
+int main(int argc, char **argv)
+{
+	ksft_print_header();
+	ksft_set_plan(NUM_TESTS);
+
+	test_openat2_struct();
+	test_openat2_flags();
+
+	if (ksft_get_fail_cnt() + ksft_get_error_cnt() > 0)
+		ksft_exit_fail();
+	else
+		ksft_exit_pass();
+}
diff --git a/tools/testing/selftests/openat2/rename_attack_test.c b/tools/testing/selftests/openat2/rename_attack_test.c
new file mode 100644
index 000000000000..0a770728b436
--- /dev/null
+++ b/tools/testing/selftests/openat2/rename_attack_test.c
@@ -0,0 +1,160 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Author: Aleksa Sarai <cyphar@cyphar.com>
+ * Copyright (C) 2018-2019 SUSE LLC.
+ */
+
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <sched.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <sys/mount.h>
+#include <sys/mman.h>
+#include <sys/prctl.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <string.h>
+#include <syscall.h>
+#include <limits.h>
+#include <unistd.h>
+
+#include "../kselftest.h"
+#include "helpers.h"
+
+/* Construct a test directory with the following structure:
+ *
+ * root/
+ * |-- a/
+ * |   `-- c/
+ * `-- b/
+ */
+int setup_testdir(void)
+{
+	int dfd;
+	char dirname[] = "/tmp/ksft-openat2-rename-attack.XXXXXX";
+
+	/* Make the top-level directory. */
+	if (!mkdtemp(dirname))
+		ksft_exit_fail_msg("setup_testdir: failed to create tmpdir\n");
+	dfd = open(dirname, O_PATH | O_DIRECTORY);
+	if (dfd < 0)
+		ksft_exit_fail_msg("setup_testdir: failed to open tmpdir\n");
+
+	E_mkdirat(dfd, "a", 0755);
+	E_mkdirat(dfd, "b", 0755);
+	E_mkdirat(dfd, "a/c", 0755);
+
+	return dfd;
+}
+
+/* Swap @dirfd/@a and @dirfd/@b constantly. Parent must kill this process. */
+pid_t spawn_attack(int dirfd, char *a, char *b)
+{
+	pid_t child = fork();
+	if (child != 0)
+		return child;
+
+	/* If the parent (the test process) dies, kill ourselves too. */
+	E_prctl(PR_SET_PDEATHSIG, SIGKILL);
+
+	/* Swap @a and @b. */
+	for (;;)
+		renameat2(dirfd, a, dirfd, b, RENAME_EXCHANGE);
+	exit(1);
+}
+
+#define NUM_RENAME_TESTS 2
+#define ROUNDS 400000
+
+const char *flagname(int resolve)
+{
+	switch (resolve) {
+	case RESOLVE_IN_ROOT:
+		return "RESOLVE_IN_ROOT";
+	case RESOLVE_BENEATH:
+		return "RESOLVE_BENEATH";
+	}
+	return "(unknown)";
+}
+
+void test_rename_attack(int resolve)
+{
+	int dfd, afd;
+	pid_t child;
+	void (*resultfn)(const char *msg, ...) = ksft_test_result_pass;
+	int escapes = 0, other_errs = 0, exdevs = 0, eagains = 0, successes = 0;
+
+	struct open_how how = {
+		.flags = O_PATH,
+		.resolve = resolve,
+	};
+
+	if (!openat2_supported) {
+		how.resolve = 0;
+		ksft_print_msg("openat2(2) unsupported -- using openat(2) instead\n");
+	}
+
+	dfd = setup_testdir();
+	afd = openat(dfd, "a", O_PATH);
+	if (afd < 0)
+		ksft_exit_fail_msg("test_rename_attack: failed to open 'a'\n");
+
+	child = spawn_attack(dfd, "a/c", "b");
+
+	for (int i = 0; i < ROUNDS; i++) {
+		int fd;
+		char *victim_path = "c/../../c/../../c/../../c/../../c/../../c/../../c/../../c/../../c/../../c/../../c/../../c/../../c/../../c/../../c/../../c/../../c/../../c/../../c/../..";
+
+		if (openat2_supported)
+			fd = sys_openat2(afd, victim_path, &how);
+		else
+			fd = sys_openat(afd, victim_path, &how);
+
+		if (fd < 0) {
+			if (fd == -EAGAIN)
+				eagains++;
+			else if (fd == -EXDEV)
+				exdevs++;
+			else if (fd == -ENOENT)
+				escapes++; /* escaped outside and got ENOENT... */
+			else
+				other_errs++; /* unexpected error */
+		} else {
+			if (fdequal(fd, afd, NULL))
+				successes++;
+			else
+				escapes++; /* we got an unexpected fd */
+		}
+		close(fd);
+	}
+
+	if (escapes > 0)
+		resultfn = ksft_test_result_fail;
+	ksft_print_msg("non-escapes: EAGAIN=%d EXDEV=%d E<other>=%d success=%d\n",
+		       eagains, exdevs, other_errs, successes);
+	resultfn("rename attack with %s (%d runs, got %d escapes)\n",
+		 flagname(resolve), ROUNDS, escapes);
+
+	/* Should be killed anyway, but might as well make sure. */
+	E_kill(child, SIGKILL);
+}
+
+#define NUM_TESTS NUM_RENAME_TESTS
+
+int main(int argc, char **argv)
+{
+	ksft_print_header();
+	ksft_set_plan(NUM_TESTS);
+
+	test_rename_attack(RESOLVE_BENEATH);
+	test_rename_attack(RESOLVE_IN_ROOT);
+
+	if (ksft_get_fail_cnt() + ksft_get_error_cnt() > 0)
+		ksft_exit_fail();
+	else
+		ksft_exit_pass();
+}
diff --git a/tools/testing/selftests/openat2/resolve_test.c b/tools/testing/selftests/openat2/resolve_test.c
new file mode 100644
index 000000000000..7a94b1da8e7b
--- /dev/null
+++ b/tools/testing/selftests/openat2/resolve_test.c
@@ -0,0 +1,523 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Author: Aleksa Sarai <cyphar@cyphar.com>
+ * Copyright (C) 2018-2019 SUSE LLC.
+ */
+
+#define _GNU_SOURCE
+#include <fcntl.h>
+#include <sched.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <sys/mount.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <string.h>
+
+#include "../kselftest.h"
+#include "helpers.h"
+
+/*
+ * Construct a test directory with the following structure:
+ *
+ * root/
+ * |-- procexe -> /proc/self/exe
+ * |-- procroot -> /proc/self/root
+ * |-- root/
+ * |-- mnt/ [mountpoint]
+ * |   |-- self -> ../mnt/
+ * |   `-- absself -> /mnt/
+ * |-- etc/
+ * |   `-- passwd
+ * |-- creatlink -> /newfile3
+ * |-- reletc -> etc/
+ * |-- relsym -> etc/passwd
+ * |-- absetc -> /etc/
+ * |-- abssym -> /etc/passwd
+ * |-- abscheeky -> /cheeky
+ * `-- cheeky/
+ *     |-- absself -> /
+ *     |-- self -> ../../root/
+ *     |-- garbageself -> /../../root/
+ *     |-- passwd -> ../cheeky/../cheeky/../etc/../etc/passwd
+ *     |-- abspasswd -> /../cheeky/../cheeky/../etc/../etc/passwd
+ *     |-- dotdotlink -> ../../../../../../../../../../../../../../etc/passwd
+ *     `-- garbagelink -> /../../../../../../../../../../../../../../etc/passwd
+ */
+int setup_testdir(void)
+{
+	int dfd, tmpfd;
+	char dirname[] = "/tmp/ksft-openat2-testdir.XXXXXX";
+
+	/* Unshare and make /tmp a new directory. */
+	E_unshare(CLONE_NEWNS);
+	E_mount("", "/tmp", "", MS_PRIVATE, "");
+
+	/* Make the top-level directory. */
+	if (!mkdtemp(dirname))
+		ksft_exit_fail_msg("setup_testdir: failed to create tmpdir\n");
+	dfd = open(dirname, O_PATH | O_DIRECTORY);
+	if (dfd < 0)
+		ksft_exit_fail_msg("setup_testdir: failed to open tmpdir\n");
+
+	/* A sub-directory which is actually used for tests. */
+	E_mkdirat(dfd, "root", 0755);
+	tmpfd = openat(dfd, "root", O_PATH | O_DIRECTORY);
+	if (tmpfd < 0)
+		ksft_exit_fail_msg("setup_testdir: failed to open tmpdir\n");
+	close(dfd);
+	dfd = tmpfd;
+
+	E_symlinkat("/proc/self/exe", dfd, "procexe");
+	E_symlinkat("/proc/self/root", dfd, "procroot");
+	E_mkdirat(dfd, "root", 0755);
+
+	/* There is no mountat(2), so use chdir. */
+	E_mkdirat(dfd, "mnt", 0755);
+	E_fchdir(dfd);
+	E_mount("tmpfs", "./mnt", "tmpfs", MS_NOSUID | MS_NODEV, "");
+	E_symlinkat("../mnt/", dfd, "mnt/self");
+	E_symlinkat("/mnt/", dfd, "mnt/absself");
+
+	E_mkdirat(dfd, "etc", 0755);
+	E_touchat(dfd, "etc/passwd");
+
+	E_symlinkat("/newfile3", dfd, "creatlink");
+	E_symlinkat("etc/", dfd, "reletc");
+	E_symlinkat("etc/passwd", dfd, "relsym");
+	E_symlinkat("/etc/", dfd, "absetc");
+	E_symlinkat("/etc/passwd", dfd, "abssym");
+	E_symlinkat("/cheeky", dfd, "abscheeky");
+
+	E_mkdirat(dfd, "cheeky", 0755);
+
+	E_symlinkat("/", dfd, "cheeky/absself");
+	E_symlinkat("../../root/", dfd, "cheeky/self");
+	E_symlinkat("/../../root/", dfd, "cheeky/garbageself");
+
+	E_symlinkat("../cheeky/../etc/../etc/passwd", dfd, "cheeky/passwd");
+	E_symlinkat("/../cheeky/../etc/../etc/passwd", dfd, "cheeky/abspasswd");
+
+	E_symlinkat("../../../../../../../../../../../../../../etc/passwd",
+		    dfd, "cheeky/dotdotlink");
+	E_symlinkat("/../../../../../../../../../../../../../../etc/passwd",
+		    dfd, "cheeky/garbagelink");
+
+	return dfd;
+}
+
+struct basic_test {
+	const char *name;
+	const char *dir;
+	const char *path;
+	struct open_how how;
+	bool pass;
+	union {
+		int err;
+		const char *path;
+	} out;
+};
+
+#define NUM_OPENAT2_OPATH_TESTS 88
+
+void test_openat2_opath_tests(void)
+{
+	int rootfd, hardcoded_fd;
+	char *procselfexe, *hardcoded_fdpath;
+
+	E_asprintf(&procselfexe, "/proc/%d/exe", getpid());
+	rootfd = setup_testdir();
+
+	hardcoded_fd = open("/dev/null", O_RDONLY);
+	E_assert(hardcoded_fd >= 0, "open fd to hardcode");
+	E_asprintf(&hardcoded_fdpath, "self/fd/%d", hardcoded_fd);
+
+	struct basic_test tests[] = {
+		/** RESOLVE_BENEATH **/
+		/* Attempts to cross dirfd should be blocked. */
+		{ .name = "[beneath] jump to /",
+		  .path = "/",			.how.resolve = RESOLVE_BENEATH,
+		  .out.err = -EXDEV,		.pass = false },
+		{ .name = "[beneath] absolute link to $root",
+		  .path = "cheeky/absself",	.how.resolve = RESOLVE_BENEATH,
+		  .out.err = -EXDEV,		.pass = false },
+		{ .name = "[beneath] chained absolute links to $root",
+		  .path = "abscheeky/absself",	.how.resolve = RESOLVE_BENEATH,
+		  .out.err = -EXDEV,		.pass = false },
+		{ .name = "[beneath] jump outside $root",
+		  .path = "..",			.how.resolve = RESOLVE_BENEATH,
+		  .out.err = -EXDEV,		.pass = false },
+		{ .name = "[beneath] temporary jump outside $root",
+		  .path = "../root/",		.how.resolve = RESOLVE_BENEATH,
+		  .out.err = -EXDEV,		.pass = false },
+		{ .name = "[beneath] symlink temporary jump outside $root",
+		  .path = "cheeky/self",	.how.resolve = RESOLVE_BENEATH,
+		  .out.err = -EXDEV,		.pass = false },
+		{ .name = "[beneath] chained symlink temporary jump outside $root",
+		  .path = "abscheeky/self",	.how.resolve = RESOLVE_BENEATH,
+		  .out.err = -EXDEV,		.pass = false },
+		{ .name = "[beneath] garbage links to $root",
+		  .path = "cheeky/garbageself",	.how.resolve = RESOLVE_BENEATH,
+		  .out.err = -EXDEV,		.pass = false },
+		{ .name = "[beneath] chained garbage links to $root",
+		  .path = "abscheeky/garbageself", .how.resolve = RESOLVE_BENEATH,
+		  .out.err = -EXDEV,		.pass = false },
+		/* Only relative paths that stay inside dirfd should work. */
+		{ .name = "[beneath] ordinary path to 'root'",
+		  .path = "root",		.how.resolve = RESOLVE_BENEATH,
+		  .out.path = "root",		.pass = true },
+		{ .name = "[beneath] ordinary path to 'etc'",
+		  .path = "etc",		.how.resolve = RESOLVE_BENEATH,
+		  .out.path = "etc",		.pass = true },
+		{ .name = "[beneath] ordinary path to 'etc/passwd'",
+		  .path = "etc/passwd",		.how.resolve = RESOLVE_BENEATH,
+		  .out.path = "etc/passwd",	.pass = true },
+		{ .name = "[beneath] relative symlink inside $root",
+		  .path = "relsym",		.how.resolve = RESOLVE_BENEATH,
+		  .out.path = "etc/passwd",	.pass = true },
+		{ .name = "[beneath] chained-'..' relative symlink inside $root",
+		  .path = "cheeky/passwd",	.how.resolve = RESOLVE_BENEATH,
+		  .out.path = "etc/passwd",	.pass = true },
+		{ .name = "[beneath] absolute symlink component outside $root",
+		  .path = "abscheeky/passwd",	.how.resolve = RESOLVE_BENEATH,
+		  .out.err = -EXDEV,		.pass = false },
+		{ .name = "[beneath] absolute symlink target outside $root",
+		  .path = "abssym",		.how.resolve = RESOLVE_BENEATH,
+		  .out.err = -EXDEV,		.pass = false },
+		{ .name = "[beneath] absolute path outside $root",
+		  .path = "/etc/passwd",	.how.resolve = RESOLVE_BENEATH,
+		  .out.err = -EXDEV,		.pass = false },
+		{ .name = "[beneath] cheeky absolute path outside $root",
+		  .path = "cheeky/abspasswd",	.how.resolve = RESOLVE_BENEATH,
+		  .out.err = -EXDEV,		.pass = false },
+		{ .name = "[beneath] chained cheeky absolute path outside $root",
+		  .path = "abscheeky/abspasswd", .how.resolve = RESOLVE_BENEATH,
+		  .out.err = -EXDEV,		.pass = false },
+		/* Tricky paths should fail. */
+		{ .name = "[beneath] tricky '..'-chained symlink outside $root",
+		  .path = "cheeky/dotdotlink",	.how.resolve = RESOLVE_BENEATH,
+		  .out.err = -EXDEV,		.pass = false },
+		{ .name = "[beneath] tricky absolute + '..'-chained symlink outside $root",
+		  .path = "abscheeky/dotdotlink", .how.resolve = RESOLVE_BENEATH,
+		  .out.err = -EXDEV,		.pass = false },
+		{ .name = "[beneath] tricky garbage link outside $root",
+		  .path = "cheeky/garbagelink",	.how.resolve = RESOLVE_BENEATH,
+		  .out.err = -EXDEV,		.pass = false },
+		{ .name = "[beneath] tricky absolute + garbage link outside $root",
+		  .path = "abscheeky/garbagelink", .how.resolve = RESOLVE_BENEATH,
+		  .out.err = -EXDEV,		.pass = false },
+
+		/** RESOLVE_IN_ROOT **/
+		/* All attempts to cross the dirfd will be scoped-to-root. */
+		{ .name = "[in_root] jump to /",
+		  .path = "/",			.how.resolve = RESOLVE_IN_ROOT,
+		  .out.path = NULL,		.pass = true },
+		{ .name = "[in_root] absolute symlink to /root",
+		  .path = "cheeky/absself",	.how.resolve = RESOLVE_IN_ROOT,
+		  .out.path = NULL,		.pass = true },
+		{ .name = "[in_root] chained absolute symlinks to /root",
+		  .path = "abscheeky/absself",	.how.resolve = RESOLVE_IN_ROOT,
+		  .out.path = NULL,		.pass = true },
+		{ .name = "[in_root] '..' at root",
+		  .path = "..",			.how.resolve = RESOLVE_IN_ROOT,
+		  .out.path = NULL,		.pass = true },
+		{ .name = "[in_root] '../root' at root",
+		  .path = "../root/",		.how.resolve = RESOLVE_IN_ROOT,
+		  .out.path = "root",		.pass = true },
+		{ .name = "[in_root] relative symlink containing '..' above root",
+		  .path = "cheeky/self",	.how.resolve = RESOLVE_IN_ROOT,
+		  .out.path = "root",		.pass = true },
+		{ .name = "[in_root] garbage link to /root",
+		  .path = "cheeky/garbageself",	.how.resolve = RESOLVE_IN_ROOT,
+		  .out.path = "root",		.pass = true },
+		{ .name = "[in_root] chainged garbage links to /root",
+		  .path = "abscheeky/garbageself", .how.resolve = RESOLVE_IN_ROOT,
+		  .out.path = "root",		.pass = true },
+		{ .name = "[in_root] relative path to 'root'",
+		  .path = "root",		.how.resolve = RESOLVE_IN_ROOT,
+		  .out.path = "root",		.pass = true },
+		{ .name = "[in_root] relative path to 'etc'",
+		  .path = "etc",		.how.resolve = RESOLVE_IN_ROOT,
+		  .out.path = "etc",		.pass = true },
+		{ .name = "[in_root] relative path to 'etc/passwd'",
+		  .path = "etc/passwd",		.how.resolve = RESOLVE_IN_ROOT,
+		  .out.path = "etc/passwd",	.pass = true },
+		{ .name = "[in_root] relative symlink to 'etc/passwd'",
+		  .path = "relsym",		.how.resolve = RESOLVE_IN_ROOT,
+		  .out.path = "etc/passwd",	.pass = true },
+		{ .name = "[in_root] chained-'..' relative symlink to 'etc/passwd'",
+		  .path = "cheeky/passwd",	.how.resolve = RESOLVE_IN_ROOT,
+		  .out.path = "etc/passwd",	.pass = true },
+		{ .name = "[in_root] chained-'..' absolute + relative symlink to 'etc/passwd'",
+		  .path = "abscheeky/passwd",	.how.resolve = RESOLVE_IN_ROOT,
+		  .out.path = "etc/passwd",	.pass = true },
+		{ .name = "[in_root] absolute symlink to 'etc/passwd'",
+		  .path = "abssym",		.how.resolve = RESOLVE_IN_ROOT,
+		  .out.path = "etc/passwd",	.pass = true },
+		{ .name = "[in_root] absolute path 'etc/passwd'",
+		  .path = "/etc/passwd",	.how.resolve = RESOLVE_IN_ROOT,
+		  .out.path = "etc/passwd",	.pass = true },
+		{ .name = "[in_root] cheeky absolute path 'etc/passwd'",
+		  .path = "cheeky/abspasswd",	.how.resolve = RESOLVE_IN_ROOT,
+		  .out.path = "etc/passwd",	.pass = true },
+		{ .name = "[in_root] chained cheeky absolute path 'etc/passwd'",
+		  .path = "abscheeky/abspasswd", .how.resolve = RESOLVE_IN_ROOT,
+		  .out.path = "etc/passwd",	.pass = true },
+		{ .name = "[in_root] tricky '..'-chained symlink outside $root",
+		  .path = "cheeky/dotdotlink",	.how.resolve = RESOLVE_IN_ROOT,
+		  .out.path = "etc/passwd",	.pass = true },
+		{ .name = "[in_root] tricky absolute + '..'-chained symlink outside $root",
+		  .path = "abscheeky/dotdotlink", .how.resolve = RESOLVE_IN_ROOT,
+		  .out.path = "etc/passwd",	.pass = true },
+		{ .name = "[in_root] tricky absolute path + absolute + '..'-chained symlink outside $root",
+		  .path = "/../../../../abscheeky/dotdotlink", .how.resolve = RESOLVE_IN_ROOT,
+		  .out.path = "etc/passwd",	.pass = true },
+		{ .name = "[in_root] tricky garbage link outside $root",
+		  .path = "cheeky/garbagelink",	.how.resolve = RESOLVE_IN_ROOT,
+		  .out.path = "etc/passwd",	.pass = true },
+		{ .name = "[in_root] tricky absolute + garbage link outside $root",
+		  .path = "abscheeky/garbagelink", .how.resolve = RESOLVE_IN_ROOT,
+		  .out.path = "etc/passwd",	.pass = true },
+		{ .name = "[in_root] tricky absolute path + absolute + garbage link outside $root",
+		  .path = "/../../../../abscheeky/garbagelink", .how.resolve = RESOLVE_IN_ROOT,
+		  .out.path = "etc/passwd",	.pass = true },
+		/* O_CREAT should handle trailing symlinks correctly. */
+		{ .name = "[in_root] O_CREAT of relative path inside $root",
+		  .path = "newfile1",		.how.flags = O_CREAT,
+						.how.mode = 0700,
+						.how.resolve = RESOLVE_IN_ROOT,
+		  .out.path = "newfile1",	.pass = true },
+		{ .name = "[in_root] O_CREAT of absolute path",
+		  .path = "/newfile2",		.how.flags = O_CREAT,
+						.how.mode = 0700,
+						.how.resolve = RESOLVE_IN_ROOT,
+		  .out.path = "newfile2",	.pass = true },
+		{ .name = "[in_root] O_CREAT of tricky symlink outside root",
+		  .path = "/creatlink",		.how.flags = O_CREAT,
+						.how.mode = 0700,
+						.how.resolve = RESOLVE_IN_ROOT,
+		  .out.path = "newfile3",	.pass = true },
+
+		/** RESOLVE_NO_XDEV **/
+		/* Crossing *down* into a mountpoint is disallowed. */
+		{ .name = "[no_xdev] cross into $mnt",
+		  .path = "mnt",		.how.resolve = RESOLVE_NO_XDEV,
+		  .out.err = -EXDEV,		.pass = false },
+		{ .name = "[no_xdev] cross into $mnt/",
+		  .path = "mnt/",		.how.resolve = RESOLVE_NO_XDEV,
+		  .out.err = -EXDEV,		.pass = false },
+		{ .name = "[no_xdev] cross into $mnt/.",
+		  .path = "mnt/.",		.how.resolve = RESOLVE_NO_XDEV,
+		  .out.err = -EXDEV,		.pass = false },
+		/* Crossing *up* out of a mountpoint is disallowed. */
+		{ .name = "[no_xdev] goto mountpoint root",
+		  .dir = "mnt", .path = ".",	.how.resolve = RESOLVE_NO_XDEV,
+		  .out.path = "mnt",		.pass = true },
+		{ .name = "[no_xdev] cross up through '..'",
+		  .dir = "mnt", .path = "..",	.how.resolve = RESOLVE_NO_XDEV,
+		  .out.err = -EXDEV,		.pass = false },
+		{ .name = "[no_xdev] temporary cross up through '..'",
+		  .dir = "mnt", .path = "../mnt", .how.resolve = RESOLVE_NO_XDEV,
+		  .out.err = -EXDEV,		.pass = false },
+		{ .name = "[no_xdev] temporary relative symlink cross up",
+		  .dir = "mnt", .path = "self",	.how.resolve = RESOLVE_NO_XDEV,
+		  .out.err = -EXDEV,		.pass = false },
+		{ .name = "[no_xdev] temporary absolute symlink cross up",
+		  .dir = "mnt", .path = "absself", .how.resolve = RESOLVE_NO_XDEV,
+		  .out.err = -EXDEV,		.pass = false },
+		/* Jumping to "/" is ok, but later components cannot cross. */
+		{ .name = "[no_xdev] jump to / directly",
+		  .dir = "mnt", .path = "/",	.how.resolve = RESOLVE_NO_XDEV,
+		  .out.path = "/",		.pass = true },
+		{ .name = "[no_xdev] jump to / (from /) directly",
+		  .dir = "/", .path = "/",	.how.resolve = RESOLVE_NO_XDEV,
+		  .out.path = "/",		.pass = true },
+		{ .name = "[no_xdev] jump to / then proc",
+		  .path = "/proc/1",		.how.resolve = RESOLVE_NO_XDEV,
+		  .out.err = -EXDEV,		.pass = false },
+		{ .name = "[no_xdev] jump to / then tmp",
+		  .path = "/tmp",		.how.resolve = RESOLVE_NO_XDEV,
+		  .out.err = -EXDEV,		.pass = false },
+		/* Magic-links are blocked since they can switch vfsmounts. */
+		{ .name = "[no_xdev] cross through magic-link to self/root",
+		  .dir = "/proc", .path = "self/root", 	.how.resolve = RESOLVE_NO_XDEV,
+		  .out.err = -EXDEV,			.pass = false },
+		{ .name = "[no_xdev] cross through magic-link to self/cwd",
+		  .dir = "/proc", .path = "self/cwd",	.how.resolve = RESOLVE_NO_XDEV,
+		  .out.err = -EXDEV,			.pass = false },
+		/* Except magic-link jumps inside the same vfsmount. */
+		{ .name = "[no_xdev] jump through magic-link to same procfs",
+		  .dir = "/proc", .path = hardcoded_fdpath, .how.resolve = RESOLVE_NO_XDEV,
+		  .out.path = "/proc",			    .pass = true, },
+
+		/** RESOLVE_NO_MAGICLINKS **/
+		/* Regular symlinks should work. */
+		{ .name = "[no_magiclinks] ordinary relative symlink",
+		  .path = "relsym",		.how.resolve = RESOLVE_NO_MAGICLINKS,
+		  .out.path = "etc/passwd",	.pass = true },
+		/* Magic-links should not work. */
+		{ .name = "[no_magiclinks] symlink to magic-link",
+		  .path = "procexe",		.how.resolve = RESOLVE_NO_MAGICLINKS,
+		  .out.err = -ELOOP,		.pass = false },
+		{ .name = "[no_magiclinks] normal path to magic-link",
+		  .path = "/proc/self/exe",	.how.resolve = RESOLVE_NO_MAGICLINKS,
+		  .out.err = -ELOOP,		.pass = false },
+		{ .name = "[no_magiclinks] normal path to magic-link with O_NOFOLLOW",
+		  .path = "/proc/self/exe",	.how.flags = O_NOFOLLOW,
+						.how.resolve = RESOLVE_NO_MAGICLINKS,
+		  .out.path = procselfexe,	.pass = true },
+		{ .name = "[no_magiclinks] symlink to magic-link path component",
+		  .path = "procroot/etc",	.how.resolve = RESOLVE_NO_MAGICLINKS,
+		  .out.err = -ELOOP,		.pass = false },
+		{ .name = "[no_magiclinks] magic-link path component",
+		  .path = "/proc/self/root/etc", .how.resolve = RESOLVE_NO_MAGICLINKS,
+		  .out.err = -ELOOP,		.pass = false },
+		{ .name = "[no_magiclinks] magic-link path component with O_NOFOLLOW",
+		  .path = "/proc/self/root/etc", .how.flags = O_NOFOLLOW,
+						 .how.resolve = RESOLVE_NO_MAGICLINKS,
+		  .out.err = -ELOOP,		.pass = false },
+
+		/** RESOLVE_NO_SYMLINKS **/
+		/* Normal paths should work. */
+		{ .name = "[no_symlinks] ordinary path to '.'",
+		  .path = ".",			.how.resolve = RESOLVE_NO_SYMLINKS,
+		  .out.path = NULL,		.pass = true },
+		{ .name = "[no_symlinks] ordinary path to 'root'",
+		  .path = "root",		.how.resolve = RESOLVE_NO_SYMLINKS,
+		  .out.path = "root",		.pass = true },
+		{ .name = "[no_symlinks] ordinary path to 'etc'",
+		  .path = "etc",		.how.resolve = RESOLVE_NO_SYMLINKS,
+		  .out.path = "etc",		.pass = true },
+		{ .name = "[no_symlinks] ordinary path to 'etc/passwd'",
+		  .path = "etc/passwd",		.how.resolve = RESOLVE_NO_SYMLINKS,
+		  .out.path = "etc/passwd",	.pass = true },
+		/* Regular symlinks are blocked. */
+		{ .name = "[no_symlinks] relative symlink target",
+		  .path = "relsym",		.how.resolve = RESOLVE_NO_SYMLINKS,
+		  .out.err = -ELOOP,		.pass = false },
+		{ .name = "[no_symlinks] relative symlink component",
+		  .path = "reletc/passwd",	.how.resolve = RESOLVE_NO_SYMLINKS,
+		  .out.err = -ELOOP,		.pass = false },
+		{ .name = "[no_symlinks] absolute symlink target",
+		  .path = "abssym",		.how.resolve = RESOLVE_NO_SYMLINKS,
+		  .out.err = -ELOOP,		.pass = false },
+		{ .name = "[no_symlinks] absolute symlink component",
+		  .path = "absetc/passwd",	.how.resolve = RESOLVE_NO_SYMLINKS,
+		  .out.err = -ELOOP,		.pass = false },
+		{ .name = "[no_symlinks] cheeky garbage link",
+		  .path = "cheeky/garbagelink",	.how.resolve = RESOLVE_NO_SYMLINKS,
+		  .out.err = -ELOOP,		.pass = false },
+		{ .name = "[no_symlinks] cheeky absolute + garbage link",
+		  .path = "abscheeky/garbagelink", .how.resolve = RESOLVE_NO_SYMLINKS,
+		  .out.err = -ELOOP,		.pass = false },
+		{ .name = "[no_symlinks] cheeky absolute + absolute symlink",
+		  .path = "abscheeky/absself",	.how.resolve = RESOLVE_NO_SYMLINKS,
+		  .out.err = -ELOOP,		.pass = false },
+		/* Trailing symlinks with NO_FOLLOW. */
+		{ .name = "[no_symlinks] relative symlink with O_NOFOLLOW",
+		  .path = "relsym",		.how.flags = O_NOFOLLOW,
+						.how.resolve = RESOLVE_NO_SYMLINKS,
+		  .out.path = "relsym",		.pass = true },
+		{ .name = "[no_symlinks] absolute symlink with O_NOFOLLOW",
+		  .path = "abssym",		.how.flags = O_NOFOLLOW,
+						.how.resolve = RESOLVE_NO_SYMLINKS,
+		  .out.path = "abssym",		.pass = true },
+		{ .name = "[no_symlinks] trailing symlink with O_NOFOLLOW",
+		  .path = "cheeky/garbagelink",	.how.flags = O_NOFOLLOW,
+						.how.resolve = RESOLVE_NO_SYMLINKS,
+		  .out.path = "cheeky/garbagelink", .pass = true },
+		{ .name = "[no_symlinks] multiple symlink components with O_NOFOLLOW",
+		  .path = "abscheeky/absself",	.how.flags = O_NOFOLLOW,
+						.how.resolve = RESOLVE_NO_SYMLINKS,
+		  .out.err = -ELOOP,		.pass = false },
+		{ .name = "[no_symlinks] multiple symlink (and garbage link) components with O_NOFOLLOW",
+		  .path = "abscheeky/garbagelink", .how.flags = O_NOFOLLOW,
+						   .how.resolve = RESOLVE_NO_SYMLINKS,
+		  .out.err = -ELOOP,		.pass = false },
+	};
+
+	BUILD_BUG_ON(ARRAY_LEN(tests) != NUM_OPENAT2_OPATH_TESTS);
+
+	for (int i = 0; i < ARRAY_LEN(tests); i++) {
+		int dfd, fd;
+		char *fdpath = NULL;
+		bool failed;
+		void (*resultfn)(const char *msg, ...) = ksft_test_result_pass;
+		struct basic_test *test = &tests[i];
+
+		if (!openat2_supported) {
+			ksft_print_msg("openat2(2) unsupported\n");
+			resultfn = ksft_test_result_skip;
+			goto skip;
+		}
+
+		/* Auto-set O_PATH. */
+		if (!(test->how.flags & O_CREAT))
+			test->how.flags |= O_PATH;
+
+		if (test->dir)
+			dfd = openat(rootfd, test->dir, O_PATH | O_DIRECTORY);
+		else
+			dfd = dup(rootfd);
+		E_assert(dfd, "failed to openat root '%s': %m", test->dir);
+
+		E_dup2(dfd, hardcoded_fd);
+
+		fd = sys_openat2(dfd, test->path, &test->how);
+		if (test->pass)
+			failed = (fd < 0 || !fdequal(fd, rootfd, test->out.path));
+		else
+			failed = (fd != test->out.err);
+		if (fd >= 0) {
+			fdpath = fdreadlink(fd);
+			close(fd);
+		}
+		close(dfd);
+
+		if (failed) {
+			resultfn = ksft_test_result_fail;
+
+			ksft_print_msg("openat2 unexpectedly returned ");
+			if (fdpath)
+				ksft_print_msg("%d['%s']\n", fd, fdpath);
+			else
+				ksft_print_msg("%d (%s)\n", fd, strerror(-fd));
+		}
+
+skip:
+		if (test->pass)
+			resultfn("%s gives path '%s'\n", test->name,
+				 test->out.path ?: ".");
+		else
+			resultfn("%s fails with %d (%s)\n", test->name,
+				 test->out.err, strerror(-test->out.err));
+
+		fflush(stdout);
+		free(fdpath);
+	}
+
+	free(procselfexe);
+	close(rootfd);
+
+	free(hardcoded_fdpath);
+	close(hardcoded_fd);
+}
+
+#define NUM_TESTS NUM_OPENAT2_OPATH_TESTS
+
+int main(int argc, char **argv)
+{
+	ksft_print_header();
+	ksft_set_plan(NUM_TESTS);
+
+	/* NOTE: We should be checking for CAP_SYS_ADMIN here... */
+	if (geteuid() != 0)
+		ksft_exit_skip("all tests require euid == 0\n");
+
+	test_openat2_opath_tests();
+
+	if (ksft_get_fail_cnt() + ksft_get_error_cnt() > 0)
+		ksft_exit_fail();
+	else
+		ksft_exit_pass();
+}
-- 
2.24.0


