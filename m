Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 462873D1EA3
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 09:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbhGVG0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 02:26:35 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:12236 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbhGVG0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 02:26:33 -0400
Received: from dggeml757-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GVjzL3QrGz1CMCH;
        Thu, 22 Jul 2021 15:01:18 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 dggeml757-chm.china.huawei.com (10.1.199.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 22 Jul 2021 15:06:40 +0800
Subject: Re: [PATCH net] can: raw: fix raw_rcv panic for sock UAF
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <mkl@pengutronix.de>,
        <netdev@vger.kernel.org>, <linux-can@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20210721010937.670275-1-william.xuanziyang@huawei.com>
 <YPeoQG19PSh3B3Dc@kroah.com>
 <44c3e0e2-03c5-80e5-001c-03e7e9758bca@hartkopp.net>
 <11822417-5931-b2d8-ae77-ec4a84b8b895@hartkopp.net>
 <d5eb8e8d-bce9-cccd-a102-b60692c242f0@huawei.com>
 <fc68ffdf-50f0-9cc7-6943-4b16b1447a9b@hartkopp.net>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <ea64e0db-0507-16bf-b040-900f17c65dd8@huawei.com>
Date:   Thu, 22 Jul 2021 15:06:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <fc68ffdf-50f0-9cc7-6943-4b16b1447a9b@hartkopp.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggeml757-chm.china.huawei.com (10.1.199.137)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/21/2021 11:13 PM, Oliver Hartkopp wrote:
> 
> 
> On 21.07.21 13:37, Ziyang Xuan (William) wrote:
>> On 7/21/2021 5:24 PM, Oliver Hartkopp wrote:
> 
>>>
>>> Can you please resend the below patch as suggested by Greg KH and add my
>>>
>>> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
>>>
>>> as it also adds the dev_get_by_index() return check.
>>>
>>> diff --git a/net/can/raw.c b/net/can/raw.c
>>> index ed4fcb7ab0c3..d3cbc32036c7 100644
>>> --- a/net/can/raw.c
>>> +++ b/net/can/raw.c
>>> @@ -544,14 +544,18 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
>>>           } else if (count == 1) {
>>>               if (copy_from_sockptr(&sfilter, optval, sizeof(sfilter)))
>>>                   return -EFAULT;
>>>           }
>>>
>>> +        rtnl_lock();
>>>           lock_sock(sk);
>>>
>>> -        if (ro->bound && ro->ifindex)
>>> +        if (ro->bound && ro->ifindex) {
>>>               dev = dev_get_by_index(sock_net(sk), ro->ifindex);
>>> +            if (!dev)
>>> +                goto out_fil;
>>> +        }
>> At first, I also use this modification. After discussion with my partner, we found that
>> it is impossible scenario if we use rtnl_lock to protect net_device object.
>> We can see two sequences:
>> 1. raw_setsockopt first get rtnl_lock, unregister_netdevice_many later.
>> It can be simplified to add the filter in raw_setsockopt, then remove the filter in raw_notify.
>>
>> 2. unregister_netdevice_many first get rtnl_lock, raw_setsockopt later.
>> raw_notify will set ro->ifindex, ro->bound and ro->count to zero firstly. The filter will not
>> be added to any filter_list in raw_notify.
>>
>> So I selected the current modification. Do you think so?
>>
>> My first modification as following:
>>
>> diff --git a/net/can/raw.c b/net/can/raw.c
>> index ed4fcb7ab0c3..a0ce4908317f 100644
>> --- a/net/can/raw.c
>> +++ b/net/can/raw.c
>> @@ -546,10 +546,16 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
>>                                  return -EFAULT;
>>                  }
>>
>> +               rtnl_lock();
>>                  lock_sock(sk);
>>
>> -               if (ro->bound && ro->ifindex)
>> +               if (ro->bound && ro->ifindex) {
>>                          dev = dev_get_by_index(sock_net(sk), ro->ifindex);
>> +                       if (!dev) {
>> +                               err = -ENODEV;
>> +                               goto out_fil;
>> +                       }
>> +               }
>>
>>                  if (ro->bound) {
>>                          /* (try to) register the new filters */
>> @@ -559,11 +565,8 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
>>                          else
>>                                  err = raw_enable_filters(sock_net(sk), dev, sk,
>>                                                           filter, count);
>> -                       if (err) {
>> -                               if (count > 1)
>> -                                       kfree(filter);
>> +                       if (err)
>>                                  goto out_fil;
>> -                       }
>>
>>                          /* remove old filter registrations */
>>                          raw_disable_filters(sock_net(sk), dev, sk, ro->filter,
>> @@ -584,10 +587,14 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
>>                  ro->count  = count;
>>
>>    out_fil:
>> +               if (err && count > 1)
>> +                       kfree(filter);
>> +
> 
> Setting the err variable to -ENODEV is a good idea but I do not like the movement of kfree(filter).
> 
> The kfree() has a tight relation inside the if-statement for ro->bound which makes it easier to understand.
> 
> Regards,
> Oliver

I will submit the v2 patch for the problem according to your suggestions. Than you.
