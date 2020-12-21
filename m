Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F11392DFDD8
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 17:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725902AbgLUQAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 11:00:40 -0500
Received: from conssluserg-06.nifty.com ([210.131.2.91]:59080 "EHLO
        conssluserg-06.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbgLUQAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 11:00:40 -0500
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178]) (authenticated)
        by conssluserg-06.nifty.com with ESMTP id 0BLFxkuQ006174;
        Tue, 22 Dec 2020 00:59:46 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-06.nifty.com 0BLFxkuQ006174
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1608566386;
        bh=v9iKmafeCvaighgEpCalcZ1NwA7eYUmABzv31kcyXUY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=uCOlCsQHRkqZOrP+gvNkTzvsW6x8jXDGaquN0Rum4iqEynVuwcE9lJSGFbxAY9sFA
         uXgL8x+NheOmnFk86tnGbUB3ekukQPz700q2a/pkQm9sDLQmRpHCv/+Mic5n5xCrrU
         pRAEjxjJj8mV1BjGcTRKY4PJKKx/6qPKm2BcGnwxr1+2sAh2eU2OL3iGYSxsHHpf2S
         byXk9AFJD6/qppuDzlcISR6PffOoNjxY72GaqlsiTHzolYizISX/T2XSIH3XwiC0OM
         6CF+x2TLWh2lfzt0A4bI2Ul+Ax5b+Tio+P5CzQrjhk8lkWSBaVwhWimqd70tnaYyXg
         sMAlMxVk6xQjA==
X-Nifty-SrcIP: [209.85.215.178]
Received: by mail-pg1-f178.google.com with SMTP id f17so6581848pge.6;
        Mon, 21 Dec 2020 07:59:46 -0800 (PST)
X-Gm-Message-State: AOAM5329D3FYDUVwdhrDkW/om+cJ6CDST2yZQsMnymYdWaOI6O0ZNJ78
        1pJg0b1EwXeX/Yw0Dwux78mCuUIwcIwFGL0ZR7s=
X-Google-Smtp-Source: ABdhPJzd43I2fCS5WlqxLQAMXfnDeU2v1Nd4N3AEKoXo4krGXsN8zQeEpZjkNePsHNmngarkHZ6IRkan7wM1uLlcvr0=
X-Received: by 2002:aa7:9501:0:b029:155:3b11:d5c4 with SMTP id
 b1-20020aa795010000b02901553b11d5c4mr15778878pfp.76.1608566385497; Mon, 21
 Dec 2020 07:59:45 -0800 (PST)
MIME-Version: 1.0
References: <20201221054323.247483-1-masahiroy@kernel.org> <20201221152645.GH3026679@lunn.ch>
In-Reply-To: <20201221152645.GH3026679@lunn.ch>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Tue, 22 Dec 2020 00:59:08 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQ9vhB6iYHeGV3xcyo8_iLqmGJeJUYOvbdHqN9Wn0mEJg@mail.gmail.com>
Message-ID: <CAK7LNAQ9vhB6iYHeGV3xcyo8_iLqmGJeJUYOvbdHqN9Wn0mEJg@mail.gmail.com>
Subject: Re: [PATCH] net: lantiq_etop: check the result of request_irq()
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 22, 2020 at 12:26 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Mon, Dec 21, 2020 at 02:43:23PM +0900, Masahiro Yamada wrote:
> > The declaration of request_irq() in <linux/interrupt.h> is marked as
> > __must_check.
> >
> > Without the return value check, I see the following warnings:
> >
> > drivers/net/ethernet/lantiq_etop.c: In function 'ltq_etop_hw_init':
> > drivers/net/ethernet/lantiq_etop.c:273:4: warning: ignoring return value of 'request_irq', declared with attribute warn_unused_result [-Wunused-result]
> >   273 |    request_irq(irq, ltq_etop_dma_irq, 0, "etop_tx", priv);
> >       |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > drivers/net/ethernet/lantiq_etop.c:281:4: warning: ignoring return value of 'request_irq', declared with attribute warn_unused_result [-Wunused-result]
> >   281 |    request_irq(irq, ltq_etop_dma_irq, 0, "etop_rx", priv);
> >       |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >
> > Reported-by: Miguel Ojeda <ojeda@kernel.org>
> > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> > ---
> >
> >  drivers/net/ethernet/lantiq_etop.c | 13 +++++++++++--
> >  1 file changed, 11 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
> > index 2d0c52f7106b..960494f9752b 100644
> > --- a/drivers/net/ethernet/lantiq_etop.c
> > +++ b/drivers/net/ethernet/lantiq_etop.c
> > @@ -264,13 +264,18 @@ ltq_etop_hw_init(struct net_device *dev)
> >       for (i = 0; i < MAX_DMA_CHAN; i++) {
> >               int irq = LTQ_DMA_CH0_INT + i;
> >               struct ltq_etop_chan *ch = &priv->ch[i];
> > +             int ret;
> >
> >               ch->idx = ch->dma.nr = i;
> >               ch->dma.dev = &priv->pdev->dev;
> >
> >               if (IS_TX(i)) {
> >                       ltq_dma_alloc_tx(&ch->dma);
> > -                     request_irq(irq, ltq_etop_dma_irq, 0, "etop_tx", priv);
> > +                     ret = request_irq(irq, ltq_etop_dma_irq, 0, "etop_tx", priv);
> > +                     if (ret) {
> > +                             netdev_err(dev, "failed to request irq\n");
> > +                             return ret;
>
> You need to cleanup what ltq_dma_alloc_tx() did.


Any failure from this function will roll back
in the following paths:

  ltq_etop_hw_exit()
     -> ltq_etop_free_channel()
          -> ltq_dma_free()


So, dma is freed anyway.

One problem I see is,
ltq_etop_hw_exit() frees all DMA channels,
some of which may not have been allocated yet.

If it is a bug, it is an existing bug.


>
> > +                     }
> >               } else if (IS_RX(i)) {
> >                       ltq_dma_alloc_rx(&ch->dma);
> >                       for (ch->dma.desc = 0; ch->dma.desc < LTQ_DESC_NUM;
> > @@ -278,7 +283,11 @@ ltq_etop_hw_init(struct net_device *dev)
> >                               if (ltq_etop_alloc_skb(ch))
> >                                       return -ENOMEM;


This -ENOMEM does not roll back anything here.

As stated above, dma_free_coherent() is called.
The problem is, ltq_etop_hw_exit() rolls back too much.

If your requirement is "this driver is completely wrong. Please rewrite it",
sorry, I cannot (unless I am paid to do so).

I am just following this driver's roll-back model.

Please do not expect more to a person who
volunteers to eliminate build warnings.

Of course, if somebody volunteers to rewrite this driver correctly,
that is appreciated.



> >                       ch->dma.desc = 0;
> > -                     request_irq(irq, ltq_etop_dma_irq, 0, "etop_rx", priv);
> > +                     ret = request_irq(irq, ltq_etop_dma_irq, 0, "etop_rx", priv);
> > +                     if (ret) {
> > +                             netdev_err(dev, "failed to request irq\n");
> > +                             return ret;
>
> And here you need to cleanup ltq_dma_alloc_rx().
>
>     Andrew



-- 
Best Regards
Masahiro Yamada
