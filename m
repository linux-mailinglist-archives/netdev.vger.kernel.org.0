Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E78863C8850
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 18:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235966AbhGNQFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 12:05:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54820 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235647AbhGNQFH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Jul 2021 12:05:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=UYyuoUFjTM6neNIQX8u+iPUtyx76GpoZIISiOp9Fi7c=; b=5AhLjlUDNYBVD/1uep9S0Y2JCo
        xmXFM+9wTq9WG8oN3Q6f+lxwIVS84jtthnFlz4JvoPy7W/2kxVl15aoaSHvYYyPedcPDo15Kquf29
        2Gqsft6Kst3AlBjbN2tMuxUnhqw0VTUmSZxtQc8sV4tXfA982F+YEDNp47rS7c+GsK4A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m3hKi-00DN9O-3E; Wed, 14 Jul 2021 18:02:00 +0200
Date:   Wed, 14 Jul 2021 18:02:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: Re: [PATCH/RFC 2/2] ravb: Add GbEthernet driver support
Message-ID: <YO8KeCg8bQPjI/a5@lunn.ch>
References: <20210714145408.4382-1-biju.das.jz@bp.renesas.com>
 <20210714145408.4382-3-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714145408.4382-3-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	if (priv->phy_interface == PHY_INTERFACE_MODE_RGMII_ID) {
> +		ravb_write(ndev, ravb_read(ndev, CXR31)
> +			 | CXR31_SEL_LINK0, CXR31);
> +	} else {
> +		ravb_write(ndev, ravb_read(ndev, CXR31)
> +			 & ~CXR31_SEL_LINK0, CXR31);
> +	}

You need to be very careful here. What value is passed to the PHY?

There is some funky code:

       /* Fall back to legacy rgmii-*id behavior */
        if (priv->phy_interface == PHY_INTERFACE_MODE_RGMII_ID ||
            priv->phy_interface == PHY_INTERFACE_MODE_RGMII_RXID) {
                priv->rxcidm = 1;
                priv->rgmii_override = 1;
        }

        if (priv->phy_interface == PHY_INTERFACE_MODE_RGMII_ID ||
            priv->phy_interface == PHY_INTERFACE_MODE_RGMII_TXID) {
                if (!WARN(soc_device_match(ravb_delay_mode_quirk_match),
                          "phy-mode %s requires TX clock internal delay mode which is not supported by this hardware revision. Please update device tree",
                          phy_modes(priv->phy_interface))) {
                        priv->txcidm = 1;
                        priv->rgmii_override = 1;
                }
        }
...

        iface = priv->rgmii_override ? PHY_INTERFACE_MODE_RGMII
                                     : priv->phy_interface;
        phydev = of_phy_connect(ndev, pn, ravb_adjust_link, 0, iface);

So it looks like, with PHY_INTERFACE_MODE_RGMII_ID,
PHY_INTERFACE_MODE_RGMII_TXID, PHY_INTERFACE_MODE_RGMII_RXID the PHY
is passed PHY_INTERFACE_MODE_RGMII, with the assumption the MAC is
adding the delay. But it looks like you are only adding a delay for
PHY_INTERFACE_MODE_RGMII_ID. So this appears wrong.

> @@ -1082,15 +1440,23 @@ static int ravb_phy_init(struct net_device *ndev)
>  		netdev_info(ndev, "limited PHY to 100Mbit/s\n");
>  	}
>  
> -	/* 10BASE, Pause and Asym Pause is not supported */
> -	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Half_BIT);
> -	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Full_BIT);
> -	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_Pause_BIT);
> -	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_Asym_Pause_BIT);
> +	if (priv->chip_id == RZ_G2L) {
> +		if (priv->phy_interface == PHY_INTERFACE_MODE_RGMII_ID)
> +			ravb_write(ndev, ravb_read(ndev, CXR35) | CXR35_SEL_MODIN, CXR35);
> +		else if (priv->phy_interface == PHY_INTERFACE_MODE_RGMII)
> +			ravb_write(ndev, 0x3E80000, CXR35);

This is not obviously correct. What about the other two RGMII modes?

> @@ -1348,6 +1741,21 @@ static const struct ethtool_ops ravb_ethtool_ops = {
>  	.set_wol		= ravb_set_wol,
>  };
>  
> +static const struct ethtool_ops rgeth_ethtool_ops = {
> +	.nway_reset		= phy_ethtool_nway_reset,
> +	.get_msglevel		= ravb_get_msglevel,
> +	.set_msglevel		= ravb_set_msglevel,
> +	.get_link		= ethtool_op_get_link,
> +	.get_strings		= ravb_get_strings,
> +	.get_ethtool_stats	= ravb_get_ethtool_stats,
> +	.get_sset_count		= ravb_get_sset_count,
> +	.get_ringparam		= ravb_get_ringparam,
> +	.set_ringparam		= ravb_set_ringparam,
> +	.get_ts_info		= ravb_get_ts_info,
> +	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
> +	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
> +};

It is not obvious why you need a seperate ethtool_ops structure? Does
it not support WOL?

> +static const struct net_device_ops rgeth_netdev_ops = {
> +	.ndo_open               = ravb_open,
> +	.ndo_stop               = ravb_close,
> +	.ndo_start_xmit         = ravb_start_xmit,
> +	.ndo_select_queue       = ravb_select_queue,
> +	.ndo_get_stats          = ravb_get_stats,
> +	.ndo_set_rx_mode        = ravb_set_rx_mode,
> +	.ndo_tx_timeout         = ravb_tx_timeout,
> +	.ndo_do_ioctl           = ravb_do_ioctl,
> +	.ndo_validate_addr      = eth_validate_addr,
> +	.ndo_set_mac_address    = eth_mac_addr,
> +	.ndo_set_features       = rgeth_set_features,

It seems like .ndo_set_features is the only difference. Maybe handle
that in actual function?

> @@ -1965,6 +2446,7 @@ static const struct of_device_id ravb_match_table[] = {
>  	{ .compatible = "renesas,etheravb-rcar-gen2", .data = (void *)RCAR_GEN2 },
>  	{ .compatible = "renesas,etheravb-r8a7795", .data = (void *)RCAR_GEN3 },
>  	{ .compatible = "renesas,etheravb-rcar-gen3", .data = (void *)RCAR_GEN3 },
> +	{ .compatible = "renesas,rzg2l-gether", .data = (void *)RZ_G2L },
>  	{ }
>  };

Please document the new compatible string in the DT binding.

       Andrew
