Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18C1555940
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 22:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbfFYUnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 16:43:07 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:43889 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfFYUnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 16:43:06 -0400
Received: by mail-ed1-f65.google.com with SMTP id e3so29056256edr.10
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 13:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ivjo75kEqcIjJ2bVFpjy/lnplvVSJv+34RbXeslOhCw=;
        b=dkwcb03o+MEAoNXYR0sy430qfVDFlkvSP8qEWdopJG9PUzzCD3vuzu7VP8W5rxrie5
         aQybQgV+LugvoK2zah/TSrQOrF+TW5U76V08ZTRUou981KeLuk8NUbfP37qAA3ea1Y55
         2nOUYpQLVlZ2U/J6qwd5ZcXqIw4vvPV9iZJx1D/FJ8X9oDdQ1/jZgdtHwVlLyy0W+yda
         F/Gbv68RqtbiFrmsz7oXP2d9CAf27o5l011M0EIaMpwQFLwAKeZVgxUNJXHD2CMI13W0
         0Q82bi0/yo2kkqqnZm3dErx5frAWZNieXDXkTB4Rj/IT2upP0JTVXt94e/z03BfA8v6i
         96rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ivjo75kEqcIjJ2bVFpjy/lnplvVSJv+34RbXeslOhCw=;
        b=eVlcYzsopv4e4AnEAKXy9AZvdAetZhKnQdN83uIB6MLXvVcy26n3Tt5duxnaNSWnkl
         MAE+5byz1mUBbXlzUfBVkLE7Cp8CZhedRXFh4/i66JdgnXl27mq31zR3nwUaSN+UBjsO
         SM0y1atBb+x14PWlDBY88NtBMhjFOw2wwXRWk3gSnhotFTGbgR8pM9NDwly85vF1NgUI
         l6PgMfG9gPsyP8uOTuXRNdhf9htTTiHKHtYDgULvo8FOKUulr/f/Uje0VQtNDs+2Bj5X
         puIZMDOwxAl+UWw/BKpN3KAxkxVgYAARV2YMrtVJIs/Y3n30khiP8mvcl274nt8AgkIV
         0lGQ==
X-Gm-Message-State: APjAAAXe1NpWYaMx23UcewRtx5rii46fKqZxacyl8GN2O3xQTR0yBG7n
        93CitoPMXtP0JpJN8OFHf3kekyLUBa1sqT7j3A==
X-Google-Smtp-Source: APXvYqzhf8C7rBTmTKhFprwsVhu4LOSE5wrhi+nZ8QY/zxBJCQLTdwiUrmm6hObNvc9wS+/EcFQWOFWms0y14I2swyo=
X-Received: by 2002:a17:906:948c:: with SMTP id t12mr499605ejx.222.1561495385137;
 Tue, 25 Jun 2019 13:43:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190625103359.31102-1-ssuryaextr@gmail.com> <f0a47b5d-6477-9a6a-cf5d-6e13f0b4acdc@gmail.com>
In-Reply-To: <f0a47b5d-6477-9a6a-cf5d-6e13f0b4acdc@gmail.com>
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
Date:   Tue, 25 Jun 2019 16:42:53 -0400
Message-ID: <CAHapkUghFv-DyjY=KtKrJYicJpvRrL1cRa50Gr7tG-H4-10Lzg@mail.gmail.com>
Subject: Re: [PATCH net] vrf: reset rt_iif for recirculated mcast out pkts
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 4:22 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 6/25/19 4:33 AM, Stephen Suryaputra wrote:
> > @@ -363,10 +376,20 @@ int ip_mc_output(struct net *net, struct sock *sk, struct sk_buff *skb)
> >  #endif
> >                  ) {
> >                       struct sk_buff *newskb = skb_clone(skb, GFP_ATOMIC);
> > -                     if (newskb)
> > +                     if (newskb) {
> > +                             /* Reset rt_iif so that inet_iif() will return
> > +                              * skb->dev->ifIndex which is the VRF device for
> > +                              * socket lookup. Setting this to VRF ifindex
> > +                              * causes ipi_ifindex in in_pktinfo to be
> > +                              * overwritten, see ipv4_pktinfo_prepare().
> > +                              */
> > +                             if (netif_is_l3_slave(dev))
>
> seems like the rt_iif is a problem for recirculated mcast packets in
> general, not just ones tied to a VRF.

It seems so to me too but I wonder why this hasn't been seen...
Can I get more feedbacks on this? If there is an agreement to fix this
generally, I will remove the if clause and respin the patch with more
accurate changelog.

>
> > +                                     ip_mc_reset_rt_iif(net, rt, newskb);
> > +
> >                               NF_HOOK(NFPROTO_IPV4, NF_INET_POST_ROUTING,
> >                                       net, sk, newskb, NULL, newskb->dev,
> >                                       ip_mc_finish_output);
> > +                     }
> >               }
> >
> >               /* Multicasts with ttl 0 must not go beyond the host */

Thanks.
