Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED51167CBC
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 04:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbfGNCpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jul 2019 22:45:50 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56550 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727918AbfGNCpt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Jul 2019 22:45:49 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 12EC11D3CA4F278F5E32;
        Sun, 14 Jul 2019 10:45:46 +0800 (CST)
Received: from [127.0.0.1] (10.57.88.168) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Sun, 14 Jul 2019
 10:45:40 +0800
Subject: Re: [PATCH v3 0/3] kernel/notifier.c: avoid duplicate registration
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     Vasily Averin <vvs@virtuozzo.com>,
        "adobriyan@gmail.com" <adobriyan@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
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
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "Huangjianhui (Alex)" <alex.huangjianhui@huawei.com>,
        Dailei <dylix.dailei@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1562728147-30251-1-git-send-email-nixiaoming@huawei.com>
 <f628ff03-eb47-62f3-465b-fe4ed046b30c@virtuozzo.com>
 <E490CD805F7529488761C40FD9D26EF12AC9D068@dggemm507-mbx.china.huawei.com>
 <d70ba831-85c7-d5a3-670a-144fa4d139cc@virtuozzo.com>
 <8ee6f763-ccce-ab58-3d96-21f5e1622916@huawei.com>
 <20190712140729.GA11583@kroah.com>
From:   Xiaoming Ni <nixiaoming@huawei.com>
Message-ID: <65f50cf2-3051-ab55-078f-30930fe0c9bc@huawei.com>
Date:   Sun, 14 Jul 2019 10:45:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190712140729.GA11583@kroah.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.57.88.168]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/7/12 22:07, gregkh@linuxfoundation.org wrote:
> On Fri, Jul 12, 2019 at 09:11:57PM +0800, Xiaoming Ni wrote:
>> On 2019/7/11 21:57, Vasily Averin wrote:
>>> On 7/11/19 4:55 AM, Nixiaoming wrote:
>>>> On Wed, July 10, 2019 1:49 PM Vasily Averin wrote:
>>>>> On 7/10/19 6:09 AM, Xiaoming Ni wrote:
>>>>>> Registering the same notifier to a hook repeatedly can cause the hook
>>>>>> list to form a ring or lose other members of the list.
>>>>>
>>>>> I think is not enough to _prevent_ 2nd register attempt,
>>>>> it's enough to detect just attempt and generate warning to mark host in bad state.
>>>>>
>>>>
>>>> Duplicate registration is prevented in my patch, not just "mark host in bad state"
>>>>
>>>> Duplicate registration is checked and exited in notifier_chain_cond_register()
>>>>
>>>> Duplicate registration was checked in notifier_chain_register() but only 
>>>> the alarm was triggered without exiting. added by commit 831246570d34692e 
>>>> ("kernel/notifier.c: double register detection")
>>>>
>>>> My patch is like a combination of 831246570d34692e and notifier_chain_cond_register(),
>>>>  which triggers an alarm and exits when a duplicate registration is detected.
>>>>
>>>>> Unexpected 2nd register of the same hook most likely will lead to 2nd unregister,
>>>>> and it can lead to host crash in any time: 
>>>>> you can unregister notifier on first attempt it can be too early, it can be still in use.
>>>>> on the other hand you can never call 2nd unregister at all.
>>>>
>>>> Since the member was not added to the linked list at the time of the second registration, 
>>>> no linked list ring was formed. 
>>>> The member is released on the first unregistration and -ENOENT on the second unregistration.
>>>> After patching, the fault has been alleviated
>>>
>>> You are wrong here.
>>> 2nd notifier's registration is a pure bug, this should never happen.
>>> If you know the way to reproduce this situation -- you need to fix it. 
>>>
>>> 2nd registration can happen in 2 cases:
>>> 1) missed rollback, when someone forget to call unregister after successfull registration, 
>>> and then tried to call register again. It can lead to crash for example when according module will be unloaded.
>>> 2) some subsystem is registered twice, for example from  different namespaces.
>>> in this case unregister called during sybsystem cleanup in first namespace will incorrectly remove notifier used 
>>> in second namespace, it also can lead to unexpacted behaviour.
>>>
>> So in these two cases, is it more reasonable to trigger BUG() directly when checking for duplicate registration ?
>> But why does current notifier_chain_register() just trigger WARN() without exiting ?
>> notifier_chain_cond_register() direct exit without triggering WARN() ?
> 
> It should recover from this, if it can be detected.  The main point is
> that not all apis have to be this "robust" when used within the kernel
> as we do allow for the callers to know what they are doing :)
> 
In the notifier_chain_register(), the condition ( (*nl) == n) is the same registration of the same hook.
 We can intercept this situation and avoid forming a linked list ring to make the API more rob

> If this does not cause any additional problems or slow downs, it's
> probably fine to add.
> 
Notifier_chain_register() is not a system hotspot function.
At the same time, there is already a WARN_ONCE judgment. There is no new judgment in the new patch.
It only changes the processing under the condition of (*nl) == n, which will not cause performance problems.
At the same time, avoiding the formation of a link ring can make the system more robust.

> thanks,
> 
> greg k-h
> 
> .
> 
Thanks

Xiaoming Ni


