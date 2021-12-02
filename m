Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4CC46665D
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 16:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358920AbhLBPZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 10:25:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358923AbhLBPZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 10:25:52 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7BD3C06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 07:22:29 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id v64so554566ybi.5
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 07:22:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TUht/ntf/ensvlsmzh+M2wDOvlyEVZyPmC8DOWE2/yY=;
        b=HFK94NWCMnYwmwTIXgerTojSRw+PzyEDfc+p6TkyU649F7e5YU5lGc6eiI6DZo0+bY
         IeNen/mLoiiB4k0F00yCH2I0Q1P9AowD2g7MRouwywls2X4Kpu9K4kPko8pRLibDIyNR
         a7miTOhawxIeSMNMWliPO2Y8xuLeP8xPj6nlctq8QNFaao6Z4H+zXlY/9oU8xm1ZMzvu
         wSt0kihGZCFgd9mMDwg3bBZ+SCUSg70Be6bmAYKBdYUPpIpe6yTLeT/NLi4kUCWoRbCN
         n7P09U4VhIkLqmjXR3NwvPK+XOw/wCjMU6DCowBIecg/MCv0S0MBBdCQWIbfgFOHn7Dl
         /1SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TUht/ntf/ensvlsmzh+M2wDOvlyEVZyPmC8DOWE2/yY=;
        b=FgBxu77PxWI51r4QO1MfQuFDBPTFlCyiygTBnM9ABzWlQ4b4K2xF1I6NPIiX2YpgV3
         45msxWx1xATlCnnhfiG746m7KOqeZLLGRVsGOEhsFeVGfnzBCjlkOU0UX14ksY9/Q27V
         aDM5QOTQb+bB9Jki0YFtH8MXFk9u/p2o0pDXjEoFYiFsz1FSCAVyTMCVw4vvuBge4E/v
         oyY5O3Qr1ZXZiyPUy4JM+LMNKlvFx9g44hMA97wWoGK3ryt6xCuytJVOR753vLwNEIbZ
         jVG52wK/puDy0IxSbiAUgt7ImPu+qwm9zu5t7OPQFngu8s5PQjz6TVy2ejWowpmJrvzO
         3kog==
X-Gm-Message-State: AOAM532xbA4CW/wRcC5s64BWxLjALswA89DuTPnr5/DLp/uYjPDOlIR9
        AwI8FkFBfaitzoV9FVB8jMbE7zuoacn9PqXdBp4Jqg==
X-Google-Smtp-Source: ABdhPJyHeuvmT8TGJMYREpEP/EUUevyGiUabsj1qEHu03mYQ/Z2cYumbFr5cJqxs9FLSigPkxyDQssKbhbDQp8hQkm4=
X-Received: by 2002:a05:6902:1025:: with SMTP id x5mr16286645ybt.156.1638458548592;
 Thu, 02 Dec 2021 07:22:28 -0800 (PST)
MIME-Version: 1.0
References: <20211124202446.2917972-1-eric.dumazet@gmail.com>
 <20211124202446.2917972-3-eric.dumazet@gmail.com> <20211202131040.rdxzbfwh2slhftg5@skbuf>
 <88b82ae31dc54a4c8b2173487f61ffe9@AcuMS.aculab.com>
In-Reply-To: <88b82ae31dc54a4c8b2173487f61ffe9@AcuMS.aculab.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 2 Dec 2021 07:22:17 -0800
Message-ID: <CANn89iLok_EZ1L0ZYxQ+H9Wi+SPrgiyhWpAnVnQBfc5qcKgHWw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: optimize skb_postpull_rcsum()
To:     David Laight <David.Laight@aculab.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        David Lebrun <dlebrun@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 2, 2021 at 7:06 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Vladimir Oltean
> > Sent: 02 December 2021 13:11
> ...
> > > --- a/include/linux/skbuff.h
> > > +++ b/include/linux/skbuff.h
> > > @@ -3485,7 +3485,11 @@ __skb_postpull_rcsum(struct sk_buff *skb, const void *start, unsigned int
> > len,
> > >  static inline void skb_postpull_rcsum(struct sk_buff *skb,
> > >                                   const void *start, unsigned int len)
> > >  {
> > > -   __skb_postpull_rcsum(skb, start, len, 0);
> > > +   if (skb->ip_summed == CHECKSUM_COMPLETE)
> > > +           skb->csum = ~csum_partial(start, len, ~skb->csum);
>
> You can't do that, the domain is 1..0xffff (or maybe 0xffffffff).
> The invert has to convert ~0 to ~0 not zero.
> ...
> > There seems to be a disparity when the skb->csum is calculated by
> > skb_postpull_rcsum as zero. Before, it was calculated as 0xffff.
>
> Which is what that will do for some inputs at least.
> Maybe:
>                 skb->csum = 1 + ~csum_partial(start, len, ~skb->csum + 1);
> is right.
> I think that is the same as:
>                 skb->csum = -csum_partial(start, len, -skb->csum);
> Although letting the compiler do that transform probably makes
> the code easier to read.
>
>

Interesting, update_csum_diff4() and update_csum_diff16() seem to both use.

skb->csum = ~csum_partial((char *)diff, sizeof(diff), ~skb->csum);
