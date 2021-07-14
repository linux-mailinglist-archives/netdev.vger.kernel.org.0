Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7E33C7ADB
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 03:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237331AbhGNBIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 21:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237312AbhGNBIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 21:08:30 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E031C06178A;
        Tue, 13 Jul 2021 18:05:37 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id g24so293406pji.4;
        Tue, 13 Jul 2021 18:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eacp3CaPnxd9tnxGadm6RTAWaGRkAaLUStKAsDbnIxo=;
        b=P+s5i5PNJ1BZiosjGs9+X+Uul2bCNfWUGSNBBxGoqAJsq3lG3o9dMND892blJOsNkq
         bItt/ny4UtU6DuXt0ul3eD6Alam/ITYqc+MGJEGjlqdkGIv7lmqXVFrICPueo1eEg+ZA
         IIauxbzjIWMU5d8rLV6t868k32Qd5odDTDTgHoNXZKXe8iUR2kpdGvgcDeDEaABf9uId
         cWnVM0xwLcudfrLyEWEpToYwz7Vb9fq5l4i7osuTPSiG8GlpiGotLX1NkPHyQDoox1tJ
         chZ2ndXcarYW+HMzh2XXcphM3/0tgvWz04ObbD7pk/B7LasdsMNyTd6cYB+FG6jkFC2o
         kJag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eacp3CaPnxd9tnxGadm6RTAWaGRkAaLUStKAsDbnIxo=;
        b=KsfTBXleajwr30NBN+UF8I0yHqQ9X6DuY+WNbuofH1035bqZlnunKiwNXXEPVcfjnP
         wG1Oi35SpVzKjWl0GMgfupYgRN9Mdw1+FFaTpTqWH4SStsW9bUR1tZVXaoITHZKzjapy
         u+5OUEkH10cC1KUh+8CvlwKM+u9Okbq2BFzy2FEsiXtaOGTJOCTBYR5NGpF6iNW7eV5V
         3rF2qVqU/CBNIEl/mMMy2lmepW+u38OPZJ/WYjQbYOqP9KZRfchvQ2cxiIsdkPQw7Kb3
         7K3QWTXba6ca5KgtWLray1lITRBoCYwcS8oHaiVUj4cAQWTDnUEA2pRTLVAj3ObS5t4h
         zNrQ==
X-Gm-Message-State: AOAM532XcYRsYQiTCI6eFKwIuIXI41LqGNqOVFbiqLcgCxpvwv0BxbQc
        BQyaguYBbt7HTlLq0AGI6iY=
X-Google-Smtp-Source: ABdhPJxO+0XJG5fDAVbx1R6KeunJfY7QCTsuOcpYHMryFET9Zuc7aG8hNAFMdYYwcL2OZ3Tq+AANqg==
X-Received: by 2002:a17:90a:940e:: with SMTP id r14mr1048433pjo.41.1626224736780;
        Tue, 13 Jul 2021 18:05:36 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:10f1])
        by smtp.gmail.com with ESMTPSA id cx4sm4073560pjb.53.2021.07.13.18.05.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Jul 2021 18:05:36 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v6 bpf-next 08/11] bpf: Implement verifier support for validation of async callbacks.
Date:   Tue, 13 Jul 2021 18:05:16 -0700
Message-Id: <20210714010519.37922-9-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210714010519.37922-1-alexei.starovoitov@gmail.com>
References: <20210714010519.37922-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

bpf_for_each_map_elem() and bpf_timer_set_callback() helpers are relying on
PTR_TO_FUNC infra in the verifier to validate addresses to subprograms
and pass them into the helpers as function callbacks.
In case of bpf_for_each_map_elem() the callback is invoked synchronously
and the verifier treats it as a normal subprogram call by adding another
bpf_func_state and new frame in __check_func_call().
bpf_timer_set_callback() doesn't invoke the callback directly.
The subprogram will be called asynchronously from bpf_timer_cb().
Teach the verifier to validate such async callbacks as special kind
of jump by pushing verifier state into stack and let pop_stack() process it.

Special care needs to be taken during state pruning.
The call insn doing bpf_timer_set_callback has to be a prune_point.
Otherwise short timer callbacks might not have prune points in front of
bpf_timer_set_callback() which means is_state_visited() will be called
after this call insn is processed in __check_func_call(). Which means that
another async_cb state will be pushed to be walked later and the verifier
will eventually hit BPF_COMPLEXITY_LIMIT_JMP_SEQ limit.
Since push_async_cb() looks like another push_stack() branch the
infinite loop detection will trigger false positive. To recognize
this case mark such states as in_async_callback_fn.
To distinguish infinite loop in async callback vs the same callback called
with different arguments for different map and timer add async_entry_cnt
to bpf_func_state.

Enforce return zero from async callbacks.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpf_verifier.h |   9 ++-
 kernel/bpf/helpers.c         |   8 +--
 kernel/bpf/verifier.c        | 123 ++++++++++++++++++++++++++++++++++-
 3 files changed, 131 insertions(+), 9 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 5d3169b57e6e..242d0b1a0772 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -208,12 +208,19 @@ struct bpf_func_state {
 	 * zero == main subprog
 	 */
 	u32 subprogno;
+	/* Every bpf_timer_start will increment async_entry_cnt.
+	 * It's used to distinguish:
+	 * void foo(void) { for(;;); }
+	 * void foo(void) { bpf_timer_set_callback(,foo); }
+	 */
+	u32 async_entry_cnt;
+	bool in_callback_fn;
+	bool in_async_callback_fn;
 
 	/* The following fields should be last. See copy_func_state() */
 	int acquired_refs;
 	struct bpf_reference_state *refs;
 	int allocated_stack;
-	bool in_callback_fn;
 	struct bpf_stack_state *stack;
 };
 
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index f133038a4bce..81ccebe2c9ba 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1043,7 +1043,6 @@ static enum hrtimer_restart bpf_timer_cb(struct hrtimer *hrtimer)
 	void *callback_fn;
 	void *key;
 	u32 idx;
-	int ret;
 
 	callback_fn = rcu_dereference_check(t->callback_fn, rcu_read_lock_bh_held());
 	if (!callback_fn)
@@ -1066,10 +1065,9 @@ static enum hrtimer_restart bpf_timer_cb(struct hrtimer *hrtimer)
 		key = value - round_up(map->key_size, 8);
 	}
 
-	ret = BPF_CAST_CALL(callback_fn)((u64)(long)map,
-					 (u64)(long)key,
-					 (u64)(long)value, 0, 0);
-	WARN_ON(ret != 0); /* Next patch moves this check into the verifier */
+	BPF_CAST_CALL(callback_fn)((u64)(long)map, (u64)(long)key,
+				   (u64)(long)value, 0, 0);
+	/* The verifier checked that return value is zero. */
 
 	this_cpu_write(hrtimer_running, NULL);
 out:
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1511f92b4cf4..ab6ce598a652 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -735,6 +735,10 @@ static void print_verifier_state(struct bpf_verifier_env *env,
 			if (state->refs[i].id)
 				verbose(env, ",%d", state->refs[i].id);
 	}
+	if (state->in_callback_fn)
+		verbose(env, " cb");
+	if (state->in_async_callback_fn)
+		verbose(env, " async_cb");
 	verbose(env, "\n");
 }
 
@@ -1527,6 +1531,54 @@ static void init_func_state(struct bpf_verifier_env *env,
 	init_reg_state(env, state);
 }
 
+/* Similar to push_stack(), but for async callbacks */
+static struct bpf_verifier_state *push_async_cb(struct bpf_verifier_env *env,
+						int insn_idx, int prev_insn_idx,
+						int subprog)
+{
+	struct bpf_verifier_stack_elem *elem;
+	struct bpf_func_state *frame;
+
+	elem = kzalloc(sizeof(struct bpf_verifier_stack_elem), GFP_KERNEL);
+	if (!elem)
+		goto err;
+
+	elem->insn_idx = insn_idx;
+	elem->prev_insn_idx = prev_insn_idx;
+	elem->next = env->head;
+	elem->log_pos = env->log.len_used;
+	env->head = elem;
+	env->stack_size++;
+	if (env->stack_size > BPF_COMPLEXITY_LIMIT_JMP_SEQ) {
+		verbose(env,
+			"The sequence of %d jumps is too complex for async cb.\n",
+			env->stack_size);
+		goto err;
+	}
+	/* Unlike push_stack() do not copy_verifier_state().
+	 * The caller state doesn't matter.
+	 * This is async callback. It starts in a fresh stack.
+	 * Initialize it similar to do_check_common().
+	 */
+	elem->st.branches = 1;
+	frame = kzalloc(sizeof(*frame), GFP_KERNEL);
+	if (!frame)
+		goto err;
+	init_func_state(env, frame,
+			BPF_MAIN_FUNC /* callsite */,
+			0 /* frameno within this callchain */,
+			subprog /* subprog number within this prog */);
+	elem->st.frame[0] = frame;
+	return &elem->st;
+err:
+	free_verifier_state(env->cur_state, true);
+	env->cur_state = NULL;
+	/* pop all elements and return */
+	while (!pop_stack(env, NULL, NULL, false));
+	return NULL;
+}
+
+
 enum reg_arg_type {
 	SRC_OP,		/* register is used as source operand */
 	DST_OP,		/* register is used as destination operand */
@@ -5704,6 +5756,30 @@ static int __check_func_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 		}
 	}
 
+	if (insn->code == (BPF_JMP | BPF_CALL) &&
+	    insn->imm == BPF_FUNC_timer_set_callback) {
+		struct bpf_verifier_state *async_cb;
+
+		/* there is no real recursion here. timer callbacks are async */
+		async_cb = push_async_cb(env, env->subprog_info[subprog].start,
+					 *insn_idx, subprog);
+		if (!async_cb)
+			return -EFAULT;
+		callee = async_cb->frame[0];
+		callee->async_entry_cnt = caller->async_entry_cnt + 1;
+
+		/* Convert bpf_timer_set_callback() args into timer callback args */
+		err = set_callee_state_cb(env, caller, callee, *insn_idx);
+		if (err)
+			return err;
+
+		clear_caller_saved_regs(env, caller->regs);
+		mark_reg_unknown(env, caller->regs, BPF_REG_0);
+		caller->regs[BPF_REG_0].subreg_def = DEF_NOT_SUBREG;
+		/* continue with next insn after call */
+		return 0;
+	}
+
 	callee = kzalloc(sizeof(*callee), GFP_KERNEL);
 	if (!callee)
 		return -ENOMEM;
@@ -5856,6 +5932,7 @@ static int set_timer_callback_state(struct bpf_verifier_env *env,
 	/* unused */
 	__mark_reg_not_init(env, &callee->regs[BPF_REG_4]);
 	__mark_reg_not_init(env, &callee->regs[BPF_REG_5]);
+	callee->in_async_callback_fn = true;
 	return 0;
 }
 
@@ -9224,7 +9301,8 @@ static int check_return_code(struct bpf_verifier_env *env)
 	struct tnum range = tnum_range(0, 1);
 	enum bpf_prog_type prog_type = resolve_prog_type(env->prog);
 	int err;
-	const bool is_subprog = env->cur_state->frame[0]->subprogno;
+	struct bpf_func_state *frame = env->cur_state->frame[0];
+	const bool is_subprog = frame->subprogno;
 
 	/* LSM and struct_ops func-ptr's return type could be "void" */
 	if (!is_subprog &&
@@ -9249,6 +9327,22 @@ static int check_return_code(struct bpf_verifier_env *env)
 	}
 
 	reg = cur_regs(env) + BPF_REG_0;
+
+	if (frame->in_async_callback_fn) {
+		/* enforce return zero from async callbacks like timer */
+		if (reg->type != SCALAR_VALUE) {
+			verbose(env, "In async callback the register R0 is not a known value (%s)\n",
+				reg_type_str[reg->type]);
+			return -EINVAL;
+		}
+
+		if (!tnum_in(tnum_const(0), reg->var_off)) {
+			verbose_invalid_scalar(env, reg, &range, "async callback", "R0");
+			return -EINVAL;
+		}
+		return 0;
+	}
+
 	if (is_subprog) {
 		if (reg->type != SCALAR_VALUE) {
 			verbose(env, "At subprogram exit the register R0 is not a scalar value (%s)\n",
@@ -9496,6 +9590,13 @@ static int visit_insn(int t, int insn_cnt, struct bpf_verifier_env *env)
 		return DONE_EXPLORING;
 
 	case BPF_CALL:
+		if (insns[t].imm == BPF_FUNC_timer_set_callback)
+			/* Mark this call insn to trigger is_state_visited() check
+			 * before call itself is processed by __check_func_call().
+			 * Otherwise new async state will be pushed for further
+			 * exploration.
+			 */
+			init_explored_state(env, t);
 		return visit_func_call_insn(t, insn_cnt, insns, env,
 					    insns[t].src_reg == BPF_PSEUDO_CALL);
 
@@ -10503,9 +10604,25 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
 		states_cnt++;
 		if (sl->state.insn_idx != insn_idx)
 			goto next;
+
 		if (sl->state.branches) {
-			if (states_maybe_looping(&sl->state, cur) &&
-			    states_equal(env, &sl->state, cur)) {
+			struct bpf_func_state *frame = sl->state.frame[sl->state.curframe];
+
+			if (frame->in_async_callback_fn &&
+			    frame->async_entry_cnt != cur->frame[cur->curframe]->async_entry_cnt) {
+				/* Different async_entry_cnt means that the verifier is
+				 * processing another entry into async callback.
+				 * Seeing the same state is not an indication of infinite
+				 * loop or infinite recursion.
+				 * But finding the same state doesn't mean that it's safe
+				 * to stop processing the current state. The previous state
+				 * hasn't yet reached bpf_exit, since state.branches > 0.
+				 * Checking in_async_callback_fn alone is not enough either.
+				 * Since the verifier still needs to catch infinite loops
+				 * inside async callbacks.
+				 */
+			} else if (states_maybe_looping(&sl->state, cur) &&
+				   states_equal(env, &sl->state, cur)) {
 				verbose_linfo(env, insn_idx, "; ");
 				verbose(env, "infinite loop detected at insn %d\n", insn_idx);
 				return -EINVAL;
-- 
2.30.2

