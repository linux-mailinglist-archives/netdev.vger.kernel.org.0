Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F6628F06B
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 12:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbgJOKys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 06:54:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24281 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726654AbgJOKys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 06:54:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602759285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=O2NEa+OE0C2+8D92OygNPC7xFMFTA/+hXq82VGwtnrI=;
        b=a5gUh61B+Pllc8+BOMSAXCGV9BkDkf0AQconj9PYzcyuqCn8qs/kDze4MmdCgeTp0yMFgE
        9iFEd+wt07sSc+D2CXbwgZEAAlpngI1OuR7EP7PTkfn6hN7QQJiD9A02ukdVUvpOqrwB+d
        b5QeUVCo+LZaOsR3qGTD5XWTEdOKFIY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-mCLsYfNXOTy-BeTdPX1SEg-1; Thu, 15 Oct 2020 06:54:44 -0400
X-MC-Unique: mCLsYfNXOTy-BeTdPX1SEg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD29D8015F7;
        Thu, 15 Oct 2020 10:54:42 +0000 (UTC)
Received: from [10.36.112.252] (ovpn-112-252.ams2.redhat.com [10.36.112.252])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 25AB15D9D5;
        Thu, 15 Oct 2020 10:54:41 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Ilya Maximets" <i.maximets@ovn.org>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org, bigeasy@linutronix.de,
        jlelli@redhat.com, kuba@kernel.org, pabeni@redhat.com,
        davem@davemloft.net
Subject: Re: [ovs-dev] [PATCH net v2] net: openvswitch: fix to make sure
 flow_lookup() is not preempted
Date:   Thu, 15 Oct 2020 12:54:39 +0200
Message-ID: <06EADE58-FBCA-44C8-9EEC-FDAACD7DD126@redhat.com>
In-Reply-To: <7212d390-ecfd-bfa1-97fc-1819c0c1ee1d@ovn.org>
References: <160275519174.566500.6537031776378218151.stgit@ebuild>
 <7212d390-ecfd-bfa1-97fc-1819c0c1ee1d@ovn.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 15 Oct 2020, at 12:27, Ilya Maximets wrote:

> On 10/15/20 11:46 AM, Eelco Chaudron wrote:
>> The flow_lookup() function uses per CPU variables, which must not be
>> preempted. However, this is fine in the general napi use case where
>> the local BH is disabled. But, it's also called in the netlink
>> context, which is preemptible. The below patch makes sure that even
>> in the netlink path, preemption is disabled.
>>
>> In addition, the u64_stats_update_begin() sync point was not 
>> protected,
>> making the sync point part of the per CPU variable fixed this.
>>
>> Fixes: eac87c413bf9 ("net: openvswitch: reorder masks array based on 
>> usage")
>> Reported-by: Juri Lelli <jlelli@redhat.com>
>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>> ---
>> v2: - Add u64_stats_update_begin() sync point protection
>>     - Moved patch to net from net-next branch
>>
>>  net/openvswitch/flow_table.c |   56 
>> +++++++++++++++++++++++++-----------------
>>  net/openvswitch/flow_table.h |    8 +++++-
>>  2 files changed, 39 insertions(+), 25 deletions(-)
>>
>> diff --git a/net/openvswitch/flow_table.c 
>> b/net/openvswitch/flow_table.c
>> index e2235849a57e..d90b4af6f539 100644
>> --- a/net/openvswitch/flow_table.c
>> +++ b/net/openvswitch/flow_table.c
>> @@ -172,7 +172,7 @@ static struct table_instance 
>> *table_instance_alloc(int new_size)
>>
>>  static void __mask_array_destroy(struct mask_array *ma)
>>  {
>> -	free_percpu(ma->masks_usage_cntr);
>> +	free_percpu(ma->masks_usage_stats);
>>  	kfree(ma);
>>  }
>>
>> @@ -196,15 +196,15 @@ static void 
>> tbl_mask_array_reset_counters(struct mask_array *ma)
>>  		ma->masks_usage_zero_cntr[i] = 0;
>>
>>  		for_each_possible_cpu(cpu) {
>> -			u64 *usage_counters = per_cpu_ptr(ma->masks_usage_cntr,
>> -							  cpu);
>> +			struct mask_array_stats *stats;
>>  			unsigned int start;
>>  			u64 counter;
>>
>> +			stats = per_cpu_ptr(ma->masks_usage_stats, cpu);
>>  			do {
>> -				start = u64_stats_fetch_begin_irq(&ma->syncp);
>> -				counter = usage_counters[i];
>> -			} while (u64_stats_fetch_retry_irq(&ma->syncp, start));
>> +				start = u64_stats_fetch_begin_irq(&stats->syncp);
>> +				counter = stats->usage_cntrs[i];
>> +			} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
>>
>>  			ma->masks_usage_zero_cntr[i] += counter;
>>  		}
>> @@ -227,9 +227,10 @@ static struct mask_array 
>> *tbl_mask_array_alloc(int size)
>>  					     sizeof(struct sw_flow_mask *) *
>>  					     size);
>>
>> -	new->masks_usage_cntr = __alloc_percpu(sizeof(u64) * size,
>> -					       __alignof__(u64));
>> -	if (!new->masks_usage_cntr) {
>> +	new->masks_usage_stats = __alloc_percpu(sizeof(struct 
>> mask_array_stats) +
>> +						sizeof(u64) * size,
>> +						__alignof__(u64));
>> +	if (!new->masks_usage_stats) {
>>  		kfree(new);
>>  		return NULL;
>>  	}
>> @@ -732,7 +733,7 @@ static struct sw_flow *flow_lookup(struct 
>> flow_table *tbl,
>>  				   u32 *n_cache_hit,
>>  				   u32 *index)
>>  {
>> -	u64 *usage_counters = this_cpu_ptr(ma->masks_usage_cntr);
>> +	struct mask_array_stats *stats = 
>> this_cpu_ptr(ma->masks_usage_stats);
>>  	struct sw_flow *flow;
>>  	struct sw_flow_mask *mask;
>>  	int i;
>> @@ -742,9 +743,9 @@ static struct sw_flow *flow_lookup(struct 
>> flow_table *tbl,
>>  		if (mask) {
>>  			flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
>>  			if (flow) {
>> -				u64_stats_update_begin(&ma->syncp);
>> -				usage_counters[*index]++;
>> -				u64_stats_update_end(&ma->syncp);
>> +				u64_stats_update_begin(&stats->syncp);
>> +				stats->usage_cntrs[*index]++;
>> +				u64_stats_update_end(&stats->syncp);
>>  				(*n_cache_hit)++;
>>  				return flow;
>>  			}
>> @@ -763,9 +764,9 @@ static struct sw_flow *flow_lookup(struct 
>> flow_table *tbl,
>>  		flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
>>  		if (flow) { /* Found */
>>  			*index = i;
>> -			u64_stats_update_begin(&ma->syncp);
>> -			usage_counters[*index]++;
>> -			u64_stats_update_end(&ma->syncp);
>> +			u64_stats_update_begin(&stats->syncp);
>> +			stats->usage_cntrs[*index]++;
>> +			u64_stats_update_end(&stats->syncp);
>>  			return flow;
>>  		}
>>  	}
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
> Is it possible to add some kind of assertion inside flow_lookup() to 
> avoid
> this kind of issues in the future?

We could do something like WARN_ON_ONCE(preemptible()) but do not think 
such check should be added to the fast path.

> It might be also good to update the comment for flow_lookup() function 
> itself.

Good idea, will do this in a v3

>> +	 */
>> +	local_bh_disable();
>> +	flow = flow_lookup(tbl, ti, ma, key, &n_mask_hit, &n_cache_hit, 
>> &index);
>> +	local_bh_enable();
>> +	return flow;
>>  }
>>
>>  struct sw_flow *ovs_flow_tbl_lookup_exact(struct flow_table *tbl,
>> @@ -1109,7 +1118,6 @@ void ovs_flow_masks_rebalance(struct flow_table 
>> *table)
>>
>>  	for (i = 0; i < ma->max; i++)  {
>>  		struct sw_flow_mask *mask;
>> -		unsigned int start;
>>  		int cpu;
>>
>>  		mask = rcu_dereference_ovsl(ma->masks[i]);
>> @@ -1120,14 +1128,16 @@ void ovs_flow_masks_rebalance(struct 
>> flow_table *table)
>>  		masks_and_count[i].counter = 0;
>>
>>  		for_each_possible_cpu(cpu) {
>> -			u64 *usage_counters = per_cpu_ptr(ma->masks_usage_cntr,
>> -							  cpu);
>> +			struct mask_array_stats *stats;
>> +			unsigned int start;
>>  			u64 counter;
>>
>> +			stats = per_cpu_ptr(ma->masks_usage_stats, cpu);
>>  			do {
>> -				start = u64_stats_fetch_begin_irq(&ma->syncp);
>> -				counter = usage_counters[i];
>> -			} while (u64_stats_fetch_retry_irq(&ma->syncp, start));
>> +				start = u64_stats_fetch_begin_irq(&stats->syncp);
>> +				counter = stats->usage_cntrs[i];
>> +			} while (u64_stats_fetch_retry_irq(&stats->syncp,
>> +							   start));
>>
>>  			masks_and_count[i].counter += counter;
>>  		}
>> diff --git a/net/openvswitch/flow_table.h 
>> b/net/openvswitch/flow_table.h
>> index 6e7d4ac59353..43144396e192 100644
>> --- a/net/openvswitch/flow_table.h
>> +++ b/net/openvswitch/flow_table.h
>> @@ -38,12 +38,16 @@ struct mask_count {
>>  	u64 counter;
>>  };
>>
>> +struct mask_array_stats {
>> +	struct u64_stats_sync syncp;
>> +	u64 usage_cntrs[];
>> +};
>> +
>>  struct mask_array {
>>  	struct rcu_head rcu;
>>  	int count, max;
>> -	u64 __percpu *masks_usage_cntr;
>> +	struct mask_array_stats __percpu *masks_usage_stats;
>>  	u64 *masks_usage_zero_cntr;
>> -	struct u64_stats_sync syncp;
>>  	struct sw_flow_mask __rcu *masks[];
>>  };
>>
>>
>> _______________________________________________
>> dev mailing list
>> dev@openvswitch.org
>> https://mail.openvswitch.org/mailman/listinfo/ovs-dev
>>

