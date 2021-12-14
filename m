Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B43B474E8B
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 00:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238215AbhLNX1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 18:27:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbhLNX1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 18:27:35 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77406C061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 15:27:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=MCMaXDILQpBLzCVB0silALFLx4Syb5AeHJJr/kKgOYo=; b=YzRlBG5PtMlSADW52DCqfoelNp
        cyahOLZ/so+SzBQsP4NV1CVRug79RPPbBIPWoAysQjrrSL0sLF18393e44m5RgSEwwyUQYckAnm2J
        yEV7bQNf2uRqcgadKnxvfDvYC+LSF5kjn0X+gCIR93MDzcLa958vMP/KGX8diTlbOZ3auxiL1QyM+
        4JZOdciD64wJ7663nwOsZHa6thBO+v9N2CzseDbwkwHCnrpcnQXn38ScNHjJIu8TWu7nXkYEzOmGT
        E71KiDBTPOT2r5oge/ymUhd5QW6k6lpBrT5ANr/Z82oYwlDHH/2BXh5QJTqaEcfklWU/h6R0fme2D
        81d9iDtQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56284)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mxHCg-0005XP-Vq; Tue, 14 Dec 2021 23:27:27 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mxHCc-0003uY-Cw; Tue, 14 Dec 2021 23:27:22 +0000
Date:   Tue, 14 Dec 2021 23:27:22 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH net-next 2/7] net: phylink: add pcs_validate() method
Message-ID: <YbkoWsMPgw5RsQCo@shell.armlinux.org.uk>
References: <Ybiue1TPCwsdHmV4@shell.armlinux.org.uk>
 <E1mx96A-00GCdF-Ei@rmk-PC.armlinux.org.uk>
 <0d7361a9-ea74-ce75-b5e0-904596fbefd1@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d7361a9-ea74-ce75-b5e0-904596fbefd1@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 02:49:13PM -0500, Sean Anderson wrote:
> Hi Russell,
> 
> On 12/14/21 9:48 AM, Russell King (Oracle) wrote:
> > Add a hook for PCS to validate the link parameters. This avoids MAC
> > drivers having to have knowledge of their PCS in their validate()
> > method, thereby allowing several MAC drivers to be simplfied.
> > 
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > ---
> >   drivers/net/phy/phylink.c | 31 +++++++++++++++++++++++++++++++
> >   include/linux/phylink.h   | 20 ++++++++++++++++++++
> >   2 files changed, 51 insertions(+)
> > 
> > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> > index c7035d65e159..420201858564 100644
> > --- a/drivers/net/phy/phylink.c
> > +++ b/drivers/net/phy/phylink.c
> > @@ -424,13 +424,44 @@ static int phylink_validate_mac_and_pcs(struct phylink *pl,
> >   					struct phylink_link_state *state)
> >   {
> >   	struct phylink_pcs *pcs;
> > +	int ret;
> > 
> > +	/* Get the PCS for this interface mode */
> >   	if (pl->mac_ops->mac_select_pcs) {
> >   		pcs = pl->mac_ops->mac_select_pcs(pl->config, state->interface);
> >   		if (IS_ERR(pcs))
> >   			return PTR_ERR(pcs);
> > +	} else {
> > +		pcs = pl->pcs;
> > +	}
> > +
> > +	if (pcs) {
> > +		/* The PCS, if present, must be setup before phylink_create()
> > +		 * has been called. If the ops is not initialised, print an
> > +		 * error and backtrace rather than oopsing the kernel.
> > +		 */
> > +		if (!pcs->ops) {
> > +			phylink_err(pl, "interface %s: uninitialised PCS\n",
> > +				    phy_modes(state->interface));
> > +			dump_stack();
> > +			return -EINVAL;
> > +		}
> > +
> > +		/* Validate the link parameters with the PCS */
> > +		if (pcs->ops->pcs_validate) {
> > +			ret = pcs->ops->pcs_validate(pcs, supported, state);
> 
> I wonder if we can add a pcs->supported_interfaces. That would let me
> write something like

I have two arguments against that:

1) Given that .mac_select_pcs should not return a PCS that is not
   appropriate for the provided state->interface, I don't see what
   use having a supported_interfaces member in the PCS would give.
   All that phylink would end up doing is validating that the MAC
   was giving us a sane PCS.

2) In the case of a static PCS (in other words, one attached just
   after phylink_create_pcs()) the PCS is known at creation time,
   so limiting phylink_config.supported_interfaces according to the
   single attached interface seems sane, rather than phylink having
   to repeatedly recalculate the bitwise-and between both
   supported_interface masks.

> static int xilinx_pcs_validate(struct phylink_pcs *pcs,
> 			       unsigned long *supported,
> 			       struct phylink_link_state *state)
> {
> 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> 
> 	phylink_set_port_modes(mask);
> 	phylink_set(mask, Autoneg);
> 	phylink_get_linkmodes(mask, state->interface,
> 			      MAC_10FD | MAC_100FD | MAC_1000FD);
> 
> 	linkmode_and(supported, supported, mask);
> }

This would be buggy - doesn't the PCS allow pause frames through?

I already have a conversion for axienet in my tree, and it doesn't
need a pcs_validate() implementation. I'll provide it below.

> And of course, the above could become phylink_pcs_validate_generic with
> the addition of a pcs->pcs_capabilities member.
> 
> The only wrinkle is that we need to handle PHY_INTERFACE_MODE_NA,
> because of the pcs = pl->pcs assignment above. This would require doing
> the phylink_validate_any dance again.

Why do you think PHY_INTERFACE_MODE_NA needs handling? If this is not
set in phylink_config.supported_interfaces (which it should never be)
then none of the validation will be called with this.

The special PHY_INTERFACE_MODE_NA meaning "give us everything you have"
is something I want to get rid of, and is something that I am already
explicitly not supporting for pcs_validate(). It doesn't work with the
mac_select_pcs() model, since that can't return all PCS that may be
used.

> 	if (state->interface == PHY_INTERFACE_MODE_NA)
> 		return -EINVAL;
> 
> at the top of phylink_pcs_validate_generic (perhaps with a warning).
> That would catch any MACs who use a PCS which wants the MAC to have
> supported_interfaces.

... which could be too late.

> > +			if (ret < 0 || phylink_is_empty_linkmode(supported))
> > +				return -EINVAL;
> > +
> > +			/* Ensure the advertising mask is a subset of the
> > +			 * supported mask.
> > +			 */
> > +			linkmode_and(state->advertising, state->advertising,
> > +				     supported);
> > +		}
> >   	}
> > 
> > +	/* Then validate the link parameters with the MAC */
> >   	pl->mac_ops->validate(pl->config, supported, state);
> 
> Shouldn't the PCS stuff happen here? Later in the series, you do things
> like
> 
> 	if (phy_interface_mode_is_8023z(state->interface) &&
> 	    !phylink_test(state->advertising, Autoneg))
> 		return -EINVAL;
> 
> but there's nothing to stop a mac validate from coming along and saying
> "we don't support autonegotiation".

How is autonegotiation a property of the MAC when there is a PCS?
In what situation is autonegotiation terminated at the MAC when
there is a PCS present?

The only case I can think of is where the PCS is tightly tied to the
MAC, and in that case you end up with a choice whether or not to model
a PCS in software. This is the case with mvneta and mvpp2 - there is
no separation of the MAC and PCS in the hardware register design. There
is one register that controls pause/duplex advertisement and speeds
irrespective of the PHY interface, whether the interface mode to the
external world is 1000BASE-X, SGMII, QSGMII, RGMII etc. mvpp2 is
slightly different in that it re-uses the GMAC design from mvneta for
speeds <= 2.5G, and an entirely separate XLG implementation for 5G
and 10G. Here, we model these as two separate PCS that we choose
between depending on the interface.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
