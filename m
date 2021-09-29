Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5EB41CC50
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 21:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346401AbhI2TJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 15:09:09 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.183]:20044 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245276AbhI2TJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 15:09:08 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.51.17])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 7FCDB1A007E;
        Wed, 29 Sep 2021 19:07:25 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 29B65680077;
        Wed, 29 Sep 2021 19:07:25 +0000 (UTC)
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id B68F913C2B0;
        Wed, 29 Sep 2021 12:07:05 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com B68F913C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1632942425;
        bh=IhIeNXorDdH1o2GdXUzRLkwrOUqzDZTktij4/PHCeNw=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=NNW8k3QrItovofR9vP8D4Db5L+nWRW1GRm9gZPPJHkrGBkTfQGqRaVMGO5/9WV8vA
         zSm4eLNiSmjpIa64arr3ias2cquPaxHXq5KFiPcf8XOvwEDze9Y2Y+jYjp9b4vf0Eh
         Li5P3jvjaJy53juguiGCoNB8e3VCaxrYg72iJoz4=
Subject: Re: 5.15-rc3+ crash in fq-codel?
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>
References: <dfa032f3-18f2-22a3-80bf-f0f570892478@candelatech.com>
 <b6e8155e-7fae-16b0-59f0-2a2e6f5142de@gmail.com>
 <00e495ba-391e-6ad8-94a2-930fbc826a37@candelatech.com>
 <296232ac-e7ed-6e3c-36b9-ed430a21f632@candelatech.com>
 <7e87883e-42f5-2341-ab67-9f1614fb8b86@candelatech.com>
 <7f1d67f1-3a2c-2e74-bb86-c02a56370526@gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <88bc8a03-da44-fc15-f032-fe5cb592958b@candelatech.com>
Date:   Wed, 29 Sep 2021 12:07:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <7f1d67f1-3a2c-2e74-bb86-c02a56370526@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-MDID: 1632942446-Kmy2EWfejAAS
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/28/21 4:25 PM, Eric Dumazet wrote:
> 
> 
> On 9/28/21 3:00 PM, Ben Greear wrote:
>> On 9/27/21 5:16 PM, Ben Greear wrote:
>>> On 9/27/21 5:04 PM, Ben Greear wrote:
>>>> On 9/27/21 4:49 PM, Eric Dumazet wrote:
>>>>>
>>>>>
>>>>> On 9/27/21 4:30 PM, Ben Greear wrote:
>>>>>> Hello,
>>>>>>
>>>>>> In a hacked upon kernel, I'm getting crashes in fq-codel when doing bi-directional
>>>>>> pktgen traffic on top of mac-vlans.  Unfortunately for me, I've made big changes to
>>>>>> pktgen so I cannot easily run this test on stock kernels, and there is some chance
>>>>>> some of my hackings have caused this issue.
>>>>>>
>>>>>> But, in case others have seen similar, please let me know.  I shall go digging
>>>>>> in the meantime...
>>>>>>
>>>>>> Looks to me like 'skb' is NULL in line 120 below.
>>>>>
>>>>>
>>>>> pktgen must not be used in a mode where a single skb
>>>>> is cloned and reused, if packet needs to be stored in a qdisc.
>>>>>
>>>>> qdisc of all sorts assume skb->next/prev can be used as
>>>>> anchor in their list.
>>>>>
>>>>> If the same skb is queued multiple times, lists are corrupted.
>>>>>
>>>>> Please double check your clone_skb pktgen setup.
>>>>>
>>>>> I thought we had IFF_TX_SKB_SHARING for this, and that macvlan was properly clearing this bit.
>>>>
>>>> My pktgen config was not using any duplicated queueing in this case.
>>>>
>>>> I changed to pfifo fast and so far it is stable for ~10 minutes, where before it would crash
>>>> within a minute.  I'll let it bake overnight....
>>>
>>> Still running stable.  I also notice we have been using fq-codel for a while and haven't noticed
>>> this problem (next most recent kernel we might have run similar test on would be 5.13-ish).
>>>
>>> I'll duplicate this test on our older kernels tomorrow to see if it looks like a regression or
>>> if we just haven't actually done this exact test in a while...
>>
>> We can reproduce this crash as far back as 5.4 using fq-codel, with our pktgen driving mac-vlans.
>> We did not try any kernels older than 5.4.
>> We cannot reproduce with pfifo on 5.15-rc3 on an overnight run.
>> We cannot produce with user-space UDP traffic on any kernel/qdisc combination.
>> Our pktgen is configured for multi-skb of 0 (no multiple submits of the same skb)
>>
>> While looking briefly at fq-codel, I didn't notice any locking in the code that crashed.
>> Any chance that it makes assumptions that would be incorrect with pktgen running multiple
>> threads (one thread per mac-vlan) on top of a single qdisc belonging to the underlying NIC?
>>
> 
> 
> qdisc are protected by a qdisc spinlock.
> 
> fq-codel does not have to lock anything in its enqueue() and dequeue() methods.
> 
> I guess your local changes to pktgen might be to blame.
> 
> pfifo is much simpler than fq-codel, it uses less fields from skb.

I looked through my pktgen, and the skb creation and setup code looks pretty
similar to upstream pktgen.

I also added this debugging code:

[greearb@ben-dt4 linux-5.15.dev.y]$ git diff
diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index bb0cd6d3d2c2..56e22106e19d 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -165,6 +165,11 @@ static unsigned int fq_codel_drop(struct Qdisc *sch, unsigned int max_packets,
         len = 0;
         i = 0;
         do {
+               if (!flow->head) {
+                       pr_err("fq-codel-drop: idx: %d maxbacklog: %d  threshold: %d max_packets: %d len: %d i: %d\n",
+                              idx, maxbacklog, threshold, max_packets, len, i);
+                       BUG_ON(1);
+               }
                 skb = dequeue_head(flow);
                 len += qdisc_pkt_len(skb);
                 mem += get_codel_cb(skb)->mem_usage;

The printout I see when this hits is:


fq-codel-drop: idx: 955 maxbacklog: 7756222  threshold: 3878111 max_packets: 64 len: 93868 i: 62
kernel BUG at net/sched/sch_fq_codel.c:171!
.....

So, I guess this means that the backlog byte counter is out of sync with the packet queue somehow?

Any suggestions for what kinds of issues in pktgen could cause this?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

