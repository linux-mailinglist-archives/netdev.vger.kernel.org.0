Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D72C831B01F
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 11:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhBNKhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 05:37:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbhBNKhf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 05:37:35 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706DAC061574
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 02:36:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=DNWt/P7MwV6niZXXSsY8aqlHK0bQEKYC0HV9L8sXuIk=; b=Jz+o7CSOkZd6DXnONRNDf2r0Q
        lrJCy6OxVBil5TQuSM56FA95CNnJNBQmxmiA+H7zk4uHXGXfo00LUYe0tOReQdh6WOdoTof9RUVwQ
        jwClvE/Nj+xpUF3bi4lOBiiFP5QHE/NHSiuT0Z93y+kHn+KNcgP/InJzFR2/jayXW77Tavn+OvlEP
        UbvtJujZJO9TEa3ql3GxNId27/LEdi62TsI3lSUkzBgFW8PUq0Ss3JrjkV7vuhmSdzGSpTFY7YGfR
        E8qkgbQQP6FW7nZCz578tEJdsGYPJyLbLOk0Kv8P3yx12XmuwT2xeff92l1rgVKouFJQtFj09WkSR
        2W2iicVWA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43246)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lBElf-0000JO-2u; Sun, 14 Feb 2021 10:36:43 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lBEkT-0000bj-Uu; Sun, 14 Feb 2021 10:35:29 +0000
Date:   Sun, 14 Feb 2021 10:35:29 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 1/2] net: phylink: explicitly configure in-band
 autoneg for PHYs that support it
Message-ID: <20210214103529.GT1463@shell.armlinux.org.uk>
References: <20210212172341.3489046-1-olteanv@gmail.com>
 <20210212172341.3489046-2-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210212172341.3489046-2-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 07:23:40PM +0200, Vladimir Oltean wrote:
> +	ret = phy_config_inband_aneg(phy,
> +				     (pl->cur_link_an_mode == MLO_AN_INBAND));

Please use phylink_autoneg_inband(pl->cur_link_an_mode) here.

> +	if (ret && ret != -EOPNOTSUPP) {
> +		phylink_warn(pl, "failed to configure PHY in-band autoneg: %d\n",
> +			     ret);

Please use %pe and ERR_PTR(ret) so we can get a symbolic errno value.

As mentioned in this thread, we have at least one PHY which is unable
to provide the inband signalling in any mode (BCM84881). Currently,
phylink detects this PHY on a SFP (in phylink_phy_no_inband()) and
adjusts not to use inband mode. This would need to be addressed if we
are creating an alterative way to discover whether the PHY supports
inband mode or not.

Also, there needs to be consideration of PHYs that dynamically change
their interface type, and whether they support inband signalling.
For example, a PHY may support a mode where it dynamically selects
between 10GBASE-R, 5GBASE-R, 2500BASE-X and SGMII, where the SGMII
mode may have inband signalling enabled or disabled. This is not a
theoretical case; we have a PHY like that supported in the kernel and
boards use it. What would the semantics of your new call be for a PHY
that performs this?

Should we also have a phydev->inband tristate, taking values "unknown,
enabled, disabled" which the PHY driver is required to update in their
read_status callback if they dynamically change their interface type?
(Although then phylink will need to figure out how to deal with that.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
