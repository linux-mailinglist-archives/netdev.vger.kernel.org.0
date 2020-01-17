Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B866C140429
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 07:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgAQGyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 01:54:13 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9648 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726726AbgAQGyM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jan 2020 01:54:12 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 5BF37D7B6E95EAD49046;
        Fri, 17 Jan 2020 14:54:10 +0800 (CST)
Received: from [127.0.0.1] (10.74.221.148) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Fri, 17 Jan 2020
 14:54:04 +0800
Subject: Re: [PATCH] net: optimize cmpxchg in ip_idents_reserve
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>
References: <1579058620-26684-1-git-send-email-zhangshaokun@hisilicon.com>
 <20200116.042722.153124126288244814.davem@davemloft.net>
 <930faaff-4d18-452d-2e44-ef05b65dc858@gmail.com>
 <1b3aaddf-22f5-1846-90f1-42e68583c1e4@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jinyuqi@huawei.com>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <edumazet@google.com>,
        <guoyang2@huawei.com>, Will Deacon <will@kernel.org>
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <430496fc-9f26-8cb4-91d8-505fda9af230@hisilicon.com>
Date:   Fri, 17 Jan 2020 14:54:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.1.1
MIME-Version: 1.0
In-Reply-To: <1b3aaddf-22f5-1846-90f1-42e68583c1e4@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.221.148]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Cc Will Deacon,

On 2020/1/16 23:19, Eric Dumazet wrote:
> 
> 
> On 1/16/20 7:12 AM, Eric Dumazet wrote:
>>
>>
>> On 1/16/20 4:27 AM, David Miller wrote:
>>> From: Shaokun Zhang <zhangshaokun@hisilicon.com>
>>> Date: Wed, 15 Jan 2020 11:23:40 +0800
>>>
>>>> From: Yuqi Jin <jinyuqi@huawei.com>
>>>>
>>>> atomic_try_cmpxchg is called instead of atomic_cmpxchg that can reduce
>>>> the access number of the global variable @p_id in the loop. Let's
>>>> optimize it for performance.
>>>>
>>>> Cc: "David S. Miller" <davem@davemloft.net>
>>>> Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
>>>> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
>>>> Cc: Eric Dumazet <edumazet@google.com>
>>>> Cc: Yang Guo <guoyang2@huawei.com>
>>>> Signed-off-by: Yuqi Jin <jinyuqi@huawei.com>
>>>> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
>>>
>>> I doubt this makes any measurable improvement in performance.
>>>
>>> If you can document a specific measurable improvement under
>>> a useful set of circumstances for real usage, then put those
>>> details into the commit message and resubmit.
>>>
>>> Otherwise, I'm not applying this, sorry.
>>>
>>
>>
>> Real difference that could be made here is to 
>> only use this cmpxchg() dance for CONFIG_UBSAN
>>
>> When CONFIG_UBSAN is not set, atomic_add_return() is just fine.
>>
>> (Supposedly UBSAN should not warn about that either, but this depends on compiler version)
> 
> I will test something like :
> 
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index 2010888e68ca96ae880481973a6d808d6c5612c5..e2fa972f5c78f2aefc801db6a45b2a81141c3028 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -495,11 +495,15 @@ u32 ip_idents_reserve(u32 hash, int segs)
>         if (old != now && cmpxchg(p_tstamp, old, now) == old)
>                 delta = prandom_u32_max(now - old);
>  
> -       /* Do not use atomic_add_return() as it makes UBSAN unhappy */
> +#ifdef CONFIG_UBSAN

I appreciate Eric's idea.

> +       /* Do not use atomic_add_return() as it makes old UBSAN versions unhappy */
>         do {
>                 old = (u32)atomic_read(p_id);
>                 new = old + delta + segs;
>         } while (atomic_cmpxchg(p_id, old, new) != old);

But about this, I still think that we can try to use atomic_try_cmpxchg instead
of atomic_cmpxchg, like refcount_add_not_zero in include/linux/refcount.h

I abstract the model, as follow:
while (get_cycles() <= (time_temp + t_cnt))
{
	do{
		old_temp = wk_in->num.counter;
		oldt = atomic64_cmpxchg(&wk_in->num, old_temp, old_temp+1);
	}while(oldt != old_temp);

	myndelay(delay_o);
	w_cnt+=1;
}

val = atomic64_read(&wk_in->num);
while (get_cycles() <= (time_temp + t_cnt))
{
	do{
		new_val = val + 1;
			
	}while(!atomic64_try_cmpxchg(&wk_in->num, &val, new_val));

	myndelay(delay_o);
	w_cnt += 1;
}

If we take the access global variable out of loop, the performance become better
on both x86 and arm64, as follow:
Kunpeng920: 24 cores call it and the successful operations per second
atomic64_read in loop 	   atomic64_read out of the loop
6291034	                   8751962

Intel 6248: 20 cores call it and the successful operations per second
atomic64_read in loop 	   atomic64_read out of the loop
8934792	                   9978998

So how about this? ;-)

                delta = prandom_u32_max(now - old);

+#ifdef CONFIG_UBSAN
        /* Do not use atomic_add_return() as it makes UBSAN unhappy */
+       old = (u32)atomic_read(p_id);
        do {
-               old = (u32)atomic_read(p_id);
                new = old + delta + segs;
-       } while (atomic_cmpxchg(p_id, old, new) != old);
+       } while (!atomic_try_cmpxchg(p_id, &old, new));
+#else
+       new = atomic_add_return(segs + delta, p_id);
+#endif

Thanks,
Shaokun


> +#else
> +       new = atomic_add_return(segs + delta, p_id);
> +#endif
>  
>         return new - segs;
>  }
> 
> 
> .
> 

