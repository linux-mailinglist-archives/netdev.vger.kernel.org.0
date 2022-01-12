Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC8648BBA3
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 01:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343695AbiALAKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 19:10:44 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33138 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232804AbiALAKn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 19:10:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=au10UuWYFuuV3VuwANJ5piC5pvoNm1+3zCZdu/In/ao=; b=ZZmYbPDim7AO4RoKIA6lcRKwAY
        AfwEAMcQs/R81ei0DbVxX2fScdAAnRLM4GBvz+EaKYUmeUX+JChKIo27VfwSXoVqnyWaSgJ91s7xz
        HlRVK5E4MobVHmQw9UkGee/9LuqQBrczaBthkW+YxytWGyoJ0uQdmkz2afKCC+Kb8u98=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n7RDs-0019Cq-W8; Wed, 12 Jan 2022 01:10:41 +0100
Date:   Wed, 12 Jan 2022 01:10:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH net-next v2 2/3] net: phy: at803x: add fiber support
Message-ID: <Yd4cgGZ2tHzjBLqS@lunn.ch>
References: <20220111215504.2714643-1-robert.hancock@calian.com>
 <20220111215504.2714643-3-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220111215504.2714643-3-robert.hancock@calian.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  #define AT803X_MODE_CFG_MASK			0x0F
> -#define AT803X_MODE_CFG_SGMII			0x01
> +#define AT803X_MODE_CFG_BASET_RGMII		0x00
> +#define AT803X_MODE_CFG_BASET_SGMII		0x01
> +#define AT803X_MODE_CFG_BX1000_RGMII_50		0x02
> +#define AT803X_MODE_CFG_BX1000_RGMII_75		0x03
> +#define AT803X_MODE_CFG_BX1000_CONV_50		0x04
> +#define AT803X_MODE_CFG_BX1000_CONV_75		0x05
> +#define AT803X_MODE_CFG_FX100_RGMII_50		0x06
> +#define AT803X_MODE_CFG_FX100_CONV_50		0x07
> +#define AT803X_MODE_CFG_RGMII_AUTO_MDET		0x0B
> +#define AT803X_MODE_CFG_FX100_RGMII_75		0x0E
> +#define AT803X_MODE_CFG_FX100_CONV_75		0x0F

Hi Robert

What do these _50, and _75 mean?

 
>  #define AT803X_PSSR				0x11	/*PHY-Specific Status Register*/
>  #define AT803X_PSSR_MR_AN_COMPLETE		0x0200
> @@ -283,6 +295,8 @@ struct at803x_priv {
>  	u16 clk_25m_mask;
>  	u8 smarteee_lpi_tw_1g;
>  	u8 smarteee_lpi_tw_100m;
> +	bool is_fiber;

Is maybe is_100basefx a better name? It makes it clearer it represents
a link mode?

> +	bool is_1000basex;
>  	struct regulator_dev *vddio_rdev;
>  	struct regulator_dev *vddh_rdev;
>  	struct regulator *vddio;
> @@ -784,7 +798,33 @@ static int at803x_probe(struct phy_device *phydev)
>  			return ret;
>  	}
>  
> +	if (phydev->drv->phy_id == ATH8031_PHY_ID) {
> +		int ccr = phy_read(phydev, AT803X_REG_CHIP_CONFIG);
> +		int mode_cfg;
> +
> +		if (ccr < 0)
> +			goto err;
> +		mode_cfg = ccr & AT803X_MODE_CFG_MASK;
> +
> +		switch (mode_cfg) {
> +		case AT803X_MODE_CFG_BX1000_RGMII_50:
> +		case AT803X_MODE_CFG_BX1000_RGMII_75:
> +			priv->is_1000basex = true;
> +			fallthrough;
> +		case AT803X_MODE_CFG_FX100_RGMII_50:
> +		case AT803X_MODE_CFG_FX100_RGMII_75:
> +			priv->is_fiber = true;

O.K, now i'm wondering what AT803X_MODE_CFG_FX100_* actually means. I
was thinking it indicated 100BaseFX? But the fall through suggests
otherwise.

>  static int at803x_config_init(struct phy_device *phydev)
>  {
> +	struct at803x_priv *priv = phydev->priv;
>  	int ret;
>  
>  	if (phydev->drv->phy_id == ATH8031_PHY_ID) {
> -	       /* Some bootloaders leave the fiber page selected.
> -		* Switch to the copper page, as otherwise we read
> -		* the PHY capabilities from the fiber side.
> -		*/
> +		/* Some bootloaders leave the fiber page selected.

Looks like you have a tab vs space problem with the previous patch?
Otherwise this first line should not of changed.

	  Andrew
