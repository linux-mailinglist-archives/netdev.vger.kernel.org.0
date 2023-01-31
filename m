Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD4B8682BDE
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 12:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231861AbjAaLws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 06:52:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbjAaLwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 06:52:47 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3351C5FD7;
        Tue, 31 Jan 2023 03:52:44 -0800 (PST)
Received: from dggpeml500006.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4P5k1s4jznzfZ4D;
        Tue, 31 Jan 2023 19:52:33 +0800 (CST)
Received: from [10.174.178.240] (10.174.178.240) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Tue, 31 Jan 2023 19:52:41 +0800
Subject: Re: [Question] neighbor entry doesn't switch to the STALE state after
 the reachable timer expires
To:     Julian Anastasov <ja@ssi.bg>
CC:     Network Development <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Denis V. Lunev" <den@openvz.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>
References: <b1d8722e-5660-c38e-848f-3220d642889d@huawei.com>
 <99532c7f-161e-6d39-7680-ccc1f20349@ssi.bg>
 <9ebd0210-a4bb-afda-8a4d-5041b8395d78@huawei.com>
 <9ac5f4f6-36cc-cc6b-1220-f45db141656c@ssi.bg>
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
Message-ID: <1252089d-75db-a45c-d735-6883c772d95a@huawei.com>
Date:   Tue, 31 Jan 2023 19:52:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <9ac5f4f6-36cc-cc6b-1220-f45db141656c@ssi.bg>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.240]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500006.china.huawei.com (7.185.36.76)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/1/30 19:01, Julian Anastasov wrote:> On Mon, 30 Jan 2023, Zhang Changzhong wrote:
> 
>> On 2023/1/30 3:43, Julian Anastasov wrote:
>>>
>>>> Does anyone have a good idea to solve this problem? Or are there other scenarios that might cause
>>>> such a neighbor entry?
>>>
>>> 	Is the neigh entry modified somehow, for example,
>>> with 'arp -s' or 'ip neigh change' ? Or is bond0 reconfigured
>>> after initial setup? I mean, 4 days ago?>
>>
>> So far, we haven't found any user-space program that modifies the neigh
>> entry or bond0.
> 
> 	Ouch, we do not need tools to hit the problem,
> thanks to gc_thresh1.
> 
>> In fact, the neigh entry has been rarely used since initialization.
>> 4 days ago, our machine just needed to download files from 172.16.1.18.
>> However, the laddr has changed, and the neigh entry wrongly switched to
>> NUD_REACHABLE state, causing the laddr to fail to update.
> 
> 	Received ARP packets should be able to change
> the address. But we do not refresh the entry because
> its timer is scheduled days ahead.
> 

Yep.

>>> 	Looking at __neigh_update, there are few cases that
>>> can assign NUD_STALE without touching neigh->confirmed:
>>> lladdr = neigh->ha should be called, NEIGH_UPDATE_F_ADMIN
>>> should be provided. Later, as you explain, it can wrongly
>>> switch to NUD_REACHABLE state for long time.
>>>
>>> 	May be there should be some measures to keep
>>> neigh->confirmed valid during admin modifications.
>>>
>>
>> This problem can also occur if the neigh entry stays in NUD_STALE state
>> for more than 99 days, even if it is not modified by the administrator.
> 
> 	I see.
> 
>>> 	What is the kernel version?
>>>
>>
>> We encountered this problem in 4.4 LTS, and the mainline doesn't seem
>> to fix it yet.
> 
> 	Yep, kernel version is irrelevant.
> 
> 	Here is a change that you can comment/test but
> I'm not sure how many days (100?) are needed :) Not tested.
> 
> : From: Julian Anastasov <ja@ssi.bg>
> Subject: [PATCH] neigh: make sure used and confirmed times are valid
> 
> Entries can linger without timer for days, thanks to
> the gc_thresh1 limit. Later, on traffic, NUD_STALE entries
> can switch to NUD_DELAY and start the timer which can see
> confirmed time in the future causing switch to NUD_REACHABLE.
> But then timer is started again based on the wrong
> confirmed time, so days in the future. This is more
> visible on 32-bit platforms.
> 
> Problem and the wrong state change reported by Zhang Changzhong:
> 
> 172.16.1.18 dev bond0 lladdr 0a:0e:0f:01:12:01 ref 1 used 350521/15994171/350520 probes 4 REACHABLE
> 
> 350520 seconds have elapsed since this entry was last updated, but it is
> still in the REACHABLE state (base_reachable_time_ms is 30000),
> preventing lladdr from being updated through probe.
> 
> Fix it by ensuring timer is started with valid used/confirmed
> times. There are also places that need used/updated times to be
> validated.
> 
> Reported-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> Signed-off-by: Julian Anastasov <ja@ssi.bg>
> ---
>  net/core/neighbour.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index a77a85e357e0..f063e8b8fb7d 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -269,7 +269,7 @@ static int neigh_forced_gc(struct neigh_table *tbl)
>  			    (n->nud_state == NUD_NOARP) ||
>  			    (tbl->is_multicast &&
>  			     tbl->is_multicast(n->primary_key)) ||
> -			    time_after(tref, n->updated))
> +			    !time_in_range(n->updated, tref, jiffies))
>  				remove = true;
>  			write_unlock(&n->lock);
>  
> @@ -289,7 +289,13 @@ static int neigh_forced_gc(struct neigh_table *tbl)
>  
>  static void neigh_add_timer(struct neighbour *n, unsigned long when)
>  {
> +	unsigned long mint = jiffies - MAX_JIFFY_OFFSET + 86400 * HZ;
> +
>  	neigh_hold(n);
> +	if (!time_in_range(n->confirmed, mint, jiffies))
> +		n->confirmed = mint;
> +	if (time_before(n->used, n->confirmed))
> +		n->used = n->confirmed;
>  	if (unlikely(mod_timer(&n->timer, when))) {
>  		printk("NEIGH: BUG, double timer add, state is %x\n",
>  		       n->nud_state);
> @@ -982,12 +988,14 @@ static void neigh_periodic_work(struct work_struct *work)
>  				goto next_elt;
>  			}
>  
> -			if (time_before(n->used, n->confirmed))
> +			if (time_before(n->used, n->confirmed) &&
> +			    time_is_before_eq_jiffies(n->confirmed))
>  				n->used = n->confirmed;
>  
>  			if (refcount_read(&n->refcnt) == 1 &&
>  			    (state == NUD_FAILED ||
> -			     time_after(jiffies, n->used + NEIGH_VAR(n->parms, GC_STALETIME)))) {
> +			     !time_in_range_open(jiffies, n->used,
> +						 n->used + NEIGH_VAR(n->parms, GC_STALETIME)))) {
>  				*np = n->next;
>  				neigh_mark_dead(n);
>  				write_unlock(&n->lock);
> 

Thanks for your fix!

I reproduced this problem by directly modifying the confirmed time of
the neigh entry in STALE state. Your change can fix the problem in this
scenario.

Just curious, why did you choose 'jiffies - MAX_JIFFY_OFFSET + 86400 * HZ'
as the value of 'mint'?

Regards,
Changzhong

