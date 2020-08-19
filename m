Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 057F3249289
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 03:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgHSBvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 21:51:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60438 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726372AbgHSBvW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 21:51:22 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k8DG4-00A1BH-A6; Wed, 19 Aug 2020 03:51:20 +0200
Date:   Wed, 19 Aug 2020 03:51:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andre Edich <andre.edich@microchip.com>
Cc:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        steve.glendinning@shawell.net, Parthiban.Veerasooran@microchip.com
Subject: Re: [PATCH net-next v3 3/3] smsc95xx: add phylib support
Message-ID: <20200819015120.GA2347062@lunn.ch>
References: <20200818111127.176422-1-andre.edich@microchip.com>
 <20200818111127.176422-4-andre.edich@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818111127.176422-4-andre.edich@microchip.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 01:11:27PM +0200, Andre Edich wrote:
> Generally, each PHY has their own configuration and it can be done
> through an external PHY driver.  The smsc95xx driver uses only the
> hard-coded internal PHY configuration.
> 
> This patch adds phylib support to probe external PHY drivers for
> configuring external PHYs.
> 
> The MDI-X configuration for the internal PHYs moves from
> drivers/net/usb/smsc95xx.c to drivers/net/phy/smsc.c.

Please spit this into a separate patch. If this changes causes any
regression in the PHY driver it will be easier to spot.

> 
> Signed-off-by: Andre Edich <andre.edich@microchip.com>
> ---
>  drivers/net/phy/smsc.c     |  67 +++++++
>  drivers/net/usb/Kconfig    |   2 +
>  drivers/net/usb/smsc95xx.c | 389 +++++++++++++------------------------
>  3 files changed, 203 insertions(+), 255 deletions(-)
> 
> diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
> index 74568ae16125..be24cd359202 100644
> --- a/drivers/net/phy/smsc.c
> +++ b/drivers/net/phy/smsc.c
> @@ -21,6 +21,17 @@
>  #include <linux/netdevice.h>
>  #include <linux/smscphy.h>
>  
> +/* Vendor-specific PHY Definitions */
> +/* EDPD NLP / crossover time configuration */
> +#define PHY_EDPD_CONFIG			16
> +#define PHY_EDPD_CONFIG_EXT_CROSSOVER_	0x0001
> +
> +/* Control/Status Indication Register */
> +#define SPECIAL_CTRL_STS		27
> +#define SPECIAL_CTRL_STS_OVRRD_AMDIX_	0x8000
> +#define SPECIAL_CTRL_STS_AMDIX_ENABLE_	0x4000
> +#define SPECIAL_CTRL_STS_AMDIX_STATE_	0x2000
> +
>  struct smsc_hw_stat {
>  	const char *string;
>  	u8 reg;
> @@ -96,6 +107,54 @@ static int lan911x_config_init(struct phy_device *phydev)
>  	return smsc_phy_ack_interrupt(phydev);
>  }
>  
> +static inline int lan87xx_config_aneg(struct phy_device *phydev)
> +{
> +	int rc;
> +	int val;
> +
> +	switch (phydev->mdix_ctrl) {
> +	case ETH_TP_MDI:
> +		val = SPECIAL_CTRL_STS_OVRRD_AMDIX_;
> +		break;
> +	case ETH_TP_MDI_X:
> +		val = SPECIAL_CTRL_STS_OVRRD_AMDIX_ |
> +			SPECIAL_CTRL_STS_AMDIX_STATE_;
> +		break;
> +	case ETH_TP_MDI_AUTO:
> +		val = SPECIAL_CTRL_STS_AMDIX_ENABLE_;
> +		break;
> +	default:
> +		return genphy_config_aneg(phydev);
> +	}
> +
> +	rc = phy_read(phydev, SPECIAL_CTRL_STS);
> +	if (rc < 0)
> +		return rc;
> +
> +	rc &= ~(SPECIAL_CTRL_STS_OVRRD_AMDIX_ |
> +		SPECIAL_CTRL_STS_AMDIX_ENABLE_ |
> +		SPECIAL_CTRL_STS_AMDIX_STATE_);
> +	rc |= val;
> +	phy_write(phydev, SPECIAL_CTRL_STS, rc);
> +
> +	phydev->mdix = phydev->mdix_ctrl;
> +	return genphy_config_aneg(phydev);
> +}
> +
> +static inline int lan87xx_config_aneg_ext(struct phy_device *phydev)
> +{
> +	int rc;
> +
> +	/* Extend Manual AutoMDIX timer */
> +	rc = phy_read(phydev, PHY_EDPD_CONFIG);
> +	if (rc < 0)
> +		return rc;
> +
> +	rc |= PHY_EDPD_CONFIG_EXT_CROSSOVER_;
> +	phy_write(phydev, PHY_EDPD_CONFIG, rc);
> +	return lan87xx_config_aneg(phydev);
> +}
> +
>  /*
>   * The LAN87xx suffers from rare absence of the ENERGYON-bit when Ethernet cable
>   * plugs in while LAN87xx is in Energy Detect Power-Down mode. This leads to
> @@ -250,6 +309,9 @@ static struct phy_driver smsc_phy_driver[] = {
>  	.suspend	= genphy_suspend,
>  	.resume		= genphy_resume,
>  }, {
> +	/* This covers internal PHY (phy_id: 0x0007C0C3) for
> +	 * LAN9500 (PID: 0x9500), LAN9514 (PID: 0xec00), LAN9505 (PID: 0x9505)
> +	 */
>  	.phy_id		= 0x0007c0c0, /* OUI=0x00800f, Model#=0x0c */
>  	.phy_id_mask	= 0xfffffff0,
>  	.name		= "SMSC LAN8700",
> @@ -262,6 +324,7 @@ static struct phy_driver smsc_phy_driver[] = {
>  	.read_status	= lan87xx_read_status,
>  	.config_init	= smsc_phy_config_init,
>  	.soft_reset	= smsc_phy_reset,
> +	.config_aneg	= lan87xx_config_aneg,
>  
>  	/* IRQ related */
>  	.ack_interrupt	= smsc_phy_ack_interrupt,
> @@ -293,6 +356,9 @@ static struct phy_driver smsc_phy_driver[] = {
>  	.suspend	= genphy_suspend,
>  	.resume		= genphy_resume,
>  }, {
> +	/* This covers internal PHY (phy_id: 0x0007C0F0) for
> +	 * LAN9500A (PID: 0x9E00), LAN9505A (PID: 0x9E01)
> +	 */
>  	.phy_id		= 0x0007c0f0, /* OUI=0x00800f, Model#=0x0f */
>  	.phy_id_mask	= 0xfffffff0,
>  	.name		= "SMSC LAN8710/LAN8720",
> @@ -306,6 +372,7 @@ static struct phy_driver smsc_phy_driver[] = {
>  	.read_status	= lan87xx_read_status,
>  	.config_init	= smsc_phy_config_init,
>  	.soft_reset	= smsc_phy_reset,
> +	.config_aneg	= lan87xx_config_aneg_ext,

As Jakub said, don't use inline in C code. Also, it is pointless
because you assign the address of the function to .config_aneg, so it
cannot inline it.

       Andrew
