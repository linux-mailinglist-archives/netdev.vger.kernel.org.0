Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90DE71C856C
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 11:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgEGJMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 05:12:35 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:60428 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725848AbgEGJMe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 05:12:34 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A8AD12FAB35445FAE711;
        Thu,  7 May 2020 17:12:31 +0800 (CST)
Received: from [127.0.0.1] (10.74.221.148) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Thu, 7 May 2020
 17:12:23 +0800
Subject: Re: [PATCH] net: optimize cmpxchg in ip_idents_reserve
To:     Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <20200116.042722.153124126288244814.davem@davemloft.net>
 <930faaff-4d18-452d-2e44-ef05b65dc858@gmail.com>
 <1b3aaddf-22f5-1846-90f1-42e68583c1e4@gmail.com>
 <430496fc-9f26-8cb4-91d8-505fda9af230@hisilicon.com>
 <20200117123253.GC14879@hirez.programming.kicks-ass.net>
 <7e6c6202-24bb-a532-adde-d53dd6fb14c3@gmail.com>
 <20200117180324.GA2623847@rani.riverdale.lan>
 <94573cea-a833-9b48-6581-8cc5cdd19b89@gmail.com>
 <20200117183800.GA2649345@rani.riverdale.lan>
 <45224c36-9941-aae5-aca4-e2c8e3723355@gmail.com>
 <20200120081858.GI14879@hirez.programming.kicks-ass.net>
CC:     Arvind Sankar <nivedita@alum.mit.edu>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jinyuqi@huawei.com>,
        <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>,
        <edumazet@google.com>, <guoyang2@huawei.com>,
        Will Deacon <will@kernel.org>
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <39ddacf9-adbe-c3f5-45a8-9c5280ef11bb@hisilicon.com>
Date:   Thu, 7 May 2020 17:12:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.1.1
MIME-Version: 1.0
In-Reply-To: <20200120081858.GI14879@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.74.221.148]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Peter/Eric,

Shall we use atomic_add_return() unconditionally and add some comments? Or I missed
something.

Thanks,
Shaokun

On 2020/1/20 16:18, Peter Zijlstra wrote:
> On Fri, Jan 17, 2020 at 10:48:19AM -0800, Eric Dumazet wrote:
>>
>>
>> On 1/17/20 10:38 AM, Arvind Sankar wrote:
>>> On Fri, Jan 17, 2020 at 10:16:45AM -0800, Eric Dumazet wrote:
>>>> Wasńt it the case back in 2016 already for linux-4.8 ?
>>>>
>>>> What will prevent someone to send another report to netdev/lkml ?
>>>>
>>>>  -fno-strict-overflow support is not a prereq for CONFIG_UBSAN.
>>>>
>>>> Fact that we kept in lib/ubsan.c and lib/test_ubsan.c code for 
>>>> test_ubsan_add_overflow() and test_ubsan_sub_overflow() is disturbing.
>>>>
>>>
>>> No, it was bumped in 2018 in commit cafa0010cd51 ("Raise the minimum
>>> required gcc version to 4.6"). That raised it from 3.2 -> 4.6.
>>>
>>
>> This seems good to me, for gcc at least.
>>
>> Maybe it is time to enfore -fno-strict-overflow in KBUILD_CFLAGS 
>> instead of making it conditional.
> 
> IIRC there was a bug in UBSAN vs -fwrapv/-fno-strict-overflow that was
> only fixed in gcc-8 or 9 or so.
> 
> So while the -fwrapv/-fno-strict-overflow flag has been correctly
> supported since like forever, UBSAN was buggy until quite recent when
> used in conjustion with that flag.
> 
> .
> 

