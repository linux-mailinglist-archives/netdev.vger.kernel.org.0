Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A522B93BB
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 14:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgKSNii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 08:38:38 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:50916 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgKSNih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 08:38:37 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0AJDcTYr042372;
        Thu, 19 Nov 2020 07:38:29 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1605793109;
        bh=nHG4ole5ud6+/+q2v9aEYqrYVx8fqlP+wXkdMjeFNZA=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=P/u19tPkmGmf0S+O9VCaSKHmoovk35StxJoaLMTWGWiy1smaplz0CMJHZ6y/jVVYJ
         4VlZFprH+ZzCxbSrzR4CQY3n3e6VImdEfZgMOMz+ftcakwlpR41gibWSbOW3jWvIXI
         81+JM+YpqPb1tnyeHJ8/S4TzdEYUpTI0gkFIqGNc=
Received: from DFLE104.ent.ti.com (dfle104.ent.ti.com [10.64.6.25])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0AJDcTjd034689
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 19 Nov 2020 07:38:29 -0600
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 19
 Nov 2020 07:38:29 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 19 Nov 2020 07:38:29 -0600
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0AJDcRZx121192;
        Thu, 19 Nov 2020 07:38:27 -0600
Subject: Re: [PATCH] mdio_bus: suppress err message for reset gpio
 EPROBE_DEFER
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
CC:     <linux-kernel@vger.kernel.org>
References: <20201118142426.25369-1-grygorii.strashko@ti.com>
 <0329ed05-371b-0bb5-4f85-75ecaff6a70b@gmail.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <655ec6e4-6e75-1835-034c-ec18dac505e8@ti.com>
Date:   Thu, 19 Nov 2020 15:38:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0329ed05-371b-0bb5-4f85-75ecaff6a70b@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 19/11/2020 14:30, Heiner Kallweit wrote:
> Am 18.11.2020 um 15:24 schrieb Grygorii Strashko:
>> The mdio_bus may have dependencies from GPIO controller and so got
>> deferred. Now it will print error message every time -EPROBE_DEFER is
>> returned from:
>> __mdiobus_register()
>>   |-devm_gpiod_get_optional()
>> without actually identifying error code.
>>
>> "mdio_bus 4a101000.mdio: mii_bus 4a101000.mdio couldn't get reset GPIO"
>>
>> Hence, suppress error message when devm_gpiod_get_optional() returning
>> -EPROBE_DEFER case.
>>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> ---
>>   drivers/net/phy/mdio_bus.c | 7 ++++---
>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
>> index 757e950fb745..54fc13043656 100644
>> --- a/drivers/net/phy/mdio_bus.c
>> +++ b/drivers/net/phy/mdio_bus.c
>> @@ -546,10 +546,11 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
>>   	/* de-assert bus level PHY GPIO reset */
>>   	gpiod = devm_gpiod_get_optional(&bus->dev, "reset", GPIOD_OUT_LOW);
>>   	if (IS_ERR(gpiod)) {
>> -		dev_err(&bus->dev, "mii_bus %s couldn't get reset GPIO\n",
>> -			bus->id);
>> +		err = PTR_ERR(gpiod);
>> +		if (err != -EPROBE_DEFER)
>> +			dev_err(&bus->dev, "mii_bus %s couldn't get reset GPIO %d\n", bus->id, err);
>>   		device_del(&bus->dev);
>> -		return PTR_ERR(gpiod);
>> +		return err;
>>   	} else	if (gpiod) {
>>   		bus->reset_gpiod = gpiod;
>>   
>>
> 
> Using dev_err_probe() here would simplify the code.
> 

this was my first though, but was not sure if it's correct as dev_err_probe() will use dev
to store defer reason, but the same 'dev' is deleted on the next line.

I also thought about using bus->parent, but it's not always provided.

So, if you think dev_err_probe(0) can be used - I can change and re-send.

-- 
Best regards,
grygorii
