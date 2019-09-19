Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91D70B7337
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 08:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388004AbfISGgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 02:36:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:35370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725320AbfISGgS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 02:36:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 840D0218AF;
        Thu, 19 Sep 2019 06:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568874978;
        bh=kLqycoBe8uV8E2knqmFJ1o58JmJlygAiwWJwYCZe3u4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MBj1OhUSqRr3IZoLYSeHbj1Qf6DNpVP0GFMSepJmowWR/fpbYu+KDjGnM8GDDFTwT
         C2wlqJBLS12ZilvPdqSYpw/TpurkUrYrG9oTs+V1gQ691DjUUdUPbQSBM+ZbNzA0NC
         3jOV/vXTS9pdhd4wf6ILs7cuvS20g5fiiHPm20xw=
Date:   Thu, 19 Sep 2019 08:36:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xiaoming Ni <nixiaoming@huawei.com>
Cc:     akpm@linux-foundation.org, vvs@virtuozzo.com,
        torvalds@linux-foundation.org, adobriyan@gmail.com,
        anna.schumaker@netapp.com, arjan@linux.intel.com,
        bfields@fieldses.org, chuck.lever@oracle.com, davem@davemloft.net,
        jlayton@kernel.org, luto@kernel.org, mingo@kernel.org,
        Nadia.Derbey@bull.net, paulmck@linux.vnet.ibm.com,
        semen.protsenko@linaro.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, trond.myklebust@hammerspace.com,
        viresh.kumar@linaro.org, stable@kernel.org,
        dylix.dailei@huawei.com, yuehaibing@huawei.com,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 1/3] kernel/notifier.c: intercepting duplicate
 registrations to avoid infinite loops
Message-ID: <20190919063615.GA2069346@kroah.com>
References: <1568861888-34045-1-git-send-email-nixiaoming@huawei.com>
 <1568861888-34045-2-git-send-email-nixiaoming@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1568861888-34045-2-git-send-email-nixiaoming@huawei.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 10:58:06AM +0800, Xiaoming Ni wrote:
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
> Add a check in notifier_chain_register(),
> Intercepting duplicate registrations to avoid infinite loops
> 
> Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
> Reviewed-by: Vasily Averin <vvs@virtuozzo.com>
> ---
>  kernel/notifier.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>

Same thing goes for all of the patches in this series.

thanks,

greg k-h
