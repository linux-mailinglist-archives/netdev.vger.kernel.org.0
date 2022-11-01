Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309EF614831
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 12:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiKALHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 07:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiKALHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 07:07:20 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E71DC18E23;
        Tue,  1 Nov 2022 04:07:14 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N1nKT3ccCzmVZB;
        Tue,  1 Nov 2022 19:07:09 +0800 (CST)
Received: from dggpemm500013.china.huawei.com (7.185.36.172) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 1 Nov 2022 19:07:12 +0800
Received: from [10.67.108.67] (10.67.108.67) by dggpemm500013.china.huawei.com
 (7.185.36.172) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 1 Nov
 2022 19:07:11 +0800
Message-ID: <210a2edd-8238-173f-9733-6f92289b7e09@huawei.com>
Date:   Tue, 1 Nov 2022 19:07:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0
Subject: Re: [PATCH] net/smc: Fix possible leaked pernet namespace in
 smc_init()
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>
CC:     <linux-kernel@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kgraul@linux.ibm.com>,
        <wenjia@linux.ibm.com>, <jaka@linux.ibm.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <guvenc@linux.ibm.com>
References: <20221101093722.127223-1-chenzhongjin@huawei.com>
 <Y2D8PvHrKtpjTdJ1@TonyMac-Alibaba>
From:   Chen Zhongjin <chenzhongjin@huawei.com>
In-Reply-To: <Y2D8PvHrKtpjTdJ1@TonyMac-Alibaba>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.108.67]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500013.china.huawei.com (7.185.36.172)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2022/11/1 19:00, Tony Lu wrote:
> On Tue, Nov 01, 2022 at 05:37:22PM +0800, Chen Zhongjin wrote:
>> In smc_init(), register_pernet_subsys(&smc_net_stat_ops) is called
>> without any error handling.
>> If it fails, registering of &smc_net_ops won't be reverted.
>> And if smc_nl_init() fails, &smc_net_stat_ops itself won't be reverted.
>>
>> This leaves wild ops in subsystem linkedlist and when another module
>> tries to call register_pernet_operations() it triggers page fault:
>>
>> BUG: unable to handle page fault for address: fffffbfff81b964c
>> RIP: 0010:register_pernet_operations+0x1b9/0x5f0
>> Call Trace:
>>    <TASK>
>>    register_pernet_subsys+0x29/0x40
>>    ebtables_init+0x58/0x1000 [ebtables]
>>    ...
>>
>> Fixes: 194730a9beb5 ("net/smc: Make SMC statistics network namespace aware")
>> Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
> This patch looks good to me.
>
> The subject of this patch should be in net, the prefix tag is missed.

Thanks for review and remind! I will add net tag for the next time I 
send patch to netdev.


Best,

Chen

>
> Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
>
>> ---
>>   net/smc/af_smc.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
>> index 3ccbf3c201cd..e12d4fa5aece 100644
>> --- a/net/smc/af_smc.c
>> +++ b/net/smc/af_smc.c
>> @@ -3380,14 +3380,14 @@ static int __init smc_init(void)
>>   
>>   	rc = register_pernet_subsys(&smc_net_stat_ops);
>>   	if (rc)
>> -		return rc;
>> +		goto out_pernet_subsys;
>>   
>>   	smc_ism_init();
>>   	smc_clc_init();
>>   
>>   	rc = smc_nl_init();
>>   	if (rc)
>> -		goto out_pernet_subsys;
>> +		goto out_pernet_subsys_stat;
>>   
>>   	rc = smc_pnet_init();
>>   	if (rc)
>> @@ -3480,6 +3480,8 @@ static int __init smc_init(void)
>>   	smc_pnet_exit();
>>   out_nl:
>>   	smc_nl_exit();
>> +out_pernet_subsys_stat:
>> +	unregister_pernet_subsys(&smc_net_stat_ops);
>>   out_pernet_subsys:
>>   	unregister_pernet_subsys(&smc_net_ops);
>>   
>> -- 
>> 2.17.1
