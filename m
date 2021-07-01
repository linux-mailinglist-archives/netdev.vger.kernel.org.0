Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6353B98D5
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 01:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234110AbhGAXIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 19:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233648AbhGAXIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 19:08:01 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96564C061762
        for <netdev@vger.kernel.org>; Thu,  1 Jul 2021 16:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=kOoJBS0N9txVKN/lyT8pOq5F2B3oEJgVfinc6n0Dtc4=; b=HtDS8Bh9Uwf7h/AvFI5SK53U7
        Msxm7u3LJbWp2mXEvQPrdMw65LkWY1+2SrzqFYR/ku9QpaXfd98JNFeUgDfCkte7qOyhbKW2QqIGM
        TMRNvU8Q1mKGljJM8br5COo8MD74bDiD4mEVPn0H6aNl8IvXcTx25CAQVMzIg57BNS9jiiv6RaToJ
        DOvBD+cJoLuOeEYeYqt2CLzJzoXvWc8xPRKpDMtzn3M342prdS5ex9YD49UKmtFvGRh/gxtT22Pv3
        ekK05KFz+2LqKRDy22/4boeI2+O099soqXdmVQrASi873ZEpgSRGUokmJT0PSjy8jWBes0GshvWYT
        npCBTVSUg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45596)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lz5kL-0001k3-ED; Fri, 02 Jul 2021 00:05:25 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lz5kJ-0004Sb-Ml; Fri, 02 Jul 2021 00:05:23 +0100
Date:   Fri, 2 Jul 2021 00:05:23 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: phy: at803x: add fiber support
Message-ID: <20210701230523.GL22278@shell.armlinux.org.uk>
References: <20210630180146.1121925-1-robert.hancock@calian.com>
 <20210630180146.1121925-2-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630180146.1121925-2-robert.hancock@calian.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 30, 2021 at 12:01:45PM -0600, Robert Hancock wrote:
> Previously this driver always forced the copper page to be selected,
> however for AR8031 in 100Base-FX or 1000Base-X modes, the fiber page
> needs to be selected. Set the appropriate mode based on the hardware
> mode_cfg strap selection.
> 
> Enable the appropriate interrupt bits to detect fiber-side link up
> or down events.
> 
> Update config_aneg and read_status methods to use the appropriate
> Clause 37 calls when fiber mode is in use.
> 
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>
> ---
>  drivers/net/phy/at803x.c | 69 ++++++++++++++++++++++++++++++++++------
>  1 file changed, 59 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> index 5d62b85a4024..65f546eca5f4 100644
> --- a/drivers/net/phy/at803x.c
> +++ b/drivers/net/phy/at803x.c
> @@ -48,6 +48,8 @@
>  #define AT803X_INTR_ENABLE_PAGE_RECEIVED	BIT(12)
>  #define AT803X_INTR_ENABLE_LINK_FAIL		BIT(11)
>  #define AT803X_INTR_ENABLE_LINK_SUCCESS		BIT(10)
> +#define AT803X_INTR_ENABLE_LINK_FAIL_BX		BIT(8)
> +#define AT803X_INTR_ENABLE_LINK_SUCCESS_BX	BIT(7)
>  #define AT803X_INTR_ENABLE_WIRESPEED_DOWNGRADE	BIT(5)
>  #define AT803X_INTR_ENABLE_POLARITY_CHANGED	BIT(1)
>  #define AT803X_INTR_ENABLE_WOL			BIT(0)
> @@ -81,7 +83,17 @@
>  #define AT803X_DEBUG_DATA			0x1E
>  
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
>  
>  #define AT803X_PSSR				0x11	/*PHY-Specific Status Register*/
>  #define AT803X_PSSR_MR_AN_COMPLETE		0x0200
> @@ -191,6 +203,8 @@ struct at803x_priv {
>  	u16 clk_25m_mask;
>  	u8 smarteee_lpi_tw_1g;
>  	u8 smarteee_lpi_tw_100m;
> +	bool is_fiber;
> +	bool is_1000basex;
>  	struct regulator_dev *vddio_rdev;
>  	struct regulator_dev *vddh_rdev;
>  	struct regulator *vddio;
> @@ -673,12 +687,32 @@ static int at803x_probe(struct phy_device *phydev)
>  	}
>  
>  	/* Some bootloaders leave the fiber page selected.
> -	 * Switch to the copper page, as otherwise we read
> -	 * the PHY capabilities from the fiber side.
> +	 * Switch to the appropriate page (fiber or copper), as otherwise we
> +	 * read the PHY capabilities from the wrong page.
>  	 */
>  	if (at803x_match_phy_id(phydev, ATH8031_PHY_ID)) {
> +		int mode_cfg;
> +
> +		ret = phy_read(phydev, AT803X_REG_CHIP_CONFIG);
> +		if (ret < 0)
> +			goto err;
> +		mode_cfg = ret & AT803X_MODE_CFG_MASK;
> +
> +		switch (mode_cfg) {
> +		case AT803X_MODE_CFG_BX1000_RGMII_50:
> +		case AT803X_MODE_CFG_BX1000_RGMII_75:
> +			priv->is_1000basex = true;
> +			fallthrough;
> +		case AT803X_MODE_CFG_FX100_RGMII_50:
> +		case AT803X_MODE_CFG_FX100_RGMII_75:
> +			priv->is_fiber = true;
> +			break;
> +		}
> +
>  		phy_lock_mdio_bus(phydev);
> -		ret = at803x_write_page(phydev, AT803X_PAGE_COPPER);
> +		ret = at803x_write_page(phydev,
> +					priv->is_fiber ? AT803X_PAGE_FIBER :
> +							 AT803X_PAGE_COPPER);
>  		phy_unlock_mdio_bus(phydev);

Does this configuration have to be restored when the PHY is resumed,
or can we assume that this is always retained? Should this be moved
to the config_init method?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
