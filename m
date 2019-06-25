Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00BC854E73
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 14:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729813AbfFYMKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 08:10:54 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:51590 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726659AbfFYMKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 08:10:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=W62WhF17xmzfUuk1lOQSfwqt29Nh9k8JJUw3HEv31xE=; b=Vs5WDFzosl7UHr4YqGyzaMEHb
        2IffrAQPIXpvqPjY5gSh5XxB5yGZEZ+e9NySGWM4wnMO1W9Dhkm5CAqMpaQMvYZOutUqQiG2naGMy
        KhJSvJZPwMl32ZPbRcy7NcGXfiaXt66O1Rp1HlTId2cYWEzSVU2djphYPS1kx8JUl8uaPsXFjx0Mq
        3Z9yDU0PBqJVQL6QWnssO/bdi8ktsjtcl7gF74F1XvHaVHUx1Arh4pdEH9FE347ay175xrY2uoOza
        c9V6TwAMKG96YNouqg8fcMSMpXOwXX4Z3bnf2FTff4EAULM3sniNy1K3d0q8zKG7WbtzVWmWV2Ocx
        L2s9nI80A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59984)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hfkHV-0006J7-H9; Tue, 25 Jun 2019 13:10:37 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hfkHO-0007Dd-9r; Tue, 25 Jun 2019 13:10:30 +0100
Date:   Tue, 25 Jun 2019 13:10:30 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
Cc:     sean.wang@mediatek.com, f.fainelli@gmail.com, davem@davemloft.net,
        matthias.bgg@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        frank-w@public-files.de, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH RFC net-next 1/5] net: dsa: mt7530: Convert to PHYLINK API
Message-ID: <20190625121030.m5w7wi3rpezhfgyo@shell.armlinux.org.uk>
References: <20190624145251.4849-1-opensource@vdorst.com>
 <20190624145251.4849-2-opensource@vdorst.com>
 <20190624153950.hdsuhrvfd77heyor@shell.armlinux.org.uk>
 <20190625113158.Horde.pCaJOVUsgyhYLd5Diz5EZKI@www.vdorst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190625113158.Horde.pCaJOVUsgyhYLd5Diz5EZKI@www.vdorst.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 11:31:58AM +0000, René van Dorst wrote:
> > > +            if (state->link || mode == MLO_AN_FIXED)
> > > +                    mcr |= PMCR_FORCE_LNK;
> > 
> > This should be removed - state->link is not for use in mac_config.
> > Even in fixed mode, the link can be brought up/down by means of a
> > gpio, and this should be dealt with via the mac_link_* functions.
> 
> Maybe I understand it wrong, but is it the intention that in
> phylink_mac_config with modes MLO_AN_FIXED and MLO_AN_PHY the MAC is always
> forces into a certain speed/mode/interface. So it never auto-negotiate because
> phylink select the best configuration for you?

You are not the only one who has recently tried to make use of
state->link in mac_config(), so I'm now preparing a set of patches
to split the current mac_config() method into two separate methods:

        void (*mac_config_fixed)(struct net_device *ndev,
                                 phy_interface_t iface, int speed, int duplex,
                                 int pause);
        void (*mac_config_inband)(struct net_device *ndev,
                                  phy_interface_t iface, bool an_enabled,
                                  unsigned long *advertising, int pause);

so that it's not possible to use members that should not be accessed
in various modes.

> Also the PMCR_FORCE_LNK is only set in phylink_link_up() or can I do it here
> and do nothing phylink_link_up()?

When the link comes up/down, mac_link_up() and mac_link_down() will be
called appropriately.  In PHY mode, this is equivalent to phylink doing
this:

	if (link_changed) {
		if (phydev->link)
			mac_link_up();
		else
			mac_link_down();
	}

So the actions you would've done depending on phydev->link should be in
the mac_link_*() methods.

> Other question:
> Where does the MAC enable/disable TX and RX fits best? port_{enable,disable}?
> Or only mac_config() and port_disable?

mac_link_*().

> > > +            if (state->pause || phylink_test(state->advertising, Pause))
> > > +                    mcr |= PMCR_TX_FC_EN | PMCR_RX_FC_EN;
> > > +            if (state->pause & MLO_PAUSE_TX)
> > > +                    mcr |= PMCR_TX_FC_EN;
> > > +            if (state->pause & MLO_PAUSE_RX)
> > > +                    mcr |= PMCR_RX_FC_EN;
> > 
> > This is clearly wrong - if any bit in state->pause is set, then we
> > end up with both PMCR_TX_FC_EN | PMCR_RX_FC_EN set.  If we have Pause
> > Pause set in the advertising mask, then both are set.  This doesn't
> > seem right - are these bits setting the advertisement, or are they
> > telling the MAC to use flow control?
> 
> Last one, tell the MAC to use flow control.

So the first if() statement is incorrect, and should be removed
entirely.  You only want to enable the MAC to use flow control as a
result of the negotiation results.

> On the current driver both bits are set in a forced-link situation.
> 
> If we always forces the MAC mode I think I always set these bits and don't
> anything with the Pause modes? Is that the right way to do it?

So what happens if your link partner (e.g. switch) does not support
flow control?  What if your link partner floods such frames to all
ports?  You end up transmitting flow control frames, which could be
sent to all stations on the network... seems not a good idea.

Implementing stuff properly and not taking short-cuts is always a
good idea for inter-operability.

> > > +
> > > +static void mt7530_phylink_validate(struct dsa_switch *ds, int port,
> > > +                                unsigned long *supported,
> > > +                                struct phylink_link_state *state)
> > > +{
> > > +    __ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> > > +
> > > +    switch (port) {
> > > +    case 0: /* Internal phy */
> > > +    case 1:
> > > +    case 2:
> > > +    case 3:
> > > +    case 4:
> > > +            if (state->interface != PHY_INTERFACE_MODE_NA &&
> > > +                state->interface != PHY_INTERFACE_MODE_GMII)
> > > +                    goto unsupported;
> > > +            break;
> > > +    /* case 5: Port 5 not supported! */
> > > +    case 6: /* 1st cpu port */
> > > +            if (state->interface != PHY_INTERFACE_MODE_RGMII &&
> > > +                state->interface != PHY_INTERFACE_MODE_TRGMII)
> > 
> > PHY_INTERFACE_MODE_NA ?
> 
> You mean PHY_INTERFACE_MODE_NA is missing?

Yes.  Please see the updated documentation in the patch I sent this
morning "net: phylink: further documentation clarifications".

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
