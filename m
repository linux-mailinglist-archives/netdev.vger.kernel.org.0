Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71364683AB
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 10:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384521AbhLDJmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 04:42:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384511AbhLDJmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 04:42:11 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11FDC061751;
        Sat,  4 Dec 2021 01:38:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rYta9gPwuaVvMDMj1SLe7iAQbRnQu1U6Lp/ngUwMtJU=; b=uU1yR8SjvptWkMxfjLOVVkRM+b
        p/FRdejrX42VNZl5uqo3HG+U2BsZ5DiJnrLcwTZv3lShRLai1yw73PiT13m1BMUrhTexAt1PZHYer
        3Lje0RFAb0IwOOkEckbX4vMmc3rXu2arr9AcIcbJcVrd9Uy129ivqAQK30+PaaHLDvnhPbGrnIS7K
        nl65DBIcxFvj6MA7Drivm9+iik9cZr7mCtdzfrh+0JQ8YswpAToohKNcCP0CDHsACLPlYBqaznjwg
        ifMjoczMhnFeFhey5ZFLUlyiIesJzt/+g0FYXpouTx1hytlslB4ZDxspZlCQdoBroE31j64N0S7L6
        x4QaVtSQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56048)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mtRV9-0003C4-FX; Sat, 04 Dec 2021 09:38:39 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mtRV8-0002IW-Md; Sat, 04 Dec 2021 09:38:38 +0000
Date:   Sat, 4 Dec 2021 09:38:38 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Yinbo Zhu <zhuyinbo@loongson.cn>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v4 2/2] net: mdio: rework mdio_uevent for mdio ethernet
 phy device
Message-ID: <Yas3HpT59X4dnXCg@shell.armlinux.org.uk>
References: <1638609208-10339-1-git-send-email-zhuyinbo@loongson.cn>
 <1638609208-10339-2-git-send-email-zhuyinbo@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1638609208-10339-2-git-send-email-zhuyinbo@loongson.cn>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 04, 2021 at 05:13:28PM +0800, Yinbo Zhu wrote:
> The of_device_uevent_modalias is service for 'of' type platform driver
> , which ask the first args must be 'of' that use MODULE_DEVICE_TABLE
> when driver was exported, but ethernet phy is a kind of 'mdio' type
> device and it is inappropriate if driver use 'of' type for exporting,
> in fact, most mainstream ethernet phy driver hasn't used 'of' type,
> even though phy driver was exported use 'of' type and it's irrelevant
> with mdio_uevent, at this time, platform_uevent was responsible for
> reporting uevent to match modules.alias configure, so, whatever that
> of_device_uevent_modalias was unnecessary, this patch was to remove it
> and add phy_id as modio uevent then ethernet phy module auto load
> function will work well.
> 
> Signed-off-by: Yinbo Zhu <zhuyinbo@loongson.cn>

NAK.

> ---
> 
>  drivers/net/phy/mdio_bus.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 6865d93..999f0d4 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -962,12 +962,12 @@ static int mdio_bus_match(struct device *dev, struct device_driver *drv)
>  
>  static int mdio_uevent(struct device *dev, struct kobj_uevent_env *env)
>  {
> -	int rc;
> +	struct phy_device *pdev;
>  
> -	/* Some devices have extra OF data and an OF-style MODALIAS */
> -	rc = of_device_uevent_modalias(dev, env);
> -	if (rc != -ENODEV)
> -		return rc;
> +	pdev = to_phy_device(dev);
> +
> +	if (add_uevent_var(env, "MODALIAS=mdio:p%08X", pdev->phy_id))
> +		return -ENOMEM;
>  
>  	return 0;
>  }
> @@ -991,7 +991,7 @@ static int mdio_uevent(struct device *dev, struct kobj_uevent_env *env)
>  };
>  
>  struct bus_type mdio_bus_type = {
> -	.name		= "mdio_bus",
> +	.name		= "mdio",
>  	.dev_groups	= mdio_bus_dev_groups,
>  	.match		= mdio_bus_match,
>  	.uevent		= mdio_uevent,
> -- 
> 1.8.3.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
