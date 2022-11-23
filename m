Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 940856352CD
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 09:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236262AbiKWIez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 03:34:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235557AbiKWIey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 03:34:54 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2526F2C3C
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 00:34:51 -0800 (PST)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NHDtz3mZsz15Mpd;
        Wed, 23 Nov 2022 16:34:19 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 16:34:50 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 16:34:49 +0800
Subject: Re: [PATCH net] net: devlink: fix UAF in
 devlink_compat_running_version()
To:     Leon Romanovsky <leon@kernel.org>, Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <jiri@nvidia.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>
References: <20221122121048.776643-1-yangyingliang@huawei.com>
 <Y3zdaX1I0Y8rdSLn@unreal> <e311b567-8130-15de-8dbb-06878339c523@huawei.com>
 <Y30dPRzO045Od2FA@unreal> <20221122122740.4b10d67d@kernel.org>
 <405f703b-b97e-afdd-8d5f-48b8f99d045d@huawei.com> <Y33OpMvLcAcnJ1oj@unreal>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <fa1ab2fb-37ce-a810-8a3f-b71d902e8ff0@huawei.com>
Date:   Wed, 23 Nov 2022 16:34:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <Y33OpMvLcAcnJ1oj@unreal>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
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


On 2022/11/23 15:41, Leon Romanovsky wrote:
> On Wed, Nov 23, 2022 at 02:40:24PM +0800, Yang Yingliang wrote:
>> On 2022/11/23 4:27, Jakub Kicinski wrote:
>>> On Tue, 22 Nov 2022 21:04:29 +0200 Leon Romanovsky wrote:
>>>>>> Please fix nsim instead of devlink.
>>>>> I think if devlink is not registered, it can not be get and used, but there
>>>>> is no API for driver to check this, can I introduce a new helper name
>>>>> devlink_is_registered() for driver using.
>>>> There is no need in such API as driver calls to devlink_register() and
>>>> as such it knows when devlink is registered.
>>>>
>>>> This UAF is nsim specific issue. Real devices have single .probe()
>>>> routine with serialized registration flow. None of them will use
>>>> devlink_is_registered() call.
>>> Agreed, the fix is to move the register call back.
>>> Something along the lines of the untested patch below?
>>> Yang Yingliang would you be able to turn that into a real patch?
>>>
>>> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
>>> index e14686594a71..26602d5fe0a2 100644
>>> --- a/drivers/net/netdevsim/dev.c
>>> +++ b/drivers/net/netdevsim/dev.c
>>> @@ -1566,12 +1566,15 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
>>>    	err = devlink_params_register(devlink, nsim_devlink_params,
>>>    				      ARRAY_SIZE(nsim_devlink_params));
>>>    	if (err)
>>> -		goto err_dl_unregister;
>>> +		goto err_resource_unregister;
>>>    	nsim_devlink_set_params_init_values(nsim_dev, devlink);
>>> +	/* here, because params API still expect devlink to be unregistered */
>>> +	devl_register(devlink);
>>> +
>> devlink_set_features() called at last in probe() also needs devlink is not
>> registered.
>>>    	err = nsim_dev_dummy_region_init(nsim_dev, devlink);
>>>    	if (err)
>>> -		goto err_params_unregister;
>>> +		goto err_dl_unregister;
>>>    	err = nsim_dev_traps_init(devlink);
>>>    	if (err)
>>> @@ -1610,7 +1613,6 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
>>>    	nsim_dev->esw_mode = DEVLINK_ESWITCH_MODE_LEGACY;
>>>    	devlink_set_features(devlink, DEVLINK_F_RELOAD);
>>>    	devl_unlock(devlink);
>>> -	devlink_register(devlink);
>>>    	return 0;
>>>    err_hwstats_exit:
>>> @@ -1629,10 +1631,11 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
>>>    	nsim_dev_traps_exit(devlink);
>>>    err_dummy_region_exit:
>>>    	nsim_dev_dummy_region_exit(nsim_dev);
>>> -err_params_unregister:
>>> +err_dl_unregister:
>>> +	devl_unregister(devlink);
>> It races with dev_ethtool():
>> dev_ethtool
>>    devlink_try_get()
>>                                  nsim_drv_probe
>>                                  devl_lock()
>>      devl_lock()
>>                                  devlink_unregister()
>>                                    devlink_put()
>>                                    wait_for_completion() <- the refcount is
>> got in dev_ethtool, it causes ABBA deadlock
> But all these races are nsim specific ones.
> Can you please explain why devlink.[c|h] MUST be changed and nsim can't
> be fixed?
I used the fix code proposed by Jakub, but it didn't work correctly, so
I tried to correct and improve it, and need some devlink helper.

Anyway, it is a nsim problem, if we want fix this without touch devlink,
I think we can add a 'registered' field in struct nsim_dev, and it can be
checked in nsim_get_devlink_port() like this:
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -242,6 +242,9 @@ static struct devlink_port 
*nsim_get_devlink_port(struct net_device *dev)
  {
         struct netdevsim *ns = netdev_priv(dev);

+       if (!ns->nsim_dev->devlink_registered)
+               return NULL;
+
         return &ns->nsim_dev_port->devlink_port;
  }

Thanks,
Yang
>
> Thanks
> .
