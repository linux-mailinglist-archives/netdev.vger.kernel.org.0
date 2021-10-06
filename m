Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F22A5424AD2
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 02:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239910AbhJGABx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 20:01:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53202 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239804AbhJGABw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 20:01:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Ihk2ty3BanjwiwUbGEJINfKjquqiWkL8fBMQf4vtyXM=; b=bRTUki9mrg+t4kUYQjhAP2shY6
        hemhyZBekcomrzjiztSwzsCt/hnDrFe7vRnU9vd7fnKitRHh0AOHTu5FTU0tw8NjN23ezILQJOFNH
        cilO2AubEpaS5LjwmlzUdNT5Pz0VaKknG5/1SJKWsjwcZP5ROfAlafZ7ODUXbr0Yhuhs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mYGpH-009t9G-NK; Thu, 07 Oct 2021 01:59:55 +0200
Date:   Thu, 7 Oct 2021 01:59:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 02/13] drivers: net: phy: at803x: add DAC
 amplitude fix for 8327 phy
Message-ID: <YV44ex0Vh6qtHbOs@lunn.ch>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
 <20211006223603.18858-3-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006223603.18858-3-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 12:35:52AM +0200, Ansuel Smith wrote:
> QCA8327 internal phy require DAC amplitude adjustement set to +6% with
> 100m speed. Also add additional define to report a change of the same
> reg in QCA8337. (different scope it does set 1000m voltage)
> Add link_change_notify function to set the proper amplitude adjustement
> on PHY_RUNNING state and disable on any other state.
> 
> Fixes: c6bcec0d6928 ("net: phy: at803x: add support for qca 8327 A variant internal phy")
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

Since this is a fix, you might want to send it on its own, based on
net.

> +	/* QCA8327 require DAC amplitude adjustment for 100m set to +6%.
> +	 * Disable on init and enable only with 100m speed following
> +	 * qca original source code.
> +	 */
> +	if (phydev->drv->phy_id == QCA8327_A_PHY_ID ||
> +	    phydev->drv->phy_id == QCA8327_B_PHY_ID)
> +		at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_0,
> +				      QCA8327_DEBUG_MANU_CTRL_EN, 0);
> +
>  	return 0;
>  }
>  
> +static void qca83xx_link_change_notify(struct phy_device *phydev)
> +{
> +	/* QCA8337 doesn't require DAC Amplitude adjustement */
> +	if (phydev->drv->phy_id == QCA8337_PHY_ID)
> +		return;
> +
> +	/* Set DAC Amplitude adjustment to +6% for 100m on link running */
> +	if (phydev->state == PHY_RUNNING) {
> +		if (phydev->speed == SPEED_100)
> +			at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_0,
> +					      QCA8327_DEBUG_MANU_CTRL_EN,
> +					      QCA8327_DEBUG_MANU_CTRL_EN);
> +	} else {
> +		/* Reset DAC Amplitude adjustment */
> +		at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_0,
> +				      QCA8327_DEBUG_MANU_CTRL_EN, 0);

Here you don't make it conditional on QCA8327_A_PHY_ID and
QCA8327_B_PHY_ID, where as above you do?

	  Andrew
