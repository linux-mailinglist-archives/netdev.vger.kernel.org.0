Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94A8A1F6CFC
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 19:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbgFKRrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 13:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725824AbgFKRrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 13:47:20 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3307C03E96F;
        Thu, 11 Jun 2020 10:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LYQ+N8x0aH8bz40x26RW7A4B2ALqLvrlMXrsdbkjenw=; b=ANXsmusz27gS1YColuHDf8V1Wd
        UL5B1uIB3xQ2AJ0LHCIxuJM62SxcKcAbej8Fi5PEUaPfzHm2MiJ+rsdBMkbTCD5TxC4T52LuNb9VA
        DAfiZbKDaxU1GFvOyqgY/YDgFwuKGGhC+gjJ0YWLJVQYRczWQZgH9eIa+0pyXDvU8tobWDPiXVAiW
        MDUhbCDT88Eid+1ZkoK22Xmb0SgcXMxsObUMPmPkevl5bh3d4ZdRDjTJ6BAU/KSCtwGUp6rCDJyvN
        sc+xDp79WYLSFCgzBHn+T9kKzE6tOYaaplKvQ0z0yOV9H+coc4+1FIAzSIwJdnNcmQdQRUPb+rloy
        8BxMoZEw==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1jjRIG-0003Xp-Ro; Thu, 11 Jun 2020 18:47:12 +0100
Date:   Thu, 11 Jun 2020 18:47:12 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: dsa: qca8k: Improve SGMII interface handling
Message-ID: <20200611174712.GW311@earth.li>
References: <cover.1591816172.git.noodles@earth.li>
 <2150f4c70c754aed179e46e166f3c305254cf85a.1591816172.git.noodles@earth.li>
 <9d7d09d5-393f-d5bd-5c57-78c914bdc850@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d7d09d5-393f-d5bd-5c57-78c914bdc850@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 10, 2020 at 08:31:11PM -0700, Florian Fainelli wrote:
> On 6/10/2020 12:15 PM, Jonathan McDowell wrote:
> > This patch improves the handling of the SGMII interface on the QCA8K
> > devices. Previously the driver did no configuration of the port, even if
> > it was selected. We now configure it up in the appropriate
> > PHY/MAC/Base-X mode depending on what phylink tells us we are connected
> > to and ensure it is enabled.
> > 
> > Tested with a device where the CPU connection is RGMII (i.e. the common
> > current use case) + one where the CPU connection is SGMII. I don't have
> > any devices where the SGMII interface is brought out to something other
> > than the CPU.
> > 
> > Signed-off-by: Jonathan McDowell <noodles@earth.li>
> > ---
> >  drivers/net/dsa/qca8k.c | 28 +++++++++++++++++++++++++++-
> >  drivers/net/dsa/qca8k.h | 13 +++++++++++++
> >  2 files changed, 40 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > index dcd9e8fa99b6..33e62598289e 100644
> > --- a/drivers/net/dsa/qca8k.c
> > +++ b/drivers/net/dsa/qca8k.c
> > @@ -681,7 +681,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
> >  			 const struct phylink_link_state *state)
> >  {
> >  	struct qca8k_priv *priv = ds->priv;
> > -	u32 reg;
> > +	u32 reg, val;
> >  
> >  	switch (port) {
> >  	case 0: /* 1st CPU port */
> > @@ -740,6 +740,32 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
> >  	case PHY_INTERFACE_MODE_1000BASEX:
> >  		/* Enable SGMII on the port */
> >  		qca8k_write(priv, reg, QCA8K_PORT_PAD_SGMII_EN);
> > +
> > +		/* Enable/disable SerDes auto-negotiation as necessary */
> > +		val = qca8k_read(priv, QCA8K_REG_PWS);
> > +		if (phylink_autoneg_inband(mode))
> > +			val &= ~QCA8K_PWS_SERDES_AEN_DIS;
> > +		else
> > +			val |= QCA8K_PWS_SERDES_AEN_DIS;
> > +		qca8k_write(priv, QCA8K_REG_PWS, val);
> > +
> > +		/* Configure the SGMII parameters */
> > +		val = qca8k_read(priv, QCA8K_REG_SGMII_CTRL);
> > +
> > +		val |= QCA8K_SGMII_EN_PLL | QCA8K_SGMII_EN_RX |
> > +			QCA8K_SGMII_EN_TX | QCA8K_SGMII_EN_SD;
> > +
> > +		val &= ~QCA8K_SGMII_MODE_CTRL_MASK;
> > +		if (dsa_is_cpu_port(ds, port)) {
> > +			/* CPU port, we're talking to the CPU MAC, be a PHY */
> > +			val |= QCA8K_SGMII_MODE_CTRL_PHY;
> 
> Since port 6 can be interfaced to an external PHY, do not you have to
> differentiate here whether this port is connected to an actual PHY,
> versus connected to a MAC? You should be able to use mode == MLO_AN_PHY
> to differentiate that case from the others.

I don't think MLO_AN_PHY is sufficient? If it's a fixed link we'll have
MLO_AN_FIXED and that could be talking to a PHY?

The logic I've gone for is assuming that a port hooked up to the CPU
should look like a PHY, and otherwise we're hooked up to a PHY so we're
acting as a MAC. That means we don't cope with the situation that we're
hooked up to something that isn't the CPU but wants us to look like a
PHY, but I don't think we have any current way to describe that.

> > +		} else if (state->interface == PHY_INTERFACE_MODE_SGMII) {
> > +			val |= QCA8K_SGMII_MODE_CTRL_MAC;
> > +		} else {
> > +			val |= QCA8K_SGMII_MODE_CTRL_BASEX;
> 
> Better make this explicit and check for PHY_INTERFACE_MODE_1000BASEX,
> even if those are the only two possible values covered by this part of
> the case statement.

Sure. I'll move the mask inside the if block too in that case, so we
don't change the setting if we get fed something invalid.

J.

-- 
Beware of programmers carrying screwdrivers.
