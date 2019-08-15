Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF35C8EC36
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 15:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732022AbfHONBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 09:01:33 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4696 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729818AbfHONBd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 09:01:33 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id EF89EA3DA5A77EBA16A2;
        Thu, 15 Aug 2019 21:01:21 +0800 (CST)
Received: from [127.0.0.1] (10.133.205.80) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Thu, 15 Aug 2019
 21:01:11 +0800
Subject: Re: [PATCH] tun: fix use-after-free when register netdev failed
To:     Eric Dumazet <eric.dumazet@gmail.com>, <netdev@vger.kernel.org>
References: <1565857122-24660-1-git-send-email-yangyingliang@huawei.com>
 <a6f519cf-95ed-02de-d432-363610e4c332@gmail.com>
CC:     <jasowang@redhat.com>, <xiyou.wangcong@gmail.com>,
        <davem@davemloft.net>, Yangyingliang <yangyingliang@huawei.com>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <5D555796.9020104@huawei.com>
Date:   Thu, 15 Aug 2019 21:01:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <a6f519cf-95ed-02de-d432-363610e4c332@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.205.80]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/8/15 17:35, Eric Dumazet wrote:
>
> On 8/15/19 10:18 AM, Yang Yingliang wrote:
>> I got a UAF repport in tun driver when doing fuzzy test:
>>
>>
>> [  466.368604] page:ffffea000dc84e00 refcount:1 mapcount:0 mapping:ffff8883df1b4f00 index:0x0 compound_mapcount: 0
>> [  466.371582] flags: 0x2fffff80010200(slab|head)
>> [  466.372910] raw: 002fffff80010200 dead000000000100 dead000000000122 ffff8883df1b4f00
>> [  466.375209] raw: 0000000000000000 0000000000070007 00000001ffffffff 0000000000000000
>> [  466.377778] page dumped because: kasan: bad access detected
>> [  466.379730]
>> [  466.380288] Memory state around the buggy address:
>> [  466.381844]  ffff888372139100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>> [  466.384009]  ffff888372139180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>> [  466.386131] >ffff888372139200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>> [  466.388257]                                                  ^
>> [  466.390234]  ffff888372139280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>> [  466.392512]  ffff888372139300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>> [  466.394667] ==================================================================
>>
>> tun_chr_read_iter() accessed the memory which freed by free_netdev()
>> called by tun_set_iff():
>>
>> 	CPUA				CPUB
>>      tun_set_iff()
>>        alloc_netdev_mqs()
>>        tun_attach()
>> 				    tun_chr_read_iter()
>> 				      tun_get()
>>        register_netdevice()
>>        tun_detach_all()
>>          synchronize_net()
>> 				      tun_do_read()
>> 				        tun_ring_recv()
>> 				          schedule()
>>        free_netdev()
>> 				      tun_put() <-- UAF
> UAF on what exactly ? The dev_hold() should prevent the free_netdev().

register_netdevice() is failed, so the dev is freed directly in free_netdev
().

>
>> Set a new bit in tun->flag if register_netdevice() successed,
>> without this bit, tun_get() returns NULL to avoid using a
>> freed tun pointer.
>>
>> Fixes: eb0fb363f920 ("tuntap: attach queue 0 before registering netdevice")
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>> ---
>>   drivers/net/tun.c | 10 ++++++++--
>>   1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>> index db16d7a13e00..cbd60c276c40 100644
>> --- a/drivers/net/tun.c
>> +++ b/drivers/net/tun.c
>> @@ -115,6 +115,7 @@ do {								\
>>   /* High bits in flags field are unused. */
>>   #define TUN_VNET_LE     0x80000000
>>   #define TUN_VNET_BE     0x40000000
>> +#define TUN_DEV_REGISTERED	0x20000000
>>   
>>   #define TUN_FEATURES (IFF_NO_PI | IFF_ONE_QUEUE | IFF_VNET_HDR | \
>>   		      IFF_MULTI_QUEUE | IFF_NAPI | IFF_NAPI_FRAGS)
>> @@ -719,8 +720,10 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
>>   			netif_carrier_off(tun->dev);
>>   
>>   			if (!(tun->flags & IFF_PERSIST) &&
>> -			    tun->dev->reg_state == NETREG_REGISTERED)
>> +			    tun->dev->reg_state == NETREG_REGISTERED) {
>>   				unregister_netdevice(tun->dev);
>> +				tun->flags &= ~TUN_DEV_REGISTERED;
> Isn't this done too late ?
>
>> +			}
>>   		}
>>   		if (tun)
>>   			xdp_rxq_info_unreg(&tfile->xdp_rxq);
>> @@ -884,8 +887,10 @@ static struct tun_struct *tun_get(struct tun_file *tfile)
>>   
>>   	rcu_read_lock();
>>   	tun = rcu_dereference(tfile->tun);
>> -	if (tun)
>> +	if (tun && (tun->flags & TUN_DEV_REGISTERED))
>>   		dev_hold(tun->dev);
>> +	else
>> +		tun = NULL;
>>   	rcu_read_unlock();
>>   
>>   	return tun;
>> @@ -2836,6 +2841,7 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
>>   		err = register_netdevice(tun->dev);
>>   		if (err < 0)
>>   			goto err_detach;
>> +		tun->flags |= TUN_DEV_REGISTERED;
>>   	}
>>   
>>   	netif_carrier_on(tun->dev);
>>
>
> So tun_get() will return NULL as long as  tun_set_iff() (TUNSETIFF ioctl()) has not yet been called ?
>
> This could break some applications, since tun_get() is used from poll() and other syscalls.
I will try Wang's sugguestion later, if it's OK, I will drop this patch.
>
> .
>


