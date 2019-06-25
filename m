Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 866F655AC4
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 00:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbfFYWN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 18:13:27 -0400
Received: from smtp-sh.infomaniak.ch ([128.65.195.4]:52165 "EHLO
        smtp-sh.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbfFYWN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 18:13:26 -0400
Received: from smtp5.infomaniak.ch (smtp5.infomaniak.ch [83.166.132.18])
        by smtp-sh.infomaniak.ch (8.14.5/8.14.5) with ESMTP id x5PLrK1v019814
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jun 2019 23:53:20 +0200
Received: from localhost (ns3096276.ip-94-23-54.eu [94.23.54.103])
        (authenticated bits=0)
        by smtp5.infomaniak.ch (8.14.5/8.14.5) with ESMTP id x5PLrKcg038719;
        Tue, 25 Jun 2019 23:53:20 +0200
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
Subject: [PATCH bpf-next v9 04/10] seccomp,landlock: Enforce Landlock programs per process hierarchy
Date:   Tue, 25 Jun 2019 23:52:33 +0200
Message-Id: <20190625215239.11136-5-mic@digikod.net>
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

The seccomp(2) syscall can be used by a task to apply a Landlock program
to itself. As a seccomp filter, a Landlock program is enforced for the
current task and all its future children. A program is immutable and a
task can only add new restricting programs to itself, forming a list of
programss.

A Landlock program is tied to a Landlock hook. If the action on a kernel
object is allowed by the other Linux security mechanisms (e.g. DAC,
capabilities, other LSM), then a Landlock hook related to this kind of
object is triggered. The list of programs for this hook is then
evaluated. Each program return a 32-bit value which can deny the action
on a kernel object with a non-zero value. If every programs of the list
return zero, then the action on the object is allowed.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: James Morris <jmorris@namei.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: Will Drewry <wad@chromium.org>
Link: https://lkml.kernel.org/r/c10a503d-5e35-7785-2f3d-25ed8dd63fab@digikod.net
---

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
 include/linux/landlock.h            |  34 ++++
 include/linux/seccomp.h             |   5 +
 include/uapi/linux/seccomp.h        |   1 +
 kernel/fork.c                       |   8 +-
 kernel/seccomp.c                    |   4 +
 security/landlock/Makefile          |   3 +-
 security/landlock/common.h          |  45 +++++
 security/landlock/enforce.c         | 272 ++++++++++++++++++++++++++++
 security/landlock/enforce.h         |  18 ++
 security/landlock/enforce_seccomp.c |  92 ++++++++++
 10 files changed, 480 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/landlock.h
 create mode 100644 security/landlock/enforce.c
 create mode 100644 security/landlock/enforce.h
 create mode 100644 security/landlock/enforce_seccomp.c

diff --git a/include/linux/landlock.h b/include/linux/landlock.h
new file mode 100644
index 000000000000..8ac7942f50fc
--- /dev/null
+++ b/include/linux/landlock.h
@@ -0,0 +1,34 @@
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
+#include <linux/sched.h> /* task_struct */
+
+#if defined(CONFIG_SECCOMP_FILTER) && defined(CONFIG_SECURITY_LANDLOCK)
+extern int landlock_seccomp_prepend_prog(unsigned int flags,
+		const int __user *user_bpf_fd);
+extern void put_seccomp_landlock(struct task_struct *tsk);
+extern void get_seccomp_landlock(struct task_struct *tsk);
+#else /* CONFIG_SECCOMP_FILTER && CONFIG_SECURITY_LANDLOCK */
+static inline int landlock_seccomp_prepend_prog(unsigned int flags,
+		const int __user *user_bpf_fd)
+{
+		return -EINVAL;
+}
+static inline void put_seccomp_landlock(struct task_struct *tsk)
+{
+}
+static inline void get_seccomp_landlock(struct task_struct *tsk)
+{
+}
+#endif /* CONFIG_SECCOMP_FILTER && CONFIG_SECURITY_LANDLOCK */
+
+#endif /* _LINUX_LANDLOCK_H */
diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index 84868d37b35d..106a0ceff3d7 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -11,6 +11,7 @@
 
 #ifdef CONFIG_SECCOMP
 
+#include <linux/landlock.h>
 #include <linux/thread_info.h>
 #include <asm/seccomp.h>
 
@@ -22,6 +23,7 @@ struct seccomp_filter;
  *         system calls available to a process.
  * @filter: must always point to a valid seccomp-filter or NULL as it is
  *          accessed without locking during system call entry.
+ * @landlock_prog_set: contains a set of Landlock programs.
  *
  *          @filter must only be accessed from the context of current as there
  *          is no read locking.
@@ -29,6 +31,9 @@ struct seccomp_filter;
 struct seccomp {
 	int mode;
 	struct seccomp_filter *filter;
+#if defined(CONFIG_SECCOMP_FILTER) && defined(CONFIG_SECURITY_LANDLOCK)
+	struct landlock_prog_set *landlock_prog_set;
+#endif /* CONFIG_SECCOMP_FILTER && CONFIG_SECURITY_LANDLOCK */
 };
 
 #ifdef CONFIG_HAVE_ARCH_SECCOMP_FILTER
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
diff --git a/kernel/fork.c b/kernel/fork.c
index 75675b9bf6df..a1ad5e80611b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -51,6 +51,7 @@
 #include <linux/security.h>
 #include <linux/hugetlb.h>
 #include <linux/seccomp.h>
+#include <linux/landlock.h>
 #include <linux/swap.h>
 #include <linux/syscalls.h>
 #include <linux/jiffies.h>
@@ -454,6 +455,7 @@ void free_task(struct task_struct *tsk)
 	rt_mutex_debug_task_free(tsk);
 	ftrace_graph_exit_task(tsk);
 	put_seccomp_filter(tsk);
+	put_seccomp_landlock(tsk);
 	arch_release_task_struct(tsk);
 	if (tsk->flags & PF_KTHREAD)
 		free_kthread_struct(tsk);
@@ -884,7 +886,10 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 	 * the usage counts on the error path calling free_task.
 	 */
 	tsk->seccomp.filter = NULL;
-#endif
+#ifdef CONFIG_SECURITY_LANDLOCK
+	tsk->seccomp.landlock_prog_set = NULL;
+#endif /* CONFIG_SECURITY_LANDLOCK */
+#endif /* CONFIG_SECCOMP */
 
 	setup_thread_stack(tsk, orig);
 	clear_user_return_notifier(tsk);
@@ -1598,6 +1603,7 @@ static void copy_seccomp(struct task_struct *p)
 
 	/* Ref-count the new filter user, and assign it. */
 	get_seccomp_filter(current);
+	get_seccomp_landlock(current);
 	p->seccomp = current->seccomp;
 
 	/*
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 811b4a86cdf6..e5005a644b23 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -41,6 +41,7 @@
 #include <linux/tracehook.h>
 #include <linux/uaccess.h>
 #include <linux/anon_inodes.h>
+#include <linux/landlock.h>
 
 enum notify_state {
 	SECCOMP_NOTIFY_INIT,
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
index 7205f9a7a2ee..2a1a7082a365 100644
--- a/security/landlock/Makefile
+++ b/security/landlock/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_SECURITY_LANDLOCK) := landlock.o
 
-landlock-y := init.o
+landlock-y := init.o \
+	enforce.o enforce_seccomp.o
diff --git a/security/landlock/common.h b/security/landlock/common.h
index fd63ed1592a7..0c9b5904e7f5 100644
--- a/security/landlock/common.h
+++ b/security/landlock/common.h
@@ -23,4 +23,49 @@
 #define _LANDLOCK_TRIGGER_FS_PICK_LAST	LANDLOCK_TRIGGER_FS_PICK_WRITE
 #define _LANDLOCK_TRIGGER_FS_PICK_MASK	((_LANDLOCK_TRIGGER_FS_PICK_LAST << 1ULL) - 1)
 
+extern struct lsm_blob_sizes landlock_blob_sizes;
+
+struct landlock_prog_list {
+	struct landlock_prog_list *prev;
+	struct bpf_prog *prog;
+	refcount_t usage;
+};
+
+/**
+ * struct landlock_prog_set - Landlock programs enforced on a thread
+ *
+ * This is used for low performance impact when forking a process. Instead of
+ * copying the full array and incrementing the usage of each entries, only
+ * create a pointer to &struct landlock_prog_set and increments its usage. When
+ * prepending a new program, if &struct landlock_prog_set is shared with other
+ * tasks, then duplicate it and prepend the program to this new &struct
+ * landlock_prog_set.
+ *
+ * @usage: reference count to manage the object lifetime. When a thread need to
+ *	   add Landlock programs and if @usage is greater than 1, then the
+ *	   thread must duplicate &struct landlock_prog_set to not change the
+ *	   children's programs as well.
+ * @programs: array of non-NULL &struct landlock_prog_list pointers
+ */
+struct landlock_prog_set {
+	struct landlock_prog_list *programs[_LANDLOCK_HOOK_LAST];
+	refcount_t usage;
+};
+
+/**
+ * get_index - get an index for the programs of struct landlock_prog_set
+ *
+ * @type: a Landlock hook type
+ */
+static inline int get_index(enum landlock_hook_type type)
+{
+	/* type ID > 0 for loaded programs */
+	return type - 1;
+}
+
+static inline enum landlock_hook_type get_type(struct bpf_prog *prog)
+{
+	return prog->aux->extra->subtype.landlock_hook.type;
+}
+
 #endif /* _SECURITY_LANDLOCK_COMMON_H */
diff --git a/security/landlock/enforce.c b/security/landlock/enforce.c
new file mode 100644
index 000000000000..c06063d9d43d
--- /dev/null
+++ b/security/landlock/enforce.c
@@ -0,0 +1,272 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Landlock LSM - enforcing helpers
+ *
+ * Copyright © 2016-2019 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2018-2019 ANSSI
+ */
+
+#include <asm/barrier.h> /* smp_store_release() */
+#include <asm/page.h> /* PAGE_SIZE */
+#include <linux/bpf.h> /* bpf_prog_put() */
+#include <linux/compiler.h> /* READ_ONCE() */
+#include <linux/err.h> /* PTR_ERR() */
+#include <linux/errno.h>
+#include <linux/filter.h> /* struct bpf_prog */
+#include <linux/refcount.h>
+#include <linux/slab.h> /* alloc(), kfree() */
+
+#include "common.h" /* struct landlock_prog_list */
+
+/* TODO: use a dedicated kmem_cache_alloc() instead of k*alloc() */
+
+static void put_landlock_prog_list(struct landlock_prog_list *prog_list)
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
+void landlock_put_prog_set(struct landlock_prog_set *prog_set)
+{
+	if (prog_set && refcount_dec_and_test(&prog_set->usage)) {
+		size_t i;
+
+		for (i = 0; i < ARRAY_SIZE(prog_set->programs); i++)
+			put_landlock_prog_list(prog_set->programs[i]);
+		kfree(prog_set);
+	}
+}
+
+void landlock_get_prog_set(struct landlock_prog_set *prog_set)
+{
+	if (!prog_set)
+		return;
+	refcount_inc(&prog_set->usage);
+}
+
+static struct landlock_prog_set *new_landlock_prog_set(void)
+{
+	struct landlock_prog_set *ret;
+
+	/* array filled with NULL values */
+	ret = kzalloc(sizeof(*ret), GFP_KERNEL);
+	if (!ret)
+		return ERR_PTR(-ENOMEM);
+	refcount_set(&ret->usage, 1);
+	return ret;
+}
+
+/**
+ * store_landlock_prog - prepend and deduplicate a Landlock prog_list
+ *
+ * Prepend @prog to @init_prog_set while ignoring @prog
+ * if they are already in @ref_prog_set.  Whatever is the result of this
+ * function call, you can call bpf_prog_put(@prog) after.
+ *
+ * @init_prog_set: empty prog_set to prepend to
+ * @ref_prog_set: prog_set to check for duplicate programs
+ * @prog: program to prepend
+ *
+ * Return -errno on error or 0 if @prog was successfully stored.
+ */
+static int store_landlock_prog(struct landlock_prog_set *init_prog_set,
+		const struct landlock_prog_set *ref_prog_set,
+		struct bpf_prog *prog)
+{
+	struct landlock_prog_list *tmp_list = NULL;
+	int err;
+	u32 hook_idx;
+	enum landlock_hook_type last_type;
+	struct bpf_prog *new = prog;
+
+	/* allocate all the memory we need */
+	struct landlock_prog_list *new_list;
+
+	last_type = get_type(new);
+
+	/* ignore duplicate programs */
+	if (ref_prog_set) {
+		struct landlock_prog_list *ref;
+
+		hook_idx = get_index(get_type(new));
+		for (ref = ref_prog_set->programs[hook_idx];
+				ref; ref = ref->prev) {
+			if (ref->prog == new)
+				return -EINVAL;
+		}
+	}
+
+	new = bpf_prog_inc(new);
+	if (IS_ERR(new)) {
+		err = PTR_ERR(new);
+		goto put_tmp_list;
+	}
+	new_list = kzalloc(sizeof(*new_list), GFP_KERNEL);
+	if (!new_list) {
+		bpf_prog_put(new);
+		err = -ENOMEM;
+		goto put_tmp_list;
+	}
+	/* ignore Landlock types in this tmp_list */
+	new_list->prog = new;
+	new_list->prev = tmp_list;
+	refcount_set(&new_list->usage, 1);
+	tmp_list = new_list;
+
+	if (!tmp_list)
+		/* inform user space that this program was already added */
+		return -EEXIST;
+
+	/* properly store the list (without error cases) */
+	while (tmp_list) {
+		struct landlock_prog_list *new_list;
+
+		new_list = tmp_list;
+		tmp_list = tmp_list->prev;
+		/* do not increment the previous prog list usage */
+		hook_idx = get_index(get_type(new_list->prog));
+		new_list->prev = init_prog_set->programs[hook_idx];
+		/* no need to add from the last program to the first because
+		 * each of them are a different Landlock type */
+		smp_store_release(&init_prog_set->programs[hook_idx], new_list);
+	}
+	return 0;
+
+put_tmp_list:
+	put_landlock_prog_list(tmp_list);
+	return err;
+}
+
+/* limit Landlock programs set to 256KB */
+#define LANDLOCK_PROGRAMS_MAX_PAGES (1 << 6)
+
+/**
+ * landlock_prepend_prog - attach a Landlock prog_list to @current_prog_set
+ *
+ * Whatever is the result of this function call, you can call
+ * bpf_prog_put(@prog) after.
+ *
+ * @current_prog_set: landlock_prog_set pointer, must be locked (if needed) to
+ *                    prevent a concurrent put/free. This pointer must not be
+ *                    freed after the call.
+ * @prog: non-NULL Landlock prog_list to prepend to @current_prog_set. @prog
+ *	  will be owned by landlock_prepend_prog() and freed if an error
+ *	  happened.
+ *
+ * Return @current_prog_set or a new pointer when OK. Return a pointer error
+ * otherwise.
+ */
+struct landlock_prog_set *landlock_prepend_prog(
+		struct landlock_prog_set *current_prog_set,
+		struct bpf_prog *prog)
+{
+	struct landlock_prog_set *new_prog_set = current_prog_set;
+	unsigned long pages;
+	int err;
+	size_t i;
+	struct landlock_prog_set tmp_prog_set = {};
+
+	if (prog->type != BPF_PROG_TYPE_LANDLOCK_HOOK)
+		return ERR_PTR(-EINVAL);
+
+	/* validate memory size allocation */
+	pages = prog->pages;
+	if (current_prog_set) {
+		size_t i;
+
+		for (i = 0; i < ARRAY_SIZE(current_prog_set->programs); i++) {
+			struct landlock_prog_list *walker_p;
+
+			for (walker_p = current_prog_set->programs[i];
+					walker_p; walker_p = walker_p->prev)
+				pages += walker_p->prog->pages;
+		}
+		/* count a struct landlock_prog_set if we need to allocate one */
+		if (refcount_read(&current_prog_set->usage) != 1)
+			pages += round_up(sizeof(*current_prog_set), PAGE_SIZE)
+				/ PAGE_SIZE;
+	}
+	if (pages > LANDLOCK_PROGRAMS_MAX_PAGES)
+		return ERR_PTR(-E2BIG);
+
+	/* ensure early that we can allocate enough memory for the new
+	 * prog_lists */
+	err = store_landlock_prog(&tmp_prog_set, current_prog_set, prog);
+	if (err)
+		return ERR_PTR(err);
+
+	/*
+	 * Each task_struct points to an array of prog list pointers.  These
+	 * tables are duplicated when additions are made (which means each
+	 * table needs to be refcounted for the processes using it). When a new
+	 * table is created, all the refcounters on the prog_list are bumped (to
+	 * track each table that references the prog). When a new prog is
+	 * added, it's just prepended to the list for the new table to point
+	 * at.
+	 *
+	 * Manage all the possible errors before this step to not uselessly
+	 * duplicate current_prog_set and avoid a rollback.
+	 */
+	if (!new_prog_set) {
+		/*
+		 * If there is no Landlock program set used by the current task,
+		 * then create a new one.
+		 */
+		new_prog_set = new_landlock_prog_set();
+		if (IS_ERR(new_prog_set))
+			goto put_tmp_lists;
+	} else if (refcount_read(&current_prog_set->usage) > 1) {
+		/*
+		 * If the current task is not the sole user of its Landlock
+		 * program set, then duplicate them.
+		 */
+		new_prog_set = new_landlock_prog_set();
+		if (IS_ERR(new_prog_set))
+			goto put_tmp_lists;
+		for (i = 0; i < ARRAY_SIZE(new_prog_set->programs); i++) {
+			new_prog_set->programs[i] =
+				READ_ONCE(current_prog_set->programs[i]);
+			if (new_prog_set->programs[i])
+				refcount_inc(&new_prog_set->programs[i]->usage);
+		}
+
+		/*
+		 * Landlock program set from the current task will not be freed
+		 * here because the usage is strictly greater than 1. It is
+		 * only prevented to be freed by another task thanks to the
+		 * caller of landlock_prepend_prog() which should be locked if
+		 * needed.
+		 */
+		landlock_put_prog_set(current_prog_set);
+	}
+
+	/* prepend tmp_prog_set to new_prog_set */
+	for (i = 0; i < ARRAY_SIZE(tmp_prog_set.programs); i++) {
+		/* get the last new list */
+		struct landlock_prog_list *last_list =
+			tmp_prog_set.programs[i];
+
+		if (last_list) {
+			while (last_list->prev)
+				last_list = last_list->prev;
+			/* no need to increment usage (pointer replacement) */
+			last_list->prev = new_prog_set->programs[i];
+			new_prog_set->programs[i] = tmp_prog_set.programs[i];
+		}
+	}
+	return new_prog_set;
+
+put_tmp_lists:
+	for (i = 0; i < ARRAY_SIZE(tmp_prog_set.programs); i++)
+		put_landlock_prog_list(tmp_prog_set.programs[i]);
+	return new_prog_set;
+}
diff --git a/security/landlock/enforce.h b/security/landlock/enforce.h
new file mode 100644
index 000000000000..39b800d9999f
--- /dev/null
+++ b/security/landlock/enforce.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Landlock LSM - enforcing helpers headers
+ *
+ * Copyright © 2016-2019 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2018-2019 ANSSI
+ */
+
+#ifndef _SECURITY_LANDLOCK_ENFORCE_H
+#define _SECURITY_LANDLOCK_ENFORCE_H
+
+struct landlock_prog_set *landlock_prepend_prog(
+		struct landlock_prog_set *current_prog_set,
+		struct bpf_prog *prog);
+void landlock_put_prog_set(struct landlock_prog_set *prog_set);
+void landlock_get_prog_set(struct landlock_prog_set *prog_set);
+
+#endif /* _SECURITY_LANDLOCK_ENFORCE_H */
diff --git a/security/landlock/enforce_seccomp.c b/security/landlock/enforce_seccomp.c
new file mode 100644
index 000000000000..c38c81e6b01a
--- /dev/null
+++ b/security/landlock/enforce_seccomp.c
@@ -0,0 +1,92 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Landlock LSM - enforcing with seccomp
+ *
+ * Copyright © 2016-2018 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2018-2019 ANSSI
+ */
+
+#ifdef CONFIG_SECCOMP_FILTER
+
+#include <linux/bpf.h> /* bpf_prog_put() */
+#include <linux/capability.h>
+#include <linux/err.h> /* PTR_ERR() */
+#include <linux/errno.h>
+#include <linux/filter.h> /* struct bpf_prog */
+#include <linux/landlock.h>
+#include <linux/refcount.h>
+#include <linux/sched.h> /* current */
+#include <linux/uaccess.h> /* get_user() */
+
+#include "enforce.h"
+
+/* headers in include/linux/landlock.h */
+
+/**
+ * landlock_seccomp_prepend_prog - attach a Landlock program to the current
+ *                                 process
+ *
+ * current->seccomp.landlock_state->prog_set is lazily allocated. When a
+ * process fork, only a pointer is copied.  When a new program is added by a
+ * process, if there is other references to this process' prog_set, then a new
+ * allocation is made to contain an array pointing to Landlock program lists.
+ * This design enable low-performance impact and is memory efficient while
+ * keeping the property of prepend-only programs.
+ *
+ * For now, installing a Landlock prog requires that the requesting task has
+ * the global CAP_SYS_ADMIN. We cannot force the use of no_new_privs to not
+ * exclude containers where a process may legitimately acquire more privileges
+ * thanks to an SUID binary.
+ *
+ * @flags: not used for now, but could be used for TSYNC
+ * @user_bpf_fd: file descriptor pointing to a loaded Landlock prog
+ */
+int landlock_seccomp_prepend_prog(unsigned int flags,
+		const int __user *user_bpf_fd)
+{
+	struct landlock_prog_set *new_prog_set;
+	struct bpf_prog *prog;
+	int bpf_fd, err;
+
+	/* planned to be replaced with a no_new_privs check to allow
+	 * unprivileged tasks */
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
+
+	prog = bpf_prog_get(bpf_fd);
+	if (IS_ERR(prog))
+		return PTR_ERR(prog);
+
+	/*
+	 * We don't need to lock anything for the current process hierarchy,
+	 * everything is guarded by the atomic counters.
+	 */
+	new_prog_set = landlock_prepend_prog(
+			current->seccomp.landlock_prog_set, prog);
+	bpf_prog_put(prog);
+	/* @prog is managed/freed by landlock_prepend_prog() */
+	if (IS_ERR(new_prog_set))
+		return PTR_ERR(new_prog_set);
+	current->seccomp.landlock_prog_set = new_prog_set;
+	return 0;
+}
+
+void put_seccomp_landlock(struct task_struct *tsk)
+{
+	landlock_put_prog_set(tsk->seccomp.landlock_prog_set);
+}
+
+void get_seccomp_landlock(struct task_struct *tsk)
+{
+	landlock_get_prog_set(tsk->seccomp.landlock_prog_set);
+}
+
+#endif /* CONFIG_SECCOMP_FILTER */
-- 
2.20.1

