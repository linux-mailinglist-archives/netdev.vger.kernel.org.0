Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 549396BB35
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 13:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbfGQLPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 07:15:52 -0400
Received: from relay.sw.ru ([185.231.240.75]:40486 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbfGQLPv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 07:15:51 -0400
Received: from [172.16.24.21]
        by relay.sw.ru with esmtp (Exim 4.92)
        (envelope-from <vvs@virtuozzo.com>)
        id 1hnhuJ-0008OT-NO; Wed, 17 Jul 2019 14:15:35 +0300
Subject: Re: [PATCH v3 0/3] kernel/notifier.c: avoid duplicate registration
To:     Xiaoming Ni <nixiaoming@huawei.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     "adobriyan@gmail.com" <adobriyan@gmail.com>,
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
 <65f50cf2-3051-ab55-078f-30930fe0c9bc@huawei.com>
 <5521e5a4-66d9-aaf8-3a12-3999bfc6be8b@virtuozzo.com>
 <3bbc16ba-953c-a6b6-c5f3-4deaeaa25d10@huawei.com>
 <e4753c70-de7c-063a-dc49-0edc7520ccd2@virtuozzo.com>
 <d418e8ed-de54-53af-a0db-3535ae50e540@huawei.com>
From:   Vasily Averin <vvs@virtuozzo.com>
Message-ID: <0d245a97-1169-9ef2-e502-043ba80eaa8c@virtuozzo.com>
Date:   Wed, 17 Jul 2019 14:15:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <d418e8ed-de54-53af-a0db-3535ae50e540@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/16/19 5:07 PM, Xiaoming Ni wrote:
> On 2019/7/16 18:20, Vasily Averin wrote:
>> On 7/16/19 5:00 AM, Xiaoming Ni wrote:
>>> On 2019/7/15 13:38, Vasily Averin wrote:
>>>> On 7/14/19 5:45 AM, Xiaoming Ni wrote:
>>>>> On 2019/7/12 22:07, gregkh@linuxfoundation.org wrote:
>>>>>> On Fri, Jul 12, 2019 at 09:11:57PM +0800, Xiaoming Ni wrote:
>>>>>>> On 2019/7/11 21:57, Vasily Averin wrote:
>>>>>>>> On 7/11/19 4:55 AM, Nixiaoming wrote:
>>>>>>>>> On Wed, July 10, 2019 1:49 PM Vasily Averin wrote:
>>>>>>>>>> On 7/10/19 6:09 AM, Xiaoming Ni wrote:
>>>>>>>>>>> Registering the same notifier to a hook repeatedly can cause the hook
>>>>>>>>>>> list to form a ring or lose other members of the list.
>>>>>>>>>>
>>>>>>>>>> I think is not enough to _prevent_ 2nd register attempt,
>>>>>>>>>> it's enough to detect just attempt and generate warning to mark host in bad state.
>>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Duplicate registration is prevented in my patch, not just "mark host in bad state"
>>>>>>>>>
>>>>>>>>> Duplicate registration is checked and exited in notifier_chain_cond_register()
>>>>>>>>>
>>>>>>>>> Duplicate registration was checked in notifier_chain_register() but only 
>>>>>>>>> the alarm was triggered without exiting. added by commit 831246570d34692e 
>>>>>>>>> ("kernel/notifier.c: double register detection")
>>>>>>>>>
>>>>>>>>> My patch is like a combination of 831246570d34692e and notifier_chain_cond_register(),
>>>>>>>>>  which triggers an alarm and exits when a duplicate registration is detected.
>>>>>>>>>
>>>>>>>>>> Unexpected 2nd register of the same hook most likely will lead to 2nd unregister,
>>>>>>>>>> and it can lead to host crash in any time: 
>>>>>>>>>> you can unregister notifier on first attempt it can be too early, it can be still in use.
>>>>>>>>>> on the other hand you can never call 2nd unregister at all.
>>>>>>>>>
>>>>>>>>> Since the member was not added to the linked list at the time of the second registration, 
>>>>>>>>> no linked list ring was formed. 
>>>>>>>>> The member is released on the first unregistration and -ENOENT on the second unregistration.
>>>>>>>>> After patching, the fault has been alleviated
>>>>>>>>
>>>>>>>> You are wrong here.
>>>>>>>> 2nd notifier's registration is a pure bug, this should never happen.
>>>>>>>> If you know the way to reproduce this situation -- you need to fix it. 
>>>>>>>>
>>>>>>>> 2nd registration can happen in 2 cases:
>>>>>>>> 1) missed rollback, when someone forget to call unregister after successfull registration, 
>>>>>>>> and then tried to call register again. It can lead to crash for example when according module will be unloaded.
>>>>>>>> 2) some subsystem is registered twice, for example from  different namespaces.
>>>>>>>> in this case unregister called during sybsystem cleanup in first namespace will incorrectly remove notifier used 
>>>>>>>> in second namespace, it also can lead to unexpacted behaviour.
>>>>>>>>
>>>>>>> So in these two cases, is it more reasonable to trigger BUG() directly when checking for duplicate registration ?
>>>>>>> But why does current notifier_chain_register() just trigger WARN() without exiting ?
>>>>>>> notifier_chain_cond_register() direct exit without triggering WARN() ?
>>>>>>
>>>>>> It should recover from this, if it can be detected.  The main point is
>>>>>> that not all apis have to be this "robust" when used within the kernel
>>>>>> as we do allow for the callers to know what they are doing :)
>>>>>>
>>>>> In the notifier_chain_register(), the condition ( (*nl) == n) is the same registration of the same hook.
>>>>>  We can intercept this situation and avoid forming a linked list ring to make the API more rob
>>>>
>>>> Once again -- yes, you CAN prevent list corruption, but you CANNOT recover the host and return it back to safe state.
>>>> If double register event was detected -- it means you have bug in kernel.
>>>>
>>>> Yes, you can add BUG here and crash the host immediately, but I prefer to use warning in such situations.
>>>>
>>>>>> If this does not cause any additional problems or slow downs, it's
>>>>>> probably fine to add.
>>>>>>
>>>>> Notifier_chain_register() is not a system hotspot function.
>>>>> At the same time, there is already a WARN_ONCE judgment. There is no new judgment in the new patch.
>>>>> It only changes the processing under the condition of (*nl) == n, which will not cause performance problems.
>>>>> At the same time, avoiding the formation of a link ring can make the system more robust.
>>>>
>>>> I disagree, 
>>>> yes, node will have correct list, but anyway node will work wrong and can crash the host in any time.
>>>
>>> Sorry, my description is not accurate.
>>>
>>> My patch feature does not prevent users from repeatedly registering hooks.
>>> But avoiding the chain ring caused by the user repeatedly registering the hook
>>>
>>> There are no modules for duplicate registration hooks in the current system.
>>> But considering that not all modules are in the kernel source tree,
>>> In order to improve the robustness of the kernel API, we should avoid the linked list ring caused by repeated registration.
>>> Or in order to improve the efficiency of problem location, when the duplicate registration is checked, the system crashes directly.
>>
>> Detect of duplicate registration means an unrecoverable error,
>> from this point of view it makes sense to replace WARN_ONCE by BUG_ON.
>>  
>>> On the other hand, the difference between notifier_chain_register() and notifier_chain_cond_register() for duplicate registrations is confusing:
>>> Blocking the formation of the linked list ring in notifier_chain_cond_register()
>>> There is no interception of the linked list ring in notifier_chain_register(), just an alarm.
>>> Give me the illusion: Isn't notifier_chain_register() allowed to create a linked list ring?
>>
>> I'm not sure that I understood your question correctly but will try to answer.
>> As far as I see all callers of notifier_chain_cond_register checks return value, expect possible failure and handle it somehow.
>> On the other hand callers of notifier_chain_register() in many cases do not check return value and always expect success.
>> The goal of original WARN_ONCE -- to detect possible misuse of notifiers and it seems for me it correctly handles this task.
>>
> Notifier_chain_cond_register() has only one return value: 0

It looks wrong for me.

> At the same time, it is only called by blocking_notifier_chain_cond_register().
> In the function comment of blocking_notifier_chain_cond_register there is " Currently always returns zero."
> Therefore, the user cannot check whether the hook has duplicate registration or other errors by checking the return value.

I think notifier_chain_cond_register can be changed to return error.
It is safe now, all its in-tree callers checks return value and can properly react on such error.

On the other hand, in all cases notifier_chain_cond_register are  __init functions, 
they are called once only and double registration seems is impossible here:
even if some old notifier was lost and was not properly unregistered, 
new one will have another address.
And even if these addresses was equal -- it is critical error 
and I prefer to generate warning instead of silent failure of module load.

> If the interceptor list ring is added to notifier_chain_register(), notifier_chain_register()
>  And notifier_chain_cond_register() becomes redundant code, we can delete one of them

Yes, I'm agree, at present there are no difference between
notifier_chain_cond_register() and notifier_chain_register()

Question is -- how to improve it.
You propose to remove notifier_chain_cond_register() by some way.
Another option is return an error, for some abstract callers who expect possible double registration.

Frankly speaking I prefer second one,
however because of kernel do not have any such callers right now seems you are right, 
and we can delete notifier_chain_cond_register().

So let me finally accept your patch-set.

Thank you,
	Vasily Averin
