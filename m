Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0D96073A8
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 11:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbiJUJNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 05:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbiJUJNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 05:13:30 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2C915FDA
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 02:13:15 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MtzFy1mGczJn44;
        Fri, 21 Oct 2022 17:10:30 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 21 Oct 2022 17:13:11 +0800
Message-ID: <297b3e63-efa5-fc14-35d7-2f6e7e334122@huawei.com>
Date:   Fri, 21 Oct 2022 17:13:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net 1/2] netdevsim: fix memory leak in nsim_drv_probe()
 when nsim_dev_resources_register() failed
From:   shaozhengchao <shaozhengchao@huawei.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>, <jiri@mellanox.com>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
References: <20221020023358.263414-1-shaozhengchao@huawei.com>
 <20221020023358.263414-2-shaozhengchao@huawei.com>
 <20221020172612.0a8e60bb@kernel.org>
 <ec77bbe9-7ced-8d9a-909c-9e6658b28e31@huawei.com>
In-Reply-To: <ec77bbe9-7ced-8d9a-909c-9e6658b28e31@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/10/21 16:28, shaozhengchao wrote:
> 
> 
> On 2022/10/21 8:26, Jakub Kicinski wrote:
>> On Thu, 20 Oct 2022 10:33:57 +0800 Zhengchao Shao wrote:
>>> Fixes: 8fb4bc6fd5bd ("netdevsim: rename devlink.c to dev.c to contain 
>>> per-dev(asic) items")
>>
>> Looks like a rename patch.
>>
>> The Fixes tag must point to the commit which introduced the bug.
>>
> OK, I will check it.
Sorry, I check this commit introduce the bug. What do I have missed?

>>> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
>>> index 794fc0cc73b8..39231c5319de 100644
>>> --- a/drivers/net/netdevsim/dev.c
>>> +++ b/drivers/net/netdevsim/dev.c
>>> @@ -1554,7 +1554,7 @@ int nsim_drv_probe(struct nsim_bus_dev 
>>> *nsim_bus_dev)
>>>       err = nsim_dev_resources_register(devlink);
>>>       if (err)
>>> -        goto err_vfc_free;
>>> +        goto err_dl_unregister;
>>
>> It's better to add the devl_resources_unregister() call to the error
>> path of nsim_dev_resources_register(). There should be no need to clean
>> up after functions when they fail.
>>
> Hi Jakub:
>      Thank you for your review. I will change it in v2.
> 
> Zhengchao Shao
>>>       err = devlink_params_register(devlink, nsim_devlink_params,
>>>                         ARRAY_SIZE(nsim_devlink_params));
>>> @@ -1627,7 +1627,6 @@ int nsim_drv_probe(struct nsim_bus_dev 
>>> *nsim_bus_dev)
>>>                     ARRAY_SIZE(nsim_devlink_params));
>>>   err_dl_unregister:
>>>       devl_resources_unregister(devlink);
>>> -err_vfc_free:
>>>       kfree(nsim_dev->vfconfigs);
> 
