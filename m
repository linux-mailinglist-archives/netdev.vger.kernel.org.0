Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13E78633D11
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 14:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbiKVNFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 08:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiKVNFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 08:05:08 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF3021276
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 05:05:07 -0800 (PST)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NGkxJ61X4zRpR1;
        Tue, 22 Nov 2022 21:04:36 +0800 (CST)
Received: from [10.67.110.176] (10.67.110.176) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 21:05:05 +0800
Subject: Re: [PATCH net] net: ethernet: wiznet: w5300: free irq when alloc
 link_name failed in w5300_hw_probe()
To:     Leon Romanovsky <leon@kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <thomas.lendacky@amd.com>,
        <shayagr@amazon.com>, <wsa+renesas@sang-engineering.com>,
        <msink@permonline.ru>, <netdev@vger.kernel.org>
References: <20221119071007.3858043-1-cuigaosheng1@huawei.com>
 <Y3zAUi5phHtYkjbb@unreal>
From:   cuigaosheng <cuigaosheng1@huawei.com>
Message-ID: <3c9cd269-7cc2-8d5a-4a12-6dc3a32ef1b5@huawei.com>
Date:   Tue, 22 Nov 2022 21:05:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <Y3zAUi5phHtYkjbb@unreal>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.176]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>    579                 if (request_any_context_irq(priv->link_irq, w5300_detect_link,
>    580                                 IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
>    581                                 link_name, priv->ndev) < 0)
>    582                         priv->link_gpio = -EINVAL;
>
> You should call to same free_irq(irq, ndev) in this "if" too.
>
> Thanks

Thanks for taking time to review this patch, if request_any_context_irq(...) failed,
w5300_hw_probe will return 0(success), should I call the free_irq(...) in this case?

Thanks.

On 2022/11/22 20:28, Leon Romanovsky wrote:
> On Sat, Nov 19, 2022 at 03:10:07PM +0800, Gaosheng Cui wrote:
>> When alloc link_name failed in w5300_hw_probe(), irq has not been
>> freed. Fix it.
>>
>> Fixes: 9899b81e7ca5 ("Ethernet driver for the WIZnet W5300 chip")
>> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
>> ---
>>   drivers/net/ethernet/wiznet/w5300.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/wiznet/w5300.c b/drivers/net/ethernet/wiznet/w5300.c
>> index b0958fe8111e..5571d4c365e9 100644
>> --- a/drivers/net/ethernet/wiznet/w5300.c
>> +++ b/drivers/net/ethernet/wiznet/w5300.c
>> @@ -572,8 +572,10 @@ static int w5300_hw_probe(struct platform_device *pdev)
>>   	priv->link_gpio = data ? data->link_gpio : -EINVAL;
>>   	if (gpio_is_valid(priv->link_gpio)) {
>>   		char *link_name = devm_kzalloc(&pdev->dev, 16, GFP_KERNEL);
>> -		if (!link_name)
>> +		if (!link_name) {
>> +			free_irq(irq, ndev);
>>   			return -ENOMEM;
>> +		}
>>   		snprintf(link_name, 16, "%s-link", name);
>>   		priv->link_irq = gpio_to_irq(priv->link_gpio);
>>   		if (request_any_context_irq(priv->link_irq, w5300_detect_link,
>    579                 if (request_any_context_irq(priv->link_irq, w5300_detect_link,
>    580                                 IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
>    581                                 link_name, priv->ndev) < 0)
>    582                         priv->link_gpio = -EINVAL;
>
> You should call to same free_irq(irq, ndev) in this "if" too.
>
> Thanks
>
>> -- 
>> 2.25.1
>>
> .
