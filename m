Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F40326ACB
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 01:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhB0AeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 19:34:23 -0500
Received: from mail.zx2c4.com ([104.131.123.232]:55706 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229622AbhB0AeW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 19:34:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1614386017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hbzBjOFYVP/R8j01xM6ZpQ7cNRNrtxzoDWx6G2hC79I=;
        b=JBd1RC1s/BqLE+HCU8vIZ5Gh3i4CnRzqx/4/CrqR4//LWSJhpYy7Zn7enEdq/MqKCa1fY+
        sQpne33npP/XSYFWhNFl829EfF129swt/8OLU9O2EsmCGA9ue+SuxP+LyubhOt+FigPRr8
        zfWGB+Lm0iEGvMM1PTtX7SIurxl7IHw=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ef999c60 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Sat, 27 Feb 2021 00:33:36 +0000 (UTC)
Received: by mail-yb1-f178.google.com with SMTP id 133so10664197ybd.5
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 16:33:36 -0800 (PST)
X-Gm-Message-State: AOAM530lxo0HGjuOzhBCVT69yaKFUQHLywjXiI6lLCkRu1Gy7nDJ+XRR
        I44eNJasWX0HcsTemtWgVmmBVxIVzPNws0c6tVE=
X-Google-Smtp-Source: ABdhPJza17L6eRTY8RnRBQN+yTmgKEqfBWkRkp30Fq0AXScxzC3Y7BmSyeBi93djpr6SgJbzXCWp6Lh5JspVEVShvko=
X-Received: by 2002:a25:8712:: with SMTP id a18mr8214275ybl.306.1614386016329;
 Fri, 26 Feb 2021 16:33:36 -0800 (PST)
MIME-Version: 1.0
References: <20210225234631.2547776-1-Jason@zx2c4.com> <CA+FuTScmM12PG96k8ZjGd1zCjAaGzjk3cOS+xam+_h6sx2_HDA@mail.gmail.com>
 <CAHmME9o2yPQ+Ai12XcCjF3jMVcMT_aooFCeKkfgFFOnqPmK_yg@mail.gmail.com> <CA+FuTSdCnCKFrpe-G55rPCq_D7uv4EaQ4z8XW2MOtTRKcWVJYQ@mail.gmail.com>
In-Reply-To: <CA+FuTSdCnCKFrpe-G55rPCq_D7uv4EaQ4z8XW2MOtTRKcWVJYQ@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sat, 27 Feb 2021 01:33:25 +0100
X-Gmail-Original-Message-ID: <CAHmME9rV1=deEkHS=W4ApHSRyN2M=VGhqcYh76DrB3ywDEce0w@mail.gmail.com>
Message-ID: <CAHmME9rV1=deEkHS=W4ApHSRyN2M=VGhqcYh76DrB3ywDEce0w@mail.gmail.com>
Subject: Re: [PATCH] net: always use icmp{,v6}_ndo_send from ndo_start_xmit
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 27, 2021 at 12:29 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Fri, Feb 26, 2021 at 5:39 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > On Fri, Feb 26, 2021 at 10:25 PM Willem de Bruijn
> > <willemdebruijn.kernel@gmail.com> wrote:
> > >
> > > On Thu, Feb 25, 2021 at 6:46 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > > >
> > > > There were a few remaining tunnel drivers that didn't receive the prior
> > > > conversion to icmp{,v6}_ndo_send. Knowing now that this could lead to
> > > > memory corrution (see ee576c47db60 ("net: icmp: pass zeroed opts from
> > > > icmp{,v6}_ndo_send before sending") for details), there's even more
> > > > imperative to have these all converted. So this commit goes through the
> > > > remaining cases that I could find and does a boring translation to the
> > > > ndo variety.
> > > >
> > > > Cc: Willem de Bruijn <willemb@google.com>
> > > > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > >
> > > Using a stack variable over skb->cb[] is definitely the right fix for
> > > all of these. Thanks Jason.
> > >
> > > Only part that I don't fully know is the conntrack conversion. That is
> > > a behavioral change. What is the context behind that? I assume it's
> > > fine. In that if needed, that is the case for all devices, nothing
> > > specific about the couple that call icmp(v6)_ndo_send already.
> >
> > That's actually a sensible change anyway. icmp_send does something
> > bogus if the packet has already passed through netfilter, which is why
> > the ndo variant was adopted. So it's good and correct for these to
> > change in that way.
> >
> > Jason
>
> Something bogus, how? Does this apply to all uses of conntrack?
> Specifically NAT? Not trying to be obtuse, but I really find it hard
> to evaluate that part.

By the time packets hit ndo_start_xmit, the src address has changed,
and icmp can't deliver to the actual source, and its rate limiting
works against the wrong source. All of this was explained, justified,
and discussed on the original icmp_ndo_start patchset, which included
the function and converted drivers to use it. However, a few spots
were missed, which this patchset cleans up. Here's the merge with
details:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=803381f9f117493d6204d82445a530c834040fe6

The network devices that this patch here adjusts are no different than
the four I originally fixed up in that series -- xfrmi, gtp, sunvnet,
wireguard.

> Please cc: the maintainers for patches that are meant to be merged, btw.

Whoops. I'll do so and repost.
