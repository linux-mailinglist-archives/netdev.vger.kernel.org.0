Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAE896BB3D
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 13:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbfGQLTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 07:19:30 -0400
Received: from relay.sw.ru ([185.231.240.75]:40572 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbfGQLTa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 07:19:30 -0400
Received: from [172.16.24.21]
        by relay.sw.ru with esmtp (Exim 4.92)
        (envelope-from <vvs@virtuozzo.com>)
        id 1hnhy0-0008Pe-EY; Wed, 17 Jul 2019 14:19:24 +0300
Subject: Re: [PATCH v3 1/3] kernel/notifier.c: avoid duplicate registration
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
References: <1562728150-30301-1-git-send-email-nixiaoming@huawei.com>
From:   Vasily Averin <vvs@virtuozzo.com>
Message-ID: <5a84e4b6-902d-a2ab-8416-2320bfab2a52@virtuozzo.com>
Date:   Wed, 17 Jul 2019 14:19:13 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1562728150-30301-1-git-send-email-nixiaoming@huawei.com>
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
> 
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
>         after ko is unloaded, it will trigger oops.
> 
> If the system is configured with softlockup_panic and the same
> hook is repeatedly registered on the panic_notifier_list, it
> will cause a loop panic.
> 
> Add a check in notifier_chain_register() to avoid duplicate registration
> 
> Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
Reviewed-by: Vasily Averin <vvs@virtuozzo.com>
> ---
>  kernel/notifier.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/notifier.c b/kernel/notifier.c
> index d9f5081..30bedb8 100644
> --- a/kernel/notifier.c
> +++ b/kernel/notifier.c
> @@ -23,7 +23,10 @@ static int notifier_chain_register(struct notifier_block **nl,
>  		struct notifier_block *n)
>  {
>  	while ((*nl) != NULL) {
> -		WARN_ONCE(((*nl) == n), "double register detected");
> +		if (unlikely((*nl) == n)) {
> +			WARN(1, "double register detected");
> +			return 0;
> +		}
>  		if (n->priority > (*nl)->priority)
>  			break;
>  		nl = &((*nl)->next);
> 
