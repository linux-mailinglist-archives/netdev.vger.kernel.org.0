Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D43A4500FC
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 10:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbhKOJSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 04:18:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:33472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230364AbhKOJSk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 04:18:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29C3561B73;
        Mon, 15 Nov 2021 09:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636967744;
        bh=r9oe1WB2yKOaxZBH1YwA9HLqfymV/mSoNzUPbR1Btqo=;
        h=In-Reply-To:References:From:Subject:To:Cc:Date:From;
        b=Q02JzfNUM/+u4rNBZTuEfzmSBPCzCqR5fWNrMr4IfqaHF1mo6NxqE7yuIBnq/TpFk
         89ab+IaH+Ergsfzso92O7CxXk+Md6KhxCxgu2Rw/rpXR2adBBa9s0QxqSnuc6IARQX
         NGQWXik/rMGKYmKG4ns01H8XW6HCSw++FOOaa54F3SHJYf6bJlQ/FQci1A3HOQYvey
         5MnbiM+5v4cEEWx06CnY8NNaN0/pBc6i1L0VTtAbcx1Uc/s2r9PrYxsq3sT7JInmBO
         hrtV8GbgcXm+9ehmCnW2dyOdStvOZObXbI4AJKo0QOKwOtKRLHFNDLag+WUEqP9cWO
         uQbKzEhblW5pw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20211108111114.2e37c9d6@gandalf.local.home>
References: <20211020083854.1101670-1-atenart@kernel.org> <20211022130146.3dacef0a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CAPFHKzduJiebgnAAjEvx4vBJCFn7-eyfJ+k6JQja2waxqKeCwQ@mail.gmail.com> <20211108111114.2e37c9d6@gandalf.local.home>
From:   Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH net-next] net: sysctl data could be in .bss
To:     Jonathon Reinhart <jonathon.reinhart@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Netdev List <netdev@vger.kernel.org>,
        tglx@linutronix.de, peterz@infradead.org
Message-ID: <163696774161.3219.11674203766283899465@kwain>
Date:   Mon, 15 Nov 2021 10:15:41 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Jonathon for the analysis and Steven for the review! I'll send
the patch formally then.

Antoine

Quoting Steven Rostedt (2021-11-08 17:11:14)
> On Mon, 8 Nov 2021 00:24:33 -0500
> Jonathon Reinhart <jonathon.reinhart@gmail.com> wrote:
>=20
> > On Fri, Oct 22, 2021 at 4:01 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > Widening the CC list a little.
>=20
> Thanks!
>=20
> [..]
>=20
> > The core_kernel_data() function was introduced in a2d063ac216c1, and
> > the commit message says:
> >=20
> > "It may or may not return true for RO data... This utility function is
> > used to determine if data is safe from ever being freed. Thus it
> > should return true for all RW global data that is not in a module or
> > has been allocated, or false otherwise."
> >=20
> > The intent of the function seems to be more in line with the
> > higher-level "is this global kernel data" semantics you suggested. The
> > purpose seems to be to differentiate between "part of the loaded
> > kernel image" vs. a dynamic allocation (which would include a loaded
> > module image). And given that it *might* return true for RO data
> > (depending on the arch linker script, presumably), I think it would be
> > safe to include .bss -- clearly, with that caveat in place, it isn't
> > promising strict section semantics.
> >=20
> > There are only two existing in-tree consumers:
> >=20
> > 1. __register_ftrace_function() [kernel/trace/ftrace.c] -- Sets
> > FTRACE_OPS_FL_DYNAMIC if core_kernel_data(ops) returns false, which
> > denotes "dynamically allocated ftrace_ops which need special care". It
> > would be unlikely (if not impossible) for the "ops" object in question
> > to be all-zero and end up in the .bss, but if it were, then the
> > current behavior would be wrong. IOW, it would be more correct to
> > include .bss.
> >=20
> > 2. ensure_safe_net_sysctl() [net/sysctl_net.c] (The subject of this
> > thread) -- Trying to distinguish "global kernel data" (static/global
> > variables) from kmalloc-allocated objects. More correct to include
> > .bss.
> >=20
> > Both of these callers only seem to delineate between static and
> > dynamic object allocations. Put another way, if core_kernel_bss(), all
> > existing callers should be updated to check core_kernel_data() ||
> > core_kernel_bss().
> >=20
> > Since Steven introduced it, and until I added
> > ensure_safe_net_sysctl(), he / tracing was the only consumer.
>=20
> I agree with your analysis.
>=20
> The intent is that allocated ftrace_ops (things that function tracer uses
> to know what callbacks are called from function entry), must go through a
> very slow synchronization (rcu_synchronize_tasks). But this is not needed
> if the ftrace_ops is part of the core kernel (.data or .bss) as that will
> never be freed, and thus does not need to worry about it disappearing whi=
le
> they are still in use.
>=20
> >=20
> > Thinking critically from the C language perspective, I can't come up
> > with any case where one would actually expect core_kernel_data() to
> > return true for 'int global =3D 1' and false for 'int global =3D 0'.
> >=20
> > In conclusion, I agree with your alternative proposal Jakub, and I
> > think this patch is the right way forward:
> >=20
> > diff --git a/kernel/extable.c b/kernel/extable.c
> > index b0ea5eb0c3b4..8b6f1d0bdaf6 100644
> > --- a/kernel/extable.c
> > +++ b/kernel/extable.c
> > @@ -97,6 +97,9 @@ int core_kernel_data(unsigned long addr)
> >         if (addr >=3D (unsigned long)_sdata &&
> >             addr < (unsigned long)_edata)
> >                 return 1;
> > +       if (addr >=3D (unsigned long)__bss_start &&
> > +           addr < (unsigned long)__bss_stop)
> > +               return 1;
> >         return 0;
> >  }
>=20
> Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
>=20
> -- Steve
>=20
