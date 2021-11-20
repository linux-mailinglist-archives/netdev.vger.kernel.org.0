Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF45457ED7
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 16:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237219AbhKTPMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 10:12:25 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43648 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229794AbhKTPMZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Nov 2021 10:12:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=I7zCtQxD9zY1wsKBA0OZDazSLBiFkiHXbA3F2PRRZ4o=; b=2RbfFTChsZNnMXCQtQRyYrgkew
        tqXKuN0W7sjEDKya+MCzoats25BCUjOQRlRNWlwUdjMC2Bx/vauoTJWYCXSVnj2izCOZkO1AfW3MP
        ZKeEhKd4g84enA8fdaDhaiQIPQ8XKa3NERgCXiLhUg1g1AFy4rj/1IyQleEH6F8ZJRew=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1moRzS-00E9Vw-H5; Sat, 20 Nov 2021 16:09:18 +0100
Date:   Sat, 20 Nov 2021 16:09:18 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v1 net-next 1/3] net: mdio: mscc-miim: convert to a
 regmap implementation
Message-ID: <YZkPnida0Kd0sG8x@lunn.ch>
References: <20211119213918.2707530-1-colin.foster@in-advantage.com>
 <20211119213918.2707530-2-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119213918.2707530-2-colin.foster@in-advantage.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -73,22 +84,30 @@ static int mscc_miim_wait_pending(struct mii_bus *bus)
>  static int mscc_miim_read(struct mii_bus *bus, int mii_id, int regnum)
>  {
>  	struct mscc_miim_dev *miim = bus->priv;
> +	int ret, err;
>  	u32 val;
> -	int ret;
>  
>  	ret = mscc_miim_wait_pending(bus);
>  	if (ret)
>  		goto out;
>  
> -	writel(MSCC_MIIM_CMD_VLD | (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
> -	       (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) | MSCC_MIIM_CMD_OPR_READ,
> -	       miim->regs + MSCC_MIIM_REG_CMD);
> +	err = regmap_write(miim->regs, MSCC_MIIM_REG_CMD, MSCC_MIIM_CMD_VLD |
> +			   (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
> +			   (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
> +			   MSCC_MIIM_CMD_OPR_READ);
> +
> +	if (err < 0)
> +		WARN_ONCE(1, "mscc miim write cmd reg error %d\n", err);

You should probably return ret here. If the setup fails, i doubt you
will get anything useful from the hardware.

>  
>  	ret = mscc_miim_wait_ready(bus);
>  	if (ret)
>  		goto out;
>  
> -	val = readl(miim->regs + MSCC_MIIM_REG_DATA);
> +	err = regmap_read(miim->regs, MSCC_MIIM_REG_DATA, &val);
> +
> +	if (err < 0)
> +		WARN_ONCE(1, "mscc miim read data reg error %d\n", err);

Same here.

> +
>  	if (val & MSCC_MIIM_DATA_ERROR) {
>  		ret = -EIO;
>  		goto out;
> @@ -103,18 +122,20 @@ static int mscc_miim_write(struct mii_bus *bus, int mii_id,
>  			   int regnum, u16 value)
>  {
>  	struct mscc_miim_dev *miim = bus->priv;
> -	int ret;
> +	int err, ret;
>  
>  	ret = mscc_miim_wait_pending(bus);
>  	if (ret < 0)
>  		goto out;
>  
> -	writel(MSCC_MIIM_CMD_VLD | (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
> -	       (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
> -	       (value << MSCC_MIIM_CMD_WRDATA_SHIFT) |
> -	       MSCC_MIIM_CMD_OPR_WRITE,
> -	       miim->regs + MSCC_MIIM_REG_CMD);
> +	err = regmap_write(miim->regs, MSCC_MIIM_REG_CMD, MSCC_MIIM_CMD_VLD |
> +			   (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
> +			   (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
> +			   (value << MSCC_MIIM_CMD_WRDATA_SHIFT) |
> +			   MSCC_MIIM_CMD_OPR_WRITE);
>  
> +	if (err < 0)
> +		WARN_ONCE(1, "mscc miim write error %d\n", err);

And here, etc.

    Andrew
