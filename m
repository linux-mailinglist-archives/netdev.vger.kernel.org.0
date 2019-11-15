Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55A1CFE629
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 21:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfKOUHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 15:07:11 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:50112 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfKOUHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 15:07:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=t6f58uo+OEeNsGkjsmDMIH//OwLjRL4Rk8bvVLw59Dg=; b=f1TwzQlzh7cy6VYeGw79BltXA
        ZRW2KD8bLN8eYSKNuAgyDEU9+UHYT1Bpmhh9HVIQXTl5w7BCDSK3s4lgHsSbSkeY4BptF1dxmramK
        zPTTa+uhxVFCRFvr6P+6LGljrcShgz/E6E76AksmLcv5VNM/J/j6P1rfdZLsejm2nHT6/ZNMW1JZT
        K28Zc8c/HF5MqlkmaegtmOj8MKCVyZdd/JAWW1kT2AAWeexs/LNRuyO3nLpgiuqQ4t7x+mfr54CCj
        Ir90DrjV6W39RlpEPGrX0PpMn6dAqxAqZLvj2wXiM8xp4mfN9wqUwXW980tmKnFSOzraMdHJDYfC3
        s5GKv+QtA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:56666)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iVhs1-0003AX-DX; Fri, 15 Nov 2019 20:07:05 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iVhrz-0004lf-So; Fri, 15 Nov 2019 20:07:03 +0000
Date:   Fri, 15 Nov 2019 20:07:03 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: phylink: update to use phy_support_asym_pause()
Message-ID: <20191115200703.GS25745@shell.armlinux.org.uk>
References: <E1iVhqj-0007eY-8u@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1iVhqj-0007eY-8u@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Forgetting the net-next tag again...

On Fri, Nov 15, 2019 at 08:05:45PM +0000, Russell King wrote:
> Use phy_support_asym_pause() rather than open-coding it.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/phy/phylink.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 2b70b4d50573..a68d664b65a3 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -697,11 +697,6 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy)
>  	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported);
>  	int ret;
>  
> -	memset(&config, 0, sizeof(config));
> -	linkmode_copy(supported, phy->supported);
> -	linkmode_copy(config.advertising, phy->advertising);
> -	config.interface = pl->link_config.interface;
> -
>  	/*
>  	 * This is the new way of dealing with flow control for PHYs,
>  	 * as described by Timur Tabi in commit 529ed1275263 ("net: phy:
> @@ -709,10 +704,12 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy)
>  	 * using our validate call to the MAC, we rely upon the MAC
>  	 * clearing the bits from both supported and advertising fields.
>  	 */
> -	if (phylink_test(supported, Pause))
> -		phylink_set(config.advertising, Pause);
> -	if (phylink_test(supported, Asym_Pause))
> -		phylink_set(config.advertising, Asym_Pause);
> +	phy_support_asym_pause(phy);
> +
> +	memset(&config, 0, sizeof(config));
> +	linkmode_copy(supported, phy->supported);
> +	linkmode_copy(config.advertising, phy->advertising);
> +	config.interface = pl->link_config.interface;
>  
>  	ret = phylink_validate(pl, supported, &config);
>  	if (ret)
> -- 
> 2.20.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
