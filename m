Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46AEF31F13B
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 21:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbhBRUmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 15:42:13 -0500
Received: from mail.zx2c4.com ([104.131.123.232]:35220 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231372AbhBRUk2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 15:40:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1613680782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bHGM/nuTA4UmQ1pSsLE/Ti7zunozB/552cVHwVKMJZQ=;
        b=db2WhlCJMzAROyKrRZHYrZp7XKHU9/gba/k1g4gSML7kAnLNZILSNyLJ33Nd5sMXTF/uNo
        LRaRux9yQL7kX3XTxsFjK4MXwEOmQEvhDfPuGgct5heXCyNy08XUSYjOtKmLZ9/lFEdrS5
        6lI7sJef9mLTun7k40JfR83G+q5JEFI=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 46097537 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Thu, 18 Feb 2021 20:39:42 +0000 (UTC)
Received: by mail-yb1-f171.google.com with SMTP id p186so3477846ybg.2
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 12:39:42 -0800 (PST)
X-Gm-Message-State: AOAM530AsZFfGn0oCdx3AGbpfMvqasHHwN9qC4Mt72VW3l2TtZcqxlbV
        n2yBxGkxv7+tNc5CtxcBcjchvifNqhuHlduha+U=
X-Google-Smtp-Source: ABdhPJz4cALI90Kc84liiu41HIfdncY4ZMf47ohngNZpMPXAnyURa1qh9WAHlBUWLo9XjQDQxyNIR544t8Gp2L/AIuY=
X-Received: by 2002:a25:3cd:: with SMTP id 196mr9686998ybd.456.1613680782197;
 Thu, 18 Feb 2021 12:39:42 -0800 (PST)
MIME-Version: 1.0
References: <CAHmME9o-N5wamS0YbQCHUfFwo3tPD8D3UH=AZpU61oohEtvOKg@mail.gmail.com>
 <20210218160745.2343501-1-Jason@zx2c4.com> <CA+FuTSeyYti3TMUd2EgQqTAjHjV=EXVZtmY9HUdOP0=U8WRyJA@mail.gmail.com>
 <CAHmME9rVuw5tAHUpnsXrLh-WAMXmvqSNFdOUh1XaKZ8bLOow9g@mail.gmail.com>
 <CA+FuTSdiuPK-V5oJOMC7fQsjQKRLt95oP7OAOtR3S5mfUJreKg@mail.gmail.com>
 <CAHmME9oyv+nWk2r3mcVrfdXW_aiex67nSvGiiqLmPOv=RHnhfQ@mail.gmail.com> <CAF=yD-K3wA5yTRSr7kas9xkKZwB2OcYOmqeOx4mpGoQfYCf7ZQ@mail.gmail.com>
In-Reply-To: <CAF=yD-K3wA5yTRSr7kas9xkKZwB2OcYOmqeOx4mpGoQfYCf7ZQ@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 18 Feb 2021 21:39:31 +0100
X-Gmail-Original-Message-ID: <CAHmME9qpRYF9EWAUOAgdoGGJBFNTgdJU3FcNotPgrFGXA-f=VA@mail.gmail.com>
Message-ID: <CAHmME9qpRYF9EWAUOAgdoGGJBFNTgdJU3FcNotPgrFGXA-f=VA@mail.gmail.com>
Subject: Re: [PATCH net v2] net: icmp: pass zeroed opts from
 icmp{,v6}_ndo_send before sending
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        SinYu <liuxyon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 9:37 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Thu, Feb 18, 2021 at 3:25 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > On Thu, Feb 18, 2021 at 9:16 PM Willem de Bruijn
> > <willemdebruijn.kernel@gmail.com> wrote:
> > >
> > > On Thu, Feb 18, 2021 at 12:58 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > > >
> > > > On Thu, Feb 18, 2021 at 5:34 PM Willem de Bruijn
> > > > <willemdebruijn.kernel@gmail.com> wrote:
> > > > > Thanks for respinning.
> > > > >
> > > > > Making ipv4 and ipv6 more aligned is a good goal, but more for
> > > > > net-next than bug fixes that need to be backported to many stable
> > > > > branches.
> > > > >
> > > > > Beyond that, I'm not sure this fixes additional cases vs the previous
> > > > > patch? It uses new on-stack variables instead of skb->cb, which again
> > > > > is probably good in general, but adds more change than is needed for
> > > > > the stable fix.
> > > >
> > > > It doesn't appear to be problematic for applying to stable. I think
> > > > this v2 is the "right way" to handle it. Zeroing out skb->cb is
> > > > unexpected and weird anyway. What if the caller was expecting to use
> > > > their skb->cb after calling icmp_ndo_send? Did they think it'd get
> > > > wiped out like that? This v2 prevents that weird behavior from
> > > > happening.
> > > >
> > > > > My comment on fixing all callers of  icmp{,v6}_send was wrong, in
> > > > > hindsight. In most cases IPCB is set correctly before calling those,
> > > > > so we cannot just zero inside those. If we can only address the case
> > > > > for icmp{,v6}_ndo_send I think the previous patch introduced less
> > > > > churn, so is preferable. Unless I'm missing something.
> > > >
> > > > As mentioned above it's weird and unexpected.
> > > >
> > > > > Reminder of two main comments: sufficient to zero sizeof(IPCB..) and
> > > > > if respinning, please explicitly mention the path that leads to a
> > > > > stack overflow, as it is not immediately obvious (even from reading
> > > > > the fix code?).
> > > >
> > > > I don't intend to respin v1, as I think v2 is more correct, and I
> > > > don't think only zeroing IPCB is a smart idea, as in the future that
> > > > code is bound to break when somebody forgets to update it. This v2
> > > > does away with the zeroing all together, though, so that the right
> > > > bytes to be zeroed are properly enforced all the time by the type
> > > > system.
> > >
> > > I'm afraid this latest version seems to have build issues, as per the
> > > patchwork bot.
> >
> > Hmm I didn't get those bot emails. Either way, I'll do a bit of build
> > testing with different config knobs now and send a v3. Thanks for
> > letting me know.
>
> Different bot :)
>
> You might get emails from the other later. These can be found through
> patchwork at
>
> https://patchwork.kernel.org/project/netdevbpf/patch/20210218160745.2343501-1-Jason@zx2c4.com/

Wow, that is an awesome bot! Can't believe I hadn't seen that.
v3 is posted at
https://patchwork.kernel.org/project/netdevbpf/patch/20210218203404.2429186-1-Jason@zx2c4.com/
and I guess now we're waiting for the bots to get whirling on it.

Jason
