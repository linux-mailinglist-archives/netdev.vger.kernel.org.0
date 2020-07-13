Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9740521BFF7
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 00:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgGJWgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 18:36:16 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:60623 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbgGJWgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 18:36:16 -0400
X-Originating-IP: 90.65.108.121
Received: from localhost (lfbn-lyo-1-1676-121.w90-65.abo.wanadoo.fr [90.65.108.121])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 1D5921BF203;
        Fri, 10 Jul 2020 22:36:10 +0000 (UTC)
Date:   Sat, 11 Jul 2020 00:36:10 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        David Jander <david@protonic.nl>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v3] net: phy: micrel: add phy-mode support for
 the KSZ9031 PHY
Message-ID: <20200710223610.GC3759@piout.net>
References: <20200422072137.8517-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422072137.8517-1-o.rempel@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij,

This patch breaks Ethernet on the sama5d3 Xplained and I have not been
able to unbreak it. Note tat If you want to test, networking has been
further broken in v5.8-rc1 but should be properly working in v5.8-rc4
after reverting this patch.

On 22/04/2020 09:21:37+0200, Oleksij Rempel wrote:
> Add support for following phy-modes: rgmii, rgmii-id, rgmii-txid, rgmii-rxid.
> 
> This PHY has an internal RX delay of 1.2ns and no delay for TX.
> 
> The pad skew registers allow to set the total TX delay to max 1.38ns and
> the total RX delay to max of 2.58ns (configurable 1.38ns + build in
> 1.2ns) and a minimal delay of 0ns.
> 
> According to the RGMII v1.3 specification the delay provided by PCB traces
> should be between 1.5ns and 2.0ns. The RGMII v2.0 allows to provide this
> delay by MAC or PHY. So, we configure this PHY to the best values we can
> get by this HW: TX delay to 1.38ns (max supported value) and RX delay to
> 1.80ns (best calculated delay)
> 
> The phy-modes can still be fine tuned/overwritten by *-skew-ps
> device tree properties described in:
> Documentation/devicetree/bindings/net/micrel-ksz90x1.txt
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
> changes v3:
> - change delay on RX line to 1.80ns
> - add warning if *-skew-ps properties are used together with not rgmii
>   mode. 
> 
> changes v2:
> - change RX_ID value from 0x1a to 0xa. The overflow bit was detected by
>   FIELD_PREP() build check.
>   Reported-by: kbuild test robot <lkp@intel.com>
> 
>  drivers/net/phy/micrel.c | 128 +++++++++++++++++++++++++++++++++++++--
>  1 file changed, 123 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index 05d20343b8161..045783eb4bc70 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -19,6 +19,7 @@
>   *			 ksz9477
>   */
>  
> +#include <linux/bitfield.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/phy.h>
> @@ -490,9 +491,50 @@ static int ksz9021_config_init(struct phy_device *phydev)
>  
>  /* MMD Address 0x2 */
>  #define MII_KSZ9031RN_CONTROL_PAD_SKEW	4
> +#define MII_KSZ9031RN_RX_CTL_M		GENMASK(7, 4)
> +#define MII_KSZ9031RN_TX_CTL_M		GENMASK(3, 0)
> +
>  #define MII_KSZ9031RN_RX_DATA_PAD_SKEW	5
> +#define MII_KSZ9031RN_RXD3		GENMASK(15, 12)
> +#define MII_KSZ9031RN_RXD2		GENMASK(11, 8)
> +#define MII_KSZ9031RN_RXD1		GENMASK(7, 4)
> +#define MII_KSZ9031RN_RXD0		GENMASK(3, 0)
> +
>  #define MII_KSZ9031RN_TX_DATA_PAD_SKEW	6
> +#define MII_KSZ9031RN_TXD3		GENMASK(15, 12)
> +#define MII_KSZ9031RN_TXD2		GENMASK(11, 8)
> +#define MII_KSZ9031RN_TXD1		GENMASK(7, 4)
> +#define MII_KSZ9031RN_TXD0		GENMASK(3, 0)
> +
>  #define MII_KSZ9031RN_CLK_PAD_SKEW	8
> +#define MII_KSZ9031RN_GTX_CLK		GENMASK(9, 5)
> +#define MII_KSZ9031RN_RX_CLK		GENMASK(4, 0)
> +
> +/* KSZ9031 has internal RGMII_IDRX = 1.2ns and RGMII_IDTX = 0ns. To
> + * provide different RGMII options we need to configure delay offset
> + * for each pad relative to build in delay.
> + */
> +/* keep rx as "No delay adjustment" and set rx_clk to +0.60ns to get delays of
> + * 1.80ns
> + */
> +#define RX_ID				0x7
> +#define RX_CLK_ID			0x19
> +
> +/* set rx to +0.30ns and rx_clk to -0.90ns to compensate the
> + * internal 1.2ns delay.
> + */
> +#define RX_ND				0xc
> +#define RX_CLK_ND			0x0
> +
> +/* set tx to -0.42ns and tx_clk to +0.96ns to get 1.38ns delay */
> +#define TX_ID				0x0
> +#define TX_CLK_ID			0x1f
> +
> +/* set tx and tx_clk to "No delay adjustment" to keep 0ns
> + * dealy
> + */
> +#define TX_ND				0x7
> +#define TX_CLK_ND			0xf
>  
>  /* MMD Address 0x1C */
>  #define MII_KSZ9031RN_EDPD		0x23
> @@ -501,7 +543,8 @@ static int ksz9021_config_init(struct phy_device *phydev)
>  static int ksz9031_of_load_skew_values(struct phy_device *phydev,
>  				       const struct device_node *of_node,
>  				       u16 reg, size_t field_sz,
> -				       const char *field[], u8 numfields)
> +				       const char *field[], u8 numfields,
> +				       bool *update)
>  {
>  	int val[4] = {-1, -2, -3, -4};
>  	int matches = 0;
> @@ -517,6 +560,8 @@ static int ksz9031_of_load_skew_values(struct phy_device *phydev,
>  	if (!matches)
>  		return 0;
>  
> +	*update |= true;
> +
>  	if (matches < numfields)
>  		newval = phy_read_mmd(phydev, 2, reg);
>  	else
> @@ -565,6 +610,67 @@ static int ksz9031_enable_edpd(struct phy_device *phydev)
>  			     reg | MII_KSZ9031RN_EDPD_ENABLE);
>  }
>  
> +static int ksz9031_config_rgmii_delay(struct phy_device *phydev)
> +{
> +	u16 rx, tx, rx_clk, tx_clk;
> +	int ret;
> +
> +	switch (phydev->interface) {
> +	case PHY_INTERFACE_MODE_RGMII:
> +		tx = TX_ND;
> +		tx_clk = TX_CLK_ND;
> +		rx = RX_ND;
> +		rx_clk = RX_CLK_ND;
> +		break;
> +	case PHY_INTERFACE_MODE_RGMII_ID:
> +		tx = TX_ID;
> +		tx_clk = TX_CLK_ID;
> +		rx = RX_ID;
> +		rx_clk = RX_CLK_ID;
> +		break;
> +	case PHY_INTERFACE_MODE_RGMII_RXID:
> +		tx = TX_ND;
> +		tx_clk = TX_CLK_ND;
> +		rx = RX_ID;
> +		rx_clk = RX_CLK_ID;
> +		break;
> +	case PHY_INTERFACE_MODE_RGMII_TXID:
> +		tx = TX_ID;
> +		tx_clk = TX_CLK_ID;
> +		rx = RX_ND;
> +		rx_clk = RX_CLK_ND;
> +		break;
> +	default:
> +		return 0;
> +	}
> +
> +	ret = phy_write_mmd(phydev, 2, MII_KSZ9031RN_CONTROL_PAD_SKEW,
> +			    FIELD_PREP(MII_KSZ9031RN_RX_CTL_M, rx) |
> +			    FIELD_PREP(MII_KSZ9031RN_TX_CTL_M, tx));
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = phy_write_mmd(phydev, 2, MII_KSZ9031RN_RX_DATA_PAD_SKEW,
> +			    FIELD_PREP(MII_KSZ9031RN_RXD3, rx) |
> +			    FIELD_PREP(MII_KSZ9031RN_RXD2, rx) |
> +			    FIELD_PREP(MII_KSZ9031RN_RXD1, rx) |
> +			    FIELD_PREP(MII_KSZ9031RN_RXD0, rx));
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = phy_write_mmd(phydev, 2, MII_KSZ9031RN_TX_DATA_PAD_SKEW,
> +			    FIELD_PREP(MII_KSZ9031RN_TXD3, tx) |
> +			    FIELD_PREP(MII_KSZ9031RN_TXD2, tx) |
> +			    FIELD_PREP(MII_KSZ9031RN_TXD1, tx) |
> +			    FIELD_PREP(MII_KSZ9031RN_TXD0, tx));
> +	if (ret < 0)
> +		return ret;
> +
> +	return phy_write_mmd(phydev, 2, MII_KSZ9031RN_CLK_PAD_SKEW,
> +			     FIELD_PREP(MII_KSZ9031RN_GTX_CLK, tx_clk) |
> +			     FIELD_PREP(MII_KSZ9031RN_RX_CLK, rx_clk));
> +}
> +
>  static int ksz9031_config_init(struct phy_device *phydev)
>  {
>  	const struct device *dev = &phydev->mdio.dev;
> @@ -597,21 +703,33 @@ static int ksz9031_config_init(struct phy_device *phydev)
>  	} while (!of_node && dev_walker);
>  
>  	if (of_node) {
> +		bool update = false;
> +
> +		if (phy_interface_is_rgmii(phydev)) {
> +			result = ksz9031_config_rgmii_delay(phydev);
> +			if (result < 0)
> +				return result;
> +		}
> +
>  		ksz9031_of_load_skew_values(phydev, of_node,
>  				MII_KSZ9031RN_CLK_PAD_SKEW, 5,
> -				clk_skews, 2);
> +				clk_skews, 2, &update);
>  
>  		ksz9031_of_load_skew_values(phydev, of_node,
>  				MII_KSZ9031RN_CONTROL_PAD_SKEW, 4,
> -				control_skews, 2);
> +				control_skews, 2, &update);
>  
>  		ksz9031_of_load_skew_values(phydev, of_node,
>  				MII_KSZ9031RN_RX_DATA_PAD_SKEW, 4,
> -				rx_data_skews, 4);
> +				rx_data_skews, 4, &update);
>  
>  		ksz9031_of_load_skew_values(phydev, of_node,
>  				MII_KSZ9031RN_TX_DATA_PAD_SKEW, 4,
> -				tx_data_skews, 4);
> +				tx_data_skews, 4, &update);
> +
> +		if (update && phydev->interface != PHY_INTERFACE_MODE_RGMII)
> +			phydev_warn(phydev,
> +				    "*-skew-ps values should be used only with phy-mode = \"rgmii\"\n");
>  
>  		/* Silicon Errata Sheet (DS80000691D or DS80000692D):
>  		 * When the device links in the 1000BASE-T slave mode only,
> -- 
> 2.26.0.rc2
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
