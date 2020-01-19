Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C026141BBD
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 04:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgASDqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 22:46:36 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9662 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725980AbgASDqf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Jan 2020 22:46:35 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 1685B544BA0FA4AD7BD8;
        Sun, 19 Jan 2020 11:46:34 +0800 (CST)
Received: from [127.0.0.1] (10.74.221.148) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Sun, 19 Jan 2020
 11:46:23 +0800
Subject: Re: [PATCH] net: optimize cmpxchg in ip_idents_reserve
To:     Peter Zijlstra <peterz@infradead.org>
References: <1579058620-26684-1-git-send-email-zhangshaokun@hisilicon.com>
 <20200116.042722.153124126288244814.davem@davemloft.net>
 <930faaff-4d18-452d-2e44-ef05b65dc858@gmail.com>
 <1b3aaddf-22f5-1846-90f1-42e68583c1e4@gmail.com>
 <430496fc-9f26-8cb4-91d8-505fda9af230@hisilicon.com>
 <20200117123253.GC14879@hirez.programming.kicks-ass.net>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jinyuqi@huawei.com>,
        <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>,
        <edumazet@google.com>, <guoyang2@huawei.com>,
        Will Deacon <will@kernel.org>
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <5fd55696-e46c-4269-c106-79782efb0dd8@hisilicon.com>
Date:   Sun, 19 Jan 2020 11:46:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.1.1
MIME-Version: 1.0
In-Reply-To: <20200117123253.GC14879@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.221.148]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Peter,

On 2020/1/17 20:32, Peter Zijlstra wrote:
> On Fri, Jan 17, 2020 at 02:54:03PM +0800, Shaokun Zhang wrote:
>> So how about this? ;-)
>>
>>                 delta = prandom_u32_max(now - old);
>>
>> +#ifdef CONFIG_UBSAN
>>         /* Do not use atomic_add_return() as it makes UBSAN unhappy */
>> +       old = (u32)atomic_read(p_id);
>>         do {
>> -               old = (u32)atomic_read(p_id);
>>                 new = old + delta + segs;
>> -       } while (atomic_cmpxchg(p_id, old, new) != old);
>> +       } while (!atomic_try_cmpxchg(p_id, &old, new));
>> +#else
>> +       new = atomic_add_return(segs + delta, p_id);
>> +#endif
> 
> That's crazy, just accept that UBSAN is taking bonghits and ignore it.
> Use atomic_add_return() unconditionally.

We have used the atomic_add_return[1], but it makes the UBSAN unhappy followed
by the comment.
It seems that Eric also agreed to do it if some comments are added. I will do
it later.

Thanks,
Shaokun

[1] https://lkml.org/lkml/2019/7/26/217

> 
> .
> 

