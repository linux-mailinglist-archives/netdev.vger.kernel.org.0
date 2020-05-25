Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700601E0506
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 05:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388689AbgEYDFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 23:05:09 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4893 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388178AbgEYDFJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 May 2020 23:05:09 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id AA5478C8C87755055AB5;
        Mon, 25 May 2020 11:05:03 +0800 (CST)
Received: from [127.0.0.1] (10.166.215.154) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Mon, 25 May 2020
 11:04:59 +0800
Subject: Re: [PATCH v2] xfrm: policy: Fix xfrm policy match
To:     Xin Long <lucien.xin@gmail.com>
References: <20200421143149.45108-1-yuehaibing@huawei.com>
 <20200422125346.27756-1-yuehaibing@huawei.com>
 <0015ec4c-0e9c-a9d2-eb03-4d51c5fbbe86@huawei.com>
 <20200519085353.GE13121@gauss3.secunet.de>
 <CADvbK_eXW24SkuLUOKkcg4JPa8XLcWpp6RNCrQT+=okaWe+GDA@mail.gmail.com>
 <550a82f1-9cb3-2392-25c6-b2a84a00ca33@huawei.com>
 <CADvbK_cpXOxbWzHzonrzzrrb+Vh3q8NhXnapz0yc9h4H4gN02A@mail.gmail.com>
 <1c4c5d40-1e35-f9bb-3f17-01bb4675f3aa@huawei.com>
 <CADvbK_e8ixjGGHRK9A4HcXDGKYcNykneUHzHiE8sQ4ojDz+e-g@mail.gmail.com>
CC:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        davem <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        network dev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <f82b038f-776e-a87a-d46b-173d238531ba@huawei.com>
Date:   Mon, 25 May 2020 11:04:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <CADvbK_e8ixjGGHRK9A4HcXDGKYcNykneUHzHiE8sQ4ojDz+e-g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.166.215.154]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/5/23 17:02, Xin Long wrote:
> On Fri, May 22, 2020 at 8:39 PM Yuehaibing <yuehaibing@huawei.com> wrote:
>>
>> On 2020/5/22 13:49, Xin Long wrote:
>>> On Fri, May 22, 2020 at 9:45 AM Yuehaibing <yuehaibing@huawei.com> wrote:
>>>>
>>>> On 2020/5/21 14:49, Xin Long wrote:
>>>>> On Tue, May 19, 2020 at 4:53 PM Steffen Klassert
>>>>> <steffen.klassert@secunet.com> wrote:
>>>>>>
>>>>>> On Fri, May 15, 2020 at 04:39:57PM +0800, Yuehaibing wrote:
>>>>>>>
>>>>>>> Friendly ping...
>>>>>>>
>>>>>>> Any plan for this issue?
>>>>>>
>>>>>> There was still no consensus between you and Xin on how
>>>>>> to fix this issue. Once this happens, I consider applying
>>>>>> a fix.
>>>>>>
>>>>> Sorry, Yuehaibing, I can't really accept to do: (A->mark.m & A->mark.v)
>>>>> I'm thinking to change to:
>>>>>
>>>>>  static bool xfrm_policy_mark_match(struct xfrm_policy *policy,
>>>>>                                    struct xfrm_policy *pol)
>>>>>  {
>>>>> -       u32 mark = policy->mark.v & policy->mark.m;
>>>>> -
>>>>> -       if (policy->mark.v == pol->mark.v && policy->mark.m == pol->mark.m)
>>>>> -               return true;
>>>>> -
>>>>> -       if ((mark & pol->mark.m) == pol->mark.v &&
>>>>> -           policy->priority == pol->priority)
>>>>> +       if (policy->mark.v == pol->mark.v &&
>>>>> +           (policy->mark.m == pol->mark.m ||
>>>>> +            policy->priority == pol->priority))
>>>>>                 return true;
>>>>>
>>>>>         return false;
>>>>>
>>>>> which means we consider (the same value and mask) or
>>>>> (the same value and priority) as the same one. This will
>>>>> cover both problems.
>>>>
>>>>   policy A (mark.v = 0x1011, mark.m = 0x1011, priority = 1)
>>>>   policy B (mark.v = 0x1001, mark.m = 0x1001, priority = 1)
>>> I'd think these are 2 different policies.
>>>
>>>>
>>>>   when fl->flowi_mark == 0x12341011, in xfrm_policy_match() do check like this:
>>>>
>>>>         (fl->flowi_mark & pol->mark.m) != pol->mark.v
>>>>
>>>>         0x12341011 & 0x1011 == 0x00001011
>>>>         0x12341011 & 0x1001 == 0x00001001
>>>>
>>>>  This also match different policy depends on the order of policy inserting.
>>> Yes, this may happen when a user adds 2  policies like that.
>>> But I think this's a problem that the user doesn't configure it well,
>>> 'priority' should be set.
>>> and this can not be avoided, also such as:
>>>
>>>    policy A (mark.v = 0xff00, mark.m = 0x1000, priority = 1)
>>>    policy B (mark.v = 0x00ff, mark.m = 0x0011, priority = 1)
>>>
>>>    try with 0x12341011
>>>
>>> So just be it, let users decide.
>>
>> Ok, this make sense.
> Thanks Yuehaibing, it's good we're on the same page now.
> 
> Just realized the patch I created above won't work for the case:
> 
>   policy A (mark.v = 0x10, mark.m = 0, priority = 1)
>   policy B (mark.v = 0x1,  mark.m = 0, priority = 2)
>   policy C (mark.v = 0x10, mark.m = 0, priority = 2)
> 
> when policy C is being added, the warning still occurs.

Do you means this:

   policy A (mark.v = 0x10, mark.m = 0, priority = 1)
   policy B (mark.v = 0x10, mark.m = 1, priority = 2)
   policy C (mark.v = 0x10, mark.m = 0, priority = 2)

> 
> So I will just check value and priority:
> -       u32 mark = policy->mark.v & policy->mark.m;
> -
> -       if (policy->mark.v == pol->mark.v && policy->mark.m == pol->mark.m)
> -               return true;
> -
> -       if ((mark & pol->mark.m) == pol->mark.v &&
> +       if (policy->mark.v == pol->mark.v &&
>             policy->priority == pol->priority)
>                 return true;
> 
> This allows two policies like this exist:
> 
>   policy A (mark.v = 0x10, mark.m = 0, priority = 1)
>   policy C (mark.v = 0x10, mark.m = 0, priority = 2)
> 
> But I don't think it's a problem.

Agreed.
>
> .
> 

