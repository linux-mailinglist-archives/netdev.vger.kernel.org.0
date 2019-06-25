Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1D2855B16
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 00:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfFYW3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 18:29:01 -0400
Received: from smtp-sh.infomaniak.ch ([128.65.195.4]:46267 "EHLO
        smtp-sh.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbfFYW3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 18:29:01 -0400
Received: from smtp5.infomaniak.ch (smtp5.infomaniak.ch [83.166.132.18])
        by smtp-sh.infomaniak.ch (8.14.5/8.14.5) with ESMTP id x5PLrM1M019856
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jun 2019 23:53:22 +0200
Received: from localhost (ns3096276.ip-94-23-54.eu [94.23.54.103])
        (authenticated bits=0)
        by smtp5.infomaniak.ch (8.14.5/8.14.5) with ESMTP id x5PLrMjQ038842;
        Tue, 25 Jun 2019 23:53:22 +0200
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
Subject: [PATCH bpf-next v9 06/10] landlock: Handle filesystem access control
Date:   Tue, 25 Jun 2019 23:52:35 +0200
Message-Id: <20190625215239.11136-7-mic@digikod.net>
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

This add two Landlock hooks: FS_WALK and FS_PICK.

The FS_WALK hook is used to walk through a file path. A program tied to
this hook will be evaluated for each directory traversal except the last
one if it is the leaf of the path.  It is important to differentiate
this hook from FS_PICK to enable more powerful path evaluation in the
future (cf. Landlock patch v8).

The FS_PICK hook is used to validate a set of actions requested on a
file. This actions are defined with triggers (e.g. read, write, open,
append...).

The Landlock LSM hook registration is done after other LSM to only run
actions from user-space, via eBPF programs, if the access was granted by
major (privileged) LSMs.

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
* add a new LSM_ORDER_LAST, cf. commit e2bc445b66ca ("LSM: Introduce
  enum lsm_order")
* add WARN_ON() for pointer dereferencement
* remove the FS_GET subtype which rely on program chaining
* remove the subtype option which was only used for chaining (with the
  "previous" field)
* remove inode_lookup which depends on the (removed) nameidata security
  blob
* remove eBPF helpers to get and set Landlock inode tags
* do not use task LSM credentials (for now)

Changes since v7:
* major rewrite with clean Landlock hooks able to deal with file paths

Changes since v6:
* add 3 more sub-events: IOCTL, LOCK, FCNTL
  https://lkml.kernel.org/r/2fbc99a6-f190-f335-bd14-04bdeed35571@digikod.net
* use the new security_add_hooks()
* explain the -Werror=unused-function
* constify pointers
* cleanup headers

Changes since v5:
* split hooks.[ch] into hooks.[ch] and hooks_fs.[ch]
* add more documentation
* cosmetic fixes
* rebase (SCALAR_VALUE)

Changes since v4:
* add LSM hook abstraction called Landlock event
  * use the compiler type checking to verify hooks use by an event
  * handle all filesystem related LSM hooks (e.g. file_permission,
    mmap_file, sb_mount...)
* register BPF programs for Landlock just after LSM hooks registration
* move hooks registration after other LSMs
* add failsafes to check if a hook is not used by the kernel
* allow partial raw value access form the context (needed for programs
  generated by LLVM)

Changes since v3:
* split commit
* add hooks dealing with struct inode and struct path pointers:
  inode_permission and inode_getattr
* add abstraction over eBPF helper arguments thanks to wrapping structs
---
 include/linux/lsm_hooks.h    |   1 +
 security/landlock/Makefile   |   3 +-
 security/landlock/common.h   |  10 +
 security/landlock/hooks.c    |  95 ++++++
 security/landlock/hooks.h    |  31 ++
 security/landlock/hooks_fs.c | 568 +++++++++++++++++++++++++++++++++++
 security/landlock/hooks_fs.h |  31 ++
 security/landlock/init.c     |  47 +++
 security/security.c          |  15 +
 9 files changed, 800 insertions(+), 1 deletion(-)
 create mode 100644 security/landlock/hooks.c
 create mode 100644 security/landlock/hooks.h
 create mode 100644 security/landlock/hooks_fs.c
 create mode 100644 security/landlock/hooks_fs.h

diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 47f58cfb6a19..eefe9f214f05 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -2092,6 +2092,7 @@ extern void security_add_hooks(struct security_hook_list *hooks, int count,
 enum lsm_order {
 	LSM_ORDER_FIRST = -1,	/* This is only for capabilities. */
 	LSM_ORDER_MUTABLE = 0,
+	LSM_ORDER_LAST = 1,	/* potentially-unprivileged LSM */
 };
 
 struct lsm_info {
diff --git a/security/landlock/Makefile b/security/landlock/Makefile
index 2a1a7082a365..270ece5d93de 100644
--- a/security/landlock/Makefile
+++ b/security/landlock/Makefile
@@ -1,4 +1,5 @@
 obj-$(CONFIG_SECURITY_LANDLOCK) := landlock.o
 
 landlock-y := init.o \
-	enforce.o enforce_seccomp.o
+	enforce.o enforce_seccomp.o \
+	hooks.o hooks_fs.o
diff --git a/security/landlock/common.h b/security/landlock/common.h
index 0c9b5904e7f5..49b892515144 100644
--- a/security/landlock/common.h
+++ b/security/landlock/common.h
@@ -11,6 +11,7 @@
 
 #include <linux/bpf.h> /* enum bpf_prog_aux */
 #include <linux/filter.h> /* bpf_prog */
+#include <linux/lsm_hooks.h> /* lsm_blob_sizes */
 #include <linux/refcount.h> /* refcount_t */
 #include <uapi/linux/landlock.h> /* enum landlock_hook_type */
 
@@ -68,4 +69,13 @@ static inline enum landlock_hook_type get_type(struct bpf_prog *prog)
 	return prog->aux->extra->subtype.landlock_hook.type;
 }
 
+__maybe_unused
+static bool current_has_prog_type(enum landlock_hook_type hook_type)
+{
+	struct landlock_prog_set *prog_set;
+
+	prog_set = current->seccomp.landlock_prog_set;
+	return (prog_set && prog_set->programs[get_index(hook_type)]);
+}
+
 #endif /* _SECURITY_LANDLOCK_COMMON_H */
diff --git a/security/landlock/hooks.c b/security/landlock/hooks.c
new file mode 100644
index 000000000000..a1620d0481eb
--- /dev/null
+++ b/security/landlock/hooks.c
@@ -0,0 +1,95 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Landlock LSM - hook helpers
+ *
+ * Copyright © 2016-2019 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2018-2019 ANSSI
+ */
+
+#include <asm/current.h>
+#include <linux/bpf.h> /* enum bpf_prog_aux */
+#include <linux/errno.h>
+#include <linux/filter.h> /* BPF_PROG_RUN() */
+#include <linux/rculist.h> /* list_add_tail_rcu */
+#include <uapi/linux/landlock.h> /* struct landlock_context */
+
+#include "common.h" /* struct landlock_rule, get_index() */
+#include "hooks.h" /* landlock_hook_ctx */
+
+#include "hooks_fs.h"
+
+/* return a Landlock program context (e.g. hook_ctx->fs_walk.prog_ctx) */
+static const void *get_ctx(enum landlock_hook_type hook_type,
+		struct landlock_hook_ctx *hook_ctx)
+{
+	switch (hook_type) {
+	case LANDLOCK_HOOK_FS_WALK:
+		return landlock_get_ctx_fs_walk(hook_ctx->fs_walk);
+	case LANDLOCK_HOOK_FS_PICK:
+		return landlock_get_ctx_fs_pick(hook_ctx->fs_pick);
+	}
+	WARN_ON(1);
+	return NULL;
+}
+
+/**
+ * landlock_access_deny - run Landlock programs tied to a hook
+ *
+ * @hook_idx: hook index in the programs array
+ * @ctx: non-NULL valid eBPF context
+ * @prog_set: Landlock program set pointer
+ * @triggers: a bitmask to check if a program should be run
+ *
+ * Return true if at least one program return deny.
+ */
+static bool landlock_access_deny(enum landlock_hook_type hook_type,
+		struct landlock_hook_ctx *hook_ctx,
+		struct landlock_prog_set *prog_set, u64 triggers)
+{
+	struct landlock_prog_list *prog_list, *prev_list = NULL;
+	u32 hook_idx = get_index(hook_type);
+
+	if (!prog_set)
+		return false;
+
+	for (prog_list = prog_set->programs[hook_idx];
+			prog_list; prog_list = prog_list->prev) {
+		u32 ret;
+		const void *prog_ctx;
+
+		/* check if @prog expect at least one of this triggers */
+		if (triggers && !(triggers & prog_list->prog->aux->extra->
+					subtype.landlock_hook.triggers))
+			continue;
+		prog_ctx = get_ctx(hook_type, hook_ctx);
+		if (!prog_ctx || WARN_ON(IS_ERR(prog_ctx)))
+			return true;
+		rcu_read_lock();
+		ret = BPF_PROG_RUN(prog_list->prog, prog_ctx);
+		rcu_read_unlock();
+		/* deny access if a program returns a value different than 0 */
+		if (ret)
+			return true;
+		if (prev_list && prog_list->prev && prog_list->prev->prog->
+				aux->extra->subtype.landlock_hook.type ==
+				prev_list->prog->aux->extra->
+				subtype.landlock_hook.type)
+			WARN_ON(prog_list->prev != prev_list);
+		prev_list = prog_list;
+	}
+	return false;
+}
+
+int landlock_decide(enum landlock_hook_type hook_type,
+		struct landlock_hook_ctx *hook_ctx, u64 triggers)
+{
+	bool deny = false;
+
+#ifdef CONFIG_SECCOMP_FILTER
+	deny = landlock_access_deny(hook_type, hook_ctx,
+			current->seccomp.landlock_prog_set, triggers);
+#endif /* CONFIG_SECCOMP_FILTER */
+
+	/* should we use -EPERM or -EACCES? */
+	return deny ? -EACCES : 0;
+}
diff --git a/security/landlock/hooks.h b/security/landlock/hooks.h
new file mode 100644
index 000000000000..31446e6629fb
--- /dev/null
+++ b/security/landlock/hooks.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Landlock LSM - hooks helpers
+ *
+ * Copyright © 2016-2019 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2018-2019 ANSSI
+ */
+
+#include <asm/current.h>
+#include <linux/sched.h> /* struct task_struct */
+#include <linux/seccomp.h>
+
+#include "hooks_fs.h"
+
+struct landlock_hook_ctx {
+	union {
+		struct landlock_hook_ctx_fs_walk *fs_walk;
+		struct landlock_hook_ctx_fs_pick *fs_pick;
+	};
+};
+
+static inline bool landlocked(const struct task_struct *task)
+{
+#ifdef CONFIG_SECCOMP_FILTER
+	return !!(task->seccomp.landlock_prog_set);
+#else
+	return false;
+#endif /* CONFIG_SECCOMP_FILTER */
+}
+
+int landlock_decide(enum landlock_hook_type, struct landlock_hook_ctx *, u64);
diff --git a/security/landlock/hooks_fs.c b/security/landlock/hooks_fs.c
new file mode 100644
index 000000000000..c3f0f60d72a7
--- /dev/null
+++ b/security/landlock/hooks_fs.c
@@ -0,0 +1,568 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Landlock LSM - filesystem hooks
+ *
+ * Copyright © 2016-2019 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2018-2019 ANSSI
+ */
+
+#include <linux/bpf.h> /* enum bpf_access_type */
+#include <linux/kernel.h> /* ARRAY_SIZE */
+#include <linux/lsm_hooks.h>
+#include <linux/rcupdate.h> /* synchronize_rcu() */
+#include <linux/stat.h> /* S_ISDIR */
+#include <linux/stddef.h> /* offsetof */
+#include <linux/types.h> /* uintptr_t */
+#include <linux/workqueue.h> /* INIT_WORK() */
+
+/* permissions translation */
+#include <linux/fs.h> /* MAY_* */
+#include <linux/mman.h> /* PROT_* */
+#include <linux/namei.h>
+
+/* hook arguments */
+#include <linux/dcache.h> /* struct dentry */
+#include <linux/fs.h> /* struct inode, struct iattr */
+#include <linux/mm_types.h> /* struct vm_area_struct */
+#include <linux/mount.h> /* struct vfsmount */
+#include <linux/path.h> /* struct path */
+#include <linux/sched.h> /* struct task_struct */
+#include <linux/time.h> /* struct timespec */
+
+#include "common.h"
+#include "hooks_fs.h"
+#include "hooks.h"
+
+/* fs_pick */
+
+#include <asm/page.h> /* PAGE_SIZE */
+#include <asm/syscall.h>
+#include <linux/dcache.h> /* d_path, dentry_path_raw */
+#include <linux/err.h> /* *_ERR */
+#include <linux/gfp.h> /* __get_free_page, GFP_KERNEL */
+#include <linux/path.h> /* struct path */
+
+bool landlock_is_valid_access_fs_pick(int off, enum bpf_access_type type,
+		enum bpf_reg_type *reg_type, int *max_size)
+{
+	switch (off) {
+	case offsetof(struct landlock_ctx_fs_pick, inode):
+		if (type != BPF_READ)
+			return false;
+		*reg_type = PTR_TO_INODE;
+		*max_size = sizeof(u64);
+		return true;
+	default:
+		return false;
+	}
+}
+
+bool landlock_is_valid_access_fs_walk(int off, enum bpf_access_type type,
+		enum bpf_reg_type *reg_type, int *max_size)
+{
+	switch (off) {
+	case offsetof(struct landlock_ctx_fs_walk, inode):
+		if (type != BPF_READ)
+			return false;
+		*reg_type = PTR_TO_INODE;
+		*max_size = sizeof(u64);
+		return true;
+	default:
+		return false;
+	}
+}
+
+/* fs_walk */
+
+struct landlock_hook_ctx_fs_walk {
+	struct landlock_ctx_fs_walk prog_ctx;
+};
+
+const struct landlock_ctx_fs_walk *landlock_get_ctx_fs_walk(
+		const struct landlock_hook_ctx_fs_walk *hook_ctx)
+{
+	if (WARN_ON(!hook_ctx))
+		return NULL;
+
+	return &hook_ctx->prog_ctx;
+}
+
+static int decide_fs_walk(int may_mask, struct inode *inode)
+{
+	struct landlock_hook_ctx_fs_walk fs_walk = {};
+	struct landlock_hook_ctx hook_ctx = {
+		.fs_walk = &fs_walk,
+	};
+	const enum landlock_hook_type hook_type = LANDLOCK_HOOK_FS_WALK;
+
+	if (!current_has_prog_type(hook_type))
+		/* no fs_walk */
+		return 0;
+	if (WARN_ON(!inode))
+		return -EFAULT;
+
+	/* init common data: inode, is_dot, is_dotdot, is_root */
+	fs_walk.prog_ctx.inode = (uintptr_t)inode;
+	return landlock_decide(hook_type, &hook_ctx, 0);
+}
+
+/* fs_pick */
+
+struct landlock_hook_ctx_fs_pick {
+	__u64 triggers;
+	struct landlock_ctx_fs_pick prog_ctx;
+};
+
+const struct landlock_ctx_fs_pick *landlock_get_ctx_fs_pick(
+		const struct landlock_hook_ctx_fs_pick *hook_ctx)
+{
+	if (WARN_ON(!hook_ctx))
+		return NULL;
+
+	return &hook_ctx->prog_ctx;
+}
+
+static int decide_fs_pick(__u64 triggers, struct inode *inode)
+{
+	struct landlock_hook_ctx_fs_pick fs_pick = {};
+	struct landlock_hook_ctx hook_ctx = {
+		.fs_pick = &fs_pick,
+	};
+	const enum landlock_hook_type hook_type = LANDLOCK_HOOK_FS_PICK;
+
+	if (WARN_ON(!triggers))
+		return 0;
+	if (!current_has_prog_type(hook_type))
+		/* no fs_pick */
+		return 0;
+	if (WARN_ON(!inode))
+		return -EFAULT;
+
+	fs_pick.triggers = triggers,
+	/* init common data: inode */
+	fs_pick.prog_ctx.inode = (uintptr_t)inode;
+	return landlock_decide(hook_type, &hook_ctx, fs_pick.triggers);
+}
+
+/* helpers */
+
+static u64 fs_may_to_triggers(int may_mask, umode_t mode)
+{
+	u64 ret = 0;
+
+	if (may_mask & MAY_EXEC)
+		ret |= LANDLOCK_TRIGGER_FS_PICK_EXECUTE;
+	if (may_mask & MAY_READ) {
+		if (S_ISDIR(mode))
+			ret |= LANDLOCK_TRIGGER_FS_PICK_READDIR;
+		else
+			ret |= LANDLOCK_TRIGGER_FS_PICK_READ;
+	}
+	if (may_mask & MAY_WRITE)
+		ret |= LANDLOCK_TRIGGER_FS_PICK_WRITE;
+	if (may_mask & MAY_APPEND)
+		ret |= LANDLOCK_TRIGGER_FS_PICK_APPEND;
+	if (may_mask & MAY_OPEN)
+		ret |= LANDLOCK_TRIGGER_FS_PICK_OPEN;
+	if (may_mask & MAY_CHROOT)
+		ret |= LANDLOCK_TRIGGER_FS_PICK_CHROOT;
+	else if (may_mask & MAY_CHDIR)
+		ret |= LANDLOCK_TRIGGER_FS_PICK_CHDIR;
+	/* XXX: ignore MAY_ACCESS */
+	WARN_ON(!ret);
+	return ret;
+}
+
+static inline u64 mem_prot_to_triggers(unsigned long prot, bool private)
+{
+	u64 ret = LANDLOCK_TRIGGER_FS_PICK_MAP;
+
+	/* private mapping do not write to files */
+	if (!private && (prot & PROT_WRITE))
+		ret |= LANDLOCK_TRIGGER_FS_PICK_WRITE;
+	if (prot & PROT_READ)
+		ret |= LANDLOCK_TRIGGER_FS_PICK_READ;
+	if (prot & PROT_EXEC)
+		ret |= LANDLOCK_TRIGGER_FS_PICK_EXECUTE;
+	WARN_ON(!ret);
+	return ret;
+}
+
+/* binder hooks */
+
+static int hook_binder_transfer_file(struct task_struct *from,
+		struct task_struct *to, struct file *file)
+{
+	if (!landlocked(current))
+		return 0;
+	if (WARN_ON(!file))
+		return 0;
+	return decide_fs_pick(LANDLOCK_TRIGGER_FS_PICK_TRANSFER,
+			file_inode(file));
+}
+
+/* sb hooks */
+
+static int hook_sb_statfs(struct dentry *dentry)
+{
+	if (!landlocked(current))
+		return 0;
+	if (WARN_ON(!dentry))
+		return 0;
+	return decide_fs_pick(LANDLOCK_TRIGGER_FS_PICK_GETATTR,
+			dentry->d_inode);
+}
+
+/* TODO: handle mount source and remount */
+static int hook_sb_mount(const char *dev_name, const struct path *path,
+		const char *type, unsigned long flags, void *data)
+{
+	if (!landlocked(current))
+		return 0;
+	if (WARN_ON(!path))
+		return 0;
+	if (WARN_ON(!path->dentry))
+		return 0;
+	return decide_fs_pick(LANDLOCK_TRIGGER_FS_PICK_MOUNTON,
+			path->dentry->d_inode);
+}
+
+/*
+ * The @old_path is similar to a destination mount point.
+ */
+static int hook_sb_pivotroot(const struct path *old_path,
+		const struct path *new_path)
+{
+	int err;
+
+	if (!landlocked(current))
+		return 0;
+	if (WARN_ON(!old_path))
+		return 0;
+	if (WARN_ON(!old_path->dentry))
+		return 0;
+	err = decide_fs_pick(LANDLOCK_TRIGGER_FS_PICK_MOUNTON,
+			old_path->dentry->d_inode);
+	if (err)
+		return err;
+	return decide_fs_pick(LANDLOCK_TRIGGER_FS_PICK_CHROOT,
+			new_path->dentry->d_inode);
+}
+
+/* inode hooks */
+
+/* a directory inode contains only one dentry */
+static int hook_inode_create(struct inode *dir, struct dentry *dentry,
+		umode_t mode)
+{
+	if (!landlocked(current))
+		return 0;
+	return decide_fs_pick(LANDLOCK_TRIGGER_FS_PICK_CREATE, dir);
+}
+
+static int hook_inode_link(struct dentry *old_dentry, struct inode *dir,
+		struct dentry *new_dentry)
+{
+	if (!landlocked(current))
+		return 0;
+	if (WARN_ON(!old_dentry)) {
+		int ret = decide_fs_pick(LANDLOCK_TRIGGER_FS_PICK_LINK,
+				old_dentry->d_inode);
+		if (ret)
+			return ret;
+	}
+	return decide_fs_pick(LANDLOCK_TRIGGER_FS_PICK_LINKTO, dir);
+}
+
+static int hook_inode_unlink(struct inode *dir, struct dentry *dentry)
+{
+	if (!landlocked(current))
+		return 0;
+	if (WARN_ON(!dentry))
+		return 0;
+	return decide_fs_pick(LANDLOCK_TRIGGER_FS_PICK_UNLINK,
+			dentry->d_inode);
+}
+
+static int hook_inode_symlink(struct inode *dir, struct dentry *dentry,
+		const char *old_name)
+{
+	if (!landlocked(current))
+		return 0;
+	return decide_fs_pick(LANDLOCK_TRIGGER_FS_PICK_CREATE, dir);
+}
+
+static int hook_inode_mkdir(struct inode *dir, struct dentry *dentry,
+		umode_t mode)
+{
+	if (!landlocked(current))
+		return 0;
+	return decide_fs_pick(LANDLOCK_TRIGGER_FS_PICK_CREATE, dir);
+}
+
+static int hook_inode_rmdir(struct inode *dir, struct dentry *dentry)
+{
+	if (!landlocked(current))
+		return 0;
+	if (WARN_ON(!dentry))
+		return 0;
+	return decide_fs_pick(LANDLOCK_TRIGGER_FS_PICK_RMDIR, dentry->d_inode);
+}
+
+static int hook_inode_mknod(struct inode *dir, struct dentry *dentry,
+		umode_t mode, dev_t dev)
+{
+	if (!landlocked(current))
+		return 0;
+	return decide_fs_pick(LANDLOCK_TRIGGER_FS_PICK_CREATE, dir);
+}
+
+static int hook_inode_rename(struct inode *old_dir, struct dentry *old_dentry,
+		struct inode *new_dir, struct dentry *new_dentry)
+{
+	if (!landlocked(current))
+		return 0;
+	/* TODO: add artificial walk session from old_dir to old_dentry */
+	if (!WARN_ON(!old_dentry)) {
+		int ret = decide_fs_pick(LANDLOCK_TRIGGER_FS_PICK_RENAME,
+				old_dentry->d_inode);
+		if (ret)
+			return ret;
+	}
+	return decide_fs_pick(LANDLOCK_TRIGGER_FS_PICK_RENAMETO, new_dir);
+}
+
+static int hook_inode_readlink(struct dentry *dentry)
+{
+	if (!landlocked(current))
+		return 0;
+	if (WARN_ON(!dentry))
+		return 0;
+	return decide_fs_pick(LANDLOCK_TRIGGER_FS_PICK_READ, dentry->d_inode);
+}
+
+/*
+ * ignore the inode_follow_link hook (could set is_symlink in the fs_walk
+ * context)
+ */
+
+static int hook_inode_permission(struct inode *inode, int mask)
+{
+	u64 triggers;
+
+	if (!landlocked(current))
+		return 0;
+	if (WARN_ON(!inode))
+		return 0;
+
+	triggers = fs_may_to_triggers(mask, inode->i_mode);
+	/*
+	 * decide_fs_walk() is exclusive with decide_fs_pick(): in a path walk,
+	 * ignore execute-only access on directory for any fs_pick program
+	 */
+	if (triggers == LANDLOCK_TRIGGER_FS_PICK_EXECUTE &&
+			S_ISDIR(inode->i_mode))
+		return decide_fs_walk(mask, inode);
+
+	return decide_fs_pick(triggers, inode);
+}
+
+static int hook_inode_setattr(struct dentry *dentry, struct iattr *attr)
+{
+	if (!landlocked(current))
+		return 0;
+	if (WARN_ON(!dentry))
+		return 0;
+	return decide_fs_pick(LANDLOCK_TRIGGER_FS_PICK_SETATTR,
+			dentry->d_inode);
+}
+
+static int hook_inode_getattr(const struct path *path)
+{
+	/* TODO: link parent inode and path */
+	if (!landlocked(current))
+		return 0;
+	if (WARN_ON(!path))
+		return 0;
+	if (WARN_ON(!path->dentry))
+		return 0;
+	return decide_fs_pick(LANDLOCK_TRIGGER_FS_PICK_GETATTR,
+			path->dentry->d_inode);
+}
+
+static int hook_inode_setxattr(struct dentry *dentry, const char *name,
+		const void *value, size_t size, int flags)
+{
+	if (!landlocked(current))
+		return 0;
+	if (WARN_ON(!dentry))
+		return 0;
+	return decide_fs_pick(LANDLOCK_TRIGGER_FS_PICK_SETATTR,
+			dentry->d_inode);
+}
+
+static int hook_inode_getxattr(struct dentry *dentry, const char *name)
+{
+	if (!landlocked(current))
+		return 0;
+	if (WARN_ON(!dentry))
+		return 0;
+	return decide_fs_pick(LANDLOCK_TRIGGER_FS_PICK_GETATTR,
+			dentry->d_inode);
+}
+
+static int hook_inode_listxattr(struct dentry *dentry)
+{
+	if (!landlocked(current))
+		return 0;
+	if (WARN_ON(!dentry))
+		return 0;
+	return decide_fs_pick(LANDLOCK_TRIGGER_FS_PICK_GETATTR,
+			dentry->d_inode);
+}
+
+static int hook_inode_removexattr(struct dentry *dentry, const char *name)
+{
+	if (!landlocked(current))
+		return 0;
+	if (WARN_ON(!dentry))
+		return 0;
+	return decide_fs_pick(LANDLOCK_TRIGGER_FS_PICK_SETATTR,
+			dentry->d_inode);
+}
+
+static int hook_inode_getsecurity(struct inode *inode, const char *name,
+		void **buffer, bool alloc)
+{
+	if (!landlocked(current))
+		return 0;
+	return decide_fs_pick(LANDLOCK_TRIGGER_FS_PICK_GETATTR, inode);
+}
+
+static int hook_inode_setsecurity(struct inode *inode, const char *name,
+		const void *value, size_t size, int flag)
+{
+	if (!landlocked(current))
+		return 0;
+	return decide_fs_pick(LANDLOCK_TRIGGER_FS_PICK_SETATTR, inode);
+}
+
+static int hook_inode_listsecurity(struct inode *inode, char *buffer,
+		size_t buffer_size)
+{
+	if (!landlocked(current))
+		return 0;
+	return decide_fs_pick(LANDLOCK_TRIGGER_FS_PICK_GETATTR, inode);
+}
+
+/* file hooks */
+
+static int hook_file_ioctl(struct file *file, unsigned int cmd,
+		unsigned long arg)
+{
+	if (!landlocked(current))
+		return 0;
+	if (WARN_ON(!file))
+		return 0;
+	return decide_fs_pick(LANDLOCK_TRIGGER_FS_PICK_IOCTL,
+			file_inode(file));
+}
+
+static int hook_file_lock(struct file *file, unsigned int cmd)
+{
+	if (!landlocked(current))
+		return 0;
+	if (WARN_ON(!file))
+		return 0;
+	return decide_fs_pick(LANDLOCK_TRIGGER_FS_PICK_LOCK, file_inode(file));
+}
+
+static int hook_file_fcntl(struct file *file, unsigned int cmd,
+		unsigned long arg)
+{
+	if (!landlocked(current))
+		return 0;
+	if (WARN_ON(!file))
+		return 0;
+	return decide_fs_pick(LANDLOCK_TRIGGER_FS_PICK_FCNTL,
+			file_inode(file));
+}
+
+static int hook_mmap_file(struct file *file, unsigned long reqprot,
+		unsigned long prot, unsigned long flags)
+{
+	if (!landlocked(current))
+		return 0;
+	/* file can be null for anonymous mmap */
+	if (!file)
+		return 0;
+	return decide_fs_pick(mem_prot_to_triggers(prot, flags & MAP_PRIVATE),
+			file_inode(file));
+}
+
+static int hook_file_mprotect(struct vm_area_struct *vma,
+		unsigned long reqprot, unsigned long prot)
+{
+	if (!landlocked(current))
+		return 0;
+	if (WARN_ON(!vma))
+		return 0;
+	if (!vma->vm_file)
+		return 0;
+	return decide_fs_pick(mem_prot_to_triggers(prot,
+				!(vma->vm_flags & VM_SHARED)),
+			file_inode(vma->vm_file));
+}
+
+static int hook_file_receive(struct file *file)
+{
+	if (!landlocked(current))
+		return 0;
+	if (WARN_ON(!file))
+		return 0;
+	return decide_fs_pick(LANDLOCK_TRIGGER_FS_PICK_RECEIVE,
+			file_inode(file));
+}
+
+static struct security_hook_list landlock_hooks[] = {
+	LSM_HOOK_INIT(binder_transfer_file, hook_binder_transfer_file),
+
+	LSM_HOOK_INIT(sb_statfs, hook_sb_statfs),
+	LSM_HOOK_INIT(sb_mount, hook_sb_mount),
+	LSM_HOOK_INIT(sb_pivotroot, hook_sb_pivotroot),
+
+	LSM_HOOK_INIT(inode_create, hook_inode_create),
+	LSM_HOOK_INIT(inode_link, hook_inode_link),
+	LSM_HOOK_INIT(inode_unlink, hook_inode_unlink),
+	LSM_HOOK_INIT(inode_symlink, hook_inode_symlink),
+	LSM_HOOK_INIT(inode_mkdir, hook_inode_mkdir),
+	LSM_HOOK_INIT(inode_rmdir, hook_inode_rmdir),
+	LSM_HOOK_INIT(inode_mknod, hook_inode_mknod),
+	LSM_HOOK_INIT(inode_rename, hook_inode_rename),
+	LSM_HOOK_INIT(inode_readlink, hook_inode_readlink),
+	LSM_HOOK_INIT(inode_permission, hook_inode_permission),
+	LSM_HOOK_INIT(inode_setattr, hook_inode_setattr),
+	LSM_HOOK_INIT(inode_getattr, hook_inode_getattr),
+	LSM_HOOK_INIT(inode_setxattr, hook_inode_setxattr),
+	LSM_HOOK_INIT(inode_getxattr, hook_inode_getxattr),
+	LSM_HOOK_INIT(inode_listxattr, hook_inode_listxattr),
+	LSM_HOOK_INIT(inode_removexattr, hook_inode_removexattr),
+	LSM_HOOK_INIT(inode_getsecurity, hook_inode_getsecurity),
+	LSM_HOOK_INIT(inode_setsecurity, hook_inode_setsecurity),
+	LSM_HOOK_INIT(inode_listsecurity, hook_inode_listsecurity),
+
+	/* do not handle file_permission for now */
+	LSM_HOOK_INIT(file_ioctl, hook_file_ioctl),
+	LSM_HOOK_INIT(file_lock, hook_file_lock),
+	LSM_HOOK_INIT(file_fcntl, hook_file_fcntl),
+	LSM_HOOK_INIT(mmap_file, hook_mmap_file),
+	LSM_HOOK_INIT(file_mprotect, hook_file_mprotect),
+	LSM_HOOK_INIT(file_receive, hook_file_receive),
+	/* file_open is not handled, use inode_permission instead */
+};
+
+__init void landlock_add_hooks_fs(void)
+{
+	security_add_hooks(landlock_hooks, ARRAY_SIZE(landlock_hooks),
+			LANDLOCK_NAME);
+}
diff --git a/security/landlock/hooks_fs.h b/security/landlock/hooks_fs.h
new file mode 100644
index 000000000000..eeae4dcd842f
--- /dev/null
+++ b/security/landlock/hooks_fs.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Landlock LSM - filesystem hooks
+ *
+ * Copyright © 2017-2019 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2018-2019 ANSSI
+ */
+
+#include <linux/bpf.h> /* enum bpf_access_type */
+
+__init void landlock_add_hooks_fs(void);
+
+/* fs_pick */
+
+struct landlock_hook_ctx_fs_pick;
+
+bool landlock_is_valid_access_fs_pick(int off, enum bpf_access_type type,
+		enum bpf_reg_type *reg_type, int *max_size);
+
+const struct landlock_ctx_fs_pick *landlock_get_ctx_fs_pick(
+		const struct landlock_hook_ctx_fs_pick *hook_ctx);
+
+/* fs_walk */
+
+struct landlock_hook_ctx_fs_walk;
+
+bool landlock_is_valid_access_fs_walk(int off, enum bpf_access_type type,
+		enum bpf_reg_type *reg_type, int *max_size);
+
+const struct landlock_ctx_fs_walk *landlock_get_ctx_fs_walk(
+		const struct landlock_hook_ctx_fs_walk *hook_ctx);
diff --git a/security/landlock/init.c b/security/landlock/init.c
index 03073cd0fc4e..68def2a7af71 100644
--- a/security/landlock/init.c
+++ b/security/landlock/init.c
@@ -9,8 +9,10 @@
 #include <linux/bpf.h> /* enum bpf_access_type */
 #include <linux/capability.h> /* capable */
 #include <linux/filter.h> /* struct bpf_prog */
+#include <linux/lsm_hooks.h>
 
 #include "common.h" /* LANDLOCK_* */
+#include "hooks_fs.h"
 
 static bool bpf_landlock_is_valid_access(int off, int size,
 		enum bpf_access_type type, const struct bpf_prog *prog,
@@ -29,6 +31,23 @@ static bool bpf_landlock_is_valid_access(int off, int size,
 	if (size <= 0 || size > sizeof(__u64))
 		return false;
 
+	/* set register type and max size */
+	switch (prog_subtype->landlock_hook.type) {
+	case LANDLOCK_HOOK_FS_PICK:
+		if (!landlock_is_valid_access_fs_pick(off, type, &reg_type,
+					&max_size))
+			return false;
+		break;
+	case LANDLOCK_HOOK_FS_WALK:
+		if (!landlock_is_valid_access_fs_walk(off, type, &reg_type,
+					&max_size))
+			return false;
+		break;
+	default:
+		WARN_ON(1);
+		return false;
+	}
+
 	/* check memory range access */
 	switch (reg_type) {
 	case NOT_INIT:
@@ -98,6 +117,18 @@ static const struct bpf_func_proto *bpf_landlock_func_proto(
 	default:
 		break;
 	}
+
+	switch (hook_type) {
+	case LANDLOCK_HOOK_FS_WALK:
+	case LANDLOCK_HOOK_FS_PICK:
+		switch (func_id) {
+		case BPF_FUNC_inode_map_lookup:
+			return &bpf_inode_map_lookup_proto;
+		default:
+			break;
+		}
+		break;
+	}
 	return NULL;
 }
 
@@ -108,3 +139,19 @@ const struct bpf_verifier_ops landlock_verifier_ops = {
 };
 
 const struct bpf_prog_ops landlock_prog_ops = {};
+
+static int __init landlock_init(void)
+{
+	pr_info(LANDLOCK_NAME ": Initializing (sandbox with seccomp)\n");
+	landlock_add_hooks_fs();
+	return 0;
+}
+
+struct lsm_blob_sizes landlock_blob_sizes __lsm_ro_after_init = {};
+
+DEFINE_LSM(LANDLOCK_NAME) = {
+	.name = LANDLOCK_NAME,
+	.order = LSM_ORDER_LAST,
+	.blobs = &landlock_blob_sizes,
+	.init = landlock_init,
+};
diff --git a/security/security.c b/security/security.c
index f493db0bf62a..05a23995407d 100644
--- a/security/security.c
+++ b/security/security.c
@@ -263,6 +263,21 @@ static void __init ordered_lsm_parse(const char *order, const char *origin)
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
2.20.1

