Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E942CA4EDA
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 07:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729501AbfIBFct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 01:32:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53102 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbfIBFcs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 01:32:48 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CF58A307D847;
        Mon,  2 Sep 2019 05:32:47 +0000 (UTC)
Received: from [10.72.12.94] (ovpn-12-94.pek2.redhat.com [10.72.12.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5534510016EB;
        Mon,  2 Sep 2019 05:32:44 +0000 (UTC)
Subject: Re: [PATCH v3] tun: fix use-after-free when register netdev failed
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        eric dumazet <eric.dumazet@gmail.com>,
        xiyou wangcong <xiyou.wangcong@gmail.com>,
        weiyongjun1@huawei.com
References: <1566221479-16094-1-git-send-email-yangyingliang@huawei.com>
 <20190819.182522.414877916903078544.davem@davemloft.net>
 <ceeafaf2-6aa4-b815-0b5f-ecc663216f43@redhat.com>
 <d8eaedf9-321c-1c07-cbd1-de5e1f73b086@redhat.com>
 <5D5E3133.2070108@huawei.com> <5D5E90C3.50306@huawei.com>
 <1676209666.10068041.1566529505528.JavaMail.zimbra@redhat.com>
 <5D5FB3B6.5080800@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <1be732b2-6eda-4ea6-772d-780694557910@redhat.com>
Date:   Mon, 2 Sep 2019 13:32:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <5D5FB3B6.5080800@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Mon, 02 Sep 2019 05:32:48 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/8/23 下午5:36, Yang Yingliang wrote:
>
>
> On 2019/8/23 11:05, Jason Wang wrote:
>> ----- Original Message -----
>>>
>>> On 2019/8/22 14:07, Yang Yingliang wrote:
>>>>
>>>> On 2019/8/22 10:13, Jason Wang wrote:
>>>>> On 2019/8/20 上午10:28, Jason Wang wrote:
>>>>>> On 2019/8/20 上午9:25, David Miller wrote:
>>>>>>> From: Yang Yingliang <yangyingliang@huawei.com>
>>>>>>> Date: Mon, 19 Aug 2019 21:31:19 +0800
>>>>>>>
>>>>>>>> Call tun_attach() after register_netdevice() to make sure 
>>>>>>>> tfile->tun
>>>>>>>> is not published until the netdevice is registered. So the 
>>>>>>>> read/write
>>>>>>>> thread can not use the tun pointer that may freed by 
>>>>>>>> free_netdev().
>>>>>>>> (The tun and dev pointer are allocated by alloc_netdev_mqs(), they
>>>>>>>> can
>>>>>>>> be freed by netdev_freemem().)
>>>>>>> register_netdevice() must always be the last operation in the 
>>>>>>> order of
>>>>>>> network device setup.
>>>>>>>
>>>>>>> At the point register_netdevice() is called, the device is visible
>>>>>>> globally
>>>>>>> and therefore all of it's software state must be fully 
>>>>>>> initialized and
>>>>>>> ready for us.
>>>>>>>
>>>>>>> You're going to have to find another solution to these problems.
>>>>>>
>>>>>> The device is loosely coupled with sockets/queues. Each side is
>>>>>> allowed to be go away without caring the other side. So in this
>>>>>> case, there's a small window that network stack think the device has
>>>>>> one queue but actually not, the code can then safely drop them.
>>>>>> Maybe it's ok here with some comments?
>>>>>>
>>>>>> Or if not, we can try to hold the device before tun_attach and drop
>>>>>> it after register_netdevice().
>>>>>
>>>>> Hi Yang:
>>>>>
>>>>> I think maybe we can try to hold refcnt instead of playing real num
>>>>> queues here. Do you want to post a V4?
>>>> I think the refcnt can prevent freeing the memory in this case.
>>>> When register_netdevice() failed, free_netdev() will be called 
>>>> directly,
>>>> dev->pcpu_refcnt and dev are freed without checking refcnt of dev.
>>> How about using patch-v1 that using a flag to check whether the device
>>> registered successfully.
>>>
>> As I said, it lacks sufficient locks or barriers. To be clear, I meant
>> something like (compile-test only):
>>
>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>> index db16d7a13e00..e52678f9f049 100644
>> --- a/drivers/net/tun.c
>> +++ b/drivers/net/tun.c
>> @@ -2828,6 +2828,7 @@ static int tun_set_iff(struct net *net, struct 
>> file *file, struct ifreq *ifr)
>>                                (ifr->ifr_flags & TUN_FEATURES);
>>                    INIT_LIST_HEAD(&tun->disabled);
>> +               dev_hold(dev);
>>                  err = tun_attach(tun, file, false, ifr->ifr_flags & 
>> IFF_NAPI,
>>                                   ifr->ifr_flags & IFF_NAPI_FRAGS);
>>                  if (err < 0)
>> @@ -2836,6 +2837,7 @@ static int tun_set_iff(struct net *net, struct 
>> file *file, struct ifreq *ifr)
>>                  err = register_netdevice(tun->dev);
>>                  if (err < 0)
>>                          goto err_detach;
>> +               dev_put(dev);
>>          }
>>            netif_carrier_on(tun->dev);
>> @@ -2852,11 +2854,13 @@ static int tun_set_iff(struct net *net, 
>> struct file *file, struct ifreq *ifr)
>>          return 0;
>>     err_detach:
>> +       dev_put(dev);
>>          tun_detach_all(dev);
>>          /* register_netdevice() already called tun_free_netdev() */
>>          goto err_free_dev;
>>     err_free_flow:
>> +       dev_put(dev);
>>          tun_flow_uninit(tun);
>>          security_tun_dev_free_security(tun->security);
>>   err_free_stat:
>>
>> What's your thought?
>
> The dev pointer are freed without checking the refcount in 
> free_netdev() called by err_free_dev
>
> path, so I don't understand how the refcount protects this pointer.
>

The refcount are guaranteed to be zero there, isn't it?

Thanks


> Thanks,
> Yang
>
>>
>> Thanks
>>
>> .
>>
>
>
