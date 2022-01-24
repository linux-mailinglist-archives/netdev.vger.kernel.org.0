Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8633349844E
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 17:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243570AbiAXQKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 11:10:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238880AbiAXQKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 11:10:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE0A9C06173D;
        Mon, 24 Jan 2022 08:10:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61089608CC;
        Mon, 24 Jan 2022 16:10:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A73C340E5;
        Mon, 24 Jan 2022 16:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643040603;
        bh=aNWUOW9Q7KhlaUepBXrjXEXQnpvNHPK+88nxgR5yfRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SL86thZ0KedJhD3bngrL/M0zmvH3AzNBZ7Y6OCE2+of7E2a6eeRNDcTMscwN+KZo9
         sdr4kWKz3aoJFowVSLESefdIR5nLuXh7sC8QzwgUffWqDCZQK+nfMalnASpmHrqtEV
         gMk9iMyAejHwQV4RnLvqDbKbD9XIqG4hwbdyEUc+moq5O2+9fuQ9pZiTryJGLZ/jVb
         FNgQcE3mtfSxhFYjz7tSrSrE1SgUijtDPhj6k6472uLuVYxYzzAuJzgAaXr2NBiREk
         +gz0mMdgp3GbqCVxF9AX1OPLA4A3zks0UyL1YeUosevg+RiVv/knacjQh7ZmoulzT/
         wM+3z30WIUOBw==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH v4 3/9] rethook: Add a generic return hook
Date:   Tue, 25 Jan 2022 01:09:57 +0900
Message-Id: <164304059693.1680787.4157399767871417383.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <164304056155.1680787.14081905648619647218.stgit@devnote2>
References: <164304056155.1680787.14081905648619647218.stgit@devnote2>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a return hook framework which hooks the function
return. Most of the idea came from the kretprobe, but
this is independent from kretprobe.
Note that this is expected to be used with other
function entry hooking feature, like ftrace, fprobe,
adn kprobes. Eventually this will replace the
kretprobe (e.g. kprobe + rethook = kretprobe), but
at this moment, this is just a additional hook.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 Changes in v4:
  - Fix rethook_trampoline_handler() loops as same as
    what currently kretprobe does.  This will fix some
    stacktrace issue in the rethook handler.
---
 include/linux/rethook.h |   99 +++++++++++++++
 include/linux/sched.h   |    3 
 kernel/exit.c           |    2 
 kernel/fork.c           |    3 
 kernel/trace/Kconfig    |   11 ++
 kernel/trace/Makefile   |    1 
 kernel/trace/rethook.c  |  311 +++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 430 insertions(+)
 create mode 100644 include/linux/rethook.h
 create mode 100644 kernel/trace/rethook.c

diff --git a/include/linux/rethook.h b/include/linux/rethook.h
new file mode 100644
index 000000000000..39cfbff1a03c
--- /dev/null
+++ b/include/linux/rethook.h
@@ -0,0 +1,99 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Return hooking with list-based shadow stack.
+ */
+#ifndef _LINUX_RETHOOK_H
+#define _LINUX_RETHOOK_H
+
+#include <linux/compiler.h>
+#include <linux/freelist.h>
+#include <linux/llist.h>
+#include <linux/rcupdate.h>
+#include <linux/refcount.h>
+
+struct rethook_node;
+
+typedef void (*rethook_handler_t) (struct rethook_node *, void *, struct pt_regs *);
+
+/**
+ * struct rethook - The rethook management data structure.
+ * @data: The user-defined data storage.
+ * @handler: The user-defined return hook handler.
+ * @pool: The pool of struct rethook_node.
+ * @ref: The reference counter.
+ * @rcu: The rcu_head for deferred freeing.
+ *
+ * Don't embed to another data structure, because this is a self-destructive
+ * data structure when all rethook_node are freed.
+ */
+struct rethook {
+	void			*data;
+	rethook_handler_t	handler;
+	struct freelist_head	pool;
+	refcount_t		ref;
+	struct rcu_head		rcu;
+};
+
+/**
+ * struct rethook_node - The rethook shadow-stack entry node.
+ * @freelist: The freelist, linked to struct rethook::pool.
+ * @rcu: The rcu_head for deferred freeing.
+ * @llist: The llist, linked to a struct task_struct::rethooks.
+ * @rethook: The pointer to the struct rethook.
+ * @ret_addr: The storage for the real return address.
+ * @frame: The stroage for the frame pointer.
+ *
+ * You can embed this with your extended data structure to store any data
+ * on the entry of shadow stack.
+ */
+struct rethook_node {
+	union {
+		struct freelist_node freelist;
+		struct rcu_head      rcu;
+	};
+	struct llist_node	llist;
+	struct rethook		*rethook;
+	unsigned long		ret_addr;
+	unsigned long		frame;
+};
+
+struct rethook *rethook_alloc(void *data, rethook_handler_t handler);
+void rethook_free(struct rethook *rh);
+void rethook_add_node(struct rethook *rh, struct rethook_node *node);
+struct rethook_node *rethook_try_get(struct rethook *rh);
+void rethook_recycle(struct rethook_node *node);
+void rethook_hook(struct rethook_node *node, struct pt_regs *regs);
+unsigned long rethook_find_ret_addr(struct task_struct *tsk, unsigned long frame,
+				    struct llist_node **cur);
+
+/* Arch dependent code must implement arch_* and trampoline code */
+void arch_rethook_prepare(struct rethook_node *node, struct pt_regs *regs);
+void arch_rethook_trampoline(void);
+
+/**
+ * is_rethook_trampoline() - Check whether the address is rethook trampoline
+ * @addr: The address to be checked
+ *
+ * Return true if the @addr is rethook trampoline address.
+ */
+static inline bool is_rethook_trampoline(unsigned long addr)
+{
+	return addr == (unsigned long)arch_rethook_trampoline;
+}
+
+/* If the architecture needs a fixup the return address, implement it. */
+void arch_rethook_fixup_return(struct pt_regs *regs,
+			       unsigned long correct_ret_addr);
+
+/* Generic trampoline handler, arch code must prepare asm stub */
+unsigned long rethook_trampoline_handler(struct pt_regs *regs,
+					 unsigned long frame);
+
+#ifdef CONFIG_RETHOOK
+void rethook_flush_task(struct task_struct *tk);
+#else
+#define rethook_flush_task(tsk)	do { } while (0)
+#endif
+
+#endif
+
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 78c351e35fec..2bfabf5355b7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1473,6 +1473,9 @@ struct task_struct {
 #ifdef CONFIG_KRETPROBES
 	struct llist_head               kretprobe_instances;
 #endif
+#ifdef CONFIG_RETHOOK
+	struct llist_head               rethooks;
+#endif
 
 #ifdef CONFIG_ARCH_HAS_PARANOID_L1D_FLUSH
 	/*
diff --git a/kernel/exit.c b/kernel/exit.c
index f702a6a63686..a39a321c1f37 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -64,6 +64,7 @@
 #include <linux/compat.h>
 #include <linux/io_uring.h>
 #include <linux/kprobes.h>
+#include <linux/rethook.h>
 
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
@@ -169,6 +170,7 @@ static void delayed_put_task_struct(struct rcu_head *rhp)
 	struct task_struct *tsk = container_of(rhp, struct task_struct, rcu);
 
 	kprobe_flush_task(tsk);
+	rethook_flush_task(tsk);
 	perf_event_delayed_put(tsk);
 	trace_sched_process_free(tsk);
 	put_task_struct(tsk);
diff --git a/kernel/fork.c b/kernel/fork.c
index 3244cc56b697..ffae38be64c4 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2282,6 +2282,9 @@ static __latent_entropy struct task_struct *copy_process(
 #ifdef CONFIG_KRETPROBES
 	p->kretprobe_instances.first = NULL;
 #endif
+#ifdef CONFIG_RETHOOK
+	p->rethooks.first = NULL;
+#endif
 
 	/*
 	 * Ensure that the cgroup subsystem policies allow the new process to be
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 23483dd474b0..4d27e56c6e76 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -10,6 +10,17 @@ config USER_STACKTRACE_SUPPORT
 config NOP_TRACER
 	bool
 
+config HAVE_RETHOOK
+	bool
+
+config RETHOOK
+	bool
+	depends on HAVE_RETHOOK
+	help
+	  Enable generic return hooking feature. This is an internal
+	  API, which will be used by other function-entry hooking
+	  feature like fprobe and kprobes.
+
 config HAVE_FUNCTION_TRACER
 	bool
 	help
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 79255f9de9a4..c6f11a139eac 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -98,6 +98,7 @@ obj-$(CONFIG_UPROBE_EVENTS) += trace_uprobe.o
 obj-$(CONFIG_BOOTTIME_TRACING) += trace_boot.o
 obj-$(CONFIG_FTRACE_RECORD_RECURSION) += trace_recursion_record.o
 obj-$(CONFIG_FPROBE) += fprobe.o
+obj-$(CONFIG_RETHOOK) += rethook.o
 
 obj-$(CONFIG_TRACEPOINT_BENCHMARK) += trace_benchmark.o
 
diff --git a/kernel/trace/rethook.c b/kernel/trace/rethook.c
new file mode 100644
index 000000000000..76c9848b44a9
--- /dev/null
+++ b/kernel/trace/rethook.c
@@ -0,0 +1,311 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define pr_fmt(fmt) "rethook: " fmt
+
+#include <linux/bug.h>
+#include <linux/kallsyms.h>
+#include <linux/kprobes.h>
+#include <linux/preempt.h>
+#include <linux/rethook.h>
+#include <linux/slab.h>
+#include <linux/sort.h>
+
+/* Return hook list (shadow stack by list) */
+
+/*
+ * This function is called from delayed_put_task_struct() when a task is
+ * dead and cleaned up to recycle any kretprobe instances associated with
+ * this task. These left over instances represent probed functions that
+ * have been called but will never return.
+ */
+void rethook_flush_task(struct task_struct *tk)
+{
+	struct rethook_node *rhn;
+	struct llist_node *node;
+
+	preempt_disable();
+
+	node = __llist_del_all(&tk->rethooks);
+	while (node) {
+		rhn = container_of(node, struct rethook_node, llist);
+		node = node->next;
+		rethook_recycle(rhn);
+	}
+
+	preempt_enable();
+}
+
+static void rethook_free_rcu(struct rcu_head *head)
+{
+	struct rethook *rh = container_of(head, struct rethook, rcu);
+	struct rethook_node *rhn;
+	struct freelist_node *node;
+	int count = 1;
+
+	node = rh->pool.head;
+	while (node) {
+		rhn = container_of(node, struct rethook_node, freelist);
+		node = node->next;
+		kfree(rhn);
+		count++;
+	}
+
+	/* The rh->ref is the number of pooled node + 1 */
+	if (refcount_sub_and_test(count, &rh->ref))
+		kfree(rh);
+}
+
+/**
+ * rethook_free() - Free struct rethook.
+ * @rh: the struct rethook to be freed.
+ *
+ * Free the rethook. Before calling this function, user must ensure the
+ * @rh::data is cleaned if needed (or, the handler can access it after
+ * calling this function.) This function will set the @rh to be freed
+ * after all rethook_node are freed (not soon). And the caller must
+ * not touch @rh after calling this.
+ */
+void rethook_free(struct rethook *rh)
+{
+	rcu_assign_pointer(rh->handler, NULL);
+
+	call_rcu(&rh->rcu, rethook_free_rcu);
+}
+
+/**
+ * rethook_alloc() - Allocate struct rethook.
+ * @data: a data to pass the @handler when hooking the return.
+ * @handler: the return hook callback function.
+ *
+ * Allocate and initialize a new rethook with @data and @handler.
+ * Return NULL if memory allocation fails or @handler is NULL.
+ * Note that @handler == NULL means this rethook is going to be freed.
+ */
+struct rethook *rethook_alloc(void *data, rethook_handler_t handler)
+{
+	struct rethook *rh = kzalloc(sizeof(struct rethook), GFP_KERNEL);
+
+	if (!rh || !handler)
+		return NULL;
+
+	rh->data = data;
+	rh->handler = handler;
+	rh->pool.head = NULL;
+	refcount_set(&rh->ref, 1);
+
+	return rh;
+}
+
+/**
+ * rethook_add_node() - Add a new node to the rethook.
+ * @rh: the struct rethook.
+ * @node: the struct rethook_node to be added.
+ *
+ * Add @node to @rh. User must allocate @node (as a part of user's
+ * data structure.) The @node fields are initialized in this function.
+ */
+void rethook_add_node(struct rethook *rh, struct rethook_node *node)
+{
+	node->rethook = rh;
+	freelist_add(&node->freelist, &rh->pool);
+	refcount_inc(&rh->ref);
+}
+
+static void free_rethook_node_rcu(struct rcu_head *head)
+{
+	struct rethook_node *node = container_of(head, struct rethook_node, rcu);
+
+	if (refcount_dec_and_test(&node->rethook->ref))
+		kfree(node->rethook);
+	kfree(node);
+}
+
+/**
+ * rethook_recycle() - return the node to rethook.
+ * @node: The struct rethook_node to be returned.
+ *
+ * Return back the @node to @node::rethook. If the @node::rethook is already
+ * marked as freed, this will free the @node.
+ */
+void rethook_recycle(struct rethook_node *node)
+{
+	lockdep_assert_preemption_disabled();
+
+	if (likely(READ_ONCE(node->rethook->handler)))
+		freelist_add(&node->freelist, &node->rethook->pool);
+	else
+		call_rcu(&node->rcu, free_rethook_node_rcu);
+}
+NOKPROBE_SYMBOL(rethook_recycle);
+
+/**
+ * rethook_try_get() - get an unused rethook node.
+ * @rh: The struct rethook which pools the nodes.
+ *
+ * Get an unused rethook node from @rh. If the node pool is empty, this
+ * will return NULL. Caller must disable preemption.
+ */
+struct rethook_node *rethook_try_get(struct rethook *rh)
+{
+	rethook_handler_t handler = READ_ONCE(rh->handler);
+	struct freelist_node *fn;
+
+	lockdep_assert_preemption_disabled();
+
+	/* Check whether @rh is going to be freed. */
+	if (unlikely(!handler))
+		return NULL;
+
+	fn = freelist_try_get(&rh->pool);
+	if (!fn)
+		return NULL;
+
+	return container_of(fn, struct rethook_node, freelist);
+}
+NOKPROBE_SYMBOL(rethook_try_get);
+
+/**
+ * rethook_hook() - Hook the current function return.
+ * @node: The struct rethook node to hook the function return.
+ * @regs: The struct pt_regs for the function entry.
+ *
+ * Hook the current running function return. This must be called when the
+ * function entry (or at least @regs must be the registers of the function
+ * entry.)
+ */
+void rethook_hook(struct rethook_node *node, struct pt_regs *regs)
+{
+	arch_rethook_prepare(node, regs);
+	__llist_add(&node->llist, &current->rethooks);
+}
+NOKPROBE_SYMBOL(rethook_hook);
+
+/* This assumes the 'tsk' is the current task or the is not running. */
+static unsigned long __rethook_find_ret_addr(struct task_struct *tsk,
+					     struct llist_node **cur)
+{
+	struct rethook_node *rh = NULL;
+	struct llist_node *node = *cur;
+
+	if (!node)
+		node = tsk->rethooks.first;
+	else
+		node = node->next;
+
+	while (node) {
+		rh = container_of(node, struct rethook_node, llist);
+		if (rh->ret_addr != (unsigned long)arch_rethook_trampoline) {
+			*cur = node;
+			return rh->ret_addr;
+		}
+		node = node->next;
+	}
+	return 0;
+}
+NOKPROBE_SYMBOL(__rethook_find_ret_addr);
+
+/**
+ * rethook_find_ret_addr -- Find correct return address modified by rethook
+ * @tsk: Target task
+ * @frame: A frame pointer
+ * @cur: a storage of the loop cursor llist_node pointer for next call
+ *
+ * Find the correct return address modified by a rethook on @tsk in unsigned
+ * long type. If it finds the return address, this returns that address value,
+ * or this returns 0.
+ * The @tsk must be 'current' or a task which is not running. @frame is a hint
+ * to get the currect return address - which is compared with the
+ * rethook::frame field. The @cur is a loop cursor for searching the
+ * kretprobe return addresses on the @tsk. The '*@cur' should be NULL at the
+ * first call, but '@cur' itself must NOT NULL.
+ */
+unsigned long rethook_find_ret_addr(struct task_struct *tsk, unsigned long frame,
+				    struct llist_node **cur)
+{
+	struct rethook_node *rhn = NULL;
+	unsigned long ret;
+
+	if (WARN_ON_ONCE(!cur))
+		return 0;
+
+	do {
+		ret = __rethook_find_ret_addr(tsk, cur);
+		if (!ret)
+			break;
+		rhn = container_of(*cur, struct rethook_node, llist);
+	} while (rhn->frame != frame);
+
+	return ret;
+}
+NOKPROBE_SYMBOL(rethook_find_ret_addr);
+
+void __weak arch_rethook_fixup_return(struct pt_regs *regs,
+				      unsigned long correct_ret_addr)
+{
+	/*
+	 * Do nothing by default. If the architecture which uses a
+	 * frame pointer to record real return address on the stack,
+	 * it should fill this function to fixup the return address
+	 * so that stacktrace works from the rethook handler.
+	 */
+}
+
+/* This function will be called from each arch-defined trampoline. */
+unsigned long rethook_trampoline_handler(struct pt_regs *regs,
+					 unsigned long frame)
+{
+	struct llist_node *first, *node = NULL;
+	unsigned long correct_ret_addr;
+	rethook_handler_t handler;
+	struct rethook_node *rhn;
+
+	correct_ret_addr = __rethook_find_ret_addr(current, &node);
+	if (!correct_ret_addr) {
+		pr_err("rethook: Return address not found! Maybe there is a bug in the kernel\n");
+		BUG_ON(1);
+	}
+
+	instruction_pointer_set(regs, correct_ret_addr);
+
+	/*
+	 * These loops must be protected from rethook_free_rcu() because those
+	 * are accessing 'rhn->rethook'.
+	 */
+	preempt_disable();
+
+	/*
+	 * Run the handler on the shadow stack. Do not unlink the list here because
+	 * stackdump inside the handlers needs to decode it.
+	 */
+	first = current->rethooks.first;
+	while (first) {
+		rhn = container_of(first, struct rethook_node, llist);
+		if (WARN_ON_ONCE(rhn->frame != frame))
+			break;
+		handler = READ_ONCE(rhn->rethook->handler);
+		if (handler)
+			handler(rhn, rhn->rethook->data, regs);
+
+		if (first == node)
+			break;
+		first = first->next;
+	}
+
+	/* Fixup registers for returning to correct address. */
+	arch_rethook_fixup_return(regs, correct_ret_addr);
+
+	/* Unlink used shadow stack */
+	first = current->rethooks.first;
+	current->rethooks.first = node->next;
+	node->next = NULL;
+
+	while (first) {
+		rhn = container_of(first, struct rethook_node, llist);
+		first = first->next;
+		rethook_recycle(rhn);
+	}
+	preempt_enable();
+
+	return correct_ret_addr;
+}
+NOKPROBE_SYMBOL(rethook_trampoline_handler);

