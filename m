Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E79F28DF45
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 12:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgJNKoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 06:44:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34382 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726186AbgJNKod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 06:44:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602672271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HviQGjv7Fx3UyNG8IImM27HOYmMpUnuE83I0CBddVdA=;
        b=g+nhSd9z+WsbXJXvqGaOkWQwfjtpDdqoFXbOXNe0nTtwKh1jYo5yxCououc1R9g9xpvSED
        PBPmmsQnKs0kiJRtY34gl704Nohrwkemo7+wXUANtkjzS05DefvKZcqJB03VclsImEH83y
        aoRquJwwZFTiv46pph3edpB+ccJkl/M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-Z6oYZc5bO7667cNxgkvbFA-1; Wed, 14 Oct 2020 06:44:28 -0400
X-MC-Unique: Z6oYZc5bO7667cNxgkvbFA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AFE2256BE5;
        Wed, 14 Oct 2020 10:44:26 +0000 (UTC)
Received: from [10.36.113.7] (ovpn-113-7.ams2.redhat.com [10.36.113.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F23A65C1BD;
        Wed, 14 Oct 2020 10:44:24 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dev@openvswitch.org,
        kuba@kernel.org, pabeni@redhat.com, pshelar@ovn.org,
        jlelli@redhat.com
Subject: Re: [PATCH net-next] net: openvswitch: fix to make sure flow_lookup()
 is not preempted
Date:   Wed, 14 Oct 2020 12:44:23 +0200
Message-ID: <3D834ADB-09E7-4E28-B62F-CB6281987E41@redhat.com>
In-Reply-To: <20201013125307.ugz4nvjvyxrfhi6n@linutronix.de>
References: <160259304349.181017.7492443293310262978.stgit@ebuild>
 <20201013125307.ugz4nvjvyxrfhi6n@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 13 Oct 2020, at 14:53, Sebastian Andrzej Siewior wrote:

> On 2020-10-13 14:44:19 [+0200], Eelco Chaudron wrote:
>> The flow_lookup() function uses per CPU variables, which must not be
>> preempted. However, this is fine in the general napi use case where
>> the local BH is disabled. But, it's also called in the netlink
>> context, which is preemptible. The below patch makes sure that even
>> in the netlink path, preemption is disabled.
>>
>> Fixes: eac87c413bf9 ("net: openvswitch: reorder masks array based on 
>> usage")
>> Reported-by: Juri Lelli <jlelli@redhat.com>
>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>> ---
>>  net/openvswitch/flow_table.c |   10 +++++++++-
>>  1 file changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/openvswitch/flow_table.c 
>> b/net/openvswitch/flow_table.c
>> index 87c286ad660e..16289386632b 100644
>> --- a/net/openvswitch/flow_table.c
>> +++ b/net/openvswitch/flow_table.c
>> @@ -850,9 +850,17 @@ struct sw_flow *ovs_flow_tbl_lookup(struct 
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
>> +	 */
>
> Once again. u64_stats_update_begin(). What protects you against
> concurrent access.

Thanks Sebastian for repeating this, as I thought I went over the 
seqcount code and thought it should be fine for my use case. However 
based on this comment I went over it again, and found the logic part I 
was constantly missing :)

My idea is to send a v2 patch and in addition to the preempt_disable() 
also make the seqcount part per CPU. I noticed other parts of the 
networking stack doing it the same way. So the patch would look 
something like:

@@ -731,7 +732,7 @@ static struct sw_flow *flow_lookup(struct flow_table 
*tbl,
                                    u32 *n_cache_hit,
                                    u32 *index)
  {
-       u64 *usage_counters = this_cpu_ptr(ma->masks_usage_cntr);
+       struct mask_array_stats *stats = 
this_cpu_ptr(ma->masks_usage_stats);
         struct sw_flow *flow;
         struct sw_flow_mask *mask;
         int i;
@@ -741,9 +742,9 @@ static struct sw_flow *flow_lookup(struct flow_table 
*tbl,
                 if (mask) {
                         flow = masked_flow_lookup(ti, key, mask, 
n_mask_hit);
                         if (flow) {
-                               u64_stats_update_begin(&ma->syncp);
-                               usage_counters[*index]++;
-                               u64_stats_update_end(&ma->syncp);
+                               u64_stats_update_begin(&stats->syncp);
+                               stats->usage_cntr[*index]++;
+                               u64_stats_update_end(&stats->syncp);
                                 (*n_cache_hit)++;
                                 return flow;
                         }

Let me know your thoughts.


Thanks,

Eelco

