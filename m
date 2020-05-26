Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5D71E25A1
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 17:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729597AbgEZPjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 11:39:51 -0400
Received: from foss.arm.com ([217.140.110.172]:52400 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729181AbgEZPjv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 11:39:51 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 62EDE30E;
        Tue, 26 May 2020 08:39:50 -0700 (PDT)
Received: from [192.168.122.166] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 21CA33F52E;
        Tue, 26 May 2020 08:39:50 -0700 (PDT)
Subject: Re: [PATCH RFC 5/7] net: phy: set devices_in_package only after
 validation
To:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
References: <20200526142948.GY1551@shell.armlinux.org.uk>
 <E1jdabx-0005sh-T7@rmk-PC.armlinux.org.uk>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <758bd1ef-e7f8-f746-af76-b54c14dd5af2@arm.com>
Date:   Tue, 26 May 2020 10:39:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <E1jdabx-0005sh-T7@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 5/26/20 9:31 AM, Russell King wrote:
> Only set the devices_in_package to a non-zero value if we find a valid
> value for this field, so we avoid leaving it set to e.g. 0x1fffffff.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>   drivers/net/phy/phy_device.c | 17 ++++++++++-------
>   1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index fa9164ac0f3d..a483d79cfc87 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -730,13 +730,13 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
>   			   struct phy_c45_device_ids *c45_ids)
>   {
>   	const int num_ids = ARRAY_SIZE(c45_ids->device_ids);
> -	u32 *devs = &c45_ids->devices_in_package;
> +	u32 devs_in_pkg = 0;
>   	int i, ret, phy_reg;
>   
>   	/* Find first non-zero Devices In package. Device zero is reserved
>   	 * for 802.3 c45 complied PHYs, so don't probe it at first.
>   	 */
> -	for (i = 1; i < MDIO_MMD_NUM && *devs == 0; i++) {
> +	for (i = 1; i < MDIO_MMD_NUM && devs_in_pkg == 0; i++) {
>   		if (i >= 8) {
>   			/* Only probe for the devices-in-package if there
>   			 * is a PHY reporting as present here; this avoids
> @@ -750,22 +750,22 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
>   			if (!ret)
>   				continue;
>   		}
> -		phy_reg = get_phy_c45_devs_in_pkg(bus, addr, i, devs);
> +		phy_reg = get_phy_c45_devs_in_pkg(bus, addr, i, &devs_in_pkg);
>   		if (phy_reg < 0)
>   			return -EIO;
>   	}
>   
> -	if ((*devs & 0x1fffffff) == 0x1fffffff) {
> +	if ((devs_in_pkg & 0x1fffffff) == 0x1fffffff) {
>   		/* If mostly Fs, there is no device there, then let's probe
>   		 * MMD 0, as some 10G PHYs have zero Devices In package,
>   		 * e.g. Cortina CS4315/CS4340 PHY.
>   		 */
> -		phy_reg = get_phy_c45_devs_in_pkg(bus, addr, 0, devs);
> +		phy_reg = get_phy_c45_devs_in_pkg(bus, addr, 0, &devs_in_pkg);
>   		if (phy_reg < 0)
>   			return -EIO;
>   
>   		/* no device there, let's get out of here */
> -		if ((*devs & 0x1fffffff) == 0x1fffffff) {
> +		if ((devs_in_pkg & 0x1fffffff) == 0x1fffffff) {
>   			*phy_id = 0xffffffff;
>   			return 0;
>   		}
> @@ -773,7 +773,7 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
>   
>   	/* Now probe Device Identifiers for each device present. */
>   	for (i = 1; i < num_ids; i++) {
> -		if (!(c45_ids->devices_in_package & (1 << i)))
> +		if (!(devs_in_pkg & (1 << i)))
>   			continue;
>   
>   		phy_reg = mdiobus_c45_read(bus, addr, i, MII_PHYSID1);
> @@ -786,6 +786,9 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
>   			return -EIO;
>   		c45_ids->device_ids[i] |= phy_reg;
>   	}
> +
> +	c45_ids->devices_in_package = devs_in_pkg;
> +
>   	*phy_id = 0;
>   	return 0;
>   }
> 

You have solved the case of 0xFFFFFFFFF devices in package, but It looks 
like the case of devs in package = 0  still gets a successful return 
from this path. Which can still create phys with phy_id=0 and 0 MMDs AFAIK.


