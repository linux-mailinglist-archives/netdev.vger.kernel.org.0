Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6684B41896E
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 16:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbhIZO2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 10:28:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60902 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231743AbhIZO2g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Sep 2021 10:28:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=k8gfpPgOHfEG4YqeX4bNBQrJbN/freSdAyEC55k1afA=; b=kemjfGqbacjmi49o7IqF1/CJN+
        hkdgAQqvH139lbY06+Oumb2dRDJMawzCHIDi73AmzgqMwKdiY+42Ii42ncM5iH3euDRvtkIpHyZGY
        CIrwp8d6I1HjvHfEnTDHNfvCcknv3gaqPDuyill/l2brMAq+61tKnA7o+eQrrbQZxnYU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mUV7H-008K6T-R6; Sun, 26 Sep 2021 16:26:55 +0200
Date:   Sun, 26 Sep 2021 16:26:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:BROADCOM GENET ETHERNET DRIVER" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 4/4] net: bcmgenet: add support for ethtool flow
 control
Message-ID: <YVCDL9WEATFOIGpH@lunn.ch>
References: <20210926032114.1785872-1-f.fainelli@gmail.com>
 <20210926032114.1785872-5-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210926032114.1785872-5-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 25, 2021 at 08:21:14PM -0700, Florian Fainelli wrote:
> From: Doug Berger <opendmb@gmail.com>
> 
> This commit extends the supported ethtool operations to allow MAC
> level flow control to be configured for the bcmgenet driver.
> 
> The ethtool utility can be used to change the configuration of
> auto-negotiated symmetric and asymmetric modes as well as manually
> configuring support for RX and TX Pause frames individually.
> 
> Signed-off-by: Doug Berger <opendmb@gmail.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  .../net/ethernet/broadcom/genet/bcmgenet.c    | 51 +++++++++++++++++++
>  .../net/ethernet/broadcom/genet/bcmgenet.h    |  4 ++
>  drivers/net/ethernet/broadcom/genet/bcmmii.c  | 44 +++++++++++++---
>  3 files changed, 92 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> index 3427f9ed7eb9..6a8234bc9428 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> @@ -935,6 +935,48 @@ static int bcmgenet_set_coalesce(struct net_device *dev,
>  	return 0;
>  }
>  
> +static void bcmgenet_get_pauseparam(struct net_device *dev,
> +				    struct ethtool_pauseparam *epause)
> +{
> +	struct bcmgenet_priv *priv;
> +	u32 umac_cmd;
> +
> +	priv = netdev_priv(dev);
> +
> +	epause->autoneg = priv->autoneg_pause;
> +
> +	if (netif_carrier_ok(dev)) {
> +		/* report active state when link is up */
> +		umac_cmd = bcmgenet_umac_readl(priv, UMAC_CMD);
> +		epause->tx_pause = !(umac_cmd & CMD_TX_PAUSE_IGNORE);
> +		epause->rx_pause = !(umac_cmd & CMD_RX_PAUSE_IGNORE);
> +	} else {
> +		/* otherwise report stored settings */
> +		epause->tx_pause = priv->tx_pause;
> +		epause->rx_pause = priv->rx_pause;
> +	}
> +}
> +
> +static int bcmgenet_set_pauseparam(struct net_device *dev,
> +				   struct ethtool_pauseparam *epause)
> +{
> +	struct bcmgenet_priv *priv = netdev_priv(dev);
> +
> +	if (!dev->phydev)
> +		return -ENODEV;
> +
> +	if (!phy_validate_pause(dev->phydev, epause))
> +		return -EINVAL;
> +
> +	priv->autoneg_pause = !!epause->autoneg;
> +	priv->tx_pause = !!epause->tx_pause;
> +	priv->rx_pause = !!epause->rx_pause;
> +
> +	bcmgenet_phy_pause_set(dev, priv->rx_pause, priv->tx_pause);

I don't think this is correct. If epause->autoneg is false, you
probably want to pass false, false here, so that the PHY will not
announce any modes. And then call bcmgenet_mac_config() to set the
manual pause bits. But watch out that you don't hold the PHY lock, so
you should not access any phydev members.

> +	} else {
> +		/* pause capability defaults to Symmetric */
> +		if (priv->autoneg_pause) {
> +			bool tx_pause = 0, rx_pause = 0;
> +
> +			if (phydev->autoneg)
> +				phy_get_pause(phydev, &tx_pause, &rx_pause);
>  
> -	/* pause capability */
> -	if (!phydev->pause)
> -		cmd_bits |= CMD_RX_PAUSE_IGNORE | CMD_TX_PAUSE_IGNORE;
> +			if (!tx_pause)
> +				cmd_bits |= CMD_TX_PAUSE_IGNORE;
> +			if (!rx_pause)
> +				cmd_bits |= CMD_RX_PAUSE_IGNORE;
> +		}

Looks like there should be an else here?

> +
> +		/* Manual override */
> +		if (!priv->rx_pause)
> +			cmd_bits |= CMD_RX_PAUSE_IGNORE;
> +		if (!priv->tx_pause)
> +			cmd_bits |= CMD_TX_PAUSE_IGNORE;
> +	}
>  
>  	/* Program UMAC and RGMII block based on established
>  	 * link speed, duplex, and pause. The speed set in
> @@ -101,6 +118,21 @@ static int bcmgenet_fixed_phy_link_update(struct net_device *dev,
>  	return 0;
>  }
>  
> +void bcmgenet_phy_pause_set(struct net_device *dev, bool rx, bool tx)
> +{
> +	struct phy_device *phydev = dev->phydev;
> +
> +	linkmode_mod_bit(ETHTOOL_LINK_MODE_Pause_BIT, phydev->advertising, rx);
> +	linkmode_mod_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, phydev->advertising,
> +			 rx | tx);
> +	phy_start_aneg(phydev);
> +
> +	mutex_lock(&phydev->lock);
> +	if (phydev->link)
> +		bcmgenet_mac_config(dev);
> +	mutex_unlock(&phydev->lock);

It is a bit oddly named, but phy_set_asym_pause() does this, minus the
lock. Please use that, rather than open coding this.

Locking is something i'm looking at now. I'm trying to go through all
the phylib calls the MAC use and checking if locks need to be added.

    Andrew
