Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4E43615BF
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 00:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235922AbhDOW5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 18:57:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54402 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234949AbhDOW5A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 18:57:00 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lXAuQ-00GyOH-LW; Fri, 16 Apr 2021 00:56:26 +0200
Date:   Fri, 16 Apr 2021 00:56:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] phy: nxp-c45: add driver for tja1103
Message-ID: <YHjEmtWjhhH6412w@lunn.ch>
References: <20210415092538.78398-1-radu-nicolae.pirea@oss.nxp.com>
 <20210415092538.78398-3-radu-nicolae.pirea@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415092538.78398-3-radu-nicolae.pirea@oss.nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +config NXP_C45_TJA11XX_PHY
> +	tristate "NXP C45 TJA11XX PHYs"
> +	help
> +	  Enable support for NXP C45 TJA11XX PHYs.
> +	  Currently supports only the TJA1103 PHY.

> +#define PHY_ID_BASE_T1			0x001BB010

It would be better to use PHY_ID_TJA_1103 here.

> +
> +#define PMAPMD_B100T1_PMAPMD_CTL		0x0834
> +#define B100T1_PMAPMD_CONFIG_EN		BIT(15)
> +#define B100T1_PMAPMD_MASTER		BIT(14)
> +#define MASTER_MODE			(B100T1_PMAPMD_CONFIG_EN | \
> +	B100T1_PMAPMD_MASTER)

You would normally align this with the B100T1_PMAPMD_CONFIG_EN

> +static int nxp_c45_reset_done(struct phy_device *phydev)
> +{
> +	return !(phy_read_mmd(phydev, MDIO_MMD_VEND1, VEND1_DEVICE_CONTROL) &
> +		DEVICE_CONTROL_RESET);
> +}
> +
> +static int nxp_c45_reset_done_or_timeout(struct phy_device *phydev,
> +					 ktime_t timeout)
> +{
> +	ktime_t cur = ktime_get();
> +
> +	return nxp_c45_reset_done(phydev) || ktime_after(cur, timeout);
> +}
> +
> +static int nxp_c45_soft_reset(struct phy_device *phydev)
> +{
> +	ktime_t timeout;
> +	int ret;
> +
> +	ret = phy_write_mmd(phydev, MDIO_MMD_VEND1, VEND1_DEVICE_CONTROL,
> +			    DEVICE_CONTROL_RESET);
> +	if (ret)
> +		return ret;
> +
> +	timeout = ktime_add_ns(ktime_get(), RESET_POLL_NS);
> +	spin_until_cond(nxp_c45_reset_done_or_timeout(phydev, timeout));

phy_read_mmd_poll_timeout() i think does what you need.

> +	if (!nxp_c45_reset_done(phydev)) {
> +		phydev_err(phydev, "reset fail\n");
> +		return -EIO;
> +	}
> +	return 0;
> +}

> +static struct phy_driver nxp_c45_driver[] = {
> +	{
> +		PHY_ID_MATCH_MODEL(PHY_ID_BASE_T1),
> +		.name			= "NXP C45 BASE-T1",

"NXP C45 TJA1103"

     Andrew
