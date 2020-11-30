Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F9B2C82ED
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 12:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbgK3LMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 06:12:55 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8164 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgK3LMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 06:12:54 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Cl2cL3yJvz15T8j;
        Mon, 30 Nov 2020 19:11:46 +0800 (CST)
Received: from [10.174.178.174] (10.174.178.174) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Mon, 30 Nov 2020 19:12:09 +0800
Subject: Re: [PATCH net] net: fix memory leak in register_netdevice() on error
 path
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <toshiaki.makita1@gmail.com>, <rkovhaev@gmail.com>
References: <20201126132312.3593725-1-yangyingliang@huawei.com>
 <20201129203933.623451fe@hermes.local>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <dee475f2-08be-3061-95e6-ee0400a1f66a@huawei.com>
Date:   Mon, 30 Nov 2020 19:12:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20201129203933.623451fe@hermes.local>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/11/30 12:39, Stephen Hemminger wrote:
> On Thu, 26 Nov 2020 21:23:12 +0800
> Yang Yingliang <yangyingliang@huawei.com> wrote:
>
>> I got a memleak report when doing fault-inject test:
>>
>> unreferenced object 0xffff88810ace9000 (size 1024):
>>    comm "ip", pid 4622, jiffies 4295457037 (age 43.378s)
>>    hex dump (first 32 bytes):
>>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>    backtrace:
>>      [<00000000008abe41>] __kmalloc+0x10f/0x210
>>      [<000000005d3533a6>] veth_dev_init+0x140/0x310
>>      [<0000000088353c64>] register_netdevice+0x496/0x7a0
>>      [<000000001324d322>] veth_newlink+0x40b/0x960
>>      [<00000000d0799866>] __rtnl_newlink+0xd8c/0x1360
>>      [<00000000d616040a>] rtnl_newlink+0x6b/0xa0
>>      [<00000000e0a1600d>] rtnetlink_rcv_msg+0x3cc/0x9e0
>>      [<000000009eeff98b>] netlink_rcv_skb+0x130/0x3a0
>>      [<00000000500f8be1>] netlink_unicast+0x4da/0x700
>>      [<00000000666c03b3>] netlink_sendmsg+0x7fe/0xcb0
>>      [<0000000073b28103>] sock_sendmsg+0x143/0x180
>>      [<00000000ad746a30>] ____sys_sendmsg+0x677/0x810
>>      [<0000000087dd98e5>] ___sys_sendmsg+0x105/0x180
>>      [<00000000028dd365>] __sys_sendmsg+0xf0/0x1c0
>>      [<00000000a6bfbae6>] do_syscall_64+0x33/0x40
>>      [<00000000e00521b4>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> It seems ifb and loopback may also hit the leak, so I try to fix this in
>> register_netdevice().
>>
>> In common case, priv_destructor() will be called in netdev_run_todo()
>> after calling ndo_uninit() in rollback_registered(), on other error
>> path in register_netdevice(), ndo_uninit() and priv_destructor() are
>> called before register_netdevice() return, but in this case,
>> priv_destructor() will never be called, then it causes memory leak,
>> so we should call priv_destructor() here.
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>> ---
>>   net/core/dev.c | 11 +++++++++++
>>   1 file changed, 11 insertions(+)
>>
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index 82dc6b48e45f..907204395b64 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -10000,6 +10000,17 @@ int register_netdevice(struct net_device *dev)
>>   	ret = notifier_to_errno(ret);
>>   	if (ret) {
>>   		rollback_registered(dev);
>> +		/*
>> +		 * In common case, priv_destructor() will be
>> +		 * called in netdev_run_todo() after calling
>> +		 * ndo_uninit() in rollback_registered().
>> +		 * But in this case, priv_destructor() will
>> +		 * never be called, then it causes memory
>> +		 * leak, so we should call priv_destructor()
>> +		 * here.
>> +		 */
>> +		if (dev->priv_destructor)
>> +			dev->priv_destructor(dev);
> Are you sure this is safe?
> Several devices have destructors that call free_netdev.
> Up until now a common pattern for those devices was to call
> free_netdev on error. After this change it would lead to double free.

After commit cf124db566e6 ("net: Fix inconsistent teardown and release 
of private netdev state."),

free_netdev() is not be called in priv_destructor().

>
> .
