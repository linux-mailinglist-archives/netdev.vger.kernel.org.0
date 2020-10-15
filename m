Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB49628F28A
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 14:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgJOMnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 08:43:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22646 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725899AbgJOMnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 08:43:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602765780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cxMDSGp+EAqbUcTbUGQoq9tuMZ+I1kIcPIy03zKRiqI=;
        b=G9caqCe5TfwWHm+9wngaQAEhB+nXK9b1g6L/Yj/2HWQiN4BkD7EyQSN+jXKx1v0vuhEtSA
        dZr+E8+8GtwmMjvVXvs8bdL3w0y9hpR5b8WJ1cU3Xkq5Jn/4qVRMVP1yMBMi1WEPvGdoRX
        1pJMRIgv2abmv3bb4EoLM06XUga1cFc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-RnAc0rq3MISLmtbVVDua8w-1; Thu, 15 Oct 2020 08:42:59 -0400
X-MC-Unique: RnAc0rq3MISLmtbVVDua8w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B7BB79CC20;
        Thu, 15 Oct 2020 12:42:56 +0000 (UTC)
Received: from [10.36.112.252] (ovpn-112-252.ams2.redhat.com [10.36.112.252])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C8B9473665;
        Thu, 15 Oct 2020 12:42:54 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Ilya Maximets" <i.maximets@ovn.org>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org, bigeasy@linutronix.de,
        jlelli@redhat.com, kuba@kernel.org, pabeni@redhat.com,
        davem@davemloft.net
Subject: Re: [ovs-dev] [PATCH net v2] net: openvswitch: fix to make sure
 flow_lookup() is not preempted
Date:   Thu, 15 Oct 2020 14:42:52 +0200
Message-ID: <A93D105E-E051-4DF2-B449-509CF1CA5E76@redhat.com>
In-Reply-To: <12246eee-e235-c10b-96e7-fffc5dda18a2@ovn.org>
References: <160275519174.566500.6537031776378218151.stgit@ebuild>
 <7212d390-ecfd-bfa1-97fc-1819c0c1ee1d@ovn.org>
 <06EADE58-FBCA-44C8-9EEC-FDAACD7DD126@redhat.com>
 <e6be9a9c-2ff0-11f1-e10b-cd2f54820622@ovn.org>
 <12246eee-e235-c10b-96e7-fffc5dda18a2@ovn.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 15 Oct 2020, at 13:22, Ilya Maximets wrote:

> On 10/15/20 1:04 PM, Ilya Maximets wrote:
>> On 10/15/20 12:54 PM, Eelco Chaudron wrote:
>>>
>>>
>>> On 15 Oct 2020, at 12:27, Ilya Maximets wrote:
>>>
>>>> On 10/15/20 11:46 AM, Eelco Chaudron wrote:
>>>>> The flow_lookup() function uses per CPU variables, which must not 
>>>>> be
>>>>> preempted. However, this is fine in the general napi use case 
>>>>> where
>>>>> the local BH is disabled. But, it's also called in the netlink
>>>>> context, which is preemptible. The below patch makes sure that 
>>>>> even
>>>>> in the netlink path, preemption is disabled.
>>>>>
>>>>> In addition, the u64_stats_update_begin() sync point was not 
>>>>> protected,
>>>>> making the sync point part of the per CPU variable fixed this.
>>>>>
>>>>> Fixes: eac87c413bf9 ("net: openvswitch: reorder masks array based 
>>>>> on usage")
>>>>> Reported-by: Juri Lelli <jlelli@redhat.com>
>>>>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>>>>> ---
>>>>> v2: - Add u64_stats_update_begin() sync point protection
>>>>>     - Moved patch to net from net-next branch
>>>>>
>>>>>  net/openvswitch/flow_table.c |   56 
>>>>> +++++++++++++++++++++++++-----------------
>>>>>  net/openvswitch/flow_table.h |    8 +++++-
>>>>>  2 files changed, 39 insertions(+), 25 deletions(-)
>>>>>
>>>>> diff --git a/net/openvswitch/flow_table.c 
>>>>> b/net/openvswitch/flow_table.c
>>>>> index e2235849a57e..d90b4af6f539 100644
>>>>> --- a/net/openvswitch/flow_table.c
>>>>> +++ b/net/openvswitch/flow_table.c
>>>>> @@ -172,7 +172,7 @@ static struct table_instance 
>>>>> *table_instance_alloc(int new_size)
>>>>>
>>>>>  static void __mask_array_destroy(struct mask_array *ma)
>>>>>  {
>>>>> -    free_percpu(ma->masks_usage_cntr);
>>>>> +    free_percpu(ma->masks_usage_stats);
>>>>>      kfree(ma);
>>>>>  }
>>>>>
>>>>> @@ -196,15 +196,15 @@ static void 
>>>>> tbl_mask_array_reset_counters(struct mask_array *ma)
>>>>>          ma->masks_usage_zero_cntr[i] = 0;
>>>>>
>>>>>          for_each_possible_cpu(cpu) {
>>>>> -            u64 *usage_counters = 
>>>>> per_cpu_ptr(ma->masks_usage_cntr,
>>>>> -                              cpu);
>>>>> +            struct mask_array_stats *stats;
>>>>>              unsigned int start;
>>>>>              u64 counter;
>>>>>
>>>>> +            stats = per_cpu_ptr(ma->masks_usage_stats, 
>>>>> cpu);
>>>>>              do {
>>>>> -                start = 
>>>>> u64_stats_fetch_begin_irq(&ma->syncp);
>>>>> -                counter = usage_counters[i];
>>>>> -            } while 
>>>>> (u64_stats_fetch_retry_irq(&ma->syncp, start));
>>>>> +                start = 
>>>>> u64_stats_fetch_begin_irq(&stats->syncp);
>>>>> +                counter = stats->usage_cntrs[i];
>>>>> +            } while 
>>>>> (u64_stats_fetch_retry_irq(&stats->syncp, start));
>>>>>
>>>>>              ma->masks_usage_zero_cntr[i] += counter;
>>>>>          }
>>>>> @@ -227,9 +227,10 @@ static struct mask_array 
>>>>> *tbl_mask_array_alloc(int size)
>>>>>                           sizeof(struct 
>>>>> sw_flow_mask *) *
>>>>>                           size);
>>>>>
>>>>> -    new->masks_usage_cntr = __alloc_percpu(sizeof(u64) * size,
>>>>> -                           
>>>>> __alignof__(u64));
>>>>> -    if (!new->masks_usage_cntr) {
>>>>> +    new->masks_usage_stats = __alloc_percpu(sizeof(struct 
>>>>> mask_array_stats) +
>>>>> +                        sizeof(u64) * 
>>>>> size,
>>>>> +                        __alignof__(u64));
>>>>> +    if (!new->masks_usage_stats) {
>>>>>          kfree(new);
>>>>>          return NULL;
>>>>>      }
>>>>> @@ -732,7 +733,7 @@ static struct sw_flow *flow_lookup(struct 
>>>>> flow_table *tbl,
>>>>>                     u32 *n_cache_hit,
>>>>>                     u32 *index)
>>>>>  {
>>>>> -    u64 *usage_counters = this_cpu_ptr(ma->masks_usage_cntr);
>>>>> +    struct mask_array_stats *stats = 
>>>>> this_cpu_ptr(ma->masks_usage_stats);
>>>>>      struct sw_flow *flow;
>>>>>      struct sw_flow_mask *mask;
>>>>>      int i;
>>>>> @@ -742,9 +743,9 @@ static struct sw_flow *flow_lookup(struct 
>>>>> flow_table *tbl,
>>>>>          if (mask) {
>>>>>              flow = masked_flow_lookup(ti, key, mask, 
>>>>> n_mask_hit);
>>>>>              if (flow) {
>>>>> -                
>>>>> u64_stats_update_begin(&ma->syncp);
>>>>> -                usage_counters[*index]++;
>>>>> -                u64_stats_update_end(&ma->syncp);
>>>>> +                
>>>>> u64_stats_update_begin(&stats->syncp);
>>>>> +                stats->usage_cntrs[*index]++;
>>>>> +                
>>>>> u64_stats_update_end(&stats->syncp);
>>>>>                  (*n_cache_hit)++;
>>>>>                  return flow;
>>>>>              }
>>>>> @@ -763,9 +764,9 @@ static struct sw_flow *flow_lookup(struct 
>>>>> flow_table *tbl,
>>>>>          flow = masked_flow_lookup(ti, key, mask, 
>>>>> n_mask_hit);
>>>>>          if (flow) { /* Found */
>>>>>              *index = i;
>>>>> -            u64_stats_update_begin(&ma->syncp);
>>>>> -            usage_counters[*index]++;
>>>>> -            u64_stats_update_end(&ma->syncp);
>>>>> +            u64_stats_update_begin(&stats->syncp);
>>>>> +            stats->usage_cntrs[*index]++;
>>>>> +            u64_stats_update_end(&stats->syncp);
>>>>>              return flow;
>>>>>          }
>>>>>      }
>>>>> @@ -851,9 +852,17 @@ struct sw_flow *ovs_flow_tbl_lookup(struct 
>>>>> flow_table *tbl,
>>>>>      struct mask_array *ma = 
>>>>> rcu_dereference_ovsl(tbl->mask_array);
>>>>>      u32 __always_unused n_mask_hit;
>>>>>      u32 __always_unused n_cache_hit;
>>>>> +    struct sw_flow *flow;
>>>>>      u32 index = 0;
>>>>>
>>>>> -    return flow_lookup(tbl, ti, ma, key, &n_mask_hit, 
>>>>> &n_cache_hit, &index);
>>>>> +    /* This function gets called trough the netlink interface 
>>>>> and therefore
>>>>> +     * is preemptible. However, flow_lookup() function needs 
>>>>> to be called
>>>>> +     * with preemption disabled due to CPU specific 
>>>>> variables.
>>>>
>>>> Is it possible to add some kind of assertion inside flow_lookup() 
>>>> to avoid
>>>> this kind of issues in the future?
>>>
>>> We could do something like WARN_ON_ONCE(preemptible()) but do not 
>>> think such check should be added to the fast path.
>>
>> I meant something like lockdep_assert_preemption_disabled().  This 
>> will not
>> impact fast path if CONFIG_PROVE_LOCKING disabled, but will allow to 
>> catch
>> issues during development.
>
> To be clear, I just mean that this could be compiled conditionally 
> under some
> debugging config.  Do not know which of existing configs might be 
> used, though.

Looked at the debug flags, but there is not really one that makes sense 
to use. Also using a general one like DEBUG_MISC will probably no help, 
as none would probably run OVS tests with this flag enabled. So for now 
I would leave it as is unless someone has a better idea…

>>>
>>>> It might be also good to update the comment for flow_lookup() 
>>>> function itself.
>>>
>>> Good idea, will do this in a v3
>>>
>>>>> +     */
>>>>> +    local_bh_disable();
>>>>> +    flow = flow_lookup(tbl, ti, ma, key, &n_mask_hit, 
>>>>> &n_cache_hit, &index);
>>>>> +    local_bh_enable();
>>>>> +    return flow;
>>>>>  }
>>>>>
>>>>>  struct sw_flow *ovs_flow_tbl_lookup_exact(struct flow_table 
>>>>> *tbl,
>>>>> @@ -1109,7 +1118,6 @@ void ovs_flow_masks_rebalance(struct 
>>>>> flow_table *table)
>>>>>
>>>>>      for (i = 0; i < ma->max; i++)  {
>>>>>          struct sw_flow_mask *mask;
>>>>> -        unsigned int start;
>>>>>          int cpu;
>>>>>
>>>>>          mask = rcu_dereference_ovsl(ma->masks[i]);
>>>>> @@ -1120,14 +1128,16 @@ void ovs_flow_masks_rebalance(struct 
>>>>> flow_table *table)
>>>>>          masks_and_count[i].counter = 0;
>>>>>
>>>>>          for_each_possible_cpu(cpu) {
>>>>> -            u64 *usage_counters = 
>>>>> per_cpu_ptr(ma->masks_usage_cntr,
>>>>> -                              cpu);
>>>>> +            struct mask_array_stats *stats;
>>>>> +            unsigned int start;
>>>>>              u64 counter;
>>>>>
>>>>> +            stats = per_cpu_ptr(ma->masks_usage_stats, 
>>>>> cpu);
>>>>>              do {
>>>>> -                start = 
>>>>> u64_stats_fetch_begin_irq(&ma->syncp);
>>>>> -                counter = usage_counters[i];
>>>>> -            } while 
>>>>> (u64_stats_fetch_retry_irq(&ma->syncp, start));
>>>>> +                start = 
>>>>> u64_stats_fetch_begin_irq(&stats->syncp);
>>>>> +                counter = stats->usage_cntrs[i];
>>>>> +            } while 
>>>>> (u64_stats_fetch_retry_irq(&stats->syncp,
>>>>> +                               
>>>>> start));
>>>>>
>>>>>              masks_and_count[i].counter += counter;
>>>>>          }
>>>>> diff --git a/net/openvswitch/flow_table.h 
>>>>> b/net/openvswitch/flow_table.h
>>>>> index 6e7d4ac59353..43144396e192 100644
>>>>> --- a/net/openvswitch/flow_table.h
>>>>> +++ b/net/openvswitch/flow_table.h
>>>>> @@ -38,12 +38,16 @@ struct mask_count {
>>>>>      u64 counter;
>>>>>  };
>>>>>
>>>>> +struct mask_array_stats {
>>>>> +    struct u64_stats_sync syncp;
>>>>> +    u64 usage_cntrs[];
>>>>> +};
>>>>> +
>>>>>  struct mask_array {
>>>>>      struct rcu_head rcu;
>>>>>      int count, max;
>>>>> -    u64 __percpu *masks_usage_cntr;
>>>>> +    struct mask_array_stats __percpu *masks_usage_stats;
>>>>>      u64 *masks_usage_zero_cntr;
>>>>> -    struct u64_stats_sync syncp;
>>>>>      struct sw_flow_mask __rcu *masks[];
>>>>>  };
>>>>>
>>>>>
>>>>> _______________________________________________
>>>>> dev mailing list
>>>>> dev@openvswitch.org
>>>>> https://mail.openvswitch.org/mailman/listinfo/ovs-dev
>>>>>
>>>
>>

