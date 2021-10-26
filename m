Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5A243B61A
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 17:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237152AbhJZPyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 11:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237175AbhJZPxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 11:53:36 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE67C061745
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 08:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=V4xbVJYNqMfIcTfMHJZ1Rljb+VCAOQxbhBrd8cp2O6w=; b=eZ77nWW19/1xYym6ATOPoYY05V
        9ubeAhHaWJ2AzJIpaICB810h9viFcRCaW2KwdVop2AJ2NRHA0/t5wtUx7tKpdPaqmgwlfNh1wR4rb
        kOAEJ97FdJbXtyn4zXkVv/AVyW8Jd2supHs5qySTumjbTXyE87DMq8JC3w3vWj0R1kSK1tXQRLw1G
        XP4x5hon/RDxUO0GkkZS2jgF0fMOYEKAvoi1XaNCbnDnzPdGQElTAXkRfEKKFruVQfn5UT7MzMv6P
        xUTjOIpTXJZrJnZNuaa4XIwD0kf9xmgVd4QNPXt47jQNW0fvxIv3hu1H2MDoGnKEz8cm3BstBhUmb
        NhMo4UIA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55318)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mfOjF-0005Uw-Lp; Tue, 26 Oct 2021 16:51:09 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mfOjE-0006sD-4w; Tue, 26 Oct 2021 16:51:08 +0100
Date:   Tue, 26 Oct 2021 16:51:08 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH v4] net: macb: Fix several edge cases in validate
Message-ID: <YXgj7HUkcRLdq+eB@shell.armlinux.org.uk>
References: <20211025172405.211164-1-sean.anderson@seco.com>
 <20211025174401.1de5e95d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <4e430fbb-0908-fd3b-bb6e-ec316ea8d66a@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e430fbb-0908-fd3b-bb6e-ec316ea8d66a@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 11:30:08AM -0400, Sean Anderson wrote:
> I don't know if it's a "fix" per se. The current logic isn't wrong,
> since I believe that the configurations where the above patch would make
> a difference do not exist. However, as noted in the commit message, this
> makes refactoring difficult. For example, one might want to implement
> supported_interfaces like
> 
>        if (bp->caps & MACB_CAPS_HIGH_SPEED &&
>            bp->caps & MACB_CAPS_PCS)
>                __set_bit(PHY_INTERFACE_MODE_10GBASER, supported);
>        if (macb_is_gem(bp) && bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
>                __set_bit(PHY_INTERFACE_MODE_GMII, supported);
> 		phy_interface_set_rgmii(supported);
>                if (bp->caps & MACB_CAPS_PCS)
>                        __set_bit(PHY_INTERFACE_MODE_SGMII, supported);
>        }
>        __set_bit(PHY_INTERFACE_MODE_MII, supported);
>        __set_bit(PHY_INTERFACE_MODE_RMII, supported);
> 
> but then you still need to check for GIGABIT_MODE in validate to
> determine whether 10GBASER should "support" 10/100. See [1] for more
> discussion.

However, 10GBASE-R doesn't support anything except 10G speeds, except
if the PHY itself does rate matching to achieve the slower speeds.
Then you need pause frames between the MAC and PHY to control the MAC
sending rate - which isn't something that the phylib model supports
particularly well.

The current code and your patched code conforms to this when
state->interface is 10GBASE-R _and_ MACB_CAPS_GIGABIT_MODE_AVAILABLE
is set, then we only end up with 10G linkmodes being allowed.

The problem case occurs in current code when
MACB_CAPS_GIGABIT_MODE_AVAILABLE is _not_ set, but state->interface
is 10GBASE-R. Current code ends up saying that 10GBASE-R supports
10/100 link modes, which is wrong.

The existing code:

        if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE &&
            (state->interface == PHY_INTERFACE_MODE_NA ||
             state->interface == PHY_INTERFACE_MODE_10GBASER)) {
                phylink_set(mask, 10000baseCR_Full);
                phylink_set(mask, 10000baseER_Full);
                phylink_set(mask, 10000baseKR_Full);
                phylink_set(mask, 10000baseLR_Full);
                phylink_set(mask, 10000baseLRM_Full);
                phylink_set(mask, 10000baseSR_Full);
                phylink_set(mask, 10000baseT_Full);
                if (state->interface != PHY_INTERFACE_MODE_NA)
                        goto out;
        }

        phylink_set(mask, 10baseT_Half);
        phylink_set(mask, 10baseT_Full);
        phylink_set(mask, 100baseT_Half);
        phylink_set(mask, 100baseT_Full);

Would have been better written as:

	if (state->interface == PHY_INTERFACE_MODE_NA ||
	    state->interface == PHY_INTERFACE_MODE_10GBASER) {
		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
	                phylink_set(mask, 10000baseCR_Full);
	                phylink_set(mask, 10000baseER_Full);
	                phylink_set(mask, 10000baseKR_Full);
	                phylink_set(mask, 10000baseLR_Full);
	                phylink_set(mask, 10000baseLRM_Full);
	                phylink_set(mask, 10000baseSR_Full);
	                phylink_set(mask, 10000baseT_Full);
		}
                if (state->interface != PHY_INTERFACE_MODE_NA)
                        goto out;
        }

        phylink_set(mask, 10baseT_Half);
        phylink_set(mask, 10baseT_Full);
        phylink_set(mask, 100baseT_Half);
        phylink_set(mask, 100baseT_Full);

which would have avoided getting to the code that sets 10/100 link
modes when state->interface is 10GBASE-R.

The same transformation is probably applicable to the next if ()
block as well.

If I truely understood exactly what MACB_CAPS_GIGABIT_MODE_AVAILABLE,
MACB_CAPS_HIGH_SPEED, and MACB_CAPS_PCS were indicating and how they
relate to what is supported, I might be tempted to come up with a
better implementation myself. However, every time I look at the
existing code, it just confuses me - it seems to me that the use of
those capability bits is entirely inconsistent in the current
macb_validate() implementation.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
