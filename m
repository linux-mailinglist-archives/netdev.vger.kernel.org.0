Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 204E8EE61F
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 18:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729445AbfKDRha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 12:37:30 -0500
Received: from smtp-sh.infomaniak.ch ([128.65.195.4]:38733 "EHLO
        smtp-sh.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728321AbfKDRha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 12:37:30 -0500
X-Greylist: delayed 843 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Nov 2019 12:37:07 EST
Received: from smtp-2-0000.mail.infomaniak.ch ([10.5.36.107])
        by smtp-sh.infomaniak.ch (8.14.5/8.14.5) with ESMTP id xA4HM5pm005281
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 4 Nov 2019 18:22:05 +0100
Received: from localhost (unknown [94.23.54.103])
        by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 99381100D31A6;
        Mon,  4 Nov 2019 18:22:04 +0100 (CET)
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
Subject: [PATCH bpf-next v13 3/7] landlock,seccomp: Apply Landlock programs to process hierarchy
Date:   Mon,  4 Nov 2019 18:21:42 +0100
Message-Id: <20191104172146.30797-4-mic@digikod.net>
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

The seccomp(2) syscall can be used by a task to apply a Landlock program
to itself. As a seccomp filter, a Landlock program is enforced for the
current task and all its future children. A program is immutable and a
task can only add new restricting programs to itself, forming a list of
programs.

A Landlock program is tied to a Landlock hook. If the action on a kernel
object is allowed by the other Linux security mechanisms (e.g. DAC,
capabilities, other LSM), then a Landlock hook related to this kind of
object is triggered. The list of programs for this hook is then
evaluated. Each program return a binary value which can deny the action
on a kernel object with a non-zero value. If every programs of the list
return zero, then the action on the object is allowed.

The next commit adds the LSM hooks to enforce the memory protection
programs on the appropriate process hierarchies.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: James Morris <jmorris@namei.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: Will Drewry <wad@chromium.org>
Link: https://lore.kernel.org/lkml/c10a503d-5e35-7785-2f3d-25ed8dd63fab@digikod.net/
---

Changes since v12:
* move the landlock_put_domain() call from domain_manage.c: same
  semantic (for this call) but less error-prone and self-explanatory
  (only put a domain when it is effectively replaced)
* only handle copy of domains (cf. domain management changes)
* use a consistent naming
* extend comment about unprivileged enforcement

Changes since v11:
* fix build of seccomp without Landlock (reported by kbuild test robot)

Changes since v10:
* rewrite the Landlock program attaching mechanisme to not rely on
  internal seccomp structures but only on the (LSM-stacked) task's
  credentials:
  * make the use of seccomp (and task's credentials) optional if not
    relying on its syscall, which may be useful for domains defined by
    other means (e.g. cgroups or system-wide thanks to a dedicated
    securityfs)

Changes since v9:
* replace subtype with expected_attach_type and expected_attach_triggers

Changes since v8:
* Remove the chaining concept from the eBPF program contexts (chain and
  cookie). We need to keep these subtypes this way to be able to make
  them evolve, though.

Changes since v7:
* handle and verify program chains
* split and rename providers.c to enforce.c and enforce_seccomp.c
* rename LANDLOCK_SUBTYPE_* to LANDLOCK_*

Changes since v6:
* rename some functions with more accurate names to reflect that an eBPF
  program for Landlock could be used for something else than a rule
* reword rule "appending" to "prepending" and explain it
* remove the superfluous no_new_privs check, only check global
  CAP_SYS_ADMIN when prepending a Landlock rule (needed for containers)
* create and use {get,put}_seccomp_landlock() (suggested by Kees Cook)
* replace ifdef with static inlined function (suggested by Kees Cook)
* use get_user() (suggested by Kees Cook)
* replace atomic_t with refcount_t (requested by Kees Cook)
* move struct landlock_{rule,events} from landlock.h to common.h
* cleanup headers

Changes since v5:
* remove struct landlock_node and use a similar inheritance mechanisme
  as seccomp-bpf (requested by Andy Lutomirski)
* rename SECCOMP_ADD_LANDLOCK_RULE to SECCOMP_APPEND_LANDLOCK_RULE
* rename file manager.c to providers.c
* add comments
* typo and cosmetic fixes

Changes since v4:
* merge manager and seccomp patches
* return -EFAULT in seccomp(2) when user_bpf_fd is null to easely check
  if Landlock is supported
* only allow a process with the global CAP_SYS_ADMIN to use Landlock
  (will be lifted in the future)
* add an early check to exit as soon as possible if the current process
  does not have Landlock rules

Changes since v3:
* remove the hard link with seccomp (suggested by Andy Lutomirski and
  Kees Cook):
  * remove the cookie which could imply multiple evaluation of Landlock
    rules
  * remove the origin field in struct landlock_data
* remove documentation fix (merged upstream)
* rename the new seccomp command to SECCOMP_ADD_LANDLOCK_RULE
* internal renaming
* split commit
* new design to be able to inherit on the fly the parent rules

Changes since v2:
* Landlock programs can now be run without seccomp filter but for any
  syscall (from the process) or interruption
* move Landlock related functions and structs into security/landlock/*
  (to manage cgroups as well)
* fix seccomp filter handling: run Landlock programs for each of their
  legitimate seccomp filter
* properly clean up all seccomp results
* cosmetic changes to ease the understanding
* fix some ifdef
---
 MAINTAINERS                        |  1 +
 include/linux/landlock.h           | 25 ++++++++
 include/linux/lsm_hooks.h          |  1 +
 include/uapi/linux/seccomp.h       |  1 +
 kernel/seccomp.c                   |  4 ++
 security/landlock/Makefile         |  5 +-
 security/landlock/common.h         | 16 +++++
 security/landlock/domain_syscall.c | 93 ++++++++++++++++++++++++++++++
 security/landlock/hooks_cred.c     | 47 +++++++++++++++
 security/landlock/hooks_cred.h     | 14 +++++
 security/landlock/init.c           | 30 ++++++++++
 security/security.c                | 15 +++++
 12 files changed, 250 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/landlock.h
 create mode 100644 security/landlock/domain_syscall.c
 create mode 100644 security/landlock/hooks_cred.c
 create mode 100644 security/landlock/hooks_cred.h
 create mode 100644 security/landlock/init.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 4cabb85ea52d..32bfd88159b0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9149,6 +9149,7 @@ F:	net/ipv4/tcp_bpf.c
 LANDLOCK SECURITY MODULE
 M:	Mickaël Salaün <mic@digikod.net>
 S:	Supported
+F:	include/linux/landlock.h
 F:	include/uapi/linux/landlock.h
 F:	security/landlock/
 K:	landlock
diff --git a/include/linux/landlock.h b/include/linux/landlock.h
new file mode 100644
index 000000000000..ffbf2397c459
--- /dev/null
+++ b/include/linux/landlock.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Landlock LSM - public kernel headers
+ *
+ * Copyright © 2016-2019 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2018-2019 ANSSI
+ */
+
+#ifndef _LINUX_LANDLOCK_H
+#define _LINUX_LANDLOCK_H
+
+#include <linux/errno.h>
+
+#if defined(CONFIG_SECCOMP_FILTER) && defined(CONFIG_SECURITY_LANDLOCK)
+extern int landlock_seccomp_prepend_prog(unsigned int flags,
+		const int __user *user_bpf_fd);
+#else /* CONFIG_SECCOMP_FILTER && CONFIG_SECURITY_LANDLOCK */
+static inline int landlock_seccomp_prepend_prog(unsigned int flags,
+		const int __user *user_bpf_fd)
+{
+		return -EINVAL;
+}
+#endif /* CONFIG_SECCOMP_FILTER && CONFIG_SECURITY_LANDLOCK */
+
+#endif /* _LINUX_LANDLOCK_H */
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index a3763247547c..a8ba679b388a 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -2106,6 +2106,7 @@ extern void security_add_hooks(struct security_hook_list *hooks, int count,
 enum lsm_order {
 	LSM_ORDER_FIRST = -1,	/* This is only for capabilities. */
 	LSM_ORDER_MUTABLE = 0,
+	LSM_ORDER_LAST = 1,	/* potentially-unprivileged LSM */
 };
 
 struct lsm_info {
diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index 90734aa5aa36..bce6534e7feb 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -16,6 +16,7 @@
 #define SECCOMP_SET_MODE_FILTER		1
 #define SECCOMP_GET_ACTION_AVAIL	2
 #define SECCOMP_GET_NOTIF_SIZES		3
+#define SECCOMP_PREPEND_LANDLOCK_PROG	4
 
 /* Valid flags for SECCOMP_SET_MODE_FILTER */
 #define SECCOMP_FILTER_FLAG_TSYNC		(1UL << 0)
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index dba52a7db5e8..0688a1439587 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -19,6 +19,7 @@
 #include <linux/compat.h>
 #include <linux/coredump.h>
 #include <linux/kmemleak.h>
+#include <linux/landlock.h>
 #include <linux/nospec.h>
 #include <linux/prctl.h>
 #include <linux/sched.h>
@@ -1397,6 +1398,9 @@ static long do_seccomp(unsigned int op, unsigned int flags,
 			return -EINVAL;
 
 		return seccomp_get_notif_sizes(uargs);
+	case SECCOMP_PREPEND_LANDLOCK_PROG:
+		return landlock_seccomp_prepend_prog(flags,
+				(const int __user *)uargs);
 	default:
 		return -EINVAL;
 	}
diff --git a/security/landlock/Makefile b/security/landlock/Makefile
index dd5f70185778..0b291f2c027c 100644
--- a/security/landlock/Makefile
+++ b/security/landlock/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_SECURITY_LANDLOCK) := landlock.o
 
-landlock-y := \
+landlock-y := init.o \
 	bpf_verify.o bpf_ptrace.o \
-	domain_manage.o
+	domain_manage.o domain_syscall.o \
+	hooks_cred.o
diff --git a/security/landlock/common.h b/security/landlock/common.h
index fb2990eb5fb4..3ae8340a5b3d 100644
--- a/security/landlock/common.h
+++ b/security/landlock/common.h
@@ -10,9 +10,15 @@
 #define _SECURITY_LANDLOCK_COMMON_H
 
 #include <linux/bpf.h>
+#include <linux/cred.h>
 #include <linux/filter.h>
+#include <linux/lsm_hooks.h>
 #include <linux/refcount.h>
 
+#define LANDLOCK_NAME "landlock"
+
+extern struct lsm_blob_sizes landlock_blob_sizes;
+
 enum landlock_hook_type {
 	LANDLOCK_HOOK_PTRACE = 1,
 };
@@ -43,6 +49,16 @@ struct landlock_domain {
 	refcount_t usage;
 };
 
+struct landlock_cred_security {
+	struct landlock_domain *domain;
+};
+
+static inline struct landlock_cred_security *landlock_cred(
+		const struct cred *cred)
+{
+	return cred->security + landlock_blob_sizes.lbs_cred;
+}
+
 /**
  * get_hook_index - get an index for the programs of struct landlock_prog_set
  *
diff --git a/security/landlock/domain_syscall.c b/security/landlock/domain_syscall.c
new file mode 100644
index 000000000000..022393841a0a
--- /dev/null
+++ b/security/landlock/domain_syscall.c
@@ -0,0 +1,93 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Landlock LSM - seccomp syscall
+ *
+ * Copyright © 2016-2018 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2018-2019 ANSSI
+ */
+
+#ifdef CONFIG_SECCOMP_FILTER
+
+#include <asm/current.h>
+#include <linux/bpf.h>
+#include <linux/capability.h>
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/filter.h>
+#include <linux/landlock.h>
+#include <linux/refcount.h>
+#include <linux/sched.h>
+#include <linux/seccomp.h>
+#include <linux/uaccess.h>
+
+#include "common.h"
+#include "domain_manage.h"
+
+/**
+ * landlock_seccomp_prepend_prog - attach a Landlock program to the current
+ *                                 task
+ *
+ * current->cred->security[landlock]->domain is lazily allocated. When a new
+ * credential is created, only a pointer is copied.  When a new Landlock
+ * program is added by a task, if there is other references to this task's
+ * domain, then a new allocation is made to contain an array pointing to
+ * Landlock program lists.  This design enable low-performance impact and is
+ * memory efficient while keeping the property of prepend-only programs.
+ *
+ * For now, installing a Landlock program requires that the requesting task has
+ * the global CAP_SYS_ADMIN. We cannot force the use of no_new_privs to not
+ * exclude containers where a process may legitimately acquire more privileges
+ * thanks to an SUID binary.
+ *
+ * @flags: not used, must be 0
+ * @user_bpf_fd: file descriptor pointing to a loaded Landlock prog
+ */
+int landlock_seccomp_prepend_prog(unsigned int flags,
+		const int __user *user_bpf_fd)
+{
+	struct landlock_domain *new_dom;
+	struct cred *new_cred;
+	struct landlock_cred_security *new_llcred;
+	struct bpf_prog *prog;
+	int bpf_fd, err;
+
+	/*
+	 * It is planned to replaced the CAP_SYS_ADMIN check with a
+	 * no_new_privs check to allow unprivileged tasks to sandbox
+	 * themselves.  However, they may not be allowed to directly create an
+	 * eBPF program, but could received it from a privileged service.
+	 */
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	/* enable to check if Landlock is supported with early EFAULT */
+	if (!user_bpf_fd)
+		return -EFAULT;
+	if (flags)
+		return -EINVAL;
+	err = get_user(bpf_fd, user_bpf_fd);
+	if (err)
+		return err;
+	prog = bpf_prog_get(bpf_fd);
+	if (IS_ERR(prog))
+		return PTR_ERR(prog);
+
+	new_cred = prepare_creds();
+	if (!new_cred) {
+		bpf_prog_put(prog);
+		return -ENOMEM;
+	}
+	new_llcred = landlock_cred(new_cred);
+	/* the new creds are an atomic copy of the current creds */
+	new_dom = landlock_prepend_prog(new_llcred->domain, prog);
+	bpf_prog_put(prog);
+	if (IS_ERR(new_dom)) {
+		abort_creds(new_cred);
+		return PTR_ERR(new_dom);
+	}
+	/* replace the old (prepared) domain */
+	landlock_put_domain(new_llcred->domain);
+	new_llcred->domain = new_dom;
+	return commit_creds(new_cred);
+}
+
+#endif /* CONFIG_SECCOMP_FILTER */
diff --git a/security/landlock/hooks_cred.c b/security/landlock/hooks_cred.c
new file mode 100644
index 000000000000..def8678019a0
--- /dev/null
+++ b/security/landlock/hooks_cred.c
@@ -0,0 +1,47 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Landlock LSM - credential hooks
+ *
+ * Copyright © 2017-2019 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2018-2019 ANSSI
+ */
+
+#include <linux/cred.h>
+#include <linux/lsm_hooks.h>
+
+#include "common.h"
+#include "domain_manage.h"
+#include "hooks_cred.h"
+
+static int hook_cred_prepare(struct cred *new, const struct cred *old,
+		gfp_t gfp)
+{
+	const struct landlock_cred_security *cred_old = landlock_cred(old);
+	struct landlock_cred_security *cred_new = landlock_cred(new);
+	struct landlock_domain *dom_old;
+
+	dom_old = cred_old->domain;
+	if (dom_old) {
+		landlock_get_domain(dom_old);
+		cred_new->domain = dom_old;
+	} else {
+		cred_new->domain = NULL;
+	}
+	return 0;
+}
+
+static void hook_cred_free(struct cred *cred)
+{
+	landlock_put_domain(landlock_cred(cred)->domain);
+}
+
+static struct security_hook_list landlock_hooks[] = {
+	LSM_HOOK_INIT(cred_prepare, hook_cred_prepare),
+	LSM_HOOK_INIT(cred_free, hook_cred_free),
+};
+
+__init void landlock_add_hooks_cred(void)
+{
+	security_add_hooks(landlock_hooks, ARRAY_SIZE(landlock_hooks),
+			LANDLOCK_NAME);
+}
diff --git a/security/landlock/hooks_cred.h b/security/landlock/hooks_cred.h
new file mode 100644
index 000000000000..641d66f6bf9a
--- /dev/null
+++ b/security/landlock/hooks_cred.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Landlock LSM - credential hooks headers
+ *
+ * Copyright © 2019 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2019 ANSSI
+ */
+
+#ifndef _SECURITY_LANDLOCK_HOOKS_CRED_H
+#define _SECURITY_LANDLOCK_HOOKS_CRED_H
+
+__init void landlock_add_hooks_cred(void);
+
+#endif /* _SECURITY_LANDLOCK_HOOKS_CRED_H */
diff --git a/security/landlock/init.c b/security/landlock/init.c
new file mode 100644
index 000000000000..8836ec4defd3
--- /dev/null
+++ b/security/landlock/init.c
@@ -0,0 +1,30 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Landlock LSM - initialization
+ *
+ * Copyright © 2016-2019 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2018-2019 ANSSI
+ */
+
+#include <linux/lsm_hooks.h>
+
+#include "common.h"
+#include "hooks_cred.h"
+
+static int __init landlock_init(void)
+{
+	pr_info(LANDLOCK_NAME ": Registering hooks\n");
+	landlock_add_hooks_cred();
+	return 0;
+}
+
+struct lsm_blob_sizes landlock_blob_sizes __lsm_ro_after_init = {
+	.lbs_cred = sizeof(struct landlock_cred_security),
+};
+
+DEFINE_LSM(LANDLOCK_NAME) = {
+	.name = LANDLOCK_NAME,
+	.order = LSM_ORDER_LAST,
+	.blobs = &landlock_blob_sizes,
+	.init = landlock_init,
+};
diff --git a/security/security.c b/security/security.c
index 1bc000f834e2..03c7dce9e014 100644
--- a/security/security.c
+++ b/security/security.c
@@ -264,6 +264,21 @@ static void __init ordered_lsm_parse(const char *order, const char *origin)
 		}
 	}
 
+	/*
+	 * In case of an unprivileged access-control, we don't want to give the
+	 * ability to any process to do some checks (e.g. through an eBPF
+	 * program) on kernel objects (e.g. files) if a privileged security
+	 * policy forbid their access.  We must then load
+	 * potentially-unprivileged security modules after all other LSMs.
+	 *
+	 * LSM_ORDER_LAST is always last and does not appear in the modifiable
+	 * ordered list of enabled LSMs.
+	 */
+	for (lsm = __start_lsm_info; lsm < __end_lsm_info; lsm++) {
+		if (lsm->order == LSM_ORDER_LAST)
+			append_ordered_lsm(lsm, "last");
+	}
+
 	/* Disable all LSMs not in the ordered list. */
 	for (lsm = __start_lsm_info; lsm < __end_lsm_info; lsm++) {
 		if (exists_ordered_lsm(lsm))
-- 
2.23.0

