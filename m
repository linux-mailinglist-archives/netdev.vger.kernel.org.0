Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2B62DFF37
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 19:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgLUSFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 13:05:21 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35974 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725902AbgLUSFU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 13:05:20 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1krPXt-00DBHi-F6; Mon, 21 Dec 2020 19:04:33 +0100
Date:   Mon, 21 Dec 2020 19:04:33 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Masahiro Yamada <masahiroy@kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] net: lantiq_etop: check the result of request_irq()
Message-ID: <20201221180433.GE3107610@lunn.ch>
References: <20201221054323.247483-1-masahiroy@kernel.org>
 <20201221152645.GH3026679@lunn.ch>
 <CAK7LNAQ9vhB6iYHeGV3xcyo8_iLqmGJeJUYOvbdHqN9Wn0mEJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK7LNAQ9vhB6iYHeGV3xcyo8_iLqmGJeJUYOvbdHqN9Wn0mEJg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 22, 2020 at 12:59:08AM +0900, Masahiro Yamada wrote:
> On Tue, Dec 22, 2020 at 12:26 AM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Mon, Dec 21, 2020 at 02:43:23PM +0900, Masahiro Yamada wrote:
> > > The declaration of request_irq() in <linux/interrupt.h> is marked as
> > > __must_check.
> > >
> > > Without the return value check, I see the following warnings:
> > >
> > > drivers/net/ethernet/lantiq_etop.c: In function 'ltq_etop_hw_init':
> > > drivers/net/ethernet/lantiq_etop.c:273:4: warning: ignoring return value of 'request_irq', declared with attribute warn_unused_result [-Wunused-result]
> > >   273 |    request_irq(irq, ltq_etop_dma_irq, 0, "etop_tx", priv);
> > >       |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > drivers/net/ethernet/lantiq_etop.c:281:4: warning: ignoring return value of 'request_irq', declared with attribute warn_unused_result [-Wunused-result]
> > >   281 |    request_irq(irq, ltq_etop_dma_irq, 0, "etop_rx", priv);
> > >       |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > >
> > > Reported-by: Miguel Ojeda <ojeda@kernel.org>
> > > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> > > ---
> > >
> > >  drivers/net/ethernet/lantiq_etop.c | 13 +++++++++++--
> > >  1 file changed, 11 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
> > > index 2d0c52f7106b..960494f9752b 100644
> > > --- a/drivers/net/ethernet/lantiq_etop.c
> > > +++ b/drivers/net/ethernet/lantiq_etop.c
> > > @@ -264,13 +264,18 @@ ltq_etop_hw_init(struct net_device *dev)
> > >       for (i = 0; i < MAX_DMA_CHAN; i++) {
> > >               int irq = LTQ_DMA_CH0_INT + i;
> > >               struct ltq_etop_chan *ch = &priv->ch[i];
> > > +             int ret;
> > >
> > >               ch->idx = ch->dma.nr = i;
> > >               ch->dma.dev = &priv->pdev->dev;
> > >
> > >               if (IS_TX(i)) {
> > >                       ltq_dma_alloc_tx(&ch->dma);
> > > -                     request_irq(irq, ltq_etop_dma_irq, 0, "etop_tx", priv);
> > > +                     ret = request_irq(irq, ltq_etop_dma_irq, 0, "etop_tx", priv);
> > > +                     if (ret) {
> > > +                             netdev_err(dev, "failed to request irq\n");
> > > +                             return ret;
> >
> > You need to cleanup what ltq_dma_alloc_tx() did.
> 
> 
> Any failure from this function will roll back
> in the following paths:
> 
>   ltq_etop_hw_exit()
>      -> ltq_etop_free_channel()
>           -> ltq_dma_free()
> 
> 
> So, dma is freed anyway.
> 
> One problem I see is,
> ltq_etop_hw_exit() frees all DMA channels,
> some of which may not have been allocated yet.
> 
> If it is a bug, it is an existing bug.
> 
> 
> >
> > > +                     }
> > >               } else if (IS_RX(i)) {
> > >                       ltq_dma_alloc_rx(&ch->dma);
> > >                       for (ch->dma.desc = 0; ch->dma.desc < LTQ_DESC_NUM;
> > > @@ -278,7 +283,11 @@ ltq_etop_hw_init(struct net_device *dev)
> > >                               if (ltq_etop_alloc_skb(ch))
> > >                                       return -ENOMEM;
> 
> 
> This -ENOMEM does not roll back anything here.
> 
> As stated above, dma_free_coherent() is called.
> The problem is, ltq_etop_hw_exit() rolls back too much.
> 
> If your requirement is "this driver is completely wrong. Please rewrite it",
> sorry, I cannot (unless I am paid to do so).
> 
> I am just following this driver's roll-back model.
> 
> Please do not expect more to a person who
> volunteers to eliminate build warnings.
> 
> Of course, if somebody volunteers to rewrite this driver correctly,
> that is appreciated.

Hi Hauke

Do you still have this hardware? Do you have time to take a look at
the cleanup code?

Thanks
	Andrew
