Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 275432C1959
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 00:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgKWXVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 18:21:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:58436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725921AbgKWXVJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 18:21:09 -0500
Received: from localhost (unknown [176.167.152.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4344320691;
        Mon, 23 Nov 2020 23:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606173668;
        bh=CKEZj+lJVWkeVVIkmbst5AlXQtm5TYqw8mkzx03cZBU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zpqpMZvcXj6eTZp/HvX7RSWVfU6lHF73DU+DFeuP40CbQiCiDOIg1/VNvpX1jv6cD
         Gt3rCu0U+kSHPlMbzN7C3jATvZXGSXHffUaym7cB38YrFwbHnTI/aFUVqHhsz/7SQE
         KtHgEJvoXzPT3SHCBdQxaAUJhf1EzU4WZWSzY7ac=
Date:   Tue, 24 Nov 2020 00:21:06 +0100
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Alex Belits <abelits@marvell.com>
Cc:     Prasun Kapoor <pkapoor@marvell.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "trix@redhat.com" <trix@redhat.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "nitesh@redhat.com" <nitesh@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "will@kernel.org" <will@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "leon@sidebranch.com" <leon@sidebranch.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "pauld@redhat.com" <pauld@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH v5 9/9] task_isolation: kick_all_cpus_sync:
 don't kick isolated cpus
Message-ID: <20201123232106.GD1751@lothringen>
References: <8d887e59ca713726f4fcb25a316e1e932b02823e.camel@marvell.com>
 <3236b13f42679031960c5605be20664e90e75223.camel@marvell.com>
 <20201123222907.GC1751@lothringen>
 <c65ac23c1c408614110635c33eaf4ace98da4343.camel@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c65ac23c1c408614110635c33eaf4ace98da4343.camel@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 10:39:34PM +0000, Alex Belits wrote:
> 
> On Mon, 2020-11-23 at 23:29 +0100, Frederic Weisbecker wrote:
> > External Email
> > 
> > -------------------------------------------------------------------
> > ---
> > On Mon, Nov 23, 2020 at 05:58:42PM +0000, Alex Belits wrote:
> > > From: Yuri Norov <ynorov@marvell.com>
> > > 
> > > Make sure that kick_all_cpus_sync() does not call CPUs that are
> > > running
> > > isolated tasks.
> > > 
> > > Signed-off-by: Yuri Norov <ynorov@marvell.com>
> > > [abelits@marvell.com: use safe task_isolation_cpumask()
> > > implementation]
> > > Signed-off-by: Alex Belits <abelits@marvell.com>
> > > ---
> > >  kernel/smp.c | 14 +++++++++++++-
> > >  1 file changed, 13 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/kernel/smp.c b/kernel/smp.c
> > > index 4d17501433be..b2faecf58ed0 100644
> > > --- a/kernel/smp.c
> > > +++ b/kernel/smp.c
> > > @@ -932,9 +932,21 @@ static void do_nothing(void *unused)
> > >   */
> > >  void kick_all_cpus_sync(void)
> > >  {
> > > +	struct cpumask mask;
> > > +
> > >  	/* Make sure the change is visible before we kick the cpus */
> > >  	smp_mb();
> > > -	smp_call_function(do_nothing, NULL, 1);
> > > +
> > > +	preempt_disable();
> > > +#ifdef CONFIG_TASK_ISOLATION
> > > +	cpumask_clear(&mask);
> > > +	task_isolation_cpumask(&mask);
> > > +	cpumask_complement(&mask, &mask);
> > > +#else
> > > +	cpumask_setall(&mask);
> > > +#endif
> > > +	smp_call_function_many(&mask, do_nothing, NULL, 1);
> > > +	preempt_enable();
> > 
> > Same comment about IPIs here.
> 
> This is different from timers. The original design was based on the
> idea that every CPU should be able to enter kernel at any time and run
> kernel code with no additional preparation. Then the only solution is
> to always do full broadcast and require all CPUs to process it.
> 
> What I am trying to introduce is the idea of CPU that is not likely to
> run kernel code any soon, and can afford to go through an additional
> synchronization procedure on the next entry into kernel. The
> synchronization is not skipped, it simply happens later, early in
> kernel entry code.

Ah I see, this is ordered that way:

ll_isol_flags = ISOLATED

         CPU 0                                CPU 1
    ------------------                       -----------------
                                            // kernel entry
    data_to_sync = 1                        ll_isol_flags = ISOLATED_BROKEN
    smp_mb()                                smp_mb()
    if ll_isol_flags(CPU 1) == ISOLATED     READ data_to_sync
         smp_call(CPU 1)

You should document that, ie: explain why what you're doing is safe.

Also Beware though that the data to sync in question doesn't need to be visible
in the entry code before task_isolation_kernel_enter(). You need to audit all
the callers of kick_all_cpus_sync().
