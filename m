Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 439002A5F35
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 09:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgKDIRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 03:17:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725896AbgKDIRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 03:17:10 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E3AC061A4D
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 00:17:10 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id u62so21342238iod.8
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 00:17:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GJUWAY2xwnHDXZb6q+y92fQ+8JQreu9EFvW1bS2gJz4=;
        b=Ja+CBP19FaVQQB03iH6mV2ThTPHWINukkanRxKJ9fUv069/mdE0Op5+ve8QwUgi9K0
         dC0R9/SBFJJtB39gT/M/9tnhKNFlPVKtQwRCvkkZSVm6VID151j7W375qRS4YaI+PieH
         LZ5neOIsCbeJfROSGG1s6f0ZtvgBIUq2rLlNa7IYrWLuyCLjgrJP4DxAWA6XZl39eap1
         3oR3mRKgU+DkpwBakllRIPREYLZQ5HlAg/5VepbfNN7/0khzFAilSyUzcXybDc+mXB6S
         ILfg8/ukCAkiRKxzPWg0iCQkGbiq4FT1pSP7lGWabSmmdTuoloYjON8LdiFDNVuNPA14
         jRdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GJUWAY2xwnHDXZb6q+y92fQ+8JQreu9EFvW1bS2gJz4=;
        b=EBYhvFEspwkaBsfxeRmeIUTT9IHvPoO/fKKQvcG9it0hguYRw9QTsDqF+uKjD2Y5+g
         PG43HTTetqmlnKoe9FUxtsQOAM9o6IvawTQ3wKzKzXJspezL1d8IOucwyLrVyqlhMAZY
         pN/rJpEnGiWdULGd18aZt3o7nPhDdIzZBqfS3C4n+gx4kH2NqBzW9xCnTKGf1Rx77Ozy
         wJ6mT5bCcB+A0luBey8SA2NGqmVY4uAffYgCg25iQ5sPA+XRDqP/XRlO/lveRne/149J
         oSnzdYvU1F1DczUHYmOKsqiEcX2bCxqFjnh9/+t4IRGd6VoMy98H3Zj4tdE5fvRanypt
         6B4A==
X-Gm-Message-State: AOAM530VuOYMBUCvjCRyZUPGl/t4KqCmoyEtjaemBFBpEVsytznwxbvk
        NlhX12z3OhssO2h4FysqNhv5WzfzmbJ1sCTzwbqOLX+O2nsyBQ==
X-Google-Smtp-Source: ABdhPJw7/6qBxdy636QLBWMOZZHGp1rtY9V/tyrE9061OHNSi3ITXXq3V0BHmKwqJfC3L0me2VABQDPakM6r2RjL3ZE=
X-Received: by 2002:a02:6948:: with SMTP id e69mr19545743jac.6.1604477829334;
 Wed, 04 Nov 2020 00:17:09 -0800 (PST)
MIME-Version: 1.0
References: <20201103220636.972106-1-mkl@pengutronix.de> <20201103220636.972106-6-mkl@pengutronix.de>
 <20201103172102.3d75cb96@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201103172102.3d75cb96@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 4 Nov 2020 09:16:57 +0100
Message-ID: <CANn89iK5xqYmLT=DZk0S15pRObSJbo2-zrO7_A0Q46Ujg1RxYg@mail.gmail.com>
Subject: Re: [net 05/27] can: dev: can_get_echo_skb(): prevent call to
 kfree_skb() in hard IRQ context
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 4, 2020 at 2:21 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue,  3 Nov 2020 23:06:14 +0100 Marc Kleine-Budde wrote:
> > From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> >
> > If a driver calls can_get_echo_skb() during a hardware IRQ (which is often, but
> > not always, the case), the 'WARN_ON(in_irq)' in
> > net/core/skbuff.c#skb_release_head_state() might be triggered, under network
> > congestion circumstances, together with the potential risk of a NULL pointer
> > dereference.
> >
> > The root cause of this issue is the call to kfree_skb() instead of
> > dev_kfree_skb_irq() in net/core/dev.c#enqueue_to_backlog().
> >
> > This patch prevents the skb to be freed within the call to netif_rx() by
> > incrementing its reference count with skb_get(). The skb is finally freed by
> > one of the in-irq-context safe functions: dev_consume_skb_any() or
> > dev_kfree_skb_any(). The "any" version is used because some drivers might call
> > can_get_echo_skb() in a normal context.
> >
> > The reason for this issue to occur is that initially, in the core network
> > stack, loopback skb were not supposed to be received in hardware IRQ context.
> > The CAN stack is an exeption.
> >
> > This bug was previously reported back in 2017 in [1] but the proposed patch
> > never got accepted.
> >
> > While [1] directly modifies net/core/dev.c, we try to propose here a
> > smoother modification local to CAN network stack (the assumption
> > behind is that only CAN devices are affected by this issue).
> >
> > [1] http://lore.kernel.org/r/57a3ffb6-3309-3ad5-5a34-e93c3fe3614d@cetitec.com
> >
> > Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> > Link: https://lore.kernel.org/r/20201002154219.4887-2-mailhol.vincent@wanadoo.fr
> > Fixes: 39549eef3587 ("can: CAN Network device driver and Netlink interface")
> > Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
>
> Hm... Why do we receive a skb with a socket attached?
>
> At a quick glance this is some loopback, so shouldn't we skb_orphan()
> in the xmit function instead?

Yes this would work, this seems the safest way, loopback_xmit() is a
good template for this.

>
> Otherwise we should probably fix this in enqueue_to_backlog().

This is dangerous.

If we drop packets under flood because the per-cpu backlog is full,
we might also be in _big_ trouble if the per-cpu
softnet_data.completion_queue is filling,
since we do not have a limit on this list.

What could happen is that when the memory is finally exhausted and no
more skb can be fed
to netif_rx(), a big latency spike would happen when
softnet_data.completion_queue
can finally be purged in one shot.

So skb_orphan(skb) in CAN before calling netif_rx() is better IMO.

>
> > diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
> > index b70ded3760f2..73cfcd7e9517 100644
> > --- a/drivers/net/can/dev.c
> > +++ b/drivers/net/can/dev.c
> > @@ -538,7 +538,11 @@ unsigned int can_get_echo_skb(struct net_device *dev, unsigned int idx)
> >       if (!skb)
> >               return 0;
> >
> > -     netif_rx(skb);
> > +     skb_get(skb);
> > +     if (netif_rx(skb) == NET_RX_SUCCESS)
> > +             dev_consume_skb_any(skb);
> > +     else
> > +             dev_kfree_skb_any(skb);
> >
> >       return len;
> >  }
>
