Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58542190E60
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 14:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbgCXNJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 09:09:23 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:60223 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726188AbgCXNJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 09:09:23 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48ms5r1Fhbz1qs3g;
        Tue, 24 Mar 2020 14:09:20 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48ms5r0f7Fz1qqkB;
        Tue, 24 Mar 2020 14:09:20 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id WjJuordWpAVq; Tue, 24 Mar 2020 14:09:19 +0100 (CET)
X-Auth-Info: 3oXUA7kA7yMXmIKg1+aoaSXJU/xBYxEQbmCqbM3EHr8=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue, 24 Mar 2020 14:09:18 +0100 (CET)
Subject: Re: [PATCH 07/14] net: ks8851: Use 16-bit writes to program MAC
 address
To:     Lukas Wunner <lukas@wunner.de>, Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
References: <20200323234303.526748-1-marex@denx.de>
 <20200323234303.526748-8-marex@denx.de>
 <20200324081311.ww6p7dmijbddi5jm@wunner.de> <20200324122553.GS3819@lunn.ch>
 <20200324123623.vvvcoiza6ehuecf6@wunner.de>
From:   Marek Vasut <marex@denx.de>
Message-ID: <be4c96dc-87ab-27a9-cf51-c1e54853b528@denx.de>
Date:   Tue, 24 Mar 2020 14:09:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200324123623.vvvcoiza6ehuecf6@wunner.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/20 1:36 PM, Lukas Wunner wrote:
> On Tue, Mar 24, 2020 at 01:25:53PM +0100, Andrew Lunn wrote:
>> On Tue, Mar 24, 2020 at 09:13:11AM +0100, Lukas Wunner wrote:
>>> On Tue, Mar 24, 2020 at 12:42:56AM +0100, Marek Vasut wrote:
>>>> On the SPI variant of KS8851, the MAC address can be programmed with
>>>> either 8/16/32-bit writes. To make it easier to support the 16-bit
>>>> parallel option of KS8851 too, switch both the MAC address programming
>>>> and readout to 16-bit operations.
>>> [...]
>>>>  static int ks8851_write_mac_addr(struct net_device *dev)
>>>>  {
>>>>  	struct ks8851_net *ks = netdev_priv(dev);
>>>> +	u16 val;
>>>>  	int i;
>>>>  
>>>>  	mutex_lock(&ks->lock);
>>>> @@ -358,8 +329,12 @@ static int ks8851_write_mac_addr(struct net_device *dev)
>>>>  	 * the first write to the MAC address does not take effect.
>>>>  	 */
>>>>  	ks8851_set_powermode(ks, PMECR_PM_NORMAL);
>>>> -	for (i = 0; i < ETH_ALEN; i++)
>>>> -		ks8851_wrreg8(ks, KS_MAR(i), dev->dev_addr[i]);
>>>> +
>>>> +	for (i = 0; i < ETH_ALEN; i += 2) {
>>>> +		val = (dev->dev_addr[i] << 8) | dev->dev_addr[i + 1];
>>>> +		ks8851_wrreg16(ks, KS_MAR(i + 1), val);
>>>> +	}
>>>> +
>>>
>>> This looks like it won't work on little-endian machines:  The MAC bytes
>>> are stored in dev->dev_addr as 012345, but in the EEPROM they're stored
>>> as 543210.  The first 16-bit value that you write is 10 on big-endian
>>> and 01 on little-endian if I'm not mistaken.
>>>
>>> By only writing 8-bit values, the original author elegantly sidestepped
>>> this issue.
>>>
>>> Maybe the simplest and most readable solution is something like:
>>>
>>>       u8 val[2];
>>>       ...
>>>       val[0] = dev->dev_addr[i+1];
>>>       val[1] = dev->dev_addr;
>>>
>>> Then cast val to a u16 when passing it to ks8851_wrreg16().
>>>
>>> Alternatively, use cpu_to_be16().
>>
>> There is a cpu_to_be16() inside ks8851_wrreg16(). Something i already
>> checked, because i wondered about endianess issues as well.
> 
> There's a cpu_to_le16() in ks8851_wrreg16(), not a cpu_to_be16().

I have a feeling this whole thing might be more messed up then we
thought. At least the KS8851-16MLL has an "endian mode" bit in the CCR
register, the SPI variant does not.

So what I think you need to do here is write exactly the registers
0x14/0x12/0x10 and let the accessors swap the endianness as needed.
