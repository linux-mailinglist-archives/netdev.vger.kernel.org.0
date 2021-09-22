Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1858C4152AC
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 23:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237936AbhIVVYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 17:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237770AbhIVVYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 17:24:02 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74882C061574
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 14:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=KsnryHZvsewJwHxjPAMINXkoQOX1qMUhXwLNx58bPXc=; b=W50S8D3t0cKoMD/S5QDCYwtnES
        /SUmxsmhnFnOKX5l5PdY5m3t36eMFNieCk+RgsoMkoAS6+/48XRDs8c3mR6QBrLQZ3OlLzq1oSdTw
        N1VRCA7bif06Xna9g+4c6ucX+yo9FfobVzRgveijCbW4kH5SIWO9wCAq4k07cOo5qx0lABFGjrf69
        RGQrHcHlxSJm779csKbm4htFw1I6M4sjIXuk1dCMbllIplo2/qPoO3tM27worqZ+/jW78myJ93UFP
        6e74ub6T1xQLjAFL++EH3+4gFyfjxKQvtf3GRY4oX3E1pUr1nABulexX5tMGUXvwSdk+DesMpEf8u
        MuRM4ltw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54742)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mT9hB-0004MB-Nu; Wed, 22 Sep 2021 22:22:25 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mT9h5-0004aC-Jw; Wed, 22 Sep 2021 22:22:19 +0100
Date:   Wed, 22 Sep 2021 22:22:19 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: Re: [RFC PATCH v3 net-next 2/6] net: phylink: introduce a generic
 method for querying PHY in-band autoneg capability
Message-ID: <YUuei7Qnb6okURPE@shell.armlinux.org.uk>
References: <20210922181446.2677089-1-vladimir.oltean@nxp.com>
 <20210922181446.2677089-3-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922181446.2677089-3-vladimir.oltean@nxp.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 09:14:42PM +0300, Vladimir Oltean wrote:
> +static unsigned int phylink_fixup_inband_aneg(struct phylink *pl,
> +					      struct phy_device *phy,
> +					      unsigned int mode)
> +{
> +	int ret;
> +
> +	ret = phy_validate_inband_aneg(phy, pl->link_interface);
> +	if (ret == PHY_INBAND_ANEG_UNKNOWN) {
> +		phylink_dbg(pl,
> +			    "PHY driver does not report in-band autoneg capability, assuming %s\n",
> +			    phylink_autoneg_inband(mode) ? "true" : "false");
> +
> +		return mode;
> +	}
> +
> +	if (phylink_autoneg_inband(mode) && !(ret & PHY_INBAND_ANEG_ON)) {
> +		phylink_err(pl,
> +			    "Requested in-band autoneg but driver does not support this, disabling it.\n");

If we add support to the BCM84881 driver to work with
phy_validate_inband_aneg(), then this will always return
PHY_INBAND_ANEG_OFF and never PHY_INBAND_ANEG_ON. Consequently,
this will always produce this "error". It is not an error in the
SFP case, but it is if firmware is misconfigured.

So, this needs better handling - we should not be issuing an error-
level kernel message for something that is "normal".

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
