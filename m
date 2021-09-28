Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C4541B9C5
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 00:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243013AbhI1WCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 18:02:35 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:43400 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242626AbhI1WCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 18:02:34 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.51.175])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 1280C1A006F;
        Tue, 28 Sep 2021 22:00:53 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id C99938C006D;
        Tue, 28 Sep 2021 22:00:52 +0000 (UTC)
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 4F5BB13C2B1;
        Tue, 28 Sep 2021 15:00:52 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 4F5BB13C2B1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1632866452;
        bh=gtsKYOgt4j2FZB99XSWMku9IvJrj4qM2Glsh5ogIvAo=;
        h=Subject:From:To:References:Date:In-Reply-To:From;
        b=fBDEaiQglcCaWcFMEddigJlghu7GLut7lKTyNS/4JpOp74F8ZvqYPi16bpGXEP8n7
         0zYJOLrYavhYomKA7HBYqGL1hU3VkLtXaf/38nu4C2NklLMRlQkIHRO+BDr2p7OOli
         WWrrhJDfQthfN9pvc1Q1m7zdtwqM6LfWzQqGqsYc=
Subject: Re: 5.15-rc3+ crash in fq-codel?
From:   Ben Greear <greearb@candelatech.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>
References: <dfa032f3-18f2-22a3-80bf-f0f570892478@candelatech.com>
 <b6e8155e-7fae-16b0-59f0-2a2e6f5142de@gmail.com>
 <00e495ba-391e-6ad8-94a2-930fbc826a37@candelatech.com>
 <296232ac-e7ed-6e3c-36b9-ed430a21f632@candelatech.com>
Organization: Candela Technologies
Message-ID: <7e87883e-42f5-2341-ab67-9f1614fb8b86@candelatech.com>
Date:   Tue, 28 Sep 2021 15:00:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <296232ac-e7ed-6e3c-36b9-ed430a21f632@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-MDID: 1632866453-3vV6xWFC60mU
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/27/21 5:16 PM, Ben Greear wrote:
> On 9/27/21 5:04 PM, Ben Greear wrote:
>> On 9/27/21 4:49 PM, Eric Dumazet wrote:
>>>
>>>
>>> On 9/27/21 4:30 PM, Ben Greear wrote:
>>>> Hello,
>>>>
>>>> In a hacked upon kernel, I'm getting crashes in fq-codel when doing bi-directional
>>>> pktgen traffic on top of mac-vlans.  Unfortunately for me, I've made big changes to
>>>> pktgen so I cannot easily run this test on stock kernels, and there is some chance
>>>> some of my hackings have caused this issue.
>>>>
>>>> But, in case others have seen similar, please let me know.  I shall go digging
>>>> in the meantime...
>>>>
>>>> Looks to me like 'skb' is NULL in line 120 below.
>>>
>>>
>>> pktgen must not be used in a mode where a single skb
>>> is cloned and reused, if packet needs to be stored in a qdisc.
>>>
>>> qdisc of all sorts assume skb->next/prev can be used as
>>> anchor in their list.
>>>
>>> If the same skb is queued multiple times, lists are corrupted.
>>>
>>> Please double check your clone_skb pktgen setup.
>>>
>>> I thought we had IFF_TX_SKB_SHARING for this, and that macvlan was properly clearing this bit.
>>
>> My pktgen config was not using any duplicated queueing in this case.
>>
>> I changed to pfifo fast and so far it is stable for ~10 minutes, where before it would crash
>> within a minute.  I'll let it bake overnight....
> 
> Still running stable.  I also notice we have been using fq-codel for a while and haven't noticed
> this problem (next most recent kernel we might have run similar test on would be 5.13-ish).
> 
> I'll duplicate this test on our older kernels tomorrow to see if it looks like a regression or
> if we just haven't actually done this exact test in a while...

We can reproduce this crash as far back as 5.4 using fq-codel, with our pktgen driving mac-vlans.
We did not try any kernels older than 5.4.
We cannot reproduce with pfifo on 5.15-rc3 on an overnight run.
We cannot produce with user-space UDP traffic on any kernel/qdisc combination.
Our pktgen is configured for multi-skb of 0 (no multiple submits of the same skb)

While looking briefly at fq-codel, I didn't notice any locking in the code that crashed.
Any chance that it makes assumptions that would be incorrect with pktgen running multiple
threads (one thread per mac-vlan) on top of a single qdisc belonging to the underlying NIC?

Thanks,
Ben

