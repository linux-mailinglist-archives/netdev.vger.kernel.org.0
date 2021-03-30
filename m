Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F0534EB69
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 17:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbhC3PBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 11:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbhC3PBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 11:01:19 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC447C061574;
        Tue, 30 Mar 2021 08:01:18 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id x26so12380967pfn.0;
        Tue, 30 Mar 2021 08:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aIIhZH7MEe4emdWSnxRXrt2i6gVhMrPoGfFDilIz73w=;
        b=desaCWlpymXZF2C2RzEsDfZ2b7i0/DZxG1Xg8u0WwaQ7wG19wt/J3/tljLcHcFkpuC
         Q+kh6ErgCJYsAtD+7RM9+daiMxg56uSvybIonRhORb5A37aw47qxIaacMab44wrgG5h/
         c7mVRuMWgT46WSToNiizqAg1z9+umIqFopcZh+NUnaEJerpi7OCYU3Uc5zxZBPZFiG+A
         GbJTTcfjOwuRY11sZkmSdczUMG9tiVBK9Lg8BE/sbBCM+WsI7lFf4fBGGCqk9BupEglw
         wCThkRzqR3e22mIqkZUwFKKs1vtNRt+NwT08Be2FFuze3nzs6MnxYw/1GolhC1AZOYW1
         G+vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aIIhZH7MEe4emdWSnxRXrt2i6gVhMrPoGfFDilIz73w=;
        b=fZGjcfc92cQRVjEaZClQblV8v+v0A+Ml7McKF/KRmmv3LfaWcQmBfhvYxaSN3PVrtf
         eXMIKVJgFjuitt4IiGzrNscKSaXur7HRPIGkKjmSFarH2tREjlahwtkMZMV7ZxB9RKgV
         lrR/7fVUk8DYxi6BgQZ7ovih31dmulP3RWrffv2umKl8oy2YF9aIuUIg/JXGl0rGmW6E
         bZlEFkjUEW5olmqjRU4Kn47l3/JbObmTTIE+y19/V6aGDdkzkj/5ZJSN/eFNV7jGZwxB
         P8auMH1C8eLLXwnVD3HHkPb941q2pc8g87WHaJSets0YnebSYYsJukUfcnpAAQG22Jw5
         NY3Q==
X-Gm-Message-State: AOAM533GXqvbsL8Yn3VfgxSRoZeUQ6QvtEDBw1rYkD5jf3mGC6devUPf
        JxsK/2rl9MijQD2I9JNzia8=
X-Google-Smtp-Source: ABdhPJwV3sCo5WWG4iadqwdExPE23HtvV5WWaQLhxi1uqK2e1hLcxg/G93jwGe37N0QaxEy0ryL//w==
X-Received: by 2002:a62:687:0:b029:1fb:2382:57b0 with SMTP id 129-20020a6206870000b02901fb238257b0mr1243247pfg.10.1617116478374;
        Tue, 30 Mar 2021 08:01:18 -0700 (PDT)
Received: from [192.168.0.4] ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id 22sm3116399pjl.31.2021.03.30.08.01.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Mar 2021 08:01:17 -0700 (PDT)
Subject: Re: [PATCH net-next v3 7/7] mld: add mc_lock for protecting
 per-interface mld data
To:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     jwi@linux.ibm.com, kgraul@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        linux-s390@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org
References: <20210325161657.10517-1-ap420073@gmail.com>
 <20210325161657.10517-8-ap420073@gmail.com>
 <fd460c2b-b974-db00-5097-4af08f12c670@gmail.com>
 <d3e101bb-14d2-4d91-6bc1-fbb766d69422@gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Message-ID: <08f0a57c-8cad-2f62-0ba2-1bc6c6caad58@gmail.com>
Date:   Wed, 31 Mar 2021 00:01:12 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d3e101bb-14d2-4d91-6bc1-fbb766d69422@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/30/21 9:24 PM, Eric Dumazet wrote:
 >
 >
 > On 3/30/21 1:59 PM, Eric Dumazet wrote:
 >>
 >>
 >> On 3/25/21 5:16 PM, Taehee Yoo wrote:
 >>> The purpose of this lock is to avoid a bottleneck in the query/report
 >>> event handler logic.
 >>>
 >>> By previous patches, almost all mld data is protected by RTNL.
 >>> So, the query and report event handler, which is data path logic
 >>> acquires RTNL too. Therefore if a lot of query and report events
 >>> are received, it uses RTNL for a long time.
 >>> So it makes the control-plane bottleneck because of using RTNL.
 >>> In order to avoid this bottleneck, mc_lock is added.
 >>>
 >>> mc_lock protect only per-interface mld data and per-interface mld
 >>> data is used in the query/report event handler logic.
 >>> So, no longer rtnl_lock is needed in the query/report event handler 
logic.
 >>> Therefore bottleneck will be disappeared by mc_lock.
 >>>
 >>
 >> What testsuite have you run exactly to validate this monster patch ?
 >>

I've been using an application, which calls setsockopt() with the below 
options.
IPV6_ADD_MEMBERSHIP
IPV6_DROP_MEMBERSHIP
MCAST_JOIN_SOURCE_GROUP
MCAST_LEAVE_SOURCE_GROUP
MCAST_BLOCK_SOURCE
MCAST_UNBLOCK_SOURCE
MCAST_MSFILTER
And checks out  /proc/net/mcfilter6 and /proc/net/igmp6.

 >> Have you used CONFIG_LOCKDEP=y / CONFIG_DEBUG_ATOMIC_SLEEP=y ?
 >>

Yes, I'm using both configs.

 >>> Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
 >>> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
 >>
 >> [...]
 >>
 >>>   /*
 >>> - *	device multicast group del
 >>> + * device multicast group del
 >>>    */
 >>>   int __ipv6_dev_mc_dec(struct inet6_dev *idev, const struct 
in6_addr *addr)
 >>>   {
 >>> @@ -943,8 +967,9 @@ int __ipv6_dev_mc_dec(struct inet6_dev *idev, 
const struct in6_addr *addr)
 >>>
 >>>   	ASSERT_RTNL();
 >>>
 >>> +	mutex_lock(&idev->mc_lock);
 >>>   	for (map = &idev->mc_list;
 >>> -	     (ma = rtnl_dereference(*map));
 >>> +	     (ma = mc_dereference(*map, idev));
 >>>   	     map = &ma->next) {
 >>>   		if (ipv6_addr_equal(&ma->mca_addr, addr)) {
 >>>   			if (--ma->mca_users == 0) {
 >>
 >> This can be called with rcu_bh held, thus :
 >>
 >> BUG: sleeping function called from invalid context at 
kernel/locking/mutex.c:928
 >> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 4624, name: 
kworker/1:2
 >> 4 locks held by kworker/1:2/4624:
 >>   #0: ffff88802135d138 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, 
at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 >>   #0: ffff88802135d138 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, 
at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 >>   #0: ffff88802135d138 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, 
at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 >>   #0: ffff88802135d138 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, 
at: set_work_data kernel/workqueue.c:616 [inline]
 >>   #0: ffff88802135d138 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, 
at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 >>   #0: ffff88802135d138 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, 
at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 >>   #1: ffffc90009adfda8 ((addr_chk_work).work){+.+.}-{0:0}, at: 
process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
 >>   #2: ffffffff8d66d328 (rtnl_mutex){+.+.}-{3:3}, at: 
addrconf_verify_work+0xa/0x20 net/ipv6/addrconf.c:4572
 >>   #3: ffffffff8bf74300 (rcu_read_lock_bh){....}-{1:2}, at: 
addrconf_verify_rtnl+0x2b/0x1150 net/ipv6/addrconf.c:4459
 >> Preemption disabled at:
 >> [<ffffffff87b39f41>] local_bh_disable include/linux/bottom_half.h:19 
[inline]
 >> [<ffffffff87b39f41>] rcu_read_lock_bh include/linux/rcupdate.h:727 
[inline]
 >> [<ffffffff87b39f41>] addrconf_verify_rtnl+0x41/0x1150 
net/ipv6/addrconf.c:4461
 >> CPU: 1 PID: 4624 Comm: kworker/1:2 Not tainted 5.12.0-rc4-syzkaller #0
 >> Hardware name: Google Google Compute Engine/Google Compute Engine, 
BIOS Google 01/01/2011
 >> Workqueue: ipv6_addrconf addrconf_verify_work
 >> Call Trace:
 >>   __dump_stack lib/dump_stack.c:79 [inline]
 >>   dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 >>   ___might_sleep.cold+0x1f1/0x237 kernel/sched/core.c:8328
 >>   __mutex_lock_common kernel/locking/mutex.c:928 [inline]
 >>   __mutex_lock+0xa9/0x1120 kernel/locking/mutex.c:1096
 >>   __ipv6_dev_mc_dec+0x5f/0x340 net/ipv6/mcast.c:970
 >>   addrconf_leave_solict net/ipv6/addrconf.c:2182 [inline]
 >>   addrconf_leave_solict net/ipv6/addrconf.c:2174 [inline]
 >>   __ipv6_ifa_notify+0x5b6/0xa90 net/ipv6/addrconf.c:6077
 >>   ipv6_ifa_notify net/ipv6/addrconf.c:6100 [inline]
 >>   ipv6_del_addr+0x463/0xae0 net/ipv6/addrconf.c:1294
 >>   addrconf_verify_rtnl+0xd59/0x1150 net/ipv6/addrconf.c:4488
 >>   addrconf_verify_work+0xf/0x20 net/ipv6/addrconf.c:4573
 >>   process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
 >>   worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 >>   kthread+0x3b1/0x4a0 kernel/kthread.c:292
 >>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
 >>
 >
 > I will test this fix:

Thanks a lot!

 >
 > diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
 > index 
120073ffb666b18678e3145d91dac59fa865a592..8f3883f4cb4a15a0749b8f0fe00061e483ea26ca 
100644
 > --- a/net/ipv6/addrconf.c
 > +++ b/net/ipv6/addrconf.c
 > @@ -4485,7 +4485,9 @@ static void addrconf_verify_rtnl(void)
 >                              age >= ifp->valid_lft) {
 >                                  spin_unlock(&ifp->lock);
 >                                  in6_ifa_hold(ifp);
 > +                               rcu_read_unlock_bh();
 >                                  ipv6_del_addr(ifp);
 > +                               rcu_read_lock_bh();
 >                                  goto restart;
 >                          } else if (ifp->prefered_lft == 
INFINITY_LIFE_TIME) {
 >                                  spin_unlock(&ifp->lock);
 >
