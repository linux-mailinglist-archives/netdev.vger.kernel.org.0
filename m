Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76B6460C679
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 10:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbiJYIcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 04:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbiJYIct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 04:32:49 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C16EA3B82
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 01:32:48 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MxQDL2tdWzHvDp;
        Tue, 25 Oct 2022 16:32:34 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 25 Oct 2022 16:32:46 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 25 Oct 2022 16:32:46 +0800
Subject: Re: [PATCH net-next 1/2] net: natsemi: xtsonic: switch to use
 platform_get_irq()
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>
References: <20221025031236.1031330-1-yangyingliang@huawei.com>
 <20221024211148.6522caac@kernel.org>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <dcc26fd7-9a4b-7f0a-979c-14d989bb2af8@huawei.com>
Date:   Tue, 25 Oct 2022 16:32:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20221024211148.6522caac@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2022/10/25 12:11, Jakub Kicinski wrote:
> On Tue, 25 Oct 2022 11:12:35 +0800 Yang Yingliang wrote:
>> Switch to use platform_get_irq() which supports more cases.
> More cases of what? You need to explain what you're trying to achieve
> and why you're touching this old driver.
platform_get_irq() is a common API which calls of_irq_get(), 
platform_get_resource() or
acpi_dev_gpio_irq_get() to get irq, and it returns exactly error code.

Thanks,
Yang
>
>> diff --git a/drivers/net/ethernet/natsemi/xtsonic.c b/drivers/net/ethernet/natsemi/xtsonic.c
>> index 52fef34d43f9..ffb3814c54cb 100644
>> --- a/drivers/net/ethernet/natsemi/xtsonic.c
>> +++ b/drivers/net/ethernet/natsemi/xtsonic.c
>> @@ -201,14 +201,17 @@ int xtsonic_probe(struct platform_device *pdev)
>>   {
>>   	struct net_device *dev;
>>   	struct sonic_local *lp;
>> -	struct resource *resmem, *resirq;
>> +	struct resource *resmem;
>> +	int irq;
>>   	int err = 0;
> The variable declaration lines should be sorted longest to shortest.
>
>>   	if ((resmem = platform_get_resource(pdev, IORESOURCE_MEM, 0)) == NULL)
>>   		return -ENODEV;
>>   
>> -	if ((resirq = platform_get_resource(pdev, IORESOURCE_IRQ, 0)) == NULL)
>> -		return -ENODEV;
>> +	irq = platform_get_irq(pdev, 0);
>> +	if (irq < 0)
>> +		return irq;
>> +
>>   
> extra new line
> .
