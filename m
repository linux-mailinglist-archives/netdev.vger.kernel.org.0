Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17CED295871
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 08:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411431AbgJVGfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 02:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394603AbgJVGfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 02:35:41 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5C2C0613CE;
        Wed, 21 Oct 2020 23:35:41 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id k9so526940qki.6;
        Wed, 21 Oct 2020 23:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ioQHIMjnRUOW/mlZwpsZuOwLkU2l1SyBhmTcsUYuavM=;
        b=i+GofPkSiwRWzygK0GUxNpAKSBtTKE0JwuPkLcLEvqtix3sYtFFAOGmJrpCPOL0jRm
         3jMH0KIv+Dl9MkacQkcWPwMVlU4JS9pPg537031vkqv3Mtox9+BMQ/bcPuZ6tXm85LNG
         18vsMuujeIv4zQ30iHZvuTKmJ06+1CV2lq1T4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ioQHIMjnRUOW/mlZwpsZuOwLkU2l1SyBhmTcsUYuavM=;
        b=SxFHalAxuou5rXF97UbR1k77ztRLCZF4ohmrA2AXstJngVSUIneYuco4ARGdHCv7bp
         W8cYkf5MuiJblHzRJNZaIcR7XPOyxf7ZVjZ5hH9HP/QIOn780htuXYxX1bqVz3HuRpWH
         EgKjfqDc3kV9InSIiOUDg+o+qJRAcEbSTZxs4rGELj2BaIydiWXW9YgskSRYbVRFhiRo
         8iouTa3k/LvBYkdVH9rJYBa3/oE6a0Yk876mk+tH5JV0BU6t8ZWw2UspITghTBJDdp1o
         7keTBqZ2KfICn3gb+7224tqEizlVKcuFeriBrM3ZtVVKLIKgT538Q05MNgZ8AZV7RG12
         ySVg==
X-Gm-Message-State: AOAM533IOv3XV3i6JHeuInMoKuTlTBD72xjf85hkyZKjlhpBkd6RVc1e
        Bt+VCaYxZXWRn6DXNomthCIQenQxc8Qtajrw6s9iyp5qrmA=
X-Google-Smtp-Source: ABdhPJzGkPSWwSIZHIfclDd5Dif2bkU3dQ4rD3qacZqhFSqEiQ1p41hNPys1ARTpaotQ2gJyDiFnhGedp+jCyr9V7yo=
X-Received: by 2002:a37:a81:: with SMTP id 123mr934295qkk.487.1603348540798;
 Wed, 21 Oct 2020 23:35:40 -0700 (PDT)
MIME-Version: 1.0
References: <20201020220639.130696-1-joel@jms.id.au> <CAK8P3a3gz4rMSkvZZ+TPaBx3B1yHXcUVFDdMFQMGUtEi4xXzyg@mail.gmail.com>
In-Reply-To: <CAK8P3a3gz4rMSkvZZ+TPaBx3B1yHXcUVFDdMFQMGUtEi4xXzyg@mail.gmail.com>
From:   Joel Stanley <joel@jms.id.au>
Date:   Thu, 22 Oct 2020 06:35:27 +0000
Message-ID: <CACPK8Xe2AGRGCsbcmAixeKOD2phO9pXdSKqs5Y4Cx7z4TeVbvw@mail.gmail.com>
Subject: Re: [PATCH] net: ftgmac100: Ensure tx descriptor updates are visible
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dylan Hung <dylan_hung@aspeedtech.com>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        Andrew Jeffery <andrew@aj.id.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Oct 2020 at 12:40, Arnd Bergmann <arnd@kernel.org> wrote:
>
> On Wed, Oct 21, 2020 at 12:39 PM Joel Stanley <joel@jms.id.au> wrote:
>
> >
> > diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
> > index 331d4bdd4a67..15cdfeb135b0 100644
> > --- a/drivers/net/ethernet/faraday/ftgmac100.c
> > +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> > @@ -653,6 +653,11 @@ static bool ftgmac100_tx_complete_packet(struct ftgmac100 *priv)
> >         ftgmac100_free_tx_packet(priv, pointer, skb, txdes, ctl_stat);
> >         txdes->txdes0 = cpu_to_le32(ctl_stat & priv->txdes0_edotr_mask);
> >
> > +       /* Ensure the descriptor config is visible before setting the tx
> > +        * pointer.
> > +        */
> > +       smp_wmb();
> > +
> >         priv->tx_clean_pointer = ftgmac100_next_tx_pointer(priv, pointer);
> >
> >         return true;
> > @@ -806,6 +811,11 @@ static netdev_tx_t ftgmac100_hard_start_xmit(struct sk_buff *skb,
> >         dma_wmb();
> >         first->txdes0 = cpu_to_le32(f_ctl_stat);
> >
> > +       /* Ensure the descriptor config is visible before setting the tx
> > +        * pointer.
> > +        */
> > +       smp_wmb();
> > +
>
> Shouldn't these be paired with smp_rmb() on the reader side?

Now that I've read memory-barriers.txt, yes, they should.

On my clarification of the description of the patch, I thought it was
about making sure that the txdes0 store (and   thus setting of the
ownership bit) happens before the reader side checks that bit.

But we're not, we're making sure all of the writes to the descriptor
happen before updating the pointer, so when the reader side loads the
ownership bit in txdes0, it sees that store to txdes0 at that pointer.

I'll add in the read side barrier(s) and send a v2.

Cheers,

Joel
