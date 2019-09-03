Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68799A60C9
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 07:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfICFnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 01:43:02 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:57272 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725878AbfICFnC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 01:43:02 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A19E1EBA214DD7CEB273;
        Tue,  3 Sep 2019 13:42:59 +0800 (CST)
Received: from [127.0.0.1] (10.133.205.80) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Tue, 3 Sep 2019
 13:42:48 +0800
Subject: Re: [PATCH v3] tun: fix use-after-free when register netdev failed
To:     Jason Wang <jasowang@redhat.com>
References: <1566221479-16094-1-git-send-email-yangyingliang@huawei.com>
 <20190819.182522.414877916903078544.davem@davemloft.net>
 <ceeafaf2-6aa4-b815-0b5f-ecc663216f43@redhat.com>
 <d8eaedf9-321c-1c07-cbd1-de5e1f73b086@redhat.com>
 <5D5E3133.2070108@huawei.com> <5D5E90C3.50306@huawei.com>
 <1676209666.10068041.1566529505528.JavaMail.zimbra@redhat.com>
 <5D5FB3B6.5080800@huawei.com>
 <1be732b2-6eda-4ea6-772d-780694557910@redhat.com>
 <5D6DC5BF.5020009@huawei.com>
 <4a5d84b7-f3cb-c4e1-d6fe-28d186a551ee@redhat.com>
CC:     David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        eric dumazet <eric.dumazet@gmail.com>,
        xiyou wangcong <xiyou.wangcong@gmail.com>,
        <weiyongjun1@huawei.com>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <5D6DFD57.7020905@huawei.com>
Date:   Tue, 3 Sep 2019 13:42:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <4a5d84b7-f3cb-c4e1-d6fe-28d186a551ee@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.133.205.80]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/9/3 11:03, Jason Wang wrote:
>
> On 2019/9/3 上午9:45, Yang Yingliang wrote:
>>
>>
>> On 2019/9/2 13:32, Jason Wang wrote:
>>>
>>> On 2019/8/23 下午5:36, Yang Yingliang wrote:
>>>>
>>>>
>>>> On 2019/8/23 11:05, Jason Wang wrote:
>>>>> ----- Original Message -----
>>>>>>
>>>>>> On 2019/8/22 14:07, Yang Yingliang wrote:
>>>>>>>
>>>>>>> On 2019/8/22 10:13, Jason Wang wrote:
>>>>>>>> On 2019/8/20 上午10:28, Jason Wang wrote:
>>>>>>>>> On 2019/8/20 上午9:25, David Miller wrote:
>>>>>>>>>> From: Yang Yingliang <yangyingliang@huawei.com>
>>>>>>>>>> Date: Mon, 19 Aug 2019 21:31:19 +0800
>>>>>>>>>>
>>>>>>>>>>> Call tun_attach() after register_netdevice() to make sure 
>>>>>>>>>>> tfile->tun
>>>>>>>>>>> is not published until the netdevice is registered. So the 
>>>>>>>>>>> read/write
>>>>>>>>>>> thread can not use the tun pointer that may freed by 
>>>>>>>>>>> free_netdev().
>>>>>>>>>>> (The tun and dev pointer are allocated by 
>>>>>>>>>>> alloc_netdev_mqs(), they
>>>>>>>>>>> can
>>>>>>>>>>> be freed by netdev_freemem().)
>>>>>>>>>> register_netdevice() must always be the last operation in the 
>>>>>>>>>> order of
>>>>>>>>>> network device setup.
>>>>>>>>>>
>>>>>>>>>> At the point register_netdevice() is called, the device is 
>>>>>>>>>> visible
>>>>>>>>>> globally
>>>>>>>>>> and therefore all of it's software state must be fully 
>>>>>>>>>> initialized and
>>>>>>>>>> ready for us.
>>>>>>>>>>
>>>>>>>>>> You're going to have to find another solution to these problems.
>>>>>>>>>
>>>>>>>>> The device is loosely coupled with sockets/queues. Each side is
>>>>>>>>> allowed to be go away without caring the other side. So in this
>>>>>>>>> case, there's a small window that network stack think the 
>>>>>>>>> device has
>>>>>>>>> one queue but actually not, the code can then safely drop them.
>>>>>>>>> Maybe it's ok here with some comments?
>>>>>>>>>
>>>>>>>>> Or if not, we can try to hold the device before tun_attach and 
>>>>>>>>> drop
>>>>>>>>> it after register_netdevice().
>>>>>>>>
>>>>>>>> Hi Yang:
>>>>>>>>
>>>>>>>> I think maybe we can try to hold refcnt instead of playing real 
>>>>>>>> num
>>>>>>>> queues here. Do you want to post a V4?
>>>>>>> I think the refcnt can prevent freeing the memory in this case.
>>>>>>> When register_netdevice() failed, free_netdev() will be called 
>>>>>>> directly,
>>>>>>> dev->pcpu_refcnt and dev are freed without checking refcnt of dev.
>>>>>> How about using patch-v1 that using a flag to check whether the 
>>>>>> device
>>>>>> registered successfully.
>>>>>>
>>>>> As I said, it lacks sufficient locks or barriers. To be clear, I 
>>>>> meant
>>>>> something like (compile-test only):
>>>>>
>>>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>>>>> index db16d7a13e00..e52678f9f049 100644
>>>>> --- a/drivers/net/tun.c
>>>>> +++ b/drivers/net/tun.c
>>>>> @@ -2828,6 +2828,7 @@ static int tun_set_iff(struct net *net, 
>>>>> struct file *file, struct ifreq *ifr)
>>>>>                                (ifr->ifr_flags & TUN_FEATURES);
>>>>>                    INIT_LIST_HEAD(&tun->disabled);
>>>>> +               dev_hold(dev);
>>>>>                  err = tun_attach(tun, file, false, ifr->ifr_flags 
>>>>> & IFF_NAPI,
>>>>>                                   ifr->ifr_flags & IFF_NAPI_FRAGS);
>>>>>                  if (err < 0)
>>>>> @@ -2836,6 +2837,7 @@ static int tun_set_iff(struct net *net, 
>>>>> struct file *file, struct ifreq *ifr)
>>>>>                  err = register_netdevice(tun->dev);
>>>>>                  if (err < 0)
>>>>>                          goto err_detach;
>>>>> +               dev_put(dev);
>>>>>          }
>>>>>            netif_carrier_on(tun->dev);
>>>>> @@ -2852,11 +2854,13 @@ static int tun_set_iff(struct net *net, 
>>>>> struct file *file, struct ifreq *ifr)
>>>>>          return 0;
>>>>>     err_detach:
>>>>> +       dev_put(dev);
>>>>>          tun_detach_all(dev);
>>>>>          /* register_netdevice() already called tun_free_netdev() */
>>>>>          goto err_free_dev;
>>>>>     err_free_flow:
>>>>> +       dev_put(dev);
>>>>>          tun_flow_uninit(tun);
>>>>>          security_tun_dev_free_security(tun->security);
>>>>>   err_free_stat:
>>>>>
>>>>> What's your thought?
>>>>
>>>> The dev pointer are freed without checking the refcount in 
>>>> free_netdev() called by err_free_dev
>>>>
>>>> path, so I don't understand how the refcount protects this pointer.
>>>>
>>>
>>> The refcount are guaranteed to be zero there, isn't it?
>> No, it's not.
>>
>> err_free_dev:
>>         free_netdev(dev);
>>
>> void free_netdev(struct net_device *dev)
>> {
>> ...
>>         /* pcpu_refcnt can be freed without checking refcount */
>>         free_percpu(dev->pcpu_refcnt);
>>         dev->pcpu_refcnt = NULL;
>>
>>         /*  Compatibility with error handling in drivers */
>>         if (dev->reg_state == NETREG_UNINITIALIZED) {
>>                 /* dev can be freed without checking refcount */
>>                 netdev_freemem(dev);
>>                 return;
>>         }
>> ...
>> }
>
>
> Right, but what I meant is in my patch, when code reaches 
> free_netdev() the refcnt is zero. What did I miss?
Yes, but it can't fix the UAF problem.
>
> Thanks
>
>
>>
>>>
>>> Thanks
>>>
>>>
>>>> Thanks,
>>>> Yang
>>>>
>>>>>
>>>>> Thanks
>>>>>
>>>>> .
>>>>>
>>>>
>>>>
>>>
>>> .
>>>
>>
>>
>
> .
>


