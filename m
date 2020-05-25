Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9991E04C7
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 04:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388706AbgEYCh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 22:37:58 -0400
Received: from foss.arm.com ([217.140.110.172]:35046 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388110AbgEYCh6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 May 2020 22:37:58 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 81FAD31B;
        Sun, 24 May 2020 19:37:57 -0700 (PDT)
Received: from [192.168.122.166] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 378B33F305;
        Sun, 24 May 2020 19:37:57 -0700 (PDT)
Subject: Re: [RFC 03/11] net: phy: refactor c45 phy identification sequence
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, madalin.bucur@oss.nxp.com,
        calvin.johnson@oss.nxp.com, linux-kernel@vger.kernel.org
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
 <20200522213059.1535892-4-jeremy.linton@arm.com>
 <20200523183058.GX1551@shell.armlinux.org.uk>
 <20200523195131.GN610998@lunn.ch>
 <20200523200141.GD1551@shell.armlinux.org.uk>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <fa71a325-e201-79c0-ca10-3614ea428802@arm.com>
Date:   Sun, 24 May 2020 21:37:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200523200141.GD1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 5/23/20 3:01 PM, Russell King - ARM Linux admin wrote:
> On Sat, May 23, 2020 at 09:51:31PM +0200, Andrew Lunn wrote:
>>>>   static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
>>>>   			   struct phy_c45_device_ids *c45_ids) {
>>>> -	int phy_reg;
>>>> -	int i, reg_addr;
>>>> +	int ret;
>>>> +	int i;
>>>>   	const int num_ids = ARRAY_SIZE(c45_ids->device_ids);
>>>>   	u32 *devs = &c45_ids->devices_in_package;
>>>
>>> I feel a "reverse christmas tree" complaint brewing... yes, the original
>>> code didn't follow it.  Maybe a tidy up while touching this code?
>>
>> At minimum, a patch should not make it worse. ret and i should clearly
>> be after devs.
>>
>>>>   static int get_phy_id(struct mii_bus *bus, int addr, u32 *phy_id,
>>>>   		      bool is_c45, struct phy_c45_device_ids *c45_ids)
>>>>   {
>>>> -	int phy_reg;
>>>> +	int ret;
>>>>   
>>>>   	if (is_c45)
>>>>   		return get_phy_c45_ids(bus, addr, phy_id, c45_ids);
>>>>   
>>>> -	/* Grab the bits from PHYIR1, and put them in the upper half */
>>>> -	phy_reg = mdiobus_read(bus, addr, MII_PHYSID1);
>>>> -	if (phy_reg < 0) {
>>>> +	ret = _get_phy_id(bus, addr, 0, phy_id, false);
>>>> +	if (ret < 0) {
>>>>   		/* returning -ENODEV doesn't stop bus scanning */
>>>> -		return (phy_reg == -EIO || phy_reg == -ENODEV) ? -ENODEV : -EIO;
>>>> +		return (ret == -EIO || ret == -ENODEV) ? -ENODEV : -EIO;
>>>
>>> Since ret will only ever be -EIO here, this can only ever return
>>> -ENODEV, which is a functional change in the code (probably unintended.)
>>> Nevertheless, it's likely introducing a bug if the intention is for
>>> some other return from mdiobus_read() to be handled differently.
>>>
>>>>   	}
>>>>   
>>>> -	*phy_id = phy_reg << 16;
>>>> -
>>>> -	/* Grab the bits from PHYIR2, and put them in the lower half */
>>>> -	phy_reg = mdiobus_read(bus, addr, MII_PHYSID2);
>>>> -	if (phy_reg < 0)
>>>> -		return -EIO;
>>>
>>> ... whereas this one always returns -EIO on any error.
>>>
>>> So, I think you have the potential in this patch to introduce a subtle
>>> change of behaviour, which may lead to problems - have you closely
>>> analysed why the code was the way it was, and whether your change of
>>> behaviour is actually valid?
>>
>> I could be remembering this wrongly, but i think this is to do with
>> orion_mdio_xsmi_read() returning -ENODEV, not 0xffffffffff, if there
>> is no device on the bus at the given address. -EIO is fatal to the
>> scan, everything stops with the assumption the bus is broken. -ENODEV
>> should not be fatal to the scan.
> 
> Maybe orion_mdio_xsmi_read() should be fixed then?  Also, maybe
> adding return code documentation for mdiobus_read() / mdiobus_write()
> would help MDIO driver authors have some consistency in what
> errors they are expected to return (does anyone know for certain?)
> 

My understanding at this point (which is mostly based on the xgmac 
here), is that 0xffffffff is equivalent to "bus responding correctly, 
phy failed to respond at this register location" while any -Eerror is 
understood as "something wrong with bus", and the mdio core then makes a 
choice about terminating just the current phy search (ENODEV), or 
terminating the entire mdio bus (basically everything else) registration.

I will see about clarifying the docs. I need to see if that will end up 
being a bit of a rabbit hole before committing to including that in this 
set.

Which brings up the problem that at least xgmac_mdio doesn't appear to 
handle being told "your bus registration failed" without OOPSing the 
probe routine. I think Calvin is aware of this, and I believe he has 
some additional xgmac/etc patches on top of this set. Although he pinged 
me offline the other day to say that apparently all my hunk shuffling 
broke some of the c45 phy detection I had working earlier in the week.

