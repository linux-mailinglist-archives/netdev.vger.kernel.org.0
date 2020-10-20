Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222B72933CC
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 06:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391347AbgJTEOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 00:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgJTEOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 00:14:03 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F5BC0613CE;
        Mon, 19 Oct 2020 21:14:03 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id m65so215042qte.11;
        Mon, 19 Oct 2020 21:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lRPCIqgVp7JxtQIwMiyZjjVI3vzOaxsFkudHQAakCTE=;
        b=CfVX7lB8vevBGCqExwTh3APKc1v2ezK78tU6+t1yX1lK9mrdPWEcTaJoUOE7QoFs8p
         GJ7Ri9qfdszlYlCd3pUwR3z8S97ruE2/106lhkHvPIw+vCqbKWayS+atwy8X/gkS2SQ4
         /mOsaA24Kj7yBhJXUdi69luiVxNI7XhEu6UME=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lRPCIqgVp7JxtQIwMiyZjjVI3vzOaxsFkudHQAakCTE=;
        b=QB0HSyMCCknty/UzatZpfUH3NRAUu+rDEl9nFTyN2GUbz5yiVb7O+PvNqTbehk7zCX
         D7ONL3ZXjGbX6zBsF987l9LMbi9jK9oBgR0i3j/Oa+BJMK5sMCIDXd65oRJuorSOv21S
         gGpPQzfzfB6tiKt9NKUqgU2J0inaYJ3R7pb7a58buv/JnsMj6YC7Int+yHS0KOo8j9LD
         myS++XbrtWFXfZ36Ju9axUduOKgzHBofrvkDOOwkHMzmGB5toaMU4Iw2qUYTF/fLMbXP
         lyEy9EgX5ODkaLaaTV8IZ8mePQ8XDNCa9t2ns2ItLAzkb6uz4eAlopp3fZUaZZ6mmKbw
         O2Ng==
X-Gm-Message-State: AOAM530lI7Y9oQsmlt2WrNrQb8caH3lKCEJ7/mY4SausYBDFZAJJRMmB
        wVlTERxVljoY4uswjB3oym6gd84mACd4kIdan8mjo8q4TBoYQw==
X-Google-Smtp-Source: ABdhPJzfgWHW/dSSaO154QYtrEdfjSG/f3sH5C15wXCfARnDLbzc/MhtJX+jfb8/wRvEhAaYvobhKCrue9XWKekWqUY=
X-Received: by 2002:aed:3325:: with SMTP id u34mr826567qtd.263.1603167242677;
 Mon, 19 Oct 2020 21:14:02 -0700 (PDT)
MIME-Version: 1.0
References: <20201019085717.32413-1-dylan_hung@aspeedtech.com>
 <20201019085717.32413-2-dylan_hung@aspeedtech.com> <be7a978c48c9f1c6c29583350dee6168385c3039.camel@kernel.crashing.org>
In-Reply-To: <be7a978c48c9f1c6c29583350dee6168385c3039.camel@kernel.crashing.org>
From:   Joel Stanley <joel@jms.id.au>
Date:   Tue, 20 Oct 2020 04:13:49 +0000
Message-ID: <CACPK8XdECaKwdQgWFQ=sRBiCjDLXHtMKo=o-xQZPmMZyevOukQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] ftgmac100: Fix race issue on TX descriptor[0]
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc:     Dylan Hung <dylan_hung@aspeedtech.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Po-Yu Chuang <ratbert@faraday-tech.com>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>,
        BMC-SW <BMC-SW@aspeedtech.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Oct 2020 at 23:20, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
> On Mon, 2020-10-19 at 16:57 +0800, Dylan Hung wrote:
> > These rules must be followed when accessing the TX descriptor:
> >
> > 1. A TX descriptor is "cleanable" only when its value is non-zero
> > and the owner bit is set to "software"
>
> Can you elaborate ? What is the point of that change ? The owner bit
> should be sufficient, why do we need to check other fields ?

I would like Dylan to clarify too. The datasheet has a footnote below
the descriptor layout:

 - TXDES#0: Bits 27 ~ 14 are valid only when FTS = 1
 - TXDES#1: Bits 31 ~ 0 are valid only when FTS = 1

So the ownership bit (31) is not valid unless FTS is set. However,
this isn't what his patch does. It adds checks for EDOTR.

>
> > 2. A TX descriptor is "writable" only when its value is zero
> > regardless the edotr mask.
>
> Again, why is that ? Can you elaborate ? What race are you trying to
> address here ?
>
> Cheers,
> Ben.
>
> > Fixes: 52c0cae87465 ("ftgmac100: Remove tx descriptor accessors")
> > Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
> > Signed-off-by: Joel Stanley <joel@jms.id.au>
> > ---
> >  drivers/net/ethernet/faraday/ftgmac100.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/faraday/ftgmac100.c
> > b/drivers/net/ethernet/faraday/ftgmac100.c
> > index 00024dd41147..7cacbe4aecb7 100644
> > --- a/drivers/net/ethernet/faraday/ftgmac100.c
> > +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> > @@ -647,6 +647,9 @@ static bool ftgmac100_tx_complete_packet(struct
> > ftgmac100 *priv)
> >       if (ctl_stat & FTGMAC100_TXDES0_TXDMA_OWN)
> >               return false;
> >
> > +     if ((ctl_stat & ~(priv->txdes0_edotr_mask)) == 0)
> > +             return false;
> > +
> >       skb = priv->tx_skbs[pointer];
> >       netdev->stats.tx_packets++;
> >       netdev->stats.tx_bytes += skb->len;
> > @@ -756,6 +759,9 @@ static netdev_tx_t
> > ftgmac100_hard_start_xmit(struct sk_buff *skb,
> >       pointer = priv->tx_pointer;
> >       txdes = first = &priv->txdes[pointer];
> >
> > +     if (le32_to_cpu(txdes->txdes0) & ~priv->txdes0_edotr_mask)
> > +             goto drop;
> > +
> >       /* Setup it up with the packet head. Don't write the head to
> > the
> >        * ring just yet
> >        */
> > @@ -787,6 +793,10 @@ static netdev_tx_t
> > ftgmac100_hard_start_xmit(struct sk_buff *skb,
> >               /* Setup descriptor */
> >               priv->tx_skbs[pointer] = skb;
> >               txdes = &priv->txdes[pointer];
> > +
> > +             if (le32_to_cpu(txdes->txdes0) & ~priv-
> > >txdes0_edotr_mask)
> > +                     goto dma_err;
> > +
> >               ctl_stat = ftgmac100_base_tx_ctlstat(priv, pointer);
> >               ctl_stat |= FTGMAC100_TXDES0_TXDMA_OWN;
> >               ctl_stat |= FTGMAC100_TXDES0_TXBUF_SIZE(len);
>
