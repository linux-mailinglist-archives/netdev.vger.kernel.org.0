Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D101627D52
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 13:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236419AbiKNMGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 07:06:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236990AbiKNMGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 07:06:21 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A11D41
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 04:06:20 -0800 (PST)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N9p194R60zHw5X;
        Mon, 14 Nov 2022 20:05:49 +0800 (CST)
Received: from [10.174.178.41] (10.174.178.41) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 14 Nov 2022 20:06:18 +0800
Message-ID: <8d761ff6-9520-4216-e2bb-f05af21b0647@huawei.com>
Date:   Mon, 14 Nov 2022 20:06:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH] net: thunderbolt: Fix error handling in tbnet_init()
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
CC:     <michael.jamet@intel.com>, <YehezkelShB@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <andriy.shevchenko@linux.intel.com>,
        <amir.jer.levy@intel.com>, <netdev@vger.kernel.org>
References: <20221114081936.35804-1-yuancan@huawei.com>
 <Y3IT7aiOOe2b3Qhy@black.fi.intel.com>
From:   Yuan Can <yuancan@huawei.com>
In-Reply-To: <Y3IT7aiOOe2b3Qhy@black.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.41]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2022/11/14 18:09, Mika Westerberg 写道:
> Hi,
>
> On Mon, Nov 14, 2022 at 08:19:36AM +0000, Yuan Can wrote:
>> A problem about insmod thunderbolt-net failed is triggered with following
>> log given while lsmod does not show thunderbolt_net:
>>
>>   insmod: ERROR: could not insert module thunderbolt-net.ko: File exists
>>
>> The reason is that tbnet_init() returns tb_register_service_driver()
>> directly without checking its return value, if tb_register_service_driver()
>> failed, it returns without removing property directory, resulting the
>> property directory can never be created later.
>>
>>   tbnet_init()
>>     tb_register_property_dir() # register property directory
>>     tb_register_service_driver()
>>       driver_register()
>>         bus_add_driver()
>>           priv = kzalloc(...) # OOM happened
>>     # return without remove property directory
>>
>> Fix by remove property directory when tb_register_service_driver() returns
>> error.
>>
>> Fixes: e69b6c02b4c3 ("net: Add support for networking over Thunderbolt cable")
>> Signed-off-by: Yuan Can <yuancan@huawei.com>
>> ---
>>   drivers/net/thunderbolt.c | 9 ++++++++-
>>   1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
>> index 83fcaeb2ac5e..fe6a9881cc75 100644
>> --- a/drivers/net/thunderbolt.c
>> +++ b/drivers/net/thunderbolt.c
>> @@ -1396,7 +1396,14 @@ static int __init tbnet_init(void)
>>   		return ret;
>>   	}
>>   
>> -	return tb_register_service_driver(&tbnet_driver);
>> +	ret = tb_register_service_driver(&tbnet_driver);
>> +	if (ret) {
>> +		tb_unregister_property_dir("network", tbnet_dir);
>> +		tb_property_free_dir(tbnet_dir);
>> +		return ret;
>> +	}
>> +
>> +	return 0;
> Okay but I suggest that you make it like:
>
> 	ret = tb_register_property_dir("network", tbnet_dir);
> 	if (ret)
> 		goto err_free_dir;
>
> 	ret = tb_register_service_driver(&tbnet_driver);
> 	if (ret)
> 		goto err_unregister;
>
> 	return 0;
>
> err_unregister:
> 	tb_unregister_property_dir("network", tbnet_dir);
> err_free_dir:
> 	tb_property_free_dir(tbnet_dir);
>
> 	return ret;
>
> }
Ok, thanks for the suggestion! I will switch to this style in the v2 patch.

-- 
Best regards,
Yuan Can

