Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B839FEE7F9
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 20:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728556AbfKDTJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 14:09:42 -0500
Received: from smtp-sh2.infomaniak.ch ([128.65.195.6]:35633 "EHLO
        smtp-sh2.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728377AbfKDTJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 14:09:41 -0500
Received: from smtp-2-0000.mail.infomaniak.ch (smtp-2-0000.mail.infomaniak.ch [10.5.36.107])
        by smtp-sh2.infomaniak.ch (8.14.4/8.14.4/Debian-8+deb8u2) with ESMTP id xA4HM9IY110703
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 4 Nov 2019 18:22:09 +0100
Received: from localhost (unknown [94.23.54.103])
        by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 92A0A100D319D;
        Mon,  4 Nov 2019 18:22:08 +0100 (CET)
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
Subject: [PATCH bpf-next v13 5/7] bpf,landlock: Add task_landlock_ptrace_ancestor() helper
Date:   Mon,  4 Nov 2019 18:21:44 +0100
Message-Id: <20191104172146.30797-6-mic@digikod.net>
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

This new task_landlock_ptrace_ancestor() helper can be used to identify
if the Landlock domain tied to the current tracer is in the same
hierarchy as the domain of tracee.  This may be a way for user space to
programmatically defines that a set of tasks is less privileged than
another set of tasks.

Indeed, ptrace(2) can be used to impersonate an unsandboxed process and
lead to a privilege escalation.  A common use-case when sandboxing a
process is then to forbid it to debug a less-privileged process.  A
sandbox process (tracer) should only be allowed to trace another process
(tracee) if the tracee has fewer privileges than the tracer.  This
policy can be implemented with this helper.

More complex helpers could be added in the future to enable other ways
to check the relation between the tracer and the tracee (e.g. check
other program types or other hierarchies) if there is a use case.

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
* new patch taking inspiration from the previous static ptrace policy
---
 include/linux/bpf.h            |  2 +
 include/uapi/linux/bpf.h       | 21 ++++++++++-
 kernel/bpf/verifier.c          |  4 ++
 security/landlock/bpf_ptrace.c | 68 ++++++++++++++++++++++++++++++++++
 security/landlock/bpf_verify.c |  4 ++
 5 files changed, 98 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 819a3e207438..67ec198a90cb 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -214,6 +214,7 @@ enum bpf_arg_type {
 	ARG_PTR_TO_LONG,	/* pointer to long */
 	ARG_PTR_TO_SOCKET,	/* pointer to bpf_sock (fullsock) */
 	ARG_PTR_TO_BTF_ID,	/* pointer to in-kernel struct */
+	ARG_PTR_TO_TASK,	/* pointer to task_struct */
 };
 
 /* type of values returned from helper functions */
@@ -1088,6 +1089,7 @@ extern const struct bpf_func_proto bpf_get_local_storage_proto;
 extern const struct bpf_func_proto bpf_strtol_proto;
 extern const struct bpf_func_proto bpf_strtoul_proto;
 extern const struct bpf_func_proto bpf_tcp_sock_proto;
+extern const struct bpf_func_proto bpf_task_landlock_ptrace_ancestor_proto;
 
 /* Shared helpers among cBPF and eBPF. */
 void bpf_user_rnd_init_once(void);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 6e4147790f96..c88436b97163 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2777,6 +2777,24 @@ union bpf_attr {
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
@@ -2890,7 +2908,8 @@ union bpf_attr {
 	FN(sk_storage_delete),		\
 	FN(send_signal),		\
 	FN(tcp_gen_syncookie),		\
-	FN(skb_output),
+	FN(skb_output),			\
+	FN(task_landlock_ptrace_ancestor),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ebf1991906b7..af8f1a777a2d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3492,6 +3492,10 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 regno,
 		    type != PTR_TO_MAP_VALUE &&
 		    type != expected_type)
 			goto err_type;
+	} else if (arg_type == ARG_PTR_TO_TASK) {
+		expected_type = PTR_TO_TASK;
+		if (type != expected_type)
+			goto err_type;
 	} else {
 		verbose(env, "unsupported arg_type %d\n", arg_type);
 		return -EFAULT;
diff --git a/security/landlock/bpf_ptrace.c b/security/landlock/bpf_ptrace.c
index 2ec73078ad01..0e1362951463 100644
--- a/security/landlock/bpf_ptrace.c
+++ b/security/landlock/bpf_ptrace.c
@@ -7,9 +7,13 @@
  */
 
 #include <linux/bpf.h>
+#include <linux/cred.h>
+#include <linux/kernel.h>
+#include <linux/rcupdate.h>
 #include <uapi/linux/landlock.h>
 
 #include "bpf_ptrace.h"
+#include "common.h"
 
 bool landlock_is_valid_access_ptrace(int off, enum bpf_access_type type,
 		enum bpf_reg_type *reg_type, int *max_size)
@@ -28,3 +32,67 @@ bool landlock_is_valid_access_ptrace(int off, enum bpf_access_type type,
 		return false;
 	}
 }
+
+/**
+ * domain_ptrace_ancestor - check domain ordering according to ptrace
+ *
+ * @parent: a parent domain
+ * @child: a potential child of @parent
+ *
+ * Check if the @parent domain is less or equal to (i.e. a subset of) the
+ * @child domain.
+ */
+static int domain_ptrace_ancestor(const struct landlock_domain *parent,
+		const struct landlock_domain *child)
+{
+	const struct landlock_prog_list *child_progs, *parent_progs;
+	const size_t hook = get_hook_index(LANDLOCK_HOOK_PTRACE);
+
+	if (!parent || !child)
+		/* @parent or @child has no ptrace restriction */
+		return -EINVAL;
+	parent_progs = parent->programs[hook];
+	child_progs = child->programs[hook];
+	if (!parent_progs || !child_progs)
+		/* @parent or @child has no ptrace restriction */
+		return -EINVAL;
+	if (child_progs == parent_progs)
+		/* @parent is at the same level as @child */
+		return 0;
+	for (child_progs = child_progs->prev; child_progs;
+			child_progs = child_progs->prev) {
+		if (child_progs == parent_progs)
+			/* @parent is one of the ancestors of @child */
+			return 1;
+	}
+	/*
+	 * Either there is no relationship between @parent and @child, or
+	 * @child is one of the ancestors of @parent.
+	 */
+	return -ENOENT;
+}
+
+/*
+ * Cf. include/uapi/linux/bpf.h - bpf_task_landlock_ptrace_ancestor
+ */
+BPF_CALL_2(bpf_task_landlock_ptrace_ancestor, const struct task_struct *,
+		parent, const struct task_struct *, child)
+{
+	const struct landlock_domain *dom_parent, *dom_child;
+
+	WARN_ON_ONCE(!rcu_read_lock_held());
+	if (WARN_ON(!parent || !child))
+		return -EFAULT;
+	dom_parent = landlock_cred(__task_cred(parent))->domain;
+	dom_child = landlock_cred(__task_cred(child))->domain;
+	return domain_ptrace_ancestor(dom_parent, dom_child);
+}
+
+const struct bpf_func_proto bpf_task_landlock_ptrace_ancestor_proto = {
+	.func		= bpf_task_landlock_ptrace_ancestor,
+	.gpl_only	= false,
+	.pkt_access	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_TASK,
+	.arg2_type	= ARG_PTR_TO_TASK,
+};
diff --git a/security/landlock/bpf_verify.c b/security/landlock/bpf_verify.c
index 6ed921588178..a1d2db75d51d 100644
--- a/security/landlock/bpf_verify.c
+++ b/security/landlock/bpf_verify.c
@@ -70,6 +70,10 @@ static const struct bpf_func_proto *bpf_landlock_func_proto(
 		return &bpf_map_update_elem_proto;
 	case BPF_FUNC_map_delete_elem:
 		return &bpf_map_delete_elem_proto;
+	case BPF_FUNC_task_landlock_ptrace_ancestor:
+		if (get_hook_type(prog) == LANDLOCK_HOOK_PTRACE)
+			return &bpf_task_landlock_ptrace_ancestor_proto;
+		return NULL;
 	default:
 		return NULL;
 	}
-- 
2.23.0

