Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26FA97A5E1
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 12:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729234AbfG3KXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 06:23:41 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:56530 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbfG3KXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 06:23:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=AlL5bfS54l8dEB2liofEahQAG5AJ1H7Y0+6oUvQV8Yc=; b=GZ1QaBwtWkCaiHIFAxRM1bsht
        gxxwkuswr1AJ1lpaCGVHeLtKyTBZOwYE0rk+C0jSzrDP8k9251PBG5UBtMz3Dc5WleKRwb2gZpj3R
        Grd4kXgb6zxHhCvaoP+GonCRWThR1D40Orl+cDflgjBNoCLXMtjPGNZdpfTaWSZVeDbsM9L1OhJxw
        KddXAfn2cUKqw6M6vfINWpenpZR9DQg80WNco6K5XfxJLT/7jB6MAoRWGOS1/H0Z4NiCDgwWQKzi/
        HRkt6CHIswn2ZIIkS2yu5EOj5RhngT5AI7U7s1FzgjFGb/3iwe2FUAdEsYq8+XmB/GOsb0radB+GX
        rDooRjVbw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:50476)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hsPI5-0004c9-QB; Tue, 30 Jul 2019 11:23:33 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hsPI1-00028W-KX; Tue, 30 Jul 2019 11:23:29 +0100
Date:   Tue, 30 Jul 2019 11:23:29 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Arseny Solokha <asolokha@kb.kras.ru>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH 1/2] gianfar: convert to phylink
Message-ID: <20190730102329.GZ1330@shell.armlinux.org.uk>
References: <20190723151702.14430-1-asolokha@kb.kras.ru>
 <20190723151702.14430-2-asolokha@kb.kras.ru>
 <CA+h21hpacLmKzoeKrdE-frZSTsiYCi4rKCObJ4LfAmfrCJ6H9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hpacLmKzoeKrdE-frZSTsiYCi4rKCObJ4LfAmfrCJ6H9g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 02:39:58AM +0300, Vladimir Oltean wrote:
> To be honest I don't have a complete answer to that question. The
> literature recommends writing 0x01a0 to the MII_ADVERTISE (0x4)
> register of the MAC PCS for 1000Base-X, and 0x4001 for SGMII.

That looks entirely sane for both modes.

0x01a0 for 802.3z (1000BASE-X) is defined in 802.3 37.2.5.1.3 as:
	bit 5 - full duplex = 1
	bit 6 - half duplex = 0
	bit 7 - pause = 1
	bit 8 - asym_pause = 1

The description of the bits match the config word that is sent in the
link with the exception of bit 14, which is the acknowledgement bit.
Normally, in 802.3z, bit 14 will not be set in the transmitted config
word until we have received the config word from the other end of the
link.

For SGMII, 0x4001 is the acknowledgement code word, which is defined
in the SGMII spec as "tx_config_Reg[15:0] sent from the MAC to the
PHY" which requires:
	bit 0 - must be 1
	bit 1 .. 13, 15 - must be 0, reserved for future use
	bit 14 - must be 1 (auto-negotiation acknowledgement in 802.3z)

> The FMan driver which uses the TSEC MAC does exactly that:
> https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/tree/drivers/net/ethernet/freescale/fman/fman_dtsec.c#n58
> However I can't seem to be able to trace down the definition of bit 14
> from 0x4001 - it's reserved in all the manuals I see. I have a hunch
> that it selects the format of the Config_Reg base page between
> 1000Base-X and SGMII.

It could be that is what bit 14 is being used for, or it could just be
that they've taken the values from the appropriate specs, and the
hardware behaves the same way irrespective of whether it is in SGMII
or 1000BASE-X mode.

> > +static int gfar_mac_link_state(struct phylink_config *config,
> > +                              struct phylink_link_state *state)
> > +{
> > +       if (state->interface == PHY_INTERFACE_MODE_SGMII ||
> > +           state->interface == PHY_INTERFACE_MODE_1000BASEX) {
> 
> What if you reduce the indentation level by 1 here, by just exiting if
> the interface mode is not SGMII?

It's only called for in-band negotiation modes anyway, so the above
protection probably doesn't gain much.

> > +               struct gfar_private *priv =
> > +                       netdev_priv(to_net_dev(config->dev));
> > +               u16 tbi_cr;
> > +
> > +               if (!priv->tbi_phy)
> > +                       return -ENODEV;
> > +
> > +               tbi_cr = phy_read(priv->tbi_phy, MII_TBI_CR);
> > +
> > +               state->duplex = !!(tbi_cr & TBI_CR_FULL_DUPLEX);
> 
> Woah there. Aren't you supposed to first ensure state->an_complete is
> ok, based on TBI_MII_Register_Set_SR[AN_Done]? There's also a
> Link_Status bit in that register that you could retrieve.

Indeed.

> > +               if ((tbi_cr & TBI_CR_SPEED_1000_MASK) == TBI_CR_SPEED_1000_MASK)
> > +                       state->speed = SPEED_1000;
> > +       }
> 
> See the Speed_Bit table from TBI_MII_Register_Set_ANLPBPA_SGMII for
> the link partner (aka SGMII PHY) advertisement. You have to do a
> logical-and between that and your own. Also please make sure you
> really are in SGMII AN and not 1000 Base-X when interpreting registers
> 4 & 5 as one way or another.

From what you've said above, yes, this needs to do exactly that.

> > -static noinline void gfar_update_link_state(struct gfar_private *priv)
> > +static void gfar_mac_config(struct phylink_config *config, unsigned int mode,
> > +                           const struct phylink_link_state *state)
> >  {
> > +       struct gfar_private *priv = netdev_priv(to_net_dev(config->dev));
> >         struct gfar __iomem *regs = priv->gfargrp[0].regs;
> > -       struct net_device *ndev = priv->ndev;
> > -       struct phy_device *phydev = ndev->phydev;
> > -       struct gfar_priv_rx_q *rx_queue = NULL;
> > -       int i;
> > +       u32 maccfg1, new_maccfg1;
> > +       u32 maccfg2, new_maccfg2;
> > +       u32 ecntrl, new_ecntrl;
> > +       u32 tx_flow, new_tx_flow;
> 
> Don't introduce new_ variables. Is there any issue if you
> unconditionally write to the MAC registers?

We do this in every driver, as mac_config() can be called with only a
small number of changes in the settings, and it is important not to
upset the MAC for minor updates.

An example of this is when we are in SGMII mode with an attached PHY.
SGMII will communicate the speed and duplex, but not the results of
the pause negotiation.  We read that from the attached PHY and report
it back by calling mac_config() - but at that point, we don't want to
cause the established link to bounce.

So, mac_config() should be implemented to avoid upsetting an already
established link where possible (unless the configuration items that
affect the link have changed.)

> > +static void gfar_mac_an_restart(struct phylink_config *config)
> > +{
> > +       /* Not supported */
> > +}
> 
> What about running gfar_configure_serdes again?

The intention here is to cause the 802.3z link to renegotiate...

> 
> > +
> > +static void gfar_mac_link_down(struct phylink_config *config, unsigned int mode,
> > +                              phy_interface_t interface)
> > +{
> > +       /* Not supported */
> > +}
> > +
> 
> What about disabling RX_EN and TX_EN from MACCFG1?
> 
> > +static void gfar_mac_link_up(struct phylink_config *config, unsigned int mode,
> > +                            phy_interface_t interface, struct phy_device *phy)
> > +{
> > +       /* Not supported */
> >  }
> >
> 
> What about enabling RX_EN and TX_EN from MACCFG1?

Note that both of these functions must still allow the link to be
established if we are using in-band negotiation - but they are
expected to start/stop the transmission of packets.

> > @@ -149,8 +148,13 @@ extern const char gfar_driver_version[];
> >  #define GFAR_SUPPORTED_GBIT SUPPORTED_1000baseT_Full
> >
> >  /* TBI register addresses */
> > +#define MII_TBI_CR             0x00
> >  #define MII_TBICON             0x11
> >
> > +/* TBI_CR register bit fields */
> > +#define TBI_CR_FULL_DUPLEX     0x0100
> > +#define TBI_CR_SPEED_1000_MASK 0x0040
> > +
> 
> I think BIT() definitions are preferred, even if that means you have
> to convert existing code first.

If MII_TBI_CR is the BMCR of the PCS, how about using the definitions
that we already have in the kernel:

BMCR_SPEED1000 is TBI_CR_SPEED_1000_MASK
BMCR_FULLDPLX is TBI_CR_FULL_DUPLEX

?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
