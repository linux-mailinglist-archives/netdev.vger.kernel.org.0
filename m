Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD5B1B62C7
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 19:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730087AbgDWRzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 13:55:21 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:57330 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729995AbgDWRzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 13:55:20 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 03NHt8a0003582;
        Thu, 23 Apr 2020 12:55:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1587664508;
        bh=/ENy4NZRRy55mejOy/0EYUHkGgSeOaxW4ELU3cqcb5Q=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=hzsNnyvjHjmkMmforumT0r7maVFqV5DXINfMpNTD7gIZV55n9OtrLlmrAaD6tgGZT
         wuQgWkJz9rNl/aYEEJfEuUeTNH4bXkOLJ6/J3UbKJVd0fh9Oe/oCQGtSrumX2ozwwm
         tbi1tBcYdR933C2CoT/EJ+eEx5ChIBHM+sMb5AQY=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 03NHt83S092083
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 23 Apr 2020 12:55:08 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 23
 Apr 2020 12:55:08 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 23 Apr 2020 12:55:08 -0500
Received: from [10.250.52.63] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 03NHt8eC097690;
        Thu, 23 Apr 2020 12:55:08 -0500
Subject: Re: [PATCH net 1/2] net: phy: DP83822: Fix WoL in config init to be
 disabled
To:     Heiner Kallweit <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>
CC:     <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <afd@ti.com>
References: <20200423163947.18313-1-dmurphy@ti.com>
 <20200423163947.18313-2-dmurphy@ti.com>
 <487889d0-d2e4-ddd4-b199-c621b2826601@gmail.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <54778ab0-faf0-9432-c5b8-755f1401d193@ti.com>
Date:   Thu, 23 Apr 2020 12:49:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <487889d0-d2e4-ddd4-b199-c621b2826601@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Heiner

On 4/23/20 12:02 PM, Heiner Kallweit wrote:
> On 23.04.2020 18:39, Dan Murphy wrote:
>> The WoL feature should be disabled when config_init is called and the
>> feature should turned on or off  when set_wol is called.
>>
>> In addition updated the calls to modify the registers to use the set_bit
>> and clear_bit function calls.
>>
>> Fixes: 3b427751a9d0 ("net: phy: DP83822 initial driver submission")
>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>> ---
>>   drivers/net/phy/dp83822.c | 30 ++++++++++++++++--------------
>>   1 file changed, 16 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
>> index fe9aa3ad52a7..40fdfd043947 100644
>> --- a/drivers/net/phy/dp83822.c
>> +++ b/drivers/net/phy/dp83822.c
>> @@ -137,16 +137,19 @@ static int dp83822_set_wol(struct phy_device *phydev,
>>   			value &= ~DP83822_WOL_SECURE_ON;
>>   		}
>>   
>> -		value |= (DP83822_WOL_EN | DP83822_WOL_INDICATION_SEL |
>> -			  DP83822_WOL_CLR_INDICATION);
>> -		phy_write_mmd(phydev, DP83822_DEVADDR, MII_DP83822_WOL_CFG,
>> -			      value);
>> +		/* Clear any pending WoL interrupt */
>> +		phy_read(phydev, MII_DP83822_MISR2);
>> +
>> +		value |= DP83822_WOL_EN | DP83822_WOL_INDICATION_SEL |
>> +			DP83822_WOL_CLR_INDICATION;
>> +
>> +		return phy_set_bits_mmd(phydev, DP83822_DEVADDR,
>> +					MII_DP83822_WOL_CFG, value);
> The switch to phy_set_bits_mmd() doesn't seem to be correct here.
> So far bit DP83822_WOL_MAGIC_EN is cleared if WAKE_MAGIC isn't set.
> Similar for bit DP83822_WOL_SECURE_ON. With your change they don't
> get cleared any longer.


Thanks for the review.  I was not watching those bits during my testing 
I will revert back to the original code.

>>   	} else {
>> -		value = phy_read_mmd(phydev, DP83822_DEVADDR,
>> -				     MII_DP83822_WOL_CFG);
>> -		value &= ~DP83822_WOL_EN;
>> -		phy_write_mmd(phydev, DP83822_DEVADDR, MII_DP83822_WOL_CFG,
>> -			      value);
>> +		value = DP83822_WOL_EN | DP83822_WOL_CLR_INDICATION;
>> +
> You clear one bit more than before. The reason for this may be worth a note
> in the commit message.

Thanks this was an artifact from debugging.  I can remove the CLR as it 
was cleared in set_wol enablement.

Dan

