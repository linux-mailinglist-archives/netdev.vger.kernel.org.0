Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE6081473DD
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 23:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729406AbgAWWcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 17:32:46 -0500
Received: from foss.arm.com ([217.140.110.172]:44900 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728057AbgAWWcp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 17:32:45 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AC233328;
        Thu, 23 Jan 2020 14:32:44 -0800 (PST)
Received: from [192.168.122.166] (unknown [10.118.28.54])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6F5DE3F68E;
        Thu, 23 Jan 2020 14:32:44 -0800 (PST)
Subject: Re: [RFC 1/2] net: bcmgenet: Initial bcmgenet ACPI support
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     opendmb@gmail.com, davem@davemloft.net,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, wahrenst@gmx.net,
        Andrew Lunn <andrew@lunn.ch>
References: <20200123060823.1902366-1-jeremy.linton@arm.com>
 <20200123060823.1902366-2-jeremy.linton@arm.com>
 <27337e71-1349-4819-7fe4-c6ecfed522cc@gmail.com>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <db42c0b5-04f8-72fc-cc9e-05d0f513ac5f@arm.com>
Date:   Thu, 23 Jan 2020 16:32:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <27337e71-1349-4819-7fe4-c6ecfed522cc@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

First, thanks for taking a look at this.

On 1/23/20 3:22 PM, Florian Fainelli wrote:
> On 1/22/20 10:08 PM, Jeremy Linton wrote:
>> The rpi4 is capable of booting in ACPI mode with the latest
>> edk2-platform commits. As such, it would be helpful if the genet
>> platform device were usable.
>>
>> To achive this we convert some of the of_ calls to device_ and
>> add the ACPI id module table, and tweak the phy connection code
>> to use phy_connect() in the ACPI path.
> 
> This seems reasonable to me at first glance, although I would be
> splitting the bcmgenet.c changes from the bcmmii.c for clarity.

Sure.

> 
> There are some more specific comments below.
> 
>>
>> Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
>> ---
>>   .../net/ethernet/broadcom/genet/bcmgenet.c    | 19 +++--
>>   drivers/net/ethernet/broadcom/genet/bcmmii.c  | 76 ++++++++++++-------
>>   2 files changed, 63 insertions(+), 32 deletions(-)
>>

(trimming some)

>> diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
>> index 6392a2530183..054be1eaa1ae 100644
>> --- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
>> +++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
>> @@ -5,7 +5,7 @@
>>    * Copyright (c) 2014-2017 Broadcom
>>    */
>>   
>> -
>> +#include <linux/acpi.h>
>>   #include <linux/types.h>
>>   #include <linux/delay.h>
>>   #include <linux/wait.h>
>> @@ -308,10 +308,21 @@ int bcmgenet_mii_config(struct net_device *dev, bool init)
>>   	return 0;
>>   }
>>   
>> +static void bcmgenet_phy_name(char *phy_name, int mdid, int phid)
>> +{
>> +	char mdio_bus_id[MII_BUS_ID_SIZE];
>> +
>> +	snprintf(mdio_bus_id, MII_BUS_ID_SIZE, "%s-%d",
>> +		 UNIMAC_MDIO_DRV_NAME, mdid);
>> +	snprintf(phy_name, MII_BUS_ID_SIZE, PHY_ID_FMT, mdio_bus_id, phid);
>> +}
>> +
>>   int bcmgenet_mii_probe(struct net_device *dev)
>>   {
>>   	struct bcmgenet_priv *priv = netdev_priv(dev);
>> -	struct device_node *dn = priv->pdev->dev.of_node;
>> +	struct device *kdev = &priv->pdev->dev;
>> +	struct device_node *dn = kdev->of_node;
>> +
>>   	struct phy_device *phydev;
>>   	u32 phy_flags = 0;
>>   	int ret;
>> @@ -333,6 +344,16 @@ int bcmgenet_mii_probe(struct net_device *dev)
>>   			pr_err("could not attach to PHY\n");
>>   			return -ENODEV;
>>   		}
>> +	} else if (has_acpi_companion(kdev)) {
>> +		char phy_name[MII_BUS_ID_SIZE + 3];
>> +
>> +		bcmgenet_phy_name(phy_name,  priv->pdev->id, 1);
> 
> There is no guarantee that 1 is valid other than for the current
> Raspberry Pi 4 design that we have in the wild, would ACPI be used in
> the future with other designs, this would likely be different. Can you
> find a way to communicate that address via appropriate firmware properties?

Your right, that "1" seems like it should be dynamic despite a large 
number of these nic drivers hardcoding the phy address.

Another _DSD property could be added, but that likely just moves the 
hardcoding from one place to another. Particularly, given that the 
mdiobus_register() phy scanning is working correctly and the machine 
knows what the phy address is.

AFAIK, The correct choice is something like phy_find_first(), but the 
mii_bus structure is layered down in the unimac module's private data, 
which we could retrieve, but that would be really ugly.

There is of_mdio_find_bus(), but that doesn't apply either. A generic 
mdio_find_bus() that takes the bus name string, or maybe the parent 
device and does the bus_find_device itself would be helpful.

Suggestions?


> 
>> +		phydev = phy_connect(dev, phy_name, bcmgenet_mii_setup,
>> +				     priv->phy_interface);
>> +		if (!IS_ERR(phydev))
>> +			phydev->dev_flags = phy_flags;
>> +		else
>> +			return -ENODEV;
>>   	} else {
>>   		phydev = dev->phydev;
>>   		phydev->dev_flags = phy_flags;
>> @@ -435,6 +456,7 @@ static int bcmgenet_mii_register(struct bcmgenet_priv *priv)
>>   	ppd.wait_func = bcmgenet_mii_wait;
>>   	ppd.wait_func_data = priv;
>>   	ppd.bus_name = "bcmgenet MII bus";
>> +	ppd.phy_mask = ~0;
> 
> This is going to be breaking PHY scanning for the platform_data case, so
> maybe something like:

Does it? I thought it was being reset in bcmgenet_mii_pdata_init(). I 
guess I don't fully understand the what happens in PHY_INTERFACE_MODE_MOCA.

> 
> 	if (acpi_has_companion())
> 		ppd.phy_mask = ~BIT(acpi_phy_id);
> 
> or something like that?

Sure, if nothing else I can wrap the mask in if (acpi) though, as I 
mentioned above I've got some reservations about picking up the phy id 
from the firmware unless its absolutely required.


> 
>>   
>>   	/* Unimac MDIO bus controller starts at UniMAC offset + MDIO_CMD
>>   	 * and is 2 * 32-bits word long, 8 bytes total.
>> @@ -477,12 +499,28 @@ static int bcmgenet_mii_register(struct bcmgenet_priv *priv)
>>   	return ret;
>>   }
>>   
>> +static int bcmgenet_mii_phy_init(struct bcmgenet_priv *priv)
>> +{
> 
> Maybe name that phy_interface_init(), there is not strictly much PHY
> initialization going on here, just property fetching and internal book
> keeping.
> 

Yup, sounds good.


Thanks, again!
