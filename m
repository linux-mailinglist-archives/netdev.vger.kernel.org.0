Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE7ED1DEF24
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 20:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730873AbgEVS1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 14:27:36 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:45600 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbgEVS1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 14:27:36 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04MIRSlo010672;
        Fri, 22 May 2020 13:27:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590172048;
        bh=Boi7UZaC0oSRkkkkdn9ayp2vIPyCQV8M/U0d7Ze06ug=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=X8Mj+ZUl7Jrge0j5RTe2sUpAvCifVeR1Ji7qpmym2iEG7Uz6bXoJmISvbhlhTES0A
         mh3x7GBdwyaKe/qW4XXd4tmuWWAeFWoZXNjWO9qyrMhbJZ2KHRiv+EFD99UKXGfd/C
         gFA0lDxUVROQ6pSXg8WWggcbJwaz4YU8YUd3fyR8=
Received: from DLEE106.ent.ti.com (dlee106.ent.ti.com [157.170.170.36])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04MIRS1A119831
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 13:27:28 -0500
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 22
 May 2020 13:27:28 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 22 May 2020 13:27:28 -0500
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04MIRSeF006844;
        Fri, 22 May 2020 13:27:28 -0500
Subject: Re: [PATCH net-next v2 2/4] net: phy: Add a helper to return the
 index for of the internal delay
To:     Florian Fainelli <f.fainelli@gmail.com>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>, <davem@davemloft.net>, <robh@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
References: <20200522122534.3353-1-dmurphy@ti.com>
 <20200522122534.3353-3-dmurphy@ti.com>
 <da85ecb0-1da1-2ccd-0830-a3ec18ee486c@gmail.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <d6c9439e-c83c-9369-a4e1-8af5d9673661@ti.com>
Date:   Fri, 22 May 2020 13:27:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <da85ecb0-1da1-2ccd-0830-a3ec18ee486c@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Florian

On 5/22/20 11:11 AM, Florian Fainelli wrote:
>
> On 5/22/2020 5:25 AM, Dan Murphy wrote:
>> Add a helper function that will return the index in the array for the
>> passed in internal delay value.  The helper requires the array, size and
>> delay value.
>>
>> The helper will then return the index for the exact match or return the
>> index for the index to the closest smaller value.
>>
>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>> ---
>>   drivers/net/phy/phy_device.c | 45 ++++++++++++++++++++++++++++++++++++
>>   include/linux/phy.h          |  2 ++
>>   2 files changed, 47 insertions(+)
>>
>> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
>> index 7481135d27ab..40f53b379d2b 100644
>> --- a/drivers/net/phy/phy_device.c
>> +++ b/drivers/net/phy/phy_device.c
>> @@ -2661,6 +2661,51 @@ void phy_get_pause(struct phy_device *phydev, bool *tx_pause, bool *rx_pause)
>>   }
>>   EXPORT_SYMBOL(phy_get_pause);
>>   
>> +/**
>> + * phy_get_delay_index - returns the index of the internal delay
>> + * @phydev: phy_device struct
>> + * @delay_values: array of delays the PHY supports
>> + * @size: the size of the delay array
>> + * @delay: the delay to be looked up
>> + *
>> + * Returns the index within the array of internal delay passed in.
> Can we consider using s32 for storage that way the various
> of_read_property_read_u32() are a natural fit (int works too, but I
> would prefer being explicit).

Ack

>
>> + */
>> +int phy_get_delay_index(struct phy_device *phydev, int *delay_values, int size,
>> +			int delay)
>> +{
>> +	int i;
>> +
>> +	if (size <= 0)
>> +		return -EINVAL;
>> +
>> +	if (delay <= delay_values[0])
>> +		return 0;
>> +
>> +	if (delay > delay_values[size - 1])
>> +		return size - 1;
> Does not that assume that the delays are sorted by ascending order, if
> so, can you make it clear in the kernel doc?

Yes I guess it does.  I can add this to the k doc


>
>> +
>> +	for (i = 0; i < size; i++) {
>> +		if (delay == delay_values[i])
>> +			return i;
>> +
>> +		/* Find an approximate index by looking up the table */
>> +		if (delay > delay_values[i - 1] &&
> && i > 0 so you do not accidentally under-run the array?

Yes and no it maybe better to start the for loop with i being 
initialized to 1 since the zeroth element is already validated above.

Dan


