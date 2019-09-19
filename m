Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9501B79E0
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 14:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390416AbfISMz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 08:55:29 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2739 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389212AbfISMz2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 08:55:28 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 91770C78C476D9935686;
        Thu, 19 Sep 2019 20:55:25 +0800 (CST)
Received: from [127.0.0.1] (10.57.88.168) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Thu, 19 Sep 2019
 20:55:19 +0800
Subject: Re: [PATCH v4 1/3] kernel/notifier.c: intercepting duplicate
 registrations to avoid infinite loops
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <akpm@linux-foundation.org>, <vvs@virtuozzo.com>,
        <torvalds@linux-foundation.org>, <adobriyan@gmail.com>,
        <anna.schumaker@netapp.com>, <arjan@linux.intel.com>,
        <bfields@fieldses.org>, <chuck.lever@oracle.com>,
        <davem@davemloft.net>, <jlayton@kernel.org>, <luto@kernel.org>,
        <mingo@kernel.org>, <Nadia.Derbey@bull.net>,
        <paulmck@linux.vnet.ibm.com>, <semen.protsenko@linaro.org>,
        <stern@rowland.harvard.edu>, <tglx@linutronix.de>,
        <trond.myklebust@hammerspace.com>, <viresh.kumar@linaro.org>,
        <stable@kernel.org>, <dylix.dailei@huawei.com>,
        <yuehaibing@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-nfs@vger.kernel.org>, <netdev@vger.kernel.org>
References: <1568861888-34045-1-git-send-email-nixiaoming@huawei.com>
 <1568861888-34045-2-git-send-email-nixiaoming@huawei.com>
 <20190919063615.GA2069346@kroah.com>
From:   Xiaoming Ni <nixiaoming@huawei.com>
Message-ID: <b37575b1-2ea4-d813-c262-b52b322652c1@huawei.com>
Date:   Thu, 19 Sep 2019 20:55:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190919063615.GA2069346@kroah.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.57.88.168]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/9/19 14:36, Greg KH wrote:
> On Thu, Sep 19, 2019 at 10:58:06AM +0800, Xiaoming Ni wrote:
>> Registering the same notifier to a hook repeatedly can cause the hook
>> list to form a ring or lose other members of the list.
>>
>> case1: An infinite loop in notifier_chain_register() can cause soft lockup
>>         atomic_notifier_chain_register(&test_notifier_list, &test1);
>>         atomic_notifier_chain_register(&test_notifier_list, &test1);
>>         atomic_notifier_chain_register(&test_notifier_list, &test2);
>>
>> case2: An infinite loop in notifier_chain_register() can cause soft lockup
>>         atomic_notifier_chain_register(&test_notifier_list, &test1);
>>         atomic_notifier_chain_register(&test_notifier_list, &test1);
>>         atomic_notifier_call_chain(&test_notifier_list, 0, NULL);
>>
>> case3: lose other hook test2
>>         atomic_notifier_chain_register(&test_notifier_list, &test1);
>>         atomic_notifier_chain_register(&test_notifier_list, &test2);
>>         atomic_notifier_chain_register(&test_notifier_list, &test1);
>>
>> case4: Unregister returns 0, but the hook is still in the linked list,
>>         and it is not really registered. If you call notifier_call_chain
>>         after ko is unloaded, it will trigger oops.
>>
>> If the system is configured with softlockup_panic and the same
>> hook is repeatedly registered on the panic_notifier_list, it
>> will cause a loop panic.
>>
>> Add a check in notifier_chain_register(),
>> Intercepting duplicate registrations to avoid infinite loops
>>
>> Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
>> Reviewed-by: Vasily Averin <vvs@virtuozzo.com>
>> ---
>>  kernel/notifier.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
> 
thanks for your guidance
I thought that as long as the code exists in the stable branch, it should be copied to stable@kernel.org
it is my mistake,

These patches are intended to be sent to the main line.
Should I resend it again?

> </formletter>
> 
> Same thing goes for all of the patches in this series.
> 
> thanks,
> 
> greg k-h
> 
> .
> 

thanks

Xiaoming Ni

