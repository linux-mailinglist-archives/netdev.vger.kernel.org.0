Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92AC84A5149
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 22:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351142AbiAaVSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 16:18:05 -0500
Received: from www62.your-server.de ([213.133.104.62]:57804 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241083AbiAaVSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 16:18:02 -0500
Received: from [78.46.152.42] (helo=sslproxy04.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nEe3e-0008dE-5l; Mon, 31 Jan 2022 22:17:54 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nEe3d-000FrK-SR; Mon, 31 Jan 2022 22:17:53 +0100
Subject: Re: [PATCH net-next 4/4] net, neigh: Add NTF_MANAGED flag for managed
 neighbor entries
To:     Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     roopa@nvidia.com, dsahern@kernel.org, m@lambda.lt,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20211011121238.25542-1-daniel@iogearbox.net>
 <20211011121238.25542-5-daniel@iogearbox.net>
 <949e2f20-5eef-ac9b-2583-f3937cf032d1@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d431eb12-0625-a9c4-802d-dd7fa7719662@iogearbox.net>
Date:   Mon, 31 Jan 2022 22:17:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <949e2f20-5eef-ac9b-2583-f3937cf032d1@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26439/Mon Jan 31 10:24:40 2022)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/31/22 9:43 PM, Eric Dumazet wrote:
[...]
>> @@ -1539,6 +1564,20 @@ int neigh_direct_output(struct neighbour *neigh, struct sk_buff *skb)
>>   }
>>   EXPORT_SYMBOL(neigh_direct_output);
>> +static void neigh_managed_work(struct work_struct *work)
>> +{
>> +    struct neigh_table *tbl = container_of(work, struct neigh_table,
>> +                           managed_work.work);
>> +    struct neighbour *neigh;
>> +
>> +    write_lock_bh(&tbl->lock);
>> +    list_for_each_entry(neigh, &tbl->managed_list, managed_list)
>> +        neigh_event_send(neigh, NULL);
> 
> neigh_event_send() can need to lock tbl->lock, leading to a deadlock ?

Thanks for forwarding the syzbot report! I'll take a look.

> __raw_write_lock_bh include/linux/rwlock_api_smp.h:202 [inline]
>   _raw_write_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:334
>   ___neigh_create+0x9e1/0x2990 net/core/neighbour.c:652
>   ip6_finish_output2+0x1070/0x14f0 net/ipv6/ip6_output.c:123
>   __ip6_finish_output net/ipv6/ip6_output.c:191 [inline]
>   __ip6_finish_output+0x61e/0xe90 net/ipv6/ip6_output.c:170
>   ip6_finish_output+0x32/0x200 net/ipv6/ip6_output.c:201
>   NF_HOOK_COND include/linux/netfilter.h:296 [inline]
>   ip6_output+0x1e4/0x530 net/ipv6/ip6_output.c:224
>   dst_output include/net/dst.h:451 [inline]
>   NF_HOOK include/linux/netfilter.h:307 [inline]
>   ndisc_send_skb+0xa99/0x17f0 net/ipv6/ndisc.c:508
>   ndisc_send_ns+0x3a9/0x840 net/ipv6/ndisc.c:650
>   ndisc_solicit+0x2cd/0x4f0 net/ipv6/ndisc.c:742
>   neigh_probe+0xc2/0x110 net/core/neighbour.c:1040
>   __neigh_event_send+0x37d/0x1570 net/core/neighbour.c:1201
>   neigh_event_send include/net/neighbour.h:470 [inline]
>   neigh_managed_work+0x162/0x250 net/core/neighbour.c:1574
>   process_one_work+0x9ac/0x1650 kernel/workqueue.c:2307
>   worker_thread+0x657/0x1110 kernel/workqueue.c:2454
>   kthread+0x2e9/0x3a0 kernel/kthread.c:377
>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> 
>> +    queue_delayed_work(system_power_efficient_wq, &tbl->managed_work,
>> +               NEIGH_VAR(&tbl->parms, DELAY_PROBE_TIME));
>> +    write_unlock_bh(&tbl->lock);
>> +}
>> +
>>   static void neigh_proxy_process(struct timer_list *t)
>>   {
>>       struct neigh_table *tbl = from_timer(tbl, t, proxy_timer);
>> @@ -1685,6 +1724,8 @@ void neigh_table_init(int index, struct neigh_table *tbl)
>>       INIT_LIST_HEAD(&tbl->parms_list);
>>       INIT_LIST_HEAD(&tbl->gc_list);
>> +    INIT_LIST_HEAD(&tbl->managed_list);
>> +
