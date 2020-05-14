Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2E4E1D3F2B
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 22:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgENUtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 16:49:20 -0400
Received: from foss.arm.com ([217.140.110.172]:44304 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbgENUtU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 16:49:20 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D64281042;
        Thu, 14 May 2020 13:49:19 -0700 (PDT)
Received: from [192.168.122.166] (unknown [10.119.48.101])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8082E3F68F;
        Thu, 14 May 2020 13:49:19 -0700 (PDT)
Subject: Re: [PATCH] net: phy: Fix c45 no phy detected logic
To:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, linux-kernel@vger.kernel.org
References: <20200514170025.1379981-1-jeremy.linton@arm.com>
 <e1826c60-736f-d496-4c4f-7229efee018b@gmail.com>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <337071a2-0eaf-6143-f6c0-b451d681733d@arm.com>
Date:   Thu, 14 May 2020 15:49:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <e1826c60-736f-d496-4c4f-7229efee018b@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 5/14/20 2:59 PM, Heiner Kallweit wrote:
> On 14.05.2020 19:00, Jeremy Linton wrote:
>> The commit "disregard Clause 22 registers present bit..." clears
>> the low bit of the devices_in_package data which is being used
>> in get_phy_c45_ids() to determine if a phy/register is responding
>> correctly. That check is against 0x1FFFFFFF, but since the low
>> bit is always cleared, the check can never be true. This leads to
>> detecting c45 phy devices where none exist.
>>
>> Lets fix this by also clearing the low bit in the mask to 0x1FFFFFFE.
>> This allows us to continue to autoprobe standards compliant devices
>> without also gaining a large number of bogus ones.
>>
>> Fixes: 3b5e74e0afe3 ("net: phy: disregard "Clause 22 registers present" bit in get_phy_c45_devs_in_pkg")
>> Cc: Heiner Kallweit <hkallweit1@gmail.com>
>> Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
>> ---
>>   drivers/net/phy/phy_device.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
>> index ac2784192472..b93d984d35cc 100644
>> --- a/drivers/net/phy/phy_device.c
>> +++ b/drivers/net/phy/phy_device.c
>> @@ -723,7 +723,7 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
>>   		if (phy_reg < 0)
>>   			return -EIO;
>>   
>> -		if ((*devs & 0x1fffffff) == 0x1fffffff) {
>> +		if ((*devs & 0x1ffffffe) == 0x1ffffffe) {
>>   			/*  If mostly Fs, there is no device there,
> 
> Looks good to me, it would just be good to extend the comment and explain
> why we exclude bit 0 here.

Sure, sounds good.

> 
> 
>>   			 *  then let's continue to probe more, as some
>>   			 *  10G PHYs have zero Devices In package,
>> @@ -733,7 +733,7 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
>>   			if (phy_reg < 0)
>>   				return -EIO;
>>   			/* no device there, let's get out of here */
>> -			if ((*devs & 0x1fffffff) == 0x1fffffff) {
>> +			if ((*devs & 0x1ffffffe) == 0x1ffffffe) {
>>   				*phy_id = 0xffffffff;
>>   				return 0;
>>   			} else {
>>
> 

