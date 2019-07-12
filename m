Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25A4666FCA
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 15:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727594AbfGLNMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 09:12:14 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:54852 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726449AbfGLNMN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jul 2019 09:12:13 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id CAD78CE0BF21130718B8;
        Fri, 12 Jul 2019 21:12:06 +0800 (CST)
Received: from [127.0.0.1] (10.57.88.168) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Fri, 12 Jul 2019
 21:11:57 +0800
Subject: Re: [PATCH v3 0/3] kernel/notifier.c: avoid duplicate registration
To:     Vasily Averin <vvs@virtuozzo.com>,
        "adobriyan@gmail.com" <adobriyan@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jlayton@kernel.org" <jlayton@kernel.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "Nadia.Derbey@bull.net" <Nadia.Derbey@bull.net>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "semen.protsenko@linaro.org" <semen.protsenko@linaro.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "trond.myklebust@hammerspace.com" <trond.myklebust@hammerspace.com>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>
CC:     "Huangjianhui (Alex)" <alex.huangjianhui@huawei.com>,
        Dailei <dylix.dailei@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1562728147-30251-1-git-send-email-nixiaoming@huawei.com>
 <f628ff03-eb47-62f3-465b-fe4ed046b30c@virtuozzo.com>
 <E490CD805F7529488761C40FD9D26EF12AC9D068@dggemm507-mbx.china.huawei.com>
 <d70ba831-85c7-d5a3-670a-144fa4d139cc@virtuozzo.com>
From:   Xiaoming Ni <nixiaoming@huawei.com>
Message-ID: <8ee6f763-ccce-ab58-3d96-21f5e1622916@huawei.com>
Date:   Fri, 12 Jul 2019 21:11:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <d70ba831-85c7-d5a3-670a-144fa4d139cc@virtuozzo.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.57.88.168]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/7/11 21:57, Vasily Averin wrote:
> On 7/11/19 4:55 AM, Nixiaoming wrote:
>> On Wed, July 10, 2019 1:49 PM Vasily Averin wrote:
>>> On 7/10/19 6:09 AM, Xiaoming Ni wrote:
>>>> Registering the same notifier to a hook repeatedly can cause the hook
>>>> list to form a ring or lose other members of the list.
>>>
>>> I think is not enough to _prevent_ 2nd register attempt,
>>> it's enough to detect just attempt and generate warning to mark host in bad state.
>>>
>>
>> Duplicate registration is prevented in my patch, not just "mark host in bad state"
>>
>> Duplicate registration is checked and exited in notifier_chain_cond_register()
>>
>> Duplicate registration was checked in notifier_chain_register() but only 
>> the alarm was triggered without exiting. added by commit 831246570d34692e 
>> ("kernel/notifier.c: double register detection")
>>
>> My patch is like a combination of 831246570d34692e and notifier_chain_cond_register(),
>>  which triggers an alarm and exits when a duplicate registration is detected.
>>
>>> Unexpected 2nd register of the same hook most likely will lead to 2nd unregister,
>>> and it can lead to host crash in any time: 
>>> you can unregister notifier on first attempt it can be too early, it can be still in use.
>>> on the other hand you can never call 2nd unregister at all.
>>
>> Since the member was not added to the linked list at the time of the second registration, 
>> no linked list ring was formed. 
>> The member is released on the first unregistration and -ENOENT on the second unregistration.
>> After patching, the fault has been alleviated
> 
> You are wrong here.
> 2nd notifier's registration is a pure bug, this should never happen.
> If you know the way to reproduce this situation -- you need to fix it. 
> 
> 2nd registration can happen in 2 cases:
> 1) missed rollback, when someone forget to call unregister after successfull registration, 
> and then tried to call register again. It can lead to crash for example when according module will be unloaded.
> 2) some subsystem is registered twice, for example from  different namespaces.
> in this case unregister called during sybsystem cleanup in first namespace will incorrectly remove notifier used 
> in second namespace, it also can lead to unexpacted behaviour.
> 
So in these two cases, is it more reasonable to trigger BUG() directly when checking for duplicate registration ?
But why does current notifier_chain_register() just trigger WARN() without exiting ?
notifier_chain_cond_register() direct exit without triggering WARN() ?

Thanks

Xiaoming Ni

>> It may be more helpful to return an error code when someone tries to register the same
>> notification program a second time.
> 
> You are wrong again here, it is senseless.
> If you have detected 2nd register -- your node is already in bad state.
> 
>> But I noticed that notifier_chain_cond_register() returns 0 when duplicate registration 
>> is detected. At the same time, in all the existing export function comments of notify,
>> "Currently always returns zero"
>>
>> I am a bit confused: which is better?
>>
>>>
>>> Unfortunately I do not see any ways to handle such cases properly,
>>> and it seems for me your patches does not resolve this problem.
>>>
>>> Am I missed something probably?
>>>
>>>> case1: An infinite loop in notifier_chain_register() can cause soft lockup
>>>>         atomic_notifier_chain_register(&test_notifier_list, &test1);
>>>>         atomic_notifier_chain_register(&test_notifier_list, &test1);
>>>>         atomic_notifier_chain_register(&test_notifier_list, &test2);
>>
>> Thanks
>>
>> Xiaoming Ni
>>
> 
> .
> 

