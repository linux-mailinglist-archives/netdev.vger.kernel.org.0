Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFEF0192A53
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 14:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbgCYNrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 09:47:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56762 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727290AbgCYNrM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 09:47:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Xy9ijAeZC1TBNVnSL1C1IqksdC1Gq8uxjKtL04YwZyM=; b=c7gtu8qQgkLg4ffuTFKuRx6iwn
        JGSeHq3F/iqibtQqfHmx9QxRgEOPLeSCyW2stN75gNR5U7m28QAh3kdziuhtZxDP3eJb5ZcfOLdjk
        KbppXpCRoySWPwTicC7CLjmF1JWMkea+D342RnaJgYPRavizRrRt+2Mj1FL8Fag9hPQE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jH6N5-0004R9-Ps; Wed, 25 Mar 2020 14:47:03 +0100
Date:   Wed, 25 Mar 2020 14:47:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, o.rempel@pengutronix.de,
        Florian Fainelli <f.fainelli@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
Subject: Re: [RFC][PATCH 2/2] net: phy: tja11xx: Add BroadRReach Master/Slave
 support into TJA11xx PHY driver
Message-ID: <20200325134703.GE3819@lunn.ch>
References: <20200325101736.2100-1-marex@denx.de>
 <20200325101736.2100-2-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325101736.2100-2-marex@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int tja11xx_get_tunable(struct phy_device *phydev,
> +			       struct ethtool_tunable *tuna, void *data)
> +{
> +	u8 *mode = (u8 *)data;
> +	int ret;
> +
> +	switch (tuna->id) {
> +	case ETHTOOL_PHY_BRR_MODE:
> +		ret = phy_read(phydev, MII_CFG1);
> +		if (ret < 0)
> +			return ret;
> +		*mode = !!(ret & MII_CFG1_MASTER_SLAVE);

It is not so easy to see if master is 1 or 0?


> +		return 0;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +
> +static int tja11xx_set_tunable(struct phy_device *phydev,
> +			       struct ethtool_tunable *tuna, const void *data)
> +{
> +	u8 mode = *(u8 *)data;
> +	int ret;
> +
> +	switch (tuna->id) {
> +	case ETHTOOL_PHY_BRR_MODE:
> +		ret = tja11xx_disable_link_control(phydev);
> +		if (ret)
> +			return ret;
> +
> +		ret = phy_modify(phydev, MII_CFG1, MII_CFG1_MASTER_SLAVE,
> +				 mode ? MII_CFG1_MASTER_SLAVE : 0);

And if the user passes 42?

    Andrew
