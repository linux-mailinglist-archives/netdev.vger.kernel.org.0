Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFE43363962
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 04:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbhDSC1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 22:27:34 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3529 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbhDSC1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 22:27:33 -0400
Received: from DGGEML404-HUB.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FNrHl6KNfzRfGc;
        Mon, 19 Apr 2021 10:24:51 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 DGGEML404-HUB.china.huawei.com (10.3.17.39) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Mon, 19 Apr 2021 10:26:59 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Mon, 19 Apr
 2021 10:26:59 +0800
Subject: Re: [PATCH] net: fix a data race when get vlan device
To:     "zhudi (J)" <zhudi21@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Chenxiang (EulerOS)" <rose.chen@huawei.com>
References: <0ba3274f12e24e519bc61f30f0b90444@huawei.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <5e9c7afa-79fc-5e03-78dd-147346478272@huawei.com>
Date:   Mon, 19 Apr 2021 10:26:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <0ba3274f12e24e519bc61f30f0b90444@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme708-chm.china.huawei.com (10.1.199.104) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/4/17 20:33, zhudi (J) wrote:
>> On 2021/4/16 11:27, zhudi (J) wrote:
>>>> dependencyOn 2021/4/15 11:35, zhudi wrote:
>>>>> From: Di Zhu <zhudi21@huawei.com>
>>>>>
>>>>> We encountered a crash: in the packet receiving process, we got an
>>>>> illegal VLAN device address, but the VLAN device address saved in
>>>>> vmcore is correct. After checking the code, we found a possible data
>>>>> competition:
>>>>> CPU 0:                             CPU 1:
>>>>>     (RCU read lock)                  (RTNL lock)
>>>>>     vlan_do_receive()		       register_vlan_dev()
>>>>>       vlan_find_dev()
>>>>>
>>>>>         ->__vlan_group_get_device()	 ->vlan_group_prealloc_vid()
>>>>>
>>>>> In vlan_group_prealloc_vid(), We need to make sure that kzalloc is
>>>>> executed before assigning a value to vlan devices array, otherwise we
>>>>
>>>> As my understanding, there is a dependency between calling kzalloc() and
>>>> assigning the address(returned from kzalloc()) to vg->vlan_devices_arrays,
>>>> CPU and compiler can see the dependency, why can't it handling the
>>>> dependency before adding the smp_wmb()?
>>>>
>>>> See CONTROL DEPENDENCIES section in Documentation/memory-
>>>> barriers.txt:
>>>>
>>>> However, stores are not speculated.  This means that ordering -is-
>> provided
>>>> for load-store control dependencies, as in the following example:
>>>>
>>>>         q = READ_ONCE(a);
>>>>         if (q) {
>>>>                 WRITE_ONCE(b, 1);
>>>>         }
>>>>
>>>
>>>  Maybe I didn't make it clear.  This memory isolation is to ensure the order
>> of
>>>  memset(object, 0, size) in kzalloc() operations and the subsequent array
>> assignment statements.
>>>
>>> kzalloc()
>>>     ->memset(object, 0, size)
>>>
>>> smp_wmb()
>>>
>>> vg->vlan_devices_arrays[pidx][vidx] = array;
>>>
>>> Because __vlan_group_get_device() function depends on this order
>>
> 
>> Thanks for clarify, it would be good to mention this in the
>> commit log too.
> 
> OK,  I'll change it.  Thank you for your advice.
> 
>>
>> Also, __vlan_group_get_device() is used in the data path, it would
>> be to avoid the barrier op too. Maybe using rcu to avoid the barrier
>> if the __vlan_group_get_device() is already protected by rcu_lock.
> 
> Using the netperf command for testing on x86, there is no difference in performance:

This may make sense for x86 because x86 has a strong order memory
model, which has smp_rmb() as compiler barrier, as my understanding.

How about the weak order memory model CPU? such as arm64, which has
smp_rmb() as 'dmb' instruction.

Also the cpu usage may need to be looked at if data rate is
at line speed.

> 
> # netperf -H 112.113.0.12 -l 20 -t TCP_STREAM
> MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 112.113.0.12 () port 0 AF_INET
> Recv   Send    Send
> Socket Socket  Message  Elapsed
> Size   Size    Size     Time     Throughput
> bytes  bytes   bytes    secs.    10^6bits/sec
> 
> 131072  16384  16384    20.00    9386.03
> 
> After patch:
> 
>  # netperf -H 112.113.0.12 -l 20 -t TCP_STREAM
> MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 112.113.0.12 () port 0 AF_INET
> Recv   Send    Send
> Socket Socket  Message  Elapsed
> Size   Size    Size     Time     Throughput
> bytes  bytes   bytes    secs.    10^6bits/sec
> 
> 131072  16384  16384    20.00    9386.41
> 
> The same is true for UDP stream test
> 
>>
>>>
>>>>
>>>>
>>>>> may get a wrong address from the hardware cache on another cpu.
>>>>>
>>>>> So fix it by adding memory barrier instruction to ensure the order of
>>>>> memory operations.
>>>>>
>>>>> Signed-off-by: Di Zhu <zhudi21@huawei.com>
>>>>> ---
>>>>>  net/8021q/vlan.c | 2 ++
>>>>>  net/8021q/vlan.h | 3 +++
>>>>>  2 files changed, 5 insertions(+)
>>>>>
>>>>> diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c index
>>>>> 8b644113715e..4f541e05cd3f 100644
>>>>> --- a/net/8021q/vlan.c
>>>>> +++ b/net/8021q/vlan.c
>>>>> @@ -71,6 +71,8 @@ static int vlan_group_prealloc_vid(struct
>> vlan_group
>>>> *vg,
>>>>>  	if (array == NULL)
>>>>>  		return -ENOBUFS;
>>>>>
>>>>> +	smp_wmb();
>>>>> +
>>>>>  	vg->vlan_devices_arrays[pidx][vidx] = array;
>>>>>  	return 0;
>>>>>  }
>>>>> diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h index
>>>>> 953405362795..7408fda084d3 100644
>>>>> --- a/net/8021q/vlan.h
>>>>> +++ b/net/8021q/vlan.h
>>>>> @@ -57,6 +57,9 @@ static inline struct net_device
>>>>> *__vlan_group_get_device(struct vlan_group *vg,
>>>>>
>>>>>  	array = vg->vlan_devices_arrays[pidx]
>>>>>  				       [vlan_id /
>>>> VLAN_GROUP_ARRAY_PART_LEN];
>>>>> +
>>>>> +	smp_rmb();
>>>>> +
>>>>>  	return array ? array[vlan_id % VLAN_GROUP_ARRAY_PART_LEN] :
>>>> NULL;  }
>>>>>
>>>>>
>>>
> 

