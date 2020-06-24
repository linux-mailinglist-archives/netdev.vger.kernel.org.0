Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7A6207B78
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 20:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406022AbgFXSZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 14:25:46 -0400
Received: from mga03.intel.com ([134.134.136.65]:15565 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404995AbgFXSZp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 14:25:45 -0400
IronPort-SDR: sY2SPFWsU1li9D4ATw/azyxV2w5JifVffWDtnpuu1Blcy2MSon9pCyHwpiCg0ygpd3c8XV4nm+
 H4acv69iWWfA==
X-IronPort-AV: E=McAfee;i="6000,8403,9662"; a="144641491"
X-IronPort-AV: E=Sophos;i="5.75,276,1589266800"; 
   d="scan'208";a="144641491"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2020 11:25:44 -0700
IronPort-SDR: ZdQU+LWo0gmEc/YdHfeoQNY51E2a2WsnrpF9wq/yygbpB09Amb6Xfi0RWmKGvY9SbvfUykxJnm
 Py4ABF8q0JYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,276,1589266800"; 
   d="scan'208";a="263709517"
Received: from vsave-mobl.amr.corp.intel.com (HELO [10.251.3.18]) ([10.251.3.18])
  by fmsmga007.fm.intel.com with ESMTP; 24 Jun 2020 11:25:44 -0700
Subject: Re: [PATCH] fs/epoll: Enable non-blocking busypoll with epoll timeout
 of 0
To:     Eric Dumazet <eric.dumazet@gmail.com>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        "davem@davemloft.net" <davem@davemloft.net>
References: <1592590409-35439-1-git-send-email-sridhar.samudrala@intel.com>
 <de6bf72d-d4fd-9a62-c082-c82179d1f4fe@intel.com>
 <28225710-0e85-f937-396d-24ce839efe09@gmail.com>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Message-ID: <d609306c-1c85-1dd7-e15b-378500895f59@intel.com>
Date:   Wed, 24 Jun 2020 11:25:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <28225710-0e85-f937-396d-24ce839efe09@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/24/2020 9:49 AM, Eric Dumazet wrote:
> 
> 
> On 6/24/20 9:32 AM, Samudrala, Sridhar wrote:
>> Adding Dave, Eric for review and see if we can get this in via net-next
>> as this is mainly useful for networking workloads doing busypoll.
>>
>> Thanks
>> Sridhar
>>
>> On 6/19/2020 11:13 AM, Sridhar Samudrala wrote:
>>> This patch triggers non-blocking busy poll when busy_poll is enabled and
>>> epoll is called with a timeout of 0 and is associated with a napi_id.
>>> This enables an app thread to go through napi poll routine once by calling
>>> epoll with a 0 timeout.
>>>
>>> poll/select with a 0 timeout behave in a similar manner.
>>>
>>> Signed-off-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
>>> ---
>>>    fs/eventpoll.c | 13 +++++++++++++
>>>    1 file changed, 13 insertions(+)
>>>
>>> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
>>> index 12eebcdea9c8..5f55078d6381 100644
>>> --- a/fs/eventpoll.c
>>> +++ b/fs/eventpoll.c
>>> @@ -1847,6 +1847,19 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
>>>            eavail = ep_events_available(ep);
>>>            write_unlock_irq(&ep->lock);
>>>    +        /*
>>> +         * Trigger non-blocking busy poll if timeout is 0 and there are
>>> +         * no events available. Passing timed_out(1) to ep_busy_loop
>>> +         * will make sure that busy polling is triggered only once and
>>> +         * only if sysctl.net.core.busy_poll is set to non-zero value.
>>> +         */
>>> +        if (!eavail) {
> 
> Maybe avoid all this stuff for the typical case of busy poll being not used ?
> 
>              if (!evail && net_busy_loop_on)) {

Sure. will submit a v2 with this change.


> 
>>> +            ep_busy_loop(ep, timed_out);
> 
> 
>>> +            write_lock_irq(&ep->lock);
>>> +            eavail = ep_events_available(ep);
>>> +            write_unlock_irq(&ep->lock);
>>> +        }
>>> +
>>>            goto send_events;
>>>        }
>>>   
