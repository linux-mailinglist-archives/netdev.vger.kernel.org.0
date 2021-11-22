Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 343B145909E
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 15:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239820AbhKVO5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 09:57:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238762AbhKVO5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 09:57:35 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAEEEC061574;
        Mon, 22 Nov 2021 06:54:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=O+eh7K1k2QSvOZZ7TCMe4K+QTFxIpsBZGSPwLICIa1Q=; b=R3xtDXjkZPOQSoZAd5+WJiAFGN
        xZv9sKaw+4RBL8RfQDjowl3hozDzZWRNfenOM22ydshHq3EWIZTOlwEt+PmD7QspMpQ2fSwYzbUls
        jGU5H7sAbaPtT9acjqhVe4I4G9UQHblMH1QOcmi+oXFQ9gf2mXu14gPOqh54UjWVbjPasfcy2lDYj
        xzHrzL0n6/7/qRV/FLUvCfNz0wHVZaC411OypbJVIEa84hRBIHGTSx1L8up1etvZFTAaQ/wP274vD
        jXup151jRJASYvapQ+EqY4KDT6rQ4erZHqnVBsjDxnwHbK9jSoeTnNg+2go5s8/L7KraYpUSybETB
        JSCqWdcg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55788)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mpAi2-0006nF-71; Mon, 22 Nov 2021 14:54:18 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mpAhx-0007m3-CQ; Mon, 22 Nov 2021 14:54:13 +0000
Date:   Mon, 22 Nov 2021 14:54:13 +0000
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
Subject: Re: [PATCH v1 2/2] net: mdio: fixup ethernet phy module auto-load
 function
Message-ID: <YZuvFVXuKFdwpFmY@shell.armlinux.org.uk>
References: <1637583298-20321-1-git-send-email-zhuyinbo@loongson.cn>
 <1637583298-20321-2-git-send-email-zhuyinbo@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1637583298-20321-2-git-send-email-zhuyinbo@loongson.cn>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 22, 2021 at 08:14:58PM +0800, Yinbo Zhu wrote:
> the phy_id is only phy identifier, that phy module auto-load function
> should according the phy_id event rather than other information, this
> patch is remove other unnecessary information and add phy_id event in
> mdio_uevent function and ethernet phy module auto-load function will
> work well.
> 
> Signed-off-by: Yinbo Zhu <zhuyinbo@loongson.cn>
> ---
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

The MDIO bus contains more than just PHYs. This completely breaks
anything that isn't a PHY device - likely by performing an
out-of-bounds access.

This change also _totally_ breaks any MDIO devices that rely on
matching via the "of:" mechanism using the compatible specified in
DT. An example of that is the B53 DSA switch.

Sorry, but we've already learnt this lesson from a similar case with
SPI. Once one particular way of dealing with MODALIAS has been
established for auto-loading modules for a subsystem, it is very
difficult to change it without causing regressions.

We need a very clear description of the problem that these patches are
attempting to address, and then we need to see that effort has been
put in to verify that changing the auto-loading mechanism is safe to
do - such as auditing every single driver that use the MDIO subsystem.

>  
>  	return 0;
>  }
> @@ -991,7 +991,7 @@ static int mdio_uevent(struct device *dev, struct kobj_uevent_env *env)
>  };
>  
>  struct bus_type mdio_bus_type = {
> -	.name		= "mdio_bus",
> +	.name		= "mdio",

This looks like an unrelated user-interface breaking change. This
changes the path of all MDIO devices and drivers in /sys/bus/mdio_bus/*

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
