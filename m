Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0492D5D33
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 15:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387883AbgLJOKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 09:10:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729351AbgLJOKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 09:10:03 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 194DBC061793
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 06:09:23 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id b8so5360784ila.13
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 06:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IPBbRhY2fa8scqQYa6fuHv3sg6vR+F2lX2rvUeIAO48=;
        b=JkdYsiUIuaKjkh9mnEn6K9UjsggLbkAEstkUertGwGfUsrbxgckPjN8K4kAMT+Qtn8
         E1t1cBIBcazvAi9hCvM7zR3BLzqI8d1JXZZqzB4xP6jFGjrIpE9B39At2l7g5WeuGT+u
         SUeS+KVEo87WLtzh1KVlcunTMvAhrHDXOXfIFHyEJjxSPl9zK7NzQ2NoGP2FqV6bV8JS
         WUuNs4AFeWDtn9cZXLh7WR1kMYqCQ1j/ZE7yoylDLN1I3uPqQHo5/HuELmzpXUgPjOg8
         WOqCY8CyqI9d81Lq6oF/oADMTwgUau75o3QgtjlBOZ0n/opE23HyfFKRTjq+oBfqVfV/
         3GWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IPBbRhY2fa8scqQYa6fuHv3sg6vR+F2lX2rvUeIAO48=;
        b=KVT3gXSNY2Jf6aQ31oJS2QiM+ZQL5KO3AcsgAiXus6lB8CrQirEJwZjX/Qf18SncJ8
         CFESP2OGknP/apKA09LPYSF5YdsbYNWaOOc4CfyNm8REXDiaGkNdb1LMPd7qjx4s3rDV
         VldirSAJc/XjhLPXkESH/XtZW9An3zg6Yo3ETiL8G90mg9XPIIwiGgqdwQ2WdapthynZ
         V8Wbz5uzHsmNVEcAHfYSyiy9vLSk+q93cxFYj3uUD1vnmgBQBPQh00LOb5r7RBGZxS/V
         JQvNWUiFogk70glfYW3gWJNGGpUjBEDR3BBt/qALLRauez7GxYx4al3g+bSppETAhA1R
         IPBA==
X-Gm-Message-State: AOAM531B5moC8OocPidvMtdUpKpvxTumclolqrek4IFMDC4hhB24KrKZ
        bYO+zLzHNSZq9xhBcIqx6cjy+5k9NATvNxd5Y50Xqw==
X-Google-Smtp-Source: ABdhPJy2c1PmZgAZz7NGUShF5YWd6ef23nP2jmGcLoSepngzWOBONwg3/eAjoiLwkee6Bcyu/sTpGjzZWWAJ44XjHeE=
X-Received: by 2002:a92:b12:: with SMTP id b18mr9243965ilf.216.1607609362100;
 Thu, 10 Dec 2020 06:09:22 -0800 (PST)
MIME-Version: 1.0
References: <20201210080844.23741-1-sjpark@amazon.com>
In-Reply-To: <20201210080844.23741-1-sjpark@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 10 Dec 2020 15:09:10 +0100
Message-ID: <CANn89i+egqwjJqGE6mZFB+-GuT_1dOQJP=pccREEZvEwQ1SGiw@mail.gmail.com>
Subject: Re: [PATCH v2 0/1] net: Reduce rcu_barrier() contentions from 'unshare(CLONE_NEWNET)'
To:     SeongJae Park <sjpark@amazon.com>
Cc:     David Miller <davem@davemloft.net>,
        SeongJae Park <sjpark@amazon.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Florian Westphal <fw@strlen.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        netdev <netdev@vger.kernel.org>, rcu@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 10, 2020 at 9:09 AM SeongJae Park <sjpark@amazon.com> wrote:
>
> From: SeongJae Park <sjpark@amazon.de>
>
> On a few of our systems, I found frequent 'unshare(CLONE_NEWNET)' calls
> make the number of active slab objects including 'sock_inode_cache' type
> rapidly and continuously increase.  As a result, memory pressure occurs.
>
> In more detail, I made an artificial reproducer that resembles the
> workload that we found the problem and reproduce the problem faster.  It
> merely repeats 'unshare(CLONE_NEWNET)' 50,000 times in a loop.  It takes
> about 2 minutes.  On 40 CPU cores, 70GB DRAM machine, it reduced about
> 15GB of available memory in total.  Note that the issue don't reproduce
> on every machine.  On my 6 CPU cores machine, the problem didn't
> reproduce.

OK, that is the number before the patch, but what is the number after
the patch ?

I think the idea is very nice, but this will serialize fqdir hash
tables destruction on one single cpu,
this might become a real issue _if_ these hash tables are populated.

(Obviously in your for (i=1;i<50000;i++) unshare(CLONE_NEWNET);  all
these tables are empty...)

As you may now, frags are often used as vectors for DDOS attacks.

I would suggest maybe to not (ab)use system_wq, but a dedicated work queue
with a limit (@max_active argument set to 1 in alloc_workqueue()) , to
make sure that the number of
threads is optimal/bounded.

Only the phase after hash table removal could benefit from your
deferral to a single context,
so that a single rcu_barrier() is active, since the part after
rcu_barrier() is damn cheap and _can_ be serialized

  if (refcount_dec_and_test(&f->refcnt))
                complete(&f->completion);

Thanks !

>
> 'cleanup_net()' and 'fqdir_work_fn()' are functions that deallocate the
> relevant memory objects.  They are asynchronously invoked by the work
> queues and internally use 'rcu_barrier()' to ensure safe destructions.
> 'cleanup_net()' works in a batched maneer in a single thread worker,
> while 'fqdir_work_fn()' works for each 'fqdir_exit()' call in the
> 'system_wq'.
>
> Therefore, 'fqdir_work_fn()' called frequently under the workload and
> made the contention for 'rcu_barrier()' high.  In more detail, the
> global mutex, 'rcu_state.barrier_mutex' became the bottleneck.
>
> I tried making 'fqdir_work_fn()' batched and confirmed it works.  The
> following patch is for the change.  I think this is the right solution
> for point fix of this issue, but someone might blame different parts.
>
> 1. User: Frequent 'unshare()' calls
> From some point of view, such frequent 'unshare()' calls might seem only
> insane.
>
> 2. Global mutex in 'rcu_barrier()'
> Because of the global mutex, 'rcu_barrier()' callers could wait long
> even after the callbacks started before the call finished.  Therefore,
> similar issues could happen in another 'rcu_barrier()' usages.  Maybe we
> can use some wait queue like mechanism to notify the waiters when the
> desired time came.
>
> I personally believe applying the point fix for now and making
> 'rcu_barrier()' improvement in longterm make sense.  If I'm missing
> something or you have different opinion, please feel free to let me
> know.
>
>
> Patch History
> -------------
>
> Changes from v1
> (https://lore.kernel.org/netdev/20201208094529.23266-1-sjpark@amazon.com/)
> - Keep xmas tree variable ordering (Jakub Kicinski)
> - Add more numbers (Eric Dumazet)
> - Use 'llist_for_each_entry_safe()' (Eric Dumazet)
>
> SeongJae Park (1):
>   net/ipv4/inet_fragment: Batch fqdir destroy works
>
>  include/net/inet_frag.h  |  2 +-
>  net/ipv4/inet_fragment.c | 28 ++++++++++++++++++++--------
>  2 files changed, 21 insertions(+), 9 deletions(-)
>
> --
> 2.17.1
>
