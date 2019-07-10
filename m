Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06F49640CE
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 07:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfGJFtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 01:49:42 -0400
Received: from relay.sw.ru ([185.231.240.75]:49196 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725844AbfGJFtl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 01:49:41 -0400
Received: from [172.16.24.21]
        by relay.sw.ru with esmtp (Exim 4.92)
        (envelope-from <vvs@virtuozzo.com>)
        id 1hl5Ti-0002oO-18; Wed, 10 Jul 2019 08:49:18 +0300
Subject: Re: [PATCH v3 0/3] kernel/notifier.c: avoid duplicate registration
To:     Xiaoming Ni <nixiaoming@huawei.com>, adobriyan@gmail.com,
        akpm@linux-foundation.org, anna.schumaker@netapp.com,
        arjan@linux.intel.com, bfields@fieldses.org,
        chuck.lever@oracle.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, jlayton@kernel.org, luto@kernel.org,
        mingo@kernel.org, Nadia.Derbey@bull.net,
        paulmck@linux.vnet.ibm.com, semen.protsenko@linaro.org,
        stable@kernel.org, stern@rowland.harvard.edu, tglx@linutronix.de,
        torvalds@linux-foundation.org, trond.myklebust@hammerspace.com,
        viresh.kumar@linaro.org
Cc:     alex.huangjianhui@huawei.com, dylix.dailei@huawei.com,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
References: <1562728147-30251-1-git-send-email-nixiaoming@huawei.com>
From:   Vasily Averin <vvs@virtuozzo.com>
Message-ID: <f628ff03-eb47-62f3-465b-fe4ed046b30c@virtuozzo.com>
Date:   Wed, 10 Jul 2019 08:49:06 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1562728147-30251-1-git-send-email-nixiaoming@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/10/19 6:09 AM, Xiaoming Ni wrote:
> Registering the same notifier to a hook repeatedly can cause the hook
> list to form a ring or lose other members of the list.

I think is not enough to _prevent_ 2nd register attempt,
it's enough to detect just attempt and generate warning to mark host in bad state.

Unexpected 2nd register of the same hook most likely will lead to 2nd unregister,
and it can lead to host crash in any time: 
you can unregister notifier on first attempt it can be too early, it can be still in use.
on the other hand you can never call 2nd unregister at all.

Unfortunately I do not see any ways to handle such cases properly,
and it seems for me your patches does not resolve this problem.

Am I missed something probably?
 
> case1: An infinite loop in notifier_chain_register() can cause soft lockup
>         atomic_notifier_chain_register(&test_notifier_list, &test1);
>         atomic_notifier_chain_register(&test_notifier_list, &test1);
>         atomic_notifier_chain_register(&test_notifier_list, &test2);
> 
> case2: An infinite loop in notifier_chain_register() can cause soft lockup
>         atomic_notifier_chain_register(&test_notifier_list, &test1);
>         atomic_notifier_chain_register(&test_notifier_list, &test1);
>         atomic_notifier_call_chain(&test_notifier_list, 0, NULL);
> 
> case3: lose other hook test2
>         atomic_notifier_chain_register(&test_notifier_list, &test1);
>         atomic_notifier_chain_register(&test_notifier_list, &test2);
>         atomic_notifier_chain_register(&test_notifier_list, &test1);
> 
> case4: Unregister returns 0, but the hook is still in the linked list,
>         and it is not really registered. If you call notifier_call_chain
>         after ko is unloaded, it will trigger oops. if the system is
>        	configured with softlockup_panic and the same hook is repeatedly
>        	registered on the panic_notifier_list, it will cause a loop panic.
> 
> so. need add a check in in notifier_chain_register() to avoid duplicate
> registration
> 
> v1:
> * use notifier_chain_cond_register replace notifier_chain_register
> 
> v2:
> * Add a check in notifier_chain_register() to avoid duplicate registration
> * remove notifier_chain_cond_register() to avoid duplicate code 
> * remove blocking_notifier_chain_cond_register() to avoid duplicate code
> 
> v3:
> * Add a cover letter.
> 
> Xiaoming Ni (3):
>   kernel/notifier.c: avoid duplicate registration
>   kernel/notifier.c: remove notifier_chain_cond_register()
>   kernel/notifier.c: remove blocking_notifier_chain_cond_register()
> 
>  include/linux/notifier.h |  4 ----
>  kernel/notifier.c        | 41 +++--------------------------------------
>  net/sunrpc/rpc_pipe.c    |  2 +-
>  3 files changed, 4 insertions(+), 43 deletions(-)
> 
