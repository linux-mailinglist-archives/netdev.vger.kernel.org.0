Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A92FC25B394
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 20:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbgIBSRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 14:17:08 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:37162 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727993AbgIBSRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 14:17:03 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 082IGkGg057123;
        Wed, 2 Sep 2020 13:16:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599070606;
        bh=GfTVZ0wvy7CzbpqFgIs3qOYOtsxaXlu82wrtrD6QGjU=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=O6mYoz1iW7ZFMC/+d5x5KA8sHJCv81ZPGS8lO/RBoXcXQ8xcdu6Q6niRSoKaRBeAn
         IGel7Vx5hXuW0Bu+PZ7yE07vhYsYG349R/7BKWoU1WBqSnBMugosiveCwf0Hqwb89t
         58VfdP9n8pZDRCnXPZioc0iQjYyZZOfXAb2+++3g=
Received: from DLEE103.ent.ti.com (dlee103.ent.ti.com [157.170.170.33])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 082IGk9R005318
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 2 Sep 2020 13:16:46 -0500
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 2 Sep
 2020 13:16:46 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 2 Sep 2020 13:16:46 -0500
Received: from [10.250.38.37] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 082IGjjn105163;
        Wed, 2 Sep 2020 13:16:45 -0500
Subject: Re: [PATCH net-next] net: dp83869: Add ability to advertise Fiber
 connection
To:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200902132556.10285-1-dmurphy@ti.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <33e15b70-fc43-ca15-75b3-79916a1b78ca@ti.com>
Date:   Wed, 2 Sep 2020 13:16:45 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200902132556.10285-1-dmurphy@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/2/20 8:25 AM, Dan Murphy wrote:
> Add the ability to advertise the Fiber connection if the strap or the
> op-mode is configured for 100Base-FX.
>
> Auto negotiation is not supported on this PHY when in fiber mode.
>
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>   drivers/net/phy/dp83869.c | 35 +++++++++++++++++++++++++++++++++++
>   1 file changed, 35 insertions(+)
>
> diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
> index 58103152c601..1acf498832f1 100644
> --- a/drivers/net/phy/dp83869.c
> +++ b/drivers/net/phy/dp83869.c
> @@ -52,6 +52,11 @@
>   					 BMCR_FULLDPLX | \
>   					 BMCR_SPEED1000)
>   
> +#define MII_DP83869_FIBER_ADVERTISE    (ADVERTISED_TP | ADVERTISED_MII | \
> +					ADVERTISED_FIBRE | ADVERTISED_BNC |  \
> +					ADVERTISED_Pause | ADVERTISED_Asym_Pause | \
> +					ADVERTISED_100baseT_Full)
> +
>   /* This is the same bit mask as the BMCR so re-use the BMCR default */
>   #define DP83869_FX_CTRL_DEFAULT	MII_DP83869_BMCR_DEFAULT
>   
> @@ -300,6 +305,7 @@ static int dp83869_configure_mode(struct phy_device *phydev,
>   {
>   	int phy_ctrl_val;
>   	int ret;
> +	int bmcr;
>   
>   	if (dp83869->mode < DP83869_RGMII_COPPER_ETHERNET ||
>   	    dp83869->mode > DP83869_SGMII_COPPER_ETHERNET)
> @@ -383,7 +389,36 @@ static int dp83869_configure_mode(struct phy_device *phydev,
>   
>   		break;
>   	case DP83869_RGMII_1000_BASE:
> +		break;
>   	case DP83869_RGMII_100_BASE:
> +		/* Only allow advertising what this PHY supports */
> +		linkmode_and(phydev->advertising, phydev->advertising,
> +			     phydev->supported);
> +
> +		linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
> +				 phydev->supported);
> +		linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
> +				 phydev->advertising);
> +
> +		/* Auto neg is not supported in fiber mode */
> +		bmcr = phy_read(phydev, MII_BMCR);
> +		if (bmcr < 0)
> +			return bmcr;
> +
> +		phydev->autoneg = AUTONEG_DISABLE;
> +		linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
> +				   phydev->supported);
> +		linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
> +				   phydev->advertising);
> +
> +		if (bmcr & BMCR_ANENABLE) {
> +			ret =  phy_modify(phydev, MII_BMCR, BMCR_ANENABLE, 0);
> +			if (ret < 0)
> +				return ret;
> +		}
> +		ret = phy_modify_changed(phydev, MII_ADVERTISE,
> +					 MII_DP83869_FIBER_ADVERTISE,
> +					 MII_DP83869_FIBER_ADVERTISE);

This is not correct after some testing find that this fails to init 
since ret will be non-zero on success

Dan
