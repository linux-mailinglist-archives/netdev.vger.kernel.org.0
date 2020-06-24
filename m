Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31DA2207CD2
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 22:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406318AbgFXUVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 16:21:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:17213 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406285AbgFXUVg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 16:21:36 -0400
IronPort-SDR: 9WyqO3iZN8hNkjrPF+//qiXHN1prd56vjtXpJcRSWg6ZeyBOeRHCTOBe317BJZbZbY+Zo3eZ5v
 2WRllU0uK9/w==
X-IronPort-AV: E=McAfee;i="6000,8403,9662"; a="142846028"
X-IronPort-AV: E=Sophos;i="5.75,276,1589266800"; 
   d="scan'208";a="142846028"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2020 13:21:35 -0700
IronPort-SDR: nyi3VoYg7dCSdb0H3gIhvLtz5ubgcooE5N1bJPGvs3LMknHH0CFpQA+LKhWXKMV8igJ1THSJDU
 gyXOGgzbsuyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,276,1589266800"; 
   d="scan'208";a="265168790"
Received: from samudral-mobl.amr.corp.intel.com (HELO [10.251.3.18]) ([10.251.3.18])
  by fmsmga008.fm.intel.com with ESMTP; 24 Jun 2020 13:21:35 -0700
Subject: Re: ADQ - comparison to aRFS, clarifications on NAPI ID, binding with
 busy-polling
To:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Kiran Patil <kiran.patil@intel.com>
Cc:     Alexander Duyck <alexander.h.duyck@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Tom Herbert <tom@herbertland.com>, netdev@vger.kernel.org
References: <e13faf29-5db3-91a2-4a95-c2cd8c2d15fe@mellanox.com>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Message-ID: <807a300e-47aa-dba3-7d6d-e14422a0d869@intel.com>
Date:   Wed, 24 Jun 2020 13:21:31 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <e13faf29-5db3-91a2-4a95-c2cd8c2d15fe@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/17/2020 6:15 AM, Maxim Mikityanskiy wrote:
> Hi,
> 
> I discovered Intel ADQ feature [1] that allows to boost performance by 
> picking dedicated queues for application traffic. We did some research, 
> and I got some level of understanding how it works, but I have some 
> questions, and I hope you could answer them.
> 
> 1. SO_INCOMING_NAPI_ID usage. In my understanding, every connection has 
> a key (sk_napi_id) that is unique to the NAPI where this connection is 
> handled, and the application uses that key to choose a handler thread 
> from the thread pool. If we have a one-to-one relationship between 
> application threads and NAPI IDs of connections, each application thread 
> will handle only traffic from a single NAPI. Is my understanding correct?

Yes. It is correct and recommended with the current implementation.

> 
> 1.1. I wonder how the application thread gets scheduled on the same core 
> that NAPI runs at. It currently only works with busy_poll, so when the 
> application initiates busy polling (calls epoll), does the Linux 
> scheduler move the thread to the right CPU? Do we have to have a strict 
> one-to-one relationship between threads and NAPIs, or can one thread 
> handle multiple NAPIs? When the data arrives, does the scheduler run the 
> application thread on the same CPU that NAPI ran on?

The app thread can do busypoll from any core and there is no requirement
that the scheduler needs to move the thread to a specific CPU.

If the NAPI processing happens via interrupts, the scheduler could move
the app thread to the same CPU that NAPI ran on.

> 
> 1.2. I see that SO_INCOMING_NAPI_ID is tightly coupled with busy_poll. 
> It is enabled only if CONFIG_NET_RX_BUSY_POLL is set. Is there a real 
> reason why it can't be used without busy_poll? In other words, if we 
> modify the kernel to drop this requirement, will the kernel still 
> schedule the application thread on the same CPU as NAPI when busy_poll 
> is not used?

It should be OK to remove this restriction, but requires enabling this 
in skb_mark_napi_id() and sk_mark_napi_id() too.

> 
> 2. Can you compare ADQ to aRFS+XPS? aRFS provides a way to steer traffic 
> to the application's CPU in an automatic fashion, and xps_rxqs can be 
> used to transmit from the corresponding queues. This setup doesn't need 
> manual configuration of TCs and is not limited to 4 applications. The 
> difference of ADQ is that (in my understanding) it moves the application 
> to the RX CPU, while aRFS steers the traffic to the RX queue handled my 
> the application's CPU. Is there any advantage of ADQ over aRFS, that I 
> failed to find?

aRFS+XPS ties app thread to a cpu, whereas ADQ ties app thread to a napi 
id which in turn ties to a queue(s)

ADQ also provides 2 levels of filtering compared to aRFS+XPS. The first
level of filtering selects a queue-set associated with the application
and the second level filter or RSS will select a queue within that queue
set associated with an app thread.

The current interface to configure ADQ limits us to support upto 16
application specific queue sets(TC_MAX_QUEUE)


> 
> 3. At [1], you mention that ADQ can be used to create separate RSS sets. 
>   Could you elaborate about the API used? Does the tc mqprio 
> configuration also affect RSS? Can it be turned on/off?

Yes. tc mqprio allows to create queue-sets per application and the
driver configures RSS per queue-set.

> 
> 4. How is tc flower used in context of ADQ? Does the user need to 
> reflect the configuration in both mqprio qdisc (for TX) and tc flower 
> (for RX)? It looks like tc flower maps incoming traffic to TCs, but what 
> is the mechanism of mapping TCs to RX queues?

tc mqprio is used to map TCs to RX queues

tc flower is used to configure the first level of filter to redirect
packets to a queue set associated with an application.

> 
> I really hope you will be able to shed more light on this feature to 
> increase my awareness on how to use it and to compare it with aRFS.

Hope this helps and we will go over in more detail in our netdev session.

> 
> Thanks,
> Max
> 
> [1]: 
> https://netdevconf.info/0x14/session.html?talk-ADQ-for-system-level-network-io-performance-improvements 
> 
