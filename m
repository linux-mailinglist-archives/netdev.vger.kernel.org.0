Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C62C149B22D
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 11:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344574AbiAYKoM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 25 Jan 2022 05:44:12 -0500
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:37617 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353423AbiAYKkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 05:40:18 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 9C18DFF809;
        Tue, 25 Jan 2022 10:40:10 +0000 (UTC)
Date:   Tue, 25 Jan 2022 11:40:09 +0100
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
Subject: Re: [wpan-next v2 1/9] net: ieee802154: hwsim: Ensure proper
 channel selection at probe time
Message-ID: <20220125114009.49e0086a@xps13>
In-Reply-To: <CAB_54W5k-AUJhcS0Wf7==5qApYo3-ZAU7VyDWLgdpKusZO093A@mail.gmail.com>
References: <20220120112115.448077-1-miquel.raynal@bootlin.com>
        <20220120112115.448077-2-miquel.raynal@bootlin.com>
        <CAB_54W5k-AUJhcS0Wf7==5qApYo3-ZAU7VyDWLgdpKusZO093A@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Sun, 23 Jan 2022 15:34:14 -0500:

> Hi,
> 
> On Thu, 20 Jan 2022 at 06:21, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > Drivers are expected to set the PHY current_channel and current_page
> > according to their default state. The hwsim driver is advertising being
> > configured on channel 13 by default but that is not reflected in its own
> > internal pib structure. In order to ensure that this driver consider the
> > current channel as being 13 internally, we can call hwsim_hw_channel()
> > instead of creating an empty pib structure.
> >
> > We assume here that kvfree_rcu(NULL) is a valid call.
> >
> > Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  drivers/net/ieee802154/mac802154_hwsim.c | 10 +---------
> >  1 file changed, 1 insertion(+), 9 deletions(-)
> >
> > diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
> > index 8caa61ec718f..795f8eb5387b 100644
> > --- a/drivers/net/ieee802154/mac802154_hwsim.c
> > +++ b/drivers/net/ieee802154/mac802154_hwsim.c
> > @@ -732,7 +732,6 @@ static int hwsim_add_one(struct genl_info *info, struct device *dev,
> >  {
> >         struct ieee802154_hw *hw;
> >         struct hwsim_phy *phy;
> > -       struct hwsim_pib *pib;
> >         int idx;
> >         int err;
> >
> > @@ -780,13 +779,8 @@ static int hwsim_add_one(struct genl_info *info, struct device *dev,
> >
> >         /* hwsim phy channel 13 as default */
> >         hw->phy->current_channel = 13;
> > -       pib = kzalloc(sizeof(*pib), GFP_KERNEL);
> > -       if (!pib) {
> > -               err = -ENOMEM;
> > -               goto err_pib;
> > -       }
> > +       hwsim_hw_channel(hw, hw->phy->current_page, hw->phy->current_channel);  
> 
> Probably you saw it already; this will end in a
> "suspicious_RCU_usage", that's because of an additional lock check in
> hwsim_hw_channel() which checks if rtnl is held. However, in this
> situation it's not necessary to hold the rtnl lock because we know the
> phy is not being registered yet.

yes, indeed!

> 
> Either we change it to rcu_derefence() but then we would reduce the
> check if rtnl lock is being held or just simply initial the default
> pib->channel here to 13 which makes that whole patch a one line fix.

In general I like to drop more lines than I add, hence my first choice
but just setting pib->channel to 13 also makes sense here and avoids
oversimplifying the rtnl check in hwsim_hw_channel(), so let's go for
it.

Thanks,
Miquèl
