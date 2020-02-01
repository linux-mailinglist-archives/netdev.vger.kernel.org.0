Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F229514FA19
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 20:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgBATIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 14:08:23 -0500
Received: from foss.arm.com ([217.140.110.172]:43378 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbgBATIW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Feb 2020 14:08:22 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4BC2BFEC;
        Sat,  1 Feb 2020 11:08:22 -0800 (PST)
Received: from [192.168.122.164] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 032B73F68E;
        Sat,  1 Feb 2020 11:08:21 -0800 (PST)
Subject: Re: [PATCH 3/6] net: bcmgenet: enable automatic phy discovery
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, opendmb@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, wahrenst@gmx.net,
        hkallweit1@gmail.com
References: <20200201074625.8698-1-jeremy.linton@arm.com>
 <20200201074625.8698-4-jeremy.linton@arm.com> <20200201152518.GI9639@lunn.ch>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <608e7fab-69a3-700d-bfcf-88e5711ce58f@arm.com>
Date:   Sat, 1 Feb 2020 13:07:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200201152518.GI9639@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

First thanks for looking at this!

On 2/1/20 9:25 AM, Andrew Lunn wrote:
> On Sat, Feb 01, 2020 at 01:46:22AM -0600, Jeremy Linton wrote:
>> The unimac mdio driver falls back to scanning the
>> entire bus if its given an appropriate mask. In ACPI
>> mode we expect that the system is well behaved and
>> conforms to recent versions of the specification.
>>
>> We then utilize phy_find_first(), and
>> phy_connect_direct() to find and attach to the
>> discovered phy during net_device open.
>>
>> Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
>> ---
>>   drivers/net/ethernet/broadcom/genet/bcmmii.c | 40 +++++++++++++++++---
>>   1 file changed, 34 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
>> index 2049f8218589..f3271975b375 100644
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
>> @@ -311,7 +311,9 @@ int bcmgenet_mii_config(struct net_device *dev, bool init)
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
>> @@ -334,7 +336,27 @@ int bcmgenet_mii_probe(struct net_device *dev)
>>   			return -ENODEV;
>>   		}
>>   	} else {
>> -		phydev = dev->phydev;
>> +		if (has_acpi_companion(kdev)) {
>> +			char mdio_bus_id[MII_BUS_ID_SIZE];
>> +			struct mii_bus *unimacbus;
>> +
>> +			snprintf(mdio_bus_id, MII_BUS_ID_SIZE, "%s-%d",
>> +				 UNIMAC_MDIO_DRV_NAME, priv->pdev->id);
>> +
>> +			unimacbus = mdio_find_bus(mdio_bus_id);
>> +			if (!unimacbus) {
>> +				pr_err("Unable to find mii\n");
>> +				return -ENODEV;
>> +			}
>> +			phydev = phy_find_first(unimacbus);
>> +			put_device(&unimacbus->dev);
>> +			if (!phydev) {
>> +				pr_err("Unable to find PHY\n");
>> +				return -ENODEV;
> 
> Hi Jeremy
> 
> phy_find_first() is not recommended. Only use it if you have no other
> option. If the hardware is more complex, two PHYs on one bus, you are
> going to have a problem. So i suggest this is used only for PCI cards
> where the hardware is very fixed, and there is only ever one MAC and
> PHY on the PCI card. When you do have this split between MAC and MDIO
> bus, each being independent devices, it is more likely that you do
> have multiple PHYs on one shared MDIO bus.

Understood.

> 
> In the DT world, you use a phy-handle to point to the PHY node in the
> device tree. Does ACPI have the same concept, a pointer to some other
> device in ACPI?

There aren't a lot of good options here. ACPI is mostly a power mgmt 
abstraction and is directly silent on this topic. So while it can be 
quite descriptive like DT, frequently choosing to use a bunch of DT 
properties in ACPI _DSD methods is a mistake. Both for cross OS booting 
as well as long term support. Similar silence from SBSA, which attempts 
to setup some guide rails for situations like this. I think that is 
because there aren't any non-obsolete industry standards for NICs.

So, in an attempt to fall back on the idea that the hardware should be 
self describing, and it shouldn't be involving the system firmware in 
basic device specific introspection I've been trying to avoid the use of 
any DSD properties. In the majority of cases (including DT) these 
properties aren't being auto-detected by the firmware either, they are 
just being hard-coded into DT or DSDT tables.

Part of the arm standardization effort has been to clamp down on all the 
creative ways that these machines can be built. It seems a guide rail 
that says for this adapter it must have a MDIO bus per MAC for ACPI 
support as though it were on PCI isn't unreasonable. Another easily 
understood one, might be to assign the PHY's the the same order as the 
MAC's UIDs if there were a shared bus (less ideal without example hardware).

I'm not really sure what the right answer here is, but I like to avoid 
hardcoding DT properties in DSD unless there simply isn't an alternative.

