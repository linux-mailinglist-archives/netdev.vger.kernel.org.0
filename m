Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D155F38110D
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 21:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232438AbhENTpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 15:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbhENTpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 15:45:38 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD804C06174A
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 12:44:26 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id z24so29136261ioj.7
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 12:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aurora.tech; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QXt0iRNRIjrwcN/IHW6iywWeJL1wqoa8+ctkut1Q5ok=;
        b=bBF2KNHWRYGB7AeSwi8VFRgpk5x3fVJErgGLD6hYZ0eD0wFUf7YFEuhXfLKcr7fYJk
         h366LmYFGLegMx/RBPOkugoQiTBwK/I5P9R5RlsiwNqYXdbIsYk6EXAgQkv0fT//Y08E
         TgD6JFky7lKLGq6tBv49rnHyjrOFwHsf3G95iiVeL5i7bedBWyIVWm1IJvFCh/ttNep5
         rxev77bTHdsBArGOa7189aSHRTo5TwbY6wGlPpGmV1UyHluxza5sc2hUfrCndRaJWTDm
         8NKdIVxHQbc61KXYDrJAbGijcNZA5KOymIAjEzHPjSno/ZxqXbPKSkGx4bNL2YZ3C+w8
         ULLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QXt0iRNRIjrwcN/IHW6iywWeJL1wqoa8+ctkut1Q5ok=;
        b=qC5GzaXMRxWNDWtb6APQYV6L9JdbMwLC6+5bJzD8v11uLKcIhF8ml3Ocu2di3iepKZ
         zYfEVBgGh6FqQFDn5vd3fYlhcq8ouf/H5GKphBife4CR4sGQfCEGUsqvQYQ1JKLGXFn8
         0Xfu1lNT3UhVINie4rOociMgfcs0qp6ql9UgihB5Dxoev7dpKJGKxdotGuN1KclehNgT
         ZgPFdqfqT7EnDrT6Q+LupWr9Vp6bBJ7wWSxugzFGnlKK66qIfqcT79GyAyUtUr2FKgxB
         iXHnAnvUqOB87yXH+hqR+VwcpproOStIZEJWNvO7b06+y3exwQx5yocQOzID19cgwUuD
         Cm5Q==
X-Gm-Message-State: AOAM530JnFr042vyPQLvcuM8uaUDmSvt/Qg2EHDqAx5ZfxQjv75dbZXd
        k3841aLjUF4KYUmi5e9efhx/BnpfBaLO3afAzbC+Nw==
X-Google-Smtp-Source: ABdhPJzWRaA7wpZGenPItwv+QdHzzPPZA3ye1kLp+NXJsJtv/uZgxyMs6frSC4GkcuGgwB4s2vsdBoZ8KaC/79WLaRw=
X-Received: by 2002:a02:b717:: with SMTP id g23mr46125633jam.109.1621021466186;
 Fri, 14 May 2021 12:44:26 -0700 (PDT)
MIME-Version: 1.0
References: <YJofplWBz8dT7xiw@localhost.localdomain> <20210512214324.hiaiw3e2tzmsygcz@linutronix.de>
 <87k0o360zx.ffs@nanos.tec.linutronix.de> <20210514115649.6c84fdc3@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20210514115649.6c84fdc3@kicinski-fedora-PC1C0HJN>
From:   Alison Chaiken <achaiken@aurora.tech>
Date:   Fri, 14 May 2021 12:44:15 -0700
Message-ID: <CAFzL-7vTcr75ho0kKs+0PxD3UFRE9=KtNQKJGTx7u-LzGK_oxA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: Treat __napi_schedule_irqoff() as
 __napi_schedule() on PREEMPT_RT
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, sassmann@redhat.com,
        "David S. Miller" <davem@davemloft.net>, stable-rt@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 11:56 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 13 May 2021 00:28:02 +0200 Thomas Gleixner wrote:
> > On Wed, May 12 2021 at 23:43, Sebastian Andrzej Siewior wrote:
> > > __napi_schedule_irqoff() is an optimized version of __napi_schedule()
> > > which can be used where it is known that interrupts are disabled,
> > > e.g. in interrupt-handlers, spin_lock_irq() sections or hrtimer
> > > callbacks.
> > >
> > > On PREEMPT_RT enabled kernels this assumptions is not true. Force-
> > > threaded interrupt handlers and spinlocks are not disabling interrupts
> > > and the NAPI hrtimer callback is forced into softirq context which runs
> > > with interrupts enabled as well.
> > >
> > > Chasing all usage sites of __napi_schedule_irqoff() is a whack-a-mole
> > > game so make __napi_schedule_irqoff() invoke __napi_schedule() for
> > > PREEMPT_RT kernels.
> > >
> > > The callers of ____napi_schedule() in the networking core have been
> > > audited and are correct on PREEMPT_RT kernels as well.
> > >
> > > Reported-by: Juri Lelli <juri.lelli@redhat.com>
> > > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> >
> > Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
> >
> > > ---
> > > Alternatively __napi_schedule_irqoff() could be #ifdef'ed out on RT and
> > > an inline provided which invokes __napi_schedule().
> > >
> > > This was not chosen as it creates #ifdeffery all over the place and with
> > > the proposed solution the code reflects the documentation consistently
> > > and in one obvious place.
> >
> > Blame me for that decision.
> >
> > No matter which variant we end up with, this needs to go into all stable
> > RT kernels ASAP.
>
> Mumble mumble. I thought we concluded that drivers used on RT can be
> fixed, we've already done it for a couple drivers (by which I mean two).
> If all the IRQ handler is doing is scheduling NAPI (which it is for
> modern NICs) - IRQF_NO_THREAD seems like the right option.
>
> Is there any driver you care about that we can convert to using
> IRQF_NO_THREAD so we can have new drivers to "do the right thing"
> while the old ones depend on this workaround for now?
>
>
> Another thing while I have your attention - ____napi_schedule() does
> __raise_softirq_irqoff() which AFAIU does not wake the ksoftirq thread.
> On non-RT we get occasional NOHZ warnings when drivers schedule napi
> from process context, but on RT this is even more of a problem, right?
> ksoftirqd won't run until something else actually wakes it up?

By "NOHZ warnings," do you mean "NOHZ: local_softirq_pending"?    We see
that message about once a week with 4.19.   Presumably any failure of
____napi_schedule() to wake ksoftirqd could only cause problems for the
NET_RX softirq, so if the pending softirq is different, the cause lies
elsewhere.

-- Alison Chaiken
   Aurora Innovation
