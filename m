Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 812864563B
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 09:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfFNH0N convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 14 Jun 2019 03:26:13 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56736 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726486AbfFNH0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 03:26:11 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5E7J8am029060
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 00:26:09 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2t3py233s0-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 00:26:09 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 14 Jun 2019 00:26:07 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 6E9AD760F47; Fri, 14 Jun 2019 00:26:05 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <andriin@fb.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 4/9] bpf: introduce bounded loops
Date:   Fri, 14 Jun 2019 00:25:52 -0700
Message-ID: <20190614072557.196239-5-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190614072557.196239-1-ast@kernel.org>
References: <20190614072557.196239-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-14_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906140058
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow the verifier to validate the loops by simulating their execution.
Exisiting programs have used '#pragma unroll' to unroll the loops
by the compiler. Instead let the verifier simulate all iterations
of the loop.
In order to do that introduce parentage chain of bpf_verifier_state and
'branches' counter for the number of branches left to explore.
See more detailed algorithm description in bpf_verifier.h

This algorithm borrows the key idea from Edward Cree approach:
https://patchwork.ozlabs.org/patch/877222/
Additional state pruning heuristics make such brute force loop walk
practical even for large loops.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 include/linux/bpf_verifier.h |  51 ++++++++++++-
 kernel/bpf/verifier.c        | 143 ++++++++++++++++++++++++++++++++---
 2 files changed, 181 insertions(+), 13 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 704ed7971472..03037373b447 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -194,6 +194,53 @@ struct bpf_func_state {
 struct bpf_verifier_state {
 	/* call stack tracking */
 	struct bpf_func_state *frame[MAX_CALL_FRAMES];
+	struct bpf_verifier_state *parent;
+	/*
+	 * 'branches' field is the number of branches left to explore:
+	 * 0 - all possible paths from this state reached bpf_exit or
+	 * were safely pruned
+	 * 1 - at least one path is being explored.
+	 * This state hasn't reached bpf_exit
+	 * 2 - at least two paths are being explored.
+	 * This state is an immediate parent of two children.
+	 * One is fallthrough branch with branches==1 and another
+	 * state is pushed into stack (to be explored later) also with
+	 * branches==1. The parent of this state has branches==1.
+	 * The verifier state tree connected via 'parent' pointer looks like:
+	 * 1
+	 * 1
+	 * 2 -> 1 (first 'if' pushed into stack)
+	 * 1
+	 * 2 -> 1 (second 'if' pushed into stack)
+	 * 1
+	 * 1
+	 * 1 bpf_exit.
+	 *
+	 * Once do_check() reaches bpf_exit, it calls update_branch_counts()
+	 * and the verifier state tree will look:
+	 * 1
+	 * 1
+	 * 2 -> 1 (first 'if' pushed into stack)
+	 * 1
+	 * 1 -> 1 (second 'if' pushed into stack)
+	 * 0
+	 * 0
+	 * 0 bpf_exit.
+	 * After pop_stack() the do_check() will resume at second 'if'.
+	 *
+	 * If is_state_visited() sees a state with branches > 0 it means
+	 * there is a loop. If such state is exactly equal to the current state
+	 * it's an infinite loop. Note states_equal() checks for states
+	 * equvalency, so two states being 'states_equal' does not mean
+	 * infinite loop. The exact comparison is provided by
+	 * states_maybe_looping() function. It's a stronger pre-check and
+	 * much faster than states_equal().
+	 *
+	 * This algorithm may not find all possible infinite loops or
+	 * loop iteration count may be too high.
+	 * In such cases BPF_COMPLEXITY_LIMIT_INSNS limit kicks in.
+	 */
+	u32 branches;
 	u32 insn_idx;
 	u32 curframe;
 	u32 active_spin_lock;
@@ -312,7 +359,9 @@ struct bpf_verifier_env {
 	} cfg;
 	u32 subprog_cnt;
 	/* number of instructions analyzed by the verifier */
-	u32 insn_processed;
+	u32 prev_insn_processed, insn_processed;
+	/* number of jmps, calls, exits analyzed so far */
+	u32 prev_jmps_processed, jmps_processed;
 	/* total verification time */
 	u64 verification_time;
 	/* maximum number of verifier states kept in 'branching' instructions */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 8d3a4ef1d969..25baa3c8cdd2 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -721,6 +721,8 @@ static int copy_verifier_state(struct bpf_verifier_state *dst_state,
 	dst_state->speculative = src->speculative;
 	dst_state->curframe = src->curframe;
 	dst_state->active_spin_lock = src->active_spin_lock;
+	dst_state->branches = src->branches;
+	dst_state->parent = src->parent;
 	for (i = 0; i <= src->curframe; i++) {
 		dst = dst_state->frame[i];
 		if (!dst) {
@@ -736,6 +738,23 @@ static int copy_verifier_state(struct bpf_verifier_state *dst_state,
 	return 0;
 }
 
+static void update_branch_counts(struct bpf_verifier_env *env, struct bpf_verifier_state *st)
+{
+	while (st) {
+		u32 br = --st->branches;
+
+		/* WARN_ON(br > 1) technically makes sense here,
+		 * but see comment in push_stack(), hence:
+		 */
+		WARN_ONCE((int)br < 0,
+			  "BUG update_branch_counts:branches_to_explore=%d\n",
+			  br);
+		if (br)
+			break;
+		st = st->parent;
+	}
+}
+
 static int pop_stack(struct bpf_verifier_env *env, int *prev_insn_idx,
 		     int *insn_idx)
 {
@@ -789,6 +808,18 @@ static struct bpf_verifier_state *push_stack(struct bpf_verifier_env *env,
 			env->stack_size);
 		goto err;
 	}
+	if (elem->st.parent) {
+		++elem->st.parent->branches;
+		/* WARN_ON(branches > 2) technically makes sense here,
+		 * but
+		 * 1. speculative states will bump 'branches' for non-branch
+		 * instructions
+		 * 2. is_state_visited() heuristics may decide not to create
+		 * a new state for a sequence of branches and all such current
+		 * and cloned states will be pointing to a single parent state
+		 * which might have large 'branches' count.
+		 */
+	}
 	return &elem->st;
 err:
 	free_verifier_state(env->cur_state, true);
@@ -5682,7 +5713,8 @@ static void init_explored_state(struct bpf_verifier_env *env, int idx)
  * w - next instruction
  * e - edge
  */
-static int push_insn(int t, int w, int e, struct bpf_verifier_env *env)
+static int push_insn(int t, int w, int e, struct bpf_verifier_env *env,
+		     bool loop_ok)
 {
 	int *insn_stack = env->cfg.insn_stack;
 	int *insn_state = env->cfg.insn_state;
@@ -5712,6 +5744,8 @@ static int push_insn(int t, int w, int e, struct bpf_verifier_env *env)
 		insn_stack[env->cfg.cur_stack++] = w;
 		return 1;
 	} else if ((insn_state[w] & 0xF0) == DISCOVERED) {
+		if (loop_ok && env->allow_ptr_leaks)
+			return 0;
 		verbose_linfo(env, t, "%d: ", t);
 		verbose_linfo(env, w, "%d: ", w);
 		verbose(env, "back-edge from insn %d to %d\n", t, w);
@@ -5763,7 +5797,7 @@ static int check_cfg(struct bpf_verifier_env *env)
 		if (opcode == BPF_EXIT) {
 			goto mark_explored;
 		} else if (opcode == BPF_CALL) {
-			ret = push_insn(t, t + 1, FALLTHROUGH, env);
+			ret = push_insn(t, t + 1, FALLTHROUGH, env, false);
 			if (ret == 1)
 				goto peek_stack;
 			else if (ret < 0)
@@ -5772,7 +5806,8 @@ static int check_cfg(struct bpf_verifier_env *env)
 				init_explored_state(env, t + 1);
 			if (insns[t].src_reg == BPF_PSEUDO_CALL) {
 				init_explored_state(env, t);
-				ret = push_insn(t, t + insns[t].imm + 1, BRANCH, env);
+				ret = push_insn(t, t + insns[t].imm + 1, BRANCH,
+						env, false);
 				if (ret == 1)
 					goto peek_stack;
 				else if (ret < 0)
@@ -5785,7 +5820,7 @@ static int check_cfg(struct bpf_verifier_env *env)
 			}
 			/* unconditional jump with single edge */
 			ret = push_insn(t, t + insns[t].off + 1,
-					FALLTHROUGH, env);
+					FALLTHROUGH, env, true);
 			if (ret == 1)
 				goto peek_stack;
 			else if (ret < 0)
@@ -5798,13 +5833,13 @@ static int check_cfg(struct bpf_verifier_env *env)
 		} else {
 			/* conditional jump with two edges */
 			init_explored_state(env, t);
-			ret = push_insn(t, t + 1, FALLTHROUGH, env);
+			ret = push_insn(t, t + 1, FALLTHROUGH, env, true);
 			if (ret == 1)
 				goto peek_stack;
 			else if (ret < 0)
 				goto err_free;
 
-			ret = push_insn(t, t + insns[t].off + 1, BRANCH, env);
+			ret = push_insn(t, t + insns[t].off + 1, BRANCH, env, true);
 			if (ret == 1)
 				goto peek_stack;
 			else if (ret < 0)
@@ -5814,7 +5849,7 @@ static int check_cfg(struct bpf_verifier_env *env)
 		/* all other non-branch instructions with single
 		 * fall-through edge
 		 */
-		ret = push_insn(t, t + 1, FALLTHROUGH, env);
+		ret = push_insn(t, t + 1, FALLTHROUGH, env, false);
 		if (ret == 1)
 			goto peek_stack;
 		else if (ret < 0)
@@ -6247,6 +6282,8 @@ static void clean_live_states(struct bpf_verifier_env *env, int insn,
 
 	sl = *explored_state(env, insn);
 	while (sl) {
+		if (sl->state.branches)
+			goto next;
 		if (sl->state.insn_idx != insn ||
 		    sl->state.curframe != cur->curframe)
 			goto next;
@@ -6611,12 +6648,32 @@ static int propagate_liveness(struct bpf_verifier_env *env,
 	return 0;
 }
 
+static bool states_maybe_looping(struct bpf_verifier_state *old,
+				 struct bpf_verifier_state *cur)
+{
+	struct bpf_func_state *fold, *fcur;
+	int i, fr = cur->curframe;
+
+	if (old->curframe != fr)
+		return false;
+
+	fold = old->frame[fr];
+	fcur = cur->frame[fr];
+	for (i = 0; i < MAX_BPF_REG; i++)
+		if (memcmp(&fold->regs[i], &fcur->regs[i],
+			   offsetof(struct bpf_reg_state, parent)))
+			return false;
+	return true;
+}
+
+
 static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
 {
 	struct bpf_verifier_state_list *new_sl;
 	struct bpf_verifier_state_list *sl, **pprev;
 	struct bpf_verifier_state *cur = env->cur_state, *new;
 	int i, j, err, states_cnt = 0;
+	bool add_new_state = false;
 
 	if (!env->insn_aux_data[insn_idx].prune_point)
 		/* this 'insn_idx' instruction wasn't marked, so we will not
@@ -6624,6 +6681,18 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
 		 */
 		return 0;
 
+	/* bpf progs typically have pruning point every 4 instructions
+	 * http://vger.kernel.org/bpfconf2019.html#session-1
+	 * Do not add new state for future pruning if the verifier hasn't seen
+	 * at least 2 jumps and at least 8 instructions.
+	 * This heuristics helps decrease 'total_states' and 'peak_states' metric.
+	 * In tests that amounts to up to 50% reduction into total verifier
+	 * memory consumption and 20% verifier time speedup.
+	 */
+	if (env->jmps_processed - env->prev_jmps_processed >= 2 &&
+	    env->insn_processed - env->prev_insn_processed >= 8)
+		add_new_state = true;
+
 	pprev = explored_state(env, insn_idx);
 	sl = *pprev;
 
@@ -6633,6 +6702,30 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
 		states_cnt++;
 		if (sl->state.insn_idx != insn_idx)
 			goto next;
+		if (sl->state.branches) {
+			if (states_maybe_looping(&sl->state, cur) &&
+			    states_equal(env, &sl->state, cur)) {
+				verbose_linfo(env, insn_idx, "; ");
+				verbose(env, "infinite loop detected at insn %d\n", insn_idx);
+				return -EINVAL;
+			}
+			/* if the verifier is processing a loop, avoid adding new state
+			 * too often, since different loop iterations have distinct
+			 * states and may not help future pruning.
+			 * This threshold shouldn't be too low to make sure that
+			 * a loop with large bound will be rejected quickly.
+			 * The most abusive loop will be:
+			 * r1 += 1
+			 * if r1 < 1000000 goto pc-2
+			 * 1M insn_procssed limit / 100 == 10k peak states.
+			 * This threshold shouldn't be too high either, since states
+			 * at the end of the loop are likely to be useful in pruning.
+			 */
+			if (env->jmps_processed - env->prev_jmps_processed < 20 &&
+			    env->insn_processed - env->prev_insn_processed < 100)
+				add_new_state = false;
+			goto miss;
+		}
 		if (states_equal(env, &sl->state, cur)) {
 			sl->hit_cnt++;
 			/* reached equivalent register/stack state,
@@ -6650,7 +6743,15 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
 				return err;
 			return 1;
 		}
-		sl->miss_cnt++;
+miss:
+		/* when new state is not going to be added do not increase miss count.
+		 * Otherwise several loop iterations will remove the state
+		 * recorded earlier. The goal of these heuristics is to have
+		 * states from some iterations of the loop (some in the beginning
+		 * and some at the end) to help pruning.
+		 */
+		if (add_new_state)
+			sl->miss_cnt++;
 		/* heuristic to determine whether this state is beneficial
 		 * to keep checking from state equivalence point of view.
 		 * Higher numbers increase max_states_per_insn and verification time,
@@ -6662,6 +6763,11 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
 			 */
 			*pprev = sl->next;
 			if (sl->state.frame[0]->regs[0].live & REG_LIVE_DONE) {
+				u32 br = sl->state.branches;
+
+				WARN_ONCE(br,
+					  "BUG live_done but branches_to_explore %d\n",
+					  br);
 				free_verifier_state(&sl->state, false);
 				kfree(sl);
 				env->peak_states--;
@@ -6687,18 +6793,25 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
 	if (!env->allow_ptr_leaks && states_cnt > BPF_COMPLEXITY_LIMIT_STATES)
 		return 0;
 
-	/* there were no equivalent states, remember current one.
-	 * technically the current state is not proven to be safe yet,
+	if (!add_new_state)
+		return 0;
+
+	/* There were no equivalent states, remember the current one.
+	 * Technically the current state is not proven to be safe yet,
 	 * but it will either reach outer most bpf_exit (which means it's safe)
-	 * or it will be rejected. Since there are no loops, we won't be
+	 * or it will be rejected. When there are no loops the verifier won't be
 	 * seeing this tuple (frame[0].callsite, frame[1].callsite, .. insn_idx)
-	 * again on the way to bpf_exit
+	 * again on the way to bpf_exit.
+	 * When looping the sl->state.branches will be > 0 and this state
+	 * will not be considered for equivalence until branches == 0.
 	 */
 	new_sl = kzalloc(sizeof(struct bpf_verifier_state_list), GFP_KERNEL);
 	if (!new_sl)
 		return -ENOMEM;
 	env->total_states++;
 	env->peak_states++;
+	env->prev_jmps_processed = env->jmps_processed;
+	env->prev_insn_processed = env->insn_processed;
 
 	/* add new state to the head of linked list */
 	new = &new_sl->state;
@@ -6709,6 +6822,9 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
 		return err;
 	}
 	new->insn_idx = insn_idx;
+	WARN_ONCE(new->branches != 1,
+		  "BUG is_state_visited:branches_to_explore=%d insn %d\n", new->branches, insn_idx);
+	cur->parent = new;
 	new_sl->next = *explored_state(env, insn_idx);
 	*explored_state(env, insn_idx) = new_sl;
 	/* connect new state to parentage chain. Current frame needs all
@@ -6795,6 +6911,7 @@ static int do_check(struct bpf_verifier_env *env)
 		return -ENOMEM;
 	state->curframe = 0;
 	state->speculative = false;
+	state->branches = 1;
 	state->frame[0] = kzalloc(sizeof(struct bpf_func_state), GFP_KERNEL);
 	if (!state->frame[0]) {
 		kfree(state);
@@ -7001,6 +7118,7 @@ static int do_check(struct bpf_verifier_env *env)
 		} else if (class == BPF_JMP || class == BPF_JMP32) {
 			u8 opcode = BPF_OP(insn->code);
 
+			env->jmps_processed++;
 			if (opcode == BPF_CALL) {
 				if (BPF_SRC(insn->code) != BPF_K ||
 				    insn->off != 0 ||
@@ -7086,6 +7204,7 @@ static int do_check(struct bpf_verifier_env *env)
 				if (err)
 					return err;
 process_bpf_exit:
+				update_branch_counts(env, env->cur_state);
 				err = pop_stack(env, &env->prev_insn_idx,
 						&env->insn_idx);
 				if (err < 0) {
-- 
2.20.0

