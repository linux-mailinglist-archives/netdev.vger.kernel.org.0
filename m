Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0594233E666
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 02:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbhCQBsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 21:48:08 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3468 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbhCQBrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 21:47:48 -0400
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4F0Y006lB7z5dHZ;
        Wed, 17 Mar 2021 09:45:52 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Wed, 17 Mar 2021 09:47:45 +0800
Received: from [127.0.0.1] (10.69.26.252) by dggpemm500006.china.huawei.com
 (7.185.36.236) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Wed, 17 Mar
 2021 09:47:45 +0800
Subject: Re: [PATCH net-next 5/9] net: hns3: refactor flow director
 configuration
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>,
        <linuxarm@huawei.com>, Jian Shen <shenjian15@huawei.com>
References: <1615811031-55209-1-git-send-email-tanhuazhong@huawei.com>
 <1615811031-55209-6-git-send-email-tanhuazhong@huawei.com>
 <20210315130027.669b8afa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Huazhong Tan <tanhuazhong@huawei.com>
Message-ID: <cbedbd4d-f293-3733-f86e-65f434a09e82@huawei.com>
Date:   Wed, 17 Mar 2021 09:47:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20210315130027.669b8afa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.69.26.252]
X-ClientProxiedBy: dggeme704-chm.china.huawei.com (10.1.199.100) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/3/16 4:00, Jakub Kicinski wrote:
> On Mon, 15 Mar 2021 20:23:47 +0800 Huazhong Tan wrote:
>> From: Jian Shen <shenjian15@huawei.com>
>>
>> Currently, there are 3 flow director work modes in HNS3 driver,
>> include EP(ethtool), tc flower and aRFS. The flow director rules
>> are configured synchronously and need holding spin lock. With this
>> limitation, all the commands with firmware are also needed to use
>> spin lock.
>>
>> To eliminate the limitation, configure flow director rules
>> asynchronously. The rules are still kept in the fd_rule_list
>> with below states.
>> TO_ADD: the rule is waiting to add to hardware
>> TO_DEL: the rule is waiting to remove from hardware
>> ADDING: the rule is adding to hardware
>> ACTIVE: the rule is already added in hardware
>>
>> When receive a new request to add or delete flow director rule,
>> check whether the rule location is existent, update the rule
>> content and state, and request to schedule the service task to
>> finish the configuration.
>>
>> Signed-off-by: Jian Shen <shenjian15@huawei.com>
>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> How is the application supposed to know if the ethtool rule was already
> installed or installation is still pending?


Yes, it's unable for the application to know whether pending or installed.

The primitive motivation is to move out the aRFS rule configuration from
IO path. To keep consistent, so does the ethtool way. We thought
of it before, considered that the time window between the two state is
very small.

How about keep aRFS asynchronously, and the ethtool synchronously?


> With the firmware bloat on all devices this sort of async mechanism
> seems to be popping up in more and more drivers but IMHO we shouldn't
> weaken the semantics without amending the kernel <> user space API.
>
> .

