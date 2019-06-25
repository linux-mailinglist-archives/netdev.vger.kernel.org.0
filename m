Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8041655AB1
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 00:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbfFYWMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 18:12:55 -0400
Received: from smtp-sh.infomaniak.ch ([128.65.195.4]:34555 "EHLO
        smtp-sh.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfFYWMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 18:12:55 -0400
Received: from smtp5.infomaniak.ch (smtp5.infomaniak.ch [83.166.132.18])
        by smtp-sh.infomaniak.ch (8.14.5/8.14.5) with ESMTP id x5PLrJZ1019802
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jun 2019 23:53:19 +0200
Received: from localhost (ns3096276.ip-94-23-54.eu [94.23.54.103])
        (authenticated bits=0)
        by smtp5.infomaniak.ch (8.14.5/8.14.5) with ESMTP id x5PLrIHg038697;
        Tue, 25 Jun 2019 23:53:19 +0200
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
Subject: [PATCH bpf-next v9 03/10] bpf,landlock: Define an eBPF program type for Landlock hooks
Date:   Tue, 25 Jun 2019 23:52:32 +0200
Message-Id: <20190625215239.11136-4-mic@digikod.net>
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

Add a new type of eBPF program used by Landlock hooks. This type of
program can be chained with the same eBPF program type (according to
subtype rules). A state can be kept with a value available in the
program's context (e.g. named "cookie" for Landlock programs).

This new BPF program type will be registered with the Landlock LSM
initialization.

Add an initial Landlock Kconfig and update the MAINTAINERS file.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: James Morris <jmorris@namei.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Serge E. Hallyn <serge@hallyn.com>
---

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
 MAINTAINERS                         |  13 ++++
 include/linux/bpf_types.h           |   3 +
 include/uapi/linux/bpf.h            |   1 +
 include/uapi/linux/landlock.h       | 109 +++++++++++++++++++++++++++
 security/Kconfig                    |   1 +
 security/Makefile                   |   2 +
 security/landlock/Kconfig           |  18 +++++
 security/landlock/Makefile          |   3 +
 security/landlock/common.h          |  26 +++++++
 security/landlock/init.c            | 110 ++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h      |   1 +
 tools/include/uapi/linux/landlock.h | 109 +++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.c              |   1 +
 tools/lib/bpf/libbpf_probes.c       |   1 +
 14 files changed, 398 insertions(+)
 create mode 100644 include/uapi/linux/landlock.h
 create mode 100644 security/landlock/Kconfig
 create mode 100644 security/landlock/Makefile
 create mode 100644 security/landlock/common.h
 create mode 100644 security/landlock/init.c
 create mode 100644 tools/include/uapi/linux/landlock.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 606d1f80bc49..4a5edc14ee84 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8807,6 +8807,19 @@ F:	net/core/skmsg.c
 F:	net/core/sock_map.c
 F:	net/ipv4/tcp_bpf.c
 
+LANDLOCK SECURITY MODULE
+M:	Mickaël Salaün <mic@digikod.net>
+S:	Supported
+F:	Documentation/security/landlock/
+F:	include/linux/landlock.h
+F:	include/uapi/linux/landlock.h
+F:	samples/bpf/landlock*
+F:	security/landlock/
+F:	tools/include/uapi/linux/landlock.h
+F:	tools/testing/selftests/landlock/
+K:	landlock
+K:	LANDLOCK
+
 LANTIQ / INTEL Ethernet drivers
 M:	Hauke Mehrtens <hauke@hauke-m.de>
 L:	netdev@vger.kernel.org
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 5a9975678d6f..dee8b82e31b1 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -37,6 +37,9 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_LIRC_MODE2, lirc_mode2)
 #ifdef CONFIG_INET
 BPF_PROG_TYPE(BPF_PROG_TYPE_SK_REUSEPORT, sk_reuseport)
 #endif
+#ifdef CONFIG_SECURITY_LANDLOCK
+BPF_PROG_TYPE(BPF_PROG_TYPE_LANDLOCK_HOOK, landlock)
+#endif
 
 BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_ARRAY, percpu_array_map_ops)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index ddae50373d58..50145d448bc3 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -170,6 +170,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_FLOW_DISSECTOR,
 	BPF_PROG_TYPE_CGROUP_SYSCTL,
 	BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE,
+	BPF_PROG_TYPE_LANDLOCK_HOOK,
 };
 
 enum bpf_attach_type {
diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.h
new file mode 100644
index 000000000000..9e6d8e10ec2c
--- /dev/null
+++ b/include/uapi/linux/landlock.h
@@ -0,0 +1,109 @@
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
+/**
+ * enum landlock_hook_type - hook type for which a Landlock program is called
+ *
+ * A hook is a policy decision point which exposes the same context type for
+ * each program evaluation.
+ *
+ * @LANDLOCK_HOOK_FS_PICK: called for the last element of a file path
+ * @LANDLOCK_HOOK_FS_WALK: called for each directory of a file path (excluding
+ *			   the directory passed to fs_pick, if any)
+ */
+enum landlock_hook_type {
+	LANDLOCK_HOOK_FS_PICK = 1,
+	LANDLOCK_HOOK_FS_WALK,
+};
+
+/**
+ * DOC: landlock_triggers
+ *
+ * A landlock trigger is used as a bitmask in subtype.landlock_hook.triggers
+ * for a fs_pick program.  It defines a set of actions for which the program
+ * should verify an access request.
+ *
+ * - %LANDLOCK_TRIGGER_FS_PICK_APPEND
+ * - %LANDLOCK_TRIGGER_FS_PICK_CHDIR
+ * - %LANDLOCK_TRIGGER_FS_PICK_CHROOT
+ * - %LANDLOCK_TRIGGER_FS_PICK_CREATE
+ * - %LANDLOCK_TRIGGER_FS_PICK_EXECUTE
+ * - %LANDLOCK_TRIGGER_FS_PICK_FCNTL
+ * - %LANDLOCK_TRIGGER_FS_PICK_GETATTR
+ * - %LANDLOCK_TRIGGER_FS_PICK_IOCTL
+ * - %LANDLOCK_TRIGGER_FS_PICK_LINK
+ * - %LANDLOCK_TRIGGER_FS_PICK_LINKTO
+ * - %LANDLOCK_TRIGGER_FS_PICK_LOCK
+ * - %LANDLOCK_TRIGGER_FS_PICK_MAP
+ * - %LANDLOCK_TRIGGER_FS_PICK_MOUNTON
+ * - %LANDLOCK_TRIGGER_FS_PICK_OPEN
+ * - %LANDLOCK_TRIGGER_FS_PICK_READ
+ * - %LANDLOCK_TRIGGER_FS_PICK_READDIR
+ * - %LANDLOCK_TRIGGER_FS_PICK_RECEIVE
+ * - %LANDLOCK_TRIGGER_FS_PICK_RENAME
+ * - %LANDLOCK_TRIGGER_FS_PICK_RENAMETO
+ * - %LANDLOCK_TRIGGER_FS_PICK_RMDIR
+ * - %LANDLOCK_TRIGGER_FS_PICK_SETATTR
+ * - %LANDLOCK_TRIGGER_FS_PICK_TRANSFER
+ * - %LANDLOCK_TRIGGER_FS_PICK_UNLINK
+ * - %LANDLOCK_TRIGGER_FS_PICK_WRITE
+ */
+#define LANDLOCK_TRIGGER_FS_PICK_APPEND			(1ULL << 0)
+#define LANDLOCK_TRIGGER_FS_PICK_CHDIR			(1ULL << 1)
+#define LANDLOCK_TRIGGER_FS_PICK_CHROOT			(1ULL << 2)
+#define LANDLOCK_TRIGGER_FS_PICK_CREATE			(1ULL << 3)
+#define LANDLOCK_TRIGGER_FS_PICK_EXECUTE		(1ULL << 4)
+#define LANDLOCK_TRIGGER_FS_PICK_FCNTL			(1ULL << 5)
+#define LANDLOCK_TRIGGER_FS_PICK_GETATTR		(1ULL << 6)
+#define LANDLOCK_TRIGGER_FS_PICK_IOCTL			(1ULL << 7)
+#define LANDLOCK_TRIGGER_FS_PICK_LINK			(1ULL << 8)
+#define LANDLOCK_TRIGGER_FS_PICK_LINKTO			(1ULL << 9)
+#define LANDLOCK_TRIGGER_FS_PICK_LOCK			(1ULL << 10)
+#define LANDLOCK_TRIGGER_FS_PICK_MAP			(1ULL << 11)
+#define LANDLOCK_TRIGGER_FS_PICK_MOUNTON		(1ULL << 12)
+#define LANDLOCK_TRIGGER_FS_PICK_OPEN			(1ULL << 13)
+#define LANDLOCK_TRIGGER_FS_PICK_READ			(1ULL << 14)
+#define LANDLOCK_TRIGGER_FS_PICK_READDIR		(1ULL << 15)
+#define LANDLOCK_TRIGGER_FS_PICK_RECEIVE		(1ULL << 16)
+#define LANDLOCK_TRIGGER_FS_PICK_RENAME			(1ULL << 17)
+#define LANDLOCK_TRIGGER_FS_PICK_RENAMETO		(1ULL << 18)
+#define LANDLOCK_TRIGGER_FS_PICK_RMDIR			(1ULL << 19)
+#define LANDLOCK_TRIGGER_FS_PICK_SETATTR		(1ULL << 20)
+#define LANDLOCK_TRIGGER_FS_PICK_TRANSFER		(1ULL << 21)
+#define LANDLOCK_TRIGGER_FS_PICK_UNLINK			(1ULL << 22)
+#define LANDLOCK_TRIGGER_FS_PICK_WRITE			(1ULL << 23)
+
+/**
+ * struct landlock_ctx_fs_pick - context accessible to a fs_pick program
+ *
+ * @inode: pointer to the current kernel object that can be used to compare
+ *         inodes from an inode map.
+ */
+struct landlock_ctx_fs_pick {
+	__u64 inode;
+};
+
+/**
+ * struct landlock_ctx_fs_walk - context accessible to a fs_walk program
+ *
+ * @inode: pointer to the current kernel object that can be used to compare
+ *         inodes from an inode map.
+ */
+struct landlock_ctx_fs_walk {
+	__u64 inode;
+};
+
+#endif /* _UAPI__LINUX_LANDLOCK_H__ */
diff --git a/security/Kconfig b/security/Kconfig
index 466cc1f8ffed..d3c070a01470 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -237,6 +237,7 @@ source "security/apparmor/Kconfig"
 source "security/loadpin/Kconfig"
 source "security/yama/Kconfig"
 source "security/safesetid/Kconfig"
+source "security/landlock/Kconfig"
 
 source "security/integrity/Kconfig"
 
diff --git a/security/Makefile b/security/Makefile
index c598b904938f..396ff107f70d 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -11,6 +11,7 @@ subdir-$(CONFIG_SECURITY_APPARMOR)	+= apparmor
 subdir-$(CONFIG_SECURITY_YAMA)		+= yama
 subdir-$(CONFIG_SECURITY_LOADPIN)	+= loadpin
 subdir-$(CONFIG_SECURITY_SAFESETID)    += safesetid
+subdir-$(CONFIG_SECURITY_LANDLOCK)		+= landlock
 
 # always enable default capabilities
 obj-y					+= commoncap.o
@@ -27,6 +28,7 @@ obj-$(CONFIG_SECURITY_APPARMOR)		+= apparmor/
 obj-$(CONFIG_SECURITY_YAMA)		+= yama/
 obj-$(CONFIG_SECURITY_LOADPIN)		+= loadpin/
 obj-$(CONFIG_SECURITY_SAFESETID)       += safesetid/
+obj-$(CONFIG_SECURITY_LANDLOCK)	+= landlock/
 obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
 
 # Object integrity file lists
diff --git a/security/landlock/Kconfig b/security/landlock/Kconfig
new file mode 100644
index 000000000000..8bd103102008
--- /dev/null
+++ b/security/landlock/Kconfig
@@ -0,0 +1,18 @@
+config SECURITY_LANDLOCK
+	bool "Landlock support"
+	depends on SECURITY
+	depends on BPF_SYSCALL
+	depends on SECCOMP_FILTER
+	default n
+	help
+	  This selects Landlock, a programmatic access control.  It enables to
+	  restrict processes on the fly (i.e. create a sandbox).  The security
+	  policy is a set of eBPF programs, dedicated to deny a list of actions
+	  on specific kernel objects (e.g. file).
+
+	  You need to enable seccomp filter to apply a security policy to a
+	  process hierarchy (e.g. application with built-in sandboxing).
+
+	  See Documentation/security/landlock/ for further information.
+
+	  If you are unsure how to answer this question, answer N.
diff --git a/security/landlock/Makefile b/security/landlock/Makefile
new file mode 100644
index 000000000000..7205f9a7a2ee
--- /dev/null
+++ b/security/landlock/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_SECURITY_LANDLOCK) := landlock.o
+
+landlock-y := init.o
diff --git a/security/landlock/common.h b/security/landlock/common.h
new file mode 100644
index 000000000000..fd63ed1592a7
--- /dev/null
+++ b/security/landlock/common.h
@@ -0,0 +1,26 @@
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
+#include <linux/bpf.h> /* enum bpf_prog_aux */
+#include <linux/filter.h> /* bpf_prog */
+#include <linux/refcount.h> /* refcount_t */
+#include <uapi/linux/landlock.h> /* enum landlock_hook_type */
+
+#define LANDLOCK_NAME "landlock"
+
+/* UAPI bounds and bitmasks */
+
+#define _LANDLOCK_HOOK_LAST LANDLOCK_HOOK_FS_WALK
+
+#define _LANDLOCK_TRIGGER_FS_PICK_LAST	LANDLOCK_TRIGGER_FS_PICK_WRITE
+#define _LANDLOCK_TRIGGER_FS_PICK_MASK	((_LANDLOCK_TRIGGER_FS_PICK_LAST << 1ULL) - 1)
+
+#endif /* _SECURITY_LANDLOCK_COMMON_H */
diff --git a/security/landlock/init.c b/security/landlock/init.c
new file mode 100644
index 000000000000..03073cd0fc4e
--- /dev/null
+++ b/security/landlock/init.c
@@ -0,0 +1,110 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Landlock LSM - init
+ *
+ * Copyright © 2016-2019 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2018-2019 ANSSI
+ */
+
+#include <linux/bpf.h> /* enum bpf_access_type */
+#include <linux/capability.h> /* capable */
+#include <linux/filter.h> /* struct bpf_prog */
+
+#include "common.h" /* LANDLOCK_* */
+
+static bool bpf_landlock_is_valid_access(int off, int size,
+		enum bpf_access_type type, const struct bpf_prog *prog,
+		struct bpf_insn_access_aux *info)
+{
+	const union bpf_prog_subtype *prog_subtype;
+	enum bpf_reg_type reg_type = NOT_INIT;
+	int max_size = 0;
+
+	if (WARN_ON(!prog->aux->extra))
+		return false;
+	prog_subtype = &prog->aux->extra->subtype;
+
+	if (off < 0)
+		return false;
+	if (size <= 0 || size > sizeof(__u64))
+		return false;
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
+static bool bpf_landlock_is_valid_subtype(struct bpf_prog_extra *prog_extra)
+{
+	const union bpf_prog_subtype *subtype;
+
+	if (!prog_extra)
+		return false;
+	subtype = &prog_extra->subtype;
+
+	switch (subtype->landlock_hook.type) {
+	case LANDLOCK_HOOK_FS_PICK:
+		if (!subtype->landlock_hook.triggers ||
+				subtype->landlock_hook.triggers &
+				~_LANDLOCK_TRIGGER_FS_PICK_MASK)
+			return false;
+		break;
+	case LANDLOCK_HOOK_FS_WALK:
+		if (subtype->landlock_hook.triggers)
+			return false;
+		break;
+	default:
+		return false;
+	}
+
+	return true;
+}
+
+static const struct bpf_func_proto *bpf_landlock_func_proto(
+		enum bpf_func_id func_id,
+		const struct bpf_prog *prog)
+{
+	u64 hook_type;
+
+	if (WARN_ON(!prog->aux->extra))
+		return NULL;
+	hook_type = prog->aux->extra->subtype.landlock_hook.type;
+
+	/* generic functions */
+	/* TODO: do we need/want update/delete functions for every LL prog?
+	 * => impurity vs. audit */
+	switch (func_id) {
+	case BPF_FUNC_map_lookup_elem:
+		return &bpf_map_lookup_elem_proto;
+	case BPF_FUNC_map_update_elem:
+		return &bpf_map_update_elem_proto;
+	case BPF_FUNC_map_delete_elem:
+		return &bpf_map_delete_elem_proto;
+	default:
+		break;
+	}
+	return NULL;
+}
+
+const struct bpf_verifier_ops landlock_verifier_ops = {
+	.get_func_proto	= bpf_landlock_func_proto,
+	.is_valid_access = bpf_landlock_is_valid_access,
+	.is_valid_subtype = bpf_landlock_is_valid_subtype,
+};
+
+const struct bpf_prog_ops landlock_prog_ops = {};
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index ddae50373d58..50145d448bc3 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -170,6 +170,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_FLOW_DISSECTOR,
 	BPF_PROG_TYPE_CGROUP_SYSCTL,
 	BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE,
+	BPF_PROG_TYPE_LANDLOCK_HOOK,
 };
 
 enum bpf_attach_type {
diff --git a/tools/include/uapi/linux/landlock.h b/tools/include/uapi/linux/landlock.h
new file mode 100644
index 000000000000..9e6d8e10ec2c
--- /dev/null
+++ b/tools/include/uapi/linux/landlock.h
@@ -0,0 +1,109 @@
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
+/**
+ * enum landlock_hook_type - hook type for which a Landlock program is called
+ *
+ * A hook is a policy decision point which exposes the same context type for
+ * each program evaluation.
+ *
+ * @LANDLOCK_HOOK_FS_PICK: called for the last element of a file path
+ * @LANDLOCK_HOOK_FS_WALK: called for each directory of a file path (excluding
+ *			   the directory passed to fs_pick, if any)
+ */
+enum landlock_hook_type {
+	LANDLOCK_HOOK_FS_PICK = 1,
+	LANDLOCK_HOOK_FS_WALK,
+};
+
+/**
+ * DOC: landlock_triggers
+ *
+ * A landlock trigger is used as a bitmask in subtype.landlock_hook.triggers
+ * for a fs_pick program.  It defines a set of actions for which the program
+ * should verify an access request.
+ *
+ * - %LANDLOCK_TRIGGER_FS_PICK_APPEND
+ * - %LANDLOCK_TRIGGER_FS_PICK_CHDIR
+ * - %LANDLOCK_TRIGGER_FS_PICK_CHROOT
+ * - %LANDLOCK_TRIGGER_FS_PICK_CREATE
+ * - %LANDLOCK_TRIGGER_FS_PICK_EXECUTE
+ * - %LANDLOCK_TRIGGER_FS_PICK_FCNTL
+ * - %LANDLOCK_TRIGGER_FS_PICK_GETATTR
+ * - %LANDLOCK_TRIGGER_FS_PICK_IOCTL
+ * - %LANDLOCK_TRIGGER_FS_PICK_LINK
+ * - %LANDLOCK_TRIGGER_FS_PICK_LINKTO
+ * - %LANDLOCK_TRIGGER_FS_PICK_LOCK
+ * - %LANDLOCK_TRIGGER_FS_PICK_MAP
+ * - %LANDLOCK_TRIGGER_FS_PICK_MOUNTON
+ * - %LANDLOCK_TRIGGER_FS_PICK_OPEN
+ * - %LANDLOCK_TRIGGER_FS_PICK_READ
+ * - %LANDLOCK_TRIGGER_FS_PICK_READDIR
+ * - %LANDLOCK_TRIGGER_FS_PICK_RECEIVE
+ * - %LANDLOCK_TRIGGER_FS_PICK_RENAME
+ * - %LANDLOCK_TRIGGER_FS_PICK_RENAMETO
+ * - %LANDLOCK_TRIGGER_FS_PICK_RMDIR
+ * - %LANDLOCK_TRIGGER_FS_PICK_SETATTR
+ * - %LANDLOCK_TRIGGER_FS_PICK_TRANSFER
+ * - %LANDLOCK_TRIGGER_FS_PICK_UNLINK
+ * - %LANDLOCK_TRIGGER_FS_PICK_WRITE
+ */
+#define LANDLOCK_TRIGGER_FS_PICK_APPEND			(1ULL << 0)
+#define LANDLOCK_TRIGGER_FS_PICK_CHDIR			(1ULL << 1)
+#define LANDLOCK_TRIGGER_FS_PICK_CHROOT			(1ULL << 2)
+#define LANDLOCK_TRIGGER_FS_PICK_CREATE			(1ULL << 3)
+#define LANDLOCK_TRIGGER_FS_PICK_EXECUTE		(1ULL << 4)
+#define LANDLOCK_TRIGGER_FS_PICK_FCNTL			(1ULL << 5)
+#define LANDLOCK_TRIGGER_FS_PICK_GETATTR		(1ULL << 6)
+#define LANDLOCK_TRIGGER_FS_PICK_IOCTL			(1ULL << 7)
+#define LANDLOCK_TRIGGER_FS_PICK_LINK			(1ULL << 8)
+#define LANDLOCK_TRIGGER_FS_PICK_LINKTO			(1ULL << 9)
+#define LANDLOCK_TRIGGER_FS_PICK_LOCK			(1ULL << 10)
+#define LANDLOCK_TRIGGER_FS_PICK_MAP			(1ULL << 11)
+#define LANDLOCK_TRIGGER_FS_PICK_MOUNTON		(1ULL << 12)
+#define LANDLOCK_TRIGGER_FS_PICK_OPEN			(1ULL << 13)
+#define LANDLOCK_TRIGGER_FS_PICK_READ			(1ULL << 14)
+#define LANDLOCK_TRIGGER_FS_PICK_READDIR		(1ULL << 15)
+#define LANDLOCK_TRIGGER_FS_PICK_RECEIVE		(1ULL << 16)
+#define LANDLOCK_TRIGGER_FS_PICK_RENAME			(1ULL << 17)
+#define LANDLOCK_TRIGGER_FS_PICK_RENAMETO		(1ULL << 18)
+#define LANDLOCK_TRIGGER_FS_PICK_RMDIR			(1ULL << 19)
+#define LANDLOCK_TRIGGER_FS_PICK_SETATTR		(1ULL << 20)
+#define LANDLOCK_TRIGGER_FS_PICK_TRANSFER		(1ULL << 21)
+#define LANDLOCK_TRIGGER_FS_PICK_UNLINK			(1ULL << 22)
+#define LANDLOCK_TRIGGER_FS_PICK_WRITE			(1ULL << 23)
+
+/**
+ * struct landlock_ctx_fs_pick - context accessible to a fs_pick program
+ *
+ * @inode: pointer to the current kernel object that can be used to compare
+ *         inodes from an inode map.
+ */
+struct landlock_ctx_fs_pick {
+	__u64 inode;
+};
+
+/**
+ * struct landlock_ctx_fs_walk - context accessible to a fs_walk program
+ *
+ * @inode: pointer to the current kernel object that can be used to compare
+ *         inodes from an inode map.
+ */
+struct landlock_ctx_fs_walk {
+	__u64 inode;
+};
+
+#endif /* _UAPI__LINUX_LANDLOCK_H__ */
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 68f45a96769f..1b99c8da7a67 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2646,6 +2646,7 @@ static bool bpf_prog_type__needs_kver(enum bpf_prog_type type)
 	case BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE:
 	case BPF_PROG_TYPE_PERF_EVENT:
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
+	case BPF_PROG_TYPE_LANDLOCK_HOOK:
 		return false;
 	case BPF_PROG_TYPE_KPROBE:
 	default:
diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
index 6635a31a7a16..f4f34cb8869a 100644
--- a/tools/lib/bpf/libbpf_probes.c
+++ b/tools/lib/bpf/libbpf_probes.c
@@ -101,6 +101,7 @@ probe_load(enum bpf_prog_type prog_type, const struct bpf_insn *insns,
 	case BPF_PROG_TYPE_SK_REUSEPORT:
 	case BPF_PROG_TYPE_FLOW_DISSECTOR:
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
+	case BPF_PROG_TYPE_LANDLOCK_HOOK:
 	default:
 		break;
 	}
-- 
2.20.1

