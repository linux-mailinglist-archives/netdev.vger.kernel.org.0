Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC7A474F50
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 01:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbhLOAc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 19:32:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238519AbhLOAc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 19:32:28 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1E6C06173E
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 16:32:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6uKCFwqMM3+5ANIEZIyfpXkp0IKUHFuza1ana6I4eMA=; b=rxLJHj4t8oG74xrMP+nH00ATA3
        dSBL7mmkmloENa8MVRNLta/mUU3nnDEFOJ1IN0ueCnRtdH3UbA9cPjqMq75UgdapiMcaZB+nwZED+
        nwGI0OPE97m56PcLnwUEfwoTDIUb1NLWqltCbUX42tHpfcjPghAIR1fxg74WoJLx7Qe/HqO5e3pMF
        tzZSnsIVgbu/ess2HsqJmYOfkTeBz+4lZeOMS/3qGq90b0voMSTIXnbBZ3uI1W7tKXPjo/L3XGZap
        OYUuAnLNd1OtpjTtWIvsn72mQ/eEl9iB3vU7UpljNW1wABXFX95CDEKUQ/grerM7WflAwTnB24YT+
        OwVtrzOg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56290)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mxIDW-0005ax-0x; Wed, 15 Dec 2021 00:32:22 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mxIDS-0003yC-8h; Wed, 15 Dec 2021 00:32:18 +0000
Date:   Wed, 15 Dec 2021 00:32:18 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH net-next 2/7] net: phylink: add pcs_validate() method
Message-ID: <Ybk3kuKyynGQYjzh@shell.armlinux.org.uk>
References: <Ybiue1TPCwsdHmV4@shell.armlinux.org.uk>
 <E1mx96A-00GCdF-Ei@rmk-PC.armlinux.org.uk>
 <0d7361a9-ea74-ce75-b5e0-904596fbefd1@seco.com>
 <YbkoWsMPgw5RsQCo@shell.armlinux.org.uk>
 <3a3716a1-54be-e218-5c1e-a794b208aa53@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a3716a1-54be-e218-5c1e-a794b208aa53@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 06:54:16PM -0500, Sean Anderson wrote:
> On 12/14/21 6:27 PM, Russell King (Oracle) wrote:
> > On Tue, Dec 14, 2021 at 02:49:13PM -0500, Sean Anderson wrote:
> > > Hi Russell,
> > > 
> > > On 12/14/21 9:48 AM, Russell King (Oracle) wrote:
> > > > Add a hook for PCS to validate the link parameters. This avoids MAC
> > > > drivers having to have knowledge of their PCS in their validate()
> > > > method, thereby allowing several MAC drivers to be simplfied.
> > > >
> > > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > > > ---
> > > >   drivers/net/phy/phylink.c | 31 +++++++++++++++++++++++++++++++
> > > >   include/linux/phylink.h   | 20 ++++++++++++++++++++
> > > >   2 files changed, 51 insertions(+)
> > > >
> > > > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> > > > index c7035d65e159..420201858564 100644
> > > > --- a/drivers/net/phy/phylink.c
> > > > +++ b/drivers/net/phy/phylink.c
> > > > @@ -424,13 +424,44 @@ static int phylink_validate_mac_and_pcs(struct phylink *pl,
> > > >   					struct phylink_link_state *state)
> > > >   {
> > > >   	struct phylink_pcs *pcs;
> > > > +	int ret;
> > > >
> > > > +	/* Get the PCS for this interface mode */
> > > >   	if (pl->mac_ops->mac_select_pcs) {
> > > >   		pcs = pl->mac_ops->mac_select_pcs(pl->config, state->interface);
> > > >   		if (IS_ERR(pcs))
> > > >   			return PTR_ERR(pcs);
> > > > +	} else {
> > > > +		pcs = pl->pcs;
> > > > +	}
> > > > +
> > > > +	if (pcs) {
> > > > +		/* The PCS, if present, must be setup before phylink_create()
> > > > +		 * has been called. If the ops is not initialised, print an
> > > > +		 * error and backtrace rather than oopsing the kernel.
> > > > +		 */
> > > > +		if (!pcs->ops) {
> > > > +			phylink_err(pl, "interface %s: uninitialised PCS\n",
> > > > +				    phy_modes(state->interface));
> > > > +			dump_stack();
> > > > +			return -EINVAL;
> > > > +		}
> > > > +
> > > > +		/* Validate the link parameters with the PCS */
> > > > +		if (pcs->ops->pcs_validate) {
> > > > +			ret = pcs->ops->pcs_validate(pcs, supported, state);
> > > 
> > > I wonder if we can add a pcs->supported_interfaces. That would let me
> > > write something like
> > 
> > I have two arguments against that:
> > 
> > 1) Given that .mac_select_pcs should not return a PCS that is not
> >     appropriate for the provided state->interface, I don't see what
> >     use having a supported_interfaces member in the PCS would give.
> >     All that phylink would end up doing is validating that the MAC
> >     was giving us a sane PCS.
> 
> The MAC may not know what the PCS can support. For example, the xilinx
> PCS/PMA can be configured to support 1000BASE-X, SGMII, both, or
> neither. How else should the mac find out what is supported?

I'll reply by asking a more relevant question at this point.

If we've asked for a PCS for 1000BASE-X via .mac_select_pcs() and a
PCS is returned that does not support 1000BASE-X, what happens then?
The system level says 1000BASE-X was supported when it isn't...
That to me sounds like bug.

> > 2) In the case of a static PCS (in other words, one attached just
> >     after phylink_create_pcs()) the PCS is known at creation time,
> >     so limiting phylink_config.supported_interfaces according to the
> >     single attached interface seems sane, rather than phylink having
> >     to repeatedly recalculate the bitwise-and between both
> >     supported_interface masks.
> > 
> > > static int xilinx_pcs_validate(struct phylink_pcs *pcs,
> > > 			       unsigned long *supported,
> > > 			       struct phylink_link_state *state)
> > > {
> > > 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> > > 
> > > 	phylink_set_port_modes(mask);
> > > 	phylink_set(mask, Autoneg);
> > > 	phylink_get_linkmodes(mask, state->interface,
> > > 			      MAC_10FD | MAC_100FD | MAC_1000FD);
> > > 
> > > 	linkmode_and(supported, supported, mask);
> > > }
> > 
> > This would be buggy - doesn't the PCS allow pause frames through?
> 
> Yes. I noticed this after writing my above email :)
> 
> > I already have a conversion for axienet in my tree, and it doesn't
> > need a pcs_validate() implementation. I'll provide it below.
> > 
> > > And of course, the above could become phylink_pcs_validate_generic with
> > > the addition of a pcs->pcs_capabilities member.
> > > 
> > > The only wrinkle is that we need to handle PHY_INTERFACE_MODE_NA,
> > > because of the pcs = pl->pcs assignment above. This would require doing
> > > the phylink_validate_any dance again.
> > 
> > Why do you think PHY_INTERFACE_MODE_NA needs handling? If this is not
> > set in phylink_config.supported_interfaces (which it should never be)
> > then none of the validation will be called with this.
> 
> If the MAC has no supported_interfaces and calls phylink_set_pcs, but
> does not implement mac_select_pcs, then you can have something like
> 
>     phylink_validate(NA)
>         phylink_validate_mac_and_pcs(NA)
>             pcs = pl->pcs;
>             pcs->ops->pcs_validate(NA)
>                 phylink_get_linkmodes(NA)
>                 /* returns just Pause and Asym_Pause linkmodes */
>             /* nonzero, so pcs_validate thinks it's fine */
>     /* phylink_validate returns 0, but there are no valid interfaces */

No, you don't end up in that situation, because phylink_validate() will
not return 0. It will return -EINVAL. We are not checking for an empty
supported mask, we are checking for a supported mask that contains no
linkmodes - this is an important difference between linkmode_empty()
and phylink_is_empty_linkmode(). The former checks for the linkmode
bitmap containing all zeros, the latter doesn't care about the media
bits, autoneg, pause or asympause linkmode bits. If all other bits are
zero, it returns true, causing phylink_validate_mac_and_pcs() to return
-EINVAL.

> > The special PHY_INTERFACE_MODE_NA meaning "give us everything you have"
> > is something I want to get rid of, and is something that I am already
> > explicitly not supporting for pcs_validate(). It doesn't work with the
> > mac_select_pcs() model, since that can't return all PCS that may be
> > used.
> > 
> > > 	if (state->interface == PHY_INTERFACE_MODE_NA)
> > > 		return -EINVAL;
> > > 
> > > at the top of phylink_pcs_validate_generic (perhaps with a warning).
> > > That would catch any MACs who use a PCS which wants the MAC to have
> > > supported_interfaces.
> > 
> > ... which could be too late.
> 
> You can't detect this in advance, since a MAC can choose to attach
> whatever PCS it wants at any time. So all you can do is warn about it so
> people report it as a bug instead of wondering why their ethernet won't
> configure.

As I say above, I don't see there's a problem here - and I think you've
mistaken the behaviour of phylink_is_empty_linkmode().

> 
> > > > +			if (ret < 0 || phylink_is_empty_linkmode(supported))
> > > > +				return -EINVAL;
> > > > +
> > > > +			/* Ensure the advertising mask is a subset of the
> > > > +			 * supported mask.
> > > > +			 */
> > > > +			linkmode_and(state->advertising, state->advertising,
> > > > +				     supported);
> > > > +		}
> > > >   	}
> > > >
> > > > +	/* Then validate the link parameters with the MAC */
> > > >   	pl->mac_ops->validate(pl->config, supported, state);
> > > 
> > > Shouldn't the PCS stuff happen here? Later in the series, you do things
> > > like
> > > 
> > > 	if (phy_interface_mode_is_8023z(state->interface) &&
> > > 	    !phylink_test(state->advertising, Autoneg))
> > > 		return -EINVAL;
> > > 
> > > but there's nothing to stop a mac validate from coming along and saying
> > > "we don't support autonegotiation".
> > 
> > How is autonegotiation a property of the MAC when there is a PCS?
> > In what situation is autonegotiation terminated at the MAC when
> > there is a PCS present?
> 
> *shrug* it doesn't make a difference really as long as the MAC and PCS
> play nice. But validate works by masking out bits, so you can only
> really test for a bit after everyone has gotten their chance to veto
> things. Which is why I think it is strange that the PCS check comes
> first.

For the explicit case you are highlighting (autoneg), please give an
example where both the PCS and MAC would get to "vote" on this bit.
Please explain how the MAC would even be involved in autonegotiation.

I'm not going to say that this model is perfect, because it isn't.
It is adequate for the purposes we need to solve to move the code
forwards, and I believe it will allow us to elimate the mac_ops
.validate method entirely in a release or two.

Once that is done, we will rely on mac_capabilities to tell us what
the MAC supports, which is really all that we need the MAC to be
telling us. This will become important when we e.g. properly model
rate adapting PCS.

We can't get close to a model that allows us to do that right now
because the .validate method prevents that because that deals with
media linkmodes, rather than just the capabilities of the MAC. Our
only option right now would be to completely avoid calling the
.validate method if we know we have a PCS and completely ignore
MAC capabilities.

This is an evolutionary step sorting out some of the issues. I'm
very sure that there will be things it doesn't do very well
identified, and we will need to address those later.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
