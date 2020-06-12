Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 814031F728F
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 05:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgFLDk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 23:40:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726520AbgFLDk4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 23:40:56 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 876B820835;
        Fri, 12 Jun 2020 03:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591933255;
        bh=vd7bcPbtbMIp5UdKF+DEUXSHMR5maubaM+1JjLQFxjg=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=oQ0K7OQ2UDESsf7QaLPKDXk5xUCQ866U57diPfIILFqyofgzracTuT21wt52wobNL
         nAznRXNywEmSDssA8sLykfaoIgT5I97rcaqGSLcXfx+5Oa2M3YxmoJl8DLpT/uvnim
         b8CitxSTqLsYQ71pNgE3YeUOgy206eRTM3mUYQOw=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 6A07135228C7; Thu, 11 Jun 2020 20:40:55 -0700 (PDT)
Date:   Thu, 11 Jun 2020 20:40:55 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH RFC v3 bpf-next 1/4] bpf: Introduce sleepable BPF programs
Message-ID: <20200612034055.GH4455@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200611222340.24081-1-alexei.starovoitov@gmail.com>
 <20200611222340.24081-2-alexei.starovoitov@gmail.com>
 <CAADnVQ+Ed86oOZPA1rOn_COKPpH1917Q6QUtETkciC8L8+u22A@mail.gmail.com>
 <20200612000447.GF4455@paulmck-ThinkPad-P72>
 <20200612021301.7esez3plqpmjf5wu@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200612021301.7esez3plqpmjf5wu@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 11, 2020 at 07:13:01PM -0700, Alexei Starovoitov wrote:
> On Thu, Jun 11, 2020 at 05:04:47PM -0700, Paul E. McKenney wrote:
> > On Thu, Jun 11, 2020 at 03:29:09PM -0700, Alexei Starovoitov wrote:
> > > On Thu, Jun 11, 2020 at 3:23 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > >  /* dummy _ops. The verifier will operate on target program's ops. */
> > > >  const struct bpf_verifier_ops bpf_extension_verifier_ops = {
> > > > @@ -205,14 +206,12 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
> > > >             tprogs[BPF_TRAMP_MODIFY_RETURN].nr_progs)
> > > >                 flags = BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_SKIP_FRAME;
> > > >
> > > > -       /* Though the second half of trampoline page is unused a task could be
> > > > -        * preempted in the middle of the first half of trampoline and two
> > > > -        * updates to trampoline would change the code from underneath the
> > > > -        * preempted task. Hence wait for tasks to voluntarily schedule or go
> > > > -        * to userspace.
> > > > +       /* the same trampoline can hold both sleepable and non-sleepable progs.
> > > > +        * synchronize_rcu_tasks_trace() is needed to make sure all sleepable
> > > > +        * programs finish executing. It also ensures that the rest of
> > > > +        * generated tramopline assembly finishes before updating trampoline.
> > > >          */
> > > > -
> > > > -       synchronize_rcu_tasks();
> > > > +       synchronize_rcu_tasks_trace();
> > > 
> > > Hi Paul,
> > > 
> > > I've been looking at rcu_trace implementation and I think above change
> > > is correct.
> > > Could you please double check my understanding?
> > 
> > From an RCU Tasks Trace perspective, it looks good to me!
> > 
> > You have rcu_read_lock_trace() and rcu_read_unlock_trace() protecting
> > the readers and synchronize_rcu_trace() waiting for them.
> > 
> > One question given my lack of understanding of BPF:  Are there still
> > tramoplines for non-sleepable BPF programs?  If so, they might still
> > need to use synchronize_rcu_tasks() or some such.
> 
> The same trampoline can hold both sleepable and non-sleepable progs.
> The following is possible:
> . trampoline asm starts
>   . rcu_read_lock + migrate_disable
>     . non-sleepable prog_A
>   . rcu_read_unlock + migrate_enable
> . trampoline asm
>   . rcu_read_lock_trace
>     . sleepable prog_B
>   . rcu_read_unlock_trace
> . trampoline asm
>   . rcu_read_lock + migrate_disable
>     . non-sleepable prog_C
>   . rcu_read_unlock + migrate_enable
> . trampoline asm ends

Ah, new one on me!

> > The general principle is "never mix one type of RCU reader with another
> > type of RCU updater".
> > 
> > But in this case, one approach is to use synchronize_rcu_mult():
> > 
> > 	synchronize_rcu_mult(call_rcu_tasks, call_rcu_tasks_trace);
> 
> That was my first approach, but I've started looking deeper and looks
> like rcu_tasks_trace is stronger than rcu_tasks.
> 'never mix' is a valid concern, so for future proofing the rcu_mult()
> is cleaner, but from safety pov just sync*rcu_tasks_trace() is enough
> even when trampoline doesn't hold sleepable progs, right ?

You really can have synchronize_rcu_tasks_trace() return before
synchronize_rcu_tasks().  And vice versa, though perhaps with less
probability.  So if you need both, you need to use both.

> Also timing wise rcu_mult() is obviously faster than doing
> one at a time, but how do you sort their speeds:
> A: synchronize_rcu_mult(call_rcu_tasks, call_rcu_tasks_trace);
> B: synchronize_rcu_tasks();
> C: synchronize_rcu_tasks_trace();

duration(A) cannot be shorter than either duration(B) or duration(C).
In theory, duration(A) = max(duration(B), duration(C)).  In practice,
things are a bit messier, but the max() is not a bad rule of thumb.

> > That would wait for both types of readers, and do so concurrently.
> > And if there is also a need to wait on rcu_read_lock() and friends,
> > you could do this:
> > 
> > 	synchronize_rcu_mult(call_rcu, call_rcu_tasks, call_rcu_tasks_trace);
> 
> I was about to reply that trampoline doesn't need it and there is no such
> case yet, but then realized that I can use it in hashtab freeing with:
> synchronize_rcu_mult(call_rcu, call_rcu_tasks_trace);
> That would be nice optimization.

Very good!  ;-)

							Thanx, Paul
