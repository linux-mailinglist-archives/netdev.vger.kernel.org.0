Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEB14257D6
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 18:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242405AbhJGQZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 12:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241221AbhJGQZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 12:25:35 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3941C061570;
        Thu,  7 Oct 2021 09:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jkXCMS5VNoUyXW6vTJCvWdqKbyECDVes7onXU0a4ZLY=; b=w6rtcG4sxE47wlrzkw46Qhg6SQ
        Ye44R9H+/bpcSiA7vANm1cc4sowUQEHgKtGi8rKoW7MpU8Rxg6/WUt5B2b7zFGzxwFk8dLallzMrV
        eUN1LuxoWUsMOcNJfHLHHd+teHyph9cXjm8niM9vnG2vwicqhY6z5WM2kUPtOihG0aFueT+4jZXcl
        77DXQRMrG3+6YD6VPScfdIAJZfrLW/HSxVW9jU1s35YUsKUlRxnP/09GKKKsAPgNuPoyJASjhsCw3
        iVhXpG+H5yYe6K4gzJ0TuYu/glIAefmyWSSUzKgZ682jCjhIQ1b+u/IpJV5xtC6JZICDPlAEhGW7x
        LTR5kCYw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55004)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mYWBG-0002eC-IG; Thu, 07 Oct 2021 17:23:38 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mYWBE-00021h-8w; Thu, 07 Oct 2021 17:23:36 +0100
Date:   Thu, 7 Oct 2021 17:23:36 +0100
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
Message-ID: <YV8fCAkcIGY+yEmQ@shell.armlinux.org.uk>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
 <20211004191527.1610759-11-sean.anderson@seco.com>
 <YVwjjghGcXaEYgY+@shell.armlinux.org.uk>
 <7c92218c-baec-a991-9d6b-af42dfabbad3@seco.com>
 <YVyfEOu+emsX/ERr@shell.armlinux.org.uk>
 <ddb81bf5-af74-1619-b083-0dba189a5061@seco.com>
 <YVzPgTAS0grKl6CN@shell.armlinux.org.uk>
 <YV7NHZRFZ9U3Xj8v@shell.armlinux.org.uk>
 <YV7Z/MF7geOp+JM2@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YV7Z/MF7geOp+JM2@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 12:29:00PM +0100, Russell King (Oracle) wrote:
> Here's a patch which illustrates roughly what I'm thinking at the
> moment - only build tested.
> 
> mac_select_pcs() should not ever fail in phylink_major_config() - that
> would be a bug. I've hooked mac_select_pcs() also into the validate
> function so we can catch problems there, but we will need to involve
> the PCS in the interface selection for SFPs etc.
> 
> Note that mac_select_pcs() must be inconsequential - it's asking the
> MAC which PCS it wishes to use for the interface mode.
> 
> I am still very much undecided whether we wish phylink to parse the
> pcs-handle property and if present, override the MAC - I feel that
> logic depends in the MAC driver, since a single PCS can be very
> restrictive in terms of what interface modes are supportable. If the
> MAC wishes pcs-handle to override its internal ones, then it can
> always do:
> 
> 	if (port->external_pcs)
> 		return port->external_pcs;
> 
> in its mac_select_pcs() implementation. This gives us a bit of future
> flexibility.
> 
> If we parse pcs-handle in phylink, then if we end up with multiple PCS
> to choose from, we then need to work out how to either allow the MAC
> driver to tell phylink not to parse pcs-handle, or we need some way for
> phylink to ask the MAC "these are the PCS I have, which one should I
> use" which is yet another interface.
> 
> What I don't like about the patch is the need to query the PCS based on
> interface - when we have a SFP plugged in, it may support multiple
> interfaces. I think we still need the MAC to restrict what it returns
> in its validate() method according to the group of PCS that it has
> available for the SFP interface selection to work properly. Things in
> this regard should become easier _if_ I can switch phylink over to
> selecting interface based on phy_interface_t bitmaps rather than the
> current bodge using ethtool link modes, but that needs changes to phylib
> and all MAC drivers, otherwise we have to support two entirely separate
> ways to select the interface mode.
> 
> My argument against that is... I'll end up converting the network
> interfaces that I use to the new implementation, and the old version
> will start to rot. I've already stopped testing phylink without a PCS
> attached for this very reason. The more legacy code we keep, the worse
> this problem becomes.

Having finished off the SFP side of the phy_interface_t bitmap
(http://git.armlinux.org.uk/cgit/linux-arm.git/log/?h=net-queue)
and I think the mac_select_pcs() approach will work.

See commit
http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=net-queue&id=3e0d51c361f5191111af206e3ed024d4367fce78
where we have a set of phy_interface_t to choose one from, and if
we add PCS selection into that logic, the loop becomes:

static phy_interface_t phylink_select_interface(struct phylink *pl,
						const unsigned long *intf
						const char *intf_name)
{
	phy_interface_t interface, intf;

	...

	interface = PHY_INTERFACE_MODE_NA;
	for (i = 0; i < ARRAY_SIZE(phylink_sfp_interface_preference); i++) {
		intf = phylink_sfp_interface_preference[i];

		if (!test_bit(intf, u))
			continue;

		pcs = pl->pcs;
		if (pl->mac_ops->mac_select_pcs) {
			pcs = pl->mac_ops->mac_select_pcs(pl->config, intf);
			if (!pcs)
				continue;
		}

		if (pcs && !test_bit(intf, pcs->supported_interfaces))
			continue;

		interface = intf;
		break;
	}
	...
}

The alternative would be to move some of that logic into
phylink_sfp_config_nophy(), and will mean knocking out bits from
the mask supplied to phylink_select_interface() each time we select
an interface mode that the PCS doesn't support... which sounds rather
more yucky to me.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
