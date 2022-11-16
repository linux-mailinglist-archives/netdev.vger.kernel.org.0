Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C40D862B324
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 07:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232398AbiKPGNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 01:13:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbiKPGNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 01:13:20 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 369C3248C4;
        Tue, 15 Nov 2022 22:13:18 -0800 (PST)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NBt4s3Vb6zHvwR;
        Wed, 16 Nov 2022 14:12:45 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (7.193.23.191) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 16 Nov 2022 14:13:15 +0800
Received: from [10.67.109.54] (10.67.109.54) by kwepemm600005.china.huawei.com
 (7.193.23.191) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 16 Nov
 2022 14:13:15 +0800
Subject: Re: [PATCH net v4] net: mvpp2: fix possible invalid pointer
 dereference
To:     Jakub Kicinski <kuba@kernel.org>
References: <20221116020617.137247-1-tanghui20@huawei.com>
 <20221116021437.145204-1-tanghui20@huawei.com>
 <20221115202850.7beeea87@kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <mw@semihalf.com>,
        <linux@armlinux.org.uk>, <leon@kernel.org>, <andrew@lunn.ch>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yusongping@huawei.com>
From:   Hui Tang <tanghui20@huawei.com>
Message-ID: <a061d870-d0ce-a580-636d-600a9a4b006f@huawei.com>
Date:   Wed, 16 Nov 2022 14:13:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20221115202850.7beeea87@kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.109.54]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600005.china.huawei.com (7.193.23.191)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/11/16 12:28, Jakub Kicinski wrote:
> On Wed, 16 Nov 2022 10:14:37 +0800 Hui Tang wrote:
>> It will cause invalid pointer dereference to priv->cm3_base behind,
>> if PTR_ERR(priv->cm3_base) in mvpp2_get_sram().
>>
>> Fixes: a59d354208a7 ("net: mvpp2: enable global flow control")
>> Signed-off-by: Hui Tang <tanghui20@huawei.com>
>
> Please do not repost new versions so often:
>
> https://www.kernel.org/doc/html/next/process/maintainer-netdev.html#tl-dr
>
> do not use --in-reply-to

Thanks for pointing out, but should I resend it with [PATCH net v3]  or [PATCH net v5]?

>> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
>> index d98f7e9a480e..efb582b63640 100644
>> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
>> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
>> @@ -7349,6 +7349,7 @@ static int mvpp2_get_sram(struct platform_device *pdev,
>>  			  struct mvpp2 *priv)
>>  {
>>  	struct resource *res;
>> +	void __iomem *base;
>>
>>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
>>  	if (!res) {
>> @@ -7359,9 +7360,11 @@ static int mvpp2_get_sram(struct platform_device *pdev,
>>  		return 0;
>>  	}
>>
>> -	priv->cm3_base = devm_ioremap_resource(&pdev->dev, res);
>> +	base = devm_ioremap_resource(&pdev->dev, res);
>> +	if (!IS_ERR(base))
>> +		priv->cm3_base = base;
>>
>> -	return PTR_ERR_OR_ZERO(priv->cm3_base);
>> +	return PTR_ERR_OR_ZERO(base);
>
> Use the idiomatic error handling, keep success path un-indented:
>
> 	ptr = function();
> 	if (IS_ERR(ptr))
> 		return PTR_ERR(ptr);
>
> 	priv->bla = ptr;
> 	return 0;
> 	
>
Ok, I will fix it in next version
