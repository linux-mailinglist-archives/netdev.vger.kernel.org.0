Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67F79391B36
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 17:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235338AbhEZPJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 11:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235231AbhEZPJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 11:09:53 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C47C061574;
        Wed, 26 May 2021 08:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=R5DSP4P68NVFJPwCNj7TWIfvCQyPmEbZmwvD6kco0WM=; b=I4pIsuqJ0nMwqR3gNCg/Qpspa
        XoLGgubaLLmi2F+a31BQ9jXkb6pNZE71kZmUDE2ckU/A77fXy0dzDic30OepyaRn21WlTVCyQaPzR
        JEd2N7HXEjPZkGq2NzXry2/cDrIGZX+8NJCqS35RTgChnbDMz1zH+oqF72stRD7UD4e32ccg9qMyY
        CGj0ytW/Ai+OTP/PrEvEoJh8NwWJ85Qi+/1/0QlOUg+0jLT7DVUn9SdqT+MQhT1hIGksxOv5HGNtH
        bClVr1Iv4K2+qaV3+JmSmM/+8QHfcODiLhIshutE19TCc+nRqI84ZKXDObsULhIaeYAZnYOqnbZ0z
        KgqnhZhwg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44376)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1llv8n-0005oS-IY; Wed, 26 May 2021 16:08:13 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1llv8l-0002tF-V9; Wed, 26 May 2021 16:08:11 +0100
Date:   Wed, 26 May 2021 16:08:11 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: Re: [PATCH net-next v3 8/9] net: dsa: dsa_slave_phy_connect():
 extend phy's flags with port specific phy flags
Message-ID: <20210526150811.GF30436@shell.armlinux.org.uk>
References: <20210526043037.9830-1-o.rempel@pengutronix.de>
 <20210526043037.9830-9-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526043037.9830-9-o.rempel@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 06:30:36AM +0200, Oleksij Rempel wrote:
> This patch extends the flags of the phy that's being connected with the
> port specific flags of the switch port.
> 
> This is needed to handle a port specific erratum of the KSZ8873 switch,
> which is added in a later patch.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/phy/phylink.c | 2 +-
>  net/dsa/slave.c           | 4 ++++
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 96d8e88b4e46..167c2277814f 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -1029,7 +1029,7 @@ static int phylink_attach_phy(struct phylink *pl, struct phy_device *phy,
>  	if (pl->phydev)
>  		return -EBUSY;
>  
> -	return phy_attach_direct(pl->netdev, phy, 0, interface);
> +	return phy_attach_direct(pl->netdev, phy, phy->dev_flags, interface);

I don't think this has any benefit. phy_attach_direct() does this
internally:

        phydev->dev_flags |= flags;

which means the above change is effectively doing:

        phydev->dev_flags |= phydev->dev_flags;

So, are you sure you need this?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
