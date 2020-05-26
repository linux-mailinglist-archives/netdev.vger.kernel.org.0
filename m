Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508DB1E2877
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 19:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388784AbgEZRUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 13:20:12 -0400
Received: from foss.arm.com ([217.140.110.172]:54184 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388061AbgEZRUM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 13:20:12 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 357DC1045;
        Tue, 26 May 2020 10:20:11 -0700 (PDT)
Received: from [192.168.122.166] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 070623F52E;
        Tue, 26 May 2020 10:20:10 -0700 (PDT)
Subject: Re: [PATCH RFC 4/7] net: phy: add support for probing MMDs >= 8 for
 devices-in-package
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
References: <20200526142948.GY1551@shell.armlinux.org.uk>
 <E1jdabs-0005sW-P8@rmk-PC.armlinux.org.uk>
 <20200526171454.GH1551@shell.armlinux.org.uk>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <be1dad52-c199-f4d7-fa36-8198151fe2dd@arm.com>
Date:   Tue, 26 May 2020 12:20:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200526171454.GH1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 5/26/20 12:14 PM, Russell King - ARM Linux admin wrote:
> On Tue, May 26, 2020 at 03:31:16PM +0100, Russell King wrote:
>> Add support for probing MMDs above 7 for a valid devices-in-package
>> specifier.
>>
>> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
>> ---
>>   drivers/net/phy/phy_device.c | 39 ++++++++++++++++++++++++++++++++++--
>>   include/linux/phy.h          |  2 ++
>>   2 files changed, 39 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
>> index 0d6b6ca66216..fa9164ac0f3d 100644
>> --- a/drivers/net/phy/phy_device.c
>> +++ b/drivers/net/phy/phy_device.c
>> @@ -659,6 +659,28 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
>>   }
>>   EXPORT_SYMBOL(phy_device_create);
>>   
>> +/* phy_c45_probe_present - checks to see if a MMD is present in the package
>> + * @bus: the target MII bus
>> + * @prtad: PHY package address on the MII bus
>> + * @devad: PHY device (MMD) address
>> + *
>> + * Read the MDIO_STAT2 register, and check whether a device is responding
>> + * at this address.
>> + *
>> + * Returns: negative error number on bus access error, zero if no device
>> + * is responding, or positive if a device is present.
>> + */
>> +static int phy_c45_probe_present(struct mii_bus *bus, int prtad, int devad)
>> +{
>> +	int stat2;
>> +
>> +	stat2 = mdiobus_c45_read(bus, prtad, devad, MDIO_STAT2);
>> +	if (stat2 < 0)
>> +		return stat2;
>> +
>> +	return (stat2 & MDIO_STAT2_DEVPRST) == MDIO_STAT2_DEVPRST_VAL;
>> +}
>> +
>>   /* get_phy_c45_devs_in_pkg - reads a MMD's devices in package registers.
>>    * @bus: the target MII bus
>>    * @addr: PHY address on the MII bus
>> @@ -709,12 +731,25 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
>>   {
>>   	const int num_ids = ARRAY_SIZE(c45_ids->device_ids);
>>   	u32 *devs = &c45_ids->devices_in_package;
>> -	int i, phy_reg;
>> +	int i, ret, phy_reg;
>>   
>>   	/* Find first non-zero Devices In package. Device zero is reserved
>>   	 * for 802.3 c45 complied PHYs, so don't probe it at first.
>>   	 */
>> -	for (i = 1; i < num_ids && *devs == 0; i++) {
>> +	for (i = 1; i < MDIO_MMD_NUM && *devs == 0; i++) {
>> +		if (i >= 8) {
>> +			/* Only probe for the devices-in-package if there
>> +			 * is a PHY reporting as present here; this avoids
>> +			 * picking up on PHYs that implement non-IEEE802.3
>> +			 * compliant register spaces.
>> +			 */
>> +			ret = phy_c45_probe_present(bus, addr, i);
>> +			if (ret < 0)
>> +				return -EIO;
>> +
>> +			if (!ret)
>> +				continue;
>> +		}
> 
> A second look at 802.3, this can't be done for all MMDs (which becomes
> visible when I look at the results from the 88x3310.)  Only MMDs 1, 2,
> 3, 4, 5, 30 and 31 are defined to have this register with the "Device
> Present" bit pair.
> 

I'm not sure it helps, but my thought process following some of the 
discussion last night was:

something to the effect:

	for (i = 1; i < MDIO_MMD_NUM && *devs == 0; i++) {
+		if (i & RESERVED_MMDS)
+			continue;

where RESERVED_MMDS was a hardcoded bitfield matching the IEEE reserved 
MMDs. or maybe a "IGNORE_MMDS" which also includes BIT0 and other MMDs 
the code doesn't understand.

