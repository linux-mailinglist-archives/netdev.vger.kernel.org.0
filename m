Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F828373B76
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 14:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233528AbhEEMik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 08:38:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54376 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233111AbhEEMig (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 08:38:36 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1leGmV-002fjT-5R; Wed, 05 May 2021 14:37:35 +0200
Date:   Wed, 5 May 2021 14:37:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: Re: [RFC PATCH v1 5/9] net: phy: micrel: ksz886x add MDI-X support
Message-ID: <YJKRj2tD0rPd+S0j@lunn.ch>
References: <20210505092025.8785-1-o.rempel@pengutronix.de>
 <20210505092025.8785-6-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210505092025.8785-6-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/* Device specific MII_BMCR (Reg 0) bits */
> +/* 1 = HP Auto MDI/MDI-X mode, 0 = Microchip Auto MDI/MDI-X mode */
> +#define KSZ886X_BMCR_HP_MDIX			BIT(5)
> +/* 1 = Force MDI (transmit on RXP/RXM pins), 0 = Normal operation
> + * (transmit on TXP/TXM pins)
> + */
> +#define KSZ886X_BMCR_FORCE_MDI			BIT(4)
> +/* 1 = Disable auto MDI-X */
> +#define KSZ886X_BMCR_DISABLE_AUTO_MDIX		BIT(3)
> +#define KSZ886X_BMCR_DISABLE_FAR_END_FAULT	BIT(2)
> +#define KSZ886X_BMCR_DISABLE_TRANSMIT		BIT(1)
> +#define KSZ886X_BMCR_DISABLE_LED		BIT(0)

Do these have the same values as what you added in patch 1?

> +static int ksz886x_config_mdix(struct phy_device *phydev, u8 ctrl)
> +{
> +	u16 val;
> +
> +	switch (ctrl) {
> +	case ETH_TP_MDI:
> +		val = KSZ886X_BMCR_DISABLE_AUTO_MDIX;
> +		break;
> +	case ETH_TP_MDI_X:
> +		/* Note: The naming of the bit KSZ886X_BMCR_FORCE_MDI is bit
> +		 * counter intuitive, the "-X" in "1 = Force MDI" in the data
> +		 * sheet seems to be missing:
> +		 * 1 = Force MDI (sic!) (transmit on RX+/RX- pins)
> +		 * 0 = Normal operation (transmit on TX+/TX- pins)
> +		 */
> +		val = KSZ886X_BMCR_DISABLE_AUTO_MDIX | KSZ886X_BMCR_FORCE_MDI;
> +		break;
> +	case ETH_TP_MDI_AUTO:
> +		val = 0;
> +		break;
> +	default:
> +		return 0;
> +	}
> +
> +	return phy_modify(phydev, MII_BMCR,
> +			  KSZ886X_BMCR_HP_MDIX | KSZ886X_BMCR_FORCE_MDI |
> +			  KSZ886X_BMCR_DISABLE_AUTO_MDIX,
> +			  KSZ886X_BMCR_HP_MDIX | val);
> +}

Maybe this will also work for the PHY driver embedded in ksz8795.c?
Maybe as another patchset, see if that PHY driver can be moved out of the DSA driver,
and share some code with this driver?

    Andrew
