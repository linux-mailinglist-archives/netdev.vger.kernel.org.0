Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B709E050C
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 15:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731936AbfJVNa1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 22 Oct 2019 09:30:27 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:57083 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388753AbfJVNa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 09:30:26 -0400
Received: from litschi.hi.pengutronix.de ([2001:67c:670:100:feaa:14ff:fe6a:8db5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <m.tretter@pengutronix.de>)
        id 1iMuEz-000817-79; Tue, 22 Oct 2019 15:30:25 +0200
Date:   Tue, 22 Oct 2019 15:30:23 +0200
From:   Michael Tretter <m.tretter@pengutronix.de>
To:     Thomas =?UTF-8?B?SMOkbW1lcmxl?= <Thomas.Haemmerle@wolfvision.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>, kernel@pengutronix.de
Subject: Re: [PATCH v2] net: phy: dp83867: support Wake on LAN
Message-ID: <20191022153023.1fc3a3e1@litschi.hi.pengutronix.de>
In-Reply-To: <1571749572-9736-1-git-send-email-thomas.haemmerle@wolfvision.net>
References: <1571742645-13800-1-git-send-email-thomas.haemmerle@wolfvision.net>
        <1571749572-9736-1-git-send-email-thomas.haemmerle@wolfvision.net>
Organization: Pengutronix
X-Mailer: Claws Mail 3.14.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SA-Exim-Connect-IP: 2001:67c:670:100:feaa:14ff:fe6a:8db5
X-SA-Exim-Mail-From: m.tretter@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Oct 2019 13:06:35 +0000, Thomas Hämmerle wrote:
> From: Thomas Haemmerle <thomas.haemmerle@wolfvision.net>
> 
> This adds WoL support on TI DP83867 for magic, magic secure, unicast and
> broadcast.
> 
> Signed-off-by: Thomas Haemmerle <thomas.haemmerle@wolfvision.net>

Reviewed-by: Michael Tretter <michael.tretter@pengutronix.de>

> ---
>  drivers/net/phy/dp83867.c | 131 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 130 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
> index 37fceaf..1a3f8f1 100644
> --- a/drivers/net/phy/dp83867.c
> +++ b/drivers/net/phy/dp83867.c
> @@ -12,6 +12,8 @@
>  #include <linux/of.h>
>  #include <linux/phy.h>
>  #include <linux/delay.h>
> +#include <linux/netdevice.h>
> +#include <linux/etherdevice.h>
>  
>  #include <dt-bindings/net/ti-dp83867.h>
>  
> @@ -21,8 +23,9 @@
>  #define MII_DP83867_PHYCTRL	0x10
>  #define MII_DP83867_MICR	0x12
>  #define MII_DP83867_ISR		0x13
> -#define DP83867_CTRL		0x1f
> +#define DP83867_CFG2		0x14
>  #define DP83867_CFG3		0x1e
> +#define DP83867_CTRL		0x1f
>  
>  /* Extended Registers */
>  #define DP83867_CFG4            0x0031
> @@ -36,6 +39,13 @@
>  #define DP83867_STRAP_STS1	0x006E
>  #define DP83867_STRAP_STS2	0x006f
>  #define DP83867_RGMIIDCTL	0x0086
> +#define DP83867_RXFCFG		0x0134
> +#define DP83867_RXFPMD1	0x0136
> +#define DP83867_RXFPMD2	0x0137
> +#define DP83867_RXFPMD3	0x0138
> +#define DP83867_RXFSOP1	0x0139
> +#define DP83867_RXFSOP2	0x013A
> +#define DP83867_RXFSOP3	0x013B
>  #define DP83867_IO_MUX_CFG	0x0170
>  #define DP83867_SGMIICTL	0x00D3
>  #define DP83867_10M_SGMII_CFG   0x016F
> @@ -65,6 +75,13 @@
>  /* SGMIICTL bits */
>  #define DP83867_SGMII_TYPE		BIT(14)
>  
> +/* RXFCFG bits*/
> +#define DP83867_WOL_MAGIC_EN		BIT(0)
> +#define DP83867_WOL_BCAST_EN		BIT(2)
> +#define DP83867_WOL_UCAST_EN		BIT(4)
> +#define DP83867_WOL_SEC_EN		BIT(5)
> +#define DP83867_WOL_ENH_MAC		BIT(7)
> +
>  /* STRAP_STS1 bits */
>  #define DP83867_STRAP_STS1_RESERVED		BIT(11)
>  
> @@ -126,6 +143,115 @@ static int dp83867_ack_interrupt(struct phy_device *phydev)
>  	return 0;
>  }
>  
> +static int dp83867_set_wol(struct phy_device *phydev,
> +			   struct ethtool_wolinfo *wol)
> +{
> +	struct net_device *ndev = phydev->attached_dev;
> +	u16 val_rxcfg, val_micr;
> +	const u8 *mac;
> +
> +	val_rxcfg = phy_read_mmd(phydev, DP83867_DEVADDR, DP83867_RXFCFG);
> +	val_micr = phy_read(phydev, MII_DP83867_MICR);
> +
> +	if (wol->wolopts & (WAKE_MAGIC | WAKE_MAGICSECURE | WAKE_UCAST |
> +			    WAKE_BCAST)) {
> +		val_rxcfg |= DP83867_WOL_ENH_MAC;
> +		val_micr |= MII_DP83867_MICR_WOL_INT_EN;
> +
> +		if (wol->wolopts & WAKE_MAGIC) {
> +			mac = (const u8 *)ndev->dev_addr;
> +
> +			if (!is_valid_ether_addr(mac))
> +				return -EINVAL;
> +
> +			phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RXFPMD1,
> +				      (mac[1] << 8 | mac[0]));
> +			phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RXFPMD2,
> +				      (mac[3] << 8 | mac[2]));
> +			phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RXFPMD3,
> +				      (mac[5] << 8 | mac[4]));
> +
> +			val_rxcfg |= DP83867_WOL_MAGIC_EN;
> +		} else {
> +			val_rxcfg &= ~DP83867_WOL_MAGIC_EN;
> +		}
> +
> +		if (wol->wolopts & WAKE_MAGICSECURE) {
> +			phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RXFSOP1,
> +				      (wol->sopass[1] << 8) | wol->sopass[0]);
> +			phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RXFSOP1,
> +				      (wol->sopass[3] << 8) | wol->sopass[2]);
> +			phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RXFSOP1,
> +				      (wol->sopass[5] << 8) | wol->sopass[4]);
> +
> +			val_rxcfg |= DP83867_WOL_SEC_EN;
> +		} else {
> +			val_rxcfg &= ~DP83867_WOL_SEC_EN;
> +		}
> +
> +		if (wol->wolopts & WAKE_UCAST)
> +			val_rxcfg |= DP83867_WOL_UCAST_EN;
> +		else
> +			val_rxcfg &= ~DP83867_WOL_UCAST_EN;
> +
> +		if (wol->wolopts & WAKE_BCAST)
> +			val_rxcfg |= DP83867_WOL_BCAST_EN;
> +		else
> +			val_rxcfg &= ~DP83867_WOL_BCAST_EN;
> +	} else {
> +		val_rxcfg &= ~DP83867_WOL_ENH_MAC;
> +		val_micr &= ~MII_DP83867_MICR_WOL_INT_EN;
> +	}
> +
> +	phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RXFCFG, val_rxcfg);
> +	phy_write(phydev, MII_DP83867_MICR, val_micr);
> +
> +	return 0;
> +}
> +
> +static void dp83867_get_wol(struct phy_device *phydev,
> +			    struct ethtool_wolinfo *wol)
> +{
> +	u16 value, sopass_val;
> +
> +	wol->supported = (WAKE_UCAST | WAKE_BCAST | WAKE_MAGIC |
> +			WAKE_MAGICSECURE);
> +	wol->wolopts = 0;
> +
> +	value = phy_read_mmd(phydev, DP83867_DEVADDR, DP83867_RXFCFG);
> +
> +	if (value & DP83867_WOL_UCAST_EN)
> +		wol->wolopts |= WAKE_UCAST;
> +
> +	if (value & DP83867_WOL_BCAST_EN)
> +		wol->wolopts |= WAKE_BCAST;
> +
> +	if (value & DP83867_WOL_MAGIC_EN)
> +		wol->wolopts |= WAKE_MAGIC;
> +
> +	if (value & DP83867_WOL_SEC_EN) {
> +		sopass_val = phy_read_mmd(phydev, DP83867_DEVADDR,
> +					  DP83867_RXFSOP1);
> +		wol->sopass[0] = (sopass_val & 0xff);
> +		wol->sopass[1] = (sopass_val >> 8);
> +
> +		sopass_val = phy_read_mmd(phydev, DP83867_DEVADDR,
> +					  DP83867_RXFSOP2);
> +		wol->sopass[2] = (sopass_val & 0xff);
> +		wol->sopass[3] = (sopass_val >> 8);
> +
> +		sopass_val = phy_read_mmd(phydev, DP83867_DEVADDR,
> +					  DP83867_RXFSOP3);
> +		wol->sopass[4] = (sopass_val & 0xff);
> +		wol->sopass[5] = (sopass_val >> 8);
> +
> +		wol->wolopts |= WAKE_MAGICSECURE;
> +	}
> +
> +	if (!(value & DP83867_WOL_ENH_MAC))
> +		wol->wolopts = 0;
> +}
> +
>  static int dp83867_config_intr(struct phy_device *phydev)
>  {
>  	int micr_status;
> @@ -463,6 +589,9 @@ static struct phy_driver dp83867_driver[] = {
>  		.config_init	= dp83867_config_init,
>  		.soft_reset	= dp83867_phy_reset,
>  
> +		.get_wol	= dp83867_get_wol,
> +		.set_wol	= dp83867_set_wol,
> +
>  		/* IRQ related */
>  		.ack_interrupt	= dp83867_ack_interrupt,
>  		.config_intr	= dp83867_config_intr,
