Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAF028E15D
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 15:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731242AbgJNNc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 09:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727250AbgJNNc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 09:32:26 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B10C061755;
        Wed, 14 Oct 2020 06:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=DAaR/g+SZ77eRfaSNW9IZ4TKiMIYWLTNCWvTePQlXgY=; b=dGcQlukx5RXHlkIQhJCVLsd0+
        GmMbPhSv8/W49wWaiL54UovC/Hj4LjuDFtn77x4WVqSNqgyraelKjmLdxI5DVAgk0O0k+lBBQOigt
        fulxD9K3/vdhm5+8VUTEYZqCF7l0WcDtSO1pX76dVPkjbclNVLkXVdWNBoRUIER3ti0YEAm7j2eI5
        Z37a1JRqQcrIFi/sUnZbu3K2pqoF2rfb7DGPBV8YP1r2f//p9ztJa7B67cY6HxkV03M97uDoKaTOF
        cqc0sV4RiunnG5SxbR6g9iBhAiL3Y7ycfC4jDqzAIDeAFkd+epjEsLFAjc3XvclxQ954czY1ABZjB
        HCJYIZZBg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45908)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kSgt5-00079u-3W; Wed, 14 Oct 2020 14:32:15 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kSgt1-0007dw-DJ; Wed, 14 Oct 2020 14:32:11 +0100
Date:   Wed, 14 Oct 2020 14:32:11 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] net: phy: Prevent reporting advertised modes when
 autoneg is off
Message-ID: <20201014133211.GQ1551@shell.armlinux.org.uk>
References: <CGME20201014125655eucas1p129ba3322a72b17a19a533e7a2890ff88@eucas1p1.samsung.com>
 <20201014125650.12137-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201014125650.12137-1-l.stelmach@samsung.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 14, 2020 at 02:56:50PM +0200, Łukasz Stelmach wrote:
> Do not report advertised link modes when autonegotiation is turned
> off. mii_ethtool_get_link_ksettings() exhibits the same behaviour.

Please explain why this is a desirable change.

Referring to some other piece of code isn't a particularly good reason
especially when that piece of code is likely derived from fairly old
code (presumably mii_ethtool_get_link_ksettings()'s behaviour is
designed to be compatible with mii_ethtool_gset()).

In any case, the mii.c code does fill in the advertising mask even when
autoneg is disabled, because, rightly or wrongly, the advertising mask
contains more than just the link modes, it includes the interface(s)
as well. Your change means phylib no longer reports the interface modes
which is at odds with the mii.c code.

> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
> ---
>  drivers/net/phy/phy.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index 35525a671400..3cadf224fdb2 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -315,7 +315,8 @@ void phy_ethtool_ksettings_get(struct phy_device *phydev,
>  			       struct ethtool_link_ksettings *cmd)
>  {
>  	linkmode_copy(cmd->link_modes.supported, phydev->supported);
> -	linkmode_copy(cmd->link_modes.advertising, phydev->advertising);
> +	if (phydev->autoneg)
> +		linkmode_copy(cmd->link_modes.advertising, phydev->advertising);
>  	linkmode_copy(cmd->link_modes.lp_advertising, phydev->lp_advertising);
>  
>  	cmd->base.speed = phydev->speed;
> -- 
> 2.26.2
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
