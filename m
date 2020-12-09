Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 085B02D4082
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 12:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730246AbgLILAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 06:00:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:55648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730180AbgLIK7z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 05:59:55 -0500
Date:   Wed, 9 Dec 2020 12:00:30 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607511553;
        bh=Cfek5dvOQ/hl/0T0y84qT50cIdNmN1oKOGwkx6JPzOk=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=axIbC16fUAMJvCLS5fI2dxdZjpnm/v2VNUkOLPhxK9V9+8/5d36uM4wu/b2Cd2SRX
         RyQm/ss/CFjY9uuOjR3vVZ3XeKAX+rIZogm7S87RemEt7z5RpYzij28Xl9rEsJ/fda
         mQBN37DJzliYVfMJ8tPKitjy+Qwm1Ps1n3cUEjwE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
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
Message-ID: <X9CuTjdgD3tDKWwo@kroah.com>
References: <20200620092047.GR1551@shell.armlinux.org.uk>
 <E1jmZgq-0001UG-1c@rmk-PC.armlinux.org.uk>
 <CAPv3WKdJKAEwCoj5z6NzP2xRFfT1HG+2o0wigt=Czi4bG7EQcg@mail.gmail.com>
 <CAPv3WKfEN22cKbM8=+qDANefQE67KQ1zwURrCqAsrbo1+gBCDA@mail.gmail.com>
 <20201102180326.GA2416734@kroah.com>
 <CAPv3WKf0fNOOovq9UzoxoAXwGLMe_MHdfCZ6U9sjgKxarUKA+Q@mail.gmail.com>
 <20201208133532.GH643756@sasha-vm>
 <CAPv3WKed9zhe0q2noGKiKdzd=jBNLtN6vRW0fnQddJhhiD=rkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPv3WKed9zhe0q2noGKiKdzd=jBNLtN6vRW0fnQddJhhiD=rkg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 08, 2020 at 04:02:50PM +0100, Marcin Wojtas wrote:
> Hi Sasha,
> 
> wt., 8 gru 2020 o 14:35 Sasha Levin <sashal@kernel.org> napisał(a):
> >
> > On Tue, Dec 08, 2020 at 01:03:38PM +0100, Marcin Wojtas wrote:
> > >Hi Greg,
> > >
> > >Apologies for delayed response:.
> > >
> > >
> > >pon., 2 lis 2020 o 19:02 Greg Kroah-Hartman
> > ><gregkh@linuxfoundation.org> napisał(a):
> > >>
> > >> On Mon, Nov 02, 2020 at 06:38:54PM +0100, Marcin Wojtas wrote:
> > >> > Hi Greg and Sasha,
> > >> >
> > >> > pt., 9 paź 2020 o 05:43 Marcin Wojtas <mw@semihalf.com> napisał(a):
> > >> > >
> > >> > > Hi,
> > >> > >
> > >> > > sob., 20 cze 2020 o 11:21 Russell King <rmk+kernel@armlinux.org.uk> napisał(a):
> > >> > > >
> > >> > > > Add a helper to convert the struct phylink_config pointer passed in
> > >> > > > from phylink to the drivers internal struct mvpp2_port.
> > >> > > >
> > >> > > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > >> > > > ---
> > >> > > >  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 29 +++++++++----------
> > >> > > >  1 file changed, 14 insertions(+), 15 deletions(-)
> > >> > > >
> > >> > > > diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > >> > > > index 7653277d03b7..313f5a60a605 100644
> > >> > > > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > >> > > > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > >> > > > @@ -4767,12 +4767,16 @@ static void mvpp2_port_copy_mac_addr(struct net_device *dev, struct mvpp2 *priv,
> > >> > > >         eth_hw_addr_random(dev);
> > >> > > >  }
> > >> > > >
> > >> > > > +static struct mvpp2_port *mvpp2_phylink_to_port(struct phylink_config *config)
> > >> > > > +{
> > >> > > > +       return container_of(config, struct mvpp2_port, phylink_config);
> > >> > > > +}
> > >> > > > +
> > >> > > >  static void mvpp2_phylink_validate(struct phylink_config *config,
> > >> > > >                                    unsigned long *supported,
> > >> > > >                                    struct phylink_link_state *state)
> > >> > > >  {
> > >> > > > -       struct mvpp2_port *port = container_of(config, struct mvpp2_port,
> > >> > > > -                                              phylink_config);
> > >> > > > +       struct mvpp2_port *port = mvpp2_phylink_to_port(config);
> > >> > > >         __ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> > >> > > >
> > >> > > >         /* Invalid combinations */
> > >> > > > @@ -4913,8 +4917,7 @@ static void mvpp2_gmac_pcs_get_state(struct mvpp2_port *port,
> > >> > > >  static void mvpp2_phylink_mac_pcs_get_state(struct phylink_config *config,
> > >> > > >                                             struct phylink_link_state *state)
> > >> > > >  {
> > >> > > > -       struct mvpp2_port *port = container_of(config, struct mvpp2_port,
> > >> > > > -                                              phylink_config);
> > >> > > > +       struct mvpp2_port *port = mvpp2_phylink_to_port(config);
> > >> > > >
> > >> > > >         if (port->priv->hw_version == MVPP22 && port->gop_id == 0) {
> > >> > > >                 u32 mode = readl(port->base + MVPP22_XLG_CTRL3_REG);
> > >> > > > @@ -4931,8 +4934,7 @@ static void mvpp2_phylink_mac_pcs_get_state(struct phylink_config *config,
> > >> > > >
> > >> > > >  static void mvpp2_mac_an_restart(struct phylink_config *config)
> > >> > > >  {
> > >> > > > -       struct mvpp2_port *port = container_of(config, struct mvpp2_port,
> > >> > > > -                                              phylink_config);
> > >> > > > +       struct mvpp2_port *port = mvpp2_phylink_to_port(config);
> > >> > > >         u32 val = readl(port->base + MVPP2_GMAC_AUTONEG_CONFIG);
> > >> > > >
> > >> > > >         writel(val | MVPP2_GMAC_IN_BAND_RESTART_AN,
> > >> > > > @@ -5105,13 +5107,12 @@ static void mvpp2_gmac_config(struct mvpp2_port *port, unsigned int mode,
> > >> > > >  static void mvpp2_mac_config(struct phylink_config *config, unsigned int mode,
> > >> > > >                              const struct phylink_link_state *state)
> > >> > > >  {
> > >> > > > -       struct net_device *dev = to_net_dev(config->dev);
> > >> > > > -       struct mvpp2_port *port = netdev_priv(dev);
> > >> > > > +       struct mvpp2_port *port = mvpp2_phylink_to_port(config);
> > >> > > >         bool change_interface = port->phy_interface != state->interface;
> > >> > > >
> > >> > > >         /* Check for invalid configuration */
> > >> > > >         if (mvpp2_is_xlg(state->interface) && port->gop_id != 0) {
> > >> > > > -               netdev_err(dev, "Invalid mode on %s\n", dev->name);
> > >> > > > +               netdev_err(port->dev, "Invalid mode on %s\n", port->dev->name);
> > >> > > >                 return;
> > >> > > >         }
> > >> > > >
> > >> > > > @@ -5151,8 +5152,7 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
> > >> > > >                               int speed, int duplex,
> > >> > > >                               bool tx_pause, bool rx_pause)
> > >> > > >  {
> > >> > > > -       struct net_device *dev = to_net_dev(config->dev);
> > >> > > > -       struct mvpp2_port *port = netdev_priv(dev);
> > >> > > > +       struct mvpp2_port *port = mvpp2_phylink_to_port(config);
> > >> > > >         u32 val;
> > >> > > >
> > >> > > >         if (mvpp2_is_xlg(interface)) {
> > >> > > > @@ -5199,14 +5199,13 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
> > >> > > >
> > >> > > >         mvpp2_egress_enable(port);
> > >> > > >         mvpp2_ingress_enable(port);
> > >> > > > -       netif_tx_wake_all_queues(dev);
> > >> > > > +       netif_tx_wake_all_queues(port->dev);
> > >> > > >  }
> > >> > > >
> > >> > > >  static void mvpp2_mac_link_down(struct phylink_config *config,
> > >> > > >                                 unsigned int mode, phy_interface_t interface)
> > >> > > >  {
> > >> > > > -       struct net_device *dev = to_net_dev(config->dev);
> > >> > > > -       struct mvpp2_port *port = netdev_priv(dev);
> > >> > > > +       struct mvpp2_port *port = mvpp2_phylink_to_port(config);
> > >> > > >         u32 val;
> > >> > > >
> > >> > > >         if (!phylink_autoneg_inband(mode)) {
> > >> > > > @@ -5223,7 +5222,7 @@ static void mvpp2_mac_link_down(struct phylink_config *config,
> > >> > > >                 }
> > >> > > >         }
> > >> > > >
> > >> > > > -       netif_tx_stop_all_queues(dev);
> > >> > > > +       netif_tx_stop_all_queues(port->dev);
> > >> > > >         mvpp2_egress_disable(port);
> > >> > > >         mvpp2_ingress_disable(port);
> > >> > > >
> > >> > > > --
> > >> > > > 2.20.1
> > >> > > >
> > >> > >
> > >> > > This patch fixes a regression that was introduced in v5.3:
> > >> > > Commit 44cc27e43fa3 ("net: phylink: Add struct phylink_config to PHYLINK API")
> > >> > >
> > >> > > Above results in a NULL pointer dereference when booting the
> > >> > > Armada7k8k/CN913x with ACPI between 5.3 and 5.8, which will be
> > >> > > problematic especially for the distros using LTSv5.4 and above (the
> > >> > > issue was reported on Fedora 32).
> > >> > >
> > >> > > Please help with backporting to the stable v5.3+ branches (it applies
> > >> > > smoothly on v5.4/v5.6/v5.8).
> > >> > >
> > >> >
> > >> > Any chances to backport this patch to relevant v5.3+ stable branches?
> > >>
> > >> What patch?  What git commit id needs to be backported?
> > >>
> > >
> > >The actual patch is:
> > >Commit 6c2b49eb9671  ("net: mvpp2: add mvpp2_phylink_to_port() helper").
> > >
> > >URL for reference:
> > >https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/net/ethernet/marvell/mvpp2?h=v5.10-rc7&id=6c2b49eb96716e91f202756bfbd3f5fea3b2b172
> > >
> > >Do you think it would be possible to get it merged to v5.3+ stable branches?
> >
> > Could you explain how that patch fixes anything? It reads like a
> > cleanup.
> >
> 
> Indeed, I am aware of it, but I'm not sure about the best way to fix
> it. In fact the mentioned patch is an unintentional fix. Commit
> 44cc27e43fa3 ("net: phylink: Add struct phylink_config to PHYLINK
> API") reworked an argument list of mvpp2_mac_config() routine in a way
> that resulted in a NULL pointer dereference when booting the
> Armada7k8k/CN913x with ACPI between 5.3 and 5.8. Part of Russell's
> patch resolves this issue.

What part fixes the issue?  I can't see it...

thanks,

greg k-h
