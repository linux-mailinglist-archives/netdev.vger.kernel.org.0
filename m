Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0C43CC341
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 14:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233677AbhGQMhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 08:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhGQMhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Jul 2021 08:37:50 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61704C06175F
        for <netdev@vger.kernel.org>; Sat, 17 Jul 2021 05:34:54 -0700 (PDT)
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 94AC781E47;
        Sat, 17 Jul 2021 14:34:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1626525292;
        bh=mbbABsfRX2M7m8snhL/DdKRn1l1CK0cUr2Wdi+U9OrY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=fXXlDorZ9UF7KPo73jtGIi4kIbXe4bPzhbIUgunwDBBL1II3QpYMJOM+5vQ4CAUUB
         fmzfFDXFbtXRahVhOPf2ei2NZekCCXKLMy5XZ/e/NyFJE2zVQk3aVqGiUz0YVwfkMh
         kAe9PBcJ0n+s0ilzom/rZ/BLHyZO7LKkCq61kLr7U/kd3RN0DwW/DcZ9ndpubJ20E5
         HpDk/tt9NGGZIjRrIfVQFk1ODOgpqnNCRuA1AV2614kunbD3bdqVG7TApw28JOM9MF
         gyXvGYfySgkE2AEzMf0w5B2qQyEEHSXMMKhhHnqxNevN9L2+IydXeUYAruBaC1HiY5
         9gbJnyxE+sCKg==
Subject: Re: [PATCH] net: phy: Add RGMII_ID/TXID/RXID handling to the DP83822
 driver
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Dan Murphy <dmurphy@ti.com>,
        "David S . Miller" <davem@davemloft.net>
References: <20210716182328.218768-1-marex@denx.de> <YPHpILw+p2l6cKR9@lunn.ch>
From:   Marek Vasut <marex@denx.de>
Message-ID: <17e8b1b8-8472-48e4-af02-8a1dc43e9601@denx.de>
Date:   Sat, 17 Jul 2021 14:34:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YPHpILw+p2l6cKR9@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/16/21 10:16 PM, Andrew Lunn wrote:
> On Fri, Jul 16, 2021 at 08:23:28PM +0200, Marek Vasut wrote:
>> Add support for setting the internal clock shift of the PHY based on
>> the interface requirements. RX/TX/both is supported for RGMII.
>>
>> Signed-off-by: Marek Vasut <marex@denx.de>
>> Cc: Florian Fainelli <f.fainelli@gmail.com>
>> Cc: Dan Murphy <dmurphy@ti.com>
>> Cc: David S. Miller <davem@davemloft.net>
>> ---
>>   drivers/net/phy/dp83822.c | 37 +++++++++++++++++++++++++++++++++----
>>   1 file changed, 33 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
>> index f7a2ec150e54..971c8d6b85d2 100644
>> --- a/drivers/net/phy/dp83822.c
>> +++ b/drivers/net/phy/dp83822.c
>> @@ -72,6 +72,10 @@
>>   #define DP83822_ANEG_ERR_INT_EN		BIT(6)
>>   #define DP83822_EEE_ERROR_CHANGE_INT_EN	BIT(7)
>>   
>> +/* RCSR bits */
>> +#define DP83822_RGMII_RX_CLOCK_SHIFT	BIT(12)
>> +#define DP83822_RGMII_TX_CLOCK_SHIFT	BIT(11)
>> +
>>   /* INT_STAT1 bits */
>>   #define DP83822_WOL_INT_EN	BIT(4)
>>   #define DP83822_WOL_INT_STAT	BIT(12)
>> @@ -326,11 +330,36 @@ static irqreturn_t dp83822_handle_interrupt(struct phy_device *phydev)
>>   
>>   static int dp8382x_disable_wol(struct phy_device *phydev)
>>   {
>> -	int value = DP83822_WOL_EN | DP83822_WOL_MAGIC_EN |
>> -		    DP83822_WOL_SECURE_ON;
>> +	u16 val = DP83822_WOL_EN | DP83822_WOL_MAGIC_EN | DP83822_WOL_SECURE_ON;
>> +
>> +	ret = phy_clear_bits_mmd(phydev, DP83822_DEVADDR,
>> +				 MII_DP83822_WOL_CFG, val);
>> +	if (ret < 0)
>> +		return ret;
>> +
>    
>> -	return phy_clear_bits_mmd(phydev, DP83822_DEVADDR,
>> -				  MII_DP83822_WOL_CFG, value);
>> +	return ret;
>>   }
> 
> This change seems to have nothing to do with RGMII delays.  Please
> split it out, so it does not distract from reviewing the real change
> here.
> 
> It also seems odd you are changing RGMII delays when disabling WOL?
> Rebase gone wrong?

Rebase gone wrong, please drop.
