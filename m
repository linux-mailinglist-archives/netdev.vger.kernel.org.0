Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 149573505E2
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 19:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234514AbhCaR7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 13:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233867AbhCaR7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 13:59:12 -0400
Received: from hs01.dk-develop.de (hs01.dk-develop.de [IPv6:2a02:c207:3002:6234::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C4FC061574;
        Wed, 31 Mar 2021 10:59:11 -0700 (PDT)
Received: from mail.dk-develop.de (hs01.dk-develop.de [IPv6:::1])
        by hs01.dk-develop.de (Postfix) with ESMTP id 7360A1DA396;
        Wed, 31 Mar 2021 19:58:33 +0200 (CEST)
MIME-Version: 1.0
Date:   Wed, 31 Mar 2021 19:58:33 +0200
From:   danilokrummrich@dk-develop.de
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux@armlinux.org.uk, davem@davemloft.net, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jeremy.linton@arm.com
Subject: Re: [PATCH 2/2] net: mdio: support c45 peripherals on c22 busses
In-Reply-To: <YGSi+b/r4zlq9rm8@lunn.ch>
References: <20210331141755.126178-1-danilokrummrich@dk-develop.de>
 <20210331141755.126178-3-danilokrummrich@dk-develop.de>
 <YGSi+b/r4zlq9rm8@lunn.ch>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <6f1dfc28368d098ace9564e53ed92041@dk-develop.de>
X-Sender: danilokrummrich@dk-develop.de
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On 2021-03-31 18:27, Andrew Lunn wrote:
>> @@ -670,19 +670,21 @@ struct phy_device *mdiobus_scan(struct mii_bus 
>> *bus, int addr)
>>  	struct phy_device *phydev = ERR_PTR(-ENODEV);
>>  	int err;
>> 
>> +	/* In case of NO_CAP and C22 only, we still can try to scan for C45
>> +	 * devices, since indirect access will be used for busses that are 
>> not
>> +	 * capable of C45 frame format.
>> +	 */
>>  	switch (bus->capabilities) {
>>  	case MDIOBUS_NO_CAP:
>>  	case MDIOBUS_C22:
>> -		phydev = get_phy_device(bus, addr, false);
>> -		break;
>> -	case MDIOBUS_C45:
>> -		phydev = get_phy_device(bus, addr, true);
>> -		break;
>>  	case MDIOBUS_C22_C45:
>>  		phydev = get_phy_device(bus, addr, false);
>>  		if (IS_ERR(phydev))
>>  			phydev = get_phy_device(bus, addr, true);
>>  		break;
>> +	case MDIOBUS_C45:
>> +		phydev = get_phy_device(bus, addr, true);
>> +		break;
>>  	}
> 
> I think this is going to cause problems.
Please note that this patch does not change already existing behaviour, 
it does
only extend it with the option to drive C45 peripherals from a bus not 
being
capable of C45 framing.

For this cited change the only thing happening is that if 
get_phy_device()
already failed for probing with is_c45==false (C22 devices) it tries to 
probe
with is_c45==true (C45 devices) which then either results into actual 
C45 frame
transfers or indirect accesses by calling mdiobus_c45_*() functions.

This is a valid approach, since we made sure that even if the MDIO 
controller does
not support C45 framing we can go with indirect accesses.
> 
> commit 0231b1a074c672f8c00da00a57144072890d816b
> Author: Kevin Hao <haokexin@gmail.com>
> Date:   Tue Mar 20 09:44:53 2018 +0800
> 
>     net: phy: realtek: Use the dummy stubs for MMD register access for 
> rtl8211b
> 
>     The Ethernet on mpc8315erdb is broken since commit b6b5e8a69118
>     ("gianfar: Disable EEE autoneg by default"). The reason is that
>     even though the rtl8211b doesn't support the MMD extended registers
>     access, it does return some random values if we trying to access
>     the MMD register via indirect method. This makes it seem that the
>     EEE is supported by this phy device. And the subsequent writing to
>     the MMD registers does cause the phy malfunction. So use the dummy
>     stubs for the MMD register access to fix this issue.
This is something different, here the issue is that an indirect access 
does
not work with a PHY being registered with is_c45==false. This is not 
related
to this change.
> 
> Indirect access to C45 via C22 is not a guaranteed part of C22. So
> there are C22 only PHYs which return random junk when you try to use
> this access method.
For C22 only PHYs nothing will change. If there is not an indirect 
access
to a C22 PHY already, then there will not be one by applying this patch
either.
> 
> I'm also a bit confused why this is actually needed. PHY drivers which
> make use of C45 use the functions phy_read_mmd(), phy_write_mmd().
I'm looking on it from the perspective of the MDIO controller. If the
controller is not capable of C45 framing this doesn't help.
 From only the PHY's capability point of view this is fine, indeed.
> 
> int __phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum)
> {
> 	int val;
> 
> 	if (regnum > (u16)~0 || devad > 32)
> 		return -EINVAL;
> 
> 	if (phydev->drv && phydev->drv->read_mmd) {
> 		val = phydev->drv->read_mmd(phydev, devad, regnum);
> 	} else if (phydev->is_c45) {
> 		val = __mdiobus_c45_read(phydev->mdio.bus, phydev->mdio.addr,
> 					 devad, regnum);
> 	} else {
> 		struct mii_bus *bus = phydev->mdio.bus;
> 		int phy_addr = phydev->mdio.addr;
> 
> 		mmd_phy_indirect(bus, phy_addr, devad, regnum);
> 
> 		/* Read the content of the MMD's selected register */
> 		val = __mdiobus_read(bus, phy_addr, MII_MMD_DATA);
> 	}
> 	return val;
> }
> 
> So if the device is a c45 device, C45 transfers are used, otherwise it
That's the issue I'm addressing, if the device is a C45 device and the 
MDIO
controller is not capable of C45 framing, currently, the device won't be 
probed
as a C45 device, because mdiobus_c45_read() will fail. Instead with this 
patch
mdiobus_c45_read() can check the bus's capabilities and perform indirect 
accesses
in case the MDIO controller is not capable of C45 framing, and therefore 
be able
to probe C45 PHYs from a MDIO controller not being capable of C45 
framing.
> falls back to mmd_phy_indirect(), which is C45 over C22.
Only if is_c45==false, that's not what I'm addressing. I'm addressing 
the case that
is_c45==true, but the MDIO controller does not support C45 framing.
> 
> Why does this not work for you?
As explained inline above.
> 
>     Andrew
Kind regards,
Danilo
