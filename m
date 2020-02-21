Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00D08168022
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 15:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbgBUOYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 09:24:18 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:57316 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728312AbgBUOYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 09:24:18 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 01LEO4lU085797;
        Fri, 21 Feb 2020 08:24:04 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1582295044;
        bh=15N8zWLORDmnGs7RDBa6ODbKVeHGFcdp+UVeeu3/p+E=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=sMAwRf6n5HWOUKOsawIhxpmOYk3T6wwOcWggB+X7xV1Pv9v9gzmVIBJ2picu0F2Mp
         Tr1bX0sH4KaIpfP1R8fPGFnKn+4AIhgcYq1CZyixIoMJml2Ba4ohQ1OTKuFJmpR9US
         GYoedWU36kRaN8DUeUyR+zTxhLBiR+kaD07XMPeM=
Received: from DFLE102.ent.ti.com (dfle102.ent.ti.com [10.64.6.23])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 01LEO4eO072663
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 21 Feb 2020 08:24:04 -0600
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 21
 Feb 2020 08:24:03 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 21 Feb 2020 08:24:03 -0600
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01LEO2YH007676;
        Fri, 21 Feb 2020 08:24:03 -0600
Subject: Re: [PATCH net-next v3] net: phy: dp83867: Add speed optimization
 feature
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>
CC:     <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200218141130.28825-1-dmurphy@ti.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <f7512515-f684-4086-200c-2b7326183d19@ti.com>
Date:   Fri, 21 Feb 2020 08:18:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200218141130.28825-1-dmurphy@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bump

On 2/18/20 8:11 AM, Dan Murphy wrote:
> Set the speed optimization bit on the DP83867 PHY.
> This feature can also be strapped on the 64 pin PHY devices
> but the 48 pin devices do not have the strap pin available to enable
> this feature in the hardware.  PHY team suggests to have this bit set.
>
> With this bit set the PHY will auto negotiate and report the link
> parameters in the PHYSTS register.  This register provides a single
> location within the register set for quick access to commonly accessed
> information.
>
> In this case when auto negotiation is on the PHY core reads the bits
> that have been configured or if auto negotiation is off the PHY core
> reads the BMCR register and sets the phydev parameters accordingly.
>
> This Giga bit PHY can throttle the speed to 100Mbps or 10Mbps to accomodate a
> 4-wire cable.  If this should occur the PHYSTS register contains the
> current negotiated speed and duplex mode.
>
> In overriding the genphy_read_status the dp83867_read_status will do a
> genphy_read_status to setup the LP and pause bits.  And then the PHYSTS
> register is read and the phydev speed and duplex mode settings are
> updated.
>
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>
> v3 - Add the tunable feature into the driver for downshift.  Change speed optimization
> nomenclature to dwonshift
>
>   drivers/net/phy/dp83867.c | 150 ++++++++++++++++++++++++++++++++++++++
>   1 file changed, 150 insertions(+)
>
> diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
> index 967f57ed0b65..13f7f2d5a2ea 100644
> --- a/drivers/net/phy/dp83867.c
> +++ b/drivers/net/phy/dp83867.c
> @@ -14,6 +14,7 @@
>   #include <linux/delay.h>
>   #include <linux/netdevice.h>
>   #include <linux/etherdevice.h>
> +#include <linux/bitfield.h>
>   
>   #include <dt-bindings/net/ti-dp83867.h>
>   
> @@ -21,6 +22,7 @@
>   #define DP83867_DEVADDR		0x1f
>   
>   #define MII_DP83867_PHYCTRL	0x10
> +#define MII_DP83867_PHYSTS	0x11
>   #define MII_DP83867_MICR	0x12
>   #define MII_DP83867_ISR		0x13
>   #define DP83867_CFG2		0x14
> @@ -118,6 +120,24 @@
>   #define DP83867_IO_MUX_CFG_CLK_O_SEL_MASK	(0x1f << 8)
>   #define DP83867_IO_MUX_CFG_CLK_O_SEL_SHIFT	8
>   
> +/* PHY STS bits */
> +#define DP83867_PHYSTS_1000			BIT(15)
> +#define DP83867_PHYSTS_100			BIT(14)
> +#define DP83867_PHYSTS_DUPLEX			BIT(13)
> +#define DP83867_PHYSTS_LINK			BIT(10)
> +
> +/* CFG2 bits */
> +#define DP83867_DOWNSHIFT_EN		(BIT(8) | BIT(9))
> +#define DP83867_DOWNSHIFT_ATTEMPT_MASK	(BIT(10) | BIT(11))
> +#define DP83867_DOWNSHIFT_1_COUNT_VAL	0
> +#define DP83867_DOWNSHIFT_2_COUNT_VAL	1
> +#define DP83867_DOWNSHIFT_4_COUNT_VAL	2
> +#define DP83867_DOWNSHIFT_8_COUNT_VAL	3
> +#define DP83867_DOWNSHIFT_1_COUNT	1
> +#define DP83867_DOWNSHIFT_2_COUNT	2
> +#define DP83867_DOWNSHIFT_4_COUNT	4
> +#define DP83867_DOWNSHIFT_8_COUNT	8
> +
>   /* CFG3 bits */
>   #define DP83867_CFG3_INT_OE			BIT(7)
>   #define DP83867_CFG3_ROBUST_AUTO_MDIX		BIT(9)
> @@ -287,6 +307,126 @@ static int dp83867_config_intr(struct phy_device *phydev)
>   	return phy_write(phydev, MII_DP83867_MICR, micr_status);
>   }
>   
> +static int dp83867_read_status(struct phy_device *phydev)
> +{
> +	int status = phy_read(phydev, MII_DP83867_PHYSTS);
> +	int ret;
> +
> +	ret = genphy_read_status(phydev);
> +	if (ret)
> +		return ret;
> +
> +	if (status < 0)
> +		return status;
> +
> +	if (status & DP83867_PHYSTS_DUPLEX)
> +		phydev->duplex = DUPLEX_FULL;
> +	else
> +		phydev->duplex = DUPLEX_HALF;
> +
> +	if (status & DP83867_PHYSTS_1000)
> +		phydev->speed = SPEED_1000;
> +	else if (status & DP83867_PHYSTS_100)
> +		phydev->speed = SPEED_100;
> +	else
> +		phydev->speed = SPEED_10;
> +
> +	return 0;
> +}
> +
> +static int dp83867_get_downshift(struct phy_device *phydev, u8 *data)
> +{
> +	int val, cnt, enable, count;
> +
> +	val = phy_read(phydev, DP83867_CFG2);
> +	if (val < 0)
> +		return val;
> +
> +	enable = FIELD_GET(DP83867_DOWNSHIFT_EN, val);
> +	cnt = FIELD_GET(DP83867_DOWNSHIFT_ATTEMPT_MASK, val);
> +
> +	switch (cnt) {
> +	case DP83867_DOWNSHIFT_1_COUNT_VAL:
> +		count = DP83867_DOWNSHIFT_1_COUNT;
> +		break;
> +	case DP83867_DOWNSHIFT_2_COUNT_VAL:
> +		count = DP83867_DOWNSHIFT_2_COUNT;
> +		break;
> +	case DP83867_DOWNSHIFT_4_COUNT_VAL:
> +		count = DP83867_DOWNSHIFT_4_COUNT;
> +		break;
> +	case DP83867_DOWNSHIFT_8_COUNT_VAL:
> +		count = DP83867_DOWNSHIFT_8_COUNT;
> +		break;
> +	default:
> +		return -EINVAL;
> +	};
> +
> +	*data = enable ? count : DOWNSHIFT_DEV_DISABLE;
> +
> +	return 0;
> +}
> +
> +static int dp83867_set_downshift(struct phy_device *phydev, u8 cnt)
> +{
> +	int val, count;
> +
> +	if (cnt > DP83867_DOWNSHIFT_8_COUNT)
> +		return -E2BIG;
> +
> +	if (!cnt)
> +		return phy_clear_bits(phydev, DP83867_CFG2,
> +				      DP83867_DOWNSHIFT_EN);
> +
> +	switch (cnt) {
> +		case DP83867_DOWNSHIFT_1_COUNT:
> +			count = DP83867_DOWNSHIFT_1_COUNT_VAL;
> +			break;
> +		case DP83867_DOWNSHIFT_2_COUNT:
> +			count = DP83867_DOWNSHIFT_2_COUNT_VAL;
> +			break;
> +		case DP83867_DOWNSHIFT_4_COUNT:
> +			count = DP83867_DOWNSHIFT_4_COUNT_VAL;
> +			break;
> +		case DP83867_DOWNSHIFT_8_COUNT:
> +			count = DP83867_DOWNSHIFT_8_COUNT_VAL;
> +			break;
> +		default:
> +			phydev_err(phydev,
> +				   "Downshift count must be 1, 2, 4 or 8\n");
> +			return -EINVAL;
> +	};
> +
> +	val = DP83867_DOWNSHIFT_EN;
> +	val |= FIELD_PREP(DP83867_DOWNSHIFT_ATTEMPT_MASK, count);
> +
> +	return phy_modify(phydev, DP83867_CFG2,
> +			  DP83867_DOWNSHIFT_EN | DP83867_DOWNSHIFT_ATTEMPT_MASK,
> +			  val);
> +}
> +
> +static int dp83867_get_tunable(struct phy_device *phydev,
> +				struct ethtool_tunable *tuna, void *data)
> +{
> +	switch (tuna->id) {
> +	case ETHTOOL_PHY_DOWNSHIFT:
> +		return dp83867_get_downshift(phydev, data);
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +
> +static int dp83867_set_tunable(struct phy_device *phydev,
> +				struct ethtool_tunable *tuna, const void *data)
> +{
> +	switch (tuna->id) {
> +	case ETHTOOL_PHY_DOWNSHIFT:
> +		return dp83867_set_downshift(phydev, *(const u8 *)data);
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +
>   static int dp83867_config_port_mirroring(struct phy_device *phydev)
>   {
>   	struct dp83867_private *dp83867 =
> @@ -467,6 +607,12 @@ static int dp83867_config_init(struct phy_device *phydev)
>   	int ret, val, bs;
>   	u16 delay;
>   
> +	/* Force speed optimization for the PHY even if it strapped */
> +	ret = phy_modify(phydev, DP83867_CFG2, DP83867_DOWNSHIFT_EN,
> +			 DP83867_DOWNSHIFT_EN);
> +	if (ret)
> +		return ret;
> +
>   	ret = dp83867_verify_rgmii_cfg(phydev);
>   	if (ret)
>   		return ret;
> @@ -655,6 +801,10 @@ static struct phy_driver dp83867_driver[] = {
>   		.config_init	= dp83867_config_init,
>   		.soft_reset	= dp83867_phy_reset,
>   
> +		.read_status	= dp83867_read_status,
> +		.get_tunable	= dp83867_get_tunable,
> +		.set_tunable	= dp83867_set_tunable,
> +
>   		.get_wol	= dp83867_get_wol,
>   		.set_wol	= dp83867_set_wol,
>   
