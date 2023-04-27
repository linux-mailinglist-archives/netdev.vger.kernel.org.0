Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 351B06F000A
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 06:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242702AbjD0EDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 00:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjD0EDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 00:03:37 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E092B2704;
        Wed, 26 Apr 2023 21:03:34 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 33R432v9020046;
        Wed, 26 Apr 2023 23:03:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1682568182;
        bh=lDWkxQMIi5UtNEXMZtZpvamrMU+V3PJfdZn3N1fqqkw=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=Q296x6S+W49hPkji144wQCUX/Z7gbmaGFb+LsgAkRYPFGRe3IvRvT+VLJ/ucXkGoy
         oOxuwuHDhcMNviuKs0pEAFPMCCsGHaFGB/DBqYcPY3qqHvPrQJYKtYJvdpYn2ZPcKE
         F0gaxOL5W+edR6inripbPbXfMBTSBLYHcBE1BXZo=
Received: from DFLE105.ent.ti.com (dfle105.ent.ti.com [10.64.6.26])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 33R4327w025674
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 26 Apr 2023 23:03:02 -0500
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Wed, 26
 Apr 2023 23:03:02 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Wed, 26 Apr 2023 23:03:01 -0500
Received: from [172.24.145.61] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 33R42wOu062580;
        Wed, 26 Apr 2023 23:02:58 -0500
Message-ID: <5a5b4348-0744-ff6b-6354-c4d0243c4fc6@ti.com>
Date:   Thu, 27 Apr 2023 09:32:57 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
CC:     <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: Re: [RFC PATCH 1/2] net: phy: dp83867: add w/a for packet errors seen
 with short cables
To:     Andrew Lunn <andrew@lunn.ch>
References: <20230425054429.3956535-1-s-vadapalli@ti.com>
 <20230425054429.3956535-2-s-vadapalli@ti.com>
 <f29411d2-c596-4a07-8b6a-7d6e203c25e0@lunn.ch>
 <540149d0-a353-7225-7c58-a4e9738b7c7c@ti.com>
 <38d9b4f9-06b5-4920-8b09-daa115bd52f4@lunn.ch>
Content-Language: en-US
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <38d9b4f9-06b5-4920-8b09-daa115bd52f4@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26/04/23 18:06, Andrew Lunn wrote:
>>>> @@ -934,8 +935,20 @@ static int dp83867_phy_reset(struct phy_device *phydev)
>>>>  
>>>>  	usleep_range(10, 20);
>>>>  
>>>> -	return phy_modify(phydev, MII_DP83867_PHYCTRL,
>>>> +	err = phy_modify(phydev, MII_DP83867_PHYCTRL,
>>>>  			 DP83867_PHYCR_FORCE_LINK_GOOD, 0);
>>>> +	if (err < 0)
>>>> +		return err;
>>>> +
>>>> +	phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_DSP_FFE_CFG, 0X0E81);
>>>
>>> Maybe check the return code for errors?
>>
>> The return value of phy_write_mmd() doesn't have to be checked since it will be
>> zero for the following reasons:
>> The dp83867 driver does not have a custom .write_mmd method. Also, the dp83867
>> phy does not support clause 45. Due to this, within __phy_write_mmd(), the ELSE
>> statement will be executed, which results in the return value being zero.
> 
> Interesting.
> 
> I would actually say __phy_write_mmd() is broken, and should be
> returning what __mdiobus_write() returns.
> 
> You should assume it will get fixed, and check the return value. And
> it does no harm to check the return value.

Thank you for clarifying. The reasoning behind the initial patch not checking
the return value was:
At all invocations of phy_write_mmd() in the dp83867 driver, at no place is the
return value checked, which led me to analyze why that was the case. I noticed
that it was due to the return value being guaranteed to be zero for this
particular driver.

Since the existing __phy_write_mmd() implementation is broken as pointed out by
you, I will update this patch to check the return value. Also, I will probably
add a cleanup patch as well, to fix this at all other invocations of
phy_write_mmd() in the driver.

-- 
Regards,
Siddharth.
