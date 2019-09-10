Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9EB3AE2AC
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 05:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392946AbfIJD6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 23:58:09 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:33042 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392933AbfIJD6I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 23:58:08 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8C9D799A7E3F6E758FE2;
        Tue, 10 Sep 2019 11:58:03 +0800 (CST)
Received: from [127.0.0.1] (10.57.88.168) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Tue, 10 Sep 2019
 11:57:56 +0800
From:   Xiaoming Ni <nixiaoming@huawei.com>
Subject: Re: [PATCH v3 0/3] kernel/notifier.c: avoid duplicate registration
To:     Vasily Averin <vvs@virtuozzo.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "adobriyan@gmail.com" <adobriyan@gmail.com>,
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
 <0d245a97-1169-9ef2-e502-043ba80eaa8c@virtuozzo.com>
Message-ID: <664674a5-5ed9-8f0a-27ae-b4b868e96bdb@huawei.com>
Date:   Tue, 10 Sep 2019 11:57:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <0d245a97-1169-9ef2-e502-043ba80eaa8c@virtuozzo.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.57.88.168]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/7/17 19:15, Vasily Averin wrote:
> On 7/16/19 5:07 PM, Xiaoming Ni wrote:
>> On 2019/7/16 18:20, Vasily Averin wrote:
>>> On 7/16/19 5:00 AM, Xiaoming Ni wrote:
>>>> On 2019/7/15 13:38, Vasily Averin wrote:
>>>>> On 7/14/19 5:45 AM, Xiaoming Ni wrote:
>>>>>> On 2019/7/12 22:07, gregkh@linuxfoundation.org wrote:
>>>>>>> On Fri, Jul 12, 2019 at 09:11:57PM +0800, Xiaoming Ni wrote:
>>>>>>>> On 2019/7/11 21:57, Vasily Averin wrote:
>>>>>>>>> On 7/11/19 4:55 AM, Nixiaoming wrote:
>>>>>>>>>> On Wed, July 10, 2019 1:49 PM Vasily Averin wrote:
>>>>>>>>>>> On 7/10/19 6:09 AM, Xiaoming Ni wrote:
....
...
>>>>>>>> So in these two cases, is it more reasonable to trigger BUG() directly when checking for duplicate registration ?
>>>>>>>> But why does current notifier_chain_register() just trigger WARN() without exiting ?
>>>>>>>> notifier_chain_cond_register() direct exit without triggering WARN() ?
>>>>>>>
>>>>>>> It should recover from this, if it can be detected.  The main point is
>>>>>>> that not all apis have to be this "robust" when used within the kernel
>>>>>>> as we do allow for the callers to know what they are doing :)
>>>>>>>
>>>>>> In the notifier_chain_register(), the condition ( (*nl) == n) is the same registration of the same hook.
>>>>>>  We can intercept this situation and avoid forming a linked list ring to make the API more rob
...
...

> Yes, I'm agree, at present there are no difference between
> notifier_chain_cond_register() and notifier_chain_register()
> 
> Question is -- how to improve it.
> You propose to remove notifier_chain_cond_register() by some way.
> Another option is return an error, for some abstract callers who expect possible double registration.
> 
> Frankly speaking I prefer second one,
> however because of kernel do not have any such callers right now seems you are right, 
> and we can delete notifier_chain_cond_register().
> 
> So let me finally accept your patch-set.
> 
> Thank you,
> 	Vasily Averin
> 
> .
>

Dear Greg Kroah-Hartman
is there any other opinion on this patch set?
can you pick this series?

thanks
	Xiaoming Ni

