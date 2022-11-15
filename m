Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACA0C629398
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 09:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237062AbiKOIut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 03:50:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236432AbiKOIur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 03:50:47 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB62FF5B6;
        Tue, 15 Nov 2022 00:50:44 -0800 (PST)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NBKdB2LZ4zmVt0;
        Tue, 15 Nov 2022 16:50:22 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (7.193.23.191) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 16:50:43 +0800
Received: from [10.67.109.54] (10.67.109.54) by kwepemm600005.china.huawei.com
 (7.193.23.191) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 15 Nov
 2022 16:50:42 +0800
Subject: Re: [PATCH] net: mvpp2: fix possible invalid pointer dereference
To:     Leon Romanovsky <leon@kernel.org>
References: <20221115044632.181769-1-tanghui20@huawei.com>
 <Y3NQ+MWftmZAuUEc@unreal>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <mw@semihalf.com>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yusongping@huawei.com>
From:   Hui Tang <tanghui20@huawei.com>
Message-ID: <0562e5c5-6c4e-4c61-f175-c06dad61b506@huawei.com>
Date:   Tue, 15 Nov 2022 16:50:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <Y3NQ+MWftmZAuUEc@unreal>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.109.54]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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



On 2022/11/15 16:42, Leon Romanovsky wrote:
> On Tue, Nov 15, 2022 at 12:46:32PM +0800, Hui Tang wrote:
>> It will cause invalid pointer dereference to priv->cm3_base behind,
>> if PTR_ERR(priv->cm3_base) in mvpp2_get_sram().
>>
>> Fixes: a59d354208a7 ("net: mvpp2: enable global flow control")
>> Signed-off-by: Hui Tang <tanghui20@huawei.com>
>> ---
>>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
>> index d98f7e9a480e..c92bd1922421 100644
>> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
>> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
>> @@ -7421,7 +7421,7 @@ static int mvpp2_probe(struct platform_device *pdev)
>>  			dev_warn(&pdev->dev, "Fail to alloc CM3 SRAM\n");
>>
>>  		/* Enable global Flow Control only if handler to SRAM not NULL */
>> -		if (priv->cm3_base)
>> +		if (!IS_ERR_OR_NULL(priv->cm3_base))
>>  			priv->global_tx_fc = true;
>
> The change is ok, but the patch title should include target, in your
> case it is net -> [PATCH net] ....

Thanks, I will fix it in v2.
