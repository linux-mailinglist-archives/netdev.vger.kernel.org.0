Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C18825BE5
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 04:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbfEVCSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 22:18:00 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34293 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfEVCSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 22:18:00 -0400
Received: by mail-pl1-f195.google.com with SMTP id w7so278886plz.1;
        Tue, 21 May 2019 19:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=me3hIszFiejEja+IiLXEdpPegYmFNgu1ot9KjRPrh8g=;
        b=HY55fYFAmn46KTT26LTZrIQdnJ8f+SHDBtON+JrIFgHOshfGuqhCP732dMXZoHIRV+
         TyGnNDyMVZlvfeihtXwBEMZir7bTVs/Lail7vxu7yAZQ36HScpieuu3UULg4ses25n5N
         eQjph0V42w7yzymDe7pNvKKQa0Bq6p6QRz3mIq/jtpdtfzxViueZkEaUGoHfvhNPg5Tx
         4IwNMugE0z6cY62VYKV2cFO+OGXeCdInIxi2Rj5WHtsjteVwwPSmA9JDRcR+FPa49dGg
         4Mgqm5iaWCIn6+/4QbKImB49GUQPmWlT9WRedgcqlMK4BeNJa5zV7gyKlFvzCV9/skO0
         /UUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=me3hIszFiejEja+IiLXEdpPegYmFNgu1ot9KjRPrh8g=;
        b=N10SbVjhsu8dYzGPMjKQ0Zh7sjPtBMeY8XyPx2dqVnDJO39Y8bvvnFnbT03MBhLYjL
         PJjx4D+vtCxOUqhgCjDz9rGb5CwbjOJpKYIKFipWRjA1mnOfPOzZdrV+fRomzsLBsqTq
         jQsNs7o5qn6iHB8ImHKf64clCFaQh6XpJGAemrodEjcnCge81QL/B7GWY9nRChkNXuLr
         DGmezquYXnYVMjtcVkws24NUQ5vDFMeGl0j1PuazeuD4UReYCXVeJwWv5/Tx0bFqrxjo
         yuhtirR24PEoGegRdI7b+2ha6kL1/NOt0SkTW7USjI7shuukD6Qm3uAkfo4ExMmGyNQ2
         uBRg==
X-Gm-Message-State: APjAAAXn0bKo22gszoxlBHkHpCWHhKCE73M2a0Bo76SWje5A8ZCLMl2v
        i0uI9EuP8jS+lVLHIlqqfex8Sls3
X-Google-Smtp-Source: APXvYqwCqv4r9EAfmfXcwEykUyhtjCRJMXq1/urK95bEL85Jm3GDAOzIEKxBqNsJFPWrhFxnTxweNg==
X-Received: by 2002:a17:902:5c5:: with SMTP id f63mr85659969plf.327.1558491478930;
        Tue, 21 May 2019 19:17:58 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::d0e7])
        by smtp.gmail.com with ESMTPSA id r138sm30504152pfr.2.2019.05.21.19.17.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 19:17:58 -0700 (PDT)
Date:   Tue, 21 May 2019 19:17:55 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 3/3] bpf: convert explored_states to hash table
Message-ID: <20190522021753.2sm2ixz644r4cnnu@ast-mbp.dhcp.thefacebook.com>
References: <20190521230635.2142522-1-ast@kernel.org>
 <20190521230635.2142522-4-ast@kernel.org>
 <CAEf4BzZkWWCqEJ8mKJjqkF1FpvP+urJ5dcdhneCoPd4wtViOww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZkWWCqEJ8mKJjqkF1FpvP+urJ5dcdhneCoPd4wtViOww@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 21, 2019 at 05:55:06PM -0700, Andrii Nakryiko wrote:
> On Tue, May 21, 2019 at 4:08 PM Alexei Starovoitov <ast@kernel.org> wrote:
> >
> > All prune points inside a callee bpf function most likely will have
> > different callsites. For example, if function foo() is called from
> > two callsites the half of explored states in all prune points in foo()
> > will be useless for subsequent walking of one of those callsites.
> > Fortunately explored_states pruning heuristics keeps the number of states
> > per prune point small, but walking these states is still a waste of cpu
> > time when the callsite of the current state is different from the callsite
> > of the explored state.
> >
> > To improve pruning logic convert explored_states into hash table and
> > use simple insn_idx ^ callsite hash to select hash bucket.
> > This optimization has no effect on programs without bpf2bpf calls
> > and drastically improves programs with calls.
> > In the later case it reduces total memory consumption in 1M scale tests
> > by almost 3 times (peak_states drops from 5752 to 2016).
> >
> > Care should be taken when comparing the states for equivalency.
> > Since the same hash bucket can now contain states with different indices
> > the insn_idx has to be part of verifier_state and compared.
> >
> > Different hash table sizes and different hash functions were explored,
> > but the results were not significantly better vs this patch.
> > They can be improved in the future.
> >
> > Hit/miss heuristic is not counting index miscompare as a miss.
> > Otherwise verifier stats become unstable when experimenting
> > with different hash functions.
> >
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
> >  include/linux/bpf_verifier.h |  1 +
> >  kernel/bpf/verifier.c        | 23 ++++++++++++++++++-----
> >  2 files changed, 19 insertions(+), 5 deletions(-)
> >
> > diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> > index 02bba09a0ea1..405b502283c5 100644
> > --- a/include/linux/bpf_verifier.h
> > +++ b/include/linux/bpf_verifier.h
> > @@ -187,6 +187,7 @@ struct bpf_func_state {
> >  struct bpf_verifier_state {
> >         /* call stack tracking */
> >         struct bpf_func_state *frame[MAX_CALL_FRAMES];
> > +       u32 insn_idx;
> >         u32 curframe;
> >         u32 active_spin_lock;
> >         bool speculative;
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 89097a4b1bf3..082f6eefb1c4 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -5435,11 +5435,19 @@ enum {
> >         BRANCH = 2,
> >  };
> >
> > +static u32 state_htab_size(struct bpf_verifier_env *env)
> 
> maybe mark it as inline function? it's called pretty heavily.

The kernel convention is no 'inline' in .c

> >  static struct bpf_verifier_state_list **explored_state(
> >                                         struct bpf_verifier_env *env,
> >                                         int idx)
> >  {
> > -       return &env->explored_states[idx];
> > +       struct bpf_verifier_state *cur = env->cur_state;
> > +       struct bpf_func_state *state = cur->frame[cur->curframe];
> > +
> > +       return &env->explored_states[(idx ^ state->callsite) % state_htab_size(env)];
> 
> % is slow, see [1] for faster alternative.
> 
> Alternatively, if you can make sure that hash size is power of two,
> then multiplicative Fibonacci hashing is preferred ([2]).
> 
> [1] https://lemire.me/blog/2016/06/27/a-fast-alternative-to-the-modulo-reduction/
> [2] https://probablydance.com/2018/06/16/fibonacci-hashing-the-optimization-that-the-world-forgot-or-a-better-alternative-to-integer-modulo/

a % b -> ((u64) a * (u64) b) >> 32 transformation assumes good
distribution of 'a'. Here it's clearly not the case.
According to Jakub's analysis the verifier marks every 4th insn
as prune_point, so this array is only quarter full.
As an experiment I've tried to shrink the size by three times and
didn't observe any significant slowdown in verification time,
but decided to keep it as-is for simplicity.
For the same reasons I avoided roundup_to_power2.
I prefer readability vs microptimization.
The cost of modulo vs multiple alu is a noise
considering everything the verifier is doing.

> >  }
> >
> >  static void init_explored_state(struct bpf_verifier_env *env, int idx)
> > @@ -6018,7 +6026,8 @@ static void clean_live_states(struct bpf_verifier_env *env, int insn,
> >
> >         sl = *explored_state(env, insn);
> >         while (sl) {
> > -               if (sl->state.curframe != cur->curframe)
> > +               if (sl->state.insn_idx != insn ||
> > +                   sl->state.curframe != cur->curframe)
> >                         goto next;
> >                 for (i = 0; i <= cur->curframe; i++)
> >                         if (sl->state.frame[i]->callsite != cur->frame[i]->callsite)
> > @@ -6384,6 +6393,9 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
> >         clean_live_states(env, insn_idx, cur);
> >
> >         while (sl) {
> > +               states_cnt++;
> > +               if (sl->state.insn_idx != insn_idx)
> > +                       goto next;
> 
> Shouldn't this be checked inside states_equal? Or you are trying to
> avoid function call overhead? If the latter is the case, then you
> should probably compare curframe as well here?

It's not equivalent.
Here is what commit log say:
 Hit/miss heuristic is not counting index miscompare as a miss.
 Otherwise verifier stats become unstable when experimenting
 with different hash functions.

If insn comparison is done inside states_equal() then
miss > hit * 3 + 3 heuristic affects 'collisions'.
The cases where different indices fall into the same bucket.
And verifier stats fluctuate when hash function or size changes.

