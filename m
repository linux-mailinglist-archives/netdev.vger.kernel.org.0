Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C28242FE56
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 00:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243373AbhJOWtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 18:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243342AbhJOWtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 18:49:51 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30687C061762
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 15:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=X5LeAbmQ65BBLEZzZzw4wATFFXXc6oTat8+brDieWcg=; b=AB3mPMOIH3lu3cDlwifwu0sK9n
        8Nr20XpqI2Tr2LYvRQVAm+C+65RWFfqssvmkypFyVApLJiqk9opq46Mk5kIflwosyUZn12R/WeT8T
        DknAL4U7ykKMWZqZYxc0iHgNX8x2fOyYP/IKkyrqheNMLYeUjgIMFoTqGWSgJWNCKZBRsY5MUQ15U
        uTApHbD0HQm9T1KckilyiyUiiZHwjAfzgNMd/RP+2chenABmRNlRgEiePNGtDeHdFkZL0g2Wj/9ly
        X1VQZwi81EmBiuExRXV1M6H34oaTEXq34Ljk5IaGwRMBsSyuD4rq/3cYat+47bL3vQqO+BXdcvphR
        AEsBgAfw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55138)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mbVzA-0002yS-O6; Fri, 15 Oct 2021 23:47:32 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mbVz8-0003Tk-SX; Fri, 15 Oct 2021 23:47:30 +0100
Date:   Fri, 15 Oct 2021 23:47:30 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Antoine Tenart <atenart@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: Re: [PATCH v2 1/2] net: macb: Clean up macb_validate
Message-ID: <YWoFAiCRZJGnkBJB@shell.armlinux.org.uk>
References: <20211011165517.2857893-1-sean.anderson@seco.com>
 <163402758460.4280.9175185858026827934@kwain>
 <YWhcEzZzrE5lMxD4@shell.armlinux.org.uk>
 <82025310-10f3-28fd-1b52-2b3969d5f00b@seco.com>
 <YWi4a5Jme5IDSuKE@shell.armlinux.org.uk>
 <95defe0f-542c-b93d-8d66-745130fbe580@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95defe0f-542c-b93d-8d66-745130fbe580@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 15, 2021 at 06:28:10PM -0400, Sean Anderson wrote:
> On 10/14/21 7:08 PM, Russell King (Oracle) wrote:
> > On Thu, Oct 14, 2021 at 01:50:36PM -0400, Sean Anderson wrote:
> > > On 10/14/21 12:34 PM, Russell King (Oracle) wrote:
> > > > You can find some patches that add the "supported_interfaces" masks
> > > > in git.armlinux.org.uk/linux-arm.git net-queue
> > > >
> > > > and we could add to phylink_validate():
> > > >
> > > > 	if (!phy_interface_empty(pl->config->supported_interfaces) &&
> > > > 	    !test_bit(state->interface, pl->config->supported_interfaces))
> > > > 		return -EINVAL;
> > > >
> > > > which should go a long way to simplifying a lot of these validation
> > > > implementations.
> > > >
> > > > Any thoughts on that?
> > > 
> > > IMO the actual issue here is PHY_INTERFACE_MODE_NA. Supporting this
> > > tends to add complexity to validate(), because we have a lot of code
> > > like
> > > 
> > > 	if (state->interface == PHY_INTERFACE_MODE_FOO) {
> > > 		if (we_support_foo())
> > > 			phylink_set(mask, Foo);
> > > 		else if (state->interface != PHY_INTERFACE_MODE_NA) {
> > > 			linkmode_zero(supported);
> > > 			return;
> > > 		}
> > > 	}
> > > 
> > > which gets even worse when we want to have different interfaces share
> > > logic.
> > 
> > There is always the option to use different operations structs if the
> > properties of the interfaces can be divided up in that way - and that
> > will probably be more efficient (not that the validate callback is a
> > performance critical path though.)
> > 
> > > IMO validate() could be much cleaner if we never called it with
> > > NA and instead did something like
> > > 
> > > 	if (state->interface == PHY_INTERFACE_MODE_NA) {
> > > 		unsigned long *original;
> > > 
> > > 		linkmode_copy(original, supported);
> > > 		for (i = 0; i < PHY_INTERFACE_MODE_MAX; i++) {
> > > 			if (test_bit(i, pl->config->supported_interfaces)) {
> > > 				unsigned long *iface_mode;
> > > 
> > > 				linkmode_copy(iface_mode, original);
> > > 				state->interface = i;
> > > 				pl->mac_ops->validate(pl->config, iface_mode, state);
> > > 				linkmode_or(supported, supported, iface_mode);
> > > 			}
> > > 		}
> > > 		state->interface = PHY_INTERFACE_MODE_NA;
> > > 	}
> > > 
> > > This of course can be done in addition to/instead of your above
> > > suggestion. I suggested something like this in v3 of this series, but it
> > > would be even better to do this on the phylink level.
> > 
> > In addition I think - I think we should use a non-empty
> > supported_interfaces as an indicator that we use the above, otherwise
> > we have to loop through all possible interface modes. That also
> > provides some encouragement to fill out the supported_interfaces
> > member.
> 
> I had a stab at this today [1], but it is only compile-tested. In order
> to compile "net: phylink: use phy_interface_t bitmaps for optical
> modules", I needed to run
> 
> 	sed -ie 's/sfp_link_an_mode/cfg_link_an_mode/g' drivers/net/phy/phylink.c
> 
> Do you plan on making up a series for this? I think the end result is
> much nicer that v3 of this series.

I have been working on it but haven't finished the patches yet. There's
a few issues that came up with e.g. DSA and mvneta being able to switch
between different speeds with some SFP modules that have needed other
tweaks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
