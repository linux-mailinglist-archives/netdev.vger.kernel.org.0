Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B48F3D3B03
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 15:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235161AbhGWMmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 08:42:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42336 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233037AbhGWMl4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 08:41:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=vHXNKEv7LkkV4lJkCF5sXM2xDe7Ke1gz3Z6CdP9WlUw=; b=tl
        0TqK87MEnAv9XxbGFqDdfFh1wMSPh6qZe2q5Lc6VfUcM8U+azFmXC2nXHhCf95+CGUIntSeZGM3Gw
        HpunGGx0AmK5QbhIz2o6rOmd+qC9awp8CpOLGsndrL8jfeILCKY54S7NhGyuPtTY6uRMxtVfL4dMw
        ALZn0KLOoVgp/Cs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m6v84-00EUqk-Ui; Fri, 23 Jul 2021 15:22:16 +0200
Date:   Fri, 23 Jul 2021 15:22:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Dan Murphy <dmurphy@ti.com>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v1 1/1] net: phy: dp83td510: Add basic support
 for the DP83TD510 Ethernet PHY
Message-ID: <YPrCiIz7baU26kLU@lunn.ch>
References: <20210723104218.25361-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210723104218.25361-1-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 12:42:18PM +0200, Oleksij Rempel wrote:
> The DP83TD510E is an ultra-low power Ethernet physical layer transceiver
> that supports 10M single pair cable.
> 
> This driver provides basic support for this chip:
> - link status
> - autoneg can be turned off
> - master/slave can be configured to be able to work without autoneg
> 
> This driver and PHY was tested with ASIX AX88772B USB Ethernet controller.

Hi Oleksij

There were patches flying around recently for another T1L PHY which
added new link modes. Please could you work together with that patch
to set the phydev features correctly to indicate this PHY is also a
T1L, and if it support 2.4v etc.

> +static int dp83td510_config_aneg(struct phy_device *phydev)
> +{
> +	u16 ctrl = 0, pmd_ctrl = 0;
> +	int ret;
> +
> +	switch (phydev->master_slave_set) {
> +	case MASTER_SLAVE_CFG_MASTER_FORCE:
> +		if (phydev->autoneg) {
> +			phydev->master_slave_set = MASTER_SLAVE_CFG_UNSUPPORTED;
> +			phydev_warn(phydev, "Can't force master mode if autoneg is enabled\n");
> +			goto do_aneg;
> +		}
> +		pmd_ctrl |= DP83TD510_PMD_CTRL_MASTER_MODE;
> +		break;
> +	case MASTER_SLAVE_CFG_SLAVE_FORCE:
> +		if (phydev->autoneg) {
> +			phydev->master_slave_set = MASTER_SLAVE_CFG_UNSUPPORTED;
> +			phydev_warn(phydev, "Can't force slave mode if autoneg is enabled\n");
> +			goto do_aneg;
> +		}
> +		break;
> +	case MASTER_SLAVE_CFG_MASTER_PREFERRED:
> +	case MASTER_SLAVE_CFG_SLAVE_PREFERRED:
> +		phydev->master_slave_set = MASTER_SLAVE_CFG_UNSUPPORTED;
> +		phydev_warn(phydev, "Preferred master/slave modes are not supported\n");
> +		goto do_aneg;
> +	case MASTER_SLAVE_CFG_UNKNOWN:
> +	case MASTER_SLAVE_CFG_UNSUPPORTED:
> +		goto do_aneg;
> +	default:
> +		phydev_warn(phydev, "Unsupported Master/Slave mode\n");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	ret = dp83td510_modify(phydev, DP83TD510_PMA_PMD_CTRL,
> +			       DP83TD510_PMD_CTRL_MASTER_MODE, pmd_ctrl);
> +	if (ret)
> +		return ret;
> +
> +do_aneg:
> +	if (phydev->autoneg)
> +		ctrl |= DP83TD510_AN_ENABLE;
> +
> +	ret = dp83td510_modify_changed(phydev, DP83TD510_AN_CONTROL,
> +				       DP83TD510_AN_ENABLE, ctrl);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Reset link if settings are changed */
> +	if (ret)
> +		ret = dp83td510_write(phydev, MII_BMCR, BMCR_RESET);
> +
> +	return ret;
> +}
> +
> +static int dp83td510_strap(struct phy_device *phydev)
> +{

> +	phydev_info(phydev,
> +		    "bootstrap cfg: Pin 18: %s, Pin 30: %s, TX Vpp: %s, RX trap: %s, xMII mode: %s, PHY addr: 0x%x\n",
> +		    pin18 ? "RX_DV" : "CRS_DV",
> +		    pin30 ? "LED_1" : "CLKOUT",
> +		    tx_vpp ? "1.0V p2p" : "2.4V & 1.0V p2p",
> +		    rx_trap ? "< 40Ω" : "50Ω",
> +		    dp83td510_get_xmii_mode_str(xmii_mode),
> +		    addr);

What i learned reviewing the other T1L driver is that 2.4v operation
seems to be something you negotiate. Yet i don't see anything about it
in dp83td510_config_aneg() ?

   Andrew
