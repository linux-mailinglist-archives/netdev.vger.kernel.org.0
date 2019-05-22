Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD3C425C86
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 06:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbfEVEJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 00:09:16 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36863 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbfEVEJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 00:09:16 -0400
Received: by mail-qt1-f196.google.com with SMTP id a17so795621qth.3;
        Tue, 21 May 2019 21:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HwkAua3scVaVR5ROC5wadI9HStdLRE9rx+sWJanld/E=;
        b=LmIMLsE6/zgBhZ1gZEHAEtAj8ALNt5R6BsF/niKyCq9XX5Sb1UARz/W0iKXfHEgfJm
         egmLGkr/SVIRUws2jVDeyhjNXnVWdoNutKAgwOcJ77f3AcBXONzks/fc0U97Xv+PDBn/
         T1Fr6s0xWrogQNGB2p4VgUdQr7H6NmZ9AdEY6UVn98cbymLPxSqznrLtkWEvAXgmYxTo
         4a5oNtPMVYayG86xtXGj8uXYznfwvVT40OhLi5cXW1YcjZtZSAryqoCrIavjZR7iadkD
         nWd2G9niYBXP9diW5eJFZ4Gw3EzQRSBMIcfvyZ/4PbXx1auFbWhEGupFika0UlYMhg4t
         vsTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HwkAua3scVaVR5ROC5wadI9HStdLRE9rx+sWJanld/E=;
        b=PhwdoMgmdYGy1659Tq49wMeDzq15f5GlPCYcHvUhLILO8ICsdNsTuAc3jypnv8ipke
         5UyJJ2lG6ZPMxb8/GQ/UyLOLk2uWRZ9kPLHHSFO6jWoMqMDLGHES6lxDjzInMfWHEOcx
         BrKozw5mSE2RKP5Acmxsix6DIzs/CjCXWuQ9stxAfdB8JX2n4rAugk8yc1dvbQNWLCok
         mZt606DkZY4WcagK8+AfNlSFvRJJELzeZv4xw0SMGD23f9SMhdLT45LzQPECsweKEVlw
         S/VeE2k3UNJdFl62yVKpeIZ7W+JL8/fkJREqx0o2Wk7WwTB+fMwTt9qKaBaoDLCA4WFI
         Fw8Q==
X-Gm-Message-State: APjAAAV3O5AJNOIaoC+2ucZpyk/hklJXt7VvYZEWPCBDgWWMZ94cdEBm
        kP80Eb/mr9X0CWMtbYvB/u4FDFrsYyFP6y9eHSA=
X-Google-Smtp-Source: APXvYqy309HVzt6zQxPfyL9O9KGn0QV1QZ6ZZ+dONUFphEAWJBd+6QAAIeVDN7uqTLaHsKI+NoBUtdrlLJpx47AV+o8=
X-Received: by 2002:a0c:ec92:: with SMTP id u18mr4253259qvo.60.1558498154779;
 Tue, 21 May 2019 21:09:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190521230635.2142522-1-ast@kernel.org> <20190521230635.2142522-4-ast@kernel.org>
 <CAEf4BzZkWWCqEJ8mKJjqkF1FpvP+urJ5dcdhneCoPd4wtViOww@mail.gmail.com> <20190522021753.2sm2ixz644r4cnnu@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20190522021753.2sm2ixz644r4cnnu@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 21 May 2019 21:09:03 -0700
Message-ID: <CAEf4BzYKrKniMmS8mTfcFS8aD1ybTY2RRFq+yXKXoXUpkQeeJA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] bpf: convert explored_states to hash table
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 21, 2019 at 7:17 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, May 21, 2019 at 05:55:06PM -0700, Andrii Nakryiko wrote:
> > On Tue, May 21, 2019 at 4:08 PM Alexei Starovoitov <ast@kernel.org> wrote:
> > >
> > > All prune points inside a callee bpf function most likely will have
> > > different callsites. For example, if function foo() is called from
> > > two callsites the half of explored states in all prune points in foo()
> > > will be useless for subsequent walking of one of those callsites.
> > > Fortunately explored_states pruning heuristics keeps the number of states
> > > per prune point small, but walking these states is still a waste of cpu
> > > time when the callsite of the current state is different from the callsite
> > > of the explored state.
> > >
> > > To improve pruning logic convert explored_states into hash table and
> > > use simple insn_idx ^ callsite hash to select hash bucket.
> > > This optimization has no effect on programs without bpf2bpf calls
> > > and drastically improves programs with calls.
> > > In the later case it reduces total memory consumption in 1M scale tests
> > > by almost 3 times (peak_states drops from 5752 to 2016).
> > >
> > > Care should be taken when comparing the states for equivalency.
> > > Since the same hash bucket can now contain states with different indices
> > > the insn_idx has to be part of verifier_state and compared.
> > >
> > > Different hash table sizes and different hash functions were explored,
> > > but the results were not significantly better vs this patch.
> > > They can be improved in the future.
> > >
> > > Hit/miss heuristic is not counting index miscompare as a miss.
> > > Otherwise verifier stats become unstable when experimenting
> > > with different hash functions.
> > >
> > > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > > ---
> > >  include/linux/bpf_verifier.h |  1 +
> > >  kernel/bpf/verifier.c        | 23 ++++++++++++++++++-----
> > >  2 files changed, 19 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> > > index 02bba09a0ea1..405b502283c5 100644
> > > --- a/include/linux/bpf_verifier.h
> > > +++ b/include/linux/bpf_verifier.h
> > > @@ -187,6 +187,7 @@ struct bpf_func_state {
> > >  struct bpf_verifier_state {
> > >         /* call stack tracking */
> > >         struct bpf_func_state *frame[MAX_CALL_FRAMES];
> > > +       u32 insn_idx;
> > >         u32 curframe;
> > >         u32 active_spin_lock;
> > >         bool speculative;
> > > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > > index 89097a4b1bf3..082f6eefb1c4 100644
> > > --- a/kernel/bpf/verifier.c
> > > +++ b/kernel/bpf/verifier.c
> > > @@ -5435,11 +5435,19 @@ enum {
> > >         BRANCH = 2,
> > >  };
> > >
> > > +static u32 state_htab_size(struct bpf_verifier_env *env)
> >
> > maybe mark it as inline function? it's called pretty heavily.
>
> The kernel convention is no 'inline' in .c

Ah, ok.

>
> > >  static struct bpf_verifier_state_list **explored_state(
> > >                                         struct bpf_verifier_env *env,
> > >                                         int idx)
> > >  {
> > > -       return &env->explored_states[idx];
> > > +       struct bpf_verifier_state *cur = env->cur_state;
> > > +       struct bpf_func_state *state = cur->frame[cur->curframe];
> > > +
> > > +       return &env->explored_states[(idx ^ state->callsite) % state_htab_size(env)];
> >
> > % is slow, see [1] for faster alternative.
> >
> > Alternatively, if you can make sure that hash size is power of two,
> > then multiplicative Fibonacci hashing is preferred ([2]).
> >
> > [1] https://lemire.me/blog/2016/06/27/a-fast-alternative-to-the-modulo-reduction/
> > [2] https://probablydance.com/2018/06/16/fibonacci-hashing-the-optimization-that-the-world-forgot-or-a-better-alternative-to-integer-modulo/
>
> a % b -> ((u64) a * (u64) b) >> 32 transformation assumes good
> distribution of 'a'. Here it's clearly not the case.
> According to Jakub's analysis the verifier marks every 4th insn
> as prune_point, so this array is only quarter full.
> As an experiment I've tried to shrink the size by three times and
> didn't observe any significant slowdown in verification time,
> but decided to keep it as-is for simplicity.
> For the same reasons I avoided roundup_to_power2.
> I prefer readability vs microptimization.
> The cost of modulo vs multiple alu is a noise
> considering everything the verifier is doing.
>

Fair enough, it's totally a microoptimization.

> > >  }
> > >
> > >  static void init_explored_state(struct bpf_verifier_env *env, int idx)
> > > @@ -6018,7 +6026,8 @@ static void clean_live_states(struct bpf_verifier_env *env, int insn,
> > >
> > >         sl = *explored_state(env, insn);
> > >         while (sl) {
> > > -               if (sl->state.curframe != cur->curframe)
> > > +               if (sl->state.insn_idx != insn ||
> > > +                   sl->state.curframe != cur->curframe)
> > >                         goto next;
> > >                 for (i = 0; i <= cur->curframe; i++)
> > >                         if (sl->state.frame[i]->callsite != cur->frame[i]->callsite)
> > > @@ -6384,6 +6393,9 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
> > >         clean_live_states(env, insn_idx, cur);
> > >
> > >         while (sl) {
> > > +               states_cnt++;
> > > +               if (sl->state.insn_idx != insn_idx)
> > > +                       goto next;
> >
> > Shouldn't this be checked inside states_equal? Or you are trying to
> > avoid function call overhead? If the latter is the case, then you
> > should probably compare curframe as well here?
>
> It's not equivalent.
> Here is what commit log say:

Ah, my bad, forgot about that by the time I got to the code. Might be
a good idea to put this in comments in the code.

>  Hit/miss heuristic is not counting index miscompare as a miss.
>  Otherwise verifier stats become unstable when experimenting
>  with different hash functions.
>
> If insn comparison is done inside states_equal() then
> miss > hit * 3 + 3 heuristic affects 'collisions'.
> The cases where different indices fall into the same bucket.
> And verifier stats fluctuate when hash function or size changes.
>

Yeah, that make sense. I wonder if curframe comparison has similar
effect, states from different frames seem similar to hash collisions
between different instruction states in that regard. Or they are not?
