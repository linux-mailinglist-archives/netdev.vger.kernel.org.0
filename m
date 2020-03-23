Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1435E18F02F
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 08:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbgCWHWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 03:22:04 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12176 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727164AbgCWHWD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 03:22:03 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 24D25A297C5B469D6335;
        Mon, 23 Mar 2020 15:21:52 +0800 (CST)
Received: from [127.0.0.1] (10.173.223.234) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Mon, 23 Mar 2020
 15:21:46 +0800
Subject: Re: [PATCH v2] xfrm: policy: Fix doulbe free in xfrm_policy_timer
To:     Timo Teras <timo.teras@iki.fi>
References: <20200318034839.57996-1-yuehaibing@huawei.com>
 <20200323014155.56376-1-yuehaibing@huawei.com>
 <20200323085311.35aefe10@vostro.wlan>
CC:     <steffen.klassert@secunet.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <832e03ea-2511-eb7f-49d1-3cda6c9e6d18@huawei.com>
Date:   Mon, 23 Mar 2020 15:21:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20200323085311.35aefe10@vostro.wlan>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.223.234]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/3/23 14:53, Timo Teras wrote:
> Hi
> 
> On Mon, 23 Mar 2020 09:41:55 +0800
> YueHaibing <yuehaibing@huawei.com> wrote:
> 
>> After xfrm_add_policy add a policy, its ref is 2, then
>>
>>                              xfrm_policy_timer
>>                                read_lock
>>                                xp->walk.dead is 0
>>                                ....
>>                                mod_timer()
>> xfrm_policy_kill
>>   policy->walk.dead = 1
>>   ....
>>   del_timer(&policy->timer)
>>     xfrm_pol_put //ref is 1
>>   xfrm_pol_put  //ref is 0
>>     xfrm_policy_destroy
>>       call_rcu
>>                                  xfrm_pol_hold //ref is 1
>>                                read_unlock
>>                                xfrm_pol_put //ref is 0
>>                                  xfrm_policy_destroy
>>                                   call_rcu
>>
>> xfrm_policy_destroy is called twice, which may leads to
>> double free.
> 
> I believe the timer changes were added later in commit e7d8f6cb2f which
> added holding a reference when timer is running. I think it fails to
> properly account for concurrently running timer in xfrm_policy_kill().

commit e7d8f6cb2f hold a reference when &pq->hold_timer is armed,
in my case, it's policy->timer, and hold_timer is not armed.
> 
> The time when commit ea2dea9dacc2 was done this was not the case.
> 
> I think it would be preferable if the concurrency issue could be solved
> without additional locking.
> 
>> Call Trace:
>> RIP: 0010:refcount_warn_saturate+0x161/0x210
>> ...
>>  xfrm_policy_timer+0x522/0x600
>>  call_timer_fn+0x1b3/0x5e0
>>  ? __xfrm_decode_session+0x2990/0x2990
>>  ? msleep+0xb0/0xb0
>>  ? _raw_spin_unlock_irq+0x24/0x40
>>  ? __xfrm_decode_session+0x2990/0x2990
>>  ? __xfrm_decode_session+0x2990/0x2990
>>  run_timer_softirq+0x5c5/0x10e0
>>
>> Fix this by use write_lock_bh in xfrm_policy_kill.
>>
>> Fixes: ea2dea9dacc2 ("xfrm: remove policy lock when accessing
>> policy->walk.dead") Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> 
> Should be instead:
> Fixes: e7d8f6cb2f ("xfrm: Add refcount handling to queued policies")
> 
>> ---
>> v2:  Fix typo 'write_lock_bh'--> 'write_unlock_bh' while unlocking
>> ---
>>  net/xfrm/xfrm_policy.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
>> index dbda08ec566e..ae0689174bbf 100644
>> --- a/net/xfrm/xfrm_policy.c
>> +++ b/net/xfrm/xfrm_policy.c
>> @@ -434,6 +434,7 @@ EXPORT_SYMBOL(xfrm_policy_destroy);
>>  
>>  static void xfrm_policy_kill(struct xfrm_policy *policy)
>>  {
>> +	write_lock_bh(&policy->lock);
>>  	policy->walk.dead = 1;
>>  
>>  	atomic_inc(&policy->genid);
>> @@ -445,6 +446,7 @@ static void xfrm_policy_kill(struct xfrm_policy
>> *policy) if (del_timer(&policy->timer))
>>  		xfrm_pol_put(policy);
>>  
>> +	write_unlock_bh(&policy->lock);
>>  	xfrm_pol_put(policy);
>>  }
>>  
> 
> 
> .
> 

