Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCA53361872
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 05:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238359AbhDPD4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 23:56:40 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3087 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234659AbhDPD4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 23:56:39 -0400
Received: from dggeml405-hub.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FM2NH4H6YzWWTJ;
        Fri, 16 Apr 2021 11:52:31 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggeml405-hub.china.huawei.com (10.3.17.49) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Fri, 16 Apr 2021 11:56:12 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Fri, 16 Apr
 2021 11:56:12 +0800
Subject: Re: [PATCH] net: fix a data race when get vlan device
To:     "zhudi (J)" <zhudi21@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Chenxiang (EulerOS)" <rose.chen@huawei.com>
References: <b03d1c13bc0147ad87e06b3dfe602213@huawei.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <160faa16-322b-cd65-9c12-a3cfe0f02e11@huawei.com>
Date:   Fri, 16 Apr 2021 11:56:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <b03d1c13bc0147ad87e06b3dfe602213@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme720-chm.china.huawei.com (10.1.199.116) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/4/16 11:27, zhudi (J) wrote:
>> dependencyOn 2021/4/15 11:35, zhudi wrote:
>>> From: Di Zhu <zhudi21@huawei.com>
>>>
>>> We encountered a crash: in the packet receiving process, we got an
>>> illegal VLAN device address, but the VLAN device address saved in
>>> vmcore is correct. After checking the code, we found a possible data
>>> competition:
>>> CPU 0:                             CPU 1:
>>>     (RCU read lock)                  (RTNL lock)
>>>     vlan_do_receive()		       register_vlan_dev()
>>>       vlan_find_dev()
>>>
>>>         ->__vlan_group_get_device()	 ->vlan_group_prealloc_vid()
>>>
>>> In vlan_group_prealloc_vid(), We need to make sure that kzalloc is
>>> executed before assigning a value to vlan devices array, otherwise we
>>
>> As my understanding, there is a dependency between calling kzalloc() and
>> assigning the address(returned from kzalloc()) to vg->vlan_devices_arrays,
>> CPU and compiler can see the dependency, why can't it handling the
>> dependency before adding the smp_wmb()?
>>
>> See CONTROL DEPENDENCIES section in Documentation/memory-
>> barriers.txt:
>>
>> However, stores are not speculated.  This means that ordering -is- provided
>> for load-store control dependencies, as in the following example:
>>
>>         q = READ_ONCE(a);
>>         if (q) {
>>                 WRITE_ONCE(b, 1);
>>         }
>>
> 
>  Maybe I didn't make it clear.  This memory isolation is to ensure the order of
>  memset(object, 0, size) in kzalloc() operations and the subsequent array assignment statements.
> 
> kzalloc()
>     ->memset(object, 0, size)
> 
> smp_wmb()
> 
> vg->vlan_devices_arrays[pidx][vidx] = array;
> 
> Because __vlan_group_get_device() function depends on this order

Thanks for clarify, it would be good to mention this in the
commit log too.

Also, __vlan_group_get_device() is used in the data path, it would
be to avoid the barrier op too. Maybe using rcu to avoid the barrier
if the __vlan_group_get_device() is already protected by rcu_lock.


> 
>>
>>
>>> may get a wrong address from the hardware cache on another cpu.
>>>
>>> So fix it by adding memory barrier instruction to ensure the order of
>>> memory operations.
>>>
>>> Signed-off-by: Di Zhu <zhudi21@huawei.com>
>>> ---
>>>  net/8021q/vlan.c | 2 ++
>>>  net/8021q/vlan.h | 3 +++
>>>  2 files changed, 5 insertions(+)
>>>
>>> diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c index
>>> 8b644113715e..4f541e05cd3f 100644
>>> --- a/net/8021q/vlan.c
>>> +++ b/net/8021q/vlan.c
>>> @@ -71,6 +71,8 @@ static int vlan_group_prealloc_vid(struct vlan_group
>> *vg,
>>>  	if (array == NULL)
>>>  		return -ENOBUFS;
>>>
>>> +	smp_wmb();
>>> +
>>>  	vg->vlan_devices_arrays[pidx][vidx] = array;
>>>  	return 0;
>>>  }
>>> diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h index
>>> 953405362795..7408fda084d3 100644
>>> --- a/net/8021q/vlan.h
>>> +++ b/net/8021q/vlan.h
>>> @@ -57,6 +57,9 @@ static inline struct net_device
>>> *__vlan_group_get_device(struct vlan_group *vg,
>>>
>>>  	array = vg->vlan_devices_arrays[pidx]
>>>  				       [vlan_id /
>> VLAN_GROUP_ARRAY_PART_LEN];
>>> +
>>> +	smp_rmb();
>>> +
>>>  	return array ? array[vlan_id % VLAN_GROUP_ARRAY_PART_LEN] :
>> NULL;  }
>>>
>>>
> 

