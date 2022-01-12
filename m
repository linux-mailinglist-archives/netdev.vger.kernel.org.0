Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDDF48C487
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 14:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353479AbiALNNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 08:13:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353439AbiALNN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 08:13:26 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F21C034002;
        Wed, 12 Jan 2022 05:13:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=K9qYdakio6i6nSysS/doW2LJOLUcCtqKh6YyRSh0/jE=; b=caQD6UaeVgCHokXJSxvWrX9Qt3
        phEFylhKv3Ve77PlrZgeu0SaXe3N5hGI6+w8pSnsy0NUkv1nwCpVbCY3er5fKoBuQeQWBneucwMyA
        8sl+uTpvFgJgY9RYPZqa8kBpYzPWgB4TgwSVUIjHqITAa2cLfOqXv7z4ibePr+ImhHWoldEb+AakH
        4k0feyiJEoLkuD/jQUqtpcAF9epeRBuGh3ayZ+jr/TeZGLVpzg0dA98dnzM2NqUDkBIclKSGF8Spe
        cTfsdEXXLCZq42b2hd1p6cQsuc8rqfns2eE2mrkbDCCUeMKLFm1dv7sTA7s1isiiBiuoKn6yyh07c
        fnpMabNA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56672)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n7dQu-000617-Ss; Wed, 12 Jan 2022 13:12:56 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n7dQr-0006vZ-UR; Wed, 12 Jan 2022 13:12:53 +0000
Date:   Wed, 12 Jan 2022 13:12:53 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net v2] net: phy: marvell: add Marvell specific PHY
 loopback
Message-ID: <Yd7T1e/R9jGWMK2B@shell.armlinux.org.uk>
References: <20220112093344.27894-1-mohammad.athari.ismail@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220112093344.27894-1-mohammad.athari.ismail@intel.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 05:33:44PM +0800, Mohammad Athari Bin Ismail wrote:
> +static int marvell_loopback(struct phy_device *phydev, bool enable)
> +{
> +	if (enable) {
> +		u16 bmcr_ctl = 0, mscr2_ctl = 0;
> +
> +		if (phydev->speed == SPEED_1000)
> +			bmcr_ctl = BMCR_SPEED1000;
> +		else if (phydev->speed == SPEED_100)
> +			bmcr_ctl = BMCR_SPEED100;
> +
> +		if (phydev->duplex == DUPLEX_FULL)
> +			bmcr_ctl |= BMCR_FULLDPLX;
> +
> +		phy_modify(phydev, MII_BMCR, ~0, bmcr_ctl);

Is there any point in doing a read-modify-write here if you're just
setting all bits in the register? Wouldn't phy_write() be more
appropriate? What about error handing?

> +
> +		if (phydev->speed == SPEED_1000)
> +			mscr2_ctl = BMCR_SPEED1000;
> +		else if (phydev->speed == SPEED_100)
> +			mscr2_ctl = BMCR_SPEED100;
> +
> +		phy_modify_paged(phydev, MII_MARVELL_MSCR_PAGE,
> +				 MII_88E1510_MSCR_2, BMCR_SPEED1000 |
> +				 BMCR_SPEED100, mscr2_ctl);
> +
> +		/* Need soft reset to have speed configuration takes effect */
> +		genphy_soft_reset(phydev);
> +
> +		/* FIXME: Based on trial and error test, it seem 1G need to have
> +		 * delay between soft reset and loopback enablement.
> +		 */
> +		if (phydev->speed == SPEED_1000)
> +			msleep(1000);
> +
> +		return phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK,
> +				  BMCR_LOOPBACK);
> +	} else {
> +		phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK, 0);

Error handling?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
