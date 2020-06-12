Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEAB1F7788
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 13:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgFLLyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 07:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbgFLLyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 07:54:11 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B593AC03E96F;
        Fri, 12 Jun 2020 04:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dpIpV/PSRomXKbHiMD9pRyZrzovTUR07LS3WQXsOVkU=; b=k/e36YCUqNdK4gRAE/dVmdBcxP
        CLbvNUVkvYG+ubjNhtLmAPx2qRrPq6FCmUtqCVS4mIXkN5HvLeMLV4wR6W3d7Ht1Vn9PWe1VDN50S
        b+jaEvDD/+HJmjlRiNmISNa7LTmZYko/QZr85pPurLPJyf3kCXOqk7HZEl6+ilfUROf6F8LbKvE0m
        zzGH984ZpiffxDzpqszLVmlgnSNBs032U53cNVODYg6cVYiyVMhfwa0FnmEXL3YvkpuDpAbSUWhhm
        xk+4WlZ8DcpQVlkw4ROFl3XEwVh6xluCBdEZ1RSbsg3iwcKIk69HNgN6/P9b7U9pUvjMdIXC45rgI
        v0bIUkFQ==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1jjiFw-0007It-BX; Fri, 12 Jun 2020 12:53:56 +0100
Date:   Fri, 12 Jun 2020 12:53:56 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net: dsa: qca8k: Switch to PHYLINK instead of PHYLIB
Message-ID: <20200612115356.GX311@earth.li>
References: <cover.1591816172.git.noodles@earth.li>
 <78519bc421a1cb7000a68d05e43c4208b26f37e5.1591816172.git.noodles@earth.li>
 <20200611085523.GV1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200611085523.GV1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 11, 2020 at 09:55:23AM +0100, Russell King - ARM Linux admin wrote:
> On Wed, Jun 10, 2020 at 08:14:03PM +0100, Jonathan McDowell wrote:
> > Update the driver to use the new PHYLINK callbacks, removing the
> > legacy adjust_link callback.
> 
> Looks good, there's a couple of issues / questions
> 
> >  static void
> > +qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
> > +			 const struct phylink_link_state *state)
> >  {
> >  	struct qca8k_priv *priv = ds->priv;
> >  	u32 reg;
> >  
> > +	switch (port) {
> ...
> > +	case 6: /* 2nd CPU port / external PHY */
> > +		if (state->interface != PHY_INTERFACE_MODE_RGMII &&
> > +		    state->interface != PHY_INTERFACE_MODE_RGMII_ID &&
> > +		    state->interface != PHY_INTERFACE_MODE_SGMII &&
> > +		    state->interface != PHY_INTERFACE_MODE_1000BASEX)
> > +			return;
> > +
> > +		reg = QCA8K_REG_PORT6_PAD_CTRL;
> > +		break;
> ...
> > +	}
> > +
> > +	if (port != 6 && phylink_autoneg_inband(mode)) {
> > +		dev_err(ds->dev, "%s: in-band negotiation unsupported\n",
> > +			__func__);
> > +		return;
> > +	}
> > +
> > +	switch (state->interface) {
> ...
> > +	case PHY_INTERFACE_MODE_SGMII:
> > +	case PHY_INTERFACE_MODE_1000BASEX:
> > +		/* Enable SGMII on the port */
> > +		qca8k_write(priv, reg, QCA8K_PORT_PAD_SGMII_EN);
> > +		break;
> 
> Is inband mode configurable?  What if the link partner does/doesn't
> send the configuration word?  How is the link state communicated to
> the MAC?

I moved those over to the second patch on the request of Andrew Lunn,
who wanted the phylink change to be separate from the addition of the
SGMII changes. This first patch should result in no change of behaviour,
just the move to phylink.

> > +static int
> > +qca8k_phylink_mac_link_state(struct dsa_switch *ds, int port,
> > +			     struct phylink_link_state *state)
> > +{
> > +	struct qca8k_priv *priv = ds->priv;
> > +	u32 reg;
> >  
> > +	reg = qca8k_read(priv, QCA8K_REG_PORT_STATUS(port));
> > +
> > +	state->link = !!(reg & QCA8K_PORT_STATUS_LINK_UP);
> > +	state->an_complete = state->link;
> > +	state->an_enabled = !!(reg & QCA8K_PORT_STATUS_LINK_AUTO);
> > +	state->duplex = (reg & QCA8K_PORT_STATUS_DUPLEX) ? DUPLEX_FULL :
> > +							   DUPLEX_HALF;
> > +
> > +	switch (reg & QCA8K_PORT_STATUS_SPEED) {
> > +	case QCA8K_PORT_STATUS_SPEED_10:
> > +		state->speed = SPEED_10;
> > +		break;
> > +	case QCA8K_PORT_STATUS_SPEED_100:
> > +		state->speed = SPEED_100;
> > +		break;
> > +	case QCA8K_PORT_STATUS_SPEED_1000:
> > +		state->speed = SPEED_1000;
> > +		break;
> > +	default:
> > +		state->speed = SPEED_UNKNOWN;
> 
> Maybe also force the link down in this case, since the state is invalid?
> 
> Do you have access to the link partner's configuration word?  If you do,
> you should use that to fill in state->lp_advertising.

It doesn't seem to be available from my reading of the data sheet.

> > +		break;
> > +	}
> > +
> > +	state->pause = MLO_PAUSE_NONE;
> > +	if (reg & QCA8K_PORT_STATUS_RXFLOW)
> > +		state->pause |= MLO_PAUSE_RX;
> > +	if (reg & QCA8K_PORT_STATUS_TXFLOW)
> > +		state->pause |= MLO_PAUSE_TX;
> > +
> > +	return 1;
> > +}
> > +
> > +static void
> > +qca8k_phylink_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
> > +			    phy_interface_t interface)
> > +{
> > +	struct qca8k_priv *priv = ds->priv;
> >  
> >  	qca8k_port_set_status(priv, port, 0);
> 
> If operating in in-band mode, forcing the link down unconditionally
> will prevent the link coming up if the SGMII/1000base-X block
> automatically updates the MAC, and if this takes precedence.
> 
> When using in-band mode, you need to call dsa_port_phylink_mac_change()
> to keep phylink updated with the link status.
> 
> Alternatively, phylink supports polling mode, but due to the layered
> way DSA is written, DSA drivers don't have access to that as that is
> in the DSA upper levels in net/dsa/slave.c (dsa_slave_phy_setup(),
> it would be dp->pl_config.pcs_poll).

My reading of Vladimir's mail is I can set pcs_poll to get that
functionality, and from the data sheet the link detection is keyed off a
separate bit than the mac link down piece so I think I'm ok there.

> Apart from those points, I think it looks fine, thanks.

Thanks for the review. I'll get a new version out soon.

J.

-- 
If a program is useless, it must be documented.
