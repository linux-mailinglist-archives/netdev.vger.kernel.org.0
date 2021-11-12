Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587CA44E88C
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 15:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235134AbhKLOYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 09:24:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235115AbhKLOYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 09:24:43 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EDCEC061766
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 06:21:52 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id g191-20020a1c9dc8000000b0032fbf912885so6881322wme.4
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 06:21:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fiCmxbpNpB6dUPct5On6J3mwsdN3UBO25bt1QCymEUc=;
        b=XzhEDJdqfh6ybCFwLTSfqaBE7x945mjgiIGdLC2gwG1lIKuohMvHqe5n0uAM8jgXPO
         2MmUf5yP8shiGeBCIm59wFVlGl1eZMYC0qCcOeFiXP1ao4rQDenS3FhVDdvayftzgdb2
         i0JXJg5MhKSa9q2xI4FhlVZeHzScdqjfMbpLJwSyod64X5mXAfMKVlMTLk9VCObOaEP1
         iWkR1FDwuP7kKvjQ8309rymfuCqEft+Rn7b/VKQ7PF8QgjprQZx4nlCMRV8s1Q+BZ1Fw
         CEZD5Lx1C5ncjnYDK818leMUr8z+kHbmb0RDL/UjAt8kBpf5QiqkK1DpUfIQ3Y2rEcdE
         e8Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fiCmxbpNpB6dUPct5On6J3mwsdN3UBO25bt1QCymEUc=;
        b=gKypkomROc1hoAx92y29OP+lCv+p5oXjHxOhT3rtnvsVQ0+jBh4SrfNyHuvTJxf2af
         agxso06/Ay/wCiP1c02umQ+nzd4mRKXrzDIi5M7fivmhG/Eqd7jezl60hYo6Uhl3QEg9
         NCWIdbjvXaJROk9djaRIQO6BaVQAyp9zEpP22nN0LEEEZHvXFG3q/FHnVS6AZLkW8ph8
         eTUD1H5BD3fNZ7pODnJZFTeimSn+EBPQp+B0TlfKchFT6HPcqZPcCbDzhzigQ/LkwMbQ
         3R7VJpa70NvVZvOSXCQo79UmWGKwAlcrN73lvtL/S/OYa9XZ90QklX26ZBmpi/QuXacp
         f/yw==
X-Gm-Message-State: AOAM533z+OH3qcgh4ayxaq1NiIu9+7aGv4kbHWVtWXgdC7vKLVLykp+/
        ww2stvwVo8a3B4by4Yi6SwcmfKuAwUYRhz25MIWhWQ==
X-Google-Smtp-Source: ABdhPJzeE2+SG0haALZ1ADr82j2z8X4zODi7QwUe9cbVKZxKIvTkSQ3EqoZHep58PF9riidbyjXrc8dyksQnIrYVp84=
X-Received: by 2002:a7b:c8c8:: with SMTP id f8mr17454867wml.49.1636726910410;
 Fri, 12 Nov 2021 06:21:50 -0800 (PST)
MIME-Version: 1.0
References: <20211111181025.2139131-1-eric.dumazet@gmail.com>
 <CAKgT0UdmECakQTinbTagiG4PWfaniP_GP6T3rLvWdP+mVrB4xw@mail.gmail.com>
 <CANn89iJAakUCC6UuUHSozT9wz7_rrgrRq3dv+hXJ1FL_DCZHyA@mail.gmail.com> <YY4wPgyt65Q6WOdK@hirez.programming.kicks-ass.net>
In-Reply-To: <YY4wPgyt65Q6WOdK@hirez.programming.kicks-ass.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 12 Nov 2021 06:21:38 -0800
Message-ID: <CANn89iJNvxatTTcHvzNKuUu2HyNfH=O7XesA3pHUwfn4Qy=pJQ@mail.gmail.com>
Subject: Re: [PATCH v1] x86/csum: rewrite csum_partial()
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 12, 2021 at 1:13 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Thu, Nov 11, 2021 at 02:30:50PM -0800, Eric Dumazet wrote:
> > > For values 7 through 1 I wonder if you wouldn't be better served by
> > > just doing a single QWORD read and a pair of shifts. Something along
> > > the lines of:
> > >     if (len) {
> > >         shift = (8 - len) * 8;
> > >         temp64 = (*(unsigned long)buff << shift) >> shift;
> > >         result += temp64;
> > >         result += result < temp64;
> > >     }
> >
> > Again, KASAN will not be happy.
>
> If you do it in asm, kasan will not know, so who cares :-) as long as
> the load is aligned, loading beyond @len shouldn't be a problem,
> otherwise there's load_unaligned_zeropad().

OK, but then in this case we have to align buff on qword boundary,
or risk crossing page boundary.

So this stuff has to be done at the beginning, and at the end.

And with IP_IP_ALIGN==0, this will unfortunately trigger for the 40-byte
IPV6 header.

IPv6 header :  <2 bytes before qword boundary><4 * 8 bytes> < 6 bytes at trail>

I will try, but I have some doubts it can save one or two cycles...
