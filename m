Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280B91DF8BD
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 19:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388071AbgEWRQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 13:16:24 -0400
Received: from foss.arm.com ([217.140.110.172]:53302 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387571AbgEWRQY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 May 2020 13:16:24 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 96FBB1FB;
        Sat, 23 May 2020 10:16:23 -0700 (PDT)
Received: from [192.168.122.166] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 317E93F305;
        Sat, 23 May 2020 10:16:23 -0700 (PDT)
Subject: Re: [RFC 03/11] net: phy: refactor c45 phy identification sequence
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        madalin.bucur@oss.nxp.com, calvin.johnson@oss.nxp.com,
        linux-kernel@vger.kernel.org
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
 <20200522213059.1535892-4-jeremy.linton@arm.com>
 <20200523152800.GM610998@lunn.ch>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <1c111763-a46c-35c2-149c-b1af8b60d7e7@arm.com>
Date:   Sat, 23 May 2020 12:16:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200523152800.GM610998@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thanks for taking a look at this!

On 5/23/20 10:28 AM, Andrew Lunn wrote:
> On Fri, May 22, 2020 at 04:30:51PM -0500, Jeremy Linton wrote:
>> Lets factor out the phy id logic, and make it generic
>> so that it can be used for c22 and c45.
>>
>> Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
>> ---
>>   drivers/net/phy/phy_device.c | 65 +++++++++++++++++++-----------------
>>   1 file changed, 35 insertions(+), 30 deletions(-)
>>
>> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
>> index 7746c07b97fe..f0761fa5e40b 100644
>> --- a/drivers/net/phy/phy_device.c
>> +++ b/drivers/net/phy/phy_device.c
>> @@ -695,6 +695,29 @@ static int get_phy_c45_devs_in_pkg(struct mii_bus *bus, int addr, int dev_addr,
>>   	return 0;
>>   }
>>   
>> +static int _get_phy_id(struct mii_bus *bus, int addr, int dev_addr,
>> +		       u32 *phy_id, bool c45)
> 
> Hi Jeremy
> 
> How about read_phy_id() so you can avoid the _ prefix.

Yes, that sounds good.

> 
>>   static bool valid_phy_id(int val)
>>   {
>>   	return (val > 0 && ((val & 0x1fffffff) != 0x1fffffff));
>> @@ -715,17 +738,17 @@ static bool valid_phy_id(int val)
>>    */
>>   static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
>>   			   struct phy_c45_device_ids *c45_ids) {
>> -	int phy_reg;
>> -	int i, reg_addr;
>> +	int ret;
>> +	int i;
>>   	const int num_ids = ARRAY_SIZE(c45_ids->device_ids);
>>   	u32 *devs = &c45_ids->devices_in_package;
>>   
>>   	/* Find first non-zero Devices In package. Device zero is reserved
>>   	 * for 802.3 c45 complied PHYs, so don't probe it at first.
>>   	 */
>> -	for (i = 1; i < num_ids && *devs == 0; i++) {
>> -		phy_reg = get_phy_c45_devs_in_pkg(bus, addr, i, devs);
>> -		if (phy_reg < 0)
>> +	for (i = 0; i < num_ids && *devs == 0; i++) {
>> +		ret = get_phy_c45_devs_in_pkg(bus, addr, i, devs);
>> +		if (ret < 0)
>>   			return -EIO;
> 
> Renaming reg_addr to ret does not belong in this patch.

Sure, that makes sense. The rename was a last min change when I was 
shuffling the args around.

Thanks,


