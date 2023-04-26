Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58CF76EED6E
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 07:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239126AbjDZFJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 01:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjDZFJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 01:09:34 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF882712;
        Tue, 25 Apr 2023 22:09:31 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 33Q5972V112529;
        Wed, 26 Apr 2023 00:09:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1682485747;
        bh=o/7xYbzWWzdYqeV6AMQFfp+G8pdckpJEHJ3AV7GT4v4=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=dsl1D43Fb/o73og51FOpr5UWiI9tkED4MpDBESMOYevSIHTafhpvra4i7EFOhyoai
         oJesowAy9Y0nPe2x/5VE55eAJEcQ+THiNZdn5cDnsMWp01nk/Rw2mml/aR4v2dKtak
         cFyPQuHlKseqTp0HNYRrd7U6Y5jKy9sZCQ1scHhw=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 33Q597Nq036320
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 26 Apr 2023 00:09:07 -0500
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Wed, 26
 Apr 2023 00:09:06 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Wed, 26 Apr 2023 00:09:06 -0500
Received: from [172.24.145.61] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 33Q592lj013845;
        Wed, 26 Apr 2023 00:09:03 -0500
Message-ID: <540149d0-a353-7225-7c58-a4e9738b7c7c@ti.com>
Date:   Wed, 26 Apr 2023 10:39:02 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
CC:     <s-vadapalli@ti.com>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>
Subject: Re: [RFC PATCH 1/2] net: phy: dp83867: add w/a for packet errors seen
 with short cables
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
References: <20230425054429.3956535-1-s-vadapalli@ti.com>
 <20230425054429.3956535-2-s-vadapalli@ti.com>
 <f29411d2-c596-4a07-8b6a-7d6e203c25e0@lunn.ch>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <f29411d2-c596-4a07-8b6a-7d6e203c25e0@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 25/04/23 17:35, Andrew Lunn wrote:
> On Tue, Apr 25, 2023 at 11:14:28AM +0530, Siddharth Vadapalli wrote:
>> From: Grygorii Strashko <grygorii.strashko@ti.com>
>>
>> Introduce the W/A for packet errors seen with short cables (<1m) between
>> two DP83867 PHYs.
>>
>> The W/A recommended by DM requires FFE Equalizer Configuration tuning by
>> writing value 0x0E81 to DSP_FFE_CFG register (0x012C), surrounded by hard
>> and soft resets as follows:
>>
>> write_reg(0x001F, 0x8000); //hard reset
>> write_reg(DSP_FFE_CFG, 0x0E81);
>> write_reg(0x001F, 0x4000); //soft reset
>>
>> Since  DP83867 PHY DM says "Changing this register to 0x0E81, will not
>> affect Long Cable performance.", enable the W/A by default.
>>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> 
> https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html
> 
> Please set the tree in the Subject line to be net.
> Please also add a Fixes: tag, probably for the patch which added this driver.

I will update the subject to "RFC PATCH net" and also add the "Fixes" tag in the
v2 series.

> 
> 
> 
> 
>> ---
>>  drivers/net/phy/dp83867.c | 15 ++++++++++++++-
>>  1 file changed, 14 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
>> index 5821f04c69dc..ba60cf35872e 100644
>> --- a/drivers/net/phy/dp83867.c
>> +++ b/drivers/net/phy/dp83867.c
>> @@ -42,6 +42,7 @@
>>  #define DP83867_STRAP_STS1	0x006E
>>  #define DP83867_STRAP_STS2	0x006f
>>  #define DP83867_RGMIIDCTL	0x0086
>> +#define DP83867_DSP_FFE_CFG	0X012C
>>  #define DP83867_RXFCFG		0x0134
>>  #define DP83867_RXFPMD1	0x0136
>>  #define DP83867_RXFPMD2	0x0137
>> @@ -934,8 +935,20 @@ static int dp83867_phy_reset(struct phy_device *phydev)
>>  
>>  	usleep_range(10, 20);
>>  
>> -	return phy_modify(phydev, MII_DP83867_PHYCTRL,
>> +	err = phy_modify(phydev, MII_DP83867_PHYCTRL,
>>  			 DP83867_PHYCR_FORCE_LINK_GOOD, 0);
>> +	if (err < 0)
>> +		return err;
>> +
>> +	phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_DSP_FFE_CFG, 0X0E81);
> 
> Maybe check the return code for errors?

The return value of phy_write_mmd() doesn't have to be checked since it will be
zero for the following reasons:
The dp83867 driver does not have a custom .write_mmd method. Also, the dp83867
phy does not support clause 45. Due to this, within __phy_write_mmd(), the ELSE
statement will be executed, which results in the return value being zero.

> 
>       Andrew

-- 
Regards,
Siddharth.
