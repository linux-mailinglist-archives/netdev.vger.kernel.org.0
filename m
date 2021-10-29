Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4DF743FEB7
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 16:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbhJ2Ozs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 10:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhJ2Ozn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 10:55:43 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40415C061570
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 07:53:14 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id a129so11740639yba.10
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 07:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8zIydskl2kPdokiXYPXpmR73WGnklkjlhU+Mrz4E8ek=;
        b=aGNz6uzuSZDh2PciSEviSIIshC8VSX9LF7850EvfnW6SGJ/qmH4uJy9lCn6PxZCBH2
         6XqUHkszpKINzXbU6mX8jSSDLLwc1iYgcRWWiMZfnLFLvXBtU7dpyTFlYf0ZismgoBH+
         56RvO6c7DCj5T1lfdBUT24GTlHa+tjprPzXcoc7ul5/e0JBmJFVR4lAhjabl6QmhE91A
         6kuK2tr2KcblTalRxKMwilDnMb2YWEisKTIS3V3N6XrCNYDSGYevSkpRIVjU+dwZ/fyE
         AU+Ra/qSZnM6ikNDdF9ZxrtYGRf6XFjv3MsZGAqJWe4BkOCvBamEHZNE6zdW3Furh+kg
         /DoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8zIydskl2kPdokiXYPXpmR73WGnklkjlhU+Mrz4E8ek=;
        b=CCh/ZtemGdOMQUClowqgqdnk7uB4MYsFlw1Zt9ZKPnbEqnEjzfZa61jxPpvu1Usy3p
         S0+tyJJbeLX/0XIjXsAyvhzYKcdb33t74hYkpSrXs5sCNidFMwzFjsXmusF0Fe392QyJ
         bZZfXqMy468yhNm/t7AdJiKWU9wqupsNZO/sO0Ne16p7Mbz5OxqMuJz3nXJ5eKYyl54w
         I5xXznapCwurshG6kHxWLsqdJxOW0wggXnQRZGjDVOEzuTDPbLW+w5hOH3uWpKcD7OW2
         jd3c8PLR4FFFNEbfh+rnMLFsPc6l7F3mk/y2xbkgoXLwEvU428ggxU2OR4EAJEJCwuRS
         Ai+w==
X-Gm-Message-State: AOAM531hpP18eIFbVT1g+R1unTBWLDcNeNWWVpLrux/RJtY16V4yeOSl
        gpx5dVxHbXU2Zsfi08tX4nukWT3bwglJQw9W0MWF1g==
X-Google-Smtp-Source: ABdhPJwdVH51oBHC4lXJNxfBQrzocqhs5h38EeAEHpUZ9NrWdbhGuvl7ShYLf7TgSY60BWXWJEkdPBoN091ip79nzVQ=
X-Received: by 2002:a25:d652:: with SMTP id n79mr4295152ybg.398.1635519192783;
 Fri, 29 Oct 2021 07:53:12 -0700 (PDT)
MIME-Version: 1.0
References: <20211028191500.47377-1-asadsa@ifi.uio.no> <CADVnQykDUB4DgUaV0rd6-OKafO+F6w=BRfxviuZ_MJLY3xMV+Q@mail.gmail.com>
In-Reply-To: <CADVnQykDUB4DgUaV0rd6-OKafO+F6w=BRfxviuZ_MJLY3xMV+Q@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 29 Oct 2021 07:53:01 -0700
Message-ID: <CANn89iLcTNHCudo-9=RLR1N3o1T0QgVvbedwXeTaFFo5RdMzkg@mail.gmail.com>
Subject: Re: [PATCH net-next] fq_codel: avoid under-utilization with
 ce_threshold at low link rates
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Asad Sajjad Ahmed <asadsa@ifi.uio.no>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Ingemar Johansson S <ingemar.s.johansson@ericsson.com>,
        Tom Henderson <tomh@tomh.org>,
        Bob Briscoe <research@bobbriscoe.net>,
        Olga Albisser <olga@albisser.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 29, 2021 at 6:54 AM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Thu, Oct 28, 2021 at 3:15 PM Asad Sajjad Ahmed <asadsa@ifi.uio.no> wrote:
> >
> > Commit "fq_codel: generalise ce_threshold marking for subset of traffic"
> > [1] enables ce_threshold to be used in the Internet, not just in data
> > centres.
> >
> > Because ce_threshold is in time units, it can cause poor utilization at
> > low link rates when it represents <1 packet.
> > E.g., if link rate <12Mb/s ce_threshold=1ms is <1500B packet.
> >
> > So, suppress ECN marking unless the backlog is also > 1 MTU.
> >
> > A similar patch to [1] was tested on an earlier kernel, and a similar
> > one-packet check prevented poor utilization at low link rates [2].
> >
> > [1] commit dfcb63ce1de6 ("fq_codel: generalise ce_threshold marking for subset of traffic")
> >
> > [2] See right hand column of plots at the end of:
> > https://bobbriscoe.net/projects/latency/dctth_journal_draft20190726.pdf
> >
> > Signed-off-by: Asad Sajjad Ahmed <asadsa@ifi.uio.no>
> > Signed-off-by: Olga Albisser <olga@albisser.org>
> > ---
> >  include/net/codel_impl.h | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/net/codel_impl.h b/include/net/codel_impl.h
> > index 137d40d8cbeb..4e3e8473e776 100644
> > --- a/include/net/codel_impl.h
> > +++ b/include/net/codel_impl.h
> > @@ -248,7 +248,8 @@ static struct sk_buff *codel_dequeue(void *ctx,
> >                                                     vars->rec_inv_sqrt);
> >         }
> >  end:
> > -       if (skb && codel_time_after(vars->ldelay, params->ce_threshold)) {
> > +       if (skb && codel_time_after(vars->ldelay, params->ce_threshold) &&
> > +           *backlog > params->mtu) {

I think this idea would apply to codel quite well.  (This helper is
common to codel and fq_codel)

But with fq_codel my thoughts are:

*backlog is the backlog of the qdisc, not the backlog for the flow,
and it includes the packet currently being removed from the queue.

Setting ce_threshold to 1ms while the link rate is 12Mbs sounds
misconfiguration to me.

Even if this flow has to transmit one tiny packet every minute, it
will get CE mark
just because at least one packet from an elephant flow is currently
being sent to the wire.

BQL won't prevent that at least one packet is being processed while
the tiny packet
is coming into fq_codel qdisc.

vars->ldelay = now - skb_time_func(skb);

For tight ce_threshold, vars->ldelay would need to be replaced by

now - (time of first codel_dequeue() after this skb has been queued).
This seems a bit hard to implement cheaply.




> >                 bool set_ce = true;
> >
> >                 if (params->ce_threshold_mask) {
> > --
>
> Sounds like a good idea, and looks good to me.
>
> Acked-by: Neal Cardwell <ncardwell@google.com>
>
> Eric, what do you think?
>
> neal
