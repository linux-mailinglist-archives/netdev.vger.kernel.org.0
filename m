Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94D371E04D9
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 04:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388730AbgEYCs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 22:48:59 -0400
Received: from foss.arm.com ([217.140.110.172]:35128 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388510AbgEYCs7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 May 2020 22:48:59 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 79D1731B;
        Sun, 24 May 2020 19:48:56 -0700 (PDT)
Received: from [192.168.122.166] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 12D3F3F305;
        Sun, 24 May 2020 19:48:56 -0700 (PDT)
Subject: Re: [RFC 02/11] net: phy: Simplify MMD device list termination
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        madalin.bucur@oss.nxp.com, calvin.johnson@oss.nxp.com,
        linux-kernel@vger.kernel.org
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
 <20200522213059.1535892-3-jeremy.linton@arm.com>
 <20200523183610.GY1551@shell.armlinux.org.uk>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <e25080cd-420a-da87-e13c-fa7e2ffb93a6@arm.com>
Date:   Sun, 24 May 2020 21:48:55 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200523183610.GY1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 5/23/20 1:36 PM, Russell King - ARM Linux admin wrote:
> On Fri, May 22, 2020 at 04:30:50PM -0500, Jeremy Linton wrote:
>> Since we are already checking for *devs == 0 after
>> the loop terminates, we can add a mostly F's check
>> as well. With that change we can simplify the return/break
>> sequence inside the loop.
>>
>> Add a valid_phy_id() macro for this, since we will be using it
>> in a couple other places.
> 
> I'm not sure you have the name of this correct, and your usage layer
> in your patch series is correct.

Or the name is poor..

> 
>>
>> Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
>> ---
>>   drivers/net/phy/phy_device.c | 15 +++++++--------
>>   1 file changed, 7 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
>> index 245899b58a7d..7746c07b97fe 100644
>> --- a/drivers/net/phy/phy_device.c
>> +++ b/drivers/net/phy/phy_device.c
>> @@ -695,6 +695,11 @@ static int get_phy_c45_devs_in_pkg(struct mii_bus *bus, int addr, int dev_addr,
>>   	return 0;
>>   }
>>   
>> +static bool valid_phy_id(int val)
>> +{
>> +	return (val > 0 && ((val & 0x1fffffff) != 0x1fffffff));
>> +}
>> +
>>   /**
>>    * get_phy_c45_ids - reads the specified addr for its 802.3-c45 IDs.
>>    * @bus: the target MII bus
>> @@ -732,18 +737,12 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
>>   			phy_reg = get_phy_c45_devs_in_pkg(bus, addr, 0, devs);
>>   			if (phy_reg < 0)
>>   				return -EIO;
>> -			/* no device there, let's get out of here */
>> -			if ((*devs & 0x1fffffff) == 0x1fffffff) {
>> -				*phy_id = 0xffffffff;
>> -				return 0;
>> -			} else {
>> -				break;
>> -			}
>> +			break;
>>   		}
>>   	}
>>   
>>   	/* no reported devices */
>> -	if (*devs == 0) {
>> +	if (!valid_phy_id(*devs)) {
> 
> You are using this to validate the "devices in package" value, not the
> PHY ID value.  So, IMHO this should be called "valid_devs_in_package()"
> or similar.

Hmmm, its more "valid_phy_reg()" since it ends up being used to validate 
both the devs in package as well as phy id.



> 
>>   		*phy_id = 0xffffffff;
>>   		return 0;
>>   	}
>> -- 
>> 2.26.2
>>
>>
> 

