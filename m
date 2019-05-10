Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E77271A444
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 23:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbfEJVEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 17:04:12 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34170 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727677AbfEJVEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 17:04:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Jf3Pm2zDnOWtkQJIjcun0b5bQQ/YocTgtQI3kHh8yL8=; b=GhV0V2JAEAawViKkY2SVXycQp
        58sa/lOsnxvAUOPJJLwRr/I8dd7Ihx7veCwvg8HSVDid0w1bxTWQxO9ld3u9kJ4TeLvjT5STWzKgh
        JwdJuf6ZyMdgYq3BlFo1cjdTTsaDxzbnEhsX6f4kFkqCb5F2kXmWT+d02TYv8vGzLzn3OuPPvFz05
        euU2PhPA1MsdnyG7/1nULM/rmfE6P05SIzOuX7te0snM7apPxN9SeZaN6wsBVbWT4SToHKYlp+Y6y
        YStPU+T41v/E6t8AtAKkX2b9TZ/RlMoFwsAQ36hnJF5BwGPmpLYsu8p9GXJvKtC7PpQWRPLU7e/y1
        uOten5YrA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:55748)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hPCgZ-0007uW-EE; Fri, 10 May 2019 22:04:07 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hPCgX-0004lU-SF; Fri, 10 May 2019 22:04:05 +0100
Date:   Fri, 10 May 2019 22:04:05 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vicente Bergas <vicencb@gmail.com>
Cc:     Serge Semin <fancer.lancer@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: net: phy: realtek: regression, kernel null pointer dereference
Message-ID: <20190510210405.tehgan2s5rhimihc@shell.armlinux.org.uk>
References: <16f75ff4-e3e3-4d96-b084-e772e3ce1c2b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <16f75ff4-e3e3-4d96-b084-e772e3ce1c2b@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 10, 2019 at 05:05:13PM +0200, Vicente Bergas wrote:
> Hello,
> there is a regression on linux v5.1-9573-gb970afcfcabd with a kernel null
> pointer dereference.
> The issue is the commit f81dadbcf7fd067baf184b63c179fc392bdb226e
>  net: phy: realtek: Add rtl8211e rx/tx delays config
> which uncovered a bug in phy-core when attempting to call
>  phydev->drv->read_page
> which can be null.
> The patch to drivers/net/phy/phy-core.c below fixes the kernel null pointer
> dereference. After applying the patch, there is still no network. I have
> also tested the patch to drivers/net/phy/realtek.c, but no success. The
> system hangs forever while initializing eth0.

You're not supposed to call these functions unless you provide the page
read/write page functions.  The fact that this code has crept in shows
that the patch adding the call to phy_select_page() in the realtek
driver was patently never tested, which, IMHO is bad software
engineering practice.  No, it's not even engineering practice, it's
an untested hack.

I don't see any point in adding run-time checks - that will only add
additional code, and we lose the backtrace.  The resulting oops from
trying to use these will give a backtrace and show exactly where the
problem is, including which driver is at fault.

The answer is... fix the driver to provide the required functions
before attempting to use an interface that requires said functions!

> 
> Any suggestions?
> 
> Regards,
>  Vicenç.
> 
> --- a/drivers/net/phy/phy-core.c
> +++ b/drivers/net/phy/phy-core.c
> @@ -648,11 +648,17 @@
> 
> static int __phy_read_page(struct phy_device *phydev)
> {
> +	if (!phydev->drv->read_page)
> +		return -EOPNOTSUPP;
> +	
> 	return phydev->drv->read_page(phydev);
> }
> 
> static int __phy_write_page(struct phy_device *phydev, int page)
> {
> +	if (!phydev->drv->write_page)
> +		return -EOPNOTSUPP;
> +
> 	return phydev->drv->write_page(phydev, page);
> }
> --- a/drivers/net/phy/realtek.c
> +++ b/drivers/net/phy/realtek.c
> @@ -214,8 +214,10 @@
> 	 * for details).
> 	 */
> 	oldpage = phy_select_page(phydev, 0x7);
> -	if (oldpage < 0)
> -		goto err_restore_page;
> +	if (oldpage < 0) {
> +		dev_warn(&phydev->mdio.dev, "Unable to set rgmii delays\n");
> +		return 0;
> +	}
> 
> 	ret = phy_write(phydev, RTL821x_EXT_PAGE_SELECT, 0xa4);
> 	if (ret)
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
