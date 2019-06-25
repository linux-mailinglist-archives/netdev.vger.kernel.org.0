Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81E9455AC9
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 00:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfFYWNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 18:13:37 -0400
Received: from smtp-sh.infomaniak.ch ([128.65.195.4]:60963 "EHLO
        smtp-sh.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfFYWNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 18:13:36 -0400
Received: from smtp5.infomaniak.ch (smtp5.infomaniak.ch [83.166.132.18])
        by smtp-sh.infomaniak.ch (8.14.5/8.14.5) with ESMTP id x5PLrQV7019903
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jun 2019 23:53:26 +0200
Received: from localhost (ns3096276.ip-94-23-54.eu [94.23.54.103])
        (authenticated bits=0)
        by smtp5.infomaniak.ch (8.14.5/8.14.5) with ESMTP id x5PLrP22038950;
        Tue, 25 Jun 2019 23:53:26 +0200
From:   =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To:     linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Drysdale <drysdale@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>,
        John Johansen <john.johansen@canonical.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>,
        Paul Moore <paul@paul-moore.com>,
        Sargun Dhillon <sargun@sargun.me>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Shuah Khan <shuah@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, Tejun Heo <tj@kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>,
        Will Drewry <wad@chromium.org>,
        kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v9 09/10] bpf,landlock: Add tests for Landlock
Date:   Tue, 25 Jun 2019 23:52:38 +0200
Message-Id: <20190625215239.11136-10-mic@digikod.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190625215239.11136-1-mic@digikod.net>
References: <20190625215239.11136-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test basic context access, ptrace protection and filesystem hooks.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: James Morris <jmorris@namei.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Will Drewry <wad@chromium.org>
---

Changes since v8:
* update eBPF include path for macros
* use TEST_GEN_PROGS and use the generic "clean" target
* add more verbose errors
* update the bpf/verifier files
* remove chain tests (from landlock and bpf/verifier)
* replace the whitelist tests with blacklist tests (because of stateless
  Landlock programs): remove "dotdot" tests and other depth tests
* sync the landlock Makefile with its bpf sibling directory and use
  bpf_load_program_xattr()

Changes since v7:
* update tests and add new ones for filesystem hierarchy and Landlock
  chains.

Changes since v6:
* use the new kselftest_harness.h
* use const variables
* replace ASSERT_STEP with ASSERT_*
* rename BPF_PROG_TYPE_LANDLOCK to BPF_PROG_TYPE_LANDLOCK_RULE
* force sample library rebuild
* fix install target

Changes since v5:
* add subtype test
* add ptrace tests
* split and rename files
* cleanup and rebase
---
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/bpf/bpf_helpers.h     |   2 +
 tools/testing/selftests/bpf/test_verifier.c   |   1 +
 .../testing/selftests/bpf/verifier/landlock.c |  35 +++
 .../testing/selftests/bpf/verifier/subtype.c  |  10 +
 tools/testing/selftests/landlock/.gitignore   |   4 +
 tools/testing/selftests/landlock/Makefile     |  39 +++
 tools/testing/selftests/landlock/test.h       |  48 ++++
 tools/testing/selftests/landlock/test_base.c  |  24 ++
 tools/testing/selftests/landlock/test_fs.c    | 257 ++++++++++++++++++
 .../testing/selftests/landlock/test_ptrace.c  | 154 +++++++++++
 11 files changed, 575 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/verifier/landlock.c
 create mode 100644 tools/testing/selftests/landlock/.gitignore
 create mode 100644 tools/testing/selftests/landlock/Makefile
 create mode 100644 tools/testing/selftests/landlock/test.h
 create mode 100644 tools/testing/selftests/landlock/test_base.c
 create mode 100644 tools/testing/selftests/landlock/test_fs.c
 create mode 100644 tools/testing/selftests/landlock/test_ptrace.c

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 9781ca79794a..342a7d714fb9 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -21,6 +21,7 @@ TARGETS += ir
 TARGETS += kcmp
 TARGETS += kexec
 TARGETS += kvm
+TARGETS += landlock
 TARGETS += lib
 TARGETS += livepatch
 TARGETS += membarrier
diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index 1a5b1accf091..0b15c49fac3f 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -225,6 +225,8 @@ static void *(*bpf_sk_storage_get)(void *map, struct bpf_sock *sk,
 static int (*bpf_sk_storage_delete)(void *map, struct bpf_sock *sk) =
 	(void *)BPF_FUNC_sk_storage_delete;
 static int (*bpf_send_signal)(unsigned sig) = (void *)BPF_FUNC_send_signal;
+static unsigned long long (*bpf_inode_map_lookup)(void *map, void *key) =
+	(void *) BPF_FUNC_inode_map_lookup;
 
 /* llvm builtin functions that eBPF C program may use to
  * emit BPF_LD_ABS and BPF_LD_IND instructions
diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 93faffd31fc3..c67218ffebf9 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -30,6 +30,7 @@
 #include <linux/bpf.h>
 #include <linux/if_ether.h>
 #include <linux/btf.h>
+#include <linux/landlock.h>
 
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
diff --git a/tools/testing/selftests/bpf/verifier/landlock.c b/tools/testing/selftests/bpf/verifier/landlock.c
new file mode 100644
index 000000000000..7ed4e24c0a88
--- /dev/null
+++ b/tools/testing/selftests/bpf/verifier/landlock.c
@@ -0,0 +1,35 @@
+{
+	"landlock/fs_pick: always accept",
+	.insns = {
+		BPF_MOV32_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_LANDLOCK_HOOK,
+	.has_prog_subtype = true,
+	.prog_subtype = {
+		.landlock_hook = {
+			.type = LANDLOCK_HOOK_FS_PICK,
+			.triggers = LANDLOCK_TRIGGER_FS_PICK_READ,
+		}
+	},
+},
+{
+	"landlock/fs_pick: read context",
+	.insns = {
+		BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+		BPF_LDX_MEM(BPF_DW, BPF_REG_7, BPF_REG_6,
+			offsetof(struct landlock_ctx_fs_pick, inode)),
+		BPF_MOV32_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_LANDLOCK_HOOK,
+	.has_prog_subtype = true,
+	.prog_subtype = {
+		.landlock_hook = {
+			.type = LANDLOCK_HOOK_FS_PICK,
+			.triggers = LANDLOCK_TRIGGER_FS_PICK_READ,
+		}
+	},
+},
diff --git a/tools/testing/selftests/bpf/verifier/subtype.c b/tools/testing/selftests/bpf/verifier/subtype.c
index cf614223d53f..6bb7ef4b39b5 100644
--- a/tools/testing/selftests/bpf/verifier/subtype.c
+++ b/tools/testing/selftests/bpf/verifier/subtype.c
@@ -8,3 +8,13 @@
 	.result = REJECT,
 	.has_prog_subtype = true,
 },
+{
+	"missing subtype",
+	.insns = {
+		BPF_MOV32_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_LANDLOCK_HOOK,
+},
diff --git a/tools/testing/selftests/landlock/.gitignore b/tools/testing/selftests/landlock/.gitignore
new file mode 100644
index 000000000000..25b9cd834c3c
--- /dev/null
+++ b/tools/testing/selftests/landlock/.gitignore
@@ -0,0 +1,4 @@
+/test_base
+/test_fs
+/test_ptrace
+/tmp_*
diff --git a/tools/testing/selftests/landlock/Makefile b/tools/testing/selftests/landlock/Makefile
new file mode 100644
index 000000000000..7a253bf6d580
--- /dev/null
+++ b/tools/testing/selftests/landlock/Makefile
@@ -0,0 +1,39 @@
+LIBDIR := ../../../lib
+BPFDIR := $(LIBDIR)/bpf
+APIDIR := ../../../include/uapi
+GENDIR := ../../../../include/generated
+GENHDR := $(GENDIR)/autoconf.h
+
+ifneq ($(wildcard $(GENHDR)),)
+  GENFLAGS := -DHAVE_GENHDR
+endif
+
+BPFOBJS := $(BPFDIR)/bpf.o $(BPFDIR)/nlattr.o
+LOADOBJ := ../../../../samples/bpf/bpf_load.o
+
+CFLAGS += -Wl,-no-as-needed -Wall -O2 -I$(APIDIR) -I$(LIBDIR) -I$(BPFDIR) -I$(GENDIR) $(GENFLAGS) -I../../../include
+LDFLAGS += -lelf
+
+test_src = $(wildcard test_*.c)
+
+test_objs := $(test_src:.c=)
+
+TEST_GEN_PROGS := $(test_objs)
+
+.PHONY: all clean force
+
+all: $(test_objs)
+
+# force a rebuild of BPFOBJS when its dependencies are updated
+force:
+
+# rebuild bpf.o as a workaround for the samples/bpf bug
+$(BPFOBJS): $(LOADOBJ) force
+	$(MAKE) -C $(BPFDIR)
+
+$(LOADOBJ): force
+	$(MAKE) -C $(dir $(LOADOBJ))
+
+$(test_objs): $(BPFOBJS) $(LOADOBJ) ../kselftest_harness.h
+
+include ../lib.mk
diff --git a/tools/testing/selftests/landlock/test.h b/tools/testing/selftests/landlock/test.h
new file mode 100644
index 000000000000..7d412d94148c
--- /dev/null
+++ b/tools/testing/selftests/landlock/test.h
@@ -0,0 +1,48 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Landlock helpers
+ *
+ * Copyright © 2017-2019 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2019 ANSSI
+ */
+
+#include <bpf/bpf.h>
+#include <errno.h>
+#include <linux/filter.h>
+#include <linux/landlock.h>
+#include <linux/seccomp.h>
+#include <sys/prctl.h>
+#include <sys/syscall.h>
+
+#include "../kselftest_harness.h"
+#include "../../../../samples/bpf/bpf_load.h"
+
+#ifndef SECCOMP_PREPEND_LANDLOCK_PROG
+#define SECCOMP_PREPEND_LANDLOCK_PROG	4
+#endif
+
+#ifndef seccomp
+static int __attribute__((unused)) seccomp(unsigned int op, unsigned int flags,
+		void *args)
+{
+	errno = 0;
+	return syscall(__NR_seccomp, op, flags, args);
+}
+#endif
+
+/* bpf_load_program() with subtype */
+static int __attribute__((unused)) ll_bpf_load_program(
+		const struct bpf_insn *insns, size_t insns_cnt, char *log_buf,
+		size_t log_buf_sz, const union bpf_prog_subtype *subtype)
+{
+	struct bpf_load_program_attr load_attr;
+
+	memset(&load_attr, 0, sizeof(struct bpf_load_program_attr));
+	load_attr.prog_type = BPF_PROG_TYPE_LANDLOCK_HOOK;
+	load_attr.prog_subtype = subtype;
+	load_attr.insns = insns;
+	load_attr.insns_cnt = insns_cnt;
+	load_attr.license = "GPL";
+
+	return bpf_load_program_xattr(&load_attr, log_buf, log_buf_sz);
+}
diff --git a/tools/testing/selftests/landlock/test_base.c b/tools/testing/selftests/landlock/test_base.c
new file mode 100644
index 000000000000..db46f39048cb
--- /dev/null
+++ b/tools/testing/selftests/landlock/test_base.c
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Landlock tests - base
+ *
+ * Copyright © 2017-2019 Mickaël Salaün <mic@digikod.net>
+ */
+
+#define _GNU_SOURCE
+#include <errno.h>
+
+#include "test.h"
+
+TEST(seccomp_landlock)
+{
+	int ret;
+
+	ret = seccomp(SECCOMP_PREPEND_LANDLOCK_PROG, 0, NULL);
+	EXPECT_EQ(-1, ret);
+	EXPECT_EQ(EFAULT, errno) {
+		TH_LOG("Kernel does not support CONFIG_SECURITY_LANDLOCK");
+	}
+}
+
+TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/landlock/test_fs.c b/tools/testing/selftests/landlock/test_fs.c
new file mode 100644
index 000000000000..dba726ea4994
--- /dev/null
+++ b/tools/testing/selftests/landlock/test_fs.c
@@ -0,0 +1,257 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Landlock tests - file system
+ *
+ * Copyright © 2018-2019 Mickaël Salaün <mic@digikod.net>
+ */
+
+#include <fcntl.h> /* O_DIRECTORY */
+#include <sys/stat.h> /* statbuf */
+#include <unistd.h> /* faccessat() */
+
+#include "test.h"
+
+#define TEST_PATH_TRIGGERS ( \
+		LANDLOCK_TRIGGER_FS_PICK_OPEN | \
+		LANDLOCK_TRIGGER_FS_PICK_READDIR | \
+		LANDLOCK_TRIGGER_FS_PICK_EXECUTE | \
+		LANDLOCK_TRIGGER_FS_PICK_GETATTR)
+
+static void test_path_rel(struct __test_metadata *_metadata, int dirfd,
+		const char *path, int ret)
+{
+	int fd;
+	struct stat statbuf;
+
+	ASSERT_EQ(ret, faccessat(dirfd, path, R_OK | X_OK, 0));
+	ASSERT_EQ(ret, fstatat(dirfd, path, &statbuf, 0));
+	fd = openat(dirfd, path, O_DIRECTORY);
+	if (ret) {
+		ASSERT_EQ(-1, fd);
+	} else {
+		ASSERT_NE(-1, fd);
+		EXPECT_EQ(0, close(fd));
+	}
+}
+
+static void test_path(struct __test_metadata *_metadata, const char *path,
+		int ret)
+{
+	return test_path_rel(_metadata, AT_FDCWD, path, ret);
+}
+
+static const char d1[] = "/usr";
+static const char d2[] = "/usr/share";
+static const char d3[] = "/usr/share/doc";
+
+TEST(fs_base)
+{
+	test_path(_metadata, d1, 0);
+	test_path(_metadata, d2, 0);
+	test_path(_metadata, d3, 0);
+}
+
+#define MAP_VALUE_DENY 1
+
+static int create_denied_inode_map(struct __test_metadata *_metadata,
+		const char *const dirs[])
+{
+	int map, key, dirs_len, i;
+	__u64 value = MAP_VALUE_DENY;
+
+	ASSERT_NE(NULL, dirs) {
+		TH_LOG("No directory list\n");
+	}
+	ASSERT_NE(NULL, dirs[0]) {
+		TH_LOG("Empty directory list\n");
+	}
+
+	/* get the number of dir entries */
+	for (dirs_len = 0; dirs[dirs_len]; dirs_len++);
+	map = bpf_create_map(BPF_MAP_TYPE_INODE, sizeof(key), sizeof(value),
+			dirs_len, 0);
+	ASSERT_NE(-1, map) {
+		TH_LOG("Failed to create a map of %d elements: %s\n", dirs_len,
+				strerror(errno));
+	}
+
+	for (i = 0; dirs[i]; i++) {
+		key = open(dirs[i], O_RDONLY | O_CLOEXEC | O_DIRECTORY);
+		ASSERT_NE(-1, key) {
+			TH_LOG("Failed to open directory \"%s\": %s\n", dirs[i],
+					strerror(errno));
+		}
+		ASSERT_EQ(0, bpf_map_update_elem(map, &key, &value, BPF_ANY)) {
+			TH_LOG("Failed to update the map with \"%s\": %s\n",
+					dirs[i], strerror(errno));
+		}
+		close(key);
+	}
+	return map;
+}
+
+static void enforce_map(struct __test_metadata *_metadata, int map,
+		bool subpath)
+{
+	const struct bpf_insn prog_deny[] = {
+		BPF_ALU64_REG(BPF_MOV, BPF_REG_6, BPF_REG_1),
+		/* look for the requested inode in the map */
+		BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_6,
+			offsetof(struct landlock_ctx_fs_walk, inode)),
+		BPF_LD_MAP_FD(BPF_REG_1, map), /* 2 instructions */
+		BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
+				BPF_FUNC_inode_map_lookup),
+		/* if it is there, then deny access to the inode, otherwise
+		 * allow it */
+		BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, MAP_VALUE_DENY, 2),
+		BPF_MOV32_IMM(BPF_REG_0, LANDLOCK_RET_ALLOW),
+		BPF_EXIT_INSN(),
+		BPF_MOV32_IMM(BPF_REG_0, LANDLOCK_RET_DENY),
+		BPF_EXIT_INSN(),
+	};
+	union bpf_prog_subtype subtype = {};
+	int fd_walk = -1, fd_pick;
+	char log[1024] = "";
+
+	if (subpath) {
+		subtype.landlock_hook.type = LANDLOCK_HOOK_FS_WALK;
+		fd_walk = ll_bpf_load_program((const struct bpf_insn *)&prog_deny,
+				sizeof(prog_deny) / sizeof(struct bpf_insn),
+				log, sizeof(log), &subtype);
+		ASSERT_NE(-1, fd_walk) {
+			TH_LOG("Failed to load fs_walk program: %s\n%s",
+					strerror(errno), log);
+		}
+		ASSERT_EQ(0, seccomp(SECCOMP_PREPEND_LANDLOCK_PROG, 0, &fd_walk)) {
+			TH_LOG("Failed to apply Landlock program: %s", strerror(errno));
+		}
+		EXPECT_EQ(0, close(fd_walk));
+	}
+
+	subtype.landlock_hook.type = LANDLOCK_HOOK_FS_PICK;
+	subtype.landlock_hook.triggers = TEST_PATH_TRIGGERS;
+	fd_pick = ll_bpf_load_program((const struct bpf_insn *)&prog_deny,
+			sizeof(prog_deny) / sizeof(struct bpf_insn), log,
+			sizeof(log), &subtype);
+	ASSERT_NE(-1, fd_pick) {
+		TH_LOG("Failed to load fs_pick program: %s\n%s",
+				strerror(errno), log);
+	}
+	ASSERT_EQ(0, seccomp(SECCOMP_PREPEND_LANDLOCK_PROG, 0, &fd_pick)) {
+		TH_LOG("Failed to apply Landlock program: %s", strerror(errno));
+	}
+	EXPECT_EQ(0, close(fd_pick));
+}
+
+static void check_map_blacklist(struct __test_metadata *_metadata,
+		bool subpath)
+{
+	int map = create_denied_inode_map(_metadata, (const char *const [])
+			{ d2, NULL });
+	ASSERT_NE(-1, map);
+	enforce_map(_metadata, map, subpath);
+	test_path(_metadata, d1, 0);
+	test_path(_metadata, d2, -1);
+	test_path(_metadata, d3, subpath ? -1 : 0);
+	EXPECT_EQ(0, close(map));
+}
+
+TEST(fs_map_blacklist_literal)
+{
+	check_map_blacklist(_metadata, false);
+}
+
+TEST(fs_map_blacklist_subpath)
+{
+	check_map_blacklist(_metadata, true);
+}
+
+static const char r2[] = ".";
+static const char r3[] = "./doc";
+
+enum relative_access {
+	REL_OPEN,
+	REL_CHDIR,
+	REL_CHROOT,
+};
+
+static void check_access(struct __test_metadata *_metadata,
+		bool enforce, enum relative_access rel)
+{
+	int dirfd;
+	int map = -1;
+
+	if (rel == REL_CHROOT)
+		ASSERT_NE(-1, chdir(d2));
+	if (enforce) {
+		map = create_denied_inode_map(_metadata, (const char *const [])
+				{ d3, NULL });
+		ASSERT_NE(-1, map);
+		enforce_map(_metadata, map, true);
+	}
+	switch (rel) {
+	case REL_OPEN:
+		dirfd = open(d2, O_DIRECTORY);
+		ASSERT_NE(-1, dirfd);
+		break;
+	case REL_CHDIR:
+		ASSERT_NE(-1, chdir(d2));
+		dirfd = AT_FDCWD;
+		break;
+	case REL_CHROOT:
+		ASSERT_NE(-1, chroot(d2)) {
+			TH_LOG("Failed to chroot: %s\n", strerror(errno));
+		}
+		dirfd = AT_FDCWD;
+		break;
+	default:
+		ASSERT_TRUE(false);
+		return;
+	}
+
+	test_path_rel(_metadata, dirfd, r2, 0);
+	test_path_rel(_metadata, dirfd, r3, enforce ? -1 : 0);
+
+	if (rel == REL_OPEN)
+		EXPECT_EQ(0, close(dirfd));
+	if (enforce)
+		EXPECT_EQ(0, close(map));
+}
+
+TEST(fs_allow_open)
+{
+	/* no enforcement, via open */
+	check_access(_metadata, false, REL_OPEN);
+}
+
+TEST(fs_allow_chdir)
+{
+	/* no enforcement, via chdir */
+	check_access(_metadata, false, REL_CHDIR);
+}
+
+TEST(fs_allow_chroot)
+{
+	/* no enforcement, via chroot */
+	check_access(_metadata, false, REL_CHROOT);
+}
+
+TEST(fs_deny_open)
+{
+	/* enforcement without tag, via open */
+	check_access(_metadata, true, REL_OPEN);
+}
+
+TEST(fs_deny_chdir)
+{
+	/* enforcement without tag, via chdir */
+	check_access(_metadata, true, REL_CHDIR);
+}
+
+TEST(fs_deny_chroot)
+{
+	/* enforcement without tag, via chroot */
+	check_access(_metadata, true, REL_CHROOT);
+}
+
+TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/landlock/test_ptrace.c b/tools/testing/selftests/landlock/test_ptrace.c
new file mode 100644
index 000000000000..2f3e346288bc
--- /dev/null
+++ b/tools/testing/selftests/landlock/test_ptrace.c
@@ -0,0 +1,154 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Landlock tests - ptrace
+ *
+ * Copyright © 2017-2019 Mickaël Salaün <mic@digikod.net>
+ */
+
+#define _GNU_SOURCE
+#include <signal.h> /* raise */
+#include <sys/ptrace.h>
+#include <sys/types.h> /* waitpid */
+#include <sys/wait.h> /* waitpid */
+#include <unistd.h> /* fork, pipe */
+
+#include "test.h"
+
+static void apply_null_sandbox(struct __test_metadata *_metadata)
+{
+	const struct bpf_insn prog_accept[] = {
+		BPF_MOV32_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	};
+	const union bpf_prog_subtype subtype = {
+		.landlock_hook = {
+			.type = LANDLOCK_HOOK_FS_PICK,
+			.triggers = LANDLOCK_TRIGGER_FS_PICK_OPEN,
+		}
+	};
+	int prog;
+	char log[256] = "";
+
+	prog = ll_bpf_load_program((const struct bpf_insn *)&prog_accept,
+			sizeof(prog_accept) / sizeof(struct bpf_insn), log,
+			sizeof(log), &subtype);
+	ASSERT_NE(-1, prog) {
+		TH_LOG("Failed to load minimal rule: %s\n%s",
+				strerror(errno), log);
+	}
+	ASSERT_EQ(0, seccomp(SECCOMP_PREPEND_LANDLOCK_PROG, 0, &prog)) {
+		TH_LOG("Failed to apply minimal rule: %s", strerror(errno));
+	}
+	EXPECT_EQ(0, close(prog));
+}
+
+/* PTRACE_TRACEME and PTRACE_ATTACH without Landlock rules effect */
+static void check_ptrace(struct __test_metadata *_metadata,
+		int sandbox_both, int sandbox_parent, int sandbox_child,
+		int expect_ptrace)
+{
+	pid_t child;
+	int status;
+	int pipefd[2];
+
+	ASSERT_EQ(0, pipe(pipefd));
+	if (sandbox_both)
+		apply_null_sandbox(_metadata);
+
+	child = fork();
+	ASSERT_LE(0, child);
+	if (child == 0) {
+		char buf;
+
+		EXPECT_EQ(0, close(pipefd[1]));
+		if (sandbox_child)
+			apply_null_sandbox(_metadata);
+
+		/* test traceme */
+		ASSERT_EQ(expect_ptrace, ptrace(PTRACE_TRACEME));
+		if (expect_ptrace) {
+			ASSERT_EQ(EPERM, errno);
+		} else {
+			ASSERT_EQ(0, raise(SIGSTOP));
+		}
+
+		/* sync */
+		ASSERT_EQ(1, read(pipefd[0], &buf, 1)) {
+			TH_LOG("Failed to read() sync from parent");
+		}
+		ASSERT_EQ('.', buf);
+		_exit(_metadata->passed ? EXIT_SUCCESS : EXIT_FAILURE);
+	}
+
+	EXPECT_EQ(0, close(pipefd[0]));
+	if (sandbox_parent)
+		apply_null_sandbox(_metadata);
+
+	/* test traceme */
+	if (!expect_ptrace) {
+		ASSERT_EQ(child, waitpid(child, &status, 0));
+		ASSERT_EQ(1, WIFSTOPPED(status));
+		ASSERT_EQ(0, ptrace(PTRACE_DETACH, child, NULL, 0));
+	}
+	/* test attach */
+	ASSERT_EQ(expect_ptrace, ptrace(PTRACE_ATTACH, child, NULL, 0));
+	if (expect_ptrace) {
+		ASSERT_EQ(EPERM, errno);
+	} else {
+		ASSERT_EQ(child, waitpid(child, &status, 0));
+		ASSERT_EQ(1, WIFSTOPPED(status));
+		ASSERT_EQ(0, ptrace(PTRACE_CONT, child, NULL, 0));
+	}
+
+	/* sync */
+	ASSERT_EQ(1, write(pipefd[1], ".", 1)) {
+		TH_LOG("Failed to write() sync to child");
+	}
+	ASSERT_EQ(child, waitpid(child, &status, 0));
+	if (WIFSIGNALED(status) || WEXITSTATUS(status))
+		_metadata->passed = 0;
+}
+
+TEST(ptrace_allow_without_sandbox)
+{
+	/* no sandbox */
+	check_ptrace(_metadata, 0, 0, 0, 0);
+}
+
+TEST(ptrace_allow_with_one_sandbox)
+{
+	/* child sandbox */
+	check_ptrace(_metadata, 0, 0, 1, 0);
+}
+
+TEST(ptrace_allow_with_nested_sandbox)
+{
+	/* inherited and child sandbox */
+	check_ptrace(_metadata, 1, 0, 1, 0);
+}
+
+TEST(ptrace_deny_with_parent_sandbox)
+{
+	/* parent sandbox */
+	check_ptrace(_metadata, 0, 1, 0, -1);
+}
+
+TEST(ptrace_deny_with_nested_and_parent_sandbox)
+{
+	/* inherited and parent sandbox */
+	check_ptrace(_metadata, 1, 1, 0, -1);
+}
+
+TEST(ptrace_deny_with_forked_sandbox)
+{
+	/* inherited, parent and child sandbox */
+	check_ptrace(_metadata, 1, 1, 1, -1);
+}
+
+TEST(ptrace_deny_with_sibling_sandbox)
+{
+	/* parent and child sandbox */
+	check_ptrace(_metadata, 0, 1, 1, -1);
+}
+
+TEST_HARNESS_MAIN
-- 
2.20.1

