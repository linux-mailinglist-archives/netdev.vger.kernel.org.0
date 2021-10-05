Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDD842306C
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 20:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235099AbhJESzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 14:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbhJESzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 14:55:00 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6502C061749;
        Tue,  5 Oct 2021 11:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=qjr76vSgztkgEfig8jYzCaTebFv24jfWo3PlnZ+dHr4=; b=eWtqvcIhO5Vo588yDa9141/8Ku
        mbeJ/XvB8y/8U3rR+1lN0/ry3+YEpFASbvneEgRMMem6fSlrsdTtzf96aD8xqS1eR1KEsViPw7Ny2
        S+XAGgj92edGRNx4xTWhCSOo+N/xEvLwhr2/zkxFbrs7WqWY/wZA+4ccHjB6zBepbhaFESgpYOs6D
        Fa8DmYq6EsN1shs74Em7ev5SLBTsUClkYWbbbF/Do7DtmciaKDNL+oGL4U6lWE/Cocv65dCkDN94W
        xu46KrfbP1v3bP61IpxGcgdIxxLH170VQu3TzNVY5D5D33ccVd2RIT/5LtGK+TBT77vp2q5rdqnRy
        d/CdwtRw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54962)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mXpYo-0000ey-Co; Tue, 05 Oct 2021 19:53:06 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mXpYm-0000EW-3k; Tue, 05 Oct 2021 19:53:04 +0100
Date:   Tue, 5 Oct 2021 19:53:04 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: Re: [RFC net-next PATCH 10/16] net: macb: Move PCS settings to PCS
 callbacks
Message-ID: <YVyfEOu+emsX/ERr@shell.armlinux.org.uk>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
 <20211004191527.1610759-11-sean.anderson@seco.com>
 <YVwjjghGcXaEYgY+@shell.armlinux.org.uk>
 <7c92218c-baec-a991-9d6b-af42dfabbad3@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c92218c-baec-a991-9d6b-af42dfabbad3@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 05, 2021 at 12:03:50PM -0400, Sean Anderson wrote:
> Hi Russell,
> 
> On 10/5/21 6:06 AM, Russell King (Oracle) wrote:
> > On Mon, Oct 04, 2021 at 03:15:21PM -0400, Sean Anderson wrote:
> > > +static void macb_pcs_get_state(struct phylink_pcs *pcs,
> > > +			       struct phylink_link_state *state)
> > > +{
> > > +	struct macb *bp = pcs_to_macb(pcs);
> > > +
> > > +	if (gem_readl(bp, NCFGR) & GEM_BIT(SGMIIEN))
> > > +		state->interface = PHY_INTERFACE_MODE_SGMII;
> > > +	else
> > > +		state->interface = PHY_INTERFACE_MODE_1000BASEX;
> > 
> > There is no requirement to set state->interface here. Phylink doesn't
> > cater for interface changes when reading the state. As documented,
> > phylink will set state->interface already before calling this function
> > to indicate what interface mode it is currently expecting from the
> > hardware.
> 
> Ok, so instead I should be doing something like
> 
> if (gem_readl(bp, NCFGR) & GEM_BIT(SGMIIEN))
> 	interface = PHY_INTERFACE_MODE_SGMII;
> else
> 	interface = PHY_INTERFACE_MODE_1000BASEX;
> 
> if (interface != state->interface) {
> 	state->link = 0;
> 	return;
> }

Why would it be different? If we've called the pcs_config method to
set the interface to one mode, why would it change?

> > There has been the suggestion that we should allow in-band AN to be
> > disabled in 1000base-X if we're in in-band mode according to the
> > ethtool state.
> 
> This logic is taken from phylink_mii_c22_pcs_config. Maybe I should add
> another _encode variant? I hadn't done this here because the logic was
> only one if statement.
> 
> > I have a patch that adds that.
> 
> Have you posted it?

I haven't - it is a patch from Robert Hancock, "net: phylink: Support
disabling autonegotiation for PCS". I've had it in my tree for a while,
but I do want to make some changes to it before re-posting.

> > You can't actually abort at this point - phylink will print the error
> > and carry on regardless. The checking is all done via the validate()
> > callback and if that indicates the interface mode is acceptable, then
> > it should be accepted.
> 
> Ok, so where can the PCS NAK an interface? This is the only callback
> which has a return code, so I assumed this was the correct place to say
> "no, we don't support this." This is what lynx_pcs_config does as well.

At the moment, the PCS doesn't get to NAK an inappropriate interface.
That's currently the job of the MAC's validate callback with the
assumtion that the MAC knows what interfaces are supportable.

Trying to do it later, once the configuration has been worked out can
_only_ lead to a failure of some kind - in many paths, there is no way
to report the problem except by printing a message into the kernel log.

For example, by the time we reach pcs_config(), we've already prepared
the MAC for a change to the interface, we've told the MAC to configure
for that interface. Now the PCS rejects it - we have no record of the
old configuration to restore. Even if we had a way to restore it, then
we could return an error to the user - but the user doesn't get to
control the interface themselves. If it was the result of a PHY changing
its interface, then what - we can only log an error to the kernel log.
If it's the result of a SFP being plugged in, we have no way to
renegotiate.

pcs_config() is too late to be making decisions about whether the
requested configuration is acceptable or not. It needs to be done as
part of the validation step.

However, the validation step is not purely just validation, but it's
negotiation too for SFPs to be able to work out what interface mode
they should use in combination with the support that the MAC/PCS
offers.

I do feel that the implementation around the validation/selection of
interface for SFP etc is starting to creak, and I've some patches that
introduce a bitmap of interface types that are supported by the various
components. I haven't had the motivation to finish that off as my last
attempt at making a phylink API change was not pleasant in terms of
either help updating network drivers or getting patches tested. So I
now try to avoid phylink API changes at all cost.

People have whinged that phylink's API changes too quickly... I'm
guessing we're now going to get other people arguing that it needs
change to fix issues like this...

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
