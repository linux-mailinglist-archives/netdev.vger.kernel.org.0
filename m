Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC2925B65
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 02:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbfEVAzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 20:55:19 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:45981 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbfEVAzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 20:55:18 -0400
Received: by mail-qk1-f196.google.com with SMTP id j1so413693qkk.12;
        Tue, 21 May 2019 17:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ka7+pl/q081b2C6RBNHR1iXcnLYH5p9VMfjEPYikAAU=;
        b=e4IGx+wIv8IV6VUQuKtxbYmlObHli6/xHuEdirZ7144WdR3kzSUeZx/yIn206adAVf
         GKXyCzviweAvPr3/DPjmJEddVhcNwtAazxTZP6JLigUfkp6e7QU2UqDXfHeF3DD+4ilB
         wfm2mxNfzNkpUYh8+bn04WykJ4uhk09djuxHBXBOcs7hAru33C2361nV7m9GCRo1G6rl
         W+GEmqRPUtCe7Gb/K662b1OMm465W8Cm86aJN7mihhQcwojg7+hwU7C8sgO+FLHzpeeL
         +S1nvuiHXCY+RunnhUsyzCuxYI/UKoF5kLP5EU9cj301LbzjGIiRdTLU14NnZAh1udmn
         yKTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ka7+pl/q081b2C6RBNHR1iXcnLYH5p9VMfjEPYikAAU=;
        b=CiaM65EnZYXPZIu+xA1F8BIblrdwONFvfMo9CQaG3UOa2Pn+l2+KYWr6SXVM8ZbwPO
         UBSC+wTnz6NNcq6/yCk3BARAjjzem/+Bl/3i+/B0Ficb6HLCcDYYoQJjUOW9IfpEe+fW
         AngPSxAu8eCLjIy/ODE9sIr0kLs2oXvieZhsa0wSQyPcPEZUldkK+OcBm78pLTLJSslI
         fN5YykYb7pUinz802jXOP3aEJTMiB/XUhfT/b59Ft8bR25VeQkQiNCTokyf2yG08miQJ
         a1loCmfd/wZu1w7ScZ1YeqjiFtL+JOZrQCwRdW7tLw+kZZahkJ49NAiKU6qpTGXMu08M
         JJDA==
X-Gm-Message-State: APjAAAVhRoZqS8Avp7tju43Fmup0VaQZvkMOsd+SvjuIM63Kiq/w96gb
        VLXOfotTizvUqca6qrQEg9EdnhpzgnzSS6eH3u0IpvubhBtDFA==
X-Google-Smtp-Source: APXvYqzVOns34f+4bJQJic9XCqfvKbsCQiXKzj3C7TePFCGNnL+ChUZQzRwpfGRJMdERguQc4a368M4KE9o0h/UssKc=
X-Received: by 2002:ae9:e806:: with SMTP id a6mr50550570qkg.247.1558486517516;
 Tue, 21 May 2019 17:55:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190521230635.2142522-1-ast@kernel.org> <20190521230635.2142522-4-ast@kernel.org>
In-Reply-To: <20190521230635.2142522-4-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 21 May 2019 17:55:06 -0700
Message-ID: <CAEf4BzZkWWCqEJ8mKJjqkF1FpvP+urJ5dcdhneCoPd4wtViOww@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] bpf: convert explored_states to hash table
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     davem@davemloft.net, Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 21, 2019 at 4:08 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> All prune points inside a callee bpf function most likely will have
> different callsites. For example, if function foo() is called from
> two callsites the half of explored states in all prune points in foo()
> will be useless for subsequent walking of one of those callsites.
> Fortunately explored_states pruning heuristics keeps the number of states
> per prune point small, but walking these states is still a waste of cpu
> time when the callsite of the current state is different from the callsite
> of the explored state.
>
> To improve pruning logic convert explored_states into hash table and
> use simple insn_idx ^ callsite hash to select hash bucket.
> This optimization has no effect on programs without bpf2bpf calls
> and drastically improves programs with calls.
> In the later case it reduces total memory consumption in 1M scale tests
> by almost 3 times (peak_states drops from 5752 to 2016).
>
> Care should be taken when comparing the states for equivalency.
> Since the same hash bucket can now contain states with different indices
> the insn_idx has to be part of verifier_state and compared.
>
> Different hash table sizes and different hash functions were explored,
> but the results were not significantly better vs this patch.
> They can be improved in the future.
>
> Hit/miss heuristic is not counting index miscompare as a miss.
> Otherwise verifier stats become unstable when experimenting
> with different hash functions.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  include/linux/bpf_verifier.h |  1 +
>  kernel/bpf/verifier.c        | 23 ++++++++++++++++++-----
>  2 files changed, 19 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> index 02bba09a0ea1..405b502283c5 100644
> --- a/include/linux/bpf_verifier.h
> +++ b/include/linux/bpf_verifier.h
> @@ -187,6 +187,7 @@ struct bpf_func_state {
>  struct bpf_verifier_state {
>         /* call stack tracking */
>         struct bpf_func_state *frame[MAX_CALL_FRAMES];
> +       u32 insn_idx;
>         u32 curframe;
>         u32 active_spin_lock;
>         bool speculative;
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 89097a4b1bf3..082f6eefb1c4 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -5435,11 +5435,19 @@ enum {
>         BRANCH = 2,
>  };
>
> +static u32 state_htab_size(struct bpf_verifier_env *env)

maybe mark it as inline function? it's called pretty heavily.

> +{
> +       return env->prog->len;
> +}
> +
>  static struct bpf_verifier_state_list **explored_state(
>                                         struct bpf_verifier_env *env,
>                                         int idx)
>  {
> -       return &env->explored_states[idx];
> +       struct bpf_verifier_state *cur = env->cur_state;
> +       struct bpf_func_state *state = cur->frame[cur->curframe];
> +
> +       return &env->explored_states[(idx ^ state->callsite) % state_htab_size(env)];

% is slow, see [1] for faster alternative.

Alternatively, if you can make sure that hash size is power of two,
then multiplicative Fibonacci hashing is preferred ([2]).

[1] https://lemire.me/blog/2016/06/27/a-fast-alternative-to-the-modulo-reduction/
[2] https://probablydance.com/2018/06/16/fibonacci-hashing-the-optimization-that-the-world-forgot-or-a-better-alternative-to-integer-modulo/

>  }
>
>  static void init_explored_state(struct bpf_verifier_env *env, int idx)
> @@ -6018,7 +6026,8 @@ static void clean_live_states(struct bpf_verifier_env *env, int insn,
>
>         sl = *explored_state(env, insn);
>         while (sl) {
> -               if (sl->state.curframe != cur->curframe)
> +               if (sl->state.insn_idx != insn ||
> +                   sl->state.curframe != cur->curframe)
>                         goto next;
>                 for (i = 0; i <= cur->curframe; i++)
>                         if (sl->state.frame[i]->callsite != cur->frame[i]->callsite)
> @@ -6384,6 +6393,9 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
>         clean_live_states(env, insn_idx, cur);
>
>         while (sl) {
> +               states_cnt++;
> +               if (sl->state.insn_idx != insn_idx)
> +                       goto next;

Shouldn't this be checked inside states_equal? Or you are trying to
avoid function call overhead? If the latter is the case, then you
should probably compare curframe as well here?

>                 if (states_equal(env, &sl->state, cur)) {
>                         sl->hit_cnt++;
>                         /* reached equivalent register/stack state,
> @@ -6401,7 +6413,6 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
>                                 return err;
>                         return 1;
>                 }
> -               states_cnt++;
>                 sl->miss_cnt++;
>                 /* heuristic to determine whether this state is beneficial
>                  * to keep checking from state equivalence point of view.
> @@ -6428,6 +6439,7 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
>                         sl = *pprev;
>                         continue;
>                 }
> +next:
>                 pprev = &sl->next;
>                 sl = *pprev;
>         }
> @@ -6459,6 +6471,7 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
>                 kfree(new_sl);
>                 return err;
>         }
> +       new->insn_idx = insn_idx;
>         new_sl->next = *explored_state(env, insn_idx);
>         *explored_state(env, insn_idx) = new_sl;
>         /* connect new state to parentage chain. Current frame needs all
> @@ -8138,7 +8151,7 @@ static void free_states(struct bpf_verifier_env *env)
>         if (!env->explored_states)
>                 return;
>
> -       for (i = 0; i < env->prog->len; i++) {
> +       for (i = 0; i < state_htab_size(env); i++) {
>                 sl = env->explored_states[i];
>
>                 while (sl) {
> @@ -8246,7 +8259,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
>                         goto skip_full_check;
>         }
>
> -       env->explored_states = kvcalloc(env->prog->len,
> +       env->explored_states = kvcalloc(state_htab_size(env),
>                                        sizeof(struct bpf_verifier_state_list *),
>                                        GFP_USER);
>         ret = -ENOMEM;
> --
> 2.20.0
>
