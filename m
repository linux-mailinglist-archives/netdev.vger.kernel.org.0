Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835D71E259F
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 17:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729928AbgEZPjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 11:39:10 -0400
Received: from foss.arm.com ([217.140.110.172]:52384 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729698AbgEZPjK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 11:39:10 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 415B530E;
        Tue, 26 May 2020 08:39:09 -0700 (PDT)
Received: from [192.168.122.166] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 07E323F52E;
        Tue, 26 May 2020 08:39:09 -0700 (PDT)
Subject: Re: [PATCH RFC 6/7] net: phy: split devices_in_package
To:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
References: <20200526142948.GY1551@shell.armlinux.org.uk>
 <E1jdac2-0005sv-W5@rmk-PC.armlinux.org.uk>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <d46d859f-f170-68f5-907f-0470ea9b218f@arm.com>
Date:   Tue, 26 May 2020 10:39:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <E1jdac2-0005sv-W5@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 5/26/20 9:31 AM, Russell King wrote:
> We have two competing requirements for the devices_in_package field.
> We want to use it as a bit array indicating which MMDs are present, but
> we also want to know if the Clause 22 registers are present.
> 
> Since "devices in package" is a term used in the 802.3 specification,
> keep this as the as-specified values read from the PHY, and introduce
> a new member "mmds_present" to indicate which MMDs are actually
> present in the PHY, derived from the "devices in package" value.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>   drivers/net/phy/phy-c45.c    | 4 ++--
>   drivers/net/phy/phy_device.c | 6 +++---
>   drivers/net/phy/phylink.c    | 8 ++++----
>   include/linux/phy.h          | 4 +++-
>   4 files changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
> index 8cd952950a75..4b5805e2bd0e 100644
> --- a/drivers/net/phy/phy-c45.c
> +++ b/drivers/net/phy/phy-c45.c
> @@ -219,7 +219,7 @@ int genphy_c45_read_link(struct phy_device *phydev)
>   	int val, devad;
>   	bool link = true;
>   
> -	if (phydev->c45_ids.devices_in_package & MDIO_DEVS_AN) {
> +	if (phydev->c45_ids.mmds_present & MDIO_DEVS_AN) {
>   		val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_CTRL1);
>   		if (val < 0)
>   			return val;
> @@ -397,7 +397,7 @@ int genphy_c45_pma_read_abilities(struct phy_device *phydev)
>   	int val;
>   
>   	linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, phydev->supported);
> -	if (phydev->c45_ids.devices_in_package & MDIO_DEVS_AN) {
> +	if (phydev->c45_ids.mmds_present & MDIO_DEVS_AN) {
>   		val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_STAT1);
>   		if (val < 0)
>   			return val;
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index a483d79cfc87..1c948bbf4fa0 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -707,9 +707,6 @@ static int get_phy_c45_devs_in_pkg(struct mii_bus *bus, int addr, int dev_addr,
>   		return -EIO;
>   	*devices_in_package |= phy_reg;
>   
> -	/* Bit 0 doesn't represent a device, it indicates c22 regs presence */
> -	*devices_in_package &= ~BIT(0);
> -
>   	return 0;
>   }
>   
> @@ -788,6 +785,8 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
>   	}
>   
>   	c45_ids->devices_in_package = devs_in_pkg;
> +	/* Bit 0 doesn't represent a device, it indicates c22 regs presence */
> +	c45_ids->mmds_present = devs_in_pkg & ~BIT(0);
>   
>   	*phy_id = 0;
>   	return 0;
> @@ -842,6 +841,7 @@ struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
>   	int r;
>   
>   	c45_ids.devices_in_package = 0;
> +	c45_ids.mmds_present = 0;
>   	memset(c45_ids.device_ids, 0xff, sizeof(c45_ids.device_ids));
>   
>   	if (is_c45)
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 6defd5eddd58..b548e0418694 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -1709,11 +1709,11 @@ static int phylink_phy_read(struct phylink *pl, unsigned int phy_id,
>   		case MII_BMSR:
>   		case MII_PHYSID1:
>   		case MII_PHYSID2:
> -			devad = __ffs(phydev->c45_ids.devices_in_package);
> +			devad = __ffs(phydev->c45_ids.mmds_present);
>   			break;
>   		case MII_ADVERTISE:
>   		case MII_LPA:
> -			if (!(phydev->c45_ids.devices_in_package & MDIO_DEVS_AN))
> +			if (!(phydev->c45_ids.mmds_present & MDIO_DEVS_AN))
>   				return -EINVAL;
>   			devad = MDIO_MMD_AN;
>   			if (reg == MII_ADVERTISE)
> @@ -1749,11 +1749,11 @@ static int phylink_phy_write(struct phylink *pl, unsigned int phy_id,
>   		case MII_BMSR:
>   		case MII_PHYSID1:
>   		case MII_PHYSID2:
> -			devad = __ffs(phydev->c45_ids.devices_in_package);
> +			devad = __ffs(phydev->c45_ids.mmds_present);
>   			break;
>   		case MII_ADVERTISE:
>   		case MII_LPA:
> -			if (!(phydev->c45_ids.devices_in_package & MDIO_DEVS_AN))
> +			if (!(phydev->c45_ids.mmds_present & MDIO_DEVS_AN))
>   				return -EINVAL;
>   			devad = MDIO_MMD_AN;
>   			if (reg == MII_ADVERTISE)
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 41c046545354..0d41c710339a 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -354,11 +354,13 @@ enum phy_state {
>   
>   /**
>    * struct phy_c45_device_ids - 802.3-c45 Device Identifiers
> - * @devices_in_package: Bit vector of devices present.
> + * @devices_in_package: IEEE 802.3 devices in package register value.
> + * @mmds_present: bit vector of MMDs present.
>    * @device_ids: The device identifer for each present device.
>    */
>   struct phy_c45_device_ids {
>   	u32 devices_in_package;
> +	u32 mmds_present;
>   	u32 device_ids[8];
>   };

It seems like the majority of the devices_in_package accessors are just 
bit masking for a given MMD/field. The case that has the problem is the 
__ffs() calls which failed to account for this. So why not just fix 
those two cases instead of creating a duplicate field with exactly the 
same data in it minus a bit.





