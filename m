Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41A5B8A09B
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 16:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbfHLOT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 10:19:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53488 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727206AbfHLOT6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 10:19:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=v50gXxy0UcfFeBrMZIy3FtqZqPifqcZZR2bgm2dAuIo=; b=h84BwQy1LrMNOO8yJaW9C+VNJq
        KW/ljM91Z/GUyUKeTsx34crAiF9KEsrEPyaKJle9NHlpZm1iDOJsHP5P/dWNLrJ3n0eMfUUK2x6qN
        vMSILa+zvZAHUw3WsbeBLofilTAVSkd+XdemD5bcSXhd0/MpBPwZmzH0a9G7dCub3Vd4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hxBAw-0000mk-AP; Mon, 12 Aug 2019 16:19:54 +0200
Date:   Mon, 12 Aug 2019 16:19:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH v4 10/14] net: phy: adin: implement PHY subsystem
 software reset
Message-ID: <20190812141954.GP14290@lunn.ch>
References: <20190812112350.15242-1-alexandru.ardelean@analog.com>
 <20190812112350.15242-11-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812112350.15242-11-alexandru.ardelean@analog.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int adin_reset(struct phy_device *phydev)
> +{
> +	/* If there is a reset GPIO just exit */
> +	if (!IS_ERR_OR_NULL(phydev->mdio.reset_gpio))
> +		return 0;

I'm not so happy with this.

First off, there are two possible GPIO configurations. The GPIO can be
applied to all PHYs on the MDIO bus. That GPIO is used when the bus is
probed. There can also be a per PHY GPIO, which is what you are
looking at here.

The idea of putting the GPIO handling in the core is that PHYs don't
need to worry about it. How much of a difference does it make if the
PHY is both reset via GPIO and then again in software? How slow is the
software reset? Maybe just unconditionally do the reset, if it is not
too slow.

> +
> +	/* Reset PHY core regs & subsystem regs */
> +	return adin_subsytem_soft_reset(phydev);
> +}
> +
> +static int adin_probe(struct phy_device *phydev)
> +{
> +	return adin_reset(phydev);
> +}

Why did you decide to do this as part of probe, and not use the
.soft_reset member of phy_driver?

> +
>  static struct phy_driver adin_driver[] = {
>  	{
>  		PHY_ID_MATCH_MODEL(PHY_ID_ADIN1200),
>  		.name		= "ADIN1200",
>  		.config_init	= adin_config_init,
> +		.probe		= adin_probe,
>  		.config_aneg	= adin_config_aneg,
>  		.read_status	= adin_read_status,
>  		.ack_interrupt	= adin_phy_ack_intr,
> @@ -461,6 +503,7 @@ static struct phy_driver adin_driver[] = {
>  		PHY_ID_MATCH_MODEL(PHY_ID_ADIN1300),
>  		.name		= "ADIN1300",
>  		.config_init	= adin_config_init,
> +		.probe		= adin_probe,
>  		.config_aneg	= adin_config_aneg,
>  		.read_status	= adin_read_status,
>  		.ack_interrupt	= adin_phy_ack_intr,

Thanks
	Andrew
