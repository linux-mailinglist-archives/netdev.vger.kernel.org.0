Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E443293203
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 01:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389103AbgJSXbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 19:31:04 -0400
Received: from kernel.crashing.org ([76.164.61.194]:42650 "EHLO
        kernel.crashing.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbgJSXbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 19:31:03 -0400
Received: from localhost (gate.crashing.org [63.228.1.57])
        (authenticated bits=0)
        by kernel.crashing.org (8.14.7/8.14.7) with ESMTP id 09JNUfPm024483
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 19 Oct 2020 18:30:46 -0500
Message-ID: <f844fe4e446a5654924198ebdb2e57510c6f14ad.camel@kernel.crashing.org>
Subject: Re: [PATCH v1 1/2] net: ftgmac100: move phy connect out from
 ftgmac100_setup_mdio
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     Ivan Mikhaylov <i.mikhaylov@yadro.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Po-Yu Chuang <ratbert@faraday-tech.com>
Cc:     Joel Stanley <joel@jms.id.au>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org
Date:   Tue, 20 Oct 2020 10:30:40 +1100
In-Reply-To: <20201015124917.8168-2-i.mikhaylov@yadro.com>
References: <20201015124917.8168-1-i.mikhaylov@yadro.com>
         <20201015124917.8168-2-i.mikhaylov@yadro.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-10-15 at 15:49 +0300, Ivan Mikhaylov wrote:
> Split MDIO registration and PHY connect into ftgmac100_setup_mdio and
> ftgmac100_mii_probe.

Please keep me CCod on ftgmac100 patches.

> Signed-off-by: Ivan Mikhaylov <i.mikhaylov@yadro.com>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> ---
>  drivers/net/ethernet/faraday/ftgmac100.c | 92 ++++++++++++------------
>  1 file changed, 47 insertions(+), 45 deletions(-)
> 
> diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
> index 87236206366f..6997e121824b 100644
> --- a/drivers/net/ethernet/faraday/ftgmac100.c
> +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> @@ -1044,11 +1044,47 @@ static void ftgmac100_adjust_link(struct net_device *netdev)
>  	schedule_work(&priv->reset_task);
>  }
>  
> -static int ftgmac100_mii_probe(struct ftgmac100 *priv, phy_interface_t intf)
> +static int ftgmac100_mii_probe(struct net_device *netdev)
>  {
> -	struct net_device *netdev = priv->netdev;
> +	struct ftgmac100 *priv = netdev_priv(netdev);
> +	struct platform_device *pdev = to_platform_device(priv->dev);
> +	struct device_node *np = pdev->dev.of_node;
> +	phy_interface_t phy_intf = PHY_INTERFACE_MODE_RGMII;
>  	struct phy_device *phydev;
>  
> +	/* Get PHY mode from device-tree */
> +	if (np) {
> +		/* Default to RGMII. It's a gigabit part after all */
> +		phy_intf = of_get_phy_mode(np, &phy_intf);
> +		if (phy_intf < 0)
> +			phy_intf = PHY_INTERFACE_MODE_RGMII;
> +
> +		/* Aspeed only supports these. I don't know about other IP
> +		 * block vendors so I'm going to just let them through for
> +		 * now. Note that this is only a warning if for some obscure
> +		 * reason the DT really means to lie about it or it's a newer
> +		 * part we don't know about.
> +		 *
> +		 * On the Aspeed SoC there are additionally straps and SCU
> +		 * control bits that could tell us what the interface is
> +		 * (or allow us to configure it while the IP block is held
> +		 * in reset). For now I chose to keep this driver away from
> +		 * those SoC specific bits and assume the device-tree is
> +		 * right and the SCU has been configured properly by pinmux
> +		 * or the firmware.
> +		 */
> +		if (priv->is_aspeed &&
> +		    phy_intf != PHY_INTERFACE_MODE_RMII &&
> +		    phy_intf != PHY_INTERFACE_MODE_RGMII &&
> +		    phy_intf != PHY_INTERFACE_MODE_RGMII_ID &&
> +		    phy_intf != PHY_INTERFACE_MODE_RGMII_RXID &&
> +		    phy_intf != PHY_INTERFACE_MODE_RGMII_TXID) {
> +			netdev_warn(netdev,
> +				    "Unsupported PHY mode %s !\n",
> +				    phy_modes(phy_intf));
> +		}
> +	}
> +
>  	phydev = phy_find_first(priv->mii_bus);
>  	if (!phydev) {
>  		netdev_info(netdev, "%s: no PHY found\n", netdev->name);
> @@ -1056,7 +1092,7 @@ static int ftgmac100_mii_probe(struct ftgmac100 *priv, phy_interface_t intf)
>  	}
>  
>  	phydev = phy_connect(netdev, phydev_name(phydev),
> -			     &ftgmac100_adjust_link, intf);
> +			     &ftgmac100_adjust_link, phy_intf);
>  
>  	if (IS_ERR(phydev)) {
>  		netdev_err(netdev, "%s: Could not attach to PHY\n", netdev->name);
> @@ -1601,7 +1637,6 @@ static int ftgmac100_setup_mdio(struct net_device *netdev)
>  {
>  	struct ftgmac100 *priv = netdev_priv(netdev);
>  	struct platform_device *pdev = to_platform_device(priv->dev);
> -	phy_interface_t phy_intf = PHY_INTERFACE_MODE_RGMII;
>  	struct device_node *np = pdev->dev.of_node;
>  	int i, err = 0;
>  	u32 reg;
> @@ -1623,39 +1658,6 @@ static int ftgmac100_setup_mdio(struct net_device *netdev)
>  		iowrite32(reg, priv->base + FTGMAC100_OFFSET_REVR);
>  	}
>  
> -	/* Get PHY mode from device-tree */
> -	if (np) {
> -		/* Default to RGMII. It's a gigabit part after all */
> -		err = of_get_phy_mode(np, &phy_intf);
> -		if (err)
> -			phy_intf = PHY_INTERFACE_MODE_RGMII;
> -
> -		/* Aspeed only supports these. I don't know about other IP
> -		 * block vendors so I'm going to just let them through for
> -		 * now. Note that this is only a warning if for some obscure
> -		 * reason the DT really means to lie about it or it's a newer
> -		 * part we don't know about.
> -		 *
> -		 * On the Aspeed SoC there are additionally straps and SCU
> -		 * control bits that could tell us what the interface is
> -		 * (or allow us to configure it while the IP block is held
> -		 * in reset). For now I chose to keep this driver away from
> -		 * those SoC specific bits and assume the device-tree is
> -		 * right and the SCU has been configured properly by pinmux
> -		 * or the firmware.
> -		 */
> -		if (priv->is_aspeed &&
> -		    phy_intf != PHY_INTERFACE_MODE_RMII &&
> -		    phy_intf != PHY_INTERFACE_MODE_RGMII &&
> -		    phy_intf != PHY_INTERFACE_MODE_RGMII_ID &&
> -		    phy_intf != PHY_INTERFACE_MODE_RGMII_RXID &&
> -		    phy_intf != PHY_INTERFACE_MODE_RGMII_TXID) {
> -			netdev_warn(netdev,
> -				   "Unsupported PHY mode %s !\n",
> -				   phy_modes(phy_intf));
> -		}
> -	}
> -
>  	priv->mii_bus->name = "ftgmac100_mdio";
>  	snprintf(priv->mii_bus->id, MII_BUS_ID_SIZE, "%s-%d",
>  		 pdev->name, pdev->id);
> @@ -1673,16 +1675,8 @@ static int ftgmac100_setup_mdio(struct net_device *netdev)
>  		goto err_register_mdiobus;
>  	}
>  
> -	err = ftgmac100_mii_probe(priv, phy_intf);
> -	if (err) {
> -		dev_err(priv->dev, "MII Probe failed!\n");
> -		goto err_mii_probe;
> -	}
> -
>  	return 0;
>  
> -err_mii_probe:
> -	mdiobus_unregister(priv->mii_bus);
>  err_register_mdiobus:
>  	mdiobus_free(priv->mii_bus);
>  	return err;
> @@ -1860,6 +1854,14 @@ static int ftgmac100_probe(struct platform_device *pdev)
>  		err = ftgmac100_setup_mdio(netdev);
>  		if (err)
>  			goto err_setup_mdio;
> +
> +		err = ftgmac100_mii_probe(netdev);
> +		if (err) {
> +			dev_err(priv->dev, "MII probe failed!\n");
> +			mdiobus_unregister(priv->mii_bus);
> +			goto err_setup_mdio;
> +		}
> +
>  	}
>  
>  	if (priv->is_aspeed) {

