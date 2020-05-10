Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A64EF1CCB77
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 16:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729113AbgEJOFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 10:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728238AbgEJOFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 10:05:39 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 713C9C061A0C
        for <netdev@vger.kernel.org>; Sun, 10 May 2020 07:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=U1scZU0OfB6U3xPsTumdQ2lpWfnn2X5DtujsR2x6QfQ=; b=kPTGZJ0BTv8c8G+di5pi/lZIK
        dUSCxQJelTKM1LCRCSWyGbZac1raVmqlnWYp98M0OzWD4YueCBS1o0TbzuY5mfih2VGsTVc1IYuqr
        HiFS9n4IUKRVjG4LNYLMC/WJzR9ts0NM61T/VjBoLlJJvjNjcOn7biBOyrdqLEM5RHg6ab1/82CJO
        /F9hNhbdnObaVAXLnpI834nzYYU3HEiMvR3MaboMPoM3ngPC4ZgVMp7Vl8Rh2j7YUCVS3LdFQ6lGy
        vyfAY8WXPNgcinSfBbgyoUchbPJJ1osTfyFSO3Z9WESwlZIlFRNmA9eB4aUwinurkys2LefGUrZXr
        ikas8+4Gg==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:56202)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jXma5-0007FT-2N; Sun, 10 May 2020 15:05:29 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jXma1-0004ga-Tv; Sun, 10 May 2020 15:05:21 +0100
Date:   Sun, 10 May 2020 15:05:21 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/2] net: phy: check for aneg disabled and half
 duplex in phy_ethtool_set_eee
Message-ID: <20200510140521.GM1551@shell.armlinux.org.uk>
References: <8e7df680-e3c2-24ae-81d3-e24776583966@gmail.com>
 <0c8429c2-7498-efe8-c223-da3d17b1e8e6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c8429c2-7498-efe8-c223-da3d17b1e8e6@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 10, 2020 at 10:11:33AM +0200, Heiner Kallweit wrote:
> EEE requires aneg and full duplex, therefore return EPROTONOSUPPORT
> if aneg is disabled or aneg resulted in a half duplex mode.

I think this is completely wrong.  This is the ethtool configuration
interface for EEE that you're making fail.

Why should you not be able to configure EEE parameters if the link
happens to negotiated a half-duplex?  Why should you not be able to
adjust the EEE advertisment via ethtool if the link has negotiated
half-duplex?

Why should any of this configuration depend on the current state?

Why should we force people to negotiate a FD link before they can
then configure EEE, and then have to perform a renegotiation?

Sorry, but to me this patch seems to be a completely wrong approach,
and I really don't get what problem it is trying to fix.

> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/phy/phy.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index 8c22d02b4..891bb6929 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -1110,6 +1110,9 @@ int phy_ethtool_set_eee(struct phy_device *phydev, struct ethtool_eee *data)
>  	if (!phydev->drv)
>  		return -EIO;
>  
> +	if (phydev->autoneg == AUTONEG_DISABLE || phydev->duplex == DUPLEX_HALF)
> +		return -EPROTONOSUPPORT;
> +
>  	/* Get Supported EEE */
>  	cap = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_PCS_EEE_ABLE);
>  	if (cap < 0)
> -- 
> 2.26.2
> 
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
