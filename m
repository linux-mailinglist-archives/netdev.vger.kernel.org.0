Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7B7EE61D
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 18:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729438AbfKDRhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 12:37:25 -0500
Received: from smtp-sh.infomaniak.ch ([128.65.195.4]:38733 "EHLO
        smtp-sh.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728321AbfKDRhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 12:37:25 -0500
X-Greylist: delayed 843 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Nov 2019 12:37:07 EST
Received: from smtp-3-0001.mail.infomaniak.ch ([10.4.36.108])
        by smtp-sh.infomaniak.ch (8.14.5/8.14.5) with ESMTP id xA4HM1sF005141
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 4 Nov 2019 18:22:01 +0100
Received: from localhost (unknown [94.23.54.103])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id AE0A7100ABF7E;
        Mon,  4 Nov 2019 18:21:58 +0100 (CET)
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
Subject: [PATCH bpf-next v13 1/7] bpf,landlock: Define an eBPF program type for Landlock hooks
Date:   Mon,  4 Nov 2019 18:21:40 +0100
Message-Id: <20191104172146.30797-2-mic@digikod.net>
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

Add a new type of eBPF program used by Landlock hooks.  The goal of this
type of program is to accept or deny a requested access from userspace
to a kernel object (e.g. ptrace a process).  This will be more useful
with the next commit adding a new eBPF helper.

The context of this program type contains two items of type PTR_TO_TASK,
one for the tracer and one for the tracee.  The underlying kernel
structure is currently a task_struct pointer, but it could seamlessly
evolve to a task wrapper with dedicated rights (i.e.  capability-based
security) to fit with different use cases (e.g. get and log the task's
PID).

This new BPF program type will be registered with the Landlock LSM
initialization.

Add an initial Landlock Kconfig and update the MAINTAINERS file.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: James Morris <jmorris@namei.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: Will Drewry <wad@chromium.org>
---

Changes since v10:
* replace file system program types with a (simpler) ptrace program type
* add an eBPF task pointer type
* split files

Changes since v9:
* handle inode put and map put, which fix unmount (reported by Al Viro)
* replace subtype with expected_attach_type and expected_attach_triggers
* check eBPF program return code

Changes since v8:
* Remove the chaining concept from the eBPF program contexts (chain and
  cookie). We need to keep these subtypes this way to be able to make
  them evolve, though.
* remove bpf_landlock_put_extra() because there is no more a "previous"
  field to free (for now)

Changes since v7:
* cosmetic fixes
* rename LANDLOCK_SUBTYPE_* to LANDLOCK_*
* cleanup UAPI definitions and move them from bpf.h to landlock.h
  (suggested by Alexei Starovoitov)
* disable Landlock by default (suggested by Alexei Starovoitov)
* rename BPF_PROG_TYPE_LANDLOCK_{RULE,HOOK}
* update the Kconfig
* update the MAINTAINERS file
* replace the IOCTL, LOCK and FCNTL events with FS_PICK, FS_WALK and
  FS_GET hook types
* add the ability to chain programs with an eBPF program file descriptor
  (i.e. the "previous" field in a Landlock subtype) and keep a state
  with a "cookie" value available from the context
* add a "triggers" subtype bitfield to match specific actions (e.g.
  append, chdir, read...)

Changes since v6:
* add 3 more sub-events: IOCTL, LOCK, FCNTL
  https://lkml.kernel.org/r/2fbc99a6-f190-f335-bd14-04bdeed35571@digikod.net
* rename LANDLOCK_VERSION to LANDLOCK_ABI to better reflect its purpose,
  and move it from landlock.h to common.h
* rename BPF_PROG_TYPE_LANDLOCK to BPF_PROG_TYPE_LANDLOCK_RULE: an eBPF
  program could be used for something else than a rule
* simplify struct landlock_context by removing the arch and syscall_nr fields
* remove all eBPF map functions call, remove ABILITY_WRITE
* refactor bpf_landlock_func_proto() (suggested by Kees Cook)
* constify pointers
* fix doc inclusion

Changes since v5:
* rename file hooks.c to init.c
* fix spelling

Changes since v4:
* merge a minimal (not enabled) LSM code and Kconfig in this commit

Changes since v3:
* split commit
* revamp the landlock_context:
  * add arch, syscall_nr and syscall_cmd (ioctl, fcntl…) to be able to
    cross-check action with the event type
  * replace args array with dedicated fields to ease the addition of new
    fields
---
 MAINTAINERS                    |  8 ++++
 include/linux/bpf.h            |  1 +
 include/linux/bpf_types.h      |  3 ++
 include/uapi/linux/bpf.h       |  2 +
 include/uapi/linux/landlock.h  | 39 ++++++++++++++++
 kernel/bpf/syscall.c           |  9 ++++
 kernel/bpf/verifier.c          |  7 +++
 security/Kconfig               |  1 +
 security/Makefile              |  2 +
 security/landlock/Kconfig      | 19 ++++++++
 security/landlock/Makefile     |  4 ++
 security/landlock/bpf_ptrace.c | 30 ++++++++++++
 security/landlock/bpf_ptrace.h | 17 +++++++
 security/landlock/bpf_verify.c | 83 ++++++++++++++++++++++++++++++++++
 security/landlock/common.h     | 30 ++++++++++++
 15 files changed, 255 insertions(+)
 create mode 100644 include/uapi/linux/landlock.h
 create mode 100644 security/landlock/Kconfig
 create mode 100644 security/landlock/Makefile
 create mode 100644 security/landlock/bpf_ptrace.c
 create mode 100644 security/landlock/bpf_ptrace.h
 create mode 100644 security/landlock/bpf_verify.c
 create mode 100644 security/landlock/common.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 7fc074632eac..4cabb85ea52d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9146,6 +9146,14 @@ F:	net/core/skmsg.c
 F:	net/core/sock_map.c
 F:	net/ipv4/tcp_bpf.c
 
+LANDLOCK SECURITY MODULE
+M:	Mickaël Salaün <mic@digikod.net>
+S:	Supported
+F:	include/uapi/linux/landlock.h
+F:	security/landlock/
+K:	landlock
+K:	LANDLOCK
+
 LANTIQ / INTEL Ethernet drivers
 M:	Hauke Mehrtens <hauke@hauke-m.de>
 L:	netdev@vger.kernel.org
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 171be30fe0ae..819a3e207438 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -291,6 +291,7 @@ enum bpf_reg_type {
 	PTR_TO_TP_BUFFER,	 /* reg points to a writable raw tp's buffer */
 	PTR_TO_XDP_SOCK,	 /* reg points to struct xdp_sock */
 	PTR_TO_BTF_ID,		 /* reg points to kernel struct */
+	PTR_TO_TASK,		 /* reg points to struct task_struct */
 };
 
 /* The information passed from prog-specific *_is_valid_access
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 36a9c2325176..bddabc961a3b 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -38,6 +38,9 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_LIRC_MODE2, lirc_mode2)
 #ifdef CONFIG_INET
 BPF_PROG_TYPE(BPF_PROG_TYPE_SK_REUSEPORT, sk_reuseport)
 #endif
+#ifdef CONFIG_SECURITY_LANDLOCK
+BPF_PROG_TYPE(BPF_PROG_TYPE_LANDLOCK_HOOK, landlock)
+#endif
 
 BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_ARRAY, percpu_array_map_ops)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4af8b0819a32..6e4147790f96 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
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
 
diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.h
new file mode 100644
index 000000000000..3ffe3cbdbad6
--- /dev/null
+++ b/include/uapi/linux/landlock.h
@@ -0,0 +1,39 @@
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
+/**
+ * DOC: landlock_ret
+ *
+ * The return value of a landlock program is a bitmask that can allow or deny
+ * the action for which the program is run.
+ *
+ * In the future, this could be used to trigger an audit event as well.
+ *
+ * - %LANDLOCK_RET_ALLOW
+ * - %LANDLOCK_RET_DENY
+ */
+#define LANDLOCK_RET_ALLOW	0
+#define LANDLOCK_RET_DENY	1
+
+/**
+ * struct landlock_context_ptrace - context accessible to BPF_LANDLOCK_PTRACE
+ *
+ * @tracer: pointer to the task requesting to debug @tracee
+ * @tracee: pointer to the task being debugged
+ */
+struct landlock_context_ptrace {
+	__u64 tracer;
+	__u64 tracee;
+};
+
+#endif /* _UAPI__LINUX_LANDLOCK_H__ */
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index ff5225759553..5159e582a0d8 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1621,6 +1621,15 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
 		default:
 			return -EINVAL;
 		}
+#ifdef CONFIG_SECURITY_LANDLOCK
+	case BPF_PROG_TYPE_LANDLOCK_HOOK:
+		switch (expected_attach_type) {
+		case BPF_LANDLOCK_PTRACE:
+			return 0;
+		default:
+			return -EINVAL;
+		}
+#endif
 	default:
 		return 0;
 	}
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c59778c0fc4d..ebf1991906b7 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -421,6 +421,7 @@ static const char * const reg_type_str[] = {
 	[PTR_TO_TP_BUFFER]	= "tp_buffer",
 	[PTR_TO_XDP_SOCK]	= "xdp_sock",
 	[PTR_TO_BTF_ID]		= "ptr_",
+	[PTR_TO_TASK]		= "task",
 };
 
 static char slot_type_char[] = {
@@ -1878,6 +1879,7 @@ static bool is_spillable_regtype(enum bpf_reg_type type)
 	case PTR_TO_TCP_SOCK:
 	case PTR_TO_TCP_SOCK_OR_NULL:
 	case PTR_TO_XDP_SOCK:
+	case PTR_TO_TASK:
 		return true;
 	default:
 		return false;
@@ -2600,6 +2602,9 @@ static int check_ptr_alignment(struct bpf_verifier_env *env,
 	case PTR_TO_XDP_SOCK:
 		pointer_desc = "xdp_sock ";
 		break;
+	case PTR_TO_TASK:
+		pointer_desc = "task ";
+		break;
 	default:
 		break;
 	}
@@ -4527,6 +4532,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 	case PTR_TO_TCP_SOCK:
 	case PTR_TO_TCP_SOCK_OR_NULL:
 	case PTR_TO_XDP_SOCK:
+	case PTR_TO_TASK:
 		verbose(env, "R%d pointer arithmetic on %s prohibited\n",
 			dst, reg_type_str[ptr_reg->type]);
 		return -EACCES;
@@ -6278,6 +6284,7 @@ static int check_return_code(struct bpf_verifier_env *env)
 	case BPF_PROG_TYPE_CGROUP_DEVICE:
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
 	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
+	case BPF_PROG_TYPE_LANDLOCK_HOOK:
 		break;
 	default:
 		return 0;
diff --git a/security/Kconfig b/security/Kconfig
index 2a1a2d396228..9d9981394fb0 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -238,6 +238,7 @@ source "security/loadpin/Kconfig"
 source "security/yama/Kconfig"
 source "security/safesetid/Kconfig"
 source "security/lockdown/Kconfig"
+source "security/landlock/Kconfig"
 
 source "security/integrity/Kconfig"
 
diff --git a/security/Makefile b/security/Makefile
index be1dd9d2cb2f..60b7f6f2fd30 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -12,6 +12,7 @@ subdir-$(CONFIG_SECURITY_YAMA)		+= yama
 subdir-$(CONFIG_SECURITY_LOADPIN)	+= loadpin
 subdir-$(CONFIG_SECURITY_SAFESETID)    += safesetid
 subdir-$(CONFIG_SECURITY_LOCKDOWN_LSM)	+= lockdown
+subdir-$(CONFIG_SECURITY_LANDLOCK)		+= landlock
 
 # always enable default capabilities
 obj-y					+= commoncap.o
@@ -29,6 +30,7 @@ obj-$(CONFIG_SECURITY_YAMA)		+= yama/
 obj-$(CONFIG_SECURITY_LOADPIN)		+= loadpin/
 obj-$(CONFIG_SECURITY_SAFESETID)       += safesetid/
 obj-$(CONFIG_SECURITY_LOCKDOWN_LSM)	+= lockdown/
+obj-$(CONFIG_SECURITY_LANDLOCK)	+= landlock/
 obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
 
 # Object integrity file lists
diff --git a/security/landlock/Kconfig b/security/landlock/Kconfig
new file mode 100644
index 000000000000..44921bd72380
--- /dev/null
+++ b/security/landlock/Kconfig
@@ -0,0 +1,19 @@
+config SECURITY_LANDLOCK
+	bool "Landlock support"
+	depends on SECURITY
+	depends on BPF_SYSCALL
+	depends on SECCOMP_FILTER
+	default n
+	help
+	  This selects Landlock, a programmatic access control.  It enables to
+	  restrict processes on the fly (i.e. create a sandbox) or log some
+	  actions.  The security policy is a set of eBPF programs, dedicated to
+	  allow or deny a list of actions on specific kernel objects (e.g.
+	  process).
+
+	  You need to enable seccomp filter to apply a security policy to a
+	  process hierarchy (e.g. application with built-in sandboxing).
+
+	  See Documentation/security/landlock/ for further information.
+
+	  If you are unsure how to answer this question, answer N.
diff --git a/security/landlock/Makefile b/security/landlock/Makefile
new file mode 100644
index 000000000000..682b798c6b76
--- /dev/null
+++ b/security/landlock/Makefile
@@ -0,0 +1,4 @@
+obj-$(CONFIG_SECURITY_LANDLOCK) := landlock.o
+
+landlock-y := \
+	bpf_verify.o bpf_ptrace.o
diff --git a/security/landlock/bpf_ptrace.c b/security/landlock/bpf_ptrace.c
new file mode 100644
index 000000000000..2ec73078ad01
--- /dev/null
+++ b/security/landlock/bpf_ptrace.c
@@ -0,0 +1,30 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Landlock LSM - eBPF ptrace
+ *
+ * Copyright © 2017-2019 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2019 ANSSI
+ */
+
+#include <linux/bpf.h>
+#include <uapi/linux/landlock.h>
+
+#include "bpf_ptrace.h"
+
+bool landlock_is_valid_access_ptrace(int off, enum bpf_access_type type,
+		enum bpf_reg_type *reg_type, int *max_size)
+{
+	if (type != BPF_READ)
+		return false;
+
+	switch (off) {
+	case offsetof(struct landlock_context_ptrace, tracer):
+		/* fall through */
+	case offsetof(struct landlock_context_ptrace, tracee):
+		*reg_type = PTR_TO_TASK;
+		*max_size = sizeof(u64);
+		return true;
+	default:
+		return false;
+	}
+}
diff --git a/security/landlock/bpf_ptrace.h b/security/landlock/bpf_ptrace.h
new file mode 100644
index 000000000000..85edce37b70a
--- /dev/null
+++ b/security/landlock/bpf_ptrace.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Landlock LSM - eBPF ptrace headers
+ *
+ * Copyright © 2017-2019 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2019 ANSSI
+ */
+
+#ifndef _SECURITY_LANDLOCK_BPF_PTRACE_H
+#define _SECURITY_LANDLOCK_BPF_PTRACE_H
+
+#include <linux/bpf.h>
+
+bool landlock_is_valid_access_ptrace(int off, enum bpf_access_type type,
+		enum bpf_reg_type *reg_type, int *max_size);
+
+#endif /* _SECURITY_LANDLOCK_BPF_PTRACE_H */
diff --git a/security/landlock/bpf_verify.c b/security/landlock/bpf_verify.c
new file mode 100644
index 000000000000..6ed921588178
--- /dev/null
+++ b/security/landlock/bpf_verify.c
@@ -0,0 +1,83 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Landlock LSM - eBPF program verifications
+ *
+ * Copyright © 2016-2019 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2018-2019 ANSSI
+ */
+
+#include <linux/bpf.h>
+#include <linux/filter.h>
+
+#include "common.h"
+#include "bpf_ptrace.h"
+
+static bool bpf_landlock_is_valid_access(int off, int size,
+		enum bpf_access_type type, const struct bpf_prog *prog,
+		struct bpf_insn_access_aux *info)
+{
+	enum bpf_reg_type reg_type = NOT_INIT;
+	int max_size = 0;
+
+	if (WARN_ON(!prog->expected_attach_type))
+		return false;
+
+	if (off < 0)
+		return false;
+	if (size <= 0 || size > sizeof(__u64))
+		return false;
+
+	/* set register type and max size */
+	switch (get_hook_type(prog)) {
+	case LANDLOCK_HOOK_PTRACE:
+		if (!landlock_is_valid_access_ptrace(off, type, &reg_type,
+					&max_size))
+			return false;
+		break;
+	}
+
+	/* check memory range access */
+	switch (reg_type) {
+	case NOT_INIT:
+		return false;
+	case SCALAR_VALUE:
+		/* allow partial raw value */
+		if (size > max_size)
+			return false;
+		info->ctx_field_size = max_size;
+		break;
+	default:
+		/* deny partial pointer */
+		if (size != max_size)
+			return false;
+	}
+
+	info->reg_type = reg_type;
+	return true;
+}
+
+static const struct bpf_func_proto *bpf_landlock_func_proto(
+		enum bpf_func_id func_id,
+		const struct bpf_prog *prog)
+{
+	if (WARN_ON(!prog->expected_attach_type))
+		return NULL;
+
+	switch (func_id) {
+	case BPF_FUNC_map_lookup_elem:
+		return &bpf_map_lookup_elem_proto;
+	case BPF_FUNC_map_update_elem:
+		return &bpf_map_update_elem_proto;
+	case BPF_FUNC_map_delete_elem:
+		return &bpf_map_delete_elem_proto;
+	default:
+		return NULL;
+	}
+}
+
+const struct bpf_verifier_ops landlock_verifier_ops = {
+	.get_func_proto	= bpf_landlock_func_proto,
+	.is_valid_access = bpf_landlock_is_valid_access,
+};
+
+const struct bpf_prog_ops landlock_prog_ops = {};
diff --git a/security/landlock/common.h b/security/landlock/common.h
new file mode 100644
index 000000000000..0234c4bc4acd
--- /dev/null
+++ b/security/landlock/common.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Landlock LSM - private headers
+ *
+ * Copyright © 2016-2019 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2018-2019 ANSSI
+ */
+
+#ifndef _SECURITY_LANDLOCK_COMMON_H
+#define _SECURITY_LANDLOCK_COMMON_H
+
+#include <linux/bpf.h>
+#include <linux/filter.h>
+
+enum landlock_hook_type {
+	LANDLOCK_HOOK_PTRACE = 1,
+};
+
+static inline enum landlock_hook_type get_hook_type(const struct bpf_prog *prog)
+{
+	switch (prog->expected_attach_type) {
+	case BPF_LANDLOCK_PTRACE:
+		return LANDLOCK_HOOK_PTRACE;
+	default:
+		WARN_ON(1);
+		return BPF_LANDLOCK_PTRACE;
+	}
+}
+
+#endif /* _SECURITY_LANDLOCK_COMMON_H */
-- 
2.23.0

