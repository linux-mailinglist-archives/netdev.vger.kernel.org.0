Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1152210A2F
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 13:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730230AbgGALRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 07:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730140AbgGALRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 07:17:05 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36679C061755
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 04:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ZnYJLubiDmAWsAI/QbnaxFha1I79ZyQGuYdEvuvNLk4=; b=1MmzKoJhRNQkqcHVzLfGw/7ok
        8WlaBNObs2+7l+inFPYhIdl5HYpFwiQWlTszR/KdIyL7sMy6v/TnEL+n8EpnRSmQcr7OvbcGEsA0R
        3NKrppJmbdcckHqSMfaWHAYnETJXQ6UJuw+W998MKuR3mH7mSIdUKYmgoN0IEYXqxeeJXvXLU4vqC
        1rZca3q4uICZLu98zrAfD8wulXq4B4r6YfRZdJd6AWF03AYAyQdNOQN0ncIYqvSM42L4Q6yt0rJPc
        3q0PAGfrtNXbyMvslWdNg27KLODcyQ+EpkDkoudWUBrKo4gwkGNeMDx3WeujgLAMZofHgK8FfzbRp
        KHKtY1x8w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33942)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jqajT-0001dS-L3; Wed, 01 Jul 2020 12:16:51 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jqajK-0000jD-U6; Wed, 01 Jul 2020 12:16:42 +0100
Date:   Wed, 1 Jul 2020 12:16:42 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC net-next 12/13] net: phylink: add struct phylink_pcs
Message-ID: <20200701111642.GJ1551@shell.armlinux.org.uk>
References: <20200630142754.GC1551@shell.armlinux.org.uk>
 <E1jqHGO-0006QN-Hw@rmk-PC.armlinux.org.uk>
 <CA+h21hokR=966wRCWctN+gNALjZmr3tXU1D4uHhoFDwos7vNdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hokR=966wRCWctN+gNALjZmr3tXU1D4uHhoFDwos7vNdQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 01, 2020 at 01:47:27PM +0300, Vladimir Oltean wrote:
> Hi Russell,
> 
> On Tue, 30 Jun 2020 at 17:29, Russell King <rmk+kernel@armlinux.org.uk> wrote:
> >
> > Add a way for MAC PCS to have private data while keeping independence
> > from struct phylink_config, which is used for the MAC itself. We need
> > this independence as we will have stand-alone code for PCS that is
> > independent of the MAC.  Introduce struct phylink_pcs, which is
> > designed to be embedded in a driver private data structure.
> >
> > This structure does not include a mdio_device as there are PCS
> > implementations such as the Marvell DSA and network drivers where this
> > is not necessary.
> >
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > ---
> >  drivers/net/phy/phylink.c | 25 ++++++++++++++++------
> >  include/linux/phylink.h   | 45 ++++++++++++++++++++++++++-------------
> >  2 files changed, 48 insertions(+), 22 deletions(-)
> >
> > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> > index a31a00fb4974..fbc8591b474b 100644
> > --- a/drivers/net/phy/phylink.c
> > +++ b/drivers/net/phy/phylink.c
> > @@ -43,6 +43,7 @@ struct phylink {
> >         const struct phylink_mac_ops *mac_ops;
> >         const struct phylink_pcs_ops *pcs_ops;
> >         struct phylink_config *config;
> > +       struct phylink_pcs *pcs;
> >         struct device *dev;
> >         unsigned int old_link_state:1;
> >
> > @@ -427,7 +428,7 @@ static void phylink_mac_pcs_an_restart(struct phylink *pl)
> >             phy_interface_mode_is_8023z(pl->link_config.interface) &&
> >             phylink_autoneg_inband(pl->cur_link_an_mode)) {
> >                 if (pl->pcs_ops)
> > -                       pl->pcs_ops->pcs_an_restart(pl->config);
> > +                       pl->pcs_ops->pcs_an_restart(pl->pcs);
> >                 else
> >                         pl->mac_ops->mac_an_restart(pl->config);
> >         }
> > @@ -453,7 +454,7 @@ static void phylink_change_interface(struct phylink *pl, bool restart,
> >         phylink_mac_config(pl, state);
> >
> >         if (pl->pcs_ops) {
> > -               err = pl->pcs_ops->pcs_config(pl->config, pl->cur_link_an_mode,
> > +               err = pl->pcs_ops->pcs_config(pl->pcs, pl->cur_link_an_mode,
> >                                               state->interface,
> >                                               state->advertising,
> >                                               !!(pl->link_config.pause &
> > @@ -533,7 +534,7 @@ static void phylink_mac_pcs_get_state(struct phylink *pl,
> >         state->link = 1;
> >
> >         if (pl->pcs_ops)
> > -               pl->pcs_ops->pcs_get_state(pl->config, state);
> > +               pl->pcs_ops->pcs_get_state(pl->pcs, state);
> >         else
> >                 pl->mac_ops->mac_pcs_get_state(pl->config, state);
> >  }
> > @@ -604,7 +605,7 @@ static void phylink_link_up(struct phylink *pl,
> >         pl->cur_interface = link_state.interface;
> >
> >         if (pl->pcs_ops && pl->pcs_ops->pcs_link_up)
> > -               pl->pcs_ops->pcs_link_up(pl->config, pl->cur_link_an_mode,
> > +               pl->pcs_ops->pcs_link_up(pl->pcs, pl->cur_link_an_mode,
> >                                          pl->cur_interface,
> >                                          link_state.speed, link_state.duplex);
> >
> > @@ -863,11 +864,19 @@ struct phylink *phylink_create(struct phylink_config *config,
> >  }
> >  EXPORT_SYMBOL_GPL(phylink_create);
> >
> > -void phylink_add_pcs(struct phylink *pl, const struct phylink_pcs_ops *ops)
> > +/**
> > + * phylink_set_pcs() - set the current PCS for phylink to use
> > + * @pl: a pointer to a &struct phylink returned from phylink_create()
> > + * @pcs: a pointer to the &struct phylink_pcs
> > + *
> > + * Bind the MAC PCS to phylink.
> > + */
> > +void phylink_set_pcs(struct phylink *pl, struct phylink_pcs *pcs)
> >  {
> > -       pl->pcs_ops = ops;
> > +       pl->pcs = pcs;
> > +       pl->pcs_ops = pcs->ops;
> >  }
> > -EXPORT_SYMBOL_GPL(phylink_add_pcs);
> > +EXPORT_SYMBOL_GPL(phylink_set_pcs);
> >
> >  /**
> >   * phylink_destroy() - cleanup and destroy the phylink instance
> > @@ -1212,6 +1221,8 @@ void phylink_start(struct phylink *pl)
> >                 break;
> >         case MLO_AN_INBAND:
> >                 poll |= pl->config->pcs_poll;
> > +               if (pl->pcs)
> > +                       poll |= pl->pcs->poll;
> 
> Do we see a need for yet another way to request phylink to poll the
> PCS for link status?

Please consider what the model looks like if we have the PCS almost
self contained except for this property, which is in the MAC side.
What if some PCS need to be polled but others do not.  Why should the
MAC need to have that knowledge - is it not a property of the PCS
itself?

The reason we stuffed it into phylink_config is that at the time, that
was all that existed.  That doesn't mean that when we change the model
that we should be tied by that decision.

So, for example, does the Lynx PCS IP support any kind of notification
of link changes to its integrated system?  If it does not, then having
the Lynx PCS mark _itself_ as needing polling is entirely sane, rather
than burying that information in the MAC driver.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
