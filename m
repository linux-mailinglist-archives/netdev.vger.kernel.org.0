Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40042A8789
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730412AbfIDN7V convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 4 Sep 2019 09:59:21 -0400
Received: from ispman.iskranet.ru ([62.213.33.10]:39233 "EHLO
        ispman.iskranet.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730245AbfIDN7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 09:59:21 -0400
Received: by ispman.iskranet.ru (Postfix, from userid 8)
        id 50268821826; Wed,  4 Sep 2019 20:54:08 +0700 (KRAT)
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on ispman.iskranet.ru
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=4.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.3.2
Received: from KB016249 (unknown [62.213.40.60])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ispman.iskranet.ru (Postfix) with ESMTPS id 1F8C2821824;
        Wed,  4 Sep 2019 20:54:08 +0700 (KRAT)
From:   Arseny Solokha <asolokha@kb.kras.ru>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH 1/2] gianfar: convert to phylink
References: <20190723151702.14430-1-asolokha@kb.kras.ru>
        <20190723151702.14430-2-asolokha@kb.kras.ru>
        <CA+h21hpacLmKzoeKrdE-frZSTsiYCi4rKCObJ4LfAmfrCJ6H9g@mail.gmail.com>
        <87lfwfio13.fsf@eldim>
        <CA+h21hruqt6nGG5ksDSwrGH_w5GtGF4fjAMCWJne7QJrjusERQ@mail.gmail.com>
Date:   Wed, 04 Sep 2019 20:54:08 +0700
Message-ID: <87d0ggp3pb.fsf@kb.kras.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Arseny.
>
> On Tue, 30 Jul 2019 at 17:40, Arseny Solokha <asolokha@kb.kras.ru> wrote:
>>
>> > Hi Arseny,
>> >
>> > Nice project!
>>
>> Vladimir, Russell, thanks for your review. I'm on vacation now, so won't fully
>> address your comments in a few weeks: while I can build the code, I won't have
>> access to hardware to test.
>>
>> So it seems this patch will turn into a series where we'll have some cleanup
>> patches preceding the actual conversion (and the latter will also contain a
>> documentation change in Documentation/devicetree/bindings/net/fsl-tsec-phy.txt
>> which I've overlooked in the first submission). I'll try to post trivial
>> cleanups independently while still on vacation.
>>
>
> Yes, ideally the cleanup would be separate from the conversion.

I've just sent a cleanup series. It won't make the conversion easier to digest,
though.


>> >> @@ -3387,23 +3384,6 @@ static irqreturn_t gfar_interrupt(int irq, void *grp_id)
>> >>         return IRQ_HANDLED;
>> >>  }
>> >>
>> >> -/* Called every time the controller might need to be made
>> >> - * aware of new link state.  The PHY code conveys this
>> >> - * information through variables in the phydev structure, and this
>> >> - * function converts those variables into the appropriate
>> >> - * register values, and can bring down the device if needed.
>> >> - */
>> >> -static void adjust_link(struct net_device *dev)
>> >> -{
>> >> -       struct gfar_private *priv = netdev_priv(dev);
>> >> -       struct phy_device *phydev = dev->phydev;
>> >> -
>> >> -       if (unlikely(phydev->link != priv->oldlink ||
>> >> -                    (phydev->link && (phydev->duplex != priv->oldduplex ||
>> >> -                                      phydev->speed != priv->oldspeed))))
>> >> -               gfar_update_link_state(priv);
>> >> -}
>> >
>> > Getting rid of the cruft from this function deserves its own patch.
>>
>> How am I supposed to remove it without breaking the PHYLIB-based driver? Or do
>> you mean making it call gfar_update_link_state() just before the conversion
>> which will then remove adjust_link() altogether?
>>
>
> I don't know, if you can't refactor without breaking anything then ok.

I can, of course, effectively revert 6ce29b0e2a04 ("gianfar: Avoid unnecessary
reg accesses in adjust_link()") and 2a4eebf0c485 ("gianfar: Restore link state
settings after MAC reset") just before the conversion, but I fail to see a point
in that. It would only make subsequent bisection harder.


>> >>         if (unlikely(test_bit(GFAR_RESETTING, &priv->state)))
>> >>                 return;
>> >>
>> >> -       if (phydev->link) {
>> >> -               u32 tempval1 = gfar_read(&regs->maccfg1);
>> >> -               u32 tempval = gfar_read(&regs->maccfg2);
>> >> -               u32 ecntrl = gfar_read(&regs->ecntrl);
>> >> -               u32 tx_flow_oldval = (tempval1 & MACCFG1_TX_FLOW);
>> >> +       if (unlikely(phylink_autoneg_inband(mode)))
>> >> +               return;
>> >>
>> >> -               if (phydev->duplex != priv->oldduplex) {
>> >> -                       if (!(phydev->duplex))
>> >> -                               tempval &= ~(MACCFG2_FULL_DUPLEX);
>> >> -                       else
>> >> -                               tempval |= MACCFG2_FULL_DUPLEX;
>> >> +       maccfg1 = gfar_read(&regs->maccfg1);
>> >> +       maccfg2 = gfar_read(&regs->maccfg2);
>> >> +       ecntrl = gfar_read(&regs->ecntrl);
>> >>
>> >> -                       priv->oldduplex = phydev->duplex;
>> >> -               }
>> >> +       new_maccfg2 = maccfg2 & ~(MACCFG2_FULL_DUPLEX | MACCFG2_IF);
>> >> +       new_ecntrl = ecntrl & ~ECNTRL_R100;
>> >>
>> >> -               if (phydev->speed != priv->oldspeed) {
>> >> -                       switch (phydev->speed) {
>> >> -                       case 1000:
>> >> -                               tempval =
>> >> -                                   ((tempval & ~(MACCFG2_IF)) | MACCFG2_GMII);
>> >> +       if (state->duplex)
>> >> +               new_maccfg2 |= MACCFG2_FULL_DUPLEX;
>> >>
>> >> -                               ecntrl &= ~(ECNTRL_R100);
>> >> -                               break;
>> >> -                       case 100:
>> >> -                       case 10:
>> >> -                               tempval =
>> >> -                                   ((tempval & ~(MACCFG2_IF)) | MACCFG2_MII);
>> >> -
>> >> -                               /* Reduced mode distinguishes
>> >> -                                * between 10 and 100
>> >> -                                */
>> >> -                               if (phydev->speed == SPEED_100)
>> >> -                                       ecntrl |= ECNTRL_R100;
>> >> -                               else
>> >> -                                       ecntrl &= ~(ECNTRL_R100);
>> >> -                               break;
>> >> -                       default:
>> >> -                               netif_warn(priv, link, priv->ndev,
>> >> -                                          "Ack!  Speed (%d) is not 10/100/1000!\n",
>> >> -                                          phydev->speed);
>> >
>> > Please 1. remove "Ack!" 2. treat SPEED_UNKNOWN here by setting the MAC
>> > into a low-power state (e.g. 10 Mbps - the power savings are real).
>> > Don't print that Speed -1 is not 10/100/1000, we know that.
>>
>> In my first conversion attempt I see "Ack!" when changing link speed on when
>> shutting it down, so switching to 10 Mbps doesn't seem right for me—hence early
>> return in this case. Maybe I'm doing something wrong here.
>>
>
> When mac_config calls with SPEED_UNKNOWN, the link is down, and you
> can put the MAC in the lowest energy state it can go to (10 Mbps, in
> this case). Or so I've been told. Maybe Russell can chime in. Anyway,
> you don't need to print anything, there's lots of prints from PHYLINK
> already.

OK. I believe this comment only applies to a PHYLINK-based driver and I should
omit this change from a cleanup series? Because in the PHYLIB-based driver this
code only gets executed when the link is up, and I can't immediately see how it
could be called with phydev->speed set to SPEED_UNKNOWN.


>> >> diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
>> >> index 3433b46b90c1..146b30d07789 100644
>> >> --- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
>> >> +++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
>> >> @@ -35,7 +35,7 @@
>> >>  #include <asm/types.h>
>> >>  #include <linux/ethtool.h>
>> >>  #include <linux/mii.h>
>> >> -#include <linux/phy.h>
>> >> +#include <linux/phylink.h>
>> >>  #include <linux/sort.h>
>> >>  #include <linux/if_vlan.h>
>> >>  #include <linux/of_platform.h>
>> >> @@ -207,12 +207,10 @@ static void gfar_get_regs(struct net_device *dev, struct ethtool_regs *regs,
>> >>  static unsigned int gfar_usecs2ticks(struct gfar_private *priv,
>> >>                                      unsigned int usecs)
>> >>  {
>> >> -       struct net_device *ndev = priv->ndev;
>> >> -       struct phy_device *phydev = ndev->phydev;
>> >
>> > Are you sure this still works? You missed a ndev->phydev check from
>> > gfar_gcoalesce, where this is called from. Technically you can still
>> > check ndev->phydev, it's just that PHYLINK doesn't guarantee you'll
>> > have one (e.g. fixed-link interfaces).
>>
>> It still works for RGMII PHYs, SGMII and 1000Base-X in my testing. I didn't
>> check it with fixed-link, though.
>>
>>
>> >> @@ -1519,6 +1472,24 @@ static int gfar_get_ts_info(struct net_device *dev,
>> >>         return 0;
>> >>  }
>> >>
>> >> +/* Set link ksettings (phy address, speed) for ethtools */
>> >
>> > ethtool, not ethtools. Also, I'm not quite sure what you mean by
>> > setting the "phy address" with ethtool.
>>
>> Well, I know where I've copied it from… Thanks for pointing it out.
>
> Regards,
> -Vladimir
