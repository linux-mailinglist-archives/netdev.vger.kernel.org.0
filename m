Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04A5860CCBD
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 14:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232481AbiJYMyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 08:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbiJYMyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 08:54:23 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54CB516F75C
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 05:51:00 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MxWrq18wczmV7g;
        Tue, 25 Oct 2022 20:46:03 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 25 Oct 2022 20:50:55 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 25 Oct 2022 20:50:54 +0800
Subject: Re: [PATCH net] net: ehea: fix possible memory leak in
 ehea_register_port()
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     <dougmill@linux.ibm.com>, <davem@davemloft.net>, <kuba@kernel.org>
References: <20221022113722.3409846-1-yangyingliang@huawei.com>
 <0ea0057771c623ca3a37a79fc953fd34c54aa815.camel@redhat.com>
 <207fa9fb-2ea5-fa0e-ab56-22d535749132@huawei.com>
Message-ID: <1d186b5a-c201-20ae-b513-7152e09f8f43@huawei.com>
Date:   Tue, 25 Oct 2022 20:50:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <207fa9fb-2ea5-fa0e-ab56-22d535749132@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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


On 2022/10/25 20:16, Yang Yingliang wrote:
> Hi,
>
> On 2022/10/25 19:55, Paolo Abeni wrote:
>> Hello,
>>
>> On Sat, 2022-10-22 at 19:37 +0800, Yang Yingliang wrote:
>>> dev_set_name() in ehea_register_port() allocates memory for name,
>>> it need be freed when of_device_register() fails, call put_device()
>>> to give up the reference that hold in device_initialize(), so that
>>> it can be freed in kobject_cleanup() when the refcount hit to 0.
>>>
>>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>>> ---
>>>   drivers/net/ethernet/ibm/ehea/ehea_main.c | 1 +
>>>   1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c 
>>> b/drivers/net/ethernet/ibm/ehea/ehea_main.c
>>> index 294bdbbeacc3..b4aff59b3eb4 100644
>>> --- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
>>> +++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
>>> @@ -2900,6 +2900,7 @@ static struct device 
>>> *ehea_register_port(struct ehea_port *port,
>>>       ret = of_device_register(&port->ofdev);
>>>       if (ret) {
>>>           pr_err("failed to register device. ret=%d\n", ret);
>>> +        put_device(&port->ofdev.dev);
>>>           goto out;
>>>       }
>> You need to include a suitable Fixes tag into the commit message.
>> Additionally, if you have a kmemleak splat handy, please include even
>> that in the commit message.
> Fixes: 1fa5ae857bb1 ("driver core: get rid of struct device's bus_id 
> string array")
>
> Afer commit 1fa5ae857bb1 ("driver core: get rid of struct device's
> bus_id string array"), the name of device is allocated dynamically.
It should be 1acf2318dd13 ("ehea: dynamic add / remove port"). I will
add it in v2.

Thanks,
Yang
>
>>
>> Thanks!
>>
>> Paolo
>>
>>
>> .
>
> .
