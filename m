Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F37257323
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 06:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgHaEqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 00:46:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725794AbgHaEqV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 00:46:21 -0400
Received: from paulmck-ThinkPad-P72.home (unknown [50.45.173.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4796120738;
        Mon, 31 Aug 2020 04:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598849180;
        bh=z07VbWplmd8kSSWFmY0FC8S6ddQoGdWv7RYOj7vXwfA=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=hA4cUsX+crIRQIo8cVhAQix+pQ+n0mK3SA29ns+G5EITCchZ3Bhgw/P1g4goGmk7z
         gyoCcF9DHqAHnAz3+Pvrgag0kqayl4u5A0BeDp7mlmQ3HOHnSv3II+YKxBnitEf2cL
         viluqdlzhdJXdMkC4aPstOuLMjjQQMVVHu++V18s=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 2205F35226AC; Sun, 30 Aug 2020 21:46:20 -0700 (PDT)
Date:   Sun, 30 Aug 2020 21:46:20 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, josef@toxicpanda.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf-next] bpf: Fix build without BPF_SYSCALL, but with
 BPF_JIT.
Message-ID: <20200831044620.GX2855@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200830204328.50419-1-alexei.starovoitov@gmail.com>
 <20200830220313.GV2855@paulmck-ThinkPad-P72>
 <20200831005321.75g5pw2xi4gyrb2i@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200831005321.75g5pw2xi4gyrb2i@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 30, 2020 at 05:53:21PM -0700, Alexei Starovoitov wrote:
> On Sun, Aug 30, 2020 at 03:03:13PM -0700, Paul E. McKenney wrote:
> > On Sun, Aug 30, 2020 at 01:43:28PM -0700, Alexei Starovoitov wrote:
> > > From: Alexei Starovoitov <ast@kernel.org>
> > > 
> > > When CONFIG_BPF_SYSCALL is not set, but CONFIG_BPF_JIT=y
> > > the kernel build fails:
> > > In file included from ../kernel/bpf/trampoline.c:11:
> > > ../kernel/bpf/trampoline.c: In function ‘bpf_trampoline_update’:
> > > ../kernel/bpf/trampoline.c:220:39: error: ‘call_rcu_tasks_trace’ undeclared
> > > ../kernel/bpf/trampoline.c: In function ‘__bpf_prog_enter_sleepable’:
> > > ../kernel/bpf/trampoline.c:411:2: error: implicit declaration of function ‘rcu_read_lock_trace’
> > > ../kernel/bpf/trampoline.c: In function ‘__bpf_prog_exit_sleepable’:
> > > ../kernel/bpf/trampoline.c:416:2: error: implicit declaration of function ‘rcu_read_unlock_trace’
> > > 
> > > Add these functions to rcupdate_trace.h.
> > > The JIT won't call them and BPF trampoline logic won't be used without BPF_SYSCALL.
> > > 
> > > Reported-by: kernel test robot <lkp@intel.com>
> > > Fixes: 1e6c62a88215 ("bpf: Introduce sleepable BPF programs")
> > > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > 
> > A couple of nits below, but overall:
> > 
> > Acked-by: Paul E. McKenney <paulmck@kernel.org>
> > 
> > > ---
> > >  include/linux/rcupdate_trace.h | 14 +++++++++++++-
> > >  1 file changed, 13 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/include/linux/rcupdate_trace.h b/include/linux/rcupdate_trace.h
> > > index d9015aac78c6..334840f4f245 100644
> > > --- a/include/linux/rcupdate_trace.h
> > > +++ b/include/linux/rcupdate_trace.h
> > > @@ -82,7 +82,19 @@ static inline void rcu_read_unlock_trace(void)
> > >  void call_rcu_tasks_trace(struct rcu_head *rhp, rcu_callback_t func);
> > >  void synchronize_rcu_tasks_trace(void);
> > >  void rcu_barrier_tasks_trace(void);
> > > -
> > > +#else
> > 
> > This formulation is a bit novel for RCU.  Could we therefore please add
> > a comment something like this?
> > 
> > // The BPF JIT forms these addresses even when it doesn't call these
> > // functions, so provide definitions that result in runtime errors.
> 
> ok. will add.
> The root of the problem is:
> obj-$(CONFIG_BPF_JIT) += trampoline.o
> obj-$(CONFIG_BPF_JIT) += dispatcher.o
> There is a number of functions that arch/x86/net/bpf_jit_comp.c is
> using from these two files, but none of them will be used when
> only cBPF is on (which is the case for BPF_SYSCALL=n BPF_JIT=y).
> Don't confuse cBPF with eBPF ;)

Perhaps I should avoid this confusion by having you generate the actual
comment?  ;-)

> This patch is imo the lesser of three evils. The other two:
> - some serious refactoring of trampoline.c and dipsatcher.c into
>   multiple files
> - add 'depends on BPF_SYSCALL' to 'config BPF_JIT' in net/Kconfig

The first of these two occurred to me, the second not, but yes, this
sort of reasoning eventually convinced me not to complain about the
solution you chose.

> > > +static inline void call_rcu_tasks_trace(struct rcu_head *rhp, rcu_callback_t func)
> > > +{
> > > +	BUG();
> > > +}
> > > +static inline void rcu_read_lock_trace(void)
> > > +{
> > > +	BUG();
> > > +}
> > > +static inline void rcu_read_unlock_trace(void)
> > > +{
> > > +	BUG();
> > > +}
> > 
> > People have been moving towards one-liner for things like these last two:
> > 
> > static inline void rcu_read_lock_trace(void) { BUG(); }
> > static inline void rcu_read_unlock_trace(void) { BUG(); }
> 
> sure. will respin.

Thank you!

							Thanx, Paul
