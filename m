Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6678DEE7FA
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 20:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728778AbfKDTJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 14:09:43 -0500
Received: from smtp-sh2.infomaniak.ch ([128.65.195.6]:35633 "EHLO
        smtp-sh2.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728377AbfKDTJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 14:09:43 -0500
Received: from smtp-3-0000.mail.infomaniak.ch (smtp-3-0000.mail.infomaniak.ch [10.4.36.107])
        by smtp-sh2.infomaniak.ch (8.14.4/8.14.4/Debian-8+deb8u2) with ESMTP id xA4HM3t4110104
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 4 Nov 2019 18:22:03 +0100
Received: from localhost (unknown [94.23.54.103])
        by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id B0EC2100A7A0E;
        Mon,  4 Nov 2019 18:22:02 +0100 (CET)
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
Subject: [PATCH bpf-next v13 2/7] landlock: Add the management of domains
Date:   Mon,  4 Nov 2019 18:21:41 +0100
Message-Id: <20191104172146.30797-3-mic@digikod.net>
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

A Landlock domain is a set of eBPF programs.  There is a list for each
different program types that can be run on a specific Landlock hook
(e.g. ptrace).  A domain is tied to a set of subjects (i.e. tasks).  A
Landlock program should not try (nor be able) to infer which subject is
currently enforced, but to have a unique security policy for all
subjects tied to the same domain.  This make the reasoning much easier
and help avoid pitfalls.

The next commits tie a domain to a task's credentials thanks to
seccomp(2), but we could use cgroups or a security file-system to
enforce a sysadmin-defined policy .

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
* move the landlock_put_domain() call from landlock_prepend_prog() to
  domain_syscall.c:landlock_seccomp_prepend_prog() (next commit): keep
  the same semantic but don't conditionally own the domain (safeguard
  domain owning)
* always copy a domain to-be-modified which guarantee domain
  immutability: the callers of landlock_prepend_prog() are now fully in
  charge of concurrency handling, which is currently only handled by
  prepare_creds() and commit_creds() (next commit)
* simplify landlock_prepend_prog()
* use a consistent naming

Changes since v11:
* remove old code from previous refactoring (removing the program
  chaining concept) and simplify program prepending (reported by Serge
  E. Hallyn):
  * simplify landlock_prepend_prog() and merge it with
    store_landlock_prog()
  * add new_prog_list() and rework new_landlock_domain()
  * remove the extra page allocation checks, only rely on the eBPF
    program checks
* replace the -EINVAL for the duplicate program check with the -EEXIST

Changes since v10:
* rename files and names to clearly define a domain
* create a standalone patch to ease review
---
 security/landlock/Makefile        |   3 +-
 security/landlock/common.h        |  38 ++++++++
 security/landlock/domain_manage.c | 152 ++++++++++++++++++++++++++++++
 security/landlock/domain_manage.h |  22 +++++
 4 files changed, 214 insertions(+), 1 deletion(-)
 create mode 100644 security/landlock/domain_manage.c
 create mode 100644 security/landlock/domain_manage.h

diff --git a/security/landlock/Makefile b/security/landlock/Makefile
index 682b798c6b76..dd5f70185778 100644
--- a/security/landlock/Makefile
+++ b/security/landlock/Makefile
@@ -1,4 +1,5 @@
 obj-$(CONFIG_SECURITY_LANDLOCK) := landlock.o
 
 landlock-y := \
-	bpf_verify.o bpf_ptrace.o
+	bpf_verify.o bpf_ptrace.o \
+	domain_manage.o
diff --git a/security/landlock/common.h b/security/landlock/common.h
index 0234c4bc4acd..fb2990eb5fb4 100644
--- a/security/landlock/common.h
+++ b/security/landlock/common.h
@@ -11,11 +11,49 @@
 
 #include <linux/bpf.h>
 #include <linux/filter.h>
+#include <linux/refcount.h>
 
 enum landlock_hook_type {
 	LANDLOCK_HOOK_PTRACE = 1,
 };
 
+#define _LANDLOCK_HOOK_LAST LANDLOCK_HOOK_PTRACE
+
+struct landlock_prog_list {
+	struct landlock_prog_list *prev;
+	struct bpf_prog *prog;
+	refcount_t usage;
+};
+
+/**
+ * struct landlock_domain - Landlock programs enforced on a set of tasks
+ *
+ * When prepending a new program, if &struct landlock_domain is shared with
+ * other tasks, then duplicate it and prepend the program to this new &struct
+ * landlock_domain.
+ *
+ * @usage: reference count to manage the object lifetime. When a task needs to
+ *	   add Landlock programs and if @usage is greater than 1, then the
+ *	   task must duplicate &struct landlock_domain to not change the
+ *	   children's programs as well.
+ * @programs: array of non-NULL &struct landlock_prog_list pointers
+ */
+struct landlock_domain {
+	struct landlock_prog_list *programs[_LANDLOCK_HOOK_LAST];
+	refcount_t usage;
+};
+
+/**
+ * get_hook_index - get an index for the programs of struct landlock_prog_set
+ *
+ * @type: a Landlock hook type
+ */
+static inline size_t get_hook_index(enum landlock_hook_type type)
+{
+	/* type ID > 0 for loaded programs */
+	return type - 1;
+}
+
 static inline enum landlock_hook_type get_hook_type(const struct bpf_prog *prog)
 {
 	switch (prog->expected_attach_type) {
diff --git a/security/landlock/domain_manage.c b/security/landlock/domain_manage.c
new file mode 100644
index 000000000000..b65960611d09
--- /dev/null
+++ b/security/landlock/domain_manage.c
@@ -0,0 +1,152 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Landlock LSM - domain management
+ *
+ * Copyright © 2016-2019 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2018-2019 ANSSI
+ */
+
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/refcount.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+
+#include "common.h"
+#include "domain_manage.h"
+
+void landlock_get_domain(struct landlock_domain *domain)
+{
+	if (!domain)
+		return;
+	refcount_inc(&domain->usage);
+}
+
+static void put_prog_list(struct landlock_prog_list *prog_list)
+{
+	struct landlock_prog_list *orig = prog_list;
+
+	/* clean up single-reference branches iteratively */
+	while (orig && refcount_dec_and_test(&orig->usage)) {
+		struct landlock_prog_list *freeme = orig;
+
+		if (orig->prog)
+			bpf_prog_put(orig->prog);
+		orig = orig->prev;
+		kfree(freeme);
+	}
+}
+
+void landlock_put_domain(struct landlock_domain *domain)
+{
+	if (domain && refcount_dec_and_test(&domain->usage)) {
+		size_t i;
+
+		for (i = 0; i < ARRAY_SIZE(domain->programs); i++)
+			put_prog_list(domain->programs[i]);
+		kfree(domain);
+	}
+}
+
+static struct landlock_prog_list *create_prog_list(struct bpf_prog *prog)
+{
+	struct landlock_prog_list *new_list;
+
+	if (WARN_ON(IS_ERR_OR_NULL(prog)))
+		return ERR_PTR(-EFAULT);
+	if (prog->type != BPF_PROG_TYPE_LANDLOCK_HOOK)
+		return ERR_PTR(-EINVAL);
+	prog = bpf_prog_inc(prog);
+	if (IS_ERR(prog))
+		return ERR_CAST(prog);
+	new_list = kzalloc(sizeof(*new_list), GFP_KERNEL);
+	if (!new_list) {
+		bpf_prog_put(prog);
+		return ERR_PTR(-ENOMEM);
+	}
+	new_list->prog = prog;
+	refcount_set(&new_list->usage, 1);
+	return new_list;
+}
+
+static struct landlock_domain *create_domain(struct bpf_prog *prog)
+{
+	struct landlock_domain *new_dom;
+	struct landlock_prog_list *new_list;
+	size_t hook;
+
+	/* programs[] filled with NULL values */
+	new_dom = kzalloc(sizeof(*new_dom), GFP_KERNEL);
+	if (!new_dom)
+		return ERR_PTR(-ENOMEM);
+	refcount_set(&new_dom->usage, 1);
+	new_list = create_prog_list(prog);
+	if (IS_ERR(new_list)) {
+		kfree(new_dom);
+		return ERR_CAST(new_list);
+	}
+	hook = get_hook_index(get_hook_type(prog));
+	new_dom->programs[hook] = new_list;
+	return new_dom;
+}
+
+/**
+ * landlock_prepend_prog - extend a Landlock domain with an eBPF program
+ *
+ * Prepend @prog to @domain if @prog is not already in @domain.
+ *
+ * @domain: domain to copy and extend with @prog. This domain must not be
+ *          modified by another function than this one to guarantee domain
+ *          immutability.
+ * @prog: non-NULL Landlock program to prepend to a copy of @domain.  @prog
+ *        will be owned by landlock_prepend_prog(). You can then call
+ *        bpf_prog_put(@prog) after.
+ *
+ * Return a copy of @domain (with @prog prepended) when OK. Return a pointer
+ * error otherwise.
+ */
+struct landlock_domain *landlock_prepend_prog(struct landlock_domain *domain,
+		struct bpf_prog *prog)
+{
+	struct landlock_prog_list *walker;
+	struct landlock_domain *new_dom;
+	size_t i, hook;
+
+	if (WARN_ON(!prog))
+		return ERR_PTR(-EFAULT);
+	if (prog->type != BPF_PROG_TYPE_LANDLOCK_HOOK)
+		return ERR_PTR(-EINVAL);
+
+	if (!domain)
+		return create_domain(prog);
+
+	hook = get_hook_index(get_hook_type(prog));
+	/* check for similar program */
+	for (walker = domain->programs[hook]; walker;
+			walker = walker->prev) {
+		/* don't allow duplicate programs */
+		if (prog == walker->prog)
+			return ERR_PTR(-EEXIST);
+	}
+
+	new_dom = create_domain(prog);
+	if (IS_ERR(new_dom))
+		return new_dom;
+
+	/* copy @domain (which is guarantee to be immutable) */
+	for (i = 0; i < ARRAY_SIZE(new_dom->programs); i++) {
+		struct landlock_prog_list *current_list;
+		struct landlock_prog_list **new_list;
+
+		current_list = domain->programs[i];
+		if (!current_list)
+			continue;
+		refcount_inc(&current_list->usage);
+		new_list = &new_dom->programs[i];
+		if (*new_list)
+			new_list = &(*new_list)->prev;
+		/* do not increment usage */
+		*new_list = current_list;
+	}
+	return new_dom;
+}
diff --git a/security/landlock/domain_manage.h b/security/landlock/domain_manage.h
new file mode 100644
index 000000000000..d32c65c941c0
--- /dev/null
+++ b/security/landlock/domain_manage.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Landlock LSM - domain management headers
+ *
+ * Copyright © 2016-2019 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2018-2019 ANSSI
+ */
+
+#ifndef _SECURITY_LANDLOCK_DOMAIN_MANAGE_H
+#define _SECURITY_LANDLOCK_DOMAIN_MANAGE_H
+
+#include <linux/filter.h>
+
+#include "common.h"
+
+void landlock_get_domain(struct landlock_domain *domain);
+void landlock_put_domain(struct landlock_domain *domain);
+
+struct landlock_domain *landlock_prepend_prog(struct landlock_domain *domain,
+		struct bpf_prog *prog);
+
+#endif /* _SECURITY_LANDLOCK_DOMAIN_MANAGE_H */
-- 
2.23.0

