Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6492C82F4
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 12:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbgK3LOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 06:14:05 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8531 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgK3LOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 06:14:05 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Cl2dk5BxVzhY7b;
        Mon, 30 Nov 2020 19:12:58 +0800 (CST)
Received: from [10.174.178.174] (10.174.178.174) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Mon, 30 Nov 2020 19:13:20 +0800
Subject: Re: [PATCH net] net: fix memory leak in register_netdevice() on error
 path
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <rkovhaev@gmail.com>,
        Netdev <netdev@vger.kernel.org>
References: <20201126132312.3593725-1-yangyingliang@huawei.com>
 <3548dfef-da8f-0247-0af5-e612b540e397@gmail.com>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <00b0ef28-ebb4-c036-0082-093549251b16@huawei.com>
Date:   Mon, 30 Nov 2020 19:13:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <3548dfef-da8f-0247-0af5-e612b540e397@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/11/29 21:56, Toshiaki Makita wrote:
> On 2020/11/26 22:23, Yang Yingliang wrote:
> ...
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>> ---
>>   net/core/dev.c | 11 +++++++++++
>>   1 file changed, 11 insertions(+)
>>
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index 82dc6b48e45f..907204395b64 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -10000,6 +10000,17 @@ int register_netdevice(struct net_device *dev)
>>       ret = notifier_to_errno(ret);
>>       if (ret) {
>>           rollback_registered(dev);
>> +        /*
>> +         * In common case, priv_destructor() will be
>
> As per netdev-faq, the comment style should be
>
> /* foobar blah blah blah
>  * another line of text
>  */
>
> rather than
>
> /*
>  * foobar blah blah blah
>  * another line of text
>  */
>
>> +         * called in netdev_run_todo() after calling
>> +         * ndo_uninit() in rollback_registered().
>> +         * But in this case, priv_destructor() will
>> +         * never be called, then it causes memory
>> +         * leak, so we should call priv_destructor()
>> +         * here.
>> +         */
>> +        if (dev->priv_destructor)
>> +            dev->priv_destructor(dev);
>
> To be in line with netdev_run_todo(), I think priv_destructor() should be
> called after "dev->reg_state = NETREG_UNREGISTERED".
OK,  I will send a v2 later.
>
> Toshiaki Makita
>
>>           rcu_barrier();
>>             dev->reg_state = NETREG_UNREGISTERED;
>>
