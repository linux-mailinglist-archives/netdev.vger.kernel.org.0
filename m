Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C524623972
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 03:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbiKJCDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 21:03:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232618AbiKJCCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 21:02:12 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C91393
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 18:00:31 -0800 (PST)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N74mJ54Chz15MH0;
        Thu, 10 Nov 2022 10:00:16 +0800 (CST)
Received: from [10.174.178.41] (10.174.178.41) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 10:00:29 +0800
Message-ID: <5980dba5-1323-e08b-252c-8d5365584db6@huawei.com>
Date:   Thu, 10 Nov 2022 10:00:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH] net: hinic: Fix error handling in hinic_module_init()
To:     Francois Romieu <romieu@fr.zoreil.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <mqaio@linux.alibaba.com>,
        <shaozhengchao@huawei.com>, <christophe.jaillet@wanadoo.fr>,
        <gustavoars@kernel.org>, <luobin9@huawei.com>,
        <netdev@vger.kernel.org>
References: <20221109112315.125135-1-yuancan@huawei.com>
 <Y2vpyGB+iivl0L+K@electric-eye.fr.zoreil.com>
From:   Yuan Can <yuancan@huawei.com>
In-Reply-To: <Y2vpyGB+iivl0L+K@electric-eye.fr.zoreil.com>
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


在 2022/11/10 1:56, Francois Romieu 写道:
> Yuan Can <yuancan@huawei.com> :
> [...]
>> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
>> index e1f54a2f28b2..b2fcd83d58fa 100644
>> --- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
>> +++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
>> @@ -1474,8 +1474,17 @@ static struct pci_driver hinic_driver = {
>>   
>>   static int __init hinic_module_init(void)
>>   {
>> +	int ret;
>> +
>>   	hinic_dbg_register_debugfs(HINIC_DRV_NAME);
>> -	return pci_register_driver(&hinic_driver);
>> +
>> +	ret = pci_register_driver(&hinic_driver);
>> +	if (ret) {
>> +		hinic_dbg_unregister_debugfs();
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>>   }
> You can remove some fat:
>
> 	ret = pci_register_driver(&hinic_driver);
> 	if (ret)
> 		hinic_dbg_unregister_debugfs();
>
> 	return ret;
Thanks for the suggestion! I will change to this style.

-- 
Best regards,
Yuan Can

