Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1B1F81F42
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 16:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbfHEOjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 10:39:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34282 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728149AbfHEOjk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 10:39:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IeOH3oshZOnypMVGQWFImyX6LwfvJFmlGyYwHKRWVis=; b=y/H1IuHAz2xH6KAAg1Db/wvVdi
        BAYlOx98HBwt+ZcC0Pn3prgmOGYmYL41y3nFd5ojKT4qn2r3NztcuRW1Hy/IdD4kQ8buaIDCKvjDp
        11lD45o3yzKb1AB1mDmcVo/9Vy7deVYgmTbIO2oOgDJawDHlUyZodnE9TH8Fbz7wM934=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hue99-0007XJ-Vw; Mon, 05 Aug 2019 16:39:35 +0200
Date:   Mon, 5 Aug 2019 16:39:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH 05/16] net: phy: adin: configure RGMII/RMII/MII modes on
 config
Message-ID: <20190805143935.GM24275@lunn.ch>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
 <20190805165453.3989-6-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805165453.3989-6-alexandru.ardelean@analog.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 05, 2019 at 07:54:42PM +0300, Alexandru Ardelean wrote:
> The ADIN1300 chip supports RGMII, RMII & MII modes. Default (if
> unconfigured) is RGMII.
> This change adds support for configuring these modes via the device
> registers.
> 
> For RGMII with internal delays (modes RGMII_ID,RGMII_TXID, RGMII_RXID),

It would be nice to add the missing space.

> the default delay is 2 ns. This can be configurable and will be done in
> a subsequent change.
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
> ---
>  drivers/net/phy/adin.c | 79 +++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 78 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
> index 3dd9fe50f4c8..dbdb8f60741c 100644
> --- a/drivers/net/phy/adin.c
> +++ b/drivers/net/phy/adin.c
> @@ -33,14 +33,91 @@
>  	 ADIN1300_INT_HW_IRQ_EN)
>  #define ADIN1300_INT_STATUS_REG			0x0019
>  
> +#define ADIN1300_GE_RGMII_CFG_REG		0xff23
> +#define   ADIN1300_GE_RGMII_RXID_EN		BIT(2)
> +#define   ADIN1300_GE_RGMII_TXID_EN		BIT(1)
> +#define   ADIN1300_GE_RGMII_EN			BIT(0)
> +
> +#define ADIN1300_GE_RMII_CFG_REG		0xff24
> +#define   ADIN1300_GE_RMII_EN			BIT(0)
> +
> +static int adin_config_rgmii_mode(struct phy_device *phydev,
> +				  phy_interface_t intf)
> +{
> +	int reg;
> +
> +	reg = phy_read_mmd(phydev, MDIO_MMD_VEND1, ADIN1300_GE_RGMII_CFG_REG);
> +	if (reg < 0)
> +		return reg;
> +
> +	if (!phy_interface_mode_is_rgmii(intf)) {
> +		reg &= ~ADIN1300_GE_RGMII_EN;
> +		goto write;
> +	}
> +
> +	reg |= ADIN1300_GE_RGMII_EN;
> +
> +	if (intf == PHY_INTERFACE_MODE_RGMII_ID ||
> +	    intf == PHY_INTERFACE_MODE_RGMII_RXID) {
> +		reg |= ADIN1300_GE_RGMII_RXID_EN;
> +	} else {
> +		reg &= ~ADIN1300_GE_RGMII_RXID_EN;
> +	}
> +
> +	if (intf == PHY_INTERFACE_MODE_RGMII_ID ||
> +	    intf == PHY_INTERFACE_MODE_RGMII_TXID) {
> +		reg |= ADIN1300_GE_RGMII_TXID_EN;
> +	} else {
> +		reg &= ~ADIN1300_GE_RGMII_TXID_EN;
> +	}

Nice. Often driver writers forget to clear the delay, they only set
it. Not so here.

However, is checkpatch happy with this? Each half of the if/else is a
single statement, so the {} are not needed.

> +
> +write:
> +	return phy_write_mmd(phydev, MDIO_MMD_VEND1,
> +			     ADIN1300_GE_RGMII_CFG_REG, reg);
> +}
> +
> +static int adin_config_rmii_mode(struct phy_device *phydev,
> +				 phy_interface_t intf)
> +{
> +	int reg;
> +
> +	reg = phy_read_mmd(phydev, MDIO_MMD_VEND1, ADIN1300_GE_RMII_CFG_REG);
> +	if (reg < 0)
> +		return reg;
> +
> +	if (intf != PHY_INTERFACE_MODE_RMII) {
> +		reg &= ~ADIN1300_GE_RMII_EN;
> +		goto write;

goto? Really?

> +	}
> +
> +	reg |= ADIN1300_GE_RMII_EN;
> +
> +write:
> +	return phy_write_mmd(phydev, MDIO_MMD_VEND1,
> +			     ADIN1300_GE_RMII_CFG_REG, reg);
> +}
> +
>  static int adin_config_init(struct phy_device *phydev)
>  {
> -	int rc;
> +	phy_interface_t interface, rc;

genphy_config_init() does not return a phy_interface_t!

>  
>  	rc = genphy_config_init(phydev);
>  	if (rc < 0)
>  		return rc;
>  
> +	interface = phydev->interface;
> +
> +	rc = adin_config_rgmii_mode(phydev, interface);
> +	if (rc < 0)
> +		return rc;
> +
> +	rc = adin_config_rmii_mode(phydev, interface);
> +	if (rc < 0)
> +		return rc;
> +
> +	dev_info(&phydev->mdio.dev, "PHY is using mode '%s'\n",
> +		 phy_modes(phydev->interface));

phydev_dbg(), or not at all.

	      Andrew
