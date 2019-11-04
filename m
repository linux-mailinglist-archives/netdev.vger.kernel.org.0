Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 670C4EE7FB
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 20:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728940AbfKDTJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 14:09:46 -0500
Received: from smtp-sh2.infomaniak.ch ([128.65.195.6]:35633 "EHLO
        smtp-sh2.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728761AbfKDTJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 14:09:45 -0500
Received: from smtp-2-0000.mail.infomaniak.ch (smtp-2-0000.mail.infomaniak.ch [10.5.36.107])
        by smtp-sh2.infomaniak.ch (8.14.4/8.14.4/Debian-8+deb8u2) with ESMTP id xA4HM7CT110630
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 4 Nov 2019 18:22:07 +0100
Received: from localhost (unknown [94.23.54.103])
        by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 88D0C1003E5F4;
        Mon,  4 Nov 2019 18:22:06 +0100 (CET)
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
Subject: [PATCH bpf-next v13 4/7] landlock: Add ptrace LSM hooks
Date:   Mon,  4 Nov 2019 18:21:43 +0100
Message-Id: <20191104172146.30797-5-mic@digikod.net>
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

Add a first Landlock hook that can be used to enforce a security policy
or to audit some process activities.  For a sandboxing use-case, it is
needed to inform the kernel if a task can legitimately debug another.
ptrace(2) can also be used by an attacker to impersonate another task
and remain undetected while performing malicious activities.

Using ptrace(2) and related features on a target process can lead to a
privilege escalation.  A sandboxed task must then be able to tell the
kernel if another task is more privileged, via ptrace_may_access().

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: James Morris <jmorris@namei.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: Will Drewry <wad@chromium.org>
---

Changes since v12:
* ensure preemption is disabled before running BPF programs, cf. commit
  568f196756ad ("bpf: check that BPF programs run with preemption
  disabled")

Changes since v10:
* revamp and replace the static policy with a Landlock hook which may be
  used by the corresponding BPF_LANDLOCK_PTRACE program (attach) type
  and a dedicated process_cmp_landlock_ptrace() BPF helper
* check prog return value against LANDLOCK_RET_DENY (ret is a bitmask)

Changes since v6:
* factor out ptrace check
* constify pointers
* cleanup headers
* use the new security_add_hooks()
---
 security/landlock/Makefile       |   4 +-
 security/landlock/bpf_run.c      |  65 ++++++++++++++++++
 security/landlock/bpf_run.h      |  25 +++++++
 security/landlock/hooks_ptrace.c | 114 +++++++++++++++++++++++++++++++
 security/landlock/hooks_ptrace.h |  19 ++++++
 security/landlock/init.c         |   2 +
 6 files changed, 227 insertions(+), 2 deletions(-)
 create mode 100644 security/landlock/bpf_run.c
 create mode 100644 security/landlock/bpf_run.h
 create mode 100644 security/landlock/hooks_ptrace.c
 create mode 100644 security/landlock/hooks_ptrace.h

diff --git a/security/landlock/Makefile b/security/landlock/Makefile
index 0b291f2c027c..93e4c2f31c8a 100644
--- a/security/landlock/Makefile
+++ b/security/landlock/Makefile
@@ -1,6 +1,6 @@
 obj-$(CONFIG_SECURITY_LANDLOCK) := landlock.o
 
 landlock-y := init.o \
-	bpf_verify.o bpf_ptrace.o \
+	bpf_verify.o bpf_run.o bpf_ptrace.o \
 	domain_manage.o domain_syscall.o \
-	hooks_cred.o
+	hooks_cred.o hooks_ptrace.o
diff --git a/security/landlock/bpf_run.c b/security/landlock/bpf_run.c
new file mode 100644
index 000000000000..454cd4b6e99b
--- /dev/null
+++ b/security/landlock/bpf_run.c
@@ -0,0 +1,65 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Landlock LSM - eBPF program evaluation
+ *
+ * Copyright © 2016-2019 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2018-2019 ANSSI
+ */
+
+#include <asm/current.h>
+#include <linux/bpf.h>
+#include <linux/errno.h>
+#include <linux/filter.h>
+#include <linux/preempt.h>
+#include <linux/rculist.h>
+#include <uapi/linux/landlock.h>
+
+#include "bpf_run.h"
+#include "common.h"
+#include "hooks_ptrace.h"
+
+static const void *get_prog_ctx(struct landlock_hook_ctx *hook_ctx)
+{
+	switch (hook_ctx->type) {
+	case LANDLOCK_HOOK_PTRACE:
+		return landlock_get_ctx_ptrace(hook_ctx->ctx_ptrace);
+	}
+	WARN_ON(1);
+	return NULL;
+}
+
+/**
+ * landlock_access_denied - run Landlock programs tied to a hook
+ *
+ * @domain: Landlock domain pointer
+ * @hook_ctx: non-NULL valid eBPF context pointer
+ *
+ * Return true if at least one program return deny, false otherwise.
+ */
+bool landlock_access_denied(struct landlock_domain *domain,
+		struct landlock_hook_ctx *hook_ctx)
+{
+	struct landlock_prog_list *prog_list;
+	const size_t hook = get_hook_index(hook_ctx->type);
+
+	if (!domain)
+		return false;
+
+	for (prog_list = domain->programs[hook]; prog_list;
+			prog_list = prog_list->prev) {
+		u32 ret;
+		const void *prog_ctx;
+
+		prog_ctx = get_prog_ctx(hook_ctx);
+		if (!prog_ctx || WARN_ON(IS_ERR(prog_ctx)))
+			return true;
+		preempt_disable();
+		rcu_read_lock();
+		ret = BPF_PROG_RUN(prog_list->prog, prog_ctx);
+		rcu_read_unlock();
+		preempt_enable();
+		if (ret & LANDLOCK_RET_DENY)
+			return true;
+	}
+	return false;
+}
diff --git a/security/landlock/bpf_run.h b/security/landlock/bpf_run.h
new file mode 100644
index 000000000000..3461cbb8ec12
--- /dev/null
+++ b/security/landlock/bpf_run.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Landlock LSM - eBPF program evaluation headers
+ *
+ * Copyright © 2016-2019 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2018-2019 ANSSI
+ */
+
+#ifndef _SECURITY_LANDLOCK_BPF_RUN_H
+#define _SECURITY_LANDLOCK_BPF_RUN_H
+
+#include "common.h"
+#include "hooks_ptrace.h"
+
+struct landlock_hook_ctx {
+	enum landlock_hook_type type;
+	union {
+		struct landlock_hook_ctx_ptrace *ctx_ptrace;
+	};
+};
+
+bool landlock_access_denied(struct landlock_domain *domain,
+		struct landlock_hook_ctx *hook_ctx);
+
+#endif /* _SECURITY_LANDLOCK_BPF_RUN_H */
diff --git a/security/landlock/hooks_ptrace.c b/security/landlock/hooks_ptrace.c
new file mode 100644
index 000000000000..8e518a472d04
--- /dev/null
+++ b/security/landlock/hooks_ptrace.c
@@ -0,0 +1,114 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Landlock LSM - ptrace hooks
+ *
+ * Copyright © 2017-2019 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2019 ANSSI
+ */
+
+#include <asm/current.h>
+#include <linux/cred.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/lsm_hooks.h>
+#include <linux/sched.h>
+#include <uapi/linux/landlock.h>
+
+#include "bpf_run.h"
+#include "common.h"
+#include "hooks_ptrace.h"
+
+struct landlock_hook_ctx_ptrace {
+	struct landlock_context_ptrace prog_ctx;
+};
+
+const struct landlock_context_ptrace *landlock_get_ctx_ptrace(
+		const struct landlock_hook_ctx_ptrace *hook_ctx)
+{
+	if (WARN_ON(!hook_ctx))
+		return NULL;
+
+	return &hook_ctx->prog_ctx;
+}
+
+static int check_ptrace(struct landlock_domain *domain,
+		struct task_struct *tracer, struct task_struct *tracee)
+{
+	struct landlock_hook_ctx_ptrace ctx_ptrace = {
+		.prog_ctx = {
+			.tracer = (uintptr_t)tracer,
+			.tracee = (uintptr_t)tracee,
+		},
+	};
+	struct landlock_hook_ctx hook_ctx = {
+		.type = LANDLOCK_HOOK_PTRACE,
+		.ctx_ptrace = &ctx_ptrace,
+	};
+
+	return landlock_access_denied(domain, &hook_ctx) ? -EPERM : 0;
+}
+
+/**
+ * hook_ptrace_access_check - determine whether the current process may access
+ *			      another
+ *
+ * @child: the process to be accessed
+ * @mode: the mode of attachment
+ *
+ * If the current task (i.e. tracer) has one or multiple BPF_LANDLOCK_PTRACE
+ * programs, then run them with the `struct landlock_context_ptrace` context.
+ * If one of these programs return LANDLOCK_RET_DENY, then deny access with
+ * -EPERM, else allow it by returning 0.
+ */
+static int hook_ptrace_access_check(struct task_struct *child,
+		unsigned int mode)
+{
+	struct landlock_domain *dom_current;
+	const size_t hook = get_hook_index(LANDLOCK_HOOK_PTRACE);
+
+	dom_current = landlock_cred(current_cred())->domain;
+	if (!(dom_current && dom_current->programs[hook]))
+		return 0;
+	return check_ptrace(dom_current, current, child);
+}
+
+/**
+ * hook_ptrace_traceme - determine whether another process may trace the
+ *			 current one
+ *
+ * @parent: the task proposed to be the tracer
+ *
+ * If the parent task (i.e. tracer) has one or multiple BPF_LANDLOCK_PTRACE
+ * programs, then run them with the `struct landlock_context_ptrace` context.
+ * If one of these programs return LANDLOCK_RET_DENY, then deny access with
+ * -EPERM, else allow it by returning 0.
+ */
+static int hook_ptrace_traceme(struct task_struct *parent)
+{
+	struct landlock_domain *dom_parent;
+	const size_t hook = get_hook_index(LANDLOCK_HOOK_PTRACE);
+	int ret;
+
+	rcu_read_lock();
+	dom_parent = landlock_cred(__task_cred(parent))->domain;
+	if (!(dom_parent && dom_parent->programs[hook])) {
+		ret = 0;
+		goto put_rcu;
+	}
+	ret = check_ptrace(dom_parent, parent, current);
+
+put_rcu:
+	rcu_read_unlock();
+	return ret;
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
index 000000000000..53fe651bdb3e
--- /dev/null
+++ b/security/landlock/hooks_ptrace.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Landlock LSM - ptrace hooks headers
+ *
+ * Copyright © 2017-2019 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2019 ANSSI
+ */
+
+#ifndef _SECURITY_LANDLOCK_HOOKS_PTRACE_H
+#define _SECURITY_LANDLOCK_HOOKS_PTRACE_H
+
+struct landlock_hook_ctx_ptrace;
+
+const struct landlock_context_ptrace *landlock_get_ctx_ptrace(
+		const struct landlock_hook_ctx_ptrace *hook_ctx);
+
+__init void landlock_add_hooks_ptrace(void);
+
+#endif /* _SECURITY_LANDLOCK_HOOKS_PTRACE_H */
diff --git a/security/landlock/init.c b/security/landlock/init.c
index 8836ec4defd3..541aad17418e 100644
--- a/security/landlock/init.c
+++ b/security/landlock/init.c
@@ -10,11 +10,13 @@
 
 #include "common.h"
 #include "hooks_cred.h"
+#include "hooks_ptrace.h"
 
 static int __init landlock_init(void)
 {
 	pr_info(LANDLOCK_NAME ": Registering hooks\n");
 	landlock_add_hooks_cred();
+	landlock_add_hooks_ptrace();
 	return 0;
 }
 
-- 
2.23.0

