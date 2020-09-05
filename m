Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF3625E9B6
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 20:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728604AbgIESee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 14:34:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728449AbgIESeb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 14:34:31 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22F2E2074D;
        Sat,  5 Sep 2020 18:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599330870;
        bh=eDxhChDXMDdm2AmyMVrCf4N6Nj7XWqUMzGfNFQZEEbI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NAMfWN/Oc1cs7IT3LzXmjqEwWzd8QUTjYZlnS6YNhChnJxoofg40srvncCeF03+1H
         IjvhS9ub33EjXNaR9IEIOAFHz++7odncBd+auighkv8DbU/Td8M57moBFgRxVmMqMb
         1hdCHFTgVRksy9nbbCnSdGxSxyA/w7BB9FVl4JNA=
Date:   Sat, 5 Sep 2020 11:34:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3 2/3] net: phy: dp83869: support Wake on LAN
Message-ID: <20200905113428.5bd7dc95@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200903114259.14013-3-dmurphy@ti.com>
References: <20200903114259.14013-1-dmurphy@ti.com>
        <20200903114259.14013-3-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Sep 2020 06:42:58 -0500 Dan Murphy wrote:
> This adds WoL support on TI DP83869 for magic, magic secure, unicast and
> broadcast.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>  drivers/net/phy/dp83869.c | 128 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 128 insertions(+)
> 
> diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
> index 48a68474f89c..5045df9515a5 100644
> --- a/drivers/net/phy/dp83869.c
> +++ b/drivers/net/phy/dp83869.c
> @@ -4,6 +4,7 @@
>   */
>  
>  #include <linux/ethtool.h>
> +#include <linux/etherdevice.h>
>  #include <linux/kernel.h>
>  #include <linux/mii.h>
>  #include <linux/module.h>
> @@ -27,6 +28,13 @@
>  #define DP83869_RGMIICTL	0x0032
>  #define DP83869_STRAP_STS1	0x006e
>  #define DP83869_RGMIIDCTL	0x0086
> +#define DP83869_RXFCFG		0x0134
> +#define DP83869_RXFPMD1		0x0136
> +#define DP83869_RXFPMD2		0x0137
> +#define DP83869_RXFPMD3		0x0138
> +#define DP83869_RXFSOP1		0x0139
> +#define DP83869_RXFSOP2		0x013A
> +#define DP83869_RXFSOP3		0x013B
>  #define DP83869_IO_MUX_CFG	0x0170
>  #define DP83869_OP_MODE		0x01df
>  #define DP83869_FX_CTRL		0x0c00
> @@ -105,6 +113,14 @@
>  #define DP83869_OP_MODE_MII			BIT(5)
>  #define DP83869_SGMII_RGMII_BRIDGE		BIT(6)
>  
> +/* RXFCFG bits*/
> +#define DP83869_WOL_MAGIC_EN		BIT(0)
> +#define DP83869_WOL_PATTERN_EN		BIT(1)
> +#define DP83869_WOL_BCAST_EN		BIT(2)
> +#define DP83869_WOL_UCAST_EN		BIT(4)
> +#define DP83869_WOL_SEC_EN		BIT(5)
> +#define DP83869_WOL_ENH_MAC		BIT(7)
> +
>  enum {
>  	DP83869_PORT_MIRRORING_KEEP,
>  	DP83869_PORT_MIRRORING_EN,
> @@ -156,6 +172,115 @@ static int dp83869_config_intr(struct phy_device *phydev)
>  	return phy_write(phydev, MII_DP83869_MICR, micr_status);
>  }
>  
> +static int dp83869_set_wol(struct phy_device *phydev,
> +			   struct ethtool_wolinfo *wol)
> +{
> +	struct net_device *ndev = phydev->attached_dev;
> +	u16 val_rxcfg, val_micr;
> +	u8 *mac;
> +
> +	val_rxcfg = phy_read_mmd(phydev, DP83869_DEVADDR, DP83869_RXFCFG);
> +	val_micr = phy_read(phydev, MII_DP83869_MICR);

In the previous patch you checked if phy_read() failed, here you don't.

> +	if (wol->wolopts & (WAKE_MAGIC | WAKE_MAGICSECURE | WAKE_UCAST |
> +			    WAKE_BCAST)) {
> +		val_rxcfg |= DP83869_WOL_ENH_MAC;
> +		val_micr |= MII_DP83869_MICR_WOL_INT_EN;
> +
> +		if (wol->wolopts & WAKE_MAGIC) {
> +			mac = (u8 *)ndev->dev_addr;
> +
> +			if (!is_valid_ether_addr(mac))
> +				return -EINVAL;
> +
> +			phy_write_mmd(phydev, DP83869_DEVADDR, DP83869_RXFPMD1,
> +				      (mac[1] << 8 | mac[0]));

parenthesis unnecessary

> +			phy_write_mmd(phydev, DP83869_DEVADDR, DP83869_RXFPMD2,
> +				      (mac[3] << 8 | mac[2]));
> +			phy_write_mmd(phydev, DP83869_DEVADDR, DP83869_RXFPMD3,
> +				      (mac[5] << 8 | mac[4]));

Why only program mac addr for wake_magic, does magic_secure or unicast
not require it?

> +
> +			val_rxcfg |= DP83869_WOL_MAGIC_EN;
> +		} else {
> +			val_rxcfg &= ~DP83869_WOL_MAGIC_EN;
> +		}
> +
> +		if (wol->wolopts & WAKE_MAGICSECURE) {
> +			phy_write_mmd(phydev, DP83869_DEVADDR, DP83869_RXFSOP1,
> +				      (wol->sopass[1] << 8) | wol->sopass[0]);
> +			phy_write_mmd(phydev, DP83869_DEVADDR, DP83869_RXFSOP2,
> +				      (wol->sopass[3] << 8) | wol->sopass[2]);
> +			phy_write_mmd(phydev, DP83869_DEVADDR, DP83869_RXFSOP3,
> +				      (wol->sopass[5] << 8) | wol->sopass[4]);
> +
> +			val_rxcfg |= DP83869_WOL_SEC_EN;
> +		} else {
> +			val_rxcfg &= ~DP83869_WOL_SEC_EN;
> +		}
> +
> +		if (wol->wolopts & WAKE_UCAST)
> +			val_rxcfg |= DP83869_WOL_UCAST_EN;
> +		else
> +			val_rxcfg &= ~DP83869_WOL_UCAST_EN;
> +
> +		if (wol->wolopts & WAKE_BCAST)
> +			val_rxcfg |= DP83869_WOL_BCAST_EN;
> +		else
> +			val_rxcfg &= ~DP83869_WOL_BCAST_EN;
> +	} else {
> +		val_rxcfg &= ~DP83869_WOL_ENH_MAC;
> +		val_micr &= ~MII_DP83869_MICR_WOL_INT_EN;
> +	}
> +
> +	phy_write_mmd(phydev, DP83869_DEVADDR, DP83869_RXFCFG, val_rxcfg);
> +	phy_write(phydev, MII_DP83869_MICR, val_micr);
> +
> +	return 0;
> +}
> +
> +static void dp83869_get_wol(struct phy_device *phydev,
> +			    struct ethtool_wolinfo *wol)
> +{
> +	u16 value, sopass_val;
> +
> +	wol->supported = (WAKE_UCAST | WAKE_BCAST | WAKE_MAGIC |
> +			WAKE_MAGICSECURE);
> +	wol->wolopts = 0;
> +
> +	value = phy_read_mmd(phydev, DP83869_DEVADDR, DP83869_RXFCFG);
> +
> +	if (value & DP83869_WOL_UCAST_EN)
> +		wol->wolopts |= WAKE_UCAST;
> +
> +	if (value & DP83869_WOL_BCAST_EN)
> +		wol->wolopts |= WAKE_BCAST;
> +
> +	if (value & DP83869_WOL_MAGIC_EN)
> +		wol->wolopts |= WAKE_MAGIC;
> +
> +	if (value & DP83869_WOL_SEC_EN) {
> +		sopass_val = phy_read_mmd(phydev, DP83869_DEVADDR,
> +					  DP83869_RXFSOP1);
> +		wol->sopass[0] = (sopass_val & 0xff);
> +		wol->sopass[1] = (sopass_val >> 8);
> +
> +		sopass_val = phy_read_mmd(phydev, DP83869_DEVADDR,
> +					  DP83869_RXFSOP2);
> +		wol->sopass[2] = (sopass_val & 0xff);
> +		wol->sopass[3] = (sopass_val >> 8);
> +
> +		sopass_val = phy_read_mmd(phydev, DP83869_DEVADDR,
> +					  DP83869_RXFSOP3);
> +		wol->sopass[4] = (sopass_val & 0xff);
> +		wol->sopass[5] = (sopass_val >> 8);
> +
> +		wol->wolopts |= WAKE_MAGICSECURE;
> +	}
> +
> +	if (!(value & DP83869_WOL_ENH_MAC))
> +		wol->wolopts = 0;

What does ENH stand for?

Perhaps it would be cleaner to make a helper like this:

u32 helper(u16 rxfsop1)
{
	u32 wolopts;

	if (!(value & DP83869_WOL_ENH_MAC))
		return 0;

	if (value & DP83869_WOL_UCAST_EN)
		wolopts |= WAKE_UCAST;
	if (value & DP83869_WOL_BCAST_EN)
		wolopts |= WAKE_BCAST;
	if (value & DP83869_WOL_MAGIC_EN)
		wolopts |= WAKE_MAGIC;
	if (value & DP83869_WOL_SEC_EN)
		wolopts |= WAKE_MAGICSECURE;

	return wolopts;
}

wol->wolopts = helper(value);

setting the bits and then clearing the value looks strange.

> +}
> +
>  static int dp83869_config_port_mirroring(struct phy_device *phydev)
>  {
>  	struct dp83869_private *dp83869 = phydev->priv;

Overall this code looks quite similar to dp83867, is there no way to
factor this out?
