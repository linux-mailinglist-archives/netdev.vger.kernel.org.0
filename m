Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F29721F6637
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 13:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbgFKLEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 07:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727844AbgFKLEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 07:04:47 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797BBC08C5C1;
        Thu, 11 Jun 2020 04:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CvFbGnYz+lQYgHeXrLshL7auugXlwdA1VE+LJ9ysFF8=; b=MJLDHgLH+pptuIbbqk2Easu/Jy
        uj1sbNqVWlBmqWIuzK+STMcsTHlTU/PyX7bnjedWM3uMy5ElZVxTWNORpEsJsxye1h+pVIi1KZOU0
        A7tg/LDeDYEsiPbz178HNugLNUeP86rDklgAdledlwdVMMm7lsL0BB1YEy+h9ebnLGyRA/f3FDxqF
        wHVtmB9N8gPqVDrKKgT7Esc3BCpvmY9rhDX9EvNv9p6KovOCzv4Q1BtShIcowaOsZT73gkoJNvpnQ
        GoUXUILWVGF+ni8zUmrcHyVqubeoc9s1vgkWgSfxrDAO/zZiZVffWLATRKBEmli2wH1DwXw6N8IpX
        rCjx/BuA==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1jjL0h-00006R-9p; Thu, 11 Jun 2020 12:04:39 +0100
Date:   Thu, 11 Jun 2020 12:04:39 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] net: dsa: qca8k: Switch to PHYLINK instead of PHYLIB
Message-ID: <20200611110439.GV311@earth.li>
References: <cover.1591816172.git.noodles@earth.li>
 <78519bc421a1cb7000a68d05e43c4208b26f37e5.1591816172.git.noodles@earth.li>
 <CA+h21hr-5TCeYAiPueKce1Jo+s76mzDUaTpaM6JtjQj-mJPO6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hr-5TCeYAiPueKce1Jo+s76mzDUaTpaM6JtjQj-mJPO6w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 11, 2020 at 11:58:43AM +0300, Vladimir Oltean wrote:
> Hi Jonathan,
> 
> On Wed, 10 Jun 2020 at 23:19, Jonathan McDowell <noodles@earth.li> wrote:
> >
> > Update the driver to use the new PHYLINK callbacks, removing the
> > legacy adjust_link callback.
> >
> > Signed-off-by: Jonathan McDowell <noodles@earth.li>
...
> >  static void
> > -qca8k_adjust_link(struct dsa_switch *ds, int port, struct phy_device *phy)
> > +qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
> > +                        const struct phylink_link_state *state)
> >  {
> >         struct qca8k_priv *priv = ds->priv;
> >         u32 reg;
> >
> > -       /* Force fixed-link setting for CPU port, skip others. */
> > -       if (!phy_is_pseudo_fixed_link(phy))
> > +       switch (port) {
> > +       case 0: /* 1st CPU port */
> > +               if (state->interface != PHY_INTERFACE_MODE_RGMII &&
> > +                   state->interface != PHY_INTERFACE_MODE_RGMII_ID &&
> > +                   state->interface != PHY_INTERFACE_MODE_SGMII)
> > +                       return;
> > +
> > +               reg = QCA8K_REG_PORT0_PAD_CTRL;
> > +               break;
> > +       case 1:
> > +       case 2:
> > +       case 3:
> > +       case 4:
> > +       case 5:
> > +               /* Internal PHY, nothing to do */
> > +               return;
> > +       case 6: /* 2nd CPU port / external PHY */
> > +               if (state->interface != PHY_INTERFACE_MODE_RGMII &&
> > +                   state->interface != PHY_INTERFACE_MODE_RGMII_ID &&
> > +                   state->interface != PHY_INTERFACE_MODE_SGMII &&
> > +                   state->interface != PHY_INTERFACE_MODE_1000BASEX)
> > +                       return;
> > +
> > +               reg = QCA8K_REG_PORT6_PAD_CTRL;
> > +               break;
> > +       default:
> > +               dev_err(ds->dev, "%s: unsupported port: %i\n", __func__, port);
> > +               return;
> > +       }
> > +
> > +       if (port != 6 && phylink_autoneg_inband(mode)) {
> > +               dev_err(ds->dev, "%s: in-band negotiation unsupported\n",
> > +                       __func__);
> > +               return;
> > +       }
> > +
> > +       switch (state->interface) {
> > +       case PHY_INTERFACE_MODE_RGMII:
> > +               /* RGMII mode means no delay so don't enable the delay */
> > +               qca8k_write(priv, reg, QCA8K_PORT_PAD_RGMII_EN);
> > +               break;
> > +       case PHY_INTERFACE_MODE_RGMII_ID:
> > +               /* RGMII_ID needs internal delay. This is enabled through
> > +                * PORT5_PAD_CTRL for all ports, rather than individual port
> > +                * registers
> > +                */
> > +               qca8k_write(priv, reg,
> > +                           QCA8K_PORT_PAD_RGMII_EN |
> > +                           QCA8K_PORT_PAD_RGMII_TX_DELAY(QCA8K_MAX_DELAY) |
> > +                           QCA8K_PORT_PAD_RGMII_RX_DELAY(QCA8K_MAX_DELAY));
> 
> 3 points here:
> - Should you prevalidate the device tree bindings that in case rgmii*
> mode are used, same delay settings are applied to all ports?
> - Can any RGMII port be connected to a PHY? If it can, won't the PHY
> enable delays too for RGMII_ID? Will the link work in that case?
> - Should you treat RGMII_TX_DELAY and RGMII_RX_DELAY independently for
> the case where there may be PCB traces?

The intent with this patch was to pull out the conversion to PHYLINK to
be stand-alone, with no functional changes, as request by Andrew. I
think there's room for some future clean-up here around the RGMII
options, but my main purpose in this patch set is to improve the SGMII
portion which my hardware uses that doesn't work with mainline.

> > +static void
> > +qca8k_phylink_validate(struct dsa_switch *ds, int port,
> > +                      unsigned long *supported,
> > +                      struct phylink_link_state *state)
> > +{
> > +       __ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> > +
> > +       switch (port) {
> > +       case 0: /* 1st CPU port */
> > +               if (state->interface != PHY_INTERFACE_MODE_NA &&
> > +                   state->interface != PHY_INTERFACE_MODE_RGMII &&
> > +                   state->interface != PHY_INTERFACE_MODE_RGMII_ID &&
> > +                   state->interface != PHY_INTERFACE_MODE_SGMII)
> > +                       goto unsupported;
> >                 break;
> > -       case 100:
> > -               reg = QCA8K_PORT_STATUS_SPEED_100;
> > +       case 1:
> > +       case 2:
> > +       case 3:
> > +       case 4:
> > +       case 5:
> > +               /* Internal PHY */
> > +               if (state->interface != PHY_INTERFACE_MODE_NA &&
> > +                   state->interface != PHY_INTERFACE_MODE_GMII)
> > +                       goto unsupported;
> >                 break;
> > -       case 1000:
> > -               reg = QCA8K_PORT_STATUS_SPEED_1000;
> > +       case 6: /* 2nd CPU port / external PHY */
> > +               if (state->interface != PHY_INTERFACE_MODE_NA &&
> > +                   state->interface != PHY_INTERFACE_MODE_RGMII &&
> > +                   state->interface != PHY_INTERFACE_MODE_RGMII_ID &&
> > +                   state->interface != PHY_INTERFACE_MODE_SGMII &&
> > +                   state->interface != PHY_INTERFACE_MODE_1000BASEX)
> > +                       goto unsupported;
> >                 break;
> >         default:
> > -               dev_dbg(priv->dev, "port%d link speed %dMbps not supported.\n",
> > -                       port, phy->speed);
> > +               dev_err(ds->dev, "%s: unsupported port: %i\n", __func__, port);
> 
> phylink has a better validation error message than this, I'd say this
> is unnecessary.

Ok.

> > +static void
> > +qca8k_phylink_mac_link_up(struct dsa_switch *ds, int port, unsigned int mode,
> > +                         phy_interface_t interface, struct phy_device *phydev,
> > +                         int speed, int duplex, bool tx_pause, bool rx_pause)
> > +{
> > +       struct qca8k_priv *priv = ds->priv;
> > +       u32 reg;
> > +
> > +       if (phylink_autoneg_inband(mode)) {
> > +               reg = QCA8K_PORT_STATUS_LINK_AUTO;
> > +       } else {
> > +               switch (speed) {
> > +               case SPEED_10:
> > +                       reg = QCA8K_PORT_STATUS_SPEED_10;
> > +                       break;
> > +               case SPEED_100:
> > +                       reg = QCA8K_PORT_STATUS_SPEED_100;
> > +                       break;
> > +               case SPEED_1000:
> > +                       reg = QCA8K_PORT_STATUS_SPEED_1000;
> > +                       break;
> > +               default:
> > +                       reg = QCA8K_PORT_STATUS_LINK_AUTO;
> > +                       break;
> > +               }
> > +
> > +               if (duplex == DUPLEX_FULL)
> > +                       reg |= QCA8K_PORT_STATUS_DUPLEX;
> > +
> > +               if (rx_pause | dsa_is_cpu_port(ds, port))
> 
> I think it is odd to do bitwise OR on booleans.

I agree; will fix in the next spin.

J.

-- 
I get the feeling that I've been cheated.
