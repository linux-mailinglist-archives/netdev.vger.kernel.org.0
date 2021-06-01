Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237263972CA
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 13:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233805AbhFALuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 07:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233064AbhFALuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 07:50:51 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D89AC061574;
        Tue,  1 Jun 2021 04:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=H/HM1WVJ7mnoqRbkGOWXXNo3F/vveMrIh8BwkNykNIE=; b=QQgc3cFyzWZ7FkAx+KCVEPR1y
        xwt54wMQEr7wwSoPlSfX09YV6iuZV+BwNTUSxd31JaJKthxV6cYW4trItZftUl778oqgfUHlXLjof
        MJvfBK+fadvitjy+7KHzoV4+o9hkyPnfAGJvqZPAfCJXVHpZth6NPYkiqhym+zzkNozkpd/QE9Mvx
        YrYa/O3oTt1NspqU23b6JWUd+QSTev6Ekl+XDcIqXEhmrE7QYdeitvXTwmUs0/e/3iiUrI//RLcrv
        p0hLhMDyH7HaZkPjJjNnMKCofxVNKkx3IccSPhki6fc5qF2FdJOMTE/r+gAxzN6jG1hKtdkvhy3My
        EcanDoHbA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44562)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lo2tE-0003vr-W7; Tue, 01 Jun 2021 12:48:57 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lo2tC-0008Vi-Ao; Tue, 01 Jun 2021 12:48:54 +0100
Date:   Tue, 1 Jun 2021 12:48:54 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, f.fainelli@gmail.com,
        linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/4] net: phy: realtek: add dt property to
 disable CLKOUT clock
Message-ID: <20210601114854.GT30436@shell.armlinux.org.uk>
References: <20210601090408.22025-1-qiangqing.zhang@nxp.com>
 <20210601090408.22025-3-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601090408.22025-3-qiangqing.zhang@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 01, 2021 at 05:04:06PM +0800, Joakim Zhang wrote:
> Add "rtl821x,clkout-disable" property for user to disable CLKOUT clock
> to save PHY power.
> 
> Per RTL8211F guide, a PHY reset should be issued after setting these
> bits in PHYCR2 register. After this patch, CLKOUT clock output to be
> disabled.
> 
> Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> ---
>  drivers/net/phy/realtek.c | 48 ++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 47 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> index 821e85a97367..4219c23ff2b0 100644
> --- a/drivers/net/phy/realtek.c
> +++ b/drivers/net/phy/realtek.c
> @@ -8,6 +8,7 @@
>   * Copyright (c) 2004 Freescale Semiconductor, Inc.
>   */
>  #include <linux/bitops.h>
> +#include <linux/of.h>
>  #include <linux/phy.h>
>  #include <linux/module.h>
>  #include <linux/delay.h>
> @@ -27,6 +28,7 @@
>  #define RTL821x_PAGE_SELECT			0x1f
>  
>  #define RTL8211F_PHYCR1				0x18
> +#define RTL8211F_PHYCR2				0x19
>  #define RTL8211F_INSR				0x1d
>  
>  #define RTL8211F_TX_DELAY			BIT(8)
> @@ -40,6 +42,8 @@
>  #define RTL8211E_TX_DELAY			BIT(12)
>  #define RTL8211E_RX_DELAY			BIT(11)
>  
> +#define RTL8211F_CLKOUT_EN			BIT(0)
> +
>  #define RTL8201F_ISR				0x1e
>  #define RTL8201F_ISR_ANERR			BIT(15)
>  #define RTL8201F_ISR_DUPLEX			BIT(13)
> @@ -67,10 +71,17 @@
>  
>  #define RTL_GENERIC_PHYID			0x001cc800
>  
> +/* quirks for realtek phy */
> +#define RTL821X_CLKOUT_DISABLE_FEATURE		BIT(0)
> +
>  MODULE_DESCRIPTION("Realtek PHY driver");
>  MODULE_AUTHOR("Johnson Leung");
>  MODULE_LICENSE("GPL");
>  
> +struct rtl821x_priv {
> +	u32 quirks;
> +};
> +
>  static int rtl821x_read_page(struct phy_device *phydev)
>  {
>  	return __phy_read(phydev, RTL821x_PAGE_SELECT);
> @@ -81,6 +92,23 @@ static int rtl821x_write_page(struct phy_device *phydev, int page)
>  	return __phy_write(phydev, RTL821x_PAGE_SELECT, page);
>  }
>  
> +static int rtl821x_probe(struct phy_device *phydev)
> +{
> +	struct device *dev = &phydev->mdio.dev;
> +	struct rtl821x_priv *priv;
> +
> +	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	if (of_property_read_bool(dev->of_node, "rtl821x,clkout-disable"))
> +		priv->quirks |= RTL821X_CLKOUT_DISABLE_FEATURE;
> +
> +	phydev->priv = priv;
> +
> +	return 0;
> +}
> +
>  static int rtl8201_ack_interrupt(struct phy_device *phydev)
>  {
>  	int err;
> @@ -291,6 +319,7 @@ static int rtl8211c_config_init(struct phy_device *phydev)
>  
>  static int rtl8211f_config_init(struct phy_device *phydev)
>  {
> +	struct rtl821x_priv *priv = phydev->priv;
>  	struct device *dev = &phydev->mdio.dev;
>  	u16 val_txdly, val_rxdly;
>  	u16 val;
> @@ -354,7 +383,23 @@ static int rtl8211f_config_init(struct phy_device *phydev)
>  			val_rxdly ? "enabled" : "disabled");
>  	}
>  
> -	return 0;
> +	if (priv->quirks & RTL821X_CLKOUT_DISABLE_FEATURE) {
> +		ret = phy_modify_paged(phydev, 0xa43, RTL8211F_PHYCR2,
> +				       RTL8211F_CLKOUT_EN, 0);
> +		if (ret < 0) {
> +			dev_err(&phydev->mdio.dev, "clkout disable failed\n");

You already have "dev" above, so this can be simplified to:

			dev_err(dev, "clkout disable failed\n");

> +			return ret;
> +		}
> +	} else {
> +		ret = phy_modify_paged(phydev, 0xa43, RTL8211F_PHYCR2,
> +				       RTL8211F_CLKOUT_EN, RTL8211F_CLKOUT_EN);
> +		if (ret < 0) {
> +			dev_err(&phydev->mdio.dev, "clkout enable failed\n");

Same here.

> +			return ret;
> +		}
> +	}

Do you really need to distinguish between the enable and disable
operation? Would the following be better?

	if (priv->quirks & RTL821X_CLKOUT_DISABLE_FEATURE)
		clkout = 0;
	else
		clkout = RTL8211_CLKOUT_EN;

	ret = phy_modify_paged(phydev, 0xa43, RTL8211F_PHYCR2,
			       RTL8211_CLKOUT_EN, clkout);
	if (ret < 0) {
		dev_err(dev, "clkout configuration failed: %pe\n",
			ERR_PTR(ret));
		return ret;
	}

Other questions:
- Does the clock output default to enabled or disabled during kernel
  boot without this patch? Does this state depend on the boot loader?
- Do we really need the use of negative logic here (which depends on
  the answer to the above question)?
- Could other bits in the RTL8211F_PHYCR2 register also require future
  configuration? Would it be better to store the desired PHYCR2
  register value in "priv" rather than using "quirks". Quirks can become
  very unweildy over time.

By way of example on the last point... probe() would become:

	priv->phycr2 = RTL8211_CLKOUT_EN;

	if (of_property_read_bool(dev->of_node, "rtl821x,clkout-disable"))
		priv->phycr2 &= ~RTL8211_CLKOUT_EN;

and config_init():

	ret = phy_modify_paged(phydev, 0xa43, RTL8211F_PHYCR2,
			       RTL8211_CLKOUT_EN, priv->phycr2);
	if (ret < 0) {
		dev_err(dev, "clkout configuration failed: %pe\n",
			ERR_PTR(ret));
		return ret;
	}

Note that phycr2 would be a u16 value.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
