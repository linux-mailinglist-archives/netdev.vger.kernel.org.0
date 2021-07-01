Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB3883B9396
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 16:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbhGAOzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 10:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232413AbhGAOy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 10:54:59 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05319C061762
        for <netdev@vger.kernel.org>; Thu,  1 Jul 2021 07:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=n+WAmZLYN7PJyuyRoStv6iVr7lqrH2yN8IGe+c5jv1A=; b=iq4RJ+dmntJqwr/5glpbGcXI7
        duYKLrVNU4nn2RTbh0WiwkgolpO0+N4NgTnbxJ9eusHnvdp+wcP9ogDuEUrVWNS1hf+InBqFSHG5V
        JelHQVFzJfJ7nIhnR6Cao4amQW6tB9Knq3406eW/OtmRtQm4Bg1yKAkjyvZh3apgi2KBWhj0Qf2jk
        Z3ZoA1z4hbGrCknxFTFTNqOBhZctq65OaeQ3uMNBbBhgTs4Xq2pI6uitwK/wlrqR7FOot11GVbL9w
        4P3m5UUNolzo51NB3ePjrmZvRbjHnoeQjSViEW5wipvm2VfuuuzHKTpLEHN8G7z2b5A3A7Nmfffuu
        atYUo9KdA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45580)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lyy3E-0001Jk-8B; Thu, 01 Jul 2021 15:52:24 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lyy3C-0004Am-Cy; Thu, 01 Jul 2021 15:52:22 +0100
Date:   Thu, 1 Jul 2021 15:52:22 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phylink: Support disabling autonegotiation
 for PCS
Message-ID: <20210701145222.GK22278@shell.armlinux.org.uk>
References: <20210630174927.1077249-1-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630174927.1077249-1-robert.hancock@calian.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 30, 2021 at 11:49:27AM -0600, Robert Hancock wrote:
> The auto-negotiation state in the PCS as set by
> phylink_mii_c22_pcs_config was previously always enabled when the driver is
> configured for in-band autonegotiation, even if autonegotiation was
> disabled on the interface with ethtool. Update the code to set the
> BMCR_ANENABLE bit based on the interface's autonegotiation enabled
> state.
> 
> Update phylink_mii_c22_pcs_get_state to not check
> autonegotiation-related fields when autonegotiation is disabled.
> 
> Update phylink_mac_pcs_get_state to initialize the state based on the
> interface's configured speed, duplex and pause parameters rather than to
> unknown when autonegotiation is disabled, before calling the driver's
> pcs_get_state functions, as they are not likely to provide meaningful data
> for these fields when autonegotiation is disabled. In this case the
> driver is really just filling in the link state field.
> 
> Note that in cases where there is a downstream PHY connected, such as
> with SGMII and a copper PHY, the configuration set by ethtool is handled by
> phy_ethtool_ksettings_set and not propagated to the PCS. This is correct
> since SGMII or 1000Base-X autonegotiation with the PCS should normally
> still be used even if the copper side has disabled it.

In theory, this seems to be correct, but...

We do have some cases where, if a port is in 1000Base-X mode, the
documentation explicitly states that AN must be enabled. So, I think
if we are introducing the possibility to disable the negotiation in
1000Base-X mode, we need to give an option to explicitly reject that
configuration attempt.

We also need this to be consistently applied over all the existing
phylink-using drivers that support 1000Base-X without AN - we shouldn't
end up in the situation where we have different behaviours with
different network drivers.

So, we need mvneta and mvpp2 to reject such a configuration - with
these ports in 1000Base-X mode, the documentation states:

"Bit 2 Field InBandAnEn In-band Auto-Negotiation enable. ...
When <PortType> = 1 (1000BASE-X) this field must be set to 1."

We should be aware that there may be other hardware out there which
may not support 1000BASE-X without inband.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
