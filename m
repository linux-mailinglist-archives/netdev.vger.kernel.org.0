Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39C234E25E
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 10:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbfFUIwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 04:52:23 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:38074 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbfFUIwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 04:52:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wJEfgdcwxyn0hB47BD9e9IQHK3vkjR82sMxeZtqQdDI=; b=dvWjgyvfVuRpdSQIxY4BMf7lS
        xWo4p4JbHukIXMlJl47tYGfg1kfDQ0Hzh4kpOws2oOQoqnMBkr9BPnqUP5IDBeY/FIkImHk2bQ+fF
        UqNZQIdEktkU0wabKBtZnEIs36dcpSeZoSZCbJV9id7flbEye3AW6xrxVMYktUB0cO/YCc8iPBnmr
        wOKbwl8sFyce22mo6X6TLfMnEucbK+X9y6JRLYkiu+GFZTfcA95djG79SVXaCTSZDGfssQVYxuBC6
        ZWt6lU1CxibdMgF8xfubJg0txk5b6TlsKNqFFwlKBix+llmYmqYo7tfHdjIuwBrSqvN0K3nYutkfK
        cDCc/6lMQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:58858)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1heFHK-00044z-Tw; Fri, 21 Jun 2019 09:52:15 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1heFHG-000389-Q4; Fri, 21 Jun 2019 09:52:10 +0100
Date:   Fri, 21 Jun 2019 09:52:10 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Parshuram Thombare <pthombar@cadence.com>
Cc:     andrew@lunn.ch, nicolas.ferre@microchip.com, davem@davemloft.net,
        f.fainelli@gmail.com, netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, rafalc@cadence.com,
        aniljoy@cadence.com, piotrs@cadence.com
Subject: Re: [PATCH v3 2/5] net: macb: add support for sgmii MAC-PHY interface
Message-ID: <20190621085210.qa272dzmypb3oe7l@shell.armlinux.org.uk>
References: <1561106037-6859-1-git-send-email-pthombar@cadence.com>
 <1561106090-8465-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1561106090-8465-1-git-send-email-pthombar@cadence.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 21, 2019 at 09:34:50AM +0100, Parshuram Thombare wrote:
> @@ -486,23 +503,54 @@ static void gem_mac_config(struct phylink_config *pl_config, unsigned int mode,
>  {
>  	struct net_device *netdev = to_net_dev(pl_config->dev);
>  	struct macb *bp = netdev_priv(netdev);
> +	bool change_interface = bp->phy_interface != state->interface;
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&bp->lock, flags);
>  
> +	if (change_interface) {
> +		if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII ||
> +		    bp->phy_interface == PHY_INTERFACE_MODE_1000BASEX ||
> +		    bp->phy_interface == PHY_INTERFACE_MODE_2500BASEX) {
> +			gem_writel(bp, NCFGR, ~GEM_BIT(SGMIIEN) &
> +				   ~GEM_BIT(PCSSEL) &
> +				   gem_readl(bp, NCFGR));
> +			gem_writel(bp, NCR, ~GEM_BIT(TWO_PT_FIVE_GIG) &
> +				   gem_readl(bp, NCR));
> +			gem_writel(bp, PCS_CTRL, gem_readl(bp, PCS_CTRL) |
> +				   GEM_BIT(PCS_CTRL_RST));
> +		}
> +		bp->phy_interface = state->interface;
> +	}
> +
>  	if (!phylink_autoneg_inband(mode) &&
>  	    (bp->speed != state->speed ||
> -	     bp->duplex != state->duplex)) {
> +	     bp->duplex != state->duplex ||
> +	     change_interface)) {
>  		u32 reg;
>  
>  		reg = macb_readl(bp, NCFGR);
>  		reg &= ~(MACB_BIT(SPD) | MACB_BIT(FD));
>  		if (macb_is_gem(bp))
>  			reg &= ~GEM_BIT(GBE);
> +		macb_or_gem_writel(bp, NCFGR, reg);
> +
> +		if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII ||
> +		    bp->phy_interface == PHY_INTERFACE_MODE_1000BASEX ||
> +		    bp->phy_interface == PHY_INTERFACE_MODE_2500BASEX)
> +			gem_writel(bp, NCFGR, GEM_BIT(SGMIIEN) |
> +				   GEM_BIT(PCSSEL) |
> +				   gem_readl(bp, NCFGR));

You don't appear to treat SGMII any differently from the 802.3z modes.
They are certainly not the same thing, so this doesn't seem to be
correct.  Also, placing this here, I don't see how the MAC gets
configured for SGMII if in-band mode is enabled.

> +
> +		reg = macb_readl(bp, NCFGR);
>  		if (state->duplex)
>  			reg |= MACB_BIT(FD);
>  
>  		switch (state->speed) {
> +		case SPEED_2500:
> +			gem_writel(bp, NCR, GEM_BIT(TWO_PT_FIVE_GIG) |
> +				   gem_readl(bp, NCR));
> +			break;
>  		case SPEED_1000:
>  			reg |= GEM_BIT(GBE);
>  			break;

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
