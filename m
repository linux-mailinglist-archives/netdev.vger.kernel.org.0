Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAFE2100F4
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 02:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgGAAXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 20:23:37 -0400
Received: from mga14.intel.com ([192.55.52.115]:29056 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgGAAXh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 20:23:37 -0400
IronPort-SDR: HI6dHNhhyJa6Im1B7hOpxnNoAQzZecdJmM3u0h53Zo/+1BTlHS9ULZS3+3i4OkbxKHHGESoebO
 kLu9R+C1WKNw==
X-IronPort-AV: E=McAfee;i="6000,8403,9668"; a="145492574"
X-IronPort-AV: E=Sophos;i="5.75,298,1589266800"; 
   d="scan'208";a="145492574"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2020 17:23:28 -0700
IronPort-SDR: 3YEcXvcgzhdBZ18cVHzBmEK5+85Oohp+ALaDy7WV50RSu+eMW5gbM63XevMSG27NG5oJSkISPo
 3KEPT9L7XOvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,298,1589266800"; 
   d="scan'208";a="355942861"
Received: from samudral-mobl.amr.corp.intel.com (HELO [10.212.255.238]) ([10.212.255.238])
  by orsmga001.jf.intel.com with ESMTP; 30 Jun 2020 17:23:27 -0700
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: Re: ADQ - comparison to aRFS, clarifications on NAPI ID, binding with
 busy-polling
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Amritha Nambiar <amritha.nambiar@intel.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Tom Herbert <tom@herbertland.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <e13faf29-5db3-91a2-4a95-c2cd8c2d15fe@mellanox.com>
 <807a300e-47aa-dba3-7d6d-e14422a0d869@intel.com>
 <AM6PR05MB5974D512D3205C247B07D0C7D1930@AM6PR05MB5974.eurprd05.prod.outlook.com>
Message-ID: <6ca520df-2668-992a-2717-c0501f1d2a89@intel.com>
Date:   Tue, 30 Jun 2020 17:23:27 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <AM6PR05MB5974D512D3205C247B07D0C7D1930@AM6PR05MB5974.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/26/2020 5:48 AM, Maxim Mikityanskiy wrote:
> Thanks a lot for your reply! It was really helpful. I have a few
> comments, please see below.
> 
> On 2020-06-24 23:21, Samudrala, Sridhar wrote:
>>
>>
>> On 6/17/2020 6:15 AM, Maxim Mikityanskiy wrote:
>>> Hi,
>>>
>>> I discovered Intel ADQ feature [1] that allows to boost performance by
>>> picking dedicated queues for application traffic. We did some
>>> research, and I got some level of understanding how it works, but I
>>> have some questions, and I hope you could answer them.
>>>
>>> 1. SO_INCOMING_NAPI_ID usage. In my understanding, every connection
>>> has a key (sk_napi_id) that is unique to the NAPI where this
>>> connection is handled, and the application uses that key to choose a
>>> handler thread from the thread pool. If we have a one-to-one
>>> relationship between application threads and NAPI IDs of connections,
>>> each application thread will handle only traffic from a single NAPI.
>>> Is my understanding correct?
>>
>> Yes. It is correct and recommended with the current implementation.
>>
>>>
>>> 1.1. I wonder how the application thread gets scheduled on the same
>>> core that NAPI runs at. It currently only works with busy_poll, so
>>> when the application initiates busy polling (calls epoll), does the
>>> Linux scheduler move the thread to the right CPU? Do we have to have a
>>> strict one-to-one relationship between threads and NAPIs, or can one
>>> thread handle multiple NAPIs? When the data arrives, does the
>>> scheduler run the application thread on the same CPU that NAPI ran on?
>>
>> The app thread can do busypoll from any core and there is no requirement
>> that the scheduler needs to move the thread to a specific CPU.
>>
>> If the NAPI processing happens via interrupts, the scheduler could move
>> the app thread to the same CPU that NAPI ran on.
>>
>>>
>>> 1.2. I see that SO_INCOMING_NAPI_ID is tightly coupled with busy_poll.
>>> It is enabled only if CONFIG_NET_RX_BUSY_POLL is set. Is there a real
>>> reason why it can't be used without busy_poll? In other words, if we
>>> modify the kernel to drop this requirement, will the kernel still
>>> schedule the application thread on the same CPU as NAPI when busy_poll
>>> is not used?
>>
>> It should be OK to remove this restriction, but requires enabling this
>> in skb_mark_napi_id() and sk_mark_napi_id() too.
>>
>>>
>>> 2. Can you compare ADQ to aRFS+XPS? aRFS provides a way to steer
>>> traffic to the application's CPU in an automatic fashion, and xps_rxqs
>>> can be used to transmit from the corresponding queues. This setup
>>> doesn't need manual configuration of TCs and is not limited to 4
>>> applications. The difference of ADQ is that (in my understanding) it
>>> moves the application to the RX CPU, while aRFS steers the traffic to
>>> the RX queue handled my the application's CPU. Is there any advantage
>>> of ADQ over aRFS, that I failed to find?
>>
>> aRFS+XPS ties app thread to a cpu,
> 
> Well, not exactly. To pin the app thread to a CPU, one uses
> taskset/sched_setaffinity, while aRFS+XPS pick a queue that corresponds
> to that CPU.

Yes. I should have said XPS-cpus ties app thread to a cpu and aRFS maps 
that cpu to rx queue.

> 
>> whereas ADQ ties app thread to a napi
>> id which in turn ties to a queue(s)
> 
> So, basically, both technologies result in making NAPI and the app run
> on the same CPU. The difference that I see is that ADQ forces NAPI
> processing (in busy polling) on the app's CPU, while aRFS steers the
> traffic to a queue, whose NAPI runs on the app's CPU. The effect is the
> same, but ADQ requires busy polling. Is my understanding correct?

'busy polling' is not a requirement. It is possible to use ADQ receive 
filters with XPS based on rx queues to make NAPI and the app run on the 
same CPU without busy polling.

> 
>> ADQ also provides 2 levels of filtering compared to aRFS+XPS. The first
>> level of filtering selects a queue-set associated with the application
>> and the second level filter or RSS will select a queue within that queue
>> set associated with an app thread.
> 
> This difference looks important. So, ADQ reserves a dedicated set of
> queues solely for the application use.
> 
>> The current interface to configure ADQ limits us to support upto 16
>> application specific queue sets(TC_MAX_QUEUE)
> 
>   From the commit message:
> 
> https://patchwork.ozlabs.org/project/netdev/patch/20180214174539.11392-5-jeffrey.t.kirsher@intel.com/
> 
> I got that i40e supports up to 4 groups. Has this limitation been
> lifted, or are you saying that 16 is the limitation of mqprio, while the
> driver may support fewer? Or is it different for different Intel drivers?

Yes. That patch is enabling support for ADQ in a VF and it is currently 
limited to 4 queue groups. But 16 is tc mqprio interface limitation.

> 
>>
>>
>>>
>>> 3. At [1], you mention that ADQ can be used to create separate RSS
>>> sets.   Could you elaborate about the API used? Does the tc mqprio
>>> configuration also affect RSS? Can it be turned on/off?
>>
>> Yes. tc mqprio allows to create queue-sets per application and the
>> driver configures RSS per queue-set.
>>
>>>
>>> 4. How is tc flower used in context of ADQ? Does the user need to
>>> reflect the configuration in both mqprio qdisc (for TX) and tc flower
>>> (for RX)? It looks like tc flower maps incoming traffic to TCs, but
>>> what is the mechanism of mapping TCs to RX queues?
>>
>> tc mqprio is used to map TCs to RX queues
> 
> OK, I got how the configuration works now, thanks! Though I'm not sure
> mqprio is the best API to configure the RX side. I thought it's supposed
> to configure the TX queues. Looks more like a hack to me.
> 
> Ethtool RSS context API (look for "context" in man ethtool) seems more
> appropriate for the RX side for this purpose.

Thanks, we will explore if ethtool will work for us. We went with mqprio 
so that we can configure both TX/RX queue-sets together rather than 
splitting the configuration into 2 steps.

> 
> Thanks,
> Max
> 
>> tc flower is used to configure the first level of filter to redirect
>> packets to a queue set associated with an application.
>>
>>>
>>> I really hope you will be able to shed more light on this feature to
>>> increase my awareness on how to use it and to compare it with aRFS.
>>
>> Hope this helps and we will go over in more detail in our netdev session.
>>
>>>
>>> Thanks,
>>> Max
>>>
>>> [1]:
>>> https://netdevconf.info/0x14/session.html?talk-ADQ-for-system-level-network-io-performance-improvements
>>>
> 
