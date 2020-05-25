Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 081B31E179C
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 00:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730157AbgEYWJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 18:09:58 -0400
Received: from foss.arm.com ([217.140.110.172]:44694 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729183AbgEYWJ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 18:09:57 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E41B631B;
        Mon, 25 May 2020 15:09:56 -0700 (PDT)
Received: from [192.168.122.166] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8A1653F6C4;
        Mon, 25 May 2020 15:09:56 -0700 (PDT)
Subject: Re: [RFC 08/11] net: phy: Allow mdio buses to auto-probe c45 devices
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        madalin.bucur@oss.nxp.com, calvin.johnson@oss.nxp.com,
        linux-kernel@vger.kernel.org
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
 <20200522213059.1535892-9-jeremy.linton@arm.com>
 <20200524144449.GP610998@lunn.ch>
 <ec63b0d4-2abc-0d32-69c0-ed1a822162cf@arm.com>
 <20200525082510.GH1551@shell.armlinux.org.uk>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <8567710f-b4d3-5ce6-225f-b932b4ffc97c@arm.com>
Date:   Mon, 25 May 2020 17:09:56 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200525082510.GH1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 5/25/20 3:25 AM, Russell King - ARM Linux admin wrote:
> On Sun, May 24, 2020 at 11:28:52PM -0500, Jeremy Linton wrote:
>> Hi,
>>
>> On 5/24/20 9:44 AM, Andrew Lunn wrote:
>>>> +++ b/include/linux/phy.h
>>>> @@ -275,6 +275,11 @@ struct mii_bus {
>>>>    	int reset_delay_us;
>>>>    	/* RESET GPIO descriptor pointer */
>>>>    	struct gpio_desc *reset_gpiod;
>>>> +	/* bus capabilities, used for probing */
>>>> +	enum {
>>>> +		MDIOBUS_C22_ONLY = 0,
>>>> +		MDIOBUS_C45_FIRST,
>>>> +	} probe_capabilities;
>>>>    };
>>>
>>>
>>> I'm not so keen on _FIRST. It suggest _LAST would also be valid.  But
>>> that then suggests this is not a bus property, but a PHY property, and
>>> some PHYs might need _FIRST and other phys need _LAST, and then you
>>> have a bus which has both sorts of PHY on it, and you have a problem.
>>>
>>> So i think it would be better to have
>>>
>>> 	enum {
>>> 		MDIOBUS_UNKNOWN = 0,
>>> 		MDIOBUS_C22,
>>> 		MDIOBUS_C45,
>>> 		MDIOBUS_C45_C22,
>>> 	} bus_capabilities;
>>>
>>> Describe just what the bus master can support.
>>
>> Yes, the naming is reasonable and I will update it in the next patch. I went
>> around a bit myself with this naming early on, and the problem I saw was
>> that a C45 capable master, can have C45 electrical phy's that only respond
>> to c22 requests (AFAIK).
> 
> If you have a master that can only generate clause 45 cycles, and
> someone is daft enough to connect a clause 22 only PHY to it, the
> result is hardware that doesn't work - there's no getting around
> that.  The MDIO interface can't generate the appropriate cycles to
> access the clause 22 PHY.  So, this is not something we need care
> about.
> 
>> So the MDIOBUS_C45 (I think I was calling it
>> C45_ONLY) is an invalid selection. Not, that it wouldn't be helpful to have
>> a C45_ONLY case, but that the assumption is that you wouldn't try and probe
>> c22 registers, which I thought was a mistake.
> 
> MDIOBUS_C45 means "I can generate clause 45 cycles".
> MDIOBUS_C22 means "I can generate clause 22 cycles".
> MDIOBUS_C45_C22 means "I can generate both clause 45 and clause 22
> cycles."

Hi, to be clear, we are talking about c45 controllers that can access 
the c22 register space via c45, or controllers which are 
electrically/level shifting to be compatible with c22 voltages/etc?

The nxp hardware in question has 1, 10 and 40Gbit phys on the same MDIO, 
the 1gbit we fall back to c22 registers because it doesn't respond 
correctly to c45 registers. Which is AFAIK what the bit0 C22 regs bit is 
for..

The general logic right now for a C45_FIRST is attempt to detect a c45 
phy and if nothing is detected fall back and attempt c22 register 
access. That is whats picking up the 1G phys. If for whatever reason the 
MDIO controller can't do the right thing to access the c22 regs, I guess 
there really isn't anything we can do about it.


> 
> Notice carefully the values these end up with - MDIOBUS_C22 = BIT(0),
> MDIOBUS_C45 = BIT(1), MDIOBUS_C45_C22 = BIT(0) | BIT(1).  I suspect
> that was no coincidence in Andrew's suggestion.
> 

