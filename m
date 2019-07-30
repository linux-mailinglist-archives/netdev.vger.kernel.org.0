Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6BF37AB32
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 16:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731386AbfG3Okd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 30 Jul 2019 10:40:33 -0400
Received: from ispman.iskranet.ru ([62.213.33.10]:52337 "EHLO
        ispman.iskranet.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729167AbfG3Okc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 10:40:32 -0400
Received: by ispman.iskranet.ru (Postfix, from userid 8)
        id 88B9F8217FF; Tue, 30 Jul 2019 21:40:27 +0700 (KRAT)
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on ispman.iskranet.ru
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=4.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.3.2
Received: from eldim (unknown [178.185.68.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: asolokha@kb.kras.ru)
        by ispman.iskranet.ru (Postfix) with ESMTPSA id 19DD78217F9;
        Tue, 30 Jul 2019 21:40:25 +0700 (KRAT)
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
Date:   Tue, 30 Jul 2019 21:40:24 +0700
In-Reply-To: <CA+h21hpacLmKzoeKrdE-frZSTsiYCi4rKCObJ4LfAmfrCJ6H9g@mail.gmail.com>
        (Vladimir Oltean's message of "Tue, 30 Jul 2019 02:39:58 +0300")
Message-ID: <87lfwfio13.fsf@eldim>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Arseny,
>
> Nice project!

Vladimir, Russell, thanks for your review. I'm on vacation now, so won't fully
address your comments in a few weeks: while I can build the code, I won't have
access to hardware to test.

So it seems this patch will turn into a series where we'll have some cleanup
patches preceding the actual conversion (and the latter will also contain a
documentation change in Documentation/devicetree/bindings/net/fsl-tsec-phy.txt
which I've overlooked in the first submission). I'll try to post trivial
cleanups independently while still on vacation.


>> @@ -891,11 +912,21 @@ static int gfar_of_init(struct platform_device *ofdev, struct net_device **pdev)
>>
>>         err = of_property_read_string(np, "phy-connection-type", &ctype);
>>
>> -       /* We only care about rgmii-id.  The rest are autodetected */
>> -       if (err == 0 && !strcmp(ctype, "rgmii-id"))
>> -               priv->interface = PHY_INTERFACE_MODE_RGMII_ID;
>> -       else
>> +       /* We only care about rgmii-id and sgmii - the former
>> +        * is indistinguishable from rgmii in hardware, and phylink needs
>> +        * the latter to be set appropriately for correct phy configuration.
>> +        * The rest are autodetected
>> +        */
>> +       if (err == 0) {
>> +               if (!strcmp(ctype, "rgmii-id"))
>> +                       priv->interface = PHY_INTERFACE_MODE_RGMII_ID;
>> +               else if (!strcmp(ctype, "sgmii"))
>> +                       priv->interface = PHY_INTERFACE_MODE_SGMII;
>> +               else
>> +                       priv->interface = PHY_INTERFACE_MODE_MII;
>> +       } else {
>>                 priv->interface = PHY_INTERFACE_MODE_MII;
>> +       }
>>
>
> No. Don't do this. Just do:
>
>     err = of_get_phy_mode(np);
>     if (err < 0)
>         goto err_grp_init;
>
>     priv->interface = err;
>
>>         if (of_find_property(np, "fsl,magic-packet", NULL))
>>                 priv->device_flags |= FSL_GIANFAR_DEV_HAS_MAGIC_PACKET;
>> @@ -903,19 +934,21 @@ static int gfar_of_init(struct platform_device *ofdev, struct net_device **pdev)
>>         if (of_get_property(np, "fsl,wake-on-filer", NULL))
>>                 priv->device_flags |= FSL_GIANFAR_DEV_HAS_WAKE_ON_FILER;
>>
>> -       priv->phy_node = of_parse_phandle(np, "phy-handle", 0);
>> +       priv->device_node = np;
>> +       priv->speed = SPEED_UNKNOWN;
>>
>> -       /* In the case of a fixed PHY, the DT node associated
>> -        * to the PHY is the Ethernet MAC DT node.
>> -        */
>> -       if (!priv->phy_node && of_phy_is_fixed_link(np)) {
>> -               err = of_phy_register_fixed_link(np);
>> -               if (err)
>> -                       goto err_grp_init;
>> +       priv->phylink_config.dev = &priv->ndev->dev;
>> +       priv->phylink_config.type = PHYLINK_NETDEV;
>>
>> -               priv->phy_node = of_node_get(np);
>> +       phylink = phylink_create(&priv->phylink_config, of_fwnode_handle(np),
>> +                                priv->interface, &gfar_phylink_ops);
>
> You introduced a bug here.
> of_phy_connect used to take the PHY interface type (for good or bad)
> from gfar_get_interface() (which is reconstructing it from the MAC
> registers).
> You are now passing the PHY interface type to phylink_create from the
> "phy-connection-type" DT property.
> At the very least, you are breaking LS1021A which uses phy-mode
> instead of phy-connection-type (hence my comment above to use the
> generic OF helper).
> Actually I think you just uncovered a latent bug, in that the DT
> bindings for phy-mode didn't mean much at all to the driver - it would
> rely on what the bootloader had set up.
> Actually DT bindings for phy-connection-type were most likely simply
> bolt on on top of gianfar when they figured they couldn't just
> auto-detect the various species of required RGMII delays.
> But gfar_get_interface is a piece of history that was introduced in
> the same commit as the enum phy_interface_t itself: e8a2b6a42073
> ("[PATCH] PHY: Add support for configuring the PHY connection
> interface"). Its time has come.

<…>

>>         }
>>
>> +       priv->tbi_phy = NULL;
>> +       interface = gfar_get_interface(dev);
>
> Be consistent and just go for priv->interface. Nobody's changing it anyway.

So if I get you right, I'm supposed to drop gfar_get_interface() and rely on DT
bindings entirely?


>> @@ -3387,23 +3384,6 @@ static irqreturn_t gfar_interrupt(int irq, void *grp_id)
>>         return IRQ_HANDLED;
>>  }
>>
>> -/* Called every time the controller might need to be made
>> - * aware of new link state.  The PHY code conveys this
>> - * information through variables in the phydev structure, and this
>> - * function converts those variables into the appropriate
>> - * register values, and can bring down the device if needed.
>> - */
>> -static void adjust_link(struct net_device *dev)
>> -{
>> -       struct gfar_private *priv = netdev_priv(dev);
>> -       struct phy_device *phydev = dev->phydev;
>> -
>> -       if (unlikely(phydev->link != priv->oldlink ||
>> -                    (phydev->link && (phydev->duplex != priv->oldduplex ||
>> -                                      phydev->speed != priv->oldspeed))))
>> -               gfar_update_link_state(priv);
>> -}
>
> Getting rid of the cruft from this function deserves its own patch.

How am I supposed to remove it without breaking the PHYLIB-based driver? Or do
you mean making it call gfar_update_link_state() just before the conversion
which will then remove adjust_link() altogether?


>>
>>         if (unlikely(test_bit(GFAR_RESETTING, &priv->state)))
>>                 return;
>>
>> -       if (phydev->link) {
>> -               u32 tempval1 = gfar_read(&regs->maccfg1);
>> -               u32 tempval = gfar_read(&regs->maccfg2);
>> -               u32 ecntrl = gfar_read(&regs->ecntrl);
>> -               u32 tx_flow_oldval = (tempval1 & MACCFG1_TX_FLOW);
>> +       if (unlikely(phylink_autoneg_inband(mode)))
>> +               return;
>>
>> -               if (phydev->duplex != priv->oldduplex) {
>> -                       if (!(phydev->duplex))
>> -                               tempval &= ~(MACCFG2_FULL_DUPLEX);
>> -                       else
>> -                               tempval |= MACCFG2_FULL_DUPLEX;
>> +       maccfg1 = gfar_read(&regs->maccfg1);
>> +       maccfg2 = gfar_read(&regs->maccfg2);
>> +       ecntrl = gfar_read(&regs->ecntrl);
>>
>> -                       priv->oldduplex = phydev->duplex;
>> -               }
>> +       new_maccfg2 = maccfg2 & ~(MACCFG2_FULL_DUPLEX | MACCFG2_IF);
>> +       new_ecntrl = ecntrl & ~ECNTRL_R100;
>>
>> -               if (phydev->speed != priv->oldspeed) {
>> -                       switch (phydev->speed) {
>> -                       case 1000:
>> -                               tempval =
>> -                                   ((tempval & ~(MACCFG2_IF)) | MACCFG2_GMII);
>> +       if (state->duplex)
>> +               new_maccfg2 |= MACCFG2_FULL_DUPLEX;
>>
>> -                               ecntrl &= ~(ECNTRL_R100);
>> -                               break;
>> -                       case 100:
>> -                       case 10:
>> -                               tempval =
>> -                                   ((tempval & ~(MACCFG2_IF)) | MACCFG2_MII);
>> -
>> -                               /* Reduced mode distinguishes
>> -                                * between 10 and 100
>> -                                */
>> -                               if (phydev->speed == SPEED_100)
>> -                                       ecntrl |= ECNTRL_R100;
>> -                               else
>> -                                       ecntrl &= ~(ECNTRL_R100);
>> -                               break;
>> -                       default:
>> -                               netif_warn(priv, link, priv->ndev,
>> -                                          "Ack!  Speed (%d) is not 10/100/1000!\n",
>> -                                          phydev->speed);
>
> Please 1. remove "Ack!" 2. treat SPEED_UNKNOWN here by setting the MAC
> into a low-power state (e.g. 10 Mbps - the power savings are real).
> Don't print that Speed -1 is not 10/100/1000, we know that.

In my first conversion attempt I see "Ack!" when changing link speed on when
shutting it down, so switching to 10 Mbps doesn't seem right for me—hence early
return in this case. Maybe I'm doing something wrong here.


>> diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
>> index 3433b46b90c1..146b30d07789 100644
>> --- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
>> +++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
>> @@ -35,7 +35,7 @@
>>  #include <asm/types.h>
>>  #include <linux/ethtool.h>
>>  #include <linux/mii.h>
>> -#include <linux/phy.h>
>> +#include <linux/phylink.h>
>>  #include <linux/sort.h>
>>  #include <linux/if_vlan.h>
>>  #include <linux/of_platform.h>
>> @@ -207,12 +207,10 @@ static void gfar_get_regs(struct net_device *dev, struct ethtool_regs *regs,
>>  static unsigned int gfar_usecs2ticks(struct gfar_private *priv,
>>                                      unsigned int usecs)
>>  {
>> -       struct net_device *ndev = priv->ndev;
>> -       struct phy_device *phydev = ndev->phydev;
>
> Are you sure this still works? You missed a ndev->phydev check from
> gfar_gcoalesce, where this is called from. Technically you can still
> check ndev->phydev, it's just that PHYLINK doesn't guarantee you'll
> have one (e.g. fixed-link interfaces).

It still works for RGMII PHYs, SGMII and 1000Base-X in my testing. I didn't
check it with fixed-link, though.


>> @@ -1519,6 +1472,24 @@ static int gfar_get_ts_info(struct net_device *dev,
>>         return 0;
>>  }
>>
>> +/* Set link ksettings (phy address, speed) for ethtools */
>
> ethtool, not ethtools. Also, I'm not quite sure what you mean by
> setting the "phy address" with ethtool.

Well, I know where I've copied it from… Thanks for pointing it out.
