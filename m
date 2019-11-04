Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B487DEE625
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 18:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729443AbfKDRhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 12:37:40 -0500
Received: from smtp-sh.infomaniak.ch ([128.65.195.4]:38733 "EHLO
        smtp-sh.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729441AbfKDRhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 12:37:40 -0500
X-Greylist: delayed 843 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Nov 2019 12:37:07 EST
Received: from smtp-3-0001.mail.infomaniak.ch ([10.4.36.108])
        by smtp-sh.infomaniak.ch (8.14.5/8.14.5) with ESMTP id xA4HMBuX005467
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 4 Nov 2019 18:22:11 +0100
Received: from localhost (unknown [94.23.54.103])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 871B5100ABF7E;
        Mon,  4 Nov 2019 18:22:10 +0100 (CET)
From:   =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To:     linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Drysdale <drysdale@google.com>,
        Florent Revest <revest@chromium.org>,
        James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>,
        John Johansen <john.johansen@canonical.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>,
        KP Singh <kpsingh@chromium.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>,
        Paul Moore <paul@paul-moore.com>,
        Sargun Dhillon <sargun@sargun.me>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Shuah Khan <shuah@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, Tejun Heo <tj@kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Tycho Andersen <tycho@tycho.ws>,
        Will Drewry <wad@chromium.org>, bpf@vger.kernel.org,
        kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v13 6/7] bpf,landlock: Add tests for the Landlock ptrace program type
Date:   Mon,  4 Nov 2019 18:21:45 +0100
Message-Id: <20191104172146.30797-7-mic@digikod.net>
X-Mailer: git-send-email 2.24.0.rc1
In-Reply-To: <20191104172146.30797-1-mic@digikod.net>
References: <20191104172146.30797-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test eBPF program context access and ptrace hooks semantic.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: James Morris <jmorris@namei.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Will Drewry <wad@chromium.org>
---

Changes since v12:
* add documentation and diagrams (by Vincent Dagonneau)

Changes since v11:
* cosmetic fixes

Changes since v10:
* rework tests with new Landlock ptrace programs which restrict ptrace
  thanks to the task_landlock_ptrace_ancestor() helper
* simplify ptrace tests (make expect_ptrace implicit)
* add tests:
  * check a child process tracing its parent
  * check Landlock domain without ptrace enforcement (e.g. useful for
    audit/signaling purpose)
  * check inherited-only domains
  * check task pointer arithmetic
* fix flaky test for multi-core
* increase log size
* cosmetic renames
* update and improve the Makefile

Changes since v9:
* replace subtype with expected_attach_type and expected_attach_triggers
* rename inode_map_lookup() into inode_map_lookup_elem()
* check for inode map entry without value (which is now possible thanks
  to the pointer null check)
* use read-only inode map for Landlock programs

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
 scripts/bpf_helpers_doc.py                    |   1 +
 tools/include/uapi/linux/bpf.h                |  23 +-
 tools/include/uapi/linux/landlock.h           |  22 ++
 tools/lib/bpf/libbpf_probes.c                 |   3 +
 tools/testing/selftests/bpf/config            |   3 +
 tools/testing/selftests/bpf/test_verifier.c   |   1 +
 .../testing/selftests/bpf/verifier/landlock.c |  56 ++++
 tools/testing/selftests/landlock/.gitignore   |   5 +
 tools/testing/selftests/landlock/Makefile     |  27 ++
 tools/testing/selftests/landlock/config       |   5 +
 tools/testing/selftests/landlock/test.h       |  48 +++
 tools/testing/selftests/landlock/test_base.c  |  24 ++
 .../testing/selftests/landlock/test_ptrace.c  | 289 ++++++++++++++++++
 13 files changed, 506 insertions(+), 1 deletion(-)
 create mode 100644 tools/include/uapi/linux/landlock.h
 create mode 100644 tools/testing/selftests/bpf/verifier/landlock.c
 create mode 100644 tools/testing/selftests/landlock/.gitignore
 create mode 100644 tools/testing/selftests/landlock/Makefile
 create mode 100644 tools/testing/selftests/landlock/config
 create mode 100644 tools/testing/selftests/landlock/test.h
 create mode 100644 tools/testing/selftests/landlock/test_base.c
 create mode 100644 tools/testing/selftests/landlock/test_ptrace.c

diff --git a/scripts/bpf_helpers_doc.py b/scripts/bpf_helpers_doc.py
index 7548569e8076..8e4c0fe75663 100755
--- a/scripts/bpf_helpers_doc.py
+++ b/scripts/bpf_helpers_doc.py
@@ -466,6 +466,7 @@ class PrinterHelpers(Printer):
             'const struct sk_buff': 'const struct __sk_buff',
             'struct sk_msg_buff': 'struct sk_msg_md',
             'struct xdp_buff': 'struct xdp_md',
+            'struct task_struct': 'void',
     }
 
     def print_header(self):
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4af8b0819a32..c88436b97163 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -173,6 +173,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_CGROUP_SYSCTL,
 	BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE,
 	BPF_PROG_TYPE_CGROUP_SOCKOPT,
+	BPF_PROG_TYPE_LANDLOCK_HOOK,
 };
 
 enum bpf_attach_type {
@@ -199,6 +200,7 @@ enum bpf_attach_type {
 	BPF_CGROUP_UDP6_RECVMSG,
 	BPF_CGROUP_GETSOCKOPT,
 	BPF_CGROUP_SETSOCKOPT,
+	BPF_LANDLOCK_PTRACE,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -2775,6 +2777,24 @@ union bpf_attr {
  * 		restricted to raw_tracepoint bpf programs.
  * 	Return
  * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_task_landlock_ptrace_ancestor(struct task_struct *parent, struct task_struct *child)
+ *	Description
+ *		Check the relation of a potentially parent task with a child
+ *		one, according to their Landlock ptrace hook programs.
+ *	Return
+ *		**-EINVAL** if the child's ptrace programs are not comparable
+ *		to the parent ones, i.e. one of them is an empty set.
+ *
+ *		**-ENOENT** if the parent's ptrace programs are either in a
+ *		separate hierarchy of the child ones, or if the parent's ptrace
+ *		programs are a superset of the child ones.
+ *
+ *		0 if the parent's ptrace programs are the same as the child
+ *		ones.
+ *
+ *		1 if the parent's ptrace programs are indeed a subset of the
+ *		child ones.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2888,7 +2908,8 @@ union bpf_attr {
 	FN(sk_storage_delete),		\
 	FN(send_signal),		\
 	FN(tcp_gen_syncookie),		\
-	FN(skb_output),
+	FN(skb_output),			\
+	FN(task_landlock_ptrace_ancestor),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/tools/include/uapi/linux/landlock.h b/tools/include/uapi/linux/landlock.h
new file mode 100644
index 000000000000..3db2d190c4e7
--- /dev/null
+++ b/tools/include/uapi/linux/landlock.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Landlock - UAPI headers
+ *
+ * Copyright © 2017-2019 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2018-2019 ANSSI
+ */
+
+#ifndef _UAPI__LINUX_LANDLOCK_H__
+#define _UAPI__LINUX_LANDLOCK_H__
+
+#include <linux/types.h>
+
+#define LANDLOCK_RET_ALLOW	0
+#define LANDLOCK_RET_DENY	1
+
+struct landlock_context_ptrace {
+	__u64 tracer;
+	__u64 tracee;
+};
+
+#endif /* _UAPI__LINUX_LANDLOCK_H__ */
diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
index 4b0b0364f5fc..1e0d6346a7c7 100644
--- a/tools/lib/bpf/libbpf_probes.c
+++ b/tools/lib/bpf/libbpf_probes.c
@@ -78,6 +78,9 @@ probe_load(enum bpf_prog_type prog_type, const struct bpf_insn *insns,
 	case BPF_PROG_TYPE_KPROBE:
 		xattr.kern_version = get_kernel_version();
 		break;
+	case BPF_PROG_TYPE_LANDLOCK_HOOK:
+		xattr.expected_attach_type = BPF_LANDLOCK_PTRACE;
+		break;
 	case BPF_PROG_TYPE_UNSPEC:
 	case BPF_PROG_TYPE_SOCKET_FILTER:
 	case BPF_PROG_TYPE_SCHED_CLS:
diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 5dc109f4c097..3161a88a6059 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -35,3 +35,6 @@ CONFIG_MPLS_ROUTING=m
 CONFIG_MPLS_IPTUNNEL=m
 CONFIG_IPV6_SIT=m
 CONFIG_BPF_JIT=y
+CONFIG_SECCOMP_FILTER=y
+CONFIG_SECURITY=y
+CONFIG_SECURITY_LANDLOCK=y
diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index d27fd929abb9..74f249dafc0b 100644
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
index 000000000000..59cd333745dc
--- /dev/null
+++ b/tools/testing/selftests/bpf/verifier/landlock.c
@@ -0,0 +1,56 @@
+{
+	"landlock/ptrace: always accept",
+	.prog_type = BPF_PROG_TYPE_LANDLOCK_HOOK,
+	.expected_attach_type = BPF_LANDLOCK_PTRACE,
+	.insns = {
+		BPF_MOV32_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+},
+{
+	"landlock/ptrace: forbid arbitrary return value",
+	.prog_type = BPF_PROG_TYPE_LANDLOCK_HOOK,
+	.expected_attach_type = BPF_LANDLOCK_PTRACE,
+	.insns = {
+		BPF_MOV32_IMM(BPF_REG_0, 2),
+		BPF_EXIT_INSN(),
+	},
+	.result = REJECT,
+	.errstr = "At program exit the register R0 has value (0x2; 0x0) should have been in (0x0; 0x1)",
+},
+{
+	"landlock/ptrace: read context and call dedicated helper",
+	.prog_type = BPF_PROG_TYPE_LANDLOCK_HOOK,
+	.expected_attach_type = BPF_LANDLOCK_PTRACE,
+	.insns = {
+		BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+		BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_6,
+			offsetof(struct landlock_context_ptrace, tracer)),
+		BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_6,
+			offsetof(struct landlock_context_ptrace, tracer)),
+		BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
+				BPF_FUNC_task_landlock_ptrace_ancestor),
+		BPF_MOV32_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+},
+{
+	"landlock/ptrace: forbid pointer arithmetic",
+	.prog_type = BPF_PROG_TYPE_LANDLOCK_HOOK,
+	.expected_attach_type = BPF_LANDLOCK_PTRACE,
+	.insns = {
+		BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+		BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_6,
+			offsetof(struct landlock_context_ptrace, tracer)),
+		BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 1),
+		BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_6,
+			offsetof(struct landlock_context_ptrace, tracee)),
+		BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, 1),
+		BPF_MOV32_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.result = REJECT,
+	.errstr = "R1 pointer arithmetic on task prohibited",
+},
diff --git a/tools/testing/selftests/landlock/.gitignore b/tools/testing/selftests/landlock/.gitignore
new file mode 100644
index 000000000000..4c5c01d23fe0
--- /dev/null
+++ b/tools/testing/selftests/landlock/.gitignore
@@ -0,0 +1,5 @@
+/feature
+/fixdep
+/*libbpf*
+/test_base
+/test_ptrace
diff --git a/tools/testing/selftests/landlock/Makefile b/tools/testing/selftests/landlock/Makefile
new file mode 100644
index 000000000000..2da77c30e77f
--- /dev/null
+++ b/tools/testing/selftests/landlock/Makefile
@@ -0,0 +1,27 @@
+# SPDX-License-Identifier: GPL-2.0
+
+LIBDIR := $(abspath ../../../lib)
+BPFDIR := $(LIBDIR)/bpf
+TOOLSDIR := $(abspath ../../../include)
+APIDIR := $(TOOLSDIR)/uapi
+
+CFLAGS += -g -Wall -O2 -I$(APIDIR) -I$(LIBDIR) -I$(TOOLSDIR)
+LDLIBS += -lelf
+
+test_src = $(wildcard test_*.c)
+
+TEST_GEN_PROGS := $(test_src:.c=)
+
+include ../lib.mk
+
+BPFOBJ := $(OUTPUT)/libbpf.a
+
+$(TEST_GEN_PROGS): $(BPFOBJ) ../kselftest_harness.h
+
+.PHONY: force
+
+# force a rebuild of BPFOBJ when its dependencies are updated
+force:
+
+$(BPFOBJ): force
+	$(MAKE) -C $(BPFDIR) OUTPUT=$(OUTPUT)/
diff --git a/tools/testing/selftests/landlock/config b/tools/testing/selftests/landlock/config
new file mode 100644
index 000000000000..fa5081b840ad
--- /dev/null
+++ b/tools/testing/selftests/landlock/config
@@ -0,0 +1,5 @@
+CONFIG_BPF=y
+CONFIG_BPF_SYSCALL=y
+CONFIG_SECCOMP_FILTER=y
+CONFIG_SECURITY=y
+CONFIG_SECURITY_LANDLOCK=y
diff --git a/tools/testing/selftests/landlock/test.h b/tools/testing/selftests/landlock/test.h
new file mode 100644
index 000000000000..836df68b6bb8
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
+static int __attribute__((unused)) ll_bpf_load_program(
+		const struct bpf_insn *bpf_insns, size_t insns_len,
+		char *log_buf, size_t log_buf_sz,
+		const enum bpf_attach_type attach_type)
+{
+	struct bpf_load_program_attr load_attr;
+
+	memset(&load_attr, 0, sizeof(struct bpf_load_program_attr));
+	load_attr.prog_type = BPF_PROG_TYPE_LANDLOCK_HOOK;
+	load_attr.expected_attach_type = attach_type;
+	load_attr.insns = bpf_insns;
+	load_attr.insns_cnt = insns_len / sizeof(struct bpf_insn);
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
diff --git a/tools/testing/selftests/landlock/test_ptrace.c b/tools/testing/selftests/landlock/test_ptrace.c
new file mode 100644
index 000000000000..7f4945a61758
--- /dev/null
+++ b/tools/testing/selftests/landlock/test_ptrace.c
@@ -0,0 +1,289 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Landlock tests - ptrace
+ *
+ * Copyright © 2017-2019 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2019 ANSSI
+ */
+
+#define _GNU_SOURCE
+#include <signal.h>
+#include <sys/ptrace.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#include "test.h"
+
+#define LOG_SIZE 512
+
+static void create_domain(struct __test_metadata *_metadata,
+		bool scoped_ptrace, bool inherited_only)
+{
+	const struct bpf_insn prog_void[] = {
+		BPF_MOV32_IMM(BPF_REG_0, LANDLOCK_RET_ALLOW),
+		BPF_EXIT_INSN(),
+	};
+	const struct bpf_insn prog_check[] = {
+		BPF_ALU64_REG(BPF_MOV, BPF_REG_6, BPF_REG_1),
+		BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_6,
+			offsetof(struct landlock_context_ptrace, tracer)),
+		BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_6,
+			offsetof(struct landlock_context_ptrace, tracee)),
+		BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
+				BPF_FUNC_task_landlock_ptrace_ancestor),
+		/*
+		 * If @tracee is an ancestor or at the same level of @tracer,
+		 * then allow ptrace (warning: do not use BPF_JGE 0).
+		 */
+		BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, inherited_only ? 0 : 1, 2),
+		BPF_MOV32_IMM(BPF_REG_0, LANDLOCK_RET_DENY),
+		BPF_EXIT_INSN(),
+		BPF_MOV32_IMM(BPF_REG_0, LANDLOCK_RET_ALLOW),
+		BPF_EXIT_INSN(),
+	};
+	int prog;
+	char log[LOG_SIZE] = "";
+
+	if (scoped_ptrace)
+		prog = ll_bpf_load_program(prog_check, sizeof(prog_check),
+				log, sizeof(log), BPF_LANDLOCK_PTRACE);
+	else
+		prog = ll_bpf_load_program(prog_void, sizeof(prog_void),
+				log, sizeof(log), BPF_LANDLOCK_PTRACE);
+	ASSERT_NE(-1, prog) {
+		TH_LOG("Failed to load the %s program: %s\n%s",
+				scoped_ptrace ? "check" : "void",
+				strerror(errno), log);
+	}
+	ASSERT_EQ(0, seccomp(SECCOMP_PREPEND_LANDLOCK_PROG, 0, &prog)) {
+		TH_LOG("Failed to create a Landlock domain: %s",
+				strerror(errno));
+	}
+	EXPECT_EQ(0, close(prog));
+}
+
+/* test PTRACE_TRACEME and PTRACE_ATTACH for parent and child */
+static void _check_ptrace(struct __test_metadata *_metadata,
+		bool scoped_ptrace, bool domain_both,
+		bool domain_parent, bool domain_child)
+{
+	pid_t child, parent;
+	int status;
+	int pipe_child[2], pipe_parent[2];
+	char buf_parent;
+	const bool inherited_only = domain_both && !domain_parent &&
+		!domain_child;
+
+	parent = getpid();
+
+	ASSERT_EQ(0, pipe(pipe_child));
+	ASSERT_EQ(0, pipe(pipe_parent));
+	if (domain_both)
+		create_domain(_metadata, scoped_ptrace, inherited_only);
+
+	child = fork();
+	ASSERT_LE(0, child);
+	if (child == 0) {
+		char buf_child;
+
+		EXPECT_EQ(0, close(pipe_parent[1]));
+		EXPECT_EQ(0, close(pipe_child[0]));
+		if (domain_child)
+			create_domain(_metadata, scoped_ptrace, inherited_only);
+
+		/* sync #1 */
+		ASSERT_EQ(1, read(pipe_parent[0], &buf_child, 1)) {
+			TH_LOG("Failed to read() sync #1 from parent");
+		}
+		ASSERT_EQ('.', buf_child);
+
+		/* test the parent protection */
+		ASSERT_EQ((domain_child && scoped_ptrace) ? -1 : 0,
+				ptrace(PTRACE_ATTACH, parent, NULL, 0));
+		if (domain_child && scoped_ptrace) {
+			ASSERT_EQ(EPERM, errno);
+		} else {
+			ASSERT_EQ(parent, waitpid(parent, &status, 0));
+			ASSERT_EQ(1, WIFSTOPPED(status));
+			ASSERT_EQ(0, ptrace(PTRACE_DETACH, parent, NULL, 0));
+		}
+
+		/* sync #2 */
+		ASSERT_EQ(1, write(pipe_child[1], ".", 1)) {
+			TH_LOG("Failed to write() sync #2 to parent");
+		}
+
+		/* test traceme */
+		ASSERT_EQ((domain_parent && scoped_ptrace) ? -1 : 0,
+				ptrace(PTRACE_TRACEME));
+		if (domain_parent && scoped_ptrace) {
+			ASSERT_EQ(EPERM, errno);
+		} else {
+			ASSERT_EQ(0, raise(SIGSTOP));
+		}
+
+		/* sync #3 */
+		ASSERT_EQ(1, read(pipe_parent[0], &buf_child, 1)) {
+			TH_LOG("Failed to read() sync #3 from parent");
+		}
+		ASSERT_EQ('.', buf_child);
+		_exit(_metadata->passed ? EXIT_SUCCESS : EXIT_FAILURE);
+	}
+
+	EXPECT_EQ(0, close(pipe_child[1]));
+	EXPECT_EQ(0, close(pipe_parent[0]));
+	if (domain_parent)
+		create_domain(_metadata, scoped_ptrace, inherited_only);
+
+	/* sync #1 */
+	ASSERT_EQ(1, write(pipe_parent[1], ".", 1)) {
+		TH_LOG("Failed to write() sync #1 to child");
+	}
+
+	/* test the parent protection */
+	/* sync #2 */
+	ASSERT_EQ(1, read(pipe_child[0], &buf_parent, 1)) {
+		TH_LOG("Failed to read() sync #2 from child");
+	}
+	ASSERT_EQ('.', buf_parent);
+
+	/* test traceme */
+	if (!(domain_parent && scoped_ptrace)) {
+		ASSERT_EQ(child, waitpid(child, &status, 0));
+		ASSERT_EQ(1, WIFSTOPPED(status));
+		ASSERT_EQ(0, ptrace(PTRACE_DETACH, child, NULL, 0));
+	}
+	/* test attach */
+	ASSERT_EQ((domain_parent && scoped_ptrace) ? -1 : 0,
+			ptrace(PTRACE_ATTACH, child, NULL, 0));
+	if (domain_parent && scoped_ptrace) {
+		ASSERT_EQ(EPERM, errno);
+	} else {
+		ASSERT_EQ(child, waitpid(child, &status, 0));
+		ASSERT_EQ(1, WIFSTOPPED(status));
+		ASSERT_EQ(0, ptrace(PTRACE_DETACH, child, NULL, 0));
+	}
+
+	/* sync #3 */
+	ASSERT_EQ(1, write(pipe_parent[1], ".", 1)) {
+		TH_LOG("Failed to write() sync #3 to child");
+	}
+	ASSERT_EQ(child, waitpid(child, &status, 0));
+	if (WIFSIGNALED(status) || WEXITSTATUS(status))
+		_metadata->passed = 0;
+}
+
+/* keep the *_scoped order to check program inheritance */
+#define CHECK_PTRACE(name, domain_both, domain_parent, domain_child) \
+	TEST(name ## _unscoped) { \
+		_check_ptrace(_metadata, false, domain_both, domain_parent, \
+				domain_child); \
+	} \
+	TEST(name ## _scoped) { \
+		_check_ptrace(_metadata, false, domain_both, domain_parent, \
+				domain_child); \
+		_check_ptrace(_metadata, true, domain_both, domain_parent, \
+				domain_child); \
+	}
+
+/*
+ * Test multiple tracing combinations between a parent process P1 and a child
+ * process P2.
+ *
+ * Yama's scoped ptrace is presumed disabled.  If enabled, this additional
+ * restriction is enforced before any Landlock check, which means that all P2
+ * requests to trace P1 would be denied.
+ */
+
+/*
+ *        No domain
+ *
+ *   P1-.               P1 -> P2 : allow
+ *       \              P2 -> P1 : allow
+ *        'P2
+ */
+CHECK_PTRACE(allow_without_domain, false, false, false);
+
+/*
+ *        Child domain
+ *
+ *   P1--.              P1 -> P2 : allow
+ *        \             P2 -> P1 : deny
+ *        .'-----.
+ *        |  P2  |
+ *        '------'
+ */
+CHECK_PTRACE(allow_with_one_domain, false, false, true);
+
+/*
+ *        Parent domain
+ * .------.
+ * |  P1  --.           P1 -> P2 : deny
+ * '------'  \          P2 -> P1 : allow
+ *            '
+ *            P2
+ */
+CHECK_PTRACE(deny_with_parent_domain, false, true, false);
+
+/*
+ *        Parent + child domain (siblings)
+ * .------.
+ * |  P1  ---.          P1 -> P2 : deny
+ * '------'   \         P2 -> P1 : deny
+ *         .---'--.
+ *         |  P2  |
+ *         '------'
+ */
+CHECK_PTRACE(deny_with_sibling_domain, false, true, true);
+
+/*
+ *         Same domain (inherited)
+ * .-------------.
+ * | P1----.     |      P1 -> P2 : allow
+ * |        \    |      P2 -> P1 : allow
+ * |         '   |
+ * |         P2  |
+ * '-------------'
+ */
+CHECK_PTRACE(allow_sibling_domain, true, false, false);
+
+/*
+ *         Inherited + child domain
+ * .-----------------.
+ * |  P1----.        |  P1 -> P2 : allow
+ * |         \       |  P2 -> P1 : deny
+ * |        .-'----. |
+ * |        |  P2  | |
+ * |        '------' |
+ * '-----------------'
+ */
+CHECK_PTRACE(allow_with_nested_domain, true, false, true);
+
+/*
+ *         Inherited + parent domain
+ * .-----------------.
+ * |.------.         |  P1 -> P2 : deny
+ * ||  P1  ----.     |  P2 -> P1 : allow
+ * |'------'    \    |
+ * |             '   |
+ * |             P2  |
+ * '-----------------'
+ */
+CHECK_PTRACE(deny_with_nested_and_parent_domain, true, true, false);
+
+/*
+ *         Inherited + parent and child domain (siblings)
+ * .-----------------.
+ * | .------.        |  P1 -> P2 : deny
+ * | |  P1  .        |  P2 -> P1 : deny
+ * | '------'\       |
+ * |          \      |
+ * |        .--'---. |
+ * |        |  P2  | |
+ * |        '------' |
+ * '-----------------'
+ */
+CHECK_PTRACE(deny_with_forked_domain, true, true, true);
+
+TEST_HARNESS_MAIN
-- 
2.23.0

