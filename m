Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62CBE6372DF
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 08:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbiKXHSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 02:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiKXHSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 02:18:30 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3FE1AE7B
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 23:28:41 -0800 (PST)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NHqN817fLz15Mq9;
        Thu, 24 Nov 2022 15:28:08 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 15:28:40 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 15:28:39 +0800
Subject: Re: [PATCH net] net: devlink: fix UAF in
 devlink_compat_running_version()
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Leon Romanovsky <leon@kernel.org>, <netdev@vger.kernel.org>,
        <jiri@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <pabeni@redhat.com>
References: <20221122121048.776643-1-yangyingliang@huawei.com>
 <Y3zdaX1I0Y8rdSLn@unreal> <e311b567-8130-15de-8dbb-06878339c523@huawei.com>
 <Y30dPRzO045Od2FA@unreal> <20221122122740.4b10d67d@kernel.org>
 <405f703b-b97e-afdd-8d5f-48b8f99d045d@huawei.com>
 <20221123184738.29718806@kernel.org>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <36f320f3-f4e6-7388-6292-83f240bcd28c@huawei.com>
Date:   Thu, 24 Nov 2022 15:28:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20221123184738.29718806@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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


On 2022/11/24 10:47, Jakub Kicinski wrote:
> On Wed, 23 Nov 2022 14:40:24 +0800 Yang Yingliang wrote:
>>> +err_dl_unregister:
>>> +	devl_unregister(devlink);
>> It races with dev_ethtool():
>> dev_ethtool
>>     devlink_try_get()
>>                                   nsim_drv_probe
>>                                   devl_lock()
>>       devl_lock()
>>                                   devlink_unregister()
>>                                     devlink_put()
>>                                     wait_for_completion() <- the refcount
>> is got in dev_ethtool, it causes ABBA deadlock
> Yeah.. so my original design for the locking had a "devlink_is_alive()"
> check for this exact reason:
>
> https://lore.kernel.org/netdev/20211030231254.2477599-3-kuba@kernel.org/
>
> and the devlink structure was properly refcounted (devlink_put() calls
> devlink_free() when the last reference is released).
>
> Pure references then need to check if the instance is still alive
> after locking it. Which is fine, it should only happen in core code.
>
> I think we should go back to that idea.
But Leon disagree to change devlink code.

I think this problem occurs in the drivers that have multiple ports(netdev):

In some drivers (e.g. mlx5) , one net device uses one devlink 
instance(see mlx5e_probe()),
the instance can not be get until the device is register, in this case, 
it won't cause UAF.

But in some other drivers(e.g. netdevsim, funeth) multiple ports(net 
devices) use one
devlink instance. If first one is register successful, the instance is 
visible and can be get
through netdev, meanwhile, the second port register failed and goto free 
the devlink
that used by first port(netdevice). So can we fix this in every single 
driver.

Thanks,
Yang
>
> The waiting for references is a nightmare in the netdev code.
>
> .
