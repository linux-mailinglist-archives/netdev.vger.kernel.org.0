Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22DF28F770
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 19:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390041AbgJORGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 13:06:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49085 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389893AbgJORGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 13:06:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602781593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3RJi0kM08UK8TVzxHsYU0qxAjxcnVI5ZTlhLMSIRwaE=;
        b=Oh+yegRSTyr7h76Wi4msibcVNbJFZtmCKGsB+rAIJ6J4rBkZ49IrfzT1DAeUDBnMQIIjhr
        z9o9jnbV30dLYBtJ7rYz0oj2OnGfvxeWH6u2+sKFTzoooM0XyRHfSgGd4ZOrw79iTUHe8F
        BHz81IfKbv8tMIKHf9IEIdaY7dhUepE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-spoX46UhOT2YbDR86TDX_w-1; Thu, 15 Oct 2020 13:06:29 -0400
X-MC-Unique: spoX46UhOT2YbDR86TDX_w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AED69803642;
        Thu, 15 Oct 2020 17:06:27 +0000 (UTC)
Received: from [10.36.112.252] (ovpn-112-252.ams2.redhat.com [10.36.112.252])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DACDB6EF61;
        Thu, 15 Oct 2020 17:06:22 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dev@openvswitch.org,
        kuba@kernel.org, pabeni@redhat.com, pshelar@ovn.org,
        jlelli@redhat.com, "Peter Zijlstra" <peterz@infradead.org>,
        tglx@linutronix.de
Subject: Re: [PATCH net v2] net: openvswitch: fix to make sure flow_lookup()
 is not preempted
Date:   Thu, 15 Oct 2020 19:06:21 +0200
Message-ID: <91906B2A-FE02-4757-99A8-12F57F2AFCAD@redhat.com>
In-Reply-To: <20201015123434.7tesbva626nczpq5@linutronix.de>
References: <160275519174.566500.6537031776378218151.stgit@ebuild>
 <20201015123434.7tesbva626nczpq5@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 15 Oct 2020, at 14:34, Sebastian Andrzej Siewior wrote:

> On 2020-10-15 11:46:53 [+0200], Eelco Chaudron wrote:
>> The flow_lookup() function uses per CPU variables, which must not be
>> preempted. However, this is fine in the general napi use case where
>> the local BH is disabled. But, it's also called in the netlink
>> context, which is preemptible. The below patch makes sure that even
>> in the netlink path, preemption is disabled.
>
> I would suggest to rephrase it: the term preemption usually means
> preempt_disable(). A preempt disabled section can be preempted /
> interrupted by hardirq and softirq. The later is mentioned and I think
> is confusing.
>
>> In addition, the u64_stats_update_begin() sync point was not 
>> protected,
>> making the sync point part of the per CPU variable fixed this.
>
> I would rephrase it and mention the key details:
> u64_stats_update_begin() requires a lock to ensure one writer which is
> not ensured here. Making it per-CPU and disabling NAPI (softirq) 
> ensures
> that there is always only one writer.
>
> Regarding the annotation which were mentioned here in the thread.
> Basically the this_cpu_ptr() warning worked as expected and got us 
> here.
> I don't think it is wise to add annotation distinguished from the 
> actual
> problem like assert_the_softirq_is_switched_off() in flow_lookup(). 
> The
> assert may become obsolete once the reason is removed and gets 
> overseen
> and remains in the code. The commits
>
> 	c60c32a577561 ("posix-cpu-timers: Remove 
> lockdep_assert_irqs_disabled()")
> 	f9dae5554aed4 ("dpaa2-eth: Remove preempt_disable() from 
> seed_pool()")
>
> are just two examples which came to mind while writing this.
>
> Instead I would prefer lockdep annotation in u64_stats_update_begin()
> which is around also in 64bit kernels and complains if it is seen
> without disabled BH if observed in-serving-softirq.
> PeterZ, wasn't this mentioned before?
>
>> --- a/net/openvswitch/flow_table.c
>> +++ b/net/openvswitch/flow_table.c
>> @@ -851,9 +852,17 @@ struct sw_flow *ovs_flow_tbl_lookup(struct 
>> flow_table *tbl,
>>  	struct mask_array *ma = rcu_dereference_ovsl(tbl->mask_array);
>>  	u32 __always_unused n_mask_hit;
>>  	u32 __always_unused n_cache_hit;
>> +	struct sw_flow *flow;
>>  	u32 index = 0;
>>
>> -	return flow_lookup(tbl, ti, ma, key, &n_mask_hit, &n_cache_hit, 
>> &index);
>> +	/* This function gets called trough the netlink interface and 
>> therefore
>> +	 * is preemptible. However, flow_lookup() function needs to be 
>> called
>> +	 * with preemption disabled due to CPU specific variables.
>
> preemption vs BH.
>
>> +	 */
>> +	local_bh_disable();
>> +	flow = flow_lookup(tbl, ti, ma, key, &n_mask_hit, &n_cache_hit, 
>> &index);
>> +	local_bh_enable();
>> +	return flow;
>>  }
>>
>>  struct sw_flow *ovs_flow_tbl_lookup_exact(struct flow_table *tbl,
>
> Otherwise it looks good.
>

Thanks for your review! Made the modifications you suggested and will 
send out a v3 soon.

//Eelco

