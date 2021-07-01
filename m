Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4B183B9472
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 17:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232413AbhGAQCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 12:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232126AbhGAQCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 12:02:04 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0511EC061762
        for <netdev@vger.kernel.org>; Thu,  1 Jul 2021 08:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/tsG7FfgDVviO9ddgOTScrmuYBWRySIKL4TCkGgx7Vc=; b=IwFXD5oqygKuRrfvyJqV++Irc
        MdY8hywJgLyZgnSHmZppNCxtTUf3LThomUuDylner1oZpgVai96ij+cksrunYMEGvLrmIC8Gq/Okd
        UHON1YoQJXNW6K9/pDwNRYlcpxj2ZLZ7m6y93b8IG6ZCtMSsvmXpYarJTgIgOakhNiVlipvRBD+U6
        ALIYwswYu7TC/OC9WC72KMArYiYDaFY5/xWLU67F9umeX6O8wgxQI4bHJhusITTIUgPURH+YZx5GJ
        Rat82Lj/uu/flvwIhosKQ66io/3SqMWQ/Y2dKQy8HtVJ0kpC5wu9WCMsGVe+INs6/kxUPadF1kAEk
        XryIwcmxA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45584)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lyz65-0001Oq-8n; Thu, 01 Jul 2021 16:59:25 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lyz63-0004D4-KH; Thu, 01 Jul 2021 16:59:23 +0100
Date:   Thu, 1 Jul 2021 16:59:23 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phylink: Support disabling autonegotiation
 for PCS
Message-ID: <20210701155923.GC1350@shell.armlinux.org.uk>
References: <20210630174927.1077249-1-robert.hancock@calian.com>
 <20210701145222.GK22278@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210701145222.GK22278@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 01, 2021 at 03:52:22PM +0100, Russell King (Oracle) wrote:
> On Wed, Jun 30, 2021 at 11:49:27AM -0600, Robert Hancock wrote:
> > The auto-negotiation state in the PCS as set by
> > phylink_mii_c22_pcs_config was previously always enabled when the driver is
> > configured for in-band autonegotiation, even if autonegotiation was
> > disabled on the interface with ethtool. Update the code to set the
> > BMCR_ANENABLE bit based on the interface's autonegotiation enabled
> > state.
> > 
> > Update phylink_mii_c22_pcs_get_state to not check
> > autonegotiation-related fields when autonegotiation is disabled.
> > 
> > Update phylink_mac_pcs_get_state to initialize the state based on the
> > interface's configured speed, duplex and pause parameters rather than to
> > unknown when autonegotiation is disabled, before calling the driver's
> > pcs_get_state functions, as they are not likely to provide meaningful data
> > for these fields when autonegotiation is disabled. In this case the
> > driver is really just filling in the link state field.
> > 
> > Note that in cases where there is a downstream PHY connected, such as
> > with SGMII and a copper PHY, the configuration set by ethtool is handled by
> > phy_ethtool_ksettings_set and not propagated to the PCS. This is correct
> > since SGMII or 1000Base-X autonegotiation with the PCS should normally
> > still be used even if the copper side has disabled it.
> 
> In theory, this seems to be correct, but...
> 
> We do have some cases where, if a port is in 1000Base-X mode, the
> documentation explicitly states that AN must be enabled. So, I think
> if we are introducing the possibility to disable the negotiation in
> 1000Base-X mode, we need to give an option to explicitly reject that
> configuration attempt.
> 
> We also need this to be consistently applied over all the existing
> phylink-using drivers that support 1000Base-X without AN - we shouldn't
> end up in the situation where we have different behaviours with
> different network drivers.
> 
> So, we need mvneta and mvpp2 to reject such a configuration - with
> these ports in 1000Base-X mode, the documentation states:
> 
> "Bit 2 Field InBandAnEn In-band Auto-Negotiation enable. ...
> When <PortType> = 1 (1000BASE-X) this field must be set to 1."
> 
> We should be aware that there may be other hardware out there which
> may not support 1000BASE-X without inband.

Incidentally, this also means that when we're in 2500BASE-X mode on
mvneta and mvpp2, PortType is 1, and we must use autonegotiation.

I think we _really_ need to have a better discussion about the
presence of AN or not with 2500BASE-X as far as the kernel is concerned
because we have ended up in the situation where mvneta and mvpp2 always
enable it (through need) for 1000BASE-X and 2500BASE-X, whereas others
always disable it in 2500BASE-X. Meanwhile, Xilinx allows it to be
configured. We seem to have headed into a situation where different
SoCs from different manufacturers disagree on whether 2500BASE-X does
negotiation, and thus we've ended up with different kernel behaviours.
This is not sane.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
