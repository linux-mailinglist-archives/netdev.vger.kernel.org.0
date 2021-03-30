Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43D4934E6FD
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 14:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbhC3L7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 07:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231812AbhC3L7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 07:59:37 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61965C061574;
        Tue, 30 Mar 2021 04:59:37 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id c8so15947962wrq.11;
        Tue, 30 Mar 2021 04:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=U/4TeLcM1UNsh9OCgocN0tnCoz1dv6AKljeqZVGsdkE=;
        b=nwTyc7QEJdlUs/TfyvLtXvJqn930gAyt7rNHkJJCsr1A6x8Sgj26LWdvwSYyy0bvIW
         t7vMfAAGkkNnq6YeV/uWjFBhdsM9/602iP5QO3QX28NtPRuc1OdMjbhm2IQMiPMdzLib
         NkHdl7Ud2tkWmlPz4SEsHf9GOMJqVatpaTe8qV7rvxtG8uHk77xdm+wQzPkVXzkmce0y
         sxe6JtQQe+0scCA1VxWjjyVvxdtpP7W8dW3Z4jqy+Dl7PjyG9va1zYQq0k1hjobowXUN
         R0e8d5ICG/MnXUaMaUFyiicFl7p53aV6FebCCwWMlncuB5URZ4K8sWoelmenq3mNBoLo
         0pVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U/4TeLcM1UNsh9OCgocN0tnCoz1dv6AKljeqZVGsdkE=;
        b=uFKq/+D1d3G0DBfEBpmF6OeB8Cbfvbe0hsasBjujt8QaZr+5WLUvig77PbaFK5Vhhk
         lXcPFYxmZV4cPK5li8s0GlBH/WxDlidsE3X4SSGjJyOuB7u/Lgl+bg+pAobvzcbrPMwQ
         nTamr/RoqsOKu3vHhvpReXL7I4RwqvVuR1cCCoOyldFLN9L3/UykJ0GJLz+3Nvy/3lQG
         kUnz6QBpTPfAwJcpN3uFhyzfat/CMLPB5d8Vi09qajB+v0Xr0Vm0YpYsbQOgWmTYQWBd
         +Fn6rbL3+LzY+X6y9D2sl7AWHIZ69cbvcqTz4S11fHHVESSMwyMoPbKeIBOIblCcHng2
         wuQw==
X-Gm-Message-State: AOAM5307Y64JdTmMBKBtMy3KX9kOnKDQPUOAXz8JYj7065yXQj2FS45D
        ZFpy2/Shl5O5W9eTxgkTCoo=
X-Google-Smtp-Source: ABdhPJy+WBqRR0bXmhglug/JD2jqX5Bsqg4lVGpV3HCUSVz3NdUFyAxn8IkLNCPuofhIS1/1avRGUA==
X-Received: by 2002:adf:dd47:: with SMTP id u7mr33765469wrm.13.1617105576189;
        Tue, 30 Mar 2021 04:59:36 -0700 (PDT)
Received: from [192.168.1.101] ([37.167.251.74])
        by smtp.gmail.com with ESMTPSA id x11sm4424978wme.9.2021.03.30.04.59.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Mar 2021 04:59:35 -0700 (PDT)
Subject: Re: [PATCH net-next v3 7/7] mld: add mc_lock for protecting
 per-interface mld data
To:     Taehee Yoo <ap420073@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     jwi@linux.ibm.com, kgraul@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        linux-s390@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org
References: <20210325161657.10517-1-ap420073@gmail.com>
 <20210325161657.10517-8-ap420073@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <fd460c2b-b974-db00-5097-4af08f12c670@gmail.com>
Date:   Tue, 30 Mar 2021 13:59:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210325161657.10517-8-ap420073@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/25/21 5:16 PM, Taehee Yoo wrote:
> The purpose of this lock is to avoid a bottleneck in the query/report
> event handler logic.
> 
> By previous patches, almost all mld data is protected by RTNL.
> So, the query and report event handler, which is data path logic
> acquires RTNL too. Therefore if a lot of query and report events
> are received, it uses RTNL for a long time.
> So it makes the control-plane bottleneck because of using RTNL.
> In order to avoid this bottleneck, mc_lock is added.
> 
> mc_lock protect only per-interface mld data and per-interface mld
> data is used in the query/report event handler logic.
> So, no longer rtnl_lock is needed in the query/report event handler logic.
> Therefore bottleneck will be disappeared by mc_lock.
> 

What testsuite have you run exactly to validate this monster patch ?

Have you used CONFIG_LOCKDEP=y / CONFIG_DEBUG_ATOMIC_SLEEP=y ?

> Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

[...]

>  /*
> - *	device multicast group del
> + * device multicast group del
>   */
>  int __ipv6_dev_mc_dec(struct inet6_dev *idev, const struct in6_addr *addr)
>  {
> @@ -943,8 +967,9 @@ int __ipv6_dev_mc_dec(struct inet6_dev *idev, const struct in6_addr *addr)
>  
>  	ASSERT_RTNL();
>  
> +	mutex_lock(&idev->mc_lock);
>  	for (map = &idev->mc_list;
> -	     (ma = rtnl_dereference(*map));
> +	     (ma = mc_dereference(*map, idev));
>  	     map = &ma->next) {
>  		if (ipv6_addr_equal(&ma->mca_addr, addr)) {
>  			if (--ma->mca_users == 0) {

This can be called with rcu_bh held, thus :

BUG: sleeping function called from invalid context at kernel/locking/mutex.c:928
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 4624, name: kworker/1:2
4 locks held by kworker/1:2/4624:
 #0: ffff88802135d138 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88802135d138 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88802135d138 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88802135d138 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88802135d138 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88802135d138 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc90009adfda8 ((addr_chk_work).work){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
 #2: ffffffff8d66d328 (rtnl_mutex){+.+.}-{3:3}, at: addrconf_verify_work+0xa/0x20 net/ipv6/addrconf.c:4572
 #3: ffffffff8bf74300 (rcu_read_lock_bh){....}-{1:2}, at: addrconf_verify_rtnl+0x2b/0x1150 net/ipv6/addrconf.c:4459
Preemption disabled at:
[<ffffffff87b39f41>] local_bh_disable include/linux/bottom_half.h:19 [inline]
[<ffffffff87b39f41>] rcu_read_lock_bh include/linux/rcupdate.h:727 [inline]
[<ffffffff87b39f41>] addrconf_verify_rtnl+0x41/0x1150 net/ipv6/addrconf.c:4461
CPU: 1 PID: 4624 Comm: kworker/1:2 Not tainted 5.12.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: ipv6_addrconf addrconf_verify_work
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 ___might_sleep.cold+0x1f1/0x237 kernel/sched/core.c:8328
 __mutex_lock_common kernel/locking/mutex.c:928 [inline]
 __mutex_lock+0xa9/0x1120 kernel/locking/mutex.c:1096
 __ipv6_dev_mc_dec+0x5f/0x340 net/ipv6/mcast.c:970
 addrconf_leave_solict net/ipv6/addrconf.c:2182 [inline]
 addrconf_leave_solict net/ipv6/addrconf.c:2174 [inline]
 __ipv6_ifa_notify+0x5b6/0xa90 net/ipv6/addrconf.c:6077
 ipv6_ifa_notify net/ipv6/addrconf.c:6100 [inline]
 ipv6_del_addr+0x463/0xae0 net/ipv6/addrconf.c:1294
 addrconf_verify_rtnl+0xd59/0x1150 net/ipv6/addrconf.c:4488
 addrconf_verify_work+0xf/0x20 net/ipv6/addrconf.c:4573
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
