Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730D73D575E
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 12:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232624AbhGZJm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 05:42:57 -0400
Received: from relay.sw.ru ([185.231.240.75]:53124 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232450AbhGZJmy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 05:42:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=LeiBgMdLdAKoG5QoVqntV3PGe2GjN3JZXuy4s2QzASE=; b=NsVv1g7zmwRc0wDYF
        6w5B9v1wRacnAXFL1RjML0me3vGK20qWYKR5lDfma0Ca7IoqXgBOJI5X9sOZYtc3HDAjwbkeLmPWf
        9uFmU+GVXjeVrPqrJCt47Gs1DocySVgdsCRCh5TyuKre81uWeIKuJG22z5aqqSe7WSJyzEOGHBuiI
        =;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1m7xlV-005FNh-By; Mon, 26 Jul 2021 13:23:17 +0300
Subject: Re: [PATCH v5 02/16] memcg: enable accounting for IP address and
 routing-related objects
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Roman Gushchin <guro@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <CALvZod66KF-8xKB1dyY2twizDE=svE8iXT_nqvsrfWg1a92f4A@mail.gmail.com>
 <cover.1626688654.git.vvs@virtuozzo.com>
 <9123bca3-23bb-1361-c48f-e468c81ad4f6@virtuozzo.com>
 <CALvZod4HCRHpPJtGE=8tU1Yj=WsWHpocP0q0JU3r4F2fMmAw5w@mail.gmail.com>
From:   Vasily Averin <vvs@virtuozzo.com>
Message-ID: <08151b5b-f84a-aa32-82a6-0b6e94e63338@virtuozzo.com>
Date:   Mon, 26 Jul 2021 13:23:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CALvZod4HCRHpPJtGE=8tU1Yj=WsWHpocP0q0JU3r4F2fMmAw5w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/20/21 10:26 PM, Shakeel Butt wrote:
> On Mon, Jul 19, 2021 at 3:44 AM Vasily Averin <vvs@virtuozzo.com> wrote:
>>
>> An netadmin inside container can use 'ip a a' and 'ip r a'
>> to assign a large number of ipv4/ipv6 addresses and routing entries
>> and force kernel to allocate megabytes of unaccounted memory
>> for long-lived per-netdevice related kernel objects:
>> 'struct in_ifaddr', 'struct inet6_ifaddr', 'struct fib6_node',
>> 'struct rt6_info', 'struct fib_rules' and ip_fib caches.
>>
>> These objects can be manually removed, though usually they lives
>> in memory till destroy of its net namespace.
>>
>> It makes sense to account for them to restrict the host's memory
>> consumption from inside the memcg-limited container.
>>
>> One of such objects is the 'struct fib6_node' mostly allocated in
>> net/ipv6/route.c::__ip6_ins_rt() inside the lock_bh()/unlock_bh() section:
>>
>>  write_lock_bh(&table->tb6_lock);
>>  err = fib6_add(&table->tb6_root, rt, info, mxc);
>>  write_unlock_bh(&table->tb6_lock);
>>
>> In this case it is not enough to simply add SLAB_ACCOUNT to corresponding
>> kmem cache. The proper memory cgroup still cannot be found due to the
>> incorrect 'in_interrupt()' check used in memcg_kmem_bypass().
>>
>> Obsoleted in_interrupt() does not describe real execution context properly.
>> From include/linux/preempt.h:
>>
>>  The following macros are deprecated and should not be used in new code:
>>  in_interrupt() - We're in NMI,IRQ,SoftIRQ context or have BH disabled
>>
>> To verify the current execution context new macro should be used instead:
>>  in_task()      - We're in task context
>>
>> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
>> ---
>>  mm/memcontrol.c      | 2 +-
>>  net/core/fib_rules.c | 4 ++--
>>  net/ipv4/devinet.c   | 2 +-
>>  net/ipv4/fib_trie.c  | 4 ++--
>>  net/ipv6/addrconf.c  | 2 +-
>>  net/ipv6/ip6_fib.c   | 4 ++--
>>  net/ipv6/route.c     | 2 +-
>>  7 files changed, 10 insertions(+), 10 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index ae1f5d0..1bbf239 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -968,7 +968,7 @@ static __always_inline bool memcg_kmem_bypass(void)
>>                 return false;
>>
>>         /* Memcg to charge can't be determined. */
>> -       if (in_interrupt() || !current->mm || (current->flags & PF_KTHREAD))
>> +       if (!in_task() || !current->mm || (current->flags & PF_KTHREAD))
>>                 return true;
>>
>>         return false;
> 
> Can you please also change in_interrupt() in active_memcg() as well?
> There are other unrelated in_interrupt() in that file but the one in
> active_memcg() should be coupled with this change.

Could you please elaborate?
From my point of view active_memcg is paired with set_active_memcg() and is not related to this case.
active_memcg uses memcg that was set by set_active_memcg(), either from int_active_memcg per-cpu pointer
or from current->active_memcg pointer.
I'm agree, it in case of disabled BH it is incorrect to use int_active_memcg, 
we still can use current->active_memcg. However it isn't a problem, 
memcg will be properly provided in both cases.

I think it's better to fix set_active_memcg/active_memcg by separate patch.

Am I missed something perhaps?

Thank you,
	Vasily Averin
