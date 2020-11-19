Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F662B9CD7
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 22:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgKSVRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 16:17:20 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:37802 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbgKSVRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 16:17:20 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0AJLHC1g079602;
        Thu, 19 Nov 2020 15:17:12 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1605820632;
        bh=6x5+zSmGmoZLYsG84UhFq8eMCxFBYISt4Ge2M1I4b50=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=i41BoCsjjdj3PMOH9lqKSjqL27a/NJpnksn6kfANG6hJ3P4r4+qPYuu5lyxKd7FOe
         hKl3PYI/Q6axPVfOauK+lzIKVFvrdnXulNPJkYCQXUEV6FciAT27dvF14aKTUeE343
         83IHkXKLCNT4VDsBeiOBCBtCeJWHfZpSdVbQBGPc=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0AJLHC59041139
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 19 Nov 2020 15:17:12 -0600
Received: from DFLE112.ent.ti.com (10.64.6.33) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 19
 Nov 2020 15:17:11 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 19 Nov 2020 15:17:12 -0600
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0AJLH9Qh126529;
        Thu, 19 Nov 2020 15:17:10 -0600
Subject: Re: [PATCH v2] mdio_bus: suppress err message for reset gpio
 EPROBE_DEFER
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
CC:     <linux-kernel@vger.kernel.org>
References: <20201119203446.20857-1-grygorii.strashko@ti.com>
 <1a59fbe1-6a5d-81a3-4a86-fa3b5dbfdf8e@gmail.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <cabad89e-23cc-18b3-8306-e5ef1ee4bfa6@ti.com>
Date:   Thu, 19 Nov 2020 23:17:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1a59fbe1-6a5d-81a3-4a86-fa3b5dbfdf8e@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 19/11/2020 23:11, Heiner Kallweit wrote:
> Am 19.11.2020 um 21:34 schrieb Grygorii Strashko:
>> The mdio_bus may have dependencies from GPIO controller and so got
>> deferred. Now it will print error message every time -EPROBE_DEFER is
>> returned which from:
>> __mdiobus_register()
>>   |-devm_gpiod_get_optional()
>> without actually identifying error code.
>>
>> "mdio_bus 4a101000.mdio: mii_bus 4a101000.mdio couldn't get reset GPIO"
>>
>> Hence, suppress error message for devm_gpiod_get_optional() returning
>> -EPROBE_DEFER case by using dev_err_probe().
>>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> ---
>>   drivers/net/phy/mdio_bus.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
>> index 757e950fb745..83cd61c3dd01 100644
>> --- a/drivers/net/phy/mdio_bus.c
>> +++ b/drivers/net/phy/mdio_bus.c
>> @@ -546,10 +546,10 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
>>   	/* de-assert bus level PHY GPIO reset */
>>   	gpiod = devm_gpiod_get_optional(&bus->dev, "reset", GPIOD_OUT_LOW);
>>   	if (IS_ERR(gpiod)) {
>> -		dev_err(&bus->dev, "mii_bus %s couldn't get reset GPIO\n",
>> -			bus->id);
>> +		err = dev_err_probe(&bus->dev, PTR_ERR(gpiod),
>> +				    "mii_bus %s couldn't get reset GPIO\n", bus->id);
> 
> Doesn't checkpatch complain about line length > 80 here?

:)

commit bdc48fa11e46f867ea4d75fa59ee87a7f48be144
Author: Joe Perches <joe@perches.com>
Date:   Fri May 29 16:12:21 2020 -0700

     checkpatch/coding-style: deprecate 80-column warning

> 
>>   		device_del(&bus->dev);
>> -		return PTR_ERR(gpiod);
>> +		return err;
>>   	} else	if (gpiod) {
>>   		bus->reset_gpiod = gpiod;
>>   
>>
> 
> Last but not least the net or net-next patch annotation is missing.
> I'd be fine with treating the change as an improvement (net-next).
> 
> Apart from that change looks good to me.
> 

-- 
Best regards,
grygorii
