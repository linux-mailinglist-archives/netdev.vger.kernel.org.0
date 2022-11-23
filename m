Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB929634D71
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 02:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234320AbiKWBuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 20:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233459AbiKWBuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 20:50:22 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54815E9EF
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 17:50:20 -0800 (PST)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NH3w66DgTzHw2y;
        Wed, 23 Nov 2022 09:49:42 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 09:50:19 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 09:50:18 +0800
Subject: Re: [PATCH net] net: devlink: fix UAF in
 devlink_compat_running_version()
To:     Jakub Kicinski <kuba@kernel.org>, Leon Romanovsky <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <jiri@nvidia.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>
References: <20221122121048.776643-1-yangyingliang@huawei.com>
 <Y3zdaX1I0Y8rdSLn@unreal> <e311b567-8130-15de-8dbb-06878339c523@huawei.com>
 <Y30dPRzO045Od2FA@unreal> <20221122122740.4b10d67d@kernel.org>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <0e0d0f3f-0cf6-c941-9e7e-0c19b6b1097d@huawei.com>
Date:   Wed, 23 Nov 2022 09:50:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20221122122740.4b10d67d@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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


On 2022/11/23 4:27, Jakub Kicinski wrote:
> On Tue, 22 Nov 2022 21:04:29 +0200 Leon Romanovsky wrote:
>>>> Please fix nsim instead of devlink.
>>> I think if devlink is not registered, it can not be get and used, but there
>>> is no API for driver to check this, can I introduce a new helper name
>>> devlink_is_registered() for driver using.
>> There is no need in such API as driver calls to devlink_register() and
>> as such it knows when devlink is registered.
>>
>> This UAF is nsim specific issue. Real devices have single .probe()
>> routine with serialized registration flow. None of them will use
>> devlink_is_registered() call.
> Agreed, the fix is to move the register call back.
> Something along the lines of the untested patch below?
> Yang Yingliang would you be able to turn that into a real patch?
OK.

Thanks,
Yang
>
> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> index e14686594a71..26602d5fe0a2 100644
> --- a/drivers/net/netdevsim/dev.c
> +++ b/drivers/net/netdevsim/dev.c
> @@ -1566,12 +1566,15 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
>   	err = devlink_params_register(devlink, nsim_devlink_params,
>   				      ARRAY_SIZE(nsim_devlink_params));
>   	if (err)
> -		goto err_dl_unregister;
> +		goto err_resource_unregister;
>   	nsim_devlink_set_params_init_values(nsim_dev, devlink);
>   
> +	/* here, because params API still expect devlink to be unregistered */
> +	devl_register(devlink);
> +
>   	err = nsim_dev_dummy_region_init(nsim_dev, devlink);
>   	if (err)
> -		goto err_params_unregister;
> +		goto err_dl_unregister;
>   
>   	err = nsim_dev_traps_init(devlink);
>   	if (err)
> @@ -1610,7 +1613,6 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
>   	nsim_dev->esw_mode = DEVLINK_ESWITCH_MODE_LEGACY;
>   	devlink_set_features(devlink, DEVLINK_F_RELOAD);
>   	devl_unlock(devlink);
> -	devlink_register(devlink);
>   	return 0;
>   
>   err_hwstats_exit:
> @@ -1629,10 +1631,11 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
>   	nsim_dev_traps_exit(devlink);
>   err_dummy_region_exit:
>   	nsim_dev_dummy_region_exit(nsim_dev);
> -err_params_unregister:
> +err_dl_unregister:
> +	devl_unregister(devlink);
>   	devlink_params_unregister(devlink, nsim_devlink_params,
>   				  ARRAY_SIZE(nsim_devlink_params));
> -err_dl_unregister:
> +err_resource_unregister:
>   	devl_resources_unregister(devlink);
>   err_vfc_free:
>   	kfree(nsim_dev->vfconfigs);
> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index 074a79b8933f..e0f13100fc6b 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -1593,6 +1593,14 @@ void devlink_set_features(struct devlink *devlink, u64 features);
>   void devlink_register(struct devlink *devlink);
>   void devlink_unregister(struct devlink *devlink);
>   void devlink_free(struct devlink *devlink);
> +
> +void devl_register(struct devlink *devlink)
> +{
> +	devl_assert_locked(devlink);
> +	/* doesn't actually take the instance lock */
> +	devlink_register(devlink);
> +}
> +
>   void devlink_port_init(struct devlink *devlink,
>   		       struct devlink_port *devlink_port);
>   void devlink_port_fini(struct devlink_port *devlink_port);
> .
