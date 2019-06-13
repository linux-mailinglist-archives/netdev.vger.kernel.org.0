Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7EF44FC7
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 01:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbfFMXEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 19:04:36 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45366 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfFMXEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 19:04:35 -0400
Received: by mail-qt1-f196.google.com with SMTP id j19so346948qtr.12;
        Thu, 13 Jun 2019 16:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eFe9b3YUerG2qyA6obK7zVDw06O06f4xQnfBJUBndkc=;
        b=k8ZMjYdSQSmLuubw9BFx8wSDxd6x93qFiaPjwq7/34w2i8ZOsRdVW19jztiRs0qUQi
         rroOqo5/uu6rBLjuu2iKlkPmVgpHefmp6ZVSxeJO1B9RmboUSKdY/ql6Cn1Vd6iG8Myo
         ZrOxUJ7HVEcpSSOvWjeFtSU834qxnXQS7V3batCNSuz0RRQkGd3aoySodaWQ0ow9vStj
         6CKW/FihNMMhrpKHtYwWXwl556bdfx7vimuVs68FhCCkqNrDZGmub0CbOZc+6eVoAFJk
         1oKx+EnaAd47kXCkNW4p/t2BPxTj0LYkdPsOlL/VeJb8YYytfSE7K0BcZ6j/BXUxURpM
         XY9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eFe9b3YUerG2qyA6obK7zVDw06O06f4xQnfBJUBndkc=;
        b=ReIkTj6hbM5Hts3pI1WtkU/AVYKja8TAeoQUTg7YgHSRCSJnXmeOO3byDFqBCDizsM
         VUcT9Kat+erfhC0Zr2X23+YTWZixBoP2LHNbIzX7VnoeFBuLXT6t4T4wbKRkM33yisyA
         nj4BWOaOkfKgNs53ttl6NwXz56CcsC0QxZaSwEL8G/zIIJByMDA/tnsxBon3TA4fI/FH
         ooTkY3yD20qHaG/qGScUR2c1QJBbmmj7RZPXzAvL9MZ4U7lOBl7fm9EK3Y3sSD4VjwLS
         KCF3QU8FAPl4RKMEoMKikQ9OLrjviz4ltREHbb/81SYV+X/wnRvIwoIqiSPYinn+FWXw
         z2Aw==
X-Gm-Message-State: APjAAAUf9Hnd89m6SmugFN1yXkBS0rsDnoniH9MpxSoXHRs6ck1XD1cz
        WLavnZ+8tjcoYdWMQL/drq625OsCesfXQL4cDSYe/VGKqLo=
X-Google-Smtp-Source: APXvYqxuP7/IXzGA8y7slb8g05w64VOP/J/6ETqDeXSc5a+YiirZlaD4Gme+5knVzVEg3ziYleAEwQOX/WisuWFp24Y=
X-Received: by 2002:ac8:2d56:: with SMTP id o22mr27254879qta.171.1560467073909;
 Thu, 13 Jun 2019 16:04:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190613042003.3791852-1-ast@kernel.org> <20190613042003.3791852-5-ast@kernel.org>
In-Reply-To: <20190613042003.3791852-5-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 13 Jun 2019 16:04:22 -0700
Message-ID: <CAEf4Bzb43AzO1+tg8n8u7KSxe1De3y4Sau4cy+=NQ-m6RCU_Gg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/9] bpf: introduce bounded loops
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Edward Cree <ecree@solarflare.com>,
        john fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, Jann Horn <jannh@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 9:49 AM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Allow the verifier to validate the loops by simulating their execution.
> Exisiting programs have used '#pragma unroll' to unroll the loops
> by the compiler. Instead let the verifier simulate all iterations
> of the loop.
> In order to do that introduce parentage chain of bpf_verifier_state and
> 'branches' counter for the number of branches left to explore.
> See more detailed algorithm description in bpf_verifier.h
>
> This algorithm borrows the key idea from Edward Cree approach:
> https://patchwork.ozlabs.org/patch/877222/
> Additional state pruning heuristics make such brute force loop walk
> practical even for large loops.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

LGTM, few suggestions below.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/linux/bpf_verifier.h |  51 +++++++++++++-
>  kernel/bpf/verifier.c        | 133 ++++++++++++++++++++++++++++++++---
>  2 files changed, 175 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> index 704ed7971472..03037373b447 100644
> --- a/include/linux/bpf_verifier.h
> +++ b/include/linux/bpf_verifier.h
> @@ -194,6 +194,53 @@ struct bpf_func_state {
>  struct bpf_verifier_state {
>         /* call stack tracking */
>         struct bpf_func_state *frame[MAX_CALL_FRAMES];
> +       struct bpf_verifier_state *parent;
> +       /*
> +        * 'branches' field is the number of branches left to explore:
> +        * 0 - all possible paths from this state reached bpf_exit or
> +        * were safely pruned
> +        * 1 - at least one path is being explored.
> +        * This state hasn't reached bpf_exit
> +        * 2 - at least two paths are being explored.
> +        * This state is an immediate parent of two children.
> +        * One is fallthrough branch with branches==1 and another
> +        * state is pushed into stack (to be explored later) also with
> +        * branches==1. The parent of this state has branches==1.
> +        * The verifier state tree connected via 'parent' pointer looks like:
> +        * 1
> +        * 1
> +        * 2 -> 1 (first 'if' pushed into stack)
> +        * 1
> +        * 2 -> 1 (second 'if' pushed into stack)
> +        * 1
> +        * 1
> +        * 1 bpf_exit.
> +        *
> +        * Once do_check() reaches bpf_exit, it calls update_branch_counts()
> +        * and the verifier state tree will look:
> +        * 1
> +        * 1
> +        * 2 -> 1 (first 'if' pushed into stack)
> +        * 1
> +        * 1 -> 1 (second 'if' pushed into stack)
> +        * 0
> +        * 0
> +        * 0 bpf_exit.
> +        * After pop_stack() the do_check() will resume at second 'if'.
> +        *
> +        * If is_state_visited() sees a state with branches > 0 it means
> +        * there is a loop. If such state is exactly equal to the current state
> +        * it's an infinite loop. Note states_equal() checks for states
> +        * equvalency, so two states being 'states_equal' does not mean
> +        * infinite loop. The exact comparison is provided by
> +        * states_maybe_looping() function. It's a stronger pre-check and
> +        * much faster than states_equal().
> +        *
> +        * This algorithm may not find all possible infinite loops or
> +        * loop iteration count may be too high.
> +        * In such cases BPF_COMPLEXITY_LIMIT_INSNS limit kicks in.
> +        */
> +       u32 branches;
>         u32 insn_idx;
>         u32 curframe;
>         u32 active_spin_lock;
> @@ -312,7 +359,9 @@ struct bpf_verifier_env {
>         } cfg;
>         u32 subprog_cnt;
>         /* number of instructions analyzed by the verifier */
> -       u32 insn_processed;
> +       u32 prev_insn_processed, insn_processed;
> +       /* number of jmps, calls, exits analyzed so far */
> +       u32 prev_jmps_processed, jmps_processed;
>         /* total verification time */
>         u64 verification_time;
>         /* maximum number of verifier states kept in 'branching' instructions */
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index c79c09586a9e..55d5ab4ab83e 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -721,6 +721,8 @@ static int copy_verifier_state(struct bpf_verifier_state *dst_state,
>         dst_state->speculative = src->speculative;
>         dst_state->curframe = src->curframe;
>         dst_state->active_spin_lock = src->active_spin_lock;
> +       dst_state->branches = src->branches;
> +       dst_state->parent = src->parent;
>         for (i = 0; i <= src->curframe; i++) {
>                 dst = dst_state->frame[i];
>                 if (!dst) {
> @@ -736,6 +738,23 @@ static int copy_verifier_state(struct bpf_verifier_state *dst_state,
>         return 0;
>  }
>
> +static void update_branch_counts(struct bpf_verifier_env *env, struct bpf_verifier_state *st)
> +{
> +       while (st) {
> +               u32 br = --st->branches;
> +
> +               /* WARN_ON(br > 1) technically makes sense here,
> +                * but see comment in push_stack(), hence:
> +                */
> +               WARN_ONCE((int)br < 0,
> +                         "BUG update_branch_counts:branches_to_explore=%d\n",
> +                         br);
> +               if (br)
> +                       break;
> +               st = st->parent;
> +       }
> +}
> +
>  static int pop_stack(struct bpf_verifier_env *env, int *prev_insn_idx,
>                      int *insn_idx)
>  {
> @@ -789,6 +808,18 @@ static struct bpf_verifier_state *push_stack(struct bpf_verifier_env *env,
>                         env->stack_size);
>                 goto err;
>         }
> +       if (elem->st.parent) {
> +               ++elem->st.parent->branches;
> +               /* WARN_ON(branches > 2) technically makes sense here,
> +                * but
> +                * 1. speculative states will bump 'branches' for non-branch
> +                * instructions
> +                * 2. is_state_visited() heuristics may decide not to create
> +                * a new state for a sequence of branches and all such current
> +                * and cloned states will be pointing to a single parent state
> +                * which might have large 'branches' count.
> +                */
> +       }
>         return &elem->st;
>  err:
>         free_verifier_state(env->cur_state, true);
> @@ -5685,7 +5716,8 @@ static void init_explored_state(struct bpf_verifier_env *env, int idx)
>   * w - next instruction
>   * e - edge
>   */
> -static int push_insn(int t, int w, int e, struct bpf_verifier_env *env)
> +static int push_insn(int t, int w, int e, struct bpf_verifier_env *env,
> +                    bool loop_ok)
>  {
>         int *insn_stack = env->cfg.insn_stack;
>         int *insn_state = env->cfg.insn_state;
> @@ -5715,6 +5747,8 @@ static int push_insn(int t, int w, int e, struct bpf_verifier_env *env)
>                 insn_stack[env->cfg.cur_stack++] = w;
>                 return 1;
>         } else if ((insn_state[w] & 0xF0) == DISCOVERED) {
> +               if (loop_ok && env->allow_ptr_leaks)

allow_ptr_leaks is used as a proxy for SYS_CAP_ADMIN, right? Maybe
have explicit env->allow_loops instead. That would make more sense
when reading code. Plus, it would decouple loop enablement from
SYS_CAP_ADMIN, so would allow more fine-grained control, if necessary.

> +                       return 0;
>                 verbose_linfo(env, t, "%d: ", t);
>                 verbose_linfo(env, w, "%d: ", w);
>                 verbose(env, "back-edge from insn %d to %d\n", t, w);
> @@ -5766,7 +5800,7 @@ static int check_cfg(struct bpf_verifier_env *env)
>                 if (opcode == BPF_EXIT) {
>                         goto mark_explored;
>                 } else if (opcode == BPF_CALL) {
> -                       ret = push_insn(t, t + 1, FALLTHROUGH, env);
> +                       ret = push_insn(t, t + 1, FALLTHROUGH, env, false);
>                         if (ret == 1)
>                                 goto peek_stack;
>                         else if (ret < 0)
> @@ -5775,7 +5809,8 @@ static int check_cfg(struct bpf_verifier_env *env)
>                                 init_explored_state(env, t + 1);
>                         if (insns[t].src_reg == BPF_PSEUDO_CALL) {
>                                 init_explored_state(env, t);
> -                               ret = push_insn(t, t + insns[t].imm + 1, BRANCH, env);
> +                               ret = push_insn(t, t + insns[t].imm + 1, BRANCH,
> +                                               env, false);
>                                 if (ret == 1)
>                                         goto peek_stack;
>                                 else if (ret < 0)
> @@ -5788,7 +5823,7 @@ static int check_cfg(struct bpf_verifier_env *env)
>                         }
>                         /* unconditional jump with single edge */
>                         ret = push_insn(t, t + insns[t].off + 1,
> -                                       FALLTHROUGH, env);
> +                                       FALLTHROUGH, env, true);
>                         if (ret == 1)
>                                 goto peek_stack;
>                         else if (ret < 0)
> @@ -5801,13 +5836,13 @@ static int check_cfg(struct bpf_verifier_env *env)
>                 } else {
>                         /* conditional jump with two edges */
>                         init_explored_state(env, t);
> -                       ret = push_insn(t, t + 1, FALLTHROUGH, env);
> +                       ret = push_insn(t, t + 1, FALLTHROUGH, env, true);
>                         if (ret == 1)
>                                 goto peek_stack;
>                         else if (ret < 0)
>                                 goto err_free;
>
> -                       ret = push_insn(t, t + insns[t].off + 1, BRANCH, env);
> +                       ret = push_insn(t, t + insns[t].off + 1, BRANCH, env, true);
>                         if (ret == 1)
>                                 goto peek_stack;
>                         else if (ret < 0)
> @@ -5817,7 +5852,7 @@ static int check_cfg(struct bpf_verifier_env *env)
>                 /* all other non-branch instructions with single
>                  * fall-through edge
>                  */
> -               ret = push_insn(t, t + 1, FALLTHROUGH, env);
> +               ret = push_insn(t, t + 1, FALLTHROUGH, env, false);
>                 if (ret == 1)
>                         goto peek_stack;
>                 else if (ret < 0)
> @@ -6250,6 +6285,8 @@ static void clean_live_states(struct bpf_verifier_env *env, int insn,
>
>         sl = *explored_state(env, insn);
>         while (sl) {
> +               if (sl->state.branches)
> +                       goto next;
>                 if (sl->state.insn_idx != insn ||
>                     sl->state.curframe != cur->curframe)
>                         goto next;
> @@ -6614,12 +6651,32 @@ static int propagate_liveness(struct bpf_verifier_env *env,
>         return 0;
>  }
>
> +static bool states_maybe_looping(struct bpf_verifier_state *old,
> +                                struct bpf_verifier_state *cur)
> +{
> +       struct bpf_func_state *fold, *fcur;
> +       int i, fr = cur->curframe;
> +
> +       if (old->curframe != fr)
> +               return false;
> +
> +       fold = old->frame[fr];
> +       fcur = cur->frame[fr];
> +       for (i = 0; i < MAX_BPF_REG; i++)
> +               if (memcmp(&fold->regs[i], &fcur->regs[i],
> +                          offsetof(struct bpf_reg_state, parent)))
> +                       return false;
> +       return true;
> +}
> +
> +
>  static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
>  {
>         struct bpf_verifier_state_list *new_sl;
>         struct bpf_verifier_state_list *sl, **pprev;
>         struct bpf_verifier_state *cur = env->cur_state, *new;
>         int i, j, err, states_cnt = 0;
> +       bool add_new_state = false;
>
>         if (!env->insn_aux_data[insn_idx].prune_point)
>                 /* this 'insn_idx' instruction wasn't marked, so we will not
> @@ -6627,6 +6684,18 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
>                  */
>                 return 0;
>
> +       /* bpf progs typically have pruning point every 4 instructions
> +        * http://vger.kernel.org/bpfconf2019.html#session-1
> +        * Do not add new state for future pruning if the verifier hasn't seen
> +        * at least 2 jumps and at least 8 instructions.
> +        * This heuristics helps decrease 'total_states' and 'peak_states' metric.
> +        * In tests that amounts to up to 50% reduction into total verifier
> +        * memory consumption and 20% verifier time speedup.
> +        */
> +       if (env->jmps_processed - env->prev_jmps_processed >= 2 &&
> +           env->insn_processed - env->prev_insn_processed >= 8)
> +               add_new_state = true;

nit: trivial if, why not:

add_new_state = env->jmps_processed - env->prev_jmps_processed >= 2 &&
                env->insn_processed - env->prev_insn_processed >= 8;

> +
>         pprev = explored_state(env, insn_idx);
>         sl = *pprev;
>
> @@ -6636,6 +6705,30 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
>                 states_cnt++;
>                 if (sl->state.insn_idx != insn_idx)
>                         goto next;
> +               if (sl->state.branches) {
> +                       if (states_maybe_looping(&sl->state, cur) &&
> +                           states_equal(env, &sl->state, cur)) {
> +                               verbose_linfo(env, insn_idx, "; ");
> +                               verbose(env, "infinite loop detected at insn %d\n", insn_idx);
> +                               return -EINVAL;
> +                       }
> +                       /* if the verifier is processing a loop, avoid adding new state
> +                        * too often, since different loop iterations have distinct
> +                        * states and may not help future pruning.
> +                        * This threshold shouldn't be too low to make sure that
> +                        * a loop with large bound will be rejected quickly.
> +                        * The most abusive loop will be:
> +                        * r1 += 1
> +                        * if r1 < 1000000 goto pc-2
> +                        * 1M insn_procssed limit / 100 == 10k peak states.
> +                        * This threshold shouldn't be too high either, since states
> +                        * at the end of the loop are likely to be useful in pruning.
> +                        */
> +                       if (env->jmps_processed - env->prev_jmps_processed < 20 &&
> +                           env->insn_processed - env->prev_insn_processed < 100)
> +                               add_new_state = false;

same as above

> +                       goto miss;
> +               }
>                 if (states_equal(env, &sl->state, cur)) {
>                         sl->hit_cnt++;
>                         /* reached equivalent register/stack state,
> @@ -6653,7 +6746,15 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
>                                 return err;
>                         return 1;
>                 }
> -               sl->miss_cnt++;
> +miss:
> +               /* when new state is not going to be added do not increase miss count.
> +                * Otherwise several loop iterations will remove the state
> +                * recorded earlier. The goal of these heuristics is to have
> +                * states from some iterations of the loop (some in the beginning
> +                * and some at the end) to help pruning.
> +                */
> +               if (add_new_state)
> +                       sl->miss_cnt++;
>                 /* heuristic to determine whether this state is beneficial
>                  * to keep checking from state equivalence point of view.
>                  * Higher numbers increase max_states_per_insn and verification time,
> @@ -6665,6 +6766,11 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
>                          */
>                         *pprev = sl->next;
>                         if (sl->state.frame[0]->regs[0].live & REG_LIVE_DONE) {
> +                               u32 br = sl->state.branches;
> +
> +                               WARN_ONCE(br,
> +                                         "BUG live_done but branches_to_explore %d\n",
> +                                         br);
>                                 free_verifier_state(&sl->state, false);
>                                 kfree(sl);
>                                 env->peak_states--;
> @@ -6690,6 +6796,9 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
>         if (!env->allow_ptr_leaks && states_cnt > BPF_COMPLEXITY_LIMIT_STATES)
>                 return 0;
>
> +       if (!add_new_state)
> +               return 0;
> +
>         /* there were no equivalent states, remember current one.
>          * technically the current state is not proven to be safe yet,
>          * but it will either reach outer most bpf_exit (which means it's safe)
> @@ -6702,6 +6811,8 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
>                 return -ENOMEM;
>         env->total_states++;
>         env->peak_states++;
> +       env->prev_jmps_processed = env->jmps_processed;
> +       env->prev_insn_processed = env->insn_processed;
>
>         /* add new state to the head of linked list */
>         new = &new_sl->state;
> @@ -6712,6 +6823,9 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)

Few lines above this there is comment stating " Since there are no
loops ...", can you please fix it?

>                 return err;
>         }
>         new->insn_idx = insn_idx;
> +       WARN_ONCE(new->branches != 1,
> +                 "BUG is_state_visited:branches_to_explore=%d insn %d\n", new->branches, insn_idx);
> +       cur->parent = new;
>         new_sl->next = *explored_state(env, insn_idx);
>         *explored_state(env, insn_idx) = new_sl;
>         /* connect new state to parentage chain. Current frame needs all
> @@ -6798,6 +6912,7 @@ static int do_check(struct bpf_verifier_env *env)
>                 return -ENOMEM;
>         state->curframe = 0;
>         state->speculative = false;
> +       state->branches = 1;
>         state->frame[0] = kzalloc(sizeof(struct bpf_func_state), GFP_KERNEL);
>         if (!state->frame[0]) {
>                 kfree(state);
> @@ -7004,6 +7119,7 @@ static int do_check(struct bpf_verifier_env *env)
>                 } else if (class == BPF_JMP || class == BPF_JMP32) {
>                         u8 opcode = BPF_OP(insn->code);
>
> +                       env->jmps_processed++;
>                         if (opcode == BPF_CALL) {
>                                 if (BPF_SRC(insn->code) != BPF_K ||
>                                     insn->off != 0 ||
> @@ -7089,6 +7205,7 @@ static int do_check(struct bpf_verifier_env *env)
>                                 if (err)
>                                         return err;
>  process_bpf_exit:
> +                               update_branch_counts(env, env->cur_state);
>                                 err = pop_stack(env, &env->prev_insn_idx,
>                                                 &env->insn_idx);
>                                 if (err < 0) {
> --
> 2.20.0
>
