Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C51D1F7123
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 02:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgFLAEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 20:04:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726285AbgFLAEt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 20:04:49 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02D9820853;
        Fri, 12 Jun 2020 00:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591920288;
        bh=zhN9pvX/GHt+eRCGsoMJjH8TB6EC2vueYb5IyBukovA=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=Qjjwr5sPrc8GLc9zLoGnYgc6skDa0XU8ozi6PngAVEpeGbyRGnMAiTg7oBGNgiOte
         K9gD7yabEJthl4+ZwnysDmCXySTCWAgSWdtUdlBTOKKo8BUqbFf6N70E+BeOqOYUIS
         GnCEl9iwS10laOWamEefVDpr4Z0ySvF2b2A5ha04=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id D2C6F35228C7; Thu, 11 Jun 2020 17:04:47 -0700 (PDT)
Date:   Thu, 11 Jun 2020 17:04:47 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH RFC v3 bpf-next 1/4] bpf: Introduce sleepable BPF programs
Message-ID: <20200612000447.GF4455@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200611222340.24081-1-alexei.starovoitov@gmail.com>
 <20200611222340.24081-2-alexei.starovoitov@gmail.com>
 <CAADnVQ+Ed86oOZPA1rOn_COKPpH1917Q6QUtETkciC8L8+u22A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQ+Ed86oOZPA1rOn_COKPpH1917Q6QUtETkciC8L8+u22A@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 11, 2020 at 03:29:09PM -0700, Alexei Starovoitov wrote:
> On Thu, Jun 11, 2020 at 3:23 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> >  /* dummy _ops. The verifier will operate on target program's ops. */
> >  const struct bpf_verifier_ops bpf_extension_verifier_ops = {
> > @@ -205,14 +206,12 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
> >             tprogs[BPF_TRAMP_MODIFY_RETURN].nr_progs)
> >                 flags = BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_SKIP_FRAME;
> >
> > -       /* Though the second half of trampoline page is unused a task could be
> > -        * preempted in the middle of the first half of trampoline and two
> > -        * updates to trampoline would change the code from underneath the
> > -        * preempted task. Hence wait for tasks to voluntarily schedule or go
> > -        * to userspace.
> > +       /* the same trampoline can hold both sleepable and non-sleepable progs.
> > +        * synchronize_rcu_tasks_trace() is needed to make sure all sleepable
> > +        * programs finish executing. It also ensures that the rest of
> > +        * generated tramopline assembly finishes before updating trampoline.
> >          */
> > -
> > -       synchronize_rcu_tasks();
> > +       synchronize_rcu_tasks_trace();
> 
> Hi Paul,
> 
> I've been looking at rcu_trace implementation and I think above change
> is correct.
> Could you please double check my understanding?

From an RCU Tasks Trace perspective, it looks good to me!

You have rcu_read_lock_trace() and rcu_read_unlock_trace() protecting
the readers and synchronize_rcu_trace() waiting for them.

One question given my lack of understanding of BPF:  Are there still
tramoplines for non-sleepable BPF programs?  If so, they might still
need to use synchronize_rcu_tasks() or some such.

The general principle is "never mix one type of RCU reader with another
type of RCU updater".

But in this case, one approach is to use synchronize_rcu_mult():

	synchronize_rcu_mult(call_rcu_tasks, call_rcu_tasks_trace);

That would wait for both types of readers, and do so concurrently.
And if there is also a need to wait on rcu_read_lock() and friends,
you could do this:

	synchronize_rcu_mult(call_rcu, call_rcu_tasks, call_rcu_tasks_trace);

> Also see benchmarking numbers in the cover letter :)

Now -that- is what I am talking about!!!  Very nice!  ;-)

							Thanx, Paul

> >         err = arch_prepare_bpf_trampoline(new_image, new_image + PAGE_SIZE / 2,
> >                                           &tr->func.model, flags, tprogs,
> > @@ -344,7 +343,14 @@ void bpf_trampoline_put(struct bpf_trampoline *tr)
> >         if (WARN_ON_ONCE(!hlist_empty(&tr->progs_hlist[BPF_TRAMP_FEXIT])))
> >                 goto out;
> >         bpf_image_ksym_del(&tr->ksym);
> > -       /* wait for tasks to get out of trampoline before freeing it */
> > +       /* This code will be executed when all bpf progs (both sleepable and
> > +        * non-sleepable) went through
> > +        * bpf_prog_put()->call_rcu[_tasks_trace]()->bpf_prog_free_deferred().
> > +        * Hence no need for another synchronize_rcu_tasks_trace() here,
> > +        * but synchronize_rcu_tasks() is still needed, since trampoline
> > +        * may not have had any sleepable programs and we need to wait
> > +        * for tasks to get out of trampoline code before freeing it.
> > +        */
> >         synchronize_rcu_tasks();
> >         bpf_jit_free_exec(tr->image);
> >         hlist_del(&tr->hlist);
> > @@ -394,6 +400,21 @@ void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start)
> >         rcu_read_unlock();
> >  }
> >
> > +/* when rcu_read_lock_trace is held it means that some sleepable bpf program is
> > + * running. Those programs can use bpf arrays and preallocated hash maps. These
> > + * map types are waiting on programs to complete via
> > + * synchronize_rcu_tasks_trace();
> > + */
> > +void notrace __bpf_prog_enter_sleepable(void)
> > +{
> > +       rcu_read_lock_trace();
> > +}
> > +
> > +void notrace __bpf_prog_exit_sleepable(void)
> > +{
> > +       rcu_read_unlock_trace();
> > +}
> > +
