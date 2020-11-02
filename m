Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61CBE2A3279
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 19:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgKBSCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 13:02:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:38776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726166AbgKBSCd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 13:02:33 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B6A9206DB;
        Mon,  2 Nov 2020 18:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604340151;
        bh=K48VmbWQfDWUABFcwaBvjkiKjs+7PPfUOKkSj2GtDws=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FBpQ1GnMEUGs2hN38wqHPRwgZ/uARpBTReb4PFjxhRJjq2nu5NVW4fYQDEdB/PRzI
         77f0K9uX/xaQnOnJB4Nl2ZPvrUKSLTV9eL6LRp77nCbQkB/O0dwk6FFC9PyqLR4xtV
         yqa5JprgldbkoQgDlaIZY9sH3f+de63zI9S+52qM=
Date:   Mon, 2 Nov 2020 19:03:26 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     sashal@kernel.org, Antoine Tenart <antoine.tenart@bootlin.com>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Gabor Samu <samu_gabor@yahoo.ca>,
        Jon Nettleton <jon@solid-run.com>,
        Andrew Elwell <andrew.elwell@gmail.com>
Subject: Re: [PATCH net-next 2/4] net: mvpp2: add mvpp2_phylink_to_port()
 helper
Message-ID: <20201102180326.GA2416734@kroah.com>
References: <20200620092047.GR1551@shell.armlinux.org.uk>
 <E1jmZgq-0001UG-1c@rmk-PC.armlinux.org.uk>
 <CAPv3WKdJKAEwCoj5z6NzP2xRFfT1HG+2o0wigt=Czi4bG7EQcg@mail.gmail.com>
 <CAPv3WKfEN22cKbM8=+qDANefQE67KQ1zwURrCqAsrbo1+gBCDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPv3WKfEN22cKbM8=+qDANefQE67KQ1zwURrCqAsrbo1+gBCDA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 02, 2020 at 06:38:54PM +0100, Marcin Wojtas wrote:
> Hi Greg and Sasha,
> 
> pt., 9 paź 2020 o 05:43 Marcin Wojtas <mw@semihalf.com> napisał(a):
> >
> > Hi,
> >
> > sob., 20 cze 2020 o 11:21 Russell King <rmk+kernel@armlinux.org.uk> napisał(a):
> > >
> > > Add a helper to convert the struct phylink_config pointer passed in
> > > from phylink to the drivers internal struct mvpp2_port.
> > >
> > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > > ---
> > >  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 29 +++++++++----------
> > >  1 file changed, 14 insertions(+), 15 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > index 7653277d03b7..313f5a60a605 100644
> > > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > @@ -4767,12 +4767,16 @@ static void mvpp2_port_copy_mac_addr(struct net_device *dev, struct mvpp2 *priv,
> > >         eth_hw_addr_random(dev);
> > >  }
> > >
> > > +static struct mvpp2_port *mvpp2_phylink_to_port(struct phylink_config *config)
> > > +{
> > > +       return container_of(config, struct mvpp2_port, phylink_config);
> > > +}
> > > +
> > >  static void mvpp2_phylink_validate(struct phylink_config *config,
> > >                                    unsigned long *supported,
> > >                                    struct phylink_link_state *state)
> > >  {
> > > -       struct mvpp2_port *port = container_of(config, struct mvpp2_port,
> > > -                                              phylink_config);
> > > +       struct mvpp2_port *port = mvpp2_phylink_to_port(config);
> > >         __ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> > >
> > >         /* Invalid combinations */
> > > @@ -4913,8 +4917,7 @@ static void mvpp2_gmac_pcs_get_state(struct mvpp2_port *port,
> > >  static void mvpp2_phylink_mac_pcs_get_state(struct phylink_config *config,
> > >                                             struct phylink_link_state *state)
> > >  {
> > > -       struct mvpp2_port *port = container_of(config, struct mvpp2_port,
> > > -                                              phylink_config);
> > > +       struct mvpp2_port *port = mvpp2_phylink_to_port(config);
> > >
> > >         if (port->priv->hw_version == MVPP22 && port->gop_id == 0) {
> > >                 u32 mode = readl(port->base + MVPP22_XLG_CTRL3_REG);
> > > @@ -4931,8 +4934,7 @@ static void mvpp2_phylink_mac_pcs_get_state(struct phylink_config *config,
> > >
> > >  static void mvpp2_mac_an_restart(struct phylink_config *config)
> > >  {
> > > -       struct mvpp2_port *port = container_of(config, struct mvpp2_port,
> > > -                                              phylink_config);
> > > +       struct mvpp2_port *port = mvpp2_phylink_to_port(config);
> > >         u32 val = readl(port->base + MVPP2_GMAC_AUTONEG_CONFIG);
> > >
> > >         writel(val | MVPP2_GMAC_IN_BAND_RESTART_AN,
> > > @@ -5105,13 +5107,12 @@ static void mvpp2_gmac_config(struct mvpp2_port *port, unsigned int mode,
> > >  static void mvpp2_mac_config(struct phylink_config *config, unsigned int mode,
> > >                              const struct phylink_link_state *state)
> > >  {
> > > -       struct net_device *dev = to_net_dev(config->dev);
> > > -       struct mvpp2_port *port = netdev_priv(dev);
> > > +       struct mvpp2_port *port = mvpp2_phylink_to_port(config);
> > >         bool change_interface = port->phy_interface != state->interface;
> > >
> > >         /* Check for invalid configuration */
> > >         if (mvpp2_is_xlg(state->interface) && port->gop_id != 0) {
> > > -               netdev_err(dev, "Invalid mode on %s\n", dev->name);
> > > +               netdev_err(port->dev, "Invalid mode on %s\n", port->dev->name);
> > >                 return;
> > >         }
> > >
> > > @@ -5151,8 +5152,7 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
> > >                               int speed, int duplex,
> > >                               bool tx_pause, bool rx_pause)
> > >  {
> > > -       struct net_device *dev = to_net_dev(config->dev);
> > > -       struct mvpp2_port *port = netdev_priv(dev);
> > > +       struct mvpp2_port *port = mvpp2_phylink_to_port(config);
> > >         u32 val;
> > >
> > >         if (mvpp2_is_xlg(interface)) {
> > > @@ -5199,14 +5199,13 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
> > >
> > >         mvpp2_egress_enable(port);
> > >         mvpp2_ingress_enable(port);
> > > -       netif_tx_wake_all_queues(dev);
> > > +       netif_tx_wake_all_queues(port->dev);
> > >  }
> > >
> > >  static void mvpp2_mac_link_down(struct phylink_config *config,
> > >                                 unsigned int mode, phy_interface_t interface)
> > >  {
> > > -       struct net_device *dev = to_net_dev(config->dev);
> > > -       struct mvpp2_port *port = netdev_priv(dev);
> > > +       struct mvpp2_port *port = mvpp2_phylink_to_port(config);
> > >         u32 val;
> > >
> > >         if (!phylink_autoneg_inband(mode)) {
> > > @@ -5223,7 +5222,7 @@ static void mvpp2_mac_link_down(struct phylink_config *config,
> > >                 }
> > >         }
> > >
> > > -       netif_tx_stop_all_queues(dev);
> > > +       netif_tx_stop_all_queues(port->dev);
> > >         mvpp2_egress_disable(port);
> > >         mvpp2_ingress_disable(port);
> > >
> > > --
> > > 2.20.1
> > >
> >
> > This patch fixes a regression that was introduced in v5.3:
> > Commit 44cc27e43fa3 ("net: phylink: Add struct phylink_config to PHYLINK API")
> >
> > Above results in a NULL pointer dereference when booting the
> > Armada7k8k/CN913x with ACPI between 5.3 and 5.8, which will be
> > problematic especially for the distros using LTSv5.4 and above (the
> > issue was reported on Fedora 32).
> >
> > Please help with backporting to the stable v5.3+ branches (it applies
> > smoothly on v5.4/v5.6/v5.8).
> >
> 
> Any chances to backport this patch to relevant v5.3+ stable branches?

What patch?  What git commit id needs to be backported?

confused,

greg k-h
