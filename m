Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDCB63401F
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 16:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233015AbiKVPZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 10:25:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232783AbiKVPZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 10:25:35 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545A95C775
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 07:25:34 -0800 (PST)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NGp3D5jfDzHw0q;
        Tue, 22 Nov 2022 23:24:56 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 23:25:32 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 23:25:31 +0800
Subject: Re: [PATCH net] net: devlink: fix UAF in
 devlink_compat_running_version()
To:     Leon Romanovsky <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <jiri@nvidia.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
References: <20221122121048.776643-1-yangyingliang@huawei.com>
 <Y3zdaX1I0Y8rdSLn@unreal>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <e311b567-8130-15de-8dbb-06878339c523@huawei.com>
Date:   Tue, 22 Nov 2022 23:25:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <Y3zdaX1I0Y8rdSLn@unreal>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
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

Hi,

On 2022/11/22 22:32, Leon Romanovsky wrote:
> On Tue, Nov 22, 2022 at 08:10:48PM +0800, Yang Yingliang wrote:
>> I got a UAF report as following when doing fault injection test:
>>
>> BUG: KASAN: use-after-free in devlink_compat_running_version+0x5b9/0x6a0
>> Read of size 8 at addr ffff88810ac591f0 by task systemd-udevd/458
>>
>> CPU: 2 PID: 458 Comm: systemd-udevd Not tainted 6.1.0-rc5-00155-ga9d2b54dd4e7-dirty #1359
>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
>> Call Trace:
>>   <TASK>
>>   kasan_report+0x90/0x190
>>   devlink_compat_running_version+0x5b9/0x6a0
>>   dev_ethtool+0x2ca/0x340
>>   dev_ioctl+0x16c/0xff0
>>   sock_do_ioctl+0x1ae/0x220
>>
>> Allocated by task 456:
>>   kasan_save_stack+0x1c/0x40
>>   kasan_set_track+0x21/0x30
>>   __kasan_kmalloc+0x7e/0x90
>>   __kmalloc+0x59/0x1b0
>>   devlink_alloc_ns+0xf7/0xa10
>>   nsim_drv_probe+0xa8/0x150 [netdevsim]
>>   really_probe+0x1ff/0x660
>>
>> Freed by task 456:
>>   kasan_save_stack+0x1c/0x40
>>   kasan_set_track+0x21/0x30
>>   kasan_save_free_info+0x2a/0x50
>>   __kasan_slab_free+0x102/0x190
>>   __kmem_cache_free+0xca/0x400
>>   nsim_drv_probe.cold.31+0x2af/0xf62 [netdevsim]
>>   really_probe+0x1ff/0x660
>>
>> It happened like this:
>>
>> processor A							processor B
>> nsim_drv_probe()
>>    devlink_alloc_ns()
>>    nsim_dev_port_add_all()
>>      __nsim_dev_port_add() // add eth1 successful
>> 								dev_ethtool()
>> 								  ethtool_get_drvinfo(eth1)
>> 								    netdev_to_devlink_get(eth1)
>> 								      devlink_try_get() // get devlink here
>>      __nsim_dev_port_add() // add eth2 failed, goto error
>>        devlink_free() // it's called in the error path
>> 								  devlink_compat_running_version() <- causes UAF
>>    devlink_register() // it's in normal path, not called yet
>>
>> There is two ports to add in nsim_dev_port_add_all(), if first
>> port is added successful, the devlink is visable and can be get
>> by devlink_try_get() on another cpu, but it is not registered
>> yet. And then the second port is failed to added, in the error
>> path, devlink_free() is called, at last it causes UAF.
>>
>> Add check in devlink_try_get(), if the 'devlink' is not registered
>> it returns NULL to avoid UAF like this case.
>>
>> Fixes: a62fdbbe9403 ("netdevsim: implement ndo_get_devlink_port")
>> Reported-by: Zhengchao Shao <shaozhengchao@huawei.com>
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>> ---
>>   net/core/devlink.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index 89baa7c0938b..6453ac0558fb 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -250,6 +250,9 @@ void devlink_put(struct devlink *devlink)
>>   
>>   struct devlink *__must_check devlink_try_get(struct devlink *devlink)
>>   {
>> +	 if (!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED))
>> +		return NULL;
>> +
> Please fix nsim instead of devlink.
I think if devlink is not registered, it can not be get and used, but there
is no API for driver to check this, can I introduce a new helper name
devlink_is_registered() for driver using.

Thanks,
Yang
>
> Thanks
>
>>   	if (refcount_inc_not_zero(&devlink->refcount))
>>   		return devlink;
>>   	return NULL;
>> -- 
>> 2.25.1
>>
> .
