Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 291FE49B27B
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 12:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379919AbiAYLAE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 25 Jan 2022 06:00:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379908AbiAYK6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 05:58:35 -0500
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19CDC06173D;
        Tue, 25 Jan 2022 02:58:34 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id BB4A06000B;
        Tue, 25 Jan 2022 10:58:29 +0000 (UTC)
Date:   Tue, 25 Jan 2022 11:58:28 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Xue Liu <liuxuenetmail@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harry Morris <harrymorris12@gmail.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [wpan-next v2 4/9] net: ieee802154: at86rf230: Stop leaking
 skb's
Message-ID: <20220125115828.74738f60@xps13>
In-Reply-To: <CAB_54W6GLqY69D=kmjiGCaVHh1+vjKp8OtdS77Nu-bZRqELjNw@mail.gmail.com>
References: <20220120112115.448077-1-miquel.raynal@bootlin.com>
        <20220120112115.448077-5-miquel.raynal@bootlin.com>
        <CAB_54W721DFUw+qu6_UR58GFvjLxshmxiTE0DX-DNNY-XLskoQ@mail.gmail.com>
        <CAB_54W4qLJQhPYY1h-88VK7n554SdtY9CLF3U5HLR6QS4i4tNA@mail.gmail.com>
        <CAB_54W6GLqY69D=kmjiGCaVHh1+vjKp8OtdS77Nu-bZRqELjNw@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Sun, 23 Jan 2022 18:14:12 -0500:

> Hi,
> 
> On Sun, 23 Jan 2022 at 17:41, Alexander Aring <alex.aring@gmail.com> wrote:
> >
> > Hi,
> >
> > On Sun, 23 Jan 2022 at 15:43, Alexander Aring <alex.aring@gmail.com> wrote:  
> > >
> > > Hi,
> > >
> > > On Thu, 20 Jan 2022 at 06:21, Miquel Raynal <miquel.raynal@bootlin.com> wrote:  
> > > >
> > > > Upon error the ieee802154_xmit_complete() helper is not called. Only
> > > > ieee802154_wake_queue() is called manually. We then leak the skb
> > > > structure.
> > > >
> > > > Free the skb structure upon error before returning.
> > > >
> > > > There is no Fixes tag applying here, many changes have been made on this
> > > > area and the issue kind of always existed.
> > > >
> > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > ---
> > > >  drivers/net/ieee802154/at86rf230.c | 1 +
> > > >  1 file changed, 1 insertion(+)
> > > >
> > > > diff --git a/drivers/net/ieee802154/at86rf230.c b/drivers/net/ieee802154/at86rf230.c
> > > > index 7d67f41387f5..0746150f78cf 100644
> > > > --- a/drivers/net/ieee802154/at86rf230.c
> > > > +++ b/drivers/net/ieee802154/at86rf230.c
> > > > @@ -344,6 +344,7 @@ at86rf230_async_error_recover_complete(void *context)
> > > >                 kfree(ctx);
> > > >
> > > >         ieee802154_wake_queue(lp->hw);
> > > > +       dev_kfree_skb_any(lp->tx_skb);  
> > >
> > > as I said in other mails there is more broken, we need a:
> > >
> > > if (lp->is_tx) {
> > >         ieee802154_wake_queue(lp->hw);
> > >         dev_kfree_skb_any(lp->tx_skb);
> > >         lp->is_tx = 0;
> > > }
> > >
> > > in at86rf230_async_error_recover().
> > >  
> > s/at86rf230_async_error_recover/at86rf230_async_error_recover_complete/
> >
> > move the is_tx = 0 out of at86rf230_async_error_recover().  
> 
> Sorry, still seeing an issue here.
> 
> We cannot move is_tx = 0 out of at86rf230_async_error_recover()
> because switching to RX_AACK_ON races with a new interrupt and is_tx
> is not correct anymore. We need something new like "was_tx" to
> remember that it was a tx case for the error handling in
> at86rf230_async_error_recover_complete().

It wasn't easy to catch...

I've added a was_tx boolean which is set at the same time is_tx is
reset. Then, in the complete handler, if was_tx was set we reset it and
run the kfree/wake calls. I believe this should sort it out.

Thanks,
Miquèl
