Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 850FF55A88
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 00:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfFYWD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 18:03:57 -0400
Received: from smtp-sh.infomaniak.ch ([128.65.195.4]:38457 "EHLO
        smtp-sh.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfFYWD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 18:03:57 -0400
Received: from smtp5.infomaniak.ch (smtp5.infomaniak.ch [83.166.132.18])
        by smtp-sh.infomaniak.ch (8.14.5/8.14.5) with ESMTP id x5PLrNIv019875
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jun 2019 23:53:23 +0200
Received: from localhost (ns3096276.ip-94-23-54.eu [94.23.54.103])
        (authenticated bits=0)
        by smtp5.infomaniak.ch (8.14.5/8.14.5) with ESMTP id x5PLrNLP038854;
        Tue, 25 Jun 2019 23:53:23 +0200
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
Subject: [PATCH bpf-next v9 07/10] landlock: Add ptrace restrictions
Date:   Tue, 25 Jun 2019 23:52:36 +0200
Message-Id: <20190625215239.11136-8-mic@digikod.net>
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

A landlocked process has less privileges than a non-landlocked process
and must then be subject to additional restrictions when manipulating
processes. To be allowed to use ptrace(2) and related syscalls on a
target process, a landlocked process must have a subset of the target
process' rules.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: James Morris <jmorris@namei.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Serge E. Hallyn <serge@hallyn.com>
---

Changes since v6:
* factor out ptrace check
* constify pointers
* cleanup headers
* use the new security_add_hooks()
---
 security/landlock/Makefile       |   2 +-
 security/landlock/hooks_ptrace.c | 121 +++++++++++++++++++++++++++++++
 security/landlock/hooks_ptrace.h |   8 ++
 security/landlock/init.c         |   2 +
 4 files changed, 132 insertions(+), 1 deletion(-)
 create mode 100644 security/landlock/hooks_ptrace.c
 create mode 100644 security/landlock/hooks_ptrace.h

diff --git a/security/landlock/Makefile b/security/landlock/Makefile
index 270ece5d93de..4500ddb0767e 100644
--- a/security/landlock/Makefile
+++ b/security/landlock/Makefile
@@ -2,4 +2,4 @@ obj-$(CONFIG_SECURITY_LANDLOCK) := landlock.o
 
 landlock-y := init.o \
 	enforce.o enforce_seccomp.o \
-	hooks.o hooks_fs.o
+	hooks.o hooks_fs.o hooks_ptrace.o
diff --git a/security/landlock/hooks_ptrace.c b/security/landlock/hooks_ptrace.c
new file mode 100644
index 000000000000..7f5e8b994e93
--- /dev/null
+++ b/security/landlock/hooks_ptrace.c
@@ -0,0 +1,121 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Landlock LSM - ptrace hooks
+ *
+ * Copyright © 2017 Mickaël Salaün <mic@digikod.net>
+ */
+
+#include <asm/current.h>
+#include <linux/errno.h>
+#include <linux/kernel.h> /* ARRAY_SIZE */
+#include <linux/lsm_hooks.h>
+#include <linux/sched.h> /* struct task_struct */
+#include <linux/seccomp.h>
+
+#include "common.h" /* struct landlock_prog_set */
+#include "hooks.h" /* landlocked() */
+#include "hooks_ptrace.h"
+
+static bool progs_are_subset(const struct landlock_prog_set *parent,
+		const struct landlock_prog_set *child)
+{
+	size_t i;
+
+	if (!parent || !child)
+		return false;
+	if (parent == child)
+		return true;
+
+	for (i = 0; i < ARRAY_SIZE(child->programs); i++) {
+		struct landlock_prog_list *walker;
+		bool found_parent = false;
+
+		if (!parent->programs[i])
+			continue;
+		for (walker = child->programs[i]; walker;
+				walker = walker->prev) {
+			if (walker == parent->programs[i]) {
+				found_parent = true;
+				break;
+			}
+		}
+		if (!found_parent)
+			return false;
+	}
+	return true;
+}
+
+static bool task_has_subset_progs(const struct task_struct *parent,
+		const struct task_struct *child)
+{
+#ifdef CONFIG_SECCOMP_FILTER
+	if (progs_are_subset(parent->seccomp.landlock_prog_set,
+				child->seccomp.landlock_prog_set))
+		/* must be ANDed with other providers (i.e. cgroup) */
+		return true;
+#endif /* CONFIG_SECCOMP_FILTER */
+	return false;
+}
+
+static int task_ptrace(const struct task_struct *parent,
+		const struct task_struct *child)
+{
+	if (!landlocked(parent))
+		return 0;
+
+	if (!landlocked(child))
+		return -EPERM;
+
+	if (task_has_subset_progs(parent, child))
+		return 0;
+
+	return -EPERM;
+}
+
+/**
+ * hook_ptrace_access_check - determine whether the current process may access
+ *			      another
+ *
+ * @child: the process to be accessed
+ * @mode: the mode of attachment
+ *
+ * If the current task has Landlock programs, then the child must have at least
+ * the same programs.  Else denied.
+ *
+ * Determine whether a process may access another, returning 0 if permission
+ * granted, -errno if denied.
+ */
+static int hook_ptrace_access_check(struct task_struct *child,
+		unsigned int mode)
+{
+	return task_ptrace(current, child);
+}
+
+/**
+ * hook_ptrace_traceme - determine whether another process may trace the
+ *			 current one
+ *
+ * @parent: the task proposed to be the tracer
+ *
+ * If the parent has Landlock programs, then the current task must have the
+ * same or more programs.
+ * Else denied.
+ *
+ * Determine whether the nominated task is permitted to trace the current
+ * process, returning 0 if permission is granted, -errno if denied.
+ */
+static int hook_ptrace_traceme(struct task_struct *parent)
+{
+	return task_ptrace(parent, current);
+}
+
+static struct security_hook_list landlock_hooks[] = {
+	LSM_HOOK_INIT(ptrace_access_check, hook_ptrace_access_check),
+	LSM_HOOK_INIT(ptrace_traceme, hook_ptrace_traceme),
+};
+
+__init void landlock_add_hooks_ptrace(void)
+{
+	security_add_hooks(landlock_hooks, ARRAY_SIZE(landlock_hooks),
+			LANDLOCK_NAME);
+}
diff --git a/security/landlock/hooks_ptrace.h b/security/landlock/hooks_ptrace.h
new file mode 100644
index 000000000000..2c2b8a13037f
--- /dev/null
+++ b/security/landlock/hooks_ptrace.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Landlock LSM - ptrace hooks
+ *
+ * Copyright © 2017 Mickaël Salaün <mic@digikod.net>
+ */
+
+__init void landlock_add_hooks_ptrace(void);
diff --git a/security/landlock/init.c b/security/landlock/init.c
index 68def2a7af71..d58aa94124b0 100644
--- a/security/landlock/init.c
+++ b/security/landlock/init.c
@@ -13,6 +13,7 @@
 
 #include "common.h" /* LANDLOCK_* */
 #include "hooks_fs.h"
+#include "hooks_ptrace.h"
 
 static bool bpf_landlock_is_valid_access(int off, int size,
 		enum bpf_access_type type, const struct bpf_prog *prog,
@@ -143,6 +144,7 @@ const struct bpf_prog_ops landlock_prog_ops = {};
 static int __init landlock_init(void)
 {
 	pr_info(LANDLOCK_NAME ": Initializing (sandbox with seccomp)\n");
+	landlock_add_hooks_ptrace();
 	landlock_add_hooks_fs();
 	return 0;
 }
-- 
2.20.1

