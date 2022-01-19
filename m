Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53814493C66
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 15:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355458AbiASO6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 09:58:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44828 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355340AbiASO6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 09:58:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13B79B81A02;
        Wed, 19 Jan 2022 14:58:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68519C004E1;
        Wed, 19 Jan 2022 14:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642604297;
        bh=7YMU4iSFQFCrnBRJ+ncg84L6KbeukGzeA1KEwRRcGI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EFYwWvxA17DACqU/yAgKI5IQS6sdLR1lKgQB2vmJO+hIj7bHoAMx1K/gNYUpPw2cl
         xawZIW+xknPC42LHz01n6c0804Q7HDHbSPzpXXRshxVmy6O4e3cf1/XLYc0AF5WtJH
         6TKY8JTsbyeEtfDvSub2dTOnFNGeJcJSxeDa+lJ13up3uA4itidchTwNEVBV9wmlE7
         rPKVibXBIpsfBI+Y4dT0vTYL77VAElBAJYCRvrSwxvjBcSpZWZmLcO0Z9hIH5B2OrG
         Furop1UuwKd0ZEXTG9VJYhMuYWkISm2V3l9mu2t54IZ8i/sEHuiLr1kxF90HJXFBpk
         hmzRpI1Mx3Idw==
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
Subject: [RFC PATCH v3 9/9] [DO NOT MERGE] out-of-tree: kprobes: Use rethook for kretprobe
Date:   Wed, 19 Jan 2022 23:58:12 +0900
Message-Id: <164260429179.657731.6829755429590905296.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <164260419349.657731.13913104835063027148.stgit@devnote2>
References: <164260419349.657731.13913104835063027148.stgit@devnote2>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the kretprobe return trampoline code with rethook APIs.
Note that this is still under testing. This will work only on x86,
but breaks other architectures.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 arch/x86/include/asm/unwind.h  |    8 +
 arch/x86/kernel/kprobes/core.c |  106 ----------------
 include/linux/kprobes.h        |   85 +------------
 include/linux/sched.h          |    3 
 kernel/exit.c                  |    1 
 kernel/fork.c                  |    3 
 kernel/kprobes.c               |  265 ++++++----------------------------------
 kernel/trace/trace_kprobe.c    |    4 -
 kernel/trace/trace_output.c    |    2 
 9 files changed, 50 insertions(+), 427 deletions(-)

diff --git a/arch/x86/include/asm/unwind.h b/arch/x86/include/asm/unwind.h
index 2a1f8734416d..9237576f7ab4 100644
--- a/arch/x86/include/asm/unwind.h
+++ b/arch/x86/include/asm/unwind.h
@@ -4,7 +4,7 @@
 
 #include <linux/sched.h>
 #include <linux/ftrace.h>
-#include <linux/kprobes.h>
+#include <linux/rethook.h>
 #include <asm/ptrace.h>
 #include <asm/stacktrace.h>
 
@@ -107,9 +107,9 @@ static inline
 unsigned long unwind_recover_kretprobe(struct unwind_state *state,
 				       unsigned long addr, unsigned long *addr_p)
 {
-#ifdef CONFIG_KRETPROBES
-	return is_kretprobe_trampoline(addr) ?
-		kretprobe_find_ret_addr(state->task, addr_p, &state->kr_cur) :
+#ifdef CONFIG_RETHOOK
+	return is_rethook_trampoline(addr) ?
+		rethook_find_ret_addr(state->task, (unsigned long)addr_p, &state->kr_cur) :
 		addr;
 #else
 	return addr;
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index fce99e249d61..b986434035f9 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -801,18 +801,6 @@ set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
 		= (regs->flags & X86_EFLAGS_IF);
 }
 
-void arch_prepare_kretprobe(struct kretprobe_instance *ri, struct pt_regs *regs)
-{
-	unsigned long *sara = stack_addr(regs);
-
-	ri->ret_addr = (kprobe_opcode_t *) *sara;
-	ri->fp = sara;
-
-	/* Replace the return addr with trampoline addr */
-	*sara = (unsigned long) &__kretprobe_trampoline;
-}
-NOKPROBE_SYMBOL(arch_prepare_kretprobe);
-
 static void kprobe_post_process(struct kprobe *cur, struct pt_regs *regs,
 			       struct kprobe_ctlblk *kcb)
 {
@@ -1013,100 +1001,6 @@ int kprobe_int3_handler(struct pt_regs *regs)
 }
 NOKPROBE_SYMBOL(kprobe_int3_handler);
 
-/*
- * When a retprobed function returns, this code saves registers and
- * calls trampoline_handler() runs, which calls the kretprobe's handler.
- */
-asm(
-	".text\n"
-	".global __kretprobe_trampoline\n"
-	".type __kretprobe_trampoline, @function\n"
-	"__kretprobe_trampoline:\n"
-#ifdef CONFIG_X86_64
-	/* Push a fake return address to tell the unwinder it's a kretprobe. */
-	"	pushq $__kretprobe_trampoline\n"
-	UNWIND_HINT_FUNC
-	/* Save the 'sp - 8', this will be fixed later. */
-	"	pushq %rsp\n"
-	"	pushfq\n"
-	SAVE_REGS_STRING
-	"	movq %rsp, %rdi\n"
-	"	call trampoline_handler\n"
-	RESTORE_REGS_STRING
-	/* In trampoline_handler(), 'regs->flags' is copied to 'regs->sp'. */
-	"	addq $8, %rsp\n"
-	"	popfq\n"
-#else
-	/* Push a fake return address to tell the unwinder it's a kretprobe. */
-	"	pushl $__kretprobe_trampoline\n"
-	UNWIND_HINT_FUNC
-	/* Save the 'sp - 4', this will be fixed later. */
-	"	pushl %esp\n"
-	"	pushfl\n"
-	SAVE_REGS_STRING
-	"	movl %esp, %eax\n"
-	"	call trampoline_handler\n"
-	RESTORE_REGS_STRING
-	/* In trampoline_handler(), 'regs->flags' is copied to 'regs->sp'. */
-	"	addl $4, %esp\n"
-	"	popfl\n"
-#endif
-	"	ret\n"
-	".size __kretprobe_trampoline, .-__kretprobe_trampoline\n"
-);
-NOKPROBE_SYMBOL(__kretprobe_trampoline);
-/*
- * __kretprobe_trampoline() skips updating frame pointer. The frame pointer
- * saved in trampoline_handler() points to the real caller function's
- * frame pointer. Thus the __kretprobe_trampoline() doesn't have a
- * standard stack frame with CONFIG_FRAME_POINTER=y.
- * Let's mark it non-standard function. Anyway, FP unwinder can correctly
- * unwind without the hint.
- */
-STACK_FRAME_NON_STANDARD_FP(__kretprobe_trampoline);
-
-/* This is called from kretprobe_trampoline_handler(). */
-void arch_kretprobe_fixup_return(struct pt_regs *regs,
-				 kprobe_opcode_t *correct_ret_addr)
-{
-	unsigned long *frame_pointer = &regs->sp + 1;
-
-	/* Replace fake return address with real one. */
-	*frame_pointer = (unsigned long)correct_ret_addr;
-}
-
-/*
- * Called from __kretprobe_trampoline
- */
-__used __visible void trampoline_handler(struct pt_regs *regs)
-{
-	unsigned long *frame_pointer;
-
-	/* fixup registers */
-	regs->cs = __KERNEL_CS;
-#ifdef CONFIG_X86_32
-	regs->gs = 0;
-#endif
-	regs->ip = (unsigned long)&__kretprobe_trampoline;
-	regs->orig_ax = ~0UL;
-	regs->sp += sizeof(long);
-	frame_pointer = &regs->sp + 1;
-
-	/*
-	 * The return address at 'frame_pointer' is recovered by the
-	 * arch_kretprobe_fixup_return() which called from the
-	 * kretprobe_trampoline_handler().
-	 */
-	kretprobe_trampoline_handler(regs, frame_pointer);
-
-	/*
-	 * Copy FLAGS to 'pt_regs::sp' so that __kretprobe_trapmoline()
-	 * can do RET right after POPF.
-	 */
-	regs->sp = regs->flags;
-}
-NOKPROBE_SYMBOL(trampoline_handler);
-
 int kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 {
 	struct kprobe *cur = kprobe_running();
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 8c8f7a4d93af..0742b38181c1 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -26,8 +26,7 @@
 #include <linux/rcupdate.h>
 #include <linux/mutex.h>
 #include <linux/ftrace.h>
-#include <linux/refcount.h>
-#include <linux/freelist.h>
+#include <linux/rethook.h>
 #include <asm/kprobes.h>
 
 #ifdef CONFIG_KPROBES
@@ -137,10 +136,6 @@ static inline bool kprobe_ftrace(struct kprobe *p)
  * ignored, due to maxactive being too low.
  *
  */
-struct kretprobe_holder {
-	struct kretprobe	*rp;
-	refcount_t		ref;
-};
 
 struct kretprobe {
 	struct kprobe kp;
@@ -149,21 +144,13 @@ struct kretprobe {
 	int maxactive;
 	int nmissed;
 	size_t data_size;
-	struct freelist_head freelist;
-	struct kretprobe_holder *rph;
+	struct rethook *rh;
 };
 
 #define KRETPROBE_MAX_DATA_SIZE	4096
 
 struct kretprobe_instance {
-	union {
-		struct freelist_node freelist;
-		struct rcu_head rcu;
-	};
-	struct llist_node llist;
-	struct kretprobe_holder *rph;
-	kprobe_opcode_t *ret_addr;
-	void *fp;
+	struct rethook_node node;
 	char data[];
 };
 
@@ -186,57 +173,17 @@ extern void kprobe_busy_begin(void);
 extern void kprobe_busy_end(void);
 
 #ifdef CONFIG_KRETPROBES
-extern void arch_prepare_kretprobe(struct kretprobe_instance *ri,
-				   struct pt_regs *regs);
 extern int arch_trampoline_kprobe(struct kprobe *p);
 
-void arch_kretprobe_fixup_return(struct pt_regs *regs,
-				 kprobe_opcode_t *correct_ret_addr);
-
-void __kretprobe_trampoline(void);
-/*
- * Since some architecture uses structured function pointer,
- * use dereference_function_descriptor() to get real function address.
- */
-static nokprobe_inline void *kretprobe_trampoline_addr(void)
-{
-	return dereference_kernel_function_descriptor(__kretprobe_trampoline);
-}
-
-/* If the trampoline handler called from a kprobe, use this version */
-unsigned long __kretprobe_trampoline_handler(struct pt_regs *regs,
-					     void *frame_pointer);
-
-static nokprobe_inline
-unsigned long kretprobe_trampoline_handler(struct pt_regs *regs,
-					   void *frame_pointer)
-{
-	unsigned long ret;
-	/*
-	 * Set a dummy kprobe for avoiding kretprobe recursion.
-	 * Since kretprobe never runs in kprobe handler, no kprobe must
-	 * be running at this point.
-	 */
-	kprobe_busy_begin();
-	ret = __kretprobe_trampoline_handler(regs, frame_pointer);
-	kprobe_busy_end();
-
-	return ret;
-}
-
 static nokprobe_inline struct kretprobe *get_kretprobe(struct kretprobe_instance *ri)
 {
 	RCU_LOCKDEP_WARN(!rcu_read_lock_any_held(),
 		"Kretprobe is accessed from instance under preemptive context");
 
-	return READ_ONCE(ri->rph->rp);
+	return (struct kretprobe *)READ_ONCE(ri->node.rethook->data);
 }
 
 #else /* !CONFIG_KRETPROBES */
-static inline void arch_prepare_kretprobe(struct kretprobe *rp,
-					struct pt_regs *regs)
-{
-}
 static inline int arch_trampoline_kprobe(struct kprobe *p)
 {
 	return 0;
@@ -400,8 +347,6 @@ void unregister_kretprobe(struct kretprobe *rp);
 int register_kretprobes(struct kretprobe **rps, int num);
 void unregister_kretprobes(struct kretprobe **rps, int num);
 
-void kprobe_flush_task(struct task_struct *tk);
-
 void kprobe_free_init_mem(void);
 
 int disable_kprobe(struct kprobe *kp);
@@ -510,28 +455,6 @@ static inline bool is_kprobe_optinsn_slot(unsigned long addr)
 }
 #endif /* !CONFIG_OPTPROBES */
 
-#ifdef CONFIG_KRETPROBES
-static nokprobe_inline bool is_kretprobe_trampoline(unsigned long addr)
-{
-	return (void *)addr == kretprobe_trampoline_addr();
-}
-
-unsigned long kretprobe_find_ret_addr(struct task_struct *tsk, void *fp,
-				      struct llist_node **cur);
-#else
-static nokprobe_inline bool is_kretprobe_trampoline(unsigned long addr)
-{
-	return false;
-}
-
-static nokprobe_inline
-unsigned long kretprobe_find_ret_addr(struct task_struct *tsk, void *fp,
-				      struct llist_node **cur)
-{
-	return 0;
-}
-#endif
-
 /* Returns true if kprobes handled the fault */
 static nokprobe_inline bool kprobe_page_fault(struct pt_regs *regs,
 					      unsigned int trap)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2bfabf5355b7..b0fa25523a35 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1470,9 +1470,6 @@ struct task_struct {
 	int				mce_count;
 #endif
 
-#ifdef CONFIG_KRETPROBES
-	struct llist_head               kretprobe_instances;
-#endif
 #ifdef CONFIG_RETHOOK
 	struct llist_head               rethooks;
 #endif
diff --git a/kernel/exit.c b/kernel/exit.c
index a39a321c1f37..e3a05589faa4 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -169,7 +169,6 @@ static void delayed_put_task_struct(struct rcu_head *rhp)
 {
 	struct task_struct *tsk = container_of(rhp, struct task_struct, rcu);
 
-	kprobe_flush_task(tsk);
 	rethook_flush_task(tsk);
 	perf_event_delayed_put(tsk);
 	trace_sched_process_free(tsk);
diff --git a/kernel/fork.c b/kernel/fork.c
index ffae38be64c4..bce71536c20a 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2279,9 +2279,6 @@ static __latent_entropy struct task_struct *copy_process(
 	p->task_works = NULL;
 	clear_posix_cputimers_work(p);
 
-#ifdef CONFIG_KRETPROBES
-	p->kretprobe_instances.first = NULL;
-#endif
 #ifdef CONFIG_RETHOOK
 	p->rethooks.first = NULL;
 #endif
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 21eccc961bba..1f7bba138f7e 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1216,26 +1216,6 @@ void kprobes_inc_nmissed_count(struct kprobe *p)
 }
 NOKPROBE_SYMBOL(kprobes_inc_nmissed_count);
 
-static void free_rp_inst_rcu(struct rcu_head *head)
-{
-	struct kretprobe_instance *ri = container_of(head, struct kretprobe_instance, rcu);
-
-	if (refcount_dec_and_test(&ri->rph->ref))
-		kfree(ri->rph);
-	kfree(ri);
-}
-NOKPROBE_SYMBOL(free_rp_inst_rcu);
-
-static void recycle_rp_inst(struct kretprobe_instance *ri)
-{
-	struct kretprobe *rp = get_kretprobe(ri);
-
-	if (likely(rp))
-		freelist_add(&ri->freelist, &rp->freelist);
-	else
-		call_rcu(&ri->rcu, free_rp_inst_rcu);
-}
-NOKPROBE_SYMBOL(recycle_rp_inst);
 
 static struct kprobe kprobe_busy = {
 	.addr = (void *) get_kprobe,
@@ -1257,56 +1237,6 @@ void kprobe_busy_end(void)
 	preempt_enable();
 }
 
-/*
- * This function is called from delayed_put_task_struct() when a task is
- * dead and cleaned up to recycle any kretprobe instances associated with
- * this task. These left over instances represent probed functions that
- * have been called but will never return.
- */
-void kprobe_flush_task(struct task_struct *tk)
-{
-	struct kretprobe_instance *ri;
-	struct llist_node *node;
-
-	/* Early boot, not yet initialized. */
-	if (unlikely(!kprobes_initialized))
-		return;
-
-	kprobe_busy_begin();
-
-	node = __llist_del_all(&tk->kretprobe_instances);
-	while (node) {
-		ri = container_of(node, struct kretprobe_instance, llist);
-		node = node->next;
-
-		recycle_rp_inst(ri);
-	}
-
-	kprobe_busy_end();
-}
-NOKPROBE_SYMBOL(kprobe_flush_task);
-
-static inline void free_rp_inst(struct kretprobe *rp)
-{
-	struct kretprobe_instance *ri;
-	struct freelist_node *node;
-	int count = 0;
-
-	node = rp->freelist.head;
-	while (node) {
-		ri = container_of(node, struct kretprobe_instance, freelist);
-		node = node->next;
-
-		kfree(ri);
-		count++;
-	}
-
-	if (refcount_sub_and_test(count, &rp->rph->ref)) {
-		kfree(rp->rph);
-		rp->rph = NULL;
-	}
-}
-
 /* Add the new probe to 'ap->list'. */
 static int add_new_kprobe(struct kprobe *ap, struct kprobe *p)
 {
@@ -1862,139 +1792,6 @@ static struct notifier_block kprobe_exceptions_nb = {
 };
 
 #ifdef CONFIG_KRETPROBES
-
-/* This assumes the 'tsk' is the current task or the is not running. */
-static kprobe_opcode_t *__kretprobe_find_ret_addr(struct task_struct *tsk,
-						  struct llist_node **cur)
-{
-	struct kretprobe_instance *ri = NULL;
-	struct llist_node *node = *cur;
-
-	if (!node)
-		node = tsk->kretprobe_instances.first;
-	else
-		node = node->next;
-
-	while (node) {
-		ri = container_of(node, struct kretprobe_instance, llist);
-		if (ri->ret_addr != kretprobe_trampoline_addr()) {
-			*cur = node;
-			return ri->ret_addr;
-		}
-		node = node->next;
-	}
-	return NULL;
-}
-NOKPROBE_SYMBOL(__kretprobe_find_ret_addr);
-
-/**
- * kretprobe_find_ret_addr -- Find correct return address modified by kretprobe
- * @tsk: Target task
- * @fp: A frame pointer
- * @cur: a storage of the loop cursor llist_node pointer for next call
- *
- * Find the correct return address modified by a kretprobe on @tsk in unsigned
- * long type. If it finds the return address, this returns that address value,
- * or this returns 0.
- * The @tsk must be 'current' or a task which is not running. @fp is a hint
- * to get the currect return address - which is compared with the
- * kretprobe_instance::fp field. The @cur is a loop cursor for searching the
- * kretprobe return addresses on the @tsk. The '*@cur' should be NULL at the
- * first call, but '@cur' itself must NOT NULL.
- */
-unsigned long kretprobe_find_ret_addr(struct task_struct *tsk, void *fp,
-				      struct llist_node **cur)
-{
-	struct kretprobe_instance *ri = NULL;
-	kprobe_opcode_t *ret;
-
-	if (WARN_ON_ONCE(!cur))
-		return 0;
-
-	do {
-		ret = __kretprobe_find_ret_addr(tsk, cur);
-		if (!ret)
-			break;
-		ri = container_of(*cur, struct kretprobe_instance, llist);
-	} while (ri->fp != fp);
-
-	return (unsigned long)ret;
-}
-NOKPROBE_SYMBOL(kretprobe_find_ret_addr);
-
-void __weak arch_kretprobe_fixup_return(struct pt_regs *regs,
-					kprobe_opcode_t *correct_ret_addr)
-{
-	/*
-	 * Do nothing by default. Please fill this to update the fake return
-	 * address on the stack with the correct one on each arch if possible.
-	 */
-}
-
-unsigned long __kretprobe_trampoline_handler(struct pt_regs *regs,
-					     void *frame_pointer)
-{
-	kprobe_opcode_t *correct_ret_addr = NULL;
-	struct kretprobe_instance *ri = NULL;
-	struct llist_node *first, *node = NULL;
-	struct kretprobe *rp;
-
-	/* Find correct address and all nodes for this frame. */
-	correct_ret_addr = __kretprobe_find_ret_addr(current, &node);
-	if (!correct_ret_addr) {
-		pr_err("kretprobe: Return address not found, not execute handler. Maybe there is a bug in the kernel.\n");
-		BUG_ON(1);
-	}
-
-	/*
-	 * Set the return address as the instruction pointer, because if the
-	 * user handler calls stack_trace_save_regs() with this 'regs',
-	 * the stack trace will start from the instruction pointer.
-	 */
-	instruction_pointer_set(regs, (unsigned long)correct_ret_addr);
-
-	/* Run the user handler of the nodes. */
-	first = current->kretprobe_instances.first;
-	while (first) {
-		ri = container_of(first, struct kretprobe_instance, llist);
-
-		if (WARN_ON_ONCE(ri->fp != frame_pointer))
-			break;
-
-		rp = get_kretprobe(ri);
-		if (rp && rp->handler) {
-			struct kprobe *prev = kprobe_running();
-
-			__this_cpu_write(current_kprobe, &rp->kp);
-			ri->ret_addr = correct_ret_addr;
-			rp->handler(ri, regs);
-			__this_cpu_write(current_kprobe, prev);
-		}
-		if (first == node)
-			break;
-
-		first = first->next;
-	}
-
-	arch_kretprobe_fixup_return(regs, correct_ret_addr);
-
-	/* Unlink all nodes for this frame. */
-	first = current->kretprobe_instances.first;
-	current->kretprobe_instances.first = node->next;
-	node->next = NULL;
-
-	/* Recycle free instances. */
-	while (first) {
-		ri = container_of(first, struct kretprobe_instance, llist);
-		first = first->next;
-
-		recycle_rp_inst(ri);
-	}
-
-	return (unsigned long)correct_ret_addr;
-}
-NOKPROBE_SYMBOL(__kretprobe_trampoline_handler)
-
 /*
  * This kprobe pre_handler is registered with every kretprobe. When probe
  * hits it will set up the return probe.
@@ -2003,29 +1800,47 @@ static int pre_handler_kretprobe(struct kprobe *p, struct pt_regs *regs)
 {
 	struct kretprobe *rp = container_of(p, struct kretprobe, kp);
 	struct kretprobe_instance *ri;
-	struct freelist_node *fn;
+	struct rethook_node *rhn;
 
-	fn = freelist_try_get(&rp->freelist);
-	if (!fn) {
+	rhn = rethook_try_get(rp->rh);
+	if (!rhn) {
 		rp->nmissed++;
 		return 0;
 	}
 
-	ri = container_of(fn, struct kretprobe_instance, freelist);
+	ri = container_of(rhn, struct kretprobe_instance, node);
 
 	if (rp->entry_handler && rp->entry_handler(ri, regs)) {
-		freelist_add(&ri->freelist, &rp->freelist);
+		rethook_recycle(rhn);
 		return 0;
 	}
 
-	arch_prepare_kretprobe(ri, regs);
-
-	__llist_add(&ri->llist, &current->kretprobe_instances);
+	rethook_hook(rhn, regs);
 
 	return 0;
 }
 NOKPROBE_SYMBOL(pre_handler_kretprobe);
 
+static void kretprobe_rethook_handler(struct rethook_node *rh, void *data,
+				      struct pt_regs *regs)
+{
+	struct kretprobe *rp = (struct kretprobe *)data;
+	struct kretprobe_instance *ri;
+	struct kprobe_ctlblk *kcb;
+
+	if (!data)
+		return;
+
+	__this_cpu_write(current_kprobe, &rp->kp);
+	kcb = get_kprobe_ctlblk();
+	kcb->kprobe_status = KPROBE_HIT_ACTIVE;
+
+	ri = container_of(rh, struct kretprobe_instance, node);
+	rp->handler(ri, regs);
+
+	__this_cpu_write(current_kprobe, NULL);
+}
+
 bool __weak arch_kprobe_on_func_entry(unsigned long offset)
 {
 	return !offset;
@@ -2100,30 +1915,28 @@ int register_kretprobe(struct kretprobe *rp)
 		rp->maxactive = num_possible_cpus();
 #endif
 	}
-	rp->freelist.head = NULL;
-	rp->rph = kzalloc(sizeof(struct kretprobe_holder), GFP_KERNEL);
-	if (!rp->rph)
+	rp->rh = rethook_alloc((void *)rp, kretprobe_rethook_handler);
+	if (!rp->rh)
 		return -ENOMEM;
 
-	rp->rph->rp = rp;
 	for (i = 0; i < rp->maxactive; i++) {
 		inst = kzalloc(sizeof(struct kretprobe_instance) +
 			       rp->data_size, GFP_KERNEL);
 		if (inst == NULL) {
-			refcount_set(&rp->rph->ref, i);
-			free_rp_inst(rp);
+			rethook_free(rp->rh);
+			rp->rh = NULL;
 			return -ENOMEM;
 		}
-		inst->rph = rp->rph;
-		freelist_add(&inst->freelist, &rp->freelist);
+		rethook_add_node(rp->rh, &inst->node);
 	}
-	refcount_set(&rp->rph->ref, i);
 
 	rp->nmissed = 0;
 	/* Establish function entry probe point */
 	ret = register_kprobe(&rp->kp);
-	if (ret != 0)
-		free_rp_inst(rp);
+	if (ret != 0) {
+		rethook_free(rp->rh);
+		rp->rh = NULL;
+	}
 	return ret;
 }
 EXPORT_SYMBOL_GPL(register_kretprobe);
@@ -2162,16 +1975,16 @@ void unregister_kretprobes(struct kretprobe **rps, int num)
 	for (i = 0; i < num; i++) {
 		if (__unregister_kprobe_top(&rps[i]->kp) < 0)
 			rps[i]->kp.addr = NULL;
-		rps[i]->rph->rp = NULL;
+		rcu_assign_pointer(rps[i]->rh->data, NULL);
+		barrier();
+		rethook_free(rps[i]->rh);
 	}
 	mutex_unlock(&kprobe_mutex);
 
 	synchronize_rcu();
 	for (i = 0; i < num; i++) {
-		if (rps[i]->kp.addr) {
+		if (rps[i]->kp.addr)
 			__unregister_kprobe_bottom(&rps[i]->kp);
-			free_rp_inst(rps[i]);
-		}
 	}
 }
 EXPORT_SYMBOL_GPL(unregister_kretprobes);
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 4e1257f50aa3..3d88cf33f7cc 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1446,7 +1446,7 @@ __kretprobe_trace_func(struct trace_kprobe *tk, struct kretprobe_instance *ri,
 	fbuffer.regs = regs;
 	entry = fbuffer.entry = ring_buffer_event_data(fbuffer.event);
 	entry->func = (unsigned long)tk->rp.kp.addr;
-	entry->ret_ip = (unsigned long)ri->ret_addr;
+	entry->ret_ip = ri->node.ret_addr;
 	store_trace_args(&entry[1], &tk->tp, regs, sizeof(*entry), dsize);
 
 	trace_event_buffer_commit(&fbuffer);
@@ -1641,7 +1641,7 @@ kretprobe_perf_func(struct trace_kprobe *tk, struct kretprobe_instance *ri,
 		return;
 
 	entry->func = (unsigned long)tk->rp.kp.addr;
-	entry->ret_ip = (unsigned long)ri->ret_addr;
+	entry->ret_ip = ri->node.ret_addr;
 	store_trace_args(&entry[1], &tk->tp, regs, sizeof(*entry), dsize);
 	perf_trace_buf_submit(entry, size, rctx, call->event.type, 1, regs,
 			      head, NULL);
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 3547e7176ff7..b1a391f7bc78 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -349,7 +349,7 @@ EXPORT_SYMBOL_GPL(trace_output_call);
 
 static inline const char *kretprobed(const char *name, unsigned long addr)
 {
-	if (is_kretprobe_trampoline(addr))
+	if (is_rethook_trampoline(addr))
 		return "[unknown/kretprobe'd]";
 	return name;
 }

